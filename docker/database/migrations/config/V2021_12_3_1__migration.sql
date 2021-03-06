--
-- MAIN | EDW - Octane schemas from prod-release to v2021.12.3.0 on uat  -  https://app.asana.com/0/0/1201508123725637
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'staging_octane', 'branch_license_contact', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', NULL, NULL, NULL)
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT insert_rows.database_name, insert_rows.schema_name, insert_rows.table_name, source_table_definition.dwid
FROM insert_rows
    LEFT JOIN mdi.edw_table_definition source_table_definition
        ON insert_rows.source_database_name = source_table_definition.database_name
            AND insert_rows.source_schema_name = source_table_definition.schema_name
            AND insert_rows.source_table_name = source_table_definition.table_name;

WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'history_octane', 'branch_license_contact', 'staging', 'staging_octane', 'branch_license_contact')
         , ('staging', 'history_octane', 'company_settings', 'staging', 'staging_octane', 'company_settings')
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT insert_rows.database_name, insert_rows.schema_name, insert_rows.table_name, source_table_definition.dwid
FROM insert_rows
    LEFT JOIN mdi.edw_table_definition source_table_definition
        ON insert_rows.source_database_name = source_table_definition.database_name
            AND insert_rows.source_schema_name = source_table_definition.schema_name
            AND insert_rows.source_table_name = source_table_definition.table_name;

--edw_join_definition
WITH insert_rows (primary_database_name, primary_schema_name, primary_table_name, target_database_name, target_schema_name, target_table_name, join_condition) AS (
    VALUES ('staging', 'history_octane', 'branch_license_contact', 'staging', 'history_octane', 'lender_user', 'primary_table.brlc_lender_user_pid = target_table.lu_pid')
         , ('staging', 'history_octane', 'branch_license_contact', 'staging', 'history_octane', 'branch_license', 'primary_table.brlc_branch_license_pid = target_table.brml_pid')
         , ('staging', 'history_octane', 'company_settings', 'staging', 'history_octane', 'company', 'primary_table.cs_company_pid = target_table.cm_pid')
         , ('staging', 'history_octane', 'company_settings', 'staging', 'history_octane', 'location', 'primary_table.cs_fha_home_office_location_pid = target_table.loc_pid')
         , ('staging', 'history_octane', 'company_settings', 'staging', 'history_octane', 'yes_no_unknown_type', 'primary_table.cs_fha_settings_present = target_table.code')
         , ('staging', 'history_octane', 'company_settings', 'staging', 'history_octane', 'country_type', 'primary_table.cs_fha_sponsor_address_country = target_table.code')
         , ('staging', 'history_octane', 'company_settings', 'staging', 'history_octane', 'yes_no_unknown_type', 'primary_table.cs_usda_settings_present = target_table.code')
         , ('staging', 'history_octane', 'company_settings', 'staging', 'history_octane', 'yes_no_unknown_type', 'primary_table.cs_va_settings_present = target_table.code')
)
INSERT
INTO mdi.edw_join_definition (dwid, primary_edw_table_definition_dwid, target_edw_table_definition_dwid, join_type, join_condition)
SELECT NEXTVAL( 'mdi.edw_join_definition_dwid_seq' )
    , primary_table.dwid
    , target_table.dwid
    , 'left'
    , REPLACE( insert_rows.join_condition, 'target_table', 't' || CURRVAL( 'mdi.edw_join_definition_dwid_seq' ) )
FROM insert_rows
    JOIN mdi.edw_table_definition primary_table
        ON insert_rows.primary_database_name = primary_table.database_name
            AND insert_rows.primary_schema_name = primary_table.schema_name
            AND insert_rows.primary_table_name = primary_table.table_name
    JOIN mdi.edw_table_definition target_table
        ON insert_rows.target_database_name = target_table.database_name
            AND insert_rows.target_schema_name = target_table.schema_name
            AND insert_rows.target_table_name = target_table.table_name;

