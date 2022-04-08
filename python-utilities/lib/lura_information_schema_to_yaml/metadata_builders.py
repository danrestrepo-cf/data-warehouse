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
                                                       StepFunctionMetadata,
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


def generate_history_octane_metadata(octane_metadata: DataWarehouseMetadata,
                                     current_yaml_metadata: DataWarehouseMetadata) -> DataWarehouseMetadata:
    """Generate a new DataWarehouseMetadata object with added history_octane metadata given existing staging_octane metadata.

    :param octane_metadata: a DataWarehouseMetadata object generated from Octane's information schema that already
    contains staging_octane metadata within it.
    :param current_yaml_metadata: a DataWarehouseMetadata object generated from EDW's existing YAML inventory
    """
    metadata_with_history_octane = copy.deepcopy(octane_metadata)
    try:
        staging_octane_schema = metadata_with_history_octane.get_database('staging').get_schema('staging_octane')
    except InvalidMetadataKeyException:
        raise ValueError(
            'Schema "staging_octane" in database "staging" must be present in octane-derived metadata order to derive '
            'history_octane metadata'
        )
    try:
        yaml_history_octane_metadata = current_yaml_metadata.get_database('staging').get_schema('history_octane')
    except InvalidMetadataKeyException:
        raise ValueError(
            'Schema "history_octane" in database "staging" must be present in current yaml metadata in order to derive '
            'history_octane metadata'
        )

    current_max_process_number = determine_max_process_number(yaml_history_octane_metadata)

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
            foreign_table_path = copy.copy(staging_fk.table)
            foreign_table_path.schema = 'history_octane'
            history_fk = ForeignKeyMetadata(
                name=staging_fk.name,
                table=foreign_table_path,
                native_columns=copy.copy(staging_fk.native_columns),
                foreign_columns=copy.copy(staging_fk.foreign_columns)
            )
            history_table.add_foreign_key(history_fk)
        if yaml_history_octane_metadata.contains_table(staging_table.name):
            # this code assumes every history table has exactly 1 SFN/ETL, and will need to change if that ever ceases to be true
            existing_step_function = yaml_history_octane_metadata.get_table(staging_table.name).step_functions[0]
            process_number = get_step_function_process_number(existing_step_function)
            next_step_functions = existing_step_function.etls[0].next_step_functions.copy()
        else:
            # generate an SP number for the table if one doesn't already exist
            # this process is TEMPORARY and will be replaced once the SP naming
            # system has been overhauled and all ETLs are autogenerated.
            current_max_process_number += 1
            process_number = current_max_process_number
            next_step_functions = []
        if len(history_table.columns) < 100:
            container_memory = 2048
        else:
            container_memory = 4096
        history_etl = ETLMetadata(
            process_name=f'ETL-{process_number}',
            hardcoded_data_source=None,
            input_type=ETLInputType.TABLE,
            output_type=ETLOutputType.INSERT,
            output_table=history_table.path,
            primary_source_table=history_table.primary_source_table,
            json_output_field=staging_table.primary_key[0],
            truncate_table=False,
            container_memory=container_memory,
            next_step_functions=next_step_functions,
            input_sql=generate_history_octane_table_input_sql(staging_table)
        )
        history_step_function = StepFunctionMetadata(
            name=f'SP-{process_number}',
            primary_target_table=history_table.path,
            parallel_limit=None
        )
        history_step_function.add_etl(history_etl)
        history_table.add_step_function(history_step_function)
    return metadata_with_history_octane


def determine_max_process_number(yaml_history_octane_metadata: SchemaMetadata) -> int:
    max_process_number = 0
    for table in yaml_history_octane_metadata.tables:
        for step_function in table.step_functions:
            max_process_number = max(max_process_number, get_step_function_process_number(step_function))
    return max_process_number


def get_step_function_process_number(step_function: StepFunctionMetadata) -> int:
    return int(step_function.name[3:])


def remove_deleted_column_metadata_from_column(column_metadata: ColumnMetadata) -> ColumnMetadata:
    column_metadata.source = None
    column_metadata.update_flag = None
    return column_metadata


def remove_deleted_table_metadata_from_table(table_metadata: TableMetadata) -> TableMetadata:
    table_metadata.primary_source_table = None
    table_metadata.next_etls = []

    # remove ETLs
    for table_metadata_step_functions in table_metadata.step_functions:
        print(f"      Removing Step Function '{table_metadata_step_functions.name}'")
        table_metadata.remove_step_function(table_metadata_step_functions.name)

    # remove FKs
    for table_metadata_fk in table_metadata.foreign_keys:
        print(f"      Removing FK '{table_metadata_fk.name}")
        table_metadata.remove_foreign_key(table_metadata_fk.name)

    # remove metadata from columns
    for column in table_metadata.columns:
        print(f"      Removing metadata from column '{table_metadata.name}.{column.name}'")
        remove_deleted_column_metadata_from_column(column)

    return table_metadata


