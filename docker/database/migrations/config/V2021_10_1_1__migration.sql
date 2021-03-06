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
    VALUES ('loan_beneficiary',     '
            --finding records to insert into hitory_octane.loan_beneficiary
            SELECT staging_table.lb_pid, staging_table.lb_version, staging_table.lb_loan_pid, staging_table.lb_investor_pid, staging_table.lb_investor_loan_id, staging_table.lb_from_date, staging_table.lb_through_date, staging_table.lb_current, staging_table.lb_initial, staging_table.lb_loan_benef_transfer_status_type, staging_table.lb_loan_file_ship_date, staging_table.lb_approved_with_conditions_date, staging_table.lb_rejected_date, staging_table.lb_pending_wire_date, staging_table.lb_purchase_advice_amount, staging_table.lb_mers_mom, staging_table.lb_mers_transfer_status_type, staging_table.lb_mers_transfer_creation_date, staging_table.lb_mers_transfer_override, staging_table.lb_mers_transfer_batch_pid, staging_table.lb_loan_file_courier_type, staging_table.lb_loan_file_tracking_number, staging_table.lb_collateral_courier_type, staging_table.lb_collateral_tracking_number, staging_table.lb_loan_file_delivery_method_type, staging_table.lb_pool_id, staging_table.lb_mbs_final_purchaser_investor_pid, staging_table.lb_early_funding, staging_table.lb_early_funding_date, staging_table.lb_delivery_aus_type, staging_table.lb_synthetic_unique_current, staging_table.lb_synthetic_unique_initial,FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
            FROM staging_octane.loan_beneficiary staging_table
            LEFT JOIN history_octane.loan_beneficiary history_table on staging_table.lb_pid = history_table.lb_pid and staging_table.lb_version = history_table.lb_version
            WHERE history_table.lb_pid is NULL
            UNION ALL
            SELECT history_table.lb_pid, history_table.lb_version+1, history_table.lb_loan_pid, history_table.lb_investor_pid, history_table.lb_investor_loan_id, history_table.lb_from_date, history_table.lb_through_date, history_table.lb_current, history_table.lb_initial, history_table.lb_loan_benef_transfer_status_type, history_table.lb_loan_file_ship_date, history_table.lb_approved_with_conditions_date, history_table.lb_rejected_date, history_table.lb_pending_wire_date, history_table.lb_purchase_advice_amount, history_table.lb_mers_mom, history_table.lb_mers_transfer_status_type, history_table.lb_mers_transfer_creation_date, history_table.lb_mers_transfer_override, history_table.lb_mers_transfer_batch_pid, history_table.lb_loan_file_courier_type, history_table.lb_loan_file_tracking_number, history_table.lb_collateral_courier_type, history_table.lb_collateral_tracking_number, history_table.lb_loan_file_delivery_method_type, history_table.lb_pool_id, history_table.lb_mbs_final_purchaser_investor_pid, history_table.lb_early_funding, history_table.lb_early_funding_date, history_table.lb_delivery_aus_type, history_table.lb_synthetic_unique_current, history_table.lb_synthetic_unique_initial, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
            FROM history_octane.loan_beneficiary history_table
            LEFT JOIN staging_octane.loan_beneficiary staging_table on staging_table.lb_pid = history_table.lb_pid
            WHERE staging_table.lb_pid is NULL
                AND not exists (select 1 from history_octane.loan_beneficiary deleted_records where deleted_records.lb_pid = history_table.lb_pid and deleted_records.data_source_deleted_flag = True);')
         , ('smart_charge_case',    '--finding records to insert into hitory_octane.smart_charge_case
            SELECT staging_table.scc_pid, staging_table.scc_version, staging_table.scc_smart_charge_group_case_pid, staging_table.scc_case_name, staging_table.scc_ordinal, staging_table.scc_criteria_pid, staging_table.scc_amount_description, staging_table.scc_charge_payer_type, staging_table.scc_charge_payee_type, staging_table.scc_paid_by, staging_table.scc_paid_to, staging_table.scc_base_amount, staging_table.scc_charge_input_type, staging_table.scc_charge_input_type_percent, staging_table.scc_charge_input_type_currency, staging_table.scc_financed, staging_table.scc_financed_auto_compute, staging_table.scc_poc, staging_table.scc_reduction_amount, staging_table.scc_subtract_lenders_title_insurance_amount, staging_table.scc_case_label, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
            FROM staging_octane.smart_charge_case staging_table
            LEFT JOIN history_octane.smart_charge_case history_table on staging_table.scc_pid = history_table.scc_pid and staging_table.scc_version = history_table.scc_version
            WHERE history_table.scc_pid is NULL
            UNION ALL
            SELECT history_table.scc_pid, history_table.scc_version+1, history_table.scc_smart_charge_group_case_pid, history_table.scc_case_name, history_table.scc_ordinal, history_table.scc_criteria_pid, history_table.scc_amount_description, history_table.scc_charge_payer_type, history_table.scc_charge_payee_type, history_table.scc_paid_by, history_table.scc_paid_to, history_table.scc_base_amount, history_table.scc_charge_input_type, history_table.scc_charge_input_type_percent, history_table.scc_charge_input_type_currency, history_table.scc_financed, history_table.scc_financed_auto_compute, history_table.scc_poc, history_table.scc_reduction_amount, history_table.scc_subtract_lenders_title_insurance_amount, history_table.scc_case_label, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
            FROM history_octane.smart_charge_case history_table
            LEFT JOIN staging_octane.smart_charge_case staging_table on staging_table.scc_pid = history_table.scc_pid
            WHERE staging_table.scc_pid is NULL
                AND not exists (select 1 from history_octane.smart_charge_case deleted_records where deleted_records.scc_pid = history_table.scc_pid and deleted_records.data_source_deleted_flag = True);')
         , ('loan',                 '--finding records to insert into history_octane.loan
SELECT staging_table.l_pid, staging_table.l_version, staging_table.l_proposal_pid, staging_table.l_offering_pid, staging_table.l_product_terms_pid, staging_table.l_mortgage_type, staging_table.l_interest_only_type, staging_table.l_buydown_schedule_type, staging_table.l_prepay_penalty_schedule_type, staging_table.l_aus_type, staging_table.l_arm_index_datetime, staging_table.l_arm_index_current_value_percent, staging_table.l_arm_margin_percent, staging_table.l_base_loan_amount, staging_table.l_buydown_contributor_type, staging_table.l_target_cash_out_amount, staging_table.l_heloc_maximum_balance_amount, staging_table.l_note_rate_percent, staging_table.l_initial_note_rate_percent, staging_table.l_lien_priority_type, staging_table.l_loan_amount, staging_table.l_financed_amount, staging_table.l_ltv_ratio_percent, staging_table.l_mi_requirement_ltv_ratio_percent, staging_table.l_mi_auto_compute, staging_table.l_mi_no_mi_product, staging_table.l_mi_input_type, staging_table.l_mi_company_name_type, staging_table.l_mi_certificate_id, staging_table.l_mi_premium_refundable_type, staging_table.l_mi_initial_calculation_type, staging_table.l_mi_renewal_calculation_type, staging_table.l_mi_payer_type, staging_table.l_mi_coverage_percent, staging_table.l_mi_ltv_cutoff_percent, staging_table.l_mi_midpoint_cutoff_required, staging_table.l_mi_required_monthly_payment_count, staging_table.l_mi_actual_monthly_payment_count, staging_table.l_mi_payment_type, staging_table.l_mi_upfront_amount, staging_table.l_mi_upfront_percent, staging_table.l_mi_initial_monthly_payment_amount, staging_table.l_mi_renewal_monthly_payment_annual_percent, staging_table.l_mi_renewal_monthly_payment_amount, staging_table.l_mi_initial_duration_months, staging_table.l_mi_initial_monthly_payment_annual_percent, staging_table.l_mi_initial_calculated_rate_type, staging_table.l_mi_renewal_calculated_rate_type, staging_table.l_mi_base_rate_label, staging_table.l_mi_base_monthly_payment_annual_percent, staging_table.l_mi_base_upfront_percent, staging_table.l_mi_base_monthly_payment_amount, staging_table.l_mi_base_upfront_payment_amount, staging_table.l_qualifying_rate_type, staging_table.l_qualifying_rate_input_percent, staging_table.l_qualifying_rate_percent, staging_table.l_fha_program_code_type, staging_table.l_fha_principal_write_down, staging_table.l_fhac_case_assignment_messages, staging_table.l_initial_pi_amount, staging_table.l_qualifying_pi_amount, staging_table.l_base_note_rate_percent, staging_table.l_base_arm_margin_percent, staging_table.l_base_price_percent, staging_table.l_lock_price_percent, staging_table.l_lock_duration_days, staging_table.l_lock_commitment_type, staging_table.l_product_choice_datetime, staging_table.l_hmda_purchaser_of_loan_2017_type, staging_table.l_hmda_purchaser_of_loan_2018_type, staging_table.l_texas_equity, staging_table.l_texas_equity_auto, staging_table.l_fnm_mbs_investor_contract_id, staging_table.l_base_guaranty_fee_basis_points, staging_table.l_guaranty_fee_basis_points, staging_table.l_guaranty_fee_after_alternate_payment_method_basis_points, staging_table.l_fnm_investor_product_plan_id, staging_table.l_uldd_loan_comment, staging_table.l_principal_curtailment_amount, staging_table.l_mi_lender_paid_rate_adjustment_percent, staging_table.l_apr, staging_table.l_finance_charge_amount, staging_table.l_apor_percent, staging_table.l_apor_date, staging_table.l_hmda_rate_spread_percent, staging_table.l_hoepa_apr, staging_table.l_hoepa_rate_spread, staging_table.l_hoepa_fees_dollar_amount, staging_table.l_hmda_hoepa_status_type, staging_table.l_rate_sheet_undiscounted_rate_percent, staging_table.l_effective_undiscounted_rate_percent, staging_table.l_last_unprocessed_changes_datetime, staging_table.l_locked_price_change_percent, staging_table.l_interest_rate_fee_change_amount, staging_table.l_lender_concession_candidate, staging_table.l_durp_eligibility_opt_out, staging_table.l_qualified_mortgage_status_type, staging_table.l_qualified_mortgage, staging_table.l_lqa_purchase_eligibility_type, staging_table.l_student_loan_cash_out_refinance, staging_table.l_mi_rate_quote_id, staging_table.l_mi_integration_vendor_request_pid, staging_table.l_secondary_clear_to_commit, staging_table.l_qm_eligible, staging_table.l_fha_endorsement_date, staging_table.l_va_guaranty_date, staging_table.l_usda_guarantee_date, staging_table.l_hpml, staging_table.l_qualified_mortgage_rule_version_type, staging_table.l_qualified_mortgage_apr, staging_table.l_qualified_mortgage_max_allowed_rate_spread, staging_table.l_buyup_buydown_basis_points, staging_table.l_va_agency_case_id,staging_table.l_fha_agency_case_id,staging_table.l_usda_agency_case_id,staging_table.l_va_agency_case_id_assigned_date,staging_table.l_fha_agency_case_id_assigned_date,staging_table.l_usda_agency_case_id_assigned_date,staging_table.l_post_interest_only_first_payment_date, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.loan staging_table
LEFT JOIN history_octane.loan history_table on staging_table.l_pid = history_table.l_pid and staging_table.l_version = history_table.l_version
WHERE history_table.l_pid is NULL
UNION ALL
SELECT history_table.l_pid, history_table.l_version+1, history_table.l_proposal_pid, history_table.l_offering_pid, history_table.l_product_terms_pid, history_table.l_mortgage_type, history_table.l_interest_only_type, history_table.l_buydown_schedule_type, history_table.l_prepay_penalty_schedule_type, history_table.l_aus_type, history_table.l_arm_index_datetime, history_table.l_arm_index_current_value_percent, history_table.l_arm_margin_percent, history_table.l_base_loan_amount, history_table.l_buydown_contributor_type, history_table.l_target_cash_out_amount, history_table.l_heloc_maximum_balance_amount, history_table.l_note_rate_percent, history_table.l_initial_note_rate_percent, history_table.l_lien_priority_type, history_table.l_loan_amount, history_table.l_financed_amount, history_table.l_ltv_ratio_percent, history_table.l_mi_requirement_ltv_ratio_percent, history_table.l_mi_auto_compute, history_table.l_mi_no_mi_product, history_table.l_mi_input_type, history_table.l_mi_company_name_type, history_table.l_mi_certificate_id, history_table.l_mi_premium_refundable_type, history_table.l_mi_initial_calculation_type, history_table.l_mi_renewal_calculation_type, history_table.l_mi_payer_type, history_table.l_mi_coverage_percent, history_table.l_mi_ltv_cutoff_percent, history_table.l_mi_midpoint_cutoff_required, history_table.l_mi_required_monthly_payment_count, history_table.l_mi_actual_monthly_payment_count, history_table.l_mi_payment_type, history_table.l_mi_upfront_amount, history_table.l_mi_upfront_percent, history_table.l_mi_initial_monthly_payment_amount, history_table.l_mi_renewal_monthly_payment_annual_percent, history_table.l_mi_renewal_monthly_payment_amount, history_table.l_mi_initial_duration_months, history_table.l_mi_initial_monthly_payment_annual_percent, history_table.l_mi_initial_calculated_rate_type, history_table.l_mi_renewal_calculated_rate_type, history_table.l_mi_base_rate_label, history_table.l_mi_base_monthly_payment_annual_percent, history_table.l_mi_base_upfront_percent, history_table.l_mi_base_monthly_payment_amount, history_table.l_mi_base_upfront_payment_amount, history_table.l_qualifying_rate_type, history_table.l_qualifying_rate_input_percent, history_table.l_qualifying_rate_percent, history_table.l_fha_program_code_type, history_table.l_fha_principal_write_down, history_table.l_fhac_case_assignment_messages, history_table.l_initial_pi_amount, history_table.l_qualifying_pi_amount, history_table.l_base_note_rate_percent, history_table.l_base_arm_margin_percent, history_table.l_base_price_percent, history_table.l_lock_price_percent, history_table.l_lock_duration_days, history_table.l_lock_commitment_type, history_table.l_product_choice_datetime, history_table.l_hmda_purchaser_of_loan_2017_type, history_table.l_hmda_purchaser_of_loan_2018_type, history_table.l_texas_equity, history_table.l_texas_equity_auto, history_table.l_fnm_mbs_investor_contract_id, history_table.l_base_guaranty_fee_basis_points, history_table.l_guaranty_fee_basis_points, history_table.l_guaranty_fee_after_alternate_payment_method_basis_points, history_table.l_fnm_investor_product_plan_id, history_table.l_uldd_loan_comment, history_table.l_principal_curtailment_amount, history_table.l_mi_lender_paid_rate_adjustment_percent, history_table.l_apr, history_table.l_finance_charge_amount, history_table.l_apor_percent, history_table.l_apor_date, history_table.l_hmda_rate_spread_percent, history_table.l_hoepa_apr, history_table.l_hoepa_rate_spread, history_table.l_hoepa_fees_dollar_amount, history_table.l_hmda_hoepa_status_type, history_table.l_rate_sheet_undiscounted_rate_percent, history_table.l_effective_undiscounted_rate_percent, history_table.l_last_unprocessed_changes_datetime, history_table.l_locked_price_change_percent, history_table.l_interest_rate_fee_change_amount, history_table.l_lender_concession_candidate, history_table.l_durp_eligibility_opt_out, history_table.l_qualified_mortgage_status_type, history_table.l_qualified_mortgage, history_table.l_lqa_purchase_eligibility_type, history_table.l_student_loan_cash_out_refinance, history_table.l_mi_rate_quote_id, history_table.l_mi_integration_vendor_request_pid, history_table.l_secondary_clear_to_commit, history_table.l_qm_eligible, history_table.l_fha_endorsement_date, history_table.l_va_guaranty_date, history_table.l_usda_guarantee_date, history_table.l_hpml, history_table.l_qualified_mortgage_rule_version_type, history_table.l_qualified_mortgage_apr, history_table.l_qualified_mortgage_max_allowed_rate_spread, history_table.l_buyup_buydown_basis_points, history_table.l_va_agency_case_id,history_table.l_fha_agency_case_id,history_table.l_usda_agency_case_id,history_table.l_va_agency_case_id_assigned_date,history_table.l_fha_agency_case_id_assigned_date,history_table.l_usda_agency_case_id_assigned_date,history_table.l_post_interest_only_first_payment_date, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM history_octane.loan history_table
LEFT JOIN staging_octane.loan staging_table on staging_table.l_pid = history_table.l_pid
WHERE staging_table.l_pid is NULL
AND not exists (select 1 from history_octane.loan deleted_records where deleted_records.l_pid = history_table.l_pid and deleted_records.data_source_deleted_flag = TRUE );')
         , ('proposal_summary',     'SELECT staging_table.ps_pid, staging_table.ps_version, staging_table.ps_proposal_pid, staging_table.ps_subject_property_city, staging_table.ps_subject_property_country, staging_table.ps_subject_property_postal_code, staging_table.ps_subject_property_state, staging_table.ps_subject_property_street1, staging_table.ps_subject_property_street2, staging_table.ps_note_rate_percent_main, staging_table.ps_note_rate_percent_piggyback, staging_table.ps_initial_note_rate_percent_main, staging_table.ps_initial_note_rate_percent_piggyback, staging_table.ps_base_loan_amount_main, staging_table.ps_base_loan_amount_piggyback, staging_table.ps_loan_amount_main, staging_table.ps_loan_amount_piggyback, staging_table.ps_product_special_program_type_main, staging_table.ps_product_special_program_type_piggyback, staging_table.ps_investor_pid_main, staging_table.ps_investor_pid_piggyback, staging_table.ps_product_fnm_community_lending_product_type_main, staging_table.ps_product_fnm_community_lending_product_type_piggyback, staging_table.ps_product_fre_community_program_type_main, staging_table.ps_product_fre_community_program_type_piggyback, staging_table.ps_mortgage_type_main, staging_table.ps_mortgage_type_piggyback, staging_table.ps_b1_first_name, staging_table.ps_c1_first_name, staging_table.ps_b2_first_name, staging_table.ps_b1_last_name, staging_table.ps_c1_last_name, staging_table.ps_b2_last_name, staging_table.ps_b1_middle_name, staging_table.ps_c1_middle_name, staging_table.ps_b2_middle_name, staging_table.ps_b1_preferred_first_name, staging_table.ps_b2_preferred_first_name, staging_table.ps_c1_preferred_first_name, staging_table.ps_b1_birth_date, staging_table.ps_c1_birth_date, staging_table.ps_b1_monthly_income, staging_table.ps_c1_monthly_income, staging_table.ps_b2_monthly_income, staging_table.ps_b1_has_business_income, staging_table.ps_c1_has_business_income, staging_table.ps_b2_has_business_income, staging_table.ps_b1_citizenship_residency_type, staging_table.ps_c1_citizenship_residency_type, staging_table.ps_b2_citizenship_residency_type, staging_table.ps_b1_hmda_ethnicity_2017_type, staging_table.ps_c1_hmda_ethnicity_2017_type, staging_table.ps_b2_hmda_ethnicity_2017_type, staging_table.ps_b1_decision_credit_score, staging_table.ps_c1_decision_credit_score, staging_table.ps_b2_decision_credit_score, staging_table.ps_b1_gender_type, staging_table.ps_c1_gender_type, staging_table.ps_b2_gender_type, staging_table.ps_b1_hmda_race_2017_type, staging_table.ps_c1_hmda_race_2017_type, staging_table.ps_b2_hmda_race_2017_type, staging_table.ps_any_lender_employee_borrower, staging_table.ps_upfront_mi_percent_main, staging_table.ps_upfront_mi_percent_piggyback, staging_table.ps_primary_application_name, staging_table.ps_investor_loan_id_main, staging_table.ps_investor_loan_id_piggyback, staging_table.ps_initial_servicer_investor_loan_id_main, staging_table.ps_initial_servicer_investor_loan_id_piggyback, staging_table.ps_current_servicer_investor_loan_id_main, staging_table.ps_current_servicer_investor_loan_id_piggyback, staging_table.ps_offering_id_main, staging_table.ps_offering_id_piggyback, staging_table.ps_proposal_structure_type, staging_table.ps_loan_maturity_date_main, staging_table.ps_loan_maturity_date_piggyback, staging_table.ps_ltv_ratio_percent_main, staging_table.ps_ltv_ratio_percent_piggyback, staging_table.ps_cltv_ratio_percent, staging_table.ps_hcltv_ratio_percent, staging_table.ps_hcltv_applicable, staging_table.ps_debt_ratio_percent, staging_table.ps_housing_ratio_percent, staging_table.ps_property_category_type, staging_table.ps_any_first_time_home_buyer, staging_table.ps_primary_housing_expense_amount, staging_table.ps_non_primary_housing_expense_amount, staging_table.ps_income_monthly_total_amount, staging_table.ps_asset_total_amount, staging_table.ps_liquid_asset_total_amount, staging_table.ps_liability_unpaid_balance_total_amount, staging_table.ps_liability_monthly_payment_total_amount, staging_table.ps_monthly_pitia_amount, staging_table.ps_cash_from_borrower_amount_signed, staging_table.ps_proposed_monthly_housing_and_debt_amount, staging_table.ps_funding_date_main, staging_table.ps_funding_date_piggyback, staging_table.ps_interim_funder_company_name, staging_table.ps_interim_funder_mers_org_id, staging_table.ps_funding_scheduled_release_date_main, staging_table.ps_funding_scheduled_release_date_piggyback, staging_table.ps_uuts_aus_recommendation_description, staging_table.ps_interest_rate_fee_amount_signed, staging_table.ps_interest_rate_fee_amount_signed_main, staging_table.ps_interest_rate_fee_amount_signed_piggyback, staging_table.ps_origination_fees_amount_signed, staging_table.ps_origination_fees_amount_signed_main, staging_table.ps_origination_fees_amount_signed_piggyback, staging_table.ps_any_escrow_waived, staging_table.ps_initial_rate_adjustment_date_main, staging_table.ps_initial_rate_adjustment_date_piggyback, staging_table.ps_tolerance_cure_amount_signed, staging_table.ps_tolerance_cure_amount_signed_main, staging_table.ps_tolerance_cure_amount_signed_piggyback, staging_table.ps_subject_property_existing_subordinate_2nd, staging_table.ps_subject_property_subordinate_2nd_creditor_pid, staging_table.ps_subject_property_existing_subordinate_3rd, staging_table.ps_subject_property_subordinate_3rd_creditor_pid, staging_table.ps_total_monthly_solar_lease_payments_amount, staging_table.ps_total_debt_payoff_amount, staging_table.ps_total_new_subordinate_financing_amount, staging_table.ps_total_grant_amount, staging_table.ps_any_third_party_community_second, staging_table.ps_any_grant_program, staging_table.ps_initial_loan_estimate_loan_amount_main, staging_table.ps_initial_loan_estimate_loan_amount_piggyback, staging_table.ps_any_mortgage_credit_certificate, staging_table.ps_debt_ratio_excluding_mi_percent, staging_table.ps_fund_source_type_main, staging_table.ps_fund_source_type_piggyback, staging_table.ps_mortgage_credit_certificate_issuer_pid, staging_table.ps_subject_property_new_subordinate_2nd, staging_table.ps_subject_property_new_subordinate_3rd, staging_table.ps_any_borrower_self_employed, staging_table.ps_fha_section_of_act_coarse_type_main, staging_table.ps_fha_section_of_act_coarse_type_piggyback, staging_table.ps_fha_special_program_type_main, staging_table.ps_fha_special_program_type_piggyback, staging_table.ps_product_pid_main, staging_table.ps_product_pid_piggyback, staging_table.ps_net_origination_charge_main, staging_table.ps_net_origination_charge_piggyback, staging_table.ps_household_income_guideline_percent, staging_table.ps_applicant_count, staging_table.ps_early_wire_total_charge_amount_main, staging_table.ps_early_wire_total_charge_amount_piggyback, staging_table.ps_funding_scheduled_release_date_auto_compute_main, staging_table.ps_funding_scheduled_release_date_auto_compute_piggyback, staging_table.ps_any_hoa_certification_fee, staging_table.ps_effective_agency_case_id_main,staging_table.ps_effective_agency_case_id_piggyback,staging_table.ps_effective_agency_case_id_assigned_date_main,staging_table.ps_effective_agency_case_id_assigned_date_piggyback, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.proposal_summary staging_table
LEFT JOIN history_octane.proposal_summary history_table on staging_table.ps_pid = history_table.ps_pid and staging_table.ps_version = history_table.ps_version
WHERE history_table.ps_pid is NULL
UNION ALL
SELECT history_table.ps_pid, history_table.ps_version+1, history_table.ps_proposal_pid, history_table.ps_subject_property_city, history_table.ps_subject_property_country, history_table.ps_subject_property_postal_code, history_table.ps_subject_property_state, history_table.ps_subject_property_street1, history_table.ps_subject_property_street2, history_table.ps_note_rate_percent_main, history_table.ps_note_rate_percent_piggyback, history_table.ps_initial_note_rate_percent_main, history_table.ps_initial_note_rate_percent_piggyback, history_table.ps_base_loan_amount_main, history_table.ps_base_loan_amount_piggyback, history_table.ps_loan_amount_main, history_table.ps_loan_amount_piggyback, history_table.ps_product_special_program_type_main, history_table.ps_product_special_program_type_piggyback, history_table.ps_investor_pid_main, history_table.ps_investor_pid_piggyback, history_table.ps_product_fnm_community_lending_product_type_main, history_table.ps_product_fnm_community_lending_product_type_piggyback, history_table.ps_product_fre_community_program_type_main, history_table.ps_product_fre_community_program_type_piggyback, history_table.ps_mortgage_type_main, history_table.ps_mortgage_type_piggyback, history_table.ps_b1_first_name, history_table.ps_c1_first_name, history_table.ps_b2_first_name, history_table.ps_b1_last_name, history_table.ps_c1_last_name, history_table.ps_b2_last_name, history_table.ps_b1_middle_name, history_table.ps_c1_middle_name, history_table.ps_b2_middle_name, history_table.ps_b1_preferred_first_name, history_table.ps_b2_preferred_first_name, history_table.ps_c1_preferred_first_name, history_table.ps_b1_birth_date, history_table.ps_c1_birth_date, history_table.ps_b1_monthly_income, history_table.ps_c1_monthly_income, history_table.ps_b2_monthly_income, history_table.ps_b1_has_business_income, history_table.ps_c1_has_business_income, history_table.ps_b2_has_business_income, history_table.ps_b1_citizenship_residency_type, history_table.ps_c1_citizenship_residency_type, history_table.ps_b2_citizenship_residency_type, history_table.ps_b1_hmda_ethnicity_2017_type, history_table.ps_c1_hmda_ethnicity_2017_type, history_table.ps_b2_hmda_ethnicity_2017_type, history_table.ps_b1_decision_credit_score, history_table.ps_c1_decision_credit_score, history_table.ps_b2_decision_credit_score, history_table.ps_b1_gender_type, history_table.ps_c1_gender_type, history_table.ps_b2_gender_type, history_table.ps_b1_hmda_race_2017_type, history_table.ps_c1_hmda_race_2017_type, history_table.ps_b2_hmda_race_2017_type, history_table.ps_any_lender_employee_borrower, history_table.ps_upfront_mi_percent_main, history_table.ps_upfront_mi_percent_piggyback, history_table.ps_primary_application_name, history_table.ps_investor_loan_id_main, history_table.ps_investor_loan_id_piggyback, history_table.ps_initial_servicer_investor_loan_id_main, history_table.ps_initial_servicer_investor_loan_id_piggyback, history_table.ps_current_servicer_investor_loan_id_main, history_table.ps_current_servicer_investor_loan_id_piggyback, history_table.ps_offering_id_main, history_table.ps_offering_id_piggyback, history_table.ps_proposal_structure_type, history_table.ps_loan_maturity_date_main, history_table.ps_loan_maturity_date_piggyback, history_table.ps_ltv_ratio_percent_main, history_table.ps_ltv_ratio_percent_piggyback, history_table.ps_cltv_ratio_percent, history_table.ps_hcltv_ratio_percent, history_table.ps_hcltv_applicable, history_table.ps_debt_ratio_percent, history_table.ps_housing_ratio_percent, history_table.ps_property_category_type, history_table.ps_any_first_time_home_buyer, history_table.ps_primary_housing_expense_amount, history_table.ps_non_primary_housing_expense_amount, history_table.ps_income_monthly_total_amount, history_table.ps_asset_total_amount, history_table.ps_liquid_asset_total_amount, history_table.ps_liability_unpaid_balance_total_amount, history_table.ps_liability_monthly_payment_total_amount, history_table.ps_monthly_pitia_amount, history_table.ps_cash_from_borrower_amount_signed, history_table.ps_proposed_monthly_housing_and_debt_amount, history_table.ps_funding_date_main, history_table.ps_funding_date_piggyback, history_table.ps_interim_funder_company_name, history_table.ps_interim_funder_mers_org_id, history_table.ps_funding_scheduled_release_date_main, history_table.ps_funding_scheduled_release_date_piggyback, history_table.ps_uuts_aus_recommendation_description, history_table.ps_interest_rate_fee_amount_signed, history_table.ps_interest_rate_fee_amount_signed_main, history_table.ps_interest_rate_fee_amount_signed_piggyback, history_table.ps_origination_fees_amount_signed, history_table.ps_origination_fees_amount_signed_main, history_table.ps_origination_fees_amount_signed_piggyback, history_table.ps_any_escrow_waived, history_table.ps_initial_rate_adjustment_date_main, history_table.ps_initial_rate_adjustment_date_piggyback, history_table.ps_tolerance_cure_amount_signed, history_table.ps_tolerance_cure_amount_signed_main, history_table.ps_tolerance_cure_amount_signed_piggyback, history_table.ps_subject_property_existing_subordinate_2nd, history_table.ps_subject_property_subordinate_2nd_creditor_pid, history_table.ps_subject_property_existing_subordinate_3rd, history_table.ps_subject_property_subordinate_3rd_creditor_pid, history_table.ps_total_monthly_solar_lease_payments_amount, history_table.ps_total_debt_payoff_amount, history_table.ps_total_new_subordinate_financing_amount, history_table.ps_total_grant_amount, history_table.ps_any_third_party_community_second, history_table.ps_any_grant_program, history_table.ps_initial_loan_estimate_loan_amount_main, history_table.ps_initial_loan_estimate_loan_amount_piggyback, history_table.ps_any_mortgage_credit_certificate, history_table.ps_debt_ratio_excluding_mi_percent, history_table.ps_fund_source_type_main, history_table.ps_fund_source_type_piggyback, history_table.ps_mortgage_credit_certificate_issuer_pid, history_table.ps_subject_property_new_subordinate_2nd, history_table.ps_subject_property_new_subordinate_3rd, history_table.ps_any_borrower_self_employed, history_table.ps_fha_section_of_act_coarse_type_main, history_table.ps_fha_section_of_act_coarse_type_piggyback, history_table.ps_fha_special_program_type_main, history_table.ps_fha_special_program_type_piggyback, history_table.ps_product_pid_main, history_table.ps_product_pid_piggyback, history_table.ps_net_origination_charge_main, history_table.ps_net_origination_charge_piggyback, history_table.ps_household_income_guideline_percent, history_table.ps_applicant_count, history_table.ps_early_wire_total_charge_amount_main, history_table.ps_early_wire_total_charge_amount_piggyback, history_table.ps_funding_scheduled_release_date_auto_compute_main, history_table.ps_funding_scheduled_release_date_auto_compute_piggyback, history_table.ps_any_hoa_certification_fee, history_table.ps_effective_agency_case_id_main,history_table.ps_effective_agency_case_id_piggyback,history_table.ps_effective_agency_case_id_assigned_date_main,history_table.ps_effective_agency_case_id_assigned_date_piggyback, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM history_octane.proposal_summary history_table
LEFT JOIN staging_octane.proposal_summary staging_table on staging_table.ps_pid = history_table.ps_pid
WHERE staging_table.ps_pid is NULL
  AND not exists (select 1 from history_octane.proposal_summary deleted_records where deleted_records.ps_pid = history_table.ps_pid and deleted_records.data_source_deleted_flag = True);')
         , ('loan_funding',         '
            --finding records to insert into hitory_octane.loan_funding
            SELECT staging_table.lf_pid, staging_table.lf_version, staging_table.lf_loan_pid, staging_table.lf_interim_funder_pid, staging_table.lf_proposal_snapshot_pid, staging_table.lf_interim_funder_loan_id, staging_table.lf_funding_status_type, staging_table.lf_requested_date, staging_table.lf_confirmed_release_datetime, staging_table.lf_wire_amount, staging_table.lf_interim_funder_fee_amount, staging_table.lf_release_wire_federal_reference_number, staging_table.lf_disbursement_date, staging_table.lf_return_request_date, staging_table.lf_return_confirmed_date, staging_table.lf_funds_authorization_code, staging_table.lf_scheduled_release_date, staging_table.lf_funds_authorized_datetime, staging_table.lf_funding_date, staging_table.lf_collateral_sent_date, staging_table.lf_collateral_tracking_number, staging_table.lf_collateral_courier_type, staging_table.lf_post_wire_adjustment_amount, staging_table.lf_net_wire_amount, staging_table.lf_early_wire_charge_day_count, staging_table.lf_early_wire_daily_charge_amount, staging_table.lf_early_wire_total_charge_amount, staging_table.lf_scheduled_release_date_auto_compute, staging_table.lf_early_wire_request, staging_table.lf_synthetic_unique_active, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
            FROM staging_octane.loan_funding staging_table
            LEFT JOIN history_octane.loan_funding history_table on staging_table.lf_pid = history_table.lf_pid and staging_table.lf_version = history_table.lf_version
            WHERE history_table.lf_pid is NULL
            UNION ALL
            SELECT history_table.lf_pid, history_table.lf_version+1, history_table.lf_loan_pid, history_table.lf_interim_funder_pid, history_table.lf_proposal_snapshot_pid, history_table.lf_interim_funder_loan_id, history_table.lf_funding_status_type, history_table.lf_requested_date, history_table.lf_confirmed_release_datetime, history_table.lf_wire_amount, history_table.lf_interim_funder_fee_amount, history_table.lf_release_wire_federal_reference_number, history_table.lf_disbursement_date, history_table.lf_return_request_date, history_table.lf_return_confirmed_date, history_table.lf_funds_authorization_code, history_table.lf_scheduled_release_date, history_table.lf_funds_authorized_datetime, history_table.lf_funding_date, history_table.lf_collateral_sent_date, history_table.lf_collateral_tracking_number, history_table.lf_collateral_courier_type, history_table.lf_post_wire_adjustment_amount, history_table.lf_net_wire_amount, history_table.lf_early_wire_charge_day_count, history_table.lf_early_wire_daily_charge_amount, history_table.lf_early_wire_total_charge_amount, history_table.lf_scheduled_release_date_auto_compute, history_table.lf_early_wire_request, history_table.lf_synthetic_unique_active, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
            FROM history_octane.loan_funding history_table
            LEFT JOIN staging_octane.loan_funding staging_table on staging_table.lf_pid = history_table.lf_pid
            WHERE staging_table.lf_pid is NULL
                AND not exists (select 1 from history_octane.loan_funding deleted_records where deleted_records.lf_pid = history_table.lf_pid and deleted_records.data_source_deleted_flag = True);')
         , ('lender_user',          '
            --finding records to insert into hitory_octane.lender_user
            SELECT staging_table.lu_pid, staging_table.lu_version, staging_table.lu_branch_pid, staging_table.lu_account_owner, staging_table.lu_account_pid, staging_table.lu_create_date, staging_table.lu_first_name, staging_table.lu_last_name, staging_table.lu_middle_name, staging_table.lu_name_suffix, staging_table.lu_company_name, staging_table.lu_title, staging_table.lu_office_phone, staging_table.lu_office_phone_extension, staging_table.lu_email, staging_table.lu_fax, staging_table.lu_city, staging_table.lu_country, staging_table.lu_postal_code, staging_table.lu_state, staging_table.lu_street1, staging_table.lu_street2, staging_table.lu_office_phone_use_branch, staging_table.lu_fax_use_branch, staging_table.lu_address_use_branch, staging_table.lu_start_date, staging_table.lu_through_date, staging_table.lu_time_zone, staging_table.lu_unparsed_name, staging_table.lu_lender_user_status_type, staging_table.lu_username, staging_table.lu_nmls_loan_originator_id, staging_table.lu_fha_chums_id, staging_table.lu_va_agent_id, staging_table.lu_search_text, staging_table.lu_company_user_id, staging_table.lu_force_password_change, staging_table.lu_last_password_change_date, staging_table.lu_challenge_question_type, staging_table.lu_challenge_question_answer, staging_table.lu_allow_external_ip, staging_table.lu_total_workload_cap, staging_table.lu_schedule_once_booking_page_id, staging_table.lu_performer_team_pid, staging_table.lu_esign_only, staging_table.lu_work_step_start_notices_enabled, staging_table.lu_smart_app_enabled, staging_table.lu_default_lead_source_pid, staging_table.lu_default_credit_bureau_type, staging_table.lu_originator_id, staging_table.lu_name_qualifier, staging_table.lu_training_mode, staging_table.lu_about_me, staging_table.lu_lender_user_type, staging_table.lu_hire_date, staging_table.lu_mercury_client_group_pid, staging_table.lu_nickname, staging_table.lu_preferred_first_name, staging_table.lu_hub_directory, staging_table.lu_email_signature_title,staging_table.lu_termination_date, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
            FROM staging_octane.lender_user staging_table
            LEFT JOIN history_octane.lender_user history_table on staging_table.lu_pid = history_table.lu_pid and staging_table.lu_version = history_table.lu_version
            WHERE history_table.lu_pid is NULL
            UNION ALL
            SELECT history_table.lu_pid, history_table.lu_version+1, history_table.lu_branch_pid, history_table.lu_account_owner, history_table.lu_account_pid, history_table.lu_create_date, history_table.lu_first_name, history_table.lu_last_name, history_table.lu_middle_name, history_table.lu_name_suffix, history_table.lu_company_name, history_table.lu_title, history_table.lu_office_phone, history_table.lu_office_phone_extension, history_table.lu_email, history_table.lu_fax, history_table.lu_city, history_table.lu_country, history_table.lu_postal_code, history_table.lu_state, history_table.lu_street1, history_table.lu_street2, history_table.lu_office_phone_use_branch, history_table.lu_fax_use_branch, history_table.lu_address_use_branch, history_table.lu_start_date, history_table.lu_through_date, history_table.lu_time_zone, history_table.lu_unparsed_name, history_table.lu_lender_user_status_type, history_table.lu_username, history_table.lu_nmls_loan_originator_id, history_table.lu_fha_chums_id, history_table.lu_va_agent_id, history_table.lu_search_text, history_table.lu_company_user_id, history_table.lu_force_password_change, history_table.lu_last_password_change_date, history_table.lu_challenge_question_type, history_table.lu_challenge_question_answer, history_table.lu_allow_external_ip, history_table.lu_total_workload_cap, history_table.lu_schedule_once_booking_page_id, history_table.lu_performer_team_pid, history_table.lu_esign_only, history_table.lu_work_step_start_notices_enabled, history_table.lu_smart_app_enabled, history_table.lu_default_lead_source_pid, history_table.lu_default_credit_bureau_type, history_table.lu_originator_id, history_table.lu_name_qualifier, history_table.lu_training_mode, history_table.lu_about_me, history_table.lu_lender_user_type, history_table.lu_hire_date, history_table.lu_mercury_client_group_pid, history_table.lu_nickname, history_table.lu_preferred_first_name, history_table.lu_hub_directory, history_table.lu_email_signature_title,history_table.lu_termination_date, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
            FROM history_octane.lender_user history_table
            LEFT JOIN staging_octane.lender_user staging_table on staging_table.lu_pid = history_table.lu_pid
            WHERE staging_table.lu_pid is NULL
                AND not exists (select 1 from history_octane.lender_user deleted_records where deleted_records.lu_pid = history_table.lu_pid and deleted_records.data_source_deleted_flag = True);')
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

select 'Done removing fields from ETLs and metadata tables:
staging_octane.loan
    l_agency_case_id
    l_agency_case_id_assigned_date';



/*
Created Tables:
staging_octane.smart_message_permission_type
    code
    value
history_octane.smart_message_permission_type
    code
    value
    data_source_updated_datetime
    data_source_deleted_flag

staging_octane.smart_message_permission
    smp_pid
    smp_version
    smp_smart_message_pid
    smp_role_pid
    smp_permission_type
history_octane.smart_message_permission
    smp_pid
    smp_version
    smp_smart_message_pid
    smp_role_pid
    smp_permission_type
    data_source_updated_datetime
    data_source_deleted_flag

staging_octane.wf_deal_step_performer_unavailable
    wdspu_pid
    wdspu_version
    wdspu_lender_user_pid
    wdspu_wf_deal_step_pid
    wdspu_days_unavailable
history_octane.wf_deal_step_performer_unavailable
    wdspu_pid
    wdspu_version
    wdspu_lender_user_pid
    wdspu_wf_deal_step_pid
    wdspu_days_unavailable
    data_source_updated_datetime
    data_source_deleted_flag
 */


-- Insert metadata for new tables: wf_deal_step_performer_unavailable, smart_message_permission, smart_message_permission_type
WITH new_staging_table_definitions AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'smart_message_permission_type', NULL)
             , ('staging', 'staging_octane', 'smart_message_permission', NULL)
             , ('staging', 'staging_octane', 'wf_deal_step_performer_unavailable', NULL)
        RETURNING dwid, table_name
)

    , new_history_table_definitions AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        SELECT 'staging'
            , 'history_octane'
            , new_staging_table_definitions.table_name
            , new_staging_table_definitions.dwid
        FROM new_staging_table_definitions
        RETURNING dwid, table_name
)

    , new_fields (schema_name, table_name, field_name, key_field_flag, field_order) AS (
    VALUES ('staging_octane', 'smart_message_permission_type', 'code', TRUE, NULL)
         , ('staging_octane', 'smart_message_permission_type', 'value', FALSE, NULL)
         , ('history_octane', 'smart_message_permission_type', 'code', FALSE, 1)
         , ('history_octane', 'smart_message_permission_type', 'value', FALSE, 2)
         , ('history_octane', 'smart_message_permission_type', 'data_source_updated_datetime', FALSE, 3)
         , ('history_octane', 'smart_message_permission_type', 'data_source_deleted_flag', FALSE, 4)

         , ('staging_octane', 'smart_message_permission', 'smp_pid', FALSE, NULL)
         , ('staging_octane', 'smart_message_permission', 'smp_version', FALSE, NULL)
         , ('staging_octane', 'smart_message_permission', 'smp_smart_message_pid', FALSE, NULL)
         , ('staging_octane', 'smart_message_permission', 'smp_role_pid', FALSE, NULL)
         , ('staging_octane', 'smart_message_permission', 'smp_permission_type', FALSE, NULL)
         , ('history_octane', 'smart_message_permission', 'smp_pid', FALSE, 1)
         , ('history_octane', 'smart_message_permission', 'smp_version', FALSE, 2)
         , ('history_octane', 'smart_message_permission', 'smp_smart_message_pid', FALSE, 3)
         , ('history_octane', 'smart_message_permission', 'smp_role_pid', FALSE, 4)
         , ('history_octane', 'smart_message_permission', 'smp_permission_type', TRUE, 5)
         , ('history_octane', 'smart_message_permission', 'data_source_updated_datetime', FALSE, 6)
         , ('history_octane', 'smart_message_permission', 'data_source_deleted_flag', FALSE, 7)

         , ('staging_octane', 'wf_deal_step_performer_unavailable', 'wdspu_pid', FALSE, NULL)
         , ('staging_octane', 'wf_deal_step_performer_unavailable', 'wdspu_version', FALSE, NULL)
         , ('staging_octane', 'wf_deal_step_performer_unavailable', 'wdspu_lender_user_pid', FALSE, NULL)
         , ('staging_octane', 'wf_deal_step_performer_unavailable', 'wdspu_wf_deal_step_pid', FALSE, NULL)
         , ('staging_octane', 'wf_deal_step_performer_unavailable', 'wdspu_days_unavailable', FALSE, NULL)
         , ('history_octane', 'wf_deal_step_performer_unavailable', 'wdspu_pid', FALSE, 1)
         , ('history_octane', 'wf_deal_step_performer_unavailable', 'wdspu_version', FALSE, 2)
         , ('history_octane', 'wf_deal_step_performer_unavailable', 'wdspu_lender_user_pid', FALSE, 3)
         , ('history_octane', 'wf_deal_step_performer_unavailable', 'wdspu_wf_deal_step_pid', FALSE, 4)
         , ('history_octane', 'wf_deal_step_performer_unavailable', 'wdspu_days_unavailable', FALSE, 5)
         , ('history_octane', 'wf_deal_step_performer_unavailable', 'data_source_updated_datetime', FALSE, 6)
         , ('history_octane', 'wf_deal_step_performer_unavailable', 'data_source_deleted_flag', FALSE, 7)
)

    , new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT new_staging_table_definitions.dwid, new_fields.field_name, new_fields.key_field_flag
        FROM new_fields
            JOIN new_staging_table_definitions
                ON new_fields.table_name = new_staging_table_definitions.table_name
        WHERE new_fields.schema_name = 'staging_octane'
        RETURNING dwid, edw_table_definition_dwid, field_name
)

    , new_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag,
                                          source_edw_field_definition_dwid)
        SELECT new_history_table_definitions.dwid
            , new_fields.field_name
            , new_fields.key_field_flag
            , new_staging_field_definitions.dwid
        FROM new_fields
            JOIN new_staging_table_definitions
                ON new_fields.table_name = new_staging_table_definitions.table_name
            JOIN new_history_table_definitions
                ON new_fields.table_name = new_history_table_definitions.table_name
            LEFT JOIN new_staging_field_definitions
                ON new_staging_table_definitions.dwid =
                   new_staging_field_definitions.edw_table_definition_dwid
                    AND new_fields.field_name = new_staging_field_definitions.field_name
        WHERE new_fields.schema_name = 'history_octane'
)

    , new_process_variables (name, target_table, json_output_field, sql) AS (
    VALUES ('SP-100862', 'smart_message_permission_type', 'code', 'SELECT staging_table.code, staging_table.value, FALSE AS data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.smart_message_permission_type staging_table
    LEFT JOIN history_octane.smart_message_permission_type history_table on staging_table.code = history_table.code AND staging_table.value = history_table.value
WHERE history_table.code IS NULL')
         , ('SP-100861', 'wf_deal_step_performer_unavailable', 'wdspu_pid', '--finding records to insert into history_octane.wf_deal_step_performer_unavailable
SELECT staging_table.wdspu_pid
, staging_table.wdspu_version
, staging_table.wdspu_lender_user_pid
, staging_table.wdspu_wf_deal_step_pid
, staging_table.wdspu_days_unavailable
, FALSE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM staging_octane.wf_deal_step_performer_unavailable staging_table
    LEFT JOIN history_octane.wf_deal_step_performer_unavailable history_table
        ON staging_table.wdspu_pid = history_table.wdspu_pid AND staging_table.wdspu_version = history_table.wdspu_version
WHERE history_table.wdspu_pid IS NULL
UNION ALL
SELECT history_table.wdspu_pid
, history_table.wdspu_version + 1
, history_table.wdspu_lender_user_pid
, history_table.wdspu_wf_deal_step_pid
, history_table.wdspu_days_unavailable
, TRUE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM history_octane.wf_deal_step_performer_unavailable history_table
    LEFT JOIN staging_octane.wf_deal_step_performer_unavailable staging_table
        ON staging_table.wdspu_pid = history_table.wdspu_pid
WHERE staging_table.wdspu_pid IS NULL
    AND NOT EXISTS( SELECT 1
                    FROM history_octane.wf_deal_step_performer_unavailable deleted_records
                    WHERE deleted_records.wdspu_pid = history_table.wdspu_pid AND deleted_records.data_source_deleted_flag = TRUE );')
         , ('SP-100860', 'smart_message_permission', 'smp_pid', '--finding records to insert into history_octane.smart_message_permission
SELECT staging_table.smp_pid
, staging_table.smp_version
, staging_table.smp_smart_message_pid
, staging_table.smp_role_pid
, staging_table.smp_permission_type
, FALSE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_message_permission staging_table
    LEFT JOIN history_octane.smart_message_permission history_table
        ON staging_table.smp_pid = history_table.smp_pid AND staging_table.smp_version = history_table.smp_version
WHERE history_table.smp_pid IS NULL
UNION ALL
SELECT history_table.smp_pid
, history_table.smp_version + 1
, history_table.smp_smart_message_pid
, history_table.smp_role_pid
, history_table.smp_permission_type
, TRUE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM history_octane.smart_message_permission history_table
    LEFT JOIN staging_octane.smart_message_permission staging_table
        ON staging_table.smp_pid = history_table.smp_pid
WHERE staging_table.smp_pid IS NULL
    AND NOT EXISTS( SELECT 1
                    FROM history_octane.smart_message_permission deleted_records
                    WHERE deleted_records.smp_pid = history_table.smp_pid AND deleted_records.data_source_deleted_flag = TRUE );')
)
    , new_processes AS (
    INSERT INTO mdi.process (name, description)
        SELECT new_process_variables.name
            , 'ETL to copy ' || new_process_variables.target_table || ' data from staging_octane to history_octane'
        FROM new_process_variables
        RETURNING dwid, name, description
)

    , new_table_input_steps AS (
    INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables,
                                      enable_lazy_conversion, cached_row_meta, connectionname)
        SELECT new_processes.dwid
            , 0
            , new_process_variables.sql
            , 0
            , 'N'
            , 'N'
            , 'N'
            , 'N'
            , 'Staging DB Connection'
        FROM new_processes
            JOIN new_process_variables
                ON new_processes.name = new_process_variables.name
)

    , new_table_output_steps AS (
    INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field,
                                       auto_generated_key_field, partition_data_per, table_name_defined_in_field,
                                       return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables,
                                       specify_database_fields, ignore_insert_errors, use_batch_update)
        SELECT new_processes.dwid
            , 'history_octane'
            , new_process_variables.target_table
            , 1000
            , NULL
            , NULL
            , NULL
            , NULL
            , 'N'
            , NULL
            , 'N'
            , 'Staging DB Connection'
            , 'N'
            , 'Y'
            , 'N'
            , 'N'
        FROM new_processes
            JOIN new_process_variables
                ON new_processes.name = new_process_variables.name
        RETURNING dwid, target_schema, target_table
)

    , new_table_output_fields AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
        SELECT new_table_output_steps.dwid
            , new_fields.field_name
            , new_fields.field_name
            , new_fields.field_order
            , FALSE
        FROM new_table_output_steps
            JOIN new_fields
                ON new_fields.schema_name = new_table_output_steps.target_schema
                    AND new_fields.table_name = new_table_output_steps.target_table
)

    , new_json_output_fields AS (
    INSERT INTO mdi.json_output_field (process_dwid, field_name)
        SELECT new_processes.dwid, new_process_variables.json_output_field
        FROM new_processes
            JOIN new_process_variables
                ON new_processes.name = new_process_variables.name
)

    , new_state_machine_definitions AS (
    INSERT INTO mdi.state_machine_definition (process_dwid, name, comment)
        SELECT new_processes.dwid, new_processes.name, new_processes.description
        FROM new_processes
)
SELECT 'Finished inserting metadata for new tables';
