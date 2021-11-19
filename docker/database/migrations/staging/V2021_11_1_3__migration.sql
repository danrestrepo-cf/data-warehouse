--
-- Main | Octane schemas from prod-release to v2021.11.3.0 on uat
-- https://app.asana.com/0/0/1201374364166630
--

--staging_octane changes

ALTER TABLE staging_octane.smart_message
    ADD COLUMN smsg_allow_custom_text BOOLEAN;

CREATE TABLE staging_octane.smart_message_available_attachment (
    smaa_pid BIGINT,
    smaa_version INTEGER,
    CONSTRAINT pk_smart_message_available_attachment
        PRIMARY KEY (smaa_pid),
    smaa_smart_message_pid BIGINT,
    smaa_smart_doc_pid BIGINT
);

CREATE INDEX idx_smart_message_available_attachment__pid_version ON staging_octane.smart_message_available_attachment (smaa_pid, smaa_version);

CREATE TABLE staging_octane.deal_message_log_attachment (
    dmloga_pid BIGINT,
    dmloga_version INTEGER,
    CONSTRAINT pk_deal_message_log_attachment
        PRIMARY KEY (dmloga_pid),
    dmloga_deal_message_log_pid BIGINT,
    dmloga_deal_file_pid BIGINT
);

CREATE INDEX idx_deal_message_log_attachment__pid_version ON staging_octane.deal_message_log_attachment (dmloga_pid, dmloga_version);

ALTER TABLE staging_octane.deal_message_log
    DROP COLUMN dmlog_attachment_deal_file_pid;

ALTER TABLE staging_octane.criteria_snippet
    ADD COLUMN crs_compatible_with_smart_charge_apr BOOLEAN;

CREATE TABLE staging_octane.broker_compensation_type (
    code VARCHAR(128),
    value VARCHAR(1024),
    CONSTRAINT pk_broker_compensation_type
        PRIMARY KEY (code)
);

ALTER TABLE staging_octane.lead_source
    ADD COLUMN lds_broker_compensation_type VARCHAR(128);


--history_octane changes

ALTER TABLE history_octane.smart_message
    ADD COLUMN smsg_allow_custom_text BOOLEAN;

CREATE TABLE history_octane.smart_message_available_attachment (
    smaa_pid BIGINT,
    smaa_version INTEGER,
    smaa_smart_message_pid BIGINT,
    smaa_smart_doc_pid BIGINT,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN
);

CREATE INDEX idx_smart_message_available_attachment__pid ON history_octane.smart_message_available_attachment (smaa_pid);

CREATE INDEX idx_fb4b88abd8f35bc1cda1f9493404e8ca ON history_octane.smart_message_available_attachment (data_source_updated_datetime);

CREATE INDEX idx_aeff4b7de9551bb966d2c0647d2077cf ON history_octane.smart_message_available_attachment (data_source_deleted_flag);

CREATE INDEX idx_smart_message_available_attachment__pid_version ON history_octane.smart_message_available_attachment (smaa_pid, smaa_version);

CREATE INDEX fk_smart_message_available_attachment_1 ON history_octane.smart_message_available_attachment (smaa_smart_message_pid);

CREATE INDEX fk_smart_message_available_attachment_2 ON history_octane.smart_message_available_attachment (smaa_smart_doc_pid);

CREATE TABLE history_octane.deal_message_log_attachment (
    dmloga_pid BIGINT,
    dmloga_version INTEGER,
    dmloga_deal_message_log_pid BIGINT,
    dmloga_deal_file_pid BIGINT,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN
);

CREATE INDEX idx_deal_message_log_attachment__pid ON history_octane.deal_message_log_attachment (dmloga_pid);

CREATE INDEX idx_deal_message_log_attachment__data_source_updated_datetime ON history_octane.deal_message_log_attachment (data_source_updated_datetime);

CREATE INDEX idx_deal_message_log_attachment__data_source_deleted_flag ON history_octane.deal_message_log_attachment (data_source_deleted_flag);

CREATE INDEX idx_deal_message_log_attachment__pid_version ON history_octane.deal_message_log_attachment (dmloga_pid, dmloga_version);

CREATE INDEX fk_deal_message_log_attachment_1 ON history_octane.deal_message_log_attachment (dmloga_deal_message_log_pid);

CREATE INDEX fk_deal_message_log_attachment_2 ON history_octane.deal_message_log_attachment (dmloga_deal_file_pid);

ALTER TABLE history_octane.criteria_snippet
    ADD COLUMN crs_compatible_with_smart_charge_apr BOOLEAN;

CREATE TABLE history_octane.broker_compensation_type (
    code VARCHAR(128),
    value VARCHAR(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN
);

CREATE INDEX idx_broker_compensation_type__data_source_updated_datetime ON history_octane.broker_compensation_type (data_source_updated_datetime);

CREATE INDEX idx_broker_compensation_type__data_source_deleted_flag ON history_octane.broker_compensation_type (data_source_deleted_flag);

ALTER TABLE history_octane.lead_source
    ADD COLUMN lds_broker_compensation_type VARCHAR(128);

CREATE INDEX fkt_lds_broker_compensation_type ON history_octane.lead_source (lds_broker_compensation_type);
