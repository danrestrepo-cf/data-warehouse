--
-- EDW | permissions - Grant etl_loan user required permissions on star_loan sequences
-- https://app.asana.com/0/0/1200519541777137
--

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA star_loan TO etl_loan;

ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA star_loan GRANT USAGE, SELECT
    ON SEQUENCES TO etl_loan;
