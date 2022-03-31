--
-- Main | EDW | Octane schema synchronization for v2022.4.1.0 (2022-04-01)
-- https://app.asana.com/0/0/1202049009611960
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'staging_octane', 'org_node_doc', NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'org_node_doc', 'staging', 'staging_octane', 'org_node_doc')
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
    VALUES ('staging', 'history_octane', 'org_node_doc', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'org_node_doc', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'org_node_doc', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'company_settings', 'cs_fha_origination_sponsored', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_user', 'lu_esign_by_email', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_doc', 'ond_account_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_doc', 'ond_description', 'VARCHAR(256)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_doc', 'ond_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_doc', 'ond_org_node_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_doc', 'ond_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_doc', 'ond_url', 'VARCHAR(2048)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_doc', 'ond_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_construction', 'prpc_certificate_of_occupancy_date', 'DATE', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'company_settings', 'cs_fha_origination_sponsored', 'BOOLEAN', 'staging', 'staging_octane', 'company_settings', 'cs_fha_origination_sponsored')
         , ('staging', 'history_octane', 'lender_user', 'lu_esign_by_email', 'BOOLEAN', 'staging', 'staging_octane', 'lender_user', 'lu_esign_by_email')
         , ('staging', 'history_octane', 'org_node_doc', 'ond_account_pid', 'BIGINT', 'staging', 'staging_octane', 'org_node_doc', 'ond_account_pid')
         , ('staging', 'history_octane', 'org_node_doc', 'ond_description', 'VARCHAR(256)', 'staging', 'staging_octane', 'org_node_doc', 'ond_description')
         , ('staging', 'history_octane', 'org_node_doc', 'ond_name', 'VARCHAR(128)', 'staging', 'staging_octane', 'org_node_doc', 'ond_name')
         , ('staging', 'history_octane', 'org_node_doc', 'ond_org_node_pid', 'BIGINT', 'staging', 'staging_octane', 'org_node_doc', 'ond_org_node_pid')
         , ('staging', 'history_octane', 'org_node_doc', 'ond_pid', 'BIGINT', 'staging', 'staging_octane', 'org_node_doc', 'ond_pid')
         , ('staging', 'history_octane', 'org_node_doc', 'ond_url', 'VARCHAR(2048)', 'staging', 'staging_octane', 'org_node_doc', 'ond_url')
         , ('staging', 'history_octane', 'org_node_doc', 'ond_version', 'INTEGER', 'staging', 'staging_octane', 'org_node_doc', 'ond_version')
         , ('staging', 'history_octane', 'proposal_construction', 'prpc_certificate_of_occupancy_date', 'DATE', 'staging', 'staging_octane', 'proposal_construction', 'prpc_certificate_of_occupancy_date')
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
    VALUES ('staging', 'star_loan', 'lender_user_dim', 'esign_by_email_flag', 'BOOLEAN', 'staging', 'history_octane', 'lender_user', 'lu_esign_by_email')
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
VALUES ('SP-100908', 'ETL to insert records into staging.history_octane.org_node_doc using staging.staging_octane.org_node_doc as the primary source');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100908', 0, '--finding records to insert into history_octane.org_node_doc
SELECT staging_table.ond_pid
     , staging_table.ond_version
     , staging_table.ond_account_pid
     , staging_table.ond_org_node_pid
     , staging_table.ond_name
     , staging_table.ond_description
     , staging_table.ond_url
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.org_node_doc staging_table
LEFT JOIN history_octane.org_node_doc history_table
          ON staging_table.ond_pid = history_table.ond_pid
              AND staging_table.ond_version = history_table.ond_version
WHERE history_table.ond_pid IS NULL
UNION ALL
SELECT history_table.ond_pid
     , history_table.ond_version + 1
     , history_table.ond_account_pid
     , history_table.ond_org_node_pid
     , history_table.ond_name
     , history_table.ond_description
     , history_table.ond_url
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.org_node_doc history_table
LEFT JOIN staging_octane.org_node_doc staging_table
          ON staging_table.ond_pid = history_table.ond_pid
WHERE staging_table.ond_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.org_node_doc deleted_records
    WHERE deleted_records.ond_pid = history_table.ond_pid
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
    VALUES ('SP-100908', 'history_octane', 'org_node_doc', 'N', 'Staging DB Connection')
)
INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT process.dwid, insert_rows.target_schema, insert_rows.target_table, 1000, NULL, NULL, NULL, NULL, 'N', NULL, insert_rows.truncate_table::mdi.pentaho_y_or_n, insert_rows.connectionname, 'N', 'Y', 'N', 'N'
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('SP-100884', 'cs_fha_origination_sponsored')
         , ('SP-100090', 'lu_esign_by_email')
         , ('SP-100908', 'data_source_deleted_flag')
         , ('SP-100908', 'data_source_updated_datetime')
         , ('SP-100908', 'etl_batch_id')
         , ('SP-100908', 'ond_account_pid')
         , ('SP-100908', 'ond_description')
         , ('SP-100908', 'ond_name')
         , ('SP-100908', 'ond_org_node_pid')
         , ('SP-100908', 'ond_pid')
         , ('SP-100908', 'ond_url')
         , ('SP-100908', 'ond_version')
         , ('SP-100826', 'prpc_certificate_of_occupancy_date')
)
INSERT
INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
SELECT table_output_step.dwid, insert_rows.database_field_name, insert_rows.database_field_name, 0, FALSE
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name
JOIN mdi.table_output_step
     ON process.dwid = table_output_step.process_dwid;


