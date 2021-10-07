from dataclasses import dataclass

from lib.db_connections import LocalEDWConnection
from lib.metadata_core.data_warehouse_metadata import DataWarehouseMetadata
from lib.config_mdi_metadata_maintenance.metadata_comparison_functions import MetadataComparisonFunctions


@dataclass
class TableMaintenanceSQL:
    insert_sql: str
    update_sql: str
    delete_sql: str


def generate_metadata_maintenance_sql(edw_connection: LocalEDWConnection, source_metadata: DataWarehouseMetadata,
                                      comparison_functions: MetadataComparisonFunctions) -> TableMaintenanceSQL:
    config_metadata_table = comparison_functions.construct_metadata_table_from_config_db(edw_connection)
    source_metadata_table = comparison_functions.construct_metadata_table_from_source(source_metadata)
    insert_row_grouper = comparison_functions.construct_insert_row_grouper(source_metadata)
    insert_rows = []
    for row in source_metadata_table.rows:
        if not config_metadata_table.row_exists_with_key(row.key):
            insert_rows.append(row)

    if len(insert_rows) > 0:
        insert_row_groups = insert_row_grouper.group_rows(insert_rows)
        insert_sql = '\n\n'.join([comparison_functions.generate_insert_sql(group) for group in insert_row_groups])
    else:
        insert_sql = ''

    return TableMaintenanceSQL(
        insert_sql=insert_sql,
        update_sql='',
        delete_sql=''
    )
