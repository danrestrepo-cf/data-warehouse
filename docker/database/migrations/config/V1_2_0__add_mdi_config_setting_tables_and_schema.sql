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

CREATE SCHEMA mdi;


--
-- Types: create domain values for configuration settings
--
CREATE TYPE PENTAHO_FIELD_TYPE AS ENUM ('String'
    , 'Date', 'Integer', 'Number', 'BigNumber', 'Binary', 'Timestamp', 'Internet Address');
CREATE TYPE PENTAHO_FIELD_CURRENCY AS ENUM ('$');
CREATE TYPE PENTAHO_FIELD_DECIMAL AS ENUM ('.');
CREATE TYPE PENTAHO_TRIM_TYPE AS ENUM ('both', 'right', 'left', 'none');
CREATE TYPE PENTAHO_Y_OR_N AS ENUM ('Y', 'N');
CREATE TYPE PENTAHO_SPREADSHEET_TYPE AS ENUM ('JXL', 'POI', 'SAX_POI', 'ODS');
CREATE TYPE PENTAHO_FIELD_FORMAT AS ENUM ('mixed', 'DOS', 'Unix');
CREATE TYPE PENTAHO_DB_CONNECTION_NAME AS ENUM ('Ingress DB Connection', 'Config DB Connection', 'Staging DB Connection');

--
-- Tables: create tables needed for mdi process
--
CREATE TABLE process
(
	process_name TEXT NOT NULL
		CONSTRAINT process_pk
			PRIMARY KEY,
	description TEXT NOT NULL
);

CREATE TABLE csv_file_input_step
(
	process_name TEXT NOT NULL
		CONSTRAINT csv_file_input_step_process_process_name_fk
			REFERENCES process
			ON UPDATE CASCADE
			ON DELETE CASCADE
			DEFERRABLE INITIALLY DEFERRED,
	step_id BIGSERIAL NOT NULL
		CONSTRAINT csv_file_input_step_pk
			PRIMARY KEY,
	filename TEXT NOT NULL,
	header_present mdi.PENTAHO_Y_OR_N NOT NULL,
	csv_delimiter CHAR NOT NULL,
	enclosure CHAR NOT NULL,
	buffersize INTEGER NOT NULL,
	lazy_conversion mdi.PENTAHO_Y_OR_N NOT NULL,
	newline_possible mdi.PENTAHO_Y_OR_N NOT NULL,
	add_filename_result mdi.PENTAHO_Y_OR_N NOT NULL,
	file_format mdi.PENTAHO_FIELD_FORMAT NOT NULL,
	file_encoding TEXT NOT NULL,
	include_filename mdi.PENTAHO_Y_OR_N NOT NULL,
	process_in_parallel mdi.PENTAHO_Y_OR_N NOT NULL,
	filename_field TEXT,
	row_num_field TEXT
);

CREATE TABLE csv_file_input_field
(
	step_id BIGSERIAL NOT NULL
		CONSTRAINT csv_file_input_field_csv_file_input_step_step_id_fk
			REFERENCES csv_file_input_step
			ON UPDATE CASCADE
			ON DELETE CASCADE
			DEFERRABLE INITIALLY DEFERRED,
	row_id BIGSERIAL NOT NULL
		CONSTRAINT csv_file_input_field_pk
			PRIMARY KEY,
	field_name TEXT NOT NULL,
	field_type mdi.PENTAHO_FIELD_TYPE NOT NULL,
	field_format TEXT,
	field_length INTEGER,
	field_precision INTEGER,
	field_currency mdi.PENTAHO_FIELD_CURRENCY,
	field_decimal mdi.PENTAHO_FIELD_DECIMAL,
	field_group TEXT,
	field_trim_type mdi.PENTAHO_TRIM_TYPE,
	field_order NUMERIC NOT NULL
);

CREATE TABLE excel_file_input_step
(
	process_name TEXT NOT NULL
		CONSTRAINT excel_input_step_process_process_name_fk
			REFERENCES process
			ON UPDATE CASCADE
			ON DELETE CASCADE
			DEFERRABLE INITIALLY DEFERRED,
	step_id BIGSERIAL NOT NULL
		CONSTRAINT excel_input_step_pk
			PRIMARY KEY,
	spreadsheet_type mdi.PENTAHO_SPREADSHEET_TYPE NOT NULL,
	filename TEXT NOT NULL,
	filemask TEXT,
	exclude_filemask TEXT,
	file_required mdi.PENTAHO_Y_OR_N NOT NULL,
	include_subfolders mdi.PENTAHO_Y_OR_N NOT NULL,
	sheet_name TEXT NOT NULL,
	sheet_start_row INTEGER NOT NULL,
	sheet_start_col INTEGER NOT NULL
);

