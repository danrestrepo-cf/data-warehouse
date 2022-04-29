--
-- Main | EDW | Octane schema synchronization for v2022.4.5.0 (2022-04-29)
-- https://app.asana.com/0/0/1202177783000740
--

--staging_octane
CREATE TABLE staging_octane.mcr_state_snapshot (
    mcrss_pid BIGINT,
    mcrss_version INTEGER,
    CONSTRAINT pk_mcr_state_snapshot
        PRIMARY KEY (mcrss_pid),
    mcrss_mcr_snapshot_pid BIGINT,
    mcrss_subject_property_state VARCHAR(128),
    mcrss_applications_in_process_borrower_loan_amount BIGINT,
    mcrss_applications_in_process_borrower_loan_count BIGINT,
    mcrss_applications_in_process_third_party_loan_amount BIGINT,
    mcrss_applications_in_process_third_party_loan_count BIGINT
);

CREATE INDEX idx_mcr_state_snapshot__mcrss_pid_mcrss_version ON staging_octane.mcr_state_snapshot (mcrss_pid, mcrss_version);

ALTER TABLE staging_octane.location
    ADD COLUMN loc_amt_location_code VARCHAR(16);

--history_octane
CREATE TABLE history_octane.mcr_state_snapshot (
    mcrss_pid BIGINT,
    mcrss_version INTEGER,
    mcrss_mcr_snapshot_pid BIGINT,
    mcrss_subject_property_state VARCHAR(128),
    mcrss_applications_in_process_borrower_loan_amount BIGINT,
    mcrss_applications_in_process_borrower_loan_count BIGINT,
    mcrss_applications_in_process_third_party_loan_amount BIGINT,
    mcrss_applications_in_process_third_party_loan_count BIGINT,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN,
    etl_batch_id TEXT
);

CREATE INDEX idx_mcr_state_snapshot__mcrss_pid ON history_octane.mcr_state_snapshot (mcrss_pid);

CREATE INDEX idx_mcr_state_snapshot__data_source_updated_datetime ON history_octane.mcr_state_snapshot (data_source_updated_datetime);

CREATE INDEX idx_mcr_state_snapshot__data_source_deleted_flag ON history_octane.mcr_state_snapshot (data_source_deleted_flag);

CREATE INDEX idx_mcr_state_snapshot__etl_batch_id ON history_octane.mcr_state_snapshot (etl_batch_id);

CREATE INDEX idx_mcr_state_snapshot__mcrss_pid_mcrss_version ON history_octane.mcr_state_snapshot (mcrss_pid, mcrss_version);

CREATE INDEX fk_mcr_state_snapshot_1 ON history_octane.mcr_state_snapshot (mcrss_mcr_snapshot_pid);

ALTER TABLE history_octane.location
    ADD COLUMN loc_amt_location_code VARCHAR(16);
