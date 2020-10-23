-------------------------------------------------------------------------------
--  NAME
--      Add MDI Config Tables
--
--  ASANA
--      https://app.asana.com/0/0/1198065847802233
--
--  DESCRIPTION/PURPOSE
--      This script adds the config tables that are needed for MDI controller and
--      performer processes to load data files.
--
-- PROGRAMMING NOTES
--     None
--
-------------------------------------------------------------------------------

DROP SCHEMA IF EXISTS mdi CASCADE;

create type pentaho_field_type as enum ('String', 'Date', 'Integer', 'Number', 'BigNumber', 'Binary', 'Timestamp', 'Internet Address');
create type pentaho_field_currency as enum ('$');
create type pentaho_field_decimal as enum ('.');
create type pentaho_trim_type as enum ('both', 'right', 'left', 'none');
create type pentaho_y_or_n as enum ('Y', 'N');
create type pentaho_spreadsheet_type as enum ('JXL', 'POI', 'SAX_POI', 'ODS');
create type pentaho_field_format as enum ('mixed', 'DOS', 'Unix');
create type pentaho_db_connection_name as enum ('Ingress DB Connection', 'Config DB Connection', 'Staging DB Connection');

create table process
(
	process_name text not null
		constraint process_pk
			primary key,
	description text not null
);

create table csv_file_input_step
(
	process_name text not null
		constraint csv_file_input_step_process_process_name_fk
			references process
			on update cascade on delete cascade
			deferrable initially deferred,
	step_id bigserial not null
		constraint csv_file_input_step_pk
			primary key,
	filename text not null,
	header_present mdi.pentaho_y_or_n not null,
	csv_delimiter char not null,
	enclosure char not null,
	buffersize integer not null,
	lazy_conversion mdi.pentaho_y_or_n not null,
	newline_possible mdi.pentaho_y_or_n not null,
	add_filename_result mdi.pentaho_y_or_n not null,
	file_format mdi.pentaho_field_format not null,
	file_encoding text not null,
	include_filename mdi.pentaho_y_or_n not null,
	process_in_parallel mdi.pentaho_y_or_n not null,
	filename_field text,
	row_num_field text
);

create table csv_file_input_field
(
	step_id bigserial not null
		constraint csv_file_input_field_csv_file_input_step_step_id_fk
			references csv_file_input_step
			on update cascade on delete cascade
			deferrable initially deferred,
	row_id bigserial not null
		constraint csv_file_input_field_pk
			primary key,
	field_name text not null,
	field_type mdi.pentaho_field_type not null,
	field_format text,
	field_length integer,
	field_precision integer,
	field_currency mdi.pentaho_field_currency,
	field_decimal mdi.pentaho_field_decimal,
	field_group text,
	field_trim_type mdi.pentaho_trim_type,
	field_order numeric not null
);

create table excel_file_input_step
(
	process_name text not null
		constraint excel_input_step_process_process_name_fk
			references process
			on update cascade on delete cascade
			deferrable initially deferred,
	step_id bigserial not null
		constraint excel_input_step_pk
			primary key,
	spreadsheet_type mdi.pentaho_spreadsheet_type not null,
	filename text not null,
	filemask text,
	exclude_filemask text,
	file_required mdi.pentaho_y_or_n not null,
	include_subfolders mdi.pentaho_y_or_n not null,
	sheet_name text not null,
	sheet_start_row integer not null,
	sheet_start_col integer not null
);

create table excel_file_input_field
(
	step_id bigint not null
		constraint excel_file_input_field_excel_file_input_step_step_id_fk
			references excel_file_input_step
			on update cascade on delete cascade
			deferrable initially deferred,
	row_id bigserial not null
		constraint excel_file_input_field_pk
			primary key,
	field_name text not null,
	field_type mdi.pentaho_field_type not null,
	field_format text,
	field_length integer,
	field_precision integer,
	field_currency mdi.pentaho_field_currency,
	field_decimal mdi.pentaho_field_decimal,
	field_group text,
	field_trim_type mdi.pentaho_trim_type,
	field_order numeric not null
);

