--
-- Main | EDW | Octane schema synchronization for v2022.3.2.0 (2022-03-11) https://app.asana.com/0/0/1201943559059092
--

-- staging_octane

CREATE TABLE staging_octane.config_note_scope_type (
                                                       code varchar(128),
                                                       value varchar(1024),
                                                       constraint pk_config_note_scope_type primary key (code)
);

CREATE TABLE staging_octane.config_note (
                                            cn_pid bigint,
                                            cn_version integer,
                                            constraint pk_config_note primary key (cn_pid),
                                            cn_account_pid bigint,
                                            cn_create_datetime timestamp,
                                            cn_content varchar(16000),
                                            cn_author_unparsed_name varchar(128),
                                            cn_author_lender_user_pid bigint,
                                            cn_config_note_scope_type varchar(128),
                                            cn_scope_name varchar(1024),
                                            cn_location_pid bigint,
                                            cn_smart_doc_pid bigint,
                                            cn_wf_process_pid bigint,
                                            cn_wf_step_pid bigint,
                                            cn_old_location_note_pid bigint,
                                            cn_old_smart_doc_note_pid bigint,
                                            cn_old_wf_process_note_pid bigint,
                                            cn_old_wf_step_note_pid bigint
);

CREATE INDEX idx_config_note__pid_version ON staging_octane.config_note (cn_pid, cn_version);

CREATE TABLE staging_octane.config_note_comment (
                                                    cnc_pid bigint,
                                                    cnc_version integer,
                                                    constraint pk_config_note_comment primary key (cnc_pid),
                                                    cnc_config_note_pid bigint,
                                                    cnc_create_datetime timestamp,
                                                    cnc_content varchar(16000),
                                                    cnc_author_unparsed_name varchar(128),
                                                    cnc_author_lender_user_pid bigint
);

CREATE INDEX idx_config_note_comment__pid_version ON staging_octane.config_note_comment (cnc_pid, cnc_version);

CREATE TABLE staging_octane.config_note_monitor (
                                                    cnm_pid bigint,
                                                    cnm_version integer,
                                                    constraint pk_config_note_monitor primary key (cnm_pid),
                                                    cnm_config_note_pid bigint,
                                                    cnm_lender_user_pid bigint
);

CREATE INDEX idx_config_note_monitor__pid_version ON staging_octane.config_note_monitor (cnm_pid, cnm_version);



ALTER TABLE staging_octane.smart_doc
    ADD COLUMN sd_action_entity_production_manager boolean;

ALTER TABLE staging_octane.deal_key_roles
    ADD COLUMN dkrs_production_manager_lender_user_pid bigint,
    ADD COLUMN dkrs_production_manager_fmls varchar(128);


-- history_octane

CREATE TABLE history_octane.config_note_scope_type (
                                                       code varchar(128),
                                                       value varchar(1024),
                                                       data_source_updated_datetime timestamptz,
                                                       data_source_deleted_flag boolean
);

CREATE INDEX idx_config_note_scope_type__data_source_updated_datetime ON history_octane.config_note_scope_type (data_source_updated_datetime);

CREATE INDEX idx_config_note_scope_type__data_source_deleted_flag ON history_octane.config_note_scope_type (data_source_deleted_flag);

CREATE TABLE history_octane.config_note (
                                            cn_pid bigint,
                                            cn_version integer,
                                            cn_account_pid bigint,
                                            cn_create_datetime timestamp,
                                            cn_content varchar(16000),
                                            cn_author_unparsed_name varchar(128),
                                            cn_author_lender_user_pid bigint,
                                            cn_config_note_scope_type varchar(128),
                                            cn_scope_name varchar(1024),
                                            cn_location_pid bigint,
                                            cn_smart_doc_pid bigint,
                                            cn_wf_process_pid bigint,
                                            cn_wf_step_pid bigint,
                                            cn_old_location_note_pid bigint,
                                            cn_old_smart_doc_note_pid bigint,
                                            cn_old_wf_process_note_pid bigint,
                                            cn_old_wf_step_note_pid bigint,
                                            data_source_updated_datetime timestamptz,
                                            data_source_deleted_flag boolean
);

