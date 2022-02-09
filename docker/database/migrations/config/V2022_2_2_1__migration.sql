--
-- Main | EDW | Octane schemas from prod-release to v2022.2.2.1 on uat
-- https://app.asana.com/0/0/1201788240114334
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'staging_octane', 'deal_pending_update', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_review_request_type', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_update_type', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'wf_step_function_parameters', NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'deal_pending_update', 'staging', 'staging_octane', 'deal_pending_update')
         , ('staging', 'history_octane', 'proposal_review_request_type', 'staging', 'staging_octane', 'proposal_review_request_type')
         , ('staging', 'history_octane', 'deal_update_type', 'staging', 'staging_octane', 'deal_update_type')
         , ('staging', 'history_octane', 'wf_step_function_parameters', 'staging', 'staging_octane', 'wf_step_function_parameters')
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
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'history_octane', 'deal_pending_update', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'deal_pending_update', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'deal_pending_update', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'proposal_review_request_type', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'proposal_review_request_type', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'proposal_review_request_type', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'deal_update_type', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'deal_update_type', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'deal_update_type', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_function_parameters', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_function_parameters', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_function_parameters', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_pending_update', 'dpu_args_json', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_pending_update', 'dpu_completed_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_pending_update', 'dpu_create_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_pending_update', 'dpu_deal_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_pending_update', 'dpu_deal_update_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_pending_update', 'dpu_last_attempt_end_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_pending_update', 'dpu_last_attempt_start_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_pending_update', 'dpu_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_pending_update', 'dpu_run_count', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_pending_update', 'dpu_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_review', 'prpre_completed_proposal_snapshot_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_review', 'prpre_create_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_review', 'prpre_proposal_review_request_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_review', 'prpre_requested_proposal_snapshot_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_review', 'prpre_scenario_proposal_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_review', 'prpre_scenario_proposal_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'role_charge_permissions', 'rcp_payer_borrower_seller_editable', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'role_charge_permissions', 'rcp_payer_other_editable', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_review_request_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_review_request_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_summary', 'ds_proposal_review_requested_count', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_update_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_update_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'place', 'pl_verified_geocode', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'wf_step_function_parameters', 'wsfp_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'wf_step_function_parameters', 'wsfp_proposal_review_id', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'wf_step_function_parameters', 'wsfp_proposal_review_status_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'wf_step_function_parameters', 'wsfp_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'wf_step_function_parameters', 'wsfp_wf_step_pid', 'BIGINT', NULL, NULL, NULL, NULL)
)
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
SELECT edw_table_definition.dwid, insert_rows.field_name, FALSE, source_field_definition.dwid, NULL, insert_rows.data_type, NULL, NULL, NULL, NULL
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

WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'history_octane', 'deal_pending_update', 'dpu_args_json', 'TEXT', 'staging', 'staging_octane', 'deal_pending_update', 'dpu_args_json')
         , ('staging', 'history_octane', 'deal_pending_update', 'dpu_completed_datetime', 'TIMESTAMP', 'staging', 'staging_octane', 'deal_pending_update', 'dpu_completed_datetime')
         , ('staging', 'history_octane', 'deal_pending_update', 'dpu_create_datetime', 'TIMESTAMP', 'staging', 'staging_octane', 'deal_pending_update', 'dpu_create_datetime')
         , ('staging', 'history_octane', 'deal_pending_update', 'dpu_deal_pid', 'BIGINT', 'staging', 'staging_octane', 'deal_pending_update', 'dpu_deal_pid')
         , ('staging', 'history_octane', 'deal_pending_update', 'dpu_deal_update_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'deal_pending_update', 'dpu_deal_update_type')
         , ('staging', 'history_octane', 'deal_pending_update', 'dpu_last_attempt_end_datetime', 'TIMESTAMP', 'staging', 'staging_octane', 'deal_pending_update', 'dpu_last_attempt_end_datetime')
         , ('staging', 'history_octane', 'deal_pending_update', 'dpu_last_attempt_start_datetime', 'TIMESTAMP', 'staging', 'staging_octane', 'deal_pending_update', 'dpu_last_attempt_start_datetime')
         , ('staging', 'history_octane', 'deal_pending_update', 'dpu_pid', 'BIGINT', 'staging', 'staging_octane', 'deal_pending_update', 'dpu_pid')
         , ('staging', 'history_octane', 'deal_pending_update', 'dpu_run_count', 'INTEGER', 'staging', 'staging_octane', 'deal_pending_update', 'dpu_run_count')
         , ('staging', 'history_octane', 'deal_pending_update', 'dpu_version', 'INTEGER', 'staging', 'staging_octane', 'deal_pending_update', 'dpu_version')
         , ('staging', 'history_octane', 'proposal_review', 'prpre_completed_proposal_snapshot_pid', 'BIGINT', 'staging', 'staging_octane', 'proposal_review', 'prpre_completed_proposal_snapshot_pid')
         , ('staging', 'history_octane', 'proposal_review', 'prpre_create_datetime', 'TIMESTAMP', 'staging', 'staging_octane', 'proposal_review', 'prpre_create_datetime')
         , ('staging', 'history_octane', 'proposal_review', 'prpre_proposal_review_request_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'proposal_review', 'prpre_proposal_review_request_type')
         , ('staging', 'history_octane', 'proposal_review', 'prpre_requested_proposal_snapshot_pid', 'BIGINT', 'staging', 'staging_octane', 'proposal_review', 'prpre_requested_proposal_snapshot_pid')
         , ('staging', 'history_octane', 'proposal_review', 'prpre_scenario_proposal_name', 'VARCHAR(128)', 'staging', 'staging_octane', 'proposal_review', 'prpre_scenario_proposal_name')
         , ('staging', 'history_octane', 'proposal_review', 'prpre_scenario_proposal_pid', 'BIGINT', 'staging', 'staging_octane', 'proposal_review', 'prpre_scenario_proposal_pid')
         , ('staging', 'history_octane', 'role_charge_permissions', 'rcp_payer_borrower_seller_editable', 'BOOLEAN', 'staging', 'staging_octane', 'role_charge_permissions', 'rcp_payer_borrower_seller_editable')
         , ('staging', 'history_octane', 'role_charge_permissions', 'rcp_payer_other_editable', 'BOOLEAN', 'staging', 'staging_octane', 'role_charge_permissions', 'rcp_payer_other_editable')
         , ('staging', 'history_octane', 'proposal_review_request_type', 'code', 'VARCHAR(128)', 'staging', 'staging_octane', 'proposal_review_request_type', 'code')
         , ('staging', 'history_octane', 'proposal_review_request_type', 'value', 'VARCHAR(1024)', 'staging', 'staging_octane', 'proposal_review_request_type', 'value')
         , ('staging', 'history_octane', 'deal_summary', 'ds_proposal_review_requested_count', 'INTEGER', 'staging', 'staging_octane', 'deal_summary', 'ds_proposal_review_requested_count')
         , ('staging', 'history_octane', 'deal_update_type', 'code', 'VARCHAR(128)', 'staging', 'staging_octane', 'deal_update_type', 'code')
         , ('staging', 'history_octane', 'deal_update_type', 'value', 'VARCHAR(1024)', 'staging', 'staging_octane', 'deal_update_type', 'value')
         , ('staging', 'history_octane', 'place', 'pl_verified_geocode', 'BOOLEAN', 'staging', 'staging_octane', 'place', 'pl_verified_geocode')
         , ('staging', 'history_octane', 'wf_step_function_parameters', 'wsfp_pid', 'BIGINT', 'staging', 'staging_octane', 'wf_step_function_parameters', 'wsfp_pid')
         , ('staging', 'history_octane', 'wf_step_function_parameters', 'wsfp_proposal_review_id', 'INTEGER', 'staging', 'staging_octane', 'wf_step_function_parameters', 'wsfp_proposal_review_id')
         , ('staging', 'history_octane', 'wf_step_function_parameters', 'wsfp_proposal_review_status_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'wf_step_function_parameters', 'wsfp_proposal_review_status_type')
         , ('staging', 'history_octane', 'wf_step_function_parameters', 'wsfp_version', 'INTEGER', 'staging', 'staging_octane', 'wf_step_function_parameters', 'wsfp_version')
         , ('staging', 'history_octane', 'wf_step_function_parameters', 'wsfp_wf_step_pid', 'BIGINT', 'staging', 'staging_octane', 'wf_step_function_parameters', 'wsfp_wf_step_pid')
)
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
SELECT edw_table_definition.dwid, insert_rows.field_name, FALSE, source_field_definition.dwid, NULL, insert_rows.data_type, NULL, NULL, NULL, NULL
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
VALUES ('SP-100897', 'ETL to copy deal_pending_update data from staging_octane to history_octane')
     , ('SP-100899', 'ETL to copy proposal_review_request_type data from staging_octane to history_octane')
     , ('SP-100898', 'ETL to copy deal_update_type data from staging_octane to history_octane')
     , ('SP-100900', 'ETL to copy wf_step_function_parameters data from staging_octane to history_octane');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100897', 0, '--finding records to insert into history_octane.deal_pending_update
SELECT staging_table.dpu_pid
     , staging_table.dpu_version
     , staging_table.dpu_deal_pid
     , staging_table.dpu_deal_update_type
     , staging_table.dpu_args_json
     , staging_table.dpu_create_datetime
     , staging_table.dpu_last_attempt_start_datetime
     , staging_table.dpu_last_attempt_end_datetime
     , staging_table.dpu_completed_datetime
     , staging_table.dpu_run_count
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.deal_pending_update staging_table
LEFT JOIN history_octane.deal_pending_update history_table
          ON staging_table.dpu_pid = history_table.dpu_pid
              AND staging_table.dpu_version = history_table.dpu_version
WHERE history_table.dpu_pid IS NULL
UNION ALL
SELECT history_table.dpu_pid
     , history_table.dpu_version + 1
     , history_table.dpu_deal_pid
     , history_table.dpu_deal_update_type
     , history_table.dpu_args_json
     , history_table.dpu_create_datetime
     , history_table.dpu_last_attempt_start_datetime
     , history_table.dpu_last_attempt_end_datetime
     , history_table.dpu_completed_datetime
     , history_table.dpu_run_count
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.deal_pending_update history_table
LEFT JOIN staging_octane.deal_pending_update staging_table
          ON staging_table.dpu_pid = history_table.dpu_pid
WHERE staging_table.dpu_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.deal_pending_update deleted_records
    WHERE deleted_records.dpu_pid = history_table.dpu_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100899', 0, '--finding records to insert into history_octane.proposal_review_request_type
SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal_review_request_type staging_table
LEFT JOIN history_octane.proposal_review_request_type history_table
          ON staging_table.code = history_table.code
              AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;', 'Staging DB Connection')
         , ('SP-100898', 0, '--finding records to insert into history_octane.deal_update_type
SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.deal_update_type staging_table
LEFT JOIN history_octane.deal_update_type history_table
          ON staging_table.code = history_table.code
              AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;', 'Staging DB Connection')
         , ('SP-100900', 0, '--finding records to insert into history_octane.wf_step_function_parameters
SELECT staging_table.wsfp_pid
     , staging_table.wsfp_version
     , staging_table.wsfp_wf_step_pid
     , staging_table.wsfp_proposal_review_id
     , staging_table.wsfp_proposal_review_status_type
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.wf_step_function_parameters staging_table
LEFT JOIN history_octane.wf_step_function_parameters history_table
          ON staging_table.wsfp_pid = history_table.wsfp_pid
              AND staging_table.wsfp_version = history_table.wsfp_version
WHERE history_table.wsfp_pid IS NULL
UNION ALL
SELECT history_table.wsfp_pid
     , history_table.wsfp_version + 1
     , history_table.wsfp_wf_step_pid
     , history_table.wsfp_proposal_review_id
     , history_table.wsfp_proposal_review_status_type
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.wf_step_function_parameters history_table
LEFT JOIN staging_octane.wf_step_function_parameters staging_table
          ON staging_table.wsfp_pid = history_table.wsfp_pid
WHERE staging_table.wsfp_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.wf_step_function_parameters deleted_records
    WHERE deleted_records.wsfp_pid = history_table.wsfp_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
)
INSERT
INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
SELECT process.dwid, insert_rows.data_source_dwid, insert_rows.sql, 0, 'N', 'N', 'N', 'N', insert_rows.connectionname::mdi.pentaho_db_connection_name
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--table_output_step
WITH insert_rows (process_name, target_schema, target_table, truncate_table, connectionname) AS (
    VALUES ('SP-100897', 'history_octane', 'deal_pending_update', 'N', 'Staging DB Connection')
         , ('SP-100899', 'history_octane', 'proposal_review_request_type', 'N', 'Staging DB Connection')
         , ('SP-100898', 'history_octane', 'deal_update_type', 'N', 'Staging DB Connection')
         , ('SP-100900', 'history_octane', 'wf_step_function_parameters', 'N', 'Staging DB Connection')
)
INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT process.dwid, insert_rows.target_schema, insert_rows.target_table, 1000, NULL, NULL, NULL, NULL, 'N', NULL, insert_rows.truncate_table::mdi.pentaho_y_or_n, insert_rows.connectionname, 'N', 'Y', 'N', 'N'
FROM insert_rows
JOIN mdi.process
ON process.name = insert_rows.process_name;

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('SP-100897', 'data_source_deleted_flag')
         , ('SP-100897', 'data_source_updated_datetime')
         , ('SP-100897', 'dpu_args_json')
         , ('SP-100897', 'dpu_completed_datetime')
         , ('SP-100897', 'dpu_create_datetime')
         , ('SP-100897', 'dpu_deal_pid')
         , ('SP-100897', 'dpu_deal_update_type')
         , ('SP-100897', 'dpu_last_attempt_end_datetime')
         , ('SP-100897', 'dpu_last_attempt_start_datetime')
         , ('SP-100897', 'dpu_pid')
         , ('SP-100897', 'dpu_run_count')
         , ('SP-100897', 'dpu_version')
         , ('SP-100897', 'etl_batch_id')
         , ('SP-100327', 'prpre_completed_proposal_snapshot_pid')
         , ('SP-100327', 'prpre_create_datetime')
         , ('SP-100327', 'prpre_proposal_review_request_type')
         , ('SP-100327', 'prpre_requested_proposal_snapshot_pid')
         , ('SP-100327', 'prpre_scenario_proposal_name')
         , ('SP-100327', 'prpre_scenario_proposal_pid')
         , ('SP-100049', 'rcp_payer_borrower_seller_editable')
         , ('SP-100049', 'rcp_payer_other_editable')
         , ('SP-100899', 'code')
         , ('SP-100899', 'data_source_deleted_flag')
         , ('SP-100899', 'data_source_updated_datetime')
         , ('SP-100899', 'etl_batch_id')
         , ('SP-100899', 'value')
         , ('SP-100087', 'ds_proposal_review_requested_count')
         , ('SP-100898', 'code')
         , ('SP-100898', 'data_source_deleted_flag')
         , ('SP-100898', 'data_source_updated_datetime')
         , ('SP-100898', 'etl_batch_id')
         , ('SP-100898', 'value')
         , ('SP-100012', 'pl_verified_geocode')
         , ('SP-100900', 'data_source_deleted_flag')
         , ('SP-100900', 'data_source_updated_datetime')
         , ('SP-100900', 'etl_batch_id')
         , ('SP-100900', 'wsfp_pid')
         , ('SP-100900', 'wsfp_proposal_review_id')
         , ('SP-100900', 'wsfp_proposal_review_status_type')
         , ('SP-100900', 'wsfp_version')
         , ('SP-100900', 'wsfp_wf_step_pid')
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
    VALUES ('SP-100897', 'dpu_pid')
         , ('SP-100899', 'code')
         , ('SP-100898', 'code')
         , ('SP-100900', 'wsfp_pid')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
JOIN mdi.process
     ON insert_rows.process_name = process.name;

--state_machine_definition
WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-100897', 'SP-100897', 'ETL to copy deal_pending_update data from staging_octane to history_octane')
         , ('SP-100899', 'SP-100899', 'ETL to copy proposal_review_request_type data from staging_octane to history_octane')
         , ('SP-100898', 'SP-100898', 'ETL to copy deal_update_type data from staging_octane to history_octane')
         , ('SP-100900', 'SP-100900', 'ETL to copy wf_step_function_parameters data from staging_octane to history_octane')
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
WITH update_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'history_octane', 'role_charge_permissions', 'rcp_payer_non_lender_editable', 'BOOLEAN', NULL, NULL, NULL, NULL)
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
    VALUES ('SP-100327', 0, '--finding records to insert into history_octane.proposal_review
SELECT staging_table.prpre_pid
     , staging_table.prpre_version
     , staging_table.prpre_proposal_pid
     , staging_table.prpre_request_id
     , staging_table.prpre_request_datetime
     , staging_table.prpre_request_by_lender_user_pid
     , staging_table.prpre_request_summary
     , staging_table.prpre_proposal_review_status_type
     , staging_table.prpre_decision_datetime
     , staging_table.prpre_decision_by_lender_user_pid
     , staging_table.prpre_decision_summary
     , staging_table.prpre_scenario_proposal_pid
     , staging_table.prpre_scenario_proposal_name
     , staging_table.prpre_requested_proposal_snapshot_pid
     , staging_table.prpre_completed_proposal_snapshot_pid
     , staging_table.prpre_proposal_review_request_type
     , staging_table.prpre_create_datetime
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal_review staging_table
LEFT JOIN history_octane.proposal_review history_table
          ON staging_table.prpre_pid = history_table.prpre_pid
              AND staging_table.prpre_version = history_table.prpre_version
WHERE history_table.prpre_pid IS NULL
UNION ALL
SELECT history_table.prpre_pid
     , history_table.prpre_version + 1
     , history_table.prpre_proposal_pid
     , history_table.prpre_request_id
     , history_table.prpre_request_datetime
     , history_table.prpre_request_by_lender_user_pid
     , history_table.prpre_request_summary
     , history_table.prpre_proposal_review_status_type
     , history_table.prpre_decision_datetime
     , history_table.prpre_decision_by_lender_user_pid
     , history_table.prpre_decision_summary
     , history_table.prpre_scenario_proposal_pid
     , history_table.prpre_scenario_proposal_name
     , history_table.prpre_requested_proposal_snapshot_pid
     , history_table.prpre_completed_proposal_snapshot_pid
     , history_table.prpre_proposal_review_request_type
     , history_table.prpre_create_datetime
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal_review history_table
LEFT JOIN staging_octane.proposal_review staging_table
          ON staging_table.prpre_pid = history_table.prpre_pid
WHERE staging_table.prpre_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.proposal_review deleted_records
    WHERE deleted_records.prpre_pid = history_table.prpre_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100049', 0, '--finding records to insert into history_octane.role_charge_permissions
SELECT staging_table.rcp_pid
     , staging_table.rcp_version
     , staging_table.rcp_role_pid
     , staging_table.rcp_charge_type
     , staging_table.rcp_basic_editable
     , staging_table.rcp_financed_editable
     , staging_table.rcp_payer_borrower_seller_editable
     , staging_table.rcp_payer_lender_editable
     , staging_table.rcp_payee_editable
     , staging_table.rcp_apr_editable
     , staging_table.rcp_poc_editable
     , staging_table.rcp_wire_editable
     , staging_table.rcp_payer_other_editable
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.role_charge_permissions staging_table
LEFT JOIN history_octane.role_charge_permissions history_table
          ON staging_table.rcp_pid = history_table.rcp_pid
              AND staging_table.rcp_version = history_table.rcp_version
WHERE history_table.rcp_pid IS NULL
UNION ALL
SELECT history_table.rcp_pid
     , history_table.rcp_version + 1
     , history_table.rcp_role_pid
     , history_table.rcp_charge_type
     , history_table.rcp_basic_editable
     , history_table.rcp_financed_editable
     , history_table.rcp_payer_borrower_seller_editable
     , history_table.rcp_payer_lender_editable
     , history_table.rcp_payee_editable
     , history_table.rcp_apr_editable
     , history_table.rcp_poc_editable
     , history_table.rcp_wire_editable
     , history_table.rcp_payer_other_editable
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.role_charge_permissions history_table
LEFT JOIN staging_octane.role_charge_permissions staging_table
          ON staging_table.rcp_pid = history_table.rcp_pid
WHERE staging_table.rcp_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.role_charge_permissions deleted_records
    WHERE deleted_records.rcp_pid = history_table.rcp_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100087', 0, '--finding records to insert into history_octane.deal_summary
SELECT staging_table.ds_pid
     , staging_table.ds_version
     , staging_table.ds_deal_pid
     , staging_table.ds_lender_lock_expiration_datetime_main
     , staging_table.ds_lender_lock_expiration_datetime_piggyback
     , staging_table.ds_lender_lock_status_type_main
     , staging_table.ds_lender_lock_status_type_piggyback
     , staging_table.ds_decision_appraisal_condition_type
     , staging_table.ds_funding_status_type_main
     , staging_table.ds_funding_status_type_piggyback
     , staging_table.ds_purchase_advice_date_main
     , staging_table.ds_purchase_advice_date_piggyback
     , staging_table.ds_last_wf_phase_number
     , staging_table.ds_last_wf_phase_name
     , staging_table.ds_eligible_investor_ids_main
     , staging_table.ds_eligible_investor_ids_piggyback
     , staging_table.ds_decision_appraisal_cu_risk_score
     , staging_table.ds_deal_stage_type
     , staging_table.ds_deal_stage_from_datetime
     , staging_table.ds_funded_main
     , staging_table.ds_funded_piggyback
     , staging_table.ds_most_recent_user_update_date
     , staging_table.ds_lock_vintage_date_main
     , staging_table.ds_lock_vintage_date_piggyback
     , staging_table.ds_lender_lock_datetime_main
     , staging_table.ds_lender_lock_datetime_piggyback
     , staging_table.ds_any_unrequested_packages
     , staging_table.ds_proposal_review_requested_count
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.deal_summary staging_table
LEFT JOIN history_octane.deal_summary history_table
          ON staging_table.ds_pid = history_table.ds_pid
              AND staging_table.ds_version = history_table.ds_version
WHERE history_table.ds_pid IS NULL
UNION ALL
SELECT history_table.ds_pid
     , history_table.ds_version + 1
     , history_table.ds_deal_pid
     , history_table.ds_lender_lock_expiration_datetime_main
     , history_table.ds_lender_lock_expiration_datetime_piggyback
     , history_table.ds_lender_lock_status_type_main
     , history_table.ds_lender_lock_status_type_piggyback
     , history_table.ds_decision_appraisal_condition_type
     , history_table.ds_funding_status_type_main
     , history_table.ds_funding_status_type_piggyback
     , history_table.ds_purchase_advice_date_main
     , history_table.ds_purchase_advice_date_piggyback
     , history_table.ds_last_wf_phase_number
     , history_table.ds_last_wf_phase_name
     , history_table.ds_eligible_investor_ids_main
     , history_table.ds_eligible_investor_ids_piggyback
     , history_table.ds_decision_appraisal_cu_risk_score
     , history_table.ds_deal_stage_type
     , history_table.ds_deal_stage_from_datetime
     , history_table.ds_funded_main
     , history_table.ds_funded_piggyback
     , history_table.ds_most_recent_user_update_date
     , history_table.ds_lock_vintage_date_main
     , history_table.ds_lock_vintage_date_piggyback
     , history_table.ds_lender_lock_datetime_main
     , history_table.ds_lender_lock_datetime_piggyback
     , history_table.ds_any_unrequested_packages
     , history_table.ds_proposal_review_requested_count
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.deal_summary history_table
LEFT JOIN staging_octane.deal_summary staging_table
          ON staging_table.ds_pid = history_table.ds_pid
WHERE staging_table.ds_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.deal_summary deleted_records
    WHERE deleted_records.ds_pid = history_table.ds_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100012', 0, '--finding records to insert into history_octane.place
SELECT staging_table.pl_pid
     , staging_table.pl_version
     , staging_table.pl_proposal_pid
     , staging_table.pl_subject_property
     , staging_table.pl_acquisition_date
     , staging_table.pl_financed_units_count
     , staging_table.pl_unit_count
     , staging_table.pl_land_estimated_value_amount
     , staging_table.pl_land_original_cost_amount
     , staging_table.pl_leasehold_expiration_date
     , staging_table.pl_legal_description_type
     , staging_table.pl_legal_description
     , staging_table.pl_property_tax_id
     , staging_table.pl_legal_lot
     , staging_table.pl_legal_block
     , staging_table.pl_legal_section
     , staging_table.pl_project_name
     , staging_table.pl_cpm_project_id
     , staging_table.pl_acquisition_cost_amount
     , staging_table.pl_county_pid
     , staging_table.pl_sub_jurisdiction_name
     , staging_table.pl_recording_district_name
     , staging_table.pl_project_classification_type
     , staging_table.pl_property_category_type
     , staging_table.pl_property_rights_type
     , staging_table.pl_structure_built_year
     , staging_table.pl_structure_built_month
     , staging_table.pl_title_manner_held_type
     , staging_table.pl_title_manner_held_description
     , staging_table.pl_building_status_type
     , staging_table.pl_construction_conversion
     , staging_table.pl_native_american_lands_type
     , staging_table.pl_community_land_trust
     , staging_table.pl_inclusionary_zoning
     , staging_table.pl_unique_dwelling_type
     , staging_table.pl_living_unit_count
     , staging_table.pl_project_design_type
     , staging_table.pl_city
     , staging_table.pl_country
     , staging_table.pl_postal_code
     , staging_table.pl_state
     , staging_table.pl_street1
     , staging_table.pl_street2
     , staging_table.pl_street_tbd
     , staging_table.pl_landlord_first_name
     , staging_table.pl_landlord_last_name
     , staging_table.pl_landlord_middle_name
     , staging_table.pl_landlord_name_suffix
     , staging_table.pl_landlord_company_name
     , staging_table.pl_landlord_title
     , staging_table.pl_landlord_office_phone
     , staging_table.pl_landlord_office_phone_extension
     , staging_table.pl_landlord_mobile_phone
     , staging_table.pl_landlord_email
     , staging_table.pl_landlord_fax
     , staging_table.pl_landlord_city
     , staging_table.pl_landlord_country
     , staging_table.pl_landlord_postal_code
     , staging_table.pl_landlord_state
     , staging_table.pl_landlord_street1
     , staging_table.pl_landlord_street2
     , staging_table.pl_management_first_name
     , staging_table.pl_management_last_name
     , staging_table.pl_management_middle_name
     , staging_table.pl_management_name_suffix
     , staging_table.pl_management_company_name
     , staging_table.pl_management_title
     , staging_table.pl_management_office_phone
     , staging_table.pl_management_office_phone_extension
     , staging_table.pl_management_mobile_phone
     , staging_table.pl_management_email
     , staging_table.pl_management_fax
     , staging_table.pl_management_city
     , staging_table.pl_management_country
     , staging_table.pl_management_postal_code
     , staging_table.pl_management_state
     , staging_table.pl_management_street1
     , staging_table.pl_management_street2
     , staging_table.pl_property_insurance_amount_input_type
     , staging_table.pl_property_tax_amount_input_type
     , staging_table.pl_annual_property_insurance_amount
     , staging_table.pl_annual_property_tax_amount
     , staging_table.pl_monthly_property_insurance_amount
     , staging_table.pl_monthly_hoa_amount
     , staging_table.pl_monthly_mi_amount
     , staging_table.pl_monthly_property_tax_amount
     , staging_table.pl_monthly_lease_ground_rent_amount
     , staging_table.pl_monthly_rent_amount
     , staging_table.pl_monthly_obligation_amount
     , staging_table.pl_use_proposed_property_usage
     , staging_table.pl_property_usage_type
     , staging_table.pl_property_value_amount
     , staging_table.pl_reo_disposition_status_type
     , staging_table.pl_auto_geocode
     , staging_table.pl_auto_geocode_exception
     , staging_table.pl_msa_code
     , staging_table.pl_state_fips
     , staging_table.pl_county_fips
     , staging_table.pl_census_tract
     , staging_table.pl_mh_make
     , staging_table.pl_mh_model
     , staging_table.pl_mh_length
     , staging_table.pl_mh_width
     , staging_table.pl_mh_manufacturer
     , staging_table.pl_mh_serial_number
     , staging_table.pl_mh_hud_label_number
     , staging_table.pl_mh_certificate_of_title_issued
     , staging_table.pl_mh_certificate_of_title_number
     , staging_table.pl_mh_certificate_of_title_type
     , staging_table.pl_mh_loan_purpose_type
     , staging_table.pl_mh_anchored
     , staging_table.pl_coop_company_name
     , staging_table.pl_coop_building_name
     , staging_table.pl_coop_vacant_units
     , staging_table.pl_coop_proprietary_lease_date
     , staging_table.pl_coop_assignment_lease_date
     , staging_table.pl_coop_existing_company_laws_state
     , staging_table.pl_coop_shares_being_purchased
     , staging_table.pl_coop_attorney_in_fact
     , staging_table.pl_coop_stock_certificate_number
     , staging_table.pl_coop_apartment_unit
     , staging_table.pl_rental
     , staging_table.pl_underwriter_comments
     , staging_table.pl_lava_zone_type
     , staging_table.pl_neighborhood_location_type
     , staging_table.pl_site_area
     , staging_table.pl_hud_reo
     , staging_table.pl_va_guaranteed_reo
     , staging_table.pl_va_loan_date
     , staging_table.pl_gross_building_area_square_feet
     , staging_table.pl_project_dwelling_units_sold_count
     , staging_table.pl_prior_owners_title
     , staging_table.pl_prior_owners_title_policy_amount
     , staging_table.pl_prior_owners_title_policy_effective_date
     , staging_table.pl_prior_lenders_title
     , staging_table.pl_prior_lenders_title_policy_amount
     , staging_table.pl_prior_lenders_title_policy_effective_date
     , staging_table.pl_bedroom_count_unit_1
     , staging_table.pl_bedroom_count_unit_2
     , staging_table.pl_bedroom_count_unit_3
     , staging_table.pl_bedroom_count_unit_4
     , staging_table.pl_rent_amount_unit_1
     , staging_table.pl_rent_amount_unit_2
     , staging_table.pl_rent_amount_unit_3
     , staging_table.pl_rent_amount_unit_4
     , staging_table.pl_listed_for_sale_in_last_6_months
     , staging_table.pl_property_in_borrower_trust
     , staging_table.pl_road_type
     , staging_table.pl_water_type
     , staging_table.pl_sanitation_type
     , staging_table.pl_survey_required
     , staging_table.pl_solar_panels_type
     , staging_table.pl_power_purchase_agreement
     , staging_table.pl_solar_panel_provider_name
     , staging_table.pl_seller_acquired_date
     , staging_table.pl_seller_original_cost_amount
     , staging_table.pl_remaining_economic_life_years
     , staging_table.pl_bathroom_count_unit_1
     , staging_table.pl_bathroom_count_unit_2
     , staging_table.pl_bathroom_count_unit_3
     , staging_table.pl_bathroom_count_unit_4
     , staging_table.pl_total_room_count_unit_1
     , staging_table.pl_total_room_count_unit_2
     , staging_table.pl_total_room_count_unit_3
     , staging_table.pl_total_room_count_unit_4
     , staging_table.pl_gross_living_area_square_feet_unit_1
     , staging_table.pl_gross_living_area_square_feet_unit_2
     , staging_table.pl_gross_living_area_square_feet_unit_3
     , staging_table.pl_gross_living_area_square_feet_unit_4
     , staging_table.pl_mh_leasehold__property_interest_type
     , staging_table.pl_tribe_name
     , staging_table.pl_leasehold_begin_date
     , staging_table.pl_lease_number
     , staging_table.pl_property_inspection_required
     , staging_table.pl_hvac_inspection_required
     , staging_table.pl_pest_inspection_required
     , staging_table.pl_radon_inspection_required
     , staging_table.pl_septic_inspection_required
     , staging_table.pl_water_well_inspection_required
     , staging_table.pl_structural_inspection_required
     , staging_table.pl_pest_inspection_required_auto_compute
     , staging_table.pl_management_agent_federal_tax_id
     , staging_table.pl_mh_manufacturer_street_1
     , staging_table.pl_mh_manufacturer_street_2
     , staging_table.pl_mh_manufacturer_city
     , staging_table.pl_mh_manufacturer_state
     , staging_table.pl_mh_manufacturer_postal_code
     , staging_table.pl_mh_manufacturer_phone
     , staging_table.pl_mh_manufacturer_phone_extension
     , staging_table.pl_recording_city_name
     , staging_table.pl_abbreviated_legal_description
     , staging_table.pl_geocode_service_disabled
     , staging_table.pl_vesting_confirmed
     , staging_table.pl_previous_title_manner_held_description
     , staging_table.pl_legal_lot_na
     , staging_table.pl_legal_block_na
     , staging_table.pl_legal_section_na
     , staging_table.pl_legal_description_confirmed
     , staging_table.pl_lead_inspection_required
     , staging_table.pl_calculated_lead_inspection_required
     , staging_table.pl_geocode_system_error
     , staging_table.pl_mixed_use
     , staging_table.pl_mixed_use_verified
     , staging_table.pl_mixed_use_area_square_feet
     , staging_table.pl_mixed_use_area_square_feet_verified
     , staging_table.pl_mixed_use_area_percent
     , staging_table.pl_trust_classification_type
     , staging_table.pl_additional_building_area_square_feet
     , staging_table.pl_acquisition_date_verified
     , staging_table.pl_acquisition_cost_amount_verified
     , staging_table.pl_property_tax_id_verified
     , staging_table.pl_seller_acquired_date_verified
     , staging_table.pl_seller_original_cost_amount_verified
     , staging_table.pl_snapshotted_pid
     , staging_table.pl_verified_geocode
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.place staging_table
LEFT JOIN history_octane.place history_table
          ON staging_table.pl_pid = history_table.pl_pid
              AND staging_table.pl_version = history_table.pl_version
WHERE history_table.pl_pid IS NULL
UNION ALL
SELECT history_table.pl_pid
     , history_table.pl_version + 1
     , history_table.pl_proposal_pid
     , history_table.pl_subject_property
     , history_table.pl_acquisition_date
     , history_table.pl_financed_units_count
     , history_table.pl_unit_count
     , history_table.pl_land_estimated_value_amount
     , history_table.pl_land_original_cost_amount
     , history_table.pl_leasehold_expiration_date
     , history_table.pl_legal_description_type
     , history_table.pl_legal_description
     , history_table.pl_property_tax_id
     , history_table.pl_legal_lot
     , history_table.pl_legal_block
     , history_table.pl_legal_section
     , history_table.pl_project_name
     , history_table.pl_cpm_project_id
     , history_table.pl_acquisition_cost_amount
     , history_table.pl_county_pid
     , history_table.pl_sub_jurisdiction_name
     , history_table.pl_recording_district_name
     , history_table.pl_project_classification_type
     , history_table.pl_property_category_type
     , history_table.pl_property_rights_type
     , history_table.pl_structure_built_year
     , history_table.pl_structure_built_month
     , history_table.pl_title_manner_held_type
     , history_table.pl_title_manner_held_description
     , history_table.pl_building_status_type
     , history_table.pl_construction_conversion
     , history_table.pl_native_american_lands_type
     , history_table.pl_community_land_trust
     , history_table.pl_inclusionary_zoning
     , history_table.pl_unique_dwelling_type
     , history_table.pl_living_unit_count
     , history_table.pl_project_design_type
     , history_table.pl_city
     , history_table.pl_country
     , history_table.pl_postal_code
     , history_table.pl_state
     , history_table.pl_street1
     , history_table.pl_street2
     , history_table.pl_street_tbd
     , history_table.pl_landlord_first_name
     , history_table.pl_landlord_last_name
     , history_table.pl_landlord_middle_name
     , history_table.pl_landlord_name_suffix
     , history_table.pl_landlord_company_name
     , history_table.pl_landlord_title
     , history_table.pl_landlord_office_phone
     , history_table.pl_landlord_office_phone_extension
     , history_table.pl_landlord_mobile_phone
     , history_table.pl_landlord_email
     , history_table.pl_landlord_fax
     , history_table.pl_landlord_city
     , history_table.pl_landlord_country
     , history_table.pl_landlord_postal_code
     , history_table.pl_landlord_state
     , history_table.pl_landlord_street1
     , history_table.pl_landlord_street2
     , history_table.pl_management_first_name
     , history_table.pl_management_last_name
     , history_table.pl_management_middle_name
     , history_table.pl_management_name_suffix
     , history_table.pl_management_company_name
     , history_table.pl_management_title
     , history_table.pl_management_office_phone
     , history_table.pl_management_office_phone_extension
     , history_table.pl_management_mobile_phone
     , history_table.pl_management_email
     , history_table.pl_management_fax
     , history_table.pl_management_city
     , history_table.pl_management_country
     , history_table.pl_management_postal_code
     , history_table.pl_management_state
     , history_table.pl_management_street1
     , history_table.pl_management_street2
     , history_table.pl_property_insurance_amount_input_type
     , history_table.pl_property_tax_amount_input_type
     , history_table.pl_annual_property_insurance_amount
     , history_table.pl_annual_property_tax_amount
     , history_table.pl_monthly_property_insurance_amount
     , history_table.pl_monthly_hoa_amount
     , history_table.pl_monthly_mi_amount
     , history_table.pl_monthly_property_tax_amount
     , history_table.pl_monthly_lease_ground_rent_amount
     , history_table.pl_monthly_rent_amount
     , history_table.pl_monthly_obligation_amount
     , history_table.pl_use_proposed_property_usage
     , history_table.pl_property_usage_type
     , history_table.pl_property_value_amount
     , history_table.pl_reo_disposition_status_type
     , history_table.pl_auto_geocode
     , history_table.pl_auto_geocode_exception
     , history_table.pl_msa_code
     , history_table.pl_state_fips
     , history_table.pl_county_fips
     , history_table.pl_census_tract
     , history_table.pl_mh_make
     , history_table.pl_mh_model
     , history_table.pl_mh_length
     , history_table.pl_mh_width
     , history_table.pl_mh_manufacturer
     , history_table.pl_mh_serial_number
     , history_table.pl_mh_hud_label_number
     , history_table.pl_mh_certificate_of_title_issued
     , history_table.pl_mh_certificate_of_title_number
     , history_table.pl_mh_certificate_of_title_type
     , history_table.pl_mh_loan_purpose_type
     , history_table.pl_mh_anchored
     , history_table.pl_coop_company_name
     , history_table.pl_coop_building_name
     , history_table.pl_coop_vacant_units
     , history_table.pl_coop_proprietary_lease_date
     , history_table.pl_coop_assignment_lease_date
     , history_table.pl_coop_existing_company_laws_state
     , history_table.pl_coop_shares_being_purchased
     , history_table.pl_coop_attorney_in_fact
     , history_table.pl_coop_stock_certificate_number
     , history_table.pl_coop_apartment_unit
     , history_table.pl_rental
     , history_table.pl_underwriter_comments
     , history_table.pl_lava_zone_type
     , history_table.pl_neighborhood_location_type
     , history_table.pl_site_area
     , history_table.pl_hud_reo
     , history_table.pl_va_guaranteed_reo
     , history_table.pl_va_loan_date
     , history_table.pl_gross_building_area_square_feet
     , history_table.pl_project_dwelling_units_sold_count
     , history_table.pl_prior_owners_title
     , history_table.pl_prior_owners_title_policy_amount
     , history_table.pl_prior_owners_title_policy_effective_date
     , history_table.pl_prior_lenders_title
     , history_table.pl_prior_lenders_title_policy_amount
     , history_table.pl_prior_lenders_title_policy_effective_date
     , history_table.pl_bedroom_count_unit_1
     , history_table.pl_bedroom_count_unit_2
     , history_table.pl_bedroom_count_unit_3
     , history_table.pl_bedroom_count_unit_4
     , history_table.pl_rent_amount_unit_1
     , history_table.pl_rent_amount_unit_2
     , history_table.pl_rent_amount_unit_3
     , history_table.pl_rent_amount_unit_4
     , history_table.pl_listed_for_sale_in_last_6_months
     , history_table.pl_property_in_borrower_trust
     , history_table.pl_road_type
     , history_table.pl_water_type
     , history_table.pl_sanitation_type
     , history_table.pl_survey_required
     , history_table.pl_solar_panels_type
     , history_table.pl_power_purchase_agreement
     , history_table.pl_solar_panel_provider_name
     , history_table.pl_seller_acquired_date
     , history_table.pl_seller_original_cost_amount
     , history_table.pl_remaining_economic_life_years
     , history_table.pl_bathroom_count_unit_1
     , history_table.pl_bathroom_count_unit_2
     , history_table.pl_bathroom_count_unit_3
     , history_table.pl_bathroom_count_unit_4
     , history_table.pl_total_room_count_unit_1
     , history_table.pl_total_room_count_unit_2
     , history_table.pl_total_room_count_unit_3
     , history_table.pl_total_room_count_unit_4
     , history_table.pl_gross_living_area_square_feet_unit_1
     , history_table.pl_gross_living_area_square_feet_unit_2
     , history_table.pl_gross_living_area_square_feet_unit_3
     , history_table.pl_gross_living_area_square_feet_unit_4
     , history_table.pl_mh_leasehold__property_interest_type
     , history_table.pl_tribe_name
     , history_table.pl_leasehold_begin_date
     , history_table.pl_lease_number
     , history_table.pl_property_inspection_required
     , history_table.pl_hvac_inspection_required
     , history_table.pl_pest_inspection_required
     , history_table.pl_radon_inspection_required
     , history_table.pl_septic_inspection_required
     , history_table.pl_water_well_inspection_required
     , history_table.pl_structural_inspection_required
     , history_table.pl_pest_inspection_required_auto_compute
     , history_table.pl_management_agent_federal_tax_id
     , history_table.pl_mh_manufacturer_street_1
     , history_table.pl_mh_manufacturer_street_2
     , history_table.pl_mh_manufacturer_city
     , history_table.pl_mh_manufacturer_state
     , history_table.pl_mh_manufacturer_postal_code
     , history_table.pl_mh_manufacturer_phone
     , history_table.pl_mh_manufacturer_phone_extension
     , history_table.pl_recording_city_name
     , history_table.pl_abbreviated_legal_description
     , history_table.pl_geocode_service_disabled
     , history_table.pl_vesting_confirmed
     , history_table.pl_previous_title_manner_held_description
     , history_table.pl_legal_lot_na
     , history_table.pl_legal_block_na
     , history_table.pl_legal_section_na
     , history_table.pl_legal_description_confirmed
     , history_table.pl_lead_inspection_required
     , history_table.pl_calculated_lead_inspection_required
     , history_table.pl_geocode_system_error
     , history_table.pl_mixed_use
     , history_table.pl_mixed_use_verified
     , history_table.pl_mixed_use_area_square_feet
     , history_table.pl_mixed_use_area_square_feet_verified
     , history_table.pl_mixed_use_area_percent
     , history_table.pl_trust_classification_type
     , history_table.pl_additional_building_area_square_feet
     , history_table.pl_acquisition_date_verified
     , history_table.pl_acquisition_cost_amount_verified
     , history_table.pl_property_tax_id_verified
     , history_table.pl_seller_acquired_date_verified
     , history_table.pl_seller_original_cost_amount_verified
     , history_table.pl_snapshotted_pid
     , history_table.pl_verified_geocode
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.place history_table
LEFT JOIN staging_octane.place staging_table
          ON staging_table.pl_pid = history_table.pl_pid
WHERE staging_table.pl_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.place deleted_records
    WHERE deleted_records.pl_pid = history_table.pl_pid
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

--table_output_field
WITH delete_keys (process_name, database_field_name) AS (
    VALUES ('SP-100049', 'rcp_payer_non_lender_editable')
)
DELETE
FROM mdi.table_output_field
    USING delete_keys, mdi.process, mdi.table_output_step
WHERE delete_keys.process_name = process.name
  AND process.dwid = table_output_step.process_dwid
  AND table_output_step.dwid = table_output_field.table_output_step_dwid
  AND delete_keys.database_field_name = table_output_field.database_field_name;

--edw_field_definition
WITH delete_keys (database_name, schema_name, table_name, field_name) AS (
    VALUES ('staging', 'staging_octane', 'role_charge_permissions', 'rcp_payer_non_lender_editable')
)
DELETE
FROM mdi.edw_field_definition
    USING delete_keys, mdi.edw_table_definition
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name
  AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = delete_keys.field_name;
