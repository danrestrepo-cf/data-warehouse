--
-- EDW | star_loan - incorporate new lender_user fields into dimension tables
-- https://app.asana.com/0/0/1201360578080569
--

/*
INSERTIONS
*/

--edw_field_definition
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'star_loan', 'lender_user_dim', 'marketing_details_enabled', 'BOOLEAN', 'staging', 'history_octane', 'lender_user', 'lu_marketing_details_enabled')
         , ('staging', 'star_loan', 'lender_user_dim', 'marketing_details_featured_review', 'VARCHAR(1024)', 'staging', 'history_octane', 'lender_user', 'lu_marketing_details_featured_review')
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

--insert_update_field
WITH insert_rows (process_name, update_lookup, update_flag) AS (
    VALUES ('ETL-200010', 'marketing_details_enabled', 'Y')
         , ('ETL-200010', 'marketing_details_featured_review', 'Y')
)
INSERT
INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)
SELECT insert_update_step.dwid, insert_rows.update_lookup, insert_rows.update_lookup, insert_rows.update_flag::mdi.pentaho_y_or_n, FALSE
FROM insert_rows
         JOIN mdi.process
              ON process.name = insert_rows.process_name
         JOIN mdi.insert_update_step
              ON process.dwid = insert_update_step.process_dwid;


/*
UPDATES
*/

--table_input_step
WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('ETL-200010', 1, 'WITH lender_user_dim_incl_new_records AS (
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
         , primary_table.lu_marketing_details_enabled as marketing_details_enabled
         , primary_table.lu_marketing_details_featured_review as marketing_details_featured_review
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