--
-- EDW | Business Applications data mart- build a data mart and provide Octane user hierarchy data (patch 2)
-- https://app.asana.com/0/0/1201859471430286
--

/*
UPDATES
*/

--process
WITH update_rows (process_name, process_description) AS (
    VALUES ('SP-400002-insert-update', 'ETL to insert_update records into staging.data_mart_business_applications.edw_current_parent_nodes using staging.history_octane.org_node as the primary source')
         , ('SP-400002-delete', 'ETL to delete records from staging.data_mart_business_applications.edw_current_parent_nodes using staging.history_octane.org_node as the primary source')
         , ('SP-400003-insert-update', 'ETL to insert_update records into staging.data_mart_business_applications.edw_current_parent_node_employee_leaders using staging.history_octane.org_node_lender_user as the primary source')
         , ('SP-400003-delete', 'ETL to delete records from staging.data_mart_business_applications.edw_current_parent_node_employee_leaders using staging.history_octane.org_node_lender_user as the primary source')
         , ('SP-400001-insert-update', 'ETL to insert_update records into staging.data_mart_business_applications.edw_employee_user_details using staging.history_octane.lender_user as the primary source')
         , ('SP-400001-delete', 'ETL to delete records from staging.data_mart_business_applications.edw_employee_user_details using staging.history_octane.lender_user as the primary source')
)
UPDATE mdi.process
SET description = update_rows.process_description
FROM update_rows
WHERE update_rows.process_name = process.name;

--table_input_step
WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100267', 0, '--finding records to insert into history_octane.deal
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
     , staging_table.d_trid_application_date
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
     , staging_table.d_ecoa_application_date
     , staging_table.d_ecoa_decision_due_date
     , staging_table.d_ecoa_notice_of_incomplete_date
     , staging_table.d_ecoa_notice_of_incomplete_due_date
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
     , history_table.d_trid_application_date
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
     , history_table.d_ecoa_application_date
     , history_table.d_ecoa_decision_due_date
     , history_table.d_ecoa_notice_of_incomplete_date
     , history_table.d_ecoa_notice_of_incomplete_due_date
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
         , ('SP-100900', 0, '--finding records to insert into history_octane.wf_step_function_parameters
SELECT staging_table.wsfp_pid
     , staging_table.wsfp_version
     , staging_table.wsfp_wf_step_pid
     , staging_table.wsfp_proposal_review_id
     , staging_table.wsfp_proposal_review_status_type
     , staging_table.wsfp_number_business_days
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
     , history_table.wsfp_number_business_days
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
UPDATE mdi.table_input_step
SET data_source_dwid = update_rows.data_source_dwid
  , sql = update_rows.sql
  , connectionname = update_rows.connectionname::mdi.pentaho_db_connection_name
FROM update_rows
JOIN mdi.process
     ON process.name = update_rows.process_name
WHERE process.dwid = table_input_step.process_dwid;

--state_machine_definition
WITH update_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-400002-insert-update', 'SP-400002-insert-update', 'ETL to insert_update records into staging.data_mart_business_applications.edw_current_parent_nodes using staging.history_octane.org_node as the primary source')
         , ('SP-400002-delete', 'SP-400002-delete', 'ETL to delete records from staging.data_mart_business_applications.edw_current_parent_nodes using staging.history_octane.org_node as the primary source')
         , ('SP-400003-insert-update', 'SP-400003-insert-update', 'ETL to insert_update records into staging.data_mart_business_applications.edw_current_parent_node_employee_leaders using staging.history_octane.org_node_lender_user as the primary source')
         , ('SP-400003-delete', 'SP-400003-delete', 'ETL to delete records from staging.data_mart_business_applications.edw_current_parent_node_employee_leaders using staging.history_octane.org_node_lender_user as the primary source')
         , ('SP-400001-insert-update', 'SP-400001-insert-update', 'ETL to insert_update records into staging.data_mart_business_applications.edw_employee_user_details using staging.history_octane.lender_user as the primary source')
         , ('SP-400001-delete', 'SP-400001-delete', 'ETL to delete records from staging.data_mart_business_applications.edw_employee_user_details using staging.history_octane.lender_user as the primary source')
)
UPDATE mdi.state_machine_definition
SET name = update_rows.state_machine_name
  , comment = update_rows.state_machine_comment
FROM update_rows
JOIN mdi.process
     ON process.name = update_rows.process_name
WHERE process.dwid = state_machine_definition.process_dwid;
