"""A set of functions used to construct a DataWarehouseMetadata object by synthesizing information_schema data from Octane and EDW.

The resulting DataWarehouseMetadata object will only contain metadata pertaining
to the staging_octane and history_octane schemas in EDW, as those are the only two
schemas whose metadata is directly derivable from Octane's information schema.

Public Functions:
- build_staging_octane_metadata
- generate_history_octane_metadata
- add_deleted_tables_and_columns_to_history_octane_metadata
"""

import copy
from typing import List, Optional
import re

from lib.metadata_core.data_warehouse_metadata import (DataWarehouseMetadata,
                                                       SchemaMetadata,
                                                       TableMetadata,
                                                       ColumnMetadata,
                                                       ForeignKeyMetadata,
                                                       ETLMetadata,
                                                       ColumnSourceComponents,
                                                       SourceForeignKeyPath,
                                                       InvalidMetadataKeyException,
                                                       ETLInputType,
                                                       ETLOutputType)
from lib.metadata_core.metadata_yaml_translator import construct_data_warehouse_metadata_from_dict


def build_staging_octane_metadata(column_metadata: List[dict], foreign_key_metadata: List[dict]) -> DataWarehouseMetadata:
    """Construct a DataWarehouseMetadata object containing all table/column metadata for EDW's staging.staging_octane schema.

    :param column_metadata: a list of dicts with the below structure that contains Octane column metadata:
        {
            'table_name': <table_name>,
            'column_name': <column_name>,
            'column_type': <column_type>,
            'is_primary_key': <is_primary_key> (either 0 or 1, because MySQL doesn't have a native boolean type)
        }
    :param foreign_key_metadata: a list of dicts with the below structure that contains Octane foreign key metadata:
        {
            'table_name': <table_name>,
            'column_name': <column_name>,
            'constraint_name': <constraint_name>,
            'referenced_table_name': <referenced_table_name>,
            'referenced_column_name': <referenced_column_name>
        }
    """
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
            'data_type': map_msql_data_type(row['column_type'])
        }

    for row in foreign_key_metadata:
        if row['table_name'] in tables_dict:
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


def map_msql_data_type(data_type: str) -> str:
    """Map a MySQL data type to the equivalent PostgreSQL data type."""
    upper_data_type = data_type.upper()
    if upper_data_type in ('DATE', 'TIME', 'TEXT', 'TIMESTAMP') or upper_data_type.startswith('VARCHAR('):
        return upper_data_type
    elif upper_data_type == 'DATETIME':
        return 'TIMESTAMP'
    elif upper_data_type == 'BLOB':
        return 'BYTEA'
    elif upper_data_type.startswith('TINYINT('):
        return 'SMALLINT'
    elif upper_data_type.startswith('SMALLINT('):
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


def generate_history_octane_metadata(metadata: DataWarehouseMetadata, table_to_process_map: dict,
                                     current_max_process_number: int) -> DataWarehouseMetadata:
    """Generate a new DataWarehouseMetadata object with added history_octane metadata given existing staging_octane metadata.

    :param metadata: a DataWarehouseMetadata object that already contains staging_octane metadata within it.
    :param table_to_process_map: a dictionary with the below structure that is used to map a history_octane table with
    related ETL process metadata:
        {
            <table_name1>: {
                'process': <process_name>,
                'next_processes': [
                    <process1>,
                    <process2>,
                    ...
                ]
            },
            <table_name2>: {...},
            ...
        }
    :param current_max_process_number: the largest SP number for a staging_octane ->
    history_octane ETL process that currently exists in EDW. This is used to
    generate new SP numbers for any tables that do not appear in the table_to_process map.
    """
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
            history_column.source = ColumnSourceComponents(calculation_string=None, foreign_key_paths=[
                SourceForeignKeyPath(fk_steps=[], column_name=staging_column.name)])
            history_table.add_column(history_column)
        history_table.add_column(ColumnMetadata(name='data_source_updated_datetime', data_type='TIMESTAMPTZ'))
        history_table.add_column(ColumnMetadata(name='data_source_deleted_flag', data_type='BOOLEAN'))
        history_table.add_column(ColumnMetadata(name='etl_batch_id', data_type='TEXT'))
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
        if staging_table.name in table_to_process_map:
            process_name = table_to_process_map[staging_table.name]['process']
            next_processes = table_to_process_map[staging_table.name]['next_processes']
        else:
            # generate an SP number for the table if one doesn't already exist
            # this process is TEMPORARY and will be replaced once the SP naming
            # system has been overhauled and all ETLs are autogenerated.
            process_name = f'SP-{current_max_process_number + 1}'
            next_processes = []
            current_max_process_number += 1
        if len(history_table.columns) < 100:
            container_memory = 2048
        else:
            container_memory = 4096
        history_etl = ETLMetadata(
            process_name=process_name,
            hardcoded_data_source=None,
            input_type=ETLInputType.TABLE,
            output_type=ETLOutputType.INSERT,
            json_output_field=staging_table.primary_key[0],
            truncate_table=False,
            container_memory=container_memory,
            input_sql=generate_history_octane_table_input_sql(staging_table)
        )
        history_table.add_etl(history_etl)
        for process in next_processes:
            history_table.next_etls.append(process)
    return metadata_with_history_octane

