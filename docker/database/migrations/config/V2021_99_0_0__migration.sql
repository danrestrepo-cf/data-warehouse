--
-- Main | Octane schemas from prod-release to v2021.11.3.0 on uat
-- https://app.asana.com/0/0/1201374364166630
--

-- Insert metadata for new tables: smart_message_available_attachment
WITH new_staging_table_definitions AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'smart_message_available_attachment', NULL)
             , ('staging', 'staging_octane', 'deal_message_log_attachment', NULL)
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
   , new_fields (schema_name, table_name, field_name, data_type, field_order) AS (
    VALUES ('staging_octane', 'smart_message_available_attachment', 'smaa_pid', 'BIGINT', NULL)
         , ('staging_octane', 'smart_message_available_attachment', 'smaa_version', 'INTEGER', NULL)
         , ('staging_octane', 'smart_message_available_attachment', 'smaa_smart_message_pid', 'BIGINT', NULL)
         , ('staging_octane', 'smart_message_available_attachment', 'smaa_smart_doc_pid', 'BIGINT', NULL)
         , ('history_octane', 'smart_message_available_attachment', 'smaa_pid', 'BIGINT', 1)
         , ('history_octane', 'smart_message_available_attachment', 'smaa_version', 'INTEGER', 2)
         , ('history_octane', 'smart_message_available_attachment', 'smaa_smart_message_pid', 'BIGINT', 3)
         , ('history_octane', 'smart_message_available_attachment', 'smaa_smart_doc_pid', 'BIGINT', 4)
         , ('history_octane', 'smart_message_available_attachment', 'data_source_updated_datetime', 'TIMESTAMPTZ', 5)
         , ('history_octane', 'smart_message_available_attachment', 'data_source_deleted_flag', 'BOOLEAN', 6)
         , ('staging_octane', 'deal_message_log_attachment', 'dmloga_pid', 'BIGINT', NULL)
         , ('staging_octane', 'deal_message_log_attachment', 'dmloga_version', 'INTEGER', NULL)
         , ('staging_octane', 'deal_message_log_attachment', 'dmloga_deal_message_log_pid', 'BIGINT', NULL)
         , ('staging_octane', 'deal_message_log_attachment', 'dmloga_deal_file_pid', 'BIGINT', NULL)
         , ('history_octane', 'deal_message_log_attachment', 'dmloga_pid', 'BIGINT', 1)
         , ('history_octane', 'deal_message_log_attachment', 'dmloga_version', 'INTEGER', 2)
         , ('history_octane', 'deal_message_log_attachment', 'dmloga_deal_message_log_pid', 'BIGINT', 3)
         , ('history_octane', 'deal_message_log_attachment', 'dmloga_deal_file_pid', 'BIGINT', 4)
         , ('history_octane', 'deal_message_log_attachment', 'data_source_updated_datetime', 'TIMESTAMPTZ', 5)
         , ('history_octane', 'deal_message_log_attachment', 'data_source_deleted_flag', 'BOOLEAN', 6)
)
   , new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, data_type, key_field_flag)
        SELECT new_staging_table_definitions.dwid, new_fields.field_name, new_fields.data_type, FALSE
        FROM new_fields
        JOIN new_staging_table_definitions
             ON new_fields.table_name = new_staging_table_definitions.table_name
        WHERE new_fields.schema_name = 'staging_octane'
        RETURNING dwid, edw_table_definition_dwid, field_name
)
   , new_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, data_type, key_field_flag,
                                          source_edw_field_definition_dwid)
        SELECT new_history_table_definitions.dwid
             , new_fields.field_name
             , new_fields.data_type
             , FALSE
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
    VALUES ('SP-100871', 'smart_message_available_attachment', 'smaa_pid', '--finding records to insert into history_octane.smart_message_available_attachment
SELECT staging_table.smaa_pid
     , staging_table.smaa_version
     , staging_table.smaa_smart_message_pid
     , staging_table.smaa_smart_doc_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_message_available_attachment staging_table
LEFT JOIN history_octane.smart_message_available_attachment history_table
          ON staging_table.smaa_pid = history_table.smaa_pid
              AND staging_table.smaa_version = history_table.smaa_version
WHERE history_table.smaa_pid IS NULL
UNION ALL
SELECT history_table.smaa_pid
     , history_table.smaa_version + 1
     , history_table.smaa_smart_message_pid
     , history_table.smaa_smart_doc_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.smart_message_available_attachment history_table
LEFT JOIN staging_octane.smart_message_available_attachment staging_table
          ON staging_table.smaa_pid = history_table.smaa_pid
WHERE staging_table.smaa_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.smart_message_available_attachment deleted_records
    WHERE deleted_records.smaa_pid = history_table.smaa_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );')
         , ('SP-100872', 'deal_message_log_attachment', 'dmloga_pid', '--finding records to insert into history_octane.deal_message_log_attachment
SELECT staging_table.dmloga_pid
     , staging_table.dmloga_version
     , staging_table.dmloga_deal_message_log_pid
     , staging_table.dmloga_deal_file_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.deal_message_log_attachment staging_table
LEFT JOIN history_octane.deal_message_log_attachment history_table
          ON staging_table.dmloga_pid = history_table.dmloga_pid
              AND staging_table.dmloga_version = history_table.dmloga_version
WHERE history_table.dmloga_pid IS NULL
UNION ALL
SELECT history_table.dmloga_pid
     , history_table.dmloga_version + 1
     , history_table.dmloga_deal_message_log_pid
     , history_table.dmloga_deal_file_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.deal_message_log_attachment history_table
LEFT JOIN staging_octane.deal_message_log_attachment staging_table
          ON staging_table.dmloga_pid = history_table.dmloga_pid
WHERE staging_table.dmloga_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.deal_message_log_attachment deleted_records
    WHERE deleted_records.dmloga_pid = history_table.dmloga_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );')
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
SELECT 'Finished inserting metadata for new tables.';


