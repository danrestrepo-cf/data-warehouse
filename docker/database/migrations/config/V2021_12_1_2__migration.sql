--
-- MAIN | Octane schemas from prod-release to v2021.12.1.1  -  https://app.asana.com/0/0/1201452884282751
--


/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'staging_octane', 'org_node_custom_field', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_value_type', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_choice', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_lineage_tracker_custom_field_update_status_type', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_lineage_tracker_custom_field_update', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_setting', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_scope_type', NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'org_node_custom_field', 'staging', 'staging_octane', 'org_node_custom_field')
         , ('staging', 'history_octane', 'custom_field_value_type', 'staging', 'staging_octane', 'custom_field_value_type')
         , ('staging', 'history_octane', 'custom_field_choice', 'staging', 'staging_octane', 'custom_field_choice')
         , ('staging', 'history_octane', 'org_lineage_tracker_custom_field_update_status_type', 'staging', 'staging_octane', 'org_lineage_tracker_custom_field_update_status_type')
         , ('staging', 'history_octane', 'org_lineage_tracker_custom_field_update', 'staging', 'staging_octane', 'org_lineage_tracker_custom_field_update')
         , ('staging', 'history_octane', 'custom_field_setting', 'staging', 'staging_octane', 'custom_field_setting')
         , ('staging', 'history_octane', 'custom_field_scope_type', 'staging', 'staging_octane', 'custom_field_scope_type')
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT insert_rows.database_name, insert_rows.schema_name, insert_rows.table_name, source_table_definition.dwid
FROM insert_rows
LEFT JOIN mdi.edw_table_definition source_table_definition
     ON insert_rows.source_database_name = source_table_definition.database_name
         AND insert_rows.source_schema_name = source_table_definition.schema_name
         AND insert_rows.source_table_name = source_table_definition.table_name;

