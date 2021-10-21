--
-- Main | EDW - Octane schemas from prod-release to v2021.10.3.3 on uat
-- https://app.asana.com/0/0/1201229678686976
--

/*
Insert metadata for new tables:
    - wf_step_note
    - wf_step_note_comment
    - wf_step_note_monitor
    - wf_process_note
    - wf_process_note_comment
    - wf_process_note_monitor
*/

WITH new_staging_table_definitions AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'wf_step_note', NULL)
            , ('staging', 'staging_octane', 'wf_step_note_comment', NULL)
            , ('staging', 'staging_octane', 'wf_step_note_monitor', NULL)
            , ('staging', 'staging_octane', 'wf_process_note', NULL)
            , ('staging', 'staging_octane', 'wf_process_note_comment', NULL)
            , ('staging', 'staging_octane', 'wf_process_note_monitor', NULL)
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
    VALUES
        -- staging_octane.wf_step_note
        ('staging_octane', 'wf_step_note', 'wfsn_pid', TRUE, 1)
        , ('staging_octane', 'wf_step_note', 'wfsn_version', FALSE, 2)
        , ('staging_octane', 'wf_step_note', 'wfsn_wf_step_pid', FALSE, 3)
        , ('staging_octane', 'wf_step_note', 'wfsn_create_datetime', FALSE, 4)
        , ('staging_octane', 'wf_step_note', 'wfsn_content', FALSE, 5)
        , ('staging_octane', 'wf_step_note', 'wfsn_author_lender_user_pid', FALSE, 6)
        , ('staging_octane', 'wf_step_note', 'wfsn_author_unparsed_name', FALSE, 7)
        -- staging_octane.wf_step_note_comment
        , ('staging_octane', 'wf_step_note_comment', 'wfsnc_pid', TRUE, 1)
        , ('staging_octane', 'wf_step_note_comment', 'wfsnc_version', FALSE, 2)
        , ('staging_octane', 'wf_step_note_comment', 'wfsnc_wf_step_note_pid', FALSE, 3)
        , ('staging_octane', 'wf_step_note_comment', 'wfsnc_create_datetime', FALSE, 4)
        , ('staging_octane', 'wf_step_note_comment', 'wfsnc_content', FALSE, 5)
        , ('staging_octane', 'wf_step_note_comment', 'wfsnc_author_lender_user_pid', FALSE, 6)
        , ('staging_octane', 'wf_step_note_comment', 'wfsnc_author_unparsed_name', FALSE, 7)
        -- staging_octane.wf_step_note_monitor
        , ('staging_octane', 'wf_step_note_monitor', 'wfsnm_pid', TRUE, 1)
        , ('staging_octane', 'wf_step_note_monitor', 'wfsnm_version', FALSE, 2)
        , ('staging_octane', 'wf_step_note_monitor', 'wfsnm_wf_step_note_pid', FALSE, 3)
        , ('staging_octane', 'wf_step_note_monitor', 'wfsnm_lender_user_pid', FALSE, 4)
        -- staging_octane.wf_process_note
        , ('staging_octane', 'wf_process_note', 'wfpn_pid', TRUE, 1)
        , ('staging_octane', 'wf_process_note', 'wfpn_version', FALSE, 2)
        , ('staging_octane', 'wf_process_note', 'wfpn_wf_process_pid', FALSE, 3)
        , ('staging_octane', 'wf_process_note', 'wfpn_create_datetime', FALSE, 4)
        , ('staging_octane', 'wf_process_note', 'wfpn_content', FALSE, 5)
        , ('staging_octane', 'wf_process_note', 'wfpn_author_lender_user_pid', FALSE, 6)
        , ('staging_octane', 'wf_process_note', 'wfpn_author_unparsed_name', FALSE, 7)
        -- staging_octane.wf_process_note_comment
        , ('staging_octane', 'wf_process_note_comment', 'wfpnc_pid', TRUE, 1)
        , ('staging_octane', 'wf_process_note_comment', 'wfpnc_version', FALSE, 2)
        , ('staging_octane', 'wf_process_note_comment', 'wfpnc_wf_process_note_pid', FALSE, 3)
        , ('staging_octane', 'wf_process_note_comment', 'wfpnc_create_datetime', FALSE, 4)
        , ('staging_octane', 'wf_process_note_comment', 'wfpnc_content', FALSE, 5)
        , ('staging_octane', 'wf_process_note_comment', 'wfpnc_author_lender_user_pid', FALSE, 6)
        , ('staging_octane', 'wf_process_note_comment', 'wfpnc_author_unparsed_name', FALSE, 7)
        -- staging_octane.wf_process_note_monitor
        , ('staging_octane', 'wf_process_note_monitor', 'wfpnm_pid', TRUE, 1)
        , ('staging_octane', 'wf_process_note_monitor', 'wfpnm_version', FALSE, 2)
        , ('staging_octane', 'wf_process_note_monitor', 'wfpnm_wf_process_note_pid', FALSE, 3)
        , ('staging_octane', 'wf_process_note_monitor', 'wfpnm_lender_user_pid', FALSE, 4)
         -- history_octane.wf_step_note
        , ('history_octane', 'wf_step_note', 'wfsn_pid', TRUE, 1)
        , ('history_octane', 'wf_step_note', 'wfsn_version', FALSE, 2)
        , ('history_octane', 'wf_step_note', 'wfsn_wf_step_pid', FALSE, 3)
        , ('history_octane', 'wf_step_note', 'wfsn_create_datetime', FALSE, 4)
        , ('history_octane', 'wf_step_note', 'wfsn_content', FALSE, 5)
        , ('history_octane', 'wf_step_note', 'wfsn_author_lender_user_pid', FALSE, 6)
        , ('history_octane', 'wf_step_note', 'wfsn_author_unparsed_name', FALSE, 7)
        , ('history_octane', 'wf_step_note', 'data_source_updated_datetime', FALSE, 8)
        , ('history_octane', 'wf_step_note', 'data_source_deleted_flag', FALSE, 9)
        -- history_octane.wf_step_note_comment
        , ('history_octane', 'wf_step_note_comment', 'wfsnc_pid', TRUE, 1)
        , ('history_octane', 'wf_step_note_comment', 'wfsnc_version', FALSE, 2)
        , ('history_octane', 'wf_step_note_comment', 'wfsnc_wf_step_note_pid', FALSE, 3)
        , ('history_octane', 'wf_step_note_comment', 'wfsnc_create_datetime', FALSE, 4)
        , ('history_octane', 'wf_step_note_comment', 'wfsnc_content', FALSE, 5)
        , ('history_octane', 'wf_step_note_comment', 'wfsnc_author_lender_user_pid', FALSE, 6)
        , ('history_octane', 'wf_step_note_comment', 'wfsnc_author_unparsed_name', FALSE, 7)
        , ('history_octane', 'wf_step_note_comment', 'data_source_updated_datetime', FALSE, 8)
        , ('history_octane', 'wf_step_note_comment', 'data_source_deleted_flag', FALSE, 9)
        -- history_octane.wf_step_note_monitor
        , ('history_octane', 'wf_step_note_monitor', 'wfsnm_pid', TRUE, 1)
        , ('history_octane', 'wf_step_note_monitor', 'wfsnm_version', FALSE, 2)
        , ('history_octane', 'wf_step_note_monitor', 'wfsnm_wf_step_note_pid', FALSE, 3)
        , ('history_octane', 'wf_step_note_monitor', 'wfsnm_lender_user_pid', FALSE, 4)
        , ('history_octane', 'wf_step_note_monitor', 'data_source_updated_datetime', FALSE, 5)
        , ('history_octane', 'wf_step_note_monitor', 'data_source_deleted_flag', FALSE, 6)
        -- history_octane.wf_process_note
        , ('history_octane', 'wf_process_note', 'wfpn_pid', TRUE, 1)
        , ('history_octane', 'wf_process_note', 'wfpn_version', FALSE, 2)
        , ('history_octane', 'wf_process_note', 'wfpn_wf_process_pid', FALSE, 3)
        , ('history_octane', 'wf_process_note', 'wfpn_create_datetime', FALSE, 4)
        , ('history_octane', 'wf_process_note', 'wfpn_content', FALSE, 5)
        , ('history_octane', 'wf_process_note', 'wfpn_author_lender_user_pid', FALSE, 6)
        , ('history_octane', 'wf_process_note', 'wfpn_author_unparsed_name', FALSE, 7)
        , ('history_octane', 'wf_process_note', 'data_source_updated_datetime', FALSE, 8)
        , ('history_octane', 'wf_process_note', 'data_source_deleted_flag', FALSE, 9)
        -- history_octane.wf_process_note_comment
        , ('history_octane', 'wf_process_note_comment', 'wfpnc_pid', TRUE, 1)
        , ('history_octane', 'wf_process_note_comment', 'wfpnc_version', FALSE, 2)
        , ('history_octane', 'wf_process_note_comment', 'wfpnc_wf_process_note_pid', FALSE, 3)
        , ('history_octane', 'wf_process_note_comment', 'wfpnc_create_datetime', FALSE, 4)
        , ('history_octane', 'wf_process_note_comment', 'wfpnc_content', FALSE, 5)
        , ('history_octane', 'wf_process_note_comment', 'wfpnc_author_lender_user_pid', FALSE, 6)
        , ('history_octane', 'wf_process_note_comment', 'wfpnc_author_unparsed_name', FALSE, 7)
        , ('history_octane', 'wf_process_note_comment', 'data_source_updated_datetime', FALSE, 8)
        , ('history_octane', 'wf_process_note_comment', 'data_source_deleted_flag', FALSE, 9)
        -- history_octane.wf_process_note_monitor
        , ('history_octane', 'wf_process_note_monitor', 'wfpnm_pid', TRUE, 1)
        , ('history_octane', 'wf_process_note_monitor', 'wfpnm_version', FALSE, 2)
        , ('history_octane', 'wf_process_note_monitor', 'wfpnm_wf_process_note_pid', FALSE, 3)
        , ('history_octane', 'wf_process_note_monitor', 'wfpnm_lender_user_pid', FALSE, 4)
        , ('history_octane', 'wf_process_note_monitor', 'data_source_updated_datetime', FALSE, 5)
        , ('history_octane', 'wf_process_note_monitor', 'data_source_deleted_flag', FALSE, 6)
)

