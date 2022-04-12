--
-- Main | EDW | Octane schema synchronization for v2022.4.2.2 (2022-04-12)
-- https://app.asana.com/0/0/1202118188346928
--

/*
INSERTIONS
*/

--edw_field_definition
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'staging_octane', 'borrower', 'b_oldest_credit_report_received_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal', 'd_ecoa_application_complete_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal', 'd_ecoa_application_received_date', 'DATE', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'borrower', 'b_oldest_credit_report_received_date', 'DATE', 'staging', 'staging_octane', 'borrower', 'b_oldest_credit_report_received_date')
         , ('staging', 'history_octane', 'deal', 'd_ecoa_application_complete_date', 'DATE', 'staging', 'staging_octane', 'deal', 'd_ecoa_application_complete_date')
         , ('staging', 'history_octane', 'deal', 'd_ecoa_application_received_date', 'DATE', 'staging', 'staging_octane', 'deal', 'd_ecoa_application_received_date')
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
    VALUES ('ETL-100308', 'b_oldest_credit_report_received_date')
         , ('ETL-100267', 'd_ecoa_application_complete_date')
         , ('ETL-100267', 'd_ecoa_application_received_date')
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
    VALUES ('ETL-100308', 0, '--finding records to insert into history_octane.borrower
SELECT staging_table.b_pid
     , staging_table.b_version
     , staging_table.b_alimony_child_support
     , staging_table.b_alimony_child_support_explanation
     , staging_table.b_application_pid
     , staging_table.b_application_signed_date
     , staging_table.b_application_taken_method_type
     , staging_table.b_bankruptcy
     , staging_table.b_bankruptcy_explanation
     , staging_table.b_birth_date
     , staging_table.b_borrowed_down_payment
     , staging_table.b_borrowed_down_payment_explanation
     , staging_table.b_applicant_role_type
     , staging_table.b_required_to_sign
     , staging_table.b_spousal_homestead
     , staging_table.b_has_no_ssn
     , staging_table.b_citizenship_residency_type
     , staging_table.b_credit_request_pid
     , staging_table.b_credit_report_identifier
     , staging_table.b_credit_report_authorization
     , staging_table.b_has_dependents
     , staging_table.b_dependent_count
     , staging_table.b_dependents_age_years
     , staging_table.b_email
     , staging_table.b_fax
     , staging_table.b_first_name
     , staging_table.b_nickname
     , staging_table.b_first_time_homebuyer
     , staging_table.b_lender_employee
     , staging_table.b_lender_employee_status_confirmed
     , staging_table.b_sex_refused
     , staging_table.b_sex_collected_visual_or_surname
     , staging_table.b_sex_male
     , staging_table.b_sex_female
     , staging_table.b_sex_not_obtainable
     , staging_table.b_ethnicity_refused
     , staging_table.b_ethnicity_collected_visual_or_surname
     , staging_table.b_ethnicity_hispanic_or_latino
     , staging_table.b_ethnicity_mexican
     , staging_table.b_ethnicity_puerto_rican
     , staging_table.b_ethnicity_cuban
     , staging_table.b_ethnicity_other_hispanic_or_latino
     , staging_table.b_ethnicity_other_hispanic_or_latino_description
     , staging_table.b_ethnicity_not_hispanic_or_latino
     , staging_table.b_ethnicity_not_obtainable
     , staging_table.b_homeowner_past_three_years
     , staging_table.b_home_phone
     , staging_table.b_intend_to_occupy
     , staging_table.b_last_name
     , staging_table.b_mailing_place_pid
     , staging_table.b_marital_status_type
     , staging_table.b_spouse_borrower_pid
     , staging_table.b_middle_name
     , staging_table.b_mobile_phone
     , staging_table.b_name_suffix
     , staging_table.b_note_endorser
     , staging_table.b_note_endorser_explanation
     , staging_table.b_obligated_loan_foreclosure
     , staging_table.b_obligated_loan_foreclosure_explanation
     , staging_table.b_office_phone
     , staging_table.b_office_phone_extension
     , staging_table.b_other_race_national_origin_description
     , staging_table.b_outstanding_judgements
     , staging_table.b_outstanding_judgments_explanation
     , staging_table.b_party_to_lawsuit
     , staging_table.b_party_to_lawsuit_explanation
     , staging_table.b_power_of_attorney
     , staging_table.b_power_of_attorney_signing_capacity
     , staging_table.b_power_of_attorney_first_name
     , staging_table.b_power_of_attorney_last_name
     , staging_table.b_power_of_attorney_middle_name
     , staging_table.b_power_of_attorney_name_suffix
     , staging_table.b_power_of_attorney_company_name
     , staging_table.b_power_of_attorney_title
     , staging_table.b_power_of_attorney_office_phone
     , staging_table.b_power_of_attorney_office_phone_extension
     , staging_table.b_power_of_attorney_mobile_phone
     , staging_table.b_power_of_attorney_email
     , staging_table.b_power_of_attorney_fax
     , staging_table.b_power_of_attorney_city
     , staging_table.b_power_of_attorney_country
     , staging_table.b_power_of_attorney_postal_code
     , staging_table.b_power_of_attorney_state
     , staging_table.b_power_of_attorney_street1
     , staging_table.b_power_of_attorney_street2
     , staging_table.b_presently_delinquent
     , staging_table.b_presently_delinquent_explanation
     , staging_table.b_prior_property_title_type
     , staging_table.b_prior_property_usage_type
     , staging_table.b_property_foreclosure
     , staging_table.b_property_foreclosure_explanation
     , staging_table.b_race_refused
     , staging_table.b_race_collected_visual_or_surname
     , staging_table.b_race_american_indian_or_alaska_native
     , staging_table.b_race_other_american_indian_or_alaska_native_description
     , staging_table.b_race_asian
     , staging_table.b_race_asian_indian
     , staging_table.b_race_chinese
     , staging_table.b_race_filipino
     , staging_table.b_race_japanese
     , staging_table.b_race_korean
     , staging_table.b_race_vietnamese
     , staging_table.b_race_other_asian
     , staging_table.b_race_other_asian_description
     , staging_table.b_race_black_or_african_american
     , staging_table.b_race_information_not_provided
     , staging_table.b_race_national_origin_refusal
     , staging_table.b_race_native_hawaiian_or_other_pacific_islander
     , staging_table.b_race_native_hawaiian
     , staging_table.b_race_guamanian_or_chamorro
     , staging_table.b_race_samoan
     , staging_table.b_race_other_pacific_islander
     , staging_table.b_race_not_obtainable
     , staging_table.b_race_other_pacific_islander_description
     , staging_table.b_race_not_applicable
     , staging_table.b_race_white
     , staging_table.b_schooling_years
     , staging_table.b_titleholder
     , staging_table.b_experian_credit_score
     , staging_table.b_equifax_credit_score
     , staging_table.b_trans_union_credit_score
     , staging_table.b_decision_credit_score
     , staging_table.b_borrower_tiny_id_type
     , staging_table.b_first_time_home_buyer_explain
     , staging_table.b_first_time_home_buyer_auto_compute
     , staging_table.b_caivrs_id
     , staging_table.b_caivrs_messages
     , staging_table.b_on_ldp_list
     , staging_table.b_on_gsa_list
     , staging_table.b_monthly_job_federal_tax_amount
     , staging_table.b_monthly_job_state_tax_amount
     , staging_table.b_monthly_job_retirement_tax_amount
     , staging_table.b_monthly_job_medicare_tax_amount
     , staging_table.b_monthly_job_state_disability_insurance_amount
     , staging_table.b_monthly_job_other_tax_1_amount
     , staging_table.b_monthly_job_other_tax_1_description
     , staging_table.b_monthly_job_other_tax_2_amount
     , staging_table.b_monthly_job_other_tax_2_description
     , staging_table.b_monthly_job_other_tax_3_amount
     , staging_table.b_monthly_job_other_tax_3_description
     , staging_table.b_monthly_job_total_tax_amount
     , staging_table.b_homeownership_education_type
     , staging_table.b_homeownership_education_agency_type
     , staging_table.b_homeownership_education_id
     , staging_table.b_homeownership_education_name
     , staging_table.b_homeownership_education_complete_date
     , staging_table.b_housing_counseling_type
     , staging_table.b_housing_counseling_agency_type
     , staging_table.b_housing_counseling_id
     , staging_table.b_housing_counseling_name
     , staging_table.b_housing_counseling_complete_date
     , staging_table.b_legal_entity_type
     , staging_table.b_credit_report_authorization_datetime
     , staging_table.b_credit_report_authorization_method
     , staging_table.b_credit_report_authorization_obtained_by_unparsed_name
     , staging_table.b_disabled
     , staging_table.b_usda_annual_child_care_expenses
     , staging_table.b_usda_disability_expenses
     , staging_table.b_usda_medical_expenses
     , staging_table.b_usda_income_from_assets
     , staging_table.b_usda_moderate_income_limit
     , staging_table.b_hud_employee
     , staging_table.b_relationship_to_primary_borrower_type
     , staging_table.b_relationship_to_seller_type
     , staging_table.b_preferred_first_name
     , staging_table.b_domestic_relationship_state_type
     , staging_table.b_credit_report_required
     , staging_table.b_closing_disclosure_signer
     , staging_table.b_snapshotted_pid
     , staging_table.b_mobile_phone_na
     , staging_table.b_oldest_credit_report_received_date
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.borrower staging_table
LEFT JOIN history_octane.borrower history_table
          ON staging_table.b_pid = history_table.b_pid
              AND staging_table.b_version = history_table.b_version
WHERE history_table.b_pid IS NULL
UNION ALL
SELECT history_table.b_pid
     , history_table.b_version + 1
     , history_table.b_alimony_child_support
     , history_table.b_alimony_child_support_explanation
     , history_table.b_application_pid
     , history_table.b_application_signed_date
     , history_table.b_application_taken_method_type
     , history_table.b_bankruptcy
     , history_table.b_bankruptcy_explanation
     , history_table.b_birth_date
     , history_table.b_borrowed_down_payment
     , history_table.b_borrowed_down_payment_explanation
     , history_table.b_applicant_role_type
     , history_table.b_required_to_sign
     , history_table.b_spousal_homestead
     , history_table.b_has_no_ssn
     , history_table.b_citizenship_residency_type
     , history_table.b_credit_request_pid
     , history_table.b_credit_report_identifier
     , history_table.b_credit_report_authorization
     , history_table.b_has_dependents
     , history_table.b_dependent_count
     , history_table.b_dependents_age_years
     , history_table.b_email
     , history_table.b_fax
     , history_table.b_first_name
     , history_table.b_nickname
     , history_table.b_first_time_homebuyer
     , history_table.b_lender_employee
     , history_table.b_lender_employee_status_confirmed
     , history_table.b_sex_refused
     , history_table.b_sex_collected_visual_or_surname
     , history_table.b_sex_male
     , history_table.b_sex_female
     , history_table.b_sex_not_obtainable
     , history_table.b_ethnicity_refused
     , history_table.b_ethnicity_collected_visual_or_surname
     , history_table.b_ethnicity_hispanic_or_latino
     , history_table.b_ethnicity_mexican
     , history_table.b_ethnicity_puerto_rican
     , history_table.b_ethnicity_cuban
     , history_table.b_ethnicity_other_hispanic_or_latino
     , history_table.b_ethnicity_other_hispanic_or_latino_description
     , history_table.b_ethnicity_not_hispanic_or_latino
     , history_table.b_ethnicity_not_obtainable
     , history_table.b_homeowner_past_three_years
     , history_table.b_home_phone
     , history_table.b_intend_to_occupy
     , history_table.b_last_name
     , history_table.b_mailing_place_pid
     , history_table.b_marital_status_type
     , history_table.b_spouse_borrower_pid
     , history_table.b_middle_name
     , history_table.b_mobile_phone
     , history_table.b_name_suffix
     , history_table.b_note_endorser
     , history_table.b_note_endorser_explanation
     , history_table.b_obligated_loan_foreclosure
     , history_table.b_obligated_loan_foreclosure_explanation
     , history_table.b_office_phone
     , history_table.b_office_phone_extension
     , history_table.b_other_race_national_origin_description
     , history_table.b_outstanding_judgements
     , history_table.b_outstanding_judgments_explanation
     , history_table.b_party_to_lawsuit
     , history_table.b_party_to_lawsuit_explanation
     , history_table.b_power_of_attorney
     , history_table.b_power_of_attorney_signing_capacity
     , history_table.b_power_of_attorney_first_name
     , history_table.b_power_of_attorney_last_name
     , history_table.b_power_of_attorney_middle_name
     , history_table.b_power_of_attorney_name_suffix
     , history_table.b_power_of_attorney_company_name
     , history_table.b_power_of_attorney_title
     , history_table.b_power_of_attorney_office_phone
     , history_table.b_power_of_attorney_office_phone_extension
     , history_table.b_power_of_attorney_mobile_phone
     , history_table.b_power_of_attorney_email
     , history_table.b_power_of_attorney_fax
     , history_table.b_power_of_attorney_city
     , history_table.b_power_of_attorney_country
     , history_table.b_power_of_attorney_postal_code
     , history_table.b_power_of_attorney_state
     , history_table.b_power_of_attorney_street1
     , history_table.b_power_of_attorney_street2
     , history_table.b_presently_delinquent
     , history_table.b_presently_delinquent_explanation
     , history_table.b_prior_property_title_type
     , history_table.b_prior_property_usage_type
     , history_table.b_property_foreclosure
     , history_table.b_property_foreclosure_explanation
     , history_table.b_race_refused
     , history_table.b_race_collected_visual_or_surname
     , history_table.b_race_american_indian_or_alaska_native
     , history_table.b_race_other_american_indian_or_alaska_native_description
     , history_table.b_race_asian
     , history_table.b_race_asian_indian
     , history_table.b_race_chinese
     , history_table.b_race_filipino
     , history_table.b_race_japanese
     , history_table.b_race_korean
     , history_table.b_race_vietnamese
     , history_table.b_race_other_asian
     , history_table.b_race_other_asian_description
     , history_table.b_race_black_or_african_american
     , history_table.b_race_information_not_provided
     , history_table.b_race_national_origin_refusal
     , history_table.b_race_native_hawaiian_or_other_pacific_islander
     , history_table.b_race_native_hawaiian
     , history_table.b_race_guamanian_or_chamorro
     , history_table.b_race_samoan
     , history_table.b_race_other_pacific_islander
     , history_table.b_race_not_obtainable
     , history_table.b_race_other_pacific_islander_description
     , history_table.b_race_not_applicable
     , history_table.b_race_white
     , history_table.b_schooling_years
     , history_table.b_titleholder
     , history_table.b_experian_credit_score
     , history_table.b_equifax_credit_score
     , history_table.b_trans_union_credit_score
     , history_table.b_decision_credit_score
     , history_table.b_borrower_tiny_id_type
     , history_table.b_first_time_home_buyer_explain
     , history_table.b_first_time_home_buyer_auto_compute
     , history_table.b_caivrs_id
     , history_table.b_caivrs_messages
     , history_table.b_on_ldp_list
     , history_table.b_on_gsa_list
     , history_table.b_monthly_job_federal_tax_amount
     , history_table.b_monthly_job_state_tax_amount
     , history_table.b_monthly_job_retirement_tax_amount
     , history_table.b_monthly_job_medicare_tax_amount
     , history_table.b_monthly_job_state_disability_insurance_amount
     , history_table.b_monthly_job_other_tax_1_amount
     , history_table.b_monthly_job_other_tax_1_description
     , history_table.b_monthly_job_other_tax_2_amount
     , history_table.b_monthly_job_other_tax_2_description
     , history_table.b_monthly_job_other_tax_3_amount
     , history_table.b_monthly_job_other_tax_3_description
     , history_table.b_monthly_job_total_tax_amount
     , history_table.b_homeownership_education_type
     , history_table.b_homeownership_education_agency_type
     , history_table.b_homeownership_education_id
     , history_table.b_homeownership_education_name
     , history_table.b_homeownership_education_complete_date
     , history_table.b_housing_counseling_type
     , history_table.b_housing_counseling_agency_type
     , history_table.b_housing_counseling_id
     , history_table.b_housing_counseling_name
     , history_table.b_housing_counseling_complete_date
     , history_table.b_legal_entity_type
     , history_table.b_credit_report_authorization_datetime
     , history_table.b_credit_report_authorization_method
     , history_table.b_credit_report_authorization_obtained_by_unparsed_name
     , history_table.b_disabled
     , history_table.b_usda_annual_child_care_expenses
     , history_table.b_usda_disability_expenses
     , history_table.b_usda_medical_expenses
     , history_table.b_usda_income_from_assets
     , history_table.b_usda_moderate_income_limit
     , history_table.b_hud_employee
     , history_table.b_relationship_to_primary_borrower_type
     , history_table.b_relationship_to_seller_type
     , history_table.b_preferred_first_name
     , history_table.b_domestic_relationship_state_type
     , history_table.b_credit_report_required
     , history_table.b_closing_disclosure_signer
     , history_table.b_snapshotted_pid
     , history_table.b_mobile_phone_na
     , history_table.b_oldest_credit_report_received_date
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM (
    SELECT current_records.*
    FROM history_octane.borrower AS current_records
    LEFT JOIN history_octane.borrower AS history_records
              ON current_records.b_pid = history_records.b_pid
                  AND current_records.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.data_source_updated_datetime IS NULL
      AND current_records.data_source_deleted_flag = FALSE
) AS history_table
LEFT JOIN staging_octane.borrower staging_table
          ON staging_table.b_pid = history_table.b_pid
WHERE staging_table.b_pid IS NULL;', 'Staging DB Connection')
         , ('ETL-100267', 0, '--finding records to insert into history_octane.deal
SELECT staging_table.d_pid
     , staging_table.d_version
     , staging_table.d_account_pid
     , staging_table.d_company_pid
     , staging_table.d_active_proposal_pid
     , staging_table.d_branch_pid
     , staging_table.d_deal_create_date
     , staging_table.d_deal_status_type
     , staging_table.d_velocify_lead_id
     , staging_table.d_lead_zillow_zq
     , staging_table.d_lead_tracking_id
     , staging_table.d_lead_reference_id
     , staging_table.d_los_loan_id_main
     , staging_table.d_los_loan_id_piggyback
     , staging_table.d_mers_min_main
     , staging_table.d_mers_min_piggyback
     , staging_table.d_external_loan_id_main
     , staging_table.d_external_loan_id_piggyback
     , staging_table.d_lead_source_pid
     , staging_table.d_trid_application_date
     , staging_table.d_deal_status_date
     , staging_table.d_sap_deal
     , staging_table.d_hmda_action_date
     , staging_table.d_hmda_action_type
     , staging_table.d_hmda_denial_reason_type_1
     , staging_table.d_hmda_denial_reason_type_2
     , staging_table.d_hmda_denial_reason_type_3
     , staging_table.d_hmda_denial_reason_type_4
     , staging_table.d_borrower_esign
     , staging_table.d_application_type
     , staging_table.d_welcome_call_datetime
     , staging_table.d_realty_agent_scenario_type
     , staging_table.d_test_loan
     , staging_table.d_charges_enabled_date
     , staging_table.d_credit_bureau_type
     , staging_table.d_performer_team_pid
     , staging_table.d_deal_create_type
     , staging_table.d_hmda_denial_reason_other_description
     , staging_table.d_effective_hmda_action_date
     , staging_table.d_copy_source_los_loan_id_main
     , staging_table.d_copy_source_los_loan_id_piggyback
     , staging_table.d_referred_by_name
     , staging_table.d_hmda_universal_loan_id_main
     , staging_table.d_hmda_universal_loan_id_piggyback
     , staging_table.d_calyx_loan_guid
     , staging_table.d_invoices_enabled_date
     , staging_table.d_invoices_enabled
     , staging_table.d_training_loan
     , staging_table.d_deal_orphan_status_type
     , staging_table.d_deal_orphan_earliest_check_date
     , staging_table.d_deal_create_date_time
     , staging_table.d_early_wire_request
     , staging_table.d_enable_electronic_transaction
     , staging_table.d_initial_cancel_status_date
     , staging_table.d_location_pid
     , staging_table.d_ecoa_application_complete_date
     , staging_table.d_ecoa_decision_due_date
     , staging_table.d_ecoa_notice_of_incomplete_date
     , staging_table.d_ecoa_notice_of_incomplete_due_date
     , staging_table.d_ecoa_application_received_date
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.deal staging_table
LEFT JOIN history_octane.deal history_table
          ON staging_table.d_pid = history_table.d_pid
              AND staging_table.d_version = history_table.d_version
WHERE history_table.d_pid IS NULL
UNION ALL
SELECT history_table.d_pid
     , history_table.d_version + 1
     , history_table.d_account_pid
     , history_table.d_company_pid
     , history_table.d_active_proposal_pid
     , history_table.d_branch_pid
     , history_table.d_deal_create_date
     , history_table.d_deal_status_type
     , history_table.d_velocify_lead_id
     , history_table.d_lead_zillow_zq
     , history_table.d_lead_tracking_id
     , history_table.d_lead_reference_id
     , history_table.d_los_loan_id_main
     , history_table.d_los_loan_id_piggyback
     , history_table.d_mers_min_main
     , history_table.d_mers_min_piggyback
     , history_table.d_external_loan_id_main
     , history_table.d_external_loan_id_piggyback
     , history_table.d_lead_source_pid
     , history_table.d_trid_application_date
     , history_table.d_deal_status_date
     , history_table.d_sap_deal
     , history_table.d_hmda_action_date
     , history_table.d_hmda_action_type
     , history_table.d_hmda_denial_reason_type_1
     , history_table.d_hmda_denial_reason_type_2
     , history_table.d_hmda_denial_reason_type_3
     , history_table.d_hmda_denial_reason_type_4
     , history_table.d_borrower_esign
     , history_table.d_application_type
     , history_table.d_welcome_call_datetime
     , history_table.d_realty_agent_scenario_type
     , history_table.d_test_loan
     , history_table.d_charges_enabled_date
     , history_table.d_credit_bureau_type
     , history_table.d_performer_team_pid
     , history_table.d_deal_create_type
     , history_table.d_hmda_denial_reason_other_description
     , history_table.d_effective_hmda_action_date
     , history_table.d_copy_source_los_loan_id_main
     , history_table.d_copy_source_los_loan_id_piggyback
     , history_table.d_referred_by_name
     , history_table.d_hmda_universal_loan_id_main
     , history_table.d_hmda_universal_loan_id_piggyback
     , history_table.d_calyx_loan_guid
     , history_table.d_invoices_enabled_date
     , history_table.d_invoices_enabled
     , history_table.d_training_loan
     , history_table.d_deal_orphan_status_type
     , history_table.d_deal_orphan_earliest_check_date
     , history_table.d_deal_create_date_time
     , history_table.d_early_wire_request
     , history_table.d_enable_electronic_transaction
     , history_table.d_initial_cancel_status_date
     , history_table.d_location_pid
     , history_table.d_ecoa_application_complete_date
     , history_table.d_ecoa_decision_due_date
     , history_table.d_ecoa_notice_of_incomplete_date
     , history_table.d_ecoa_notice_of_incomplete_due_date
     , history_table.d_ecoa_application_received_date
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM (
    SELECT current_records.*
    FROM history_octane.deal AS current_records
    LEFT JOIN history_octane.deal AS history_records
              ON current_records.d_pid = history_records.d_pid
                  AND current_records.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.data_source_updated_datetime IS NULL
      AND current_records.data_source_deleted_flag = FALSE
) AS history_table
LEFT JOIN staging_octane.deal staging_table
          ON staging_table.d_pid = history_table.d_pid
WHERE staging_table.d_pid IS NULL;', 'Staging DB Connection')
)
UPDATE mdi.table_input_step
SET data_source_dwid = update_rows.data_source_dwid
  , sql = update_rows.sql
  , connectionname = update_rows.connectionname::mdi.pentaho_db_connection_name
FROM update_rows
JOIN mdi.process
     ON process.name = update_rows.process_name
WHERE process.dwid = table_input_step.process_dwid;

/*
DELETIONS
*/

--table_output_field
WITH delete_keys (process_name, database_field_name) AS (
    VALUES ('ETL-100267', 'd_ecoa_application_date')
)
DELETE
FROM mdi.table_output_field
    USING delete_keys, mdi.process, mdi.table_output_step
WHERE delete_keys.process_name = process.name
  AND process.dwid = table_output_step.process_dwid
  AND table_output_step.dwid = table_output_field.table_output_step_dwid
  AND delete_keys.database_field_name = table_output_field.database_field_name;

--edw_field_definition
WITH delete_keys (database_name, schema_name, table_name, field_name) AS (
    VALUES ('staging', 'history_octane', 'deal', 'd_ecoa_application_date')
)
DELETE
FROM mdi.edw_field_definition
    USING delete_keys, mdi.edw_table_definition
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name
  AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = delete_keys.field_name;

WITH delete_keys (database_name, schema_name, table_name, field_name) AS (
    VALUES ('staging', 'staging_octane', 'deal', 'd_ecoa_application_date')
)
DELETE
FROM mdi.edw_field_definition
    USING delete_keys, mdi.edw_table_definition
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name
  AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = delete_keys.field_name;
