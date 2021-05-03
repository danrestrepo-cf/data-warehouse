--
-- EDW User Permissions | Create PostgreSQL user to run MDI configs for loan data
-- https://app.asana.com/0/0/1200279714721251
--

-- Usage on schemas
GRANT USAGE ON SCHEMA staging_octane, history_octane, star_loan TO etl_loan;

-- SELECT on existing tables in staging_octane
GRANT SELECT ON ALL TABLES IN SCHEMA staging_octane TO etl_loan;

-- SELECT on future tables in staging_octane
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA staging_octane GRANT SELECT ON TABLES TO etl_loan;

-- SELECT, INSERT, UPDATE, on existing tables in history_octane
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA history_octane TO etl_loan;

-- SELECT, INSERT, UPDATE on future tables in history_octane
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA history_octane, star_loan GRANT SELECT, INSERT, UPDATE
    ON TABLES TO etl_loan;

-- SELECT, INSERT, UPDATE, DELETE on existing tables in star_loan
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA star_loan TO etl_loan;

-- SELECT, INSERT, UPDATE, DELETE on future tables in star_loan
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA star_loan GRANT SELECT, INSERT, UPDATE, DELETE
    ON TABLES TO etl_loan;
