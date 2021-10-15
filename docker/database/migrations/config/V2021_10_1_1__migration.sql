--
-- Main | EDW - Octane schemas from prod-release to v2021.10.2.0 on uat https://app.asana.com/0/0/1201176006424816
--

/*
Add fields:
staging_octane.loan_beneficiary
    lb_synthetic_unique_current
    lb_synthetic_unique_initial
history_octane.loan_beneficiary
    lb_synthetic_unique_current
    lb_synthetic_unique_initial

staging_octane.smart_charge_case
    scc_case_label
history_octane.smart_charge_case
    scc_case_label

staging_octane.loan
    l_va_agency_case_id
    l_fha_agency_case_id
    l_usda_agency_case_id
    l_va_agency_case_id_assigned_date
    l_fha_agency_case_id_assigned_date
    l_usda_agency_case_id_assigned_date
    l_post_interest_only_first_payment_date
history_octane.loan
    l_va_agency_case_id
    l_fha_agency_case_id
    l_usda_agency_case_id
    l_va_agency_case_id_assigned_date
    l_fha_agency_case_id_assigned_date
    l_usda_agency_case_id_assigned_date
    l_post_interest_only_first_payment_date

staging_octane.proposal_summary
    ps_effective_agency_case_id_main
    ps_effective_agency_case_id_piggyback
    ps_effective_agency_case_id_assigned_date_main
    ps_effective_agency_case_id_assigned_date_piggyback
history_octane.proposal_summary
    ps_effective_agency_case_id_main
    ps_effective_agency_case_id_piggyback
    ps_effective_agency_case_id_assigned_date_main
    ps_effective_agency_case_id_assigned_date_piggyback

staging_octane.loan_funding
    lf_synthetic_unique_active
history_octane.loan_funding
    lf_synthetic_unique_active

staging_octane.lender_user
    lu_email_signature_title
    lu_termination_date
history_octane.lender_user
    lu_email_signature_title
    lu_termination_date
*/

