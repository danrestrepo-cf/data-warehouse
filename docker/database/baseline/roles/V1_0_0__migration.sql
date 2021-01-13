-- These users are created in terraform.  Their permissions are managed in the permissions migrations
-- CREATE USER IF NOT EXISTS admin;
-- CREATE USER IF NOT EXISTS deployer;
CREATE USER readonly PASSWORD 'testonly';

-- allow login
CREATE USER encompass_sp6 PASSWORD 'testonly';
CREATE USER dmi PASSWORD 'testonly';

CREATE ROLE pentaho_logging;
CREATE ROLE pentaho_mdi;

GRANT pentaho_logging TO encompass_sp6, dmi;
GRANT pentaho_mdi TO dmi;
