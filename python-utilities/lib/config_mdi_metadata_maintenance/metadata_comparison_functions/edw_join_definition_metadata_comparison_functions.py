from typing import List

from lib.config_mdi_metadata_maintenance.metadata_comparison_functions.metadata_comparison_functions import MetadataComparisonFunctions
from lib.db_connections import LocalEDWConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, SingleGroupRowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, ForeignKeyMetadata, TableAddress


class EDWJoinDefinitionMetadataComparisonFunctions(MetadataComparisonFunctions):

    def __init__(self):
        super().__init__(key_fields=[
            'primary_database_name',
            'primary_schema_name',
            'primary_table_name',
            'target_database_name',
            'target_schema_name',
            'target_table_name',
            'join_condition'
        ])

    def construct_metadata_table_from_config_db(self, local_edw_connection: LocalEDWConnection) -> MetadataTable:
        return self.construct_metadata_table_from_sql_query_results(local_edw_connection, """
                SELECT primary_table_definition.database_name AS primary_database_name
                     , primary_table_definition.schema_name AS primary_schema_name
                     , primary_table_definition.table_name AS primary_table_name
                     , target_table_definition.database_name AS target_database_name
                     , target_table_definition.schema_name AS target_schema_name
                     , target_table_definition.table_name AS target_table_name
                     , REGEXP_REPLACE(edw_join_definition.join_condition, 't[0-9]+\.', 'target_table.') AS join_condition
                FROM mdi.edw_join_definition
                JOIN mdi.edw_table_definition primary_table_definition
                     ON primary_table_definition.dwid = edw_join_definition.primary_edw_table_definition_dwid
                JOIN mdi.edw_table_definition target_table_definition
                     ON target_table_definition.dwid = edw_join_definition.target_edw_table_definition_dwid
                -- hardcoded to only check staging/history_octane until this script is updated to handle other schemas' join metadata
                WHERE primary_table_definition.schema_name IN ('staging_octane', 'history_octane')
                  AND target_table_definition.schema_name IN ('staging_octane', 'history_octane');
            """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for foreign_key in table.foreign_keys:
                        metadata_table.add_row({
                            'primary_database_name': database.name,
                            'primary_schema_name': schema.name,
                            'primary_table_name': table.name,
                            'target_database_name': foreign_key.table.database,
                            'target_schema_name': foreign_key.table.schema,
                            'target_table_name': foreign_key.table.table,
                            'join_condition': self.construct_join_condition_string(table.address, foreign_key)
                        })
        return metadata_table

    @staticmethod
    def construct_join_condition_string(primary_table: TableAddress, foreign_key: ForeignKeyMetadata) -> str:
        if len(foreign_key.native_columns) != len(foreign_key.foreign_columns):
            raise ValueError(f'Unable to generate join condition for foreign key "{foreign_key.name}" in table '
                             f'{primary_table.database}.{primary_table.schema}.{primary_table.table}. Primary table has a '
                             f'different number of join columns than target table.')
        else:
            primary_columns = foreign_key.native_columns
            target_columns = foreign_key.foreign_columns
            return ' AND '.join([f'primary_table.{primary_columns[i]} = target_table.{target_columns[i]}'
                                 for i in range(len(foreign_key.native_columns))])

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "WITH insert_rows (primary_database_name, primary_schema_name, primary_table_name, target_database_name, target_schema_name, target_table_name, join_condition) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "INSERT\n" + \
               "INTO mdi.edw_join_definition (dwid, primary_edw_table_definition_dwid, target_edw_table_definition_dwid, join_type, join_condition)\n" + \
               "SELECT NEXTVAL( 'mdi.edw_join_definition_dwid_seq' )\n" + \
               "     , primary_table.dwid\n" + \
               "     , target_table.dwid\n" + \
               "     , 'left'\n" + \
               "     , REPLACE( insert_rows.join_condition, 'target_table', 't' || CURRVAL( 'mdi.edw_join_definition_dwid_seq' ) )\n" + \
               "FROM insert_rows\n" + \
               "JOIN mdi.edw_table_definition primary_table\n" + \
               "     ON insert_rows.primary_database_name = primary_table.database_name\n" + \
               "         AND insert_rows.primary_schema_name = primary_table.schema_name\n" + \
               "         AND insert_rows.primary_table_name = primary_table.table_name\n" + \
               "JOIN mdi.edw_table_definition target_table\n" + \
               "     ON insert_rows.target_database_name = target_table.database_name\n" + \
               "         AND insert_rows.target_schema_name = target_table.schema_name\n" + \
               "         AND insert_rows.target_table_name = target_table.table_name;"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return ""  # since edw_join_definition has no non-key values, it will never need to generate any updates (only inserts/deletes)

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (primary_database_name, primary_schema_name, primary_table_name, target_database_name, target_schema_name, target_table_name, join_condition) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.edw_join_definition\n" + \
               "    USING delete_keys, edw_table_definition primary_table, edw_table_definition target_table\n" + \
               "WHERE delete_keys.primary_database_name = primary_table.database_name\n" + \
               "  AND delete_keys.primary_schema_name = primary_table.schema_name\n" + \
               "  AND delete_keys.primary_table_name = primary_table.table_name\n" + \
               "  AND delete_keys.target_database_name = target_table.database_name\n" + \
               "  AND delete_keys.target_schema_name = target_table.schema_name\n" + \
               "  AND delete_keys.target_table_name = target_table.table_name\n" + \
               "  AND primary_table.dwid = edw_join_definition.primary_edw_table_definition_dwid\n" + \
               "  AND target_table.dwid = edw_join_definition.target_edw_table_definition_dwid\n" + \
               "  AND delete_keys.join_condition = REGEXP_REPLACE( edw_join_definition.join_condition, 't[0-9]+\.', 'target_table.' );"
