--
-- EDW | Create borrower_hmda_collection_dim and add its dwid to borrower_dim
-- https://app.asana.com/0/0/1201985219077223
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'staging', 'history_octane', 'borrower')
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
    VALUES ('staging', 'star_loan', 'borrower_dim', 'borrower_hmda_collection_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'ethnicity_collected_visual_or_surname', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'ethnicity_collected_visual_or_surname_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_ethnicity_collected_visual_or_surname')
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'ethnicity_not_obtainable_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_ethnicity_not_obtainable')
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'ethnicity_refused', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'ethnicity_refused_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_ethnicity_refused')
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'race_collected_visual_or_surname', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'race_collected_visual_or_surname_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_race_collected_visual_or_surname')
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'race_information_not_provided_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_information_not_provided')
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'race_national_origin_refusal_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_national_origin_refusal')
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'race_not_obtainable_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_not_obtainable')
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'race_refused', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'race_refused_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_race_refused')
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'sex_collected_visual_or_surname', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'sex_collected_visual_or_surname_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_sex_collected_visual_or_surname')
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'sex_not_obtainable_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_sex_not_obtainable')
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'sex_refused', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_hmda_collection_dim', 'sex_refused_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_sex_refused')
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
VALUES ('SP-200005-insert-update', 'ETL to insert_update records into staging.star_loan.borrower_dim using staging.history_octane.borrower as the primary source')
     , ('SP-200005-update', 'ETL to insert_update records into staging.star_loan.borrower_dim using staging.history_octane.borrower as the primary source')
     , ('SP-200021', 'ETL to insert records into staging.star_loan.borrower_hmda_collection_dim using staging.history_octane.borrower as the primary source');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-200005-insert-update', 1, 'WITH borrower_dim_incl_new_records AS (
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
         , current_borrower_residence_place.pl_street1 AS current_residence_street1
         , current_borrower_residence_place.pl_street2 AS current_residence_street2
         , current_borrower_residence_place.pl_city AS current_residence_city
         , current_borrower_residence_place.pl_postal_code AS current_residence_postal_code
         , county.c_name AS current_residence_county_name
         , current_borrower_residence_place.pl_county_fips AS current_residence_county_fips
         , current_borrower_residence_place.pl_state AS current_residence_state
         , current_borrower_residence_place.pl_state_fips AS current_residence_state_fips
         , current_borrower_residence_place.pl_country AS current_residence_country_code
         , country_type.value AS current_residence_country
         , GREATEST( primary_table.etl_end_date_time, t114.etl_end_date_time, t115.etl_end_date_time, t149.etl_end_date_time,
                     t150.etl_end_date_time, t118.etl_end_date_time, t142.etl_end_date_time, t120.etl_end_date_time, t129.etl_end_date_time,
                     t130.etl_end_date_time, t132.etl_end_date_time, t144.etl_end_date_time, t145.etl_end_date_time,
                     t141.etl_end_date_time, current_borrower_residence.etl_end_date_time,
                     current_borrower_residence_place.etl_end_date_time, county.etl_end_date_time,
                     country_type.etl_end_date_time ) AS max_source_etl_end_date_time
         , COALESCE( CAST( primary_table.b_ethnicity_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_ethnicity_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_ethnicity_refused AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_information_not_provided AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_national_origin_refusal AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_refused AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_sex_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_sex_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_sex_refused AS TEXT ), ''<NULL>'' ) || ''~1'' AS borrower_hmda_collection_dim_integration_id
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
    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<borrower_residence_partial_load_condition>> AS include_record
                 , borrower_residence.*
                 , etl_log.etl_end_date_time
            FROM history_octane.borrower_residence
            LEFT JOIN history_octane.borrower_residence AS history_records
                      ON borrower_residence.bres_pid = history_records.bres_pid
                          AND borrower_residence.data_source_updated_datetime < history_records.data_source_updated_datetime
            JOIN star_common.etl_log
                 ON borrower_residence.etl_batch_id = etl_log.etl_batch_id
            WHERE history_records.bres_pid IS NULL
        ) AS primary_table
    ) AS current_borrower_residence
               ON primary_table.b_pid = current_borrower_residence.bres_borrower_pid
                   AND current_borrower_residence.bres_current IS TRUE
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
    ) AS current_borrower_residence_place
               ON current_borrower_residence.bres_place_pid = current_borrower_residence_place.pl_pid
    INNER JOIN (
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
    ) AS county
               ON current_borrower_residence_place.pl_county_pid = county.c_pid
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
    ) AS country_type
               ON current_borrower_residence_place.pl_country = country_type.code
    WHERE GREATEST( primary_table.include_record, t114.include_record, t115.include_record, t149.include_record, t150.include_record,
                    t118.include_record, t142.include_record, t120.include_record, t129.include_record, t130.include_record,
                    t132.include_record, t144.include_record, t145.include_record, t141.include_record,
                    current_borrower_residence.include_record, current_borrower_residence_place.include_record,
                    county.include_record, country_type.include_record ) IS TRUE
)
   , borrower_dim_inserts_and_updates AS (
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
             AND borrower_dim_incl_new_records.max_source_etl_end_date_time >= borrower_dim_etl_start_times.etl_start_date_time
)
SELECT borrower_dim_inserts_and_updates.*
     , COALESCE( borrower_hmda_collection_dim.dwid, 0 ) AS borrower_hmda_collection_dwid
