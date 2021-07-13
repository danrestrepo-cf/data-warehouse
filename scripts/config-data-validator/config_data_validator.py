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
    print("Proceeding with csv table validations...")
    csv_file_input_step_check()
    csv_file_input_field_check()
    print("Proceeding with Microsoft Excel table validations...")
    microsoft_excel_input_step_check()
    print("Proceeding with table input table validations...")
    table_input_step_check()
    print("Proceeding with table output table validations...")
    table_output_step_check()
    table_output_field_check()
    print("Proceeding with insert update table validations...")
    insert_update_step_check()
    insert_update_key_check()
    insert_update_field_check()
    print("Proceeding with delete table validations...")
    delete_step_check()
    delete_key_check()
    output_message()

def output_message():
    if not failure_list:
        print("Config data validator completed successfully.")
    else:
        failure_list.insert(0, "One or more validations FAILED:")
        print("\n".join(failure_list))

def edw_table_definition_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
            SELECT *
            FROM mdi.edw_table_definition
            WHERE edw_table_definition.database_name = 'staging'
                AND edw_table_definition.schema_name = 'staging_octane'
                AND edw_table_definition.primary_source_edw_table_definition_dwid IS NOT NULL
        """).shape[0]) > 0:
            failure_list.append("edw_table_definition: Non-null values in primary_source_edw_table_definition_dwid "
                                "field for staging_octane tables.")

        if (cursor.select_into_dataframe("""
            SELECT history_tables.dwid
            FROM mdi.edw_table_definition history_tables
                JOIN mdi.edw_table_definition history_source_tables
                    ON history_tables.primary_source_edw_table_definition_dwid = history_source_tables.dwid
                    AND history_source_tables.schema_name <> 'staging_octane'
            WHERE history_tables.database_name = 'staging'
                AND history_tables.schema_name = 'history_octane'
        """).shape[0]) > 0:
            failure_list.append("edw_table_definition: history_octane record(s) mapped to an unexpected source schema.")

def edw_field_definition_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
            SELECT *
            FROM mdi.edw_field_definition
            WHERE edw_field_definition.field_source_calculation IS NOT NULL
                AND edw_field_definition.field_source_calculation ~ 'AS .*$'
        """).shape[0]) > 0:
            failure_list.append("edw_field_definition: Alias detected in field_source_calculation.")

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
            failure_list.append('process: Record(s) missing required MDI input relation.')

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
            failure_list.append('process: Record(s) missing required MDI output relation.')

def csv_file_input_step_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
            SELECT csv_file_input_step.dwid
            FROM mdi.csv_file_input_step
                LEFT JOIN mdi.csv_file_input_field ON csv_file_input_step.dwid = 
                    csv_file_input_field.csv_file_input_step_dwid
            WHERE csv_file_input_field.dwid IS NULL        
        """).shape[0]) > 0:
            failure_list.append('csv_file_input_step: Record(s) missing required csv_file_input_field relation.')

def csv_file_input_field_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
            SELECT csv_file_input_field.csv_file_input_step_dwid
                , csv_file_input_field.field_name
                , COUNT(*)
            FROM mdi.csv_file_input_field
            GROUP BY csv_file_input_field.csv_file_input_step_dwid
                , csv_file_input_field.field_name
            HAVING COUNT(*) > 1
        """).shape[0]) > 0:
            failure_list.append('csv_file_input_field: Duplicate field names mapped to a single csv_file_input_step '
                                'record.')

def microsoft_excel_input_step_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
            SELECT microsoft_excel_input_step.dwid
            FROM mdi.microsoft_excel_input_step
                LEFT JOIN mdi.microsoft_excel_input_field ON microsoft_excel_input_step.dwid = 
                    microsoft_excel_input_field.microsoft_excel_input_step_dwid
            WHERE microsoft_excel_input_field.dwid IS NULL
        """).shape[0]) > 0:
            failure_list.append('microsoft_excel_input_step: Record(s) missing required microsoft_excel_input_field '
                                'relation.')

def microsoft_excel_input_field_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
            SELECT microsoft_excel_input_field.microsoft_excel_input_step_dwid
                 , microsoft_excel_input_field.field_name
                 , COUNT(*)
            FROM mdi.microsoft_excel_input_field
            GROUP BY microsoft_excel_input_field.microsoft_excel_input_step_dwid
                   , microsoft_excel_input_field.field_name
            HAVING COUNT(*) > 1;
        """).shape[0]) > 0:
            failure_list.append(('microsoft_excel_input_field: Duplicate field names mapped to a single '
                                 'microsoft_excel_input_step record.'))

