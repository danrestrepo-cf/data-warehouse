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

CREATE TYPE mdi.PENTAHO_FIELD_TYPE AS ENUM ('String', 'Date', 'Integer', 'Number', 'BigNumber', 'Binary', 'Timestamp', 'Internet Address');
CREATE TYPE mdi.PENTAHO_FIELD_CURRENCY AS ENUM ('$');
CREATE TYPE mdi.PENTAHO_FIELD_DECIMAL AS ENUM ('.');
CREATE TYPE mdi.PENTAHO_TRIM_TYPE AS ENUM ('both', 'right', 'left', 'none');
CREATE TYPE mdi.PENTAHO_Y_OR_N AS ENUM ('Y', 'N');
CREATE TYPE mdi.PENTAHO_SPREADSHEET_TYPE AS ENUM ('JXL', 'POI', 'SAX_POI', 'ODS');
CREATE TYPE mdi.PENTAHO_FIELD_FORMAT AS ENUM ('mixed', 'DOS', 'Unix');
CREATE TYPE mdi.PENTAHO_DB_CONNECTION_NAME AS ENUM ('Ingress DB Connection', 'Config DB Connection', 'Staging DB Connection');

CREATE TABLE mdi.process
(
	process_name TEXT NOT NULL
		CONSTRAINT process_pk
			PRIMARY KEY,
	description TEXT
);

CREATE TABLE mdi.csv_file_input_step
(
	process_name TEXT NOT NULL
		CONSTRAINT fk_csv_file_input_step_1
			REFERENCES mdi.process
			ON UPDATE RESTRICT
			ON DELETE RESTRICT
			DEFERRABLE INITIALLY DEFERRED,
	step_id BIGSERIAL NOT NULL
		CONSTRAINT pk_csv_file_input_step_1
			PRIMARY KEY,
	filename TEXT NOT NULL,
	header_present mdi.PENTAHO_Y_OR_N NOT NULL,
	delimiter TEXT NOT NULL,
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

CREATE TABLE mdi.csv_file_input_field
(
	step_id BIGSERIAL NOT NULL
		CONSTRAINT fk_csv_file_input_field_1
			REFERENCES mdi.csv_file_input_step
			ON UPDATE RESTRICT
			ON DELETE RESTRICT
			DEFERRABLE INITIALLY DEFERRED,
	row_id BIGSERIAL NOT NULL
		CONSTRAINT pk_csv_file_input_field_1
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

CREATE TABLE mdi.microsoft_excel_input_step
(
	process_name TEXT NOT NULL
		CONSTRAINT fk_microsoft_excel_input_step_1
			REFERENCES mdi.process
			ON UPDATE RESTRICT
			ON DELETE RESTRICT
			DEFERRABLE INITIALLY DEFERRED,
	step_id BIGSERIAL NOT NULL
		CONSTRAINT pk_microsoft_excel_input_step_1
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

CREATE TABLE mdi.microsoft_excel_input_field
(
	step_id BIGINT NOT NULL
		CONSTRAINT fk_microsoft_excel_input_field_1
			REFERENCES mdi.microsoft_excel_input_step
			ON UPDATE RESTRICT
			ON DELETE RESTRICT
			DEFERRABLE INITIALLY DEFERRED,
	row_id BIGSERIAL NOT NULL
		CONSTRAINT pk_microsoft_excel_input_field_1
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

CREATE TABLE mdi.table_output_step
(
	process_name TEXT
		CONSTRAINT fk_table_output_step_1
			REFERENCES mdi.process
			ON UPDATE RESTRICT
			ON DELETE RESTRICT
			DEFERRABLE INITIALLY DEFERRED,
	step_id BIGSERIAL NOT NULL
		CONSTRAINT pk_table_output_step_1
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

CREATE TABLE mdi.table_output_field
(
	step_id BIGINT NOT NULL
		CONSTRAINT fk_table_output_field_1
			REFERENCES mdi.table_output_step
			ON UPDATE RESTRICT
			ON DELETE RESTRICT
			DEFERRABLE INITIALLY DEFERRED,
	row_id BIGSERIAL NOT NULL
		CONSTRAINT pk_table_output_field_1
			PRIMARY KEY,
	database_field_name TEXT NOT NULL,
	database_stream_name TEXT NOT NULL,
	field_order NUMERIC NOT NULL
);
