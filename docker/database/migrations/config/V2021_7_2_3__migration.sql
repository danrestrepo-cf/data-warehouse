--
-- EDW - Octane schemas from prod-release to uat (2021-07-23)
-- https://app.asana.com/0/0/1200643028011805/
--

WITH new_column (table_name, field_name, key_field_flag, field_order) AS (
    VALUES ('borrower', 'b_closing_disclosure_signer', FALSE, 169)
    )

, insert_staging_field_definition AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT edw_table_definition.dwid, new_column.field_name, new_column.key_field_flag
        FROM new_column
            JOIN mdi.edw_table_definition ON new_column.table_name = edw_table_definition.table_name
                AND edw_table_definition.schema_name = 'staging_octane'
        RETURNING dwid, field_name
)

, insert_history_field_definition AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid,field_name, key_field_flag,
                                          source_edw_field_definition_dwid)
        SELECT edw_table_definition.dwid, new_column.field_name, new_column.key_field_flag,
               insert_staging_field_definition.dwid
        FROM new_column
            JOIN mdi.edw_table_definition ON new_column.table_name = edw_table_definition.table_name
                AND edw_table_definition.schema_name = 'history_octane'
            LEFT JOIN insert_staging_field_definition ON new_column.field_name = insert_staging_field_definition.field_name
)

, update_table_input_step AS (
    UPDATE mdi.table_input_step
        SET sql = '--finding records to insert into history_octane.borrower
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
, FALSE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM staging_octane.borrower staging_table
         LEFT JOIN history_octane.borrower history_table
                   ON staging_table.b_pid = history_table.b_pid AND staging_table.b_version = history_table.b_version
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
, TRUE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM history_octane.borrower history_table
         LEFT JOIN staging_octane.borrower staging_table
                   ON staging_table.b_pid = history_table.b_pid
WHERE staging_table.b_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.borrower deleted_records
                  WHERE deleted_records.b_pid = history_table.b_pid AND deleted_records.data_source_deleted_flag = TRUE );'
        WHERE dwid = (SELECT table_input_step.dwid
                        FROM mdi.process
                            JOIN mdi.table_input_step ON process.dwid = table_input_step.process_dwid
                            JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
                                AND table_output_step.target_schema = 'history_octane'
                                AND table_output_step.target_table = 'borrower')
)

, insert_table_output_field AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid
        , database_field_name
        , database_stream_name
        , field_order
        , is_sensitive)
        SELECT table_output_step.dwid
            , new_column.field_name
            , new_column.field_name
            , new_column.field_order
            , FALSE
        FROM new_column
            JOIN mdi.table_output_step ON new_column.table_name = table_output_step.target_table
                AND table_output_step.target_schema = 'history_octane'
)

SELECT 'Finished loading new Octane catch up metadata';