--edw_field_definition
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'history_octane', 'branch_license_contact', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'branch_license_contact', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'branch_license_contact', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'company_settings', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'company_settings', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'company_settings', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'branch_license_contact', 'brlc_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'branch_license_contact', 'brlc_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'branch_license_contact', 'brlc_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'branch_license_contact', 'brlc_branch_license_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'branch_license_contact', 'brlc_from_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'branch_license_contact', 'brlc_through_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_company_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_equifax_mortgage_services_internal_account_id', 'VARCHAR(256)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_factual_data_internal_account_id', 'VARCHAR(256)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_sharper_lending_internal_account_id', 'VARCHAR(256)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_va_lender_id', 'VARCHAR(16)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_usda_lender_id', 'VARCHAR(16)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_fha_sponsor_address_country', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_fha_sponsor_id', 'VARCHAR(16)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_fha_sponsor_company_name', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_fha_non_supervised_mortgagee', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_fha_sponsor_address_city', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_fha_lender_id', 'VARCHAR(16)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_fha_sponsor_address_street2', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_fha_sponsor_address_street1', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_fha_sponsor_address_state', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_fha_home_office_location_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_fha_sponsor_address_postal_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_fha_settings_present', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_va_settings_present', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_usda_settings_present', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_construction', 'prpc_extension_period_days', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'wf_step', 'ws_user_step_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'ledger_entry_import_loan_status', 'leils_row_number', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_settings', 'lss_equifax_submitting_party_name', 'VARCHAR(256)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_settings', 'lss_factual_data_submitting_party_name', 'VARCHAR(256)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_settings', 'lss_factual_data_submitting_party_id', 'VARCHAR(256)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_settings', 'lss_meridian_link_submitting_party_id', 'VARCHAR(256)', NULL, NULL, NULL, NULL)
)
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
SELECT edw_table_definition.dwid, insert_rows.field_name, FALSE, source_field_definition.dwid, NULL, NULL, insert_rows.data_type, NULL, NULL, NULL, NULL
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
    VALUES ('staging', 'history_octane', 'branch_license_contact', 'brlc_pid', 'BIGINT', 'staging', 'staging_octane', 'branch_license_contact', 'brlc_pid')
         , ('staging', 'history_octane', 'branch_license_contact', 'brlc_version', 'INTEGER', 'staging', 'staging_octane', 'branch_license_contact', 'brlc_version')
         , ('staging', 'history_octane', 'branch_license_contact', 'brlc_lender_user_pid', 'BIGINT', 'staging', 'staging_octane', 'branch_license_contact', 'brlc_lender_user_pid')
         , ('staging', 'history_octane', 'branch_license_contact', 'brlc_branch_license_pid', 'BIGINT', 'staging', 'staging_octane', 'branch_license_contact', 'brlc_branch_license_pid')
         , ('staging', 'history_octane', 'branch_license_contact', 'brlc_from_date', 'DATE', 'staging', 'staging_octane', 'branch_license_contact', 'brlc_from_date')
         , ('staging', 'history_octane', 'branch_license_contact', 'brlc_through_date', 'DATE', 'staging', 'staging_octane', 'branch_license_contact', 'brlc_through_date')
         , ('staging', 'history_octane', 'company_settings', 'cs_pid', 'BIGINT', 'staging', 'staging_octane', 'company_settings', 'cs_pid')
         , ('staging', 'history_octane', 'company_settings', 'cs_version', 'INTEGER', 'staging', 'staging_octane', 'company_settings', 'cs_version')
         , ('staging', 'history_octane', 'company_settings', 'cs_company_pid', 'BIGINT', 'staging', 'staging_octane', 'company_settings', 'cs_company_pid')
         , ('staging', 'history_octane', 'company_settings', 'cs_equifax_mortgage_services_internal_account_id', 'VARCHAR(256)', 'staging', 'staging_octane', 'company_settings', 'cs_equifax_mortgage_services_internal_account_id')
         , ('staging', 'history_octane', 'company_settings', 'cs_factual_data_internal_account_id', 'VARCHAR(256)', 'staging', 'staging_octane', 'company_settings', 'cs_factual_data_internal_account_id')
         , ('staging', 'history_octane', 'company_settings', 'cs_sharper_lending_internal_account_id', 'VARCHAR(256)', 'staging', 'staging_octane', 'company_settings', 'cs_sharper_lending_internal_account_id')
         , ('staging', 'history_octane', 'company_settings', 'cs_va_lender_id', 'VARCHAR(16)', 'staging', 'staging_octane', 'company_settings', 'cs_va_lender_id')
         , ('staging', 'history_octane', 'company_settings', 'cs_usda_lender_id', 'VARCHAR(16)', 'staging', 'staging_octane', 'company_settings', 'cs_usda_lender_id')
         , ('staging', 'history_octane', 'company_settings', 'cs_fha_sponsor_address_country', 'VARCHAR(128)', 'staging', 'staging_octane', 'company_settings', 'cs_fha_sponsor_address_country')
         , ('staging', 'history_octane', 'company_settings', 'cs_fha_sponsor_id', 'VARCHAR(16)', 'staging', 'staging_octane', 'company_settings', 'cs_fha_sponsor_id')
         , ('staging', 'history_octane', 'company_settings', 'cs_fha_sponsor_company_name', 'VARCHAR(32)', 'staging', 'staging_octane', 'company_settings', 'cs_fha_sponsor_company_name')
         , ('staging', 'history_octane', 'company_settings', 'cs_fha_non_supervised_mortgagee', 'BOOLEAN', 'staging', 'staging_octane', 'company_settings', 'cs_fha_non_supervised_mortgagee')
         , ('staging', 'history_octane', 'company_settings', 'cs_fha_sponsor_address_city', 'VARCHAR(128)', 'staging', 'staging_octane', 'company_settings', 'cs_fha_sponsor_address_city')
         , ('staging', 'history_octane', 'company_settings', 'cs_fha_lender_id', 'VARCHAR(16)', 'staging', 'staging_octane', 'company_settings', 'cs_fha_lender_id')
         , ('staging', 'history_octane', 'company_settings', 'cs_fha_sponsor_address_street2', 'VARCHAR(128)', 'staging', 'staging_octane', 'company_settings', 'cs_fha_sponsor_address_street2')
         , ('staging', 'history_octane', 'company_settings', 'cs_fha_sponsor_address_street1', 'VARCHAR(128)', 'staging', 'staging_octane', 'company_settings', 'cs_fha_sponsor_address_street1')
         , ('staging', 'history_octane', 'company_settings', 'cs_fha_sponsor_address_state', 'VARCHAR(128)', 'staging', 'staging_octane', 'company_settings', 'cs_fha_sponsor_address_state')
         , ('staging', 'history_octane', 'company_settings', 'cs_fha_home_office_location_pid', 'BIGINT', 'staging', 'staging_octane', 'company_settings', 'cs_fha_home_office_location_pid')
         , ('staging', 'history_octane', 'company_settings', 'cs_fha_sponsor_address_postal_code', 'VARCHAR(128)', 'staging', 'staging_octane', 'company_settings', 'cs_fha_sponsor_address_postal_code')
         , ('staging', 'history_octane', 'company_settings', 'cs_fha_settings_present', 'VARCHAR(128)', 'staging', 'staging_octane', 'company_settings', 'cs_fha_settings_present')
         , ('staging', 'history_octane', 'company_settings', 'cs_va_settings_present', 'VARCHAR(128)', 'staging', 'staging_octane', 'company_settings', 'cs_va_settings_present')
         , ('staging', 'history_octane', 'company_settings', 'cs_usda_settings_present', 'VARCHAR(128)', 'staging', 'staging_octane', 'company_settings', 'cs_usda_settings_present')
         , ('staging', 'history_octane', 'proposal_construction', 'prpc_extension_period_days', 'INTEGER', 'staging', 'staging_octane', 'proposal_construction', 'prpc_extension_period_days')
         , ('staging', 'history_octane', 'wf_step', 'ws_user_step_name', 'VARCHAR(128)', 'staging', 'staging_octane', 'wf_step', 'ws_user_step_name')
         , ('staging', 'history_octane', 'ledger_entry_import_loan_status', 'leils_row_number', 'INTEGER', 'staging', 'staging_octane', 'ledger_entry_import_loan_status', 'leils_row_number')
         , ('staging', 'history_octane', 'lender_settings', 'lss_equifax_submitting_party_name', 'VARCHAR(256)', 'staging', 'staging_octane', 'lender_settings', 'lss_equifax_submitting_party_name')
         , ('staging', 'history_octane', 'lender_settings', 'lss_factual_data_submitting_party_name', 'VARCHAR(256)', 'staging', 'staging_octane', 'lender_settings', 'lss_factual_data_submitting_party_name')
         , ('staging', 'history_octane', 'lender_settings', 'lss_factual_data_submitting_party_id', 'VARCHAR(256)', 'staging', 'staging_octane', 'lender_settings', 'lss_factual_data_submitting_party_id')
         , ('staging', 'history_octane', 'lender_settings', 'lss_meridian_link_submitting_party_id', 'VARCHAR(256)', 'staging', 'staging_octane', 'lender_settings', 'lss_meridian_link_submitting_party_id')
)
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
SELECT edw_table_definition.dwid, insert_rows.field_name, FALSE, source_field_definition.dwid, NULL, NULL, insert_rows.data_type, NULL, NULL, NULL, NULL
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
VALUES ('SP-100883', 'ETL to copy branch_license_contact data from staging_octane to history_octane')
     , ('SP-100884', 'ETL to copy company_settings data from staging_octane to history_octane');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100883', 0, '--finding records to insert into history_octane.branch_license_contact
