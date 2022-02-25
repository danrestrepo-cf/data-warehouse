--
-- Main | EDW | Octane schemas from prod-release to v2022.2.4.3 on uat
-- https://app.asana.com/0/0/1201869048849952
--

/*
INSERTIONS
*/

--edw_field_definition
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'staging_octane', 'deal', 'd_ecoa_notice_of_incomplete_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal', 'd_ecoa_notice_of_incomplete_due_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'wf_step_function_parameters', 'wsfp_number_business_days', 'INTEGER', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'deal', 'd_ecoa_notice_of_incomplete_date', 'DATE', 'staging', 'staging_octane', 'deal', 'd_ecoa_notice_of_incomplete_date')
         , ('staging', 'history_octane', 'deal', 'd_ecoa_notice_of_incomplete_due_date', 'DATE', 'staging', 'staging_octane', 'deal', 'd_ecoa_notice_of_incomplete_due_date')
         , ('staging', 'history_octane', 'wf_step_function_parameters', 'wsfp_number_business_days', 'INTEGER', 'staging', 'staging_octane', 'wf_step_function_parameters', 'wsfp_number_business_days')
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
    VALUES ('SP-100267', 'd_ecoa_notice_of_incomplete_date')
         , ('SP-100267', 'd_ecoa_notice_of_incomplete_due_date')
         , ('SP-100900', 'wsfp_number_business_days')
)
INSERT
INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
SELECT table_output_step.dwid, insert_rows.database_field_name, insert_rows.database_field_name, 0, FALSE
FROM insert_rows
         JOIN mdi.process
              ON process.name = insert_rows.process_name
         JOIN mdi.table_output_step
              ON process.dwid = table_output_step.process_dwid;
