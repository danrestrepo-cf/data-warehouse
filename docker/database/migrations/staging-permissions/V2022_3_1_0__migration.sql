--
-- EDW | Business Applications data mart- build a data mart and provide Octane user hierarchy data
-- https://app.asana.com/0/0/1201859471430286
--

GRANT USAGE ON SCHEMA data_mart_business_applications TO svc_document_management;
--granting select on VIEWS only, not underlying tables (underlying table names have "edw_" prefix
GRANT SELECT ON TABLE data_mart_business_applications.employee_user_details TO svc_document_management;
GRANT SELECT ON TABLE data_mart_business_applications.current_parent_nodes TO svc_document_management;
GRANT SELECT ON TABLE data_mart_business_applications.current_parent_node_employee_leaders TO svc_document_management;

GRANT USAGE ON SCHEMA data_mart_business_applications TO etl_loan;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA data_mart_business_applications TO etl_loan;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA data_mart_business_applications GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO etl_loan;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA data_mart_business_applications TO etl_loan;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA data_mart_business_applications GRANT USAGE, SELECT
    ON SEQUENCES TO etl_loan;
