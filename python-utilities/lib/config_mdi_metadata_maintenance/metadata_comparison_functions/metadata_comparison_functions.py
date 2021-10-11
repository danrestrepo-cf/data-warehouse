from typing import List
from abc import ABC, abstractmethod

from lib.db_connections import LocalEDWConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, ETLMetadata, TableAddress


class MetadataComparisonFunctions(ABC):

    def __init__(self, key_fields: List[str]):
        self.key_fields = key_fields

    @abstractmethod
    def construct_metadata_table_from_config_db(self, local_edw_connection: LocalEDWConnection) -> MetadataTable:
        pass

    @abstractmethod
    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        pass

    @abstractmethod
    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        pass

    @abstractmethod
    def generate_insert_sql(self, rows: List[Row]) -> str:
        pass

    @abstractmethod
    def generate_update_sql(self, rows: List[Row]) -> str:
        pass

    @abstractmethod
    def generate_delete_sql(self, rows: List[Row]) -> str:
        pass

    def construct_metadata_table_from_sql_query_results(self, local_edw_connection: LocalEDWConnection, sql_query: str) -> MetadataTable:
        with local_edw_connection as cursor:
            raw_data = cursor.select(sql_query)
            metadata_table = self.construct_empty_metadata_table()
            metadata_table.add_rows(raw_data)
            return metadata_table

    def construct_empty_metadata_table(self) -> MetadataTable:
        return MetadataTable(self.key_fields)

    @staticmethod
    def construct_process_description(table: TableAddress, source_table: TableAddress, etl: ETLMetadata) -> str:
        if table.database == 'staging' and table.schema == 'history_octane' and source_table.database == 'staging' and source_table.schema == 'staging_octane':
            return f'ETL to copy {table.table} data from staging_octane to history_octane'
        else:
            return f'{etl.input_type.value} -> table-{etl.output_type.value} ETL from ' \
                   f'{source_table.database}.{source_table.schema}.{source_table.table} to {table.database}.{table.schema}.{table.table}'

    def construct_values_string_from_full_rows(self, rows: List[Row], base_indent: int = 0) -> str:
        full_rows = [row.full_row for row in rows]
        return self.construct_values_string_from_list_of_dicts(full_rows, base_indent)

    def construct_values_string_from_row_keys(self, rows: List[Row], base_indent: int = 0) -> str:
        row_keys = [row.key for row in rows]
        return self.construct_values_string_from_list_of_dicts(row_keys, base_indent)

    def construct_values_string_from_list_of_dicts(self, data: List[dict], base_indent: int = 0) -> str:
        indent_str = ' ' * (base_indent + 5)  # 5 is the length of the string "VALUES"
        return ('\n' + indent_str + ', ').join(
            ['(' + ', '.join([self.format_value_for_sql(value) for value in d.values()]) + ')' for d in data]
        )

    @staticmethod
    def get_connection_name(database: str) -> str:
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
        if type(value) == str:
            return f"'{value}'"
        elif type(value) == int:
            return str(value)
        else:
            raise ValueError(f'Unable to format value of type {type(value)} for inclusion in SQL string: {value}')
