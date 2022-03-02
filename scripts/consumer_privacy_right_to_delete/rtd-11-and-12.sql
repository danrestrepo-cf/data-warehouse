--
-- EDW | California Consumer Privacy Act: two right-to-delete (RTD) requests:
-- RTD 11: https://app.asana.com/0/0/1201696010784016
-- RTD 12: https://app.asana.com/0/0/1201689552095074
--


/*
RTD 11: loan #1401318407
*/
-- application
UPDATE history_octane.application
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, apl_application_name = 'REDACTED_BORROWER_LAST_NAME'
FROM history_octane.proposal
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE application.apl_proposal_pid = proposal.prp_pid;


-- asset
UPDATE history_octane.asset
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, as_aggregate_description = ''
	, as_automobile_make_description = ''
	, as_automobile_model_year = 0
	, as_cash_or_market_value_amount = 0
	, as_description = ''
	, as_donor_city = ''
	, as_donor_country = ''
	, as_donor_postal_code = ''
	, as_donor_state = ''
	, as_donor_street1 = ''
	, as_donor_street2 = ''
	, as_gift_funds_donor_phone = ''
	, as_gift_funds_donor_relationship = ''
	, as_gift_funds_donor_unparsed_name = ''
	, as_gift_amount = 0
	, as_gift_funds_source_holder_name = ''
	, as_holder_name = ''
	, as_holder_city = ''
	, as_holder_country = ''
	, as_holder_postal_code = ''
	, as_holder_state = ''
	, as_holder_street1 = ''
	, as_holder_street2 = ''
	, as_life_insurance_face_value_amount = 0
	, as_liquid_amount = 0
	, as_liquid_percent = 0
	, as_stock_bond_mutual_fund_share_count = 0
	, as_available_amount = 0
	, as_down_payment_amount = 0
	, as_closing_costs_amount = 0
	, as_penalty_amount = 0
	, as_deposit_date = NULL
	, as_gift_funds_ein = ''
FROM history_octane.borrower_asset
	JOIN history_octane.borrower ON borrower_asset.bas_borrower_pid = borrower.b_pid
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE asset.as_pid = borrower_asset.bas_asset_pid;


-- borrower
UPDATE history_octane.borrower
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, b_alimony_child_support = 'UNKNOWN'
	, b_alimony_child_support_explanation = ''
	, b_bankruptcy = 'UNKNOWN'
	, b_bankruptcy_explanation = ''
	, b_birth_date = NULL
	, b_borrowed_down_payment = 'UNKNOWN'
	, b_borrowed_down_payment_explanation = ''
	, b_spousal_homestead = 'UNKNOWN'
	, b_has_no_ssn = FALSE
	, b_citizenship_residency_type = 'UNKNOWN'
	, b_credit_report_identifier = ''
	, b_has_dependents = 'UNKNOWN'
	, b_dependents_age_years = ''
	, b_email = ''
	, b_fax = ''
	, b_first_name = ''
	, b_nickname = ''
	, b_lender_employee = 'NO'
	, b_lender_employee_status_confirmed = FALSE
	, b_sex_collected_visual_or_surname = 'UNKNOWN'
	, b_sex_male = FALSE
	, b_sex_female = FALSE
	, b_ethnicity_collected_visual_or_surname = 'UNKNOWN'
	, b_ethnicity_hispanic_or_latino = FALSE
	, b_ethnicity_mexican = FALSE
	, b_ethnicity_puerto_rican = FALSE
	, b_ethnicity_cuban = FALSE
	, b_ethnicity_other_hispanic_or_latino = FALSE
	, b_ethnicity_not_hispanic_or_latino = FALSE
	, b_homeowner_past_three_years = 'UNKNOWN'
	, b_home_phone = ''
	, b_intend_to_occupy = 'UNKNOWN'
	, b_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, b_mailing_place_pid = 66955927
	, b_middle_name = ''
	, b_mobile_phone = ''
	, b_name_suffix = ''
	, b_note_endorser = 'UNKNOWN'
	, b_note_endorser_explanation = ''
	, b_obligated_loan_foreclosure = 'UNKNOWN'
	, b_obligated_loan_foreclosure_explanation = ''
	, b_office_phone = ''
	, b_office_phone_extension = ''
	, b_outstanding_judgements = 'UNKNOWN'
	, b_outstanding_judgments_explanation = ''
	, b_party_to_lawsuit = 'UNKNOWN'
	, b_party_to_lawsuit_explanation = ''
	, b_power_of_attorney = 'NO'
	, b_power_of_attorney_signing_capacity = ''
	, b_power_of_attorney_first_name = ''
	, b_power_of_attorney_last_name = ''
	, b_power_of_attorney_middle_name = ''
	, b_power_of_attorney_name_suffix = ''
	, b_power_of_attorney_company_name = ''
	, b_power_of_attorney_title = ''
	, b_power_of_attorney_office_phone = ''
	, b_power_of_attorney_office_phone_extension = ''
	, b_power_of_attorney_mobile_phone = ''
	, b_power_of_attorney_email = ''
	, b_power_of_attorney_fax = ''
	, b_power_of_attorney_city = ''
	, b_power_of_attorney_country = ''
	, b_power_of_attorney_postal_code = ''
	, b_power_of_attorney_state = ''
	, b_power_of_attorney_street1 = ''
	, b_power_of_attorney_street2 = ''
	, b_presently_delinquent = 'UNKNOWN'
	, b_presently_delinquent_explanation = ''
	, b_prior_property_title_type = 'SOLE'
	, b_prior_property_usage_type = 'PRIMARY_RESIDENCE'
	, b_property_foreclosure = 'UNKNOWN'
	, b_property_foreclosure_explanation = ''
	, b_race_collected_visual_or_surname = 'UNKNOWN'
	, b_race_american_indian_or_alaska_native = FALSE
	, b_race_asian = FALSE
	, b_race_asian_indian = FALSE
	, b_race_chinese = FALSE
	, b_race_filipino = FALSE
	, b_race_japanese = FALSE
	, b_race_korean = FALSE
	, b_race_vietnamese = FALSE
	, b_race_other_asian = FALSE
	, b_race_black_or_african_american = FALSE
	, b_race_native_hawaiian_or_other_pacific_islander = FALSE
	, b_race_native_hawaiian = FALSE
	, b_race_guamanian_or_chamorro = FALSE
	, b_race_samoan = FALSE
	, b_race_other_pacific_islander = FALSE
	, b_race_white = FALSE
	, b_schooling_years = 0
	, b_first_time_home_buyer_explain = ''
	, b_caivrs_id = ''
	, b_caivrs_messages = ''
	, b_on_ldp_list = 'UNKNOWN'
	, b_on_gsa_list = 'UNKNOWN'
	, b_monthly_job_federal_tax_amount = 0
	, b_monthly_job_state_tax_amount = 0
	, b_monthly_job_retirement_tax_amount = 0
	, b_monthly_job_medicare_tax_amount = 0
	, b_monthly_job_state_disability_insurance_amount = 0
	, b_monthly_job_other_tax_1_amount = 0
	, b_monthly_job_other_tax_1_description = ''
	, b_monthly_job_other_tax_2_amount = 0
	, b_monthly_job_other_tax_2_description = ''
	, b_monthly_job_other_tax_3_amount = 0
	, b_monthly_job_other_tax_3_description = ''
	, b_monthly_job_total_tax_amount = 0
	, b_homeownership_education_type = 'UNKNOWN'
	, b_homeownership_education_agency_type = 'UNKNOWN'
	, b_homeownership_education_complete_date = NULL
	, b_housing_counseling_type = 'UNKNOWN'
	, b_housing_counseling_agency_type = 'UNKNOWN'
	, b_housing_counseling_complete_date = NULL
	, b_legal_entity_type = 'NA'
	, b_disabled = 'UNKNOWN'
	, b_usda_annual_child_care_expenses = 0
	, b_usda_disability_expenses = 0
	, b_usda_medical_expenses = 0
	, b_usda_income_from_assets = 0
	, b_usda_moderate_income_limit = 0
	, b_hud_employee = FALSE
	, b_preferred_first_name = ''
FROM history_octane.application
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE borrower.b_application_pid = application.apl_pid;


-- borrower_alias
UPDATE history_octane.borrower_alias
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, ba_first_name = ''
	, ba_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, ba_middle_name = ''
	, ba_name_suffix = ''
	, ba_credit_report_identifier = ''
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE borrower_alias.ba_borrower_pid = borrower.b_pid;


-- borrower_associated_address
UPDATE history_octane.borrower_associated_address
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, baa_credit_report_identifier = ''
	, baa_reported_year = 0
	, baa_reported_address_street1 = ''
	, baa_reported_address_street2 = ''
	, baa_reported_address_city = ''
	, baa_reported_address_state = ''
	, baa_reported_address_postal_code = ''
	, baa_reported_address_country = ''
	, baa_current = 'UNKNOWN'
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE borrower_associated_address.baa_borrower_pid = borrower.b_pid;


-- borrower_declarations
UPDATE history_octane.borrower_declarations
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, bdec_fha_secondary_residence = 'UNKNOWN'
	, bdec_relationship_with_seller = 'UNKNOWN'
	, bdec_borrowed_funds_undisclosed = 'UNKNOWN'
	, bdec_borrowed_funds_undisclosed_amount = 0
	, bdec_other_mortgage_in_progress_before_closing = 'UNKNOWN'
	, bdec_applying_for_credit_before_closing = 'UNKNOWN'
	, bdec_priority_given_to_another_lien = 'UNKNOWN'
	, bdec_cosigner_undisclosed = 'UNKNOWN'
	, bdec_currently_delinquent_federal_debt = 'UNKNOWN'
	, bdec_party_to_lawsuit = 'UNKNOWN'
	, bdec_conveyed_title_in_lieu_of_foreclosure = 'UNKNOWN'
	, bdec_completed_pre_foreclosure_short_sale = 'UNKNOWN'
	, bdec_property_foreclosure = 'UNKNOWN'
	, bdec_bankruptcy_chapter_7 = 'UNKNOWN'
	, bdec_bankruptcy_chapter_11 = 'UNKNOWN'
	, bdec_bankruptcy_chapter_12 = 'UNKNOWN'
	, bdec_bankruptcy_chapter_13 = 'UNKNOWN'
	, bdec_intend_to_occupy_more_than_14_days = 'UNKNOWN'
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE borrower_declarations.bdec_borrower_pid = borrower.b_pid;


-- borrower_dependent
UPDATE history_octane.borrower_dependent
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, bd_first_name = ''
	, bd_last_name = ''
	, bd_age = 0
	, bd_disabled = 'UNKNOWN'
	, bd_full_time_student = 'UNKNOWN'
	, bd_receives_income = 'UNKNOWN'
	, bd_income_source = ''
	, bd_income_amount = 0
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE borrower_dependent.bd_borrower_pid = borrower.b_pid;


-- borrower_income
UPDATE history_octane.borrower_income
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, bi_job_gap_reason_type = 'NA'
	, bi_job_gap_reason_explanation = ''
	, bi_business_ownership_type = 'UNSPECIFIED'
	, bi_from_date = NULL
	, bi_through_date = NULL
	, bi_current = FALSE
	, bi_primary = FALSE
	, bi_source_name = ''
	, bi_source_address_street1 = ''
	, bi_source_address_street2 = ''
	, bi_source_address_city = ''
	, bi_source_address_state = ''
	, bi_source_address_postal_code = ''
	, bi_source_address_country = ''
	, bi_source_phone = ''
	, bi_source_phone_extension = ''
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE borrower_income.bi_borrower_pid = borrower.b_pid;


-- borrower_job_gap
UPDATE history_octane.borrower_job_gap
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, bjg_from_date = NULL
	, bjg_through_date = NULL
	, bjg_primary_job = FALSE
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE borrower_job_gap.bjg_borrower_pid = borrower.b_pid;


-- borrower_reo
UPDATE history_octane.borrower_reo
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, breo_place_pid = 66955927
	, breo_ownership_percent = 0
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE borrower_reo.breo_borrower_pid = borrower.b_pid;


-- borrower_residence
UPDATE history_octane.borrower_residence
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, bres_place_pid = 66955927
	, bres_current = FALSE
	, bres_borrower_residency_basis_type = 'RENT'
	, bres_from_date = NULL
	, bres_through_date = NULL
	, bres_verification_required = FALSE
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE borrower_residence.bres_borrower_pid = borrower.b_pid;


-- borrower_tax_filing
UPDATE history_octane.borrower_tax_filing
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
    , btf_place_pid = 66955927
	, btf_tax_filing_status_type = 'UNSPECIFIED'
	, btf_year = 0
	, btf_joint_filer_first_name = ''
	, btf_joint_filer_middle_name = ''
	, btf_joint_filer_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, btf_joint_filer_suffix = ''
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE borrower_tax_filing.btf_borrower_pid = borrower.b_pid;


-- borrower_user
UPDATE history_octane.borrower_user
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, bu_email = ''
	, bu_first_name = ''
	, bu_middle_name = ''
	, bu_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, bu_name_suffix = ''
	, bu_unparsed_name = ''
	, bu_challenge_question_answer = NULL
	, bu_nickname = ''
	, bu_plain_text_email = FALSE
	, bu_preferred_first_name = ''
FROM history_octane.borrower_user_deal
	JOIN history_octane.deal ON borrower_user_deal.bud_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE borrower_user.bu_pid = borrower_user_deal.bud_borrower_user_pid;


