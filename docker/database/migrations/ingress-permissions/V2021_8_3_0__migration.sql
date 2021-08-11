-- Grant permissions to loan_inventory_etl user to run Risk asset IP40 process

-- warehouse_banks_etl permissions
GRANT USAGE ON SCHEMA warehouse_banks TO warehouse_banks_etl;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA warehouse_banks TO warehouse_banks_etl;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA warehouse_banks GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON TABLES TO warehouse_banks_etl;

-- readonly permissions
GRANT USAGE ON SCHEMA warehouse_banks TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA warehouse_banks TO readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA warehouse_banks GRANT SELECT ON TABLES TO readonly;
