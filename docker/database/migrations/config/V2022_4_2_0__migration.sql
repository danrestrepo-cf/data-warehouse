--
-- EDW | Integrate fields from the 'deal' and 'proposal' tables in Octane to the star_loan schema
-- https://app.asana.com/0/0/1201949290096029
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
	VALUES ('staging', 'star_loan', 'cash_out_reason_dim', 'staging', 'history_octane', 'proposal')
		, ('staging', 'star_loan', 'hmda_action_dim', 'staging', 'history_octane', 'deal')
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'staging', 'history_octane', 'deal')
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'staging', 'history_octane', 'deal')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'staging', 'history_octane', 'deal')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'staging', 'history_octane', 'deal')
		, ('staging', 'star_loan', 'underwrite_dim', 'staging', 'history_octane', 'proposal')
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT insert_rows.database_name, insert_rows.schema_name, insert_rows.table_name, source_table_definition.dwid
FROM insert_rows
	LEFT JOIN mdi.edw_table_definition source_table_definition
		ON insert_rows.source_database_name = source_table_definition.database_name
			AND insert_rows.source_schema_name = source_table_definition.schema_name
			AND insert_rows.source_table_name = source_table_definition.table_name;

--edw_field_definition
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
	VALUES ('staging', 'star_loan', 'cash_out_reason_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'hmda_action_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'hmda_action_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'hmda_action_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'hmda_action_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'hmda_action_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'hmda_action_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'hmda_action_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'hmda_action_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'cd_clear_date_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'charges_enabled_date_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'effective_earliest_allowed_consummation_date_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'effective_hmda_action_date_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'effective_note_date_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'hmda_action_date_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'initial_cancel_status_date_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'initial_uw_disposition_date_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'initial_uw_submit_date_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'note_date_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'preapproval_uw_submit_date_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'transaction_create_date_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'transaction_welcome_call_date_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'trid_application_date_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'underwrite_publish_date_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'cash_out_reason_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'hmda_action_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'loan_fact', 'underwrite_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'transaction_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'transaction_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'transaction_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'transaction_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'underwrite_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'underwrite_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'underwrite_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'underwrite_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'underwrite_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'underwrite_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'underwrite_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
		, ('staging', 'star_loan', 'underwrite_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
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
	VALUES ('staging', 'star_loan', 'cash_out_reason_dim', 'cash_out_reason_business_debt_or_debt_consolidation_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_cash_out_reason_business_debt_or_debt_consolidation')
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'cash_out_reason_debt_or_debt_consolidation_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_cash_out_reason_debt_or_debt_consolidation')
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'cash_out_reason_future_investment_not_under_contract_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_cash_out_reason_future_investment_not_under_contract')
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'cash_out_reason_future_investment_under_contract_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_cash_out_reason_future_investment_under_contract')
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'cash_out_reason_home_improvement_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_cash_out_reason_home_improvement')
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'cash_out_reason_investment_or_business_property_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_cash_out_reason_investment_or_business_property')
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'cash_out_reason_other_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_cash_out_reason_other')
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'cash_out_reason_personal_use_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_cash_out_reason_personal_use')
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'cash_out_reason_student_loans_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_cash_out_reason_student_loans')
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'non_business_cash_out_reason_acknowledged', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_na_type', 'value')
		, ('staging', 'star_loan', 'cash_out_reason_dim', 'non_business_cash_out_reason_acknowledged_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_non_business_cash_out_reason_acknowledged')
		, ('staging', 'star_loan', 'hmda_action_dim', 'hmda_action', 'VARCHAR(1024)', 'staging', 'history_octane', 'hmda_action_type', 'value')
		, ('staging', 'star_loan', 'hmda_action_dim', 'hmda_action_code', 'VARCHAR(128)', 'staging', 'history_octane', 'deal', 'd_hmda_action_type')
		, ('staging', 'star_loan', 'hmda_action_dim', 'hmda_denial_reason_1', 'VARCHAR(1024)', 'staging', 'history_octane', 'hmda_denial_reason_type', 'value')
		, ('staging', 'star_loan', 'hmda_action_dim', 'hmda_denial_reason_2', 'VARCHAR(1024)', 'staging', 'history_octane', 'hmda_denial_reason_type', 'value')
		, ('staging', 'star_loan', 'hmda_action_dim', 'hmda_denial_reason_3', 'VARCHAR(1024)', 'staging', 'history_octane', 'hmda_denial_reason_type', 'value')
		, ('staging', 'star_loan', 'hmda_action_dim', 'hmda_denial_reason_4', 'VARCHAR(1024)', 'staging', 'history_octane', 'hmda_denial_reason_type', 'value')
		, ('staging', 'star_loan', 'hmda_action_dim', 'hmda_denial_reason_code_1', 'VARCHAR(128)', 'staging', 'history_octane', 'deal', 'd_hmda_denial_reason_type_1')
		, ('staging', 'star_loan', 'hmda_action_dim', 'hmda_denial_reason_code_2', 'VARCHAR(128)', 'staging', 'history_octane', 'deal', 'd_hmda_denial_reason_type_2')
		, ('staging', 'star_loan', 'hmda_action_dim', 'hmda_denial_reason_code_3', 'VARCHAR(128)', 'staging', 'history_octane', 'deal', 'd_hmda_denial_reason_type_3')
		, ('staging', 'star_loan', 'hmda_action_dim', 'hmda_denial_reason_code_4', 'VARCHAR(128)', 'staging', 'history_octane', 'deal', 'd_hmda_denial_reason_type_4')
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'deal_pid', 'BIGINT', 'staging', 'history_octane', 'deal', 'd_pid')
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'active_proposal_pid', 'BIGINT', 'staging', 'history_octane', 'proposal', 'prp_pid')
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'financed_property_improvements_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_financed_property_improvements')
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'loan_modification_agreement_executed_received_datetime', 'TIMESTAMPTZ', 'staging', 'history_octane', 'proposal', 'prp_loan_modification_agreement_executed_received_datetime')
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'adjusted_as_is_value_amount', 'NUMERIC(15,0)', 'staging', 'history_octane', 'proposal', 'prp_adjusted_as_is_value_amount')
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'after_improved_value_amount', 'NUMERIC(15,0)', 'staging', 'history_octane', 'proposal', 'prp_after_improved_value_amount')
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'construction_borrower_contribution_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_construction_borrower_contribution_amount')
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'estimated_hard_construction_cost_amount', 'BIGINT', 'staging', 'history_octane', 'proposal', 'prp_estimated_hard_construction_cost_amount')
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'cr_tracker_url', 'VARCHAR(1024)', 'staging', 'history_octane', 'proposal', 'prp_cr_tracker_url')
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'construction_lot_ownership_status', 'VARCHAR(1024)', 'staging', 'history_octane', 'construction_lot_ownership_status_type', 'value')
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'construction_lot_ownership_status_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_construction_lot_ownership_status_type')
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'financed_property_improvements_category', 'VARCHAR(1024)', 'staging', 'history_octane', 'financed_property_improvements_category_type', 'value')
		, ('staging', 'star_loan', 'transaction_aux_construction_dim', 'financed_property_improvements_category_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_financed_property_improvements_category_type')
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'deal_pid', 'BIGINT', 'staging', 'history_octane', 'deal', 'd_pid')
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'active_proposal_pid', 'BIGINT', 'staging', 'history_octane', 'proposal', 'prp_pid')
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'any_disaster_declaration_after_appraisal_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_any_disaster_declaration_after_appraisal')
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'any_disaster_declaration_before_appraisal_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_any_disaster_declaration_before_appraisal')
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'any_disaster_declaration_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_any_disaster_declaration')
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'disaster_declaration_check_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_disaster_declaration_check_date')
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'disaster_declaration_check_date_type', 'VARCHAR(1024)', 'staging', 'history_octane', 'disaster_declaration_check_date_type', 'value')
		, ('staging', 'star_loan', 'transaction_aux_disaster_declaration_dim', 'disaster_declaration_check_date_type_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_disaster_declaration_check_date_type')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'deal_pid', 'BIGINT', 'staging', 'history_octane', 'deal', 'd_pid')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'active_proposal_pid', 'BIGINT', 'staging', 'history_octane', 'proposal', 'prp_pid')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'fha_mip_refund_request_input_error_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_fha_mip_refund_request_input_error')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'fha_non_arms_length_ltv_exception_verified_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_fha_non_arms_length_ltv_exception_verified')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'request_fha_mip_refund_required_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_request_fha_mip_refund_required')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'texas_equity_conversion_determination_datetime_override_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_texas_equity_conversion_determination_datetime_override')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'texas_equity_determination_datetime_override_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_texas_equity_determination_datetime_override')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_maintenance_utilities_auto_compute_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_va_maintenance_utilities_auto_compute')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'fha_prior_agency_case_endorsement_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_fha_prior_agency_case_endorsement_date')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'fha_refinance_authorization_expiration_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_fha_refinance_authorization_expiration_date')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'texas_equity_determination_datetime', 'TIMESTAMPTZ', 'staging', 'history_octane', 'proposal', 'prp_texas_equity_determination_datetime')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'usda_gsa_sam_checked_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_usda_gsa_sam_checked_date')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_notice_of_value_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_va_notice_of_value_date')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'cema_borrower_savings', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_cema_borrower_savings')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'fha_va_reasonable_value_amount', 'NUMERIC(15,0)', 'staging', 'history_octane', 'proposal', 'prp_fha_va_reasonable_value_amount')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_actual_guaranty_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_va_actual_guaranty_amount')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_amount_used_to_calculate_maximum_guaranty', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_va_amount_used_to_calculate_maximum_guaranty')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_energy_efficient_improvements_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_va_energy_efficient_improvements_amount')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_guaranty_percent', 'NUMERIC(11,9)', 'staging', 'history_octane', 'proposal', 'prp_va_guaranty_percent')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_maintenance_utilities_per_square_feet_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_va_maintenance_utilities_per_square_feet_amount')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_maximum_base_loan_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_va_maximum_base_loan_amount')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_maximum_funding_fee_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_va_maximum_funding_fee_amount')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_maximum_total_loan_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_va_maximum_total_loan_amount')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_monthly_maintenance_utilities_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_va_monthly_maintenance_utilities_amount')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_notice_of_value_estimated_reasonable_value_amount', 'NUMERIC(15,0)', 'staging', 'history_octane', 'proposal', 'prp_va_notice_of_value_estimated_reasonable_value_amount')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_required_cash_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_va_required_cash_amount')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_required_guaranty_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_va_required_guaranty_amount')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'fha_prior_agency_case_id', 'VARCHAR(32)', 'staging', 'history_octane', 'proposal', 'prp_fha_prior_agency_case_id')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'fha_refinance_authorization_number', 'VARCHAR(16)', 'staging', 'history_octane', 'proposal', 'prp_fha_refinance_authorization_number')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'fhac_refinance_authorization_messages', 'TEXT', 'staging', 'history_octane', 'proposal', 'prp_fhac_refinance_authorization_messages')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'texas_equity_conversion_determ_datetime_override_reason', 'TEXT', 'staging', 'history_octane', 'proposal', 'prp_texas_equity_conversion_determ_datetime_override_reason')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'texas_equity_determination_datetime_override_reason', 'TEXT', 'staging', 'history_octane', 'proposal', 'prp_texas_equity_determination_datetime_override_reason')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_prior_paid_in_full_loan_number', 'VARCHAR(32)', 'staging', 'history_octane', 'proposal', 'prp_va_prior_paid_in_full_loan_number')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'fha_non_arms_length_ltv_exception', 'VARCHAR(1024)', 'staging', 'history_octane', 'fha_non_arms_length_ltv_limit_exception_type', 'value')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'fha_non_arms_length_ltv_exception_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_fha_non_arms_length_ltv_exception_type')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'hud_fha_de_approval', 'VARCHAR(1024)', 'staging', 'history_octane', 'hud_fha_de_approval_type', 'value')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'hud_fha_de_approval_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_hud_fha_de_approval_type')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'usda_rd_single_family_housing', 'VARCHAR(1024)', 'staging', 'history_octane', 'usda_rd_single_family_housing_type', 'value')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'usda_rd_single_family_housing_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_usda_rd_single_family_housing_type')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_notice_of_value_source', 'VARCHAR(1024)', 'staging', 'history_octane', 'va_notice_of_value_source_type', 'value')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_notice_of_value_source_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_va_notice_of_value_source_type')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_past_credit_record', 'VARCHAR(1024)', 'staging', 'history_octane', 'va_past_credit_record_type', 'value')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_past_credit_record_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_va_past_credit_record_type')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'cema', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_na_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'cema_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_cema')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'fha_eligible_maximum_financing', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'fha_eligible_maximum_financing_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_fha_eligible_maximum_financing')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'usda_gsa_sam_exclusion', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'usda_gsa_sam_exclusion_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_usda_gsa_sam_exclusion')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_meets_credit_standards', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_meets_credit_standards_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_va_meets_credit_standards')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_monthly_utilities_included', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_aux_govt_programs_dim', 'va_monthly_utilities_included_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_va_monthly_utilities_included')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'deal_pid', 'BIGINT', 'staging', 'history_octane', 'deal', 'd_pid')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'active_proposal_pid', 'BIGINT', 'staging', 'history_octane', 'proposal', 'prp_pid')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'property_repairs_completed_notification_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_property_repairs_completed_notification_date')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'property_repairs_funds_released_contractor_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_property_repairs_funds_released_contractor_date')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'property_repairs_holdback_required_completion_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_property_repairs_holdback_required_completion_date')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'property_repairs_inspection_completed_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_property_repairs_inspection_completed_date')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'property_repairs_inspection_ordered_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_property_repairs_inspection_ordered_date')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'property_repairs_cost_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_property_repairs_cost_amount')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'property_repairs_holdback_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_property_repairs_holdback_amount')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'property_repairs_description', 'VARCHAR(1024)', 'staging', 'history_octane', 'proposal', 'prp_property_repairs_description')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'property_repairs_holdback_administrator', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_property_repairs_holdback_administrator')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'property_repairs_holdback_calc', 'VARCHAR(1024)', 'staging', 'history_octane', 'property_repairs_holdback_calc_type', 'value')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'property_repairs_holdback_calc_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_property_repairs_holdback_calc_type')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'property_repairs_holdback_payer', 'VARCHAR(1024)', 'staging', 'history_octane', 'property_repairs_holdback_payer_type', 'value')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'property_repairs_holdback_payer_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_property_repairs_holdback_payer_type')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'property_repairs_required', 'VARCHAR(1024)', 'staging', 'history_octane', 'property_repairs_required_type', 'value')
		, ('staging', 'star_loan', 'transaction_aux_property_repairs_dim', 'property_repairs_required_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_property_repairs_required_type')
		, ('staging', 'star_loan', 'transaction_dim', 'borrower_esign_flag', 'BOOLEAN', 'staging', 'history_octane', 'deal', 'd_borrower_esign')
		, ('staging', 'star_loan', 'transaction_dim', 'deed_taxes_applicable_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_deed_taxes_applicable')
		, ('staging', 'star_loan', 'transaction_dim', 'deed_taxes_auto_compute_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_deed_taxes_auto_compute')
		, ('staging', 'star_loan', 'transaction_dim', 'delayed_financing_exception_guidelines_applicable_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_delayed_financing_exception_guidelines_applicable')
		, ('staging', 'star_loan', 'transaction_dim', 'delayed_financing_exception_verified_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_delayed_financing_exception_verified')
		, ('staging', 'star_loan', 'transaction_dim', 'down_payment_percent_mode_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_down_payment_percent_mode')
		, ('staging', 'star_loan', 'transaction_dim', 'early_wire_request_flag', 'BOOLEAN', 'staging', 'history_octane', 'deal', 'd_early_wire_request')
		, ('staging', 'star_loan', 'transaction_dim', 'enable_electronic_transaction_flag', 'BOOLEAN', 'staging', 'history_octane', 'deal', 'd_enable_electronic_transaction')
		, ('staging', 'star_loan', 'transaction_dim', 'escrow_cushion_months_auto_compute_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_escrow_cushion_months_auto_compute')
		, ('staging', 'star_loan', 'transaction_dim', 'first_payment_date_auto_compute_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_first_payment_date_auto_compute')
		, ('staging', 'star_loan', 'transaction_dim', 'household_income_exclusive_edit_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_household_income_exclusive_edit')
		, ('staging', 'star_loan', 'transaction_dim', 'intent_to_proceed_provided_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_intent_to_proceed_provided')
		, ('staging', 'star_loan', 'transaction_dim', 'invoices_enabled_flag', 'BOOLEAN', 'staging', 'history_octane', 'deal', 'd_invoices_enabled')
		, ('staging', 'star_loan', 'transaction_dim', 'ipc_auto_compute_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_ipc_auto_compute')
		, ('staging', 'star_loan', 'transaction_dim', 'minimum_residual_income_auto_compute_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_minimum_residual_income_auto_compute')
		, ('staging', 'star_loan', 'transaction_dim', 'other_lender_requires_appraisal_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_other_lender_requires_appraisal')
		, ('staging', 'star_loan', 'transaction_dim', 'owner_occupancy_not_required_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_owner_occupancy_not_required')
		, ('staging', 'star_loan', 'transaction_dim', 'property_taxes_request_input_error_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_property_taxes_request_input_error')
		, ('staging', 'star_loan', 'transaction_dim', 'publish_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_publish')
		, ('staging', 'star_loan', 'transaction_dim', 'recording_fees_request_input_error_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_recording_fees_request_input_error')
		, ('staging', 'star_loan', 'transaction_dim', 'request_property_taxes_required_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_request_property_taxes_required')
		, ('staging', 'star_loan', 'transaction_dim', 'request_recording_fees_required_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_request_recording_fees_required')
		, ('staging', 'star_loan', 'transaction_dim', 'rescission_applicable_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_rescission_applicable')
		, ('staging', 'star_loan', 'transaction_dim', 'reserves_auto_compute_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_reserves_auto_compute')
		, ('staging', 'star_loan', 'transaction_dim', 'sap_deal_flag', 'BOOLEAN', 'staging', 'history_octane', 'deal', 'd_sap_deal')
		, ('staging', 'star_loan', 'transaction_dim', 'sar_significant_adjustments_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_sar_significant_adjustments')
		, ('staging', 'star_loan', 'transaction_dim', 'smart_charges_enabled_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_smart_charges_enabled')
		, ('staging', 'star_loan', 'transaction_dim', 'smart_docs_enabled_flag', 'BOOLEAN', 'staging', 'history_octane', 'proposal', 'prp_smart_docs_enabled')
		, ('staging', 'star_loan', 'transaction_dim', 'training_loan_flag', 'BOOLEAN', 'staging', 'history_octane', 'deal', 'd_training_loan')
		, ('staging', 'star_loan', 'transaction_dim', 'active_proposal_publish_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_publish_date')
		, ('staging', 'star_loan', 'transaction_dim', 'calculated_earliest_allowed_consummation_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_calculated_earliest_allowed_consummation_date')
		, ('staging', 'star_loan', 'transaction_dim', 'charges_updated_datetime', 'TIMESTAMPTZ', 'staging', 'history_octane', 'proposal', 'prp_charges_updated_datetime')
		, ('staging', 'star_loan', 'transaction_dim', 'closing_document_sign_datetime', 'TIMESTAMPTZ', 'staging', 'history_octane', 'proposal', 'prp_closing_document_sign_datetime')
		, ('staging', 'star_loan', 'transaction_dim', 'docs_enabled_datetime', 'TIMESTAMPTZ', 'staging', 'history_octane', 'proposal', 'prp_docs_enabled_datetime')
		, ('staging', 'star_loan', 'transaction_dim', 'ecoa_application_complete_date', 'DATE', 'staging', 'history_octane', 'deal', 'd_ecoa_application_complete_date')
		, ('staging', 'star_loan', 'transaction_dim', 'ecoa_application_received_date', 'DATE', 'staging', 'history_octane', 'deal', 'd_ecoa_application_received_date')
		, ('staging', 'star_loan', 'transaction_dim', 'ecoa_decision_due_date', 'DATE', 'staging', 'history_octane', 'deal', 'd_ecoa_decision_due_date')
		, ('staging', 'star_loan', 'transaction_dim', 'ecoa_notice_of_incomplete_date', 'DATE', 'staging', 'history_octane', 'deal', 'd_ecoa_notice_of_incomplete_date')
		, ('staging', 'star_loan', 'transaction_dim', 'ecoa_notice_of_incomplete_due_date', 'DATE', 'staging', 'history_octane', 'deal', 'd_ecoa_notice_of_incomplete_due_date')
		, ('staging', 'star_loan', 'transaction_dim', 'effective_earliest_allowed_consummation_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_effective_earliest_allowed_consummation_date')
		, ('staging', 'star_loan', 'transaction_dim', 'first_payment_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_first_payment_date')
		, ('staging', 'star_loan', 'transaction_dim', 'fre_ctp_first_payment_due_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_fre_ctp_first_payment_due_date')
		, ('staging', 'star_loan', 'transaction_dim', 'gfe_interest_rate_expiration_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_gfe_interest_rate_expiration_date')
		, ('staging', 'star_loan', 'transaction_dim', 'initial_uw_disposition_datetime', 'TIMESTAMPTZ', 'staging', 'history_octane', 'proposal', 'prp_initial_uw_disposition_datetime')
		, ('staging', 'star_loan', 'transaction_dim', 'initial_uw_submit_datetime', 'TIMESTAMPTZ', 'staging', 'history_octane', 'proposal', 'prp_initial_uw_submit_datetime')
		, ('staging', 'star_loan', 'transaction_dim', 'invoices_enabled_date', 'DATE', 'staging', 'history_octane', 'deal', 'd_invoices_enabled_date')
		, ('staging', 'star_loan', 'transaction_dim', 'land_acquisition_transaction_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_land_acquisition_transaction_date')
		, ('staging', 'star_loan', 'transaction_dim', 'last_corrective_disclosure_processed_datetime', 'TIMESTAMPTZ', 'staging', 'history_octane', 'proposal', 'prp_last_corrective_disclosure_processed_datetime')
		, ('staging', 'star_loan', 'transaction_dim', 'last_requested_disclosure_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_last_requested_disclosure_date')
		, ('staging', 'star_loan', 'transaction_dim', 'lender_escrow_loan_due_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_lender_escrow_loan_due_date')
		, ('staging', 'star_loan', 'transaction_dim', 'overridden_earliest_allowed_consummation_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_overridden_earliest_allowed_consummation_date')
		, ('staging', 'star_loan', 'transaction_dim', 'preapproval_uw_disposition_datetime', 'TIMESTAMPTZ', 'staging', 'history_octane', 'proposal', 'prp_preapproval_uw_disposition_datetime')
		, ('staging', 'star_loan', 'transaction_dim', 'preapproval_uw_submit_datetime', 'TIMESTAMPTZ', 'staging', 'history_octane', 'proposal', 'prp_preapproval_uw_submit_datetime')
		, ('staging', 'star_loan', 'transaction_dim', 'proposal_expiration_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_proposal_expiration_date')
		, ('staging', 'star_loan', 'transaction_dim', 'purchase_contract_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_purchase_contract_date')
		, ('staging', 'star_loan', 'transaction_dim', 'purchase_contract_financing_contingency_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_purchase_contract_financing_contingency_date')
		, ('staging', 'star_loan', 'transaction_dim', 'purchase_contract_funding_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_purchase_contract_funding_date')
		, ('staging', 'star_loan', 'transaction_dim', 'purchase_contract_received_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_purchase_contract_received_date')
		, ('staging', 'star_loan', 'transaction_dim', 'rescission_effective_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_rescission_effective_date')
		, ('staging', 'star_loan', 'transaction_dim', 'rescission_notification_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_rescission_notification_date')
		, ('staging', 'star_loan', 'transaction_dim', 'rescission_through_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_rescission_through_date')
		, ('staging', 'star_loan', 'transaction_dim', 'scheduled_closing_document_sign_datetime', 'TIMESTAMPTZ', 'staging', 'history_octane', 'proposal', 'prp_scheduled_closing_document_sign_datetime')
		, ('staging', 'star_loan', 'transaction_dim', 'signed_closing_doc_received_datetime', 'TIMESTAMPTZ', 'staging', 'history_octane', 'proposal', 'prp_signed_closing_doc_received_datetime')
		, ('staging', 'star_loan', 'transaction_dim', 'transaction_deal_create_datetime', 'TIMESTAMPTZ', 'staging', 'history_octane', 'deal', 'd_deal_create_date_time')
		, ('staging', 'star_loan', 'transaction_dim', 'transaction_orphan_earliest_check_date', 'DATE', 'staging', 'history_octane', 'deal', 'd_deal_orphan_earliest_check_date')
		, ('staging', 'star_loan', 'transaction_dim', 'transaction_proposal_create_datetime', 'TIMESTAMPTZ', 'staging', 'history_octane', 'proposal', 'prp_create_datetime')
		, ('staging', 'star_loan', 'transaction_dim', 'transaction_status_date', 'DATE', 'staging', 'history_octane', 'deal', 'd_deal_status_date')
		, ('staging', 'star_loan', 'transaction_dim', 'transaction_welcome_call_datetime', 'TIMESTAMPTZ', 'staging', 'history_octane', 'deal', 'd_welcome_call_datetime')
		, ('staging', 'star_loan', 'transaction_dim', 'underwrite_expiration_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_underwrite_expiration_date')
		, ('staging', 'star_loan', 'transaction_dim', 'user_entered_note_date', 'DATE', 'staging', 'history_octane', 'proposal', 'prp_user_entered_note_date')
		, ('staging', 'star_loan', 'transaction_dim', 'anti_steering_lowest_cost_option_fee_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_anti_steering_lowest_cost_option_fee_amount')
		, ('staging', 'star_loan', 'transaction_dim', 'anti_steering_lowest_cost_option_rate_percent', 'NUMERIC(11,9)', 'staging', 'history_octane', 'proposal', 'prp_anti_steering_lowest_cost_option_rate_percent')
		, ('staging', 'star_loan', 'transaction_dim', 'anti_steering_lowest_rate_option_fee_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_anti_steering_lowest_rate_option_fee_amount')
		, ('staging', 'star_loan', 'transaction_dim', 'anti_steering_lowest_rate_option_rate_percent', 'NUMERIC(11,9)', 'staging', 'history_octane', 'proposal', 'prp_anti_steering_lowest_rate_option_rate_percent')
		, ('staging', 'star_loan', 'transaction_dim', 'anti_steering_lowest_rate_wo_neg_option_fee_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_anti_steering_lowest_rate_wo_neg_option_fee_amount')
		, ('staging', 'star_loan', 'transaction_dim', 'anti_steering_lowest_rate_wo_neg_option_rate_percent', 'NUMERIC(11,9)', 'staging', 'history_octane', 'proposal', 'prp_anti_steering_lowest_rate_wo_neg_option_rate_percent')
		, ('staging', 'star_loan', 'transaction_dim', 'area_median_income', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_area_median_income')
		, ('staging', 'star_loan', 'transaction_dim', 'decision_appraised_value_amount', 'NUMERIC(15,0)', 'staging', 'history_octane', 'proposal', 'prp_decision_appraised_value_amount')
		, ('staging', 'star_loan', 'transaction_dim', 'decision_credit_score', 'INTEGER', 'staging', 'history_octane', 'proposal', 'prp_decision_credit_score')
		, ('staging', 'star_loan', 'transaction_dim', 'down_payment_percent', 'NUMERIC(11,9)', 'staging', 'history_octane', 'proposal', 'prp_down_payment_percent')
		, ('staging', 'star_loan', 'transaction_dim', 'effective_credit_score', 'INTEGER', 'staging', 'history_octane', 'proposal', 'prp_effective_credit_score')
		, ('staging', 'star_loan', 'transaction_dim', 'effective_property_value_amount', 'NUMERIC(15,0)', 'staging', 'history_octane', 'proposal', 'prp_effective_property_value_amount')
		, ('staging', 'star_loan', 'transaction_dim', 'escrow_cushion_months', 'INTEGER', 'staging', 'history_octane', 'proposal', 'prp_escrow_cushion_months')
		, ('staging', 'star_loan', 'transaction_dim', 'estimated_credit_score', 'INTEGER', 'staging', 'history_octane', 'proposal', 'prp_estimated_credit_score')
		, ('staging', 'star_loan', 'transaction_dim', 'estimated_property_value_amount', 'NUMERIC(15,0)', 'staging', 'history_octane', 'proposal', 'prp_estimated_property_value_amount')
		, ('staging', 'star_loan', 'transaction_dim', 'gfe_lock_before_settlement_days', 'INTEGER', 'staging', 'history_octane', 'proposal', 'prp_gfe_lock_before_settlement_days')
		, ('staging', 'star_loan', 'transaction_dim', 'gfe_lock_duration_days', 'INTEGER', 'staging', 'history_octane', 'proposal', 'prp_gfe_lock_duration_days')
		, ('staging', 'star_loan', 'transaction_dim', 'household_size_count', 'INTEGER', 'staging', 'history_octane', 'proposal', 'prp_household_size_count')
		, ('staging', 'star_loan', 'transaction_dim', 'ipc_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_ipc_amount')
		, ('staging', 'star_loan', 'transaction_dim', 'ipc_financing_concession_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_ipc_financing_concession_amount')
		, ('staging', 'star_loan', 'transaction_dim', 'ipc_limit_percent', 'NUMERIC(11,9)', 'staging', 'history_octane', 'proposal', 'prp_ipc_limit_percent')
		, ('staging', 'star_loan', 'transaction_dim', 'ipc_maximum_amount_allowed', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_ipc_maximum_amount_allowed')
		, ('staging', 'star_loan', 'transaction_dim', 'ipc_non_cash_concession_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_ipc_non_cash_concession_amount')
		, ('staging', 'star_loan', 'transaction_dim', 'ipc_percent', 'NUMERIC(11,9)', 'staging', 'history_octane', 'proposal', 'prp_ipc_percent')
		, ('staging', 'star_loan', 'transaction_dim', 'land_acquisition_price', 'NUMERIC(15,0)', 'staging', 'history_octane', 'proposal', 'prp_land_acquisition_price')
		, ('staging', 'star_loan', 'transaction_dim', 'lender_escrow_loan_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_lender_escrow_loan_amount')
		, ('staging', 'star_loan', 'transaction_dim', 'minimum_household_income_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_minimum_household_income_amount')
		, ('staging', 'star_loan', 'transaction_dim', 'minimum_residual_income_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_minimum_residual_income_amount')
		, ('staging', 'star_loan', 'transaction_dim', 'proposed_additional_monthly_payment', 'NUMERIC(17,2)', 'staging', 'history_octane', 'proposal', 'prp_proposed_additional_monthly_payment')
		, ('staging', 'star_loan', 'transaction_dim', 'reserves_amount', 'NUMERIC(15,2)', 'staging', 'history_octane', 'proposal', 'prp_reserves_amount')
		, ('staging', 'star_loan', 'transaction_dim', 'reserves_months', 'INTEGER', 'staging', 'history_octane', 'proposal', 'prp_reserves_months')
		, ('staging', 'star_loan', 'transaction_dim', 'sale_price_amount', 'NUMERIC(15,0)', 'staging', 'history_octane', 'proposal', 'prp_sale_price_amount')
		, ('staging', 'star_loan', 'transaction_dim', 'term_borrower_intends_to_retain_property', 'INTEGER', 'staging', 'history_octane', 'proposal', 'prp_term_borrower_intends_to_retain_property')
		, ('staging', 'star_loan', 'transaction_dim', 'total_income_to_ami_ratio', 'NUMERIC(14,9)', 'staging', 'history_octane', 'proposal', 'prp_total_income_to_ami_ratio')
		, ('staging', 'star_loan', 'transaction_dim', 'active_proposal_description', 'VARCHAR(256)', 'staging', 'history_octane', 'proposal', 'prp_description')
		, ('staging', 'star_loan', 'transaction_dim', 'active_proposal_name', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_name')
		, ('staging', 'star_loan', 'transaction_dim', 'calyx_loan_guid', 'NUMERIC(128)', 'staging', 'history_octane', 'deal', 'd_calyx_loan_guid')
		, ('staging', 'star_loan', 'transaction_dim', 'cash_out_reason_other_text', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_cash_out_reason_other_text')
		, ('staging', 'star_loan', 'transaction_dim', 'copy_source_los_loan_id_main', 'BIGINT', 'staging', 'history_octane', 'deal', 'd_copy_source_los_loan_id_main')
		, ('staging', 'star_loan', 'transaction_dim', 'copy_source_los_loan_id_piggyback', 'BIGINT', 'staging', 'history_octane', 'deal', 'd_copy_source_los_loan_id_piggyback')
		, ('staging', 'star_loan', 'transaction_dim', 'deed_taxes_applicable_explanation', 'VARCHAR(1024)', 'staging', 'history_octane', 'proposal', 'prp_deed_taxes_applicable_explanation')
		, ('staging', 'star_loan', 'transaction_dim', 'deed_taxes_auto_compute_override_reason', 'VARCHAR(1024)', 'staging', 'history_octane', 'proposal', 'prp_deed_taxes_auto_compute_override_reason')
		, ('staging', 'star_loan', 'transaction_dim', 'earliest_allowed_consummation_date_override_reason', 'TEXT', 'staging', 'history_octane', 'proposal', 'prp_earliest_allowed_consummation_date_override_reason')
		, ('staging', 'star_loan', 'transaction_dim', 'effective_signing_location_city', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_effective_signing_location_city')
		, ('staging', 'star_loan', 'transaction_dim', 'external_loan_id_main', 'VARCHAR(32)', 'staging', 'history_octane', 'deal', 'd_external_loan_id_main')
		, ('staging', 'star_loan', 'transaction_dim', 'external_loan_id_piggyback', 'VARCHAR(32)', 'staging', 'history_octane', 'deal', 'd_external_loan_id_piggyback')
		, ('staging', 'star_loan', 'transaction_dim', 'hmda_denial_reason_other_description', 'VARCHAR(255)', 'staging', 'history_octane', 'deal', 'd_hmda_denial_reason_other_description')
		, ('staging', 'star_loan', 'transaction_dim', 'hmda_universal_loan_id_main', 'VARCHAR(45)', 'staging', 'history_octane', 'deal', 'd_hmda_universal_loan_id_main')
		, ('staging', 'star_loan', 'transaction_dim', 'hmda_universal_loan_id_piggyback', 'VARCHAR(45)', 'staging', 'history_octane', 'deal', 'd_hmda_universal_loan_id_piggyback')
		, ('staging', 'star_loan', 'transaction_dim', 'intent_to_proceed_obtainer_unparsed_name', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_intent_to_proceed_obtainer_unparsed_name')
		, ('staging', 'star_loan', 'transaction_dim', 'intent_to_proceed_provider_unparsed_name', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_intent_to_proceed_provider_unparsed_name')
		, ('staging', 'star_loan', 'transaction_dim', 'lead_reference_id', 'VARCHAR(256)', 'staging', 'history_octane', 'deal', 'd_lead_reference_id')
		, ('staging', 'star_loan', 'transaction_dim', 'lead_tracking_id', 'VARCHAR(256)', 'staging', 'history_octane', 'deal', 'd_lead_tracking_id')
		, ('staging', 'star_loan', 'transaction_dim', 'lead_zillow_zq', 'VARCHAR(256)', 'staging', 'history_octane', 'deal', 'd_lead_zillow_zq')
		, ('staging', 'star_loan', 'transaction_dim', 'los_loan_number_main', 'BIGINT', 'staging', 'history_octane', 'deal', 'd_los_loan_id_main')
		, ('staging', 'star_loan', 'transaction_dim', 'los_loan_number_piggyback', 'BIGINT', 'staging', 'history_octane', 'deal', 'd_los_loan_id_piggyback')
		, ('staging', 'star_loan', 'transaction_dim', 'mers_min_main', 'VARCHAR(20)', 'staging', 'history_octane', 'deal', 'd_mers_min_main')
		, ('staging', 'star_loan', 'transaction_dim', 'mers_min_piggyback', 'VARCHAR(20)', 'staging', 'history_octane', 'deal', 'd_mers_min_piggyback')
		, ('staging', 'star_loan', 'transaction_dim', 'other_lender_requires_appraisal_reason', 'TEXT', 'staging', 'history_octane', 'proposal', 'prp_other_lender_requires_appraisal_reason')
		, ('staging', 'star_loan', 'transaction_dim', 'property_tax_request_error_messages', 'TEXT', 'staging', 'history_octane', 'proposal', 'prp_property_tax_request_error_messages')
		, ('staging', 'star_loan', 'transaction_dim', 'recsission_notication_by', 'VARCHAR(256)', 'staging', 'history_octane', 'proposal', 'prp_rescission_notification_by')
		, ('staging', 'star_loan', 'transaction_dim', 'referred_by_name', 'VARCHAR(128)', 'staging', 'history_octane', 'deal', 'd_referred_by_name')
		, ('staging', 'star_loan', 'transaction_dim', 'trustee_address_city', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_trustee_address_city')
		, ('staging', 'star_loan', 'transaction_dim', 'trustee_address_country', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_trustee_address_country')
		, ('staging', 'star_loan', 'transaction_dim', 'trustee_address_postal_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_trustee_address_postal_code')
		, ('staging', 'star_loan', 'transaction_dim', 'trustee_address_state', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_trustee_address_state')
		, ('staging', 'star_loan', 'transaction_dim', 'trustee_address_street1', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_trustee_address_street1')
		, ('staging', 'star_loan', 'transaction_dim', 'trustee_address_street2', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_trustee_address_street2')
		, ('staging', 'star_loan', 'transaction_dim', 'trustee_mers_org_id', 'VARCHAR(7)', 'staging', 'history_octane', 'proposal', 'prp_trustee_mers_org_id')
		, ('staging', 'star_loan', 'transaction_dim', 'trustee_name', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_trustee_name')
		, ('staging', 'star_loan', 'transaction_dim', 'trustee_phone_number', 'VARCHAR(32)', 'staging', 'history_octane', 'proposal', 'prp_trustee_phone_number')
		, ('staging', 'star_loan', 'transaction_dim', 'underwrite_disposition_note', 'VARCHAR(1024)', 'staging', 'history_octane', 'proposal', 'prp_underwrite_disposition_note')
		, ('staging', 'star_loan', 'transaction_dim', 'underwriting_comments', 'VARCHAR(1024)', 'staging', 'history_octane', 'proposal', 'prp_underwriting_comments')
		, ('staging', 'star_loan', 'transaction_dim', 'uuts_master_contact_name', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_uuts_master_contact_name')
		, ('staging', 'star_loan', 'transaction_dim', 'uuts_master_contact_title', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_uuts_master_contact_title')
		, ('staging', 'star_loan', 'transaction_dim', 'uuts_master_office_phone', 'VARCHAR(32)', 'staging', 'history_octane', 'proposal', 'prp_uuts_master_office_phone')
		, ('staging', 'star_loan', 'transaction_dim', 'uuts_master_office_phone_extension', 'VARCHAR(16)', 'staging', 'history_octane', 'proposal', 'prp_uuts_master_office_phone_extension')
		, ('staging', 'star_loan', 'transaction_dim', 'velocify_lead_id', 'VARCHAR(32)', 'staging', 'history_octane', 'deal', 'd_velocify_lead_id')
		, ('staging', 'star_loan', 'transaction_dim', 'active_proposal_type', 'VARCHAR(1024)', 'staging', 'history_octane', 'proposal_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'active_proposal_type_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_proposal_type')
		, ('staging', 'star_loan', 'transaction_dim', 'application_type', 'VARCHAR(1024)', 'staging', 'history_octane', 'application_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'application_type_code', 'VARCHAR(128)', 'staging', 'history_octane', 'deal', 'd_application_type')
		, ('staging', 'star_loan', 'transaction_dim', 'credit_bureau', 'VARCHAR(1024)', 'staging', 'history_octane', 'credit_bureau_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'credit_bureau_code', 'VARCHAR(128)', 'staging', 'history_octane', 'deal', 'd_credit_bureau_type')
		, ('staging', 'star_loan', 'transaction_dim', 'disclosure_action', 'VARCHAR(1024)', 'staging', 'history_octane', 'disclosure_action_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'disclosure_action_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_disclosure_action_type')
		, ('staging', 'star_loan', 'transaction_dim', 'doc_level', 'VARCHAR(1024)', 'staging', 'history_octane', 'doc_level_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'doc_level_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_doc_level_type')
		, ('staging', 'star_loan', 'transaction_dim', 'effective_property_value_explanation', 'VARCHAR(1024)', 'staging', 'history_octane', 'effective_property_value_explanation_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'effective_property_value_explanation_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_effective_property_value_explanation_type')
		, ('staging', 'star_loan', 'transaction_dim', 'effective_property_value_type', 'VARCHAR(1024)', 'staging', 'history_octane', 'effective_property_value_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'effective_property_value_type_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_effective_property_value_type')
		, ('staging', 'star_loan', 'transaction_dim', 'effective_signing_location_state', 'VARCHAR(1024)', 'staging', 'history_octane', 'state_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'effective_signing_location_state_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_effective_signing_location_state')
		, ('staging', 'star_loan', 'transaction_dim', 'fre_ctp_closing_feature', 'VARCHAR(1024)', 'staging', 'history_octane', 'fre_ctp_closing_feature_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'fre_ctp_closing_feature_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_fre_ctp_closing_feature_type')
		, ('staging', 'star_loan', 'transaction_dim', 'gse_version', 'VARCHAR(1024)', 'staging', 'history_octane', 'gse_version_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'gse_version_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_gse_version_type')
		, ('staging', 'star_loan', 'transaction_dim', 'intent_to_proceed', 'VARCHAR(1024)', 'staging', 'history_octane', 'intent_to_proceed_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'intent_to_proceed_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_intent_to_proceed_type')
		, ('staging', 'star_loan', 'transaction_dim', 'orphan_status', 'VARCHAR(1024)', 'staging', 'history_octane', 'deal_orphan_status_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'orphan_status_code', 'VARCHAR(128)', 'staging', 'history_octane', 'deal', 'd_deal_orphan_status_type')
		, ('staging', 'star_loan', 'transaction_dim', 'realty_agent_scenario', 'VARCHAR(1024)', 'staging', 'history_octane', 'realty_agent_scenario_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'realty_agent_scenario_code', 'VARCHAR(128)', 'staging', 'history_octane', 'deal', 'd_realty_agent_scenario_type')
		, ('staging', 'star_loan', 'transaction_dim', 'rescission_notification', 'VARCHAR(1024)', 'staging', 'history_octane', 'rescission_notification_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'rescission_notification_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_rescission_notification_type')
		, ('staging', 'star_loan', 'transaction_dim', 'security_instrument', 'VARCHAR(1024)', 'staging', 'history_octane', 'security_instrument_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'security_instrument_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_security_instrument_type')
		, ('staging', 'star_loan', 'transaction_dim', 'transaction_create_type', 'VARCHAR(1024)', 'staging', 'history_octane', 'deal_create_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'transaction_create_type_code', 'VARCHAR(128)', 'staging', 'history_octane', 'deal', 'd_deal_create_type')
		, ('staging', 'star_loan', 'transaction_dim', 'transaction_status', 'VARCHAR(1024)', 'staging', 'history_octane', 'deal_status_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'transaction_status_code', 'VARCHAR(128)', 'staging', 'history_octane', 'deal', 'd_deal_status_type')
		, ('staging', 'star_loan', 'transaction_dim', 'any_vesting_changes', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'any_vesting_changes_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_any_vesting_changes')
		, ('staging', 'star_loan', 'transaction_dim', 'arms_length', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'arms_length_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_arms_length')
		, ('staging', 'star_loan', 'transaction_dim', 'early_first_payment', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'early_first_payment_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_early_first_payment')
		, ('staging', 'star_loan', 'transaction_dim', 'earthquake_insurance_applicable', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'earthquake_insurance_applicable_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_earthquake_insurance_applicable')
		, ('staging', 'star_loan', 'transaction_dim', 'flood_insurance_applicable', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'flood_insurance_applicable_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_flood_insurance_applicable')
		, ('staging', 'star_loan', 'transaction_dim', 'hazard_insurance_applicable', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'hazard_insurance_applicable_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_hazard_insurance_applicable')
		, ('staging', 'star_loan', 'transaction_dim', 'hud_consultant', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'hud_consultant_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_hud_consultant')
		, ('staging', 'star_loan', 'transaction_dim', 'mortgagee_builder_seller_relationship', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'mortgagee_builder_seller_relationship_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_mortgagee_builder_seller_relationship')
		, ('staging', 'star_loan', 'transaction_dim', 'property_acquired_through_ancillary_relief', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'property_acquired_through_ancillary_relief_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_property_acquired_through_ancillary_relief')
		, ('staging', 'star_loan', 'transaction_dim', 'property_acquired_through_inheritance', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'property_acquired_through_inheritance_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_property_acquired_through_inheritance')
		, ('staging', 'star_loan', 'transaction_dim', 'separate_transaction_for_land_acquisition', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'separate_transaction_for_land_acquisition_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_separate_transaction_for_land_acquisition')
		, ('staging', 'star_loan', 'transaction_dim', 'taxes_escrowed', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'taxes_escrowed_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_taxes_escrowed')
		, ('staging', 'star_loan', 'transaction_dim', 'vesting_change_titleholder_added', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'vesting_change_titleholder_added_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_vesting_change_titleholder_added')
		, ('staging', 'star_loan', 'transaction_dim', 'vesting_change_titleholder_name_change', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'vesting_change_titleholder_name_change_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_vesting_change_titleholder_name_change')
		, ('staging', 'star_loan', 'transaction_dim', 'vesting_change_titleholder_removed', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'vesting_change_titleholder_removed_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_vesting_change_titleholder_removed')
		, ('staging', 'star_loan', 'transaction_dim', 'windstorm_insurance_applicable', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
		, ('staging', 'star_loan', 'transaction_dim', 'windstorm_insurance_applicable_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_windstorm_insurance_applicable')
		, ('staging', 'star_loan', 'underwrite_dim', 'underwrite_disposition', 'VARCHAR(1024)', 'staging', 'history_octane', 'underwrite_disposition_type', 'value')
		, ('staging', 'star_loan', 'underwrite_dim', 'underwrite_disposition_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_underwrite_disposition_type')
		, ('staging', 'star_loan', 'underwrite_dim', 'underwrite_method', 'VARCHAR(1024)', 'staging', 'history_octane', 'underwrite_method_type', 'value')
		, ('staging', 'star_loan', 'underwrite_dim', 'underwrite_method_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_underwrite_method_type')
		, ('staging', 'star_loan', 'underwrite_dim', 'underwrite_risk_assessment', 'VARCHAR(1024)', 'staging', 'history_octane', 'underwrite_risk_assessment_type', 'value')
		, ('staging', 'star_loan', 'underwrite_dim', 'underwrite_risk_assessment_code', 'VARCHAR(128)', 'staging', 'history_octane', 'proposal', 'prp_underwrite_risk_assessment_type')
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

--process
INSERT
INTO mdi.process (name, description)
VALUES ('ETL-200023', 'ETL to insert_update records into staging.star_loan.cash_out_reason_dim using staging.history_octane.proposal as the primary source')
	, ('ETL-200024', 'ETL to insert_update records into staging.star_loan.hmda_action_dim using staging.history_octane.deal as the primary source')
	, ('ETL-200026', 'ETL to insert_update records into staging.star_loan.transaction_aux_construction_dim using staging.history_octane.deal as the primary source')
	, ('ETL-200027', 'ETL to insert_update records into staging.star_loan.transaction_aux_disaster_declaration_dim using staging.history_octane.deal as the primary source')
	, ('ETL-200028', 'ETL to insert_update records into staging.star_loan.transaction_aux_govt_programs_dim using staging.history_octane.deal as the primary source')
	, ('ETL-200029', 'ETL to insert_update records into staging.star_loan.transaction_aux_property_repairs_dim using staging.history_octane.deal as the primary source')
	, ('ETL-200025', 'ETL to insert_update records into staging.star_loan.underwrite_dim using staging.history_octane.proposal as the primary source');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
	VALUES ('ETL-200023', 1, 'WITH cash_out_reason_dim_new_records AS (
    SELECT ''cash_out_reason_business_debt_or_debt_consolidation_flag~'' ||
		   ''cash_out_reason_debt_or_debt_consolidation_flag~'' ||
		   ''cash_out_reason_future_investment_not_under_contract_flag~'' ||
		   ''cash_out_reason_future_investment_under_contract_flag~'' ||
		   ''cash_out_reason_home_improvement_flag~'' ||
		   ''cash_out_reason_investment_or_business_property_flag~'' ||
		   ''cash_out_reason_other_flag~'' ||
		   ''cash_out_reason_personal_use_flag~'' ||
		   ''cash_out_reason_student_loans_flag~'' ||
		   ''non_business_cash_out_reason_acknowledged_code~data_source_dwid'' AS data_source_integration_columns
        , COALESCE(CAST(proposal.prp_cash_out_reason_business_debt_or_debt_consolidation AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_cash_out_reason_debt_or_debt_consolidation AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_cash_out_reason_future_investment_not_under_contract AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_cash_out_reason_future_investment_under_contracT AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_cash_out_reason_home_improvement AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_cash_out_reason_investment_or_business_property AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_cash_out_reason_other AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_cash_out_reason_personal_use AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_cash_out_reason_student_loans AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(proposal.prp_non_business_cash_out_reason_acknowledged AS TEXT), ''<NULL>'') || ''~'' ||
         COALESCE(CAST(1 AS TEXT), ''<NULL>'') AS data_source_integration_id
        , NOW() AS edw_created_datetime
        , NOW() AS edw_modified_datetime
        , MAX(proposal.data_source_updated_datetime) AS data_source_modified_datetime
		, proposal.prp_cash_out_reason_business_debt_or_debt_consolidation AS cash_out_reason_business_debt_or_debt_consolidation_flag
		, proposal.prp_cash_out_reason_debt_or_debt_consolidation AS cash_out_reason_debt_or_debt_consolidation_flag
		, proposal.prp_cash_out_reason_future_investment_not_under_contract AS cash_out_reason_future_investment_not_under_contract_flag
		, proposal.prp_cash_out_reason_future_investment_under_contract AS cash_out_reason_future_investment_under_contract_flag
		, proposal.prp_cash_out_reason_home_improvement AS cash_out_reason_home_improvement_flag
		, proposal.prp_cash_out_reason_investment_or_business_property AS cash_out_reason_investment_or_business_property_flag
		, proposal.prp_cash_out_reason_other AS cash_out_reason_other_flag
		, proposal.prp_cash_out_reason_personal_use AS cash_out_reason_personal_use_flag
		, proposal.prp_cash_out_reason_student_loans AS cash_out_reason_student_loans_flag
		, yes_no_na_type.value AS non_business_cash_out_reason_acknowledged
		, proposal.prp_non_business_cash_out_reason_acknowledged AS non_business_cash_out_reason_acknowledged_code
    	, MAX(GREATEST(yes_no_na_type.etl_end_date_time)) AS max_source_etl_end_date_time
    FROM (
		SELECT <<deal_partial_load_condition>> AS include_record
			, deal.*
		FROM history_octane.deal
		LEFT JOIN history_octane.deal AS history_records
			ON deal.d_pid = history_records.d_pid
				AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
		WHERE history_records.d_pid IS NULL
		) AS deal
    JOIN (
      SELECT *
      FROM (
        SELECT <<proposal_partial_load_condition>> AS include_record
            , proposal.*
        FROM history_octane.proposal
        LEFT JOIN history_octane.proposal AS history_records
            ON proposal.prp_pid = history_records.prp_pid
                AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.prp_pid IS NULL
        ) AS primary_table
		) AS proposal
    		ON deal.d_pid = proposal.prp_deal_pid
    JOIN (
		SELECT *
		FROM (
        SELECT <<yes_no_na_type_partial_load_condition>> AS include_record
            , yes_no_na_type.*
            , etl_log.etl_end_date_time
        FROM history_octane.yes_no_na_type
        LEFT JOIN history_octane.yes_no_na_type AS history_records
            ON yes_no_na_type.code = history_records.code
                AND yes_no_na_type.data_source_updated_datetime < history_records.data_source_updated_datetime
        JOIN star_common.etl_log
            ON yes_no_na_type.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.code IS NULL
        ) AS primary_table
      ) AS yes_no_na_type
    		ON proposal.prp_non_business_cash_out_reason_acknowledged = yes_no_na_type.code
    WHERE GREATEST(deal.include_record, proposal.include_record, yes_no_na_type.include_record) IS TRUE
    GROUP BY proposal.prp_cash_out_reason_business_debt_or_debt_consolidation
		, proposal.prp_cash_out_reason_debt_or_debt_consolidation
		, proposal.prp_cash_out_reason_future_investment_not_under_contract
		, proposal.prp_cash_out_reason_future_investment_under_contract
		, proposal.prp_cash_out_reason_home_improvement
		, proposal.prp_cash_out_reason_investment_or_business_property
		, proposal.prp_cash_out_reason_other
		, proposal.prp_cash_out_reason_personal_use
		, proposal.prp_cash_out_reason_student_loans
		, yes_no_na_type.value
		, proposal.prp_non_business_cash_out_reason_acknowledged
)
-- new records that should be inserted
SELECT cash_out_reason_dim_new_records.*
FROM cash_out_reason_dim_new_records
LEFT JOIN star_loan.cash_out_reason_dim
  ON cash_out_reason_dim_new_records.data_source_integration_id = cash_out_reason_dim.data_source_integration_id
WHERE cash_out_reason_dim.dwid IS NULL
UNION ALL
-- existing records that need to be updated
SELECT cash_out_reason_dim_new_records.*
FROM cash_out_reason_dim_new_records
JOIN (
  SELECT cash_out_reason_dim.data_source_integration_id
    , etl_log.etl_start_date_time
  FROM star_loan.cash_out_reason_dim
    JOIN star_common.etl_log
      ON cash_out_reason_dim.etl_batch_id = etl_log.etl_batch_id
) AS cash_out_reason_dim_etl_start_times
  ON cash_out_reason_dim_new_records.data_source_integration_id = cash_out_reason_dim_etl_start_times.data_source_integration_id
    AND cash_out_reason_dim_new_records.max_source_etl_end_date_time >= cash_out_reason_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
		, ('ETL-200024', 1, 'WITH hmda_action_dim_new_records AS (
    SELECT ''hmda_action_code~hmda_denial_reason_code_1~'' ||
           ''hmda_denial_reason_code_2~'' ||
           ''hmda_denial_reason_code_3~'' ||
           ''hmda_denial_reason_code_4~'' ||
           ''data_source_dwid'' AS data_source_integration_columns
    	, COALESCE(CAST(deal.d_hmda_action_type AS TEXT), ''<NULL>'') || ''~'' ||
    	  COALESCE(CAST(deal.d_hmda_denial_reason_type_1 AS TEXT), ''<NULL>'') || ''~'' ||
    	  COALESCE(CAST(deal.d_hmda_denial_reason_type_2 AS TEXT), ''<NULL>'') || ''~'' ||
    	  COALESCE(CAST(deal.d_hmda_denial_reason_type_3 AS TEXT), ''<NULL>'') || ''~'' ||
    	  COALESCE(CAST(deal.d_hmda_denial_reason_type_4 AS TEXT), ''<NULL>'') || ''~'' ||
    	  COALESCE(CAST(1 AS TEXT), ''<NULL>'') AS data_source_integration_id
    	, NOW() AS edw_created_datetime
    	, NOW() AS edw_modified_datetime
    	, MAX(deal.data_source_updated_datetime) AS data_source_modified_datetime
		, hmda_action_type.value AS hmda_action
    	, deal.d_hmda_action_type AS hmda_action_code
    	, hmda_denial_reason_type_1.value AS hmda_denial_reason_1
    	, hmda_denial_reason_type_2.value AS hmda_deniaL_reason_2
		, hmda_denial_reason_type_3.value AS hmda_deniaL_reason_3
		, hmda_denial_reason_type_4.value AS hmda_deniaL_reason_4
    	, deal.d_hmda_denial_reason_type_1 AS hmda_denial_reason_code_1
		, deal.d_hmda_denial_reason_type_2 AS hmda_denial_reason_code_2
		, deal.d_hmda_denial_reason_type_3 AS hmda_denial_reason_code_3
		, deal.d_hmda_denial_reason_type_4 AS hmda_denial_reason_code_4
    	, MAX(GREATEST(hmda_action_type.etl_end_date_time, hmda_denial_reason_type_1.etl_end_date_time,
    	    hmda_denial_reason_type_2.etl_end_date_time, hmda_denial_reason_type_3.etl_end_date_time,
    	    hmda_denial_reason_type_4.etl_end_date_time)) AS max_source_etl_end_date_time
    FROM (
         SELECT <<deal_partial_load_condition>> AS include_record
         	, deal.*
         FROM history_octane.deal
         LEFT JOIN history_octane.deal AS history_records
         	ON deal.d_pid = history_records.d_pid
         		AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
         WHERE history_records.d_pid IS NULL
		) AS deal
    JOIN (
        SELECT *
        FROM (
        	SELECT <<hmda_action_type_partial_load_condition>> AS include_record
            	, hmda_action_type.*
            	, etl_log.etl_end_date_time
            FROM history_octane.hmda_action_type
            LEFT JOIN history_octane.hmda_action_type AS history_records
            	ON hmda_action_type.code = history_records.code
            		AND hmda_action_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
            	ON hmda_action_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
			) AS primary_table
		) AS hmda_action_type
    		ON deal.d_hmda_action_type = hmda_action_type.code
    JOIN (
        SELECT *
        FROM (
        	SELECT <<hmda_denial_reason_type_partial_load_condition>> AS include_record
            	, hmda_denial_reason_type.*
            	, etl_log.etl_end_date_time
            FROM history_octane.hmda_denial_reason_type
            LEFT JOIN history_octane.hmda_denial_reason_type AS history_records
            	ON hmda_denial_reason_type.code = history_records.code
            		AND hmda_denial_reason_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
            	ON hmda_denial_reason_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
			) AS primary_table
		) AS hmda_denial_reason_type_1
    		ON deal.d_hmda_denial_reason_type_1 = hmda_denial_reason_type_1.code
    JOIN (
        SELECT *
        FROM (
        	SELECT <<hmda_denial_reason_type_partial_load_condition>> AS include_record
            	, hmda_denial_reason_type.*
            	, etl_log.etl_end_date_time
            FROM history_octane.hmda_denial_reason_type
            LEFT JOIN history_octane.hmda_denial_reason_type AS history_records
            	ON hmda_denial_reason_type.code = history_records.code
            		AND hmda_denial_reason_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
            	ON hmda_denial_reason_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
			) AS primary_table
		) AS hmda_denial_reason_type_2
    		ON deal.d_hmda_denial_reason_type_2 = hmda_denial_reason_type_2.code
    JOIN (
        SELECT *
        FROM (
        	SELECT <<hmda_denial_reason_type_partial_load_condition>> AS include_record
            	, hmda_denial_reason_type.*
            	, etl_log.etl_end_date_time
            FROM history_octane.hmda_denial_reason_type
            LEFT JOIN history_octane.hmda_denial_reason_type AS history_records
            	ON hmda_denial_reason_type.code = history_records.code
            		AND hmda_denial_reason_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
            	ON hmda_denial_reason_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
			) AS primary_table
		) AS hmda_denial_reason_type_3
    		ON deal.d_hmda_denial_reason_type_3 = hmda_denial_reason_type_3.code
    JOIN (
        SELECT *
        FROM (
        	SELECT <<hmda_denial_reason_type_partial_load_condition>> AS include_record
            	, hmda_denial_reason_type.*
            	, etl_log.etl_end_date_time
            FROM history_octane.hmda_denial_reason_type
            LEFT JOIN history_octane.hmda_denial_reason_type AS history_records
            	ON hmda_denial_reason_type.code = history_records.code
            		AND hmda_denial_reason_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
            	ON hmda_denial_reason_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
			) AS primary_table
		) AS hmda_denial_reason_type_4
    		ON deal.d_hmda_denial_reason_type_4 = hmda_denial_reason_type_4.code
    WHERE GREATEST(deal.include_record, hmda_action_type.include_record, hmda_denial_reason_type_1.include_record,
        hmda_denial_reason_type_2.include_record, hmda_denial_reason_type_3.include_record, hmda_denial_reason_type_4
            .include_record) IS TRUE
    GROUP BY hmda_action_type.value
    	, deal.d_hmda_action_type
    	, hmda_denial_reason_type_1.value
    	, hmda_denial_reason_type_2.value
		, hmda_denial_reason_type_3.value
		, hmda_denial_reason_type_4.value
    	, deal.d_hmda_denial_reason_type_1
		, deal.d_hmda_denial_reason_type_2
		, deal.d_hmda_denial_reason_type_3
		, deal.d_hmda_denial_reason_type_4
)
-- new records that should be inserted
SELECT hmda_action_dim_new_records.*
FROM hmda_action_dim_new_records
LEFT JOIN star_loan.hmda_action_dim
	ON hmda_action_dim_new_records.data_source_integration_id = hmda_action_dim.data_source_integration_id
WHERE hmda_action_dim.dwid IS NULL
UNION ALL
-- existing records that should be updated
SELECT hmda_action_dim_new_records.*
FROM hmda_action_dim_new_records
JOIN (
    SELECT hmda_action_dim.data_source_integration_id
    	, etl_log.etl_start_date_time
	FROM star_loan.hmda_action_dim
    	JOIN star_common.etl_log
    		ON hmda_action_dim.etl_batch_id = etl_log.etl_batch_id
	) AS hmda_action_dim_etl_start_times
	ON hmda_action_dim_new_records.data_source_integration_id = hmda_action_dim_etl_start_times.data_source_integration_id
		AND hmda_action_dim_new_records.max_source_etl_end_date_time >= hmda_action_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
		, ('ETL-200026', 1, 'WITH transaction_aux_construction_dim_incl_new_records AS (
    SELECT ''deal_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
    	, COALESCE(CAST(deal.d_pid AS TEXT), ''<NULL>'') || ''~'' ||
    	  COALESCE(CAST(1 AS TEXT), ''<NULL>'') AS data_source_integration_id
    	, NOW() AS edw_created_datetime
    	, NOW() AS edw_modified_datetime
    	, proposal.data_source_updated_datetime AS data_source_modified_datetime
    	, transaction_dim.dwid AS transaction_dwid
      , deal.d_pid AS deal_pid
    	, proposal.prp_pid AS active_proposal_pid
    	, proposal.prp_financed_property_improvements AS financed_property_improvements_flag
    	, proposal.prp_loan_modification_agreement_executed_received_datetime AS loan_modification_agreement_executed_received_datetime
    	, proposal.prp_adjusted_as_is_value_amount AS adjusted_as_is_value_amount
    	, proposal.prp_after_improved_value_amount AS after_improved_value_amount
    	, proposal.prp_construction_borrower_contribution_amount AS construction_borrower_contribution_amount
    	, proposal.prp_estimated_hard_construction_cost_amount AS estimated_hard_construction_cost_amount
    	, proposal.prp_cr_tracker_url AS cr_tracker_url
    	, construction_lot_ownership_status_type.value AS construction_lot_ownership_status
    	, proposal.prp_construction_lot_ownership_status_type AS construction_lot_ownership_status_code
    	, financed_property_improvements_category_type.value AS financed_property_improvements_category
    	, proposal.prp_financed_property_improvements_category_type AS financed_property_improvements_category_code
    	, GREATEST(deal.etl_end_date_time, proposal.etl_end_date_time, construction_lot_ownership_status_type
    	    .etl_end_date_time, financed_property_improvements_category_type.etl_end_date_time,
    	    transaction_dim.etl_end_date_time) AS max_source_etl_end_date_time
    FROM (
        SELECT <<deal_partial_load_condition>> AS include_record
        	, deal.*
        	, etl_log.etl_end_date_time
        FROM history_octane.deal
        	LEFT JOIN history_octane.deal AS history_records
        		ON deal.d_pid = history_records.d_pid
        			AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
        	JOIN star_common.etl_log
        		ON deal.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.d_pid IS NULL
		) AS deal
    JOIN (
        SELECT *
        FROM (
            SELECT <<proposal_partial_load_condition>> AS include_record
            	, proposal.*
            	, etl_log.etl_end_date_time
            FROM history_octane.proposal
            	LEFT JOIN history_octane.proposal AS history_records
            		ON proposal.prp_pid = history_records.prp_pid
            			AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
            	JOIN star_common.etl_log
            		ON proposal.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.prp_pid IS NULL
		) AS primary_table
	) AS proposal
    	ON deal.d_active_proposal_pid = proposal.prp_pid
    LEFT JOIN (
        SELECT *
        FROM (
            SELECT <<construction_lot_ownership_status_type_partial_load_condition>> AS include_record
            	, construction_lot_ownership_status_type.*
            	, etl_log.etl_end_date_time
            FROM history_octane.construction_lot_ownership_status_type
            	LEFT JOIN history_octane.construction_lot_ownership_status_type AS history_records
            		ON construction_lot_ownership_status_type.code = history_records.code
            			AND construction_lot_ownership_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            	JOIN star_common.etl_log
            		ON construction_lot_ownership_status_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
		) AS primary_table
	) AS construction_lot_ownership_status_type
        ON proposal.prp_construction_lot_ownership_status_type = construction_lot_ownership_status_type.code
    JOIN (
        SELECT *
        FROM (
            SELECT <<financed_property_improvements_category_type_partial_load_condition>> AS include_record
            	, financed_property_improvements_category_type.*
            	, etl_log.etl_end_date_time
            FROM history_octane.financed_property_improvements_category_type
            	LEFT JOIN history_octane.financed_property_improvements_category_type AS history_records
            		ON financed_property_improvements_category_type.code = history_records.code
            			AND financed_property_improvements_category_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            	JOIN star_common.etl_log
            		ON financed_property_improvements_category_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
			) AS primary_table
	) AS financed_property_improvements_category_type
    	ON proposal.prp_financed_property_improvements_category_type = financed_property_improvements_category_type.code
    JOIN (
    	SELECT <<transaction_dim_partial_load_condition>> AS include_record
    		, transaction_dim.*
    		, etl_log.etl_end_date_time
    	FROM star_loan.transaction_dim
        JOIN star_common.etl_log
        	ON transaction_dim.etl_batch_id = etl_log.etl_batch_id
    ) AS transaction_dim
    	ON deal.d_pid = transaction_dim.deal_pid
	WHERE GREATEST(deal.include_record, proposal.include_record, construction_lot_ownership_status_type
		.include_record, financed_property_improvements_category_type.include_record, transaction_dim.include_record) IS TRUE
)
-- new records that should be inserted
SELECT transaction_aux_construction_dim_incl_new_records.*
FROM transaction_aux_construction_dim_incl_new_records
LEFT JOIN star_loan.transaction_aux_construction_dim
	ON transaction_aux_construction_dim_incl_new_records.data_source_integration_id =
	   transaction_aux_construction_dim.data_source_integration_id
WHERE transaction_aux_construction_dim.transaction_dwid IS NULL
UNION ALL
-- existing records that need to be updated
SELECT transaction_aux_construction_dim_incl_new_records.*
FROM transaction_aux_construction_dim_incl_new_records
JOIN (
    SELECT transaction_aux_construction_dim.data_source_integration_id
    	, etl_log.etl_start_date_time
    FROM star_loan.transaction_aux_construction_dim
    JOIN star_common.etl_log
    	ON transaction_aux_construction_dim.etl_batch_id = etl_log.etl_batch_id
) AS transaction_aux_construction_dim_etl_start_times
	ON transaction_aux_construction_dim_incl_new_records.data_source_integration_id =
	   transaction_aux_construction_dim_etl_start_times.data_source_integration_id
		AND transaction_aux_construction_dim_incl_new_records.max_source_etl_end_date_time >=
		    transaction_aux_construction_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
		, ('ETL-200027', 1, 'WITH transaction_aux_disaster_declaration_dim_incl_new_records AS (
	SELECT ''deal_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
		, COALESCE(CAST(deal.d_pid AS TEXT), ''<NULL>'') || ''~'' ||
		  COALESCE(CAST(1 AS TEXT), ''<NULL>'') AS data_source_integration_id
		, NOW() AS edw_created_datetime
		, NOW() AS edw_modified_datetime
		, proposal.data_source_updated_datetime AS data_source_modified_datetime
		, transaction_dim.dwid AS transaction_dwid
		, deal.d_pid AS deal_pid
		, proposal.prp_pid AS active_proposal_pid
    	, proposal.prp_any_disaster_declaration_after_appraisal AS any_disaster_declaration_after_appraisal_flag
    	, proposal.prp_any_disaster_declaration_before_appraisal AS any_disaster_declaration_before_appraisal_flag
    	, proposal.prp_any_disaster_declaration AS any_disaster_declaration_flag
    	, proposal.prp_disaster_declaration_check_date AS disaster_declaration_check_date
    	, disaster_declaration_check_date_type.value AS disaster_declaration_check_date_type
    	, proposal.prp_disaster_declaration_check_date_type AS disaster_declaration_check_date_type_code
		, GREATEST(deal.etl_end_date_time, proposal.etl_end_date_time, disaster_declaration_check_date_type
		    .etl_end_date_time, transaction_dim.etl_end_date_time) AS max_source_etl_end_date_time
	FROM (
		SELECT <<deal_partial_load_condition>> AS include_record
			, deal.*
			, etl_log.etl_end_date_time
		FROM history_octane.deal
			LEFT JOIN history_octane.deal AS history_records
				ON deal.d_pid = history_records.d_pid
					AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
			JOIN star_common.etl_log
				ON deal.etl_batch_id = etl_log.etl_batch_id
		WHERE history_records.d_pid IS NULL
	) AS deal
	JOIN (
		SELECT *
		FROM (
			SELECT <<proposal_partial_load_condition>> AS include_record
				, proposal.*
				, etl_log.etl_end_date_time
			FROM history_octane.proposal
				LEFT JOIN history_octane.proposal AS history_records
					ON proposal.prp_pid = history_records.prp_pid
						AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
				JOIN star_common.etl_log
					ON proposal.etl_batch_id = etl_log.etl_batch_id
			WHERE history_records.prp_pid IS NULL
		) AS primary_table
	) AS proposal
		ON deal.d_active_proposal_pid = proposal.prp_pid
    JOIN (
        SELECT *
        FROM (
            SELECT <<disaster_declaration_check_date_type_partial_load_condition>> AS include_record
            	, disaster_declaration_check_date_type.*
            	, etl_log.etl_end_date_time
            FROM history_octane.disaster_declaration_check_date_type
            	LEFT JOIN history_octane.disaster_declaration_check_date_type AS history_records
            		ON disaster_declaration_check_date_type.code = history_records.code
            			AND disaster_declaration_check_date_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
            	ON disaster_declaration_check_date_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
		) AS primary_table
	) AS disaster_declaration_check_date_type
    	ON proposal.prp_disaster_declaration_check_date_type = disaster_declaration_check_date_type.code
	JOIN (
		SELECT <<transaction_dim_partial_load_condition>> AS include_record
			, transaction_dim.*
			, etl_log.etl_end_date_time
		FROM star_loan.transaction_dim
			JOIN star_common.etl_log
				ON transaction_dim.etl_batch_id = etl_log.etl_batch_id
	) AS transaction_dim
		ON deal.d_pid = transaction_dim.deal_pid
    WHERE GREATEST(deal.include_record, proposal.include_record, disaster_declaration_check_date_type.include_record,
        transaction_dim.include_record) IS TRUE
)
-- new records that should be inserted
SELECT transaction_aux_disaster_declaration_dim_incl_new_records.*
FROM transaction_aux_disaster_declaration_dim_incl_new_records
LEFT JOIN star_loan.transaction_aux_disaster_declaration_dim
	ON transaction_aux_disaster_declaration_dim_incl_new_records.data_source_integration_id =
	   transaction_aux_disaster_declaration_dim.data_source_integration_id
WHERE transaction_aux_disaster_declaration_dim.transaction_dwid IS NULL
UNION ALL
-- existing records that need to be updated
SELECT transaction_aux_disaster_declaration_dim_incl_new_records.*
FROM transaction_aux_disaster_declaration_dim_incl_new_records
JOIN (
    SELECT transaction_aux_disaster_declaration_dim.data_source_integration_id
    	, etl_log.etl_start_date_time
    FROM star_loan.transaction_aux_disaster_declaration_dim
    	JOIN star_common.etl_log
    		ON transaction_aux_disaster_declaration_dim.etl_batch_id = etl_log.etl_batch_id
		) AS transaction_aux_disaster_declaration_dim_etl_start_times
		ON transaction_aux_disaster_declaration_dim_incl_new_records.data_source_integration_id =
		   transaction_aux_disaster_declaration_dim_etl_start_times.data_source_integration_id
			AND transaction_aux_disaster_declaration_dim_incl_new_records.max_source_etl_end_date_time >=
			    transaction_aux_disaster_declaration_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
		, ('ETL-200028', 1, 'WITH transaction_aux_govt_programs_dim_incl_new_records AS (
	SELECT ''deal_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
		, COALESCE(CAST(deal.d_pid AS TEXT), ''<NULL>'') || ''~'' ||
		  COALESCE(CAST(1 AS TEXT), ''<NULL>'') AS data_source_integration_id
		, NOW() AS edw_created_datetime
		, NOW() AS edw_modified_datetime
		, proposal.data_source_updated_datetime AS data_source_modified_datetime
		, transaction_dim.dwid AS transaction_dwid
		, deal.d_pid AS deal_pid
		, proposal.prp_pid AS active_proposal_pid
		, proposal.prp_fha_mip_refund_request_input_error AS fha_mip_refund_request_input_error_flag
		, proposal.prp_fha_non_arms_length_ltv_exception_verified AS fha_non_arms_length_ltv_exception_verified_flag
      , proposal.prp_request_fha_mip_refund_required AS request_fha_mip_refund_required_flag
      , proposal.prp_texas_equity_conversion_determination_datetime_override AS texas_equity_conversion_determination_datetime_override_flag
      , proposal.prp_texas_equity_determination_datetime_override AS texas_equity_determination_datetime_override_flag
      , proposal.prp_va_maintenance_utilities_auto_compute AS va_maintenance_utilities_auto_compute_flag
      , proposal.prp_fha_prior_agency_case_endorsement_date AS fha_prior_agency_case_endorsement_date
      , proposal.prp_fha_refinance_authorization_expiration_date AS fha_refinance_authorization_expiration_date
      , proposal.prp_texas_equity_determination_datetime AS texas_equity_determination_datetime
      , proposal.prp_usda_gsa_sam_checked_date AS usda_gsa_sam_checked_date
      , proposal.prp_va_notice_of_value_date AS va_notice_of_value_date
      , proposal.prp_cema_borrower_savings AS cema_borrower_savings
      , proposal.prp_fha_va_reasonable_value_amount AS fha_va_reasonable_value_amount
      , proposal.prp_va_actual_guaranty_amount AS va_actual_guaranty_amount
      , proposal.prp_va_amount_used_to_calculate_maximum_guaranty AS va_amount_used_to_calculate_maximum_guaranty
      , proposal.prp_va_energy_efficient_improvements_amount AS va_energy_efficient_improvements_amount
      , proposal.prp_va_guaranty_percent AS va_guaranty_percent
      , proposal.prp_va_maintenance_utilities_per_square_feet_amount AS va_maintenance_utilities_per_square_feet_amount
      , proposal.prp_va_maximum_base_loan_amount AS va_maximum_base_loan_amount
      , proposal.prp_va_maximum_funding_fee_amount AS va_maximum_funding_fee_amount
      , proposal.prp_va_maximum_total_loan_amount AS va_maximum_total_loan_amount
      , proposal.prp_va_monthly_maintenance_utilities_amount AS va_monthly_maintenance_utilities_amount
      , proposal.prp_va_notice_of_value_estimated_reasonable_value_amount AS va_notice_of_value_estimated_reasonable_value_amount
      , proposal.prp_va_required_cash_amount AS va_required_cash_amount
      , proposal.prp_va_required_guaranty_amount AS va_required_guaranty_amount
      , proposal.prp_fha_prior_agency_case_id AS fha_prior_agency_case_id
      , proposal.prp_fha_refinance_authorization_number AS fha_refinance_authorization_number
      , proposal.prp_fhac_refinance_authorization_messages AS fhac_refinance_authorization_messages
      , proposal.prp_texas_equity_conversion_determ_datetime_override_reason AS texas_equity_conversion_determ_datetime_override_reason
      , proposal.prp_texas_equity_determination_datetime_override_reason AS texas_equity_determination_datetime_override_reason
      , proposal.prp_va_prior_paid_in_full_loan_number AS va_prior_paid_in_full_loan_number
    	, fha_non_arms_length_ltv_limit_exception_type.value AS fha_non_arms_length_ltv_exception
    	, proposal.prp_fha_non_arms_length_ltv_exception_type AS fha_non_arms_length_ltv_exception_code
    	, hud_fha_de_approval_type.value AS hud_fha_de_approval
    	, proposal.prp_hud_fha_de_approval_type AS hud_fha_de_approval_code
    	, usda_rd_single_family_housing_type.value AS usda_rd_single_family_housing
    	, proposal.prp_usda_rd_single_family_housing_type AS usda_rd_single_family_housing_code
    	, va_notice_of_value_source_type.value AS va_notice_of_value_source
    	, proposal.prp_va_notice_of_value_source_type AS va_notice_of_value_source_code
    	, va_past_credit_record_type.value AS va_past_credit_record
    	, proposal.prp_va_past_credit_record_type AS va_past_credit_record_code
    	, cema_ynna_type.value AS cema
    	, proposal.prp_cema AS cema_code
	    , fha_eligible_maximum_financing_ynu_type.value AS fha_eligible_maximum_financing
    	, proposal.prp_fha_eligible_maximum_financing AS fha_eligible_maximum_financing_code
    	, usda_gsa_sam_exclusion_ynu_type.value AS usda_gsa_sam_exclusion
	    , proposal.prp_usda_gsa_sam_exclusion AS usda_gsa_sam_exclusion_code
		, va_meets_credit_standards_ynu_type.value AS va_meets_credit_standards
	    , proposal.prp_va_meets_credit_standards AS va_meets_credit_standards_code
    	, va_monthly_utilities_included_ynu_type.value AS va_monthly_utilities_included
	    , proposal.prp_va_monthly_utilities_included AS va_monthly_utilities_included_code
		, GREATEST(deal.etl_end_date_time, proposal.etl_end_date_time, fha_non_arms_length_ltv_limit_exception_type
		    .etl_end_date_time, hud_fha_de_approval_type.etl_end_date_time, usda_rd_single_family_housing_type
		        .etl_end_date_time, va_notice_of_value_source_type.etl_end_date_time, va_past_credit_record_type
		            .etl_end_date_time, cema_ynna_type.etl_end_date_time, fha_eligible_maximum_financing_ynu_type
		                .etl_end_date_time, usda_gsa_sam_exclusion_ynu_type.etl_end_date_time,
		    va_meets_credit_standards_ynu_type.etl_end_date_time, va_monthly_utilities_included_ynu_type
		        .etl_end_date_time, transaction_dim.etl_end_date_time) AS max_source_etl_end_date_time
	FROM (
		SELECT <<deal_partial_load_condition>> AS include_record
			, deal.*
			, etl_log.etl_end_date_time
		FROM history_octane.deal
			LEFT JOIN history_octane.deal AS history_records
				ON deal.d_pid = history_records.d_pid
					AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
			JOIN star_common.etl_log
				ON deal.etl_batch_id = etl_log.etl_batch_id
		WHERE history_records.d_pid IS NULL
	) AS deal
		JOIN (
			SELECT *
			FROM (
				SELECT <<proposal_partial_load_condition>> AS include_record
					, proposal.*
					, etl_log.etl_end_date_time
				FROM history_octane.proposal
					LEFT JOIN history_octane.proposal AS history_records
						ON proposal.prp_pid = history_records.prp_pid
							AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON proposal.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.prp_pid IS NULL
			) AS primary_table
		) AS proposal
			ON deal.d_active_proposal_pid = proposal.prp_pid
		JOIN (
		    SELECT *
		    FROM (
		        SELECT <<fha_non_arms_length_ltv_limit_exception_type_partial_load_condition>> AS include_record
		        	, fha_non_arms_length_ltv_limit_exception_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.fha_non_arms_length_ltv_limit_exception_type
		        	LEFT JOIN history_octane.fha_non_arms_length_ltv_limit_exception_type AS history_records
		        		ON fha_non_arms_length_ltv_limit_exception_type.code = history_records.code
		        			AND fha_non_arms_length_ltv_limit_exception_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON fha_non_arms_length_ltv_limit_exception_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS fha_non_arms_length_ltv_limit_exception_type
	    		ON proposal.prp_fha_non_arms_length_ltv_exception_type = fha_non_arms_length_ltv_limit_exception_type.code
	    JOIN (
	        SELECT *
	        FROM (
	            SELECT <<hud_fha_de_approval_type_partial_load_condition>> AS include_record
	            	, hud_fha_de_approval_type.*
	            	, etl_log.etl_end_date_time
	            FROM history_octane.hud_fha_de_approval_type
	            	LEFT JOIN history_octane.hud_fha_de_approval_type AS history_records
	            		ON hud_fha_de_approval_type.code = history_records.code
	            			AND hud_fha_de_approval_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	            	JOIN star_common.etl_log
	            		ON hud_fha_de_approval_type.etl_batch_id = etl_log.etl_batch_id
	            WHERE history_records.code IS NULL
			) AS primary_table
		) AS hud_fha_de_approval_type
	    	ON proposal.prp_hud_fha_de_approval_type = hud_fha_de_approval_type.code
	    JOIN (
	        SELECT *
	        FROM (
	            SELECT <<usda_rd_single_family_housing_type_partial_load_condition>> AS include_record
	            	, usda_rd_single_family_housing_type.*
	            	, etl_log.etl_end_date_time
	            FROM history_octane.usda_rd_single_family_housing_type
	            	LEFT JOIN history_octane.usda_rd_single_family_housing_type AS history_records
	            		ON usda_rd_single_family_housing_type.code = history_records.code
	            			AND usda_rd_single_family_housing_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	            	JOIN star_common.etl_log
	            		ON usda_rd_single_family_housing_type.etl_batch_id = etl_log.etl_batch_id
	            WHERE history_records.code IS NULL
			) AS primary_table
		) AS usda_rd_single_family_housing_type
			ON proposal.prp_usda_rd_single_family_housing_type = usda_rd_single_family_housing_type.code
	    JOIN (
	        SELECT *
	        FROM (
	            SELECT <<va_notice_of_value_source_type_partial_load_condition>> AS include_record
	            	, va_notice_of_value_source_type.*
	            	, etl_log.etl_end_date_time
	            FROM history_octane.va_notice_of_value_source_type
	            	LEFT JOIN history_octane.va_notice_of_value_source_type AS history_records
	            		ON va_notice_of_value_source_type.code = history_records.code
	            			AND va_notice_of_value_source_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	            	JOIN star_common.etl_log
	            		ON va_notice_of_value_source_type.etl_batch_id = etl_log.etl_batch_id
	            WHERE history_records.code IS NULL
			) AS primary_table
		) AS va_notice_of_value_source_type
	    	ON proposal.prp_va_notice_of_value_source_type = va_notice_of_value_source_type.code
	    JOIN (
	        SELECT *
	        FROM (
	            SELECT <<va_past_credit_record_type_partial_load_condition>> AS include_record
	            	, va_past_credit_record_type.*
	            	, etl_log.etl_end_date_time
	            FROM history_octane.va_past_credit_record_type
	            	LEFT JOIN history_octane.va_past_credit_record_type AS history_records
	            		ON va_past_credit_record_type.code = history_records.code
	            			AND va_past_credit_record_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	            	JOIN star_common.etl_log
	            		ON va_past_credit_record_type.etl_batch_id = etl_log.etl_batch_id
	            WHERE history_records.code IS NULL
			) AS primary_table
		) AS va_past_credit_record_type
	    	ON proposal.prp_va_past_credit_record_type = va_past_credit_record_type.code
	    JOIN (
	        SELECT *
	        FROM (
	            SELECT <<yes_no_na_type_partial_load_condition>> AS include_record
	            	, yes_no_na_type.*
	            	, etl_log.etl_end_date_time
	            FROM history_octane.yes_no_na_type
	            	LEFT JOIN history_octane.yes_no_na_type AS history_records
	            		ON yes_no_na_type.code = history_records.code
	            			AND yes_no_na_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	            	JOIN star_common.etl_log
	            		ON yes_no_na_type.etl_batch_id = etl_log.etl_batch_id
	            WHERE history_records.code IS NULL
				) AS primary_table
			) AS cema_ynna_type
	    		ON proposal.prp_cema = cema_ynna_type.code
	    JOIN (
	        SELECT *
	        FROM (
	            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
	            	, yes_no_unknown_type.*
	            	, etl_log.etl_end_date_time
	            FROM history_octane.yes_no_unknown_type
	            	LEFT JOIN history_octane.yes_no_unknown_type AS history_records
	            		ON yes_no_unknown_type.code = history_records.code
	            			AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
	            	JOIN star_common.etl_log
	            		ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
	            WHERE history_records.code IS NULL
			) AS primary_table
		) AS fha_eligible_maximum_financing_ynu_type
	    		ON proposal.prp_fha_eligible_maximum_financing = fha_eligible_maximum_financing_ynu_type.code
		JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS usda_gsa_sam_exclusion_ynu_type
	    	ON proposal.prp_usda_gsa_sam_exclusion = usda_gsa_sam_exclusion_ynu_type.code
		JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS va_meets_credit_standards_ynu_type
	    	ON proposal.prp_va_meets_credit_standards = va_meets_credit_standards_ynu_type.code
		JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS va_monthly_utilities_included_ynu_type
	    	ON proposal.prp_va_monthly_utilities_included = va_monthly_utilities_included_ynu_type.code
		JOIN (
			SELECT <<transaction_dim_partial_load_condition>> AS include_record
				, transaction_dim.*
				, etl_log.etl_end_date_time
			FROM star_loan.transaction_dim
				JOIN star_common.etl_log
					ON transaction_dim.etl_batch_id = etl_log.etl_batch_id
		) AS transaction_dim
			ON deal.d_pid = transaction_dim.deal_pid
    WHERE GREATEST(deal.include_record, proposal.include_record, fha_non_arms_length_ltv_limit_exception_type
		.include_record, hud_fha_de_approval_type.include_record, usda_rd_single_family_housing_type
					   .include_record, va_notice_of_value_source_type.include_record, va_past_credit_record_type
					   .include_record, cema_ynna_type.include_record, fha_eligible_maximum_financing_ynu_type
					   .include_record, usda_gsa_sam_exclusion_ynu_type.include_record,
				   va_meets_credit_standards_ynu_type.include_record, va_monthly_utilities_included_ynu_type
					   .include_record, transaction_dim.include_record) IS TRUE
)
-- new records that should be inserted
SELECT transaction_aux_govt_programs_dim_incl_new_records.*
FROM transaction_aux_govt_programs_dim_incl_new_records
LEFT JOIN star_loan.transaction_aux_govt_programs_dim
	ON transaction_aux_govt_programs_dim_incl_new_records.data_source_integration_id =
	   transaction_aux_govt_programs_dim.data_source_integration_id
WHERE transaction_aux_govt_programs_dim.transaction_dwid IS NULL
UNION ALL
-- existing records that need to be updated
SELECT transaction_aux_govt_programs_dim_incl_new_records.*
FROM transaction_aux_govt_programs_dim_incl_new_records
JOIN (
    SELECT transaction_aux_govt_programs_dim.data_source_integration_id
    	, etl_log.etl_start_date_time
    FROM star_loan.transaction_aux_govt_programs_dim
    	JOIN star_common.etl_log
    		ON transaction_aux_govt_programs_dim.etl_batch_id = etl_log.etl_batch_id
		) AS transaction_aux_govt_programs_dim_etl_start_times
		ON transaction_aux_govt_programs_dim_incl_new_records.data_source_integration_id =
		   transaction_aux_govt_programs_dim_etl_start_times.data_source_integration_id
			AND transaction_aux_govt_programs_dim_incl_new_records.max_source_etl_end_date_time >=
			    transaction_aux_govt_programs_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
		, ('ETL-200029', 1, 'WITH transaction_aux_property_repairs_dim_incl_new_records AS (
	SELECT ''deal_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
		, COALESCE(CAST(deal.d_pid AS TEXT), ''<NULL>'') || ''~'' ||
		  COALESCE(CAST(1 AS TEXT), ''<NULL>'') AS data_source_integration_id
		, NOW() AS edw_created_datetime
		, NOW() AS edw_modified_datetime
		, proposal.data_source_updated_datetime AS data_source_modified_datetime
		, transaction_dim.dwid AS transaction_dwid
		, deal.d_pid AS deal_pid
		, proposal.prp_pid AS active_proposal_pid
		, proposal.prp_property_repairs_completed_notification_date AS property_repairs_completed_notification_date
		, proposal.prp_property_repairs_funds_released_contractor_date AS property_repairs_funds_released_contractor_date
		, proposal.prp_property_repairs_holdback_required_completion_date AS property_repairs_holdback_required_completion_date
		, proposal.prp_property_repairs_inspection_completed_date AS property_repairs_inspection_completed_date
		, proposal.prp_property_repairs_inspection_ordered_date AS property_repairs_inspection_ordered_date
		, proposal.prp_property_repairs_cost_amount AS property_repairs_cost_amount
		, proposal.prp_property_repairs_holdback_amount AS property_repairs_holdback_amount
		, proposal.prp_property_repairs_description AS property_repairs_description
		, proposal.prp_property_repairs_holdback_administrator AS property_repairs_holdback_administrator
		, property_repairs_holdback_calc_type.value AS property_repairs_holdback_calc
		, proposal.prp_property_repairs_holdback_calc_type AS property_repairs_holdback_calc_code
		, property_repairs_holdback_payer_type.value AS property_repairs_holdback_payer
		, proposal.prp_property_repairs_holdback_payer_type AS property_repairs_holdback_payer_code
		, property_repairs_required_type.value AS property_repairs_required
		, proposal.prp_property_repairs_required_type AS property_repairs_required_code
		, GREATEST(deal.etl_end_date_time, proposal.etl_end_date_time, property_repairs_holdback_calc_type
		    .etl_end_date_time, property_repairs_holdback_payer_type.etl_end_date_time,
		    property_repairs_required_type.etl_end_date_time, transaction_dim.etl_end_date_time) AS
		    max_source_etl_end_date_time
	FROM (
		SELECT <<deal_partial_load_condition>> AS include_record
			, deal.*
			, etl_log.etl_end_date_time
		FROM history_octane.deal
			LEFT JOIN history_octane.deal AS history_records
				ON deal.d_pid = history_records.d_pid
					AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
			JOIN star_common.etl_log
				ON deal.etl_batch_id = etl_log.etl_batch_id
		WHERE history_records.d_pid IS NULL
	) AS deal
		JOIN (
			SELECT *
			FROM (
				SELECT <<proposal_partial_load_condition>> AS include_record
					, proposal.*
					, etl_log.etl_end_date_time
				FROM history_octane.proposal
					LEFT JOIN history_octane.proposal AS history_records
						ON proposal.prp_pid = history_records.prp_pid
							AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON proposal.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.prp_pid IS NULL
			) AS primary_table
		) AS proposal
			ON deal.d_active_proposal_pid = proposal.prp_pid
    	JOIN (
    	    SELECT *
    	    FROM (
    	        SELECT <<property_repairs_holdback_calc_type_partial_load_condition>> AS include_record
    	        	, property_repairs_holdback_calc_type.*
    	        	, etl_log.etl_end_date_time
    	        FROM history_octane.property_repairs_holdback_calc_type
    	        	LEFT JOIN history_octane.property_repairs_holdback_calc_type AS history_records
    	        		ON property_repairs_holdback_calc_type.code = history_records.code
    	        			AND property_repairs_holdback_calc_type.data_source_updated_datetime < history_records.data_source_updated_datetime
    	        	JOIN star_common.etl_log
    	        		ON property_repairs_holdback_calc_type.etl_batch_id = etl_log.etl_batch_id
    	        WHERE history_records.code IS NULL
				) AS primary_table
			) AS property_repairs_holdback_calc_type
    			ON proposal.prp_property_repairs_holdback_calc_type = property_repairs_holdback_calc_type.code
    	JOIN (
    	    SELECT *
    	    FROM (
    	        SELECT <<property_repairs_holdback_payer_type_partial_load_condition>> AS include_record
    	        	, property_repairs_holdback_payer_type.*
    	        	, etl_log.etl_end_date_time
    	        FROM history_octane.property_repairs_holdback_payer_type
    	        	LEFT JOIN history_octane.property_repairs_holdback_payer_type AS history_records
    	        		ON property_repairs_holdback_payer_type.code = history_records.code
    	        			AND property_repairs_holdback_payer_type.data_source_updated_datetime < history_records.data_source_updated_datetime
    	        	JOIN star_common.etl_log
    	        		ON property_repairs_holdback_payer_type.etl_batch_id = etl_log.etl_batch_id
    	        WHERE history_records.code IS NULL
				) AS primary_table
			) AS property_repairs_holdback_payer_type
    			ON proposal.prp_property_repairs_holdback_payer_type = property_repairs_holdback_payer_type.code
    	JOIN (
    	    SELECT *
    	    FROM (
    	        SELECT <<property_repairs_required_type_partial_load_condition>> AS include_record
    	        	, property_repairs_required_type.*
    	        	, etl_log.etl_end_date_time
    	        FROM history_octane.property_repairs_required_type
    	        	LEFT JOIN history_octane.property_repairs_required_type AS history_records
    	        		ON property_repairs_required_type.code = history_records.code
    	        			AND property_repairs_required_type.data_source_updated_datetime < history_records.data_source_updated_datetime
    	        	JOIN star_common.etl_log
    	        		ON property_repairs_required_type.etl_batch_id = etl_log.etl_batch_id
    	        WHERE history_records.code IS NULL
				) AS primary_table
			) AS property_repairs_required_type
    			ON proposal.prp_property_repairs_required_type = property_repairs_required_type.code
		JOIN (
			SELECT <<transaction_dim_partial_load_condition>> AS include_record
				, transaction_dim.*
				, etl_log.etl_end_date_time
			FROM star_loan.transaction_dim
				JOIN star_common.etl_log
					ON transaction_dim.etl_batch_id = etl_log.etl_batch_id
			) AS transaction_dim
				ON deal.d_pid = transaction_dim.deal_pid
    WHERE GREATEST(deal.include_record, proposal.include_record, property_repairs_holdback_calc_type
		.include_record, property_repairs_holdback_payer_type.include_record,
				   property_repairs_required_type.include_record, transaction_dim.include_record) IS TRUE
)
-- new records that should be inserted
SELECT transaction_aux_property_repairs_dim_incl_new_records.*
FROM transaction_aux_property_repairs_dim_incl_new_records
LEFT JOIN star_loan.transaction_aux_property_repairs_dim
	ON transaction_aux_property_repairs_dim_incl_new_records.data_source_integration_id =
	   transaction_aux_property_repairs_dim.data_source_integration_id
WHERE transaction_aux_property_repairs_dim.transaction_dwid IS NULL
UNION ALL
-- existing records that need to be updated
SELECT transaction_aux_property_repairs_dim_incl_new_records.*
FROM transaction_aux_property_repairs_dim_incl_new_records
JOIN (
    SELECT transaction_aux_property_repairs_dim.data_source_integration_id
    	, etl_log.etl_start_date_time
    FROM star_loan.transaction_aux_property_repairs_dim
    	JOIN star_common.etl_log
    		ON transaction_aux_property_repairs_dim.etl_batch_id = etl_log.etl_batch_id
		) AS transaction_aux_property_repairs_dim_etl_start_times
		ON transaction_aux_property_repairs_dim_incl_new_records.data_source_integration_id =
		   transaction_aux_property_repairs_dim_etl_start_times.data_source_integration_id
			AND transaction_aux_property_repairs_dim_incl_new_records.max_source_etl_end_date_time >=
			    transaction_aux_property_repairs_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
		, ('ETL-200025', 1, 'WITH underwrite_dim_new_records AS (
    SELECT ''underwrite_disposition_code~'' ||
           ''underwrite_method_code~'' ||
           ''underwrite_risk_assessment_code~'' ||
           ''data_source_dwid'' AS data_source_integration_columns
    	, COALESCE(CAST(proposal.prp_underwrite_disposition_type AS TEXT), ''<NULL>'') || ''~'' ||
    	  COALESCE(CAST(proposal.prp_underwrite_method_type AS TEXT), ''<NULL>'') || ''~'' ||
    	  COALESCE(CAST(proposal.prp_underwrite_risk_assessment_type AS TEXT), ''<NULL>'') || ''~'' ||
    	  COALESCE(CAST(1 AS TEXT), ''<NULL>'') AS data_source_integration_id
    	, NOW() AS edw_created_datetime
    	, NOW() AS edw_modified_datetime
    	, MAX(proposal.data_source_updated_datetime) AS data_source_modified_datetime
    	, underwrite_disposition_type.value AS underwrite_disposition
    	, proposal.prp_underwrite_disposition_type AS underwrite_disposition_code
    	, underwrite_method_type.value AS underwrite_method
    	, proposal.prp_underwrite_method_type AS underwrite_method_code
    	, underwrite_risk_assessment_type.value AS underwrite_risk_assessment
    	, proposal.prp_underwrite_risk_assessment_type AS underwrite_risk_assessment_code
    	, MAX(GREATEST(underwrite_disposition_type.etl_end_date_time, underwrite_method_type.etl_end_date_time,
    	    underwrite_risk_assessment_type.etl_end_date_time)) AS max_source_etl_end_date_time
    FROM (
		 SELECT <<proposal_partial_load_condition>> AS include_record
			, proposal.*
		 FROM history_octane.proposal
		 LEFT JOIN history_octane.proposal AS history_records
			ON proposal.prp_pid = history_records.prp_pid
				AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
         WHERE history_records.prp_pid IS NULL
	) AS proposal
    JOIN (
        SELECT *
        FROM (
             SELECT <<underwrite_disposition_type_partial_load_condition>> AS include_record
            	, underwrite_disposition_type.*
            	, etl_log.etl_end_date_time
            FROM history_octane.underwrite_disposition_type
            LEFT JOIN history_octane.underwrite_disposition_type AS history_records
            	ON underwrite_disposition_type.code = history_records.code
            		AND underwrite_disposition_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
            	ON underwrite_disposition_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
		) AS primary_table
	) AS underwrite_disposition_type
    	ON proposal.prp_underwrite_disposition_type = underwrite_disposition_type.code
    JOIN (
        SELECT *
        FROM (
             SELECT <<underwrite_method_type_partial_load_condition>> AS include_record
            	, underwrite_method_type.*
            	, etl_log.etl_end_date_time
             FROM history_octane.underwrite_method_type
             LEFT JOIN history_octane.underwrite_method_type AS history_records
             	ON underwrite_method_type.code = history_records.code
             		AND underwrite_method_type.data_source_updated_datetime < history_records.data_source_updated_datetime
             JOIN star_common.etl_log
             	ON underwrite_method_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
		) AS primary_table
	) AS underwrite_method_type
    	ON proposal.prp_underwrite_method_type = underwrite_method_type.code
    JOIN (
        SELECT *
        FROM (
            SELECT <<underwrite_risk_assessment_type_partial_load_condition>> AS include_record
            	, underwrite_risk_assessment_type.*
            	, etl_log.etl_end_date_time
            FROM history_octane.underwrite_risk_assessment_type
            LEFT JOIN history_octane.underwrite_risk_assessment_type AS history_records
            	ON underwrite_risk_assessment_type.code = history_records.code
            		AND underwrite_risk_assessment_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
            	ON underwrite_risk_assessment_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
		) AS primary_table
	) AS underwrite_risk_assessment_type
    	ON proposal.prp_underwrite_risk_assessment_type = underwrite_risk_assessment_type.code
    WHERE GREATEST(proposal.include_record, underwrite_disposition_type.include_record, underwrite_method_type
        .include_record, underwrite_risk_assessment_type.include_record) IS TRUE
    GROUP BY underwrite_disposition_type.value
    	, proposal.prp_underwrite_disposition_type
    	, underwrite_method_type.value
    	, proposal.prp_underwrite_method_type
    	, underwrite_risk_assessment_type.value
    	, proposal.prp_underwrite_risk_assessment_type
)
-- new records that should be inserted
SELECT underwrite_dim_new_records.*
FROM underwrite_dim_new_records
LEFT JOIN star_loan.underwrite_dim
	ON underwrite_dim_new_records.data_source_integration_id = underwrite_dim.data_source_integration_id
WHERE underwrite_dim.dwid IS NULL
UNION ALL
-- existing records that should be updated
SELECT underwrite_dim_new_records.*
FROM underwrite_dim_new_records
JOIN (
    SELECT underwrite_dim.data_source_integration_id
    	, etl_log.etl_start_date_time
    FROM star_loan.underwrite_dim
    	JOIN star_common.etl_log
    		ON underwrite_dim.etl_batch_id = etl_log.etl_batch_id
	) AS underwrite_dim_etl_start_times
	ON underwrite_dim_new_records.data_source_integration_id = underwrite_dim_etl_start_times.data_source_integration_id
		AND underwrite_dim_new_records.max_source_etl_end_date_time >= underwrite_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
)
INSERT
INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
SELECT process.dwid, insert_rows.data_source_dwid, insert_rows.sql, 0, 'N', 'N', 'N', 'N', insert_rows.connectionname::mdi.pentaho_db_connection_name
FROM insert_rows
	JOIN mdi.process
		ON process.name = insert_rows.process_name;

--insert_update_step
WITH insert_rows (process_name, connectionname, schema_name, table_name) AS (
	VALUES ('ETL-200023', 'Staging DB Connection', 'star_loan', 'cash_out_reason_dim')
		, ('ETL-200024', 'Staging DB Connection', 'star_loan', 'hmda_action_dim')
		, ('ETL-200026', 'Staging DB Connection', 'star_loan', 'transaction_aux_construction_dim')
		, ('ETL-200027', 'Staging DB Connection', 'star_loan', 'transaction_aux_disaster_declaration_dim')
		, ('ETL-200028', 'Staging DB Connection', 'star_loan', 'transaction_aux_govt_programs_dim')
		, ('ETL-200029', 'Staging DB Connection', 'star_loan', 'transaction_aux_property_repairs_dim')
		, ('ETL-200025', 'Staging DB Connection', 'star_loan', 'underwrite_dim')
)
INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)
SELECT process.dwid, insert_rows.connectionname, insert_rows.schema_name, insert_rows.table_name, 1000, 'N'::mdi.pentaho_y_or_n
FROM insert_rows
	JOIN mdi.process
		ON process.name = insert_rows.process_name;

--insert_update_key
WITH insert_rows (process_name, key_lookup) AS (
	VALUES ('ETL-200023', 'data_source_integration_id')
		, ('ETL-200024', 'data_source_integration_id')
		, ('ETL-200026', 'data_source_integration_id')
		, ('ETL-200027', 'data_source_integration_id')
		, ('ETL-200028', 'data_source_integration_id')
		, ('ETL-200029', 'data_source_integration_id')
		, ('ETL-200025', 'data_source_integration_id')
)
INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_stream2, key_condition)
SELECT insert_update_step.dwid, insert_rows.key_lookup, insert_rows.key_lookup, NULL, '='
FROM insert_rows
	JOIN mdi.process
		ON process.name = insert_rows.process_name
	JOIN mdi.insert_update_step
		ON process.dwid = insert_update_step.process_dwid;

--insert_update_field
WITH insert_rows (process_name, update_lookup, update_flag) AS (
	VALUES ('ETL-200023', 'data_source_dwid', 'N')
		, ('ETL-200023', 'edw_created_datetime', 'N')
		, ('ETL-200023', 'edw_modified_datetime', 'Y')
		, ('ETL-200023', 'etl_batch_id', 'Y')
		, ('ETL-200023', 'data_source_integration_columns', 'N')
		, ('ETL-200023', 'data_source_integration_id', 'N')
		, ('ETL-200023', 'data_source_modified_datetime', 'Y')
		, ('ETL-200023', 'cash_out_reason_business_debt_or_debt_consolidation_flag', 'N')
		, ('ETL-200023', 'cash_out_reason_debt_or_debt_consolidation_flag', 'N')
		, ('ETL-200023', 'cash_out_reason_future_investment_not_under_contract_flag', 'N')
		, ('ETL-200023', 'cash_out_reason_future_investment_under_contract_flag', 'N')
		, ('ETL-200023', 'cash_out_reason_home_improvement_flag', 'N')
		, ('ETL-200023', 'cash_out_reason_investment_or_business_property_flag', 'N')
		, ('ETL-200023', 'cash_out_reason_other_flag', 'N')
		, ('ETL-200023', 'cash_out_reason_personal_use_flag', 'N')
		, ('ETL-200023', 'cash_out_reason_student_loans_flag', 'N')
		, ('ETL-200023', 'non_business_cash_out_reason_acknowledged', 'Y')
		, ('ETL-200023', 'non_business_cash_out_reason_acknowledged_code', 'N')
		, ('ETL-200024', 'data_source_dwid', 'N')
		, ('ETL-200024', 'edw_created_datetime', 'N')
		, ('ETL-200024', 'edw_modified_datetime', 'Y')
		, ('ETL-200024', 'etl_batch_id', 'Y')
		, ('ETL-200024', 'data_source_integration_columns', 'N')
		, ('ETL-200024', 'data_source_integration_id', 'N')
		, ('ETL-200024', 'data_source_modified_datetime', 'Y')
		, ('ETL-200024', 'hmda_action', 'Y')
		, ('ETL-200024', 'hmda_action_code', 'N')
		, ('ETL-200024', 'hmda_denial_reason_1', 'Y')
		, ('ETL-200024', 'hmda_denial_reason_2', 'Y')
		, ('ETL-200024', 'hmda_denial_reason_3', 'Y')
		, ('ETL-200024', 'hmda_denial_reason_4', 'Y')
		, ('ETL-200024', 'hmda_denial_reason_code_1', 'N')
		, ('ETL-200024', 'hmda_denial_reason_code_2', 'N')
		, ('ETL-200024', 'hmda_denial_reason_code_3', 'N')
		, ('ETL-200024', 'hmda_denial_reason_code_4', 'N')
		, ('ETL-300001-insert-update', 'cd_clear_date_dwid', 'Y')
		, ('ETL-300001-insert-update', 'charges_enabled_date_dwid', 'Y')
		, ('ETL-300001-insert-update', 'effective_earliest_allowed_consummation_date_dwid', 'Y')
		, ('ETL-300001-insert-update', 'effective_hmda_action_date_dwid', 'Y')
		, ('ETL-300001-insert-update', 'effective_note_date_dwid', 'Y')
		, ('ETL-300001-insert-update', 'hmda_action_date_dwid', 'Y')
		, ('ETL-300001-insert-update', 'initial_cancel_status_date_dwid', 'Y')
		, ('ETL-300001-insert-update', 'initial_uw_disposition_date_dwid', 'Y')
		, ('ETL-300001-insert-update', 'initial_uw_submit_date_dwid', 'Y')
		, ('ETL-300001-insert-update', 'note_date_dwid', 'Y')
		, ('ETL-300001-insert-update', 'preapproval_uw_submit_date_dwid', 'Y')
		, ('ETL-300001-insert-update', 'transaction_create_date_dwid', 'Y')
		, ('ETL-300001-insert-update', 'transaction_welcome_call_date_dwid', 'Y')
		, ('ETL-300001-insert-update', 'trid_application_date_dwid', 'Y')
		, ('ETL-300001-insert-update', 'underwrite_publish_date_dwid', 'Y')
		, ('ETL-300001-insert-update', 'cash_out_reason_dwid', 'Y')
		, ('ETL-300001-insert-update', 'hmda_action_dwid', 'Y')
		, ('ETL-300001-insert-update', 'underwrite_dwid', 'Y')
		, ('ETL-200026', 'transaction_dwid', 'Y')
		, ('ETL-200026', 'data_source_dwid', 'Y')
		, ('ETL-200026', 'edw_created_datetime', 'N')
		, ('ETL-200026', 'edw_modified_datetime', 'Y')
		, ('ETL-200026', 'etl_batch_id', 'Y')
		, ('ETL-200026', 'data_source_integration_columns', 'N')
		, ('ETL-200026', 'data_source_integration_id', 'N')
		, ('ETL-200026', 'data_source_modified_datetime', 'Y')
		, ('ETL-200026', 'deal_pid', 'Y')
		, ('ETL-200026', 'active_proposal_pid', 'Y')
		, ('ETL-200026', 'financed_property_improvements_flag', 'Y')
		, ('ETL-200026', 'loan_modification_agreement_executed_received_datetime', 'Y')
		, ('ETL-200026', 'adjusted_as_is_value_amount', 'Y')
		, ('ETL-200026', 'after_improved_value_amount', 'Y')
		, ('ETL-200026', 'construction_borrower_contribution_amount', 'Y')
		, ('ETL-200026', 'estimated_hard_construction_cost_amount', 'Y')
		, ('ETL-200026', 'cr_tracker_url', 'Y')
		, ('ETL-200026', 'construction_lot_ownership_status', 'Y')
		, ('ETL-200026', 'construction_lot_ownership_status_code', 'Y')
		, ('ETL-200026', 'financed_property_improvements_category', 'Y')
		, ('ETL-200026', 'financed_property_improvements_category_code', 'N')
		, ('ETL-200027', 'transaction_dwid', 'Y')
		, ('ETL-200027', 'data_source_dwid', 'Y')
		, ('ETL-200027', 'edw_created_datetime', 'N')
		, ('ETL-200027', 'edw_modified_datetime', 'Y')
		, ('ETL-200027', 'etl_batch_id', 'Y')
		, ('ETL-200027', 'data_source_integration_columns', 'N')
		, ('ETL-200027', 'data_source_integration_id', 'N')
		, ('ETL-200027', 'data_source_modified_datetime', 'Y')
		, ('ETL-200027', 'deal_pid', 'Y')
		, ('ETL-200027', 'active_proposal_pid', 'Y')
		, ('ETL-200027', 'any_disaster_declaration_after_appraisal_flag', 'Y')
		, ('ETL-200027', 'any_disaster_declaration_before_appraisal_flag', 'Y')
		, ('ETL-200027', 'any_disaster_declaration_flag', 'Y')
		, ('ETL-200027', 'disaster_declaration_check_date', 'Y')
		, ('ETL-200027', 'disaster_declaration_check_date_type', 'Y')
		, ('ETL-200027', 'disaster_declaration_check_date_type_code', 'Y')
		, ('ETL-200028', 'transaction_dwid', 'Y')
		, ('ETL-200028', 'data_source_dwid', 'Y')
		, ('ETL-200028', 'edw_created_datetime', 'N')
		, ('ETL-200028', 'edw_modified_datetime', 'Y')
		, ('ETL-200028', 'etl_batch_id', 'Y')
		, ('ETL-200028', 'data_source_integration_columns', 'N')
		, ('ETL-200028', 'data_source_integration_id', 'N')
		, ('ETL-200028', 'data_source_modified_datetime', 'Y')
		, ('ETL-200028', 'deal_pid', 'Y')
		, ('ETL-200028', 'active_proposal_pid', 'Y')
		, ('ETL-200028', 'fha_mip_refund_request_input_error_flag', 'Y')
		, ('ETL-200028', 'fha_non_arms_length_ltv_exception_verified_flag', 'N')
		, ('ETL-200028', 'request_fha_mip_refund_required_flag', 'Y')
		, ('ETL-200028', 'texas_equity_conversion_determination_datetime_override_flag', 'Y')
		, ('ETL-200028', 'texas_equity_determination_datetime_override_flag', 'Y')
		, ('ETL-200028', 'va_maintenance_utilities_auto_compute_flag', 'Y')
		, ('ETL-200028', 'fha_prior_agency_case_endorsement_date', 'Y')
		, ('ETL-200028', 'fha_refinance_authorization_expiration_date', 'Y')
		, ('ETL-200028', 'texas_equity_determination_datetime', 'Y')
		, ('ETL-200028', 'usda_gsa_sam_checked_date', 'Y')
		, ('ETL-200028', 'va_notice_of_value_date', 'Y')
		, ('ETL-200028', 'cema_borrower_savings', 'Y')
		, ('ETL-200028', 'fha_va_reasonable_value_amount', 'Y')
		, ('ETL-200028', 'va_actual_guaranty_amount', 'Y')
		, ('ETL-200028', 'va_amount_used_to_calculate_maximum_guaranty', 'Y')
		, ('ETL-200028', 'va_energy_efficient_improvements_amount', 'Y')
		, ('ETL-200028', 'va_guaranty_percent', 'Y')
		, ('ETL-200028', 'va_maintenance_utilities_per_square_feet_amount', 'Y')
		, ('ETL-200028', 'va_maximum_base_loan_amount', 'Y')
		, ('ETL-200028', 'va_maximum_funding_fee_amount', 'Y')
		, ('ETL-200028', 'va_maximum_total_loan_amount', 'Y')
		, ('ETL-200028', 'va_monthly_maintenance_utilities_amount', 'Y')
		, ('ETL-200028', 'va_notice_of_value_estimated_reasonable_value_amount', 'Y')
		, ('ETL-200028', 'va_required_cash_amount', 'Y')
		, ('ETL-200028', 'va_required_guaranty_amount', 'Y')
		, ('ETL-200028', 'fha_prior_agency_case_id', 'Y')
		, ('ETL-200028', 'fha_refinance_authorization_number', 'Y')
		, ('ETL-200028', 'fhac_refinance_authorization_messages', 'Y')
		, ('ETL-200028', 'texas_equity_conversion_determ_datetime_override_reason', 'Y')
		, ('ETL-200028', 'texas_equity_determination_datetime_override_reason', 'Y')
		, ('ETL-200028', 'va_prior_paid_in_full_loan_number', 'Y')
		, ('ETL-200028', 'fha_non_arms_length_ltv_exception', 'Y')
		, ('ETL-200028', 'fha_non_arms_length_ltv_exception_code', 'Y')
		, ('ETL-200028', 'hud_fha_de_approval', 'Y')
		, ('ETL-200028', 'hud_fha_de_approval_code', 'Y')
		, ('ETL-200028', 'usda_rd_single_family_housing', 'Y')
		, ('ETL-200028', 'usda_rd_single_family_housing_code', 'Y')
		, ('ETL-200028', 'va_notice_of_value_source', 'Y')
		, ('ETL-200028', 'va_notice_of_value_source_code', 'Y')
		, ('ETL-200028', 'va_past_credit_record', 'Y')
		, ('ETL-200028', 'va_past_credit_record_code', 'Y')
		, ('ETL-200028', 'cema', 'Y')
		, ('ETL-200028', 'cema_code', 'Y')
		, ('ETL-200028', 'fha_eligible_maximum_financing', 'Y')
		, ('ETL-200028', 'fha_eligible_maximum_financing_code', 'Y')
		, ('ETL-200028', 'usda_gsa_sam_exclusion', 'Y')
		, ('ETL-200028', 'usda_gsa_sam_exclusion_code', 'Y')
		, ('ETL-200028', 'va_meets_credit_standards', 'Y')
		, ('ETL-200028', 'va_meets_credit_standards_code', 'Y')
		, ('ETL-200028', 'va_monthly_utilities_included', 'Y')
		, ('ETL-200028', 'va_monthly_utilities_included_code', 'Y')
		, ('ETL-200029', 'transaction_dwid', 'Y')
		, ('ETL-200029', 'data_source_dwid', 'Y')
		, ('ETL-200029', 'edw_created_datetime', 'N')
		, ('ETL-200029', 'edw_modified_datetime', 'Y')
		, ('ETL-200029', 'etl_batch_id', 'Y')
		, ('ETL-200029', 'data_source_integration_columns', 'N')
		, ('ETL-200029', 'data_source_integration_id', 'N')
		, ('ETL-200029', 'data_source_modified_datetime', 'Y')
		, ('ETL-200029', 'deal_pid', 'Y')
		, ('ETL-200029', 'active_proposal_pid', 'Y')
		, ('ETL-200029', 'property_repairs_completed_notification_date', 'Y')
		, ('ETL-200029', 'property_repairs_funds_released_contractor_date', 'Y')
		, ('ETL-200029', 'property_repairs_holdback_required_completion_date', 'Y')
		, ('ETL-200029', 'property_repairs_inspection_completed_date', 'Y')
		, ('ETL-200029', 'property_repairs_inspection_ordered_date', 'Y')
		, ('ETL-200029', 'property_repairs_cost_amount', 'Y')
		, ('ETL-200029', 'property_repairs_holdback_amount', 'Y')
		, ('ETL-200029', 'property_repairs_description', 'Y')
		, ('ETL-200029', 'property_repairs_holdback_administrator', 'Y')
		, ('ETL-200029', 'property_repairs_holdback_calc', 'Y')
		, ('ETL-200029', 'property_repairs_holdback_calc_code', 'Y')
		, ('ETL-200029', 'property_repairs_holdback_payer', 'Y')
		, ('ETL-200029', 'property_repairs_holdback_payer_code', 'Y')
		, ('ETL-200029', 'property_repairs_required', 'Y')
		, ('ETL-200029', 'property_repairs_required_code', 'Y')
		, ('ETL-200019', 'borrower_esign_flag', 'Y')
		, ('ETL-200019', 'deed_taxes_applicable_flag', 'Y')
		, ('ETL-200019', 'deed_taxes_auto_compute_flag', 'Y')
		, ('ETL-200019', 'delayed_financing_exception_guidelines_applicable_flag', 'Y')
		, ('ETL-200019', 'delayed_financing_exception_verified_flag', 'Y')
		, ('ETL-200019', 'down_payment_percent_mode_flag', 'Y')
		, ('ETL-200019', 'early_wire_request_flag', 'Y')
		, ('ETL-200019', 'enable_electronic_transaction_flag', 'Y')
		, ('ETL-200019', 'escrow_cushion_months_auto_compute_flag', 'Y')
		, ('ETL-200019', 'first_payment_date_auto_compute_flag', 'Y')
		, ('ETL-200019', 'household_income_exclusive_edit_flag', 'Y')
		, ('ETL-200019', 'intent_to_proceed_provided_flag', 'Y')
		, ('ETL-200019', 'invoices_enabled_flag', 'Y')
		, ('ETL-200019', 'ipc_auto_compute_flag', 'Y')
		, ('ETL-200019', 'minimum_residual_income_auto_compute_flag', 'Y')
		, ('ETL-200019', 'other_lender_requires_appraisal_flag', 'Y')
		, ('ETL-200019', 'owner_occupancy_not_required_flag', 'Y')
		, ('ETL-200019', 'property_taxes_request_input_error_flag', 'Y')
		, ('ETL-200019', 'publish_flag', 'Y')
		, ('ETL-200019', 'recording_fees_request_input_error_flag', 'Y')
		, ('ETL-200019', 'request_property_taxes_required_flag', 'Y')
		, ('ETL-200019', 'request_recording_fees_required_flag', 'Y')
		, ('ETL-200019', 'rescission_applicable_flag', 'Y')
		, ('ETL-200019', 'reserves_auto_compute_flag', 'Y')
		, ('ETL-200019', 'sap_deal_flag', 'Y')
		, ('ETL-200019', 'sar_significant_adjustments_flag', 'Y')
		, ('ETL-200019', 'smart_charges_enabled_flag', 'Y')
		, ('ETL-200019', 'smart_docs_enabled_flag', 'Y')
		, ('ETL-200019', 'training_loan_flag', 'Y')
		, ('ETL-200019', 'active_proposal_publish_date', 'Y')
		, ('ETL-200019', 'calculated_earliest_allowed_consummation_date', 'Y')
		, ('ETL-200019', 'charges_updated_datetime', 'Y')
		, ('ETL-200019', 'closing_document_sign_datetime', 'Y')
		, ('ETL-200019', 'docs_enabled_datetime', 'Y')
		, ('ETL-200019', 'ecoa_application_complete_date', 'Y')
		, ('ETL-200019', 'ecoa_application_received_date', 'Y')
		, ('ETL-200019', 'ecoa_decision_due_date', 'Y')
		, ('ETL-200019', 'ecoa_notice_of_incomplete_date', 'Y')
		, ('ETL-200019', 'ecoa_notice_of_incomplete_due_date', 'Y')
		, ('ETL-200019', 'effective_earliest_allowed_consummation_date', 'Y')
		, ('ETL-200019', 'first_payment_date', 'Y')
		, ('ETL-200019', 'fre_ctp_first_payment_due_date', 'Y')
		, ('ETL-200019', 'gfe_interest_rate_expiration_date', 'Y')
		, ('ETL-200019', 'initial_uw_disposition_datetime', 'Y')
		, ('ETL-200019', 'initial_uw_submit_datetime', 'Y')
		, ('ETL-200019', 'invoices_enabled_date', 'Y')
		, ('ETL-200019', 'land_acquisition_transaction_date', 'Y')
		, ('ETL-200019', 'last_corrective_disclosure_processed_datetime', 'Y')
		, ('ETL-200019', 'last_requested_disclosure_date', 'Y')
		, ('ETL-200019', 'lender_escrow_loan_due_date', 'Y')
		, ('ETL-200019', 'overridden_earliest_allowed_consummation_date', 'Y')
		, ('ETL-200019', 'preapproval_uw_disposition_datetime', 'Y')
		, ('ETL-200019', 'preapproval_uw_submit_datetime', 'Y')
		, ('ETL-200019', 'proposal_expiration_date', 'Y')
		, ('ETL-200019', 'purchase_contract_date', 'Y')
		, ('ETL-200019', 'purchase_contract_financing_contingency_date', 'Y')
		, ('ETL-200019', 'purchase_contract_funding_date', 'Y')
		, ('ETL-200019', 'purchase_contract_received_date', 'Y')
		, ('ETL-200019', 'rescission_effective_date', 'Y')
		, ('ETL-200019', 'rescission_notification_date', 'Y')
		, ('ETL-200019', 'rescission_through_date', 'Y')
		, ('ETL-200019', 'scheduled_closing_document_sign_datetime', 'Y')
		, ('ETL-200019', 'signed_closing_doc_received_datetime', 'Y')
		, ('ETL-200019', 'transaction_deal_create_datetime', 'Y')
		, ('ETL-200019', 'transaction_orphan_earliest_check_date', 'Y')
		, ('ETL-200019', 'transaction_proposal_create_datetime', 'Y')
		, ('ETL-200019', 'transaction_status_date', 'Y')
		, ('ETL-200019', 'transaction_welcome_call_datetime', 'Y')
		, ('ETL-200019', 'underwrite_expiration_date', 'Y')
		, ('ETL-200019', 'user_entered_note_date', 'Y')
		, ('ETL-200019', 'anti_steering_lowest_cost_option_fee_amount', 'Y')
		, ('ETL-200019', 'anti_steering_lowest_cost_option_rate_percent', 'Y')
		, ('ETL-200019', 'anti_steering_lowest_rate_option_fee_amount', 'Y')
		, ('ETL-200019', 'anti_steering_lowest_rate_option_rate_percent', 'Y')
		, ('ETL-200019', 'anti_steering_lowest_rate_wo_neg_option_fee_amount', 'Y')
		, ('ETL-200019', 'anti_steering_lowest_rate_wo_neg_option_rate_percent', 'Y')
		, ('ETL-200019', 'area_median_income', 'Y')
		, ('ETL-200019', 'decision_appraised_value_amount', 'Y')
		, ('ETL-200019', 'decision_credit_score', 'Y')
		, ('ETL-200019', 'down_payment_percent', 'Y')
		, ('ETL-200019', 'effective_credit_score', 'Y')
		, ('ETL-200019', 'effective_property_value_amount', 'Y')
		, ('ETL-200019', 'escrow_cushion_months', 'Y')
		, ('ETL-200019', 'estimated_credit_score', 'Y')
		, ('ETL-200019', 'estimated_property_value_amount', 'Y')
		, ('ETL-200019', 'gfe_lock_before_settlement_days', 'Y')
		, ('ETL-200019', 'gfe_lock_duration_days', 'Y')
		, ('ETL-200019', 'household_size_count', 'Y')
		, ('ETL-200019', 'ipc_amount', 'Y')
		, ('ETL-200019', 'ipc_financing_concession_amount', 'Y')
		, ('ETL-200019', 'ipc_limit_percent', 'Y')
		, ('ETL-200019', 'ipc_maximum_amount_allowed', 'Y')
		, ('ETL-200019', 'ipc_non_cash_concession_amount', 'Y')
		, ('ETL-200019', 'ipc_percent', 'Y')
		, ('ETL-200019', 'land_acquisition_price', 'Y')
		, ('ETL-200019', 'lender_escrow_loan_amount', 'Y')
		, ('ETL-200019', 'minimum_household_income_amount', 'Y')
		, ('ETL-200019', 'minimum_residual_income_amount', 'Y')
		, ('ETL-200019', 'proposed_additional_monthly_payment', 'Y')
		, ('ETL-200019', 'reserves_amount', 'Y')
		, ('ETL-200019', 'reserves_months', 'Y')
		, ('ETL-200019', 'sale_price_amount', 'Y')
		, ('ETL-200019', 'term_borrower_intends_to_retain_property', 'Y')
		, ('ETL-200019', 'total_income_to_ami_ratio', 'Y')
		, ('ETL-200019', 'active_proposal_description', 'Y')
		, ('ETL-200019', 'active_proposal_name', 'Y')
		, ('ETL-200019', 'calyx_loan_guid', 'Y')
		, ('ETL-200019', 'cash_out_reason_other_text', 'Y')
		, ('ETL-200019', 'copy_source_los_loan_id_main', 'Y')
		, ('ETL-200019', 'copy_source_los_loan_id_piggyback', 'Y')
		, ('ETL-200019', 'deed_taxes_applicable_explanation', 'Y')
		, ('ETL-200019', 'deed_taxes_auto_compute_override_reason', 'Y')
		, ('ETL-200019', 'earliest_allowed_consummation_date_override_reason', 'Y')
		, ('ETL-200019', 'effective_signing_location_city', 'Y')
		, ('ETL-200019', 'external_loan_id_main', 'Y')
		, ('ETL-200019', 'external_loan_id_piggyback', 'Y')
		, ('ETL-200019', 'hmda_denial_reason_other_description', 'Y')
		, ('ETL-200019', 'hmda_universal_loan_id_main', 'Y')
		, ('ETL-200019', 'hmda_universal_loan_id_piggyback', 'Y')
		, ('ETL-200019', 'intent_to_proceed_obtainer_unparsed_name', 'Y')
		, ('ETL-200019', 'intent_to_proceed_provider_unparsed_name', 'Y')
		, ('ETL-200019', 'lead_reference_id', 'Y')
		, ('ETL-200019', 'lead_tracking_id', 'Y')
		, ('ETL-200019', 'lead_zillow_zq', 'Y')
		, ('ETL-200019', 'los_loan_number_main', 'Y')
		, ('ETL-200019', 'los_loan_number_piggyback', 'Y')
		, ('ETL-200019', 'mers_min_main', 'Y')
		, ('ETL-200019', 'mers_min_piggyback', 'Y')
		, ('ETL-200019', 'other_lender_requires_appraisal_reason', 'Y')
		, ('ETL-200019', 'property_tax_request_error_messages', 'Y')
		, ('ETL-200019', 'recsission_notication_by', 'Y')
		, ('ETL-200019', 'referred_by_name', 'Y')
		, ('ETL-200019', 'trustee_address_city', 'Y')
		, ('ETL-200019', 'trustee_address_country', 'Y')
		, ('ETL-200019', 'trustee_address_postal_code', 'Y')
		, ('ETL-200019', 'trustee_address_state', 'Y')
		, ('ETL-200019', 'trustee_address_street1', 'Y')
		, ('ETL-200019', 'trustee_address_street2', 'Y')
		, ('ETL-200019', 'trustee_mers_org_id', 'Y')
		, ('ETL-200019', 'trustee_name', 'Y')
		, ('ETL-200019', 'trustee_phone_number', 'Y')
		, ('ETL-200019', 'underwrite_disposition_note', 'Y')
		, ('ETL-200019', 'underwriting_comments', 'Y')
		, ('ETL-200019', 'uuts_master_contact_name', 'Y')
		, ('ETL-200019', 'uuts_master_contact_title', 'Y')
		, ('ETL-200019', 'uuts_master_office_phone', 'Y')
		, ('ETL-200019', 'uuts_master_office_phone_extension', 'Y')
		, ('ETL-200019', 'velocify_lead_id', 'Y')
		, ('ETL-200019', 'active_proposal_type', 'Y')
		, ('ETL-200019', 'active_proposal_type_code', 'Y')
		, ('ETL-200019', 'application_type', 'Y')
		, ('ETL-200019', 'application_type_code', 'Y')
		, ('ETL-200019', 'credit_bureau', 'Y')
		, ('ETL-200019', 'credit_bureau_code', 'Y')
		, ('ETL-200019', 'disclosure_action', 'Y')
		, ('ETL-200019', 'disclosure_action_code', 'Y')
		, ('ETL-200019', 'doc_level', 'Y')
		, ('ETL-200019', 'doc_level_code', 'Y')
		, ('ETL-200019', 'effective_property_value_explanation', 'Y')
		, ('ETL-200019', 'effective_property_value_explanation_code', 'Y')
		, ('ETL-200019', 'effective_property_value_type', 'Y')
		, ('ETL-200019', 'effective_property_value_type_code', 'Y')
		, ('ETL-200019', 'effective_signing_location_state', 'Y')
		, ('ETL-200019', 'effective_signing_location_state_code', 'Y')
		, ('ETL-200019', 'fre_ctp_closing_feature', 'Y')
		, ('ETL-200019', 'fre_ctp_closing_feature_code', 'Y')
		, ('ETL-200019', 'gse_version', 'Y')
		, ('ETL-200019', 'gse_version_code', 'Y')
		, ('ETL-200019', 'intent_to_proceed', 'Y')
		, ('ETL-200019', 'intent_to_proceed_code', 'Y')
		, ('ETL-200019', 'orphan_status', 'Y')
		, ('ETL-200019', 'orphan_status_code', 'Y')
		, ('ETL-200019', 'realty_agent_scenario', 'Y')
		, ('ETL-200019', 'realty_agent_scenario_code', 'Y')
		, ('ETL-200019', 'rescission_notification', 'Y')
		, ('ETL-200019', 'rescission_notification_code', 'Y')
		, ('ETL-200019', 'security_instrument', 'Y')
		, ('ETL-200019', 'security_instrument_code', 'Y')
		, ('ETL-200019', 'transaction_create_type', 'Y')
		, ('ETL-200019', 'transaction_create_type_code', 'Y')
		, ('ETL-200019', 'transaction_status', 'Y')
		, ('ETL-200019', 'transaction_status_code', 'Y')
		, ('ETL-200019', 'any_vesting_changes', 'Y')
		, ('ETL-200019', 'any_vesting_changes_code', 'Y')
		, ('ETL-200019', 'arms_length', 'Y')
		, ('ETL-200019', 'arms_length_code', 'Y')
		, ('ETL-200019', 'early_first_payment', 'Y')
		, ('ETL-200019', 'early_first_payment_code', 'Y')
		, ('ETL-200019', 'earthquake_insurance_applicable', 'Y')
		, ('ETL-200019', 'earthquake_insurance_applicable_code', 'Y')
		, ('ETL-200019', 'flood_insurance_applicable', 'Y')
		, ('ETL-200019', 'flood_insurance_applicable_code', 'Y')
		, ('ETL-200019', 'hazard_insurance_applicable', 'Y')
		, ('ETL-200019', 'hazard_insurance_applicable_code', 'Y')
		, ('ETL-200019', 'hud_consultant', 'Y')
		, ('ETL-200019', 'hud_consultant_code', 'Y')
		, ('ETL-200019', 'mortgagee_builder_seller_relationship', 'Y')
		, ('ETL-200019', 'mortgagee_builder_seller_relationship_code', 'Y')
		, ('ETL-200019', 'property_acquired_through_ancillary_relief', 'Y')
		, ('ETL-200019', 'property_acquired_through_ancillary_relief_code', 'Y')
		, ('ETL-200019', 'property_acquired_through_inheritance', 'Y')
		, ('ETL-200019', 'property_acquired_through_inheritance_code', 'Y')
		, ('ETL-200019', 'separate_transaction_for_land_acquisition', 'Y')
		, ('ETL-200019', 'separate_transaction_for_land_acquisition_code', 'Y')
		, ('ETL-200019', 'taxes_escrowed', 'Y')
		, ('ETL-200019', 'taxes_escrowed_code', 'Y')
		, ('ETL-200019', 'vesting_change_titleholder_added', 'Y')
		, ('ETL-200019', 'vesting_change_titleholder_added_code', 'Y')
		, ('ETL-200019', 'vesting_change_titleholder_name_change', 'Y')
		, ('ETL-200019', 'vesting_change_titleholder_name_change_code', 'Y')
		, ('ETL-200019', 'vesting_change_titleholder_removed', 'Y')
		, ('ETL-200019', 'vesting_change_titleholder_removed_code', 'Y')
		, ('ETL-200019', 'windstorm_insurance_applicable', 'Y')
		, ('ETL-200019', 'windstorm_insurance_applicable_code', 'Y')
		, ('ETL-200025', 'data_source_dwid', 'N')
		, ('ETL-200025', 'edw_created_datetime', 'N')
		, ('ETL-200025', 'edw_modified_datetime', 'Y')
		, ('ETL-200025', 'etl_batch_id', 'Y')
		, ('ETL-200025', 'data_source_integration_columns', 'N')
		, ('ETL-200025', 'data_source_integration_id', 'N')
		, ('ETL-200025', 'data_source_modified_datetime', 'Y')
		, ('ETL-200025', 'underwrite_disposition', 'Y')
		, ('ETL-200025', 'underwrite_disposition_code', 'N')
		, ('ETL-200025', 'underwrite_method', 'Y')
		, ('ETL-200025', 'underwrite_method_code', 'N')
		, ('ETL-200025', 'underwrite_risk_assessment', 'Y')
		, ('ETL-200025', 'underwrite_risk_assessment_code', 'N')
)
INSERT
INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)
SELECT insert_update_step.dwid, insert_rows.update_lookup, insert_rows.update_lookup, insert_rows.update_flag::mdi.pentaho_y_or_n, FALSE
FROM insert_rows
	JOIN mdi.process
		ON process.name = insert_rows.process_name
	JOIN mdi.insert_update_step
		ON process.dwid = insert_update_step.process_dwid;


--json_output_field
WITH insert_rows (process_name, json_output_field) AS (
	VALUES ('ETL-200023', 'data_source_integration_id')
		, ('ETL-200024', 'data_source_integration_id')
		, ('ETL-200026', 'data_source_integration_id')
		, ('ETL-200027', 'data_source_integration_id')
		, ('ETL-200028', 'data_source_integration_id')
		, ('ETL-200029', 'data_source_integration_id')
		, ('ETL-200025', 'data_source_integration_id')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
	JOIN mdi.process
		ON insert_rows.process_name = process.name;

/*
UPDATES
*/

--table_input_step
WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (
	VALUES ('ETL-300001-insert-update', 1, 'SELECT loan_fact_incl_new_records.edw_created_datetime
	, loan_fact_incl_new_records.edw_modified_datetime
	, loan_fact_incl_new_records.data_source_integration_columns
	, loan_fact_incl_new_records.data_source_integration_id
	, loan_fact_incl_new_records.data_source_modified_datetime
	, loan_fact_incl_new_records.loan_pid
	, loan_fact_incl_new_records.loan_dwid
	, loan_fact_incl_new_records.loan_junk_dwid
	, loan_fact_incl_new_records.product_choice_dwid
	, loan_fact_incl_new_records.transaction_dwid
	, loan_fact_incl_new_records.transaction_junk_dwid
	, loan_fact_incl_new_records.current_loan_beneficiary_dwid
	, loan_fact_incl_new_records.active_loan_funding_dwid
	, loan_fact_incl_new_records.b1_borrower_dwid
	, loan_fact_incl_new_records.b2_borrower_dwid
	, loan_fact_incl_new_records.b3_borrower_dwid
	, loan_fact_incl_new_records.b4_borrower_dwid
	, loan_fact_incl_new_records.b5_borrower_dwid
	, loan_fact_incl_new_records.c1_borrower_dwid
	, loan_fact_incl_new_records.c2_borrower_dwid
	, loan_fact_incl_new_records.c3_borrower_dwid
	, loan_fact_incl_new_records.c4_borrower_dwid
	, loan_fact_incl_new_records.c5_borrower_dwid
	, loan_fact_incl_new_records.n1_borrower_dwid
	, loan_fact_incl_new_records.n2_borrower_dwid
	, loan_fact_incl_new_records.n3_borrower_dwid
	, loan_fact_incl_new_records.n4_borrower_dwid
	, loan_fact_incl_new_records.n5_borrower_dwid
	, loan_fact_incl_new_records.n6_borrower_dwid
	, loan_fact_incl_new_records.n7_borrower_dwid
	, loan_fact_incl_new_records.n8_borrower_dwid
	, loan_fact_incl_new_records.b1_borrower_demographics_dwid
	, loan_fact_incl_new_records.b1_borrower_lending_profile_dwid
  , loan_fact_incl_new_records.b1_borrower_hmda_collection_dwid
	, loan_fact_incl_new_records.primary_application_dwid
	, loan_fact_incl_new_records.collateral_to_custodian_lender_user_dwid
	, loan_fact_incl_new_records.interim_funder_dwid
	, loan_fact_incl_new_records.product_terms_dwid
	, loan_fact_incl_new_records.product_dwid
	, loan_fact_incl_new_records.product_investor_dwid
	, loan_fact_incl_new_records.hmda_purchaser_of_loan_dwid
	, loan_fact_incl_new_records.apr
	, loan_fact_incl_new_records.base_loan_amount
	, loan_fact_incl_new_records.financed_amount
	, loan_fact_incl_new_records.loan_amount
	, loan_fact_incl_new_records.ltv_ratio_percent
	, loan_fact_incl_new_records.note_rate_percent
	, loan_fact_incl_new_records.purchase_advice_amount
	, loan_fact_incl_new_records.finance_charge_amount
	, loan_fact_incl_new_records.hoepa_fees_dollar_amount
	, loan_fact_incl_new_records.interest_rate_fee_change_amount
	, loan_fact_incl_new_records.principal_curtailment_amount
	, loan_fact_incl_new_records.qualifying_pi_amount
	, loan_fact_incl_new_records.target_cash_out_amount
	, loan_fact_incl_new_records.heloc_maximum_balance_amount
	, loan_fact_incl_new_records.agency_case_id_assigned_date_dwid
	, loan_fact_incl_new_records.apor_date_dwid
	, loan_fact_incl_new_records.application_signed_date_dwid
	, loan_fact_incl_new_records.approved_with_conditions_date_dwid
	, loan_fact_incl_new_records.beneficiary_from_date_dwid
	, loan_fact_incl_new_records.beneficiary_through_date_dwid
	, loan_fact_incl_new_records.collateral_sent_date_dwid
	, loan_fact_incl_new_records.disbursement_date_dwid
	, loan_fact_incl_new_records.early_funding_date_dwid
	, loan_fact_incl_new_records.effective_funding_date_dwid
	, loan_fact_incl_new_records.fha_endorsement_date_dwid
	, loan_fact_incl_new_records.estimated_funding_date_dwid
	, loan_fact_incl_new_records.intent_to_proceed_date_dwid
	, loan_fact_incl_new_records.funding_date_dwid
	, loan_fact_incl_new_records.funding_requested_date_dwid
	, loan_fact_incl_new_records.loan_file_ship_date_dwid
	, loan_fact_incl_new_records.mers_transfer_creation_date_dwid
	, loan_fact_incl_new_records.pending_wire_date_dwid
	, loan_fact_incl_new_records.rejected_date_dwid
	, loan_fact_incl_new_records.return_confirmed_date_dwid
	, loan_fact_incl_new_records.return_request_date_dwid
	, loan_fact_incl_new_records.scheduled_release_date_dwid
	, loan_fact_incl_new_records.usda_guarantee_date_dwid
	, loan_fact_incl_new_records.va_guaranty_date_dwid
	, loan_fact_incl_new_records.account_executive_lender_user_dwid
	, loan_fact_incl_new_records.closing_doc_specialist_lender_user_dwid
	, loan_fact_incl_new_records.closing_scheduler_lender_user_dwid
	, loan_fact_incl_new_records.collateral_to_investor_lender_user_dwid
	, loan_fact_incl_new_records.collateral_underwriter_lender_user_dwid
	, loan_fact_incl_new_records.correspondent_client_advocate_lender_user_dwid
	, loan_fact_incl_new_records.final_documents_to_investor_lender_user_dwid
	, loan_fact_incl_new_records.flood_insurance_specialist_lender_user_dwid
	, loan_fact_incl_new_records.funder_lender_user_dwid
	, loan_fact_incl_new_records.government_insurance_lender_user_dwid
	, loan_fact_incl_new_records.ho6_specialist_lender_user_dwid
	, loan_fact_incl_new_records.hoa_specialist_lender_user_dwid
	, loan_fact_incl_new_records.hoi_specialist_lender_user_dwid
	, loan_fact_incl_new_records.hud_va_lender_officer_lender_user_dwid
	, loan_fact_incl_new_records.internal_construction_manager_lender_user_dwid
	, loan_fact_incl_new_records.investor_conditions_lender_user_dwid
	, loan_fact_incl_new_records.investor_stack_to_investor_lender_user_dwid
	, loan_fact_incl_new_records.loan_officer_assistant_lender_user_dwid
	, loan_fact_incl_new_records.loan_payoff_specialist_lender_user_dwid
	, loan_fact_incl_new_records.originator_lender_user_dwid
	, loan_fact_incl_new_records.processor_lender_user_dwid
	, loan_fact_incl_new_records.project_underwriter_lender_user_dwid
	, loan_fact_incl_new_records.subordination_specialist_lender_user_dwid
	, loan_fact_incl_new_records.supplemental_originator_lender_user_dwid
	, loan_fact_incl_new_records.title_specialist_lender_user_dwid
	, loan_fact_incl_new_records.transaction_assistant_lender_user_dwid
	, loan_fact_incl_new_records.underwriter_lender_user_dwid
	, loan_fact_incl_new_records.underwriting_manager_lender_user_dwid
	, loan_fact_incl_new_records.va_specialist_lender_user_dwid
	, loan_fact_incl_new_records.verbal_voe_specialist_lender_user_dwid
	, loan_fact_incl_new_records.voe_specialist_lender_user_dwid
	, loan_fact_incl_new_records.wholesale_client_advocate_lender_user_dwid
	, loan_fact_incl_new_records.wire_specialist_lender_user_dwid
	, loan_fact_incl_new_records.initial_beneficiary_investor_dwid
	, loan_fact_incl_new_records.first_beneficiary_after_initial_investor_dwid
	, loan_fact_incl_new_records.most_recent_purchasing_beneficiary_investor_dwid
	, loan_fact_incl_new_records.current_beneficiary_investor_dwid
	, loan_fact_incl_new_records.current_transaction_stage_from_date_dwid
	, loan_fact_incl_new_records.cd_clear_date_dwid
	, loan_fact_incl_new_records.charges_enabled_date_dwid
	, loan_fact_incl_new_records.effective_earliest_allowed_consummation_date_dwid
	, loan_fact_incl_new_records.effective_hmda_action_date_dwid
	, loan_fact_incl_new_records.effective_note_date_dwid
	, loan_fact_incl_new_records.hmda_action_date_dwid
	, loan_fact_incl_new_records.initial_cancel_status_date_dwid
	, loan_fact_incl_new_records.initial_uw_disposition_date_dwid
	, loan_fact_incl_new_records.initial_uw_submit_date_dwid
	, loan_fact_incl_new_records.note_date_dwid
	, loan_fact_incl_new_records.preapproval_uw_submit_date_dwid
	, loan_fact_incl_new_records.transaction_create_date_dwid
	, loan_fact_incl_new_records.transaction_welcome_call_date_dwid
	, loan_fact_incl_new_records.trid_application_date_dwid
	, loan_fact_incl_new_records.underwrite_publish_date_dwid
	, loan_fact_incl_new_records.cash_out_reason_dwid
	, loan_fact_incl_new_records.hmda_action_dwid
	, loan_fact_incl_new_records.underwrite_dwid
FROM (
	SELECT COALESCE(loan_fact.edw_created_datetime, NOW()) AS edw_created_datetime
		, NOW() AS edw_modified_datetime
		, ''loan_pid~data_source_dwid'' AS data_source_integration_columns
		, loan_dim.loan_pid || ''~1'' AS data_source_integration_id
		, loan_dim.edw_modified_datetime AS data_source_modified_datetime
		, loan_dim.loan_pid AS loan_pid
		, loan_dim.dwid AS loan_dwid
		, COALESCE(loan_junk_dim.dwid, 0) AS loan_junk_dwid
		, COALESCE(product_choice_dim.dwid, 0) AS product_choice_dwid
		, COALESCE(transaction_dim.dwid, 0) AS transaction_dwid
		, COALESCE(transaction_junk_dim.dwid, 0) AS transaction_junk_dwid
		, COALESCE(current_loan_beneficiary_dim.dwid, 0) AS current_loan_beneficiary_dwid
		, COALESCE(loan_funding_dim.dwid, 0) AS active_loan_funding_dwid
		, COALESCE(borrower_b1_dim.dwid, 0) AS b1_borrower_dwid
		, COALESCE(borrower_b2_dim.dwid, 0) AS b2_borrower_dwid
		, COALESCE(borrower_b3_dim.dwid, 0) AS b3_borrower_dwid
		, COALESCE(borrower_b4_dim.dwid, 0) AS b4_borrower_dwid
		, COALESCE(borrower_b5_dim.dwid, 0) AS b5_borrower_dwid
		, COALESCE(borrower_c1_dim.dwid, 0) AS c1_borrower_dwid
		, COALESCE(borrower_c2_dim.dwid, 0) AS c2_borrower_dwid
		, COALESCE(borrower_c3_dim.dwid, 0) AS c3_borrower_dwid
		, COALESCE(borrower_c4_dim.dwid, 0) AS c4_borrower_dwid
		, COALESCE(borrower_c5_dim.dwid, 0) AS c5_borrower_dwid
		, COALESCE(borrower_n1_dim.dwid, 0) AS n1_borrower_dwid
		, COALESCE(borrower_n2_dim.dwid, 0) AS n2_borrower_dwid
		, COALESCE(borrower_n3_dim.dwid, 0) AS n3_borrower_dwid
		, COALESCE(borrower_n4_dim.dwid, 0) AS n4_borrower_dwid
		, COALESCE(borrower_n5_dim.dwid, 0) AS n5_borrower_dwid
		, COALESCE(borrower_n6_dim.dwid, 0) AS n6_borrower_dwid
		, COALESCE(borrower_n7_dim.dwid, 0) AS n7_borrower_dwid
		, COALESCE(borrower_n8_dim.dwid, 0) AS n8_borrower_dwid
		, COALESCE(borrower_demographics_dim.dwid, 0) AS b1_borrower_demographics_dwid
		, COALESCE(borrower_lending_profile_dim.dwid, 0) AS b1_borrower_lending_profile_dwid
      , COALESCE(b1_borrower_lkup.borrower_hmda_collection_dwid, 0) AS b1_borrower_hmda_collection_dwid
		, COALESCE(application_dim.dwid, 0) AS primary_application_dwid
		, COALESCE(collateral_to_custodian.dwid, 0) AS collateral_to_custodian_lender_user_dwid
		, COALESCE(interim_funder_dim.dwid, 0) AS interim_funder_dwid
		, COALESCE(product_terms_dim.dwid, 0) AS product_terms_dwid
		, COALESCE(product_dim.dwid, 0) AS product_dwid
		, COALESCE(investor_dim.dwid, 0) AS product_investor_dwid
		, COALESCE(hmda_purchaser_of_loan_dim.dwid, 0) AS hmda_purchaser_of_loan_dwid
		, loan.l_apr AS apr
		, loan.l_base_loan_amount AS base_loan_amount
		, loan.l_financed_amount AS financed_amount
		, loan.l_loan_amount AS loan_amount
		, loan.l_ltv_ratio_percent AS ltv_ratio_percent
		, loan.l_note_rate_percent AS note_rate_percent
		, current_loan_beneficiary.lb_purchase_advice_amount AS purchase_advice_amount
		, loan.l_finance_charge_amount AS finance_charge_amount
		, loan.l_hoepa_fees_dollar_amount AS hoepa_fees_dollar_amount
		, loan.l_interest_rate_fee_change_amount AS interest_rate_fee_change_amount
		, loan.l_principal_curtailment_amount AS principal_curtailment_amount
		, loan.l_qualifying_pi_amount AS qualifying_pi_amount
		, loan.l_target_cash_out_amount AS target_cash_out_amount
		, loan.l_heloc_maximum_balance_amount AS heloc_maximum_balance_amount
		, COALESCE(agency_case_id_assigned_date_dim.dwid, 0) AS agency_case_id_assigned_date_dwid
		, COALESCE(apor_date_dim.dwid, 0) AS apor_date_dwid
		, COALESCE(application_signed_date_dim.dwid,0) AS application_signed_date_dwid
		, COALESCE(approved_with_conditions_date_dim.dwid,0) AS approved_with_conditions_date_dwid
		, COALESCE(beneficiary_from_date_dim.dwid,0) AS beneficiary_from_date_dwid
		, COALESCE(beneficiary_through_date_dim.dwid,0) AS beneficiary_through_date_dwid
		, COALESCE(collateral_sent_date_dim.dwid, 0) AS collateral_sent_date_dwid
		, COALESCE(disbursement_date_dim.dwid, 0) AS disbursement_date_dwid
		, COALESCE(early_funding_date_dim.dwid, 0) AS early_funding_date_dwid
		, COALESCE(effective_funding_date_dim.dwid,0) AS effective_funding_date_dwid
		, COALESCE(fha_endorsement_date_dim.dwid,0) AS fha_endorsement_date_dwid
		, COALESCE(estimated_funding_date_dim.dwid, 0) AS estimated_funding_date_dwid
		, COALESCE(intent_to_proceed_date_dim.dwid, 0) AS intent_to_proceed_date_dwid
		, COALESCE(funding_date_dim.dwid, 0) AS funding_date_dwid
		, COALESCE(funding_requested_date_dim.dwid, 0) AS funding_requested_date_dwid
		, COALESCE(loan_file_ship_date_dim.dwid, 0) AS loan_file_ship_date_dwid
		, COALESCE(mers_transfer_creation_date_dim.dwid, 0) AS mers_transfer_creation_date_dwid
		, COALESCE(pending_wire_date_dim.dwid, 0) AS pending_wire_date_dwid
		, COALESCE(rejected_date_dim.dwid, 0) AS rejected_date_dwid
		, COALESCE(return_confirmed_date_dim.dwid, 0) AS return_confirmed_date_dwid
		, COALESCE(return_request_date_dim.dwid, 0) AS return_request_date_dwid
		, COALESCE(scheduled_release_date_dim.dwid, 0) AS scheduled_release_date_dwid
		, COALESCE(usda_guarantee_date_dim.dwid, 0) AS usda_guarantee_date_dwid
		, COALESCE(va_guaranty_date_dim.dwid, 0) AS va_guaranty_date_dwid
		, COALESCE(account_executive.dwid, 0) AS account_executive_lender_user_dwid
		, COALESCE(closing_doc_specialist.dwid, 0) AS closing_doc_specialist_lender_user_dwid
		, COALESCE(closing_scheduler.dwid, 0) AS closing_scheduler_lender_user_dwid
		, COALESCE(collateral_to_investor.dwid, 0) AS collateral_to_investor_lender_user_dwid
		, COALESCE(collateral_underwriter.dwid, 0) AS collateral_underwriter_lender_user_dwid
		, COALESCE(correspondent_client_advocate.dwid, 0) AS correspondent_client_advocate_lender_user_dwid
		, COALESCE(final_documents_to_investor.dwid, 0) AS final_documents_to_investor_lender_user_dwid
		, COALESCE(flood_insurance_specialist.dwid, 0) AS flood_insurance_specialist_lender_user_dwid
		, COALESCE(funder.dwid, 0) AS funder_lender_user_dwid
		, COALESCE(government_insurance.dwid, 0) AS government_insurance_lender_user_dwid
		, COALESCE(ho6_specialist.dwid, 0) AS ho6_specialist_lender_user_dwid
		, COALESCE(hoa_specialist.dwid, 0) AS hoa_specialist_lender_user_dwid
		, COALESCE(hoi_specialist.dwid, 0) AS hoi_specialist_lender_user_dwid
		, COALESCE(hud_va_lender_officer.dwid, 0) AS hud_va_lender_officer_lender_user_dwid
		, COALESCE(internal_construction_manager.dwid, 0) AS internal_construction_manager_lender_user_dwid
		, COALESCE(investor_conditions.dwid, 0) AS investor_conditions_lender_user_dwid
		, COALESCE(investor_stack_to_investor.dwid, 0) AS investor_stack_to_investor_lender_user_dwid
		, COALESCE(loan_officer_assistant.dwid, 0) AS loan_officer_assistant_lender_user_dwid
		, COALESCE(loan_payoff_specialist.dwid, 0) AS loan_payoff_specialist_lender_user_dwid
		, COALESCE(originator.dwid, 0) AS originator_lender_user_dwid
		, COALESCE(processor.dwid, 0) AS processor_lender_user_dwid
		, COALESCE(project_underwriter.dwid, 0) AS project_underwriter_lender_user_dwid
		, COALESCE(subordination_specialist.dwid, 0) AS subordination_specialist_lender_user_dwid
		, COALESCE(supplemental_originator.dwid, 0) AS supplemental_originator_lender_user_dwid
		, COALESCE(title_specialist.dwid, 0) AS title_specialist_lender_user_dwid
		, COALESCE(transaction_assistant.dwid, 0) AS transaction_assistant_lender_user_dwid
		, COALESCE(underwriter.dwid, 0) AS underwriter_lender_user_dwid
		, COALESCE(underwriting_manager.dwid, 0) AS underwriting_manager_lender_user_dwid
		, COALESCE(va_specialist.dwid, 0) AS va_specialist_lender_user_dwid
		, COALESCE(verbal_voe_specialist.dwid, 0) AS verbal_voe_specialist_lender_user_dwid
		, COALESCE(voe_specialist.dwid, 0) AS voe_specialist_lender_user_dwid
		, COALESCE(wholesale_client_advocate.dwid, 0) AS wholesale_client_advocate_lender_user_dwid
		, COALESCE(wire_specialist.dwid, 0) AS wire_specialist_lender_user_dwid
		, COALESCE(current_beneficiary_investor_dim.dwid, 0) AS current_beneficiary_investor_dwid
		, COALESCE(initial_beneficiary_investor_dim.dwid, 0) AS initial_beneficiary_investor_dwid
		, COALESCE(first_beneficiary_after_initial_investor_dim.dwid, 0) AS
		first_beneficiary_after_initial_investor_dwid
		, COALESCE(most_recent_purchasing_beneficiary_investor_dim.dwid, 0) AS
		most_recent_purchasing_beneficiary_investor_dwid
		, COALESCE(current_deal_stage_date_dim.dwid, 0) AS current_transaction_stage_from_date_dwid
		, COALESCE(cd_clear_date_dim.dwid, 0) AS cd_clear_date_dwid
		, COALESCE(charges_enabled_date_dim.dwid, 0) AS charges_enabled_date_dwid
		, COALESCE(effective_earliest_allowed_consummation_date_dim.dwid, 0) AS effective_earliest_allowed_consummation_date_dwid
		, COALESCE(effective_hmda_action_date_dim.dwid, 0) AS effective_hmda_action_date_dwid
		, COALESCE(effective_note_date_dim.dwid, 0) AS effective_note_date_dwid
		, COALESCE(hmda_action_date_dim.dwid, 0) AS hmda_action_date_dwid
		, COALESCE(initial_cancel_status_date_dim.dwid, 0) AS initial_cancel_status_date_dwid
		, COALESCE(initial_uw_disposition_date_dim.dwid, 0) AS initial_uw_disposition_date_dwid
		, COALESCE(initial_uw_submit_date_dim.dwid, 0) AS initial_uw_submit_date_dwid
		, COALESCE(note_date_dim.dwid, 0) AS note_date_dwid
		, COALESCE(preapproval_uw_submit_date_dim.dwid, 0) AS preapproval_uw_submit_date_dwid
		, COALESCE(transaction_create_date_dim.dwid, 0) AS transaction_create_date_dwid
		, COALESCE(transaction_welcome_call_date_dim.dwid, 0) AS transaction_welcome_call_date_dwid
		, COALESCE(trid_application_date_dim.dwid, 0) AS trid_application_date_dwid
		, COALESCE(underwrite_publish_date_dim.dwid, 0) AS underwrite_publish_date_dwid
		, COALESCE(cash_out_reason_dim.dwid, 0) AS cash_out_reason_dwid
		, COALESCE(hmda_action_dim.dwid, 0) AS hmda_action_dwid
		, COALESCE(underwrite_dim.dwid, 0) AS underwrite_dwid
	FROM
		-- history_octane deal
		(
			SELECT deal.*
				, <<deal_partial_load_condition>> AS include_record
			FROM history_octane.deal
				LEFT JOIN history_octane.deal AS history_records ON deal.d_pid = history_records.d_pid
					AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE deal.data_source_deleted_flag IS FALSE
				AND history_records.d_pid IS NULL) AS deal
			-- history_octane deal_stage
			JOIN (
			SELECT deal_stage.*
				, <<deal_stage_partial_load_condition>> AS include_record
			FROM history_octane.deal_stage
				LEFT JOIN history_octane.deal_stage AS history_records ON deal_stage.dst_pid = history_records.dst_pid
					AND deal_stage.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE deal_stage.data_source_deleted_flag IS FALSE
				AND deal_stage.dst_through_date IS NULL
				AND history_records.dst_pid IS NULL) AS deal_stage ON deal.d_pid = deal_stage.dst_deal_pid
			-- history_octane proposal
			JOIN (
			SELECT proposal.*
				, <<proposal_partial_load_condition>> AS include_record
			FROM history_octane.proposal
				LEFT JOIN history_octane.proposal AS history_records ON proposal.prp_pid = history_records.prp_pid
					AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE proposal.data_source_deleted_flag IS FALSE
				AND history_records.prp_pid IS NULL) AS proposal ON deal.d_active_proposal_pid = proposal.prp_pid
			-- history_octane (primary) application
			JOIN (
			SELECT application.*
				, <<application_partial_load_condition>> AS include_record
			FROM history_octane.application
				LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
					AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE application.data_source_deleted_flag IS FALSE
				AND history_records.apl_pid IS NULL) AS primary_application ON proposal.prp_pid = primary_application.apl_proposal_pid
			AND primary_application.apl_primary_application IS TRUE
			-- history_octane loan
			JOIN (
			SELECT loan.*
				, <<loan_partial_load_condition>> AS include_record
			FROM history_octane.loan
				LEFT JOIN history_octane.loan AS history_records ON loan.l_pid = history_records.l_pid
					AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE loan.data_source_deleted_flag IS FALSE
				AND history_records.l_pid IS NULL) AS loan ON proposal.prp_pid = loan.l_proposal_pid
			-- history_octane deal_key_roles
			JOIN (
			SELECT deal_key_roles.*
				, <<deal_key_roles_partial_load_condition>> AS include_record
			FROM history_octane.deal_key_roles
				LEFT JOIN history_octane.deal_key_roles AS history_records ON deal_key_roles.dkrs_pid = history_records.dkrs_pid
					AND deal_key_roles.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE deal_key_roles.data_source_deleted_flag IS FALSE
				AND history_records.dkrs_pid IS NULL) AS deal_key_roles ON deal.d_pid = deal_key_roles.dkrs_deal_pid
			-- history_octane.borrower B1
			JOIN (
			SELECT * FROM (
				SELECT borrower.*
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_b1 ON proposal.prp_pid = borrower_b1.apl_proposal_pid
			AND borrower_b1.b_borrower_tiny_id_type = ''B1''
			-- history_octane.borrower B2
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_b2 ON proposal.prp_pid = borrower_b2.apl_proposal_pid
			AND borrower_b2.b_borrower_tiny_id_type = ''B2''
			-- history_octane.borrower B3
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_b3 ON proposal.prp_pid = borrower_b3.apl_proposal_pid
			AND borrower_b3.b_borrower_tiny_id_type = ''B3''
			-- history_octane.borrower B4
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_b4 ON proposal.prp_pid = borrower_b4.apl_proposal_pid
			AND borrower_b4.b_borrower_tiny_id_type = ''B4''
			-- history_octane.borrower B5
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_b5 ON proposal.prp_pid = borrower_b5.apl_proposal_pid
			AND borrower_b5.b_borrower_tiny_id_type = ''B5''
			-- history_octane.borrower C1
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_c1 ON proposal.prp_pid = borrower_c1.apl_proposal_pid
			AND borrower_c1.b_borrower_tiny_id_type = ''C1''
			-- history_octane.borrower C2
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_c2 ON proposal.prp_pid = borrower_c2.apl_proposal_pid
			AND borrower_c2.b_borrower_tiny_id_type = ''C2''
			-- history_octane.borrower C3
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_c3 ON proposal.prp_pid = borrower_c3.apl_proposal_pid
			AND borrower_c3.b_borrower_tiny_id_type = ''C3''
			-- history_octane.borrower C4
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_c4 ON proposal.prp_pid = borrower_c4.apl_proposal_pid
			AND borrower_c4.b_borrower_tiny_id_type = ''C4''
			-- history_octane.borrower C5
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_c5 ON proposal.prp_pid = borrower_c5.apl_proposal_pid
			AND borrower_c5.b_borrower_tiny_id_type = ''C5''
			-- history_octane.borrower N1
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_n1 ON proposal.prp_pid = borrower_n1.apl_proposal_pid
			AND borrower_n1.b_borrower_tiny_id_type = ''N1''
			-- history_octane.borrower N2
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_n2 ON proposal.prp_pid = borrower_n2.apl_proposal_pid
			AND borrower_n2.b_borrower_tiny_id_type = ''N2''
			-- history_octane.borrower N3
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_n3 ON proposal.prp_pid = borrower_n3.apl_proposal_pid
			AND borrower_n3.b_borrower_tiny_id_type = ''N3''
			-- history_octane.borrower N4
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_n4 ON proposal.prp_pid = borrower_n4.apl_proposal_pid
			AND borrower_n4.b_borrower_tiny_id_type = ''N4''
			-- history_octane.borrower N5
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_n5 ON proposal.prp_pid = borrower_n5.apl_proposal_pid
			AND borrower_n5.b_borrower_tiny_id_type = ''N5''
			-- history_octane.borrower N6
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_n6 ON proposal.prp_pid = borrower_n6.apl_proposal_pid
			AND borrower_n6.b_borrower_tiny_id_type = ''N6''
			-- history_octane.borrower N7
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_n7 ON proposal.prp_pid = borrower_n7.apl_proposal_pid
			AND borrower_n7.b_borrower_tiny_id_type = ''N7''
			-- history_octane.borrower N8
			LEFT JOIN (
			SELECT * FROM (
				SELECT borrower.b_pid
					, borrower.b_application_pid
					, borrower.b_borrower_tiny_id_type
					, <<borrower_partial_load_condition>> AS include_record
				FROM history_octane.borrower
					LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid  = history_records.b_pid
						AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
				WHERE borrower.data_source_deleted_flag IS FALSE
					AND history_records.b_pid IS NULL
			) AS borrower
				JOIN (
					SELECT application.apl_proposal_pid
						, application.apl_pid
					FROM history_octane.application
						LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
							AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
					WHERE application.data_source_deleted_flag IS FALSE
						AND history_records.apl_pid IS NULL
				) AS application ON borrower.b_application_pid = application.apl_pid
		) AS borrower_n8 ON proposal.prp_pid = borrower_n8.apl_proposal_pid
			AND borrower_n8.b_borrower_tiny_id_type = ''N8''
			-- history_octane.loan_beneficiary: current
			LEFT JOIN (
			SELECT loan_beneficiary.*
				, <<loan_beneficiary_partial_load_condition>> AS include_record
			FROM history_octane.loan_beneficiary
				LEFT JOIN history_octane.loan_beneficiary AS history_records ON loan_beneficiary.lb_pid =
																				history_records.lb_pid
					AND loan_beneficiary.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE loan_beneficiary.data_source_deleted_flag IS FALSE
				AND history_records.lb_pid IS NULL
		) AS current_loan_beneficiary ON loan.l_pid = current_loan_beneficiary.lb_loan_pid
			AND current_loan_beneficiary.lb_current IS TRUE
			-- history_octane.loan_beneficiary: initial beneficiary
			LEFT JOIN (
			SELECT loan_beneficiary.*
				, <<loan_beneficiary_partial_load_condition>> AS include_record
			FROM history_octane.loan_beneficiary
				LEFT JOIN history_octane.loan_beneficiary AS history_records ON loan_beneficiary.lb_pid =
																				history_records.lb_pid
					AND loan_beneficiary.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE loan_beneficiary.data_source_deleted_flag IS FALSE
				AND history_records.lb_pid IS NULL
		) AS initial_loan_beneficiary ON loan.l_pid = initial_loan_beneficiary.lb_loan_pid
			AND initial_loan_beneficiary.lb_initial IS TRUE
			-- history_octane.loan_beneficiary: first beneficiary after initial
			LEFT JOIN (
			SELECT loan_beneficiary.*
				, <<loan_beneficiary_partial_load_condition>> AS include_record
			FROM (
				SELECT loan_beneficiary.*
				FROM history_octane.loan_beneficiary
					JOIN (
						SELECT loan_beneficiary.lb_loan_pid
							, MIN(loan_beneficiary.lb_pid) AS min_lb_pid
						FROM history_octane.loan_beneficiary
						WHERE loan_beneficiary.lb_initial IS FALSE
						GROUP BY loan_beneficiary.lb_loan_pid
					) AS min_lb_pid_per_loan ON loan_beneficiary.lb_pid = min_lb_pid_per_loan.min_lb_pid
			) AS loan_beneficiary
				LEFT JOIN history_octane.loan_beneficiary AS history_records ON loan_beneficiary.lb_pid = history_records.lb_pid
					AND loan_beneficiary.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE loan_beneficiary.data_source_deleted_flag IS FALSE
				AND history_records.lb_pid IS NULL
		) AS first_loan_beneficiary_after_initial ON loan.l_pid = first_loan_beneficiary_after_initial.lb_loan_pid
			-- history_octane.loan_beneficiary: most recent purchasing beneficiary
			LEFT JOIN (
			SELECT loan_beneficiary.*
				, <<loan_beneficiary_partial_load_condition>> AS include_record
			FROM (
				SELECT loan_beneficiary.*
				FROM history_octane.loan_beneficiary
					JOIN (
						SELECT loan_beneficiary.lb_loan_pid
							, MAX(loan_beneficiary.lb_pid) AS max_lb_pid
						FROM history_octane.loan_beneficiary
						WHERE loan_beneficiary.lb_loan_benef_transfer_status_type IN (''SHIPPED'', ''APPROVED_WITH_CONDITIONS'', ''PENDING_WIRE'', ''PENDING'', ''PURCHASED'')
						GROUP BY loan_beneficiary.lb_loan_pid
					) AS max_lb_pid_per_loan ON loan_beneficiary.lb_pid = max_lb_pid_per_loan.max_lb_pid
			) AS loan_beneficiary
				LEFT JOIN history_octane.loan_beneficiary AS history_records
					ON loan_beneficiary.lb_pid = history_records.lb_pid
						AND loan_beneficiary.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE loan_beneficiary.data_source_deleted_flag IS FALSE
				AND history_records.lb_pid IS NULL
		) AS most_recent_purchasing_beneficiary ON loan.l_pid = most_recent_purchasing_beneficiary.lb_loan_pid
			-- history_octane.loan_funding
			LEFT JOIN (
			SELECT loan_funding.*
				, <<loan_funding_partial_load_condition>> AS include_record
			FROM history_octane.loan_funding
				LEFT JOIN history_octane.loan_funding AS history_records ON loan_funding.lf_pid = history_records.lf_pid
					AND loan_funding.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE loan_funding.data_source_deleted_flag IS FALSE
				AND history_records.lf_pid IS NULL
		) AS active_loan_funding ON loan.l_pid = active_loan_funding.lf_loan_pid
			AND active_loan_funding.lf_return_confirmed_date IS NULL
			-- history_octane.interim_funder
			LEFT JOIN (
			SELECT interim_funder.*
				, <<interim_funder_partial_load_condition>> AS include_record
			FROM history_octane.interim_funder
				LEFT JOIN history_octane.interim_funder AS history_records ON interim_funder.if_pid = history_records.if_pid
					AND interim_funder.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE interim_funder.data_source_deleted_flag IS FALSE
				AND history_records.if_pid IS NULL
		) AS interim_funder ON active_loan_funding.lf_interim_funder_pid = interim_funder.if_pid
			-- history_octane.product_terms
			LEFT JOIN (
			SELECT product_terms.*
				, <<product_terms_partial_load_condition>> AS include_record
			FROM history_octane.product_terms
				LEFT JOIN history_octane.product_terms AS history_records ON product_terms.pt_pid = history_records.pt_pid
					AND product_terms.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE product_terms.data_source_deleted_flag IS FALSE
				AND history_records.pt_pid IS NULL
		) AS product_terms ON loan.l_product_terms_pid = product_terms.pt_pid
			-- history_octane.product
			LEFT JOIN (
			SELECT product.*
				, <<product_partial_load_condition>> AS include_record
			FROM history_octane.product
				LEFT JOIN history_octane.product AS history_records ON product.p_pid = history_records.p_pid
					AND product.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE product.data_source_deleted_flag IS FALSE
				AND history_records.p_pid IS NULL
		) AS product ON product_terms.pt_product_pid = product.p_pid
			-- history_octane.investor
			LEFT JOIN (
			SELECT investor.*
				, <<investor_partial_load_condition>> AS include_record
			FROM history_octane.investor
				LEFT JOIN history_octane.investor AS history_records ON investor.i_pid = history_records.i_pid
					AND investor.data_source_updated_datetime < history_records.data_source_updated_datetime
			WHERE investor.data_source_deleted_flag IS FALSE
				AND history_records.i_pid IS NULL
		) AS product_investor ON product.p_investor_pid = product_investor.i_pid
			-- history_octane.hmda_purchaser_of_loan_2017_type
			LEFT JOIN history_octane.hmda_purchaser_of_loan_2017_type ON loan.l_hmda_purchaser_of_loan_2017_type =
																		 hmda_purchaser_of_loan_2017_type.code
			AND hmda_purchaser_of_loan_2017_type.data_source_deleted_flag IS FALSE
			-- history_octane.hmda_purchaser_of_loan_2018_type
			LEFT JOIN history_octane.hmda_purchaser_of_loan_2018_type ON loan.l_hmda_purchaser_of_loan_2018_type =
																		 hmda_purchaser_of_loan_2018_type.code
			AND hmda_purchaser_of_loan_2018_type.data_source_deleted_flag IS FALSE
			-- star_loan.loan_dim
			JOIN (
			SELECT loan_dim.*
				, <<loan_dim_partial_load_condition>> AS include_record
			FROM star_loan.loan_dim
		) AS loan_dim ON loan.l_pid = loan_dim.loan_pid
			AND loan_dim.data_source_dwid = 1
			-- star_loan.loan_fact
			LEFT JOIN star_loan.loan_fact ON loan_dim.dwid = loan_fact.loan_dwid
			AND loan_fact.data_source_dwid = 1
			-- star_loan.application_dim
			LEFT JOIN (
			SELECT application_dim.*
				, <<application_dim_partial_load_condition>> AS include_record
			FROM star_loan.application_dim
		) AS application_dim ON primary_application.apl_pid = application_dim.application_pid
			AND application_dim.data_source_dwid = 1
			-- star_loan.loan_junk_dim
			LEFT JOIN (
			SELECT loan_junk_dim.*
				, <<loan_junk_dim_partial_load_condition>> AS include_record
			FROM star_loan.loan_junk_dim
		) AS loan_junk_dim ON loan.l_buydown_contributor_type IS NOT DISTINCT FROM loan_junk_dim.buydown_contributor_code
			AND loan.l_fha_program_code_type IS NOT DISTINCT FROM loan_junk_dim.fha_program_code
			AND loan.l_hmda_hoepa_status_type IS NOT DISTINCT FROM loan_junk_dim.hmda_hoepa_status_code
			AND loan.l_durp_eligibility_opt_out IS NOT DISTINCT FROM loan_junk_dim.durp_eligibility_opt_out_flag
			AND loan.l_fha_principal_write_down IS NOT DISTINCT FROM loan_junk_dim.fha_principal_write_down_flag
			AND loan.l_hpml IS NOT DISTINCT FROM loan_junk_dim.hpml_flag
			AND loan.l_lender_concession_candidate IS NOT DISTINCT FROM loan_junk_dim.lender_concession_candidate_flag
			AND proposal.prp_mi_required IS NOT DISTINCT FROM loan_junk_dim.mi_required_flag
			AND (CASE WHEN (loan.l_lien_priority_type IS NULL OR proposal.prp_structure_type IS NULL) THEN NULL
					  WHEN (loan.l_lien_priority_type = ''FIRST'' OR proposal.prp_structure_type = ''STANDALONE_2ND'') THEN FALSE
					  ELSE TRUE END) IS NOT DISTINCT FROM loan_junk_dim.piggyback_flag
			AND loan.l_qm_eligible IS NOT DISTINCT FROM loan_junk_dim.qm_eligible_flag
			AND loan.l_qualified_mortgage IS NOT DISTINCT FROM loan_junk_dim.qualified_mortgage_flag
			AND loan.l_secondary_clear_to_commit IS NOT DISTINCT FROM loan_junk_dim.secondary_clear_to_commit_flag
			AND loan.l_student_loan_cash_out_refinance IS NOT DISTINCT FROM loan_junk_dim.student_loan_cash_out_refinance_flag
			AND loan.l_lien_priority_type IS NOT DISTINCT FROM loan_junk_dim.lien_priority_code
			AND loan.l_lqa_purchase_eligibility_type IS NOT DISTINCT FROM loan_junk_dim.lqa_purchase_eligibility_code
			AND loan.l_qualified_mortgage_status_type IS NOT DISTINCT FROM loan_junk_dim.qualified_mortgage_status_code
			AND loan.l_qualifying_rate_type IS NOT DISTINCT FROM loan_junk_dim.qualifying_rate_code
			AND loan.l_texas_equity_auto IS NOT DISTINCT FROM loan_junk_dim.texas_equity_auto_code
			AND loan.l_texas_equity IS NOT DISTINCT FROM loan_junk_dim.texas_equity_code
			AND loan_junk_dim.data_source_dwid = 1
			-- star_loan.product_choice_dim
			LEFT JOIN (
			SELECT product_choice_dim.*
				, <<product_choice_dim_partial_load_condition>> AS include_record
			FROM star_loan.product_choice_dim
		) AS product_choice_dim ON loan.l_aus_type IS NOT DISTINCT FROM product_choice_dim.aus_code
			AND loan.l_buydown_schedule_type IS NOT DISTINCT FROM product_choice_dim.buydown_schedule_code
			AND loan.l_interest_only_type IS NOT DISTINCT FROM product_choice_dim.interest_only_code
			AND loan.l_mortgage_type IS NOT DISTINCT FROM product_choice_dim.mortgage_type_code
			AND loan.l_prepay_penalty_schedule_type IS NOT DISTINCT FROM product_choice_dim.prepay_penalty_schedule_code
			AND product_choice_dim.data_source_dwid = 1
			-- star_loan.transaction_junk_dim
			LEFT JOIN (
			SELECT transaction_junk_dim.*
				, <<transaction_junk_dim_partial_load_condition>> AS include_record
			FROM star_loan.transaction_junk_dim
		) AS transaction_junk_dim ON (CASE WHEN proposal.prp_structure_type = ''COMBO'' THEN TRUE ELSE FALSE
			END) IS NOT DISTINCT FROM transaction_junk_dim.piggyback_flag
			AND proposal.prp_mi_required IS NOT DISTINCT FROM transaction_junk_dim.mi_required_flag
			AND deal.d_test_loan IS NOT DISTINCT FROM transaction_junk_dim.is_test_loan_flag
			AND proposal.prp_structure_type IS NOT DISTINCT FROM transaction_junk_dim.structure_code
			AND proposal.prp_loan_purpose_type IS NOT DISTINCT FROM transaction_junk_dim.loan_purpose_code
			AND proposal.prp_property_usage_type IS NOT DISTINCT FROM transaction_junk_dim.property_usage_code
			AND transaction_junk_dim.data_source_dwid = 1
			-- star_loan.transaction_dim
			LEFT JOIN (
			SELECT transaction_dim.*
				, <<transaction_dim_partial_load_condition>> AS include_record
			FROM star_loan.transaction_dim
		) AS transaction_dim ON deal.d_pid = transaction_dim.deal_pid
			AND transaction_dim.data_source_dwid = 1
			-- star_loan.loan_beneficiary_dim: current beneficiary
			LEFT JOIN (
			SELECT loan_beneficiary_dim.*
				, <<loan_beneficiary_dim_partial_load_condition>> AS include_record
			FROM star_loan.loan_beneficiary_dim
		) AS current_loan_beneficiary_dim
			ON current_loan_beneficiary.lb_pid = current_loan_beneficiary_dim.loan_beneficiary_pid
				AND current_loan_beneficiary_dim.data_source_dwid = 1
			-- star_loan.investor_dim: current beneficiary investor
			LEFT JOIN (
			SELECT investor_dim.*
				, <<investor_dim_partial_load_condition>> AS include_record
			FROM star_loan.investor_dim
		) AS current_beneficiary_investor_dim
			ON current_loan_beneficiary.lb_investor_pid = current_beneficiary_investor_dim.investor_pid
				AND current_beneficiary_investor_dim.data_source_dwid = 1
			-- star_loan.investor_dim: initial beneficiary investor
			LEFT JOIN (
			SELECT investor_dim.*
				, <<investor_dim_partial_load_condition>> AS include_record
			FROM star_loan.investor_dim
		) AS initial_beneficiary_investor_dim
			ON initial_loan_beneficiary.lb_investor_pid = initial_beneficiary_investor_dim.investor_pid
				AND initial_beneficiary_investor_dim.data_source_dwid = 1
			-- star_loan.investor_dim: first beneficiary after initial investor
			LEFT JOIN (
			SELECT investor_dim.*
				, <<investor_dim_partial_load_condition>> AS include_record
			FROM star_loan.investor_dim
		) AS first_beneficiary_after_initial_investor_dim
			ON first_loan_beneficiary_after_initial.lb_investor_pid = first_beneficiary_after_initial_investor_dim.investor_pid
				AND first_beneficiary_after_initial_investor_dim.data_source_dwid = 1
			-- star_loan.investor_dim: most recent purchasing beneficiary investor
			LEFT JOIN (
			SELECT investor_dim.*
				, <<investor_dim_partial_load_condition>> AS include_record
			FROM star_loan.investor_dim
		) AS most_recent_purchasing_beneficiary_investor_dim
			ON most_recent_purchasing_beneficiary.lb_investor_pid = most_recent_purchasing_beneficiary_investor_dim.investor_pid
				AND most_recent_purchasing_beneficiary_investor_dim.data_source_dwid = 1
			-- star_loan.loan_funding_dim
			LEFT JOIN (
			SELECT loan_funding_dim.*
				, <<loan_funding_dim_partial_load_condition>> AS include_record
			FROM star_loan.loan_funding_dim
		) AS loan_funding_dim ON active_loan_funding.lf_pid = loan_funding_dim.loan_funding_pid
			AND loan_funding_dim.data_source_dwid = 1
			-- star_loan.borrower B1
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_b1_dim ON borrower_b1.b_pid = borrower_b1_dim.borrower_pid
			AND borrower_b1_dim.data_source_dwid = 1
			-- star_loan.borrower B2
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_b2_dim ON borrower_b2.b_pid = borrower_b2_dim.borrower_pid
			AND borrower_b2_dim.data_source_dwid = 1
			-- star_loan.borrower B3
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_b3_dim ON borrower_b3.b_pid = borrower_b3_dim.borrower_pid
			AND borrower_b3_dim.data_source_dwid = 1
			-- star_loan.borrower B4
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_b4_dim ON borrower_b4.b_pid = borrower_b4_dim.borrower_pid
			AND borrower_b4_dim.data_source_dwid = 1
			-- star_loan.borrower B5
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_b5_dim ON borrower_b5.b_pid = borrower_b5_dim.borrower_pid
			AND borrower_b5_dim.data_source_dwid = 1
			-- star_loan.borrower C1
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_c1_dim ON borrower_c1.b_pid = borrower_c1_dim.borrower_pid
			AND borrower_c1_dim.data_source_dwid = 1
			-- star_loan.borrower C2
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_c2_dim ON borrower_c2.b_pid = borrower_c2_dim.borrower_pid
			AND borrower_c2_dim.data_source_dwid = 1
			-- star_loan.borrower C3
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_c3_dim ON borrower_c3.b_pid = borrower_c3_dim.borrower_pid
			AND borrower_c3_dim.data_source_dwid = 1
			-- star_loan.borrower C4
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_c4_dim ON borrower_c4.b_pid = borrower_c4_dim.borrower_pid
			AND borrower_c4_dim.data_source_dwid = 1
			-- star_loan.borrower C5
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_c5_dim ON borrower_c5.b_pid = borrower_c5_dim.borrower_pid
			AND borrower_c5_dim.data_source_dwid = 1
			-- star_loan.borrower N1
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_n1_dim ON borrower_n1.b_pid = borrower_n1_dim.borrower_pid
			AND borrower_n1_dim.data_source_dwid = 1
			-- star_loan.borrower N2
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_n2_dim ON borrower_n2.b_pid = borrower_n2_dim.borrower_pid
			AND borrower_n2_dim.data_source_dwid = 1
			-- star_loan.borrower N3
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_n3_dim ON borrower_n3.b_pid = borrower_n3_dim.borrower_pid
			AND borrower_n3_dim.data_source_dwid = 1
			-- star_loan.borrower N4
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_n4_dim ON borrower_n4.b_pid = borrower_n4_dim.borrower_pid
			AND borrower_n4_dim.data_source_dwid = 1
			-- star_loan.borrower N5
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_n5_dim ON borrower_n5.b_pid = borrower_n5_dim.borrower_pid
			AND borrower_n5_dim.data_source_dwid = 1
			-- star_loan.borrower N6
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_n6_dim ON borrower_n6.b_pid = borrower_n6_dim.borrower_pid
			AND borrower_n6_dim.data_source_dwid = 1
			-- star_loan.borrower N7
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_n7_dim ON borrower_n7.b_pid = borrower_n7_dim.borrower_pid
			AND borrower_n7_dim.data_source_dwid = 1
			-- star_loan.borrower N8
			LEFT JOIN (
			SELECT borrower_dim.*
				, <<borrower_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_dim
		) AS borrower_n8_dim ON borrower_n8.b_pid = borrower_n8_dim.borrower_pid
			AND borrower_n8_dim.data_source_dwid = 1
			-- star_loan.borrower_demographics_dim
			LEFT JOIN (
			SELECT borrower_demographics_dim.*
				, <<borrower_demographics_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_demographics_dim
		) AS borrower_demographics_dim ON borrower_b1.b_ethnicity_collected_visual_or_surname IS NOT DISTINCT FROM
										  borrower_demographics_dim.ethnicity_collected_visual_or_surname_code
			AND borrower_b1.b_ethnicity_refused IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_refused_code
			AND (CASE WHEN borrower_b1.b_ethnicity_other_hispanic_or_latino_description <> ''''
				AND borrower_b1.b_ethnicity_other_hispanic_or_latino_description IS NOT NULL THEN TRUE ELSE FALSE END) IS NOT DISTINCT FROM
				borrower_demographics_dim.ethnicity_other_hispanic_or_latino_description_flag
			AND (CASE WHEN borrower_b1.b_other_race_national_origin_description <> ''''
				AND borrower_b1.b_other_race_national_origin_description IS NOT NULL THEN TRUE ELSE FALSE END) IS NOT DISTINCT FROM
				borrower_demographics_dim.other_race_national_origin_description_flag
			AND (CASE WHEN borrower_b1.b_race_other_american_indian_or_alaska_native_description <> ''''
				AND borrower_b1.b_race_other_american_indian_or_alaska_native_description IS NOT NULL THEN TRUE ELSE FALSE END) IS NOT DISTINCT FROM
				borrower_demographics_dim.race_other_american_indian_or_alaska_native_description_flag
			AND (CASE WHEN borrower_b1.b_race_other_asian_description <> ''''
				AND borrower_b1.b_race_other_asian_description IS NOT NULL THEN TRUE ELSE FALSE END) IS NOT DISTINCT FROM
				borrower_demographics_dim.race_other_asian_description_flag
			AND (CASE WHEN borrower_b1.b_race_other_pacific_islander_description <> ''''
				AND borrower_b1.b_race_other_pacific_islander_description IS NOT NULL THEN TRUE ELSE FALSE END) IS NOT DISTINCT FROM
				borrower_demographics_dim.race_other_pacific_islander_description_flag
			AND borrower_b1.b_ethnicity_cuban IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_cuban_flag
			AND borrower_b1.b_ethnicity_hispanic_or_latino IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_hispanic_or_latino_flag
			AND borrower_b1.b_ethnicity_mexican IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_mexican_flag
			AND borrower_b1.b_ethnicity_not_hispanic_or_latino IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_not_hispanic_or_latino_flag
			AND borrower_b1.b_ethnicity_not_obtainable IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_not_obtainable_flag
			AND borrower_b1.b_ethnicity_other_hispanic_or_latino IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_other_hispanic_or_latino_flag
			AND borrower_b1.b_ethnicity_puerto_rican IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_puerto_rican_flag
			AND borrower_b1.b_race_american_indian_or_alaska_native IS NOT DISTINCT FROM borrower_demographics_dim.race_american_indian_or_alaska_native_flag
			AND borrower_b1.b_race_asian IS NOT DISTINCT FROM borrower_demographics_dim.race_asian_flag
			AND borrower_b1.b_race_asian_indian IS NOT DISTINCT FROM borrower_demographics_dim.race_asian_indian_flag
			AND borrower_b1.b_race_black_or_african_american IS NOT DISTINCT FROM borrower_demographics_dim.race_black_or_african_american_flag
			AND borrower_b1.b_race_chinese IS NOT DISTINCT FROM borrower_demographics_dim.race_chinese_flag
			AND borrower_b1.b_race_filipino IS NOT DISTINCT FROM borrower_demographics_dim.race_filipino_flag
			AND borrower_b1.b_race_guamanian_or_chamorro IS NOT DISTINCT FROM borrower_demographics_dim.race_guamanian_or_chamorro_flag
			AND borrower_b1.b_race_information_not_provided IS NOT DISTINCT FROM borrower_demographics_dim.race_information_not_provided_flag
			AND borrower_b1.b_race_japanese IS NOT DISTINCT FROM borrower_demographics_dim.race_japanese_flag
			AND borrower_b1.b_race_korean IS NOT DISTINCT FROM borrower_demographics_dim.race_korean_flag
			AND borrower_b1.b_race_national_origin_refusal IS NOT DISTINCT FROM borrower_demographics_dim.race_national_origin_refusal_flag
			AND borrower_b1.b_race_native_hawaiian IS NOT DISTINCT FROM borrower_demographics_dim.race_native_hawaiian_flag
			AND borrower_b1.b_race_native_hawaiian_or_other_pacific_islander IS NOT DISTINCT FROM borrower_demographics_dim.race_native_hawaiian_or_other_pacific_islander_flag
			AND borrower_b1.b_race_not_applicable IS NOT DISTINCT FROM borrower_demographics_dim.race_not_applicable_flag
			AND borrower_b1.b_race_not_obtainable IS NOT DISTINCT FROM borrower_demographics_dim.race_not_obtainable_flag
			AND borrower_b1.b_race_other_asian IS NOT DISTINCT FROM borrower_demographics_dim.race_other_asian_flag
			AND borrower_b1.b_race_other_pacific_islander IS NOT DISTINCT FROM borrower_demographics_dim.race_other_pacific_islander_flag
			AND borrower_b1.b_race_samoan IS NOT DISTINCT FROM borrower_demographics_dim.race_samoan_flag
			AND borrower_b1.b_race_vietnamese IS NOT DISTINCT FROM borrower_demographics_dim.race_vietnamese_flag
			AND borrower_b1.b_race_white IS NOT DISTINCT FROM borrower_demographics_dim.race_white_flag
			AND borrower_b1.b_sex_female IS NOT DISTINCT FROM borrower_demographics_dim.sex_female_flag
			AND borrower_b1.b_sex_male IS NOT DISTINCT FROM borrower_demographics_dim.sex_male_flag
			AND borrower_b1.b_sex_not_obtainable IS NOT DISTINCT FROM borrower_demographics_dim.sex_not_obtainable_flag
			AND borrower_b1.b_marital_status_type IS NOT DISTINCT FROM borrower_demographics_dim.marital_status_code
			AND borrower_b1.b_race_collected_visual_or_surname IS NOT DISTINCT FROM borrower_demographics_dim.race_collected_visual_or_surname_code
			AND borrower_b1.b_race_refused IS NOT DISTINCT FROM borrower_demographics_dim.race_refused_code
			AND borrower_b1.b_schooling_years IS NOT DISTINCT FROM borrower_demographics_dim.schooling_years
			AND borrower_b1.b_sex_collected_visual_or_surname IS NOT DISTINCT FROM borrower_demographics_dim.sex_collected_visual_or_surname_code
			AND borrower_b1.b_sex_refused IS NOT DISTINCT FROM borrower_demographics_dim.sex_refused_code
			AND borrower_demographics_dim.data_source_dwid = 1
			-- star_loan.borrower_lending_profile_dim
			LEFT JOIN (
			SELECT borrower_lending_profile_dim.*
				, <<borrower_lending_profile_dim_partial_load_condition>> AS include_record
			FROM star_loan.borrower_lending_profile_dim
		) AS borrower_lending_profile_dim ON borrower_b1.b_alimony_child_support IS NOT DISTINCT FROM
											 borrower_lending_profile_dim.alimony_child_support_code
			AND borrower_b1.b_bankruptcy IS NOT DISTINCT FROM borrower_lending_profile_dim.bankruptcy_code
			AND borrower_b1.b_borrowed_down_payment IS NOT DISTINCT FROM borrower_lending_profile_dim.borrowed_down_payment_code
			AND borrower_b1.b_citizenship_residency_type IS NOT DISTINCT FROM borrower_lending_profile_dim.citizenship_residency_code
			AND borrower_b1.b_disabled IS NOT DISTINCT FROM borrower_lending_profile_dim.disabled_code
			AND borrower_b1.b_domestic_relationship_state_type IS NOT DISTINCT FROM borrower_lending_profile_dim.domestic_relationship_state_code
			AND borrower_b1.b_has_dependents IS NOT DISTINCT FROM borrower_lending_profile_dim.dependents_code
			AND borrower_b1.b_homeowner_past_three_years IS NOT DISTINCT FROM borrower_lending_profile_dim.homeowner_past_three_years_code
			AND borrower_b1.b_homeownership_education_agency_type IS NOT DISTINCT FROM borrower_lending_profile_dim
				.homeownership_education_agency_code
			AND borrower_b1.b_homeownership_education_type IS NOT DISTINCT FROM borrower_lending_profile_dim.homeownership_education_code
			AND borrower_b1.b_intend_to_occupy IS NOT DISTINCT FROM borrower_lending_profile_dim.intend_to_occupy_code
			AND borrower_b1.b_first_time_homebuyer IS NOT DISTINCT FROM borrower_lending_profile_dim.first_time_homebuyer_flag
			AND borrower_b1.b_first_time_home_buyer_auto_compute IS NOT DISTINCT FROM borrower_lending_profile_dim.first_time_homebuyer_auto_compute_flag
			AND borrower_b1.b_hud_employee IS NOT DISTINCT FROM borrower_lending_profile_dim.hud_employee_flag
			AND borrower_b1.b_lender_employee_status_confirmed IS NOT DISTINCT FROM borrower_lending_profile_dim.lender_employee_status_confirmed_flag
			AND borrower_b1.b_lender_employee IS NOT DISTINCT FROM borrower_lending_profile_dim.lender_employee_code
			AND borrower_b1.b_note_endorser IS NOT DISTINCT FROM borrower_lending_profile_dim.note_endorser_code
			AND borrower_b1.b_obligated_loan_foreclosure IS NOT DISTINCT FROM borrower_lending_profile_dim.obligated_loan_foreclosure_code
			AND borrower_b1.b_on_gsa_list IS NOT DISTINCT FROM borrower_lending_profile_dim.on_gsa_list_code
			AND borrower_b1.b_on_ldp_list IS NOT DISTINCT FROM borrower_lending_profile_dim.on_ldp_list_code
			AND borrower_b1.b_outstanding_judgements IS NOT DISTINCT FROM borrower_lending_profile_dim.outstanding_judgements_code
			AND borrower_b1.b_party_to_lawsuit IS NOT DISTINCT FROM borrower_lending_profile_dim.party_to_lawsuit_code
			AND borrower_b1.b_presently_delinquent IS NOT DISTINCT FROM borrower_lending_profile_dim.presently_delinquent_code
			AND borrower_b1.b_property_foreclosure IS NOT DISTINCT FROM borrower_lending_profile_dim.property_foreclosure_code
			AND borrower_b1.b_spousal_homestead IS NOT DISTINCT FROM borrower_lending_profile_dim.spousal_homestead_code
			AND borrower_b1.b_titleholder IS NOT DISTINCT FROM borrower_lending_profile_dim.titleholder_code
			AND borrower_lending_profile_dim.data_source_dwid = 1
          -- star_loan.borrower_lkup
          LEFT JOIN (
           SELECT borrower_lkup.*
                , <<borrower_lkup_partial_load_condition>> AS include_record
           FROM star_loan.borrower_lkup
      ) AS b1_borrower_lkup
          ON borrower_b1_dim.dwid = b1_borrower_lkup.borrower_dwid
			-- star_loan.lender_user_dim: collateral_to_custodian
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS collateral_to_custodian
			ON deal_key_roles.dkrs_collateral_to_custodian_lender_user_pid = collateral_to_custodian.lender_user_pid
				AND collateral_to_custodian.data_source_dwid = 1
			-- star_loan.lender_user_dim: account_executive
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS account_executive
			ON deal_key_roles.dkrs_account_executive_lender_user_pid = account_executive.lender_user_pid
				AND account_executive.data_source_dwid = 1
			-- star_loan.lender_user_dim: closing_doc_specialist
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS closing_doc_specialist
			ON deal_key_roles.dkrs_closing_doc_specialist_lender_user_pid = closing_doc_specialist.lender_user_pid
				AND closing_doc_specialist.data_source_dwid = 1
			-- star_loan.lender_user_dim: closing_scheduler
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS closing_scheduler
			ON deal_key_roles.dkrs_closing_scheduler_lender_user_pid = closing_scheduler.lender_user_pid
				AND closing_scheduler.data_source_dwid = 1
			-- star_loan.lender_user_dim: collateral_to_investor
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS collateral_to_investor
			ON deal_key_roles.dkrs_collateral_to_investor_lender_user_pid = collateral_to_investor.lender_user_pid
				AND collateral_to_investor.data_source_dwid = 1
			-- star_loan.lender_user_dim: collateral_underwriter
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS collateral_underwriter
			ON deal_key_roles.dkrs_collateral_underwriter_lender_user_pid = collateral_underwriter.lender_user_pid
				AND collateral_underwriter.data_source_dwid = 1
			-- star_loan.lender_user_dim: correspondent_client_advocate
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS correspondent_client_advocate
			ON deal_key_roles.dkrs_correspondent_client_advocate_lender_user_pid = correspondent_client_advocate.lender_user_pid
				AND correspondent_client_advocate.data_source_dwid = 1
			-- star_loan.lender_user_dim: final_documents_to_investor
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS final_documents_to_investor
			ON deal_key_roles.dkrs_final_documents_to_investor_lender_user_pid = final_documents_to_investor.lender_user_pid
				AND final_documents_to_investor.data_source_dwid = 1
			-- star_loan.lender_user_dim: flood_insurance_specialist
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS flood_insurance_specialist
			ON deal_key_roles.dkrs_flood_insurance_specialist_lender_user_pid = flood_insurance_specialist.lender_user_pid
				AND flood_insurance_specialist.data_source_dwid = 1
			-- star_loan.lender_user_dim: funder
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS funder
			ON deal_key_roles.dkrs_funder_lender_user_pid = funder.lender_user_pid
				AND funder.data_source_dwid = 1
			-- star_loan.lender_user_dim: government_insurance
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS government_insurance
			ON deal_key_roles.dkrs_government_insurance_lender_user_pid = government_insurance.lender_user_pid
				AND government_insurance.data_source_dwid = 1
			-- star_loan.lender_user_dim: ho6_specialist
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS ho6_specialist
			ON deal_key_roles.dkrs_ho6_specialist_lender_user_pid = ho6_specialist.lender_user_pid
				AND ho6_specialist.data_source_dwid = 1
			-- star_loan.lender_user_dim: hoa_specialist
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS hoa_specialist
			ON deal_key_roles.dkrs_hoa_specialist_lender_user_pid = hoa_specialist.lender_user_pid
				AND hoa_specialist.data_source_dwid = 1
			-- star_loan.lender_user_dim: hoi_specialist
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS hoi_specialist
			ON deal_key_roles.dkrs_hoi_specialist_lender_user_pid = hoi_specialist.lender_user_pid
				AND hoi_specialist.data_source_dwid = 1
			-- star_loan.lender_user_dim: hud_va_lender_officer
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS hud_va_lender_officer
			ON deal_key_roles.dkrs_hud_va_lender_officer_lender_user_pid = hud_va_lender_officer.lender_user_pid
				AND hud_va_lender_officer.data_source_dwid = 1
			-- star_loan.lender_user_dim: internal_construction_manager
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS internal_construction_manager
			ON deal_key_roles.dkrs_internal_construction_manager_lender_user_pid = internal_construction_manager.lender_user_pid
				AND internal_construction_manager.data_source_dwid = 1
			-- star_loan.lender_user_dim: investor_conditions
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS investor_conditions
			ON deal_key_roles.dkrs_investor_conditions_lender_user_pid = investor_conditions.lender_user_pid
				AND investor_conditions.data_source_dwid = 1
			-- star_loan.lender_user_dim: investor_stack_to_investor
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS investor_stack_to_investor
			ON deal_key_roles.dkrs_investor_stack_to_investor_lender_user_pid = investor_stack_to_investor.lender_user_pid
				AND investor_stack_to_investor.data_source_dwid = 1
			-- star_loan.lender_user_dim: loan_officer_assistant
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS loan_officer_assistant
			ON deal_key_roles.dkrs_loan_officer_assistant_lender_user_pid = loan_officer_assistant.lender_user_pid
				AND loan_officer_assistant.data_source_dwid = 1
			-- star_loan.lender_user_dim: loan_payoff_specialist
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS loan_payoff_specialist
			ON deal_key_roles.dkrs_loan_payoff_specialist_lender_user_pid = loan_payoff_specialist.lender_user_pid
				AND loan_payoff_specialist.data_source_dwid = 1
			-- star_loan.lender_user_dim: originator
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS originator
			ON deal_key_roles.dkrs_originator_lender_user_pid = originator.lender_user_pid
				AND originator.data_source_dwid = 1
			-- star_loan.lender_user_dim: processor
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS processor
			ON deal_key_roles.dkrs_processor_lender_user_pid = processor.lender_user_pid
				AND processor.data_source_dwid = 1
			-- star_loan.lender_user_dim: project_underwriter
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS project_underwriter
			ON deal_key_roles.dkrs_project_underwriter_lender_user_pid = project_underwriter.lender_user_pid
				AND project_underwriter.data_source_dwid = 1
			-- star_loan.lender_user_dim: subordination_specialist
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS subordination_specialist
			ON deal_key_roles.dkrs_subordination_specialist_lender_user_pid = subordination_specialist.lender_user_pid
				AND subordination_specialist.data_source_dwid = 1
			-- star_loan.lender_user_dim: supplemental_originator
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS supplemental_originator
			ON deal_key_roles.dkrs_supplemental_originator_lender_user_pid = supplemental_originator.lender_user_pid
				AND supplemental_originator.data_source_dwid = 1
			-- star_loan.lender_user_dim: title_specialist
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS title_specialist
			ON deal_key_roles.dkrs_title_specialist_lender_user_pid = title_specialist.lender_user_pid
				AND title_specialist.data_source_dwid = 1
			-- star_loan.lender_user_dim: transaction_assistant
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS transaction_assistant
			ON deal_key_roles.dkrs_transaction_assistant_lender_user_pid = transaction_assistant.lender_user_pid
				AND transaction_assistant.data_source_dwid = 1
			-- star_loan.lender_user_dim: underwriter
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS underwriter
			ON deal_key_roles.dkrs_underwriter_lender_user_pid = underwriter.lender_user_pid
				AND underwriter.data_source_dwid = 1
			-- star_loan.lender_user_dim: underwriting_manager
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS underwriting_manager
			ON deal_key_roles.dkrs_underwriting_manager_lender_user_pid = underwriting_manager.lender_user_pid
				AND underwriting_manager.data_source_dwid = 1
			-- star_loan.lender_user_dim: va_specialist
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS va_specialist
			ON deal_key_roles.dkrs_va_specialist_lender_user_pid = va_specialist.lender_user_pid
				AND va_specialist.data_source_dwid = 1
			-- star_loan.lender_user_dim: verbal_voe_specialist
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS verbal_voe_specialist
			ON deal_key_roles.dkrs_verbal_voe_specialist_lender_user_pid = verbal_voe_specialist.lender_user_pid
				AND verbal_voe_specialist.data_source_dwid = 1
			-- star_loan.lender_user_dim: voe_specialist
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS voe_specialist
			ON deal_key_roles.dkrs_voe_specialist_lender_user_pid = voe_specialist.lender_user_pid
				AND voe_specialist.data_source_dwid = 1
			-- star_loan.lender_user_dim: wholesale_client_advocate
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS wholesale_client_advocate
			ON deal_key_roles.dkrs_wholesale_client_advocate_lender_user_pid = wholesale_client_advocate.lender_user_pid
				AND wholesale_client_advocate.data_source_dwid = 1
			-- star_loan.lender_user_dim: wire_specialist
			LEFT JOIN (
			SELECT lender_user_dim.*
				, <<lender_user_dim_partial_load_condition>> AS include_record
			FROM star_loan.lender_user_dim
		) AS wire_specialist
			ON deal_key_roles.dkrs_wire_specialist_lender_user_pid = wire_specialist.lender_user_pid
				AND wire_specialist.data_source_dwid = 1
			-- star_loan.interim_funder_dim
			LEFT JOIN (
			SELECT interim_funder_dim.*
				, <<interim_funder_dim_partial_load_condition>> AS include_record
			FROM star_loan.interim_funder_dim
		) AS interim_funder_dim ON interim_funder.if_pid = interim_funder_dim.interim_funder_pid
			AND interim_funder_dim.data_source_dwid = 1
			-- star_loan.product_terms_dim
			LEFT JOIN (
			SELECT product_terms_dim.*
				, <<product_terms_dim_partial_load_condition>> AS include_record
			FROM star_loan.product_terms_dim
		) AS product_terms_dim ON product_terms.pt_pid = product_terms_dim.product_terms_pid
			AND product_terms_dim.data_source_dwid = 1
			-- star_loan.product_dim
			LEFT JOIN (
			SELECT product_dim.*
				, <<product_dim_partial_load_condition>> AS include_record
			FROM star_loan.product_dim
		) AS product_dim ON product.p_pid = product_dim.product_pid
			AND product_dim.data_source_dwid = 1
			-- star_loan.investor_dim
			LEFT JOIN (
			SELECT investor_dim.*
				, <<investor_dim_partial_load_condition>> AS include_record
			FROM star_loan.investor_dim
		) AS investor_dim ON product_investor.i_pid = investor_dim.investor_pid
			AND investor_dim.data_source_dwid = 1
			-- star_loan.hmda_purchaser_of_loan_dim
			LEFT JOIN (
			SELECT hmda_purchaser_of_loan_dim.*
				, <<hmda_purchaser_of_loan_dim_partial_load_condition>> AS include_record
			FROM star_loan.hmda_purchaser_of_loan_dim
		) AS hmda_purchaser_of_loan_dim ON hmda_purchaser_of_loan_2017_type.code IS NOT DISTINCT FROM hmda_purchaser_of_loan_dim.code_2017
			AND hmda_purchaser_of_loan_2018_type.code IS NOT DISTINCT FROM hmda_purchaser_of_loan_dim.code_2018
			AND hmda_purchaser_of_loan_dim.data_source_dwid = 1
			-- star_loan.cash_out_reason_dim
			LEFT JOIN (
			SELECT cash_out_reason_dim.*
			    , <<cash_out_reason_dim_partial_load_condition>> AS include_record
			FROM star_loan.cash_out_reason_dim
		) AS cash_out_reason_dim ON proposal.prp_cash_out_reason_business_debt_or_debt_consolidation IS NOT DISTINCT FROM
		                            cash_out_reason_dim.cash_out_reason_business_debt_or_debt_consolidation_flag
			    AND proposal.prp_cash_out_reason_debt_or_debt_consolidation IS NOT DISTINCT FROM cash_out_reason_dim
			        .cash_out_reason_debt_or_debt_consolidation_flag
			    AND proposal.prp_cash_out_reason_future_investment_not_under_contract IS NOT DISTINCT FROM
			        cash_out_reason_dim.cash_out_reason_future_investment_not_under_contract_flag
			    AND proposal.prp_cash_out_reason_future_investment_under_contract IS NOT DISTINCT FROM
			        cash_out_reason_dim.cash_out_reason_future_investment_under_contract_flag
			    AND proposal.prp_cash_out_reason_home_improvement IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_home_improvement_flag
			    AND proposal.prp_cash_out_reason_investment_or_business_property IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_investment_or_business_property_flag
			    AND proposal.prp_cash_out_reason_other IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_other_flag
			    AND proposal.prp_cash_out_reason_personal_use IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_personal_use_flag
			    AND proposal.prp_cash_out_reason_student_loans IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_student_loans_flag
			    AND proposal.prp_non_business_cash_out_reason_acknowledged IS NOT DISTINCT FROM cash_out_reason_dim.non_business_cash_out_reason_acknowledged_code
			    AND cash_out_reason_dim.data_source_dwid = 1
			-- star_loan.hmda_action_dim
		    LEFT JOIN (
				SELECT hmda_action_dim.*
					, <<hmda_action_dim_partial_load_condition>> AS include_record
				FROM star_loan.hmda_action_dim
		) AS hmda_action_dim ON deal.d_hmda_action_type IS NOT DISTINCT FROM hmda_action_dim.hmda_action_code
			    AND deal.d_hmda_denial_reason_type_1 IS NOT DISTINCT FROM hmda_action_dim.hmda_denial_reason_code_1
				AND deal.d_hmda_denial_reason_type_2 IS NOT DISTINCT FROM hmda_action_dim.hmda_denial_reason_code_2
				AND deal.d_hmda_denial_reason_type_3 IS NOT DISTINCT FROM hmda_action_dim.hmda_denial_reason_code_3
				AND deal.d_hmda_denial_reason_type_4 IS NOT DISTINCT FROM hmda_action_dim.hmda_denial_reason_code_4
		        AND hmda_action_dim.data_source_dwid = 1
		    -- star_loan.underwrite_dim
		    LEFT JOIN (
		        SELECT underwrite_dim.*
		        	, <<underwrite_dim_partial_load_condition>> AS include_record
		        FROM star_loan.underwrite_dim
		) AS underwrite_dim ON proposal.prp_underwrite_disposition_type IS NOT DISTINCT FROM underwrite_dim.underwrite_disposition_code
		    	AND proposal.prp_underwrite_method_type IS NOT DISTINCT FROM underwrite_dim.underwrite_method_code
		    	AND proposal.prp_underwrite_risk_assessment_type IS NOT DISTINCT FROM underwrite_dim.underwrite_risk_assessment_code
		    	AND underwrite_dim.data_source_dwid = 1
          -- star_loan.date_dim joins for date dwids
			LEFT JOIN star_common.date_dim current_deal_stage_date_dim ON deal_stage.dst_from_date = current_deal_stage_date_dim.value
			LEFT JOIN star_common.date_dim agency_case_id_assigned_date_dim ON loan.l_agency_case_id_assigned_date =
																			   agency_case_id_assigned_date_dim.value
			LEFT JOIN star_common.date_dim apor_date_dim ON loan.l_apor_date = apor_date_dim.value
			LEFT JOIN star_common.date_dim application_signed_date_dim ON borrower_b1.b_application_signed_date =
																		  application_signed_date_dim.value
			LEFT JOIN star_common.date_dim approved_with_conditions_date_dim ON
				current_loan_beneficiary.lb_approved_with_conditions_date = approved_with_conditions_date_dim.value
			LEFT JOIN star_common.date_dim beneficiary_from_date_dim ON current_loan_beneficiary.lb_from_date
			= beneficiary_from_date_dim.value
			LEFT JOIN star_common.date_dim beneficiary_through_date_dim ON current_loan_beneficiary.lb_through_date =
																		   beneficiary_through_date_dim.value
			LEFT JOIN star_common.date_dim collateral_sent_date_dim ON active_loan_funding.lf_collateral_sent_date =
																	   collateral_sent_date_dim.value
			LEFT JOIN star_common.date_dim disbursement_date_dim ON active_loan_funding.lf_disbursement_date =
																	disbursement_date_dim.value
			LEFT JOIN star_common.date_dim early_funding_date_dim ON current_loan_beneficiary.lb_early_funding_date =
																	 early_funding_date_dim.value
			LEFT JOIN star_common.date_dim effective_funding_date_dim ON proposal.prp_effective_funding_date =
																		 effective_funding_date_dim.value
			LEFT JOIN star_common.date_dim fha_endorsement_date_dim ON loan.l_fha_endorsement_date =
																	   fha_endorsement_date_dim.value
			LEFT JOIN star_common.date_dim estimated_funding_date_dim ON proposal.prp_estimated_funding_date =
																		 estimated_funding_date_dim.value
			LEFT JOIN star_common.date_dim intent_to_proceed_date_dim ON proposal.prp_intent_to_proceed_date =
																		 intent_to_proceed_date_dim.value
			LEFT JOIN star_common.date_dim funding_date_dim ON active_loan_funding.lf_funding_date = funding_date_dim.value
			LEFT JOIN star_common.date_dim funding_requested_date_dim ON active_loan_funding.lf_requested_date =
																		 funding_requested_date_dim.value
			LEFT JOIN star_common.date_dim loan_file_ship_date_dim ON current_loan_beneficiary.lb_loan_file_ship_date =
																	  loan_file_ship_date_dim.value
			LEFT JOIN star_common.date_dim mers_transfer_creation_date_dim ON current_loan_beneficiary.lb_mers_transfer_creation_date =
																			  mers_transfer_creation_date_dim.value
			LEFT JOIN star_common.date_dim pending_wire_date_dim ON current_loan_beneficiary.lb_pending_wire_date =
																	pending_wire_date_dim.value
			LEFT JOIN star_common.date_dim rejected_date_dim ON current_loan_beneficiary.lb_rejected_date =
																rejected_date_dim.value
			LEFT JOIN star_common.date_dim return_confirmed_date_dim ON active_loan_funding.lf_return_confirmed_date =
																		return_confirmed_date_dim.value
			LEFT JOIN star_common.date_dim return_request_date_dim ON active_loan_funding.lf_return_request_date =
																	  return_request_date_dim.value
			LEFT JOIN star_common.date_dim scheduled_release_date_dim ON active_loan_funding.lf_scheduled_release_date =
																		 scheduled_release_date_dim.value
			LEFT JOIN star_common.date_dim usda_guarantee_date_dim ON loan.l_usda_guarantee_date = usda_guarantee_date_dim.value
			LEFT JOIN star_common.date_dim va_guaranty_date_dim ON loan.l_va_guaranty_date = va_guaranty_date_dim.value
			LEFT JOIN star_common.date_dim cd_clear_date_dim ON proposal.prp_cd_clear_date = cd_clear_date_dim.value
			LEFT JOIN star_common.date_dim charges_enabled_date_dim ON deal.d_charges_enabled_date =
																	   charges_enabled_date_dim.value
			LEFT JOIN star_common.date_dim effective_earliest_allowed_consummation_date_dim
			ON proposal.prp_effective_earliest_allowed_consummation_date = effective_earliest_allowed_consummation_date_dim.value
			LEFT JOIN star_common.date_dim effective_hmda_action_date_dim ON deal.d_effective_hmda_action_date =
																			 effective_hmda_action_date_dim.value
			LEFT JOIN star_common.date_dim effective_note_date_dim ON proposal.prp_effective_note_date = effective_note_date_dim.value
			LEFT JOIN star_common.date_dim hmda_action_date_dim ON deal.d_hmda_action_date = hmda_action_date_dim.value
			LEFT JOIN star_common.date_dim initial_cancel_status_date_dim ON deal.d_initial_cancel_status_date =
																			 initial_cancel_status_date_dim.value
			LEFT JOIN star_common.date_dim initial_uw_disposition_date_dim ON DATE(proposal
			.prp_initial_uw_disposition_datetime) = initial_uw_disposition_date_dim.value
			LEFT JOIN star_common.date_dim initial_uw_submit_date_dim ON DATE(proposal
			.prp_initial_uw_submit_datetime) = initial_uw_submit_date_dim.value
			LEFT JOIN star_common.date_dim note_date_dim ON proposal.prp_note_date = note_date_dim.value
			LEFT JOIN star_common.date_dim preapproval_uw_submit_date_dim ON DATE(proposal
			.prp_preapproval_uw_submit_datetime) = preapproval_uw_submit_date_dim.value
			LEFT JOIN star_common.date_dim transaction_create_date_dim ON deal.d_deal_create_date = transaction_create_date_dim.value
			LEFT JOIN star_common.date_dim transaction_welcome_call_date_dim ON DATE(deal.d_welcome_call_datetime) =
																		 transaction_welcome_call_date_dim.value
			LEFT JOIN star_common.date_dim trid_application_date_dim ON deal.d_trid_application_date =
																		trid_application_date_dim.value
			LEFT JOIN star_common.date_dim underwrite_publish_date_dim ON proposal.prp_underwrite_publish_date =
																		  underwrite_publish_date_dim.value
	WHERE GREATEST(deal.include_record, proposal.include_record, primary_application.include_record, loan.include_record,
				   deal_key_roles.include_record, deal_stage.include_record, borrower_b1.include_record,
                 borrower_b2.include_record,
				   borrower_b3.include_record,
				   borrower_b4.include_record, borrower_b5.include_record, borrower_c1.include_record,
				   borrower_c2.include_record,
				   borrower_c3.include_record, borrower_c4.include_record, borrower_c5.include_record,
				   borrower_n1.include_record,
				   borrower_n2.include_record, borrower_n3.include_record, borrower_n4.include_record,
				   borrower_n5.include_record,
				   borrower_n6.include_record, borrower_n7.include_record, borrower_n8.include_record,
				   current_loan_beneficiary.include_record, initial_loan_beneficiary.include_record,
				   first_loan_beneficiary_after_initial.include_record, most_recent_purchasing_beneficiary.include_record,
				   active_loan_funding.include_record, interim_funder.include_record, product_terms.include_record,
				   product.include_record, product_investor.include_record, application_dim.include_record,
				   loan_junk_dim.include_record, product_choice_dim.include_record, transaction_junk_dim.include_record,
				   borrower_b1_dim.include_record, borrower_b2_dim.include_record, borrower_b3_dim.include_record,
				   borrower_b4_dim.include_record, borrower_b5_dim.include_record,
				   borrower_c1_dim.include_record, borrower_c2_dim.include_record, borrower_c3_dim.include_record,
				   borrower_c4_dim.include_record, borrower_c5_dim.include_record, borrower_n1_dim.include_record,
				   borrower_n2_dim.include_record, borrower_n3_dim.include_record, borrower_n4_dim.include_record,
				   borrower_n5_dim.include_record, borrower_n6_dim.include_record, borrower_n7_dim.include_record,
				   borrower_n8_dim.include_record, borrower_demographics_dim.include_record,
				   borrower_lending_profile_dim.include_record, b1_borrower_lkup.include_record,
                 hmda_purchaser_of_loan_dim.include_record, interim_funder_dim.include_record,
				   investor_dim.include_record, collateral_to_custodian.include_record, account_executive.include_record,
				   closing_doc_specialist.include_record, closing_scheduler.include_record,
				   collateral_to_investor.include_record,
				   collateral_underwriter.include_record, correspondent_client_advocate.include_record,
				   final_documents_to_investor.include_record, flood_insurance_specialist.include_record,
				   funder.include_record,
				   government_insurance.include_record, ho6_specialist.include_record, hoa_specialist.include_record,
				   hoi_specialist.include_record, hud_va_lender_officer.include_record,
				   internal_construction_manager.include_record, investor_conditions.include_record,
				   investor_stack_to_investor.include_record, loan_officer_assistant.include_record,
				   loan_payoff_specialist.include_record,
				   originator.include_record, processor.include_record, project_underwriter.include_record,
				   subordination_specialist.include_record,
				   supplemental_originator.include_record, title_specialist.include_record,
				   transaction_assistant.include_record,
				   underwriter.include_record, underwriting_manager.include_record, va_specialist.include_record,
				   verbal_voe_specialist.include_record, voe_specialist.include_record,
				   wholesale_client_advocate.include_record,
				   wire_specialist.include_record,
				   current_loan_beneficiary_dim.include_record, current_beneficiary_investor_dim.include_record,
				   initial_beneficiary_investor_dim.include_record,
				   first_beneficiary_after_initial_investor_dim.include_record,
				   most_recent_purchasing_beneficiary_investor_dim.include_record,
				   loan_dim.include_record, loan_funding_dim.include_record, product_dim.include_record,
				   product_terms_dim.include_record, transaction_dim.include_record, cash_out_reason_dim.include_record,
	    		   hmda_action_dim.include_record, underwrite_dim.include_record) IS TRUE
) AS loan_fact_incl_new_records
	LEFT JOIN star_loan.loan_fact ON loan_fact_incl_new_records.data_source_integration_id =
									 loan_fact.data_source_integration_id
		AND loan_fact_incl_new_records.loan_junk_dwid = loan_fact.loan_junk_dwid
		AND loan_fact_incl_new_records.product_choice_dwid = loan_fact.product_choice_dwid
		AND loan_fact_incl_new_records.transaction_dwid = loan_fact.transaction_dwid
		AND loan_fact_incl_new_records.transaction_junk_dwid = loan_fact.transaction_junk_dwid
		AND loan_fact_incl_new_records.current_loan_beneficiary_dwid = loan_fact.current_loan_beneficiary_dwid
		AND loan_fact_incl_new_records.active_loan_funding_dwid = loan_fact.active_loan_funding_dwid
		AND loan_fact_incl_new_records.b1_borrower_dwid = loan_fact.b1_borrower_dwid
		AND loan_fact_incl_new_records.b2_borrower_dwid = loan_fact.b2_borrower_dwid
		AND loan_fact_incl_new_records.b3_borrower_dwid = loan_fact.b3_borrower_dwid
		AND loan_fact_incl_new_records.b4_borrower_dwid = loan_fact.b4_borrower_dwid
		AND loan_fact_incl_new_records.b5_borrower_dwid = loan_fact.b5_borrower_dwid
		AND loan_fact_incl_new_records.c1_borrower_dwid = loan_fact.c1_borrower_dwid
		AND loan_fact_incl_new_records.c2_borrower_dwid = loan_fact.c2_borrower_dwid
		AND loan_fact_incl_new_records.c3_borrower_dwid = loan_fact.c3_borrower_dwid
		AND loan_fact_incl_new_records.c4_borrower_dwid = loan_fact.c4_borrower_dwid
		AND loan_fact_incl_new_records.c5_borrower_dwid = loan_fact.c5_borrower_dwid
		AND loan_fact_incl_new_records.n1_borrower_dwid = loan_fact.n1_borrower_dwid
		AND loan_fact_incl_new_records.n2_borrower_dwid = loan_fact.n2_borrower_dwid
		AND loan_fact_incl_new_records.n3_borrower_dwid = loan_fact.n3_borrower_dwid
		AND loan_fact_incl_new_records.n4_borrower_dwid = loan_fact.n4_borrower_dwid
		AND loan_fact_incl_new_records.n5_borrower_dwid = loan_fact.n5_borrower_dwid
		AND loan_fact_incl_new_records.n6_borrower_dwid = loan_fact.n6_borrower_dwid
		AND loan_fact_incl_new_records.n7_borrower_dwid = loan_fact.n7_borrower_dwid
		AND loan_fact_incl_new_records.n8_borrower_dwid = loan_fact.n8_borrower_dwid
		AND loan_fact_incl_new_records.b1_borrower_demographics_dwid = loan_fact.b1_borrower_demographics_dwid
		AND loan_fact_incl_new_records.b1_borrower_lending_profile_dwid = loan_fact.b1_borrower_lending_profile_dwid
      AND loan_fact_incl_new_records.b1_borrower_hmda_collection_dwid = loan_fact.b1_borrower_hmda_collection_dwid
		AND loan_fact_incl_new_records.primary_application_dwid = loan_fact.primary_application_dwid
		AND loan_fact_incl_new_records.collateral_to_custodian_lender_user_dwid =
			loan_fact.collateral_to_custodian_lender_user_dwid
		AND loan_fact_incl_new_records.interim_funder_dwid = loan_fact.interim_funder_dwid
		AND loan_fact_incl_new_records.product_terms_dwid = loan_fact.product_terms_dwid
		AND loan_fact_incl_new_records.product_dwid = loan_fact.product_dwid
		AND loan_fact_incl_new_records.product_investor_dwid = loan_fact.product_investor_dwid
		AND loan_fact_incl_new_records.hmda_purchaser_of_loan_dwid = loan_fact.hmda_purchaser_of_loan_dwid
		AND loan_fact_incl_new_records.apr IS NOT DISTINCT FROM loan_fact.apr
		AND loan_fact_incl_new_records.base_loan_amount IS NOT DISTINCT FROM loan_fact.base_loan_amount
		AND loan_fact_incl_new_records.financed_amount IS NOT DISTINCT FROM loan_fact.financed_amount
		AND loan_fact_incl_new_records.loan_amount IS NOT DISTINCT FROM loan_fact.loan_amount
		AND loan_fact_incl_new_records.ltv_ratio_percent IS NOT DISTINCT FROM loan_fact.ltv_ratio_percent
		AND loan_fact_incl_new_records.note_rate_percent IS NOT DISTINCT FROM loan_fact.note_rate_percent
		AND loan_fact_incl_new_records.purchase_advice_amount IS NOT DISTINCT FROM loan_fact.purchase_advice_amount
		AND loan_fact_incl_new_records.finance_charge_amount IS NOT DISTINCT FROM loan_fact.finance_charge_amount
		AND loan_fact_incl_new_records.hoepa_fees_dollar_amount IS NOT DISTINCT FROM loan_fact.hoepa_fees_dollar_amount
		AND loan_fact_incl_new_records.interest_rate_fee_change_amount IS NOT DISTINCT FROM loan_fact.interest_rate_fee_change_amount
		AND loan_fact_incl_new_records.principal_curtailment_amount IS NOT DISTINCT FROM loan_fact.principal_curtailment_amount
		AND loan_fact_incl_new_records.qualifying_pi_amount IS NOT DISTINCT FROM loan_fact.qualifying_pi_amount
		AND loan_fact_incl_new_records.target_cash_out_amount IS NOT DISTINCT FROM loan_fact.target_cash_out_amount
		AND loan_fact_incl_new_records.heloc_maximum_balance_amount IS NOT DISTINCT FROM loan_fact.heloc_maximum_balance_amount
		AND loan_fact_incl_new_records.agency_case_id_assigned_date_dwid = loan_fact.agency_case_id_assigned_date_dwid
		AND loan_fact_incl_new_records.apor_date_dwid = loan_fact.apor_date_dwid
		AND loan_fact_incl_new_records.application_signed_date_dwid = loan_fact.application_signed_date_dwid
		AND loan_fact_incl_new_records.approved_with_conditions_date_dwid = loan_fact.approved_with_conditions_date_dwid
		AND loan_fact_incl_new_records.beneficiary_from_date_dwid = loan_fact.beneficiary_from_date_dwid
		AND loan_fact_incl_new_records.beneficiary_through_date_dwid = loan_fact.beneficiary_through_date_dwid
		AND loan_fact_incl_new_records.collateral_sent_date_dwid = loan_fact.collateral_sent_date_dwid
		AND loan_fact_incl_new_records.disbursement_date_dwid = loan_fact.disbursement_date_dwid
		AND loan_fact_incl_new_records.early_funding_date_dwid = loan_fact.early_funding_date_dwid
		AND loan_fact_incl_new_records.effective_funding_date_dwid = loan_fact.effective_funding_date_dwid
		AND loan_fact_incl_new_records.fha_endorsement_date_dwid = loan_fact.fha_endorsement_date_dwid
		AND loan_fact_incl_new_records.estimated_funding_date_dwid = loan_fact.estimated_funding_date_dwid
		AND loan_fact_incl_new_records.intent_to_proceed_date_dwid = loan_fact.intent_to_proceed_date_dwid
		AND loan_fact_incl_new_records.funding_date_dwid = loan_fact.funding_date_dwid
		AND loan_fact_incl_new_records.funding_requested_date_dwid = loan_fact.funding_requested_date_dwid
		AND loan_fact_incl_new_records.loan_file_ship_date_dwid = loan_fact.loan_file_ship_date_dwid
		AND loan_fact_incl_new_records.mers_transfer_creation_date_dwid = loan_fact.mers_transfer_creation_date_dwid
		AND loan_fact_incl_new_records.pending_wire_date_dwid = loan_fact.pending_wire_date_dwid
		AND loan_fact_incl_new_records.rejected_date_dwid = loan_fact.rejected_date_dwid
		AND loan_fact_incl_new_records.return_confirmed_date_dwid = loan_fact.return_confirmed_date_dwid
		AND loan_fact_incl_new_records.return_request_date_dwid = loan_fact.return_request_date_dwid
		AND loan_fact_incl_new_records.scheduled_release_date_dwid = loan_fact.scheduled_release_date_dwid
		AND loan_fact_incl_new_records.usda_guarantee_date_dwid = loan_fact.usda_guarantee_date_dwid
		AND loan_fact_incl_new_records.va_guaranty_date_dwid = loan_fact.va_guaranty_date_dwid
		AND loan_fact_incl_new_records.account_executive_lender_user_dwid = loan_fact.account_executive_lender_user_dwid
		AND loan_fact_incl_new_records.closing_doc_specialist_lender_user_dwid =
			loan_fact.closing_doc_specialist_lender_user_dwid
		AND loan_fact_incl_new_records.closing_scheduler_lender_user_dwid = loan_fact.closing_scheduler_lender_user_dwid
		AND loan_fact_incl_new_records.collateral_to_investor_lender_user_dwid =
			loan_fact.collateral_to_investor_lender_user_dwid
		AND loan_fact_incl_new_records.collateral_underwriter_lender_user_dwid =
			loan_fact.collateral_underwriter_lender_user_dwid
		AND loan_fact_incl_new_records.correspondent_client_advocate_lender_user_dwid =
			loan_fact.correspondent_client_advocate_lender_user_dwid
		AND loan_fact_incl_new_records.final_documents_to_investor_lender_user_dwid = loan_fact
			.final_documents_to_investor_lender_user_dwid
		AND loan_fact_incl_new_records.flood_insurance_specialist_lender_user_dwid = loan_fact
			.flood_insurance_specialist_lender_user_dwid
		AND loan_fact_incl_new_records.funder_lender_user_dwid = loan_fact.funder_lender_user_dwid
		AND loan_fact_incl_new_records.government_insurance_lender_user_dwid = loan_fact
			.government_insurance_lender_user_dwid
		AND loan_fact_incl_new_records.ho6_specialist_lender_user_dwid = loan_fact.ho6_specialist_lender_user_dwid
		AND loan_fact_incl_new_records.hoa_specialist_lender_user_dwid = loan_fact.hoa_specialist_lender_user_dwid
		AND loan_fact_incl_new_records.hoi_specialist_lender_user_dwid = loan_fact.hoi_specialist_lender_user_dwid
		AND loan_fact_incl_new_records.hud_va_lender_officer_lender_user_dwid = loan_fact
			.hud_va_lender_officer_lender_user_dwid
		AND loan_fact_incl_new_records.internal_construction_manager_lender_user_dwid = loan_fact
			.internal_construction_manager_lender_user_dwid
		AND loan_fact_incl_new_records.investor_conditions_lender_user_dwid = loan_fact
			.investor_conditions_lender_user_dwid
		AND loan_fact_incl_new_records.investor_stack_to_investor_lender_user_dwid = loan_fact
			.investor_stack_to_investor_lender_user_dwid
		AND loan_fact_incl_new_records.loan_officer_assistant_lender_user_dwid = loan_fact
			.loan_officer_assistant_lender_user_dwid
		AND loan_fact_incl_new_records.loan_payoff_specialist_lender_user_dwid = loan_fact
			.loan_payoff_specialist_lender_user_dwid
		AND loan_fact_incl_new_records.originator_lender_user_dwid = loan_fact.originator_lender_user_dwid
		AND loan_fact_incl_new_records.processor_lender_user_dwid = loan_fact.processor_lender_user_dwid
		AND loan_fact_incl_new_records.project_underwriter_lender_user_dwid = loan_fact
			.project_underwriter_lender_user_dwid
		AND loan_fact_incl_new_records.subordination_specialist_lender_user_dwid = loan_fact
			.subordination_specialist_lender_user_dwid
		AND loan_fact_incl_new_records.supplemental_originator_lender_user_dwid = loan_fact
			.supplemental_originator_lender_user_dwid
		AND loan_fact_incl_new_records.title_specialist_lender_user_dwid = loan_fact.title_specialist_lender_user_dwid
		AND loan_fact_incl_new_records.transaction_assistant_lender_user_dwid = loan_fact
			.transaction_assistant_lender_user_dwid
		AND loan_fact_incl_new_records.underwriter_lender_user_dwid = loan_fact.underwriter_lender_user_dwid
		AND loan_fact_incl_new_records.underwriting_manager_lender_user_dwid = loan_fact
			.underwriting_manager_lender_user_dwid
		AND loan_fact_incl_new_records.va_specialist_lender_user_dwid = loan_fact.va_specialist_lender_user_dwid
		AND loan_fact_incl_new_records.verbal_voe_specialist_lender_user_dwid = loan_fact
			.verbal_voe_specialist_lender_user_dwid
		AND loan_fact_incl_new_records.voe_specialist_lender_user_dwid = loan_fact.voe_specialist_lender_user_dwid
		AND loan_fact_incl_new_records.wholesale_client_advocate_lender_user_dwid = loan_fact
			.wholesale_client_advocate_lender_user_dwid
		AND loan_fact_incl_new_records.wire_specialist_lender_user_dwid = loan_fact.wire_specialist_lender_user_dwid
		AND loan_fact_incl_new_records.initial_beneficiary_investor_dwid = loan_fact.initial_beneficiary_investor_dwid
		AND loan_fact_incl_new_records.first_beneficiary_after_initial_investor_dwid = loan_fact
			.first_beneficiary_after_initial_investor_dwid
		AND loan_fact_incl_new_records.most_recent_purchasing_beneficiary_investor_dwid = loan_fact
			.most_recent_purchasing_beneficiary_investor_dwid
		AND loan_fact_incl_new_records.current_beneficiary_investor_dwid = loan_fact.current_beneficiary_investor_dwid
		AND loan_fact_incl_new_records.current_transaction_stage_from_date_dwid = loan_fact.current_transaction_stage_from_date_dwid
		AND loan_fact_incl_new_records.cd_clear_date_dwid = loan_fact.cd_clear_date_dwid
		AND loan_fact_incl_new_records.charges_enabled_date_dwid = loan_fact.charges_enabled_date_dwid
		AND loan_fact_incl_new_records.effective_earliest_allowed_consummation_date_dwid = loan_fact.effective_earliest_allowed_consummation_date_dwid
		AND loan_fact_incl_new_records.effective_hmda_action_date_dwid = loan_fact.effective_hmda_action_date_dwid
		AND loan_fact_incl_new_records.effective_note_date_dwid = loan_fact.effective_note_date_dwid
		AND loan_fact_incl_new_records.hmda_action_date_dwid = loan_fact.hmda_action_date_dwid
		AND loan_fact_incl_new_records.initial_cancel_status_date_dwid = loan_fact.initial_cancel_status_date_dwid
		AND loan_fact_incl_new_records.initial_uw_disposition_date_dwid = loan_fact.initial_uw_disposition_date_dwid
		AND loan_fact_incl_new_records.initial_uw_submit_date_dwid = loan_fact.initial_uw_submit_date_dwid
		AND loan_fact_incl_new_records.note_date_dwid = loan_fact.note_date_dwid
		AND loan_fact_incl_new_records.preapproval_uw_submit_date_dwid = loan_fact.preapproval_uw_submit_date_dwid
		AND loan_fact_incl_new_records.transaction_create_date_dwid = loan_fact.transaction_create_date_dwid
		AND loan_fact_incl_new_records.transaction_welcome_call_date_dwid = loan_fact.transaction_welcome_call_date_dwid
		AND loan_fact_incl_new_records.trid_application_date_dwid = loan_fact.trid_application_date_dwid
		AND loan_fact_incl_new_records.underwrite_publish_date_dwid = loan_fact.underwrite_publish_date_dwid
		AND loan_fact_incl_new_records.cash_out_reason_dwid = loan_fact.cash_out_reason_dwid
		AND loan_fact_incl_new_records.hmda_action_dwid = loan_fact.hmda_action_dwid
		AND loan_fact_incl_new_records.underwrite_dwid = loan_fact.underwrite_dwid
WHERE loan_fact.loan_dwid IS NULL;', 'Staging DB Connection')
		, ('ETL-200019', 1, 'WITH transaction_dim_incl_new_records AS (
	SELECT ''deal_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
		, COALESCE( CAST( t1441.d_pid AS TEXT ), ''<NULL>'' ) || ''~'' || COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
		, NOW( ) AS edw_created_datetime
		, NOW( ) AS edw_modified_datetime
		, primary_table.data_source_updated_datetime AS data_source_modified_datetime
		, t1441.d_pid AS deal_pid
		, primary_table.prp_pid AS active_proposal_pid
		, current_deal_stage_records.dst_deal_stage_type as current_transaction_stage_code
		, current_deal_stage_type_records.value as current_transaction_stage
		, subject_property.pl_street1 AS subject_property_street1
		, subject_property.pl_street2 AS subject_property_street2
		, subject_property.pl_city subject_property_city
		, subject_property.pl_property_tax_id AS subject_property_tax_id
		, subject_property.pl_postal_code AS subject_property_postal_code
		, county.c_name AS subject_property_county_name
		, subject_property.pl_county_fips AS subject_property_county_fips
		, subject_property.pl_state AS subject_property_state
		, subject_property.pl_state_fips subject_property_state_fips
		, subject_property.pl_country AS subject_property_country_code
		, country_type.value AS subject_property_country
		, subject_property.pl_structure_built_year AS subject_property_year_built
		, subject_property.pl_property_category_type AS subject_property_category_code
		, property_category_type.value AS subject_property_category
		, subject_property.pl_building_status_type AS subject_property_building_status_code
		, building_status_type.value AS subject_property_building_status
		, subject_property.pl_rental AS subject_property_rental_flag
		, subject_property.pl_property_rights_type AS subject_property_rights_code
		, property_rights_type.value AS subject_property_rights
		, subject_property.pl_neighborhood_location_type AS subject_property_neighborhood_location_code
		, neighborhood_location_type.value AS subject_property_neighborhood_location
		, t1441.d_borrower_esign AS borrower_esign_flag
		, primary_table.prp_deed_taxes_applicable AS deed_taxes_applicable_flag
		, primary_table.prp_deed_taxes_auto_compute AS deed_taxes_auto_compute_flag
		, primary_table.prp_delayed_financing_exception_guidelines_applicable AS delayed_financing_exception_guidelines_applicable_flag
		, primary_table.prp_delayed_financing_exception_verified AS delayed_financing_exception_verified_flag
		, primary_table.prp_down_payment_percent_mode AS down_payment_percent_mode_flag
		, t1441.d_early_wire_request AS early_wire_request_flag
		, t1441.d_enable_electronic_transaction AS enable_electronic_transaction_flag
		, primary_table.prp_escrow_cushion_months_auto_compute AS escrow_cushion_months_auto_compute_flag
		, primary_table.prp_first_payment_date_auto_compute AS first_payment_date_auto_compute_flag
		, primary_table.prp_household_income_exclusive_edit AS household_income_exclusive_edit_flag
		, primary_table.prp_intent_to_proceed_provided AS intent_to_proceed_provided_flag
		, t1441.d_invoices_enabled AS invoices_enabled_flag
		, primary_table.prp_ipc_auto_compute AS ipc_auto_compute_flag
		, primary_table.prp_minimum_residual_income_auto_compute AS minimum_residual_income_auto_compute_flag
		, primary_table.prp_other_lender_requires_appraisal AS other_lender_requires_appraisal_flag
		, primary_table.prp_owner_occupancy_not_required AS owner_occupancy_not_required_flag
		, primary_table.prp_property_taxes_request_input_error AS property_taxes_request_input_error_flag
		, primary_table.prp_publish AS publish_flag
		, primary_table.prp_recording_fees_request_input_error AS recording_fees_request_input_error_flag
		, primary_table.prp_request_property_taxes_required AS request_property_taxes_required_flag
		, primary_table.prp_request_recording_fees_required AS request_recording_fees_required_flag
		, primary_table.prp_rescission_applicable AS rescission_applicable_flag
		, primary_table.prp_reserves_auto_compute AS reserves_auto_compute_flag
		, t1441.d_sap_deal AS sap_deal_flag
		, primary_table.prp_sar_significant_adjustments AS sar_significant_adjustments_flag
		, primary_table.prp_smart_charges_enabled AS smart_charges_enabled_flag
		, primary_table.prp_smart_docs_enabled AS smart_docs_enabled_flag
		, t1441.d_training_loan AS training_loan_flag
		, primary_table.prp_publish_date AS active_proposal_publish_date
		, primary_table.prp_calculated_earliest_allowed_consummation_date AS calculated_earliest_allowed_consummation_date
		, primary_table.prp_charges_updated_datetime AS charges_updated_datetime
		, primary_table.prp_closing_document_sign_datetime AS closing_document_sign_datetime
		, primary_table.prp_docs_enabled_datetime AS docs_enabled_datetime
		, t1441.d_ecoa_application_complete_date AS ecoa_application_complete_date
      , t1441.d_ecoa_application_received_date AS ecoa_application_received_date
		, t1441.d_ecoa_decision_due_date AS ecoa_decision_due_date
		, t1441.d_ecoa_notice_of_incomplete_date AS ecoa_notice_of_incomplete_date
		, t1441.d_ecoa_notice_of_incomplete_due_date AS ecoa_notice_of_incomplete_due_date
		, primary_table.prp_effective_earliest_allowed_consummation_date AS effective_earliest_allowed_consummation_date
		, primary_table.prp_first_payment_date AS first_payment_date
		, primary_table.prp_fre_ctp_first_payment_due_date AS fre_ctp_first_payment_due_date
		, primary_table.prp_gfe_interest_rate_expiration_date AS gfe_interest_rate_expiration_date
		, primary_table.prp_initial_uw_disposition_datetime AS initial_uw_disposition_datetime
		, primary_table.prp_initial_uw_submit_datetime AS initial_uw_submit_datetime
		, t1441.d_invoices_enabled_date AS invoices_enabled_date
		, primary_table.prp_land_acquisition_transaction_date AS land_acquisition_transaction_date
		, primary_table.prp_last_corrective_disclosure_processed_datetime AS last_corrective_disclosure_processed_datetime
		, primary_table.prp_last_requested_disclosure_date AS last_requested_disclosure_date
		, primary_table.prp_lender_escrow_loan_due_date AS lender_escrow_loan_due_date
		, primary_table.prp_overridden_earliest_allowed_consummation_date AS overridden_earliest_allowed_consummation_date
		, primary_table.prp_preapproval_uw_disposition_datetime AS preapproval_uw_disposition_datetime
		, primary_table.prp_preapproval_uw_submit_datetime AS preapproval_uw_submit_datetime
		, primary_table.prp_proposal_expiration_date AS proposal_expiration_date
		, primary_table.prp_purchase_contract_date AS purchase_contract_date
		, primary_table.prp_purchase_contract_financing_contingency_date AS purchase_contract_financing_contingency_date
		, primary_table.prp_purchase_contract_funding_date AS purchase_contract_funding_date
		, primary_table.prp_purchase_contract_received_date AS purchase_contract_received_date
		, primary_table.prp_rescission_effective_date AS rescission_effective_date
		, primary_table.prp_rescission_notification_date AS rescission_notification_date
		, primary_table.prp_rescission_through_date AS rescission_through_date
		, primary_table.prp_scheduled_closing_document_sign_datetime AS scheduled_closing_document_sign_datetime
		, primary_table.prp_signed_closing_doc_received_datetime AS signed_closing_doc_received_datetime
		, t1441.d_deal_create_date_time AS transaction_deal_create_datetime
		, t1441.d_deal_orphan_earliest_check_date AS transaction_orphan_earliest_check_date
		, primary_table.prp_create_datetime AS transaction_proposal_create_datetime
		, t1441.d_deal_status_date AS transaction_status_date
		, t1441.d_welcome_call_datetime AS transaction_welcome_call_datetime
		, primary_table.prp_underwrite_expiration_date AS underwrite_expiration_date
		, primary_table.prp_user_entered_note_date AS user_entered_note_date
		, primary_table.prp_anti_steering_lowest_cost_option_fee_amount AS anti_steering_lowest_cost_option_fee_amount
		, primary_table.prp_anti_steering_lowest_cost_option_rate_percent AS anti_steering_lowest_cost_option_rate_percent
		, primary_table.prp_anti_steering_lowest_rate_option_fee_amount AS anti_steering_lowest_rate_option_fee_amount
		, primary_table.prp_anti_steering_lowest_rate_option_rate_percent AS anti_steering_lowest_rate_option_rate_percent
		, primary_table.prp_anti_steering_lowest_rate_wo_neg_option_fee_amount AS anti_steering_lowest_rate_wo_neg_option_fee_amount
		, primary_table.prp_anti_steering_lowest_rate_wo_neg_option_rate_percent AS anti_steering_lowest_rate_wo_neg_option_rate_percent
		, primary_table.prp_area_median_income AS area_median_income
		, primary_table.prp_decision_appraised_value_amount AS decision_appraised_value_amount
		, primary_table.prp_decision_credit_score AS decision_credit_score
		, primary_table.prp_down_payment_percent AS down_payment_percent
		, primary_table.prp_effective_credit_score AS effective_credit_score
		, primary_table.prp_effective_property_value_amount AS effective_property_value_amount
		, primary_table.prp_escrow_cushion_months AS escrow_cushion_months
		, primary_table.prp_estimated_credit_score AS estimated_credit_score
		, primary_table.prp_estimated_property_value_amount AS estimated_property_value_amount
		, primary_table.prp_gfe_lock_before_settlement_days AS gfe_lock_before_settlement_days
		, primary_table.prp_gfe_lock_duration_days AS gfe_lock_duration_days
		, primary_table.prp_household_size_count AS household_size_count
		, primary_table.prp_ipc_amount AS ipc_amount
		, primary_table.prp_ipc_financing_concession_amount AS ipc_financing_concession_amount
		, primary_table.prp_ipc_limit_percent AS ipc_limit_percent
		, primary_table.prp_ipc_maximum_amount_allowed AS ipc_maximum_amount_allowed
		, primary_table.prp_ipc_non_cash_concession_amount AS ipc_non_cash_concession_amount
		, primary_table.prp_ipc_percent AS ipc_percent
		, primary_table.prp_land_acquisition_price AS land_acquisition_price
		, primary_table.prp_lender_escrow_loan_amount AS lender_escrow_loan_amount
		, primary_table.prp_minimum_household_income_amount AS minimum_household_income_amount
		, primary_table.prp_minimum_residual_income_amount AS minimum_residual_income_amount
		, primary_table.prp_proposed_additional_monthly_payment AS proposed_additional_monthly_payment
		, primary_table.prp_reserves_amount AS reserves_amount
		, primary_table.prp_reserves_months AS reserves_months
		, primary_table.prp_sale_price_amount AS sale_price_amount
		, primary_table.prp_term_borrower_intends_to_retain_property AS term_borrower_intends_to_retain_property
		, primary_table.prp_total_income_to_ami_ratio AS total_income_to_ami_ratio
		, primary_table.prp_description AS active_proposal_description
		, primary_table.prp_name AS active_proposal_name
		, t1441.d_calyx_loan_guid AS calyx_loan_guid
		, primary_table.prp_cash_out_reason_other_text AS cash_out_reason_other_text
		, t1441.d_copy_source_los_loan_id_main AS copy_source_los_loan_id_main
		, t1441.d_copy_source_los_loan_id_piggyback AS copy_source_los_loan_id_piggyback
		, primary_table.prp_deed_taxes_applicable_explanation AS deed_taxes_applicable_explanation
		, primary_table.prp_deed_taxes_auto_compute_override_reason AS deed_taxes_auto_compute_override_reason
		, primary_table.prp_earliest_allowed_consummation_date_override_reason AS earliest_allowed_consummation_date_override_reason
		, primary_table.prp_effective_signing_location_city AS effective_signing_location_city
		, t1441.d_external_loan_id_main AS external_loan_id_main
		, t1441.d_external_loan_id_piggyback AS external_loan_id_piggyback
		, t1441.d_hmda_denial_reason_other_description AS hmda_denial_reason_other_description
		, t1441.d_hmda_universal_loan_id_main AS hmda_universal_loan_id_main
		, t1441.d_hmda_universal_loan_id_piggyback AS hmda_universal_loan_id_piggyback
		, primary_table.prp_intent_to_proceed_obtainer_unparsed_name AS intent_to_proceed_obtainer_unparsed_name
		, primary_table.prp_intent_to_proceed_provider_unparsed_name AS intent_to_proceed_provider_unparsed_name
		, t1441.d_lead_reference_id AS lead_reference_id
		, t1441.d_lead_tracking_id AS lead_tracking_id
		, t1441.d_lead_zillow_zq AS lead_zillow_zq
		, t1441.d_los_loan_id_main AS los_loan_number_main
		, t1441.d_los_loan_id_piggyback AS los_loan_number_piggyback
		, t1441.d_mers_min_main AS mers_min_main
		, t1441.d_mers_min_piggyback AS mers_min_piggyback
		, primary_table.prp_other_lender_requires_appraisal_reason AS other_lender_requires_appraisal_reason
		, primary_table.prp_property_tax_request_error_messages AS property_tax_request_error_messages
		, primary_table.prp_rescission_notification_by AS recsission_notication_by
		, t1441.d_referred_by_name AS referred_by_name
		, primary_table.prp_trustee_address_city AS trustee_address_city
		, primary_table.prp_trustee_address_country AS trustee_address_country
		, primary_table.prp_trustee_address_postal_code AS trustee_address_postal_code
		, primary_table.prp_trustee_address_state AS trustee_address_state
		, primary_table.prp_trustee_address_street1 AS trustee_address_street1
		, primary_table.prp_trustee_address_street2 AS trustee_address_street2
		, primary_table.prp_trustee_mers_org_id AS trustee_mers_org_id
		, primary_table.prp_trustee_name AS trustee_name
		, primary_table.prp_trustee_phone_number AS trustee_phone_number
		, primary_table.prp_underwrite_disposition_note AS underwrite_disposition_note
		, primary_table.prp_underwriting_comments AS underwriting_comments
		, primary_table.prp_uuts_master_contact_name AS uuts_master_contact_name
		, primary_table.prp_uuts_master_contact_title AS uuts_master_contact_title
		, primary_table.prp_uuts_master_office_phone AS uuts_master_office_phone
		, primary_table.prp_uuts_master_office_phone_extension AS uuts_master_office_phone_extension
		, t1441.d_velocify_lead_id AS velocify_lead_id
		, proposal_type.value AS active_proposal_type
		, primary_table.prp_proposal_type AS active_proposal_type_code
		, application_type.value AS application_type
		, t1441.d_application_type AS application_type_code
		, credit_bureau_type.value AS credit_bureau
		, t1441.d_credit_bureau_type AS credit_bureau_code
		, disclosure_action_type.value AS disclosure_action
		, primary_table.prp_disclosure_action_type AS disclosure_action_code
		, doc_level_type.value AS doc_level
		, primary_table.prp_doc_level_type AS doc_level_code
		, effective_property_value_explanation_type.value AS effective_property_value_explanation
		, primary_table.prp_effective_property_value_explanation_type AS effective_property_value_explanation_code
		, effective_property_value_type.value AS effective_property_value_type
		, primary_table.prp_effective_property_value_type AS effective_property_value_type_code
		, state_type.value AS effective_signing_location_state
		, primary_table.prp_effective_signing_location_state AS effective_signing_location_state_code
		, fre_ctp_closing_feature_type.value AS fre_ctp_closing_feature
		, primary_table.prp_fre_ctp_closing_feature_type AS fre_ctp_closing_feature_code
		, gse_version_type.value AS gse_version
		, primary_table.prp_gse_version_type AS gse_version_code
		, intent_to_proceed_type.value AS intent_to_proceed
		, primary_table.prp_intent_to_proceed_type AS intent_to_proceed_code
		, deal_orphan_status_type.value AS orphan_status
		, t1441.d_deal_orphan_status_type AS orphan_status_code
		, realty_agent_scenario_type.value AS realty_agent_scenario
		, t1441.d_realty_agent_scenario_type AS realty_agent_scenario_code
		, rescission_notification_type.value AS rescission_notification
		, primary_table.prp_rescission_notification_type AS rescission_notification_code
		, security_instrument_type.value AS security_instrument
		, primary_table.prp_security_instrument_type AS security_instrument_code
		, deal_create_type.value AS transaction_create_type
		, t1441.d_deal_create_type AS transaction_create_type_code
		, deal_status_type.value AS transaction_status
		, t1441.d_deal_status_type AS transaction_status_code
		, any_vesting_changes_ynu_type.value AS any_vesting_changes
		, primary_table.prp_any_vesting_changes AS any_vesting_changes_code
		, arms_length_ynu_type.value AS arms_length
		, primary_table.prp_arms_length AS arms_length_code
		, early_first_payment_ynu_type.value AS early_first_payment
		, primary_table.prp_early_first_payment AS early_first_payment_code
		, earthquake_insurance_applicable_ynu_type.value AS earthquake_insurance_applicable
		, primary_table.prp_earthquake_insurance_applicable AS earthquake_insurance_applicable_code
		, flood_insurance_applicable_ynu_type.value AS flood_insurance_applicable
		, primary_table.prp_flood_insurance_applicable AS flood_insurance_applicable_code
		, hazard_insurance_applicable_ynu_type.value AS hazard_insurance_applicable
		, primary_table.prp_hazard_insurance_applicable AS hazard_insurance_applicable_code
		, hud_consultant_ynu_type.value AS hud_consultant
		, primary_table.prp_hud_consultant AS hud_consultant_code
		, mortgagee_builder_seller_relationship_ynu_type.value AS mortgagee_builder_seller_relationship
		, primary_table.prp_mortgagee_builder_seller_relationship AS mortgagee_builder_seller_relationship_code
		, property_acquired_through_ancillary_relief_ynu_type.value AS property_acquired_through_ancillary_relief
		, primary_table.prp_property_acquired_through_ancillary_relief AS property_acquired_through_ancillary_relief_code
		, property_acquired_through_inheritance_ynu_type.value AS property_acquired_through_inheritance
		, primary_table.prp_property_acquired_through_inheritance AS property_acquired_through_inheritance_code
		, separate_transaction_for_land_acquisition_ynu_type.value AS separate_transaction_for_land_acquisition
		, primary_table.prp_separate_transaction_for_land_acquisition AS separate_transaction_for_land_acquisition_code
		, taxes_escrowed_ynu_type.value AS taxes_escrowed
		, primary_table.prp_taxes_escrowed AS taxes_escrowed_code
		, vesting_change_titleholder_added_ynu_type.value AS vesting_change_titleholder_added
		, primary_table.prp_vesting_change_titleholder_added AS vesting_change_titleholder_added_code
		, vesting_change_titleholder_name_change_ynu_type.value AS vesting_change_titleholder_name_change
		, primary_table.prp_vesting_change_titleholder_name_change AS vesting_change_titleholder_name_change_code
		, vesting_change_titleholder_removed_ynu_type.value AS vesting_change_titleholder_removed
		, primary_table.prp_vesting_change_titleholder_removed AS vesting_change_titleholder_removed_code
		, windstorm_insurance_applicable_ynu_type.value AS windstorm_insurance_applicable
		, primary_table.prp_windstorm_insurance_applicable AS windstorm_insurance_applicable_code
		, GREATEST( primary_table.etl_end_date_time, t1441.etl_end_date_time, current_deal_stage_records.etl_end_date_time,
					current_deal_stage_type_records.etl_end_date_time, subject_property.etl_end_date_time, county.etl_end_date_time,
					country_type.etl_end_date_time, property_category_type.etl_end_date_time, building_status_type.etl_end_date_time,
					property_rights_type.etl_end_date_time, neighborhood_location_type.etl_end_date_time, proposal_type.etl_end_date_time,
					application_type.etl_end_date_time, credit_bureau_type.etl_end_date_time, disclosure_action_type.etl_end_date_time,
					doc_level_type.etl_end_date_time, effective_property_value_explanation_type.etl_end_date_time,
					effective_property_value_type.etl_end_date_time, state_type.etl_end_date_time,
					fre_ctp_closing_feature_type.etl_end_date_time, gse_version_type.etl_end_date_time,
					intent_to_proceed_type.etl_end_date_time, deal_orphan_status_type.etl_end_date_time,
					realty_agent_scenario_type.etl_end_date_time, rescission_notification_type.etl_end_date_time,
					security_instrument_type.etl_end_date_time, deal_create_type.etl_end_date_time, deal_status_type.etl_end_date_time,
					any_vesting_changes_ynu_type.etl_end_date_time,
					arms_length_ynu_type.etl_end_date_time,
					early_first_payment_ynu_type.etl_end_date_time,
					earthquake_insurance_applicable_ynu_type.etl_end_date_time,
					flood_insurance_applicable_ynu_type.etl_end_date_time,
					hazard_insurance_applicable_ynu_type.etl_end_date_time,
					hud_consultant_ynu_type.etl_end_date_time,
					mortgagee_builder_seller_relationship_ynu_type.etl_end_date_time,
					property_acquired_through_ancillary_relief_ynu_type.etl_end_date_time,
					property_acquired_through_inheritance_ynu_type.etl_end_date_time,
					separate_transaction_for_land_acquisition_ynu_type.etl_end_date_time,
					taxes_escrowed_ynu_type.etl_end_date_time,
					vesting_change_titleholder_added_ynu_type.etl_end_date_time,
					vesting_change_titleholder_name_change_ynu_type.etl_end_date_time,
					vesting_change_titleholder_removed_ynu_type.etl_end_date_time,
					windstorm_insurance_applicable_ynu_type.etl_end_date_time) AS max_source_etl_end_date_time
	FROM (
		SELECT <<proposal_partial_load_condition>> AS include_record
			, proposal.*
			, etl_log.etl_end_date_time
		FROM history_octane.proposal
			LEFT JOIN history_octane.proposal AS history_records
				ON proposal.prp_pid = history_records.prp_pid
					AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
			JOIN star_common.etl_log
				ON proposal.etl_batch_id = etl_log.etl_batch_id
		WHERE history_records.prp_pid IS NULL
	) AS primary_table
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<deal_partial_load_condition>> AS include_record
					, deal.*
					, etl_log.etl_end_date_time
				FROM history_octane.deal
					LEFT JOIN history_octane.deal AS history_records
						ON deal.d_pid = history_records.d_pid
							AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON deal.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.d_pid IS NULL
			) AS primary_table
		) AS t1441
			ON primary_table.prp_pid = t1441.d_active_proposal_pid
		INNER JOIN (
			SELECT <<deal_stage_partial_load_condition>> AS include_record
				, deal_stage.*
				, etl_log.etl_end_date_time as etl_end_date_time
			FROM history_octane.deal_stage
				LEFT JOIN history_octane.deal_stage AS history_records
					ON deal_stage.dst_pid = history_records.dst_pid
						AND deal_stage.data_source_updated_datetime < history_records.data_source_updated_datetime
				JOIN star_common.etl_log
					ON deal_stage.etl_batch_id = etl_log.etl_batch_id
			WHERE history_records.dst_pid IS NULL
				AND deal_stage.dst_through_date IS NULL
		) as current_deal_stage_records ON t1441.d_pid = current_deal_stage_records.dst_deal_pid
		INNER JOIN (
			SELECT <<deal_stage_type_partial_load_condition>> AS include_record
				, deal_stage_type.code
				, deal_stage_type.value
				, etl_log.etl_end_date_time as etl_end_date_time
			FROM history_octane.deal_stage_type
				LEFT JOIN history_octane.deal_stage_type AS history_records
					ON deal_stage_type.code = history_records.code
						AND deal_stage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
				JOIN star_common.etl_log ON deal_stage_type.etl_batch_id = etl_log.etl_batch_id
			WHERE history_records.code IS NULL
		) AS current_deal_stage_type_records ON current_deal_stage_records.dst_deal_stage_type = current_deal_stage_type_records.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<place_partial_load_condition>> AS include_record
					, place.*
					, etl_log.etl_end_date_time
				FROM history_octane.place
					LEFT JOIN history_octane.place AS history_records
						ON place.pl_pid = history_records.pl_pid
							AND place.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON place.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.pl_pid IS NULL
			) AS primary_table
		) AS subject_property ON primary_table.prp_pid = subject_property.pl_proposal_pid
			AND subject_property.pl_subject_property IS TRUE
		LEFT JOIN (
			SELECT *
			FROM (
				SELECT <<county_partial_load_condition>> AS include_record
					, county.*
					, etl_log.etl_end_date_time
				FROM history_octane.county
					LEFT JOIN history_octane.county AS history_records
						ON county.c_pid = history_records.c_pid
							AND county.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON county.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.c_pid IS NULL
			) AS primary_table
		) AS county ON subject_property.pl_county_pid = county.c_pid
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<country_type_partial_load_condition>> AS include_record
					, country_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.country_type
					LEFT JOIN history_octane.country_type AS history_records
						ON country_type.code = history_records.code
							AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON country_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS country_type ON subject_property.pl_country = country_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<property_category_type_partial_load_condition>> AS include_record
					, property_category_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.property_category_type
					LEFT JOIN history_octane.property_category_type AS history_records
						ON property_category_type.code = history_records.code
							AND property_category_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON property_category_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS property_category_type ON subject_property.pl_property_category_type = property_category_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<building_status_type_partial_load_condition>> AS include_record
					, building_status_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.building_status_type
					LEFT JOIN history_octane.building_status_type AS history_records
						ON building_status_type.code = history_records.code
							AND building_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON building_status_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS building_status_type ON subject_property.pl_building_status_type = building_status_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<property_rights_type_partial_load_condition>> AS include_record
					, property_rights_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.property_rights_type
					LEFT JOIN history_octane.property_rights_type AS history_records
						ON property_rights_type.code = history_records.code
							AND property_rights_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON property_rights_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS property_rights_type ON subject_property.pl_property_rights_type = property_rights_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<neighborhood_location_type_partial_load_condition>> AS include_record
					, neighborhood_location_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.neighborhood_location_type
					LEFT JOIN history_octane.neighborhood_location_type AS history_records
						ON neighborhood_location_type.code = history_records.code
							AND neighborhood_location_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log ON neighborhood_location_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS neighborhood_location_type ON subject_property.pl_neighborhood_location_type = neighborhood_location_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<proposal_type_partial_load_condition>> AS include_record
		        	, proposal_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.proposal_type
		        	LEFT JOIN history_octane.proposal_type AS history_records
		        		ON proposal_type.code = history_records.code
		        			AND proposal_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON proposal_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS proposal_type
			ON primary_table.prp_proposal_type = proposal_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<application_type_partial_load_condition>> AS include_record
		        	, application_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.application_type
		        	LEFT JOIN history_octane.application_type AS history_records
		        		ON application_type.code = history_records.code
		        			AND application_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON application_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS application_type
			ON t1441.d_application_type = application_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<credit_bureau_type_partial_load_condition>> AS include_record
		        	, credit_bureau_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.credit_bureau_type
		        	LEFT JOIN history_octane.credit_bureau_type AS history_records
		        		ON credit_bureau_type.code = history_records.code
		        			AND credit_bureau_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON credit_bureau_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS credit_bureau_type
				ON t1441.d_credit_bureau_type = credit_bureau_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<disclosure_action_type_partial_load_condition>> AS include_record
		        	, disclosure_action_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.disclosure_action_type
		        	LEFT JOIN history_octane.disclosure_action_type AS history_records
		        		ON disclosure_action_type.code = history_records.code
		        			AND disclosure_action_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON disclosure_action_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS disclosure_action_type
				ON primary_table.prp_disclosure_action_type = disclosure_action_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<doc_level_type_partial_load_condition>> AS include_record
		        	, doc_level_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.doc_level_type
		        	LEFT JOIN history_octane.doc_level_type AS history_records
		        		ON doc_level_type.code = history_records.code
		        			AND doc_level_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON doc_level_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS doc_level_type
				ON primary_table.prp_doc_level_type = doc_level_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<effective_property_value_explanation_type_partial_load_condition>> AS include_record
		        	, effective_property_value_explanation_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.effective_property_value_explanation_type
		        	LEFT JOIN history_octane.effective_property_value_explanation_type AS history_records
		        		ON effective_property_value_explanation_type.code = history_records.code
		        			AND effective_property_value_explanation_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON effective_property_value_explanation_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS effective_property_value_explanation_type
				ON primary_table.prp_effective_property_value_explanation_type = effective_property_value_explanation_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<effective_property_value_type_partial_load_condition>> AS include_record
		        	, effective_property_value_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.effective_property_value_type
		        	LEFT JOIN history_octane.effective_property_value_type AS history_records
		        		ON effective_property_value_type.code = history_records.code
		        			AND effective_property_value_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON effective_property_value_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
				) AS primary_table
			) AS effective_property_value_type
				ON primary_table.prp_effective_property_value_type = effective_property_value_type.code
		LEFT JOIN (
		    SELECT *
		    FROM (
		        SELECT <<state_type_partial_load_condition>> AS include_record
		        	, state_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.state_type
		        	LEFT JOIN history_octane.state_type AS history_records
		        		ON state_type.code = history_records.code
		        			AND state_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON state_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS state_type
			ON primary_table.prp_effective_signing_location_state = state_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<fre_ctp_closing_feature_type_partial_load_condition>> AS include_record
		        	, fre_ctp_closing_feature_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.fre_ctp_closing_feature_type
		        	LEFT JOIN history_octane.fre_ctp_closing_feature_type AS history_records
		        		ON fre_ctp_closing_feature_type.code = history_records.code
		        			AND fre_ctp_closing_feature_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON fre_ctp_closing_feature_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS fre_ctp_closing_feature_type
			ON primary_table.prp_fre_ctp_closing_feature_type = fre_ctp_closing_feature_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<gse_version_type_partial_load_condition>> AS include_record
		        	, gse_version_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.gse_version_type
		        	LEFT JOIN history_octane.gse_version_type AS history_records
		        		ON gse_version_type.code = history_records.code
		        			AND gse_version_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON gse_version_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS gse_version_type
			ON primary_table.prp_gse_version_type = gse_version_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<intent_to_proceed_type_partial_load_condition>> AS include_record
		        	, intent_to_proceed_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.intent_to_proceed_type
		        	LEFT JOIN history_octane.intent_to_proceed_type AS history_records
		        		ON intent_to_proceed_type.code = history_records.code
		        			AND intent_to_proceed_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON intent_to_proceed_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS intent_to_proceed_type
			ON primary_table.prp_intent_to_proceed_type = intent_to_proceed_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<deal_orphan_status_type_partial_load_condition>> AS include_record
					, deal_orphan_status_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.deal_orphan_status_type
		        	LEFT JOIN history_octane.deal_orphan_status_type AS history_records
		        		ON deal_orphan_status_type.code = history_records.code
		        			AND deal_orphan_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON deal_orphan_status_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS deal_orphan_status_type
			ON t1441.d_deal_orphan_status_type = deal_orphan_status_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<realty_agent_scenario_type_partial_load_condition>> AS include_record
		        	, realty_agent_scenario_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.realty_agent_scenario_type
		        	LEFT JOIN history_octane.realty_agent_scenario_type AS history_records
		        		ON realty_agent_scenario_type.code = history_records.code
		        			AND realty_agent_scenario_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON realty_agent_scenario_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS realty_agent_scenario_type
			ON t1441.d_realty_agent_scenario_type = realty_agent_scenario_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<rescission_notification_type_partial_load_condition>> AS include_record
		        	, rescission_notification_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.rescission_notification_type
		        	LEFT JOIN history_octane.rescission_notification_type AS history_records
		        		ON rescission_notification_type.code = history_records.code
		        			AND rescission_notification_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON rescission_notification_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS rescission_notification_type
			ON primary_table.prp_rescission_notification_type = rescission_notification_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<security_instrument_type_partial_load_condition>> AS include_record
		        	, security_instrument_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.security_instrument_type
		        	LEFT JOIN history_octane.security_instrument_type AS history_records
		        		ON security_instrument_type.code = history_records.code
		        			AND security_instrument_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON security_instrument_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS security_instrument_type
			ON primary_table.prp_security_instrument_type = security_instrument_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<deal_create_type_partial_load_condition>> AS include_record
		        	, deal_create_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.deal_create_type
		        	LEFT JOIN history_octane.deal_create_type AS history_records
		        		ON deal_create_type.code = history_records.code
		        			AND deal_create_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON deal_create_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS deal_create_type
			ON t1441.d_deal_create_type = deal_create_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<deal_status_type_partial_load_condition>> AS include_record
		        	, deal_status_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.deal_status_type
		        	LEFT JOIN history_octane.deal_status_type AS history_records
		        		ON deal_status_type.code = history_records.code
		        			AND deal_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON deal_status_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS deal_status_type
			ON t1441.d_deal_status_type = deal_status_type.code
		INNER JOIN (
		    SELECT *
		    FROM (
		        SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
		        	, yes_no_unknown_type.*
		        	, etl_log.etl_end_date_time
		        FROM history_octane.yes_no_unknown_type
		        	LEFT JOIN history_octane.yes_no_unknown_type AS history_records
		        		ON yes_no_unknown_type.code = history_records.code
		        			AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
		        	JOIN star_common.etl_log
		        		ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
		        WHERE history_records.code IS NULL
			) AS primary_table
		) AS any_vesting_changes_ynu_type
			ON primary_table.prp_any_vesting_changes = any_vesting_changes_ynu_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS arms_length_ynu_type
			ON primary_table.prp_arms_length = arms_length_ynu_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS early_first_payment_ynu_type
			ON primary_table.prp_early_first_payment = early_first_payment_ynu_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS earthquake_insurance_applicable_ynu_type
			ON primary_table.prp_earthquake_insurance_applicable = earthquake_insurance_applicable_ynu_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS flood_insurance_applicable_ynu_type
			ON primary_table.prp_flood_insurance_applicable = flood_insurance_applicable_ynu_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS hazard_insurance_applicable_ynu_type
			ON primary_table.prp_hazard_insurance_applicable = hazard_insurance_applicable_ynu_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS hud_consultant_ynu_type
			ON primary_table.prp_hud_consultant = hud_consultant_ynu_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS mortgagee_builder_seller_relationship_ynu_type
			ON primary_table.prp_mortgagee_builder_seller_relationship = mortgagee_builder_seller_relationship_ynu_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS property_acquired_through_ancillary_relief_ynu_type
			ON primary_table.prp_property_acquired_through_ancillary_relief = property_acquired_through_ancillary_relief_ynu_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS property_acquired_through_inheritance_ynu_type
			ON primary_table.prp_property_acquired_through_inheritance = property_acquired_through_inheritance_ynu_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS separate_transaction_for_land_acquisition_ynu_type
			ON primary_table.prp_separate_transaction_for_land_acquisition = separate_transaction_for_land_acquisition_ynu_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS taxes_escrowed_ynu_type
			ON primary_table.prp_taxes_escrowed = taxes_escrowed_ynu_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS vesting_change_titleholder_added_ynu_type
			ON primary_table.prp_vesting_change_titleholder_added = vesting_change_titleholder_added_ynu_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS vesting_change_titleholder_name_change_ynu_type
			ON primary_table.prp_vesting_change_titleholder_name_change = vesting_change_titleholder_name_change_ynu_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS vesting_change_titleholder_removed_ynu_type
			ON primary_table.prp_vesting_change_titleholder_removed = vesting_change_titleholder_removed_ynu_type.code
		INNER JOIN (
			SELECT *
			FROM (
				SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
					, yes_no_unknown_type.*
					, etl_log.etl_end_date_time
				FROM history_octane.yes_no_unknown_type
					LEFT JOIN history_octane.yes_no_unknown_type AS history_records
						ON yes_no_unknown_type.code = history_records.code
							AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
					JOIN star_common.etl_log
						ON yes_no_unknown_type.etl_batch_id = etl_log.etl_batch_id
				WHERE history_records.code IS NULL
			) AS primary_table
		) AS windstorm_insurance_applicable_ynu_type
			ON primary_table.prp_windstorm_insurance_applicable = windstorm_insurance_applicable_ynu_type.code
	WHERE GREATEST( primary_table.include_record, t1441.include_record, current_deal_stage_records.include_record,
					current_deal_stage_type_records.include_record, subject_property.include_record, county.include_record,
					country_type.include_record, property_category_type.include_record, building_status_type.include_record,
					property_rights_type.include_record, neighborhood_location_type.include_record, proposal_type.include_record,
	    			application_type.include_record, credit_bureau_type.include_record, disclosure_action_type.include_record,
	    			doc_level_type.include_record, effective_property_value_explanation_type.include_record,
	    			effective_property_value_type.include_record, state_type.include_record,
	    			fre_ctp_closing_feature_type.include_record, gse_version_type.include_record,
	    			intent_to_proceed_type.include_record, deal_orphan_status_type.include_record,
	    			realty_agent_scenario_type.include_record, rescission_notification_type.include_record,
	    			security_instrument_type.include_record, deal_create_type.include_record, deal_status_type.include_record,
					any_vesting_changes_ynu_type.include_record,
					arms_length_ynu_type.include_record,
					early_first_payment_ynu_type.include_record,
					earthquake_insurance_applicable_ynu_type.include_record,
					flood_insurance_applicable_ynu_type.include_record,
					hazard_insurance_applicable_ynu_type.include_record,
					hud_consultant_ynu_type.include_record,
					mortgagee_builder_seller_relationship_ynu_type.include_record,
					property_acquired_through_ancillary_relief_ynu_type.include_record,
					property_acquired_through_inheritance_ynu_type.include_record,
					separate_transaction_for_land_acquisition_ynu_type.include_record,
					taxes_escrowed_ynu_type.include_record,
					vesting_change_titleholder_added_ynu_type.include_record,
					vesting_change_titleholder_name_change_ynu_type.include_record,
					vesting_change_titleholder_removed_ynu_type.include_record,
					windstorm_insurance_applicable_ynu_type.include_record) IS TRUE
)
--new records that should be inserted
SELECT transaction_dim_incl_new_records.*
FROM transaction_dim_incl_new_records
	LEFT JOIN star_loan.transaction_dim
		ON transaction_dim_incl_new_records.data_source_integration_id = transaction_dim.data_source_integration_id
WHERE transaction_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT transaction_dim_incl_new_records.*
FROM transaction_dim_incl_new_records
	JOIN (
		SELECT transaction_dim.data_source_integration_id, etl_log.etl_start_date_time
		FROM star_loan.transaction_dim
			JOIN star_common.etl_log
				ON transaction_dim.etl_batch_id = etl_log.etl_batch_id
	) AS transaction_dim_etl_start_times
		ON transaction_dim_incl_new_records.data_source_integration_id = transaction_dim_etl_start_times.data_source_integration_id
			AND transaction_dim_incl_new_records.max_source_etl_end_date_time >= transaction_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
)
UPDATE mdi.table_input_step
SET data_source_dwid = update_rows.data_source_dwid
	, sql = update_rows.sql
	, connectionname = update_rows.connectionname::mdi.pentaho_db_connection_name
FROM update_rows
	JOIN mdi.process
		ON process.name = update_rows.process_name
WHERE process.dwid = table_input_step.process_dwid;
