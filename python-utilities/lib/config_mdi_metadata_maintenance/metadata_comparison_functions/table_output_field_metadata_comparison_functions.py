from typing import List

from lib.config_mdi_metadata_maintenance.metadata_comparison_functions.metadata_comparison_functions import MetadataComparisonFunctions
from lib.db_connections import DBConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, SingleGroupRowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, ETLOutputType


class TableOutputFieldMetadataComparisonFunctions(MetadataComparisonFunctions):
    """The set of metadata comparison functions used to maintain config.mdi.table_output_field."""

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
                WHERE table_output_step.target_schema IN ('history_octane', 'star_loan', 'data_mart_business_applications');
            """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        # The inclusion of star_* schema specific 'standard' fields and other star_loan columns involved in insert-only
        # ETLs in the below list is a TEMPORARY workaround.
        # Such fields should be removed from this script once they are parseable by python-utilities;
        # see task https://app.asana.com/0/0/1201468659414065 for more information.
        temp_sourceless_fields = ['data_source_updated_datetime', 'data_source_deleted_flag', 'etl_batch_id',
                                  'data_source_dwid', 'edw_created_datetime', 'edw_modified_datetime',
                                  'data_source_integration_columns', 'data_source_integration_id',
                                  'data_source_modified_datetime', 'octane_username', 'loan_dwid', 'account_pid',
                                  'borrower_dwid', 'borrower_pid', 'borrower_hmda_collection_dwid', 'borrower_counseling_dwid',
                                  'borrower_employee_status_dwid', 'borrower_finances_declarations_dwid', 'borrower_hmda_ethnicity_dwid',
                                  'borrower_hmda_race_dwid', 'borrower_hmda_sex_dwid', 'borrower_junk_dwid',
                                  'borrower_pre_umdp_declarations_dwid', 'borrower_property_declarations_dwid', 'borrower_relations_dwid']
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for step_function in table.step_functions:
                        for etl in step_function.etls:
                            if etl.output_type == ETLOutputType.INSERT:
                                for column in table.columns:
                                    if column.source is not None or column.name in temp_sourceless_fields:
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
