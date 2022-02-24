--
-- EDW | ensure SP-200001 (loan_lender_user_access) ETLs are triggered as part of the nightly ETL cycle
-- https://app.asana.com/0/0/1201878754398244
--

/*
INSERTIONS
*/

--state_machine_step
WITH insert_rows (process_name, next_process_name) AS (
    VALUES ('SP-100092', 'SP-200001-delete')
         , ('SP-100092', 'SP-200001-insert')
         , ('SP-100090', 'SP-200001-delete')
         , ('SP-100090', 'SP-200001-insert')
         , ('SP-300001-insert-update', 'SP-200001-delete')
         , ('SP-300001-insert-update', 'SP-200001-insert')
         , ('SP-300001-delete', 'SP-200001-delete')
         , ('SP-300001-delete', 'SP-200001-insert')
)
INSERT
INTO mdi.state_machine_step (process_dwid, next_process_dwid)
SELECT process.dwid, next_process.dwid
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name
JOIN mdi.process next_process
     ON next_process.name = insert_rows.next_process_name;

--
-- Main | EDW | Octane schemas from prod-release to v2022.2.4.1 on uat
-- https://app.asana.com/0/0/1201869048849952
--

/*
INSERTIONS
*/

--edw_field_definition
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'staging_octane', 'borrower', 'b_mobile_phone_na', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_concession_request', 'lcr_decision_explanation', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_concession_request', 'lcr_requested_reason_explanation', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_engagement', 'prpe_lender_engagement_percent', 'NUMERIC(11,9)', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'borrower', 'b_mobile_phone_na', 'BOOLEAN', 'staging', 'staging_octane', 'borrower', 'b_mobile_phone_na')
         , ('staging', 'history_octane', 'lender_concession_request', 'lcr_decision_explanation', 'VARCHAR(1024)', 'staging', 'staging_octane', 'lender_concession_request', 'lcr_decision_explanation')
         , ('staging', 'history_octane', 'lender_concession_request', 'lcr_requested_reason_explanation', 'VARCHAR(1024)', 'staging', 'staging_octane', 'lender_concession_request', 'lcr_requested_reason_explanation')
         , ('staging', 'history_octane', 'proposal_engagement', 'prpe_lender_engagement_percent', 'NUMERIC(11,9)', 'staging', 'staging_octane', 'proposal_engagement', 'prpe_lender_engagement_percent')
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
    VALUES ('SP-100308', 'b_mobile_phone_na')
         , ('SP-100322', 'lcr_decision_explanation')
         , ('SP-100322', 'lcr_requested_reason_explanation')
         , ('SP-100167', 'prpe_lender_engagement_percent')
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
DELETIONS
*/

--table_output_field
WITH delete_keys (process_name, database_field_name) AS (
    VALUES ('SP-100322', 'lcr_decision_notes')
         , ('SP-100322', 'lcr_request_notes')
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
    VALUES ('staging', 'history_octane', 'lender_concession_request', 'lcr_decision_notes')
         , ('staging', 'history_octane', 'lender_concession_request', 'lcr_request_notes')
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
    VALUES ('staging', 'staging_octane', 'lender_concession_request', 'lcr_request_notes')
         , ('staging', 'staging_octane', 'lender_concession_request', 'lcr_decision_notes')
)
DELETE
FROM mdi.edw_field_definition
    USING delete_keys, mdi.edw_table_definition
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name
  AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = delete_keys.field_name;
