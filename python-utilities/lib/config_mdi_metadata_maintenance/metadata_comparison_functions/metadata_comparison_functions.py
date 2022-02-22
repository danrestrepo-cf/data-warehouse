"""The base class for the entire family of MetadataComparisonFunctions classes that comprise this sub-module.

The MetadataComparisonFunctions abstraction is a way of representing the ways
that metadata comparison processes *differ* between different tables. This class
allows for isolating those differences in functionality, and also allows us to easily
add additional tables to the overall metadata maintenance process simply by adding
additional MetadataComparisonFunctions subclasses and hooking them into the main
script.

The "differing" functionality that is isolated in this abstraction includes:
- What query to run to get the current contents of the config.mdi table in question
- How to build a metadata table from a DataWarehouseMetadata object that matches
  the result structure from the config.mdi query mentioned above
- How to group rows when INSERTING data into the relevant config.mdi table
- How to group rows when DELETING data from the relevant config.mdi table
- How to write the SQL that will perform any necessary insertions into the config.mdi table
- How to write the SQL that will perform any necessary updates the config.mdi table
- How to write the SQL that will perform any necessary deletions from the config.mdi table

Each subclass implements the above functionality (corresponding to this class's 7
abstract methods) differently, but adhering to the same interface enables the driver
code that generates all metadata maintenance SQL to be *much* simpler and easier
understand. Also, as mentioned above, it allows us to easily extend the system
to maintain additional tables without having to modify the program's core
business logic.
"""

from typing import List
from abc import ABC, abstractmethod

from lib.db_connections import DBConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, ETLMetadata
from lib.metadata_core.metadata_object_path import TablePath


class MetadataComparisonFunctions(ABC):
    """An abstract class representing a set of common functionality that all tables that are part of the metadata comparison need."""

    def __init__(self, key_fields: List[str]):
        self.key_fields = key_fields

    # abstract methods

    @abstractmethod
    def construct_metadata_table_from_config_db(self, local_edw_connection: DBConnection) -> MetadataTable:
        """Construct a MetadataTable from the appropriate table in EDW's config.mdi schema."""
        pass

    @abstractmethod
    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        """Construct a MetadataTable from the relevant data in the given DataWarehouseMetadata object."""
        pass

    @abstractmethod
    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        """Construct a RowGrouper that will group rows for this table's INSERT SQL statement(s)."""
        pass

    @abstractmethod
    def construct_delete_row_grouper(self, metadata_table: MetadataTable) -> RowGrouper:
        """Construct a RowGrouper that will group rows for this table's DELETE SQL statement(s)."""
        pass

    @abstractmethod
    def generate_insert_sql(self, rows: List[Row]) -> str:
        """Generate SQL to INSERT rows into the appropriate config.mdi table."""
        pass

    @abstractmethod
    def generate_update_sql(self, rows: List[Row]) -> str:
        """Generate SQL to UPDATE rows in the appropriate config.mdi table."""
        pass

    @abstractmethod
    def generate_delete_sql(self, rows: List[Row]) -> str:
        """Generate SQL to DELETE rows from the appropriate config.mdi table."""
        pass

    # helper methods to be used by subclasses when implementing the above abstract methods

    def construct_metadata_table_from_sql_query_results(self, local_edw_connection: DBConnection, sql_query: str) -> MetadataTable:
        """Construct a MetadataTable from the results of a query to the EDW config.mdi schema."""
        with local_edw_connection as cursor:
            raw_data = cursor.execute_and_fetch_all_results(sql_query)
            metadata_table = self.construct_empty_metadata_table()
            metadata_table.add_rows(raw_data)
            return metadata_table

    def construct_empty_metadata_table(self) -> MetadataTable:
        """Construct an empty metadata table pre-configured with the appropriate key fields."""
        return MetadataTable(self.key_fields)

    def construct_values_string_from_full_rows(self, rows: List[Row], base_indent: int = 0) -> str:
        """Construct a valid SQL VALUES item containing every field in each of the given rows.

        This is used to populate the initial CTE's VALUES list in all INSERT and
        UPDATE SQL statements.
        """
        full_rows = [row.full_row for row in rows]
        return self.construct_values_string_from_list_of_dicts(full_rows, base_indent)

    def construct_values_string_from_row_keys(self, rows: List[Row], base_indent: int = 0) -> str:
        """Construct a valid SQL VALUES item containing every field in each of the given rows' *keys*.

        This is used to populate the initial CTE's VALUES list in all DELETE SQL
        statements.
        """
        row_keys = [row.key for row in rows]
        return self.construct_values_string_from_list_of_dicts(row_keys, base_indent)

    def construct_values_string_from_list_of_dicts(self, data: List[dict], base_indent: int = 0) -> str:
        indent_str = ' ' * (base_indent + 5)  # 5 is the length of the string "VALUES"
        return ('\n' + indent_str + ', ').join(
            ['(' + ', '.join([self.format_value_for_sql(value) for value in d.values()]) + ')' for d in data]
        )

    @staticmethod
    def get_connection_name(database: str) -> str:
        """Get the Pentaho connection name for the given database."""
        connection_name_lookup = {
            'staging': 'Staging DB Connection',
            'ingress': 'Ingress DB Connection',
            'config': 'Config DB Connection'
        }
        if database not in connection_name_lookup:
            raise ValueError(f'No Pentaho connection name mapping could be found for database "{database}"')
        return connection_name_lookup[database]

    @staticmethod
    def format_value_for_sql(value) -> str:
        """Format the given value for inclusion in a SQL statement based on its type."""
        if type(value) == str:
            quote_replaced_value = value.replace("'", "''")
            return f"'{quote_replaced_value}'"
        elif type(value) == int:
            return str(value)
        elif value is None:
            return 'NULL'
        else:
            raise ValueError(f'Unable to format value of type {type(value)} for inclusion in SQL string: {value}')
