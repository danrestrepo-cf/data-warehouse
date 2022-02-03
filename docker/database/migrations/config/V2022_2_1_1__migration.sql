--
-- EDW | star_loan: Remove column lender_user_dim.work_step_start_notices_enabled_flag
-- https://app.asana.com/0/0/1201753612968906
--

/*
UPDATES
*/

--table_input_step
WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-200010', 1, 'WITH lender_user_dim_incl_new_records AS (
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
         , primary_table.lu_esign_only AS esign_only_flag
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

/*
DELETIONS
*/

--insert_update_field
WITH delete_keys (process_name, update_lookup) AS (
    VALUES ('SP-200010', 'work_step_start_notices_enabled_flag')
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
    VALUES ('staging', 'star_loan', 'lender_user_dim', 'work_step_start_notices_enabled_flag')
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
-- Main | EDW | Octane schemas from prod-release to v2022.2.1.0 on uat
-- https://app.asana.com/0/0/1201745462160447
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'staging_octane', 'qm_points_and_fees_thresholds', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_rate_spread_thresholds', NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'qm_points_and_fees_thresholds', 'staging', 'staging_octane', 'qm_points_and_fees_thresholds')
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'staging', 'staging_octane', 'qm_rate_spread_thresholds')
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
    VALUES ('staging', 'history_octane', 'qm_points_and_fees_thresholds', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'qm_points_and_fees_thresholds', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'qm_points_and_fees_thresholds', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_ceiling_points_and_fees_threshold_percent', 'NUMERIC(11,9)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_effective_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_first_points_and_fees_threshold_percent', 'NUMERIC(11,9)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_first_total_loan_amount_threshold', 'NUMERIC(15,0)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_fourth_points_and_fees_threshold_amount', 'NUMERIC(15,0)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_fourth_total_loan_amount_threshold', 'NUMERIC(15,0)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_second_points_and_fees_threshold_amount', 'NUMERIC(15,0)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_second_total_loan_amount_threshold', 'NUMERIC(15,0)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_third_points_and_fees_threshold_percent', 'NUMERIC(11,9)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_third_total_loan_amount_threshold', 'NUMERIC(15,0)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_effective_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_high_loan_amount_threshold', 'NUMERIC(15,0)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_low_loan_amount_threshold', 'NUMERIC(15,0)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_manufactured_loan_amount_threshold', 'NUMERIC(15,0)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_manufactured_max_rate_spread_over_threshold', 'NUMERIC(11,9)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_manufactured_max_rate_spread_under_threshold', 'NUMERIC(11,9)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_max_rate_spread_over_high_threshold', 'NUMERIC(11,9)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_max_rate_spread_under_high_over_low_threshold', 'NUMERIC(11,9)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_max_rate_spread_under_low_threshold', 'NUMERIC(11,9)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_subordinate_lien_loan_amount_threshold', 'NUMERIC(15,0)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_subordinate_lien_max_rate_spread_over_threshold', 'NUMERIC(11,9)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_subordinate_lien_max_rate_spread_under_threshold', 'NUMERIC(11,9)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc', 'sd_document_explanation', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc', 'sd_document_explanation_reference', 'VARCHAR(2048)', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'qm_points_and_fees_thresholds', 'qmpaft_ceiling_points_and_fees_threshold_percent', 'NUMERIC(11,9)', 'staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_ceiling_points_and_fees_threshold_percent')
         , ('staging', 'history_octane', 'qm_points_and_fees_thresholds', 'qmpaft_effective_date', 'DATE', 'staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_effective_date')
         , ('staging', 'history_octane', 'qm_points_and_fees_thresholds', 'qmpaft_first_points_and_fees_threshold_percent', 'NUMERIC(11,9)', 'staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_first_points_and_fees_threshold_percent')
         , ('staging', 'history_octane', 'qm_points_and_fees_thresholds', 'qmpaft_first_total_loan_amount_threshold', 'NUMERIC(15,0)', 'staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_first_total_loan_amount_threshold')
         , ('staging', 'history_octane', 'qm_points_and_fees_thresholds', 'qmpaft_fourth_points_and_fees_threshold_amount', 'NUMERIC(15,0)', 'staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_fourth_points_and_fees_threshold_amount')
         , ('staging', 'history_octane', 'qm_points_and_fees_thresholds', 'qmpaft_fourth_total_loan_amount_threshold', 'NUMERIC(15,0)', 'staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_fourth_total_loan_amount_threshold')
         , ('staging', 'history_octane', 'qm_points_and_fees_thresholds', 'qmpaft_pid', 'BIGINT', 'staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_pid')
         , ('staging', 'history_octane', 'qm_points_and_fees_thresholds', 'qmpaft_second_points_and_fees_threshold_amount', 'NUMERIC(15,0)', 'staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_second_points_and_fees_threshold_amount')
         , ('staging', 'history_octane', 'qm_points_and_fees_thresholds', 'qmpaft_second_total_loan_amount_threshold', 'NUMERIC(15,0)', 'staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_second_total_loan_amount_threshold')
         , ('staging', 'history_octane', 'qm_points_and_fees_thresholds', 'qmpaft_third_points_and_fees_threshold_percent', 'NUMERIC(11,9)', 'staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_third_points_and_fees_threshold_percent')
         , ('staging', 'history_octane', 'qm_points_and_fees_thresholds', 'qmpaft_third_total_loan_amount_threshold', 'NUMERIC(15,0)', 'staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_third_total_loan_amount_threshold')
         , ('staging', 'history_octane', 'qm_points_and_fees_thresholds', 'qmpaft_version', 'INTEGER', 'staging', 'staging_octane', 'qm_points_and_fees_thresholds', 'qmpaft_version')
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'qmrst_effective_date', 'DATE', 'staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_effective_date')
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_high_loan_amount_threshold', 'NUMERIC(15,0)', 'staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_high_loan_amount_threshold')
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_low_loan_amount_threshold', 'NUMERIC(15,0)', 'staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_low_loan_amount_threshold')
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_manufactured_loan_amount_threshold', 'NUMERIC(15,0)', 'staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_manufactured_loan_amount_threshold')
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_manufactured_max_rate_spread_over_threshold', 'NUMERIC(11,9)', 'staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_manufactured_max_rate_spread_over_threshold')
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_manufactured_max_rate_spread_under_threshold', 'NUMERIC(11,9)', 'staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_manufactured_max_rate_spread_under_threshold')
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_max_rate_spread_over_high_threshold', 'NUMERIC(11,9)', 'staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_max_rate_spread_over_high_threshold')
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_max_rate_spread_under_high_over_low_threshold', 'NUMERIC(11,9)', 'staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_max_rate_spread_under_high_over_low_threshold')
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_max_rate_spread_under_low_threshold', 'NUMERIC(11,9)', 'staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_first_lien_max_rate_spread_under_low_threshold')
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'qmrst_pid', 'BIGINT', 'staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_pid')
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'qmrst_subordinate_lien_loan_amount_threshold', 'NUMERIC(15,0)', 'staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_subordinate_lien_loan_amount_threshold')
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'qmrst_subordinate_lien_max_rate_spread_over_threshold', 'NUMERIC(11,9)', 'staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_subordinate_lien_max_rate_spread_over_threshold')
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'qmrst_subordinate_lien_max_rate_spread_under_threshold', 'NUMERIC(11,9)', 'staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_subordinate_lien_max_rate_spread_under_threshold')
         , ('staging', 'history_octane', 'qm_rate_spread_thresholds', 'qmrst_version', 'INTEGER', 'staging', 'staging_octane', 'qm_rate_spread_thresholds', 'qmrst_version')
         , ('staging', 'history_octane', 'smart_doc', 'sd_document_explanation', 'VARCHAR(1024)', 'staging', 'staging_octane', 'smart_doc', 'sd_document_explanation')
         , ('staging', 'history_octane', 'smart_doc', 'sd_document_explanation_reference', 'VARCHAR(2048)', 'staging', 'staging_octane', 'smart_doc', 'sd_document_explanation_reference')
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
VALUES ('SP-100895', 'ETL to copy qm_points_and_fees_thresholds data from staging_octane to history_octane')
     , ('SP-100896', 'ETL to copy qm_rate_spread_thresholds data from staging_octane to history_octane');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100895', 0, '--finding records to insert into history_octane.qm_points_and_fees_thresholds
