"""
EDW metadata unit tests: a script to check the contents of each config.mdi schema table against a specific set
of validation rules
https://app.asana.com/0/0/1200343485858665
"""
import psycopg2
import psycopg2.extras
from typing import List


def query_tester(query: str, failure_message: str):
    with EDW() as cursor:
        if len(cursor.select_as_list_of_dicts(query)) > 0:
            print(failure_message)


def test_1():
    """edw_table_definition: If database is staging and schema_name is staging_octane then
    primary_source_edw_table_definition_dwid must be null"""
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
    """, "Test 1: [edw_table_definition] Non-null values in primary_source_edw_table_definition_dwid field for "
         "staging_octane tables.")


def test_2():
    """edw_table_defintion: If database is staging and schema_name is history_octane then
    primary_source_edw_table_definition_dwid must reference a record whose schema is staging_octane"""
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
        """, "Test 2: [edw_table_definition] history_octane record(s) mapped to an invalid source schema.")


def test_3():
    """edw_field_definition: field_source_calculation must not have an alias"""
    query_tester("""
        SELECT edw_field_definition.dwid 
            , edw_field_definition.field_name
            , edw_field_definition.field_source_calculation
        FROM mdi.edw_field_definition
        WHERE edw_field_definition.field_source_calculation IS NOT NULL
          AND edw_field_definition.field_source_calculation ~* 'AS .*$'
    """, "Test 3: [edw_field_definition] Alias detected in field_source_calculation.")


def test_4():
    """edw_field_definition: field_source_calculation must include appropriate table qualifiers,
    e.g. primary_table, t<dwid>"""
    query_tester("""
        SELECT edw_field_definition.dwid 
            , edw_field_definition.field_name
            , edw_field_definition.field_source_calculation
        FROM mdi.edw_field_definition
        WHERE edw_field_definition.field_source_calculation IS NOT NULL
            AND edw_field_definition.field_source_calculation NOT LIKE '%primary_table.%'
            AND edw_field_definition.field_source_calculation !~ 't[0-9]+\.'
    """, "Test 4: [edw_field_definition] field_source_calculation detected without appropriate table qualifiers.")


