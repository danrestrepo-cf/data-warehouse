-- all schemas in the ingress db should be created in this file
-- if a new schema is created you need to work with devops to create the schema in QA/Prod
CREATE SCHEMA IF NOT EXISTS encompass;
CREATE SCHEMA IF NOT EXISTS dmi;
CREATE SCHEMA IF NOT EXISTS test; -- created for MDI unit tests
CREATE SCHEMA IF NOT EXISTS flyway;
CREATE SCHEMA IF NOT EXISTS "flyway-permissions";

GRANT USAGE, CREATE ON SCHEMA flyway TO deployer;
GRANT USAGE, CREATE ON SCHEMA "flyway-permissions" TO deployer;
GRANT USAGE, CREATE ON SCHEMA encompass TO deployer;
GRANT USAGE, CREATE ON SCHEMA dmi TO deployer;
GRANT USAGE, CREATE ON SCHEMA test TO deployer;

GRANT USAGE ON SCHEMA encompass TO admin WITH GRANT OPTION;
GRANT USAGE ON SCHEMA dmi TO admin WITH GRANT OPTION;
GRANT USAGE ON SCHEMA test TO admin WITH GRANT OPTION;

/*
granting usage to readonly here since the superuser is the only user who should
be able to grant USAGE on the flyway schemas
 */
GRANT USAGE ON SCHEMA flyway TO readonly;
GRANT USAGE ON SCHEMA "flyway-permissions" TO readonly;
