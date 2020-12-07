-- create additional field to csv input to track where the input data came from
ALTER TABLE
    mdi.csv_file_input_step
    ADD
        data_source_dwid BIGINT
;

-- populate values for csv input
UPDATE
    mdi.csv_file_input_step
SET
    data_source_dwid=3
WHERE
    process_dwid IN ( 1, 2 ) -- update for SP8.1 and SP9.1
;


-- create additional field to excel input to track where the input data came from
ALTER TABLE
    mdi.microsoft_excel_input_step
    ADD
        data_source_dwid BIGINT
;

-- populate values for excel input
UPDATE
    mdi.microsoft_excel_input_step
SET
    data_source_dwid=3
WHERE
    process_dwid = 3 -- update for SP10.1
;

--
-- create settings table for Table Input step in Pentaho
--
CREATE TABLE mdi.table_input_step
(
    dwid BIGSERIAL NOT NULL
        CONSTRAINT table_input_step_pk
            PRIMARY KEY,
    process_dwid BIGINT NOT NULL,
    sql TEXT NOT NULL,
    limit_size INTEGER DEFAULT 0, -- default to zero so Pentaho will return ALL rows queried
    execute_for_each_row mdi.PENTAHO_Y_OR_N DEFAULT 'N'::mdi.PENTAHO_Y_OR_N NOT NULL,
    replace_variables_in_script mdi.PENTAHO_Y_OR_N DEFAULT 'N'::mdi.PENTAHO_Y_OR_N NOT NULL,
    enable_lazy_conversion mdi.PENTAHO_Y_OR_N DEFAULT 'N'::mdi.PENTAHO_Y_OR_N NOT NULL,
    cached_row_meta mdi.PENTAHO_Y_OR_N DEFAULT 'N'::mdi.PENTAHO_Y_OR_N NOT NULL,
    connection mdi.PENTAHO_DB_CONNECTION_NAME DEFAULT 'Ingress DB Connection'::mdi.PENTAHO_DB_CONNECTION_NAME NOT NULL
);

--
-- add MDI settings for SP8.2
--
INSERT INTO mdi.process
    ( dwid, name, description )
VALUES ( 5, 'SP8.2', 'Transfer DMI NMLS Call Report data to staging db - state' )
;

