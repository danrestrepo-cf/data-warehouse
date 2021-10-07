from typing import List
from abc import ABC, abstractmethod

from lib.db_connections import LocalEDWConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, DefaultRowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata


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

    def construct_empty_metadata_table(self) -> MetadataTable:
        return MetadataTable(self.key_fields)

    def construct_values_string_from_full_rows(self, rows: List[Row], base_indent: int = 0) -> str:
        full_rows = [row.full_row for row in rows]
        return self.construct_values_string_from_list_of_dicts(full_rows, base_indent)

    def construct_values_string_from_row_keys(self, rows: List[Row], base_indent: int = 0) -> str:
        row_keys = [row.key for row in rows]
        return self.construct_values_string_from_list_of_dicts(row_keys, base_indent)

    @staticmethod
    def construct_values_string_from_list_of_dicts(data: List[dict], base_indent: int = 0) -> str:
        indent_str = ' ' * (base_indent + 5)  # 5 is the length of the string "VALUES"
        return ('\n' + indent_str + ', ').join(['(' + ', '.join([f"'{value}'" for value in d.values()]) + ')' for d in data])


class ProcessMetadataComparisonFunctions(MetadataComparisonFunctions):

    def __init__(self):
        super().__init__(key_fields=['process_name'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: LocalEDWConnection) -> MetadataTable:
        with local_edw_connection as cursor:
            raw_data = cursor.select("""
                SELECT process.name AS process_name
                     , process.description AS process_description
                FROM mdi.process
                JOIN mdi.table_output_step
                     ON process.dwid = table_output_step.process_dwid;
            """)
            metadata_table = self.construct_empty_metadata_table()
            metadata_table.add_rows(raw_data)
            return metadata_table

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for etl in table.etls:
                        source_table = table.primary_source_table
                        if database.name == 'staging' and schema.name == 'history_octane' and source_table.database == 'staging' and source_table.schema == 'staging_octane':
                            description = f'ETL to copy {table.name} data from staging_octane to history_octane'
                        else:
                            description = f'{etl.input_type.value} -> table-{etl.output_type.value} ETL from ' \
                                          f'{source_table.database}.{source_table.schema}.{source_table.table} to {database.name}.{schema.name}.{table.name}'
                        metadata_table.add_row({'process_name': etl.process_name, 'process_description': description})
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        return DefaultRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "INSERT\n" + \
               "INTO mdi.process\n" + \
               "VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=0) + ";"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return "WITH update_rows (process_name, process_description) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "UPDATE mdi.process\n" + \
               "SET description = update_rows.process_description\n" + \
               "FROM update_rows\n" + \
               "WHERE update_rows.process_name = process.name;"

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (process_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.process\n" + \
               "USING delete_keys\n" + \
               "WHERE process.name = delete_keys.process_name;"