SELECT staging_table.qmpaft_pid
     , staging_table.qmpaft_version
     , staging_table.qmpaft_effective_date
     , staging_table.qmpaft_first_total_loan_amount_threshold
     , staging_table.qmpaft_first_points_and_fees_threshold_percent
     , staging_table.qmpaft_second_total_loan_amount_threshold
     , staging_table.qmpaft_second_points_and_fees_threshold_amount
     , staging_table.qmpaft_third_total_loan_amount_threshold
     , staging_table.qmpaft_third_points_and_fees_threshold_percent
     , staging_table.qmpaft_fourth_total_loan_amount_threshold
     , staging_table.qmpaft_fourth_points_and_fees_threshold_amount
     , staging_table.qmpaft_ceiling_points_and_fees_threshold_percent
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.qm_points_and_fees_thresholds staging_table
LEFT JOIN history_octane.qm_points_and_fees_thresholds history_table
          ON staging_table.qmpaft_pid = history_table.qmpaft_pid
              AND staging_table.qmpaft_version = history_table.qmpaft_version
WHERE history_table.qmpaft_pid IS NULL
UNION ALL
SELECT history_table.qmpaft_pid
     , history_table.qmpaft_version + 1
     , history_table.qmpaft_effective_date
     , history_table.qmpaft_first_total_loan_amount_threshold
     , history_table.qmpaft_first_points_and_fees_threshold_percent
     , history_table.qmpaft_second_total_loan_amount_threshold
     , history_table.qmpaft_second_points_and_fees_threshold_amount
     , history_table.qmpaft_third_total_loan_amount_threshold
     , history_table.qmpaft_third_points_and_fees_threshold_percent
     , history_table.qmpaft_fourth_total_loan_amount_threshold
     , history_table.qmpaft_fourth_points_and_fees_threshold_amount
     , history_table.qmpaft_ceiling_points_and_fees_threshold_percent
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.qm_points_and_fees_thresholds history_table
LEFT JOIN staging_octane.qm_points_and_fees_thresholds staging_table
          ON staging_table.qmpaft_pid = history_table.qmpaft_pid
