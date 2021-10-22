--
-- Main | EDW - Octane schemas from prod-release to v2021.10.3.3 on uat
-- https://app.asana.com/0/0/1201229678686976
--

-- staging_octane changes
CREATE TABLE staging_octane.wf_step_note
(
    wfsn_pid                    bigint,
    wfsn_version                integer,
    constraint pk_wf_step_note primary key (wfsn_pid),
    wfsn_wf_step_pid            bigint,
    wfsn_create_datetime        timestamp,
    wfsn_content                varchar(16000),
    wfsn_author_lender_user_pid bigint,
    wfsn_author_unparsed_name   varchar(128)
);

CREATE INDEX idx_wf_step_note__pid_version ON staging_octane.wf_step_note (wfsn_pid, wfsn_version);

CREATE TABLE staging_octane.wf_step_note_comment
(
    wfsnc_pid                    bigint,
    wfsnc_version                integer,
    constraint pk_wf_step_note_comment primary key (wfsnc_pid),
    wfsnc_wf_step_note_pid       bigint,
    wfsnc_create_datetime        timestamp,
    wfsnc_content                varchar(16000),
    wfsnc_author_lender_user_pid bigint,
    wfsnc_author_unparsed_name   varchar(128)
);

CREATE INDEX idx_wf_step_note_comment__pid_version ON staging_octane.wf_step_note_comment (wfsnc_pid, wfsnc_version);

CREATE TABLE staging_octane.wf_step_note_monitor
(
    wfsnm_pid              bigint,
    wfsnm_version          integer,
    constraint pk_wf_step_note_monitor primary key (wfsnm_pid),
    wfsnm_wf_step_note_pid bigint,
    wfsnm_lender_user_pid  bigint
);

CREATE INDEX idx_wf_step_note_monitor__pid_version ON staging_octane.wf_step_note_monitor (wfsnm_pid, wfsnm_version);

CREATE TABLE staging_octane.wf_process_note
(
    wfpn_pid                    bigint,
    wfpn_version                integer,
    constraint pk_wf_process_note primary key (wfpn_pid),
    wfpn_wf_process_pid         bigint,
    wfpn_create_datetime        timestamp,
    wfpn_content                varchar(16000),
    wfpn_author_lender_user_pid bigint,
    wfpn_author_unparsed_name   varchar(128)
);

CREATE INDEX idx_wf_process_note__pid_version ON staging_octane.wf_process_note (wfpn_pid, wfpn_version);

CREATE TABLE staging_octane.wf_process_note_comment
(
    wfpnc_pid                    bigint,
    wfpnc_version                integer,
    constraint pk_wf_process_note_comment primary key (wfpnc_pid),
    wfpnc_wf_process_note_pid    bigint,
    wfpnc_create_datetime        timestamp,
    wfpnc_content                varchar(16000),
    wfpnc_author_lender_user_pid bigint,
    wfpnc_author_unparsed_name   varchar(128)
);

CREATE INDEX idx_wf_process_note_comment__pid_version ON staging_octane.wf_process_note_comment (wfpnc_pid, wfpnc_version);

CREATE TABLE staging_octane.wf_process_note_monitor
(
    wfpnm_pid                 bigint,
    wfpnm_version             integer,
    constraint pk_wf_process_note_monitor primary key (wfpnm_pid),
    wfpnm_wf_process_note_pid bigint,
    wfpnm_lender_user_pid     bigint
);

CREATE INDEX idx_wf_process_note_monitor__pid_version ON staging_octane.wf_process_note_monitor (wfpnm_pid, wfpnm_version);

ALTER TABLE staging_octane.construction_cost
    ADD COLUMN coc_borrower_pid                bigint,
    ADD COLUMN coc_proposal_hud_consultant_pid bigint,
    ADD COLUMN coc_title_company_pid           bigint,
    ADD COLUMN coc_payee_other_selected        boolean,
    ADD COLUMN coc_payee_other_description     varchar(128),
    DROP COLUMN coc_payee;

ALTER TABLE staging_octane.lender_settings
    ADD COLUMN lss_fha_home_office_location_pid bigint;


