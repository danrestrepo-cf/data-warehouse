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


create table mdi.process
(
	pr_process_name text not null
		constraint process_pk
			primary key,
	pr_sp_name text,
	pr_description text,
	pr_last_updated timestamp with time zone default now() not null
);



create unique index process_pr_process_name_uindex
	on mdi.process (pr_process_name);

create table mdi.step_metadata_csv_file_input
(
	smcfi_step_definition_id bigserial not null
		constraint step_csv_file_input_pk
			primary key,
	smcfi_filename text,
	smcfi_header_present text,
	smcfi_csv_delimiter text,
	smcfi_enclosure text,
	smcfi_buffersize integer,
	smcfi_lazy_conversion text,
	smcfi_newline_possible text,
	smcfi_add_filename_result text,
	smcfi_file_format text,
	smcfi_file_encoding text,
	smcfi_include_filename text,
	smcfi_process_in_parallel text,
	smcfi_process_name text,
	smcfi_filename_field text,
	smcfi_row_num_field text
);



create table mdi.row_metadata_csv_file_input
(
	rmcfi_row_definition_id bigserial not null
		constraint step_data_csv_file_input_pk
			primary key,
	rmcfi_field_name text,
	rmcfi_field_type text,
	rmcfi_field_format text,
	rmcfi_field_length text,
	rmcfi_field_precision text,
	rmcfi_field_currency text,
	rmcfi_field_decimal text,
	rmcfi_field_group text,
	rmcfi_field_trim_type text,
	rmcfi_step_definition_id bigserial not null,
	rmcfi_field_order numeric not null
);



create table mdi.step_metadata_table_output
(
	smto_step_definition_id bigserial not null
		constraint step_definition_table_output_pk
			primary key,
	smto_target_schema text,
	smto_target_table text,
	smto_commit_size text,
	smto_partitioning_field text,
	smto_table_name_field text,
	smto_auto_generated_key_field text,
	smto_partition_data_per text,
	smto_table_name_defined_in_field text,
	smto_return_auto_generated_key_field text,
	smto_truncate_table text,
	smto_connectionname text,
	smto_partition_over_tables text,
	smto_specify_database_fields text,
	smto_ignore_insert_errors text,
	smto_use_batch_update text,
	smto_process_name text
);



create table mdi.row_metadata_table_output
(
	rmto_row_definition_id bigserial not null
		constraint step_data_table_output_pk
			primary key,
	rmto_field_name_in_db text,
	rmto_field_name_in_stream text,
	rmto_step_definition_id bigint,
	rmto_field_order numeric not null
);



create table mdi.step_metadata_excel_input
(
	smei_step_id bigserial not null
		constraint step_metadata_excel_input_pk
			primary key,
	smei_spreadsheet_type text,
	smei_process_name text not null,
	smei_filename text,
	smei_filemask text,
	smei_exclude_filemask text,
	smei_file_required text,
	smei_include_subfolders text,
	smei_sheet_name text,
	smei_sheet_start_row integer,
	smei_sheet_start_col integer
);



create unique index step_metadata_excel_input_smei_step_id_uindex
	on mdi.step_metadata_excel_input (smei_step_id);

create table mdi.row_metadata_excel_input
(
	rmei_row_definition_id bigserial not null
		constraint row_metadata_excel_input_pk
			primary key,
	rmei_field_name text,
	rmei_field_type text,
	rmei_field_format text,
	rmei_field_length text,
	rmei_field_precision text,
	rmei_field_currency text,
	rmei_field_decimal text,
	rmei_field_group text,
	rmei_field_trim_type text,
	rmei_step_definition_id bigserial not null,
	rmei_field_order numeric
);



