--
-- Main | EDW - Octane schemas from prod-release to v2021.9.4.1 on uat
-- https://app.asana.com/0/0/1201028468419837
--

/*
Insert metadata for new tables:
    - location_status_type
    - location
    - location_lease
    - company_location_type
    - company_location
    - lender_user_location_type
    - workspace_type
    - lender_user_location
    - location_id_ticker
    - location_note
    - location_note_comment
    - location_note_monitor
*/

WITH new_staging_table_definitions AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'location_status_type', NULL)
            , ('staging', 'staging_octane', 'location', NULL)
            , ('staging', 'staging_octane', 'location_lease', NULL)
            , ('staging', 'staging_octane', 'company_location_type', NULL)
            , ('staging', 'staging_octane', 'company_location', NULL)
            , ('staging', 'staging_octane', 'lender_user_location_type', NULL)
            , ('staging', 'staging_octane', 'workspace_type', NULL)
            , ('staging', 'staging_octane', 'lender_user_location', NULL)
            , ('staging', 'staging_octane', 'location_id_ticker', NULL)
            , ('staging', 'staging_octane', 'location_note', NULL)
            , ('staging', 'staging_octane', 'location_note_comment', NULL)
            , ('staging', 'staging_octane', 'location_note_monitor', NULL)
        RETURNING dwid, table_name
)

, new_history_table_definitions AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        SELECT 'staging'
            , 'history_octane'
            , new_staging_table_definitions.table_name
            , new_staging_table_definitions.dwid
        FROM new_staging_table_definitions
        RETURNING dwid, table_name
)

, new_fields (schema_name, table_name, field_name, key_field_flag, field_order) AS (
    VALUES
        -- staging_octane.location_status_type
        ('staging_octane', 'location_status_type', 'code', TRUE, NULL)
        , ('staging_octane', 'location_status_type', 'value', FALSE, NULL)
        -- history_octane.location_status_type
        , ('history_octane', 'location_status_type', 'code', TRUE, 1)
        , ('history_octane', 'location_status_type', 'value', FALSE, 2)
        , ('history_octane', 'location_status_type', 'data_source_updated_datetime', FALSE, 3)
        , ('history_octane', 'location_status_type', 'data_source_deleted_flag', FALSE, 4)
        -- staging_octane.location
        , ('staging_octane', 'location', 'loc_pid', TRUE, NULL)
        , ('staging_octane', 'location', 'loc_version', FALSE, NULL)
        , ('staging_octane', 'location', 'loc_account_pid', FALSE, NULL)
        , ('staging_octane', 'location', 'loc_address_street1', FALSE, NULL)
        , ('staging_octane', 'location', 'loc_address_street2', FALSE, NULL)
        , ('staging_octane', 'location', 'loc_address_city', FALSE, NULL)
        , ('staging_octane', 'location', 'loc_address_state', FALSE, NULL)
        , ('staging_octane', 'location', 'loc_address_postal_code', FALSE, NULL)
        , ('staging_octane', 'location', 'loc_location_name', FALSE, NULL)
        , ('staging_octane', 'location', 'loc_location_id', FALSE, NULL)
        , ('staging_octane', 'location', 'loc_location_remote', FALSE, NULL)
        , ('staging_octane', 'location', 'loc_location_status_type', FALSE, NULL)
        , ('staging_octane', 'location', 'loc_fha_field_office_code', FALSE, NULL)
        , ('staging_octane', 'location', 'loc_documents_url', FALSE, NULL)
        -- history_octane.location
        , ('history_octane', 'location', 'loc_pid', TRUE, 1)
        , ('history_octane', 'location', 'loc_version', FALSE, 2)
        , ('history_octane', 'location', 'loc_account_pid', FALSE, 3)
        , ('history_octane', 'location', 'loc_address_street1', FALSE, 4)
        , ('history_octane', 'location', 'loc_address_street2', FALSE, 5)
        , ('history_octane', 'location', 'loc_address_city', FALSE, 6)
        , ('history_octane', 'location', 'loc_address_state', FALSE, 7)
        , ('history_octane', 'location', 'loc_address_postal_code', FALSE, 8)
        , ('history_octane', 'location', 'loc_location_name', FALSE, 9)
        , ('history_octane', 'location', 'loc_location_id', FALSE, 10)
        , ('history_octane', 'location', 'loc_location_remote', FALSE, 11)
        , ('history_octane', 'location', 'loc_location_status_type', FALSE, 12)
        , ('history_octane', 'location', 'loc_fha_field_office_code', FALSE, 13)
        , ('history_octane', 'location', 'loc_documents_url', FALSE, 14)
        , ('history_octane', 'location', 'data_source_updated_datetime', FALSE, 15)
        , ('history_octane', 'location', 'data_source_deleted_flag', FALSE, 16)
        -- staging_octane.location_lease
        , ('staging_octane', 'location_lease', 'locl_pid', TRUE, NULL)
        , ('staging_octane', 'location_lease', 'locl_version', FALSE, NULL)
        , ('staging_octane', 'location_lease', 'locl_location_pid', FALSE, NULL)
        , ('staging_octane', 'location_lease', 'locl_from_date', FALSE, NULL)
        , ('staging_octane', 'location_lease', 'locl_through_date', FALSE, NULL)
        , ('staging_octane', 'location_lease', 'locl_monthly_lease_amount', FALSE, NULL)
        , ('staging_octane', 'location_lease', 'locl_cubicle_count', FALSE, NULL)
        , ('staging_octane', 'location_lease', 'locl_office_count', FALSE, NULL)
        -- history_octane.location_lease
        , ('history_octane', 'location_lease', 'locl_pid', TRUE, 1)
        , ('history_octane', 'location_lease', 'locl_version', FALSE, 2)
        , ('history_octane', 'location_lease', 'locl_location_pid', FALSE, 3)
        , ('history_octane', 'location_lease', 'locl_from_date', FALSE, 4)
        , ('history_octane', 'location_lease', 'locl_through_date', FALSE, 5)
        , ('history_octane', 'location_lease', 'locl_monthly_lease_amount', FALSE, 6)
        , ('history_octane', 'location_lease', 'locl_cubicle_count', FALSE, 7)
        , ('history_octane', 'location_lease', 'locl_office_count', FALSE, 8)
        , ('history_octane', 'location_lease', 'data_source_updated_datetime', FALSE, 9)
        , ('history_octane', 'location_lease', 'data_source_deleted_flag', FALSE, 10)
        -- staging_octane.company_location_type
        , ('staging_octane', 'company_location_type', 'code', TRUE, NULL)
        , ('staging_octane', 'company_location_type', 'value', FALSE, NULL)
        -- history_octane.company_location_type
        , ('history_octane', 'company_location_type', 'code', TRUE, 1)
        , ('history_octane', 'company_location_type', 'value', FALSE, 2)
        , ('history_octane', 'company_location_type', 'data_source_updated_datetime', FALSE, 3)
        , ('history_octane', 'company_location_type', 'data_source_deleted_flag', FALSE, 4)
        -- staging_octane.company_location
        , ('staging_octane', 'company_location', 'cmloc_pid', TRUE, NULL)
        , ('staging_octane', 'company_location', 'cmloc_version', FALSE, NULL)
        , ('staging_octane', 'company_location', 'cmloc_company_pid', FALSE, NULL)
        , ('staging_octane', 'company_location', 'cmloc_location_pid', FALSE, NULL)
        , ('staging_octane', 'company_location', 'cmloc_from_date', FALSE, NULL)
        , ('staging_octane', 'company_location', 'cmloc_through_date', FALSE, NULL)
        , ('staging_octane', 'company_location', 'cmloc_company_location_type', FALSE, NULL)
        , ('staging_octane', 'company_location', 'cmloc_nmls_id', FALSE, NULL)
        , ('staging_octane', 'company_location', 'cmloc_fha_branch_id', FALSE, NULL)
        , ('staging_octane', 'company_location', 'cmloc_fha_branch_id_qualified', FALSE, NULL)
        , ('staging_octane', 'company_location', 'cmloc_office_phone', FALSE, NULL)
        , ('staging_octane', 'company_location', 'cmloc_office_phone_extension', FALSE, NULL)
        , ('staging_octane', 'company_location', 'cmloc_fax', FALSE, NULL)
        -- history_octane.company_location
        , ('history_octane', 'company_location', 'cmloc_pid', TRUE, 1)
        , ('history_octane', 'company_location', 'cmloc_version', FALSE, 2)
        , ('history_octane', 'company_location', 'cmloc_company_pid', FALSE, 3)
        , ('history_octane', 'company_location', 'cmloc_location_pid', FALSE, 4)
        , ('history_octane', 'company_location', 'cmloc_from_date', FALSE, 5)
        , ('history_octane', 'company_location', 'cmloc_through_date', FALSE, 6)
        , ('history_octane', 'company_location', 'cmloc_company_location_type', FALSE, 7)
        , ('history_octane', 'company_location', 'cmloc_nmls_id', FALSE, 8)
        , ('history_octane', 'company_location', 'cmloc_fha_branch_id', FALSE, 9)
        , ('history_octane', 'company_location', 'cmloc_fha_branch_id_qualified', FALSE, 10)
        , ('history_octane', 'company_location', 'cmloc_office_phone', FALSE, 11)
        , ('history_octane', 'company_location', 'cmloc_office_phone_extension', FALSE, 12)
        , ('history_octane', 'company_location', 'cmloc_fax', FALSE, 13)
        , ('history_octane', 'company_location', 'data_source_updated_datetime', FALSE, 14)
        , ('history_octane', 'company_location', 'data_source_deleted_flag', FALSE, 15)
        -- staging_octane.lender_user_location_type
        , ('staging_octane', 'lender_user_location_type', 'code', TRUE, NULL)
        , ('staging_octane', 'lender_user_location_type', 'value', FALSE, NULL)
        -- history_octane.lender_user_location_type
        , ('history_octane', 'lender_user_location_type', 'code', TRUE, 1)
        , ('history_octane', 'lender_user_location_type', 'value', FALSE, 2)
        , ('history_octane', 'lender_user_location_type', 'data_source_updated_datetime', FALSE, 3)
        , ('history_octane', 'lender_user_location_type', 'data_source_deleted_flag', FALSE, 4)
        -- staging_octane.workspace_type
        , ('staging_octane', 'workspace_type', 'code', TRUE, NULL)
        , ('staging_octane', 'workspace_type', 'value', FALSE, NULL)
        -- history_octane.workspace_type
        , ('history_octane', 'workspace_type', 'code', TRUE, 1)
        , ('history_octane', 'workspace_type', 'value', FALSE, 2)
        , ('history_octane', 'workspace_type', 'data_source_updated_datetime', FALSE, 3)
        , ('history_octane', 'workspace_type', 'data_source_deleted_flag', FALSE, 4)
        -- staging_octane.lender_user_location
        , ('staging_octane', 'lender_user_location', 'luloc_pid', TRUE, NULL)
        , ('staging_octane', 'lender_user_location', 'luloc_version', FALSE, NULL)
        , ('staging_octane', 'lender_user_location', 'luloc_company_pid', FALSE, NULL)
        , ('staging_octane', 'lender_user_location', 'luloc_lender_user_pid', FALSE, NULL)
        , ('staging_octane', 'lender_user_location', 'luloc_location_pid', FALSE, NULL)
        , ('staging_octane', 'lender_user_location', 'luloc_from_date', FALSE, NULL)
        , ('staging_octane', 'lender_user_location', 'luloc_lender_user_location_type', FALSE, NULL)
        , ('staging_octane', 'lender_user_location', 'luloc_workspace_type', FALSE, NULL)
        , ('staging_octane', 'lender_user_location', 'luloc_workspace_code', FALSE, NULL)
        -- history_octane.lender_user_location
        , ('history_octane', 'lender_user_location', 'luloc_pid', TRUE, 1)
        , ('history_octane', 'lender_user_location', 'luloc_version', FALSE, 2)
        , ('history_octane', 'lender_user_location', 'luloc_company_pid', FALSE, 3)
        , ('history_octane', 'lender_user_location', 'luloc_lender_user_pid', FALSE, 4)
        , ('history_octane', 'lender_user_location', 'luloc_location_pid', FALSE, 5)
        , ('history_octane', 'lender_user_location', 'luloc_from_date', FALSE, 6)
        , ('history_octane', 'lender_user_location', 'luloc_lender_user_location_type', FALSE, 7)
        , ('history_octane', 'lender_user_location', 'luloc_workspace_type', FALSE, 8)
        , ('history_octane', 'lender_user_location', 'luloc_workspace_code', FALSE, 9)
        , ('history_octane', 'lender_user_location', 'data_source_updated_datetime', FALSE, 10)
        , ('history_octane', 'lender_user_location', 'data_source_deleted_flag', FALSE, 11)
        -- staging_octane.location_id_ticker
        , ('staging_octane', 'location_id_ticker', 'loctk_pid', TRUE, NULL)
        , ('staging_octane', 'location_id_ticker', 'loctk_version', FALSE, NULL)
        , ('staging_octane', 'location_id_ticker', 'loctk_account_pid', FALSE, NULL)
        , ('staging_octane', 'location_id_ticker', 'loctk_next_location_id', FALSE, NULL)
        -- history_octane.location_id_ticker
        , ('history_octane', 'location_id_ticker', 'loctk_pid', TRUE, 1)
        , ('history_octane', 'location_id_ticker', 'loctk_version', FALSE, 2)
        , ('history_octane', 'location_id_ticker', 'loctk_account_pid', FALSE, 3)
        , ('history_octane', 'location_id_ticker', 'loctk_next_location_id', FALSE, 4)
        , ('history_octane', 'location_id_ticker', 'data_source_updated_datetime', FALSE, 5)
        , ('history_octane', 'location_id_ticker', 'data_source_deleted_flag', FALSE, 6)
        -- staging_octane.location_note
        , ('staging_octane', 'location_note', 'locn_pid', TRUE, NULL)
        , ('staging_octane', 'location_note', 'locn_version', FALSE, NULL)
        , ('staging_octane', 'location_note', 'locn_location_pid', FALSE, NULL)
        , ('staging_octane', 'location_note', 'locn_create_datetime', FALSE, NULL)
        , ('staging_octane', 'location_note', 'locn_content', FALSE, NULL)
        , ('staging_octane', 'location_note', 'locn_author_lender_user_pid', FALSE, NULL)
        , ('staging_octane', 'location_note', 'locn_author_unparsed_name', FALSE, NULL)
        -- history_octane.location_note
        , ('history_octane', 'location_note', 'locn_pid', TRUE, 1)
        , ('history_octane', 'location_note', 'locn_version', FALSE, 2)
        , ('history_octane', 'location_note', 'locn_location_pid', FALSE, 3)
        , ('history_octane', 'location_note', 'locn_create_datetime', FALSE, 4)
        , ('history_octane', 'location_note', 'locn_content', FALSE, 5)
        , ('history_octane', 'location_note', 'locn_author_lender_user_pid', FALSE, 6)
        , ('history_octane', 'location_note', 'locn_author_unparsed_name', FALSE, 7)
        , ('history_octane', 'location_note', 'data_source_updated_datetime', FALSE, 8)
        , ('history_octane', 'location_note', 'data_source_deleted_flag', FALSE, 9)
        -- staging_octane.location_note_comment
        , ('staging_octane', 'location_note_comment', 'locnc_pid', TRUE, NULL)
        , ('staging_octane', 'location_note_comment', 'locnc_version', FALSE, NULL)
        , ('staging_octane', 'location_note_comment', 'locnc_location_note_pid', FALSE, NULL)
        , ('staging_octane', 'location_note_comment', 'locnc_create_datetime', FALSE, NULL)
        , ('staging_octane', 'location_note_comment', 'locnc_content', FALSE, NULL)
        , ('staging_octane', 'location_note_comment', 'locnc_author_lender_user_pid', FALSE, NULL)
        , ('staging_octane', 'location_note_comment', 'locnc_author_unparsed_name', FALSE, NULL)
        -- history_octane.location_note_comment
        , ('history_octane', 'location_note_comment', 'locnc_pid', TRUE, 1)
        , ('history_octane', 'location_note_comment', 'locnc_version', FALSE, 2)
        , ('history_octane', 'location_note_comment', 'locnc_location_note_pid', FALSE, 3)
        , ('history_octane', 'location_note_comment', 'locnc_create_datetime', FALSE, 4)
        , ('history_octane', 'location_note_comment', 'locnc_content', FALSE, 5)
        , ('history_octane', 'location_note_comment', 'locnc_author_lender_user_pid', FALSE, 6)
        , ('history_octane', 'location_note_comment', 'locnc_author_unparsed_name', FALSE, 7)
        , ('history_octane', 'location_note_comment', 'data_source_updated_datetime', FALSE, 8)
        , ('history_octane', 'location_note_comment', 'data_source_deleted_flag', FALSE, 9)
        -- staging_octane.location_note_monitor
        , ('staging_octane', 'location_note_monitor', 'locnm_pid', TRUE, NULL)
        , ('staging_octane', 'location_note_monitor', 'locnm_version', FALSE, NULL)
        , ('staging_octane', 'location_note_monitor', 'locnm_location_note_pid', FALSE, NULL)
        , ('staging_octane', 'location_note_monitor', 'locnm_lender_user_pid', FALSE, NULL)
        -- history_octane.location_note_monitor
        , ('history_octane', 'location_note_monitor', 'locnm_pid', TRUE, 1)
        , ('history_octane', 'location_note_monitor', 'locnm_version', FALSE, 2)
        , ('history_octane', 'location_note_monitor', 'locnm_location_note_pid', FALSE, 3)
        , ('history_octane', 'location_note_monitor', 'locnm_lender_user_pid', FALSE, 4)
        , ('history_octane', 'location_note_monitor', 'data_source_updated_datetime', FALSE, 5)
        , ('history_octane', 'location_note_monitor', 'data_source_deleted_flag', FALSE, 6)
)

