from enum import Enum
from dataclasses import dataclass
from typing import List


@dataclass
class TableAddress:
    database: str
    schema: str
    table: str


@dataclass
class ForeignColumnPath:
    fk_steps: List[str]
    column_name: str


@dataclass
class ForeignKeyMetadata:
    name: str
    table: TableAddress
    native_columns: List[str]
    foreign_columns: List[str]


class ETLDataSource(Enum):
    OCTANE = 1


class ETLInputType(Enum):
    TABLE = 'table'


class ETLOutputType(Enum):
    INSERT = 'insert'


@dataclass
class ETLMetadata:
    process_name: str
    hardcoded_data_source: ETLDataSource = ETLDataSource.OCTANE
    input_type: ETLInputType = ETLInputType.TABLE
    output_type: ETLOutputType = ETLOutputType.INSERT
    json_output_field: str = None
    truncate_table: bool = None
    insert_update_keys: List[str] = None
    delete_keys: List[str] = None
    input_sql: str = None


@dataclass
class ColumnMetadata:
    name: str
    data_type: str = None
    source_field: ForeignColumnPath = None


class TableMetadata:

    def __init__(self, name: str, schema_name: str = None, database_name: str = None, primary_source_table: TableAddress = None):
        self.name = name
        self.schema_name = schema_name
        self.database_name = database_name
        self.primary_source_table = primary_source_table
        self.primary_key = []
        self.next_etls = []
        self._columns = {}
        self._etls = {}
        self._foreign_keys = {}

    def add_column(self, column: ColumnMetadata):
        self._columns[column.name] = column

    def add_etl(self, etl: ETLMetadata):
        self._etls[etl.process_name] = etl

    def add_foreign_key(self, foreign_key: ForeignKeyMetadata):
        self._foreign_keys[foreign_key.name] = foreign_key

    def get_column(self, column_name: str) -> ColumnMetadata:
        if column_name not in self._columns:
            raise InvalidMetadataKeyException('table', self.name, 'column', column_name)
        else:
            return self._columns[column_name]

    def get_etl(self, etl_process_name: str) -> ETLMetadata:
        if etl_process_name not in self._etls:
            raise InvalidMetadataKeyException('table', self.name, 'etl', etl_process_name)
        else:
            return self._etls[etl_process_name]

    def get_foreign_key(self, foreign_key_name: str) -> ETLMetadata:
        if foreign_key_name not in self._foreign_keys:
            raise InvalidMetadataKeyException('table', self.name, 'foreign_key', foreign_key_name)
        else:
            return self._foreign_keys[foreign_key_name]

    def remove_column_metadata(self, column_name: str):
        if column_name in self._columns:
            del self._columns[column_name]

    def remove_etl_metadata(self, etl_name: str):
        if etl_name in self._etls:
            del self._etls[etl_name]

    def remove_foreign_key_metadata(self, foreign_key_name: str):
        if foreign_key_name in self._foreign_keys:
            del self._foreign_keys[foreign_key_name]

    @property
    def columns(self) -> List[ColumnMetadata]:
        return list(self._columns.values())

    @property
    def etls(self) -> List[ETLMetadata]:
        return list(self._etls.values())

    @property
    def foreign_keys(self) -> List[ForeignKeyMetadata]:
        return list(self._foreign_keys.values())

    @property
    def address(self) -> TableAddress:
        return TableAddress(
            database=self.database_name,
            schema=self.schema_name,
            table=self.name
        )

    def __repr__(self) -> str:
        return f'TableMetadata(\n' \
               f'    name={self.name},\n' \
               f'    schema_name={self.schema_name}\n' \
               f'    database_name={self.database_name}\n' \
               f'    primary_source_table={repr(self.primary_source_table)}\n' \
               f'    foreign_keys={repr(self.foreign_keys)}\n' \
               f'    columns={repr(self.columns)}\n' \
               f'    etls={repr(self.etls)}\n' \
               f'    next_etls={repr(self.next_etls)}\n' \
               f')'

    def __eq__(self, other: 'TableMetadata') -> bool:
        return isinstance(other, TableMetadata) and \
               self.name == other.name and \
               self.schema_name == other.schema_name and \
               self.database_name == other.database_name and \
               self.primary_source_table == other.primary_source_table and \
               self.foreign_keys == other.foreign_keys and \
               self.columns == other.columns and \
               self.etls == other.etls and \
               self.next_etls == other.next_etls


