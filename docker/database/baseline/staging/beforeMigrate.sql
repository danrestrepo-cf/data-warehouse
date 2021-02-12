CREATE SCHEMA IF NOT EXISTS star_common;
CREATE SCHEMA IF NOT EXISTS loan;
CREATE SCHEMA IF NOT EXISTS staging_compliance;
CREATE SCHEMA IF NOT EXISTS staging_octane;


--
-- Expose DMI NMLS Call Report data to Octane via a view: (https://app.asana.com/0/0/1199574510798743)
--
CREATE SCHEMA IF NOT EXISTS octane_data_mart;
