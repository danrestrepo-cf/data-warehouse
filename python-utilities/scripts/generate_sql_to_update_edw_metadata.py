import sys
import os
import argparse

# this line allows the script to import directly from lib when run from the command line
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..'))

from lib.db_connections import LocalEDWConnection
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.metadata_core.metadata_yaml_translator import generate_data_warehouse_metadata_from_yaml
from lib.config_mdi_metadata_maintenance.metadata_maintenance_sql import MetadataMaintenanceSQLGenerator
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import (ProcessMetadataComparisonFunctions,
                                                                               JSONOutputFieldMetadataComparisonFunctions,
                                                                               StateMachineDefinitionMetadataComparisonFunctions,
                                                                               StateMachineStepMetadataComparisonFunctions,
                                                                               TableInputStepMetadataComparisonFunctions,
                                                                               TableOutputStepMetadataComparisonFunctions)


def main():
    # parse command line arguments
    default_metadata_root_dir = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', '..', 'metadata', 'edw')
    default_output_file_path = os.path.realpath('./config_mdi_metadata_maintenance.sql')
    argparser = argparse.ArgumentParser(description='Generate SQL to maintain metadata in the config.mdi schema')
    argparser.add_argument('-d', '--metadata_dir', type=str, default=default_metadata_root_dir)
    argparser.add_argument('-o', '--output_file', type=str, default=default_output_file_path)
    args = argparser.parse_args()

    # read in metadata to be compared
    edw_connection = LocalEDWConnection(host='localhost', dbname='config', user='postgres', password='testonly')
    data_warehouse_metadata = generate_data_warehouse_metadata_from_yaml(args.metadata_dir)
    filter_metadata_to_staging_octane_and_history_octane_schemas(data_warehouse_metadata)

    # set up SQL generator object
    sql_generator = MetadataMaintenanceSQLGenerator(edw_connection, data_warehouse_metadata)
    sql_generator.add_metadata_comparison_functions('process', ProcessMetadataComparisonFunctions())
    sql_generator.add_metadata_comparison_functions('table_input_step', TableInputStepMetadataComparisonFunctions())
    sql_generator.add_metadata_comparison_functions('table_output_step', TableOutputStepMetadataComparisonFunctions())
    sql_generator.add_metadata_comparison_functions('json_output_field', JSONOutputFieldMetadataComparisonFunctions())
    sql_generator.add_metadata_comparison_functions('state_machine_definition', StateMachineDefinitionMetadataComparisonFunctions())
    sql_generator.add_metadata_comparison_functions('state_machine_step', StateMachineStepMetadataComparisonFunctions())
    insert_and_update_table_order = [
        'process',
        'table_input_step',
        'table_output_step',
        'json_output_field',
        'state_machine_definition',
        'state_machine_step'
    ]
    delete_table_order = list(reversed(insert_and_update_table_order))
    sql_generator.set_insert_table_order(insert_and_update_table_order)
    sql_generator.set_update_table_order(insert_and_update_table_order)
    sql_generator.set_delete_table_order(delete_table_order)

    # generate and output metadata maintenance SQL statements
    metadata_maintenance_sql = sql_generator.generate_all_metadata_maintenance_sql()
    if metadata_maintenance_sql == '':
        print('No metadata updates are necessary at this time')
    else:
        with open(args.output_file, 'w') as file:
            file.write(metadata_maintenance_sql)
        print(f'config.mdi metadata maintenance SQL successfully written to {args.output_file}')


def filter_metadata_to_staging_octane_and_history_octane_schemas(metadata: DataWarehouseMetadata):
    """
    Delete any metadata not from the staging.staging_octane or staging.history_octane schemas

    This is to prevent potentially misleading comparisons involving other schemas while
    this script is still not properly configured to handle those other schemas. This
    method and its usages should be REMOVED if/when the script is expanded to handle
    schema metadata outside of staging_octane and history_octane.
    """
    for database in metadata.databases:
        if database.name != 'staging':
            metadata.remove_database_metadata(database.name)
    if 'staging' in metadata.databases:
        database = metadata.get_database('staging')
        for schema in database.schemas:
            if schema.name != 'staging_octane' and schema.name != 'history_octane':
                database.remove_schema_metadata(schema.name)


if __name__ == '__main__':
    main()
