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
