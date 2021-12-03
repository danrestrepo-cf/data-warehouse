DROP TABLE IF EXISTS staging_octane.loan_closing_doc;DROP TABLE IF EXISTS staging_octane.closing_document_status_type;ALTER TABLE staging_octane.branch.br_dsi_customer_id
    DROP COLUMN br_dsi_customer_id;

ALTER TABLE staging_octane.account
    DROP COLUMN a_allonge_representative_name,
    DROP COLUMN a_allonge_representative_title;

ALTER TABLE staging_octane.product_terms
    DROP COLUMN pt_dsi_plan_code;

CREATE TABLE staging_octane.custom_field_value_type (
                                                        code varchar(128),
                                                        value varchar(1024),
                                                        constraint pk_custom_field_value_type primary key (code)
);

CREATE TABLE staging_octane.custom_field_scope_type (
                                                        code varchar(128),
                                                        value varchar(1024),
                                                        constraint pk_custom_field_scope_type primary key (code)
);

CREATE TABLE staging_octane.org_lineage_tracker_custom_field_update_status_type (
                                                                                    code varchar(128),
                                                                                    value varchar(1024),
                                                                                    constraint pk_org_lineage_tracker_custom_field_update_status_type primary key (code)
);

CREATE TABLE staging_octane.custom_field_setting (
                                                     cfs_pid bigint,
                                                     cfs_version integer,
                                                     constraint pk_custom_field_setting primary key (cfs_pid),
                                                     cfs_account_pid
                                                         cfs_custom_field_scope_type
                                                         cfs_custom_field_setting_name
                                                         cfs_custom_field_value_type
                                                         cfs_custom_field_setting_description
);

CREATE INDEX idx_custom_field_setting__pid_version ON staging_octane.custom_field_setting (cfs_pid, cfs_version);

CREATE TABLE staging_octane.custom_field_choice (
                                                    cfc_pid bigint,
                                                    cfc_version integer,
                                                    constraint pk_custom_field_choice primary key (cfc_pid),
                                                    cfc_custom_field_setting_pid bigint,
                                                    cfc_choice_label varchar(1024),
                                                    cfc_disabled boolean
);

CREATE INDEX idx_custom_field_choice__pid_version ON staging_octane.custom_field_choice (cfc_pid, cfc_version);

CREATE TABLE staging_octane.org_node_custom_field (
                                                      oncf_pid bigint,
                                                      oncf_version integer,
                                                      constraint pk_org_node_custom_field primary key (oncf_pid),
                                                      oncf_org_node_pid bigint,
                                                      oncf_custom_field_setting_pid bigint,
                                                      oncf_field_value varchar(1024),
                                                      oncf_custom_field_choice_pid bigint,
                                                      oncf_propagator boolean,
                                                      oncf_propagated boolean,
                                                      oncf_excluded boolean,
                                                      oncf_propagator_org_node_custom_field_pid bigint,
                                                      oncf_org_lineage_tracker_pid bigint
);

CREATE INDEX idx_org_node_custom_field__pid_version ON staging_octane.org_node_custom_field (oncf_pid, oncf_version);

CREATE TABLE staging_octane.org_lineage_tracker_custom_field_update (
                                                                        otcfu_pid bigint,
                                                                        otcfu_version integer,
                                                                        constraint pk_org_lineage_tracker_custom_field_update primary key (otcfu_pid),
                                                                        otcfu_org_lineage_tracker_pid bigint,
                                                                        otcfu_org_lineage_tracker_custom_field_update_status_type varchar(128)
);

CREATE INDEX idx_org_lineage_tracker_custom_field_update__pid_version ON staging_octane.org_lineage_tracker_custom_field_update (otcfu_pid, otcfu_version);













CREATE TABLE history_octane.custom_field_value_type (
                                                        code varchar(128),
                                                        value varchar(1024),
                                                        data_source_updated_datetime timestamptz,
                                                        data_source_deleted_flag boolean
);

CREATE INDEX idx_custom_field_value_type__data_source_updated_datetime ON history_octane.custom_field_value_type (data_source_updated_datetime);

CREATE INDEX idx_custom_field_value_type__data_source_deleted_flag ON history_octane.custom_field_value_type (data_source_deleted_flag);

CREATE TABLE history_octane.custom_field_scope_type (
                                                        code varchar(128),
                                                        value varchar(1024),
                                                        data_source_updated_datetime timestamptz,
                                                        data_source_deleted_flag boolean
);

CREATE INDEX idx_custom_field_scope_type__data_source_updated_datetime ON history_octane.custom_field_scope_type (data_source_updated_datetime);

CREATE INDEX idx_custom_field_scope_type__data_source_deleted_flag ON history_octane.custom_field_scope_type (data_source_deleted_flag);

CREATE TABLE history_octane.org_lineage_tracker_custom_field_update_status_type (
                                                                                    code varchar(128),
                                                                                    value varchar(1024),
                                                                                    data_source_updated_datetime timestamptz,
                                                                                    data_source_deleted_flag boolean
);

CREATE INDEX idx_2133330e966e616e6fc70ec0fc21848c ON history_octane.org_lineage_tracker_custom_field_update_status_type (data_source_updated_datetime);

CREATE INDEX idx_23700b2d1556ca5d13f9cd986b6cfec6 ON history_octane.org_lineage_tracker_custom_field_update_status_type (data_source_deleted_flag);

