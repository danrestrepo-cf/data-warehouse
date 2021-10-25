"""A collection of functions and classes that convert between DataWarehouseMetadata structures and YAML files

Public Functions:
- generate_data_warehouse_metadata_from_yaml
    - reads in existing YAML files and constructs an in-memory DataWarehouseMetadata object for further manipulation
- write_data_warehouse_metadata_to_yaml
    - writes YAML files and their containing directory structure from a given DataWarehouseMetadata object
- construct_data_warehouse_metadata_from_dict
    - creates a DataWarehouseMetadata object from a dictionary structure that mirrors the standard directory and YAML structure
    - this method is mainly useful for unit testing, as it provides an easy-to-read way of building an entire DataWarehouseMetadata
      structure at once.

The directory structure that this module reads from/writes to is as follows:
- data warehouse directory
    - database directory (prefixed with “db.”)
        - schema directory (prefixed with “schema.”)
            - YAML files for each table in the schema (prefixed with “table.”)

For example:
- edw
    - db.staging
        - schema.history_octane
            - table.account.yaml
            - table.account_contact.yaml
            - ...

Each table.*.yaml file conforms to the following structure:

name: table_name
primary_source_table: database.schema.source_table_name
primary_key:
  - pk_column_1
# - etc...
foreign_keys:
  t1_c2_fkey:
    columns:
      - c2
    references:
      columns:
        - c21
      schema: s1
      table: t2
columns:
  column_1:
    data_type: data_type_name (e.g. bigint)
    source:  # only used for history_octane metadata
      field: primary_source_table.foreign_keys.t1_c2_fkey.columns.column_name
  column_2:
    data_type: data_type_name (e.g. bigint)
    source:  # only used for history_octane metadata
      field: primary_source_table.columns.column2
# etc…
etls:  # only used for history_octane metadata
  SP-xxxxxx:
    hardcoded_data_source: Octane
    input_type: table  # or CSV, EXCEL, etc
    output_type: insert
    json_output_field: column_1
    # - etc
    truncate_table: false  # for insert
    insert_update_keys: # for insert update
      - column_1
      - etc
    #      - etc…
    delete_keys: # for delete
      - column_1
    input_sql: |  # for table input_type
      SELECT *
      FROM schema.source_table_name
  # etc…
next_etls:
  - SP-yyyyyy
  - SP-zzzzzz
"""
import pathlib
import glob
import os
import shutil
import yaml
from typing import List, Optional

from lib.metadata_core.data_warehouse_metadata import (DataWarehouseMetadata,
                                                       DatabaseMetadata,
                                                       SchemaMetadata,
                                                       TableMetadata,
                                                       ColumnMetadata,
                                                       ETLMetadata,
                                                       ForeignKeyMetadata,
                                                       ForeignColumnPath,
                                                       ETLDataSource,
                                                       ETLInputType,
                                                       ETLOutputType)
from lib.metadata_core.metadata_object_path import TablePath


# enable PyYAML to gracefully output multi-line string values (e.g. ETL SQL queries)
# https://stackoverflow.com/a/33300001/15696521
def str_presenter(dumper, data):
    if len(data.splitlines()) > 1:  # check for multiline string
        return dumper.represent_scalar('tag:yaml.org,2002:str', data, style='|')
    return dumper.represent_scalar('tag:yaml.org,2002:str', data)


yaml.add_representer(str, str_presenter)


# public functions

def generate_data_warehouse_metadata_from_yaml(root_dir_file_path: str) -> DataWarehouseMetadata:
    """Generate a DataWarehouseMetadata object by reading and parsing a metadata directory/file structure with the given root path."""
    return MetadataReader(root_dir_file_path).read()


