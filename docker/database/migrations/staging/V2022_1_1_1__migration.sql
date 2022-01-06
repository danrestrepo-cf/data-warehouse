--
-- EDW | star_loan - remove country fields from lender_user_dim
-- https://app.asana.com/0/0/1201615556752354
--

ALTER TABLE star_loan.lender_user_dim
    DROP COLUMN country_code,
    DROP COLUMN country;

--
-- Main | EDW - Octane schemas from prod-release to uat (2022-01-07)
-- https://app.asana.com/0/0/1201625431714639
--

--staging_octane changes

ALTER TABLE staging_octane.new_lock_only_add_on
    ALTER COLUMN nlo_add_on_prefix SET DATA TYPE VARCHAR(128);

CREATE TABLE staging_octane.fha_case_type (
    code VARCHAR(128),
    value VARCHAR(1024),
    CONSTRAINT pk_fha_case_type
        PRIMARY KEY (code)
);

CREATE TABLE staging_octane.section_of_act_type (
    code VARCHAR(128),
    value VARCHAR(1024),
    CONSTRAINT pk_section_of_act_type
        PRIMARY KEY (code)
);

ALTER TABLE staging_octane.loan
    ADD COLUMN l_fha_case_type VARCHAR(128),
    ADD COLUMN l_section_of_act_type VARCHAR(128);

--history_octane changes

ALTER TABLE history_octane.new_lock_only_add_on
    ALTER COLUMN nlo_add_on_prefix SET DATA TYPE VARCHAR(128);

CREATE TABLE history_octane.fha_case_type (
    code VARCHAR(128),
    value VARCHAR(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN,
    etl_batch_id TEXT
);

CREATE INDEX idx_fha_case_type__code ON history_octane.fha_case_type (code);

CREATE INDEX idx_fha_case_type__data_source_updated_datetime ON history_octane.fha_case_type (data_source_updated_datetime);

CREATE INDEX idx_fha_case_type__data_source_deleted_flag ON history_octane.fha_case_type (data_source_deleted_flag);

CREATE INDEX idx_fha_case_type__etl_batch_id ON history_octane.fha_case_type (etl_batch_id);

CREATE TABLE history_octane.section_of_act_type (
    code VARCHAR(128),
    value VARCHAR(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN,
    etl_batch_id TEXT
);

CREATE INDEX idx_section_of_act_type__code ON history_octane.section_of_act_type (code);

CREATE INDEX idx_section_of_act_type__data_source_updated_datetime ON history_octane.section_of_act_type (data_source_updated_datetime);

CREATE INDEX idx_section_of_act_type__data_source_deleted_flag ON history_octane.section_of_act_type (data_source_deleted_flag);

CREATE INDEX idx_section_of_act_type__etl_batch_id ON history_octane.section_of_act_type (etl_batch_id);

ALTER TABLE history_octane.loan
    ADD COLUMN l_fha_case_type VARCHAR(128),
    ADD COLUMN l_section_of_act_type VARCHAR(128);

CREATE INDEX fkt_l_fha_case_type ON history_octane.loan (l_fha_case_type);

CREATE INDEX fkt_l_section_of_act_type ON history_octane.loan (l_section_of_act_type);
