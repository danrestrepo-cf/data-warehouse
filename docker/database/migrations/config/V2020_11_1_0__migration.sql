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
-- create schema mdi
CREATE TYPE mdi.PENTAHO_FIELD_TYPE AS ENUM ('String', 'Date', 'Integer', 'Number', 'BigNumber', 'Binary', 'Timestamp', 'Internet Address');
CREATE TYPE mdi.PENTAHO_FIELD_CURRENCY AS ENUM ('$');
CREATE TYPE mdi.PENTAHO_FIELD_DECIMAL AS ENUM ('.');
CREATE TYPE mdi.PENTAHO_TRIM_TYPE AS ENUM ('both', 'right', 'left', 'none');
CREATE TYPE mdi.PENTAHO_Y_OR_N AS ENUM ('Y', 'N');
CREATE TYPE mdi.PENTAHO_SPREADSHEET_TYPE AS ENUM ('JXL', 'POI', 'SAX_POI', 'ODS');
CREATE TYPE mdi.PENTAHO_FIELD_FORMAT AS ENUM ('mixed', 'DOS', 'Unix');
CREATE TYPE mdi.PENTAHO_DB_CONNECTION_NAME AS ENUM ('Ingress DB Connection', 'Config DB Connection', 'Staging DB Connection');

create table mdi.process
(
	dwid BIGSERIAL
		constraint pk_process
			primary key,
	name text not null,
	description text not null
);

create unique index process_description_uindex
	on mdi.process (description);

create unique index process_name_uindex
	on mdi.process (name);


CREATE TABLE mdi.csv_file_input_step
(
	process_dwid BIGINT NOT NULL
		CONSTRAINT fk_csv_file_input_step_1
			REFERENCES mdi.process
			ON UPDATE RESTRICT
			ON DELETE RESTRICT
			DEFERRABLE INITIALLY DEFERRED,
	dwid BIGSERIAL NOT NULL
		CONSTRAINT pk_csv_file_input_step
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
	csv_file_input_step_dwid BIGSERIAL NOT NULL
		CONSTRAINT fk_csv_file_input_field_1
			REFERENCES mdi.csv_file_input_step
			ON UPDATE RESTRICT
			ON DELETE RESTRICT
			DEFERRABLE INITIALLY DEFERRED,
	dwid BIGSERIAL NOT NULL
		CONSTRAINT pk_csv_file_input_field
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
	process_dwid BIGINT NOT NULL
		CONSTRAINT fk_microsoft_excel_input_step_1
			REFERENCES mdi.process
			ON UPDATE RESTRICT
			ON DELETE RESTRICT
			DEFERRABLE INITIALLY DEFERRED,
	dwid BIGSERIAL NOT NULL
		CONSTRAINT pk_microsoft_excel_input_step
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
	microsoft_excel_input_step_dwid BIGINT NOT NULL
		CONSTRAINT fk_microsoft_excel_input_field_1
			REFERENCES mdi.microsoft_excel_input_step
			ON UPDATE RESTRICT
			ON DELETE RESTRICT
			DEFERRABLE INITIALLY DEFERRED,
	dwid BIGSERIAL NOT NULL
		CONSTRAINT pk_microsoft_excel_input_field
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
	process_dwid BIGINT NOT NULL
		CONSTRAINT fk_table_output_step_1
			REFERENCES mdi.process
			ON UPDATE RESTRICT
			ON DELETE RESTRICT
			DEFERRABLE INITIALLY DEFERRED,
	dwid BIGSERIAL NOT NULL
		CONSTRAINT pk_table_output_step
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
	table_output_step_dwid BIGINT NOT NULL
		CONSTRAINT fk_table_output_field_1
			REFERENCES mdi.table_output_step
			ON UPDATE RESTRICT
			ON DELETE RESTRICT
			DEFERRABLE INITIALLY DEFERRED,
	dwid BIGSERIAL NOT NULL
		CONSTRAINT pk_table_output_field
			PRIMARY KEY,
	database_field_name TEXT NOT NULL,
	database_stream_name TEXT NOT NULL,
	field_order NUMERIC NOT NULL
);

--
-- MDI configs for SP8.1
--
INSERT
INTO mdi.process (dwid, name, description)
VALUES
(1, 'SP8.1', 'Load DMI NMLS Call Report to ingress raw table - state');

