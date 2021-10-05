import pathlib
import glob
import os
import yaml
from typing import List

from data_warehouse_metadata import (DataWarehouseMetadata,
                                     DatabaseMetadata,
                                     SchemaMetadata,
                                     TableMetadata,
                                     ColumnMetadata,
                                     ETLMetadata,
                                     ForeignKeyMetadata,
                                     ForeignColumnPath,
                                     TableAddress,
                                     InvalidMetadataKeyException)


def generate_data_warehouse_metadata_from_yaml(root_dir_file_path: str) -> DataWarehouseMetadata:
    if not os.path.isdir(root_dir_file_path):
        raise FileNotFoundError(f'{root_dir_file_path} is not a valid directory path')
    data_warehouse_dir_name = pathlib.PurePath(root_dir_file_path).name
    data_warehouse = DataWarehouseMetadata(data_warehouse_dir_name)
    for db_subdir_path in get_subdir_paths_with_prefix(root_dir_file_path, 'db'):
        database_name = strip_dot_prefix(pathlib.PurePath(db_subdir_path).name)
        database = DatabaseMetadata(database_name)
        data_warehouse.add_database(database)
        for schema_subdir_path in get_subdir_paths_with_prefix(db_subdir_path, 'schema'):
            schema_name = strip_dot_prefix(pathlib.PurePath(schema_subdir_path).name)
            schema = SchemaMetadata(schema_name)
            database.add_schema(schema)
            for table_yaml_path in get_yaml_paths_with_prefix(schema_subdir_path, 'table'):
                table_yaml = read_yaml_file(table_yaml_path)
                table = TableMetadata(table_yaml['name'])
                if 'primary_source_table' in table_yaml:
                    # todo: add error checking
                    source_table_components = table_yaml['primary_source_table'].split('.')
                    table.primary_source_table = TableAddress(
                        database=source_table_components[0],
                        schema=source_table_components[1],
                        table=source_table_components[2]
                    )
                if 'primary_key' in table_yaml:
                    table.primary_key = table_yaml['primary_key']
                if 'foreign_keys' in table_yaml:
                    for fk_name, fk_data in table_yaml['foreign_keys'].items():
                        table.add_foreign_key(ForeignKeyMetadata(
                            name=fk_name,
                            table=TableAddress(database_name, fk_data['references']['schema'], fk_data['references']['table']),
                            native_columns=fk_data['columns'],
                            foreign_columns=fk_data['references']['columns']
                        ))
                if 'next_etls' in table_yaml:
                    table.next_etls = table_yaml['next_etls']
                schema.add_table(table)
    return data_warehouse


def get_subdir_paths_with_prefix(root_dir: str, prefix: str) -> List[str]:
    return [item for item in glob.glob(os.path.join(root_dir, f'{prefix}.*')) if os.path.isdir(item)]


def get_yaml_paths_with_prefix(root_dir: str, prefix: str) -> List[str]:
    return [item for item in glob.glob(os.path.join(root_dir, f'{prefix}.*.yaml')) if os.path.isfile(item)]


def strip_dot_prefix(s: str) -> str:
    """Returns the given string with the dot-separated prefix removed (if one existed). E.g. 'a.b.c' -> 'b.c'"""
    return '.'.join((s.split('.')[1:]))


def read_yaml_file(filepath: str) -> dict:
    with open(filepath, 'r') as file:
        return yaml.safe_load(file)


def strip_dot_prefix_and_suffix(s: str) -> str:
    """Returns the given string with dot-separated prefix and suffix removed (if any exist). E.g. 'a.b.c' -> 'b'"""
    return '.'.join((s.split('.')[1:-1]))


class InvalidTableYAMLFileException(Exception):
    pass
