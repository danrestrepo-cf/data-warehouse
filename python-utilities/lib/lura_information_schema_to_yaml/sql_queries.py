from lib.db_connections import OctaneDBConnection


def get_octane_column_metadata(octane_connection: OctaneDBConnection) -> dict:
    with octane_connection as cursor:
        return cursor.select_as_list_of_dicts("""
                SELECT columns.table_name
                    , columns.column_name
                    , UPPER( columns.column_type ) AS column_type
                    , columns.column_key = 'PRI' AS is_primary_key
                FROM information_schema.columns
                WHERE columns.table_schema = 'lura_qa'
                ORDER BY columns.table_name, columns.ordinal_position;
            """)


def get_octane_foreign_key_metadata(octane_connection: OctaneDBConnection) -> dict:
    with octane_connection as cursor:
        return cursor.select_as_list_of_dicts("""
                SELECT table_name
                    , column_name
                    , constraint_name
                    , referenced_table_name
                    , referenced_column_name
                FROM information_schema.key_column_usage
                WHERE key_column_usage.referenced_table_schema IS NOT NULL;
            """)
