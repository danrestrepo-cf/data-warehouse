--
-- EDW | dimension ETLs - refactor to use batch_id start/end times instead of comparing every field to determine which records to update
-- https://app.asana.com/0/0/1201313036590173
--

WITH updated_dim_sql (table_name, sql) AS (
/*
 application_dim
 */
    VALUES ('application_dim', 'WITH application_dim_incl_new_records AS (
    SELECT ''application_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( primary_table.apl_pid AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , primary_table.data_source_updated_datetime AS data_source_modified_datetime
         , primary_table.apl_pid AS application_pid
         , primary_table.apl_proposal_pid AS proposal_pid
         , GREATEST( primary_table.etl_end_date_time ) AS max_source_etl_end_date_time
    FROM (
        SELECT <<application_partial_load_condition>> AS include_record
             , application.*
             , etl_log.etl_end_date_time
        FROM history_octane.application
        LEFT JOIN history_octane.application AS history_records
                  ON application.apl_pid = history_records.apl_pid
                      AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
        JOIN star_common.etl_log
             ON application.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.apl_pid IS NULL
    ) AS primary_table
    WHERE GREATEST( primary_table.include_record ) IS TRUE
    ORDER BY primary_table.data_source_updated_datetime ASC
)
--new records that should be inserted
SELECT application_dim_incl_new_records.*
FROM application_dim_incl_new_records
LEFT JOIN star_loan.application_dim
          ON application_dim_incl_new_records.data_source_integration_id = application_dim.data_source_integration_id
WHERE application_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT application_dim_incl_new_records.*
FROM application_dim_incl_new_records
JOIN (
    SELECT application_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.application_dim
    JOIN star_common.etl_log
         ON application_dim.etl_batch_id = etl_log.etl_batch_id
) AS application_dim_etl_start_times
     ON application_dim_incl_new_records.data_source_integration_id = application_dim_etl_start_times.data_source_integration_id
         AND application_dim_incl_new_records.max_source_etl_end_date_time >= application_dim_etl_start_times.etl_start_date_time;')
/*
 borrower_dim
 */
         , ('borrower_dim', 'WITH borrower_dim_incl_new_records AS (
    SELECT ''borrower_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( primary_table.b_pid AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , primary_table.data_source_updated_datetime AS data_source_modified_datetime
         , t114.value AS applicant_role
         , t115.value AS application_taken_method
         , primary_table.b_pid AS borrower_pid
         , primary_table.b_alimony_child_support_explanation AS alimony_child_support_explanation
         , primary_table.b_application_taken_method_type AS application_taken_method_code
         , primary_table.b_bankruptcy_explanation AS bankruptcy_explanation
         , primary_table.b_birth_date AS birth_date
         , primary_table.b_borrowed_down_payment_explanation AS borrowed_down_payment_explanation
         , primary_table.b_applicant_role_type AS applicant_role_code
         , primary_table.b_required_to_sign AS required_to_sign_flag
         , primary_table.b_has_no_ssn AS has_no_ssn_flag
         , primary_table.b_credit_report_identifier AS credit_report_identifier
         , primary_table.b_credit_report_authorization AS credit_report_authorization_flag
         , primary_table.b_dependent_count AS dependent_count
         , primary_table.b_dependents_age_years AS dependents_age_years
         , primary_table.b_email AS email
         , primary_table.b_fax AS fax
         , primary_table.b_first_name AS first_name
         , primary_table.b_nickname AS nickname
         , primary_table.b_ethnicity_other_hispanic_or_latino_description AS ethnicity_other_hispanic_or_latino_description
         , primary_table.b_home_phone AS home_phone
         , primary_table.b_last_name AS last_name
         , primary_table.b_middle_name AS middle_name
         , primary_table.b_name_suffix AS name_suffix
         , primary_table.b_note_endorser_explanation AS note_endorser_explanation
         , primary_table.b_obligated_loan_foreclosure_explanation AS obligated_loan_foreclosure_explanation
         , primary_table.b_office_phone AS office_phone
         , primary_table.b_office_phone_extension AS office_phone_extension
         , primary_table.b_other_race_national_origin_description AS other_race_national_origin_description
         , primary_table.b_outstanding_judgments_explanation AS outstanding_judgments_explanation
         , primary_table.b_party_to_lawsuit_explanation AS party_to_lawsuit_explanation
         , primary_table.b_power_of_attorney AS power_of_attorney_code
         , primary_table.b_power_of_attorney_signing_capacity AS power_of_attorney_signing_capacity
         , primary_table.b_power_of_attorney_first_name AS power_of_attorney_first_name
         , primary_table.b_power_of_attorney_last_name AS power_of_attorney_last_name
         , primary_table.b_power_of_attorney_middle_name AS power_of_attorney_middle_name
         , primary_table.b_power_of_attorney_name_suffix AS power_of_attorney_name_suffix
         , primary_table.b_power_of_attorney_company_name AS power_of_attorney_company_name
         , primary_table.b_power_of_attorney_title AS power_of_attorney_title
         , primary_table.b_power_of_attorney_office_phone AS power_of_attorney_office_phone
         , primary_table.b_power_of_attorney_office_phone_extension AS power_of_attorney_office_phone_extension
         , primary_table.b_power_of_attorney_mobile_phone AS power_of_attorney_mobile_phone
         , primary_table.b_power_of_attorney_email AS power_of_attorney_email
         , primary_table.b_power_of_attorney_fax AS power_of_attorney_fax
         , primary_table.b_power_of_attorney_city AS power_of_attorney_city
         , primary_table.b_power_of_attorney_country AS power_of_attorney_country_code
         , primary_table.b_power_of_attorney_postal_code AS power_of_attorney_postal_code
         , primary_table.b_power_of_attorney_state AS power_of_attorney_state
         , primary_table.b_power_of_attorney_street1 AS power_of_attorney_street1
         , primary_table.b_power_of_attorney_street2 AS power_of_attorney_street2
         , primary_table.b_presently_delinquent_explanation AS presently_delinquent_explanation
         , primary_table.b_prior_property_title_type AS prior_property_title_code
         , primary_table.b_prior_property_usage_type AS prior_property_usage_code
         , primary_table.b_property_foreclosure_explanation AS property_foreclosure_explanation
         , primary_table.b_race_other_american_indian_or_alaska_native_description AS race_other_american_indian_or_alaska_native_description
         , primary_table.b_race_other_asian_description AS race_other_asian_description
         , primary_table.b_race_other_pacific_islander_description AS race_other_pacific_islander_description
         , primary_table.b_experian_credit_score AS experian_credit_score
         , primary_table.b_equifax_credit_score AS equifax_credit_score
         , primary_table.b_trans_union_credit_score AS trans_union_credit_score
         , primary_table.b_decision_credit_score AS decision_credit_score
         , primary_table.b_borrower_tiny_id_type AS tiny_id_code
         , primary_table.b_first_time_home_buyer_explain AS first_time_homebuyer_explain
         , primary_table.b_caivrs_id AS caivrs_id
         , primary_table.b_caivrs_messages AS caivrs_messages
         , primary_table.b_monthly_job_federal_tax_amount AS monthly_job_federal_tax_amount
         , primary_table.b_monthly_job_state_tax_amount AS monthly_job_state_tax_amount
         , primary_table.b_monthly_job_retirement_tax_amount AS monthly_job_retirement_tax_amount
         , primary_table.b_monthly_job_medicare_tax_amount AS monthly_job_medicare_tax_amount
         , primary_table.b_monthly_job_state_disability_insurance_amount AS monthly_job_state_disability_insurance_amount
         , primary_table.b_monthly_job_other_tax_1_amount AS monthly_job_other_tax_1_amount
         , primary_table.b_monthly_job_other_tax_1_description AS monthly_job_other_tax_1_description
         , primary_table.b_monthly_job_other_tax_2_amount AS monthly_job_other_tax_2_amount
         , primary_table.b_monthly_job_other_tax_2_description AS monthly_job_other_tax_2_description
         , primary_table.b_monthly_job_other_tax_3_amount AS monthly_job_other_tax_3_amount
         , primary_table.b_monthly_job_other_tax_3_description AS monthly_job_other_tax_3_description
         , primary_table.b_monthly_job_total_tax_amount AS monthly_job_total_tax_amount
         , primary_table.b_homeownership_education_id AS homeownership_education_id
         , primary_table.b_homeownership_education_name AS homeownership_education_name
         , primary_table.b_housing_counseling_type AS housing_counseling_code
         , primary_table.b_housing_counseling_agency_type AS housing_counseling_agency_code
         , primary_table.b_housing_counseling_id AS housing_counseling_id
         , primary_table.b_housing_counseling_name AS housing_counseling_name
         , primary_table.b_housing_counseling_complete_date AS housing_counseling_complete_date
         , primary_table.b_legal_entity_type AS legal_entity_code
         , primary_table.b_credit_report_authorization_datetime AS credit_report_authorization_datetime
         , primary_table.b_credit_report_authorization_method AS credit_report_authorization_method_code
         , primary_table.b_credit_report_authorization_obtained_by_unparsed_name AS credit_report_authorization_obtained_by_unparsed_name
         , primary_table.b_usda_annual_child_care_expenses AS usda_annual_child_care_expenses
         , primary_table.b_usda_disability_expenses AS usda_disability_expenses
         , primary_table.b_usda_medical_expenses AS usda_medical_expenses
         , primary_table.b_usda_income_from_assets AS usda_income_from_assets
         , primary_table.b_usda_moderate_income_limit AS usda_moderate_income_limit
         , primary_table.b_relationship_to_primary_borrower_type AS relationship_to_primary_borrower_code
         , primary_table.b_relationship_to_seller_type AS relationship_to_seller_code
         , primary_table.b_preferred_first_name AS preferred_first_name
         , primary_table.b_application_pid AS application_pid
         , t149.value AS relationship_to_primary_borrower
         , t150.value AS relationship_to_seller
         , t118.value AS tiny_id
         , t142.value AS power_of_attorney_country
         , t120.value AS credit_report_authorization_method
         , t129.value AS housing_counseling_agency
         , t130.value AS housing_counseling
         , t132.value AS legal_entity
         , t144.value AS prior_property_title
         , t145.value AS prior_property_usage
         , t141.value AS power_of_attorney
         , GREATEST( primary_table.etl_end_date_time, t114.etl_end_date_time, t115.etl_end_date_time, t149.etl_end_date_time,
                     t150.etl_end_date_time, t118.etl_end_date_time, t142.etl_end_date_time, t120.etl_end_date_time, t129.etl_end_date_time,
                     t130.etl_end_date_time, t132.etl_end_date_time, t144.etl_end_date_time, t145.etl_end_date_time,
                     t141.etl_end_date_time ) AS max_source_etl_end_date_time
    FROM (
        SELECT <<borrower_partial_load_condition>> AS include_record
             , borrower.*
             , etl_log.etl_end_date_time
        FROM history_octane.borrower
        LEFT JOIN history_octane.borrower AS history_records
                  ON borrower.b_pid = history_records.b_pid
                      AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
        JOIN star_common.etl_log
             ON borrower.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.b_pid IS NULL
    ) AS primary_table
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<applicant_role_type_partial_load_condition>> AS include_record
                 , applicant_role_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.applicant_role_type
            LEFT JOIN history_octane.applicant_role_type AS history_records
                      ON applicant_role_type.code = history_records.code
                          AND applicant_role_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON applicant_role_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t114
               ON primary_table.b_applicant_role_type = t114.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<application_taken_method_type_partial_load_condition>> AS include_record
                 , application_taken_method_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.application_taken_method_type
            LEFT JOIN history_octane.application_taken_method_type AS history_records
                      ON application_taken_method_type.code = history_records.code
                          AND application_taken_method_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON application_taken_method_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t115
               ON primary_table.b_application_taken_method_type = t115.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<borrower_relationship_type_partial_load_condition>> AS include_record
                 , borrower_relationship_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.borrower_relationship_type
            LEFT JOIN history_octane.borrower_relationship_type AS history_records
                      ON borrower_relationship_type.code = history_records.code
                          AND borrower_relationship_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON borrower_relationship_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t149
               ON primary_table.b_relationship_to_primary_borrower_type = t149.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<borrower_relationship_type_partial_load_condition>> AS include_record
                 , borrower_relationship_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.borrower_relationship_type
            LEFT JOIN history_octane.borrower_relationship_type AS history_records
                      ON borrower_relationship_type.code = history_records.code
                          AND borrower_relationship_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON borrower_relationship_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t150
               ON primary_table.b_relationship_to_seller_type = t150.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<borrower_tiny_id_type_partial_load_condition>> AS include_record
                 , borrower_tiny_id_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.borrower_tiny_id_type
            LEFT JOIN history_octane.borrower_tiny_id_type AS history_records
                      ON borrower_tiny_id_type.code = history_records.code
                          AND borrower_tiny_id_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON borrower_tiny_id_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t118
               ON primary_table.b_borrower_tiny_id_type = t118.code
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
    ) AS t142
               ON primary_table.b_power_of_attorney_country = t142.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<credit_authorization_method_type_partial_load_condition>> AS include_record
                 , credit_authorization_method_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.credit_authorization_method_type
            LEFT JOIN history_octane.credit_authorization_method_type AS history_records
                      ON credit_authorization_method_type.code = history_records.code
                          AND credit_authorization_method_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON credit_authorization_method_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t120
               ON primary_table.b_credit_report_authorization_method = t120.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<housing_counseling_agency_type_partial_load_condition>> AS include_record
                 , housing_counseling_agency_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.housing_counseling_agency_type
            LEFT JOIN history_octane.housing_counseling_agency_type AS history_records
                      ON housing_counseling_agency_type.code = history_records.code
                          AND housing_counseling_agency_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON housing_counseling_agency_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t129
               ON primary_table.b_housing_counseling_agency_type = t129.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<housing_counseling_type_partial_load_condition>> AS include_record
                 , housing_counseling_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.housing_counseling_type
            LEFT JOIN history_octane.housing_counseling_type AS history_records
                      ON housing_counseling_type.code = history_records.code
                          AND housing_counseling_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON housing_counseling_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t130
               ON primary_table.b_housing_counseling_type = t130.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<legal_entity_type_partial_load_condition>> AS include_record
                 , legal_entity_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.legal_entity_type
            LEFT JOIN history_octane.legal_entity_type AS history_records
                      ON legal_entity_type.code = history_records.code
                          AND legal_entity_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON legal_entity_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t132
               ON primary_table.b_legal_entity_type = t132.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<prior_property_title_type_partial_load_condition>> AS include_record
                 , prior_property_title_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.prior_property_title_type
            LEFT JOIN history_octane.prior_property_title_type AS history_records
                      ON prior_property_title_type.code = history_records.code
                          AND prior_property_title_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON prior_property_title_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t144
               ON primary_table.b_prior_property_title_type = t144.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<property_usage_type_partial_load_condition>> AS include_record
                 , property_usage_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.property_usage_type
            LEFT JOIN history_octane.property_usage_type AS history_records
                      ON property_usage_type.code = history_records.code
                          AND property_usage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON property_usage_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t145
               ON primary_table.b_prior_property_usage_type = t145.code
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
    ) AS t141
               ON primary_table.b_power_of_attorney = t141.code
    WHERE GREATEST( primary_table.include_record, t114.include_record, t115.include_record, t149.include_record, t150.include_record,
                    t118.include_record, t142.include_record, t120.include_record, t129.include_record, t130.include_record,
                    t132.include_record, t144.include_record, t145.include_record, t141.include_record ) IS TRUE
)
--new records that should be inserted
SELECT borrower_dim_incl_new_records.*
FROM borrower_dim_incl_new_records
LEFT JOIN star_loan.borrower_dim
          ON borrower_dim_incl_new_records.data_source_integration_id = borrower_dim.data_source_integration_id
WHERE borrower_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT borrower_dim_incl_new_records.*
FROM borrower_dim_incl_new_records
JOIN (
    SELECT borrower_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.borrower_dim
    JOIN star_common.etl_log
         ON borrower_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_dim_etl_start_times
     ON borrower_dim_incl_new_records.data_source_integration_id = borrower_dim_etl_start_times.data_source_integration_id
         AND borrower_dim_incl_new_records.max_source_etl_end_date_time >= borrower_dim_etl_start_times.etl_start_date_time;')
/*
 interim_funder_dim
*/
         , ('interim_funder_dim', 'WITH interim_funder_dim_incl_new_records AS (
    SELECT ''interim_funder_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( primary_table.if_pid AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , primary_table.data_source_updated_datetime AS data_source_modified_datetime
         , t309.value AS address_country
         , primary_table.if_pid AS interim_funder_pid
         , primary_table.if_company_name AS name
         , primary_table.if_company_contact_unparsed_name AS contact_unparsed_name
         , primary_table.if_company_address_street1 AS address_street1
         , primary_table.if_company_address_street2 AS address_street2
         , primary_table.if_company_address_city AS address_city
         , primary_table.if_company_address_state AS address_state
         , primary_table.if_company_address_postal_code AS address_postal_code
         , primary_table.if_company_address_country AS address_country_code
         , primary_table.if_company_office_phone AS office_phone
         , primary_table.if_company_office_phone_extension AS office_phone_extension
         , primary_table.if_company_email AS email
         , primary_table.if_company_fax AS fax
         , primary_table.if_company_mers_org_id AS mers_org_id
         , primary_table.if_remarks AS remarks
         , primary_table.if_from_date AS from_date
         , primary_table.if_through_date AS through_date
         , primary_table.if_reimbursement_wire_credit_to_name AS remibursement_wire_credit_to_name
         , primary_table.if_reimbursement_wire_attention_unparsed_name AS reimbursement_wire_attention_unparsed_name
         , primary_table.if_reimbursement_wire_authorized_signer_unparsed_name AS reimbursement_wire_authorized_signer_unparsed_name
         , primary_table.if_return_wire_credit_to_name AS return_wire_credit_to_name
         , primary_table.if_return_wire_authorized_signer_unparsed_name AS return_wire_authorized_signer_unparsed_name
         , primary_table.if_fnm_payee_id AS fnm_payee_id
         , primary_table.if_interim_funder_mers_registration_type AS mers_registration_code
         , primary_table.if_fnm_warehouse_lender_id AS fnm_warehouse_lender_id
         , primary_table.if_fre_warehouse_lender_id AS fre_warehouse_lender_id
         , primary_table.if_funder_id AS id
         , primary_table.if_return_wire_attention_unparsed_name AS return_wire_attention_unparsed_name
         , t310.value AS mers_registration
         , GREATEST( primary_table.etl_end_date_time, t309.etl_end_date_time, t310.etl_end_date_time ) AS max_source_etl_end_date_time
    FROM (
        SELECT <<interim_funder_partial_load_condition>> AS include_record
             , interim_funder.*
             , etl_log.etl_end_date_time
        FROM history_octane.interim_funder
        LEFT JOIN history_octane.interim_funder AS history_records
                  ON interim_funder.if_pid = history_records.if_pid
                      AND interim_funder.data_source_updated_datetime < history_records.data_source_updated_datetime
        JOIN star_common.etl_log
             ON interim_funder.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.if_pid IS NULL
    ) AS primary_table
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
    ) AS t309
               ON primary_table.if_company_address_country = t309.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<interim_funder_mers_registration_type_partial_load_condition>> AS include_record
                 , interim_funder_mers_registration_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.interim_funder_mers_registration_type
            LEFT JOIN history_octane.interim_funder_mers_registration_type AS history_records
                      ON interim_funder_mers_registration_type.code = history_records.code
                          AND
                         interim_funder_mers_registration_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON interim_funder_mers_registration_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t310
               ON primary_table.if_interim_funder_mers_registration_type = t310.code
    WHERE GREATEST( primary_table.include_record, t309.include_record, t310.include_record ) IS TRUE
)
--new records that should be inserted
SELECT interim_funder_dim_incl_new_records.*
FROM interim_funder_dim_incl_new_records
LEFT JOIN star_loan.interim_funder_dim
          ON interim_funder_dim_incl_new_records.data_source_integration_id = interim_funder_dim.data_source_integration_id
WHERE interim_funder_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT interim_funder_dim_incl_new_records.*
FROM interim_funder_dim_incl_new_records
JOIN (
    SELECT interim_funder_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.interim_funder_dim
    JOIN star_common.etl_log
         ON interim_funder_dim.etl_batch_id = etl_log.etl_batch_id
) AS interim_funder_dim_etl_start_times
     ON interim_funder_dim_incl_new_records.data_source_integration_id = interim_funder_dim_etl_start_times.data_source_integration_id
         AND interim_funder_dim_incl_new_records.max_source_etl_end_date_time >= interim_funder_dim_etl_start_times.etl_start_date_time;')
/*
 investor_dim
*/
         , ('investor_dim', 'WITH investor_dim_incl_new_records AS (
    SELECT ''investor_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( primary_table.i_pid AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , primary_table.data_source_updated_datetime AS data_source_modified_datetime
         , t318.value AS beneficiary_country
         , t319.value AS file_delivery_address_country
         , t323.value AS investor_country
         , t326.value AS loss_payee_country
         , t330.value AS servicer_address_country
         , t331.value AS sub_servicer_address_country
         , t332.value AS when_recorded_mail_to_country
         , t320.value AS fnm_investor_remittance
         , t321.value AS fnm_mbs_loan_default_loss_party
         , t322.value AS fnm_mbs_reo_marketing_party
         , t329.value AS secondary_financing_source
         , primary_table.i_investor_country AS investor_country_code
         , primary_table.i_investor_postal_code AS investor_postal_code
         , primary_table.i_investor_state AS investor_state
         , primary_table.i_investor_street1 AS investor_street1
         , primary_table.i_investor_street2 AS investor_street2
         , primary_table.i_secondary_financing_source_type AS secondary_financing_source_code
         , primary_table.i_ein AS ein
         , primary_table.i_loss_payee_state AS loss_payee_state
         , primary_table.i_loss_payee_postal_code AS loss_payee_postal_code
         , primary_table.i_when_recorded_mail_to_country AS when_recorded_mail_to_country_code
         , primary_table.i_when_recorded_mail_to_postal_code AS when_recorded_mail_to_postal_code
         , primary_table.i_when_recorded_mail_to_state AS when_recorded_mail_to_state
         , primary_table.i_when_recorded_mail_to_street1 AS when_recorded_mail_to_street1
         , primary_table.i_when_recorded_mail_to_street2 AS when_recorded_mail_to_street2
         , primary_table.i_servicer_name AS servicer_name
         , primary_table.i_servicer_address_street1 AS servicer_address_street1
         , primary_table.i_servicer_address_street2 AS servicer_address_street2
         , primary_table.i_servicer_address_city AS servicer_address_city
         , primary_table.i_servicer_address_state AS servicer_address_state
         , primary_table.i_servicer_address_postal_code AS servicer_address_postal_code
         , primary_table.i_servicer_address_country AS servicer_address_country_code
         , primary_table.i_sub_servicer_name AS sub_servicer_name
         , primary_table.i_sub_servicer_address_street1 AS sub_servicer_address_street1
         , primary_table.i_sub_servicer_address_street2 AS sub_servicer_address_street2
         , primary_table.i_sub_servicer_address_city AS sub_servicer_address_city
         , primary_table.i_sub_servicer_address_state AS sub_servicer_address_state
         , primary_table.i_sub_servicer_address_postal_code AS sub_servicer_address_postal_code
         , primary_table.i_sub_servicer_address_country AS sub_servicer_address_country_code
         , primary_table.i_sub_servicer_mers_org_id AS sub_servicer_mers_org_id
         , primary_table.i_file_delivery_name AS file_delivery_name
         , primary_table.i_file_delivery_address_street1 AS file_delivery_address_street1
         , primary_table.i_file_delivery_address_street2 AS file_delivery_address_street2
         , primary_table.i_file_delivery_address_city AS file_delivery_address_city
         , primary_table.i_file_delivery_address_state AS file_delivery_address_state
         , primary_table.i_file_delivery_address_postal_code AS file_delivery_address_postal_code
         , primary_table.i_file_delivery_address_country AS file_delivery_address_country_code
         , primary_table.i_initial_beneficiary_candidate AS initial_beneficiary_candidate_flag
         , primary_table.i_initial_servicer_candidate AS initial_servicer_candidate_flag
         , primary_table.i_mers_org_member AS mers_org_member
         , primary_table.i_mers_org_id AS mers_org_id
         , primary_table.i_allonge_transfer_to_name AS allonge_transfer_to_name
         , primary_table.i_lock_expiration_delivery_subtrahend_days AS lock_expiration_delivery_subtrahend_days
         , primary_table.i_loss_payee_country AS loss_payee_country_code
         , primary_table.i_loss_payee_city AS loss_payee_city
         , primary_table.i_loss_payee_name AS loss_payee_name
         , primary_table.i_pid AS investor_pid
         , primary_table.i_investor_id AS investor_id
         , primary_table.i_website_url AS website_url
         , primary_table.i_investor_name AS investor_name
         , primary_table.i_investor_city AS investor_city
         , primary_table.i_when_recorded_mail_to_city AS when_recorded_mail_to_city
         , primary_table.i_maximum_lock_extensions_allowed AS maximum_lock_extensions_allowed
         , primary_table.i_maximum_lock_extension_days_allowed AS maximum_lock_extension_days_allowed
         , primary_table.i_mortech_investor_id AS mortech_investor_id
         , primary_table.i_fnma_servicer_id AS fnma_servicer_id
         , primary_table.i_loan_file_delivery_method_type AS loan_file_delivery_method_code
         , primary_table.i_mbs_investor AS mbs_investor_flag
         , primary_table.i_investor_hmda_purchaser_of_loan_type AS investor_hmda_purchaser_of_loan_code
         , primary_table.i_lock_disable_time AS investor_lock_disable_time
         , primary_table.i_allow_weekend_holiday_locks AS allows_weekend_holiday_locks_flag
         , primary_table.i_nmls_id AS nmls_id
         , primary_table.i_nmls_id_applicable AS nmls_id_applicable
         , primary_table.i_fnm_investor_remittance_type AS fnm_investor_remittance_code
         , primary_table.i_fnm_mbs_investor_remittance_day_of_month AS fnm_mbs_investor_remittance_day_of_month
         , primary_table.i_fnm_mbs_loan_default_loss_party_type AS fnm_mbs_loan_default_loss_party_code
         , primary_table.i_fnm_mbs_reo_marketing_party_type AS fnm_mbs_reo_marketing_party_code
         , primary_table.i_offers_secondary_financing AS offers_secondary_financing_flag
         , primary_table.i_beneficiary_street2 AS beneficiary_street2
         , primary_table.i_beneficiary_street1 AS beneficiary_street1
         , primary_table.i_beneficiary_state AS beneficiary_state
         , primary_table.i_beneficiary_postal_code AS beneficiary_postal_code
         , primary_table.i_beneficiary_country AS beneficiary_country_code
         , primary_table.i_beneficiary_city AS beneficiary_city
         , primary_table.i_loss_payee_street1 AS loss_payee_street1
         , primary_table.i_loss_payee_street2 AS loss_payee_street2
         , primary_table.i_beneficiary_name AS beneficiary_name
         , primary_table.i_loss_payee_assignee_name AS loss_payee_assignee_name
         , primary_table.i_when_recorded_mail_to_name AS when_recorded_mail_to_name
         , t324.value AS investor_hmda_purchaser_of_loan
         , t325.value AS loan_file_delivery_method
         , GREATEST( primary_table.etl_end_date_time, t318.etl_end_date_time, t319.etl_end_date_time, t323.etl_end_date_time,
                     t326.etl_end_date_time, t330.etl_end_date_time, t331.etl_end_date_time, t332.etl_end_date_time, t320.etl_end_date_time,
                     t321.etl_end_date_time, t322.etl_end_date_time, t329.etl_end_date_time, t324.etl_end_date_time,
                     t325.etl_end_date_time ) AS max_source_etl_end_date_time
    FROM (
        SELECT <<investor_partial_load_condition>> AS include_record
             , investor.*
             , etl_log.etl_end_date_time
        FROM history_octane.investor
        LEFT JOIN history_octane.investor AS history_records
                  ON investor.i_pid = history_records.i_pid
                      AND investor.data_source_updated_datetime < history_records.data_source_updated_datetime
        JOIN star_common.etl_log
             ON investor.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.i_pid IS NULL
    ) AS primary_table
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
    ) AS t318
               ON primary_table.i_beneficiary_country = t318.code
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
    ) AS t319
               ON primary_table.i_file_delivery_address_country = t319.code
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
    ) AS t323
               ON primary_table.i_investor_country = t323.code
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
    ) AS t326
               ON primary_table.i_loss_payee_country = t326.code
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
    ) AS t330
               ON primary_table.i_servicer_address_country = t330.code
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
    ) AS t331
               ON primary_table.i_sub_servicer_address_country = t331.code
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
    ) AS t332
               ON primary_table.i_when_recorded_mail_to_country = t332.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<fnm_investor_remittance_type_partial_load_condition>> AS include_record
                 , fnm_investor_remittance_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.fnm_investor_remittance_type
            LEFT JOIN history_octane.fnm_investor_remittance_type AS history_records
                      ON fnm_investor_remittance_type.code = history_records.code
                          AND fnm_investor_remittance_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON fnm_investor_remittance_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t320
               ON primary_table.i_fnm_investor_remittance_type = t320.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<fnm_mbs_loan_default_loss_party_type_partial_load_condition>> AS include_record
                 , fnm_mbs_loan_default_loss_party_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.fnm_mbs_loan_default_loss_party_type
            LEFT JOIN history_octane.fnm_mbs_loan_default_loss_party_type AS history_records
                      ON fnm_mbs_loan_default_loss_party_type.code = history_records.code
                          AND
                         fnm_mbs_loan_default_loss_party_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON fnm_mbs_loan_default_loss_party_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t321
               ON primary_table.i_fnm_mbs_loan_default_loss_party_type = t321.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<fnm_mbs_reo_marketing_party_type_partial_load_condition>> AS include_record
                 , fnm_mbs_reo_marketing_party_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.fnm_mbs_reo_marketing_party_type
            LEFT JOIN history_octane.fnm_mbs_reo_marketing_party_type AS history_records
                      ON fnm_mbs_reo_marketing_party_type.code = history_records.code
                          AND fnm_mbs_reo_marketing_party_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON fnm_mbs_reo_marketing_party_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t322
               ON primary_table.i_fnm_mbs_reo_marketing_party_type = t322.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<gift_funds_type_partial_load_condition>> AS include_record
                 , gift_funds_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.gift_funds_type
            LEFT JOIN history_octane.gift_funds_type AS history_records
                      ON gift_funds_type.code = history_records.code
                          AND gift_funds_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON gift_funds_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t329
               ON primary_table.i_secondary_financing_source_type = t329.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<investor_hmda_purchaser_of_loan_type_partial_load_condition>> AS include_record
                 , investor_hmda_purchaser_of_loan_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.investor_hmda_purchaser_of_loan_type
            LEFT JOIN history_octane.investor_hmda_purchaser_of_loan_type AS history_records
                      ON investor_hmda_purchaser_of_loan_type.code = history_records.code
                          AND
                         investor_hmda_purchaser_of_loan_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON investor_hmda_purchaser_of_loan_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t324
               ON primary_table.i_investor_hmda_purchaser_of_loan_type = t324.code
    LEFT JOIN (
        SELECT *
        FROM (
            SELECT <<loan_file_delivery_method_type_partial_load_condition>> AS include_record
                 , loan_file_delivery_method_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.loan_file_delivery_method_type
            LEFT JOIN history_octane.loan_file_delivery_method_type AS history_records
                      ON loan_file_delivery_method_type.code = history_records.code
                          AND loan_file_delivery_method_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON loan_file_delivery_method_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t325
              ON primary_table.i_loan_file_delivery_method_type = t325.code
    WHERE GREATEST( primary_table.include_record, t318.include_record, t319.include_record, t323.include_record, t326.include_record,
                    t330.include_record, t331.include_record, t332.include_record, t320.include_record, t321.include_record,
                    t322.include_record, t329.include_record, t324.include_record, t325.include_record ) IS TRUE
)
--new records that should be inserted
SELECT investor_dim_incl_new_records.*
FROM investor_dim_incl_new_records
LEFT JOIN star_loan.investor_dim
          ON investor_dim_incl_new_records.data_source_integration_id = investor_dim.data_source_integration_id
WHERE investor_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT investor_dim_incl_new_records.*
FROM investor_dim_incl_new_records
JOIN (
    SELECT investor_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.investor_dim
    JOIN star_common.etl_log
         ON investor_dim.etl_batch_id = etl_log.etl_batch_id
) AS investor_dim_etl_start_times
     ON investor_dim_incl_new_records.data_source_integration_id = investor_dim_etl_start_times.data_source_integration_id
         AND investor_dim_incl_new_records.max_source_etl_end_date_time >= investor_dim_etl_start_times.etl_start_date_time;')
/*
 lender_user_dim
 */
         , ('lender_user_dim', 'WITH lender_user_dim_incl_new_records AS (
    SELECT ''lender_user_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( primary_table.lu_pid AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , primary_table.data_source_updated_datetime AS data_source_modified_datetime
         , t454.value AS country
         , t455.value AS default_credit_bureau
         , primary_table.lu_username AS username
         , primary_table.lu_nmls_loan_originator_id AS nmls_loan_originator_id
         , primary_table.lu_fha_chums_id AS fha_chums_id
         , primary_table.lu_va_agent_id AS va_agent_id
         , primary_table.lu_search_text AS search_text
         , primary_table.lu_company_user_id AS company_user_id
         , primary_table.lu_force_password_change AS force_password_change_flag
         , primary_table.lu_last_password_change_date AS last_password_change_datetime
         , primary_table.lu_allow_external_ip AS allow_external_ip_flag
         , primary_table.lu_total_workload_cap AS total_workload_cap
         , primary_table.lu_schedule_once_booking_page_id AS schedule_once_booking_page_id
         , primary_table.lu_esign_only AS esign_only_flag
         , primary_table.lu_work_step_start_notices_enabled AS work_step_start_notices_enabled_flag
         , primary_table.lu_smart_app_enabled AS smart_app_enabled_flag
         , primary_table.lu_default_credit_bureau_type AS default_credit_bureau_code
         , primary_table.lu_originator_id AS originator_id
         , primary_table.lu_name_qualifier AS name_qualifier
         , primary_table.lu_training_mode AS training_mode_flag
         , primary_table.lu_about_me AS about_me
         , primary_table.lu_lender_user_type AS type_code
         , primary_table.lu_hire_date AS hire_date
         , primary_table.lu_nickname AS nickname
         , primary_table.lu_preferred_first_name AS preferred_first_name
         , primary_table.lu_hub_directory AS hub_directory_flag
         , primary_table.lu_pid AS lender_user_pid
         , primary_table.lu_account_owner AS account_owner_flag
         , primary_table.lu_create_date AS create_date
         , primary_table.lu_first_name AS first_name
         , primary_table.lu_last_name AS last_name
         , primary_table.lu_middle_name AS middle_name
         , primary_table.lu_name_suffix AS name_suffix
         , primary_table.lu_company_name AS company_name
         , primary_table.lu_title AS title
         , primary_table.lu_office_phone AS office_phone
         , primary_table.lu_office_phone_extension AS office_phone_extension
         , primary_table.lu_email AS email
         , primary_table.lu_fax AS fax
         , primary_table.lu_city AS city
         , primary_table.lu_country AS country_code
         , primary_table.lu_postal_code AS postal_code
         , primary_table.lu_state AS state
         , primary_table.lu_street1 AS street1
         , primary_table.lu_street2 AS street2
         , primary_table.lu_office_phone_use_branch AS office_phone_use_branch_flag
         , primary_table.lu_fax_use_branch AS fax_use_branch_flag
         , primary_table.lu_address_use_branch AS address_use_branch_flag
         , primary_table.lu_start_date AS start_date
         , primary_table.lu_through_date AS through_date
         , primary_table.lu_time_zone AS time_zone_code
         , primary_table.lu_unparsed_name AS unparsed_name
         , primary_table.lu_lender_user_status_type AS status_code
         , t456.value AS status
         , t457.value AS type
         , t458.value AS time_zone
         , GREATEST( primary_table.etl_end_date_time, t454.etl_end_date_time, t455.etl_end_date_time, t456.etl_end_date_time,
                     t457.etl_end_date_time, t458.etl_end_date_time ) AS max_source_etl_end_date_time
    FROM (
        SELECT <<lender_user_partial_load_condition>> AS include_record
             , lender_user.*
             , etl_log.etl_end_date_time
        FROM history_octane.lender_user
        LEFT JOIN history_octane.lender_user AS history_records
                  ON lender_user.lu_pid = history_records.lu_pid
                      AND lender_user.data_source_updated_datetime < history_records.data_source_updated_datetime
        JOIN star_common.etl_log
             ON lender_user.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.lu_pid IS NULL
    ) AS primary_table
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
    ) AS t454
               ON primary_table.lu_country = t454.code
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
    ) AS t455
               ON primary_table.lu_default_credit_bureau_type = t455.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<lender_user_status_type_partial_load_condition>> AS include_record
                 , lender_user_status_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.lender_user_status_type
            LEFT JOIN history_octane.lender_user_status_type AS history_records
                      ON lender_user_status_type.code = history_records.code
                          AND lender_user_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON lender_user_status_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t456
               ON primary_table.lu_lender_user_status_type = t456.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<lender_user_type_partial_load_condition>> AS include_record
                 , lender_user_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.lender_user_type
            LEFT JOIN history_octane.lender_user_type AS history_records
                      ON lender_user_type.code = history_records.code
                          AND lender_user_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON lender_user_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t457
               ON primary_table.lu_lender_user_type = t457.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<time_zone_type_partial_load_condition>> AS include_record
                 , time_zone_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.time_zone_type
            LEFT JOIN history_octane.time_zone_type AS history_records
                      ON time_zone_type.code = history_records.code
                          AND time_zone_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON time_zone_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t458
               ON primary_table.lu_time_zone = t458.code
    WHERE GREATEST( primary_table.include_record, t454.include_record, t455.include_record, t456.include_record, t457.include_record,
                    t458.include_record ) IS TRUE
)
--new records that should be inserted
SELECT lender_user_dim_incl_new_records.*
FROM lender_user_dim_incl_new_records
LEFT JOIN star_loan.lender_user_dim
          ON lender_user_dim_incl_new_records.data_source_integration_id = lender_user_dim.data_source_integration_id
