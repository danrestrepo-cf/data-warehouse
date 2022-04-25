--
-- EDW | Split borrower_demographics_dim and borrower_lending_profile_dim into smaller unique dim tables
-- https://app.asana.com/0/0/1201990575730852
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'star_loan', 'borrower_counseling_dim', 'staging', 'history_octane', 'borrower')
         , ('staging', 'star_loan', 'borrower_employee_status_dim', 'staging', 'history_octane', 'borrower')
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'staging', 'history_octane', 'borrower')
         , ('staging', 'star_loan', 'borrower_hmda_ethnicity_dim', 'staging', 'history_octane', 'borrower')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'staging', 'history_octane', 'borrower')
         , ('staging', 'star_loan', 'borrower_hmda_sex_dim', 'staging', 'history_octane', 'borrower')
         , ('staging', 'star_loan', 'borrower_junk_dim', 'staging', 'history_octane', 'borrower')
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'staging', 'history_octane', 'borrower')
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'staging', 'history_octane', 'borrower')
         , ('staging', 'star_loan', 'borrower_relations_dim', 'staging', 'history_octane', 'borrower')
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
    VALUES ('staging', 'star_loan', 'borrower_counseling_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_counseling_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_counseling_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_counseling_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_counseling_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_counseling_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_counseling_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_counseling_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_employee_status_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_employee_status_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_employee_status_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_employee_status_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_employee_status_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_employee_status_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_employee_status_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_employee_status_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'bankruptcy_chapter_7', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'bankruptcy_chapter_7_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'bankruptcy_chapter_11', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'bankruptcy_chapter_11_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'bankruptcy_chapter_12', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'bankruptcy_chapter_12_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'bankruptcy_chapter_13', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'bankruptcy_chapter_13_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'completed_pre_foreclosure_short_sale', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'completed_pre_foreclosure_short_sale_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'conveyed_title_in_lieu_of_foreclosure', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'conveyed_title_in_lieu_of_foreclosure_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'cosigner_undisclosed', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'cosigner_undisclosed_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'currently_delinquent_federal_debt', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'currently_delinquent_federal_debt_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'party_to_lawsuit', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'party_to_lawsuit_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'property_foreclosure', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'property_foreclosure_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_ethnicity_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_ethnicity_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_ethnicity_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_ethnicity_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_ethnicity_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_ethnicity_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_ethnicity_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_ethnicity_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_sex_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_sex_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_sex_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_sex_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_sex_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_sex_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_sex_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_sex_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_junk_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_junk_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_junk_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_junk_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_junk_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_junk_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_junk_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_junk_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_lkup', 'borrower_counseling_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_lkup', 'borrower_employee_status_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_lkup', 'borrower_finances_declarations_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_lkup', 'borrower_hmda_ethnicity_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_lkup', 'borrower_hmda_race_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_lkup', 'borrower_hmda_sex_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_lkup', 'borrower_junk_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_lkup', 'borrower_pre_umdp_declarations_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_lkup', 'borrower_property_declarations_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_lkup', 'borrower_relations_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'applying_for_credit_before_closing', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'applying_for_credit_before_closing_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'borrowed_funds_undisclosed', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'borrowed_funds_undisclosed_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'fha_secondary_residence', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'fha_secondary_residence_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'intend_to_occupy_more_than_14_days', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'intend_to_occupy_more_than_14_days_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'other_mortgage_in_progress_before_closing', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'other_mortgage_in_progress_before_closing_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'priority_given_to_another_lien', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'priority_given_to_another_lien_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'relationship_with_seller', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'relationship_with_seller_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_relations_dim', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_relations_dim', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_relations_dim', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_relations_dim', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_relations_dim', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_relations_dim', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_relations_dim', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_relations_dim', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'loan_fact', 'b1_borrower_counseling_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'loan_fact', 'b1_borrower_employee_status_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'loan_fact', 'b1_borrower_finances_declarations_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'loan_fact', 'b1_borrower_hmda_ethnicity_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'loan_fact', 'b1_borrower_hmda_race_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'loan_fact', 'b1_borrower_hmda_sex_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'loan_fact', 'b1_borrower_junk_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'loan_fact', 'b1_borrower_pre_umdp_declarations_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'loan_fact', 'b1_borrower_property_declarations_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'loan_fact', 'b1_borrower_relations_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'star_loan', 'borrower_counseling_dim', 'first_time_homebuyer_auto_compute_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_first_time_home_buyer_auto_compute')
         , ('staging', 'star_loan', 'borrower_counseling_dim', 'first_time_homebuyer_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_first_time_homebuyer')
         , ('staging', 'star_loan', 'borrower_counseling_dim', 'homeownership_education', 'VARCHAR(1024)', 'staging', 'history_octane', 'homeownership_education_type', 'value')
         , ('staging', 'star_loan', 'borrower_counseling_dim', 'homeownership_education_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_homeownership_education_type')
         , ('staging', 'star_loan', 'borrower_counseling_dim', 'homeownership_education_agency', 'VARCHAR(1024)', 'staging', 'history_octane', 'housing_counseling_agency_type', 'value')
         , ('staging', 'star_loan', 'borrower_counseling_dim', 'homeownership_education_agency_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_homeownership_education_agency_type')
         , ('staging', 'star_loan', 'borrower_counseling_dim', 'housing_counseling', 'VARCHAR(1024)', 'staging', 'history_octane', 'housing_counseling_type', 'value')
         , ('staging', 'star_loan', 'borrower_counseling_dim', 'housing_counseling_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_housing_counseling_type')
         , ('staging', 'star_loan', 'borrower_counseling_dim', 'housing_counseling_agency', 'VARCHAR(1024)', 'staging', 'history_octane', 'housing_counseling_agency_type', 'value')
         , ('staging', 'star_loan', 'borrower_counseling_dim', 'housing_counseling_agency_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_housing_counseling_agency_type')
         , ('staging', 'star_loan', 'borrower_dim', 'schooling_years', 'INTEGER', 'staging', 'history_octane', 'borrower', 'b_schooling_years')
         , ('staging', 'star_loan', 'borrower_dim', 'homeownership_education_complete_date', 'DATE', 'staging', 'history_octane', 'borrower', 'b_homeownership_education_complete_date')
         , ('staging', 'star_loan', 'borrower_employee_status_dim', 'hud_employee_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_hud_employee')
         , ('staging', 'star_loan', 'borrower_employee_status_dim', 'lender_employee', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_employee_status_dim', 'lender_employee_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_lender_employee')
         , ('staging', 'star_loan', 'borrower_employee_status_dim', 'lender_employee_status_confirmed_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_lender_employee_status_confirmed')
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'bankruptcy', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'bankruptcy_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_bankruptcy')
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'outstanding_judgements', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_finances_declarations_dim', 'outstanding_judgements_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_outstanding_judgements')
         , ('staging', 'star_loan', 'borrower_hmda_ethnicity_dim', 'ethnicity_cuban_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_ethnicity_cuban')
         , ('staging', 'star_loan', 'borrower_hmda_ethnicity_dim', 'ethnicity_hispanic_or_latino_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_ethnicity_hispanic_or_latino')
         , ('staging', 'star_loan', 'borrower_hmda_ethnicity_dim', 'ethnicity_mexican_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_ethnicity_mexican')
         , ('staging', 'star_loan', 'borrower_hmda_ethnicity_dim', 'ethnicity_not_hispanic_or_latino_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_ethnicity_not_hispanic_or_latino')
         , ('staging', 'star_loan', 'borrower_hmda_ethnicity_dim', 'ethnicity_other_hispanic_or_latino_description_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_ethnicity_dim', 'ethnicity_other_hispanic_or_latino_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_ethnicity_other_hispanic_or_latino')
         , ('staging', 'star_loan', 'borrower_hmda_ethnicity_dim', 'ethnicity_puerto_rican_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_ethnicity_puerto_rican')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'other_race_national_origin_description_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_american_indian_or_alaska_native_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_american_indian_or_alaska_native')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_asian_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_asian')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_asian_indian_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_asian_indian')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_black_or_african_american_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_black_or_african_american')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_chinese_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_chinese')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_filipino_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_filipino')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_guamanian_or_chamorro_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_guamanian_or_chamorro')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_japanese_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_japanese')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_korean_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_korean')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_native_hawaiian_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_native_hawaiian')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_native_hawaiian_or_other_pacific_islander_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_native_hawaiian_or_other_pacific_islander')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_not_applicable_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_not_applicable')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_other_american_indian_or_alaska_native_description_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_other_asian_description_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_other_asian_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_other_asian')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_other_pacific_islander_description_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_other_pacific_islander_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_other_pacific_islander')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_samoan_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_samoan')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_vietnamese_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_vietnamese')
         , ('staging', 'star_loan', 'borrower_hmda_race_dim', 'race_white_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_race_white')
         , ('staging', 'star_loan', 'borrower_hmda_sex_dim', 'sex_female_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_sex_female')
         , ('staging', 'star_loan', 'borrower_hmda_sex_dim', 'sex_male_flag', 'BOOLEAN', 'staging', 'history_octane', 'borrower', 'b_sex_male')
         , ('staging', 'star_loan', 'borrower_junk_dim', 'citizenship_residency', 'VARCHAR(1024)', 'staging', 'history_octane', 'citizenship_residency_type', 'value')
         , ('staging', 'star_loan', 'borrower_junk_dim', 'citizenship_residency_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_citizenship_residency_type')
         , ('staging', 'star_loan', 'borrower_junk_dim', 'disabled', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_junk_dim', 'disabled_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_disabled')
         , ('staging', 'star_loan', 'borrower_junk_dim', 'on_gsa_list', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_junk_dim', 'on_gsa_list_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_on_gsa_list')
         , ('staging', 'star_loan', 'borrower_junk_dim', 'on_ldp_list', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_junk_dim', 'on_ldp_list_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_on_ldp_list')
         , ('staging', 'star_loan', 'borrower_junk_dim', 'titleholder', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_junk_dim', 'titleholder_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_titleholder')
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'alimony_child_support', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'alimony_child_support_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_alimony_child_support')
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'borrowed_down_payment', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'borrowed_down_payment_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_borrowed_down_payment')
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'note_endorser', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'note_endorser_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_note_endorser')
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'obligated_loan_foreclosure', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'obligated_loan_foreclosure_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_obligated_loan_foreclosure')
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'party_to_lawsuit', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'party_to_lawsuit_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_party_to_lawsuit')
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'presently_delinquent', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'presently_delinquent_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_presently_delinquent')
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'property_foreclosure', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_pre_umdp_declarations_dim', 'property_foreclosure_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_property_foreclosure')
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'homeowner_past_three_years', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'homeowner_past_three_years_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_homeowner_past_three_years')
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'intend_to_occupy', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'intend_to_occupy_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_intend_to_occupy')
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'prior_property_title', 'VARCHAR(1024)', 'staging', 'history_octane', 'prior_property_title_type', 'value')
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'prior_property_title_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_prior_property_title_type')
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'prior_property_usage', 'VARCHAR(1024)', 'staging', 'history_octane', 'property_usage_type', 'value')
         , ('staging', 'star_loan', 'borrower_property_declarations_dim', 'prior_property_usage_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_prior_property_usage_type')
         , ('staging', 'star_loan', 'borrower_relations_dim', 'dependents', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_relations_dim', 'dependents_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_has_dependents')
         , ('staging', 'star_loan', 'borrower_relations_dim', 'domestic_relationship_state', 'VARCHAR(1024)', 'staging', 'history_octane', 'state_type', 'value')
         , ('staging', 'star_loan', 'borrower_relations_dim', 'domestic_relationship_state_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_domestic_relationship_state_type')
         , ('staging', 'star_loan', 'borrower_relations_dim', 'marital_status', 'VARCHAR(1024)', 'staging', 'history_octane', 'marital_status_type', 'value')
         , ('staging', 'star_loan', 'borrower_relations_dim', 'marital_status_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_marital_status_type')
         , ('staging', 'star_loan', 'borrower_relations_dim', 'spousal_homestead', 'VARCHAR(1024)', 'staging', 'history_octane', 'yes_no_unknown_type', 'value')
         , ('staging', 'star_loan', 'borrower_relations_dim', 'spousal_homestead_code', 'VARCHAR(128)', 'staging', 'history_octane', 'borrower', 'b_spousal_homestead')
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
VALUES ('ETL-200030', 'ETL to insert_update records into staging.star_loan.borrower_counseling_dim using staging.history_octane.borrower as the primary source')
     , ('ETL-200031', 'ETL to insert_update records into staging.star_loan.borrower_employee_status_dim using staging.history_octane.borrower as the primary source')
     , ('ETL-200032', 'ETL to insert_update records into staging.star_loan.borrower_finances_declarations_dim using staging.history_octane.borrower as the primary source')
     , ('ETL-200033', 'ETL to insert records into staging.star_loan.borrower_hmda_ethnicity_dim using staging.history_octane.borrower as the primary source')
     , ('ETL-200034', 'ETL to insert records into staging.star_loan.borrower_hmda_race_dim using staging.history_octane.borrower as the primary source')
     , ('ETL-200035', 'ETL to insert records into staging.star_loan.borrower_hmda_sex_dim using staging.history_octane.borrower as the primary source')
     , ('ETL-200036', 'ETL to insert_update records into staging.star_loan.borrower_junk_dim using staging.history_octane.borrower as the primary source')
     , ('ETL-200037', 'ETL to insert_update records into staging.star_loan.borrower_pre_umdp_declarations_dim using staging.history_octane.borrower as the primary source')
     , ('ETL-200038', 'ETL to insert_update records into staging.star_loan.borrower_property_declarations_dim using staging.history_octane.borrower as the primary source')
     , ('ETL-200039', 'ETL to insert_update records into staging.star_loan.borrower_relations_dim using staging.history_octane.borrower as the primary source');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('ETL-200030', 1, 'WITH borrower_counseling_dim_new_records AS (
    SELECT ''first_time_homebuyer_auto_compute_flag~first_time_homebuyer_flag~homeownership_education_code~homeownership_education_agency_code~housing_counseling_code~housing_counseling_agency_code~data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( borrower.b_first_time_home_buyer_auto_compute AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_first_time_homebuyer AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_homeownership_education_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_homeownership_education_agency_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_housing_counseling_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_housing_counseling_agency_type AS TEXT ), ''<NULL>'' ) || ''~1'' AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( borrower.data_source_updated_datetime ) AS data_source_modified_datetime
         , borrower.b_first_time_home_buyer_auto_compute AS first_time_homebuyer_auto_compute_flag
         , borrower.b_first_time_homebuyer AS first_time_homebuyer_flag
         , homeownership_education_type.value AS homeownership_education
         , borrower.b_homeownership_education_type AS homeownership_education_code
         , homeownership_education_agency_type.value AS homeownership_education_agency
         , borrower.b_homeownership_education_agency_type AS homeownership_education_agency_code
         , housing_counseling_type.value AS housing_counseling
         , borrower.b_housing_counseling_type AS housing_counseling_code
         , housing_counseling_agency_type.value AS housing_counseling_agency
         , borrower.b_housing_counseling_agency_type AS housing_counseling_agency_code
         , MAX( GREATEST( homeownership_education_type.etl_end_date_time, homeownership_education_agency_type.etl_end_date_time,
                          housing_counseling_type.etl_end_date_time,
                          housing_counseling_agency_type.etl_end_date_time ) ) AS max_source_etl_end_date_time
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
        SELECT <<homeownership_education_type_partial_load_condition>> AS include_record
             , homeownership_education_type.*
             , etl_log.etl_end_date_time
        FROM history_octane.homeownership_education_type
        LEFT JOIN history_octane.homeownership_education_type AS history_records
                  ON homeownership_education_type.code = history_records.code
                      AND homeownership_education_type.data_source_updated_datetime < history_records.data_source_updated_datetime
        JOIN star_common.etl_log
             ON homeownership_education_type.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.code IS NULL
    ) AS homeownership_education_type
         ON borrower.b_homeownership_education_type = homeownership_education_type.code
    JOIN (
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
    ) AS homeownership_education_agency_type
         ON borrower.b_homeownership_education_agency_type = homeownership_education_agency_type.code
    JOIN (
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
    ) AS housing_counseling_type
         ON borrower.b_housing_counseling_type = housing_counseling_type.code
    JOIN (
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
    ) AS housing_counseling_agency_type
         ON borrower.b_housing_counseling_agency_type = housing_counseling_agency_type.code
    WHERE GREATEST( borrower.include_record, homeownership_education_type.include_record, borrower.include_record,
                    homeownership_education_agency_type.include_record,
                    housing_counseling_type.include_record, housing_counseling_agency_type.include_record ) IS TRUE
    GROUP BY borrower.b_first_time_home_buyer_auto_compute
           , borrower.b_first_time_homebuyer
           , homeownership_education_type.value
           , borrower.b_homeownership_education_type
           , homeownership_education_agency_type.value
           , borrower.b_homeownership_education_agency_type
           , housing_counseling_type.value
           , borrower.b_housing_counseling_type
           , housing_counseling_agency_type.value
           , borrower.b_housing_counseling_agency_type
)
    --new records that should be inserted
SELECT borrower_counseling_dim_new_records.*
FROM borrower_counseling_dim_new_records
LEFT JOIN star_loan.borrower_counseling_dim
          ON borrower_counseling_dim_new_records.data_source_integration_id = borrower_counseling_dim.data_source_integration_id
WHERE borrower_counseling_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT borrower_counseling_dim_new_records.*
FROM borrower_counseling_dim_new_records
JOIN (
    SELECT borrower_counseling_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.borrower_counseling_dim
    JOIN star_common.etl_log
         ON borrower_counseling_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_counseling_dim_etl_start_times
     ON borrower_counseling_dim_new_records.data_source_integration_id =
        borrower_counseling_dim_etl_start_times.data_source_integration_id
         AND borrower_counseling_dim_new_records.max_source_etl_end_date_time >=
             borrower_counseling_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
         , ('ETL-200031', 1, 'WITH borrower_employee_status_dim_new_records AS (
    SELECT ''hud_employee_flag~lender_employee_code~lender_employee_status_confirmed_flag~data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( borrower.b_hud_employee AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_lender_employee AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_lender_employee_status_confirmed AS TEXT ), ''<NULL>'' ) || ''~1'' AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( borrower.data_source_updated_datetime ) AS data_source_modified_datetime
         , borrower.b_hud_employee AS hud_employee_flag
         , lender_employee_type.value AS lender_employee
         , borrower.b_lender_employee AS lender_employee_code
         , borrower.b_lender_employee_status_confirmed AS lender_employee_status_confirmed_flag
         , MAX( lender_employee_type.etl_end_date_time ) AS max_source_etl_end_date_time
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
    ) AS lender_employee_type
         ON borrower.b_lender_employee = lender_employee_type.code
    WHERE GREATEST( borrower.include_record, lender_employee_type.include_record ) IS TRUE
    GROUP BY borrower.b_hud_employee
           , lender_employee_type.value
           , borrower.b_lender_employee
           , borrower.b_lender_employee_status_confirmed
)
    --new records that should be inserted
SELECT borrower_employee_status_dim_new_records.*
FROM borrower_employee_status_dim_new_records
LEFT JOIN star_loan.borrower_employee_status_dim
          ON borrower_employee_status_dim_new_records.data_source_integration_id = borrower_employee_status_dim.data_source_integration_id
