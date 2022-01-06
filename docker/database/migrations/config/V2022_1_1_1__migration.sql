--
-- EDW | star_loan - remove country fields from lender_user_dim
-- https://app.asana.com/0/0/1201615556752354
--

/*
UPDATES
*/

--table_input_step
WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-200010', 1, 'SELECT lender_user_dim_incl_new_records.data_source_integration_columns
     , lender_user_dim_incl_new_records.data_source_integration_id
     , lender_user_dim_incl_new_records.edw_created_datetime
     , lender_user_dim_incl_new_records.edw_modified_datetime
     , lender_user_dim_incl_new_records.data_source_modified_datetime
     , lender_user_dim_incl_new_records.default_credit_bureau
     , lender_user_dim_incl_new_records.username
     , lender_user_dim_incl_new_records.nmls_loan_originator_id
     , lender_user_dim_incl_new_records.fha_chums_id
     , lender_user_dim_incl_new_records.va_agent_id
     , lender_user_dim_incl_new_records.search_text
     , lender_user_dim_incl_new_records.company_user_id
     , lender_user_dim_incl_new_records.force_password_change_flag
     , lender_user_dim_incl_new_records.last_password_change_datetime
     , lender_user_dim_incl_new_records.allow_external_ip_flag
     , lender_user_dim_incl_new_records.total_workload_cap
     , lender_user_dim_incl_new_records.schedule_once_booking_page_id
     , lender_user_dim_incl_new_records.esign_only_flag
     , lender_user_dim_incl_new_records.work_step_start_notices_enabled_flag
     , lender_user_dim_incl_new_records.smart_app_enabled_flag
     , lender_user_dim_incl_new_records.default_credit_bureau_code
     , lender_user_dim_incl_new_records.originator_id
     , lender_user_dim_incl_new_records.name_qualifier
     , lender_user_dim_incl_new_records.training_mode_flag
     , lender_user_dim_incl_new_records.about_me
     , lender_user_dim_incl_new_records.type_code
     , lender_user_dim_incl_new_records.hire_date
     , lender_user_dim_incl_new_records.nickname
     , lender_user_dim_incl_new_records.preferred_first_name
     , lender_user_dim_incl_new_records.hub_directory_flag
     , lender_user_dim_incl_new_records.lender_user_pid
     , lender_user_dim_incl_new_records.account_owner_flag
     , lender_user_dim_incl_new_records.create_date
     , lender_user_dim_incl_new_records.first_name
     , lender_user_dim_incl_new_records.last_name
     , lender_user_dim_incl_new_records.middle_name
     , lender_user_dim_incl_new_records.name_suffix
     , lender_user_dim_incl_new_records.company_name
     , lender_user_dim_incl_new_records.title
     , lender_user_dim_incl_new_records.office_phone
     , lender_user_dim_incl_new_records.office_phone_extension
     , lender_user_dim_incl_new_records.email
     , lender_user_dim_incl_new_records.fax
     , lender_user_dim_incl_new_records.city
     , lender_user_dim_incl_new_records.postal_code
     , lender_user_dim_incl_new_records.state
     , lender_user_dim_incl_new_records.street1
     , lender_user_dim_incl_new_records.street2
     , lender_user_dim_incl_new_records.office_phone_use_branch_flag
     , lender_user_dim_incl_new_records.fax_use_branch_flag
     , lender_user_dim_incl_new_records.address_use_branch_flag
     , lender_user_dim_incl_new_records.start_date
     , lender_user_dim_incl_new_records.through_date
     , lender_user_dim_incl_new_records.time_zone_code
     , lender_user_dim_incl_new_records.unparsed_name
     , lender_user_dim_incl_new_records.status_code
     , lender_user_dim_incl_new_records.status
     , lender_user_dim_incl_new_records.type
     , lender_user_dim_incl_new_records.time_zone
