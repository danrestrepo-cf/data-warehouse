--
-- EDW | DML changes - Octane Schema changes for 2021.7.2.0 (7/9/21)
-- https://app.asana.com/0/0/1200568462822754
--

-- Insert edw_table_definition rows for mortgage_delinquency_exception_type
WITH staging_table AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'mortgage_delinquency_exception_type', NULL)
        RETURNING dwid
)
INSERT
INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
SELECT 'staging', 'history_octane', 'mortgage_delinquency_exception_type', staging_table.dwid
FROM staging_table;

-- Insert edw_field_definition and mdi configuration rows for new columns and tables
WITH new_staging_and_history_columns (table_name, field_name, key_field_flag, field_order) AS (
    VALUES ('liability_place', 'lip_mortgage_delinquency_exception_type', FALSE, 21)
         , ('mortgage_delinquency_exception_type', 'code', TRUE, 1)
         , ('mortgage_delinquency_exception_type', 'value', FALSE, 2)
)
   , new_history_only_columns (table_name, field_name, key_field_flag, field_order) AS (
    VALUES ('mortgage_delinquency_exception_type', 'data_source_updated_datetime', FALSE, 3)
         , ('mortgage_delinquency_exception_type', 'data_source_deleted_flag', FALSE, 4)
)
   , all_new_columns (table_name, field_name, key_field_flag, field_order) AS (
    SELECT *
    FROM new_staging_and_history_columns
    UNION ALL
    SELECT *
    FROM new_history_only_columns
)
   , insert_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT edw_table_definition.dwid, new_staging_and_history_columns.field_name, new_staging_and_history_columns.key_field_flag
        FROM new_staging_and_history_columns
        JOIN mdi.edw_table_definition
             ON new_staging_and_history_columns.table_name = edw_table_definition.table_name
                 AND edw_table_definition.schema_name = 'staging_octane'
        RETURNING dwid, field_name
)
   , insert_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid,
                                          field_name,
                                          key_field_flag,
                                          source_edw_field_definition_dwid)
        SELECT edw_table_definition.dwid
             , all_new_columns.field_name
             , all_new_columns.key_field_flag
             , insert_staging_field_definitions.dwid
        FROM all_new_columns
        LEFT JOIN insert_staging_field_definitions
                  ON all_new_columns.field_name = insert_staging_field_definitions.field_name
        JOIN mdi.edw_table_definition
             ON all_new_columns.table_name = edw_table_definition.table_name
                 AND edw_table_definition.schema_name = 'history_octane'
)
   , new_tables (process_name, table_name, json_output_field, sql) AS (
-- mortgage_delinquency_exception_type
    VALUES ('SP-100833', 'mortgage_delinquency_exception_type', 'code', 'SELECT staging_table.code, staging_table.value, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.mortgage_delinquency_exception_type staging_table
LEFT JOIN history_octane.mortgage_delinquency_exception_type history_table on staging_table.code = history_table.code AND staging_table.value = history_table.value
WHERE history_table.code is NULL;')
)
   , updated_tables (process_name, table_name, sql) AS (
--liability place
    VALUES ('SP-100823', 'liability_place', '--finding records to insert into history_octane.liability_place
SELECT staging_table.lip_pid
     , staging_table.lip_version
     , staging_table.lip_liability_pid
     , staging_table.lip_creditor_pid
     , staging_table.lip_place_pid
     , staging_table.lip_lien_priority_type
     , staging_table.lip_liability_financing_type
     , staging_table.lip_liability_foreclosure_exception_type
     , staging_table.lip_liability_mi_type
     , staging_table.lip_original_loan_amount
     , staging_table.lip_property_taxes_escrowed
     , staging_table.lip_property_insurance_escrowed
     , staging_table.lip_senior_lien_restriction_type
     , staging_table.lip_senior_lien_restriction_amount
     , staging_table.lip_texas_equity
     , staging_table.lip_texas_equity_conversion
     , staging_table.lip_texas_equity_locked
     , staging_table.lip_third_party_community_second_program_pid
     , staging_table.lip_mortgage_delinquency_exception_type
     , FALSE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM staging_octane.liability_place staging_table
LEFT JOIN history_octane.liability_place history_table
          ON staging_table.lip_pid = history_table.lip_pid AND staging_table.lip_version = history_table.lip_version
WHERE history_table.lip_pid IS NULL
UNION ALL
SELECT history_table.lip_pid
     , history_table.lip_version + 1
     , history_table.lip_liability_pid
     , history_table.lip_creditor_pid
     , history_table.lip_place_pid
     , history_table.lip_lien_priority_type
     , history_table.lip_liability_financing_type
     , history_table.lip_liability_foreclosure_exception_type
     , history_table.lip_liability_mi_type
     , history_table.lip_original_loan_amount
     , history_table.lip_property_taxes_escrowed
     , history_table.lip_property_insurance_escrowed
     , history_table.lip_senior_lien_restriction_type
     , history_table.lip_senior_lien_restriction_amount
     , history_table.lip_texas_equity
     , history_table.lip_texas_equity_conversion
     , history_table.lip_texas_equity_locked
     , history_table.lip_third_party_community_second_program_pid
     , history_table.lip_mortgage_delinquency_exception_type
     , TRUE AS data_source_deleted_flag
     , NOW( ) AS data_source_updated_datetime
FROM history_octane.liability_place history_table
LEFT JOIN staging_octane.liability_place staging_table
          ON staging_table.lip_pid = history_table.lip_pid
WHERE staging_table.lip_pid IS NULL
  AND NOT EXISTS( SELECT 1
                  FROM history_octane.liability_place deleted_records
                  WHERE deleted_records.lip_pid = history_table.lip_pid
                    AND deleted_records.data_source_deleted_flag = TRUE );')
)
   , new_table_processes AS (
    INSERT
        INTO mdi.process (name, description)
            SELECT process_name, 'ETL to copy ' || table_name || ' data from staging_octane to history_octane'
            FROM new_tables
            RETURNING dwid, name AS process_name
)
   , new_table_input_steps AS (
    INSERT
        INTO mdi.table_input_step (process_dwid, data_source_dwid, sql, limit_size, execute_for_each_row, replace_variables,
                                   enable_lazy_conversion, cached_row_meta, connectionname)
            SELECT new_table_processes.dwid
                 , 0
                 , new_tables.sql
                 , 0
                 , 'N'
                 , 'N'
                 , 'N'
                 , 'N'
                 , 'Staging DB Connection'
            FROM new_tables
            JOIN new_table_processes
                 ON new_tables.process_name = new_table_processes.process_name
)
   , updated_table_input_steps AS (
    UPDATE mdi.table_input_step
        SET sql = updated_tables.sql
        FROM updated_tables
            JOIN mdi.process
            ON process.name = updated_tables.process_name
        WHERE table_input_step.process_dwid = process.dwid
)
   , new_table_output_steps AS (
    INSERT
        INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field,
                                    auto_generated_key_field, partition_data_per, table_name_defined_in_field,
                                    return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables,
                                    specify_database_fields, ignore_insert_errors, use_batch_update)
            SELECT new_table_processes.dwid
                 , 'history_octane'
                 , new_tables.table_name
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
            FROM new_tables
            JOIN new_table_processes
                 ON new_tables.process_name = new_table_processes.process_name
            RETURNING dwid, target_table
)
   , new_table_output_fields AS (
    INSERT
        INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
            SELECT table_output_step.dwid
                 , all_new_columns.field_name
                 , all_new_columns.field_name
                 , all_new_columns.field_order
                 , FALSE
            FROM all_new_columns
            JOIN (
                SELECT dwid, target_table
                FROM mdi.table_output_step
                JOIN all_new_columns
                     ON all_new_columns.table_name = table_output_step.target_table
                         AND table_output_step.target_schema = 'history_octane'
                UNION ALL
                SELECT dwid, target_table
                FROM new_table_output_steps
            ) AS table_output_step
                 ON table_output_step.target_table = all_new_columns.table_name
)
   , new_state_machine_definitions AS (
    INSERT
        INTO mdi.state_machine_definition (process_dwid, name, comment)
            SELECT new_table_processes.dwid
                 , 'Octane__' || new_tables.table_name
                 , 'ETL to copy ' || new_tables.table_name || ' data from staging_octane to history_octane'
            FROM new_tables
            JOIN new_table_processes
                 ON new_tables.process_name = new_table_processes.process_name
)
   , new_json_output_steps AS (
    INSERT
        INTO mdi.json_output_field (process_dwid, field_name)
            SELECT new_table_processes.dwid, new_tables.json_output_field
            FROM new_tables
            JOIN new_table_processes
                 ON new_tables.process_name = new_table_processes.process_name
)
SELECT 'Finished loading new Octane catch up metadata';
