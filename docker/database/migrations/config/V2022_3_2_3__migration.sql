--
-- Main | EDW | Octane schema synchronization for v2022.3.4.0 (2022-03-25) (https://app.asana.com/0/0/1201991021737532 )
--

/*
INSERTIONS
*/

--edw_field_definition
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'staging_octane', 'borrower_user', 'bu_activation_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_change_updater_time', 'dcut_proposal_updates_after_proposal_save_ms', 'BIGINT', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'borrower_user', 'bu_activation_datetime', 'TIMESTAMP', 'staging', 'staging_octane', 'borrower_user', 'bu_activation_datetime')
         , ('staging', 'history_octane', 'deal_change_updater_time', 'dcut_proposal_updates_after_proposal_save_ms', 'BIGINT', 'staging', 'staging_octane', 'deal_change_updater_time', 'dcut_proposal_updates_after_proposal_save_ms')
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
    VALUES ('SP-100065', 'bu_activation_datetime')
         , ('SP-100025', 'dcut_proposal_updates_after_proposal_save_ms')
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
    VALUES ('SP-100065', 0, '--finding records to insert into history_octane.borrower_user
SELECT staging_table.bu_pid
     , staging_table.bu_version
     , staging_table.bu_account_pid
     , staging_table.bu_create_datetime
     , staging_table.bu_email
     , staging_table.bu_last_sign_on_datetime
     , staging_table.bu_time_zone
     , staging_table.bu_first_name
     , staging_table.bu_middle_name
     , staging_table.bu_last_name
     , staging_table.bu_name_suffix
     , staging_table.bu_unparsed_name
     , staging_table.bu_borrower_activation_id
     , staging_table.bu_challenge_question_type
     , staging_table.bu_challenge_question_answer
     , staging_table.bu_borrower_user_account_status_type
     , staging_table.bu_public_quote_request_cache_id
     , staging_table.bu_create_sap_on_activation
     , staging_table.bu_nickname
     , staging_table.bu_plain_text_email
     , staging_table.bu_preferred_first_name
     , staging_table.bu_activation_datetime
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.borrower_user staging_table
LEFT JOIN history_octane.borrower_user history_table
          ON staging_table.bu_pid = history_table.bu_pid
              AND staging_table.bu_version = history_table.bu_version
WHERE history_table.bu_pid IS NULL
UNION ALL
SELECT history_table.bu_pid
     , history_table.bu_version + 1
     , history_table.bu_account_pid
     , history_table.bu_create_datetime
     , history_table.bu_email
     , history_table.bu_last_sign_on_datetime
     , history_table.bu_time_zone
     , history_table.bu_first_name
     , history_table.bu_middle_name
     , history_table.bu_last_name
     , history_table.bu_name_suffix
     , history_table.bu_unparsed_name
     , history_table.bu_borrower_activation_id
     , history_table.bu_challenge_question_type
     , history_table.bu_challenge_question_answer
     , history_table.bu_borrower_user_account_status_type
     , history_table.bu_public_quote_request_cache_id
     , history_table.bu_create_sap_on_activation
     , history_table.bu_nickname
     , history_table.bu_plain_text_email
     , history_table.bu_preferred_first_name
     , history_table.bu_activation_datetime
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.borrower_user history_table
LEFT JOIN staging_octane.borrower_user staging_table
          ON staging_table.bu_pid = history_table.bu_pid
WHERE staging_table.bu_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.borrower_user deleted_records
    WHERE deleted_records.bu_pid = history_table.bu_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100025', 0, '--finding records to insert into history_octane.deal_change_updater_time
SELECT staging_table.dcut_pid
     , staging_table.dcut_version
     , staging_table.dcut_account_pid
     , staging_table.dcut_los_loan_id_main
     , staging_table.dcut_start_time
     , staging_table.dcut_start_date
     , staging_table.dcut_overall_duration_ms
     , staging_table.dcut_deal_checks_ms
     , staging_table.dcut_deal_updates_ms
     , staging_table.dcut_proposal_updates_ms
     , staging_table.dcut_num_proposal_updates
     , staging_table.dcut_application_updates_ms
     , staging_table.dcut_num_application_updates
     , staging_table.dcut_borrower_updates_ms
     , staging_table.dcut_num_borrower_updates
     , staging_table.dcut_place_updates_ms
     , staging_table.dcut_num_place_updates
     , staging_table.dcut_loan_updates_ms
     , staging_table.dcut_num_loan_updates
     , staging_table.dcut_proposal_updates_after_loan_updates_ms
     , staging_table.dcut_updates_after_proposal_updates_ms
     , staging_table.dcut_proposal_summary_updates_ms
     , staging_table.dcut_deal_updates_after_all_proposal_updates_ms
     , staging_table.dcut_smart_charge_update_ms
     , staging_table.dcut_circumstance_change_updates_ms
     , staging_table.dcut_num_circumstance_change_updates
     , staging_table.dcut_tolerance_cure_update_ms
     , staging_table.dcut_proposal_summary_updates_after_smart_charge_updates_ms
     , staging_table.dcut_update_doc_sets_ms
     , staging_table.dcut_closing_funds_itemization_ms
     , staging_table.dcut_update_ribbon_for_deal_ms
     , staging_table.dcut_num_construction_draw_updates
     , staging_table.dcut_construction_draw_updates_ms
     , staging_table.dcut_proposal_updates_after_proposal_save_ms
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.deal_change_updater_time staging_table
LEFT JOIN history_octane.deal_change_updater_time history_table
          ON staging_table.dcut_pid = history_table.dcut_pid
              AND staging_table.dcut_version = history_table.dcut_version
WHERE history_table.dcut_pid IS NULL
UNION ALL
SELECT history_table.dcut_pid
     , history_table.dcut_version + 1
     , history_table.dcut_account_pid
     , history_table.dcut_los_loan_id_main
     , history_table.dcut_start_time
     , history_table.dcut_start_date
     , history_table.dcut_overall_duration_ms
     , history_table.dcut_deal_checks_ms
     , history_table.dcut_deal_updates_ms
     , history_table.dcut_proposal_updates_ms
     , history_table.dcut_num_proposal_updates
     , history_table.dcut_application_updates_ms
     , history_table.dcut_num_application_updates
     , history_table.dcut_borrower_updates_ms
     , history_table.dcut_num_borrower_updates
     , history_table.dcut_place_updates_ms
     , history_table.dcut_num_place_updates
     , history_table.dcut_loan_updates_ms
     , history_table.dcut_num_loan_updates
     , history_table.dcut_proposal_updates_after_loan_updates_ms
     , history_table.dcut_updates_after_proposal_updates_ms
     , history_table.dcut_proposal_summary_updates_ms
     , history_table.dcut_deal_updates_after_all_proposal_updates_ms
     , history_table.dcut_smart_charge_update_ms
     , history_table.dcut_circumstance_change_updates_ms
     , history_table.dcut_num_circumstance_change_updates
     , history_table.dcut_tolerance_cure_update_ms
     , history_table.dcut_proposal_summary_updates_after_smart_charge_updates_ms
     , history_table.dcut_update_doc_sets_ms
     , history_table.dcut_closing_funds_itemization_ms
     , history_table.dcut_update_ribbon_for_deal_ms
     , history_table.dcut_num_construction_draw_updates
     , history_table.dcut_construction_draw_updates_ms
     , history_table.dcut_proposal_updates_after_proposal_save_ms
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.deal_change_updater_time history_table
LEFT JOIN staging_octane.deal_change_updater_time staging_table
          ON staging_table.dcut_pid = history_table.dcut_pid
WHERE staging_table.dcut_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.deal_change_updater_time deleted_records
    WHERE deleted_records.dcut_pid = history_table.dcut_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
)
UPDATE mdi.table_input_step
SET data_source_dwid = update_rows.data_source_dwid
    , sql = update_rows.sql
    , connectionname = update_rows.connectionname::mdi.pentaho_db_connection_name
