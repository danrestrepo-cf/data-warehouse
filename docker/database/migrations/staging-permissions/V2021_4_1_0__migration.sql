--
-- EDW | NMLS Call Report State table | Rename average_loan_size column, affected views
-- (https://app.asana.com/0/0/1200094798056228)
--

-- Re-create view permissions
GRANT SELECT ON octane_data_mart.nmls_call_report_state TO readonly;
GRANT SELECT ON octane_data_mart.nmls_call_report_state TO svc_octane;