SELECT staging_table.brlc_pid
     , staging_table.brlc_version
     , staging_table.brlc_lender_user_pid
     , staging_table.brlc_branch_license_pid
     , staging_table.brlc_from_date
     , staging_table.brlc_through_date
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.branch_license_contact staging_table
LEFT JOIN history_octane.branch_license_contact history_table
          ON staging_table.brlc_pid = history_table.brlc_pid
              AND staging_table.brlc_version = history_table.brlc_version
WHERE history_table.brlc_pid IS NULL
UNION ALL
SELECT history_table.brlc_pid
     , history_table.brlc_version + 1
     , history_table.brlc_lender_user_pid
     , history_table.brlc_branch_license_pid
     , history_table.brlc_from_date
     , history_table.brlc_through_date
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.branch_license_contact history_table
LEFT JOIN staging_octane.branch_license_contact staging_table
          ON staging_table.brlc_pid = history_table.brlc_pid
WHERE staging_table.brlc_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.branch_license_contact deleted_records
    WHERE deleted_records.brlc_pid = history_table.brlc_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100884', 0, '--finding records to insert into history_octane.company_settings
SELECT staging_table.cs_pid
     , staging_table.cs_version
     , staging_table.cs_company_pid
     , staging_table.cs_equifax_mortgage_services_internal_account_id
     , staging_table.cs_factual_data_internal_account_id
     , staging_table.cs_sharper_lending_internal_account_id
     , staging_table.cs_va_lender_id
     , staging_table.cs_usda_lender_id
     , staging_table.cs_fha_sponsor_address_country
     , staging_table.cs_fha_sponsor_id
     , staging_table.cs_fha_sponsor_company_name
     , staging_table.cs_fha_non_supervised_mortgagee
     , staging_table.cs_fha_sponsor_address_city
     , staging_table.cs_fha_lender_id
     , staging_table.cs_fha_sponsor_address_street2
     , staging_table.cs_fha_sponsor_address_street1
     , staging_table.cs_fha_sponsor_address_state
     , staging_table.cs_fha_home_office_location_pid
     , staging_table.cs_fha_sponsor_address_postal_code
     , staging_table.cs_fha_settings_present
     , staging_table.cs_va_settings_present
     , staging_table.cs_usda_settings_present
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.company_settings staging_table
LEFT JOIN history_octane.company_settings history_table
          ON staging_table.cs_pid = history_table.cs_pid
              AND staging_table.cs_version = history_table.cs_version
