"""A collection of classes that store hierarchical data warehouse metadata.

The class structure is as follows:
- DataWarehouseMetadata (top level)
    - has zero to many DatabaseMetadata
        - has zero to many SchemaMetadata
            - has zero to many TableMetadata
                - has zero to many ColumnMetadata
                    - has zero to one ForeignColumnPath
                - has zero to many ForeignKeyMetadata
                - has zero to many ETLMetadata

Each node in the hierarchy contains several standardized methods for accessing and
manipulating its child nodes:
- get_<object> (e.g. schema.get_table('account'))
    - return the child metadata object with the given name
- add_<object> (e.g. database.add_schema(SchemaMetadata('star_loan')))
    - add the given metadata object as a child of the current node
- remove_<object> (e.g. data_warehouse.remove_database('staging'))
    - remove the metadata object with the given name from the current node's children
- contains_<object> (e.g. table.contains_etl('SP-123456'))
    - return True if the current node has a child with the given name, False otherwise
- <objects> (e.g. table.columns)
    - a @property method that simply returns a list of child objects of the specified type
"""
from enum import Enum
from dataclasses import dataclass
from typing import List, Optional

from lib.metadata_core.metadata_object_path import DatabasePath, SchemaPath, TablePath, ColumnPath


@dataclass
class ForeignColumnPath:
    """A data structure describing the "path" to a column in another table.

    column_name is the name of the foreign column. fk_steps is a list of foreign
    key names along the path to the foreign column. If fk_steps is empty, then the
    "foreign" column (column_name) is in the starting table.

    For example:

    fk_steps = ['fk1', 'fk2', fk3']
    column_name = 'dest_column'

    To traverse this example path, start at the "home" table. If this path is valid,
    the "home" table should have a foreign key called "fk1". If "fk1" describes
    a join between the "home" table and table1, then (again, if the path is valid)
    we can expect table1 in turn to have a foreign key called "fk2". Let's say
    "fk2" describes a join to table2, and "fk3" describes a join between table2
    and table3. We should then expect table3 to contain "dest_column", since that
    is the last hop in the path.
    """
    fk_steps: List[str]
    column_name: str


@dataclass
class ForeignKeyMetadata:
    """Metadata describing a foreign key on a table.

    Attributes:
        name: the foreign key's name
        table: the name of the other table in the foreign key relationship
        native_columns: a list of the columns in *this* table that participate
        in the foreign key relationship
        foreign_columns: a list of the columns in the other table that participate
        in the foreign key relationship

    Native and Foreign columns are matched up in the order they appear in the lists,
    so in the following example:

    native_columns = ['a', 'b']
    foreign_columns = ['c', 'd']

    The corresponding join condition for this foreign key is implied to be:

    table.a = foreign_table.c AND table.b = foreign_table.d
    """
    name: str
    table: TablePath
    native_columns: List[str]
    foreign_columns: List[str]


class ETLDataSource(Enum):
    """An Enum of possible EDW data sources.

    The enum value corresponds to the data_source_dwid in EDW.
    """
    OCTANE = 1


class ETLInputType(Enum):
    """An Enum of possible Pentaho ETL input types."""
    TABLE = 'table'


class ETLOutputType(Enum):
    """An Enum of possible Pentaho ETL output types."""
    INSERT = 'insert'
    INSERT_UPDATE = 'insert_update'
    DELETE = 'delete'


@dataclass
class ETLMetadata:
    """Metadata describing an ETL that populates and/or maintains a table.

    Attributes:
        process_name: the name of the ETL's server process (e.g. SP-123456)
        hardcoded_data_source: the primary data source of this ETL, translated to
        a hardcoded dwid value in some EDW ETL processes
        input_type: the format of data to be read in as input to this ETL
        output_type: the type of action to be taken as the output of this ETL
        json_output_field: the key column to be used in the ETL's MDI-2 output json
        truncate_table: boolean indicating whether or not the ETL's target
        table should be truncated before insertion. Only used for ETLs with
        output_type INSERT
        insert_upate_keys: a list of table columns to be used an an insert/update key.
        Only used for ETLs with output_type INSERT_UPDATE
        delete_keys: a list of table columns to be used as a delete key. Only used
        for ETLs with output_type DELETE
        input_sql: the SQL statement used as input to the ETL. Only used for ETLs
        with input_type TABLE
    """
    process_name: str
    hardcoded_data_source: Optional[ETLDataSource] = None
    input_type: ETLInputType = ETLInputType.TABLE
    output_type: ETLOutputType = ETLOutputType.INSERT
    json_output_field: Optional[str] = None
    truncate_table: Optional[bool] = None
    insert_update_keys: Optional[List[str]] = None
    delete_keys: Optional[List[str]] = None
    input_sql: Optional[str] = None