--add new join definitions for new tables: smart_message_available_attachment, deal_message_log_attachment
WITH insert_rows (primary_database_name, primary_schema_name, primary_table_name, target_database_name, target_schema_name,
                  target_table_name, join_condition) AS (
    VALUES ('staging', 'history_octane', 'smart_message_available_attachment', 'staging', 'history_octane', 'smart_message', 'primary_table.smaa_smart_message_pid = target_table.smsg_pid')
         , ('staging', 'history_octane', 'smart_message_available_attachment', 'staging', 'history_octane', 'smart_doc', 'primary_table.smaa_smart_doc_pid = target_table.sd_pid')
         , ('staging', 'history_octane', 'deal_message_log_attachment', 'staging', 'history_octane', 'deal_message_log', 'primary_table.dmloga_deal_message_log_pid = target_table.dmlog_pid')
         , ('staging', 'history_octane', 'deal_message_log_attachment', 'staging', 'history_octane', 'deal_file', 'primary_table.dmloga_deal_file_pid = target_table.df_pid')
)
INSERT
INTO mdi.edw_join_definition (dwid, primary_edw_table_definition_dwid, target_edw_table_definition_dwid, join_type, join_condition)
SELECT NEXTVAL( 'mdi.edw_join_definition_dwid_seq' )
     , primary_table.dwid
     , target_table.dwid
     , 'left'
     , REPLACE( insert_rows.join_condition, 'target_table', 't' || CURRVAL( 'mdi.edw_join_definition_dwid_seq' ) )
FROM insert_rows
JOIN mdi.edw_table_definition primary_table
     ON insert_rows.primary_database_name = primary_table.database_name
         AND insert_rows.primary_schema_name = primary_table.schema_name
         AND insert_rows.primary_table_name = primary_table.table_name
JOIN mdi.edw_table_definition target_table
     ON insert_rows.target_database_name = target_table.database_name
         AND insert_rows.target_schema_name = target_table.schema_name
         AND insert_rows.target_table_name = target_table.table_name;


