--
-- EDW | Business Applications data mart- build a data mart and provide Octane user hierarchy data
-- https://app.asana.com/0/0/1201859471430286
--

GRANT USAGE ON SCHEMA data_mart_business_applications TO svc_doc_mgmt;
GRANT SELECT ON TABLE data_mart_business_applications.employee_user_details TO svc_doc_mgmt;
GRANT SELECT ON TABLE data_mart_business_applications.current_parent_nodes TO svc_doc_mgmt;