WHERE lender_user_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT lender_user_dim_incl_new_records.*
FROM lender_user_dim_incl_new_records
JOIN (
    SELECT lender_user_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.lender_user_dim
    JOIN star_common.etl_log
         ON lender_user_dim.etl_batch_id = etl_log.etl_batch_id
) AS lender_user_dim_etl_start_times
     ON lender_user_dim_incl_new_records.data_source_integration_id = lender_user_dim_etl_start_times.data_source_integration_id
         AND lender_user_dim_incl_new_records.max_source_etl_end_date_time >= lender_user_dim_etl_start_times.etl_start_date_time;')
/*
 loan_beneficiary_dim
*/
         , ('loan_beneficiary_dim', 'WITH loan_beneficiary_dim_incl_new_records AS (
    SELECT ''loan_beneficiary_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( primary_table.lb_pid AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , primary_table.data_source_updated_datetime AS data_source_modified_datetime
         , t347.value AS collateral_courier
         , t351.value AS loan_file_courier
         , t348.value AS delivery_aus
         , primary_table.lb_mers_mom AS mers_mom_flag
         , primary_table.lb_pid AS loan_beneficiary_pid
         , primary_table.lb_mers_transfer_status_type AS mers_transfer_status_code
         , primary_table.lb_mers_transfer_override AS mers_transfer_override_flag
         , primary_table.lb_loan_file_courier_type AS loan_file_courier_code
         , primary_table.lb_collateral_courier_type AS collateral_courier_code
         , primary_table.lb_loan_pid AS loan_pid
         , primary_table.lb_delivery_aus_type AS delivery_aus_code
         , primary_table.lb_early_funding AS early_funding_code
         , primary_table.lb_pool_id AS pool_id
         , primary_table.lb_loan_file_delivery_method_type AS loan_file_delivery_method_code
         , primary_table.lb_loan_benef_transfer_status_type AS transfer_status_code
         , primary_table.lb_initial AS initial_flag
         , primary_table.lb_current AS current_flag
         , primary_table.lb_investor_loan_id AS investor_loan_id
         , t350.value AS transfer_status
         , t352.value AS loan_file_delivery_method
         , t353.value AS mers_transfer_status
         , t349.value AS early_funding
         , GREATEST( primary_table.etl_end_date_time, t347.etl_end_date_time, t351.etl_end_date_time, t348.etl_end_date_time,
                     t350.etl_end_date_time, t352.etl_end_date_time, t353.etl_end_date_time,
                     t349.etl_end_date_time ) AS max_source_etl_end_date_time
    FROM (
        SELECT <<loan_beneficiary_partial_load_condition>> AS include_record
             , loan_beneficiary.*
             , etl_log.etl_end_date_time
        FROM history_octane.loan_beneficiary
        LEFT JOIN history_octane.loan_beneficiary AS history_records
                  ON loan_beneficiary.lb_pid = history_records.lb_pid
                      AND loan_beneficiary.data_source_updated_datetime < history_records.data_source_updated_datetime
        JOIN star_common.etl_log
             ON loan_beneficiary.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.lb_pid IS NULL
    ) AS primary_table
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<courier_type_partial_load_condition>> AS include_record
                 , courier_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.courier_type
            LEFT JOIN history_octane.courier_type AS history_records
                      ON courier_type.code = history_records.code
                          AND courier_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON courier_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t347
               ON primary_table.lb_collateral_courier_type = t347.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<courier_type_partial_load_condition>> AS include_record
                 , courier_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.courier_type
            LEFT JOIN history_octane.courier_type AS history_records
                      ON courier_type.code = history_records.code
                          AND courier_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON courier_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t351
               ON primary_table.lb_loan_file_courier_type = t351.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<delivery_aus_type_partial_load_condition>> AS include_record
                 , delivery_aus_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.delivery_aus_type
            LEFT JOIN history_octane.delivery_aus_type AS history_records
                      ON delivery_aus_type.code = history_records.code
                          AND delivery_aus_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON delivery_aus_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t348
               ON primary_table.lb_delivery_aus_type = t348.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<loan_benef_transfer_status_type_partial_load_condition>> AS include_record
                 , loan_benef_transfer_status_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.loan_benef_transfer_status_type
            LEFT JOIN history_octane.loan_benef_transfer_status_type AS history_records
                      ON loan_benef_transfer_status_type.code = history_records.code
                          AND loan_benef_transfer_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON loan_benef_transfer_status_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t350
               ON primary_table.lb_loan_benef_transfer_status_type = t350.code
    LEFT JOIN (
        SELECT *
        FROM (
            SELECT <<loan_file_delivery_method_type_partial_load_condition>> AS include_record
                 , loan_file_delivery_method_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.loan_file_delivery_method_type
            LEFT JOIN history_octane.loan_file_delivery_method_type AS history_records
                      ON loan_file_delivery_method_type.code = history_records.code
                          AND loan_file_delivery_method_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON loan_file_delivery_method_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t352
              ON primary_table.lb_loan_file_delivery_method_type = t352.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<mers_transfer_status_type_partial_load_condition>> AS include_record
                 , mers_transfer_status_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.mers_transfer_status_type
            LEFT JOIN history_octane.mers_transfer_status_type AS history_records
                      ON mers_transfer_status_type.code = history_records.code
                          AND mers_transfer_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON mers_transfer_status_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t353
               ON primary_table.lb_mers_transfer_status_type = t353.code
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
    ) AS t349
               ON primary_table.lb_early_funding = t349.code
    WHERE GREATEST( primary_table.include_record, t347.include_record, t351.include_record, t348.include_record, t350.include_record,
                    t352.include_record, t353.include_record, t349.include_record ) IS TRUE
)
--new records that should be inserted
SELECT loan_beneficiary_dim_incl_new_records.*
FROM loan_beneficiary_dim_incl_new_records
LEFT JOIN star_loan.loan_beneficiary_dim
          ON loan_beneficiary_dim_incl_new_records.data_source_integration_id = loan_beneficiary_dim.data_source_integration_id
WHERE loan_beneficiary_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT loan_beneficiary_dim_incl_new_records.*
FROM loan_beneficiary_dim_incl_new_records
JOIN (
    SELECT loan_beneficiary_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.loan_beneficiary_dim
    JOIN star_common.etl_log
         ON loan_beneficiary_dim.etl_batch_id = etl_log.etl_batch_id
) AS loan_beneficiary_dim_etl_start_times
     ON loan_beneficiary_dim_incl_new_records.data_source_integration_id = loan_beneficiary_dim_etl_start_times.data_source_integration_id
         AND loan_beneficiary_dim_incl_new_records.max_source_etl_end_date_time >= loan_beneficiary_dim_etl_start_times.etl_start_date_time;')
/*
 loan_dim
 */
         , ('loan_dim', 'WITH loan_dim_incl_new_records AS (
    SELECT ''loan_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( primary_table.l_pid AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , primary_table.data_source_updated_datetime AS data_source_modified_datetime
         , primary_table.l_last_unprocessed_changes_datetime AS last_unprocessed_changes_datetime
         , primary_table.l_locked_price_change_percent AS locked_price_change_percent
         , primary_table.l_mi_requirement_ltv_ratio_percent AS mi_requirement_ltv_ratio_percent
         , primary_table.l_base_loan_amount_ltv_ratio_percent AS base_loan_amount_ltv_ratio_percent
         , primary_table.l_arm_index_current_value_percent AS arm_index_current_value_percent
         , primary_table.l_arm_index_datetime AS arm_index_datetime
         , primary_table.l_product_terms_pid AS product_terms_pid
         , primary_table.l_proposal_pid AS proposal_pid
         , primary_table.l_pid AS loan_pid
         , primary_table.l_fhac_case_assignment_messages AS fhac_case_assignment_messages
         , primary_table.l_product_choice_datetime AS product_choice_datetime
         , primary_table.l_fnm_mbs_investor_contract_id AS fnm_mbs_investor_contract_id
         , primary_table.l_base_guaranty_fee_basis_points AS base_guaranty_fee_percent
         , primary_table.l_guaranty_fee_basis_points AS guaranty_fee_percent
         , primary_table.l_guaranty_fee_after_alternate_payment_method_basis_points AS guaranty_fee_after_alternate_payment_method_percent
         , primary_table.l_fnm_investor_product_plan_id AS fnm_investor_product_plan_id
         , primary_table.l_uldd_loan_comment AS uldd_loan_comment
         , primary_table.l_hmda_rate_spread_percent AS hmda_rate_spread_percent
         , primary_table.l_hoepa_apr AS hoepa_apr
         , primary_table.l_hoepa_rate_spread AS hoepa_rate_spread
         , primary_table.l_rate_sheet_undiscounted_rate_percent AS rate_sheet_undiscounted_rate_percent
         , primary_table.l_effective_undiscounted_rate_percent AS effective_undiscounted_rate_percent
         , CASE
               WHEN primary_table.l_lien_priority_type IS NULL OR t1317.prp_structure_type IS NULL THEN NULL
               WHEN primary_table.l_lien_priority_type = ''FIRST'' OR t1317.prp_structure_type = ''STANDALONE_2ND''
                   THEN t1317.d_los_loan_id_main
               ELSE t1317.d_los_loan_id_piggyback END AS los_loan_number
         , GREATEST( primary_table.etl_end_date_time, t1317.etl_end_date_time ) AS max_source_etl_end_date_time
    FROM (
        SELECT <<loan_partial_load_condition>> AS include_record
             , loan.*
             , etl_log.etl_end_date_time
        FROM history_octane.loan
        LEFT JOIN history_octane.loan AS history_records
                  ON loan.l_pid = history_records.l_pid
                      AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
        JOIN star_common.etl_log
             ON loan.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.l_pid IS NULL
    ) AS primary_table
    INNER JOIN (
        SELECT *
        FROM (
            SELECT proposal.*
            FROM history_octane.proposal
            LEFT JOIN history_octane.proposal AS history_records
                      ON proposal.prp_pid = history_records.prp_pid
                          AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.prp_pid IS NULL
        ) AS primary_table
            -- child join start
        INNER JOIN
        (
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
        ) AS t1441
        ON primary_table.prp_deal_pid = t1441.d_pid
        -- child join end
    ) AS t1317
               ON primary_table.l_proposal_pid = t1317.prp_pid
    WHERE GREATEST( primary_table.include_record, t1317.include_record ) IS TRUE
)
--new records that should be inserted
SELECT loan_dim_incl_new_records.*
FROM loan_dim_incl_new_records
LEFT JOIN star_loan.loan_dim
          ON loan_dim_incl_new_records.data_source_integration_id = loan_dim.data_source_integration_id
WHERE loan_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT loan_dim_incl_new_records.*
FROM loan_dim_incl_new_records
JOIN (
    SELECT loan_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.loan_dim
    JOIN star_common.etl_log
         ON loan_dim.etl_batch_id = etl_log.etl_batch_id
) AS loan_dim_etl_start_times
     ON loan_dim_incl_new_records.data_source_integration_id = loan_dim_etl_start_times.data_source_integration_id
         AND loan_dim_incl_new_records.max_source_etl_end_date_time >= loan_dim_etl_start_times.etl_start_date_time;')
/*
 loan_funding_dim
 */
         , ('loan_funding_dim', 'WITH loan_funding_dim_incl_new_records AS (
    SELECT ''loan_funding_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( primary_table.lf_pid AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , primary_table.data_source_updated_datetime AS data_source_modified_datetime
         , t380.value AS collateral_courier
         , t381.value AS funding_status
         , primary_table.lf_release_wire_federal_reference_number AS release_wire_federal_reference_number
         , primary_table.lf_interim_funder_fee_amount AS interim_funder_fee_amount
         , primary_table.lf_wire_amount AS wire_amount
         , primary_table.lf_confirmed_release_datetime AS funding_confirmed_release_datetime
         , primary_table.lf_funding_status_type AS funding_status_code
         , primary_table.lf_interim_funder_loan_id AS interim_funder_loan_id
         , primary_table.lf_pid AS loan_funding_pid
         , primary_table.lf_loan_pid AS loan_pid
         , primary_table.lf_interim_funder_pid AS interim_funder_pid
         , primary_table.lf_early_wire_request AS early_wire_request_flag
         , primary_table.lf_scheduled_release_date_auto_compute AS scheduled_release_date_auto_compute_flag
         , primary_table.lf_early_wire_total_charge_amount AS early_wire_total_charge_amount
         , primary_table.lf_early_wire_daily_charge_amount AS early_wire_daily_charge_amount
         , primary_table.lf_early_wire_charge_day_count AS early_wire_charge_day_count
         , primary_table.lf_net_wire_amount AS net_wire_amount
         , primary_table.lf_post_wire_adjustment_amount AS post_wire_adjustment_amount
         , primary_table.lf_collateral_courier_type AS collateral_courier_code
         , primary_table.lf_funds_authorized_datetime AS funds_authorized_datetime
         , primary_table.lf_funds_authorization_code AS funds_authorization_code
         , primary_table.lf_collateral_tracking_number AS collateral_tracking_number
         , GREATEST( primary_table.etl_end_date_time, t380.etl_end_date_time, t381.etl_end_date_time ) AS max_source_etl_end_date_time
    FROM (
        SELECT <<loan_funding_partial_load_condition>> AS include_record
             , loan_funding.*
             , etl_log.etl_end_date_time
        FROM history_octane.loan_funding
        LEFT JOIN history_octane.loan_funding AS history_records
                  ON loan_funding.lf_pid = history_records.lf_pid
                      AND loan_funding.data_source_updated_datetime < history_records.data_source_updated_datetime
        JOIN star_common.etl_log
             ON loan_funding.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.lf_pid IS NULL
    ) AS primary_table
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<courier_type_partial_load_condition>> AS include_record
                 , courier_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.courier_type
            LEFT JOIN history_octane.courier_type AS history_records
                      ON courier_type.code = history_records.code
                          AND courier_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON courier_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t380
               ON primary_table.lf_collateral_courier_type = t380.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<funding_status_type_partial_load_condition>> AS include_record
                 , funding_status_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.funding_status_type
            LEFT JOIN history_octane.funding_status_type AS history_records
                      ON funding_status_type.code = history_records.code
                          AND funding_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON funding_status_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t381
               ON primary_table.lf_funding_status_type = t381.code
    WHERE GREATEST( primary_table.include_record, t380.include_record, t381.include_record ) IS TRUE
)
--new records that should be inserted
SELECT loan_funding_dim_incl_new_records.*
FROM loan_funding_dim_incl_new_records
LEFT JOIN star_loan.loan_funding_dim
          ON loan_funding_dim_incl_new_records.data_source_integration_id = loan_funding_dim.data_source_integration_id
WHERE loan_funding_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT loan_funding_dim_incl_new_records.*
FROM loan_funding_dim_incl_new_records
JOIN (
    SELECT loan_funding_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.loan_funding_dim
    JOIN star_common.etl_log
         ON loan_funding_dim.etl_batch_id = etl_log.etl_batch_id
) AS loan_funding_dim_etl_start_times
     ON loan_funding_dim_incl_new_records.data_source_integration_id = loan_funding_dim_etl_start_times.data_source_integration_id
         AND loan_funding_dim_incl_new_records.max_source_etl_end_date_time >= loan_funding_dim_etl_start_times.etl_start_date_time;')
/*
 mortgage_insurance_dim
 */
         , ('mortgage_insurance_dim', 'WITH mortgage_insurance_dim_incl_new_records AS (
    SELECT ''loan_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( primary_table.l_pid AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , primary_table.data_source_updated_datetime AS data_source_modified_datetime
         , primary_table.l_mi_rate_quote_id AS mi_rate_quote_id
         , primary_table.l_mi_base_upfront_payment_amount AS mi_base_upfront_payment_amount
         , primary_table.l_mi_base_monthly_payment_amount AS mi_base_monthly_payment_amount
         , primary_table.l_mi_base_upfront_percent AS mi_base_upfront_percent
         , primary_table.l_mi_base_monthly_payment_annual_percent AS mi_base_monthly_payment_annual_percent
         , primary_table.l_mi_base_rate_label AS mi_base_rate_label
         , primary_table.l_mi_renewal_calculated_rate_type AS mi_renewal_calculated_rate_code
         , primary_table.l_mi_initial_calculated_rate_type AS mi_initial_calculated_rate_code
         , primary_table.l_mi_initial_monthly_payment_annual_percent AS mi_initial_monthly_payment_annual_percent
         , primary_table.l_mi_initial_duration_months AS mi_initial_duration_months
         , primary_table.l_mi_renewal_monthly_payment_amount AS mi_renewal_monthly_payment_amount
         , primary_table.l_mi_renewal_monthly_payment_annual_percent AS mi_renewal_monthly_payment_annual_percent
         , primary_table.l_mi_initial_monthly_payment_amount AS mi_initial_monthly_payment_amount
         , primary_table.l_mi_upfront_percent AS mi_upront_percent
         , primary_table.l_mi_upfront_amount AS mi_upfront_amount
         , primary_table.l_mi_payment_type AS mi_payment_code
         , primary_table.l_mi_actual_monthly_payment_count AS mi_actual_monthly_payment_count
         , primary_table.l_mi_required_monthly_payment_count AS mi_required_monthly_payment_count
         , primary_table.l_mi_midpoint_cutoff_required AS mi_midpoint_cutoff_required_flag
         , primary_table.l_mi_ltv_cutoff_percent AS mi_ltv_cutoff_percent
         , primary_table.l_mi_coverage_percent AS mi_coverage_percent
         , primary_table.l_mi_payer_type AS mi_payer_code
         , primary_table.l_mi_renewal_calculation_type AS mi_renewal_calculation_code
         , primary_table.l_mi_initial_calculation_type AS mi_initial_calculation_code
         , primary_table.l_mi_premium_refundable_type AS mi_premium_refundable_code
         , primary_table.l_mi_certificate_id AS mi_certificate_id
         , primary_table.l_mi_company_name_type AS mi_company_code
         , primary_table.l_mi_input_type AS mi_input_code
         , primary_table.l_mi_no_mi_product AS no_mi_product_flag
         , primary_table.l_mi_auto_compute AS mi_auto_compute_flag
         , primary_table.l_pid AS loan_pid
         , primary_table.l_mi_lender_paid_rate_adjustment_percent AS mi_lender_paid_rate_adjustment_percent
         , t471.value AS mi_initial_calculated_rate
         , t477.value AS mi_renewal_calcuated_rate
         , t470.value AS mi_company
         , t472.value AS mi_initial_calculation
         , t473.value AS mi_input
         , t474.value AS mi_payer
         , t475.value AS mi_payment
         , t476.value AS mi_premium_refundable
         , t478.value AS mi_renewal_calculation
         , t1739.dwid AS loan_dwid
         , GREATEST( primary_table.etl_end_date_time, t471.etl_end_date_time, t477.etl_end_date_time, t470.etl_end_date_time,
                     t472.etl_end_date_time, t473.etl_end_date_time, t474.etl_end_date_time, t475.etl_end_date_time, t476.etl_end_date_time,
                     t478.etl_end_date_time, t1739.etl_end_date_time ) AS max_source_etl_end_date_time
    FROM (
        SELECT <<loan_partial_load_condition>> AS include_record
             , loan.*
             , etl_log.etl_end_date_time
        FROM history_octane.loan
        LEFT JOIN history_octane.loan AS history_records
                  ON loan.l_pid = history_records.l_pid
                      AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
        JOIN star_common.etl_log
             ON loan.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.l_pid IS NULL
    ) AS primary_table
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<mi_calculated_rate_type_partial_load_condition>> AS include_record
                 , mi_calculated_rate_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.mi_calculated_rate_type
            LEFT JOIN history_octane.mi_calculated_rate_type AS history_records
                      ON mi_calculated_rate_type.code = history_records.code
                          AND mi_calculated_rate_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON mi_calculated_rate_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t471
               ON primary_table.l_mi_initial_calculated_rate_type = t471.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<mi_calculated_rate_type_partial_load_condition>> AS include_record
                 , mi_calculated_rate_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.mi_calculated_rate_type
            LEFT JOIN history_octane.mi_calculated_rate_type AS history_records
                      ON mi_calculated_rate_type.code = history_records.code
                          AND mi_calculated_rate_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON mi_calculated_rate_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t477
               ON primary_table.l_mi_renewal_calculated_rate_type = t477.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<mi_company_name_type_partial_load_condition>> AS include_record
                 , mi_company_name_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.mi_company_name_type
            LEFT JOIN history_octane.mi_company_name_type AS history_records
                      ON mi_company_name_type.code = history_records.code
                          AND mi_company_name_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON mi_company_name_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t470
               ON primary_table.l_mi_company_name_type = t470.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<mi_initial_calculation_type_partial_load_condition>> AS include_record
                 , mi_initial_calculation_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.mi_initial_calculation_type
            LEFT JOIN history_octane.mi_initial_calculation_type AS history_records
                      ON mi_initial_calculation_type.code = history_records.code
                          AND mi_initial_calculation_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON mi_initial_calculation_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t472
               ON primary_table.l_mi_initial_calculation_type = t472.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<mi_input_type_partial_load_condition>> AS include_record
                 , mi_input_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.mi_input_type
            LEFT JOIN history_octane.mi_input_type AS history_records
                      ON mi_input_type.code = history_records.code
                          AND mi_input_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON mi_input_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t473
               ON primary_table.l_mi_input_type = t473.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<mi_payer_type_partial_load_condition>> AS include_record
                 , mi_payer_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.mi_payer_type
            LEFT JOIN history_octane.mi_payer_type AS history_records
                      ON mi_payer_type.code = history_records.code
                          AND mi_payer_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON mi_payer_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t474
               ON primary_table.l_mi_payer_type = t474.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<mi_payment_type_partial_load_condition>> AS include_record
                 , mi_payment_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.mi_payment_type
            LEFT JOIN history_octane.mi_payment_type AS history_records
                      ON mi_payment_type.code = history_records.code
                          AND mi_payment_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON mi_payment_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t475
               ON primary_table.l_mi_payment_type = t475.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<mi_premium_refundable_type_partial_load_condition>> AS include_record
                 , mi_premium_refundable_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.mi_premium_refundable_type
            LEFT JOIN history_octane.mi_premium_refundable_type AS history_records
                      ON mi_premium_refundable_type.code = history_records.code
                          AND mi_premium_refundable_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON mi_premium_refundable_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t476
               ON primary_table.l_mi_premium_refundable_type = t476.code
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<mi_renewal_calculation_type_partial_load_condition>> AS include_record
                 , mi_renewal_calculation_type.*
                 , etl_log.etl_end_date_time
            FROM history_octane.mi_renewal_calculation_type
            LEFT JOIN history_octane.mi_renewal_calculation_type AS history_records
                      ON mi_renewal_calculation_type.code = history_records.code
                          AND mi_renewal_calculation_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON mi_renewal_calculation_type.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t478
               ON primary_table.l_mi_renewal_calculation_type = t478.code
    INNER JOIN (
        SELECT <<loan_dim_partial_load_condition>> AS include_record
             , loan_dim.*
             , etl_log.etl_end_date_time
        FROM star_loan.loan_dim
        JOIN star_common.etl_log
             ON loan_dim.etl_batch_id = etl_log.etl_batch_id
    ) AS t1739
               ON primary_table.l_pid = t1739.loan_pid AND t1739.data_source_dwid = 1
    WHERE GREATEST( primary_table.include_record, t471.include_record, t477.include_record, t470.include_record, t472.include_record,
                    t473.include_record, t474.include_record, t475.include_record, t476.include_record, t478.include_record,
                    t1739.include_record ) IS TRUE
)
--new records that should be inserted
SELECT mortgage_insurance_dim_incl_new_records.*
FROM mortgage_insurance_dim_incl_new_records
LEFT JOIN star_loan.mortgage_insurance_dim
          ON mortgage_insurance_dim_incl_new_records.data_source_integration_id = mortgage_insurance_dim.data_source_integration_id
WHERE mortgage_insurance_dim.loan_dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT mortgage_insurance_dim_incl_new_records.*
FROM mortgage_insurance_dim_incl_new_records
JOIN (
    SELECT mortgage_insurance_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.mortgage_insurance_dim
    JOIN star_common.etl_log
         ON mortgage_insurance_dim.etl_batch_id = etl_log.etl_batch_id
) AS mortgage_insurance_dim_etl_start_times
     ON mortgage_insurance_dim_incl_new_records.data_source_integration_id =
        mortgage_insurance_dim_etl_start_times.data_source_integration_id
         AND
        mortgage_insurance_dim_incl_new_records.max_source_etl_end_date_time >= mortgage_insurance_dim_etl_start_times.etl_start_date_time;')
/*
 transaction_dim
 */
         , ('transaction_dim', 'WITH transaction_dim_incl_new_records AS (
    SELECT ''deal_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( t1441.d_pid AS TEXT ), ''<NULL>'' ) || ''~'' || COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , primary_table.data_source_updated_datetime AS data_source_modified_datetime
         , t1441.d_pid AS deal_pid
         , primary_table.prp_pid AS active_proposal_pid
         , GREATEST( primary_table.etl_end_date_time, t1441.etl_end_date_time ) AS max_source_etl_end_date_time
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
    WHERE GREATEST( primary_table.include_record, t1441.include_record ) IS TRUE
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
         AND transaction_dim_incl_new_records.max_source_etl_end_date_time >= transaction_dim_etl_start_times.etl_start_date_time;')
)
UPDATE mdi.table_input_step
SET sql = updated_dim_sql.sql
FROM updated_dim_sql
JOIN mdi.insert_update_step
     ON insert_update_step.schema_name = 'star_loan'
         AND insert_update_step.table_name = updated_dim_sql.table_name
WHERE table_input_step.process_dwid = insert_update_step.process_dwid;
