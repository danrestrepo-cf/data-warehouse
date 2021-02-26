-- Grant permissions to mditest, readonly for new ingress.test tables
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE  ON test.unit_test_tools_source, test.unit_test_tools_target TO mditest;
GRANT SELECT ON test.unit_test_tools_source, test.unit_test_tools_target TO readonly;