-- history_octane changes
CREATE TABLE history_octane.wf_step_note
(
    wfsn_pid                     bigint,
    wfsn_version                 integer,
    wfsn_wf_step_pid             bigint,
    wfsn_create_datetime         timestamp,
    wfsn_content                 varchar(16000),
    wfsn_author_lender_user_pid  bigint,
    wfsn_author_unparsed_name    varchar(128),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag     boolean
);

CREATE INDEX idx_wf_step_note__pid ON history_octane.wf_step_note (wfsn_pid);

CREATE INDEX idx_wf_step_note__data_source_updated_datetime ON history_octane.wf_step_note (data_source_updated_datetime);

CREATE INDEX idx_wf_step_note__data_source_deleted_flag ON history_octane.wf_step_note (data_source_deleted_flag);

CREATE INDEX idx_wf_step_note__pid_version ON history_octane.wf_step_note (wfsn_pid, wfsn_version);

CREATE INDEX fk_wf_step_note_1 ON history_octane.wf_step_note (wfsn_wf_step_pid);

CREATE INDEX fk_wf_step_note_2 ON history_octane.wf_step_note (wfsn_author_lender_user_pid);

CREATE TABLE history_octane.wf_step_note_comment
(
    wfsnc_pid                    bigint,
    wfsnc_version                integer,
    wfsnc_wf_step_note_pid       bigint,
    wfsnc_create_datetime        timestamp,
    wfsnc_content                varchar(16000),
    wfsnc_author_lender_user_pid bigint,
    wfsnc_author_unparsed_name   varchar(128),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag     boolean
);

CREATE INDEX idx_wf_step_note_comment__pid ON history_octane.wf_step_note_comment (wfsnc_pid);

CREATE INDEX idx_wf_step_note_comment__data_source_updated_datetime ON history_octane.wf_step_note_comment (data_source_updated_datetime);

CREATE INDEX idx_wf_step_note_comment__data_source_deleted_flag ON history_octane.wf_step_note_comment (data_source_deleted_flag);

CREATE INDEX idx_wf_step_note_comment__pid_version ON history_octane.wf_step_note_comment (wfsnc_pid, wfsnc_version);

CREATE INDEX fk_wf_step_note_comment_1 ON history_octane.wf_step_note_comment (wfsnc_wf_step_note_pid);

CREATE INDEX fk_wf_step_note_comment_2 ON history_octane.wf_step_note_comment (wfsnc_author_lender_user_pid);

CREATE TABLE history_octane.wf_step_note_monitor
(
    wfsnm_pid                    bigint,
    wfsnm_version                integer,
    wfsnm_wf_step_note_pid       bigint,
    wfsnm_lender_user_pid        bigint,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag     boolean
);

CREATE INDEX idx_wf_step_note_monitor__pid ON history_octane.wf_step_note_monitor (wfsnm_pid);

CREATE INDEX idx_wf_step_note_monitor__data_source_updated_datetime ON history_octane.wf_step_note_monitor (data_source_updated_datetime);

CREATE INDEX idx_wf_step_note_monitor__data_source_deleted_flag ON history_octane.wf_step_note_monitor (data_source_deleted_flag);

CREATE INDEX idx_wf_step_note_monitor__pid_version ON history_octane.wf_step_note_monitor (wfsnm_pid, wfsnm_version);

CREATE INDEX fk_wf_step_note_monitor_1 ON history_octane.wf_step_note_monitor (wfsnm_wf_step_note_pid);

CREATE INDEX fk_wf_step_note_monitor_2 ON history_octane.wf_step_note_monitor (wfsnm_lender_user_pid);

CREATE TABLE history_octane.wf_process_note
(
    wfpn_pid                     bigint,
    wfpn_version                 integer,
    wfpn_wf_process_pid          bigint,
    wfpn_create_datetime         timestamp,
    wfpn_content                 varchar(16000),
    wfpn_author_lender_user_pid  bigint,
    wfpn_author_unparsed_name    varchar(128),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag     boolean
);

CREATE INDEX idx_wf_process_note__pid ON history_octane.wf_process_note (wfpn_pid);

