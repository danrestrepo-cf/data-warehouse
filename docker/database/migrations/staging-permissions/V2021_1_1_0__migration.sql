GRANT USAGE ON SCHEMA staging_compliance TO dmi;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON staging_compliance.nmls_call_report_national
                                                , staging_compliance.nmls_call_report_s540a
                                                , staging_compliance.nmls_call_report_state TO dmi;
