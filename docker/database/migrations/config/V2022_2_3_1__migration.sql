--
-- Main | EDW | Octane schemas from prod-release to v2022.2.3.1 on uat
-- https://app.asana.com/0/0/1201819172972254
--

/*
INSERTIONS
*/

--edw_field_definition
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'staging_octane', 'lp_finding', 'lpf_finding_result', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'lp_finding', 'lpf_finding_result', 'VARCHAR(128)', 'staging', 'staging_octane', 'lp_finding', 'lpf_finding_result')
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

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('SP-100310', 'lpf_finding_result')
)
INSERT
INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
SELECT table_output_step.dwid, insert_rows.database_field_name, insert_rows.database_field_name, 0, FALSE
FROM insert_rows
         JOIN mdi.process
              ON process.name = insert_rows.process_name
         JOIN mdi.table_output_step
              ON process.dwid = table_output_step.process_dwid;


/*
UPDATES
*/

--table_input_step
WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100310', 0, '--finding records to insert into history_octane.lp_finding
SELECT staging_table.lpf_pid
     , staging_table.lpf_version
     , staging_table.lpf_lp_request_pid
     , staging_table.lpf_lp_finding_message_type
     , staging_table.lpf_finding_result
     , staging_table.lpf_finding_value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.lp_finding staging_table
LEFT JOIN history_octane.lp_finding history_table
          ON staging_table.lpf_pid = history_table.lpf_pid
              AND staging_table.lpf_version = history_table.lpf_version
WHERE history_table.lpf_pid IS NULL
UNION ALL
SELECT history_table.lpf_pid
     , history_table.lpf_version + 1
     , history_table.lpf_lp_request_pid
     , history_table.lpf_lp_finding_message_type
     , history_table.lpf_finding_result
     , history_table.lpf_finding_value
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.lp_finding history_table
LEFT JOIN staging_octane.lp_finding staging_table
          ON staging_table.lpf_pid = history_table.lpf_pid
WHERE staging_table.lpf_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.lp_finding deleted_records
    WHERE deleted_records.lpf_pid = history_table.lpf_pid
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
    VALUES ('SP-100310', 'lpf_finding_yes_no_unknown_type')
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
    VALUES ('staging', 'history_octane', 'lp_finding', 'lpf_finding_yes_no_unknown_type')
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
    VALUES ('staging', 'staging_octane', 'lp_finding', 'lpf_finding_yes_no_unknown_type')
)
DELETE
FROM mdi.edw_field_definition
    USING delete_keys, mdi.edw_table_definition
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name
  AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = delete_keys.field_name;