--insert_update_field
WITH insert_rows (process_name, update_lookup, update_flag) AS (
    VALUES ('SP-200010', 'esign_by_email_flag', 'Y')
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
    VALUES ('SP-100908', 'ond_pid')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
JOIN mdi.process
     ON insert_rows.process_name = process.name;

--state_machine_definition
WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-100908', 'SP-100908', 'ETL to insert records into staging.history_octane.org_node_doc using staging.staging_octane.org_node_doc as the primary source')
)
INSERT
INTO mdi.state_machine_definition (process_dwid, name, comment)
SELECT process.dwid, insert_rows.state_machine_name, insert_rows.state_machine_comment
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--state_machine_step
WITH insert_rows (process_name, next_process_name) AS (
    VALUES ('SP-100092', 'SP-200001-delete')
         , ('SP-100090', 'SP-200001-delete')
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

--table_input_step
WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100884', 0, '--finding records to insert into history_octane.company_settings
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
     , staging_table.cs_fha_origination_sponsored
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
     , history_table.cs_fha_origination_sponsored
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
         , ('SP-100090', 0, '--finding records to insert into history_octane.lender_user
SELECT staging_table.lu_pid
     , staging_table.lu_version
     , staging_table.lu_branch_pid
     , staging_table.lu_account_owner
     , staging_table.lu_account_pid
     , staging_table.lu_create_date
     , staging_table.lu_first_name
     , staging_table.lu_last_name
     , staging_table.lu_middle_name
     , staging_table.lu_name_suffix
     , staging_table.lu_company_name
     , staging_table.lu_title
     , staging_table.lu_office_phone
     , staging_table.lu_office_phone_extension
     , staging_table.lu_email
     , staging_table.lu_fax
     , staging_table.lu_city
     , staging_table.lu_country
     , staging_table.lu_postal_code
     , staging_table.lu_state
     , staging_table.lu_street1
     , staging_table.lu_street2
     , staging_table.lu_office_phone_use_branch
     , staging_table.lu_fax_use_branch
     , staging_table.lu_address_use_branch
     , staging_table.lu_start_date
     , staging_table.lu_through_date
     , staging_table.lu_time_zone
     , staging_table.lu_unparsed_name
     , staging_table.lu_lender_user_status_type
     , staging_table.lu_username
     , staging_table.lu_nmls_loan_originator_id
     , staging_table.lu_fha_chums_id
     , staging_table.lu_va_agent_id
     , staging_table.lu_search_text
     , staging_table.lu_company_user_id
     , staging_table.lu_force_password_change
     , staging_table.lu_last_password_change_date
     , staging_table.lu_challenge_question_type
     , staging_table.lu_allow_external_ip
     , staging_table.lu_total_workload_cap
     , staging_table.lu_schedule_once_booking_page_id
     , staging_table.lu_performer_team_pid
     , staging_table.lu_esign_by_email
     , staging_table.lu_smart_app_enabled
     , staging_table.lu_default_lead_source_pid
     , staging_table.lu_default_credit_bureau_type
     , staging_table.lu_originator_id
     , staging_table.lu_name_qualifier
     , staging_table.lu_training_mode
     , staging_table.lu_about_me
     , staging_table.lu_lender_user_type
     , staging_table.lu_hire_date
     , staging_table.lu_mercury_client_group_pid
     , staging_table.lu_nickname
     , staging_table.lu_preferred_first_name
     , staging_table.lu_hub_directory
     , staging_table.lu_email_signature_title
     , staging_table.lu_termination_date
     , staging_table.lu_marketing_details_enabled
     , staging_table.lu_marketing_details_featured_review
     , staging_table.lu_suspended
     , staging_table.lu_lender_user_suspend_reason_type
     , staging_table.lu_suspend_reason_other_description
     , staging_table.lu_suspend_date_time
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.lender_user staging_table
LEFT JOIN history_octane.lender_user history_table
          ON staging_table.lu_pid = history_table.lu_pid
              AND staging_table.lu_version = history_table.lu_version
WHERE history_table.lu_pid IS NULL
UNION ALL
SELECT history_table.lu_pid
     , history_table.lu_version + 1
     , history_table.lu_branch_pid
     , history_table.lu_account_owner
     , history_table.lu_account_pid
     , history_table.lu_create_date
     , history_table.lu_first_name
     , history_table.lu_last_name
     , history_table.lu_middle_name
     , history_table.lu_name_suffix
     , history_table.lu_company_name
     , history_table.lu_title
     , history_table.lu_office_phone
     , history_table.lu_office_phone_extension
     , history_table.lu_email
     , history_table.lu_fax
     , history_table.lu_city
     , history_table.lu_country
     , history_table.lu_postal_code
     , history_table.lu_state
     , history_table.lu_street1
     , history_table.lu_street2
     , history_table.lu_office_phone_use_branch
     , history_table.lu_fax_use_branch
     , history_table.lu_address_use_branch
     , history_table.lu_start_date
     , history_table.lu_through_date
     , history_table.lu_time_zone
     , history_table.lu_unparsed_name
     , history_table.lu_lender_user_status_type
     , history_table.lu_username
     , history_table.lu_nmls_loan_originator_id
     , history_table.lu_fha_chums_id
     , history_table.lu_va_agent_id
     , history_table.lu_search_text
     , history_table.lu_company_user_id
     , history_table.lu_force_password_change
     , history_table.lu_last_password_change_date
     , history_table.lu_challenge_question_type
     , history_table.lu_allow_external_ip
     , history_table.lu_total_workload_cap
     , history_table.lu_schedule_once_booking_page_id
     , history_table.lu_performer_team_pid
     , history_table.lu_esign_by_email
     , history_table.lu_smart_app_enabled
     , history_table.lu_default_lead_source_pid
     , history_table.lu_default_credit_bureau_type
     , history_table.lu_originator_id
     , history_table.lu_name_qualifier
     , history_table.lu_training_mode
     , history_table.lu_about_me
     , history_table.lu_lender_user_type
     , history_table.lu_hire_date
     , history_table.lu_mercury_client_group_pid
     , history_table.lu_nickname
     , history_table.lu_preferred_first_name
     , history_table.lu_hub_directory
     , history_table.lu_email_signature_title
     , history_table.lu_termination_date
     , history_table.lu_marketing_details_enabled
     , history_table.lu_marketing_details_featured_review
     , history_table.lu_suspended
     , history_table.lu_lender_user_suspend_reason_type
     , history_table.lu_suspend_reason_other_description
     , history_table.lu_suspend_date_time
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.lender_user history_table
LEFT JOIN staging_octane.lender_user staging_table
          ON staging_table.lu_pid = history_table.lu_pid
WHERE staging_table.lu_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.lender_user deleted_records
    WHERE deleted_records.lu_pid = history_table.lu_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100826', 0, '--finding records to insert into history_octane.proposal_construction
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
     , staging_table.prpc_effective_construction_completion_date
     , staging_table.prpc_certificate_of_occupancy_date
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
     , history_table.prpc_effective_construction_completion_date
     , history_table.prpc_certificate_of_occupancy_date
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
         , ('SP-200010', 1, 'WITH lender_user_dim_incl_new_records AS (
    SELECT ''lender_user_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( primary_table.lu_pid AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , primary_table.data_source_updated_datetime AS data_source_modified_datetime
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
         , primary_table.lu_esign_by_email AS esign_by_email_flag
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
         , GREATEST( primary_table.etl_end_date_time, t455.etl_end_date_time, t456.etl_end_date_time,
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
    WHERE GREATEST( primary_table.include_record, t455.include_record, t456.include_record, t457.include_record,
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
         AND lender_user_dim_incl_new_records.max_source_etl_end_date_time >= lender_user_dim_etl_start_times.etl_start_date_time;', 'Staging DB Connection')
)
UPDATE mdi.table_input_step
SET data_source_dwid = update_rows.data_source_dwid
  , sql = update_rows.sql
  , connectionname = update_rows.connectionname::mdi.pentaho_db_connection_name
FROM update_rows
JOIN mdi.process
     ON process.name = update_rows.process_name
WHERE process.dwid = table_input_step.process_dwid;

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

--insert_update_field
WITH delete_keys (process_name, update_lookup) AS (
    VALUES ('SP-200010', 'esign_only_flag')
)
DELETE
FROM mdi.insert_update_field
    USING delete_keys, mdi.process, mdi.insert_update_step
WHERE delete_keys.process_name = process.name
  AND process.dwid = insert_update_step.process_dwid
  AND insert_update_step.dwid = insert_update_field.insert_update_step_dwid
  AND delete_keys.update_lookup = insert_update_field.update_lookup;


--table_output_field
WITH delete_keys (process_name, database_field_name) AS (
    VALUES ('SP-100090', 'lu_esign_only')
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
    VALUES ('staging', 'star_loan', 'lender_user_dim', 'esign_only_flag')
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
    VALUES ('staging', 'history_octane', 'lender_user', 'lu_esign_only')
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
    VALUES ('staging', 'staging_octane', 'lender_user', 'lu_esign_only')
)
DELETE
FROM mdi.edw_field_definition
    USING delete_keys, mdi.edw_table_definition
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name
  AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = delete_keys.field_name;