-- business_income
UPDATE history_octane.business_income
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, bui_company_ein = ''
	, bui_estimated_net_income_amount = 0
	, bui_worksheet_monthly_total_amount = 0
	, bui_monthly_total_amount = 0
	, bui_borrower_income_percent = 0
	, bui_common_year1_year = 0
	, bui_common_year1_from_date = NULL
	, bui_common_year1_through_date = NULL
	, bui_common_year1_months = 0
	, bui_common_year1_annual_total_amount = 0
	, bui_common_year1_monthly_total_amount = 0
	, bui_common_year2_year = 0
	, bui_common_year2_from_date = NULL
	, bui_common_year2_through_date = NULL
	, bui_common_year2_months = 0
	, bui_common_year2_annual_total_amount = 0
	, bui_common_year2_monthly_total_amount = 0
	, bui_common_year3_year = 0
	, bui_common_year3_from_date = NULL
	, bui_common_year3_through_date = NULL
	, bui_common_year3_months = 0
	, bui_common_year3_annual_total_amount = 0
	, bui_common_year3_monthly_total_amount = 0
	, bui_sole_year1_gross_receipts = 0
	, bui_sole_year1_other_income_loss_exp = 0
	, bui_sole_year1_depletion = 0
	, bui_sole_year1_depreciation = 0
	, bui_sole_year1_meal_exclusions = 0
	, bui_sole_year1_business_use_home = 0
	, bui_sole_year1_amortization_loss = 0
	, bui_sole_year1_business_miles = 0
	, bui_sole_year1_depreciation_mile = 0
	, bui_sole_year1_mileage_depreciation = 0
	, bui_sole_year2_gross_receipts = 0
	, bui_sole_year2_other_income_loss_exp = 0
	, bui_sole_year2_depletion = 0
	, bui_sole_year2_depreciation = 0
	, bui_sole_year2_meal_exclusions = 0
	, bui_sole_year2_business_use_home = 0
	, bui_sole_year2_amortization_loss = 0
	, bui_sole_year2_business_miles = 0
	, bui_sole_year2_depreciation_mile = 0
	, bui_sole_year2_mileage_depreciation = 0
	, bui_sole_year3_gross_receipts = 0
	, bui_sole_year3_other_income_loss_exp = 0
	, bui_sole_year3_depletion = 0
	, bui_sole_year3_depreciation = 0
	, bui_sole_year3_meal_exclusions = 0
	, bui_sole_year3_business_use_home = 0
	, bui_sole_year3_amortization_loss = 0
	, bui_sole_year3_business_miles = 0
	, bui_sole_year3_depreciation_mile = 0
	, bui_sole_year3_mileage_depreciation = 0
	, bui_partner_year1_amortization_loss = 0
	, bui_partner_year1_depletion = 0
	, bui_partner_year1_depreciation = 0
	, bui_partner_year1_guaranteed_payments = 0
	, bui_partner_year1_meals_exclusion = 0
	, bui_partner_year1_net_rental_income_loss = 0
	, bui_partner_year1_notes_payable_less_year = 0
	, bui_partner_year1_ordinary_income_loss = 0
	, bui_partner_year1_other_income_loss = 0
	, bui_partner_year1_ownership_percent = 0
	, bui_partner_year1_form_k_1_total = 0
	, bui_partner_year1_form_1065_subtotal = 0
	, bui_partner_year1_form_1065_total = 0
	, bui_partner_year2_amortization_loss = 0
	, bui_partner_year2_depletion = 0
	, bui_partner_year2_depreciation = 0
	, bui_partner_year2_guaranteed_payments = 0
	, bui_partner_year2_meals_exclusion = 0
	, bui_partner_year2_net_rental_income_loss = 0
	, bui_partner_year2_notes_payable_less_year = 0
	, bui_partner_year2_ordinary_income_loss = 0
	, bui_partner_year2_other_income_loss = 0
	, bui_partner_year2_ownership_percent = 0
	, bui_partner_year2_form_k_1_total = 0
	, bui_partner_year2_form_1065_subtotal = 0
	, bui_partner_year2_form_1065_total = 0
	, bui_partner_year3_amortization_loss = 0
	, bui_partner_year3_depletion = 0
	, bui_partner_year3_depreciation = 0
	, bui_partner_year3_guaranteed_payments = 0
	, bui_partner_year3_meals_exclusion = 0
	, bui_partner_year3_net_rental_income_loss = 0
	, bui_partner_year3_notes_payable_less_year = 0
	, bui_partner_year3_ordinary_income_loss = 0
	, bui_partner_year3_other_income_loss = 0
	, bui_partner_year3_ownership_percent = 0
	, bui_partner_year3_form_k_1_total = 0
	, bui_partner_year3_form_1065_subtotal = 0
	, bui_partner_year3_form_1065_total = 0
	, bui_scorp_year1_ordinary_income_loss = 0
	, bui_scorp_year1_net_rental_income_loss = 0
	, bui_scorp_year1_other_income_loss = 0
	, bui_scorp_year1_depletion = 0
	, bui_scorp_year1_depreciation = 0
	, bui_scorp_year1_amortization_loss = 0
	, bui_scorp_year1_notes_payable_less_year = 0
	, bui_scorp_year1_meals_exclusion = 0
	, bui_scorp_year1_ownership_percent = 0
	, bui_scorp_year1_form_k_1_total = 0
	, bui_scorp_year1_form_1120s_subtotal = 0
	, bui_scorp_year1_form_1120s_total = 0
	, bui_scorp_year2_ordinary_income_loss = 0
	, bui_scorp_year2_net_rental_income_loss = 0
	, bui_scorp_year2_other_income_loss = 0
	, bui_scorp_year2_depletion = 0
	, bui_scorp_year2_depreciation = 0
	, bui_scorp_year2_amortization_loss = 0
	, bui_scorp_year2_notes_payable_less_year = 0
	, bui_scorp_year2_meals_exclusion = 0
	, bui_scorp_year2_ownership_percent = 0
	, bui_scorp_year2_form_k_1_total = 0
	, bui_scorp_year2_form_1120s_subtotal = 0
	, bui_scorp_year2_form_1120s_total = 0
	, bui_scorp_year3_ordinary_income_loss = 0
	, bui_scorp_year3_net_rental_income_loss = 0
	, bui_scorp_year3_other_income_loss = 0
	, bui_scorp_year3_depletion = 0
	, bui_scorp_year3_depreciation = 0
	, bui_scorp_year3_amortization_loss = 0
	, bui_scorp_year3_notes_payable_less_year = 0
	, bui_scorp_year3_meals_exclusion = 0
	, bui_scorp_year3_ownership_percent = 0
	, bui_scorp_year3_form_k_1_total = 0
	, bui_scorp_year3_form_1120s_subtotal = 0
	, bui_scorp_year3_form_1120s_total = 0
	, bui_corp_year1_taxable_income = 0
	, bui_corp_year1_total_tax = 0
	, bui_corp_year1_gain_loss = 0
	, bui_corp_year1_other_income_loss = 0
	, bui_corp_year1_depreciation = 0
	, bui_corp_year1_depletion = 0
	, bui_corp_year1_domestic_production_activities = 0
	, bui_corp_year1_other_deductions = 0
	, bui_corp_year1_net_operating_loss_special_deductions = 0
	, bui_corp_year1_notes_payable_less_one_year = 0
	, bui_corp_year1_meals_exclusion = 0
	, bui_corp_year1_dividends_paid_to_borrower = 0
	, bui_corp_year1_annual_subtotal = 0
	, bui_corp_year1_ownership_percent = 0
	, bui_corp_year1_annual_subtotal_ownership_applied = 0
	, bui_corp_year2_taxable_income = 0
	, bui_corp_year2_total_tax = 0
	, bui_corp_year2_gain_loss = 0
	, bui_corp_year2_other_income_loss = 0
	, bui_corp_year2_depreciation = 0
	, bui_corp_year2_depletion = 0
	, bui_corp_year2_domestic_production_activities = 0
	, bui_corp_year2_other_deductions = 0
	, bui_corp_year2_net_operating_loss_special_deductions = 0
	, bui_corp_year2_notes_payable_less_one_year = 0
	, bui_corp_year2_meals_exclusion = 0
	, bui_corp_year2_dividends_paid_to_borrower = 0
	, bui_corp_year2_annual_subtotal = 0
	, bui_corp_year2_ownership_percent = 0
	, bui_corp_year2_annual_subtotal_ownership_applied = 0
	, bui_corp_year3_taxable_income = 0
	, bui_corp_year3_total_tax = 0
	, bui_corp_year3_gain_loss = 0
	, bui_corp_year3_other_income_loss = 0
	, bui_corp_year3_depreciation = 0
	, bui_corp_year3_depletion = 0
	, bui_corp_year3_domestic_production_activities = 0
	, bui_corp_year3_other_deductions = 0
	, bui_corp_year3_net_operating_loss_special_deductions = 0
	, bui_corp_year3_notes_payable_less_one_year = 0
	, bui_corp_year3_meals_exclusion = 0
	, bui_corp_year3_dividends_paid_to_borrower = 0
	, bui_corp_year3_annual_subtotal = 0
	, bui_corp_year3_ownership_percent = 0
	, bui_corp_year3_annual_subtotal_ownership_applied = 0
	, bui_sch_f_year1_specific_income_loss = 0
	, bui_sch_f_year1_nonrecurring_income_loss = 0
	, bui_sch_f_year1_depreciation = 0
	, bui_sch_f_year1_amortization_loss_depletion = 0
	, bui_sch_f_year1_business_use_home = 0
	, bui_sch_f_year2_specific_income_loss = 0
	, bui_sch_f_year2_nonrecurring_income_loss = 0
	, bui_sch_f_year2_depreciation = 0
	, bui_sch_f_year2_amortization_loss_depletion = 0
	, bui_sch_f_year2_business_use_home = 0
	, bui_sch_f_year3_specific_income_loss = 0
	, bui_sch_f_year3_nonrecurring_income_loss = 0
	, bui_sch_f_year3_depreciation = 0
	, bui_sch_f_year3_amortization_loss_depletion = 0
	, bui_sch_f_year3_business_use_home = 0
	, bui_underwriter_comments = ''
FROM history_octane.borrower_income
	JOIN history_octane.borrower ON borrower_income.bi_borrower_pid = borrower.b_pid
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE business_income.bui_borrower_income_pid = borrower_income.bi_pid;


-- credit_inquiry
UPDATE history_octane.credit_inquiry
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, ci_inquiry_date = NULL
	, ci_name = ''
	, ci_address_street1 = ''
	, ci_address_street2 = ''
	, ci_address_city = ''
	, ci_address_state = ''
	, ci_address_postal_code = ''
	, ci_address_country = ''
	, ci_phone = ''
	, ci_credit_report_identifier = ''
FROM history_octane.borrower_credit_inquiry
	JOIN history_octane.borrower ON borrower_credit_inquiry.bci_borrower_pid = borrower.b_pid
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE credit_inquiry.ci_pid = borrower_credit_inquiry.bci_credit_inquiry_pid;


-- credit_request
UPDATE history_octane.credit_request
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, crdr_requester_unparsed_name = ''
	, crdr_borrower1_first_name = ''
	, crdr_borrower1_middle_name = ''
	, crdr_borrower1_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, crdr_borrower1_name_suffix = ''
	, crdr_borrower1_birth_date = NULL
	, crdr_borrower1_residence_city = ''
	, crdr_borrower1_residence_country = ''
	, crdr_borrower1_residence_postal_code = ''
	, crdr_borrower1_residence_state = ''
	, crdr_borrower1_residence_street1 = ''
	, crdr_borrower1_residence_street2 = ''
	, crdr_borrower1_experian_credit_score = 0
	, crdr_borrower1_equifax_credit_score = 0
	, crdr_borrower1_trans_union_credit_score = 0
	, crdr_borrower2_first_name = ''
	, crdr_borrower2_middle_name = ''
	, crdr_borrower2_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, crdr_borrower2_name_suffix = ''
	, crdr_borrower2_birth_date = NULL
	, crdr_borrower2_residence_city = ''
	, crdr_borrower2_residence_country = ''
	, crdr_borrower2_residence_postal_code = ''
	, crdr_borrower2_residence_state = ''
	, crdr_borrower2_residence_street1 = ''
	, crdr_borrower2_residence_street2 = ''
	, crdr_borrower2_experian_credit_score = 0
	, crdr_borrower2_equifax_credit_score = 0
	, crdr_borrower2_trans_union_credit_score = 0
	, crdr_credit_report_identifier = ''
FROM history_octane.deal
WHERE credit_request.crdr_deal_pid = deal.d_pid
	AND deal.d_los_loan_id_main = 1401318407;


-- credit_request_liability
UPDATE history_octane.credit_request_liability
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, crl_credit_report_identifier = ''
	, crl_report_holder_name = ''
	, crl_report_account_opened_date = NULL
	, crl_account_reported_date = NULL
	, crl_last_activity_date = NULL
	, crl_most_recent_adverse_rating_date = NULL
	, crl_report_monthly_payment_amount = 0
	, crl_report_remaining_term_months = 0
	, crl_months_reviewed_count = 0
	, crl_report_unpaid_balance_amount = 0
	, crl_report_credit_limit_amount = 0
	, crl_report_past_due_amount = 0
	, crl_report_terms_months_count = 0
	, crl_report_liability_current_rating_type = 'UNKNOWN'
	, crl_report_liability_account_status_type = 'UNKNOWN'
	, crl_report_liability_account_ownership_type = 'UNKNOWN'
	, crl_consumer_dispute = 'UNKNOWN'
	, crl_derogatory_data = 'UNKNOWN'
	, crl_late_30_days_count = ''
	, crl_late_60_days_count = ''
	, crl_late_90_days_count = ''
FROM history_octane.deal
WHERE credit_request_liability.crl_deal_pid = deal.d_pid
	AND deal.d_los_loan_id_main = 1401318407;


-- deal
UPDATE history_octane.deal
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, d_deal_status_type = 'CANCELLED'
	, d_hmda_action_date = CURRENT_DATE
	, d_hmda_action_type = 'WITHDRAWN'
WHERE deal.d_los_loan_id_main = 1401318407;


-- deal_invoice
UPDATE history_octane.deal_invoice
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, di_description = ''
	, di_internal_notes = ''
FROM history_octane.deal
WHERE deal_invoice.di_deal_pid = deal.d_pid
  AND deal.d_los_loan_id_main = 1401318407;


-- deal_invoice_payment_method
UPDATE history_octane.deal_invoice_payment_method
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, dipm_payer_unparsed_name = ''
FROM history_octane.deal_invoice
	JOIN history_octane.deal ON deal_invoice.di_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE deal_invoice_payment_method.dipm_deal_invoice_pid = deal_invoice.di_pid;


-- deal_signer
UPDATE history_octane.deal_signer
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, dsi_email = ''
	, dsi_first_name = ''
	, dsi_middle_name = ''
	, dsi_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, dsi_name_suffix = ''
	, dsi_signer_id = ''
FROM history_octane.deal
WHERE deal_signer.dsi_deal_pid = deal.d_pid
	AND deal.d_los_loan_id_main = 1401318407;


-- deal_tag
UPDATE history_octane.deal_tag
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, dtg_place_pid = 66955927
FROM history_octane.deal
WHERE deal_tag.dtg_deal_pid = deal.d_pid
	AND deal.d_los_loan_id_main = 1401318407;


-- du_request
UPDATE history_octane.du_request
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, dur_requester_unparsed_name = ''
	, dur_mp_status_log = ''
	, dur_loan_amount = 0
	, dur_initial_pi_amount = 0
	, dur_note_rate_percent = 0
	, dur_initial_note_rate_percent = 0
	, dur_ltv_ratio_percent = 0
	, dur_cltv_ratio_percent = 0
	, dur_housing_ratio_percent = 0
	, dur_debt_ratio_percent = 0
	, dur_du_ltv_ratio_percent = 0
	, dur_du_cltv_ratio_percent = 0
	, dur_du_housing_ratio_percent = 0
	, dur_du_debt_ratio_percent = 0
	, dur_cash_from_borrower_amount = 0
	, dur_aus_cash_from_borrower_amount = 0