def table_input_step_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
            SELECT table_input_step.dwid
            FROM mdi.table_input_step
            WHERE NOT (table_input_step.limit_size = 0
                AND execute_for_each_row = 'N'
                AND enable_lazy_conversion = 'N'
                AND cached_row_meta = 'N')
        """).shape[0]) > 0:
            failure_list.append("table_input_step: Non-standard values in standard-value fields.")

        if (cursor.select_into_dataframe("""
            SELECT table_input_step.sql
                , COUNT(*)
            FROM mdi.table_input_step
            GROUP BY sql
            HAVING COUNT(*) > 1
        """).shape[0]) > 0:
            failure_list.append("table_input_step: Duplicate values detected in sql field.")

def table_output_step_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
            SELECT table_output_step.dwid
            FROM mdi.table_output_step
                LEFT JOIN mdi.edw_table_definition ON table_output_step.target_schema = edw_table_definition.schema_name
                    AND table_output_step.target_table = edw_table_definition.table_name
            WHERE edw_table_definition.dwid IS NULL
        """).shape[0]) > 0:
            failure_list.append("table_output_step: Record(s) with a target_table field value that does not exist in "
                                "edw_table_definition.")
        if(cursor.select_into_dataframe("""
            SELECT table_output_step.dwid
            FROM mdi.table_output_step
                LEFT JOIN mdi.table_output_field ON table_output_step.dwid = table_output_field.table_output_step_dwid
            WHERE table_output_field.dwid IS NULL
        """).shape[0]) > 0:
            failure_list.append("table_output_step: Record(s) missing required table_output_field relation.")

        if (cursor.select_into_dataframe("""
            SELECT table_output_step.dwid
            FROM mdi.table_output_step
            WHERE NOT (table_output_step.partitioning_field IS NULL
                AND table_output_step.table_name_field IS NULL
                AND table_output_step.auto_generated_key_field IS NULL
                AND table_output_step.partition_data_per IS NULL
                AND table_output_step.table_name_defined_in_field = 'N'
                AND table_output_step.return_auto_generated_key_field IS NULL
                AND table_output_step.partition_over_tables = 'N'
                AND table_output_step.specify_database_fields = 'Y'
                AND table_output_step.ignore_insert_errors = 'N'
                AND table_output_step.use_batch_update = 'N')
        """).shape[0]) > 0:
            failure_list.append("table_output_step: Non-standard values in standard-value fields.")

def table_output_field_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
            SELECT edw_table_definition.schema_name
                , edw_table_definition.table_name
                , table_output_step.target_table
                , edw_field_definition.field_name
                , table_output_field.database_field_name
            FROM mdi.table_output_field
                JOIN mdi.table_output_step ON table_output_field.table_output_step_dwid = table_output_step.dwid
                LEFT JOIN mdi.edw_table_definition ON table_output_step.target_schema = edw_table_definition.schema_name
                    AND table_output_step.target_table = edw_table_definition.table_name
                LEFT JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
                    AND table_output_field.database_field_name = edw_field_definition.field_name
            WHERE NOT (edw_field_definition.dwid IS NOT NULL
                AND edw_table_definition.dwid IS NOT NULL)
        """).shape[0]) > 0:
            failure_list.append("table_output_field: Record(s) missing required relation in edw_field_definition "
                                "and/or edw_table_definition.")

        if (cursor.select_into_dataframe("""
                SELECT table_output_field.table_output_step_dwid
                     , table_output_field.database_field_name
                     , COUNT(*)
                FROM mdi.table_output_field
                GROUP BY table_output_field.table_output_step_dwid
                       , table_output_field.database_field_name
                HAVING COUNT(*) > 1
                UNION ALL
                SELECT table_output_field.table_output_step_dwid
                     , table_output_field.database_stream_name
                     , COUNT(*)
                FROM mdi.table_output_field
                GROUP BY table_output_field.table_output_step_dwid
                       , table_output_field.database_stream_name
                HAVING COUNT(*) > 1      
            """).shape[0]) > 0:
            failure_list.append("table_output_field: Duplicate field names mapped to a single table_output_step "
                                "record.")

        if (cursor.select_into_dataframe("""
            SELECT table_output_field.table_output_step_dwid
                , table_output_field.field_order
                , COUNT(*)
            FROM mdi.table_output_field
            GROUP BY table_output_field.table_output_step_dwid
                , table_output_field.field_order
            HAVING COUNT(*) > 1
        """).shape[0]) > 0:
            failure_list.append("table_output_field: Duplicate field order values mapped to a single "
                                "table_output_step record.")

def insert_update_step_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
            SELECT insert_update_step.dwid
                , insert_update_step.schema_name
                , insert_update_step.table_name
            FROM mdi.insert_update_step
                LEFT JOIN mdi.edw_table_definition ON insert_update_step.schema_name = edw_table_definition.schema_name
                    AND insert_update_step.table_name = edw_table_definition.table_name
            WHERE edw_table_definition.dwid IS NULL
        """).shape[0]) > 0:
            failure_list.append("insert_update_step: Record(s) with a table_name field value that does not exist in "
                                "the mdi.edw_table_definition table.")

        if (cursor.select_into_dataframe("""
            SELECT insert_update_step.dwid
            FROM mdi.insert_update_step
                LEFT JOIN mdi.insert_update_key ON insert_update_step.dwid = insert_update_key.insert_update_step_dwid
            WHERE insert_update_key.dwid IS NULL
        """).shape[0]) > 0:
            failure_list.append("insert update_step: Record(s) missing required insert_update_key relation.")

        if (cursor.select_into_dataframe("""
            SELECT insert_update_step.dwid
            FROM mdi.insert_update_step
                LEFT JOIN mdi.insert_update_field ON insert_update_step.dwid = insert_update_field.insert_update_step_dwid
            WHERE insert_update_field.dwid IS NULL
        """).shape[0]) > 0:
            failure_list.append("insert update_step: Record(s) missing required insert_update_field relation.")

        if (cursor.select_into_dataframe("""
            SELECT insert_update_step.dwid
            FROM mdi.insert_update_step
            WHERE insert_update_step.do_not <> 'N'
        """).shape[0]) > 0:
            failure_list.append("insert_update_step: Record(s) with invalid value in do_not field.")