def write_data_warehouse_metadata_to_yaml(parent_dir_file_path: str, metadata: DataWarehouseMetadata,
                                          rebuild_data_warehouse_dir: bool = False, rebuild_database_dirs: bool = False,
                                          rebuild_schema_dirs: bool = False, rebuild_table_files: bool = False):
    """Write the contents of a DataWarehouseMetadata object to a directory structure/series of YAML files.

    The four "rebuild_*" arguments to this function allow the user to specify which elements of any existing
    directory/file structure should be completely deleted *before* writing any new output. This is useful
    for propagating metadata deletions on to the YAML directories/files. It is important to note that,
    if a given metadata hierarchy level (e.g. databases, tables, etc) is flagged for deleting/rebuilding,
    only objects that are common to both the existing directory contents and the DataWarehouseMetadata object
    will be considered for deletion.

    Example scenario:

    The given DataWarehouseMetadata has the following structure:
    - edw
        - staging
            - staging_octane
                - loan
                - deal

    And the directory structure currently consists of:
    - edw
        - staging
            - staging_octane
                - loan
                - proposal
            - star_loan
                - loan_fact
        - ingress
            - dmi
                - table1

    executing write_data_warehouse_metadata_to_yaml('parent/dir/path', metadata, rebuild_table_files=True)
    will result in the following directory structure:
    - edw
        - staging
            - staging_octane
                - loan
                - deal
            - star_loan
                - loan_fact
        - ingress
            - dmi
                - table1

    Since rebuild_table_files was set to True, all tables *within schemas already present in both the files and the
    DataWarehouseMetadata object* were deleted, and then re-populated by this function. As a result, only the tables
    in the staging.staging_octane schema were rebuilt: the "proposal" table (in file, not in metadata object) was deleted,
    the "deal" table (in metadata object, not in file) was created, and the "loan" table was simply recreated. Tables in
    schemas *other* than staging.staging_octane were unaffected, because those schemas weren't included in the DataWarehouseMetadata
    object being written. This functionality allows users to account for inserts, updates, *and* deletes within a small subsection
    of the overall metadata directory structure without wiping out the entire thing (though wiping out the entire thing is still
    an option via the rebuild_data_warehouse_dir argument).

    :param parent_dir_file_path: the directory into which the metadata directory structure should be written. This should
    be the directory that will *contain* the top-level data warehouse directory, not the data warehouse directory itself.
    e.g. data-warehouse/metadata, not data-warehouse/metadata/edw
    :param metadata: the metadata to be written
    :param rebuild_data_warehouse_dir: whether or not to wipe out the existing data warehouse metadata directories/files
    and rebuild them from scratch
    :param rebuild_database_dirs: whether or not to wipe out the existing database metadata directories/files
    and rebuild them from scratch
    :param rebuild_schema_dirs: whether or not to wipe out the existing schema directories/files
    within any databases present in the given metadata and rebuild them from scratch
    :param rebuild_table_files: whether or not to wipe out the existing table metadata files
    within any schemas present in the given metadata and rebuild them from scratch
    """
    writer = MetadataWriter(parent_dir_file_path=parent_dir_file_path,
                            rebuild_data_warehouse_dir=rebuild_data_warehouse_dir,
                            rebuild_database_dirs=rebuild_database_dirs,
                            rebuild_schema_dirs=rebuild_schema_dirs,
                            rebuild_table_files=rebuild_table_files)
    writer.write(metadata)


