--
-- Main | EDW - Octane schemas from prod-release to uat (2022-01-21)
-- https://app.asana.com/0/0/1201686423062444
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'staging_octane', 'lender_user_suspend_reason_type', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_group_type', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_measure_source_date_type', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_measure_type', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_population_period_type', NULL, NULL, NULL)
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT insert_rows.database_name, insert_rows.schema_name, insert_rows.table_name, source_table_definition.dwid
FROM insert_rows
LEFT JOIN mdi.edw_table_definition source_table_definition
          ON insert_rows.source_database_name = source_table_definition.database_name
              AND insert_rows.source_schema_name = source_table_definition.schema_name
              AND insert_rows.source_table_name = source_table_definition.table_name;

WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'history_octane', 'lender_user_suspend_reason_type', 'staging', 'staging_octane', 'lender_user_suspend_reason_type')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_group_type', 'staging', 'staging_octane', 'smart_ledger_plan_case_group_type')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_measure_source_date_type', 'staging', 'staging_octane', 'smart_ledger_plan_case_measure_source_date_type')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_measure_type', 'staging', 'staging_octane', 'smart_ledger_plan_case_measure_type')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_population_period_type', 'staging', 'staging_octane', 'smart_ledger_plan_case_population_period_type')
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT insert_rows.database_name, insert_rows.schema_name, insert_rows.table_name, source_table_definition.dwid
FROM insert_rows
LEFT JOIN mdi.edw_table_definition source_table_definition
          ON insert_rows.source_database_name = source_table_definition.database_name
              AND insert_rows.source_schema_name = source_table_definition.schema_name
              AND insert_rows.source_table_name = source_table_definition.table_name;

