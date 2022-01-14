--
-- Main | EDW - Octane schemas from prod-release to uat (2022-01-14)
-- https://app.asana.com/0/0/1201641184457748
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'staging_octane', 'ignored_mortech_add_on', NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'ignored_mortech_add_on', 'staging', 'staging_octane', 'ignored_mortech_add_on')
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
    VALUES ('staging', 'history_octane', 'ignored_mortech_add_on', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'ignored_mortech_add_on', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'ignored_mortech_add_on', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_user_location', 'luloc_current_licensed_location', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_user_location', 'luloc_synthetic_unique_current_licensed_location', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal', 'd_location_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'ignored_mortech_add_on', 'ima_account_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'ignored_mortech_add_on', 'ima_add_on_name', 'VARCHAR(16000)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'ignored_mortech_add_on', 'ima_notes', 'VARCHAR(16000)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'ignored_mortech_add_on', 'ima_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'ignored_mortech_add_on', 'ima_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_doc', 'prpd_prior_to_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_doc', 'prpd_prior_to_type_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_doc', 'prpd_prior_to_type_unparsed_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_doc', 'prpd_provider_type_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_doc', 'prpd_provider_type_unparsed_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_doc', 'prpd_smart_doc_prior_to_type_case_criteria_html', 'VARCHAR(16000)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_doc', 'prpd_smart_doc_prior_to_type_case_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_doc', 'prpd_smart_doc_provider_type_case_criteria_html', 'VARCHAR(16000)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_doc', 'prpd_smart_doc_provider_type_case_pid', 'BIGINT', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'lender_user_location', 'luloc_current_licensed_location', 'BOOLEAN', 'staging', 'staging_octane', 'lender_user_location', 'luloc_current_licensed_location')
         , ('staging', 'history_octane', 'lender_user_location', 'luloc_synthetic_unique_current_licensed_location', 'BOOLEAN', 'staging', 'staging_octane', 'lender_user_location', 'luloc_synthetic_unique_current_licensed_location')
         , ('staging', 'history_octane', 'deal', 'd_location_pid', 'BIGINT', 'staging', 'staging_octane', 'deal', 'd_location_pid')
         , ('staging', 'history_octane', 'ignored_mortech_add_on', 'ima_account_pid', 'BIGINT', 'staging', 'staging_octane', 'ignored_mortech_add_on', 'ima_account_pid')
         , ('staging', 'history_octane', 'ignored_mortech_add_on', 'ima_add_on_name', 'VARCHAR(16000)', 'staging', 'staging_octane', 'ignored_mortech_add_on', 'ima_add_on_name')
         , ('staging', 'history_octane', 'ignored_mortech_add_on', 'ima_notes', 'VARCHAR(16000)', 'staging', 'staging_octane', 'ignored_mortech_add_on', 'ima_notes')
         , ('staging', 'history_octane', 'ignored_mortech_add_on', 'ima_pid', 'BIGINT', 'staging', 'staging_octane', 'ignored_mortech_add_on', 'ima_pid')
         , ('staging', 'history_octane', 'ignored_mortech_add_on', 'ima_version', 'INTEGER', 'staging', 'staging_octane', 'ignored_mortech_add_on', 'ima_version')
         , ('staging', 'history_octane', 'proposal_doc', 'prpd_prior_to_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'proposal_doc', 'prpd_prior_to_type')
         , ('staging', 'history_octane', 'proposal_doc', 'prpd_prior_to_type_datetime', 'TIMESTAMP', 'staging', 'staging_octane', 'proposal_doc', 'prpd_prior_to_type_datetime')
         , ('staging', 'history_octane', 'proposal_doc', 'prpd_prior_to_type_unparsed_name', 'VARCHAR(128)', 'staging', 'staging_octane', 'proposal_doc', 'prpd_prior_to_type_unparsed_name')
         , ('staging', 'history_octane', 'proposal_doc', 'prpd_provider_type_datetime', 'TIMESTAMP', 'staging', 'staging_octane', 'proposal_doc', 'prpd_provider_type_datetime')
         , ('staging', 'history_octane', 'proposal_doc', 'prpd_provider_type_unparsed_name', 'VARCHAR(128)', 'staging', 'staging_octane', 'proposal_doc', 'prpd_provider_type_unparsed_name')
         , ('staging', 'history_octane', 'proposal_doc', 'prpd_smart_doc_prior_to_type_case_criteria_html', 'VARCHAR(16000)', 'staging', 'staging_octane', 'proposal_doc', 'prpd_smart_doc_prior_to_type_case_criteria_html')
         , ('staging', 'history_octane', 'proposal_doc', 'prpd_smart_doc_prior_to_type_case_pid', 'BIGINT', 'staging', 'staging_octane', 'proposal_doc', 'prpd_smart_doc_prior_to_type_case_pid')
         , ('staging', 'history_octane', 'proposal_doc', 'prpd_smart_doc_provider_type_case_criteria_html', 'VARCHAR(16000)', 'staging', 'staging_octane', 'proposal_doc', 'prpd_smart_doc_provider_type_case_criteria_html')
         , ('staging', 'history_octane', 'proposal_doc', 'prpd_smart_doc_provider_type_case_pid', 'BIGINT', 'staging', 'staging_octane', 'proposal_doc', 'prpd_smart_doc_provider_type_case_pid')
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
VALUES ('SP-100887', 'ETL to copy ignored_mortech_add_on data from staging_octane to history_octane');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100887', 0, '--finding records to insert into history_octane.ignored_mortech_add_on
SELECT staging_table.ima_pid
     , staging_table.ima_version
     , staging_table.ima_account_pid
     , staging_table.ima_add_on_name
     , staging_table.ima_notes
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.ignored_mortech_add_on staging_table
LEFT JOIN history_octane.ignored_mortech_add_on history_table
          ON staging_table.ima_pid = history_table.ima_pid
              AND staging_table.ima_version = history_table.ima_version
WHERE history_table.ima_pid IS NULL
UNION ALL
SELECT history_table.ima_pid
     , history_table.ima_version + 1
     , history_table.ima_account_pid
     , history_table.ima_add_on_name
     , history_table.ima_notes
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.ignored_mortech_add_on history_table
LEFT JOIN staging_octane.ignored_mortech_add_on staging_table
          ON staging_table.ima_pid = history_table.ima_pid
WHERE staging_table.ima_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.ignored_mortech_add_on deleted_records
    WHERE deleted_records.ima_pid = history_table.ima_pid
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
    VALUES ('SP-100887', 'history_octane', 'ignored_mortech_add_on', 'N', 'Staging DB Connection')
)
INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT process.dwid, insert_rows.target_schema, insert_rows.target_table, 1000, NULL, NULL, NULL, NULL, 'N', NULL, insert_rows.truncate_table::mdi.pentaho_y_or_n, insert_rows.connectionname, 'N', 'Y', 'N', 'N'
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('SP-100855', 'luloc_current_licensed_location')
         , ('SP-100855', 'luloc_synthetic_unique_current_licensed_location')
         , ('SP-100267', 'd_location_pid')
         , ('SP-100887', 'data_source_deleted_flag')
         , ('SP-100887', 'data_source_updated_datetime')
         , ('SP-100887', 'etl_batch_id')
         , ('SP-100887', 'ima_account_pid')
         , ('SP-100887', 'ima_add_on_name')
         , ('SP-100887', 'ima_notes')
         , ('SP-100887', 'ima_pid')
         , ('SP-100887', 'ima_version')
         , ('SP-100350', 'prpd_prior_to_type')
         , ('SP-100350', 'prpd_prior_to_type_datetime')
         , ('SP-100350', 'prpd_prior_to_type_unparsed_name')
         , ('SP-100350', 'prpd_provider_type_datetime')
         , ('SP-100350', 'prpd_provider_type_unparsed_name')
         , ('SP-100350', 'prpd_smart_doc_prior_to_type_case_criteria_html')
         , ('SP-100350', 'prpd_smart_doc_prior_to_type_case_pid')
         , ('SP-100350', 'prpd_smart_doc_provider_type_case_criteria_html')
         , ('SP-100350', 'prpd_smart_doc_provider_type_case_pid')
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
    VALUES ('SP-100887', 'ima_pid')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
