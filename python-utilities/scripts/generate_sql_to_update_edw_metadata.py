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

import constants

# this line allows the script to import directly from lib when run from the command line
sys.path.append(constants.PROJECT_DIR_PATH)

from lib.db_connections import DBConnectionFactory
from lib.metadata_core.metadata_object_path import SchemaPath
from lib.metadata_core.metadata_yaml_translator import generate_data_warehouse_metadata_from_yaml
from lib.metadata_core.metadata_filter import InclusiveMetadataFilterer
from lib.config_mdi_metadata_maintenance.metadata_maintenance_sql_generator import MetadataMaintenanceSQLGenerator
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import (ProcessMetadataComparisonFunctions,
                                                                               JSONOutputFieldMetadataComparisonFunctions,
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
        default=os.path.realpath('./config_mdi_metadata_maintenance.sql'),
        help='the file in which to output the generated SQL statements. Defaults to ./config_mdi_metadata_maintenance.sql'
    )
    args = argparser.parse_args()

    # read in metadata to be compared
    edw_connection = DBConnectionFactory().get_connection('edw-local-config')
    data_warehouse_metadata = generate_data_warehouse_metadata_from_yaml(args.metadata_dir)

    # filter metadata to staging_octane, history_octane, star_loan, and star_common
    filterer = InclusiveMetadataFilterer()
    filterer.add_schema_criteria(SchemaPath('staging', 'staging_octane'))
    filterer.add_schema_criteria(SchemaPath('staging', 'history_octane'))
    filterer.add_schema_criteria(SchemaPath('staging', 'star_loan'))
    filterer.add_schema_criteria(SchemaPath('staging', 'star_common'))
    filterer.add_schema_criteria(SchemaPath('staging', 'data_mart_business_applications'))
    data_warehouse_metadata = filterer.filter(data_warehouse_metadata)

    # set up SQL generator object
    sql_generator = MetadataMaintenanceSQLGenerator(edw_connection, data_warehouse_metadata)
    # the order in which MetadataComparisonFunctions are added below defines the table SQL statement order in the final script output
    # this order matters because of inter-table dependencies (e.g. json_output_step depends on process)
    sql_generator.add_metadata_comparison_functions('edw_table_definition', EDWTableDefinitionMetadataComparisonFunctions())
    sql_generator.add_metadata_comparison_functions('edw_field_definition', EDWFieldDefinitionMetadataComparisonFunctions())
    sql_generator.add_metadata_comparison_functions('process', ProcessMetadataComparisonFunctions())
    sql_generator.add_metadata_comparison_functions('table_input_step', TableInputStepMetadataComparisonFunctions())
    sql_generator.add_metadata_comparison_functions('table_output_step', TableOutputStepMetadataComparisonFunctions())
    sql_generator.add_metadata_comparison_functions('table_output_field', TableOutputFieldMetadataComparisonFunctions())
    sql_generator.add_metadata_comparison_functions('insert_update_step', InsertUpdateStepMetadataComparisonFunctions())
    sql_generator.add_metadata_comparison_functions('insert_update_key', InsertUpdateKeyMetadataComparisonFunctions())
    sql_generator.add_metadata_comparison_functions('insert_update_field', InsertUpdateFieldMetadataComparisonFunctions())
    sql_generator.add_metadata_comparison_functions('delete_step', DeleteStepMetadataComparisonFunctions())
    sql_generator.add_metadata_comparison_functions('delete_key', DeleteKeyMetadataComparisonFunctions())
    sql_generator.add_metadata_comparison_functions('json_output_field', JSONOutputFieldMetadataComparisonFunctions())

    # generate and output metadata maintenance SQL statements
    metadata_maintenance_sql = sql_generator.generate_all_metadata_maintenance_sql()
    if metadata_maintenance_sql == '':
        print('No metadata updates are necessary at this time')
    else:
        with open(args.output_file, 'w') as file:
            file.write(metadata_maintenance_sql)
        print(f'config.mdi metadata maintenance SQL successfully written to {args.output_file}')


if __name__ == '__main__':
    main()
