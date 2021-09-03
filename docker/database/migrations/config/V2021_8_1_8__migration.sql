--
-- Main | EDW - Octane schemas from prod-release to uat (2021-09-03)
-- https://app.asana.com/0/0/1200902597416797
--

-- Insert metadata for new tables: smart_doc_validity_date_case, proposal_doc_validity
WITH new_staging_table_definitions AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'smart_doc_validity_date_case', NULL)
             , ('staging', 'staging_octane', 'proposal_doc_validity', NULL)
        RETURNING dwid, table_name
)

   , new_history_table_definitions AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        SELECT 'staging'
             , 'history_octane'
             , new_staging_table_definitions.table_name
             , new_staging_table_definitions.dwid
        FROM new_staging_table_definitions
        RETURNING dwid, table_name
)

   , new_fields (schema_name, table_name, field_name, key_field_flag, field_order) AS (
    VALUES ('staging_octane', 'smart_doc_validity_date_case', 'sdvdc_pid', TRUE, NULL)
         , ('staging_octane', 'smart_doc_validity_date_case', 'sdvdc_version', FALSE, NULL)
         , ('staging_octane', 'smart_doc_validity_date_case', 'sdvdc_smart_doc_pid', FALSE, NULL)
         , ('staging_octane', 'smart_doc_validity_date_case', 'sdvdc_criteria_pid', FALSE, NULL)
         , ('staging_octane', 'smart_doc_validity_date_case', 'sdvdc_criteria_html', FALSE, NULL)
         , ('staging_octane', 'smart_doc_validity_date_case', 'sdvdc_deal_child_type', FALSE, NULL)
         , ('staging_octane', 'smart_doc_validity_date_case', 'sdvdc_deal_child_relationship_type', FALSE, NULL)
         , ('staging_octane', 'smart_doc_validity_date_case', 'sdvdc_doc_validity_type', FALSE, NULL)
         , ('staging_octane', 'smart_doc_validity_date_case', 'sdvdc_doc_key_date_type', FALSE, NULL)
         , ('staging_octane', 'smart_doc_validity_date_case', 'sdvdc_expiration_calendar_rule_type', FALSE, NULL)
         , ('staging_octane', 'smart_doc_validity_date_case', 'sdvdc_days_before_key_date', FALSE, NULL)
         , ('staging_octane', 'smart_doc_validity_date_case', 'sdvdc_warning_days', FALSE, NULL)
         , ('staging_octane', 'smart_doc_validity_date_case', 'sdvdc_ordinal', FALSE, NULL)
         , ('staging_octane', 'smart_doc_validity_date_case', 'sdvdc_else_case', FALSE, NULL)
         , ('staging_octane', 'smart_doc_validity_date_case', 'sdvdc_active', FALSE, NULL)
         , ('history_octane', 'smart_doc_validity_date_case', 'sdvdc_pid', TRUE, 1)
         , ('history_octane', 'smart_doc_validity_date_case', 'sdvdc_version', FALSE, 2)
         , ('history_octane', 'smart_doc_validity_date_case', 'sdvdc_smart_doc_pid', FALSE, 3)
         , ('history_octane', 'smart_doc_validity_date_case', 'sdvdc_criteria_pid', FALSE, 4)
         , ('history_octane', 'smart_doc_validity_date_case', 'sdvdc_criteria_html', FALSE, 5)
         , ('history_octane', 'smart_doc_validity_date_case', 'sdvdc_deal_child_type', FALSE, 6)
         , ('history_octane', 'smart_doc_validity_date_case', 'sdvdc_deal_child_relationship_type', FALSE, 7)
         , ('history_octane', 'smart_doc_validity_date_case', 'sdvdc_doc_validity_type', FALSE, 8)
         , ('history_octane', 'smart_doc_validity_date_case', 'sdvdc_doc_key_date_type', FALSE, 9)
         , ('history_octane', 'smart_doc_validity_date_case', 'sdvdc_expiration_calendar_rule_type', FALSE, 10)
         , ('history_octane', 'smart_doc_validity_date_case', 'sdvdc_days_before_key_date', FALSE, 11)
         , ('history_octane', 'smart_doc_validity_date_case', 'sdvdc_warning_days', FALSE, 12)
         , ('history_octane', 'smart_doc_validity_date_case', 'sdvdc_ordinal', FALSE, 13)
         , ('history_octane', 'smart_doc_validity_date_case', 'sdvdc_else_case', FALSE, 14)
         , ('history_octane', 'smart_doc_validity_date_case', 'sdvdc_active', FALSE, 15)
         , ('history_octane', 'smart_doc_validity_date_case', 'data_source_updated_datetime', FALSE, 16)
         , ('history_octane', 'smart_doc_validity_date_case', 'data_source_deleted_flag', FALSE, 17)
         , ('staging_octane', 'proposal_doc_validity', 'prpdv_pid', TRUE, NULL)
         , ('staging_octane', 'proposal_doc_validity', 'prpdv_version', FALSE, NULL)
         , ('staging_octane', 'proposal_doc_validity', 'prpdv_proposal_doc_pid', FALSE, NULL)
         , ('staging_octane', 'proposal_doc_validity', 'prpdv_smart_doc_validity_date_case_pid', FALSE, NULL)
         , ('staging_octane', 'proposal_doc_validity', 'prpdv_deal_pid', FALSE, NULL)
         , ('staging_octane', 'proposal_doc_validity', 'prpdv_proposal_pid', FALSE, NULL)
         , ('staging_octane', 'proposal_doc_validity', 'prpdv_valid_from_date', FALSE, NULL)
         , ('staging_octane', 'proposal_doc_validity', 'prpdv_valid_through_date', FALSE, NULL)
         , ('staging_octane', 'proposal_doc_validity', 'prpdv_key_date', FALSE, NULL)
         , ('staging_octane', 'proposal_doc_validity', 'prpdv_doc_validity_type', FALSE, NULL)
         , ('staging_octane', 'proposal_doc_validity', 'prpdv_doc_key_date_type', FALSE, NULL)
         , ('staging_octane', 'proposal_doc_validity', 'prpdv_expiration_calendar_rule_type', FALSE, NULL)
         , ('staging_octane', 'proposal_doc_validity', 'prpdv_days_before_key_date', FALSE, NULL)
         , ('staging_octane', 'proposal_doc_validity', 'prpdv_warning_days', FALSE, NULL)
         , ('history_octane', 'proposal_doc_validity', 'prpdv_pid', TRUE, 1)
         , ('history_octane', 'proposal_doc_validity', 'prpdv_version', FALSE, 2)
         , ('history_octane', 'proposal_doc_validity', 'prpdv_proposal_doc_pid', FALSE, 3)
         , ('history_octane', 'proposal_doc_validity', 'prpdv_smart_doc_validity_date_case_pid', FALSE, 4)
         , ('history_octane', 'proposal_doc_validity', 'prpdv_deal_pid', FALSE, 5)
         , ('history_octane', 'proposal_doc_validity', 'prpdv_proposal_pid', FALSE, 6)
         , ('history_octane', 'proposal_doc_validity', 'prpdv_valid_from_date', FALSE, 7)
         , ('history_octane', 'proposal_doc_validity', 'prpdv_valid_through_date', FALSE, 8)
         , ('history_octane', 'proposal_doc_validity', 'prpdv_key_date', FALSE, 9)
         , ('history_octane', 'proposal_doc_validity', 'prpdv_doc_validity_type', FALSE, 10)
         , ('history_octane', 'proposal_doc_validity', 'prpdv_doc_key_date_type', FALSE, 11)
         , ('history_octane', 'proposal_doc_validity', 'prpdv_expiration_calendar_rule_type', FALSE, 12)
         , ('history_octane', 'proposal_doc_validity', 'prpdv_days_before_key_date', FALSE, 13)
         , ('history_octane', 'proposal_doc_validity', 'prpdv_warning_days', FALSE, 14)
         , ('history_octane', 'proposal_doc_validity', 'data_source_updated_datetime', FALSE, 15)
         , ('history_octane', 'proposal_doc_validity', 'data_source_deleted_flag', FALSE, 16)
)

   , new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT new_staging_table_definitions.dwid, new_fields.field_name, new_fields.key_field_flag
        FROM new_fields
        JOIN new_staging_table_definitions
             ON new_fields.table_name = new_staging_table_definitions.table_name
        WHERE new_fields.schema_name = 'staging_octane'
        RETURNING dwid, edw_table_definition_dwid, field_name
)

   , new_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag,
                                          source_edw_field_definition_dwid)
        SELECT new_history_table_definitions.dwid
             , new_fields.field_name
             , new_fields.key_field_flag
             , new_staging_field_definitions.dwid
        FROM new_fields
        JOIN new_staging_table_definitions
             ON new_fields.table_name = new_staging_table_definitions.table_name
        JOIN new_history_table_definitions
             ON new_fields.table_name = new_history_table_definitions.table_name
        LEFT JOIN new_staging_field_definitions
                  ON new_staging_table_definitions.dwid =
                     new_staging_field_definitions.edw_table_definition_dwid
                      AND new_fields.field_name = new_staging_field_definitions.field_name
        WHERE new_fields.schema_name = 'history_octane'
)

   , new_process_variables (name, target_table, json_output_field, sql) AS (
    VALUES ('SP-100842', 'smart_doc_validity_date_case', 'sdvdc_pid', '--finding records to insert into history_octane.smart_doc_validity_date_case
SELECT staging_table.sdvdc_pid,  staging_table.sdvdc_version,  staging_table.sdvdc_smart_doc_pid,  staging_table.sdvdc_criteria_pid,  staging_table.sdvdc_criteria_html,  staging_table.sdvdc_deal_child_type,  staging_table.sdvdc_deal_child_relationship_type,  staging_table.sdvdc_doc_validity_type,  staging_table.sdvdc_doc_key_date_type,  staging_table.sdvdc_expiration_calendar_rule_type,  staging_table.sdvdc_days_before_key_date,  staging_table.sdvdc_warning_days,  staging_table.sdvdc_ordinal,  staging_table.sdvdc_else_case,  staging_table.sdvdc_active,  FALSE AS data_source_deleted_flag,  NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_doc_validity_date_case staging_table
LEFT JOIN history_octane.smart_doc_validity_date_case history_table
          ON staging_table.sdvdc_pid = history_table.sdvdc_pid AND staging_table.sdvdc_version = history_table.sdvdc_version
WHERE history_table.sdvdc_pid IS NULL
UNION ALL
SELECT history_table.sdvdc_pid,  history_table.sdvdc_version + 1,  history_table.sdvdc_smart_doc_pid,  history_table.sdvdc_criteria_pid,  history_table.sdvdc_criteria_html,  history_table.sdvdc_deal_child_type,  history_table.sdvdc_deal_child_relationship_type,  history_table.sdvdc_doc_validity_type,  history_table.sdvdc_doc_key_date_type,  history_table.sdvdc_expiration_calendar_rule_type,  history_table.sdvdc_days_before_key_date,  history_table.sdvdc_warning_days,  history_table.sdvdc_ordinal,  history_table.sdvdc_else_case,  history_table.sdvdc_active,  TRUE AS data_source_deleted_flag,  NOW( ) AS data_source_updated_datetime
FROM history_octane.smart_doc_validity_date_case history_table
LEFT JOIN staging_octane.smart_doc_validity_date_case staging_table
          ON staging_table.sdvdc_pid = history_table.sdvdc_pid
WHERE staging_table.sdvdc_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.smart_doc_validity_date_case deleted_records
                  WHERE deleted_records.sdvdc_pid = history_table.sdvdc_pid AND deleted_records.data_source_deleted_flag = TRUE );
')
         , ('SP-100843', 'proposal_doc_validity', 'prpdv_pid', '--finding records to insert into history_octane.proposal_doc_validity
SELECT staging_table.prpdv_pid,  staging_table.prpdv_version,  staging_table.prpdv_proposal_doc_pid,  staging_table.prpdv_smart_doc_validity_date_case_pid,  staging_table.prpdv_deal_pid,  staging_table.prpdv_proposal_pid,  staging_table.prpdv_valid_from_date,  staging_table.prpdv_valid_through_date,  staging_table.prpdv_key_date,  staging_table.prpdv_doc_validity_type,  staging_table.prpdv_doc_key_date_type,  staging_table.prpdv_expiration_calendar_rule_type,  staging_table.prpdv_days_before_key_date,  staging_table.prpdv_warning_days,  FALSE AS data_source_deleted_flag,  NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal_doc_validity staging_table
LEFT JOIN history_octane.proposal_doc_validity history_table
          ON staging_table.prpdv_pid = history_table.prpdv_pid AND staging_table.prpdv_version = history_table.prpdv_version
WHERE history_table.prpdv_pid IS NULL
UNION ALL
SELECT history_table.prpdv_pid,  history_table.prpdv_version + 1,  history_table.prpdv_proposal_doc_pid,  history_table.prpdv_smart_doc_validity_date_case_pid,  history_table.prpdv_deal_pid,  history_table.prpdv_proposal_pid,  history_table.prpdv_valid_from_date,  history_table.prpdv_valid_through_date,  history_table.prpdv_key_date,  history_table.prpdv_doc_validity_type,  history_table.prpdv_doc_key_date_type,  history_table.prpdv_expiration_calendar_rule_type,  history_table.prpdv_days_before_key_date,  history_table.prpdv_warning_days,  TRUE AS data_source_deleted_flag,  NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal_doc_validity history_table
LEFT JOIN staging_octane.proposal_doc_validity staging_table
          ON staging_table.prpdv_pid = history_table.prpdv_pid
WHERE staging_table.prpdv_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.proposal_doc_validity deleted_records
                  WHERE deleted_records.prpdv_pid = history_table.prpdv_pid AND deleted_records.data_source_deleted_flag = TRUE );
')
)
   , new_processes AS (
    INSERT INTO mdi.process (name, description)
        SELECT new_process_variables.name
             , 'ETL to copy ' || new_process_variables.target_table || ' data from staging_octane to history_octane'
        FROM new_process_variables
        RETURNING dwid, name, description
)

   , new_table_input_steps AS (
    INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables,
                                      enable_lazy_conversion, cached_row_meta, connectionname)
        SELECT new_processes.dwid
             , 0
             , new_process_variables.sql
             , 0
             , 'N'
             , 'N'
             , 'N'
             , 'N'
             , 'Staging DB Connection'
        FROM new_processes
        JOIN new_process_variables
             ON new_processes.name = new_process_variables.name
)

   , new_table_output_steps AS (
    INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field,
                                       auto_generated_key_field, partition_data_per, table_name_defined_in_field,
                                       return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables,
                                       specify_database_fields, ignore_insert_errors, use_batch_update)
        SELECT new_processes.dwid
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
        FROM new_processes
        JOIN new_process_variables
             ON new_processes.name = new_process_variables.name
        RETURNING dwid, target_schema, target_table
)

   , new_table_output_fields AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
        SELECT new_table_output_steps.dwid
             , new_fields.field_name
             , new_fields.field_name
             , new_fields.field_order
             , FALSE
        FROM new_table_output_steps
        JOIN new_fields
             ON new_fields.schema_name = new_table_output_steps.target_schema
                 AND new_fields.table_name = new_table_output_steps.target_table
)

   , new_json_output_fields AS (
    INSERT INTO mdi.json_output_field (process_dwid, field_name)
        SELECT new_processes.dwid, new_process_variables.json_output_field
        FROM new_processes
        JOIN new_process_variables
             ON new_processes.name = new_process_variables.name
)

   , new_state_machine_definitions AS (
    INSERT INTO mdi.state_machine_definition (process_dwid, name, comment)
        SELECT new_processes.dwid, new_processes.name, new_processes.description
        FROM new_processes
)
SELECT 'Finished inserting metadata for new tables: smart_doc_validity_date_case, proposal_doc_validity';