WITH
    new_fields (table_name, field_name, field_order) AS (
        VALUES ('loan_beneficiary', 'lb_synthetic_unique_current', 32)
             , ('loan_beneficiary', 'lb_synthetic_unique_initial', 33)
             , ('smart_charge_case', 'scc_case_label', 22)
             , ('loan', 'l_va_agency_case_id', 117)
             , ('loan', 'l_fha_agency_case_id', 118)
             , ('loan', 'l_usda_agency_case_id', 119)
             , ('loan', 'l_va_agency_case_id_assigned_date', 120)
             , ('loan', 'l_fha_agency_case_id_assigned_date', 121)
             , ('loan', 'l_usda_agency_case_id_assigned_date', 122)
             , ('loan', 'l_post_interest_only_first_payment_date', 123)
             , ('proposal_summary', 'ps_effective_agency_case_id_main', 152)
             , ('proposal_summary', 'ps_effective_agency_case_id_piggyback', 153)
             , ('proposal_summary', 'ps_effective_agency_case_id_assigned_date_main', 154)
             , ('proposal_summary', 'ps_effective_agency_case_id_assigned_date_piggyback', 155)
             , ('loan_funding', 'lf_synthetic_unique_active', 31)
             , ('lender_user', 'lu_email_signature_title', 61)
             , ('lender_user', 'lu_termination_date', 62)
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
    VALUES ('loan_beneficiary',     '--finding records to insert into history_octane.proposal_doc_validity')
         , ('smart_charge_case',    '--finding records to insert into history_octane.loan')
         , ('loan',                 '--finding records to insert into hitory_octane.proposal_doc_set')
         , ('proposal_summary',     '--finding records to insert into history_octane.loan')
         , ('loan_funding',         '--finding records to insert into hitory_octane.proposal_doc_set')
         , ('lender_user',          '--finding records to insert into history_octane.loan')
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
select 'Done adding fields to ETLs and metadata tables:
staging_octane.loan_beneficiary
    lb_synthetic_unique_current
    lb_synthetic_unique_initial
history_octane.loan_beneficiary
    lb_synthetic_unique_current
    lb_synthetic_unique_initial

staging_octane.smart_charge_case
    scc_case_label
history_octane.smart_charge_case
    scc_case_label

staging_octane.loan
    l_va_agency_case_id
    l_fha_agency_case_id
    l_usda_agency_case_id
    l_va_agency_case_id_assigned_date
    l_fha_agency_case_id_assigned_date
    l_usda_agency_case_id_assigned_date
    l_post_interest_only_first_payment_date
history_octane.loan
    l_va_agency_case_id
    l_fha_agency_case_id
    l_usda_agency_case_id
    l_va_agency_case_id_assigned_date
    l_fha_agency_case_id_assigned_date
    l_usda_agency_case_id_assigned_date
    l_post_interest_only_first_payment_date

staging_octane.proposal_summary
    ps_effective_agency_case_id_main
    ps_effective_agency_case_id_piggyback
    ps_effective_agency_case_id_assigned_date_main
    ps_effective_agency_case_id_assigned_date_piggyback
history_octane.proposal_summary
    ps_effective_agency_case_id_main
    ps_effective_agency_case_id_piggyback
    ps_effective_agency_case_id_assigned_date_main
    ps_effective_agency_case_id_assigned_date_piggyback

staging_octane.loan_funding
    lf_synthetic_unique_active
history_octane.loan_funding
    lf_synthetic_unique_active

staging_octane.lender_user
    lu_email_signature_title
    lu_termination_date
history_octane.lender_user
    lu_email_signature_title
    lu_termination_date';



/*
Remove fields:
staging_octane.loan
    l_agency_case_id
    l_agency_case_id_assigned_date
*/

-- Nullify source_edw_field_definition_dwid values for history_octane rows
UPDATE mdi.edw_field_definition
SET source_edw_field_definition_dwid = NULL
WHERE dwid IN (
    SELECT edw_field_definition.dwid
    FROM mdi.edw_table_definition
        JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
    WHERE edw_table_definition.schema_name = 'history_octane'
        AND edw_table_definition.table_name IN ('loan')
        AND edw_field_definition.field_name IN ('l_agency_case_id', 'l_agency_case_id_assigned_date'));

-- Remove edw_field_definition records for staging_octane rows
DELETE FROM mdi.edw_field_definition
WHERE dwid IN (
    SELECT edw_field_definition.dwid
    FROM mdi.edw_table_definition
        JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
    WHERE edw_table_definition.schema_name = 'staging_octane'
        AND edw_table_definition.table_name IN ('loan')
        AND edw_field_definition.field_name IN ('l_agency_case_id', 'l_agency_case_id_assigned_date'));

-- Remove table_output_field records for fields removed
DELETE FROM mdi.table_output_field
WHERE dwid IN (
    SELECT table_output_field.dwid
    FROM mdi.process
        JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
            AND table_output_step.target_table IN ('loan')
        JOIN mdi.table_output_field ON table_output_step.dwid = table_output_field.table_output_step_dwid
            AND table_output_field.database_field_name IN ('l_agency_case_id', 'l_agency_case_id_assigned_date'));

-- Update the table_input_step sql queries for the ETLs that maintain the affected tables
-- loan:
UPDATE mdi.table_input_step
SET sql = '--finding records to insert into history_octane.loan
SELECT staging_table.l_pid, staging_table.l_version, staging_table.l_proposal_pid, staging_table.l_offering_pid, staging_table.l_product_terms_pid, staging_table.l_mortgage_type, staging_table.l_interest_only_type, staging_table.l_buydown_schedule_type, staging_table.l_prepay_penalty_schedule_type, staging_table.l_aus_type, staging_table.l_arm_index_datetime, staging_table.l_arm_index_current_value_percent, staging_table.l_arm_margin_percent, staging_table.l_base_loan_amount, staging_table.l_buydown_contributor_type, staging_table.l_target_cash_out_amount, staging_table.l_heloc_maximum_balance_amount, staging_table.l_note_rate_percent, staging_table.l_initial_note_rate_percent, staging_table.l_lien_priority_type, staging_table.l_loan_amount, staging_table.l_financed_amount, staging_table.l_ltv_ratio_percent, staging_table.l_mi_requirement_ltv_ratio_percent, staging_table.l_mi_auto_compute, staging_table.l_mi_no_mi_product, staging_table.l_mi_input_type, staging_table.l_mi_company_name_type, staging_table.l_mi_certificate_id, staging_table.l_mi_premium_refundable_type, staging_table.l_mi_initial_calculation_type, staging_table.l_mi_renewal_calculation_type, staging_table.l_mi_payer_type, staging_table.l_mi_coverage_percent, staging_table.l_mi_ltv_cutoff_percent, staging_table.l_mi_midpoint_cutoff_required, staging_table.l_mi_required_monthly_payment_count, staging_table.l_mi_actual_monthly_payment_count, staging_table.l_mi_payment_type, staging_table.l_mi_upfront_amount, staging_table.l_mi_upfront_percent, staging_table.l_mi_initial_monthly_payment_amount, staging_table.l_mi_renewal_monthly_payment_annual_percent, staging_table.l_mi_renewal_monthly_payment_amount, staging_table.l_mi_initial_duration_months, staging_table.l_mi_initial_monthly_payment_annual_percent, staging_table.l_mi_initial_calculated_rate_type, staging_table.l_mi_renewal_calculated_rate_type, staging_table.l_mi_base_rate_label, staging_table.l_mi_base_monthly_payment_annual_percent, staging_table.l_mi_base_upfront_percent, staging_table.l_mi_base_monthly_payment_amount, staging_table.l_mi_base_upfront_payment_amount, staging_table.l_qualifying_rate_type, staging_table.l_qualifying_rate_input_percent, staging_table.l_qualifying_rate_percent, staging_table.l_fha_program_code_type, staging_table.l_fha_principal_write_down, staging_table.l_fhac_case_assignment_messages, staging_table.l_initial_pi_amount, staging_table.l_qualifying_pi_amount, staging_table.l_base_note_rate_percent, staging_table.l_base_arm_margin_percent, staging_table.l_base_price_percent, staging_table.l_lock_price_percent, staging_table.l_lock_duration_days, staging_table.l_lock_commitment_type, staging_table.l_product_choice_datetime, staging_table.l_hmda_purchaser_of_loan_2017_type, staging_table.l_hmda_purchaser_of_loan_2018_type, staging_table.l_texas_equity, staging_table.l_texas_equity_auto, staging_table.l_fnm_mbs_investor_contract_id, staging_table.l_base_guaranty_fee_basis_points, staging_table.l_guaranty_fee_basis_points, staging_table.l_guaranty_fee_after_alternate_payment_method_basis_points, staging_table.l_fnm_investor_product_plan_id, staging_table.l_uldd_loan_comment, staging_table.l_principal_curtailment_amount, staging_table.l_mi_lender_paid_rate_adjustment_percent, staging_table.l_apr, staging_table.l_finance_charge_amount, staging_table.l_apor_percent, staging_table.l_apor_date, staging_table.l_hmda_rate_spread_percent, staging_table.l_hoepa_apr, staging_table.l_hoepa_rate_spread, staging_table.l_hoepa_fees_dollar_amount, staging_table.l_hmda_hoepa_status_type, staging_table.l_rate_sheet_undiscounted_rate_percent, staging_table.l_effective_undiscounted_rate_percent, staging_table.l_last_unprocessed_changes_datetime, staging_table.l_locked_price_change_percent, staging_table.l_interest_rate_fee_change_amount, staging_table.l_lender_concession_candidate, staging_table.l_durp_eligibility_opt_out, staging_table.l_qualified_mortgage_status_type, staging_table.l_qualified_mortgage, staging_table.l_lqa_purchase_eligibility_type, staging_table.l_student_loan_cash_out_refinance, staging_table.l_mi_rate_quote_id, staging_table.l_mi_integration_vendor_request_pid, staging_table.l_secondary_clear_to_commit, staging_table.l_qm_eligible, staging_table.l_fha_endorsement_date, staging_table.l_va_guaranty_date, staging_table.l_usda_guarantee_date, staging_table.l_hpml, staging_table.l_qualified_mortgage_rule_version_type, staging_table.l_qualified_mortgage_apr, staging_table.l_qualified_mortgage_max_allowed_rate_spread, staging_table.l_buyup_buydown_basis_points, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.loan staging_table
LEFT JOIN history_octane.loan history_table on staging_table.l_pid = history_table.l_pid and staging_table.l_version = history_table.l_version
WHERE history_table.l_pid is NULL
UNION ALL
SELECT history_table.l_pid, history_table.l_version+1, history_table.l_proposal_pid, history_table.l_offering_pid, history_table.l_product_terms_pid, history_table.l_mortgage_type, history_table.l_interest_only_type, history_table.l_buydown_schedule_type, history_table.l_prepay_penalty_schedule_type, history_table.l_aus_type, history_table.l_arm_index_datetime, history_table.l_arm_index_current_value_percent, history_table.l_arm_margin_percent, history_table.l_base_loan_amount, history_table.l_buydown_contributor_type, history_table.l_target_cash_out_amount, history_table.l_heloc_maximum_balance_amount, history_table.l_note_rate_percent, history_table.l_initial_note_rate_percent, history_table.l_lien_priority_type, history_table.l_loan_amount, history_table.l_financed_amount, history_table.l_ltv_ratio_percent, history_table.l_mi_requirement_ltv_ratio_percent, history_table.l_mi_auto_compute, history_table.l_mi_no_mi_product, history_table.l_mi_input_type, history_table.l_mi_company_name_type, history_table.l_mi_certificate_id, history_table.l_mi_premium_refundable_type, history_table.l_mi_initial_calculation_type, history_table.l_mi_renewal_calculation_type, history_table.l_mi_payer_type, history_table.l_mi_coverage_percent, history_table.l_mi_ltv_cutoff_percent, history_table.l_mi_midpoint_cutoff_required, history_table.l_mi_required_monthly_payment_count, history_table.l_mi_actual_monthly_payment_count, history_table.l_mi_payment_type, history_table.l_mi_upfront_amount, history_table.l_mi_upfront_percent, history_table.l_mi_initial_monthly_payment_amount, history_table.l_mi_renewal_monthly_payment_annual_percent, history_table.l_mi_renewal_monthly_payment_amount, history_table.l_mi_initial_duration_months, history_table.l_mi_initial_monthly_payment_annual_percent, history_table.l_mi_initial_calculated_rate_type, history_table.l_mi_renewal_calculated_rate_type, history_table.l_mi_base_rate_label, history_table.l_mi_base_monthly_payment_annual_percent, history_table.l_mi_base_upfront_percent, history_table.l_mi_base_monthly_payment_amount, history_table.l_mi_base_upfront_payment_amount, history_table.l_qualifying_rate_type, history_table.l_qualifying_rate_input_percent, history_table.l_qualifying_rate_percent, history_table.l_fha_program_code_type, history_table.l_fha_principal_write_down, history_table.l_fhac_case_assignment_messages, history_table.l_initial_pi_amount, history_table.l_qualifying_pi_amount, history_table.l_base_note_rate_percent, history_table.l_base_arm_margin_percent, history_table.l_base_price_percent, history_table.l_lock_price_percent, history_table.l_lock_duration_days, history_table.l_lock_commitment_type, history_table.l_product_choice_datetime, history_table.l_hmda_purchaser_of_loan_2017_type, history_table.l_hmda_purchaser_of_loan_2018_type, history_table.l_texas_equity, history_table.l_texas_equity_auto, history_table.l_fnm_mbs_investor_contract_id, history_table.l_base_guaranty_fee_basis_points, history_table.l_guaranty_fee_basis_points, history_table.l_guaranty_fee_after_alternate_payment_method_basis_points, history_table.l_fnm_investor_product_plan_id, history_table.l_uldd_loan_comment, history_table.l_principal_curtailment_amount, history_table.l_mi_lender_paid_rate_adjustment_percent, history_table.l_apr, history_table.l_finance_charge_amount, history_table.l_apor_percent, history_table.l_apor_date, history_table.l_hmda_rate_spread_percent, history_table.l_hoepa_apr, history_table.l_hoepa_rate_spread, history_table.l_hoepa_fees_dollar_amount, history_table.l_hmda_hoepa_status_type, history_table.l_rate_sheet_undiscounted_rate_percent, history_table.l_effective_undiscounted_rate_percent, history_table.l_last_unprocessed_changes_datetime, history_table.l_locked_price_change_percent, history_table.l_interest_rate_fee_change_amount, history_table.l_lender_concession_candidate, history_table.l_durp_eligibility_opt_out, history_table.l_qualified_mortgage_status_type, history_table.l_qualified_mortgage, history_table.l_lqa_purchase_eligibility_type, history_table.l_student_loan_cash_out_refinance, history_table.l_mi_rate_quote_id, history_table.l_mi_integration_vendor_request_pid, history_table.l_secondary_clear_to_commit, history_table.l_qm_eligible, history_table.l_fha_endorsement_date, history_table.l_va_guaranty_date, history_table.l_usda_guarantee_date, history_table.l_hpml, history_table.l_qualified_mortgage_rule_version_type, history_table.l_qualified_mortgage_apr, history_table.l_qualified_mortgage_max_allowed_rate_spread, history_table.l_buyup_buydown_basis_points, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM history_octane.loan history_table
LEFT JOIN staging_octane.loan staging_table on staging_table.l_pid = history_table.l_pid
WHERE staging_table.l_pid is NULL
AND not exists (select 1 from history_octane.loan deleted_records where deleted_records.l_pid = history_table.l_pid and deleted_records.data_source_deleted_flag = TRUE );'
WHERE dwid = (
    SELECT table_input_step.dwid
    FROM mdi.process
        JOIN mdi.table_input_step ON process.dwid = table_input_step.process_dwid
        JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
            AND table_output_step.target_table = 'loan');
select 'Done removing fields from ETLs and metadata tables:
staging_octane.loan
    l_agency_case_id
    l_agency_case_id_assigned_date';
