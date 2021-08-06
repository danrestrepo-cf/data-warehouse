--
-- Main | EDW - Octane schemas from prod-release to uat (2021-08-06)
-- https://app.asana.com/0/0/1200723475408385
--

-- Insert metadata for new tables: du_finding_message_type, du_finding
WITH new_staging_table_definitions AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'du_finding_message_type', NULL)
            , ('staging', 'staging_octane', 'du_finding', NULL)
        RETURNING dwid, table_name
)

, new_history_table_definitions AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        SELECT 'staging', 'history_octane', new_staging_table_definitions.table_name,
               new_staging_table_definitions.dwid
        FROM new_staging_table_definitions
        RETURNING dwid, table_name
)

, new_fields (schema_name, table_name, field_name, key_field_flag, field_order) AS (
    VALUES ('staging_octane', 'du_finding_message_type', 'code', TRUE, NULL)
        , ('staging_octane', 'du_finding_message_type', 'value', FALSE, NULL)
        , ('staging_octane', 'du_finding', 'duf_pid', TRUE, NULL)
        , ('staging_octane', 'du_finding', 'duf_version', FALSE, NULL)
        , ('staging_octane', 'du_finding', 'duf_du_request_pid', FALSE, NULL)
        , ('staging_octane', 'du_finding', 'duf_du_finding_message_type', FALSE, NULL)
        , ('staging_octane', 'du_finding', 'duf_finding_result', FALSE, NULL)
        , ('staging_octane', 'du_finding', 'duf_finding_value', FALSE, NULL)
        , ('history_octane', 'du_finding_message_type', 'code', TRUE, 0)
        , ('history_octane', 'du_finding_message_type', 'value', FALSE, 1)
        , ('history_octane', 'du_finding_message_type', 'data_source_updated_datetime', FALSE, 2)
        , ('history_octane', 'du_finding_message_type', 'data_source_deleted_flag', FALSE, 3)
        , ('history_octane', 'du_finding', 'duf_pid', TRUE, 0)
        , ('history_octane', 'du_finding', 'duf_version', FALSE, 1)
        , ('history_octane', 'du_finding', 'duf_du_request_pid', FALSE, 2)
        , ('history_octane', 'du_finding', 'duf_du_finding_message_type', FALSE, 3)
        , ('history_octane', 'du_finding', 'duf_finding_result', FALSE, 4)
        , ('history_octane', 'du_finding', 'duf_finding_value', FALSE, 5)
        , ('history_octane', 'du_finding', 'data_source_updated_datetime', FALSE, 6)
        , ('history_octane', 'du_finding', 'data_source_deleted_flag', FALSE, 7)
)

, new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT new_staging_table_definitions.dwid, new_fields.field_name, new_fields.key_field_flag
        FROM new_fields
            JOIN new_staging_table_definitions ON new_fields.table_name = new_staging_table_definitions.table_name
        WHERE new_fields.schema_name = 'staging_octane'
        RETURNING dwid, edw_table_definition_dwid, field_name
)

, new_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag,
                                          source_edw_field_definition_dwid)
        SELECT new_history_table_definitions.dwid, new_fields.field_name, new_fields.key_field_flag,
               new_staging_field_definitions.dwid
        FROM new_fields
            JOIN new_staging_table_definitions ON new_fields.table_name = new_staging_table_definitions.table_name
            JOIN new_history_table_definitions ON new_fields.table_name = new_history_table_definitions.table_name
            LEFT JOIN new_staging_field_definitions ON new_staging_table_definitions.dwid =
                                                       new_staging_field_definitions.edw_table_definition_dwid
                AND new_fields.field_name = new_staging_field_definitions.field_name
        WHERE new_fields.schema_name = 'history_octane'
)

