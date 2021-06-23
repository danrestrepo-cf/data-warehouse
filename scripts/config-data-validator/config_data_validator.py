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
    print("Proceeding with process table validations...")
    process_check()
    print("Proceeding with CSV table validations...")
    csv_file_input_step_check()
    csv_file_input_field_check()
    print("Proceeding with Microsoft Excel table validations...")
    microsoft_excel_input_step_check()
    print("Proceeding with Table input table validations")
    table_input_step_check()
    output_message()

def output_message():
    if not failure_list:
        print("Config data validator completed successfully.")
    else:
        failure_list.insert(0, "One or more validations failed:")
        print("\n".join(failure_list))

def process_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
        SELECT process.name
            , COUNT(*)
        FROM mdi.process
        GROUP BY process.name
        HAVING COUNT(*) > 1
        """).shape[0]) > 0:
            failure_list.append('process: Non-unique value(s) in name field.')

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
            failure_list.append('process: record(s) without any MDI input relations.')

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
            failure_list.append('process: record(s) without any MDI output relations.')

def csv_file_input_step_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
        SELECT csv_file_input_step.dwid
        FROM mdi.csv_file_input_step
            LEFT JOIN mdi.csv_file_input_field ON csv_file_input_step.dwid = 
                csv_file_input_field.csv_file_input_step_dwid
        WHERE csv_file_input_field.dwid IS NULL        
        """).shape[0]) > 0:
            failure_list.append('csv_file_input_step: record(s) without any CSV file input field relations.')

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
            failure_list.append('csv_file_input_field: Duplicate field names mapped to a single CSV file input step.')

def microsoft_excel_input_step_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
        SELECT microsoft_excel_input_step.dwid
        FROM mdi.microsoft_excel_input_step
            LEFT JOIN mdi.microsoft_excel_input_field ON microsoft_excel_input_step.dwid = 
                microsoft_excel_input_field.microsoft_excel_input_step_dwid
        WHERE microsoft_excel_input_field.dwid IS NULL
        """).shape[0]) > 0:
            failure_list.append('microsoft_excel_file_input_step: record(s) without any Microsoft Excel file '
                                'input field relations.')

def microsoft_excel_input_field_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
        SELECT microsoft_excel_file_input_field.dwid
            , microsoft_excel_file_input_field.field_name
            , COUNT(*)
        FROM mdi.microsoft_excel_file_input_field
        GROUP BY microsoft_excel_file_input_field.dwid
            , microsoft_excel_file_input_field.field_name
        HAVING COUNT(*) > 1
        """).shape[0]) > 0:
            failure_list.append(('microsoft_excel_input_field: Duplicate field names mapped to a single Microsoft '
                                 'Excel file input step.'))

def table_input_step_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
        SELECT table_input_step.dwid
        FROM mdi.table_input_step
        WHERE NOT (table_input_step.limit_size = 0
            AND execute_for_each_row = 'N'
            AND enable_lazy_conversion = 'N'
            AND cached_row_meta = 'N'
        )
        """).shape[0]) == 0:
            failure_list.append("Illegal values detected in table_input_step field(s).")

        if (cursor.select_into_dataframe("""
        
        """))


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