"""
EDW metadata unit tests: a script to check the contents of each config.mdi schema table against a specific set
of validation rules
https://app.asana.com/0/0/1200343485858665
"""
import psycopg2
import psycopg2.extras
import pandas
from typing import List


def query_tester(query: str, failure_message: str):
    with EDW() as cursor:
        if (cursor.select_into_dataframe(query).shape[0]) > 0:
            print(failure_message)


def edw_table_definition_test_1():
    query_tester("""
        SELECT edw_table_definition.dwid
            , edw_table_definition.database_name
            , edw_table_definition.schema_name
            , edw_table_definition.table_name
            , edw_table_definition.primary_source_edw_table_definition_dwid
        FROM mdi.edw_table_definition
        WHERE edw_table_definition.database_name = 'staging'
          AND edw_table_definition.schema_name = 'staging_octane'
          AND edw_table_definition.primary_source_edw_table_definition_dwid IS NOT NULL
    """, "edw_table_definition test 1: Non-null values in primary_source_edw_table_definition_dwid field " \
         "for staging_octane tables.")


def edw_table_definition_test_2():
    query_tester("""
        SELECT history_tables.dwid
            , history_tables.database_name
            , history_tables.schema_name
            , history_tables.table_name
            , history_tables.primary_source_edw_table_definition_dwid
            , history_source_tables.database_name AS source_database_name
            , history_source_tables.schema_name AS source_schema_name
            , history_source_tables.table_name AS source_table_name
        FROM mdi.edw_table_definition history_tables
                 JOIN mdi.edw_table_definition history_source_tables
                      ON history_tables.primary_source_edw_table_definition_dwid = history_source_tables.dwid
                          AND history_source_tables.schema_name <> 'staging_octane'
        WHERE history_tables.database_name = 'staging'
          AND history_tables.schema_name = 'history_octane'
    """, "edw_table_definition test 2: history_octane record(s) mapped to an unexpected source schema.")


def edw_field_definition_test_1():
    query_tester("""
        SELECT edw_field_definition.dwid 
            , edw_field_definition.field_name
            , edw_field_definition.field_source_calculation
        FROM mdi.edw_field_definition
        WHERE edw_field_definition.field_source_calculation IS NOT NULL
          AND edw_field_definition.field_source_calculation ~ 'AS .*$'
    """, "edw_field_definition test 1: Alias detected in field_source_calculation.")


def edw_field_definition_test_2():
    query_tester("""
        SELECT edw_field_definition.dwid 
            , edw_field_definition.field_name
            , edw_field_definition.field_source_calculation
        FROM mdi.edw_field_definition
        WHERE edw_field_definition.field_source_calculation IS NOT NULL
            AND edw_field_definition.field_source_calculation NOT LIKE '%primary_table%'
            AND edw_field_definition.field_source_calculation !~ 't[0-9]'
    """, "edw_field_definition test 2: field_source_calculation detected without appropriate table " \
         "qualifiers.")


def edw_field_definition_test_3():
    query_tester("""
        WITH edw_field_population_a AS (
            SELECT edw_table_definition.database_name
                , edw_table_definition.schema_name
                , edw_table_definition.table_name
                , edw_field_definition.field_name
                , edw_field_definition.dwid AS edw_field_definition_dwid
                , edw_field_definition.source_edw_field_definition_dwid
                , edw_field_definition.field_source_calculation
            FROM mdi.edw_table_definition
                JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
            WHERE (edw_table_definition.database_name = 'ingress'
                OR (edw_table_definition.database_name = 'staging'
                    AND (edw_table_definition.schema_name LIKE 'staging_%'
                        OR (edw_table_definition.schema_name = 'history_octane'
                            AND edw_field_definition.field_name IN ('data_source_updated_datetime', 'data_source_deleted_flag')
                            )
                        )
                    )
                )
        )
        
        , edw_field_population_b AS (
            SELECT edw_table_definition.database_name
                , edw_table_definition.schema_name
                , edw_table_definition.table_name
                , edw_field_definition.field_name
                , edw_field_definition.dwid AS edw_field_definition_dwid
                , edw_field_definition.source_edw_field_definition_dwid
                , edw_field_definition.field_source_calculation
            FROM mdi.edw_table_definition
                JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
                LEFT JOIN edw_field_population_a ON edw_field_definition.dwid = edw_field_population_a.edw_field_definition_dwid
            WHERE edw_field_population_a.edw_field_definition_dwid IS NULL
        )
        
        SELECT edw_field_population_a.database_name
            , edw_field_population_a.schema_name
            , edw_field_population_a.table_name
            , edw_field_population_a.field_name
            , edw_field_population_a.edw_field_definition_dwid
            , edw_field_population_a.source_edw_field_definition_dwid
            , edw_field_population_a.field_source_calculation
        FROM edw_field_population_a
        WHERE source_edw_field_definition_dwid IS NOT NULL
            AND field_source_calculation IS NOT NULL
        UNION ALL
        SELECT edw_field_population_b.database_name
             , edw_field_population_b.schema_name
             , edw_field_population_b.table_name
             , edw_field_population_b.field_name
             , edw_field_population_b.edw_field_definition_dwid
             , edw_field_population_b.source_edw_field_definition_dwid
             , edw_field_population_b.field_source_calculation
        FROM edw_field_population_b
        WHERE NOT (source_edw_field_definition_dwid IS NULL
            OR field_source_calculation IS NULL)
    """, "edw_field_definition test 3: Records with unexpected non-null values in "
         "source_edw_field_definition_dwid and/or field_source_calculation.")


