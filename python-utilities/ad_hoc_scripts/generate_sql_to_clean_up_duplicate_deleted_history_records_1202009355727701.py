"""Generate SQL to remove history_octane records marked as "deleted" but don't have the most recent version for their pid

4/8/2022 - CEdwards - Script created - https://app.asana.com/0/0/1202009355727701
"""

import sys
import os
import argparse

# this line allows the script to import directly from python-utilities/lib when run from the command line
PROJECT_DIR_PATH = os.path.realpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..'))
sys.path.append(PROJECT_DIR_PATH)

from lib.metadata_core.metadata_object_path import SchemaPath
from lib.metadata_core.metadata_yaml_translator import generate_data_warehouse_metadata_from_yaml


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
        default=os.path.realpath(os.path.join(PROJECT_DIR_PATH, 'ad_hoc_scripts', 'clean_up_history_octane_deleted_records.sql')),
        help='the file in which to output the generated SQL statements. Defaults to ./clean_up_history_octane_deleted_records.sql'
    )
    args = argparser.parse_args()

    output_sql = ''

    data_warehouse_metadata = generate_data_warehouse_metadata_from_yaml(args.metadata_dir)
    for table in data_warehouse_metadata.get_schema_by_path(SchemaPath('staging', 'history_octane')).tables:
        if not table.name.endswith('_type'):  # exclude type tables since they aren't affected by this issue
            # exclude deleted tables and handful of other tables without pid/version, e.g. account_id_sequence
            if table.primary_source_table and table.primary_key[0].endswith('_pid'):
                output_sql += (f'--{table.name}\n'
                               f'DELETE\n'
                               f'FROM history_octane.{table.name} non_current_records\n'
                               f'WHERE EXISTS(\n'
                               f'    SELECT *\n'
                               f'    FROM history_octane.{table.name} current_records\n'
                               f'    WHERE current_records.{table.primary_key[0]} = non_current_records.{table.primary_key[0]}\n'
                               f'      AND current_records.{table.primary_key[1]} > non_current_records.{table.primary_key[1]}\n'
                               f'    )\n'
                               f'  AND non_current_records.data_source_deleted_flag IS TRUE;\n\n')

    with open(args.output_file, 'w') as file:
        file.write(output_sql)


if __name__ == '__main__':
    main()
