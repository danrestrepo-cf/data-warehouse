--
-- EDW | Octane schemas for 5.1.1 (5/7/21)
-- https://app.asana.com/0/0/1200287819794006/
--

-- Octane 2021.5.1.0: staging_octane updates
ALTER TABLE staging_octane.lender_user_interest_type
    ALTER COLUMN value SET DATA TYPE varchar(1024);

ALTER TABLE staging_octane.lender_user_language_type
    ALTER COLUMN value SET DATA TYPE varchar(1024);

CREATE TABLE staging_octane.construction_cost_calculation_type (
    code varchar(128),
    value varchar(1024),
        constraint pk_construction_cost_calculation_type primary key (code)
);

ALTER TABLE staging_octane.construction_cost
    ADD COLUMN coc_calculation_percentage numeric(11,9),
    ADD COLUMN coc_construction_cost_calculation_type varchar(128);

ALTER TABLE staging_octane.deal
    ADD COLUMN d_initial_cancel_status_date date;

ALTER TABLE staging_octane.lock_series
    ALTER COLUMN lsr_org_lineage_pid SET DATA TYPE bigint;

CREATE TABLE staging_octane.proposal_hud_consultant (
    phc_pid bigint,
    phc_version integer,
    constraint pk_proposal_hud_consultant primary key (phc_pid),
    phc_proposal_pid bigint,
    phc_consultant_id varchar(8),
    phc_company_name varchar(128),
    phc_first_name varchar(32),
    phc_last_name varchar(32),
    phc_email varchar(256),
    phc_mobile_phone varchar(32),
    phc_office_phone varchar(32),
    phc_office_phone_extension varchar(16),
    phc_fax varchar(32),
    phc_address_street1 varchar(128),
    phc_address_street2 varchar(128),
    phc_address_city varchar(128),
    phc_address_state varchar(128),
    phc_address_postal_code varchar(128)
);

CREATE INDEX idx_proposal_hud_consultant__pid_version ON staging_octane.proposal_hud_consultant (phc_pid, phc_version);

ALTER TABLE staging_octane.proposal
    ADD COLUMN prp_hud_consultant varchar(128);

ALTER TABLE staging_octane.proposal
    DROP COLUMN prp_fha_203k_consultant_id;

ALTER TABLE staging_octane.borrower
    ADD COLUMN b_credit_report_required boolean;

-- Octane 2021.5.1.0: history_octane updates
ALTER TABLE history_octane.lender_user_interest_type
    ALTER COLUMN value SET DATA TYPE varchar(1024);

CREATE INDEX fkt_lui_lender_user_interest_type ON history_octane.lender_user_interest (lui_lender_user_interest_type);

CREATE INDEX fk_lender_user_interest_1 ON history_octane.lender_user_interest (lui_lender_user_pid);

ALTER TABLE history_octane.lender_user_language_type
    ALTER COLUMN value SET DATA TYPE varchar(1024);

CREATE INDEX fkt_lul_lender_user_language_type ON history_octane.lender_user_language (lul_lender_user_language_type);

CREATE INDEX fk_lender_user_language_1 ON history_octane.lender_user_language (lul_lender_user_pid);

CREATE TABLE history_octane.construction_cost_calculation_type (
    code varchar(128),
    value varchar(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_7656eaa42cb0143a669e7cac89195b0b ON history_octane.construction_cost_calculation_type (data_source_updated_datetime);

CREATE INDEX idx_71558683987989f155c1b9c281adf219 ON history_octane.construction_cost_calculation_type (data_source_deleted_flag);

ALTER TABLE history_octane.construction_cost
    ADD COLUMN coc_calculation_percentage numeric(11,9),
    ADD COLUMN coc_construction_cost_calculation_type varchar(128);

CREATE INDEX fkt_coc_construction_cost_calculation_type ON history_octane.construction_cost (coc_construction_cost_calculation_type);

ALTER TABLE history_octane.deal
    ADD COLUMN d_initial_cancel_status_date date;

ALTER TABLE history_octane.lock_series
    ALTER COLUMN lsr_org_lineage_pid SET DATA TYPE bigint;

CREATE TABLE history_octane.proposal_hud_consultant (
    phc_pid bigint,
    phc_version integer,
    phc_proposal_pid bigint,
    phc_consultant_id varchar(8),
    phc_company_name varchar(128),
    phc_first_name varchar(32),
    phc_last_name varchar(32),
    phc_email varchar(256),
    phc_mobile_phone varchar(32),
    phc_office_phone varchar(32),
    phc_office_phone_extension varchar(16),
    phc_fax varchar(32),
    phc_address_street1 varchar(128),
    phc_address_street2 varchar(128),
    phc_address_city varchar(128),
    phc_address_state varchar(128),
    phc_address_postal_code varchar(128),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_proposal_hud_consultant__pid ON history_octane.proposal_hud_consultant (phc_pid);

CREATE INDEX idx_proposal_hud_consultant__data_source_updated_datetime ON history_octane.proposal_hud_consultant (data_source_updated_datetime);

CREATE INDEX idx_proposal_hud_consultant__data_source_deleted_flag ON history_octane.proposal_hud_consultant (data_source_deleted_flag);

CREATE INDEX idx_proposal_hud_consultant__pid_version ON history_octane.proposal_hud_consultant (phc_pid, phc_version);

CREATE INDEX fk_proposal_hud_consultant_1 ON history_octane.proposal_hud_consultant (phc_proposal_pid);

ALTER TABLE history_octane.proposal
    ADD COLUMN prp_hud_consultant varchar(128);

CREATE INDEX fkt_prp_hud_consultant ON history_octane.proposal (prp_hud_consultant);

ALTER TABLE history_octane.borrower
    ADD COLUMN b_credit_report_required boolean;

-- Octane 2021.5.1.1: staging_octane updates
ALTER TABLE staging_octane.deal_key_roles
    ADD COLUMN dkrs_internal_construction_manager_lender_user_pid bigint,
    ADD COLUMN dkrs_internal_construction_manager_fmls varchar(128);

-- Octane 2021.5.1.1: history_octane updates
ALTER TABLE history_octane.deal_key_roles
    ADD COLUMN dkrs_internal_construction_manager_lender_user_pid bigint,
    ADD COLUMN dkrs_internal_construction_manager_fmls varchar(128);

CREATE INDEX fk_deal_key_roles_35 ON history_octane.deal_key_roles (dkrs_internal_construction_manager_lender_user_pid);