CREATE INDEX idx_wf_process_note__data_source_updated_datetime ON history_octane.wf_process_note (data_source_updated_datetime);

CREATE INDEX idx_wf_process_note__data_source_deleted_flag ON history_octane.wf_process_note (data_source_deleted_flag);

CREATE INDEX idx_wf_process_note__pid_version ON history_octane.wf_process_note (wfpn_pid, wfpn_version);

CREATE INDEX fk_wf_process_note_1 ON history_octane.wf_process_note (wfpn_wf_process_pid);

CREATE INDEX fk_wf_process_note_2 ON history_octane.wf_process_note (wfpn_author_lender_user_pid);

CREATE TABLE history_octane.wf_process_note_comment
(
    wfpnc_pid                    bigint,
    wfpnc_version                integer,
    wfpnc_wf_process_note_pid    bigint,
    wfpnc_create_datetime        timestamp,
    wfpnc_content                varchar(16000),
    wfpnc_author_lender_user_pid bigint,
    wfpnc_author_unparsed_name   varchar(128),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag     boolean
);

CREATE INDEX idx_wf_process_note_comment__pid ON history_octane.wf_process_note_comment (wfpnc_pid);

CREATE INDEX idx_wf_process_note_comment__data_source_updated_datetime ON history_octane.wf_process_note_comment (data_source_updated_datetime);

CREATE INDEX idx_wf_process_note_comment__data_source_deleted_flag ON history_octane.wf_process_note_comment (data_source_deleted_flag);

CREATE INDEX idx_wf_process_note_comment__pid_version ON history_octane.wf_process_note_comment (wfpnc_pid, wfpnc_version);

CREATE INDEX fk_wf_process_note_comment_1 ON history_octane.wf_process_note_comment (wfpnc_wf_process_note_pid);

CREATE INDEX fk_wf_process_note_comment_2 ON history_octane.wf_process_note_comment (wfpnc_author_lender_user_pid);

CREATE TABLE history_octane.wf_process_note_monitor
(
    wfpnm_pid                    bigint,
    wfpnm_version                integer,
    wfpnm_wf_process_note_pid    bigint,
    wfpnm_lender_user_pid        bigint,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag     boolean
);

CREATE INDEX idx_wf_process_note_monitor__pid ON history_octane.wf_process_note_monitor (wfpnm_pid);

CREATE INDEX idx_wf_process_note_monitor__data_source_updated_datetime ON history_octane.wf_process_note_monitor (data_source_updated_datetime);

CREATE INDEX idx_wf_process_note_monitor__data_source_deleted_flag ON history_octane.wf_process_note_monitor (data_source_deleted_flag);

CREATE INDEX idx_wf_process_note_monitor__pid_version ON history_octane.wf_process_note_monitor (wfpnm_pid, wfpnm_version);

CREATE INDEX fk_wf_process_note_monitor_1 ON history_octane.wf_process_note_monitor (wfpnm_wf_process_note_pid);

CREATE INDEX fk_wf_process_note_monitor_2 ON history_octane.wf_process_note_monitor (wfpnm_lender_user_pid);

ALTER TABLE history_octane.construction_cost
    ADD COLUMN coc_borrower_pid                bigint,
    ADD COLUMN coc_proposal_hud_consultant_pid bigint,
    ADD COLUMN coc_title_company_pid           bigint,
    ADD COLUMN coc_payee_other_selected        boolean,
    ADD COLUMN coc_payee_other_description     varchar(128);

CREATE INDEX fk_coc_borrower_pid ON history_octane.construction_cost (coc_borrower_pid);

CREATE INDEX fk_coc_proposal_hud_consultant_pid ON history_octane.construction_cost (coc_proposal_hud_consultant_pid);

CREATE INDEX fk_coc_title_company_pid ON history_octane.construction_cost (coc_title_company_pid);

ALTER TABLE history_octane.lender_settings
    ADD COLUMN lss_fha_home_office_location_pid bigint;

CREATE INDEX fk_lender_settings_6 ON history_octane.lender_settings (lss_fha_home_office_location_pid);
