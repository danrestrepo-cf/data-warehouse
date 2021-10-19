import copy
from typing import List, Optional

from lib.metadata_core.data_warehouse_metadata import (DataWarehouseMetadata,
                                                       SchemaMetadata,
                                                       TableMetadata,
                                                       ColumnMetadata,
                                                       ForeignKeyMetadata,
                                                       ETLMetadata,
                                                       ForeignColumnPath,
                                                       InvalidMetadataKeyException,
                                                       ETLDataSource,
                                                       ETLInputType,
                                                       ETLOutputType)
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict


def build_staging_octane_metadata(column_metadata: List[dict], foreign_key_metadata: List[dict]) -> DataWarehouseMetadata:
    tables_dict = {}
    for row in column_metadata:
        if row['table_name'] not in tables_dict:
            tables_dict[row['table_name']] = {
                'name': row['table_name'],
                'primary_key': [],
                'foreign_keys': {},
                'columns': {}
            }
        if row['is_primary_key'] == 1:
            tables_dict[row['table_name']]['primary_key'].append(row['column_name'])
        tables_dict[row['table_name']]['columns'][row['column_name']] = {
            'data_type': map_data_type(row['column_type'])
        }

    for row in foreign_key_metadata:
        tables_dict[row['table_name']]['foreign_keys'][row['constraint_name']] = {
            'columns': [row['column_name']],
            'references': {
                'columns': [row['referenced_column_name']],
                'schema': 'staging_octane',
                'table': row['referenced_table_name']
            }
        }

    metadata_dict = {
        'name': 'edw',
        'databases': [
            {
                'name': 'staging',
                'schemas': [
                    {
                        'name': 'staging_octane',
                        'tables': tables_dict.values()
                    }
                ]
            }
        ]
    }
    return construct_data_warehouse_metadata_from_dict(metadata_dict)


def map_data_type(data_type: str) -> str:
    upper_data_type = data_type.upper()
    if upper_data_type == 'DATE' or upper_data_type == 'TIME' or upper_data_type == 'TEXT' or upper_data_type.startswith('VARCHAR('):
        return upper_data_type
    elif upper_data_type == 'DATETIME':
        return 'TIMESTAMP'
    elif upper_data_type.startswith('TINYINT('):
        return 'SMALLINT'
    elif upper_data_type.startswith('INT('):
        return 'INTEGER'
    elif upper_data_type.startswith('BIGINT('):
        return 'BIGINT'
    elif upper_data_type.startswith('BIT('):
        return 'BOOLEAN'
    elif upper_data_type.startswith('DECIMAL('):
        return f'NUMERIC{upper_data_type[7:]}'
    else:
        raise ValueError(f'Unable to map data type {upper_data_type}')


def add_history_octane_metadata(metadata: DataWarehouseMetadata, table_to_process_map: dict) -> DataWarehouseMetadata:
    try:
        staging_octane_schema = metadata.get_database('staging').get_schema('staging_octane')
    except InvalidMetadataKeyException:
        raise ValueError('Schema "staging_octane" in database "staging" must be present in order to derive history_octane metadata')
    metadata_with_history_octane = copy.deepcopy(metadata)
    history_octane_schema = SchemaMetadata('history_octane')
    metadata_with_history_octane.get_database('staging').add_schema(history_octane_schema)
    for staging_table in staging_octane_schema.tables:
        history_table = TableMetadata(name=staging_table.name, primary_source_table=staging_table.path)
        history_octane_schema.add_table(history_table)
        history_table.primary_key = copy.copy(staging_table.primary_key)
        version_column_name = get_version_column_name(staging_table)
        if version_column_name is not None:
            history_table.primary_key.append(version_column_name)
        for staging_column in staging_table.columns:
            history_column = ColumnMetadata(name=staging_column.name, data_type=staging_column.data_type)
            history_column.source_field = ForeignColumnPath(fk_steps=[], column_name=staging_column.name)
            history_table.add_column(history_column)
        history_table.add_column(ColumnMetadata(name='data_source_updated_datetime', data_type='TIMESTAMPTZ'))
        history_table.add_column(ColumnMetadata(name='data_source_deleted_flag', data_type='BOOLEAN'))
        for staging_fk in staging_table.foreign_keys:
            foreign_table_path = staging_fk.table
            foreign_table_path.schema = 'history_octane'
            history_fk = ForeignKeyMetadata(
                name=staging_fk.name,
                table=foreign_table_path,
                native_columns=copy.copy(staging_fk.native_columns),
                foreign_columns=copy.copy(staging_fk.foreign_columns)
            )
            history_table.add_foreign_key(history_fk)
        history_etl = ETLMetadata(
            process_name=table_to_process_map[staging_table.name]['process'],
            hardcoded_data_source=ETLDataSource.OCTANE,
            input_type=ETLInputType.TABLE,
            output_type=ETLOutputType.INSERT,
            json_output_field=staging_table.primary_key[0],
            truncate_table=False,
            input_sql=generate_table_input_sql(staging_table)
        )
        history_table.add_etl(history_etl)
        for process in table_to_process_map[staging_table.name]['next_processes']:
            history_table.next_etls.append(process)
    return metadata_with_history_octane