JOIN mdi.process
     ON insert_rows.process_name = process.name;

--state_machine_definition
WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-100887', 'SP-100887', 'ETL to copy ignored_mortech_add_on data from staging_octane to history_octane')
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

--table_input_step
WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100855', 0, '--finding records to insert into history_octane.lender_user_location
SELECT staging_table.luloc_pid
     , staging_table.luloc_version
     , staging_table.luloc_company_pid
     , staging_table.luloc_lender_user_pid
     , staging_table.luloc_location_pid
     , staging_table.luloc_from_date
     , staging_table.luloc_lender_user_location_type
     , staging_table.luloc_workspace_type
     , staging_table.luloc_workspace_code
     , staging_table.luloc_current_physical_location
     , staging_table.luloc_current_licensed_location
     , staging_table.luloc_synthetic_unique_current_physical_location
     , staging_table.luloc_synthetic_unique_current_licensed_location
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.lender_user_location staging_table
LEFT JOIN history_octane.lender_user_location history_table
          ON staging_table.luloc_pid = history_table.luloc_pid
              AND staging_table.luloc_version = history_table.luloc_version
WHERE history_table.luloc_pid IS NULL
UNION ALL
SELECT history_table.luloc_pid
     , history_table.luloc_version + 1
     , history_table.luloc_company_pid
     , history_table.luloc_lender_user_pid
     , history_table.luloc_location_pid
     , history_table.luloc_from_date
     , history_table.luloc_lender_user_location_type
     , history_table.luloc_workspace_type
     , history_table.luloc_workspace_code
     , history_table.luloc_current_physical_location
     , history_table.luloc_current_licensed_location
     , history_table.luloc_synthetic_unique_current_physical_location
     , history_table.luloc_synthetic_unique_current_licensed_location
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.lender_user_location history_table
LEFT JOIN staging_octane.lender_user_location staging_table
          ON staging_table.luloc_pid = history_table.luloc_pid