def construct_data_warehouse_metadata_from_dict(data_warehouse_dict: dict) -> DataWarehouseMetadata:
    """Construct a DataWarehouseMeatadata object from a dict comparable to the YAML directory/file structure described above.

    Dict structure example:
    {
        'name': 'data-warehouse-name',
        'databases': [
            {
                'name': 'database-name',
                'schemas': [
                    {
                        'name': 'schema-name',
                        'tables': [
                            {
                                'name': 't1',
                                'primary_source_table': 'db2.sch2.t2',
                                'primary_key': [
                                    'col1', 'col2'
                                ],
                                'foreign_keys': {
                                    'fk1': {
                                        'columns': ['col3'],
                                        'references': {
                                            'columns': ['col3'],
                                            'schema': 'sch2',
                                            'table': 't2'
                                        }
                                    }
                                },
                                'columns': {
                                    'col1': {
                                        'data_type': 'TEXT',
                                        'source': {
                                            'field': 'primary_source_table.foreign_keys.fk3.foreign_keys.fk67.columns.col1'
                                        }
                                    }
                                },
                                'etls': {
                                    'SP-1': {
                                        'hardcoded_data_source': 'Octane',
                                        'input_type': 'table',
                                        'output_type': 'insert',
                                        'json_output_field': 'col1',
                                        'truncate_table': False,
                                        'insert_update_keys': ['col1', 'col2'],
                                        'delete_keys': ['col2', 'col3'],
                                        'input_sql': 'SQL for SP-1'
                                    }
                                },
                                'next_etls': [
                                    'SP-4', 'SP-5'
                                ]
                            }
                        ]
                    }
                ]
            }
        ]
    }
    """
    return DictToMetadataBuilder().build_metadata(data_warehouse_dict)


# internal classes/functions

