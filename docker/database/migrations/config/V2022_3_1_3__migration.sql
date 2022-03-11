--
-- Main | EDW | Octane schema synchronization for v2022.3.2.0 (2022-03-11) https://app.asana.com/0/0/1201943559059092
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'staging_octane', 'config_note_scope_type', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note_comment', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note_monitor', NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'config_note_scope_type', 'staging', 'staging_octane', 'config_note_scope_type')
         , ('staging', 'history_octane', 'config_note', 'staging', 'staging_octane', 'config_note')
         , ('staging', 'history_octane', 'config_note_comment', 'staging', 'staging_octane', 'config_note_comment')
         , ('staging', 'history_octane', 'config_note_monitor', 'staging', 'staging_octane', 'config_note_monitor')
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
    VALUES ('staging', 'history_octane', 'config_note_scope_type', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'config_note_scope_type', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'config_note_scope_type', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'config_note', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'config_note', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'config_note', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'config_note_comment', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'config_note_comment', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'config_note_comment', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'config_note_monitor', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'config_note_monitor', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'config_note_monitor', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note_scope_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note_scope_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_doc', 'sd_action_entity_production_manager', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_account_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_author_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_author_unparsed_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_config_note_scope_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_content', 'VARCHAR(16000)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_create_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_location_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_old_location_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_old_smart_doc_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_old_wf_process_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_old_wf_step_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_scope_name', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_smart_doc_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_wf_process_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note', 'cn_wf_step_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note_comment', 'cnc_author_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note_comment', 'cnc_author_unparsed_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note_comment', 'cnc_config_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note_comment', 'cnc_content', 'VARCHAR(16000)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note_comment', 'cnc_create_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note_comment', 'cnc_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note_comment', 'cnc_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_key_roles', 'dkrs_production_manager_fmls', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'deal_key_roles', 'dkrs_production_manager_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note_monitor', 'cnm_config_note_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note_monitor', 'cnm_lender_user_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note_monitor', 'cnm_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'config_note_monitor', 'cnm_version', 'INTEGER', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'config_note_scope_type', 'code', 'VARCHAR(128)', 'staging', 'staging_octane', 'config_note_scope_type', 'code')
         , ('staging', 'history_octane', 'config_note_scope_type', 'value', 'VARCHAR(1024)', 'staging', 'staging_octane', 'config_note_scope_type', 'value')
         , ('staging', 'history_octane', 'smart_doc', 'sd_action_entity_production_manager', 'BOOLEAN', 'staging', 'staging_octane', 'smart_doc', 'sd_action_entity_production_manager')
         , ('staging', 'history_octane', 'config_note', 'cn_account_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note', 'cn_account_pid')
         , ('staging', 'history_octane', 'config_note', 'cn_author_lender_user_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note', 'cn_author_lender_user_pid')
         , ('staging', 'history_octane', 'config_note', 'cn_author_unparsed_name', 'VARCHAR(128)', 'staging', 'staging_octane', 'config_note', 'cn_author_unparsed_name')
         , ('staging', 'history_octane', 'config_note', 'cn_config_note_scope_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'config_note', 'cn_config_note_scope_type')
         , ('staging', 'history_octane', 'config_note', 'cn_content', 'VARCHAR(16000)', 'staging', 'staging_octane', 'config_note', 'cn_content')
         , ('staging', 'history_octane', 'config_note', 'cn_create_datetime', 'TIMESTAMP', 'staging', 'staging_octane', 'config_note', 'cn_create_datetime')
         , ('staging', 'history_octane', 'config_note', 'cn_location_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note', 'cn_location_pid')
         , ('staging', 'history_octane', 'config_note', 'cn_old_location_note_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note', 'cn_old_location_note_pid')
         , ('staging', 'history_octane', 'config_note', 'cn_old_smart_doc_note_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note', 'cn_old_smart_doc_note_pid')
         , ('staging', 'history_octane', 'config_note', 'cn_old_wf_process_note_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note', 'cn_old_wf_process_note_pid')
         , ('staging', 'history_octane', 'config_note', 'cn_old_wf_step_note_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note', 'cn_old_wf_step_note_pid')
         , ('staging', 'history_octane', 'config_note', 'cn_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note', 'cn_pid')
         , ('staging', 'history_octane', 'config_note', 'cn_scope_name', 'VARCHAR(1024)', 'staging', 'staging_octane', 'config_note', 'cn_scope_name')
         , ('staging', 'history_octane', 'config_note', 'cn_smart_doc_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note', 'cn_smart_doc_pid')
         , ('staging', 'history_octane', 'config_note', 'cn_version', 'INTEGER', 'staging', 'staging_octane', 'config_note', 'cn_version')
         , ('staging', 'history_octane', 'config_note', 'cn_wf_process_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note', 'cn_wf_process_pid')
         , ('staging', 'history_octane', 'config_note', 'cn_wf_step_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note', 'cn_wf_step_pid')
         , ('staging', 'history_octane', 'config_note_comment', 'cnc_author_lender_user_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note_comment', 'cnc_author_lender_user_pid')
         , ('staging', 'history_octane', 'config_note_comment', 'cnc_author_unparsed_name', 'VARCHAR(128)', 'staging', 'staging_octane', 'config_note_comment', 'cnc_author_unparsed_name')
         , ('staging', 'history_octane', 'config_note_comment', 'cnc_config_note_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note_comment', 'cnc_config_note_pid')
         , ('staging', 'history_octane', 'config_note_comment', 'cnc_content', 'VARCHAR(16000)', 'staging', 'staging_octane', 'config_note_comment', 'cnc_content')
         , ('staging', 'history_octane', 'config_note_comment', 'cnc_create_datetime', 'TIMESTAMP', 'staging', 'staging_octane', 'config_note_comment', 'cnc_create_datetime')
         , ('staging', 'history_octane', 'config_note_comment', 'cnc_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note_comment', 'cnc_pid')
         , ('staging', 'history_octane', 'config_note_comment', 'cnc_version', 'INTEGER', 'staging', 'staging_octane', 'config_note_comment', 'cnc_version')
         , ('staging', 'history_octane', 'deal_key_roles', 'dkrs_production_manager_fmls', 'VARCHAR(128)', 'staging', 'staging_octane', 'deal_key_roles', 'dkrs_production_manager_fmls')
         , ('staging', 'history_octane', 'deal_key_roles', 'dkrs_production_manager_lender_user_pid', 'BIGINT', 'staging', 'staging_octane', 'deal_key_roles', 'dkrs_production_manager_lender_user_pid')
         , ('staging', 'history_octane', 'config_note_monitor', 'cnm_config_note_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note_monitor', 'cnm_config_note_pid')
         , ('staging', 'history_octane', 'config_note_monitor', 'cnm_lender_user_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note_monitor', 'cnm_lender_user_pid')
         , ('staging', 'history_octane', 'config_note_monitor', 'cnm_pid', 'BIGINT', 'staging', 'staging_octane', 'config_note_monitor', 'cnm_pid')
         , ('staging', 'history_octane', 'config_note_monitor', 'cnm_version', 'INTEGER', 'staging', 'staging_octane', 'config_note_monitor', 'cnm_version')
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
VALUES ('SP-100904', 'ETL to insert records into staging.history_octane.config_note_scope_type using staging.staging_octane.config_note_scope_type as the primary source')
     , ('SP-100901', 'ETL to insert records into staging.history_octane.config_note using staging.staging_octane.config_note as the primary source')
     , ('SP-100902', 'ETL to insert records into staging.history_octane.config_note_comment using staging.staging_octane.config_note_comment as the primary source')
     , ('SP-100903', 'ETL to insert records into staging.history_octane.config_note_monitor using staging.staging_octane.config_note_monitor as the primary source');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100904', 0, '--finding records to insert into history_octane.config_note_scope_type
SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.config_note_scope_type staging_table
LEFT JOIN history_octane.config_note_scope_type history_table
          ON staging_table.code = history_table.code
              AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;', 'Staging DB Connection')
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
     , staging_table.cn_old_location_note_pid
     , staging_table.cn_old_smart_doc_note_pid
     , staging_table.cn_old_wf_process_note_pid
     , staging_table.cn_old_wf_step_note_pid
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
     , history_table.cn_old_location_note_pid
     , history_table.cn_old_smart_doc_note_pid
     , history_table.cn_old_wf_process_note_pid
     , history_table.cn_old_wf_step_note_pid
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
         , ('SP-100902', 0, '--finding records to insert into history_octane.config_note_comment
SELECT staging_table.cnc_pid
     , staging_table.cnc_version
     , staging_table.cnc_config_note_pid
     , staging_table.cnc_create_datetime
     , staging_table.cnc_content
     , staging_table.cnc_author_unparsed_name
     , staging_table.cnc_author_lender_user_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.config_note_comment staging_table
LEFT JOIN history_octane.config_note_comment history_table
          ON staging_table.cnc_pid = history_table.cnc_pid
              AND staging_table.cnc_version = history_table.cnc_version
WHERE history_table.cnc_pid IS NULL
UNION ALL
SELECT history_table.cnc_pid
     , history_table.cnc_version + 1
     , history_table.cnc_config_note_pid
     , history_table.cnc_create_datetime
     , history_table.cnc_content
     , history_table.cnc_author_unparsed_name
     , history_table.cnc_author_lender_user_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.config_note_comment history_table
LEFT JOIN staging_octane.config_note_comment staging_table
          ON staging_table.cnc_pid = history_table.cnc_pid
WHERE staging_table.cnc_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.config_note_comment deleted_records
    WHERE deleted_records.cnc_pid = history_table.cnc_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100903', 0, '--finding records to insert into history_octane.config_note_monitor
SELECT staging_table.cnm_pid
     , staging_table.cnm_version
     , staging_table.cnm_config_note_pid
     , staging_table.cnm_lender_user_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.config_note_monitor staging_table
LEFT JOIN history_octane.config_note_monitor history_table
          ON staging_table.cnm_pid = history_table.cnm_pid
              AND staging_table.cnm_version = history_table.cnm_version
WHERE history_table.cnm_pid IS NULL
UNION ALL
SELECT history_table.cnm_pid
     , history_table.cnm_version + 1
     , history_table.cnm_config_note_pid
     , history_table.cnm_lender_user_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.config_note_monitor history_table
LEFT JOIN staging_octane.config_note_monitor staging_table
          ON staging_table.cnm_pid = history_table.cnm_pid
WHERE staging_table.cnm_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.config_note_monitor deleted_records
    WHERE deleted_records.cnm_pid = history_table.cnm_pid
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
    VALUES ('SP-100904', 'history_octane', 'config_note_scope_type', 'N', 'Staging DB Connection')
         , ('SP-100901', 'history_octane', 'config_note', 'N', 'Staging DB Connection')
         , ('SP-100902', 'history_octane', 'config_note_comment', 'N', 'Staging DB Connection')
         , ('SP-100903', 'history_octane', 'config_note_monitor', 'N', 'Staging DB Connection')
)
INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT process.dwid, insert_rows.target_schema, insert_rows.target_table, 1000, NULL, NULL, NULL, NULL, 'N', NULL, insert_rows.truncate_table::mdi.pentaho_y_or_n, insert_rows.connectionname, 'N', 'Y', 'N', 'N'
FROM insert_rows
    JOIN mdi.process
        ON process.name = insert_rows.process_name;

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('SP-100904', 'code')
         , ('SP-100904', 'data_source_deleted_flag')
         , ('SP-100904', 'data_source_updated_datetime')
         , ('SP-100904', 'etl_batch_id')
         , ('SP-100904', 'value')
         , ('SP-100333', 'sd_action_entity_production_manager')
         , ('SP-100901', 'cn_account_pid')
         , ('SP-100901', 'cn_author_lender_user_pid')
         , ('SP-100901', 'cn_author_unparsed_name')
         , ('SP-100901', 'cn_config_note_scope_type')
         , ('SP-100901', 'cn_content')
         , ('SP-100901', 'cn_create_datetime')
         , ('SP-100901', 'cn_location_pid')
         , ('SP-100901', 'cn_old_location_note_pid')
         , ('SP-100901', 'cn_old_smart_doc_note_pid')
         , ('SP-100901', 'cn_old_wf_process_note_pid')
         , ('SP-100901', 'cn_old_wf_step_note_pid')
         , ('SP-100901', 'cn_pid')
         , ('SP-100901', 'cn_scope_name')
         , ('SP-100901', 'cn_smart_doc_pid')
         , ('SP-100901', 'cn_version')
         , ('SP-100901', 'cn_wf_process_pid')
         , ('SP-100901', 'cn_wf_step_pid')
         , ('SP-100901', 'data_source_deleted_flag')
         , ('SP-100901', 'data_source_updated_datetime')
         , ('SP-100901', 'etl_batch_id')
         , ('SP-100902', 'cnc_author_lender_user_pid')
         , ('SP-100902', 'cnc_author_unparsed_name')
         , ('SP-100902', 'cnc_config_note_pid')
         , ('SP-100902', 'cnc_content')
         , ('SP-100902', 'cnc_create_datetime')
         , ('SP-100902', 'cnc_pid')
         , ('SP-100902', 'cnc_version')
         , ('SP-100902', 'data_source_deleted_flag')
         , ('SP-100902', 'data_source_updated_datetime')
         , ('SP-100902', 'etl_batch_id')
         , ('SP-100017', 'dkrs_production_manager_fmls')
         , ('SP-100017', 'dkrs_production_manager_lender_user_pid')
         , ('SP-100903', 'cnm_config_note_pid')
         , ('SP-100903', 'cnm_lender_user_pid')
         , ('SP-100903', 'cnm_pid')
         , ('SP-100903', 'cnm_version')
         , ('SP-100903', 'data_source_deleted_flag')
         , ('SP-100903', 'data_source_updated_datetime')
         , ('SP-100903', 'etl_batch_id')
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
    VALUES ('SP-100904', 'code')
         , ('SP-100901', 'cn_pid')
         , ('SP-100902', 'cnc_pid')
         , ('SP-100903', 'cnm_pid')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
    JOIN mdi.process
        ON insert_rows.process_name = process.name;

--state_machine_definition
WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-100904', 'SP-100904', 'ETL to insert records into staging.history_octane.config_note_scope_type using staging.staging_octane.config_note_scope_type as the primary source')
         , ('SP-100901', 'SP-100901', 'ETL to insert records into staging.history_octane.config_note using staging.staging_octane.config_note as the primary source')
         , ('SP-100902', 'SP-100902', 'ETL to insert records into staging.history_octane.config_note_comment using staging.staging_octane.config_note_comment as the primary source')
         , ('SP-100903', 'SP-100903', 'ETL to insert records into staging.history_octane.config_note_monitor using staging.staging_octane.config_note_monitor as the primary source')
)
INSERT
INTO mdi.state_machine_definition (process_dwid, name, comment)
SELECT process.dwid, insert_rows.state_machine_name, insert_rows.state_machine_comment
FROM insert_rows
    JOIN mdi.process
        ON process.name = insert_rows.process_name;


