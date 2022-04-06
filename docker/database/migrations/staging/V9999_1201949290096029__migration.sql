--
-- EDW | Integrate fields from the 'deal' and 'proposal' tables in Octane to the star_loan schema
-- https://app.asana.com/0/0/1201949290096029
--

CREATE TABLE star_loan.cash_out_reason_dim (
	dwid BIGSERIAL NOT NULL
		CONSTRAINT pk_cash_out_reason_dim
			PRIMARY KEY
	, data_source_dwid BIGINT NOT NULL
	, edw_created_datetime TIMESTAMPTZ
	, edw_modified_datetime TIMESTAMPTZ
	, etl_batch_id TEXT
	, data_source_integration_columns TEXT
	, data_source_integration_id TEXT NOT NULL
	, data_source_modified_datetime TIMESTAMPTZ
	, cash_out_reason_business_debt_or_debt_consolidation_flag BOOLEAN
	, cash_out_reason_debt_or_other_consolidation_flag BOOLEAN
	, cash_out_reason_future_investment_not_under_contract_flag BOOLEAN
	, cash_out_reason_future_investment_under_contract_flag BOOLEAN
	, cash_out_reason_home_improvement_flag BOOLEAN
	, cash_out_reason_investment_or_business_property_flag BOOLEAN
	, cash_out_reason_other_flag BOOLEAN
	, cash_out_reason_personal_use_flag BOOLEAN
	, cash_out_reason_student_loans_flag BOOLEAN
	, non_business_cash_out_reason_acknowledged VARCHAR(1024)
	, non_business_cash_out_reason_acknowledged_code VARCHAR(128)
);

INSERT
INTO star_loan.cash_out_reason_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id
								   , data_source_integration_columns, data_source_integration_id
								   , data_source_modified_datetime
								   , cash_out_reason_business_debt_or_debt_consolidation_flag
								   , cash_out_reason_debt_or_other_consolidation_flag
								   , cash_out_reason_future_investment_not_under_contract_flag
								   , cash_out_reason_future_investment_under_contract_flag
								   , cash_out_reason_home_improvement_flag
								   , cash_out_reason_investment_or_business_property_flag
								   , cash_out_reason_other_flag, cash_out_reason_personal_use_flag
								   , cash_out_reason_student_loans_flag
								   , non_business_cash_out_reason_acknowledged
								   , non_business_cash_out_reason_acknowledged_code)
	VALUES (0, 0, NOW(), NOW(), NULL, 'cash_out_reason_business_debt_or_debt_consolidation_flag~' ||
	                                  'cash_out_reason_debt_or_other_consolidation_flag~' ||
	                                  'cash_out_reason_future_investment_not_under_contract_flag~' ||
	                                  'cash_out_reason_future_investment_under_contract_flag~' ||
	                                  'cash_out_reason_home_improvement_flag~' ||
	                                  'cash_out_reason_investment_or_business_property_flag~' ||
	                                  'cash_out_reason_other_flag~' ||
	                                  'cash_out_reason_personal_use_flag~' ||
	                                  'cash_out_reason_student_loans_flag~' ||
	                                  'non_business_cash_out_reason_acknowledged_code~data_source_dwid',
	        '<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~0', NOW(), NULL, NULL, NULL, NULL,
	        NULL, NULL, NULL, NULL, NULL, NULL, NULL);


CREATE TABLE star_loan.hmda_action_dim (
	dwid BIGSERIAL NOT NULL
    	CONSTRAINT pk_hmda_action_dim
        	PRIMARY KEY
	, data_source_dwid BIGINT NOT NULL
	, edw_created_datetime TIMESTAMPTZ
	, edw_modified_datetime TIMESTAMPTZ
	, etl_batch_id TEXT
	, data_source_integration_columns TEXT
	, data_source_integration_id TEXT NOT NULL
	, data_source_modified_datetime TIMESTAMPTZ
    , hmda_action VARCHAR(1024)
	, hmda_action_code VARCHAR(128)
	, hmda_denial_reason_1 VARCHAR(1024)
	, hmda_denial_reason_2 VARCHAR(1024)
	, hmda_denial_reason_3 VARCHAR(1024)
	, hmda_denial_reason_4 VARCHAR(1024)
	, hmda_denial_reason_code_1 VARCHAR(128)
	, hmda_denial_reason_code_2 VARCHAR(128)
	, hmda_denial_reason_code_3 VARCHAR(128)
	, hmda_denial_reason_code_4 VARCHAR(128)
);