class SchemaMetadata:

    def __init__(self, name: str):
        self.name = name
        self._tables = {}

    def add_table(self, table: TableMetadata):
        self._tables[table.name] = table

    def get_table(self, table_name: str) -> TableMetadata:
        if table_name not in self._tables:
            raise InvalidMetadataKeyException('schema', self.name, 'table', table_name)
        else:
            return self._tables[table_name]

    def remove_table_metadata(self, table_name: str):
        if table_name in self._tables:
            del self._tables[table_name]

    @property
    def tables(self) -> List[TableMetadata]:
        return list(self._tables.values())

    def __repr__(self) -> str:
        return f'SchemaMetadata(\n' \
               f'    name={self.name},\n' \
               f'    tables={generate_collection_repr(self.tables)}'

    def __eq__(self, other: 'SchemaMetadata') -> bool:
        return isinstance(other, SchemaMetadata) and \
               self.name == other.name and \
               self._tables == other._tables


class DatabaseMetadata:

    def __init__(self, name: str):
        self.name = name
        self._schemas = {}

    def add_schema(self, schema: SchemaMetadata):
        self._schemas[schema.name] = schema

    def get_schema(self, schema_name: str) -> SchemaMetadata:
        if schema_name not in self._schemas:
            raise InvalidMetadataKeyException('database', self.name, 'schema', schema_name)
        else:
            return self._schemas[schema_name]

    def remove_schema_metadata(self, schema_name: str):
        if schema_name in self._schemas:
            del self._schemas[schema_name]

    @property
    def schemas(self) -> List[SchemaMetadata]:
        return list(self._schemas.values())

    def __repr__(self) -> str:
        return f'DatabaseMetadata(\n' \
               f'    name={self.name},\n' \
               f'    schemas={generate_collection_repr(self.schemas)}'

    def __eq__(self, other: 'DatabaseMetadata') -> bool:
        return isinstance(other, DatabaseMetadata) and \
               self.name == other.name and \
               self._schemas == other._schemas


class DataWarehouseMetadata:

    def __init__(self, name: str):
        self.name = name
        self._databases = {}

    def add_database(self, database: DatabaseMetadata):
        self._databases[database.name] = database

    def get_database(self, database_name: str) -> DatabaseMetadata:
        if database_name not in self._databases:
            raise InvalidMetadataKeyException('data warehouse', self.name, 'database', database_name)
        else:
            return self._databases[database_name]

    def remove_database_metadata(self, database_name: str):
        if database_name in self._databases:
            del self._databases[database_name]

    @property
    def databases(self) -> List[DatabaseMetadata]:
        return list(self._databases.values())

    def __repr__(self) -> str:
        return f'DataWarehouseMetadata(\n' \
               f'    name={self.name},\n' \
               f'    databases={generate_collection_repr(self.databases)}'

    def __eq__(self, other: 'DataWarehouseMetadata') -> bool:
        return isinstance(other, DataWarehouseMetadata) and \
               self.name == other.name and \
               self._databases == other._databases


class InvalidMetadataKeyException(Exception):
    def __init__(self, parent_entity_type: str, parent_name: str, child_entity_type: str, child_name: str, ):
        super().__init__(f'{child_entity_type} "{child_name}" does not exist in {parent_entity_type} "{parent_name}"')


def indent_multiline_str(s: str, indent: int = 4) -> str:
    return '\n'.join([' ' * indent + line for line in s.split('\n')])

def generate_collection_repr(collection: list) -> str:
    reprs = "\n".join([indent_multiline_str(repr(item), indent=8) for item in collection])
    return f'[\n{reprs}\n]'
