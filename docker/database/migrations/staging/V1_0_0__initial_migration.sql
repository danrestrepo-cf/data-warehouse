-------------------------------------------------------------------------------
--  NAME
--      Add Staging Encompass Tables
--
--  ASANA
--      https://app.asana.com/0/265828915819547/1156662690313663
--
--  DESCRIPTION/PURPOSE
--      This script adds the tables that are needed to stage Encompass loan data
--      into the Enterprise Data Warehouse (EDW).
--
-- PROGRAMMING NOTES
--      Table  loan.encompass_loan has functions associated with them to auto populate
--      the created_at and updated_at columns. A trigger updates the updated_at column when it
--      is modified so we can easily tell if any data was modified after the initial load.
--
-------------------------------------------------------------------------------

-- Function: set_timestamp
CREATE OR REPLACE FUNCTION  loan.set_timestamp()
	RETURNS TRIGGER AS
$$
BEGIN
	NEW.updated_at = NOW();
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;




create table loan.encompass_loan
(
	created_at TIMESTAMP DEFAULT now(),
	updated_at TIMESTAMP DEFAULT now(),
	el_loan_number bigint,
	el_loan_guid text,
	el_loan_create_datetime timestamp,
	el_lien_priority_type text,
	el_loan_purpose_type text,
	el_fannie_mae_loan_doc_code_type text,
	el_interest_only text,
	el_prepay_penalty text,
	el_subject_property_type text,
	el_subject_property_occupancy_status text,
	el_subject_property_estate_held_type text,
	el_underwriting_risk_assessment_type text,
	el_rate_lock_most_recent_lock_request_loan_type text,
	el_rate_lock_trans_details_amort_type_most_recent text,
	el_rate_lock_request_rate_sheet_id text,
	el_rate_lock_buy_side_investor_commitment text,
	el_mortgage_type text,
	el_mi_company_name_type text,
	el_mi_payer_type text,
	el_mi_payment_type text,
	el_hmda_action_type text,
	el_amortization_type text,
	el_proposal_structure_type text,
	el_product_special_program_type text,
	el_hmda_hoepa_status_type text,
	el_investor_hmda_purchaser_of_loan_type text,
	el_fund_source_type text,
	el_velocify_lead_id text,
	el_lead_source_id text,
	el_lead_reference_id text,
	el_borrower_intent_to_proceed boolean,
	el_mortgage_amount numeric(17,2),
	el_interest_rate_percent numeric(20,9),
	el_refinance_purpose_type text,
	el_investor_offering_name text,
	el_down_payment_percent numeric(20,9),
	el_housing_ratio_percent numeric(20,9),
	el_debt_ratio_percent numeric(20,9),
	el_sale_price_amount numeric(17,2),
	el_cltv_percent numeric(20,9),
	el_transaction_apr_percent numeric(20,9),
	el_product_amortization_term_months integer,
	el_mlds_prepay_penalty_period numeric(20,9),
	el_escrow_type text,
	el_borrower_first_name text,
	el_borrower_middle_name text,
	el_borrower_last_name text,
	el_borrower_email text,
	el_borrower_home_phone text,
	el_borrower_office_phone text,
	el_borrower_mobile_phone text,
	el_borrower_current_residence_street text,
	el_borrower_current_residence_city text,
	el_borrower_current_residence_state text,
	el_borrower_current_residence_postal_code text,
	el_borrower_birth_date timestamp,
	el_borrower_gender_type text,
	el_borrower_ethnicity_type text,
	el_borrower_race_american_indian boolean,
	el_borrower_race_asian boolean,
	el_borrower_race_black boolean,
	el_borrower_race_native_hawaiian boolean,
	el_borrower_race_white boolean,
	el_borrower_race_info_not_provided boolean,
	el_borrower_race_not_applicable boolean,
	el_borrower_first_time_homebuyer boolean,
	el_borrower_self_employed boolean,
	el_borrower_gross_monthly_income numeric(17,2),
	el_borrower_financed_property_ownership_count integer,
	el_borr_lmedian_fico integer,
	el_coborr_lmedian_fico integer,
	el_va_mortgage_summary_credit_score integer,
	el_coborrower_first_name text,
	el_coborrower_middle_name text,
	el_coborrower_last_name text,
	el_coborrower_email text,
	el_coborrower_home_phone text,
	el_coborrower_office_phone text,
	el_coborrower_mobile_phone text,
	el_coborrower_current_residence_street text,
	el_coborrower_current_residence_city text,
	el_coborrower_current_residence_state text,
	el_coborrower_current_residence_postal_code text,
	el_coborrower_birth_date timestamp,
	el_coborrower_gender_type text,
	el_coborrower_experian_fico_score integer,
	el_coborrower_ethnicity_type text,
	el_coborrower_race_american_indian boolean,
	el_coborrower_race_asian boolean,
	el_coborrower_race_black boolean,
	el_coborrower_race_native_hawaiian boolean,
	el_coborrower_race_white boolean,
	el_coborrower_race_info_not_provided boolean,
	el_coborrower_race_not_applicable boolean,
	el_borrower_income_verification_available boolean,
	el_coborrower_income_verification_available boolean,
	el_subject_property_street_1 text,
	el_subject_property_street_2 text,
	el_subject_property_city text,
	el_subject_property_state text,
	el_subject_property_postal_code text,
	el_subject_property_county text,
	el_subject_property_msa_number text,
	el_subject_property_county_code text,
	el_subject_property_number_units integer,
	el_subject_property_year_built text,
	el_subject_property_estimated_amount numeric(17,2),
	el_subject_property_appraised_amount numeric(17,2),
	el_occupancy_type text,
	el_property_type text,
	el_credit_report_received_date timestamp,
	el_credit_report_reference_number text,
	el_payoff_junior_lien_holder_company text,
	el_payoff_primary_lien_holder_company text,
	el_appraisal_retrieval_relative_value text,
	el_appraisal_report_as_is text,
	el_originator_compensation_line_802_discount_point_line_2_perc numeric(20,9),
	el_originator_compensation_line_802_discount_point_line_4_perc numeric(20,9),
	el_originator_compensation_line_802_user_defined_discount_amou numeric(17,2),
	el_801_borrower_paid_origination_chrarge_amount numeric(17,2),
	el_801_user_defined_fee_2_borrower_amount numeric(17,2),
	el_801_broker_compensation_borrower_paid numeric(17,2),
	el_801_user_defined_fee_2_description text,
	el_802_borrower_credits_amount numeric(17,2),
	el_fees_line_803_borrower_paid_adj_origination_charges_amount numeric(17,2),
	el_borrower_origination_fee_amount_amount numeric(17,2),
	el_borrower_origination_charge_amount numeric(17,2),
	el_fees_compensation_to_broker_1_amount numeric(17,2),
	el_originator_compensation_lender_compensation_credit_amount_l numeric(17,2),
	el_lo_compensation_borrower_paid_discount_point_amount_line_3_ numeric(17,2),
	el_requested_concession_amount numeric(17,2),
	el_manager_concession_amount numeric(17,2),
	el_lo_comp_borrower_paid_discount_point_amount_line_1_amount numeric(17,2),
	el_total_credit_for_rate_chosen_amount numeric(17,2),
	el_total_borrower_paid_discount_point_amount_line_4_amount numeric(17,2),
	el_fees_line_801_user_defined_fee_1_borrower_amount numeric(17,2),
	el_fees_line_801_user_defined_fee_1_borrower numeric(17,2),
	el_total_finance_charge_amount numeric(17,2),
	el_preapproval_letter_create_date timestamp,
	el_underwriting_suspended_date timestamp,
	el_underwriting_level_of_property_review_form_number text,
	el_uw_suspended_cleared_date timestamp,
	el_credit_committee_fico_exception boolean,
	el_fnma_collateral_underwriter_risk_score numeric(20,9),
	el_day_1_income_verification_available boolean,
	el_du_fail_reason text,
	el_acceptable_du text,
	el_acceptable_lp text,
	el_ability_to_repay_loan_type text,
	el_rate_lock_most_recent_request_fulfilled_datetime timestamp,
	el_rate_lock_request_fulfilled_datetime timestamp,
	el_rate_lock_most_recent_loan_program text,
	el_rate_lock_buy_side_base_margin numeric(20,9),
	el_rate_lock_most_recent_mortgage_amount_excluding_pmi numeric(17,2),
	el_rate_lock_most_recent_subject_property_number_of_units integer,
	el_rate_lock_buy_side_lock_expires_date timestamp,
	el_rate_lock_buy_side_lock_date timestamp,
	el_rate_lock_first_lock_lock_date timestamp,
	el_rate_lock_most_recent_lock_request_escrow_waived numeric(17,2),
	el_rate_lock_most_recent_rate_lock_request_loan_amount numeric(17,2),
	el_rate_lock_buy_side_comments text,
	el_rate_lock_sell_side_lock_expires_date timestamp,
	el_rate_lock_sell_side_number_of_days integer,
	el_rate_lock_sell_side_total_sell_price_amount numeric(17,2),
	el_rate_lock_sell_side_investor_lock_type text,
	el_rate_lock_sell_investor_name text,
	el_rate_lock_sell_side_investor_loan_number text,
	el_rate_lock_sell_side_lock_date timestamp,
	el_rate_lock_most_recent_sell_side_lock_date timestamp,
	el_rate_lock_sell_side_base_rate_percent numeric(20,9),
	el_rate_lock_sell_side_investor_delivery_date timestamp,
	el_rate_lock_most_recent_sell_side_base_rate_adjust_1_percent numeric(20,9),
	el_rate_lock_most_recent_sell_side_investor_commitment text,
	el_rate_lock_sell_side_net_sell_price_amount numeric(17,2),
	el_rate_lock_sell_side_net_buy_rate_percent numeric(20,9),
	el_rate_lock_most_recent_rate_lock_term_in_months integer,
	el_rate_lock_buy_side_number_of_days integer,
	el_rate_lock_first_lock_ltv_percent numeric(20,9),
	el_rate_lock_first_lock_cltv_percent numeric(20,9),
	el_rate_lock_first_lock_net_buy_price_amount numeric(17,2),
	el_rate_lock_date timestamp,
	el_rate_lock_expiration_date timestamp,
	el_rate_lock_number_days integer,
	el_rate_lock_extension_original_lock_term integer,
	el_rate_lock_extension_original_lock_date timestamp,
	el_rate_lock_extension_original_lock_expiration_date timestamp,
	el_rate_lock_extension_new_expiration_date timestamp,
	el_rate_initial_capture_of_lock_number_days integer,
	el_first_payment_due_date timestamp,
	el_first_payment_adjustment_date timestamp,
	el_loan_maturity_date timestamp,
	el_mortgage_total_with_mi_premium_amount numeric(17,2),
	el_mortgage_info_arm_disclosure_type text,
	el_arm_margin_percent numeric(20,9),
	el_freddie_mac_lender_rate_adjustment_convertible_percent numeric(20,9),
	el_freddie_mac_ltv_percent numeric(20,9),
	el_regz_loan_info_document_date timestamp,
	el_sub_fin_second_mortgage_loan_amount numeric(17,2),
	el_miac_aus_eligibility_type text,
	el_total_number_of_borrowers_on_loan integer,
	el_monthly_pi_amount numeric(17,2),
	el_extension_cost_total_amount numeric(17,2),
	el_homeready_eligibility boolean,
	el_homeready_eligibility_review_complete boolean,
	el_homeready_borrower_acceptance boolean,
	el_homepossible_eligibility boolean,
	el_homepossible_eligibility_review_complete boolean,
	el_fannie_mae_investor_eligibility boolean,
	el_freddie_mac_investor_eligibility boolean,
	el_morgan_stanley_upload boolean,
	el_arm_initial_rate_adjustment_term_months numeric(20,9),
	el_arm_initial_rate_adjustment_cap_percent numeric(20,9),
	el_arm_floor_rate_percent numeric(20,9),
	el_arm_subsequent_rate_adjustment_months numeric(20,9),
	el_subsequent_rate_adjustment_cap_percent numeric(20,9),
	el_arm_rate_adjustment_lifetime_cap_percent numeric(20,9),
	el_mi_company_type text,
	el_mi_company_name text,
	el_mi_coverage_factor numeric(20,9),
	el_mi_required boolean,
	el_uldd_mi_premium_source_type text,
	el_lpmi_premium_estimated_amount numeric(20,9),
	el_lpmi_final_price_percent numeric(17,2),
	el_mi_premium_frequency_type text,
	el_mi_certificate_id text,
	el_postfunding_disbursement_ledger_received_date timestamp,
	el_warehouse_curtailment boolean,
	el_funding_executed_docs_submitted_datetime text,
	el_funds_requested_date timestamp,
	el_funds_sent_date timestamp,
	el_funds_released_date timestamp,
	el_fund_outstanding_docs_funding_authorized boolean,
	el_collateral_delivery_work_completed boolean,
	el_interim_funder_company_name text,
	el_coll_to_warehouse_warehouse_company text,
	el_bbt_elds_maturity_date text,
	el_interim_servicer_payment_summary_unpaid_balance_amount numeric(17,2),
	el_collateral_delivery_servicer_id text,
	el_next_payment_due_to_interim_servicer_date timestamp,
	el_servicer_upload_pi_change_date timestamp,
	el_shipping_investor_delivery_date timestamp,
	el_shipping_actual_shipping_date timestamp,
	el_collateral_delivery_customer_to_inventory_ship_date timestamp,
	el_collateral_to_investor_work_completed_datetime timestamp,
	el_collateral_delivery_to_custodian_ship_date timestamp,
	el_purchase_advice_date timestamp,
	el_purchase_advice_actual_sell_price_percent numeric(17,2),
	el_first_payment_to_investor_due_date text,
	el_purchase_advice_first_payment_to_type text,
	el_purchase_advice_actual_sell_side_srp numeric(20,9),
	el_purchase_advice_payouts_1_amount numeric(17,2),
	el_purchase_advice_payouts_2_amount numeric(17,2),
	el_purchase_advice_payouts_3_amount numeric(17,2),
	el_purchase_advice_payouts_4_amount numeric(17,2),
	el_purchase_advice_payouts_5_amount numeric(17,2),
	el_purchase_advice_payouts_6_amount numeric(17,2),
	el_purchase_advice_payouts_7_amount numeric(17,2),
	el_purchase_advice_payouts_8_amount numeric(17,2),
	el_purchase_advice_payouts_9_amount numeric(17,2),
	el_purchase_advice_payouts_10_amount numeric(17,2),
	el_purchase_advice_payouts_11_amount numeric(17,2),
	el_purchase_advice_payouts_12_amount numeric(17,2),
	el_purchase_advice_premium_amount numeric(17,2),
	el_purchase_advice_service_release_premium_received_amount numeric(20,9),
	el_underwriting_investor_eligibility_texas_50a6_cashout boolean,
	el_underwriting_investor_eligibility_wells_fargo boolean,
	el_underwriting_investor_eligibility_chase_or_jp_morgan boolean,
	el_mers_registration_date timestamp,
	el_mers_min_number text,
	el_rate_lock_most_recent_sell_side_investor_mers_number numeric(20,9),
	el_uldd_pool_id text,
	el_uldd_property_valuation_effective_date timestamp,
	el_uldd_first_unit_bedrooms integer,
	el_uldd_first_unit_subject_property_gross_rent_amount numeric(17,2),
	el_loan_estimate_most_recent_issued_date timestamp,
	el_appraisal_retrieval_work_completed_date timestamp,
	el_current_milestone_name text,
	el_current_milestone_datetime timestamp,
	el_disclosure_mode_date timestamp,
	el_current_loan_status_date timestamp,
	el_underwriting_clear_to_close_date timestamp,
	el_estimated_closing_date timestamp,
	el_closing_scheduled_date timestamp,
	el_closing_document_signed_milestone_date timestamp,
	el_closing_docs_delivered_datetime timestamp,
	el_total_wire_transfer_amount numeric(17,2),
	el_closed_date timestamp,
	el_closing_docs_regz_loan_info_disbursement_date timestamp,
	el_loan_folder_name text,
	el_buyer_agent_company_name text,
	el_buyer_agent_fmls text,
	el_buyer_agent_email text,
	el_originator_fmls text,
	el_processor_fmls text,
	el_funder_fmls text,
	el_closing_document_specialist_fmls text,
	el_originator_nmls_id text,
	el_processing_resub_worker_assigned_datetime timestamp,
	el_loan_team_member_name_uw_conditions text,
	el_underwriter_unparsed_name text,
	el_appraisal_onhold_estimated_release_date timestamp,
	el_appraisal_onhold_datetime timestamp,
	el_appraisal_cleared_datetime timestamp,
	el_refinance_type text,
	el_trans_details_purchaser_type text,
	el_trans_details_hoepa_status text,
	el_loan_info_channel text
);

CREATE INDEX idx__encompass_loan__elr_loan_number ON  loan.encompass_loan (el_loan_number);
CREATE INDEX idx__encompass_loan__elr_loan_create_datetime ON  loan.encompass_loan (el_loan_create_datetime);


-- Trigger: set_timestamp_on_encompass_loan
CREATE TRIGGER set_timestamp_on_encompass_loan
	BEFORE UPDATE
	ON  loan.encompass_loan
	FOR EACH ROW
EXECUTE PROCEDURE  loan.set_timestamp();




