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


def get_history_octane_etl_process_metadata(edw_connection: DBConnection) -> dict:
    """Get a mapping between history_octane table names and metadata about the ETL processes that populate those tables.

    Returns a dict with the following structure:
    {
        <table_name1>: {
            'process': <process_name>,
            'next_processes': [
                <process1>,
                <process2>,
                ...
            ]
        },
        <table_name2>: {...},
        ...
    }
    """
    with edw_connection as cursor:
        raw_table_etl_processes = cursor.execute_and_fetch_all_results("""
            SELECT table_output_step.target_table
                 , process.name AS process
            FROM mdi.process
            JOIN mdi.table_output_step
                 ON process.dwid = table_output_step.process_dwid
            WHERE table_output_step.target_schema = 'history_octane';
        """)

        raw_next_etl_processes = cursor.execute_and_fetch_all_results("""
            SELECT table_output_step.target_table
                 , next_process.name AS next_process
            FROM mdi.state_machine_step
            JOIN mdi.process
                 ON state_machine_step.process_dwid = process.dwid
            JOIN mdi.process next_process
                 ON state_machine_step.next_process_dwid = next_process.dwid
            JOIN mdi.table_output_step
                 ON process.dwid = table_output_step.process_dwid
            WHERE table_output_step.target_schema = 'history_octane';
        """)

        table_etl_processes = {row['target_table']: {'process': row['process'], 'next_processes': []} for row in raw_table_etl_processes}
        for row in raw_next_etl_processes:
            table_etl_processes[row['target_table']]['next_processes'].append(row['next_process'])
        return table_etl_processes


def get_max_staging_to_history_server_process_number(edw_connection: DBConnection) -> int:
    """Get numeric component of the largest SP number currently assigned to a staging_octane -> history_octane ETL."""
    with edw_connection as cursor:
        return cursor.execute_and_fetch_all_results("""
            SELECT SUBSTRING( MAX( process.name ), 4 )::INT AS max_process_number
            FROM mdi.process
            WHERE process.name LIKE 'SP-1_____';
        """)[0]['max_process_number']


def get_history_octane_metadata_for_deleted_columns(edw_connection: DBConnection) -> List[dict]:
    """Get metadata about all history_octane columns (and their tables) from EDW's staging database information_schema.

    Returns a list of dicts, each with the following structure:
    {
        'table_name': <table_name>,
        'column_name': <column_name>,
        'data_type': <data_type>,
    }
    """
    with edw_connection as cursor:
        return cursor.execute_and_fetch_all_results("""
            SELECT history_columns.table_name
                 , history_columns.column_name
                 , CASE
                       WHEN history_columns.data_type = 'numeric'
                           THEN 'NUMERIC(' || history_columns.numeric_precision || ',' || history_columns.numeric_scale || ')'
                       WHEN history_columns.data_type = 'character varying'
                           THEN 'VARCHAR(' || history_columns.character_maximum_length || ')'
                       WHEN history_columns.data_type = 'timestamp with time zone'
                           THEN 'TIMESTAMPTZ'
                       WHEN history_columns.data_type = 'timestamp without time zone'
                           THEN 'TIMESTAMP'
                       WHEN history_columns.data_type = 'time with time zone'
                           THEN 'TIMETZ'
                       WHEN history_columns.data_type = 'time without time zone'
                           THEN 'TIME'
                       ELSE
                           UPPER( history_columns.data_type )
                END AS data_type
            FROM information_schema.columns history_columns
            WHERE history_columns.table_schema = 'history_octane'
            ORDER BY history_columns.table_name, history_columns.ordinal_position;
""")