WHERE history_table.cs_pid IS NULL
UNION ALL
SELECT history_table.cs_pid
     , history_table.cs_version + 1
     , history_table.cs_company_pid
     , history_table.cs_equifax_mortgage_services_internal_account_id
     , history_table.cs_factual_data_internal_account_id
     , history_table.cs_sharper_lending_internal_account_id
     , history_table.cs_va_lender_id
     , history_table.cs_usda_lender_id
     , history_table.cs_fha_sponsor_address_country
     , history_table.cs_fha_sponsor_id
     , history_table.cs_fha_sponsor_company_name
     , history_table.cs_fha_non_supervised_mortgagee
     , history_table.cs_fha_sponsor_address_city
     , history_table.cs_fha_lender_id
     , history_table.cs_fha_sponsor_address_street2
     , history_table.cs_fha_sponsor_address_street1
     , history_table.cs_fha_sponsor_address_state
     , history_table.cs_fha_home_office_location_pid
     , history_table.cs_fha_sponsor_address_postal_code
     , history_table.cs_fha_settings_present
     , history_table.cs_va_settings_present
     , history_table.cs_usda_settings_present
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.company_settings history_table
LEFT JOIN staging_octane.company_settings staging_table
          ON staging_table.cs_pid = history_table.cs_pid
WHERE staging_table.cs_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.company_settings deleted_records
    WHERE deleted_records.cs_pid = history_table.cs_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
)
INSERT
INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
SELECT process.dwid, insert_rows.data_source_dwid, insert_rows.sql, 0, 'N', 'N', 'N', 'N', insert_rows.connectionname::mdi.pentaho_db_connection_name
FROM insert_rows
    JOIN mdi.process
        ON process.name = insert_rows.process_name;

