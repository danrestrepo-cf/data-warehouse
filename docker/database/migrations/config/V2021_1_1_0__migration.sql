-- create additional field to csv input to track where the input data came from
ALTER TABLE mdi.csv_file_input_step
    ADD data_source_dwid BIGINT
;

-- populate values for csv input
UPDATE mdi.csv_file_input_step
SET data_source_dwid=3
WHERE process_dwid IN ( 1, 2 ) -- update for SP8.1 and SP9.1
;


-- create additional field to excel input to track where the input data came from
ALTER TABLE mdi.microsoft_excel_input_step
    ADD data_source_dwid BIGINT
;

-- populate values for excel input
UPDATE mdi.microsoft_excel_input_step
SET data_source_dwid=3
WHERE process_dwid = 3 -- update for SP10.1
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
    data_source_dwid BIGINT NULL,
    sql TEXT NOT NULL,
    limit_size INTEGER DEFAULT 0 NOT NULL, -- default to zero so Pentaho will return ALL rows queried
    execute_for_each_row mdi.PENTAHO_Y_OR_N DEFAULT 'N'::mdi.PENTAHO_Y_OR_N NOT NULL,
    replace_variables mdi.PENTAHO_Y_OR_N DEFAULT 'N'::mdi.PENTAHO_Y_OR_N NOT NULL,
    enable_lazy_conversion mdi.PENTAHO_Y_OR_N DEFAULT 'N'::mdi.PENTAHO_Y_OR_N NOT NULL,
    cached_row_meta mdi.PENTAHO_Y_OR_N DEFAULT 'N'::mdi.PENTAHO_Y_OR_N NOT NULL,
    connectionname mdi.PENTAHO_DB_CONNECTION_NAME NOT NULL
);

--
-- add MDI settings for SP8.2
--
INSERT INTO mdi.process
    ( dwid, name, description )
VALUES ( 5, 'SP8.2', 'Transfer DMI NMLS Call Report data to staging db - state' )
;