def test_5():
    """edw_field_definition:
    If any of the following:
        - database is ingress
        - database is staging AND schema is staging_*
        - database is staging AND schema is history_octane AND field is data_source_deleted_flag
        - database is staging AND schema is history_octane AND field is data_source_updated_datetime
            THEN
                Both of the following fields must be NULL
                    - source_edw_field_definition_dwid
                    - field_source_calculation
            ELSE
                At least one of the following fields must be NULL
                    - source_edw_field_definition_dwid
                    - field_source_calculation

    edw_field_population_a must have NULLs in both source_edw_field_definition_dwid and field_source_calculation
    fields
    edw_field_population_b must have NULL in at least one of the two source_edw_field_definition_dwid and
    field_source_calculation fields"""
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
    """, "Test 5: [edw_field_definition] Records with invalid non-null values in "
         "source_edw_field_definition_dwid and/or field_source_calculation.")


def test_6():
    """edw_join_definition: join_condition must only reference fields in primary table and target table"""
    query_tester("""
        WITH prefixes AS (
            SELECT edw_join_definition.dwid
                , (REGEXP_MATCHES(edw_join_definition.join_condition, '([a-zA-Z0-9_]+)\.', 'g' ))[1] AS alias
            FROM mdi.edw_join_definition
        )
        SELECT prefixes.dwid
            , prefixes.alias
            , (prefixes.alias = 't' || prefixes.dwid OR prefixes.alias = 'primary_table') AS legal_prefix
        FROM prefixes
        WHERE (prefixes.alias = 't' || prefixes.dwid OR prefixes.alias = 'primary_table') IS FALSE
    """, "Test 6: [edw_join_definition] Join_condition references fields from an invalid table.")


def test_7():
    """edw_join_tree_definition: dwid : child_join_tree_dwid relationship must never result in recursive loop"""
    query_tester("""
        WITH RECURSIVE search_graph (edw_join_tree_dwid, next_child_dwid, join_sequence, loop_detected) AS (
            SELECT edw_join_tree_definition.dwid
                 , edw_join_tree_definition.child_join_tree_dwid
                 , ARRAY[edw_join_tree_definition.dwid]
                 , edw_join_tree_definition.child_join_tree_dwid = edw_join_tree_definition.dwid
            FROM mdi.edw_join_tree_definition
            UNION ALL
            SELECT search_graph.edw_join_tree_dwid
                 , edw_join_tree_definition.child_join_tree_dwid
                 , search_graph.join_sequence || edw_join_tree_definition.dwid
                 , edw_join_tree_definition.dwid = ANY(search_graph.join_sequence)
            FROM search_graph
                JOIN mdi.edw_join_tree_definition ON search_graph.next_child_dwid = edw_join_tree_definition.dwid
            WHERE search_graph.loop_detected IS FALSE
        )
        SELECT search_graph.join_sequence AS looping_join_dwid_sequence
        FROM search_graph
        WHERE search_graph.loop_detected IS TRUE;
    """, "Test 7: [edw_join_tree_definition] Loop detected in edw root / child join sequence(s).")


def test_8():
    """process: Values in name field must be unique"""
    query_tester("""
        SELECT process.name
            , COUNT(*)
        FROM mdi.process
        GROUP BY process.name
        HAVING COUNT(*) > 1
    """, "Test 8: [process] Non-unique value(s) in name field.")


def test_9():
    """process: All records must always be referenced by exactly one record from one the following tables:
      - table_input_step
      - microsoft_excel_input_step
      - csv_file_input_step"""
    query_tester("""
        WITH process_input AS (
            SELECT process.dwid
                , process.name
                , process.description
                , CASE WHEN table_input_step.dwid IS NULL THEN 0 ELSE 1 END AS has_table_input_dwid
                , CASE WHEN microsoft_excel_input_step.dwid IS NULL THEN 0 ELSE 1 END AS has_excel_input_dwid
                , CASE when csv_file_input_step.dwid IS NULL THEN 0 ELSE 1 END AS has_csv_input_dwid
            FROM mdi.process
                     LEFT JOIN mdi.table_input_step ON process.dwid = table_input_step.process_dwid
                     LEFT JOIN mdi.microsoft_excel_input_step ON process.dwid = microsoft_excel_input_step.process_dwid
                     LEFT JOIN mdi.csv_file_input_step ON process.dwid = csv_file_input_step.process_dwid
        )
            SELECT process_input.dwid
                , process_input.name
                , process_input.description
            FROM process_input
            WHERE process_input.has_table_input_dwid
                + process_input.has_excel_input_dwid
                + process_input.has_csv_input_dwid != 1
    """, "Test 9: [process] Record(s) mapped to zero or more than one MDI input relation.")


def test_10():
    """process: All records must always be referenced by exactly one record from one the following tables:
        - table_output_step
        - insert_update_step
        - delete_step"""
    query_tester("""
        WITH process_output AS (
            SELECT process.dwid
                , process.name
                , process.description
                , CASE WHEN table_output_step.dwid IS NULL THEN 0 ELSE 1 END AS has_table_output_dwid
                , CASE WHEN insert_update_step.dwid IS NULL THEN 0 ELSE 1 END AS has_insert_update_dwid
                , CASE when delete_step.dwid IS NULL THEN 0 ELSE 1 END AS has_delete_dwid
            FROM mdi.process
                     LEFT JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
                     LEFT JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
                     LEFT JOIN mdi.delete_step ON process.dwid = delete_step.process_dwid
        )
            SELECT process_output.dwid
                , process_output.name
                , process_output.description
            FROM process_output
            WHERE process_output.has_table_output_dwid
                + process_output.has_insert_update_dwid
                + process_output.has_delete_dwid != 1
    """, "Test 10: [process] Record(s) mapped to zero or more than one MDI output relation.")


def test_11():
    """csv_file_input_step: All records must be referenced by at least one record from csv_file_input_field"""
    query_tester("""
        SELECT csv_file_input_step.dwid
        FROM mdi.csv_file_input_step
            LEFT JOIN mdi.csv_file_input_field ON csv_file_input_step.dwid = 
                csv_file_input_field.csv_file_input_step_dwid
        WHERE csv_file_input_field.dwid IS NULL        
    """, "Test 11: [csv_file_input_step] Record(s) missing required csv_file_input_field relation.")


def test_12():
    """csv_file_input_field: field_name must be unique among records with the same csv_file_input_step_dwid"""
    query_tester("""
        SELECT csv_file_input_field.csv_file_input_step_dwid
            , csv_file_input_field.field_name
            , COUNT(*)
        FROM mdi.csv_file_input_field
        GROUP BY csv_file_input_field.csv_file_input_step_dwid
            , csv_file_input_field.field_name
        HAVING COUNT(*) > 1
    """, "Test 12: [csv_file_input_field] Duplicate field names mapped to a single csv_file_input_step record.")


def test_13():
    """microsoft_excel_input_step: All records must be referenced by at least one record from
    microsoft_excel_input_field"""
    query_tester("""
        SELECT microsoft_excel_input_step.dwid
        FROM mdi.microsoft_excel_input_step
            LEFT JOIN mdi.microsoft_excel_input_field ON microsoft_excel_input_step.dwid = 
                microsoft_excel_input_field.microsoft_excel_input_step_dwid
        WHERE microsoft_excel_input_field.dwid IS NULL
    """, "Test 13: [microsoft_excel_input_step] Record(s) missing required microsoft_excel_input_field relation.")


def test_14():
    """microsoft_excel_input_field: field_name must be unique among records with the same
    microsoft_excel_input_step_dwid"""
    query_tester("""
        SELECT microsoft_excel_input_field.microsoft_excel_input_step_dwid
             , microsoft_excel_input_field.field_name
             , COUNT(*)
        FROM mdi.microsoft_excel_input_field
        GROUP BY microsoft_excel_input_field.microsoft_excel_input_step_dwid
               , microsoft_excel_input_field.field_name
        HAVING COUNT(*) > 1
    """, "Test 14: [microsoft_excel_input_field] Duplicate field names mapped to a single " 
         "microsoft_excel_input_step record.")


def test_15():
    """table_input_step: The following fields must contain the corresponding values for all records:
        - limit_size = 0
        - execute_for_each_row = ‘N’
        - enable_lazy_conversion = ‘N’
        - cached_row_meta = ‘N’"""
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
    """, "Test 15: [table_input_step] Non-standard values in standard-value fields.")


