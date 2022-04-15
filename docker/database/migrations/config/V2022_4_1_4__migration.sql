--
-- Main | EDW | Octane schema synchronization for v2022.4.3.2 (2022-04-15)
-- https://app.asana.com/0/0/1202112089121386
--

/*
INSERTIONS
*/

--edw_field_definition
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
	VALUES ('staging', 'staging_octane', 'loan_hedge', 'lh_total_income_to_ami_ratio', 'NUMERIC(14,9)', NULL, NULL, NULL, NULL)
		, ('staging', 'staging_octane', 'secondary_settings', 'sset_high_balance_llpa_filter_applicable_date', 'DATE', NULL, NULL, NULL, NULL)
		, ('staging', 'staging_octane', 'secondary_settings', 'sset_high_balance_llpa_prefixes', 'VARCHAR(16000)', NULL, NULL, NULL, NULL)
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
	VALUES ('staging', 'history_octane', 'loan_hedge', 'lh_total_income_to_ami_ratio', 'NUMERIC(14,9)', 'staging', 'staging_octane', 'loan_hedge', 'lh_total_income_to_ami_ratio')
		, ('staging', 'history_octane', 'secondary_settings', 'sset_high_balance_llpa_filter_applicable_date', 'DATE', 'staging', 'staging_octane', 'secondary_settings', 'sset_high_balance_llpa_filter_applicable_date')
		, ('staging', 'history_octane', 'secondary_settings', 'sset_high_balance_llpa_prefixes', 'VARCHAR(16000)', 'staging', 'staging_octane', 'secondary_settings', 'sset_high_balance_llpa_prefixes')
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
	VALUES ('ETL-100325', 'lh_total_income_to_ami_ratio')
		, ('ETL-100174', 'sset_high_balance_llpa_filter_applicable_date')
		, ('ETL-100174', 'sset_high_balance_llpa_prefixes')
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
	VALUES ('ETL-100325', 0, '--finding records to insert into history_octane.loan_hedge
SELECT staging_table.lh_pid
     , staging_table.lh_version
     , staging_table.lh_loan_pid
     , staging_table.lh_update_datetime
     , staging_table.lh_update_pending_datetime
     , staging_table.lh_transaction_status_date
     , staging_table.lh_loan_number
     , staging_table.lh_product_code
     , staging_table.lh_note_rate
     , staging_table.lh_loan_amount
     , staging_table.lh_lock_date
     , staging_table.lh_buy_side_lock_expires_date
     , staging_table.lh_lock_expiration_date
     , staging_table.lh_secondary_cost
     , staging_table.lh_total_cost_basis
     , staging_table.lh_total_lender_margin
     , staging_table.lh_stage
     , staging_table.lh_fund_date
     , staging_table.lh_allocation_date
     , staging_table.lh_estimated_fund_date
     , staging_table.lh_purchased_by_investor_date
     , staging_table.lh_commitment_number
     , staging_table.lh_property_occupancy
     , staging_table.lh_property_type
     , staging_table.lh_property_type_supplemental
     , staging_table.lh_property_state
     , staging_table.lh_property_zip
     , staging_table.lh_property_number_of_units
     , staging_table.lh_purchase_price
     , staging_table.lh_appraised_value
     , staging_table.lh_purpose
     , staging_table.lh_refinance_type
     , staging_table.lh_lien_position
     , staging_table.lh_impounds
     , staging_table.lh_buydown_type
     , staging_table.lh_buydown
     , staging_table.lh_ltv
     , staging_table.lh_original_ltv
     , staging_table.lh_cltv
     , staging_table.lh_original_cltv
     , staging_table.lh_effective_credit_score
     , staging_table.lh_doc_type
     , staging_table.lh_debt_to_income
     , staging_table.lh_prepayment_penalty
     , staging_table.lh_prepayment_penalty_term
     , staging_table.lh_interest_only
     , staging_table.lh_lock_type
     , staging_table.lh_lock_period
     , staging_table.lh_fees_collected_bps
     , staging_table.lh_channel
     , staging_table.lh_loan_officer
     , staging_table.lh_branch
     , staging_table.lh_broker
     , staging_table.lh_correspondent
     , staging_table.lh_origination_source
     , staging_table.lh_investor
     , staging_table.lh_investor_total_price
     , staging_table.lh_investor_base_price
     , staging_table.lh_investor_srp_paid
     , staging_table.lh_investor_loan_number
     , staging_table.lh_pmi
     , staging_table.lh_pmi_percent
     , staging_table.lh_mi_cert_number
     , staging_table.lh_srp_paid
     , staging_table.lh_discount_points
     , staging_table.lh_date_docs_back
     , staging_table.lh_note_date
     , staging_table.lh_close_date
     , staging_table.lh_first_payment_date
     , staging_table.lh_last_payment_date
     , staging_table.lh_next_scheduled_payment_due_date
     , staging_table.lh_scheduled_principal_and_interest
     , staging_table.lh_current_principal_and_interest
     , staging_table.lh_minimum_principal_and_interest
     , staging_table.lh_current_unpaid_principal_balance
     , staging_table.lh_original_interest_rate
     , staging_table.lh_maturity_date
     , staging_table.lh_amortization_term
     , staging_table.lh_yearly_payment_cap
     , staging_table.lh_arm_margin
     , staging_table.lh_arm_adjustment_date
     , staging_table.lh_first_arm_period
     , staging_table.lh_first_arm_adjustment_cap
     , staging_table.lh_arm_life_floor
     , staging_table.lh_arm_life_ceiling
     , staging_table.lh_first_arm_payment_adjustment_date
     , staging_table.lh_arm_period_after_first
     , staging_table.lh_arm_adjustment_cap_after_first
     , staging_table.lh_first_payment_cap
     , staging_table.lh_payment_cap_option
     , staging_table.lh_neg_am_flag
     , staging_table.lh_maximum_negative_amortization
     , staging_table.lh_arm_convertible
     , staging_table.lh_arm_index
     , staging_table.lh_dual_loan_flag
     , staging_table.lh_other_loan_number
     , staging_table.lh_agency_extract_fields
     , staging_table.lh_warehouse_bank
     , staging_table.lh_wire_amount
     , staging_table.lh_credit_rating_agency_fields
     , staging_table.lh_levels_fields
     , staging_table.lh_data_fields
     , staging_table.lh_loan_status
     , staging_table.lh_suspense_yes_no
     , staging_table.lh_loan_type
     , staging_table.lh_hud_borr_paid_by_for_borr_other_amount
     , staging_table.lh_fees_line_user_def_fee_one_borr
     , staging_table.lh_uw_suspended_cleared_date
     , staging_table.lh_underwriting_suspended_date
     , staging_table.lh_line_orig_charge
     , staging_table.lh_amortization_type
     , staging_table.lh_milestone
     , staging_table.lh_msa
     , staging_table.lh_county_code
     , staging_table.lh_ship_date_to_investor
     , staging_table.lh_borrower_last_name
     , staging_table.lh_purchase_advice_suspense_fee
     , staging_table.lh_purchase_advice_early_delivery_amount
     , staging_table.lh_purchase_advice_llpa
     , staging_table.lh_purchase_advice_fmna
     , staging_table.lh_purchase_advice_rp
     , staging_table.lh_lock_info_relock_amount
     , staging_table.lh_lock_info_loan_basis
     , staging_table.lh_lock_info_lock_request_fulfilled_date_time
     , staging_table.lh_lock_info_rate_lock_request_rate_sheet_id
     , staging_table.lh_current_status_change_date
     , staging_table.lh_aus_type
     , staging_table.lh_buy_side_base_arm_margin
     , staging_table.lh_uldd_poolid
     , staging_table.lh_warehouse_co_name
     , staging_table.lh_underwriting_investor_eligibility_wells_fargo
     , staging_table.lh_underwriting_investor_eligibility_chase
     , staging_table.lh_du_fail_reason
     , staging_table.lh_lpmi_total_costs_on_lock
     , staging_table.lh_lpmi_after_lock_required
     , staging_table.lh_lpmi_after_lock_bps
     , staging_table.lh_mi_company_name_type
     , staging_table.lh_lpmi_frequency
     , staging_table.lh_lpmi_estimated_amount_of_lender_paid_mi
     , staging_table.lh_mortgage_insurance_premium_source_type
     , staging_table.lh_loan_amount_repeat
     , staging_table.lh_product_code_repeat
     , staging_table.lh_note_rate_repeat
     , staging_table.lh_loan_info_loan_id
     , staging_table.lh_salable_loan
     , staging_table.lh_sale_hold
     , staging_table.lh_sale_hold_comments
     , staging_table.lh_pf_disbursement_ledger_date
     , staging_table.lh_aus_eligibility
     , staging_table.lh_texas_cash_out
     , staging_table.lh_acceptable_du
     , staging_table.lh_acceptable_lp
     , staging_table.lh_financed_property_count
     , staging_table.lh_payoff_primary_lien_holder_company
     , staging_table.lh_payoff_junior_lien_holder_company
     , staging_table.lh_base_loan_amount
     , staging_table.lh_funding_authorized
     , staging_table.lh_credit_committee_fico_exception
     , staging_table.lh_home_ready_eligibility
     , staging_table.lh_home_ready_borr_acceptance
     , staging_table.lh_home_ready_eligibility_review
     , staging_table.lh_home_possible_eligibility
     , staging_table.lh_home_possible_eligibility_review
     , staging_table.lh_piw
     , staging_table.lh_piw_fee
     , staging_table.lh_uw_investor_eligibility_fnma
     , staging_table.lh_uw_investor_eligibility_fhlmc
     , staging_table.lh_appraisal_form
     , staging_table.lh_ext_cos_total_amt
     , staging_table.lh_fnmcu_risk_score
     , staging_table.lh_borrower_income_verification
     , staging_table.lh_co_borrower_income_verification
     , staging_table.lh_day_one_income_verification_available
     , staging_table.lh_subject_property_estimated_value
     , staging_table.lh_transaction_status
     , staging_table.lh_buy_status
     , staging_table.lh_appraisal_exists
     , staging_table.lh_du_piw_eligible
     , staging_table.lh_lp_appraisal_waiver_eligible
     , staging_table.lh_borrower_first_name
     , staging_table.lh_co_borrower_first_name
     , staging_table.lh_co_borrower_last_name
     , staging_table.lh_total_borrower_income
     , staging_table.lh_subject_property_city
     , staging_table.lh_subject_property_county
     , staging_table.lh_subject_property_zip
     , staging_table.lh_borrower_decision_credit_score
     , staging_table.lh_co_borrower_decision_credit_score
     , staging_table.lh_underwriter_disposition
     , staging_table.lh_underwrite_risk_assessment_type
     , staging_table.lh_subject_property_address
     , staging_table.lh_original_lock_date
     , staging_table.lh_original_lock_period
     , staging_table.lh_borrower_income_docs_required_count
     , staging_table.lh_borrower_income_docs_fulfilled_count
     , staging_table.lh_borrower_income_docs_approved_count
     , staging_table.lh_borrower_asset_docs_required_count
     , staging_table.lh_borrower_asset_docs_fulfilled_count
     , staging_table.lh_borrower_asset_docs_approved_count
     , staging_table.lh_borrower_credit_docs_required_count
     , staging_table.lh_borrower_credit_docs_fulfilled_count
     , staging_table.lh_borrower_credit_docs_approved_count
     , staging_table.lh_initial_uw_submit_date_time
     , staging_table.lh_cd_clear_date
     , staging_table.lh_lender_concession_total_approved_amount
     , staging_table.lh_relock_fee_gross_amount
     , staging_table.lh_relock_fee_amount_less_concessions
     , staging_table.lh_relock_fee_amount_concessed
     , staging_table.lh_lock_extension_fee_gross_amount
     , staging_table.lh_lock_extension_fee_amount_less_concessions
     , staging_table.lh_lock_extension_fee_amount_concessed
     , staging_table.lh_general_lender_concessions_amount_non_itemized
     , staging_table.lh_day_one_concessions
     , staging_table.lh_investor_lock_commitment_type
     , staging_table.lh_signed_closing_doc_received_datetime
     , staging_table.lh_geocoding_msa_code
     , staging_table.lh_geocoding_state_code
     , staging_table.lh_geocoding_county_code
     , staging_table.lh_geocoding_census_tract
     , staging_table.lh_tolerance_cure_amount
     , staging_table.lh_self_employed_flag
     , staging_table.lh_first_time_homebuyer
     , staging_table.lh_mortgage_insurance_lpmi_rate_adjustment
     , staging_table.lh_eligible_for_qm_status
     , staging_table.lh_safe_harbor_test_passed
     , staging_table.lh_hpml
     , staging_table.lh_hoepa
     , staging_table.lh_funding_status
     , staging_table.lh_early_funding
     , staging_table.lh_early_funding_date
     , staging_table.lh_lqa_purchase_eligibility_type
     , staging_table.lh_transferred_appraisal
     , staging_table.lh_appraisal_cu_risk_score
     , staging_table.lh_mi_upfront_rate
     , staging_table.lh_loan_funding_requested_date
     , staging_table.lh_student_loan_cash_out
     , staging_table.lh_octane_high_balance
     , staging_table.lh_borrower_final_price
     , staging_table.lh_charge_credit_for_interest_rate
     , staging_table.lh_contract_processing_fee
     , staging_table.lh_escrow_holdback
     , staging_table.lh_appraiser_license_number
     , staging_table.lh_mcc_present
     , staging_table.lh_grant_present
     , staging_table.lh_cema
     , staging_table.lh_supplemental_margin_company
     , staging_table.lh_supplemental_margin_branch
     , staging_table.lh_supplemental_margin_total
     , staging_table.lh_concessions_renegotiations_amount
     , staging_table.lh_fund_source_type
     , staging_table.lh_purchase_contract_funding_date
     , staging_table.lh_product_id
     , staging_table.lh_community_second
     , staging_table.lh_current_taxes_and_insurance
     , staging_table.lh_multiple_applicants
     , staging_table.lh_community_second_liability
     , staging_table.lh_property_rights_type
     , staging_table.lh_mbs_final_purchaser
     , staging_table.lh_hmda_universal_loan_id
     , staging_table.lh_lp_ace_eligible
     , staging_table.lh_family_advantage_product
     , staging_table.lh_effective_rate_sheet_datetime
     , staging_table.lh_debt_to_income_excluding_mi
     , staging_table.lh_clear_to_commit
     , staging_table.lh_b2_first_name
     , staging_table.lh_b2_last_name
     , staging_table.lh_c2_first_name
     , staging_table.lh_c2_last_name
     , staging_table.lh_b3_first_name
     , staging_table.lh_b3_last_name
     , staging_table.lh_c3_first_name
     , staging_table.lh_c3_last_name
     , staging_table.lh_b4_first_name
     , staging_table.lh_b4_last_name
     , staging_table.lh_c4_first_name
     , staging_table.lh_c4_last_name
     , staging_table.lh_b5_first_name
     , staging_table.lh_b5_last_name
     , staging_table.lh_c5_first_name
     , staging_table.lh_c5_last_name
     , staging_table.lh_texas_home_equity_conversion
     , staging_table.lh_interest_only_heloc
     , staging_table.lh_interest_only_term_months
     , staging_table.lh_investor_lock_product_name
     , staging_table.lh_investor_lock_product_id
     , staging_table.lh_rebuttable_presumption
     , staging_table.lh_non_conforming
     , staging_table.lh_num_deal_updates_since_update_pending
     , staging_table.lh_borrower_engagement_percent
     , staging_table.lh_loan_create_date
     , staging_table.lh_high_balance_hit_percent
     , staging_table.lh_new_york_payup_percent
     , staging_table.lh_ship_date_to_custodian
     , staging_table.lh_lock_vintage
     , staging_table.lh_lock_series
     , staging_table.lh_investor_total
     , staging_table.lh_velocify_lead_id
     , staging_table.lh_collateral_tracking_number
     , staging_table.lh_qualified_mortgage_status_type
     , staging_table.lh_charges_enabled_date
     , staging_table.lh_application_date
     , staging_table.lh_total_income_to_ami_ratio
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.loan_hedge staging_table
LEFT JOIN history_octane.loan_hedge history_table
          ON staging_table.lh_pid = history_table.lh_pid
              AND staging_table.lh_version = history_table.lh_version
WHERE history_table.lh_pid IS NULL
UNION ALL
SELECT history_table.lh_pid
     , history_table.lh_version + 1
     , history_table.lh_loan_pid
     , history_table.lh_update_datetime
     , history_table.lh_update_pending_datetime
     , history_table.lh_transaction_status_date
     , history_table.lh_loan_number
     , history_table.lh_product_code
     , history_table.lh_note_rate
     , history_table.lh_loan_amount
     , history_table.lh_lock_date
     , history_table.lh_buy_side_lock_expires_date
     , history_table.lh_lock_expiration_date
     , history_table.lh_secondary_cost
     , history_table.lh_total_cost_basis
     , history_table.lh_total_lender_margin
     , history_table.lh_stage
     , history_table.lh_fund_date
     , history_table.lh_allocation_date
     , history_table.lh_estimated_fund_date
     , history_table.lh_purchased_by_investor_date
     , history_table.lh_commitment_number
     , history_table.lh_property_occupancy
     , history_table.lh_property_type
     , history_table.lh_property_type_supplemental
     , history_table.lh_property_state
     , history_table.lh_property_zip
     , history_table.lh_property_number_of_units
     , history_table.lh_purchase_price
     , history_table.lh_appraised_value
     , history_table.lh_purpose
     , history_table.lh_refinance_type
     , history_table.lh_lien_position
     , history_table.lh_impounds
     , history_table.lh_buydown_type
     , history_table.lh_buydown
     , history_table.lh_ltv
     , history_table.lh_original_ltv
     , history_table.lh_cltv
     , history_table.lh_original_cltv
     , history_table.lh_effective_credit_score
     , history_table.lh_doc_type
     , history_table.lh_debt_to_income
     , history_table.lh_prepayment_penalty
     , history_table.lh_prepayment_penalty_term
     , history_table.lh_interest_only
     , history_table.lh_lock_type
     , history_table.lh_lock_period
     , history_table.lh_fees_collected_bps
     , history_table.lh_channel
     , history_table.lh_loan_officer
     , history_table.lh_branch
     , history_table.lh_broker
     , history_table.lh_correspondent
     , history_table.lh_origination_source
     , history_table.lh_investor
     , history_table.lh_investor_total_price
     , history_table.lh_investor_base_price
     , history_table.lh_investor_srp_paid
     , history_table.lh_investor_loan_number
     , history_table.lh_pmi
     , history_table.lh_pmi_percent
     , history_table.lh_mi_cert_number
     , history_table.lh_srp_paid
     , history_table.lh_discount_points
     , history_table.lh_date_docs_back
     , history_table.lh_note_date
     , history_table.lh_close_date
     , history_table.lh_first_payment_date
     , history_table.lh_last_payment_date
     , history_table.lh_next_scheduled_payment_due_date
     , history_table.lh_scheduled_principal_and_interest
     , history_table.lh_current_principal_and_interest
     , history_table.lh_minimum_principal_and_interest
     , history_table.lh_current_unpaid_principal_balance
     , history_table.lh_original_interest_rate
     , history_table.lh_maturity_date
     , history_table.lh_amortization_term
     , history_table.lh_yearly_payment_cap
     , history_table.lh_arm_margin
     , history_table.lh_arm_adjustment_date
     , history_table.lh_first_arm_period
     , history_table.lh_first_arm_adjustment_cap
     , history_table.lh_arm_life_floor
     , history_table.lh_arm_life_ceiling
     , history_table.lh_first_arm_payment_adjustment_date
     , history_table.lh_arm_period_after_first
     , history_table.lh_arm_adjustment_cap_after_first
     , history_table.lh_first_payment_cap
     , history_table.lh_payment_cap_option
     , history_table.lh_neg_am_flag
     , history_table.lh_maximum_negative_amortization
     , history_table.lh_arm_convertible
     , history_table.lh_arm_index
     , history_table.lh_dual_loan_flag
     , history_table.lh_other_loan_number
     , history_table.lh_agency_extract_fields
     , history_table.lh_warehouse_bank
     , history_table.lh_wire_amount
     , history_table.lh_credit_rating_agency_fields
     , history_table.lh_levels_fields
     , history_table.lh_data_fields
     , history_table.lh_loan_status
     , history_table.lh_suspense_yes_no
     , history_table.lh_loan_type
     , history_table.lh_hud_borr_paid_by_for_borr_other_amount
     , history_table.lh_fees_line_user_def_fee_one_borr
     , history_table.lh_uw_suspended_cleared_date
     , history_table.lh_underwriting_suspended_date
     , history_table.lh_line_orig_charge
     , history_table.lh_amortization_type
     , history_table.lh_milestone
     , history_table.lh_msa
     , history_table.lh_county_code
     , history_table.lh_ship_date_to_investor
     , history_table.lh_borrower_last_name
     , history_table.lh_purchase_advice_suspense_fee
     , history_table.lh_purchase_advice_early_delivery_amount
     , history_table.lh_purchase_advice_llpa
     , history_table.lh_purchase_advice_fmna
     , history_table.lh_purchase_advice_rp
     , history_table.lh_lock_info_relock_amount
     , history_table.lh_lock_info_loan_basis
     , history_table.lh_lock_info_lock_request_fulfilled_date_time
     , history_table.lh_lock_info_rate_lock_request_rate_sheet_id
     , history_table.lh_current_status_change_date
     , history_table.lh_aus_type
     , history_table.lh_buy_side_base_arm_margin
     , history_table.lh_uldd_poolid
     , history_table.lh_warehouse_co_name
     , history_table.lh_underwriting_investor_eligibility_wells_fargo
     , history_table.lh_underwriting_investor_eligibility_chase
     , history_table.lh_du_fail_reason
     , history_table.lh_lpmi_total_costs_on_lock
     , history_table.lh_lpmi_after_lock_required
     , history_table.lh_lpmi_after_lock_bps
     , history_table.lh_mi_company_name_type
     , history_table.lh_lpmi_frequency
     , history_table.lh_lpmi_estimated_amount_of_lender_paid_mi
     , history_table.lh_mortgage_insurance_premium_source_type
     , history_table.lh_loan_amount_repeat
     , history_table.lh_product_code_repeat
     , history_table.lh_note_rate_repeat
     , history_table.lh_loan_info_loan_id
     , history_table.lh_salable_loan
     , history_table.lh_sale_hold
     , history_table.lh_sale_hold_comments
     , history_table.lh_pf_disbursement_ledger_date
     , history_table.lh_aus_eligibility
     , history_table.lh_texas_cash_out
     , history_table.lh_acceptable_du
     , history_table.lh_acceptable_lp
     , history_table.lh_financed_property_count
     , history_table.lh_payoff_primary_lien_holder_company
     , history_table.lh_payoff_junior_lien_holder_company
     , history_table.lh_base_loan_amount
     , history_table.lh_funding_authorized
     , history_table.lh_credit_committee_fico_exception
     , history_table.lh_home_ready_eligibility
     , history_table.lh_home_ready_borr_acceptance
     , history_table.lh_home_ready_eligibility_review
     , history_table.lh_home_possible_eligibility
     , history_table.lh_home_possible_eligibility_review
     , history_table.lh_piw
     , history_table.lh_piw_fee
     , history_table.lh_uw_investor_eligibility_fnma
     , history_table.lh_uw_investor_eligibility_fhlmc
     , history_table.lh_appraisal_form
     , history_table.lh_ext_cos_total_amt
     , history_table.lh_fnmcu_risk_score
     , history_table.lh_borrower_income_verification
     , history_table.lh_co_borrower_income_verification
     , history_table.lh_day_one_income_verification_available
     , history_table.lh_subject_property_estimated_value
     , history_table.lh_transaction_status
     , history_table.lh_buy_status
     , history_table.lh_appraisal_exists
     , history_table.lh_du_piw_eligible
     , history_table.lh_lp_appraisal_waiver_eligible
     , history_table.lh_borrower_first_name
     , history_table.lh_co_borrower_first_name
     , history_table.lh_co_borrower_last_name
     , history_table.lh_total_borrower_income
     , history_table.lh_subject_property_city
     , history_table.lh_subject_property_county
     , history_table.lh_subject_property_zip
     , history_table.lh_borrower_decision_credit_score
     , history_table.lh_co_borrower_decision_credit_score
     , history_table.lh_underwriter_disposition
     , history_table.lh_underwrite_risk_assessment_type
     , history_table.lh_subject_property_address
     , history_table.lh_original_lock_date
     , history_table.lh_original_lock_period
     , history_table.lh_borrower_income_docs_required_count
     , history_table.lh_borrower_income_docs_fulfilled_count
     , history_table.lh_borrower_income_docs_approved_count
     , history_table.lh_borrower_asset_docs_required_count
     , history_table.lh_borrower_asset_docs_fulfilled_count
     , history_table.lh_borrower_asset_docs_approved_count
     , history_table.lh_borrower_credit_docs_required_count
     , history_table.lh_borrower_credit_docs_fulfilled_count
     , history_table.lh_borrower_credit_docs_approved_count
     , history_table.lh_initial_uw_submit_date_time
     , history_table.lh_cd_clear_date
     , history_table.lh_lender_concession_total_approved_amount
     , history_table.lh_relock_fee_gross_amount
     , history_table.lh_relock_fee_amount_less_concessions
     , history_table.lh_relock_fee_amount_concessed
     , history_table.lh_lock_extension_fee_gross_amount
     , history_table.lh_lock_extension_fee_amount_less_concessions
     , history_table.lh_lock_extension_fee_amount_concessed
     , history_table.lh_general_lender_concessions_amount_non_itemized
     , history_table.lh_day_one_concessions
     , history_table.lh_investor_lock_commitment_type
     , history_table.lh_signed_closing_doc_received_datetime
     , history_table.lh_geocoding_msa_code
     , history_table.lh_geocoding_state_code
     , history_table.lh_geocoding_county_code
     , history_table.lh_geocoding_census_tract
     , history_table.lh_tolerance_cure_amount
     , history_table.lh_self_employed_flag
     , history_table.lh_first_time_homebuyer
     , history_table.lh_mortgage_insurance_lpmi_rate_adjustment
     , history_table.lh_eligible_for_qm_status
     , history_table.lh_safe_harbor_test_passed
     , history_table.lh_hpml
     , history_table.lh_hoepa
     , history_table.lh_funding_status
     , history_table.lh_early_funding
     , history_table.lh_early_funding_date
     , history_table.lh_lqa_purchase_eligibility_type
     , history_table.lh_transferred_appraisal
     , history_table.lh_appraisal_cu_risk_score
     , history_table.lh_mi_upfront_rate
     , history_table.lh_loan_funding_requested_date
     , history_table.lh_student_loan_cash_out
     , history_table.lh_octane_high_balance
     , history_table.lh_borrower_final_price
     , history_table.lh_charge_credit_for_interest_rate
     , history_table.lh_contract_processing_fee
     , history_table.lh_escrow_holdback
     , history_table.lh_appraiser_license_number
     , history_table.lh_mcc_present
     , history_table.lh_grant_present
     , history_table.lh_cema
     , history_table.lh_supplemental_margin_company
     , history_table.lh_supplemental_margin_branch
     , history_table.lh_supplemental_margin_total
     , history_table.lh_concessions_renegotiations_amount
     , history_table.lh_fund_source_type
     , history_table.lh_purchase_contract_funding_date
     , history_table.lh_product_id
     , history_table.lh_community_second
     , history_table.lh_current_taxes_and_insurance
     , history_table.lh_multiple_applicants
     , history_table.lh_community_second_liability
     , history_table.lh_property_rights_type
     , history_table.lh_mbs_final_purchaser
     , history_table.lh_hmda_universal_loan_id
     , history_table.lh_lp_ace_eligible
     , history_table.lh_family_advantage_product
     , history_table.lh_effective_rate_sheet_datetime
     , history_table.lh_debt_to_income_excluding_mi
     , history_table.lh_clear_to_commit
     , history_table.lh_b2_first_name
     , history_table.lh_b2_last_name
     , history_table.lh_c2_first_name
     , history_table.lh_c2_last_name
     , history_table.lh_b3_first_name
     , history_table.lh_b3_last_name
     , history_table.lh_c3_first_name
     , history_table.lh_c3_last_name
     , history_table.lh_b4_first_name
     , history_table.lh_b4_last_name
     , history_table.lh_c4_first_name
     , history_table.lh_c4_last_name
     , history_table.lh_b5_first_name
     , history_table.lh_b5_last_name
     , history_table.lh_c5_first_name
     , history_table.lh_c5_last_name
     , history_table.lh_texas_home_equity_conversion
     , history_table.lh_interest_only_heloc
     , history_table.lh_interest_only_term_months
     , history_table.lh_investor_lock_product_name
     , history_table.lh_investor_lock_product_id
     , history_table.lh_rebuttable_presumption
     , history_table.lh_non_conforming
     , history_table.lh_num_deal_updates_since_update_pending
     , history_table.lh_borrower_engagement_percent
     , history_table.lh_loan_create_date
     , history_table.lh_high_balance_hit_percent
     , history_table.lh_new_york_payup_percent
     , history_table.lh_ship_date_to_custodian
     , history_table.lh_lock_vintage
     , history_table.lh_lock_series
     , history_table.lh_investor_total
     , history_table.lh_velocify_lead_id
     , history_table.lh_collateral_tracking_number
     , history_table.lh_qualified_mortgage_status_type
     , history_table.lh_charges_enabled_date
     , history_table.lh_application_date
     , history_table.lh_total_income_to_ami_ratio
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM (
    SELECT current_records.*
    FROM history_octane.loan_hedge AS current_records
    LEFT JOIN history_octane.loan_hedge AS history_records
              ON current_records.lh_pid = history_records.lh_pid
                  AND current_records.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.data_source_updated_datetime IS NULL
      AND current_records.data_source_deleted_flag = FALSE
) AS history_table
LEFT JOIN staging_octane.loan_hedge staging_table
          ON staging_table.lh_pid = history_table.lh_pid
WHERE staging_table.lh_pid IS NULL;', 'Staging DB Connection')
		, ('ETL-100174', 0, '--finding records to insert into history_octane.secondary_settings
SELECT staging_table.sset_pid
     , staging_table.sset_version
     , staging_table.sset_account_pid
     , staging_table.sset_default_lead_source_pid
     , staging_table.sset_default_mortech_account_pid
     , staging_table.sset_default_beneficiary_investor_pid
     , staging_table.sset_default_servicer_investor_pid
     , staging_table.sset_initial_lender_lock_id
     , staging_table.sset_initial_lender_trade_id
     , staging_table.sset_lock_expiration_warning_days
     , staging_table.sset_expired_lock_update_allowed_days
     , staging_table.sset_disable_all_locking
     , staging_table.sset_pricing_engine_type
     , staging_table.sset_price_match_check_suspend_through_date
     , staging_table.sset_mortech_disable_eligibility
     , staging_table.sset_mortech_strict_eligibility
     , staging_table.sset_zillow_appraisal_fee
     , staging_table.sset_zillow_title_fee
     , staging_table.sset_zillow_recording_fee
     , staging_table.sset_mortech_floating_adjuster_prefixes
     , staging_table.sset_rate_lock_acknowledgement_due_days
     , staging_table.sset_rate_lock_supporting_documentation_due_days
     , staging_table.sset_rate_lock_appraisal_inspection_due_days
     , staging_table.sset_min_subordinate_financing_lock_term_days
     , staging_table.sset_servicer_loan_id_minimum_available_threshold
     , staging_table.sset_servicer_loan_id_minimum_available_warning_email
     , staging_table.sset_third_party_base_margin_prefixes
     , staging_table.sset_third_party_floating_margin_prefixes
     , staging_table.sset_month_ami_uses_subsequent_year
     , staging_table.sset_day_ami_uses_subsequent_year
     , staging_table.sset_high_balance_llpa_prefixes
     , staging_table.sset_high_balance_llpa_filter_applicable_date
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.secondary_settings staging_table
LEFT JOIN history_octane.secondary_settings history_table
          ON staging_table.sset_pid = history_table.sset_pid
              AND staging_table.sset_version = history_table.sset_version
WHERE history_table.sset_pid IS NULL
UNION ALL
SELECT history_table.sset_pid
     , history_table.sset_version + 1
     , history_table.sset_account_pid
     , history_table.sset_default_lead_source_pid
     , history_table.sset_default_mortech_account_pid
     , history_table.sset_default_beneficiary_investor_pid
     , history_table.sset_default_servicer_investor_pid
     , history_table.sset_initial_lender_lock_id
     , history_table.sset_initial_lender_trade_id
     , history_table.sset_lock_expiration_warning_days
     , history_table.sset_expired_lock_update_allowed_days
     , history_table.sset_disable_all_locking
     , history_table.sset_pricing_engine_type
     , history_table.sset_price_match_check_suspend_through_date
     , history_table.sset_mortech_disable_eligibility
     , history_table.sset_mortech_strict_eligibility
     , history_table.sset_zillow_appraisal_fee
     , history_table.sset_zillow_title_fee
     , history_table.sset_zillow_recording_fee
     , history_table.sset_mortech_floating_adjuster_prefixes
     , history_table.sset_rate_lock_acknowledgement_due_days
     , history_table.sset_rate_lock_supporting_documentation_due_days
     , history_table.sset_rate_lock_appraisal_inspection_due_days
     , history_table.sset_min_subordinate_financing_lock_term_days
     , history_table.sset_servicer_loan_id_minimum_available_threshold
     , history_table.sset_servicer_loan_id_minimum_available_warning_email
     , history_table.sset_third_party_base_margin_prefixes
     , history_table.sset_third_party_floating_margin_prefixes
     , history_table.sset_month_ami_uses_subsequent_year
     , history_table.sset_day_ami_uses_subsequent_year
     , history_table.sset_high_balance_llpa_prefixes
     , history_table.sset_high_balance_llpa_filter_applicable_date
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM (
    SELECT current_records.*
    FROM history_octane.secondary_settings AS current_records
    LEFT JOIN history_octane.secondary_settings AS history_records
              ON current_records.sset_pid = history_records.sset_pid
                  AND current_records.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.data_source_updated_datetime IS NULL
      AND current_records.data_source_deleted_flag = FALSE
) AS history_table
LEFT JOIN staging_octane.secondary_settings staging_table
          ON staging_table.sset_pid = history_table.sset_pid
WHERE staging_table.sset_pid IS NULL;', 'Staging DB Connection')
)
UPDATE mdi.table_input_step
SET data_source_dwid = update_rows.data_source_dwid
	, sql = update_rows.sql
	, connectionname = update_rows.connectionname::mdi.pentaho_db_connection_name
FROM update_rows
	JOIN mdi.process
		ON process.name = update_rows.process_name
WHERE process.dwid = table_input_step.process_dwid;
