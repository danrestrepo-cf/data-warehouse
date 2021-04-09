--
-- EDW | Create initial star model
-- (https://app.asana.com/0/0/1199659841029429)
--
GRANT USAGE ON SCHEMA star_loan TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA star_loan TO readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA star_loan GRANT SELECT ON TABLES TO readonly;


--
--  BI - EDW | schema history_octane - Create initial DDL (https://app.asana.com/0/0/1200124472993448)
--

-- update default permissions use readonly can SELECT any new tables created
GRANT USAGE ON SCHEMA history_octane TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA history_octane to readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA history_octane GRANT SELECT ON TABLES TO readonly;

