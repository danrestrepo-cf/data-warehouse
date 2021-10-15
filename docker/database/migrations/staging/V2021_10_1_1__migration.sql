ALTER TABLE staging_octane.loan_beneficiary
    ADD COLUMN lb_synthetic_unique_current boolean,
    ADD COLUMN lb_synthetic_unique_initial boolean;

ALTER TABLE staging_octane.smart_charge_case
    ADD COLUMN scc_case_label varchar(108);

ALTER TABLE staging_octane.loan
    ADD COLUMN l_va_agency_case_id varchar(32),
    ADD COLUMN l_fha_agency_case_id varchar(32),
    ADD COLUMN l_usda_agency_case_id varchar(32),
    ADD COLUMN l_va_agency_case_id_assigned_date date,
    ADD COLUMN l_fha_agency_case_id_assigned_date date,
    ADD COLUMN l_usda_agency_case_id_assigned_date date;

ALTER TABLE staging_octane.loan
    DROP COLUMN l_agency_case_id,
    DROP COLUMN l_agency_case_id_assigned_date;

ALTER TABLE staging_octane.proposal_summary
    ADD COLUMN ps_effective_agency_case_id_main varchar(64),
    ADD COLUMN ps_effective_agency_case_id_piggyback varchar(64),
    ADD COLUMN ps_effective_agency_case_id_assigned_date_main date,
    ADD COLUMN ps_effective_agency_case_id_assigned_date_piggyback date;

ALTER TABLE staging_octane.loan_funding
    ADD COLUMN lf_synthetic_unique_active boolean;

CREATE TABLE staging_octane.smart_message_permission_type (
                                                              code varchar(128),
                                                              value varchar(1024),
                                                              constraint pk_smart_message_permission_type primary key (code)
);

CREATE TABLE staging_octane.smart_message_permission (
                                                         smp_pid bigint,
                                                         smp_version integer,
                                                         constraint pk_smart_message_permission primary key (smp_pid),
                                                         smp_smart_message_pid bigint,
                                                         smp_role_pid bigint,
                                                         smp_permission_type varchar(128)
);

CREATE INDEX idx_smart_message_permission__pid_version ON staging_octane.smart_message_permission (smp_pid, smp_version);

CREATE TABLE staging_octane.wf_deal_step_performer_unavailable (
                                                                   wdspu_pid bigint,
                                                                   wdspu_version integer,
                                                                   constraint pk_wf_deal_step_performer_unavailable primary key (wdspu_pid),
                                                                   wdspu_lender_user_pid bigint,
                                                                   wdspu_wf_deal_step_pid bigint,
                                                                   wdspu_days_unavailable integer
);

CREATE INDEX idx_wf_deal_step_performer_unavailable__pid_version ON staging_octane.wf_deal_step_performer_unavailable (wdspu_pid, wdspu_version);

ALTER TABLE staging_octane.lender_user
    ADD COLUMN lu_email_signature_title varchar(128),
    ADD COLUMN lu_termination_date date;

ALTER TABLE staging_octane.loan
    ADD COLUMN l_post_interest_only_first_payment_date date;


ALTER TABLE history_octane.loan_beneficiary
    ADD COLUMN lb_synthetic_unique_current boolean,
    ADD COLUMN lb_synthetic_unique_initial boolean;

ALTER TABLE history_octane.smart_charge_case
    ADD COLUMN scc_case_label varchar(108);

ALTER TABLE history_octane.loan
    ADD COLUMN l_va_agency_case_id varchar(32),
    ADD COLUMN l_fha_agency_case_id varchar(32),
    ADD COLUMN l_usda_agency_case_id varchar(32),
    ADD COLUMN l_va_agency_case_id_assigned_date date,
    ADD COLUMN l_fha_agency_case_id_assigned_date date,
    ADD COLUMN l_usda_agency_case_id_assigned_date date;

