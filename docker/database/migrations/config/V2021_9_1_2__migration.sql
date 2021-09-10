--
-- Main | EDW - Octane schemas from prod-release to v2021.9.2.0 on uat
-- https://app.asana.com/0/0/1200944665668886
--

-- Insert metadata for new tables: lender_concession_item, lender_concession_request_number_ticker
WITH new_staging_table_definitions AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'lender_concession_item', NULL)
            , ('staging', 'staging_octane', 'lender_concession_request_number_ticker', NULL)
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
    VALUES ('staging_octane', 'lender_concession_item', 'lci_pid', TRUE, NULL)
        , ('staging_octane', 'lender_concession_item', 'lci_version', FALSE, NULL)
        , ('staging_octane', 'lender_concession_item', 'lci_lender_concession_request_pid', FALSE, NULL)
        , ('staging_octane', 'lender_concession_item', 'lci_loan_charge_pid', FALSE, NULL)
        , ('staging_octane', 'lender_concession_item', 'lci_allocation_amount', FALSE, NULL)
        , ('staging_octane', 'lender_concession_item', 'lci_absorb_cost', FALSE, NULL)
        , ('history_octane', 'lender_concession_item', 'lci_pid', TRUE, 1)
        , ('history_octane', 'lender_concession_item', 'lci_version', FALSE, 2)
        , ('history_octane', 'lender_concession_item', 'lci_lender_concession_request_pid', FALSE, 3)
        , ('history_octane', 'lender_concession_item', 'lci_loan_charge_pid', FALSE, 4)
        , ('history_octane', 'lender_concession_item', 'lci_allocation_amount', FALSE, 5)
        , ('history_octane', 'lender_concession_item', 'lci_absorb_cost', FALSE, 6)
        , ('history_octane', 'lender_concession_item', 'data_source_updated_datetime', FALSE, 7)
        , ('history_octane', 'lender_concession_item', 'data_source_deleted_flag', FALSE, 8)
        , ('staging_octane', 'lender_concession_request_number_ticker', 'lcrnt_pid', TRUE, NULL)
        , ('staging_octane', 'lender_concession_request_number_ticker', 'lcrnt_version', FALSE, NULL)
        , ('staging_octane', 'lender_concession_request_number_ticker', 'lcrnt_proposal_pid', FALSE, NULL)
        , ('staging_octane', 'lender_concession_request_number_ticker',
        'lcrnt_next_lender_concession_request_number', FALSE, NULL)
        , ('history_octane', 'lender_concession_request_number_ticker', 'lcrnt_pid', TRUE, 1)
        , ('history_octane', 'lender_concession_request_number_ticker', 'lcrnt_version', FALSE, 2)
        , ('history_octane', 'lender_concession_request_number_ticker', 'lcrnt_proposal_pid', FALSE, 3)
        , ('history_octane', 'lender_concession_request_number_ticker',
        'lcrnt_next_lender_concession_request_number', FALSE, 4)
        , ('history_octane', 'lender_concession_request_number_ticker', 'data_source_updated_datetime', FALSE, 5)
        , ('history_octane', 'lender_concession_request_number_ticker', 'data_source_deleted_flag', FALSE, 6)
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
            LEFT JOIN new_staging_field_definitions ON new_staging_table_definitions.dwid = new_staging_field_definitions.edw_table_definition_dwid
                AND new_fields.field_name = new_staging_field_definitions.field_name
        WHERE new_fields.schema_name = 'history_octane'
)