CREATE TABLE history_octane.custom_field_setting (
                                                     cfs_pid bigint,
                                                     cfs_version integer,
                                                     cfs_account_pid bigint,
                                                     cfs_custom_field_scope_type varchar(128),
                                                     cfs_custom_field_setting_name varchar(1024),
                                                     cfs_custom_field_value_type varchar(128),
                                                     cfs_custom_field_setting_description varchar(1024),
                                                     data_source_updated_datetime timestamptz,
                                                     data_source_deleted_flag boolean
);

CREATE INDEX idx_custom_field_setting__pid ON history_octane.custom_field_setting (cfs_pid);

CREATE INDEX idx_custom_field_setting__data_source_updated_datetime ON history_octane.custom_field_setting (data_source_updated_datetime);

CREATE INDEX idx_custom_field_setting__data_source_deleted_flag ON history_octane.custom_field_setting (data_source_deleted_flag);

CREATE INDEX idx_custom_field_setting__pid_version ON history_octane.custom_field_setting (cfs_pid, cfs_version);

CREATE INDEX fk_custom_field_setting_1 ON history_octane.custom_field_setting (cfs_account_pid);

CREATE INDEX fkt_cfs_custom_field_scope_type ON history_octane.custom_field_setting (cfs_custom_field_scope_type);

CREATE INDEX fkt_cfs_custom_field_value_type ON history_octane.custom_field_setting (cfs_custom_field_value_type);

CREATE TABLE history_octane.custom_field_choice (
                                                    cfc_pid bigint,
                                                    cfc_version integer,
                                                    cfc_custom_field_setting_pid bigint,
                                                    cfc_choice_label varchar(1024),
                                                    cfc_disabled boolean,
                                                    data_source_updated_datetime timestamptz,
                                                    data_source_deleted_flag boolean
);

CREATE INDEX idx_custom_field_choice__pid ON history_octane.custom_field_choice (cfc_pid);

CREATE INDEX idx_custom_field_choice__data_source_updated_datetime ON history_octane.custom_field_choice (data_source_updated_datetime);

CREATE INDEX idx_custom_field_choice__data_source_deleted_flag ON history_octane.custom_field_choice (data_source_deleted_flag);

CREATE INDEX idx_custom_field_choice__pid_version ON history_octane.custom_field_choice (cfc_pid, cfc_version);

CREATE INDEX fk_custom_field_choice_1 ON history_octane.custom_field_choice (cfc_custom_field_setting_pid);

CREATE TABLE history_octane.org_node_custom_field (
                                                      oncf_pid bigint,
                                                      oncf_version integer,
                                                      oncf_org_node_pid bigint,
                                                      oncf_custom_field_setting_pid bigint,
                                                      oncf_field_value varchar(1024),
                                                      oncf_custom_field_choice_pid bigint,
                                                      oncf_propagator boolean,
                                                      oncf_propagated boolean,
                                                      oncf_excluded boolean,
                                                      oncf_propagator_org_node_custom_field_pid bigint,
                                                      oncf_org_lineage_tracker_pid bigint,
                                                      data_source_updated_datetime timestamptz,
                                                      data_source_deleted_flag boolean
);

CREATE INDEX idx_org_node_custom_field__pid ON history_octane.org_node_custom_field (oncf_pid);

CREATE INDEX idx_org_node_custom_field__data_source_updated_datetime ON history_octane.org_node_custom_field (data_source_updated_datetime);

CREATE INDEX idx_org_node_custom_field__data_source_deleted_flag ON history_octane.org_node_custom_field (data_source_deleted_flag);

CREATE INDEX idx_org_node_custom_field__pid_version ON history_octane.org_node_custom_field (oncf_pid, oncf_version);

CREATE INDEX fk_org_node_custom_field_1 ON history_octane.org_node_custom_field (oncf_org_node_pid);

CREATE INDEX fk_org_node_custom_field_2 ON history_octane.org_node_custom_field (oncf_custom_field_setting_pid);

CREATE INDEX fk_org_node_custom_field_3 ON history_octane.org_node_custom_field (oncf_custom_field_choice_pid);

CREATE INDEX fk_org_node_custom_field_4 ON history_octane.org_node_custom_field (oncf_propagator_org_node_custom_field_pid);

CREATE INDEX fk_org_node_custom_field_5 ON history_octane.org_node_custom_field (oncf_org_lineage_tracker_pid);

CREATE TABLE history_octane.org_lineage_tracker_custom_field_update (
                                                                        otcfu_pid bigint,
                                                                        otcfu_version integer,
                                                                        otcfu_org_lineage_tracker_pid bigint,
                                                                        otcfu_org_lineage_tracker_custom_field_update_status_type varchar(128),
                                                                        data_source_updated_datetime timestamptz,
                                                                        data_source_deleted_flag boolean
);

CREATE INDEX idx_org_lineage_tracker_custom_field_update__pid ON history_octane.org_lineage_tracker_custom_field_update (otcfu_pid);

CREATE INDEX idx_9c4cc8a32a9732a9c86746f55a15a77d ON history_octane.org_lineage_tracker_custom_field_update (data_source_updated_datetime);

CREATE INDEX idx_1c2b79d40dc6bf04f1e27a1ad80bc5f1 ON history_octane.org_lineage_tracker_custom_field_update (data_source_deleted_flag);

CREATE INDEX idx_org_lineage_tracker_custom_field_update__pid_version ON history_octane.org_lineage_tracker_custom_field_update (otcfu_pid, otcfu_version);

CREATE INDEX fk_org_lineage_tracker_custom_field_update_1 ON history_octane.org_lineage_tracker_custom_field_update (otcfu_org_lineage_tracker_pid);

