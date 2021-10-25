from typing import List

from lib.config_mdi_metadata_maintenance.metadata_comparison_functions.metadata_comparison_functions import MetadataComparisonFunctions
from lib.db_connections import DBConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, SingleGroupRowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata


class ProcessMetadataComparisonFunctions(MetadataComparisonFunctions):

    def __init__(self):
        super().__init__(key_fields=['process_name'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: DBConnection) -> MetadataTable:
        return self.construct_metadata_table_from_sql_query_results(local_edw_connection, """
                SELECT process.name AS process_name
                     , process.description AS process_description
                FROM mdi.process
                JOIN mdi.table_output_step
                     ON process.dwid = table_output_step.process_dwid
                -- hardcoded to only check history_octane until this script is updated to handle other schemas' ETLs
                WHERE table_output_step.target_schema = 'history_octane';
            """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for etl in table.etls:
                        description = self.construct_process_description(table.path, table.primary_source_table, etl)
                        metadata_table.add_row({'process_name': etl.process_name, 'process_description': description})
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        return SingleGroupRowGrouper()

    def construct_delete_row_grouper(self, metadata_table: MetadataTable) -> RowGrouper:
        return SingleGroupRowGrouper()

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