--edw_join_definition
WITH insert_rows (primary_database_name, primary_schema_name, primary_table_name, target_database_name, target_schema_name, target_table_name, join_condition) AS (
    VALUES ('staging', 'history_octane', 'org_node_custom_field', 'staging', 'history_octane', 'org_node', 'primary_table.oncf_org_node_pid = target_table.on_pid')
         , ('staging', 'history_octane', 'org_node_custom_field', 'staging', 'history_octane', 'custom_field_setting', 'primary_table.oncf_custom_field_setting_pid = target_table.cfs_pid')
         , ('staging', 'history_octane', 'org_node_custom_field', 'staging', 'history_octane', 'custom_field_choice', 'primary_table.oncf_custom_field_choice_pid = target_table.cfc_pid')
         , ('staging', 'history_octane', 'org_node_custom_field', 'staging', 'history_octane', 'org_node_custom_field', 'primary_table.oncf_propagator_org_node_custom_field_pid = target_table.oncf_pid')
         , ('staging', 'history_octane', 'org_node_custom_field', 'staging', 'history_octane', 'org_lineage_tracker', 'primary_table.oncf_org_lineage_tracker_pid = target_table.olt_pid')
         , ('staging', 'history_octane', 'custom_field_choice', 'staging', 'history_octane', 'custom_field_setting', 'primary_table.cfc_custom_field_setting_pid = target_table.cfs_pid')
         , ('staging', 'history_octane', 'org_lineage_tracker_custom_field_update', 'staging', 'history_octane', 'org_lineage_tracker', 'primary_table.otcfu_org_lineage_tracker_pid = target_table.olt_pid')
         , ('staging', 'history_octane', 'custom_field_setting', 'staging', 'history_octane', 'account', 'primary_table.cfs_account_pid = target_table.a_pid')
         , ('staging', 'history_octane', 'custom_field_setting', 'staging', 'history_octane', 'custom_field_scope_type', 'primary_table.cfs_custom_field_scope_type = target_table.code')
         , ('staging', 'history_octane', 'custom_field_setting', 'staging', 'history_octane', 'custom_field_value_type', 'primary_table.cfs_custom_field_value_type = target_table.code')
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

--edw_field_definition
WITH insert_rows (database_name, schema_name, table_name, field_name, data_type, source_database_name, source_schema_name, source_table_name, source_field_name) AS (
    VALUES ('staging', 'history_octane', 'org_node_custom_field', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'org_node_custom_field', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'org_node_custom_field', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'custom_field_value_type', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'custom_field_value_type', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'custom_field_value_type', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'custom_field_choice', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'custom_field_choice', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'custom_field_choice', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'org_lineage_tracker_custom_field_update_status_type', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'org_lineage_tracker_custom_field_update_status_type', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'org_lineage_tracker_custom_field_update_status_type', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'org_lineage_tracker_custom_field_update', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'org_lineage_tracker_custom_field_update', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'org_lineage_tracker_custom_field_update', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'custom_field_setting', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'custom_field_setting', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'custom_field_setting', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'custom_field_scope_type', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'custom_field_scope_type', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'custom_field_scope_type', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_custom_field', 'oncf_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_custom_field', 'oncf_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_custom_field', 'oncf_org_node_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_custom_field', 'oncf_custom_field_setting_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_custom_field', 'oncf_field_value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_custom_field', 'oncf_custom_field_choice_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_custom_field', 'oncf_propagator', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_custom_field', 'oncf_propagated', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_custom_field', 'oncf_excluded', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_custom_field', 'oncf_propagator_org_node_custom_field_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_node_custom_field', 'oncf_org_lineage_tracker_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_value_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_value_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_choice', 'cfc_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_choice', 'cfc_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_choice', 'cfc_custom_field_setting_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_choice', 'cfc_choice_label', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_choice', 'cfc_disabled', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_lineage_tracker_custom_field_update_status_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_lineage_tracker_custom_field_update_status_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_lineage_tracker_custom_field_update', 'otcfu_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_lineage_tracker_custom_field_update', 'otcfu_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_lineage_tracker_custom_field_update', 'otcfu_org_lineage_tracker_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'org_lineage_tracker_custom_field_update', 'otcfu_org_lineage_tracker_custom_field_update_status_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_setting', 'cfs_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_setting', 'cfs_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_setting', 'cfs_account_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_setting', 'cfs_custom_field_scope_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_setting', 'cfs_custom_field_setting_name', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_setting', 'cfs_custom_field_value_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_setting', 'cfs_custom_field_setting_description', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_scope_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'custom_field_scope_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
)
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
SELECT edw_table_definition.dwid, insert_rows.field_name, FALSE, source_field_definition.dwid, NULL, NULL, insert_rows.data_type, NULL, NULL, NULL, NULL
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
    VALUES ('staging', 'history_octane', 'org_node_custom_field', 'oncf_pid', 'BIGINT', 'staging', 'staging_octane', 'org_node_custom_field', 'oncf_pid')
         , ('staging', 'history_octane', 'org_node_custom_field', 'oncf_version', 'INTEGER', 'staging', 'staging_octane', 'org_node_custom_field', 'oncf_version')
         , ('staging', 'history_octane', 'org_node_custom_field', 'oncf_org_node_pid', 'BIGINT', 'staging', 'staging_octane', 'org_node_custom_field', 'oncf_org_node_pid')
         , ('staging', 'history_octane', 'org_node_custom_field', 'oncf_custom_field_setting_pid', 'BIGINT', 'staging', 'staging_octane', 'org_node_custom_field', 'oncf_custom_field_setting_pid')
         , ('staging', 'history_octane', 'org_node_custom_field', 'oncf_field_value', 'VARCHAR(1024)', 'staging', 'staging_octane', 'org_node_custom_field', 'oncf_field_value')
         , ('staging', 'history_octane', 'org_node_custom_field', 'oncf_custom_field_choice_pid', 'BIGINT', 'staging', 'staging_octane', 'org_node_custom_field', 'oncf_custom_field_choice_pid')
         , ('staging', 'history_octane', 'org_node_custom_field', 'oncf_propagator', 'BOOLEAN', 'staging', 'staging_octane', 'org_node_custom_field', 'oncf_propagator')
         , ('staging', 'history_octane', 'org_node_custom_field', 'oncf_propagated', 'BOOLEAN', 'staging', 'staging_octane', 'org_node_custom_field', 'oncf_propagated')
         , ('staging', 'history_octane', 'org_node_custom_field', 'oncf_excluded', 'BOOLEAN', 'staging', 'staging_octane', 'org_node_custom_field', 'oncf_excluded')
         , ('staging', 'history_octane', 'org_node_custom_field', 'oncf_propagator_org_node_custom_field_pid', 'BIGINT', 'staging', 'staging_octane', 'org_node_custom_field', 'oncf_propagator_org_node_custom_field_pid')
         , ('staging', 'history_octane', 'org_node_custom_field', 'oncf_org_lineage_tracker_pid', 'BIGINT', 'staging', 'staging_octane', 'org_node_custom_field', 'oncf_org_lineage_tracker_pid')
         , ('staging', 'history_octane', 'custom_field_value_type', 'code', 'VARCHAR(128)', 'staging', 'staging_octane', 'custom_field_value_type', 'code')
         , ('staging', 'history_octane', 'custom_field_value_type', 'value', 'VARCHAR(1024)', 'staging', 'staging_octane', 'custom_field_value_type', 'value')
         , ('staging', 'history_octane', 'custom_field_choice', 'cfc_pid', 'BIGINT', 'staging', 'staging_octane', 'custom_field_choice', 'cfc_pid')
         , ('staging', 'history_octane', 'custom_field_choice', 'cfc_version', 'INTEGER', 'staging', 'staging_octane', 'custom_field_choice', 'cfc_version')
         , ('staging', 'history_octane', 'custom_field_choice', 'cfc_custom_field_setting_pid', 'BIGINT', 'staging', 'staging_octane', 'custom_field_choice', 'cfc_custom_field_setting_pid')
         , ('staging', 'history_octane', 'custom_field_choice', 'cfc_choice_label', 'VARCHAR(1024)', 'staging', 'staging_octane', 'custom_field_choice', 'cfc_choice_label')
         , ('staging', 'history_octane', 'custom_field_choice', 'cfc_disabled', 'BOOLEAN', 'staging', 'staging_octane', 'custom_field_choice', 'cfc_disabled')
         , ('staging', 'history_octane', 'org_lineage_tracker_custom_field_update_status_type', 'code', 'VARCHAR(128)', 'staging', 'staging_octane', 'org_lineage_tracker_custom_field_update_status_type', 'code')
         , ('staging', 'history_octane', 'org_lineage_tracker_custom_field_update_status_type', 'value', 'VARCHAR(1024)', 'staging', 'staging_octane', 'org_lineage_tracker_custom_field_update_status_type', 'value')
         , ('staging', 'history_octane', 'org_lineage_tracker_custom_field_update', 'otcfu_pid', 'BIGINT', 'staging', 'staging_octane', 'org_lineage_tracker_custom_field_update', 'otcfu_pid')
         , ('staging', 'history_octane', 'org_lineage_tracker_custom_field_update', 'otcfu_version', 'INTEGER', 'staging', 'staging_octane', 'org_lineage_tracker_custom_field_update', 'otcfu_version')
         , ('staging', 'history_octane', 'org_lineage_tracker_custom_field_update', 'otcfu_org_lineage_tracker_pid', 'BIGINT', 'staging', 'staging_octane', 'org_lineage_tracker_custom_field_update', 'otcfu_org_lineage_tracker_pid')
         , ('staging', 'history_octane', 'org_lineage_tracker_custom_field_update', 'otcfu_org_lineage_tracker_custom_field_update_status_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'org_lineage_tracker_custom_field_update', 'otcfu_org_lineage_tracker_custom_field_update_status_type')
         , ('staging', 'history_octane', 'custom_field_setting', 'cfs_pid', 'BIGINT', 'staging', 'staging_octane', 'custom_field_setting', 'cfs_pid')
         , ('staging', 'history_octane', 'custom_field_setting', 'cfs_version', 'INTEGER', 'staging', 'staging_octane', 'custom_field_setting', 'cfs_version')
         , ('staging', 'history_octane', 'custom_field_setting', 'cfs_account_pid', 'BIGINT', 'staging', 'staging_octane', 'custom_field_setting', 'cfs_account_pid')
         , ('staging', 'history_octane', 'custom_field_setting', 'cfs_custom_field_scope_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'custom_field_setting', 'cfs_custom_field_scope_type')
         , ('staging', 'history_octane', 'custom_field_setting', 'cfs_custom_field_setting_name', 'VARCHAR(1024)', 'staging', 'staging_octane', 'custom_field_setting', 'cfs_custom_field_setting_name')
         , ('staging', 'history_octane', 'custom_field_setting', 'cfs_custom_field_value_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'custom_field_setting', 'cfs_custom_field_value_type')
         , ('staging', 'history_octane', 'custom_field_setting', 'cfs_custom_field_setting_description', 'VARCHAR(1024)', 'staging', 'staging_octane', 'custom_field_setting', 'cfs_custom_field_setting_description')
         , ('staging', 'history_octane', 'custom_field_scope_type', 'code', 'VARCHAR(128)', 'staging', 'staging_octane', 'custom_field_scope_type', 'code')
         , ('staging', 'history_octane', 'custom_field_scope_type', 'value', 'VARCHAR(1024)', 'staging', 'staging_octane', 'custom_field_scope_type', 'value')
)
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid, field_source_calculation, source_edw_join_tree_definition_dwid, data_type, reporting_label, reporting_description, reporting_hidden, reporting_key_flag)
SELECT edw_table_definition.dwid, insert_rows.field_name, FALSE, source_field_definition.dwid, NULL, NULL, insert_rows.data_type, NULL, NULL, NULL, NULL
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
VALUES ('SP-100880', 'ETL to copy org_node_custom_field data from staging_octane to history_octane')
     , ('SP-100877', 'ETL to copy custom_field_value_type data from staging_octane to history_octane')
     , ('SP-100874', 'ETL to copy custom_field_choice data from staging_octane to history_octane')
     , ('SP-100879', 'ETL to copy org_lineage_tracker_custom_field_update_status_type data from staging_octane to history_octane')
     , ('SP-100878', 'ETL to copy org_lineage_tracker_custom_field_update data from staging_octane to history_octane')
     , ('SP-100876', 'ETL to copy custom_field_setting data from staging_octane to history_octane')
     , ('SP-100875', 'ETL to copy custom_field_scope_type data from staging_octane to history_octane');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100880', 0, '--finding records to insert into history_octane.org_node_custom_field
SELECT staging_table.oncf_pid
     , staging_table.oncf_version
     , staging_table.oncf_org_node_pid
     , staging_table.oncf_custom_field_setting_pid
     , staging_table.oncf_field_value
     , staging_table.oncf_custom_field_choice_pid
     , staging_table.oncf_propagator
     , staging_table.oncf_propagated
     , staging_table.oncf_excluded
     , staging_table.oncf_propagator_org_node_custom_field_pid
     , staging_table.oncf_org_lineage_tracker_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.org_node_custom_field staging_table
LEFT JOIN history_octane.org_node_custom_field history_table
          ON staging_table.oncf_pid = history_table.oncf_pid
              AND staging_table.oncf_version = history_table.oncf_version
WHERE history_table.oncf_pid IS NULL
UNION ALL
SELECT history_table.oncf_pid
     , history_table.oncf_version + 1
     , history_table.oncf_org_node_pid
     , history_table.oncf_custom_field_setting_pid
     , history_table.oncf_field_value
     , history_table.oncf_custom_field_choice_pid
     , history_table.oncf_propagator
     , history_table.oncf_propagated
     , history_table.oncf_excluded
     , history_table.oncf_propagator_org_node_custom_field_pid
     , history_table.oncf_org_lineage_tracker_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.org_node_custom_field history_table
LEFT JOIN staging_octane.org_node_custom_field staging_table
          ON staging_table.oncf_pid = history_table.oncf_pid
WHERE staging_table.oncf_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.org_node_custom_field deleted_records
    WHERE deleted_records.oncf_pid = history_table.oncf_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100877', 0, '--finding records to insert into history_octane.custom_field_value_type
SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.custom_field_value_type staging_table
LEFT JOIN history_octane.custom_field_value_type history_table
          ON staging_table.code = history_table.code
              AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;', 'Staging DB Connection')
         , ('SP-100874', 0, '--finding records to insert into history_octane.custom_field_choice
SELECT staging_table.cfc_pid
     , staging_table.cfc_version
     , staging_table.cfc_custom_field_setting_pid
     , staging_table.cfc_choice_label
     , staging_table.cfc_disabled
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.custom_field_choice staging_table
LEFT JOIN history_octane.custom_field_choice history_table
          ON staging_table.cfc_pid = history_table.cfc_pid
              AND staging_table.cfc_version = history_table.cfc_version
WHERE history_table.cfc_pid IS NULL
UNION ALL
SELECT history_table.cfc_pid
     , history_table.cfc_version + 1
     , history_table.cfc_custom_field_setting_pid
     , history_table.cfc_choice_label
     , history_table.cfc_disabled
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.custom_field_choice history_table
LEFT JOIN staging_octane.custom_field_choice staging_table
          ON staging_table.cfc_pid = history_table.cfc_pid
WHERE staging_table.cfc_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.custom_field_choice deleted_records
    WHERE deleted_records.cfc_pid = history_table.cfc_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100879', 0, '--finding records to insert into history_octane.org_lineage_tracker_custom_field_update_status_type
SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.org_lineage_tracker_custom_field_update_status_type staging_table
LEFT JOIN history_octane.org_lineage_tracker_custom_field_update_status_type history_table
          ON staging_table.code = history_table.code
              AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;', 'Staging DB Connection')
         , ('SP-100878', 0, '--finding records to insert into history_octane.org_lineage_tracker_custom_field_update
SELECT staging_table.otcfu_pid
     , staging_table.otcfu_version
     , staging_table.otcfu_org_lineage_tracker_pid
     , staging_table.otcfu_org_lineage_tracker_custom_field_update_status_type
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.org_lineage_tracker_custom_field_update staging_table
LEFT JOIN history_octane.org_lineage_tracker_custom_field_update history_table
          ON staging_table.otcfu_pid = history_table.otcfu_pid
              AND staging_table.otcfu_version = history_table.otcfu_version
WHERE history_table.otcfu_pid IS NULL
UNION ALL
SELECT history_table.otcfu_pid
     , history_table.otcfu_version + 1
     , history_table.otcfu_org_lineage_tracker_pid
     , history_table.otcfu_org_lineage_tracker_custom_field_update_status_type
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.org_lineage_tracker_custom_field_update history_table
LEFT JOIN staging_octane.org_lineage_tracker_custom_field_update staging_table
          ON staging_table.otcfu_pid = history_table.otcfu_pid
WHERE staging_table.otcfu_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.org_lineage_tracker_custom_field_update deleted_records
    WHERE deleted_records.otcfu_pid = history_table.otcfu_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100876', 0, '--finding records to insert into history_octane.custom_field_setting
SELECT staging_table.cfs_pid
     , staging_table.cfs_version
     , staging_table.cfs_account_pid
     , staging_table.cfs_custom_field_scope_type
     , staging_table.cfs_custom_field_setting_name
     , staging_table.cfs_custom_field_value_type
     , staging_table.cfs_custom_field_setting_description
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.custom_field_setting staging_table
LEFT JOIN history_octane.custom_field_setting history_table
          ON staging_table.cfs_pid = history_table.cfs_pid
              AND staging_table.cfs_version = history_table.cfs_version
WHERE history_table.cfs_pid IS NULL
UNION ALL
SELECT history_table.cfs_pid
     , history_table.cfs_version + 1
     , history_table.cfs_account_pid
     , history_table.cfs_custom_field_scope_type
     , history_table.cfs_custom_field_setting_name
     , history_table.cfs_custom_field_value_type
     , history_table.cfs_custom_field_setting_description
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.custom_field_setting history_table
LEFT JOIN staging_octane.custom_field_setting staging_table
          ON staging_table.cfs_pid = history_table.cfs_pid
WHERE staging_table.cfs_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.custom_field_setting deleted_records
    WHERE deleted_records.cfs_pid = history_table.cfs_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100875', 0, '--finding records to insert into history_octane.custom_field_scope_type
SELECT staging_table.code
     , staging_table.value
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.custom_field_scope_type staging_table
LEFT JOIN history_octane.custom_field_scope_type history_table
          ON staging_table.code = history_table.code
              AND staging_table.value = history_table.value
WHERE history_table.code IS NULL;', 'Staging DB Connection')
)
INSERT
INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
SELECT process.dwid, insert_rows.data_source_dwid, insert_rows.sql, 0, 'N', 'N', 'N', 'N', insert_rows.connectionname::mdi.pentaho_db_connection_name
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--table_output_step
WITH insert_rows (process_name, target_schema, target_table, truncate_table, connectionname) AS (
    VALUES ('SP-100880', 'history_octane', 'org_node_custom_field', 'N', 'Staging DB Connection')
         , ('SP-100877', 'history_octane', 'custom_field_value_type', 'N', 'Staging DB Connection')
         , ('SP-100874', 'history_octane', 'custom_field_choice', 'N', 'Staging DB Connection')
         , ('SP-100879', 'history_octane', 'org_lineage_tracker_custom_field_update_status_type', 'N', 'Staging DB Connection')
         , ('SP-100878', 'history_octane', 'org_lineage_tracker_custom_field_update', 'N', 'Staging DB Connection')
         , ('SP-100876', 'history_octane', 'custom_field_setting', 'N', 'Staging DB Connection')
         , ('SP-100875', 'history_octane', 'custom_field_scope_type', 'N', 'Staging DB Connection')
)
INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT process.dwid, insert_rows.target_schema, insert_rows.target_table, 1000, NULL, NULL, NULL, NULL, 'N', NULL, insert_rows.truncate_table::mdi.pentaho_y_or_n, insert_rows.connectionname, 'N', 'Y', 'N', 'N'
FROM insert_rows
JOIN mdi.process
ON process.name = insert_rows.process_name;

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('SP-100880', 'oncf_pid')
         , ('SP-100880', 'oncf_version')
         , ('SP-100880', 'oncf_org_node_pid')
         , ('SP-100880', 'oncf_custom_field_setting_pid')
         , ('SP-100880', 'oncf_field_value')
         , ('SP-100880', 'oncf_custom_field_choice_pid')
         , ('SP-100880', 'oncf_propagator')
         , ('SP-100880', 'oncf_propagated')
         , ('SP-100880', 'oncf_excluded')
         , ('SP-100880', 'oncf_propagator_org_node_custom_field_pid')
         , ('SP-100880', 'oncf_org_lineage_tracker_pid')
         , ('SP-100880', 'data_source_updated_datetime')
         , ('SP-100880', 'data_source_deleted_flag')
         , ('SP-100880', 'etl_batch_id')
         , ('SP-100877', 'code')
         , ('SP-100877', 'value')
         , ('SP-100877', 'data_source_updated_datetime')
         , ('SP-100877', 'data_source_deleted_flag')
         , ('SP-100877', 'etl_batch_id')
         , ('SP-100874', 'cfc_pid')
         , ('SP-100874', 'cfc_version')
         , ('SP-100874', 'cfc_custom_field_setting_pid')
         , ('SP-100874', 'cfc_choice_label')
         , ('SP-100874', 'cfc_disabled')
         , ('SP-100874', 'data_source_updated_datetime')
         , ('SP-100874', 'data_source_deleted_flag')
         , ('SP-100874', 'etl_batch_id')
         , ('SP-100879', 'code')
         , ('SP-100879', 'value')
         , ('SP-100879', 'data_source_updated_datetime')
         , ('SP-100879', 'data_source_deleted_flag')
         , ('SP-100879', 'etl_batch_id')
         , ('SP-100878', 'otcfu_pid')
         , ('SP-100878', 'otcfu_version')
         , ('SP-100878', 'otcfu_org_lineage_tracker_pid')
         , ('SP-100878', 'otcfu_org_lineage_tracker_custom_field_update_status_type')
         , ('SP-100878', 'data_source_updated_datetime')
         , ('SP-100878', 'data_source_deleted_flag')
         , ('SP-100878', 'etl_batch_id')
         , ('SP-100876', 'cfs_pid')
         , ('SP-100876', 'cfs_version')
         , ('SP-100876', 'cfs_account_pid')
         , ('SP-100876', 'cfs_custom_field_scope_type')
         , ('SP-100876', 'cfs_custom_field_setting_name')
         , ('SP-100876', 'cfs_custom_field_value_type')
         , ('SP-100876', 'cfs_custom_field_setting_description')
         , ('SP-100876', 'data_source_updated_datetime')
         , ('SP-100876', 'data_source_deleted_flag')
         , ('SP-100876', 'etl_batch_id')
         , ('SP-100875', 'code')
         , ('SP-100875', 'value')
         , ('SP-100875', 'data_source_updated_datetime')
         , ('SP-100875', 'data_source_deleted_flag')
         , ('SP-100875', 'etl_batch_id')
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
    VALUES ('SP-100880', 'oncf_pid')
         , ('SP-100877', 'code')
         , ('SP-100874', 'cfc_pid')
         , ('SP-100879', 'code')
         , ('SP-100878', 'otcfu_pid')
         , ('SP-100876', 'cfs_pid')
         , ('SP-100875', 'code')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
JOIN mdi.process
     ON insert_rows.process_name = process.name;

--state_machine_definition
WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-100880', 'SP-100880', 'ETL to copy org_node_custom_field data from staging_octane to history_octane')
         , ('SP-100877', 'SP-100877', 'ETL to copy custom_field_value_type data from staging_octane to history_octane')
         , ('SP-100874', 'SP-100874', 'ETL to copy custom_field_choice data from staging_octane to history_octane')
         , ('SP-100879', 'SP-100879', 'ETL to copy org_lineage_tracker_custom_field_update_status_type data from staging_octane to history_octane')
         , ('SP-100878', 'SP-100878', 'ETL to copy org_lineage_tracker_custom_field_update data from staging_octane to history_octane')
         , ('SP-100876', 'SP-100876', 'ETL to copy custom_field_setting data from staging_octane to history_octane')
         , ('SP-100875', 'SP-100875', 'ETL to copy custom_field_scope_type data from staging_octane to history_octane')
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

--edw_table_definition
WITH update_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'history_octane', 'closing_document_status_type', NULL, NULL, NULL)
         , ('staging', 'history_octane', 'loan_closing_doc', NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'account', 'a_allonge_representative_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'account', 'a_allonge_representative_title', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'closing_document_status_type', 'code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'closing_document_status_type', 'value', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'product_terms', 'pt_dsi_plan_code', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'branch', 'br_dsi_customer_id', 'VARCHAR(16)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'loan_closing_doc', 'lcd_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'loan_closing_doc', 'lcd_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'loan_closing_doc', 'lcd_loan_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'loan_closing_doc', 'lcd_dsi_websheet_number', 'VARCHAR(16)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'loan_closing_doc', 'lcd_dsi_doc_code', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'loan_closing_doc', 'lcd_dsi_transaction_id', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'loan_closing_doc', 'lcd_dsi_closing_document_status_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'loan_closing_doc', 'lcd_dsi_fatal_messages', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'loan_closing_doc', 'lcd_dsi_warning_messages', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'loan_closing_doc', 'lcd_unsigned_closing_doc_deal_file_pid', 'BIGINT', NULL, NULL, NULL, NULL)
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
    VALUES ('SP-100019', 0, '--finding records to insert into history_octane.account
SELECT staging_table.a_pid
     , staging_table.a_version
     , staging_table.a_account_id
     , staging_table.a_account_name
     , staging_table.a_gfe_interest_rate_expiration_days
     , staging_table.a_gfe_lock_duration_days
     , staging_table.a_gfe_lock_before_settlement_days
     , staging_table.a_proposal_expiration_days
     , staging_table.a_uw_expiration_days
     , staging_table.a_conditional_commitment_expiration_days
     , staging_table.a_account_from_date
     , staging_table.a_account_status_type
     , staging_table.a_account_through_date
     , staging_table.a_initial_los_loan_id
     , staging_table.a_uuts_master_contact_name
     , staging_table.a_uuts_master_contact_title
     , staging_table.a_uuts_master_office_phone
     , staging_table.a_uuts_master_office_phone_extension
     , staging_table.a_account_borrower_site_id
     , staging_table.a_originator_borrower_sites_enabled
     , staging_table.a_company_borrower_site_enabled
     , staging_table.a_discount_included_in_origination_fee
     , staging_table.a_uuts_use_master_contact
     , staging_table.a_borrower_job_gap_lookback_years
     , staging_table.a_borrower_job_gap_minimum_days
     , staging_table.a_lender_app_host
     , staging_table.a_lender_app_ip_address
     , staging_table.a_advance_period_days
     , staging_table.a_account_destroy_mode
     , staging_table.a_paid_through_current_month_required_day_of_month
     , staging_table.a_disclosure_change_threshold_cash_to_close
     , staging_table.a_disclosure_change_threshold_monthly_payment
     , staging_table.a_disclosure_action_required_days
     , staging_table.a_le_to_cd_seasoning_days
     , staging_table.a_disclosure_max_arm_apr_change_percent
     , staging_table.a_disclosure_max_non_arm_apr_change_percent
     , staging_table.a_initial_le_delivered_mailed_seasoning_days
     , staging_table.a_revised_le_delivered_mailed_seasoning_days
     , staging_table.a_revised_le_received_signed_seasoning_days
     , staging_table.a_significant_cd_delivered_mailed_seasoning_days
     , staging_table.a_significant_cd_received_signed_seasoning_days
     , staging_table.a_supported_states
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.account staging_table
LEFT JOIN history_octane.account history_table
          ON staging_table.a_pid = history_table.a_pid
              AND staging_table.a_version = history_table.a_version
WHERE history_table.a_pid IS NULL
UNION ALL
SELECT history_table.a_pid
     , history_table.a_version + 1
     , history_table.a_account_id
     , history_table.a_account_name
     , history_table.a_gfe_interest_rate_expiration_days
     , history_table.a_gfe_lock_duration_days
     , history_table.a_gfe_lock_before_settlement_days
     , history_table.a_proposal_expiration_days
     , history_table.a_uw_expiration_days
     , history_table.a_conditional_commitment_expiration_days
     , history_table.a_account_from_date
     , history_table.a_account_status_type
     , history_table.a_account_through_date
     , history_table.a_initial_los_loan_id
     , history_table.a_uuts_master_contact_name
     , history_table.a_uuts_master_contact_title
     , history_table.a_uuts_master_office_phone
     , history_table.a_uuts_master_office_phone_extension
     , history_table.a_account_borrower_site_id
     , history_table.a_originator_borrower_sites_enabled
     , history_table.a_company_borrower_site_enabled
     , history_table.a_discount_included_in_origination_fee
     , history_table.a_uuts_use_master_contact
     , history_table.a_borrower_job_gap_lookback_years
     , history_table.a_borrower_job_gap_minimum_days
     , history_table.a_lender_app_host
     , history_table.a_lender_app_ip_address
     , history_table.a_advance_period_days
     , history_table.a_account_destroy_mode
     , history_table.a_paid_through_current_month_required_day_of_month
     , history_table.a_disclosure_change_threshold_cash_to_close
     , history_table.a_disclosure_change_threshold_monthly_payment
     , history_table.a_disclosure_action_required_days
     , history_table.a_le_to_cd_seasoning_days
     , history_table.a_disclosure_max_arm_apr_change_percent
     , history_table.a_disclosure_max_non_arm_apr_change_percent
     , history_table.a_initial_le_delivered_mailed_seasoning_days
     , history_table.a_revised_le_delivered_mailed_seasoning_days
     , history_table.a_revised_le_received_signed_seasoning_days
     , history_table.a_significant_cd_delivered_mailed_seasoning_days
     , history_table.a_significant_cd_received_signed_seasoning_days
     , history_table.a_supported_states
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.account history_table
LEFT JOIN staging_octane.account staging_table
          ON staging_table.a_pid = history_table.a_pid
WHERE staging_table.a_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.account deleted_records
    WHERE deleted_records.a_pid = history_table.a_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100285', 0, '--finding records to insert into history_octane.product_terms
SELECT staging_table.pt_pid
     , staging_table.pt_version
     , staging_table.pt_amortization_term_months
     , staging_table.pt_arm_index_type
     , staging_table.pt_arm_payment_adjustment_calculation_type
     , staging_table.pt_assumable
     , staging_table.pt_product_category
     , staging_table.pt_conditions_to_assumability
     , staging_table.pt_demand_feature
     , staging_table.pt_due_in_term_months
     , staging_table.pt_escrow_cushion_months
     , staging_table.pt_from_date
     , staging_table.pt_initial_payment_adjustment_term_months
     , staging_table.pt_initial_rate_adjustment_cap_percent
     , staging_table.pt_initial_rate_adjustment_term_months
     , staging_table.pt_lien_priority_type
     , staging_table.pt_loan_amortization_type
     , staging_table.pt_minimum_payment_rate_percent
     , staging_table.pt_minimum_rate_term_months
     , staging_table.pt_mortgage_type
     , staging_table.pt_negative_amortization_type
     , staging_table.pt_negative_amortization_limit_percent
     , staging_table.pt_negative_amortization_recast_period_months
     , staging_table.pt_payment_adjustment_lifetime_cap_percent
     , staging_table.pt_payment_adjustment_periodic_cap
     , staging_table.pt_payment_frequency_type
     , staging_table.pt_prepayment_finance_charge_refund
     , staging_table.pt_product_pid
     , staging_table.pt_rate_adjustment_lifetime_cap_percent
     , staging_table.pt_subsequent_payment_adjustment_term_months
     , staging_table.pt_subsequent_rate_adjustment_cap_percent
     , staging_table.pt_subsequent_rate_adjustment_term_months
     , staging_table.pt_prepay_penalty_type
     , staging_table.pt_lender_hazard_insurance_available
     , staging_table.pt_lender_hazard_insurance_premium_amount
     , staging_table.pt_lender_hazard_insurance_term_months
     , staging_table.pt_loan_requires_hazard_insurance
     , staging_table.pt_arm_convertible
     , staging_table.pt_arm_convertible_from_month
     , staging_table.pt_arm_convertible_through_month
     , staging_table.pt_arm_floor_rate_percent
     , staging_table.pt_arm_lookback_period_days
     , staging_table.pt_escrow_waiver_allowed
     , staging_table.pt_days_per_year_type
     , staging_table.pt_lp_risk_assessment_accepted
     , staging_table.pt_du_risk_assessment_accepted
     , staging_table.pt_manual_risk_assessment_accepted
     , staging_table.pt_internal_underwrite_accepted
     , staging_table.pt_external_fha_underwrite_accepted
     , staging_table.pt_external_va_underwrite_accepted
     , staging_table.pt_external_usda_underwrite_accepted
     , staging_table.pt_external_investor_underwrite_accepted
     , staging_table.pt_heloc_cancel_fee_applicable_type
     , staging_table.pt_heloc_cancel_fee_period_months
     , staging_table.pt_heloc_cancel_fee_amount
     , staging_table.pt_heloc_draw_period_months
     , staging_table.pt_heloc_repayment_period_duration_months
     , staging_table.pt_heloc_maximum_initial_draw
     , staging_table.pt_heloc_maximum_initial_draw_amount
     , staging_table.pt_heloc_minimum_draw
     , staging_table.pt_heloc_minimum_draw_amount
     , staging_table.pt_gpm_adjustment_years
     , staging_table.pt_gpm_adjustment_percent
     , staging_table.pt_qualifying_monthly_payment_type
     , staging_table.pt_qualifying_rate_type
     , staging_table.pt_qualifying_rate_input_percent
     , staging_table.pt_ipc_calc_type
     , staging_table.pt_ipc_limit_percent1
     , staging_table.pt_ipc_property_usage_type1
     , staging_table.pt_ipc_comparison_operator_type1
     , staging_table.pt_ipc_cltv_ratio_percent1
     , staging_table.pt_ipc_limit_percent2
     , staging_table.pt_ipc_property_usage_type2
     , staging_table.pt_ipc_comparison_operator_type2
     , staging_table.pt_ipc_cltv_ratio_percent2
     , staging_table.pt_ipc_limit_percent3
     , staging_table.pt_ipc_property_usage_type3
     , staging_table.pt_ipc_comparison_operator_type3
     , staging_table.pt_ipc_cltv_ratio_percent3
     , staging_table.pt_ipc_limit_percent4
     , staging_table.pt_ipc_property_usage_type4
     , staging_table.pt_ipc_comparison_operator_type4
     , staging_table.pt_ipc_cltv_ratio_percent4
     , staging_table.pt_buydown_base_date_type
     , staging_table.pt_buydown_subsidy_calculation_type
     , staging_table.pt_prepaid_interest_rate_type
     , staging_table.pt_fnm_arm_plan_type
     , staging_table.pt_credit_qualifying
     , staging_table.pt_product_special_program_type
     , staging_table.pt_section_of_act_coarse_type
     , staging_table.pt_fha_rehab_program_type
     , staging_table.pt_fha_special_program_type
     , staging_table.pt_third_party_grant_eligible
     , staging_table.pt_servicing_transfer_type
     , staging_table.pt_no_mi_product
     , staging_table.pt_mortgage_credit_certificate_eligible
     , staging_table.pt_fre_community_program_type
     , staging_table.pt_fnm_community_lending_product_type
     , staging_table.pt_zero_note_rate
     , staging_table.pt_third_party_community_second_program_eligibility_type
     , staging_table.pt_texas_veterans_land_board
     , staging_table.pt_security_instrument_page_count
     , staging_table.pt_deed_page_count
     , staging_table.pt_partial_payment_policy_type
     , staging_table.pt_payment_structure_type
     , staging_table.pt_deferred_payment_months
     , staging_table.pt_always_current_market_price
     , staging_table.pt_rate_protect
     , staging_table.pt_non_conforming
     , staging_table.pt_allow_loan_amount_cents
     , staging_table.pt_product_appraisal_requirement_type
     , staging_table.pt_family_advantage
     , staging_table.pt_community_lending_type
     , staging_table.pt_high_balance
     , staging_table.pt_decision_credit_score_calc_type
     , staging_table.pt_new_york
     , staging_table.pt_maximum_number_of_construction_draws
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.product_terms staging_table
LEFT JOIN history_octane.product_terms history_table
          ON staging_table.pt_pid = history_table.pt_pid
              AND staging_table.pt_version = history_table.pt_version
WHERE history_table.pt_pid IS NULL
UNION ALL
SELECT history_table.pt_pid
     , history_table.pt_version + 1
     , history_table.pt_amortization_term_months
     , history_table.pt_arm_index_type
     , history_table.pt_arm_payment_adjustment_calculation_type
     , history_table.pt_assumable
     , history_table.pt_product_category
     , history_table.pt_conditions_to_assumability
     , history_table.pt_demand_feature
     , history_table.pt_due_in_term_months
     , history_table.pt_escrow_cushion_months
     , history_table.pt_from_date
     , history_table.pt_initial_payment_adjustment_term_months
     , history_table.pt_initial_rate_adjustment_cap_percent
     , history_table.pt_initial_rate_adjustment_term_months
     , history_table.pt_lien_priority_type
     , history_table.pt_loan_amortization_type
     , history_table.pt_minimum_payment_rate_percent
     , history_table.pt_minimum_rate_term_months
     , history_table.pt_mortgage_type
     , history_table.pt_negative_amortization_type
     , history_table.pt_negative_amortization_limit_percent
     , history_table.pt_negative_amortization_recast_period_months
     , history_table.pt_payment_adjustment_lifetime_cap_percent
     , history_table.pt_payment_adjustment_periodic_cap
     , history_table.pt_payment_frequency_type
     , history_table.pt_prepayment_finance_charge_refund
     , history_table.pt_product_pid
     , history_table.pt_rate_adjustment_lifetime_cap_percent
     , history_table.pt_subsequent_payment_adjustment_term_months
     , history_table.pt_subsequent_rate_adjustment_cap_percent
     , history_table.pt_subsequent_rate_adjustment_term_months
     , history_table.pt_prepay_penalty_type
     , history_table.pt_lender_hazard_insurance_available
     , history_table.pt_lender_hazard_insurance_premium_amount
     , history_table.pt_lender_hazard_insurance_term_months
     , history_table.pt_loan_requires_hazard_insurance
     , history_table.pt_arm_convertible
     , history_table.pt_arm_convertible_from_month
     , history_table.pt_arm_convertible_through_month
     , history_table.pt_arm_floor_rate_percent
     , history_table.pt_arm_lookback_period_days
     , history_table.pt_escrow_waiver_allowed
     , history_table.pt_days_per_year_type
     , history_table.pt_lp_risk_assessment_accepted
     , history_table.pt_du_risk_assessment_accepted
     , history_table.pt_manual_risk_assessment_accepted
     , history_table.pt_internal_underwrite_accepted
     , history_table.pt_external_fha_underwrite_accepted
     , history_table.pt_external_va_underwrite_accepted
     , history_table.pt_external_usda_underwrite_accepted
     , history_table.pt_external_investor_underwrite_accepted
     , history_table.pt_heloc_cancel_fee_applicable_type
     , history_table.pt_heloc_cancel_fee_period_months
     , history_table.pt_heloc_cancel_fee_amount
     , history_table.pt_heloc_draw_period_months
     , history_table.pt_heloc_repayment_period_duration_months
     , history_table.pt_heloc_maximum_initial_draw
     , history_table.pt_heloc_maximum_initial_draw_amount
     , history_table.pt_heloc_minimum_draw
     , history_table.pt_heloc_minimum_draw_amount
     , history_table.pt_gpm_adjustment_years
     , history_table.pt_gpm_adjustment_percent
     , history_table.pt_qualifying_monthly_payment_type
     , history_table.pt_qualifying_rate_type
     , history_table.pt_qualifying_rate_input_percent
     , history_table.pt_ipc_calc_type
     , history_table.pt_ipc_limit_percent1
     , history_table.pt_ipc_property_usage_type1
     , history_table.pt_ipc_comparison_operator_type1
     , history_table.pt_ipc_cltv_ratio_percent1
     , history_table.pt_ipc_limit_percent2
     , history_table.pt_ipc_property_usage_type2
     , history_table.pt_ipc_comparison_operator_type2
     , history_table.pt_ipc_cltv_ratio_percent2
     , history_table.pt_ipc_limit_percent3
     , history_table.pt_ipc_property_usage_type3
     , history_table.pt_ipc_comparison_operator_type3
     , history_table.pt_ipc_cltv_ratio_percent3
     , history_table.pt_ipc_limit_percent4
     , history_table.pt_ipc_property_usage_type4
     , history_table.pt_ipc_comparison_operator_type4
     , history_table.pt_ipc_cltv_ratio_percent4
     , history_table.pt_buydown_base_date_type
     , history_table.pt_buydown_subsidy_calculation_type
     , history_table.pt_prepaid_interest_rate_type
     , history_table.pt_fnm_arm_plan_type
     , history_table.pt_credit_qualifying
     , history_table.pt_product_special_program_type
     , history_table.pt_section_of_act_coarse_type
     , history_table.pt_fha_rehab_program_type
     , history_table.pt_fha_special_program_type
     , history_table.pt_third_party_grant_eligible
     , history_table.pt_servicing_transfer_type
     , history_table.pt_no_mi_product
     , history_table.pt_mortgage_credit_certificate_eligible
     , history_table.pt_fre_community_program_type
     , history_table.pt_fnm_community_lending_product_type
     , history_table.pt_zero_note_rate
     , history_table.pt_third_party_community_second_program_eligibility_type
     , history_table.pt_texas_veterans_land_board
     , history_table.pt_security_instrument_page_count
     , history_table.pt_deed_page_count
     , history_table.pt_partial_payment_policy_type
     , history_table.pt_payment_structure_type
     , history_table.pt_deferred_payment_months
     , history_table.pt_always_current_market_price
     , history_table.pt_rate_protect
     , history_table.pt_non_conforming
     , history_table.pt_allow_loan_amount_cents
     , history_table.pt_product_appraisal_requirement_type
     , history_table.pt_family_advantage
     , history_table.pt_community_lending_type
     , history_table.pt_high_balance
     , history_table.pt_decision_credit_score_calc_type
     , history_table.pt_new_york
     , history_table.pt_maximum_number_of_construction_draws
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.product_terms history_table
LEFT JOIN staging_octane.product_terms staging_table
          ON staging_table.pt_pid = history_table.pt_pid
WHERE staging_table.pt_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.product_terms deleted_records
    WHERE deleted_records.pt_pid = history_table.pt_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100075', 0, '--finding records to insert into history_octane.branch
SELECT staging_table.br_pid
     , staging_table.br_version
     , staging_table.br_company_pid
     , staging_table.br_branch_name
     , staging_table.br_fha_field_office_code
     , staging_table.br_branch_id
     , staging_table.br_branch_status_type
     , staging_table.br_nmls_branch_id
     , staging_table.br_uuts_loan_originator_type
     , staging_table.br_address_street1
     , staging_table.br_address_street2
     , staging_table.br_address_city
     , staging_table.br_address_state
     , staging_table.br_address_postal_code
     , staging_table.br_address_country
     , staging_table.br_office_phone
     , staging_table.br_office_phone_extension
     , staging_table.br_fax
     , staging_table.br_lp_lender_branch_id
     , staging_table.br_clg_flood_cert_internal_account_id
     , staging_table.br_street_links_branch_id
     , staging_table.br_fha_branch_id
     , staging_table.br_fha_branch_id_qualified
     , staging_table.br_lender_paid_broker_compensation_percent
     , staging_table.br_location_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.branch staging_table
LEFT JOIN history_octane.branch history_table
          ON staging_table.br_pid = history_table.br_pid
              AND staging_table.br_version = history_table.br_version
WHERE history_table.br_pid IS NULL
UNION ALL
SELECT history_table.br_pid
     , history_table.br_version + 1
     , history_table.br_company_pid
     , history_table.br_branch_name
     , history_table.br_fha_field_office_code
     , history_table.br_branch_id
     , history_table.br_branch_status_type
     , history_table.br_nmls_branch_id
     , history_table.br_uuts_loan_originator_type
     , history_table.br_address_street1
     , history_table.br_address_street2
     , history_table.br_address_city
     , history_table.br_address_state
     , history_table.br_address_postal_code
     , history_table.br_address_country
     , history_table.br_office_phone
     , history_table.br_office_phone_extension
     , history_table.br_fax
     , history_table.br_lp_lender_branch_id
     , history_table.br_clg_flood_cert_internal_account_id
     , history_table.br_street_links_branch_id
     , history_table.br_fha_branch_id
     , history_table.br_fha_branch_id_qualified
     , history_table.br_lender_paid_broker_compensation_percent
     , history_table.br_location_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.branch history_table
LEFT JOIN staging_octane.branch staging_table
          ON staging_table.br_pid = history_table.br_pid
WHERE staging_table.br_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.branch deleted_records
    WHERE deleted_records.br_pid = history_table.br_pid
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
    VALUES ('SP-100145')
         , ('SP-100720')
)
DELETE
FROM mdi.state_machine_definition
    USING delete_keys, mdi.process
WHERE state_machine_definition.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--json_output_field
WITH delete_keys (process_name) AS (
    VALUES ('SP-100145')
         , ('SP-100720')
)
DELETE
FROM mdi.json_output_field
    USING delete_keys, mdi.process
WHERE json_output_field.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--table_output_field
WITH delete_keys (process_name, database_field_name) AS (
    VALUES ('SP-100019', 'a_allonge_representative_name')
         , ('SP-100019', 'a_allonge_representative_title')
         , ('SP-100075', 'br_dsi_customer_id')
         , ('SP-100145', 'lcd_pid')
         , ('SP-100145', 'lcd_version')
         , ('SP-100145', 'lcd_loan_pid')
         , ('SP-100145', 'lcd_dsi_websheet_number')
         , ('SP-100145', 'lcd_dsi_doc_code')
         , ('SP-100145', 'lcd_dsi_transaction_id')
         , ('SP-100145', 'lcd_dsi_closing_document_status_type')
         , ('SP-100145', 'lcd_dsi_fatal_messages')
         , ('SP-100145', 'lcd_dsi_warning_messages')
         , ('SP-100145', 'lcd_unsigned_closing_doc_deal_file_pid')
         , ('SP-100145', 'data_source_updated_datetime')
         , ('SP-100145', 'data_source_deleted_flag')
         , ('SP-100285', 'pt_dsi_plan_code')
         , ('SP-100720', 'code')
         , ('SP-100720', 'value')
         , ('SP-100720', 'data_source_updated_datetime')
         , ('SP-100720', 'data_source_deleted_flag')
         , ('SP-100145', 'etl_batch_id')
         , ('SP-100720', 'etl_batch_id')
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
    VALUES ('SP-100145')
         , ('SP-100720')
)
DELETE
FROM mdi.table_output_step
    USING delete_keys, mdi.process
WHERE table_output_step.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--table_input_step
WITH delete_keys (process_name) AS (
    VALUES ('SP-100145')
         , ('SP-100720')
)
DELETE
FROM mdi.table_input_step
    USING delete_keys, mdi.process
WHERE table_input_step.process_dwid = process.dwid
  AND process.name = delete_keys.process_name;

--process
WITH delete_keys (process_name) AS (
    VALUES ('SP-100145')
         , ('SP-100720')
)
DELETE
FROM mdi.process
USING delete_keys
WHERE process.name = delete_keys.process_name;

--edw_field_definition
WITH delete_keys (database_name, schema_name, table_name, field_name) AS (
    VALUES ('staging', 'staging_octane', 'loan_closing_doc', 'lcd_dsi_closing_document_status_type')
         , ('staging', 'staging_octane', 'account', 'a_allonge_representative_name')
         , ('staging', 'staging_octane', 'loan_closing_doc', 'lcd_unsigned_closing_doc_deal_file_pid')
         , ('staging', 'staging_octane', 'loan_closing_doc', 'lcd_pid')
         , ('staging', 'staging_octane', 'loan_closing_doc', 'lcd_version')
         , ('staging', 'staging_octane', 'loan_closing_doc', 'lcd_dsi_websheet_number')
         , ('staging', 'staging_octane', 'loan_closing_doc', 'lcd_dsi_fatal_messages')
         , ('staging', 'staging_octane', 'product_terms', 'pt_dsi_plan_code')
         , ('staging', 'staging_octane', 'account', 'a_allonge_representative_title')
         , ('staging', 'staging_octane', 'branch', 'br_dsi_customer_id')
         , ('staging', 'staging_octane', 'closing_document_status_type', 'code')
         , ('staging', 'staging_octane', 'closing_document_status_type', 'value')
         , ('staging', 'staging_octane', 'loan_closing_doc', 'lcd_dsi_transaction_id')
         , ('staging', 'staging_octane', 'loan_closing_doc', 'lcd_loan_pid')
         , ('staging', 'staging_octane', 'loan_closing_doc', 'lcd_dsi_doc_code')
         , ('staging', 'staging_octane', 'loan_closing_doc', 'lcd_dsi_warning_messages')
)
DELETE
FROM mdi.edw_field_definition
    USING delete_keys, mdi.edw_table_definition
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name
  AND edw_field_definition.edw_table_definition_dwid = edw_table_definition.dwid
  AND edw_field_definition.field_name = delete_keys.field_name;

--edw_join_definition
WITH delete_keys (primary_database_name, primary_schema_name, primary_table_name, target_database_name, target_schema_name, target_table_name, join_condition) AS (
    VALUES ('staging', 'history_octane', 'loan_closing_doc', 'staging', 'history_octane', 'closing_document_status_type', 'primary_table.lcd_dsi_closing_document_status_type = target_table.code')
         , ('staging', 'history_octane', 'loan_closing_doc', 'staging', 'history_octane', 'loan', 'primary_table.lcd_loan_pid = target_table.l_pid')
         , ('staging', 'history_octane', 'loan_closing_doc', 'staging', 'history_octane', 'deal_file', 'primary_table.lcd_unsigned_closing_doc_deal_file_pid = target_table.df_pid')
)
DELETE
FROM mdi.edw_join_definition
    USING delete_keys, mdi.edw_table_definition primary_table, mdi.edw_table_definition target_table
WHERE delete_keys.primary_database_name = primary_table.database_name
  AND delete_keys.primary_schema_name = primary_table.schema_name
  AND delete_keys.primary_table_name = primary_table.table_name
  AND delete_keys.target_database_name = target_table.database_name
  AND delete_keys.target_schema_name = target_table.schema_name
  AND delete_keys.target_table_name = target_table.table_name
  AND primary_table.dwid = edw_join_definition.primary_edw_table_definition_dwid
  AND target_table.dwid = edw_join_definition.target_edw_table_definition_dwid
  AND delete_keys.join_condition = REGEXP_REPLACE( edw_join_definition.join_condition, 't[0-9]+\.', 'target_table.' );

--edw_table_definition
WITH delete_keys (database_name, schema_name, table_name) AS (
    VALUES ('staging', 'staging_octane', 'closing_document_status_type')
         , ('staging', 'staging_octane', 'loan_closing_doc')
)
DELETE
FROM mdi.edw_table_definition
    USING delete_keys
WHERE edw_table_definition.database_name = delete_keys.database_name
  AND edw_table_definition.schema_name = delete_keys.schema_name
  AND edw_table_definition.table_name = delete_keys.table_name;