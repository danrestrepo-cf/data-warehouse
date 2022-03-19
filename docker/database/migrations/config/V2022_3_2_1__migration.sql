--
-- Main | EDW | Octane schema synchronization for v2022.3.3.0 (2022-03-18) (https://app.asana.com/0/0/1201986460557023)
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'staging_octane', 'compensation_type', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'business_income_borrower_title_type', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_user_role_org_node', NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'compensation_type', 'staging', 'staging_octane', 'compensation_type')
         , ('staging', 'history_octane', 'business_income_borrower_title_type', 'staging', 'staging_octane', 'business_income_borrower_title_type')
         , ('staging', 'history_octane', 'lender_user_role_org_node', 'staging', 'staging_octane', 'lender_user_role_org_node')
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
    VALUES ('staging', 'history_octane', 'compensation_type', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'compensation_type', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'compensation_type', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'business_income_borrower_title_type', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'business_income_borrower_title_type', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'business_income_borrower_title_type', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_user_role_org_node', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_user_role_org_node', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'lender_user_role_org_node', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'compensation_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'compensation_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'business_income_borrower_title_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'business_income_borrower_title_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_construction', 'prpc_effective_construction_completion_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_user_role_org_node', 'luron_lender_user_role_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_user_role_org_node', 'luron_org_node_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_user_role_org_node', 'luron_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lender_user_role_org_node', 'luron_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal', 'prp_loan_modification_agreement_executed_received_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_key_roles', 'dkrs_contract_processor_fmls', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_key_roles', 'dkrs_contract_processor_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'business_income', 'bui_borrower_title_other_description', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'business_income', 'bui_borrower_title_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'tax_transcript_request', 'ttr_business_income_borrower_title', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'tax_transcript_request', 'ttr_include_1120s', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'tax_transcript_request', 'ttr_include_1120s_account_transcript', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'tax_transcript_request', 'ttr_include_1120s_record_of_account', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'tax_transcript_request', 'ttr_include_1120s_return_transcript', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'lead_source', 'lds_compensation_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'compensation_type', 'code', 'VARCHAR(128)', 'staging', 'staging_octane', 'compensation_type', 'code')
         , ('staging', 'history_octane', 'compensation_type', 'value', 'VARCHAR(1024)', 'staging', 'staging_octane', 'compensation_type', 'value')
         , ('staging', 'history_octane', 'business_income_borrower_title_type', 'code', 'VARCHAR(128)', 'staging', 'staging_octane', 'business_income_borrower_title_type', 'code')
         , ('staging', 'history_octane', 'business_income_borrower_title_type', 'value', 'VARCHAR(1024)', 'staging', 'staging_octane', 'business_income_borrower_title_type', 'value')
         , ('staging', 'history_octane', 'proposal_construction', 'prpc_effective_construction_completion_date', 'DATE', 'staging', 'staging_octane', 'proposal_construction', 'prpc_effective_construction_completion_date')
         , ('staging', 'history_octane', 'lender_user_role_org_node', 'luron_lender_user_role_pid', 'BIGINT', 'staging', 'staging_octane', 'lender_user_role_org_node', 'luron_lender_user_role_pid')
         , ('staging', 'history_octane', 'lender_user_role_org_node', 'luron_org_node_pid', 'BIGINT', 'staging', 'staging_octane', 'lender_user_role_org_node', 'luron_org_node_pid')
         , ('staging', 'history_octane', 'lender_user_role_org_node', 'luron_pid', 'BIGINT', 'staging', 'staging_octane', 'lender_user_role_org_node', 'luron_pid')
         , ('staging', 'history_octane', 'lender_user_role_org_node', 'luron_version', 'INTEGER', 'staging', 'staging_octane', 'lender_user_role_org_node', 'luron_version')
         , ('staging', 'history_octane', 'proposal', 'prp_loan_modification_agreement_executed_received_datetime', 'TIMESTAMP', 'staging', 'staging_octane', 'proposal', 'prp_loan_modification_agreement_executed_received_datetime')
         , ('staging', 'history_octane', 'deal_key_roles', 'dkrs_contract_processor_fmls', 'VARCHAR(128)', 'staging', 'staging_octane', 'deal_key_roles', 'dkrs_contract_processor_fmls')
         , ('staging', 'history_octane', 'deal_key_roles', 'dkrs_contract_processor_lender_user_pid', 'BIGINT', 'staging', 'staging_octane', 'deal_key_roles', 'dkrs_contract_processor_lender_user_pid')
         , ('staging', 'history_octane', 'business_income', 'bui_borrower_title_other_description', 'VARCHAR(128)', 'staging', 'staging_octane', 'business_income', 'bui_borrower_title_other_description')
         , ('staging', 'history_octane', 'business_income', 'bui_borrower_title_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'business_income', 'bui_borrower_title_type')
         , ('staging', 'history_octane', 'tax_transcript_request', 'ttr_business_income_borrower_title', 'VARCHAR(128)', 'staging', 'staging_octane', 'tax_transcript_request', 'ttr_business_income_borrower_title')
         , ('staging', 'history_octane', 'tax_transcript_request', 'ttr_include_1120s', 'BOOLEAN', 'staging', 'staging_octane', 'tax_transcript_request', 'ttr_include_1120s')
         , ('staging', 'history_octane', 'tax_transcript_request', 'ttr_include_1120s_account_transcript', 'BOOLEAN', 'staging', 'staging_octane', 'tax_transcript_request', 'ttr_include_1120s_account_transcript')
         , ('staging', 'history_octane', 'tax_transcript_request', 'ttr_include_1120s_record_of_account', 'BOOLEAN', 'staging', 'staging_octane', 'tax_transcript_request', 'ttr_include_1120s_record_of_account')
         , ('staging', 'history_octane', 'tax_transcript_request', 'ttr_include_1120s_return_transcript', 'BOOLEAN', 'staging', 'staging_octane', 'tax_transcript_request', 'ttr_include_1120s_return_transcript')
         , ('staging', 'history_octane', 'lead_source', 'lds_compensation_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'lead_source', 'lds_compensation_type')
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
VALUES ('SP-100906', 'ETL to insert records into staging.history_octane.compensation_type using staging.staging_octane.compensation_type as the primary source')
     , ('SP-100905', 'ETL to insert records into staging.history_octane.business_income_borrower_title_type using staging.staging_octane.business_income_borrower_title_type as the primary source')
     , ('SP-100907', 'ETL to insert records into staging.history_octane.lender_user_role_org_node using staging.staging_octane.lender_user_role_org_node as the primary source');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100906', 0, '--finding records to insert into history_octane.compensation_type
SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.compensation_type staging_table
LEFT JOIN history_octane.compensation_type history_table
          ON staging_table.code = history_table.code
              AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;', 'Staging DB Connection')
         , ('SP-100905', 0, '--finding records to insert into history_octane.business_income_borrower_title_type
SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.business_income_borrower_title_type staging_table
LEFT JOIN history_octane.business_income_borrower_title_type history_table
          ON staging_table.code = history_table.code
              AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;', 'Staging DB Connection')
         , ('SP-100907', 0, '--finding records to insert into history_octane.lender_user_role_org_node
SELECT staging_table.luron_pid
     , staging_table.luron_version
     , staging_table.luron_lender_user_role_pid
     , staging_table.luron_org_node_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.lender_user_role_org_node staging_table
LEFT JOIN history_octane.lender_user_role_org_node history_table
          ON staging_table.luron_pid = history_table.luron_pid
              AND staging_table.luron_version = history_table.luron_version
WHERE history_table.luron_pid IS NULL
UNION ALL
SELECT history_table.luron_pid
     , history_table.luron_version + 1
     , history_table.luron_lender_user_role_pid
     , history_table.luron_org_node_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.lender_user_role_org_node history_table
LEFT JOIN staging_octane.lender_user_role_org_node staging_table
          ON staging_table.luron_pid = history_table.luron_pid
WHERE staging_table.luron_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.lender_user_role_org_node deleted_records
    WHERE deleted_records.luron_pid = history_table.luron_pid
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
    VALUES ('SP-100906', 'history_octane', 'compensation_type', 'N', 'Staging DB Connection')
         , ('SP-100905', 'history_octane', 'business_income_borrower_title_type', 'N', 'Staging DB Connection')
         , ('SP-100907', 'history_octane', 'lender_user_role_org_node', 'N', 'Staging DB Connection')
)
INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT process.dwid, insert_rows.target_schema, insert_rows.target_table, 1000, NULL, NULL, NULL, NULL, 'N', NULL, insert_rows.truncate_table::mdi.pentaho_y_or_n, insert_rows.connectionname, 'N', 'Y', 'N', 'N'
FROM insert_rows
    JOIN mdi.process
        ON process.name = insert_rows.process_name;

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('SP-100906', 'code')
         , ('SP-100906', 'data_source_deleted_flag')
         , ('SP-100906', 'data_source_updated_datetime')
         , ('SP-100906', 'etl_batch_id')
         , ('SP-100906', 'value')
         , ('SP-100905', 'code')
         , ('SP-100905', 'data_source_deleted_flag')
         , ('SP-100905', 'data_source_updated_datetime')
         , ('SP-100905', 'etl_batch_id')
         , ('SP-100905', 'value')
         , ('SP-100826', 'prpc_effective_construction_completion_date')
         , ('SP-100907', 'data_source_deleted_flag')
         , ('SP-100907', 'data_source_updated_datetime')
         , ('SP-100907', 'etl_batch_id')
         , ('SP-100907', 'luron_lender_user_role_pid')
         , ('SP-100907', 'luron_org_node_pid')
         , ('SP-100907', 'luron_pid')
         , ('SP-100907', 'luron_version')
         , ('SP-100317', 'prp_loan_modification_agreement_executed_received_datetime')
         , ('SP-100017', 'dkrs_contract_processor_fmls')
         , ('SP-100017', 'dkrs_contract_processor_lender_user_pid')
         , ('SP-100130', 'bui_borrower_title_other_description')
         , ('SP-100130', 'bui_borrower_title_type')
         , ('SP-100340', 'ttr_business_income_borrower_title')
         , ('SP-100340', 'ttr_include_1120s')
         , ('SP-100340', 'ttr_include_1120s_account_transcript')
         , ('SP-100340', 'ttr_include_1120s_record_of_account')
         , ('SP-100340', 'ttr_include_1120s_return_transcript')
         , ('SP-100038', 'lds_compensation_type')
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
    VALUES ('SP-100906', 'code')
         , ('SP-100905', 'code')
         , ('SP-100907', 'luron_pid')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
    JOIN mdi.process
        ON insert_rows.process_name = process.name;

--state_machine_definition
WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-100906', 'SP-100906', 'ETL to insert records into staging.history_octane.compensation_type using staging.staging_octane.compensation_type as the primary source')
         , ('SP-100905', 'SP-100905', 'ETL to insert records into staging.history_octane.business_income_borrower_title_type using staging.staging_octane.business_income_borrower_title_type as the primary source')
         , ('SP-100907', 'SP-100907', 'ETL to insert records into staging.history_octane.lender_user_role_org_node using staging.staging_octane.lender_user_role_org_node as the primary source')
)
INSERT
INTO mdi.state_machine_definition (process_dwid, name, comment)
SELECT process.dwid, insert_rows.state_machine_name, insert_rows.state_machine_comment
FROM insert_rows
    JOIN mdi.process
        ON process.name = insert_rows.process_name;

--state_machine_step
WITH insert_rows (process_name, next_process_name) AS (
    VALUES ('SP-300001-insert-update', 'SP-200001-delete')
         , ('SP-300001-delete', 'SP-200001-delete')
)
INSERT
INTO mdi.state_machine_step (process_dwid, next_process_dwid)
SELECT process.dwid, next_process.dwid
FROM insert_rows
    JOIN mdi.process
        ON process.name = insert_rows.process_name
    JOIN mdi.process next_process
        ON next_process.name = insert_rows.next_process_name;

/*
UPDATES
*/

--edw_table_definition
WITH update_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'history_octane', 'broker_compensation_type', NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note', NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note', NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note_comment', NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note', NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note', NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note_monitor', NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note_comment', NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note_comment', NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note_monitor', NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note_monitor', NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note_comment', NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note_monitor', NULL, NULL, NULL)
)
UPDATE mdi.edw_table_definition
SET primary_source_edw_table_definition_dwid = source_table_definition.dwid
FROM update_rows
    LEFT JOIN mdi.edw_table_definition source_table_definition
        ON update_rows.source_database_name = source_table_definition.database_name
            AND update_rows.source_schema_name = source_table_definition.schema_name
            AND update_rows.source_table_name = source_table_definition.table_name
WHERE update_rows.database_name = edw_table_definition.database_name
    AND update_rows.schema_name = edw_table_definition.schema_name
    AND update_rows.table_name = edw_table_definition.table_name;

--edw_field_definition
WITH update_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'history_octane', 'broker_compensation_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'broker_compensation_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note', 'locn_author_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note', 'locn_author_unparsed_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note', 'locn_content', 'VARCHAR(16000)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note', 'locn_create_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note', 'locn_location_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note', 'locn_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note', 'locn_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note', 'wfpn_author_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note', 'wfpn_author_unparsed_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note', 'wfpn_content', 'VARCHAR(16000)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note', 'wfpn_create_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note', 'wfpn_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note', 'wfpn_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note', 'wfpn_wf_process_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note_comment', 'sdnc_author_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note_comment', 'sdnc_author_unparsed_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note_comment', 'sdnc_content', 'VARCHAR(16000)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note_comment', 'sdnc_create_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note_comment', 'sdnc_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note_comment', 'sdnc_smart_doc_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note_comment', 'sdnc_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note', 'wfsn_author_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note', 'wfsn_author_unparsed_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note', 'wfsn_content', 'VARCHAR(16000)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note', 'wfsn_create_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note', 'wfsn_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note', 'wfsn_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note', 'wfsn_wf_step_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note', 'sdn_author_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note', 'sdn_author_unparsed_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note', 'sdn_content', 'VARCHAR(16000)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note', 'sdn_create_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note', 'sdn_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note', 'sdn_smart_doc_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note', 'sdn_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note_monitor', 'locnm_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note_monitor', 'locnm_location_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note_monitor', 'locnm_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note_monitor', 'locnm_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note_comment', 'locnc_author_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note_comment', 'locnc_author_unparsed_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note_comment', 'locnc_content', 'VARCHAR(16000)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note_comment', 'locnc_create_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note_comment', 'locnc_location_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note_comment', 'locnc_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'location_note_comment', 'locnc_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note_comment', 'wfpnc_author_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note_comment', 'wfpnc_author_unparsed_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note_comment', 'wfpnc_content', 'VARCHAR(16000)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note_comment', 'wfpnc_create_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note_comment', 'wfpnc_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note_comment', 'wfpnc_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note_comment', 'wfpnc_wf_process_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'config_note', 'cn_old_location_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'config_note', 'cn_old_smart_doc_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'config_note', 'cn_old_wf_process_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'config_note', 'cn_old_wf_step_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note_monitor', 'sdnm_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note_monitor', 'sdnm_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note_monitor', 'sdnm_smart_doc_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'smart_doc_note_monitor', 'sdnm_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note_monitor', 'wfsnm_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note_monitor', 'wfsnm_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note_monitor', 'wfsnm_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note_monitor', 'wfsnm_wf_step_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note_comment', 'wfsnc_author_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note_comment', 'wfsnc_author_unparsed_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note_comment', 'wfsnc_content', 'VARCHAR(16000)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note_comment', 'wfsnc_create_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note_comment', 'wfsnc_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note_comment', 'wfsnc_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_step_note_comment', 'wfsnc_wf_step_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note_monitor', 'wfpnm_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note_monitor', 'wfpnm_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note_monitor', 'wfpnm_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'wf_process_note_monitor', 'wfpnm_wf_process_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
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
    VALUES ('SP-100826', 0, '--finding records to insert into history_octane.proposal_construction
SELECT staging_table.prpc_pid
     , staging_table.prpc_version
     , staging_table.prpc_proposal_pid
     , staging_table.prpc_architectural_exhibits
     , staging_table.prpc_feasibility_study
     , staging_table.prpc_expected_months_to_complete
     , staging_table.prpc_extension_needed
     , staging_table.prpc_extension_period_months
     , staging_table.prpc_any_utilities_inoperable
     , staging_table.prpc_non_habitable_months
     , staging_table.prpc_non_habitable_units
     , staging_table.prpc_number_of_draws
     , staging_table.prpc_construction_confirmed_start_date
     , staging_table.prpc_loan_in_process_account_closed_date
     , staging_table.prpc_mortgage_payment_reserves_required
     , staging_table.prpc_estimated_permit_amount_applicable
     , staging_table.prpc_contingency_reserve_required
     , staging_table.prpc_extension_period_days
     , staging_table.prpc_effective_construction_completion_date
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal_construction staging_table
LEFT JOIN history_octane.proposal_construction history_table
          ON staging_table.prpc_pid = history_table.prpc_pid
              AND staging_table.prpc_version = history_table.prpc_version
WHERE history_table.prpc_pid IS NULL
UNION ALL
SELECT history_table.prpc_pid
     , history_table.prpc_version + 1
     , history_table.prpc_proposal_pid
     , history_table.prpc_architectural_exhibits
     , history_table.prpc_feasibility_study
     , history_table.prpc_expected_months_to_complete
     , history_table.prpc_extension_needed
     , history_table.prpc_extension_period_months
     , history_table.prpc_any_utilities_inoperable
     , history_table.prpc_non_habitable_months
     , history_table.prpc_non_habitable_units
     , history_table.prpc_number_of_draws
     , history_table.prpc_construction_confirmed_start_date
     , history_table.prpc_loan_in_process_account_closed_date
     , history_table.prpc_mortgage_payment_reserves_required
     , history_table.prpc_estimated_permit_amount_applicable
     , history_table.prpc_contingency_reserve_required
     , history_table.prpc_extension_period_days
     , history_table.prpc_effective_construction_completion_date
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal_construction history_table
LEFT JOIN staging_octane.proposal_construction staging_table
          ON staging_table.prpc_pid = history_table.prpc_pid
WHERE staging_table.prpc_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.proposal_construction deleted_records
    WHERE deleted_records.prpc_pid = history_table.prpc_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100901', 0, '--finding records to insert into history_octane.config_note
SELECT staging_table.cn_pid
     , staging_table.cn_version
     , staging_table.cn_account_pid
     , staging_table.cn_create_datetime
     , staging_table.cn_content
     , staging_table.cn_author_unparsed_name
     , staging_table.cn_author_lender_user_pid
     , staging_table.cn_config_note_scope_type
     , staging_table.cn_scope_name
     , staging_table.cn_location_pid
     , staging_table.cn_smart_doc_pid
     , staging_table.cn_wf_process_pid
     , staging_table.cn_wf_step_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.config_note staging_table
LEFT JOIN history_octane.config_note history_table
          ON staging_table.cn_pid = history_table.cn_pid
              AND staging_table.cn_version = history_table.cn_version
WHERE history_table.cn_pid IS NULL
UNION ALL
SELECT history_table.cn_pid
     , history_table.cn_version + 1
     , history_table.cn_account_pid
     , history_table.cn_create_datetime
     , history_table.cn_content
     , history_table.cn_author_unparsed_name
     , history_table.cn_author_lender_user_pid
     , history_table.cn_config_note_scope_type
     , history_table.cn_scope_name
     , history_table.cn_location_pid
     , history_table.cn_smart_doc_pid
     , history_table.cn_wf_process_pid
     , history_table.cn_wf_step_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.config_note history_table
LEFT JOIN staging_octane.config_note staging_table
          ON staging_table.cn_pid = history_table.cn_pid
WHERE staging_table.cn_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.config_note deleted_records
    WHERE deleted_records.cn_pid = history_table.cn_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100317', 0, '--finding records to insert into history_octane.proposal
SELECT staging_table.prp_pid
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
     , staging_table.prp_hud_consultant
     , staging_table.prp_disclosure_action_type
     , staging_table.prp_financed_property_improvements
     , staging_table.prp_estimated_hard_construction_cost_amount
     , staging_table.prp_initial_uw_disposition_datetime
     , staging_table.prp_preapproval_uw_submit_datetime
     , staging_table.prp_preapproval_uw_disposition_datetime
     , staging_table.prp_down_payment_percent
     , staging_table.prp_cash_out_reason_investment_or_business_property
     , staging_table.prp_cash_out_reason_business_debt_or_debt_consolidation
     , staging_table.prp_non_business_cash_out_reason_acknowledged
     , staging_table.prp_va_energy_efficient_improvements_amount
     , staging_table.prp_proposed_additional_monthly_payment
     , staging_table.prp_term_borrower_intends_to_retain_property
     , staging_table.prp_loan_modification_agreement_executed_received_datetime
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal staging_table
LEFT JOIN history_octane.proposal history_table
          ON staging_table.prp_pid = history_table.prp_pid
              AND staging_table.prp_version = history_table.prp_version
WHERE history_table.prp_pid IS NULL
UNION ALL
SELECT history_table.prp_pid
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
     , history_table.prp_hud_consultant
     , history_table.prp_disclosure_action_type
     , history_table.prp_financed_property_improvements
     , history_table.prp_estimated_hard_construction_cost_amount
     , history_table.prp_initial_uw_disposition_datetime
     , history_table.prp_preapproval_uw_submit_datetime
     , history_table.prp_preapproval_uw_disposition_datetime
     , history_table.prp_down_payment_percent
     , history_table.prp_cash_out_reason_investment_or_business_property
     , history_table.prp_cash_out_reason_business_debt_or_debt_consolidation
     , history_table.prp_non_business_cash_out_reason_acknowledged
     , history_table.prp_va_energy_efficient_improvements_amount
     , history_table.prp_proposed_additional_monthly_payment
     , history_table.prp_term_borrower_intends_to_retain_property
     , history_table.prp_loan_modification_agreement_executed_received_datetime
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal history_table
LEFT JOIN staging_octane.proposal staging_table
          ON staging_table.prp_pid = history_table.prp_pid
WHERE staging_table.prp_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.proposal deleted_records
    WHERE deleted_records.prp_pid = history_table.prp_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100017', 0, '--finding records to insert into history_octane.deal_key_roles
SELECT staging_table.dkrs_pid
     , staging_table.dkrs_version
     , staging_table.dkrs_deal_pid
     , staging_table.dkrs_originator_lender_user_pid
     , staging_table.dkrs_originator_first_name
     , staging_table.dkrs_originator_last_name
     , staging_table.dkrs_originator_middle_name
     , staging_table.dkrs_originator_fmls_basic
     , staging_table.dkrs_originator_nmls_id
     , staging_table.dkrs_supplemental_originator_lender_user_pid
     , staging_table.dkrs_supplemental_originator_fmls
     , staging_table.dkrs_account_executive_lender_user_pid
     , staging_table.dkrs_account_executive_fmls
     , staging_table.dkrs_investor_conditions_lender_user_pid
     , staging_table.dkrs_investor_conditions_fmls
     , staging_table.dkrs_investor_stack_to_investor_lender_user_pid
     , staging_table.dkrs_investor_stack_to_investor_fmls
     , staging_table.dkrs_collateral_to_custodian_lender_user_pid
     , staging_table.dkrs_collateral_to_custodian_fmls
     , staging_table.dkrs_collateral_to_investor_lender_user_pid
     , staging_table.dkrs_collateral_to_investor_fmls
     , staging_table.dkrs_transaction_assistant_lender_user_pid
     , staging_table.dkrs_transaction_assistant_fmls
     , staging_table.dkrs_final_documents_to_investor_lender_user_pid
     , staging_table.dkrs_final_documents_to_investor_fmls
     , staging_table.dkrs_government_insurance_lender_user_pid
     , staging_table.dkrs_government_insurance_fmls
     , staging_table.dkrs_funder_lender_user_pid
     , staging_table.dkrs_funder_fmls
     , staging_table.dkrs_processor_lender_user_pid
     , staging_table.dkrs_processor_fmls
     , staging_table.dkrs_underwriter_lender_user_pid
     , staging_table.dkrs_underwriter_fmls
     , staging_table.dkrs_project_underwriter_lender_user_pid
     , staging_table.dkrs_project_underwriter_fmls
     , staging_table.dkrs_closing_doc_specialist_lender_user_pid
     , staging_table.dkrs_closing_doc_specialist_fmls
     , staging_table.dkrs_wholesale_client_advocate_lender_user_pid
     , staging_table.dkrs_wholesale_client_advocate_fmls
     , staging_table.dkrs_closing_scheduler_lender_user_pid
     , staging_table.dkrs_closing_scheduler_fmls
     , staging_table.dkrs_collateral_underwriter_lender_user_pid
     , staging_table.dkrs_collateral_underwriter_fmls
     , staging_table.dkrs_correspondent_client_advocate_lender_user_pid
     , staging_table.dkrs_correspondent_client_advocate_fmls
     , staging_table.dkrs_flood_insurance_specialist_lender_user_pid
     , staging_table.dkrs_flood_insurance_specialist_fmls
     , staging_table.dkrs_hoa_specialist_lender_user_pid
     , staging_table.dkrs_hoa_specialist_fmls
     , staging_table.dkrs_hoi_specialist_lender_user_pid
     , staging_table.dkrs_hoi_specialist_fmls
     , staging_table.dkrs_ho6_specialist_lender_user_pid
     , staging_table.dkrs_ho6_specialist_fmls
     , staging_table.dkrs_hud_va_lender_officer_lender_user_pid
     , staging_table.dkrs_hud_va_lender_officer_fmls
     , staging_table.dkrs_loan_officer_assistant_lender_user_pid
     , staging_table.dkrs_loan_officer_assistant_fmls
     , staging_table.dkrs_loan_payoff_specialist_lender_user_pid
     , staging_table.dkrs_loan_payoff_specialist_fmls
     , staging_table.dkrs_subordination_specialist_lender_user_pid
     , staging_table.dkrs_subordination_specialist_fmls
     , staging_table.dkrs_title_specialist_lender_user_pid
     , staging_table.dkrs_title_specialist_fmls
     , staging_table.dkrs_underwriting_manager_lender_user_pid
     , staging_table.dkrs_underwriting_manager_fmls
     , staging_table.dkrs_va_specialist_lender_user_pid
     , staging_table.dkrs_va_specialist_fmls
     , staging_table.dkrs_verbal_voe_specialist_lender_user_pid
     , staging_table.dkrs_verbal_voe_specialist_fmls
     , staging_table.dkrs_voe_specialist_lender_user_pid
     , staging_table.dkrs_voe_specialist_fmls
     , staging_table.dkrs_wire_specialist_lender_user_pid
     , staging_table.dkrs_wire_specialist_fmls
     , staging_table.dkrs_internal_construction_manager_lender_user_pid
     , staging_table.dkrs_internal_construction_manager_fmls
     , staging_table.dkrs_review_requester_1_lender_user_pid
     , staging_table.dkrs_review_requester_1_fmls
     , staging_table.dkrs_review_requester_2_lender_user_pid
     , staging_table.dkrs_review_requester_2_fmls
     , staging_table.dkrs_review_requester_3_lender_user_pid
     , staging_table.dkrs_review_requester_3_fmls
     , staging_table.dkrs_review_requester_4_lender_user_pid
     , staging_table.dkrs_review_requester_4_fmls
     , staging_table.dkrs_review_requester_5_lender_user_pid
     , staging_table.dkrs_review_requester_5_fmls
     , staging_table.dkrs_referring_associate_lender_user_pid
     , staging_table.dkrs_referring_associate_fmls
     , staging_table.dkrs_production_manager_lender_user_pid
     , staging_table.dkrs_production_manager_fmls
     , staging_table.dkrs_contract_processor_lender_user_pid
     , staging_table.dkrs_contract_processor_fmls
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.deal_key_roles staging_table
LEFT JOIN history_octane.deal_key_roles history_table
          ON staging_table.dkrs_pid = history_table.dkrs_pid
              AND staging_table.dkrs_version = history_table.dkrs_version
WHERE history_table.dkrs_pid IS NULL
UNION ALL
SELECT history_table.dkrs_pid
     , history_table.dkrs_version + 1
     , history_table.dkrs_deal_pid
     , history_table.dkrs_originator_lender_user_pid
     , history_table.dkrs_originator_first_name
     , history_table.dkrs_originator_last_name
     , history_table.dkrs_originator_middle_name
     , history_table.dkrs_originator_fmls_basic
     , history_table.dkrs_originator_nmls_id
     , history_table.dkrs_supplemental_originator_lender_user_pid
     , history_table.dkrs_supplemental_originator_fmls
     , history_table.dkrs_account_executive_lender_user_pid
     , history_table.dkrs_account_executive_fmls
     , history_table.dkrs_investor_conditions_lender_user_pid
     , history_table.dkrs_investor_conditions_fmls
     , history_table.dkrs_investor_stack_to_investor_lender_user_pid
     , history_table.dkrs_investor_stack_to_investor_fmls
     , history_table.dkrs_collateral_to_custodian_lender_user_pid
     , history_table.dkrs_collateral_to_custodian_fmls
     , history_table.dkrs_collateral_to_investor_lender_user_pid
     , history_table.dkrs_collateral_to_investor_fmls
     , history_table.dkrs_transaction_assistant_lender_user_pid
     , history_table.dkrs_transaction_assistant_fmls
     , history_table.dkrs_final_documents_to_investor_lender_user_pid
     , history_table.dkrs_final_documents_to_investor_fmls
     , history_table.dkrs_government_insurance_lender_user_pid
     , history_table.dkrs_government_insurance_fmls
     , history_table.dkrs_funder_lender_user_pid
     , history_table.dkrs_funder_fmls
     , history_table.dkrs_processor_lender_user_pid
     , history_table.dkrs_processor_fmls
     , history_table.dkrs_underwriter_lender_user_pid
     , history_table.dkrs_underwriter_fmls
     , history_table.dkrs_project_underwriter_lender_user_pid
     , history_table.dkrs_project_underwriter_fmls
     , history_table.dkrs_closing_doc_specialist_lender_user_pid
     , history_table.dkrs_closing_doc_specialist_fmls
     , history_table.dkrs_wholesale_client_advocate_lender_user_pid
     , history_table.dkrs_wholesale_client_advocate_fmls
     , history_table.dkrs_closing_scheduler_lender_user_pid
     , history_table.dkrs_closing_scheduler_fmls
     , history_table.dkrs_collateral_underwriter_lender_user_pid
     , history_table.dkrs_collateral_underwriter_fmls
     , history_table.dkrs_correspondent_client_advocate_lender_user_pid
     , history_table.dkrs_correspondent_client_advocate_fmls
     , history_table.dkrs_flood_insurance_specialist_lender_user_pid
     , history_table.dkrs_flood_insurance_specialist_fmls
     , history_table.dkrs_hoa_specialist_lender_user_pid
     , history_table.dkrs_hoa_specialist_fmls
     , history_table.dkrs_hoi_specialist_lender_user_pid
     , history_table.dkrs_hoi_specialist_fmls
     , history_table.dkrs_ho6_specialist_lender_user_pid
     , history_table.dkrs_ho6_specialist_fmls
     , history_table.dkrs_hud_va_lender_officer_lender_user_pid
     , history_table.dkrs_hud_va_lender_officer_fmls
     , history_table.dkrs_loan_officer_assistant_lender_user_pid
     , history_table.dkrs_loan_officer_assistant_fmls
     , history_table.dkrs_loan_payoff_specialist_lender_user_pid
     , history_table.dkrs_loan_payoff_specialist_fmls
     , history_table.dkrs_subordination_specialist_lender_user_pid
     , history_table.dkrs_subordination_specialist_fmls
     , history_table.dkrs_title_specialist_lender_user_pid
     , history_table.dkrs_title_specialist_fmls
     , history_table.dkrs_underwriting_manager_lender_user_pid
     , history_table.dkrs_underwriting_manager_fmls
     , history_table.dkrs_va_specialist_lender_user_pid
     , history_table.dkrs_va_specialist_fmls
     , history_table.dkrs_verbal_voe_specialist_lender_user_pid
     , history_table.dkrs_verbal_voe_specialist_fmls
     , history_table.dkrs_voe_specialist_lender_user_pid
     , history_table.dkrs_voe_specialist_fmls
     , history_table.dkrs_wire_specialist_lender_user_pid
     , history_table.dkrs_wire_specialist_fmls
     , history_table.dkrs_internal_construction_manager_lender_user_pid
     , history_table.dkrs_internal_construction_manager_fmls
     , history_table.dkrs_review_requester_1_lender_user_pid
     , history_table.dkrs_review_requester_1_fmls
     , history_table.dkrs_review_requester_2_lender_user_pid
     , history_table.dkrs_review_requester_2_fmls
     , history_table.dkrs_review_requester_3_lender_user_pid
     , history_table.dkrs_review_requester_3_fmls
     , history_table.dkrs_review_requester_4_lender_user_pid
     , history_table.dkrs_review_requester_4_fmls
     , history_table.dkrs_review_requester_5_lender_user_pid
     , history_table.dkrs_review_requester_5_fmls
     , history_table.dkrs_referring_associate_lender_user_pid
     , history_table.dkrs_referring_associate_fmls
     , history_table.dkrs_production_manager_lender_user_pid
     , history_table.dkrs_production_manager_fmls
     , history_table.dkrs_contract_processor_lender_user_pid
     , history_table.dkrs_contract_processor_fmls
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.deal_key_roles history_table
LEFT JOIN staging_octane.deal_key_roles staging_table
          ON staging_table.dkrs_pid = history_table.dkrs_pid
WHERE staging_table.dkrs_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.deal_key_roles deleted_records
    WHERE deleted_records.dkrs_pid = history_table.dkrs_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100130', 0, '--finding records to insert into history_octane.business_income
SELECT staging_table.bui_pid
     , staging_table.bui_version
     , staging_table.bui_borrower_income_pid
     , staging_table.bui_business_income_type
     , staging_table.bui_business_disposition_type
     , staging_table.bui_company_ein
     , staging_table.bui_estimated_net_income_amount
     , staging_table.bui_estimated_mode
     , staging_table.bui_worksheet_monthly_total_amount
     , staging_table.bui_monthly_total_amount
     , staging_table.bui_borrower_income_percent
     , staging_table.bui_calc_method_type
     , staging_table.bui_common_year1_year
     , staging_table.bui_common_year1_year_include
     , staging_table.bui_common_year1_from_date
     , staging_table.bui_common_year1_through_date
     , staging_table.bui_common_year1_months
     , staging_table.bui_common_year1_annual_total_amount
     , staging_table.bui_common_year1_monthly_total_amount
     , staging_table.bui_common_year2_year
     , staging_table.bui_common_year2_year_include
     , staging_table.bui_common_year2_from_date
     , staging_table.bui_common_year2_through_date
     , staging_table.bui_common_year2_months
     , staging_table.bui_common_year2_annual_total_amount
     , staging_table.bui_common_year2_monthly_total_amount
     , staging_table.bui_common_year3_year
     , staging_table.bui_common_year3_year_include
     , staging_table.bui_common_year3_from_date
     , staging_table.bui_common_year3_through_date
     , staging_table.bui_common_year3_months
     , staging_table.bui_common_year3_annual_total_amount
     , staging_table.bui_common_year3_monthly_total_amount
     , staging_table.bui_sole_year1_gross_receipts
     , staging_table.bui_sole_year1_other_income_loss_exp
     , staging_table.bui_sole_year1_depletion
     , staging_table.bui_sole_year1_depreciation
     , staging_table.bui_sole_year1_meal_exclusions
     , staging_table.bui_sole_year1_business_use_home
     , staging_table.bui_sole_year1_amortization_loss
     , staging_table.bui_sole_year1_business_miles
     , staging_table.bui_sole_year1_depreciation_mile
     , staging_table.bui_sole_year1_mileage_depreciation
     , staging_table.bui_sole_year2_gross_receipts
     , staging_table.bui_sole_year2_other_income_loss_exp
     , staging_table.bui_sole_year2_depletion
     , staging_table.bui_sole_year2_depreciation
     , staging_table.bui_sole_year2_meal_exclusions
     , staging_table.bui_sole_year2_business_use_home
     , staging_table.bui_sole_year2_amortization_loss
     , staging_table.bui_sole_year2_business_miles
     , staging_table.bui_sole_year2_depreciation_mile
     , staging_table.bui_sole_year2_mileage_depreciation
     , staging_table.bui_sole_year3_gross_receipts
     , staging_table.bui_sole_year3_other_income_loss_exp
     , staging_table.bui_sole_year3_depletion
     , staging_table.bui_sole_year3_depreciation
     , staging_table.bui_sole_year3_meal_exclusions
     , staging_table.bui_sole_year3_business_use_home
     , staging_table.bui_sole_year3_amortization_loss
     , staging_table.bui_sole_year3_business_miles
     , staging_table.bui_sole_year3_depreciation_mile
     , staging_table.bui_sole_year3_mileage_depreciation
     , staging_table.bui_partner_year1_amortization_loss
     , staging_table.bui_partner_year1_depletion
     , staging_table.bui_partner_year1_depreciation
     , staging_table.bui_partner_year1_guaranteed_payments
     , staging_table.bui_partner_year1_meals_exclusion
     , staging_table.bui_partner_year1_net_rental_income_loss
     , staging_table.bui_partner_year1_notes_payable_less_year
     , staging_table.bui_partner_year1_ordinary_income_loss
     , staging_table.bui_partner_year1_other_income_loss
     , staging_table.bui_partner_year1_ownership_percent
     , staging_table.bui_partner_year1_form_k_1_total
     , staging_table.bui_partner_year1_form_1065_subtotal
     , staging_table.bui_partner_year1_form_1065_total
     , staging_table.bui_partner_year2_amortization_loss
     , staging_table.bui_partner_year2_depletion
     , staging_table.bui_partner_year2_depreciation
     , staging_table.bui_partner_year2_guaranteed_payments
     , staging_table.bui_partner_year2_meals_exclusion
     , staging_table.bui_partner_year2_net_rental_income_loss
     , staging_table.bui_partner_year2_notes_payable_less_year
     , staging_table.bui_partner_year2_ordinary_income_loss
     , staging_table.bui_partner_year2_other_income_loss
     , staging_table.bui_partner_year2_ownership_percent
     , staging_table.bui_partner_year2_form_k_1_total
     , staging_table.bui_partner_year2_form_1065_subtotal
     , staging_table.bui_partner_year2_form_1065_total
     , staging_table.bui_partner_year3_amortization_loss
     , staging_table.bui_partner_year3_depletion
     , staging_table.bui_partner_year3_depreciation
     , staging_table.bui_partner_year3_guaranteed_payments
     , staging_table.bui_partner_year3_meals_exclusion
     , staging_table.bui_partner_year3_net_rental_income_loss
     , staging_table.bui_partner_year3_notes_payable_less_year
     , staging_table.bui_partner_year3_ordinary_income_loss
     , staging_table.bui_partner_year3_other_income_loss
     , staging_table.bui_partner_year3_ownership_percent
     , staging_table.bui_partner_year3_form_k_1_total
     , staging_table.bui_partner_year3_form_1065_subtotal
     , staging_table.bui_partner_year3_form_1065_total
     , staging_table.bui_form_1065_available
     , staging_table.bui_scorp_year1_ordinary_income_loss
     , staging_table.bui_scorp_year1_net_rental_income_loss
     , staging_table.bui_scorp_year1_other_income_loss
     , staging_table.bui_scorp_year1_depletion
     , staging_table.bui_scorp_year1_depreciation
     , staging_table.bui_scorp_year1_amortization_loss
     , staging_table.bui_scorp_year1_notes_payable_less_year
     , staging_table.bui_scorp_year1_meals_exclusion
     , staging_table.bui_scorp_year1_ownership_percent
     , staging_table.bui_scorp_year1_form_k_1_total
     , staging_table.bui_scorp_year1_form_1120s_subtotal
     , staging_table.bui_scorp_year1_form_1120s_total
     , staging_table.bui_scorp_year2_ordinary_income_loss
     , staging_table.bui_scorp_year2_net_rental_income_loss
     , staging_table.bui_scorp_year2_other_income_loss
     , staging_table.bui_scorp_year2_depletion
     , staging_table.bui_scorp_year2_depreciation
     , staging_table.bui_scorp_year2_amortization_loss
     , staging_table.bui_scorp_year2_notes_payable_less_year
     , staging_table.bui_scorp_year2_meals_exclusion
     , staging_table.bui_scorp_year2_ownership_percent
     , staging_table.bui_scorp_year2_form_k_1_total
     , staging_table.bui_scorp_year2_form_1120s_subtotal
     , staging_table.bui_scorp_year2_form_1120s_total
     , staging_table.bui_scorp_year3_ordinary_income_loss
     , staging_table.bui_scorp_year3_net_rental_income_loss
     , staging_table.bui_scorp_year3_other_income_loss
     , staging_table.bui_scorp_year3_depletion
     , staging_table.bui_scorp_year3_depreciation
     , staging_table.bui_scorp_year3_amortization_loss
     , staging_table.bui_scorp_year3_notes_payable_less_year
     , staging_table.bui_scorp_year3_meals_exclusion
     , staging_table.bui_scorp_year3_ownership_percent
     , staging_table.bui_scorp_year3_form_k_1_total
     , staging_table.bui_scorp_year3_form_1120s_subtotal
     , staging_table.bui_scorp_year3_form_1120s_total
     , staging_table.bui_form_1120s_available
     , staging_table.bui_corp_year1_taxable_income
     , staging_table.bui_corp_year1_total_tax
     , staging_table.bui_corp_year1_gain_loss
     , staging_table.bui_corp_year1_other_income_loss
     , staging_table.bui_corp_year1_depreciation
     , staging_table.bui_corp_year1_depletion
     , staging_table.bui_corp_year1_domestic_production_activities
     , staging_table.bui_corp_year1_other_deductions
     , staging_table.bui_corp_year1_net_operating_loss_special_deductions
     , staging_table.bui_corp_year1_notes_payable_less_one_year
     , staging_table.bui_corp_year1_meals_exclusion
     , staging_table.bui_corp_year1_dividends_paid_to_borrower
     , staging_table.bui_corp_year1_annual_subtotal
     , staging_table.bui_corp_year1_ownership_percent
     , staging_table.bui_corp_year1_annual_subtotal_ownership_applied
     , staging_table.bui_corp_year2_taxable_income
     , staging_table.bui_corp_year2_total_tax
     , staging_table.bui_corp_year2_gain_loss
     , staging_table.bui_corp_year2_other_income_loss
     , staging_table.bui_corp_year2_depreciation
     , staging_table.bui_corp_year2_depletion
     , staging_table.bui_corp_year2_domestic_production_activities
     , staging_table.bui_corp_year2_other_deductions
     , staging_table.bui_corp_year2_net_operating_loss_special_deductions
     , staging_table.bui_corp_year2_notes_payable_less_one_year
     , staging_table.bui_corp_year2_meals_exclusion
     , staging_table.bui_corp_year2_dividends_paid_to_borrower
     , staging_table.bui_corp_year2_annual_subtotal
     , staging_table.bui_corp_year2_ownership_percent
     , staging_table.bui_corp_year2_annual_subtotal_ownership_applied
     , staging_table.bui_corp_year3_taxable_income
     , staging_table.bui_corp_year3_total_tax
     , staging_table.bui_corp_year3_gain_loss
     , staging_table.bui_corp_year3_other_income_loss
     , staging_table.bui_corp_year3_depreciation
     , staging_table.bui_corp_year3_depletion
     , staging_table.bui_corp_year3_domestic_production_activities
     , staging_table.bui_corp_year3_other_deductions
     , staging_table.bui_corp_year3_net_operating_loss_special_deductions
     , staging_table.bui_corp_year3_notes_payable_less_one_year
     , staging_table.bui_corp_year3_meals_exclusion
     , staging_table.bui_corp_year3_dividends_paid_to_borrower
     , staging_table.bui_corp_year3_annual_subtotal
     , staging_table.bui_corp_year3_ownership_percent
     , staging_table.bui_corp_year3_annual_subtotal_ownership_applied
     , staging_table.bui_sch_f_year1_specific_income_loss
     , staging_table.bui_sch_f_year1_nonrecurring_income_loss
     , staging_table.bui_sch_f_year1_depreciation
     , staging_table.bui_sch_f_year1_amortization_loss_depletion
     , staging_table.bui_sch_f_year1_business_use_home
     , staging_table.bui_sch_f_year2_specific_income_loss
     , staging_table.bui_sch_f_year2_nonrecurring_income_loss
     , staging_table.bui_sch_f_year2_depreciation
     , staging_table.bui_sch_f_year2_amortization_loss_depletion
     , staging_table.bui_sch_f_year2_business_use_home
     , staging_table.bui_sch_f_year3_specific_income_loss
     , staging_table.bui_sch_f_year3_nonrecurring_income_loss
     , staging_table.bui_sch_f_year3_depreciation
     , staging_table.bui_sch_f_year3_amortization_loss_depletion
     , staging_table.bui_sch_f_year3_business_use_home
     , staging_table.bui_underwriter_comments
     , staging_table.bui_borrower_title_type
     , staging_table.bui_borrower_title_other_description
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.business_income staging_table
LEFT JOIN history_octane.business_income history_table
          ON staging_table.bui_pid = history_table.bui_pid
              AND staging_table.bui_version = history_table.bui_version
WHERE history_table.bui_pid IS NULL
UNION ALL
SELECT history_table.bui_pid
     , history_table.bui_version + 1
     , history_table.bui_borrower_income_pid
     , history_table.bui_business_income_type
     , history_table.bui_business_disposition_type
     , history_table.bui_company_ein
     , history_table.bui_estimated_net_income_amount
     , history_table.bui_estimated_mode
     , history_table.bui_worksheet_monthly_total_amount
     , history_table.bui_monthly_total_amount
     , history_table.bui_borrower_income_percent
     , history_table.bui_calc_method_type
     , history_table.bui_common_year1_year
     , history_table.bui_common_year1_year_include
     , history_table.bui_common_year1_from_date
     , history_table.bui_common_year1_through_date
     , history_table.bui_common_year1_months
     , history_table.bui_common_year1_annual_total_amount
     , history_table.bui_common_year1_monthly_total_amount
     , history_table.bui_common_year2_year
     , history_table.bui_common_year2_year_include
     , history_table.bui_common_year2_from_date
     , history_table.bui_common_year2_through_date
     , history_table.bui_common_year2_months
     , history_table.bui_common_year2_annual_total_amount
     , history_table.bui_common_year2_monthly_total_amount
     , history_table.bui_common_year3_year
     , history_table.bui_common_year3_year_include
     , history_table.bui_common_year3_from_date
     , history_table.bui_common_year3_through_date
     , history_table.bui_common_year3_months
     , history_table.bui_common_year3_annual_total_amount
     , history_table.bui_common_year3_monthly_total_amount
     , history_table.bui_sole_year1_gross_receipts
     , history_table.bui_sole_year1_other_income_loss_exp
     , history_table.bui_sole_year1_depletion
     , history_table.bui_sole_year1_depreciation
     , history_table.bui_sole_year1_meal_exclusions
     , history_table.bui_sole_year1_business_use_home
     , history_table.bui_sole_year1_amortization_loss
     , history_table.bui_sole_year1_business_miles
     , history_table.bui_sole_year1_depreciation_mile
     , history_table.bui_sole_year1_mileage_depreciation
     , history_table.bui_sole_year2_gross_receipts
     , history_table.bui_sole_year2_other_income_loss_exp
     , history_table.bui_sole_year2_depletion
     , history_table.bui_sole_year2_depreciation
     , history_table.bui_sole_year2_meal_exclusions
     , history_table.bui_sole_year2_business_use_home
     , history_table.bui_sole_year2_amortization_loss
     , history_table.bui_sole_year2_business_miles
     , history_table.bui_sole_year2_depreciation_mile
     , history_table.bui_sole_year2_mileage_depreciation
     , history_table.bui_sole_year3_gross_receipts
     , history_table.bui_sole_year3_other_income_loss_exp
     , history_table.bui_sole_year3_depletion
     , history_table.bui_sole_year3_depreciation
     , history_table.bui_sole_year3_meal_exclusions
     , history_table.bui_sole_year3_business_use_home
     , history_table.bui_sole_year3_amortization_loss
     , history_table.bui_sole_year3_business_miles
     , history_table.bui_sole_year3_depreciation_mile
     , history_table.bui_sole_year3_mileage_depreciation
     , history_table.bui_partner_year1_amortization_loss
     , history_table.bui_partner_year1_depletion
     , history_table.bui_partner_year1_depreciation
     , history_table.bui_partner_year1_guaranteed_payments
     , history_table.bui_partner_year1_meals_exclusion
     , history_table.bui_partner_year1_net_rental_income_loss
     , history_table.bui_partner_year1_notes_payable_less_year
     , history_table.bui_partner_year1_ordinary_income_loss
     , history_table.bui_partner_year1_other_income_loss
     , history_table.bui_partner_year1_ownership_percent
     , history_table.bui_partner_year1_form_k_1_total
     , history_table.bui_partner_year1_form_1065_subtotal
     , history_table.bui_partner_year1_form_1065_total
     , history_table.bui_partner_year2_amortization_loss
     , history_table.bui_partner_year2_depletion
     , history_table.bui_partner_year2_depreciation
     , history_table.bui_partner_year2_guaranteed_payments
     , history_table.bui_partner_year2_meals_exclusion
     , history_table.bui_partner_year2_net_rental_income_loss
     , history_table.bui_partner_year2_notes_payable_less_year
     , history_table.bui_partner_year2_ordinary_income_loss
     , history_table.bui_partner_year2_other_income_loss
     , history_table.bui_partner_year2_ownership_percent
     , history_table.bui_partner_year2_form_k_1_total
     , history_table.bui_partner_year2_form_1065_subtotal
     , history_table.bui_partner_year2_form_1065_total
     , history_table.bui_partner_year3_amortization_loss
     , history_table.bui_partner_year3_depletion
     , history_table.bui_partner_year3_depreciation
     , history_table.bui_partner_year3_guaranteed_payments
     , history_table.bui_partner_year3_meals_exclusion
     , history_table.bui_partner_year3_net_rental_income_loss
     , history_table.bui_partner_year3_notes_payable_less_year
     , history_table.bui_partner_year3_ordinary_income_loss
     , history_table.bui_partner_year3_other_income_loss
     , history_table.bui_partner_year3_ownership_percent
     , history_table.bui_partner_year3_form_k_1_total
     , history_table.bui_partner_year3_form_1065_subtotal
     , history_table.bui_partner_year3_form_1065_total
     , history_table.bui_form_1065_available
     , history_table.bui_scorp_year1_ordinary_income_loss
     , history_table.bui_scorp_year1_net_rental_income_loss
     , history_table.bui_scorp_year1_other_income_loss
     , history_table.bui_scorp_year1_depletion
     , history_table.bui_scorp_year1_depreciation
     , history_table.bui_scorp_year1_amortization_loss
     , history_table.bui_scorp_year1_notes_payable_less_year
     , history_table.bui_scorp_year1_meals_exclusion
     , history_table.bui_scorp_year1_ownership_percent
     , history_table.bui_scorp_year1_form_k_1_total
     , history_table.bui_scorp_year1_form_1120s_subtotal
     , history_table.bui_scorp_year1_form_1120s_total
     , history_table.bui_scorp_year2_ordinary_income_loss
     , history_table.bui_scorp_year2_net_rental_income_loss
     , history_table.bui_scorp_year2_other_income_loss
     , history_table.bui_scorp_year2_depletion
     , history_table.bui_scorp_year2_depreciation
     , history_table.bui_scorp_year2_amortization_loss
     , history_table.bui_scorp_year2_notes_payable_less_year
     , history_table.bui_scorp_year2_meals_exclusion
     , history_table.bui_scorp_year2_ownership_percent
     , history_table.bui_scorp_year2_form_k_1_total
     , history_table.bui_scorp_year2_form_1120s_subtotal
     , history_table.bui_scorp_year2_form_1120s_total
     , history_table.bui_scorp_year3_ordinary_income_loss
     , history_table.bui_scorp_year3_net_rental_income_loss
     , history_table.bui_scorp_year3_other_income_loss
     , history_table.bui_scorp_year3_depletion
     , history_table.bui_scorp_year3_depreciation
     , history_table.bui_scorp_year3_amortization_loss
     , history_table.bui_scorp_year3_notes_payable_less_year
     , history_table.bui_scorp_year3_meals_exclusion
     , history_table.bui_scorp_year3_ownership_percent
     , history_table.bui_scorp_year3_form_k_1_total
     , history_table.bui_scorp_year3_form_1120s_subtotal
     , history_table.bui_scorp_year3_form_1120s_total
     , history_table.bui_form_1120s_available
     , history_table.bui_corp_year1_taxable_income
     , history_table.bui_corp_year1_total_tax
     , history_table.bui_corp_year1_gain_loss
     , history_table.bui_corp_year1_other_income_loss
     , history_table.bui_corp_year1_depreciation
     , history_table.bui_corp_year1_depletion
     , history_table.bui_corp_year1_domestic_production_activities
     , history_table.bui_corp_year1_other_deductions
     , history_table.bui_corp_year1_net_operating_loss_special_deductions
     , history_table.bui_corp_year1_notes_payable_less_one_year
     , history_table.bui_corp_year1_meals_exclusion
     , history_table.bui_corp_year1_dividends_paid_to_borrower
     , history_table.bui_corp_year1_annual_subtotal
     , history_table.bui_corp_year1_ownership_percent
     , history_table.bui_corp_year1_annual_subtotal_ownership_applied
     , history_table.bui_corp_year2_taxable_income
     , history_table.bui_corp_year2_total_tax
     , history_table.bui_corp_year2_gain_loss
     , history_table.bui_corp_year2_other_income_loss
     , history_table.bui_corp_year2_depreciation
     , history_table.bui_corp_year2_depletion
     , history_table.bui_corp_year2_domestic_production_activities
     , history_table.bui_corp_year2_other_deductions
     , history_table.bui_corp_year2_net_operating_loss_special_deductions
     , history_table.bui_corp_year2_notes_payable_less_one_year
     , history_table.bui_corp_year2_meals_exclusion
     , history_table.bui_corp_year2_dividends_paid_to_borrower
     , history_table.bui_corp_year2_annual_subtotal
     , history_table.bui_corp_year2_ownership_percent
     , history_table.bui_corp_year2_annual_subtotal_ownership_applied
     , history_table.bui_corp_year3_taxable_income
     , history_table.bui_corp_year3_total_tax
     , history_table.bui_corp_year3_gain_loss
     , history_table.bui_corp_year3_other_income_loss
     , history_table.bui_corp_year3_depreciation
     , history_table.bui_corp_year3_depletion
     , history_table.bui_corp_year3_domestic_production_activities
     , history_table.bui_corp_year3_other_deductions
     , history_table.bui_corp_year3_net_operating_loss_special_deductions
     , history_table.bui_corp_year3_notes_payable_less_one_year
     , history_table.bui_corp_year3_meals_exclusion
     , history_table.bui_corp_year3_dividends_paid_to_borrower
     , history_table.bui_corp_year3_annual_subtotal
     , history_table.bui_corp_year3_ownership_percent
     , history_table.bui_corp_year3_annual_subtotal_ownership_applied
     , history_table.bui_sch_f_year1_specific_income_loss
     , history_table.bui_sch_f_year1_nonrecurring_income_loss
     , history_table.bui_sch_f_year1_depreciation
     , history_table.bui_sch_f_year1_amortization_loss_depletion
     , history_table.bui_sch_f_year1_business_use_home
     , history_table.bui_sch_f_year2_specific_income_loss
     , history_table.bui_sch_f_year2_nonrecurring_income_loss
     , history_table.bui_sch_f_year2_depreciation
     , history_table.bui_sch_f_year2_amortization_loss_depletion
     , history_table.bui_sch_f_year2_business_use_home
     , history_table.bui_sch_f_year3_specific_income_loss
     , history_table.bui_sch_f_year3_nonrecurring_income_loss
     , history_table.bui_sch_f_year3_depreciation
     , history_table.bui_sch_f_year3_amortization_loss_depletion
     , history_table.bui_sch_f_year3_business_use_home
     , history_table.bui_underwriter_comments
     , history_table.bui_borrower_title_type
     , history_table.bui_borrower_title_other_description
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.business_income history_table
LEFT JOIN staging_octane.business_income staging_table
          ON staging_table.bui_pid = history_table.bui_pid
WHERE staging_table.bui_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.business_income deleted_records
    WHERE deleted_records.bui_pid = history_table.bui_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100340', 0, '--finding records to insert into history_octane.tax_transcript_request
SELECT staging_table.ttr_pid
     , staging_table.ttr_version
     , staging_table.ttr_deal_pid
     , staging_table.ttr_create_datetime
     , staging_table.ttr_requester_agent_type
     , staging_table.ttr_requester_lender_user_pid
     , staging_table.ttr_requester_unparsed_name
     , staging_table.ttr_mismo_version_type
     , staging_table.ttr_credit_request_type
     , staging_table.ttr_request_error_messages
     , staging_table.ttr_request_success_messages
     , staging_table.ttr_tracking_number
     , staging_table.ttr_tax_transcript_request_status_type
     , staging_table.ttr_update_reason
     , staging_table.ttr_last_status_query_datetime
     , staging_table.ttr_signed_4506t_deal_file_pid
     , staging_table.ttr_company
     , staging_table.ttr_company_name
     , staging_table.ttr_company_city
     , staging_table.ttr_company_country
     , staging_table.ttr_company_postal_code
     , staging_table.ttr_company_state
     , staging_table.ttr_company_street1
     , staging_table.ttr_company_street2
     , staging_table.ttr_company_ein
     , staging_table.ttr_borrower1_pid
     , staging_table.ttr_borrower1_first_name
     , staging_table.ttr_borrower1_middle_name
     , staging_table.ttr_borrower1_last_name
     , staging_table.ttr_borrower1_name_suffix
     , staging_table.ttr_borrower1_birth_date
     , staging_table.ttr_borrower1_current_city
     , staging_table.ttr_borrower1_current_country
     , staging_table.ttr_borrower1_current_postal_code
     , staging_table.ttr_borrower1_current_state
     , staging_table.ttr_borrower1_current_street1
     , staging_table.ttr_borrower1_current_street2
     , staging_table.ttr_borrower1_prior_city
     , staging_table.ttr_borrower1_prior_country
     , staging_table.ttr_borrower1_prior_postal_code
     , staging_table.ttr_borrower1_prior_state
     , staging_table.ttr_borrower1_prior_street1
     , staging_table.ttr_borrower1_prior_street2
     , staging_table.ttr_borrower1_monthly_income_amount
     , staging_table.ttr_borrower2_pid
     , staging_table.ttr_borrower2_first_name
     , staging_table.ttr_borrower2_middle_name
     , staging_table.ttr_borrower2_last_name
     , staging_table.ttr_borrower2_name_suffix
     , staging_table.ttr_borrower2_birth_date
     , staging_table.ttr_borrower2_current_city
     , staging_table.ttr_borrower2_current_country
     , staging_table.ttr_borrower2_current_postal_code
     , staging_table.ttr_borrower2_current_state
     , staging_table.ttr_borrower2_current_street1
     , staging_table.ttr_borrower2_current_street2
     , staging_table.ttr_borrower2_prior_city
     , staging_table.ttr_borrower2_prior_country
     , staging_table.ttr_borrower2_prior_postal_code
     , staging_table.ttr_borrower2_prior_state
     , staging_table.ttr_borrower2_prior_street1
     , staging_table.ttr_borrower2_prior_street2
     , staging_table.ttr_borrower2_monthly_income_amount
     , staging_table.ttr_year1
     , staging_table.ttr_year2
     , staging_table.ttr_year3
     , staging_table.ttr_year4
     , staging_table.ttr_include_w_2
     , staging_table.ttr_include_1099
     , staging_table.ttr_include_1040
     , staging_table.ttr_include_1040_return_transcript
     , staging_table.ttr_include_1040_account_transcript
     , staging_table.ttr_include_1040_record_of_account
     , staging_table.ttr_include_1065
     , staging_table.ttr_include_1065_return_transcript
     , staging_table.ttr_include_1065_account_transcript
     , staging_table.ttr_include_1065_record_of_account
     , staging_table.ttr_include_1120
     , staging_table.ttr_include_1120_return_transcript
     , staging_table.ttr_include_1120_account_transcript
     , staging_table.ttr_include_1120_record_of_account
     , staging_table.ttr_archived
     , staging_table.ttr_company_phone
     , staging_table.ttr_company_phone_extension
     , staging_table.ttr_business_ownership_type
     , staging_table.ttr_include_1120s
     , staging_table.ttr_include_1120s_return_transcript
     , staging_table.ttr_include_1120s_account_transcript
     , staging_table.ttr_include_1120s_record_of_account
     , staging_table.ttr_business_income_borrower_title
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.tax_transcript_request staging_table
LEFT JOIN history_octane.tax_transcript_request history_table
          ON staging_table.ttr_pid = history_table.ttr_pid
              AND staging_table.ttr_version = history_table.ttr_version
WHERE history_table.ttr_pid IS NULL
UNION ALL
SELECT history_table.ttr_pid
     , history_table.ttr_version + 1
     , history_table.ttr_deal_pid
     , history_table.ttr_create_datetime
     , history_table.ttr_requester_agent_type
     , history_table.ttr_requester_lender_user_pid
     , history_table.ttr_requester_unparsed_name
     , history_table.ttr_mismo_version_type
     , history_table.ttr_credit_request_type
     , history_table.ttr_request_error_messages
     , history_table.ttr_request_success_messages
     , history_table.ttr_tracking_number
     , history_table.ttr_tax_transcript_request_status_type
     , history_table.ttr_update_reason
     , history_table.ttr_last_status_query_datetime
     , history_table.ttr_signed_4506t_deal_file_pid
     , history_table.ttr_company
     , history_table.ttr_company_name
     , history_table.ttr_company_city
     , history_table.ttr_company_country
     , history_table.ttr_company_postal_code
     , history_table.ttr_company_state
     , history_table.ttr_company_street1
     , history_table.ttr_company_street2
     , history_table.ttr_company_ein
     , history_table.ttr_borrower1_pid
     , history_table.ttr_borrower1_first_name
     , history_table.ttr_borrower1_middle_name
     , history_table.ttr_borrower1_last_name
     , history_table.ttr_borrower1_name_suffix
     , history_table.ttr_borrower1_birth_date
     , history_table.ttr_borrower1_current_city
     , history_table.ttr_borrower1_current_country
     , history_table.ttr_borrower1_current_postal_code
     , history_table.ttr_borrower1_current_state
     , history_table.ttr_borrower1_current_street1
     , history_table.ttr_borrower1_current_street2
     , history_table.ttr_borrower1_prior_city
     , history_table.ttr_borrower1_prior_country
     , history_table.ttr_borrower1_prior_postal_code
     , history_table.ttr_borrower1_prior_state
     , history_table.ttr_borrower1_prior_street1
     , history_table.ttr_borrower1_prior_street2
     , history_table.ttr_borrower1_monthly_income_amount
     , history_table.ttr_borrower2_pid
     , history_table.ttr_borrower2_first_name
     , history_table.ttr_borrower2_middle_name
     , history_table.ttr_borrower2_last_name
     , history_table.ttr_borrower2_name_suffix
     , history_table.ttr_borrower2_birth_date
     , history_table.ttr_borrower2_current_city
     , history_table.ttr_borrower2_current_country
     , history_table.ttr_borrower2_current_postal_code
     , history_table.ttr_borrower2_current_state
     , history_table.ttr_borrower2_current_street1
     , history_table.ttr_borrower2_current_street2
     , history_table.ttr_borrower2_prior_city
     , history_table.ttr_borrower2_prior_country
     , history_table.ttr_borrower2_prior_postal_code
     , history_table.ttr_borrower2_prior_state
     , history_table.ttr_borrower2_prior_street1
     , history_table.ttr_borrower2_prior_street2
     , history_table.ttr_borrower2_monthly_income_amount
     , history_table.ttr_year1
     , history_table.ttr_year2
     , history_table.ttr_year3
     , history_table.ttr_year4
     , history_table.ttr_include_w_2
     , history_table.ttr_include_1099
     , history_table.ttr_include_1040
     , history_table.ttr_include_1040_return_transcript
     , history_table.ttr_include_1040_account_transcript
     , history_table.ttr_include_1040_record_of_account
     , history_table.ttr_include_1065
     , history_table.ttr_include_1065_return_transcript
     , history_table.ttr_include_1065_account_transcript
     , history_table.ttr_include_1065_record_of_account
     , history_table.ttr_include_1120
     , history_table.ttr_include_1120_return_transcript
     , history_table.ttr_include_1120_account_transcript
     , history_table.ttr_include_1120_record_of_account
     , history_table.ttr_archived
     , history_table.ttr_company_phone
     , history_table.ttr_company_phone_extension
     , history_table.ttr_business_ownership_type
     , history_table.ttr_include_1120s
     , history_table.ttr_include_1120s_return_transcript
     , history_table.ttr_include_1120s_account_transcript
     , history_table.ttr_include_1120s_record_of_account
     , history_table.ttr_business_income_borrower_title
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.tax_transcript_request history_table
LEFT JOIN staging_octane.tax_transcript_request staging_table
          ON staging_table.ttr_pid = history_table.ttr_pid
WHERE staging_table.ttr_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.tax_transcript_request deleted_records
    WHERE deleted_records.ttr_pid = history_table.ttr_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100038', 0, '--finding records to insert into history_octane.lead_source
SELECT staging_table.lds_pid
     , staging_table.lds_version
     , staging_table.lds_account_pid
     , staging_table.lds_channel_pid
     , staging_table.lds_lead_source_name
     , staging_table.lds_mortech_lead_source_id
     , staging_table.lds_lead_source_id
     , staging_table.lds_active
     , staging_table.lds_lead_id_required
     , staging_table.lds_zero_margin_allowed
     , staging_table.lds_mortech_account_pid
     , staging_table.lds_training_only
     , staging_table.lds_compensation_type
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.lead_source staging_table
LEFT JOIN history_octane.lead_source history_table
          ON staging_table.lds_pid = history_table.lds_pid
              AND staging_table.lds_version = history_table.lds_version
WHERE history_table.lds_pid IS NULL
UNION ALL
SELECT history_table.lds_pid
     , history_table.lds_version + 1
     , history_table.lds_account_pid
     , history_table.lds_channel_pid
     , history_table.lds_lead_source_name
     , history_table.lds_mortech_lead_source_id
     , history_table.lds_lead_source_id
     , history_table.lds_active
     , history_table.lds_lead_id_required
     , history_table.lds_zero_margin_allowed
     , history_table.lds_mortech_account_pid
     , history_table.lds_training_only
     , history_table.lds_compensation_type
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.lead_source history_table
LEFT JOIN staging_octane.lead_source staging_table
          ON staging_table.lds_pid = history_table.lds_pid
WHERE staging_table.lds_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.lead_source deleted_records
    WHERE deleted_records.lds_pid = history_table.lds_pid
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
    VALUES ('SP-100176')
         , ('SP-100177')
         , ('SP-100332')
         , ('SP-100857')
         , ('SP-100858')
         , ('SP-100859')
         , ('SP-100863')
         , ('SP-100864')
         , ('SP-100865')
         , ('SP-100866')
         , ('SP-100867')
         , ('SP-100868')
         , ('SP-100873')
)
DELETE
FROM mdi.state_machine_definition
    USING delete_keys, mdi.process
WHERE state_machine_definition.process_dwid = process.dwid
    AND process.name = delete_keys.process_name;

--json_output_field
WITH delete_keys (process_name) AS (
    VALUES ('SP-100176')
         , ('SP-100177')
         , ('SP-100332')
         , ('SP-100857')
         , ('SP-100858')
         , ('SP-100859')
         , ('SP-100863')
         , ('SP-100864')
         , ('SP-100865')
         , ('SP-100866')
         , ('SP-100867')
         , ('SP-100868')
         , ('SP-100873')
)
DELETE
FROM mdi.json_output_field
    USING delete_keys, mdi.process
WHERE json_output_field.process_dwid = process.dwid
    AND process.name = delete_keys.process_name;

--table_output_field
WITH delete_keys (process_name, database_field_name) AS (
    VALUES ('SP-100176', 'sdnc_pid')
         , ('SP-100176', 'sdnc_version')
         , ('SP-100176', 'sdnc_smart_doc_note_pid')
         , ('SP-100176', 'sdnc_create_datetime')
         , ('SP-100176', 'sdnc_content')
         , ('SP-100176', 'sdnc_author_lender_user_pid')
         , ('SP-100176', 'sdnc_author_unparsed_name')
         , ('SP-100176', 'data_source_updated_datetime')
         , ('SP-100176', 'data_source_deleted_flag')
         , ('SP-100177', 'sdnm_pid')
         , ('SP-100177', 'sdnm_version')
         , ('SP-100177', 'sdnm_smart_doc_note_pid')
         , ('SP-100177', 'sdnm_lender_user_pid')
         , ('SP-100177', 'data_source_updated_datetime')
         , ('SP-100177', 'data_source_deleted_flag')
         , ('SP-100332', 'sdn_pid')
         , ('SP-100332', 'sdn_version')
         , ('SP-100332', 'sdn_smart_doc_pid')
         , ('SP-100332', 'sdn_create_datetime')
         , ('SP-100332', 'sdn_content')
         , ('SP-100332', 'sdn_author_lender_user_pid')
         , ('SP-100332', 'sdn_author_unparsed_name')
         , ('SP-100332', 'data_source_updated_datetime')
         , ('SP-100332', 'data_source_deleted_flag')
         , ('SP-100857', 'locn_pid')
         , ('SP-100857', 'locn_version')
         , ('SP-100857', 'locn_location_pid')
         , ('SP-100857', 'locn_create_datetime')
         , ('SP-100857', 'locn_content')
         , ('SP-100857', 'locn_author_lender_user_pid')
         , ('SP-100857', 'locn_author_unparsed_name')
         , ('SP-100857', 'data_source_updated_datetime')
         , ('SP-100857', 'data_source_deleted_flag')
         , ('SP-100858', 'locnc_pid')
         , ('SP-100858', 'locnc_version')
         , ('SP-100858', 'locnc_location_note_pid')
         , ('SP-100858', 'locnc_create_datetime')
         , ('SP-100858', 'locnc_content')
         , ('SP-100858', 'locnc_author_lender_user_pid')
         , ('SP-100858', 'locnc_author_unparsed_name')
         , ('SP-100858', 'data_source_updated_datetime')
         , ('SP-100858', 'data_source_deleted_flag')
         , ('SP-100859', 'locnm_pid')
         , ('SP-100859', 'locnm_version')
         , ('SP-100859', 'locnm_location_note_pid')
         , ('SP-100859', 'locnm_lender_user_pid')
         , ('SP-100859', 'data_source_updated_datetime')
         , ('SP-100859', 'data_source_deleted_flag')
         , ('SP-100863', 'wfsn_pid')
         , ('SP-100863', 'wfsn_version')
         , ('SP-100863', 'wfsn_wf_step_pid')
         , ('SP-100863', 'wfsn_create_datetime')
         , ('SP-100863', 'wfsn_content')
         , ('SP-100863', 'wfsn_author_lender_user_pid')
         , ('SP-100863', 'wfsn_author_unparsed_name')
         , ('SP-100863', 'data_source_updated_datetime')
         , ('SP-100863', 'data_source_deleted_flag')
         , ('SP-100864', 'wfsnc_pid')
         , ('SP-100864', 'wfsnc_version')
         , ('SP-100864', 'wfsnc_wf_step_note_pid')
         , ('SP-100864', 'wfsnc_create_datetime')
         , ('SP-100864', 'wfsnc_content')
         , ('SP-100864', 'wfsnc_author_lender_user_pid')
         , ('SP-100864', 'wfsnc_author_unparsed_name')
         , ('SP-100864', 'data_source_updated_datetime')
         , ('SP-100864', 'data_source_deleted_flag')
         , ('SP-100865', 'wfsnm_pid')
         , ('SP-100865', 'wfsnm_version')
         , ('SP-100865', 'wfsnm_wf_step_note_pid')
         , ('SP-100865', 'wfsnm_lender_user_pid')
         , ('SP-100865', 'data_source_updated_datetime')
         , ('SP-100865', 'data_source_deleted_flag')
         , ('SP-100866', 'wfpn_pid')
         , ('SP-100866', 'wfpn_version')
         , ('SP-100866', 'wfpn_wf_process_pid')
         , ('SP-100866', 'wfpn_create_datetime')
         , ('SP-100866', 'wfpn_content')
         , ('SP-100866', 'wfpn_author_lender_user_pid')
         , ('SP-100866', 'wfpn_author_unparsed_name')
         , ('SP-100866', 'data_source_updated_datetime')
         , ('SP-100866', 'data_source_deleted_flag')
         , ('SP-100867', 'wfpnc_pid')
         , ('SP-100867', 'wfpnc_version')
         , ('SP-100867', 'wfpnc_wf_process_note_pid')
         , ('SP-100867', 'wfpnc_create_datetime')
         , ('SP-100867', 'wfpnc_content')
         , ('SP-100867', 'wfpnc_author_lender_user_pid')
         , ('SP-100867', 'wfpnc_author_unparsed_name')
         , ('SP-100867', 'data_source_updated_datetime')
         , ('SP-100867', 'data_source_deleted_flag')
         , ('SP-100868', 'wfpnm_pid')
         , ('SP-100868', 'wfpnm_version')
         , ('SP-100868', 'wfpnm_wf_process_note_pid')
         , ('SP-100868', 'wfpnm_lender_user_pid')
         , ('SP-100868', 'data_source_updated_datetime')
         , ('SP-100868', 'data_source_deleted_flag')
         , ('SP-100873', 'code')
         , ('SP-100873', 'value')
         , ('SP-100873', 'data_source_updated_datetime')
         , ('SP-100873', 'data_source_deleted_flag')
         , ('SP-100038', 'lds_broker_compensation_type')
         , ('SP-100176', 'etl_batch_id')
         , ('SP-100177', 'etl_batch_id')
         , ('SP-100332', 'etl_batch_id')
         , ('SP-100857', 'etl_batch_id')
         , ('SP-100858', 'etl_batch_id')
         , ('SP-100859', 'etl_batch_id')
         , ('SP-100863', 'etl_batch_id')
         , ('SP-100864', 'etl_batch_id')
         , ('SP-100865', 'etl_batch_id')
         , ('SP-100866', 'etl_batch_id')
         , ('SP-100867', 'etl_batch_id')
         , ('SP-100868', 'etl_batch_id')
         , ('SP-100873', 'etl_batch_id')
         , ('SP-100901', 'cn_old_location_note_pid')
         , ('SP-100901', 'cn_old_smart_doc_note_pid')
         , ('SP-100901', 'cn_old_wf_process_note_pid')
         , ('SP-100901', 'cn_old_wf_step_note_pid')
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
    VALUES ('SP-100176')
         , ('SP-100177')
         , ('SP-100332')
         , ('SP-100857')
         , ('SP-100858')
         , ('SP-100859')
         , ('SP-100863')
         , ('SP-100864')
         , ('SP-100865')
         , ('SP-100866')
         , ('SP-100867')
         , ('SP-100868')
         , ('SP-100873')
)
DELETE
FROM mdi.table_output_step
    USING delete_keys, mdi.process
WHERE table_output_step.process_dwid = process.dwid
    AND process.name = delete_keys.process_name;

--table_input_step
WITH delete_keys (process_name) AS (
    VALUES ('SP-100176')
         , ('SP-100177')
         , ('SP-100332')
         , ('SP-100857')
         , ('SP-100858')
         , ('SP-100859')
         , ('SP-100863')
         , ('SP-100864')
         , ('SP-100865')
         , ('SP-100866')
         , ('SP-100867')
         , ('SP-100868')
         , ('SP-100873')
)
DELETE
FROM mdi.table_input_step
    USING delete_keys, mdi.process
WHERE table_input_step.process_dwid = process.dwid
    AND process.name = delete_keys.process_name;

--process
WITH delete_keys (process_name) AS (
    VALUES ('SP-100176')
         , ('SP-100177')
         , ('SP-100332')
         , ('SP-100857')
         , ('SP-100858')
         , ('SP-100859')
         , ('SP-100863')
         , ('SP-100864')
         , ('SP-100865')
         , ('SP-100866')
         , ('SP-100867')
         , ('SP-100868')
         , ('SP-100873')
)
DELETE
FROM mdi.process
    USING delete_keys
WHERE process.name = delete_keys.process_name;

--edw_field_definition
WITH delete_keys (database_name, schema_name, table_name, field_name) AS (
    VALUES ('staging', 'history_octane', 'lead_source', 'lds_broker_compensation_type')
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
    VALUES ('staging', 'staging_octane', 'broker_compensation_type', 'code')
         , ('staging', 'staging_octane', 'broker_compensation_type', 'value')
         , ('staging', 'staging_octane', 'lead_source', 'lds_broker_compensation_type')
         , ('staging', 'staging_octane', 'wf_step_note', 'wfsn_content')
         , ('staging', 'staging_octane', 'wf_process_note_monitor', 'wfpnm_pid')
         , ('staging', 'staging_octane', 'wf_process_note_monitor', 'wfpnm_version')
         , ('staging', 'staging_octane', 'wf_process_note_monitor', 'wfpnm_wf_process_note_pid')
         , ('staging', 'staging_octane', 'wf_process_note_comment', 'wfpnc_pid')
         , ('staging', 'staging_octane', 'wf_process_note_comment', 'wfpnc_version')
         , ('staging', 'staging_octane', 'wf_process_note_comment', 'wfpnc_content')
         , ('staging', 'staging_octane', 'wf_process_note_comment', 'wfpnc_author_unparsed_name')
         , ('staging', 'staging_octane', 'wf_process_note', 'wfpn_pid')
         , ('staging', 'staging_octane', 'wf_process_note', 'wfpn_wf_process_pid')
         , ('staging', 'staging_octane', 'wf_process_note', 'wfpn_author_lender_user_pid')
         , ('staging', 'staging_octane', 'wf_process_note', 'wfpn_author_unparsed_name')
         , ('staging', 'staging_octane', 'wf_step_note_monitor', 'wfsnm_version')
         , ('staging', 'staging_octane', 'wf_step_note_monitor', 'wfsnm_lender_user_pid')
         , ('staging', 'staging_octane', 'wf_step_note_comment', 'wfsnc_version')
         , ('staging', 'staging_octane', 'wf_step_note_comment', 'wfsnc_wf_step_note_pid')
         , ('staging', 'staging_octane', 'wf_step_note_comment', 'wfsnc_create_datetime')
         , ('staging', 'staging_octane', 'wf_step_note_comment', 'wfsnc_author_lender_user_pid')
         , ('staging', 'staging_octane', 'wf_step_note', 'wfsn_pid')
         , ('staging', 'staging_octane', 'wf_step_note', 'wfsn_version')
         , ('staging', 'staging_octane', 'wf_step_note', 'wfsn_author_lender_user_pid')
         , ('staging', 'staging_octane', 'wf_step_note', 'wfsn_author_unparsed_name')
         , ('staging', 'staging_octane', 'location_note_monitor', 'locnm_version')
         , ('staging', 'staging_octane', 'location_note_monitor', 'locnm_lender_user_pid')
         , ('staging', 'staging_octane', 'location_note_comment', 'locnc_pid')
         , ('staging', 'staging_octane', 'location_note_comment', 'locnc_content')
         , ('staging', 'staging_octane', 'location_note_comment', 'locnc_author_unparsed_name')
         , ('staging', 'staging_octane', 'location_note', 'locn_pid')
         , ('staging', 'staging_octane', 'location_note', 'locn_version')
         , ('staging', 'staging_octane', 'location_note', 'locn_author_unparsed_name')
         , ('staging', 'staging_octane', 'smart_doc_note_monitor', 'sdnm_smart_doc_note_pid')
         , ('staging', 'staging_octane', 'smart_doc_note_monitor', 'sdnm_pid')
         , ('staging', 'staging_octane', 'smart_doc_note_comment', 'sdnc_create_datetime')
         , ('staging', 'staging_octane', 'smart_doc_note_comment', 'sdnc_content')
         , ('staging', 'staging_octane', 'smart_doc_note_comment', 'sdnc_author_lender_user_pid')
         , ('staging', 'staging_octane', 'smart_doc_note_comment', 'sdnc_pid')
         , ('staging', 'staging_octane', 'smart_doc_note', 'sdn_version')
         , ('staging', 'staging_octane', 'smart_doc_note', 'sdn_content')
         , ('staging', 'staging_octane', 'smart_doc_note', 'sdn_author_lender_user_pid')
         , ('staging', 'staging_octane', 'location_note_monitor', 'locnm_pid')
         , ('staging', 'staging_octane', 'location_note_monitor', 'locnm_location_note_pid')
         , ('staging', 'staging_octane', 'location_note_comment', 'locnc_version')
         , ('staging', 'staging_octane', 'location_note_comment', 'locnc_location_note_pid')
         , ('staging', 'staging_octane', 'location_note_comment', 'locnc_create_datetime')
         , ('staging', 'staging_octane', 'location_note_comment', 'locnc_author_lender_user_pid')
         , ('staging', 'staging_octane', 'location_note', 'locn_location_pid')
         , ('staging', 'staging_octane', 'location_note', 'locn_create_datetime')
         , ('staging', 'staging_octane', 'location_note', 'locn_content')
         , ('staging', 'staging_octane', 'location_note', 'locn_author_lender_user_pid')
         , ('staging', 'staging_octane', 'wf_step_note_comment', 'wfsnc_pid')
         , ('staging', 'staging_octane', 'wf_process_note_monitor', 'wfpnm_lender_user_pid')
         , ('staging', 'staging_octane', 'wf_process_note_comment', 'wfpnc_wf_process_note_pid')
         , ('staging', 'staging_octane', 'wf_process_note_comment', 'wfpnc_create_datetime')
         , ('staging', 'staging_octane', 'wf_process_note_comment', 'wfpnc_author_lender_user_pid')
         , ('staging', 'staging_octane', 'wf_process_note', 'wfpn_version')
         , ('staging', 'staging_octane', 'wf_process_note', 'wfpn_create_datetime')
         , ('staging', 'staging_octane', 'wf_process_note', 'wfpn_content')
         , ('staging', 'staging_octane', 'wf_step_note_monitor', 'wfsnm_pid')
         , ('staging', 'staging_octane', 'wf_step_note_monitor', 'wfsnm_wf_step_note_pid')
         , ('staging', 'staging_octane', 'wf_step_note_comment', 'wfsnc_content')
         , ('staging', 'staging_octane', 'wf_step_note_comment', 'wfsnc_author_unparsed_name')
         , ('staging', 'staging_octane', 'wf_step_note', 'wfsn_wf_step_pid')
         , ('staging', 'staging_octane', 'wf_step_note', 'wfsn_create_datetime')
         , ('staging', 'staging_octane', 'smart_doc_note_monitor', 'sdnm_lender_user_pid')
         , ('staging', 'staging_octane', 'smart_doc_note_monitor', 'sdnm_version')
         , ('staging', 'staging_octane', 'smart_doc_note_comment', 'sdnc_version')
         , ('staging', 'staging_octane', 'smart_doc_note_comment', 'sdnc_smart_doc_note_pid')
         , ('staging', 'staging_octane', 'smart_doc_note_comment', 'sdnc_author_unparsed_name')
         , ('staging', 'staging_octane', 'smart_doc_note', 'sdn_author_unparsed_name')
         , ('staging', 'staging_octane', 'smart_doc_note', 'sdn_pid')
         , ('staging', 'staging_octane', 'smart_doc_note', 'sdn_smart_doc_pid')
         , ('staging', 'staging_octane', 'smart_doc_note', 'sdn_create_datetime')
         , ('staging', 'staging_octane', 'config_note', 'cn_old_wf_step_note_pid')
         , ('staging', 'staging_octane', 'config_note', 'cn_old_wf_process_note_pid')
         , ('staging', 'staging_octane', 'config_note', 'cn_old_smart_doc_note_pid')
         , ('staging', 'staging_octane', 'config_note', 'cn_old_location_note_pid')
)
DELETE
FROM mdi.edw_field_definition
    USING delete_keys, mdi.edw_table_definition
WHERE edw_table_definition.database_name = delete_keys.database_name
    AND edw_table_definition.schema_name = delete_keys.schema_name
    AND edw_table_definition.table_name = delete_keys.table_name
    AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
    AND edw_field_definition.field_name = delete_keys.field_name;

--edw_table_definition
WITH delete_keys (database_name, schema_name, table_name) AS (
    VALUES ('staging', 'staging_octane', 'smart_doc_note')
         , ('staging', 'staging_octane', 'smart_doc_note_comment')
         , ('staging', 'staging_octane', 'smart_doc_note_monitor')
         , ('staging', 'staging_octane', 'location_note')
         , ('staging', 'staging_octane', 'location_note_comment')
         , ('staging', 'staging_octane', 'location_note_monitor')
         , ('staging', 'staging_octane', 'wf_step_note')
         , ('staging', 'staging_octane', 'wf_step_note_comment')
         , ('staging', 'staging_octane', 'wf_step_note_monitor')
         , ('staging', 'staging_octane', 'wf_process_note')
         , ('staging', 'staging_octane', 'wf_process_note_comment')
         , ('staging', 'staging_octane', 'wf_process_note_monitor')
         , ('staging', 'staging_octane', 'broker_compensation_type')
)
DELETE
FROM mdi.edw_table_definition
    USING delete_keys
WHERE edw_table_definition.database_name = delete_keys.database_name
    AND edw_table_definition.schema_name = delete_keys.schema_name
    AND edw_table_definition.table_name = delete_keys.table_name;
/*
DELETIONS
*/

--edw_field_definition
WITH delete_keys (database_name, schema_name, table_name, field_name) AS (
    VALUES ('staging', 'history_octane', 'broker_compensation_type', 'data_source_updated_datetime')
         , ('staging', 'history_octane', 'broker_compensation_type', 'data_source_deleted_flag')
         , ('staging', 'history_octane', 'broker_compensation_type', 'etl_batch_id')
         , ('staging', 'history_octane', 'broker_compensation_type', 'code')
         , ('staging', 'history_octane', 'broker_compensation_type', 'value')
)
DELETE
FROM mdi.edw_field_definition
    USING delete_keys, mdi.edw_table_definition
WHERE edw_table_definition.database_name = delete_keys.database_name
    AND edw_table_definition.schema_name = delete_keys.schema_name
    AND edw_table_definition.table_name = delete_keys.table_name
    AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
    AND edw_field_definition.field_name = delete_keys.field_name;

--edw_table_definition
WITH delete_keys (database_name, schema_name, table_name) AS (
    VALUES ('staging', 'history_octane', 'broker_compensation_type')
)
DELETE
FROM mdi.edw_table_definition
    USING delete_keys
WHERE edw_table_definition.database_name = delete_keys.database_name
    AND edw_table_definition.schema_name = delete_keys.schema_name
    AND edw_table_definition.table_name = delete_keys.table_name;

delete from mdi.edw_join_definition where target_edw_table_definition_dwid = (select dwid from mdi.edw_table_definition where table_name='broker_compensation_type');