WHERE staging_table.luloc_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.lender_user_location deleted_records
    WHERE deleted_records.luloc_pid = history_table.luloc_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100267', 0, '--finding records to insert into history_octane.deal
SELECT staging_table.d_pid
     , staging_table.d_version
     , staging_table.d_account_pid
     , staging_table.d_company_pid
     , staging_table.d_active_proposal_pid
     , staging_table.d_branch_pid
     , staging_table.d_deal_create_date
     , staging_table.d_deal_status_type
     , staging_table.d_velocify_lead_id
     , staging_table.d_lead_zillow_zq
     , staging_table.d_lead_tracking_id
     , staging_table.d_lead_reference_id
     , staging_table.d_los_loan_id_main
     , staging_table.d_los_loan_id_piggyback
     , staging_table.d_mers_min_main
     , staging_table.d_mers_min_piggyback
     , staging_table.d_external_loan_id_main
     , staging_table.d_external_loan_id_piggyback
     , staging_table.d_lead_source_pid
     , staging_table.d_disclosure_mode_date
     , staging_table.d_deal_status_date
     , staging_table.d_sap_deal
     , staging_table.d_hmda_action_date
     , staging_table.d_hmda_action_type
     , staging_table.d_hmda_denial_reason_type_1
     , staging_table.d_hmda_denial_reason_type_2
     , staging_table.d_hmda_denial_reason_type_3
     , staging_table.d_hmda_denial_reason_type_4
     , staging_table.d_borrower_esign
     , staging_table.d_application_type
     , staging_table.d_welcome_call_datetime
     , staging_table.d_realty_agent_scenario_type
     , staging_table.d_test_loan
     , staging_table.d_charges_enabled_date
     , staging_table.d_credit_bureau_type
     , staging_table.d_performer_team_pid
     , staging_table.d_deal_create_type
     , staging_table.d_hmda_denial_reason_other_description
     , staging_table.d_effective_hmda_action_date
     , staging_table.d_copy_source_los_loan_id_main
     , staging_table.d_copy_source_los_loan_id_piggyback
     , staging_table.d_referred_by_name
     , staging_table.d_hmda_universal_loan_id_main
     , staging_table.d_hmda_universal_loan_id_piggyback
     , staging_table.d_calyx_loan_guid
     , staging_table.d_invoices_enabled_date
     , staging_table.d_invoices_enabled
     , staging_table.d_training_loan
     , staging_table.d_deal_orphan_status_type
     , staging_table.d_deal_orphan_earliest_check_date
     , staging_table.d_deal_create_date_time
     , staging_table.d_early_wire_request
     , staging_table.d_enable_electronic_transaction
     , staging_table.d_initial_cancel_status_date
     , staging_table.d_location_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.deal staging_table