INSERT
INTO star_loan.hmda_action_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id
							   , data_source_integration_columns, data_source_integration_id
							   , data_source_modified_datetime, hmda_action, hmda_action_code, hmda_denial_reason_1
							   , hmda_denial_reason_2, hmda_denial_reason_3, hmda_denial_reason_4
							   , hmda_denial_reason_code_1, hmda_denial_reason_code_2, hmda_denial_reason_code_3
							   , hmda_denial_reason_code_4)
	VALUES (0, 0, NOW(), NOW(), NULL, 'hmda_action_code~hmda_denial_reason_code_1~hmda_denial_reason_code_2' ||
	                                  '~hmda_denial_reason_code_3~hmda_deniaL_reason_code_4~data_source_dwid',
	        '<NULL>~<NULL>~<NULL>~<NULL>~<NULL>~0', NOW(), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

CREATE TABLE star_loan.underwrite_dim (
	dwid BIGSERIAL NOT NULL
    	CONSTRAINT pk_underwrite_dim
        	PRIMARY KEY
	, data_source_dwid BIGINT NOT NULL
	, edw_created_datetime TIMESTAMPTZ
	, edw_modified_datetime TIMESTAMPTZ
	, etl_batch_id TEXT
	, data_source_integration_columns TEXT
	, data_source_integration_id TEXT NOT NULL
	, data_source_modified_datetime TIMESTAMPTZ
    , underwrite_disposition VARCHAR(1024)
	, underwrite_disposition_code VARCHAR(128)
	, underwrite_method VARCHAR(1024)
	, underwrite_method_code VARCHAR(128)
	, underwrite_risk_assessment VARCHAR(1024)
	, underwrite_risk_assessment_code VARCHAR(128)
);

INSERT
INTO star_loan.underwrite_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id
									 , data_source_integration_columns, data_source_integration_id
									 , data_source_modified_datetime, underwrite_disposition
									 , underwrite_disposition_code, underwrite_method, underwrite_method_code
									 , underwrite_risk_assessment, underwrite_risk_assessment_code)
	VALUES (0, 0, NOW(), NOW(), NULL,
	        'underwrite_disposition_code~underwrite_method_code~underwrite_risk_assessment_code~data_source_dwid',
	        '<NULL>~<NULL>~<NULL>~0', NOW(), NULL, NULL, NULL, NULL, NULL, NULL);


CREATE TABLE star_loan.transaction_aux_construction_dim (
	transaction_dwid BIGINT NOT NULL
    	CONSTRAINT pk_transaction_aux_construction_dim
        	PRIMARY KEY
	, data_source_dwid BIGINT NOT NULL
	, edw_created_datetime TIMESTAMPTZ
	, edw_modified_datetime TIMESTAMPTZ
	, etl_batch_id TEXT
	, data_source_integration_columns TEXT
	, data_source_integration_id TEXT NOT NULL
	, data_source_modified_datetime TIMESTAMPTZ
	, deal_pid BIGINT NOT NULL
	, active_proposal_pid BIGINT NOT NULL
	, financed_property_improvements_flag BOOLEAN
	, loan_modification_agreement_executed_received_datetime TIMESTAMPTZ
	, adjusted_as_is_value_amount NUMERIC(15,0)
	, after_improved_value_amount NUMERIC(15,0)
	, construction_borrower_contribution_amount NUMERIC(15,2)
	, estimated_hard_construction_cost_amount BIGINT
	, cr_tracker_url VARCHAR(1024)
	, construction_lot_ownership_status VARCHAR(1024)
	, construction_lot_ownership_status_code VARCHAR(128)
	, financed_property_improvements_category VARCHAR(1024)
	, financed_property_improvements_category_code VARCHAR(128)
);

INSERT
INTO star_loan.transaction_aux_construction_dim (transaction_dwid, data_source_dwid, edw_created_datetime
													   , edw_modified_datetime, etl_batch_id
													   , data_source_integration_columns, data_source_integration_id
													   , data_source_modified_datetime, deal_pid, active_proposal_pid
													   , financed_property_improvements_flag
													   , loan_modification_agreement_executed_received_datetime
													   , adjusted_as_is_value_amount, after_improved_value_amount
													   , construction_borrower_contribution_amount
													   , estimated_hard_construction_cost_amount, cr_tracker_url
													   , construction_lot_ownership_status
													   , construction_lot_ownership_status_code
													   , financed_property_improvements_category
													   , financed_property_improvements_category_code)
	VALUES (0, 0, NOW(), NOW(), NULL, 'deal_pid~data_source_dwid', '0~0', NOW(), 0, 0, NULL, NULL, NULL, NULL, NULL,
	        NULL, NULL, NULL, NULL, NULL, NULL);


