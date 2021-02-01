CREATE SCHEMA IF NOT EXISTS test;

create table test.sp_01
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

create table test.sp_02
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
