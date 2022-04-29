--
-- Main | EDW | Octane schema synchronization for v2022.4.5.0 (2022-04-29)
-- https://app.asana.com/0/0/1202177783000740
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'staging_octane', 'mcr_state_snapshot', NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'mcr_state_snapshot', 'staging', 'staging_octane', 'mcr_state_snapshot')
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
    VALUES ('staging', 'history_octane', 'mcr_state_snapshot', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'mcr_state_snapshot', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'mcr_state_snapshot', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'mcr_state_snapshot', 'mcrss_applications_in_process_borrower_loan_amount', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'mcr_state_snapshot', 'mcrss_applications_in_process_borrower_loan_count', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'mcr_state_snapshot', 'mcrss_applications_in_process_third_party_loan_amount', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'mcr_state_snapshot', 'mcrss_applications_in_process_third_party_loan_count', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'mcr_state_snapshot', 'mcrss_mcr_snapshot_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'mcr_state_snapshot', 'mcrss_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'mcr_state_snapshot', 'mcrss_subject_property_state', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'mcr_state_snapshot', 'mcrss_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'location', 'loc_amt_location_code', 'VARCHAR(16)', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'mcr_state_snapshot', 'mcrss_applications_in_process_borrower_loan_amount', 'BIGINT', 'staging', 'staging_octane', 'mcr_state_snapshot', 'mcrss_applications_in_process_borrower_loan_amount')
         , ('staging', 'history_octane', 'mcr_state_snapshot', 'mcrss_applications_in_process_borrower_loan_count', 'BIGINT', 'staging', 'staging_octane', 'mcr_state_snapshot', 'mcrss_applications_in_process_borrower_loan_count')
         , ('staging', 'history_octane', 'mcr_state_snapshot', 'mcrss_applications_in_process_third_party_loan_amount', 'BIGINT', 'staging', 'staging_octane', 'mcr_state_snapshot', 'mcrss_applications_in_process_third_party_loan_amount')
         , ('staging', 'history_octane', 'mcr_state_snapshot', 'mcrss_applications_in_process_third_party_loan_count', 'BIGINT', 'staging', 'staging_octane', 'mcr_state_snapshot', 'mcrss_applications_in_process_third_party_loan_count')
         , ('staging', 'history_octane', 'mcr_state_snapshot', 'mcrss_mcr_snapshot_pid', 'BIGINT', 'staging', 'staging_octane', 'mcr_state_snapshot', 'mcrss_mcr_snapshot_pid')
         , ('staging', 'history_octane', 'mcr_state_snapshot', 'mcrss_pid', 'BIGINT', 'staging', 'staging_octane', 'mcr_state_snapshot', 'mcrss_pid')
         , ('staging', 'history_octane', 'mcr_state_snapshot', 'mcrss_subject_property_state', 'VARCHAR(128)', 'staging', 'staging_octane', 'mcr_state_snapshot', 'mcrss_subject_property_state')
         , ('staging', 'history_octane', 'mcr_state_snapshot', 'mcrss_version', 'INTEGER', 'staging', 'staging_octane', 'mcr_state_snapshot', 'mcrss_version')
         , ('staging', 'history_octane', 'location', 'loc_amt_location_code', 'VARCHAR(16)', 'staging', 'staging_octane', 'location', 'loc_amt_location_code')
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
VALUES ('ETL-100914', 'ETL to insert records into staging.history_octane.mcr_state_snapshot using staging.staging_octane.mcr_state_snapshot as the primary source');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('ETL-100914', 0, '--finding records to insert into history_octane.mcr_state_snapshot
SELECT staging_table.mcrss_pid
     , staging_table.mcrss_version
     , staging_table.mcrss_mcr_snapshot_pid
     , staging_table.mcrss_subject_property_state
     , staging_table.mcrss_applications_in_process_borrower_loan_amount
     , staging_table.mcrss_applications_in_process_borrower_loan_count
     , staging_table.mcrss_applications_in_process_third_party_loan_amount
     , staging_table.mcrss_applications_in_process_third_party_loan_count
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.mcr_state_snapshot staging_table
LEFT JOIN history_octane.mcr_state_snapshot history_table
          ON staging_table.mcrss_pid = history_table.mcrss_pid
              AND staging_table.mcrss_version = history_table.mcrss_version
WHERE history_table.mcrss_pid IS NULL
UNION ALL
SELECT history_table.mcrss_pid
     , history_table.mcrss_version + 1
     , history_table.mcrss_mcr_snapshot_pid
     , history_table.mcrss_subject_property_state
     , history_table.mcrss_applications_in_process_borrower_loan_amount
     , history_table.mcrss_applications_in_process_borrower_loan_count
     , history_table.mcrss_applications_in_process_third_party_loan_amount
     , history_table.mcrss_applications_in_process_third_party_loan_count
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM (
    SELECT current_records.*
    FROM history_octane.mcr_state_snapshot AS current_records
    LEFT JOIN history_octane.mcr_state_snapshot AS history_records
              ON current_records.mcrss_pid = history_records.mcrss_pid
                  AND current_records.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.data_source_updated_datetime IS NULL
      AND current_records.data_source_deleted_flag = FALSE
) AS history_table
LEFT JOIN staging_octane.mcr_state_snapshot staging_table
          ON staging_table.mcrss_pid = history_table.mcrss_pid
WHERE staging_table.mcrss_pid IS NULL;', 'Staging DB Connection')
)
INSERT
INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
SELECT process.dwid, insert_rows.data_source_dwid, insert_rows.sql, 0, 'N', 'N', 'N', 'N', insert_rows.connectionname::mdi.pentaho_db_connection_name
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--table_output_step
WITH insert_rows (process_name, target_schema, target_table, truncate_table, connectionname) AS (
    VALUES ('ETL-100914', 'history_octane', 'mcr_state_snapshot', 'N', 'Staging DB Connection')
)
INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT process.dwid, insert_rows.target_schema, insert_rows.target_table, 1000, NULL, NULL, NULL, NULL, 'N', NULL, insert_rows.truncate_table::mdi.pentaho_y_or_n, insert_rows.connectionname, 'N', 'Y', 'N', 'N'
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('ETL-100914', 'data_source_deleted_flag')
         , ('ETL-100914', 'data_source_updated_datetime')
         , ('ETL-100914', 'etl_batch_id')
         , ('ETL-100914', 'mcrss_applications_in_process_borrower_loan_amount')
         , ('ETL-100914', 'mcrss_applications_in_process_borrower_loan_count')
         , ('ETL-100914', 'mcrss_applications_in_process_third_party_loan_amount')
         , ('ETL-100914', 'mcrss_applications_in_process_third_party_loan_count')
         , ('ETL-100914', 'mcrss_mcr_snapshot_pid')
         , ('ETL-100914', 'mcrss_pid')
         , ('ETL-100914', 'mcrss_subject_property_state')
         , ('ETL-100914', 'mcrss_version')
         , ('ETL-100849', 'loc_amt_location_code')
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
    VALUES ('ETL-100914', 'mcrss_pid')
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
    VALUES ('ETL-100849', 0, '--finding records to insert into history_octane.location
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
     , staging_table.loc_amt_location_code
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.location staging_table
LEFT JOIN history_octane.location history_table
          ON staging_table.loc_pid = history_table.loc_pid
              AND staging_table.loc_version = history_table.loc_version
WHERE history_table.loc_pid IS NULL
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
     , history_table.loc_amt_location_code
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM (
    SELECT current_records.*
    FROM history_octane.location AS current_records
    LEFT JOIN history_octane.location AS history_records
              ON current_records.loc_pid = history_records.loc_pid
                  AND current_records.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.data_source_updated_datetime IS NULL
      AND current_records.data_source_deleted_flag = FALSE
) AS history_table
LEFT JOIN staging_octane.location staging_table
          ON staging_table.loc_pid = history_table.loc_pid
WHERE staging_table.loc_pid IS NULL;', 'Staging DB Connection')
)
UPDATE mdi.table_input_step
SET data_source_dwid = update_rows.data_source_dwid
  , sql = update_rows.sql
  , connectionname = update_rows.connectionname::mdi.pentaho_db_connection_name
FROM update_rows
JOIN mdi.process
     ON process.name = update_rows.process_name
WHERE process.dwid = table_input_step.process_dwid;
