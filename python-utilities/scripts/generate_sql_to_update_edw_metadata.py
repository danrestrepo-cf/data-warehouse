import os
import argparse

from lib.db_connections import LocalEDWConnection
from lib.metadata_core.metadata_yaml_translator import generate_data_warehouse_metadata_from_yaml
from lib.config_mdi_metadata_maintenance.metadata_maintenance_sql import MetadataMaintenanceSQLGenerator
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import (ProcessMetadataComparisonFunctions)


def main():
    default_metadata_root_dir = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', '..', 'metadata', 'edw')
    argparser = argparse.ArgumentParser(description='Generate SQL to maintain metadata in the config.mdi schema')
    argparser.add_argument('-d', '--metadata_dir', type=str, default=default_metadata_root_dir)
    args = argparser.parse_args()

    edw_connection = LocalEDWConnection(host='localhost', dbname='config', user='postgres', password='testonly')
    data_warehouse_metadata = generate_data_warehouse_metadata_from_yaml(args.metadata_dir)
    sql_generator = MetadataMaintenanceSQLGenerator(edw_connection, data_warehouse_metadata)
    sql_generator.add_metadata_comparison_functions('process', ProcessMetadataComparisonFunctions())
    metadata_maintenance_sql = sql_generator.generate_all_metadata_maintenance_sql()
    if metadata_maintenance_sql == '':
        print('No metadata updates are necessary at this time')
    else:
        print(metadata_maintenance_sql)


if __name__ == '__main__':
    main()
