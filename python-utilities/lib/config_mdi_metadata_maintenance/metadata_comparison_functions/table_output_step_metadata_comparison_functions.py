from typing import List

from lib.config_mdi_metadata_maintenance.metadata_comparison_functions.metadata_comparison_functions import MetadataComparisonFunctions
from lib.db_connections import DBConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, SingleGroupRowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, ETLOutputType


class TableOutputStepMetadataComparisonFunctions(MetadataComparisonFunctions):
    """The set of metadata comparison functions used to maintain config.mdi.table_output_step."""

    def __init__(self):
        super().__init__(key_fields=['process_name'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: DBConnection) -> MetadataTable:
        return self.construct_metadata_table_from_sql_query_results(local_edw_connection, """
                SELECT process.name AS process_name
                     , table_output_step.target_schema
                     , table_output_step.target_table
                     , table_output_step.truncate_table
                     , table_output_step.connectionname
                FROM mdi.table_output_step
                JOIN mdi.process
                     ON table_output_step.process_dwid = process.dwid
                -- hardcoded to only check history_octane until this script is updated to handle other schemas' ETLs
                WHERE table_output_step.target_schema = 'history_octane';
            """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for etl in table.etls:
                        if etl.output_type == ETLOutputType.INSERT:
                            truncate_table = 'Y' if etl.truncate_table else 'N'
                            metadata_table.add_row({
                                'process_name': etl.process_name,
                                'target_schema': schema.name,
                                'target_table': table.name,
                                'truncate_table': truncate_table,
                                'connectionname': self.get_connection_name(database.name)
                            })
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        return SingleGroupRowGrouper()

    def construct_delete_row_grouper(self, metadata_table: MetadataTable) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "WITH insert_rows (process_name, target_schema, target_table, truncate_table, connectionname) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)\n" + \
               "SELECT process.dwid, insert_rows.target_schema, insert_rows.target_table, 1000, NULL, NULL, NULL, NULL, 'N', NULL, insert_rows.truncate_table::mdi.pentaho_y_or_n, insert_rows.connectionname, 'N', 'Y', 'N', 'N'\n" + \
               "FROM insert_rows\n" + \
               "JOIN mdi.process\n" + \
               "ON process.name = insert_rows.process_name;"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return "WITH update_rows (process_name, target_schema, target_table, truncate_table, connectionname) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "UPDATE mdi.table_output_step\n" + \
               "SET target_schema = update_rows.target_schema\n" + \
               "  , target_table = update_rows.target_table\n" + \
               "  , truncate_table = update_rows.truncate_table::mdi.pentaho_y_or_n\n" + \
               "  , connectionname = update_rows.connectionname\n" + \
               "FROM update_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON process.name = update_rows.process_name\n" + \
               "WHERE process.dwid = table_output_step.process_dwid;"

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (process_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.table_output_step\n" + \
               "    USING delete_keys, mdi.process\n" + \
               "WHERE table_output_step.process_dwid = process.dwid\n" + \
               "  AND process.name = delete_keys.process_name;"
