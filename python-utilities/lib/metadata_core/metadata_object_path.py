"""A family of data structures that hold paths to specific metadata objects within a DataWarehouseMetadata hierarchy."""

from dataclasses import dataclass
from typing import Optional


@dataclass
class DatabasePath:
    """The path to a specific database in a DataWarehouseMetadata structure."""
    database: str

    def make_schema_path(self, schema_name: str) -> 'SchemaPath':
        """Construct a SchemaPath object appending the given schema name to the current DatabasePath."""
        return SchemaPath(database=self.database, schema=schema_name)


@dataclass
class SchemaPath:
    """The path to a specific schema in a DataWarehouseMetadata structure."""
    database: Optional[str]
    schema: str

    @property
    def database_path(self) -> DatabasePath:
        """Get the DatabasePath for this schema's parent database."""
        return DatabasePath(database=self.database)

    def make_table_path(self, table_name: str) -> 'TablePath':
        """Construct a TablePath object appending the given table name to the current SchemaPath."""
        return TablePath(database=self.database, schema=self.schema, table=table_name)


@dataclass
class TablePath:
    """The path to a specific table in a DataWarehouseMetadata structure."""
    database: Optional[str]
    schema: Optional[str]
    table: str

    @property
    def database_path(self) -> DatabasePath:
        """Get the DatabasePath for this table's parent database."""
        return DatabasePath(database=self.database)

    @property
    def schema_path(self) -> SchemaPath:
        """Get the SchemaPath for this table's parent schema."""
        return SchemaPath(database=self.database, schema=self.schema)

    def make_column_path(self, column_name: str) -> 'ColumnPath':
        """Construct a ColumnPath object appending the given column name to the current TablePath."""
        return ColumnPath(database=self.database, schema=self.schema, table=self.table, column=column_name)


@dataclass
class ColumnPath:
    """The path to a specific column in a DataWarehouseMetadata structure."""
    database: Optional[str]
    schema: Optional[str]
    table: Optional[str]
    column: str

    @property
    def database_path(self) -> DatabasePath:
        """Get the DatabasePath for this column's parent database."""
        return DatabasePath(database=self.database)

    @property
    def schema_path(self) -> SchemaPath:
        """Get the SchemaPath for this column's parent schema."""
        return SchemaPath(database=self.database, schema=self.schema)

    @property
    def table_path(self) -> TablePath:
        """Get the TablePath for this column's parent table."""
        return TablePath(database=self.database, schema=self.schema, table=self.table)
