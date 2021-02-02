create table test.sp_0_1_mdi_csv_file_to_table
(
    imported_filename text,
    state text,
    item_id bigint,
    servicer_id bigint,
    servicer_name text,
    pool_no text,
    upb integer,
    loan_count integer,
    avg_loan_size integer,
    report_quarter text,
    etl_batch_id text
);

create table test.sp_0_2_mdi_microsoft_excel_to_table
(
    imported_filename text,
    state text,
    item_id bigint,
    servicer_id bigint,
    servicer_name text,
    pool_no text,
    upb integer,
    loan_count integer,
    avg_loan_size integer,
    report_quarter text,
    etl_batch_id text
);

-- rename tables to remove _raw
ALTER TABLE dmi.nmls_call_report_national_raw RENAME TO nmls_call_report_national;
ALTER TABLE dmi.nmls_call_report_state_raw RENAME TO nmls_call_report_state;
ALTER TABLE dmi.nmls_call_report_s540a_raw RENAME TO nmls_call_report_s540a;
