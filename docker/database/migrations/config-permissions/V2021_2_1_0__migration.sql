GRANT CONNECT ON DATABASE config TO mditest;
GRANT pentaho_mdi TO mditest;
GRANT pentaho_logging TO mditest;

-- mdi schema
GRANT USAGE ON SCHEMA mdi TO mditest;
GRANT SELECT ON ALL TABLES IN SCHEMA mdi TO mditest;
