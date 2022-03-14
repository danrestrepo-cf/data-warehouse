from typing import List

from lib.config_mdi_metadata_maintenance.metadata_comparison_functions.metadata_comparison_functions import MetadataComparisonFunctions
from lib.db_connections import DBConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, SingleGroupRowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, ETLInputType


class TableInputStepMetadataComparisonFunctions(MetadataComparisonFunctions):
    """The set of metadata comparison functions used to maintain config.mdi.table_input_step."""

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
                    , table_input_step.data_source_dwid
                    , TRANSLATE(table_input_step.sql, E'\r', '') AS sql --standardize line endings for easier comparison
                    , table_input_step.connectionname
                FROM mdi.table_input_step
                JOIN filtered_process process
                     ON table_input_step.process_dwid = process.dwid;
            """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for step_function in table.step_functions:
                        for etl in step_function.etls:
                            if etl.input_type == ETLInputType.TABLE:
                                data_source_dwid = etl.hardcoded_data_source.value if etl.hardcoded_data_source else 0
                                metadata_table.add_row({
                                    'process_name': etl.process_name,
                                    'data_source_dwid': data_source_dwid,
                                    'sql': etl.input_sql,
                                    'connectionname': self.get_connection_name(database.name)
                                })
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        return SingleGroupRowGrouper()

    def construct_delete_row_grouper(self, metadata_table: MetadataTable) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "INSERT\n" + \
               "INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)\n" + \
               "SELECT process.dwid, insert_rows.data_source_dwid, insert_rows.sql, 0, 'N', 'N', 'N', 'N', insert_rows.connectionname::mdi.pentaho_db_connection_name\n" + \
               "FROM insert_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON process.name = insert_rows.process_name;"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return "WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "UPDATE mdi.table_input_step\n" + \
               "SET data_source_dwid = update_rows.data_source_dwid\n" + \
               "  , sql = update_rows.sql\n" + \
               "  , connectionname = update_rows.connectionname::mdi.pentaho_db_connection_name\n" + \
               "FROM update_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON process.name = update_rows.process_name\n" + \
               "WHERE process.dwid = table_input_step.process_dwid;"

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (process_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.table_input_step\n" + \
               "    USING delete_keys, mdi.process\n" + \
               "WHERE table_input_step.process_dwid = process.dwid\n" + \
               "  AND process.name = delete_keys.process_name;"
