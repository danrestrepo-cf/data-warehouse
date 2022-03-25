"""Convert all ETL metadata EDW table YAML files to the new format/syntax specified in task 1201843492068511.

This is a one-off script that essentially serves as a YAML structure migration script for the task in question.

3/24/2022 - CEdwards - Script created - https://app.asana.com/0/0/1201843492068511
"""

import sys
import os
import argparse
import yaml
from typing import Any
from copy import deepcopy

# this line allows the script to import directly from python-utilities/lib when run from the command line
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
    argparser = argparse.ArgumentParser(description='Generate SQL to maintain metadata in the config.mdi schema')
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
            database = db_dir.name.split('.')[1]
            for schema_dir in os.scandir(db_dir):
                if schema_dir.is_dir():
                    schema = schema_dir.name.split('.')[1]
                    for table_file in os.scandir(schema_dir):
                        if table_file.is_file():
                            # read in current state of yaml file
                            with open(table_file.path, 'r') as file:
                                table_yaml = yaml.safe_load(file)
                            if 'etls' in table_yaml:
                                # modify metadata to adhere to new structure
                                update_structure(table_yaml, database, schema)
                                # overwrite file with new structure
                                with open(table_file.path, 'w') as file:
                                    yaml.dump(table_yaml, file, default_flow_style=False, sort_keys=False)


def update_structure(table_yaml: dict, database: str, schema: str) -> None:
    table_yaml['step_functions'] = {}
    for etl_name, etl in table_yaml['etls'].items():
        # add new output_table and next_step_functions values to each ETL metadata dict
        insert_dict_item_after_key(
            d=etl,
            after_key='output_type',
            key='output_table',
            value=f'{database}.{schema}.{table_yaml["name"]}'
        )
        if 'next_etls' in table_yaml:
            insert_dict_item_after_key(
                d=etl,
                after_key='container_memory',
                key='next_step_functions',
                value=deepcopy(table_yaml['next_etls'])  # deepcopy to ensure yaml.dumps doesn't do anchoring/aliasing for multiple ETLs
            )
        # place ETL dict within new encompassing structure
        process_number = etl_name[3:]
        table_yaml['step_functions'][f'SP-{process_number}'] = {
            'etls': {
                f'ETL-{process_number}': etl
            }
        }
    del table_yaml['etls']
    if 'next_etls' in table_yaml:
        del table_yaml['next_etls']


def insert_dict_item_after_key(d: dict, after_key: str, key: str, value: Any) -> None:
    items = list(d.items())
    insert_pos = list(d.keys()).index(after_key) + 1
    items.insert(insert_pos, (key, value))
    d.clear()
    d.update(items)


if __name__ == '__main__':
    main()