/*
UPDATES
*/

--table_input_step
WITH update_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100333', 0, '--finding records to insert into history_octane.smart_doc
SELECT staging_table.sd_pid
     , staging_table.sd_version
     , staging_table.sd_account_pid
     , staging_table.sd_doc_set_type
     , staging_table.sd_custom_form_pid
     , staging_table.sd_doc_name
     , staging_table.sd_doc_number
     , staging_table.sd_doc_category_type
     , staging_table.sd_doc_file_source_type
     , staging_table.sd_doc_external_provider_type
     , staging_table.sd_broker_applicable_provider
     , staging_table.sd_action_entities_from_merge_field
     , staging_table.sd_action_entity_applicant
     , staging_table.sd_action_entity_non_applicant
     , staging_table.sd_action_entity_underwriter
     , staging_table.sd_action_entity_originator
     , staging_table.sd_doc_borrower_access_mode_type
     , staging_table.sd_borrower_explanation
     , staging_table.sd_deal_child_type
     , staging_table.sd_doc_fulfill_status_type_default
     , staging_table.sd_prior_to_type
     , staging_table.sd_doc_action_type
     , staging_table.sd_e_delivery
     , staging_table.sd_active
     , staging_table.sd_key_doc_type
     , staging_table.sd_key_doc_include_file
     , staging_table.sd_doc_approval_type
     , staging_table.sd_auto_approve
     , staging_table.sd_auto_include_on_request
     , staging_table.sd_poa_applicable
     , staging_table.sd_action_entity_hud_va_lender_officer
     , staging_table.sd_action_entity_collateral_underwriter
     , staging_table.sd_action_entity_wholesale_client_advocate
     , staging_table.sd_action_entity_correspondent_client_advocate
     , staging_table.sd_action_entity_government_insurance
     , staging_table.sd_action_entity_underwriting_manager
     , staging_table.sd_action_entity_effective_collateral_underwriter
     , staging_table.sd_document_explanation
     , staging_table.sd_document_explanation_reference
     , staging_table.sd_action_entity_supplemental_originator
     , staging_table.sd_action_entity_referring_associate
     , staging_table.sd_action_entity_production_manager
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_doc staging_table
LEFT JOIN history_octane.smart_doc history_table
          ON staging_table.sd_pid = history_table.sd_pid
              AND staging_table.sd_version = history_table.sd_version