@dataclass(init=False)
class ColumnMetadata:
    """Metadata describing a column in a table.

    Attributes:
        name: the column name
        data_type: the column's data type
        source_field: a ForeignColumnPath describing the location of the column's
        source field, starting from the table's primary_source_table
    """
    name: str
    data_type: Optional[str] = None
    source_field: Optional[ForeignColumnPath] = None

    def __init__(self, name: str, data_type: Optional[str] = None, source_field: Optional[ForeignColumnPath] = None):
        self.name = name
        self.path = ColumnPath(database=None, schema=None, table=None, column=name)
        self.data_type = data_type
        self.source_field = source_field


class TableMetadata:
    """A bottom-level metadata hierarchy node containing all metadata for a single table within it

    Attributes:
        name: the table name
        path: the path to this table in the metadata hierarchy
        primary_source_table: the path to this table's source table in the metadata hierarchy
        primary_key: a list of fields that constitue this table's primary key
        columns: a list of metadata objects describing the table's columns
        foreign_keys: a list of metadata objects describing the table's foreign_keys
        etls: a list of metadata objects describing ETLs that populate/maintain the table
        next_etls: a list of server processes to be triggered following any ETLs that maintain this table
    """

    def __init__(self, name: str, primary_source_table: Optional[TablePath] = None):
        self.name = name
        self.path = TablePath(database=None, schema=None, table=name)
        self.primary_source_table = primary_source_table
        self.primary_key = []
        self.next_etls = []
        self._columns = {}
        self._etls = {}
        self._foreign_keys = {}

    def add_column(self, column: ColumnMetadata):
        self._columns[column.name] = column
        column.path.database = self.path.database
        column.path.schema = self.path.schema
        column.path.table = self.name

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

    def get_foreign_key(self, foreign_key_name: str) -> ForeignKeyMetadata:
        if foreign_key_name not in self._foreign_keys:
            raise InvalidMetadataKeyException('table', self.name, 'foreign_key', foreign_key_name)
        else:
            return self._foreign_keys[foreign_key_name]

    def remove_column(self, column_name: str):
        if column_name in self._columns:
            del self._columns[column_name]

    def remove_etl(self, etl_name: str):
        if etl_name in self._etls:
            del self._etls[etl_name]

    def remove_foreign_key(self, foreign_key_name: str):
        if foreign_key_name in self._foreign_keys:
            del self._foreign_keys[foreign_key_name]

    def contains_column(self, column_name: str) -> bool:
        return column_name in self._columns

    def contains_etl(self, process_name: str) -> bool:
        return process_name in self._etls

    def contains_foreign_key(self, foreign_key_name: str) -> bool:
        return foreign_key_name in self._foreign_keys

    def get_column_source_table(self, column_name: str, data_warehouse_metadata: 'DataWarehouseMetadata') -> Optional['TableMetadata']:
        """Get the TableMetadata object for a given column's source table from within the given DataWarehouseMetadata structure."""
        source_field = self.get_column(column_name).source_field
        if source_field is not None:
            source_table = data_warehouse_metadata.get_table_by_path(self.primary_source_table)
            for foreign_key in source_field.fk_steps:
                source_table = data_warehouse_metadata.get_table_by_path(source_table.get_foreign_key(foreign_key).table)
            return source_table
        else:
            return None

    @property
    def columns(self) -> List[ColumnMetadata]:
        return list(self._columns.values())

    @property
    def etls(self) -> List[ETLMetadata]:
        return list(self._etls.values())

    @property
    def foreign_keys(self) -> List[ForeignKeyMetadata]:
        return list(self._foreign_keys.values())

    def __repr__(self) -> str:
        return f'TableMetadata(\n' \
               f'    name={self.name},\n' \
               f'    schema_name={self.path.schema}\n' \
               f'    database_name={self.path.database}\n' \
               f'    primary_source_table={repr(self.primary_source_table)}\n' \
               f'    primary_key={repr(self.primary_key)}\n' \
               f'    foreign_keys={repr(self.foreign_keys)}\n' \
               f'    columns={repr(self.columns)}\n' \
               f'    etls={repr(self.etls)}\n' \
               f'    next_etls={repr(self.next_etls)}\n' \
               f')'

    def __eq__(self, other: 'TableMetadata') -> bool:
        return isinstance(other, TableMetadata) and \
               self.name == other.name and \
               self.path == other.path and \
               self.primary_source_table == other.primary_source_table and \
               self.primary_key == other.primary_key and \
               self.foreign_keys == other.foreign_keys and \
               self.columns == other.columns and \
               self.etls == other.etls and \
               self.next_etls == other.next_etls


