--
-- EDW | Update SP8.2, SP9.2, SP10.2 to not truncate target tables and update data types for monetary value fields
-- (https://app.asana.com/0/0/1200180166290103)
--

ALTER TABLE dmi.nmls_call_report_national
    ALTER COLUMN sum_of_upb TYPE NUMERIC(21,3)
    , ALTER COLUMN avg_loan_size TYPE NUMERIC (21,3);

ALTER TABLE dmi.nmls_call_report_state
    ALTER COLUMN sum_of_upb TYPE NUMERIC(21,3)
    , ALTER COLUMN avg_loan_size TYPE NUMERIC(21,3);

ALTER TABLE dmi.nmls_call_report_s540a
    ALTER COLUMN upb TYPE NUMERIC(21,3)
    , ALTER COLUMN avg_loan_size TYPE NUMERIC(21,3);
