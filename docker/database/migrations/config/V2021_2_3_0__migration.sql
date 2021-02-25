-------------------------------------------------------------------------------
--  NAME
--      Add MDI Config tables for Pentaho Insert / update step support
--
--  ASANA
--      https://app.asana.com/0/0/1199565206309934
--
--  DESCRIPTION/PURPOSE
--      This script adds the config tables that are needed to support MDI into
--      Pentaho's Insert / update step
--
-- PROGRAMMING NOTES
--     None
--
-------------------------------------------------------------------------------

CREATE TABLE mdi.insert_update_step (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_insert_update_step
            PRIMARY KEY
    , process_dwid BIGINT NOT NULL
        CONSTRAINT fk_insert_update_step_1
            REFERENCES mdi.process
            ON UPDATE RESTRICT
            ON DELETE RESTRICT
            DEFERRABLE INITIALLY DEFERRED
    , connectionname TEXT NOT NULL
    , schema_name TEXT NOT NULL
    , table_name TEXT NOT NULL
    , commit_size INTEGER NOT NULL
    , do_not mdi.PENTAHO_Y_OR_N NOT NULL
);

CREATE TABLE mdi.insert_update_key (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_insert_update_key
            PRIMARY KEY
    , insert_update_step_dwid BIGINT NOT NULL
        CONSTRAINT fk_insert_update_key_1
            REFERENCES mdi.insert_update_step
            ON UPDATE RESTRICT
            ON DELETE RESTRICT
            DEFERRABLE INITIALLY DEFERRED
    , key_lookup TEXT NOT NULL
    , key_stream1 TEXT NOT NULL
    , key_stream2 TEXT NOT NULL
    , key_condition TEXT NOT NULL
);

CREATE TABLE mdi.insert_update_field (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_insert_update_field
            PRIMARY KEY
    , insert_update_step_dwid BIGINT NOT NULL
        CONSTRAINT fk_insert_update_field_1
            REFERENCES mdi.insert_update_step
            ON UPDATE RESTRICT
            ON DELETE RESTRICT
            DEFERRABLE INITIALLY DEFERRED
    , update_lookup TEXT NOT NULL
    , update_stream TEXT NOT NULL
    , update_flag mdi.PENTAHO_Y_OR_N NOT NULL
    , is_sensitive BOOLEAN NOT NULL
);

