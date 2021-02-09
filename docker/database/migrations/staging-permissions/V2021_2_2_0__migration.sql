GRANT USAGE ON SCHEMA staging_octane TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA staging_octane TO readonly;

GRANT USAGE ON SCHEMA staging_octane TO dms_octane_writer;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA staging_octane TO dms_octane_writer;