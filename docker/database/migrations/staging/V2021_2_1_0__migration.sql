ALTER TABLE staging_compliance.nmls_call_report_national ADD COLUMN imported_filename text NOT NULL;
ALTER TABLE staging_compliance.nmls_call_report_s540a ADD COLUMN imported_filename text NOT NULL;
ALTER TABLE staging_compliance.nmls_call_report_state ADD COLUMN imported_filename text NOT NULL;
