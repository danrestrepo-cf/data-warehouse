import sys
import os
import copy
import csv
import glob
from typing import List
from collections import defaultdict
from pathlib import Path

import yaml

from database_connectors import EDW, OctaneDB


# enable PyYAML to gracefully output multi-line string values (e.g. ETL SQL queries)
# https://stackoverflow.com/a/33300001/15696521
def str_presenter(dumper, data):
    if len(data.splitlines()) > 1:  # check for multiline string
        return dumper.represent_scalar('tag:yaml.org,2002:str', data, style='|')
    return dumper.represent_scalar('tag:yaml.org,2002:str', data)


yaml.add_representer(str, str_presenter)


def main():
    # validate and parse command line arguments
    if len(sys.argv) != 2 or not os.path.isfile(sys.argv[1]):
        print('usage: python generate_edw_metadata_files.py [ssl_ca_filepath]')
        print()
        print('A valid AWS ssl certificate can be downloaded at the following link, ' +
              'provided you are already authenticated with AWS:')
        print('https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem')
        exit(1)
    ssl_ca_filepath = sys.argv[1]

    # define file paths for and (if needed) create output directory structure
    # default output root directory is data-warehouse/metadata
    root_dir = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', '..', 'metadata', 'edw', 'db.staging'))
    staging_octane_schema_dir = os.path.join(root_dir, 'schema.staging_octane')
    history_octane_schema_dir = os.path.join(root_dir, 'schema.history_octane')

    if not os.path.isdir(staging_octane_schema_dir):
        Path(staging_octane_schema_dir).mkdir(parents=True, exist_ok=True)

    if not os.path.isdir(history_octane_schema_dir):
        Path(history_octane_schema_dir).mkdir(parents=True, exist_ok=True)

    # delete any existing staging_octane and history_octane TABLE metadata files
    for file in glob.glob(f'{staging_octane_schema_dir}/table.*.yaml'):
        os.remove(file)

    for file in glob.glob(f'{history_octane_schema_dir}/table.*.yaml'):
        os.remove(file)

    # read in and parse metadata related to excluded tables and fields in Octane's DB
    excluded_table_prefixes_filepath = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'octane_excluded_table_prefixes.csv')
    excluded_tables_filepath = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'octane_excluded_tables.csv')
    excluded_columns_filepath = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'octane_excluded_columns.csv')

    excluded_table_prefixes = {row['table_prefix'] for row in read_csv_to_list_of_dicts(excluded_table_prefixes_filepath)}
    excluded_tables = {row['table_name'] for row in read_csv_to_list_of_dicts(excluded_tables_filepath)}
    excluded_columns_raw = read_csv_to_list_of_dicts(excluded_columns_filepath)
    excluded_columns = defaultdict(set)
    for row in excluded_columns_raw:
        excluded_columns[row['table_name']].add(row['column_name'])

    octane_data_filterer = OctaneDataFilterer(excluded_table_prefixes, excluded_tables, excluded_columns)

    # define database connections to Octane cert and EDW local
    octane_connection = OctaneDB(
        host="cert-lura-db.cluster-ro-c67hguplwubq.us-east-1.rds.amazonaws.com",
        dbname="lura_qa",
        region="us-east-1",
        user="engineer.readonly",
        port="3306",
        profile_name="octane-database-readonly",
        ssl_ca_filepath=ssl_ca_filepath
    )

    edw_connection = EDW(
        host='localhost',
        dbname='config',
        user='postgres',
        password='testonly'
    )

    # generate EDW metadata
    staging_octane_metadata = generate_staging_octane_metadata(octane_connection, octane_data_filterer)
    table_etl_processes = generate_etl_process_metadata(edw_connection)
    history_octane_metadata = generate_history_octane_metadata(staging_octane_metadata, table_etl_processes)

    # write EDW metadata to yaml files
    print('Writing staging_octane table metadata files')
    for table_name, metadata in staging_octane_metadata.items():
        write_table_metadata_yaml_file(staging_octane_schema_dir, table_name, metadata)
    print('Writing history_octane table metadata files')
    for table_name, metadata in history_octane_metadata.items():
        write_table_metadata_yaml_file(history_octane_schema_dir, table_name, metadata)

    print('Metadata files written successfully!')


