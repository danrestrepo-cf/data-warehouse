"""Add new physical_column_flag attribute to all columns listed in table definition yaml files within the below listed
schemas per 1202199739435359.

    - data_mart_business_applications
    - history_octane
    - staging_octane
    - star_common
    - star_loan

This is a one-off script that essentially serves as a YAML attribute addition script for the task in question.


05/03/2022 - CBoulé - Script created - https://app.asana.com/0/0/1202199739435359
"""

import sys
import os
import argparse
import yaml
from typing import Any

# this line allows the script to import directly from lib when run from the command line
PROJECT_DIR_PATH = os.path.realpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..'))
sys.path.append(PROJECT_DIR_PATH)


# enable PyYAML to gracefully output multi-line string values (e.g. ETL SQL queries)
# https://stackoverflow.com/a/33300001/15696521
def str_presenter(dumper, data):
    if len(data.splitlines()) > 1:  # check for multiline string
        return dumper.represent_scalar('tag:yaml.org,2002:str', data, style='|')
    return dumper.represent_scalar('tag:yaml.org,2002:str', data)


yaml.add_representer(str, str_presenter)


def main():
    # parse command line arguments
    argparser = argparse.ArgumentParser(description='Regenerate EDW metadata yaml files')
    argparser.add_argument(
        '--metadata_dir',
        type=str,
        default=os.path.join(PROJECT_DIR_PATH, '..', 'metadata', 'edw'),
        help='the source directory for metadata files. Defaults to data-warehouse/metadata.'
    )
    args = argparser.parse_args()

    if not os.path.isdir(args.metadata_dir):
        raise FileNotFoundError(f'{args.metadata_dir} is not a valid directory path')
    for db_dir in os.scandir(args.metadata_dir):
        if db_dir.is_dir():  # JetBrains IDEs have a known issue with giving incorrect type warnings related to the scandir() method
            for schema_dir in os.scandir(db_dir):
                if schema_dir.is_dir():
                    for table_file in os.scandir(schema_dir):
                        if table_file.is_file():
                            # read in current state of yaml file
                            with open(table_file.path, 'r') as file:
                                table_yaml = yaml.safe_load(file)
                            if 'columns' in table_yaml:
                                for column, attributes in table_yaml['columns'].items():
                                    insert_dict_item_after_key(
                                        d=attributes,
                                        after_key='data_type',
                                        key='physical_column_flag',
                                        value=True
                                    )
                                with open(table_file.path, 'w', newline='\n') as file:
                                    yaml.dump(table_yaml, file, default_flow_style=False, sort_keys=False)


def insert_dict_item_after_key(d: dict, after_key: str, key: str, value: Any) -> None:
    items = list(d.items())
    insert_pos = list(d.keys()).index(after_key) + 1
    items.insert(insert_pos, (key, value))
    d.clear()
    d.update(items)


if __name__ == '__main__':
    main()