LEFT JOIN history_octane.deal history_table
          ON staging_table.d_pid = history_table.d_pid
              AND staging_table.d_version = history_table.d_version
WHERE history_table.d_pid IS NULL
UNION ALL
SELECT history_table.d_pid
     , history_table.d_version + 1
     , history_table.d_account_pid
     , history_table.d_company_pid
     , history_table.d_active_proposal_pid
     , history_table.d_branch_pid
     , history_table.d_deal_create_date
     , history_table.d_deal_status_type
     , history_table.d_velocify_lead_id
     , history_table.d_lead_zillow_zq
     , history_table.d_lead_tracking_id
     , history_table.d_lead_reference_id
     , history_table.d_los_loan_id_main
     , history_table.d_los_loan_id_piggyback
     , history_table.d_mers_min_main
     , history_table.d_mers_min_piggyback
     , history_table.d_external_loan_id_main
     , history_table.d_external_loan_id_piggyback
     , history_table.d_lead_source_pid
     , history_table.d_disclosure_mode_date
     , history_table.d_deal_status_date
     , history_table.d_sap_deal
     , history_table.d_hmda_action_date
     , history_table.d_hmda_action_type
     , history_table.d_hmda_denial_reason_type_1
     , history_table.d_hmda_denial_reason_type_2
     , history_table.d_hmda_denial_reason_type_3
     , history_table.d_hmda_denial_reason_type_4
     , history_table.d_borrower_esign
     , history_table.d_application_type
     , history_table.d_welcome_call_datetime
     , history_table.d_realty_agent_scenario_type
     , history_table.d_test_loan
     , history_table.d_charges_enabled_date
     , history_table.d_credit_bureau_type
     , history_table.d_performer_team_pid
     , history_table.d_deal_create_type
     , history_table.d_hmda_denial_reason_other_description
     , history_table.d_effective_hmda_action_date
     , history_table.d_copy_source_los_loan_id_main
     , history_table.d_copy_source_los_loan_id_piggyback
     , history_table.d_referred_by_name
     , history_table.d_hmda_universal_loan_id_main
     , history_table.d_hmda_universal_loan_id_piggyback
     , history_table.d_calyx_loan_guid
     , history_table.d_invoices_enabled_date
     , history_table.d_invoices_enabled
     , history_table.d_training_loan
     , history_table.d_deal_orphan_status_type
     , history_table.d_deal_orphan_earliest_check_date
     , history_table.d_deal_create_date_time
     , history_table.d_early_wire_request
     , history_table.d_enable_electronic_transaction
     , history_table.d_initial_cancel_status_date
     , history_table.d_location_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.deal history_table