class OctaneDataFilterer:

    def __init__(self, excluded_table_prefixes: iter, excluded_tables: iter, excluded_columns: dict):
        self.excluded_table_prefixes = excluded_table_prefixes
        self.excluded_tables = excluded_tables
        self.excluded_columns = excluded_columns

    def row_should_be_excluded(self, row: dict) -> bool:
        return (row['table_name'] in self.excluded_tables) or \
               (row['table_name'] in self.excluded_columns and row['column_name'] in self.excluded_columns[row['table_name']]) or \
               (any([row['table_name'].startswith(prefix) for prefix in self.excluded_table_prefixes]))


def generate_staging_octane_metadata(octane_connection: OctaneDB, octane_data_filterer: OctaneDataFilterer) -> dict:
    with octane_connection as cursor:
        column_metadata = cursor.select_as_list_of_dicts("""
                SELECT columns.table_name
                    , columns.column_name
                    , UPPER( columns.column_type ) AS column_type
                    , columns.column_key = 'PRI' AS is_primary_key
                FROM information_schema.columns
                WHERE columns.table_schema = 'lura_qa'
                ORDER BY columns.table_name, columns.ordinal_position;
            """)

        fk_metadata = cursor.select_as_list_of_dicts("""
                SELECT table_name
                    , column_name
                    , constraint_name
                    , referenced_table_name
                    , referenced_column_name
                FROM information_schema.key_column_usage
                WHERE key_column_usage.referenced_table_schema IS NOT NULL;
            """)

        staging_octane_data = {}
        for row in column_metadata:
            if not octane_data_filterer.row_should_be_excluded(row):
                if row['table_name'] not in staging_octane_data:
                    # add all possibly-needed keys to the dict now to enforce key ordering
                    # keys with no value (e.g. None, empty list, etc) will be filtered out before being written to a file
                    staging_octane_data[row['table_name']] = {
                        'name': row['table_name'],
                        'primary_source_table': None,
                        'primary_key': [],
                        'foreign_keys': {},
                        'columns': {},
                        'etls': {},
                        'next_etls': {}
                    }
                if row['is_primary_key'] == 1:
                    staging_octane_data[row['table_name']]['primary_key'].append(row['column_name'])
                staging_octane_data[row['table_name']]['columns'][row['column_name']] = {
                    'data_type': map_data_type(row['column_type'])
                }

        for row in fk_metadata:
            if not octane_data_filterer.row_should_be_excluded(row):
                staging_octane_data[row['table_name']]['foreign_keys'][row['constraint_name']] = {
                    'columns': [row['column_name']],
                    'references': {
                        'columns': [row['referenced_column_name']],
                        'schema': 'staging_octane',
                        'table': row['referenced_table_name']
                    }
                }
        return staging_octane_data


def read_csv_to_list_of_dicts(filepath: str) -> List[dict]:
    with open(filepath) as file:
        return list(csv.DictReader(file))


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


def generate_etl_process_metadata(edw_connection: EDW) -> dict:
    with edw_connection as cursor:
        raw_table_etl_processes = cursor.select_as_list_of_dicts("""
            SELECT table_output_step.target_table
                 , process.name AS process
            FROM mdi.process
            JOIN mdi.table_output_step
                 ON process.dwid = table_output_step.process_dwid
            WHERE table_output_step.target_schema = 'history_octane';
        """)

        raw_next_etl_processes = cursor.select_as_list_of_dicts("""
            SELECT table_output_step.target_table
                 , next_process.name AS next_process
            FROM mdi.state_machine_step
            JOIN mdi.process
                 ON state_machine_step.process_dwid = process.dwid
            JOIN mdi.process next_process
                 ON state_machine_step.next_process_dwid = next_process.dwid
            JOIN mdi.table_output_step
                 ON process.dwid = table_output_step.process_dwid
            WHERE table_output_step.target_schema = 'history_octane';
        """)

        table_etl_processes = {row['target_table']: {'process': row['process'], 'next_processes': []} for row in raw_table_etl_processes}
        for row in raw_next_etl_processes:
            table_etl_processes[row['target_table']]['next_processes'].append(row['next_process'])
        return table_etl_processes


