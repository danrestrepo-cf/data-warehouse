--
-- EDW | star_loan table metadata shows key fields as updatable
-- https://app.asana.com/0/0/1200753845956817
--
--
-- Main | EDW - Octane schemas from prod-release to v2021.10.1.0 on uat https://app.asana.com/0/0/1201077269203237/
--

UPDATE mdi.insert_update_field
    SET update_flag = 'N'
    WHERE dwid IN (
        SELECT insert_update_field.dwid
        FROM mdi.insert_update_step
                 JOIN mdi.insert_update_key ON insert_update_step.dwid = insert_update_key.insert_update_step_dwid
                 JOIN mdi.insert_update_field ON insert_update_step.dwid = insert_update_field.insert_update_step_dwid
            AND insert_update_key.key_lookup = insert_update_field.update_lookup
            AND insert_update_field.update_flag = 'Y'
        );

/*
Add fields:
    staging_octane.proposal_doc_validity.prpdv_criteria_html
    staging_octane.loan.l_buyup_buydown_basis_points
    staging_octane.proposal_doc_set.prpds_docs_last_updated_datetime

    history_octane.proposal_doc_validity.prpdv_criteria_html
    history_octane.loan.l_buyup_buydown_basis_points
    history_octane.proposal_doc_set.prpds_docs_last_updated_datetime
*/