FROM history_octane.proposal
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE du_request.dur_proposal_pid = proposal.prp_pid;


-- job_income
UPDATE history_octane.job_income
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, ji_line_of_work_years = 0
	, ji_monthly_base_unadjusted_amount = 0
	, ji_monthly_base_adjustment_amount = 0
	, ji_monthly_overtime_unadjusted_amount = 0
	, ji_monthly_overtime_adjustment_amount = 0
	, ji_monthly_bonus_unadjusted_amount = 0
	, ji_monthly_bonus_adjustment_amount = 0
	, ji_monthly_commissions_unadjusted_amount = 0
	, ji_monthly_commissions_adjustment_amount = 0
	, ji_monthly_tip_unadjusted_amount = 0
	, ji_monthly_tip_adjustment_amount = 0
	, ji_monthly_adjustment_amount = 0
	, ji_employer_relative = FALSE
	, ji_employer_property_seller = FALSE
	, ji_employer_real_estate_broker = FALSE
	, ji_military_job = FALSE
	, ji_estimated_monthly_military_amount = 0
	, ji_monthly_military_base_pay_amount = 0
	, ji_monthly_military_clothes_allowance_ungrossed_amount = 0
	, ji_monthly_military_combat_pay_amount = 0
	, ji_monthly_military_flight_pay_amount = 0
	, ji_monthly_military_hazard_pay_amount = 0
	, ji_monthly_military_housing_allowance_ungrossed_amount = 0
	, ji_monthly_military_overseas_pay_amount = 0
	, ji_monthly_military_prop_pay_amount = 0
	, ji_monthly_military_quarters_allowance_ungrossed_amount = 0
	, ji_monthly_military_rations_allowance_ungrossed_amount = 0
	, ji_military_gross_up_percent = 0
	, ji_monthly_military_clothes_allowance_amount = 0
	, ji_monthly_military_quarters_allowance_amount = 0
	, ji_monthly_military_rations_allowance_amount = 0
	, ji_monthly_military_housing_allowance_amount = 0
	, ji_military_pay_subtotal_amount = 0
	, ji_military_allowance_subtotal_amount = 0
	, ji_monthly_military_total_amount = 0
	, ji_annual_military_total_amount = 0
	, ji_job_year1_year = 0
	, ji_job_year1_from_date = NULL
	, ji_job_year1_through_date = NULL
	, ji_job_year1_months = 0
	, ji_job_year1_base_input_amount = 0
	, ji_job_year1_monthly_base_amount = 0
	, ji_job_year1_overtime_input_amount = 0
	, ji_job_year1_monthly_overtime_amount = 0
	, ji_job_year1_bonus_input_amount = 0
	, ji_job_year1_monthly_bonus_amount = 0
	, ji_job_year1_commissions_input_amount = 0
	, ji_job_year1_monthly_commissions_amount = 0
	, ji_job_year1_tip_input_amount = 0
	, ji_job_year1_monthly_tip_amount = 0
	, ji_job_year1_adjustment_input_amount = 0
	, ji_job_year1_monthly_adjustment_amount = 0
	, ji_job_year1_monthly_total_amount = 0
	, ji_job_year1_annual_total_amount = 0
	, ji_job_year1_monthly_total_commissions_percent = 0
	, ji_job_year2_year = 0
	, ji_job_year2_from_date = NULL
	, ji_job_year2_through_date = NULL
	, ji_job_year2_months = 0
	, ji_job_year2_base_input_amount = 0
	, ji_job_year2_monthly_base_amount = 0
	, ji_job_year2_overtime_input_amount = 0
	, ji_job_year2_monthly_overtime_amount = 0
	, ji_job_year2_bonus_input_amount = 0
	, ji_job_year2_monthly_bonus_amount = 0
	, ji_job_year2_commissions_input_amount = 0
	, ji_job_year2_monthly_commissions_amount = 0
	, ji_job_year2_tip_input_amount = 0
	, ji_job_year2_monthly_tip_amount = 0
	, ji_job_year2_adjustment_input_amount = 0
	, ji_job_year2_monthly_adjustment_amount = 0
	, ji_job_year2_monthly_total_amount = 0
	, ji_job_year2_annual_total_amount = 0
	, ji_job_year2_monthly_total_commissions_percent = 0
	, ji_job_year3_year = 0
	, ji_job_year3_from_date = NULL
	, ji_job_year3_through_date = NULL
	, ji_job_year3_months = 0
	, ji_job_year3_base_input_amount = 0
	, ji_job_year3_monthly_base_amount = 0
	, ji_job_year3_overtime_input_amount = 0
	, ji_job_year3_monthly_overtime_amount = 0
	, ji_job_year3_bonus_input_amount = 0
	, ji_job_year3_monthly_bonus_amount = 0
	, ji_job_year3_commissions_input_amount = 0
	, ji_job_year3_monthly_commissions_amount = 0
	, ji_job_year3_tip_input_amount = 0
	, ji_job_year3_monthly_tip_amount = 0
	, ji_job_year3_adjustment_input_amount = 0
	, ji_job_year3_monthly_adjustment_amount = 0
	, ji_job_year3_monthly_total_amount = 0
	, ji_job_year3_annual_total_amount = 0
	, ji_job_year3_monthly_total_commissions_percent = 0
	, ji_estimated_monthly_base_amount = 0
	, ji_estimated_monthly_bonus_amount = 0
	, ji_estimated_monthly_overtime_amount = 0
	, ji_estimated_monthly_commissions_amount = 0
	, ji_estimated_monthly_tip_amount = 0
	, ji_estimated_monthly_total_amount = 0
	, ji_estimated_annual_total_amount = 0
	, ji_estimated_monthly_total_commissions_percent = 0
	, ji_worksheet_monthly_base_amount = 0
	, ji_worksheet_monthly_bonus_amount = 0
	, ji_worksheet_monthly_overtime_amount = 0
	, ji_worksheet_monthly_commissions_amount = 0
	, ji_worksheet_monthly_tip_amount = 0
	, ji_worksheet_monthly_total_amount = 0
	, ji_worksheet_annual_total_amount = 0
	, ji_worksheet_monthly_total_commissions_percent = 0
	, ji_working_monthly_base_amount = 0
	, ji_working_monthly_bonus_amount = 0
	, ji_working_monthly_overtime_amount = 0
	, ji_working_monthly_commissions_amount = 0
	, ji_working_monthly_tip_amount = 0
	, ji_working_monthly_total_amount = 0
	, ji_working_annual_total_amount = 0
	, ji_working_monthly_total_commissions_percent = 0
	, ji_underwriter_comments = ''
	, ji_voe_third_party_verifier_order_id = ''
	, ji_employer_voe_name = ''
	, ji_employer_voe_title = ''
	, ji_employer_voe_phone = ''
	, ji_employer_voe_phone_extension = ''
	, ji_employer_voe_fax = ''
	, ji_employer_voe_email = ''
	, ji_employer_other_interested_party_description = ''
	, ji_line_of_work_months = 0
FROM history_octane.borrower_income
	JOIN history_octane.borrower ON borrower_income.bi_borrower_pid = borrower.b_pid
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE job_income.ji_borrower_income_pid = borrower_income.bi_pid;


-- liability
UPDATE history_octane.liability
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, lia_aggregate_description = ''
	, lia_description = ''
	, lia_city = ''
	, lia_country = ''
	, lia_postal_code = ''
	, lia_state = ''
	, lia_street1 = ''
	, lia_street2 = ''
	, lia_holder_name = ''
	, lia_holder_phone = ''
	, lia_holder_phone_extension = ''
	, lia_holder_fax = ''
	, lia_holder_email = ''
	, lia_account_opened_date = NULL
	, lia_monthly_payment_amount = 0
	, lia_remaining_term_months = 0
	, lia_high_balance_amount = 0
	, lia_credit_limit_amount = 0
	, lia_past_due_amount = 0
	, lia_unpaid_balance_amount = 0
	, lia_note = ''
	, lia_terms_months_count = 0
	, lia_payoff_amount = 0
FROM history_octane.borrower_liability
	JOIN history_octane.borrower ON borrower_liability.bl_borrower_pid = borrower.b_pid
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE liability.lia_pid = borrower_liability.bl_liability_pid;


-- loan_hedge
UPDATE history_octane.loan_hedge
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, lh_effective_credit_score = 0
	, lh_debt_to_income = 0
	, lh_note_date = NULL
	, lh_borrower_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, lh_borrower_first_name = ''
	, lh_co_borrower_first_name = ''
	, lh_co_borrower_last_name = ''
	, lh_total_borrower_income = 0
	, lh_borrower_decision_credit_score = 0
	, lh_co_borrower_decision_credit_score = 0
	, lh_b2_first_name = ''
	, lh_b2_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, lh_c2_first_name = ''
	, lh_c2_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, lh_b3_first_name = ''
	, lh_b3_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, lh_c3_first_name = ''
	, lh_c3_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, lh_b4_first_name = ''
	, lh_b4_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, lh_c4_first_name = ''
	, lh_c4_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, lh_b5_first_name = ''
	, lh_b5_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, lh_c5_first_name = ''
	, lh_c5_last_name = 'REDACTED_BORROWER_LAST_NAME'
FROM history_octane.loan
	JOIN history_octane.proposal ON loan.l_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE loan_hedge.lh_loan_pid = loan.l_pid;


-- lp_request
UPDATE history_octane.lp_request
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, lpr_requester_unparsed_name = ''
	, lpr_loan_amount = 0
	, lpr_initial_pi_amount = 0
	, lpr_note_rate_percent = 0
	, lpr_initial_note_rate_percent = 0
	, lpr_ltv_ratio_percent = 0
	, lpr_cltv_ratio_percent = 0
	, lpr_hcltv_ratio_percent = 0
	, lpr_housing_ratio_percent = 0
	, lpr_debt_ratio_percent = 0
	, lpr_lp_ltv_ratio_percent = 0
	, lpr_lp_total_ltv_ratio_percent = 0
	, lpr_lp_high_total_ltv_ratio_percent = 0
	, lpr_lp_housing_ratio_percent = 0
	, lpr_lp_debt_ratio_percent = 0
	, lpr_lp_total_funds_to_be_verified_amount = 0
	, lpr_lp_required_borrower_funds_amount = 0
	, lpr_lp_paid_off_debt_amount = 0
	, lpr_lp_required_reserves_amount = 0
	, lpr_lp_total_eligible_assets_amount = 0
	, lpr_lp_proceeds_from_subordinate_financing_amount = 0
	, lpr_lp_calculated_reserves_amount = 0
	, lpr_aus_request_number = 0
	, lpr_cash_from_borrower_amount = 0
	, lpr_aus_cash_from_borrower_amount = 0
FROM history_octane.proposal
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE lp_request.lpr_proposal_pid = proposal.prp_pid;


-- military_service
UPDATE history_octane.military_service
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, ms_from_date = NULL
	, ms_through_date = NULL
	, ms_name_used_during_service = ''
	, ms_service_number = ''
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE military_service.ms_borrower_pid = borrower.b_pid;


-- other_income
UPDATE history_octane.other_income
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, oi_estimated_net_income_amount = 0
	, oi_worksheet_monthly_total_amount = 0
	, oi_monthly_total_amount = 0
	, oi_borrower_income_percent = 0
	, oi_description = ''
	, oi_common_year1_year = 0
	, oi_common_year1_from_date = NULL
	, oi_common_year1_through_date = NULL
	, oi_common_year1_months = 0
	, oi_common_year1_annual_total_amount = 0
	, oi_common_year1_monthly_total_amount = 0
	, oi_common_year2_year = 0
	, oi_common_year2_from_date = NULL
	, oi_common_year2_through_date = NULL
	, oi_common_year2_months = 0
	, oi_common_year2_annual_total_amount = 0
	, oi_common_year2_monthly_total_amount = 0
	, oi_common_year3_year = 0
	, oi_common_year3_from_date = NULL
	, oi_common_year3_through_date = NULL
	, oi_common_year3_months = 0
	, oi_common_year3_annual_total_amount = 0
	, oi_common_year3_monthly_total_amount = 0
	, oi_simple_year1_unadjusted_amount = 0
	, oi_simple_year1_tax_exempt_tax_rate_percent = 0
	, oi_simple_year1_tax_exempt_amount = 0
	, oi_simple_year2_unadjusted_amount = 0
	, oi_simple_year2_tax_exempt_tax_rate_percent = 0
	, oi_simple_year2_tax_exempt_amount = 0
	, oi_simple_year3_unadjusted_amount = 0
	, oi_simple_year3_tax_exempt_tax_rate_percent = 0
	, oi_simple_year3_tax_exempt_amount = 0
	, oi_simple_unadjusted_monthly_amount = 0
	, oi_simple_tax_exempt_tax_rate_percent = 0
	, oi_simple_tax_exempt_amount = 0
	, oi_simple_calculated_monthly_amount = 0
	, oi_underwriter_comments = ''
	, oi_mcc_reservation_number = ''
	, oi_mcc_reservation_date = NULL
	, oi_mcc_reservation_expiration_date = NULL
	, oi_mcc_commitment_number = ''
	, oi_mcc_underwriting_certification_deadline_date = NULL
	, oi_mcc_delivered_by_date = NULL
	, oi_unadjusted_monthly_total_amount = 0
	, oi_simple_year1_unadjusted_monthly_amount = 0
	, oi_simple_year2_unadjusted_monthly_amount = 0
	, oi_simple_year3_unadjusted_monthly_amount = 0
FROM history_octane.borrower_income
	JOIN history_octane.borrower ON borrower_income.bi_borrower_pid = borrower.b_pid
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE other_income.oi_borrower_income_pid = borrower_income.bi_pid;


-- proposal
UPDATE history_octane.proposal
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, prp_smart_docs_enabled = FALSE
	, prp_note_date = NULL
	, prp_intent_to_proceed_provider_unparsed_name = ''
	, prp_intent_to_proceed_obtainer_unparsed_name = ''
FROM history_octane.deal
WHERE proposal.prp_deal_pid = deal.d_pid
	AND deal.d_los_loan_id_main = 1401318407;


-- proposal_doc
UPDATE history_octane.proposal_doc
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, prpd_deal_child_name = ''
	, prpd_reo_place_pid = 66955927
	, prpd_property_place_pid = 66955927
	, prpd_residence_place_pid = 66955927
	, prpd_status_unparsed_name = ''
	, prpd_doc_excluded_unparsed_name = ''
	, prpd_prior_to_type_unparsed_name = ''
	, prpd_provider_type_unparsed_name = ''
