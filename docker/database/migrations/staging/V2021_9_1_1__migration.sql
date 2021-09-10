--
-- Main | EDW - Octane schemas from prod-release to v2021.9.2.0 on uat
-- https://app.asana.com/0/0/1200944665668886
--

-- staging_octane changes
ALTER TABLE staging_octane.borrower
    ADD COLUMN b_snapshotted_pid bigint;

CREATE TABLE staging_octane.lender_concession_item (
    lci_pid bigint,
    lci_version integer,
    constraint pk_lender_concession_item primary key (lci_pid),
    lci_lender_concession_request_pid bigint,
    lci_loan_charge_pid bigint,
    lci_allocation_amount numeric(15,2),
    lci_absorb_cost boolean
);

CREATE INDEX idx_lender_concession_item__pid_version ON staging_octane.lender_concession_item (lci_pid, lci_version);

CREATE TABLE staging_octane.lender_concession_request_number_ticker (
    lcrnt_pid bigint,
    lcrnt_version integer,
        constraint pk_lender_concession_request_number_ticker primary key (lcrnt_pid),
    lcrnt_proposal_pid bigint,
    lcrnt_next_lender_concession_request_number bigint
);

CREATE INDEX idx_lender_concession_request_number_ticker__pid_version ON staging_octane.lender_concession_request_number_ticker (lcrnt_pid, lcrnt_version);

ALTER TABLE staging_octane.lender_concession_request
    ADD COLUMN lcr_unallocated_amount numeric(15,2),
    ADD COLUMN lcr_lender_concession_request_number integer;


-- history_octane changes
ALTER TABLE history_octane.borrower
    ADD COLUMN b_snapshotted_pid bigint;

CREATE TABLE history_octane.lender_concession_item (
    lci_pid bigint,
    lci_version integer,
    lci_lender_concession_request_pid bigint,
    lci_loan_charge_pid bigint,
    lci_allocation_amount numeric(15,2),
    lci_absorb_cost boolean,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_lender_concession_item__pid ON history_octane.lender_concession_item (lci_pid);

CREATE INDEX idx_lender_concession_item__data_source_updated_datetime ON history_octane.lender_concession_item (data_source_updated_datetime);

CREATE INDEX idx_lender_concession_item__data_source_deleted_flag ON history_octane.lender_concession_item (data_source_deleted_flag);

CREATE INDEX idx_lender_concession_item__pid_version ON history_octane.lender_concession_item (lci_pid, lci_version);

CREATE INDEX fk_lender_concession_item_1 ON history_octane.lender_concession_item (lci_lender_concession_request_pid);

CREATE INDEX fk_lender_concession_item_2 ON history_octane.lender_concession_item (lci_loan_charge_pid);

CREATE TABLE history_octane.lender_concession_request_number_ticker (
    lcrnt_pid bigint,
    lcrnt_version integer,
    lcrnt_proposal_pid bigint,
    lcrnt_next_lender_concession_request_number bigint,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_lender_concession_request_number_ticker__pid ON history_octane.lender_concession_request_number_ticker (lcrnt_pid);

CREATE INDEX idx_cfe9d2dd748f954c64b257eeaeca2383 ON history_octane.lender_concession_request_number_ticker (data_source_updated_datetime);

CREATE INDEX idx_2669e76ab84e8f7ff70b4cb684225037 ON history_octane.lender_concession_request_number_ticker (data_source_deleted_flag);

CREATE INDEX idx_lender_concession_request_number_ticker__pid_version ON history_octane.lender_concession_request_number_ticker (lcrnt_pid, lcrnt_version);

CREATE INDEX fk_lender_concession_request_number_ticker_1 ON history_octane.lender_concession_request_number_ticker (lcrnt_proposal_pid);

ALTER TABLE history_octane.lender_concession_request
    ADD COLUMN lcr_unallocated_amount numeric(15,2),
    ADD COLUMN lcr_lender_concession_request_number integer;
