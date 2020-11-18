--
-- create settings table for Table Input step in Pentaho
--
create table mdi.table_input_step
(
    dwid bigserial not null
        constraint table_input_step_pk
            primary key,
    process_dwid bigint NOT NULL,
    sql text not null,
    limit_size integer,
    execute_for_each_row mdi.pentaho_y_or_n default 'N'::mdi.pentaho_y_or_n not null,
    replace_variables_in_script mdi.pentaho_y_or_n default 'N'::mdi.pentaho_y_or_n not null,
    enable_lazy_conversion mdi.pentaho_y_or_n default 'N'::mdi.pentaho_y_or_n not null,
    cached_row_meta mdi.pentaho_y_or_n default 'N'::mdi.pentaho_y_or_n not null,
    connection mdi.pentaho_db_connection_name default 'Ingress DB Connection'::mdi.pentaho_db_connection_name not null
);

--
-- add MDI settings for SP8.2
--
INSERT INTO mdi.process
(dwid, name, description)
VALUES
(5, 'SP8.2', 'Transfer DMI NMLS Call Report data to staging db - state')
;

INSERT INTO mdi.table_input_step
(dwid, process_dwid, sql, limit_size, execute_for_each_row, replace_variables_in_script, enable_lazy_conversion,
 cached_row_meta, connection)
VALUES
(2, 5, 'select
   mcr_code
   , mcr_desc
   , state_type
   , unpaid_balance
   , loan_count
   , avg_loan_size
   , etl_batch_id
   , 3 as data_source_dwid
from
   dmi.nmls_call_report_state_raw
;', null, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT) -- data_source_dwid=3 is DMI
;

INSERT INTO mdi.table_output_step (dwid, process_dwid, target_schema, target_table, commit_size, partitioning_field,
                                   table_name_field, auto_generated_key_field, partition_data_per,
                                   table_name_defined_in_field, return_auto_generated_key_field, truncate_table,
                                   connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors,
                                   use_batch_update)
VALUES
(5, 5, 'mcr', 'nmls_call_report_state', 1000, null, null, null, null, 'N', null, 'Y', 'Staging DB Connection', 'N',
 'Y', 'N', 'N')
;

INSERT INTO mdi.table_output_field
(dwid, table_output_step_dwid, database_field_name, database_stream_name, field_order)
VALUES
(29, 5, 'mcr_code', 'mcr_code', 1)
, (30, 5, 'mcr_desc', 'mcr_desc', 2)
, (31, 5, 'state_type', 'state_type', 3)
, (32, 5, 'unpaid_balance', 'unpaid_balance', 4)
, (33, 5, 'loan_count', 'loan_count', 5)
, (34, 5, 'avg_loan_size', 'avg_loan_size', 6)
, (35, 5, 'etl_batch_id', 'etl_batch_id', 7)
, (36, 5, 'data_source_dwid', 'data_source_dwid', 8)
;

--
-- add MDI settings for SP9.2
--
INSERT INTO mdi.process
    (dwid, name, description)
VALUES
    (4, 'SP9.2', 'Transfer DMI NMLS Call Report data to staging db - national')
;

INSERT INTO mdi.table_input_step
(dwid, process_dwid, sql, limit_size, execute_for_each_row, replace_variables_in_script, enable_lazy_conversion,
 cached_row_meta, connection)
VALUES
(1, 4, 'select
   mcr_code
   , mcr_desc
   , unpaid_balance
   , loan_count
   , avg_loan_size
   , etl_batch_id
   , 3 as data_source_dwid
from
   dmi.nmls_call_report_national_raw
;', null, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT) -- data_source_dwid=3 is DMI
;

INSERT INTO mdi.table_output_step (dwid, process_dwid, target_schema, target_table, commit_size, partitioning_field,
    table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field,
    return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields,
    ignore_insert_errors, use_batch_update)
VALUES
(4, 4, 'mcr', 'nmls_call_report_national', 1000, null, null, null, null, 'N', null, 'Y', 'Staging DB Connection',
  'N', 'Y', 'N', 'N')
;

INSERT INTO mdi.table_output_field
    (dwid, table_output_step_dwid, database_field_name, database_stream_name, field_order)
VALUES
  (22, 4, 'mcr_code', 'mcr_code', 1)
, (23, 4, 'mcr_desc', 'mcr_desc', 2)
, (24, 4, 'unpaid_balance', 'unpaid_balance', 3)
, (25, 4, 'loan_count', 'loan_count', 4)
, (26, 4, 'avg_loan_size', 'avg_loan_size', 5)
, (27, 4, 'etl_batch_id', 'etl_batch_id', 6)
, (28, 4, 'data_source_dwid', 'data_source_dwid', 7)
;

--
-- add MDI settings for SP10.2
--
INSERT INTO mdi.process
(dwid, name, description)
VALUES
(6, 'SP8.2', 'Transfer DMI NMLS Call Report data to staging db - S540a')
;

INSERT INTO mdi.table_input_step
(dwid, process_dwid, sql, limit_size, execute_for_each_row, replace_variables_in_script, enable_lazy_conversion,
 cached_row_meta, connection)
VALUES
(3, 6, 'select
   state_type
   , item_id
   , servicer_id
   , servicer_name
   , pool_number
   , unpaid_balance
   , loan_count
   , etl_batch_id
   , 3 as data_source_dwid
from
   dmi.nmls_call_report_s540a_raw
;', null, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT) -- data_source_dwid=3 is DMI
;

INSERT INTO mdi.table_output_step (dwid, process_dwid, target_schema, target_table, commit_size, partitioning_field,
                                   table_name_field, auto_generated_key_field, partition_data_per,
                                   table_name_defined_in_field, return_auto_generated_key_field, truncate_table,
                                   connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors,
                                   use_batch_update)
VALUES
(6, 6, 'mcr', 'nmls_call_report_s540a', 1000, null, null, null, null, 'N', null, 'Y', 'Staging DB Connection', 'N',
 'Y', 'N', 'N')
;

INSERT INTO mdi.table_output_field
(dwid, table_output_step_dwid, database_field_name, database_stream_name, field_order)
VALUES
(37, 6, 'state_type', 'state_type', 1)
     , (38, 6, 'mcr_desc', 'mcr_desc', 2)
     , (39, 6, 'item_id', 'item_id', 3)
     , (40, 6, 'servicer_id', 'servicer_id', 4)
     , (41, 6, 'servicer_name', 'servicer_name', 5)
     , (42, 6, 'pool_number', 'pool_number', 6)
     , (43, 6, 'data_source_dwid', 'data_source_dwid', 7)
     , (44, 6, 'servicer_name', 'servicer_name', 8)
     , (45, 6, 'pool_number', 'pool_number', 9)
     , (46, 6, 'data_source_dwid', 'data_source_dwid', 10)
;
