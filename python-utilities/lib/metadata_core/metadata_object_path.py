from dataclasses import dataclass


@dataclass
class DatabasePath:
    database: str

    def make_schema_path(self, schema_name: str) -> 'SchemaPath':
        return SchemaPath(database=self.database, schema=schema_name)


@dataclass
class SchemaPath:
    database: str
    schema: str

    @property
    def database_path(self) -> DatabasePath:
        return DatabasePath(database=self.database)

    def make_table_path(self, table_name: str) -> 'TablePath':
        return TablePath(database=self.database, schema=self.schema, table=table_name)


@dataclass
class TablePath:
    database: str
    schema: str
    table: str

    @property
    def database_path(self) -> DatabasePath:
        return DatabasePath(database=self.database)

    @property
    def schema_path(self) -> SchemaPath:
        return SchemaPath(database=self.database, schema=self.schema)

    def make_column_path(self, column_name: str) -> 'ColumnPath':
        return ColumnPath(database=self.database, schema=self.schema, table=self.table, column=column_name)


@dataclass
class ColumnPath:
    database: str
    schema: str
    table: str
    column: str

    @property
    def database_path(self) -> DatabasePath:
        return DatabasePath(database=self.database)

    @property
    def schema_path(self) -> SchemaPath:
        return SchemaPath(database=self.database, schema=self.schema)

    @property
    def table_path(self) -> TablePath:
        return TablePath(database=self.database, schema=self.schema, table=self.table)
