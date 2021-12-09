CREATE TABLE staging_octane.rate_sheet_group (
                                                 rsg_pid bigint,
                                                 rsg_version integer,
                                                 constraint pk_rate_sheet_group primary key (rsg_pid),
                                                 rsg_account_pid bigint,
                                                 rsg_rate_sheet_group_id varchar(32),
                                                 rsg_rate_sheet_group_name varchar(128),
                                                 rsg_investor_pid bigint,
                                                 rsg_loan_amortization_type varchar(128)
);

CREATE INDEX idx_rate_sheet_group__pid_version ON staging_octane.rate_sheet_group (rsg_pid, rsg_version);

CREATE TABLE staging_octane.rate_sheet_group_member (
                                                        rsgm_pid bigint,
                                                        rsgm_version integer,
                                                        constraint pk_rate_sheet_group_member primary key (rsgm_pid),
                                                        rsgm_rate_sheet_group_pid bigint,
                                                        rsgm_product_pid bigint,
                                                        rsgm_from_date date,
                                                        rsgm_through_date date
);

CREATE INDEX idx_rate_sheet_group_member__pid_version ON staging_octane.rate_sheet_group_member (rsgm_pid, rsgm_version);

ALTER TABLE staging_octane.rate_sheet
    ALTER COLUMN rs_product_pid SET DATA TYPE bigint,
    ADD COLUMN rs_rate_sheet_group_pid bigint;

ALTER TABLE staging_octane.smart_ledger_plan_case_version
    ADD COLUMN slpcv_last_modified_by varchar(128),
    ADD COLUMN slpcv_last_modified_datetime timestamp;

ALTER TABLE staging_octane.asset
    ADD COLUMN as_snapshotted_pid bigint;

ALTER TABLE staging_octane.liability
    ADD COLUMN lia_snapshotted_pid bigint;

ALTER TABLE staging_octane.proposal_grant_program
    ADD COLUMN pgp_snapshotted_pid bigint;

ALTER TABLE staging_octane.borrower_income
    ADD COLUMN bi_snapshotted_pid bigint;

ALTER TABLE staging_octane.place
    ADD COLUMN pl_snapshotted_pid bigint;

ALTER TABLE staging_octane.asset_large_deposit
    ADD COLUMN ald_snapshotted_pid bigint;
















CREATE TABLE history_octane.rate_sheet_group (
rsg_pid bigint,
rsg_version integer,
rsg_account_pid bigint,
rsg_rate_sheet_group_id varchar(32),
rsg_rate_sheet_group_name varchar(128),
rsg_investor_pid bigint,
rsg_loan_amortization_type varchar(128),
data_source_updated_datetime timestamptz,
data_source_deleted_flag boolean
);

CREATE INDEX idx_rate_sheet_group__pid ON history_octane.rate_sheet_group (rsg_pid);

CREATE INDEX idx_rate_sheet_group__data_source_updated_datetime ON history_octane.rate_sheet_group (data_source_updated_datetime);

CREATE INDEX idx_rate_sheet_group__data_source_deleted_flag ON history_octane.rate_sheet_group (data_source_deleted_flag);

CREATE INDEX idx_rate_sheet_group__pid_version ON history_octane.rate_sheet_group (rsg_pid, rsg_version);

CREATE INDEX fk_rate_sheet_group_1 ON history_octane.rate_sheet_group (rsg_account_pid);

CREATE INDEX fk_rate_sheet_group_2 ON history_octane.rate_sheet_group (rsg_investor_pid);

CREATE INDEX fkt_rsg_loan_amortization_type ON history_octane.rate_sheet_group (rsg_loan_amortization_type);

CREATE TABLE history_octane.rate_sheet_group_member (
rsgm_pid bigint,
rsgm_version integer,
rsgm_rate_sheet_group_pid bigint,
rsgm_product_pid bigint,
rsgm_from_date date,
rsgm_through_date date,
data_source_updated_datetime timestamptz,
data_source_deleted_flag boolean
);

CREATE INDEX idx_rate_sheet_group_member__pid ON history_octane.rate_sheet_group_member (rsgm_pid);

CREATE INDEX idx_rate_sheet_group_member__data_source_updated_datetime ON history_octane.rate_sheet_group_member (data_source_updated_datetime);

CREATE INDEX idx_rate_sheet_group_member__data_source_deleted_flag ON history_octane.rate_sheet_group_member (data_source_deleted_flag);

CREATE INDEX idx_rate_sheet_group_member__pid_version ON history_octane.rate_sheet_group_member (rsgm_pid, rsgm_version);

CREATE INDEX fk_rate_sheet_group_member_1 ON history_octane.rate_sheet_group_member (rsgm_rate_sheet_group_pid);

CREATE INDEX fk_rate_sheet_group_member_2 ON history_octane.rate_sheet_group_member (rsgm_product_pid);

ALTER TABLE history_octane.rate_sheet 
ALTER COLUMN rs_product_pid SET DATA TYPE bigint,
ADD COLUMN rs_rate_sheet_group_pid bigint;

CREATE INDEX fk_rate_sheet_2 ON history_octane.rate_sheet (rs_rate_sheet_group_pid);

ALTER TABLE history_octane.smart_ledger_plan_case_version 
ADD COLUMN slpcv_last_modified_by varchar(128),
ADD COLUMN slpcv_last_modified_datetime timestamp;

ALTER TABLE history_octane.asset 
ADD COLUMN as_snapshotted_pid bigint;

ALTER TABLE history_octane.liability 
ADD COLUMN lia_snapshotted_pid bigint;

ALTER TABLE history_octane.proposal_grant_program 
ADD COLUMN pgp_snapshotted_pid bigint;

ALTER TABLE history_octane.borrower_income 
ADD COLUMN bi_snapshotted_pid bigint;

ALTER TABLE history_octane.place 
ADD COLUMN pl_snapshotted_pid bigint;

ALTER TABLE history_octane.asset_large_deposit 
ADD COLUMN ald_snapshotted_pid bigint;