class DictToMetadataBuilder:
    """A collection of functionality related to constructing a DataWarehouseMetadata object from a dictionary."""

    def build_metadata(self, data_warehouse_dict: dict) -> DataWarehouseMetadata:
        """Construct a DataWarehouseMetadata object from the given dictionary."""
        data_warehouse_metadata = DataWarehouseMetadata(data_warehouse_dict['name'])
        if 'databases' in data_warehouse_dict:
            for database_dict in data_warehouse_dict['databases']:
                database_metadata = DatabaseMetadata(database_dict['name'])
                data_warehouse_metadata.add_database(database_metadata)
                if 'schemas' in database_dict:
                    for schema_dict in database_dict['schemas']:
                        schema_metadata = SchemaMetadata(schema_dict['name'])
                        database_metadata.add_schema(schema_metadata)
                        if 'tables' in schema_dict:
                            for table_dict in schema_dict['tables']:
                                table_metadata = self.construct_table_metadata_from_dict(
                                    table_dict=table_dict,
                                    schema_name=schema_metadata.name,
                                    database_name=database_metadata.name
                                )
                                schema_metadata.add_table(table_metadata)
        return data_warehouse_metadata

    def construct_table_metadata_from_dict(self, table_dict: dict, schema_name: str, database_name: str) -> TableMetadata:
        """Construct a TableMetadata object from the given dictionary."""
        table = TableMetadata(name=table_dict['name'])
        table.path.database = database_name
        table.path.schema = schema_name
        if 'primary_source_table' in table_dict:
            if not table_dict['primary_source_table'] or table_dict['primary_source_table'].count('.') != 2:
                raise self.InvalidTableMetadataException(
                    f'Primary source table for table "{table_dict["name"]}" is not in the format "database.schema.table"'
                )
            source_table_components = table_dict['primary_source_table'].split('.')
            table.primary_source_table = TablePath(
                database=source_table_components[0],
                schema=source_table_components[1],
                table=source_table_components[2]
            )
        if 'primary_key' in table_dict:
            for key_field in table_dict['primary_key']:
                table.primary_key.append(key_field)
        if 'foreign_keys' in table_dict:
            for fk_name, fk_data in table_dict['foreign_keys'].items():
                if 'columns' not in fk_data or 'references' not in fk_data or 'schema' not in fk_data['references'] or \
                        'table' not in fk_data['references']:
                    raise self.InvalidTableMetadataException(f'Foreign key "{fk_name}" is missing one or more required metadata fields')
                table.add_foreign_key(ForeignKeyMetadata(
                    name=fk_name,
                    table=TablePath(
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
                    column_metadata.source_field = self.parse_foreign_column_path(column_data['source']['field'])
                table.add_column(column_metadata)
        if 'etls' in table_dict:
            for etl_process_name, etl_data in table_dict['etls'].items():
                if 'input_type' not in etl_data or 'output_type' not in etl_data:
                    raise self.InvalidTableMetadataException(f'ETL "{etl_process_name}" is missing one or more required metadata fields')
                table.add_etl(ETLMetadata(
                    process_name=etl_process_name,
                    hardcoded_data_source=self.parse_etl_data_source(etl_data.get('hardcoded_data_source')),
                    input_type=self.parse_etl_input_type(etl_data.get('input_type')),
                    output_type=self.parse_etl_output_type(etl_data.get('output_type')),
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

    def parse_foreign_column_path(self, path: str) -> ForeignColumnPath:
        """Construct a ForeignColumnPath object from the given foreign path string.

        A valid string is in the format:

            primary_source_table.[foreign_keys.fk_name1.foreign_keys.fk_name2...].columns.foreign_column_name

        For example, the path:

            primary_source_table.foreign_keys.fk1.foreign_keys.fk2.columns.col1

        Would be parsed into the following object:

            ForeignColumnPath(
                fk_steps = ['fk1', 'fk2'],
                column_name = 'col1'
            )
        """
        if not path or not path.startswith('primary_source_table') or path.count('.') < 2 or path.count('.') % 2 == 1:
            raise self.InvalidTableMetadataException(f'Source field path "{path}" could not be parsed')
        split_path = path.split('.')
        fk_path = []
        for i in range(1, len(split_path), 2):
            if split_path[i] == 'foreign_keys':
                if i == len(split_path) - 2:  # reached the end of the path without encountering "columns"
                    raise self.InvalidTableMetadataException(f'Source field path "{path}" could not be parsed')
                fk_path.append(split_path[i + 1])
            elif split_path[i] == 'columns':
                if i != len(split_path) - 2:  # "columns" is not the last thing in the path
                    raise self.InvalidTableMetadataException(f'Source field path "{path}" could not be parsed')
                return ForeignColumnPath(fk_path, split_path[i + 1])
            else:
                raise self.InvalidTableMetadataException(f'Source field path "{path}" could not be parsed')

    def parse_etl_data_source(self, raw_data_source: Optional[str]) -> Optional[ETLDataSource]:
        """Parse the given string into an ETLDataSource Enum value."""
        if raw_data_source is None:
            return None
        if raw_data_source.lower() == 'octane':
            return ETLDataSource.OCTANE
        else:
            raise self.InvalidTableMetadataException(f'Invalid ETL data source: {raw_data_source}')

    def parse_etl_input_type(self, raw_input_type: str) -> ETLInputType:
        """Parse the given string into an ETLInputType Enum value."""
        if raw_input_type.lower() == 'table':
            return ETLInputType.TABLE
        else:
            raise self.InvalidTableMetadataException(f'Invalid ETL input type: {raw_input_type}')

    def parse_etl_output_type(self, raw_output_type: str) -> ETLOutputType:
        """Parse the given string into an ETLOutputType Enum value."""
        if raw_output_type.lower() == 'insert':
            return ETLOutputType.INSERT
        else:
            raise self.InvalidTableMetadataException(f'Invalid ETL output type: {raw_output_type}')

    class InvalidTableMetadataException(Exception):
        pass


class MetadataReader:
    """A collection of functionality related to reading YAML files into a DataWarehouseMetadata object."""

    def __init__(self, root_dir_file_path: str):
        self.root_dir_file_path = root_dir_file_path
        self.dict_to_metadata_builder = DictToMetadataBuilder()

    def read(self):
        """Read a metadata directory/file structure like the one described above into a DataWarehouseMetadata object."""
        return self.dict_to_metadata_builder.build_metadata(self.read_data_warehouse_yaml_files_into_dict())

    def read_data_warehouse_yaml_files_into_dict(self) -> dict:
        """Read a metadata directory/file structure like the one described above into a dictionary."""
        if not os.path.isdir(self.root_dir_file_path):
            raise FileNotFoundError(f'{self.root_dir_file_path} is not a valid directory path')
        data_warehouse_name = pathlib.PurePath(self.root_dir_file_path).name
        data_warehouse_dict = {'name': data_warehouse_name, 'databases': []}
        for db_subdir_path in get_subdir_paths_with_prefix(self.root_dir_file_path, 'db'):
            database_name = self.strip_dot_prefix(pathlib.PurePath(db_subdir_path).name)
            database_dict = {'name': database_name, 'schemas': []}
            data_warehouse_dict['databases'].append(database_dict)
            for schema_subdir_path in get_subdir_paths_with_prefix(db_subdir_path, 'schema'):
                schema_name = self.strip_dot_prefix(pathlib.PurePath(schema_subdir_path).name)
                schema_dict = {'name': schema_name, 'tables': []}
                database_dict['schemas'].append(schema_dict)
                for table_yaml_path in get_yaml_paths_with_prefix(schema_subdir_path, 'table'):
                    table_dict = self.read_yaml_file(table_yaml_path)
                    schema_dict['tables'].append(table_dict)
        return data_warehouse_dict

    @staticmethod
    def strip_dot_prefix(s: str) -> str:
        """Returns the given string with the dot-separated prefix removed (if one existed). E.g. 'a.b.c' -> 'b.c'"""
        return '.'.join((s.split('.')[1:]))

    @staticmethod
    def read_yaml_file(filepath: str) -> dict:
        """Read a YAML file to a dictionary."""
        with open(filepath, 'r') as file:
            return yaml.safe_load(file)


class MetadataWriter:
    """A collection of functionality related to writing DataWarehouseMetadata objects to YAML files."""

    def __init__(self, parent_dir_file_path: str, rebuild_data_warehouse_dir: bool, rebuild_database_dirs: bool,
                 rebuild_schema_dirs: bool, rebuild_table_files: bool):
        self.parent_dir_file_path = parent_dir_file_path
        self.rebuild_data_warehouse_dir = rebuild_data_warehouse_dir
        self.rebuild_database_dirs = rebuild_database_dirs
        self.rebuild_schema_dirs = rebuild_schema_dirs
        self.rebuild_table_files = rebuild_table_files

    def write(self, metadata: DataWarehouseMetadata):
        """Write the given DataWarehouseMetadata object to the directory/file structure described above."""
        root_dir = os.path.join(self.parent_dir_file_path, metadata.name)
        if self.rebuild_data_warehouse_dir:
            self.recursively_delete_dir_contents(root_dir)
        self.make_dir_if_not_exists(root_dir)
        for database in metadata.databases:
            database_dir = os.path.join(root_dir, f'db.{database.name}')
            if self.rebuild_database_dirs:
                self.recursively_delete_dir_contents(database_dir)
            self.make_dir_if_not_exists(database_dir)
            for schema in database.schemas:
                schema_dir = os.path.join(database_dir, f'schema.{schema.name}')
                if self.rebuild_schema_dirs:
                    self.recursively_delete_dir_contents(schema_dir)
                self.make_dir_if_not_exists(schema_dir)
                if self.rebuild_table_files:
                    table_files = get_yaml_paths_with_prefix(schema_dir, 'table')
                    for table_file in table_files:
                        os.remove(table_file)
                for table in schema.tables:
                    table_yaml_dict = filter_out_dict_keys_with_no_value(self.create_yaml_dict_from_table_metadata(table))
                    table_file_path = os.path.join(schema_dir, f'table.{table.name}.yaml')
                    self.write_table_metadata_yaml_file(table_file_path, table_yaml_dict)

    @staticmethod
    def make_dir_if_not_exists(dir_path: str):
        if not os.path.isdir(dir_path):
            os.mkdir(dir_path)

    @staticmethod
    def recursively_delete_dir_contents(dir_path: str):
        """Delete the directory with the given path and all of its contents."""
        if os.path.isdir(dir_path):
            shutil.rmtree(dir_path)

    def create_yaml_dict_from_table_metadata(self, table_metadata: TableMetadata) -> dict:
        """Convert a TableMetadata object to a dict in preparation for writing it to YAML."""
        # the order in which these fields are set here determines the order in which they appear in the YAML file
        return {
            'name': table_metadata.name,
            'primary_source_table': self.table_path_to_string(table_metadata.primary_source_table),
            'primary_key': table_metadata.primary_key,
            'foreign_keys': {foreign_key.name: {
                'columns': foreign_key.native_columns,
                'references': {
                    'columns': foreign_key.foreign_columns,
                    'schema': foreign_key.table.schema,
                    'table': foreign_key.table.table
                }
            } for foreign_key in table_metadata.foreign_keys},
            'columns': {column.name: self.column_metadata_to_dict(column) for column in table_metadata.columns},
            'etls': {etl.process_name: {
                'hardcoded_data_source': self.hardcoded_data_source_to_str(etl.hardcoded_data_source),
                'input_type': etl.input_type.value,
                'output_type': etl.output_type.value,
                'json_output_field': etl.json_output_field,
                'truncate_table': etl.truncate_table,
                'insert_update_keys': etl.insert_update_keys,
                'delete_keys': etl.delete_keys,
                'input_sql': etl.input_sql
            } for etl in table_metadata.etls},
            'next_etls': table_metadata.next_etls
        }

    @staticmethod
    def table_path_to_string(table_path: Optional[TablePath]) -> Optional[str]:
        """Construct a string representation of a TablePath in preparation for writing it to YAML."""
        if table_path is None:
            return None
        else:
            return f'{table_path.database}.{table_path.schema}.{table_path.table}'

    @staticmethod
    def column_metadata_to_dict(column_metadata: ColumnMetadata) -> dict:
        """Convert a ColumnMetadata object to a dict in preparation for writing it to YAML."""
        column_dict = {
            'data_type': column_metadata.data_type
        }
        if column_metadata.source_field is not None:
            source_field_string = 'primary_source_table'
            foreign_key_steps_string = '.'.join([f'foreign_keys.{fk_step}' for fk_step in column_metadata.source_field.fk_steps])
            if foreign_key_steps_string != '':
                source_field_string += f'.{foreign_key_steps_string}'
            source_field_string += f'.columns.{column_metadata.source_field.column_name}'
            column_dict['source'] = {
                'field': source_field_string
            }
        return column_dict

    @staticmethod
    def write_table_metadata_yaml_file(output_file_path: str, metadata: dict):
        """Write the given metadata dict to a YAML file."""
        with open(output_file_path, 'w') as output_file:
            yaml.dump(metadata, output_file, default_flow_style=False, sort_keys=False)

    @staticmethod
    def hardcoded_data_source_to_str(data_source: Optional[ETLDataSource]) -> Optional[str]:
        """Map a ETLDataSource Enum value to a string so that it can be written to a file."""
        if data_source is None:
            return None
        elif data_source == ETLDataSource.OCTANE:
            return 'Octane'
        else:
            raise ValueError(f'Unable to convert {data_source} to string in order to write metadata to file. No mapping defined.')


def filter_out_dict_keys_with_no_value(d: dict) -> dict:
    """Remove all key-value pairs from the given dict that have no meaningful value.

    None, empty dicts, and empty lists all count as having "no meaningful value",
    in that there would be no reason to output them to a YAML file.
    """
    result = {}
    for key, value in d.items():
        if value == [] or value == {} or value is None:
            pass  # do nothing, don't add the value to the result
        elif type(value) is dict:
            result[key] = filter_out_dict_keys_with_no_value(value)
        else:
            result[key] = value
    return result


def get_subdir_paths_with_prefix(root_dir: str, prefix: str) -> List[str]:
    """Get a list of directory paths for all sub-directories of the given directory that have the given prefix."""
    return [item for item in glob.glob(os.path.join(root_dir, f'{prefix}.*')) if os.path.isdir(item)]


def get_yaml_paths_with_prefix(root_dir: str, prefix: str) -> List[str]:
    """Get a list of files paths for all files the given directory that have the given prefix."""
    return [item for item in glob.glob(os.path.join(root_dir, f'{prefix}.*.yaml')) if os.path.isfile(item)]
