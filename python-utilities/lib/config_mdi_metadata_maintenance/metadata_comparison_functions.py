from typing import List
from abc import ABC, abstractmethod

from lib.db_connections import LocalEDWConnection
from lib.config_mdi_metadata_maintenance.metadata_table import MetadataTable, Row
from lib.config_mdi_metadata_maintenance.row_grouper import RowGrouper, SingleGroupRowGrouper
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata, ETLMetadata, TableAddress


class MetadataComparisonFunctions(ABC):

    def __init__(self, key_fields: List[str]):
        self.key_fields = key_fields

    @abstractmethod
    def construct_metadata_table_from_config_db(self, local_edw_connection: LocalEDWConnection) -> MetadataTable:
        pass

    @abstractmethod
    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        pass

    @abstractmethod
    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        pass

    @abstractmethod
    def generate_insert_sql(self, rows: List[Row]) -> str:
        pass

    @abstractmethod
    def generate_update_sql(self, rows: List[Row]) -> str:
        pass

    @abstractmethod
    def generate_delete_sql(self, rows: List[Row]) -> str:
        pass

    def construct_metadata_table_from_sql_query_results(self, local_edw_connection: LocalEDWConnection, sql_query: str) -> MetadataTable:
        with local_edw_connection as cursor:
            raw_data = cursor.select(sql_query)
            metadata_table = self.construct_empty_metadata_table()
            metadata_table.add_rows(raw_data)
            return metadata_table

    def construct_empty_metadata_table(self) -> MetadataTable:
        return MetadataTable(self.key_fields)

    @staticmethod
    def construct_process_description(table: TableAddress, source_table: TableAddress, etl: ETLMetadata) -> str:
        if table.database == 'staging' and table.schema == 'history_octane' and source_table.database == 'staging' and source_table.schema == 'staging_octane':
            return f'ETL to copy {table.table} data from staging_octane to history_octane'
        else:
            return f'{etl.input_type.value} -> table-{etl.output_type.value} ETL from ' \
                   f'{source_table.database}.{source_table.schema}.{source_table.table} to {table.database}.{table.schema}.{table.table}'

    def construct_values_string_from_full_rows(self, rows: List[Row], base_indent: int = 0) -> str:
        full_rows = [row.full_row for row in rows]
        return self.construct_values_string_from_list_of_dicts(full_rows, base_indent)

    def construct_values_string_from_row_keys(self, rows: List[Row], base_indent: int = 0) -> str:
        row_keys = [row.key for row in rows]
        return self.construct_values_string_from_list_of_dicts(row_keys, base_indent)

    @staticmethod
    def construct_values_string_from_list_of_dicts(data: List[dict], base_indent: int = 0) -> str:
        indent_str = ' ' * (base_indent + 5)  # 5 is the length of the string "VALUES"
        return ('\n' + indent_str + ', ').join(['(' + ', '.join([f"'{value}'" for value in d.values()]) + ')' for d in data])


