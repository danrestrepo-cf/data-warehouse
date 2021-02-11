--
-- EDW - Modify DMI NMLS Call Report processes (SP8/SP9/SP10) to add report_quarter and filename columns (https://app.asana.com/0/0/1199603976631072)
--

--
-- SP8.1
--
DROP TABLE dmi.nmls_call_report_state_raw;
CREATE TABLE dmi.nmls_call_report_state
(
    etl_batch_id TEXT,
    data_source_dwid BIGINT,
    input_filename TEXT,
    mcr_code TEXT,
    mcr_description TEXT,
    state_code TEXT,
    sum_of_upb NUMERIC,
    loan_count INTEGER,
    avg_loan_size NUMERIC,
    report_quarter TEXT
);


--
-- SP9.1
--
DROP TABLE dmi.nmls_call_report_national_raw;
CREATE TABLE dmi.nmls_call_report_national
(
    etl_batch_id text,
    data_source_dwid BIGINT,
    input_filename text,
    mcr_code text,
    mcr_description text,
    sum_of_upb numeric,
    loan_count integer,
    avg_loan_size numeric,
    report_quarter text
);


--
-- SP10.1
--
DROP TABLE dmi.nmls_call_report_s540a_raw;
CREATE TABLE dmi.nmls_call_report_s540a
(
    etl_batch_id text,
    data_source_dwid BIGINT,
    input_filename text,
    state text,
    item_id integer,
    servicer_id integer,
    servicer_name text,
    pool_no text,
    upb numeric,
    loan_count integer,
    avg_loan_size numeric,
    report_quarter text
);