--edw_field_definition
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name,
                  source_table_name, source_field_name) AS (
    VALUES ('staging', 'history_octane', 'lender_user_suspend_reason_type', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_user_suspend_reason_type', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_user_suspend_reason_type', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_ledger_plan_case_group_type', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_ledger_plan_case_group_type', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_ledger_plan_case_group_type', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_ledger_plan_case_measure_source_date_type', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_ledger_plan_case_measure_source_date_type', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_ledger_plan_case_measure_source_date_type', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_ledger_plan_case_measure_type', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_ledger_plan_case_measure_type', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_ledger_plan_case_measure_type', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_ledger_plan_case_population_period_type', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_ledger_plan_case_population_period_type', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_ledger_plan_case_population_period_type', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'ledger_entry', 'le_smart_adjustment', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_user', 'lu_lender_user_suspend_reason_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_user', 'lu_suspend_date_time', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_user', 'lu_suspend_reason_other_description', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_user', 'lu_suspended', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_user_suspend_reason_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_user_suspend_reason_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_group', 'slpcg_smart_ledger_plan_case_group_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_group_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_group_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_measure_source_date_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_measure_source_date_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_measure_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_measure_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_population_period_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_population_period_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_version', 'slpcv_measure_criteria_from_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_version', 'slpcv_measure_criteria_through_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_version', 'slpcv_smart_ledger_plan_case_measure_source_date_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_version', 'slpcv_smart_ledger_plan_case_measure_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_version', 'slpcv_smart_ledger_plan_case_population_period_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
)
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
SELECT edw_table_definition.dwid
     , insert_rows.field_name
     , FALSE
     , source_field_definition.dwid
     , NULL
     , insert_rows.data_type
     , NULL
     , NULL
     , NULL
     , NULL
FROM insert_rows
JOIN mdi.edw_table_definition
     ON insert_rows.database_name = edw_table_definition.database_name
         AND insert_rows.schema_name = edw_table_definition.schema_name
         AND insert_rows.table_name = edw_table_definition.table_name
LEFT JOIN mdi.edw_table_definition source_table_definition
          ON insert_rows.source_database_name = source_table_definition.database_name
              AND insert_rows.source_schema_name = source_table_definition.schema_name
              AND insert_rows.source_table_name = source_table_definition.table_name
LEFT JOIN mdi.edw_field_definition source_field_definition
          ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid
              AND insert_rows.source_field_name = source_field_definition.field_name;

WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name,
                  source_table_name, source_field_name) AS (
    VALUES ('staging', 'history_octane', 'ledger_entry', 'le_smart_adjustment', 'BOOLEAN', 'staging', 'staging_octane', 'ledger_entry', 'le_smart_adjustment')
         , ('staging', 'history_octane', 'lender_user', 'lu_lender_user_suspend_reason_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'lender_user', 'lu_lender_user_suspend_reason_type')
         , ('staging', 'history_octane', 'lender_user', 'lu_suspend_date_time', 'TIMESTAMP', 'staging', 'staging_octane', 'lender_user', 'lu_suspend_date_time')
         , ('staging', 'history_octane', 'lender_user', 'lu_suspend_reason_other_description', 'VARCHAR(1024)', 'staging', 'staging_octane', 'lender_user', 'lu_suspend_reason_other_description')
         , ('staging', 'history_octane', 'lender_user', 'lu_suspended', 'BOOLEAN', 'staging', 'staging_octane', 'lender_user', 'lu_suspended')
         , ('staging', 'history_octane', 'lender_user_suspend_reason_type', 'code', 'VARCHAR(128)', 'staging', 'staging_octane', 'lender_user_suspend_reason_type', 'code')
         , ('staging', 'history_octane', 'lender_user_suspend_reason_type', 'value', 'VARCHAR(1024)', 'staging', 'staging_octane', 'lender_user_suspend_reason_type', 'value')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_group', 'slpcg_smart_ledger_plan_case_group_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'smart_ledger_plan_case_group', 'slpcg_smart_ledger_plan_case_group_type')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_group_type', 'code', 'VARCHAR(128)', 'staging', 'staging_octane', 'smart_ledger_plan_case_group_type', 'code')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_group_type', 'value', 'VARCHAR(1024)', 'staging', 'staging_octane', 'smart_ledger_plan_case_group_type', 'value')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_measure_source_date_type', 'code', 'VARCHAR(128)', 'staging', 'staging_octane', 'smart_ledger_plan_case_measure_source_date_type', 'code')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_measure_source_date_type', 'value', 'VARCHAR(1024)', 'staging', 'staging_octane', 'smart_ledger_plan_case_measure_source_date_type', 'value')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_measure_type', 'code', 'VARCHAR(128)', 'staging', 'staging_octane', 'smart_ledger_plan_case_measure_type', 'code')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_measure_type', 'value', 'VARCHAR(1024)', 'staging', 'staging_octane', 'smart_ledger_plan_case_measure_type', 'value')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_population_period_type', 'code', 'VARCHAR(128)', 'staging', 'staging_octane', 'smart_ledger_plan_case_population_period_type', 'code')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_population_period_type', 'value', 'VARCHAR(1024)', 'staging', 'staging_octane', 'smart_ledger_plan_case_population_period_type', 'value')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_version', 'slpcv_measure_criteria_from_date', 'DATE', 'staging', 'staging_octane', 'smart_ledger_plan_case_version', 'slpcv_measure_criteria_from_date')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_version', 'slpcv_measure_criteria_through_date', 'DATE', 'staging', 'staging_octane', 'smart_ledger_plan_case_version', 'slpcv_measure_criteria_through_date')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_version', 'slpcv_smart_ledger_plan_case_measure_source_date_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'smart_ledger_plan_case_version', 'slpcv_smart_ledger_plan_case_measure_source_date_type')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_version', 'slpcv_smart_ledger_plan_case_measure_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'smart_ledger_plan_case_version', 'slpcv_smart_ledger_plan_case_measure_type')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_version', 'slpcv_smart_ledger_plan_case_population_period_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'smart_ledger_plan_case_version', 'slpcv_smart_ledger_plan_case_population_period_type')
)
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
SELECT edw_table_definition.dwid
     , insert_rows.field_name
     , FALSE
     , source_field_definition.dwid
     , NULL
     , insert_rows.data_type
     , NULL
     , NULL
     , NULL
     , NULL
FROM insert_rows
JOIN mdi.edw_table_definition
     ON insert_rows.database_name = edw_table_definition.database_name
         AND insert_rows.schema_name = edw_table_definition.schema_name
         AND insert_rows.table_name = edw_table_definition.table_name
LEFT JOIN mdi.edw_table_definition source_table_definition
          ON insert_rows.source_database_name = source_table_definition.database_name
              AND insert_rows.source_schema_name = source_table_definition.schema_name
              AND insert_rows.source_table_name = source_table_definition.table_name
LEFT JOIN mdi.edw_field_definition source_field_definition
          ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid
              AND insert_rows.source_field_name = source_field_definition.field_name;