def add_deleted_tables_and_columns_to_history_octane_metadata(octane_metadata: DataWarehouseMetadata,
                                                              current_yaml_metadata: DataWarehouseMetadata) -> DataWarehouseMetadata:
    """Generate a new DataWarehouseMetadata object with previously-deleted tables/columns incorporated into history_octane.

    This function is used to cross-reference the current history_octane metadata with the metadata pulled from Octane's
    information_schema in order to include tables/columns deleted from Octane's database to the autogenerated metadata
    resulting from this process.

    This is done because the DataWarehouseMetadata object generated from Octane's DB can only contain tables/columns that
    still exist in Octane. However, EDW's history_octane schema contains tables/columns that no longer
    exist in Octane but should still be included in the generated metadata.

    :param octane_metadata: a DataWarehouseMetadata object that already contains history_octane metadata within it.
    :param current_yaml_metadata:  a DataWarehouseMetadata object that already contains history_octane metadata within it.
    """

    # verify the staging database has a schema named history_octane in the DataWarehouseMetadata object read from the yaml files
    try:
        current_history_octane_metadata = current_yaml_metadata.get_database('staging').get_schema('history_octane')
    except InvalidMetadataKeyException:
        raise ValueError('Schema "history_octane" in database "staging" must be present in parameter "current_history_octane_metadata" in order to incorporate deleted tables and columns')

    # verify the staging database has a schema named history_octane in the DataWarehouse Metadata created from octane's database
    try:
        octane_metadata.get_database('staging').get_schema('history_octane')
    except InvalidMetadataKeyException:
        raise ValueError('Schema "history_octane" in database "staging" must be present in parameter "octane_metadata" in  order to incorporate deleted tables and columns')

    # python passes by reference so use the copy library to create a copy of objects so we can modify them without
    # causing side effects.
    import copy
    output_database_metadata = copy.deepcopy(octane_metadata)
    print(f"output_database_metadata: {output_database_metadata}")

    # this SchemaMetadata object contains only history_octane metadata read from yamls.
    # it will be modified to remove anything needed and then added to the DataWarehouseMetadata object to create the
    # full set of data needed to write a new set of yamls.
    history_octane_metadata = copy.deepcopy(current_history_octane_metadata)
    print("Now checking to see if tables/fields from history_octane exist in staging_octane...")
    for current_metadata_table in history_octane_metadata.tables:
        print(f"    Now processing table: history_octane.{current_metadata_table.name}")

        # detect if table is deleted from octane
        if not octane_metadata.get_database('staging').get_schema('staging_octane').contains_table(current_metadata_table.name):
            # table deleted (not found in octane's metadata)
            print(f"        Table not found in Octane's metadata. Removing source table and ETLs.")
            # remove the table source and next etls
            current_metadata_table.primary_source_table = None
            current_metadata_table.next_etls = None

            # remove all ETLs in the current table
            for etl in current_metadata_table.etls:
                current_metadata_table.remove_etl(etl.process_name)

        # detect if field is deleted from staging_octane
        for current_metadata_table_column in current_metadata_table.columns:
            if not octane_metadata.get_database('staging').get_schema('staging_octane').get_table(current_metadata_table.name).get_column(current_metadata_table_column.name):
                # column deleted (not found on octane's metadata)
                print(f"            Column {current_metadata_table_column.name} does not exist in staging_octane schema! Removing source and update_flag.")
                current_metadata_table_column.source = None
                current_metadata_table_column.update_flag = False

        # add any new fields from octane's history_octane schema to the output
        for octane_metadata_table in octane_metadata.get_database('staging').get_schema('history_octane').tables:
            for octane_metadata_table_column in octane_metadata_table.columns:
                if not current_metadata_table.contains_column(octane_metadata_table_column.name):
                    current_metadata_table.add_column(octane_metadata_table_column)

    output_database_metadata.get_database('staging').remove_schema('history_octane')
    output_database_metadata.get_database('staging').add_schema(history_octane_metadata)
    return output_database_metadata


