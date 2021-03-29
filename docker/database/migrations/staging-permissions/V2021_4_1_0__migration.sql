--
-- EDW - update DMS permissions to apply to future tables (https://app.asana.com/0/0/1200119921931317)
--

ALTER DEFAULT PRIVILEGES IN SCHEMA staging_octane GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON TABLES TO dms_octane_writer;
