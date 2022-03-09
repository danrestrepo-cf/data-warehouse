--
-- EDW | Business Applications data mart- build a data mart and provide Octane user hierarchy data
-- https://app.asana.com/0/0/1201859471430286
--

--employee_user_details
CREATE TABLE data_mart_business_applications.edw_employee_user_details (
    dwid BIGSERIAL
        CONSTRAINT pk_employee_user_details
            PRIMARY KEY,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
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

CREATE INDEX idx_edw_employee_user_details__octane_username ON data_mart_business_applications.edw_employee_user_details (octane_username);
CREATE INDEX idx_edw_employee_user_details__parent_node_id ON data_mart_business_applications.edw_employee_user_details (parent_node_id);
CREATE INDEX idx_edw_employee_user_details__company_user_id ON data_mart_business_applications.edw_employee_user_details (company_user_id);
CREATE INDEX idx_edw_employee_user_details__email ON data_mart_business_applications.edw_employee_user_details (email);

CREATE VIEW data_mart_business_applications.employee_user_details
AS
    SELECT edw_employee_user_details.parent_node_id
         , edw_employee_user_details.parent_node_name
         , edw_employee_user_details.company_user_id
         , edw_employee_user_details.octane_username
         , edw_employee_user_details.first_name
         , edw_employee_user_details.last_name
         , edw_employee_user_details.professional_title
         , edw_employee_user_details.email
         , edw_employee_user_details.hire_date
         , edw_employee_user_details.termination_date
         , edw_employee_user_details.is_active_hub_user
         , edw_employee_user_details.data_source_modified_datetime AS last_updated_datetime
    FROM data_mart_business_applications.edw_employee_user_details;

--current_parent_nodes
CREATE TABLE data_mart_business_applications.edw_current_parent_nodes (
    dwid BIGSERIAL
        CONSTRAINT pk_current_parent_nodes
            PRIMARY KEY,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    parent_node_id BIGINT,
    parent_node_name VARCHAR(256),
    grandparent_node_id BIGINT,
    grandparent_node_name VARCHAR(256)
);

CREATE INDEX idx_edw_current_parent_nodes__parent_node_id ON data_mart_business_applications.edw_current_parent_nodes (parent_node_id);
CREATE INDEX idx_edw_current_parent_nodes__grandparent_node_id ON data_mart_business_applications.edw_current_parent_nodes (grandparent_node_id);

CREATE VIEW data_mart_business_applications.current_parent_nodes
AS
    SELECT edw_current_parent_nodes.parent_node_id
         , edw_current_parent_nodes.parent_node_name
         , edw_current_parent_nodes.grandparent_node_id
         , edw_current_parent_nodes.grandparent_node_name
         , edw_current_parent_nodes.data_source_modified_datetime AS last_updated_datetime
    FROM data_mart_business_applications.edw_current_parent_nodes;

--current_parent_node_leaders
CREATE TABLE data_mart_business_applications.edw_current_parent_node_employee_leaders (
    dwid BIGSERIAL
        CONSTRAINT pk_current_parent_node_leaders
            PRIMARY KEY,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    parent_node_id BIGINT,
    leader_company_user_id VARCHAR(32),
    leader_type VARCHAR(1024)
);

CREATE INDEX idx_edw_current_parent_node_employee_leaders__parent_node_id ON data_mart_business_applications.edw_current_parent_node_employee_leaders (parent_node_id);
CREATE INDEX idx_bc5812ae78bf2c71d265441a32b03430 ON data_mart_business_applications.edw_current_parent_node_employee_leaders (leader_company_user_id);

CREATE VIEW data_mart_business_applications.current_parent_node_employee_leaders
AS
    SELECT edw_current_parent_node_employee_leaders.parent_node_id
         , edw_current_parent_node_employee_leaders.leader_company_user_id
         , edw_current_parent_node_employee_leaders.leader_type
         , edw_current_parent_node_employee_leaders.data_source_modified_datetime AS last_updated_datetime
    FROM data_mart_business_applications.edw_current_parent_node_employee_leaders;