--process
INSERT
INTO mdi.process (name, description)
VALUES ('SP-100888', 'ETL to copy lender_user_suspend_reason_type data from staging_octane to history_octane')
     , ('SP-100889', 'ETL to copy smart_ledger_plan_case_group_type data from staging_octane to history_octane')
     , ('SP-100890', 'ETL to copy smart_ledger_plan_case_measure_source_date_type data from staging_octane to history_octane')
     , ('SP-100891', 'ETL to copy smart_ledger_plan_case_measure_type data from staging_octane to history_octane')
     , ('SP-100892', 'ETL to copy smart_ledger_plan_case_population_period_type data from staging_octane to history_octane');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100888', 0, '--finding records to insert into history_octane.lender_user_suspend_reason_type
SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.lender_user_suspend_reason_type staging_table
LEFT JOIN history_octane.lender_user_suspend_reason_type history_table
          ON staging_table.code = history_table.code
              AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;', 'Staging DB Connection')
         , ('SP-100889', 0, '--finding records to insert into history_octane.smart_ledger_plan_case_group_type
SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_ledger_plan_case_group_type staging_table
LEFT JOIN history_octane.smart_ledger_plan_case_group_type history_table
          ON staging_table.code = history_table.code
              AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;', 'Staging DB Connection')
         , ('SP-100890', 0, '--finding records to insert into history_octane.smart_ledger_plan_case_measure_source_date_type
SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_ledger_plan_case_measure_source_date_type staging_table
LEFT JOIN history_octane.smart_ledger_plan_case_measure_source_date_type history_table
          ON staging_table.code = history_table.code
              AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;', 'Staging DB Connection')
         , ('SP-100891', 0, '--finding records to insert into history_octane.smart_ledger_plan_case_measure_type
SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_ledger_plan_case_measure_type staging_table
LEFT JOIN history_octane.smart_ledger_plan_case_measure_type history_table
          ON staging_table.code = history_table.code
              AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;', 'Staging DB Connection')
         , ('SP-100892', 0, '--finding records to insert into history_octane.smart_ledger_plan_case_population_period_type
SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_ledger_plan_case_population_period_type staging_table
LEFT JOIN history_octane.smart_ledger_plan_case_population_period_type history_table
          ON staging_table.code = history_table.code
              AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;', 'Staging DB Connection')
)
INSERT
INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
SELECT process.dwid
     , insert_rows.data_source_dwid
     , insert_rows.sql
     , 0
     , 'N'
     , 'N'
     , 'N'
     , 'N'
     , insert_rows.connectionname::mdi.pentaho_db_connection_name
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--table_output_step
WITH insert_rows (process_name, target_schema, target_table, truncate_table, connectionname) AS (
    VALUES ('SP-100888', 'history_octane', 'lender_user_suspend_reason_type', 'N', 'Staging DB Connection')
         , ('SP-100889', 'history_octane', 'smart_ledger_plan_case_group_type', 'N', 'Staging DB Connection')
         , ('SP-100890', 'history_octane', 'smart_ledger_plan_case_measure_source_date_type', 'N', 'Staging DB Connection')
         , ('SP-100891', 'history_octane', 'smart_ledger_plan_case_measure_type', 'N', 'Staging DB Connection')
         , ('SP-100892', 'history_octane', 'smart_ledger_plan_case_population_period_type', 'N', 'Staging DB Connection')
)
INSERT
INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT process.dwid
     , insert_rows.target_schema
     , insert_rows.target_table
     , 1000
     , NULL
     , NULL
     , NULL
     , NULL
     , 'N'
     , NULL
     , insert_rows.truncate_table::mdi.pentaho_y_or_n
     , insert_rows.connectionname
     , 'N'
     , 'Y'
     , 'N'
     , 'N'
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('SP-100214', 'le_smart_adjustment')
         , ('SP-100090', 'lu_lender_user_suspend_reason_type')
         , ('SP-100090', 'lu_suspend_date_time')
         , ('SP-100090', 'lu_suspend_reason_other_description')
         , ('SP-100090', 'lu_suspended')
         , ('SP-100888', 'code')
         , ('SP-100888', 'data_source_deleted_flag')
         , ('SP-100888', 'data_source_updated_datetime')
         , ('SP-100888', 'etl_batch_id')
         , ('SP-100888', 'value')
         , ('SP-100211', 'slpcg_smart_ledger_plan_case_group_type')
         , ('SP-100889', 'code')
         , ('SP-100889', 'data_source_deleted_flag')
         , ('SP-100889', 'data_source_updated_datetime')
         , ('SP-100889', 'etl_batch_id')
         , ('SP-100889', 'value')
         , ('SP-100890', 'code')
         , ('SP-100890', 'data_source_deleted_flag')
         , ('SP-100890', 'data_source_updated_datetime')
         , ('SP-100890', 'etl_batch_id')
         , ('SP-100890', 'value')
         , ('SP-100891', 'code')
         , ('SP-100891', 'data_source_deleted_flag')
         , ('SP-100891', 'data_source_updated_datetime')
         , ('SP-100891', 'etl_batch_id')
         , ('SP-100891', 'value')
         , ('SP-100892', 'code')
         , ('SP-100892', 'data_source_deleted_flag')
         , ('SP-100892', 'data_source_updated_datetime')
         , ('SP-100892', 'etl_batch_id')
         , ('SP-100892', 'value')
         , ('SP-100213', 'slpcv_measure_criteria_from_date')
         , ('SP-100213', 'slpcv_measure_criteria_through_date')
         , ('SP-100213', 'slpcv_smart_ledger_plan_case_measure_source_date_type')
         , ('SP-100213', 'slpcv_smart_ledger_plan_case_measure_type')
         , ('SP-100213', 'slpcv_smart_ledger_plan_case_population_period_type')
)
INSERT
INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
SELECT table_output_step.dwid, insert_rows.database_field_name, insert_rows.database_field_name, 0, FALSE
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name
JOIN mdi.table_output_step
     ON process.dwid = table_output_step.process_dwid;


--json_output_field
WITH insert_rows (process_name, json_output_field) AS (
    VALUES ('SP-100888', 'code')
         , ('SP-100889', 'code')
         , ('SP-100890', 'code')
         , ('SP-100891', 'code')
         , ('SP-100892', 'code')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
JOIN mdi.process
     ON insert_rows.process_name = process.name;

--state_machine_definition
WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-100888', 'SP-100888', 'ETL to copy lender_user_suspend_reason_type data from staging_octane to history_octane')
         , ('SP-100889', 'SP-100889', 'ETL to copy smart_ledger_plan_case_group_type data from staging_octane to history_octane')
         , ('SP-100890', 'SP-100890', 'ETL to copy smart_ledger_plan_case_measure_source_date_type data from staging_octane to history_octane')
         , ('SP-100891', 'SP-100891', 'ETL to copy smart_ledger_plan_case_measure_type data from staging_octane to history_octane')
         , ('SP-100892', 'SP-100892', 'ETL to copy smart_ledger_plan_case_population_period_type data from staging_octane to history_octane')
)
INSERT
INTO mdi.state_machine_definition (process_dwid, name, comment)
SELECT process.dwid, insert_rows.state_machine_name, insert_rows.state_machine_comment
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

/*
UPDATES
*/

--edw_field_definition
WITH update_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name,
                  source_table_name, source_field_name) AS (
    VALUES ('staging', 'history_octane', 'ledger_entry', 'le_synthetic_unique', 'VARCHAR(128)', 'staging', 'staging_octane', 'ledger_entry', 'le_synthetic_unique')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_version', 'slpcv_smart_ledger_plan_case_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'ledger_entry', 'le_synthetic_unique', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
)
UPDATE mdi.edw_field_definition
SET data_type = update_rows.data_type
  , source_edw_field_definition_dwid = source_field_definition.dwid
FROM update_rows
JOIN mdi.edw_table_definition
     ON update_rows.database_name = edw_table_definition.database_name
         AND update_rows.schema_name = edw_table_definition.schema_name
         AND update_rows.table_name = edw_table_definition.table_name
LEFT JOIN mdi.edw_table_definition source_table_definition
          ON update_rows.source_database_name = source_table_definition.database_name
              AND update_rows.source_schema_name = source_table_definition.schema_name
              AND update_rows.source_table_name = source_table_definition.table_name
LEFT JOIN mdi.edw_field_definition source_field_definition
          ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid
              AND update_rows.source_field_name = source_field_definition.field_name
WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = update_rows.field_name;

--table_input_step
WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100214', 0, '--finding records to insert into history_octane.ledger_entry
SELECT staging_table.le_pid
     , staging_table.le_version
     , staging_table.le_account_pid
     , staging_table.le_ledger_entry_type
     , staging_table.le_ledger_entry_source_type
     , staging_table.le_estimate
     , staging_table.le_ledger_entry_decision_status_type
     , staging_table.le_create_datetime
     , staging_table.le_entry_amount
     , staging_table.le_source_org_node_pid
     , staging_table.le_payee_org_node_pid
     , staging_table.le_payee_org_lineage_pid
     , staging_table.le_source_org_lineage_pid
     , staging_table.le_org_lineage_source_date
     , staging_table.le_deal_pid
     , staging_table.le_loan_position_type
     , staging_table.le_los_loan_id
     , staging_table.le_notes
     , staging_table.le_monthly_ledger_book_pid
     , staging_table.le_payroll_ledger_book_pid
     , staging_table.le_ledger_book_datetime
     , staging_table.le_expense_date
     , staging_table.le_reversal
     , staging_table.le_passthrough
     , staging_table.le_smart_ledger_plan_case_version_pid
     , staging_table.le_synthetic_unique
     , staging_table.le_smart_adjustment
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.ledger_entry staging_table
LEFT JOIN history_octane.ledger_entry history_table
          ON staging_table.le_pid = history_table.le_pid
              AND staging_table.le_version = history_table.le_version
WHERE history_table.le_pid IS NULL
UNION ALL
SELECT history_table.le_pid
     , history_table.le_version + 1
     , history_table.le_account_pid
     , history_table.le_ledger_entry_type
     , history_table.le_ledger_entry_source_type
     , history_table.le_estimate
     , history_table.le_ledger_entry_decision_status_type
     , history_table.le_create_datetime
     , history_table.le_entry_amount
     , history_table.le_source_org_node_pid
     , history_table.le_payee_org_node_pid
     , history_table.le_payee_org_lineage_pid
     , history_table.le_source_org_lineage_pid
     , history_table.le_org_lineage_source_date
     , history_table.le_deal_pid
     , history_table.le_loan_position_type
     , history_table.le_los_loan_id
     , history_table.le_notes
     , history_table.le_monthly_ledger_book_pid
     , history_table.le_payroll_ledger_book_pid
     , history_table.le_ledger_book_datetime
     , history_table.le_expense_date
     , history_table.le_reversal
     , history_table.le_passthrough
     , history_table.le_smart_ledger_plan_case_version_pid
     , history_table.le_synthetic_unique
     , history_table.le_smart_adjustment
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.ledger_entry history_table
LEFT JOIN staging_octane.ledger_entry staging_table
          ON staging_table.le_pid = history_table.le_pid
WHERE staging_table.le_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.ledger_entry deleted_records
    WHERE deleted_records.le_pid = history_table.le_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100090', 0, '--finding records to insert into history_octane.lender_user
SELECT staging_table.lu_pid
     , staging_table.lu_version
     , staging_table.lu_branch_pid
     , staging_table.lu_account_owner
     , staging_table.lu_account_pid
     , staging_table.lu_create_date
     , staging_table.lu_first_name
     , staging_table.lu_last_name
     , staging_table.lu_middle_name
     , staging_table.lu_name_suffix
     , staging_table.lu_company_name
     , staging_table.lu_title
     , staging_table.lu_office_phone
     , staging_table.lu_office_phone_extension
     , staging_table.lu_email
     , staging_table.lu_fax
     , staging_table.lu_city
     , staging_table.lu_country
     , staging_table.lu_postal_code
     , staging_table.lu_state
     , staging_table.lu_street1
     , staging_table.lu_street2
     , staging_table.lu_office_phone_use_branch
     , staging_table.lu_fax_use_branch
     , staging_table.lu_address_use_branch
     , staging_table.lu_start_date
     , staging_table.lu_through_date
     , staging_table.lu_time_zone
     , staging_table.lu_unparsed_name
     , staging_table.lu_lender_user_status_type
     , staging_table.lu_username
     , staging_table.lu_nmls_loan_originator_id
     , staging_table.lu_fha_chums_id
     , staging_table.lu_va_agent_id
     , staging_table.lu_search_text
     , staging_table.lu_company_user_id
     , staging_table.lu_force_password_change
     , staging_table.lu_last_password_change_date
     , staging_table.lu_challenge_question_type
     , staging_table.lu_allow_external_ip
     , staging_table.lu_total_workload_cap
     , staging_table.lu_schedule_once_booking_page_id
     , staging_table.lu_performer_team_pid
     , staging_table.lu_esign_only
     , staging_table.lu_work_step_start_notices_enabled
     , staging_table.lu_smart_app_enabled
     , staging_table.lu_default_lead_source_pid
     , staging_table.lu_default_credit_bureau_type
     , staging_table.lu_originator_id
     , staging_table.lu_name_qualifier
     , staging_table.lu_training_mode
     , staging_table.lu_about_me
     , staging_table.lu_lender_user_type
     , staging_table.lu_hire_date
     , staging_table.lu_mercury_client_group_pid
     , staging_table.lu_nickname
     , staging_table.lu_preferred_first_name
     , staging_table.lu_hub_directory
     , staging_table.lu_email_signature_title
     , staging_table.lu_termination_date
     , staging_table.lu_marketing_details_enabled
     , staging_table.lu_marketing_details_featured_review
     , staging_table.lu_suspended
     , staging_table.lu_lender_user_suspend_reason_type
     , staging_table.lu_suspend_reason_other_description
     , staging_table.lu_suspend_date_time
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.lender_user staging_table
LEFT JOIN history_octane.lender_user history_table
          ON staging_table.lu_pid = history_table.lu_pid
              AND staging_table.lu_version = history_table.lu_version
WHERE history_table.lu_pid IS NULL
UNION ALL
SELECT history_table.lu_pid
     , history_table.lu_version + 1
     , history_table.lu_branch_pid
     , history_table.lu_account_owner
     , history_table.lu_account_pid
     , history_table.lu_create_date
     , history_table.lu_first_name
     , history_table.lu_last_name
     , history_table.lu_middle_name
     , history_table.lu_name_suffix
     , history_table.lu_company_name
     , history_table.lu_title
     , history_table.lu_office_phone
     , history_table.lu_office_phone_extension
     , history_table.lu_email
     , history_table.lu_fax
     , history_table.lu_city
     , history_table.lu_country
     , history_table.lu_postal_code
     , history_table.lu_state
     , history_table.lu_street1
     , history_table.lu_street2
     , history_table.lu_office_phone_use_branch
     , history_table.lu_fax_use_branch
     , history_table.lu_address_use_branch
     , history_table.lu_start_date
     , history_table.lu_through_date
     , history_table.lu_time_zone
     , history_table.lu_unparsed_name
     , history_table.lu_lender_user_status_type
     , history_table.lu_username
     , history_table.lu_nmls_loan_originator_id
     , history_table.lu_fha_chums_id
     , history_table.lu_va_agent_id
     , history_table.lu_search_text
     , history_table.lu_company_user_id
     , history_table.lu_force_password_change
     , history_table.lu_last_password_change_date
     , history_table.lu_challenge_question_type
     , history_table.lu_allow_external_ip
     , history_table.lu_total_workload_cap
     , history_table.lu_schedule_once_booking_page_id
     , history_table.lu_performer_team_pid
     , history_table.lu_esign_only
     , history_table.lu_work_step_start_notices_enabled
     , history_table.lu_smart_app_enabled
     , history_table.lu_default_lead_source_pid
     , history_table.lu_default_credit_bureau_type
     , history_table.lu_originator_id
     , history_table.lu_name_qualifier
     , history_table.lu_training_mode
     , history_table.lu_about_me
     , history_table.lu_lender_user_type
     , history_table.lu_hire_date
     , history_table.lu_mercury_client_group_pid
     , history_table.lu_nickname
     , history_table.lu_preferred_first_name
     , history_table.lu_hub_directory
     , history_table.lu_email_signature_title
     , history_table.lu_termination_date
     , history_table.lu_marketing_details_enabled
     , history_table.lu_marketing_details_featured_review
     , history_table.lu_suspended
     , history_table.lu_lender_user_suspend_reason_type
     , history_table.lu_suspend_reason_other_description
     , history_table.lu_suspend_date_time
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.lender_user history_table
LEFT JOIN staging_octane.lender_user staging_table
          ON staging_table.lu_pid = history_table.lu_pid
WHERE staging_table.lu_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.lender_user deleted_records
    WHERE deleted_records.lu_pid = history_table.lu_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100211', 0, '--finding records to insert into history_octane.smart_ledger_plan_case_group
SELECT staging_table.slpcg_pid
     , staging_table.slpcg_version
     , staging_table.slpcg_account_pid
     , staging_table.slpcg_smart_ledger_plan_pid
     , staging_table.slpcg_group_name
     , staging_table.slpcg_group_id
     , staging_table.slpcg_payer_org_node_pid
     , staging_table.slpcg_smart_ledger_plan_case_group_calculation_type
     , staging_table.slpcg_smart_ledger_plan_case_group_type
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_ledger_plan_case_group staging_table
LEFT JOIN history_octane.smart_ledger_plan_case_group history_table
          ON staging_table.slpcg_pid = history_table.slpcg_pid
              AND staging_table.slpcg_version = history_table.slpcg_version
WHERE history_table.slpcg_pid IS NULL
UNION ALL
SELECT history_table.slpcg_pid
     , history_table.slpcg_version + 1
     , history_table.slpcg_account_pid
     , history_table.slpcg_smart_ledger_plan_pid
     , history_table.slpcg_group_name
     , history_table.slpcg_group_id
     , history_table.slpcg_payer_org_node_pid
     , history_table.slpcg_smart_ledger_plan_case_group_calculation_type
     , history_table.slpcg_smart_ledger_plan_case_group_type
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.smart_ledger_plan_case_group history_table
LEFT JOIN staging_octane.smart_ledger_plan_case_group staging_table
          ON staging_table.slpcg_pid = history_table.slpcg_pid
WHERE staging_table.slpcg_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.smart_ledger_plan_case_group deleted_records
    WHERE deleted_records.slpcg_pid = history_table.slpcg_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100213', 0, '--finding records to insert into history_octane.smart_ledger_plan_case_version
SELECT staging_table.slpcv_pid
     , staging_table.slpcv_version
     , staging_table.slpcv_account_pid
     , staging_table.slpcv_smart_ledger_plan_case_pid
     , staging_table.slpcv_payer_org_node_pid
     , staging_table.slpcv_active
     , staging_table.slpcv_synthetic_unique
     , staging_table.slpcv_case_name
     , staging_table.slpcv_smart_ledger_plan_case_level_type
     , staging_table.slpcv_smart_ledger_pay_frequency_type
     , staging_table.slpcv_from_date
     , staging_table.slpcv_through_date
     , staging_table.slpcv_base_amount
     , staging_table.slpcv_basis_points
     , staging_table.slpcv_min_amount
     , staging_table.slpcv_max_amount
     , staging_table.slpcv_ledger_basis_points_input_type
     , staging_table.slpcv_criteria_pid
     , staging_table.slpcv_last_modified_by
     , staging_table.slpcv_last_modified_datetime
     , staging_table.slpcv_smart_ledger_plan_case_measure_type
     , staging_table.slpcv_smart_ledger_plan_case_measure_source_date_type
     , staging_table.slpcv_smart_ledger_plan_case_population_period_type
     , staging_table.slpcv_measure_criteria_from_date
     , staging_table.slpcv_measure_criteria_through_date
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_ledger_plan_case_version staging_table
LEFT JOIN history_octane.smart_ledger_plan_case_version history_table
          ON staging_table.slpcv_pid = history_table.slpcv_pid
              AND staging_table.slpcv_version = history_table.slpcv_version
WHERE history_table.slpcv_pid IS NULL
UNION ALL
SELECT history_table.slpcv_pid
     , history_table.slpcv_version + 1
     , history_table.slpcv_account_pid
     , history_table.slpcv_smart_ledger_plan_case_pid
     , history_table.slpcv_payer_org_node_pid
     , history_table.slpcv_active
     , history_table.slpcv_synthetic_unique
     , history_table.slpcv_case_name
     , history_table.slpcv_smart_ledger_plan_case_level_type
     , history_table.slpcv_smart_ledger_pay_frequency_type
     , history_table.slpcv_from_date
     , history_table.slpcv_through_date
     , history_table.slpcv_base_amount
     , history_table.slpcv_basis_points
     , history_table.slpcv_min_amount
     , history_table.slpcv_max_amount
     , history_table.slpcv_ledger_basis_points_input_type
     , history_table.slpcv_criteria_pid
     , history_table.slpcv_last_modified_by
     , history_table.slpcv_last_modified_datetime
     , history_table.slpcv_smart_ledger_plan_case_measure_type
     , history_table.slpcv_smart_ledger_plan_case_measure_source_date_type
     , history_table.slpcv_smart_ledger_plan_case_population_period_type
     , history_table.slpcv_measure_criteria_from_date
     , history_table.slpcv_measure_criteria_through_date
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.smart_ledger_plan_case_version history_table
LEFT JOIN staging_octane.smart_ledger_plan_case_version staging_table
          ON staging_table.slpcv_pid = history_table.slpcv_pid
WHERE staging_table.slpcv_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.smart_ledger_plan_case_version deleted_records
    WHERE deleted_records.slpcv_pid = history_table.slpcv_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
)
UPDATE mdi.table_input_step
SET data_source_dwid = update_rows.data_source_dwid
  , sql = update_rows.sql
  , connectionname = update_rows.connectionname::mdi.pentaho_db_connection_name