ALTER TABLE history_octane.proposal_summary
    ADD COLUMN ps_effective_agency_case_id_main varchar(64),
    ADD COLUMN ps_effective_agency_case_id_piggyback varchar(64),
    ADD COLUMN ps_effective_agency_case_id_assigned_date_main date,
    ADD COLUMN ps_effective_agency_case_id_assigned_date_piggyback date;

ALTER TABLE history_octane.loan_funding
    ADD COLUMN lf_synthetic_unique_active boolean;

CREATE TABLE history_octane.smart_message_permission_type (
                                                              code varchar(128),
                                                              value varchar(1024),
                                                              data_source_updated_datetime timestamptz,
                                                              data_source_deleted_flag boolean
);

CREATE INDEX idx_smart_message_permission_type__data_source_updated_datetime ON history_octane.smart_message_permission_type (data_source_updated_datetime);

CREATE INDEX idx_smart_message_permission_type__data_source_deleted_flag ON history_octane.smart_message_permission_type (data_source_deleted_flag);

CREATE TABLE history_octane.smart_message_permission (
                                                         smp_pid bigint,
                                                         smp_version integer,
                                                         smp_smart_message_pid bigint,
                                                         smp_role_pid bigint,
                                                         smp_permission_type varchar(128),
                                                         data_source_updated_datetime timestamptz,
                                                         data_source_deleted_flag boolean
);

CREATE INDEX idx_smart_message_permission__pid ON history_octane.smart_message_permission (smp_pid);

CREATE INDEX idx_smart_message_permission__data_source_updated_datetime ON history_octane.smart_message_permission (data_source_updated_datetime);

CREATE INDEX idx_smart_message_permission__data_source_deleted_flag ON history_octane.smart_message_permission (data_source_deleted_flag);

CREATE INDEX idx_smart_message_permission__pid_version ON history_octane.smart_message_permission (smp_pid, smp_version);

CREATE INDEX fk_smart_message_permission_1 ON history_octane.smart_message_permission (smp_smart_message_pid);

CREATE INDEX fk_smart_message_permission_2 ON history_octane.smart_message_permission (smp_role_pid);

CREATE INDEX fkt_smp_permission_type ON history_octane.smart_message_permission (smp_permission_type);

CREATE TABLE history_octane.wf_deal_step_performer_unavailable (
                                                                   wdspu_pid bigint,
                                                                   wdspu_version integer,
                                                                   wdspu_lender_user_pid bigint,
                                                                   wdspu_wf_deal_step_pid bigint,
                                                                   wdspu_days_unavailable integer,
                                                                   data_source_updated_datetime timestamptz,
                                                                   data_source_deleted_flag boolean
);

CREATE INDEX idx_wf_deal_step_performer_unavailable__pid ON history_octane.wf_deal_step_performer_unavailable (wdspu_pid);

CREATE INDEX idx_fdd4070c409649d0345ecae4eaff1251 ON history_octane.wf_deal_step_performer_unavailable (data_source_updated_datetime);

CREATE INDEX idx_39af454fd32103c30c4ebcd7e649b094 ON history_octane.wf_deal_step_performer_unavailable (data_source_deleted_flag);

CREATE INDEX idx_wf_deal_step_performer_unavailable__pid_version ON history_octane.wf_deal_step_performer_unavailable (wdspu_pid, wdspu_version);

CREATE INDEX fk_wf_deal_step_performer_unavailable_1 ON history_octane.wf_deal_step_performer_unavailable (wdspu_lender_user_pid);

CREATE INDEX fk_wf_deal_step_performer_unavailable_2 ON history_octane.wf_deal_step_performer_unavailable (wdspu_wf_deal_step_pid);

ALTER TABLE history_octane.lender_user
    ADD COLUMN lu_email_signature_title varchar(128),
    ADD COLUMN lu_termination_date date;

ALTER TABLE history_octane.loan
    ADD COLUMN l_post_interest_only_first_payment_date date;