CREATE TABLE star_loan.transaction_aux_disaster_declaration_dim (
	transaction_dwid BIGINT NOT NULL
    	CONSTRAINT pk_transaction_aux_disaster_declaration_dim
        	PRIMARY KEY
	, data_source_dwid BIGINT NOT NULL
	, edw_created_datetime TIMESTAMPTZ
	, edw_modified_datetime TIMESTAMPTZ
	, etl_batch_id TEXT
	, data_source_integration_columns TEXT
	, data_source_integration_id TEXT NOT NULL
	, data_source_modified_datetime TIMESTAMPTZ
	, deal_pid BIGINT NOT NULL
	, active_proposal_pid BIGINT NOT NULL
	, any_disaster_declaration_after_appraisal_flag BOOLEAN
	, any_disaster_declaration_before_appraisal_flag BOOLEAN
	, any_disaster_declaration_flag BOOLEAN
	, disaster_declaration_check_date DATE
	, disaster_declaration_check_date_type VARCHAR(1024)
	, disaster_declaration_check_date_type_code VARCHAR(128)
);

CREATE TABLE star_loan.transaction_aux_govt_programs_dim (
	transaction_dwid BIGINT NOT NULL
    	CONSTRAINT pk_transaction_aux_govt_programs_dim
        	PRIMARY KEY
	, data_source_dwid BIGINT NOT NULL
	, edw_created_datetime TIMESTAMPTZ
	, edw_modified_datetime TIMESTAMPTZ
	, etl_batch_id TEXT
	, data_source_integration_columns TEXT
	, data_source_integration_id TEXT NOT NULL
	, data_source_modified_datetime TIMESTAMPTZ
	, deal_pid BIGINT NOT NULL
	, active_proposal_pid BIGINT NOT NULL
	, fha_mip_refund_request_input_error_flag BOOLEAN
	, fha_non_arms_length_ltv_exception_verified_flag BOOLEAN
	, request_fha_mip_refund_required_flag BOOLEAN
	, texas_equity_conversion_determination_datetime_override_flag BOOLEAN
	, texas_equity_determination_datetime_override_flag BOOLEAN
	, va_maintenance_utilities_auto_compute_flag BOOLEAN
	, fha_prior_agency_case_endorsement_date DATE
	, fha_refinance_authorization_expiration_date DATE
	, texas_equity_determination_datetime TIMESTAMPTZ
	, usda_gsa_sam_checked_date DATE
	, va_notice_of_value_date DATE
	, cema_borrower_savings NUMERIC(15,2)
	, fha_va_reasonable_value_amount NUMERIC(15,0)
	, va_actual_guaranty_amount NUMERIC(15,2)
	, va_amount_used_to_calculate_maximum_guaranty NUMERIC(15,2)
	, va_energy_efficient_improvements_amount NUMERIC(15,2)
	, va_guaranty_percent NUMERIC (11,9)
	, va_maintenance_utilities_per_square_feet_amount NUMERIC(15,2)
	, va_maximum_base_loan_amount NUMERIC(15,2)
	, va_maximum_funding_fee_amount NUMERIC(15,2)
	, va_maximum_total_loan_amount NUMERIC(15,2)
	, va_monthly_maintenance_utilities_amount NUMERIC(15,2)
	, va_notice_of_value_estimated_reasonable_value_amount NUMERIC(15,0)
	, va_required_cash_amount NUMERIC(15,2)
	, va_required_guaranty_amount NUMERIC(15,2)
	, fha_prior_agency_case_id VARCHAR(32)
	, fha_refinance_authorization_number VARCHAR(16)
	, fhac_refinance_authorization_messages TEXT
	, texas_equity_conversion_determ_datetime_override_reason TEXT
	, texas_equity_determination_datetime_override_reason TEXT
	, va_prior_paid_in_full_loan_number VARCHAR(32)
	, fha_non_arms_length_ltv_exception VARCHAR(1024)
	, fha_non_arms_length_ltv_exception_code VARCHAR(128)
	, hud_fha_de_approval VARCHAR(1024)
	, hud_fha_de_approval_code VARCHAR(128)
	, usda_rd_single_family_housing VARCHAR(1024)
	, usda_rd_single_family_housing_code VARCHAR(128)
	, va_notice_of_value_source VARCHAR(1024)
	, va_notice_of_value_source_code VARCHAR(128)
	, va_past_credit_record VARCHAR(1024)
	, va_past_credit_record_code VARCHAR(128)
	, cema VARCHAR(1024)
	, cema_code VARCHAR(128)
	, fha_eligible_maximum_financing VARCHAR(1024)
	, fha_eligible_maximum_financing_code VARCHAR(128)
	, usda_gsa_sam_exclusion VARCHAR(1024)
	, usda_gsa_sam_exclusion_code VARCHAR(128)
	, va_meets_credit_standards VARCHAR(1024)
	, va_meets_credit_standards_code VARCHAR(128)
	, va_monthly_utilities_included VARCHAR(1024)
	, va_monthly_utilities_included_code VARCHAR(128)
);