def is_type_table(table: TableMetadata) -> str:
    return table.name.endswith('_type') and \
           table.primary_key == ['code']


def get_table_column_prefix(table: TableMetadata) -> Optional[str]:
    if is_type_table(table):
        return None
    else:
        return table.primary_key[0].split('_')[0]


def get_version_column_name(table: TableMetadata) -> Optional[str]:
    column_prefix = get_table_column_prefix(table)
    if column_prefix is None:
        return None
    else:
        probable_version_column_name = f'{column_prefix}_version'
        try:
            table.get_column(probable_version_column_name)  # confirm the version column actually exists
            return probable_version_column_name
        except InvalidMetadataKeyException:
            return None


def generate_table_input_sql(table_metadata: TableMetadata) -> str:
    table_name = table_metadata.name
    staging_select_columns = generate_select_columns_string('staging_table', table_metadata.columns, increment_version=False)
    table_input_sql = f'--finding records to insert into history_octane.{table_name}\n' + \
                      f'SELECT {staging_select_columns}\n' + \
                      f'     , FALSE AS data_source_deleted_flag\n' + \
                      f'     , NOW( ) AS data_source_updated_datetime\n' + \
                      f'FROM staging_octane.{table_name} staging_table\n'

    if table_name.endswith('_type'):
        table_input_sql += f'LEFT JOIN history_octane.{table_name} history_table\n' + \
                           f'          ON staging_table.code = history_table.code\n' \
                           f'              AND staging_table.value = history_table.value\n' + \
                           f'WHERE history_table.code IS NULL;'
    else:
        primary_key_column = table_metadata.primary_key[0]
        octane_table_column_prefix = primary_key_column.split('_')[0]
        version_column = f'{octane_table_column_prefix}_version'
        history_select_columns = generate_select_columns_string('history_table', table_metadata.columns, increment_version=True)
        table_input_sql += f'LEFT JOIN history_octane.{table_name} history_table\n' + \
                           f'          ON staging_table.{primary_key_column} = history_table.{primary_key_column}\n' \
                           f'              AND staging_table.{version_column} = history_table.{version_column}\n' + \
                           f'WHERE history_table.{primary_key_column} IS NULL\n' + \
                           f'UNION ALL\n' + \
                           f'SELECT {history_select_columns}\n' + \
                           f'     , TRUE AS data_source_deleted_flag\n' + \
                           f'     , NOW( ) AS data_source_updated_datetime\n' + \
                           f'FROM history_octane.{table_name} history_table\n' + \
                           f'LEFT JOIN staging_octane.{table_name} staging_table\n' + \
                           f'          ON staging_table.{primary_key_column} = history_table.{primary_key_column}\n' + \
                           f'WHERE staging_table.{primary_key_column} IS NULL\n' + \
                           f'  AND NOT EXISTS(\n' + \
                           f'    SELECT 1\n' + \
                           f'    FROM history_octane.{table_name} deleted_records\n' + \
                           f'    WHERE deleted_records.{primary_key_column} = history_table.{primary_key_column}\n' + \
                           f'      AND deleted_records.data_source_deleted_flag = TRUE\n' + \
                           f'    );'
    return table_input_sql


def generate_select_columns_string(table_prefix: str, columns: List[ColumnMetadata], increment_version: bool) -> str:
    select_columns = []
    for col in columns:
        if col.name.endswith('_version') and increment_version:
            select_columns.append(f'{table_prefix}.{col.name} + 1')
        elif col.name not in ['data_source_updated_datetime', 'data_source_deleted_flag']:
            select_columns.append(f'{table_prefix}.{col.name}')
    return '\n     , '.join(select_columns)
