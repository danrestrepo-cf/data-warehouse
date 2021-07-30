--
-- Main | EDW - Octane schemas from prod-release to uat (2021-07-30)
-- https://app.asana.com/0/0/1200693388322564
--

--Insert metadata for new table: sap_status_type
WITH new_staging_table_definition AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'sap_status_type', NULL)
        RETURNING dwid, table_name
)
   , new_history_table_definition AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        SELECT 'staging', 'history_octane', 'sap_status_type', new_staging_table_definition.dwid
        FROM new_staging_table_definition
        RETURNING dwid, table_name
)
   , new_fields (schema_name, table_name, field_name, key_field_flag, field_order) AS (
    VALUES ('staging_octane', 'sap_status_type', 'code', TRUE, 1)
         , ('staging_octane', 'sap_status_type', 'value', FALSE, 2)
         , ('history_octane', 'sap_status_type', 'code', TRUE, 1)
         , ('history_octane', 'sap_status_type', 'value', FALSE, 2)
         , ('history_octane', 'sap_status_type', 'data_source_updated_datetime', FALSE, 3)
         , ('history_octane', 'sap_status_type', 'data_source_deleted_flag', FALSE, 4)
)
   , new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT new_staging_table_definition.dwid, new_fields.field_name, new_fields.key_field_flag
        FROM new_fields
        JOIN new_staging_table_definition
             ON new_staging_table_definition.table_name = new_fields.table_name
        WHERE new_fields.schema_name = 'staging_octane'
        RETURNING dwid, edw_table_definition_dwid, field_name
)
   , new_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid)
        SELECT new_history_table_definition.dwid, new_fields.field_name, new_fields.key_field_flag, new_staging_field_definitions.dwid
        FROM new_fields
        JOIN new_history_table_definition
             ON new_history_table_definition.table_name = new_fields.table_name
        JOIN new_staging_table_definition
             ON new_staging_table_definition.table_name = new_fields.table_name
        LEFT JOIN new_staging_field_definitions
                  ON new_staging_field_definitions.edw_table_definition_dwid = new_staging_table_definition.dwid
                      AND new_staging_field_definitions.field_name = new_fields.field_name
        WHERE new_fields.schema_name = 'history_octane'
)
   , new_process_variables (name, target_table, json_output_field, sql) AS (
    VALUES ('SP-100835', 'sap_status_type', 'code', 'SELECT staging_table.code, staging_table.value, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.sap_status_type staging_table
LEFT JOIN history_octane.sap_status_type history_table on staging_table.code = history_table.code AND staging_table.value = history_table.value
WHERE history_table.code is NULL')
)
   , new_process AS (
    INSERT INTO mdi.process (name, description)
        SELECT new_process_variables.name
             , 'ETL to copy ' || new_process_variables.target_table || ' data from staging_octane to history_octane'
        FROM new_process_variables
        RETURNING dwid, name, description
)
   , new_table_input_step AS (
    INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables,
                                      enable_lazy_conversion, cached_row_meta, connectionname)
        SELECT new_process.dwid
             , 0
             , new_process_variables.sql
             , 0
             , 'N'
             , 'N'
             , 'N'
             , 'N'
             , 'Staging DB Connection'
        FROM new_process
        JOIN new_process_variables
             ON new_process.name = new_process_variables.name
)
   , new_table_output_step AS (
    INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field,
                                       auto_generated_key_field, partition_data_per, table_name_defined_in_field,
                                       return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables,
                                       specify_database_fields, ignore_insert_errors, use_batch_update)
        SELECT new_process.dwid
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
        FROM new_process
        JOIN new_process_variables
             ON new_process.name = new_process_variables.name
        RETURNING dwid, target_schema, target_table
)
   , new_table_output_fields AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
        SELECT new_table_output_step.dwid
             , new_fields.field_name
             , new_fields.field_name
             , new_fields.field_order
             , FALSE
        FROM new_table_output_step
        JOIN new_fields
             ON new_fields.schema_name = new_table_output_step.target_schema
                 AND new_fields.table_name = new_table_output_step.target_table
)
   , new_json_output_field AS (
    INSERT INTO mdi.json_output_field (process_dwid, field_name)
        SELECT new_process.dwid, new_process_variables.json_output_field
        FROM new_process
        JOIN new_process_variables
             ON new_process.name = new_process_variables.name
)
   , new_state_machine_definition AS (
    INSERT INTO mdi.state_machine_definition (process_dwid, name, comment, cron_schedule)
        SELECT new_process.dwid, new_process.name, new_process.description, NULL
        FROM new_process
)
SELECT 'Finished inserting metadata for new table: sap_status_type';