FROM update_rows
JOIN mdi.process
     ON process.name = update_rows.process_name
WHERE process.dwid = table_input_step.process_dwid;

/*
DELETIONS
*/

--state_machine_definition
WITH delete_keys (process_name) AS (
    VALUES ('SP-100702')
)
DELETE
FROM mdi.state_machine_definition
    USING delete_keys, mdi.process
WHERE state_machine_definition.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--json_output_field
WITH delete_keys (process_name) AS (
    VALUES ('SP-100702')
)
DELETE
FROM mdi.json_output_field
    USING delete_keys, mdi.process
WHERE json_output_field.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--table_output_field
WITH delete_keys (process_name, database_field_name) AS (
    VALUES ('SP-100213', 'slpcv_smart_ledger_plan_case_type')
         , ('SP-100702', 'code')
         , ('SP-100702', 'value')
         , ('SP-100702', 'data_source_updated_datetime')
         , ('SP-100702', 'data_source_deleted_flag')
         , ('SP-100702', 'etl_batch_id')
)
DELETE
FROM mdi.table_output_field
    USING delete_keys, mdi.process, mdi.table_output_step
WHERE delete_keys.process_name = process.name
  AND process.dwid = table_output_step.process_dwid
  AND table_output_step.dwid = table_output_field.table_output_step_dwid
  AND delete_keys.database_field_name = table_output_field.database_field_name;

