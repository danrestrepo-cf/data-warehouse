"""Generate SQL statements to update metadata stored in the EDW config.mdi schema so that it matches EDW YAML metadata files' contents.

This script reads EDW metadata from the following tables in the config.mdi schema:
- edw_table_definition
- edw_join_definition
- edw_field_definition
- process
- table_input_step
- table_output_step
- table_output_field
- json_output_field
- state_machine_definition
- state_machine_step

It then compares that data with the corresponding metadata in the EDW YAML metadata
records, and generates INSERT, UPDATE, and DELETE SQL statements based on the
following logic:
- Any metadata present in the YAML files but not in the mdi schema should
  be INSERTED into the appropriate mdi schema table
- Any metadata not present in the YAML files but present in the mdi schema should
  be DELETED from the appropriate mdi schema table
- Any metadata entity in the mdi schema whose attributes differ from the same
  entity in the YAML metadata should be UPDATED in the appropriate mdi schema table

After performing the comparison and analyzing any differences, the script outputs
a SQL file (either to "./config_mdi_metadata_maintenance.sql" or a user-specified
location, if one is given) containing DML queries that, when executed, update
the contents of the config.mdi metadata tables to match the contents of the EDW
metadata YAML files.
"""
import sys
import os
import argparse
from typing import List

import constants

# this line allows the script to import directly from lib when run from the command line
sys.path.append(constants.PROJECT_DIR_PATH)

from lib.db_connections import DBConnectionFactory, DBConnection
from lib.metadata_core.metadata_object_path import SchemaPath
from lib.metadata_core.metadata_yaml_translator import generate_data_warehouse_metadata_from_yaml
from lib.metadata_core.metadata_filter import InclusiveMetadataFilterer
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable
from lib.config_mdi_metadata_maintenance.metadata_maintenance_sql_generator import MetadataMaintenanceSQLGenerator
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import (ProcessMetadataComparisonFunctions,
                                                                               JSONOutputFieldMetadataComparisonFunctions,
                                                                               StateMachineDefinitionMetadataComparisonFunctions,
                                                                               StateMachineStepMetadataComparisonFunctions,
                                                                               TableInputStepMetadataComparisonFunctions,
                                                                               TableOutputStepMetadataComparisonFunctions,
                                                                               TableOutputFieldMetadataComparisonFunctions,
                                                                               InsertUpdateStepMetadataComparisonFunctions,
                                                                               InsertUpdateKeyMetadataComparisonFunctions,
                                                                               InsertUpdateFieldMetadataComparisonFunctions,
                                                                               DeleteStepMetadataComparisonFunctions,
                                                                               DeleteKeyMetadataComparisonFunctions,
                                                                               EDWTableDefinitionMetadataComparisonFunctions,
                                                                               EDWFieldDefinitionMetadataComparisonFunctions)


def main():
    # parse command line arguments
    argparser = argparse.ArgumentParser(description='Generate SQL to maintain metadata in the config.mdi schema')
    argparser.add_argument(
        '--metadata_dir',
        type=str,
        default=os.path.join(constants.PROJECT_DIR_PATH, '..', 'metadata', 'edw'),
        help='the source directory for metadata files. Defaults to data-warehouse/metadata.'
    )
    argparser.add_argument(
        '--output_file',
        type=str,
        default=os.path.realpath('./history_octane_index_maintenance.sql'),
        help='the file in which to output the generated SQL statements. Defaults to ./history_octane_index_maintenance.sql'
    )
    args = argparser.parse_args()

    # read in metadata to be compared
    index_metadata = get_existing_index_metadata(DBConnectionFactory().get_connection('edw-local-staging'))
    data_warehouse_metadata = generate_data_warehouse_metadata_from_yaml(args.metadata_dir)

    # filter metadata to staging_octane, history_octane, star_loan, and star_common
    filterer = InclusiveMetadataFilterer()
    filterer.add_schema_criteria(SchemaPath('staging', 'history_octane'))
    data_warehouse_metadata = filterer.filter(data_warehouse_metadata)

    # build metadata table from YAML foreign key data
    # indexname is an *attribute* (not part of the key) in order to identify columns that *are* indexed but with an unexpected name
    foreign_key_metadata = MetadataTable(['tablename', 'columnname'])
    for table in data_warehouse_metadata.get_schema_by_path(SchemaPath('staging', 'history_octane')).tables:
        for foreign_key in table.foreign_keys:
            foreign_key_metadata.add_row({
                'tablename': table.name,
                'indexname': foreign_key.name,
                'columnname': foreign_key.native_columns[0]
            })

    # generate maintenance SQL string
    maintenance_sql = ''
    for row in foreign_key_metadata.rows:
        if not index_metadata.row_exists_with_key(row.key):
            maintenance_sql += f'CREATE INDEX {row.attributes["indexname"]} ON history_octane.{row.key["tablename"]} ({row.key["columnname"]});\n'
        elif not row.attributes == index_metadata.get_attributes_by_key(row.key):
            current_idx_name = index_metadata.get_attributes_by_key(row.key)['indexname']
            maintenance_sql += f'ALTER INDEX history_octane.{current_idx_name} RENAME TO {row.attributes["indexname"]};\n'

    # output results
    if maintenance_sql == '':
        print('No new indexes are necessary at this time')
    else:
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


if __name__ == '__main__':
    main()
