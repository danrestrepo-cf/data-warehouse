--
-- EDW | permissions - clean up non-star_loan user permissions
-- https://app.asana.com/0/0/1200548116207040
--

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA dmi TO dmi;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA dmi GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON TABLES TO dmi;

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA encompass TO encompass_sp6;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA encompass GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON TABLES TO encompass_sp6;

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA test TO mditest;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA test GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON TABLES TO mditest;

GRANT SELECT ON ALL TABLES IN SCHEMA flyway TO readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA flyway GRANT SELECT ON TABLES TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA "flyway-permissions" TO readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA "flyway-permissions" GRANT SELECT ON TABLES TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA dmi TO readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA dmi GRANT SELECT ON TABLES TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA encompass TO readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA encompass GRANT SELECT ON TABLES TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA test TO readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA test GRANT SELECT ON TABLES TO readonly;

-- Grant permissions for warehouse_banks schema

-- warehouse_banks_etl permissions
GRANT USAGE ON SCHEMA warehouse_banks TO warehouse_banks_etl;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA warehouse_banks TO warehouse_banks_etl;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA warehouse_banks GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON TABLES TO warehouse_banks_etl;

-- readonly permissions
GRANT USAGE ON SCHEMA warehouse_banks TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA warehouse_banks TO readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA warehouse_banks GRANT SELECT ON TABLES TO readonly;

-- deploy permissions
GRANT USAGE, CREATE ON SCHEMA warehouse_banks to deployer;

-- admin permissions
GRANT USAGE ON SCHEMA warehouse_banks to admin;
