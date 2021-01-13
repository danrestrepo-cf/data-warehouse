-- GRANT CONNECT ON DATABASE config TO readonly;
-- GRANT CONNECT ON DATABASE config TO encompass_sp6;
-- GRANT CONNECT ON DATABASE config TO dmi;

GRANT SELECT ON ALL TABLES IN SCHEMA flyway TO readonly;

-- log schema
GRANT USAGE ON SCHEMA log TO readonly;
GRANT USAGE ON SCHEMA log TO pentaho_logging;
GRANT SELECT ON ALL TABLES IN SCHEMA log TO readonly;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA log TO pentaho_logging;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA log TO pentaho_logging;
-- GRANT USAGE, SELECT ON SEQUENCE log.pentaho_logging_sequence TO pentaho_logging;

-- mdi schema
GRANT USAGE ON SCHEMA mdi TO readonly;
GRANT USAGE ON SCHEMA mdi TO pentaho_mdi;
GRANT SELECT ON ALL TABLES IN SCHEMA mdi TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA mdi TO pentaho_mdi;