def insert_update_key_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
            SELECT insert_update_key.dwid
            FROM mdi.insert_update_key
            WHERE insert_update_key.key_condition <> 'BETWEEN'
                AND insert_update_key.key_stream2 IS NOT NULL
        """).shape[0]) > 0:
            failure_list.append("insert_update_key: Record(s) with conflicting key_condition and key_stream2 values.")

def insert_update_field_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
            SELECT edw_table_definition.schema_name
                , edw_table_definition.table_name
                , insert_update_step.table_name
                , edw_field_definition.field_name
                , insert_update_field.update_lookup
            FROM mdi.insert_update_field
                JOIN mdi.insert_update_step ON insert_update_field.insert_update_step_dwid = insert_update_step.dwid
                LEFT JOIN mdi.edw_table_definition ON insert_update_step.schema_name = edw_table_definition.schema_name
                    AND insert_update_step.table_name = edw_table_definition.table_name
                LEFT JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
                    AND insert_update_field.update_lookup = edw_field_definition.field_name
            WHERE NOT (edw_field_definition.dwid IS NOT NULL
                AND edw_table_definition.dwid IS NOT NULL)
        """).shape[0]) > 0:
            failure_list.append("insert_update_field: Record(s) missing required relation in edw_field_definition "
                        "and/or edw_table_definition.")

        if (cursor.select_into_dataframe("""
        SELECT insert_update_field.insert_update_step_dwid
            , insert_update_field.update_lookup
            , COUNT(*)
        FROM mdi.insert_update_field
        GROUP BY insert_update_field.insert_update_step_dwid
            , insert_update_field.update_lookup
        HAVING COUNT(*) > 1
        """).shape[0]) > 0:
            failure_list.append("insert_update_field: Duplicate field names mapped to a single insert_update_step "
                                "record.")

def delete_step_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
            SELECT delete_step.dwid
            FROM mdi.delete_step
                LEFT JOIN mdi.delete_key ON delete_step.dwid = delete_key.delete_step_dwid
            WHERE delete_key.dwid IS NULL
        """).shape[0]) > 0:
            failure_list.append("delete_step: Record(s) missing required delete_key relation.")

def delete_key_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
            SELECT delete_key.dwid
            FROM mdi.delete_key
            WHERE comparator = 'BETWEEN'
                AND stream_fieldname_2 = ''
        """).shape[0]) > 0:
            failure_list.append("delete_key: Record(s) with conflicting comparator and stream_fieldname_2 values.")

def json_output_field_check():
    with EDW() as cursor:
        if (cursor.select_into_dataframe("""
            SELECT json_output_field.process_dwid
                , COUNT(*)
            FROM mdi.json_output_field
            GROUP BY json_output_field.process_dwid
            HAVING COUNT(*) > 1
        """).shape[0]) > 0:
            failure_list.append("json_output_field: Duplicate values detected in process_dwid field.")

        if (cursor.select_into_dataframe("""
            SELECT json_output_field.dwid
            FROM mdi.json_output_field
            WHERE NOT (json_output_field.field_name LIKE '%_pid'
                OR json_output_field.field_name LIKE '%_dwid'
                OR json_output_field.field_name IN ('dwid', 'data_source_integration_id', 'code'))
        """).shape[0]) > 0:
            failure_list.append("json_output_field: ")

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

    def select_as_list_of_dicts(self, sql: str) -> List[dict]:
        self.cursor.execute(sql)
        return self.cursor.fetchall()

    def select_into_dataframe(self, sql: str):
        self.cursor.execute(sql)
        return pandas.DataFrame(self.cursor.fetchall())

if __name__ == '__main__':
    main()
