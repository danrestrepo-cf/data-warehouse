--
-- SP8.2
--

ALTER TABLE staging_compliance.nmls_call_report_national RENAME COLUMN unpaid_balance to total_unpaid_balance;
ALTER TABLE staging_compliance.nmls_call_report_national RENAME COLUMN average_loan_size to average_unpaid_balance;
ALTER TABLE staging_compliance.nmls_call_report_national ADD COLUMN report_quarter text;


--
-- SP9.2
--

ALTER TABLE staging_compliance.nmls_call_report_state RENAME COLUMN unpaid_balance to total_unpaid_balance;
ALTER TABLE staging_compliance.nmls_call_report_state RENAME COLUMN average_loan_size to average_unpaid_balance;
ALTER TABLE staging_compliance.nmls_call_report_state ADD COLUMN report_quarter text;


--
-- SP10.2
--

ALTER TABLE staging_compliance.nmls_call_report_s540a RENAME COLUMN unpaid_balance to total_unpaid_balance;
ALTER TABLE staging_compliance.nmls_call_report_s540a RENAME COLUMN average_loan_size to average_unpaid_balance;
ALTER TABLE staging_compliance.nmls_call_report_s540a ADD COLUMN report_quarter text;