, new_process_variables (name, target_table, json_output_field, sql) AS (
    VALUES ('SP-100844', 'lender_concession_item', 'lci_pid', '--finding records to insert into history_octane.lender_concession_item
            SELECT staging_table.lci_pid
            ,  staging_table.lci_version
            ,  staging_table.lci_lender_concession_request_pid
            ,  staging_table.lci_loan_charge_pid
            ,  staging_table.lci_allocation_amount
            ,  staging_table.lci_absorb_cost
            ,  FALSE AS data_source_deleted_flag
            ,  NOW( ) AS data_source_updated_datetime
            FROM staging_octane.lender_concession_item staging_table
            LEFT JOIN history_octane.lender_concession_item history_table
                      ON staging_table.lci_pid = history_table.lci_pid AND staging_table.lci_version = history_table.lci_version
            WHERE history_table.lci_pid IS NULL
            UNION ALL
            SELECT history_table.lci_pid
            ,  history_table.lci_version + 1
            ,  history_table.lci_lender_concession_request_pid
            ,  history_table.lci_loan_charge_pid
            ,  history_table.lci_allocation_amount
            ,  history_table.lci_absorb_cost
            ,  TRUE AS data_source_deleted_flag
            ,  NOW( ) AS data_source_updated_datetime
            FROM history_octane.lender_concession_item history_table
            LEFT JOIN staging_octane.lender_concession_item staging_table
                      ON staging_table.lci_pid = history_table.lci_pid
            WHERE staging_table.lci_pid IS NULL
              AND NOT EXISTS( SELECT 1
                              FROM history_octane.lender_concession_item deleted_records
                              WHERE deleted_records.lci_pid = history_table.lci_pid AND deleted_records.data_source_deleted_flag = TRUE );')
    , ('SP-100845', 'lender_concession_request_number_ticker', 'lcrnt_pid', '--finding records to insert into history_octane.lender_concession_request_number_ticker
            SELECT staging_table.lcrnt_pid
            ,  staging_table.lcrnt_version
            , staging_table.lcrnt_proposal_pid
            , staging_table.lcrnt_next_lender_concession_request_number
            ,  FALSE AS data_source_deleted_flag
            ,  NOW( ) AS data_source_updated_datetime
            FROM staging_octane.lender_concession_request_number_ticker staging_table
            LEFT JOIN history_octane.lender_concession_request_number_ticker history_table
                      ON staging_table.lcrnt_pid = history_table.lcrnt_pid AND staging_table.lcrnt_version = history_table.lcrnt_version
            WHERE history_table.lcrnt_pid IS NULL
            UNION ALL
            SELECT history_table.lcrnt_pid
            ,  history_table.lcrnt_version + 1
            , history_table.lcrnt_proposal_pid
            , history_table.lcrnt_next_lender_concession_request_number
            ,  TRUE AS data_source_deleted_flag
            ,  NOW( ) AS data_source_updated_datetime
            FROM history_octane.lender_concession_request_number_ticker history_table
            LEFT JOIN staging_octane.lender_concession_request_number_ticker staging_table
                      ON staging_table.lcrnt_pid = history_table.lcrnt_pid
            WHERE staging_table.lcrnt_pid IS NULL
              AND NOT EXISTS( SELECT 1
                              FROM history_octane.lender_concession_request_number_ticker deleted_records
                              WHERE deleted_records.lcrnt_pid = history_table.lcrnt_pid AND deleted_records.data_source_deleted_flag = TRUE );')
)

, new_processes AS (
    INSERT INTO mdi.process (name, description)
        SELECT new_process_variables.name
            , 'ETL to copy ' || new_process_variables.target_table || ' data from staging_octane to history_octane'
        FROM new_process_variables
        RETURNING dwid, name, description
)

, new_table_input_steps AS (
    INSERT INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row,
                                      replace_variables, enable_lazy_conversion, cached_row_meta, connectionname)
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
    INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field,
                                       table_name_field, auto_generated_key_field, partition_data_per,
                                       table_name_defined_in_field, return_auto_generated_key_field, truncate_table,
                                       connectionname, partition_over_tables, specify_database_fields,
                                       ignore_insert_errors, use_batch_update)
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
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name,
                                        field_order, is_sensitive)
        SELECT new_table_output_steps.dwid
            , new_fields.field_name
            , new_fields.field_name
            , new_fields.field_order
            , FALSE
        FROM new_table_output_steps
            JOIN new_fields ON new_table_output_steps.target_schema = new_fields.schema_name
                AND new_table_output_steps.target_table = new_fields.table_name
)

, new_json_output_fields AS (
    INSERT INTO mdi.json_output_field (process_dwid, field_name)
        SELECT new_processes.dwid
            , new_process_variables.json_output_field
        FROM new_processes
            JOIN new_process_variables ON new_processes.name = new_process_variables.name
)

, new_state_machine_definitions AS (
    INSERT INTO mdi.state_machine_definition (process_dwid, name, comment)
        SELECT new_processes.dwid
            , new_processes.name
            , new_processes.description
        FROM new_processes
)

SELECT 'Finished inserting metadata for new tables: lender_concession_item, lender_concession_request_number_ticker';