def generate_history_octane_metadata(staging_octane_metadata: dict, table_etl_processes: dict) -> dict:
    history_octane_metadata = copy.deepcopy(staging_octane_metadata)

    for metadata in history_octane_metadata.values():
        metadata['primary_source_table'] = f'staging.staging_octane.{metadata["name"]}'
        for column in metadata['columns'].keys():
            metadata['columns'][column]['source'] = {
                'field': f'primary_source_table.columns.{column}'
            }
        metadata['columns']['data_source_updated_datetime'] = {
            'data_type': 'TIMESTAMPTZ'
        }
        metadata['columns']['data_source_deleted_flag'] = {
            'data_type': 'BOOLEAN'
        }
        for foreign_key in metadata['foreign_keys'].keys():
            metadata['foreign_keys'][foreign_key]['references']['schema'] = 'history_octane'
        if metadata['name'] in table_etl_processes:
            metadata['etls'][table_etl_processes[metadata['name']]['process']] = {
                'hardcoded_data_source': 'Octane',
                'input_type': 'table',
                'output_type': 'insert',
                'json_output_field': metadata['primary_key'][0],
                'truncate_table': False,
                'input_sql': generate_table_input_sql(metadata)
            }
            metadata['next_etls'] = table_etl_processes[metadata['name']]['next_processes']
    return history_octane_metadata


def generate_table_input_sql(table_metadata: dict) -> str:
    table_name = table_metadata['name']
    columns = list(table_metadata['columns'].keys())
    staging_select_columns = generate_select_columns_string('staging_table', columns, increment_version=False)
    table_input_sql = f'--finding records to insert into history_octane.{table_name}\n' + \
                      f'SELECT {staging_select_columns}\n' + \
                      f'     , FALSE AS data_source_deleted_flag\n' + \
                      f'     , NOW( ) AS data_source_updated_datetime\n' + \
                      f'FROM staging_octane.{table_name} staging_table\n'

    if table_name.endswith('_type'):
        table_input_sql += f'LEFT JOIN history_octane.{table_name} history_table\n' + \
                           f'          ON staging_table.code = history_table.code AND staging_table.value = history_table.value\n' + \
                           f'WHERE history_table.code IS NULL;'
    else:
        primary_key_column = table_metadata['primary_key'][0]
        octane_table_column_prefix = primary_key_column.split('_')[0]
        version_column = f'{octane_table_column_prefix}_version'
        history_select_columns = generate_select_columns_string('history_table', columns, increment_version=True)
        table_input_sql += f'LEFT JOIN history_octane.{table_name} history_table\n' + \
                           f'          ON staging_table.{primary_key_column} = history_table.{primary_key_column} AND staging_table.{version_column} = history_table.{version_column}\n' + \
                           f'WHERE history_table.code IS NULL\n' + \
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


def generate_select_columns_string(table_prefix: str, columns: List[str], increment_version: bool) -> str:
    select_columns = []
    for col in columns:
        if col.endswith('_version') and increment_version:
            select_columns.append(f'{table_prefix}.{col} + 1')
        else:
            select_columns.append(f'{table_prefix}.{col}')
    return '\n     , '.join(select_columns)


def write_table_metadata_yaml_file(output_dir: str, table_name: str, metadata: dict):
    filepath = os.path.join(output_dir, f'table.{table_name}.yaml')
    with open(filepath, 'w') as output_file:
        yaml.dump(filter_out_keys_with_no_value(metadata), output_file, default_flow_style=False, sort_keys=False)


def filter_out_keys_with_no_value(metadata: dict) -> dict:
    return {key: value for key, value in metadata.items() if value != [] and value != {} and value is not None}


if __name__ == '__main__':
    main()