, new_process_variables (name, target_table, json_output_field, sql) AS (
    VALUES ('SP-100839', 'du_finding_message_type', 'code', 'SELECT staging_table.code
, staging_table.value
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.du_finding_message_type staging_table
LEFT JOIN history_octane.du_finding_message_type history_table on staging_table.code = history_table.code AND staging_table.value = history_table.value
WHERE history_table.code is NULL')
        , ('SP-100840', 'du_finding', 'duf_pid', '--finding records to insert into history_octane.du_finding
SELECT staging_table.duf_pid
, staging_table.duf_version
, staging_table.duf_du_request_pid
, staging_table.duf_du_finding_message_type
, staging_table.duf_finding_result
, staging_table.duf_finding_value
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.du_finding staging_table
LEFT JOIN history_octane.du_finding history_table on staging_table.duf_pid = history_table.duf_pid and staging_table.duf_version = history_table.duf_version
WHERE history_table.duf_pid is NULL
UNION ALL
SELECT history_table.duf_pid
, history_table.duf_version+1
, history_table.duf_du_request_pid
, history_table.duf_du_finding_message_type
, history_table.duf_finding_result
, history_table.duf_finding_value
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM history_octane.du_finding history_table
LEFT JOIN staging_octane.du_finding staging_table on staging_table.duf_pid = history_table.duf_pid
WHERE staging_table.duf_pid is NULL
    AND not exists (select 1 from history_octane.du_finding deleted_records where deleted_records.duf_pid = history_table.duf_pid and deleted_records.data_source_deleted_flag = True)')
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
            JOIN new_process_variables ON new_processes.name = new_process_variables.name
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
            JOIN new_process_variables ON new_processes.name = new_process_variables.name
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
            JOIN new_fields ON new_fields.schema_name = new_table_output_steps.target_schema
                AND new_fields.table_name = new_table_output_steps.target_table
)

, new_json_output_fields AS (
    INSERT INTO mdi.json_output_field (process_dwid, field_name)
        SELECT new_processes.dwid, new_process_variables.json_output_field
        FROM new_processes
            JOIN new_process_variables ON new_processes.name = new_process_variables.name
)

, new_state_machine_definitions AS (
    INSERT INTO mdi.state_machine_definition (process_dwid, name, comment)
        SELECT new_processes.dwid, new_processes.name, new_processes.description
        FROM new_processes
)

SELECT 'Finished inserting metadata for new tables du_finding_message_type, du_finding';

-- Insert metadata for new columns on existing tables:
    -- proposal.prp_initial_uw_disposition_datetime
    -- proposal.prp_preapproval_uw_submit_datetime
    -- proposal.prp_preapproval_uw_disposition_datetime

WITH new_fields (table_name, field_name, field_order) AS (
    VALUES ('proposal', 'prp_initial_uw_disposition_datetime', 235)
         , ('proposal', 'prp_preapproval_uw_submit_datetime', 236)
         , ('proposal', 'prp_preapproval_uw_disposition_datetime', 237)
)

, new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT edw_table_definition.dwid, new_fields.field_name, FALSE
        FROM new_fields
            JOIN mdi.edw_table_definition ON new_fields.table_name = edw_table_definition.table_name
                AND edw_table_definition.schema_name = 'staging_octane'
        RETURNING dwid, edw_table_definition_dwid, field_name
)

, new_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag,
                                          source_edw_field_definition_dwid)
        SELECT edw_table_definition.dwid, new_fields.field_name, FALSE, new_staging_field_definitions.dwid
        FROM new_fields
            JOIN mdi.edw_table_definition ON new_fields.table_name = edw_table_definition.table_name
                AND edw_table_definition.schema_name = 'history_octane'
            JOIN mdi.edw_table_definition source_table_definition ON new_fields.table_name = source_table_definition.table_name
                AND source_table_definition.schema_name = 'staging_octane'
            JOIN new_staging_field_definitions ON new_fields.field_name = new_staging_field_definitions.field_name
                AND source_table_definition.dwid = new_staging_field_definitions.edw_table_definition_dwid
)

, new_table_output_fields AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name,
                                        field_order, is_sensitive)
        SELECT table_output_step.dwid, new_fields.field_name, new_fields.field_name, new_fields.field_order, FALSE
        FROM new_fields
            JOIN mdi.table_output_step ON new_fields.table_name = table_output_step.target_table
                AND table_output_step.target_schema = 'history_octane'
)