def test_16():
    """table_input_step: sql must be unique"""
    query_tester("""
        SELECT table_input_step.sql
            , COUNT(*)
        FROM mdi.table_input_step
        GROUP BY sql
        HAVING COUNT(*) > 1
    """, "Test 16: [table_input_step] Duplicate values detected in sql field.")


def test_17():
    """table_output_step: Target_table must exist in edw_table_definition
    UNLESS database is ingress OR schema is staging_compliance"""
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
    """, "Test 17: [table_output_step] Record(s) with a target_table field value that does not exist in "
         "edw_table_definition.")


def test_18():
    """table_output_step: All records must be referenced by at least one record in table_output_field"""
    query_tester("""
        SELECT table_output_step.dwid
            , table_output_step.connectionname
            , table_output_step.target_schema
            , table_output_step.target_table
        FROM mdi.table_output_step
            LEFT JOIN mdi.table_output_field ON table_output_step.dwid = table_output_field.table_output_step_dwid
        WHERE table_output_field.dwid IS NULL
    """, "Test 18: [table_output_step] Record(s) missing required table_output_field relation.")


def test_19():
    """table_output_step: The following fields must contain the corresponding values for all records:
        - partitioning_field IS NULL
        - table_name_field IS NULL
        - auto_generated_key_field IS NULL
        - partition_data_per IS NULL
        - table_name_defined_in_field = ‘N’
        - return_auto_generated_key_field IS NULL
        - partition_over_tables = ‘N’
        - specify_database_fields = ‘Y’
        - ignore_insert_errors = ‘N’
        - use_batch_update = ‘N’"""
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
    """, "Test 19: [table_output_step] Non-standard values in standard-value fields.")


def test_20():
    """table_output_field: field_name must exist in edw_field_definition
    AND edw_field_definition record must reference same table as the table_output_step.target_table
    UNLESS database is ingress OR schema is staging_compliance"""
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
    """, "Test 20: [table_output_field] Record(s) missing required relation in edw_field_definition and/or "
         "edw_table_definition.")


def test_21():
    """table_output_field: the following fields must be unique among records with the same table_output_step_dwid:
        - database_stream_name
        - database_field_name"""
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
    """, "Test 21: [table_output_field] Duplicate field names mapped to a single table_output_step record.")