create table table_output_step
(
	process_name text
		constraint table_output_step_process_process_name_fk
			references process
			on update cascade on delete cascade
			deferrable initially deferred,
	step_id bigserial not null
		constraint table_output_step_pk
			primary key,
	target_schema text not null,
	target_table text not null,
	commit_size integer not null,
	partitioning_field text,
	table_name_field text,
	auto_generated_key_field text,
	partition_data_per text,
	table_name_defined_in_field mdi.pentaho_y_or_n not null,
	return_auto_generated_key_field text,
	truncate_table mdi.pentaho_y_or_n not null,
	connectionname text not null,
	partition_over_tables mdi.pentaho_y_or_n,
	specify_database_fields mdi.pentaho_y_or_n not null,
	ignore_insert_errors mdi.pentaho_y_or_n not null,
	use_batch_update mdi.pentaho_y_or_n not null
);

create table table_output_field
(
	step_id bigint not null
		constraint table_output_field_table_output_step_step_id_fk
			references table_output_step
			on update cascade on delete cascade
			deferrable initially deferred,
	row_id bigserial not null
		constraint table_output_field_pk
			primary key,
	field_name_in_db text not null,
	field_name_in_stream text not null,
	field_order numeric not null
);




INSERT INTO mdi.process (process_name, description) VALUES ('sp7_1_1', 'Load DMI NMLS Call Report - state');
INSERT INTO mdi.process (process_name, description) VALUES ('sp7_1_3', 'DMI NMLS Call Report - S540a');

INSERT INTO mdi.table_output_step (process_name, step_id, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update) VALUES ('sp7_1_1', 1, 'dmi', 'nmls_call_state_raw', 1000, null, null, null, null, 'N', null, 'Y', 'Ingress DB Connection', 'N', 'Y', 'N', 'N');
INSERT INTO mdi.table_output_step (process_name, step_id, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update) VALUES ('sp7_1_3', 6, 'dmi', 'nmls_call_report_s540a_raw', 1000, null, null, null, null, 'N', null, 'Y', 'Ingress DB Connection', 'N', 'Y', 'N', 'N');

INSERT INTO mdi.table_output_field (step_id, row_id, field_name_in_db, field_name_in_stream, field_order) VALUES (1, 1, 'mcr_code', 'mcr_code', 1);
INSERT INTO mdi.table_output_field (step_id, row_id, field_name_in_db, field_name_in_stream, field_order) VALUES (1, 2, 'mcr_desc', 'mcr_desc', 2);
INSERT INTO mdi.table_output_field (step_id, row_id, field_name_in_db, field_name_in_stream, field_order) VALUES (1, 3, 'state_code', 'state_code', 3);
INSERT INTO mdi.table_output_field (step_id, row_id, field_name_in_db, field_name_in_stream, field_order) VALUES (1, 4, 'unpaid_balance', 'unpaid_balance', 4);
INSERT INTO mdi.table_output_field (step_id, row_id, field_name_in_db, field_name_in_stream, field_order) VALUES (1, 5, 'loan_count', 'loan_count', 5);
INSERT INTO mdi.table_output_field (step_id, row_id, field_name_in_db, field_name_in_stream, field_order) VALUES (1, 6, 'avg_loan_size', 'avg_loan_size', 6);
INSERT INTO mdi.table_output_field (step_id, row_id, field_name_in_db, field_name_in_stream, field_order) VALUES (6, 38, 'LoanCount', 'loan_count', 5);
INSERT INTO mdi.table_output_field (step_id, row_id, field_name_in_db, field_name_in_stream, field_order) VALUES (6, 36, 'POOL #', 'pool_number', 3);
INSERT INTO mdi.table_output_field (step_id, row_id, field_name_in_db, field_name_in_stream, field_order) VALUES (6, 34, 'ServicerID', 'servicer_id', 1);
INSERT INTO mdi.table_output_field (step_id, row_id, field_name_in_db, field_name_in_stream, field_order) VALUES (6, 35, 'UPB', 'unpaid_balance', 2);
INSERT INTO mdi.table_output_field (step_id, row_id, field_name_in_db, field_name_in_stream, field_order) VALUES (6, 39, 'ServicerName', 'servicer_name', 6);
INSERT INTO mdi.table_output_field (step_id, row_id, field_name_in_db, field_name_in_stream, field_order) VALUES (6, 40, 'ItemId', 'item_id', 7);
INSERT INTO mdi.table_output_field (step_id, row_id, field_name_in_db, field_name_in_stream, field_order) VALUES (6, 37, 'STATE', 'state_code', 4);