, new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT new_staging_table_definitions.dwid
            , new_fields.field_name
            , new_fields.key_field_flag
        FROM new_fields
            JOIN new_staging_table_definitions ON new_fields.table_name = new_staging_table_definitions.table_name
        WHERE new_fields.schema_name = 'staging_octane'
        RETURNING dwid, edw_table_definition_dwid, field_name
)

, new_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag,
                                          source_edw_field_definition_dwid)
        SELECT new_history_table_definitions.dwid
            , new_fields.field_name
            , new_fields.key_field_flag
            , new_staging_field_definitions.dwid
        FROM new_fields
            JOIN new_staging_table_definitions ON new_fields.table_name = new_staging_table_definitions.table_name
            JOIN new_history_table_definitions ON new_fields.table_name = new_history_table_definitions.table_name
            LEFT JOIN new_staging_field_definitions ON new_staging_table_definitions.dwid =
                                                       new_staging_field_definitions.edw_table_definition_dwid
                AND new_fields.field_name = new_staging_field_definitions.field_name
        WHERE new_fields.schema_name = 'history_octane'
)

, new_process_variables (name, target_table, json_output_field, sql) AS (
    VALUES ('SP-100848', 'location_status_type', 'code', 'SELECT staging_table.code
, staging_table.value
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.location_status_type staging_table
LEFT JOIN history_octane.location_status_type history_table on staging_table.code = history_table.code AND staging_table.value = history_table.value
WHERE history_table.code is NULL')
        , ('SP-100849', 'location', 'loc_pid', '--finding records to insert into history_octane.location
SELECT staging_table.loc_pid
     , staging_table.loc_version
     , staging_table.loc_account_pid
     , staging_table.loc_address_street1
     , staging_table.loc_address_street2
     , staging_table.loc_address_city
     , staging_table.loc_address_state
     , staging_table.loc_address_postal_code
     , staging_table.loc_location_name
     , staging_table.loc_location_id
     , staging_table.loc_location_remote
     , staging_table.loc_location_status_type
     , staging_table.loc_fha_field_office_code
     , staging_table.loc_documents_url
     , FALSE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM staging_octane.location staging_table
         LEFT JOIN history_octane.location history_table on staging_table.loc_pid = history_table.loc_pid and staging_table.loc_version = history_table.loc_version
WHERE history_table.loc_pid is NULL
UNION ALL
SELECT history_table.loc_pid
     , history_table.loc_version + 1
     , history_table.loc_account_pid
     , history_table.loc_address_street1
     , history_table.loc_address_street2
     , history_table.loc_address_city
     , history_table.loc_address_state
     , history_table.loc_address_postal_code
     , history_table.loc_location_name
     , history_table.loc_location_id
     , history_table.loc_location_remote
     , history_table.loc_location_status_type
     , history_table.loc_fha_field_office_code
     , history_table.loc_documents_url
     , TRUE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM history_octane.location history_table
         LEFT JOIN staging_octane.location staging_table on staging_table.loc_pid = history_table.loc_pid
WHERE staging_table.loc_pid is NULL
  AND not exists (select 1 from history_octane.location deleted_records where deleted_records.loc_pid = history_table.loc_pid and deleted_records.data_source_deleted_flag = True);')
        , ('SP-100850', 'location_lease', 'locl_pid', '--finding records to insert into history_octane.location_lease
SELECT staging_table.locl_pid
     , staging_table.locl_version
     , staging_table.locl_location_pid
     , staging_table.locl_from_date
     , staging_table.locl_through_date
     , staging_table.locl_monthly_lease_amount
     , staging_table.locl_cubicle_count
     , staging_table.locl_office_count
     , FALSE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM staging_octane.location_lease staging_table
         LEFT JOIN history_octane.location_lease history_table on staging_table.locl_pid = history_table.locl_pid and staging_table.locl_version = history_table.locl_version
WHERE history_table.locl_pid is NULL
UNION ALL
SELECT history_table.locl_pid
     , history_table.locl_version + 1
     , history_table.locl_location_pid
     , history_table.locl_from_date
     , history_table.locl_through_date
     , history_table.locl_monthly_lease_amount
     , history_table.locl_cubicle_count
     , history_table.locl_office_count
     , TRUE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM history_octane.location_lease history_table
         LEFT JOIN staging_octane.location_lease staging_table on staging_table.locl_pid = history_table.locl_pid
WHERE staging_table.locl_pid is NULL
  AND not exists (select 1 from history_octane.location_lease deleted_records where deleted_records.locl_pid = history_table.locl_pid and deleted_records.data_source_deleted_flag = True);
')
        , ('SP-100851', 'company_location_type', 'code', 'SELECT staging_table.code
, staging_table.value
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.company_location_type staging_table
LEFT JOIN history_octane.company_location_type history_table on staging_table.code = history_table.code AND staging_table.value = history_table.value
WHERE history_table.code is NULL')
        , ('SP-100852', 'company_location', 'cmloc_pid', '--finding records to insert into history_octane.company_location
SELECT staging_table.cmloc_pid
     , staging_table.cmloc_version
     , staging_table.cmloc_company_pid
     , staging_table.cmloc_location_pid
     , staging_table.cmloc_from_date
     , staging_table.cmloc_through_date
     , staging_table.cmloc_company_location_type
     , staging_table.cmloc_nmls_id
     , staging_table.cmloc_fha_branch_id
     , staging_table.cmloc_fha_branch_id_qualified
     , staging_table.cmloc_office_phone
     , staging_table.cmloc_office_phone_extension
     , staging_table.cmloc_fax
     , FALSE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM staging_octane.company_location staging_table
         LEFT JOIN history_octane.company_location history_table on staging_table.cmloc_pid = history_table.cmloc_pid and staging_table.cmloc_version = history_table.cmloc_version
WHERE history_table.cmloc_pid is NULL
UNION ALL
SELECT history_table.cmloc_pid
     , history_table.cmloc_version + 1
     , history_table.cmloc_company_pid
     , history_table.cmloc_location_pid
     , history_table.cmloc_from_date
     , history_table.cmloc_through_date
     , history_table.cmloc_company_location_type
     , history_table.cmloc_nmls_id
     , history_table.cmloc_fha_branch_id
     , history_table.cmloc_fha_branch_id_qualified
     , history_table.cmloc_office_phone
     , history_table.cmloc_office_phone_extension
     , history_table.cmloc_fax
     , TRUE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM history_octane.company_location history_table
         LEFT JOIN staging_octane.company_location staging_table on staging_table.cmloc_pid = history_table.cmloc_pid
WHERE staging_table.cmloc_pid is NULL
  AND not exists (select 1 from history_octane.company_location deleted_records where deleted_records.cmloc_pid = history_table.cmloc_pid and deleted_records.data_source_deleted_flag = True);
')
        , ('SP-100853', 'lender_user_location_type', 'code', 'SELECT staging_table.code
, staging_table.value
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.lender_user_location_type staging_table
LEFT JOIN history_octane.lender_user_location_type history_table on staging_table.code = history_table.code AND staging_table.value = history_table.value
WHERE history_table.code is NULL')
        , ('SP-100854', 'workspace_type', 'code', 'SELECT staging_table.code
, staging_table.value
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.workspace_type staging_table
LEFT JOIN history_octane.workspace_type history_table on staging_table.code = history_table.code AND staging_table.value = history_table.value
WHERE history_table.code is NULL')
        , ('SP-100855', 'lender_user_location', 'luloc_pid', '--finding records to insert into history_octane.lender_user_location
SELECT staging_table.luloc_pid
     , staging_table.luloc_version
     , staging_table.luloc_company_pid
     , staging_table.luloc_lender_user_pid
     , staging_table.luloc_location_pid
     , staging_table.luloc_from_date
     , staging_table.luloc_lender_user_location_type
     , staging_table.luloc_workspace_type
     , staging_table.luloc_workspace_code
     , FALSE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM staging_octane.lender_user_location staging_table
         LEFT JOIN history_octane.lender_user_location history_table on staging_table.luloc_pid = history_table.luloc_pid and staging_table.luloc_version = history_table.luloc_version
WHERE history_table.luloc_pid is NULL
UNION ALL
SELECT history_table.luloc_pid
     , history_table.luloc_version + 1
     , history_table.luloc_company_pid
     , history_table.luloc_lender_user_pid
     , history_table.luloc_location_pid
     , history_table.luloc_from_date
     , history_table.luloc_lender_user_location_type
     , history_table.luloc_workspace_type
     , history_table.luloc_workspace_code
     , TRUE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM history_octane.lender_user_location history_table
         LEFT JOIN staging_octane.lender_user_location staging_table on staging_table.luloc_pid = history_table.luloc_pid
WHERE staging_table.luloc_pid is NULL
  AND not exists (select 1 from history_octane.lender_user_location deleted_records where deleted_records.luloc_pid = history_table.luloc_pid and deleted_records.data_source_deleted_flag = True);
')
        , ('SP-100856', 'location_id_ticker', 'loctk_pid', '--finding records to insert into history_octane.location_id_ticker
SELECT staging_table.loctk_pid
     , staging_table.loctk_version
     , staging_table.loctk_account_pid
     , staging_table.loctk_next_location_id
     , FALSE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM staging_octane.location_id_ticker staging_table
         LEFT JOIN history_octane.location_id_ticker history_table on staging_table.loctk_pid = history_table.loctk_pid and staging_table.loctk_version = history_table.loctk_version
WHERE history_table.loctk_pid is NULL
UNION ALL
SELECT history_table.loctk_pid
     , history_table.loctk_version + 1
     , history_table.loctk_account_pid
     , history_table.loctk_next_location_id
     , TRUE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM history_octane.location_id_ticker history_table
         LEFT JOIN staging_octane.location_id_ticker staging_table on staging_table.loctk_pid = history_table.loctk_pid
WHERE staging_table.loctk_pid is NULL
  AND not exists (select 1 from history_octane.location_id_ticker deleted_records where deleted_records.loctk_pid = history_table.loctk_pid and deleted_records.data_source_deleted_flag = True);
')
        , ('SP-100857', 'location_note', 'locn_pid', '--finding records to insert into history_octane.location_note
SELECT staging_table.locn_pid
, staging_table.locn_version
, staging_table.locn_location_pid
, staging_table.locn_create_datetime
, staging_table.locn_content
, staging_table.locn_author_lender_user_pid
, staging_table.locn_author_unparsed_name
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.location_note staging_table
LEFT JOIN history_octane.location_note history_table on staging_table.locn_pid = history_table.locn_pid and staging_table.locn_version = history_table.locn_version
WHERE history_table.locn_pid is NULL
UNION ALL
SELECT history_table.locn_pid
, history_table.locn_version + 1
, history_table.locn_location_pid
, history_table.locn_create_datetime
, history_table.locn_content
, history_table.locn_author_lender_user_pid
, history_table.locn_author_unparsed_name
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM history_octane.location_note history_table
LEFT JOIN staging_octane.location_note staging_table on staging_table.locn_pid = history_table.locn_pid
WHERE staging_table.locn_pid is NULL
  AND not exists (select 1 from history_octane.location_note deleted_records where deleted_records.locn_pid = history_table.locn_pid and deleted_records.data_source_deleted_flag = True);')
        , ('SP-100858', 'location_note_comment', 'locnc_pid', '--finding records to insert into history_octane.location_note_comment
SELECT staging_table.locnc_pid
, staging_table.locnc_version
, staging_table.locnc_location_note_pid
, staging_table.locnc_create_datetime
, staging_table.locnc_content
, staging_table.locnc_author_lender_user_pid
, staging_table.locnc_author_unparsed_name
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.location_note_comment staging_table
LEFT JOIN history_octane.location_note_comment history_table on staging_table.locnc_pid = history_table.locnc_pid and staging_table.locnc_version = history_table.locnc_version
WHERE history_table.locnc_pid is NULL
UNION ALL
SELECT history_table.locnc_pid
, history_table.locnc_version + 1
, history_table.locnc_location_note_pid
, history_table.locnc_create_datetime
, history_table.locnc_content
, history_table.locnc_author_lender_user_pid
, history_table.locnc_author_unparsed_name
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM history_octane.location_note_comment history_table
LEFT JOIN staging_octane.location_note_comment staging_table on staging_table.locnc_pid = history_table.locnc_pid
WHERE staging_table.locnc_pid is NULL
  AND not exists (select 1 from history_octane.location_note_comment deleted_records where deleted_records.locnc_pid = history_table.locnc_pid and deleted_records.data_source_deleted_flag = True);')
        , ('SP-100859', 'location_note_monitor', 'locnm_pid', '--finding records to insert into history_octane.location_note_monitor
SELECT staging_table.locnm_pid
, staging_table.locnm_version
, staging_table.locnm_location_note_pid
, staging_table.locnm_lender_user_pid
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.location_note_monitor staging_table
LEFT JOIN history_octane.location_note_monitor history_table on staging_table.locnm_pid = history_table.locnm_pid and staging_table.locnm_version = history_table.locnm_version
WHERE history_table.locnm_pid is NULL
UNION ALL
SELECT history_table.locnm_pid
, history_table.locnm_version + 1
, history_table.locnm_location_note_pid
, history_table.locnm_lender_user_pid
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM history_octane.location_note_monitor history_table
LEFT JOIN staging_octane.location_note_monitor staging_table on staging_table.locnm_pid = history_table.locnm_pid
WHERE staging_table.locnm_pid is NULL
  AND not exists (select 1 from history_octane.location_note_monitor deleted_records where deleted_records.locnm_pid = history_table.locnm_pid and deleted_records.data_source_deleted_flag = True);')
)

, new_processes AS (
    INSERT INTO mdi.process (name, description)
        SELECT new_process_variables.name
             , 'ETL to copy ' || new_process_variables.target_table || ' data from staging_octane to history_octane'
        FROM new_process_variables
        RETURNING dwid, name, description
)

, new_table_input_steps AS (
    INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables,
                                      enable_lazy_conversion, cached_row_meta, connectionname)
        SELECT new_processes.dwid
             , 0
             , new_process_variables.sql
             , 0
             , 'N'
             , 'N'
             , 'N'
             , 'N'
             , 'Staging DB Connection'
        FROM new_processes
            JOIN new_process_variables ON new_processes.name = new_process_variables.name
)

, new_table_output_steps AS (
    INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field,
                                       auto_generated_key_field, partition_data_per, table_name_defined_in_field,
                                       return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables,
                                       specify_database_fields, ignore_insert_errors, use_batch_update)
        SELECT new_processes.dwid
             , 'history_octane'
             , new_process_variables.target_table
             , 1000
             , NULL
             , NULL
             , NULL
             , NULL
             , 'N'
             , NULL
             , 'N'
             , 'Staging DB Connection'
             , 'N'
             , 'Y'
             , 'N'
             , 'N'
        FROM new_processes
            JOIN new_process_variables ON new_processes.name = new_process_variables.name
        RETURNING dwid, target_schema, target_table
)

, new_table_output_fields AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
        SELECT new_table_output_steps.dwid
             , new_fields.field_name
             , new_fields.field_name
             , new_fields.field_order
             , FALSE
        FROM new_table_output_steps
            JOIN new_fields ON new_fields.schema_name = new_table_output_steps.target_schema
                AND new_fields.table_name = new_table_output_steps.target_table
)

, new_json_output_fields AS (
    INSERT INTO mdi.json_output_field (process_dwid, field_name)
        SELECT new_processes.dwid, new_process_variables.json_output_field
        FROM new_processes
            JOIN new_process_variables ON new_processes.name = new_process_variables.name
)

, new_state_machine_definitions AS (
    INSERT INTO mdi.state_machine_definition (process_dwid, name, comment)
        SELECT new_processes.dwid, new_processes.name, new_processes.description
        FROM new_processes
)
SELECT 'Finished inserting metadata for new tables: location, location_status_type, location_lease, ' ||
       'company_location_type, company_location, lender_user_location_type, workspace_type, lender_user_location, ' ||
       'location_id_ticker, location_note, location_note_comment, location_note_monitor';

/*
Insert metadata for new columns:
    - branch.br_location_pid
    - branch_license.brml_company_pid
    - branch_license.brml_location_pid
    - deal.d_license_location_pid
    - borrower_declarations.bdec_intend_to_occupy_more_than_14_days
    - proposal.prp_cash_out_reason_investment_or_business_property
    - proposal.prp_cash_out_reason_business_debt_or_debt_consolidation
    - proposal.prp_non_business_cash_out_reason_acknowledged
    - loan_hedge.lh_qualified_mortgage_status_type
*/

WITH new_fields (table_name, field_name, field_order) AS (
    VALUES ('branch', 'br_location_pid', 27)
        , ('branch_license', 'brml_company_pid', 11)
        , ('branch_license', 'brml_location_pid', 12)
        , ('deal', 'd_license_location_pid', 56)
        , ('borrower_declarations', 'bdec_intend_to_occupy_more_than_14_days', 23)
        , ('proposal', 'prp_cash_out_reason_investment_or_business_property', 239)
        , ('proposal', 'prp_cash_out_reason_business_debt_or_debt_consolidation', 240)
        , ('proposal', 'prp_non_business_cash_out_reason_acknowledged', 241)
        , ('loan_hedge', 'lh_qualified_mortgage_status_type', 300)
)

, new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT edw_table_definition.dwid
             , new_fields.field_name
             , FALSE
        FROM new_fields
            JOIN mdi.edw_table_definition ON edw_table_definition.schema_name = 'staging_octane'
                AND new_fields.table_name = edw_table_definition.table_name
        RETURNING dwid, edw_table_definition_dwid, field_name
)

, new_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid)
        SELECT edw_table_definition.dwid
             , new_fields.field_name
             , FALSE
             , new_staging_field_definitions.dwid
        FROM new_fields
            JOIN mdi.edw_table_definition ON edw_table_definition.schema_name = 'history_octane'
                AND new_fields.table_name = edw_table_definition.table_name
            JOIN mdi.edw_table_definition AS source_table_definition ON source_table_definition.schema_name = 'staging_octane'
                AND source_table_definition.table_name = new_fields.table_name
            JOIN new_staging_field_definitions ON new_staging_field_definitions.edw_table_definition_dwid = source_table_definition.dwid
                AND new_staging_field_definitions.field_name = new_fields.field_name
)

, new_table_output_fields AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
        SELECT table_output_step.dwid
             , new_fields.field_name
             , new_fields.field_name
             , new_fields.field_order
             , FALSE
        FROM new_fields
            JOIN mdi.table_output_step ON table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = new_fields.table_name
)

, updated_table_input_sql (table_name, sql) AS (
    VALUES ('borrower_declarations', '--finding records to insert into history_octane.borrower_declarations
SELECT staging_table.bdec_pid
, staging_table.bdec_version
, staging_table.bdec_borrower_pid
, staging_table.bdec_fha_secondary_residence
, staging_table.bdec_relationship_with_seller
, staging_table.bdec_borrowed_funds_undisclosed
, staging_table.bdec_borrowed_funds_undisclosed_amount
, staging_table.bdec_other_mortgage_in_progress_before_closing
, staging_table.bdec_applying_for_credit_before_closing
, staging_table.bdec_priority_given_to_another_lien
, staging_table.bdec_cosigner_undisclosed
, staging_table.bdec_currently_delinquent_federal_debt
, staging_table.bdec_party_to_lawsuit
, staging_table.bdec_conveyed_title_in_lieu_of_foreclosure
, staging_table.bdec_completed_pre_foreclosure_short_sale
, staging_table.bdec_property_foreclosure
, staging_table.bdec_bankruptcy_chapter_7
, staging_table.bdec_bankruptcy_chapter_11
, staging_table.bdec_bankruptcy_chapter_12
, staging_table.bdec_bankruptcy_chapter_13
, staging_table.bdec_intend_to_occupy_more_than_14_days
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.borrower_declarations staging_table
LEFT JOIN history_octane.borrower_declarations history_table on staging_table.bdec_pid = history_table.bdec_pid and staging_table.bdec_version = history_table.bdec_version
WHERE history_table.bdec_pid is NULL
UNION ALL
SELECT history_table.bdec_pid
, history_table.bdec_version+1
, history_table.bdec_borrower_pid
, history_table.bdec_fha_secondary_residence
, history_table.bdec_relationship_with_seller
, history_table.bdec_borrowed_funds_undisclosed
, history_table.bdec_borrowed_funds_undisclosed_amount
, history_table.bdec_other_mortgage_in_progress_before_closing
, history_table.bdec_applying_for_credit_before_closing
, history_table.bdec_priority_given_to_another_lien
, history_table.bdec_cosigner_undisclosed
, history_table.bdec_currently_delinquent_federal_debt
, history_table.bdec_party_to_lawsuit
, history_table.bdec_conveyed_title_in_lieu_of_foreclosure
, history_table.bdec_completed_pre_foreclosure_short_sale
, history_table.bdec_property_foreclosure
, history_table.bdec_bankruptcy_chapter_7
, history_table.bdec_bankruptcy_chapter_11
, history_table.bdec_bankruptcy_chapter_12
, history_table.bdec_bankruptcy_chapter_13
, history_table.bdec_intend_to_occupy_more_than_14_days
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM history_octane.borrower_declarations history_table
LEFT JOIN staging_octane.borrower_declarations staging_table on staging_table.bdec_pid = history_table.bdec_pid
WHERE staging_table.bdec_pid is NULL
    AND not exists (select 1 from history_octane.borrower_declarations deleted_records where deleted_records.bdec_pid = history_table.bdec_pid and deleted_records.data_source_deleted_flag = True)')
        , ('branch', '--finding records to insert into history_octane.branch
SELECT staging_table.br_pid
, staging_table.br_version
, staging_table.br_company_pid
, staging_table.br_branch_name
, staging_table.br_fha_field_office_code
, staging_table.br_branch_id
, staging_table.br_branch_status_type
, staging_table.br_nmls_branch_id
, staging_table.br_uuts_loan_originator_type
, staging_table.br_address_street1
, staging_table.br_address_street2
, staging_table.br_address_city
, staging_table.br_address_state
, staging_table.br_address_postal_code
, staging_table.br_address_country
, staging_table.br_office_phone
, staging_table.br_office_phone_extension
, staging_table.br_fax
, staging_table.br_lp_lender_branch_id
, staging_table.br_dsi_customer_id
, staging_table.br_clg_flood_cert_internal_account_id
, staging_table.br_street_links_branch_id
, staging_table.br_fha_branch_id
, staging_table.br_fha_branch_id_qualified
, staging_table.br_lender_paid_broker_compensation_percent
, staging_table.br_location_pid
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.branch staging_table
LEFT JOIN history_octane.branch history_table on staging_table.br_pid = history_table.br_pid and staging_table.br_version = history_table.br_version
WHERE history_table.br_pid is NULL
UNION ALL
SELECT history_table.br_pid
, history_table.br_version+1
, history_table.br_company_pid
, history_table.br_branch_name
, history_table.br_fha_field_office_code
, history_table.br_branch_id
, history_table.br_branch_status_type
, history_table.br_nmls_branch_id
, history_table.br_uuts_loan_originator_type
, history_table.br_address_street1
, history_table.br_address_street2
, history_table.br_address_city
, history_table.br_address_state
, history_table.br_address_postal_code
, history_table.br_address_country
, history_table.br_office_phone
, history_table.br_office_phone_extension
, history_table.br_fax
, history_table.br_lp_lender_branch_id
, history_table.br_dsi_customer_id
, history_table.br_clg_flood_cert_internal_account_id
, history_table.br_street_links_branch_id
, history_table.br_fha_branch_id
, history_table.br_fha_branch_id_qualified
, history_table.br_lender_paid_broker_compensation_percent
, history_table.br_location_pid
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM history_octane.branch history_table
LEFT JOIN staging_octane.branch staging_table on staging_table.br_pid = history_table.br_pid
WHERE staging_table.br_pid is NULL
    AND not exists (select 1 from history_octane.branch deleted_records where deleted_records.br_pid = history_table.br_pid and deleted_records.data_source_deleted_flag = True)')
        , ('branch_license', '--finding records to insert into history_octane.branch_license
SELECT staging_table.brml_pid
, staging_table.brml_version
, staging_table.brml_branch_pid
, staging_table.brml_license_type
, staging_table.brml_state_type
, staging_table.brml_license_number
, staging_table.brml_from_date
, staging_table.brml_through_date
, staging_table.brml_note
, staging_table.brml_company_pid
, staging_table.brml_location_pid
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.branch_license staging_table
LEFT JOIN history_octane.branch_license history_table on staging_table.brml_pid = history_table.brml_pid and staging_table.brml_version = history_table.brml_version
WHERE history_table.brml_pid is NULL
UNION ALL
SELECT history_table.brml_pid
, history_table.brml_version+1
, history_table.brml_branch_pid
, history_table.brml_license_type
, history_table.brml_state_type
, history_table.brml_license_number
, history_table.brml_from_date
, history_table.brml_through_date
, history_table.brml_note
, history_table.brml_company_pid
, history_table.brml_location_pid
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM history_octane.branch_license history_table
LEFT JOIN staging_octane.branch_license staging_table on staging_table.brml_pid = history_table.brml_pid
WHERE staging_table.brml_pid is NULL
    AND not exists (select 1 from history_octane.branch_license deleted_records where deleted_records.brml_pid = history_table.brml_pid and deleted_records.data_source_deleted_flag = True)           ')
        , ('deal', '--finding records to insert into history_octane.deal
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
, staging_table.d_disclosure_mode_date
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
, staging_table.d_license_location_pid
, FALSE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM staging_octane.deal staging_table
LEFT JOIN history_octane.deal history_table
          ON staging_table.d_pid = history_table.d_pid AND staging_table.d_version = history_table.d_version
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
, history_table.d_disclosure_mode_date
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
, history_table.d_license_location_pid
, TRUE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM history_octane.deal history_table
LEFT JOIN staging_octane.deal staging_table
          ON staging_table.d_pid = history_table.d_pid
WHERE staging_table.d_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.deal deleted_records
                  WHERE deleted_records.d_pid = history_table.d_pid AND deleted_records.data_source_deleted_flag = TRUE );')
        , ('loan_hedge', '--finding records to insert into history_octane.loan_hedge
SELECT staging_table.lh_pid
, staging_table.lh_version
, staging_table.lh_loan_pid
, staging_table.lh_update_datetime
, staging_table.lh_update_pending_datetime
, staging_table.lh_transaction_status_date
, staging_table.lh_loan_number
, staging_table.lh_product_code
, staging_table.lh_note_rate
, staging_table.lh_loan_amount
, staging_table.lh_lock_date
, staging_table.lh_buy_side_lock_expires_date
, staging_table.lh_lock_expiration_date
, staging_table.lh_secondary_cost
, staging_table.lh_total_cost_basis
, staging_table.lh_total_lender_margin
, staging_table.lh_stage
, staging_table.lh_fund_date
, staging_table.lh_allocation_date
, staging_table.lh_estimated_fund_date
, staging_table.lh_purchased_by_investor_date
, staging_table.lh_commitment_number
, staging_table.lh_property_occupancy
, staging_table.lh_property_type
, staging_table.lh_property_type_supplemental
, staging_table.lh_property_state
, staging_table.lh_property_zip
, staging_table.lh_property_number_of_units
, staging_table.lh_purchase_price
, staging_table.lh_appraised_value
, staging_table.lh_purpose
, staging_table.lh_refinance_type
, staging_table.lh_lien_position
, staging_table.lh_impounds
, staging_table.lh_buydown_type
, staging_table.lh_buydown
, staging_table.lh_ltv
, staging_table.lh_original_ltv
, staging_table.lh_cltv
, staging_table.lh_original_cltv
, staging_table.lh_effective_credit_score
, staging_table.lh_doc_type
, staging_table.lh_debt_to_income
, staging_table.lh_prepayment_penalty
, staging_table.lh_prepayment_penalty_term
, staging_table.lh_interest_only
, staging_table.lh_lock_type
, staging_table.lh_lock_period
, staging_table.lh_fees_collected_bps
, staging_table.lh_channel
, staging_table.lh_loan_officer
, staging_table.lh_branch
, staging_table.lh_broker
, staging_table.lh_correspondent
, staging_table.lh_origination_source
, staging_table.lh_investor
, staging_table.lh_investor_total_price
, staging_table.lh_investor_base_price
, staging_table.lh_investor_srp_paid
, staging_table.lh_investor_loan_number
, staging_table.lh_pmi
, staging_table.lh_pmi_percent
, staging_table.lh_mi_cert_number
, staging_table.lh_srp_paid
, staging_table.lh_discount_points
, staging_table.lh_date_docs_back
, staging_table.lh_note_date
, staging_table.lh_close_date
, staging_table.lh_first_payment_date
, staging_table.lh_last_payment_date
, staging_table.lh_next_scheduled_payment_due_date
, staging_table.lh_scheduled_principal_and_interest
, staging_table.lh_current_principal_and_interest
, staging_table.lh_minimum_principal_and_interest
, staging_table.lh_current_unpaid_principal_balance
, staging_table.lh_original_interest_rate
, staging_table.lh_maturity_date
, staging_table.lh_amortization_term
, staging_table.lh_yearly_payment_cap
, staging_table.lh_arm_margin
, staging_table.lh_arm_adjustment_date
, staging_table.lh_first_arm_period
, staging_table.lh_first_arm_adjustment_cap
, staging_table.lh_arm_life_floor
, staging_table.lh_arm_life_ceiling
, staging_table.lh_first_arm_payment_adjustment_date
, staging_table.lh_arm_period_after_first
, staging_table.lh_arm_adjustment_cap_after_first
, staging_table.lh_first_payment_cap
, staging_table.lh_payment_cap_option
, staging_table.lh_neg_am_flag
, staging_table.lh_maximum_negative_amortization
, staging_table.lh_arm_convertible
, staging_table.lh_arm_index
, staging_table.lh_dual_loan_flag
, staging_table.lh_other_loan_number
, staging_table.lh_agency_extract_fields
, staging_table.lh_warehouse_bank
, staging_table.lh_wire_amount
, staging_table.lh_credit_rating_agency_fields
, staging_table.lh_levels_fields
, staging_table.lh_data_fields
, staging_table.lh_loan_status
, staging_table.lh_suspense_yes_no
, staging_table.lh_loan_type
, staging_table.lh_hud_borr_paid_by_for_borr_other_amount
, staging_table.lh_fees_line_user_def_fee_one_borr
, staging_table.lh_uw_suspended_cleared_date
, staging_table.lh_underwriting_suspended_date
, staging_table.lh_line_orig_charge
, staging_table.lh_amortization_type
, staging_table.lh_milestone
, staging_table.lh_msa
, staging_table.lh_county_code
, staging_table.lh_ship_date_to_investor
, staging_table.lh_borrower_last_name
, staging_table.lh_purchase_advice_suspense_fee
, staging_table.lh_purchase_advice_early_delivery_amount
, staging_table.lh_purchase_advice_llpa
, staging_table.lh_purchase_advice_fmna
, staging_table.lh_purchase_advice_rp
, staging_table.lh_lock_info_relock_amount
, staging_table.lh_lock_info_loan_basis
, staging_table.lh_lock_info_lock_request_fulfilled_date_time
, staging_table.lh_lock_info_rate_lock_request_rate_sheet_id
, staging_table.lh_current_status_change_date
, staging_table.lh_aus_type
, staging_table.lh_buy_side_base_arm_margin
, staging_table.lh_uldd_poolid
, staging_table.lh_warehouse_co_name
, staging_table.lh_underwriting_investor_eligibility_wells_fargo
, staging_table.lh_underwriting_investor_eligibility_chase
, staging_table.lh_du_fail_reason
, staging_table.lh_lpmi_total_costs_on_lock
, staging_table.lh_lpmi_after_lock_required
, staging_table.lh_lpmi_after_lock_bps
, staging_table.lh_mi_company_name_type
, staging_table.lh_lpmi_frequency
, staging_table.lh_lpmi_estimated_amount_of_lender_paid_mi
, staging_table.lh_mortgage_insurance_premium_source_type
, staging_table.lh_loan_amount_repeat
, staging_table.lh_product_code_repeat
, staging_table.lh_note_rate_repeat
, staging_table.lh_loan_info_loan_id
, staging_table.lh_salable_loan
, staging_table.lh_sale_hold
, staging_table.lh_sale_hold_comments
, staging_table.lh_pf_disbursement_ledger_date
, staging_table.lh_aus_eligibility
, staging_table.lh_texas_cash_out
, staging_table.lh_acceptable_du
, staging_table.lh_acceptable_lp
, staging_table.lh_financed_property_count
, staging_table.lh_payoff_primary_lien_holder_company
, staging_table.lh_payoff_junior_lien_holder_company
, staging_table.lh_base_loan_amount
, staging_table.lh_funding_authorized
, staging_table.lh_credit_committee_fico_exception
, staging_table.lh_home_ready_eligibility
, staging_table.lh_home_ready_borr_acceptance
, staging_table.lh_home_ready_eligibility_review
, staging_table.lh_home_possible_eligibility
, staging_table.lh_home_possible_eligibility_review
, staging_table.lh_piw
, staging_table.lh_piw_fee
, staging_table.lh_uw_investor_eligibility_fnma
, staging_table.lh_uw_investor_eligibility_fhlmc
, staging_table.lh_appraisal_form
, staging_table.lh_ext_cos_total_amt
, staging_table.lh_fnmcu_risk_score
, staging_table.lh_borrower_income_verification
, staging_table.lh_co_borrower_income_verification
, staging_table.lh_day_one_income_verification_available
, staging_table.lh_subject_property_estimated_value
, staging_table.lh_transaction_status
, staging_table.lh_buy_status
, staging_table.lh_appraisal_exists
, staging_table.lh_du_piw_eligible
, staging_table.lh_lp_appraisal_waiver_eligible
, staging_table.lh_borrower_first_name
, staging_table.lh_co_borrower_first_name
, staging_table.lh_co_borrower_last_name
, staging_table.lh_total_borrower_income
, staging_table.lh_subject_property_city
, staging_table.lh_subject_property_county
, staging_table.lh_subject_property_zip
, staging_table.lh_borrower_decision_credit_score
, staging_table.lh_co_borrower_decision_credit_score
, staging_table.lh_underwriter_disposition
, staging_table.lh_underwrite_risk_assessment_type
, staging_table.lh_subject_property_address
, staging_table.lh_original_lock_date
, staging_table.lh_original_lock_period
, staging_table.lh_borrower_income_docs_required_count
, staging_table.lh_borrower_income_docs_fulfilled_count
, staging_table.lh_borrower_income_docs_approved_count
, staging_table.lh_borrower_asset_docs_required_count
, staging_table.lh_borrower_asset_docs_fulfilled_count
, staging_table.lh_borrower_asset_docs_approved_count
, staging_table.lh_borrower_credit_docs_required_count
, staging_table.lh_borrower_credit_docs_fulfilled_count
, staging_table.lh_borrower_credit_docs_approved_count
, staging_table.lh_initial_uw_submit_date_time
, staging_table.lh_cd_clear_date
, staging_table.lh_lender_concession_total_approved_amount
, staging_table.lh_relock_fee_gross_amount
, staging_table.lh_relock_fee_amount_less_concessions
, staging_table.lh_relock_fee_amount_concessed
, staging_table.lh_lock_extension_fee_gross_amount
, staging_table.lh_lock_extension_fee_amount_less_concessions
, staging_table.lh_lock_extension_fee_amount_concessed
, staging_table.lh_lender_concession_remaining_amount
, staging_table.lh_day_one_concessions
, staging_table.lh_investor_lock_commitment_type
, staging_table.lh_signed_closing_doc_received_datetime
, staging_table.lh_geocoding_msa_code
, staging_table.lh_geocoding_state_code
, staging_table.lh_geocoding_county_code
, staging_table.lh_geocoding_census_tract
, staging_table.lh_tolerance_cure_amount
, staging_table.lh_self_employed_flag
, staging_table.lh_first_time_homebuyer
, staging_table.lh_mortgage_insurance_lpmi_rate_adjustment
, staging_table.lh_eligible_for_qm_status
, staging_table.lh_safe_harbor_test_passed
, staging_table.lh_hpml
, staging_table.lh_hoepa
, staging_table.lh_funding_status
, staging_table.lh_early_funding
, staging_table.lh_early_funding_date
, staging_table.lh_lqa_purchase_eligibility_type
, staging_table.lh_transferred_appraisal
, staging_table.lh_appraisal_cu_risk_score
, staging_table.lh_mi_upfront_rate
, staging_table.lh_loan_funding_requested_date
, staging_table.lh_student_loan_cash_out
, staging_table.lh_octane_high_balance
, staging_table.lh_borrower_final_price
, staging_table.lh_charge_credit_for_interest_rate
, staging_table.lh_contract_processing_fee
, staging_table.lh_escrow_holdback
, staging_table.lh_appraiser_license_number
, staging_table.lh_mcc_present
, staging_table.lh_grant_present
, staging_table.lh_cema
, staging_table.lh_supplemental_margin_company
, staging_table.lh_supplemental_margin_branch
, staging_table.lh_supplemental_margin_total
, staging_table.lh_concessions_renegotiations_amount
, staging_table.lh_fund_source_type
, staging_table.lh_purchase_contract_funding_date
, staging_table.lh_product_id
, staging_table.lh_community_second
, staging_table.lh_current_taxes_and_insurance
, staging_table.lh_multiple_applicants
, staging_table.lh_community_second_liability
, staging_table.lh_property_rights_type
, staging_table.lh_mbs_final_purchaser
, staging_table.lh_hmda_universal_loan_id
, staging_table.lh_lp_ace_eligible
, staging_table.lh_family_advantage_product
, staging_table.lh_effective_rate_sheet_datetime
, staging_table.lh_debt_to_income_excluding_mi
, staging_table.lh_clear_to_commit
, staging_table.lh_b2_first_name
, staging_table.lh_b2_last_name
, staging_table.lh_c2_first_name
, staging_table.lh_c2_last_name
, staging_table.lh_b3_first_name
, staging_table.lh_b3_last_name
, staging_table.lh_c3_first_name
, staging_table.lh_c3_last_name
, staging_table.lh_b4_first_name
, staging_table.lh_b4_last_name
, staging_table.lh_c4_first_name
, staging_table.lh_c4_last_name
, staging_table.lh_b5_first_name
, staging_table.lh_b5_last_name
, staging_table.lh_c5_first_name
, staging_table.lh_c5_last_name
, staging_table.lh_texas_home_equity_conversion
, staging_table.lh_interest_only_heloc
, staging_table.lh_interest_only_term_months
, staging_table.lh_investor_lock_product_name
, staging_table.lh_investor_lock_product_id
, staging_table.lh_rebuttable_presumption
, staging_table.lh_non_conforming
, staging_table.lh_num_deal_updates_since_update_pending
, staging_table.lh_borrower_engagement_percent
, staging_table.lh_loan_create_date
, staging_table.lh_high_balance_hit_percent
, staging_table.lh_new_york_payup_percent
, staging_table.lh_ship_date_to_custodian
, staging_table.lh_lock_vintage
, staging_table.lh_lock_series
, staging_table.lh_investor_total
, staging_table.lh_velocify_lead_id
, staging_table.lh_collateral_tracking_number
, staging_table.lh_qualified_mortgage_status_type
, FALSE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM staging_octane.loan_hedge staging_table
LEFT JOIN history_octane.loan_hedge history_table on staging_table.lh_pid = history_table.lh_pid and staging_table.lh_version = history_table.lh_version
WHERE history_table.lh_pid is NULL
UNION ALL
SELECT history_table.lh_pid
, history_table.lh_version+1
, history_table.lh_loan_pid
, history_table.lh_update_datetime
, history_table.lh_update_pending_datetime
, history_table.lh_transaction_status_date
, history_table.lh_loan_number
, history_table.lh_product_code
, history_table.lh_note_rate
, history_table.lh_loan_amount
, history_table.lh_lock_date
, history_table.lh_buy_side_lock_expires_date
, history_table.lh_lock_expiration_date
, history_table.lh_secondary_cost
, history_table.lh_total_cost_basis
, history_table.lh_total_lender_margin
, history_table.lh_stage
, history_table.lh_fund_date
, history_table.lh_allocation_date
, history_table.lh_estimated_fund_date
, history_table.lh_purchased_by_investor_date
, history_table.lh_commitment_number
, history_table.lh_property_occupancy
, history_table.lh_property_type
, history_table.lh_property_type_supplemental
, history_table.lh_property_state
, history_table.lh_property_zip
, history_table.lh_property_number_of_units
, history_table.lh_purchase_price
, history_table.lh_appraised_value
, history_table.lh_purpose
, history_table.lh_refinance_type
, history_table.lh_lien_position
, history_table.lh_impounds
, history_table.lh_buydown_type
, history_table.lh_buydown
, history_table.lh_ltv
, history_table.lh_original_ltv
, history_table.lh_cltv
, history_table.lh_original_cltv
, history_table.lh_effective_credit_score
, history_table.lh_doc_type
, history_table.lh_debt_to_income
, history_table.lh_prepayment_penalty
, history_table.lh_prepayment_penalty_term
, history_table.lh_interest_only
, history_table.lh_lock_type
, history_table.lh_lock_period
, history_table.lh_fees_collected_bps
, history_table.lh_channel
, history_table.lh_loan_officer
, history_table.lh_branch
, history_table.lh_broker
, history_table.lh_correspondent
, history_table.lh_origination_source
, history_table.lh_investor
, history_table.lh_investor_total_price
, history_table.lh_investor_base_price
, history_table.lh_investor_srp_paid
, history_table.lh_investor_loan_number
, history_table.lh_pmi
, history_table.lh_pmi_percent
, history_table.lh_mi_cert_number
, history_table.lh_srp_paid
, history_table.lh_discount_points
, history_table.lh_date_docs_back
, history_table.lh_note_date
, history_table.lh_close_date
, history_table.lh_first_payment_date
, history_table.lh_last_payment_date
, history_table.lh_next_scheduled_payment_due_date
, history_table.lh_scheduled_principal_and_interest
, history_table.lh_current_principal_and_interest
, history_table.lh_minimum_principal_and_interest
, history_table.lh_current_unpaid_principal_balance
, history_table.lh_original_interest_rate
, history_table.lh_maturity_date
, history_table.lh_amortization_term
, history_table.lh_yearly_payment_cap
, history_table.lh_arm_margin
, history_table.lh_arm_adjustment_date
, history_table.lh_first_arm_period
, history_table.lh_first_arm_adjustment_cap
, history_table.lh_arm_life_floor
, history_table.lh_arm_life_ceiling
, history_table.lh_first_arm_payment_adjustment_date
, history_table.lh_arm_period_after_first
, history_table.lh_arm_adjustment_cap_after_first
, history_table.lh_first_payment_cap
, history_table.lh_payment_cap_option
, history_table.lh_neg_am_flag
, history_table.lh_maximum_negative_amortization
, history_table.lh_arm_convertible
, history_table.lh_arm_index
, history_table.lh_dual_loan_flag
, history_table.lh_other_loan_number
, history_table.lh_agency_extract_fields
, history_table.lh_warehouse_bank
, history_table.lh_wire_amount
, history_table.lh_credit_rating_agency_fields
, history_table.lh_levels_fields
, history_table.lh_data_fields
, history_table.lh_loan_status
, history_table.lh_suspense_yes_no
, history_table.lh_loan_type
, history_table.lh_hud_borr_paid_by_for_borr_other_amount
, history_table.lh_fees_line_user_def_fee_one_borr
, history_table.lh_uw_suspended_cleared_date
, history_table.lh_underwriting_suspended_date
, history_table.lh_line_orig_charge
, history_table.lh_amortization_type
, history_table.lh_milestone
, history_table.lh_msa
, history_table.lh_county_code
, history_table.lh_ship_date_to_investor
, history_table.lh_borrower_last_name
, history_table.lh_purchase_advice_suspense_fee
, history_table.lh_purchase_advice_early_delivery_amount
, history_table.lh_purchase_advice_llpa
, history_table.lh_purchase_advice_fmna
, history_table.lh_purchase_advice_rp
, history_table.lh_lock_info_relock_amount
, history_table.lh_lock_info_loan_basis
, history_table.lh_lock_info_lock_request_fulfilled_date_time
, history_table.lh_lock_info_rate_lock_request_rate_sheet_id
, history_table.lh_current_status_change_date
, history_table.lh_aus_type
, history_table.lh_buy_side_base_arm_margin
, history_table.lh_uldd_poolid
, history_table.lh_warehouse_co_name
, history_table.lh_underwriting_investor_eligibility_wells_fargo
, history_table.lh_underwriting_investor_eligibility_chase
, history_table.lh_du_fail_reason
, history_table.lh_lpmi_total_costs_on_lock
, history_table.lh_lpmi_after_lock_required
, history_table.lh_lpmi_after_lock_bps
, history_table.lh_mi_company_name_type
, history_table.lh_lpmi_frequency
, history_table.lh_lpmi_estimated_amount_of_lender_paid_mi
, history_table.lh_mortgage_insurance_premium_source_type
, history_table.lh_loan_amount_repeat
, history_table.lh_product_code_repeat
, history_table.lh_note_rate_repeat
, history_table.lh_loan_info_loan_id
, history_table.lh_salable_loan
, history_table.lh_sale_hold
, history_table.lh_sale_hold_comments
, history_table.lh_pf_disbursement_ledger_date
, history_table.lh_aus_eligibility
, history_table.lh_texas_cash_out
, history_table.lh_acceptable_du
, history_table.lh_acceptable_lp
, history_table.lh_financed_property_count
, history_table.lh_payoff_primary_lien_holder_company
, history_table.lh_payoff_junior_lien_holder_company
, history_table.lh_base_loan_amount
, history_table.lh_funding_authorized
, history_table.lh_credit_committee_fico_exception
, history_table.lh_home_ready_eligibility
, history_table.lh_home_ready_borr_acceptance
, history_table.lh_home_ready_eligibility_review
, history_table.lh_home_possible_eligibility
, history_table.lh_home_possible_eligibility_review
, history_table.lh_piw
, history_table.lh_piw_fee
, history_table.lh_uw_investor_eligibility_fnma
, history_table.lh_uw_investor_eligibility_fhlmc
, history_table.lh_appraisal_form
, history_table.lh_ext_cos_total_amt
, history_table.lh_fnmcu_risk_score
, history_table.lh_borrower_income_verification
, history_table.lh_co_borrower_income_verification
, history_table.lh_day_one_income_verification_available
, history_table.lh_subject_property_estimated_value
, history_table.lh_transaction_status
, history_table.lh_buy_status
, history_table.lh_appraisal_exists
, history_table.lh_du_piw_eligible
, history_table.lh_lp_appraisal_waiver_eligible
, history_table.lh_borrower_first_name
, history_table.lh_co_borrower_first_name
, history_table.lh_co_borrower_last_name
, history_table.lh_total_borrower_income
, history_table.lh_subject_property_city
, history_table.lh_subject_property_county
, history_table.lh_subject_property_zip
, history_table.lh_borrower_decision_credit_score
, history_table.lh_co_borrower_decision_credit_score
, history_table.lh_underwriter_disposition
, history_table.lh_underwrite_risk_assessment_type
, history_table.lh_subject_property_address
, history_table.lh_original_lock_date
, history_table.lh_original_lock_period
, history_table.lh_borrower_income_docs_required_count
, history_table.lh_borrower_income_docs_fulfilled_count
, history_table.lh_borrower_income_docs_approved_count
, history_table.lh_borrower_asset_docs_required_count
, history_table.lh_borrower_asset_docs_fulfilled_count
, history_table.lh_borrower_asset_docs_approved_count
, history_table.lh_borrower_credit_docs_required_count
, history_table.lh_borrower_credit_docs_fulfilled_count
, history_table.lh_borrower_credit_docs_approved_count
, history_table.lh_initial_uw_submit_date_time
, history_table.lh_cd_clear_date
, history_table.lh_lender_concession_total_approved_amount
, history_table.lh_relock_fee_gross_amount
, history_table.lh_relock_fee_amount_less_concessions
, history_table.lh_relock_fee_amount_concessed
, history_table.lh_lock_extension_fee_gross_amount
, history_table.lh_lock_extension_fee_amount_less_concessions
, history_table.lh_lock_extension_fee_amount_concessed
, history_table.lh_lender_concession_remaining_amount
, history_table.lh_day_one_concessions
, history_table.lh_investor_lock_commitment_type
, history_table.lh_signed_closing_doc_received_datetime
, history_table.lh_geocoding_msa_code
, history_table.lh_geocoding_state_code
, history_table.lh_geocoding_county_code
, history_table.lh_geocoding_census_tract
, history_table.lh_tolerance_cure_amount
, history_table.lh_self_employed_flag
, history_table.lh_first_time_homebuyer
, history_table.lh_mortgage_insurance_lpmi_rate_adjustment
, history_table.lh_eligible_for_qm_status
, history_table.lh_safe_harbor_test_passed
, history_table.lh_hpml
, history_table.lh_hoepa
, history_table.lh_funding_status
, history_table.lh_early_funding
, history_table.lh_early_funding_date
, history_table.lh_lqa_purchase_eligibility_type
, history_table.lh_transferred_appraisal
, history_table.lh_appraisal_cu_risk_score
, history_table.lh_mi_upfront_rate
, history_table.lh_loan_funding_requested_date
, history_table.lh_student_loan_cash_out
, history_table.lh_octane_high_balance
, history_table.lh_borrower_final_price
, history_table.lh_charge_credit_for_interest_rate
, history_table.lh_contract_processing_fee
, history_table.lh_escrow_holdback
, history_table.lh_appraiser_license_number
, history_table.lh_mcc_present
, history_table.lh_grant_present
, history_table.lh_cema
, history_table.lh_supplemental_margin_company
, history_table.lh_supplemental_margin_branch
, history_table.lh_supplemental_margin_total
, history_table.lh_concessions_renegotiations_amount
, history_table.lh_fund_source_type
, history_table.lh_purchase_contract_funding_date
, history_table.lh_product_id
, history_table.lh_community_second
, history_table.lh_current_taxes_and_insurance
, history_table.lh_multiple_applicants
, history_table.lh_community_second_liability
, history_table.lh_property_rights_type
, history_table.lh_mbs_final_purchaser
, history_table.lh_hmda_universal_loan_id
, history_table.lh_lp_ace_eligible
, history_table.lh_family_advantage_product
, history_table.lh_effective_rate_sheet_datetime
, history_table.lh_debt_to_income_excluding_mi
, history_table.lh_clear_to_commit
, history_table.lh_b2_first_name
, history_table.lh_b2_last_name
, history_table.lh_c2_first_name
, history_table.lh_c2_last_name
, history_table.lh_b3_first_name
, history_table.lh_b3_last_name
, history_table.lh_c3_first_name
, history_table.lh_c3_last_name
, history_table.lh_b4_first_name
, history_table.lh_b4_last_name
, history_table.lh_c4_first_name
, history_table.lh_c4_last_name
, history_table.lh_b5_first_name
, history_table.lh_b5_last_name
, history_table.lh_c5_first_name
, history_table.lh_c5_last_name
, history_table.lh_texas_home_equity_conversion
, history_table.lh_interest_only_heloc
, history_table.lh_interest_only_term_months
, history_table.lh_investor_lock_product_name
, history_table.lh_investor_lock_product_id
, history_table.lh_rebuttable_presumption
, history_table.lh_non_conforming
, history_table.lh_num_deal_updates_since_update_pending
, history_table.lh_borrower_engagement_percent
, history_table.lh_loan_create_date
, history_table.lh_high_balance_hit_percent
, history_table.lh_new_york_payup_percent
, history_table.lh_ship_date_to_custodian
, history_table.lh_lock_vintage
, history_table.lh_lock_series
, history_table.lh_investor_total
, history_table.lh_velocify_lead_id
, history_table.lh_collateral_tracking_number
, history_table.lh_qualified_mortgage_status_type
, TRUE as data_source_deleted_flag
, now() AS data_source_updated_datetime
FROM history_octane.loan_hedge history_table
LEFT JOIN staging_octane.loan_hedge staging_table on staging_table.lh_pid = history_table.lh_pid
WHERE staging_table.lh_pid is NULL
  AND not exists (select 1 from history_octane.loan_hedge deleted_records where deleted_records.lh_pid = history_table.lh_pid and deleted_records.data_source_deleted_flag = True);')
        , ('proposal', '--finding records to insert into history_octane.proposal
SELECT staging_table.prp_estimated_hard_construction_cost_amount
, staging_table.prp_financed_property_improvements
, staging_table.prp_pid
, staging_table.prp_version
, staging_table.prp_decision_lp_request_pid
, staging_table.prp_decision_du_request_pid
, staging_table.prp_proposal_type
, staging_table.prp_description
, staging_table.prp_doc_level_type
, staging_table.prp_loan_purpose_type
, staging_table.prp_name
, staging_table.prp_create_datetime
, staging_table.prp_effective_funding_date
, staging_table.prp_estimated_funding_date
, staging_table.prp_calculated_earliest_allowed_consummation_date
, staging_table.prp_overridden_earliest_allowed_consummation_date
, staging_table.prp_effective_earliest_allowed_consummation_date
, staging_table.prp_earliest_allowed_consummation_date_override_reason
, staging_table.prp_last_requested_disclosure_date
, staging_table.prp_closing_document_sign_datetime
, staging_table.prp_scheduled_closing_document_sign_datetime
, staging_table.prp_rescission_through_date
, staging_table.prp_rescission_notification_date
, staging_table.prp_rescission_notification_by
, staging_table.prp_rescission_notification_type
, staging_table.prp_rescission_effective_date
, staging_table.prp_first_payment_date
, staging_table.prp_first_payment_date_auto_compute
, staging_table.prp_property_usage_type
, staging_table.prp_estimated_property_value_amount
, staging_table.prp_smart_charges_enabled
, staging_table.prp_charges_updated_datetime
, staging_table.prp_smart_docs_enabled
, staging_table.prp_docs_enabled_datetime
, staging_table.prp_request_fha_mip_refund_required
, staging_table.prp_request_recording_fees_required
, staging_table.prp_request_property_taxes_required
, staging_table.prp_property_tax_request_error_messages
, staging_table.prp_fha_mip_refund_request_input_error
, staging_table.prp_recording_fees_request_input_error
, staging_table.prp_property_taxes_request_input_error
, staging_table.prp_publish
, staging_table.prp_publish_date
, staging_table.prp_ipc_auto_compute
, staging_table.prp_ipc_limit_percent
, staging_table.prp_ipc_maximum_amount_allowed
, staging_table.prp_ipc_amount
, staging_table.prp_ipc_percent
, staging_table.prp_ipc_financing_concession_amount
, staging_table.prp_ipc_non_cash_concession_amount
, staging_table.prp_sale_price_amount
, staging_table.prp_structure_type
, staging_table.prp_deal_pid
, staging_table.prp_gfe_interest_rate_expiration_date
, staging_table.prp_gfe_lock_duration_days
, staging_table.prp_gfe_lock_before_settlement_days
, staging_table.prp_proposal_expiration_date
, staging_table.prp_uuts_master_contact_name
, staging_table.prp_uuts_master_contact_title
, staging_table.prp_uuts_master_office_phone
, staging_table.prp_uuts_master_office_phone_extension
, staging_table.prp_underwrite_risk_assessment_type
, staging_table.prp_underwriting_comments
, staging_table.prp_reserves_auto_compute
, staging_table.prp_reserves_amount
, staging_table.prp_reserves_months
, staging_table.prp_underwrite_disposition_type
, staging_table.prp_underwrite_publish_date
, staging_table.prp_underwrite_expiration_date
, staging_table.prp_usda_gsa_sam_exclusion
, staging_table.prp_usda_gsa_sam_checked_date
, staging_table.prp_usda_rd_single_family_housing_type
, staging_table.prp_underwrite_method_type
, staging_table.prp_mi_required
, staging_table.prp_decision_credit_score_borrower_pid
, staging_table.prp_decision_credit_score
, staging_table.prp_estimated_credit_score
, staging_table.prp_effective_credit_score
, staging_table.prp_mortgagee_builder_seller_relationship
, staging_table.prp_fha_prior_agency_case_id
, staging_table.prp_fha_prior_agency_case_endorsement_date
, staging_table.prp_fha_refinance_authorization_number
, staging_table.prp_fha_refinance_authorization_expiration_date
, staging_table.prp_fhac_refinance_authorization_messages
, staging_table.prp_hud_fha_de_approval_type
, staging_table.prp_owner_occupancy_not_required
, staging_table.prp_va_monthly_utilities_included
, staging_table.prp_va_maintenance_utilities_auto_compute
, staging_table.prp_va_monthly_maintenance_utilities_amount
, staging_table.prp_va_maintenance_utilities_per_square_feet_amount
, staging_table.prp_household_size_count
, staging_table.prp_va_past_credit_record_type
, staging_table.prp_va_meets_credit_standards
, staging_table.prp_va_prior_paid_in_full_loan_number
, staging_table.prp_note_date
, staging_table.prp_security_instrument_type
, staging_table.prp_trustee_pid
, staging_table.prp_trustee_name
, staging_table.prp_trustee_address_street1
, staging_table.prp_trustee_address_street2
, staging_table.prp_trustee_address_city
, staging_table.prp_trustee_address_state
, staging_table.prp_trustee_address_postal_code
, staging_table.prp_trustee_address_country
, staging_table.prp_trustee_mers_org_id
, staging_table.prp_trustee_phone_number
, staging_table.prp_fre_ctp_closing_feature_type
, staging_table.prp_fre_ctp_first_payment_due_date
, staging_table.prp_purchase_contract_date
, staging_table.prp_purchase_contract_financing_contingency_date
, staging_table.prp_purchase_contract_funding_date
, staging_table.prp_effective_property_value_type
, staging_table.prp_effective_property_value_amount
, staging_table.prp_decision_appraised_value_amount
, staging_table.prp_fha_va_reasonable_value_amount
, staging_table.prp_cd_clear_date
, staging_table.prp_disaster_declaration_check_date_type
, staging_table.prp_disaster_declaration_check_date
, staging_table.prp_any_disaster_declaration_before_appraisal
, staging_table.prp_any_disaster_declaration_after_appraisal
, staging_table.prp_any_disaster_declaration
, staging_table.prp_early_first_payment
, staging_table.prp_property_acquired_through_inheritance
, staging_table.prp_property_acquired_through_ancillary_relief
, staging_table.prp_delayed_financing_exception_guidelines_applicable
, staging_table.prp_delayed_financing_exception_verified
, staging_table.prp_effective_property_value_explanation_type
, staging_table.prp_taxes_escrowed
, staging_table.prp_flood_insurance_applicable
, staging_table.prp_windstorm_insurance_applicable
, staging_table.prp_earthquake_insurance_applicable
, staging_table.prp_arms_length
, staging_table.prp_fha_non_arms_length_ltv_exception_type
, staging_table.prp_fha_non_arms_length_ltv_exception_verified
, staging_table.prp_escrow_cushion_months
, staging_table.prp_escrow_cushion_months_auto_compute
, staging_table.prp_fha_eligible_maximum_financing
, staging_table.prp_hazard_insurance_applicable
, staging_table.prp_property_repairs_required_type
, staging_table.prp_property_repairs_description
, staging_table.prp_property_repairs_cost_amount
, staging_table.prp_property_repairs_holdback_calc_type
, staging_table.prp_property_repairs_holdback_amount
, staging_table.prp_property_repairs_holdback_payer_type
, staging_table.prp_property_repairs_holdback_administrator
, staging_table.prp_property_repairs_holdback_required_completion_date
, staging_table.prp_property_repairs_completed_notification_date
, staging_table.prp_property_repairs_inspection_ordered_date
, staging_table.prp_property_repairs_inspection_completed_date
, staging_table.prp_property_repairs_funds_released_contractor_date
, staging_table.prp_anti_steering_lowest_rate_option_rate_percent
, staging_table.prp_anti_steering_lowest_rate_option_fee_amount
, staging_table.prp_anti_steering_lowest_rate_wo_neg_option_rate_percent
, staging_table.prp_anti_steering_lowest_rate_wo_neg_option_fee_amount
, staging_table.prp_anti_steering_lowest_cost_option_rate_percent
, staging_table.prp_anti_steering_lowest_cost_option_fee_amount
, staging_table.prp_initial_uw_submit_datetime
, staging_table.prp_va_notice_of_value_source_type
, staging_table.prp_va_notice_of_value_date
, staging_table.prp_va_notice_of_value_estimated_reasonable_value_amount
, staging_table.prp_sar_significant_adjustments
, staging_table.prp_separate_transaction_for_land_acquisition
, staging_table.prp_land_acquisition_transaction_date
, staging_table.prp_land_acquisition_price
, staging_table.prp_cash_out_reason_home_improvement
, staging_table.prp_cash_out_reason_debt_or_debt_consolidation
, staging_table.prp_cash_out_reason_personal_use
, staging_table.prp_cash_out_reason_future_investment_not_under_contract
, staging_table.prp_cash_out_reason_future_investment_under_contract
, staging_table.prp_cash_out_reason_other
, staging_table.prp_cash_out_reason_other_text
, staging_table.prp_decision_veteran_borrower_pid
, staging_table.prp_signed_closing_doc_received_datetime
, staging_table.prp_other_lender_requires_appraisal
, staging_table.prp_other_lender_requires_appraisal_reason
, staging_table.prp_texas_equity_determination_datetime
, staging_table.prp_texas_equity_conversion_determination_datetime
, staging_table.prp_texas_equity_determination_datetime_override
, staging_table.prp_texas_equity_determination_datetime_override_reason
, staging_table.prp_texas_equity_conversion_determination_datetime_override
, staging_table.prp_texas_equity_conversion_determ_datetime_override_reason
, staging_table.prp_cema
, staging_table.prp_cema_borrower_savings
, staging_table.prp_any_vesting_changes
, staging_table.prp_vesting_change_titleholder_added
, staging_table.prp_vesting_change_titleholder_removed
, staging_table.prp_vesting_change_titleholder_name_change
, staging_table.prp_deed_taxes_applicable
, staging_table.prp_deed_taxes_applicable_explanation
, staging_table.prp_deed_taxes_auto_compute
, staging_table.prp_deed_taxes_auto_compute_override_reason
, staging_table.prp_intent_to_proceed_date
, staging_table.prp_intent_to_proceed_type
, staging_table.prp_intent_to_proceed_provider_unparsed_name
, staging_table.prp_intent_to_proceed_obtainer_unparsed_name
, staging_table.prp_cash_out_reason_student_loans
, staging_table.prp_household_income_exclusive_edit
, staging_table.prp_purchase_contract_received_date
, staging_table.prp_down_payment_percent_mode
, staging_table.prp_lender_escrow_loan_amount
, staging_table.prp_underwrite_disposition_note
, staging_table.prp_rescission_applicable
, staging_table.prp_area_median_income
, staging_table.prp_total_income_to_ami_ratio
, staging_table.prp_cr_tracker_url
, staging_table.prp_construction_borrower_contribution_amount
, staging_table.prp_construction_lot_ownership_status_type
, staging_table.prp_intent_to_proceed_provided
, staging_table.prp_effective_signing_location_state
, staging_table.prp_effective_signing_location_city
, staging_table.prp_va_required_guaranty_amount
, staging_table.prp_va_amount_used_to_calculate_maximum_guaranty
, staging_table.prp_va_actual_guaranty_amount
, staging_table.prp_last_corrective_disclosure_processed_datetime
, staging_table.prp_user_entered_note_date
, staging_table.prp_effective_note_date
, staging_table.prp_lender_escrow_loan_due_date
, staging_table.prp_va_maximum_base_loan_amount
, staging_table.prp_va_maximum_funding_fee_amount
, staging_table.prp_va_maximum_total_loan_amount
, staging_table.prp_va_required_cash_amount
, staging_table.prp_va_guaranty_percent
, staging_table.prp_gse_version_type
, staging_table.prp_minimum_household_income_amount
, staging_table.prp_minimum_residual_income_amount
, staging_table.prp_minimum_residual_income_auto_compute
, staging_table.prp_financed_property_improvements_category_type
, staging_table.prp_adjusted_as_is_value_amount
, staging_table.prp_after_improved_value_amount
, staging_table.prp_disclosure_action_type
, staging_table.prp_hud_consultant
, staging_table.prp_initial_uw_disposition_datetime
, staging_table.prp_preapproval_uw_submit_datetime
, staging_table.prp_preapproval_uw_disposition_datetime
, staging_table.prp_down_payment_percent
, staging_table.prp_cash_out_reason_investment_or_business_property
, staging_table.prp_cash_out_reason_business_debt_or_debt_consolidation
, staging_table.prp_non_business_cash_out_reason_acknowledged
, FALSE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal staging_table
LEFT JOIN history_octane.proposal history_table
          ON staging_table.prp_pid = history_table.prp_pid AND staging_table.prp_version = history_table.prp_version
WHERE history_table.prp_pid IS NULL
UNION ALL
SELECT history_table.prp_estimated_hard_construction_cost_amount
, history_table.prp_financed_property_improvements
, history_table.prp_pid
, history_table.prp_version + 1
, history_table.prp_decision_lp_request_pid
, history_table.prp_decision_du_request_pid
, history_table.prp_proposal_type
, history_table.prp_description
, history_table.prp_doc_level_type
, history_table.prp_loan_purpose_type
, history_table.prp_name
, history_table.prp_create_datetime
, history_table.prp_effective_funding_date
, history_table.prp_estimated_funding_date
, history_table.prp_calculated_earliest_allowed_consummation_date
, history_table.prp_overridden_earliest_allowed_consummation_date
, history_table.prp_effective_earliest_allowed_consummation_date
, history_table.prp_earliest_allowed_consummation_date_override_reason
, history_table.prp_last_requested_disclosure_date
, history_table.prp_closing_document_sign_datetime
, history_table.prp_scheduled_closing_document_sign_datetime
, history_table.prp_rescission_through_date
, history_table.prp_rescission_notification_date
, history_table.prp_rescission_notification_by
, history_table.prp_rescission_notification_type
, history_table.prp_rescission_effective_date
, history_table.prp_first_payment_date
, history_table.prp_first_payment_date_auto_compute
, history_table.prp_property_usage_type
, history_table.prp_estimated_property_value_amount
, history_table.prp_smart_charges_enabled
, history_table.prp_charges_updated_datetime
, history_table.prp_smart_docs_enabled
, history_table.prp_docs_enabled_datetime
, history_table.prp_request_fha_mip_refund_required
, history_table.prp_request_recording_fees_required
, history_table.prp_request_property_taxes_required
, history_table.prp_property_tax_request_error_messages
, history_table.prp_fha_mip_refund_request_input_error
, history_table.prp_recording_fees_request_input_error
, history_table.prp_property_taxes_request_input_error
, history_table.prp_publish
, history_table.prp_publish_date
, history_table.prp_ipc_auto_compute
, history_table.prp_ipc_limit_percent
, history_table.prp_ipc_maximum_amount_allowed
, history_table.prp_ipc_amount
, history_table.prp_ipc_percent
, history_table.prp_ipc_financing_concession_amount
, history_table.prp_ipc_non_cash_concession_amount
, history_table.prp_sale_price_amount
, history_table.prp_structure_type
, history_table.prp_deal_pid
, history_table.prp_gfe_interest_rate_expiration_date
, history_table.prp_gfe_lock_duration_days
, history_table.prp_gfe_lock_before_settlement_days
, history_table.prp_proposal_expiration_date
, history_table.prp_uuts_master_contact_name
, history_table.prp_uuts_master_contact_title
, history_table.prp_uuts_master_office_phone
, history_table.prp_uuts_master_office_phone_extension
, history_table.prp_underwrite_risk_assessment_type
, history_table.prp_underwriting_comments
, history_table.prp_reserves_auto_compute
, history_table.prp_reserves_amount
, history_table.prp_reserves_months
, history_table.prp_underwrite_disposition_type
, history_table.prp_underwrite_publish_date
, history_table.prp_underwrite_expiration_date
, history_table.prp_usda_gsa_sam_exclusion
, history_table.prp_usda_gsa_sam_checked_date
, history_table.prp_usda_rd_single_family_housing_type
, history_table.prp_underwrite_method_type
, history_table.prp_mi_required
, history_table.prp_decision_credit_score_borrower_pid
, history_table.prp_decision_credit_score
, history_table.prp_estimated_credit_score
, history_table.prp_effective_credit_score
, history_table.prp_mortgagee_builder_seller_relationship
, history_table.prp_fha_prior_agency_case_id
, history_table.prp_fha_prior_agency_case_endorsement_date
, history_table.prp_fha_refinance_authorization_number
, history_table.prp_fha_refinance_authorization_expiration_date
, history_table.prp_fhac_refinance_authorization_messages
, history_table.prp_hud_fha_de_approval_type
, history_table.prp_owner_occupancy_not_required
, history_table.prp_va_monthly_utilities_included
, history_table.prp_va_maintenance_utilities_auto_compute
, history_table.prp_va_monthly_maintenance_utilities_amount
, history_table.prp_va_maintenance_utilities_per_square_feet_amount
, history_table.prp_household_size_count
, history_table.prp_va_past_credit_record_type
, history_table.prp_va_meets_credit_standards
, history_table.prp_va_prior_paid_in_full_loan_number
, history_table.prp_note_date
, history_table.prp_security_instrument_type
, history_table.prp_trustee_pid
, history_table.prp_trustee_name
, history_table.prp_trustee_address_street1
, history_table.prp_trustee_address_street2
, history_table.prp_trustee_address_city
, history_table.prp_trustee_address_state
, history_table.prp_trustee_address_postal_code
, history_table.prp_trustee_address_country
, history_table.prp_trustee_mers_org_id
, history_table.prp_trustee_phone_number
, history_table.prp_fre_ctp_closing_feature_type
, history_table.prp_fre_ctp_first_payment_due_date
, history_table.prp_purchase_contract_date
, history_table.prp_purchase_contract_financing_contingency_date
, history_table.prp_purchase_contract_funding_date
, history_table.prp_effective_property_value_type
, history_table.prp_effective_property_value_amount
, history_table.prp_decision_appraised_value_amount
, history_table.prp_fha_va_reasonable_value_amount
, history_table.prp_cd_clear_date
, history_table.prp_disaster_declaration_check_date_type
, history_table.prp_disaster_declaration_check_date
, history_table.prp_any_disaster_declaration_before_appraisal
, history_table.prp_any_disaster_declaration_after_appraisal
, history_table.prp_any_disaster_declaration
, history_table.prp_early_first_payment
, history_table.prp_property_acquired_through_inheritance
, history_table.prp_property_acquired_through_ancillary_relief
, history_table.prp_delayed_financing_exception_guidelines_applicable
, history_table.prp_delayed_financing_exception_verified
, history_table.prp_effective_property_value_explanation_type
, history_table.prp_taxes_escrowed
, history_table.prp_flood_insurance_applicable
, history_table.prp_windstorm_insurance_applicable
, history_table.prp_earthquake_insurance_applicable
, history_table.prp_arms_length
, history_table.prp_fha_non_arms_length_ltv_exception_type
, history_table.prp_fha_non_arms_length_ltv_exception_verified
, history_table.prp_escrow_cushion_months
, history_table.prp_escrow_cushion_months_auto_compute
, history_table.prp_fha_eligible_maximum_financing
, history_table.prp_hazard_insurance_applicable
, history_table.prp_property_repairs_required_type
, history_table.prp_property_repairs_description
, history_table.prp_property_repairs_cost_amount
, history_table.prp_property_repairs_holdback_calc_type
, history_table.prp_property_repairs_holdback_amount
, history_table.prp_property_repairs_holdback_payer_type
, history_table.prp_property_repairs_holdback_administrator
, history_table.prp_property_repairs_holdback_required_completion_date
, history_table.prp_property_repairs_completed_notification_date
, history_table.prp_property_repairs_inspection_ordered_date
, history_table.prp_property_repairs_inspection_completed_date
, history_table.prp_property_repairs_funds_released_contractor_date
, history_table.prp_anti_steering_lowest_rate_option_rate_percent
, history_table.prp_anti_steering_lowest_rate_option_fee_amount
, history_table.prp_anti_steering_lowest_rate_wo_neg_option_rate_percent
, history_table.prp_anti_steering_lowest_rate_wo_neg_option_fee_amount
, history_table.prp_anti_steering_lowest_cost_option_rate_percent
, history_table.prp_anti_steering_lowest_cost_option_fee_amount
, history_table.prp_initial_uw_submit_datetime
, history_table.prp_va_notice_of_value_source_type
, history_table.prp_va_notice_of_value_date
, history_table.prp_va_notice_of_value_estimated_reasonable_value_amount
, history_table.prp_sar_significant_adjustments
, history_table.prp_separate_transaction_for_land_acquisition
, history_table.prp_land_acquisition_transaction_date
, history_table.prp_land_acquisition_price
, history_table.prp_cash_out_reason_home_improvement
, history_table.prp_cash_out_reason_debt_or_debt_consolidation
, history_table.prp_cash_out_reason_personal_use
, history_table.prp_cash_out_reason_future_investment_not_under_contract
, history_table.prp_cash_out_reason_future_investment_under_contract
, history_table.prp_cash_out_reason_other
, history_table.prp_cash_out_reason_other_text
, history_table.prp_decision_veteran_borrower_pid
, history_table.prp_signed_closing_doc_received_datetime
, history_table.prp_other_lender_requires_appraisal
, history_table.prp_other_lender_requires_appraisal_reason
, history_table.prp_texas_equity_determination_datetime
, history_table.prp_texas_equity_conversion_determination_datetime
, history_table.prp_texas_equity_determination_datetime_override
, history_table.prp_texas_equity_determination_datetime_override_reason
, history_table.prp_texas_equity_conversion_determination_datetime_override
, history_table.prp_texas_equity_conversion_determ_datetime_override_reason
, history_table.prp_cema
, history_table.prp_cema_borrower_savings
, history_table.prp_any_vesting_changes
, history_table.prp_vesting_change_titleholder_added
, history_table.prp_vesting_change_titleholder_removed
, history_table.prp_vesting_change_titleholder_name_change
, history_table.prp_deed_taxes_applicable
, history_table.prp_deed_taxes_applicable_explanation
, history_table.prp_deed_taxes_auto_compute
, history_table.prp_deed_taxes_auto_compute_override_reason
, history_table.prp_intent_to_proceed_date
, history_table.prp_intent_to_proceed_type
, history_table.prp_intent_to_proceed_provider_unparsed_name
, history_table.prp_intent_to_proceed_obtainer_unparsed_name
, history_table.prp_cash_out_reason_student_loans
, history_table.prp_household_income_exclusive_edit
, history_table.prp_purchase_contract_received_date
, history_table.prp_down_payment_percent_mode
, history_table.prp_lender_escrow_loan_amount
, history_table.prp_underwrite_disposition_note
, history_table.prp_rescission_applicable
, history_table.prp_area_median_income
, history_table.prp_total_income_to_ami_ratio
, history_table.prp_cr_tracker_url
, history_table.prp_construction_borrower_contribution_amount
, history_table.prp_construction_lot_ownership_status_type
, history_table.prp_intent_to_proceed_provided
, history_table.prp_effective_signing_location_state
, history_table.prp_effective_signing_location_city
, history_table.prp_va_required_guaranty_amount
, history_table.prp_va_amount_used_to_calculate_maximum_guaranty
, history_table.prp_va_actual_guaranty_amount
, history_table.prp_last_corrective_disclosure_processed_datetime
, history_table.prp_user_entered_note_date
, history_table.prp_effective_note_date
, history_table.prp_lender_escrow_loan_due_date
, history_table.prp_va_maximum_base_loan_amount
, history_table.prp_va_maximum_funding_fee_amount
, history_table.prp_va_maximum_total_loan_amount
, history_table.prp_va_required_cash_amount
, history_table.prp_va_guaranty_percent
, history_table.prp_gse_version_type
, history_table.prp_minimum_household_income_amount
, history_table.prp_minimum_residual_income_amount
, history_table.prp_minimum_residual_income_auto_compute
, history_table.prp_financed_property_improvements_category_type
, history_table.prp_adjusted_as_is_value_amount
, history_table.prp_after_improved_value_amount
, history_table.prp_disclosure_action_type
, history_table.prp_hud_consultant
, history_table.prp_initial_uw_disposition_datetime
, history_table.prp_preapproval_uw_submit_datetime
, history_table.prp_preapproval_uw_disposition_datetime
, history_table.prp_down_payment_percent
, history_table.prp_cash_out_reason_investment_or_business_property
, history_table.prp_cash_out_reason_business_debt_or_debt_consolidation
, history_table.prp_non_business_cash_out_reason_acknowledged
, TRUE AS data_source_deleted_flag
, NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal history_table
LEFT JOIN staging_octane.proposal staging_table
          ON staging_table.prp_pid = history_table.prp_pid
WHERE staging_table.prp_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.proposal deleted_records
                  WHERE deleted_records.prp_pid = history_table.prp_pid
                    AND deleted_records.data_source_deleted_flag = TRUE);')
)

, updated_table_input_step AS (
    UPDATE mdi.table_input_step
        SET sql = updated_table_input_sql.sql
        FROM updated_table_input_sql
            , mdi.table_output_step
        WHERE table_input_step.process_dwid = table_output_step.process_dwid
            AND table_output_step.target_schema = 'history_octane'
            AND table_output_step.target_table = updated_table_input_sql.table_name
)

SELECT 'Finished inserting metadata for new columns: branch.br_location_pid, branch_license.brml_company_pid
    , branch_license.brml_location_pid, deal.d_license_location_pid, borrower_declarations.bdec_intend_to_occupy_more_than_14_days
    , proposal.prp_cash_out_reason_investment_or_business_property, proposal.prp_cash_out_reason_business_debt_or_debt_consolidation
    , proposal.prp_non_business_cash_out_reason_acknowledged, loan_hedge.lh_qualified_mortgage_status_type';