def add_deleted_tables_and_columns_to_history_octane_metadata(octane_metadata: DataWarehouseMetadata,
                                                              current_yaml_metadata: DataWarehouseMetadata) -> DataWarehouseMetadata:
    """Generate a new DataWarehouseMetadata object with previously-deleted tables/columns incorporated into history_octane by adding data not found in octane_metadata from current_yaml_metadata.

    This function is used to cross-reference the current history_octane metadata generated from the metadata yaml files
    and passed in as current_yaml_metadata with the metadata pulled from Octane's information_schema passed in as octane_metadata
    in order to include tables/columns deleted from Octane's database to the autogenerated metadata resulting from this process.

    This is done because the DataWarehouseMetadata object generated from Octane's DB can only contain tables/columns that
    still exist in Octane. However, EDW's history_octane schema contains tables/columns that no longer
    exist in Octane but should still be included in the generated metadata.

    :param octane_metadata: a DataWarehouseMetadata object that already contains history_octane metadata within it that is generated
        from Octane's database and then has the history_octane metadata added to it.
    :param current_yaml_metadata:  a DataWarehouseMetadata object that already contains history_octane metadata within that is
        generated from reading the EDW's metadata yaml files.
    """

    # verify the staging database has a schema named history_octane in the DataWarehouseMetadata object read from the yaml files
    try:
        current_yaml_history_octane_metadata = current_yaml_metadata.get_database('staging').get_schema('history_octane')
    except InvalidMetadataKeyException:
        raise ValueError(
            'Schema "history_octane" in database "staging" must be present in parameter "current_yaml_history_octane_metadata" in order to incorporate deleted tables and columns')

    output_metadata = copy.deepcopy(octane_metadata)

    # verify the staging database has a schema named history_octane in the DataWarehouse Metadata created from octane's database
    try:
        combined_history_octane_metadata = copy.deepcopy(output_metadata.get_database('staging').get_schema('history_octane'))
    except InvalidMetadataKeyException:
        raise ValueError(
            'Schema "history_octane" in database "staging" must be present in parameter "octane_metadata" in  order to incorporate deleted tables and columns')

    print("Now finding tables that are not in octane metadata from yaml metadata...")
    for current_yaml_history_octane_metadata_table in current_yaml_history_octane_metadata.tables:
        print(f"  Checking table {current_yaml_history_octane_metadata_table.name}")
        if not combined_history_octane_metadata.contains_table(current_yaml_history_octane_metadata_table.name):
            # the table from the yaml metadata was not found in the generated octane metadata so we need to clean it and
            # add it to the output DataWarehouseMetadata object
            print(
                f"    The table 'history_octane.{current_yaml_history_octane_metadata_table.name}' is not in octane metadata. Need to add to output!")
            combined_history_octane_metadata.add_table(remove_deleted_table_metadata_from_table(current_yaml_history_octane_metadata_table))
        else:
            # the table from the yaml metadata was found in the generated octane metadata. we need to compare the
            # list of columns to see if there are any columns present in the yaml metadata that aren't in the generated
            # octane metadata.
            print(f"    Checking the list of columns because the table was found in generated Octane metadata... ")
            for current_yaml_history_octane_metadata_table_column in current_yaml_history_octane_metadata_table.columns:
                print(
                    f"      Checking column {current_yaml_history_octane_metadata_table.name}.{current_yaml_history_octane_metadata_table_column.name}")
                if not combined_history_octane_metadata.get_table(current_yaml_history_octane_metadata_table.name).contains_column(
                        current_yaml_history_octane_metadata_table_column.name):
                    # the column is not found so we need to add it
                    print(f"        Column not found... adding to output metadata after removing deleted column data.")
                    combined_history_octane_metadata.get_table(current_yaml_history_octane_metadata_table.name).add_column(
                        remove_deleted_column_metadata_from_column(current_yaml_history_octane_metadata_table_column))

    # remove the history_octane schema from the generated octane metadata and replace it with the enriched deepcopy
    output_metadata.get_database('staging').remove_schema('history_octane')
    output_metadata.get_database('staging').add_schema(combined_history_octane_metadata)
    return output_metadata


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
                           f'FROM (\n' + \
                           generate_most_recent_history_octane_table_record_subquery(table) + '\n' + \
                           f'     ) AS history_table\n' + \
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


def generate_most_recent_history_octane_table_record_subquery(table: TableMetadata, base_indent: int = 6) -> str:
    """Generate a full SQL subquery string to show the most recently updated record for each primary key in a history_octane table.

    The base_indent defaults to 6 because this is a subquery which will generally
    be following 'FROM (' which is exactly 6 characters
    """
    base_indent_str = base_indent * ' '

    current_history_octane_record_subquery = \
        f'{base_indent_str}SELECT current_records.*\n' + \
        f'{base_indent_str}FROM history_octane.{table.name} AS current_records\n' + \
        f'{base_indent_str}LEFT JOIN history_octane.{table.name} AS history_records\n' + \
        f'{base_indent_str}  ON current_records.{table.primary_key[0]} =\n' + \
        f'{base_indent_str}      history_records.{table.primary_key[0]}\n' + \
        f'{base_indent_str}    AND current_records.data_source_updated_datetime <\n' + \
        f'{base_indent_str}        history_records.data_source_updated_datetime\n' + \
        f'{base_indent_str}WHERE history_records.data_source_updated_datetime IS NULL'

    return current_history_octane_record_subquery


def generate_staging_to_history_join_column_string(column: str) -> str:
    """Generate a single join condition between a staging_octane column and its history_octane counterpart."""
    return f'staging_table.{column} = history_table.{column}'