FROM history_octane.proposal
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE proposal_doc.prpd_proposal_pid = proposal.prp_pid;


-- proposal_doc_set
UPDATE history_octane.proposal_doc_set
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, prpds_creator_unparsed_name = ''
	, prpds_requester_unparsed_name = ''
	, prpds_canceler_unparsed_name = ''
FROM history_octane.proposal
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE proposal_doc_set.prpds_proposal_pid = proposal.prp_pid;


-- proposal_req
UPDATE history_octane.proposal_req
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, prpr_fulfill_status_unparsed_name = ''
	, prpr_decision_status_unparsed_name = ''
	, prpr_reo_place_pid = 66955927
	, prpr_property_place_pid = 66955927
	, prpr_residence_place_pid = 66955927
	, prpr_deal_child_name = ''
FROM history_octane.proposal
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE proposal_req.prpr_proposal_pid = proposal.prp_pid;


-- proposal_review
UPDATE history_octane.proposal_review
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, prpre_request_summary = ''
	, prpre_decision_summary = ''
FROM history_octane.proposal
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE proposal_review.prpre_proposal_pid = proposal.prp_pid;


-- proposal_summary
UPDATE history_octane.proposal_summary
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, ps_b1_first_name = ''
	, ps_c1_first_name = ''
	, ps_b2_first_name = ''
	, ps_b1_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, ps_c1_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, ps_b2_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, ps_b1_middle_name = ''
	, ps_c1_middle_name = ''
	, ps_b2_middle_name = ''
	, ps_b1_preferred_first_name = ''
	, ps_b2_preferred_first_name = ''
	, ps_c1_preferred_first_name = ''
	, ps_b1_birth_date = NULL
	, ps_c1_birth_date = NULL
	, ps_b1_monthly_income = 0
	, ps_c1_monthly_income = 0
	, ps_b2_monthly_income = 0
	, ps_b1_has_business_income = FALSE
	, ps_c1_has_business_income = FALSE
	, ps_b2_has_business_income = FALSE
	, ps_b1_citizenship_residency_type = 'UNKNOWN'
	, ps_c1_citizenship_residency_type = 'UNKNOWN'
	, ps_b2_citizenship_residency_type = 'UNKNOWN'
	, ps_b1_hmda_ethnicity_2017_type = 'NOT_OBTAINABLE'
	, ps_c1_hmda_ethnicity_2017_type = 'NOT_OBTAINABLE'
	, ps_b2_hmda_ethnicity_2017_type = 'NOT_OBTAINABLE'
	, ps_b1_decision_credit_score = 0
	, ps_c1_decision_credit_score = 0
	, ps_b2_decision_credit_score = 0
	, ps_b1_gender_type = 'NOT_OBTAINABLE'
	, ps_c1_gender_type = 'NOT_OBTAINABLE'
	, ps_b2_gender_type = 'NOT_OBTAINABLE'
	, ps_b1_hmda_race_2017_type = 'NA'
	, ps_c1_hmda_race_2017_type = 'NA'
	, ps_b2_hmda_race_2017_type = 'NA'
	, ps_any_lender_employee_borrower = FALSE
	, ps_primary_application_name = 'REDACTED_BORROWER_LAST_NAME'
FROM history_octane.proposal
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE proposal_summary.ps_proposal_pid = proposal.prp_pid;

-- public_record
UPDATE history_octane.public_record
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, pr_disposition_date = NULL
	, pr_filed_date = NULL
	, pr_reported_date = NULL
	, pr_settled_date = NULL
	, pr_paid_date = NULL
	, pr_docket_id = ''
	, pr_bankruptcy_assets_amount = 0
	, pr_bankruptcy_exempt_amount = 0
	, pr_bankruptcy_liabilities_amount = 0
	, pr_legal_obligation_amount = 0
	, pr_court_name = ''
	, pr_plaintiff_name = ''
	, pr_defendant_name = ''
	, pr_attorney_name = ''
	, pr_comment = ''
	, pr_note = ''
	, pr_credit_report_identifier = ''
FROM history_octane.borrower_public_record
	JOIN history_octane.borrower ON borrower_public_record.bpr_borrower_pid = borrower.b_pid
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE public_record.pr_pid = borrower_public_record.bpr_public_record_pid;


-- rental_income
UPDATE history_octane.rental_income
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, ri_place_pid = 66955927
	, ri_rental_income_estimated_gross_monthly_amount = 0
	, ri_simple_monthly_total_amount = 0
	, ri_schedule_e_calculated_gross_monthly_amount = 0
	, ri_schedule_e_proposed_monthly_expense_amount = 0
	, ri_schedule_e_net_monthly_amount = 0
	, ri_rental_income_monthly_total_amount = 0
	, ri_schedule_e_non_recurring_expense_1 = ''
	, ri_schedule_e_non_recurring_expense_2 = ''
	, ri_schedule_e_non_recurring_expense_3 = ''
	, ri_common_year1_year = 0
	, ri_common_year1_from_date = NULL
	, ri_common_year1_through_date = NULL
	, ri_common_year1_months = 0
	, ri_common_year1_annual_total_amount = 0
	, ri_common_year1_monthly_total_amount = 0
	, ri_common_year2_year = 0
	, ri_common_year2_from_date = NULL
	, ri_common_year2_through_date = NULL
	, ri_common_year2_months = 0
	, ri_common_year2_annual_total_amount = 0
	, ri_common_year2_monthly_total_amount = 0
	, ri_common_year3_year = 0
	, ri_common_year3_from_date = NULL
	, ri_common_year3_through_date = NULL
	, ri_common_year3_months = 0
	, ri_common_year3_annual_total_amount = 0
	, ri_common_year3_monthly_total_amount = 0
	, ri_schedule_e_year1_rent_received_amount = 0
	, ri_schedule_e_year1_advertising_expense_amount = 0
	, ri_schedule_e_year1_auto_travel_expense_amount = 0
	, ri_schedule_e_year1_cleaning_maintenance_expense_amount = 0
	, ri_schedule_e_year1_commissions_expense_amount = 0
	, ri_schedule_e_year1_insurance_expense_amount = 0
	, ri_schedule_e_year1_legal_professional_expense_amount = 0
	, ri_schedule_e_year1_management_expense_amount = 0
	, ri_schedule_e_year1_mortgage_interest_expense_amount = 0
	, ri_schedule_e_year1_other_interest_expense_amount = 0
	, ri_schedule_e_year1_repairs_expense_amount = 0
	, ri_schedule_e_year1_supplies_expense_amount = 0
	, ri_schedule_e_year1_taxes_expense_amount = 0
	, ri_schedule_e_year1_utilities_expense_amount = 0
	, ri_schedule_e_year1_depreciation_expense_amount = 0
	, ri_schedule_e_year1_other_expense_amount = 0
	, ri_schedule_e_year1_total_expense_amount = 0
	, ri_schedule_e_year1_non_recurring_expense_amount_1 = 0
	, ri_schedule_e_year1_non_recurring_expense_amount_2 = 0
	, ri_schedule_e_year1_non_recurring_expense_amount_3 = 0
	, ri_schedule_e_year1_insurance_credit_amount = 0
	, ri_schedule_e_year1_taxes_credit_amount = 0
	, ri_schedule_e_year1_annual_subtotal = 0
	, ri_schedule_e_year1_ownership_percent = 0
	, ri_schedule_e_year2_rent_received_amount = 0
	, ri_schedule_e_year2_advertising_expense_amount = 0
	, ri_schedule_e_year2_auto_travel_expense_amount = 0
	, ri_schedule_e_year2_cleaning_maintenance_expense_amount = 0
	, ri_schedule_e_year2_commissions_expense_amount = 0
	, ri_schedule_e_year2_insurance_expense_amount = 0
	, ri_schedule_e_year2_legal_professional_expense_amount = 0
	, ri_schedule_e_year2_management_expense_amount = 0
	, ri_schedule_e_year2_mortgage_interest_expense_amount = 0
	, ri_schedule_e_year2_other_interest_expense_amount = 0
	, ri_schedule_e_year2_repairs_expense_amount = 0
	, ri_schedule_e_year2_supplies_expense_amount = 0
	, ri_schedule_e_year2_taxes_expense_amount = 0
	, ri_schedule_e_year2_utilities_expense_amount = 0
	, ri_schedule_e_year2_depreciation_expense_amount = 0
	, ri_schedule_e_year2_other_expense_amount = 0
	, ri_schedule_e_year2_total_expense_amount = 0
	, ri_schedule_e_year2_non_recurring_expense_amount_1 = 0
	, ri_schedule_e_year2_non_recurring_expense_amount_2 = 0
	, ri_schedule_e_year2_non_recurring_expense_amount_3 = 0
	, ri_schedule_e_year2_insurance_credit_amount = 0
	, ri_schedule_e_year2_taxes_credit_amount = 0
	, ri_schedule_e_year2_annual_subtotal = 0
	, ri_schedule_e_year2_ownership_percent = 0
	, ri_schedule_e_year3_rent_received_amount = 0
	, ri_schedule_e_year3_advertising_expense_amount = 0
	, ri_schedule_e_year3_auto_travel_expense_amount = 0
	, ri_schedule_e_year3_cleaning_maintenance_expense_amount = 0
	, ri_schedule_e_year3_commissions_expense_amount = 0
	, ri_schedule_e_year3_insurance_expense_amount = 0
	, ri_schedule_e_year3_legal_professional_expense_amount = 0
	, ri_schedule_e_year3_management_expense_amount = 0
	, ri_schedule_e_year3_mortgage_interest_expense_amount = 0
	, ri_schedule_e_year3_other_interest_expense_amount = 0
	, ri_schedule_e_year3_repairs_expense_amount = 0
	, ri_schedule_e_year3_supplies_expense_amount = 0
	, ri_schedule_e_year3_taxes_expense_amount = 0
	, ri_schedule_e_year3_utilities_expense_amount = 0
	, ri_schedule_e_year3_depreciation_expense_amount = 0
	, ri_schedule_e_year3_other_expense_amount = 0
	, ri_schedule_e_year3_total_expense_amount = 0
	, ri_schedule_e_year3_non_recurring_expense_amount_1 = 0
	, ri_schedule_e_year3_non_recurring_expense_amount_2 = 0
	, ri_schedule_e_year3_non_recurring_expense_amount_3 = 0
	, ri_schedule_e_year3_insurance_credit_amount = 0
	, ri_schedule_e_year3_taxes_credit_amount = 0
	, ri_schedule_e_year3_annual_subtotal = 0
	, ri_schedule_e_year3_ownership_percent = 0
	, ri_simple_monthly_rent_amount = 0
	, ri_simple_vacancy_maintenance_adjustment_percent = 0
	, ri_simple_monthly_net_rent_amount = 0
	, ri_simple_monthly_expense_amount = 0
	, ri_simple_monthly_pre_ownership_income_amount = 0
	, ri_simple_ownership_percent = 0
	, ri_simple_calculated_monthly_amount = 0
FROM history_octane.borrower_income
	JOIN history_octane.borrower ON borrower_income.bi_borrower_pid = borrower.b_pid
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE rental_income.ri_borrower_income_pid = borrower_income.bi_pid;


-- repository_file
UPDATE history_octane.repository_file
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, rf_client_filename = ''
	, rf_repository_filename = ''
	, rf_uploader_name = ''
	, rf_description = ''
FROM history_octane.deal_file
	JOIN history_octane.deal ON deal_file.df_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE repository_file.rf_pid = deal_file.df_repository_file_pid;


-- stripe_payment
UPDATE history_octane.stripe_payment
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, stpm_payer_unparsed_name = ''
	, stpm_receipt_email = ''
FROM history_octane.deal_invoice_payment_method
	JOIN history_octane.deal_invoice ON deal_invoice_payment_method.dipm_deal_invoice_pid = deal_invoice.di_pid
	JOIN history_octane.deal ON deal_invoice.di_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401318407
WHERE stripe_payment.stpm_pid = deal_invoice_payment_method.dipm_stripe_payment_pid;


-- tax_transcript_request
UPDATE history_octane.tax_transcript_request
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-11-1201696010784016'
	, ttr_requester_unparsed_name = ''
	, ttr_company_name = ''
	, ttr_company_city = ''
	, ttr_company_country = ''
	, ttr_company_postal_code = ''
	, ttr_company_state = ''
	, ttr_company_street1 = ''
	, ttr_company_street2 = ''
	, ttr_company_ein = ''
	, ttr_borrower1_first_name = ''
	, ttr_borrower1_middle_name = ''
	, ttr_borrower1_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, ttr_borrower1_name_suffix = ''
	, ttr_borrower1_birth_date = NULL
	, ttr_borrower1_current_city = ''
	, ttr_borrower1_current_country = ''
	, ttr_borrower1_current_postal_code = ''
	, ttr_borrower1_current_state = ''
	, ttr_borrower1_current_street1 = ''
	, ttr_borrower1_current_street2 = ''
	, ttr_borrower1_prior_city = ''
	, ttr_borrower1_prior_country = ''
	, ttr_borrower1_prior_postal_code = ''
	, ttr_borrower1_prior_state = ''
	, ttr_borrower1_prior_street1 = ''
	, ttr_borrower1_prior_street2 = ''
	, ttr_borrower1_monthly_income_amount = 0
	, ttr_borrower2_first_name = ''
	, ttr_borrower2_middle_name = ''
	, ttr_borrower2_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, ttr_borrower2_name_suffix = ''
	, ttr_borrower2_birth_date = NULL
	, ttr_borrower2_current_city = ''
	, ttr_borrower2_current_country = ''
	, ttr_borrower2_current_postal_code = ''
	, ttr_borrower2_current_state = ''
	, ttr_borrower2_current_street1 = ''
	, ttr_borrower2_current_street2 = ''
	, ttr_borrower2_prior_city = ''
	, ttr_borrower2_prior_country = ''
	, ttr_borrower2_prior_postal_code = ''
	, ttr_borrower2_prior_state = ''
	, ttr_borrower2_prior_street1 = ''
	, ttr_borrower2_prior_street2 = ''
	, ttr_borrower2_monthly_income_amount = 0
	, ttr_year1 = 0
	, ttr_year2 = 0
	, ttr_year3 = 0
	, ttr_year4 = 0
	, ttr_company_phone = ''
	, ttr_company_phone_extension = ''
FROM history_octane.deal
WHERE tax_transcript_request.ttr_deal_pid = deal.d_pid
	AND deal.d_los_loan_id_main = 1401318407;


