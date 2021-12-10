--
-- MAIN | EDW - Octane schemas from prod-release to v2021.12.2.0 on uat - https://app.asana.com/0/0/1201473422514474
--

/*
INSERTIONS
*/

--edw_table_definition
WITH insert_rows (database_name, schema_name, table_name, source_database_name, source_schema_name, source_table_name) AS (
    VALUES ('staging', 'staging_octane', 'rate_sheet_group', NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'rate_sheet_group_member', NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'rate_sheet_group', 'staging', 'staging_octane', 'rate_sheet_group')
         , ('staging', 'history_octane', 'rate_sheet_group_member', 'staging', 'staging_octane', 'rate_sheet_group_member')
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
    VALUES ('staging', 'history_octane', 'rate_sheet_group', 'staging', 'history_octane', 'account', 'primary_table.rsg_account_pid = target_table.a_pid')
         , ('staging', 'history_octane', 'rate_sheet_group', 'staging', 'history_octane', 'investor', 'primary_table.rsg_investor_pid = target_table.i_pid')
         , ('staging', 'history_octane', 'rate_sheet_group', 'staging', 'history_octane', 'loan_amortization_type', 'primary_table.rsg_loan_amortization_type = target_table.code')
         , ('staging', 'history_octane', 'rate_sheet_group_member', 'staging', 'history_octane', 'rate_sheet_group', 'primary_table.rsgm_rate_sheet_group_pid = target_table.rsg_pid')
         , ('staging', 'history_octane', 'rate_sheet_group_member', 'staging', 'history_octane', 'product', 'primary_table.rsgm_product_pid = target_table.p_pid')
         , ('staging', 'history_octane', 'rate_sheet', 'staging', 'history_octane', 'rate_sheet_group', 'primary_table.rs_rate_sheet_group_pid = target_table.rsg_pid')
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
    VALUES ('staging', 'history_octane', 'rate_sheet_group', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'rate_sheet_group', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'rate_sheet_group', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'rate_sheet_group_member', 'data_source_updated_datetime', 'TIMESTAMPTZ', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'rate_sheet_group_member', 'data_source_deleted_flag', 'BOOLEAN', NULL, NULL, NULL, NULL)
         , ('staging', 'history_octane', 'rate_sheet_group_member', 'etl_batch_id', 'TEXT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'proposal_grant_program', 'pgp_snapshotted_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'liability', 'lia_snapshotted_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'rate_sheet_group', 'rsg_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'rate_sheet_group', 'rsg_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'rate_sheet_group', 'rsg_account_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'rate_sheet_group', 'rsg_rate_sheet_group_id', 'VARCHAR(32)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'rate_sheet_group', 'rsg_rate_sheet_group_name', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'rate_sheet_group', 'rsg_investor_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'rate_sheet_group', 'rsg_loan_amortization_type', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'asset', 'as_snapshotted_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'rate_sheet_group_member', 'rsgm_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'rate_sheet_group_member', 'rsgm_version', 'INTEGER', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'rate_sheet_group_member', 'rsgm_rate_sheet_group_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'rate_sheet_group_member', 'rsgm_product_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'rate_sheet_group_member', 'rsgm_from_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'rate_sheet_group_member', 'rsgm_through_date', 'DATE', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'borrower_income', 'bi_snapshotted_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'rate_sheet', 'rs_rate_sheet_group_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'place', 'pl_snapshotted_pid', 'BIGINT', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_version', 'slpcv_last_modified_by', 'VARCHAR(128)', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'smart_ledger_plan_case_version', 'slpcv_last_modified_datetime', 'TIMESTAMP', NULL, NULL, NULL, NULL)
         , ('staging', 'staging_octane', 'asset_large_deposit', 'ald_snapshotted_pid', 'BIGINT', NULL, NULL, NULL, NULL)
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
    VALUES ('staging', 'history_octane', 'proposal_grant_program', 'pgp_snapshotted_pid', 'BIGINT', 'staging', 'staging_octane', 'proposal_grant_program', 'pgp_snapshotted_pid')
         , ('staging', 'history_octane', 'liability', 'lia_snapshotted_pid', 'BIGINT', 'staging', 'staging_octane', 'liability', 'lia_snapshotted_pid')
         , ('staging', 'history_octane', 'rate_sheet_group', 'rsg_pid', 'BIGINT', 'staging', 'staging_octane', 'rate_sheet_group', 'rsg_pid')
         , ('staging', 'history_octane', 'rate_sheet_group', 'rsg_version', 'INTEGER', 'staging', 'staging_octane', 'rate_sheet_group', 'rsg_version')
         , ('staging', 'history_octane', 'rate_sheet_group', 'rsg_account_pid', 'BIGINT', 'staging', 'staging_octane', 'rate_sheet_group', 'rsg_account_pid')
         , ('staging', 'history_octane', 'rate_sheet_group', 'rsg_rate_sheet_group_id', 'VARCHAR(32)', 'staging', 'staging_octane', 'rate_sheet_group', 'rsg_rate_sheet_group_id')
         , ('staging', 'history_octane', 'rate_sheet_group', 'rsg_rate_sheet_group_name', 'VARCHAR(128)', 'staging', 'staging_octane', 'rate_sheet_group', 'rsg_rate_sheet_group_name')
         , ('staging', 'history_octane', 'rate_sheet_group', 'rsg_investor_pid', 'BIGINT', 'staging', 'staging_octane', 'rate_sheet_group', 'rsg_investor_pid')
         , ('staging', 'history_octane', 'rate_sheet_group', 'rsg_loan_amortization_type', 'VARCHAR(128)', 'staging', 'staging_octane', 'rate_sheet_group', 'rsg_loan_amortization_type')
         , ('staging', 'history_octane', 'asset', 'as_snapshotted_pid', 'BIGINT', 'staging', 'staging_octane', 'asset', 'as_snapshotted_pid')
         , ('staging', 'history_octane', 'rate_sheet_group_member', 'rsgm_pid', 'BIGINT', 'staging', 'staging_octane', 'rate_sheet_group_member', 'rsgm_pid')
         , ('staging', 'history_octane', 'rate_sheet_group_member', 'rsgm_version', 'INTEGER', 'staging', 'staging_octane', 'rate_sheet_group_member', 'rsgm_version')
         , ('staging', 'history_octane', 'rate_sheet_group_member', 'rsgm_rate_sheet_group_pid', 'BIGINT', 'staging', 'staging_octane', 'rate_sheet_group_member', 'rsgm_rate_sheet_group_pid')
         , ('staging', 'history_octane', 'rate_sheet_group_member', 'rsgm_product_pid', 'BIGINT', 'staging', 'staging_octane', 'rate_sheet_group_member', 'rsgm_product_pid')
         , ('staging', 'history_octane', 'rate_sheet_group_member', 'rsgm_from_date', 'DATE', 'staging', 'staging_octane', 'rate_sheet_group_member', 'rsgm_from_date')
         , ('staging', 'history_octane', 'rate_sheet_group_member', 'rsgm_through_date', 'DATE', 'staging', 'staging_octane', 'rate_sheet_group_member', 'rsgm_through_date')
         , ('staging', 'history_octane', 'borrower_income', 'bi_snapshotted_pid', 'BIGINT', 'staging', 'staging_octane', 'borrower_income', 'bi_snapshotted_pid')
         , ('staging', 'history_octane', 'rate_sheet', 'rs_rate_sheet_group_pid', 'BIGINT', 'staging', 'staging_octane', 'rate_sheet', 'rs_rate_sheet_group_pid')
         , ('staging', 'history_octane', 'place', 'pl_snapshotted_pid', 'BIGINT', 'staging', 'staging_octane', 'place', 'pl_snapshotted_pid')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_version', 'slpcv_last_modified_by', 'VARCHAR(128)', 'staging', 'staging_octane', 'smart_ledger_plan_case_version', 'slpcv_last_modified_by')
         , ('staging', 'history_octane', 'smart_ledger_plan_case_version', 'slpcv_last_modified_datetime', 'TIMESTAMP', 'staging', 'staging_octane', 'smart_ledger_plan_case_version', 'slpcv_last_modified_datetime')
         , ('staging', 'history_octane', 'asset_large_deposit', 'ald_snapshotted_pid', 'BIGINT', 'staging', 'staging_octane', 'asset_large_deposit', 'ald_snapshotted_pid')
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
VALUES ('SP-100881', 'ETL to copy rate_sheet_group data from staging_octane to history_octane')
     , ('SP-100882', 'ETL to copy rate_sheet_group_member data from staging_octane to history_octane');

--table_input_step
WITH insert_rows (process_name, data_source_dwid, sql, connectionname) AS (
    VALUES ('SP-100881', 0, '--finding records to insert into history_octane.rate_sheet_group
SELECT staging_table.rsg_pid
     , staging_table.rsg_version
     , staging_table.rsg_account_pid
     , staging_table.rsg_rate_sheet_group_id
     , staging_table.rsg_rate_sheet_group_name
     , staging_table.rsg_investor_pid
     , staging_table.rsg_loan_amortization_type
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.rate_sheet_group staging_table
LEFT JOIN history_octane.rate_sheet_group history_table
          ON staging_table.rsg_pid = history_table.rsg_pid
              AND staging_table.rsg_version = history_table.rsg_version
WHERE history_table.rsg_pid IS NULL
UNION ALL
SELECT history_table.rsg_pid
     , history_table.rsg_version + 1
     , history_table.rsg_account_pid
     , history_table.rsg_rate_sheet_group_id
     , history_table.rsg_rate_sheet_group_name
     , history_table.rsg_investor_pid
     , history_table.rsg_loan_amortization_type
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.rate_sheet_group history_table
LEFT JOIN staging_octane.rate_sheet_group staging_table
          ON staging_table.rsg_pid = history_table.rsg_pid
WHERE staging_table.rsg_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.rate_sheet_group deleted_records
    WHERE deleted_records.rsg_pid = history_table.rsg_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100882', 0, '--finding records to insert into history_octane.rate_sheet_group_member
SELECT staging_table.rsgm_pid
     , staging_table.rsgm_version
     , staging_table.rsgm_rate_sheet_group_pid
     , staging_table.rsgm_product_pid
     , staging_table.rsgm_from_date
     , staging_table.rsgm_through_date
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.rate_sheet_group_member staging_table
LEFT JOIN history_octane.rate_sheet_group_member history_table
          ON staging_table.rsgm_pid = history_table.rsgm_pid
              AND staging_table.rsgm_version = history_table.rsgm_version
WHERE history_table.rsgm_pid IS NULL
UNION ALL
SELECT history_table.rsgm_pid
     , history_table.rsgm_version + 1
     , history_table.rsgm_rate_sheet_group_pid
     , history_table.rsgm_product_pid
     , history_table.rsgm_from_date
     , history_table.rsgm_through_date
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.rate_sheet_group_member history_table
LEFT JOIN staging_octane.rate_sheet_group_member staging_table
          ON staging_table.rsgm_pid = history_table.rsgm_pid
WHERE staging_table.rsgm_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.rate_sheet_group_member deleted_records
    WHERE deleted_records.rsgm_pid = history_table.rsgm_pid
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
    VALUES ('SP-100881', 'history_octane', 'rate_sheet_group', 'N', 'Staging DB Connection')
         , ('SP-100882', 'history_octane', 'rate_sheet_group_member', 'N', 'Staging DB Connection')
)
INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
SELECT process.dwid, insert_rows.target_schema, insert_rows.target_table, 1000, NULL, NULL, NULL, NULL, 'N', NULL, insert_rows.truncate_table::mdi.pentaho_y_or_n, insert_rows.connectionname, 'N', 'Y', 'N', 'N'
FROM insert_rows
    JOIN mdi.process
        ON process.name = insert_rows.process_name;

--table_output_field
WITH insert_rows (process_name, database_field_name) AS (
    VALUES ('SP-100168', 'pgp_snapshotted_pid')
         , ('SP-100182', 'lia_snapshotted_pid')
         , ('SP-100881', 'rsg_pid')
         , ('SP-100881', 'rsg_version')
         , ('SP-100881', 'rsg_account_pid')
         , ('SP-100881', 'rsg_rate_sheet_group_id')
         , ('SP-100881', 'rsg_rate_sheet_group_name')
         , ('SP-100881', 'rsg_investor_pid')
         , ('SP-100881', 'rsg_loan_amortization_type')
         , ('SP-100881', 'data_source_updated_datetime')
         , ('SP-100881', 'data_source_deleted_flag')
         , ('SP-100881', 'etl_batch_id')
         , ('SP-100070', 'as_snapshotted_pid')
         , ('SP-100882', 'rsgm_pid')
         , ('SP-100882', 'rsgm_version')
         , ('SP-100882', 'rsgm_rate_sheet_group_pid')
         , ('SP-100882', 'rsgm_product_pid')
         , ('SP-100882', 'rsgm_from_date')
         , ('SP-100882', 'rsgm_through_date')
         , ('SP-100882', 'data_source_updated_datetime')
         , ('SP-100882', 'data_source_deleted_flag')
         , ('SP-100882', 'etl_batch_id')
         , ('SP-100133', 'bi_snapshotted_pid')
         , ('SP-100288', 'rs_rate_sheet_group_pid')
         , ('SP-100012', 'pl_snapshotted_pid')
         , ('SP-100213', 'slpcv_last_modified_by')
         , ('SP-100213', 'slpcv_last_modified_datetime')
         , ('SP-100071', 'ald_snapshotted_pid')
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
    VALUES ('SP-100881', 'rsg_pid')
         , ('SP-100882', 'rsgm_pid')
)
INSERT
INTO mdi.json_output_field (process_dwid, field_name)
SELECT process.dwid, insert_rows.json_output_field
FROM insert_rows
    JOIN mdi.process
        ON insert_rows.process_name = process.name;

--state_machine_definition
WITH insert_rows (process_name, state_machine_name, state_machine_comment) AS (
    VALUES ('SP-100881', 'SP-100881', 'ETL to copy rate_sheet_group data from staging_octane to history_octane')
         , ('SP-100882', 'SP-100882', 'ETL to copy rate_sheet_group_member data from staging_octane to history_octane')
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
    VALUES ('SP-100168', 0, '--finding records to insert into history_octane.proposal_grant_program
SELECT staging_table.pgp_pid
     , staging_table.pgp_version
     , staging_table.pgp_proposal_pid
     , staging_table.pgp_account_grant_program_pid
     , staging_table.pgp_grant_amount
     , staging_table.pgp_snapshotted_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.proposal_grant_program staging_table
LEFT JOIN history_octane.proposal_grant_program history_table
          ON staging_table.pgp_pid = history_table.pgp_pid
              AND staging_table.pgp_version = history_table.pgp_version
WHERE history_table.pgp_pid IS NULL
UNION ALL
SELECT history_table.pgp_pid
     , history_table.pgp_version + 1
     , history_table.pgp_proposal_pid
     , history_table.pgp_account_grant_program_pid
     , history_table.pgp_grant_amount
     , history_table.pgp_snapshotted_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.proposal_grant_program history_table
LEFT JOIN staging_octane.proposal_grant_program staging_table
          ON staging_table.pgp_pid = history_table.pgp_pid
WHERE staging_table.pgp_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.proposal_grant_program deleted_records
    WHERE deleted_records.pgp_pid = history_table.pgp_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100182', 0, '--finding records to insert into history_octane.liability
SELECT staging_table.lia_pid
     , staging_table.lia_version
     , staging_table.lia_proposal_pid
     , staging_table.lia_aggregate_description
     , staging_table.lia_credit_request_liability_pid
     , staging_table.lia_description
     , staging_table.lia_city
     , staging_table.lia_country
     , staging_table.lia_postal_code
     , staging_table.lia_state
     , staging_table.lia_street1
     , staging_table.lia_street2
     , staging_table.lia_holder_name
     , staging_table.lia_holder_phone
     , staging_table.lia_holder_phone_extension
     , staging_table.lia_holder_fax
     , staging_table.lia_holder_email
     , staging_table.lia_account_opened_date
     , staging_table.lia_liability_disposition_type
     , staging_table.lia_liability_type
     , staging_table.lia_monthly_payment_amount
     , staging_table.lia_remaining_term_months
     , staging_table.lia_high_balance_amount
     , staging_table.lia_credit_limit_amount
     , staging_table.lia_past_due_amount
     , staging_table.lia_unpaid_balance_amount
     , staging_table.lia_report_value_overridden
     , staging_table.lia_bankruptcy_exception_type
     , staging_table.lia_note
     , staging_table.lia_terms_months_count
     , staging_table.lia_payoff_amount
     , staging_table.lia_energy_related_type
     , staging_table.lia_snapshotted_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.liability staging_table
LEFT JOIN history_octane.liability history_table
          ON staging_table.lia_pid = history_table.lia_pid
              AND staging_table.lia_version = history_table.lia_version
WHERE history_table.lia_pid IS NULL
UNION ALL
SELECT history_table.lia_pid
     , history_table.lia_version + 1
     , history_table.lia_proposal_pid
     , history_table.lia_aggregate_description
     , history_table.lia_credit_request_liability_pid
     , history_table.lia_description
     , history_table.lia_city
     , history_table.lia_country
     , history_table.lia_postal_code
     , history_table.lia_state
     , history_table.lia_street1
     , history_table.lia_street2
     , history_table.lia_holder_name
     , history_table.lia_holder_phone
     , history_table.lia_holder_phone_extension
     , history_table.lia_holder_fax
     , history_table.lia_holder_email
     , history_table.lia_account_opened_date
     , history_table.lia_liability_disposition_type
     , history_table.lia_liability_type
     , history_table.lia_monthly_payment_amount
     , history_table.lia_remaining_term_months
     , history_table.lia_high_balance_amount
     , history_table.lia_credit_limit_amount
     , history_table.lia_past_due_amount
     , history_table.lia_unpaid_balance_amount
     , history_table.lia_report_value_overridden
     , history_table.lia_bankruptcy_exception_type
     , history_table.lia_note
     , history_table.lia_terms_months_count
     , history_table.lia_payoff_amount
     , history_table.lia_energy_related_type
     , history_table.lia_snapshotted_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.liability history_table
LEFT JOIN staging_octane.liability staging_table
          ON staging_table.lia_pid = history_table.lia_pid
WHERE staging_table.lia_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.liability deleted_records
    WHERE deleted_records.lia_pid = history_table.lia_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100070', 0, '--finding records to insert into history_octane.asset
SELECT staging_table.as_pid
     , staging_table.as_version
     , staging_table.as_aggregate_description
     , staging_table.as_application_pid
     , staging_table.as_asset_type
     , staging_table.as_automobile_make_description
     , staging_table.as_automobile_model_year
     , staging_table.as_cash_or_market_value_amount
     , staging_table.as_description
     , staging_table.as_donor_city
     , staging_table.as_donor_country
     , staging_table.as_donor_postal_code
     , staging_table.as_donor_state
     , staging_table.as_donor_street1
     , staging_table.as_donor_street2
     , staging_table.as_gift_funds_donor_phone
     , staging_table.as_gift_funds_donor_relationship
     , staging_table.as_gift_funds_donor_unparsed_name
     , staging_table.as_gift_funds_other_type_description
     , staging_table.as_gift_funds_depository_asset_pid
     , staging_table.as_gift_amount
     , staging_table.as_gift_funds_source_account_type
     , staging_table.as_gift_funds_source_holder_name
     , staging_table.as_gift_funds_type
     , staging_table.as_holder_name
     , staging_table.as_holder_city
     , staging_table.as_holder_country
     , staging_table.as_holder_postal_code
     , staging_table.as_holder_state
     , staging_table.as_holder_street1
     , staging_table.as_holder_street2
     , staging_table.as_life_insurance_face_value_amount
     , staging_table.as_liquid_amount
     , staging_table.as_liquid_percent
     , staging_table.as_source_verification_required
     , staging_table.as_stock_bond_mutual_fund_share_count
     , staging_table.as_earnest_money_deposit_source_pid
     , staging_table.as_available_amount
     , staging_table.as_down_payment_amount
     , staging_table.as_closing_costs_amount
     , staging_table.as_gift_funds_account_holder_type
     , staging_table.as_penalty_amount
     , staging_table.as_earnest_money_deposit_is_gift
     , staging_table.as_deposit_date
     , staging_table.as_gift_funds_ein
     , staging_table.as_snapshotted_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.asset staging_table
LEFT JOIN history_octane.asset history_table
          ON staging_table.as_pid = history_table.as_pid
              AND staging_table.as_version = history_table.as_version
WHERE history_table.as_pid IS NULL
UNION ALL
SELECT history_table.as_pid
     , history_table.as_version + 1
     , history_table.as_aggregate_description
     , history_table.as_application_pid
     , history_table.as_asset_type
     , history_table.as_automobile_make_description
     , history_table.as_automobile_model_year
     , history_table.as_cash_or_market_value_amount
     , history_table.as_description
     , history_table.as_donor_city
     , history_table.as_donor_country
     , history_table.as_donor_postal_code
     , history_table.as_donor_state
     , history_table.as_donor_street1
     , history_table.as_donor_street2
     , history_table.as_gift_funds_donor_phone
     , history_table.as_gift_funds_donor_relationship
     , history_table.as_gift_funds_donor_unparsed_name
     , history_table.as_gift_funds_other_type_description
     , history_table.as_gift_funds_depository_asset_pid
     , history_table.as_gift_amount
     , history_table.as_gift_funds_source_account_type
     , history_table.as_gift_funds_source_holder_name
     , history_table.as_gift_funds_type
     , history_table.as_holder_name
     , history_table.as_holder_city
     , history_table.as_holder_country
     , history_table.as_holder_postal_code
     , history_table.as_holder_state
     , history_table.as_holder_street1
     , history_table.as_holder_street2
     , history_table.as_life_insurance_face_value_amount
     , history_table.as_liquid_amount
     , history_table.as_liquid_percent
     , history_table.as_source_verification_required
     , history_table.as_stock_bond_mutual_fund_share_count
     , history_table.as_earnest_money_deposit_source_pid
     , history_table.as_available_amount
     , history_table.as_down_payment_amount
     , history_table.as_closing_costs_amount
     , history_table.as_gift_funds_account_holder_type
     , history_table.as_penalty_amount
     , history_table.as_earnest_money_deposit_is_gift
     , history_table.as_deposit_date
     , history_table.as_gift_funds_ein
     , history_table.as_snapshotted_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.asset history_table
LEFT JOIN staging_octane.asset staging_table
          ON staging_table.as_pid = history_table.as_pid
WHERE staging_table.as_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.asset deleted_records
    WHERE deleted_records.as_pid = history_table.as_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100133', 0, '--finding records to insert into history_octane.borrower_income
SELECT staging_table.bi_pid
     , staging_table.bi_version
     , staging_table.bi_borrower_pid
     , staging_table.bi_borrower_income_category_type
     , staging_table.bi_job_gap_reason_type
     , staging_table.bi_job_gap_reason_explanation
     , staging_table.bi_business_ownership_type
     , staging_table.bi_from_date
     , staging_table.bi_through_date
     , staging_table.bi_current
     , staging_table.bi_primary
     , staging_table.bi_source_name
     , staging_table.bi_source_address_street1
     , staging_table.bi_source_address_street2
     , staging_table.bi_source_address_city
     , staging_table.bi_source_address_state
     , staging_table.bi_source_address_postal_code
     , staging_table.bi_source_address_country
     , staging_table.bi_source_phone
     , staging_table.bi_source_phone_extension
     , staging_table.bi_synthetic_unique
     , staging_table.bi_snapshotted_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.borrower_income staging_table
LEFT JOIN history_octane.borrower_income history_table
          ON staging_table.bi_pid = history_table.bi_pid
              AND staging_table.bi_version = history_table.bi_version
WHERE history_table.bi_pid IS NULL
UNION ALL
SELECT history_table.bi_pid
     , history_table.bi_version + 1
     , history_table.bi_borrower_pid
     , history_table.bi_borrower_income_category_type
     , history_table.bi_job_gap_reason_type
     , history_table.bi_job_gap_reason_explanation
     , history_table.bi_business_ownership_type
     , history_table.bi_from_date
     , history_table.bi_through_date
     , history_table.bi_current
     , history_table.bi_primary
     , history_table.bi_source_name
     , history_table.bi_source_address_street1
     , history_table.bi_source_address_street2
     , history_table.bi_source_address_city
     , history_table.bi_source_address_state
     , history_table.bi_source_address_postal_code
     , history_table.bi_source_address_country
     , history_table.bi_source_phone
     , history_table.bi_source_phone_extension
     , history_table.bi_synthetic_unique
     , history_table.bi_snapshotted_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.borrower_income history_table
LEFT JOIN staging_octane.borrower_income staging_table
          ON staging_table.bi_pid = history_table.bi_pid
WHERE staging_table.bi_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.borrower_income deleted_records
    WHERE deleted_records.bi_pid = history_table.bi_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100288', 0, '--finding records to insert into history_octane.rate_sheet
SELECT staging_table.rs_pid
     , staging_table.rs_version
     , staging_table.rs_product_pid
     , staging_table.rs_from_datetime
     , staging_table.rs_rate_sheet_group_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.rate_sheet staging_table
LEFT JOIN history_octane.rate_sheet history_table
          ON staging_table.rs_pid = history_table.rs_pid
              AND staging_table.rs_version = history_table.rs_version
WHERE history_table.rs_pid IS NULL
UNION ALL
SELECT history_table.rs_pid
     , history_table.rs_version + 1
     , history_table.rs_product_pid
     , history_table.rs_from_datetime
     , history_table.rs_rate_sheet_group_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.rate_sheet history_table
LEFT JOIN staging_octane.rate_sheet staging_table
          ON staging_table.rs_pid = history_table.rs_pid
WHERE staging_table.rs_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.rate_sheet deleted_records
    WHERE deleted_records.rs_pid = history_table.rs_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100012', 0, '--finding records to insert into history_octane.place
SELECT staging_table.pl_pid
     , staging_table.pl_version
     , staging_table.pl_proposal_pid
     , staging_table.pl_subject_property
     , staging_table.pl_acquisition_date
     , staging_table.pl_financed_units_count
     , staging_table.pl_unit_count
     , staging_table.pl_land_estimated_value_amount
     , staging_table.pl_land_original_cost_amount
     , staging_table.pl_leasehold_expiration_date
     , staging_table.pl_legal_description_type
     , staging_table.pl_legal_description
     , staging_table.pl_property_tax_id
     , staging_table.pl_legal_lot
     , staging_table.pl_legal_block
     , staging_table.pl_legal_section
     , staging_table.pl_project_name
     , staging_table.pl_cpm_project_id
     , staging_table.pl_acquisition_cost_amount
     , staging_table.pl_county_pid
     , staging_table.pl_sub_jurisdiction_name
     , staging_table.pl_recording_district_name
     , staging_table.pl_project_classification_type
     , staging_table.pl_property_category_type
     , staging_table.pl_property_rights_type
     , staging_table.pl_structure_built_year
     , staging_table.pl_structure_built_month
     , staging_table.pl_title_manner_held_type
     , staging_table.pl_title_manner_held_description
     , staging_table.pl_building_status_type
     , staging_table.pl_construction_conversion
     , staging_table.pl_native_american_lands_type
     , staging_table.pl_community_land_trust
     , staging_table.pl_inclusionary_zoning
     , staging_table.pl_unique_dwelling_type
     , staging_table.pl_living_unit_count
     , staging_table.pl_project_design_type
     , staging_table.pl_city
     , staging_table.pl_country
     , staging_table.pl_postal_code
     , staging_table.pl_state
     , staging_table.pl_street1
     , staging_table.pl_street2
     , staging_table.pl_street_tbd
     , staging_table.pl_landlord_first_name
     , staging_table.pl_landlord_last_name
     , staging_table.pl_landlord_middle_name
     , staging_table.pl_landlord_name_suffix
     , staging_table.pl_landlord_company_name
     , staging_table.pl_landlord_title
     , staging_table.pl_landlord_office_phone
     , staging_table.pl_landlord_office_phone_extension
     , staging_table.pl_landlord_mobile_phone
     , staging_table.pl_landlord_email
     , staging_table.pl_landlord_fax
     , staging_table.pl_landlord_city
     , staging_table.pl_landlord_country
     , staging_table.pl_landlord_postal_code
     , staging_table.pl_landlord_state
     , staging_table.pl_landlord_street1
     , staging_table.pl_landlord_street2
     , staging_table.pl_management_first_name
     , staging_table.pl_management_last_name
     , staging_table.pl_management_middle_name
     , staging_table.pl_management_name_suffix
     , staging_table.pl_management_company_name
     , staging_table.pl_management_title
     , staging_table.pl_management_office_phone
     , staging_table.pl_management_office_phone_extension
     , staging_table.pl_management_mobile_phone
     , staging_table.pl_management_email
     , staging_table.pl_management_fax
     , staging_table.pl_management_city
     , staging_table.pl_management_country
     , staging_table.pl_management_postal_code
     , staging_table.pl_management_state
     , staging_table.pl_management_street1
     , staging_table.pl_management_street2
     , staging_table.pl_property_insurance_amount_input_type
     , staging_table.pl_property_tax_amount_input_type
     , staging_table.pl_annual_property_insurance_amount
     , staging_table.pl_annual_property_tax_amount
     , staging_table.pl_monthly_property_insurance_amount
     , staging_table.pl_monthly_hoa_amount
     , staging_table.pl_monthly_mi_amount
     , staging_table.pl_monthly_property_tax_amount
     , staging_table.pl_monthly_lease_ground_rent_amount
     , staging_table.pl_monthly_rent_amount
     , staging_table.pl_monthly_obligation_amount
     , staging_table.pl_use_proposed_property_usage
     , staging_table.pl_property_usage_type
     , staging_table.pl_property_value_amount
     , staging_table.pl_reo_disposition_status_type
     , staging_table.pl_auto_geocode
     , staging_table.pl_auto_geocode_exception
     , staging_table.pl_msa_code
     , staging_table.pl_state_fips
     , staging_table.pl_county_fips
     , staging_table.pl_census_tract
     , staging_table.pl_mh_make
     , staging_table.pl_mh_model
     , staging_table.pl_mh_length
     , staging_table.pl_mh_width
     , staging_table.pl_mh_manufacturer
     , staging_table.pl_mh_serial_number
     , staging_table.pl_mh_hud_label_number
     , staging_table.pl_mh_certificate_of_title_issued
     , staging_table.pl_mh_certificate_of_title_number
     , staging_table.pl_mh_certificate_of_title_type
     , staging_table.pl_mh_loan_purpose_type
     , staging_table.pl_mh_anchored
     , staging_table.pl_coop_company_name
     , staging_table.pl_coop_building_name
     , staging_table.pl_coop_vacant_units
     , staging_table.pl_coop_proprietary_lease_date
     , staging_table.pl_coop_assignment_lease_date
     , staging_table.pl_coop_existing_company_laws_state
     , staging_table.pl_coop_shares_being_purchased
     , staging_table.pl_coop_attorney_in_fact
     , staging_table.pl_coop_stock_certificate_number
     , staging_table.pl_coop_apartment_unit
     , staging_table.pl_rental
     , staging_table.pl_underwriter_comments
     , staging_table.pl_lava_zone_type
     , staging_table.pl_neighborhood_location_type
     , staging_table.pl_site_area
     , staging_table.pl_hud_reo
     , staging_table.pl_va_guaranteed_reo
     , staging_table.pl_va_loan_date
     , staging_table.pl_gross_building_area_square_feet
     , staging_table.pl_project_dwelling_units_sold_count
     , staging_table.pl_prior_owners_title
     , staging_table.pl_prior_owners_title_policy_amount
     , staging_table.pl_prior_owners_title_policy_effective_date
     , staging_table.pl_prior_lenders_title
     , staging_table.pl_prior_lenders_title_policy_amount
     , staging_table.pl_prior_lenders_title_policy_effective_date
     , staging_table.pl_bedroom_count_unit_1
     , staging_table.pl_bedroom_count_unit_2
     , staging_table.pl_bedroom_count_unit_3
     , staging_table.pl_bedroom_count_unit_4
     , staging_table.pl_rent_amount_unit_1
     , staging_table.pl_rent_amount_unit_2
     , staging_table.pl_rent_amount_unit_3
     , staging_table.pl_rent_amount_unit_4
     , staging_table.pl_listed_for_sale_in_last_6_months
     , staging_table.pl_property_in_borrower_trust
     , staging_table.pl_road_type
     , staging_table.pl_water_type
     , staging_table.pl_sanitation_type
     , staging_table.pl_survey_required
     , staging_table.pl_solar_panels_type
     , staging_table.pl_power_purchase_agreement
     , staging_table.pl_solar_panel_provider_name
     , staging_table.pl_seller_acquired_date
     , staging_table.pl_seller_original_cost_amount
     , staging_table.pl_remaining_economic_life_years
     , staging_table.pl_bathroom_count_unit_1
     , staging_table.pl_bathroom_count_unit_2
     , staging_table.pl_bathroom_count_unit_3
     , staging_table.pl_bathroom_count_unit_4
     , staging_table.pl_total_room_count_unit_1
     , staging_table.pl_total_room_count_unit_2
     , staging_table.pl_total_room_count_unit_3
     , staging_table.pl_total_room_count_unit_4
     , staging_table.pl_gross_living_area_square_feet_unit_1
     , staging_table.pl_gross_living_area_square_feet_unit_2
     , staging_table.pl_gross_living_area_square_feet_unit_3
     , staging_table.pl_gross_living_area_square_feet_unit_4
     , staging_table.pl_mh_leasehold__property_interest_type
     , staging_table.pl_tribe_name
     , staging_table.pl_leasehold_begin_date
     , staging_table.pl_lease_number
     , staging_table.pl_property_inspection_required
     , staging_table.pl_hvac_inspection_required
     , staging_table.pl_pest_inspection_required
     , staging_table.pl_radon_inspection_required
     , staging_table.pl_septic_inspection_required
     , staging_table.pl_water_well_inspection_required
     , staging_table.pl_structural_inspection_required
     , staging_table.pl_pest_inspection_required_auto_compute
     , staging_table.pl_management_agent_federal_tax_id
     , staging_table.pl_mh_manufacturer_street_1
     , staging_table.pl_mh_manufacturer_street_2
     , staging_table.pl_mh_manufacturer_city
     , staging_table.pl_mh_manufacturer_state
     , staging_table.pl_mh_manufacturer_postal_code
     , staging_table.pl_mh_manufacturer_phone
     , staging_table.pl_mh_manufacturer_phone_extension
     , staging_table.pl_recording_city_name
     , staging_table.pl_abbreviated_legal_description
     , staging_table.pl_geocode_service_disabled
     , staging_table.pl_vesting_confirmed
     , staging_table.pl_previous_title_manner_held_description
     , staging_table.pl_legal_lot_na
     , staging_table.pl_legal_block_na
     , staging_table.pl_legal_section_na
     , staging_table.pl_legal_description_confirmed
     , staging_table.pl_lead_inspection_required
     , staging_table.pl_calculated_lead_inspection_required
     , staging_table.pl_geocode_system_error
     , staging_table.pl_mixed_use
     , staging_table.pl_mixed_use_verified
     , staging_table.pl_mixed_use_area_square_feet
     , staging_table.pl_mixed_use_area_square_feet_verified
     , staging_table.pl_mixed_use_area_percent
     , staging_table.pl_trust_classification_type
     , staging_table.pl_additional_building_area_square_feet
     , staging_table.pl_acquisition_date_verified
     , staging_table.pl_acquisition_cost_amount_verified
     , staging_table.pl_property_tax_id_verified
     , staging_table.pl_seller_acquired_date_verified
     , staging_table.pl_seller_original_cost_amount_verified
     , staging_table.pl_snapshotted_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.place staging_table
LEFT JOIN history_octane.place history_table
          ON staging_table.pl_pid = history_table.pl_pid
              AND staging_table.pl_version = history_table.pl_version
WHERE history_table.pl_pid IS NULL
UNION ALL
SELECT history_table.pl_pid
     , history_table.pl_version + 1
     , history_table.pl_proposal_pid
     , history_table.pl_subject_property
     , history_table.pl_acquisition_date
     , history_table.pl_financed_units_count
     , history_table.pl_unit_count
     , history_table.pl_land_estimated_value_amount
     , history_table.pl_land_original_cost_amount
     , history_table.pl_leasehold_expiration_date
     , history_table.pl_legal_description_type
     , history_table.pl_legal_description
     , history_table.pl_property_tax_id
     , history_table.pl_legal_lot
     , history_table.pl_legal_block
     , history_table.pl_legal_section
     , history_table.pl_project_name
     , history_table.pl_cpm_project_id
     , history_table.pl_acquisition_cost_amount
     , history_table.pl_county_pid
     , history_table.pl_sub_jurisdiction_name
     , history_table.pl_recording_district_name
     , history_table.pl_project_classification_type
     , history_table.pl_property_category_type
     , history_table.pl_property_rights_type
     , history_table.pl_structure_built_year
     , history_table.pl_structure_built_month
     , history_table.pl_title_manner_held_type
     , history_table.pl_title_manner_held_description
     , history_table.pl_building_status_type
     , history_table.pl_construction_conversion
     , history_table.pl_native_american_lands_type
     , history_table.pl_community_land_trust
     , history_table.pl_inclusionary_zoning
     , history_table.pl_unique_dwelling_type
     , history_table.pl_living_unit_count
     , history_table.pl_project_design_type
     , history_table.pl_city
     , history_table.pl_country
     , history_table.pl_postal_code
     , history_table.pl_state
     , history_table.pl_street1
     , history_table.pl_street2
     , history_table.pl_street_tbd
     , history_table.pl_landlord_first_name
     , history_table.pl_landlord_last_name
     , history_table.pl_landlord_middle_name
     , history_table.pl_landlord_name_suffix
     , history_table.pl_landlord_company_name
     , history_table.pl_landlord_title
     , history_table.pl_landlord_office_phone
     , history_table.pl_landlord_office_phone_extension
     , history_table.pl_landlord_mobile_phone
     , history_table.pl_landlord_email
     , history_table.pl_landlord_fax
     , history_table.pl_landlord_city
     , history_table.pl_landlord_country
     , history_table.pl_landlord_postal_code
     , history_table.pl_landlord_state
     , history_table.pl_landlord_street1
     , history_table.pl_landlord_street2
     , history_table.pl_management_first_name
     , history_table.pl_management_last_name
     , history_table.pl_management_middle_name
     , history_table.pl_management_name_suffix
     , history_table.pl_management_company_name
     , history_table.pl_management_title
     , history_table.pl_management_office_phone
     , history_table.pl_management_office_phone_extension
     , history_table.pl_management_mobile_phone
     , history_table.pl_management_email
     , history_table.pl_management_fax
     , history_table.pl_management_city
     , history_table.pl_management_country
     , history_table.pl_management_postal_code
     , history_table.pl_management_state
     , history_table.pl_management_street1
     , history_table.pl_management_street2
     , history_table.pl_property_insurance_amount_input_type
     , history_table.pl_property_tax_amount_input_type
     , history_table.pl_annual_property_insurance_amount
     , history_table.pl_annual_property_tax_amount
     , history_table.pl_monthly_property_insurance_amount
     , history_table.pl_monthly_hoa_amount
     , history_table.pl_monthly_mi_amount
     , history_table.pl_monthly_property_tax_amount
     , history_table.pl_monthly_lease_ground_rent_amount
     , history_table.pl_monthly_rent_amount
     , history_table.pl_monthly_obligation_amount
     , history_table.pl_use_proposed_property_usage
     , history_table.pl_property_usage_type
     , history_table.pl_property_value_amount
     , history_table.pl_reo_disposition_status_type
     , history_table.pl_auto_geocode
     , history_table.pl_auto_geocode_exception
     , history_table.pl_msa_code
     , history_table.pl_state_fips
     , history_table.pl_county_fips
     , history_table.pl_census_tract
     , history_table.pl_mh_make
     , history_table.pl_mh_model
     , history_table.pl_mh_length
     , history_table.pl_mh_width
     , history_table.pl_mh_manufacturer
     , history_table.pl_mh_serial_number
     , history_table.pl_mh_hud_label_number
     , history_table.pl_mh_certificate_of_title_issued
     , history_table.pl_mh_certificate_of_title_number
     , history_table.pl_mh_certificate_of_title_type
     , history_table.pl_mh_loan_purpose_type
     , history_table.pl_mh_anchored
     , history_table.pl_coop_company_name
     , history_table.pl_coop_building_name
     , history_table.pl_coop_vacant_units
     , history_table.pl_coop_proprietary_lease_date
     , history_table.pl_coop_assignment_lease_date
     , history_table.pl_coop_existing_company_laws_state
     , history_table.pl_coop_shares_being_purchased
     , history_table.pl_coop_attorney_in_fact
     , history_table.pl_coop_stock_certificate_number
     , history_table.pl_coop_apartment_unit
     , history_table.pl_rental
     , history_table.pl_underwriter_comments
     , history_table.pl_lava_zone_type
     , history_table.pl_neighborhood_location_type
     , history_table.pl_site_area
     , history_table.pl_hud_reo
     , history_table.pl_va_guaranteed_reo
     , history_table.pl_va_loan_date
     , history_table.pl_gross_building_area_square_feet
     , history_table.pl_project_dwelling_units_sold_count
     , history_table.pl_prior_owners_title
     , history_table.pl_prior_owners_title_policy_amount
     , history_table.pl_prior_owners_title_policy_effective_date
     , history_table.pl_prior_lenders_title
     , history_table.pl_prior_lenders_title_policy_amount
     , history_table.pl_prior_lenders_title_policy_effective_date
     , history_table.pl_bedroom_count_unit_1
     , history_table.pl_bedroom_count_unit_2
     , history_table.pl_bedroom_count_unit_3
     , history_table.pl_bedroom_count_unit_4
     , history_table.pl_rent_amount_unit_1
     , history_table.pl_rent_amount_unit_2
     , history_table.pl_rent_amount_unit_3
     , history_table.pl_rent_amount_unit_4
     , history_table.pl_listed_for_sale_in_last_6_months
     , history_table.pl_property_in_borrower_trust
     , history_table.pl_road_type
     , history_table.pl_water_type
     , history_table.pl_sanitation_type
     , history_table.pl_survey_required
     , history_table.pl_solar_panels_type
     , history_table.pl_power_purchase_agreement
     , history_table.pl_solar_panel_provider_name
     , history_table.pl_seller_acquired_date
     , history_table.pl_seller_original_cost_amount
     , history_table.pl_remaining_economic_life_years
     , history_table.pl_bathroom_count_unit_1
     , history_table.pl_bathroom_count_unit_2
     , history_table.pl_bathroom_count_unit_3
     , history_table.pl_bathroom_count_unit_4
     , history_table.pl_total_room_count_unit_1
     , history_table.pl_total_room_count_unit_2
     , history_table.pl_total_room_count_unit_3
     , history_table.pl_total_room_count_unit_4
     , history_table.pl_gross_living_area_square_feet_unit_1
     , history_table.pl_gross_living_area_square_feet_unit_2
     , history_table.pl_gross_living_area_square_feet_unit_3
     , history_table.pl_gross_living_area_square_feet_unit_4
     , history_table.pl_mh_leasehold__property_interest_type
     , history_table.pl_tribe_name
     , history_table.pl_leasehold_begin_date
     , history_table.pl_lease_number
     , history_table.pl_property_inspection_required
     , history_table.pl_hvac_inspection_required
     , history_table.pl_pest_inspection_required
     , history_table.pl_radon_inspection_required
     , history_table.pl_septic_inspection_required
     , history_table.pl_water_well_inspection_required
     , history_table.pl_structural_inspection_required
     , history_table.pl_pest_inspection_required_auto_compute
     , history_table.pl_management_agent_federal_tax_id
     , history_table.pl_mh_manufacturer_street_1
     , history_table.pl_mh_manufacturer_street_2
     , history_table.pl_mh_manufacturer_city
     , history_table.pl_mh_manufacturer_state
     , history_table.pl_mh_manufacturer_postal_code
     , history_table.pl_mh_manufacturer_phone
     , history_table.pl_mh_manufacturer_phone_extension
     , history_table.pl_recording_city_name
     , history_table.pl_abbreviated_legal_description
     , history_table.pl_geocode_service_disabled
     , history_table.pl_vesting_confirmed
     , history_table.pl_previous_title_manner_held_description
     , history_table.pl_legal_lot_na
     , history_table.pl_legal_block_na
     , history_table.pl_legal_section_na
     , history_table.pl_legal_description_confirmed
     , history_table.pl_lead_inspection_required
     , history_table.pl_calculated_lead_inspection_required
     , history_table.pl_geocode_system_error
     , history_table.pl_mixed_use
     , history_table.pl_mixed_use_verified
     , history_table.pl_mixed_use_area_square_feet
     , history_table.pl_mixed_use_area_square_feet_verified
     , history_table.pl_mixed_use_area_percent
     , history_table.pl_trust_classification_type
     , history_table.pl_additional_building_area_square_feet
     , history_table.pl_acquisition_date_verified
     , history_table.pl_acquisition_cost_amount_verified
     , history_table.pl_property_tax_id_verified
     , history_table.pl_seller_acquired_date_verified
     , history_table.pl_seller_original_cost_amount_verified
     , history_table.pl_snapshotted_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.place history_table
LEFT JOIN staging_octane.place staging_table
          ON staging_table.pl_pid = history_table.pl_pid
WHERE staging_table.pl_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.place deleted_records
    WHERE deleted_records.pl_pid = history_table.pl_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100213', 0, '--finding records to insert into history_octane.smart_ledger_plan_case_version
SELECT staging_table.slpcv_pid
     , staging_table.slpcv_version
     , staging_table.slpcv_account_pid
     , staging_table.slpcv_smart_ledger_plan_case_pid
     , staging_table.slpcv_payer_org_node_pid
     , staging_table.slpcv_active
     , staging_table.slpcv_synthetic_unique
     , staging_table.slpcv_case_name
     , staging_table.slpcv_smart_ledger_plan_case_type
     , staging_table.slpcv_smart_ledger_plan_case_level_type
     , staging_table.slpcv_smart_ledger_pay_frequency_type
     , staging_table.slpcv_from_date
     , staging_table.slpcv_through_date
     , staging_table.slpcv_base_amount
     , staging_table.slpcv_basis_points
     , staging_table.slpcv_min_amount
     , staging_table.slpcv_max_amount
     , staging_table.slpcv_ledger_basis_points_input_type
     , staging_table.slpcv_criteria_pid
     , staging_table.slpcv_last_modified_by
     , staging_table.slpcv_last_modified_datetime
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.smart_ledger_plan_case_version staging_table
LEFT JOIN history_octane.smart_ledger_plan_case_version history_table
          ON staging_table.slpcv_pid = history_table.slpcv_pid
              AND staging_table.slpcv_version = history_table.slpcv_version
WHERE history_table.slpcv_pid IS NULL
UNION ALL
SELECT history_table.slpcv_pid
     , history_table.slpcv_version + 1
     , history_table.slpcv_account_pid
     , history_table.slpcv_smart_ledger_plan_case_pid
     , history_table.slpcv_payer_org_node_pid
     , history_table.slpcv_active
     , history_table.slpcv_synthetic_unique
     , history_table.slpcv_case_name
     , history_table.slpcv_smart_ledger_plan_case_type
     , history_table.slpcv_smart_ledger_plan_case_level_type
     , history_table.slpcv_smart_ledger_pay_frequency_type
     , history_table.slpcv_from_date
     , history_table.slpcv_through_date
     , history_table.slpcv_base_amount
     , history_table.slpcv_basis_points
     , history_table.slpcv_min_amount
     , history_table.slpcv_max_amount
     , history_table.slpcv_ledger_basis_points_input_type
     , history_table.slpcv_criteria_pid
     , history_table.slpcv_last_modified_by
     , history_table.slpcv_last_modified_datetime
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.smart_ledger_plan_case_version history_table
LEFT JOIN staging_octane.smart_ledger_plan_case_version staging_table
          ON staging_table.slpcv_pid = history_table.slpcv_pid
WHERE staging_table.slpcv_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.smart_ledger_plan_case_version deleted_records
    WHERE deleted_records.slpcv_pid = history_table.slpcv_pid
      AND deleted_records.data_source_deleted_flag = TRUE
    );', 'Staging DB Connection')
         , ('SP-100071', 0, '--finding records to insert into history_octane.asset_large_deposit
SELECT staging_table.ald_pid
     , staging_table.ald_version
     , staging_table.ald_asset_pid
     , staging_table.ald_deposit_amount
     , staging_table.ald_deposit_date
     , staging_table.ald_snapshotted_pid
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.asset_large_deposit staging_table
LEFT JOIN history_octane.asset_large_deposit history_table
          ON staging_table.ald_pid = history_table.ald_pid
              AND staging_table.ald_version = history_table.ald_version
WHERE history_table.ald_pid IS NULL
UNION ALL
SELECT history_table.ald_pid
     , history_table.ald_version + 1
     , history_table.ald_asset_pid
     , history_table.ald_deposit_amount
     , history_table.ald_deposit_date
     , history_table.ald_snapshotted_pid
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.asset_large_deposit history_table
LEFT JOIN staging_octane.asset_large_deposit staging_table
          ON staging_table.ald_pid = history_table.ald_pid
WHERE staging_table.ald_pid IS NULL
  AND NOT EXISTS(
    SELECT 1
    FROM history_octane.asset_large_deposit deleted_records
    WHERE deleted_records.ald_pid = history_table.ald_pid
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
