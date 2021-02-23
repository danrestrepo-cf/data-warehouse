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

-- Process records for SP-0.3 and SP-0.4
INSERT INTO mdi.process (
    name
    , description
)
SELECT 'SP-0.3', 'Test Table Input -> Table Output'
UNION ALL
SELECT 'SP-0.4', 'Test Table Input -> Table Insert / Update'
;


-- Table input step records for SP-0.3 and SP-0.4
INSERT INTO mdi.table_input_step (
    process_dwid
    , data_source_dwid
    , sql
    , limit_size

    , connectionname
)
SELECT 9
    , 3
    , 'SELECT tool_pid
            , tool_code
            , tool_type
            , tool_price
            , tool_inventory_start_date
            , tool_inventory_end_date
        FROM test.unit_test_tools_input;'
    , 0
    , 'Ingress DB Connection'::mdi.pentaho_db_connection_name
UNION ALL
SELECT 10
     , 3
     , 'SELECT tool_pid
            , tool_code
            , tool_type
            , tool_price
            , tool_inventory_start_date
            , tool_inventory_end_date
        FROM test.unit_test_tools_input;'
     , 0
     , 'Ingress DB Connection'::mdi.pentaho_db_connection_name
;

-- Table output step record for SP-0.3
INSERT INTO mdi.table_output_step (
    process_dwid
    , target_schema
    , target_table
    , commit_size
    , table_name_defined_in_field
    , truncate_table
    , connectionname
    , partition_over_tables
    , specify_database_fields
    , ignore_insert_errors
    , use_batch_update
)
SELECT 9
    , 'test'
    , 'unit_test_tools_output'
    , 1000
    , 'N'::mdi.pentaho_y_or_n
    , 'N'
    , 'Ingress DB Connection'::mdi.pentaho_db_connection_name
    , 'N'::mdi.pentaho_y_or_n
    , 'Y'::mdi.pentaho_y_or_n
    , 'N'::mdi.pentaho_y_or_n
    , 'N'::mdi.pentaho_y_or_n
;

-- Table output field records for SP-0.3
INSERT INTO mdi.table_output_field (
    table_output_step_dwid
    , database_field_name
    , database_stream_name
    , field_order
    , is_sensitive
)
SELECT 9
    , 'tool_pid'
    , 'tool_pid'
    , 1
    , FALSE
UNION ALL
SELECT 9
    , 'tool_code'
    , 'tool_code'
    , 2
    , FALSE
UNION ALL
SELECT 9
    , 'tool_type'
    , 'tool_type'
    , 3
    , FALSE
UNION ALL
SELECT 9
    , 'tool_price'
    , 'tool_price'
    , 4
    , FALSE
UNION ALL
SELECT 9
    , 'tool_inventory_start_date'
    , 'tool_inventory_start_date'
    , 5
    , FALSE
UNION ALL
SELECT 9
    , 'tool_inventory_end_date'
    , 'tool_inventory_end_date'
    , 6
    , FALSE
UNION ALL
SELECT 9
     , 'data_source_dwid'
     , 'data_source_dwid'
     , 7
     , FALSE
UNION ALL
SELECT 9
    , 'etl_batch_id'
    , 'etl_batch_id'
    , 8
    , FALSE
;

-- Insert / Update step record for SP-0.4
INSERT INTO mdi.insert_update_step (
    process_dwid
    , connectionname
    , schema_name
    , table_name
    , commit_size
    , do_not
)
SELECT 10
    , 'Ingress DB Connection'::mdi.pentaho_db_connection_name
    , 'test'
    , 'unit_test_tools_output'
    , 1000
    , 'N'::mdi.pentaho_y_or_n
;

-- Insert / Update key record for SP-0.4
INSERT INTO mdi.insert_update_key (
    insert_update_step_dwid
    , key_lookup
    , key_stream1
    , key_stream2
    , key_condition
)
SELECT 1
    , 'tool_pid'
    , 'tool_pid'
    , 'N/A'
    , '='
;

-- Insert / Update records for SP-0.4
INSERT INTO mdi.insert_update_field (
    insert_update_step_dwid
    , update_lookup
    , update_stream
    , update_flag
    , is_sensitive
)
SELECT 1
    , 'tool_pid'
    , 'tool_pid'
    , 'N'::mdi.pentaho_y_or_n
    , FALSE
UNION ALL
SELECT 1
    , 'tool_code'
    , 'tool_code'
    , 'Y'::mdi.pentaho_y_or_n
    , FALSE
UNION ALL
SELECT 1
    , 'tool_type'
    , 'tool_type'
    , 'Y'::mdi.pentaho_y_or_n
    , FALSE
UNION ALL
SELECT 1
    , 'tool_price'
    , 'tool_price'
    , 'Y'::mdi.pentaho_y_or_n
    , FALSE
UNION ALL
SELECT 1
    , 'tool_inventory_start_date'
    , 'tool_inventory_start_date'
    , 'Y'::mdi.pentaho_y_or_n
    , FALSE
UNION ALL
SELECT 1
    , 'tool_inventory_end_date'
    , 'tool_inventory_end_date'
    , 'Y'::mdi.pentaho_y_or_n
    , FALSE
UNION ALL
SELECT 1
    , 'data_source_dwid'
    , 'data_source_dwid'
    , 'Y'::mdi.pentaho_y_or_n
    , FALSE
UNION ALL
SELECT 1
     , 'etl_batch_id'
     , 'etl_batch_id'
     , 'Y'::mdi.pentaho_y_or_n
     , FALSE
;