FROM borrower_dim_inserts_and_updates
LEFT JOIN star_loan.borrower_hmda_collection_dim
          ON borrower_dim_inserts_and_updates.borrower_hmda_collection_dim_integration_id =
             borrower_hmda_collection_dim.data_source_integration_id;', 'Staging DB Connection')
         , ('SP-200005-update', 1, '--SP-200005-update
SELECT borrower_dim.data_source_integration_columns
     , borrower_dim.data_source_integration_id
     , borrower_dim.edw_created_datetime
     , NOW( ) AS edw_modified_datetime
     , borrower_dim.data_source_modified_datetime
     , borrower_dim.applicant_role
     , borrower_dim.application_taken_method
     , borrower_dim.borrower_pid
     , borrower_dim.alimony_child_support_explanation
     , borrower_dim.application_taken_method_code
     , borrower_dim.bankruptcy_explanation
     , borrower_dim.birth_date
     , borrower_dim.borrowed_down_payment_explanation
     , borrower_dim.applicant_role_code
     , borrower_dim.required_to_sign_flag
     , borrower_dim.has_no_ssn_flag
     , borrower_dim.credit_report_identifier
     , borrower_dim.credit_report_authorization_flag
     , borrower_dim.dependent_count
     , borrower_dim.dependents_age_years
     , borrower_dim.email
     , borrower_dim.fax
     , borrower_dim.first_name
     , borrower_dim.nickname
     , borrower_dim.ethnicity_other_hispanic_or_latino_description
     , borrower_dim.home_phone
     , borrower_dim.last_name
     , borrower_dim.middle_name
     , borrower_dim.name_suffix
     , borrower_dim.note_endorser_explanation
     , borrower_dim.obligated_loan_foreclosure_explanation
     , borrower_dim.office_phone
     , borrower_dim.office_phone_extension
     , borrower_dim.other_race_national_origin_description
     , borrower_dim.outstanding_judgments_explanation
     , borrower_dim.party_to_lawsuit_explanation
     , borrower_dim.power_of_attorney_code
     , borrower_dim.power_of_attorney_signing_capacity
     , borrower_dim.power_of_attorney_first_name
     , borrower_dim.power_of_attorney_last_name
     , borrower_dim.power_of_attorney_middle_name
     , borrower_dim.power_of_attorney_name_suffix
     , borrower_dim.power_of_attorney_company_name
     , borrower_dim.power_of_attorney_title
     , borrower_dim.power_of_attorney_office_phone
     , borrower_dim.power_of_attorney_office_phone_extension
     , borrower_dim.power_of_attorney_mobile_phone
     , borrower_dim.power_of_attorney_email
     , borrower_dim.power_of_attorney_fax
     , borrower_dim.power_of_attorney_city
     , borrower_dim.power_of_attorney_country_code
     , borrower_dim.power_of_attorney_postal_code
     , borrower_dim.power_of_attorney_state
     , borrower_dim.power_of_attorney_street1
     , borrower_dim.power_of_attorney_street2
     , borrower_dim.presently_delinquent_explanation
     , borrower_dim.prior_property_title_code
     , borrower_dim.prior_property_usage_code
     , borrower_dim.property_foreclosure_explanation
     , borrower_dim.race_other_american_indian_or_alaska_native_description
     , borrower_dim.race_other_asian_description
     , borrower_dim.race_other_pacific_islander_description
     , borrower_dim.experian_credit_score
     , borrower_dim.equifax_credit_score
     , borrower_dim.trans_union_credit_score
     , borrower_dim.decision_credit_score
     , borrower_dim.tiny_id_code
     , borrower_dim.first_time_homebuyer_explain
     , borrower_dim.caivrs_id
     , borrower_dim.caivrs_messages
     , borrower_dim.monthly_job_federal_tax_amount
     , borrower_dim.monthly_job_state_tax_amount
     , borrower_dim.monthly_job_retirement_tax_amount
     , borrower_dim.monthly_job_medicare_tax_amount
     , borrower_dim.monthly_job_state_disability_insurance_amount
     , borrower_dim.monthly_job_other_tax_1_amount
     , borrower_dim.monthly_job_other_tax_1_description
     , borrower_dim.monthly_job_other_tax_2_amount
     , borrower_dim.monthly_job_other_tax_2_description
     , borrower_dim.monthly_job_other_tax_3_amount
     , borrower_dim.monthly_job_other_tax_3_description
     , borrower_dim.monthly_job_total_tax_amount
     , borrower_dim.homeownership_education_id
     , borrower_dim.homeownership_education_name
     , borrower_dim.housing_counseling_code
     , borrower_dim.housing_counseling_agency_code
     , borrower_dim.housing_counseling_id
     , borrower_dim.housing_counseling_name
     , borrower_dim.housing_counseling_complete_date
     , borrower_dim.legal_entity_code
     , borrower_dim.credit_report_authorization_datetime
     , borrower_dim.credit_report_authorization_method_code
     , borrower_dim.credit_report_authorization_obtained_by_unparsed_name
     , borrower_dim.usda_annual_child_care_expenses
     , borrower_dim.usda_disability_expenses
     , borrower_dim.usda_medical_expenses
     , borrower_dim.usda_income_from_assets
     , borrower_dim.usda_moderate_income_limit
     , borrower_dim.relationship_to_primary_borrower_code
     , borrower_dim.relationship_to_seller_code
     , borrower_dim.preferred_first_name
     , borrower_dim.application_pid
     , borrower_dim.relationship_to_primary_borrower
     , borrower_dim.relationship_to_seller
     , borrower_dim.tiny_id
     , borrower_dim.power_of_attorney_country
     , borrower_dim.credit_report_authorization_method
     , borrower_dim.housing_counseling_agency
     , borrower_dim.housing_counseling
     , borrower_dim.legal_entity
     , borrower_dim.prior_property_title
     , borrower_dim.prior_property_usage
     , borrower_dim.power_of_attorney
     , borrower_dim.current_residence_street1
     , borrower_dim.current_residence_street2
     , borrower_dim.current_residence_city
     , borrower_dim.current_residence_postal_code
     , borrower_dim.current_residence_county_name
     , borrower_dim.current_residence_county_fips
     , borrower_dim.current_residence_state
     , borrower_dim.current_residence_state_fips
     , borrower_dim.current_residence_country_code
     , borrower_dim.current_residence_country
     , borrower_hmda_collection_dim.dwid AS borrower_hmda_collection_dwid
FROM star_loan.borrower_dim
JOIN (
    SELECT borrower.*
         , COALESCE( CAST( borrower.b_ethnicity_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_ethnicity_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_ethnicity_refused AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_information_not_provided AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_national_origin_refusal AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_refused AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_sex_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_sex_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_sex_refused AS TEXT ), ''<NULL>'' ) || ''~1'' AS borrower_hmda_collection_dim_integration_id
    FROM history_octane.borrower
    LEFT JOIN history_octane.borrower AS history_records
              ON borrower.b_pid = history_records.b_pid
                  AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.b_pid IS NULL
) AS borrower
     ON borrower_dim.borrower_pid = borrower.b_pid
JOIN star_loan.borrower_hmda_collection_dim
     ON borrower.borrower_hmda_collection_dim_integration_id = borrower_hmda_collection_dim.data_source_integration_id
WHERE borrower_dim.borrower_hmda_collection_dwid = 0;', 'Staging DB Connection')
         , ('SP-200021', 1, 'WITH borrower_hmda_collection_dim_new_records AS (
    SELECT ''ethnicity_collected_visual_or_surname_code~ethnicity_not_obtainable_flag~ethnicity_refused_code~race_collected_visual_or_surname_code~race_information_not_provided_flag~race_national_origin_refusal_flag~race_not_obtainable_flag~race_refused_code~sex_collected_visual_or_surname_code~sex_not_obtainable_flag~sex_refused_code~data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( borrower.b_ethnicity_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_ethnicity_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_ethnicity_refused AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_information_not_provided AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_national_origin_refusal AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_refused AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_sex_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_sex_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_sex_refused AS TEXT ), ''<NULL>'' ) || ''~1'' AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( borrower.data_source_updated_datetime ) AS data_source_modified_datetime
         , ethnicity_collected_visual_or_surname_type.value AS ethnicity_collected_visual_or_surname
         , borrower.b_ethnicity_collected_visual_or_surname AS ethnicity_collected_visual_or_surname_code
         , borrower.b_ethnicity_not_obtainable AS ethnicity_not_obtainable_flag
         , ethnicity_refused_type.value AS ethnicity_refused
         , borrower.b_ethnicity_refused AS ethnicity_refused_code
         , race_collected_visual_or_surname_type.value AS race_collected_visual_or_surname
         , borrower.b_race_collected_visual_or_surname AS race_collected_visual_or_surname_code
         , borrower.b_race_information_not_provided AS race_information_not_provided_flag
         , borrower.b_race_national_origin_refusal AS race_national_origin_refusal_flag
         , borrower.b_race_not_obtainable AS race_not_obtainable_flag
         , race_refused_type.value AS race_refused
         , borrower.b_race_refused AS race_refused_code
         , sex_collected_visual_or_surname_type.value AS sex_collected_visual_or_surname
         , borrower.b_sex_collected_visual_or_surname AS sex_collected_visual_or_surname_code
         , borrower.b_sex_not_obtainable AS sex_not_obtainable_flag
         , sex_refused_type.value AS sex_refused
         , borrower.b_sex_refused AS sex_refused_code
         , MAX( GREATEST( ethnicity_collected_visual_or_surname_type.etl_end_date_time, ethnicity_refused_type.etl_end_date_time,
                          race_collected_visual_or_surname_type.etl_end_date_time, race_refused_type.etl_end_date_time,
                          sex_collected_visual_or_surname_type.etl_end_date_time,
                          sex_refused_type.etl_end_date_time ) ) AS max_source_etl_end_date_time
    FROM (
        SELECT <<borrower_partial_load_condition>> AS include_record
             , borrower.*
        FROM history_octane.borrower
        LEFT JOIN history_octane.borrower AS history_records
                  ON borrower.b_pid = history_records.b_pid
                      AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.b_pid IS NULL
    ) AS borrower
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
    ) AS ethnicity_collected_visual_or_surname_type
         ON borrower.b_ethnicity_collected_visual_or_surname = ethnicity_collected_visual_or_surname_type.code
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
    ) AS ethnicity_refused_type
         ON borrower.b_ethnicity_refused = ethnicity_refused_type.code
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
    ) AS race_collected_visual_or_surname_type
         ON borrower.b_race_collected_visual_or_surname = race_collected_visual_or_surname_type.code
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
    ) AS race_refused_type
         ON borrower.b_race_refused = race_refused_type.code
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
    ) AS sex_collected_visual_or_surname_type
         ON borrower.b_sex_collected_visual_or_surname = sex_collected_visual_or_surname_type.code
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
    ) AS sex_refused_type
         ON borrower.b_sex_refused = sex_refused_type.code
    WHERE GREATEST( ethnicity_collected_visual_or_surname_type.include_record, borrower.include_record,
                    ethnicity_refused_type.include_record,
                    race_collected_visual_or_surname_type.include_record, race_refused_type.include_record,
                    sex_collected_visual_or_surname_type.include_record, sex_refused_type.include_record ) IS TRUE
    GROUP BY ethnicity_collected_visual_or_surname_type.value, borrower.b_ethnicity_collected_visual_or_surname
           , borrower.b_ethnicity_not_obtainable, ethnicity_refused_type.value, borrower.b_ethnicity_refused
           , race_collected_visual_or_surname_type.value, borrower.b_race_collected_visual_or_surname
           , borrower.b_race_information_not_provided
           , borrower.b_race_national_origin_refusal, borrower.b_race_not_obtainable, race_refused_type.value, borrower.b_race_refused
           , sex_collected_visual_or_surname_type.value, borrower.b_sex_collected_visual_or_surname, borrower.b_sex_not_obtainable
           , sex_refused_type.value, borrower.b_sex_refused
)
--new records that should be inserted
SELECT borrower_hmda_collection_dim_new_records.*
FROM borrower_hmda_collection_dim_new_records
LEFT JOIN star_loan.borrower_hmda_collection_dim
          ON borrower_hmda_collection_dim_new_records.data_source_integration_id = borrower_hmda_collection_dim.data_source_integration_id