def is_type_table(table: TableMetadata) -> str:
    """Determine whether or not the given table is an Octane type table."""
    return table.name.endswith('_type') and table.primary_key == ['code']


def is_id_sequence_table(table: TableMetadata) -> str:
    """Determine whether or not the given table is an Octane sequence id table."""
    return table.name.endswith('_id_sequence') and table.primary_key[0].endswith('_id')


def derive_history_table_primary_key_from_scratch(table: TableMetadata) -> List[str]:
    """Determine the most likely primary key column in a history_octane table with no external reference.

    Primary key is assumed to be "<table_prefix>_pid" (e.g. prp_pid, d_pid, etc), unless the table
    is a type table, in which case the primary key is always "code".
    """
    for column in table.columns:
        pid_prefix_match = re.match(r'([a-z0-9]+)_pid', column.name)
        if pid_prefix_match:
            primary_key = [pid_prefix_match.group(0)]
            probable_version_column_name = f'{pid_prefix_match.group(1)}_version'
            if table.contains_column(probable_version_column_name):
                primary_key.append(probable_version_column_name)
            return primary_key
        elif column.name == 'code':
            return ['code']
    return []  # primary key could not be derived


def get_table_column_prefix(table: TableMetadata) -> Optional[str]:
    """Figure out an Octane table's column prefix.

    Return None if the table is a type table, since type tables do not use column prefixes.
    """
    if is_type_table(table):
        return None
    else:
        return table.primary_key[0].split('_')[0]


def get_version_column_name(table: TableMetadata) -> Optional[str]:
    """Figure out an Octane table's version column name

    Return None if the table is a type table or if the table has no column named "<table_prefix>_version".
    """
    column_prefix = get_table_column_prefix(table)
    if column_prefix is None:
        return None
    else:
        probable_version_column_name = f'{column_prefix}_version'
        if table.contains_column(probable_version_column_name):
            return probable_version_column_name
        else:
            return None


