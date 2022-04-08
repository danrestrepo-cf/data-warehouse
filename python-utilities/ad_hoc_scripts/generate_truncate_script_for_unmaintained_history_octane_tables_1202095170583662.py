"""Generates a SQL script for truncating history_octane tables whose ETL(s) are NOT associated with any dependent
step functions.

4/8/2022 - CBoulé - Script created - https://app.asana.com/0/0/1202095170583662
"""

import sys
import os

# this line allows the script to import directly from python-utilities/lib when run from the command line
PROJECT_DIR_PATH = os.path.realpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..'))
sys.path.append(PROJECT_DIR_PATH)

from lib.metadata_core.metadata_object_path import SchemaPath
from lib.metadata_core.metadata_yaml_translator import generate_data_warehouse_metadata_from_yaml
from lib.metadata_core.metadata_filter import InclusiveMetadataFilterer


def main():
    metadata_dir = os.path.join(PROJECT_DIR_PATH, '..', 'metadata', 'edw')
    data_warehouse_metadata = generate_data_warehouse_metadata_from_yaml(metadata_dir)
    truncate_statements = []

    # filter metadata to history_octane
    filterer = InclusiveMetadataFilterer()
    filterer.add_schema_criteria(SchemaPath('staging', 'history_octane'))
    history_octane_metadata = filterer.filter(data_warehouse_metadata)

    for etl in history_octane_metadata.get_etls():
        if len(etl.next_step_functions) >= 1:
            pass
        else:
            truncate_statements.append(f'TRUNCATE history_octane.{etl.output_table.table};')

    with open('truncate_unmaintained_history_octane_tables.sql', 'w') as f:
        for entry in truncate_statements:
            f.write("%s\n" % entry)


if __name__ == '__main__':
    main()
