--
-- EDW | Business Applications data mart- build a data mart and provide Octane user hierarchy data
-- https://app.asana.com/0/0/1201859471430286
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'data_mart_business_applications', 'edw_current_parent_nodes', 'staging', 'history_octane', 'org_node')
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_node_employee_leaders', 'staging', 'history_octane', 'org_node_lender_user')
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'staging', 'history_octane', 'lender_user')
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
    VALUES ('staging', 'data_mart_business_applications', 'edw_current_parent_nodes', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_nodes', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_nodes', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_nodes', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_nodes', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_nodes', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_nodes', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_nodes', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_nodes', 'parent_node_id', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_nodes', 'parent_node_name', 'VARCHAR(256)', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_nodes', 'grandparent_node_id', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_nodes', 'grandparent_node_name', 'VARCHAR(256)', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_node_employee_leaders', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_node_employee_leaders', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_node_employee_leaders', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_node_employee_leaders', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_node_employee_leaders', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_node_employee_leaders', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_node_employee_leaders', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_node_employee_leaders', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_node_employee_leaders', 'parent_node_id', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_node_employee_leaders', 'leader_company_user_id', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_current_parent_node_employee_leaders', 'leader_type', 'VARCHAR(1024)', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'data_source_dwid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'edw_created_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'edw_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'data_source_integration_columns', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'data_source_integration_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'data_source_modified_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'parent_node_id', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'parent_node_name', 'VARCHAR(256)', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'company_user_id', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'octane_username', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'first_name', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'last_name', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'professional_title', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'email', 'VARCHAR(256)', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'hire_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'termination_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'data_mart_business_applications', 'edw_employee_user_details', 'is_active_hub_user', 'BOOLEAN', NULL, NULL, NULL, NULL)
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
VALUES ('SP-400002-insert-update', 'table -> table-insert_update ETL from staging.history_octane.org_node to staging.data_mart_business_applications.edw_current_parent_nodes')
     , ('SP-400002-delete', 'table -> table-delete ETL from staging.history_octane.org_node to staging.data_mart_business_applications.edw_current_parent_nodes')
     , ('SP-400003-insert-update', 'table -> table-insert_update ETL from staging.history_octane.org_node_lender_user to staging.data_mart_business_applications.edw_current_parent_node_employee_leaders')
     , ('SP-400003-delete', 'table -> table-delete ETL from staging.history_octane.org_node_lender_user to staging.data_mart_business_applications.edw_current_parent_node_employee_leaders')
     , ('SP-400001-insert-update', 'table -> table-insert_update ETL from staging.history_octane.lender_user to staging.data_mart_business_applications.edw_employee_user_details')
     , ('SP-400001-delete', 'table -> table-delete ETL from staging.history_octane.lender_user to staging.data_mart_business_applications.edw_employee_user_details');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-400002-insert-update', 1, '--SP-400002-insert-update
SELECT ''on_pid~data_source_dwid'' AS data_source_integration_columns
     , COALESCE( CAST( parent_node.on_pid AS TEXT ), ''<NULL>'' ) || ''~1'' AS data_source_integration_id
     , NOW( ) AS edw_created_datetime
     , NOW( ) AS edw_modified_datetime
     , parent_node.data_source_updated_datetime AS data_source_modified_datetime
     , parent_node.on_org_node_id AS parent_node_id
     , parent_node.on_org_node_name_latest AS parent_node_name
     , grandparent_org_node.on_org_node_id AS grandparent_node_id
     , grandparent_org_node.on_org_node_name_latest AS grandparent_node_name
FROM (
    SELECT org_node.*
    FROM history_octane.org_node
    LEFT JOIN history_octane.org_node AS history_records
              ON org_node.on_pid = history_records.on_pid
                  AND org_node.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.on_pid IS NULL
      AND NOT org_node.data_source_deleted_flag
      AND org_node.on_lender_user_pid IS NULL -- prevents user nodes from being listed as parent nodes
) AS parent_node
--filter down to current org_node_version
JOIN (
    SELECT org_node_version.*
    FROM history_octane.org_node_version
    LEFT JOIN history_octane.org_node_version AS history_records
              ON org_node_version.onv_pid = history_records.onv_pid
                  AND org_node_version.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.onv_pid IS NULL
      AND NOT org_node_version.data_source_deleted_flag
      AND CURRENT_DATE BETWEEN org_node_version.onv_from_date
        AND COALESCE( org_node_version.onv_through_date, CURRENT_DATE ) -- is current version
) AS org_node_version
     ON parent_node.on_pid = org_node_version.onv_org_node_pid
-- grandparent node
LEFT JOIN (
    SELECT org_node.*
    FROM history_octane.org_node
    LEFT JOIN history_octane.org_node AS history_records
              ON org_node.on_pid = history_records.on_pid
                  AND org_node.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.on_pid IS NULL
      AND NOT org_node.data_source_deleted_flag
) AS grandparent_org_node
          ON org_node_version.onv_parent_org_node_pid = grandparent_org_node.on_pid
LEFT JOIN data_mart_business_applications.edw_current_parent_nodes
          ON parent_node.on_org_node_id = edw_current_parent_nodes.parent_node_id
              AND parent_node.on_org_node_name_latest = edw_current_parent_nodes.parent_node_name
              AND grandparent_org_node.on_org_node_id = edw_current_parent_nodes.grandparent_node_id
              AND grandparent_org_node.on_org_node_name_latest = edw_current_parent_nodes.grandparent_node_name
WHERE edw_current_parent_nodes.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-400002-delete', 0, '--SP-400002-delete
SELECT edw_current_parent_nodes.data_source_integration_id
FROM data_mart_business_applications.edw_current_parent_nodes
LEFT JOIN (
    SELECT *
    FROM (
        SELECT org_node.*
        FROM history_octane.org_node
        LEFT JOIN history_octane.org_node AS history_records
                  ON org_node.on_pid = history_records.on_pid
                      AND org_node.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.on_pid IS NULL
          AND NOT org_node.data_source_deleted_flag
          AND org_node.on_lender_user_pid IS NULL -- prevents user nodes from being listed as parent nodes
    ) AS parent_node
    JOIN (
        SELECT org_node_version.*
        FROM history_octane.org_node_version
        LEFT JOIN history_octane.org_node_version AS history_records
                  ON org_node_version.onv_pid = history_records.onv_pid
                      AND org_node_version.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.onv_pid IS NULL
          AND NOT org_node_version.data_source_deleted_flag
          AND CURRENT_DATE BETWEEN org_node_version.onv_from_date
            AND COALESCE( org_node_version.onv_through_date, CURRENT_DATE ) -- is current version
    ) AS org_node_version
         ON parent_node.on_pid = org_node_version.onv_org_node_pid
) AS current_data
          ON edw_current_parent_nodes.data_source_integration_id =
             COALESCE( CAST( current_data.on_pid AS TEXT ), ''<NULL>'' ) || ''~1''
WHERE current_data.on_pid IS NULL;', 'Staging DB Connection')
         , ('SP-400003-insert-update', 1, '--SP-400003-insert-update
SELECT ''onlu_pid~data_source_dwid'' AS data_source_integration_columns
     , COALESCE( CAST( org_node_lender_user.onlu_pid AS TEXT ), ''<NULL>'' ) || ''~1'' AS data_source_integration_id
     , NOW( ) AS edw_created_datetime
     , NOW( ) AS edw_modified_datetime
     , org_node_lender_user.data_source_updated_datetime AS data_source_modified_datetime
     , org_node.on_org_node_id AS parent_node_id
     , lender_user.lu_company_user_id AS leader_company_user_id
     , org_node_lender_user_type.value AS leader_type
FROM (
    SELECT org_node_lender_user.*
    FROM history_octane.org_node_lender_user
    LEFT JOIN history_octane.org_node_lender_user AS history_records
              ON org_node_lender_user.onlu_pid = history_records.onlu_pid
                  AND org_node_lender_user.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.onlu_pid IS NULL
      AND NOT org_node_lender_user.data_source_deleted_flag
      AND org_node_lender_user.onlu_org_node_lender_user_type IN (''LEADER'', ''CO_LEADER'')
      AND CURRENT_DATE BETWEEN org_node_lender_user.onlu_from_date
        AND COALESCE( org_node_lender_user.onlu_through_date, CURRENT_DATE )
) AS org_node_lender_user
JOIN (
    SELECT lender_user.*
    FROM history_octane.lender_user
    LEFT JOIN history_octane.lender_user AS history_records
              ON lender_user.lu_pid = history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND lender_user.lu_lender_user_type = ''EMPLOYEE''
) AS lender_user
     ON org_node_lender_user.onlu_lender_user_pid = lender_user.lu_pid
JOIN (
    SELECT org_node.*
    FROM history_octane.org_node
    LEFT JOIN history_octane.org_node AS history_records
              ON org_node.on_pid = history_records.on_pid
                  AND org_node.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.on_pid IS NULL
      AND NOT org_node.data_source_deleted_flag
) AS org_node
     ON org_node_lender_user.onlu_org_node_pid = org_node.on_pid
--filter down to current org_node_version
JOIN (
    SELECT org_node_version.*
    FROM history_octane.org_node_version
    LEFT JOIN history_octane.org_node_version AS history_records
              ON org_node_version.onv_pid = history_records.onv_pid
                  AND org_node_version.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.onv_pid IS NULL
      AND NOT org_node_version.data_source_deleted_flag
      AND CURRENT_DATE BETWEEN org_node_version.onv_from_date
        AND COALESCE( org_node_version.onv_through_date, CURRENT_DATE ) -- is current version
) AS org_node_version
     ON org_node.on_pid = org_node_version.onv_org_node_pid
JOIN (
    SELECT org_node_lender_user_type.*
    FROM history_octane.org_node_lender_user_type
    LEFT JOIN history_octane.org_node_lender_user_type AS history_records
              ON org_node_lender_user_type.code = history_records.code
                  AND org_node_lender_user_type.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.code IS NULL
      AND NOT org_node_lender_user_type.data_source_deleted_flag
) AS org_node_lender_user_type
     ON org_node_lender_user.onlu_org_node_lender_user_type = org_node_lender_user_type.code;', 'Staging DB Connection')
         , ('SP-400003-delete', 0, '--SP-400003-delete
SELECT edw_current_parent_node_employee_leaders.data_source_integration_id
FROM data_mart_business_applications.edw_current_parent_node_employee_leaders
LEFT JOIN (
    SELECT *
    FROM (
        SELECT org_node_lender_user.*
        FROM history_octane.org_node_lender_user
        LEFT JOIN history_octane.org_node_lender_user AS history_records
                  ON org_node_lender_user.onlu_pid = history_records.onlu_pid
                      AND org_node_lender_user.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.onlu_pid IS NULL
          AND NOT org_node_lender_user.data_source_deleted_flag
          AND org_node_lender_user.onlu_org_node_lender_user_type IN (''LEADER'', ''CO_LEADER'')
          AND CURRENT_DATE BETWEEN org_node_lender_user.onlu_from_date
            AND COALESCE( org_node_lender_user.onlu_through_date, CURRENT_DATE )
    ) AS org_node_lender_user
    JOIN (
        SELECT lender_user.*
        FROM history_octane.lender_user
        LEFT JOIN history_octane.lender_user AS history_records
                  ON lender_user.lu_pid = history_records.lu_pid
                      AND lender_user.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.lu_pid IS NULL
          AND NOT lender_user.data_source_deleted_flag
          AND lender_user.lu_lender_user_type = ''EMPLOYEE''
    ) AS lender_user
         ON org_node_lender_user.onlu_lender_user_pid = lender_user.lu_pid
    JOIN (
        SELECT org_node.*
        FROM history_octane.org_node
        LEFT JOIN history_octane.org_node AS history_records
                  ON org_node.on_pid = history_records.on_pid
                      AND org_node.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.on_pid IS NULL
          AND NOT org_node.data_source_deleted_flag
    ) AS org_node
         ON org_node_lender_user.onlu_org_node_pid = org_node.on_pid
    --filter down to current org_node_version
    JOIN (
        SELECT org_node_version.*
        FROM history_octane.org_node_version
        LEFT JOIN history_octane.org_node_version AS history_records
                  ON org_node_version.onv_pid = history_records.onv_pid
                      AND org_node_version.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.onv_pid IS NULL
          AND NOT org_node_version.data_source_deleted_flag
          AND CURRENT_DATE BETWEEN org_node_version.onv_from_date
            AND COALESCE( org_node_version.onv_through_date, CURRENT_DATE ) -- is current version
    ) AS org_node_version
         ON org_node.on_pid = org_node_version.onv_org_node_pid
    JOIN (
        SELECT org_node_lender_user_type.*
        FROM history_octane.org_node_lender_user_type
        LEFT JOIN history_octane.org_node_lender_user_type AS history_records
                  ON org_node_lender_user_type.code = history_records.code
                      AND org_node_lender_user_type.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.code IS NULL
          AND NOT org_node_lender_user_type.data_source_deleted_flag
    ) AS org_node_lender_user_type
         ON org_node_lender_user.onlu_org_node_lender_user_type = org_node_lender_user_type.code
) AS current_data
          ON edw_current_parent_node_employee_leaders.data_source_integration_id =
             COALESCE( CAST( current_data.onlu_pid AS TEXT ), ''<NULL>'' ) || ''~1''
WHERE current_data.onlu_pid IS NULL;', 'Staging DB Connection')
         , ('SP-400001-insert-update', 1, '--SP-400001-insert-update
SELECT ''lu_pid~data_source_dwid'' AS data_source_integration_columns
     , COALESCE( CAST( lender_user.lu_pid AS TEXT ), ''<NULL>'' ) || ''~1'' AS data_source_integration_id
     , NOW( ) AS edw_created_datetime
     , NOW( ) AS edw_modified_datetime
     , lender_user.data_source_updated_datetime AS data_source_modified_datetime
     , parent_org_node.on_org_node_id AS parent_node_id
     , parent_org_node.on_org_node_name_latest AS parent_node_name
     , lender_user.lu_company_user_id AS company_user_id
     , lender_user.lu_username AS octane_username
     , lender_user.lu_first_name AS first_name
     , lender_user.lu_last_name AS last_name
     , lender_user.lu_title AS professional_title
     , lender_user.lu_email AS email
     , lender_user.lu_hire_date AS hire_date
     , lender_user.lu_termination_date AS termination_date
     , (lender_user.lu_lender_user_status_type <> ''INACTIVE'' AND lender_user.lu_hub_directory) AS is_active_hub_user
FROM (
    SELECT lender_user.*
    FROM history_octane.lender_user
    LEFT JOIN history_octane.lender_user AS history_records
              ON lender_user.lu_pid = history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND lender_user.lu_lender_user_type = ''EMPLOYEE''
) AS lender_user
LEFT JOIN (
    SELECT org_node.*
    FROM history_octane.org_node
    LEFT JOIN history_octane.org_node AS history_records
              ON org_node.on_pid = history_records.on_pid
                  AND org_node.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.on_pid IS NULL
      AND NOT org_node.data_source_deleted_flag
) AS child_org_node
     ON child_org_node.on_lender_user_pid = lender_user.lu_pid
LEFT JOIN (
    SELECT org_node_version.*
    FROM history_octane.org_node_version
    LEFT JOIN history_octane.org_node_version AS history_records
              ON org_node_version.onv_pid = history_records.onv_pid
                  AND org_node_version.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.onv_pid IS NULL
      AND NOT org_node_version.data_source_deleted_flag
      AND CURRENT_DATE BETWEEN org_node_version.onv_from_date
        AND COALESCE( org_node_version.onv_through_date, CURRENT_DATE ) -- current version
) AS org_node_version
          ON child_org_node.on_pid = org_node_version.onv_org_node_pid
LEFT JOIN (
    SELECT org_node.*
    FROM history_octane.org_node
    LEFT JOIN history_octane.org_node AS history_records
              ON org_node.on_pid = history_records.on_pid
                  AND org_node.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.on_pid IS NULL
      AND NOT org_node.data_source_deleted_flag
) AS parent_org_node
          ON org_node_version.onv_parent_org_node_pid = parent_org_node.on_pid
LEFT JOIN data_mart_business_applications.edw_employee_user_details
          ON parent_org_node.on_org_node_id = edw_employee_user_details.parent_node_id
              AND parent_org_node.on_org_node_name_latest = edw_employee_user_details.parent_node_name
              AND lender_user.lu_company_user_id = edw_employee_user_details.company_user_id
              AND lender_user.lu_username = edw_employee_user_details.octane_username
              AND lender_user.lu_first_name = edw_employee_user_details.first_name
              AND lender_user.lu_last_name = edw_employee_user_details.last_name
              AND lender_user.lu_title = edw_employee_user_details.professional_title
              AND lender_user.lu_email = edw_employee_user_details.email
              AND lender_user.lu_hire_date = edw_employee_user_details.hire_date
              AND lender_user.lu_termination_date = edw_employee_user_details.termination_date
              AND (lender_user.lu_lender_user_status_type <> ''INACTIVE'' AND lender_user.lu_hub_directory) =
                  edw_employee_user_details.is_active_hub_user
WHERE edw_employee_user_details.dwid IS NULL;', 'Staging DB Connection')
         , ('SP-400001-delete', 0, '--SP-400001-delete
SELECT edw_employee_user_details.data_source_integration_id
FROM data_mart_business_applications.edw_employee_user_details
LEFT JOIN (
    SELECT lender_user.*
    FROM history_octane.lender_user
    LEFT JOIN history_octane.lender_user AS history_records
              ON lender_user.lu_pid = history_records.lu_pid
                  AND lender_user.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.lu_pid IS NULL
      AND NOT lender_user.data_source_deleted_flag
      AND lender_user.lu_lender_user_type = ''EMPLOYEE''
) AS current_data
          ON edw_employee_user_details.data_source_integration_id =
             COALESCE( CAST( current_data.lu_pid AS TEXT ), ''<NULL>'' ) || ''~1''
WHERE current_data.lu_pid IS NULL;', 'Staging DB Connection')
)
INSERT
INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
SELECT process.dwid, insert_rows.data_source_dwid, insert_rows.sql, 0, 'N', 'N', 'N', 'N', insert_rows.connectionname::mdi.pentaho_db_connection_name
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--insert_update_step
WITH insert_rows (process_name, connectionname, schema_name, table_name) AS (
    VALUES ('SP-400002-insert-update', 'Staging DB Connection', 'data_mart_business_applications', 'edw_current_parent_nodes')
         , ('SP-400003-insert-update', 'Staging DB Connection', 'data_mart_business_applications', 'edw_current_parent_node_employee_leaders')
         , ('SP-400001-insert-update', 'Staging DB Connection', 'data_mart_business_applications', 'edw_employee_user_details')
)
INSERT INTO mdi.insert_update_step (process_dwid, connectionname, schema_name, table_name, commit_size, do_not)
SELECT process.dwid, insert_rows.connectionname, insert_rows.schema_name, insert_rows.table_name, 1000, 'N'::mdi.pentaho_y_or_n
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--insert_update_key
WITH insert_rows (process_name, key_lookup) AS (
    VALUES ('SP-400002-insert-update', 'data_source_integration_id')
         , ('SP-400003-insert-update', 'data_source_integration_id')
         , ('SP-400001-insert-update', 'data_source_integration_id')
)
INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_stream2, key_condition)
SELECT insert_update_step.dwid, insert_rows.key_lookup, insert_rows.key_lookup, NULL, '='
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name
JOIN mdi.insert_update_step
     ON process.dwid = insert_update_step.process_dwid;

--insert_update_field
WITH insert_rows (process_name, update_lookup, update_flag) AS (
    VALUES ('SP-400002-insert-update', 'data_source_dwid', 'Y')
         , ('SP-400002-insert-update', 'edw_created_datetime', 'N')
         , ('SP-400002-insert-update', 'edw_modified_datetime', 'Y')
         , ('SP-400002-insert-update', 'etl_batch_id', 'Y')
         , ('SP-400002-insert-update', 'data_source_integration_columns', 'Y')
         , ('SP-400002-insert-update', 'data_source_integration_id', 'N')
         , ('SP-400002-insert-update', 'data_source_modified_datetime', 'Y')
         , ('SP-400002-insert-update', 'parent_node_id', 'N')
         , ('SP-400002-insert-update', 'parent_node_name', 'Y')
         , ('SP-400002-insert-update', 'grandparent_node_id', 'Y')
         , ('SP-400002-insert-update', 'grandparent_node_name', 'Y')
         , ('SP-400003-insert-update', 'data_source_dwid', 'Y')
         , ('SP-400003-insert-update', 'edw_created_datetime', 'N')
         , ('SP-400003-insert-update', 'edw_modified_datetime', 'Y')
         , ('SP-400003-insert-update', 'etl_batch_id', 'Y')
         , ('SP-400003-insert-update', 'data_source_integration_columns', 'Y')
         , ('SP-400003-insert-update', 'data_source_integration_id', 'N')
         , ('SP-400003-insert-update', 'data_source_modified_datetime', 'Y')
         , ('SP-400003-insert-update', 'parent_node_id', 'N')
         , ('SP-400003-insert-update', 'leader_company_user_id', 'N')
         , ('SP-400003-insert-update', 'leader_type', 'Y')
         , ('SP-400001-insert-update', 'data_source_dwid', 'Y')
         , ('SP-400001-insert-update', 'edw_created_datetime', 'N')
         , ('SP-400001-insert-update', 'edw_modified_datetime', 'Y')
         , ('SP-400001-insert-update', 'etl_batch_id', 'Y')
         , ('SP-400001-insert-update', 'data_source_integration_columns', 'Y')
         , ('SP-400001-insert-update', 'data_source_integration_id', 'N')
         , ('SP-400001-insert-update', 'data_source_modified_datetime', 'Y')
         , ('SP-400001-insert-update', 'parent_node_id', 'Y')
         , ('SP-400001-insert-update', 'parent_node_name', 'Y')
         , ('SP-400001-insert-update', 'company_user_id', 'Y')
         , ('SP-400001-insert-update', 'octane_username', 'N')
         , ('SP-400001-insert-update', 'first_name', 'Y')
         , ('SP-400001-insert-update', 'last_name', 'Y')
         , ('SP-400001-insert-update', 'professional_title', 'Y')
         , ('SP-400001-insert-update', 'email', 'Y')
         , ('SP-400001-insert-update', 'hire_date', 'Y')
         , ('SP-400001-insert-update', 'termination_date', 'Y')
         , ('SP-400001-insert-update', 'is_active_hub_user', 'Y')
)
INSERT
INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)
SELECT insert_update_step.dwid, insert_rows.update_lookup, insert_rows.update_lookup, insert_rows.update_flag::mdi.pentaho_y_or_n, FALSE
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name
JOIN mdi.insert_update_step
     ON process.dwid = insert_update_step.process_dwid;


--delete_step
WITH insert_rows (process_name, connectionname, schema_name, table_name) AS (
    VALUES ('SP-400002-delete', 'Staging DB Connection', 'data_mart_business_applications', 'edw_current_parent_nodes')
         , ('SP-400003-delete', 'Staging DB Connection', 'data_mart_business_applications', 'edw_current_parent_node_employee_leaders')
         , ('SP-400001-delete', 'Staging DB Connection', 'data_mart_business_applications', 'edw_employee_user_details')
)
INSERT INTO mdi.delete_step (process_dwid, connectionname, schema_name, table_name, commit_size)
SELECT process.dwid, insert_rows.connectionname, insert_rows.schema_name, insert_rows.table_name, 1000
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--delete_key
WITH insert_rows (process_name, table_name_field) AS (
    VALUES ('SP-400002-delete', 'data_source_integration_id')
         , ('SP-400003-delete', 'data_source_integration_id')
         , ('SP-400001-delete', 'data_source_integration_id')
)
INSERT INTO mdi.delete_key (delete_step_dwid, table_name_field, stream_fieldname_1, stream_fieldname_2, comparator, is_sensitive)
SELECT delete_step.dwid, insert_rows.table_name_field, insert_rows.table_name_field, '', '=', FALSE
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name
JOIN mdi.delete_step
     ON process.dwid = delete_step.process_dwid;

--json_output_field
WITH insert_rows (process_name, json_output_field) AS (
    VALUES ('SP-400002-insert-update', 'data_source_integration_id')
         , ('SP-400002-delete', 'data_source_integration_id')
         , ('SP-400003-insert-update', 'data_source_integration_id')
         , ('SP-400003-delete', 'data_source_integration_id')
         , ('SP-400001-insert-update', 'data_source_integration_id')
         , ('SP-400001-delete', 'data_source_integration_id')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
JOIN mdi.process
     ON insert_rows.process_name = process.name;

--state_machine_definition
WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-400002-insert-update', 'SP-400002-insert-update', 'table -> table-insert_update ETL from staging.history_octane.org_node to staging.data_mart_business_applications.edw_current_parent_nodes')
         , ('SP-400002-delete', 'SP-400002-delete', 'table -> table-delete ETL from staging.history_octane.org_node to staging.data_mart_business_applications.edw_current_parent_nodes')
         , ('SP-400003-insert-update', 'SP-400003-insert-update', 'table -> table-insert_update ETL from staging.history_octane.org_node_lender_user to staging.data_mart_business_applications.edw_current_parent_node_employee_leaders')
         , ('SP-400003-delete', 'SP-400003-delete', 'table -> table-delete ETL from staging.history_octane.org_node_lender_user to staging.data_mart_business_applications.edw_current_parent_node_employee_leaders')
         , ('SP-400001-insert-update', 'SP-400001-insert-update', 'table -> table-insert_update ETL from staging.history_octane.lender_user to staging.data_mart_business_applications.edw_employee_user_details')
         , ('SP-400001-delete', 'SP-400001-delete', 'table -> table-delete ETL from staging.history_octane.lender_user to staging.data_mart_business_applications.edw_employee_user_details')
)
INSERT
INTO mdi.state_machine_definition (process_dwid, name, comment)
SELECT process.dwid, insert_rows.state_machine_name, insert_rows.state_machine_comment
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name;

--state_machine_step
WITH insert_rows (process_name, next_process_name) AS (
    VALUES ('SP-100092', 'SP-200001-delete')
         , ('SP-100090', 'SP-200001-delete')
         , ('SP-100090', 'SP-400001-delete')
         , ('SP-100090', 'SP-400001-insert-update')
         , ('SP-100090', 'SP-400003-delete')
         , ('SP-100090', 'SP-400003-insert-update')
         , ('SP-100367', 'SP-400001-delete')
         , ('SP-100367', 'SP-400001-insert-update')
         , ('SP-100367', 'SP-400002-delete')
         , ('SP-100367', 'SP-400002-insert-update')
         , ('SP-100367', 'SP-400003-delete')
         , ('SP-100367', 'SP-400003-insert-update')
         , ('SP-100368', 'SP-400003-delete')
         , ('SP-100368', 'SP-400003-insert-update')
         , ('SP-100697', 'SP-400003-delete')
         , ('SP-100697', 'SP-400003-insert-update')
         , ('SP-100369', 'SP-400001-delete')
         , ('SP-100369', 'SP-400001-insert-update')
         , ('SP-100369', 'SP-400002-delete')
         , ('SP-100369', 'SP-400002-insert-update')
         , ('SP-300001-insert-update', 'SP-200001-delete')
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

--delete_step
WITH update_rows (process_name, connectionname, schema_name, table_name) AS (
    VALUES ('SP-200001-delete-0', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-1', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-2', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-3', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-4', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-5', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-6', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-7', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-8', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-9', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-10', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-11', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-12', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-13', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-14', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-15', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-16', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-17', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-18', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-19', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-20', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-21', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-22', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-23', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-24', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-25', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-26', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-27', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-28', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-29', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-30', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-31', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-32', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-33', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-34', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-35', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-36', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-37', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-38', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-39', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-40', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-41', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-42', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-43', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-44', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-45', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-46', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-47', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-48', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-49', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-50', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-51', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-52', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-53', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-54', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-55', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-56', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-57', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-58', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-59', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-60', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-61', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-62', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-63', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-64', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-65', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-66', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-67', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-68', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-69', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-70', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-71', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-72', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-73', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-74', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-75', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-76', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-77', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-78', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-79', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-80', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-81', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-82', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-83', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-84', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-85', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-86', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-87', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-88', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-89', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-90', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-91', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-92', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-93', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-94', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-95', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-96', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-97', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-98', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
         , ('SP-200001-delete-99', 'Staging DB Connection', 'star_loan', 'loan_lender_user_access')
)
UPDATE mdi.delete_step
SET connectionname = update_rows.connectionname
  , schema_name = update_rows.schema_name
  , table_name = update_rows.table_name
FROM update_rows
JOIN mdi.process
     ON process.name = update_rows.process_name
WHERE process.dwid = delete_step.process_dwid;
