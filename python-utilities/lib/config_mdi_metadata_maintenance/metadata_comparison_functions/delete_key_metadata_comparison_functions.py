from typing import List

from lib.config_mdi_metadata_maintenance.metadata_comparison_functions.metadata_comparison_functions import MetadataComparisonFunctions
from lib.db_connections import DBConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, SingleGroupRowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, ETLOutputType


class DeleteKeyMetadataComparisonFunctions(MetadataComparisonFunctions):
    """The set of metadata comparison functions used to maintain config.mdi.delete_key."""

    def __init__(self):
        super().__init__(key_fields=['process_name', 'table_name_field'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: DBConnection) -> MetadataTable:
        return self.construct_metadata_table_from_sql_query_results(local_edw_connection, """
                SELECT process.name AS process_name
                    , delete_key.table_name_field
                FROM mdi.delete_key
                JOIN mdi.delete_step
                    ON delete_key.delete_step_dwid = delete_step.dwid
                JOIN mdi.process
                    ON delete_step.process_dwid = process.dwid;
        """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for etl in data_warehouse_metadata.get_etls(filter_func=lambda etl: etl.output_type == ETLOutputType.DELETE):
            for delete_key in etl.delete_keys:
                metadata_table.add_row({
                    'process_name': etl.process_name,
                    'table_name_field': delete_key
                })
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        return SingleGroupRowGrouper()

    def construct_delete_row_grouper(self, metadata_table: MetadataTable) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "WITH insert_rows (process_name, table_name_field) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "INSERT INTO mdi.delete_key (delete_step_dwid, table_name_field, stream_fieldname_1, stream_fieldname_2, comparator, is_sensitive)\n" + \
               "SELECT delete_step.dwid, insert_rows.table_name_field, insert_rows.table_name_field, '', '=', FALSE\n" + \
               "FROM insert_rows\n" + \
               "JOIN mdi.process\n" + \
               "ON process.name = insert_rows.process_name\n" + \
               "JOIN mdi.delete_step\n" + \
               "ON process.dwid = delete_step.process_dwid;"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return ""  # since delete_key has no non-key values, it will never need to generate any updates (only inserts/deletes)

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (process_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.delete_key\n" + \
               "    USING delete_keys, mdi.process, mdi.delete_step\n" + \
               "WHERE delete_key.delete_step_dwid = delete_step.dwid" \
               "  AND delete_step.process_dwid = process.dwid\n" + \
               "  AND process.name = delete_keys.process_name;"
