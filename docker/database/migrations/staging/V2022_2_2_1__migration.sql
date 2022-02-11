--
-- Main | EDW | Octane schemas from prod-release to v2022.2.2.1 on uat
-- https://app.asana.com/0/0/1201788240114334
--

-- staging_octane
ALTER TABLE staging_octane.place
ADD COLUMN pl_verified_geocode boolean;

CREATE TABLE staging_octane.deal_update_type (
code varchar(128),
value varchar(1024),
constraint pk_deal_update_type primary key (code)
);

CREATE TABLE staging_octane.deal_pending_update (
dpu_pid bigint,
dpu_version integer,
constraint pk_deal_pending_update primary key (dpu_pid),
dpu_deal_pid bigint,
dpu_deal_update_type varchar(128),
dpu_args_json text,
dpu_create_datetime timestamp,
dpu_last_attempt_start_datetime timestamp,
dpu_last_attempt_end_datetime timestamp,
dpu_completed_datetime timestamp,
dpu_run_count integer
);

CREATE INDEX idx_deal_pending_update__pid_version ON staging_octane.deal_pending_update (dpu_pid, dpu_version);

ALTER TABLE staging_octane.role_charge_permissions
ADD COLUMN rcp_payer_other_editable boolean;

ALTER TABLE staging_octane.role_charge_permissions RENAME COLUMN rcp_payer_non_lender_editable TO rcp_payer_borrower_seller_editable;

CREATE TABLE staging_octane.proposal_review_request_type (
code varchar(128),
value varchar(1024),
constraint pk_proposal_review_request_type primary key (code)
);

ALTER TABLE staging_octane.proposal_review
ADD COLUMN prpre_scenario_proposal_pid bigint,
ADD COLUMN prpre_scenario_proposal_name varchar(128),
ADD COLUMN prpre_requested_proposal_snapshot_pid bigint,
ADD COLUMN prpre_completed_proposal_snapshot_pid bigint,
ADD COLUMN prpre_proposal_review_request_type varchar(128),
ADD COLUMN prpre_create_datetime timestamp;

CREATE TABLE staging_octane.wf_step_function_parameters (
wsfp_pid bigint,
wsfp_version integer,
constraint pk_wf_step_function_parameters primary key (wsfp_pid),
wsfp_wf_step_pid bigint,
wsfp_proposal_review_id integer,
wsfp_proposal_review_status_type varchar(128)
);

CREATE INDEX idx_wf_step_function_parameters__pid_version ON staging_octane.wf_step_function_parameters (wsfp_pid, wsfp_version);

ALTER TABLE staging_octane.deal_summary
ADD COLUMN ds_proposal_review_requested_count integer;

-- history_octane
ALTER TABLE history_octane.place
ADD COLUMN pl_verified_geocode boolean;

CREATE TABLE history_octane.deal_update_type (
code varchar(128),
value varchar(1024),
data_source_updated_datetime timestamptz,
data_source_deleted_flag boolean,
etl_batch_id text
);

CREATE INDEX idx_deal_update_type__code ON history_octane.deal_update_type (code);

CREATE INDEX idx_deal_update_type__data_source_updated_datetime ON history_octane.deal_update_type (data_source_updated_datetime);

CREATE INDEX idx_deal_update_type__data_source_deleted_flag ON history_octane.deal_update_type (data_source_deleted_flag);

CREATE INDEX idx_deal_update_type__etl_batch_id ON history_octane.deal_update_type (etl_batch_id);

CREATE TABLE history_octane.deal_pending_update (
dpu_pid bigint,
dpu_version integer,
dpu_deal_pid bigint,
dpu_deal_update_type varchar(128),
dpu_args_json text,
dpu_create_datetime timestamp,
dpu_last_attempt_start_datetime timestamp,
dpu_last_attempt_end_datetime timestamp,
dpu_completed_datetime timestamp,
dpu_run_count integer,
data_source_updated_datetime timestamptz,
data_source_deleted_flag boolean,
etl_batch_id text
);

CREATE INDEX idx_deal_pending_update__pid ON history_octane.deal_pending_update (dpu_pid);

CREATE INDEX idx_deal_pending_update__data_source_updated_datetime ON history_octane.deal_pending_update (data_source_updated_datetime);

CREATE INDEX idx_deal_pending_update__data_source_deleted_flag ON history_octane.deal_pending_update (data_source_deleted_flag);

