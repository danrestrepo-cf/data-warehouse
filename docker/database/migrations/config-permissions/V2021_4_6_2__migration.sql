--
-- EDW User Permissions | Create PostgreSQL user to run MDI configs for loan data
-- https://app.asana.com/0/0/1200279714721251
--


GRANT SELECT ON
    mdi.state_machine_step
    , mdi.state_machine_definition
    , mdi.json_output_field
    , mdi.edw_table_definition
    , mdi.edw_join_definition
    , mdi.edw_field_definition TO pentaho_mdi;

-- SELECT on future tables
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA mdi GRANT SELECT ON TABLES TO pentaho_mdi;