WHERE borrower_hmda_collection_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT borrower_hmda_collection_dim_new_records.*
FROM borrower_hmda_collection_dim_new_records
JOIN (
    SELECT borrower_hmda_collection_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.borrower_hmda_collection_dim
    JOIN star_common.etl_log
         ON borrower_hmda_collection_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_hmda_collection_dim_etl_start_times
     ON borrower_hmda_collection_dim_new_records.data_source_integration_id =
        borrower_hmda_collection_dim_etl_start_times.data_source_integration_id
         AND borrower_hmda_collection_dim_new_records.max_source_etl_end_date_time >=
             borrower_hmda_collection_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
)
INSERT
INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
SELECT process.dwid, insert_rows.data_source_dwid, insert_rows.sql, 0, 'N', 'N', 'N', 'N', insert_rows.connectionname::mdi.pentaho_db_connection_name
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--table_output_step
WITH insert_rows (process_name, target_schema, target_table, truncate_table, connectionname) AS (
    VALUES ('SP-200021', 'star_loan', 'borrower_hmda_collection_dim', 'N', 'Staging DB Connection')
)
INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT process.dwid, insert_rows.target_schema, insert_rows.target_table, 1000, NULL, NULL, NULL, NULL, 'N', NULL, insert_rows.truncate_table::mdi.pentaho_y_or_n, insert_rows.connectionname, 'N', 'Y', 'N', 'N'
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('SP-200021', 'data_source_dwid')
         , ('SP-200021', 'edw_created_datetime')
         , ('SP-200021', 'edw_modified_datetime')
         , ('SP-200021', 'etl_batch_id')
         , ('SP-200021', 'data_source_integration_columns')
         , ('SP-200021', 'data_source_integration_id')
         , ('SP-200021', 'data_source_modified_datetime')
         , ('SP-200021', 'ethnicity_collected_visual_or_surname')
         , ('SP-200021', 'ethnicity_collected_visual_or_surname_code')
         , ('SP-200021', 'ethnicity_not_obtainable_flag')
         , ('SP-200021', 'ethnicity_refused')
         , ('SP-200021', 'ethnicity_refused_code')
         , ('SP-200021', 'race_collected_visual_or_surname')
         , ('SP-200021', 'race_collected_visual_or_surname_code')
         , ('SP-200021', 'race_information_not_provided_flag')
         , ('SP-200021', 'race_national_origin_refusal_flag')
         , ('SP-200021', 'race_not_obtainable_flag')
         , ('SP-200021', 'race_refused')
         , ('SP-200021', 'race_refused_code')
         , ('SP-200021', 'sex_collected_visual_or_surname')
         , ('SP-200021', 'sex_collected_visual_or_surname_code')
         , ('SP-200021', 'sex_not_obtainable_flag')
         , ('SP-200021', 'sex_refused')
         , ('SP-200021', 'sex_refused_code')
)
INSERT
INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
SELECT table_output_step.dwid, insert_rows.database_field_name, insert_rows.database_field_name, 0, FALSE
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name
JOIN mdi.table_output_step
     ON process.dwid = table_output_step.process_dwid;