WHERE staging_table.qmpaft_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.qm_points_and_fees_thresholds deleted_records
    WHERE deleted_records.qmpaft_pid = history_table.qmpaft_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100896', 0, '--finding records to insert into history_octane.qm_rate_spread_thresholds
SELECT staging_table.qmrst_pid
     , staging_table.qmrst_version
     , staging_table.qmrst_effective_date
     , staging_table.qmrst_first_lien_manufactured_loan_amount_threshold
     , staging_table.qmrst_first_lien_manufactured_max_rate_spread_over_threshold
     , staging_table.qmrst_first_lien_manufactured_max_rate_spread_under_threshold
     , staging_table.qmrst_first_lien_high_loan_amount_threshold
     , staging_table.qmrst_first_lien_low_loan_amount_threshold
     , staging_table.qmrst_first_lien_max_rate_spread_over_high_threshold
     , staging_table.qmrst_first_lien_max_rate_spread_under_high_over_low_threshold
     , staging_table.qmrst_first_lien_max_rate_spread_under_low_threshold
     , staging_table.qmrst_subordinate_lien_loan_amount_threshold
     , staging_table.qmrst_subordinate_lien_max_rate_spread_over_threshold
     , staging_table.qmrst_subordinate_lien_max_rate_spread_under_threshold
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.qm_rate_spread_thresholds staging_table
LEFT JOIN history_octane.qm_rate_spread_thresholds history_table
          ON staging_table.qmrst_pid = history_table.qmrst_pid
              AND staging_table.qmrst_version = history_table.qmrst_version