--table_output_step
WITH insert_rows (process_name, target_schema, target_table, truncate_table, connectionname) AS (
    VALUES ('SP-100883', 'history_octane', 'branch_license_contact', 'N', 'Staging DB Connection')
         , ('SP-100884', 'history_octane', 'company_settings', 'N', 'Staging DB Connection')
)
INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT process.dwid, insert_rows.target_schema, insert_rows.target_table, 1000, NULL, NULL, NULL, NULL, 'N', NULL, insert_rows.truncate_table::mdi.pentaho_y_or_n, insert_rows.connectionname, 'N', 'Y', 'N', 'N'
FROM insert_rows
    JOIN mdi.process
        ON process.name = insert_rows.process_name;

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('SP-100883', 'brlc_pid')
         , ('SP-100883', 'brlc_version')
         , ('SP-100883', 'brlc_lender_user_pid')
         , ('SP-100883', 'brlc_branch_license_pid')
         , ('SP-100883', 'brlc_from_date')
         , ('SP-100883', 'brlc_through_date')
         , ('SP-100883', 'data_source_updated_datetime')
         , ('SP-100883', 'data_source_deleted_flag')
         , ('SP-100883', 'etl_batch_id')
         , ('SP-100884', 'cs_pid')
         , ('SP-100884', 'cs_version')
         , ('SP-100884', 'cs_company_pid')
         , ('SP-100884', 'cs_equifax_mortgage_services_internal_account_id')
         , ('SP-100884', 'cs_factual_data_internal_account_id')
         , ('SP-100884', 'cs_sharper_lending_internal_account_id')
         , ('SP-100884', 'cs_va_lender_id')
         , ('SP-100884', 'cs_usda_lender_id')
         , ('SP-100884', 'cs_fha_sponsor_address_country')
         , ('SP-100884', 'cs_fha_sponsor_id')
         , ('SP-100884', 'cs_fha_sponsor_company_name')
         , ('SP-100884', 'cs_fha_non_supervised_mortgagee')
         , ('SP-100884', 'cs_fha_sponsor_address_city')
         , ('SP-100884', 'cs_fha_lender_id')
         , ('SP-100884', 'cs_fha_sponsor_address_street2')
         , ('SP-100884', 'cs_fha_sponsor_address_street1')
         , ('SP-100884', 'cs_fha_sponsor_address_state')
         , ('SP-100884', 'cs_fha_home_office_location_pid')
         , ('SP-100884', 'cs_fha_sponsor_address_postal_code')
         , ('SP-100884', 'cs_fha_settings_present')
         , ('SP-100884', 'cs_va_settings_present')
         , ('SP-100884', 'cs_usda_settings_present')
         , ('SP-100884', 'data_source_updated_datetime')
         , ('SP-100884', 'data_source_deleted_flag')
         , ('SP-100884', 'etl_batch_id')
         , ('SP-100826', 'prpc_extension_period_days')
         , ('SP-100191', 'ws_user_step_name')
         , ('SP-100216', 'leils_row_number')
         , ('SP-100095', 'lss_equifax_submitting_party_name')
         , ('SP-100095', 'lss_factual_data_submitting_party_name')
         , ('SP-100095', 'lss_factual_data_submitting_party_id')
         , ('SP-100095', 'lss_meridian_link_submitting_party_id')
)
INSERT
INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
SELECT table_output_step.dwid, insert_rows.database_field_name, insert_rows.database_field_name, 0, FALSE
FROM insert_rows
    JOIN mdi.process
        ON process.name = insert_rows.process_name
    JOIN mdi.table_output_step
        ON process.dwid = table_output_step.process_dwid;


--json_output_field
WITH insert_rows (process_name, json_output_field) AS (
    VALUES ('SP-100883', 'brlc_pid')
         , ('SP-100884', 'cs_pid')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
    JOIN mdi.process
        ON insert_rows.process_name = process.name;

--state_machine_definition
WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-100883', 'SP-100883', 'ETL to copy branch_license_contact data from staging_octane to history_octane')
         , ('SP-100884', 'SP-100884', 'ETL to copy company_settings data from staging_octane to history_octane')
)
INSERT
INTO mdi.state_machine_definition (process_dwid, name, comment)
SELECT process.dwid, insert_rows.state_machine_name, insert_rows.state_machine_comment
FROM insert_rows
    JOIN mdi.process
        ON process.name = insert_rows.process_name;

/*
UPDATES
*/

--edw_field_definition
WITH update_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'history_octane', 'lender_settings', 'lss_va_lender_id', 'VARCHAR(16)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_settings', 'lss_usda_lender_id', 'VARCHAR(16)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_settings', 'lss_fha_lender_id', 'VARCHAR(16)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_settings', 'lss_fha_sponsor_id', 'VARCHAR(16)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_settings', 'lss_fha_sponsor_company_name', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_settings', 'lss_fha_sponsor_address_street1', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_settings', 'lss_fha_sponsor_address_street2', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_settings', 'lss_fha_sponsor_address_city', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_settings', 'lss_fha_sponsor_address_state', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_settings', 'lss_fha_sponsor_address_postal_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_settings', 'lss_fha_sponsor_address_country', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_settings', 'lss_fha_non_supervised_mortgagee', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_settings', 'lss_fha_home_office_location_pid', 'BIGINT', NULL, NULL, NULL, NULL)
)
UPDATE mdi.edw_field_definition
SET data_type = update_rows.data_type
    , source_edw_field_definition_dwid = source_field_definition.dwid
FROM update_rows
    JOIN mdi.edw_table_definition
        ON update_rows.database_name = edw_table_definition.database_name
            AND update_rows.schema_name = edw_table_definition.schema_name
            AND update_rows.table_name = edw_table_definition.table_name
    LEFT JOIN mdi.edw_table_definition source_table_definition
        ON update_rows.source_database_name = source_table_definition.database_name
            AND update_rows.source_schema_name = source_table_definition.schema_name
            AND update_rows.source_table_name = source_table_definition.table_name
    LEFT JOIN mdi.edw_field_definition source_field_definition
        ON source_table_definition.dwid = source_field_definition.edw_table_definition_dwid
            AND update_rows.source_field_name = source_field_definition.field_name
WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
    AND edw_field_definition.field_name = update_rows.field_name;