INSERT
INTO star_loan.transaction_aux_govt_programs_dim (transaction_dwid, data_source_dwid, edw_created_datetime
												 , edw_modified_datetime, etl_batch_id, data_source_integration_columns
												 , data_source_integration_id, data_source_modified_datetime, deal_pid
												 , active_proposal_pid, fha_mip_refund_request_input_error_flag
												 , fha_non_arms_length_ltv_exception_verified_flag
												 , request_fha_mip_refund_required_flag
												 , texas_equity_conversion_determination_datetime_override_flag
												 , texas_equity_determination_datetime_override_flag
												 , va_maintenance_utilities_auto_compute_flag
												 , fha_prior_agency_case_endorsement_date
												 , fha_refinance_authorization_expiration_date
												 , texas_equity_determination_datetime, usda_gsa_sam_checked_date
												 , va_notice_of_value_date, cema_borrower_savings
												 , fha_va_reasonable_value_amount, va_actual_guaranty_amount
												 , va_amount_used_to_calculate_maximum_guaranty
												 , va_energy_efficient_improvements_amount, va_guaranty_percent
												 , va_maintenance_utilities_per_square_feet_amount
												 , va_maximum_base_loan_amount, va_maximum_funding_fee_amount
												 , va_maximum_total_loan_amount, va_monthly_maintenance_utilities_amount
												 , va_notice_of_value_estimated_reasonable_value_amount
												 , va_required_cash_amount, va_required_guaranty_amount
												 , fha_prior_agency_case_id, fha_refinance_authorization_number
												 , fhac_refinance_authorization_messages
												 , texas_equity_conversion_determ_datetime_override_reason
												 , texas_equity_determination_datetime_override_reason
												 , va_prior_paid_in_full_loan_number, fha_non_arms_length_ltv_exception
												 , fha_non_arms_length_ltv_exception_code, hud_fha_de_approval
												 , hud_fha_de_approval_code, usda_rd_single_family_housing
												 , usda_rd_single_family_housing_code, va_notice_of_value_source
												 , va_notice_of_value_source_code, va_past_credit_record
												 , va_past_credit_record_code, cema, cema_code
												 , fha_eligible_maximum_financing, fha_eligible_maximum_financing_code
												 , usda_gsa_sam_exclusion, usda_gsa_sam_exclusion_code
												 , va_meets_credit_standards, va_meets_credit_standards_code
												 , va_monthly_utilities_included, va_monthly_utilities_included_code)
	VALUES (0, 0, NOW(), NOW(), NULL, 'deal_pid~data_source_dwid', '0~0', NOW(), 0, 0, NULL, NULL, NULL, NULL, NULL,
	        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


CREATE TABLE star_loan.transaction_aux_property_repairs_dim (
	transaction_dwid BIGINT NOT NULL
    	CONSTRAINT pk_transaction_aux_property_repairs_dim
        	PRIMARY KEY
	, data_source_dwid BIGINT NOT NULL
	, edw_created_datetime TIMESTAMPTZ
	, edw_modified_datetime TIMESTAMPTZ
	, etl_batch_id TEXT
	, data_source_integration_columns TEXT
	, data_source_integration_id TEXT NOT NULL
	, data_source_modified_datetime TIMESTAMPTZ
	, deal_pid BIGINT NOT NULL
	, active_proposal_pid BIGINT NOT NULL
	, property_repairs_completed_notification_date DATE
	, property_repairs_funds_released_contractor_date DATE
	, property_repairs_holdback_required_completion_date DATE
	, property_repairs_inspection_completed_date DATE
	, property_repairs_inspection_ordered_date DATE
	, property_repairs_cost_amount NUMERIC(15,2)
	, property_repairs_holdback_amount NUMERIC(15,2)
	, property_repairs_description VARCHAR(1024)
	, property_repairs_holdback_administrator VARCHAR(128)
	, property_repairs_holdback_calc VARCHAR(1024)
	, property_repairs_holdback_calc_code VARCHAR(128)
	, property_repairs_holdback_payer VARCHAR(1024)
	, property_repairs_holdback_payer_code VARCHAR(128)
	, property_repairs_required VARCHAR(1024)
	, property_repairs_required_code VARCHAR(128)
);


INSERT INTO star_loan.transaction_aux_property_repairs_dim (transaction_dwid, data_source_dwid, edw_created_datetime
														   , edw_modified_datetime, etl_batch_id
														   , data_source_integration_columns, data_source_integration_id
														   , data_source_modified_datetime, deal_pid
														   , active_proposal_pid
														   , property_repairs_completed_notification_date
														   , property_repairs_funds_released_contractor_date
														   , property_repairs_holdback_required_completion_date
														   , property_repairs_inspection_completed_date
														   , property_repairs_inspection_ordered_date
														   , property_repairs_cost_amount
														   , property_repairs_holdback_amount
														   , property_repairs_description
														   , property_repairs_holdback_administrator
														   , property_repairs_holdback_calc
														   , property_repairs_holdback_calc_code
														   , property_repairs_holdback_payer
														   , property_repairs_holdback_payer_code
														   , property_repairs_required, property_repairs_required_code)
	VALUES (0, 0, NOW(), NOW(), NULL, 'deal_pid~data_source_dwid', '0~0', NOW(), 0, 0, NULL, NULL, NULL, NULL, NULL,
	        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


ALTER TABLE star_loan.transaction_dim
	ADD COLUMN borrower_esign_flag BOOLEAN
	, ADD COLUMN deed_taxes_applicable_flag BOOLEAN
	, ADD COLUMN deed_taxes_auto_compute_flag BOOLEAN
	, ADD COLUMN delayed_financing_exception_guidelines_applicable_flag BOOLEAN
	, ADD COLUMN delayed_financing_exception_verified_flag BOOLEAN
	, ADD COLUMN down_payment_percent_mode_flag BOOLEAN
	, ADD COLUMN early_wire_request_flag BOOLEAN
	, ADD COLUMN enable_electronic_transaction_flag BOOLEAN
	, ADD COLUMN escrow_cushion_months_auto_compute_flag BOOLEAN
	, ADD COLUMN first_payment_date_auto_compute_flag BOOLEAN
	, ADD COLUMN household_income_exclusive_edit_flag BOOLEAN
	, ADD COLUMN intent_to_proceed_provided_flag BOOLEAN
	, ADD COLUMN invoices_enabled_flag BOOLEAN
	, ADD COLUMN ipc_auto_compute_flag BOOLEAN
	, ADD COLUMN minimum_residual_income_auto_compute_flag BOOLEAN
	, ADD COLUMN other_lender_requires_appraisal_flag BOOLEAN
	, ADD COLUMN owner_occupancy_not_required_flag BOOLEAN
	, ADD COLUMN property_taxes_request_input_error_flag BOOLEAN
	, ADD COLUMN publish_flag BOOLEAN
	, ADD COLUMN recording_fees_request_input_error_flag BOOLEAN
	, ADD COLUMN request_property_taxes_required_flag BOOLEAN
	, ADD COLUMN request_recording_fees_required_flag BOOLEAN
	, ADD COLUMN rescission_applicable_flag BOOLEAN
	, ADD COLUMN reserves_auto_compute_flag BOOLEAN
	, ADD COLUMN sap_deal_flag BOOLEAN
	, ADD COLUMN sar_significant_adjustments_flag BOOLEAN
	, ADD COLUMN smart_charges_enabled_flag BOOLEAN
	, ADD COLUMN smart_docs_enabled_flag BOOLEAN
	, ADD COLUMN training_loan_flag BOOLEAN
	, ADD COLUMN active_proposal_publish_date DATE
	, ADD COLUMN calculated_earliest_allowed_consummation_date DATE
	, ADD COLUMN charges_updated_datetime TIMESTAMPTZ
	, ADD COLUMN closing_document_sign_datetime TIMESTAMPTZ
	, ADD COLUMN docs_enabled_datetime TIMESTAMPTZ
	, ADD COLUMN ecoa_decision_due_date DATE
	, ADD COLUMN ecoa_notice_of_incomplete_date DATE
	, ADD COLUMN ecoa_notice_of_incomplete_due_date DATE
	, ADD COLUMN effective_earliest_allowed_consummation_date DATE
	, ADD COLUMN first_payment_date DATE
	, ADD COLUMN fre_ctp_first_payment_due_date DATE
	, ADD COLUMN gfe_interest_rate_expiration_date DATE
	, ADD COLUMN initial_uw_disposition_datetime TIMESTAMPTZ
	, ADD COLUMN initial_uw_submit_datetime TIMESTAMPTZ
	, ADD COLUMN invoices_enabled_date DATE
	, ADD COLUMN land_acquisition_transaction_date DATE
	, ADD COLUMN last_corrective_disclosure_processed_datetime TIMESTAMPTZ
	, ADD COLUMN last_requested_disclosure_date DATE
	, ADD COLUMN lender_escrow_loan_due_date DATE
	, ADD COLUMN overridden_earliest_allowed_consummation_date DATE
	, ADD COLUMN preapproval_uw_disposition_datetime TIMESTAMPTZ
	, ADD COLUMN preapproval_uw_submit_datetime TIMESTAMPTZ
	, ADD COLUMN proposal_expiration_date DATE
	, ADD COLUMN purchase_contract_date DATE
	, ADD COLUMN purchase_contract_financing_contingency_date DATE
	, ADD COLUMN purchase_contract_funding_date DATE
	, ADD COLUMN purchase_contract_received_date DATE
	, ADD COLUMN rescission_effective_date DATE
	, ADD COLUMN rescission_notification_date DATE
	, ADD COLUMN rescission_through_date DATE
	, ADD COLUMN scheduled_closing_document_sign_datetime TIMESTAMPTZ
	, ADD COLUMN signed_closing_doc_received_datetime TIMESTAMPTZ
	, ADD COLUMN transaction_deal_create_datetime TIMESTAMPTZ
	, ADD COLUMN transaction_orphan_earliest_check_date DATE
	, ADD COLUMN transaction_proposal_create_datetime TIMESTAMPTZ
	, ADD COLUMN transaction_status_date DATE
	, ADD COLUMN transaction_welcome_call_datetime TIMESTAMPTZ
	, ADD COLUMN underwrite_expiration_date DATE
	, ADD COLUMN user_entered_note_date DATE
	, ADD COLUMN anti_steering_lowest_cost_option_fee_amount NUMERIC(15,2)
	, ADD COLUMN anti_steering_lowest_cost_option_rate_percent NUMERIC (11,9)
	, ADD COLUMN anti_steering_lowest_rate_option_fee_amount NUMERIC(15,2)
	, ADD COLUMN anti_steering_lowest_rate_option_rate_percent NUMERIC(11,9)
	, ADD COLUMN anti_steering_lowest_rate_wo_neg_option_fee_amount NUMERIC(15,2)
	, ADD COLUMN anti_steering_lowest_rate_wo_neg_option_rate_percent NUMERIC(11,9)
	, ADD COLUMN area_median_income NUMERIC(15,2)
	, ADD COLUMN decision_appraised_value_amount NUMERIC(15,0)
	, ADD COLUMN decision_credit_score INTEGER
	, ADD COLUMN down_payment_percent NUMERIC(11,9)
	, ADD COLUMN effective_credit_score INTEGER
	, ADD COLUMN effective_property_value_amount NUMERIC(15,0)
	, ADD COLUMN escrow_cushion_months INTEGER
	, ADD COLUMN estimated_credit_score INTEGER
	, ADD COLUMN estimated_property_value_amount NUMERIC(15,0)
	, ADD COLUMN gfe_lock_before_settlement_days INTEGER
	, ADD COLUMN gfe_lock_duration_days INTEGER
	, ADD COLUMN household_size_count INTEGER
	, ADD COLUMN ipc_amount NUMERIC(15,2)
	, ADD COLUMN ipc_financing_concession_amount NUMERIC(15,2)
	, ADD COLUMN ipc_limit_percent NUMERIC(11,9)
	, ADD COLUMN ipc_maximum_amount_allowed NUMERIC(15,2)
	, ADD COLUMN ipc_non_cash_concession_amount NUMERIC(15,2)
	, ADD COLUMN ipc_percent NUMERIC(11,9)
	, ADD COLUMN land_acquisition_price NUMERIC(15,0)
	, ADD COLUMN lender_escrow_loan_amount NUMERIC(15,2)
	, ADD COLUMN minimum_household_income_amount NUMERIC(15,2)
	, ADD COLUMN minimum_residual_income_amount NUMERIC(15,2)
	, ADD COLUMN proposed_additional_monthly_payment NUMERIC(17,2)
	, ADD COLUMN reserves_amount NUMERIC(15,2)
	, ADD COLUMN reserves_months INTEGER
	, ADD COLUMN sale_price_amount NUMERIC(15,0)
	, ADD COLUMN term_borrower_intends_to_retain_property INTEGER
	, ADD COLUMN total_income_to_ami_ratio NUMERIC(14,9)
	, ADD COLUMN active_proposal_description VARCHAR(256)
	, ADD COLUMN active_proposal_name VARCHAR(128)
	, ADD COLUMN calyx_loan_guid VARCHAR(128)
	, ADD COLUMN cash_out_reason_other_text VARCHAR(128)
	, ADD COLUMN copy_source_los_loan_id_main BIGINT
	, ADD COLUMN copy_source_los_loan_id_piggyback BIGINT
	, ADD COLUMN deed_taxes_applicable_explanation VARCHAR(1024)
	, ADD COLUMN deed_taxes_auto_compute_override_reason VARCHAR(1024)
	, ADD COLUMN earliest_allowed_consummation_date_override_reason TEXT
	, ADD COLUMN effective_signing_location_city VARCHAR(128)
	, ADD COLUMN external_loan_id_main VARCHAR(32)
	, ADD COLUMN external_loan_id_piggyback VARCHAR(32)
	, ADD COLUMN hmda_denial_reason_other_description VARCHAR(255)
	, ADD COLUMN hmda_universal_loan_id_main VARCHAR(45)
	, ADD COLUMN hmda_universal_loan_id_piggyback VARCHAR(45)
	, ADD COLUMN intent_to_proceed_obtainer_unparsed_name VARCHAR(128)
	, ADD COLUMN intent_to_proceed_provider_unparsed_name VARCHAR(128)
	, ADD COLUMN lead_reference_id VARCHAR(256)
	, ADD COLUMN lead_tracking_id VARCHAR(256)
	, ADD COLUMN lead_zillow_zq VARCHAR(256)
	, ADD COLUMN los_loan_number_main BIGINT
	, ADD COLUMN los_loan_number_piggyback BIGINT
	, ADD COLUMN mers_min_main VARCHAR(20)
	, ADD COLUMN mers_min_piggyback VARCHAR(20)
	, ADD COLUMN other_lender_requires_appraisal_reason TEXT
	, ADD COLUMN property_tax_request_error_messages TEXT
	, ADD COLUMN recsission_notication_by VARCHAR(256)
	, ADD COLUMN referred_by_name VARCHAR(128)
	, ADD COLUMN trustee_address_city VARCHAR(128)
	, ADD COLUMN trustee_address_country VARCHAR(128)
	, ADD COLUMN trustee_address_postal_code VARCHAR(128)
	, ADD COLUMN trustee_address_state VARCHAR(128)
	, ADD COLUMN trustee_address_street1 VARCHAR(128)
	, ADD COLUMN trustee_address_street2 VARCHAR(128)
	, ADD COLUMN trustee_mers_org_id VARCHAR(7)
	, ADD COLUMN trustee_name VARCHAR(128)
	, ADD COLUMN trustee_phone_number VARCHAR(32)
	, ADD COLUMN underwrite_disposition_note VARCHAR(1024)
	, ADD COLUMN underwriting_comments VARCHAR(1024)
	, ADD COLUMN uuts_master_contact_name VARCHAR(128)
	, ADD COLUMN uuts_master_contact_title VARCHAR(128)
	, ADD COLUMN uuts_master_office_phone VARCHAR(32)
	, ADD COLUMN uuts_master_office_phone_extension VARCHAR(16)
	, ADD COLUMN velocify_lead_id VARCHAR(32)
	, ADD COLUMN active_proposal_type VARCHAR(1024)
	, ADD COLUMN active_proposal_type_code VARCHAR(128)
	, ADD COLUMN application_type VARCHAR(1024)
	, ADD COLUMN application_type_code VARCHAR(128)
	, ADD COLUMN credit_bureau VARCHAR(1024)
	, ADD COLUMN credit_bureau_code VARCHAR(128)
	, ADD COLUMN disclosure_action VARCHAR(1024)
	, ADD COLUMN disclosure_action_code VARCHAR(128)
	, ADD COLUMN doc_level VARCHAR(1024)
	, ADD COLUMN doc_level_code VARCHAR(128)
	, ADD COLUMN effective_property_value_explanation VARCHAR(1024)
	, ADD COLUMN effective_property_value_explanation_code VARCHAR(128)
	, ADD COLUMN effective_property_value_type VARCHAR(1024)
	, ADD COLUMN effective_property_value_type_code VARCHAR(128)
	, ADD COLUMN effective_signing_location_state VARCHAR(1024)
	, ADD COLUMN effective_signing_location_state_code VARCHAR(128)
	, ADD COLUMN fre_ctp_closing_feature VARCHAR(1024)
	, ADD COLUMN fre_ctp_closing_feature_code VARCHAR(128)
	, ADD COLUMN gse_version VARCHAR(1024)
	, ADD COLUMN gse_version_code VARCHAR(128)
	, ADD COLUMN intent_to_proceed VARCHAR(1024)
	, ADD COLUMN intent_to_proceed_code VARCHAR(128)
	, ADD COLUMN orphan_status VARCHAR(1024)
	, ADD COLUMN orphan_status_code VARCHAR(128)
	, ADD COLUMN realty_agent_scenario VARCHAR(1024)
	, ADD COLUMN realty_agent_scenario_code VARCHAR(128)
	, ADD COLUMN rescission_notification VARCHAR(1024)
	, ADD COLUMN rescission_notification_code VARCHAR(128)
	, ADD COLUMN security_instrument VARCHAR(1024)
	, ADD COLUMN security_instrument_code VARCHAR(128)
	, ADD COLUMN transaction_create_type VARCHAR(1024)
	, ADD COLUMN transaction_create_type_code VARCHAR(128)
	, ADD COLUMN transaction_status VARCHAR(1024)
	, ADD COLUMN transaction_status_code VARCHAR(128)
	, ADD COLUMN any_vesting_changes VARCHAR(1024)
	, ADD COLUMN any_vesting_changes_code VARCHAR(128)
	, ADD COLUMN arms_length VARCHAR(1024)
	, ADD COLUMN arms_length_code VARCHAR(128)
	, ADD COLUMN early_first_payment VARCHAR(1024)
	, ADD COLUMN early_first_payment_code VARCHAR(128)
	, ADD COLUMN earthquake_insurance_applicable VARCHAR(1024)
	, ADD COLUMN earthquake_insurance_applicable_code VARCHAR(128)
	, ADD COLUMN flood_insurance_applicable VARCHAR(1024)
	, ADD COLUMN flood_insurance_applicable_code VARCHAR(128)
	, ADD COLUMN hazard_insurance_applicable VARCHAR(1024)
	, ADD COLUMN hazard_insurance_applicable_code VARCHAR(128)
	, ADD COLUMN hud_consultant VARCHAR(1024)
	, ADD COLUMN hud_consultant_code VARCHAR(128)
	, ADD COLUMN mortgagee_builder_seller_relationship VARCHAR(1024)
	, ADD COLUMN mortgagee_builder_seller_relationship_code VARCHAR(128)
	, ADD COLUMN property_acquired_through_acillary_relief VARCHAR(1024)
	, ADD COLUMN property_acquired_through_acillary_relief_code VARCHAR(128)
	, ADD COLUMN property_acquired_through_inheritance VARCHAR(1024)
	, ADD COLUMN property_acquired_through_inheritance_code VARCHAR(128)
	, ADD COLUMN separate_transaction_for_land_acquisition VARCHAR(1024)
	, ADD COLUMN separate_transaction_for_land_acquisition_code VARCHAR(128)
	, ADD COLUMN taxes_escrowed VARCHAR(1024)
	, ADD COLUMN taxes_escrowed_code VARCHAR(128)
	, ADD COLUMN vesting_change_titleholder_added VARCHAR(1024)
	, ADD COLUMN vesting_change_titleholder_added_code VARCHAR(128)
	, ADD COLUMN vesting_change_titleholder_name_change VARCHAR(1024)
	, ADD COLUMN vesting_change_titleholder_name_change_code VARCHAR(128)
	, ADD COLUMN vesting_change_titleholder_removed VARCHAR(1024)
	, ADD COLUMN vesting_change_titleholder_removed_code VARCHAR(128)
	, ADD COLUMN windstorm_insurance_applicable VARCHAR(1024)
	, ADD COLUMN windstorm_insurance_applicable_code VARCHAR(128);


ALTER TABLE star_loan.loan_fact
	ADD COLUMN cash_out_reason_dwid BIGINT
	, ADD COLUMN hmda_action_dwid BIGINT
	, ADD COLUMN underwrite_dwid BIGINT
	, ADD COLUMN transaction_aux_construction_dwid BIGINT
	, ADD COLUMN transaction_aux_disaster_declaration_dwid BIGINT
	, ADD COLUMN transaction_aux_govt_programs_dwid BIGINT
	, ADD COLUMN transaction_aux_property_repairs_dwid BIGINT
    , ADD COLUMN cd_clear_date_dwid BIGINT
	, ADD COLUMN charges_enabled_date_dwid BIGINT
	, ADD COLUMN ecoa_application_date_dwid BIGINT
	, ADD COLUMN effective_earliest_allowed_consummation_date_dwid BIGINT
	, ADD COLUMN effective_hmda_action_date_dwid BIGINT
	, ADD COLUMN effective_note_date_dwid BIGINT
	, ADD COLUMN hmda_action_date_dwid BIGINT
	, ADD COLUMN initial_cancel_status_date_dwid BIGINT
	, ADD COLUMN initial_uw_disposition_date_dwid BIGINT
	, ADD COLUMN initial_uw_submit_date_dwid BIGINT
	, ADD COLUMN note_date_dwid BIGINT
	, ADD COLUMN preapproval_uw_submit_date_dwid BIGINT
	, ADD COLUMN transaction_create_date_dwid BIGINT
	, ADD COLUMN transaction_welcome_call_date_dwid BIGINT
	, ADD COLUMN trid_application_date_dwid BIGINT
	, ADD COLUMN underwrite_publish_date_dwid BIGINT;
