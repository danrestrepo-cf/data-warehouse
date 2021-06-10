import psycopg2


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

        cur = conn.cursor()
        cur.execute(query, args)
        conn.commit()
        rows = cur.fetchall()
        conn.close()

        return rows

    def get_all_step_children_by_process_id(self, starting_process_dwid: int) -> list:
        results = self.execute_query(f'''WITH RECURSIVE step_lineage AS
    (
        select
            state_machine_step.process_dwid
            , state_machine_step.next_process_dwid
            , state_machine_step.process_dwid as starting_process_dwid
        FROM
            mdi.state_machine_step
        WHERE
            state_machine_step.process_dwid = %s
        UNION ALL

        SELECT
            state_machine_step.process_dwid
            , state_machine_step.next_process_dwid
            , step_lineage.starting_process_dwid
        FROM
            mdi.state_machine_step
                INNER JOIN step_lineage ON state_machine_step.process_dwid = step_lineage.next_process_dwid
        )
        SELECT
            step_lineage.process_dwid,
            process.name as process_name,
            step_lineage.starting_process_dwid
        FROM
            step_lineage
        JOIN mdi.process ON step_lineage.process_dwid = process.dwid
        ;''', starting_process_dwid)
        return results

    # returns a list of 3-tuples with process_dwid, name, and comment
    def get_all_state_machine_definitions(self) -> list:
        rows = self.execute_query('''
        SELECT
            state_machine_definition.process_dwid,
            state_machine_definition.name as process_name,
            state_machine_definition.comment as comment
        FROM
            mdi.state_machine_definition;
        ''')
        return rows

    def get_state_machine_step_by_process_dwid(self, process_dwid: int) -> list:
        rows = self.execute_query('''
        SELECT
            state_machine_step.process_dwid,
            state_machine_step.next_process_dwid
        FROM
            mdi.state_machine_step
        WHERE
            process_dwid = %s;
        ''', process_dwid)
        return rows

    def has_only_valid_state_machine_configs(self) -> bool:
        rows = self.get_all_state_machine_configs_with_one_parent_multiple_children()
        if len(rows) > 0:
            print(f"Error: there is a state_machine_step configuration where one process_dwid has multiple children.")
            print("List of process_dwids configured multiple times:")
            for row in rows:
                print(f"{row[0]}")
            return False

        state_machine_definition_rows = self.get_all_state_machine_definitions()
        for state_machine_definition_row in state_machine_definition_rows:
            process_dwid = state_machine_definition_row[0]

            state_machine_step_rows = self.get_state_machine_step_by_process_dwid(process_dwid)
            if len(state_machine_step_rows) == 0:
                print(f"ERROR: No steps were found in mdi.state_machine_step for process_dwid = {process_dwid}")
                return False

            step_process_dwids_found = []

            while state_machine_step_rows[0][1] is not None:
                step_process_dwid = state_machine_step_rows[0][0]
                step_next_process_dwid = state_machine_step_rows[0][1]

                if step_process_dwid not in step_process_dwids_found:
                    step_process_dwids_found.append(step_process_dwid)
                else:
                    print(f"ERROR: The process_dwid = {step_process_dwid} has been detected multiple times in mdi.step_machine_definition.process_dwid = {process_dwid}")
                    return False

                state_machine_step_rows = self.get_state_machine_step_by_process_dwid(step_next_process_dwid)
                if len(state_machine_step_rows) == 0:
                    print(f"ERROR: No steps were found in mdi.state_machine_step for process_dwid = {process_dwid}")
                    return False

        return True # if no errors have occurred default to reporting back all configs checked are valid

    def get_all_state_machine_configs_with_one_parent_multiple_children(self) -> list:
        rows = self.execute_query('''
                                    SELECT
                                        process_dwid
                                    FROM
                                        mdi.state_machine_step
                                    GROUP BY
                                        process_dwid
                                    HAVING count(process_dwid) > 1;''')
        return rows