--table_input_step
WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100826', 0, '--finding records to insert into history_octane.proposal_construction
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
     , staging_table.prpc_estimated_permit_amount_applicable
     , staging_table.prpc_contingency_reserve_required
     , staging_table.prpc_extension_period_days
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal_construction staging_table
LEFT JOIN history_octane.proposal_construction history_table
          ON staging_table.prpc_pid = history_table.prpc_pid
              AND staging_table.prpc_version = history_table.prpc_version
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
     , history_table.prpc_estimated_permit_amount_applicable
     , history_table.prpc_contingency_reserve_required
     , history_table.prpc_extension_period_days
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal_construction history_table
LEFT JOIN staging_octane.proposal_construction staging_table
          ON staging_table.prpc_pid = history_table.prpc_pid
WHERE staging_table.prpc_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.proposal_construction deleted_records
    WHERE deleted_records.prpc_pid = history_table.prpc_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100191', 0, '--finding records to insert into history_octane.wf_step
SELECT staging_table.ws_pid
     , staging_table.ws_version
     , staging_table.ws_wf_process_pid
     , staging_table.ws_step_name
     , staging_table.ws_step_number
     , staging_table.ws_step_number_formatted
     , staging_table.ws_step_number_name_formatted
     , staging_table.ws_step_start_borrower_text
     , staging_table.ws_expected_complete_minutes
     , staging_table.ws_wf_step_timeout_type
     , staging_table.ws_second_of_day_timeout
     , staging_table.ws_timeout_time_zone_type
     , staging_table.ws_description
     , staging_table.ws_wf_step_type
     , staging_table.ws_wf_phase_pid
     , staging_table.ws_wf_step_performer_assign_type
     , staging_table.ws_role_pid
     , staging_table.ws_from_role_pid
     , staging_table.ws_wf_step_reassign_type
     , staging_table.ws_wf_step_function_type
     , staging_table.ws_sap_expire_minutes
     , staging_table.ws_sap_expire_warning_minutes
     , staging_table.ws_prompt_user_defined_time
     , staging_table.ws_smart_message_pid
     , staging_table.ws_smart_doc_set_pid
     , staging_table.ws_lien_priority_type
     , staging_table.ws_active_only
     , staging_table.ws_internal
     , staging_table.ws_deal_stage_type
     , staging_table.ws_polling_interval_type
     , staging_table.ws_swappable
     , staging_table.ws_wf_prereq_set_pid
     , staging_table.ws_user_step_name
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.wf_step staging_table
LEFT JOIN history_octane.wf_step history_table
          ON staging_table.ws_pid = history_table.ws_pid
              AND staging_table.ws_version = history_table.ws_version
WHERE history_table.ws_pid IS NULL
UNION ALL
SELECT history_table.ws_pid
     , history_table.ws_version + 1
     , history_table.ws_wf_process_pid
     , history_table.ws_step_name
     , history_table.ws_step_number
     , history_table.ws_step_number_formatted
     , history_table.ws_step_number_name_formatted
     , history_table.ws_step_start_borrower_text
     , history_table.ws_expected_complete_minutes
     , history_table.ws_wf_step_timeout_type
     , history_table.ws_second_of_day_timeout
     , history_table.ws_timeout_time_zone_type
     , history_table.ws_description
     , history_table.ws_wf_step_type
     , history_table.ws_wf_phase_pid
     , history_table.ws_wf_step_performer_assign_type
     , history_table.ws_role_pid
     , history_table.ws_from_role_pid
     , history_table.ws_wf_step_reassign_type
     , history_table.ws_wf_step_function_type
     , history_table.ws_sap_expire_minutes
     , history_table.ws_sap_expire_warning_minutes
     , history_table.ws_prompt_user_defined_time
     , history_table.ws_smart_message_pid
     , history_table.ws_smart_doc_set_pid
     , history_table.ws_lien_priority_type
     , history_table.ws_active_only
     , history_table.ws_internal
     , history_table.ws_deal_stage_type
     , history_table.ws_polling_interval_type
     , history_table.ws_swappable
     , history_table.ws_wf_prereq_set_pid
     , history_table.ws_user_step_name
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.wf_step history_table
LEFT JOIN staging_octane.wf_step staging_table
          ON staging_table.ws_pid = history_table.ws_pid
WHERE staging_table.ws_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.wf_step deleted_records
    WHERE deleted_records.ws_pid = history_table.ws_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100216', 0, '--finding records to insert into history_octane.ledger_entry_import_loan_status
SELECT staging_table.leils_pid
     , staging_table.leils_version
     , staging_table.leils_ledger_entry_import_status_pid
     , staging_table.leils_ledger_entry_pid
     , staging_table.leils_los_loan_id
     , staging_table.leils_payee_unparsed_name
     , staging_table.leils_entry_amount
     , staging_table.leils_entry_description
     , staging_table.leils_start_datetime
     , staging_table.leils_complete_datetime
     , staging_table.leils_ledger_entry_import_status_type
     , staging_table.leils_failure_info
     , staging_table.leils_raw_row
     , staging_table.leils_row_number
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.ledger_entry_import_loan_status staging_table
LEFT JOIN history_octane.ledger_entry_import_loan_status history_table
          ON staging_table.leils_pid = history_table.leils_pid
              AND staging_table.leils_version = history_table.leils_version
