--
-- EDW | dimension ETLs - refactor to use batch_id start/end times instead of comparing every field to determine which records to update
-- https://app.asana.com/0/0/1201313036590173
--

WITH updated_dim_sql (table_name, sql) AS (
/*
 application_dim
 */
    VALUES ('application_dim', 'WITH application_dim_incl_new_records AS (
    SELECT ''application_pid'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( primary_table.apl_pid AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , primary_table.data_source_updated_datetime AS data_source_modified_datetime
         , primary_table.apl_pid AS application_pid
         , primary_table.apl_proposal_pid AS proposal_pid
         , GREATEST( primary_table.etl_end_date_time ) AS max_source_etl_end_date_time
    FROM (
        SELECT <<application_partial_load_condition>> AS include_record
             , application.*
             , etl_log.etl_end_date_time
        FROM history_octane.application
        LEFT JOIN history_octane.application AS history_records
                  ON application.apl_pid = history_records.apl_pid
                      AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
        JOIN star_common.etl_log
             ON application.etl_batch_id = etl_log.etl_batch_id
        WHERE history_records.apl_pid IS NULL
    ) AS primary_table
    WHERE GREATEST( primary_table.include_record ) IS TRUE
    ORDER BY primary_table.data_source_updated_datetime ASC
)
--new records that should be inserted
SELECT application_dim_incl_new_records.*
FROM application_dim_incl_new_records
LEFT JOIN star_loan.application_dim
          ON application_dim_incl_new_records.data_source_integration_id = application_dim.data_source_integration_id
WHERE application_dim.dwid IS NULL
UNION ALL
--existing records that need to be updated
SELECT application_dim_incl_new_records.*
FROM application_dim_incl_new_records
JOIN (
    SELECT application_dim.data_source_integration_id, etl_log.etl_start_date_time
    FROM star_loan.application_dim
    JOIN star_common.etl_log
         ON application_dim.etl_batch_id = etl_log.etl_batch_id
) AS application_dim_etl_start_times
     ON application_dim_incl_new_records.data_source_integration_id = application_dim_etl_start_times.data_source_integration_id
         AND application_dim_incl_new_records.max_source_etl_end_date_time >= application_dim_etl_start_times.etl_start_date_time;')
)
UPDATE mdi.table_input_step
SET sql = updated_dim_sql.sql
FROM updated_dim_sql
JOIN mdi.insert_update_step
     ON insert_update_step.schema_name = 'star_loan'
         AND insert_update_step.table_name = updated_dim_sql.table_name
WHERE table_input_step.process_dwid = insert_update_step.process_dwid;