DO $$
    DECLARE sp_0_3_process_dwid BIGINT;
    DECLARE sp_0_4_process_dwid BIGINT;

    DECLARE sp_0_3_table_input_step_dwid BIGINT;
    DECLARE sp_0_4_table_input_step_dwid BIGINT;
    DECLARE sp_0_3_table_output_step_dwid BIGINT;
    DECLARE sp_0_4_insert_update_step_dwid BIGINT;

    BEGIN
        sp_0_3_process_dwid = (SELECT nextval('mdi."process_dwid_seq"'));
        sp_0_4_process_dwid = (SELECT nextval('mdi."process_dwid_seq"'));

        sp_0_3_table_input_step_dwid = (SELECT nextval('mdi."table_input_step_dwid_seq"'));
        sp_0_4_table_input_step_dwid = (SELECT nextval('mdi."table_input_step_dwid_seq"'));
        sp_0_3_table_output_step_dwid = (SELECT nextval('mdi."table_output_step_dwid_seq"'));
        sp_0_4_insert_update_step_dwid = (SELECT nextval('mdi."insert_update_step_dwid_seq"'));

        -- Process records for SP-0.3 and SP-0.4
        INSERT INTO mdi.process (dwid, name, description)
        VALUES (sp_0_3_process_dwid, 'SP-0.3', 'Test Table Input -> Table Output')
        ,      (sp_0_4_process_dwid, 'SP-0.4', 'Test Table Input -> Table Insert / Update');


        -- Table input step records for SP-0.3 and SP-0.4
        INSERT INTO mdi.table_input_step (dwid, process_dwid, data_source_dwid, sql, limit_size, connectionname)
        VALUES (sp_0_3_table_input_step_dwid
            , sp_0_3_process_dwid
            , 3
            , 'SELECT tool_pid
                    , tool_code
                    , tool_type
                    , tool_price
                    , tool_inventory_start_date
                    , tool_inventory_end_date
                FROM test.unit_test_tools_source;'
            , 0
            , 'Ingress DB Connection')
        , (sp_0_4_table_input_step_dwid
            , sp_0_4_process_dwid
            , 3
            , 'SELECT tool_pid
                   , tool_code
                   , tool_type
                   , tool_price
                   , tool_inventory_start_date
                   , tool_inventory_end_date
               FROM test.unit_test_tools_source;'
            , 0
            , 'Ingress DB Connection');

        -- Table output step record for SP-0.3
        INSERT INTO mdi.table_output_step (dwid, process_dwid, target_schema, target_table, commit_size,
                                           table_name_defined_in_field, truncate_table, connectionname,
                                           partition_over_tables, specify_database_fields, ignore_insert_errors,
                                           use_batch_update)
        VALUES (sp_0_3_table_output_step_dwid, sp_0_3_process_dwid, 'test', 'unit_test_tools_target', 1000, 'N', 'N',
                'Ingress DB Connection', 'N', 'Y', 'N', 'N');

        -- Table output field records for SP-0.3
        INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
        VALUES (sp_0_3_table_output_step_dwid, 'tool_pid', 'tool_pid', 1, FALSE)
        ,      (sp_0_3_table_output_step_dwid, 'tool_code', 'tool_code', 2, FALSE)
        ,      (sp_0_3_table_output_step_dwid, 'tool_type', 'tool_type', 3, FALSE)
        ,      (sp_0_3_table_output_step_dwid, 'tool_price', 'tool_price', 4, FALSE)
        ,      (sp_0_3_table_output_step_dwid, 'tool_inventory_start_date', 'tool_inventory_start_date', 5, FALSE)
        ,      (sp_0_3_table_output_step_dwid, 'tool_inventory_end_date', 'tool_inventory_end_date', 6, FALSE)
        ,      (sp_0_3_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid', 7, FALSE)
        ,      (sp_0_3_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', 8, FALSE);

        -- Insert / Update step record for SP-0.4
        INSERT INTO mdi.insert_update_step (dwid, process_dwid, connectionname, schema_name, table_name, commit_size,
                                            do_not)
        VALUES (sp_0_4_insert_update_step_dwid, sp_0_4_process_dwid, 'Ingress DB Connection', 'test',
                'unit_test_tools_target', 1000, 'N');

        -- Insert / Update key record for SP-0.4
        INSERT INTO mdi.insert_update_key (insert_update_step_dwid, key_lookup, key_stream1, key_stream2, key_condition)
        VALUES (sp_0_4_insert_update_step_dwid, 'tool_pid', 'tool_pid', 'N/A', '=');

        -- Insert / Update records for SP-0.4
        INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)
        VALUES (sp_0_4_insert_update_step_dwid, 'tool_pid', 'tool_pid', 'N', FALSE)
        ,      (sp_0_4_insert_update_step_dwid, 'tool_code', 'tool_code', 'Y', FALSE)
        ,      (sp_0_4_insert_update_step_dwid, 'tool_type', 'tool_type', 'Y', FALSE)
        ,      (sp_0_4_insert_update_step_dwid, 'tool_price', 'tool_price', 'Y', FALSE)
        ,      (sp_0_4_insert_update_step_dwid, 'tool_inventory_start_date', 'tool_inventory_start_date', 'Y', FALSE)
        ,      (sp_0_4_insert_update_step_dwid, 'tool_inventory_end_date', 'tool_inventory_end_date', 'Y', FALSE)
        ,      (sp_0_4_insert_update_step_dwid, 'data_source_dwid', 'data_source_dwid', 'Y', FALSE)
        ,      (sp_0_4_insert_update_step_dwid, 'etl_batch_id', 'etl_batch_id', 'Y', FALSE);

END $$