def generate_history_octane_table_input_sql(table: TableMetadata) -> str:
    """Generate an ETL SELECT query used in the ETL process that populates the given table.

    All staging_octane -> history_octane ETL queries start by selecting every column from the
    staging_octane table, while also adding two calculated fields unique to history_octane
    (data_source_deleted_flag and data_source_updated_datetime). Only records that haven't yet
    been inserted into the history_octane table are needed in the query result, so a left outer
    join to the history_octane table is used to filter the query to contain only *new* records.

    From there, the query template diverges based on the type of table:
    - type tables and id sequence tables queries have no further components
    - regular table queries perform an additional SELECT query that is UNIONed to the first
      in order to add new "deleted" versions of rows which exist in the history_octane table but
      which no longer exist in the staging_octane table.
    """
    # SELECT statement - new rows from staging_octane table
    staging_select_columns = generate_staging_to_history_select_columns_string('staging_table', table, columns_to_increment=[])
    table_input_sql = f'--finding records to insert into history_octane.{table.name}\n' + \
                      f'SELECT {staging_select_columns}\n' + \
                      f'     , FALSE AS data_source_deleted_flag\n' + \
                      f'     , NOW( ) AS data_source_updated_datetime\n' + \
                      f'FROM staging_octane.{table.name} staging_table\n'

    # LEFT JOIN to history_octane table to filter out rows that have already been copied over
    primary_key_column = table.primary_key[0]
    version_column = get_version_column_name(table)
    if is_type_table(table):
        join_columns = [column.name for column in table.columns]
    else:
        join_columns = [primary_key_column]
        if version_column is not None:
            join_columns.append(version_column)
    table_input_sql += f'LEFT JOIN history_octane.{table.name} history_table\n' + \
                       generate_staging_to_history_join_columns_string(join_columns) + '\n' + \
                       f'WHERE history_table.{primary_key_column} IS NULL'

    # UNION ALL SELECT statement - deleted rows from staging_octane table (regular table ETLs only)
    if not (is_type_table(table) or is_id_sequence_table(table)):
        history_select_columns = generate_staging_to_history_select_columns_string('history_table', table,
                                                                                   columns_to_increment=[version_column])
        table_input_sql += f'\n' + \
                           f'UNION ALL\n' + \
                           f'SELECT {history_select_columns}\n' + \
                           f'     , TRUE AS data_source_deleted_flag\n' + \
                           f'     , NOW( ) AS data_source_updated_datetime\n' + \
                           f'FROM history_octane.{table.name} history_table\n' + \
                           f'LEFT JOIN staging_octane.{table.name} staging_table\n' + \
                           generate_staging_to_history_join_columns_string([primary_key_column]) + '\n' + \
                           f'WHERE staging_table.{primary_key_column} IS NULL\n' + \
                           f'  AND NOT EXISTS(\n' + \
                           f'    SELECT 1\n' + \
                           f'    FROM history_octane.{table.name} deleted_records\n' + \
                           f'    WHERE deleted_records.{primary_key_column} = history_table.{primary_key_column}\n' + \
                           f'      AND deleted_records.data_source_deleted_flag = TRUE\n' + \
                           f'    )'
    # add Postgres-required final semicolon
    table_input_sql += ';'
    return table_input_sql


def generate_staging_to_history_select_columns_string(table_prefix: str, table: TableMetadata, columns_to_increment: List[str]) -> str:
    """Generate a formatted list of columns to go into a SELECT statement for a staging_octane -> history_octane ETL.

    :param table_prefix: a prefix string to prepend to each column in the list. In staging -> history
    ETL queries, this is usually either "staging_table" or "history_table".
    :param table: the table whose columns should be included in the resulting column list.
    :param columns_to_increment: a list of columns that should be incremented via the appending of
    the string " + 1" after the column name. Mainly used to add " + 1" to a regular Octane table's
    version column when selecting deleted rows in a regular table ETL.
    """
    select_columns = []
    for column in table.columns:
        if column.name in columns_to_increment:
            select_columns.append(f'{table_prefix}.{column.name} + 1')
        elif column.name not in ['data_source_updated_datetime', 'data_source_deleted_flag']:
            select_columns.append(f'{table_prefix}.{column.name}')
    return '\n     , '.join(select_columns)


def generate_staging_to_history_join_columns_string(columns: List[str], base_indent: int = 10) -> str:
    """Generate a full SQL join condition string for a staging_octane -> history_octane ETL given the list of columns on which to join.

    Since this function is only used in the context of staging_octane -> history_octane ETL
    query generation, only a single column list is needed. Every join condition will
    be of the form "staging_table.<column_name> = history_table.<column_name>".

    The base_indent defaults to 10 because that is the number of characters in the
    string "LEFT JOIN " (spaces included). This conforms to EDW formatting standards.
    """
    base_indent_str = base_indent * ' '
    join_columns_str = f'{base_indent_str}ON {generate_staging_to_history_join_column_string(columns[0])}'
    join_columns_str += ''.join([f'\n{base_indent_str}    AND {generate_staging_to_history_join_column_string(column)}'
                                 for column in columns[1:]])
    return join_columns_str


def generate_staging_to_history_join_column_string(column: str) -> str:
    """Generate a single join condition between a staging_octane column and its history_octane counterpart."""
    return f'staging_table.{column} = history_table.{column}'