/*
RTD 12: loan #1401487039
*/
-- application
UPDATE history_octane.application
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, apl_application_name = 'REDACTED_BORROWER_LAST_NAME'
FROM history_octane.proposal
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE application.apl_proposal_pid = proposal.prp_pid;


-- asset
UPDATE history_octane.asset
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, as_aggregate_description = ''
	, as_automobile_make_description = ''
	, as_automobile_model_year = 0
	, as_cash_or_market_value_amount = 0
	, as_description = ''
	, as_donor_city = ''
	, as_donor_country = ''
	, as_donor_postal_code = ''
	, as_donor_state = ''
	, as_donor_street1 = ''
	, as_donor_street2 = ''
	, as_gift_funds_donor_phone = ''
	, as_gift_funds_donor_relationship = ''
	, as_gift_funds_donor_unparsed_name = ''
	, as_gift_amount = 0
	, as_gift_funds_source_holder_name = ''
	, as_holder_name = ''
	, as_holder_city = ''
	, as_holder_country = ''
	, as_holder_postal_code = ''
	, as_holder_state = ''
	, as_holder_street1 = ''
	, as_holder_street2 = ''
	, as_life_insurance_face_value_amount = 0
	, as_liquid_amount = 0
	, as_liquid_percent = 0
	, as_stock_bond_mutual_fund_share_count = 0
	, as_available_amount = 0
	, as_down_payment_amount = 0
	, as_closing_costs_amount = 0
	, as_penalty_amount = 0
	, as_deposit_date = NULL
	, as_gift_funds_ein = ''
FROM history_octane.borrower_asset
	JOIN history_octane.borrower ON borrower_asset.bas_borrower_pid = borrower.b_pid
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE asset.as_pid = borrower_asset.bas_asset_pid;


-- borrower
UPDATE history_octane.borrower
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, b_alimony_child_support = 'UNKNOWN'
	, b_alimony_child_support_explanation = ''
	, b_bankruptcy = 'UNKNOWN'
	, b_bankruptcy_explanation = ''
	, b_birth_date = NULL
	, b_borrowed_down_payment = 'UNKNOWN'
	, b_borrowed_down_payment_explanation = ''
	, b_spousal_homestead = 'UNKNOWN'
	, b_has_no_ssn = FALSE
	, b_citizenship_residency_type = 'UNKNOWN'
	, b_credit_report_identifier = ''
	, b_has_dependents = 'UNKNOWN'
	, b_dependents_age_years = ''
	, b_email = ''
	, b_fax = ''
	, b_first_name = ''
	, b_nickname = ''
	, b_lender_employee = 'NO'
	, b_lender_employee_status_confirmed = FALSE
	, b_sex_collected_visual_or_surname = 'UNKNOWN'
	, b_sex_male = FALSE
	, b_sex_female = FALSE
	, b_ethnicity_collected_visual_or_surname = 'UNKNOWN'
	, b_ethnicity_hispanic_or_latino = FALSE
	, b_ethnicity_mexican = FALSE
	, b_ethnicity_puerto_rican = FALSE
	, b_ethnicity_cuban = FALSE
	, b_ethnicity_other_hispanic_or_latino = FALSE
	, b_ethnicity_not_hispanic_or_latino = FALSE
	, b_homeowner_past_three_years = 'UNKNOWN'
	, b_home_phone = ''
	, b_intend_to_occupy = 'UNKNOWN'
	, b_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, b_mailing_place_pid = 66955894
	, b_middle_name = ''
	, b_mobile_phone = ''
	, b_name_suffix = ''
	, b_note_endorser = 'UNKNOWN'
	, b_note_endorser_explanation = ''
	, b_obligated_loan_foreclosure = 'UNKNOWN'
	, b_obligated_loan_foreclosure_explanation = ''
	, b_office_phone = ''
	, b_office_phone_extension = ''
	, b_outstanding_judgements = 'UNKNOWN'
	, b_outstanding_judgments_explanation = ''
	, b_party_to_lawsuit = 'UNKNOWN'
	, b_party_to_lawsuit_explanation = ''
	, b_power_of_attorney = 'NO'
	, b_power_of_attorney_signing_capacity = ''
	, b_power_of_attorney_first_name = ''
	, b_power_of_attorney_last_name = ''
	, b_power_of_attorney_middle_name = ''
	, b_power_of_attorney_name_suffix = ''
	, b_power_of_attorney_company_name = ''
	, b_power_of_attorney_title = ''
	, b_power_of_attorney_office_phone = ''
	, b_power_of_attorney_office_phone_extension = ''
	, b_power_of_attorney_mobile_phone = ''
	, b_power_of_attorney_email = ''
	, b_power_of_attorney_fax = ''
	, b_power_of_attorney_city = ''
	, b_power_of_attorney_country = ''
	, b_power_of_attorney_postal_code = ''
	, b_power_of_attorney_state = ''
	, b_power_of_attorney_street1 = ''
	, b_power_of_attorney_street2 = ''
	, b_presently_delinquent = 'UNKNOWN'
	, b_presently_delinquent_explanation = ''
	, b_prior_property_title_type = 'SOLE'
	, b_prior_property_usage_type = 'PRIMARY_RESIDENCE'
	, b_property_foreclosure = 'UNKNOWN'
	, b_property_foreclosure_explanation = ''
	, b_race_collected_visual_or_surname = 'UNKNOWN'
	, b_race_american_indian_or_alaska_native = FALSE
	, b_race_asian = FALSE
	, b_race_asian_indian = FALSE
	, b_race_chinese = FALSE
	, b_race_filipino = FALSE
	, b_race_japanese = FALSE
	, b_race_korean = FALSE
	, b_race_vietnamese = FALSE
	, b_race_other_asian = FALSE
	, b_race_black_or_african_american = FALSE
	, b_race_native_hawaiian_or_other_pacific_islander = FALSE
	, b_race_native_hawaiian = FALSE
	, b_race_guamanian_or_chamorro = FALSE
	, b_race_samoan = FALSE
	, b_race_other_pacific_islander = FALSE
	, b_race_white = FALSE
	, b_schooling_years = 0
	, b_first_time_home_buyer_explain = ''
	, b_caivrs_id = ''
	, b_caivrs_messages = ''
	, b_on_ldp_list = 'UNKNOWN'
	, b_on_gsa_list = 'UNKNOWN'
	, b_monthly_job_federal_tax_amount = 0
	, b_monthly_job_state_tax_amount = 0
	, b_monthly_job_retirement_tax_amount = 0
	, b_monthly_job_medicare_tax_amount = 0
	, b_monthly_job_state_disability_insurance_amount = 0
	, b_monthly_job_other_tax_1_amount = 0
	, b_monthly_job_other_tax_1_description = ''
	, b_monthly_job_other_tax_2_amount = 0
	, b_monthly_job_other_tax_2_description = ''
	, b_monthly_job_other_tax_3_amount = 0
	, b_monthly_job_other_tax_3_description = ''
	, b_monthly_job_total_tax_amount = 0
	, b_homeownership_education_type = 'UNKNOWN'
	, b_homeownership_education_agency_type = 'UNKNOWN'
	, b_homeownership_education_complete_date = NULL
	, b_housing_counseling_type = 'UNKNOWN'
	, b_housing_counseling_agency_type = 'UNKNOWN'
	, b_housing_counseling_complete_date = NULL
	, b_legal_entity_type = 'NA'
	, b_disabled = 'UNKNOWN'
	, b_usda_annual_child_care_expenses = 0
	, b_usda_disability_expenses = 0
	, b_usda_medical_expenses = 0
	, b_usda_income_from_assets = 0
	, b_usda_moderate_income_limit = 0
	, b_hud_employee = FALSE
	, b_preferred_first_name = ''
FROM history_octane.application
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE borrower.b_application_pid = application.apl_pid;


-- borrower_alias
UPDATE history_octane.borrower_alias
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, ba_first_name = ''
	, ba_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, ba_middle_name = ''
	, ba_name_suffix = ''
	, ba_credit_report_identifier = ''
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE borrower_alias.ba_borrower_pid = borrower.b_pid;


-- borrower_associated_address
UPDATE history_octane.borrower_associated_address
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, baa_credit_report_identifier = ''
	, baa_reported_year = 0
	, baa_reported_address_street1 = ''
	, baa_reported_address_street2 = ''
	, baa_reported_address_city = ''
	, baa_reported_address_state = ''
	, baa_reported_address_postal_code = ''
	, baa_reported_address_country = ''
	, baa_current = 'UNKNOWN'
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE borrower_associated_address.baa_borrower_pid = borrower.b_pid;


-- borrower_declarations
UPDATE history_octane.borrower_declarations
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, bdec_fha_secondary_residence = 'UNKNOWN'
	, bdec_relationship_with_seller = 'UNKNOWN'
	, bdec_borrowed_funds_undisclosed = 'UNKNOWN'
	, bdec_borrowed_funds_undisclosed_amount = 0
	, bdec_other_mortgage_in_progress_before_closing = 'UNKNOWN'
	, bdec_applying_for_credit_before_closing = 'UNKNOWN'
	, bdec_priority_given_to_another_lien = 'UNKNOWN'
	, bdec_cosigner_undisclosed = 'UNKNOWN'
	, bdec_currently_delinquent_federal_debt = 'UNKNOWN'
	, bdec_party_to_lawsuit = 'UNKNOWN'
	, bdec_conveyed_title_in_lieu_of_foreclosure = 'UNKNOWN'
	, bdec_completed_pre_foreclosure_short_sale = 'UNKNOWN'
	, bdec_property_foreclosure = 'UNKNOWN'
	, bdec_bankruptcy_chapter_7 = 'UNKNOWN'
	, bdec_bankruptcy_chapter_11 = 'UNKNOWN'
	, bdec_bankruptcy_chapter_12 = 'UNKNOWN'
	, bdec_bankruptcy_chapter_13 = 'UNKNOWN'
	, bdec_intend_to_occupy_more_than_14_days = 'UNKNOWN'
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE borrower_declarations.bdec_borrower_pid = borrower.b_pid;


-- borrower_dependent
UPDATE history_octane.borrower_dependent
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, bd_first_name = ''
	, bd_last_name = ''
	, bd_age = 0
	, bd_disabled = 'UNKNOWN'
	, bd_full_time_student = 'UNKNOWN'
	, bd_receives_income = 'UNKNOWN'
	, bd_income_source = ''
	, bd_income_amount = 0
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE borrower_dependent.bd_borrower_pid = borrower.b_pid;


-- borrower_income
UPDATE history_octane.borrower_income
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, bi_job_gap_reason_type = 'NA'
	, bi_job_gap_reason_explanation = ''
	, bi_business_ownership_type = 'UNSPECIFIED'
	, bi_from_date = NULL
	, bi_through_date = NULL
	, bi_current = FALSE
	, bi_primary = FALSE
	, bi_source_name = ''
	, bi_source_address_street1 = ''
	, bi_source_address_street2 = ''
	, bi_source_address_city = ''
	, bi_source_address_state = ''
	, bi_source_address_postal_code = ''
	, bi_source_address_country = ''
	, bi_source_phone = ''
	, bi_source_phone_extension = ''
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE borrower_income.bi_borrower_pid = borrower.b_pid;


-- borrower_job_gap
UPDATE history_octane.borrower_job_gap
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, bjg_from_date = NULL
	, bjg_through_date = NULL
	, bjg_primary_job = FALSE
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE borrower_job_gap.bjg_borrower_pid = borrower.b_pid;


-- borrower_reo
UPDATE history_octane.borrower_reo
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, breo_place_pid = 66955894
	, breo_ownership_percent = 0
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE borrower_reo.breo_borrower_pid = borrower.b_pid;


-- borrower_residence
UPDATE history_octane.borrower_residence
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, bres_place_pid = 66955894
	, bres_current = FALSE
	, bres_borrower_residency_basis_type = 'RENT'
	, bres_from_date = NULL
	, bres_through_date = NULL
	, bres_verification_required = FALSE
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE borrower_residence.bres_borrower_pid = borrower.b_pid;


-- borrower_tax_filing
UPDATE history_octane.borrower_tax_filing
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
  	, btf_place_pid = 66955894
	, btf_tax_filing_status_type = 'UNSPECIFIED'
	, btf_year = 0
	, btf_joint_filer_first_name = ''
	, btf_joint_filer_middle_name = ''
	, btf_joint_filer_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, btf_joint_filer_suffix = ''
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE borrower_tax_filing.btf_borrower_pid = borrower.b_pid;


-- borrower_user
UPDATE history_octane.borrower_user
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, bu_email = ''
	, bu_first_name = ''
	, bu_middle_name = ''
	, bu_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, bu_name_suffix = ''
	, bu_unparsed_name = ''
	, bu_challenge_question_answer = NULL
	, bu_nickname = ''
	, bu_plain_text_email = FALSE
	, bu_preferred_first_name = ''
FROM history_octane.borrower_user_deal
	JOIN history_octane.deal ON borrower_user_deal.bud_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE borrower_user.bu_pid = borrower_user_deal.bud_borrower_user_pid;