INSERT INTO mdi.excel_file_input_step (process_name, step_id, spreadsheet_type, filename, filemask, exclude_filemask, file_required, include_subfolders, sheet_name, sheet_start_row, sheet_start_col) VALUES ('sp7_1_3', 1, 'POI', 'C:\pdi\Data\V35_Q022020 Cardinal Financial Company NMLS Call Summary Report-RESTRICTED.xls', null, null, 'Y', 'N', 'S540A Layout #2', 3, 0);

INSERT INTO mdi.excel_file_input_field (step_id, row_id, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order) VALUES (1, 70, 'ServicerID', 'String', null, null, null, '$', '.', ',', 'none', 3);
INSERT INTO mdi.excel_file_input_field (step_id, row_id, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order) VALUES (1, 73, 'UPB', 'Number', null, 17, 2, '$', '.', ',', 'none', 6);
INSERT INTO mdi.excel_file_input_field (step_id, row_id, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order) VALUES (1, 72, 'POOL #', 'String', null, null, null, '$', '.', ',', 'none', 5);
INSERT INTO mdi.excel_file_input_field (step_id, row_id, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order) VALUES (1, 68, 'STATE', 'String', null, null, null, '$', '.', ',', 'none', 1);
INSERT INTO mdi.excel_file_input_field (step_id, row_id, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order) VALUES (1, 74, 'LoanCount', 'Number', null, 17, 2, '$', '.', ',', 'none', 7);
INSERT INTO mdi.excel_file_input_field (step_id, row_id, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order) VALUES (1, 71, 'ServicerName', 'String', null, null, null, '$', '.', ',', 'none', 4);
INSERT INTO mdi.excel_file_input_field (step_id, row_id, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order) VALUES (1, 69, 'ItemId', 'Integer', null, null, null, '$', '.', ',', 'none', 2);

INSERT INTO mdi.csv_file_input_step (process_name, step_id, filename, header_present, csv_delimiter, enclosure, buffersize, lazy_conversion, newline_possible, add_filename_result, file_format, file_encoding, include_filename, process_in_parallel, filename_field, row_num_field) VALUES ('sp7_1_1', 1, 'C:\pdi\Data\state.csv', 'Y', ',', '"', 1024, 'N', 'N', 'N', 'mixed', 'UTF-8', 'N', 'Y', null, null);

INSERT INTO mdi.csv_file_input_field (step_id, row_id, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order) VALUES (1, 2, 'mcr_desc', 'String', '', -1, -1, '$', '.', ',', 'none', 2);
INSERT INTO mdi.csv_file_input_field (step_id, row_id, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order) VALUES (1, 3, 'state_code', 'String', '', -1, -1, '$', '.', ',', 'none', 3);
INSERT INTO mdi.csv_file_input_field (step_id, row_id, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order) VALUES (1, 1, 'mcr_code', 'String', '', -1, -1, '$', '.', ',', 'none', 1);
INSERT INTO mdi.csv_file_input_field (step_id, row_id, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order) VALUES (1, 6, 'avg_loan_size', 'Number', '#', -1, -1, '$', '.', ',', 'none', 6);
INSERT INTO mdi.csv_file_input_field (step_id, row_id, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order) VALUES (1, 4, 'unpaid_balance', 'Number', '#', -1, -1, '$', '.', ',', 'none', 4);
INSERT INTO mdi.csv_file_input_field (step_id, row_id, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order) VALUES (1, 5, 'loan_count', 'Integer', '#', -1, -1, '$', '.', ',', 'none', 5);