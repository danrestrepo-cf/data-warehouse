--
-- Main | EDW - Octane schemas from prod-release to v2022.2.3.3-release
-- https://app.asana.com/0/0/1201862456976010
--

/*
INSERTIONS
*/

--edw_field_definition
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'staging_octane', 'deal', 'd_ecoa_application_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal', 'd_ecoa_decision_due_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal', 'd_trid_application_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'mcr_loan', 'mcrl_trid_application_date', 'DATE', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'deal', 'd_ecoa_application_date', 'DATE', 'staging', 'staging_octane', 'deal', 'd_ecoa_application_date')
         , ('staging', 'history_octane', 'deal', 'd_ecoa_decision_due_date', 'DATE', 'staging', 'staging_octane', 'deal', 'd_ecoa_decision_due_date')
         , ('staging', 'history_octane', 'deal', 'd_trid_application_date', 'DATE', 'staging', 'staging_octane', 'deal', 'd_trid_application_date')
         , ('staging', 'history_octane', 'mcr_loan', 'mcrl_trid_application_date', 'DATE', 'staging', 'staging_octane', 'mcr_loan', 'mcrl_trid_application_date')
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

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('SP-100267', 'd_ecoa_application_date')
         , ('SP-100267', 'd_ecoa_decision_due_date')
         , ('SP-100267', 'd_trid_application_date')
         , ('SP-100042', 'mcrl_trid_application_date')
)
INSERT
INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
SELECT table_output_step.dwid, insert_rows.database_field_name, insert_rows.database_field_name, 0, FALSE
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name
JOIN mdi.table_output_step
     ON process.dwid = table_output_step.process_dwid;


