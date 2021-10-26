from dataclasses import dataclass
from typing import List

from lib.db_connections import DBConnection
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import MetadataComparisonFunctions


@dataclass
class TableMaintenanceSQL:
    """A collection of insert, update, and delete SQL statements on a single table.

    This data structure was necessary because, while all three statement categories
    are *generated* together for a given table, they cannot all be *executed* together
    for a single table. Because of the inherent dependencies involved, all Inserts
    appear before all Updates, which appear before all Deletes. This data structure
    is a convenient holding place for a table's maintenance SQL between the time
    it is generated and the time the statement types are split up into their own
    groupings.
    """
    insert_sql: str
    update_sql: str
    delete_sql: str


class MetadataMaintenanceSQLGenerator:
    """A class that compares metadata from EDW's mdi.config schema and YAML files to generate SQL updating mdi.config accordingly.

    This is the primary "connective tissue" class in the process that keeps mdi.config metadata in lockstep with
    the EDW YAML metadata files. It combines and draws on the functionality of the rest of the config_mdi_metadata_maintenance
    module to produce the finished product: executable SQL statements.
    """

    def __init__(self, edw_connection: DBConnection, source_metadata: DataWarehouseMetadata):
        """
        :param edw_connection: a database connection to EDW's config database
        :param source_metadata: a DataWarehouseMetadata object containing the
        "metadata of record" that will be used as a basis for updating the contents
        of the EDW config.mdi schema.
        """
        self._edw_connection = edw_connection
        self._source_metadata = source_metadata
        self._comparison_functions = {}
        self._insert_table_order = []
        self._update_table_order = []
        self._delete_table_order = []

    def add_metadata_comparison_functions(self, table_name: str, comparison_functions: MetadataComparisonFunctions):
        """Add a set of metadata comparison functions to enable generating maintenance SQL for the specified table."""
        self._comparison_functions[table_name] = comparison_functions
        self._insert_table_order.append(table_name)
        self._update_table_order.append(table_name)
        self._delete_table_order.append(table_name)

    def generate_all_metadata_maintenance_sql(self) -> str:
        """Produce the final string of all SQL statements generated using all currently-held set of metadata comparison functions.

        If a given category of SQL statement (e.g. Insertions, Updates, Deletions)
        has no members, then that category will be omitted from the final result.
        For example, of no deletions are necessary, there will simply be no "DELETIONS"
        section in the output.
        """
        maintenance_sql_statements = {}
        for table_name, comparison_functions in self._comparison_functions.items():
            maintenance_sql_statements[table_name] = self.generate_table_metadata_maintenance_sql(comparison_functions)

        statement_separator = '\n\n'

        all_sql_strings = {
            'INSERTIONS': statement_separator.join([
                f'--{table}\n{maintenance_sql_statements[table].insert_sql}' for table in self._insert_table_order
                if maintenance_sql_statements[table].insert_sql != ''
            ]),
            'UPDATES': statement_separator.join([
                f'--{table}\n{maintenance_sql_statements[table].update_sql}' for table in self._update_table_order
                if maintenance_sql_statements[table].update_sql != ''
            ]),
            'DELETIONS': statement_separator.join([
                f'--{table}\n{maintenance_sql_statements[table].delete_sql}' for table in self._delete_table_order
                if maintenance_sql_statements[table].delete_sql != ''
            ])
        }
        return statement_separator.join([f'/*\n{sql_type}\n*/\n\n{sql}' for sql_type, sql in all_sql_strings.items() if sql != ''])

    def generate_table_metadata_maintenance_sql(self, comparison_functions: MetadataComparisonFunctions) -> TableMaintenanceSQL:
        """Produce a collection of Insert, Update, and Delete SQL statements from the given set of metadata comparison functions."""
        config_metadata_table = comparison_functions.construct_metadata_table_from_config_db(self._edw_connection)
        source_metadata_table = comparison_functions.construct_metadata_table_from_source(self._source_metadata)
        insert_row_grouper = comparison_functions.construct_insert_row_grouper(self._source_metadata)
        delete_row_grouper = comparison_functions.construct_delete_row_grouper(config_metadata_table)

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
            delete_row_groups = delete_row_grouper.group_rows(delete_rows)
            delete_sql = '\n\n'.join([comparison_functions.generate_delete_sql(group) for group in delete_row_groups])
        else:
            delete_sql = ''

        return TableMaintenanceSQL(
            insert_sql=insert_sql,
            update_sql=update_sql,
            delete_sql=delete_sql
        )

    def set_insert_table_order(self, table_order: List[str]):
        """Set the order in which INSERT SQL statements will be executed (by table name)."""
        self.validate_table_order_list(table_order)
        self._insert_table_order = table_order

    def set_update_table_order(self, table_order: List[str]):
        """Set the order in which UPDATE SQL statements will be executed (by table name)."""
        self.validate_table_order_list(table_order)
        self._update_table_order = table_order

    def set_delete_table_order(self, table_order: List[str]):
        """Set the order in which DELETE SQL statements will be executed (by table name)."""
        self.validate_table_order_list(table_order)
        self._delete_table_order = table_order

    def validate_table_order_list(self, table_order: List[str]):
        """Throw an error if the given list of table names does not exactly match the known list of tables."""
        missing_tables = []
        for table_name in self._comparison_functions.keys():
            if table_name not in table_order:
                missing_tables.append(table_name)
        extra_tables = []
        for table_name in table_order:
            if table_name not in self._comparison_functions:
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
