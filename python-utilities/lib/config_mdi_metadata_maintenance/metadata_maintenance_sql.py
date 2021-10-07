from dataclasses import dataclass
from typing import List

from lib.db_connections import LocalEDWConnection
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import MetadataComparisonFunctions


@dataclass
class TableMaintenanceSQL:
    insert_sql: str
    update_sql: str
    delete_sql: str


class MetadataMaintenanceSQLGenerator:

    def __init__(self, edw_connection: LocalEDWConnection, source_metadata: DataWarehouseMetadata):
        self.edw_connection = edw_connection
        self.source_metadata = source_metadata
        self.comparison_functions = {}

    def add_metadata_comparison_functions(self, table_name: str, comparison_functions: MetadataComparisonFunctions):
        self.comparison_functions[table_name] = comparison_functions

    def generate_all_metadata_maintenance_sql(self) -> str:
        maintenance_sql_statements = []
        for table_name, comparison_functions in self.comparison_functions.items():
            maintenance_sql_statements.append(self.generate_table_metadata_maintenance_sql(comparison_functions))
        statement_separator = '\n\n'
        insert_statements = statement_separator.join([table_statements.insert_sql for table_statements in maintenance_sql_statements])
        update_statements = statement_separator.join([table_statements.update_sql for table_statements in maintenance_sql_statements])
        delete_statements = statement_separator.join([table_statements.delete_sql for table_statements in maintenance_sql_statements])
        return '--Insertions\n' + \
               insert_statements + \
               statement_separator + \
               '--Updates\n' + \
               update_statements + \
               statement_separator + \
               '--Deletions\n' + \
               delete_statements

    def generate_table_metadata_maintenance_sql(self, comparison_functions: MetadataComparisonFunctions) -> TableMaintenanceSQL:
        config_metadata_table = comparison_functions.construct_metadata_table_from_config_db(self.edw_connection)
        source_metadata_table = comparison_functions.construct_metadata_table_from_source(self.source_metadata)
        insert_row_grouper = comparison_functions.construct_insert_row_grouper(self.source_metadata)

        insert_rows = []
        update_rows = []
        delete_rows = []

        for row in source_metadata_table.rows:
            if not config_metadata_table.row_exists_with_key(row.key):
                insert_rows.append(row)
            elif not row.attributes == config_metadata_table.get_attributes_by_key(row.key):
                update_rows.append(row)

        for row in config_metadata_table.rows:
            if not source_metadata_table.row_exists_with_key(row.key):
                delete_rows.append(row)

        if len(insert_rows) > 0:
            insert_row_groups = insert_row_grouper.group_rows(insert_rows)
            insert_sql = '\n\n'.join([comparison_functions.generate_insert_sql(group) for group in insert_row_groups])
        else:
            insert_sql = ''

        if len(update_rows) > 0:
            update_sql = comparison_functions.generate_update_sql(update_rows)
        else:
            update_sql = ''

        if len(delete_rows) > 0:
            delete_sql = comparison_functions.generate_delete_sql(delete_rows)
        else:
            delete_sql = ''

        return TableMaintenanceSQL(
            insert_sql=insert_sql,
            update_sql=update_sql,
            delete_sql=delete_sql
        )

    def set_insert_table_order(self, table_order: List[str]):
        self.validate_table_order_list(table_order)

    def set_update_table_order(self, table_order: List[str]):
        self.validate_table_order_list(table_order)

    def set_delete_table_order(self, table_order: List[str]):
        self.validate_table_order_list(table_order)

    def validate_table_order_list(self, table_order: List[str]):
        missing_tables = []
        for table_name in self.comparison_functions.keys():
            if table_name not in table_order:
                missing_tables.append(table_name)
        extra_tables = []
        for table_name in table_order:
            if table_name not in self.comparison_functions:
                extra_tables.append(table_name)
        if missing_tables or extra_tables:
            raise self.InvalidTableOrderException(missing_tables=missing_tables, extra_tables=extra_tables)

    class InvalidTableOrderException(Exception):
        def __init__(self, missing_tables: List[str] = None, extra_tables: List[str] = None):
            error_msgs = []
            if missing_tables:
                error_msgs.append(f'Tables missing from table order list: {", ".join(missing_tables)}')
            if extra_tables:
                error_msgs.append(f'Unknown tables in table order list: {", ".join(extra_tables)}')
            super().__init__('; '.join(error_msgs))