/*
UPDATES
*/

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
         , ('SP-100042', 0, '--finding records to insert into history_octane.mcr_loan
SELECT staging_table.mcrl_pid
     , staging_table.mcrl_version
     , staging_table.mcrl_loan_pid
     , staging_table.mcrl_mcr_snapshot_pid
     , staging_table.mcrl_los_loan_id
     , staging_table.mcrl_originator_nmls_id
     , staging_table.mcrl_loan_amount
     , staging_table.mcrl_lien_priority_type
     , staging_table.mcrl_mortgage_type
     , staging_table.mcrl_interest_only_type
     , staging_table.mcrl_prepay_penalty_schedule_type
     , staging_table.mcrl_ltv_ratio_percent
     , staging_table.mcrl_note_rate_percent
     , staging_table.mcrl_hmda_action_type
     , staging_table.mcrl_hmda_action_date
     , staging_table.mcrl_trid_application_date
     , staging_table.mcrl_decision_credit_score
     , staging_table.mcrl_property_usage_type
     , staging_table.mcrl_doc_level_type
     , staging_table.mcrl_loan_purpose_type
     , staging_table.mcrl_mi_required
     , staging_table.mcrl_proposal_structure_type
     , staging_table.mcrl_subject_property_state
     , staging_table.mcrl_property_category_type
     , staging_table.mcrl_cltv_ratio_percent
     , staging_table.mcrl_funding_status_type
     , staging_table.mcrl_funding_date
     , staging_table.mcrl_loan_amortization_type
     , staging_table.mcrl_product_special_program_type
     , staging_table.mcrl_non_conforming
     , staging_table.mcrl_initial_payment_adjustment_term_months
     , staging_table.mcrl_subsequent_payment_adjustment_term_months
     , staging_table.mcrl_fund_source_type
     , staging_table.mcrl_channel_type
     , staging_table.mcrl_financed_units_count
     , staging_table.mcrl_cash_out_reason_home_improvement
     , staging_table.mcrl_hmda_hoepa_status_type
     , staging_table.mcrl_qualified_mortgage_status_type
     , staging_table.mcrl_lender_fee_total_amount
     , staging_table.mcrl_broker_fee_total_amount
     , staging_table.mcrl_investor_hmda_purchaser_of_loan_type
     , staging_table.mcrl_confirmed_release_datetime
     , staging_table.mcrl_purchase_advice_date
     , staging_table.mcrl_purchasing_beneficiary_investor_pid
     , staging_table.mcrl_mcr_loan_status_type
     , staging_table.mcrl_servicing_transfer_type
     , staging_table.mcrl_financed_property_improvements_category_type
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.mcr_loan staging_table
LEFT JOIN history_octane.mcr_loan history_table
          ON staging_table.mcrl_pid = history_table.mcrl_pid
              AND staging_table.mcrl_version = history_table.mcrl_version
WHERE history_table.mcrl_pid IS NULL
UNION ALL
SELECT history_table.mcrl_pid
     , history_table.mcrl_version + 1
     , history_table.mcrl_loan_pid
     , history_table.mcrl_mcr_snapshot_pid
     , history_table.mcrl_los_loan_id
     , history_table.mcrl_originator_nmls_id
     , history_table.mcrl_loan_amount
     , history_table.mcrl_lien_priority_type
     , history_table.mcrl_mortgage_type
     , history_table.mcrl_interest_only_type
     , history_table.mcrl_prepay_penalty_schedule_type
     , history_table.mcrl_ltv_ratio_percent
     , history_table.mcrl_note_rate_percent
     , history_table.mcrl_hmda_action_type
     , history_table.mcrl_hmda_action_date
     , history_table.mcrl_trid_application_date
     , history_table.mcrl_decision_credit_score
     , history_table.mcrl_property_usage_type
     , history_table.mcrl_doc_level_type
     , history_table.mcrl_loan_purpose_type
     , history_table.mcrl_mi_required
     , history_table.mcrl_proposal_structure_type
     , history_table.mcrl_subject_property_state
     , history_table.mcrl_property_category_type
     , history_table.mcrl_cltv_ratio_percent
     , history_table.mcrl_funding_status_type
     , history_table.mcrl_funding_date
     , history_table.mcrl_loan_amortization_type
     , history_table.mcrl_product_special_program_type
     , history_table.mcrl_non_conforming
     , history_table.mcrl_initial_payment_adjustment_term_months
     , history_table.mcrl_subsequent_payment_adjustment_term_months
     , history_table.mcrl_fund_source_type
     , history_table.mcrl_channel_type
     , history_table.mcrl_financed_units_count
     , history_table.mcrl_cash_out_reason_home_improvement
     , history_table.mcrl_hmda_hoepa_status_type
     , history_table.mcrl_qualified_mortgage_status_type
     , history_table.mcrl_lender_fee_total_amount
     , history_table.mcrl_broker_fee_total_amount
     , history_table.mcrl_investor_hmda_purchaser_of_loan_type
     , history_table.mcrl_confirmed_release_datetime
     , history_table.mcrl_purchase_advice_date
     , history_table.mcrl_purchasing_beneficiary_investor_pid
     , history_table.mcrl_mcr_loan_status_type
     , history_table.mcrl_servicing_transfer_type
     , history_table.mcrl_financed_property_improvements_category_type
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.mcr_loan history_table
LEFT JOIN staging_octane.mcr_loan staging_table
          ON staging_table.mcrl_pid = history_table.mcrl_pid
WHERE staging_table.mcrl_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.mcr_loan deleted_records
    WHERE deleted_records.mcrl_pid = history_table.mcrl_pid
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
    VALUES ('SP-100042', 'mcrl_disclosure_mode_date')
         , ('SP-100267', 'd_disclosure_mode_date')
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
    VALUES ('staging', 'history_octane', 'deal', 'd_disclosure_mode_date')
         , ('staging', 'history_octane', 'mcr_loan', 'mcrl_disclosure_mode_date')
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
    VALUES ('staging', 'staging_octane', 'mcr_loan', 'mcrl_disclosure_mode_date')
         , ('staging', 'staging_octane', 'deal', 'd_disclosure_mode_date')
)
DELETE
FROM mdi.edw_field_definition
    USING delete_keys, mdi.edw_table_definition
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name
  AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = delete_keys.field_name;