WHERE history_table.sd_pid IS NULL
UNION ALL
SELECT history_table.sd_pid
     , history_table.sd_version + 1
     , history_table.sd_account_pid
     , history_table.sd_doc_set_type
     , history_table.sd_custom_form_pid
     , history_table.sd_doc_name
     , history_table.sd_doc_number
     , history_table.sd_doc_category_type
     , history_table.sd_doc_file_source_type
     , history_table.sd_doc_external_provider_type
     , history_table.sd_broker_applicable_provider
     , history_table.sd_action_entities_from_merge_field
     , history_table.sd_action_entity_applicant
     , history_table.sd_action_entity_non_applicant
     , history_table.sd_action_entity_underwriter
     , history_table.sd_action_entity_originator
     , history_table.sd_doc_borrower_access_mode_type
     , history_table.sd_borrower_explanation
     , history_table.sd_deal_child_type
     , history_table.sd_doc_fulfill_status_type_default
     , history_table.sd_prior_to_type
     , history_table.sd_doc_action_type
     , history_table.sd_e_delivery
     , history_table.sd_active
     , history_table.sd_key_doc_type
     , history_table.sd_key_doc_include_file
     , history_table.sd_doc_approval_type
     , history_table.sd_auto_approve
     , history_table.sd_auto_include_on_request
     , history_table.sd_poa_applicable
     , history_table.sd_action_entity_hud_va_lender_officer
     , history_table.sd_action_entity_collateral_underwriter
     , history_table.sd_action_entity_wholesale_client_advocate
     , history_table.sd_action_entity_correspondent_client_advocate
     , history_table.sd_action_entity_government_insurance
     , history_table.sd_action_entity_underwriting_manager
     , history_table.sd_action_entity_effective_collateral_underwriter
     , history_table.sd_document_explanation
     , history_table.sd_document_explanation_reference
     , history_table.sd_action_entity_supplemental_originator
     , history_table.sd_action_entity_referring_associate
     , history_table.sd_action_entity_production_manager
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.smart_doc history_table
LEFT JOIN staging_octane.smart_doc staging_table
          ON staging_table.sd_pid = history_table.sd_pid
WHERE staging_table.sd_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.smart_doc deleted_records
    WHERE deleted_records.sd_pid = history_table.sd_pid
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
)
UPDATE mdi.table_input_step
SET data_source_dwid = update_rows.data_source_dwid
    , sql = update_rows.sql
    , connectionname = update_rows.connectionname::mdi.pentaho_db_connection_name
FROM update_rows
    JOIN mdi.process
        ON process.name = update_rows.process_name
WHERE process.dwid = table_input_step.process_dwid;

--state_machine_step
WITH insert_rows (process_name, next_process_name) AS (
    VALUES ('SP-100369', 'SP-400003-delete') -- patch for issue introduced in 2022.3.1.2
         , ('SP-100369', 'SP-400003-insert-update') -- patch for issue introduced in 2022.3.1.2
)
INSERT
INTO mdi.state_machine_step (process_dwid, next_process_dwid)
SELECT process.dwid, next_process.dwid
FROM insert_rows
    JOIN mdi.process
        ON process.name = insert_rows.process_name
    JOIN mdi.process next_process
        ON next_process.name = insert_rows.next_process_name;
