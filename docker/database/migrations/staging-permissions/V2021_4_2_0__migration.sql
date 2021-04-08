--
-- EDW | Create initial star model
-- (https://app.asana.com/0/0/1199659841029429)
--
GRANT USAGE ON SCHEMA star_loan TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA star_loan TO readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA star_loan GRANT SELECT ON TABLES TO readonly;