CREATE INDEX idx_config_note__pid ON history_octane.config_note (cn_pid);

CREATE INDEX idx_config_note__data_source_updated_datetime ON history_octane.config_note (data_source_updated_datetime);

CREATE INDEX idx_config_note__data_source_deleted_flag ON history_octane.config_note (data_source_deleted_flag);

CREATE INDEX idx_config_note__pid_version ON history_octane.config_note (cn_pid, cn_version);

CREATE INDEX fk_config_note_1 ON history_octane.config_note (cn_account_pid);

CREATE INDEX fk_config_note_2 ON history_octane.config_note (cn_author_lender_user_pid);

CREATE INDEX fk_config_note_3 ON history_octane.config_note (cn_location_pid);

CREATE INDEX fk_config_note_4 ON history_octane.config_note (cn_smart_doc_pid);

CREATE INDEX fk_config_note_5 ON history_octane.config_note (cn_wf_process_pid);

CREATE INDEX fk_config_note_6 ON history_octane.config_note (cn_wf_step_pid);

CREATE INDEX fkt_cn_config_note_scope_type ON history_octane.config_note (cn_config_note_scope_type);

CREATE TABLE history_octane.config_note_comment (
                                                    cnc_pid bigint,
                                                    cnc_version integer,
                                                    cnc_config_note_pid bigint,
                                                    cnc_create_datetime timestamp,
                                                    cnc_content varchar(16000),
                                                    cnc_author_unparsed_name varchar(128),
                                                    cnc_author_lender_user_pid bigint,
                                                    data_source_updated_datetime timestamptz,
                                                    data_source_deleted_flag boolean
);

CREATE INDEX idx_config_note_comment__pid ON history_octane.config_note_comment (cnc_pid);

CREATE INDEX idx_config_note_comment__data_source_updated_datetime ON history_octane.config_note_comment (data_source_updated_datetime);

CREATE INDEX idx_config_note_comment__data_source_deleted_flag ON history_octane.config_note_comment (data_source_deleted_flag);

CREATE INDEX idx_config_note_comment__pid_version ON history_octane.config_note_comment (cnc_pid, cnc_version);

CREATE INDEX fk_config_note_comment_1 ON history_octane.config_note_comment (cnc_config_note_pid);

CREATE INDEX fk_config_note_comment_2 ON history_octane.config_note_comment (cnc_author_lender_user_pid);

CREATE TABLE history_octane.config_note_monitor (
                                                    cnm_pid bigint,
                                                    cnm_version integer,
                                                    cnm_config_note_pid bigint,
                                                    cnm_lender_user_pid bigint,
                                                    data_source_updated_datetime timestamptz,
                                                    data_source_deleted_flag boolean
);

CREATE INDEX idx_config_note_monitor__pid ON history_octane.config_note_monitor (cnm_pid);

CREATE INDEX idx_config_note_monitor__data_source_updated_datetime ON history_octane.config_note_monitor (data_source_updated_datetime);

CREATE INDEX idx_config_note_monitor__data_source_deleted_flag ON history_octane.config_note_monitor (data_source_deleted_flag);

CREATE INDEX idx_config_note_monitor__pid_version ON history_octane.config_note_monitor (cnm_pid, cnm_version);

CREATE INDEX fk_config_note_monitor_1 ON history_octane.config_note_monitor (cnm_config_note_pid);

CREATE INDEX fk_config_note_monitor_2 ON history_octane.config_note_monitor (cnm_lender_user_pid);



ALTER TABLE history_octane.smart_doc
    ADD COLUMN sd_action_entity_production_manager boolean;

ALTER TABLE history_octane.deal_key_roles
    ADD COLUMN dkrs_production_manager_lender_user_pid bigint,
    ADD COLUMN dkrs_production_manager_fmls varchar(128);

CREATE INDEX fk_deal_key_roles_42 ON history_octane.deal_key_roles (dkrs_production_manager_lender_user_pid);

