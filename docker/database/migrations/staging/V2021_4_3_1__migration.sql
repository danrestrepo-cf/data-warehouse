--
-- EDW | Update SP8.2, SP9.2, SP10.2 to not truncate target tables and update data types for monetary value fields
-- Patch task: truncate all staging_compliace tables so that monetary data can be updated to include decimal places
-- (https://app.asana.com/0/0/1200180166290103)

TRUNCATE staging_compliance.nmls_call_report_national;
TRUNCATE staging_compliance.nmls_call_report_state;
TRUNCATE staging_compliance.nmls_call_report_s540a;
