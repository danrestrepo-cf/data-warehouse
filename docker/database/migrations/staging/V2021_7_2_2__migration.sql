--
-- EDW | DDL changes - Octane Schema changes for 2021.7.3.0 (7/16/21)
-- https://app.asana.com/0/0/1200594538672335
--

-- staging changes
ALTER TABLE staging_octane.mcr_loan
    ALTER COLUMN mcrl_servicing_transfer_type SET DATA TYPE varchar(128),
    ADD COLUMN mcrl_financed_property_improvements_category_type varchar(128);

ALTER TABLE staging_octane.deal_check_type
    ADD COLUMN dct_id_num integer;

ALTER TABLE staging_octane.deal_check_type
    ALTER COLUMN dct_id_num SET DATA TYPE integer;

ALTER TABLE staging_octane.place
    ADD COLUMN pl_acquisition_date_verified boolean,
    ADD COLUMN pl_acquisition_cost_amount_verified boolean,
    ADD COLUMN pl_property_tax_id_verified boolean,
    ADD COLUMN pl_seller_acquired_date_verified boolean,
    ADD COLUMN pl_seller_original_cost_amount_verified boolean;

CREATE TABLE staging_octane.contractor_validation_status_type (
    code varchar(128),
    value varchar(1024),
    constraint pk_contractor_validation_status_type primary key (code)
);

ALTER TABLE staging_octane.proposal_contractor
    ALTER COLUMN pctr_proposal_pid SET DATA TYPE bigint,
    ALTER COLUMN pctr_contractor_pid SET DATA TYPE bigint;

ALTER TABLE staging_octane.contractor
    ADD COLUMN ctr_verified boolean,
    ADD COLUMN ctr_validation_status_type varchar(128);

ALTER TABLE staging_octane.appraisal
    ADD COLUMN apr_second_decision_appraisal boolean;

-- history changes
ALTER TABLE history_octane.mcr_loan
    ALTER COLUMN mcrl_servicing_transfer_type SET DATA TYPE varchar(128),
    ADD COLUMN mcrl_financed_property_improvements_category_type varchar(128);

CREATE INDEX fkt_mcrl_financed_property_improvements_category_type ON history_octane.mcr_loan (mcrl_financed_property_improvements_category_type);

ALTER TABLE history_octane.deal_check_type
    ADD COLUMN dct_id_num integer;

ALTER TABLE history_octane.deal_check_type
    ALTER COLUMN dct_id_num SET DATA TYPE integer;

ALTER TABLE history_octane.place
    ADD COLUMN pl_acquisition_date_verified boolean,
    ADD COLUMN pl_acquisition_cost_amount_verified boolean,
    ADD COLUMN pl_property_tax_id_verified boolean,
    ADD COLUMN pl_seller_acquired_date_verified boolean,
    ADD COLUMN pl_seller_original_cost_amount_verified boolean;

CREATE TABLE history_octane.contractor_validation_status_type (
    code varchar(128),
    value varchar(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_6be95126131f734ffcfd5460184b7498 ON history_octane.contractor_validation_status_type (data_source_updated_datetime);

CREATE INDEX idx_contractor_validation_status_type__data_source_deleted_flag ON history_octane.contractor_validation_status_type (data_source_deleted_flag);

ALTER TABLE history_octane.proposal_contractor
    ALTER COLUMN pctr_proposal_pid SET DATA TYPE bigint,
    ALTER COLUMN pctr_contractor_pid SET DATA TYPE bigint;

ALTER TABLE history_octane.contractor
    ADD COLUMN ctr_verified boolean,
    ADD COLUMN ctr_validation_status_type varchar(128);

CREATE INDEX fkt_ctr_validation_status_type ON history_octane.contractor (ctr_validation_status_type);

ALTER TABLE history_octane.appraisal
    ADD COLUMN apr_second_decision_appraisal boolean;