def edw_join_definition_test_1():
    query_tester("""
        SELECT edw_join_definition.dwid
            , edw_join_definition.join_condition
        FROM mdi.edw_join_definition
        WHERE (SPLIT_PART(join_condition, '.', 1) <> 'primary_table'
            OR SPLIT_PART(SPLIT_PART(join_condition, '.', 2), ' = ', 2) !~ 't[0-9]')
    """, "edw_join_definition test 1: join_condition references fields from an unexpected table.")


def edw_join_tree_definition_test_1():
    query_tester("""
        SELECT edw_join_tree_definition.dwid
             , edw_join_tree_definition.child_join_tree_dwid
             , child_join_tree_definition.dwid
             , child_join_tree_definition.child_join_tree_dwid
        FROM mdi.edw_join_tree_definition
                 JOIN mdi.edw_join_tree_definition child_join_tree_definition ON edw_join_tree_definition.child_join_tree_dwid =
                                                                                 child_join_tree_definition.dwid
        WHERE edw_join_tree_definition.dwid = child_join_tree_definition.child_join_tree_dwid
    """, "edw_join_tree_definition test 1: Recursive loop detected.")


def process_test_1():
    query_tester("""
        SELECT process.name
            , COUNT(*)
        FROM mdi.process
        GROUP BY process.name
        HAVING COUNT(*) > 1
    """, "process test 1: Non-unique value(s) in name field.")


def process_test_2():
    query_tester("""
        SELECT process.dwid
        FROM mdi.process
            LEFT JOIN mdi.table_input_step ON process.dwid = table_input_step.process_dwid
            LEFT JOIN mdi.microsoft_excel_input_step ON process.dwid = microsoft_excel_input_step.process_dwid
            LEFT JOIN mdi.csv_file_input_step ON process.dwid = csv_file_input_step.process_dwid
        WHERE table_input_step.dwid IS NULL
            AND microsoft_excel_input_step.dwid IS NULL
            AND csv_file_input_step.dwid IS NULL
    """, "process test 2: Record(s) missing required MDI input relation.")


def process_test_3():
    query_tester("""
        SELECT process.dwid
        FROM mdi.process
            LEFT JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
            LEFT JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
            LEFT JOIN mdi.delete_step ON process.dwid = delete_step.process_dwid
        WHERE table_output_step.dwid IS NULL
            AND insert_update_step.dwid IS NULL
            AND delete_step.dwid IS NULL
    """, "process test 3: Record(s) missing required MDI output relation.")


def csv_file_input_step_test_1():
    query_tester("""
        SELECT csv_file_input_step.dwid
        FROM mdi.csv_file_input_step
            LEFT JOIN mdi.csv_file_input_field ON csv_file_input_step.dwid = 
                csv_file_input_field.csv_file_input_step_dwid
        WHERE csv_file_input_field.dwid IS NULL        
    """, "csv_file_input_step test 1: Record(s) missing required csv_file_input_field relation.")