WITH
    new_fields (table_name, field_name, field_order) AS (
    VALUES ('proposal_doc_validity', 'prpdv_criteria_html', 17)
         , ('loan', 'l_buyup_buydown_basis_points', 115)
         , ('proposal_doc_set', 'prpds_docs_last_updated_datetime', 31)
)

    , new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT edw_table_definition.dwid
            , new_fields.field_name
            , FALSE
        FROM new_fields
            JOIN mdi.edw_table_definition ON edw_table_definition.schema_name = 'staging_octane'
                AND new_fields.table_name = edw_table_definition.table_name
        RETURNING dwid, edw_table_definition_dwid, field_name
)

    , new_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid)
        SELECT edw_table_definition.dwid
            , new_fields.field_name
            , FALSE -- key_field_flag
            , new_staging_field_definitions.dwid
        FROM new_fields
            JOIN mdi.edw_table_definition ON edw_table_definition.schema_name = 'history_octane'
                AND new_fields.table_name = edw_table_definition.table_name
            JOIN mdi.edw_table_definition AS source_table_definition ON source_table_definition.schema_name = 'staging_octane'
                AND source_table_definition.table_name = new_fields.table_name
            JOIN new_staging_field_definitions ON new_staging_field_definitions.edw_table_definition_dwid = source_table_definition.dwid
                AND new_staging_field_definitions.field_name = new_fields.field_name
)

    , new_table_output_fields AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
        SELECT table_output_step.dwid
            , new_fields.field_name
            , new_fields.field_name
            , new_fields.field_order
            , FALSE -- is_sensitive
        FROM new_fields
            JOIN mdi.table_output_step ON table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = new_fields.table_name
)

    , updated_table_input_sql (table_name, sql) AS (
    VALUES ('proposal_doc_validity', '--finding records to insert into history_octane.proposal_doc_validity
SELECT staging_table.prpdv_pid,  staging_table.prpdv_version,  staging_table.prpdv_proposal_doc_pid,  staging_table.prpdv_smart_doc_validity_date_case_pid,  staging_table.prpdv_deal_pid,  staging_table.prpdv_proposal_pid,  staging_table.prpdv_valid_from_date,  staging_table.prpdv_valid_through_date,  staging_table.prpdv_key_date,  staging_table.prpdv_doc_validity_type,  staging_table.prpdv_doc_key_date_type,  staging_table.prpdv_expiration_calendar_rule_type,  staging_table.prpdv_days_before_key_date,  staging_table.prpdv_warning_days, staging_table.prpdv_criteria_html, FALSE AS data_source_deleted_flag,  NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal_doc_validity staging_table
LEFT JOIN history_octane.proposal_doc_validity history_table
ON staging_table.prpdv_pid = history_table.prpdv_pid AND staging_table.prpdv_version = history_table.prpdv_version
WHERE history_table.prpdv_pid IS NULL
UNION ALL
SELECT history_table.prpdv_pid,  history_table.prpdv_version + 1,  history_table.prpdv_proposal_doc_pid,  history_table.prpdv_smart_doc_validity_date_case_pid,  history_table.prpdv_deal_pid,  history_table.prpdv_proposal_pid,  history_table.prpdv_valid_from_date,  history_table.prpdv_valid_through_date,  history_table.prpdv_key_date,  history_table.prpdv_doc_validity_type,  history_table.prpdv_doc_key_date_type,  history_table.prpdv_expiration_calendar_rule_type,  history_table.prpdv_days_before_key_date,  history_table.prpdv_warning_days, history_table.prpdv_criteria_html, TRUE AS data_source_deleted_flag,  NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal_doc_validity history_table
LEFT JOIN staging_octane.proposal_doc_validity staging_table
ON staging_table.prpdv_pid = history_table.prpdv_pid
WHERE staging_table.prpdv_pid IS NULL
AND NOT EXISTS( SELECT 1
FROM history_octane.proposal_doc_validity deleted_records
WHERE deleted_records.prpdv_pid = history_table.prpdv_pid AND deleted_records.data_source_deleted_flag = TRUE );')

         , ('loan', '--finding records to insert into history_octane.loan
SELECT staging_table.l_pid, staging_table.l_version, staging_table.l_proposal_pid, staging_table.l_offering_pid, staging_table.l_product_terms_pid, staging_table.l_mortgage_type, staging_table.l_interest_only_type, staging_table.l_buydown_schedule_type, staging_table.l_prepay_penalty_schedule_type, staging_table.l_aus_type, staging_table.l_agency_case_id, staging_table.l_arm_index_datetime, staging_table.l_arm_index_current_value_percent, staging_table.l_arm_margin_percent, staging_table.l_base_loan_amount, staging_table.l_buydown_contributor_type, staging_table.l_target_cash_out_amount, staging_table.l_heloc_maximum_balance_amount, staging_table.l_note_rate_percent, staging_table.l_initial_note_rate_percent, staging_table.l_lien_priority_type, staging_table.l_loan_amount, staging_table.l_financed_amount, staging_table.l_ltv_ratio_percent, staging_table.l_mi_requirement_ltv_ratio_percent, staging_table.l_mi_auto_compute, staging_table.l_mi_no_mi_product, staging_table.l_mi_input_type, staging_table.l_mi_company_name_type, staging_table.l_mi_certificate_id, staging_table.l_mi_premium_refundable_type, staging_table.l_mi_initial_calculation_type, staging_table.l_mi_renewal_calculation_type, staging_table.l_mi_payer_type, staging_table.l_mi_coverage_percent, staging_table.l_mi_ltv_cutoff_percent, staging_table.l_mi_midpoint_cutoff_required, staging_table.l_mi_required_monthly_payment_count, staging_table.l_mi_actual_monthly_payment_count, staging_table.l_mi_payment_type, staging_table.l_mi_upfront_amount, staging_table.l_mi_upfront_percent, staging_table.l_mi_initial_monthly_payment_amount, staging_table.l_mi_renewal_monthly_payment_annual_percent, staging_table.l_mi_renewal_monthly_payment_amount, staging_table.l_mi_initial_duration_months, staging_table.l_mi_initial_monthly_payment_annual_percent, staging_table.l_mi_initial_calculated_rate_type, staging_table.l_mi_renewal_calculated_rate_type, staging_table.l_mi_base_rate_label, staging_table.l_mi_base_monthly_payment_annual_percent, staging_table.l_mi_base_upfront_percent, staging_table.l_mi_base_monthly_payment_amount, staging_table.l_mi_base_upfront_payment_amount, staging_table.l_qualifying_rate_type, staging_table.l_qualifying_rate_input_percent, staging_table.l_qualifying_rate_percent, staging_table.l_fha_program_code_type, staging_table.l_fha_principal_write_down, staging_table.l_fhac_case_assignment_messages, staging_table.l_initial_pi_amount, staging_table.l_qualifying_pi_amount, staging_table.l_base_note_rate_percent, staging_table.l_base_arm_margin_percent, staging_table.l_base_price_percent, staging_table.l_lock_price_percent, staging_table.l_lock_duration_days, staging_table.l_lock_commitment_type, staging_table.l_product_choice_datetime, staging_table.l_hmda_purchaser_of_loan_2017_type, staging_table.l_hmda_purchaser_of_loan_2018_type, staging_table.l_texas_equity, staging_table.l_texas_equity_auto, staging_table.l_fnm_mbs_investor_contract_id, staging_table.l_base_guaranty_fee_basis_points, staging_table.l_guaranty_fee_basis_points, staging_table.l_guaranty_fee_after_alternate_payment_method_basis_points, staging_table.l_fnm_investor_product_plan_id, staging_table.l_uldd_loan_comment, staging_table.l_principal_curtailment_amount, staging_table.l_agency_case_id_assigned_date, staging_table.l_mi_lender_paid_rate_adjustment_percent, staging_table.l_apr, staging_table.l_finance_charge_amount, staging_table.l_apor_percent, staging_table.l_apor_date, staging_table.l_hmda_rate_spread_percent, staging_table.l_hoepa_apr, staging_table.l_hoepa_rate_spread, staging_table.l_hoepa_fees_dollar_amount, staging_table.l_hmda_hoepa_status_type, staging_table.l_rate_sheet_undiscounted_rate_percent, staging_table.l_effective_undiscounted_rate_percent, staging_table.l_last_unprocessed_changes_datetime, staging_table.l_locked_price_change_percent, staging_table.l_interest_rate_fee_change_amount, staging_table.l_lender_concession_candidate, staging_table.l_durp_eligibility_opt_out, staging_table.l_qualified_mortgage_status_type, staging_table.l_qualified_mortgage, staging_table.l_lqa_purchase_eligibility_type, staging_table.l_student_loan_cash_out_refinance, staging_table.l_mi_rate_quote_id, staging_table.l_mi_integration_vendor_request_pid, staging_table.l_secondary_clear_to_commit, staging_table.l_qm_eligible, staging_table.l_fha_endorsement_date, staging_table.l_va_guaranty_date, staging_table.l_usda_guarantee_date, staging_table.l_hpml, staging_table.l_qualified_mortgage_rule_version_type, staging_table.l_qualified_mortgage_apr, staging_table.l_qualified_mortgage_max_allowed_rate_spread, staging_table.l_buyup_buydown_basis_points, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.loan staging_table
LEFT JOIN history_octane.loan history_table on staging_table.l_pid = history_table.l_pid and staging_table.l_version = history_table.l_version
WHERE history_table.l_pid is NULL
UNION ALL
SELECT history_table.l_pid, history_table.l_version+1, history_table.l_proposal_pid, history_table.l_offering_pid, history_table.l_product_terms_pid, history_table.l_mortgage_type, history_table.l_interest_only_type, history_table.l_buydown_schedule_type, history_table.l_prepay_penalty_schedule_type, history_table.l_aus_type, history_table.l_agency_case_id, history_table.l_arm_index_datetime, history_table.l_arm_index_current_value_percent, history_table.l_arm_margin_percent, history_table.l_base_loan_amount, history_table.l_buydown_contributor_type, history_table.l_target_cash_out_amount, history_table.l_heloc_maximum_balance_amount, history_table.l_note_rate_percent, history_table.l_initial_note_rate_percent, history_table.l_lien_priority_type, history_table.l_loan_amount, history_table.l_financed_amount, history_table.l_ltv_ratio_percent, history_table.l_mi_requirement_ltv_ratio_percent, history_table.l_mi_auto_compute, history_table.l_mi_no_mi_product, history_table.l_mi_input_type, history_table.l_mi_company_name_type, history_table.l_mi_certificate_id, history_table.l_mi_premium_refundable_type, history_table.l_mi_initial_calculation_type, history_table.l_mi_renewal_calculation_type, history_table.l_mi_payer_type, history_table.l_mi_coverage_percent, history_table.l_mi_ltv_cutoff_percent, history_table.l_mi_midpoint_cutoff_required, history_table.l_mi_required_monthly_payment_count, history_table.l_mi_actual_monthly_payment_count, history_table.l_mi_payment_type, history_table.l_mi_upfront_amount, history_table.l_mi_upfront_percent, history_table.l_mi_initial_monthly_payment_amount, history_table.l_mi_renewal_monthly_payment_annual_percent, history_table.l_mi_renewal_monthly_payment_amount, history_table.l_mi_initial_duration_months, history_table.l_mi_initial_monthly_payment_annual_percent, history_table.l_mi_initial_calculated_rate_type, history_table.l_mi_renewal_calculated_rate_type, history_table.l_mi_base_rate_label, history_table.l_mi_base_monthly_payment_annual_percent, history_table.l_mi_base_upfront_percent, history_table.l_mi_base_monthly_payment_amount, history_table.l_mi_base_upfront_payment_amount, history_table.l_qualifying_rate_type, history_table.l_qualifying_rate_input_percent, history_table.l_qualifying_rate_percent, history_table.l_fha_program_code_type, history_table.l_fha_principal_write_down, history_table.l_fhac_case_assignment_messages, history_table.l_initial_pi_amount, history_table.l_qualifying_pi_amount, history_table.l_base_note_rate_percent, history_table.l_base_arm_margin_percent, history_table.l_base_price_percent, history_table.l_lock_price_percent, history_table.l_lock_duration_days, history_table.l_lock_commitment_type, history_table.l_product_choice_datetime, history_table.l_hmda_purchaser_of_loan_2017_type, history_table.l_hmda_purchaser_of_loan_2018_type, history_table.l_texas_equity, history_table.l_texas_equity_auto, history_table.l_fnm_mbs_investor_contract_id, history_table.l_base_guaranty_fee_basis_points, history_table.l_guaranty_fee_basis_points, history_table.l_guaranty_fee_after_alternate_payment_method_basis_points, history_table.l_fnm_investor_product_plan_id, history_table.l_uldd_loan_comment, history_table.l_principal_curtailment_amount, history_table.l_agency_case_id_assigned_date, history_table.l_mi_lender_paid_rate_adjustment_percent, history_table.l_apr, history_table.l_finance_charge_amount, history_table.l_apor_percent, history_table.l_apor_date, history_table.l_hmda_rate_spread_percent, history_table.l_hoepa_apr, history_table.l_hoepa_rate_spread, history_table.l_hoepa_fees_dollar_amount, history_table.l_hmda_hoepa_status_type, history_table.l_rate_sheet_undiscounted_rate_percent, history_table.l_effective_undiscounted_rate_percent, history_table.l_last_unprocessed_changes_datetime, history_table.l_locked_price_change_percent, history_table.l_interest_rate_fee_change_amount, history_table.l_lender_concession_candidate, history_table.l_durp_eligibility_opt_out, history_table.l_qualified_mortgage_status_type, history_table.l_qualified_mortgage, history_table.l_lqa_purchase_eligibility_type, history_table.l_student_loan_cash_out_refinance, history_table.l_mi_rate_quote_id, history_table.l_mi_integration_vendor_request_pid, history_table.l_secondary_clear_to_commit, history_table.l_qm_eligible, history_table.l_fha_endorsement_date, history_table.l_va_guaranty_date, history_table.l_usda_guarantee_date, history_table.l_hpml, history_table.l_qualified_mortgage_rule_version_type, history_table.l_qualified_mortgage_apr, history_table.l_qualified_mortgage_max_allowed_rate_spread, history_table.l_buyup_buydown_basis_points, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM history_octane.loan history_table
LEFT JOIN staging_octane.loan staging_table on staging_table.l_pid = history_table.l_pid
WHERE staging_table.l_pid is NULL
AND not exists (select 1 from history_octane.loan deleted_records where deleted_records.l_pid = history_table.l_pid and deleted_records.data_source_deleted_flag = TRUE );')

         , ('proposal_doc_set', '--finding records to insert into hitory_octane.proposal_doc_set
SELECT staging_table.prpds_pid, staging_table.prpds_version, staging_table.prpds_proposal_pid, staging_table.prpds_smart_doc_set_pid, staging_table.prpds_create_datetime, staging_table.prpds_delivered_or_mailed_datetime, staging_table.prpds_creator_agent_type, staging_table.prpds_creator_lender_user_pid, staging_table.prpds_creator_unparsed_name, staging_table.prpds_requested_datetime, staging_table.prpds_requester_agent_type, staging_table.prpds_requester_lender_user_pid, staging_table.prpds_requester_unparsed_name, staging_table.prpds_signed_date, staging_table.prpds_delivery_method_type, staging_table.prpds_tracking_number, staging_table.prpds_affects_earliest_allowed_consummation_date, staging_table.prpds_name, staging_table.prpds_docusign_package_pid, staging_table.prpds_esign_vendor_type, staging_table.prpds_esign_evidence_deal_file_pid, staging_table.prpds_doc_package_status_type, staging_table.prpds_canceled_reason_type, staging_table.prpds_canceled_datetime, staging_table.prpds_canceler_agent_type, staging_table.prpds_canceler_lender_user_pid, staging_table.prpds_canceler_unparsed_name, staging_table.prpds_canceled_reason, staging_table.prpds_proposal_doc_set_id, staging_table.prpds_docs_last_updated_datetime, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.proposal_doc_set staging_table
LEFT JOIN history_octane.proposal_doc_set history_table on staging_table.prpds_pid = history_table.prpds_pid and staging_table.prpds_version = history_table.prpds_version
WHERE history_table.prpds_pid is NULL
UNION ALL
SELECT history_table.prpds_pid, history_table.prpds_version+1, history_table.prpds_proposal_pid, history_table.prpds_smart_doc_set_pid, history_table.prpds_create_datetime, history_table.prpds_delivered_or_mailed_datetime, history_table.prpds_creator_agent_type, history_table.prpds_creator_lender_user_pid, history_table.prpds_creator_unparsed_name, history_table.prpds_requested_datetime, history_table.prpds_requester_agent_type, history_table.prpds_requester_lender_user_pid, history_table.prpds_requester_unparsed_name, history_table.prpds_signed_date, history_table.prpds_delivery_method_type, history_table.prpds_tracking_number, history_table.prpds_affects_earliest_allowed_consummation_date, history_table.prpds_name, history_table.prpds_docusign_package_pid, history_table.prpds_esign_vendor_type, history_table.prpds_esign_evidence_deal_file_pid, history_table.prpds_doc_package_status_type, history_table.prpds_canceled_reason_type, history_table.prpds_canceled_datetime, history_table.prpds_canceler_agent_type, history_table.prpds_canceler_lender_user_pid, history_table.prpds_canceler_unparsed_name, history_table.prpds_canceled_reason, history_table.prpds_proposal_doc_set_id, history_table.prpds_docs_last_updated_datetime, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM history_octane.proposal_doc_set history_table
LEFT JOIN staging_octane.proposal_doc_set staging_table on staging_table.prpds_pid = history_table.prpds_pid
WHERE staging_table.prpds_pid is NULL
AND not exists (select 1 from history_octane.proposal_doc_set deleted_records where deleted_records.prpds_pid = history_table.prpds_pid and deleted_records.data_source_deleted_flag = TRUE );')
)

    , updated_table_input_step AS (
    UPDATE mdi.table_input_step
        SET sql = updated_table_input_sql.sql
        FROM updated_table_input_sql
            , mdi.table_output_step
        WHERE table_input_step.process_dwid = table_output_step.process_dwid
            AND table_output_step.target_schema = 'history_octane'
            AND table_output_step.target_table = updated_table_input_sql.table_name
)
select 'Done adding fields:
staging_octane.proposal_doc_validity.prpdv_criteria_html
staging_octane.loan.l_buyup_buydown_basis_points
staging_octane.proposal_doc_set.prpds_docs_last_updated_datetime

history_octane.proposal_doc_validity.prpdv_criteria_html
history_octane.loan.l_buyup_buydown_basis_points
history_octane.proposal_doc_set.prpds_docs_last_updated_datetime';



/*
Remove fields:
    staging_octane.smart_doc_validity_date_case.sdvdc_criteria_html
    staging_octane.smart_mi_rate_case.smrc_criteria_html
    staging_octane.smart_mi_rate_adjustment_case.smrac_criteria_html
    staging_octane.smart_mi_surcharge_case.smsc_criteria_html
    staging_octane.construction_cost.coc_contractor_pid
    staging_octane.loan.l_base_loan_amount_ltv_ratio_percent
*/

-- Nullify source_edw_field_definition_dwid values for history_octane rows
UPDATE mdi.edw_field_definition
SET source_edw_field_definition_dwid = NULL
WHERE dwid IN (
    SELECT edw_field_definition.dwid
    FROM mdi.edw_table_definition
        JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
    WHERE edw_table_definition.schema_name = 'history_octane'
        AND edw_table_definition.table_name IN ('smart_doc_validity_date_case', 'smart_mi_rate_case', 'smart_mi_rate_adjustment_case', 'smart_mi_surcharge_case', 'construction_cost', 'loan')
        AND edw_field_definition.field_name IN ('sdvdc_criteria_html', 'smrc_criteria_html',
                                                'smrac_criteria_html', 'smsc_criteria_html', 'coc_contractor_pid',
                                                'l_base_loan_amount_ltv_ratio_percent'));

-- Remove edw_field_definition records for staging_octane rows
DELETE FROM mdi.edw_field_definition
WHERE dwid IN (
    SELECT edw_field_definition.dwid
    FROM mdi.edw_table_definition
        JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
    WHERE edw_table_definition.schema_name = 'staging_octane'
    AND edw_table_definition.table_name IN ('smart_doc_validity_date_case', 'smart_mi_rate_case', 'smart_mi_rate_adjustment_case', 'smart_mi_surcharge_case', 'construction_cost', 'loan')
    AND edw_field_definition.field_name IN ('sdvdc_criteria_html', 'smrc_criteria_html',
                                            'smrac_criteria_html', 'smsc_criteria_html', 'coc_contractor_pid',
                                            'l_base_loan_amount_ltv_ratio_percent'));

-- Remove table_output_field records for fields removed
DELETE FROM mdi.table_output_field
WHERE dwid IN (
    SELECT table_output_field.dwid
    FROM mdi.process
        JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
            AND table_output_step.target_table IN ('smart_doc_validity_date_case', 'smart_mi_rate_case', 'smart_mi_rate_adjustment_case', 'smart_mi_surcharge_case', 'construction_cost', 'loan')
        JOIN mdi.table_output_field ON table_output_step.dwid = table_output_field.table_output_step_dwid
            AND table_output_field.database_field_name IN ( 'sdvdc_criteria_html', 'smrc_criteria_html',
                                                            'smrac_criteria_html', 'smsc_criteria_html',
                                                            'coc_contractor_pid', 'l_base_loan_amount_ltv_ratio_percent'));

-- Update the table_input_step sql queries for the ETLs that maintain the affected tables
-- smart_doc_validity_date_case:
UPDATE mdi.table_input_step
SET sql = '--finding records to insert into history_octane.smart_doc_validity_date_case
SELECT staging_table.sdvdc_pid,  staging_table.sdvdc_version,  staging_table.sdvdc_smart_doc_pid,  staging_table.sdvdc_criteria_pid, staging_table.sdvdc_deal_child_type,  staging_table.sdvdc_deal_child_relationship_type,  staging_table.sdvdc_doc_validity_type,  staging_table.sdvdc_doc_key_date_type,  staging_table.sdvdc_expiration_calendar_rule_type,  staging_table.sdvdc_days_before_key_date,  staging_table.sdvdc_warning_days,  staging_table.sdvdc_ordinal,  staging_table.sdvdc_else_case,  staging_table.sdvdc_active,  FALSE AS data_source_deleted_flag,  NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_doc_validity_date_case staging_table
LEFT JOIN history_octane.smart_doc_validity_date_case history_table
ON staging_table.sdvdc_pid = history_table.sdvdc_pid AND staging_table.sdvdc_version = history_table.sdvdc_version
WHERE history_table.sdvdc_pid IS NULL
UNION ALL
SELECT history_table.sdvdc_pid,  history_table.sdvdc_version + 1,  history_table.sdvdc_smart_doc_pid,  history_table.sdvdc_criteria_pid, history_table.sdvdc_deal_child_type,  history_table.sdvdc_deal_child_relationship_type,  history_table.sdvdc_doc_validity_type,  history_table.sdvdc_doc_key_date_type,  history_table.sdvdc_expiration_calendar_rule_type,  history_table.sdvdc_days_before_key_date,  history_table.sdvdc_warning_days,  history_table.sdvdc_ordinal,  history_table.sdvdc_else_case,  history_table.sdvdc_active,  TRUE AS data_source_deleted_flag,  NOW( ) AS data_source_updated_datetime
FROM history_octane.smart_doc_validity_date_case history_table
LEFT JOIN staging_octane.smart_doc_validity_date_case staging_table
ON staging_table.sdvdc_pid = history_table.sdvdc_pid
WHERE staging_table.sdvdc_pid IS NULL
AND NOT EXISTS( SELECT 1
FROM history_octane.smart_doc_validity_date_case deleted_records
WHERE deleted_records.sdvdc_pid = history_table.sdvdc_pid AND deleted_records.data_source_deleted_flag = TRUE );'
WHERE dwid = (
    SELECT table_input_step.dwid
    FROM mdi.process
        JOIN mdi.table_input_step ON process.dwid = table_input_step.process_dwid
        JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
            AND table_output_step.target_table = 'smart_doc_validity_date_case');

-- smart_mi_rate_case:
UPDATE mdi.table_input_step
SET sql = '--finding records to insert into hitory_octane.smart_mi_rate_case
SELECT staging_table.smrc_pid, staging_table.smrc_version, staging_table.smrc_smart_mi_rate_card_pid, staging_table.smrc_ordinal, staging_table.smrc_criteria_pid, staging_table.smrc_else_case, staging_table.smrc_amount_description, staging_table.smrc_upfront_percent, staging_table.smrc_initial_monthly_payment_annual_percent, staging_table.smrc_coverage_percent, staging_table.smrc_ltv_cutoff_percent, staging_table.smrc_midpoint_cutoff_required, staging_table.smrc_required_monthly_payment_count, staging_table.smrc_initial_duration_months, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.smart_mi_rate_case staging_table
LEFT JOIN history_octane.smart_mi_rate_case history_table on staging_table.smrc_pid = history_table.smrc_pid and staging_table.smrc_version = history_table.smrc_version
WHERE history_table.smrc_pid is NULL
UNION ALL
SELECT history_table.smrc_pid, history_table.smrc_version+1, history_table.smrc_smart_mi_rate_card_pid, history_table.smrc_ordinal, history_table.smrc_criteria_pid, history_table.smrc_else_case, history_table.smrc_amount_description, history_table.smrc_upfront_percent, history_table.smrc_initial_monthly_payment_annual_percent, history_table.smrc_coverage_percent, history_table.smrc_ltv_cutoff_percent, history_table.smrc_midpoint_cutoff_required, history_table.smrc_required_monthly_payment_count, history_table.smrc_initial_duration_months, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM history_octane.smart_mi_rate_case history_table
LEFT JOIN staging_octane.smart_mi_rate_case staging_table on staging_table.smrc_pid = history_table.smrc_pid
WHERE staging_table.smrc_pid is NULL
AND not exists (select 1 from history_octane.smart_mi_rate_case deleted_records where deleted_records.smrc_pid = history_table.smrc_pid and deleted_records.data_source_deleted_flag = TRUE );'
WHERE dwid = (
    SELECT table_input_step.dwid
    FROM mdi.process
        JOIN mdi.table_input_step ON process.dwid = table_input_step.process_dwid
        JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
            AND table_output_step.target_table = 'smart_mi_rate_case');

-- smart_mi_rate_adjustment_case:
UPDATE mdi.table_input_step
SET sql = '--finding records to insert into hitory_octane.smart_mi_rate_adjustment_case
SELECT staging_table.smrac_pid, staging_table.smrac_version, staging_table.smrac_smart_mi_rate_card_pid, staging_table.smrac_rate_adjustment_percent, staging_table.smrac_criteria_pid, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.smart_mi_rate_adjustment_case staging_table
LEFT JOIN history_octane.smart_mi_rate_adjustment_case history_table on staging_table.smrac_pid = history_table.smrac_pid and staging_table.smrac_version = history_table.smrac_version
WHERE history_table.smrac_pid is NULL
UNION ALL
SELECT history_table.smrac_pid, history_table.smrac_version+1, history_table.smrac_smart_mi_rate_card_pid, history_table.smrac_rate_adjustment_percent, history_table.smrac_criteria_pid, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM history_octane.smart_mi_rate_adjustment_case history_table
LEFT JOIN staging_octane.smart_mi_rate_adjustment_case staging_table on staging_table.smrac_pid = history_table.smrac_pid
WHERE staging_table.smrac_pid is NULL
AND not exists (select 1 from history_octane.smart_mi_rate_adjustment_case deleted_records where deleted_records.smrac_pid = history_table.smrac_pid and deleted_records.data_source_deleted_flag = TRUE);'
WHERE dwid = (
    SELECT table_input_step.dwid
    FROM mdi.process
        JOIN mdi.table_input_step ON process.dwid = table_input_step.process_dwid
        JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
            AND table_output_step.target_table = 'smart_mi_rate_adjustment_case');

-- smart_mi_surcharge_case:
UPDATE mdi.table_input_step
SET sql = '--finding records to insert into hitory_octane.smart_mi_surcharge_case
SELECT staging_table.smsc_pid, staging_table.smsc_version, staging_table.smsc_smart_mi_surcharge_pid, staging_table.smsc_criteria_pid, staging_table.smsc_government_surcharge_percent, staging_table.smsc_minimum_surcharge_amount, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.smart_mi_surcharge_case staging_table
LEFT JOIN history_octane.smart_mi_surcharge_case history_table on staging_table.smsc_pid = history_table.smsc_pid and staging_table.smsc_version = history_table.smsc_version
WHERE history_table.smsc_pid is NULL
UNION ALL
SELECT history_table.smsc_pid, history_table.smsc_version+1, history_table.smsc_smart_mi_surcharge_pid, history_table.smsc_criteria_pid, history_table.smsc_government_surcharge_percent, history_table.smsc_minimum_surcharge_amount, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM history_octane.smart_mi_surcharge_case history_table
LEFT JOIN staging_octane.smart_mi_surcharge_case staging_table on staging_table.smsc_pid = history_table.smsc_pid
WHERE staging_table.smsc_pid is NULL
AND not exists (select 1 from history_octane.smart_mi_surcharge_case deleted_records where deleted_records.smsc_pid = history_table.smsc_pid and deleted_records.data_source_deleted_flag = TRUE );'
WHERE dwid = (
    SELECT table_input_step.dwid
    FROM mdi.process
        JOIN mdi.table_input_step ON process.dwid = table_input_step.process_dwid
        JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
            AND table_output_step.target_table = 'smart_mi_surcharge_case');

-- construction_cost:
UPDATE mdi.table_input_step
SET sql = '--finding records to insert into history_octane.construction_cost
SELECT staging_table.coc_pid
, staging_table.coc_version
, staging_table.coc_proposal_pid
, staging_table.coc_construction_cost_category_type
, staging_table.coc_construction_cost_funding_type
, staging_table.coc_construction_cost_status_type
, staging_table.coc_construction_cost_payee_type
, staging_table.coc_create_datetime
, staging_table.coc_construction_cost_amount
, staging_table.coc_construction_cost_notes
, staging_table.coc_proposal_contractor_pid
, staging_table.coc_payee
, staging_table.coc_effective_construction_cost_calculation_percent
, staging_table.coc_construction_cost_calculation_type
, staging_table.coc_permit_pid
, staging_table.coc_category_type_label
, staging_table.coc_calculated_construction_cost_percent
, staging_table.coc_overridden_construction_cost_percent
, staging_table.coc_construction_cost_calculation_percent_override_reason
, staging_table.coc_calculated_construction_cost_months
, staging_table.coc_overridden_construction_cost_months
, staging_table.coc_effective_construction_cost_months
, staging_table.coc_construction_cost_months_override_reason
, staging_table.coc_charge_type
, staging_table.coc_draw_discrepancy_text
, staging_table.coc_impeding_draw_discrepancy
, FALSE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM staging_octane.construction_cost staging_table
LEFT JOIN history_octane.construction_cost history_table
ON staging_table.coc_pid = history_table.coc_pid AND staging_table.coc_version = history_table.coc_version
WHERE history_table.coc_pid IS NULL
UNION ALL
SELECT history_table.coc_pid
, history_table.coc_version + 1
, history_table.coc_proposal_pid
, history_table.coc_construction_cost_category_type
, history_table.coc_construction_cost_funding_type
, history_table.coc_construction_cost_status_type
, history_table.coc_construction_cost_payee_type
, history_table.coc_create_datetime
, history_table.coc_construction_cost_amount
, history_table.coc_construction_cost_notes
, history_table.coc_proposal_contractor_pid
, history_table.coc_payee
, history_table.coc_effective_construction_cost_calculation_percent
, history_table.coc_construction_cost_calculation_type
, history_table.coc_permit_pid
, history_table.coc_category_type_label
, history_table.coc_calculated_construction_cost_percent
, history_table.coc_overridden_construction_cost_percent
, history_table.coc_construction_cost_calculation_percent_override_reason
, history_table.coc_calculated_construction_cost_months
, history_table.coc_overridden_construction_cost_months
, history_table.coc_effective_construction_cost_months
, history_table.coc_construction_cost_months_override_reason
, history_table.coc_charge_type
, history_table.coc_draw_discrepancy_text
, history_table.coc_impeding_draw_discrepancy
, TRUE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM history_octane.construction_cost history_table
LEFT JOIN staging_octane.construction_cost staging_table
ON staging_table.coc_pid = history_table.coc_pid
WHERE staging_table.coc_pid IS NULL
AND NOT EXISTS( SELECT 1
FROM history_octane.construction_cost deleted_records
WHERE deleted_records.coc_pid = history_table.coc_pid AND deleted_records.data_source_deleted_flag = TRUE );'
WHERE dwid = (
    SELECT table_input_step.dwid
    FROM mdi.process
        JOIN mdi.table_input_step ON process.dwid = table_input_step.process_dwid
        JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
            AND table_output_step.target_table = 'construction_cost');

-- loan was updated on line 78 above since a column was being added

/*
Rename fields:
    staging_octane.loan.l_base_guaranty_fee_percent TO l_base_guaranty_fee_basis_points
    staging_octane.loan.l_guaranty_fee_percent TO l_guaranty_fee_basis_points
    staging_octane.loan.l_guaranty_fee_after_alternate_payment_method_percent TO l_guaranty_fee_after_alternate_payment_method_basis_points

    history_octane.loan.l_base_guaranty_fee_percent TO l_base_guaranty_fee_basis_points
    history_octane.loan.l_guaranty_fee_percent TO l_guaranty_fee_basis_points
    history_octane.loan.l_guaranty_fee_after_alternate_payment_method_percent TO l_guaranty_fee_after_alternate_payment_method_basis_points
*/


-- rename proposal field in edw_field_definition
-- loan.l_base_guaranty_fee_percent TO l_base_guaranty_fee_basis_points
UPDATE mdi.edw_field_definition
SET field_name = 'l_base_guaranty_fee_basis_points'
FROM mdi.edw_table_definition
WHERE edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
    AND edw_field_definition.field_name = 'l_base_guaranty_fee_percent'
    AND edw_table_definition.table_name = 'loan';

-- l_guaranty_fee_percent TO l_guaranty_fee_basis_points
UPDATE mdi.edw_field_definition
SET field_name = 'l_guaranty_fee_basis_points'
FROM mdi.edw_table_definition
WHERE edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
    AND edw_field_definition.field_name = 'l_guaranty_fee_percent'
    AND edw_table_definition.table_name = 'loan';

-- l_guaranty_fee_after_alternate_payment_method_percent TO l_guaranty_fee_after_alternate_payment_method_basis_points
UPDATE mdi.edw_field_definition
SET field_name = 'l_guaranty_fee_after_alternate_payment_method_basis_points'
FROM mdi.edw_table_definition
WHERE edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
    AND edw_field_definition.field_name = 'l_guaranty_fee_after_alternate_payment_method_percent'
    AND edw_table_definition.table_name = 'loan';


-- loan's table input sql was modified on line 78 to account for these changes

-- rename fields in table_output_field
-- loan.l_base_guaranty_fee_percent TO l_base_guaranty_fee_basis_points
UPDATE mdi.table_output_field
SET database_field_name = 'l_base_guaranty_fee_basis_points'
    , database_stream_name = 'l_base_guaranty_fee_basis_points'
WHERE database_field_name = 'l_base_guaranty_fee_percent';

-- l_guaranty_fee_percent TO l_guaranty_fee_basis_points
UPDATE mdi.table_output_field
SET database_field_name = 'l_guaranty_fee_basis_points'
    , database_stream_name = 'l_guaranty_fee_basis_points'
WHERE database_field_name = 'l_guaranty_fee_percent';

-- l_guaranty_fee_after_alternate_payment_method_percent TO l_guaranty_fee_after_alternate_payment_method_basis_points
UPDATE mdi.table_output_field
SET database_field_name = 'l_guaranty_fee_after_alternate_payment_method_basis_points'
    , database_stream_name = 'l_guaranty_fee_after_alternate_payment_method_basis_points'
WHERE database_field_name = 'l_guaranty_fee_after_alternate_payment_method_percent';