-- business_income
UPDATE history_octane.business_income
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, bui_company_ein = ''
	, bui_estimated_net_income_amount = 0
	, bui_worksheet_monthly_total_amount = 0
	, bui_monthly_total_amount = 0
	, bui_borrower_income_percent = 0
	, bui_common_year1_year = 0
	, bui_common_year1_from_date = NULL
	, bui_common_year1_through_date = NULL
	, bui_common_year1_months = 0
	, bui_common_year1_annual_total_amount = 0
	, bui_common_year1_monthly_total_amount = 0
	, bui_common_year2_year = 0
	, bui_common_year2_from_date = NULL
	, bui_common_year2_through_date = NULL
	, bui_common_year2_months = 0
	, bui_common_year2_annual_total_amount = 0
	, bui_common_year2_monthly_total_amount = 0
	, bui_common_year3_year = 0
	, bui_common_year3_from_date = NULL
	, bui_common_year3_through_date = NULL
	, bui_common_year3_months = 0
	, bui_common_year3_annual_total_amount = 0
	, bui_common_year3_monthly_total_amount = 0
	, bui_sole_year1_gross_receipts = 0
	, bui_sole_year1_other_income_loss_exp = 0
	, bui_sole_year1_depletion = 0
	, bui_sole_year1_depreciation = 0
	, bui_sole_year1_meal_exclusions = 0
	, bui_sole_year1_business_use_home = 0
	, bui_sole_year1_amortization_loss = 0
	, bui_sole_year1_business_miles = 0
	, bui_sole_year1_depreciation_mile = 0
	, bui_sole_year1_mileage_depreciation = 0
	, bui_sole_year2_gross_receipts = 0
	, bui_sole_year2_other_income_loss_exp = 0
	, bui_sole_year2_depletion = 0
	, bui_sole_year2_depreciation = 0
	, bui_sole_year2_meal_exclusions = 0
	, bui_sole_year2_business_use_home = 0
	, bui_sole_year2_amortization_loss = 0
	, bui_sole_year2_business_miles = 0
	, bui_sole_year2_depreciation_mile = 0
	, bui_sole_year2_mileage_depreciation = 0
	, bui_sole_year3_gross_receipts = 0
	, bui_sole_year3_other_income_loss_exp = 0
	, bui_sole_year3_depletion = 0
	, bui_sole_year3_depreciation = 0
	, bui_sole_year3_meal_exclusions = 0
	, bui_sole_year3_business_use_home = 0
	, bui_sole_year3_amortization_loss = 0
	, bui_sole_year3_business_miles = 0
	, bui_sole_year3_depreciation_mile = 0
	, bui_sole_year3_mileage_depreciation = 0
	, bui_partner_year1_amortization_loss = 0
	, bui_partner_year1_depletion = 0
	, bui_partner_year1_depreciation = 0
	, bui_partner_year1_guaranteed_payments = 0
	, bui_partner_year1_meals_exclusion = 0
	, bui_partner_year1_net_rental_income_loss = 0
	, bui_partner_year1_notes_payable_less_year = 0
	, bui_partner_year1_ordinary_income_loss = 0
	, bui_partner_year1_other_income_loss = 0
	, bui_partner_year1_ownership_percent = 0
	, bui_partner_year1_form_k_1_total = 0
	, bui_partner_year1_form_1065_subtotal = 0
	, bui_partner_year1_form_1065_total = 0
	, bui_partner_year2_amortization_loss = 0
	, bui_partner_year2_depletion = 0
	, bui_partner_year2_depreciation = 0
	, bui_partner_year2_guaranteed_payments = 0
	, bui_partner_year2_meals_exclusion = 0
	, bui_partner_year2_net_rental_income_loss = 0
	, bui_partner_year2_notes_payable_less_year = 0
	, bui_partner_year2_ordinary_income_loss = 0
	, bui_partner_year2_other_income_loss = 0
	, bui_partner_year2_ownership_percent = 0
	, bui_partner_year2_form_k_1_total = 0
	, bui_partner_year2_form_1065_subtotal = 0
	, bui_partner_year2_form_1065_total = 0
	, bui_partner_year3_amortization_loss = 0
	, bui_partner_year3_depletion = 0
	, bui_partner_year3_depreciation = 0
	, bui_partner_year3_guaranteed_payments = 0
	, bui_partner_year3_meals_exclusion = 0
	, bui_partner_year3_net_rental_income_loss = 0
	, bui_partner_year3_notes_payable_less_year = 0
	, bui_partner_year3_ordinary_income_loss = 0
	, bui_partner_year3_other_income_loss = 0
	, bui_partner_year3_ownership_percent = 0
	, bui_partner_year3_form_k_1_total = 0
	, bui_partner_year3_form_1065_subtotal = 0
	, bui_partner_year3_form_1065_total = 0
	, bui_scorp_year1_ordinary_income_loss = 0
	, bui_scorp_year1_net_rental_income_loss = 0
	, bui_scorp_year1_other_income_loss = 0
	, bui_scorp_year1_depletion = 0
	, bui_scorp_year1_depreciation = 0
	, bui_scorp_year1_amortization_loss = 0
	, bui_scorp_year1_notes_payable_less_year = 0
	, bui_scorp_year1_meals_exclusion = 0
	, bui_scorp_year1_ownership_percent = 0
	, bui_scorp_year1_form_k_1_total = 0
	, bui_scorp_year1_form_1120s_subtotal = 0
	, bui_scorp_year1_form_1120s_total = 0
	, bui_scorp_year2_ordinary_income_loss = 0
	, bui_scorp_year2_net_rental_income_loss = 0
	, bui_scorp_year2_other_income_loss = 0
	, bui_scorp_year2_depletion = 0
	, bui_scorp_year2_depreciation = 0
	, bui_scorp_year2_amortization_loss = 0
	, bui_scorp_year2_notes_payable_less_year = 0
	, bui_scorp_year2_meals_exclusion = 0
	, bui_scorp_year2_ownership_percent = 0
	, bui_scorp_year2_form_k_1_total = 0
	, bui_scorp_year2_form_1120s_subtotal = 0
	, bui_scorp_year2_form_1120s_total = 0
	, bui_scorp_year3_ordinary_income_loss = 0
	, bui_scorp_year3_net_rental_income_loss = 0
	, bui_scorp_year3_other_income_loss = 0
	, bui_scorp_year3_depletion = 0
	, bui_scorp_year3_depreciation = 0
	, bui_scorp_year3_amortization_loss = 0
	, bui_scorp_year3_notes_payable_less_year = 0
	, bui_scorp_year3_meals_exclusion = 0
	, bui_scorp_year3_ownership_percent = 0
	, bui_scorp_year3_form_k_1_total = 0
	, bui_scorp_year3_form_1120s_subtotal = 0
	, bui_scorp_year3_form_1120s_total = 0
	, bui_corp_year1_taxable_income = 0
	, bui_corp_year1_total_tax = 0
	, bui_corp_year1_gain_loss = 0
	, bui_corp_year1_other_income_loss = 0
	, bui_corp_year1_depreciation = 0
	, bui_corp_year1_depletion = 0
	, bui_corp_year1_domestic_production_activities = 0
	, bui_corp_year1_other_deductions = 0
	, bui_corp_year1_net_operating_loss_special_deductions = 0
	, bui_corp_year1_notes_payable_less_one_year = 0
	, bui_corp_year1_meals_exclusion = 0
	, bui_corp_year1_dividends_paid_to_borrower = 0
	, bui_corp_year1_annual_subtotal = 0
	, bui_corp_year1_ownership_percent = 0
	, bui_corp_year1_annual_subtotal_ownership_applied = 0
	, bui_corp_year2_taxable_income = 0
	, bui_corp_year2_total_tax = 0
	, bui_corp_year2_gain_loss = 0
	, bui_corp_year2_other_income_loss = 0
	, bui_corp_year2_depreciation = 0
	, bui_corp_year2_depletion = 0
	, bui_corp_year2_domestic_production_activities = 0
	, bui_corp_year2_other_deductions = 0
	, bui_corp_year2_net_operating_loss_special_deductions = 0
	, bui_corp_year2_notes_payable_less_one_year = 0
	, bui_corp_year2_meals_exclusion = 0
	, bui_corp_year2_dividends_paid_to_borrower = 0
	, bui_corp_year2_annual_subtotal = 0
	, bui_corp_year2_ownership_percent = 0
	, bui_corp_year2_annual_subtotal_ownership_applied = 0
	, bui_corp_year3_taxable_income = 0
	, bui_corp_year3_total_tax = 0
	, bui_corp_year3_gain_loss = 0
	, bui_corp_year3_other_income_loss = 0
	, bui_corp_year3_depreciation = 0
	, bui_corp_year3_depletion = 0
	, bui_corp_year3_domestic_production_activities = 0
	, bui_corp_year3_other_deductions = 0
	, bui_corp_year3_net_operating_loss_special_deductions = 0
	, bui_corp_year3_notes_payable_less_one_year = 0
	, bui_corp_year3_meals_exclusion = 0
	, bui_corp_year3_dividends_paid_to_borrower = 0
	, bui_corp_year3_annual_subtotal = 0
	, bui_corp_year3_ownership_percent = 0
	, bui_corp_year3_annual_subtotal_ownership_applied = 0
	, bui_sch_f_year1_specific_income_loss = 0
	, bui_sch_f_year1_nonrecurring_income_loss = 0
	, bui_sch_f_year1_depreciation = 0
	, bui_sch_f_year1_amortization_loss_depletion = 0
	, bui_sch_f_year1_business_use_home = 0
	, bui_sch_f_year2_specific_income_loss = 0
	, bui_sch_f_year2_nonrecurring_income_loss = 0
	, bui_sch_f_year2_depreciation = 0
	, bui_sch_f_year2_amortization_loss_depletion = 0
	, bui_sch_f_year2_business_use_home = 0
	, bui_sch_f_year3_specific_income_loss = 0
	, bui_sch_f_year3_nonrecurring_income_loss = 0
	, bui_sch_f_year3_depreciation = 0
	, bui_sch_f_year3_amortization_loss_depletion = 0
	, bui_sch_f_year3_business_use_home = 0
	, bui_underwriter_comments = ''
FROM history_octane.borrower_income
	JOIN history_octane.borrower ON borrower_income.bi_borrower_pid = borrower.b_pid
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE business_income.bui_borrower_income_pid = borrower_income.bi_pid;


-- credit_inquiry
UPDATE history_octane.credit_inquiry
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, ci_inquiry_date = NULL
	, ci_name = ''
	, ci_address_street1 = ''
	, ci_address_street2 = ''
	, ci_address_city = ''
	, ci_address_state = ''
	, ci_address_postal_code = ''
	, ci_address_country = ''
	, ci_phone = ''
	, ci_credit_report_identifier = ''
FROM history_octane.borrower_credit_inquiry
	JOIN history_octane.borrower ON borrower_credit_inquiry.bci_borrower_pid = borrower.b_pid
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE credit_inquiry.ci_pid = borrower_credit_inquiry.bci_credit_inquiry_pid;


-- credit_request
UPDATE history_octane.credit_request
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, crdr_requester_unparsed_name = ''
	, crdr_borrower1_first_name = ''
	, crdr_borrower1_middle_name = ''
	, crdr_borrower1_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, crdr_borrower1_name_suffix = ''
	, crdr_borrower1_birth_date = NULL
	, crdr_borrower1_residence_city = ''
	, crdr_borrower1_residence_country = ''
	, crdr_borrower1_residence_postal_code = ''
	, crdr_borrower1_residence_state = ''
	, crdr_borrower1_residence_street1 = ''
	, crdr_borrower1_residence_street2 = ''
	, crdr_borrower1_experian_credit_score = 0
	, crdr_borrower1_equifax_credit_score = 0
	, crdr_borrower1_trans_union_credit_score = 0
	, crdr_borrower2_first_name = ''
	, crdr_borrower2_middle_name = ''
	, crdr_borrower2_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, crdr_borrower2_name_suffix = ''
	, crdr_borrower2_birth_date = NULL
	, crdr_borrower2_residence_city = ''
	, crdr_borrower2_residence_country = ''
	, crdr_borrower2_residence_postal_code = ''
	, crdr_borrower2_residence_state = ''
	, crdr_borrower2_residence_street1 = ''
	, crdr_borrower2_residence_street2 = ''
	, crdr_borrower2_experian_credit_score = 0
	, crdr_borrower2_equifax_credit_score = 0
	, crdr_borrower2_trans_union_credit_score = 0
	, crdr_credit_report_identifier = ''
FROM history_octane.deal
WHERE credit_request.crdr_deal_pid = deal.d_pid
	AND deal.d_los_loan_id_main = 1401487039;


-- credit_request_liability
UPDATE history_octane.credit_request_liability
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, crl_credit_report_identifier = ''
	, crl_report_holder_name = ''
	, crl_report_account_opened_date = NULL
	, crl_account_reported_date = NULL
	, crl_last_activity_date = NULL
	, crl_most_recent_adverse_rating_date = NULL
	, crl_report_monthly_payment_amount = 0
	, crl_report_remaining_term_months = 0
	, crl_months_reviewed_count = 0
	, crl_report_unpaid_balance_amount = 0
	, crl_report_credit_limit_amount = 0
	, crl_report_past_due_amount = 0
	, crl_report_terms_months_count = 0
	, crl_report_liability_current_rating_type = 'UNKNOWN'
	, crl_report_liability_account_status_type = 'UNKNOWN'
	, crl_report_liability_account_ownership_type = 'UNKNOWN'
	, crl_consumer_dispute = 'UNKNOWN'
	, crl_derogatory_data = 'UNKNOWN'
	, crl_late_30_days_count = ''
	, crl_late_60_days_count = ''
	, crl_late_90_days_count = ''
FROM history_octane.deal
WHERE credit_request_liability.crl_deal_pid = deal.d_pid
	AND deal.d_los_loan_id_main = 1401487039;


-- deal
UPDATE history_octane.deal
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, d_deal_status_type = 'CANCELLED'
	, d_hmda_action_date = CURRENT_DATE
	, d_hmda_action_type = 'WITHDRAWN'
WHERE deal.d_los_loan_id_main = 1401487039;


-- deal_invoice
UPDATE history_octane.deal_invoice
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, di_description = ''
	, di_internal_notes = ''
FROM history_octane.deal
WHERE deal_invoice.di_deal_pid = deal.d_pid
  AND deal.d_los_loan_id_main = 1401487039;


-- deal_invoice_payment_method
UPDATE history_octane.deal_invoice_payment_method
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, dipm_payer_unparsed_name = ''
FROM history_octane.deal_invoice
	JOIN history_octane.deal ON deal_invoice.di_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE deal_invoice_payment_method.dipm_deal_invoice_pid = deal_invoice.di_pid;


-- deal_signer
UPDATE history_octane.deal_signer
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, dsi_email = ''
	, dsi_first_name = ''
	, dsi_middle_name = ''
	, dsi_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, dsi_name_suffix = ''
	, dsi_signer_id = ''
FROM history_octane.deal
WHERE deal_signer.dsi_deal_pid = deal.d_pid
	AND deal.d_los_loan_id_main = 1401487039;


-- deal_tag
UPDATE history_octane.deal_tag
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, dtg_place_pid = 66955894
FROM history_octane.deal
WHERE deal_tag.dtg_deal_pid = deal.d_pid
	AND deal.d_los_loan_id_main = 1401487039;


-- du_request
UPDATE history_octane.du_request
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, dur_requester_unparsed_name = ''
	, dur_mp_status_log = ''
	, dur_loan_amount = 0
	, dur_initial_pi_amount = 0
	, dur_note_rate_percent = 0
	, dur_initial_note_rate_percent = 0
	, dur_ltv_ratio_percent = 0
	, dur_cltv_ratio_percent = 0
	, dur_housing_ratio_percent = 0
	, dur_debt_ratio_percent = 0
	, dur_du_ltv_ratio_percent = 0
	, dur_du_cltv_ratio_percent = 0
	, dur_du_housing_ratio_percent = 0
	, dur_du_debt_ratio_percent = 0
	, dur_cash_from_borrower_amount = 0
	, dur_aus_cash_from_borrower_amount = 0
FROM history_octane.proposal
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE du_request.dur_proposal_pid = proposal.prp_pid;


