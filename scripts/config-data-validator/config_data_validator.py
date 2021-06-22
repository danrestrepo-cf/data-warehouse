"""
Config data validator: a script to check the contents of each config.mdi schema table against a specific set
of validation rules
https://app.asana.com/0/0/1200343485858665
"""

import psycopg2
import psycopg2.extras
from psycopg2 import sql
import pandas
from typing import List

failure_list = []

def main():
    process_check()
    print(failure_list)

def process_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
        SELECT process.name
            , COUNT(*)
        FROM mdi.process
        GROUP BY process.name
        HAVING COUNT(*) > 1
        """).shape[0]) > 0:
            failure_list.append('Non-unique value(s) found in process.name field.')

        if (cursor.select_into_dataframe("""
        SELECT process.dwid
        FROM mdi.process
            LEFT JOIN mdi.table_input_step ON process.dwid = table_input_step.process_dwid
            LEFT JOIN mdi.microsoft_excel_input_step ON process.dwid = microsoft_excel_input_step.process_dwid
            LEFT JOIN mdi.csv_file_input_step ON process.dwid = csv_file_input_step.process_dwid
        WHERE table_input_step.dwid IS NULL
            AND microsoft_excel_input_step.dwid IS NULL
            AND csv_file_input_step.dwid IS NULL
        """).shape[0]) > 0:
            failure_list.append('Process record(s) found without any MDI input relations.')

        if (cursor.select_into_dataframe("""
        SELECT process.dwid
        FROM mdi.process
            LEFT JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
            LEFT JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
            LEFT JOIN mdi.delete_step ON process.dwid = delete_step.process_dwid
        WHERE table_output_step.dwid IS NULL
            AND insert_update_step.dwid IS NULL
            AND delete_step.dwid IS NULL
        """).shape[0]) > 0:
            failure_list.append('Process record(s) found without any MDI output relations.')

def csv_file_input_step_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
        SELECT csv_file_input_step.dwid
        FROM mdi.csv_file_input_step
            LEFT JOIN mdi.csv_file_input_field ON csv_file_input_step.dwid = 
                csv_file_input_field.csv_file_input_step_dwid
        WHERE csv_file_input_field.dwid IS NULL        
        """).shape[0]) > 0:
            failure_list.append('CSV file input step record(s) found without any CSV file input field relations.')

def csv_file_input_field_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
        SELECT csv_file_input_field.dwid
            , csv_file_input_field.field_name
            , COUNT(*)
        FROM mdi.csv_file_input_field
        GROUP BY csv_file_input_field.dwid
            , csv_file_input_field.field_name
        HAVING COUNT(*) > 1
        """).shape[0]) > 0:
            failure_list.append('CSV file input field ')




# def read_config_table_names_into_list():
#     with EDW() as cursor:
#         config_table_names = cursor.select_column_as_list('table_name', """
#         SELECT table_name
#         FROM information_schema.tables
#         WHERE table_schema = 'mdi'
#         """)
#     return config_table_names
#
# def read_table_data_into_dataframes(config_table_names):
#     with EDW() as cursor:
#         df_dict = {}
#         placeholder_sql = "SELECT * FROM mdi.{};"
#         # table_name = "process"
#         for table_name in config_table_names:
#             df_dict[table_name] = cursor.execute_paramterized_query(placeholder_sql,table_name)
#             # cursor.execute_paramterized_query(placeholder_sql, table_name)
#         process_df = df_dict["process"]
#         print(process_df["dwid"].is_unique)

class EDW:
    """
    A connection to EDW. When used as a context manager, returns an EDWCursor
    instance.
    """

    def __init__(self, host: str = 'localhost', dbname: str = 'config', user: str = 'postgres', password: str = 'testonly'):
        self.host = host
        self.dbname = dbname
        self.user = user
        self.password = password

    def __enter__(self):
        self.conn = psycopg2.connect(host=self.host, database=self.dbname, user=self.user, password=self.password)
        return EDWCursor(self.conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor))

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.conn.commit()
        self.conn.close()


class EDWCursor:
    """
    A simple wrapper around psycopg2's cursor with method(s) added to facilitate
    more expressive code
    """

    def __init__(self, cursor):
        self.cursor = cursor

    # def execute_paramterized_query (self, input_sql: str, table_parameter: str):
    #     query = sql.SQL(input_sql).format(sql.Identifier(table_parameter))
    #     self.cursor.execute(query)
    #     return pandas.DataFrame(self.cursor.fetchall())

    def select_as_list_of_dicts(self, sql: str) -> List[dict]:
        self.cursor.execute(sql)
        return self.cursor.fetchall()

    def select_into_dataframe(self, sql: str):
        self.cursor.execute(sql)
        return pandas.DataFrame(self.cursor.fetchall())

    # def select_column_as_list(self, column_name: str, sql: str):
    #     self.cursor.execute(sql)
    #     tuples = self.cursor.fetchall()
    #     return pandas.DataFrame(tuples)[column_name].values.tolist()

if __name__ == '__main__':
    main()