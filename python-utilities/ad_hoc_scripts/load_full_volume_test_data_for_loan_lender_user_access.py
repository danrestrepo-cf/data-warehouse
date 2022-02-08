"""Load all relevant tables with production-volume data to test loan_lender_user_access ETL performance.

2/8/2022 - CEdwards- Script created - https://app.asana.com/0/0/1201486823872698
"""
import sys
import os
import argparse

# this line allows the script to import directly from python-utilities/lib when run from the command line
PROJECT_DIR_PATH = os.path.realpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..'))
sys.path.append(PROJECT_DIR_PATH)

from lib.db_connections import DBConnectionFactory, DBConnection
from lib.metadata_core.metadata_object_path import SchemaPath
from lib.metadata_core.metadata_yaml_translator import generate_data_warehouse_metadata_from_yaml
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable


def main():
    DBConnectionFactory().get_connection('edw-local-staging')



if __name__ == '__main__':
    main()
