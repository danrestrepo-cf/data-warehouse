import os

from lib.db_connections import LocalEDWConnection
from lib.metadata_core.metadata_yaml_translator import generate_data_warehouse_metadata_from_yaml
from lib.config_mdi_metadata_maintenance.metadata_maintenance_sql import MetadataMaintenanceSQLGenerator
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import (ProcessMetadataComparisonFunctions)


def main():
    edw_connection = LocalEDWConnection(host='localhost', dbname='config', user='postgres', password='testonly')
    metadata_root_dir = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', '..', 'metadata', 'edw')
    data_warehouse_metadata = generate_data_warehouse_metadata_from_yaml(metadata_root_dir)
    sql_generator = MetadataMaintenanceSQLGenerator(edw_connection, data_warehouse_metadata)
    sql_generator.add_metadata_comparison_functions('process', ProcessMetadataComparisonFunctions())
    metadata_maintenance_sql = sql_generator.generate_all_metadata_maintenance_sql()
    if metadata_maintenance_sql == '':
        print('No metadata updates are necessary at this time')
    else:
        print(metadata_maintenance_sql)


if __name__ == '__main__':
    main()
