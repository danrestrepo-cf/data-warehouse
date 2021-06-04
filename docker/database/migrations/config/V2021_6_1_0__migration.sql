--
-- EDW | edw_field_definition - fix data type mismatches between dimensions and source fields
-- https://app.asana.com/0/0/1200393611923107
--

-- add missing field source calculations
CREATE TEMPORARY TABLE temp_field_calculations (
    schema_name TEXT,
    table_name TEXT,
    field_name TEXT,
    calculation TEXT
);

INSERT
INTO temp_field_calculations (schema_name, table_name, field_name, calculation)
VALUES ('star_loan', 'transaction_junk_dim', 'piggyback_flag', 'prp_structure_type = ''COMBO''')
     , ('star_loan', 'borrower_demographics_dim', 'ethnicity_other_hispanic_or_latino_description_flag', 'borrower.b_ethnicity_other_hispanic_or_latino_description <> ''''')
     , ('star_loan', 'borrower_demographics_dim', 'other_race_national_origin_description_flag', 'borrower.b_other_race_national_origin_description <> ''''')
     , ('star_loan', 'borrower_demographics_dim', 'race_other_american_indian_or_alaska_native_description_flag', 'borrower.b_race_other_american_indian_or_alaska_native_description <> ''''')
     , ('star_loan', 'borrower_demographics_dim', 'race_other_asian_description_flag', 'borrower.b_race_other_asian_description <> ''''')
     , ('star_loan', 'borrower_demographics_dim', 'race_other_pacific_islander_description_flag', 'borrower.b_race_other_pacific_islander_description <> ''''');

UPDATE mdi.edw_field_definition
SET field_source_calculation = temp_field_calculations.calculation
  , source_edw_field_definition_dwid = NULL
FROM temp_field_calculations
   , mdi.edw_table_definition
WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_table_definition.schema_name = temp_field_calculations.schema_name
  AND edw_table_definition.table_name = temp_field_calculations.table_name
  AND edw_field_definition.field_name = temp_field_calculations.field_name;

-- update data type for borrower_demographics_dim.schooling_years
UPDATE mdi.edw_field_definition
SET data_type = 'INTEGER'
FROM mdi.edw_table_definition
WHERE edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
  AND edw_table_definition.schema_name = 'star_loan'
  AND edw_table_definition.table_name = 'borrower_demographics_dim'
  AND edw_field_definition.field_name = 'schooling_years';

--
-- Main | EDW | Octane Schema changes for 2021.6.1.0 (6/4/21)
-- https://app.asana.com/0/0/1200421121421369
--

--
-- INSERT EDW_TABLE_DEFINITION ROWS FOR NEW TABLES: disclosure_action_type, proposal_construction
--

-- Insert edw_table_definition rows for disclosure_action_type
WITH staging_table AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'disclosure_action_type', NULL)
        RETURNING dwid
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT 'staging', 'history_octane', 'disclosure_action_type', staging_table.dwid
FROM staging_table;

-- Insert edw_table_definition rows for proposal_construction
WITH staging_table AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'proposal_construction', NULL)
        RETURNING dwid
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT 'staging', 'history_octane', 'proposal_construction', staging_table.dwid
FROM staging_table;

--
-- INSERT EDW_FIELD_DEFINITION ROWS FOR NEW TABLES: disclosure_action_type, proposal_construction
--

-- Load fields common to both history_octane and staging_octane into temp table before inserting staging_octane field data
CREATE TEMPORARY TABLE temp_new_table_field_data (
    table_name TEXT,
    field_name TEXT,
    key_field_flag BOOLEAN,
    field_order INTEGER
);

INSERT
INTO temp_new_table_field_data (table_name, field_name, key_field_flag, field_order)
VALUES ('disclosure_action_type', 'code', TRUE, 1)
     , ('disclosure_action_type', 'value', FALSE, 2)
     , ('proposal_construction', 'prpc_pid', TRUE, 1)
     , ('proposal_construction', 'prpc_version', FALSE, 2)
     , ('proposal_construction', 'prpc_proposal_pid', FALSE, 3)
     , ('proposal_construction', 'prpc_architectural_exhibits', FALSE, 4)
     , ('proposal_construction', 'prpc_feasibility_study', FALSE, 5)
     , ('proposal_construction', 'prpc_expected_months_to_complete', FALSE, 6)
     , ('proposal_construction', 'prpc_extension_needed', FALSE, 7)
     , ('proposal_construction', 'prpc_extension_period_months', FALSE, 8)
     , ('proposal_construction', 'prpc_any_utilities_inoperable', FALSE, 9)
     , ('proposal_construction', 'prpc_non_habitable_months', FALSE, 10)
     , ('proposal_construction', 'prpc_non_habitable_units', FALSE, 11)
     , ('proposal_construction', 'prpc_number_of_draws', FALSE, 12)
     , ('proposal_construction', 'prpc_construction_confirmed_start_date', FALSE, 13)
     , ('proposal_construction', 'prpc_loan_in_process_account_closed_date', FALSE, 14)
     , ('proposal_construction', 'prpc_mortgage_payment_reserves_required', FALSE, 15);

-- Insert edw_field_definition data for new staging_octane tables
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
SELECT edw_table_definition.dwid, temp_new_table_field_data.field_name, temp_new_table_field_data.key_field_flag
FROM temp_new_table_field_data
JOIN mdi.edw_table_definition
     ON temp_new_table_field_data.table_name = edw_table_definition.table_name
         AND edw_table_definition.schema_name = 'staging_octane';

-- Load history_octane-specific fields into temporary table before inserting history_octane field data
INSERT
INTO temp_new_table_field_data (table_name, field_name, key_field_flag, field_order)
VALUES ('disclosure_action_type', 'data_source_updated_datetime', FALSE, 3)
     , ('disclosure_action_type', 'data_source_deleted_flag', FALSE, 4)
     , ('proposal_construction', 'data_source_updated_datetime', FALSE, 16)
     , ('proposal_construction', 'data_source_deleted_flag', FALSE, 17);

-- Insert edw_field_definition data fo new history_octane tables
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid)
SELECT edw_table_definition.dwid
     , temp_new_table_field_data.field_name
     , temp_new_table_field_data.key_field_flag
     , source_field_definition.dwid
FROM temp_new_table_field_data
JOIN mdi.edw_table_definition
     ON temp_new_table_field_data.table_name = edw_table_definition.table_name
         AND edw_table_definition.schema_name = 'history_octane'
JOIN mdi.edw_table_definition source_table_definition
     ON edw_table_definition.table_name = source_table_definition.table_name
         AND source_table_definition.schema_name = 'staging_octane'
LEFT JOIN mdi.edw_field_definition source_field_definition
          ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid
              AND temp_new_table_field_data.field_name = source_field_definition.field_name;

--
-- INSERT MDI ETL CONFIG DATA FOR NEW TABLES: disclosure_action_type, proposal_construction
--

-- Load field values that differ between processes into a temp table before inserting MDI config data
CREATE TEMPORARY TABLE temp_new_table_mdi_data (
    table_name TEXT,
    process_name TEXT,
    json_output_field TEXT,
    input_sql TEXT,
    process_dwid BIGINT
);

INSERT
INTO temp_new_table_mdi_data (table_name, process_name, json_output_field, input_sql)
VALUES ('disclosure_action_type', 'SP-100825', 'code', 'SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.disclosure_action_type staging_table
LEFT JOIN history_octane.disclosure_action_type history_table
          ON staging_table.code = history_table.code AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;')
     , ('proposal_construction', 'SP-100826', 'prpc_pid', '--finding records to insert into history_octane.proposal_construction
SELECT staging_table.prpc_pid
     , staging_table.prpc_version
     , staging_table.prpc_proposal_pid
     , staging_table.prpc_architectural_exhibits
     , staging_table.prpc_feasibility_study
     , staging_table.prpc_expected_months_to_complete
     , staging_table.prpc_extension_needed
     , staging_table.prpc_extension_period_months
     , staging_table.prpc_any_utilities_inoperable
     , staging_table.prpc_non_habitable_months
     , staging_table.prpc_non_habitable_units
     , staging_table.prpc_number_of_draws
     , staging_table.prpc_construction_confirmed_start_date
     , staging_table.prpc_loan_in_process_account_closed_date
     , staging_table.prpc_mortgage_payment_reserves_required
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal_construction staging_table
LEFT JOIN history_octane.proposal_construction history_table
          ON staging_table.prpc_pid = history_table.prpc_pid AND staging_table.prpc_version = history_table.prpc_version
WHERE history_table.prpc_pid IS NULL
UNION ALL
SELECT history_table.prpc_pid
     , history_table.prpc_version + 1
     , history_table.prpc_proposal_pid
     , history_table.prpc_architectural_exhibits
     , history_table.prpc_feasibility_study
     , history_table.prpc_expected_months_to_complete
     , history_table.prpc_extension_needed
     , history_table.prpc_extension_period_months
     , history_table.prpc_any_utilities_inoperable
     , history_table.prpc_non_habitable_months
     , history_table.prpc_non_habitable_units
     , history_table.prpc_number_of_draws
     , history_table.prpc_construction_confirmed_start_date
     , history_table.prpc_loan_in_process_account_closed_date
     , history_table.prpc_mortgage_payment_reserves_required
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal_construction history_table
LEFT JOIN staging_octane.proposal_construction staging_table
          ON staging_table.prpc_pid = history_table.prpc_pid
WHERE staging_table.prpc_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.proposal_construction deleted_records
                  WHERE deleted_records.prpc_pid = history_table.prpc_pid
                    AND deleted_records.data_source_deleted_flag = TRUE )');

-- Insert process rows for all new tables
INSERT
INTO mdi.process (name, description)
SELECT process_name, 'ETL to copy ' || table_name || ' data from staging_octane to history_octane'
FROM temp_new_table_mdi_data;

-- Update temp_mdi_data table with newly-inserted process dwids to avoid repetitive joins later
UPDATE temp_new_table_mdi_data
SET process_dwid = process.dwid
FROM mdi.process
WHERE temp_new_table_mdi_data.process_name = process.name;

-- Insert table_input_step rows for all new tables
INSERT
INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
SELECT temp_new_table_mdi_data.process_dwid
     , 0
     , temp_new_table_mdi_data.input_sql
     , 0
     , 'N'
     , 'N'
     , 'N'
     , 'N'
     , 'Staging DB Connection'
FROM temp_new_table_mdi_data;

-- Insert table_output_step rows for all new tables
INSERT
INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT temp_new_table_mdi_data.process_dwid
     , 'history_octane'
     , temp_new_table_mdi_data.table_name
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
FROM temp_new_table_mdi_data;

-- Insert table_output_field rows for all new tables
INSERT
INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
SELECT table_output_step.dwid
     , temp_new_table_field_data.field_name
     , temp_new_table_field_data.field_name
     , temp_new_table_field_data.field_order
     , FALSE
FROM temp_new_table_mdi_data
JOIN temp_new_table_field_data
     ON temp_new_table_mdi_data.table_name = temp_new_table_field_data.table_name
JOIN mdi.table_output_step
     ON temp_new_table_mdi_data.table_name = table_output_step.target_table
         AND table_output_step.target_schema = 'history_octane';

-- Insert state_machine_definition rows for all new tables
INSERT
INTO mdi.state_machine_definition (process_dwid, name, comment)
SELECT temp_new_table_mdi_data.process_dwid
     , 'Octane ' || temp_new_table_mdi_data.table_name
     , 'ETL to copy ' || temp_new_table_mdi_data.table_name || ' data from staging_octane to history_octane'
FROM temp_new_table_mdi_data;

-- Insert state_machine_step rows for all new tables
INSERT
INTO mdi.state_machine_step (process_dwid, next_process_dwid)
SELECT temp_new_table_mdi_data.process_dwid, NULL
FROM temp_new_table_mdi_data;

-- Insert json_output_field rows for all new tables
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT temp_new_table_mdi_data.process_dwid, temp_new_table_mdi_data.json_output_field
FROM temp_new_table_mdi_data;

--
-- INSERT EDW_FIELD_DEFINITION DATA FOR NEW COLUMNS:
-- - proposal.prp_disclosure_action_type
-- - construction_cost.coc_permit_pid
-- - construction_cost.coc_category_type_label
-- - product_terms.pt_maximum_number_of_construction_draws
--

-- Load fields common to both history_octane and staging_octane into temp table before inserting staging_octane field data
CREATE TEMPORARY TABLE temp_new_column_field_data (
    table_name TEXT,
    field_name TEXT,
    key_field_flag BOOLEAN,
    field_order INTEGER
);

INSERT
INTO temp_new_column_field_data (table_name, field_name, key_field_flag, field_order)
VALUES ('proposal', 'prp_disclosure_action_type', FALSE, 231)
     , ('construction_cost', 'coc_permit_pid', FALSE, 15)
     , ('construction_cost', 'coc_category_type_label', FALSE, 16)
     , ('product_terms', 'pt_maximum_number_of_construction_draws', FALSE, 119);

-- Insert edw_field_definition data for new staging_octane columns
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
SELECT edw_table_definition.dwid, temp_new_column_field_data.field_name, temp_new_column_field_data.key_field_flag
FROM temp_new_column_field_data
JOIN mdi.edw_table_definition
     ON temp_new_column_field_data.table_name = edw_table_definition.table_name
         AND edw_table_definition.schema_name = 'staging_octane';

-- Insert edw_field_definition data for new history_octane columns
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid)
SELECT edw_table_definition.dwid
     , temp_new_column_field_data.field_name
     , temp_new_column_field_data.key_field_flag
     , source_field_definition.dwid
FROM temp_new_column_field_data
JOIN mdi.edw_table_definition
     ON temp_new_column_field_data.table_name = edw_table_definition.table_name
         AND edw_table_definition.schema_name = 'history_octane'
JOIN mdi.edw_table_definition source_table_definition
     ON edw_table_definition.table_name = source_table_definition.table_name
         AND source_table_definition.schema_name = 'staging_octane'
LEFT JOIN mdi.edw_field_definition source_field_definition
          ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid
              AND temp_new_column_field_data.field_name = source_field_definition.field_name;

--
-- INSERT/UPDATE MDI CONFIG DATA FOR NEW COLUMNS:
-- - proposal.prp_disclosure_action_type
-- - construction_cost.coc_permit_pid
-- - construction_cost.coc_category_type_label
-- - product_terms.pt_maximum_number_of_construction_draws
--

-- Load field values that differ between processes into a temp table before inserting MDI config data
CREATE TEMPORARY TABLE temp_new_column_mdi_data (
    process_name TEXT,
    input_sql TEXT
);

INSERT
INTO temp_new_column_mdi_data (process_name, input_sql)
-- proposal (also remove proposal.prp_fre_ctp_closing_type in this step, since it is being deleted)
VALUES ('SP-100317', '--finding records to insert into history_octane.proposal
SELECT staging_table.prp_pid
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
     , staging_table.prp_fha_203k_consultant_id
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
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal staging_table
LEFT JOIN history_octane.proposal history_table
          ON staging_table.prp_pid = history_table.prp_pid AND staging_table.prp_version = history_table.prp_version
WHERE history_table.prp_pid IS NULL
UNION ALL
SELECT history_table.prp_pid
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
     , history_table.prp_fha_203k_consultant_id
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
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal history_table
LEFT JOIN staging_octane.proposal staging_table
          ON staging_table.prp_pid = history_table.prp_pid
WHERE staging_table.prp_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.proposal deleted_records
                  WHERE deleted_records.prp_pid = history_table.prp_pid
                    AND deleted_records.data_source_deleted_flag = TRUE );
')
-- construction_cost
     , ('SP-100161', '--finding records to insert into history_octane.construction_cost
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
     , staging_table.coc_contractor_pid
     , staging_table.coc_proposal_contractor_pid
     , staging_table.coc_payee
     , staging_table.coc_permit_pid
     , staging_table.coc_category_type_label
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
     , history_table.coc_contractor_pid
     , history_table.coc_proposal_contractor_pid
     , history_table.coc_payee
     , history_table.coc_permit_pid
     , history_table.coc_category_type_label
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.construction_cost history_table
LEFT JOIN staging_octane.construction_cost staging_table
          ON staging_table.coc_pid = history_table.coc_pid
WHERE staging_table.coc_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.construction_cost deleted_records
                  WHERE deleted_records.coc_pid = history_table.coc_pid AND deleted_records.data_source_deleted_flag = TRUE )
')
-- product_terms
     , ('SP-100285', '--finding records to insert into history_octane.product_terms
SELECT staging_table.pt_pid
     , staging_table.pt_version
     , staging_table.pt_amortization_term_months
     , staging_table.pt_arm_index_type
     , staging_table.pt_arm_payment_adjustment_calculation_type
     , staging_table.pt_assumable
     , staging_table.pt_product_category
     , staging_table.pt_conditions_to_assumability
     , staging_table.pt_demand_feature
     , staging_table.pt_due_in_term_months
     , staging_table.pt_escrow_cushion_months
     , staging_table.pt_from_date
     , staging_table.pt_initial_payment_adjustment_term_months
     , staging_table.pt_initial_rate_adjustment_cap_percent
     , staging_table.pt_initial_rate_adjustment_term_months
     , staging_table.pt_lien_priority_type
     , staging_table.pt_loan_amortization_type
     , staging_table.pt_minimum_payment_rate_percent
     , staging_table.pt_minimum_rate_term_months
     , staging_table.pt_mortgage_type
     , staging_table.pt_negative_amortization_type
     , staging_table.pt_negative_amortization_limit_percent
     , staging_table.pt_negative_amortization_recast_period_months
     , staging_table.pt_payment_adjustment_lifetime_cap_percent
     , staging_table.pt_payment_adjustment_periodic_cap
     , staging_table.pt_payment_frequency_type
     , staging_table.pt_prepayment_finance_charge_refund
     , staging_table.pt_product_pid
     , staging_table.pt_rate_adjustment_lifetime_cap_percent
     , staging_table.pt_subsequent_payment_adjustment_term_months
     , staging_table.pt_subsequent_rate_adjustment_cap_percent
     , staging_table.pt_subsequent_rate_adjustment_term_months
     , staging_table.pt_prepay_penalty_type
     , staging_table.pt_lender_hazard_insurance_available
     , staging_table.pt_lender_hazard_insurance_premium_amount
     , staging_table.pt_lender_hazard_insurance_term_months
     , staging_table.pt_loan_requires_hazard_insurance
     , staging_table.pt_arm_convertible
     , staging_table.pt_arm_convertible_from_month
     , staging_table.pt_arm_convertible_through_month
     , staging_table.pt_arm_floor_rate_percent
     , staging_table.pt_arm_lookback_period_days
     , staging_table.pt_escrow_waiver_allowed
     , staging_table.pt_days_per_year_type
     , staging_table.pt_lp_risk_assessment_accepted
     , staging_table.pt_du_risk_assessment_accepted
     , staging_table.pt_manual_risk_assessment_accepted
     , staging_table.pt_internal_underwrite_accepted
     , staging_table.pt_external_fha_underwrite_accepted
     , staging_table.pt_external_va_underwrite_accepted
     , staging_table.pt_external_usda_underwrite_accepted
     , staging_table.pt_external_investor_underwrite_accepted
     , staging_table.pt_heloc_cancel_fee_applicable_type
     , staging_table.pt_heloc_cancel_fee_period_months
     , staging_table.pt_heloc_cancel_fee_amount
     , staging_table.pt_heloc_draw_period_months
     , staging_table.pt_heloc_repayment_period_duration_months
     , staging_table.pt_heloc_maximum_initial_draw
     , staging_table.pt_heloc_maximum_initial_draw_amount
     , staging_table.pt_heloc_minimum_draw
     , staging_table.pt_heloc_minimum_draw_amount
     , staging_table.pt_gpm_adjustment_years
     , staging_table.pt_gpm_adjustment_percent
     , staging_table.pt_qualifying_monthly_payment_type
     , staging_table.pt_qualifying_rate_type
     , staging_table.pt_qualifying_rate_input_percent
     , staging_table.pt_ipc_calc_type
     , staging_table.pt_ipc_limit_percent1
     , staging_table.pt_ipc_property_usage_type1
     , staging_table.pt_ipc_comparison_operator_type1
     , staging_table.pt_ipc_cltv_ratio_percent1
     , staging_table.pt_ipc_limit_percent2
     , staging_table.pt_ipc_property_usage_type2
     , staging_table.pt_ipc_comparison_operator_type2
     , staging_table.pt_ipc_cltv_ratio_percent2
     , staging_table.pt_ipc_limit_percent3
     , staging_table.pt_ipc_property_usage_type3
     , staging_table.pt_ipc_comparison_operator_type3
     , staging_table.pt_ipc_cltv_ratio_percent3
     , staging_table.pt_ipc_limit_percent4
     , staging_table.pt_ipc_property_usage_type4
     , staging_table.pt_ipc_comparison_operator_type4
     , staging_table.pt_ipc_cltv_ratio_percent4
     , staging_table.pt_buydown_base_date_type
     , staging_table.pt_buydown_subsidy_calculation_type
     , staging_table.pt_prepaid_interest_rate_type
     , staging_table.pt_fnm_arm_plan_type
     , staging_table.pt_dsi_plan_code
     , staging_table.pt_credit_qualifying
     , staging_table.pt_product_special_program_type
     , staging_table.pt_section_of_act_coarse_type
     , staging_table.pt_fha_rehab_program_type
     , staging_table.pt_fha_special_program_type
     , staging_table.pt_third_party_grant_eligible
     , staging_table.pt_servicing_transfer_type
     , staging_table.pt_no_mi_product
     , staging_table.pt_mortgage_credit_certificate_eligible
     , staging_table.pt_fre_community_program_type
     , staging_table.pt_fnm_community_lending_product_type
     , staging_table.pt_zero_note_rate
     , staging_table.pt_third_party_community_second_program_eligibility_type
     , staging_table.pt_texas_veterans_land_board
     , staging_table.pt_security_instrument_page_count
     , staging_table.pt_deed_page_count
     , staging_table.pt_partial_payment_policy_type
     , staging_table.pt_payment_structure_type
     , staging_table.pt_deferred_payment_months
     , staging_table.pt_always_current_market_price
     , staging_table.pt_rate_protect
     , staging_table.pt_non_conforming
     , staging_table.pt_allow_loan_amount_cents
     , staging_table.pt_product_appraisal_requirement_type
     , staging_table.pt_family_advantage
     , staging_table.pt_community_lending_type
     , staging_table.pt_high_balance
     , staging_table.pt_decision_credit_score_calc_type
     , staging_table.pt_new_york
     , staging_table.pt_maximum_number_of_construction_draws
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.product_terms staging_table
LEFT JOIN history_octane.product_terms history_table
          ON staging_table.pt_pid = history_table.pt_pid AND staging_table.pt_version = history_table.pt_version
WHERE history_table.pt_pid IS NULL
UNION ALL
SELECT history_table.pt_pid
     , history_table.pt_version + 1
     , history_table.pt_amortization_term_months
     , history_table.pt_arm_index_type
     , history_table.pt_arm_payment_adjustment_calculation_type
     , history_table.pt_assumable
     , history_table.pt_product_category
     , history_table.pt_conditions_to_assumability
     , history_table.pt_demand_feature
     , history_table.pt_due_in_term_months
     , history_table.pt_escrow_cushion_months
     , history_table.pt_from_date
     , history_table.pt_initial_payment_adjustment_term_months
     , history_table.pt_initial_rate_adjustment_cap_percent
     , history_table.pt_initial_rate_adjustment_term_months
     , history_table.pt_lien_priority_type
     , history_table.pt_loan_amortization_type
     , history_table.pt_minimum_payment_rate_percent
     , history_table.pt_minimum_rate_term_months
     , history_table.pt_mortgage_type
     , history_table.pt_negative_amortization_type
     , history_table.pt_negative_amortization_limit_percent
     , history_table.pt_negative_amortization_recast_period_months
     , history_table.pt_payment_adjustment_lifetime_cap_percent
     , history_table.pt_payment_adjustment_periodic_cap
     , history_table.pt_payment_frequency_type
     , history_table.pt_prepayment_finance_charge_refund
     , history_table.pt_product_pid
     , history_table.pt_rate_adjustment_lifetime_cap_percent
     , history_table.pt_subsequent_payment_adjustment_term_months
     , history_table.pt_subsequent_rate_adjustment_cap_percent
     , history_table.pt_subsequent_rate_adjustment_term_months
     , history_table.pt_prepay_penalty_type
     , history_table.pt_lender_hazard_insurance_available
     , history_table.pt_lender_hazard_insurance_premium_amount
     , history_table.pt_lender_hazard_insurance_term_months
     , history_table.pt_loan_requires_hazard_insurance
     , history_table.pt_arm_convertible
     , history_table.pt_arm_convertible_from_month
     , history_table.pt_arm_convertible_through_month
     , history_table.pt_arm_floor_rate_percent
     , history_table.pt_arm_lookback_period_days
     , history_table.pt_escrow_waiver_allowed
     , history_table.pt_days_per_year_type
     , history_table.pt_lp_risk_assessment_accepted
     , history_table.pt_du_risk_assessment_accepted
     , history_table.pt_manual_risk_assessment_accepted
     , history_table.pt_internal_underwrite_accepted
     , history_table.pt_external_fha_underwrite_accepted
     , history_table.pt_external_va_underwrite_accepted
     , history_table.pt_external_usda_underwrite_accepted
     , history_table.pt_external_investor_underwrite_accepted
     , history_table.pt_heloc_cancel_fee_applicable_type
     , history_table.pt_heloc_cancel_fee_period_months
     , history_table.pt_heloc_cancel_fee_amount
     , history_table.pt_heloc_draw_period_months
     , history_table.pt_heloc_repayment_period_duration_months
     , history_table.pt_heloc_maximum_initial_draw
     , history_table.pt_heloc_maximum_initial_draw_amount
     , history_table.pt_heloc_minimum_draw
     , history_table.pt_heloc_minimum_draw_amount
     , history_table.pt_gpm_adjustment_years
     , history_table.pt_gpm_adjustment_percent
     , history_table.pt_qualifying_monthly_payment_type
     , history_table.pt_qualifying_rate_type
     , history_table.pt_qualifying_rate_input_percent
     , history_table.pt_ipc_calc_type
     , history_table.pt_ipc_limit_percent1
     , history_table.pt_ipc_property_usage_type1
     , history_table.pt_ipc_comparison_operator_type1
     , history_table.pt_ipc_cltv_ratio_percent1
     , history_table.pt_ipc_limit_percent2
     , history_table.pt_ipc_property_usage_type2
     , history_table.pt_ipc_comparison_operator_type2
     , history_table.pt_ipc_cltv_ratio_percent2
     , history_table.pt_ipc_limit_percent3
     , history_table.pt_ipc_property_usage_type3
     , history_table.pt_ipc_comparison_operator_type3
     , history_table.pt_ipc_cltv_ratio_percent3
     , history_table.pt_ipc_limit_percent4
     , history_table.pt_ipc_property_usage_type4
     , history_table.pt_ipc_comparison_operator_type4
     , history_table.pt_ipc_cltv_ratio_percent4
     , history_table.pt_buydown_base_date_type
     , history_table.pt_buydown_subsidy_calculation_type
     , history_table.pt_prepaid_interest_rate_type
     , history_table.pt_fnm_arm_plan_type
     , history_table.pt_dsi_plan_code
     , history_table.pt_credit_qualifying
     , history_table.pt_product_special_program_type
     , history_table.pt_section_of_act_coarse_type
     , history_table.pt_fha_rehab_program_type
     , history_table.pt_fha_special_program_type
     , history_table.pt_third_party_grant_eligible
     , history_table.pt_servicing_transfer_type
     , history_table.pt_no_mi_product
     , history_table.pt_mortgage_credit_certificate_eligible
     , history_table.pt_fre_community_program_type
     , history_table.pt_fnm_community_lending_product_type
     , history_table.pt_zero_note_rate
     , history_table.pt_third_party_community_second_program_eligibility_type
     , history_table.pt_texas_veterans_land_board
     , history_table.pt_security_instrument_page_count
     , history_table.pt_deed_page_count
     , history_table.pt_partial_payment_policy_type
     , history_table.pt_payment_structure_type
     , history_table.pt_deferred_payment_months
     , history_table.pt_always_current_market_price
     , history_table.pt_rate_protect
     , history_table.pt_non_conforming
     , history_table.pt_allow_loan_amount_cents
     , history_table.pt_product_appraisal_requirement_type
     , history_table.pt_family_advantage
     , history_table.pt_community_lending_type
     , history_table.pt_high_balance
     , history_table.pt_decision_credit_score_calc_type
     , history_table.pt_new_york
     , history_table.pt_maximum_number_of_construction_draws
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.product_terms history_table
LEFT JOIN staging_octane.product_terms staging_table
          ON staging_table.pt_pid = history_table.pt_pid
WHERE staging_table.pt_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.product_terms deleted_records
                  WHERE deleted_records.pt_pid = history_table.pt_pid AND deleted_records.data_source_deleted_flag = TRUE )
')
;

-- Update table_input_step sql for all new columns
UPDATE mdi.table_input_step
SET sql = temp_new_column_mdi_data.input_sql
FROM temp_new_column_mdi_data
JOIN mdi.process
     ON process.name = temp_new_column_mdi_data.process_name
WHERE table_input_step.process_dwid = process.dwid;

-- Insert table_output_field rows for all new columns
INSERT
INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
SELECT table_output_step.dwid
     , temp_new_column_field_data.field_name
     , temp_new_column_field_data.field_name
     , temp_new_column_field_data.field_order
     , FALSE
FROM temp_new_column_field_data
JOIN mdi.table_output_step
     ON temp_new_column_field_data.table_name = table_output_step.target_table
         AND table_output_step.target_schema = 'history_octane';

--
-- REMOVE EDW_*_DEFINITION AND MDI CONFIG DATA FOR DELETED COLUMN: staging_octane.proposal.prp_fre_ctp_closing_type
--
--   note: field is removed from proposal's table_input_step above in the same
--         update that adds the new proposal column
--

-- nullify source_edw_field_definition_dwid pointing to deleted field
UPDATE mdi.edw_field_definition
SET source_edw_field_definition_dwid = NULL
FROM mdi.edw_table_definition
WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = 'prp_fre_ctp_closing_type'
  AND edw_table_definition.schema_name = 'history_octane';

-- delete field from edw_field_definition
DELETE
FROM mdi.edw_field_definition
    USING mdi.edw_table_definition
WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = 'prp_fre_ctp_closing_type'
  AND edw_table_definition.schema_name = 'staging_octane';

-- delete join definitions relying on the deleted field from edw_join_definition
DELETE
FROM mdi.edw_join_definition
WHERE join_condition LIKE '%prp_fre_ctp_closing_type%';

-- delete field from table_output_field
DELETE
FROM mdi.table_output_field
WHERE table_output_field.database_field_name = 'prp_fre_ctp_closing_type';

--
-- REMOVE EDW_*_DEFINITION DATA FOR DELETED TABLE: staging_octane.fre_ctp_closing_type
--

-- nullify primary_source_edw_table_definition_dwid pointing to deleted table
UPDATE mdi.edw_table_definition
SET primary_source_edw_table_definition_dwid = NULL
WHERE edw_table_definition.table_name = 'fre_ctp_closing_type'
  AND edw_table_definition.schema_name = 'history_octane';

-- nullify source_edw_field_definition_dwids pointing to deleted table's fields
UPDATE mdi.edw_field_definition
SET source_edw_field_definition_dwid = NULL
FROM mdi.edw_table_definition
WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_table_definition.table_name = 'fre_ctp_closing_type'
  AND edw_table_definition.schema_name = 'history_octane';

-- delete table's fields from edw_field_definition
DELETE
FROM mdi.edw_field_definition
    USING mdi.edw_table_definition
WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_table_definition.table_name = 'fre_ctp_closing_type'
  AND edw_table_definition.schema_name = 'staging_octane';

-- delete table's row in edw_table_definition
DELETE
FROM mdi.edw_table_definition
WHERE edw_table_definition.table_name = 'fre_ctp_closing_type'
  AND edw_table_definition.schema_name = 'staging_octane';

--
-- REMOVE STAGING -> HISTORY MDI CONFIG DATA FOR DELETED TABLE: staging_octane.fre_ctp_closing_type
--

-- delete table's json_output_field
DELETE
FROM mdi.json_output_field
    USING mdi.process
WHERE json_output_field.process_dwid = process.dwid
  AND process.name = 'SP-100520';

-- delete table's state_machine_step
DELETE
FROM mdi.state_machine_step
    USING mdi.process
WHERE state_machine_step.process_dwid = process.dwid
  AND process.name = 'SP-100520';

-- delete table's state_machine_definition
DELETE
FROM mdi.state_machine_definition
    USING mdi.process
WHERE state_machine_definition.process_dwid = process.dwid
  AND process.name = 'SP-100520';

-- delete table's table_output_fields
DELETE
FROM mdi.table_output_field
    USING mdi.table_output_step, mdi.process
WHERE table_output_field.table_output_step_dwid = table_output_step.dwid
  AND process.dwid = table_output_step.process_dwid
  AND process.name = 'SP-100520';

-- delete table's table_output_step
DELETE
FROM mdi.table_output_step
    USING mdi.process
WHERE process.dwid = table_output_step.process_dwid
  AND process.name = 'SP-100520';

-- delete table's table_input_step
DELETE
FROM mdi.table_input_step
    USING mdi.process
WHERE process.dwid = table_input_step.process_dwid
  AND process.name = 'SP-100520';

-- delete table's process
DELETE
FROM mdi.process
WHERE process.name = 'SP-100520';