INSERT INTO mdi.table_input_step
( dwid, process_dwid, data_source_dwid, sql, limit_size, enable_lazy_conversion, cached_row_meta, connectionname )
VALUES ( 1, 5, 3, 'select
   mcr_code
   , mcr_desc
   , state_type
   , unpaid_balance
   , loan_count
   , avg_loan_size
   , etl_batch_id
from
   dmi.nmls_call_report_state_raw
;', 0, DEFAULT, DEFAULT, 'Ingress DB Connection' )
;

INSERT INTO mdi.table_output_step ( dwid, process_dwid, target_schema, target_table, commit_size, partitioning_field
                                  , table_name_field, auto_generated_key_field, partition_data_per
                                  , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                  , connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors
                                  , use_batch_update )
VALUES ( 4, 5, 'staging_compliance', 'nmls_call_report_state', 1000, NULL, NULL, NULL, NULL, 'N', NULL, 'Y'
       , 'Staging DB Connection', 'N', 'Y', 'N', 'N' )
;

INSERT INTO mdi.table_output_field
( dwid, table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive )
VALUES ( 22, 4, 'mcr_code', 'mcr_code', 1, FALSE )
     , ( 23, 4, 'mcr_description', 'mcr_desc', 2, FALSE )
     , ( 24, 4, 'state_type', 'state_type', 3, FALSE )
     , ( 25, 4, 'unpaid_balance', 'unpaid_balance', 4, FALSE )
     , ( 26, 4, 'loan_count', 'loan_count', 5, FALSE )
     , ( 27, 4, 'average_loan_size', 'avg_loan_size', 6, FALSE )
     , ( 28, 4, 'etl_batch_id', 'etl_batch_id', 7, FALSE )
     , ( 29, 4, 'data_source_dwid', 'data_source_dwid', 8, FALSE )
;

--
-- add MDI settings for SP9.2
--
INSERT INTO mdi.process
    ( dwid, name, description )
VALUES ( 4, 'SP9.2', 'Transfer DMI NMLS Call Report data to staging db - national' )
;

INSERT INTO mdi.table_input_step
( dwid, process_dwid, data_source_dwid, sql, limit_size, enable_lazy_conversion, cached_row_meta, connectionname )
VALUES ( 2, 4, 3, 'select
   mcr_code
   , mcr_desc
   , unpaid_balance
   , loan_count
   , avg_loan_size
   , etl_batch_id
from
   dmi.nmls_call_report_national_raw
;', 0, DEFAULT, DEFAULT, 'Ingress DB Connection' )
;

INSERT INTO mdi.table_output_step ( dwid, process_dwid, target_schema, target_table, commit_size, partitioning_field
                                  , table_name_field, auto_generated_key_field, partition_data_per
                                  , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                  , connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors
                                  , use_batch_update )
VALUES ( 5, 4, 'staging_compliance', 'nmls_call_report_national', 1000, NULL, NULL, NULL, NULL, 'N', NULL, 'Y'
       , 'Staging DB Connection', 'N', 'Y', 'N', 'N' )
;

INSERT INTO mdi.table_output_field
( dwid, table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive )
VALUES ( 30, 5, 'mcr_code', 'mcr_code', 1, FALSE )
     , ( 31, 5, 'mcr_description', 'mcr_desc', 2, FALSE )
     , ( 32, 5, 'unpaid_balance', 'unpaid_balance', 3, FALSE )
     , ( 33, 5, 'loan_count', 'loan_count', 4, FALSE )
     , ( 34, 5, 'average_loan_size', 'avg_loan_size', 5, FALSE )
     , ( 35, 5, 'etl_batch_id', 'etl_batch_id', 6, FALSE )
     , ( 36, 5, 'data_source_dwid', 'data_source_dwid', 7, FALSE )
;

--
-- add MDI settings for SP10.2
--
INSERT INTO mdi.process
    ( dwid, name, description )
VALUES ( 6, 'SP10.2', 'Transfer DMI NMLS Call Report data to staging db - S540a' )
;

INSERT INTO mdi.table_input_step
( dwid, process_dwid, data_source_dwid, sql, limit_size, enable_lazy_conversion, cached_row_meta, connectionname )
VALUES ( 3, 6, 3, 'select
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
;', 0, DEFAULT, DEFAULT, 'Ingress DB Connection' )
;

INSERT INTO mdi.table_output_step ( dwid, process_dwid, target_schema, target_table, commit_size, partitioning_field
                                  , table_name_field, auto_generated_key_field, partition_data_per
                                  , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                  , connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors
                                  , use_batch_update )
VALUES ( 6, 6, 'staging_compliance', 'nmls_call_report_s540a', 1000, NULL, NULL, NULL, NULL, 'N', NULL, 'Y'
       , 'Staging DB Connection', 'N', 'Y', 'N', 'N' )
;

INSERT INTO mdi.table_output_field
( dwid, table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive )
VALUES ( 37, 6, 'state_type', 'state_type', 1, FALSE )
     , ( 38, 6, 'item_id', 'item_id', 3, FALSE )
     , ( 39, 6, 'servicer_nmls_id', 'servicer_id', 4, FALSE )
     , ( 40, 6, 'servicer_name', 'servicer_name', 5, FALSE )
     , ( 41, 6, 'pool_number', 'pool_number', 6, FALSE )
     , ( 42, 6, 'unpaid_balance', 'unpaid_balance', 7, FALSE )
     , ( 43, 6, 'loan_count', 'loan_count', 8, FALSE )
     , ( 44, 6, 'etl_batch_id', 'etl_batch_id', 9, FALSE )
     , ( 45, 6, 'data_source_dwid', 'data_source_dwid', 10, FALSE )
;

-- Set sequences since we haven't been using them yet
SELECT setval('mdi.table_input_step_dwid_seq', (select max(dwid) from mdi.table_input_step), true);
SELECT setval('mdi.table_output_step_dwid_seq', (select max(dwid) from mdi.table_output_step), true);
SELECT setval('mdi.table_output_field_dwid_seq', (select max(dwid) from mdi.table_output_field), true);
SELECT setval('mdi.process_dwid_seq', (select max(dwid) from mdi.process), true);
SELECT setval('mdi.microsoft_excel_input_step_dwid_seq', (select max(dwid) from mdi.microsoft_excel_input_step), true);
SELECT setval('mdi.microsoft_excel_input_field_dwid_seq', (select max(dwid) from mdi.microsoft_excel_input_field), true);
SELECT setval('mdi.csv_file_input_step_dwid_seq', (select max(dwid) from mdi.csv_file_input_step), true);
SELECT setval('mdi.csv_file_input_field_dwid_seq', (select max(dwid) from mdi.csv_file_input_field), true);