class SchemaMetadata:
    """A metadata hierarchy node containing all metadata for a single schema within it."""

    def __init__(self, name: str):
        self.name = name
        self.path = SchemaPath(database=None, schema=name)
        self._tables = {}

    def add_table(self, table: TableMetadata):
        self._tables[table.name] = table
        table.path.database = self.path.database
        table.path.schema = self.name

    def get_table(self, table_name: str) -> TableMetadata:
        if table_name not in self._tables:
            raise InvalidMetadataKeyException('schema', self.name, 'table', table_name)
        else:
            return self._tables[table_name]

    def contains_table(self, table_name: str) -> bool:
        return table_name in self._tables

    def remove_table(self, table_name: str):
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
    """A metadata hierarchy node containing all metadata for a single database within it."""

    def __init__(self, name: str):
        self.name = name
        self.path = DatabasePath(database=name)
        self._schemas = {}

    def add_schema(self, schema: SchemaMetadata):
        self._schemas[schema.name] = schema
        schema.path.database = self.name

    def get_schema(self, schema_name: str) -> SchemaMetadata:
        if schema_name not in self._schemas:
            raise InvalidMetadataKeyException('database', self.name, 'schema', schema_name)
        else:
            return self._schemas[schema_name]

    def contains_schema(self, schema_name: str) -> bool:
        return schema_name in self._schemas

    def remove_schema(self, schema_name: str):
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
    """A top-level metadata object containing an entire metadata hierarchy within it, starting with databases."""

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

    def contains_database(self, database_name: str) -> bool:
        return database_name in self._databases

    def remove_database(self, database_name: str):
        if database_name in self._databases:
            del self._databases[database_name]

    @property
    def databases(self) -> List[DatabaseMetadata]:
        return list(self._databases.values())

    def get_database_by_path(self, path: DatabasePath) -> DatabaseMetadata:
        return self.get_database(path.database)

    def get_schema_by_path(self, path: SchemaPath) -> SchemaMetadata:
        return self.get_database(path.database).get_schema(path.schema)

    def get_table_by_path(self, path: TablePath) -> TableMetadata:
        return self.get_database(path.database).get_schema(path.schema).get_table(path.table)

    def get_column_by_path(self, path: ColumnPath) -> ColumnMetadata:
        return self.get_database(path.database).get_schema(path.schema).get_table(path.table).get_column(path.column)

    def __repr__(self) -> str:
        return f'DataWarehouseMetadata(\n' \
               f'    name={self.name},\n' \
               f'    databases={generate_collection_repr(self.databases)}'

    def __eq__(self, other: 'DataWarehouseMetadata') -> bool:
        return isinstance(other, DataWarehouseMetadata) and \
               self.name == other.name and \
               self._databases == other._databases


class InvalidMetadataKeyException(Exception):
    """A generic exception to be thrown by the metadata hierarchy when the user attempts to access a child object that doesn't exist"""

    def __init__(self, parent_entity_type: str, parent_name: str, child_entity_type: str, child_name: str, ):
        super().__init__(f'{child_entity_type} "{child_name}" does not exist in {parent_entity_type} "{parent_name}"')


def indent_multiline_str(s: str, indent: int = 4) -> str:
    """Indent every line in a multi-line string by the given indentation amount."""
    return '\n'.join([' ' * indent + line for line in s.split('\n')])


def generate_collection_repr(collection: list) -> str:
    """Generate an easy-to-read repr for a list of repr-able objects."""
    reprs = "\n".join([indent_multiline_str(repr(item), indent=8) for item in collection])
    return f'[\n{reprs}\n]'