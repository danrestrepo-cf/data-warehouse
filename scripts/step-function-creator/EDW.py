from typing import List

import psycopg2
import psycopg2.extras


class EDW:

    def __init__(self,
                 db_name="config",
                 db_username="postgres",
                 db_password="testonly",
                 db_hostname="localhost",
                 db_port="5432"):
        self.database_name = db_name
        self.database_username = db_username
        self.database_password = db_password
        self.database_hostname = db_hostname
        self.database_port = db_port

    def __str__(self) -> str:
        return f"EDW object with the connection details: \nhostname: '{self.database_hostname}'\nport: '{self.database_port}'\ndatabase name: '{self.database_name}'\nusername: '{self.database_username}'"

    def execute_query(self, query: str, *args) -> list:
        conn = psycopg2.connect(database=self.database_name,
                                user=self.database_username,
                                password=self.database_password,
                                host=self.database_hostname,
                                port=self.database_port)

        cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        cur.execute(query, args)
        conn.commit()
        rows = cur.fetchall()
        conn.close()

        return rows

    def get_step_tree_metadata(self) -> List[dict]:
        return self.execute_query('''
            SELECT parent_process.name AS process_name
                 , child_process.name AS child_process_name
            FROM mdi.state_machine_step
            JOIN mdi.process parent_process
                 ON parent_process.dwid = state_machine_step.process_dwid
            LEFT JOIN mdi.process child_process
                      ON child_process.dwid = state_machine_step.next_process_dwid
            ORDER BY parent_process.name, child_process.name;
        ''')

    def get_state_machine_metadata(self) -> List[dict]:
        return self.execute_query('''
            SELECT process.name AS process_name
                 , state_machine_definition.name AS state_machine_name
                 , state_machine_definition.comment AS comment
                 , state_machine_definition.cron_schedule AS cron_schedule
            FROM mdi.state_machine_definition
            JOIN mdi.process
                 ON state_machine_definition.process_dwid = process.dwid
            ORDER BY process.name;
        ''')

    def get_target_table_metadata(self) -> List[dict]:
        return self.execute_query('''
            SELECT etl_processes.process_name
                 , etl_processes.target_table
                 , table_column_counts.column_count AS target_table_column_count
            FROM (
                SELECT process.name AS process_name
                     , table_output_step.target_table
                     , table_output_step.target_schema
                FROM mdi.process
                JOIN mdi.table_output_step
                     ON process.dwid = table_output_step.process_dwid
                UNION ALL
                SELECT process.name AS process_name
                     , insert_update_step.table_name AS target_table
                     , insert_update_step.schema_name AS target_schema
                FROM mdi.process
                JOIN mdi.insert_update_step
                     ON process.dwid = insert_update_step.process_dwid
                UNION ALL
                SELECT process.name AS process_name
                     , delete_step.table_name AS target_table
                     , delete_step.schema_name AS target_schema
                FROM mdi.process
                JOIN mdi.delete_step
                     ON process.dwid = delete_step.process_dwid
            ) AS etl_processes
            LEFT JOIN (
                SELECT edw_table_definition.schema_name
                     , edw_table_definition.table_name
                     , COUNT( edw_field_definition ) AS column_count
                FROM mdi.edw_table_definition
                JOIN mdi.edw_field_definition
                     ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
                GROUP BY edw_table_definition.schema_name
                       , edw_table_definition.table_name
            ) AS table_column_counts
                      ON etl_processes.target_schema = table_column_counts.schema_name
                          AND etl_processes.target_table = table_column_counts.table_name;
        ''')
