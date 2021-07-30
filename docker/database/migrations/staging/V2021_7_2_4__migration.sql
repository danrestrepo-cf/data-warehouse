--
-- Main | EDW - Octane schemas from prod-release to uat (2021-07-30)
-- https://app.asana.com/0/0/1200693388322564
--

-- staging_octane changes
ALTER TABLE staging_octane.criteria_pid_operand
    ADD COLUMN crpo_trustee_pid bigint;

CREATE TABLE staging_octane.sap_status_type (
    code varchar(128),
    value varchar(1024),
    constraint pk_sap_status_type primary key (code)
);

ALTER TABLE staging_octane.deal_sap
    ADD COLUMN dsap_sap_status_type varchar(128);

-- history_octane changes
ALTER TABLE history_octane.criteria_pid_operand
    ADD COLUMN crpo_trustee_pid bigint;

CREATE INDEX fk_criteria_pid_operand_25 ON history_octane.criteria_pid_operand (crpo_trustee_pid);

CREATE TABLE history_octane.sap_status_type (
    code varchar(128),
    value varchar(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_sap_status_type__data_source_updated_datetime ON history_octane.sap_status_type (data_source_updated_datetime);

CREATE INDEX idx_sap_status_type__data_source_deleted_flag ON history_octane.sap_status_type (data_source_deleted_flag);

ALTER TABLE history_octane.deal_sap
    ADD COLUMN dsap_sap_status_type varchar(128);

CREATE INDEX fkt_dsap_sap_status_type ON history_octane.deal_sap (dsap_sap_status_type);