-- Insert metadata for new columns: smart_message.smsg_allow_custom_text
WITH new_fields (table_name, field_name, data_type, field_order) AS (
    VALUES ('smart_message', 'smsg_allow_custom_text', 'BOOLEAN', 17)
)
   , new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, data_type, key_field_flag)
        SELECT edw_table_definition.dwid
             , new_fields.field_name
             , new_fields.data_type
             , FALSE
        FROM new_fields
        JOIN mdi.edw_table_definition
             ON edw_table_definition.schema_name = 'staging_octane'
                 AND new_fields.table_name = edw_table_definition.table_name
        RETURNING dwid, edw_table_definition_dwid, field_name
)
   , new_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, data_type, key_field_flag,
                                          source_edw_field_definition_dwid)
        SELECT edw_table_definition.dwid
             , new_fields.field_name
             , new_fields.data_type
             , FALSE
             , new_staging_field_definitions.dwid
        FROM new_fields
        JOIN mdi.edw_table_definition
             ON edw_table_definition.schema_name = 'history_octane'
                 AND new_fields.table_name = edw_table_definition.table_name
        JOIN mdi.edw_table_definition AS source_table_definition
             ON source_table_definition.schema_name = 'staging_octane'
                 AND source_table_definition.table_name = new_fields.table_name
        JOIN new_staging_field_definitions
             ON new_staging_field_definitions.edw_table_definition_dwid = source_table_definition.dwid
                 AND new_staging_field_definitions.field_name = new_fields.field_name
)
   , new_table_output_fields AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
        SELECT table_output_step.dwid
             , new_fields.field_name
             , new_fields.field_name
             , new_fields.field_order
             , FALSE
        FROM new_fields
        JOIN mdi.table_output_step
             ON table_output_step.target_schema = 'history_octane'
                 AND table_output_step.target_table = new_fields.table_name
)
SELECT 'Finished inserting metadata for new columns.';


-- Remove metadata for deleted fields: deal_message_log.dmlog_attachment_deal_file_pid
WITH deleted_fields (table_name, field_name) AS (
    VALUES ('deal_message_log', 'dmlog_attachment_deal_file_pid')
)
   , delete_table_output_fields AS (
    DELETE
        FROM mdi.table_output_field
            USING mdi.table_output_step, deleted_fields
            WHERE table_output_field.table_output_step_dwid = table_output_step.dwid
                AND table_output_field.database_field_name = deleted_fields.field_name
                AND table_output_step.target_table = deleted_fields.table_name
)
   , nullify_history_field_sources AS (
    UPDATE mdi.edw_field_definition
        SET source_edw_field_definition_dwid = NULL
        FROM mdi.edw_table_definition
            JOIN deleted_fields
            ON edw_table_definition.table_name = deleted_fields.table_name
                AND edw_table_definition.schema_name = 'history_octane'
        WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
            AND edw_field_definition.field_name = deleted_fields.field_name
)
   , delete_staging_field_definitions AS (
    DELETE
        FROM mdi.edw_field_definition
            USING mdi.edw_table_definition, deleted_fields
            WHERE edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
                AND edw_field_definition.field_name = deleted_fields.field_name
                AND edw_table_definition.table_name = deleted_fields.table_name
                AND edw_table_definition.schema_name = 'staging_octane'
)
SELECT 'Finished removing metadata for deleted fields.';