INSERT INTO mdi.table_input_step
( dwid, process_dwid, sql, limit_size, execute_for_each_row, replace_variables_in_script, enable_lazy_conversion
, cached_row_meta, connection )
VALUES ( 2, 5, 'select
   mcr_code
   , mcr_desc
   , state_type
   , unpaid_balance
   , loan_count
   , avg_loan_size
   , etl_batch_id
from
   dmi.nmls_call_report_state_raw
;', NULL, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT )
;

INSERT INTO mdi.table_output_step ( dwid, process_dwid, target_schema, target_table, commit_size, partitioning_field
                                  , table_name_field, auto_generated_key_field, partition_data_per
                                  , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                  , connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors
                                  , use_batch_update )
VALUES ( 5, 5, 'mcr', 'nmls_call_report_state', 1000, NULL, NULL, NULL, NULL, 'N', NULL, 'Y', 'Staging DB Connection'
       , 'N', 'Y', 'N', 'N' )
;

INSERT INTO mdi.table_output_field
( dwid, table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive )
VALUES ( 29, 5, 'mcr_code', 'mcr_code', 1,0  )
     , ( 30, 5, 'mcr_desc', 'mcr_desc', 2,0 )
     , ( 31, 5, 'state_type', 'state_type', 3,0 )
     , ( 32, 5, 'unpaid_balance', 'unpaid_balance', 4,0 )
     , ( 33, 5, 'loan_count', 'loan_count', 5,0 )
     , ( 34, 5, 'avg_loan_size', 'avg_loan_size', 6,0 )
     , ( 35, 5, 'etl_batch_id', 'etl_batch_id', 7 ,0)
     , ( 36, 5, 'data_source_dwid', 'data_source_dwid', 8 ,0)
;

--
-- add MDI settings for SP9.2
--
INSERT INTO mdi.process
    ( dwid, name, description )
VALUES ( 4, 'SP9.2', 'Transfer DMI NMLS Call Report data to staging db - national' )
;

INSERT INTO mdi.table_input_step
( dwid, process_dwid, sql, limit_size, execute_for_each_row, replace_variables_in_script, enable_lazy_conversion
, cached_row_meta, connection )
VALUES ( 1, 4, 'select
   mcr_code
   , mcr_desc
   , unpaid_balance
   , loan_count
   , avg_loan_size
   , etl_batch_id
from
   dmi.nmls_call_report_national_raw
;', NULL, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT )
;

INSERT INTO mdi.table_output_step ( dwid, process_dwid, target_schema, target_table, commit_size, partitioning_field
                                  , table_name_field, auto_generated_key_field, partition_data_per
                                  , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                  , connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors
                                  , use_batch_update )
VALUES ( 4, 4, 'mcr', 'nmls_call_report_national', 1000, NULL, NULL, NULL, NULL, 'N', NULL, 'Y', 'Staging DB Connection'
       , 'N', 'Y', 'N', 'N' )
;

INSERT INTO mdi.table_output_field
( dwid, table_output_step_dwid, database_field_name, database_stream_name, field_order,is_sensitive )
VALUES ( 22, 4, 'mcr_code', 'mcr_code', 1 ,0)
     , ( 23, 4, 'mcr_desc', 'mcr_desc', 2 ,0)
     , ( 24, 4, 'unpaid_balance', 'unpaid_balance', 3 ,0)
     , ( 25, 4, 'loan_count', 'loan_count', 4 ,0)
     , ( 26, 4, 'avg_loan_size', 'avg_loan_size', 5 ,0)
     , ( 27, 4, 'etl_batch_id', 'etl_batch_id', 6 ,0)
     , ( 28, 4, 'data_source_dwid', 'data_source_dwid', 7 ,0)
;

--
-- add MDI settings for SP10.2
--
INSERT INTO mdi.process
    ( dwid, name, description )
VALUES ( 6, 'SP8.2', 'Transfer DMI NMLS Call Report data to staging db - S540a' )
;

INSERT INTO mdi.table_input_step
( dwid, process_dwid, sql, limit_size, execute_for_each_row, replace_variables_in_script, enable_lazy_conversion
, cached_row_meta, connection )
VALUES ( 3, 6, 'select
   state_type
   , item_id
   , servicer_id
   , servicer_name
   , pool_number
   , unpaid_balance
   , loan_count
   , etl_batch_id
from
   dmi.nmls_call_report_s540a_raw
;', NULL, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT )
;

INSERT INTO mdi.table_output_step ( dwid, process_dwid, target_schema, target_table, commit_size, partitioning_field
                                  , table_name_field, auto_generated_key_field, partition_data_per
                                  , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                  , connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors
                                  , use_batch_update )
VALUES ( 6, 6, 'mcr', 'nmls_call_report_s540a', 1000, NULL, NULL, NULL, NULL, 'N', NULL, 'Y', 'Staging DB Connection'
       , 'N', 'Y', 'N', 'N' )
;

INSERT INTO mdi.table_output_field
( dwid, table_output_step_dwid, database_field_name, database_stream_name, field_order,is_sensitive )
VALUES ( 37, 6, 'state_type', 'state_type', 1,0 )
     , ( 38, 6, 'mcr_desc', 'mcr_desc', 2,0 )
     , ( 39, 6, 'item_id', 'item_id', 3,0 )
     , ( 40, 6, 'servicer_id', 'servicer_id', 4,0 )
     , ( 41, 6, 'servicer_name', 'servicer_name', 5,0 )
     , ( 42, 6, 'pool_number', 'pool_number', 6,0 )
     , ( 43, 6, 'data_source_dwid', 'data_source_dwid', 7 ,0)
     , ( 44, 6, 'servicer_name', 'servicer_name', 8,0 )
     , ( 45, 6, 'pool_number', 'pool_number', 9,0 )
     , ( 46, 6, 'data_source_dwid', 'data_source_dwid', 10 ,0)
;
