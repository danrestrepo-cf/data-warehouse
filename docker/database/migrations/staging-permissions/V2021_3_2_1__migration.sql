-- BI - add a octane_dms_control schema and grant the existing user full DDL, readwrite permissions:
-- (https://app.asana.com/0/0/1200118824180563)

GRANT USAGE ON SCHEMA octane_dms_control TO dms_octane_writer;
ALTER DEFAULT PRIVILEGES IN SCHEMA octane_dms_control GRANT ALL PRIVILEGES ON TABLES TO dms_octane_writer;

GRANT USAGE ON SCHEMA octane_dms_control TO readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA octane_dms_control GRANT SELECT ON TABLES TO readonly;