WHERE borrower_employee_status_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT borrower_employee_status_dim_new_records.*
FROM borrower_employee_status_dim_new_records
JOIN (
    SELECT borrower_employee_status_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.borrower_employee_status_dim
    JOIN star_common.etl_log
         ON borrower_employee_status_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_employee_status_dim_etl_start_times
     ON borrower_employee_status_dim_new_records.data_source_integration_id =
        borrower_employee_status_dim_etl_start_times.data_source_integration_id
         AND borrower_employee_status_dim_new_records.max_source_etl_end_date_time >=
             borrower_employee_status_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
         , ('ETL-200032', 1, 'WITH borrower_finances_declarations_dim_new_records AS (
    SELECT ''bankruptcy_code~outstanding_judgements_code~bankruptcy_chapter_7_code~bankruptcy_chapter_11_code~bankruptcy_chapter_12_code~bankruptcy_chapter_13_code~completed_pre_foreclosure_short_sale_code~conveyed_title_in_lieu_of_foreclosure_code~cosigner_undisclosed_code~currently_delinquent_federal_debt_code~party_to_lawsuit_code~property_foreclosure_code~data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( borrower.b_bankruptcy AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_outstanding_judgements AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower_declarations.bdec_bankruptcy_chapter_7 AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower_declarations.bdec_bankruptcy_chapter_11 AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower_declarations.bdec_bankruptcy_chapter_12 AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower_declarations.bdec_bankruptcy_chapter_13 AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower_declarations.bdec_completed_pre_foreclosure_short_sale AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower_declarations.bdec_conveyed_title_in_lieu_of_foreclosure AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower_declarations.bdec_cosigner_undisclosed AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower_declarations.bdec_currently_delinquent_federal_debt AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower_declarations.bdec_party_to_lawsuit AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower_declarations.bdec_property_foreclosure AS TEXT ), ''<NULL>'' ) || ''~1'' AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( borrower.data_source_updated_datetime ) AS data_source_modified_datetime
         , bankruptcy_type.value AS bankruptcy
         , borrower.b_bankruptcy AS bankruptcy_code
         , outstanding_judgements_type.value AS outstanding_judgements
         , borrower.b_outstanding_judgements AS outstanding_judgements_code
         , bankruptcy_chapter_7_type.value AS bankruptcy_chapter_7
         , borrower_declarations.bdec_bankruptcy_chapter_7 AS bankruptcy_chapter_7_code
         , bankruptcy_chapter_11_type.value AS bankruptcy_chapter_11
         , borrower_declarations.bdec_bankruptcy_chapter_11 AS bankruptcy_chapter_11_code
         , bankruptcy_chapter_12_type.value AS bankruptcy_chapter_12
         , borrower_declarations.bdec_bankruptcy_chapter_12 AS bankruptcy_chapter_12_code
         , bankruptcy_chapter_13_type.value AS bankruptcy_chapter_13
         , borrower_declarations.bdec_bankruptcy_chapter_13 AS bankruptcy_chapter_13_code
         , completed_pre_foreclosure_short_sale_type.value AS completed_pre_foreclosure_short_sale
         , borrower_declarations.bdec_completed_pre_foreclosure_short_sale AS completed_pre_foreclosure_short_sale_code
         , conveyed_title_in_lieu_of_foreclosure_type.value AS conveyed_title_in_lieu_of_foreclosure
         , borrower_declarations.bdec_conveyed_title_in_lieu_of_foreclosure AS conveyed_title_in_lieu_of_foreclosure_code
         , cosigner_undisclosed_type.value AS cosigner_undisclosed
         , borrower_declarations.bdec_cosigner_undisclosed AS cosigner_undisclosed_code
         , currently_delinquent_federal_debt_type.value AS currently_delinquent_federal_debt
         , borrower_declarations.bdec_currently_delinquent_federal_debt AS currently_delinquent_federal_debt_code
         , party_to_lawsuit_type.value AS party_to_lawsuit
         , borrower_declarations.bdec_party_to_lawsuit AS party_to_lawsuit_code
         , property_foreclosure_type.value AS property_foreclosure
         , borrower_declarations.bdec_property_foreclosure AS property_foreclosure_code
         , MAX( GREATEST( bankruptcy_type.etl_end_date_time, outstanding_judgements_type.etl_end_date_time,
                          bankruptcy_chapter_7_type.etl_end_date_time, bankruptcy_chapter_11_type.etl_end_date_time,
                          bankruptcy_chapter_12_type.etl_end_date_time, bankruptcy_chapter_13_type.etl_end_date_time,
                          completed_pre_foreclosure_short_sale_type.etl_end_date_time,
                          conveyed_title_in_lieu_of_foreclosure_type.etl_end_date_time, cosigner_undisclosed_type.etl_end_date_time,
                          currently_delinquent_federal_debt_type.etl_end_date_time, party_to_lawsuit_type.etl_end_date_time,
                          property_foreclosure_type.etl_end_date_time ) ) AS max_source_etl_end_date_time
    FROM (
        SELECT <<borrower_partial_load_condition>> AS include_record
             , borrower.*
        FROM history_octane.borrower
        LEFT JOIN history_octane.borrower AS history_records
                  ON borrower.b_pid = history_records.b_pid
                      AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.b_pid IS NULL
    ) AS borrower
    LEFT JOIN (
        SELECT <<borrower_declarations_partial_load_condition>> AS include_record
             , borrower_declarations.*
        FROM history_octane.borrower_declarations
        LEFT JOIN history_octane.borrower_declarations AS history_records
                  ON borrower_declarations.bdec_pid = history_records.bdec_pid
                      AND borrower_declarations.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.bdec_pid IS NULL
    ) AS borrower_declarations
              ON borrower.b_pid = borrower_declarations.bdec_borrower_pid
    LEFT JOIN (
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
    ) AS bankruptcy_type
              ON borrower.b_bankruptcy = bankruptcy_type.code
    LEFT JOIN (
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
    ) AS outstanding_judgements_type
              ON borrower.b_outstanding_judgements = outstanding_judgements_type.code
    LEFT JOIN (
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
    ) AS bankruptcy_chapter_7_type
              ON borrower_declarations.bdec_bankruptcy_chapter_7 = bankruptcy_chapter_7_type.code
    LEFT JOIN (
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
    ) AS bankruptcy_chapter_11_type
              ON borrower_declarations.bdec_bankruptcy_chapter_11 = bankruptcy_chapter_11_type.code
    LEFT JOIN (
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
    ) AS bankruptcy_chapter_12_type
              ON borrower_declarations.bdec_bankruptcy_chapter_12 = bankruptcy_chapter_12_type.code
    LEFT JOIN (
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
    ) AS bankruptcy_chapter_13_type
              ON borrower_declarations.bdec_bankruptcy_chapter_13 = bankruptcy_chapter_13_type.code
    LEFT JOIN (
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
    ) AS completed_pre_foreclosure_short_sale_type
              ON borrower_declarations.bdec_completed_pre_foreclosure_short_sale = completed_pre_foreclosure_short_sale_type.code
    LEFT JOIN (
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
    ) AS conveyed_title_in_lieu_of_foreclosure_type
              ON borrower_declarations.bdec_conveyed_title_in_lieu_of_foreclosure = conveyed_title_in_lieu_of_foreclosure_type.code
    LEFT JOIN (
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
    ) AS cosigner_undisclosed_type
              ON borrower_declarations.bdec_cosigner_undisclosed = cosigner_undisclosed_type.code
    LEFT JOIN (
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
    ) AS currently_delinquent_federal_debt_type
              ON borrower_declarations.bdec_currently_delinquent_federal_debt = currently_delinquent_federal_debt_type.code
    LEFT JOIN (
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
    ) AS party_to_lawsuit_type
              ON borrower_declarations.bdec_party_to_lawsuit = party_to_lawsuit_type.code
    LEFT JOIN (
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
    ) AS property_foreclosure_type
              ON borrower_declarations.bdec_property_foreclosure = property_foreclosure_type.code
    WHERE GREATEST( borrower.include_record, borrower_declarations.include_record, bankruptcy_type.include_record,
                    outstanding_judgements_type.include_record, bankruptcy_chapter_7_type.include_record,
                    bankruptcy_chapter_11_type.include_record, bankruptcy_chapter_12_type.include_record,
                    bankruptcy_chapter_13_type.include_record, completed_pre_foreclosure_short_sale_type.include_record,
                    conveyed_title_in_lieu_of_foreclosure_type.include_record, cosigner_undisclosed_type.include_record,
                    currently_delinquent_federal_debt_type.include_record, party_to_lawsuit_type.include_record,
                    property_foreclosure_type.include_record ) IS TRUE
    GROUP BY bankruptcy_type.value
           , borrower.b_bankruptcy
           , outstanding_judgements_type.value
           , borrower.b_outstanding_judgements
           , bankruptcy_chapter_7_type.value
           , borrower_declarations.bdec_bankruptcy_chapter_7
           , bankruptcy_chapter_11_type.value
           , borrower_declarations.bdec_bankruptcy_chapter_11
           , bankruptcy_chapter_12_type.value
           , borrower_declarations.bdec_bankruptcy_chapter_12
           , bankruptcy_chapter_13_type.value
           , borrower_declarations.bdec_bankruptcy_chapter_13
           , completed_pre_foreclosure_short_sale_type.value
           , borrower_declarations.bdec_completed_pre_foreclosure_short_sale
           , conveyed_title_in_lieu_of_foreclosure_type.value
           , borrower_declarations.bdec_conveyed_title_in_lieu_of_foreclosure
           , cosigner_undisclosed_type.value
           , borrower_declarations.bdec_cosigner_undisclosed
           , currently_delinquent_federal_debt_type.value
           , borrower_declarations.bdec_currently_delinquent_federal_debt
           , party_to_lawsuit_type.value
           , borrower_declarations.bdec_party_to_lawsuit
           , property_foreclosure_type.value
           , borrower_declarations.bdec_property_foreclosure
)
    --new records that should be inserted
SELECT borrower_finances_declarations_dim_new_records.*
FROM borrower_finances_declarations_dim_new_records
LEFT JOIN star_loan.borrower_finances_declarations_dim
          ON borrower_finances_declarations_dim_new_records.data_source_integration_id =
             borrower_finances_declarations_dim.data_source_integration_id
