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
	, cash_out_reason_debt_or_debt_consolidation_flag BOOLEAN
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

CREATE INDEX idx_cash_out_reason_dim__etl_batch_id ON star_loan.cash_out_reason_dim (etl_batch_id);
CREATE INDEX idx_cash_out_reason_dim__data_source_integration_id ON star_loan.cash_out_reason_dim (data_source_integration_id);

INSERT INTO star_loan.cash_out_reason_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id
								   , data_source_integration_columns, data_source_integration_id
								   , data_source_modified_datetime
								   , cash_out_reason_business_debt_or_debt_consolidation_flag
								   , cash_out_reason_debt_or_debt_consolidation_flag
								   , cash_out_reason_future_investment_not_under_contract_flag
								   , cash_out_reason_future_investment_under_contract_flag
								   , cash_out_reason_home_improvement_flag
								   , cash_out_reason_investment_or_business_property_flag
								   , cash_out_reason_other_flag, cash_out_reason_personal_use_flag
								   , cash_out_reason_student_loans_flag
								   , non_business_cash_out_reason_acknowledged
								   , non_business_cash_out_reason_acknowledged_code)
	VALUES (0, 0, NOW(), NOW(), NULL, 'cash_out_reason_business_debt_or_debt_consolidation_flag~' ||
	                                  'cash_out_reason_debt_or_debt_consolidation_flag~' ||
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

CREATE INDEX idx_hmda_action_dim__etl_batch_id ON star_loan.hmda_action_dim (etl_batch_id);
CREATE INDEX idx_hmda_action_dim__data_source_integration_id ON star_loan.hmda_action_dim (data_source_integration_id);

INSERT INTO star_loan.hmda_action_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id
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

CREATE INDEX idx_underwrite_dim__etl_batch_id ON star_loan.underwrite_dim (etl_batch_id);
CREATE INDEX idx_underwrite_dim__data_source_integration_id ON star_loan.underwrite_dim (data_source_integration_id);

INSERT INTO star_loan.underwrite_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id
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

CREATE INDEX idx_transaction_aux_construction_dim__etl_batch_id ON star_loan.transaction_aux_construction_dim (etl_batch_id);
CREATE INDEX idx_27025b9014d47d482cd5e9ec905c2147 ON star_loan.transaction_aux_construction_dim (data_source_integration_id);
CREATE INDEX idx_transaction_aux_construction_dim__deal_pid ON star_loan.transaction_aux_construction_dim (deal_pid);
CREATE INDEX idx_transaction_aux_construction_dim__active_proposal_pid ON star_loan.transaction_aux_construction_dim (active_proposal_pid);

INSERT INTO star_loan.transaction_aux_construction_dim (transaction_dwid, data_source_dwid, edw_created_datetime
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

CREATE INDEX idx_transaction_aux_disaster_declaration_dim__etl_batch_id ON star_loan.transaction_aux_disaster_declaration_dim (etl_batch_id);
CREATE INDEX idx_446b96e1239ccc6eec4b201cb1479f92 ON star_loan.transaction_aux_disaster_declaration_dim (data_source_integration_id);
CREATE INDEX idx_transaction_aux_disaster_declaration_dim ON star_loan.transaction_aux_disaster_declaration_dim (deal_pid);
CREATE INDEX idx_transactoin_aux_disaster_declaration_dim ON star_loan.transaction_aux_disaster_declaration_dim (active_proposal_pid);

INSERT INTO star_loan.transaction_aux_disaster_declaration_dim (transaction_dwid, data_source_dwid
															   , edw_created_datetime, edw_modified_datetime
															   , etl_batch_id, data_source_integration_columns
															   , data_source_integration_id
															   , data_source_modified_datetime, deal_pid
															   , active_proposal_pid
															   , any_disaster_declaration_after_appraisal_flag
															   , any_disaster_declaration_before_appraisal_flag
															   , any_disaster_declaration_flag
															   , disaster_declaration_check_date
															   , disaster_declaration_check_date_type
															   , disaster_declaration_check_date_type_code)
	VALUES (0, 0, NOW(), NOW(), NULL, 'deal_pid~data_source_dwid', '0~0', NOW(), 0, 0, NULL, NULL, NULL, NULL, NULL,
	        NULL);


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

CREATE INDEX idx_transaction_aux_govt_programs_dim__etl_batch_id ON star_loan.transaction_aux_govt_programs_dim (etl_batch_id);
CREATE INDEX idx_9e2819b5aa61f14cd203b6213dea81a0 ON star_loan.transaction_aux_govt_programs_dim (data_source_integration_id);
CREATE INDEX idx_transaction_aux_govt_programs_dim__deal_pid ON star_loan.transaction_aux_govt_programs_dim (deal_pid);
CREATE INDEX idx_transaction_aux_govt_programs_dim__active_proposal_pid ON star_loan.transaction_aux_govt_programs_dim (active_proposal_pid);

INSERT INTO star_loan.transaction_aux_govt_programs_dim (transaction_dwid, data_source_dwid, edw_created_datetime
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

CREATE INDEX idx_transaction_aux_property_repairs_dim__etl_batch_id ON star_loan.transaction_aux_property_repairs_dim (etl_batch_id);
CREATE INDEX idx_e52402860b802ade209a27c2e38cf98f ON star_loan.transaction_aux_property_repairs_dim (data_source_integration_id);
CREATE INDEX idx_transaction_aux_property_repairs_dim__deal_pid ON star_loan.transaction_aux_property_repairs_dim (deal_pid);
CREATE INDEX idx_transaction_aux_property_repairs_dim__active_proposal_pid ON star_loan.transaction_aux_property_repairs_dim (active_proposal_pid);

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
	, ADD COLUMN ecoa_application_complete_date DATE
	, ADD COLUMN ecoa_application_received_date DATE
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
	, ADD COLUMN property_acquired_through_ancillary_relief VARCHAR(1024)
	, ADD COLUMN property_acquired_through_ancillary_relief_code VARCHAR(128)
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
    , ADD COLUMN cd_clear_date_dwid BIGINT
	, ADD COLUMN charges_enabled_date_dwid BIGINT
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

CREATE INDEX idx_loan_fact__cash_out_reason_dwid ON star_loan.loan_fact (cash_out_reason_dwid);
CREATE INDEX idx_loan_fact__hmda_action_dwid ON star_loan.loan_fact (hmda_action_dwid);
CREATE INDEX idx_loan_fact__underwrite_dwid ON star_loan.loan_fact (underwrite_dwid);
CREATE INDEX idx_loan_fact__cd_clear_date_dwid ON star_loan.loan_fact (cd_clear_date_dwid);
CREATE INDEX idx_loan_fact__charges_enabled_date_dwid ON star_loan.loan_fact (charges_enabled_date_dwid);
CREATE INDEX idx_4f7b260241c5cf3e35a967b26b40a9c5 ON star_loan.loan_fact (effective_earliest_allowed_consummation_date_dwid);
CREATE INDEX idx_loan_fact__effective_hmda_action_date_dwid ON star_loan.loan_fact (effective_hmda_action_date_dwid);
CREATE INDEX idx_loan_fact__effective_note_date_dwid ON star_loan.loan_fact (effective_note_date_dwid);
CREATE INDEX idx_loan_fact__hmda_action_date_dwid ON star_loan.loan_fact (hmda_action_date_dwid);
CREATE INDEX idx_loan_fact__initial_cancel_status_date_dwid ON star_loan.loan_fact (initial_cancel_status_date_dwid);
CREATE INDEX idx_loan_fact__initial_uw_disposition_date_dwid ON star_loan.loan_fact (initial_uw_disposition_date_dwid);
CREATE INDEX idx_loan_fact__initial_uw_submit_date_dwid ON star_loan.loan_fact (initial_uw_submit_date_dwid);
CREATE INDEX idx_loan_fact__note_date_dwid ON star_loan.loan_fact (note_date_dwid);
CREATE INDEX idx_loan_fact__preapproval_uw_submit_date_dwid ON star_loan.loan_fact (preapproval_uw_submit_date_dwid);
CREATE INDEX idx_loan_fact__transaction_create_date_dwid ON star_loan.loan_fact (transaction_create_date_dwid);
CREATE INDEX idx_loan_fact__transaction_welcome_call_date_dwid ON star_loan.loan_fact (transaction_welcome_call_date_dwid);
CREATE INDEX idx_loan_fact__trid_application_date_dwid ON star_loan.loan_fact (trid_application_date_dwid);
CREATE INDEX idx_loan_fact__underwrite_publish_date_dwid ON star_loan.loan_fact (underwrite_publish_date_dwid);


/*
BACKFILL NEW FIELDS IN THE FOLLOWING TABLES:
	- transaction_dim
	- loan_fact
*/

UPDATE star_loan.transaction_dim
	SET edw_modified_datetime = NOW()
		, borrower_esign_flag = deal.d_borrower_esign
		, deed_taxes_applicable_flag = proposal.prp_deed_taxes_applicable
		, deed_taxes_auto_compute_flag = proposal.prp_deed_taxes_auto_compute
		, delayed_financing_exception_guidelines_applicable_flag = proposal.prp_delayed_financing_exception_guidelines_applicable
		, delayed_financing_exception_verified_flag = proposal.prp_delayed_financing_exception_verified
		, down_payment_percent_mode_flag = proposal.prp_down_payment_percent_mode
		, early_wire_request_flag = deal.d_early_wire_request
		, enable_electronic_transaction_flag = deal.d_enable_electronic_transaction
		, escrow_cushion_months_auto_compute_flag = proposal.prp_escrow_cushion_months_auto_compute
		, first_payment_date_auto_compute_flag = proposal.prp_first_payment_date_auto_compute
		, household_income_exclusive_edit_flag = proposal.prp_household_income_exclusive_edit
		, intent_to_proceed_provided_flag = proposal.prp_intent_to_proceed_provided
		, invoices_enabled_flag = deal.d_invoices_enabled
		, ipc_auto_compute_flag = proposal.prp_ipc_auto_compute
		, minimum_residual_income_auto_compute_flag = proposal.prp_minimum_residual_income_auto_compute
		, other_lender_requires_appraisal_flag = proposal.prp_other_lender_requires_appraisal
		, owner_occupancy_not_required_flag = proposal.prp_owner_occupancy_not_required
		, property_taxes_request_input_error_flag = proposal.prp_property_taxes_request_input_error
		, publish_flag = proposal.prp_publish
		, recording_fees_request_input_error_flag = proposal.prp_recording_fees_request_input_error
		, request_property_taxes_required_flag = proposal.prp_request_property_taxes_required
		, request_recording_fees_required_flag = proposal.prp_request_recording_fees_required
		, rescission_applicable_flag = proposal.prp_rescission_applicable
		, reserves_auto_compute_flag = proposal.prp_reserves_auto_compute
		, sap_deal_flag = deal.d_sap_deal
		, sar_significant_adjustments_flag = proposal.prp_sar_significant_adjustments
		, smart_charges_enabled_flag = proposal.prp_smart_charges_enabled
		, smart_docs_enabled_flag = proposal.prp_smart_docs_enabled
		, training_loan_flag = deal.d_training_loan
		, active_proposal_publish_date = proposal.prp_publish_date
		, calculated_earliest_allowed_consummation_date = proposal.prp_calculated_earliest_allowed_consummation_date
		, charges_updated_datetime = proposal.prp_charges_updated_datetime
		, closing_document_sign_datetime = proposal.prp_closing_document_sign_datetime
		, docs_enabled_datetime = proposal.prp_docs_enabled_datetime
		, ecoa_decision_due_date = deal.d_ecoa_decision_due_date
		, ecoa_notice_of_incomplete_date = deal.d_ecoa_notice_of_incomplete_date
		, ecoa_notice_of_incomplete_due_date = deal.d_ecoa_notice_of_incomplete_due_date
		, effective_earliest_allowed_consummation_date = proposal.prp_effective_earliest_allowed_consummation_date
		, first_payment_date = proposal.prp_first_payment_date
		, fre_ctp_first_payment_due_date = proposal.prp_fre_ctp_first_payment_due_date
		, gfe_interest_rate_expiration_date = proposal.prp_gfe_interest_rate_expiration_date
		, initial_uw_disposition_datetime = proposal.prp_initial_uw_disposition_datetime
		, initial_uw_submit_datetime = proposal.prp_initial_uw_submit_datetime
		, invoices_enabled_date = deal.d_invoices_enabled_date
		, land_acquisition_transaction_date = proposal.prp_land_acquisition_transaction_date
		, last_corrective_disclosure_processed_datetime = proposal.prp_last_corrective_disclosure_processed_datetime
		, last_requested_disclosure_date = proposal.prp_last_requested_disclosure_date
		, lender_escrow_loan_due_date = proposal.prp_lender_escrow_loan_due_date
		, overridden_earliest_allowed_consummation_date = proposal.prp_overridden_earliest_allowed_consummation_date
		, preapproval_uw_disposition_datetime = proposal.prp_preapproval_uw_disposition_datetime
		, preapproval_uw_submit_datetime = proposal.prp_preapproval_uw_submit_datetime
		, proposal_expiration_date = proposal.prp_proposal_expiration_date
		, purchase_contract_date = proposal.prp_purchase_contract_date
		, purchase_contract_financing_contingency_date = proposal.prp_purchase_contract_financing_contingency_date
		, purchase_contract_funding_date = proposal.prp_purchase_contract_funding_date
		, purchase_contract_received_date = proposal.prp_purchase_contract_received_date
		, rescission_effective_date = proposal.prp_rescission_effective_date
		, rescission_notification_date = proposal.prp_rescission_notification_date
		, rescission_through_date = proposal.prp_rescission_through_date
		, scheduled_closing_document_sign_datetime = proposal.prp_scheduled_closing_document_sign_datetime
		, signed_closing_doc_received_datetime = proposal.prp_signed_closing_doc_received_datetime
		, transaction_deal_create_datetime = deal.d_deal_create_date_time
		, transaction_orphan_earliest_check_date = deal.d_deal_orphan_earliest_check_date
		, transaction_proposal_create_datetime = proposal.prp_create_datetime
		, transaction_status_date = deal.d_deal_status_date
		, transaction_welcome_call_datetime = deal.d_welcome_call_datetime
		, underwrite_expiration_date = proposal.prp_underwrite_expiration_date
		, user_entered_note_date = proposal.prp_user_entered_note_date
		, anti_steering_lowest_cost_option_fee_amount = proposal.prp_anti_steering_lowest_cost_option_fee_amount
		, anti_steering_lowest_cost_option_rate_percent = proposal.prp_anti_steering_lowest_cost_option_rate_percent
		, anti_steering_lowest_rate_option_fee_amount = proposal.prp_anti_steering_lowest_rate_option_fee_amount
		, anti_steering_lowest_rate_option_rate_percent = proposal.prp_anti_steering_lowest_rate_option_rate_percent
		, anti_steering_lowest_rate_wo_neg_option_fee_amount = proposal.prp_anti_steering_lowest_rate_wo_neg_option_fee_amount
		, anti_steering_lowest_rate_wo_neg_option_rate_percent = proposal.prp_anti_steering_lowest_rate_wo_neg_option_rate_percent
		, area_median_income = proposal.prp_area_median_income
		, decision_appraised_value_amount = proposal.prp_decision_appraised_value_amount
		, decision_credit_score = proposal.prp_decision_credit_score
		, down_payment_percent = proposal.prp_down_payment_percent
		, effective_credit_score = proposal.prp_effective_credit_score
		, effective_property_value_amount = proposal.prp_effective_property_value_amount
		, escrow_cushion_months = proposal.prp_escrow_cushion_months
		, estimated_credit_score = proposal.prp_estimated_credit_score
		, estimated_property_value_amount = proposal.prp_estimated_property_value_amount
		, gfe_lock_before_settlement_days = proposal.prp_gfe_lock_before_settlement_days
		, gfe_lock_duration_days = proposal.prp_gfe_lock_duration_days
		, household_size_count = proposal.prp_household_size_count
		, ipc_amount = proposal.prp_ipc_amount
		, ipc_financing_concession_amount = proposal.prp_ipc_financing_concession_amount
		, ipc_limit_percent = proposal.prp_ipc_limit_percent
		, ipc_maximum_amount_allowed = proposal.prp_ipc_maximum_amount_allowed
		, ipc_non_cash_concession_amount = proposal.prp_ipc_non_cash_concession_amount
		, ipc_percent = proposal.prp_ipc_percent
		, land_acquisition_price = proposal.prp_land_acquisition_price
		, lender_escrow_loan_amount = proposal.prp_lender_escrow_loan_amount
		, minimum_household_income_amount = proposal.prp_minimum_household_income_amount
		, minimum_residual_income_amount = proposal.prp_minimum_residual_income_amount
		, proposed_additional_monthly_payment = proposal.prp_proposed_additional_monthly_payment
		, reserves_amount = proposal.prp_reserves_amount
		, reserves_months = proposal.prp_reserves_months
		, sale_price_amount = proposal.prp_sale_price_amount
		, term_borrower_intends_to_retain_property = proposal.prp_term_borrower_intends_to_retain_property
		, total_income_to_ami_ratio = proposal.prp_total_income_to_ami_ratio
		, active_proposal_description = proposal.prp_description
		, active_proposal_name = proposal.prp_name
		, calyx_loan_guid = deal.d_calyx_loan_guid
		, cash_out_reason_other_text = proposal.prp_cash_out_reason_other_text
		, copy_source_los_loan_id_main = deal.d_copy_source_los_loan_id_main
		, copy_source_los_loan_id_piggyback = deal.d_copy_source_los_loan_id_piggyback
		, deed_taxes_applicable_explanation = proposal.prp_deed_taxes_applicable_explanation
		, deed_taxes_auto_compute_override_reason = proposal.prp_deed_taxes_auto_compute_override_reason
		, earliest_allowed_consummation_date_override_reason = proposal.prp_earliest_allowed_consummation_date_override_reason
		, effective_signing_location_city = proposal.prp_effective_signing_location_city
		, external_loan_id_main = deal.d_external_loan_id_main
		, external_loan_id_piggyback = deal.d_external_loan_id_piggyback
		, hmda_denial_reason_other_description = deal.d_hmda_denial_reason_other_description
		, hmda_universal_loan_id_main = deal.d_hmda_universal_loan_id_main
		, hmda_universal_loan_id_piggyback = deal.d_hmda_universal_loan_id_piggyback
		, intent_to_proceed_obtainer_unparsed_name = proposal.prp_intent_to_proceed_obtainer_unparsed_name
		, intent_to_proceed_provider_unparsed_name = proposal.prp_intent_to_proceed_provider_unparsed_name
		, lead_reference_id = deal.d_lead_reference_id
		, lead_tracking_id = deal.d_lead_tracking_id
		, lead_zillow_zq = deal.d_lead_zillow_zq
		, los_loan_number_main = deal.d_los_loan_id_main
		, los_loan_number_piggyback = deal.d_los_loan_id_piggyback
		, mers_min_main = deal.d_mers_min_main
		, mers_min_piggyback = deal.d_mers_min_piggyback
		, other_lender_requires_appraisal_reason = proposal.prp_other_lender_requires_appraisal_reason
		, property_tax_request_error_messages = proposal.prp_property_tax_request_error_messages
		, recsission_notication_by = proposal.prp_rescission_notification_by
		, referred_by_name = deal.d_referred_by_name
		, trustee_address_city = proposal.prp_trustee_address_city
		, trustee_address_country = proposal.prp_trustee_address_country
		, trustee_address_postal_code = proposal.prp_trustee_address_postal_code
		, trustee_address_state = proposal.prp_trustee_address_state
		, trustee_address_street1 = proposal.prp_trustee_address_street1
		, trustee_address_street2 = proposal.prp_trustee_address_street2
		, trustee_mers_org_id = proposal.prp_trustee_mers_org_id
		, trustee_name = proposal.prp_trustee_name
		, trustee_phone_number = proposal.prp_trustee_phone_number
		, underwrite_disposition_note = proposal.prp_underwrite_disposition_note
		, underwriting_comments = proposal.prp_underwriting_comments
		, uuts_master_contact_name = proposal.prp_uuts_master_contact_name
		, uuts_master_contact_title = proposal.prp_uuts_master_contact_title
		, uuts_master_office_phone = proposal.prp_uuts_master_office_phone
		, uuts_master_office_phone_extension = proposal.prp_uuts_master_office_phone_extension
		, velocify_lead_id = deal.d_velocify_lead_id
		, active_proposal_type = proposal_type.value
		, active_proposal_type_code = proposal.prp_proposal_type
		, application_type = application_type.value
		, application_type_code = deal.d_application_type
		, credit_bureau = credit_bureau_type.value
		, credit_bureau_code = deal.d_credit_bureau_type
		, disclosure_action = disclosure_action_type.value
		, disclosure_action_code = proposal.prp_disclosure_action_type
		, doc_level = doc_level_type.value
		, doc_level_code = proposal.prp_doc_level_type
		, effective_property_value_explanation = effective_property_value_explanation_type.value
		, effective_property_value_explanation_code = proposal.prp_effective_property_value_explanation_type
		, effective_property_value_type = effective_property_value_type.value
		, effective_property_value_type_code = proposal.prp_effective_property_value_type
		, effective_signing_location_state = state_type.value
		, effective_signing_location_state_code = proposal.prp_effective_signing_location_state
		, fre_ctp_closing_feature = fre_ctp_closing_feature_type.value
		, fre_ctp_closing_feature_code = proposal.prp_fre_ctp_closing_feature_type
		, gse_version = gse_version_type.value
		, gse_version_code = proposal.prp_gse_version_type
		, intent_to_proceed = intent_to_proceed_type.value
		, intent_to_proceed_code = proposal.prp_intent_to_proceed_type
		, orphan_status = deal_orphan_status_type.value
		, orphan_status_code = deal.d_deal_orphan_status_type
		, realty_agent_scenario = realty_agent_scenario_type.value
		, realty_agent_scenario_code = deal.d_realty_agent_scenario_type
		, rescission_notification = rescission_notification_type.value
		, rescission_notification_code = proposal.prp_rescission_notification_type
		, security_instrument = security_instrument_type.value
		, security_instrument_code = proposal.prp_security_instrument_type
		, transaction_create_type = deal_create_type.value
		, transaction_create_type_code = deal.d_deal_create_type
		, transaction_status = deal_status_type.value
		, transaction_status_code = deal.d_deal_status_type
		, any_vesting_changes = any_vesting_changes_ynu_type.value
		, any_vesting_changes_code = proposal.prp_any_vesting_changes
		, arms_length = arms_length_ynu_type.value
		, arms_length_code = proposal.prp_arms_length
		, early_first_payment = early_first_payment_ynu_type.value
		, early_first_payment_code = proposal.prp_early_first_payment
		, earthquake_insurance_applicable = earthquake_insurance_applicable_ynu_type.value
		, earthquake_insurance_applicable_code = proposal.prp_earthquake_insurance_applicable
		, flood_insurance_applicable = flood_insurance_applicable_ynu_type.value
		, flood_insurance_applicable_code = proposal.prp_flood_insurance_applicable
		, hazard_insurance_applicable = hazard_insurance_applicable_ynu_type.value
		, hazard_insurance_applicable_code = proposal.prp_hazard_insurance_applicable
		, hud_consultant = hud_consultant_ynu_type.value
		, hud_consultant_code = proposal.prp_hud_consultant
		, mortgagee_builder_seller_relationship = mortgagee_builder_seller_relationship_ynu_type.value
		, mortgagee_builder_seller_relationship_code = proposal.prp_mortgagee_builder_seller_relationship
		, property_acquired_through_ancillary_relief = property_acquired_through_ancillary_relief_ynu_type.value
		, property_acquired_through_ancillary_relief_code = proposal.prp_property_acquired_through_ancillary_relief
		, property_acquired_through_inheritance = property_acquired_through_inheritance_ynu_type.value
		, property_acquired_through_inheritance_code = proposal.prp_property_acquired_through_inheritance
		, separate_transaction_for_land_acquisition = separate_transaction_for_land_acquisition_ynu_type.value
		, separate_transaction_for_land_acquisition_code = proposal.prp_separate_transaction_for_land_acquisition
		, taxes_escrowed = taxes_escrowed_ynu_type.value
		, taxes_escrowed_code = proposal.prp_taxes_escrowed
		, vesting_change_titleholder_added = vesting_change_titleholder_added_ynu_type.value
		, vesting_change_titleholder_added_code = proposal.prp_vesting_change_titleholder_added
		, vesting_change_titleholder_name_change = vesting_change_titleholder_name_change_ynu_type.value
		, vesting_change_titleholder_name_change_code = proposal.prp_vesting_change_titleholder_name_change
		, vesting_change_titleholder_removed = vesting_change_titleholder_removed_ynu_type.value
		, vesting_change_titleholder_removed_code = proposal.prp_vesting_change_titleholder_removed
		, windstorm_insurance_applicable = windstorm_insurance_applicable_ynu_type.value
		, windstorm_insurance_applicable_code = proposal.prp_windstorm_insurance_applicable
		, ecoa_application_complete_date = deal.d_ecoa_application_complete_date
		, ecoa_application_received_date = deal.d_ecoa_application_received_date
FROM (
	SELECT proposal.*
	FROM history_octane.proposal
		LEFT JOIN history_octane.proposal AS history_records
			ON proposal.prp_pid = history_records.prp_pid
				AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
	WHERE history_records.prp_pid IS NULL
) AS proposal
	JOIN (
		SELECT deal.*
		FROM history_octane.deal
			LEFT JOIN history_octane.deal AS history_records
				ON deal.d_pid = history_records.d_pid
					AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.d_pid IS NULL
	) AS deal
		ON proposal.prp_pid = deal.d_active_proposal_pid
	JOIN (
		SELECT proposal_type.*
		FROM history_octane.proposal_type
			LEFT JOIN history_octane.proposal_type AS history_records
				ON proposal_type.code = history_records.code
					AND proposal_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS proposal_type
		ON proposal.prp_proposal_type = proposal_type.code
	JOIN (
		SELECT application_type.*
		FROM history_octane.application_type
			LEFT JOIN history_octane.application_type AS history_records
				ON application_type.code = history_records.code
					AND application_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS application_type
		ON deal.d_application_type = application_type.code
	JOIN (
		SELECT credit_bureau_type.*
		FROM history_octane.credit_bureau_type
			LEFT JOIN history_octane.credit_bureau_type AS history_records
				ON credit_bureau_type.code = history_records.code
					AND credit_bureau_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS credit_bureau_type
		ON deal.d_credit_bureau_type = credit_bureau_type.code
	JOIN (
		SELECT disclosure_action_type.*
		FROM history_octane.disclosure_action_type
			LEFT JOIN history_octane.disclosure_action_type AS history_records
				ON disclosure_action_type.code = history_records.code
					AND disclosure_action_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS disclosure_action_type
		ON proposal.prp_disclosure_action_type = disclosure_action_type.code
	JOIN (
		SELECT doc_level_type.*
		FROM history_octane.doc_level_type
			LEFT JOIN history_octane.doc_level_type AS history_records
				ON doc_level_type.code = history_records.code
					AND doc_level_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS doc_level_type
		ON proposal.prp_doc_level_type = doc_level_type.code
	JOIN (
		SELECT effective_property_value_explanation_type.*
		FROM history_octane.effective_property_value_explanation_type
			LEFT JOIN history_octane.effective_property_value_explanation_type AS history_records
				ON effective_property_value_explanation_type.code = history_records.code
					AND effective_property_value_explanation_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS effective_property_value_explanation_type
		ON proposal.prp_effective_property_value_explanation_type = effective_property_value_explanation_type.code
	JOIN (
		SELECT effective_property_value_type.*
		FROM history_octane.effective_property_value_type
			LEFT JOIN history_octane.effective_property_value_type AS history_records
				ON effective_property_value_type.code = history_records.code
					AND effective_property_value_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS effective_property_value_type
		ON proposal.prp_effective_property_value_type = effective_property_value_type.code
	LEFT JOIN (
		SELECT state_type.*
		FROM history_octane.state_type
			LEFT JOIN history_octane.state_type AS history_records
				ON state_type.code = history_records.code
					AND state_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS state_type
		ON proposal.prp_effective_signing_location_state = state_type.code
	JOIN (
		SELECT fre_ctp_closing_feature_type.*
		FROM history_octane.fre_ctp_closing_feature_type
			LEFT JOIN history_octane.fre_ctp_closing_feature_type AS history_records
				ON fre_ctp_closing_feature_type.code = history_records.code
					AND fre_ctp_closing_feature_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS fre_ctp_closing_feature_type
		ON proposal.prp_fre_ctp_closing_feature_type = fre_ctp_closing_feature_type.code
	JOIN (
		SELECT gse_version_type.*
		FROM history_octane.gse_version_type
			LEFT JOIN history_octane.gse_version_type AS history_records
				ON gse_version_type.code = history_records.code
					AND gse_version_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS gse_version_type
		ON proposal.prp_gse_version_type = gse_version_type.code
	JOIN (
		SELECT intent_to_proceed_type.*
		FROM history_octane.intent_to_proceed_type
			LEFT JOIN history_octane.intent_to_proceed_type AS history_records
				ON intent_to_proceed_type.code = history_records.code
					AND intent_to_proceed_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS intent_to_proceed_type
		ON proposal.prp_intent_to_proceed_type = intent_to_proceed_type.code
	JOIN (
		SELECT deal_orphan_status_type.*
		FROM history_octane.deal_orphan_status_type
			LEFT JOIN history_octane.deal_orphan_status_type AS history_records
				ON deal_orphan_status_type.code = history_records.code
					AND deal_orphan_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS deal_orphan_status_type
		ON deal.d_deal_orphan_status_type = deal_orphan_status_type.code
	JOIN (
		SELECT realty_agent_scenario_type.*
		FROM history_octane.realty_agent_scenario_type
			LEFT JOIN history_octane.realty_agent_scenario_type AS history_records
				ON realty_agent_scenario_type.code = history_records.code
					AND realty_agent_scenario_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS realty_agent_scenario_type
		ON deal.d_realty_agent_scenario_type = realty_agent_scenario_type.code
	JOIN (
		SELECT rescission_notification_type.*
		FROM history_octane.rescission_notification_type
			LEFT JOIN history_octane.rescission_notification_type AS history_records
				ON rescission_notification_type.code = history_records.code
					AND rescission_notification_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS rescission_notification_type
		ON proposal.prp_rescission_notification_type = rescission_notification_type.code
	JOIN (
			SELECT security_instrument_type.*
			FROM history_octane.security_instrument_type
				LEFT JOIN history_octane.security_instrument_type AS history_records
					ON security_instrument_type.code = history_records.code
						AND security_instrument_type.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE history_records.code IS NULL
	) AS security_instrument_type
		ON proposal.prp_security_instrument_type = security_instrument_type.code
	JOIN (
		SELECT deal_create_type.*
		FROM history_octane.deal_create_type
			LEFT JOIN history_octane.deal_create_type AS history_records
				ON deal_create_type.code = history_records.code
					AND deal_create_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS deal_create_type
		ON deal.d_deal_create_type = deal_create_type.code
	JOIN (
		SELECT deal_status_type.*
		FROM history_octane.deal_status_type
			LEFT JOIN history_octane.deal_status_type AS history_records
				ON deal_status_type.code = history_records.code
					AND deal_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS deal_status_type
		ON deal.d_deal_status_type = deal_status_type.code
	JOIN (
		SELECT yes_no_unknown_type.*
		FROM history_octane.yes_no_unknown_type
			LEFT JOIN history_octane.yes_no_unknown_type AS history_records
				ON yes_no_unknown_type.code = history_records.code
					AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS any_vesting_changes_ynu_type
		ON proposal.prp_any_vesting_changes = any_vesting_changes_ynu_type.code
	JOIN (
		SELECT yes_no_unknown_type.*
		FROM history_octane.yes_no_unknown_type
			LEFT JOIN history_octane.yes_no_unknown_type AS history_records
				ON yes_no_unknown_type.code = history_records.code
					AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS arms_length_ynu_type
		ON proposal.prp_arms_length = arms_length_ynu_type.code
	JOIN (
		SELECT yes_no_unknown_type.*
		FROM history_octane.yes_no_unknown_type
			LEFT JOIN history_octane.yes_no_unknown_type AS history_records
				ON yes_no_unknown_type.code = history_records.code
					AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS early_first_payment_ynu_type
		ON proposal.prp_early_first_payment = early_first_payment_ynu_type.code
	JOIN (
		SELECT yes_no_unknown_type.*
		FROM history_octane.yes_no_unknown_type
			LEFT JOIN history_octane.yes_no_unknown_type AS history_records
				ON yes_no_unknown_type.code = history_records.code
					AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS earthquake_insurance_applicable_ynu_type
		ON proposal.prp_earthquake_insurance_applicable = earthquake_insurance_applicable_ynu_type.code
	JOIN (
		SELECT yes_no_unknown_type.*
		FROM history_octane.yes_no_unknown_type
			LEFT JOIN history_octane.yes_no_unknown_type AS history_records
				ON yes_no_unknown_type.code = history_records.code
					AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS flood_insurance_applicable_ynu_type
		ON proposal.prp_flood_insurance_applicable = flood_insurance_applicable_ynu_type.code
	JOIN (
		SELECT yes_no_unknown_type.*
		FROM history_octane.yes_no_unknown_type
			LEFT JOIN history_octane.yes_no_unknown_type AS history_records
				ON yes_no_unknown_type.code = history_records.code
					AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS hazard_insurance_applicable_ynu_type
		ON proposal.prp_hazard_insurance_applicable = hazard_insurance_applicable_ynu_type.code
	JOIN (
		SELECT yes_no_unknown_type.*
		FROM history_octane.yes_no_unknown_type
			LEFT JOIN history_octane.yes_no_unknown_type AS history_records
				ON yes_no_unknown_type.code = history_records.code
					AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS hud_consultant_ynu_type
		ON proposal.prp_hud_consultant = hud_consultant_ynu_type.code
	JOIN (
		SELECT yes_no_unknown_type.*
		FROM history_octane.yes_no_unknown_type
			LEFT JOIN history_octane.yes_no_unknown_type AS history_records
				ON yes_no_unknown_type.code = history_records.code
					AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS mortgagee_builder_seller_relationship_ynu_type
		ON proposal.prp_mortgagee_builder_seller_relationship = mortgagee_builder_seller_relationship_ynu_type.code
	JOIN (
		SELECT yes_no_unknown_type.*
		FROM history_octane.yes_no_unknown_type
			LEFT JOIN history_octane.yes_no_unknown_type AS history_records
				ON yes_no_unknown_type.code = history_records.code
					AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS property_acquired_through_ancillary_relief_ynu_type
		ON proposal.prp_property_acquired_through_ancillary_relief = property_acquired_through_ancillary_relief_ynu_type.code
	JOIN (
		SELECT yes_no_unknown_type.*
		FROM history_octane.yes_no_unknown_type
			LEFT JOIN history_octane.yes_no_unknown_type AS history_records
				ON yes_no_unknown_type.code = history_records.code
					AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS property_acquired_through_inheritance_ynu_type
		ON proposal.prp_property_acquired_through_inheritance = property_acquired_through_inheritance_ynu_type.code
	JOIN (
		SELECT yes_no_unknown_type.*
		FROM history_octane.yes_no_unknown_type
			LEFT JOIN history_octane.yes_no_unknown_type AS history_records
				ON yes_no_unknown_type.code = history_records.code
					AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS separate_transaction_for_land_acquisition_ynu_type
		ON proposal.prp_separate_transaction_for_land_acquisition = separate_transaction_for_land_acquisition_ynu_type.code
	JOIN (
		SELECT yes_no_unknown_type.*
		FROM history_octane.yes_no_unknown_type
			LEFT JOIN history_octane.yes_no_unknown_type AS history_records
				ON yes_no_unknown_type.code = history_records.code
					AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS taxes_escrowed_ynu_type
		ON proposal.prp_taxes_escrowed = taxes_escrowed_ynu_type.code
	JOIN (
		SELECT yes_no_unknown_type.*
		FROM history_octane.yes_no_unknown_type
			LEFT JOIN history_octane.yes_no_unknown_type AS history_records
				ON yes_no_unknown_type.code = history_records.code
					AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS vesting_change_titleholder_added_ynu_type
		ON proposal.prp_vesting_change_titleholder_added = vesting_change_titleholder_added_ynu_type.code
	JOIN (
		SELECT yes_no_unknown_type.*
		FROM history_octane.yes_no_unknown_type
			LEFT JOIN history_octane.yes_no_unknown_type AS history_records
				ON yes_no_unknown_type.code = history_records.code
					AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS vesting_change_titleholder_name_change_ynu_type
		ON proposal.prp_vesting_change_titleholder_name_change = vesting_change_titleholder_name_change_ynu_type.code
	JOIN (
		SELECT yes_no_unknown_type.*
		FROM history_octane.yes_no_unknown_type
			LEFT JOIN history_octane.yes_no_unknown_type AS history_records
				ON yes_no_unknown_type.code = history_records.code
					AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE history_records.code IS NULL
	) AS vesting_change_titleholder_removed_ynu_type
		ON proposal.prp_vesting_change_titleholder_removed = vesting_change_titleholder_removed_ynu_type.code
	JOIN (
		SELECT yes_no_unknown_type.*
		FROM history_octane.yes_no_unknown_type
			LEFT JOIN history_octane.yes_no_unknown_type AS history_records
				ON yes_no_unknown_type.code = history_records.code
					AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.code IS NULL
	) AS windstorm_insurance_applicable_ynu_type
		ON proposal.prp_windstorm_insurance_applicable = windstorm_insurance_applicable_ynu_type.code
WHERE transaction_dim.deal_pid = deal.d_pid
	AND transaction_dim.dwid != 0
	AND COALESCE(transaction_dim.borrower_esign_flag::VARCHAR
	, transaction_dim.deed_taxes_applicable_flag::VARCHAR
	, transaction_dim.deed_taxes_auto_compute_flag::VARCHAR
	, transaction_dim.delayed_financing_exception_guidelines_applicable_flag::VARCHAR
	, transaction_dim.delayed_financing_exception_verified_flag::VARCHAR
	, transaction_dim.down_payment_percent_mode_flag::VARCHAR
	, transaction_dim.early_wire_request_flag::VARCHAR
	, transaction_dim.enable_electronic_transaction_flag::VARCHAR
	, transaction_dim.escrow_cushion_months_auto_compute_flag::VARCHAR
	, transaction_dim.first_payment_date_auto_compute_flag::VARCHAR
	, transaction_dim.household_income_exclusive_edit_flag::VARCHAR
	, transaction_dim.intent_to_proceed_provided_flag::VARCHAR
	, transaction_dim.invoices_enabled_flag::VARCHAR
	, transaction_dim.ipc_auto_compute_flag::VARCHAR
	, transaction_dim.minimum_residual_income_auto_compute_flag::VARCHAR
	, transaction_dim.other_lender_requires_appraisal_flag::VARCHAR
	, transaction_dim.owner_occupancy_not_required_flag::VARCHAR
	, transaction_dim.property_taxes_request_input_error_flag::VARCHAR
	, transaction_dim.publish_flag::VARCHAR
	, transaction_dim.recording_fees_request_input_error_flag::VARCHAR
	, transaction_dim.request_property_taxes_required_flag::VARCHAR
	, transaction_dim.request_recording_fees_required_flag::VARCHAR
	, transaction_dim.rescission_applicable_flag::VARCHAR
	, transaction_dim.reserves_auto_compute_flag::VARCHAR
	, transaction_dim.sap_deal_flag::VARCHAR
	, transaction_dim.sar_significant_adjustments_flag::VARCHAR
	, transaction_dim.smart_charges_enabled_flag::VARCHAR
	, transaction_dim.smart_docs_enabled_flag::VARCHAR
	, transaction_dim.training_loan_flag::VARCHAR
	, transaction_dim.active_proposal_publish_date::VARCHAR
	, transaction_dim.calculated_earliest_allowed_consummation_date::VARCHAR
	, transaction_dim.charges_updated_datetime::VARCHAR
	, transaction_dim.closing_document_sign_datetime::VARCHAR
	, transaction_dim.docs_enabled_datetime::VARCHAR
	, transaction_dim.ecoa_decision_due_date::VARCHAR
	, transaction_dim.ecoa_notice_of_incomplete_date::VARCHAR
	, transaction_dim.ecoa_notice_of_incomplete_due_date::VARCHAR
	, transaction_dim.effective_earliest_allowed_consummation_date::VARCHAR
	, transaction_dim.first_payment_date::VARCHAR
	, transaction_dim.fre_ctp_first_payment_due_date::VARCHAR
	, transaction_dim.gfe_interest_rate_expiration_date::VARCHAR
	, transaction_dim.initial_uw_disposition_datetime::VARCHAR
	, transaction_dim.initial_uw_submit_datetime::VARCHAR
	, transaction_dim.invoices_enabled_date::VARCHAR
	, transaction_dim.land_acquisition_transaction_date::VARCHAR
	, transaction_dim.last_corrective_disclosure_processed_datetime::VARCHAR
	, transaction_dim.last_requested_disclosure_date::VARCHAR
	, transaction_dim.lender_escrow_loan_due_date::VARCHAR
	, transaction_dim.overridden_earliest_allowed_consummation_date::VARCHAR
	, transaction_dim.preapproval_uw_disposition_datetime::VARCHAR
	, transaction_dim.preapproval_uw_submit_datetime::VARCHAR
	, transaction_dim.proposal_expiration_date::VARCHAR
	, transaction_dim.purchase_contract_date::VARCHAR
	, transaction_dim.purchase_contract_financing_contingency_date::VARCHAR
	, transaction_dim.purchase_contract_funding_date::VARCHAR
	, transaction_dim.purchase_contract_received_date::VARCHAR
	, transaction_dim.rescission_effective_date::VARCHAR
	, transaction_dim.rescission_notification_date::VARCHAR
	, transaction_dim.rescission_through_date::VARCHAR
	, transaction_dim.scheduled_closing_document_sign_datetime::VARCHAR
	, transaction_dim.signed_closing_doc_received_datetime::VARCHAR
	, transaction_dim.transaction_deal_create_datetime::VARCHAR
	, transaction_dim.transaction_orphan_earliest_check_date::VARCHAR
	, transaction_dim.transaction_proposal_create_datetime::VARCHAR
	, transaction_dim.transaction_status_date::VARCHAR
	, transaction_dim.transaction_welcome_call_datetime::VARCHAR
	, transaction_dim.underwrite_expiration_date::VARCHAR
	, transaction_dim.user_entered_note_date::VARCHAR
	, transaction_dim.anti_steering_lowest_cost_option_fee_amount::VARCHAR
	, transaction_dim.anti_steering_lowest_cost_option_rate_percent::VARCHAR
	, transaction_dim.anti_steering_lowest_rate_option_fee_amount::VARCHAR
	, transaction_dim.anti_steering_lowest_rate_option_rate_percent::VARCHAR
	, transaction_dim.anti_steering_lowest_rate_wo_neg_option_fee_amount::VARCHAR
	, transaction_dim.anti_steering_lowest_rate_wo_neg_option_rate_percent::VARCHAR
	, transaction_dim.area_median_income::VARCHAR
	, transaction_dim.decision_appraised_value_amount::VARCHAR
	, transaction_dim.decision_credit_score::VARCHAR
	, transaction_dim.down_payment_percent::VARCHAR
	, transaction_dim.effective_credit_score::VARCHAR
	, transaction_dim.effective_property_value_amount::VARCHAR
	, transaction_dim.escrow_cushion_months::VARCHAR
	, transaction_dim.estimated_credit_score::VARCHAR
	, transaction_dim.estimated_property_value_amount::VARCHAR
	, transaction_dim.gfe_lock_before_settlement_days::VARCHAR
	, transaction_dim.gfe_lock_duration_days::VARCHAR
	, transaction_dim.household_size_count::VARCHAR
	, transaction_dim.ipc_amount::VARCHAR
	, transaction_dim.ipc_financing_concession_amount::VARCHAR
	, transaction_dim.ipc_limit_percent::VARCHAR
	, transaction_dim.ipc_maximum_amount_allowed::VARCHAR
	, transaction_dim.ipc_non_cash_concession_amount::VARCHAR
	, transaction_dim.ipc_percent::VARCHAR
	, transaction_dim.land_acquisition_price::VARCHAR
	, transaction_dim.lender_escrow_loan_amount::VARCHAR
	, transaction_dim.minimum_household_income_amount::VARCHAR
	, transaction_dim.minimum_residual_income_amount::VARCHAR
	, transaction_dim.proposed_additional_monthly_payment::VARCHAR
	, transaction_dim.reserves_amount::VARCHAR
	, transaction_dim.reserves_months::VARCHAR
	, transaction_dim.sale_price_amount::VARCHAR
	, transaction_dim.term_borrower_intends_to_retain_property::VARCHAR
	, transaction_dim.total_income_to_ami_ratio::VARCHAR
	, transaction_dim.active_proposal_description
	, transaction_dim.active_proposal_name
	, transaction_dim.calyx_loan_guid
	, transaction_dim.cash_out_reason_other_text
	, transaction_dim.copy_source_los_loan_id_main::VARCHAR
	, transaction_dim.copy_source_los_loan_id_piggyback::VARCHAR
	, transaction_dim.deed_taxes_applicable_explanation
	, transaction_dim.deed_taxes_auto_compute_override_reason
	, transaction_dim.earliest_allowed_consummation_date_override_reason
	, transaction_dim.effective_signing_location_city
	, transaction_dim.external_loan_id_main
	, transaction_dim.external_loan_id_piggyback
	, transaction_dim.hmda_denial_reason_other_description
	, transaction_dim.hmda_universal_loan_id_main
	, transaction_dim.hmda_universal_loan_id_piggyback
	, transaction_dim.intent_to_proceed_obtainer_unparsed_name
	, transaction_dim.intent_to_proceed_provider_unparsed_name
	, transaction_dim.lead_reference_id
	, transaction_dim.lead_tracking_id
	, transaction_dim.lead_zillow_zq
	, transaction_dim.los_loan_number_main::VARCHAR
	, transaction_dim.los_loan_number_piggyback::VARCHAR
	, transaction_dim.mers_min_main
	, transaction_dim.mers_min_piggyback
	, transaction_dim.other_lender_requires_appraisal_reason
	, transaction_dim.property_tax_request_error_messages
	, transaction_dim.recsission_notication_by
	, transaction_dim.referred_by_name
	, transaction_dim.trustee_address_city
	, transaction_dim.trustee_address_country
	, transaction_dim.trustee_address_postal_code
	, transaction_dim.trustee_address_state
	, transaction_dim.trustee_address_street1
	, transaction_dim.trustee_address_street2
	, transaction_dim.trustee_mers_org_id
	, transaction_dim.trustee_name
	, transaction_dim.trustee_phone_number
	, transaction_dim.underwrite_disposition_note
	, transaction_dim.underwriting_comments
	, transaction_dim.uuts_master_contact_name
	, transaction_dim.uuts_master_contact_title
	, transaction_dim.uuts_master_office_phone
	, transaction_dim.uuts_master_office_phone_extension
	, transaction_dim.velocify_lead_id
	, transaction_dim.active_proposal_type
	, transaction_dim.active_proposal_type_code
	, transaction_dim.application_type
	, transaction_dim.application_type_code
	, transaction_dim.credit_bureau
	, transaction_dim.credit_bureau_code
	, transaction_dim.disclosure_action
	, transaction_dim.disclosure_action_code
	, transaction_dim.doc_level
	, transaction_dim.doc_level_code
	, transaction_dim.effective_property_value_explanation
	, transaction_dim.effective_property_value_explanation_code
	, transaction_dim.effective_property_value_type
	, transaction_dim.effective_property_value_type_code
	, transaction_dim.effective_signing_location_state
	, transaction_dim.effective_signing_location_state_code
	, transaction_dim.fre_ctp_closing_feature
	, transaction_dim.fre_ctp_closing_feature_code
	, transaction_dim.gse_version
	, transaction_dim.gse_version_code
	, transaction_dim.intent_to_proceed
	, transaction_dim.intent_to_proceed_code
	, transaction_dim.orphan_status
	, transaction_dim.orphan_status_code
	, transaction_dim.realty_agent_scenario
	, transaction_dim.realty_agent_scenario_code
	, transaction_dim.rescission_notification
	, transaction_dim.rescission_notification_code
	, transaction_dim.security_instrument
	, transaction_dim.security_instrument_code
	, transaction_dim.transaction_create_type
	, transaction_dim.transaction_create_type_code
	, transaction_dim.transaction_status
	, transaction_dim.transaction_status_code
	, transaction_dim.any_vesting_changes
	, transaction_dim.any_vesting_changes_code
	, transaction_dim.arms_length
	, transaction_dim.arms_length_code
	, transaction_dim.early_first_payment
	, transaction_dim.early_first_payment_code
	, transaction_dim.earthquake_insurance_applicable
	, transaction_dim.earthquake_insurance_applicable_code
	, transaction_dim.flood_insurance_applicable
	, transaction_dim.flood_insurance_applicable_code
	, transaction_dim.hazard_insurance_applicable
	, transaction_dim.hazard_insurance_applicable_code
	, transaction_dim.hud_consultant
	, transaction_dim.hud_consultant_code
	, transaction_dim.mortgagee_builder_seller_relationship
	, transaction_dim.mortgagee_builder_seller_relationship_code
	, transaction_dim.property_acquired_through_ancillary_relief
	, transaction_dim.property_acquired_through_ancillary_relief_code
	, transaction_dim.property_acquired_through_inheritance
	, transaction_dim.property_acquired_through_inheritance_code
	, transaction_dim.separate_transaction_for_land_acquisition
	, transaction_dim.separate_transaction_for_land_acquisition_code
	, transaction_dim.taxes_escrowed
	, transaction_dim.taxes_escrowed_code
	, transaction_dim.vesting_change_titleholder_added
	, transaction_dim.vesting_change_titleholder_added_code
	, transaction_dim.vesting_change_titleholder_name_change
	, transaction_dim.vesting_change_titleholder_name_change_code
	, transaction_dim.vesting_change_titleholder_removed
	, transaction_dim.vesting_change_titleholder_removed_code
	, transaction_dim.windstorm_insurance_applicable
	, transaction_dim.windstorm_insurance_applicable_code
	, transaction_dim.ecoa_application_complete_date::VARCHAR
	, transaction_dim.ecoa_application_received_date::VARCHAR) IS NULL;


UPDATE star_loan.loan_fact
SET edw_modified_datetime = NOW()
  	, cash_out_reason_dwid = COALESCE(cash_out_reason_dim.dwid, 0)
  	, hmda_action_dwid = COALESCE(hmda_action_dim.dwid, 0)
  	, underwrite_dwid = COALESCE(underwrite_dim.dwid, 0)
	, cd_clear_date_dwid = COALESCE(cd_clear_date_dim.dwid, 0)
	, charges_enabled_date_dwid = COALESCE(charges_enabled_date_dim.dwid, 0)
	, effective_earliest_allowed_consummation_date_dwid = COALESCE(effective_earliest_allowed_consummation_date_dim.dwid, 0)
	, effective_hmda_action_date_dwid = COALESCE(effective_hmda_action_date_dim.dwid, 0)
	, effective_note_date_dwid = COALESCE(effective_note_date_dim.dwid, 0)
	, hmda_action_date_dwid = COALESCE(hmda_action_date_dim.dwid, 0)
	, initial_cancel_status_date_dwid = COALESCE(initial_cancel_status_date_dim.dwid, 0)
	, initial_uw_disposition_date_dwid = COALESCE(initial_uw_disposition_date_dim.dwid, 0)
	, initial_uw_submit_date_dwid = COALESCE(initial_uw_submit_date_dim.dwid, 0)
	, note_date_dwid = COALESCE(note_date_dim.dwid, 0)
	, preapproval_uw_submit_date_dwid = COALESCE(preapproval_uw_submit_date_dim.dwid, 0)
	, transaction_create_date_dwid = COALESCE(transaction_create_date_dim.dwid, 0)
	, transaction_welcome_call_date_dwid = COALESCE(transaction_welcome_call_date_dim.dwid, 0)
	, trid_application_date_dwid = COALESCE(trid_application_date_dim.dwid, 0)
	, underwrite_publish_date_dwid = COALESCE(underwrite_publish_date_dim.dwid, 0)
FROM (
    SELECT deal.*
	FROM history_octane.deal
		LEFT JOIN history_octane.deal AS history_records
		    ON deal.d_pid = history_records.d_pid
				AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
	WHERE deal.data_source_deleted_flag IS FALSE
		AND history_records.d_pid IS NULL
) AS deal
	JOIN (
		SELECT proposal.*
		FROM history_octane.proposal
			LEFT JOIN history_octane.proposal AS history_records
			    ON proposal.prp_pid = history_records.prp_pid
					AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE proposal.data_source_deleted_flag IS FALSE
			AND history_records.prp_pid IS NULL
	) AS proposal
		ON deal.d_active_proposal_pid = proposal.prp_pid
	JOIN (
		SELECT application.*
		FROM history_octane.application
			LEFT JOIN history_octane.application AS history_records
			    ON application.apl_pid = history_records.apl_pid
					AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE application.data_source_deleted_flag IS FALSE
			AND history_records.apl_pid IS NULL
	) AS primary_application
		ON proposal.prp_pid = primary_application.apl_proposal_pid
			AND primary_application.apl_primary_application IS TRUE
	JOIN (
		SELECT loan.*
		FROM history_octane.loan
			LEFT JOIN history_octane.loan AS history_records
				ON loan.l_pid = history_records.l_pid
					AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE loan.data_source_deleted_flag IS FALSE
			AND history_records.l_pid IS NULL
	) AS loan
		ON proposal.prp_pid = loan.l_proposal_pid
	LEFT JOIN (
		SELECT cash_out_reason_dim.*
		FROM star_loan.cash_out_reason_dim
	) AS cash_out_reason_dim
		ON proposal.prp_cash_out_reason_business_debt_or_debt_consolidation IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_business_debt_or_debt_consolidation_flag
			AND proposal.prp_cash_out_reason_debt_or_debt_consolidation IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_business_debt_or_debt_consolidation_flag
			AND proposal.prp_cash_out_reason_future_investment_not_under_contract IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_future_investment_not_under_contract_flag
			AND proposal.prp_cash_out_reason_future_investment_under_contract IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_future_investment_under_contract_flag
			AND proposal.prp_cash_out_reason_home_improvement IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_home_improvement_flag
			AND proposal.prp_cash_out_reason_investment_or_business_property IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_investment_or_business_property_flag
			AND proposal.prp_cash_out_reason_other IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_other_flag
			AND proposal.prp_cash_out_reason_personal_use IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_personal_use_flag
			AND proposal.prp_cash_out_reason_student_loans IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_student_loans_flag
			AND proposal.prp_non_business_cash_out_reason_acknowledged IS NOT DISTINCT FROM cash_out_reason_dim.non_business_cash_out_reason_acknowledged_code
			AND cash_out_reason_dim.data_source_dwid = 1
	LEFT JOIN (
		SELECT hmda_action_dim.*
		FROM star_loan.hmda_action_dim
	) AS hmda_action_dim
		ON deal.d_hmda_action_type IS NOT DISTINCT FROM hmda_action_dim.hmda_action_code
			AND deal.d_hmda_denial_reason_type_1 IS NOT DISTINCT FROM hmda_action_dim.hmda_denial_reason_code_1
			AND deal.d_hmda_denial_reason_type_2 IS NOT DISTINCT FROM hmda_action_dim.hmda_denial_reason_code_2
			AND deal.d_hmda_denial_reason_type_3 IS NOT DISTINCT FROM hmda_action_dim.hmda_denial_reason_code_3
			AND deal.d_hmda_denial_reason_type_4 IS NOT DISTINCT FROM hmda_action_dim.hmda_denial_reason_code_4
			AND hmda_action_dim.data_source_dwid = 1
	LEFT JOIN (
		SELECT underwrite_dim.*
		FROM star_loan.underwrite_dim
	) AS underwrite_dim
	    ON proposal.prp_underwrite_disposition_type IS NOT DISTINCT FROM underwrite_dim.underwrite_disposition_code
			AND proposal.prp_underwrite_method_type IS NOT DISTINCT FROM underwrite_dim.underwrite_method_code
			AND proposal.prp_underwrite_risk_assessment_type IS NOT DISTINCT FROM underwrite_dim.underwrite_risk_assessment_code
			AND underwrite_dim.data_source_dwid = 1
	LEFT JOIN star_common.date_dim cd_clear_date_dim
	    ON proposal.prp_cd_clear_date = cd_clear_date_dim.value
	LEFT JOIN star_common.date_dim charges_enabled_date_dim
	    ON deal.d_charges_enabled_date = charges_enabled_date_dim.value
	LEFT JOIN star_common.date_dim effective_earliest_allowed_consummation_date_dim
		ON proposal.prp_effective_earliest_allowed_consummation_date = effective_earliest_allowed_consummation_date_dim.value
	LEFT JOIN star_common.date_dim effective_hmda_action_date_dim
	    ON deal.d_effective_hmda_action_date = effective_hmda_action_date_dim.value
	LEFT JOIN star_common.date_dim effective_note_date_dim
	    ON proposal.prp_effective_note_date = effective_note_date_dim.value
	LEFT JOIN star_common.date_dim hmda_action_date_dim
	    ON deal.d_hmda_action_date = hmda_action_date_dim.value
	LEFT JOIN star_common.date_dim initial_cancel_status_date_dim
	    ON deal.d_initial_cancel_status_date = initial_cancel_status_date_dim.value
	LEFT JOIN star_common.date_dim initial_uw_disposition_date_dim
	    ON DATE(proposal.prp_initial_uw_disposition_datetime) = initial_uw_disposition_date_dim.value
	LEFT JOIN star_common.date_dim initial_uw_submit_date_dim
	    ON DATE(proposal.prp_initial_uw_submit_datetime) = initial_uw_submit_date_dim.value
	LEFT JOIN star_common.date_dim note_date_dim
	    ON proposal.prp_note_date = note_date_dim.value
	LEFT JOIN star_common.date_dim preapproval_uw_submit_date_dim
	    ON DATE(proposal.prp_preapproval_uw_submit_datetime) = preapproval_uw_submit_date_dim.value
	LEFT JOIN star_common.date_dim transaction_create_date_dim
	    ON deal.d_deal_create_date = transaction_create_date_dim.value
	LEFT JOIN star_common.date_dim transaction_welcome_call_date_dim
	    ON DATE(deal.d_welcome_call_datetime) = transaction_welcome_call_date_dim.value
	LEFT JOIN star_common.date_dim trid_application_date_dim
	    ON deal.d_trid_application_date = trid_application_date_dim.value
	LEFT JOIN star_common.date_dim underwrite_publish_date_dim
	    ON proposal.prp_underwrite_publish_date = underwrite_publish_date_dim.value
WHERE loan_fact.loan_pid = loan.l_pid
	AND COALESCE(loan_fact.cash_out_reason_dwid
	    , loan_fact.hmda_action_dwid
	    , loan_fact.underwrite_dwid
		, loan_fact.cd_clear_date_dwid
		, loan_fact.charges_enabled_date_dwid
		, loan_fact.effective_earliest_allowed_consummation_date_dwid
		, loan_fact.effective_hmda_action_date_dwid
		, loan_fact.effective_note_date_dwid
		, loan_fact.hmda_action_date_dwid
		, loan_fact.initial_cancel_status_date_dwid
		, loan_fact.initial_uw_disposition_date_dwid
		, loan_fact.initial_uw_submit_date_dwid
		, loan_fact.note_date_dwid
		, loan_fact.preapproval_uw_submit_date_dwid
		, loan_fact.transaction_create_date_dwid
		, loan_fact.transaction_welcome_call_date_dwid
		, loan_fact.trid_application_date_dwid
		, loan_fact.underwrite_publish_date_dwid) IS NULL;