INSERT
INTO mdi.csv_file_input_step ( process_dwid, dwid, filename, header_present, delimiter, enclosure, buffersize
							 , lazy_conversion, newline_possible, add_filename_result, file_format, file_encoding
							 , include_filename, process_in_parallel, filename_field, row_num_field)
VALUES
(1, 1, '\input\dmi-V35-state.csv', 'Y', ',', '"', 1024, 'N', 'N', 'N', 'mixed', 'UTF-8', 'N', 'Y', NULL, NULL);

INSERT
INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, dwid, field_name, field_type, field_format, field_length
							  , field_precision
							  , field_currency, field_decimal, field_group, field_trim_type, field_order)
VALUES
(1, 2, 'mcr_desc', 'String', '', -1, -1, '$', '.', ',', 'none', 2);
INSERT
INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, dwid, field_name, field_type, field_format, field_length
							  , field_precision
							  , field_currency, field_decimal, field_group, field_trim_type, field_order)
VALUES
(1, 3, 'state_type', 'String', '', -1, -1, '$', '.', ',', 'none', 3);
INSERT
INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, dwid, field_name, field_type, field_format, field_length
							  , field_precision
							  , field_currency, field_decimal, field_group, field_trim_type, field_order)
VALUES
(1, 1, 'mcr_code', 'String', '', -1, -1, '$', '.', ',', 'none', 1);
INSERT
INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, dwid, field_name, field_type, field_format, field_length
							  , field_precision
							  , field_currency, field_decimal, field_group, field_trim_type, field_order)
VALUES
(1, 6, 'avg_loan_size', 'Number', '#', -1, -1, '$', '.', ',', 'none', 6);
INSERT
INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, dwid, field_name, field_type, field_format, field_length
							  , field_precision
							  , field_currency, field_decimal, field_group, field_trim_type, field_order)
VALUES
(1, 4, 'unpaid_balance', 'Number', '#', -1, -1, '$', '.', ',', 'none', 4);
INSERT
INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, dwid, field_name, field_type, field_format, field_length
							  , field_precision
							  , field_currency, field_decimal, field_group, field_trim_type, field_order)
VALUES
(1, 5, 'loan_count', 'Integer', '#', -1, -1, '$', '.', ',', 'none', 5);

INSERT
INTO mdi.table_output_step ( process_dwid, dwid, target_schema, target_table, commit_size, partitioning_field
						   , table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field
						   , return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables
						   , specify_database_fields, ignore_insert_errors, use_batch_update)
VALUES
( 1, 1, 'dmi', 'nmls_call_report_state_raw', 1000, NULL, NULL, NULL, NULL, 'N', NULL, 'Y', 'Ingress DB Connection', 'N', 'Y', 'N', 'N');

INSERT
INTO mdi.table_output_field (table_output_step_dwid, dwid, database_field_name, database_stream_name, field_order)
VALUES
(1, 1, 'mcr_code', 'mcr_code', 1);
INSERT
INTO mdi.table_output_field (table_output_step_dwid, dwid, database_field_name, database_stream_name, field_order)
VALUES
(1, 2, 'mcr_desc', 'mcr_desc', 2);
INSERT
INTO mdi.table_output_field (table_output_step_dwid, dwid, database_field_name, database_stream_name, field_order)
VALUES
(1, 3, 'state_type', 'state_type', 3);
INSERT
INTO mdi.table_output_field (table_output_step_dwid, dwid, database_field_name, database_stream_name, field_order)
VALUES
(1, 4, 'unpaid_balance', 'unpaid_balance', 4);
INSERT
INTO mdi.table_output_field (table_output_step_dwid, dwid, database_field_name, database_stream_name, field_order)
VALUES
(1, 5, 'loan_count', 'loan_count', 5);
INSERT
INTO mdi.table_output_field (table_output_step_dwid, dwid, database_field_name, database_stream_name, field_order)
VALUES
(1, 6, 'avg_loan_size', 'avg_loan_size', 6);
INSERT
INTO mdi.table_output_field (table_output_step_dwid, dwid, database_field_name, database_stream_name, field_order)
VALUES
(1, 7, 'etl_batch_id', 'etl_batch_id', 7);


--
-- MDI configs for SP10.1
--
INSERT
INTO mdi.process (dwid, name, description)
VALUES
(3, 'SP10.1', 'Load DMI NMLS Call Report to ingress raw table - S540a');


INSERT
INTO mdi.microsoft_excel_input_step ( process_dwid, dwid, spreadsheet_type, filename, filemask, exclude_filemask
									, file_required, include_subfolders, sheet_name, sheet_start_row, sheet_start_col)