FROM (
       SELECT ''lender_user_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.lu_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        t455.value as default_credit_bureau,
        primary_table.lu_username as username,
        primary_table.lu_nmls_loan_originator_id as nmls_loan_originator_id,
        primary_table.lu_fha_chums_id as fha_chums_id,
        primary_table.lu_va_agent_id as va_agent_id,
        primary_table.lu_search_text as search_text,
        primary_table.lu_company_user_id as company_user_id,
        primary_table.lu_force_password_change as force_password_change_flag,
        primary_table.lu_last_password_change_date as last_password_change_datetime,
        primary_table.lu_allow_external_ip as allow_external_ip_flag,
        primary_table.lu_total_workload_cap as total_workload_cap,
        primary_table.lu_schedule_once_booking_page_id as schedule_once_booking_page_id,
        primary_table.lu_esign_only as esign_only_flag,
        primary_table.lu_work_step_start_notices_enabled as work_step_start_notices_enabled_flag,
        primary_table.lu_smart_app_enabled as smart_app_enabled_flag,
        primary_table.lu_default_credit_bureau_type as default_credit_bureau_code,
        primary_table.lu_originator_id as originator_id,
        primary_table.lu_name_qualifier as name_qualifier,
        primary_table.lu_training_mode as training_mode_flag,
        primary_table.lu_about_me as about_me,
        primary_table.lu_lender_user_type as type_code,
        primary_table.lu_hire_date as hire_date,
        primary_table.lu_nickname as nickname,
        primary_table.lu_preferred_first_name as preferred_first_name,
        primary_table.lu_hub_directory as hub_directory_flag,
        primary_table.lu_pid as lender_user_pid,
        primary_table.lu_account_owner as account_owner_flag,
        primary_table.lu_create_date as create_date,
        primary_table.lu_first_name as first_name,
        primary_table.lu_last_name as last_name,
        primary_table.lu_middle_name as middle_name,
        primary_table.lu_name_suffix as name_suffix,
        primary_table.lu_company_name as company_name,
        primary_table.lu_title as title,
        primary_table.lu_office_phone as office_phone,
        primary_table.lu_office_phone_extension as office_phone_extension,
        primary_table.lu_email as email,
        primary_table.lu_fax as fax,
        primary_table.lu_city as city,
        primary_table.lu_postal_code as postal_code,
        primary_table.lu_state as state,
        primary_table.lu_street1 as street1,
        primary_table.lu_street2 as street2,
        primary_table.lu_office_phone_use_branch as office_phone_use_branch_flag,
        primary_table.lu_fax_use_branch as fax_use_branch_flag,
        primary_table.lu_address_use_branch as address_use_branch_flag,
        primary_table.lu_start_date as start_date,
        primary_table.lu_through_date as through_date,
        primary_table.lu_time_zone as time_zone_code,
        primary_table.lu_unparsed_name as unparsed_name,
        primary_table.lu_lender_user_status_type as status_code,
        t456.value as status,
        t457.value as type,
        t458.value as time_zone
 FROM (
    SELECT
        <<lender_user_partial_load_condition>> as include_record,
        lender_user.*
    FROM history_octane.lender_user
        LEFT JOIN history_octane.lender_user AS history_records ON lender_user.lu_pid = history_records.lu_pid
            AND lender_user.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.lu_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<credit_bureau_type_partial_load_condition>> as include_record,
            credit_bureau_type.*
            FROM history_octane.credit_bureau_type
                LEFT JOIN history_octane.credit_bureau_type AS history_records ON credit_bureau_type.code = history_records.code
                AND credit_bureau_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t455 ON primary_table.lu_default_credit_bureau_type = t455.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<lender_user_status_type_partial_load_condition>> as include_record,
            lender_user_status_type.*
            FROM history_octane.lender_user_status_type
                LEFT JOIN history_octane.lender_user_status_type AS history_records ON lender_user_status_type.code = history_records.code
                AND lender_user_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t456 ON primary_table.lu_lender_user_status_type = t456.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<lender_user_type_partial_load_condition>> as include_record,
            lender_user_type.*
            FROM history_octane.lender_user_type
                LEFT JOIN history_octane.lender_user_type AS history_records ON lender_user_type.code = history_records.code
                AND lender_user_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t457 ON primary_table.lu_lender_user_type = t457.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<time_zone_type_partial_load_condition>> as include_record,
            time_zone_type.*
            FROM history_octane.time_zone_type
                LEFT JOIN history_octane.time_zone_type AS history_records ON time_zone_type.code = history_records.code
                AND time_zone_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t458 ON primary_table.lu_time_zone = t458.code
 WHERE
    GREATEST(primary_table.include_record, t455.include_record, t456.include_record, t457.include_record, t458.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
) AS lender_user_dim_incl_new_records
    LEFT JOIN star_loan.lender_user_dim ON lender_user_dim_incl_new_records.data_source_integration_id =
                                           lender_user_dim.data_source_integration_id
        AND lender_user_dim_incl_new_records.create_date IS NOT DISTINCT FROM lender_user_dim.create_date
        AND lender_user_dim_incl_new_records.about_me IS NOT DISTINCT FROM lender_user_dim.about_me
        AND lender_user_dim_incl_new_records.city IS NOT DISTINCT FROM lender_user_dim.city
        AND lender_user_dim_incl_new_records.company_name IS NOT DISTINCT FROM lender_user_dim.company_name
        AND lender_user_dim_incl_new_records.company_user_id IS NOT DISTINCT FROM lender_user_dim.company_user_id
        AND lender_user_dim_incl_new_records.default_credit_bureau IS NOT DISTINCT FROM lender_user_dim.default_credit_bureau
        AND lender_user_dim_incl_new_records.default_credit_bureau_code IS NOT DISTINCT FROM lender_user_dim.default_credit_bureau_code
        AND lender_user_dim_incl_new_records.email IS NOT DISTINCT FROM lender_user_dim.email
        AND lender_user_dim_incl_new_records.fax IS NOT DISTINCT FROM lender_user_dim.fax
        AND lender_user_dim_incl_new_records.fha_chums_id IS NOT DISTINCT FROM lender_user_dim.fha_chums_id
        AND lender_user_dim_incl_new_records.first_name IS NOT DISTINCT FROM lender_user_dim.first_name
        AND lender_user_dim_incl_new_records.hire_date IS NOT DISTINCT FROM lender_user_dim.hire_date
        AND lender_user_dim_incl_new_records.account_owner_flag IS NOT DISTINCT FROM lender_user_dim.account_owner_flag
        AND lender_user_dim_incl_new_records.address_use_branch_flag IS NOT DISTINCT FROM lender_user_dim.address_use_branch_flag
        AND lender_user_dim_incl_new_records.allow_external_ip_flag IS NOT DISTINCT FROM lender_user_dim.allow_external_ip_flag
        AND lender_user_dim_incl_new_records.esign_only_flag IS NOT DISTINCT FROM lender_user_dim.esign_only_flag
        AND lender_user_dim_incl_new_records.fax_use_branch_flag IS NOT DISTINCT FROM lender_user_dim.fax_use_branch_flag
        AND lender_user_dim_incl_new_records.force_password_change_flag IS NOT DISTINCT FROM lender_user_dim.force_password_change_flag
        AND lender_user_dim_incl_new_records.hub_directory_flag IS NOT DISTINCT FROM lender_user_dim.hub_directory_flag
        AND lender_user_dim_incl_new_records.office_phone_use_branch_flag IS NOT DISTINCT FROM lender_user_dim.office_phone_use_branch_flag
        AND lender_user_dim_incl_new_records.smart_app_enabled_flag IS NOT DISTINCT FROM lender_user_dim.smart_app_enabled_flag
        AND lender_user_dim_incl_new_records.training_mode_flag IS NOT DISTINCT FROM lender_user_dim.training_mode_flag
        AND lender_user_dim_incl_new_records.work_step_start_notices_enabled_flag IS NOT DISTINCT FROM lender_user_dim.work_step_start_notices_enabled_flag
        AND lender_user_dim_incl_new_records.last_name IS NOT DISTINCT FROM lender_user_dim.last_name
        AND lender_user_dim_incl_new_records.last_password_change_datetime IS NOT DISTINCT FROM lender_user_dim.last_password_change_datetime
        AND lender_user_dim_incl_new_records.middle_name IS NOT DISTINCT FROM lender_user_dim.middle_name
        AND lender_user_dim_incl_new_records.name_qualifier IS NOT DISTINCT FROM lender_user_dim.name_qualifier
        AND lender_user_dim_incl_new_records.name_suffix IS NOT DISTINCT FROM lender_user_dim.name_suffix
        AND lender_user_dim_incl_new_records.nickname IS NOT DISTINCT FROM lender_user_dim.nickname
        AND lender_user_dim_incl_new_records.nmls_loan_originator_id IS NOT DISTINCT FROM lender_user_dim.nmls_loan_originator_id
        AND lender_user_dim_incl_new_records.office_phone IS NOT DISTINCT FROM lender_user_dim.office_phone
        AND lender_user_dim_incl_new_records.office_phone_extension IS NOT DISTINCT FROM lender_user_dim.office_phone_extension
        AND lender_user_dim_incl_new_records.originator_id IS NOT DISTINCT FROM lender_user_dim.originator_id
        AND lender_user_dim_incl_new_records.postal_code IS NOT DISTINCT FROM lender_user_dim.postal_code
        AND lender_user_dim_incl_new_records.preferred_first_name IS NOT DISTINCT FROM lender_user_dim.preferred_first_name
        AND lender_user_dim_incl_new_records.schedule_once_booking_page_id IS NOT DISTINCT FROM lender_user_dim.schedule_once_booking_page_id
        AND lender_user_dim_incl_new_records.search_text IS NOT DISTINCT FROM lender_user_dim.search_text
        AND lender_user_dim_incl_new_records.state IS NOT DISTINCT FROM lender_user_dim.state
        AND lender_user_dim_incl_new_records.status IS NOT DISTINCT FROM lender_user_dim.status
        AND lender_user_dim_incl_new_records.status_code IS NOT DISTINCT FROM lender_user_dim.status_code
        AND lender_user_dim_incl_new_records.street1 IS NOT DISTINCT FROM lender_user_dim.street1
        AND lender_user_dim_incl_new_records.street2 IS NOT DISTINCT FROM lender_user_dim.street2
        AND lender_user_dim_incl_new_records.time_zone IS NOT DISTINCT FROM lender_user_dim.time_zone
        AND lender_user_dim_incl_new_records.time_zone_code IS NOT DISTINCT FROM lender_user_dim.time_zone_code
        AND lender_user_dim_incl_new_records.title IS NOT DISTINCT FROM lender_user_dim.title
        AND lender_user_dim_incl_new_records.total_workload_cap IS NOT DISTINCT FROM lender_user_dim.total_workload_cap
        AND lender_user_dim_incl_new_records.type IS NOT DISTINCT FROM lender_user_dim.type
        AND lender_user_dim_incl_new_records.type_code IS NOT DISTINCT FROM lender_user_dim.type_code
        AND lender_user_dim_incl_new_records.unparsed_name IS NOT DISTINCT FROM lender_user_dim.unparsed_name
        AND lender_user_dim_incl_new_records.username IS NOT DISTINCT FROM lender_user_dim.username
        AND lender_user_dim_incl_new_records.va_agent_id IS NOT DISTINCT FROM lender_user_dim.va_agent_id
        AND lender_user_dim_incl_new_records.start_date IS NOT DISTINCT FROM lender_user_dim.start_date
        AND lender_user_dim_incl_new_records.through_date IS NOT DISTINCT FROM lender_user_dim.through_date
WHERE lender_user_dim.dwid IS NULL;', 'Staging DB Connection')
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

--state_machine_step
WITH delete_keys (process_name, next_process_name) AS (
    VALUES ('SP-100450', 'SP-200010')
)
DELETE
FROM mdi.state_machine_step
    USING delete_keys, mdi.process, mdi.process next_process
WHERE state_machine_step.process_dwid = process.dwid
  AND state_machine_step.next_process_dwid = next_process.dwid
  AND delete_keys.process_name = process.name
  AND delete_keys.next_process_name = next_process.name;

--insert_update_field
WITH delete_keys (process_name, update_lookup) AS (
    VALUES ('SP-200010', 'country_code')
         , ('SP-200010', 'country')
)
DELETE
FROM mdi.insert_update_field
    USING delete_keys, mdi.process, mdi.insert_update_step
WHERE delete_keys.process_name = process.name
  AND process.dwid = insert_update_step.process_dwid
  AND insert_update_step.dwid = insert_update_field.insert_update_step_dwid
  AND delete_keys.update_lookup = insert_update_field.update_lookup;


--edw_field_definition
WITH delete_keys (database_name, schema_name, table_name, field_name) AS (
    VALUES ('staging', 'star_loan', 'lender_user_dim', 'country')
         , ('staging', 'star_loan', 'lender_user_dim', 'country_code')
)
DELETE
FROM mdi.edw_field_definition
    USING delete_keys, mdi.edw_table_definition
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name
  AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = delete_keys.field_name;

--
-- Main | EDW - Octane schemas from prod-release to uat (2022-01-07)
-- https://app.asana.com/0/0/1201625431714639
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'staging_octane', 'fha_case_type', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'section_of_act_type', NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'fha_case_type', 'staging', 'staging_octane', 'fha_case_type')
         , ('staging', 'history_octane', 'section_of_act_type', 'staging', 'staging_octane', 'section_of_act_type')
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
    VALUES ('staging', 'history_octane', 'fha_case_type', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'fha_case_type', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'fha_case_type', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'section_of_act_type', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'section_of_act_type', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'section_of_act_type', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'fha_case_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'fha_case_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'section_of_act_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'section_of_act_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'loan', 'l_fha_case_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'loan', 'l_section_of_act_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'fha_case_type', 'code', 'VARCHAR(128)', 'staging', 'staging_octane', 'fha_case_type', 'code')
         , ('staging', 'history_octane', 'fha_case_type', 'value', 'VARCHAR(1024)', 'staging', 'staging_octane', 'fha_case_type', 'value')
         , ('staging', 'history_octane', 'section_of_act_type', 'code', 'VARCHAR(128)', 'staging', 'staging_octane', 'section_of_act_type', 'code')
         , ('staging', 'history_octane', 'section_of_act_type', 'value', 'VARCHAR(1024)', 'staging', 'staging_octane', 'section_of_act_type', 'value')
         , ('staging', 'history_octane', 'loan', 'l_fha_case_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'loan', 'l_fha_case_type')
         , ('staging', 'history_octane', 'loan', 'l_section_of_act_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'loan', 'l_section_of_act_type')
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
VALUES ('SP-100885', 'ETL to copy fha_case_type data from staging_octane to history_octane')
     , ('SP-100886', 'ETL to copy section_of_act_type data from staging_octane to history_octane');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100885', 0, '--finding records to insert into history_octane.fha_case_type
SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.fha_case_type staging_table
LEFT JOIN history_octane.fha_case_type history_table
          ON staging_table.code = history_table.code
              AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;', 'Staging DB Connection')
         , ('SP-100886', 0, '--finding records to insert into history_octane.section_of_act_type
SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.section_of_act_type staging_table
LEFT JOIN history_octane.section_of_act_type history_table
          ON staging_table.code = history_table.code
              AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;', 'Staging DB Connection')
)
INSERT
INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
SELECT process.dwid, insert_rows.data_source_dwid, insert_rows.sql, 0, 'N', 'N', 'N', 'N', insert_rows.connectionname::mdi.pentaho_db_connection_name
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--table_output_step
WITH insert_rows (process_name, target_schema, target_table, truncate_table, connectionname) AS (
    VALUES ('SP-100885', 'history_octane', 'fha_case_type', 'N', 'Staging DB Connection')
         , ('SP-100886', 'history_octane', 'section_of_act_type', 'N', 'Staging DB Connection')
)
INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT process.dwid, insert_rows.target_schema, insert_rows.target_table, 1000, NULL, NULL, NULL, NULL, 'N', NULL, insert_rows.truncate_table::mdi.pentaho_y_or_n, insert_rows.connectionname, 'N', 'Y', 'N', 'N'
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('SP-100885', 'code')
         , ('SP-100885', 'value')
         , ('SP-100885', 'data_source_updated_datetime')
         , ('SP-100885', 'data_source_deleted_flag')
         , ('SP-100885', 'etl_batch_id')
         , ('SP-100886', 'code')
         , ('SP-100886', 'value')
         , ('SP-100886', 'data_source_updated_datetime')
         , ('SP-100886', 'data_source_deleted_flag')
         , ('SP-100886', 'etl_batch_id')
         , ('SP-100320', 'l_fha_case_type')
         , ('SP-100320', 'l_section_of_act_type')
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
    VALUES ('SP-100885', 'code')
         , ('SP-100886', 'code')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
JOIN mdi.process
     ON insert_rows.process_name = process.name;

--state_machine_definition
WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-100885', 'SP-100885', 'ETL to copy fha_case_type data from staging_octane to history_octane')
         , ('SP-100886', 'SP-100886', 'ETL to copy section_of_act_type data from staging_octane to history_octane')
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
    VALUES ('staging', 'history_octane', 'new_lock_only_add_on', 'nlo_add_on_prefix', 'VARCHAR(128)', 'staging', 'staging_octane', 'new_lock_only_add_on', 'nlo_add_on_prefix')
         , ('staging', 'staging_octane', 'new_lock_only_add_on', 'nlo_add_on_prefix', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
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
    VALUES ('SP-100320', 0, '--finding records to insert into history_octane.loan
SELECT staging_table.l_pid
     , staging_table.l_version
     , staging_table.l_proposal_pid
     , staging_table.l_offering_pid
     , staging_table.l_product_terms_pid
     , staging_table.l_mortgage_type
     , staging_table.l_interest_only_type
     , staging_table.l_buydown_schedule_type
     , staging_table.l_prepay_penalty_schedule_type
     , staging_table.l_aus_type
     , staging_table.l_arm_index_datetime
     , staging_table.l_arm_index_current_value_percent
     , staging_table.l_arm_margin_percent
     , staging_table.l_base_loan_amount
     , staging_table.l_buydown_contributor_type
     , staging_table.l_target_cash_out_amount
     , staging_table.l_heloc_maximum_balance_amount
     , staging_table.l_note_rate_percent
     , staging_table.l_initial_note_rate_percent
     , staging_table.l_lien_priority_type
     , staging_table.l_loan_amount
     , staging_table.l_financed_amount
     , staging_table.l_ltv_ratio_percent
     , staging_table.l_mi_requirement_ltv_ratio_percent
     , staging_table.l_mi_auto_compute
     , staging_table.l_mi_no_mi_product
     , staging_table.l_mi_input_type
     , staging_table.l_mi_company_name_type
     , staging_table.l_mi_certificate_id
     , staging_table.l_mi_premium_refundable_type
     , staging_table.l_mi_initial_calculation_type
     , staging_table.l_mi_renewal_calculation_type
     , staging_table.l_mi_payer_type
     , staging_table.l_mi_coverage_percent
     , staging_table.l_mi_ltv_cutoff_percent
     , staging_table.l_mi_midpoint_cutoff_required
     , staging_table.l_mi_required_monthly_payment_count
     , staging_table.l_mi_actual_monthly_payment_count
     , staging_table.l_mi_payment_type
     , staging_table.l_mi_upfront_amount
     , staging_table.l_mi_upfront_percent
     , staging_table.l_mi_initial_monthly_payment_amount
     , staging_table.l_mi_renewal_monthly_payment_annual_percent
     , staging_table.l_mi_renewal_monthly_payment_amount
     , staging_table.l_mi_initial_duration_months
     , staging_table.l_mi_initial_monthly_payment_annual_percent
     , staging_table.l_mi_initial_calculated_rate_type
     , staging_table.l_mi_renewal_calculated_rate_type
     , staging_table.l_mi_base_rate_label
     , staging_table.l_mi_base_monthly_payment_annual_percent
     , staging_table.l_mi_base_upfront_percent
     , staging_table.l_mi_base_monthly_payment_amount
     , staging_table.l_mi_base_upfront_payment_amount
     , staging_table.l_qualifying_rate_type
     , staging_table.l_qualifying_rate_input_percent
     , staging_table.l_qualifying_rate_percent
     , staging_table.l_fha_program_code_type
     , staging_table.l_fha_principal_write_down
     , staging_table.l_fhac_case_assignment_messages
     , staging_table.l_initial_pi_amount
     , staging_table.l_qualifying_pi_amount
     , staging_table.l_base_note_rate_percent
     , staging_table.l_base_arm_margin_percent
     , staging_table.l_base_price_percent
     , staging_table.l_lock_price_percent
     , staging_table.l_lock_duration_days
     , staging_table.l_lock_commitment_type
     , staging_table.l_product_choice_datetime
     , staging_table.l_hmda_purchaser_of_loan_2017_type
     , staging_table.l_hmda_purchaser_of_loan_2018_type
     , staging_table.l_texas_equity
     , staging_table.l_texas_equity_auto
     , staging_table.l_fnm_mbs_investor_contract_id
     , staging_table.l_base_guaranty_fee_basis_points
     , staging_table.l_guaranty_fee_basis_points
     , staging_table.l_guaranty_fee_after_alternate_payment_method_basis_points
     , staging_table.l_fnm_investor_product_plan_id
     , staging_table.l_uldd_loan_comment
     , staging_table.l_principal_curtailment_amount
     , staging_table.l_mi_lender_paid_rate_adjustment_percent
     , staging_table.l_apr
     , staging_table.l_finance_charge_amount
     , staging_table.l_apor_percent
     , staging_table.l_apor_date
     , staging_table.l_hmda_rate_spread_percent
     , staging_table.l_hoepa_apr
     , staging_table.l_hoepa_rate_spread
     , staging_table.l_hoepa_fees_dollar_amount
     , staging_table.l_hmda_hoepa_status_type
     , staging_table.l_rate_sheet_undiscounted_rate_percent
     , staging_table.l_effective_undiscounted_rate_percent
     , staging_table.l_last_unprocessed_changes_datetime
     , staging_table.l_locked_price_change_percent
     , staging_table.l_interest_rate_fee_change_amount
     , staging_table.l_lender_concession_candidate
     , staging_table.l_durp_eligibility_opt_out
     , staging_table.l_qualified_mortgage_status_type
     , staging_table.l_qualified_mortgage
     , staging_table.l_lqa_purchase_eligibility_type
     , staging_table.l_student_loan_cash_out_refinance
     , staging_table.l_mi_rate_quote_id
     , staging_table.l_mi_integration_vendor_request_pid
     , staging_table.l_secondary_clear_to_commit
     , staging_table.l_qm_eligible
     , staging_table.l_fha_endorsement_date
     , staging_table.l_va_guaranty_date
     , staging_table.l_usda_guarantee_date
     , staging_table.l_hpml
     , staging_table.l_qualified_mortgage_rule_version_type
     , staging_table.l_qualified_mortgage_apr
     , staging_table.l_qualified_mortgage_max_allowed_rate_spread
     , staging_table.l_buyup_buydown_basis_points
     , staging_table.l_va_agency_case_id
     , staging_table.l_fha_agency_case_id
     , staging_table.l_usda_agency_case_id
     , staging_table.l_va_agency_case_id_assigned_date
     , staging_table.l_fha_agency_case_id_assigned_date
     , staging_table.l_usda_agency_case_id_assigned_date
     , staging_table.l_post_interest_only_first_payment_date
     , staging_table.l_fha_case_type
     , staging_table.l_section_of_act_type
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.loan staging_table
LEFT JOIN history_octane.loan history_table
          ON staging_table.l_pid = history_table.l_pid
              AND staging_table.l_version = history_table.l_version
WHERE history_table.l_pid IS NULL
UNION ALL
SELECT history_table.l_pid
     , history_table.l_version + 1
     , history_table.l_proposal_pid
     , history_table.l_offering_pid
     , history_table.l_product_terms_pid
     , history_table.l_mortgage_type
     , history_table.l_interest_only_type
     , history_table.l_buydown_schedule_type
     , history_table.l_prepay_penalty_schedule_type
     , history_table.l_aus_type
     , history_table.l_arm_index_datetime
     , history_table.l_arm_index_current_value_percent
     , history_table.l_arm_margin_percent
     , history_table.l_base_loan_amount
     , history_table.l_buydown_contributor_type
     , history_table.l_target_cash_out_amount
     , history_table.l_heloc_maximum_balance_amount
     , history_table.l_note_rate_percent
     , history_table.l_initial_note_rate_percent
     , history_table.l_lien_priority_type
     , history_table.l_loan_amount
     , history_table.l_financed_amount
     , history_table.l_ltv_ratio_percent
     , history_table.l_mi_requirement_ltv_ratio_percent
     , history_table.l_mi_auto_compute
     , history_table.l_mi_no_mi_product
     , history_table.l_mi_input_type
     , history_table.l_mi_company_name_type
     , history_table.l_mi_certificate_id
     , history_table.l_mi_premium_refundable_type
     , history_table.l_mi_initial_calculation_type
     , history_table.l_mi_renewal_calculation_type
     , history_table.l_mi_payer_type
     , history_table.l_mi_coverage_percent
     , history_table.l_mi_ltv_cutoff_percent
     , history_table.l_mi_midpoint_cutoff_required
     , history_table.l_mi_required_monthly_payment_count
     , history_table.l_mi_actual_monthly_payment_count
     , history_table.l_mi_payment_type
     , history_table.l_mi_upfront_amount
     , history_table.l_mi_upfront_percent
     , history_table.l_mi_initial_monthly_payment_amount
     , history_table.l_mi_renewal_monthly_payment_annual_percent
     , history_table.l_mi_renewal_monthly_payment_amount
     , history_table.l_mi_initial_duration_months
     , history_table.l_mi_initial_monthly_payment_annual_percent
     , history_table.l_mi_initial_calculated_rate_type
     , history_table.l_mi_renewal_calculated_rate_type
     , history_table.l_mi_base_rate_label
     , history_table.l_mi_base_monthly_payment_annual_percent
     , history_table.l_mi_base_upfront_percent
     , history_table.l_mi_base_monthly_payment_amount
     , history_table.l_mi_base_upfront_payment_amount
     , history_table.l_qualifying_rate_type
     , history_table.l_qualifying_rate_input_percent
     , history_table.l_qualifying_rate_percent
     , history_table.l_fha_program_code_type
     , history_table.l_fha_principal_write_down
     , history_table.l_fhac_case_assignment_messages
     , history_table.l_initial_pi_amount
     , history_table.l_qualifying_pi_amount
     , history_table.l_base_note_rate_percent
     , history_table.l_base_arm_margin_percent
     , history_table.l_base_price_percent
     , history_table.l_lock_price_percent
     , history_table.l_lock_duration_days
     , history_table.l_lock_commitment_type
     , history_table.l_product_choice_datetime
     , history_table.l_hmda_purchaser_of_loan_2017_type
     , history_table.l_hmda_purchaser_of_loan_2018_type
     , history_table.l_texas_equity
     , history_table.l_texas_equity_auto
     , history_table.l_fnm_mbs_investor_contract_id
     , history_table.l_base_guaranty_fee_basis_points
     , history_table.l_guaranty_fee_basis_points
     , history_table.l_guaranty_fee_after_alternate_payment_method_basis_points
     , history_table.l_fnm_investor_product_plan_id
     , history_table.l_uldd_loan_comment
     , history_table.l_principal_curtailment_amount
     , history_table.l_mi_lender_paid_rate_adjustment_percent
     , history_table.l_apr
     , history_table.l_finance_charge_amount
     , history_table.l_apor_percent
     , history_table.l_apor_date
     , history_table.l_hmda_rate_spread_percent
     , history_table.l_hoepa_apr
     , history_table.l_hoepa_rate_spread
     , history_table.l_hoepa_fees_dollar_amount
     , history_table.l_hmda_hoepa_status_type
     , history_table.l_rate_sheet_undiscounted_rate_percent
     , history_table.l_effective_undiscounted_rate_percent
     , history_table.l_last_unprocessed_changes_datetime
     , history_table.l_locked_price_change_percent
     , history_table.l_interest_rate_fee_change_amount
     , history_table.l_lender_concession_candidate
     , history_table.l_durp_eligibility_opt_out
     , history_table.l_qualified_mortgage_status_type
     , history_table.l_qualified_mortgage
     , history_table.l_lqa_purchase_eligibility_type
     , history_table.l_student_loan_cash_out_refinance
     , history_table.l_mi_rate_quote_id
     , history_table.l_mi_integration_vendor_request_pid
     , history_table.l_secondary_clear_to_commit
     , history_table.l_qm_eligible
     , history_table.l_fha_endorsement_date
     , history_table.l_va_guaranty_date
     , history_table.l_usda_guarantee_date
     , history_table.l_hpml
     , history_table.l_qualified_mortgage_rule_version_type
     , history_table.l_qualified_mortgage_apr
     , history_table.l_qualified_mortgage_max_allowed_rate_spread
     , history_table.l_buyup_buydown_basis_points
     , history_table.l_va_agency_case_id
     , history_table.l_fha_agency_case_id
     , history_table.l_usda_agency_case_id
     , history_table.l_va_agency_case_id_assigned_date
     , history_table.l_fha_agency_case_id_assigned_date
     , history_table.l_usda_agency_case_id_assigned_date
     , history_table.l_post_interest_only_first_payment_date
     , history_table.l_fha_case_type
     , history_table.l_section_of_act_type
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.loan history_table
LEFT JOIN staging_octane.loan staging_table
          ON staging_table.l_pid = history_table.l_pid
WHERE staging_table.l_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.loan deleted_records
    WHERE deleted_records.l_pid = history_table.l_pid
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