def csv_file_input_field_test_1():
    query_tester("""
        SELECT csv_file_input_field.csv_file_input_step_dwid
            , csv_file_input_field.field_name
            , COUNT(*)
        FROM mdi.csv_file_input_field
        GROUP BY csv_file_input_field.csv_file_input_step_dwid
            , csv_file_input_field.field_name
        HAVING COUNT(*) > 1
    """, "csv_file_input_field test 1: Duplicate field names mapped to a single csv_file_input_step record.")


def microsoft_excel_input_step_test_1():
    query_tester("""
        SELECT microsoft_excel_input_step.dwid
        FROM mdi.microsoft_excel_input_step
            LEFT JOIN mdi.microsoft_excel_input_field ON microsoft_excel_input_step.dwid = 
                microsoft_excel_input_field.microsoft_excel_input_step_dwid
        WHERE microsoft_excel_input_field.dwid IS NULL
    """, "microsoft_excel_input_step test 1: Record(s) missing required microsoft_excel_input_field relation.")


def microsoft_excel_input_field_test_1():
    query_tester("""
        SELECT microsoft_excel_input_field.microsoft_excel_input_step_dwid
             , microsoft_excel_input_field.field_name
             , COUNT(*)
        FROM mdi.microsoft_excel_input_field
        GROUP BY microsoft_excel_input_field.microsoft_excel_input_step_dwid
               , microsoft_excel_input_field.field_name
        HAVING COUNT(*) > 1
    """, "microsoft_excel_input_field test 1: Duplicate field names mapped to a single " \
         "microsoft_excel_input_step record.")


def table_input_step_test_1():
    query_tester("""
        SELECT table_input_step.dwid
            , table_input_step.limit_size
            , table_input_step.execute_for_each_row
            , table_input_step.enable_lazy_conversion
            , table_input_step.cached_row_meta
        FROM mdi.table_input_step
        WHERE NOT (table_input_step.limit_size = 0
            AND execute_for_each_row = 'N'
            AND enable_lazy_conversion = 'N'
            AND cached_row_meta = 'N')
    """, "table_input_step test 1: Non-standard values in standard-value fields.")


def table_input_step_test_2():
    query_tester("""
        SELECT table_input_step.sql
            , COUNT(*)
        FROM mdi.table_input_step
        GROUP BY sql
        HAVING COUNT(*) > 1
    """, "table_input_step test 2: Duplicate values detected in sql field.")


def table_output_step_test_1():
    query_tester("""
        SELECT table_output_step.dwid
            , table_output_step.connectionname
            , table_output_step.target_schema
            , table_output_step.target_table
        FROM mdi.table_output_step
            LEFT JOIN mdi.edw_table_definition ON table_output_step.target_schema = edw_table_definition.schema_name
                AND table_output_step.target_table = edw_table_definition.table_name
        WHERE table_output_step.connectionname <> 'Ingress DB Connection'
            AND table_output_step.target_schema <> 'staging_compliance'
            AND edw_table_definition.dwid IS NULL
    """, "table_output_step test 1: Record(s) with a target_table field value that does not exist in " \
         "edw_table_definition.")


def table_output_step_test_2():
    query_tester("""
        SELECT table_output_step.dwid
            , table_output_step.connectionname
            , table_output_step.target_schema
            , table_output_step.target_table
        FROM mdi.table_output_step
            LEFT JOIN mdi.table_output_field ON table_output_step.dwid = table_output_field.table_output_step_dwid
        WHERE table_output_field.dwid IS NULL
    """, "table_output_step test 2: Record(s) missing required table_output_field relation.")


def table_output_step_test_3():
    query_tester("""
        SELECT table_output_step.dwid
            , table_output_step.connectionname
            , table_output_step.target_schema
            , table_output_step.target_table
            , table_output_step.partitioning_field
            , table_output_step.table_name_field
            , table_output_step.auto_generated_key_field
            , table_output_step.partition_data_per
            , table_output_step.table_name_defined_in_field
            , table_output_step.return_auto_generated_key_field
            , table_output_step.partition_over_tables
            , table_output_step.specify_database_fields
            , table_output_step.ignore_insert_errors
            , table_output_step.use_batch_update
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
    """, "table_output_step test 3: Non-standard values in standard-value fields.")