WHERE borrower_finances_declarations_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT borrower_finances_declarations_dim_new_records.*
FROM borrower_finances_declarations_dim_new_records
JOIN (
    SELECT borrower_finances_declarations_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.borrower_finances_declarations_dim
    JOIN star_common.etl_log
         ON borrower_finances_declarations_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_finances_declarations_dim_etl_start_times
     ON borrower_finances_declarations_dim_new_records.data_source_integration_id =
        borrower_finances_declarations_dim_etl_start_times.data_source_integration_id
         AND borrower_finances_declarations_dim_new_records.max_source_etl_end_date_time >=
             borrower_finances_declarations_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
         , ('ETL-200033', 1, 'WITH borrower_hmda_ethnicity_dim_new_records AS (
    SELECT ''ethnicity_cuban_flag~ethnicity_hispanic_or_latino_flag~ethnicity_mexican_flag~ethnicity_not_hispanic_or_latino_flag~ethnicity_other_hispanic_or_latino_description_flag~ethnicity_other_hispanic_or_latino_flag~ethnicity_puerto_rican_flag~data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( borrower.b_ethnicity_cuban AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_ethnicity_hispanic_or_latino AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_ethnicity_mexican AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_ethnicity_not_hispanic_or_latino AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_ethnicity_other_hispanic_or_latino_description <> '''' AND
                           borrower.b_ethnicity_other_hispanic_or_latino_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_ethnicity_other_hispanic_or_latino AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_ethnicity_puerto_rican AS TEXT ), ''<NULL>'' ) || ''~1'' AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( borrower.data_source_updated_datetime ) AS data_source_modified_datetime
         , borrower.b_ethnicity_cuban AS ethnicity_cuban_flag
         , borrower.b_ethnicity_hispanic_or_latino AS ethnicity_hispanic_or_latino_flag
         , borrower.b_ethnicity_mexican AS ethnicity_mexican_flag
         , borrower.b_ethnicity_not_hispanic_or_latino AS ethnicity_not_hispanic_or_latino_flag
         , borrower.b_ethnicity_other_hispanic_or_latino_description <> '''' AND
           borrower.b_ethnicity_other_hispanic_or_latino_description IS NOT NULL AS ethnicity_other_hispanic_or_latino_description_flag
         , borrower.b_ethnicity_other_hispanic_or_latino AS ethnicity_other_hispanic_or_latino_flag
         , borrower.b_ethnicity_puerto_rican AS ethnicity_puerto_rican_flag
    FROM (
        SELECT borrower.*
        FROM history_octane.borrower
        LEFT JOIN history_octane.borrower AS history_records
                  ON borrower.b_pid = history_records.b_pid
                      AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.b_pid IS NULL
          AND <<borrower_partial_load_condition>>
    ) AS borrower
    GROUP BY borrower.b_ethnicity_cuban
           , borrower.b_ethnicity_hispanic_or_latino
           , borrower.b_ethnicity_mexican
           , borrower.b_ethnicity_not_hispanic_or_latino
           , borrower.b_ethnicity_other_hispanic_or_latino_description <> '''' AND
             borrower.b_ethnicity_other_hispanic_or_latino_description IS NOT NULL
           , borrower.b_ethnicity_other_hispanic_or_latino
           , borrower.b_ethnicity_puerto_rican
)
SELECT borrower_hmda_ethnicity_dim_new_records.*
FROM borrower_hmda_ethnicity_dim_new_records
LEFT JOIN star_loan.borrower_hmda_ethnicity_dim
          ON borrower_hmda_ethnicity_dim_new_records.data_source_integration_id = borrower_hmda_ethnicity_dim.data_source_integration_id
WHERE borrower_hmda_ethnicity_dim.dwid IS NULL;', 'Staging DB Connection')
         , ('ETL-200034', 1, 'WITH borrower_hmda_race_dim_new_records AS (
    SELECT ''other_race_national_origin_description_flag~race_american_indian_or_alaska_native_flag~race_asian_flag~race_asian_indian_flag~race_black_or_african_american_flag~race_chinese_flag~race_filipino_flag~race_guamanian_or_chamorro_flag~race_japanese_flag~race_korean_flag~race_native_hawaiian_flag~race_native_hawaiian_or_other_pacific_islander_flag~race_not_applicable_flag~race_other_american_indian_or_alaska_native_description_flag~race_other_asian_description_flag~race_other_asian_flag~race_other_pacific_islander_description_flag~race_other_pacific_islander_flag~race_samoan_flag~race_vietnamese_flag~race_white_flag~data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( borrower.b_other_race_national_origin_description <> '''' AND
                           borrower.b_other_race_national_origin_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_american_indian_or_alaska_native AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_asian AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_asian_indian AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_black_or_african_american AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_chinese AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_filipino AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_guamanian_or_chamorro AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_japanese AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_korean AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_native_hawaiian AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_native_hawaiian_or_other_pacific_islander AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_not_applicable AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_other_american_indian_or_alaska_native_description <> '''' AND
                           borrower.b_race_other_american_indian_or_alaska_native_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_other_asian_description <> '''' AND
                           borrower.b_race_other_asian_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_other_asian AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_other_pacific_islander_description <> '''' AND
                           borrower.b_race_other_pacific_islander_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_other_pacific_islander AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_samoan AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_vietnamese AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_race_white AS TEXT ), ''<NULL>'' ) || ''~1'' AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( borrower.data_source_updated_datetime ) AS data_source_modified_datetime
         , borrower.b_other_race_national_origin_description <> '''' AND
           borrower.b_other_race_national_origin_description IS NOT NULL AS other_race_national_origin_description_flag
         , borrower.b_race_american_indian_or_alaska_native AS race_american_indian_or_alaska_native_flag
         , borrower.b_race_asian AS race_asian_flag
         , borrower.b_race_asian_indian AS race_asian_indian_flag
         , borrower.b_race_black_or_african_american AS race_black_or_african_american_flag
         , borrower.b_race_chinese AS race_chinese_flag
         , borrower.b_race_filipino AS race_filipino_flag
         , borrower.b_race_guamanian_or_chamorro AS race_guamanian_or_chamorro_flag
         , borrower.b_race_japanese AS race_japanese_flag
         , borrower.b_race_korean AS race_korean_flag
         , borrower.b_race_native_hawaiian AS race_native_hawaiian_flag
         , borrower.b_race_native_hawaiian_or_other_pacific_islander AS race_native_hawaiian_or_other_pacific_islander_flag
         , borrower.b_race_not_applicable AS race_not_applicable_flag
         , borrower.b_race_other_american_indian_or_alaska_native_description <> '''' AND
           borrower.b_race_other_american_indian_or_alaska_native_description IS NOT NULL AS race_other_american_indian_or_alaska_native_description_flag
         , borrower.b_race_other_asian_description <> '''' AND
           borrower.b_race_other_asian_description IS NOT NULL AS race_other_asian_description_flag
         , borrower.b_race_other_asian AS race_other_asian_flag
         , borrower.b_race_other_pacific_islander_description <> '''' AND
           borrower.b_race_other_pacific_islander_description IS NOT NULL AS race_other_pacific_islander_description_flag
         , borrower.b_race_other_pacific_islander AS race_other_pacific_islander_flag
         , borrower.b_race_samoan AS race_samoan_flag
         , borrower.b_race_vietnamese AS race_vietnamese_flag
         , borrower.b_race_white AS race_white_flag
    FROM (
        SELECT borrower.*
        FROM history_octane.borrower
        LEFT JOIN history_octane.borrower AS history_records
                  ON borrower.b_pid = history_records.b_pid
                      AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.b_pid IS NULL
          AND <<borrower_partial_load_condition>>
    ) AS borrower
    GROUP BY borrower.b_other_race_national_origin_description <> '''' AND
             borrower.b_other_race_national_origin_description IS NOT NULL
           , borrower.b_race_american_indian_or_alaska_native
           , borrower.b_race_asian
           , borrower.b_race_asian_indian
           , borrower.b_race_black_or_african_american
           , borrower.b_race_chinese
           , borrower.b_race_filipino
           , borrower.b_race_guamanian_or_chamorro
           , borrower.b_race_japanese
           , borrower.b_race_korean
           , borrower.b_race_native_hawaiian
           , borrower.b_race_native_hawaiian_or_other_pacific_islander
           , borrower.b_race_not_applicable
           , borrower.b_race_other_american_indian_or_alaska_native_description <> '''' AND
             borrower.b_race_other_american_indian_or_alaska_native_description IS NOT NULL
           , borrower.b_race_other_asian_description <> '''' AND
             borrower.b_race_other_asian_description IS NOT NULL
           , borrower.b_race_other_asian
           , borrower.b_race_other_pacific_islander_description <> '''' AND
             borrower.b_race_other_pacific_islander_description IS NOT NULL
           , borrower.b_race_other_pacific_islander
           , borrower.b_race_samoan
           , borrower.b_race_vietnamese
           , borrower.b_race_white
)
SELECT borrower_hmda_race_dim_new_records.*
FROM borrower_hmda_race_dim_new_records
LEFT JOIN star_loan.borrower_hmda_race_dim
          ON borrower_hmda_race_dim_new_records.data_source_integration_id = borrower_hmda_race_dim.data_source_integration_id
WHERE borrower_hmda_race_dim.dwid IS NULL;', 'Staging DB Connection')
         , ('ETL-200035', 1, 'WITH borrower_hmda_sex_dim_new_records AS (
    SELECT ''sex_female_flag~sex_male_flag~data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( borrower.b_sex_female AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_sex_male AS TEXT ), ''<NULL>'' ) || ''~1'' AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( borrower.data_source_updated_datetime ) AS data_source_modified_datetime
         , borrower.b_sex_female AS sex_female_flag
         , borrower.b_sex_male AS sex_male_flag
    FROM (
        SELECT borrower.*
        FROM history_octane.borrower
        LEFT JOIN history_octane.borrower AS history_records
                  ON borrower.b_pid = history_records.b_pid
                      AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.b_pid IS NULL
          AND <<borrower_partial_load_condition>>
    ) AS borrower
    GROUP BY borrower.b_sex_female, borrower.b_sex_male
)
SELECT borrower_hmda_sex_dim_new_records.*
FROM borrower_hmda_sex_dim_new_records
LEFT JOIN star_loan.borrower_hmda_sex_dim
          ON borrower_hmda_sex_dim_new_records.data_source_integration_id = borrower_hmda_sex_dim.data_source_integration_id
WHERE borrower_hmda_sex_dim.dwid IS NULL;', 'Staging DB Connection')
         , ('ETL-200036', 1, 'WITH borrower_junk_dim_new_records AS (
    SELECT ''citizenship_residency_code~disabled_code~on_gsa_list_code~on_ldp_list_code~titleholder_code~data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( borrower.b_citizenship_residency_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_disabled AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_on_gsa_list AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_on_ldp_list AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_titleholder AS TEXT ), ''<NULL>'' ) || ''~1'' AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( borrower.data_source_updated_datetime ) AS data_source_modified_datetime
         , citizenship_residency_type.value AS citizenship_residency
         , borrower.b_citizenship_residency_type AS citizenship_residency_code
         , disabled_type.value AS disabled
         , borrower.b_disabled AS disabled_code
         , on_gsa_list_type.value AS on_gsa_list
         , borrower.b_on_gsa_list AS on_gsa_list_code
         , on_ldp_list_type.value AS on_ldp_list
         , borrower.b_on_ldp_list AS on_ldp_list_code
         , titleholder_type.value AS titleholder
         , borrower.b_titleholder AS titleholder_code
         , MAX( GREATEST( citizenship_residency_type.etl_end_date_time, disabled_type.etl_end_date_time, on_gsa_list_type.etl_end_date_time,
                          on_ldp_list_type.etl_end_date_time, titleholder_type.etl_end_date_time ) ) AS max_source_etl_end_date_time
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
        SELECT <<citizenship_residency_type_partial_load_condition>> AS include_record
             , citizenship_residency_type.*
             , etl_log.etl_end_date_time
        FROM history_octane.citizenship_residency_type
        LEFT JOIN history_octane.citizenship_residency_type AS history_records
                  ON citizenship_residency_type.code = history_records.code
                      AND citizenship_residency_type.data_source_updated_datetime < history_records.data_source_updated_datetime
        JOIN star_common.etl_log
             ON citizenship_residency_type.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.code IS NULL
    ) AS citizenship_residency_type
         ON borrower.b_citizenship_residency_type = citizenship_residency_type.code
    JOIN (
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
    ) AS disabled_type
         ON borrower.b_disabled = disabled_type.code
    JOIN (
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
    ) AS on_gsa_list_type
         ON borrower.b_on_gsa_list = on_gsa_list_type.code
    JOIN (
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
    ) AS on_ldp_list_type
         ON borrower.b_on_ldp_list = on_ldp_list_type.code
    JOIN (
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
    ) AS titleholder_type
         ON borrower.b_titleholder = titleholder_type.code
    WHERE GREATEST( borrower.include_record, citizenship_residency_type.include_record, disabled_type.include_record,
                    on_gsa_list_type.include_record, on_ldp_list_type.include_record, titleholder_type.include_record ) IS TRUE
    GROUP BY citizenship_residency_type.value
           , borrower.b_citizenship_residency_type
           , disabled_type.value
           , borrower.b_disabled
           , on_gsa_list_type.value
           , borrower.b_on_gsa_list
           , on_ldp_list_type.value
           , borrower.b_on_ldp_list
           , titleholder_type.value
           , borrower.b_titleholder
)
    --new records that should be inserted
SELECT borrower_junk_dim_new_records.*
FROM borrower_junk_dim_new_records
LEFT JOIN star_loan.borrower_junk_dim
          ON borrower_junk_dim_new_records.data_source_integration_id = borrower_junk_dim.data_source_integration_id
WHERE borrower_junk_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT borrower_junk_dim_new_records.*
FROM borrower_junk_dim_new_records
JOIN (
    SELECT borrower_junk_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.borrower_junk_dim
    JOIN star_common.etl_log
         ON borrower_junk_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_junk_dim_etl_start_times
     ON borrower_junk_dim_new_records.data_source_integration_id =
        borrower_junk_dim_etl_start_times.data_source_integration_id
         AND borrower_junk_dim_new_records.max_source_etl_end_date_time >=
             borrower_junk_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
         , ('ETL-200037', 1, 'WITH borrower_pre_umdp_declarations_dim_new_records AS (
    SELECT ''alimony_child_support_code~borrowed_down_payment_code~note_endorser_code~obligated_loan_foreclosure_code~party_to_lawsuit_code~presently_delinquent_code~property_foreclosure_code~data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( borrower.b_alimony_child_support AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_borrowed_down_payment AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_note_endorser AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_obligated_loan_foreclosure AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_party_to_lawsuit AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_presently_delinquent AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_property_foreclosure AS TEXT ), ''<NULL>'' ) || ''~1'' AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( borrower.data_source_updated_datetime ) AS data_source_modified_datetime
         , alimony_child_support_type.value AS alimony_child_support
         , borrower.b_alimony_child_support AS alimony_child_support_code
         , borrowed_down_payment_type.value AS borrowed_down_payment
         , borrower.b_borrowed_down_payment AS borrowed_down_payment_code
         , note_endorser_type.value AS note_endorser
         , borrower.b_note_endorser AS note_endorser_code
         , obligated_loan_foreclosure_type.value AS obligated_loan_foreclosure
         , borrower.b_obligated_loan_foreclosure AS obligated_loan_foreclosure_code
         , party_to_lawsuit_type.value AS party_to_lawsuit
         , borrower.b_party_to_lawsuit AS party_to_lawsuit_code
         , presently_delinquent_type.value AS presently_delinquent
         , borrower.b_presently_delinquent AS presently_delinquent_code
         , property_foreclosure_type.value AS property_foreclosure
         , borrower.b_property_foreclosure AS property_foreclosure_code
         , MAX( GREATEST( alimony_child_support_type.etl_end_date_time, borrowed_down_payment_type.etl_end_date_time,
                          note_endorser_type.etl_end_date_time, obligated_loan_foreclosure_type.etl_end_date_time,
                          party_to_lawsuit_type.etl_end_date_time, presently_delinquent_type.etl_end_date_time,
                          property_foreclosure_type.etl_end_date_time ) ) AS max_source_etl_end_date_time
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
    ) AS alimony_child_support_type
         ON borrower.b_alimony_child_support = alimony_child_support_type.code
    JOIN (
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
    ) AS borrowed_down_payment_type
         ON borrower.b_borrowed_down_payment = borrowed_down_payment_type.code
    JOIN (
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
    ) AS note_endorser_type
         ON borrower.b_note_endorser = note_endorser_type.code
    JOIN (
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
    ) AS obligated_loan_foreclosure_type
         ON borrower.b_obligated_loan_foreclosure = obligated_loan_foreclosure_type.code
    JOIN (
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
    ) AS party_to_lawsuit_type
         ON borrower.b_party_to_lawsuit = party_to_lawsuit_type.code
    JOIN (
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
    ) AS presently_delinquent_type
         ON borrower.b_presently_delinquent = presently_delinquent_type.code
    JOIN (
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
    ) AS property_foreclosure_type
         ON borrower.b_property_foreclosure = property_foreclosure_type.code
    WHERE GREATEST( borrower.include_record, alimony_child_support_type.include_record, borrowed_down_payment_type.include_record,
                    note_endorser_type.include_record, obligated_loan_foreclosure_type.include_record, party_to_lawsuit_type.include_record,
                    presently_delinquent_type.include_record, property_foreclosure_type.include_record ) IS TRUE
    GROUP BY alimony_child_support_type.value
           , borrower.b_alimony_child_support
           , borrowed_down_payment_type.value
           , borrower.b_borrowed_down_payment
           , note_endorser_type.value
           , borrower.b_note_endorser
           , obligated_loan_foreclosure_type.value
           , borrower.b_obligated_loan_foreclosure
           , party_to_lawsuit_type.value
           , borrower.b_party_to_lawsuit
           , presently_delinquent_type.value
           , borrower.b_presently_delinquent
           , property_foreclosure_type.value
           , borrower.b_property_foreclosure
)
    --new records that should be inserted
SELECT borrower_pre_umdp_declarations_dim_new_records.*
FROM borrower_pre_umdp_declarations_dim_new_records
LEFT JOIN star_loan.borrower_pre_umdp_declarations_dim
          ON borrower_pre_umdp_declarations_dim_new_records.data_source_integration_id =
             borrower_pre_umdp_declarations_dim.data_source_integration_id
WHERE borrower_pre_umdp_declarations_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT borrower_pre_umdp_declarations_dim_new_records.*
FROM borrower_pre_umdp_declarations_dim_new_records
JOIN (
    SELECT borrower_pre_umdp_declarations_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.borrower_pre_umdp_declarations_dim
    JOIN star_common.etl_log
         ON borrower_pre_umdp_declarations_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_pre_umdp_declarations_dim_etl_start_times
     ON borrower_pre_umdp_declarations_dim_new_records.data_source_integration_id =
        borrower_pre_umdp_declarations_dim_etl_start_times.data_source_integration_id
         AND borrower_pre_umdp_declarations_dim_new_records.max_source_etl_end_date_time >=
             borrower_pre_umdp_declarations_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
         , ('ETL-200038', 1, 'WITH borrower_property_declarations_dim_new_records AS (
    SELECT ''applying_for_credit_before_closing_code~borrowed_funds_undisclosed_code~fha_secondary_residence_code~homeowner_past_three_years_code~intend_to_occupy_code~intend_to_occupy_more_than_14_days_code~other_mortgage_in_progress_before_closing_code~prior_property_title_code~prior_property_usage_code~priority_given_to_another_lien_code~relationship_with_seller_code~data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( borrower_declarations.bdec_applying_for_credit_before_closing AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower_declarations.bdec_borrowed_funds_undisclosed AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower_declarations.bdec_fha_secondary_residence AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_homeowner_past_three_years AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_intend_to_occupy AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower_declarations.bdec_intend_to_occupy_more_than_14_days AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower_declarations.bdec_other_mortgage_in_progress_before_closing AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_prior_property_title_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_prior_property_usage_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower_declarations.bdec_priority_given_to_another_lien AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower_declarations.bdec_relationship_with_seller AS TEXT ), ''<NULL>'' ) || ''~1'' AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( borrower.data_source_updated_datetime ) AS data_source_modified_datetime
         , applying_for_credit_before_closing_type.value AS applying_for_credit_before_closing
         , borrower_declarations.bdec_applying_for_credit_before_closing AS applying_for_credit_before_closing_code
         , borrowed_funds_undisclosed_type.value AS borrowed_funds_undisclosed
         , borrower_declarations.bdec_borrowed_funds_undisclosed AS borrowed_funds_undisclosed_code
         , fha_secondary_residence_type.value AS fha_secondary_residence
         , borrower_declarations.bdec_fha_secondary_residence AS fha_secondary_residence_code
         , homeowner_past_three_years_type.value AS homeowner_past_three_years
         , borrower.b_homeowner_past_three_years AS homeowner_past_three_years_code
         , intend_to_occupy_type.value AS intend_to_occupy
         , borrower.b_intend_to_occupy AS intend_to_occupy_code
         , intend_to_occupy_more_than_14_days_type.value AS intend_to_occupy_more_than_14_days
         , borrower_declarations.bdec_intend_to_occupy_more_than_14_days AS intend_to_occupy_more_than_14_days_code
         , other_mortgage_in_progress_before_closing_type.value AS other_mortgage_in_progress_before_closing
         , borrower_declarations.bdec_other_mortgage_in_progress_before_closing AS other_mortgage_in_progress_before_closing_code
         , prior_property_title_type.value AS prior_property_title
         , borrower.b_prior_property_title_type AS prior_property_title_code
         , property_usage_type.value AS prior_property_usage
         , borrower.b_prior_property_usage_type AS prior_property_usage_code
         , priority_given_to_another_lien_type.value AS priority_given_to_another_lien
         , borrower_declarations.bdec_priority_given_to_another_lien AS priority_given_to_another_lien_code
         , relationship_with_seller_type.value AS relationship_with_seller
         , borrower_declarations.bdec_relationship_with_seller AS relationship_with_seller_code
         , MAX( GREATEST( applying_for_credit_before_closing_type.etl_end_date_time, borrowed_funds_undisclosed_type.etl_end_date_time,
                          fha_secondary_residence_type.etl_end_date_time, homeowner_past_three_years_type.etl_end_date_time,
                          intend_to_occupy_type.etl_end_date_time, intend_to_occupy_more_than_14_days_type.etl_end_date_time,
                          other_mortgage_in_progress_before_closing_type.etl_end_date_time, prior_property_title_type.etl_end_date_time,
                          property_usage_type.etl_end_date_time, priority_given_to_another_lien_type.etl_end_date_time,
                          relationship_with_seller_type.etl_end_date_time ) ) AS max_source_etl_end_date_time
    FROM (
        SELECT <<borrower_partial_load_condition>> AS include_record
             , borrower.*
        FROM history_octane.borrower
        LEFT JOIN history_octane.borrower AS history_records
                  ON borrower.b_pid = history_records.b_pid
                      AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.b_pid IS NULL
    ) AS borrower
    LEFT JOIN (
        SELECT <<borrower_declarations_partial_load_condition>> AS include_record
             , borrower_declarations.*
        FROM history_octane.borrower_declarations
        LEFT JOIN history_octane.borrower_declarations AS history_records
                  ON borrower_declarations.bdec_pid = history_records.bdec_pid
                      AND borrower_declarations.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.bdec_pid IS NULL
    ) AS borrower_declarations
              ON borrower.b_pid = borrower_declarations.bdec_borrower_pid
    LEFT JOIN (
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
    ) AS applying_for_credit_before_closing_type
              ON borrower_declarations.bdec_applying_for_credit_before_closing = applying_for_credit_before_closing_type.code
    LEFT JOIN (
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
    ) AS borrowed_funds_undisclosed_type
              ON borrower_declarations.bdec_borrowed_funds_undisclosed = borrowed_funds_undisclosed_type.code
    LEFT JOIN (
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
    ) AS fha_secondary_residence_type
              ON borrower_declarations.bdec_fha_secondary_residence = fha_secondary_residence_type.code
    LEFT JOIN (
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
    ) AS homeowner_past_three_years_type
              ON borrower.b_homeowner_past_three_years = homeowner_past_three_years_type.code
    LEFT JOIN (
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
    ) AS intend_to_occupy_type
              ON borrower.b_intend_to_occupy = intend_to_occupy_type.code
    LEFT JOIN (
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
    ) AS intend_to_occupy_more_than_14_days_type
              ON borrower_declarations.bdec_intend_to_occupy_more_than_14_days = intend_to_occupy_more_than_14_days_type.code
    LEFT JOIN (
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
    ) AS other_mortgage_in_progress_before_closing_type
              ON borrower_declarations.bdec_other_mortgage_in_progress_before_closing = other_mortgage_in_progress_before_closing_type.code
    LEFT JOIN (
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
    ) AS prior_property_title_type
              ON borrower.b_prior_property_title_type = prior_property_title_type.code
    LEFT JOIN (
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
    ) AS property_usage_type
              ON borrower.b_prior_property_usage_type = property_usage_type.code
    LEFT JOIN (
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
    ) AS priority_given_to_another_lien_type
              ON borrower_declarations.bdec_priority_given_to_another_lien = priority_given_to_another_lien_type.code
    LEFT JOIN (
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
    ) AS relationship_with_seller_type
              ON borrower_declarations.bdec_relationship_with_seller = relationship_with_seller_type.code
    WHERE GREATEST( applying_for_credit_before_closing_type.include_record, borrowed_funds_undisclosed_type.include_record,
                    fha_secondary_residence_type.include_record, homeowner_past_three_years_type.include_record,
                    intend_to_occupy_type.include_record, intend_to_occupy_more_than_14_days_type.include_record,
                    other_mortgage_in_progress_before_closing_type.include_record, prior_property_title_type.include_record,
                    property_usage_type.include_record, borrower.include_record, priority_given_to_another_lien_type.include_record,
                    relationship_with_seller_type.include_record, borrower_declarations.include_record ) IS TRUE
    GROUP BY applying_for_credit_before_closing_type.value
           , borrower_declarations.bdec_applying_for_credit_before_closing
           , borrowed_funds_undisclosed_type.value
           , borrower_declarations.bdec_borrowed_funds_undisclosed
           , fha_secondary_residence_type.value
           , borrower_declarations.bdec_fha_secondary_residence
           , homeowner_past_three_years_type.value
           , borrower.b_homeowner_past_three_years
           , intend_to_occupy_type.value
           , borrower.b_intend_to_occupy
           , intend_to_occupy_more_than_14_days_type.value
           , borrower_declarations.bdec_intend_to_occupy_more_than_14_days
           , other_mortgage_in_progress_before_closing_type.value
           , borrower_declarations.bdec_other_mortgage_in_progress_before_closing
           , prior_property_title_type.value
           , borrower.b_prior_property_title_type
           , property_usage_type.value
           , borrower.b_prior_property_usage_type
           , priority_given_to_another_lien_type.value
           , borrower_declarations.bdec_priority_given_to_another_lien
           , relationship_with_seller_type.value
           , borrower_declarations.bdec_relationship_with_seller
)
    --new records that should be inserted
SELECT borrower_property_declarations_dim_new_records.*
FROM borrower_property_declarations_dim_new_records
LEFT JOIN star_loan.borrower_property_declarations_dim
          ON borrower_property_declarations_dim_new_records.data_source_integration_id =
             borrower_property_declarations_dim.data_source_integration_id
WHERE borrower_property_declarations_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT borrower_property_declarations_dim_new_records.*
FROM borrower_property_declarations_dim_new_records
JOIN (
    SELECT borrower_property_declarations_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.borrower_property_declarations_dim
    JOIN star_common.etl_log
         ON borrower_property_declarations_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_property_declarations_dim_etl_start_times
     ON borrower_property_declarations_dim_new_records.data_source_integration_id =
        borrower_property_declarations_dim_etl_start_times.data_source_integration_id
         AND borrower_property_declarations_dim_new_records.max_source_etl_end_date_time >=
             borrower_property_declarations_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
         , ('ETL-200039', 1, 'WITH borrower_relations_dim_new_records AS (
    SELECT ''dependents_code~domestic_relationship_state_code~marital_status_code~spousal_homestead_code~data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( borrower.b_has_dependents AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_domestic_relationship_state_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_marital_status_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( borrower.b_spousal_homestead AS TEXT ), ''<NULL>'' ) || ''~1'' AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( borrower.data_source_updated_datetime ) AS data_source_modified_datetime
         , dependents_type.value AS dependents
         , borrower.b_has_dependents AS dependents_code
         , state_type.value AS domestic_relationship_state
         , borrower.b_domestic_relationship_state_type AS domestic_relationship_state_code
         , marital_status_type.value AS marital_status
         , borrower.b_marital_status_type AS marital_status_code
         , spousal_homestead_type.value AS spousal_homestead
         , borrower.b_spousal_homestead AS spousal_homestead_code
         , MAX( GREATEST( dependents_type.etl_end_date_time, state_type.etl_end_date_time, marital_status_type.etl_end_date_time,
                          spousal_homestead_type.etl_end_date_time ) ) AS max_source_etl_end_date_time
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
    ) AS dependents_type
         ON borrower.b_has_dependents = dependents_type.code
    LEFT JOIN (
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
    ) AS state_type
              ON borrower.b_domestic_relationship_state_type = state_type.code
    JOIN (
        SELECT <<marital_status_type_partial_load_condition>> AS include_record
             , marital_status_type.*
             , etl_log.etl_end_date_time
        FROM history_octane.marital_status_type
        LEFT JOIN history_octane.marital_status_type AS history_records
                  ON marital_status_type.code = history_records.code
                      AND marital_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
        JOIN star_common.etl_log
             ON marital_status_type.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.code IS NULL
    ) AS marital_status_type
         ON borrower.b_marital_status_type = marital_status_type.code
    JOIN (
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
    ) AS spousal_homestead_type
         ON borrower.b_spousal_homestead = spousal_homestead_type.code
    WHERE GREATEST( borrower.include_record, dependents_type.include_record, state_type.include_record, marital_status_type.include_record,
                    spousal_homestead_type.include_record ) IS TRUE
    GROUP BY dependents_type.value
           , borrower.b_has_dependents
           , state_type.value
           , borrower.b_domestic_relationship_state_type
           , marital_status_type.value
           , borrower.b_marital_status_type
           , spousal_homestead_type.value
           , borrower.b_spousal_homestead
)
    --new records that should be inserted
SELECT borrower_relations_dim_new_records.*
FROM borrower_relations_dim_new_records
LEFT JOIN star_loan.borrower_relations_dim
          ON borrower_relations_dim_new_records.data_source_integration_id =
             borrower_relations_dim.data_source_integration_id
WHERE borrower_relations_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT borrower_relations_dim_new_records.*
FROM borrower_relations_dim_new_records
JOIN (
    SELECT borrower_relations_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.borrower_relations_dim
    JOIN star_common.etl_log
         ON borrower_relations_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_relations_dim_etl_start_times
     ON borrower_relations_dim_new_records.data_source_integration_id =
        borrower_relations_dim_etl_start_times.data_source_integration_id
         AND borrower_relations_dim_new_records.max_source_etl_end_date_time >=
             borrower_relations_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
)
INSERT
INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
SELECT process.dwid, insert_rows.data_source_dwid, insert_rows.sql, 0, 'N', 'N', 'N', 'N', insert_rows.connectionname::mdi.pentaho_db_connection_name
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--table_output_step
WITH insert_rows (process_name, target_schema, target_table, truncate_table, connectionname) AS (
    VALUES ('ETL-200033', 'star_loan', 'borrower_hmda_ethnicity_dim', 'N', 'Staging DB Connection')
         , ('ETL-200034', 'star_loan', 'borrower_hmda_race_dim', 'N', 'Staging DB Connection')
         , ('ETL-200035', 'star_loan', 'borrower_hmda_sex_dim', 'N', 'Staging DB Connection')
)
INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT process.dwid, insert_rows.target_schema, insert_rows.target_table, 1000, NULL, NULL, NULL, NULL, 'N', NULL, insert_rows.truncate_table::mdi.pentaho_y_or_n, insert_rows.connectionname, 'N', 'Y', 'N', 'N'
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('ETL-200033', 'data_source_dwid')
         , ('ETL-200033', 'edw_created_datetime')
         , ('ETL-200033', 'edw_modified_datetime')
         , ('ETL-200033', 'etl_batch_id')
         , ('ETL-200033', 'data_source_integration_columns')
         , ('ETL-200033', 'data_source_integration_id')
         , ('ETL-200033', 'data_source_modified_datetime')
         , ('ETL-200033', 'ethnicity_cuban_flag')
         , ('ETL-200033', 'ethnicity_hispanic_or_latino_flag')
         , ('ETL-200033', 'ethnicity_mexican_flag')
         , ('ETL-200033', 'ethnicity_not_hispanic_or_latino_flag')
         , ('ETL-200033', 'ethnicity_other_hispanic_or_latino_description_flag')
         , ('ETL-200033', 'ethnicity_other_hispanic_or_latino_flag')
         , ('ETL-200033', 'ethnicity_puerto_rican_flag')
         , ('ETL-200034', 'data_source_dwid')
         , ('ETL-200034', 'edw_created_datetime')
         , ('ETL-200034', 'edw_modified_datetime')
         , ('ETL-200034', 'etl_batch_id')
         , ('ETL-200034', 'data_source_integration_columns')
         , ('ETL-200034', 'data_source_integration_id')
         , ('ETL-200034', 'data_source_modified_datetime')
         , ('ETL-200034', 'other_race_national_origin_description_flag')
         , ('ETL-200034', 'race_american_indian_or_alaska_native_flag')
         , ('ETL-200034', 'race_asian_flag')
         , ('ETL-200034', 'race_asian_indian_flag')
         , ('ETL-200034', 'race_black_or_african_american_flag')
         , ('ETL-200034', 'race_chinese_flag')
         , ('ETL-200034', 'race_filipino_flag')
         , ('ETL-200034', 'race_guamanian_or_chamorro_flag')
         , ('ETL-200034', 'race_japanese_flag')
         , ('ETL-200034', 'race_korean_flag')
         , ('ETL-200034', 'race_native_hawaiian_flag')
         , ('ETL-200034', 'race_native_hawaiian_or_other_pacific_islander_flag')
         , ('ETL-200034', 'race_not_applicable_flag')
         , ('ETL-200034', 'race_other_american_indian_or_alaska_native_description_flag')
         , ('ETL-200034', 'race_other_asian_description_flag')
         , ('ETL-200034', 'race_other_asian_flag')
         , ('ETL-200034', 'race_other_pacific_islander_description_flag')
         , ('ETL-200034', 'race_other_pacific_islander_flag')
         , ('ETL-200034', 'race_samoan_flag')
         , ('ETL-200034', 'race_vietnamese_flag')
         , ('ETL-200034', 'race_white_flag')
         , ('ETL-200035', 'data_source_dwid')
         , ('ETL-200035', 'edw_created_datetime')
         , ('ETL-200035', 'edw_modified_datetime')
         , ('ETL-200035', 'etl_batch_id')
         , ('ETL-200035', 'data_source_integration_columns')
         , ('ETL-200035', 'data_source_integration_id')
         , ('ETL-200035', 'data_source_modified_datetime')
         , ('ETL-200035', 'sex_female_flag')
         , ('ETL-200035', 'sex_male_flag')
         , ('ETL-200022-insert', 'borrower_counseling_dwid')
         , ('ETL-200022-insert', 'borrower_employee_status_dwid')
         , ('ETL-200022-insert', 'borrower_finances_declarations_dwid')
         , ('ETL-200022-insert', 'borrower_hmda_ethnicity_dwid')
         , ('ETL-200022-insert', 'borrower_hmda_race_dwid')
         , ('ETL-200022-insert', 'borrower_hmda_sex_dwid')
         , ('ETL-200022-insert', 'borrower_junk_dwid')
         , ('ETL-200022-insert', 'borrower_pre_umdp_declarations_dwid')
         , ('ETL-200022-insert', 'borrower_property_declarations_dwid')
         , ('ETL-200022-insert', 'borrower_relations_dwid')
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
    VALUES ('ETL-200030', 'Staging DB Connection', 'star_loan', 'borrower_counseling_dim')
         , ('ETL-200031', 'Staging DB Connection', 'star_loan', 'borrower_employee_status_dim')
         , ('ETL-200032', 'Staging DB Connection', 'star_loan', 'borrower_finances_declarations_dim')
         , ('ETL-200036', 'Staging DB Connection', 'star_loan', 'borrower_junk_dim')
         , ('ETL-200037', 'Staging DB Connection', 'star_loan', 'borrower_pre_umdp_declarations_dim')
         , ('ETL-200038', 'Staging DB Connection', 'star_loan', 'borrower_property_declarations_dim')
         , ('ETL-200039', 'Staging DB Connection', 'star_loan', 'borrower_relations_dim')
)
INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)
SELECT process.dwid, insert_rows.connectionname, insert_rows.schema_name, insert_rows.table_name, 1000, 'N'::mdi.pentaho_y_or_n
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--insert_update_key
WITH insert_rows (process_name, key_lookup) AS (
    VALUES ('ETL-200030', 'data_source_integration_id')
         , ('ETL-200031', 'data_source_integration_id')
         , ('ETL-200032', 'data_source_integration_id')
         , ('ETL-200036', 'data_source_integration_id')
         , ('ETL-200037', 'data_source_integration_id')
         , ('ETL-200038', 'data_source_integration_id')
         , ('ETL-200039', 'data_source_integration_id')
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
    VALUES ('ETL-200030', 'data_source_dwid', 'N')
         , ('ETL-200030', 'edw_created_datetime', 'N')
         , ('ETL-200030', 'edw_modified_datetime', 'Y')
         , ('ETL-200030', 'etl_batch_id', 'Y')
         , ('ETL-200030', 'data_source_integration_columns', 'N')
         , ('ETL-200030', 'data_source_integration_id', 'N')
         , ('ETL-200030', 'data_source_modified_datetime', 'Y')
         , ('ETL-200030', 'first_time_homebuyer_auto_compute_flag', 'N')
         , ('ETL-200030', 'first_time_homebuyer_flag', 'N')
         , ('ETL-200030', 'homeownership_education', 'Y')
         , ('ETL-200030', 'homeownership_education_code', 'N')
         , ('ETL-200030', 'homeownership_education_agency', 'Y')
         , ('ETL-200030', 'homeownership_education_agency_code', 'N')
         , ('ETL-200030', 'housing_counseling', 'Y')
         , ('ETL-200030', 'housing_counseling_code', 'N')
         , ('ETL-200030', 'housing_counseling_agency', 'Y')
         , ('ETL-200030', 'housing_counseling_agency_code', 'N')
         , ('ETL-200005-insert-update', 'schooling_years', 'Y')
         , ('ETL-200005-insert-update', 'homeownership_education_complete_date', 'Y')
         , ('ETL-200031', 'data_source_dwid', 'N')
         , ('ETL-200031', 'edw_created_datetime', 'N')
         , ('ETL-200031', 'edw_modified_datetime', 'Y')
         , ('ETL-200031', 'etl_batch_id', 'Y')
         , ('ETL-200031', 'data_source_integration_columns', 'N')
         , ('ETL-200031', 'data_source_integration_id', 'N')
         , ('ETL-200031', 'data_source_modified_datetime', 'Y')
         , ('ETL-200031', 'hud_employee_flag', 'N')
         , ('ETL-200031', 'lender_employee', 'Y')
         , ('ETL-200031', 'lender_employee_code', 'N')
         , ('ETL-200031', 'lender_employee_status_confirmed_flag', 'N')
         , ('ETL-200032', 'data_source_dwid', 'N')
         , ('ETL-200032', 'edw_created_datetime', 'N')
         , ('ETL-200032', 'edw_modified_datetime', 'Y')
         , ('ETL-200032', 'etl_batch_id', 'Y')
         , ('ETL-200032', 'data_source_integration_columns', 'N')
         , ('ETL-200032', 'data_source_integration_id', 'N')
         , ('ETL-200032', 'data_source_modified_datetime', 'Y')
         , ('ETL-200032', 'bankruptcy', 'Y')
         , ('ETL-200032', 'bankruptcy_code', 'N')
         , ('ETL-200032', 'outstanding_judgements', 'Y')
         , ('ETL-200032', 'outstanding_judgements_code', 'N')
         , ('ETL-200032', 'bankruptcy_chapter_7', 'Y')
         , ('ETL-200032', 'bankruptcy_chapter_7_code', 'N')
         , ('ETL-200032', 'bankruptcy_chapter_11', 'Y')
         , ('ETL-200032', 'bankruptcy_chapter_11_code', 'N')
         , ('ETL-200032', 'bankruptcy_chapter_12', 'Y')
         , ('ETL-200032', 'bankruptcy_chapter_12_code', 'N')
         , ('ETL-200032', 'bankruptcy_chapter_13', 'Y')
         , ('ETL-200032', 'bankruptcy_chapter_13_code', 'N')
         , ('ETL-200032', 'completed_pre_foreclosure_short_sale', 'Y')
         , ('ETL-200032', 'completed_pre_foreclosure_short_sale_code', 'N')
         , ('ETL-200032', 'conveyed_title_in_lieu_of_foreclosure', 'Y')
         , ('ETL-200032', 'conveyed_title_in_lieu_of_foreclosure_code', 'N')
         , ('ETL-200032', 'cosigner_undisclosed', 'Y')
         , ('ETL-200032', 'cosigner_undisclosed_code', 'N')
         , ('ETL-200032', 'currently_delinquent_federal_debt', 'Y')
         , ('ETL-200032', 'currently_delinquent_federal_debt_code', 'N')
         , ('ETL-200032', 'party_to_lawsuit', 'Y')
         , ('ETL-200032', 'party_to_lawsuit_code', 'N')
         , ('ETL-200032', 'property_foreclosure', 'Y')
         , ('ETL-200032', 'property_foreclosure_code', 'N')
         , ('ETL-200036', 'data_source_dwid', 'N')
         , ('ETL-200036', 'edw_created_datetime', 'N')
         , ('ETL-200036', 'edw_modified_datetime', 'Y')
         , ('ETL-200036', 'etl_batch_id', 'Y')
         , ('ETL-200036', 'data_source_integration_columns', 'N')
         , ('ETL-200036', 'data_source_integration_id', 'N')
         , ('ETL-200036', 'data_source_modified_datetime', 'Y')
         , ('ETL-200036', 'citizenship_residency', 'Y')
         , ('ETL-200036', 'citizenship_residency_code', 'N')
         , ('ETL-200036', 'disabled', 'Y')
         , ('ETL-200036', 'disabled_code', 'N')
         , ('ETL-200036', 'on_gsa_list', 'Y')
         , ('ETL-200036', 'on_gsa_list_code', 'N')
         , ('ETL-200036', 'on_ldp_list', 'Y')
         , ('ETL-200036', 'on_ldp_list_code', 'N')
         , ('ETL-200036', 'titleholder', 'Y')
         , ('ETL-200036', 'titleholder_code', 'N')
         , ('ETL-200022-update', 'borrower_counseling_dwid', 'Y')
         , ('ETL-200022-update', 'borrower_employee_status_dwid', 'Y')
         , ('ETL-200022-update', 'borrower_finances_declarations_dwid', 'Y')
         , ('ETL-200022-update', 'borrower_hmda_ethnicity_dwid', 'Y')
         , ('ETL-200022-update', 'borrower_hmda_race_dwid', 'Y')
         , ('ETL-200022-update', 'borrower_hmda_sex_dwid', 'Y')
         , ('ETL-200022-update', 'borrower_junk_dwid', 'Y')
         , ('ETL-200022-update', 'borrower_pre_umdp_declarations_dwid', 'Y')
         , ('ETL-200022-update', 'borrower_property_declarations_dwid', 'Y')
         , ('ETL-200022-update', 'borrower_relations_dwid', 'Y')
         , ('ETL-200037', 'data_source_dwid', 'N')
         , ('ETL-200037', 'edw_created_datetime', 'N')
         , ('ETL-200037', 'edw_modified_datetime', 'Y')
         , ('ETL-200037', 'etl_batch_id', 'Y')
         , ('ETL-200037', 'data_source_integration_columns', 'N')
         , ('ETL-200037', 'data_source_integration_id', 'N')
         , ('ETL-200037', 'data_source_modified_datetime', 'Y')
         , ('ETL-200037', 'alimony_child_support', 'Y')
         , ('ETL-200037', 'alimony_child_support_code', 'N')
         , ('ETL-200037', 'borrowed_down_payment', 'Y')
         , ('ETL-200037', 'borrowed_down_payment_code', 'N')
         , ('ETL-200037', 'note_endorser', 'Y')
         , ('ETL-200037', 'note_endorser_code', 'N')
         , ('ETL-200037', 'obligated_loan_foreclosure', 'Y')
         , ('ETL-200037', 'obligated_loan_foreclosure_code', 'N')
         , ('ETL-200037', 'party_to_lawsuit', 'Y')
         , ('ETL-200037', 'party_to_lawsuit_code', 'N')
         , ('ETL-200037', 'presently_delinquent', 'Y')
         , ('ETL-200037', 'presently_delinquent_code', 'N')
         , ('ETL-200037', 'property_foreclosure', 'Y')
         , ('ETL-200037', 'property_foreclosure_code', 'N')
         , ('ETL-200038', 'data_source_dwid', 'N')
         , ('ETL-200038', 'edw_created_datetime', 'N')
         , ('ETL-200038', 'edw_modified_datetime', 'Y')
         , ('ETL-200038', 'etl_batch_id', 'Y')
         , ('ETL-200038', 'data_source_integration_columns', 'N')
         , ('ETL-200038', 'data_source_integration_id', 'N')
         , ('ETL-200038', 'data_source_modified_datetime', 'Y')
         , ('ETL-200038', 'applying_for_credit_before_closing', 'Y')
         , ('ETL-200038', 'applying_for_credit_before_closing_code', 'N')
         , ('ETL-200038', 'borrowed_funds_undisclosed', 'Y')
         , ('ETL-200038', 'borrowed_funds_undisclosed_code', 'N')
         , ('ETL-200038', 'fha_secondary_residence', 'Y')
         , ('ETL-200038', 'fha_secondary_residence_code', 'N')
         , ('ETL-200038', 'homeowner_past_three_years', 'Y')
         , ('ETL-200038', 'homeowner_past_three_years_code', 'N')
         , ('ETL-200038', 'intend_to_occupy', 'Y')
         , ('ETL-200038', 'intend_to_occupy_code', 'N')
         , ('ETL-200038', 'intend_to_occupy_more_than_14_days', 'Y')
         , ('ETL-200038', 'intend_to_occupy_more_than_14_days_code', 'N')
         , ('ETL-200038', 'other_mortgage_in_progress_before_closing', 'Y')
         , ('ETL-200038', 'other_mortgage_in_progress_before_closing_code', 'N')
         , ('ETL-200038', 'prior_property_title', 'Y')
         , ('ETL-200038', 'prior_property_title_code', 'N')
         , ('ETL-200038', 'prior_property_usage', 'Y')
         , ('ETL-200038', 'prior_property_usage_code', 'N')
         , ('ETL-200038', 'priority_given_to_another_lien', 'Y')
         , ('ETL-200038', 'priority_given_to_another_lien_code', 'N')
         , ('ETL-200038', 'relationship_with_seller', 'Y')
         , ('ETL-200038', 'relationship_with_seller_code', 'N')
         , ('ETL-200039', 'data_source_dwid', 'N')
         , ('ETL-200039', 'edw_created_datetime', 'N')
         , ('ETL-200039', 'edw_modified_datetime', 'Y')
         , ('ETL-200039', 'etl_batch_id', 'Y')
         , ('ETL-200039', 'data_source_integration_columns', 'N')
         , ('ETL-200039', 'data_source_integration_id', 'N')
         , ('ETL-200039', 'data_source_modified_datetime', 'Y')
         , ('ETL-200039', 'dependents', 'Y')
         , ('ETL-200039', 'dependents_code', 'N')
         , ('ETL-200039', 'domestic_relationship_state', 'Y')
         , ('ETL-200039', 'domestic_relationship_state_code', 'N')
         , ('ETL-200039', 'marital_status', 'Y')
         , ('ETL-200039', 'marital_status_code', 'N')
         , ('ETL-200039', 'spousal_homestead', 'Y')
         , ('ETL-200039', 'spousal_homestead_code', 'N')
         , ('ETL-300001-insert-update', 'b1_borrower_counseling_dwid', 'Y')
         , ('ETL-300001-insert-update', 'b1_borrower_employee_status_dwid', 'Y')
         , ('ETL-300001-insert-update', 'b1_borrower_finances_declarations_dwid', 'Y')
         , ('ETL-300001-insert-update', 'b1_borrower_hmda_ethnicity_dwid', 'Y')
         , ('ETL-300001-insert-update', 'b1_borrower_hmda_race_dwid', 'Y')
         , ('ETL-300001-insert-update', 'b1_borrower_hmda_sex_dwid', 'Y')
         , ('ETL-300001-insert-update', 'b1_borrower_junk_dwid', 'Y')
         , ('ETL-300001-insert-update', 'b1_borrower_pre_umdp_declarations_dwid', 'Y')
         , ('ETL-300001-insert-update', 'b1_borrower_property_declarations_dwid', 'Y')
         , ('ETL-300001-insert-update', 'b1_borrower_relations_dwid', 'Y')
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
    VALUES ('ETL-200030', 'data_source_integration_id')
         , ('ETL-200031', 'data_source_integration_id')
         , ('ETL-200032', 'data_source_integration_id')
         , ('ETL-200033', 'data_source_integration_id')
         , ('ETL-200034', 'data_source_integration_id')
         , ('ETL-200035', 'data_source_integration_id')
         , ('ETL-200036', 'data_source_integration_id')
         , ('ETL-200037', 'data_source_integration_id')
         , ('ETL-200038', 'data_source_integration_id')
         , ('ETL-200039', 'data_source_integration_id')
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
    VALUES ('ETL-200005-insert-update', 1, 'WITH borrower_dim_incl_new_records AS (
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
         , primary_table.b_schooling_years AS schooling_years
         , primary_table.b_homeownership_education_complete_date AS homeownership_education_complete_date
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
         , ('ETL-200021', 1, 'WITH borrower_hmda_collection_dim_new_records AS (
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
    ) AS ethnicity_collected_visual_or_surname_type
         ON borrower.b_ethnicity_collected_visual_or_surname = ethnicity_collected_visual_or_surname_type.code
    JOIN (
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
    ) AS ethnicity_refused_type
         ON borrower.b_ethnicity_refused = ethnicity_refused_type.code
    JOIN (
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
    ) AS race_collected_visual_or_surname_type
         ON borrower.b_race_collected_visual_or_surname = race_collected_visual_or_surname_type.code
    JOIN (
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
    ) AS race_refused_type
         ON borrower.b_race_refused = race_refused_type.code
    JOIN (
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
    ) AS sex_collected_visual_or_surname_type
         ON borrower.b_sex_collected_visual_or_surname = sex_collected_visual_or_surname_type.code
    JOIN (
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
         , ('ETL-200022-insert', 1, 'SELECT ''borrower_pid~data_source_dwid'' AS data_source_integration_columns
     , COALESCE( CAST( borrower.b_pid AS TEXT ), ''<NULL>'' ) || ''~1'' AS data_source_integration_id
     , NOW( ) AS edw_created_datetime
     , NOW( ) AS edw_modified_datetime
     , borrower.data_source_updated_datetime AS data_source_modified_datetime
     , borrower_dim.dwid AS borrower_dwid
     , borrower.b_pid AS borrower_pid
     , COALESCE( borrower_hmda_collection_dim.dwid, 0 ) AS borrower_hmda_collection_dwid
     , COALESCE( borrower_counseling_dim.dwid, 0 ) AS borrower_counseling_dwid
     , COALESCE( borrower_employee_status_dim.dwid, 0 ) AS borrower_employee_status_dwid
     , COALESCE( borrower_finances_declarations_dim.dwid, 0 ) AS borrower_finances_declarations_dwid
     , COALESCE( borrower_hmda_ethnicity_dim.dwid, 0 ) AS borrower_hmda_ethnicity_dwid
     , COALESCE( borrower_hmda_race_dim.dwid, 0 ) AS borrower_hmda_race_dwid
     , COALESCE( borrower_hmda_sex_dim.dwid, 0 ) AS borrower_hmda_sex_dwid
     , COALESCE( borrower_junk_dim.dwid, 0 ) AS borrower_junk_dwid
     , COALESCE( borrower_pre_umdp_declarations_dim.dwid, 0 ) AS borrower_pre_umdp_declarations_dwid
     , COALESCE( borrower_property_declarations_dim.dwid, 0 ) AS borrower_property_declarations_dwid
     , COALESCE( borrower_relations_dim.dwid, 0 ) AS borrower_relations_dwid
FROM (
    SELECT borrower.*
         , <<borrower_partial_load_condition>> AS include_record
    FROM history_octane.borrower
    LEFT JOIN history_octane.borrower AS history_records
              ON borrower.b_pid = history_records.b_pid
                  AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
    LEFT JOIN star_loan.borrower_lkup
              ON borrower.b_pid = borrower_lkup.borrower_pid
                  AND borrower_lkup.data_source_dwid = 1
    WHERE history_records.b_pid IS NULL
      AND borrower_lkup.borrower_pid IS NULL
) AS borrower
JOIN(
    SELECT borrower_dim.*
         , <<borrower_dim_partial_load_condition>> AS include_record
    FROM star_loan.borrower_dim
) AS borrower_dim
    ON borrower.b_pid = borrower_dim.borrower_pid
        AND borrower_dim.data_source_dwid = 1
LEFT JOIN (
    SELECT borrower_declarations.*
         , <<borrower_declarations_partial_load_condition>> AS include_record
    FROM history_octane.borrower_declarations
    LEFT JOIN history_octane.borrower_declarations AS history_records
              ON borrower_declarations.bdec_pid = history_records.bdec_pid
                  AND borrower_declarations.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.bdec_pid IS NULL
) AS borrower_declarations
          ON borrower.b_pid = borrower_declarations.bdec_borrower_pid
LEFT JOIN star_loan.borrower_counseling_dim
          ON COALESCE( CAST( borrower.b_first_time_home_buyer_auto_compute AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_first_time_homebuyer AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_homeownership_education_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_homeownership_education_agency_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_housing_counseling_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_housing_counseling_agency_type AS TEXT ), ''<NULL>'' ) || ''~1'' =
             borrower_counseling_dim.data_source_integration_id
LEFT JOIN star_loan.borrower_employee_status_dim
          ON COALESCE( CAST( borrower.b_hud_employee AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_lender_employee AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_lender_employee_status_confirmed AS TEXT ), ''<NULL>'' ) || ''~1'' =
             borrower_employee_status_dim.data_source_integration_id
LEFT JOIN star_loan.borrower_finances_declarations_dim
          ON COALESCE( CAST( borrower.b_bankruptcy AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_outstanding_judgements AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_bankruptcy_chapter_7 AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_bankruptcy_chapter_11 AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_bankruptcy_chapter_12 AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_bankruptcy_chapter_13 AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_completed_pre_foreclosure_short_sale AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_conveyed_title_in_lieu_of_foreclosure AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_cosigner_undisclosed AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_currently_delinquent_federal_debt AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_party_to_lawsuit AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_property_foreclosure AS TEXT ), ''<NULL>'' ) || ''~1'' =
             borrower_finances_declarations_dim.data_source_integration_id
LEFT JOIN star_loan.borrower_hmda_collection_dim
          ON COALESCE( CAST( borrower.b_ethnicity_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_ethnicity_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_ethnicity_refused AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_information_not_provided AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_national_origin_refusal AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_refused AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_sex_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_sex_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_sex_refused AS TEXT ), ''<NULL>'' ) || ''~1'' = borrower_hmda_collection_dim.data_source_integration_id
LEFT JOIN star_loan.borrower_hmda_ethnicity_dim
          ON COALESCE( CAST( borrower.b_ethnicity_cuban AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_ethnicity_hispanic_or_latino AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_ethnicity_mexican AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_ethnicity_not_hispanic_or_latino AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_ethnicity_other_hispanic_or_latino_description <> '''' AND
                             borrower.b_ethnicity_other_hispanic_or_latino_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_ethnicity_other_hispanic_or_latino AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_ethnicity_puerto_rican AS TEXT ), ''<NULL>'' ) || ''~1'' =
             borrower_hmda_ethnicity_dim.data_source_integration_id
LEFT JOIN star_loan.borrower_hmda_race_dim
          ON COALESCE( CAST( borrower.b_other_race_national_origin_description <> '''' AND
                             borrower.b_other_race_national_origin_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_american_indian_or_alaska_native AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_asian AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_asian_indian AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_black_or_african_american AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_chinese AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_filipino AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_guamanian_or_chamorro AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_japanese AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_korean AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_native_hawaiian AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_native_hawaiian_or_other_pacific_islander AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_not_applicable AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_other_american_indian_or_alaska_native_description <> '''' AND
                             borrower.b_race_other_american_indian_or_alaska_native_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_other_asian_description <> '''' AND
                             borrower.b_race_other_asian_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_other_asian AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_other_pacific_islander_description <> '''' AND
                             borrower.b_race_other_pacific_islander_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_other_pacific_islander AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_samoan AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_vietnamese AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_white AS TEXT ), ''<NULL>'' ) || ''~1'' = borrower_hmda_race_dim.data_source_integration_id
LEFT JOIN star_loan.borrower_hmda_sex_dim
          ON COALESCE( CAST( borrower.b_sex_female AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_sex_male AS TEXT ), ''<NULL>'' ) || ''~1'' = borrower_hmda_sex_dim.data_source_integration_id
LEFT JOIN star_loan.borrower_junk_dim
          ON COALESCE( CAST( borrower.b_citizenship_residency_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_disabled AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_on_gsa_list AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_on_ldp_list AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_titleholder AS TEXT ), ''<NULL>'' ) || ''~1'' = borrower_junk_dim.data_source_integration_id
LEFT JOIN star_loan.borrower_pre_umdp_declarations_dim
          ON COALESCE( CAST( borrower.b_alimony_child_support AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_borrowed_down_payment AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_note_endorser AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_obligated_loan_foreclosure AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_party_to_lawsuit AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_presently_delinquent AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_property_foreclosure AS TEXT ), ''<NULL>'' ) || ''~1'' =
             borrower_pre_umdp_declarations_dim.data_source_integration_id
LEFT JOIN star_loan.borrower_property_declarations_dim
          ON COALESCE( CAST( borrower_declarations.bdec_applying_for_credit_before_closing AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_borrowed_funds_undisclosed AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_fha_secondary_residence AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_homeowner_past_three_years AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_intend_to_occupy AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_intend_to_occupy_more_than_14_days AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_other_mortgage_in_progress_before_closing AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_prior_property_title_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_prior_property_usage_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_priority_given_to_another_lien AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_relationship_with_seller AS TEXT ), ''<NULL>'' ) || ''~1'' =
             borrower_property_declarations_dim.data_source_integration_id
LEFT JOIN star_loan.borrower_relations_dim
          ON COALESCE( CAST( borrower.b_has_dependents AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_domestic_relationship_state_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_marital_status_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_spousal_homestead AS TEXT ), ''<NULL>'' ) || ''~1'' = borrower_relations_dim.data_source_integration_id
WHERE GREATEST( borrower.include_record, borrower_dim.include_record, borrower_declarations.include_record );', 'Staging DB Connection')
         , ('ETL-200022-update', 1, 'SELECT borrower_lkup.data_source_integration_columns
     , borrower_lkup.data_source_integration_id
     , borrower_lkup.edw_created_datetime
     , NOW( ) AS edw_modified_datetime
     , borrower.data_source_updated_datetime AS data_source_modified_datetime
     , borrower_dim.dwid AS borrower_dwid
     , borrower_lkup.borrower_pid
     , COALESCE( borrower_counseling_dim.dwid, 0 ) AS borrower_counseling_dwid
     , COALESCE( borrower_employee_status_dim.dwid, 0 ) AS borrower_employee_status_dwid
     , COALESCE( borrower_finances_declarations_dim.dwid, 0 ) AS borrower_finances_declarations_dwid
     , COALESCE( borrower_hmda_collection_dim.dwid, 0 ) AS borrower_hmda_collection_dwid
     , COALESCE( borrower_hmda_ethnicity_dim.dwid, 0 ) AS borrower_hmda_ethnicity_dwid
     , COALESCE( borrower_hmda_race_dim.dwid, 0 ) AS borrower_hmda_race_dwid
     , COALESCE( borrower_hmda_sex_dim.dwid, 0 ) AS borrower_hmda_sex_dwid
     , COALESCE( borrower_junk_dim.dwid, 0 ) AS borrower_junk_dwid
     , COALESCE( borrower_pre_umdp_declarations_dim.dwid, 0 ) AS borrower_pre_umdp_declarations_dwid
     , COALESCE( borrower_property_declarations_dim.dwid, 0 ) AS borrower_property_declarations_dwid
     , COALESCE( borrower_relations_dim.dwid, 0 ) AS borrower_relations_dwid
FROM (
    SELECT borrower.*
         , <<borrower_partial_load_condition>> AS include_record
         , etl_log.etl_end_date_time
    FROM history_octane.borrower
    LEFT JOIN history_octane.borrower AS history_records
              ON borrower.b_pid = history_records.b_pid
                  AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
    JOIN star_common.etl_log
         ON borrower.etl_batch_id = etl_log.etl_batch_id
    WHERE history_records.b_pid IS NULL
) AS borrower
JOIN (
    SELECT borrower_dim.*
         , <<borrower_dim_partial_load_condition>> AS include_record
         , etl_log.etl_end_date_time
    FROM star_loan.borrower_dim
    JOIN star_common.etl_log
         ON borrower_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_dim
     ON borrower.b_pid = borrower_dim.borrower_pid
         AND borrower_dim.data_source_dwid = 1
LEFT JOIN (
    SELECT borrower_declarations.*
         , <<borrower_declarations_partial_load_condition>> AS include_record
         , etl_log.etl_end_date_time
    FROM history_octane.borrower_declarations
    LEFT JOIN history_octane.borrower_declarations AS history_records
              ON borrower_declarations.bdec_pid = history_records.bdec_pid
                  AND borrower_declarations.data_source_updated_datetime < history_records.data_source_updated_datetime
    JOIN star_common.etl_log
         ON borrower_declarations.etl_batch_id = etl_log.etl_batch_id
    WHERE history_records.bdec_pid IS NULL
) AS borrower_declarations
          ON borrower.b_pid = borrower_declarations.bdec_borrower_pid
LEFT JOIN (
    SELECT borrower_counseling_dim.*
         , <<borrower_counseling_dim_partial_load_condition>> AS include_record
         , etl_log.etl_end_date_time
    FROM star_loan.borrower_counseling_dim
    JOIN star_common.etl_log
         ON borrower_counseling_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_counseling_dim
          ON COALESCE( CAST( borrower.b_first_time_home_buyer_auto_compute AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_first_time_homebuyer AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_homeownership_education_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_homeownership_education_agency_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_housing_counseling_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_housing_counseling_agency_type AS TEXT ), ''<NULL>'' ) || ''~1'' =
             borrower_counseling_dim.data_source_integration_id
LEFT JOIN (
    SELECT borrower_employee_status_dim.*
         , <<borrower_employee_status_dim_partial_load_condition>> AS include_record
         , etl_log.etl_end_date_time
    FROM star_loan.borrower_employee_status_dim
    JOIN star_common.etl_log
         ON borrower_employee_status_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_employee_status_dim
          ON COALESCE( CAST( borrower.b_hud_employee AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_lender_employee AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_lender_employee_status_confirmed AS TEXT ), ''<NULL>'' ) || ''~1'' =
             borrower_employee_status_dim.data_source_integration_id
LEFT JOIN (
    SELECT borrower_finances_declarations_dim.*
         , <<borrower_finances_declarations_dim_partial_load_condition>> AS include_record
         , etl_log.etl_end_date_time
    FROM star_loan.borrower_finances_declarations_dim
    JOIN star_common.etl_log
         ON borrower_finances_declarations_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_finances_declarations_dim
          ON COALESCE( CAST( borrower.b_bankruptcy AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_outstanding_judgements AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_bankruptcy_chapter_7 AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_bankruptcy_chapter_11 AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_bankruptcy_chapter_12 AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_bankruptcy_chapter_13 AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_completed_pre_foreclosure_short_sale AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_conveyed_title_in_lieu_of_foreclosure AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_cosigner_undisclosed AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_currently_delinquent_federal_debt AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_party_to_lawsuit AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_property_foreclosure AS TEXT ), ''<NULL>'' ) || ''~1'' =
             borrower_finances_declarations_dim.data_source_integration_id
LEFT JOIN (
    SELECT borrower_hmda_collection_dim.*
         , <<borrower_hmda_collection_dim_partial_load_condition>> AS include_record
         , etl_log.etl_end_date_time
    FROM star_loan.borrower_hmda_collection_dim
    JOIN star_common.etl_log
         ON borrower_hmda_collection_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_hmda_collection_dim
          ON COALESCE( CAST( borrower.b_ethnicity_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_ethnicity_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_ethnicity_refused AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_information_not_provided AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_national_origin_refusal AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_refused AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_sex_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_sex_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_sex_refused AS TEXT ), ''<NULL>'' ) || ''~1'' = borrower_hmda_collection_dim.data_source_integration_id
LEFT JOIN (
    SELECT borrower_hmda_ethnicity_dim.*
         , <<borrower_hmda_ethnicity_dim_partial_load_condition>> AS include_record
         , etl_log.etl_end_date_time
    FROM star_loan.borrower_hmda_ethnicity_dim
    JOIN star_common.etl_log
         ON borrower_hmda_ethnicity_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_hmda_ethnicity_dim
          ON COALESCE( CAST( borrower.b_ethnicity_cuban AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_ethnicity_hispanic_or_latino AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_ethnicity_mexican AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_ethnicity_not_hispanic_or_latino AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_ethnicity_other_hispanic_or_latino_description <> '''' AND
                             borrower.b_ethnicity_other_hispanic_or_latino_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_ethnicity_other_hispanic_or_latino AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_ethnicity_puerto_rican AS TEXT ), ''<NULL>'' ) || ''~1'' =
             borrower_hmda_ethnicity_dim.data_source_integration_id
LEFT JOIN (
    SELECT borrower_hmda_race_dim.*
         , <<borrower_hmda_race_dim_partial_load_condition>> AS include_record
         , etl_log.etl_end_date_time
    FROM star_loan.borrower_hmda_race_dim
    JOIN star_common.etl_log
         ON borrower_hmda_race_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_hmda_race_dim
          ON COALESCE( CAST( borrower.b_other_race_national_origin_description <> '''' AND
                             borrower.b_other_race_national_origin_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_american_indian_or_alaska_native AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_asian AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_asian_indian AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_black_or_african_american AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_chinese AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_filipino AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_guamanian_or_chamorro AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_japanese AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_korean AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_native_hawaiian AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_native_hawaiian_or_other_pacific_islander AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_not_applicable AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_other_american_indian_or_alaska_native_description <> '''' AND
                             borrower.b_race_other_american_indian_or_alaska_native_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_other_asian_description <> '''' AND
                             borrower.b_race_other_asian_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_other_asian AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_other_pacific_islander_description <> '''' AND
                             borrower.b_race_other_pacific_islander_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_other_pacific_islander AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_samoan AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_vietnamese AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_race_white AS TEXT ), ''<NULL>'' ) || ''~1'' = borrower_hmda_race_dim.data_source_integration_id
LEFT JOIN (
    SELECT borrower_hmda_sex_dim.*
         , <<borrower_hmda_sex_dim_partial_load_condition>> AS include_record
         , etl_log.etl_end_date_time
    FROM star_loan.borrower_hmda_sex_dim
    JOIN star_common.etl_log
         ON borrower_hmda_sex_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_hmda_sex_dim
          ON COALESCE( CAST( borrower.b_sex_female AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_sex_male AS TEXT ), ''<NULL>'' ) || ''~1'' = borrower_hmda_sex_dim.data_source_integration_id
LEFT JOIN (
    SELECT borrower_junk_dim.*
         , <<borrower_junk_dim_partial_load_condition>> AS include_record
         , etl_log.etl_end_date_time
    FROM star_loan.borrower_junk_dim
    JOIN star_common.etl_log
         ON borrower_junk_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_junk_dim
          ON COALESCE( CAST( borrower.b_citizenship_residency_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_disabled AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_on_gsa_list AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_on_ldp_list AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_titleholder AS TEXT ), ''<NULL>'' ) || ''~1'' = borrower_junk_dim.data_source_integration_id
LEFT JOIN (
    SELECT borrower_pre_umdp_declarations_dim.*
         , <<borrower_pre_umdp_declarations_dim_partial_load_condition>> AS include_record
         , etl_log.etl_end_date_time
    FROM star_loan.borrower_pre_umdp_declarations_dim
    JOIN star_common.etl_log
         ON borrower_pre_umdp_declarations_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_pre_umdp_declarations_dim
          ON COALESCE( CAST( borrower.b_alimony_child_support AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_borrowed_down_payment AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_note_endorser AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_obligated_loan_foreclosure AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_party_to_lawsuit AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_presently_delinquent AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_property_foreclosure AS TEXT ), ''<NULL>'' ) || ''~1'' =
             borrower_pre_umdp_declarations_dim.data_source_integration_id
LEFT JOIN (
    SELECT borrower_property_declarations_dim.*
         , <<borrower_property_declarations_dim_partial_load_condition>> AS include_record
         , etl_log.etl_end_date_time
    FROM star_loan.borrower_property_declarations_dim
    JOIN star_common.etl_log
         ON borrower_property_declarations_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_property_declarations_dim
          ON COALESCE( CAST( borrower_declarations.bdec_applying_for_credit_before_closing AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_borrowed_funds_undisclosed AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_fha_secondary_residence AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_homeowner_past_three_years AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_intend_to_occupy AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_intend_to_occupy_more_than_14_days AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_other_mortgage_in_progress_before_closing AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_prior_property_title_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_prior_property_usage_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_priority_given_to_another_lien AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower_declarations.bdec_relationship_with_seller AS TEXT ), ''<NULL>'' ) || ''~1'' =
             borrower_property_declarations_dim.data_source_integration_id
LEFT JOIN (
    SELECT borrower_relations_dim.*
         , <<borrower_relations_dim_partial_load_condition>> AS include_record
         , etl_log.etl_end_date_time
    FROM star_loan.borrower_relations_dim
    JOIN star_common.etl_log
         ON borrower_relations_dim.etl_batch_id = etl_log.etl_batch_id
) AS borrower_relations_dim
          ON COALESCE( CAST( borrower.b_has_dependents AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_domestic_relationship_state_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_marital_status_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
             COALESCE( CAST( borrower.b_spousal_homestead AS TEXT ), ''<NULL>'' ) || ''~1'' = borrower_relations_dim.data_source_integration_id
JOIN (
    SELECT borrower_lkup.*
         , etl_log.etl_start_date_time
    FROM star_loan.borrower_lkup
    JOIN star_common.etl_log
         ON borrower_lkup.etl_batch_id = etl_log.etl_batch_id
) AS borrower_lkup
     ON borrower.b_pid = borrower_lkup.borrower_pid
         AND borrower_lkup.data_source_dwid = 1
         AND GREATEST( borrower.etl_end_date_time, borrower_dim.etl_end_date_time, borrower_declarations.etl_end_date_time,
                       borrower_hmda_collection_dim.etl_end_date_time, borrower_counseling_dim.etl_end_date_time,
                       borrower_employee_status_dim.etl_end_date_time, borrower_finances_declarations_dim.etl_end_date_time,
                       borrower_hmda_ethnicity_dim.etl_end_date_time, borrower_hmda_race_dim.etl_end_date_time,
                       borrower_hmda_sex_dim.etl_end_date_time, borrower_junk_dim.etl_end_date_time,
                       borrower_pre_umdp_declarations_dim.etl_end_date_time, borrower_property_declarations_dim.etl_end_date_time,
                       borrower_relations_dim.etl_end_date_time ) >=
             borrower_lkup.etl_start_date_time
WHERE GREATEST( borrower.include_record, borrower_dim.include_record, borrower_declarations.include_record,
                borrower_hmda_collection_dim.include_record, borrower_counseling_dim.include_record,
                borrower_employee_status_dim.include_record, borrower_finances_declarations_dim.include_record,
                borrower_hmda_ethnicity_dim.include_record, borrower_hmda_race_dim.include_record, borrower_hmda_sex_dim.include_record,
                borrower_junk_dim.include_record, borrower_pre_umdp_declarations_dim.include_record,
                borrower_property_declarations_dim.include_record, borrower_relations_dim.include_record ) IS TRUE;', 'Staging DB Connection')
         , ('ETL-300001-insert-update', 1, 'SELECT loan_fact_incl_new_records.edw_created_datetime
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
     , loan_fact_incl_new_records.b1_borrower_counseling_dwid
     , loan_fact_incl_new_records.b1_borrower_employee_status_dwid
     , loan_fact_incl_new_records.b1_borrower_finances_declarations_dwid
     , loan_fact_incl_new_records.b1_borrower_hmda_collection_dwid
     , loan_fact_incl_new_records.b1_borrower_hmda_ethnicity_dwid
     , loan_fact_incl_new_records.b1_borrower_hmda_race_dwid
     , loan_fact_incl_new_records.b1_borrower_hmda_sex_dwid
     , loan_fact_incl_new_records.b1_borrower_junk_dwid
     , loan_fact_incl_new_records.b1_borrower_pre_umdp_declarations_dwid
     , loan_fact_incl_new_records.b1_borrower_property_declarations_dwid
     , loan_fact_incl_new_records.b1_borrower_relations_dwid
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
     , loan_fact_incl_new_records.preapproval_complete_date_dwid
     , loan_fact_incl_new_records.transaction_create_date_dwid
     , loan_fact_incl_new_records.transaction_welcome_call_date_dwid
     , loan_fact_incl_new_records.trid_application_date_dwid
     , loan_fact_incl_new_records.underwrite_publish_date_dwid
     , loan_fact_incl_new_records.cash_out_reason_dwid
     , loan_fact_incl_new_records.hmda_action_dwid
     , loan_fact_incl_new_records.underwrite_dwid
FROM (
    SELECT COALESCE( loan_fact.edw_created_datetime, NOW( ) ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , ''loan_pid~data_source_dwid'' AS data_source_integration_columns
         , loan_dim.loan_pid || ''~1'' AS data_source_integration_id
         , loan_dim.edw_modified_datetime AS data_source_modified_datetime
         , loan_dim.loan_pid AS loan_pid
         , loan_dim.dwid AS loan_dwid
         , COALESCE( loan_junk_dim.dwid, 0 ) AS loan_junk_dwid
         , COALESCE( product_choice_dim.dwid, 0 ) AS product_choice_dwid
         , COALESCE( transaction_dim.dwid, 0 ) AS transaction_dwid
         , COALESCE( transaction_junk_dim.dwid, 0 ) AS transaction_junk_dwid
         , COALESCE( current_loan_beneficiary_dim.dwid, 0 ) AS current_loan_beneficiary_dwid
         , COALESCE( loan_funding_dim.dwid, 0 ) AS active_loan_funding_dwid
         , COALESCE( borrower_b1_dim.dwid, 0 ) AS b1_borrower_dwid
         , COALESCE( borrower_b2_dim.dwid, 0 ) AS b2_borrower_dwid
         , COALESCE( borrower_b3_dim.dwid, 0 ) AS b3_borrower_dwid
         , COALESCE( borrower_b4_dim.dwid, 0 ) AS b4_borrower_dwid
         , COALESCE( borrower_b5_dim.dwid, 0 ) AS b5_borrower_dwid
         , COALESCE( borrower_c1_dim.dwid, 0 ) AS c1_borrower_dwid
         , COALESCE( borrower_c2_dim.dwid, 0 ) AS c2_borrower_dwid
         , COALESCE( borrower_c3_dim.dwid, 0 ) AS c3_borrower_dwid
         , COALESCE( borrower_c4_dim.dwid, 0 ) AS c4_borrower_dwid
         , COALESCE( borrower_c5_dim.dwid, 0 ) AS c5_borrower_dwid
         , COALESCE( borrower_n1_dim.dwid, 0 ) AS n1_borrower_dwid
         , COALESCE( borrower_n2_dim.dwid, 0 ) AS n2_borrower_dwid
         , COALESCE( borrower_n3_dim.dwid, 0 ) AS n3_borrower_dwid
         , COALESCE( borrower_n4_dim.dwid, 0 ) AS n4_borrower_dwid
         , COALESCE( borrower_n5_dim.dwid, 0 ) AS n5_borrower_dwid
         , COALESCE( borrower_n6_dim.dwid, 0 ) AS n6_borrower_dwid
         , COALESCE( borrower_n7_dim.dwid, 0 ) AS n7_borrower_dwid
         , COALESCE( borrower_n8_dim.dwid, 0 ) AS n8_borrower_dwid
         , COALESCE( borrower_demographics_dim.dwid, 0 ) AS b1_borrower_demographics_dwid
         , COALESCE( borrower_lending_profile_dim.dwid, 0 ) AS b1_borrower_lending_profile_dwid
         , COALESCE( b1_borrower_lkup.borrower_counseling_dwid, 0 ) AS b1_borrower_counseling_dwid
         , COALESCE( b1_borrower_lkup.borrower_employee_status_dwid, 0 ) AS b1_borrower_employee_status_dwid
         , COALESCE( b1_borrower_lkup.borrower_finances_declarations_dwid, 0 ) AS b1_borrower_finances_declarations_dwid
         , COALESCE( b1_borrower_lkup.borrower_hmda_collection_dwid, 0 ) AS b1_borrower_hmda_collection_dwid
         , COALESCE( b1_borrower_lkup.borrower_hmda_ethnicity_dwid, 0 ) AS b1_borrower_hmda_ethnicity_dwid
         , COALESCE( b1_borrower_lkup.borrower_hmda_race_dwid, 0 ) AS b1_borrower_hmda_race_dwid
         , COALESCE( b1_borrower_lkup.borrower_hmda_sex_dwid, 0 ) AS b1_borrower_hmda_sex_dwid
         , COALESCE( b1_borrower_lkup.borrower_junk_dwid, 0 ) AS b1_borrower_junk_dwid
         , COALESCE( b1_borrower_lkup.borrower_pre_umdp_declarations_dwid, 0 ) AS b1_borrower_pre_umdp_declarations_dwid
         , COALESCE( b1_borrower_lkup.borrower_property_declarations_dwid, 0 ) AS b1_borrower_property_declarations_dwid
         , COALESCE( b1_borrower_lkup.borrower_relations_dwid, 0 ) AS b1_borrower_relations_dwid
         , COALESCE( application_dim.dwid, 0 ) AS primary_application_dwid
         , COALESCE( collateral_to_custodian.dwid, 0 ) AS collateral_to_custodian_lender_user_dwid
         , COALESCE( interim_funder_dim.dwid, 0 ) AS interim_funder_dwid
         , COALESCE( product_terms_dim.dwid, 0 ) AS product_terms_dwid
         , COALESCE( product_dim.dwid, 0 ) AS product_dwid
         , COALESCE( investor_dim.dwid, 0 ) AS product_investor_dwid
         , COALESCE( hmda_purchaser_of_loan_dim.dwid, 0 ) AS hmda_purchaser_of_loan_dwid
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
         , COALESCE( agency_case_id_assigned_date_dim.dwid, 0 ) AS agency_case_id_assigned_date_dwid
         , COALESCE( apor_date_dim.dwid, 0 ) AS apor_date_dwid
         , COALESCE( application_signed_date_dim.dwid, 0 ) AS application_signed_date_dwid
         , COALESCE( approved_with_conditions_date_dim.dwid, 0 ) AS approved_with_conditions_date_dwid
         , COALESCE( beneficiary_from_date_dim.dwid, 0 ) AS beneficiary_from_date_dwid
         , COALESCE( beneficiary_through_date_dim.dwid, 0 ) AS beneficiary_through_date_dwid
         , COALESCE( collateral_sent_date_dim.dwid, 0 ) AS collateral_sent_date_dwid
         , COALESCE( disbursement_date_dim.dwid, 0 ) AS disbursement_date_dwid
         , COALESCE( early_funding_date_dim.dwid, 0 ) AS early_funding_date_dwid
         , COALESCE( effective_funding_date_dim.dwid, 0 ) AS effective_funding_date_dwid
         , COALESCE( fha_endorsement_date_dim.dwid, 0 ) AS fha_endorsement_date_dwid
         , COALESCE( estimated_funding_date_dim.dwid, 0 ) AS estimated_funding_date_dwid
         , COALESCE( intent_to_proceed_date_dim.dwid, 0 ) AS intent_to_proceed_date_dwid
         , COALESCE( funding_date_dim.dwid, 0 ) AS funding_date_dwid
         , COALESCE( funding_requested_date_dim.dwid, 0 ) AS funding_requested_date_dwid
         , COALESCE( loan_file_ship_date_dim.dwid, 0 ) AS loan_file_ship_date_dwid
         , COALESCE( mers_transfer_creation_date_dim.dwid, 0 ) AS mers_transfer_creation_date_dwid
         , COALESCE( pending_wire_date_dim.dwid, 0 ) AS pending_wire_date_dwid
         , COALESCE( rejected_date_dim.dwid, 0 ) AS rejected_date_dwid
         , COALESCE( return_confirmed_date_dim.dwid, 0 ) AS return_confirmed_date_dwid
         , COALESCE( return_request_date_dim.dwid, 0 ) AS return_request_date_dwid
         , COALESCE( scheduled_release_date_dim.dwid, 0 ) AS scheduled_release_date_dwid
         , COALESCE( usda_guarantee_date_dim.dwid, 0 ) AS usda_guarantee_date_dwid
         , COALESCE( va_guaranty_date_dim.dwid, 0 ) AS va_guaranty_date_dwid
         , COALESCE( account_executive.dwid, 0 ) AS account_executive_lender_user_dwid
         , COALESCE( closing_doc_specialist.dwid, 0 ) AS closing_doc_specialist_lender_user_dwid
         , COALESCE( closing_scheduler.dwid, 0 ) AS closing_scheduler_lender_user_dwid
         , COALESCE( collateral_to_investor.dwid, 0 ) AS collateral_to_investor_lender_user_dwid
         , COALESCE( collateral_underwriter.dwid, 0 ) AS collateral_underwriter_lender_user_dwid
         , COALESCE( correspondent_client_advocate.dwid, 0 ) AS correspondent_client_advocate_lender_user_dwid
         , COALESCE( final_documents_to_investor.dwid, 0 ) AS final_documents_to_investor_lender_user_dwid
         , COALESCE( flood_insurance_specialist.dwid, 0 ) AS flood_insurance_specialist_lender_user_dwid
         , COALESCE( funder.dwid, 0 ) AS funder_lender_user_dwid
         , COALESCE( government_insurance.dwid, 0 ) AS government_insurance_lender_user_dwid
         , COALESCE( ho6_specialist.dwid, 0 ) AS ho6_specialist_lender_user_dwid
         , COALESCE( hoa_specialist.dwid, 0 ) AS hoa_specialist_lender_user_dwid
         , COALESCE( hoi_specialist.dwid, 0 ) AS hoi_specialist_lender_user_dwid
         , COALESCE( hud_va_lender_officer.dwid, 0 ) AS hud_va_lender_officer_lender_user_dwid
         , COALESCE( internal_construction_manager.dwid, 0 ) AS internal_construction_manager_lender_user_dwid
         , COALESCE( investor_conditions.dwid, 0 ) AS investor_conditions_lender_user_dwid
         , COALESCE( investor_stack_to_investor.dwid, 0 ) AS investor_stack_to_investor_lender_user_dwid
         , COALESCE( loan_officer_assistant.dwid, 0 ) AS loan_officer_assistant_lender_user_dwid
         , COALESCE( loan_payoff_specialist.dwid, 0 ) AS loan_payoff_specialist_lender_user_dwid
         , COALESCE( originator.dwid, 0 ) AS originator_lender_user_dwid
         , COALESCE( processor.dwid, 0 ) AS processor_lender_user_dwid
         , COALESCE( project_underwriter.dwid, 0 ) AS project_underwriter_lender_user_dwid
         , COALESCE( subordination_specialist.dwid, 0 ) AS subordination_specialist_lender_user_dwid
         , COALESCE( supplemental_originator.dwid, 0 ) AS supplemental_originator_lender_user_dwid
         , COALESCE( title_specialist.dwid, 0 ) AS title_specialist_lender_user_dwid
         , COALESCE( transaction_assistant.dwid, 0 ) AS transaction_assistant_lender_user_dwid
         , COALESCE( underwriter.dwid, 0 ) AS underwriter_lender_user_dwid
         , COALESCE( underwriting_manager.dwid, 0 ) AS underwriting_manager_lender_user_dwid
         , COALESCE( va_specialist.dwid, 0 ) AS va_specialist_lender_user_dwid
         , COALESCE( verbal_voe_specialist.dwid, 0 ) AS verbal_voe_specialist_lender_user_dwid
         , COALESCE( voe_specialist.dwid, 0 ) AS voe_specialist_lender_user_dwid
         , COALESCE( wholesale_client_advocate.dwid, 0 ) AS wholesale_client_advocate_lender_user_dwid
         , COALESCE( wire_specialist.dwid, 0 ) AS wire_specialist_lender_user_dwid
         , COALESCE( current_beneficiary_investor_dim.dwid, 0 ) AS current_beneficiary_investor_dwid
         , COALESCE( initial_beneficiary_investor_dim.dwid, 0 ) AS initial_beneficiary_investor_dwid
         , COALESCE( first_beneficiary_after_initial_investor_dim.dwid, 0 ) AS
        first_beneficiary_after_initial_investor_dwid
         , COALESCE( most_recent_purchasing_beneficiary_investor_dim.dwid, 0 ) AS
        most_recent_purchasing_beneficiary_investor_dwid
         , COALESCE( current_deal_stage_date_dim.dwid, 0 ) AS current_transaction_stage_from_date_dwid
         , COALESCE( cd_clear_date_dim.dwid, 0 ) AS cd_clear_date_dwid
         , COALESCE( charges_enabled_date_dim.dwid, 0 ) AS charges_enabled_date_dwid
         , COALESCE( effective_earliest_allowed_consummation_date_dim.dwid, 0 ) AS effective_earliest_allowed_consummation_date_dwid
         , COALESCE( effective_hmda_action_date_dim.dwid, 0 ) AS effective_hmda_action_date_dwid
         , COALESCE( effective_note_date_dim.dwid, 0 ) AS effective_note_date_dwid
         , COALESCE( hmda_action_date_dim.dwid, 0 ) AS hmda_action_date_dwid
         , COALESCE( initial_cancel_status_date_dim.dwid, 0 ) AS initial_cancel_status_date_dwid
         , COALESCE( initial_uw_disposition_date_dim.dwid, 0 ) AS initial_uw_disposition_date_dwid
         , COALESCE( initial_uw_submit_date_dim.dwid, 0 ) AS initial_uw_submit_date_dwid
         , COALESCE( note_date_dim.dwid, 0 ) AS note_date_dwid
         , COALESCE( preapproval_complete_date_dim.dwid, 0 ) AS preapproval_complete_date_dwid
         , COALESCE( transaction_create_date_dim.dwid, 0 ) AS transaction_create_date_dwid
         , COALESCE( transaction_welcome_call_date_dim.dwid, 0 ) AS transaction_welcome_call_date_dwid
         , COALESCE( trid_application_date_dim.dwid, 0 ) AS trid_application_date_dwid
         , COALESCE( underwrite_publish_date_dim.dwid, 0 ) AS underwrite_publish_date_dwid
         , COALESCE( cash_out_reason_dim.dwid, 0 ) AS cash_out_reason_dwid
         , COALESCE( hmda_action_dim.dwid, 0 ) AS hmda_action_dwid
         , COALESCE( underwrite_dim.dwid, 0 ) AS underwrite_dwid
    FROM
        -- history_octane deal
        (
            SELECT deal.*
                 , <<deal_partial_load_condition>> AS include_record
            FROM history_octane.deal
            LEFT JOIN history_octane.deal AS history_records
                      ON deal.d_pid = history_records.d_pid
                          AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE deal.data_source_deleted_flag IS FALSE
              AND history_records.d_pid IS NULL) AS deal
            -- history_octane deal_stage
        JOIN (
            SELECT deal_stage.*
                 , <<deal_stage_partial_load_condition>> AS include_record
            FROM history_octane.deal_stage
            LEFT JOIN history_octane.deal_stage AS history_records
                      ON deal_stage.dst_pid = history_records.dst_pid
                          AND deal_stage.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE deal_stage.data_source_deleted_flag IS FALSE
              AND deal_stage.dst_through_date IS NULL
              AND history_records.dst_pid IS NULL) AS deal_stage
             ON deal.d_pid = deal_stage.dst_deal_pid
            -- history_octane proposal
        JOIN (
            SELECT proposal.*
                 , <<proposal_partial_load_condition>> AS include_record
            FROM history_octane.proposal
            LEFT JOIN history_octane.proposal AS history_records
                      ON proposal.prp_pid = history_records.prp_pid
                          AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE proposal.data_source_deleted_flag IS FALSE
              AND history_records.prp_pid IS NULL) AS proposal
             ON deal.d_active_proposal_pid = proposal.prp_pid
            -- history_octane (primary) application
        JOIN (
            SELECT application.*
                 , <<application_partial_load_condition>> AS include_record
            FROM history_octane.application
            LEFT JOIN history_octane.application AS history_records
                      ON application.apl_pid = history_records.apl_pid
                          AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE application.data_source_deleted_flag IS FALSE
              AND history_records.apl_pid IS NULL) AS primary_application
             ON proposal.prp_pid = primary_application.apl_proposal_pid
                 AND primary_application.apl_primary_application IS TRUE
            -- history_octane loan
        JOIN (
            SELECT loan.*
                 , <<loan_partial_load_condition>> AS include_record
            FROM history_octane.loan
            LEFT JOIN history_octane.loan AS history_records
                      ON loan.l_pid = history_records.l_pid
                          AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE loan.data_source_deleted_flag IS FALSE
              AND history_records.l_pid IS NULL) AS loan
             ON proposal.prp_pid = loan.l_proposal_pid
            -- history_octane deal_key_roles
        JOIN (
            SELECT deal_key_roles.*
                 , <<deal_key_roles_partial_load_condition>> AS include_record
            FROM history_octane.deal_key_roles
            LEFT JOIN history_octane.deal_key_roles AS history_records
                      ON deal_key_roles.dkrs_pid = history_records.dkrs_pid
                          AND deal_key_roles.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE deal_key_roles.data_source_deleted_flag IS FALSE
              AND history_records.dkrs_pid IS NULL) AS deal_key_roles
             ON deal.d_pid = deal_key_roles.dkrs_deal_pid
            -- history_octane.borrower B1
        JOIN (
            SELECT *
            FROM (
                SELECT borrower.*
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_b1
             ON proposal.prp_pid = borrower_b1.apl_proposal_pid
                 AND borrower_b1.b_borrower_tiny_id_type = ''B1''
            -- history_octane.borrower B2
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_b2
                  ON proposal.prp_pid = borrower_b2.apl_proposal_pid
                      AND borrower_b2.b_borrower_tiny_id_type = ''B2''
            -- history_octane.borrower B3
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_b3
                  ON proposal.prp_pid = borrower_b3.apl_proposal_pid
                      AND borrower_b3.b_borrower_tiny_id_type = ''B3''
            -- history_octane.borrower B4
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_b4
                  ON proposal.prp_pid = borrower_b4.apl_proposal_pid
                      AND borrower_b4.b_borrower_tiny_id_type = ''B4''
            -- history_octane.borrower B5
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_b5
                  ON proposal.prp_pid = borrower_b5.apl_proposal_pid
                      AND borrower_b5.b_borrower_tiny_id_type = ''B5''
            -- history_octane.borrower C1
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_c1
                  ON proposal.prp_pid = borrower_c1.apl_proposal_pid
                      AND borrower_c1.b_borrower_tiny_id_type = ''C1''
            -- history_octane.borrower C2
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_c2
                  ON proposal.prp_pid = borrower_c2.apl_proposal_pid
                      AND borrower_c2.b_borrower_tiny_id_type = ''C2''
            -- history_octane.borrower C3
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_c3
                  ON proposal.prp_pid = borrower_c3.apl_proposal_pid
                      AND borrower_c3.b_borrower_tiny_id_type = ''C3''
            -- history_octane.borrower C4
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_c4
                  ON proposal.prp_pid = borrower_c4.apl_proposal_pid
                      AND borrower_c4.b_borrower_tiny_id_type = ''C4''
            -- history_octane.borrower C5
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_c5
                  ON proposal.prp_pid = borrower_c5.apl_proposal_pid
                      AND borrower_c5.b_borrower_tiny_id_type = ''C5''
            -- history_octane.borrower N1
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_n1
                  ON proposal.prp_pid = borrower_n1.apl_proposal_pid
                      AND borrower_n1.b_borrower_tiny_id_type = ''N1''
            -- history_octane.borrower N2
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_n2
                  ON proposal.prp_pid = borrower_n2.apl_proposal_pid
                      AND borrower_n2.b_borrower_tiny_id_type = ''N2''
            -- history_octane.borrower N3
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_n3
                  ON proposal.prp_pid = borrower_n3.apl_proposal_pid
                      AND borrower_n3.b_borrower_tiny_id_type = ''N3''
            -- history_octane.borrower N4
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_n4
                  ON proposal.prp_pid = borrower_n4.apl_proposal_pid
                      AND borrower_n4.b_borrower_tiny_id_type = ''N4''
            -- history_octane.borrower N5
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_n5
                  ON proposal.prp_pid = borrower_n5.apl_proposal_pid
                      AND borrower_n5.b_borrower_tiny_id_type = ''N5''
            -- history_octane.borrower N6
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_n6
                  ON proposal.prp_pid = borrower_n6.apl_proposal_pid
                      AND borrower_n6.b_borrower_tiny_id_type = ''N6''
            -- history_octane.borrower N7
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_n7
                  ON proposal.prp_pid = borrower_n7.apl_proposal_pid
                      AND borrower_n7.b_borrower_tiny_id_type = ''N7''
            -- history_octane.borrower N8
        LEFT JOIN (
            SELECT *
            FROM (
                SELECT borrower.b_pid
                     , borrower.b_application_pid
                     , borrower.b_borrower_tiny_id_type
                     , <<borrower_partial_load_condition>> AS include_record
                FROM history_octane.borrower
                LEFT JOIN history_octane.borrower AS history_records
                          ON borrower.b_pid = history_records.b_pid
                              AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE borrower.data_source_deleted_flag IS FALSE
                  AND history_records.b_pid IS NULL
            ) AS borrower
            JOIN (
                SELECT application.apl_proposal_pid
                     , application.apl_pid
                FROM history_octane.application
                LEFT JOIN history_octane.application AS history_records
                          ON application.apl_pid = history_records.apl_pid
                              AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
                WHERE application.data_source_deleted_flag IS FALSE
                  AND history_records.apl_pid IS NULL
            ) AS application
                 ON borrower.b_application_pid = application.apl_pid
        ) AS borrower_n8
                  ON proposal.prp_pid = borrower_n8.apl_proposal_pid
                      AND borrower_n8.b_borrower_tiny_id_type = ''N8''
            -- history_octane.loan_beneficiary: current
        LEFT JOIN (
            SELECT loan_beneficiary.*
                 , <<loan_beneficiary_partial_load_condition>> AS include_record
            FROM history_octane.loan_beneficiary
            LEFT JOIN history_octane.loan_beneficiary AS history_records
                      ON loan_beneficiary.lb_pid =
                         history_records.lb_pid
                          AND loan_beneficiary.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE loan_beneficiary.data_source_deleted_flag IS FALSE
              AND history_records.lb_pid IS NULL
        ) AS current_loan_beneficiary
                  ON loan.l_pid = current_loan_beneficiary.lb_loan_pid
                      AND current_loan_beneficiary.lb_current IS TRUE
            -- history_octane.loan_beneficiary: initial beneficiary
        LEFT JOIN (
            SELECT loan_beneficiary.*
                 , <<loan_beneficiary_partial_load_condition>> AS include_record
            FROM history_octane.loan_beneficiary
            LEFT JOIN history_octane.loan_beneficiary AS history_records
                      ON loan_beneficiary.lb_pid =
                         history_records.lb_pid
                          AND loan_beneficiary.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE loan_beneficiary.data_source_deleted_flag IS FALSE
              AND history_records.lb_pid IS NULL
        ) AS initial_loan_beneficiary
                  ON loan.l_pid = initial_loan_beneficiary.lb_loan_pid
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
                         , MIN( loan_beneficiary.lb_pid ) AS min_lb_pid
                    FROM history_octane.loan_beneficiary
                    WHERE loan_beneficiary.lb_initial IS FALSE
                    GROUP BY loan_beneficiary.lb_loan_pid
                ) AS min_lb_pid_per_loan
                     ON loan_beneficiary.lb_pid = min_lb_pid_per_loan.min_lb_pid
            ) AS loan_beneficiary
            LEFT JOIN history_octane.loan_beneficiary AS history_records
                      ON loan_beneficiary.lb_pid = history_records.lb_pid
                          AND loan_beneficiary.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE loan_beneficiary.data_source_deleted_flag IS FALSE
              AND history_records.lb_pid IS NULL
        ) AS first_loan_beneficiary_after_initial
                  ON loan.l_pid = first_loan_beneficiary_after_initial.lb_loan_pid
            -- history_octane.loan_beneficiary: most recent purchasing beneficiary
        LEFT JOIN (
            SELECT loan_beneficiary.*
                 , <<loan_beneficiary_partial_load_condition>> AS include_record
            FROM (
                SELECT loan_beneficiary.*
                FROM history_octane.loan_beneficiary
                JOIN (
                    SELECT loan_beneficiary.lb_loan_pid
                         , MAX( loan_beneficiary.lb_pid ) AS max_lb_pid
                    FROM history_octane.loan_beneficiary
                    WHERE loan_beneficiary.lb_loan_benef_transfer_status_type IN
                          (''SHIPPED'', ''APPROVED_WITH_CONDITIONS'', ''PENDING_WIRE'', ''PENDING'', ''PURCHASED'')
                    GROUP BY loan_beneficiary.lb_loan_pid
                ) AS max_lb_pid_per_loan
                     ON loan_beneficiary.lb_pid = max_lb_pid_per_loan.max_lb_pid
            ) AS loan_beneficiary
            LEFT JOIN history_octane.loan_beneficiary AS history_records
                      ON loan_beneficiary.lb_pid = history_records.lb_pid
                          AND loan_beneficiary.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE loan_beneficiary.data_source_deleted_flag IS FALSE
              AND history_records.lb_pid IS NULL
        ) AS most_recent_purchasing_beneficiary
                  ON loan.l_pid = most_recent_purchasing_beneficiary.lb_loan_pid
            -- history_octane.loan_funding
        LEFT JOIN (
            SELECT loan_funding.*
                 , <<loan_funding_partial_load_condition>> AS include_record
            FROM history_octane.loan_funding
            LEFT JOIN history_octane.loan_funding AS history_records
                      ON loan_funding.lf_pid = history_records.lf_pid
                          AND loan_funding.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE loan_funding.data_source_deleted_flag IS FALSE
              AND history_records.lf_pid IS NULL
        ) AS active_loan_funding
                  ON loan.l_pid = active_loan_funding.lf_loan_pid
                      AND active_loan_funding.lf_return_confirmed_date IS NULL
            -- history_octane.interim_funder
        LEFT JOIN (
            SELECT interim_funder.*
                 , <<interim_funder_partial_load_condition>> AS include_record
            FROM history_octane.interim_funder
            LEFT JOIN history_octane.interim_funder AS history_records
                      ON interim_funder.if_pid = history_records.if_pid
                          AND interim_funder.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE interim_funder.data_source_deleted_flag IS FALSE
              AND history_records.if_pid IS NULL
        ) AS interim_funder
                  ON active_loan_funding.lf_interim_funder_pid = interim_funder.if_pid
            -- history_octane.product_terms
        LEFT JOIN (
            SELECT product_terms.*
                 , <<product_terms_partial_load_condition>> AS include_record
            FROM history_octane.product_terms
            LEFT JOIN history_octane.product_terms AS history_records
                      ON product_terms.pt_pid = history_records.pt_pid
                          AND product_terms.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE product_terms.data_source_deleted_flag IS FALSE
              AND history_records.pt_pid IS NULL
        ) AS product_terms
                  ON loan.l_product_terms_pid = product_terms.pt_pid
            -- history_octane.product
        LEFT JOIN (
            SELECT product.*
                 , <<product_partial_load_condition>> AS include_record
            FROM history_octane.product
            LEFT JOIN history_octane.product AS history_records
                      ON product.p_pid = history_records.p_pid
                          AND product.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE product.data_source_deleted_flag IS FALSE
              AND history_records.p_pid IS NULL
        ) AS product
                  ON product_terms.pt_product_pid = product.p_pid
            -- history_octane.investor
        LEFT JOIN (
            SELECT investor.*
                 , <<investor_partial_load_condition>> AS include_record
            FROM history_octane.investor
            LEFT JOIN history_octane.investor AS history_records
                      ON investor.i_pid = history_records.i_pid
                          AND investor.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE investor.data_source_deleted_flag IS FALSE
              AND history_records.i_pid IS NULL
        ) AS product_investor
                  ON product.p_investor_pid = product_investor.i_pid
            -- history_octane.hmda_purchaser_of_loan_2017_type
        LEFT JOIN history_octane.hmda_purchaser_of_loan_2017_type
                  ON loan.l_hmda_purchaser_of_loan_2017_type =
                     hmda_purchaser_of_loan_2017_type.code
                      AND hmda_purchaser_of_loan_2017_type.data_source_deleted_flag IS FALSE
            -- history_octane.hmda_purchaser_of_loan_2018_type
        LEFT JOIN history_octane.hmda_purchaser_of_loan_2018_type
                  ON loan.l_hmda_purchaser_of_loan_2018_type =
                     hmda_purchaser_of_loan_2018_type.code
                      AND hmda_purchaser_of_loan_2018_type.data_source_deleted_flag IS FALSE
            -- star_loan.loan_dim
        JOIN (
            SELECT loan_dim.*
                 , <<loan_dim_partial_load_condition>> AS include_record
            FROM star_loan.loan_dim
        ) AS loan_dim
             ON loan.l_pid = loan_dim.loan_pid
                 AND loan_dim.data_source_dwid = 1
            -- star_loan.loan_fact
        LEFT JOIN star_loan.loan_fact
                  ON loan_dim.dwid = loan_fact.loan_dwid
                      AND loan_fact.data_source_dwid = 1
            -- star_loan.application_dim
        LEFT JOIN (
            SELECT application_dim.*
                 , <<application_dim_partial_load_condition>> AS include_record
            FROM star_loan.application_dim
        ) AS application_dim
                  ON primary_application.apl_pid = application_dim.application_pid
                      AND application_dim.data_source_dwid = 1
            -- star_loan.loan_junk_dim
        LEFT JOIN (
            SELECT loan_junk_dim.*
                 , <<loan_junk_dim_partial_load_condition>> AS include_record
            FROM star_loan.loan_junk_dim
        ) AS loan_junk_dim
                  ON loan.l_buydown_contributor_type IS NOT DISTINCT FROM loan_junk_dim.buydown_contributor_code
                      AND loan.l_fha_program_code_type IS NOT DISTINCT FROM loan_junk_dim.fha_program_code
                      AND loan.l_hmda_hoepa_status_type IS NOT DISTINCT FROM loan_junk_dim.hmda_hoepa_status_code
                      AND loan.l_durp_eligibility_opt_out IS NOT DISTINCT FROM loan_junk_dim.durp_eligibility_opt_out_flag
                      AND loan.l_fha_principal_write_down IS NOT DISTINCT FROM loan_junk_dim.fha_principal_write_down_flag
                      AND loan.l_hpml IS NOT DISTINCT FROM loan_junk_dim.hpml_flag
                      AND loan.l_lender_concession_candidate IS NOT DISTINCT FROM loan_junk_dim.lender_concession_candidate_flag
                      AND proposal.prp_mi_required IS NOT DISTINCT FROM loan_junk_dim.mi_required_flag
                      AND (CASE
                               WHEN (loan.l_lien_priority_type IS NULL OR proposal.prp_structure_type IS NULL) THEN NULL
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
        ) AS product_choice_dim
                  ON loan.l_aus_type IS NOT DISTINCT FROM product_choice_dim.aus_code
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
        ) AS transaction_junk_dim
                  ON (CASE
                          WHEN proposal.prp_structure_type = ''COMBO'' THEN TRUE
                          ELSE FALSE
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
        ) AS transaction_dim
                  ON deal.d_pid = transaction_dim.deal_pid
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
        ) AS loan_funding_dim
                  ON active_loan_funding.lf_pid = loan_funding_dim.loan_funding_pid
                      AND loan_funding_dim.data_source_dwid = 1
            -- star_loan.borrower B1
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_b1_dim
                  ON borrower_b1.b_pid = borrower_b1_dim.borrower_pid
                      AND borrower_b1_dim.data_source_dwid = 1
            -- star_loan.borrower B2
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_b2_dim
                  ON borrower_b2.b_pid = borrower_b2_dim.borrower_pid
                      AND borrower_b2_dim.data_source_dwid = 1
            -- star_loan.borrower B3
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_b3_dim
                  ON borrower_b3.b_pid = borrower_b3_dim.borrower_pid
                      AND borrower_b3_dim.data_source_dwid = 1
            -- star_loan.borrower B4
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_b4_dim
                  ON borrower_b4.b_pid = borrower_b4_dim.borrower_pid
                      AND borrower_b4_dim.data_source_dwid = 1
            -- star_loan.borrower B5
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_b5_dim
                  ON borrower_b5.b_pid = borrower_b5_dim.borrower_pid
                      AND borrower_b5_dim.data_source_dwid = 1
            -- star_loan.borrower C1
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_c1_dim
                  ON borrower_c1.b_pid = borrower_c1_dim.borrower_pid
                      AND borrower_c1_dim.data_source_dwid = 1
            -- star_loan.borrower C2
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_c2_dim
                  ON borrower_c2.b_pid = borrower_c2_dim.borrower_pid
                      AND borrower_c2_dim.data_source_dwid = 1
            -- star_loan.borrower C3
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_c3_dim
                  ON borrower_c3.b_pid = borrower_c3_dim.borrower_pid
                      AND borrower_c3_dim.data_source_dwid = 1
            -- star_loan.borrower C4
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_c4_dim
                  ON borrower_c4.b_pid = borrower_c4_dim.borrower_pid
                      AND borrower_c4_dim.data_source_dwid = 1
            -- star_loan.borrower C5
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_c5_dim
                  ON borrower_c5.b_pid = borrower_c5_dim.borrower_pid
                      AND borrower_c5_dim.data_source_dwid = 1
            -- star_loan.borrower N1
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_n1_dim
                  ON borrower_n1.b_pid = borrower_n1_dim.borrower_pid
                      AND borrower_n1_dim.data_source_dwid = 1
            -- star_loan.borrower N2
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_n2_dim
                  ON borrower_n2.b_pid = borrower_n2_dim.borrower_pid
                      AND borrower_n2_dim.data_source_dwid = 1
            -- star_loan.borrower N3
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_n3_dim
                  ON borrower_n3.b_pid = borrower_n3_dim.borrower_pid
                      AND borrower_n3_dim.data_source_dwid = 1
            -- star_loan.borrower N4
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_n4_dim
                  ON borrower_n4.b_pid = borrower_n4_dim.borrower_pid
                      AND borrower_n4_dim.data_source_dwid = 1
            -- star_loan.borrower N5
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_n5_dim
                  ON borrower_n5.b_pid = borrower_n5_dim.borrower_pid
                      AND borrower_n5_dim.data_source_dwid = 1
            -- star_loan.borrower N6
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_n6_dim
                  ON borrower_n6.b_pid = borrower_n6_dim.borrower_pid
                      AND borrower_n6_dim.data_source_dwid = 1
            -- star_loan.borrower N7
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_n7_dim
                  ON borrower_n7.b_pid = borrower_n7_dim.borrower_pid
                      AND borrower_n7_dim.data_source_dwid = 1
            -- star_loan.borrower N8
        LEFT JOIN (
            SELECT borrower_dim.*
                 , <<borrower_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_dim
        ) AS borrower_n8_dim
                  ON borrower_n8.b_pid = borrower_n8_dim.borrower_pid
                      AND borrower_n8_dim.data_source_dwid = 1
            -- star_loan.borrower_demographics_dim
        LEFT JOIN (
            SELECT borrower_demographics_dim.*
                 , <<borrower_demographics_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_demographics_dim
        ) AS borrower_demographics_dim
                  ON borrower_b1.b_ethnicity_collected_visual_or_surname IS NOT DISTINCT FROM
                     borrower_demographics_dim.ethnicity_collected_visual_or_surname_code
                      AND borrower_b1.b_ethnicity_refused IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_refused_code
                      AND (CASE
                               WHEN borrower_b1.b_ethnicity_other_hispanic_or_latino_description <> ''''
                                   AND borrower_b1.b_ethnicity_other_hispanic_or_latino_description IS NOT NULL THEN TRUE
                               ELSE FALSE END) IS NOT DISTINCT FROM
                          borrower_demographics_dim.ethnicity_other_hispanic_or_latino_description_flag
                      AND (CASE
                               WHEN borrower_b1.b_other_race_national_origin_description <> ''''
                                   AND borrower_b1.b_other_race_national_origin_description IS NOT NULL THEN TRUE
                               ELSE FALSE END) IS NOT DISTINCT FROM
                          borrower_demographics_dim.other_race_national_origin_description_flag
                      AND (CASE
                               WHEN borrower_b1.b_race_other_american_indian_or_alaska_native_description <> ''''
                                   AND borrower_b1.b_race_other_american_indian_or_alaska_native_description IS NOT NULL THEN TRUE
                               ELSE FALSE END) IS NOT DISTINCT FROM
                          borrower_demographics_dim.race_other_american_indian_or_alaska_native_description_flag
                      AND (CASE
                               WHEN borrower_b1.b_race_other_asian_description <> ''''
                                   AND borrower_b1.b_race_other_asian_description IS NOT NULL THEN TRUE
                               ELSE FALSE END) IS NOT DISTINCT FROM
                          borrower_demographics_dim.race_other_asian_description_flag
                      AND (CASE
                               WHEN borrower_b1.b_race_other_pacific_islander_description <> ''''
                                   AND borrower_b1.b_race_other_pacific_islander_description IS NOT NULL THEN TRUE
                               ELSE FALSE END) IS NOT DISTINCT FROM
                          borrower_demographics_dim.race_other_pacific_islander_description_flag
                      AND borrower_b1.b_ethnicity_cuban IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_cuban_flag
                      AND borrower_b1.b_ethnicity_hispanic_or_latino IS NOT DISTINCT FROM
                          borrower_demographics_dim.ethnicity_hispanic_or_latino_flag
                      AND borrower_b1.b_ethnicity_mexican IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_mexican_flag
                      AND borrower_b1.b_ethnicity_not_hispanic_or_latino IS NOT DISTINCT FROM
                          borrower_demographics_dim.ethnicity_not_hispanic_or_latino_flag
                      AND
                     borrower_b1.b_ethnicity_not_obtainable IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_not_obtainable_flag
                      AND borrower_b1.b_ethnicity_other_hispanic_or_latino IS NOT DISTINCT FROM
                          borrower_demographics_dim.ethnicity_other_hispanic_or_latino_flag
                      AND borrower_b1.b_ethnicity_puerto_rican IS NOT DISTINCT FROM borrower_demographics_dim.ethnicity_puerto_rican_flag
                      AND borrower_b1.b_race_american_indian_or_alaska_native IS NOT DISTINCT FROM
                          borrower_demographics_dim.race_american_indian_or_alaska_native_flag
                      AND borrower_b1.b_race_asian IS NOT DISTINCT FROM borrower_demographics_dim.race_asian_flag
                      AND borrower_b1.b_race_asian_indian IS NOT DISTINCT FROM borrower_demographics_dim.race_asian_indian_flag
                      AND borrower_b1.b_race_black_or_african_american IS NOT DISTINCT FROM
                          borrower_demographics_dim.race_black_or_african_american_flag
                      AND borrower_b1.b_race_chinese IS NOT DISTINCT FROM borrower_demographics_dim.race_chinese_flag
                      AND borrower_b1.b_race_filipino IS NOT DISTINCT FROM borrower_demographics_dim.race_filipino_flag
                      AND
                     borrower_b1.b_race_guamanian_or_chamorro IS NOT DISTINCT FROM borrower_demographics_dim.race_guamanian_or_chamorro_flag
                      AND borrower_b1.b_race_information_not_provided IS NOT DISTINCT FROM
                          borrower_demographics_dim.race_information_not_provided_flag
                      AND borrower_b1.b_race_japanese IS NOT DISTINCT FROM borrower_demographics_dim.race_japanese_flag
                      AND borrower_b1.b_race_korean IS NOT DISTINCT FROM borrower_demographics_dim.race_korean_flag
                      AND borrower_b1.b_race_national_origin_refusal IS NOT DISTINCT FROM
                          borrower_demographics_dim.race_national_origin_refusal_flag
                      AND borrower_b1.b_race_native_hawaiian IS NOT DISTINCT FROM borrower_demographics_dim.race_native_hawaiian_flag
                      AND borrower_b1.b_race_native_hawaiian_or_other_pacific_islander IS NOT DISTINCT FROM
                          borrower_demographics_dim.race_native_hawaiian_or_other_pacific_islander_flag
                      AND borrower_b1.b_race_not_applicable IS NOT DISTINCT FROM borrower_demographics_dim.race_not_applicable_flag
                      AND borrower_b1.b_race_not_obtainable IS NOT DISTINCT FROM borrower_demographics_dim.race_not_obtainable_flag
                      AND borrower_b1.b_race_other_asian IS NOT DISTINCT FROM borrower_demographics_dim.race_other_asian_flag
                      AND borrower_b1.b_race_other_pacific_islander IS NOT DISTINCT FROM
                          borrower_demographics_dim.race_other_pacific_islander_flag
                      AND borrower_b1.b_race_samoan IS NOT DISTINCT FROM borrower_demographics_dim.race_samoan_flag
                      AND borrower_b1.b_race_vietnamese IS NOT DISTINCT FROM borrower_demographics_dim.race_vietnamese_flag
                      AND borrower_b1.b_race_white IS NOT DISTINCT FROM borrower_demographics_dim.race_white_flag
                      AND borrower_b1.b_sex_female IS NOT DISTINCT FROM borrower_demographics_dim.sex_female_flag
                      AND borrower_b1.b_sex_male IS NOT DISTINCT FROM borrower_demographics_dim.sex_male_flag
                      AND borrower_b1.b_sex_not_obtainable IS NOT DISTINCT FROM borrower_demographics_dim.sex_not_obtainable_flag
                      AND borrower_b1.b_marital_status_type IS NOT DISTINCT FROM borrower_demographics_dim.marital_status_code
                      AND borrower_b1.b_race_collected_visual_or_surname IS NOT DISTINCT FROM
                          borrower_demographics_dim.race_collected_visual_or_surname_code
                      AND borrower_b1.b_race_refused IS NOT DISTINCT FROM borrower_demographics_dim.race_refused_code
                      AND borrower_b1.b_schooling_years IS NOT DISTINCT FROM borrower_demographics_dim.schooling_years
                      AND borrower_b1.b_sex_collected_visual_or_surname IS NOT DISTINCT FROM
                          borrower_demographics_dim.sex_collected_visual_or_surname_code
                      AND borrower_b1.b_sex_refused IS NOT DISTINCT FROM borrower_demographics_dim.sex_refused_code
                      AND borrower_demographics_dim.data_source_dwid = 1
            -- star_loan.borrower_lending_profile_dim
        LEFT JOIN (
            SELECT borrower_lending_profile_dim.*
                 , <<borrower_lending_profile_dim_partial_load_condition>> AS include_record
            FROM star_loan.borrower_lending_profile_dim
        ) AS borrower_lending_profile_dim
                  ON borrower_b1.b_alimony_child_support IS NOT DISTINCT FROM
                     borrower_lending_profile_dim.alimony_child_support_code
                      AND borrower_b1.b_bankruptcy IS NOT DISTINCT FROM borrower_lending_profile_dim.bankruptcy_code
                      AND borrower_b1.b_borrowed_down_payment IS NOT DISTINCT FROM borrower_lending_profile_dim.borrowed_down_payment_code
                      AND
                     borrower_b1.b_citizenship_residency_type IS NOT DISTINCT FROM borrower_lending_profile_dim.citizenship_residency_code
                      AND borrower_b1.b_disabled IS NOT DISTINCT FROM borrower_lending_profile_dim.disabled_code
                      AND borrower_b1.b_domestic_relationship_state_type IS NOT DISTINCT FROM
                          borrower_lending_profile_dim.domestic_relationship_state_code
                      AND borrower_b1.b_has_dependents IS NOT DISTINCT FROM borrower_lending_profile_dim.dependents_code
                      AND borrower_b1.b_homeowner_past_three_years IS NOT DISTINCT FROM
                          borrower_lending_profile_dim.homeowner_past_three_years_code
                      AND borrower_b1.b_homeownership_education_agency_type IS NOT DISTINCT FROM borrower_lending_profile_dim
                          .homeownership_education_agency_code
                      AND borrower_b1.b_homeownership_education_type IS NOT DISTINCT FROM
                          borrower_lending_profile_dim.homeownership_education_code
                      AND borrower_b1.b_intend_to_occupy IS NOT DISTINCT FROM borrower_lending_profile_dim.intend_to_occupy_code
                      AND borrower_b1.b_first_time_homebuyer IS NOT DISTINCT FROM borrower_lending_profile_dim.first_time_homebuyer_flag
                      AND borrower_b1.b_first_time_home_buyer_auto_compute IS NOT DISTINCT FROM
                          borrower_lending_profile_dim.first_time_homebuyer_auto_compute_flag
                      AND borrower_b1.b_hud_employee IS NOT DISTINCT FROM borrower_lending_profile_dim.hud_employee_flag
                      AND borrower_b1.b_lender_employee_status_confirmed IS NOT DISTINCT FROM
                          borrower_lending_profile_dim.lender_employee_status_confirmed_flag
                      AND borrower_b1.b_lender_employee IS NOT DISTINCT FROM borrower_lending_profile_dim.lender_employee_code
                      AND borrower_b1.b_note_endorser IS NOT DISTINCT FROM borrower_lending_profile_dim.note_endorser_code
                      AND borrower_b1.b_obligated_loan_foreclosure IS NOT DISTINCT FROM
                          borrower_lending_profile_dim.obligated_loan_foreclosure_code
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
        ) AS interim_funder_dim
                  ON interim_funder.if_pid = interim_funder_dim.interim_funder_pid
                      AND interim_funder_dim.data_source_dwid = 1
            -- star_loan.product_terms_dim
        LEFT JOIN (
            SELECT product_terms_dim.*
                 , <<product_terms_dim_partial_load_condition>> AS include_record
            FROM star_loan.product_terms_dim
        ) AS product_terms_dim
                  ON product_terms.pt_pid = product_terms_dim.product_terms_pid
                      AND product_terms_dim.data_source_dwid = 1
            -- star_loan.product_dim
        LEFT JOIN (
            SELECT product_dim.*
                 , <<product_dim_partial_load_condition>> AS include_record
            FROM star_loan.product_dim
        ) AS product_dim
                  ON product.p_pid = product_dim.product_pid
                      AND product_dim.data_source_dwid = 1
            -- star_loan.investor_dim
        LEFT JOIN (
            SELECT investor_dim.*
                 , <<investor_dim_partial_load_condition>> AS include_record
            FROM star_loan.investor_dim
        ) AS investor_dim
                  ON product_investor.i_pid = investor_dim.investor_pid
                      AND investor_dim.data_source_dwid = 1
            -- star_loan.hmda_purchaser_of_loan_dim
        LEFT JOIN (
            SELECT hmda_purchaser_of_loan_dim.*
                 , <<hmda_purchaser_of_loan_dim_partial_load_condition>> AS include_record
            FROM star_loan.hmda_purchaser_of_loan_dim
        ) AS hmda_purchaser_of_loan_dim
                  ON hmda_purchaser_of_loan_2017_type.code IS NOT DISTINCT FROM hmda_purchaser_of_loan_dim.code_2017
                      AND hmda_purchaser_of_loan_2018_type.code IS NOT DISTINCT FROM hmda_purchaser_of_loan_dim.code_2018
                      AND hmda_purchaser_of_loan_dim.data_source_dwid = 1
            -- star_loan.cash_out_reason_dim
        LEFT JOIN (
            SELECT cash_out_reason_dim.*
                 , <<cash_out_reason_dim_partial_load_condition>> AS include_record
            FROM star_loan.cash_out_reason_dim
        ) AS cash_out_reason_dim
                  ON proposal.prp_cash_out_reason_business_debt_or_debt_consolidation IS NOT DISTINCT FROM
                     cash_out_reason_dim.cash_out_reason_business_debt_or_debt_consolidation_flag
                      AND proposal.prp_cash_out_reason_debt_or_debt_consolidation IS NOT DISTINCT FROM cash_out_reason_dim
                          .cash_out_reason_debt_or_debt_consolidation_flag
                      AND proposal.prp_cash_out_reason_future_investment_not_under_contract IS NOT DISTINCT FROM
                          cash_out_reason_dim.cash_out_reason_future_investment_not_under_contract_flag
                      AND proposal.prp_cash_out_reason_future_investment_under_contract IS NOT DISTINCT FROM
                          cash_out_reason_dim.cash_out_reason_future_investment_under_contract_flag
                      AND proposal.prp_cash_out_reason_home_improvement IS NOT DISTINCT FROM
                          cash_out_reason_dim.cash_out_reason_home_improvement_flag
                      AND proposal.prp_cash_out_reason_investment_or_business_property IS NOT DISTINCT FROM
                          cash_out_reason_dim.cash_out_reason_investment_or_business_property_flag
                      AND proposal.prp_cash_out_reason_other IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_other_flag
                      AND
                     proposal.prp_cash_out_reason_personal_use IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_personal_use_flag
                      AND
                     proposal.prp_cash_out_reason_student_loans IS NOT DISTINCT FROM cash_out_reason_dim.cash_out_reason_student_loans_flag
                      AND proposal.prp_non_business_cash_out_reason_acknowledged IS NOT DISTINCT FROM
                          cash_out_reason_dim.non_business_cash_out_reason_acknowledged_code
                      AND cash_out_reason_dim.data_source_dwid = 1
            -- star_loan.hmda_action_dim
        LEFT JOIN (
            SELECT hmda_action_dim.*
                 , <<hmda_action_dim_partial_load_condition>> AS include_record
            FROM star_loan.hmda_action_dim
        ) AS hmda_action_dim
                  ON deal.d_hmda_action_type IS NOT DISTINCT FROM hmda_action_dim.hmda_action_code
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
        ) AS underwrite_dim
                  ON proposal.prp_underwrite_disposition_type IS NOT DISTINCT FROM underwrite_dim.underwrite_disposition_code
                      AND proposal.prp_underwrite_method_type IS NOT DISTINCT FROM underwrite_dim.underwrite_method_code
                      AND proposal.prp_underwrite_risk_assessment_type IS NOT DISTINCT FROM underwrite_dim.underwrite_risk_assessment_code
                      AND underwrite_dim.data_source_dwid = 1
            -- star_loan.date_dim joins for date dwids
        LEFT JOIN star_common.date_dim current_deal_stage_date_dim
                  ON deal_stage.dst_from_date = current_deal_stage_date_dim.value
        LEFT JOIN star_common.date_dim agency_case_id_assigned_date_dim
                  ON loan.l_agency_case_id_assigned_date =
                     agency_case_id_assigned_date_dim.value
        LEFT JOIN star_common.date_dim apor_date_dim
                  ON loan.l_apor_date = apor_date_dim.value
        LEFT JOIN star_common.date_dim application_signed_date_dim
                  ON borrower_b1.b_application_signed_date =
                     application_signed_date_dim.value
        LEFT JOIN star_common.date_dim approved_with_conditions_date_dim
                  ON
                          current_loan_beneficiary.lb_approved_with_conditions_date = approved_with_conditions_date_dim.value
        LEFT JOIN star_common.date_dim beneficiary_from_date_dim
                  ON current_loan_beneficiary.lb_from_date
                      = beneficiary_from_date_dim.value
        LEFT JOIN star_common.date_dim beneficiary_through_date_dim
                  ON current_loan_beneficiary.lb_through_date =
                     beneficiary_through_date_dim.value
        LEFT JOIN star_common.date_dim collateral_sent_date_dim
                  ON active_loan_funding.lf_collateral_sent_date =
                     collateral_sent_date_dim.value
        LEFT JOIN star_common.date_dim disbursement_date_dim
                  ON active_loan_funding.lf_disbursement_date =
                     disbursement_date_dim.value
        LEFT JOIN star_common.date_dim early_funding_date_dim
                  ON current_loan_beneficiary.lb_early_funding_date =
                     early_funding_date_dim.value
        LEFT JOIN star_common.date_dim effective_funding_date_dim
                  ON proposal.prp_effective_funding_date =
                     effective_funding_date_dim.value
        LEFT JOIN star_common.date_dim fha_endorsement_date_dim
                  ON loan.l_fha_endorsement_date =
                     fha_endorsement_date_dim.value
        LEFT JOIN star_common.date_dim estimated_funding_date_dim
                  ON proposal.prp_estimated_funding_date =
                     estimated_funding_date_dim.value
        LEFT JOIN star_common.date_dim intent_to_proceed_date_dim
                  ON proposal.prp_intent_to_proceed_date =
                     intent_to_proceed_date_dim.value
        LEFT JOIN star_common.date_dim funding_date_dim
                  ON active_loan_funding.lf_funding_date = funding_date_dim.value
        LEFT JOIN star_common.date_dim funding_requested_date_dim
                  ON active_loan_funding.lf_requested_date =
                     funding_requested_date_dim.value
        LEFT JOIN star_common.date_dim loan_file_ship_date_dim
                  ON current_loan_beneficiary.lb_loan_file_ship_date =
                     loan_file_ship_date_dim.value
        LEFT JOIN star_common.date_dim mers_transfer_creation_date_dim
                  ON current_loan_beneficiary.lb_mers_transfer_creation_date =
                     mers_transfer_creation_date_dim.value
        LEFT JOIN star_common.date_dim pending_wire_date_dim
                  ON current_loan_beneficiary.lb_pending_wire_date =
                     pending_wire_date_dim.value
        LEFT JOIN star_common.date_dim rejected_date_dim
                  ON current_loan_beneficiary.lb_rejected_date =
                     rejected_date_dim.value
        LEFT JOIN star_common.date_dim return_confirmed_date_dim
                  ON active_loan_funding.lf_return_confirmed_date =
                     return_confirmed_date_dim.value
        LEFT JOIN star_common.date_dim return_request_date_dim
                  ON active_loan_funding.lf_return_request_date =
                     return_request_date_dim.value
        LEFT JOIN star_common.date_dim scheduled_release_date_dim
                  ON active_loan_funding.lf_scheduled_release_date =
                     scheduled_release_date_dim.value
        LEFT JOIN star_common.date_dim usda_guarantee_date_dim
                  ON loan.l_usda_guarantee_date = usda_guarantee_date_dim.value
        LEFT JOIN star_common.date_dim va_guaranty_date_dim
                  ON loan.l_va_guaranty_date = va_guaranty_date_dim.value
        LEFT JOIN star_common.date_dim cd_clear_date_dim
                  ON proposal.prp_cd_clear_date = cd_clear_date_dim.value
        LEFT JOIN star_common.date_dim charges_enabled_date_dim
                  ON deal.d_charges_enabled_date =
                     charges_enabled_date_dim.value
        LEFT JOIN star_common.date_dim effective_earliest_allowed_consummation_date_dim
                  ON proposal.prp_effective_earliest_allowed_consummation_date = effective_earliest_allowed_consummation_date_dim.value
        LEFT JOIN star_common.date_dim effective_hmda_action_date_dim
                  ON deal.d_effective_hmda_action_date =
                     effective_hmda_action_date_dim.value
        LEFT JOIN star_common.date_dim effective_note_date_dim
                  ON proposal.prp_effective_note_date = effective_note_date_dim.value
        LEFT JOIN star_common.date_dim hmda_action_date_dim
                  ON deal.d_hmda_action_date = hmda_action_date_dim.value
        LEFT JOIN star_common.date_dim initial_cancel_status_date_dim
                  ON deal.d_initial_cancel_status_date =
                     initial_cancel_status_date_dim.value
        LEFT JOIN star_common.date_dim initial_uw_disposition_date_dim
                  ON date( proposal
                      .prp_initial_uw_disposition_datetime ) = initial_uw_disposition_date_dim.value
        LEFT JOIN star_common.date_dim initial_uw_submit_date_dim
                  ON date( proposal
                      .prp_initial_uw_submit_datetime ) = initial_uw_submit_date_dim.value
        LEFT JOIN star_common.date_dim note_date_dim
                  ON proposal.prp_note_date = note_date_dim.value
        LEFT JOIN star_common.date_dim preapproval_complete_date_dim
                  ON date( proposal
                      .prp_preapproval_complete_datetime ) = preapproval_complete_date_dim.value
        LEFT JOIN star_common.date_dim transaction_create_date_dim
                  ON deal.d_deal_create_date = transaction_create_date_dim.value
        LEFT JOIN star_common.date_dim transaction_welcome_call_date_dim
                  ON date( deal.d_welcome_call_datetime ) =
                     transaction_welcome_call_date_dim.value
        LEFT JOIN star_common.date_dim trid_application_date_dim
                  ON deal.d_trid_application_date =
                     trid_application_date_dim.value
        LEFT JOIN star_common.date_dim underwrite_publish_date_dim
                  ON proposal.prp_underwrite_publish_date =
                     underwrite_publish_date_dim.value
    WHERE GREATEST( deal.include_record, proposal.include_record, primary_application.include_record, loan.include_record,
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
                    hmda_action_dim.include_record, underwrite_dim.include_record ) IS TRUE
) AS loan_fact_incl_new_records
LEFT JOIN star_loan.loan_fact
          ON loan_fact_incl_new_records.data_source_integration_id =
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
              AND loan_fact_incl_new_records.b1_borrower_counseling_dwid = loan_fact.b1_borrower_counseling_dwid
              AND loan_fact_incl_new_records.b1_borrower_employee_status_dwid = loan_fact.b1_borrower_employee_status_dwid
              AND loan_fact_incl_new_records.b1_borrower_finances_declarations_dwid = loan_fact.b1_borrower_finances_declarations_dwid
              AND loan_fact_incl_new_records.b1_borrower_hmda_collection_dwid = loan_fact.b1_borrower_hmda_collection_dwid
              AND loan_fact_incl_new_records.b1_borrower_hmda_ethnicity_dwid = loan_fact.b1_borrower_hmda_ethnicity_dwid
              AND loan_fact_incl_new_records.b1_borrower_hmda_race_dwid = loan_fact.b1_borrower_hmda_race_dwid
              AND loan_fact_incl_new_records.b1_borrower_hmda_sex_dwid = loan_fact.b1_borrower_hmda_sex_dwid
              AND loan_fact_incl_new_records.b1_borrower_junk_dwid = loan_fact.b1_borrower_junk_dwid
              AND loan_fact_incl_new_records.b1_borrower_pre_umdp_declarations_dwid = loan_fact.b1_borrower_pre_umdp_declarations_dwid
              AND loan_fact_incl_new_records.b1_borrower_property_declarations_dwid = loan_fact.b1_borrower_property_declarations_dwid
              AND loan_fact_incl_new_records.b1_borrower_relations_dwid = loan_fact.b1_borrower_relations_dwid
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
              AND loan_fact_incl_new_records.effective_earliest_allowed_consummation_date_dwid =
                  loan_fact.effective_earliest_allowed_consummation_date_dwid
              AND loan_fact_incl_new_records.effective_hmda_action_date_dwid = loan_fact.effective_hmda_action_date_dwid
              AND loan_fact_incl_new_records.effective_note_date_dwid = loan_fact.effective_note_date_dwid
              AND loan_fact_incl_new_records.hmda_action_date_dwid = loan_fact.hmda_action_date_dwid
              AND loan_fact_incl_new_records.initial_cancel_status_date_dwid = loan_fact.initial_cancel_status_date_dwid
              AND loan_fact_incl_new_records.initial_uw_disposition_date_dwid = loan_fact.initial_uw_disposition_date_dwid
              AND loan_fact_incl_new_records.initial_uw_submit_date_dwid = loan_fact.initial_uw_submit_date_dwid
              AND loan_fact_incl_new_records.note_date_dwid = loan_fact.note_date_dwid
              AND loan_fact_incl_new_records.preapproval_complete_date_dwid = loan_fact.preapproval_complete_date_dwid
              AND loan_fact_incl_new_records.transaction_create_date_dwid = loan_fact.transaction_create_date_dwid
              AND loan_fact_incl_new_records.transaction_welcome_call_date_dwid = loan_fact.transaction_welcome_call_date_dwid
              AND loan_fact_incl_new_records.trid_application_date_dwid = loan_fact.trid_application_date_dwid
              AND loan_fact_incl_new_records.underwrite_publish_date_dwid = loan_fact.underwrite_publish_date_dwid
              AND loan_fact_incl_new_records.cash_out_reason_dwid = loan_fact.cash_out_reason_dwid
              AND loan_fact_incl_new_records.hmda_action_dwid = loan_fact.hmda_action_dwid
              AND loan_fact_incl_new_records.underwrite_dwid = loan_fact.underwrite_dwid
WHERE loan_fact.loan_dwid IS NULL;', 'Staging DB Connection')
)
UPDATE mdi.table_input_step
SET data_source_dwid = update_rows.data_source_dwid
  , sql = update_rows.sql
  , connectionname = update_rows.connectionname::mdi.pentaho_db_connection_name
FROM update_rows
JOIN mdi.process
     ON process.name = update_rows.process_name
WHERE process.dwid = table_input_step.process_dwid;
