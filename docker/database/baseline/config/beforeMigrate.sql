CREATE SCHEMA IF NOT EXISTS log;
CREATE SCHEMA IF NOT EXISTS mdi;
CREATE SCHEMA IF NOT EXISTS flyway;
CREATE SCHEMA IF NOT EXISTS "flyway-permissions";

GRANT USAGE, CREATE ON SCHEMA flyway TO deployer;
GRANT USAGE, CREATE ON SCHEMA "flyway-permissions" TO deployer;
GRANT USAGE, CREATE ON SCHEMA log TO deployer;
GRANT USAGE, CREATE ON SCHEMA mdi TO deployer;

GRANT USAGE ON SCHEMA log TO admin WITH GRANT OPTION;
GRANT USAGE ON SCHEMA mdi TO admin WITH GRANT OPTION;

/*
granting usage to readonly here since the superuser is the only user who should
be able to grant USAGE on the flyway schemas
 */
GRANT USAGE ON SCHEMA flyway TO readonly;
GRANT USAGE ON SCHEMA "flyway-permissions" TO readonly;
