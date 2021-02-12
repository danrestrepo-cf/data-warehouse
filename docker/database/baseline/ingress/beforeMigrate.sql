-- all schemas in the ingress db should be created in this file
-- if a new schema is created you need to work with devops to create the schema in QA/Prod
CREATE SCHEMA IF NOT EXISTS encompass;
CREATE SCHEMA IF NOT EXISTS dmi;
CREATE SCHEMA IF NOT EXISTS test; -- created for MDI unit tests