def table_output_field_test_1():
    query_tester("""
        SELECT edw_table_definition.schema_name
            , edw_table_definition.table_name
            , table_output_step.target_table
            , table_output_field.database_field_name
            , edw_field_definition.field_name
        FROM mdi.table_output_field
            JOIN mdi.table_output_step ON table_output_field.table_output_step_dwid = table_output_step.dwid
                AND table_output_step.connectionname <> 'Ingress DB Connection'
                AND table_output_step.target_schema <> 'staging_compliance'
            LEFT JOIN mdi.edw_table_definition ON table_output_step.target_schema = edw_table_definition.schema_name
                AND table_output_step.target_table = edw_table_definition.table_name
            LEFT JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
                AND table_output_field.database_field_name = edw_field_definition.field_name
        WHERE NOT (edw_field_definition.dwid IS NOT NULL
            AND edw_table_definition.dwid IS NOT NULL)
    """, "table_output_field test 1: Record(s) missing required relation in edw_field_definition and/or " \
         "edw_table_definition.")


def table_output_field_test_2():
    query_tester("""
        SELECT table_output_field.table_output_step_dwid
             , 'database_field_name' AS table_output_field_field_type
             , table_output_field.database_field_name AS field_name
             , COUNT(*)
        FROM mdi.table_output_field
        GROUP BY table_output_field.table_output_step_dwid
               , table_output_field.database_field_name
        HAVING COUNT(*) > 1
        UNION ALL
        SELECT table_output_field.table_output_step_dwid
             , 'database_stream_name' AS table_output_field_field_type
             , table_output_field.database_stream_name
             , COUNT(*)
        FROM mdi.table_output_field
        GROUP BY table_output_field.table_output_step_dwid
               , table_output_field.database_stream_name
        HAVING COUNT(*) > 1
        ORDER BY field_name      
    """, "table_output_field test 2: Duplicate field names mapped to a single table_output_step record.")


def table_output_field_test_3():
    query_tester("""
        SELECT table_output_field.table_output_step_dwid
            , table_output_field.field_order
            , COUNT(*)
        FROM mdi.table_output_field
        GROUP BY table_output_field.table_output_step_dwid
            , table_output_field.field_order
        HAVING COUNT(*) > 1
    """, "table_output_field test 3: Duplicate field order values mapped to a single table_output_step " \
         "record.")


def insert_update_step_test_1():
    query_tester("""
        SELECT insert_update_step.dwid
            , insert_update_step.schema_name
            , insert_update_step.table_name
        FROM mdi.insert_update_step
            LEFT JOIN mdi.edw_table_definition ON insert_update_step.schema_name = edw_table_definition.schema_name
                AND insert_update_step.table_name = edw_table_definition.table_name
        WHERE insert_update_step.connectionname <> 'Ingress DB Connection'
            AND insert_update_step.schema_name <> 'staging_compliance' 
            AND edw_table_definition.dwid IS NULL
    """, "insert_update_step test 1: Record(s) with a table_name field value that does not exist in the " \
         "mdi.edw_table_definition table.")


def insert_update_step_test_2():
    query_tester("""
        SELECT insert_update_step.dwid
        FROM mdi.insert_update_step
            LEFT JOIN mdi.insert_update_key ON insert_update_step.dwid = insert_update_key.insert_update_step_dwid
        WHERE insert_update_key.dwid IS NULL
    """, "insert update_step test 2: Record(s) missing required insert_update_key relation.")


def insert_update_step_test_3():
    query_tester("""
        SELECT insert_update_step.dwid
        FROM mdi.insert_update_step
            LEFT JOIN mdi.insert_update_field ON insert_update_step.dwid = insert_update_field.insert_update_step_dwid
        WHERE insert_update_field.dwid IS NULL
    """, "insert update_step test 3: Record(s) missing required insert_update_field relation.")


def insert_update_step_test_4():
    query_tester("""
        SELECT insert_update_step.dwid
            , insert_update_step.do_not
        FROM mdi.insert_update_step
        WHERE insert_update_step.do_not <> 'N'
    """, "insert_update_step test 4: Record(s) with invalid value in do_not field.")


def insert_update_key_test_1():
    query_tester("""
        SELECT insert_update_key.dwid
            , insert_update_key.key_stream1
            , insert_update_key.key_stream2
            , insert_update_key.key_condition
        FROM mdi.insert_update_key
        WHERE insert_update_key.key_condition <> 'BETWEEN'
            AND insert_update_key.key_stream2 IS NOT NULL
    """, "insert_update_key test 1: Record(s) with conflicting key_condition and key_stream2 values.")


