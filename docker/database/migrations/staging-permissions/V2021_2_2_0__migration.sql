GRANT USAGE ON SCHEMA staging_octane TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA staging_octane TO readonly;

GRANT USAGE ON SCHEMA staging_octane TO dms_octane_writer;
GRANT SELECT, INSERT, UPDATE, TRUNCATE, DELETE ON ALL TABLES IN SCHEMA staging_octane TO dms_octane_writer;


--
-- Expose DMI NMLS Call Report data to Octane via a view: (https://app.asana.com/0/0/1199574510798743)
--
GRANT USAGE ON SCHEMA octane_data_mart TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA octane_data_mart TO readonly;

GRANT USAGE ON SCHEMA octane_data_mart TO svc_octane;
GRANT SELECT ON ALL TABLES IN SCHEMA octane_data_mart TO svc_octane;
