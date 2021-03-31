--
-- EDW | NMLS Call Report State table | Rename average_loan_size column, affected views
-- (https://app.asana.com/0/0/1200094798056228)
--

-- Drop nmls_call_report_state view
DROP VIEW IF EXISTS octane_data_mart.nmls_call_report_state;

-- Rename average_loan_size column in view's source table
ALTER TABLE staging_compliance.nmls_call_report_state
    RENAME COLUMN average_loan_size TO average_unpaid_balance;

-- Re-create view with updated column name
CREATE VIEW octane_data_mart.nmls_call_report_state(mcr_field_id, mcr_description, state_type, total_unpaid_balance_amount, loan_count, average_unpaid_balance_amount, report_quarter) AS
SELECT nmls_call_report_state.mcr_field_id,
       nmls_call_report_state.mcr_description,
       nmls_call_report_state.state_type,
       nmls_call_report_state.total_unpaid_balance AS total_unpaid_balance_amount,
       nmls_call_report_state.loan_count,
       nmls_call_report_state.average_unpaid_balance AS average_unpaid_balance_amount,
       nmls_call_report_state.report_quarter
FROM staging_compliance.nmls_call_report_state;

