CREATE SCHEMA IF NOT EXISTS star_common;
CREATE SCHEMA IF NOT EXISTS loan;
CREATE SCHEMA IF NOT EXISTS staging_compliance;
CREATE SCHEMA IF NOT EXISTS staging_octane;


--
-- Expose DMI NMLS Call Report data to Octane via a view: (https://app.asana.com/0/0/1199574510798743)
--
CREATE SCHEMA IF NOT EXISTS octane_data_mart;

-- BI - add an octane_dms_control schema: (https://app.asana.com/0/0/1200118824180563)
CREATE SCHEMA IF NOT EXISTS octane_dms_control;

--
-- EDW | Create initial star model
-- (https://app.asana.com/0/0/1199659841029429)
--
CREATE SCHEMA IF NOT EXISTS star_loan;


--
--  BI - EDW | schema history_octane - Create initial DDL (https://app.asana.com/0/0/1200124472993448)
--
CREATE SCHEMA IF NOT EXISTS history_octane
