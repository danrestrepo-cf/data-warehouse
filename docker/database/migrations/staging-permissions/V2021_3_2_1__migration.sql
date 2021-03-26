-- BI - add a octane_dms_control schema and grant the existing user full DDL, readwrite permissions:
-- (https://app.asana.com/0/0/1200118824180563)

GRANT USAGE ON SCHEMA octane_dms_control TO dms_octane_writer;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA octane_dms_control TO dms_octane_writer;