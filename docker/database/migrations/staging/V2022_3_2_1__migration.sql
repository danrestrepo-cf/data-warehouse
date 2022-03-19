--
-- Main | EDW | Octane schema synchronization for v2022.3.3.0 (2022-03-18) (https://app.asana.com/0/0/1201986460557023)
--

-- staging_octane
CREATE TABLE staging_octane.business_income_borrower_title_type (
                                                                    code varchar(128),
                                                                    value varchar(1024),
                                                                    constraint pk_business_income_borrower_title_type primary key (code)
);

ALTER TABLE staging_octane.business_income
    ADD COLUMN bui_borrower_title_type varchar(128),
    ADD COLUMN bui_borrower_title_other_description varchar(128);

ALTER TABLE staging_octane.tax_transcript_request
    ADD COLUMN ttr_include_1120s boolean,
    ADD COLUMN ttr_include_1120s_return_transcript boolean,
    ADD COLUMN ttr_include_1120s_account_transcript boolean,
    ADD COLUMN ttr_include_1120s_record_of_account boolean,
    ADD COLUMN ttr_business_income_borrower_title varchar(128);

ALTER TABLE staging_octane.config_note
    DROP COLUMN cn_old_location_note_pid,
    DROP COLUMN cn_old_smart_doc_note_pid,
    DROP COLUMN cn_old_wf_process_note_pid,
    DROP COLUMN cn_old_wf_step_note_pid;

DROP TABLE IF EXISTS staging_octane.location_note_comment;
DROP TABLE IF EXISTS staging_octane.location_note_monitor;
DROP TABLE IF EXISTS staging_octane.location_note;
DROP TABLE IF EXISTS staging_octane.smart_doc_note_comment;
DROP TABLE IF EXISTS staging_octane.smart_doc_note_monitor;
DROP TABLE IF EXISTS staging_octane.smart_doc_note;
DROP TABLE IF EXISTS staging_octane.wf_process_note_comment;
DROP TABLE IF EXISTS staging_octane.wf_process_note_monitor;
DROP TABLE IF EXISTS staging_octane.wf_process_note;
DROP TABLE IF EXISTS staging_octane.wf_step_note_comment;
DROP TABLE IF EXISTS staging_octane.wf_step_note_monitor;
DROP TABLE IF EXISTS staging_octane.wf_step_note;

ALTER TABLE staging_octane.proposal_construction
    ADD COLUMN prpc_effective_construction_completion_date date;

ALTER TABLE staging_octane.proposal
    ADD COLUMN prp_loan_modification_agreement_executed_received_datetime timestamp;

ALTER TABLE staging_octane.deal_key_roles
    ADD COLUMN dkrs_contract_processor_lender_user_pid bigint,
    ADD COLUMN dkrs_contract_processor_fmls varchar(128);

CREATE TABLE staging_octane.lender_user_role_org_node (
                                                          luron_pid bigint,
                                                          luron_version integer,
                                                          constraint pk_lender_user_role_org_node primary key (luron_pid),
                                                          luron_lender_user_role_pid bigint,
                                                          luron_org_node_pid bigint
);

CREATE INDEX idx_lender_user_role_org_node__pid_version ON staging_octane.lender_user_role_org_node (luron_pid, luron_version);

ALTER TABLE staging_octane.lead_source RENAME COLUMN lds_broker_compensation_type TO lds_compensation_type;

ALTER TABLE staging_octane.broker_compensation_type RENAME TO compensation_type;


-- history_octane
CREATE TABLE history_octane.business_income_borrower_title_type (
                                                                    code varchar(128),
                                                                    value varchar(1024),
                                                                    data_source_updated_datetime timestamptz,
                                                                    data_source_deleted_flag boolean
);

CREATE INDEX idx_898065ca79b025eefdcd6f0ca5afc58f ON history_octane.business_income_borrower_title_type (data_source_updated_datetime);

CREATE INDEX idx_b78cf088169e6891324efd3341e9eb0e ON history_octane.business_income_borrower_title_type (data_source_deleted_flag);

ALTER TABLE history_octane.business_income
    ADD COLUMN bui_borrower_title_type varchar(128),
    ADD COLUMN bui_borrower_title_other_description varchar(128);

CREATE INDEX fkt_bui_borrower_title_type ON history_octane.business_income (bui_borrower_title_type);

ALTER TABLE history_octane.tax_transcript_request
    ADD COLUMN ttr_include_1120s boolean,
    ADD COLUMN ttr_include_1120s_return_transcript boolean,
    ADD COLUMN ttr_include_1120s_account_transcript boolean,
    ADD COLUMN ttr_include_1120s_record_of_account boolean,
    ADD COLUMN ttr_business_income_borrower_title varchar(128);

ALTER TABLE history_octane.proposal_construction
    ADD COLUMN prpc_effective_construction_completion_date date;

ALTER TABLE history_octane.proposal
    ADD COLUMN prp_loan_modification_agreement_executed_received_datetime timestamp;

ALTER TABLE history_octane.deal_key_roles
    ADD COLUMN dkrs_contract_processor_lender_user_pid bigint,
    ADD COLUMN dkrs_contract_processor_fmls varchar(128);

CREATE INDEX fk_deal_key_roles_43 ON history_octane.deal_key_roles (dkrs_contract_processor_lender_user_pid);

CREATE TABLE history_octane.lender_user_role_org_node (
                                                          luron_pid bigint,
                                                          luron_version integer,
                                                          luron_lender_user_role_pid bigint,
                                                          luron_org_node_pid bigint,
                                                          data_source_updated_datetime timestamptz,
                                                          data_source_deleted_flag boolean
);

CREATE INDEX idx_lender_user_role_org_node__pid ON history_octane.lender_user_role_org_node (luron_pid);

CREATE INDEX idx_lender_user_role_org_node__data_source_updated_datetime ON history_octane.lender_user_role_org_node (data_source_updated_datetime);

CREATE INDEX idx_lender_user_role_org_node__data_source_deleted_flag ON history_octane.lender_user_role_org_node (data_source_deleted_flag);

CREATE INDEX idx_lender_user_role_org_node__pid_version ON history_octane.lender_user_role_org_node (luron_pid, luron_version);

CREATE INDEX fk_lender_user_role_org_node_1 ON history_octane.lender_user_role_org_node (luron_lender_user_role_pid);

CREATE INDEX fk_lender_user_role_org_node_2 ON history_octane.lender_user_role_org_node (luron_org_node_pid);

ALTER TABLE history_octane.lead_source RENAME COLUMN lds_broker_compensation_type TO lds_compensation_type;

ALTER TABLE history_octane.broker_compensation_type RENAME TO compensation_type;
