import pathlib
import glob
import os
import yaml
from typing import List

from lib.metadata_core.data_warehouse_metadata import (DataWarehouseMetadata,
                                                       DatabaseMetadata,
                                                       SchemaMetadata,
                                                       TableMetadata,
                                                       ColumnMetadata,
                                                       ETLMetadata,
                                                       ForeignKeyMetadata,
                                                       ForeignColumnPath,
                                                       TableAddress,
                                                       ETLDataSource,
                                                       ETLInputType,
                                                       ETLOutputType)


def generate_data_warehouse_metadata_from_yaml(root_dir_file_path: str) -> DataWarehouseMetadata:
    return construct_data_warehouse_metadata_from_dict(read_data_warehouse_yaml_files_into_dict(root_dir_file_path))


def read_data_warehouse_yaml_files_into_dict(root_dir_file_path: str) -> dict:
    if not os.path.isdir(root_dir_file_path):
        raise FileNotFoundError(f'{root_dir_file_path} is not a valid directory path')
    data_warehouse_name = pathlib.PurePath(root_dir_file_path).name
    data_warehouse_dict = {'name': data_warehouse_name, 'databases': []}
    for db_subdir_path in get_subdir_paths_with_prefix(root_dir_file_path, 'db'):
        database_name = strip_dot_prefix(pathlib.PurePath(db_subdir_path).name)
        database_dict = {'name': database_name, 'schemas': []}
        data_warehouse_dict['databases'].append(database_dict)
        for schema_subdir_path in get_subdir_paths_with_prefix(db_subdir_path, 'schema'):
            schema_name = strip_dot_prefix(pathlib.PurePath(schema_subdir_path).name)
            schema_dict = {'name': schema_name, 'tables': []}
            database_dict['schemas'].append(schema_dict)
            for table_yaml_path in get_yaml_paths_with_prefix(schema_subdir_path, 'table'):
                table_dict = read_yaml_file(table_yaml_path)
                schema_dict['tables'].append(table_dict)
    return data_warehouse_dict


def construct_data_warehouse_metadata_from_dict(data_warehouse_dict: dict) -> DataWarehouseMetadata:
    data_warehouse_metadata = DataWarehouseMetadata(data_warehouse_dict['name'])
    for database_dict in data_warehouse_dict['databases']:
        database_metadata = DatabaseMetadata(database_dict['name'])
        data_warehouse_metadata.add_database(database_metadata)
        for schema_dict in database_dict['schemas']:
            schema_metadata = SchemaMetadata(schema_dict['name'])
            database_metadata.add_schema(schema_metadata)
            for table_dict in schema_dict['tables']:
                table_metadata = construct_table_metadata_from_dict(table_dict, schema_metadata.name, database_metadata.name)
                schema_metadata.add_table(table_metadata)
    return data_warehouse_metadata


def construct_table_metadata_from_dict(table_dict: dict, schema_name: str, database_name: str) -> TableMetadata:
    table = TableMetadata(name=table_dict['name'], schema_name=schema_name, database_name=database_name)
    if 'primary_source_table' in table_dict:
        if not table_dict['primary_source_table'] or table_dict['primary_source_table'].count('.') != 2:
            raise InvalidTableMetadataException(
                f'Primary source table for table "{table_dict["name"]}" is not in the format "database.schema.table"'
            )
        source_table_components = table_dict['primary_source_table'].split('.')
        table.primary_source_table = TableAddress(
            database=source_table_components[0],
            schema=source_table_components[1],
            table=source_table_components[2]
        )
    table.primary_key = table_dict.get('primary_key')
    if 'foreign_keys' in table_dict:
        for fk_name, fk_data in table_dict['foreign_keys'].items():
            if 'columns' not in fk_data or 'references' not in fk_data or 'schema' not in fk_data['references'] or \
                    'table' not in fk_data['references']:
                raise InvalidTableMetadataException(f'Foreign key "{fk_name}" is missing one or more required metadata fields')
            table.add_foreign_key(ForeignKeyMetadata(
                name=fk_name,
                table=TableAddress(
                    database_name,
                    fk_data['references']['schema'],
                    fk_data['references']['table']
                ),
                native_columns=fk_data['columns'],
                foreign_columns=fk_data['references']['columns']
            ))
    if 'columns' in table_dict:
        for column_name, column_data in table_dict['columns'].items():
            column_metadata = ColumnMetadata(
                name=column_name,
                data_type=column_data.get('data_type')
            )
            if 'source' in column_data and 'field' in column_data['source']:
                column_metadata.source_field = parse_foreign_column_path(column_data['source']['field'])
            table.add_column(column_metadata)
    if 'etls' in table_dict:
        for etl_process_name, etl_data in table_dict['etls'].items():
            if 'hardcoded_data_source' not in etl_data or 'input_type' not in etl_data or 'output_type' not in etl_data:
                raise InvalidTableMetadataException(f'ETL "{etl_process_name}" is missing one or more required metadata fields')
            table.add_etl(ETLMetadata(
                process_name=etl_process_name,
                hardcoded_data_source=parse_etl_data_source(etl_data.get('hardcoded_data_source')),
                input_type=parse_etl_input_type(etl_data.get('input_type')),
                output_type=parse_etl_output_type(etl_data.get('output_type')),
                json_output_field=etl_data.get('json_output_field'),
                truncate_table=etl_data.get('truncate_table'),
                insert_update_keys=etl_data.get('insert_update_keys'),
                delete_keys=etl_data.get('delete_keys'),
                input_sql=etl_data.get('input_sql')
            ))
    if 'next_etls' in table_dict:
        for process_name in table_dict['next_etls']:
            table.next_etls.append(process_name)
    return table


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


def parse_foreign_column_path(path: str) -> ForeignColumnPath:
    if not path or not path.startswith('primary_source_table') or path.count('.') < 2 or path.count('.') % 2 == 1:
        raise InvalidTableMetadataException(f'Source field path "{path}" could not be parsed')
    split_path = path.split('.')
    fk_path = []
    for i in range(1, len(split_path), 2):
        if split_path[i] == 'foreign_keys':
            if i == len(split_path) - 2:  # reached the end of the path without encountering "columns"
                raise InvalidTableMetadataException(f'Source field path "{path}" could not be parsed')
            fk_path.append(split_path[i + 1])
        elif split_path[i] == 'columns':
            if i != len(split_path) - 2:  # "columns" is not the last thing in the path
                raise InvalidTableMetadataException(f'Source field path "{path}" could not be parsed')
            return ForeignColumnPath(fk_path, split_path[i + 1])
        else:
            raise InvalidTableMetadataException(f'Source field path "{path}" could not be parsed')


def parse_etl_data_source(raw_data_source: str) -> ETLDataSource:
    if raw_data_source.lower() == 'octane':
        return ETLDataSource.OCTANE
    else:
        raise InvalidTableMetadataException(f'Invalid ETL data source: {raw_data_source}')


def parse_etl_input_type(raw_input_type: str) -> ETLInputType:
    if raw_input_type.lower() == 'table':
        return ETLInputType.TABLE
    else:
        raise InvalidTableMetadataException(f'Invalid ETL input type: {raw_input_type}')


def parse_etl_output_type(raw_output_type: str) -> ETLOutputType:
    if raw_output_type.lower() == 'insert':
        return ETLOutputType.INSERT
    else:
        raise InvalidTableMetadataException(f'Invalid ETL output type: {raw_output_type}')


class InvalidTableMetadataException(Exception):
    pass
