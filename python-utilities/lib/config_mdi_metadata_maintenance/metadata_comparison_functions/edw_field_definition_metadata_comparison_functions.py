from typing import List

from lib.config_mdi_metadata_maintenance.metadata_comparison_functions.metadata_comparison_functions import MetadataComparisonFunctions
from lib.db_connections import DBConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.config_mdi_metadata_maintenance.dependency_row_grouper_generator import (DependencyRowGrouperGenerator,
                                                                                  FieldInsertNodeLineageTracer,
                                                                                  FieldDeleteNodeLineageTracer)


class EDWFieldDefinitionMetadataComparisonFunctions(MetadataComparisonFunctions):
    """The set of metadata comparison functions used to maintain config.mdi.edw_field_definition."""

    def __init__(self):
        super().__init__(key_fields=[
            'database_name',
            'schema_name',
            'table_name',
            'field_name'
        ])

    def construct_metadata_table_from_config_db(self, local_edw_connection: DBConnection) -> MetadataTable:
        return self.construct_metadata_table_from_sql_query_results(local_edw_connection, """
                SELECT edw_table_definition.database_name
                     , edw_table_definition.schema_name
                     , edw_table_definition.table_name
                     , edw_field_definition.field_name
                     , edw_field_definition.data_type
                     , source_table_definition.database_name AS source_database_name
                     , source_table_definition.schema_name AS source_schema_name
                     , source_table_definition.table_name AS source_table_name
                     , source_field_definition.field_name AS source_field_name
                FROM mdi.edw_table_definition
                JOIN mdi.edw_field_definition
                     ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
                LEFT JOIN mdi.edw_field_definition source_field_definition
                          ON edw_field_definition.source_edw_field_definition_dwid = source_field_definition.dwid
                LEFT JOIN mdi.edw_table_definition source_table_definition
                          ON source_field_definition.edw_table_definition_dwid = source_table_definition.dwid
                WHERE edw_table_definition.schema_name IN ('staging_octane', 'history_octane', 'star_loan', 'star_common', 'data_mart_business_applications')
                  AND (source_table_definition.schema_name IN ('staging_octane', 'history_octane', 'star_loan', 'star_common', 'data_mart_business_applications')
                    OR source_table_definition.schema_name IS NULL);
            """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for column in table.columns:
                        row = {
                            'database_name': database.name,
                            'schema_name': schema.name,
                            'table_name': table.name,
                            'field_name': column.name,
                            'data_type': column.data_type
                        }
                        if column.source is None or column.source.calculation_string is not None:
                            row['source_database_name'] = None
                            row['source_schema_name'] = None
                            row['source_table_name'] = None
                            row['source_field_name'] = None
                        else:
                            source_column_path = table.get_source_column_paths(column.name, data_warehouse_metadata)[0]
                            row['source_database_name'] = source_column_path.database
                            row['source_schema_name'] = source_column_path.schema
                            row['source_table_name'] = source_column_path.table
                            row['source_field_name'] = source_column_path.column
                        metadata_table.add_row(row)
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        row_grouper_generator = DependencyRowGrouperGenerator(FieldInsertNodeLineageTracer(data_warehouse_metadata))
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for column in table.columns:
                        dependency_tree_node_key = {
                            'database_name': database.name,
                            'schema_name': schema.name,
                            'table_name': table.name,
                            'field_name': column.name
                        }
                        row_grouper_generator.calculate_and_store_dependency_tree_node_depth(dependency_tree_node_key)
        return row_grouper_generator.generate_row_grouper()

    def construct_delete_row_grouper(self, metadata_table: MetadataTable) -> RowGrouper:
        row_grouper_generator = DependencyRowGrouperGenerator(FieldDeleteNodeLineageTracer(metadata_table))
        for row in metadata_table.rows:
            row_grouper_generator.calculate_and_store_dependency_tree_node_depth(row.key)
        return row_grouper_generator.generate_row_grouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "INSERT\n" + \
               "INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)\n" + \
               "SELECT edw_table_definition.dwid, insert_rows.field_name, FALSE, source_field_definition.dwid, NULL, insert_rows.data_type, NULL, NULL, NULL, NULL\n" + \
               "FROM insert_rows\n" + \
               "JOIN mdi.edw_table_definition\n" + \
               "     ON insert_rows.database_name = edw_table_definition.database_name\n" + \
               "         AND insert_rows.schema_name = edw_table_definition.schema_name\n" + \
               "         AND insert_rows.table_name = edw_table_definition.table_name\n" + \
               "LEFT JOIN mdi.edw_table_definition source_table_definition\n" + \
               "          ON insert_rows.source_database_name = source_table_definition.database_name\n" + \
               "              AND insert_rows.source_schema_name = source_table_definition.schema_name\n" + \
               "              AND insert_rows.source_table_name = source_table_definition.table_name\n" + \
               "LEFT JOIN mdi.edw_field_definition source_field_definition\n" + \
               "          ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid\n" + \
               "              AND insert_rows.source_field_name = source_field_definition.field_name;"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return "WITH update_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "UPDATE mdi.edw_field_definition\n" + \
               "SET data_type = update_rows.data_type\n" + \
               "  , source_edw_field_definition_dwid = source_field_definition.dwid\n" + \
               "FROM update_rows\n" + \
               "JOIN mdi.edw_table_definition\n" + \
               "     ON update_rows.database_name = edw_table_definition.database_name\n" + \
               "         AND update_rows.schema_name = edw_table_definition.schema_name\n" + \
               "         AND update_rows.table_name = edw_table_definition.table_name\n" + \
               "LEFT JOIN mdi.edw_table_definition source_table_definition\n" + \
               "          ON update_rows.source_database_name = source_table_definition.database_name\n" + \
               "              AND update_rows.source_schema_name = source_table_definition.schema_name\n" + \
               "              AND update_rows.source_table_name = source_table_definition.table_name\n" + \
               "LEFT JOIN mdi.edw_field_definition source_field_definition\n" + \
               "          ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid\n" + \
               "              AND update_rows.source_field_name = source_field_definition.field_name\n" + \
               "WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid\n" + \
               "  AND edw_field_definition.field_name = update_rows.field_name;"

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (database_name, schema_name, table_name, field_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.edw_field_definition\n" + \
               "    USING delete_keys, mdi.edw_table_definition\n" + \
               "WHERE edw_table_definition.database_name = delete_keys.database_name\n" + \
               "  AND edw_table_definition.schema_name = delete_keys.schema_name\n" + \
               "  AND edw_table_definition.table_name = delete_keys.table_name\n" + \
               "  AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid\n" + \
               "  AND edw_field_definition.field_name = delete_keys.field_name;"