LEFT JOIN staging_octane.deal staging_table
          ON staging_table.d_pid = history_table.d_pid
WHERE staging_table.d_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.deal deleted_records
    WHERE deleted_records.d_pid = history_table.d_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100350', 0, '--finding records to insert into history_octane.proposal_doc
SELECT staging_table.prpd_pid
     , staging_table.prpd_version
     , staging_table.prpd_doc_name
     , staging_table.prpd_doc_number
     , staging_table.prpd_borrower_access
     , staging_table.prpd_deal_child_type
     , staging_table.prpd_deal_child_name
     , staging_table.prpd_deal_pid
     , staging_table.prpd_proposal_pid
     , staging_table.prpd_loan_pid
     , staging_table.prpd_borrower_pid
     , staging_table.prpd_borrower_income_pid
     , staging_table.prpd_job_income_pid
     , staging_table.prpd_borrower_job_gap_pid
     , staging_table.prpd_other_income_pid
     , staging_table.prpd_business_income_pid
     , staging_table.prpd_rental_income_pid
     , staging_table.prpd_asset_pid
     , staging_table.prpd_asset_large_deposit_pid
     , staging_table.prpd_liability_pid
     , staging_table.prpd_reo_place_pid
     , staging_table.prpd_property_place_pid
     , staging_table.prpd_residence_place_pid
     , staging_table.prpd_borrower_residence_pid
     , staging_table.prpd_application_pid
     , staging_table.prpd_credit_inquiry_pid
     , staging_table.prpd_appraisal_pid
     , staging_table.prpd_appraisal_form_pid
     , staging_table.prpd_tax_transcript_request_pid
     , staging_table.prpd_trash
     , staging_table.prpd_smart_doc_pid
     , staging_table.prpd_proposal_doc_set_pid
     , staging_table.prpd_doc_fulfill_status_type
     , staging_table.prpd_status_unparsed_name
     , staging_table.prpd_status_datetime
     , staging_table.prpd_status_reason
     , staging_table.prpd_doc_excluded
     , staging_table.prpd_doc_excluded_reason
     , staging_table.prpd_doc_excluded_unparsed_name
     , staging_table.prpd_doc_excluded_datetime
     , staging_table.prpd_doc_approval_type
     , staging_table.prpd_borrower_edit
     , staging_table.prpd_borrower_associated_address_pid
     , staging_table.prpd_construction_cost_pid
     , staging_table.prpd_construction_draw_pid
     , staging_table.prpd_proposal_contractor_pid
     , staging_table.prpd_doc_provider_group_type
     , staging_table.prpd_doc_req_fulfill_status_type
     , staging_table.prpd_doc_req_decision_status_type
     , staging_table.prpd_doc_status_type
     , staging_table.prpd_proposal_review_pid
     , staging_table.prpd_prior_to_type
     , staging_table.prpd_prior_to_type_unparsed_name
     , staging_table.prpd_prior_to_type_datetime
     , staging_table.prpd_smart_doc_prior_to_type_case_pid
     , staging_table.prpd_smart_doc_prior_to_type_case_criteria_html
     , staging_table.prpd_provider_type_unparsed_name
     , staging_table.prpd_provider_type_datetime
     , staging_table.prpd_smart_doc_provider_type_case_pid
     , staging_table.prpd_smart_doc_provider_type_case_criteria_html
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal_doc staging_table
LEFT JOIN history_octane.proposal_doc history_table
          ON staging_table.prpd_pid = history_table.prpd_pid
              AND staging_table.prpd_version = history_table.prpd_version