CREATE INDEX idx_deal_pending_update__etl_batch_id ON history_octane.deal_pending_update (etl_batch_id);

CREATE INDEX idx_deal_pending_update__pid_version ON history_octane.deal_pending_update (dpu_pid, dpu_version);

CREATE INDEX fk_deal_pending_update_1 ON history_octane.deal_pending_update (dpu_deal_pid);

CREATE INDEX fkt_dpu_deal_update_type ON history_octane.deal_pending_update (dpu_deal_update_type);

ALTER TABLE history_octane.role_charge_permissions
ADD COLUMN rcp_payer_other_editable boolean;

ALTER TABLE history_octane.role_charge_permissions RENAME COLUMN rcp_payer_non_lender_editable TO rcp_payer_borrower_seller_editable;

CREATE TABLE history_octane.proposal_review_request_type (
code varchar(128),
value varchar(1024),
data_source_updated_datetime timestamptz,
data_source_deleted_flag boolean,
etl_batch_id text
);

CREATE INDEX idx_proposal_review_request_type__code ON history_octane.proposal_review_request_type (code);

CREATE INDEX idx_proposal_review_request_type__data_source_updated_datetime ON history_octane.proposal_review_request_type (data_source_updated_datetime);

CREATE INDEX idx_proposal_review_request_type__data_source_deleted_flag ON history_octane.proposal_review_request_type (data_source_deleted_flag);

CREATE INDEX idx_proposal_reveiew_request_type__etl_batch_id ON history_octane.proposal_review_request_type (etl_batch_id);

ALTER TABLE history_octane.proposal_review
ADD COLUMN prpre_scenario_proposal_pid bigint,
ADD COLUMN prpre_scenario_proposal_name varchar(128),
ADD COLUMN prpre_requested_proposal_snapshot_pid bigint,
ADD COLUMN prpre_completed_proposal_snapshot_pid bigint,
ADD COLUMN prpre_proposal_review_request_type varchar(128),
ADD COLUMN prpre_create_datetime timestamp;

CREATE INDEX fkt_prpre_proposal_review_request_type ON history_octane.proposal_review (prpre_proposal_review_request_type);

CREATE INDEX fk_proposal_review_4 ON history_octane.proposal_review (prpre_scenario_proposal_pid);

CREATE INDEX fk_proposal_review_5 ON history_octane.proposal_review (prpre_requested_proposal_snapshot_pid);

CREATE INDEX fk_proposal_review_6 ON history_octane.proposal_review (prpre_completed_proposal_snapshot_pid);

CREATE TABLE history_octane.wf_step_function_parameters (
wsfp_pid bigint,
wsfp_version integer,
wsfp_wf_step_pid bigint,
wsfp_proposal_review_id integer,
wsfp_proposal_review_status_type varchar(128),
data_source_updated_datetime timestamptz,
data_source_deleted_flag boolean,
etl_batch_id text
);

CREATE INDEX idx_wf_step_function_parameters__pid ON history_octane.wf_step_function_parameters (wsfp_pid);

CREATE INDEX idx_wf_step_function_parameters__data_source_updated_datetime ON history_octane.wf_step_function_parameters (data_source_updated_datetime);

CREATE INDEX idx_wf_step_function_parameters__data_source_deleted_flag ON history_octane.wf_step_function_parameters (data_source_deleted_flag);

CREATE INDEX idx_wf_step_function_parameters__etl_batch_id ON history_octane.wf_step_function_parameters (etl_batch_id);

CREATE INDEX idx_wf_step_function_parameters__pid_version ON history_octane.wf_step_function_parameters (wsfp_pid, wsfp_version);

CREATE INDEX fk_wf_step_function_parameters_1 ON history_octane.wf_step_function_parameters (wsfp_wf_step_pid);

CREATE INDEX fkt_wsfp_proposal_review_status_type ON history_octane.wf_step_function_parameters (wsfp_proposal_review_status_type);

ALTER TABLE history_octane.deal_summary
ADD COLUMN ds_proposal_review_requested_count integer;

--
-- EDW | add index to lender_user columns used in loan_lender_user_access ETL join
-- https://app.asana.com/0/0/1201824069136219
--

CREATE INDEX idx_lender_user__lu_username_lu_account_pid ON history_octane.lender_user (lu_username, lu_account_pid);