WHERE history_table.leils_pid IS NULL
UNION ALL
SELECT history_table.leils_pid
     , history_table.leils_version + 1
     , history_table.leils_ledger_entry_import_status_pid
     , history_table.leils_ledger_entry_pid
     , history_table.leils_los_loan_id
     , history_table.leils_payee_unparsed_name
     , history_table.leils_entry_amount
     , history_table.leils_entry_description
     , history_table.leils_start_datetime
     , history_table.leils_complete_datetime
     , history_table.leils_ledger_entry_import_status_type
     , history_table.leils_failure_info
     , history_table.leils_raw_row
     , history_table.leils_row_number
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.ledger_entry_import_loan_status history_table
LEFT JOIN staging_octane.ledger_entry_import_loan_status staging_table
          ON staging_table.leils_pid = history_table.leils_pid
WHERE staging_table.leils_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.ledger_entry_import_loan_status deleted_records
    WHERE deleted_records.leils_pid = history_table.leils_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100095', 0, '--finding records to insert into history_octane.lender_settings
SELECT staging_table.lss_pid
     , staging_table.lss_version
     , staging_table.lss_account_pid
     , staging_table.lss_company_time_zone_type
     , staging_table.lss_fha_home_office_branch_pid
     , staging_table.lss_fnma_seller_id
     , staging_table.lss_fre_seller_id
     , staging_table.lss_lp_submission_type
     , staging_table.lss_lender_user_email_from
     , staging_table.lss_hmda_contact_pid
     , staging_table.lss_hmda_legal_entity_id
     , staging_table.lss_hmda_respondent_id
     , staging_table.lss_hmda_agency_id_type
     , staging_table.lss_prequalification_program
     , staging_table.lss_preapproval_program
     , staging_table.lss_pest_inspector_company_name
     , staging_table.lss_pest_inspector_phone
     , staging_table.lss_pest_inspector_website_url
     , staging_table.lss_pest_inspector_address_street1
     , staging_table.lss_pest_inspector_address_street2
     , staging_table.lss_pest_inspector_address_city
     , staging_table.lss_pest_inspector_address_state
     , staging_table.lss_pest_inspector_address_postal_code
     , staging_table.lss_take_application_hours
     , staging_table.lss_originator_title
     , staging_table.lss_default_credit_bureau_type
     , staging_table.lss_sap_minimum_decision_credit_score
     , staging_table.lss_default_standalone_lock_term_setting_pid
     , staging_table.lss_default_combo_lock_term_setting_pid
     , staging_table.lss_preferred_aus_type
     , staging_table.lss_borrower_quote_filter_pivot_type
     , staging_table.lss_borrower_quote_filter_pivot_lower_count
     , staging_table.lss_borrower_quote_filter_pivot_higher_count
     , staging_table.lss_equifax_submitting_party_name
     , staging_table.lss_factual_data_submitting_party_name
     , staging_table.lss_factual_data_submitting_party_id
     , staging_table.lss_meridian_link_submitting_party_id
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.lender_settings staging_table
LEFT JOIN history_octane.lender_settings history_table
          ON staging_table.lss_pid = history_table.lss_pid
              AND staging_table.lss_version = history_table.lss_version
WHERE history_table.lss_pid IS NULL
UNION ALL
SELECT history_table.lss_pid
     , history_table.lss_version + 1
     , history_table.lss_account_pid
     , history_table.lss_company_time_zone_type
     , history_table.lss_fha_home_office_branch_pid
     , history_table.lss_fnma_seller_id
     , history_table.lss_fre_seller_id
     , history_table.lss_lp_submission_type
     , history_table.lss_lender_user_email_from
     , history_table.lss_hmda_contact_pid
     , history_table.lss_hmda_legal_entity_id
     , history_table.lss_hmda_respondent_id
     , history_table.lss_hmda_agency_id_type
     , history_table.lss_prequalification_program
     , history_table.lss_preapproval_program
     , history_table.lss_pest_inspector_company_name
     , history_table.lss_pest_inspector_phone
     , history_table.lss_pest_inspector_website_url
     , history_table.lss_pest_inspector_address_street1
     , history_table.lss_pest_inspector_address_street2
     , history_table.lss_pest_inspector_address_city
     , history_table.lss_pest_inspector_address_state
     , history_table.lss_pest_inspector_address_postal_code
     , history_table.lss_take_application_hours
     , history_table.lss_originator_title
     , history_table.lss_default_credit_bureau_type
     , history_table.lss_sap_minimum_decision_credit_score
     , history_table.lss_default_standalone_lock_term_setting_pid
     , history_table.lss_default_combo_lock_term_setting_pid
     , history_table.lss_preferred_aus_type
     , history_table.lss_borrower_quote_filter_pivot_type
     , history_table.lss_borrower_quote_filter_pivot_lower_count
     , history_table.lss_borrower_quote_filter_pivot_higher_count
     , history_table.lss_equifax_submitting_party_name
     , history_table.lss_factual_data_submitting_party_name
     , history_table.lss_factual_data_submitting_party_id
     , history_table.lss_meridian_link_submitting_party_id
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.lender_settings history_table
LEFT JOIN staging_octane.lender_settings staging_table
          ON staging_table.lss_pid = history_table.lss_pid