, updated_table_input_sql (table_name, sql) AS (
    VALUES ('proposal', '
--finding records to insert into history_octane.proposal
SELECT staging_table.prp_estimated_hard_construction_cost_amount
, staging_table.prp_financed_property_improvements
, staging_table.prp_pid
, staging_table.prp_version
, staging_table.prp_decision_lp_request_pid
, staging_table.prp_decision_du_request_pid
, staging_table.prp_proposal_type
, staging_table.prp_description
, staging_table.prp_doc_level_type
, staging_table.prp_loan_purpose_type
, staging_table.prp_name
, staging_table.prp_create_datetime
, staging_table.prp_effective_funding_date
, staging_table.prp_estimated_funding_date
, staging_table.prp_calculated_earliest_allowed_consummation_date
, staging_table.prp_overridden_earliest_allowed_consummation_date
, staging_table.prp_effective_earliest_allowed_consummation_date
, staging_table.prp_earliest_allowed_consummation_date_override_reason
, staging_table.prp_last_requested_disclosure_date
, staging_table.prp_closing_document_sign_datetime
, staging_table.prp_scheduled_closing_document_sign_datetime
, staging_table.prp_rescission_through_date
, staging_table.prp_rescission_notification_date
, staging_table.prp_rescission_notification_by
, staging_table.prp_rescission_notification_type
, staging_table.prp_rescission_effective_date
, staging_table.prp_first_payment_date
, staging_table.prp_first_payment_date_auto_compute
, staging_table.prp_property_usage_type
, staging_table.prp_estimated_property_value_amount
, staging_table.prp_smart_charges_enabled
, staging_table.prp_charges_updated_datetime
, staging_table.prp_smart_docs_enabled
, staging_table.prp_docs_enabled_datetime
, staging_table.prp_request_fha_mip_refund_required
, staging_table.prp_request_recording_fees_required
, staging_table.prp_request_property_taxes_required
, staging_table.prp_property_tax_request_error_messages
, staging_table.prp_fha_mip_refund_request_input_error
, staging_table.prp_recording_fees_request_input_error
, staging_table.prp_property_taxes_request_input_error
, staging_table.prp_publish
, staging_table.prp_publish_date
, staging_table.prp_ipc_auto_compute
, staging_table.prp_ipc_limit_percent
, staging_table.prp_ipc_maximum_amount_allowed
, staging_table.prp_ipc_amount
, staging_table.prp_ipc_percent
, staging_table.prp_ipc_financing_concession_amount
, staging_table.prp_ipc_non_cash_concession_amount
, staging_table.prp_sale_price_amount
, staging_table.prp_structure_type
, staging_table.prp_deal_pid
, staging_table.prp_gfe_interest_rate_expiration_date
, staging_table.prp_gfe_lock_duration_days
, staging_table.prp_gfe_lock_before_settlement_days
, staging_table.prp_proposal_expiration_date
, staging_table.prp_uuts_master_contact_name
, staging_table.prp_uuts_master_contact_title
, staging_table.prp_uuts_master_office_phone
, staging_table.prp_uuts_master_office_phone_extension
, staging_table.prp_underwrite_risk_assessment_type
, staging_table.prp_underwriting_comments
, staging_table.prp_reserves_auto_compute
, staging_table.prp_reserves_amount
, staging_table.prp_reserves_months
, staging_table.prp_underwrite_disposition_type
, staging_table.prp_underwrite_publish_date
, staging_table.prp_underwrite_expiration_date
, staging_table.prp_usda_gsa_sam_exclusion
, staging_table.prp_usda_gsa_sam_checked_date
, staging_table.prp_usda_rd_single_family_housing_type
, staging_table.prp_underwrite_method_type
, staging_table.prp_mi_required
, staging_table.prp_decision_credit_score_borrower_pid
, staging_table.prp_decision_credit_score
, staging_table.prp_estimated_credit_score
, staging_table.prp_effective_credit_score
, staging_table.prp_mortgagee_builder_seller_relationship
, staging_table.prp_fha_prior_agency_case_id
, staging_table.prp_fha_prior_agency_case_endorsement_date
, staging_table.prp_fha_refinance_authorization_number
, staging_table.prp_fha_refinance_authorization_expiration_date
, staging_table.prp_fhac_refinance_authorization_messages
, staging_table.prp_hud_fha_de_approval_type
, staging_table.prp_owner_occupancy_not_required
, staging_table.prp_va_monthly_utilities_included
, staging_table.prp_va_maintenance_utilities_auto_compute
, staging_table.prp_va_monthly_maintenance_utilities_amount
, staging_table.prp_va_maintenance_utilities_per_square_feet_amount
, staging_table.prp_household_size_count
, staging_table.prp_va_past_credit_record_type
, staging_table.prp_va_meets_credit_standards
, staging_table.prp_va_prior_paid_in_full_loan_number
, staging_table.prp_note_date
, staging_table.prp_security_instrument_type
, staging_table.prp_trustee_pid
, staging_table.prp_trustee_name
, staging_table.prp_trustee_address_street1
, staging_table.prp_trustee_address_street2
, staging_table.prp_trustee_address_city
, staging_table.prp_trustee_address_state
, staging_table.prp_trustee_address_postal_code
, staging_table.prp_trustee_address_country
, staging_table.prp_trustee_mers_org_id
, staging_table.prp_trustee_phone_number
, staging_table.prp_fre_ctp_closing_feature_type
, staging_table.prp_fre_ctp_first_payment_due_date
, staging_table.prp_purchase_contract_date
, staging_table.prp_purchase_contract_financing_contingency_date
, staging_table.prp_purchase_contract_funding_date
, staging_table.prp_effective_property_value_type
, staging_table.prp_effective_property_value_amount
, staging_table.prp_decision_appraised_value_amount
, staging_table.prp_fha_va_reasonable_value_amount
, staging_table.prp_cd_clear_date
, staging_table.prp_disaster_declaration_check_date_type
, staging_table.prp_disaster_declaration_check_date
, staging_table.prp_any_disaster_declaration_before_appraisal
, staging_table.prp_any_disaster_declaration_after_appraisal
, staging_table.prp_any_disaster_declaration
, staging_table.prp_early_first_payment
, staging_table.prp_property_acquired_through_inheritance
, staging_table.prp_property_acquired_through_ancillary_relief
, staging_table.prp_delayed_financing_exception_guidelines_applicable
, staging_table.prp_delayed_financing_exception_verified
, staging_table.prp_effective_property_value_explanation_type
, staging_table.prp_taxes_escrowed
, staging_table.prp_flood_insurance_applicable
, staging_table.prp_windstorm_insurance_applicable
, staging_table.prp_earthquake_insurance_applicable
, staging_table.prp_arms_length
, staging_table.prp_fha_non_arms_length_ltv_exception_type
, staging_table.prp_fha_non_arms_length_ltv_exception_verified
, staging_table.prp_escrow_cushion_months
, staging_table.prp_escrow_cushion_months_auto_compute
, staging_table.prp_fha_eligible_maximum_financing
, staging_table.prp_hazard_insurance_applicable
, staging_table.prp_property_repairs_required_type
, staging_table.prp_property_repairs_description
, staging_table.prp_property_repairs_cost_amount
, staging_table.prp_property_repairs_holdback_calc_type
, staging_table.prp_property_repairs_holdback_amount
, staging_table.prp_property_repairs_holdback_payer_type
, staging_table.prp_property_repairs_holdback_administrator
, staging_table.prp_property_repairs_holdback_required_completion_date
, staging_table.prp_property_repairs_completed_notification_date
, staging_table.prp_property_repairs_inspection_ordered_date
, staging_table.prp_property_repairs_inspection_completed_date
, staging_table.prp_property_repairs_funds_released_contractor_date
, staging_table.prp_anti_steering_lowest_rate_option_rate_percent
, staging_table.prp_anti_steering_lowest_rate_option_fee_amount
, staging_table.prp_anti_steering_lowest_rate_wo_neg_option_rate_percent
, staging_table.prp_anti_steering_lowest_rate_wo_neg_option_fee_amount
, staging_table.prp_anti_steering_lowest_cost_option_rate_percent
, staging_table.prp_anti_steering_lowest_cost_option_fee_amount
, staging_table.prp_initial_uw_submit_datetime
, staging_table.prp_va_notice_of_value_source_type
, staging_table.prp_va_notice_of_value_date
, staging_table.prp_va_notice_of_value_estimated_reasonable_value_amount
, staging_table.prp_sar_significant_adjustments
, staging_table.prp_separate_transaction_for_land_acquisition
, staging_table.prp_land_acquisition_transaction_date
, staging_table.prp_land_acquisition_price
, staging_table.prp_cash_out_reason_home_improvement
, staging_table.prp_cash_out_reason_debt_or_debt_consolidation
, staging_table.prp_cash_out_reason_personal_use
, staging_table.prp_cash_out_reason_future_investment_not_under_contract
, staging_table.prp_cash_out_reason_future_investment_under_contract
, staging_table.prp_cash_out_reason_other
, staging_table.prp_cash_out_reason_other_text
, staging_table.prp_decision_veteran_borrower_pid
, staging_table.prp_signed_closing_doc_received_datetime
, staging_table.prp_other_lender_requires_appraisal
, staging_table.prp_other_lender_requires_appraisal_reason
, staging_table.prp_texas_equity_determination_datetime
, staging_table.prp_texas_equity_conversion_determination_datetime
, staging_table.prp_texas_equity_determination_datetime_override
, staging_table.prp_texas_equity_determination_datetime_override_reason
, staging_table.prp_texas_equity_conversion_determination_datetime_override
, staging_table.prp_texas_equity_conversion_determ_datetime_override_reason
, staging_table.prp_cema
, staging_table.prp_cema_borrower_savings
, staging_table.prp_any_vesting_changes
, staging_table.prp_vesting_change_titleholder_added
, staging_table.prp_vesting_change_titleholder_removed
, staging_table.prp_vesting_change_titleholder_name_change
, staging_table.prp_deed_taxes_applicable
, staging_table.prp_deed_taxes_applicable_explanation
, staging_table.prp_deed_taxes_auto_compute
, staging_table.prp_deed_taxes_auto_compute_override_reason
, staging_table.prp_intent_to_proceed_date
, staging_table.prp_intent_to_proceed_type
, staging_table.prp_intent_to_proceed_provider_unparsed_name
, staging_table.prp_intent_to_proceed_obtainer_unparsed_name
, staging_table.prp_cash_out_reason_student_loans
, staging_table.prp_household_income_exclusive_edit
, staging_table.prp_purchase_contract_received_date
, staging_table.prp_down_payment_percent_mode
, staging_table.prp_lender_escrow_loan_amount
, staging_table.prp_underwrite_disposition_note
, staging_table.prp_rescission_applicable
, staging_table.prp_area_median_income
, staging_table.prp_total_income_to_ami_ratio
, staging_table.prp_cr_tracker_url
, staging_table.prp_construction_borrower_contribution_amount
, staging_table.prp_construction_lot_ownership_status_type
, staging_table.prp_intent_to_proceed_provided
, staging_table.prp_effective_signing_location_state
, staging_table.prp_effective_signing_location_city
, staging_table.prp_va_required_guaranty_amount
, staging_table.prp_va_amount_used_to_calculate_maximum_guaranty
, staging_table.prp_va_actual_guaranty_amount
, staging_table.prp_last_corrective_disclosure_processed_datetime
, staging_table.prp_user_entered_note_date
, staging_table.prp_effective_note_date
, staging_table.prp_lender_escrow_loan_due_date
, staging_table.prp_va_maximum_base_loan_amount
, staging_table.prp_va_maximum_funding_fee_amount
, staging_table.prp_va_maximum_total_loan_amount
, staging_table.prp_va_required_cash_amount
, staging_table.prp_va_guaranty_percent
, staging_table.prp_gse_version_type
, staging_table.prp_minimum_household_income_amount
, staging_table.prp_minimum_residual_income_amount
, staging_table.prp_minimum_residual_income_auto_compute
, staging_table.prp_financed_property_improvements_category_type
, staging_table.prp_adjusted_as_is_value_amount
, staging_table.prp_after_improved_value_amount
, staging_table.prp_disclosure_action_type
, staging_table.prp_hud_consultant
, staging_table.prp_initial_uw_disposition_datetime
, staging_table.prp_preapproval_uw_submit_datetime
, staging_table.prp_preapproval_uw_disposition_datetime
, FALSE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal staging_table
LEFT JOIN history_octane.proposal history_table
          ON staging_table.prp_pid = history_table.prp_pid AND staging_table.prp_version = history_table.prp_version
WHERE history_table.prp_pid IS NULL
UNION ALL
SELECT history_table.prp_estimated_hard_construction_cost_amount
, history_table.prp_financed_property_improvements
, history_table.prp_pid
, history_table.prp_version + 1
, history_table.prp_decision_lp_request_pid
, history_table.prp_decision_du_request_pid
, history_table.prp_proposal_type
, history_table.prp_description
, history_table.prp_doc_level_type
, history_table.prp_loan_purpose_type
, history_table.prp_name
, history_table.prp_create_datetime
, history_table.prp_effective_funding_date
, history_table.prp_estimated_funding_date
, history_table.prp_calculated_earliest_allowed_consummation_date
, history_table.prp_overridden_earliest_allowed_consummation_date
, history_table.prp_effective_earliest_allowed_consummation_date
, history_table.prp_earliest_allowed_consummation_date_override_reason
, history_table.prp_last_requested_disclosure_date
, history_table.prp_closing_document_sign_datetime
, history_table.prp_scheduled_closing_document_sign_datetime
, history_table.prp_rescission_through_date
, history_table.prp_rescission_notification_date
, history_table.prp_rescission_notification_by
, history_table.prp_rescission_notification_type
, history_table.prp_rescission_effective_date
, history_table.prp_first_payment_date
, history_table.prp_first_payment_date_auto_compute
, history_table.prp_property_usage_type
, history_table.prp_estimated_property_value_amount
, history_table.prp_smart_charges_enabled
, history_table.prp_charges_updated_datetime
, history_table.prp_smart_docs_enabled
, history_table.prp_docs_enabled_datetime
, history_table.prp_request_fha_mip_refund_required
, history_table.prp_request_recording_fees_required
, history_table.prp_request_property_taxes_required
, history_table.prp_property_tax_request_error_messages
, history_table.prp_fha_mip_refund_request_input_error
, history_table.prp_recording_fees_request_input_error
, history_table.prp_property_taxes_request_input_error
, history_table.prp_publish
, history_table.prp_publish_date
, history_table.prp_ipc_auto_compute
, history_table.prp_ipc_limit_percent
, history_table.prp_ipc_maximum_amount_allowed
, history_table.prp_ipc_amount
, history_table.prp_ipc_percent
, history_table.prp_ipc_financing_concession_amount
, history_table.prp_ipc_non_cash_concession_amount
, history_table.prp_sale_price_amount
, history_table.prp_structure_type
, history_table.prp_deal_pid
, history_table.prp_gfe_interest_rate_expiration_date
, history_table.prp_gfe_lock_duration_days
, history_table.prp_gfe_lock_before_settlement_days
, history_table.prp_proposal_expiration_date
, history_table.prp_uuts_master_contact_name
, history_table.prp_uuts_master_contact_title
, history_table.prp_uuts_master_office_phone
, history_table.prp_uuts_master_office_phone_extension
, history_table.prp_underwrite_risk_assessment_type
, history_table.prp_underwriting_comments
, history_table.prp_reserves_auto_compute
, history_table.prp_reserves_amount
, history_table.prp_reserves_months
, history_table.prp_underwrite_disposition_type
, history_table.prp_underwrite_publish_date
, history_table.prp_underwrite_expiration_date
, history_table.prp_usda_gsa_sam_exclusion
, history_table.prp_usda_gsa_sam_checked_date
, history_table.prp_usda_rd_single_family_housing_type
, history_table.prp_underwrite_method_type
, history_table.prp_mi_required
, history_table.prp_decision_credit_score_borrower_pid
, history_table.prp_decision_credit_score
, history_table.prp_estimated_credit_score
, history_table.prp_effective_credit_score
, history_table.prp_mortgagee_builder_seller_relationship
, history_table.prp_fha_prior_agency_case_id
, history_table.prp_fha_prior_agency_case_endorsement_date
, history_table.prp_fha_refinance_authorization_number
, history_table.prp_fha_refinance_authorization_expiration_date
, history_table.prp_fhac_refinance_authorization_messages
, history_table.prp_hud_fha_de_approval_type
, history_table.prp_owner_occupancy_not_required
, history_table.prp_va_monthly_utilities_included
, history_table.prp_va_maintenance_utilities_auto_compute
, history_table.prp_va_monthly_maintenance_utilities_amount
, history_table.prp_va_maintenance_utilities_per_square_feet_amount
, history_table.prp_household_size_count
, history_table.prp_va_past_credit_record_type
, history_table.prp_va_meets_credit_standards
, history_table.prp_va_prior_paid_in_full_loan_number
, history_table.prp_note_date
, history_table.prp_security_instrument_type
, history_table.prp_trustee_pid
, history_table.prp_trustee_name
, history_table.prp_trustee_address_street1
, history_table.prp_trustee_address_street2
, history_table.prp_trustee_address_city
, history_table.prp_trustee_address_state
, history_table.prp_trustee_address_postal_code
, history_table.prp_trustee_address_country
, history_table.prp_trustee_mers_org_id
, history_table.prp_trustee_phone_number
, history_table.prp_fre_ctp_closing_feature_type
, history_table.prp_fre_ctp_first_payment_due_date
, history_table.prp_purchase_contract_date
, history_table.prp_purchase_contract_financing_contingency_date
, history_table.prp_purchase_contract_funding_date
, history_table.prp_effective_property_value_type
, history_table.prp_effective_property_value_amount
, history_table.prp_decision_appraised_value_amount
, history_table.prp_fha_va_reasonable_value_amount
, history_table.prp_cd_clear_date
, history_table.prp_disaster_declaration_check_date_type
, history_table.prp_disaster_declaration_check_date
, history_table.prp_any_disaster_declaration_before_appraisal
, history_table.prp_any_disaster_declaration_after_appraisal
, history_table.prp_any_disaster_declaration
, history_table.prp_early_first_payment
, history_table.prp_property_acquired_through_inheritance
, history_table.prp_property_acquired_through_ancillary_relief
, history_table.prp_delayed_financing_exception_guidelines_applicable
, history_table.prp_delayed_financing_exception_verified
, history_table.prp_effective_property_value_explanation_type
, history_table.prp_taxes_escrowed
, history_table.prp_flood_insurance_applicable
, history_table.prp_windstorm_insurance_applicable
, history_table.prp_earthquake_insurance_applicable
, history_table.prp_arms_length
, history_table.prp_fha_non_arms_length_ltv_exception_type
, history_table.prp_fha_non_arms_length_ltv_exception_verified
, history_table.prp_escrow_cushion_months
, history_table.prp_escrow_cushion_months_auto_compute
, history_table.prp_fha_eligible_maximum_financing
, history_table.prp_hazard_insurance_applicable
, history_table.prp_property_repairs_required_type
, history_table.prp_property_repairs_description
, history_table.prp_property_repairs_cost_amount
, history_table.prp_property_repairs_holdback_calc_type
, history_table.prp_property_repairs_holdback_amount
, history_table.prp_property_repairs_holdback_payer_type
, history_table.prp_property_repairs_holdback_administrator
, history_table.prp_property_repairs_holdback_required_completion_date
, history_table.prp_property_repairs_completed_notification_date
, history_table.prp_property_repairs_inspection_ordered_date
, history_table.prp_property_repairs_inspection_completed_date
, history_table.prp_property_repairs_funds_released_contractor_date
, history_table.prp_anti_steering_lowest_rate_option_rate_percent
, history_table.prp_anti_steering_lowest_rate_option_fee_amount
, history_table.prp_anti_steering_lowest_rate_wo_neg_option_rate_percent
, history_table.prp_anti_steering_lowest_rate_wo_neg_option_fee_amount
, history_table.prp_anti_steering_lowest_cost_option_rate_percent
, history_table.prp_anti_steering_lowest_cost_option_fee_amount
, history_table.prp_initial_uw_submit_datetime
, history_table.prp_va_notice_of_value_source_type
, history_table.prp_va_notice_of_value_date
, history_table.prp_va_notice_of_value_estimated_reasonable_value_amount
, history_table.prp_sar_significant_adjustments
, history_table.prp_separate_transaction_for_land_acquisition
, history_table.prp_land_acquisition_transaction_date
, history_table.prp_land_acquisition_price
, history_table.prp_cash_out_reason_home_improvement
, history_table.prp_cash_out_reason_debt_or_debt_consolidation
, history_table.prp_cash_out_reason_personal_use
, history_table.prp_cash_out_reason_future_investment_not_under_contract
, history_table.prp_cash_out_reason_future_investment_under_contract
, history_table.prp_cash_out_reason_other
, history_table.prp_cash_out_reason_other_text
, history_table.prp_decision_veteran_borrower_pid
, history_table.prp_signed_closing_doc_received_datetime
, history_table.prp_other_lender_requires_appraisal
, history_table.prp_other_lender_requires_appraisal_reason
, history_table.prp_texas_equity_determination_datetime
, history_table.prp_texas_equity_conversion_determination_datetime
, history_table.prp_texas_equity_determination_datetime_override
, history_table.prp_texas_equity_determination_datetime_override_reason
, history_table.prp_texas_equity_conversion_determination_datetime_override
, history_table.prp_texas_equity_conversion_determ_datetime_override_reason
, history_table.prp_cema
, history_table.prp_cema_borrower_savings
, history_table.prp_any_vesting_changes
, history_table.prp_vesting_change_titleholder_added
, history_table.prp_vesting_change_titleholder_removed
, history_table.prp_vesting_change_titleholder_name_change
, history_table.prp_deed_taxes_applicable
, history_table.prp_deed_taxes_applicable_explanation
, history_table.prp_deed_taxes_auto_compute
, history_table.prp_deed_taxes_auto_compute_override_reason
, history_table.prp_intent_to_proceed_date
, history_table.prp_intent_to_proceed_type
, history_table.prp_intent_to_proceed_provider_unparsed_name
, history_table.prp_intent_to_proceed_obtainer_unparsed_name
, history_table.prp_cash_out_reason_student_loans
, history_table.prp_household_income_exclusive_edit
, history_table.prp_purchase_contract_received_date
, history_table.prp_down_payment_percent_mode
, history_table.prp_lender_escrow_loan_amount
, history_table.prp_underwrite_disposition_note
, history_table.prp_rescission_applicable
, history_table.prp_area_median_income
, history_table.prp_total_income_to_ami_ratio
, history_table.prp_cr_tracker_url
, history_table.prp_construction_borrower_contribution_amount
, history_table.prp_construction_lot_ownership_status_type
, history_table.prp_intent_to_proceed_provided
, history_table.prp_effective_signing_location_state
, history_table.prp_effective_signing_location_city
, history_table.prp_va_required_guaranty_amount
, history_table.prp_va_amount_used_to_calculate_maximum_guaranty
, history_table.prp_va_actual_guaranty_amount
, history_table.prp_last_corrective_disclosure_processed_datetime
, history_table.prp_user_entered_note_date
, history_table.prp_effective_note_date
, history_table.prp_lender_escrow_loan_due_date
, history_table.prp_va_maximum_base_loan_amount
, history_table.prp_va_maximum_funding_fee_amount
, history_table.prp_va_maximum_total_loan_amount
, history_table.prp_va_required_cash_amount
, history_table.prp_va_guaranty_percent
, history_table.prp_gse_version_type
, history_table.prp_minimum_household_income_amount
, history_table.prp_minimum_residual_income_amount
, history_table.prp_minimum_residual_income_auto_compute
, history_table.prp_financed_property_improvements_category_type
, history_table.prp_adjusted_as_is_value_amount
, history_table.prp_after_improved_value_amount
, history_table.prp_disclosure_action_type
, history_table.prp_hud_consultant
, history_table.prp_initial_uw_disposition_datetime
, history_table.prp_preapproval_uw_submit_datetime
, history_table.prp_preapproval_uw_disposition_datetime
, TRUE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal history_table
LEFT JOIN staging_octane.proposal staging_table
          ON staging_table.prp_pid = history_table.prp_pid
WHERE staging_table.prp_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.proposal deleted_records
                  WHERE deleted_records.prp_pid = history_table.prp_pid
                    AND deleted_records.data_source_deleted_flag = TRUE);')
)

, updated_table_input_step AS (
    UPDATE mdi.table_input_step
        SET sql = updated_table_input_sql.sql
        FROM updated_table_input_sql, mdi.table_output_step
        WHERE table_input_step.process_dwid = table_output_step.process_dwid
            AND table_output_step.target_schema = 'history_octane'
            AND table_output_step.target_table = updated_table_input_sql.table_name
)

SELECT 'Finished inserting metadata for new proposal columns: prp_initial_uw_disposition_datetime, ' ||
       'prp_preapproval_uw_submit_datetime, prp_preapproval_uw_disposition_datetime';