from typing import List

from lib.config_mdi_metadata_maintenance.metadata_comparison_functions.metadata_comparison_functions import MetadataComparisonFunctions
from lib.db_connections import DBConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, SingleGroupRowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, ETLOutputType


class TableOutputFieldMetadataComparisonFunctions(MetadataComparisonFunctions):

    def __init__(self):
        super().__init__(key_fields=['process_name', 'database_field_name'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: DBConnection) -> MetadataTable:
        return self.construct_metadata_table_from_sql_query_results(local_edw_connection, """
                SELECT process.name AS process_name
                     , table_output_field.database_field_name
                FROM mdi.table_output_field
                JOIN mdi.table_output_step
                     ON table_output_field.table_output_step_dwid = table_output_step.dwid
                JOIN mdi.process
                     ON table_output_step.process_dwid = process.dwid
                -- hardcoded to only check history_octane until this script is updated to handle other schemas' ETLs
                WHERE table_output_step.target_schema = 'history_octane';
            """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        standard_sourceless_fields = ['data_source_updated_datetime', 'data_source_deleted_flag']
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for etl in table.etls:
                        if etl.output_type == ETLOutputType.INSERT:
                            for column in table.columns:
                                if column.source_field is not None or column.name in standard_sourceless_fields:
                                    metadata_table.add_row({
                                        'process_name': etl.process_name,
                                        'database_field_name': column.name
                                    })
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        return SingleGroupRowGrouper()

    def construct_delete_row_grouper(self, metadata_table: MetadataTable) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "WITH insert_rows (process_name, database_field_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "INSERT\n" + \
               "INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)\n" + \
               "SELECT table_output_step.dwid, insert_rows.database_field_name, insert_rows.database_field_name, 0, FALSE\n" + \
               "FROM insert_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON process.name = insert_rows.process_name\n" + \
               "JOIN mdi.table_output_step\n" + \
               "     ON process.dwid = table_output_step.process_dwid;\n"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return ""  # since table_output_field has no non-key values, it will never need to generate any updates (only inserts/deletes)

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (process_name, database_field_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.table_output_field\n" + \
               "    USING delete_keys, mdi.process, mdi.table_output_step\n" + \
               "WHERE delete_keys.process_name = process.name\n" + \
               "  AND process.dwid = table_output_step.process_dwid\n" + \
               "  AND table_output_step.dwid = table_output_field.table_output_step_dwid\n" + \
               "  AND delete_keys.database_field_name = table_output_field.database_field_name;"
