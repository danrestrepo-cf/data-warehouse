--
-- EDW | permissions update in config database
-- (https://app.asana.com/0/0/1200256573875517)
--
GRANT SELECT ON
	mdi.state_machine_step,
	mdi.state_machine_definition,
	mdi.json_output_field,
	mdi.edw_table_definition,
	mdi.edw_join_definition,
	mdi.edw_field_definition TO readonly;

ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA mdi GRANT SELECT ON TABLES TO readonly;