WHERE history_table.qmrst_pid IS NULL
UNION ALL
SELECT history_table.qmrst_pid
     , history_table.qmrst_version + 1
     , history_table.qmrst_effective_date
     , history_table.qmrst_first_lien_manufactured_loan_amount_threshold
     , history_table.qmrst_first_lien_manufactured_max_rate_spread_over_threshold
     , history_table.qmrst_first_lien_manufactured_max_rate_spread_under_threshold
     , history_table.qmrst_first_lien_high_loan_amount_threshold
     , history_table.qmrst_first_lien_low_loan_amount_threshold
     , history_table.qmrst_first_lien_max_rate_spread_over_high_threshold
     , history_table.qmrst_first_lien_max_rate_spread_under_high_over_low_threshold
     , history_table.qmrst_first_lien_max_rate_spread_under_low_threshold
     , history_table.qmrst_subordinate_lien_loan_amount_threshold
     , history_table.qmrst_subordinate_lien_max_rate_spread_over_threshold
     , history_table.qmrst_subordinate_lien_max_rate_spread_under_threshold
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.qm_rate_spread_thresholds history_table
LEFT JOIN staging_octane.qm_rate_spread_thresholds staging_table
          ON staging_table.qmrst_pid = history_table.qmrst_pid
WHERE staging_table.qmrst_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.qm_rate_spread_thresholds deleted_records
    WHERE deleted_records.qmrst_pid = history_table.qmrst_pid
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
    VALUES ('SP-100895', 'history_octane', 'qm_points_and_fees_thresholds', 'N', 'Staging DB Connection')
         , ('SP-100896', 'history_octane', 'qm_rate_spread_thresholds', 'N', 'Staging DB Connection')
)
INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT process.dwid, insert_rows.target_schema, insert_rows.target_table, 1000, NULL, NULL, NULL, NULL, 'N', NULL, insert_rows.truncate_table::mdi.pentaho_y_or_n, insert_rows.connectionname, 'N', 'Y', 'N', 'N'
FROM insert_rows
         JOIN mdi.process
              ON process.name = insert_rows.process_name;

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('SP-100895', 'data_source_deleted_flag')
         , ('SP-100895', 'data_source_updated_datetime')
         , ('SP-100895', 'etl_batch_id')
         , ('SP-100895', 'qmpaft_ceiling_points_and_fees_threshold_percent')
         , ('SP-100895', 'qmpaft_effective_date')
         , ('SP-100895', 'qmpaft_first_points_and_fees_threshold_percent')
         , ('SP-100895', 'qmpaft_first_total_loan_amount_threshold')
         , ('SP-100895', 'qmpaft_fourth_points_and_fees_threshold_amount')
         , ('SP-100895', 'qmpaft_fourth_total_loan_amount_threshold')
         , ('SP-100895', 'qmpaft_pid')
         , ('SP-100895', 'qmpaft_second_points_and_fees_threshold_amount')
         , ('SP-100895', 'qmpaft_second_total_loan_amount_threshold')
         , ('SP-100895', 'qmpaft_third_points_and_fees_threshold_percent')
         , ('SP-100895', 'qmpaft_third_total_loan_amount_threshold')
         , ('SP-100895', 'qmpaft_version')
         , ('SP-100896', 'data_source_deleted_flag')
         , ('SP-100896', 'data_source_updated_datetime')
         , ('SP-100896', 'etl_batch_id')
         , ('SP-100896', 'qmrst_effective_date')
         , ('SP-100896', 'qmrst_first_lien_high_loan_amount_threshold')
         , ('SP-100896', 'qmrst_first_lien_low_loan_amount_threshold')
         , ('SP-100896', 'qmrst_first_lien_manufactured_loan_amount_threshold')
         , ('SP-100896', 'qmrst_first_lien_manufactured_max_rate_spread_over_threshold')
         , ('SP-100896', 'qmrst_first_lien_manufactured_max_rate_spread_under_threshold')
         , ('SP-100896', 'qmrst_first_lien_max_rate_spread_over_high_threshold')
         , ('SP-100896', 'qmrst_first_lien_max_rate_spread_under_high_over_low_threshold')
         , ('SP-100896', 'qmrst_first_lien_max_rate_spread_under_low_threshold')
         , ('SP-100896', 'qmrst_pid')
         , ('SP-100896', 'qmrst_subordinate_lien_loan_amount_threshold')
         , ('SP-100896', 'qmrst_subordinate_lien_max_rate_spread_over_threshold')
         , ('SP-100896', 'qmrst_subordinate_lien_max_rate_spread_under_threshold')
         , ('SP-100896', 'qmrst_version')
         , ('SP-100333', 'sd_document_explanation')
         , ('SP-100333', 'sd_document_explanation_reference')
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
    VALUES ('SP-100895', 'qmpaft_pid')
         , ('SP-100896', 'qmrst_pid')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
         JOIN mdi.process
              ON insert_rows.process_name = process.name;