, new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT new_staging_table_definitions.dwid
            , new_fields.field_name
            , new_fields.key_field_flag
        FROM new_fields
            JOIN new_staging_table_definitions ON new_fields.table_name = new_staging_table_definitions.table_name
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
            JOIN new_staging_table_definitions ON new_fields.table_name = new_staging_table_definitions.table_name
            JOIN new_history_table_definitions ON new_fields.table_name = new_history_table_definitions.table_name
            LEFT JOIN new_staging_field_definitions ON new_staging_table_definitions.dwid =
                                                    new_staging_field_definitions.edw_table_definition_dwid
                AND new_fields.field_name = new_staging_field_definitions.field_name
        WHERE new_fields.schema_name = 'history_octane'
)

, new_process_variables (name, target_table, json_output_field, sql) AS (
    VALUES ('SP-100863', 'wf_step_note', 'wfsn_pid', '--finding records to insert into history_octane.wf_step_note
SELECT staging_table.wfsn_pid
     , staging_table.wfsn_version
     , staging_table.wfsn_wf_step_pid
     , staging_table.wfsn_create_datetime
     , staging_table.wfsn_content
     , staging_table.wfsn_author_lender_user_pid
     , staging_table.wfsn_author_unparsed_name
     , FALSE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM staging_octane.wf_step_note staging_table
         LEFT JOIN history_octane.wf_step_note history_table on staging_table.wfsn_pid = history_table.wfsn_pid and staging_table.wfsn_version = history_table.wfsn_version
WHERE history_table.wfsn_pid is NULL
UNION ALL
SELECT history_table.wfsn_pid
     , history_table.wfsn_version + 1
     , history_table.wfsn_wf_step_pid
     , history_table.wfsn_create_datetime
     , history_table.wfsn_content
     , history_table.wfsn_author_lender_user_pid
     , history_table.wfsn_author_unparsed_name
     , TRUE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM history_octane.wf_step_note history_table
         LEFT JOIN staging_octane.wf_step_note staging_table on staging_table.wfsn_pid = history_table.wfsn_pid
WHERE staging_table.wfsn_pid is NULL
  AND not exists (select 1 from history_octane.wf_step_note deleted_records where deleted_records.wfsn_pid = history_table.wfsn_pid and deleted_records.data_source_deleted_flag = True);')
        , ('SP-100864', 'wf_step_note_comment', 'wfsnc_pid', '--finding records to insert into history_octane.wf_step_note_comment
SELECT staging_table.wfsnc_pid
     , staging_table.wfsnc_version
     , staging_table.wfsnc_wf_step_note_pid
     , staging_table.wfsnc_create_datetime
     , staging_table.wfsnc_content
     , staging_table.wfsnc_author_lender_user_pid
     , staging_table.wfsnc_author_unparsed_name
     , FALSE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM staging_octane.wf_step_note_comment staging_table
         LEFT JOIN history_octane.wf_step_note_comment history_table on staging_table.wfsnc_pid = history_table.wfsnc_pid and staging_table.wfsnc_version = history_table.wfsnc_version
WHERE history_table.wfsnc_pid is NULL
UNION ALL
SELECT history_table.wfsnc_pid
     , history_table.wfsnc_version + 1
     , history_table.wfsnc_wf_step_note_pid
     , history_table.wfsnc_create_datetime
     , history_table.wfsnc_content
     , history_table.wfsnc_author_lender_user_pid
     , history_table.wfsnc_author_unparsed_name
     , TRUE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM history_octane.wf_step_note_comment history_table
         LEFT JOIN staging_octane.wf_step_note_comment staging_table on staging_table.wfsnc_pid = history_table.wfsnc_pid
WHERE staging_table.wfsnc_pid is NULL
  AND not exists (select 1 from history_octane.wf_step_note_comment deleted_records where deleted_records.wfsnc_pid = history_table.wfsnc_pid and deleted_records.data_source_deleted_flag = True);')
        , ('SP-100865', 'wf_step_note_monitor', 'wfsnm_pid', '--finding records to insert into history_octane.wf_step_note_monitor
SELECT staging_table.wfsnm_pid
     , staging_table.wfsnm_version
     , staging_table.wfsnm_wf_step_note_pid
     , staging_table.wfsnm_lender_user_pid
     , FALSE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM staging_octane.wf_step_note_monitor staging_table
         LEFT JOIN history_octane.wf_step_note_monitor history_table on staging_table.wfsnm_pid = history_table.wfsnm_pid and staging_table.wfsnm_version = history_table.wfsnm_version
WHERE history_table.wfsnm_pid is NULL
UNION ALL
SELECT history_table.wfsnm_pid
     , history_table.wfsnm_version + 1
     , history_table.wfsnm_wf_step_note_pid
     , history_table.wfsnm_lender_user_pid
     , TRUE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM history_octane.wf_step_note_monitor history_table
         LEFT JOIN staging_octane.wf_step_note_monitor staging_table on staging_table.wfsnm_pid = history_table.wfsnm_pid
WHERE staging_table.wfsnm_pid is NULL
  AND not exists (select 1 from history_octane.wf_step_note_monitor deleted_records where deleted_records.wfsnm_pid = history_table.wfsnm_pid and deleted_records.data_source_deleted_flag = True);
')
        , ('SP-100866', 'wf_process_note', 'wfpn_pid', '--finding records to insert into history_octane.wf_process_note
SELECT staging_table.wfpn_pid
     , staging_table.wfpn_version
     , staging_table.wfpn_wf_process_pid
     , staging_table.wfpn_create_datetime
     , staging_table.wfpn_content
     , staging_table.wfpn_author_lender_user_pid
     , staging_table.wfpn_author_unparsed_name
     , FALSE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM staging_octane.wf_process_note staging_table
         LEFT JOIN history_octane.wf_process_note history_table on staging_table.wfpn_pid = history_table.wfpn_pid and staging_table.wfpn_version = history_table.wfpn_version
WHERE history_table.wfpn_pid is NULL
UNION ALL
SELECT history_table.wfpn_pid
     , history_table.wfpn_version + 1
     , history_table.wfpn_wf_process_pid
     , history_table.wfpn_create_datetime
     , history_table.wfpn_content
     , history_table.wfpn_author_lender_user_pid
     , history_table.wfpn_author_unparsed_name
     , TRUE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM history_octane.wf_process_note history_table
         LEFT JOIN staging_octane.wf_process_note staging_table on staging_table.wfpn_pid = history_table.wfpn_pid
WHERE staging_table.wfpn_pid is NULL
  AND not exists (select 1 from history_octane.wf_process_note deleted_records where deleted_records.wfpn_pid = history_table.wfpn_pid and deleted_records.data_source_deleted_flag = True);')
        , ('SP-100867', 'wf_process_note_comment', 'wfpnc_pid', '--finding records to insert into history_octane.wf_process_note_comment
SELECT staging_table.wfpnc_pid
     , staging_table.wfpnc_version
     , staging_table.wfpnc_wf_process_note_pid
     , staging_table.wfpnc_create_datetime
     , staging_table.wfpnc_content
     , staging_table.wfpnc_author_lender_user_pid
     , staging_table.wfpnc_author_unparsed_name
     , FALSE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM staging_octane.wf_process_note_comment staging_table
         LEFT JOIN history_octane.wf_process_note_comment history_table on staging_table.wfpnc_pid = history_table.wfpnc_pid and staging_table.wfpnc_version = history_table.wfpnc_version
WHERE history_table.wfpnc_pid is NULL
UNION ALL
SELECT history_table.wfpnc_pid
     , history_table.wfpnc_version + 1
     , history_table.wfpnc_wf_process_note_pid
     , history_table.wfpnc_create_datetime
     , history_table.wfpnc_content
     , history_table.wfpnc_author_lender_user_pid
     , history_table.wfpnc_author_unparsed_name
     , TRUE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM history_octane.wf_process_note_comment history_table
         LEFT JOIN staging_octane.wf_process_note_comment staging_table on staging_table.wfpnc_pid = history_table.wfpnc_pid
WHERE staging_table.wfpnc_pid is NULL
  AND not exists (select 1 from history_octane.wf_process_note_comment deleted_records where deleted_records.wfpnc_pid = history_table.wfpnc_pid and deleted_records.data_source_deleted_flag = True);
')
        , ('SP-100868', 'wf_process_note_monitor', 'wfpnm_pid', '--finding records to insert into history_octane.wf_process_note_monitor
SELECT staging_table.wfpnm_pid
     , staging_table.wfpnm_version
     , staging_table.wfpnm_wf_process_note_pid
     , staging_table.wfpnm_lender_user_pid
     , FALSE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM staging_octane.wf_process_note_monitor staging_table
         LEFT JOIN history_octane.wf_process_note_monitor history_table on staging_table.wfpnm_pid = history_table.wfpnm_pid and staging_table.wfpnm_version = history_table.wfpnm_version
WHERE history_table.wfpnm_pid is NULL
UNION ALL
SELECT history_table.wfpnm_pid
     , history_table.wfpnm_version + 1
     , history_table.wfpnm_wf_process_note_pid
     , history_table.wfpnm_lender_user_pid
     , TRUE as data_source_deleted_flag
     , now() AS data_source_updated_datetime
FROM history_octane.wf_process_note_monitor history_table
         LEFT JOIN staging_octane.wf_process_note_monitor staging_table on staging_table.wfpnm_pid = history_table.wfpnm_pid
WHERE staging_table.wfpnm_pid is NULL
  AND not exists (select 1 from history_octane.wf_process_note_monitor deleted_records where deleted_records.wfpnm_pid = history_table.wfpnm_pid and deleted_records.data_source_deleted_flag = True);')
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
            JOIN new_process_variables ON new_processes.name = new_process_variables.name
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
            JOIN new_process_variables ON new_processes.name = new_process_variables.name
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
            JOIN new_fields ON new_fields.schema_name = new_table_output_steps.target_schema
                AND new_fields.table_name = new_table_output_steps.target_table
)

, new_json_output_fields AS (
    INSERT INTO mdi.json_output_field (process_dwid, field_name)
        SELECT new_processes.dwid, new_process_variables.json_output_field
        FROM new_processes
            JOIN new_process_variables ON new_processes.name = new_process_variables.name
)

, new_state_machine_definitions AS (
    INSERT INTO mdi.state_machine_definition (process_dwid, name, comment)
        SELECT new_processes.dwid, new_processes.name, new_processes.description
        FROM new_processes
)
SELECT 'Finished inserting metadata for new tables: wf_step_note, wf_step_note_comment, wf_step_note_monitor, ' ||
       'wf_process_note, wf_process_note_comment, wf_process_note_monitor';


/*
Remove metadata for deleted field: construction_cost.coc_payee
NOTE: The table_input_step sql value for construction_cost will be updated to reflect this field removal in the next
series of CTEs, where other fields are being ADDED to the construction_cost table.
*/

-- mdi.table_output_field
DELETE FROM mdi.table_output_field
    WHERE dwid = (
        SELECT table_output_field.dwid
        FROM mdi.table_output_step
            JOIN mdi.table_output_field ON table_output_step.dwid = table_output_field.table_output_step_dwid
                AND table_output_field.database_field_name = 'coc_payee'
        WHERE table_output_step.target_table = 'construction_cost'
        );

-- mdi.edw_field_definition: delete staging_octane row for coc_payee
DELETE FROM mdi.edw_field_definition
    WHERE dwid = (
        SELECT edw_field_definition.dwid
        FROM mdi.edw_table_definition
                 JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
            AND edw_field_definition.field_name = 'coc_payee'
        WHERE edw_table_definition.schema_name = 'staging_octane'
        );

-- mdi.edw_field_definition: nullify field source value for history_octane coc_payee
UPDATE mdi.edw_field_definition
    SET source_edw_field_definition_dwid = NULL
    WHERE dwid = (
        SELECT edw_field_definition.dwid
        FROM mdi.edw_table_definition
                 JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
            AND edw_field_definition.field_name = 'coc_payee'
        WHERE edw_table_definition.schema_name = 'history_octane'
        );

SELECT 'Finished removing EDW metadata for deleted field: construction_cost.coc_payee';


/*
Insert metadata for new columns:
    - construction_cost.coc_borrower_pid
    - construction_cost.coc_proposal_hud_consultant_pid
    - construction_cost.coc_title_company_pid
    - construction_cost.coc_payee_other_selected
    - construction_cost.coc_payee_other_description
    - lender_settings.lss_fha_home_office_location_pid
*/

WITH new_fields (table_name, field_name, field_order) AS (
    VALUES ('construction_cost', 'coc_borrower_pid', 29)
        , ('construction_cost', 'coc_proposal_hud_consultant_pid', 30)
        , ('construction_cost', 'coc_title_company_pid', 31)
        , ('construction_cost', 'coc_payee_other_selected', 32)
        , ('construction_cost', 'coc_payee_other_description', 33)
        , ('lender_settings', 'lss_fha_home_office_location_pid', 47)
)

, new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT edw_table_definition.dwid
             , new_fields.field_name
             , FALSE
        FROM new_fields
            JOIN mdi.edw_table_definition ON edw_table_definition.schema_name = 'staging_octane'
                AND new_fields.table_name = edw_table_definition.table_name
        RETURNING dwid, edw_table_definition_dwid, field_name
)

, new_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid)
        SELECT edw_table_definition.dwid
             , new_fields.field_name
             , FALSE
             , new_staging_field_definitions.dwid
        FROM new_fields
            JOIN mdi.edw_table_definition ON edw_table_definition.schema_name = 'history_octane'
                AND new_fields.table_name = edw_table_definition.table_name
            JOIN mdi.edw_table_definition AS source_table_definition ON source_table_definition.schema_name = 'staging_octane'
                AND source_table_definition.table_name = new_fields.table_name
            JOIN new_staging_field_definitions ON new_staging_field_definitions.edw_table_definition_dwid = source_table_definition.dwid
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
            JOIN mdi.table_output_step ON table_output_step.target_schema = 'history_octane'
                AND table_output_step.target_table = new_fields.table_name
)

, updated_table_input_sql (table_name, sql) AS (
    VALUES ('construction_cost', '')
        , ('lender_settings', '')
)
