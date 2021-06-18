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
