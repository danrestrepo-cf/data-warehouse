--
-- EDW | permissions - clean up non-star_loan user permissions
-- https://app.asana.com/0/0/1200548116207040
--

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA log TO pentaho_logging;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA log GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO pentaho_logging;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA log TO pentaho_logging;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA log GRANT USAGE, SELECT ON SEQUENCES TO pentaho_logging;

GRANT SELECT ON ALL TABLES IN SCHEMA flyway TO readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA flyway GRANT SELECT ON TABLES TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA "flyway-permissions" TO readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA "flyway-permissions" GRANT SELECT ON TABLES TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA log TO readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA log GRANT SELECT ON TABLES TO readonly;

/*
 Grant pentaho_logging and pentaho_mdi roles to warehouse_banks_etl user
 */

GRANT pentaho_logging TO warehouse_banks_etl;
GRANT pentaho_mdi to warehouse_banks_etl;