--Insert metadata for new columns: criteria_snippet.crs_compatible_with_smart_doc_validity_date_case
WITH new_fields (table_name, field_name, field_order) AS (
    VALUES ('criteria_snippet', 'crs_compatible_with_smart_doc_validity_date_case', 17)
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
    VALUES ('criteria_snippet', '--finding records to insert into history_octane.criteria_snippet
SELECT staging_table.crs_pid,  staging_table.crs_version,  staging_table.crs_account_pid,  staging_table.crs_name,  staging_table.crs_criteria_pid,  staging_table.crs_description,  staging_table.crs_deal_child_type,  staging_table.crs_compatible_with_smart_charge_case,  staging_table.crs_compatible_with_smart_req,  staging_table.crs_compatible_with_stack_separator,  staging_table.crs_compatible_with_investor_eligibility,  staging_table.crs_compatible_with_wf_smart_task,  staging_table.crs_compatible_with_wf_outcome,  staging_table.crs_compatible_with_wf_smart_process,  staging_table.crs_compatible_with_smart_doc,  staging_table.crs_compatible_with_smart_doc_validity_date_case,  FALSE AS data_source_deleted_flag,  NOW( ) AS data_source_updated_datetime
FROM staging_octane.criteria_snippet staging_table
LEFT JOIN history_octane.criteria_snippet history_table
          ON staging_table.crs_pid = history_table.crs_pid AND staging_table.crs_version = history_table.crs_version
WHERE history_table.crs_pid IS NULL
UNION ALL
SELECT history_table.crs_pid,  history_table.crs_version + 1,  history_table.crs_account_pid,  history_table.crs_name,  history_table.crs_criteria_pid,  history_table.crs_description,  history_table.crs_deal_child_type,  history_table.crs_compatible_with_smart_charge_case,  history_table.crs_compatible_with_smart_req,  history_table.crs_compatible_with_stack_separator,  history_table.crs_compatible_with_investor_eligibility,  history_table.crs_compatible_with_wf_smart_task,  history_table.crs_compatible_with_wf_outcome,  history_table.crs_compatible_with_wf_smart_process,  history_table.crs_compatible_with_smart_doc,  history_table.crs_compatible_with_smart_doc_validity_date_case,  TRUE AS data_source_deleted_flag,  NOW( ) AS data_source_updated_datetime
FROM history_octane.criteria_snippet history_table
LEFT JOIN staging_octane.criteria_snippet staging_table
          ON staging_table.crs_pid = history_table.crs_pid
WHERE staging_table.crs_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.criteria_snippet deleted_records
                  WHERE deleted_records.crs_pid = history_table.crs_pid AND deleted_records.data_source_deleted_flag = TRUE );')
)
   , updated_table_input_step AS (
    UPDATE mdi.table_input_step
        SET sql = updated_table_input_sql.sql
        FROM updated_table_input_sql, mdi.table_output_step
        WHERE table_input_step.process_dwid = table_output_step.process_dwid
            AND table_output_step.target_schema = 'history_octane'
            AND table_output_step.target_table = updated_table_input_sql.table_name
)
SELECT 'Finished inserting metadata for new columns: criteria_snippet.crs_compatible_with_smart_doc_validity_date_case';
