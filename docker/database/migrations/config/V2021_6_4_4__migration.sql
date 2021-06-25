--
-- EDW | DML changes - Octane Schema changes for 2021.6.4.0 (6/25/21)
-- https://app.asana.com/0/0/1200504745087507
--

WITH new_columns (table_name, field_name, key_field_flag) AS (
    VALUES ('smart_ledger_plan_case', 'slpc_ordinal', FALSE)
         , ('ledger_entry', 'le_synthetic_unique', FALSE)
         , ('org_node', 'on_amb_codes', FALSE)
         , ('account_event', 'ae_event_date', FALSE)
)
   , insert_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT edw_table_definition.dwid, new_columns.field_name, new_columns.key_field_flag
        FROM new_columns
        JOIN mdi.edw_table_definition
             ON new_columns.table_name = edw_table_definition.table_name
                 AND edw_table_definition.schema_name = 'staging_octane'
        RETURNING dwid, field_name
)
   , insert_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid,
                                          field_name,
                                          key_field_flag,
                                          source_edw_field_definition_dwid)
        SELECT edw_table_definition.dwid
             , new_columns.field_name
             , new_columns.key_field_flag
             , insert_staging_field_definitions.dwid
        FROM new_columns
        JOIN insert_staging_field_definitions
             ON new_columns.field_name = insert_staging_field_definitions.field_name
        JOIN mdi.edw_table_definition
             ON new_columns.table_name = edw_table_definition.table_name
                 AND edw_table_definition.schema_name = 'history_octane'
)
   , tables_with_new_columns (process_name, table_name, updated_input_sql) AS (
--smart_ledger_plan_case
    VALUES ('SP-100212', 'smart_ledger_plan_case', '--finding records to insert into history_octane.smart_ledger_plan_case
SELECT staging_table.slpc_pid, staging_table.slpc_version, staging_table.slpc_account_pid, staging_table.slpc_smart_ledger_plan_case_group_pid, staging_table.slpc_case_id, staging_table.slpc_ordinal, FALSE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_ledger_plan_case staging_table
LEFT JOIN history_octane.smart_ledger_plan_case history_table
          ON staging_table.slpc_pid = history_table.slpc_pid AND staging_table.slpc_version = history_table.slpc_version
WHERE history_table.slpc_pid IS NULL
UNION ALL
SELECT history_table.slpc_pid, history_table.slpc_version + 1, history_table.slpc_account_pid, history_table.slpc_smart_ledger_plan_case_group_pid, history_table.slpc_case_id, history_table.slpc_ordinal, TRUE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM history_octane.smart_ledger_plan_case history_table
LEFT JOIN staging_octane.smart_ledger_plan_case staging_table
          ON staging_table.slpc_pid = history_table.slpc_pid
WHERE staging_table.slpc_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.smart_ledger_plan_case deleted_records
                  WHERE deleted_records.slpc_pid = history_table.slpc_pid AND deleted_records.data_source_deleted_flag = TRUE );')
-- ledger_entry
         , ('SP-100214', 'ledger_entry', '--finding records to insert into history_octane.ledger_entry
SELECT staging_table.le_pid, staging_table.le_version, staging_table.le_account_pid, staging_table.le_ledger_entry_type, staging_table.le_ledger_entry_source_type, staging_table.le_estimate, staging_table.le_ledger_entry_decision_status_type, staging_table.le_create_datetime, staging_table.le_entry_amount, staging_table.le_source_org_node_pid, staging_table.le_payee_org_node_pid, staging_table.le_payee_org_lineage_pid, staging_table.le_source_org_lineage_pid, staging_table.le_org_lineage_source_date, staging_table.le_deal_pid, staging_table.le_loan_position_type, staging_table.le_los_loan_id, staging_table.le_notes, staging_table.le_monthly_ledger_book_pid, staging_table.le_payroll_ledger_book_pid, staging_table.le_ledger_book_datetime, staging_table.le_expense_date, staging_table.le_reversal, staging_table.le_passthrough, staging_table.le_smart_ledger_plan_case_version_pid, staging_table.le_synthetic_unique, FALSE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM staging_octane.ledger_entry staging_table
LEFT JOIN history_octane.ledger_entry history_table
          ON staging_table.le_pid = history_table.le_pid AND staging_table.le_version = history_table.le_version
WHERE history_table.le_pid IS NULL
UNION ALL
SELECT history_table.le_pid, history_table.le_version + 1, history_table.le_account_pid, history_table.le_ledger_entry_type, history_table.le_ledger_entry_source_type, history_table.le_estimate, history_table.le_ledger_entry_decision_status_type, history_table.le_create_datetime, history_table.le_entry_amount, history_table.le_source_org_node_pid, history_table.le_payee_org_node_pid, history_table.le_payee_org_lineage_pid, history_table.le_source_org_lineage_pid, history_table.le_org_lineage_source_date, history_table.le_deal_pid, history_table.le_loan_position_type, history_table.le_los_loan_id, history_table.le_notes, history_table.le_monthly_ledger_book_pid, history_table.le_payroll_ledger_book_pid, history_table.le_ledger_book_datetime, history_table.le_expense_date, history_table.le_reversal, history_table.le_passthrough, history_table.le_smart_ledger_plan_case_version_pid, history_table.le_synthetic_unique, TRUE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM history_octane.ledger_entry history_table
LEFT JOIN staging_octane.ledger_entry staging_table
          ON staging_table.le_pid = history_table.le_pid
WHERE staging_table.le_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.ledger_entry deleted_records
                  WHERE deleted_records.le_pid = history_table.le_pid AND deleted_records.data_source_deleted_flag = TRUE );')
-- org_node
         , ('SP-100367', 'org_node', '--finding records to insert into history_octane.org_node
SELECT staging_table.on_pid, staging_table.on_version, staging_table.on_account_pid, staging_table.on_org_node_tree_pid, staging_table.on_lender_user_pid, staging_table.on_org_node_id, staging_table.on_org_node_short_id, staging_table.on_org_node_name_latest, staging_table.on_org_node_type, staging_table.on_description, staging_table.on_org_node_active, staging_table.on_amb_codes, FALSE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM staging_octane.org_node staging_table
LEFT JOIN history_octane.org_node history_table
          ON staging_table.on_pid = history_table.on_pid AND staging_table.on_version = history_table.on_version
WHERE history_table.on_pid IS NULL
UNION ALL
SELECT history_table.on_pid, history_table.on_version + 1, history_table.on_account_pid, history_table.on_org_node_tree_pid, history_table.on_lender_user_pid, history_table.on_org_node_id, history_table.on_org_node_short_id, history_table.on_org_node_name_latest, history_table.on_org_node_type, history_table.on_description, history_table.on_org_node_active, history_table.on_amb_codes, TRUE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM history_octane.org_node history_table
LEFT JOIN staging_octane.org_node staging_table
          ON staging_table.on_pid = history_table.on_pid
WHERE staging_table.on_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.org_node deleted_records
                  WHERE deleted_records.on_pid = history_table.on_pid AND deleted_records.data_source_deleted_flag = TRUE );')
-- account_event
         , ('SP-100002', 'account_event', '--finding records to insert into history_octane.account_event
SELECT staging_table.ae_pid, staging_table.ae_version, staging_table.ae_account_pid, staging_table.ae_create_datetime, staging_table.ae_account_event_type, staging_table.ae_detail, staging_table.ae_source_unparsed_name, staging_table.ae_ip_address, staging_table.ae_client_agent, staging_table.ae_event_date, FALSE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM staging_octane.account_event staging_table
LEFT JOIN history_octane.account_event history_table
          ON staging_table.ae_pid = history_table.ae_pid AND staging_table.ae_version = history_table.ae_version
WHERE history_table.ae_pid IS NULL
UNION ALL
SELECT history_table.ae_pid, history_table.ae_version + 1, history_table.ae_account_pid, history_table.ae_create_datetime, history_table.ae_account_event_type, history_table.ae_detail, history_table.ae_source_unparsed_name, history_table.ae_ip_address, history_table.ae_client_agent, history_table.ae_event_date, TRUE AS data_source_deleted_flag, NOW( ) AS data_source_updated_datetime
FROM history_octane.account_event history_table
LEFT JOIN staging_octane.account_event staging_table
          ON staging_table.ae_pid = history_table.ae_pid
WHERE staging_table.ae_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.account_event deleted_records
                  WHERE deleted_records.ae_pid = history_table.ae_pid AND deleted_records.data_source_deleted_flag = TRUE );')
)
   , max_field_orders AS (
    SELECT table_output_step.target_table
         , MAX( table_output_field.field_order ) AS max_field_order
    FROM mdi.table_output_field
    JOIN mdi.table_output_step
         ON table_output_step.dwid = table_output_field.table_output_step_dwid
             AND table_output_step.target_schema = 'history_octane'
    JOIN tables_with_new_columns
         ON table_output_step.target_table = tables_with_new_columns.table_name
    GROUP BY table_output_step.target_table
)
   , new_column_field_orders AS (
    SELECT new_columns.field_name
         , ROW_NUMBER( ) OVER (PARTITION BY new_columns.table_name) + max_field_orders.max_field_order AS field_order
    FROM new_columns
    JOIN max_field_orders
         ON max_field_orders.target_table = new_columns.table_name
)
   , insert_output_fields AS (
    INSERT
        INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
            SELECT table_output_step.dwid
                 , new_columns.field_name
                 , new_columns.field_name
                 , new_column_field_orders.field_order
                 , FALSE
            FROM new_columns
            JOIN new_column_field_orders
                 ON new_columns.field_name = new_column_field_orders.field_name
            JOIN mdi.table_output_step
                 ON new_columns.table_name = table_output_step.target_table
                     AND table_output_step.target_schema = 'history_octane'
)
UPDATE mdi.table_input_step
SET sql = tables_with_new_columns.updated_input_sql
FROM tables_with_new_columns
JOIN mdi.process
     ON process.name = tables_with_new_columns.process_name
WHERE table_input_step.process_dwid = process.dwid;
