from typing import List

from lib.config_mdi_metadata_maintenance.metadata_comparison_functions.metadata_comparison_functions import MetadataComparisonFunctions
from lib.db_connections import DBConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, SingleGroupRowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata


class JSONOutputFieldMetadataComparisonFunctions(MetadataComparisonFunctions):
    """The set of metadata comparison functions used to maintain config.mdi.json_output_field."""

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
                    WHERE table_output_step.target_schema IN ('history_octane', 'star_loan', 'data_mart_business_applications')
                    UNION ALL
                    SELECT process.dwid
                         , process.name
                    FROM mdi.process
                    JOIN mdi.insert_update_step
                         ON process.dwid = insert_update_step.process_dwid
                    WHERE insert_update_step.schema_name IN ('star_loan', 'data_mart_business_applications')
                    UNION ALL
                    SELECT process.dwid
                         , process.name
                    FROM mdi.process
                    JOIN mdi.delete_step
                         ON process.dwid = delete_step.process_dwid
                    WHERE delete_step.schema_name IN ('star_loan', 'data_mart_business_applications')
                )
                SELECT process.name AS process_name
                     , json_output_field.field_name AS json_output_field
                FROM mdi.json_output_field
                JOIN filtered_process process
                     ON json_output_field.process_dwid = process.dwid;
            """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for etl in table.etls:
                        metadata_table.add_row({'process_name': etl.process_name, 'json_output_field': etl.json_output_field})
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        return SingleGroupRowGrouper()

    def construct_delete_row_grouper(self, metadata_table: MetadataTable) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "WITH insert_rows (process_name, json_output_field) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "INSERT\n" + \
               "INTO mdi.json_output_field (process_dwid, field_name)\n" + \
               "SELECT process.dwid, insert_rows.json_output_field\n" + \
               "FROM insert_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON insert_rows.process_name = process.name;"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return "WITH update_rows (process_name, json_output_field) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "UPDATE mdi.json_output_field\n" + \
               "SET field_name = update_rows.json_output_field\n" + \
               "FROM update_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON process.name = update_rows.process_name\n" + \
               "WHERE json_output_field.process_dwid = process.dwid;"

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (process_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.json_output_field\n" + \
               "    USING delete_keys, mdi.process\n" + \
               "WHERE json_output_field.process_dwid = process.dwid\n" + \
               "  AND process.name = delete_keys.process_name;"
