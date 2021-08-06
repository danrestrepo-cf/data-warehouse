--
-- Main | EDW - Octane schemas from prod-release to uat (2021-08-06)
-- https://app.asana.com/0/0/1200723475408385
--

-- staging_octane changes
-- 2021.8.1.0
CREATE TABLE staging_octane.du_finding_message_type (
    code varchar(128),
    value varchar(1024),
        constraint pk_du_finding_message_type primary key (code)
);

CREATE TABLE staging_octane.du_finding (
    duf_pid bigint,
    duf_version integer,
        constraint pk_du_finding primary key (duf_pid),
    duf_du_request_pid bigint,
    duf_du_finding_message_type varchar(128),
    duf_finding_result varchar(128),
    duf_finding_value varchar(128)
);

CREATE INDEX idx_du_finding__pid_version ON staging_octane.du_finding (duf_pid, duf_version);

-- 2021.8.1.2
ALTER TABLE staging_octane.proposal
    ADD COLUMN prp_initial_uw_disposition_datetime timestamp,
    ADD COLUMN prp_preapproval_uw_submit_datetime timestamp,
    ADD COLUMN prp_preapproval_uw_disposition_datetime timestamp;

-- history_octane changes
-- 2021.8.1.0
CREATE TABLE history_octane.du_finding_message_type (
    code varchar(128),
    value varchar(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_du_finding_message_type__data_source_updated_datetime ON history_octane.du_finding_message_type (data_source_updated_datetime);

CREATE INDEX idx_du_finding_message_type__data_source_deleted_flag ON history_octane.du_finding_message_type (data_source_deleted_flag);

CREATE TABLE history_octane.du_finding (
    duf_pid bigint,
    duf_version integer,
    duf_du_request_pid bigint,
    duf_du_finding_message_type varchar(128),
    duf_finding_result varchar(128),
    duf_finding_value varchar(128),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_du_finding__pid ON history_octane.du_finding (duf_pid);

CREATE INDEX idx_du_finding__data_source_updated_datetime ON history_octane.du_finding (data_source_updated_datetime);

CREATE INDEX idx_du_finding__data_source_deleted_flag ON history_octane.du_finding (data_source_deleted_flag);

CREATE INDEX idx_du_finding__pid_version ON history_octane.du_finding (duf_pid, duf_version);

CREATE INDEX fk_du_finding_1 ON history_octane.du_finding (duf_du_request_pid);

CREATE INDEX fkt_duf_du_finding_message_type ON history_octane.du_finding (duf_du_finding_message_type);

CREATE INDEX fkt_duf_finding_result ON history_octane.du_finding (duf_finding_result);

-- 2021.8.1.2
ALTER TABLE history_octane.proposal 
    ADD COLUMN prp_initial_uw_disposition_datetime timestamp,
    ADD COLUMN prp_preapproval_uw_submit_datetime timestamp,
    ADD COLUMN prp_preapproval_uw_disposition_datetime timestamp;