CREATE TABLE excel_file_input_field
(
	step_id BIGINT NOT NULL
		CONSTRAINT excel_file_input_field_excel_file_input_step_step_id_fk
			REFERENCES excel_file_input_step
			ON UPDATE CASCADE
			ON DELETE CASCADE
			DEFERRABLE INITIALLY DEFERRED,
	row_id BIGSERIAL NOT NULL
		CONSTRAINT excel_file_input_field_pk
			PRIMARY KEY,
	field_name TEXT NOT NULL,
	field_type mdi.PENTAHO_FIELD_TYPE NOT NULL,
	field_format TEXT,
	field_length INTEGER,
	field_precision INTEGER,
	field_currency mdi.PENTAHO_FIELD_CURRENCY,
	field_decimal mdi.PENTAHO_FIELD_DECIMAL,
	field_group TEXT,
	field_trim_type mdi.PENTAHO_TRIM_TYPE,
	field_order NUMERIC NOT NULL
);

CREATE TABLE table_output_step
(
	process_name TEXT
		CONSTRAINT table_output_step_process_process_name_fk
			REFERENCES process
			ON UPDATE CASCADE
			ON DELETE CASCADE
			DEFERRABLE INITIALLY DEFERRED,
	step_id BIGSERIAL NOT NULL
		CONSTRAINT table_output_step_pk
			PRIMARY KEY,
	target_schema TEXT NOT NULL,
	target_table TEXT NOT NULL,
	commit_size INTEGER NOT NULL,
	partitioning_field TEXT,
	table_name_field TEXT,
	auto_generated_key_field TEXT,
	partition_data_per TEXT,
	table_name_defined_in_field mdi.PENTAHO_Y_OR_N NOT NULL,
	return_auto_generated_key_field TEXT,
	truncate_table mdi.PENTAHO_Y_OR_N NOT NULL,
	connectionname TEXT NOT NULL,
	partition_over_tables mdi.PENTAHO_Y_OR_N,
	specify_database_fields mdi.PENTAHO_Y_OR_N NOT NULL,
	ignore_insert_errors mdi.PENTAHO_Y_OR_N NOT NULL,
	use_batch_update mdi.PENTAHO_Y_OR_N NOT NULL
);

CREATE TABLE table_output_field
(
	step_id BIGINT NOT NULL
		CONSTRAINT table_output_field_table_output_step_step_id_fk
			REFERENCES table_output_step
			ON UPDATE CASCADE
			ON DELETE CASCADE
			DEFERRABLE INITIALLY DEFERRED,
	row_id BIGSERIAL NOT NULL
		CONSTRAINT table_output_field_pk
			PRIMARY KEY,
	field_name_in_db TEXT NOT NULL,
	field_name_in_stream TEXT NOT NULL,
	field_order NUMERIC NOT NULL
);

INSERT INTO mdi.process (process_name, description) VALUES ('sp7_1_1', 'Load DMI NMLS Call Report - state');
INSERT INTO mdi.process (process_name, description) VALUES ('sp7_1_2', 'Load DMI NMLS Call Report - national');
INSERT INTO mdi.process (process_name, description) VALUES ('sp7_1_3', 'Load DMI NMLS Call Report - S540a');

INSERT INTO mdi.table_output_step (process_name, step_id, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update) VALUES ('sp7_1_1', 1, 'mdi', 'nmls_call_report_national_raw', 1000, null, null, null, null, 'N', null, 'N', 'Ingress DB Connection', 'N', 'Y', 'N', 'N');
INSERT INTO mdi.table_output_step (process_name, step_id, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update) VALUES ('sp7_1_2', 2, 'mdi', 'nmls_call_report_state_raw', 1000, null, null, null, null, 'N', null, 'N', 'Ingress DB Connection', 'N', 'Y', 'N', 'N');
INSERT INTO mdi.table_output_step (process_name, step_id, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update) VALUES ('sp7_1_3', 3, 'mdi', 'nmls_call_report_s540a_raw', 1000, null, null, null, null, 'N', null, 'N', 'Ingress DB Connection', 'N', 'Y', 'N', 'N');

INSERT INTO mdi.csv_file_input_step (process_name, step_id, filename, header_present, csv_delimiter, enclosure, buffersize, lazy_conversion, newline_possible, add_filename_result, file_format, file_encoding, include_filename, process_in_parallel, filename_field, row_num_field) VALUES ('sp7_1_1', 1, 'c:\\pdi\\Data\\state.csv', 'Y', ',', '"', 1024, 'N', 'N', 'N', 'mixed', 'UTF-8', 'N', 'Y', null, null);
INSERT INTO mdi.csv_file_input_step (process_name, step_id, filename, header_present, csv_delimiter, enclosure, buffersize, lazy_conversion, newline_possible, add_filename_result, file_format, file_encoding, include_filename, process_in_parallel, filename_field, row_num_field) VALUES ('sp7_1_2', 2, 'c:\\pdi\\Data\\national.csv', 'Y', ',', '"', 1024, 'N', 'N', 'N', 'mixed', 'UTF-8', 'N', 'Y', null, null);
INSERT INTO mdi.csv_file_input_step (process_name, step_id, filename, header_present, csv_delimiter, enclosure, buffersize, lazy_conversion, newline_possible, add_filename_result, file_format, file_encoding, include_filename, process_in_parallel, filename_field, row_num_field) VALUES ('sp7_1_3', 3, 'c:\\pdi\\Data\\S540a.xls', 'Y', ',', '"', 1024, 'N', 'N', 'N', 'mixed', 'UTF-8', 'N', 'Y', null, null);