WHERE history_table.prpd_pid IS NULL
UNION ALL
SELECT history_table.prpd_pid
     , history_table.prpd_version + 1
     , history_table.prpd_doc_name
     , history_table.prpd_doc_number
     , history_table.prpd_borrower_access
     , history_table.prpd_deal_child_type
     , history_table.prpd_deal_child_name
     , history_table.prpd_deal_pid
     , history_table.prpd_proposal_pid
     , history_table.prpd_loan_pid
     , history_table.prpd_borrower_pid
     , history_table.prpd_borrower_income_pid
     , history_table.prpd_job_income_pid
     , history_table.prpd_borrower_job_gap_pid
     , history_table.prpd_other_income_pid
     , history_table.prpd_business_income_pid
     , history_table.prpd_rental_income_pid
     , history_table.prpd_asset_pid
     , history_table.prpd_asset_large_deposit_pid
     , history_table.prpd_liability_pid
     , history_table.prpd_reo_place_pid
     , history_table.prpd_property_place_pid
     , history_table.prpd_residence_place_pid
     , history_table.prpd_borrower_residence_pid
     , history_table.prpd_application_pid
     , history_table.prpd_credit_inquiry_pid
     , history_table.prpd_appraisal_pid
     , history_table.prpd_appraisal_form_pid
     , history_table.prpd_tax_transcript_request_pid
     , history_table.prpd_trash
     , history_table.prpd_smart_doc_pid
     , history_table.prpd_proposal_doc_set_pid
     , history_table.prpd_doc_fulfill_status_type
     , history_table.prpd_status_unparsed_name
     , history_table.prpd_status_datetime
     , history_table.prpd_status_reason
     , history_table.prpd_doc_excluded
     , history_table.prpd_doc_excluded_reason
     , history_table.prpd_doc_excluded_unparsed_name
     , history_table.prpd_doc_excluded_datetime
     , history_table.prpd_doc_approval_type
     , history_table.prpd_borrower_edit
     , history_table.prpd_borrower_associated_address_pid
     , history_table.prpd_construction_cost_pid
     , history_table.prpd_construction_draw_pid
     , history_table.prpd_proposal_contractor_pid
     , history_table.prpd_doc_provider_group_type
     , history_table.prpd_doc_req_fulfill_status_type
     , history_table.prpd_doc_req_decision_status_type
     , history_table.prpd_doc_status_type
     , history_table.prpd_proposal_review_pid
     , history_table.prpd_prior_to_type
     , history_table.prpd_prior_to_type_unparsed_name
     , history_table.prpd_prior_to_type_datetime
     , history_table.prpd_smart_doc_prior_to_type_case_pid
     , history_table.prpd_smart_doc_prior_to_type_case_criteria_html
     , history_table.prpd_provider_type_unparsed_name
     , history_table.prpd_provider_type_datetime
     , history_table.prpd_smart_doc_provider_type_case_pid
     , history_table.prpd_smart_doc_provider_type_case_criteria_html
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal_doc history_table
LEFT JOIN staging_octane.proposal_doc staging_table
          ON staging_table.prpd_pid = history_table.prpd_pid
WHERE staging_table.prpd_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.proposal_doc deleted_records
    WHERE deleted_records.prpd_pid = history_table.prpd_pid
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
    VALUES ('SP-100267', 'd_license_location_pid')
         , ('SP-100855', 'luloc_current_license_location')
         , ('SP-100855', 'luloc_synthetic_unique_current_license_location')
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
    VALUES ('staging', 'history_octane', 'lender_user_location', 'luloc_current_license_location')
         , ('staging', 'history_octane', 'lender_user_location', 'luloc_synthetic_unique_current_license_location')
         , ('staging', 'history_octane', 'deal', 'd_license_location_pid')
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
    VALUES ('staging', 'staging_octane', 'lender_user_location', 'luloc_synthetic_unique_current_license_location')
         , ('staging', 'staging_octane', 'lender_user_location', 'luloc_current_license_location')
         , ('staging', 'staging_octane', 'deal', 'd_license_location_pid')
)
DELETE
FROM mdi.edw_field_definition
    USING delete_keys, mdi.edw_table_definition
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name
  AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = delete_keys.field_name;
