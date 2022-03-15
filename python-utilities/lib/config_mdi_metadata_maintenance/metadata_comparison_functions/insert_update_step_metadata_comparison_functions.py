from typing import List

from lib.config_mdi_metadata_maintenance.metadata_comparison_functions.metadata_comparison_functions import MetadataComparisonFunctions
from lib.db_connections import DBConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, SingleGroupRowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, ETLOutputType


class InsertUpdateStepMetadataComparisonFunctions(MetadataComparisonFunctions):
    """The set of metadata comparison functions used to maintain config.mdi.insert_update_step."""

    def __init__(self):
        super().__init__(key_fields=['process_name'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: DBConnection) -> MetadataTable:
        return self.construct_metadata_table_from_sql_query_results(local_edw_connection, """
                SELECT process.name AS process_name
                     , insert_update_step.connectionname
                     , insert_update_step.schema_name
                     , insert_update_step.table_name
                FROM mdi.insert_update_step
                JOIN mdi.process
                     ON insert_update_step.process_dwid = process.dwid
                WHERE insert_update_step.schema_name IN ('star_loan', 'data_mart_business_applications');
            """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for step_function in table.step_functions:
                        for etl in step_function.etls:
                            if etl.output_type == ETLOutputType.INSERT_UPDATE:
                                metadata_table.add_row({
                                    'process_name': etl.process_name,
                                    'connectionname': self.get_connection_name(database.name),
                                    'schema_name': etl.output_table.schema,
                                    'table_name': etl.output_table.table
                                })
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        return SingleGroupRowGrouper()

    def construct_delete_row_grouper(self, metadata_table: MetadataTable) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "WITH insert_rows (process_name, connectionname, schema_name, table_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)\n" + \
               "SELECT process.dwid, insert_rows.connectionname, insert_rows.schema_name, insert_rows.table_name, 1000, 'N'::mdi.pentaho_y_or_n\n" + \
               "FROM insert_rows\n" + \
               "JOIN mdi.process\n" + \
               "ON process.name = insert_rows.process_name;"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return "WITH update_rows (process_name, connectionname, schema_name, table_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "UPDATE mdi.insert_update_step\n" + \
               "SET connectionname = update_rows.connectionname\n" + \
               "  , schema_name = update_rows.schema_name\n" + \
               "  , table_name = update_rows.table_name\n" + \
               "FROM update_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON process.name = update_rows.process_name\n" + \
               "WHERE process.dwid = insert_update_step.process_dwid;"

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (process_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.insert_update_step\n" + \
               "    USING delete_keys, mdi.process\n" + \
               "WHERE insert_update_step.process_dwid = process.dwid\n" + \
               "  AND process.name = delete_keys.process_name;"