def insert_update_field_test_1():
    query_tester("""
        SELECT insert_update_step.table_name AS insert_update_step_target_table_name
            , insert_update_field.update_lookup AS insert_update_target_field_name
            , edw_table_definition.schema_name AS edw_table_definition_schema_name
            , edw_table_definition.table_name AS edw_table_definition_table_name
            , edw_field_definition.field_name AS edw_table_definition_field_name
        FROM mdi.insert_update_field
            JOIN mdi.insert_update_step ON insert_update_field.insert_update_step_dwid = insert_update_step.dwid
                AND insert_update_step.connectionname <> 'Ingress DB Connection'
                AND insert_update_step.schema_name <> 'staging_compliance' 
            LEFT JOIN mdi.edw_table_definition ON insert_update_step.schema_name = edw_table_definition.schema_name
                AND insert_update_step.table_name = edw_table_definition.table_name
            LEFT JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
                AND insert_update_field.update_lookup = edw_field_definition.field_name
        WHERE NOT (edw_field_definition.dwid IS NOT NULL
            AND edw_table_definition.dwid IS NOT NULL)
    """, "insert_update_field test 1: Record(s) missing required relation in edw_field_definition and/or " \
         "edw_table_definition.")


def insert_update_field_test_2():
    query_tester("""
        SELECT insert_update_field.insert_update_step_dwid
            , insert_update_field.update_lookup
            , COUNT(*)
        FROM mdi.insert_update_field
        GROUP BY insert_update_field.insert_update_step_dwid
            , insert_update_field.update_lookup
        HAVING COUNT(*) > 1
    """, "insert_update_field test 2: Duplicate field names mapped to a single insert_update_step record.")


def delete_step_test_1():
    query_tester("""
        SELECT delete_step.dwid
        FROM mdi.delete_step
            LEFT JOIN mdi.delete_key ON delete_step.dwid = delete_key.delete_step_dwid
        WHERE delete_key.dwid IS NULL
    """, "delete_step test 1: Record(s) missing required delete_key relation.")


def delete_key_test_1():
    query_tester("""
        SELECT delete_key.dwid
            , delete_key.stream_fieldname_1
            , delete_key.stream_fieldname_2
            , delete_key.comparator
        FROM mdi.delete_key
        WHERE comparator = 'BETWEEN'
            AND stream_fieldname_2 = ''
    """, "delete_key test 1: Record(s) with conflicting comparator and stream_fieldname_2 values.")


def json_output_field_test_1():
    query_tester("""
        SELECT json_output_field.process_dwid
            , COUNT(*)
        FROM mdi.json_output_field
        GROUP BY json_output_field.process_dwid
        HAVING COUNT(*) > 1
    """, "json_output_field test 1: Duplicate values detected in process_dwid field.")


def json_output_field_test_2():
    query_tester("""
        SELECT json_output_field.dwid
            , json_output_field.field_name
        FROM mdi.json_output_field
        WHERE NOT (json_output_field.field_name LIKE '%_pid'
            OR json_output_field.field_name LIKE '%_dwid'
            OR json_output_field.field_name IN ('dwid', 'data_source_integration_id', 'code'))
    """, "json_output_field test 2: Unexpected field name.")


def state_machine_definition_test_1():
    query_tester("""
        SELECT state_machine_definition.process_dwid
            , state_machine_step.next_process_dwid
            , subseq_state_machine_step.next_process_dwid
        FROM mdi.state_machine_definition
            JOIN mdi.state_machine_step
                ON state_machine_definition.process_dwid = state_machine_step.process_dwid
            JOIN mdi.state_machine_step subseq_state_machine_step
                ON state_machine_step.next_process_dwid = subseq_state_machine_step.process_dwid
        WHERE state_machine_definition.process_dwid = subseq_state_machine_step.next_process_dwid
    """, "state_machine_definition test 1: Loop detected in recursive join through state_machine_step.")


def state_machine_definition_test_2():
    query_tester("""
        SELECT state_machine_definition.dwid
            , state_machine_definition.name
        FROM mdi.state_machine_definition
        WHERE name !~ '^[a-zA-Z0-9_-]*$'
    """, "state_machine_definition test 2: Invalid value(s) detected in name field.")


class EDW:
    """
    A connection to EDW. When used as a context manager, returns an EDWCursor
    instance.
    """

    def __init__(self, host: str = 'localhost', dbname: str = 'config', user: str = 'postgres',
                 password: str = 'testonly'):
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
