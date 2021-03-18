--
-- EDW - Add test cases to EDW unit test runner script: https://app.asana.com/0/0/1199980645336559
--

-- add SP-0.5 config
DO $$
    DECLARE sp_process_dwid BIGINT;
    DECLARE sp_table_input_step_dwid BIGINT;
    DECLARE sp_table_output_step_dwid BIGINT;

    BEGIN
        sp_process_dwid = (SELECT nextval('mdi."process_dwid_seq"'));
        sp_table_input_step_dwid = (SELECT nextval('mdi."table_input_step_dwid_seq"'));
        sp_table_output_step_dwid = (SELECT nextval('mdi."table_output_step_dwid_seq"'));

        -- Process records for SP-0.5
        INSERT INTO mdi.process (dwid, name, description)
        VALUES (sp_process_dwid, 'SP-0.5', 'Test data_source_dwid via Table Input -> Table Output');

        -- Table input step records for SP-0.5
        INSERT INTO mdi.table_input_step (dwid, process_dwid, data_source_dwid, sql, limit_size, connectionname)
        VALUES (sp_table_input_step_dwid
               , sp_process_dwid
               , 0
               , 'SELECT tool_pid
                    , tool_code
                    , tool_type
                    , tool_price
                    , tool_inventory_start_date
                    , tool_inventory_end_date
                    , data_source_dwid as data_source_value
                FROM test.unit_test_tools_source;'
               , 0
               , 'Ingress DB Connection');

        -- Table output step record for SP-0.5
        INSERT INTO mdi.table_output_step (dwid, process_dwid, target_schema, target_table, commit_size,
                                           table_name_defined_in_field, truncate_table, connectionname,
                                           partition_over_tables, specify_database_fields, ignore_insert_errors,
                                           use_batch_update)
        VALUES (sp_table_output_step_dwid, sp_process_dwid, 'test', 'unit_test_tools_target', 1000, 'N', 'N', 'Ingress DB Connection', 'N', 'Y', 'N', 'N');

        -- Table output field records for SP-0.5
        INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
        VALUES (sp_table_output_step_dwid, 'tool_pid', 'tool_pid', 1, FALSE)
             ,      (sp_table_output_step_dwid, 'tool_code', 'tool_code', 2, FALSE)
             ,      (sp_table_output_step_dwid, 'tool_type', 'tool_type', 3, FALSE)
             ,      (sp_table_output_step_dwid, 'tool_price', 'tool_price', 4, FALSE)
             ,      (sp_table_output_step_dwid, 'tool_inventory_start_date', 'tool_inventory_start_date', 5, FALSE)
             ,      (sp_table_output_step_dwid, 'tool_inventory_end_date', 'tool_inventory_end_date', 6, FALSE)
             ,      (sp_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid_value', 7, FALSE)
             ,      (sp_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', 8, FALSE);

END $$;


-- add SP-0.6 config
DO $$
        DECLARE sp_process_dwid BIGINT;
        DECLARE sp_table_input_step_dwid BIGINT;
        DECLARE sp_insert_update_step_dwid BIGINT;

    BEGIN
        sp_process_dwid = (SELECT nextval('mdi."process_dwid_seq"'));
        sp_table_input_step_dwid = (SELECT nextval('mdi."table_input_step_dwid_seq"'));
        sp_insert_update_step_dwid = (SELECT nextval('mdi."insert_update_step_dwid_seq"'));

        -- Process records for SP-0.3 and SP-0.6
        INSERT INTO mdi.process (dwid, name, description)
        VALUES (sp_process_dwid, 'SP-0.6', 'Test data_source_dwid via Table Input -> Table Insert / Update');


        -- Table input step records for SP-0.3 and SP-0.6
        INSERT INTO mdi.table_input_step (dwid, process_dwid, data_source_dwid, sql, limit_size, connectionname)
        VALUES (sp_table_input_step_dwid
               , sp_process_dwid
               , 0
               , 'SELECT tool_pid
                   , tool_code
                   , tool_type
                   , tool_price
                   , tool_inventory_start_date
                   , tool_inventory_end_date
                   , data_source_dwid as data_source_value
               FROM test.unit_test_tools_source;'
               , 0
               , 'Ingress DB Connection');

        -- Insert / Update step record for SP-0.6
        INSERT INTO mdi.insert_update_step (dwid, process_dwid, connectionname, schema_name, table_name, commit_size,
                                            do_not)
        VALUES (sp_insert_update_step_dwid, sp_process_dwid, 'Ingress DB Connection', 'test',
                'unit_test_tools_target', 1000, 'N');

        -- Insert / Update key record for SP-0.6
        INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_stream2, key_condition)
        VALUES (sp_insert_update_step_dwid, 'tool_pid', 'tool_pid', NULL, '=');

        -- Insert / Update records for SP-0.6
        INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)
        VALUES (sp_insert_update_step_dwid, 'tool_pid', 'tool_pid', 'N', FALSE)
             ,      (sp_insert_update_step_dwid, 'tool_code', 'tool_code', 'Y', FALSE)
             ,      (sp_insert_update_step_dwid, 'tool_type', 'tool_type', 'Y', FALSE)
             ,      (sp_insert_update_step_dwid, 'tool_price', 'tool_price', 'Y', FALSE)
             ,      (sp_insert_update_step_dwid, 'tool_inventory_start_date', 'tool_inventory_start_date', 'Y', FALSE)
             ,      (sp_insert_update_step_dwid, 'tool_inventory_end_date', 'tool_inventory_end_date', 'Y', FALSE)
             ,      (sp_insert_update_step_dwid, 'data_source_dwid', 'data_source_dwid_value', 'Y', FALSE)
             ,      (sp_insert_update_step_dwid, 'etl_batch_id', 'etl_batch_id', 'Y', FALSE);
END $$;
