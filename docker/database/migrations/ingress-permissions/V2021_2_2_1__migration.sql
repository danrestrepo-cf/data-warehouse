--
-- EDW | Recreate PostgreSQL permissions for dropped/created tables in EDW (https://app.asana.com/0/0/1199933501989661/)
--
GRANT SELECT ON
    dmi.nmls_call_report_national
    , dmi.nmls_call_report_s540a
    , dmi.nmls_call_report_state TO readonly;

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON
    dmi.nmls_call_report_national
    , dmi.nmls_call_report_s540a
    , dmi.nmls_call_report_state TO dmi;
