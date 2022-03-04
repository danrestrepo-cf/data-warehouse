/*
INSERTIONS
*/

--edw_field_definition
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'staging_octane', 'appraisal_order_request', 'aprq_appraisal_import_warnings', 'TEXT', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'appraisal_order_request', 'aprq_appraisal_import_warnings', 'TEXT', 'staging', 'staging_octane', 'appraisal_order_request', 'aprq_appraisal_import_warnings')
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
    VALUES ('SP-100302', 'aprq_appraisal_import_warnings')
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
    VALUES ('SP-100302', 0, '--finding records to insert into history_octane.appraisal_order_request
SELECT staging_table.aprq_pid
     , staging_table.aprq_version
     , staging_table.aprq_deal_pid
     , staging_table.aprq_appraisal_pid
     , staging_table.aprq_mercury_network_status_request_pid
     , staging_table.aprq_appraisal_order_coarse_status_type
     , staging_table.aprq_order_id
     , staging_table.aprq_order_instructions
     , staging_table.aprq_address_street1
     , staging_table.aprq_address_street2
     , staging_table.aprq_address_city
     , staging_table.aprq_address_state
     , staging_table.aprq_address_postal_code
     , staging_table.aprq_order_request_date
     , staging_table.aprq_response_xml_deal_system_file_pid
     , staging_table.aprq_mismo_xml_deal_system_file_pid
     , staging_table.aprq_appraisal_order_request_type
     , staging_table.aprq_status_check_datetime
     , staging_table.aprq_appraisal_management_company_type
     , staging_table.aprq_requester_lender_user_pid
     , staging_table.aprq_requester_unparsed_name
     , staging_table.aprq_requester_agent_type
     , staging_table.aprq_vendor_status_unique_id
     , staging_table.aprq_appraisal_import_warnings
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.appraisal_order_request staging_table
LEFT JOIN history_octane.appraisal_order_request history_table
          ON staging_table.aprq_pid = history_table.aprq_pid
              AND staging_table.aprq_version = history_table.aprq_version
WHERE history_table.aprq_pid IS NULL
UNION ALL
SELECT history_table.aprq_pid
     , history_table.aprq_version + 1
     , history_table.aprq_deal_pid
     , history_table.aprq_appraisal_pid
     , history_table.aprq_mercury_network_status_request_pid
     , history_table.aprq_appraisal_order_coarse_status_type
     , history_table.aprq_order_id
     , history_table.aprq_order_instructions
     , history_table.aprq_address_street1
     , history_table.aprq_address_street2
     , history_table.aprq_address_city
     , history_table.aprq_address_state
     , history_table.aprq_address_postal_code
     , history_table.aprq_order_request_date
     , history_table.aprq_response_xml_deal_system_file_pid
     , history_table.aprq_mismo_xml_deal_system_file_pid
     , history_table.aprq_appraisal_order_request_type
     , history_table.aprq_status_check_datetime
     , history_table.aprq_appraisal_management_company_type
     , history_table.aprq_requester_lender_user_pid
     , history_table.aprq_requester_unparsed_name
     , history_table.aprq_requester_agent_type
     , history_table.aprq_vendor_status_unique_id
     , history_table.aprq_appraisal_import_warnings
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.appraisal_order_request history_table
LEFT JOIN staging_octane.appraisal_order_request staging_table
          ON staging_table.aprq_pid = history_table.aprq_pid
WHERE staging_table.aprq_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.appraisal_order_request deleted_records
    WHERE deleted_records.aprq_pid = history_table.aprq_pid
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
