from typing import List


class ETLMetadata:
    pass


class ColumnMetadata:
    pass


class TableMetadata:

    def __init__(self, name: str):
        self.name = name

    def __eq__(self, other: 'TableMetadata'):
        return isinstance(other, TableMetadata) and \
               self.name == other.name


class SchemaMetadata:

    def __init__(self, name: str):
        self.name = name
        self._tables = {}

    def add_table_metadata(self, table: TableMetadata):
        self._tables[table.name] = table

    def get_table_metadata(self, table_name: str) -> TableMetadata:
        if table_name not in self._tables:
            raise InvalidMetadataKeyException('database', self.name, 'schema', table_name)
        else:
            return self._tables[table_name]

    @property
    def tables(self) -> List[TableMetadata]:
        return list(self._tables.values())

    def __eq__(self, other: 'SchemaMetadata'):
        return isinstance(other, SchemaMetadata) and \
               self.name == other.name and \
               self._tables == other._tables


class DatabaseMetadata:

    def __init__(self, name: str):
        self.name = name
        self._schemas = {}

    def add_schema_metadata(self, schema: SchemaMetadata):
        self._schemas[schema.name] = schema

    def get_schema_metadata(self, schema_name: str) -> SchemaMetadata:
        if schema_name not in self._schemas:
            raise InvalidMetadataKeyException('database', self.name, 'schema', schema_name)
        else:
            return self._schemas[schema_name]

    @property
    def schemas(self) -> List[SchemaMetadata]:
        return list(self._schemas.values())

    def __eq__(self, other: 'DatabaseMetadata'):
        return isinstance(other, DatabaseMetadata) and \
               self.name == other.name and \
               self._schemas == other._schemas


class DataWarehouseMetadata:

    def __init__(self, name: str):
        self.name = name
        self._databases = {}

    def add_database_metadata(self, database: DatabaseMetadata):
        self._databases[database.name] = database

    def get_database_metadata(self, database_name: str) -> DatabaseMetadata:
        if database_name not in self._databases:
            raise InvalidMetadataKeyException('data warehouse', self.name, 'database', database_name)
        else:
            return self._databases[database_name]

    @property
    def databases(self) -> List[DatabaseMetadata]:
        return list(self._databases.values())

    def __eq__(self, other: 'DataWarehouseMetadata'):
        return isinstance(other, DataWarehouseMetadata) and \
               self.name == other.name and \
               self._databases == other._databases


class InvalidMetadataKeyException(Exception):
    def __init__(self, parent_entity_type: str, parent_name: str, child_entity_type: str, child_name: str, ):
        super().__init__(f'{child_entity_type} "{child_name}" does not exist in {parent_entity_type} "{parent_name}"')
