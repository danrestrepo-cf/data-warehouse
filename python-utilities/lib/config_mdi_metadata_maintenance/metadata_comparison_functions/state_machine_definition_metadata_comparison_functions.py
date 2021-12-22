from typing import List

from lib.config_mdi_metadata_maintenance.metadata_comparison_functions.metadata_comparison_functions import MetadataComparisonFunctions
from lib.db_connections import DBConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, SingleGroupRowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata


class StateMachineDefinitionMetadataComparisonFunctions(MetadataComparisonFunctions):
    """The set of metadata comparison functions used to maintain config.mdi.state_machine_definition."""

    def __init__(self):
        super().__init__(key_fields=['process_name'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: DBConnection) -> MetadataTable:
        return self.construct_metadata_table_from_sql_query_results(local_edw_connection, """
                WITH filtered_process AS (
                    SELECT process.dwid
                         , process.name
                    FROM mdi.process
                    JOIN mdi.table_output_step
                         ON process.dwid = table_output_step.process_dwid
                    WHERE table_output_step.target_schema IN ('history_octane', 'star_loan')
                    UNION ALL
                    SELECT process.dwid
                         , process.name
                    FROM mdi.process
                    JOIN mdi.insert_update_step
                         ON process.dwid = insert_update_step.process_dwid
                    WHERE insert_update_step.schema_name = 'star_loan'
                    UNION ALL
                    SELECT process.dwid
                         , process.name
                    FROM mdi.process
                    JOIN mdi.delete_step
                         ON process.dwid = delete_step.process_dwid
                    WHERE delete_step.schema_name = 'star_loan'
                )
                SELECT process.name AS process_name
                    , state_machine_definition.name AS state_machine_name
                    , state_machine_definition.comment AS state_machine_comment
                FROM mdi.state_machine_definition
                JOIN filtered_process process
                     ON state_machine_definition.process_dwid = process.dwid;
            """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for etl in table.etls:
                        comment = self.construct_process_description(table.path, table.primary_source_table, etl)
                        metadata_table.add_row({'process_name': etl.process_name, 'state_machine_name': etl.process_name,
                                                'state_machine_comment': comment})
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        return SingleGroupRowGrouper()

    def construct_delete_row_grouper(self, metadata_table: MetadataTable) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "INSERT\n" + \
               "INTO mdi.state_machine_definition (process_dwid, name, comment)\n" + \
               "SELECT process.dwid, insert_rows.state_machine_name, insert_rows.state_machine_comment\n" + \
               "FROM insert_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON process.name = insert_rows.process_name;"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return "WITH update_rows (process_name, state_machine_name, state_machine_comment) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "UPDATE mdi.state_machine_definition\n" + \
               "SET name = update_rows.state_machine_name\n" + \
               "  , comment = update_rows.state_machine_comment\n" + \
               "FROM update_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON process.name = update_rows.process_name\n" + \
               "WHERE process.dwid = state_machine_definition.process_dwid;"

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (process_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.state_machine_definition\n" + \
               "    USING delete_keys, mdi.process\n" + \
               "WHERE state_machine_definition.process_dwid = process.dwid\n" + \
               "  AND process.name = delete_keys.process_name;"