--state_machine_definition
WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-100895', 'SP-100895', 'ETL to copy qm_points_and_fees_thresholds data from staging_octane to history_octane')
         , ('SP-100896', 'SP-100896', 'ETL to copy qm_rate_spread_thresholds data from staging_octane to history_octane')
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
    VALUES ('staging', 'history_octane', 'lender_user', 'lu_work_step_start_notices_enabled', 'BOOLEAN', NULL, NULL, NULL, NULL)
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
    VALUES ('SP-100090', 0, '--finding records to insert into history_octane.lender_user
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
     , staging_table.lu_esign_only
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
     , history_table.lu_esign_only
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
         , ('SP-100333', 0, '--finding records to insert into history_octane.smart_doc
SELECT staging_table.sd_pid
     , staging_table.sd_version
     , staging_table.sd_account_pid
     , staging_table.sd_doc_set_type
     , staging_table.sd_custom_form_pid
     , staging_table.sd_doc_name
     , staging_table.sd_doc_number
     , staging_table.sd_doc_category_type
     , staging_table.sd_doc_file_source_type
     , staging_table.sd_doc_external_provider_type
     , staging_table.sd_broker_applicable_provider
     , staging_table.sd_action_entities_from_merge_field
     , staging_table.sd_action_entity_applicant
     , staging_table.sd_action_entity_non_applicant
     , staging_table.sd_action_entity_underwriter
     , staging_table.sd_action_entity_originator
     , staging_table.sd_doc_borrower_access_mode_type
     , staging_table.sd_borrower_explanation
     , staging_table.sd_deal_child_type
     , staging_table.sd_doc_fulfill_status_type_default
     , staging_table.sd_prior_to_type
     , staging_table.sd_doc_action_type
     , staging_table.sd_e_delivery
     , staging_table.sd_active
     , staging_table.sd_key_doc_type
     , staging_table.sd_key_doc_include_file
     , staging_table.sd_doc_approval_type
     , staging_table.sd_auto_approve
     , staging_table.sd_auto_include_on_request
     , staging_table.sd_poa_applicable
     , staging_table.sd_action_entity_hud_va_lender_officer
     , staging_table.sd_action_entity_collateral_underwriter
     , staging_table.sd_action_entity_wholesale_client_advocate
     , staging_table.sd_action_entity_correspondent_client_advocate
     , staging_table.sd_action_entity_government_insurance
     , staging_table.sd_action_entity_underwriting_manager
     , staging_table.sd_action_entity_effective_collateral_underwriter
     , staging_table.sd_document_explanation
     , staging_table.sd_document_explanation_reference
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_doc staging_table
LEFT JOIN history_octane.smart_doc history_table
          ON staging_table.sd_pid = history_table.sd_pid
              AND staging_table.sd_version = history_table.sd_version
WHERE history_table.sd_pid IS NULL
UNION ALL
SELECT history_table.sd_pid
     , history_table.sd_version + 1
     , history_table.sd_account_pid
     , history_table.sd_doc_set_type
     , history_table.sd_custom_form_pid
     , history_table.sd_doc_name
     , history_table.sd_doc_number
     , history_table.sd_doc_category_type
     , history_table.sd_doc_file_source_type
     , history_table.sd_doc_external_provider_type
     , history_table.sd_broker_applicable_provider
     , history_table.sd_action_entities_from_merge_field
     , history_table.sd_action_entity_applicant
     , history_table.sd_action_entity_non_applicant
     , history_table.sd_action_entity_underwriter
     , history_table.sd_action_entity_originator
     , history_table.sd_doc_borrower_access_mode_type
     , history_table.sd_borrower_explanation
     , history_table.sd_deal_child_type
     , history_table.sd_doc_fulfill_status_type_default
     , history_table.sd_prior_to_type
     , history_table.sd_doc_action_type
     , history_table.sd_e_delivery
     , history_table.sd_active
     , history_table.sd_key_doc_type
     , history_table.sd_key_doc_include_file
     , history_table.sd_doc_approval_type
     , history_table.sd_auto_approve
     , history_table.sd_auto_include_on_request
     , history_table.sd_poa_applicable
     , history_table.sd_action_entity_hud_va_lender_officer
     , history_table.sd_action_entity_collateral_underwriter
     , history_table.sd_action_entity_wholesale_client_advocate
     , history_table.sd_action_entity_correspondent_client_advocate
     , history_table.sd_action_entity_government_insurance
     , history_table.sd_action_entity_underwriting_manager
     , history_table.sd_action_entity_effective_collateral_underwriter
     , history_table.sd_document_explanation
     , history_table.sd_document_explanation_reference
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.smart_doc history_table
LEFT JOIN staging_octane.smart_doc staging_table
          ON staging_table.sd_pid = history_table.sd_pid
WHERE staging_table.sd_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.smart_doc deleted_records
    WHERE deleted_records.sd_pid = history_table.sd_pid
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

--state_machine_definition
WITH delete_keys (process_name) AS (
    VALUES ('SP-100231')
)
DELETE
FROM mdi.state_machine_definition
    USING delete_keys, mdi.process
WHERE state_machine_definition.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--json_output_field
WITH delete_keys (process_name) AS (
    VALUES ('SP-100231')
)
DELETE
FROM mdi.json_output_field
    USING delete_keys, mdi.process
WHERE json_output_field.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--table_output_field
WITH delete_keys (process_name, database_field_name) AS (
    VALUES ('SP-100090', 'lu_work_step_start_notices_enabled')
         , ('SP-100231', 'qmt_pid')
         , ('SP-100231', 'qmt_version')
         , ('SP-100231', 'qmt_effective_date')
         , ('SP-100231', 'qmt_first_total_loan_amount_threshold')
         , ('SP-100231', 'qmt_first_points_and_fees_threshold_percent')
         , ('SP-100231', 'qmt_second_total_loan_amount_threshold')
         , ('SP-100231', 'qmt_second_points_and_fees_threshold_amount')
         , ('SP-100231', 'qmt_third_total_loan_amount_threshold')
         , ('SP-100231', 'qmt_third_points_and_fees_threshold_percent')
         , ('SP-100231', 'qmt_fourth_total_loan_amount_threshold')
         , ('SP-100231', 'qmt_fourth_points_and_fees_threshold_amount')
         , ('SP-100231', 'qmt_ceiling_points_and_fees_threshold_percent')
         , ('SP-100231', 'data_source_updated_datetime')
         , ('SP-100231', 'data_source_deleted_flag')
         , ('SP-100231', 'etl_batch_id')
)
DELETE
FROM mdi.table_output_field
    USING delete_keys, mdi.process, mdi.table_output_step
WHERE delete_keys.process_name = process.name
  AND process.dwid = table_output_step.process_dwid
  AND table_output_step.dwid = table_output_field.table_output_step_dwid
  AND delete_keys.database_field_name = table_output_field.database_field_name;

--table_output_step
WITH delete_keys (process_name) AS (
    VALUES ('SP-100231')
)
DELETE
FROM mdi.table_output_step
    USING delete_keys, mdi.process
WHERE table_output_step.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--table_input_step
WITH delete_keys (process_name) AS (
    VALUES ('SP-100231')
)
DELETE
FROM mdi.table_input_step
    USING delete_keys, mdi.process
WHERE table_input_step.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--process
WITH delete_keys (process_name) AS (
    VALUES ('SP-100231')
)
DELETE
FROM mdi.process
    USING delete_keys
WHERE process.name = delete_keys.process_name;

--edw_field_definition
WITH delete_keys (database_name, schema_name, table_name, field_name) AS (
    VALUES ('staging', 'history_octane', 'qualified_mortgage_thresholds', 'etl_batch_id')
         , ('staging', 'history_octane', 'qualified_mortgage_thresholds', 'qmt_first_total_loan_amount_threshold')
         , ('staging', 'history_octane', 'qualified_mortgage_thresholds', 'qmt_second_points_and_fees_threshold_amount')
         , ('staging', 'history_octane', 'qualified_mortgage_thresholds', 'qmt_third_total_loan_amount_threshold')
         , ('staging', 'history_octane', 'qualified_mortgage_thresholds', 'qmt_third_points_and_fees_threshold_percent')
         , ('staging', 'history_octane', 'qualified_mortgage_thresholds', 'qmt_fourth_total_loan_amount_threshold')
         , ('staging', 'history_octane', 'qualified_mortgage_thresholds', 'qmt_fourth_points_and_fees_threshold_amount')
         , ('staging', 'history_octane', 'qualified_mortgage_thresholds', 'data_source_updated_datetime')
         , ('staging', 'history_octane', 'qualified_mortgage_thresholds', 'data_source_deleted_flag')
         , ('staging', 'history_octane', 'qualified_mortgage_thresholds', 'qmt_effective_date')
         , ('staging', 'history_octane', 'qualified_mortgage_thresholds', 'qmt_version')
         , ('staging', 'history_octane', 'qualified_mortgage_thresholds', 'qmt_pid')
         , ('staging', 'history_octane', 'qualified_mortgage_thresholds', 'qmt_first_points_and_fees_threshold_percent')
         , ('staging', 'history_octane', 'qualified_mortgage_thresholds', 'qmt_ceiling_points_and_fees_threshold_percent')
         , ('staging', 'history_octane', 'qualified_mortgage_thresholds', 'qmt_second_total_loan_amount_threshold')
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
    VALUES ('staging', 'staging_octane', 'qualified_mortgage_thresholds', 'qmt_second_total_loan_amount_threshold')
         , ('staging', 'staging_octane', 'qualified_mortgage_thresholds', 'qmt_fourth_points_and_fees_threshold_amount')
         , ('staging', 'staging_octane', 'qualified_mortgage_thresholds', 'qmt_third_points_and_fees_threshold_percent')
         , ('staging', 'staging_octane', 'qualified_mortgage_thresholds', 'qmt_first_points_and_fees_threshold_percent')
         , ('staging', 'staging_octane', 'qualified_mortgage_thresholds', 'qmt_pid')
         , ('staging', 'staging_octane', 'qualified_mortgage_thresholds', 'qmt_ceiling_points_and_fees_threshold_percent')
         , ('staging', 'staging_octane', 'qualified_mortgage_thresholds', 'qmt_fourth_total_loan_amount_threshold')
         , ('staging', 'staging_octane', 'qualified_mortgage_thresholds', 'qmt_third_total_loan_amount_threshold')
         , ('staging', 'staging_octane', 'qualified_mortgage_thresholds', 'qmt_second_points_and_fees_threshold_amount')
         , ('staging', 'staging_octane', 'qualified_mortgage_thresholds', 'qmt_first_total_loan_amount_threshold')
         , ('staging', 'staging_octane', 'qualified_mortgage_thresholds', 'qmt_version')
         , ('staging', 'staging_octane', 'qualified_mortgage_thresholds', 'qmt_effective_date')
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
    VALUES ('staging', 'staging_octane', 'lender_user', 'lu_work_step_start_notices_enabled')
)
DELETE
FROM mdi.edw_field_definition
    USING delete_keys, mdi.edw_table_definition
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name
  AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = delete_keys.field_name;

--edw_join_definition (MANUALLY ADDED to prevent referential integrity error in auto-generated script)
DELETE
FROM mdi.edw_join_definition
    USING mdi.edw_table_definition primary_table, mdi.edw_table_definition target_table
WHERE edw_join_definition.primary_edw_table_definition_dwid = primary_table.dwid
  AND edw_join_definition.target_edw_table_definition_dwid = target_table.dwid
  AND (primary_table.table_name = 'qualified_mortgage_thresholds'
    OR target_table.table_name = 'qualified_mortgage_thresholds');

--edw_table_definition
WITH delete_keys (database_name, schema_name, table_name) AS (
    VALUES ('staging', 'history_octane', 'qualified_mortgage_thresholds')
)
DELETE
FROM mdi.edw_table_definition
    USING delete_keys
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name;

WITH delete_keys (database_name, schema_name, table_name) AS (
    VALUES ('staging', 'staging_octane', 'qualified_mortgage_thresholds')
)
DELETE
FROM mdi.edw_table_definition
    USING delete_keys
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name;