WHERE staging_table.lss_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.lender_settings deleted_records
    WHERE deleted_records.lss_pid = history_table.lss_pid
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

/*
DELETIONS
*/

--table_output_field
WITH delete_keys (process_name, database_field_name) AS (
    VALUES ('SP-100095', 'lss_va_lender_id')
         , ('SP-100095', 'lss_usda_lender_id')
         , ('SP-100095', 'lss_fha_lender_id')
         , ('SP-100095', 'lss_fha_sponsor_id')
         , ('SP-100095', 'lss_fha_sponsor_company_name')
         , ('SP-100095', 'lss_fha_sponsor_address_street1')
         , ('SP-100095', 'lss_fha_sponsor_address_street2')
         , ('SP-100095', 'lss_fha_sponsor_address_city')
         , ('SP-100095', 'lss_fha_sponsor_address_state')
         , ('SP-100095', 'lss_fha_sponsor_address_postal_code')
         , ('SP-100095', 'lss_fha_sponsor_address_country')
         , ('SP-100095', 'lss_fha_non_supervised_mortgagee')
         , ('SP-100095', 'lss_fha_home_office_location_pid')
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
    VALUES ('staging', 'staging_octane', 'lender_settings', 'lss_fha_home_office_location_pid')
         , ('staging', 'staging_octane', 'lender_settings', 'lss_fha_sponsor_id')
         , ('staging', 'staging_octane', 'lender_settings', 'lss_fha_sponsor_company_name')
         , ('staging', 'staging_octane', 'lender_settings', 'lss_fha_sponsor_address_street1')
         , ('staging', 'staging_octane', 'lender_settings', 'lss_fha_sponsor_address_street2')
         , ('staging', 'staging_octane', 'lender_settings', 'lss_fha_sponsor_address_state')
         , ('staging', 'staging_octane', 'lender_settings', 'lss_fha_sponsor_address_country')
         , ('staging', 'staging_octane', 'lender_settings', 'lss_fha_non_supervised_mortgagee')
         , ('staging', 'staging_octane', 'lender_settings', 'lss_fha_lender_id')
         , ('staging', 'staging_octane', 'lender_settings', 'lss_fha_sponsor_address_city')
         , ('staging', 'staging_octane', 'lender_settings', 'lss_fha_sponsor_address_postal_code')
         , ('staging', 'staging_octane', 'lender_settings', 'lss_va_lender_id')
         , ('staging', 'staging_octane', 'lender_settings', 'lss_usda_lender_id')
)
DELETE
FROM mdi.edw_field_definition
    USING delete_keys, mdi.edw_table_definition
WHERE edw_table_definition.database_name = delete_keys.database_name
    AND edw_table_definition.schema_name = delete_keys.schema_name
    AND edw_table_definition.table_name = delete_keys.table_name
    AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
    AND edw_field_definition.field_name = delete_keys.field_name;

--edw_join_definition
WITH delete_keys (primary_database_name, primary_schema_name, primary_table_name, target_database_name, target_schema_name, target_table_name, join_condition) AS (
    VALUES ('staging', 'history_octane', 'lender_settings', 'staging', 'history_octane', 'country_type', 'primary_table.lss_fha_sponsor_address_country = target_table.code')
         , ('staging', 'history_octane', 'lender_settings', 'staging', 'history_octane', 'location', 'primary_table.lss_fha_home_office_location_pid = target_table.loc_pid')
)
DELETE
FROM mdi.edw_join_definition
    USING delete_keys, mdi.edw_table_definition primary_table, mdi.edw_table_definition target_table
WHERE delete_keys.primary_database_name = primary_table.database_name
    AND delete_keys.primary_schema_name = primary_table.schema_name
    AND delete_keys.primary_table_name = primary_table.table_name
    AND delete_keys.target_database_name = target_table.database_name
    AND delete_keys.target_schema_name = target_table.schema_name
    AND delete_keys.target_table_name = target_table.table_name
    AND primary_table.dwid = edw_join_definition.primary_edw_table_definition_dwid
    AND target_table.dwid = edw_join_definition.target_edw_table_definition_dwid
    AND delete_keys.join_condition = REGEXP_REPLACE( edw_join_definition.join_condition, 't[0-9]+\.', 'target_table.' );