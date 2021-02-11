--
-- EDW - Modify DMI NMLS Call Report processes (SP8/SP9/SP10) to add report_quarter and filename columns (https://app.asana.com/0/0/1199603976631072)
--

--
-- SP8.1
--
ALTER TABLE dmi.nmls_call_report_state_raw RENAME TO nmls_call_report_state;

ALTER TABLE dmi.nmls_call_report_state DROP COLUMN unpaid_balance;
ALTER TABLE dmi.nmls_call_report_state DROP COLUMN state_type;
ALTER TABLE dmi.nmls_call_report_state DROP COLUMN mcr_code;
ALTER TABLE dmi.nmls_call_report_state DROP COLUMN mcr_desc;
ALTER TABLE dmi.nmls_call_report_state DROP COLUMN loan_count;
ALTER TABLE dmi.nmls_call_report_state DROP COLUMN avg_loan_size;
ALTER TABLE dmi.nmls_call_report_state DROP COLUMN etl_batch_id;

ALTER TABLE dmi.nmls_call_report_state ADD COLUMN etl_batch_id TEXT;
ALTER TABLE dmi.nmls_call_report_state ADD COLUMN data_source_dwid BIGINT;
ALTER TABLE dmi.nmls_call_report_state ADD COLUMN input_filename TEXT;
ALTER TABLE dmi.nmls_call_report_state ADD COLUMN mcr_code TEXT;
ALTER TABLE dmi.nmls_call_report_state ADD COLUMN mcr_description TEXT;
ALTER TABLE dmi.nmls_call_report_state ADD COLUMN state_code TEXT;
ALTER TABLE dmi.nmls_call_report_state ADD COLUMN sum_of_upb NUMERIC;
ALTER TABLE dmi.nmls_call_report_state ADD COLUMN loan_count INTEGER;
ALTER TABLE dmi.nmls_call_report_state ADD COLUMN avg_loan_size NUMERIC;
ALTER TABLE dmi.nmls_call_report_state ADD COLUMN report_quarter TEXT;


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
