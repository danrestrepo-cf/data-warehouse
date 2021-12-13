from typing import List

from lib.config_mdi_metadata_maintenance.metadata_comparison_functions.metadata_comparison_functions import MetadataComparisonFunctions
from lib.db_connections import DBConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, SingleGroupRowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, ETLOutputType


class InsertUpdateKeyMetadataComparisonFunctions(MetadataComparisonFunctions):
    """The set of metadata comparison functions used to maintain config.mdi.insert_update_key."""

    def __init__(self):
        super().__init__(key_fields=['process_name', 'key_lookup'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: DBConnection) -> MetadataTable:
        return self.construct_metadata_table_from_sql_query_results(local_edw_connection, """
                SELECT process.name AS process_name
                    , insert_update_key.key_lookup
                FROM mdi.insert_update_key
                JOIN mdi.insert_update_step
                    ON insert_update_key.insert_update_step_dwid = insert_update_step.dwid
                JOIN mdi.process
                    ON insert_update_step.process_dwid = process.dwid;
        """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for etl in table.etls:
                        if etl.output_type == ETLOutputType.INSERT_UPDATE:
                            for insert_update_key in etl.insert_update_keys:
                                metadata_table.add_row({
                                    'process_name': etl.process_name,
                                    'key_lookup': insert_update_key,
                            })
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
            return SingleGroupRowGrouper()

    def construct_delete_row_grouper(self, metadata_table: MetadataTable) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "WITH insert_rows (process_name, key_lookup) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_stream2, key_condition)\n" + \
               "SELECT insert_update_step.dwid, insert_rows.key_lookup, insert_rows.key_lookup, NULL, '='\n" + \
               "FROM insert_rows\n" + \
               "JOIN mdi.process\n" + \
               "ON process.name = insert_rows.process_name\n" + \
               "JOIN mdi.insert_update_step\n" + \
               "ON process.dwid = insert_update_step.process_dwid;"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return ""  # since insert_update_key has no non-key values, it will never need to generate any updates (only inserts/deletes)

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (process_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.insert_update_key\n" + \
               "    USING delete_keys, mdi.process, mdi.insert_update_step\n" + \
               "WHERE insert_update_key.insert_update_step_dwid = insert_update_step.dwid" \
               "  AND insert_update_step.process_dwid = process.dwid\n" + \
               "  AND process.name = delete_keys.process_name;"
