--
-- EDW | DDL changes - Octane Schema changes for 2021.7.2.0 (7/9/21)
-- https://app.asana.com/0/0/1200568462822754
--

-- staging changes

CREATE TABLE staging_octane.mortgage_delinquency_exception_type (
    code varchar(128),
    value varchar(1024),
    constraint pk_mortgage_delinquency_exception_type primary key (code)
);

ALTER TABLE staging_octane.liability_place
    ADD COLUMN lip_mortgage_delinquency_exception_type varchar(128);

-- history changes

CREATE TABLE history_octane.mortgage_delinquency_exception_type (
    code varchar(128),
    value varchar(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_1c3c44b635f19d240fc3b257dd7e2f57 ON history_octane.mortgage_delinquency_exception_type (data_source_updated_datetime);

CREATE INDEX idx_2bb086413c4670caa97913f40af9fabc ON history_octane.mortgage_delinquency_exception_type (data_source_deleted_flag);

ALTER TABLE history_octane.liability_place
    ADD COLUMN lip_mortgage_delinquency_exception_type varchar(128);

CREATE INDEX fkt_lip_mortgage_delinquency_exception_type ON history_octane.liability_place (lip_mortgage_delinquency_exception_type);