--table_output_step
WITH delete_keys (process_name) AS (
    VALUES ('SP-100702')
)
DELETE
FROM mdi.table_output_step
    USING delete_keys, mdi.process
WHERE table_output_step.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--table_input_step
WITH delete_keys (process_name) AS (
    VALUES ('SP-100702')
)
DELETE
FROM mdi.table_input_step
    USING delete_keys, mdi.process
WHERE table_input_step.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--process
WITH delete_keys (process_name) AS (
    VALUES ('SP-100702')
)
DELETE
FROM mdi.process
    USING delete_keys
WHERE process.name = delete_keys.process_name;

--edw_field_definition
WITH delete_keys (database_name, schema_name, table_name, field_name) AS (
    VALUES ('staging', 'history_octane', 'smart_ledger_plan_case_type', 'etl_batch_id')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_type', 'data_source_updated_datetime')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_type', 'data_source_deleted_flag')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_type', 'value')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_type', 'code')
)
DELETE
FROM mdi.edw_field_definition
    USING delete_keys, mdi.edw_table_definition
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name
  AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = delete_keys.field_name;

WITH delete_keys (database_name, schema_name, table_name, field_name) AS (
    VALUES ('staging', 'staging_octane', 'smart_ledger_plan_case_type', 'code')
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_type', 'value')
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_version', 'slpcv_smart_ledger_plan_case_type')
)
DELETE
FROM mdi.edw_field_definition
    USING delete_keys, mdi.edw_table_definition
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name
  AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = delete_keys.field_name;

--edw_join_definition (MANUALLY ADDED to prevent referential integrity error in auto-generated script)
DELETE
FROM mdi.edw_join_definition
    USING mdi.edw_table_definition primary_table, mdi.edw_table_definition target_table
WHERE edw_join_definition.primary_edw_table_definition_dwid = primary_table.dwid
  AND edw_join_definition.target_edw_table_definition_dwid = target_table.dwid
  AND (primary_table.table_name = 'smart_ledger_plan_case_type'
    OR target_table.table_name = 'smart_ledger_plan_case_type');


--edw_table_definition
WITH delete_keys (database_name, schema_name, table_name) AS (
    VALUES ('staging', 'history_octane', 'smart_ledger_plan_case_type')
)
DELETE
FROM mdi.edw_table_definition
    USING delete_keys
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name;

WITH delete_keys (database_name, schema_name, table_name) AS (
    VALUES ('staging', 'staging_octane', 'smart_ledger_plan_case_type')
)
DELETE
FROM mdi.edw_table_definition
    USING delete_keys
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name;