def test_22():
    """NOTE: TEST 22 IS DEPRECATED. IT IS NO LONGER CALLED BY THE unit-test-runner.sh SHELL SCRIPT; see https://app.asana.com/0/0/1201461907662856
    table_output_field: field_order numbers must be unique within any given table_output_step_dwid"""
    query_tester("""
        SELECT table_output_field.table_output_step_dwid
            , table_output_field.field_order
            , COUNT(*)
        FROM mdi.table_output_field
        GROUP BY table_output_field.table_output_step_dwid
            , table_output_field.field_order
        HAVING COUNT(*) > 1
    """, "Test 22: [table_output_field] Duplicate field order values mapped to a single table_output_step "
         "record.")


def test_23():
    """insert_update_step: table_name must exist in edw_table_definition
    UNLESS database is ingress OR schema is staging_compliance"""
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
    """, "Test 23: [insert_update_step] Record(s) with a table_name field value that does not exist in the "
         "mdi.edw_table_definition table.")


def test_24():
    """insert_update_step: All records must be referenced by at least one record in insert_update_key"""
    query_tester("""
        SELECT insert_update_step.dwid
        FROM mdi.insert_update_step
            LEFT JOIN mdi.insert_update_key ON insert_update_step.dwid = insert_update_key.insert_update_step_dwid
        WHERE insert_update_key.dwid IS NULL
    """, "Test 24: [insert_update_step] Record(s) missing required insert_update_key relation.")


def test_25():
    """insert_update_step: All records must be referenced by at least one record in insert_update_field"""
    query_tester("""
        SELECT insert_update_step.dwid
        FROM mdi.insert_update_step
            LEFT JOIN mdi.insert_update_field ON insert_update_step.dwid = insert_update_field.insert_update_step_dwid
        WHERE insert_update_field.dwid IS NULL
    """, "Test 25: [insert_update_step] Record(s) missing required insert_update_field relation.")


def test_26():
    """insert_update_field: The following fields must contain the corresponding values for all records:
        - do_not = ‘N’"""
    query_tester("""
        SELECT insert_update_step.dwid
            , insert_update_step.do_not
        FROM mdi.insert_update_step
        WHERE insert_update_step.do_not <> 'N'
    """, "Test 26: [insert_update_step] Record(s) with invalid value in do_not field.")


def test_27():
    """insert_update_key: key_stream2 must be non-null if and only if key_condition = “BETWEEN”"""
    query_tester("""
        SELECT insert_update_key.dwid
            , insert_update_key.key_stream1
            , insert_update_key.key_stream2
            , insert_update_key.key_condition
        FROM mdi.insert_update_key
        WHERE insert_update_key.key_condition <> 'BETWEEN'
            AND insert_update_key.key_stream2 IS NOT NULL
        UNION ALL
        SELECT insert_update_key.dwid
            , insert_update_key.key_stream1
            , insert_update_key.key_stream2
            , insert_update_key.key_condition
        FROM mdi.insert_update_key
        WHERE insert_update_key.key_condition = 'BETWEEN'
            AND insert_update_key.key_stream2 IS NULL
    """, "Test 27: [insert_update_key] Record(s) with conflicting key_condition and key_stream2 values.")


def test_28():
    """insert_update_field: field_name must exist in edw_field_definition
    AND edw_field_definition record must reference same table as the insert_update_step.table_name
    Both conditions above must be true UNLESS database is ingress OR schema is staging_compliance"""
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
    """, "Test 28: [insert_update_field] Record(s) missing required relation in edw_field_definition and/or "
         "edw_table_definition.")


def test_29():
    """insert_update_field: field_name must be unique among records with the same insert_update_step_dwid"""
    query_tester("""
        SELECT insert_update_field.insert_update_step_dwid
            , insert_update_field.update_lookup
            , COUNT(*)
        FROM mdi.insert_update_field
        GROUP BY insert_update_field.insert_update_step_dwid
            , insert_update_field.update_lookup
        HAVING COUNT(*) > 1
    """, "Test 29: [insert_update_field] Duplicate field names mapped to a single insert_update_step record.")


def test_30():
    """insert_update_field: If a field is designated as a key field (i.e. it exists in the insert_update_key table)
    then update_flag must be set to ‘N’"""
    query_tester("""
        SELECT insert_update_step.dwid AS insert_update_step_dwid
            , insert_update_key.key_lookup AS key_field_name
            , insert_update_field.update_flag
        FROM mdi.insert_update_step
            JOIN mdi.insert_update_key ON insert_update_step.dwid = insert_update_key.insert_update_step_dwid
            JOIN mdi.insert_update_field ON insert_update_step.dwid = insert_update_field.insert_update_step_dwid
                AND insert_update_key.key_lookup = insert_update_field.update_lookup
                AND insert_update_field.update_flag = 'Y'
    """, "Test 30: [insert_update_field] Designated key field(s) with invalid update_flag value.")