-- job_income
UPDATE history_octane.job_income
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, ji_line_of_work_years = 0
	, ji_monthly_base_unadjusted_amount = 0
	, ji_monthly_base_adjustment_amount = 0
	, ji_monthly_overtime_unadjusted_amount = 0
	, ji_monthly_overtime_adjustment_amount = 0
	, ji_monthly_bonus_unadjusted_amount = 0
	, ji_monthly_bonus_adjustment_amount = 0
	, ji_monthly_commissions_unadjusted_amount = 0
	, ji_monthly_commissions_adjustment_amount = 0
	, ji_monthly_tip_unadjusted_amount = 0
	, ji_monthly_tip_adjustment_amount = 0
	, ji_monthly_adjustment_amount = 0
	, ji_employer_relative = FALSE
	, ji_employer_property_seller = FALSE
	, ji_employer_real_estate_broker = FALSE
	, ji_military_job = FALSE
	, ji_estimated_monthly_military_amount = 0
	, ji_monthly_military_base_pay_amount = 0
	, ji_monthly_military_clothes_allowance_ungrossed_amount = 0
	, ji_monthly_military_combat_pay_amount = 0
	, ji_monthly_military_flight_pay_amount = 0
	, ji_monthly_military_hazard_pay_amount = 0
	, ji_monthly_military_housing_allowance_ungrossed_amount = 0
	, ji_monthly_military_overseas_pay_amount = 0
	, ji_monthly_military_prop_pay_amount = 0
	, ji_monthly_military_quarters_allowance_ungrossed_amount = 0
	, ji_monthly_military_rations_allowance_ungrossed_amount = 0
	, ji_military_gross_up_percent = 0
	, ji_monthly_military_clothes_allowance_amount = 0
	, ji_monthly_military_quarters_allowance_amount = 0
	, ji_monthly_military_rations_allowance_amount = 0
	, ji_monthly_military_housing_allowance_amount = 0
	, ji_military_pay_subtotal_amount = 0
	, ji_military_allowance_subtotal_amount = 0
	, ji_monthly_military_total_amount = 0
	, ji_annual_military_total_amount = 0
	, ji_job_year1_year = 0
	, ji_job_year1_from_date = NULL
	, ji_job_year1_through_date = NULL
	, ji_job_year1_months = 0
	, ji_job_year1_base_input_amount = 0
	, ji_job_year1_monthly_base_amount = 0
	, ji_job_year1_overtime_input_amount = 0
	, ji_job_year1_monthly_overtime_amount = 0
	, ji_job_year1_bonus_input_amount = 0
	, ji_job_year1_monthly_bonus_amount = 0
	, ji_job_year1_commissions_input_amount = 0
	, ji_job_year1_monthly_commissions_amount = 0
	, ji_job_year1_tip_input_amount = 0
	, ji_job_year1_monthly_tip_amount = 0
	, ji_job_year1_adjustment_input_amount = 0
	, ji_job_year1_monthly_adjustment_amount = 0
	, ji_job_year1_monthly_total_amount = 0
	, ji_job_year1_annual_total_amount = 0
	, ji_job_year1_monthly_total_commissions_percent = 0
	, ji_job_year2_year = 0
	, ji_job_year2_from_date = NULL
	, ji_job_year2_through_date = NULL
	, ji_job_year2_months = 0
	, ji_job_year2_base_input_amount = 0
	, ji_job_year2_monthly_base_amount = 0
	, ji_job_year2_overtime_input_amount = 0
	, ji_job_year2_monthly_overtime_amount = 0
	, ji_job_year2_bonus_input_amount = 0
	, ji_job_year2_monthly_bonus_amount = 0
	, ji_job_year2_commissions_input_amount = 0
	, ji_job_year2_monthly_commissions_amount = 0
	, ji_job_year2_tip_input_amount = 0
	, ji_job_year2_monthly_tip_amount = 0
	, ji_job_year2_adjustment_input_amount = 0
	, ji_job_year2_monthly_adjustment_amount = 0
	, ji_job_year2_monthly_total_amount = 0
	, ji_job_year2_annual_total_amount = 0
	, ji_job_year2_monthly_total_commissions_percent = 0
	, ji_job_year3_year = 0
	, ji_job_year3_from_date = NULL
	, ji_job_year3_through_date = NULL
	, ji_job_year3_months = 0
	, ji_job_year3_base_input_amount = 0
	, ji_job_year3_monthly_base_amount = 0
	, ji_job_year3_overtime_input_amount = 0
	, ji_job_year3_monthly_overtime_amount = 0
	, ji_job_year3_bonus_input_amount = 0
	, ji_job_year3_monthly_bonus_amount = 0
	, ji_job_year3_commissions_input_amount = 0
	, ji_job_year3_monthly_commissions_amount = 0
	, ji_job_year3_tip_input_amount = 0
	, ji_job_year3_monthly_tip_amount = 0
	, ji_job_year3_adjustment_input_amount = 0
	, ji_job_year3_monthly_adjustment_amount = 0
	, ji_job_year3_monthly_total_amount = 0
	, ji_job_year3_annual_total_amount = 0
	, ji_job_year3_monthly_total_commissions_percent = 0
	, ji_estimated_monthly_base_amount = 0
	, ji_estimated_monthly_bonus_amount = 0
	, ji_estimated_monthly_overtime_amount = 0
	, ji_estimated_monthly_commissions_amount = 0
	, ji_estimated_monthly_tip_amount = 0
	, ji_estimated_monthly_total_amount = 0
	, ji_estimated_annual_total_amount = 0
	, ji_estimated_monthly_total_commissions_percent = 0
	, ji_worksheet_monthly_base_amount = 0
	, ji_worksheet_monthly_bonus_amount = 0
	, ji_worksheet_monthly_overtime_amount = 0
	, ji_worksheet_monthly_commissions_amount = 0
	, ji_worksheet_monthly_tip_amount = 0
	, ji_worksheet_monthly_total_amount = 0
	, ji_worksheet_annual_total_amount = 0
	, ji_worksheet_monthly_total_commissions_percent = 0
	, ji_working_monthly_base_amount = 0
	, ji_working_monthly_bonus_amount = 0
	, ji_working_monthly_overtime_amount = 0
	, ji_working_monthly_commissions_amount = 0
	, ji_working_monthly_tip_amount = 0
	, ji_working_monthly_total_amount = 0
	, ji_working_annual_total_amount = 0
	, ji_working_monthly_total_commissions_percent = 0
	, ji_underwriter_comments = ''
	, ji_voe_third_party_verifier_order_id = ''
	, ji_employer_voe_name = ''
	, ji_employer_voe_title = ''
	, ji_employer_voe_phone = ''
	, ji_employer_voe_phone_extension = ''
	, ji_employer_voe_fax = ''
	, ji_employer_voe_email = ''
	, ji_employer_other_interested_party_description = ''
	, ji_line_of_work_months = 0
FROM history_octane.borrower_income
	JOIN history_octane.borrower ON borrower_income.bi_borrower_pid = borrower.b_pid
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE job_income.ji_borrower_income_pid = borrower_income.bi_pid;


-- liability
UPDATE history_octane.liability
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, lia_aggregate_description = ''
	, lia_description = ''
	, lia_city = ''
	, lia_country = ''
	, lia_postal_code = ''
	, lia_state = ''
	, lia_street1 = ''
	, lia_street2 = ''
	, lia_holder_name = ''
	, lia_holder_phone = ''
	, lia_holder_phone_extension = ''
	, lia_holder_fax = ''
	, lia_holder_email = ''
	, lia_account_opened_date = NULL
	, lia_monthly_payment_amount = 0
	, lia_remaining_term_months = 0
	, lia_high_balance_amount = 0
	, lia_credit_limit_amount = 0
	, lia_past_due_amount = 0
	, lia_unpaid_balance_amount = 0
	, lia_note = ''
	, lia_terms_months_count = 0
	, lia_payoff_amount = 0
FROM history_octane.borrower_liability
	JOIN history_octane.borrower ON borrower_liability.bl_borrower_pid = borrower.b_pid
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE liability.lia_pid = borrower_liability.bl_liability_pid;


-- loan_hedge
UPDATE history_octane.loan_hedge
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, lh_effective_credit_score = 0
	, lh_debt_to_income = 0
	, lh_note_date = NULL
	, lh_borrower_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, lh_borrower_first_name = ''
	, lh_co_borrower_first_name = ''
	, lh_co_borrower_last_name = ''
	, lh_total_borrower_income = 0
	, lh_borrower_decision_credit_score = 0
	, lh_co_borrower_decision_credit_score = 0
	, lh_b2_first_name = ''
	, lh_b2_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, lh_c2_first_name = ''
	, lh_c2_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, lh_b3_first_name = ''
	, lh_b3_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, lh_c3_first_name = ''
	, lh_c3_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, lh_b4_first_name = ''
	, lh_b4_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, lh_c4_first_name = ''
	, lh_c4_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, lh_b5_first_name = ''
	, lh_b5_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, lh_c5_first_name = ''
	, lh_c5_last_name = 'REDACTED_BORROWER_LAST_NAME'
FROM history_octane.loan
	JOIN history_octane.proposal ON loan.l_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE loan_hedge.lh_loan_pid = loan.l_pid;


-- lp_request
UPDATE history_octane.lp_request
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, lpr_requester_unparsed_name = ''
	, lpr_loan_amount = 0
	, lpr_initial_pi_amount = 0
	, lpr_note_rate_percent = 0
	, lpr_initial_note_rate_percent = 0
	, lpr_ltv_ratio_percent = 0
	, lpr_cltv_ratio_percent = 0
	, lpr_hcltv_ratio_percent = 0
	, lpr_housing_ratio_percent = 0
	, lpr_debt_ratio_percent = 0
	, lpr_lp_ltv_ratio_percent = 0
	, lpr_lp_total_ltv_ratio_percent = 0
	, lpr_lp_high_total_ltv_ratio_percent = 0
	, lpr_lp_housing_ratio_percent = 0
	, lpr_lp_debt_ratio_percent = 0
	, lpr_lp_total_funds_to_be_verified_amount = 0
	, lpr_lp_required_borrower_funds_amount = 0
	, lpr_lp_paid_off_debt_amount = 0
	, lpr_lp_required_reserves_amount = 0
	, lpr_lp_total_eligible_assets_amount = 0
	, lpr_lp_proceeds_from_subordinate_financing_amount = 0
	, lpr_lp_calculated_reserves_amount = 0
	, lpr_aus_request_number = 0
	, lpr_cash_from_borrower_amount = 0
	, lpr_aus_cash_from_borrower_amount = 0
FROM history_octane.proposal
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE lp_request.lpr_proposal_pid = proposal.prp_pid;


-- military_service
UPDATE history_octane.military_service
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, ms_from_date = NULL
	, ms_through_date = NULL
	, ms_name_used_during_service = ''
	, ms_service_number = ''
FROM history_octane.borrower
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE military_service.ms_borrower_pid = borrower.b_pid;


-- other_income
UPDATE history_octane.other_income
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, oi_estimated_net_income_amount = 0
	, oi_worksheet_monthly_total_amount = 0
	, oi_monthly_total_amount = 0
	, oi_borrower_income_percent = 0
	, oi_description = ''
	, oi_common_year1_year = 0
	, oi_common_year1_from_date = NULL
	, oi_common_year1_through_date = NULL
	, oi_common_year1_months = 0
	, oi_common_year1_annual_total_amount = 0
	, oi_common_year1_monthly_total_amount = 0
	, oi_common_year2_year = 0
	, oi_common_year2_from_date = NULL
	, oi_common_year2_through_date = NULL
	, oi_common_year2_months = 0
	, oi_common_year2_annual_total_amount = 0
	, oi_common_year2_monthly_total_amount = 0
	, oi_common_year3_year = 0
	, oi_common_year3_from_date = NULL
	, oi_common_year3_through_date = NULL
	, oi_common_year3_months = 0
	, oi_common_year3_annual_total_amount = 0
	, oi_common_year3_monthly_total_amount = 0
	, oi_simple_year1_unadjusted_amount = 0
	, oi_simple_year1_tax_exempt_tax_rate_percent = 0
	, oi_simple_year1_tax_exempt_amount = 0
	, oi_simple_year2_unadjusted_amount = 0
	, oi_simple_year2_tax_exempt_tax_rate_percent = 0
	, oi_simple_year2_tax_exempt_amount = 0
	, oi_simple_year3_unadjusted_amount = 0
	, oi_simple_year3_tax_exempt_tax_rate_percent = 0
	, oi_simple_year3_tax_exempt_amount = 0
	, oi_simple_unadjusted_monthly_amount = 0
	, oi_simple_tax_exempt_tax_rate_percent = 0
	, oi_simple_tax_exempt_amount = 0
	, oi_simple_calculated_monthly_amount = 0
	, oi_underwriter_comments = ''
	, oi_mcc_reservation_number = ''
	, oi_mcc_reservation_date = NULL
	, oi_mcc_reservation_expiration_date = NULL
	, oi_mcc_commitment_number = ''
	, oi_mcc_underwriting_certification_deadline_date = NULL
	, oi_mcc_delivered_by_date = NULL
	, oi_unadjusted_monthly_total_amount = 0
	, oi_simple_year1_unadjusted_monthly_amount = 0
	, oi_simple_year2_unadjusted_monthly_amount = 0
	, oi_simple_year3_unadjusted_monthly_amount = 0
FROM history_octane.borrower_income
	JOIN history_octane.borrower ON borrower_income.bi_borrower_pid = borrower.b_pid
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE other_income.oi_borrower_income_pid = borrower_income.bi_pid;


-- proposal
UPDATE history_octane.proposal
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, prp_smart_docs_enabled = FALSE
	, prp_note_date = NULL
	, prp_intent_to_proceed_provider_unparsed_name = ''
	, prp_intent_to_proceed_obtainer_unparsed_name = ''
FROM history_octane.deal
WHERE proposal.prp_deal_pid = deal.d_pid
	AND deal.d_los_loan_id_main = 1401487039;


-- proposal_doc
UPDATE history_octane.proposal_doc
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, prpd_deal_child_name = ''
	, prpd_reo_place_pid = 66955894
	, prpd_property_place_pid = 66955894
	, prpd_residence_place_pid = 66955894
	, prpd_status_unparsed_name = ''
	, prpd_doc_excluded_unparsed_name = ''
	, prpd_prior_to_type_unparsed_name = ''
	, prpd_provider_type_unparsed_name = ''
FROM history_octane.proposal
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE proposal_doc.prpd_proposal_pid = proposal.prp_pid;


-- proposal_doc_set
UPDATE history_octane.proposal_doc_set
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, prpds_creator_unparsed_name = ''
	, prpds_requester_unparsed_name = ''
	, prpds_canceler_unparsed_name = ''
