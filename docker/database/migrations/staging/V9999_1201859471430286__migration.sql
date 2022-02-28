--
-- EDW | Business Applications data mart- build a data mart and provide Octane user hierarchy data
-- https://app.asana.com/0/0/1201859471430286
--

CREATE TABLE data_mart_business_applications.employee_user_details (
    parent_node_id BIGINT,
    parent_node_name VARCHAR(256),
    company_user_id VARCHAR(32),
    octane_username VARCHAR(32),
    first_name VARCHAR(32),
    last_name VARCHAR(32),
    professional_title VARCHAR(128),
    email VARCHAR(256),
    hire_date DATE,
    termination_date DATE,
    is_active_hub_user BOOLEAN
);

CREATE TABLE data_mart_business_applications.current_parent_nodes (
    parent_node_id BIGINT,
    parent_node_name VARCHAR(256),
    leader_company_user_id VARCHAR(32),
    coleader_company_user_id VARCHAR(1024),
    grandparent_node_id BIGINT,
    grandparent_node_name VARCHAR(256)
);