class ProcessMetadataComparisonFunctions(MetadataComparisonFunctions):

    def __init__(self):
        super().__init__(key_fields=['process_name'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: LocalEDWConnection) -> MetadataTable:
        return self.construct_metadata_table_from_sql_query_results(local_edw_connection, """
                SELECT process.name AS process_name
                     , process.description AS process_description
                FROM mdi.process
                JOIN mdi.table_output_step
                     ON process.dwid = table_output_step.process_dwid
                -- hardcoded to only check history_octane until this script is updated to handle other schemas' ETLs
                WHERE table_output_step.target_schema = 'history_octane';
            """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for etl in table.etls:
                        description = self.construct_process_description(table.address, table.primary_source_table, etl)
                        metadata_table.add_row({'process_name': etl.process_name, 'process_description': description})
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "INSERT\n" + \
               "INTO mdi.process\n" + \
               "VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=0) + ";"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return "WITH update_rows (process_name, process_description) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "UPDATE mdi.process\n" + \
               "SET description = update_rows.process_description\n" + \
               "FROM update_rows\n" + \
               "WHERE update_rows.process_name = process.name;"

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (process_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.process\n" + \
               "USING delete_keys\n" + \
               "WHERE process.name = delete_keys.process_name;"


class JSONOutputFieldMetadataComparisonFunctions(MetadataComparisonFunctions):

    def __init__(self):
        super().__init__(key_fields=['process_name'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: LocalEDWConnection) -> MetadataTable:
        return self.construct_metadata_table_from_sql_query_results(local_edw_connection, """
                SELECT process.name AS process_name
                     , json_output_field.field_name AS json_output_field
                FROM mdi.json_output_field
                JOIN mdi.process
                     ON json_output_field.process_dwid = process.dwid
                JOIN mdi.table_output_step
                     ON process.dwid = table_output_step.process_dwid
                -- hardcoded to only check history_octane until this script is updated to handle other schemas' ETLs
                WHERE table_output_step.target_schema = 'history_octane';
            """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for etl in table.etls:
                        metadata_table.add_row({'process_name': etl.process_name, 'json_output_field': etl.json_output_field})
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "WITH insert_rows (process_name, json_output_field) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "INSERT\n" + \
               "INTO mdi.json_output_field (process_dwid, field_name)\n" + \
               "SELECT process.dwid, insert_rows.json_output_field\n" + \
               "FROM insert_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON insert_rows.process_name = process.name;"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return "WITH update_rows (process_name, json_output_field) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "UPDATE mdi.json_output_field\n" + \
               "SET field_name = update_rows.json_output_field\n" + \
               "FROM update_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON process.name = update_rows.process_name\n" + \
               "WHERE json_output_field.process_dwid = process.dwid;"

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (process_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.json_output_field\n" + \
               "    USING delete_keys, mdi.process\n" + \
               "WHERE json_output_field.process_dwid = process.dwid\n" + \
               "  AND process.name = delete_keys.process_name;"


class StateMachineDefinitionMetadataComparisonFunctions(MetadataComparisonFunctions):

    def __init__(self):
        super().__init__(key_fields=['process_name'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: LocalEDWConnection) -> MetadataTable:
        return self.construct_metadata_table_from_sql_query_results(local_edw_connection, """
                SELECT process.name AS process_name
                     , state_machine_definition.name AS state_machine_name
                     , state_machine_definition.comment AS state_machine_comment
                FROM mdi.state_machine_definition
                JOIN mdi.process
                     ON state_machine_definition.process_dwid = process.dwid
                JOIN mdi.table_output_step
                     ON process.dwid = table_output_step.process_dwid
                -- hardcoded to only check history_octane until this script is updated to handle other schemas' ETLs
                WHERE table_output_step.target_schema = 'history_octane';
            """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for etl in table.etls:
                        comment = self.construct_process_description(table.address, table.primary_source_table, etl)
                        metadata_table.add_row({'process_name': etl.process_name, 'state_machine_name': etl.process_name,
                                                'state_machine_comment': comment})
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "INSERT\n" + \
               "INTO mdi.state_machine_definition (process_dwid, name, comment)\n" + \
               "SELECT process.dwid, insert_rows.state_machine_name, insert_rows.state_machine_comment\n" + \
               "FROM insert_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON process.name = insert_rows.process_name;"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return "WITH update_rows (process_name, state_machine_name, state_machine_comment) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "UPDATE mdi.state_machine_definition\n" + \
               "SET name = update_rows.state_machine_name\n" + \
               "  , comment = update_rows.state_machine_comment\n" + \
               "FROM update_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON process.name = update_rows.process_name\n" + \
               "WHERE process.dwid = state_machine_definition.process_dwid;"

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (process_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.state_machine_definition\n" + \
               "    USING delete_keys, mdi.process\n" + \
               "WHERE state_machine_definition.process_dwid = process.dwid\n" + \
               "  AND process.name = delete_keys.process_name;"


class StateMachineStepMetadataComparisonFunctions(MetadataComparisonFunctions):

    def __init__(self):
        super().__init__(key_fields=['process_name', 'next_process_name'])

    def construct_metadata_table_from_config_db(self, local_edw_connection: LocalEDWConnection) -> MetadataTable:
        return self.construct_metadata_table_from_sql_query_results(local_edw_connection, """
                SELECT process.name AS process_name
                     , next_process.name AS next_process_name
                FROM mdi.state_machine_step
                JOIN mdi.process
                     ON state_machine_step.process_dwid = process.dwid
                JOIN mdi.process next_process
                     ON state_machine_step.next_process_dwid = next_process.dwid
                JOIN mdi.table_output_step
                     ON process.dwid = table_output_step.process_dwid
                -- hardcoded to only check history_octane until this script is updated to handle other schemas' ETLs
                WHERE table_output_step.target_schema = 'history_octane';
            """)

    def construct_metadata_table_from_source(self, data_warehouse_metadata: DataWarehouseMetadata) -> MetadataTable:
        metadata_table = self.construct_empty_metadata_table()
        for database in data_warehouse_metadata.databases:
            for schema in database.schemas:
                for table in schema.tables:
                    for etl in table.etls:
                        for next_etl_process_name in table.next_etls:
                            metadata_table.add_row({'process_name': etl.process_name, 'next_process_name': next_etl_process_name})
        return metadata_table

    def construct_insert_row_grouper(self, data_warehouse_metadata: DataWarehouseMetadata) -> RowGrouper:
        return SingleGroupRowGrouper()

    def generate_insert_sql(self, rows: List[Row]) -> str:
        return "WITH insert_rows (process_name, next_process_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_full_rows(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "INSERT\n" + \
               "INTO mdi.state_machine_step (process_dwid, next_process_dwid)\n" + \
               "SELECT process.dwid, next_process.dwid\n" + \
               "FROM insert_rows\n" + \
               "JOIN mdi.process\n" + \
               "     ON process.name = insert_rows.process_name\n" + \
               "JOIN mdi.process next_process\n" + \
               "     ON next_process.name = insert_rows.next_process_name;"

    def generate_update_sql(self, rows: List[Row]) -> str:
        return ''  # since state_machine_step has no non-key values, it will never need to generate any updates (only inserts/deletes)

    def generate_delete_sql(self, rows: List[Row]) -> str:
        return "WITH delete_keys (process_name, next_process_name) AS (\n" + \
               "    VALUES " + self.construct_values_string_from_row_keys(rows, base_indent=4) + "\n" + \
               ")\n" + \
               "DELETE\n" + \
               "FROM mdi.state_machine_step\n" + \
               "    USING delete_keys, mdi.process, mdi.process next_process\n" + \
               "WHERE state_machine_step.process_dwid = process.dwid\n" + \
               "  AND state_machine_step.next_process_dwid = next_process.dwid\n" + \
               "  AND delete_keys.process_name = process.name\n" + \
               "  AND delete_keys.next_process_name = next_process.name;"
