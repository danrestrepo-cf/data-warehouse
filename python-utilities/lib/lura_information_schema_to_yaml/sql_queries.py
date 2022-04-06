"""A set of SQL queries used to generate source data for the metadata YAML generation process."""

from typing import List

from lib.db_connections import DBConnection


def get_octane_column_metadata(octane_connection: DBConnection) -> List[dict]:
    """Get metadata about all columns (and their tables) from an Octane DB's information_schema.

    Returns a list of dicts, each with the following structure:
    {
        'table_name': <table_name>,
        'column_name': <column_name>,
        'column_type': <column_type>,
        'is_primary_key': <is_primary_key> (either 0 or 1, because MySQL doesn't have a native boolean type)
    }
    """
    with octane_connection as cursor:
        return cursor.execute_and_fetch_all_results("""
                SELECT columns.table_name
                    , columns.column_name
                    , UPPER( columns.column_type ) AS column_type
                    , columns.column_key = 'PRI' AS is_primary_key
                FROM information_schema.columns
                WHERE columns.table_schema = 'lura_cert'
                ORDER BY columns.table_name, columns.ordinal_position;
            """)


def get_octane_foreign_key_metadata(octane_connection: DBConnection) -> List[dict]:
    """Get metadata about all foreign keys from an Octane DB's information_schema.

    Returns a list of dicts, each with the following structure:
    {
        'table_name': <table_name>,
        'column_name': <column_name>,
        'constraint_name': <constraint_name>,
        'referenced_table_name': <referenced_table_name>,
        'referenced_column_name': <referenced_column_name>
    }
    """
    with octane_connection as cursor:
        return cursor.execute_and_fetch_all_results("""
                SELECT table_name
                    , column_name
                    , constraint_name
                    , referenced_table_name
                    , referenced_column_name
                FROM information_schema.key_column_usage
                WHERE key_column_usage.referenced_table_schema IS NOT NULL
                    AND key_column_usage.referenced_table_schema = 'lura_cert';
            """)