FROM update_rows
    JOIN mdi.process
        ON process.name = update_rows.process_name
WHERE process.dwid = table_input_step.process_dwid;


--
-- EDW | star_loan ETLs: Switch JOINs to county table to LEFT JOINs, backfill missing data
-- https://app.asana.com/0/0/1202015403592063
--

/*
UPDATES
*/

--table_input_step
WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-200005', 1, 'WITH borrower_dim_incl_new_records AS (
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
    ) AS current_borrower_residence ON primary_table.b_pid = current_borrower_residence.bres_borrower_pid
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
    ) AS current_borrower_residence_place ON current_borrower_residence.bres_place_pid = current_borrower_residence_place.pl_pid
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
    ) AS county ON current_borrower_residence_place.pl_county_pid = county.c_pid
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
    ) AS country_type ON current_borrower_residence_place.pl_country = country_type.code
    WHERE GREATEST( primary_table.include_record, t114.include_record, t115.include_record, t149.include_record, t150.include_record,
                    t118.include_record, t142.include_record, t120.include_record, t129.include_record, t130.include_record,
                    t132.include_record, t144.include_record, t145.include_record, t141.include_record,
                      current_borrower_residence.include_record, current_borrower_residence_place.include_record,
                      county.include_record, country_type.include_record ) IS TRUE
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
         AND borrower_dim_incl_new_records.max_source_etl_end_date_time >= borrower_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
         , ('SP-200019', 1, 'WITH transaction_dim_incl_new_records AS (
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
        , GREATEST( primary_table.etl_end_date_time, t1441.etl_end_date_time, current_deal_stage_records.etl_end_date_time,
            current_deal_stage_type_records.etl_end_date_time, subject_property.etl_end_date_time, county.etl_end_date_time,
            country_type.etl_end_date_time, property_category_type.etl_end_date_time, building_status_type.etl_end_date_time,
            property_rights_type.etl_end_date_time, neighborhood_location_type.etl_end_date_time) AS max_source_etl_end_date_time
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
WHERE GREATEST( primary_table.include_record, t1441.include_record, current_deal_stage_records.include_record,
    current_deal_stage_type_records.include_record, subject_property.include_record, county.include_record,
    country_type.include_record, property_category_type.include_record, building_status_type.include_record,
    property_rights_type.include_record, neighborhood_location_type.include_record ) IS TRUE
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
