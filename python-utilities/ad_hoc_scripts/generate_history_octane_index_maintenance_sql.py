"""Create indexes in history_octane to match Octane foreign and primary keys

This one-off script compares primary- and foreign-key metadata in the history_octane
schema with history_octane index metadata from pg_catalog and generates SQL statements
that create indexes on any columns in history_octane that correspond to either:
    1. primary key columns in Octane
    2. foreign key columns in Octane

1/3/2022 - CEdwards - Script created        https://app.asana.com/0/0/1201595592239229
"""

import sys
import os
import argparse
import hashlib

# this line allows the script to import directly from lib when run from the command line
PROJECT_DIR_PATH = os.path.realpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..'))
sys.path.append(PROJECT_DIR_PATH)

from lib.db_connections import DBConnectionFactory, DBConnection
from lib.metadata_core.metadata_object_path import SchemaPath
from lib.metadata_core.metadata_yaml_translator import generate_data_warehouse_metadata_from_yaml
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable


def main():
    # parse command line arguments
    argparser = argparse.ArgumentParser(description='Generate SQL to maintain metadata in the config.mdi schema')
    argparser.add_argument(
        '--metadata_dir',
        type=str,
        default=os.path.join(PROJECT_DIR_PATH, '..', 'metadata', 'edw'),
        help='the source directory for metadata files. Defaults to data-warehouse/metadata.'
    )
    argparser.add_argument(
        '--output_file',
        type=str,
        default=os.path.realpath(os.path.join(PROJECT_DIR_PATH, 'ad_hoc_scripts', 'history_octane_index_maintenance.sql')),
        help='the file in which to output the generated SQL statements. Defaults to ./history_octane_index_maintenance.sql'
    )
    args = argparser.parse_args()

    # read in metadata to be compared
    index_metadata = get_existing_index_metadata(DBConnectionFactory().get_connection('edw-local-staging'))
    data_warehouse_metadata = generate_data_warehouse_metadata_from_yaml(args.metadata_dir)

    # build metadata tables from YAML primary key and foreign key data
    foreign_key_metadata = MetadataTable(['tablename', 'columnname'])
    primary_key_metadata = MetadataTable(['tablename', 'columnname'])
    for table in data_warehouse_metadata.get_schema_by_path(SchemaPath('staging', 'history_octane')).tables:
        primary_key_metadata.add_row({
            'tablename': table.name,
            'indexname': make_index_name(table.name, table.primary_key[0]),
            'columnname': table.primary_key[0]
        })
        for foreign_key in table.foreign_keys:
            foreign_key_metadata.add_row({
                'tablename': table.name,
                'indexname': foreign_key.name,
                'columnname': foreign_key.native_columns[0]
            })

    # generate maintenance SQL string
    maintenance_sql = '/*\nPRIMARY KEY INDEXES\n*/\n\n'
    for row in primary_key_metadata.rows:
        if not index_metadata.row_exists_with_key(row.key):
            maintenance_sql += make_create_index_statement(row.attributes["indexname"], row.key["tablename"], row.key["columnname"])

    maintenance_sql += '\n/*\nFOREIGN KEY INDEXES\n*/\n\n'
    for row in foreign_key_metadata.rows:
        if not index_metadata.row_exists_with_key(row.key):
            maintenance_sql += make_create_index_statement(row.attributes["indexname"], row.key["tablename"], row.key["columnname"])

    # output results
    with open(args.output_file, 'w') as file:
        file.write(maintenance_sql)
    print(f'history_octane index maintenance SQL successfully written to {args.output_file}')


def get_existing_index_metadata(edw_connection: DBConnection) -> MetadataTable:
    with edw_connection as cursor:
        raw_metadata = cursor.execute_and_fetch_all_results('''
            SELECT tablename
                 , indexname
                 , (REGEXP_MATCHES( indexdef, '\(([a-zA-Z0-9_]+)\)$', 'g' ))[1] AS columnname
            FROM pg_catalog.pg_indexes
            WHERE schemaname = 'history_octane';

        ''')
        metadata_table = MetadataTable(['tablename', 'columnname'])
        for row in raw_metadata:
            metadata_table.add_row(row)
        return metadata_table


def make_index_name(table: str, column: str) -> str:
    default_name = f'idx_{table}__{column}'
    if len(default_name) > 63:
        return f'idx_{hashlib.md5(default_name).hexdigest()}'
    else:
        return default_name


def make_create_index_statement(index: str, table: str, column: str) -> str:
    return f'CREATE INDEX {index} ON history_octane.{table} ({column});\n'


if __name__ == '__main__':
    main()