FROM history_octane.proposal
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE proposal_doc_set.prpds_proposal_pid = proposal.prp_pid;


-- proposal_req
UPDATE history_octane.proposal_req
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, prpr_fulfill_status_unparsed_name = ''
	, prpr_decision_status_unparsed_name = ''
	, prpr_reo_place_pid = 66955894
	, prpr_property_place_pid = 66955894
	, prpr_residence_place_pid = 66955894
	, prpr_deal_child_name = ''
FROM history_octane.proposal
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE proposal_req.prpr_proposal_pid = proposal.prp_pid;


-- proposal_review
UPDATE history_octane.proposal_review
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, prpre_request_summary = ''
	, prpre_decision_summary = ''
FROM history_octane.proposal
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE proposal_review.prpre_proposal_pid = proposal.prp_pid;


-- proposal_summary
UPDATE history_octane.proposal_summary
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, ps_b1_first_name = ''
	, ps_c1_first_name = ''
	, ps_b2_first_name = ''
	, ps_b1_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, ps_c1_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, ps_b2_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, ps_b1_middle_name = ''
	, ps_c1_middle_name = ''
	, ps_b2_middle_name = ''
	, ps_b1_preferred_first_name = ''
	, ps_b2_preferred_first_name = ''
	, ps_c1_preferred_first_name = ''
	, ps_b1_birth_date = NULL
	, ps_c1_birth_date = NULL
	, ps_b1_monthly_income = 0
	, ps_c1_monthly_income = 0
	, ps_b2_monthly_income = 0
	, ps_b1_has_business_income = FALSE
	, ps_c1_has_business_income = FALSE
	, ps_b2_has_business_income = FALSE
	, ps_b1_citizenship_residency_type = 'UNKNOWN'
	, ps_c1_citizenship_residency_type = 'UNKNOWN'
	, ps_b2_citizenship_residency_type = 'UNKNOWN'
	, ps_b1_hmda_ethnicity_2017_type = 'NOT_OBTAINABLE'
	, ps_c1_hmda_ethnicity_2017_type = 'NOT_OBTAINABLE'
	, ps_b2_hmda_ethnicity_2017_type = 'NOT_OBTAINABLE'
	, ps_b1_decision_credit_score = 0
	, ps_c1_decision_credit_score = 0
	, ps_b2_decision_credit_score = 0
	, ps_b1_gender_type = 'NOT_OBTAINABLE'
	, ps_c1_gender_type = 'NOT_OBTAINABLE'
	, ps_b2_gender_type = 'NOT_OBTAINABLE'
	, ps_b1_hmda_race_2017_type = 'NA'
	, ps_c1_hmda_race_2017_type = 'NA'
	, ps_b2_hmda_race_2017_type = 'NA'
	, ps_any_lender_employee_borrower = FALSE
	, ps_primary_application_name = 'REDACTED_BORROWER_LAST_NAME'
FROM history_octane.proposal
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE proposal_summary.ps_proposal_pid = proposal.prp_pid;

-- public_record
UPDATE history_octane.public_record
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, pr_disposition_date = NULL
	, pr_filed_date = NULL
	, pr_reported_date = NULL
	, pr_settled_date = NULL
	, pr_paid_date = NULL
	, pr_docket_id = ''
	, pr_bankruptcy_assets_amount = 0
	, pr_bankruptcy_exempt_amount = 0
	, pr_bankruptcy_liabilities_amount = 0
	, pr_legal_obligation_amount = 0
	, pr_court_name = ''
	, pr_plaintiff_name = ''
	, pr_defendant_name = ''
	, pr_attorney_name = ''
	, pr_comment = ''
	, pr_note = ''
	, pr_credit_report_identifier = ''
FROM history_octane.borrower_public_record
	JOIN history_octane.borrower ON borrower_public_record.bpr_borrower_pid = borrower.b_pid
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE public_record.pr_pid = borrower_public_record.bpr_public_record_pid;


-- rental_income
UPDATE history_octane.rental_income
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, ri_place_pid = 66955894
	, ri_rental_income_estimated_gross_monthly_amount = 0
	, ri_simple_monthly_total_amount = 0
	, ri_schedule_e_calculated_gross_monthly_amount = 0
	, ri_schedule_e_proposed_monthly_expense_amount = 0
	, ri_schedule_e_net_monthly_amount = 0
	, ri_rental_income_monthly_total_amount = 0
	, ri_schedule_e_non_recurring_expense_1 = ''
	, ri_schedule_e_non_recurring_expense_2 = ''
	, ri_schedule_e_non_recurring_expense_3 = ''
	, ri_common_year1_year = 0
	, ri_common_year1_from_date = NULL
	, ri_common_year1_through_date = NULL
	, ri_common_year1_months = 0
	, ri_common_year1_annual_total_amount = 0
	, ri_common_year1_monthly_total_amount = 0
	, ri_common_year2_year = 0
	, ri_common_year2_from_date = NULL
	, ri_common_year2_through_date = NULL
	, ri_common_year2_months = 0
	, ri_common_year2_annual_total_amount = 0
	, ri_common_year2_monthly_total_amount = 0
	, ri_common_year3_year = 0
	, ri_common_year3_from_date = NULL
	, ri_common_year3_through_date = NULL
	, ri_common_year3_months = 0
	, ri_common_year3_annual_total_amount = 0
	, ri_common_year3_monthly_total_amount = 0
	, ri_schedule_e_year1_rent_received_amount = 0
	, ri_schedule_e_year1_advertising_expense_amount = 0
	, ri_schedule_e_year1_auto_travel_expense_amount = 0
	, ri_schedule_e_year1_cleaning_maintenance_expense_amount = 0
	, ri_schedule_e_year1_commissions_expense_amount = 0
	, ri_schedule_e_year1_insurance_expense_amount = 0
	, ri_schedule_e_year1_legal_professional_expense_amount = 0
	, ri_schedule_e_year1_management_expense_amount = 0
	, ri_schedule_e_year1_mortgage_interest_expense_amount = 0
	, ri_schedule_e_year1_other_interest_expense_amount = 0
	, ri_schedule_e_year1_repairs_expense_amount = 0
	, ri_schedule_e_year1_supplies_expense_amount = 0
	, ri_schedule_e_year1_taxes_expense_amount = 0
	, ri_schedule_e_year1_utilities_expense_amount = 0
	, ri_schedule_e_year1_depreciation_expense_amount = 0
	, ri_schedule_e_year1_other_expense_amount = 0
	, ri_schedule_e_year1_total_expense_amount = 0
	, ri_schedule_e_year1_non_recurring_expense_amount_1 = 0
	, ri_schedule_e_year1_non_recurring_expense_amount_2 = 0
	, ri_schedule_e_year1_non_recurring_expense_amount_3 = 0
	, ri_schedule_e_year1_insurance_credit_amount = 0
	, ri_schedule_e_year1_taxes_credit_amount = 0
	, ri_schedule_e_year1_annual_subtotal = 0
	, ri_schedule_e_year1_ownership_percent = 0
	, ri_schedule_e_year2_rent_received_amount = 0
	, ri_schedule_e_year2_advertising_expense_amount = 0
	, ri_schedule_e_year2_auto_travel_expense_amount = 0
	, ri_schedule_e_year2_cleaning_maintenance_expense_amount = 0
	, ri_schedule_e_year2_commissions_expense_amount = 0
	, ri_schedule_e_year2_insurance_expense_amount = 0
	, ri_schedule_e_year2_legal_professional_expense_amount = 0
	, ri_schedule_e_year2_management_expense_amount = 0
	, ri_schedule_e_year2_mortgage_interest_expense_amount = 0
	, ri_schedule_e_year2_other_interest_expense_amount = 0
	, ri_schedule_e_year2_repairs_expense_amount = 0
	, ri_schedule_e_year2_supplies_expense_amount = 0
	, ri_schedule_e_year2_taxes_expense_amount = 0
	, ri_schedule_e_year2_utilities_expense_amount = 0
	, ri_schedule_e_year2_depreciation_expense_amount = 0
	, ri_schedule_e_year2_other_expense_amount = 0
	, ri_schedule_e_year2_total_expense_amount = 0
	, ri_schedule_e_year2_non_recurring_expense_amount_1 = 0
	, ri_schedule_e_year2_non_recurring_expense_amount_2 = 0
	, ri_schedule_e_year2_non_recurring_expense_amount_3 = 0
	, ri_schedule_e_year2_insurance_credit_amount = 0
	, ri_schedule_e_year2_taxes_credit_amount = 0
	, ri_schedule_e_year2_annual_subtotal = 0
	, ri_schedule_e_year2_ownership_percent = 0
	, ri_schedule_e_year3_rent_received_amount = 0
	, ri_schedule_e_year3_advertising_expense_amount = 0
	, ri_schedule_e_year3_auto_travel_expense_amount = 0
	, ri_schedule_e_year3_cleaning_maintenance_expense_amount = 0
	, ri_schedule_e_year3_commissions_expense_amount = 0
	, ri_schedule_e_year3_insurance_expense_amount = 0
	, ri_schedule_e_year3_legal_professional_expense_amount = 0
	, ri_schedule_e_year3_management_expense_amount = 0
	, ri_schedule_e_year3_mortgage_interest_expense_amount = 0
	, ri_schedule_e_year3_other_interest_expense_amount = 0
	, ri_schedule_e_year3_repairs_expense_amount = 0
	, ri_schedule_e_year3_supplies_expense_amount = 0
	, ri_schedule_e_year3_taxes_expense_amount = 0
	, ri_schedule_e_year3_utilities_expense_amount = 0
	, ri_schedule_e_year3_depreciation_expense_amount = 0
	, ri_schedule_e_year3_other_expense_amount = 0
	, ri_schedule_e_year3_total_expense_amount = 0
	, ri_schedule_e_year3_non_recurring_expense_amount_1 = 0
	, ri_schedule_e_year3_non_recurring_expense_amount_2 = 0
	, ri_schedule_e_year3_non_recurring_expense_amount_3 = 0
	, ri_schedule_e_year3_insurance_credit_amount = 0
	, ri_schedule_e_year3_taxes_credit_amount = 0
	, ri_schedule_e_year3_annual_subtotal = 0
	, ri_schedule_e_year3_ownership_percent = 0
	, ri_simple_monthly_rent_amount = 0
	, ri_simple_vacancy_maintenance_adjustment_percent = 0
	, ri_simple_monthly_net_rent_amount = 0
	, ri_simple_monthly_expense_amount = 0
	, ri_simple_monthly_pre_ownership_income_amount = 0
	, ri_simple_ownership_percent = 0
	, ri_simple_calculated_monthly_amount = 0
FROM history_octane.borrower_income
	JOIN history_octane.borrower ON borrower_income.bi_borrower_pid = borrower.b_pid
	JOIN history_octane.application ON borrower.b_application_pid = application.apl_pid
	JOIN history_octane.proposal ON application.apl_proposal_pid = proposal.prp_pid
	JOIN history_octane.deal ON proposal.prp_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE rental_income.ri_borrower_income_pid = borrower_income.bi_pid;


-- repository_file
UPDATE history_octane.repository_file
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, rf_client_filename = ''
	, rf_repository_filename = ''
	, rf_uploader_name = ''
	, rf_description = ''
FROM history_octane.deal_file
	JOIN history_octane.deal ON deal_file.df_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE repository_file.rf_pid = deal_file.df_repository_file_pid;


-- stripe_payment
UPDATE history_octane.stripe_payment
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, stpm_payer_unparsed_name = ''
	, stpm_receipt_email = ''
FROM history_octane.deal_invoice_payment_method
	JOIN history_octane.deal_invoice ON deal_invoice_payment_method.dipm_deal_invoice_pid = deal_invoice.di_pid
	JOIN history_octane.deal ON deal_invoice.di_deal_pid = deal.d_pid
		AND deal.d_los_loan_id_main = 1401487039
WHERE stripe_payment.stpm_pid = deal_invoice_payment_method.dipm_stripe_payment_pid;


-- tax_transcript_request
UPDATE history_octane.tax_transcript_request
SET data_source_updated_datetime = NOW()
	, etl_batch_id = 'ccpa-rtd-12-1201689552095074'
	, ttr_requester_unparsed_name = ''
	, ttr_company_name = ''
	, ttr_company_city = ''
	, ttr_company_country = ''
	, ttr_company_postal_code = ''
	, ttr_company_state = ''
	, ttr_company_street1 = ''
	, ttr_company_street2 = ''
	, ttr_company_ein = ''
	, ttr_borrower1_first_name = ''
	, ttr_borrower1_middle_name = ''
	, ttr_borrower1_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, ttr_borrower1_name_suffix = ''
	, ttr_borrower1_birth_date = NULL
	, ttr_borrower1_current_city = ''
	, ttr_borrower1_current_country = ''
	, ttr_borrower1_current_postal_code = ''
	, ttr_borrower1_current_state = ''
	, ttr_borrower1_current_street1 = ''
	, ttr_borrower1_current_street2 = ''
	, ttr_borrower1_prior_city = ''
	, ttr_borrower1_prior_country = ''
	, ttr_borrower1_prior_postal_code = ''
	, ttr_borrower1_prior_state = ''
	, ttr_borrower1_prior_street1 = ''
	, ttr_borrower1_prior_street2 = ''
	, ttr_borrower1_monthly_income_amount = 0
	, ttr_borrower2_first_name = ''
	, ttr_borrower2_middle_name = ''
	, ttr_borrower2_last_name = 'REDACTED_BORROWER_LAST_NAME'
	, ttr_borrower2_name_suffix = ''
	, ttr_borrower2_birth_date = NULL
	, ttr_borrower2_current_city = ''
	, ttr_borrower2_current_country = ''
	, ttr_borrower2_current_postal_code = ''
	, ttr_borrower2_current_state = ''
	, ttr_borrower2_current_street1 = ''
	, ttr_borrower2_current_street2 = ''
	, ttr_borrower2_prior_city = ''
	, ttr_borrower2_prior_country = ''
	, ttr_borrower2_prior_postal_code = ''
	, ttr_borrower2_prior_state = ''
	, ttr_borrower2_prior_street1 = ''
	, ttr_borrower2_prior_street2 = ''
	, ttr_borrower2_monthly_income_amount = 0
	, ttr_year1 = 0
	, ttr_year2 = 0
	, ttr_year3 = 0
	, ttr_year4 = 0
	, ttr_company_phone = ''
	, ttr_company_phone_extension = ''
FROM history_octane.deal
WHERE tax_transcript_request.ttr_deal_pid = deal.d_pid
	AND deal.d_los_loan_id_main = 1401487039;