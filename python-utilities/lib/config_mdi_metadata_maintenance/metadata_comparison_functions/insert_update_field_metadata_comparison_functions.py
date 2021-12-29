from typing import List

from lib.config_mdi_metadata_maintenance.metadata_comparison_functions.metadata_comparison_functions import MetadataComparisonFunctions
from lib.db_connections import DBConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, SingleGroupRowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, ETLOutputType


class InsertUpdateFieldMetadataComparisonFunctions(MetadataComparisonFunctions):
    """The set of metadata comparison functions used to maintain config.mdi.insert_update_field."""

    def __init__(self):
        super().__init__(key_fields=['process_name', 'update_lookup'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: DBConnection) -> MetadataTable:
        return self.construct_metadata_table_from_sql_query_results(local_edw_connection, """
                SELECT process.name AS process_name
                    , insert_update_field.update_lookup
                    , insert_update_field.update_flag
                FROM mdi.insert_update_field
                JOIN mdi.insert_update_step
                    ON insert_update_field.insert_update_step_dwid = insert_update_step.dwid
                JOIN mdi.process
                    ON insert_update_step.process_dwid = process.dwid
                WHERE insert_update_step.schema_name = 'star_loan';
            """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for etl in table.etls:
                        if etl.output_type == ETLOutputType.INSERT_UPDATE:
                            for column in table.columns:
                                if column.name != 'dwid':
                                    metadata_table.add_row({
                                        'process_name': etl.process_name,
                                        'update_lookup': column.name,
                                        'update_flag': 'Y' if column.update_flag else 'N'
                                })
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        return SingleGroupRowGrouper()

    def construct_delete_row_grouper(self, metadata_table: MetadataTable) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "WITH insert_rows (process_name, update_lookup, update_flag) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "INSERT\n" + \
               "INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)\n" + \
               "SELECT insert_update_step.dwid, insert_rows.update_lookup, insert_rows.update_lookup, insert_rows.update_flag::mdi.pentaho_y_or_n, FALSE\n" + \
               "FROM insert_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON process.name = insert_rows.process_name\n" + \
               "JOIN mdi.insert_update_step\n" + \
               "     ON process.dwid = insert_update_step.process_dwid;\n"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return "WITH update_rows (process_name, update_lookup, update_flag) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "UPDATE mdi.insert_update_field\n" + \
               "SET update_flag = update_rows.update_flag::mdi.pentaho_y_or_n\n" + \
               "FROM update_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON process.name = update_rows.process_name\n" + \
               "JOIN mdi.insert_update_step\n" + \
               "     ON process.dwid = insert_update_step.process_dwid\n" + \
               "WHERE insert_update_step.dwid = insert_update_field.insert_update_step_dwid\n" + \
               "     AND update_rows.update_lookup = insert_update_field.update_lookup;\n"

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (process_name, update_lookup) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.insert_update_field\n" + \
               "    USING delete_keys, mdi.process, mdi.insert_update_step\n" + \
               "WHERE delete_keys.process_name = process.name\n" + \
               "  AND process.dwid = insert_update_step.process_dwid\n" + \
               "  AND insert_update_step.dwid = insert_update_field.insert_update_step_dwid\n" + \
               "  AND delete_keys.update_lookup = insert_update_field.update_lookup;\n"
