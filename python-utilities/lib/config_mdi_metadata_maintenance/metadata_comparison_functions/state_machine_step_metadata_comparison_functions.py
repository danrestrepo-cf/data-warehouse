from typing import List

from lib.config_mdi_metadata_maintenance.metadata_comparison_functions.metadata_comparison_functions import MetadataComparisonFunctions
from lib.db_connections import LocalEDWConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, SingleGroupRowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata


class StateMachineStepMetadataComparisonFunctions(MetadataComparisonFunctions):

    def __init__(self):
        super().__init__(key_fields=['process_name', 'next_process_name'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: LocalEDWConnection) -> MetadataTable:
        return self.construct_metadata_table_from_sql_query_results(local_edw_connection, """
                SELECT process.name AS process_name
                     , next_process.name AS next_process_name
                FROM mdi.state_machine_step
                JOIN mdi.process
                     ON state_machine_step.process_dwid = process.dwid
                JOIN mdi.process next_process
                     ON state_machine_step.next_process_dwid = next_process.dwid
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
                        for next_etl_process_name in table.next_etls:
                            metadata_table.add_row({'process_name': etl.process_name, 'next_process_name': next_etl_process_name})
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "WITH insert_rows (process_name, next_process_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "INSERT\n" + \
               "INTO mdi.state_machine_step (process_dwid, next_process_dwid)\n" + \
               "SELECT process.dwid, next_process.dwid\n" + \
               "FROM insert_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON process.name = insert_rows.process_name\n" + \
               "JOIN mdi.process next_process\n" + \
               "     ON next_process.name = insert_rows.next_process_name;"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return ''  # since state_machine_step has no non-key values, it will never need to generate any updates (only inserts/deletes)

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (process_name, next_process_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.state_machine_step\n" + \
               "    USING delete_keys, mdi.process, mdi.process next_process\n" + \
               "WHERE state_machine_step.process_dwid = process.dwid\n" + \
               "  AND state_machine_step.next_process_dwid = next_process.dwid\n" + \
               "  AND delete_keys.process_name = process.name\n" + \
               "  AND delete_keys.next_process_name = next_process.name;"
