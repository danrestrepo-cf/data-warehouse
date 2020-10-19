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


CREATE TABLE mdi.process
(
	pr_process_name TEXT NOT NULL
		CONSTRAINT process_pk
			PRIMARY KEY,
	pr_sp_name TEXT,
	pr_description TEXT,
	pr_last_updated TIMESTAMP WITH TIME ZONE DEFAULT now( ) NOT NULL
);



CREATE UNIQUE INDEX process_pr_process_name_uindex
	ON mdi.process (pr_process_name);

CREATE TABLE mdi.step_metadata_csv_file_input
(
	smcfi_step_definition_id BIGSERIAL NOT NULL
		CONSTRAINT step_csv_file_input_pk
			PRIMARY KEY,
	smcfi_filename TEXT,
	smcfi_header_present TEXT,
	smcfi_csv_delimiter TEXT,
	smcfi_enclosure TEXT,
	smcfi_buffersize INTEGER,
	smcfi_lazy_conversion TEXT,
	smcfi_newline_possible TEXT,
	smcfi_add_filename_result TEXT,
	smcfi_file_format TEXT,
	smcfi_file_encoding TEXT,
	smcfi_include_filename TEXT,
	smcfi_process_in_parallel TEXT,
	smcfi_process_name TEXT,
	smcfi_filename_field TEXT,
	smcfi_row_num_field TEXT
);



CREATE TABLE mdi.row_metadata_csv_file_input
(
	rmcfi_row_definition_id BIGSERIAL NOT NULL
		CONSTRAINT step_data_csv_file_input_pk
			PRIMARY KEY,
	rmcfi_field_name TEXT,
	rmcfi_field_type TEXT,
	rmcfi_field_format TEXT,
	rmcfi_field_length TEXT,
	rmcfi_field_precision TEXT,
	rmcfi_field_currency TEXT,
	rmcfi_field_decimal TEXT,
	rmcfi_field_group TEXT,
	rmcfi_field_trim_type TEXT,
	rmcfi_step_definition_id BIGSERIAL NOT NULL,
	rmcfi_field_order NUMERIC NOT NULL
);



CREATE TABLE mdi.step_metadata_table_output
(
	smto_step_definition_id BIGSERIAL NOT NULL
		CONSTRAINT step_definition_table_output_pk
			PRIMARY KEY,
	smto_target_schema TEXT,
	smto_target_table TEXT,
	smto_commit_size TEXT,
	smto_partitioning_field TEXT,
	smto_table_name_field TEXT,
	smto_auto_generated_key_field TEXT,
	smto_partition_data_per TEXT,
	smto_table_name_defined_in_field TEXT,
	smto_return_auto_generated_key_field TEXT,
	smto_truncate_table TEXT,
	smto_connectionname TEXT,
	smto_partition_over_tables TEXT,
	smto_specify_database_fields TEXT,
	smto_ignore_insert_errors TEXT,
	smto_use_batch_update TEXT,
	smto_process_name TEXT
);



CREATE TABLE mdi.row_metadata_table_output
(
	rmto_row_definition_id BIGSERIAL NOT NULL
		CONSTRAINT step_data_table_output_pk
			PRIMARY KEY,
	rmto_field_name_in_db TEXT,
	rmto_field_name_in_stream TEXT,
	rmto_step_definition_id BIGINT,
	rmto_field_order NUMERIC NOT NULL
);



CREATE TABLE mdi.step_metadata_excel_input
(
	smei_step_id BIGSERIAL NOT NULL
		CONSTRAINT step_metadata_excel_input_pk
			PRIMARY KEY,
	smei_spreadsheet_type TEXT,
	smei_process_name TEXT NOT NULL,
	smei_filename TEXT,
	smei_filemask TEXT,
	smei_exclude_filemask TEXT,
	smei_file_required TEXT,
	smei_include_subfolders TEXT,
	smei_sheet_name TEXT,
	smei_sheet_start_row INTEGER,
	smei_sheet_start_col INTEGER
);



CREATE UNIQUE INDEX step_metadata_excel_input_smei_step_id_uindex
	ON mdi.step_metadata_excel_input (smei_step_id);

CREATE TABLE mdi.row_metadata_excel_input
(
	rmei_row_definition_id BIGSERIAL NOT NULL
		CONSTRAINT row_metadata_excel_input_pk
			PRIMARY KEY,
	rmei_field_name TEXT,
	rmei_field_type TEXT,
	rmei_field_format TEXT,
	rmei_field_length TEXT,
	rmei_field_precision TEXT,
	rmei_field_currency TEXT,
	rmei_field_decimal TEXT,
	rmei_field_group TEXT,
	rmei_field_trim_type TEXT,
	rmei_step_definition_id BIGSERIAL NOT NULL,
	rmei_field_order NUMERIC
);