--Insert metadata for new columns: criteria_pid_operand.crpo_trustee_pid, deal_sap.dsap_sap_status_type
WITH new_fields (table_name, field_name, field_order) AS (
    VALUES ('criteria_pid_operand', 'crpo_trustee_pid', 29)
         , ('deal_sap', 'dsap_sap_status_type', 10)
)
   , new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT edw_table_definition.dwid, new_fields.field_name, FALSE
        FROM new_fields
        JOIN mdi.edw_table_definition
             ON edw_table_definition.schema_name = 'staging_octane'
                 AND edw_table_definition.table_name = new_fields.table_name
        RETURNING dwid, edw_table_definition_dwid, field_name
)
   , new_history_field_definitions AS (
    INSERT
        INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid)
            SELECT edw_table_definition.dwid, new_fields.field_name, FALSE, new_staging_field_definitions.dwid
            FROM new_fields
            JOIN mdi.edw_table_definition
                 ON edw_table_definition.schema_name = 'history_octane'
                     AND edw_table_definition.table_name = new_fields.table_name
            JOIN mdi.edw_table_definition source_table_definition
                 ON source_table_definition.schema_name = 'staging_octane'
                     AND source_table_definition.table_name = new_fields.table_name
            JOIN new_staging_field_definitions
                 ON new_staging_field_definitions.edw_table_definition_dwid = source_table_definition.dwid
                     AND new_staging_field_definitions.field_name = new_fields.field_name
)
   , new_table_output_fields AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
        SELECT table_output_step.dwid, new_fields.field_name, new_fields.field_name, new_fields.field_order, FALSE
        FROM new_fields
        JOIN mdi.table_output_step
             ON table_output_step.target_schema = 'history_octane'
                 AND table_output_step.target_table = new_fields.table_name
)
   , updated_table_input_sql (table_name, sql) AS (
    VALUES ('criteria_pid_operand', '
            --finding records to insert into history_octane.criteria_pid_operand
            SELECT staging_table.crpo_pid, staging_table.crpo_version, staging_table.crpo_criteria_pid, staging_table.crpo_criteria_pid_operand_type, staging_table.crpo_lender_user_pid, staging_table.crpo_role_pid, staging_table.crpo_branch_pid, staging_table.crpo_wf_step_pid, staging_table.crpo_wf_phase_pid, staging_table.crpo_county_pid, staging_table.crpo_investor_pid, staging_table.crpo_product_pid, staging_table.crpo_lead_source_pid, staging_table.crpo_company_pid, staging_table.crpo_deal_tag_definition_pid, staging_table.crpo_creditor_pid, staging_table.crpo_interim_funder_pid, staging_table.crpo_settlement_agent_pid, staging_table.crpo_performer_team_pid, staging_table.crpo_third_party_community_second_program_pid, staging_table.crpo_offering_pid, staging_table.crpo_channel_pid, staging_table.crpo_account_grant_program_pid, staging_table.crpo_mortgage_credit_certificate_issuer_pid, staging_table.crpo_criteria_snippet_pid, staging_table.crpo_smart_doc_pid, staging_table.crpo_org_node_pid, staging_table.crpo_trustee_pid, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
            FROM staging_octane.criteria_pid_operand staging_table
            LEFT JOIN history_octane.criteria_pid_operand history_table on staging_table.crpo_pid = history_table.crpo_pid and staging_table.crpo_version = history_table.crpo_version
            WHERE history_table.crpo_pid is NULL
            UNION ALL
            SELECT history_table.crpo_pid, history_table.crpo_version+1, history_table.crpo_criteria_pid, history_table.crpo_criteria_pid_operand_type, history_table.crpo_lender_user_pid, history_table.crpo_role_pid, history_table.crpo_branch_pid, history_table.crpo_wf_step_pid, history_table.crpo_wf_phase_pid, history_table.crpo_county_pid, history_table.crpo_investor_pid, history_table.crpo_product_pid, history_table.crpo_lead_source_pid, history_table.crpo_company_pid, history_table.crpo_deal_tag_definition_pid, history_table.crpo_creditor_pid, history_table.crpo_interim_funder_pid, history_table.crpo_settlement_agent_pid, history_table.crpo_performer_team_pid, history_table.crpo_third_party_community_second_program_pid, history_table.crpo_offering_pid, history_table.crpo_channel_pid, history_table.crpo_account_grant_program_pid, history_table.crpo_mortgage_credit_certificate_issuer_pid, history_table.crpo_criteria_snippet_pid, history_table.crpo_smart_doc_pid, history_table.crpo_org_node_pid, history_table.crpo_trustee_pid, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
            FROM history_octane.criteria_pid_operand history_table
            LEFT JOIN staging_octane.criteria_pid_operand staging_table on staging_table.crpo_pid = history_table.crpo_pid
            WHERE staging_table.crpo_pid is NULL
                AND not exists (select 1 from history_octane.criteria_pid_operand deleted_records where deleted_records.crpo_pid = history_table.crpo_pid and deleted_records.data_source_deleted_flag = True)
')
         , ('deal_sap', '
            --finding records to insert into history_octane.deal_sap
            SELECT staging_table.dsap_pid, staging_table.dsap_version, staging_table.dsap_deal_pid, staging_table.dsap_last_sap_deal_step_pid, staging_table.dsap_last_sap_step_type, staging_table.dsap_credit_pull_attempts, staging_table.dsap_retry_credit_pull, staging_table.dsap_borrower_step_type, staging_table.dsap_sap_status_type, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
            FROM staging_octane.deal_sap staging_table
            LEFT JOIN history_octane.deal_sap history_table on staging_table.dsap_pid = history_table.dsap_pid and staging_table.dsap_version = history_table.dsap_version
            WHERE history_table.dsap_pid is NULL
            UNION ALL
            SELECT history_table.dsap_pid, history_table.dsap_version+1, history_table.dsap_deal_pid, history_table.dsap_last_sap_deal_step_pid, history_table.dsap_last_sap_step_type, history_table.dsap_credit_pull_attempts, history_table.dsap_retry_credit_pull, history_table.dsap_borrower_step_type, history_table.dsap_sap_status_type, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
            FROM history_octane.deal_sap history_table
            LEFT JOIN staging_octane.deal_sap staging_table on staging_table.dsap_pid = history_table.dsap_pid
            WHERE staging_table.dsap_pid is NULL
                AND not exists (select 1 from history_octane.deal_sap deleted_records where deleted_records.dsap_pid = history_table.dsap_pid and deleted_records.data_source_deleted_flag = True)
            ')
)
   , updated_table_input_step AS (
    UPDATE mdi.table_input_step
        SET sql = updated_table_input_sql.sql
        FROM updated_table_input_sql, mdi.table_output_step
        WHERE table_input_step.process_dwid = table_output_step.process_dwid
            AND table_output_step.target_schema = 'history_octane'
            AND table_output_step.target_table = updated_table_input_sql.table_name
)
SELECT 'Finished inserting metadata for new columns: criteria_pid_operand.crpo_trustee_pid, deal_sap.dsap_sap_status_type';
