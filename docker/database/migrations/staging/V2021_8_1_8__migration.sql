--
-- Main | EDW - Octane schemas from prod-release to uat (2021-09-03)
-- https://app.asana.com/0/0/1200902597416797
--

--staging_octane changes

CREATE TABLE staging_octane.smart_doc_validity_date_case (
    sdvdc_pid bigint,
    sdvdc_version integer,
    constraint pk_smart_doc_validity_date_case primary key (sdvdc_pid),
    sdvdc_smart_doc_pid bigint,
    sdvdc_criteria_pid bigint,
    sdvdc_criteria_html varchar(16000),
    sdvdc_deal_child_type varchar(128),
    sdvdc_deal_child_relationship_type varchar(128),
    sdvdc_doc_validity_type varchar(128),
    sdvdc_doc_key_date_type varchar(128),
    sdvdc_expiration_calendar_rule_type varchar(128),
    sdvdc_days_before_key_date integer,
    sdvdc_warning_days integer,
    sdvdc_ordinal integer,
    sdvdc_else_case boolean,
    sdvdc_active boolean
);

CREATE INDEX idx_smart_doc_validity_date_case__pid_version ON staging_octane.smart_doc_validity_date_case (sdvdc_pid, sdvdc_version);

ALTER TABLE staging_octane.criteria_snippet
    ADD COLUMN crs_compatible_with_smart_doc_validity_date_case boolean;

CREATE TABLE staging_octane.proposal_doc_validity (
    prpdv_pid bigint,
    prpdv_version integer,
    constraint pk_proposal_doc_validity primary key (prpdv_pid),
    prpdv_proposal_doc_pid bigint,
    prpdv_smart_doc_validity_date_case_pid bigint,
    prpdv_deal_pid bigint,
    prpdv_proposal_pid bigint,
    prpdv_valid_from_date date,
    prpdv_valid_through_date date,
    prpdv_key_date date,
    prpdv_doc_validity_type varchar(128),
    prpdv_doc_key_date_type varchar(128),
    prpdv_expiration_calendar_rule_type varchar(128),
    prpdv_days_before_key_date integer,
    prpdv_warning_days integer
);

CREATE INDEX idx_proposal_doc_validity__pid_version ON staging_octane.proposal_doc_validity (prpdv_pid, prpdv_version);

--history_octane changes

CREATE TABLE history_octane.smart_doc_validity_date_case (
    sdvdc_pid bigint,
    sdvdc_version integer,
    sdvdc_smart_doc_pid bigint,
    sdvdc_criteria_pid bigint,
    sdvdc_criteria_html varchar(16000),
    sdvdc_deal_child_type varchar(128),
    sdvdc_deal_child_relationship_type varchar(128),
    sdvdc_doc_validity_type varchar(128),
    sdvdc_doc_key_date_type varchar(128),
    sdvdc_expiration_calendar_rule_type varchar(128),
    sdvdc_days_before_key_date integer,
    sdvdc_warning_days integer,
    sdvdc_ordinal integer,
    sdvdc_else_case boolean,
    sdvdc_active boolean,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_smart_doc_validity_date_case__pid ON history_octane.smart_doc_validity_date_case (sdvdc_pid);

CREATE INDEX idx_smart_doc_validity_date_case__data_source_updated_datetime ON history_octane.smart_doc_validity_date_case (data_source_updated_datetime);

CREATE INDEX idx_smart_doc_validity_date_case__data_source_deleted_flag ON history_octane.smart_doc_validity_date_case (data_source_deleted_flag);

CREATE INDEX idx_smart_doc_validity_date_case__pid_version ON history_octane.smart_doc_validity_date_case (sdvdc_pid, sdvdc_version);

CREATE INDEX fk_smart_doc_validity_date_case_1 ON history_octane.smart_doc_validity_date_case (sdvdc_smart_doc_pid);

CREATE INDEX fk_smart_doc_validity_date_case_2 ON history_octane.smart_doc_validity_date_case (sdvdc_criteria_pid);

CREATE INDEX fkt_sdvdc_deal_child_type ON history_octane.smart_doc_validity_date_case (sdvdc_deal_child_type);

CREATE INDEX fkt_sdvdc_deal_child_relationship_type ON history_octane.smart_doc_validity_date_case (sdvdc_deal_child_relationship_type);

CREATE INDEX fkt_sdvdc_doc_validity_type ON history_octane.smart_doc_validity_date_case (sdvdc_doc_validity_type);

CREATE INDEX fkt_sdvdc_doc_key_date_type ON history_octane.smart_doc_validity_date_case (sdvdc_doc_key_date_type);

CREATE INDEX fkt_sdvdc_expiration_calendar_rule_type ON history_octane.smart_doc_validity_date_case (sdvdc_expiration_calendar_rule_type);

ALTER TABLE history_octane.criteria_snippet
    ADD COLUMN crs_compatible_with_smart_doc_validity_date_case boolean;

CREATE TABLE history_octane.proposal_doc_validity (
    prpdv_pid bigint,
    prpdv_version integer,
    prpdv_proposal_doc_pid bigint,
    prpdv_smart_doc_validity_date_case_pid bigint,
    prpdv_deal_pid bigint,
    prpdv_proposal_pid bigint,
    prpdv_valid_from_date date,
    prpdv_valid_through_date date,
    prpdv_key_date date,
    prpdv_doc_validity_type varchar(128),
    prpdv_doc_key_date_type varchar(128),
    prpdv_expiration_calendar_rule_type varchar(128),
    prpdv_days_before_key_date integer,
    prpdv_warning_days integer,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_proposal_doc_validity__pid ON history_octane.proposal_doc_validity (prpdv_pid);

CREATE INDEX idx_proposal_doc_validity__data_source_updated_datetime ON history_octane.proposal_doc_validity (data_source_updated_datetime);

CREATE INDEX idx_proposal_doc_validity__data_source_deleted_flag ON history_octane.proposal_doc_validity (data_source_deleted_flag);

CREATE INDEX idx_proposal_doc_validity__pid_version ON history_octane.proposal_doc_validity (prpdv_pid, prpdv_version);

CREATE INDEX fk_proposal_doc_validity_1 ON history_octane.proposal_doc_validity (prpdv_proposal_doc_pid);

CREATE INDEX fk_proposal_doc_validity_2 ON history_octane.proposal_doc_validity (prpdv_smart_doc_validity_date_case_pid);

CREATE INDEX fk_proposal_doc_validity_3 ON history_octane.proposal_doc_validity (prpdv_deal_pid);

CREATE INDEX fk_proposal_doc_validity_4 ON history_octane.proposal_doc_validity (prpdv_proposal_pid);

CREATE INDEX fkt_prpdv_doc_validity_type ON history_octane.proposal_doc_validity (prpdv_doc_validity_type);

CREATE INDEX fkt_prpdv_doc_key_date_type ON history_octane.proposal_doc_validity (prpdv_doc_key_date_type);

CREATE INDEX fkt_prpdv_expiration_calendar_rule_type ON history_octane.proposal_doc_validity (prpdv_expiration_calendar_rule_type);