--insert_update_step
WITH insert_rows (process_name, connectionname, schema_name, table_name) AS (
    VALUES ('SP-200005-insert-update', 'Staging DB Connection', 'star_loan', 'borrower_dim')
         , ('SP-200005-update', 'Staging DB Connection', 'star_loan', 'borrower_dim')
)
INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)
SELECT process.dwid, insert_rows.connectionname, insert_rows.schema_name, insert_rows.table_name, 1000, 'N'::mdi.pentaho_y_or_n
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--insert_update_key
WITH insert_rows (process_name, key_lookup) AS (
    VALUES ('SP-200005-insert-update', 'data_source_integration_id')
         , ('SP-200005-update', 'data_source_integration_id')
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
    VALUES ('SP-200005-insert-update', 'data_source_dwid', 'Y')
         , ('SP-200005-insert-update', 'edw_created_datetime', 'N')
         , ('SP-200005-insert-update', 'edw_modified_datetime', 'Y')
         , ('SP-200005-insert-update', 'etl_batch_id', 'Y')
         , ('SP-200005-insert-update', 'data_source_integration_columns', 'Y')
         , ('SP-200005-insert-update', 'data_source_integration_id', 'N')
         , ('SP-200005-insert-update', 'data_source_modified_datetime', 'N')
         , ('SP-200005-insert-update', 'borrower_pid', 'Y')
         , ('SP-200005-insert-update', 'application_pid', 'Y')
         , ('SP-200005-insert-update', 'alimony_child_support_explanation', 'Y')
         , ('SP-200005-insert-update', 'applicant_role', 'Y')
         , ('SP-200005-insert-update', 'applicant_role_code', 'Y')
         , ('SP-200005-insert-update', 'application_taken_method', 'Y')
         , ('SP-200005-insert-update', 'application_taken_method_code', 'Y')
         , ('SP-200005-insert-update', 'bankruptcy_explanation', 'Y')
         , ('SP-200005-insert-update', 'birth_date', 'Y')
         , ('SP-200005-insert-update', 'borrowed_down_payment_explanation', 'Y')
         , ('SP-200005-insert-update', 'caivrs_id', 'Y')
         , ('SP-200005-insert-update', 'caivrs_messages', 'Y')
         , ('SP-200005-insert-update', 'credit_report_authorization_datetime', 'Y')
         , ('SP-200005-insert-update', 'credit_report_authorization_method', 'Y')
         , ('SP-200005-insert-update', 'credit_report_authorization_method_code', 'Y')
         , ('SP-200005-insert-update', 'credit_report_authorization_obtained_by_unparsed_name', 'Y')
         , ('SP-200005-insert-update', 'credit_report_identifier', 'Y')
         , ('SP-200005-insert-update', 'decision_credit_score', 'Y')
         , ('SP-200005-insert-update', 'dependent_count', 'Y')
         , ('SP-200005-insert-update', 'dependents_age_years', 'Y')
         , ('SP-200005-insert-update', 'email', 'Y')
         , ('SP-200005-insert-update', 'equifax_credit_score', 'Y')
         , ('SP-200005-insert-update', 'ethnicity_other_hispanic_or_latino_description', 'Y')
         , ('SP-200005-insert-update', 'experian_credit_score', 'Y')
         , ('SP-200005-insert-update', 'fax', 'Y')
         , ('SP-200005-insert-update', 'first_name', 'Y')
         , ('SP-200005-insert-update', 'first_time_homebuyer_explain', 'Y')
         , ('SP-200005-insert-update', 'credit_report_authorization_flag', 'Y')
         , ('SP-200005-insert-update', 'has_no_ssn_flag', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_code', 'Y')
         , ('SP-200005-insert-update', 'home_phone', 'Y')
         , ('SP-200005-insert-update', 'homeownership_education_id', 'Y')
         , ('SP-200005-insert-update', 'homeownership_education_name', 'Y')
         , ('SP-200005-insert-update', 'housing_counseling', 'Y')
         , ('SP-200005-insert-update', 'housing_counseling_agency', 'Y')
         , ('SP-200005-insert-update', 'housing_counseling_agency_code', 'Y')
         , ('SP-200005-insert-update', 'housing_counseling_code', 'Y')
         , ('SP-200005-insert-update', 'housing_counseling_complete_date', 'Y')
         , ('SP-200005-insert-update', 'housing_counseling_id', 'Y')
         , ('SP-200005-insert-update', 'housing_counseling_name', 'Y')
         , ('SP-200005-insert-update', 'required_to_sign_flag', 'Y')
         , ('SP-200005-insert-update', 'last_name', 'Y')
         , ('SP-200005-insert-update', 'legal_entity', 'Y')
         , ('SP-200005-insert-update', 'legal_entity_code', 'Y')
         , ('SP-200005-insert-update', 'middle_name', 'Y')
         , ('SP-200005-insert-update', 'monthly_job_federal_tax_amount', 'Y')
         , ('SP-200005-insert-update', 'monthly_job_medicare_tax_amount', 'Y')
         , ('SP-200005-insert-update', 'monthly_job_other_tax_1_amount', 'Y')
         , ('SP-200005-insert-update', 'monthly_job_other_tax_1_description', 'Y')
         , ('SP-200005-insert-update', 'monthly_job_other_tax_2_amount', 'Y')
         , ('SP-200005-insert-update', 'monthly_job_other_tax_2_description', 'Y')
         , ('SP-200005-insert-update', 'monthly_job_other_tax_3_amount', 'Y')
         , ('SP-200005-insert-update', 'monthly_job_other_tax_3_description', 'Y')
         , ('SP-200005-insert-update', 'monthly_job_retirement_tax_amount', 'Y')
         , ('SP-200005-insert-update', 'monthly_job_state_disability_insurance_amount', 'Y')
         , ('SP-200005-insert-update', 'monthly_job_state_tax_amount', 'Y')
         , ('SP-200005-insert-update', 'monthly_job_total_tax_amount', 'Y')
         , ('SP-200005-insert-update', 'name_suffix', 'Y')
         , ('SP-200005-insert-update', 'nickname', 'Y')
         , ('SP-200005-insert-update', 'note_endorser_explanation', 'Y')
         , ('SP-200005-insert-update', 'obligated_loan_foreclosure_explanation', 'Y')
         , ('SP-200005-insert-update', 'office_phone', 'Y')
         , ('SP-200005-insert-update', 'office_phone_extension', 'Y')
         , ('SP-200005-insert-update', 'other_race_national_origin_description', 'Y')
         , ('SP-200005-insert-update', 'outstanding_judgments_explanation', 'Y')
         , ('SP-200005-insert-update', 'party_to_lawsuit_explanation', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_city', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_company_name', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_country', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_country_code', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_email', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_fax', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_first_name', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_last_name', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_middle_name', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_mobile_phone', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_name_suffix', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_office_phone', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_office_phone_extension', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_postal_code', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_signing_capacity', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_state', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_street1', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_street2', 'Y')
         , ('SP-200005-insert-update', 'power_of_attorney_title', 'Y')
         , ('SP-200005-insert-update', 'preferred_first_name', 'Y')
         , ('SP-200005-insert-update', 'presently_delinquent_explanation', 'Y')
         , ('SP-200005-insert-update', 'prior_property_title', 'Y')
         , ('SP-200005-insert-update', 'prior_property_title_code', 'Y')
         , ('SP-200005-insert-update', 'prior_property_usage', 'Y')
         , ('SP-200005-insert-update', 'prior_property_usage_code', 'Y')
         , ('SP-200005-insert-update', 'property_foreclosure_explanation', 'Y')
         , ('SP-200005-insert-update', 'race_other_american_indian_or_alaska_native_description', 'Y')
         , ('SP-200005-insert-update', 'race_other_asian_description', 'Y')
         , ('SP-200005-insert-update', 'race_other_pacific_islander_description', 'Y')
         , ('SP-200005-insert-update', 'relationship_to_primary_borrower', 'Y')
         , ('SP-200005-insert-update', 'relationship_to_primary_borrower_code', 'Y')
         , ('SP-200005-insert-update', 'relationship_to_seller', 'Y')
         , ('SP-200005-insert-update', 'relationship_to_seller_code', 'Y')
         , ('SP-200005-insert-update', 'tiny_id', 'Y')
         , ('SP-200005-insert-update', 'tiny_id_code', 'Y')
         , ('SP-200005-insert-update', 'trans_union_credit_score', 'Y')
         , ('SP-200005-insert-update', 'usda_annual_child_care_expenses', 'Y')
         , ('SP-200005-insert-update', 'usda_disability_expenses', 'Y')
         , ('SP-200005-insert-update', 'usda_income_from_assets', 'Y')
         , ('SP-200005-insert-update', 'usda_medical_expenses', 'Y')
         , ('SP-200005-insert-update', 'usda_moderate_income_limit', 'Y')
         , ('SP-200005-insert-update', 'current_residence_street1', 'Y')
         , ('SP-200005-insert-update', 'current_residence_street2', 'Y')
         , ('SP-200005-insert-update', 'current_residence_city', 'Y')
         , ('SP-200005-insert-update', 'current_residence_postal_code', 'Y')
         , ('SP-200005-insert-update', 'current_residence_county_name', 'Y')
         , ('SP-200005-insert-update', 'current_residence_county_fips', 'Y')
         , ('SP-200005-insert-update', 'current_residence_state', 'Y')
         , ('SP-200005-insert-update', 'current_residence_state_fips', 'Y')
         , ('SP-200005-insert-update', 'current_residence_country_code', 'Y')
         , ('SP-200005-insert-update', 'current_residence_country', 'Y')
         , ('SP-200005-insert-update', 'borrower_hmda_collection_dwid', 'Y')
         , ('SP-200005-update', 'data_source_dwid', 'Y')
         , ('SP-200005-update', 'edw_created_datetime', 'N')
         , ('SP-200005-update', 'edw_modified_datetime', 'Y')
         , ('SP-200005-update', 'etl_batch_id', 'Y')
         , ('SP-200005-update', 'data_source_integration_columns', 'Y')
         , ('SP-200005-update', 'data_source_integration_id', 'N')
         , ('SP-200005-update', 'data_source_modified_datetime', 'N')
         , ('SP-200005-update', 'borrower_pid', 'Y')
         , ('SP-200005-update', 'application_pid', 'Y')
         , ('SP-200005-update', 'alimony_child_support_explanation', 'Y')
         , ('SP-200005-update', 'applicant_role', 'Y')
         , ('SP-200005-update', 'applicant_role_code', 'Y')
         , ('SP-200005-update', 'application_taken_method', 'Y')
         , ('SP-200005-update', 'application_taken_method_code', 'Y')
         , ('SP-200005-update', 'bankruptcy_explanation', 'Y')
         , ('SP-200005-update', 'birth_date', 'Y')
         , ('SP-200005-update', 'borrowed_down_payment_explanation', 'Y')
         , ('SP-200005-update', 'caivrs_id', 'Y')
         , ('SP-200005-update', 'caivrs_messages', 'Y')
         , ('SP-200005-update', 'credit_report_authorization_datetime', 'Y')
         , ('SP-200005-update', 'credit_report_authorization_method', 'Y')
         , ('SP-200005-update', 'credit_report_authorization_method_code', 'Y')
         , ('SP-200005-update', 'credit_report_authorization_obtained_by_unparsed_name', 'Y')
         , ('SP-200005-update', 'credit_report_identifier', 'Y')
         , ('SP-200005-update', 'decision_credit_score', 'Y')
         , ('SP-200005-update', 'dependent_count', 'Y')
         , ('SP-200005-update', 'dependents_age_years', 'Y')
         , ('SP-200005-update', 'email', 'Y')
         , ('SP-200005-update', 'equifax_credit_score', 'Y')
         , ('SP-200005-update', 'ethnicity_other_hispanic_or_latino_description', 'Y')
         , ('SP-200005-update', 'experian_credit_score', 'Y')
         , ('SP-200005-update', 'fax', 'Y')
         , ('SP-200005-update', 'first_name', 'Y')
         , ('SP-200005-update', 'first_time_homebuyer_explain', 'Y')
         , ('SP-200005-update', 'credit_report_authorization_flag', 'Y')
         , ('SP-200005-update', 'has_no_ssn_flag', 'Y')
         , ('SP-200005-update', 'power_of_attorney', 'Y')
         , ('SP-200005-update', 'power_of_attorney_code', 'Y')
         , ('SP-200005-update', 'home_phone', 'Y')
         , ('SP-200005-update', 'homeownership_education_id', 'Y')
         , ('SP-200005-update', 'homeownership_education_name', 'Y')
         , ('SP-200005-update', 'housing_counseling', 'Y')
         , ('SP-200005-update', 'housing_counseling_agency', 'Y')
         , ('SP-200005-update', 'housing_counseling_agency_code', 'Y')
         , ('SP-200005-update', 'housing_counseling_code', 'Y')
         , ('SP-200005-update', 'housing_counseling_complete_date', 'Y')
         , ('SP-200005-update', 'housing_counseling_id', 'Y')
         , ('SP-200005-update', 'housing_counseling_name', 'Y')
         , ('SP-200005-update', 'required_to_sign_flag', 'Y')
         , ('SP-200005-update', 'last_name', 'Y')
         , ('SP-200005-update', 'legal_entity', 'Y')
         , ('SP-200005-update', 'legal_entity_code', 'Y')
         , ('SP-200005-update', 'middle_name', 'Y')
         , ('SP-200005-update', 'monthly_job_federal_tax_amount', 'Y')
         , ('SP-200005-update', 'monthly_job_medicare_tax_amount', 'Y')
         , ('SP-200005-update', 'monthly_job_other_tax_1_amount', 'Y')
         , ('SP-200005-update', 'monthly_job_other_tax_1_description', 'Y')
         , ('SP-200005-update', 'monthly_job_other_tax_2_amount', 'Y')
         , ('SP-200005-update', 'monthly_job_other_tax_2_description', 'Y')
         , ('SP-200005-update', 'monthly_job_other_tax_3_amount', 'Y')
         , ('SP-200005-update', 'monthly_job_other_tax_3_description', 'Y')
         , ('SP-200005-update', 'monthly_job_retirement_tax_amount', 'Y')
         , ('SP-200005-update', 'monthly_job_state_disability_insurance_amount', 'Y')
         , ('SP-200005-update', 'monthly_job_state_tax_amount', 'Y')
         , ('SP-200005-update', 'monthly_job_total_tax_amount', 'Y')
         , ('SP-200005-update', 'name_suffix', 'Y')
         , ('SP-200005-update', 'nickname', 'Y')
         , ('SP-200005-update', 'note_endorser_explanation', 'Y')
         , ('SP-200005-update', 'obligated_loan_foreclosure_explanation', 'Y')
         , ('SP-200005-update', 'office_phone', 'Y')
         , ('SP-200005-update', 'office_phone_extension', 'Y')
         , ('SP-200005-update', 'other_race_national_origin_description', 'Y')
         , ('SP-200005-update', 'outstanding_judgments_explanation', 'Y')
         , ('SP-200005-update', 'party_to_lawsuit_explanation', 'Y')
         , ('SP-200005-update', 'power_of_attorney_city', 'Y')
         , ('SP-200005-update', 'power_of_attorney_company_name', 'Y')
         , ('SP-200005-update', 'power_of_attorney_country', 'Y')
         , ('SP-200005-update', 'power_of_attorney_country_code', 'Y')
         , ('SP-200005-update', 'power_of_attorney_email', 'Y')
         , ('SP-200005-update', 'power_of_attorney_fax', 'Y')
         , ('SP-200005-update', 'power_of_attorney_first_name', 'Y')
         , ('SP-200005-update', 'power_of_attorney_last_name', 'Y')
         , ('SP-200005-update', 'power_of_attorney_middle_name', 'Y')
         , ('SP-200005-update', 'power_of_attorney_mobile_phone', 'Y')
         , ('SP-200005-update', 'power_of_attorney_name_suffix', 'Y')
         , ('SP-200005-update', 'power_of_attorney_office_phone', 'Y')
         , ('SP-200005-update', 'power_of_attorney_office_phone_extension', 'Y')
         , ('SP-200005-update', 'power_of_attorney_postal_code', 'Y')
         , ('SP-200005-update', 'power_of_attorney_signing_capacity', 'Y')
         , ('SP-200005-update', 'power_of_attorney_state', 'Y')
         , ('SP-200005-update', 'power_of_attorney_street1', 'Y')
         , ('SP-200005-update', 'power_of_attorney_street2', 'Y')
         , ('SP-200005-update', 'power_of_attorney_title', 'Y')
         , ('SP-200005-update', 'preferred_first_name', 'Y')
         , ('SP-200005-update', 'presently_delinquent_explanation', 'Y')
         , ('SP-200005-update', 'prior_property_title', 'Y')
         , ('SP-200005-update', 'prior_property_title_code', 'Y')
         , ('SP-200005-update', 'prior_property_usage', 'Y')
         , ('SP-200005-update', 'prior_property_usage_code', 'Y')
         , ('SP-200005-update', 'property_foreclosure_explanation', 'Y')
         , ('SP-200005-update', 'race_other_american_indian_or_alaska_native_description', 'Y')
         , ('SP-200005-update', 'race_other_asian_description', 'Y')
         , ('SP-200005-update', 'race_other_pacific_islander_description', 'Y')
         , ('SP-200005-update', 'relationship_to_primary_borrower', 'Y')
         , ('SP-200005-update', 'relationship_to_primary_borrower_code', 'Y')
         , ('SP-200005-update', 'relationship_to_seller', 'Y')
         , ('SP-200005-update', 'relationship_to_seller_code', 'Y')
         , ('SP-200005-update', 'tiny_id', 'Y')
         , ('SP-200005-update', 'tiny_id_code', 'Y')
         , ('SP-200005-update', 'trans_union_credit_score', 'Y')
         , ('SP-200005-update', 'usda_annual_child_care_expenses', 'Y')
         , ('SP-200005-update', 'usda_disability_expenses', 'Y')
         , ('SP-200005-update', 'usda_income_from_assets', 'Y')
         , ('SP-200005-update', 'usda_medical_expenses', 'Y')
         , ('SP-200005-update', 'usda_moderate_income_limit', 'Y')
         , ('SP-200005-update', 'current_residence_street1', 'Y')
         , ('SP-200005-update', 'current_residence_street2', 'Y')
         , ('SP-200005-update', 'current_residence_city', 'Y')
         , ('SP-200005-update', 'current_residence_postal_code', 'Y')
         , ('SP-200005-update', 'current_residence_county_name', 'Y')
         , ('SP-200005-update', 'current_residence_county_fips', 'Y')
         , ('SP-200005-update', 'current_residence_state', 'Y')
         , ('SP-200005-update', 'current_residence_state_fips', 'Y')
         , ('SP-200005-update', 'current_residence_country_code', 'Y')
         , ('SP-200005-update', 'current_residence_country', 'Y')
         , ('SP-200005-update', 'borrower_hmda_collection_dwid', 'Y')
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
    VALUES ('SP-200005-insert-update', 'data_source_integration_id')
         , ('SP-200005-update', 'data_source_integration_id')
         , ('SP-200021', 'data_source_integration_id')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
JOIN mdi.process
     ON insert_rows.process_name = process.name;

--state_machine_definition
WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-200005-insert-update', 'SP-200005-insert-update', 'ETL to insert_update records into staging.star_loan.borrower_dim using staging.history_octane.borrower as the primary source')
         , ('SP-200005-update', 'SP-200005-update', 'ETL to insert_update records into staging.star_loan.borrower_dim using staging.history_octane.borrower as the primary source')
         , ('SP-200021', 'SP-200021', 'ETL to insert records into staging.star_loan.borrower_hmda_collection_dim using staging.history_octane.borrower as the primary source')
)
INSERT
INTO mdi.state_machine_definition (process_dwid, name, comment)
SELECT process.dwid, insert_rows.state_machine_name, insert_rows.state_machine_comment
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--state_machine_step
WITH insert_rows (process_name, next_process_name) AS (
    VALUES ('SP-100403', 'SP-200005-insert-update')
         , ('SP-100404', 'SP-200005-insert-update')
         , ('SP-100308', 'SP-200021')
         , ('SP-100308', 'SP-200005-insert-update')
         , ('SP-100419', 'SP-200005-insert-update')
         , ('SP-100158', 'SP-200005-insert-update')
         , ('SP-100421', 'SP-200005-insert-update')
         , ('SP-100450', 'SP-200005-insert-update')
         , ('SP-100058', 'SP-200005-insert-update')
         , ('SP-100452', 'SP-200005-insert-update')
         , ('SP-100092', 'SP-200001-delete')
         , ('SP-100747', 'SP-200005-insert-update')
         , ('SP-100748', 'SP-200005-insert-update')
         , ('SP-100549', 'SP-200005-insert-update')
         , ('SP-100090', 'SP-200001-delete')
         , ('SP-100012', 'SP-200005-insert-update')
         , ('SP-100617', 'SP-200005-insert-update')
         , ('SP-100629', 'SP-200005-insert-update')
         , ('SP-100814', 'SP-200021')
         , ('SP-100814', 'SP-200005-insert-update')
         , ('SP-200005-insert-update', 'SP-300001-insert-update')
         , ('SP-200005-update', 'SP-300001-insert-update')
         , ('SP-200021', 'SP-200005-update')
         , ('SP-300001-insert-update', 'SP-200001-delete')
         , ('SP-300001-delete', 'SP-200001-delete')
)
INSERT
INTO mdi.state_machine_step (process_dwid, next_process_dwid)
SELECT process.dwid, next_process.dwid
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name
JOIN mdi.process next_process
     ON next_process.name = insert_rows.next_process_name;

/*
UPDATES
*/

--delete_step
WITH update_rows (process_name, connectionname, schema_name, table_name) AS (
    VALUES ('SP-200001-delete-0', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-1', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-2', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-3', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-4', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-5', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-6', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-7', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-8', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-9', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-10', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-11', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-12', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-13', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-14', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-15', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-16', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-17', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-18', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-19', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-20', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-21', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-22', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-23', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-24', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-25', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-26', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-27', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-28', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-29', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-30', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-31', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-32', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-33', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-34', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-35', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-36', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-37', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-38', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-39', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-40', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-41', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-42', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-43', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-44', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-45', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-46', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-47', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-48', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-49', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-50', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-51', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-52', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-53', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-54', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-55', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-56', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-57', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-58', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-59', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-60', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-61', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-62', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-63', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-64', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-65', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-66', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-67', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-68', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-69', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-70', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-71', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-72', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-73', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-74', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-75', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-76', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-77', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-78', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-79', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-80', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-81', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-82', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-83', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-84', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-85', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-86', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-87', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-88', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-89', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-90', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-91', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-92', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-93', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-94', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-95', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-96', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-97', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-98', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-99', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
)
UPDATE mdi.delete_step
SET connectionname = update_rows.connectionname
  , schema_name = update_rows.schema_name
  , table_name = update_rows.table_name
FROM update_rows
JOIN mdi.process
     ON process.name = update_rows.process_name
WHERE process.dwid = delete_step.process_dwid;

/*
DELETIONS
*/

--state_machine_step
WITH delete_keys (process_name, next_process_name) AS (
    VALUES ('SP-100012', 'SP-200005')
         , ('SP-100058', 'SP-200005')
         , ('SP-100158', 'SP-200005')
         , ('SP-100308', 'SP-200005')
         , ('SP-100403', 'SP-200005')
         , ('SP-100404', 'SP-200005')
         , ('SP-100419', 'SP-200005')
         , ('SP-100421', 'SP-200005')
         , ('SP-100450', 'SP-200005')
         , ('SP-100452', 'SP-200005')
         , ('SP-100549', 'SP-200005')
         , ('SP-100617', 'SP-200005')
         , ('SP-100629', 'SP-200005')
         , ('SP-100747', 'SP-200005')
         , ('SP-100748', 'SP-200005')
         , ('SP-100814', 'SP-200005')
         , ('SP-200005', 'SP-300001-insert-update')
)
DELETE
FROM mdi.state_machine_step
    USING delete_keys, mdi.process, mdi.process next_process
WHERE state_machine_step.process_dwid = process.dwid
  AND state_machine_step.next_process_dwid = next_process.dwid
  AND delete_keys.process_name = process.name
  AND delete_keys.next_process_name = next_process.name;

--state_machine_definition
WITH delete_keys (process_name) AS (
    VALUES ('SP-200005')
)
DELETE
FROM mdi.state_machine_definition
    USING delete_keys, mdi.process
WHERE state_machine_definition.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--json_output_field
WITH delete_keys (process_name) AS (
    VALUES ('SP-200005')
)
DELETE
FROM mdi.json_output_field
    USING delete_keys, mdi.process
WHERE json_output_field.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--insert_update_field
WITH delete_keys (process_name, update_lookup) AS (
    VALUES ('SP-200005', 'power_of_attorney')
         , ('SP-200005', 'prior_property_usage')
         , ('SP-200005', 'prior_property_title')
         , ('SP-200005', 'legal_entity')
         , ('SP-200005', 'housing_counseling')
         , ('SP-200005', 'housing_counseling_agency')
         , ('SP-200005', 'credit_report_authorization_method')
         , ('SP-200005', 'power_of_attorney_country')
         , ('SP-200005', 'tiny_id')
         , ('SP-200005', 'relationship_to_seller')
         , ('SP-200005', 'relationship_to_primary_borrower')
         , ('SP-200005', 'application_pid')
         , ('SP-200005', 'preferred_first_name')
         , ('SP-200005', 'relationship_to_seller_code')
         , ('SP-200005', 'relationship_to_primary_borrower_code')
         , ('SP-200005', 'usda_moderate_income_limit')
         , ('SP-200005', 'usda_income_from_assets')
         , ('SP-200005', 'usda_medical_expenses')
         , ('SP-200005', 'usda_disability_expenses')
         , ('SP-200005', 'usda_annual_child_care_expenses')
         , ('SP-200005', 'credit_report_authorization_obtained_by_unparsed_name')
         , ('SP-200005', 'credit_report_authorization_method_code')
         , ('SP-200005', 'credit_report_authorization_datetime')
         , ('SP-200005', 'legal_entity_code')
         , ('SP-200005', 'housing_counseling_complete_date')
         , ('SP-200005', 'housing_counseling_name')
         , ('SP-200005', 'housing_counseling_id')
         , ('SP-200005', 'housing_counseling_agency_code')
         , ('SP-200005', 'housing_counseling_code')
         , ('SP-200005', 'homeownership_education_name')
         , ('SP-200005', 'homeownership_education_id')
         , ('SP-200005', 'monthly_job_total_tax_amount')
         , ('SP-200005', 'monthly_job_other_tax_3_description')
         , ('SP-200005', 'monthly_job_other_tax_3_amount')
         , ('SP-200005', 'monthly_job_other_tax_2_description')
         , ('SP-200005', 'monthly_job_other_tax_2_amount')
         , ('SP-200005', 'monthly_job_other_tax_1_description')
         , ('SP-200005', 'monthly_job_other_tax_1_amount')
         , ('SP-200005', 'monthly_job_state_disability_insurance_amount')
         , ('SP-200005', 'monthly_job_medicare_tax_amount')
         , ('SP-200005', 'monthly_job_retirement_tax_amount')
         , ('SP-200005', 'monthly_job_state_tax_amount')
         , ('SP-200005', 'monthly_job_federal_tax_amount')
         , ('SP-200005', 'caivrs_messages')
         , ('SP-200005', 'caivrs_id')
         , ('SP-200005', 'first_time_homebuyer_explain')
         , ('SP-200005', 'tiny_id_code')
         , ('SP-200005', 'decision_credit_score')
         , ('SP-200005', 'trans_union_credit_score')
         , ('SP-200005', 'equifax_credit_score')
         , ('SP-200005', 'experian_credit_score')
         , ('SP-200005', 'race_other_pacific_islander_description')
         , ('SP-200005', 'race_other_asian_description')
         , ('SP-200005', 'race_other_american_indian_or_alaska_native_description')
         , ('SP-200005', 'property_foreclosure_explanation')
         , ('SP-200005', 'prior_property_usage_code')
         , ('SP-200005', 'prior_property_title_code')
         , ('SP-200005', 'presently_delinquent_explanation')
         , ('SP-200005', 'power_of_attorney_street2')
         , ('SP-200005', 'power_of_attorney_street1')
         , ('SP-200005', 'power_of_attorney_state')
         , ('SP-200005', 'power_of_attorney_postal_code')
         , ('SP-200005', 'power_of_attorney_country_code')
         , ('SP-200005', 'power_of_attorney_city')
         , ('SP-200005', 'power_of_attorney_fax')
         , ('SP-200005', 'power_of_attorney_email')
         , ('SP-200005', 'power_of_attorney_mobile_phone')
         , ('SP-200005', 'power_of_attorney_office_phone_extension')
         , ('SP-200005', 'power_of_attorney_office_phone')
         , ('SP-200005', 'power_of_attorney_title')
         , ('SP-200005', 'power_of_attorney_company_name')
         , ('SP-200005', 'power_of_attorney_name_suffix')
         , ('SP-200005', 'power_of_attorney_middle_name')
         , ('SP-200005', 'power_of_attorney_last_name')
         , ('SP-200005', 'power_of_attorney_first_name')
         , ('SP-200005', 'power_of_attorney_signing_capacity')
         , ('SP-200005', 'power_of_attorney_code')
         , ('SP-200005', 'party_to_lawsuit_explanation')
         , ('SP-200005', 'outstanding_judgments_explanation')
         , ('SP-200005', 'other_race_national_origin_description')
         , ('SP-200005', 'office_phone_extension')
         , ('SP-200005', 'office_phone')
         , ('SP-200005', 'obligated_loan_foreclosure_explanation')
         , ('SP-200005', 'note_endorser_explanation')
         , ('SP-200005', 'name_suffix')
         , ('SP-200005', 'middle_name')
         , ('SP-200005', 'last_name')
         , ('SP-200005', 'home_phone')
         , ('SP-200005', 'ethnicity_other_hispanic_or_latino_description')
         , ('SP-200005', 'nickname')
         , ('SP-200005', 'first_name')
         , ('SP-200005', 'fax')
         , ('SP-200005', 'email')
         , ('SP-200005', 'dependents_age_years')
         , ('SP-200005', 'dependent_count')
         , ('SP-200005', 'credit_report_authorization_flag')
         , ('SP-200005', 'credit_report_identifier')
         , ('SP-200005', 'has_no_ssn_flag')
         , ('SP-200005', 'required_to_sign_flag')
         , ('SP-200005', 'applicant_role_code')
         , ('SP-200005', 'borrowed_down_payment_explanation')
         , ('SP-200005', 'birth_date')
         , ('SP-200005', 'bankruptcy_explanation')
         , ('SP-200005', 'application_taken_method_code')
         , ('SP-200005', 'alimony_child_support_explanation')
         , ('SP-200005', 'borrower_pid')
         , ('SP-200005', 'application_taken_method')
         , ('SP-200005', 'applicant_role')
         , ('SP-200005', 'etl_batch_id')
         , ('SP-200005', 'data_source_modified_datetime')
         , ('SP-200005', 'edw_modified_datetime')
         , ('SP-200005', 'edw_created_datetime')
         , ('SP-200005', 'data_source_integration_columns')
         , ('SP-200005', 'data_source_dwid')
         , ('SP-200005', 'data_source_integration_id')
         , ('SP-200005', 'current_residence_street1')
         , ('SP-200005', 'current_residence_street2')
         , ('SP-200005', 'current_residence_city')
         , ('SP-200005', 'current_residence_postal_code')
         , ('SP-200005', 'current_residence_county_name')
         , ('SP-200005', 'current_residence_county_fips')
         , ('SP-200005', 'current_residence_state')
         , ('SP-200005', 'current_residence_state_fips')
         , ('SP-200005', 'current_residence_country_code')
         , ('SP-200005', 'current_residence_country')
)
DELETE
FROM mdi.insert_update_field
    USING delete_keys, mdi.process, mdi.insert_update_step
WHERE delete_keys.process_name = process.name
  AND process.dwid = insert_update_step.process_dwid
  AND insert_update_step.dwid = insert_update_field.insert_update_step_dwid
  AND delete_keys.update_lookup = insert_update_field.update_lookup;


--insert_update_key
WITH delete_keys (process_name) AS (
    VALUES ('SP-200005', 'data_source_integration_id')
)
DELETE
FROM mdi.insert_update_key
    USING delete_keys, mdi.process, mdi.insert_update_step
WHERE insert_update_key.insert_update_step_dwid = insert_update_step.dwid  AND insert_update_step.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--insert_update_step
WITH delete_keys (process_name) AS (
    VALUES ('SP-200005')
)
DELETE
FROM mdi.insert_update_step
    USING delete_keys, mdi.process
WHERE insert_update_step.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--table_input_step
WITH delete_keys (process_name) AS (
    VALUES ('SP-200005')
)
DELETE
FROM mdi.table_input_step
    USING delete_keys, mdi.process
WHERE table_input_step.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--process
WITH delete_keys (process_name) AS (
    VALUES ('SP-200005')
)
DELETE
FROM mdi.process
    USING delete_keys
WHERE process.name = delete_keys.process_name;