def test_31():
    """delete_step: All records must be referenced by at least one record in delete_key"""
    query_tester("""
        SELECT delete_step.dwid
        FROM mdi.delete_step
            LEFT JOIN mdi.delete_key ON delete_step.dwid = delete_key.delete_step_dwid
        WHERE delete_key.dwid IS NULL
    """, "Test 31: [delete_step] Record(s) missing required delete_key relation.")


def test_32():
    """delete_key: stream_fieldname_2 must never contain a NULL value"""
    query_tester("""
        SELECT delete_key.dwid
            , delete_key.stream_fieldname_1
            , delete_key.stream_fieldname_2
            , delete_key.comparator
        FROM mdi.delete_key
        WHERE stream_fieldname_2 IS NULL
    """, "Test 32: [delete_key] Record(s) with a NULL value in the stream_fieldname_2 field.")


def test_33():
    """delete_key: if comparator is “BETWEEN” then stream_fieldname_2 must have a non-null value that is not an empty
    string
    ELSE stream_fieldname_2 must contain an empty string (not NULL)"""
    query_tester("""
        SELECT delete_key.dwid
            , delete_key.stream_fieldname_1
            , delete_key.stream_fieldname_2
            , delete_key.comparator
        FROM mdi.delete_key
        WHERE comparator = 'BETWEEN'
            AND stream_fieldname_2 = ''
    """, "Test 33: [delete_key] Record(s) with conflicting comparator and stream_fieldname_2 values.")


def test_34():
    """json_output_field: process_dwid must be unique"""
    query_tester("""
        SELECT json_output_field.process_dwid
            , COUNT(*)
        FROM mdi.json_output_field
        GROUP BY json_output_field.process_dwid
        HAVING COUNT(*) > 1
    """, "Test 34: [json_output_field] Duplicate values detected in process_dwid field.")


def test_35():
    """json_output_field: field_name must be one of the following:
        - *_pid
        - dwid
        - *_dwid
        - data_source_integration_id
        - code
        - ais_id
        - dis_id
        - fter_mesage_id"""
    query_tester("""
        SELECT json_output_field.dwid
            , json_output_field.field_name
        FROM mdi.json_output_field
        WHERE NOT (json_output_field.field_name LIKE '%_pid'
            OR json_output_field.field_name LIKE '%_dwid'
            OR json_output_field.field_name IN ('dwid', 'data_source_integration_id', 'code', 'ais_id', 'dis_id', 
            'fter_message_id'))
    """, "Test 35: [json_output_field] invalid field name.")


def test_36():
    """state_machine_definition: name must be a non-empty string consisting of only letters, numbers, dashes,
    and underscores"""
    query_tester("""
        SELECT state_machine_definition.dwid
            , state_machine_definition.name
        FROM mdi.state_machine_definition
        WHERE name !~ '^[a-zA-Z0-9_-]+$'
    """, "Test 36: [state_machine_definition] Invalid value(s) detected in name field.")


def test_37():
    """state_machine_step: process_dwid and next_process_dwid relationship must never result in a recursive loop"""
    query_tester("""
        WITH RECURSIVE search_graph (process_dwid, next_process_dwid, process_sequence, loop_detected) AS (
            SELECT state_machine_step.process_dwid
                 , state_machine_step.next_process_dwid
                 , ARRAY[state_machine_step.process_dwid]
                 , state_machine_step.next_process_dwid = state_machine_step.process_dwid
            FROM mdi.state_machine_step
            UNION ALL
            SELECT state_machine_step.process_dwid
                 , state_machine_step.next_process_dwid
                 , search_graph.process_sequence || state_machine_step.process_dwid
                 , state_machine_step.process_dwid = ANY(search_graph.process_sequence)
            FROM search_graph
                 JOIN mdi.state_machine_step ON search_graph.next_process_dwid = state_machine_step.process_dwid
            WHERE search_graph.loop_detected IS FALSE
        )
        SELECT process_sequence AS looping_state_machine_process_dwid_sequence
        FROM search_graph
        WHERE loop_detected IS TRUE
        ORDER BY process_sequence;
    """, "Test 37: [state_machine_definition] Loop detected in state machine process sequence(s).")


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