VALUES
(3, 1, 'POI', 'c:\input\dmi-V35.xls', NULL, NULL, 'Y', 'N', 'S540A Layout #2', 5, 0);
INSERT
INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, dwid, field_name, field_type, field_format
									 , field_length, field_precision, field_currency, field_decimal, field_group
									 , field_trim_type, field_order)
VALUES
(1, 2, 'ItemId', 'Integer', NULL, NULL, NULL, '$', '.', ',', 'none', 2);
INSERT
INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, dwid, field_name, field_type, field_format
									 , field_length, field_precision, field_currency, field_decimal, field_group
									 , field_trim_type, field_order)
VALUES
(1, 3, 'ServicerID', 'Integer', NULL, NULL, NULL, '$', '.', ',', 'none', 3);
INSERT
INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, dwid, field_name, field_type, field_format
									 , field_length, field_precision, field_currency, field_decimal, field_group
									 , field_trim_type, field_order)
VALUES
(1, 6, 'UPB', 'Number', NULL, 17, 2, '$', '.', ',', 'none', 6);
INSERT
INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, dwid, field_name, field_type, field_format
									 , field_length, field_precision, field_currency, field_decimal, field_group
									 , field_trim_type, field_order)
VALUES
(1, 7, 'LoanCount', 'Integer', NULL, NULL, NULL, '$', '.', ',', 'none', 7);
INSERT
INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, dwid, field_name, field_type, field_format
									 , field_length, field_precision, field_currency, field_decimal, field_group
									 , field_trim_type, field_order)
VALUES
(1, 1, 'STATE', 'String', NULL, NULL, -1, '$', '.', ',', 'none', 1);
INSERT
INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, dwid, field_name, field_type, field_format
									 , field_length, field_precision, field_currency, field_decimal, field_group
									 , field_trim_type, field_order)
VALUES
(1, 5, 'POOL #', 'String', NULL, NULL, -1, '$', '.', ',', 'none', 5);
INSERT
INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, dwid, field_name, field_type, field_format
									 , field_length, field_precision, field_currency, field_decimal, field_group
									 , field_trim_type, field_order)
VALUES
(1, 4, 'ServicerName', 'String', NULL, NULL, -1, '$', '.', ',', 'none', 4);



INSERT
INTO mdi.table_output_step ( process_dwid, dwid, target_schema, target_table, commit_size, partitioning_field
						   , table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field
						   , return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables
						   , specify_database_fields, ignore_insert_errors, use_batch_update)
VALUES
(3, 2, 'dmi', 'nmls_call_report_s540a_raw', 1000, NULL, NULL, NULL, NULL, 'N', NULL, 'Y'
, 'Ingress DB Connection', 'N', 'Y', 'N', 'N');

INSERT
INTO mdi.table_output_field (table_output_step_dwid, dwid, database_field_name, database_stream_name, field_order)
VALUES
(2, 8, 'state_type', 'STATE', 1);
INSERT
INTO mdi.table_output_field (table_output_step_dwid, dwid, database_field_name, database_stream_name, field_order)
VALUES
(2, 9, 'item_id', 'ItemId', 2);
INSERT
INTO mdi.table_output_field (table_output_step_dwid, dwid, database_field_name, database_stream_name, field_order)
VALUES
(2, 10, 'servicer_id', 'ServicerID', 3);
INSERT
INTO mdi.table_output_field (table_output_step_dwid, dwid, database_field_name, database_stream_name, field_order)
VALUES
(2, 11, 'servicer_name', 'ServicerName', 4);
INSERT
INTO mdi.table_output_field (table_output_step_dwid, dwid, database_field_name, database_stream_name, field_order)
VALUES
(2, 12, 'pool_number', 'POOL #', 5);
INSERT
INTO mdi.table_output_field (table_output_step_dwid, dwid, database_field_name, database_stream_name, field_order)
VALUES
(2, 13, 'unpaid_balance', 'UPB', 6);
INSERT
INTO mdi.table_output_field (table_output_step_dwid, dwid, database_field_name, database_stream_name, field_order)
VALUES
(2, 14, 'loan_count', 'LoanCount', 7);
INSERT
INTO mdi.table_output_field (table_output_step_dwid, dwid, database_field_name, database_stream_name, field_order)
VALUES
(2, 15, 'etl_batch_id', 'etl_batch_id', 8);
