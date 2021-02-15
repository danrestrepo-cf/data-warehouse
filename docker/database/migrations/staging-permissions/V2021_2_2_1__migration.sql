--
-- EDW | Recreate PostgreSQL permissions for dropped/created tables in EDW (https://app.asana.com/0/0/1199933501989661/)
--
GRANT SELECT ON
    staging_compliance.nmls_call_report_national
    , staging_compliance.nmls_call_report_s540a
    , staging_compliance.nmls_call_report_state TO readonly;

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON
    staging_compliance.nmls_call_report_national
    , staging_compliance.nmls_call_report_s540a
    , staging_compliance.nmls_call_report_state TO dmi;
