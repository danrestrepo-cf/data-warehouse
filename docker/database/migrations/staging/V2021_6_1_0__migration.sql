--
-- EDW | edw_field_definition - fix data type mismatches between dimensions and source fields
-- https://app.asana.com/0/0/1200393611923107
--

ALTER TABLE star_loan.borrower_demographics_dim
    ALTER COLUMN schooling_years TYPE INTEGER USING schooling_years::INTEGER;

--
-- Main | EDW | Octane Schema changes for 2021.6.1.0 (6/4/21)
-- https://app.asana.com/0/0/1200421121421369
--

-- staging_octane changes
CREATE TABLE staging_octane.disclosure_action_type (
    code varchar(128),
    value varchar(1024),
    constraint pk_disclosure_action_type primary key (code)
);

ALTER TABLE staging_octane.proposal
    ADD COLUMN prp_disclosure_action_type varchar(128);

ALTER TABLE staging_octane.construction_cost
    ADD COLUMN coc_permit_pid bigint,
    ADD COLUMN coc_category_type_label varchar(256);

CREATE TABLE staging_octane.proposal_construction (
    prpc_pid bigint,
    prpc_version integer,
    constraint pk_proposal_construction primary key (prpc_pid),
    prpc_proposal_pid bigint,
    prpc_architectural_exhibits boolean,
    prpc_feasibility_study boolean,
    prpc_expected_months_to_complete integer,
    prpc_extension_needed boolean,
    prpc_extension_period_months integer,
    prpc_any_utilities_inoperable varchar(128),
    prpc_non_habitable_months integer,
    prpc_non_habitable_units integer,
    prpc_number_of_draws integer,
    prpc_construction_confirmed_start_date date,
    prpc_loan_in_process_account_closed_date date,
    prpc_mortgage_payment_reserves_required varchar(128)
);

CREATE INDEX idx_proposal_construction__pid_version ON staging_octane.proposal_construction (prpc_pid, prpc_version);

ALTER TABLE staging_octane.product_terms
    ADD COLUMN pt_maximum_number_of_construction_draws integer;

ALTER TABLE staging_octane.proposal
    DROP COLUMN prp_fre_ctp_closing_type;

DROP TABLE IF EXISTS staging_octane.fre_ctp_closing_type;

--history_octane changes
CREATE TABLE history_octane.disclosure_action_type (
    code varchar(128),
    value varchar(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_disclosure_action_type__data_source_updated_datetime ON history_octane.disclosure_action_type (data_source_updated_datetime);

CREATE INDEX idx_disclosure_action_type__data_source_deleted_flag ON history_octane.disclosure_action_type (data_source_deleted_flag);

ALTER TABLE history_octane.proposal
    ADD COLUMN prp_disclosure_action_type varchar(128);

CREATE INDEX fkt_prp_disclosure_action_type ON history_octane.proposal (prp_disclosure_action_type);

ALTER TABLE history_octane.construction_cost
    ADD COLUMN coc_permit_pid bigint,
    ADD COLUMN coc_category_type_label varchar(256);

CREATE INDEX fk_construction_cost_4 ON history_octane.construction_cost (coc_permit_pid);

CREATE TABLE history_octane.proposal_construction (
    prpc_pid bigint,
    prpc_version integer,
    prpc_proposal_pid bigint,
    prpc_architectural_exhibits boolean,
    prpc_feasibility_study boolean,
    prpc_expected_months_to_complete integer,
    prpc_extension_needed boolean,
    prpc_extension_period_months integer,
    prpc_any_utilities_inoperable varchar(128),
    prpc_non_habitable_months integer,
    prpc_non_habitable_units integer,
    prpc_number_of_draws integer,
    prpc_construction_confirmed_start_date date,
    prpc_loan_in_process_account_closed_date date,
    prpc_mortgage_payment_reserves_required varchar(128),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_proposal_construction__pid ON history_octane.proposal_construction (prpc_pid);

CREATE INDEX idx_proposal_construction__data_source_updated_datetime ON history_octane.proposal_construction (data_source_updated_datetime);

CREATE INDEX idx_proposal_construction__data_source_deleted_flag ON history_octane.proposal_construction (data_source_deleted_flag);

CREATE INDEX idx_proposal_construction__pid_version ON history_octane.proposal_construction (prpc_pid, prpc_version);

CREATE INDEX fk_proposal_construction_1 ON history_octane.proposal_construction (prpc_proposal_pid);

CREATE INDEX fkt_prpc_any_utilities_inoperable ON history_octane.proposal_construction (prpc_any_utilities_inoperable);

CREATE INDEX fkt_prpc_mortgage_payment_reserves_required ON history_octane.proposal_construction (prpc_mortgage_payment_reserves_required);

ALTER TABLE history_octane.product_terms
    ADD COLUMN pt_maximum_number_of_construction_draws integer;
