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
ALTER TABLE dmi.nmls_call_report_national_raw RENAME TO nmls_call_report_national;
ALTER TABLE dmi.nmls_call_report_national DROP COLUMN mcr_code;
ALTER TABLE dmi.nmls_call_report_national DROP COLUMN mcr_desc;
ALTER TABLE dmi.nmls_call_report_national DROP COLUMN unpaid_balance;
ALTER TABLE dmi.nmls_call_report_national DROP COLUMN loan_count;
ALTER TABLE dmi.nmls_call_report_national DROP COLUMN avg_loan_size;
ALTER TABLE dmi.nmls_call_report_national DROP COLUMN etl_batch_id;

ALTER TABLE dmi.nmls_call_report_national ADD COLUMN etl_batch_id TEXT;
ALTER TABLE dmi.nmls_call_report_national ADD COLUMN data_source_dwid TEXT;
ALTER TABLE dmi.nmls_call_report_national ADD COLUMN input_filename TEXT;
ALTER TABLE dmi.nmls_call_report_national ADD COLUMN mcr_code TEXT;
ALTER TABLE dmi.nmls_call_report_national ADD COLUMN mcr_description TEXT;
ALTER TABLE dmi.nmls_call_report_national ADD COLUMN sum_of_upb NUMERIC;
ALTER TABLE dmi.nmls_call_report_national ADD COLUMN loan_count INTEGER;
ALTER TABLE dmi.nmls_call_report_national ADD COLUMN avg_loan_size NUMERIC;
ALTER TABLE dmi.nmls_call_report_national ADD COLUMN report_quarter TEXT;


--
-- SP10.1
--
ALTER TABLE dmi.nmls_call_report_s540a_raw RENAME TO nmls_call_report_s540a;
ALTER TABLE dmi.nmls_call_report_s540a DROP COLUMN state_type;
ALTER TABLE dmi.nmls_call_report_s540a DROP COLUMN pool_number;
ALTER TABLE dmi.nmls_call_report_s540a DROP COLUMN unpaid_balance;
ALTER TABLE dmi.nmls_call_report_s540a DROP COLUMN item_id;
ALTER TABLE dmi.nmls_call_report_s540a DROP COLUMN servicer_id;
ALTER TABLE dmi.nmls_call_report_s540a DROP COLUMN servicer_name;
ALTER TABLE dmi.nmls_call_report_s540a DROP COLUMN loan_count;
ALTER TABLE dmi.nmls_call_report_s540a DROP COLUMN etl_batch_id;

ALTER TABLE dmi.nmls_call_report_s540a ADD COLUMN etl_batch_id TEXT;
ALTER TABLE dmi.nmls_call_report_s540a ADD COLUMN data_source_dwid INTEGER;
ALTER TABLE dmi.nmls_call_report_s540a ADD COLUMN input_filename TEXT;
ALTER TABLE dmi.nmls_call_report_s540a ADD COLUMN "state" TEXT;
ALTER TABLE dmi.nmls_call_report_s540a add COLUMN item_id INTEGER;
ALTER TABLE dmi.nmls_call_report_s540a add COLUMN servicer_id INTEGER;
ALTER TABLE dmi.nmls_call_report_s540a ADD COLUMN servicer_name TEXT;
ALTER TABLE dmi.nmls_call_report_s540a ADD COLUMN pool_no TEXT;
ALTER TABLE dmi.nmls_call_report_s540a ADD COLUMN upb NUMERIC;
ALTER TABLE dmi.nmls_call_report_s540a ADD COLUMN loan_count INTEGER;
ALTER TABLE dmi.nmls_call_report_s540a ADD COLUMN avg_loan_size NUMERIC;
ALTER TABLE dmi.nmls_call_report_s540a ADD COLUMN report_quarter TEXT;
