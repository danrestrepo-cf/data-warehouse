--
-- EDW | Fix staging.star_common permission issue from release 2021.6.4.3 (https://app.asana.com/0/0/1200519541777156/)
--

GRANT USAGE ON star_common TO etl_loan;

GRANT SELECT ON ALL TABLES IN SCHEMA star_common TO etl_loan;

ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA star_common GRANT SELECT ON TABLES TO etl_loan;