--update table_input_step SQL for updated tables: smart_message, deal_message_log
WITH updated_table_input_sql (table_name, sql) AS (
    VALUES ('smart_message', '--finding records to insert into history_octane.smart_message
SELECT staging_table.smsg_pid
     , staging_table.smsg_version
     , staging_table.smsg_account_pid
     , staging_table.smsg_name
     , staging_table.smsg_delivery_type
     , staging_table.smsg_reply_to_role_pid
     , staging_table.smsg_email_subject
     , staging_table.smsg_message_source_type
     , staging_table.smsg_smart_doc_pid
     , staging_table.smsg_smart_stack_pid
     , staging_table.smsg_allow_ad_hoc
     , staging_table.smsg_send_securely
     , staging_table.smsg_id_num
     , staging_table.smsg_message_body
     , staging_table.smsg_email_closing_type
     , staging_table.smsg_allow_custom_text
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_message staging_table
LEFT JOIN history_octane.smart_message history_table
          ON staging_table.smsg_pid = history_table.smsg_pid
              AND staging_table.smsg_version = history_table.smsg_version
WHERE history_table.smsg_pid IS NULL
UNION ALL
SELECT history_table.smsg_pid
     , history_table.smsg_version + 1
     , history_table.smsg_account_pid
     , history_table.smsg_name
     , history_table.smsg_delivery_type
     , history_table.smsg_reply_to_role_pid
     , history_table.smsg_email_subject
     , history_table.smsg_message_source_type
     , history_table.smsg_smart_doc_pid
     , history_table.smsg_smart_stack_pid
     , history_table.smsg_allow_ad_hoc
     , history_table.smsg_send_securely
     , history_table.smsg_id_num
     , history_table.smsg_message_body
     , history_table.smsg_email_closing_type
     , history_table.smsg_allow_custom_text
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.smart_message history_table
LEFT JOIN staging_octane.smart_message staging_table
          ON staging_table.smsg_pid = history_table.smsg_pid
WHERE staging_table.smsg_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.smart_message deleted_records
    WHERE deleted_records.smsg_pid = history_table.smsg_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );')
         , ('deal_message_log', '--finding records to insert into history_octane.deal_message_log
SELECT staging_table.dmlog_pid
     , staging_table.dmlog_version
     , staging_table.dmlog_deal_pid
     , staging_table.dmlog_sent_datetime
     , staging_table.dmlog_delivery_type
     , staging_table.dmlog_to_recipients
     , staging_table.dmlog_email_reply_to
     , staging_table.dmlog_name
     , staging_table.dmlog_email_subject
     , staging_table.dmlog_email_body
     , staging_table.dmlog_sent_securely
     , staging_table.dmlog_cover_letter_deal_file_pid
     , staging_table.dmlog_cc_recipients
     , staging_table.dmlog_bcc_recipients
     , staging_table.dmlog_plain_text
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.deal_message_log staging_table
LEFT JOIN history_octane.deal_message_log history_table
          ON staging_table.dmlog_pid = history_table.dmlog_pid
              AND staging_table.dmlog_version = history_table.dmlog_version
WHERE history_table.dmlog_pid IS NULL
UNION ALL
SELECT history_table.dmlog_pid
     , history_table.dmlog_version + 1
     , history_table.dmlog_deal_pid
     , history_table.dmlog_sent_datetime
     , history_table.dmlog_delivery_type
     , history_table.dmlog_to_recipients
     , history_table.dmlog_email_reply_to
     , history_table.dmlog_name
     , history_table.dmlog_email_subject
     , history_table.dmlog_email_body
     , history_table.dmlog_sent_securely
     , history_table.dmlog_cover_letter_deal_file_pid
     , history_table.dmlog_cc_recipients
     , history_table.dmlog_bcc_recipients
     , history_table.dmlog_plain_text
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.deal_message_log history_table
LEFT JOIN staging_octane.deal_message_log staging_table
          ON staging_table.dmlog_pid = history_table.dmlog_pid
WHERE staging_table.dmlog_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.deal_message_log deleted_records
    WHERE deleted_records.dmlog_pid = history_table.dmlog_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );')
)
   , updated_table_input_step AS (
    UPDATE mdi.table_input_step
        SET sql = updated_table_input_sql.sql
        FROM updated_table_input_sql
            , mdi.table_output_step
        WHERE table_input_step.process_dwid = table_output_step.process_dwid
            AND table_output_step.target_schema = 'history_octane'
            AND table_output_step.target_table = updated_table_input_sql.table_name
)
SELECT 'Finished updated table_input_step SQL for updated tables.'
