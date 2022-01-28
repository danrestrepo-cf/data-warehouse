CREATE SCHEMA IF NOT EXISTS star_common;
CREATE SCHEMA IF NOT EXISTS loan;
CREATE SCHEMA IF NOT EXISTS staging_compliance;
CREATE SCHEMA IF NOT EXISTS staging_octane;
CREATE SCHEMA IF NOT EXISTS octane_data_mart;
CREATE SCHEMA IF NOT EXISTS octane_dms_control;
CREATE SCHEMA IF NOT EXISTS star_loan;
CREATE SCHEMA IF NOT EXISTS history_octane;
CREATE SCHEMA IF NOT EXISTS flyway;
CREATE SCHEMA IF NOT EXISTS "flyway-permissions";

GRANT USAGE, CREATE ON SCHEMA flyway TO deployer;
GRANT USAGE, CREATE ON SCHEMA "flyway-permissions" TO deployer;
GRANT USAGE, CREATE ON SCHEMA loan TO deployer;
GRANT USAGE, CREATE ON SCHEMA staging_compliance TO deployer;
GRANT USAGE, CREATE ON SCHEMA octane_data_mart TO deployer;
GRANT USAGE, CREATE ON SCHEMA octane_dms_control TO deployer;
GRANT USAGE, CREATE ON SCHEMA staging_octane TO deployer;
GRANT USAGE, CREATE ON SCHEMA history_octane TO deployer;
GRANT USAGE, CREATE ON SCHEMA star_loan TO deployer;
GRANT USAGE, CREATE ON SCHEMA star_common TO deployer;

GRANT USAGE ON SCHEMA loan TO admin WITH GRANT OPTION;
GRANT USAGE ON SCHEMA staging_compliance TO admin WITH GRANT OPTION;
GRANT USAGE ON SCHEMA octane_data_mart TO admin WITH GRANT OPTION;
GRANT USAGE ON SCHEMA octane_dms_control TO admin WITH GRANT OPTION;
GRANT USAGE ON SCHEMA staging_octane TO admin WITH GRANT OPTION;
GRANT USAGE ON SCHEMA history_octane TO admin WITH GRANT OPTION;
GRANT USAGE ON SCHEMA star_loan TO admin WITH GRANT OPTION;
GRANT USAGE ON SCHEMA star_common TO admin WITH GRANT OPTION;

/*
granting usage to readonly here since the superuser is the only user who should
be able to grant USAGE on the flyway schemas
 */
GRANT USAGE ON SCHEMA flyway TO readonly;
GRANT USAGE ON SCHEMA "flyway-permissions" TO readonly;

--dms_octane_writer previously owned these tables, and admin was unable to affect permissions on them
GRANT ALL ON ALL TABLES IN SCHEMA octane_dms_control TO admin WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE dms_octane_writer IN SCHEMA octane_dms_control GRANT ALL ON TABLES TO admin WITH GRANT OPTION;
