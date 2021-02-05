/*
EDW | Create an Octane schema in staging, should copy the Octane schema minus any sensitive fields (SSN, etc)
https://app.asana.com/0/0/1199681185367867
*/

create table QRTZ_CALENDARS
(
    SCHED_NAME varchar(120) not null,
    CALENDAR_NAME varchar(200) not null,
    CALENDAR blob not null,
    primary key (SCHED_NAME, CALENDAR_NAME)
);

create table QRTZ_FIRED_TRIGGERS
(
    SCHED_NAME varchar(120) not null,
    ENTRY_ID varchar(95) not null,
    TRIGGER_NAME varchar(200) not null,
    TRIGGER_GROUP varchar(200) not null,
    INSTANCE_NAME varchar(200) not null,
    FIRED_TIME bigint(13) not null,
    SCHED_TIME bigint(13) not null,
    PRIORITY int not null,
    STATE varchar(16) not null,
    JOB_NAME varchar(200) null,
    JOB_GROUP varchar(200) null,
    IS_NONCONCURRENT varchar(1) null,
    REQUESTS_RECOVERY varchar(1) null,
    primary key (SCHED_NAME, ENTRY_ID)
);

create index IDX_QRTZ_FT_INST_JOB_REQ_RCVRY
    on QRTZ_FIRED_TRIGGERS (SCHED_NAME, INSTANCE_NAME, REQUESTS_RECOVERY);

create index IDX_QRTZ_FT_JG
    on QRTZ_FIRED_TRIGGERS (SCHED_NAME, JOB_GROUP);

create index IDX_QRTZ_FT_J_G
    on QRTZ_FIRED_TRIGGERS (SCHED_NAME, JOB_NAME, JOB_GROUP);

create index IDX_QRTZ_FT_TG
    on QRTZ_FIRED_TRIGGERS (SCHED_NAME, TRIGGER_GROUP);

create index IDX_QRTZ_FT_TRIG_INST_NAME
    on QRTZ_FIRED_TRIGGERS (SCHED_NAME, INSTANCE_NAME);

create index IDX_QRTZ_FT_T_G
    on QRTZ_FIRED_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);

create table QRTZ_JOB_DETAILS
(
    SCHED_NAME varchar(120) not null,
    JOB_NAME varchar(200) not null,
    JOB_GROUP varchar(200) not null,
    DESCRIPTION varchar(250) null,
    JOB_CLASS_NAME varchar(250) not null,
    IS_DURABLE varchar(1) not null,
    IS_NONCONCURRENT varchar(1) not null,
    IS_UPDATE_DATA varchar(1) not null,
    REQUESTS_RECOVERY varchar(1) not null,
    JOB_DATA blob null,
    primary key (SCHED_NAME, JOB_NAME, JOB_GROUP)
);

create index IDX_QRTZ_J_GRP
    on QRTZ_JOB_DETAILS (SCHED_NAME, JOB_GROUP);

create index IDX_QRTZ_J_REQ_RECOVERY
    on QRTZ_JOB_DETAILS (SCHED_NAME, REQUESTS_RECOVERY);

create table QRTZ_LOCKS
(
    SCHED_NAME varchar(120) not null,
    LOCK_NAME varchar(40) not null,
    primary key (SCHED_NAME, LOCK_NAME)
);

create table QRTZ_PAUSED_TRIGGER_GRPS
(
    SCHED_NAME varchar(120) not null,
    TRIGGER_GROUP varchar(200) not null,
    primary key (SCHED_NAME, TRIGGER_GROUP)
);

create table QRTZ_SCHEDULER_STATE
(
    SCHED_NAME varchar(120) not null,
    INSTANCE_NAME varchar(200) not null,
    LAST_CHECKIN_TIME bigint(13) not null,
    CHECKIN_INTERVAL bigint(13) not null,
    primary key (SCHED_NAME, INSTANCE_NAME)
);

create table QRTZ_TRIGGERS
(
    SCHED_NAME varchar(120) not null,
    TRIGGER_NAME varchar(200) not null,
    TRIGGER_GROUP varchar(200) not null,
    JOB_NAME varchar(200) not null,
    JOB_GROUP varchar(200) not null,
    DESCRIPTION varchar(250) null,
    NEXT_FIRE_TIME bigint(13) null,
    PREV_FIRE_TIME bigint(13) null,
    PRIORITY int null,
    TRIGGER_STATE varchar(16) not null,
    TRIGGER_TYPE varchar(8) not null,
    START_TIME bigint(13) not null,
    END_TIME bigint(13) null,
    CALENDAR_NAME varchar(200) null,
    MISFIRE_INSTR smallint(2) null,
    JOB_DATA blob null,
    primary key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
    constraint QRTZ_TRIGGERS_ibfk_1
        foreign key (SCHED_NAME, JOB_NAME, JOB_GROUP) references QRTZ_JOB_DETAILS (SCHED_NAME, JOB_NAME, JOB_GROUP)
);

create table QRTZ_BLOB_TRIGGERS
(
    SCHED_NAME varchar(120) not null,
    TRIGGER_NAME varchar(200) not null,
    TRIGGER_GROUP varchar(200) not null,
    BLOB_DATA blob null,
    primary key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
    constraint QRTZ_BLOB_TRIGGERS_ibfk_1
        foreign key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) references QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
);

create index SCHED_NAME
    on QRTZ_BLOB_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);

create table QRTZ_CRON_TRIGGERS
(
    SCHED_NAME varchar(120) not null,
    TRIGGER_NAME varchar(200) not null,
    TRIGGER_GROUP varchar(200) not null,
    CRON_EXPRESSION varchar(120) not null,
    TIME_ZONE_ID varchar(80) null,
    primary key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
    constraint QRTZ_CRON_TRIGGERS_ibfk_1
        foreign key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) references QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
);

create table QRTZ_SIMPLE_TRIGGERS
(
    SCHED_NAME varchar(120) not null,
    TRIGGER_NAME varchar(200) not null,
    TRIGGER_GROUP varchar(200) not null,
    REPEAT_COUNT bigint(7) not null,
    REPEAT_INTERVAL bigint(12) not null,
    TIMES_TRIGGERED bigint(10) not null,
    primary key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
    constraint QRTZ_SIMPLE_TRIGGERS_ibfk_1
        foreign key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) references QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
);

create table QRTZ_SIMPROP_TRIGGERS
(
    SCHED_NAME varchar(120) not null,
    TRIGGER_NAME varchar(200) not null,
    TRIGGER_GROUP varchar(200) not null,
    STR_PROP_1 varchar(512) null,
    STR_PROP_2 varchar(512) null,
    STR_PROP_3 varchar(512) null,
    INT_PROP_1 int null,
    INT_PROP_2 int null,
    LONG_PROP_1 bigint null,
    LONG_PROP_2 bigint null,
    DEC_PROP_1 decimal(13,4) null,
    DEC_PROP_2 decimal(13,4) null,
    BOOL_PROP_1 varchar(1) null,
    BOOL_PROP_2 varchar(1) null,
    primary key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
    constraint QRTZ_SIMPROP_TRIGGERS_ibfk_1
        foreign key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) references QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
);

create index IDX_QRTZ_T_C
    on QRTZ_TRIGGERS (SCHED_NAME, CALENDAR_NAME);

create index IDX_QRTZ_T_G
    on QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_GROUP);

create index IDX_QRTZ_T_J
    on QRTZ_TRIGGERS (SCHED_NAME, JOB_NAME, JOB_GROUP);

create index IDX_QRTZ_T_JG
    on QRTZ_TRIGGERS (SCHED_NAME, JOB_GROUP);

create index IDX_QRTZ_T_NEXT_FIRE_TIME
    on QRTZ_TRIGGERS (SCHED_NAME, NEXT_FIRE_TIME);

create index IDX_QRTZ_T_NFT_MISFIRE
    on QRTZ_TRIGGERS (SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME);

create index IDX_QRTZ_T_NFT_ST
    on QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_STATE, NEXT_FIRE_TIME);

create index IDX_QRTZ_T_NFT_ST_MISFIRE
    on QRTZ_TRIGGERS (SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME, TRIGGER_STATE);

create index IDX_QRTZ_T_NFT_ST_MISFIRE_GRP
    on QRTZ_TRIGGERS (SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME, TRIGGER_GROUP, TRIGGER_STATE);

create index IDX_QRTZ_T_N_G_STATE
    on QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_GROUP, TRIGGER_STATE);

create index IDX_QRTZ_T_N_STATE
    on QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, TRIGGER_STATE);

create index IDX_QRTZ_T_STATE
    on QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_STATE);

create table account_event_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table account_id_sequence
(
    ais_id bigint auto_increment
        primary key
);

create table account_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table account
(
    a_pid bigint auto_increment
        primary key,
    a_version int not null,
    a_account_id bigint not null,
    a_account_name varchar(128) not null,
    a_gfe_interest_rate_expiration_days int null,
    a_gfe_lock_duration_days int null,
    a_gfe_lock_before_settlement_days int null,
    a_proposal_expiration_days int null,
    a_uw_expiration_days int null,
    a_conditional_commitment_expiration_days int not null,
    a_account_from_date date not null,
    a_account_status_type varchar(128) not null,
    a_account_through_date date null,
    a_initial_los_loan_id bigint not null,
    a_uuts_master_contact_name varchar(128) not null,
    a_uuts_master_contact_title varchar(128) not null,
    a_uuts_master_office_phone varchar(16) not null,
    a_uuts_master_office_phone_extension varchar(32) not null,
    a_allonge_representative_name varchar(128) not null,
    a_allonge_representative_title varchar(128) not null,
    a_account_borrower_site_id varchar(128) null,
    a_originator_borrower_sites_enabled bit null,
    a_company_borrower_site_enabled bit null,
    a_discount_included_in_origination_fee bit null,
    a_uuts_use_master_contact bit null,
    a_borrower_job_gap_lookback_years int null,
    a_borrower_job_gap_minimum_days int null,
    a_lender_app_host varchar(256) null,
    a_lender_app_ip_address varchar(32) null,
    a_advance_period_days int null,
    a_account_destroy_mode bit null,
    a_lender_user_password_expire_days int null,
    a_lender_user_password_minimum_change_days int null,
    a_lender_user_previous_password_ban int null,
    a_paid_through_current_month_required_day_of_month int null,
    a_disclosure_change_threshold_cash_to_close decimal(15,2) not null,
    a_disclosure_change_threshold_monthly_payment decimal(15,2) not null,
    a_disclosure_action_required_days int null,
    a_le_to_cd_seasoning_days int null,
    a_disclosure_max_arm_apr_change_percent decimal(11,9) not null,
    a_disclosure_max_non_arm_apr_change_percent decimal(11,9) not null,
    a_initial_le_delivered_mailed_seasoning_days int null,
    a_revised_le_delivered_mailed_seasoning_days int not null,
    a_revised_le_received_signed_seasoning_days int null,
    a_significant_cd_delivered_mailed_seasoning_days int null,
    a_significant_cd_received_signed_seasoning_days int null,
    a_supported_states text null,
    constraint a_account_id
        unique (a_account_id),
    constraint fkt_a_account_status_type
        foreign key (a_account_status_type) references account_status_type (code)
);

create table account_event
(
    ae_pid bigint auto_increment
        primary key,
    ae_version int not null,
    ae_account_pid bigint not null,
    ae_create_datetime datetime not null,
    ae_account_event_type varchar(128) not null,
    ae_detail varchar(16000) null,
    ae_source_unparsed_name varchar(128) null,
    ae_ip_address varchar(32) null,
    ae_client_agent varchar(256) null,
    constraint fk_account_event_1
        foreign key (ae_account_pid) references account (a_pid),
    constraint fkt_ae_account_event_type
        foreign key (ae_account_event_type) references account_event_type (code)
);

create index idx_account_event_1
    on account_event (ae_create_datetime);

create index idx_account_event_2
    on account_event (ae_create_datetime, ae_account_event_type, ae_account_pid);

create table admin_user_event_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table admin_user_event
(
    aue_pid bigint auto_increment
        primary key,
    aue_version int not null,
    aue_create_datetime datetime not null,
    aue_detail varchar(16000) null,
    aue_source_unparsed_name varchar(128) null,
    aue_admin_user_event_type varchar(128) not null,
    aue_ip_address varchar(32) null,
    aue_client_agent varchar(256) null,
    constraint fkt_aue_admin_user_event_type
        foreign key (aue_admin_user_event_type) references admin_user_event_type (code)
);

create table admin_user_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table agency_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table agent_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table announcement
(
    ann_pid bigint auto_increment
        primary key,
    ann_version int not null,
    ann_lender_text varchar(1024) null,
    ann_borrower_text varchar(1024) null,
    ann_from_datetime datetime null,
    ann_to_datetime datetime null
);

create table annual_monthly_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table applicant_role_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table application_taken_method_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table application_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table appraisal_condition_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table appraisal_entry_contact_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table appraisal_file_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table appraisal_form_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table appraisal_hold_reason_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table appraisal_hold_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table appraisal_management_company_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table appraisal_order_coarse_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table appraisal_order_request_file_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table appraisal_order_request_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table appraisal_order_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table appraisal_purpose_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table appraisal_source_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table appraisal_underwriter_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table area_median_income_table
(
    amit_pid bigint auto_increment
        primary key,
    amit_version int not null,
    amit_account_pid bigint not null,
    amit_from_date date not null,
    amit_uploader_unparsed_name varchar(128) not null,
    amit_upload_datetime datetime not null,
    constraint uc_1
        unique (amit_account_pid, amit_from_date),
    constraint fk_area_median_income_table_1
        foreign key (amit_account_pid) references account (a_pid)
);

create table arm_index_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table arm_index_rate
(
    air_pid bigint auto_increment
        primary key,
    air_version int not null,
    air_arm_index_type varchar(128) not null,
    air_effective_datetime datetime not null,
    air_rate decimal(11,9) not null,
    constraint fkt_air_arm_index_type
        foreign key (air_arm_index_type) references arm_index_type (code)
);

create index idx_arm_index_rate_1
    on arm_index_rate (air_arm_index_type);

create index idx_arm_index_rate_2
    on arm_index_rate (air_effective_datetime);

create table asset_account_holder_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table asset_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table aus_credit_service_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table aus_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table backfill_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table bankruptcy_exception_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table bid_pool_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table bid_pool
(
    bp_pid bigint auto_increment
        primary key,
    bp_version int not null,
    bp_account_pid bigint not null,
    bp_bid_pool_name varchar(32) null,
    bp_bid_pool_status_type varchar(128) not null,
    bp_create_datetime date not null,
    constraint fk_bid_pool_1
        foreign key (bp_account_pid) references account (a_pid),
    constraint fkt_bp_bid_pool_status_type
        foreign key (bp_bid_pool_status_type) references bid_pool_status_type (code)
);

create table borrower_associated_address_explanation_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table borrower_associated_address_source_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table borrower_income_category_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table borrower_relationship_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table borrower_residency_basis_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table borrower_tiny_id_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table borrower_user_account_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table borrower_user_deal_access_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table branch_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table building_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table business_disposition_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table business_income_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table business_ownership_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table buydown_base_date_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table buydown_contributor_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table buydown_schedule_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table buydown_subsidy_calculation_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table calendar_rule_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table challenge_question_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table channel_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table channel
(
    ch_pid bigint auto_increment
        primary key,
    ch_version int not null,
    ch_account_pid bigint not null,
    ch_id varchar(32) null,
    ch_name varchar(128) null,
    ch_channel_type varchar(128) not null,
    constraint uk_channel_1
        unique (ch_account_pid, ch_id),
    constraint uk_channel_2
        unique (ch_account_pid, ch_name),
    constraint fk_channel_1
        foreign key (ch_account_pid) references account (a_pid),
    constraint fkt_ch_channel_type
        foreign key (ch_channel_type) references channel_type (code)
);

create table charge_input_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table charge_payee_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table charge_payer_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table charge_source_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table charge_wire_action_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table circumstance_change_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table citizenship_residency_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table clg_flood_cert_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table closing_document_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table coarse_event_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table community_lending_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table company_admin_event_entity_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table company_admin_event
(
    cae_pid bigint auto_increment
        primary key,
    cae_version int not null,
    cae_account_pid bigint not null,
    cae_company_admin_event_entity_type varchar(128) not null,
    cae_message varchar(256) not null,
    cae_diff_list text not null,
    cae_unparsed_name varchar(128) not null,
    cae_event_date date not null,
    cae_event_datetime datetime not null,
    cae_target_entity_pid bigint not null,
    constraint fk_company_admin_event_1
        foreign key (cae_account_pid) references account (a_pid),
    constraint fkt_cae_company_admin_event_entity_type
        foreign key (cae_company_admin_event_entity_type) references company_admin_event_entity_type (code)
);

create index idx_company_admin_event_1
    on company_admin_event (cae_event_date);

create table company_state_license_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table config_export_permission_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table construction_cost_category_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table construction_cost_funding_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table construction_cost_payee_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table construction_cost_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table construction_draw_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table construction_draw_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table construction_lot_ownership_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table consumer_privacy_request_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table cost_center
(
    cosc_pid bigint auto_increment
        primary key,
    cosc_version int not null,
    cosc_account_pid bigint not null,
    cosc_amb_code varchar(16) not null,
    cosc_name varchar(128) not null,
    cosc_comments varchar(1024) not null,
    cosc_active bit not null,
    constraint uk_cost_center_1
        unique (cosc_account_pid, cosc_name),
    constraint fk_cost_center_1
        foreign key (cosc_account_pid) references account (a_pid)
);

create table country_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table account_contact
(
    ac_pid bigint auto_increment
        primary key,
    ac_version int not null,
    ac_account_pid bigint not null,
    ac_unparsed_name varchar(128) not null,
    ac_note varchar(256) null,
    ac_search_text varchar(256) null,
    ac_tags varchar(256) null,
    ac_first_name varchar(32) null,
    ac_middle_name varchar(32) null,
    ac_last_name varchar(32) null,
    ac_name_suffix varchar(32) null,
    ac_company_name varchar(128) not null,
    ac_title varchar(128) null,
    ac_office_phone varchar(32) null,
    ac_office_phone_extension varchar(16) null,
    ac_mobile_phone varchar(32) null,
    ac_email varchar(256) null,
    ac_fax varchar(32) null,
    ac_address_street1 varchar(128) null,
    ac_address_street2 varchar(128) null,
    ac_address_city varchar(128) null,
    ac_address_state varchar(128) null,
    ac_address_postal_code varchar(128) null,
    ac_address_country varchar(128) not null,
    ac_home_phone varchar(32) null,
    ac_closing_document_email varchar(256) null,
    ac_license_number varchar(128) null,
    ac_supervisory_license_number varchar(128) null,
    ac_license_state varchar(128) not null,
    constraint fk_account_contact_1
        foreign key (ac_account_pid) references account (a_pid),
    constraint fkt_ac_address_country
        foreign key (ac_address_country) references country_type (code)
);

create table courier_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table credit_authorization_method_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table credit_bureau_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table credit_business_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table credit_inquiry_explanation_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table credit_inquiry_result_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table credit_limit_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table credit_loan_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table credit_report_request_action_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table credit_report_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table credit_request_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table credit_request_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table credit_request_via_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table credit_score_model_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table criteria
(
    cr_pid bigint auto_increment
        primary key,
    cr_version int not null,
    cr_account_pid bigint not null,
    cr_criteria_source varchar(16000) not null,
    cr_criteria_sql varchar(16000) not null,
    cr_criteria_owner_instance_name varchar(2048) not null,
    cr_criteria_source_html text not null,
    cr_criteria_source_pretty_text text not null,
    constraint fk_criteria_1
        foreign key (cr_account_pid) references account (a_pid)
);

create table criteria_owner_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table criteria_pid_operand_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table custodian
(
    cu_pid bigint auto_increment
        primary key,
    cu_version int not null,
    cu_account_pid bigint not null,
    cu_custodian_id varchar(32) null,
    cu_custodian_name varchar(128) not null,
    cu_address_street1 varchar(128) not null,
    cu_address_street2 varchar(128) not null,
    cu_address_city varchar(128) not null,
    cu_address_state varchar(128) not null,
    cu_address_postal_code varchar(128) not null,
    cu_address_country varchar(128) not null,
    cu_custodian_phone varchar(32) null,
    cu_custodian_mers_org_id varchar(7) null,
    cu_whole_loan_fin varchar(11) null,
    cu_mbs_loan_fin varchar(11) null,
    cu_register_with_mers bit not null,
    constraint fkt_cu_address_country
        foreign key (cu_address_country) references country_type (code)
);

create table days_per_year_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_cancel_reason_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_change_updater_time
(
    dcut_pid bigint auto_increment
        primary key,
    dcut_version int not null,
    dcut_account_pid bigint not null,
    dcut_los_loan_id_main bigint not null,
    dcut_start_time datetime not null,
    dcut_start_date date not null,
    dcut_overall_duration_ms bigint not null,
    dcut_deal_checks_ms bigint not null,
    dcut_deal_updates_ms bigint not null,
    dcut_proposal_updates_ms bigint not null,
    dcut_num_proposal_updates int null,
    dcut_application_updates_ms bigint not null,
    dcut_num_application_updates int null,
    dcut_borrower_updates_ms bigint not null,
    dcut_num_borrower_updates int null,
    dcut_place_updates_ms bigint not null,
    dcut_num_place_updates int null,
    dcut_loan_updates_ms bigint not null,
    dcut_num_loan_updates int null,
    dcut_proposal_updates_after_loan_updates_ms bigint not null,
    dcut_updates_after_proposal_updates_ms bigint not null,
    dcut_proposal_summary_updates_ms bigint not null,
    dcut_deal_updates_after_all_proposal_updates_ms bigint not null,
    dcut_smart_charge_update_ms bigint not null,
    dcut_circumstance_change_updates_ms bigint not null,
    dcut_num_circumstance_change_updates int null,
    dcut_tolerance_cure_update_ms bigint not null,
    dcut_proposal_summary_updates_after_smart_charge_updates_ms bigint not null,
    dcut_update_doc_sets_ms bigint not null,
    dcut_closing_funds_itemization_ms bigint not null,
    dcut_update_ribbon_for_deal_ms bigint not null,
    dcut_num_construction_draw_updates int not null,
    dcut_construction_draw_updates_ms bigint not null,
    constraint fk_deal_change_updater_time_1
        foreign key (dcut_account_pid) references account (a_pid)
);

create index idx_deal_change_updater_time_1
    on deal_change_updater_time (dcut_start_time);

create index idx_deal_change_updater_time_2
    on deal_change_updater_time (dcut_start_date);

create table deal_check_severity_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_check_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_child_relationship_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_child_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table criteria_snippet
(
    crs_pid bigint auto_increment
        primary key,
    crs_version int not null,
    crs_account_pid bigint not null,
    crs_name varchar(35) not null,
    crs_criteria_pid bigint not null,
    crs_description varchar(16000) not null,
    crs_deal_child_type varchar(128) not null,
    crs_compatible_with_smart_charge_case bit not null,
    crs_compatible_with_smart_req bit not null,
    crs_compatible_with_stack_separator bit not null,
    crs_compatible_with_investor_eligibility bit not null,
    crs_compatible_with_wf_smart_task bit not null,
    crs_compatible_with_wf_outcome bit not null,
    crs_compatible_with_wf_smart_process bit not null,
    crs_compatible_with_smart_doc_criteria bit not null,
    constraint uk_criteria_snippet_1
        unique (crs_name, crs_account_pid),
    constraint fk_criteria_snippet_1
        foreign key (crs_account_pid) references account (a_pid),
    constraint fk_criteria_snippet_2
        foreign key (crs_criteria_pid) references criteria (cr_pid),
    constraint fkt_crs_deal_child_type
        foreign key (crs_deal_child_type) references deal_child_type (code)
);

create table deal_contact_role_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_context_permission_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_create_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_event_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_id_sequence
(
    dis_id bigint auto_increment
        primary key
);

create table deal_invoice_file_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_invoice_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_note_scope_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_orphan_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_stage_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_tag_access_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_tag_level_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table deal_tag_definition
(
    dtd_pid bigint auto_increment
        primary key,
    dtd_version int not null,
    dtd_account_pid bigint not null,
    dtd_tag_name varchar(32) null,
    dtd_deal_tag_level_type varchar(128) not null,
    dtd_deal_tag_access_type varchar(128) not null,
    constraint fk_deal_tag_definition_1
        foreign key (dtd_account_pid) references account (a_pid),
    constraint fkt_dtd_deal_tag_access_type
        foreign key (dtd_deal_tag_access_type) references deal_tag_access_type (code),
    constraint fkt_dtd_deal_tag_level_type
        foreign key (dtd_deal_tag_level_type) references deal_tag_level_type (code)
);

create table deal_task_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table decision_credit_score_calc_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table delivery_aus_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table disaster_declaration_check_date_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table doc_action_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table doc_approval_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table doc_borrower_access_mode_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table doc_category_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table doc_external_provider_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table doc_file_source_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table doc_fulfill_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table doc_key_date_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table doc_level_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table doc_package_canceled_reason_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table doc_package_delivery_method_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table doc_package_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table doc_permission_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table doc_set_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table doc_validity_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table document_import_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table document_import_vendor_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table du_key_finding_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table du_recommendation_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table du_request_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table dw_export_request_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table ecoa_denial_reason_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table effective_property_value_explanation_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table effective_property_value_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table email_closing_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table ernst_deed_request_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table ernst_page_rec_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table ernst_request_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table ernst_security_instrument_request_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table esign_package_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table esign_vendor_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table export_permission_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table export_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table external_entity_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fault_tolerant_event_registration
(
    fter_message_id varchar(128) not null
        primary key,
    fter_queue_name varchar(128) not null,
    fter_event_type varchar(128) not null,
    fter_create_datetime datetime not null,
    fter_processed_datetime datetime null
);

create table fema_flood_zone_designation_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fha_non_arms_length_ltv_limit_exception_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fha_program_code_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fha_rehab_program_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fha_special_program_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fha_va_bor_cert_sales_price_exceeds_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table field_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table flood_cert_vendor_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table flood_certificate_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fnm_arm_plan_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fnm_community_lending_product_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fnm_community_seconds_repayment_structure_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fnm_investor_remittance_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fnm_mbs_loan_default_loss_party_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fnm_mbs_reo_marketing_party_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table for_further_credit_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fre_community_program_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fre_ctp_closing_feature_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fre_ctp_closing_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fre_doc_level_description_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fre_purchase_eligibility_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table fund_source_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table funding_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null,
    fst_ordinal int not null
);

create table gender_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table gift_funds_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table account_grant_program
(
    agp_pid bigint auto_increment
        primary key,
    agp_version int not null,
    agp_account_pid bigint not null,
    agp_from_date date null,
    agp_through_date date null,
    agp_program_id varchar(32) not null,
    agp_program_name varchar(128) not null,
    agp_program_funds_type varchar(128) not null,
    agp_donor_name varchar(128) not null,
    agp_donor_phone varchar(32) not null,
    agp_address_street1 varchar(128) not null,
    agp_address_street2 varchar(128) not null,
    agp_address_city varchar(128) not null,
    agp_address_state varchar(128) not null,
    agp_address_postal_code varchar(128) not null,
    agp_address_country varchar(128) not null,
    agp_ein varchar(10) not null,
    agp_wire_action_type varchar(128) not null,
    agp_notes varchar(1024) not null,
    constraint uk_account_grant_program_1
        unique (agp_account_pid, agp_program_id),
    constraint fk_account_grant_program_1
        foreign key (agp_account_pid) references account (a_pid),
    constraint fkt_agp_program_funds_type
        foreign key (agp_program_funds_type) references gift_funds_type (code),
    constraint fkt_agp_wire_action_type
        foreign key (agp_wire_action_type) references charge_wire_action_type (code)
);

create table gse_version_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table heloc_cancel_fee_applicable_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table hmda_action_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table hmda_agency_id_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table hmda_denial_reason_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table hmda_ethnicity_2017_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table hmda_hoepa_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table hmda_purchaser_of_loan_2017_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table hmda_purchaser_of_loan_2018_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table hmda_race_2017_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table hoepa_thresholds
(
    ht_pid bigint auto_increment
        primary key,
    ht_version int not null,
    ht_effective_date date not null,
    ht_total_loan_amount_threshold decimal(15) not null,
    ht_points_and_fees_threshold_amount decimal(15) not null,
    ht_first_lien_rate_spread_threshold decimal(11,9) not null,
    ht_subordinate_lien_rate_spread_threshold decimal(11,9) not null,
    ht_max_points_and_fees_percent_over_threshold decimal(11,9) not null,
    ht_max_points_and_fees_percent_under_threshold decimal(11,9) not null,
    constraint uc_ht_effective_date
        unique (ht_effective_date)
);

create table homeownership_education_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table housing_counseling_agency_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table housing_counseling_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table hud_fha_de_approval_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table hve_confidence_level_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table income_history_calc_method_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table intent_to_proceed_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table interest_only_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table interim_funder_mers_registration_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table interim_funder
(
    if_pid bigint auto_increment
        primary key,
    if_version int not null,
    if_account_pid bigint not null,
    if_company_name varchar(128) not null,
    if_company_contact_unparsed_name varchar(128) null,
    if_company_address_street1 varchar(128) not null,
    if_company_address_street2 varchar(128) not null,
    if_company_address_city varchar(128) not null,
    if_company_address_state varchar(128) not null,
    if_company_address_postal_code varchar(128) not null,
    if_company_address_country varchar(128) not null,
    if_company_office_phone varchar(32) null,
    if_company_office_phone_extension varchar(16) null,
    if_company_email varchar(256) null,
    if_company_fax varchar(32) null,
    if_company_mers_org_id varchar(7) null,
    if_remarks varchar(1024) null,
    if_from_date date not null,
    if_through_date date null,
    if_custodian_pid bigint null,
    if_reimbursement_wire_credit_to_name varchar(128) not null,
    if_reimbursement_wire_attention_unparsed_name varchar(128) not null,
    if_reimbursement_wire_authorized_signer_unparsed_name varchar(128) not null,
    if_reimbursement_wire_routing_number varchar(16) null,
    if_reimbursement_wire_account_number varchar(16) null,
    if_return_wire_credit_to_name varchar(128) not null,
    if_return_wire_attention_unparsed_name varchar(128) not null,
    if_return_wire_authorized_signer_unparsed_name varchar(128) not null,
    if_return_wire_routing_number varchar(16) null,
    if_return_wire_account_number varchar(16) null,
    if_fnm_payee_id varchar(9) null,
    if_interim_funder_mers_registration_type varchar(128) not null,
    if_fnm_warehouse_lender_id varchar(32) not null,
    if_fre_warehouse_lender_id varchar(32) not null,
    if_funder_id varchar(32) not null,
    constraint uk_interim_fuder_1
        unique (if_account_pid, if_company_name),
    constraint fk_interim_funder_1
        foreign key (if_account_pid) references account (a_pid),
    constraint fk_interim_funder_2
        foreign key (if_custodian_pid) references custodian (cu_pid),
    constraint fkt_if_company_address_country
        foreign key (if_company_address_country) references country_type (code),
    constraint fkt_if_interim_funder_mers_registration_type
        foreign key (if_interim_funder_mers_registration_type) references interim_funder_mers_registration_type (code)
);

create table credit_limit
(
    cl_pid bigint auto_increment
        primary key,
    cl_version int not null,
    cl_interim_funder_pid bigint not null,
    cl_credit_limit_name varchar(128) not null,
    cl_credit_limit_amount decimal(15,2) not null,
    cl_credit_limit_type varchar(128) not null,
    cl_from_date date not null,
    cl_through_date date null,
    constraint fk_credit_limit_1
        foreign key (cl_interim_funder_pid) references interim_funder (if_pid),
    constraint fkt_cl_credit_limit_type
        foreign key (cl_credit_limit_type) references credit_limit_type (code)
);

create table investor_group
(
    ig_pid bigint auto_increment
        primary key,
    ig_version int not null,
    ig_account_pid bigint not null,
    ig_name varchar(128) not null,
    ig_lender_group bit not null,
    constraint uk_investor_group_1
        unique (ig_account_pid, ig_name),
    constraint fk_investor_group_1
        foreign key (ig_account_pid) references account (a_pid)
);

create table investor_hmda_purchaser_of_loan_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table investor_lock_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table invoice_item_category_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table invoice_payer_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table invoice_payment_submission_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table ipc_calc_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table ipc_comparison_operator_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table ipc_property_usage_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table job_gap_reason_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table key_creditor_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table key_doc_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table key_package_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table key_role_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lava_zone_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table legacy_role_assignment_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table legal_description_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table legal_entity_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lender_concession_request_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lender_concession_request_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lender_lock_id_ticker
(
    lltk_pid bigint auto_increment
        primary key,
    lltk_version int not null,
    lltk_account_pid bigint not null,
    lltk_next_lender_lock_id bigint not null,
    constraint lltk_account_pid
        unique (lltk_account_pid),
    constraint fk_lender_lock_id_ticker_1
        foreign key (lltk_account_pid) references account (a_pid)
);

create table lender_lock_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lender_toolbox_permission_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lender_trade_id_ticker
(
    lttk_pid bigint auto_increment
        primary key,
    lttk_version int not null,
    lttk_account_pid bigint not null,
    lttk_next_lender_trade_id bigint not null,
    constraint lttk_account_pid
        unique (lttk_account_pid),
    constraint fk_lender_trade_id_ticker_1
        foreign key (lttk_account_pid) references account (a_pid)
);

create table lender_user_allowed_ip_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lender_user_interest
(
    lui_pid bigint auto_increment
        primary key,
    lui_version int not null,
    lui_lender_user_pid bigint not null,
    lui_lender_user_interest_type varchar(128) not null
);

create table lender_user_interest_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lender_user_language
(
    lul_pid bigint auto_increment
        primary key,
    lul_version int not null,
    lul_lender_user_pid bigint not null,
    lul_lender_user_language_type varchar(128) not null
);

create table lender_user_language_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lender_user_notice_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lender_user_reset_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lender_user_role_queue_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lender_user_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lender_user_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table liability_account_ownership_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table liability_account_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table liability_current_rating_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table liability_disposition_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table liability_energy_related_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table liability_financing_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table liability_foreclosure_exception_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table liability_mi_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table liability_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table license_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lien_priority_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table loan_access_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table loan_amortization_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table apor
(
    ap_pid bigint auto_increment
        primary key,
    ap_version int not null,
    ap_as_of_date date not null,
    ap_loan_amortization_type varchar(128) not null,
    ap_term_years int not null,
    ap_apor_percent decimal(11,9) not null,
    constraint fkt_ap_loan_amortization_type
        foreign key (ap_loan_amortization_type) references loan_amortization_type (code)
);

create index idx_apor_1
    on apor (ap_as_of_date);

create table loan_benef_transfer_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table loan_file_delivery_method_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table loan_limit_table_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table loan_limit_table
(
    llt_pid bigint auto_increment
        primary key,
    llt_version int not null,
    llt_account_pid bigint not null,
    llt_from_date date not null,
    llt_loan_limit_table_type varchar(128) not null,
    llt_uploader_unparsed_name varchar(128) not null,
    llt_upload_datetime datetime not null,
    constraint llt_uc_1
        unique (llt_account_pid, llt_from_date, llt_loan_limit_table_type),
    constraint fk_loan_limit_table_1
        foreign key (llt_account_pid) references account (a_pid),
    constraint fk_loan_limit_table_2
        foreign key (llt_loan_limit_table_type) references loan_limit_table_type (code)
);

create table loan_limit_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table loan_position_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table loan_purpose_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table loan_safe_product_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table loans_toolbox_permission_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lock_add_on_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lock_commitment_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lock_extension_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lock_term_setting
(
    lts_pid bigint auto_increment
        primary key,
    lts_version int not null,
    lts_account_pid bigint not null,
    lts_lock_duration_days int null,
    lts_lock_commitment_type varchar(128) not null,
    lts_borrower_app_enabled bit null,
    constraint uk_lock_term_setting_1
        unique (lts_account_pid, lts_lock_duration_days, lts_lock_commitment_type),
    constraint fk_lock_term_setting_1
        foreign key (lts_account_pid) references account (a_pid),
    constraint fkt_lts_lock_commitment_type
        foreign key (lts_lock_commitment_type) references lock_commitment_type (code)
);

create table los_loan_id_ticker
(
    ltk_pid bigint auto_increment
        primary key,
    ltk_version int not null,
    ltk_account_pid bigint not null,
    ltk_next_los_loan_id bigint not null,
    constraint ltk_account_pid
        unique (ltk_account_pid),
    constraint fk_los_loan_id_ticker_1
        foreign key (ltk_account_pid) references account (a_pid)
);

create table lp_case_state_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lp_credit_risk_classification_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lp_dtd_version_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lp_evaluation_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lp_finding_message_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lp_interface_version_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lp_request_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lp_submission_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lqa_purchase_eligibility_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lura_file_repository_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lura_setting_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table lura_setting
(
    ls_pid bigint auto_increment
        primary key,
    ls_version int not null,
    ls_lura_setting_type varchar(128) not null,
    ls_value varchar(256) not null,
    ls_from_date date not null,
    constraint ls_from_date
        unique (ls_from_date, ls_lura_setting_type),
    constraint fkt_ls_lura_setting_type
        foreign key (ls_lura_setting_type) references lura_setting_type (code)
);

create index idx_lura_setting_1
    on lura_setting (ls_lura_setting_type);

create table manufactured_home_certificate_of_title_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table manufactured_home_leasehold_property_interest_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table manufactured_home_loan_purpose_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table marital_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table master_property_insurance_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mcr_loan_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mercury_client_group
(
    mcg_pid bigint auto_increment
        primary key,
    mcg_version int not null,
    mcg_account_pid bigint not null,
    mcg_mercury_client_group_name varchar(1024) not null,
    mcg_mercury_client_group_id int not null,
    mcg_active bit not null,
    constraint uk_mercury_client_group_1
        unique (mcg_mercury_client_group_id, mcg_account_pid),
    constraint fk_mercury_client_group_1
        foreign key (mcg_account_pid) references account (a_pid)
);

create table mercury_network_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mers_daily_report_import_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mers_registration_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mers_transfer_batch
(
    metb_pid bigint auto_increment
        primary key,
    metb_version int not null,
    metb_account_pid bigint not null,
    metb_create_datetime datetime not null,
    metb_sent_datetime datetime null,
    metb_batch_id varchar(32) null,
    constraint metb_batch_id
        unique (metb_batch_id)
);

create table mers_transfer_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mi_calculated_rate_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mi_company_name_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mi_initial_calculation_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mi_input_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mi_integration_request_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mi_integration_vendor_request_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mi_payer_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mi_payment_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mi_premium_refundable_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mi_renewal_calculation_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mi_submission_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table military_branch_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table military_service_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table military_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mismo_version_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mortech_account
(
    ma_pid bigint auto_increment
        primary key,
    ma_version int not null,
    ma_account_pid bigint not null,
    ma_name varchar(128) not null,
    ma_mortech_customer_id varchar(128) not null,
    constraint uk_mortech_account_name_1
        unique (ma_account_pid, ma_name),
    constraint fk_mortech_account_1
        foreign key (ma_account_pid) references account (a_pid)
);

create table lead_source
(
    lds_pid bigint auto_increment
        primary key,
    lds_version int not null,
    lds_account_pid bigint not null,
    lds_channel_pid bigint not null,
    lds_lead_source_name varchar(128) not null,
    lds_mortech_lead_source_id varchar(16) not null,
    lds_lead_source_id varchar(32) null,
    lds_active bit null,
    lds_lead_id_required bit not null,
    lds_zero_margin_allowed bit not null,
    lds_mortech_account_pid bigint not null,
    lds_training_only bit not null,
    constraint lds_account_pid
        unique (lds_account_pid, lds_lead_source_id),
    constraint lds_account_pid_2
        unique (lds_account_pid, lds_lead_source_name),
    constraint uk_lead_source_1
        unique (lds_account_pid, lds_lead_source_id),
    constraint fk_lead_source_1
        foreign key (lds_account_pid) references account (a_pid),
    constraint fk_lead_source_2
        foreign key (lds_channel_pid) references channel (ch_pid),
    constraint fk_lead_source_3
        foreign key (lds_mortech_account_pid) references mortech_account (ma_pid)
);

create table lead_campaign
(
    ldc_pid bigint auto_increment
        primary key,
    ldc_version int not null,
    ldc_account_pid bigint not null,
    ldc_lead_source_pid bigint not null,
    ldc_campaign_id varchar(32) null,
    ldc_campaign_name varchar(128) null,
    ldc_velocify_campaign_title varchar(32) null,
    constraint ldc_account_pid
        unique (ldc_account_pid, ldc_velocify_campaign_title),
    constraint ldc_account_pid_2
        unique (ldc_account_pid, ldc_campaign_name),
    constraint ldc_account_pid_3
        unique (ldc_account_pid, ldc_campaign_id),
    constraint fk_lead_campaign_1
        foreign key (ldc_account_pid) references account (a_pid),
    constraint fk_lead_campaign_2
        foreign key (ldc_lead_source_pid) references lead_source (lds_pid)
);

create table lead_supplemental_margin_table
(
    lsmt_pid bigint auto_increment
        primary key,
    lsmt_version int not null,
    lsmt_lead_source_pid bigint not null,
    lsmt_effective_datetime datetime null,
    constraint fk_lead_supplemental_margin_table_1
        foreign key (lsmt_lead_source_pid) references lead_source (lds_pid)
);

create table lead_supplemental_margin_row
(
    lsmr_pid bigint auto_increment
        primary key,
    lsmr_version int not null,
    lsmr_lead_supplemental_margin_table_pid bigint not null,
    lsmr_over_anchor_rate_percent decimal(11,9) not null,
    lsmr_company_supplemental_margin_percent decimal(11,9) not null,
    lsmr_branch_supplemental_margin_percent decimal(11,9) not null,
    constraint fk_lead_supplemental_margin_row_1
        foreign key (lsmr_lead_supplemental_margin_table_pid) references lead_supplemental_margin_table (lsmt_pid)
);

create table mortgage_credit_certificate_issuer
(
    mcci_pid bigint auto_increment
        primary key,
    mcci_version int not null,
    mcci_account_pid bigint not null,
    mcci_from_date date not null,
    mcci_through_date date null,
    mcci_issuer_name varchar(128) not null,
    mcci_credit_rate_percent decimal(11,9) not null,
    mcci_ein varchar(10) not null,
    mcci_contact_name varchar(128) not null,
    mcci_contact_phone varchar(128) not null,
    mcci_address_street1 varchar(128) not null,
    mcci_address_street2 varchar(128) not null,
    mcci_address_city varchar(128) not null,
    mcci_address_state varchar(128) not null,
    mcci_address_postal_code varchar(128) not null,
    mcci_contact_email varchar(256) not null,
    mcci_web_url varchar(256) not null,
    mcci_notes varchar(1024) not null,
    constraint uk_mortgage_credit_certificate_issuer_1
        unique (mcci_account_pid, mcci_issuer_name),
    constraint fk_mortgage_credit_certificate_issuer_1
        foreign key (mcci_account_pid) references account (a_pid)
);

create table mortgage_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table native_american_lands_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table negative_amortization_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table neighborhood_location_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table net_tangible_benefit_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table nfip_community_participation_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table obligation_amount_input_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table obligation_charge_input_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table obligation_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table offering_group
(
    ofg_pid bigint auto_increment
        primary key,
    ofg_version int not null,
    ofg_account_pid bigint not null,
    ofg_name varchar(128) not null,
    constraint fk_offering_group_1
        foreign key (ofg_account_pid) references account (a_pid)
);

create table offering
(
    of_pid bigint auto_increment
        primary key,
    of_version int not null,
    of_account_pid bigint not null,
    of_offering_name varchar(128) null,
    of_offering_id varchar(32) null,
    of_from_date date not null,
    of_through_date date null,
    of_mortech_product_id varchar(16) not null,
    of_offering_group_pid bigint null,
    of_adverse_action_offering bit not null,
    constraint of_account_pid
        unique (of_account_pid, of_offering_id),
    constraint of_account_pid_2
        unique (of_account_pid, of_offering_name),
    constraint fk_offering_1
        foreign key (of_account_pid) references account (a_pid),
    constraint fk_offering_2
        foreign key (of_offering_group_pid) references offering_group (ofg_pid)
);

create table org_division
(
    orgd_pid bigint auto_increment
        primary key,
    orgd_version int not null,
    orgd_account_pid bigint not null,
    orgd_latest_level_name varchar(128) not null,
    orgd_active bit not null,
    constraint uk_org_division_1
        unique (orgd_latest_level_name),
    constraint fk_org_division_1
        foreign key (orgd_account_pid) references account (a_pid)
);

create table org_division_terms
(
    orgdt_pid bigint auto_increment
        primary key,
    orgdt_version int not null,
    orgdt_org_division_pid bigint not null,
    orgdt_from_date date not null,
    orgdt_through_date date null,
    orgdt_level_name varchar(128) not null,
    orgdt_level_cost_center_pid bigint not null,
    orgdt_beneficiary_cost_center_pid bigint null,
    orgdt_guarantor_cost_center_pid bigint null,
    constraint fk_org_division_terms_1
        foreign key (orgdt_org_division_pid) references org_division (orgd_pid),
    constraint fk_org_division_terms_2
        foreign key (orgdt_level_cost_center_pid) references cost_center (cosc_pid),
    constraint fk_org_division_terms_3
        foreign key (orgdt_beneficiary_cost_center_pid) references cost_center (cosc_pid),
    constraint fk_org_division_terms_4
        foreign key (orgdt_guarantor_cost_center_pid) references cost_center (cosc_pid)
);

create table org_group
(
    orgg_pid bigint auto_increment
        primary key,
    orgg_version int not null,
    orgg_account_pid bigint not null,
    orgg_latest_level_name varchar(128) not null,
    orgg_active bit not null,
    constraint uk_org_group_1
        unique (orgg_latest_level_name),
    constraint fk_org_group_1
        foreign key (orgg_account_pid) references account (a_pid)
);

create table org_group_terms
(
    orggt_pid bigint auto_increment
        primary key,
    orggt_version int not null,
    orggt_org_division_pid bigint not null,
    orggt_org_group_pid bigint not null,
    orggt_from_date date not null,
    orggt_through_date date null,
    orggt_level_name varchar(128) not null,
    orggt_level_cost_center_pid bigint not null,
    orggt_beneficiary_cost_center_pid bigint null,
    orggt_guarantor_cost_center_pid bigint null,
    constraint fk_org_group_terms_1
        foreign key (orggt_org_division_pid) references org_division (orgd_pid),
    constraint fk_org_group_terms_2
        foreign key (orggt_org_group_pid) references org_group (orgg_pid),
    constraint fk_org_group_terms_3
        foreign key (orggt_level_cost_center_pid) references cost_center (cosc_pid),
    constraint fk_org_group_terms_4
        foreign key (orggt_beneficiary_cost_center_pid) references cost_center (cosc_pid),
    constraint fk_org_group_terms_5
        foreign key (orggt_guarantor_cost_center_pid) references cost_center (cosc_pid)
);

create table org_leader_position_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table org_region
(
    orgr_pid bigint auto_increment
        primary key,
    orgr_version int not null,
    orgr_account_pid bigint not null,
    orgr_latest_level_name varchar(128) not null,
    orgr_active bit not null,
    constraint uk_org_region_1
        unique (orgr_latest_level_name),
    constraint fk_org_region_1
        foreign key (orgr_account_pid) references account (a_pid)
);

create table org_region_terms
(
    orgrt_pid bigint auto_increment
        primary key,
    orgrt_version int not null,
    orgrt_org_group_pid bigint not null,
    orgrt_org_region_pid bigint not null,
    orgrt_from_date date not null,
    orgrt_through_date date null,
    orgrt_level_name varchar(128) not null,
    orgrt_level_cost_center_pid bigint not null,
    orgrt_beneficiary_cost_center_pid bigint null,
    orgrt_guarantor_cost_center_pid bigint null,
    constraint fk_org_region_terms_1
        foreign key (orgrt_org_group_pid) references org_group (orgg_pid),
    constraint fk_org_region_terms_2
        foreign key (orgrt_org_region_pid) references org_region (orgr_pid),
    constraint fk_org_region_terms_3
        foreign key (orgrt_level_cost_center_pid) references cost_center (cosc_pid),
    constraint fk_org_region_terms_4
        foreign key (orgrt_beneficiary_cost_center_pid) references cost_center (cosc_pid),
    constraint fk_org_region_terms_5
        foreign key (orgrt_guarantor_cost_center_pid) references cost_center (cosc_pid)
);

create table org_team
(
    orgt_pid bigint auto_increment
        primary key,
    orgt_version int not null,
    orgt_account_pid bigint not null,
    orgt_latest_level_name varchar(128) not null,
    orgt_individual_pl_owner bit not null,
    orgt_admin_team bit not null,
    orgt_active bit not null,
    constraint fk_org_team_1
        foreign key (orgt_account_pid) references account (a_pid)
);

create table org_unit
(
    orgu_pid bigint auto_increment
        primary key,
    orgu_version int not null,
    orgu_account_pid bigint not null,
    orgu_latest_level_name varchar(128) not null,
    orgu_active bit not null,
    constraint uk_org_unit_1
        unique (orgu_latest_level_name),
    constraint fk_org_unit_1
        foreign key (orgu_account_pid) references account (a_pid)
);

create table org_team_terms
(
    orgtt_pid bigint auto_increment
        primary key,
    orgtt_version int not null,
    orgtt_org_unit_pid bigint not null,
    orgtt_org_team_pid bigint not null,
    orgtt_from_date date not null,
    orgtt_through_date date null,
    orgtt_level_name varchar(128) not null,
    orgtt_level_cost_center_pid bigint not null,
    orgtt_beneficiary_cost_center_pid bigint null,
    orgtt_guarantor_cost_center_pid bigint null,
    constraint fk_org_team_terms_1
        foreign key (orgtt_org_unit_pid) references org_unit (orgu_pid),
    constraint fk_org_team_terms_2
        foreign key (orgtt_org_team_pid) references org_team (orgt_pid),
    constraint fk_org_team_terms_3
        foreign key (orgtt_level_cost_center_pid) references cost_center (cosc_pid),
    constraint fk_org_team_terms_4
        foreign key (orgtt_beneficiary_cost_center_pid) references cost_center (cosc_pid),
    constraint fk_org_team_terms_5
        foreign key (orgtt_guarantor_cost_center_pid) references cost_center (cosc_pid)
);

create table org_unit_terms
(
    orgut_pid bigint auto_increment
        primary key,
    orgut_version int not null,
    orgut_org_region_pid bigint not null,
    orgut_org_unit_pid bigint not null,
    orgut_from_date date not null,
    orgut_through_date date null,
    orgut_level_name varchar(128) not null,
    orgut_level_cost_center_pid bigint not null,
    orgut_beneficiary_cost_center_pid bigint null,
    orgut_guarantor_cost_center_pid bigint null,
    constraint fk_org_unit_terms_1
        foreign key (orgut_org_region_pid) references org_region (orgr_pid),
    constraint fk_org_unit_terms_2
        foreign key (orgut_org_unit_pid) references org_unit (orgu_pid),
    constraint fk_org_unit_terms_3
        foreign key (orgut_level_cost_center_pid) references cost_center (cosc_pid),
    constraint fk_org_unit_terms_4
        foreign key (orgut_beneficiary_cost_center_pid) references cost_center (cosc_pid),
    constraint fk_org_unit_terms_5
        foreign key (orgut_guarantor_cost_center_pid) references cost_center (cosc_pid)
);

create table origination_source_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table other_income_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table partial_payment_policy_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table payment_adjustment_calculation_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table payment_frequency_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table payment_fulfill_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table payment_processing_company_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table payment_request_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table payment_structure_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table payment_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table payoff_request_delivery_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table performer_team
(
    ptm_pid bigint auto_increment
        primary key,
    ptm_version int not null,
    ptm_account_pid bigint not null,
    ptm_name varchar(128) not null,
    constraint ptm_account_pid
        unique (ptm_account_pid, ptm_name),
    constraint fk_performer_team_1
        foreign key (ptm_account_pid) references account (a_pid)
);

create table polling_interval_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table prepaid_interest_rate_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table prepay_penalty_schedule_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table prepay_penalty_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table price_processing_time
(
    ppt_pid bigint auto_increment
        primary key,
    ppt_version int not null,
    ppt_account_pid bigint not null,
    ppt_los_loan_id_main bigint null,
    ppt_start_time datetime not null,
    ppt_start_date date not null,
    ppt_overall_duration_ms bigint not null,
    ppt_pre_mortech_time_ms bigint not null,
    ppt_post_mortech_time_ms bigint not null,
    ppt_num_of_mortech_requests int null,
    ppt_mortech_request_url_1 text not null,
    ppt_mortech_request_start_time_1 datetime null,
    ppt_mortech_request_time_ms_1 bigint not null,
    ppt_mortech_request_url_2 text not null,
    ppt_mortech_request_start_time_2 datetime null,
    ppt_mortech_request_time_ms_2 bigint not null,
    ppt_mortech_request_url_3 text not null,
    ppt_mortech_request_start_time_3 datetime null,
    ppt_mortech_request_time_ms_3 bigint not null,
    ppt_mortech_request_url_4 text not null,
    ppt_mortech_request_start_time_4 datetime null,
    ppt_mortech_request_time_ms_4 bigint not null,
    ppt_mortech_request_url_5 text not null,
    ppt_mortech_request_start_time_5 datetime null,
    ppt_mortech_request_time_ms_5 bigint not null,
    ppt_mortech_request_url_6 text not null,
    ppt_mortech_request_start_time_6 datetime null,
    ppt_mortech_request_time_ms_6 bigint not null,
    ppt_mortech_request_url_7 text not null,
    ppt_mortech_request_start_time_7 datetime null,
    ppt_mortech_request_time_ms_7 bigint not null,
    ppt_mortech_request_url_8 text not null,
    ppt_mortech_request_start_time_8 datetime null,
    ppt_mortech_request_time_ms_8 bigint not null,
    constraint fk_price_processing_time_1
        foreign key (ppt_account_pid) references account (a_pid)
);

create index idx_price_processing_time_1
    on price_processing_time (ppt_start_time);

create index idx_price_processing_time_2
    on price_processing_time (ppt_start_date);

create table pricing_engine_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table prior_property_title_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table prior_to_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table product_appraisal_requirement_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table product_rule_domain_input_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table product_side_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table product_special_program_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table profit_margin_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table project_classification_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table project_design_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table property_category_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table property_repairs_holdback_calc_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table property_repairs_holdback_payer_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table property_repairs_required_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table property_rights_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table property_usage_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table proposal_doc_file_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table proposal_review_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table proposal_structure_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table proposal_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table pte_request_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table pte_response_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table public_record_disposition_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table public_record_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table qualified_mortgage_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table qualified_mortgage_thresholds
(
    qmt_pid bigint auto_increment
        primary key,
    qmt_version int not null,
    qmt_effective_date date not null,
    qmt_first_total_loan_amount_threshold decimal(15) not null,
    qmt_first_points_and_fees_threshold_percent decimal(11,9) not null,
    qmt_second_total_loan_amount_threshold decimal(15) not null,
    qmt_second_points_and_fees_threshold_amount decimal(15) not null,
    qmt_third_total_loan_amount_threshold decimal(15) not null,
    qmt_third_points_and_fees_threshold_percent decimal(11,9) not null,
    qmt_fourth_total_loan_amount_threshold decimal(15) not null,
    qmt_fourth_points_and_fees_threshold_amount decimal(15) not null,
    qmt_ceiling_points_and_fees_threshold_percent decimal(11,9) not null,
    constraint uc_qmt_effective_date
        unique (qmt_effective_date)
);

create table qualifying_monthly_payment_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table qualifying_rate_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table quarter_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table mcr_snapshot
(
    mcrs_pid bigint auto_increment
        primary key,
    mcrs_version int not null,
    mcrs_account_pid bigint not null,
    mcrs_year int not null,
    mcrs_quarter_type varchar(128) not null,
    constraint fk_mcr_snapshot_1
        foreign key (mcrs_account_pid) references account (a_pid),
    constraint fkt_mcrs_quarter_type
        foreign key (mcrs_quarter_type) references quarter_type (code)
);

create table mcr_loan
(
    mcrl_pid bigint auto_increment
        primary key,
    mcrl_version int not null,
    mcrl_loan_pid bigint null,
    mcrl_mcr_snapshot_pid bigint not null,
    mcrl_los_loan_id bigint not null,
    mcrl_originator_nmls_id varchar(16) not null,
    mcrl_loan_amount decimal(15,2) not null,
    mcrl_lien_priority_type varchar(128) not null,
    mcrl_mortgage_type varchar(128) not null,
    mcrl_interest_only_type varchar(128) not null,
    mcrl_prepay_penalty_schedule_type varchar(128) not null,
    mcrl_ltv_ratio_percent decimal(11,9) not null,
    mcrl_note_rate_percent decimal(11,9) not null,
    mcrl_hmda_action_type varchar(128) not null,
    mcrl_hmda_action_date date null,
    mcrl_disclosure_mode_date date null,
    mcrl_decision_credit_score int not null,
    mcrl_property_usage_type varchar(128) not null,
    mcrl_doc_level_type varchar(128) not null,
    mcrl_loan_purpose_type varchar(128) not null,
    mcrl_mi_required bit not null,
    mcrl_proposal_structure_type varchar(128) not null,
    mcrl_subject_property_state varchar(128) not null,
    mcrl_property_category_type varchar(128) not null,
    mcrl_cltv_ratio_percent decimal(11,9) not null,
    mcrl_funding_status_type varchar(128) null,
    mcrl_funding_date date null,
    mcrl_loan_amortization_type varchar(128) null,
    mcrl_product_special_program_type varchar(128) null,
    mcrl_non_conforming bit not null,
    mcrl_initial_payment_adjustment_term_months int not null,
    mcrl_subsequent_payment_adjustment_term_months int not null,
    mcrl_fund_source_type varchar(128) null,
    mcrl_channel_type varchar(128) null,
    mcrl_financed_units_count int not null,
    mcrl_cash_out_reason_home_improvement bit not null,
    mcrl_hmda_hoepa_status_type varchar(128) not null,
    mcrl_qualified_mortgage_status_type varchar(128) not null,
    mcrl_lender_fee_total_amount decimal(15,2) not null,
    mcrl_broker_fee_total_amount decimal(15,2) not null,
    mcrl_investor_hmda_purchaser_of_loan_type varchar(128) null,
    mcrl_confirmed_release_datetime datetime null,
    mcrl_purchase_advice_date date null,
    mcrl_purchasing_beneficiary_investor_pid bigint null,
    mcrl_mcr_loan_status_type varchar(128) not null,
    constraint fk_mcr_loan_1
        foreign key (mcrl_mcr_snapshot_pid) references mcr_snapshot (mcrs_pid),
    constraint fkt_mcrl_channel_type
        foreign key (mcrl_channel_type) references channel_type (code),
    constraint fkt_mcrl_doc_level_type
        foreign key (mcrl_doc_level_type) references doc_level_type (code),
    constraint fkt_mcrl_fund_source_type
        foreign key (mcrl_fund_source_type) references fund_source_type (code),
    constraint fkt_mcrl_funding_status_type
        foreign key (mcrl_funding_status_type) references funding_status_type (code),
    constraint fkt_mcrl_hmda_action_type
        foreign key (mcrl_hmda_action_type) references hmda_action_type (code),
    constraint fkt_mcrl_hmda_hoepa_status_type
        foreign key (mcrl_hmda_hoepa_status_type) references hmda_hoepa_status_type (code),
    constraint fkt_mcrl_interest_only_type
        foreign key (mcrl_interest_only_type) references interest_only_type (code),
    constraint fkt_mcrl_investor_hmda_purchaser_of_loan_type
        foreign key (mcrl_investor_hmda_purchaser_of_loan_type) references investor_hmda_purchaser_of_loan_type (code),
    constraint fkt_mcrl_lien_priority_type
        foreign key (mcrl_lien_priority_type) references lien_priority_type (code),
    constraint fkt_mcrl_loan_amortization_type
        foreign key (mcrl_loan_amortization_type) references loan_amortization_type (code),
    constraint fkt_mcrl_loan_purpose_type
        foreign key (mcrl_loan_purpose_type) references loan_purpose_type (code),
    constraint fkt_mcrl_mcr_loan_status_type
        foreign key (mcrl_mcr_loan_status_type) references mcr_loan_status_type (code),
    constraint fkt_mcrl_mortgage_type
        foreign key (mcrl_mortgage_type) references mortgage_type (code),
    constraint fkt_mcrl_prepay_penalty_schedule_type
        foreign key (mcrl_prepay_penalty_schedule_type) references prepay_penalty_schedule_type (code),
    constraint fkt_mcrl_product_special_program_type
        foreign key (mcrl_product_special_program_type) references product_special_program_type (code),
    constraint fkt_mcrl_property_category_type
        foreign key (mcrl_property_category_type) references property_category_type (code),
    constraint fkt_mcrl_property_usage_type
        foreign key (mcrl_property_usage_type) references property_usage_type (code),
    constraint fkt_mcrl_proposal_structure_type
        foreign key (mcrl_proposal_structure_type) references proposal_structure_type (code),
    constraint fkt_mcrl_qualified_mortgage_status_type
        foreign key (mcrl_qualified_mortgage_status_type) references qualified_mortgage_status_type (code)
);

create table quote_filter_pivot_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table realty_agent_scenario_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table recording_district_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table refinance_improvements_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table relock_fee_setting
(
    rfs_pid bigint auto_increment
        primary key,
    rfs_version int not null,
    rfs_account_pid bigint not null,
    rfs_from_date date null,
    rfs_relock_fee_percent decimal(11,9) not null,
    constraint uk_relock_fee_setting_1
        unique (rfs_account_pid, rfs_from_date),
    constraint fk_relock_fee_setting_1
        foreign key (rfs_account_pid) references account (a_pid)
);

create table reo_disposition_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table report_request_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table report_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table report
(
    rp_pid bigint auto_increment
        primary key,
    rp_version int not null,
    rp_account_pid bigint not null,
    rp_name varchar(128) not null,
    rp_description varchar(1024) null,
    rp_report_type varchar(128) not null,
    rp_report_row_pid bigint not null,
    rp_criteria_pid bigint null,
    rp_accessible_only bit null,
    rp_analysis_report bit null,
    rp_publish bit null,
    rp_test_data_report bit not null,
    rp_allow_view bit not null,
    rp_allow_excel_export bit not null,
    constraint fk_report_1
        foreign key (rp_account_pid) references account (a_pid),
    constraint fk_report_3
        foreign key (rp_criteria_pid) references criteria (cr_pid),
    constraint fkt_rp_report_type
        foreign key (rp_report_type) references report_type (code)
);

create table report_row
(
    rprw_pid bigint auto_increment
        primary key,
    rprw_version int not null,
    rprw_account_pid bigint not null,
    rprw_report_type varchar(128) not null,
    rprw_name varchar(128) not null,
    rprw_description varchar(1024) null,
    rprw_formula_row bit null,
    constraint fk_report_row_1
        foreign key (rprw_account_pid) references account (a_pid),
    constraint fkt_rprw_report_type
        foreign key (rprw_report_type) references report_type (code)
);

create table formula_report_column
(
    frc_pid bigint auto_increment
        primary key,
    frc_version int not null,
    frc_report_row_pid bigint not null,
    frc_header varchar(128) null,
    frc_formula varchar(1024) null,
    frc_field_type_1 varchar(128) null,
    frc_field_type_2 varchar(128) null,
    frc_field_type_3 varchar(128) null,
    frc_field_type_4 varchar(128) null,
    frc_field_type_5 varchar(128) null,
    frc_field_type_6 varchar(128) null,
    frc_ordinal int null,
    constraint fk_formula_report_column_1
        foreign key (frc_report_row_pid) references report_row (rprw_pid),
    constraint fkt_frc_field_type_1
        foreign key (frc_field_type_1) references field_type (code),
    constraint fkt_frc_field_type_2
        foreign key (frc_field_type_2) references field_type (code),
    constraint fkt_frc_field_type_3
        foreign key (frc_field_type_3) references field_type (code),
    constraint fkt_frc_field_type_4
        foreign key (frc_field_type_4) references field_type (code),
    constraint fkt_frc_field_type_5
        foreign key (frc_field_type_5) references field_type (code),
    constraint fkt_frc_field_type_6
        foreign key (frc_field_type_6) references field_type (code)
);

create table report_column
(
    rpc_pid bigint auto_increment
        primary key,
    rpc_version int not null,
    rpc_report_row_pid bigint not null,
    rpc_report_column_type varchar(128) not null,
    rpc_ordinal int null,
    constraint fk_report_column_1
        foreign key (rpc_report_row_pid) references report_row (rprw_pid),
    constraint fkt_rpc_report_column_type
        foreign key (rpc_report_column_type) references field_type (code)
);

create table req_decision_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table req_fulfill_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table rescission_notification_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table respa_section_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table charge_type
(
    code varchar(128) not null
        primary key,
    ct_respa_section_type varchar(128) not null,
    value varchar(1024) not null,
    constraint fkt_ct_respa_section_type
        foreign key (ct_respa_section_type) references respa_section_type (code)
);

create table road_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table role
(
    r_pid bigint auto_increment
        primary key,
    r_version int not null,
    r_account_pid bigint not null,
    r_role_name varchar(32) null,
    r_borrower_viewable bit null,
    r_loan_access_type varchar(128) not null,
    r_internal bit not null,
    r_training_applicable bit not null,
    constraint uk_role_1
        unique (r_account_pid, r_role_name),
    constraint fk_role_1
        foreign key (r_account_pid) references account (a_pid),
    constraint fkt_r_loan_access_type
        foreign key (r_loan_access_type) references loan_access_type (code)
);

create table key_role
(
    kr_pid bigint auto_increment
        primary key,
    kr_version int not null,
    kr_role_pid bigint not null,
    kr_account_pid bigint not null,
    kr_key_role_type varchar(128) not null,
    constraint uk_key_role_1
        unique (kr_account_pid, kr_key_role_type),
    constraint fk_key_role_1
        foreign key (kr_role_pid) references role (r_pid),
    constraint fk_key_role_2
        foreign key (kr_account_pid) references account (a_pid),
    constraint fkt_kr_key_role_type
        foreign key (kr_key_role_type) references key_role_type (code)
);

create table role_charge_permissions
(
    rcp_pid bigint auto_increment
        primary key,
    rcp_version int not null,
    rcp_role_pid bigint not null,
    rcp_charge_type varchar(128) not null,
    rcp_basic_editable bit not null,
    rcp_financed_editable bit not null,
    rcp_payer_non_lender_editable bit not null,
    rcp_payer_lender_editable bit not null,
    rcp_payee_editable bit not null,
    rcp_apr_editable bit not null,
    rcp_poc_editable bit not null,
    rcp_wire_editable bit not null,
    constraint uk_role_charge_permissions_1
        unique (rcp_role_pid, rcp_charge_type),
    constraint fk_role_charge_permissions_1
        foreign key (rcp_role_pid) references role (r_pid),
    constraint fkt_rcp_charge_type
        foreign key (rcp_charge_type) references charge_type (code)
);

create table role_config_export_permission
(
    rcep_pid bigint auto_increment
        primary key,
    rcep_version int not null,
    rcep_role_pid bigint not null,
    rcep_config_export_permission_type varchar(128) not null,
    constraint uk_role_config_export_permission_1
        unique (rcep_role_pid, rcep_config_export_permission_type),
    constraint fk_role_config_export_permission_1
        foreign key (rcep_role_pid) references role (r_pid),
    constraint fkt_rcep_export_permission_type
        foreign key (rcep_config_export_permission_type) references config_export_permission_type (code)
);

create table role_deal_context
(
    rdc_pid bigint auto_increment
        primary key,
    rdc_version int not null,
    rdc_role_pid bigint not null,
    rdc_deal_context_permission_type varchar(128) not null,
    constraint uk_role_deal_context_1
        unique (rdc_role_pid, rdc_deal_context_permission_type),
    constraint fk_role_deal_context_1
        foreign key (rdc_role_pid) references role (r_pid),
    constraint fkt_rdc_deal_context_permission_type
        foreign key (rdc_deal_context_permission_type) references deal_context_permission_type (code)
);

create table role_export_permission
(
    rep_pid bigint auto_increment
        primary key,
    rep_version int not null,
    rep_role_pid bigint not null,
    rep_export_permission_type varchar(128) not null,
    constraint uk_role_export_permission_1
        unique (rep_role_pid, rep_export_permission_type),
    constraint fk_role_export_permission_1
        foreign key (rep_role_pid) references role (r_pid),
    constraint fkt_rep_export_permission_type
        foreign key (rep_export_permission_type) references export_permission_type (code)
);

create table role_lender_toolbox
(
    rlet_pid bigint auto_increment
        primary key,
    rlet_version int not null,
    rlet_role_pid bigint not null,
    rlet_lender_toolbox_permission_type varchar(128) not null,
    constraint uk_role_lender_toolbox_1
        unique (rlet_role_pid, rlet_lender_toolbox_permission_type),
    constraint fk_role_lender_toolbox_1
        foreign key (rlet_role_pid) references role (r_pid),
    constraint fkt_rlet_lender_toolbox_permission_type
        foreign key (rlet_lender_toolbox_permission_type) references lender_toolbox_permission_type (code)
);

create table role_loans_toolbox
(
    rlot_pid bigint auto_increment
        primary key,
    rlot_version int not null,
    rlot_role_pid bigint not null,
    rlot_loans_toolbox_permission_type varchar(128) not null,
    constraint uk_role_loans_toolbox1
        unique (rlot_role_pid, rlot_loans_toolbox_permission_type),
    constraint fk_role_loans_toolbox_1
        foreign key (rlot_role_pid) references role (r_pid),
    constraint fkt_rlot_loans_toolbox_permission_type
        foreign key (rlot_loans_toolbox_permission_type) references loans_toolbox_permission_type (code)
);

create table role_performer_assign
(
    rpa_pid bigint auto_increment
        primary key,
    rpa_version int not null,
    rpa_role_pid bigint not null,
    rpa_assignee_role_pid bigint not null,
    constraint uk_role_performer_assign_1
        unique (rpa_role_pid, rpa_assignee_role_pid),
    constraint fk_role_performer_assign_1
        foreign key (rpa_role_pid) references role (r_pid),
    constraint fk_role_performer_assign_2
        foreign key (rpa_assignee_role_pid) references role (r_pid)
);

create table role_report
(
    rrp_pid bigint auto_increment
        primary key,
    rrp_version int not null,
    rrp_report_pid bigint not null,
    rrp_role_pid bigint not null,
    constraint fk_role_report_1
        foreign key (rrp_report_pid) references report (rp_pid),
    constraint fk_role_report_2
        foreign key (rrp_role_pid) references role (r_pid)
);

create table sanitation_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table sap_step_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table schema_version
(
    installed_rank int not null
        primary key,
    version varchar(50) null,
    description varchar(200) not null,
    type varchar(20) not null,
    script varchar(1000) not null,
    checksum int null,
    installed_by varchar(100) not null,
    installed_on timestamp default CURRENT_TIMESTAMP not null,
    execution_time int not null,
    success tinyint(1) not null
);

create index schema_version_s_idx
    on schema_version (success);

create table schema_version_post_data
(
    installed_rank int not null
        primary key,
    version varchar(50) null,
    description varchar(200) not null,
    type varchar(20) not null,
    script varchar(1000) not null,
    checksum int null,
    installed_by varchar(100) not null,
    installed_on timestamp default CURRENT_TIMESTAMP not null,
    execution_time int not null,
    success tinyint(1) not null
);

create index schema_version_post_data_s_idx
    on schema_version_post_data (success);

create table schema_version_pre_data
(
    installed_rank int not null
        primary key,
    version varchar(50) null,
    description varchar(200) not null,
    type varchar(20) not null,
    script varchar(1000) not null,
    checksum int null,
    installed_by varchar(100) not null,
    installed_on timestamp default CURRENT_TIMESTAMP not null,
    execution_time int not null,
    success tinyint(1) not null
);

create index schema_version_pre_data_s_idx
    on schema_version_pre_data (success);

create table secondary_admin_event_entity_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table secondary_admin_event
(
    sae_pid bigint auto_increment
        primary key,
    sae_version int not null,
    sae_account_pid bigint null,
    sae_secondary_admin_event_entity_type varchar(128) not null,
    sae_message varchar(256) not null,
    sae_diff_list text null,
    sae_unparsed_name varchar(128) not null,
    sae_event_date date not null,
    sae_event_datetime datetime not null,
    sae_target_entity_pid bigint null,
    constraint fk_secondary_admin_event_1
        foreign key (sae_account_pid) references account (a_pid),
    constraint fk_secondary_admin_event_2
        foreign key (sae_secondary_admin_event_entity_type) references secondary_admin_event_entity_type (code)
);

create index idx_secondary_admin_event_1
    on secondary_admin_event (sae_event_date);

create table section_of_act_coarse_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table security_instrument_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table senior_lien_restriction_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table servicer_loan_id_assign_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table servicer_loan_id_import_request_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table servicing_transfer_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table settlement_agent
(
    sa_pid bigint auto_increment
        primary key,
    sa_version int not null,
    sa_account_pid bigint not null,
    sa_active bit null,
    sa_admin_lock bit null,
    sa_license_id varchar(128) null,
    sa_company_name varchar(128) null,
    sa_preferred_vendor bit null,
    constraint uk_settlement_agent_1
        unique (sa_account_pid, sa_company_name),
    constraint fk_settlement_agent_1
        foreign key (sa_account_pid) references account (a_pid)
);

create table settlement_agent_office
(
    sao_pid bigint auto_increment
        primary key,
    sao_version int not null,
    sao_settlement_agent_pid bigint not null,
    sao_active bit null,
    sao_address_street1 varchar(128) not null,
    sao_address_street2 varchar(128) not null,
    sao_address_city varchar(128) not null,
    sao_address_state varchar(128) not null,
    sao_address_postal_code varchar(128) not null,
    sao_address_country varchar(128) not null,
    sao_phone varchar(32) null,
    sao_fax varchar(32) null,
    sao_docs_email varchar(256) null,
    sao_fund_email varchar(256) null,
    sao_schedule_email varchar(256) null,
    constraint fk_settlement_agent_office_1
        foreign key (sao_settlement_agent_pid) references settlement_agent (sa_pid),
    constraint fkt_sao_address_country
        foreign key (sao_address_country) references country_type (code)
);

create table settlement_agent_wire
(
    saw_pid bigint auto_increment
        primary key,
    saw_version int not null,
    saw_settlement_agent_pid bigint not null,
    saw_active bit null,
    saw_create_datetime datetime not null,
    saw_bank_aba varchar(16) null,
    saw_bank_account_number varchar(128) null,
    saw_bank_name varchar(128) null,
    saw_address_street1 varchar(128) not null,
    saw_address_street2 varchar(128) not null,
    saw_address_city varchar(128) not null,
    saw_address_state varchar(128) not null,
    saw_address_postal_code varchar(128) not null,
    saw_address_country varchar(128) not null,
    saw_for_credit_to varchar(256) null,
    saw_for_further_credit_fixed_text varchar(256) null,
    saw_for_further_credit_prompt_text varchar(256) null,
    saw_verified_from_date date null,
    saw_verified_through_date date null,
    saw_verifier varchar(128) null,
    saw_notes varchar(1024) null,
    saw_for_further_credit_type varchar(128) not null,
    saw_beneficiary_bank_aba varchar(16) not null,
    saw_beneficiary_bank_account_number varchar(128) not null,
    saw_beneficiary_bank_name varchar(128) not null,
    saw_beneficiary_address_street1 varchar(128) not null,
    saw_beneficiary_address_street2 varchar(128) not null,
    saw_beneficiary_address_city varchar(128) not null,
    saw_beneficiary_address_state varchar(128) not null,
    saw_beneficiary_address_postal_code varchar(128) not null,
    saw_beneficiary_address_country varchar(128) not null,
    saw_beneficiary_for_credit_to varchar(256) not null,
    saw_beneficiary_for_further_credit_fixed_text varchar(256) not null,
    saw_beneficiary_for_further_credit_prompt_text varchar(256) not null,
    saw_beneficiary_for_further_credit_type varchar(128) not null,
    saw_beneficiary_notes varchar(1024) not null,
    constraint fk_settlement_agent_wire_1
        foreign key (saw_settlement_agent_pid) references settlement_agent (sa_pid),
    constraint fkt_saw_address_country
        foreign key (saw_address_country) references country_type (code),
    constraint fkt_saw_beneficiary_for_further_credit_type
        foreign key (saw_beneficiary_for_further_credit_type) references for_further_credit_type (code),
    constraint fkt_saw_for_further_credit_type
        foreign key (saw_for_further_credit_type) references for_further_credit_type (code)
);

create table sheet_format_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table google_sheet_export
(
    gse_pid bigint auto_increment
        primary key,
    gse_version int not null,
    gse_name varchar(128) not null,
    gse_account_pid bigint not null,
    gse_export_type varchar(128) not null,
    gse_stored_query_name varchar(128) not null,
    gse_spreadsheet_id varchar(128) not null,
    gse_control_sheet_id varchar(128) not null,
    gse_results_sheet_id varchar(128) not null,
    gse_cron_expression varchar(32) not null,
    gse_format_type varchar(128) not null,
    constraint uk_name_1
        unique (gse_account_pid, gse_name),
    constraint fk_google_sheet_export_1
        foreign key (gse_account_pid) references account (a_pid),
    constraint fkt_gse_export_type
        foreign key (gse_export_type) references export_type (code),
    constraint fkt_gse_format_type
        foreign key (gse_format_type) references sheet_format_type (code)
);

create table signature_part_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table site_allowed_ip
(
    saip_pid bigint auto_increment
        primary key,
    saip_version int not null,
    saip_account_pid bigint not null,
    saip_name varchar(128) not null,
    saip_ip_address varchar(32) not null,
    constraint saip_account_pid
        unique (saip_account_pid, saip_name, saip_ip_address),
    constraint fk_site_allowed_ip_1
        foreign key (saip_account_pid) references account (a_pid)
);

create index idx_site_allowed_ip_1
    on site_allowed_ip (saip_ip_address);

create table smart_charge_apr_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table smart_charge
(
    sc_pid bigint auto_increment
        primary key,
    sc_version int not null,
    sc_account_pid bigint not null,
    sc_charge_type varchar(128) not null,
    sc_loan_position_type varchar(128) not null,
    sc_name varchar(128) null,
    sc_smart_charge_apr_type varchar(128) not null,
    sc_apr_criteria_pid bigint null,
    constraint sc_account_pid
        unique (sc_account_pid, sc_charge_type, sc_loan_position_type),
    constraint sc_apr_criteria_pid
        unique (sc_apr_criteria_pid),
    constraint fk_smart_charge_1
        foreign key (sc_account_pid) references account (a_pid),
    constraint fk_smart_charge_2
        foreign key (sc_apr_criteria_pid) references criteria (cr_pid),
    constraint fkt_sc_charge_type
        foreign key (sc_charge_type) references charge_type (code),
    constraint fkt_sc_loan_position_type
        foreign key (sc_loan_position_type) references loan_position_type (code),
    constraint fkt_sc_smart_charge_apr_type
        foreign key (sc_smart_charge_apr_type) references smart_charge_apr_type (code)
);

create table smart_charge_group
(
    scg_pid bigint auto_increment
        primary key,
    scg_version int not null,
    scg_smart_charge_pid bigint not null,
    scg_group_name varchar(128) null,
    constraint uk_smart_charge_group_1
        unique (scg_smart_charge_pid, scg_group_name),
    constraint fk_smart_charge_group_1
        foreign key (scg_smart_charge_pid) references smart_charge (sc_pid)
);

create table smart_charge_group_case
(
    scgc_pid bigint auto_increment
        primary key,
    scgc_version int not null,
    scgc_smart_charge_group_pid bigint not null,
    scgc_from_date date not null,
    scgc_through_date date null,
    constraint fk_smart_charge_group_case_1
        foreign key (scgc_smart_charge_group_pid) references smart_charge_group (scg_pid)
);

create table smart_charge_case
(
    scc_pid bigint auto_increment
        primary key,
    scc_version int not null,
    scc_smart_charge_group_case_pid bigint not null,
    scc_case_name varchar(128) null,
    scc_ordinal int null,
    scc_criteria_pid bigint null,
    scc_amount_description varchar(256) null,
    scc_charge_payer_type varchar(128) not null,
    scc_charge_payee_type varchar(128) not null,
    scc_paid_by varchar(128) null,
    scc_paid_to varchar(128) null,
    scc_base_amount decimal(16,3) not null,
    scc_charge_input_type varchar(128) not null,
    scc_charge_input_type_percent decimal(11,9) not null,
    scc_charge_input_type_currency decimal(16,3) not null,
    scc_financed bit null,
    scc_financed_auto_compute bit null,
    scc_poc bit null,
    scc_reduction_amount decimal(15) not null,
    scc_subtract_lenders_title_insurance_amount bit not null,
    constraint scc_criteria_pid
        unique (scc_criteria_pid),
    constraint fk_smart_charge_case_1
        foreign key (scc_smart_charge_group_case_pid) references smart_charge_group_case (scgc_pid),
    constraint fk_smart_charge_case_2
        foreign key (scc_criteria_pid) references criteria (cr_pid),
    constraint fkt_scc_charge_input_type
        foreign key (scc_charge_input_type) references charge_input_type (code),
    constraint fkt_scc_charge_payee_type
        foreign key (scc_charge_payee_type) references charge_payee_type (code),
    constraint fkt_scc_charge_payer_type
        foreign key (scc_charge_payer_type) references charge_payer_type (code)
);

create table smart_message_delivery_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table smart_message_email_recipient_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table smart_message_recipient_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table smart_message_source_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table smart_mi
(
    sm_pid bigint auto_increment
        primary key,
    sm_version int not null,
    sm_account_pid bigint not null,
    sm_mi_company_name_type varchar(128) not null,
    constraint sm_account_pid
        unique (sm_account_pid, sm_mi_company_name_type),
    constraint fk_smart_mi_1
        foreign key (sm_account_pid) references account (a_pid),
    constraint fkt_sm_mi_company_name_type
        foreign key (sm_mi_company_name_type) references mi_company_name_type (code)
);

create table smart_mi_eligibility_case
(
    smec_pid bigint auto_increment
        primary key,
    smec_version int not null,
    smec_smart_mi_pid bigint not null,
    smec_criteria_pid bigint null,
    smec_from_date date not null,
    smec_through_date date null,
    constraint fk_smart_mi_eligibility_case_1
        foreign key (smec_smart_mi_pid) references smart_mi (sm_pid),
    constraint fk_smart_mi_eligibility_case_2
        foreign key (smec_criteria_pid) references criteria (cr_pid)
);

create table smart_mi_rate_card
(
    smrca_pid bigint auto_increment
        primary key,
    smrca_version int not null,
    smrca_from_date date null,
    smrca_mi_payment_type varchar(128) not null,
    smrca_mi_payer_type varchar(128) not null,
    smrca_minimum_rate_percent decimal(11,9) not null,
    smrca_smart_mi_pid bigint not null,
    smrca_maximum_renewal_rate_percent decimal(11,9) not null,
    constraint smrca_smart_mi_pid
        unique (smrca_smart_mi_pid, smrca_from_date, smrca_mi_payment_type, smrca_mi_payer_type),
    constraint fk_smart_mi_rate_card_1
        foreign key (smrca_smart_mi_pid) references smart_mi (sm_pid),
    constraint fkt_smrca_mi_payer_type
        foreign key (smrca_mi_payer_type) references mi_payer_type (code),
    constraint fkt_smrca_mi_payment_type
        foreign key (smrca_mi_payment_type) references mi_payment_type (code)
);

create table smart_mi_rate_adjustment_case
(
    smrac_pid bigint auto_increment
        primary key,
    smrac_version int not null,
    smrac_smart_mi_rate_card_pid bigint not null,
    smrac_rate_adjustment_percent decimal(11,9) not null,
    smrac_criteria_html varchar(16000) null,
    smrac_criteria_pid bigint null,
    constraint smrac_criteria_pid
        unique (smrac_criteria_pid),
    constraint fk_smart_mi_rate_adjustment_case_1
        foreign key (smrac_smart_mi_rate_card_pid) references smart_mi_rate_card (smrca_pid),
    constraint fk_smart_mi_rate_adjustment_case_2
        foreign key (smrac_criteria_pid) references criteria (cr_pid)
);

create table smart_mi_rate_case
(
    smrc_pid bigint auto_increment
        primary key,
    smrc_version int not null,
    smrc_smart_mi_rate_card_pid bigint not null,
    smrc_criteria_html varchar(16000) null,
    smrc_ordinal int null,
    smrc_criteria_pid bigint null,
    smrc_else_case bit null,
    smrc_amount_description varchar(256) null,
    smrc_upfront_percent decimal(11,9) not null,
    smrc_initial_monthly_payment_annual_percent decimal(11,9) not null,
    smrc_coverage_percent decimal(11,9) not null,
    smrc_ltv_cutoff_percent decimal(11,9) not null,
    smrc_midpoint_cutoff_required bit null,
    smrc_required_monthly_payment_count int not null,
    smrc_initial_duration_months int not null,
    constraint smrc_criteria_pid
        unique (smrc_criteria_pid),
    constraint fk_smart_mi_rate_case_1
        foreign key (smrc_smart_mi_rate_card_pid) references smart_mi_rate_card (smrca_pid),
    constraint fk_smart_mi_rate_case_2
        foreign key (smrc_criteria_pid) references criteria (cr_pid)
);

create table smart_mi_surcharge
(
    sms_pid bigint auto_increment
        primary key,
    sms_version int not null,
    sms_account_pid bigint not null,
    sms_from_date date not null,
    constraint fk_smart_mi_surcharge_1
        foreign key (sms_account_pid) references account (a_pid)
);

create table smart_mi_surcharge_case
(
    smsc_pid bigint auto_increment
        primary key,
    smsc_version int not null,
    smsc_smart_mi_surcharge_pid bigint not null,
    smsc_criteria_pid bigint not null,
    smsc_government_surcharge_percent decimal(11,9) not null,
    smsc_minimum_surcharge_amount decimal(15,2) not null,
    smsc_criteria_html varchar(16000) not null,
    constraint fk_smart_mi_surcharge_case_1
        foreign key (smsc_smart_mi_surcharge_pid) references smart_mi_surcharge (sms_pid),
    constraint fk_smart_mi_surcharge_case_2
        foreign key (smsc_criteria_pid) references criteria (cr_pid)
);

create table smart_stack
(
    ss_pid bigint auto_increment
        primary key,
    ss_version int not null,
    ss_account_pid bigint not null,
    ss_name varchar(128) not null,
    constraint uk_smart_stack_1
        unique (ss_account_pid, ss_name),
    constraint fk_smart_stack_1
        foreign key (ss_account_pid) references account (a_pid)
);

create table smart_stack_doc_set_include_option_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table smart_doc_set
(
    sdst_pid bigint auto_increment
        primary key,
    sdst_version int not null,
    sdst_account_pid bigint not null,
    sdst_name varchar(128) null,
    sdst_doc_set_type varchar(128) not null,
    sdst_active bit null,
    sdst_smart_stack_doc_set_include_option_type varchar(128) not null,
    constraint uk_smart_doc_set_1
        unique (sdst_account_pid, sdst_name),
    constraint fk_smart_doc_set_1
        foreign key (sdst_account_pid) references account (a_pid),
    constraint fkt_sdst_doc_set_type
        foreign key (sdst_doc_set_type) references doc_set_type (code),
    constraint fkt_sdst_smart_stack_doc_set_include_option_type
        foreign key (sdst_smart_stack_doc_set_include_option_type) references smart_stack_doc_set_include_option_type (code)
);

create table key_package
(
    kp_pid bigint auto_increment
        primary key,
    kp_version int not null,
    kp_account_pid bigint not null,
    kp_smart_doc_set_pid bigint not null,
    kp_key_package_type varchar(128) not null,
    constraint kp_account_pid
        unique (kp_account_pid, kp_smart_doc_set_pid),
    constraint kp_key_package_type
        unique (kp_key_package_type, kp_account_pid),
    constraint uk_key_package_1
        unique (kp_account_pid, kp_key_package_type),
    constraint fk_key_package_1
        foreign key (kp_account_pid) references account (a_pid),
    constraint fk_key_package_2
        foreign key (kp_smart_doc_set_pid) references smart_doc_set (sdst_pid),
    constraint fkt_kp_key_package_type
        foreign key (kp_key_package_type) references key_package_type (code)
);

create table smart_stack_doc_set_include_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table solar_panel_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table stack_doc_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table stack_export_file_name_format_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table stack_export_file_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table stack_export_loan_name_format_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table stack_export_request_loan_export_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table stack_export_request_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table state_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table county
(
    c_pid bigint auto_increment
        primary key,
    c_version int not null,
    c_name varchar(128) not null,
    c_state_type varchar(128) not null,
    c_county_fips varchar(16) null,
    c_recording_district_type varchar(128) not null,
    c_torrens_available bit null,
    c_defunct bit null,
    c_mortech_name varchar(128) not null,
    constraint c_name
        unique (c_name, c_state_type),
    constraint fkt_c_recording_district_type
        foreign key (c_recording_district_type) references recording_district_type (code),
    constraint fkt_c_state_type
        foreign key (c_state_type) references state_type (code)
);

create table area_median_income_row
(
    amir_pid bigint auto_increment
        primary key,
    amir_version int not null,
    amir_area_median_income_table_pid bigint not null,
    amir_state_type varchar(128) not null,
    amir_county_pid bigint not null,
    amir_census_tract varchar(16) not null,
    amir_area_median_income decimal(15,2) not null,
    constraint uc_1
        unique (amir_area_median_income_table_pid, amir_state_type, amir_county_pid, amir_census_tract),
    constraint fk_area_median_income_row_1
        foreign key (amir_area_median_income_table_pid) references area_median_income_table (amit_pid),
    constraint fk_area_median_income_row_2
        foreign key (amir_state_type) references state_type (code),
    constraint fk_area_median_income_row_3
        foreign key (amir_county_pid) references county (c_pid)
);

create index idx_county_1
    on county (c_state_type);

create table county_city
(
    cci_pid bigint auto_increment
        primary key,
    cci_version int not null,
    cci_county_pid bigint not null,
    cci_city_name varchar(128) null,
    constraint uk_county_city_1
        unique (cci_county_pid, cci_city_name),
    constraint fk_county_city_1
        foreign key (cci_county_pid) references county (c_pid)
);

create table county_sub_jurisdiction
(
    csju_pid bigint auto_increment
        primary key,
    csju_version int not null,
    csju_county_pid bigint not null,
    csju_sub_jurisdiction_name varchar(128) null,
    constraint fk_county_sub_jurisdiction_1
        foreign key (csju_county_pid) references county (c_pid)
);

create table disaster_declaration
(
    dd_pid bigint auto_increment
        primary key,
    dd_version int not null,
    dd_account_pid bigint not null,
    dd_fema_incident_id varchar(32) null,
    dd_state_type varchar(128) not null,
    dd_county_pid bigint not null,
    dd_declared_disaster_date date null,
    dd_last_processed_datetime datetime null,
    constraint fk_disaster_declaration_1
        foreign key (dd_account_pid) references account (a_pid),
    constraint fk_disaster_declaration_2
        foreign key (dd_county_pid) references county (c_pid),
    constraint fkt_dd_state_type
        foreign key (dd_state_type) references state_type (code)
);

create table license_req
(
    mlr_pid bigint auto_increment
        primary key,
    mlr_version int not null,
    mlr_account_pid bigint not null,
    mlr_state_type varchar(128) not null,
    mlr_license_type varchar(128) not null,
    constraint uk_license_req_1
        unique (mlr_account_pid, mlr_state_type, mlr_license_type),
    constraint fk_license_req_1
        foreign key (mlr_account_pid) references account (a_pid),
    constraint fkt_mlr_license_type
        foreign key (mlr_license_type) references license_type (code),
    constraint fkt_mlr_state_type
        foreign key (mlr_state_type) references state_type (code)
);

create table loan_limit_row
(
    llr_pid bigint auto_increment
        primary key,
    llr_version int not null,
    llr_loan_limit_table_pid bigint not null,
    llr_loan_limit_type varchar(128) not null,
    llr_state_type varchar(128) not null,
    llr_county_pid bigint null,
    llr_one_unit_limit_amount decimal(15,2) not null,
    llr_two_unit_limit_amount decimal(15,2) not null,
    llr_three_unit_limit_amount decimal(15,2) not null,
    llr_four_unit_limit_amount decimal(15,2) not null,
    constraint llr_uc_1
        unique (llr_loan_limit_table_pid, llr_state_type, llr_county_pid),
    constraint fk_loan_limit_row_1
        foreign key (llr_loan_limit_table_pid) references loan_limit_table (llt_pid),
    constraint fk_loan_limit_row_2
        foreign key (llr_loan_limit_type) references loan_limit_type (code),
    constraint fk_loan_limit_row_3
        foreign key (llr_state_type) references state_type (code),
    constraint fk_loan_limit_row_4
        foreign key (llr_county_pid) references county (c_pid)
);

create table recording_city
(
    rc_pid bigint auto_increment
        primary key,
    rc_version int not null,
    rc_city_name varchar(128) not null,
    rc_state_type varchar(128) not null,
    rc_recording_city_name varchar(128) not null,
    constraint uk_recording_city_1
        unique (rc_city_name, rc_state_type),
    constraint fkt_rc_state_type
        foreign key (rc_state_type) references state_type (code)
);

create table recording_district
(
    rdi_pid bigint auto_increment
        primary key,
    rdi_version int not null,
    rdi_state_type varchar(128) not null,
    rdi_district_name_with_qualifier varchar(128) null,
    rdi_district_name varchar(128) null,
    constraint uk_county_recording_district_1
        unique (rdi_state_type, rdi_district_name_with_qualifier),
    constraint fkt_rdi_state_type
        foreign key (rdi_state_type) references state_type (code)
);

create table county_recording_district
(
    crdi_pid bigint auto_increment
        primary key,
    crdi_version int not null,
    crdi_county_pid bigint not null,
    crdi_recording_district_pid bigint not null,
    constraint uk_county_recording_district_1
        unique (crdi_county_pid, crdi_recording_district_pid),
    constraint fk_county_recording_district_1
        foreign key (crdi_county_pid) references county (c_pid),
    constraint fk_county_recording_district_2
        foreign key (crdi_recording_district_pid) references recording_district (rdi_pid)
);

create index idx_recording_district_1
    on recording_district (rdi_district_name);

create table region_ernst_page_rec
(
    rerc_pid bigint auto_increment
        primary key,
    rerc_version int not null,
    rerc_ernst_page_rec_type varchar(128) not null,
    rerc_state_type varchar(128) not null,
    rerc_county_pid bigint null,
    rerc_county_city_pid bigint null,
    rerc_recording_district_pid bigint null,
    rerc_ernst_page_rec varchar(16) not null,
    constraint fk_region_ernst_page_rec_1
        foreign key (rerc_county_pid) references county (c_pid),
    constraint fk_region_ernst_page_rec_2
        foreign key (rerc_county_city_pid) references county_city (cci_pid),
    constraint fk_region_ernst_page_rec_3
        foreign key (rerc_recording_district_pid) references recording_district (rdi_pid),
    constraint fkt_rerc_ernst_page_rec_type
        foreign key (rerc_ernst_page_rec_type) references ernst_page_rec_type (code),
    constraint fkt_rerc_state_type
        foreign key (rerc_state_type) references state_type (code)
);

create table street_links_product_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table stripe_payment_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table stripe_payment
(
    stpm_pid bigint auto_increment
        primary key,
    stpm_version int not null,
    stpm_account_pid bigint not null,
    stpm_submit_datetime datetime null,
    stpm_payer_unparsed_name varchar(128) not null,
    stpm_invoice_amount decimal(15,2) not null,
    stpm_payment_request_type varchar(128) not null,
    stpm_stripe_payment_status_type varchar(128) not null,
    stpm_payment_status_messages text not null,
    stpm_status_datetime datetime not null,
    stpm_token varchar(128) not null,
    stpm_receipt_email varchar(256) not null,
    stpm_stripe_id varchar(128) not null,
    stpm_refund_stripe_id varchar(128) not null,
    stpm_receipt_url varchar(256) not null,
    constraint fk_stripe_payment_1
        foreign key (stpm_account_pid) references account (a_pid),
    constraint fkt_stpm_payment_request_type
        foreign key (stpm_payment_request_type) references payment_request_type (code),
    constraint fkt_stpm_stripe_payment_status_type
        foreign key (stpm_stripe_payment_status_type) references stripe_payment_status_type (code)
);

create table tax_filing_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table tax_transcript_request_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table taxpayer_identifier_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table contractor
(
    ctr_pid bigint auto_increment
        primary key,
    ctr_version int not null,
    ctr_account_pid bigint not null,
    ctr_contractor_company_name varchar(128) not null,
    ctr_max_construction_credit_amount decimal(15,2) not null,
    ctr_taxpayer_identifier_type varchar(128) not null,
    ctr_first_name varchar(128) not null,
    ctr_last_name varchar(128) not null,
    ctr_work_phone varchar(32) not null,
    ctr_work_phone_extension varchar(16) not null,
    ctr_mobile_phone varchar(32) not null,
    ctr_fax varchar(32) not null,
    ctr_email varchar(256) not null,
    ctr_address_street1 varchar(128) not null,
    ctr_address_street2 varchar(128) not null,
    ctr_address_city varchar(128) not null,
    ctr_address_state varchar(128) not null,
    ctr_address_postal_code varchar(128) not null,
    ctr_address_country varchar(128) not null,
    ctr_notes varchar(1024) not null,
    constraint fk_contractor_1
        foreign key (ctr_account_pid) references account (a_pid),
    constraint fkt_ctr_taxpayer_identifier_type
        foreign key (ctr_taxpayer_identifier_type) references taxpayer_identifier_type (code)
);

create table contractor_license
(
    ctrl_pid bigint auto_increment
        primary key,
    ctrl_version int not null,
    ctrl_contractor_pid bigint not null,
    ctrl_state_type varchar(128) not null,
    ctrl_license_number varchar(128) not null,
    ctrl_from_date date not null,
    ctrl_through_date date not null,
    ctrl_note varchar(256) not null,
    constraint fk_contractor_license_1
        foreign key (ctrl_contractor_pid) references contractor (ctr_pid),
    constraint fkt_ctrl_state_type
        foreign key (ctrl_state_type) references state_type (code)
);

create table third_party_community_second_program_eligibility_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table time_zone_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table admin_user
(
    au_pid bigint auto_increment
        primary key,
    au_version int not null,
    au_create_date date not null,
    au_email varchar(256) null,
    au_first_name varchar(32) null,
    au_last_name varchar(32) not null,
    au_unparsed_name varchar(128) null,
    au_password varchar(128) not null,
    au_office_phone varchar(32) null,
    au_office_phone_extension varchar(16) null,
    au_through_date date null,
    au_time_zone varchar(128) not null,
    au_title varchar(128) null,
    au_admin_user_status_type varchar(128) not null,
    au_username varchar(32) not null,
    au_admin_user_administrator bit null,
    au_customer_support bit null,
    au_engineering bit null,
    au_management bit null,
    au_force_password_change bit null,
    au_last_password_change_date datetime null,
    au_previous_password_1 varchar(128) null,
    au_previous_password_2 varchar(128) null,
    au_previous_password_3 varchar(128) null,
    au_last_sign_on_datetime datetime null,
    au_mobile_phone varchar(32) null,
    au_backup_phone varchar(32) null,
    au_secret_key varchar(128) null,
    constraint au_username
        unique (au_username),
    constraint fkt_au_admin_user_status_type
        foreign key (au_admin_user_status_type) references admin_user_status_type (code),
    constraint fkt_au_time_zone
        foreign key (au_time_zone) references time_zone_type (code)
);

create table borrower_user
(
    bu_pid bigint auto_increment
        primary key,
    bu_version int not null,
    bu_account_pid bigint not null,
    bu_create_datetime datetime not null,
    bu_email varchar(256) not null,
    bu_password varchar(128) null,
    bu_last_sign_on_datetime datetime null,
    bu_time_zone varchar(128) not null,
    bu_first_name varchar(32) not null,
    bu_middle_name varchar(32) null,
    bu_last_name varchar(32) not null,
    bu_name_suffix varchar(32) null,
    bu_unparsed_name varchar(128) null,
    bu_borrower_activation_id varchar(128) null,
    bu_challenge_question_type varchar(128) not null,
    bu_challenge_question_answer varchar(128) null,
    bu_borrower_user_account_status_type varchar(128) not null,
    bu_public_quote_request_cache_id int null,
    bu_create_sap_on_activation bit null,
    bu_mobile_phone varchar(32) null,
    bu_backup_phone varchar(32) null,
    bu_secret_key varchar(128) null,
    bu_nickname varchar(32) not null,
    bu_plain_text_email bit not null,
    bu_preferred_first_name varchar(32) not null,
    constraint uk_borrower_user_1
        unique (bu_account_pid, bu_email),
    constraint fk_borrower_user_1
        foreign key (bu_account_pid) references account (a_pid),
    constraint fkt_bu_borrower_user_account_status_type
        foreign key (bu_borrower_user_account_status_type) references borrower_user_account_status_type (code),
    constraint fkt_bu_challenge_question_type
        foreign key (bu_challenge_question_type) references challenge_question_type (code),
    constraint fkt_bu_time_zone
        foreign key (bu_time_zone) references time_zone_type (code)
);

create index idx_borrower_user_1
    on borrower_user (bu_borrower_activation_id);

create table borrower_user_reset_password
(
    burp_pid bigint auto_increment
        primary key,
    burp_version int not null,
    burp_borrower_user_pid bigint not null,
    burp_create_datetime datetime not null,
    burp_reset_password_id varchar(128) not null,
    constraint burp_reset_password_id
        unique (burp_reset_password_id),
    constraint fk_borrower_user_reset_password_1
        foreign key (burp_borrower_user_pid) references borrower_user (bu_pid)
);

create index idx_borrower_user_reset_password_1
    on borrower_user_reset_password (burp_reset_password_id);

create table timeout_time_zone_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table title_company
(
    tc_pid bigint auto_increment
        primary key,
    tc_version int not null,
    tc_account_pid bigint not null,
    tc_company_name varchar(128) null,
    tc_admin_lock bit null,
    tc_active bit null,
    tc_preferred_vendor bit null,
    constraint fk_title_company_1
        foreign key (tc_account_pid) references account (a_pid)
);

create table title_company_office
(
    tco_pid bigint auto_increment
        primary key,
    tco_version int not null,
    tco_title_company_pid bigint not null,
    tco_address_street1 varchar(128) not null,
    tco_address_street2 varchar(128) not null,
    tco_address_city varchar(128) not null,
    tco_address_state varchar(128) not null,
    tco_address_postal_code varchar(128) not null,
    tco_address_country varchar(128) not null,
    tco_phone varchar(32) null,
    tco_fax varchar(32) null,
    tco_email varchar(256) null,
    tco_active bit null,
    constraint fk_title_company_office_1
        foreign key (tco_title_company_pid) references title_company (tc_pid),
    constraint fkt_tco_address_country
        foreign key (tco_address_country) references country_type (code)
);

create table preferred_settlement
(
    prs_pid bigint auto_increment
        primary key,
    prs_version int not null,
    prs_account_pid bigint not null,
    prs_state varchar(16) null,
    prs_from_date date null,
    prs_title_company_pid bigint not null,
    prs_title_company_office_pid bigint not null,
    prs_settlement_agent_pid bigint not null,
    prs_settlement_agent_office_pid bigint not null,
    prs_settlement_agent_wire_pid bigint not null,
    constraint uk_preferred_settlement_1
        unique (prs_account_pid, prs_state, prs_from_date),
    constraint fk_preferred_settlement_1
        foreign key (prs_account_pid) references account (a_pid),
    constraint fk_preferred_settlement_2
        foreign key (prs_title_company_pid) references title_company (tc_pid),
    constraint fk_preferred_settlement_3
        foreign key (prs_title_company_office_pid) references title_company_office (tco_pid),
    constraint fk_preferred_settlement_4
        foreign key (prs_settlement_agent_pid) references settlement_agent (sa_pid),
    constraint fk_preferred_settlement_5
        foreign key (prs_settlement_agent_office_pid) references settlement_agent_office (sao_pid),
    constraint fk_preferred_settlement_6
        foreign key (prs_settlement_agent_wire_pid) references settlement_agent_wire (saw_pid)
);

create table title_manner_held_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table total_expert_account_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table trade_audit_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table trade_fee_type
(
    tft_pid bigint auto_increment
        primary key,
    tft_version int not null,
    tft_account_pid bigint not null,
    tft_name varchar(128) not null,
    constraint tft_account_pid
        unique (tft_account_pid, tft_name),
    constraint fk_trade_fee_type_1
        foreign key (tft_account_pid) references account (a_pid)
);

create table trade_pricing_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table trade_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table trustee
(
    tru_pid bigint auto_increment
        primary key,
    tru_version int not null,
    tru_account_pid bigint not null,
    tru_name varchar(128) null,
    tru_address_street1 varchar(128) not null,
    tru_address_street2 varchar(128) not null,
    tru_address_city varchar(128) not null,
    tru_address_state varchar(128) not null,
    tru_address_postal_code varchar(128) not null,
    tru_address_country varchar(128) not null,
    tru_mers_org_id varchar(7) null,
    tru_from_date date null,
    tru_through_date date null,
    tru_phone_number varchar(32) null,
    constraint fk_trustee_1
        foreign key (tru_account_pid) references account (a_pid),
    constraint fkt_tru_address_country
        foreign key (tru_address_country) references country_type (code)
);

create table underwrite_disposition_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table underwrite_method_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table underwrite_risk_assessment_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table unique_dwelling_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table usda_rd_single_family_housing_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table uuts_loan_originator_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table va_borrower_certification_occupancy_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table va_entitlement_code_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table va_entitlement_restoration_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table va_notice_of_value_source_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table va_past_credit_record_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table va_regional_loan_center_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table va_relative_relationship_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table vendor_credential_source_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table vendor_document_event_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table vendor_import_document_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table veteran_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table voe_third_party_verifier_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table voe_verbal_verify_method_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table voe_verify_method_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table water_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table wf_deal_process_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table wf_deal_step_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table wf_outcome_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table wf_phase
(
    wph_pid bigint auto_increment
        primary key,
    wph_version int not null,
    wph_account_pid bigint not null,
    wph_phase_name varchar(128) not null,
    wph_phase_number int not null,
    constraint wph_account_pid
        unique (wph_account_pid, wph_phase_name),
    constraint wph_account_pid_2
        unique (wph_account_pid, wph_phase_number),
    constraint fk_wf_phase_1
        foreign key (wph_account_pid) references account (a_pid)
);

create table wf_process_status_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table wf_process_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table wf_process
(
    wpr_pid bigint auto_increment
        primary key,
    wpr_version int not null,
    wpr_account_pid bigint not null,
    wpr_name varchar(128) null,
    wpr_wf_process_type varchar(128) not null,
    wpr_criteria_pid bigint null,
    wpr_wf_process_status_type varchar(128) not null,
    constraint fk_wf_process_1
        foreign key (wpr_account_pid) references account (a_pid),
    constraint fkt_wpr_wf_process_status_type
        foreign key (wpr_wf_process_status_type) references wf_process_status_type (code),
    constraint fkt_wpr_wf_process_type
        foreign key (wpr_wf_process_type) references wf_process_type (code)
);

create table wf_step_function_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table wf_step_performer_assign_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table wf_step_reassign_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table wf_step_timeout_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table wf_step_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table wf_wait_until_time_slice
(
    wts_pid bigint auto_increment
        primary key,
    wts_version int not null,
    wts_time_slice datetime not null,
    wts_when_fired datetime null,
    wts_when_complete datetime null
);

create index idx_wf_wait_until_time_slice_1
    on wf_wait_until_time_slice (wts_time_slice);

create table yes_no_na_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table yes_no_na_unknown_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table yes_no_unknown_type
(
    code varchar(128) not null
        primary key,
    value varchar(1024) not null
);

create table application
(
    apl_pid bigint auto_increment
        primary key,
    apl_version int not null,
    apl_application_name varchar(128) null,
    apl_primary_application bit null,
    apl_urla bit not null,
    apl_proposal_pid bigint not null,
    apl_fha_borrower_certification_own_other_property varchar(128) not null,
    apl_fha_borrower_certification_property_to_be_sold varchar(128) not null,
    apl_fha_borrower_certification_sales_price_amount decimal(15) null,
    apl_fha_borrower_certification_mortgage_amount decimal(15) null,
    apl_address_street1 varchar(128) null,
    apl_address_street2 varchar(128) null,
    apl_address_city varchar(128) null,
    apl_address_state varchar(128) null,
    apl_address_postal_code varchar(128) null,
    apl_address_country varchar(128) not null,
    apl_fha_borrower_certification_rental varchar(128) not null,
    apl_fha_borrower_certification_rental_explain varchar(256) null,
    apl_fha_borrower_certification_more_than_four_dwellings varchar(128) not null,
    apl_va_borrower_certification_occupancy_type varchar(128) not null,
    apl_fha_va_bor_cert_sales_price_exceeds_type varchar(128) not null,
    constraint fkt_apl_address_country
        foreign key (apl_address_country) references country_type (code),
    constraint fkt_apl_fha_borrower_certification_more_than_four_dwellings
        foreign key (apl_fha_borrower_certification_more_than_four_dwellings) references yes_no_unknown_type (code),
    constraint fkt_apl_fha_borrower_certification_own_other_property
        foreign key (apl_fha_borrower_certification_own_other_property) references yes_no_unknown_type (code),
    constraint fkt_apl_fha_borrower_certification_property_to_be_sold
        foreign key (apl_fha_borrower_certification_property_to_be_sold) references yes_no_unknown_type (code),
    constraint fkt_apl_fha_borrower_certification_rental
        foreign key (apl_fha_borrower_certification_rental) references yes_no_unknown_type (code),
    constraint fkt_apl_fha_va_bor_cert_sales_price_exceeds_type
        foreign key (apl_fha_va_bor_cert_sales_price_exceeds_type) references fha_va_bor_cert_sales_price_exceeds_type (code),
    constraint fkt_apl_va_borrower_certification_occupancy_type
        foreign key (apl_va_borrower_certification_occupancy_type) references va_borrower_certification_occupancy_type (code)
);

create table asset
(
    as_pid bigint auto_increment
        primary key,
    as_version int not null,
    as_account_id varchar(32) null,
    as_aggregate_description varchar(256) null,
    as_application_pid bigint not null,
    as_asset_type varchar(128) not null,
    as_automobile_make_description varchar(32) null,
    as_automobile_model_year int null,
    as_cash_or_market_value_amount decimal(15,2) not null,
    as_description varchar(128) not null,
    as_donor_city varchar(128) null,
    as_donor_country varchar(128) not null,
    as_donor_postal_code varchar(128) null,
    as_donor_state varchar(128) null,
    as_donor_street1 varchar(128) null,
    as_donor_street2 varchar(128) null,
    as_gift_funds_donor_phone varchar(32) null,
    as_gift_funds_donor_relationship varchar(128) null,
    as_gift_funds_donor_unparsed_name varchar(128) null,
    as_gift_funds_other_type_description varchar(32) null,
    as_gift_funds_source_account_id varchar(32) null,
    as_gift_funds_depository_asset_pid bigint null,
    as_gift_amount decimal(15,2) not null,
    as_gift_funds_source_account_type varchar(128) null,
    as_gift_funds_source_holder_name varchar(128) null,
    as_gift_funds_type varchar(128) not null,
    as_holder_name varchar(128) null,
    as_holder_city varchar(128) null,
    as_holder_country varchar(128) not null,
    as_holder_postal_code varchar(128) null,
    as_holder_state varchar(128) null,
    as_holder_street1 varchar(128) null,
    as_holder_street2 varchar(128) null,
    as_life_insurance_face_value_amount decimal(15,2) not null,
    as_liquid_amount decimal(15,2) not null,
    as_liquid_percent decimal(11,9) not null,
    as_source_verification_required varchar(128) not null,
    as_stock_bond_mutual_fund_share_count int null,
    as_earnest_money_deposit_source_pid bigint null,
    as_available_amount decimal(15,2) not null,
    as_down_payment_amount decimal(15) not null,
    as_closing_costs_amount decimal(15,2) not null,
    as_gift_funds_account_holder_type varchar(128) not null,
    as_penalty_amount decimal(15,2) not null,
    constraint fk_asset_1
        foreign key (as_application_pid) references application (apl_pid),
    constraint fk_asset_2
        foreign key (as_earnest_money_deposit_source_pid) references asset (as_pid),
    constraint fk_asset_3
        foreign key (as_gift_funds_depository_asset_pid) references asset (as_pid),
    constraint fkt_as_asset_type
        foreign key (as_asset_type) references asset_type (code),
    constraint fkt_as_donor_country
        foreign key (as_donor_country) references country_type (code),
    constraint fkt_as_gift_funds_account_holder_type
        foreign key (as_gift_funds_account_holder_type) references asset_account_holder_type (code),
    constraint fkt_as_gift_funds_type
        foreign key (as_gift_funds_type) references gift_funds_type (code),
    constraint fkt_as_holder_country
        foreign key (as_holder_country) references country_type (code),
    constraint fkt_as_source_verification_required
        foreign key (as_source_verification_required) references yes_no_unknown_type (code)
);

create table asset_large_deposit
(
    ald_pid bigint auto_increment
        primary key,
    ald_version int not null,
    ald_asset_pid bigint not null,
    ald_deposit_amount decimal(15,2) not null,
    ald_deposit_date date null,
    constraint fk_asset_large_deposit_1
        foreign key (ald_asset_pid) references asset (as_pid)
);

create table creditor
(
    crd_pid bigint auto_increment
        primary key,
    crd_version int not null,
    crd_account_pid bigint not null,
    crd_payoff_request_delivery_type varchar(128) not null,
    crd_name varchar(128) null,
    crd_payoff_phone_1 varchar(32) null,
    crd_payoff_phone_1_extension varchar(16) null,
    crd_payoff_phone_2 varchar(32) null,
    crd_payoff_phone_2_extension varchar(16) null,
    crd_payoff_fax varchar(32) null,
    crd_payoff_email varchar(256) null,
    crd_payoff_auto_teller varchar(128) not null,
    crd_last_updated date null,
    crd_last_updated_by varchar(128) null,
    crd_payoff_notes varchar(1024) null,
    crd_address_street1 varchar(128) not null,
    crd_address_street2 varchar(128) not null,
    crd_address_city varchar(128) not null,
    crd_address_state varchar(128) not null,
    crd_address_postal_code varchar(128) not null,
    crd_address_country varchar(128) not null,
    crd_key_creditor_type varchar(128) not null,
    constraint fk_creditor_1
        foreign key (crd_account_pid) references account (a_pid),
    constraint fkt_crd_address_country
        foreign key (crd_address_country) references country_type (code),
    constraint fkt_crd_key_creditor_type
        foreign key (crd_key_creditor_type) references key_creditor_type (code),
    constraint fkt_crd_payoff_auto_teller
        foreign key (crd_payoff_auto_teller) references yes_no_unknown_type (code),
    constraint fkt_crd_payoff_request_delivery_type
        foreign key (crd_payoff_request_delivery_type) references payoff_request_delivery_type (code)
);

create table creditor_lookup_name
(
    cln_pid bigint auto_increment
        primary key,
    cln_version int not null,
    cln_account_pid bigint not null,
    cln_creditor_pid bigint not null,
    cln_name varchar(128) null,
    constraint uk_creditor_lookup_name_1
        unique (cln_account_pid, cln_name),
    constraint fk_creditor_lookup_name_1
        foreign key (cln_account_pid) references account (a_pid),
    constraint fk_creditor_lookup_name_2
        foreign key (cln_creditor_pid) references creditor (crd_pid)
);

create table investor
(
    i_pid bigint auto_increment
        primary key,
    i_version int not null,
    i_account_pid bigint not null,
    i_investor_id varchar(32) not null,
    i_criteria_pid bigint null,
    i_website_url varchar(256) null,
    i_investor_name varchar(128) null,
    i_investor_city varchar(128) null,
    i_investor_country varchar(128) not null,
    i_investor_postal_code varchar(128) null,
    i_investor_state varchar(128) null,
    i_investor_street1 varchar(128) null,
    i_investor_street2 varchar(128) null,
    i_investor_county_pid bigint null,
    i_beneficiary_name varchar(128) null,
    i_beneficiary_city varchar(128) null,
    i_beneficiary_country varchar(128) not null,
    i_beneficiary_postal_code varchar(128) null,
    i_beneficiary_state varchar(128) null,
    i_beneficiary_street1 varchar(128) null,
    i_beneficiary_street2 varchar(128) null,
    i_beneficiary_county_pid bigint null,
    i_loss_payee_name varchar(128) null,
    i_loss_payee_city varchar(128) null,
    i_loss_payee_country varchar(128) not null,
    i_loss_payee_postal_code varchar(128) null,
    i_loss_payee_state varchar(128) null,
    i_loss_payee_street1 varchar(128) null,
    i_loss_payee_street2 varchar(128) null,
    i_loss_payee_county_pid bigint null,
    i_loss_payee_assignee_name varchar(128) null,
    i_when_recorded_mail_to_name varchar(128) null,
    i_when_recorded_mail_to_city varchar(128) null,
    i_when_recorded_mail_to_country varchar(128) not null,
    i_when_recorded_mail_to_postal_code varchar(128) null,
    i_when_recorded_mail_to_state varchar(128) null,
    i_when_recorded_mail_to_street1 varchar(128) null,
    i_when_recorded_mail_to_street2 varchar(128) null,
    i_when_recorded_mail_to_county_pid bigint null,
    i_servicer_name varchar(128) not null,
    i_servicer_address_street1 varchar(128) not null,
    i_servicer_address_street2 varchar(128) not null,
    i_servicer_address_city varchar(128) not null,
    i_servicer_address_state varchar(128) not null,
    i_servicer_address_postal_code varchar(128) not null,
    i_servicer_address_country varchar(128) not null,
    i_servicer_county_pid bigint null,
    i_sub_servicer_name varchar(128) not null,
    i_sub_servicer_address_street1 varchar(128) not null,
    i_sub_servicer_address_street2 varchar(128) not null,
    i_sub_servicer_address_city varchar(128) not null,
    i_sub_servicer_address_state varchar(128) not null,
    i_sub_servicer_address_postal_code varchar(128) not null,
    i_sub_servicer_address_country varchar(128) not null,
    i_sub_servicer_mers_org_id varchar(7) not null,
    i_custodian_pid bigint null,
    i_file_delivery_name varchar(128) not null,
    i_file_delivery_address_street1 varchar(128) not null,
    i_file_delivery_address_street2 varchar(128) not null,
    i_file_delivery_address_city varchar(128) not null,
    i_file_delivery_address_state varchar(128) not null,
    i_file_delivery_address_postal_code varchar(128) not null,
    i_file_delivery_address_country varchar(128) not null,
    i_initial_beneficiary_candidate bit null,
    i_initial_servicer_candidate bit null,
    i_mers_org_member varchar(128) not null,
    i_mers_org_id varchar(7) not null,
    i_allonge_transfer_to_name varchar(128) null,
    i_lock_expiration_delivery_subtrahend_days int null,
    i_maximum_lock_extensions_allowed int null,
    i_maximum_lock_extension_days_allowed int null,
    i_mortech_investor_id varchar(16) null,
    i_fnma_servicer_id varchar(16) not null,
    i_loan_file_delivery_method_type varchar(128) null,
    i_investor_group_pid bigint null,
    i_mbs_investor bit not null,
    i_investor_hmda_purchaser_of_loan_type varchar(128) not null,
    i_lock_disable_time time null,
    i_allow_weekend_holiday_locks bit not null,
    i_nmls_id varchar(16) null,
    i_nmls_id_applicable varchar(128) not null,
    i_fnm_investor_remittance_type varchar(128) not null,
    i_fnm_mbs_investor_remittance_day_of_month int not null,
    i_fnm_mbs_loan_default_loss_party_type varchar(128) not null,
    i_fnm_mbs_reo_marketing_party_type varchar(128) not null,
    constraint i_account_pid
        unique (i_account_pid, i_investor_id),
    constraint fk_investor_1
        foreign key (i_account_pid) references account (a_pid),
    constraint fk_investor_10
        foreign key (i_investor_group_pid) references investor_group (ig_pid),
    constraint fk_investor_2
        foreign key (i_investor_county_pid) references county (c_pid),
    constraint fk_investor_3
        foreign key (i_beneficiary_county_pid) references county (c_pid),
    constraint fk_investor_4
        foreign key (i_loss_payee_county_pid) references county (c_pid),
    constraint fk_investor_6
        foreign key (i_when_recorded_mail_to_county_pid) references county (c_pid),
    constraint fk_investor_7
        foreign key (i_servicer_county_pid) references county (c_pid),
    constraint fk_investor_8
        foreign key (i_custodian_pid) references custodian (cu_pid),
    constraint fk_investor_9
        foreign key (i_criteria_pid) references criteria (cr_pid),
    constraint fkt_i_beneficiary_country
        foreign key (i_beneficiary_country) references country_type (code),
    constraint fkt_i_file_delivery_address_country
        foreign key (i_file_delivery_address_country) references country_type (code),
    constraint fkt_i_fnm_investor_remittance_type
        foreign key (i_fnm_investor_remittance_type) references fnm_investor_remittance_type (code),
    constraint fkt_i_fnm_mbs_loan_default_loss_party_type
        foreign key (i_fnm_mbs_loan_default_loss_party_type) references fnm_mbs_loan_default_loss_party_type (code),
    constraint fkt_i_fnm_mbs_reo_marketing_party_type
        foreign key (i_fnm_mbs_reo_marketing_party_type) references fnm_mbs_reo_marketing_party_type (code),
    constraint fkt_i_investor_country
        foreign key (i_investor_country) references country_type (code),
    constraint fkt_i_investor_hmda_purchaser_of_loan_type
        foreign key (i_investor_hmda_purchaser_of_loan_type) references investor_hmda_purchaser_of_loan_type (code),
    constraint fkt_i_loan_file_delivery_method_type
        foreign key (i_loan_file_delivery_method_type) references loan_file_delivery_method_type (code),
    constraint fkt_i_loss_payee_country
        foreign key (i_loss_payee_country) references country_type (code),
    constraint fkt_i_mers_org_member
        foreign key (i_mers_org_member) references yes_no_unknown_type (code),
    constraint fkt_i_nmls_id_applicable
        foreign key (i_nmls_id_applicable) references yes_no_unknown_type (code),
    constraint fkt_i_servicer_address_country
        foreign key (i_servicer_address_country) references country_type (code),
    constraint fkt_i_sub_servicer_address_country
        foreign key (i_sub_servicer_address_country) references country_type (code),
    constraint fkt_i_when_recorded_mail_to_country
        foreign key (i_when_recorded_mail_to_country) references country_type (code)
);

create table company
(
    cm_pid bigint auto_increment
        primary key,
    cm_version int not null,
    cm_account_pid bigint not null,
    cm_origination_source_type varchar(128) not null,
    cm_company_id varchar(32) not null,
    cm_nmls_company_id varchar(16) not null,
    cm_federal_tax_id varchar(32) null,
    cm_mers_org_id varchar(7) not null,
    cm_mers_mom bit not null,
    cm_company_name varchar(128) not null,
    cm_company_mailing_address_name varchar(128) not null,
    cm_company_name_for_header_and_footer varchar(128) not null,
    cm_casual_company_name varchar(128) not null,
    cm_company_address_street1 varchar(128) not null,
    cm_company_address_street2 varchar(128) not null,
    cm_company_address_city varchar(128) not null,
    cm_company_address_state varchar(128) not null,
    cm_company_address_postal_code varchar(128) not null,
    cm_company_address_country varchar(128) not null,
    cm_company_phone varchar(32) null,
    cm_customer_service_email varchar(256) null,
    cm_customer_service_phone varchar(32) null,
    cm_customer_service_phone_extension varchar(16) null,
    cm_borrower_app_company_host varchar(256) null,
    cm_borrower_app_company_ip_address varchar(32) null,
    cm_borrower_app_company_enabled bit null,
    cm_borrower_user_email_from varchar(256) not null,
    cm_company_legal_entity_type varchar(128) not null,
    cm_company_legal_entity_organization_state_type varchar(128) not null,
    cm_broker_participating_with_less_than_four_lenders varchar(128) not null,
    cm_broker_participating_lender_1 varchar(256) not null,
    cm_broker_participating_lender_2 varchar(256) not null,
    cm_broker_participating_lender_3 varchar(256) not null,
    cm_correspondent_investor_pid bigint null,
    cm_total_expert_account_type varchar(128) not null,
    constraint uk_company_1
        unique (cm_account_pid, cm_company_id),
    constraint fk_company_1
        foreign key (cm_account_pid) references account (a_pid),
    constraint fk_company_2
        foreign key (cm_correspondent_investor_pid) references investor (i_pid),
    constraint fkt_cm_broker_participating_with_less_than_four_lenders
        foreign key (cm_broker_participating_with_less_than_four_lenders) references yes_no_unknown_type (code),
    constraint fkt_cm_company_address_country
        foreign key (cm_company_address_country) references country_type (code),
    constraint fkt_cm_company_legal_entity_organization_state_type
        foreign key (cm_company_legal_entity_organization_state_type) references state_type (code),
    constraint fkt_cm_origination_source_type
        foreign key (cm_origination_source_type) references origination_source_type (code),
    constraint fkt_cm_total_expert_account_type
        foreign key (cm_total_expert_account_type) references total_expert_account_type (code)
);

create table branch
(
    br_pid bigint auto_increment
        primary key,
    br_version int not null,
    br_company_pid bigint not null,
    br_branch_name varchar(128) not null,
    br_fha_field_office_code varchar(16) null,
    br_branch_id varchar(16) null,
    br_branch_status_type varchar(128) not null,
    br_nmls_branch_id varchar(16) null,
    br_uuts_loan_originator_type varchar(128) not null,
    br_address_street1 varchar(128) not null,
    br_address_street2 varchar(128) not null,
    br_address_city varchar(128) not null,
    br_address_state varchar(128) not null,
    br_address_postal_code varchar(128) not null,
    br_address_country varchar(128) not null,
    br_office_phone varchar(32) null,
    br_office_phone_extension varchar(16) null,
    br_fax varchar(32) null,
    br_lp_lender_branch_id varchar(16) null,
    br_dsi_customer_id varchar(16) null,
    br_clg_flood_cert_internal_account_id varchar(16) null,
    br_street_links_branch_id varchar(32) null,
    br_fha_branch_id varchar(16) null,
    br_fha_branch_id_qualified varchar(16) null,
    br_lender_paid_broker_compensation_percent decimal(11,9) not null,
    constraint br_company_pid
        unique (br_company_pid, br_branch_id),
    constraint fk_branch_1
        foreign key (br_company_pid) references company (cm_pid),
    constraint fkt_br_address_country
        foreign key (br_address_country) references country_type (code),
    constraint fkt_br_branch_status_type
        foreign key (br_branch_status_type) references branch_status_type (code),
    constraint fkt_br_uuts_loan_originator_type
        foreign key (br_uuts_loan_originator_type) references uuts_loan_originator_type (code)
);

create table branch_license
(
    brml_pid bigint auto_increment
        primary key,
    brml_version int not null,
    brml_branch_pid bigint not null,
    brml_license_type varchar(128) not null,
    brml_state_type varchar(128) not null,
    brml_license_number varchar(128) null,
    brml_from_date date not null,
    brml_through_date date not null,
    brml_note varchar(256) null,
    constraint fk_branch_license_1
        foreign key (brml_branch_pid) references branch (br_pid),
    constraint fkt_brml_license_type
        foreign key (brml_license_type) references license_type (code),
    constraint fkt_brml_state_type
        foreign key (brml_state_type) references state_type (code)
);

create index idx_account_1
    on company (cm_borrower_app_company_host);

create table company_license
(
    cml_pid bigint auto_increment
        primary key,
    cml_version int not null,
    cml_company_pid bigint not null,
    cml_license_type varchar(128) not null,
    cml_state_type varchar(128) not null,
    cml_company_state_license_type varchar(128) not null,
    cml_company_state_legal_name varchar(128) not null,
    cml_use_state_specific_company_name bit not null,
    cml_license_number varchar(128) null,
    cml_from_date date not null,
    cml_through_date date not null,
    cml_note varchar(256) null,
    constraint fk_company_license_1
        foreign key (cml_company_pid) references company (cm_pid),
    constraint fkt_cml_company_state_license_type
        foreign key (cml_company_state_license_type) references company_state_license_type (code),
    constraint fkt_cml_license_type
        foreign key (cml_license_type) references license_type (code),
    constraint fkt_cml_state_type
        foreign key (cml_state_type) references state_type (code)
);

create table company_service_credentials
(
    cmsc_pid bigint auto_increment
        primary key,
    cmsc_version int not null,
    cmsc_company_pid bigint not null,
    cmsc_external_entity_type varchar(128) null,
    cmsc_username varchar(256) null,
    cmsc_password varchar(128) null,
    cmsc_password2 varchar(128) null,
    cmsc_additional_id varchar(32) null,
    cmsc_additional_question bit null,
    cmsc_credential_source_type_user varchar(128) null,
    cmsc_credential_source_type_auto varchar(128) null,
    constraint fk_company_service_credentials_1
        foreign key (cmsc_company_pid) references company (cm_pid),
    constraint fkt_company_service_credentials_1
        foreign key (cmsc_external_entity_type) references external_entity_type (code),
    constraint fkt_company_service_credentials_2
        foreign key (cmsc_credential_source_type_user) references vendor_credential_source_type (code),
    constraint fkt_company_service_credentials_3
        foreign key (cmsc_credential_source_type_auto) references vendor_credential_source_type (code)
);

create table deal
(
    d_pid bigint auto_increment
        primary key,
    d_version int not null,
    d_account_pid bigint not null,
    d_company_pid bigint not null,
    d_active_proposal_pid bigint null,
    d_branch_pid bigint null,
    d_deal_create_date date not null,
    d_deal_status_type varchar(128) not null,
    d_velocify_lead_id varchar(32) null,
    d_lead_zillow_zq varchar(256) null,
    d_lead_tracking_id varchar(256) null,
    d_lead_reference_id varchar(256) null,
    d_los_loan_id_main bigint not null,
    d_los_loan_id_piggyback bigint null,
    d_mers_min_main varchar(20) not null,
    d_mers_min_piggyback varchar(20) null,
    d_external_loan_id_main varchar(32) not null,
    d_external_loan_id_piggyback varchar(32) not null,
    d_lead_source_pid bigint not null,
    d_disclosure_mode_date date null,
    d_deal_status_date date null,
    d_sap_deal bit null,
    d_hmda_action_date date null,
    d_hmda_action_type varchar(128) not null,
    d_hmda_denial_reason_type_1 varchar(128) not null,
    d_hmda_denial_reason_type_2 varchar(128) not null,
    d_hmda_denial_reason_type_3 varchar(128) not null,
    d_hmda_denial_reason_type_4 varchar(128) not null,
    d_borrower_esign bit null,
    d_enable_electronic_transaction varchar(128) not null,
    d_application_type varchar(128) not null,
    d_welcome_call_datetime datetime null,
    d_realty_agent_scenario_type varchar(128) not null,
    d_test_loan bit not null,
    d_charges_enabled_date date null,
    d_credit_bureau_type varchar(128) not null,
    d_performer_team_pid bigint null,
    d_deal_create_type varchar(128) not null,
    d_hmda_denial_reason_other_description varchar(255) not null,
    d_effective_hmda_action_date date null,
    d_copy_source_los_loan_id_main bigint null,
    d_copy_source_los_loan_id_piggyback bigint null,
    d_referred_by_name varchar(128) not null,
    d_hmda_universal_loan_id_main varchar(45) not null,
    d_hmda_universal_loan_id_piggyback varchar(45) not null,
    d_calyx_loan_guid varchar(128) not null,
    d_invoices_enabled_date date null,
    d_invoices_enabled bit not null,
    d_training_loan bit not null,
    d_deal_orphan_status_type varchar(128) not null,
    d_deal_orphan_earliest_check_date date not null,
    d_deal_create_date_time datetime not null,
    d_gse_version_type varchar(128) not null,
    d_early_wire_request bit not null,
    constraint uk_deal_1
        unique (d_account_pid, d_los_loan_id_main),
    constraint uk_deal_2
        unique (d_account_pid, d_los_loan_id_piggyback),
    constraint uk_deal_3
        unique (d_account_pid, d_mers_min_main),
    constraint uk_deal_4
        unique (d_account_pid, d_mers_min_piggyback),
    constraint fk_deal_1
        foreign key (d_account_pid) references account (a_pid),
    constraint fk_deal_14
        foreign key (d_performer_team_pid) references performer_team (ptm_pid),
    constraint fk_deal_6
        foreign key (d_branch_pid) references branch (br_pid),
    constraint fk_deal_7
        foreign key (d_lead_source_pid) references lead_source (lds_pid),
    constraint fk_deal_8
        foreign key (d_company_pid) references company (cm_pid),
    constraint fkt_d_application_type
        foreign key (d_application_type) references application_type (code),
    constraint fkt_d_credit_bureau_type
        foreign key (d_credit_bureau_type) references credit_bureau_type (code),
    constraint fkt_d_deal_create_type
        foreign key (d_deal_create_type) references deal_create_type (code),
    constraint fkt_d_deal_orphan_status_type
        foreign key (d_deal_orphan_status_type) references deal_orphan_status_type (code),
    constraint fkt_d_deal_status_type
        foreign key (d_deal_status_type) references deal_status_type (code),
    constraint fkt_d_enable_electronic_transaction
        foreign key (d_enable_electronic_transaction) references yes_no_unknown_type (code),
    constraint fkt_d_gse_version_type
        foreign key (d_gse_version_type) references gse_version_type (code),
    constraint fkt_d_hmda_action_type
        foreign key (d_hmda_action_type) references hmda_action_type (code),
    constraint fkt_d_hmda_denial_reason_type_1
        foreign key (d_hmda_denial_reason_type_1) references hmda_denial_reason_type (code),
    constraint fkt_d_hmda_denial_reason_type_2
        foreign key (d_hmda_denial_reason_type_2) references hmda_denial_reason_type (code),
    constraint fkt_d_hmda_denial_reason_type_3
        foreign key (d_hmda_denial_reason_type_3) references hmda_denial_reason_type (code),
    constraint fkt_d_hmda_denial_reason_type_4
        foreign key (d_hmda_denial_reason_type_4) references hmda_denial_reason_type (code),
    constraint fkt_d_realty_agent_scenario_type
        foreign key (d_realty_agent_scenario_type) references realty_agent_scenario_type (code)
);

create table appraisal
(
    apr_pid bigint auto_increment
        primary key,
    apr_version int not null,
    apr_appraised_value_amount bigint(15) not null,
    apr_effective_date date null,
    apr_deal_pid bigint not null,
    apr_decision_appraisal bit null,
    apr_appraisal_condition_type varchar(128) not null,
    apr_appraiser_address_city varchar(128) null,
    apr_appraiser_address_country varchar(128) not null,
    apr_appraiser_address_postal_code varchar(128) null,
    apr_appraiser_address_state varchar(128) null,
    apr_appraiser_address_street1 varchar(128) null,
    apr_appraiser_address_street2 varchar(128) null,
    apr_appraiser_company_name varchar(128) not null,
    apr_appraiser_email varchar(256) null,
    apr_appraiser_fax varchar(32) null,
    apr_appraiser_first_name varchar(32) null,
    apr_appraiser_last_name varchar(32) null,
    apr_appraiser_middle_name varchar(32) null,
    apr_appraiser_mobile_phone varchar(32) null,
    apr_appraiser_name_suffix varchar(32) null,
    apr_appraiser_office_phone varchar(32) null,
    apr_appraiser_office_phone_extension varchar(16) null,
    apr_appraiser_title varchar(128) null,
    apr_appraiser_license_number varchar(128) null,
    apr_appraiser_supervisory_license_number varchar(128) null,
    apr_appraiser_license_state varchar(128) not null,
    apr_appraisal_order_status_type varchar(128) not null,
    apr_appraisal_order_id varchar(32) null,
    apr_appraisal_order_instructions varchar(1024) null,
    apr_property_address_city varchar(128) null,
    apr_property_address_country varchar(128) not null,
    apr_property_address_postal_code varchar(128) null,
    apr_property_address_state varchar(128) null,
    apr_property_address_street1 varchar(128) null,
    apr_property_address_street2 varchar(128) null,
    apr_property_county_name varchar(128) null,
    apr_obtained_from_transfer bit null,
    apr_hud_provided bit null,
    apr_bedroom_count_unit_1 int null,
    apr_bedroom_count_unit_2 int null,
    apr_bedroom_count_unit_3 int null,
    apr_bedroom_count_unit_4 int null,
    apr_bathroom_count_unit_1 int null,
    apr_bathroom_count_unit_2 int null,
    apr_bathroom_count_unit_3 int null,
    apr_bathroom_count_unit_4 int null,
    apr_total_room_count_unit_1 int null,
    apr_total_room_count_unit_2 int null,
    apr_total_room_count_unit_3 int null,
    apr_total_room_count_unit_4 int null,
    apr_gross_living_area_square_feet_unit_1 int null,
    apr_gross_living_area_square_feet_unit_2 int null,
    apr_gross_living_area_square_feet_unit_3 int null,
    apr_gross_living_area_square_feet_unit_4 int null,
    apr_appraisal_underwriter_type varchar(128) not null,
    apr_ucdp_doc_file_id varchar(10) null,
    apr_inspection_date date null,
    apr_appraisal_reference_id varchar(32) null,
    apr_ucdp_ssr_id varchar(16) null,
    apr_sale_price_amount decimal(15) not null,
    apr_property_tax_id varchar(128) not null,
    apr_property_category_type varchar(128) not null,
    apr_cost_to_build_new decimal(15) not null,
    apr_monthly_hoa_amount decimal(15,2) not null,
    apr_structure_built_year int null,
    apr_structure_built_month int null,
    apr_project_name varchar(128) null,
    apr_road_type varchar(128) not null,
    apr_water_type varchar(128) not null,
    apr_sanitation_type varchar(128) not null,
    apr_neighborhood_location_type varchar(128) null,
    apr_site_area decimal(15) not null,
    apr_due_date date null,
    apr_order_date date null,
    apr_payment_type varchar(128) not null,
    apr_payment_received_date date null,
    apr_appraisal_source_type varchar(128) not null,
    apr_appraisal_purpose_type varchar(128) not null,
    apr_exclude bit null,
    apr_order_appraisal varchar(128) not null,
    apr_appraisal_id int not null,
    apr_mortgage_type varchar(128) not null,
    apr_remaining_economic_life_years int null,
    apr_deficient_economic_life_explanation varchar(1024) null,
    apr_hve_point_value_estimate_amount decimal(15,2) null,
    apr_hve_forecast_standard_deviation_percent decimal(11,9) null,
    apr_hve_confidence_level_type varchar(128) not null,
    apr_hve_variance_percent decimal(11,9) null,
    apr_hve_excessive_value_message varchar(1024) null,
    apr_cu_risk_score decimal(10,2) null,
    apr_license_expiration_date date null,
    apr_supervisor_required bit not null,
    apr_supervisory_appraiser_first_name varchar(32) not null,
    apr_supervisory_appraiser_middle_name varchar(32) not null,
    apr_supervisory_appraiser_last_name varchar(32) not null,
    apr_supervisory_appraiser_name_suffix varchar(32) not null,
    apr_supervisory_license_state varchar(128) not null,
    apr_supervisory_license_expiration_date date null,
    apr_synthetic_unique bit null,
    constraint uk_appraisal_1
        unique (apr_deal_pid, apr_appraisal_id),
    constraint uk_appraisal_2
        unique (apr_deal_pid, apr_synthetic_unique),
    constraint fk_appraisal_1
        foreign key (apr_deal_pid) references deal (d_pid),
    constraint fk_apr_hve_confidence_level_type
        foreign key (apr_hve_confidence_level_type) references hve_confidence_level_type (code),
    constraint fkt_apr_appraisal_condition_type
        foreign key (apr_appraisal_condition_type) references appraisal_condition_type (code),
    constraint fkt_apr_appraisal_order_status_type
        foreign key (apr_appraisal_order_status_type) references appraisal_order_status_type (code),
    constraint fkt_apr_appraisal_purpose_type
        foreign key (apr_appraisal_purpose_type) references appraisal_purpose_type (code),
    constraint fkt_apr_appraisal_source_type
        foreign key (apr_appraisal_source_type) references appraisal_source_type (code),
    constraint fkt_apr_appraisal_underwriter_type
        foreign key (apr_appraisal_underwriter_type) references appraisal_underwriter_type (code),
    constraint fkt_apr_appraiser_address_country
        foreign key (apr_appraiser_address_country) references country_type (code),
    constraint fkt_apr_mortgage_type
        foreign key (apr_mortgage_type) references mortgage_type (code),
    constraint fkt_apr_neighborhood_location_type
        foreign key (apr_neighborhood_location_type) references neighborhood_location_type (code),
    constraint fkt_apr_order_appraisal
        foreign key (apr_order_appraisal) references yes_no_unknown_type (code),
    constraint fkt_apr_payment_type
        foreign key (apr_payment_type) references payment_type (code),
    constraint fkt_apr_property_address_country
        foreign key (apr_property_address_country) references country_type (code),
    constraint fkt_apr_property_category_type
        foreign key (apr_property_category_type) references property_category_type (code),
    constraint fkt_apr_road_type
        foreign key (apr_road_type) references road_type (code),
    constraint fkt_apr_sanitation_type
        foreign key (apr_sanitation_type) references sanitation_type (code),
    constraint fkt_apr_water_type
        foreign key (apr_water_type) references water_type (code)
);

create table appraisal_form
(
    aprfm_pid bigint auto_increment
        primary key,
    aprfm_version int not null,
    aprfm_appraisal_pid bigint not null,
    aprfm_appraisal_source_type varchar(128) not null,
    aprfm_appraisal_form_type varchar(128) not null,
    constraint uk_appraisal_form_1
        unique (aprfm_appraisal_pid, aprfm_appraisal_form_type),
    constraint fk_appraisal_form_1
        foreign key (aprfm_appraisal_pid) references appraisal (apr_pid),
    constraint fkt_aprfm_appraisal_form_type
        foreign key (aprfm_appraisal_form_type) references appraisal_form_type (code),
    constraint fkt_aprfm_appraisal_source_type
        foreign key (aprfm_appraisal_source_type) references appraisal_source_type (code)
);

create table appraisal_id_ticker
(
    aprtk_pid bigint auto_increment
        primary key,
    aprtk_version int not null,
    aprtk_deal_pid bigint not null,
    aprtk_next_id int not null,
    constraint fk_appraisal_id_ticker_1
        foreign key (aprtk_deal_pid) references deal (d_pid)
);

create index idx_deal_1
    on deal (d_external_loan_id_main);

create index idx_deal_2
    on deal (d_external_loan_id_piggyback);

create index idx_deal_4
    on deal (d_deal_create_date);

create index idx_deal_5
    on deal (d_hmda_action_date);

create index idx_deal_6
    on deal (d_disclosure_mode_date);

create table deal_appraisal
(
    dappr_pid bigint auto_increment
        primary key,
    dappr_version int not null,
    dappr_deal_pid bigint not null,
    dappr_door_lock_combination bit not null,
    dappr_appraisal_entry_contact_type varchar(128) not null,
    dappr_appraisal_hold_type varchar(128) not null,
    dappr_appraisal_hold_reason_type varchar(128) not null,
    dappr_hold_release_date date null,
    dappr_rush_request bit not null,
    dappr_transfer_specified bit not null,
    dappr_calculated_appraisal_required bit not null,
    dappr_override_calculated_appraisal_required bit not null,
    dappr_override_calculated_appraisal_required_reason varchar(16000) not null,
    dappr_borrower_requires_appraisal varchar(128) not null,
    dappr_lender_requires_appraisal bit not null,
    dappr_product_requires_appraisal bit not null,
    dappr_appraisal_required bit not null,
    constraint fk_deal_appraisal_1
        foreign key (dappr_deal_pid) references deal (d_pid),
    constraint fkt_dappr_appraisal_entry_contact_type
        foreign key (dappr_appraisal_entry_contact_type) references appraisal_entry_contact_type (code),
    constraint fkt_dappr_appraisal_hold_reason_type
        foreign key (dappr_appraisal_hold_reason_type) references appraisal_hold_reason_type (code),
    constraint fkt_dappr_appraisal_hold_type
        foreign key (dappr_appraisal_hold_type) references appraisal_hold_type (code),
    constraint fkt_dappr_borrower_requires_appraisal
        foreign key (dappr_borrower_requires_appraisal) references yes_no_unknown_type (code)
);

create table deal_contact
(
    dc_pid bigint auto_increment
        primary key,
    dc_version int not null,
    dc_address_city varchar(128) null,
    dc_address_country varchar(128) not null,
    dc_address_postal_code varchar(128) null,
    dc_address_state varchar(128) null,
    dc_address_street1 varchar(128) null,
    dc_address_street2 varchar(128) null,
    dc_company_name varchar(128) not null,
    dc_deal_pid bigint not null,
    dc_email varchar(256) null,
    dc_fax varchar(32) null,
    dc_first_name varchar(32) null,
    dc_last_name varchar(32) null,
    dc_middle_name varchar(32) null,
    dc_mobile_phone varchar(32) null,
    dc_name_suffix varchar(32) null,
    dc_office_phone varchar(32) null,
    dc_office_phone_extension varchar(16) null,
    dc_role_type varchar(128) not null,
    dc_title varchar(128) null,
    constraint fk_deal_contact_1
        foreign key (dc_deal_pid) references deal (d_pid),
    constraint fkt_dc_address_country
        foreign key (dc_address_country) references country_type (code),
    constraint fkt_dc_role_type
        foreign key (dc_role_type) references deal_contact_role_type (code)
);

create table deal_disaster_declaration
(
    ddd_pid bigint auto_increment
        primary key,
    ddd_version int not null,
    ddd_deal_pid bigint not null,
    ddd_disaster_declaration_pid bigint not null,
    constraint uk_deal_disaster_declaration_1
        unique (ddd_deal_pid, ddd_disaster_declaration_pid),
    constraint fk_deal_disaster_declaration_1
        foreign key (ddd_deal_pid) references deal (d_pid),
    constraint fk_deal_disaster_declaration_2
        foreign key (ddd_disaster_declaration_pid) references disaster_declaration (dd_pid)
);

create table deal_du
(
    ddu_pid bigint auto_increment
        primary key,
    ddu_version int not null,
    ddu_deal_pid bigint not null,
    ddu_du_casefile_id varchar(32) not null,
    ddu_du_institution_id varchar(16) not null,
    constraint uk_deal_du_1
        unique (ddu_deal_pid),
    constraint fk_deal_du_1
        foreign key (ddu_deal_pid) references deal (d_pid)
);

create table deal_event
(
    de_pid bigint auto_increment
        primary key,
    de_version int not null,
    de_create_datetime datetime not null,
    de_deal_event_type varchar(128) not null,
    de_deal_pid bigint not null,
    de_deal_task_pid bigint null,
    de_deal_note_pid bigint null,
    de_deal_message_log_pid bigint null,
    de_proposal_doc_pid bigint null,
    de_proposal_doc_file_pid bigint null,
    de_wf_deal_step_pid bigint null,
    de_proposal_pid bigint null,
    de_detail varchar(16000) null,
    de_source_unparsed_name varchar(128) null,
    de_coarse_event_type varchar(128) not null,
    de_borrower_text varchar(1024) null,
    de_create_nanoseconds int null,
    constraint fk_deal_event_1
        foreign key (de_deal_pid) references deal (d_pid),
    constraint fkt_de_coarse_event_type
        foreign key (de_coarse_event_type) references coarse_event_type (code),
    constraint fkt_de_deal_event_type
        foreign key (de_deal_event_type) references deal_event_type (code)
);

create index idx_deal_event_1
    on deal_event (de_create_datetime);

create index idx_deal_event_2
    on deal_event (de_deal_pid, de_coarse_event_type, de_create_datetime);

create index idx_deal_event_3
    on deal_event (de_deal_task_pid);

create index idx_deal_event_4
    on deal_event (de_deal_note_pid);

create index idx_deal_event_5
    on deal_event (de_deal_message_log_pid);

create index idx_deal_event_6
    on deal_event (de_proposal_doc_pid);

create index idx_deal_event_7
    on deal_event (de_proposal_doc_file_pid);

create index idx_deal_event_8
    on deal_event (de_wf_deal_step_pid);

create index idx_deal_event_9
    on deal_event (de_proposal_pid);

create table deal_housing_counselors_request
(
    dhcr_pid bigint auto_increment
        primary key,
    dhcr_version int not null,
    dhcr_deal_pid bigint not null,
    dhcr_centroid_address_street1 varchar(128) not null,
    dhcr_centroid_address_street2 varchar(128) not null,
    dhcr_centroid_address_city varchar(128) not null,
    dhcr_centroid_address_state varchar(128) not null,
    dhcr_centroid_address_postal_code varchar(128) not null,
    dhcr_centroid_address_country varchar(128) not null,
    dhcr_error_messages text not null,
    constraint uk_deal_housing_counselors_request_1
        unique (dhcr_deal_pid),
    constraint fk_deal_housing_counselors_request_1
        foreign key (dhcr_deal_pid) references deal (d_pid),
    constraint fkt_dhcr_centroid_address_country
        foreign key (dhcr_centroid_address_country) references country_type (code)
);

create table deal_housing_counselor_candidate
(
    dhcc_pid bigint auto_increment
        primary key,
    dhcc_version int not null,
    dhcc_deal_pid bigint not null,
    dhcc_deal_housing_counselors_request_pid bigint null,
    dhcc_counseling_agency_id varchar(16) null,
    dhcc_office_name varchar(256) null,
    dhcc_office_address_street1 varchar(128) not null,
    dhcc_office_address_street2 varchar(128) not null,
    dhcc_office_address_city varchar(128) not null,
    dhcc_office_address_state varchar(128) not null,
    dhcc_office_address_postal_code varchar(128) not null,
    dhcc_office_address_country varchar(128) not null,
    dhcc_office_email varchar(256) null,
    dhcc_office_fax varchar(32) null,
    dhcc_office_phone1 varchar(32) null,
    dhcc_office_phone2 varchar(32) null,
    dhcc_mailing_address_street1 varchar(128) not null,
    dhcc_mailing_address_street2 varchar(128) not null,
    dhcc_mailing_address_city varchar(128) not null,
    dhcc_mailing_address_state varchar(128) not null,
    dhcc_mailing_address_postal_code varchar(128) not null,
    dhcc_mailing_address_country varchar(128) not null,
    dhcc_web_url varchar(256) null,
    dhcc_language_codes varchar(256) null,
    dhcc_address_latitude decimal(15,3) not null,
    dhcc_address_longitude decimal(15,3) not null,
    dhcc_service_codes varchar(1500) null,
    dhcc_county_name varchar(128) null,
    dhcc_faith_based bit null,
    dhcc_migrant_workers bit null,
    dhcc_colonias bit null,
    dhcc_parent_org_id varchar(16) null,
    dhcc_ordinal int null,
    constraint fk_deal_housing_counselor_candidate_1
        foreign key (dhcc_deal_pid) references deal (d_pid),
    constraint fk_deal_housing_counselor_candidate_2
        foreign key (dhcc_deal_housing_counselors_request_pid) references deal_housing_counselors_request (dhcr_pid),
    constraint fkt_dhcc_mailing_address_country
        foreign key (dhcc_mailing_address_country) references country_type (code),
    constraint fkt_dhcc_office_address_country
        foreign key (dhcc_office_address_country) references country_type (code)
);

create table deal_invoice
(
    di_pid bigint auto_increment
        primary key,
    di_version int not null,
    di_deal_pid bigint not null,
    di_create_datetime datetime not null,
    di_invoice_amount decimal(15,2) not null,
    di_refund_amount decimal(15,2) not null,
    di_smart_invoice bit not null,
    di_invoice_status_type varchar(128) not null,
    di_description varchar(256) not null,
    di_internal_notes varchar(1024) not null,
    constraint fk_deal_invoice_1
        foreign key (di_deal_pid) references deal (d_pid),
    constraint fkt_di_invoice_status_type
        foreign key (di_invoice_status_type) references deal_invoice_status_type (code)
);

create table deal_invoice_item
(
    dii_pid bigint auto_increment
        primary key,
    dii_version int not null,
    dii_deal_invoice_pid bigint not null,
    dii_charge_type varchar(128) not null,
    dii_item_amount decimal(15,2) not null,
    dii_smart_item bit not null,
    dii_adjustment bit not null,
    constraint uk_deal_invoice_item_1
        unique (dii_deal_invoice_pid, dii_charge_type),
    constraint fk_deal_invoice_item_1
        foreign key (dii_deal_invoice_pid) references deal_invoice (di_pid),
    constraint fkt_dii_charge_type
        foreign key (dii_charge_type) references charge_type (code)
);

create table deal_lender_user_event
(
    dlue_pid bigint auto_increment
        primary key,
    dlue_version int not null,
    dlue_deal_pid bigint not null,
    dlue_subject_lender_user_pid bigint not null,
    dlue_role_pid bigint not null,
    dlue_create_datetime datetime not null,
    dlue_unparsed_text varchar(1024) null,
    constraint fk_deal_lender_user_event_1
        foreign key (dlue_deal_pid) references deal (d_pid)
);

create index idx_deal_lender_user_event_1
    on deal_lender_user_event (dlue_subject_lender_user_pid);

create index idx_deal_lender_user_event_2
    on deal_lender_user_event (dlue_role_pid);

create table deal_lp
(
    dlp_pid bigint auto_increment
        primary key,
    dlp_version int not null,
    dlp_deal_pid bigint not null,
    dlp_lp_loan_id varchar(32) not null,
    dlp_lp_key_id varchar(32) not null,
    constraint uk_deal_lp_1
        unique (dlp_deal_pid),
    constraint fk_deal_lp_1
        foreign key (dlp_deal_pid) references deal (d_pid)
);

create table deal_performer_team
(
    dptm_pid bigint auto_increment
        primary key,
    dptm_version int not null,
    dptm_deal_pid bigint not null,
    dptm_performer_team_pid bigint not null,
    constraint dptm_deal_pid
        unique (dptm_deal_pid, dptm_performer_team_pid),
    constraint fk_deal_performer_team_1
        foreign key (dptm_deal_pid) references deal (d_pid),
    constraint fk_deal_performer_team_2
        foreign key (dptm_performer_team_pid) references performer_team (ptm_pid)
);

create table deal_real_estate_agent
(
    drea_pid bigint auto_increment
        primary key,
    drea_version int not null,
    drea_deal_pid bigint not null,
    drea_first_name varchar(32) null,
    drea_middle_name varchar(32) null,
    drea_last_name varchar(32) null,
    drea_name_suffix varchar(32) null,
    drea_company_name varchar(128) null,
    drea_title varchar(128) null,
    drea_office_phone varchar(32) null,
    drea_office_phone_extension varchar(16) null,
    drea_mobile_phone varchar(32) null,
    drea_email varchar(256) null,
    drea_fax varchar(32) null,
    drea_street_1 varchar(128) null,
    drea_street_2 varchar(128) null,
    drea_city varchar(128) null,
    drea_state varchar(128) null,
    drea_country varchar(128) not null,
    drea_postal_code varchar(128) null,
    drea_state_license_id varchar(128) null,
    drea_company_state_license_id varchar(128) null,
    drea_agency_type varchar(128) not null,
    constraint uk_deal_real_estate_agent_1
        unique (drea_deal_pid, drea_agency_type),
    constraint fk_deal_real_estate_agent_1
        foreign key (drea_deal_pid) references deal (d_pid),
    constraint fkt_drea_agency_type
        foreign key (drea_agency_type) references agency_type (code),
    constraint fkt_drea_country
        foreign key (drea_country) references country_type (code)
);

create table deal_settlement
(
    dsmt_pid bigint auto_increment
        primary key,
    dsmt_version int not null,
    dsmt_account_pid bigint not null,
    dsmt_deal_pid bigint not null,
    dsmt_borrower_elected_preferred_settlement varchar(128) not null,
    dsmt_settlement_agent_escrow_id varchar(32) null,
    dsmt_title_company_reference_id varchar(32) null,
    dsmt_settlement_agent_pid bigint null,
    dsmt_settlement_agent_office_pid bigint null,
    dsmt_settlement_agent_wire_pid bigint null,
    dsmt_settlement_agent_first_name varchar(128) null,
    dsmt_settlement_agent_last_name varchar(128) null,
    dsmt_settlement_agent_phone varchar(32) null,
    dsmt_settlement_agent_phone_extension varchar(16) null,
    dsmt_settlement_agent_email varchar(256) null,
    dsmt_settlement_agent_contact_license_id varchar(128) null,
    dsmt_settlement_agent_preferred_vendor bit null,
    dsmt_for_further_credit varchar(128) null,
    dsmt_beneficiary_for_further_credit varchar(128) not null,
    dsmt_title_company_pid bigint null,
    dsmt_title_company_office_pid bigint null,
    dsmt_title_company_first_name varchar(128) null,
    dsmt_title_company_last_name varchar(128) null,
    dsmt_title_company_phone varchar(32) null,
    dsmt_title_company_phone_extension varchar(16) null,
    dsmt_title_company_email varchar(256) null,
    dsmt_title_company_contact_license_id varchar(128) not null,
    dsmt_title_company_preferred_vendor bit null,
    dsmt_title_insurance_underwriter_company_name varchar(128) not null,
    dsmt_title_insurance_attorney_first_name varchar(32) not null,
    dsmt_title_insurance_attorney_middle_name varchar(32) not null,
    dsmt_title_insurance_attorney_last_name varchar(32) not null,
    dsmt_title_insurance_attorney_name_suffix varchar(32) not null,
    dsmt_title_insurance_attorney_license_number varchar(32) not null,
    constraint fk_deal_settlement_1
        foreign key (dsmt_account_pid) references account (a_pid),
    constraint fk_deal_settlement_2
        foreign key (dsmt_deal_pid) references deal (d_pid),
    constraint fk_deal_settlement_3
        foreign key (dsmt_settlement_agent_pid) references settlement_agent (sa_pid),
    constraint fk_deal_settlement_4
        foreign key (dsmt_settlement_agent_office_pid) references settlement_agent_office (sao_pid),
    constraint fk_deal_settlement_5
        foreign key (dsmt_settlement_agent_wire_pid) references settlement_agent_wire (saw_pid),
    constraint fk_deal_settlement_6
        foreign key (dsmt_title_company_pid) references title_company (tc_pid),
    constraint fk_deal_settlement_7
        foreign key (dsmt_title_company_office_pid) references title_company_office (tco_pid),
    constraint fkt_dsmt_borrower_elected_preferred_settlement
        foreign key (dsmt_borrower_elected_preferred_settlement) references yes_no_unknown_type (code)
);

create index idx_deal_settlement_1
    on deal_settlement (dsmt_settlement_agent_escrow_id);

create table deal_signer
(
    dsi_pid bigint auto_increment
        primary key,
    dsi_version int not null,
    dsi_deal_pid bigint not null,
    dsi_email varchar(256) not null,
    dsi_first_name varchar(32) null,
    dsi_middle_name varchar(32) null,
    dsi_last_name varchar(32) not null,
    dsi_name_suffix varchar(32) null,
    dsi_signer_id varchar(256) not null,
    constraint uk_deal_signer_1
        unique (dsi_deal_pid, dsi_signer_id),
    constraint fk_deal_signer_1
        foreign key (dsi_deal_pid) references deal (d_pid)
);

create index idx_deal_signer_1
    on deal_signer (dsi_signer_id);

create table deal_stage
(
    dst_pid bigint auto_increment
        primary key,
    dst_version int not null,
    dst_deal_pid bigint not null,
    dst_deal_stage_type varchar(128) not null,
    dst_from_date date not null,
    dst_from_datetime datetime not null,
    dst_through_date date null,
    dst_through_datetime datetime null,
    dst_duration_seconds bigint not null,
    dst_business_hours_duration_seconds bigint not null,
    constraint fk_deal_stage_1
        foreign key (dst_deal_pid) references deal (d_pid),
    constraint fkt_dst_deal_stage_type
        foreign key (dst_deal_stage_type) references deal_stage_type (code)
);

create table deal_summary
(
    ds_pid bigint auto_increment
        primary key,
    ds_version int not null,
    ds_deal_pid bigint not null,
    ds_lender_lock_expiration_datetime_main datetime null,
    ds_lender_lock_expiration_datetime_piggyback datetime null,
    ds_lender_lock_status_type_main varchar(128) not null,
    ds_lender_lock_status_type_piggyback varchar(128) not null,
    ds_decision_appraisal_condition_type varchar(128) not null,
    ds_funding_status_type_main varchar(128) not null,
    ds_funding_status_type_piggyback varchar(128) not null,
    ds_purchase_advice_date_main date null,
    ds_purchase_advice_date_piggyback date null,
    ds_last_wf_phase_number int not null,
    ds_last_wf_phase_name varchar(128) not null,
    ds_eligible_investor_ids_main varchar(16000) null,
    ds_eligible_investor_ids_piggyback varchar(16000) null,
    ds_decision_appraisal_cu_risk_score decimal(10,2) null,
    ds_deal_stage_type varchar(128) not null,
    ds_deal_stage_from_datetime datetime not null,
    ds_funded_main bit not null,
    ds_funded_piggyback bit not null,
    ds_most_recent_user_update_date date not null,
    ds_lock_vintage_date_main date null,
    ds_lock_vintage_date_piggyback date null,
    ds_lender_lock_datetime_main datetime null,
    ds_lender_lock_datetime_piggyback datetime null,
    ds_any_unrequested_packages bit not null,
    constraint uk_deal_summary_1
        unique (ds_deal_pid),
    constraint fk_deal_summary_1
        foreign key (ds_deal_pid) references deal (d_pid),
    constraint fkt_ds_deal_stage_type
        foreign key (ds_deal_stage_type) references deal_stage_type (code),
    constraint fkt_ds_decision_appraisal_condition_type
        foreign key (ds_decision_appraisal_condition_type) references appraisal_condition_type (code),
    constraint fkt_ds_funding_status_type_main
        foreign key (ds_funding_status_type_main) references funding_status_type (code),
    constraint fkt_ds_funding_status_type_piggyback
        foreign key (ds_funding_status_type_piggyback) references funding_status_type (code),
    constraint fkt_ds_lender_lock_status_type_main
        foreign key (ds_lender_lock_status_type_main) references lender_lock_status_type (code),
    constraint fkt_ds_lender_lock_status_type_piggyback
        foreign key (ds_lender_lock_status_type_piggyback) references lender_lock_status_type (code)
);

create table investor_lock_extension_setting
(
    iles_pid bigint auto_increment
        primary key,
    iles_version int not null,
    iles_investor_pid bigint not null,
    iles_from_date date null,
    iles_through_date date null,
    iles_extension_days int null,
    iles_price_adjustment_percent decimal(11,9) not null,
    iles_auto_confirm bit null,
    constraint fk_investor_lock_extension_setting_1
        foreign key (iles_investor_pid) references investor (i_pid)
);

create table `lead`
(
    ld_pid bigint auto_increment
    primary key,
    ld_version int not null,
    ld_deal_pid bigint not null,
    ld_lead_datetime varchar(32) null,
    ld_velocify_campaign_id varchar(32) null,
    ld_velocify_campaign_title varchar(32) null,
    ld_originator_email varchar(256) null,
    ld_customer_service_rep_name varchar(128) null,
    ld_velocify_lead_id varchar(32) null,
    ld_tracking_id varchar(256) null,
    ld_zillow_zq varchar(256) null,
    ld_reference_id varchar(256) null,
    ld_apr_percent varchar(16) null,
    ld_interest_rate varchar(16) null,
    ld_rate_type varchar(32) null,
    ld_fico_score varchar(16) null,
    ld_loan_type varchar(32) null,
    ld_notes varchar(1024) null,
    ld_loan_purpose_type varchar(32) null,
    ld_purchase_price varchar(32) null,
    ld_existing_home_value varchar(32) null,
    ld_loan_amount varchar(32) null,
    ld_property_use varchar(32) null,
    ld_subject_property_street varchar(128) null,
    ld_subject_property_city varchar(128) null,
    ld_subject_property_state varchar(128) null,
    ld_subject_property_postal_code varchar(128) null,
    ld_subject_property_type varchar(32) null,
    ld_borrower_first_name varchar(32) null,
    ld_borrower_last_name varchar(32) null,
    ld_borrower_home_phone varchar(32) null,
    ld_borrower_mobile_phone varchar(32) null,
    ld_borrower_email varchar(256) null,
    ld_borrower_ssn varchar(128) null,
    ld_borrower_birth_date varchar(32) null,
    ld_borrower_residence_street varchar(128) null,
    ld_borrower_residence_city varchar(128) null,
    ld_borrower_residence_state varchar(128) null,
    ld_borrower_residence_postal_code varchar(128) null,
    ld_coborrower_first_name varchar(32) null,
    ld_coborrower_middle_name varchar(32) null,
    ld_coborrower_last_name varchar(32) null,
    ld_coborrower_email varchar(256) null,
    ld_coborrower_ssn varchar(128) null,
    ld_coborrower_birth_date varchar(32) null,
    ld_borrower_current_job_employer_name varchar(128) null,
    ld_borrower_current_job_position varchar(32) null,
    ld_borrower_years_on_job varchar(16) null,
    ld_borrower_gross_monthly_income varchar(32) null,
    constraint uk_lead_1
    unique (ld_deal_pid),
    constraint fk_lead_1
    foreign key (ld_deal_pid) references deal (d_pid)
    );

create table lender_user
(
    lu_pid bigint auto_increment
        primary key,
    lu_version int not null,
    lu_branch_pid bigint null,
    lu_account_owner bit null,
    lu_account_pid bigint not null,
    lu_create_date date not null,
    lu_first_name varchar(32) null,
    lu_last_name varchar(32) null,
    lu_middle_name varchar(32) null,
    lu_name_suffix varchar(32) null,
    lu_company_name varchar(128) not null,
    lu_title varchar(128) null,
    lu_office_phone varchar(32) null,
    lu_office_phone_extension varchar(16) null,
    lu_mobile_phone varchar(32) null,
    lu_email varchar(256) null,
    lu_fax varchar(32) null,
    lu_city varchar(128) null,
    lu_country varchar(128) not null,
    lu_postal_code varchar(128) null,
    lu_state varchar(128) null,
    lu_street1 varchar(128) null,
    lu_street2 varchar(128) null,
    lu_office_phone_use_branch bit null,
    lu_fax_use_branch bit null,
    lu_address_use_branch bit null,
    lu_password varchar(128) not null,
    lu_start_date date null,
    lu_through_date date null,
    lu_time_zone varchar(128) not null,
    lu_unparsed_name varchar(128) not null,
    lu_lender_user_status_type varchar(128) not null,
    lu_username varchar(32) not null,
    lu_nmls_loan_originator_id varchar(16) null,
    lu_fha_chums_id varchar(16) null,
    lu_va_agent_id varchar(32) null,
    lu_search_text varchar(256) null,
    lu_company_user_id varchar(32) null,
    lu_force_password_change bit null,
    lu_last_password_change_date datetime null,
    lu_previous_password_1 varchar(128) null,
    lu_previous_password_2 varchar(128) null,
    lu_previous_password_3 varchar(128) null,
    lu_challenge_question_type varchar(128) not null,
    lu_challenge_question_answer varchar(128) not null,
    lu_allow_external_ip bit null,
    lu_total_workload_cap int null,
    lu_schedule_once_booking_page_id varchar(128) null,
    lu_backup_phone varchar(32) null,
    lu_secret_key varchar(128) null,
    lu_performer_team_pid bigint null,
    lu_esign_only bit not null,
    lu_work_step_start_notices_enabled bit not null,
    lu_smart_app_enabled bit not null,
    lu_default_lead_source_pid bigint null,
    lu_default_credit_bureau_type varchar(128) not null,
    lu_originator_id varchar(32) not null,
    lu_name_qualifier varchar(16) not null,
    lu_training_mode bit not null,
    lu_about_me varchar(2000) not null,
    lu_lender_user_type varchar(128) not null,
    lu_hire_date date null,
    lu_mercury_client_group_pid bigint null,
    lu_nickname varchar(32) not null,
    lu_preferred_first_name varchar(32) not null,
    lu_hub_directory bit not null,
    constraint lu_username
        unique (lu_username),
    constraint uk_lender_user_1
        unique (lu_username),
    constraint uk_lender_user_2
        unique (lu_email),
    constraint fk_lender_user_1
        foreign key (lu_account_pid) references account (a_pid),
    constraint fk_lender_user_2
        foreign key (lu_branch_pid) references branch (br_pid),
    constraint fk_lender_user_3
        foreign key (lu_performer_team_pid) references performer_team (ptm_pid),
    constraint fk_lender_user_4
        foreign key (lu_default_lead_source_pid) references lead_source (lds_pid),
    constraint fk_lender_user_5
        foreign key (lu_mercury_client_group_pid) references mercury_client_group (mcg_pid),
    constraint fkt_lu_challenge_question_type
        foreign key (lu_challenge_question_type) references challenge_question_type (code),
    constraint fkt_lu_country
        foreign key (lu_country) references country_type (code),
    constraint fkt_lu_default_credit_bureau_type
        foreign key (lu_default_credit_bureau_type) references credit_bureau_type (code),
    constraint fkt_lu_lender_user_status_type
        foreign key (lu_lender_user_status_type) references lender_user_status_type (code),
    constraint fkt_lu_lender_user_type
        foreign key (lu_lender_user_type) references lender_user_type (code),
    constraint fkt_lu_time_zone
        foreign key (lu_time_zone) references time_zone_type (code)
);

create table backfill_status
(
    bfs_pid bigint auto_increment
        primary key,
    bfs_version int not null,
    bfs_account_pid bigint not null,
    bfs_batch_id varchar(128) not null,
    bfs_name varchar(128) not null,
    bfs_lender_user_pid bigint not null,
    bfs_submit_datetime datetime null,
    bfs_completed_datetime datetime null,
    bfs_num_loans int not null,
    bfs_backfill_status_type varchar(128) not null,
    bfs_failure_info varchar(16000) not null,
    bfs_raw_header_row varchar(16000) not null,
    constraint fk_backfill_status_1
        foreign key (bfs_account_pid) references account (a_pid),
    constraint fk_backfill_status_2
        foreign key (bfs_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_bfs_backfill_status_type
        foreign key (bfs_backfill_status_type) references backfill_status_type (code)
);

create table backfill_loan_status
(
    bfls_pid bigint auto_increment
        primary key,
    bfls_version int not null,
    bfls_backfill_status_pid bigint not null,
    bfls_los_loan_id varchar(32) not null,
    bfls_started_datetime datetime null,
    bfls_completed_datetime datetime null,
    bfls_backfill_status_type varchar(128) not null,
    bfls_failure_info varchar(16000) not null,
    bfls_raw_loan_row varchar(16000) not null,
    bfls_warning_info varchar(16000) not null,
    constraint fk_backfill_loan_status_1
        foreign key (bfls_backfill_status_pid) references backfill_status (bfs_pid),
    constraint fkt_bfls_backfill_status_type
        foreign key (bfls_backfill_status_type) references backfill_status_type (code)
);

create table bid_pool_note
(
    bpn_pid bigint auto_increment
        primary key,
    bpn_version int not null,
    bpn_bid_pool_pid bigint not null,
    bpn_create_datetime datetime not null,
    bpn_content varchar(16000) null,
    bpn_author_lender_user_pid bigint not null,
    bpn_author_unparsed_name varchar(128) null,
    constraint fk_bid_pool_note_1
        foreign key (bpn_bid_pool_pid) references bid_pool (bp_pid),
    constraint fk_bid_pool_note_2
        foreign key (bpn_author_lender_user_pid) references lender_user (lu_pid)
);

create table bid_pool_note_comment
(
    bpnc_pid bigint auto_increment
        primary key,
    bpnc_version int not null,
    bpnc_bid_pool_note_pid bigint not null,
    bpnc_create_datetime datetime not null,
    bpnc_content varchar(16000) null,
    bpnc_author_lender_user_pid bigint not null,
    bpnc_author_unparsed_name varchar(128) null,
    constraint fk_bid_pool_note_comment_1
        foreign key (bpnc_bid_pool_note_pid) references bid_pool_note (bpn_pid),
    constraint fk_bid_pool_note_comment_2
        foreign key (bpnc_author_lender_user_pid) references lender_user (lu_pid)
);

create table bid_pool_note_monitor
(
    bpnm_pid bigint auto_increment
        primary key,
    bpnm_version int not null,
    bpnm_bid_pool_note_pid bigint not null,
    bpnm_lender_user_pid bigint not null,
    constraint fk_bid_pool_note_monitor_1
        foreign key (bpnm_bid_pool_note_pid) references bid_pool_note (bpn_pid),
    constraint fk_bid_pool_note_monitor_2
        foreign key (bpnm_lender_user_pid) references lender_user (lu_pid)
);

create table branch_account_executive
(
    brae_pid bigint auto_increment
        primary key,
    brae_version int not null,
    brae_branch_pid bigint not null,
    brae_lender_user_pid bigint not null,
    brae_from_date date not null,
    constraint uk_branch_account_executive_1
        unique (brae_branch_pid, brae_from_date),
    constraint fk_branch_account_executive_1
        foreign key (brae_branch_pid) references branch (br_pid),
    constraint fk_branch_account_executive_2
        foreign key (brae_lender_user_pid) references lender_user (lu_pid)
);

create table deal_invoice_payment_method
(
    dipm_pid bigint auto_increment
        primary key,
    dipm_version int not null,
    dipm_deal_invoice_pid bigint not null,
    dipm_payer_type varchar(128) not null,
    dipm_configured_payer_type varchar(128) not null,
    dipm_payer_unparsed_name varchar(128) not null,
    dipm_payment_fulfill_type varchar(128) not null,
    dipm_payment_transfer_los_loan_id_main bigint null,
    dipm_payment_processing_company_type varchar(128) not null,
    dipm_stripe_payment_pid bigint null,
    dipm_stripe_payment_refund_pid bigint null,
    dipm_requester_agent_type varchar(128) not null,
    dipm_requester_lender_user_pid bigint null,
    dipm_requester_unparsed_name varchar(128) not null,
    dipm_payment_submission_type varchar(128) not null,
    dipm_payment_completed_date date null,
    constraint fk_deal_invoice_payment_method_1
        foreign key (dipm_deal_invoice_pid) references deal_invoice (di_pid),
    constraint fk_deal_invoice_payment_method_2
        foreign key (dipm_stripe_payment_pid) references stripe_payment (stpm_pid),
    constraint fk_deal_invoice_payment_method_3
        foreign key (dipm_stripe_payment_refund_pid) references stripe_payment (stpm_pid),
    constraint fk_deal_invoice_payment_method_4
        foreign key (dipm_requester_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_dipm_configured_payer_type
        foreign key (dipm_configured_payer_type) references invoice_payer_type (code),
    constraint fkt_dipm_payer_type
        foreign key (dipm_payer_type) references invoice_payer_type (code),
    constraint fkt_dipm_payment_fulfill_type
        foreign key (dipm_payment_fulfill_type) references payment_fulfill_type (code),
    constraint fkt_dipm_payment_processing_company_type
        foreign key (dipm_payment_processing_company_type) references payment_processing_company_type (code),
    constraint fkt_dipm_payment_submission_type
        foreign key (dipm_payment_submission_type) references invoice_payment_submission_type (code),
    constraint fkt_dipm_requester_agent_type
        foreign key (dipm_requester_agent_type) references agent_type (code)
);

create table deal_key_roles
(
    dkrs_pid bigint auto_increment
        primary key,
    dkrs_version int not null,
    dkrs_deal_pid bigint not null,
    dkrs_originator_lender_user_pid bigint null,
    dkrs_originator_first_name varchar(32) not null,
    dkrs_originator_last_name varchar(32) not null,
    dkrs_originator_middle_name varchar(32) not null,
    dkrs_originator_fmls_basic varchar(128) not null,
    dkrs_originator_nmls_id varchar(16) not null,
    dkrs_supplemental_originator_lender_user_pid bigint null,
    dkrs_supplemental_originator_fmls varchar(128) not null,
    dkrs_account_executive_lender_user_pid bigint null,
    dkrs_account_executive_fmls varchar(128) not null,
    dkrs_investor_conditions_lender_user_pid bigint null,
    dkrs_investor_conditions_fmls varchar(128) not null,
    dkrs_investor_stack_to_investor_lender_user_pid bigint null,
    dkrs_investor_stack_to_investor_fmls varchar(128) not null,
    dkrs_collateral_to_custodian_lender_user_pid bigint null,
    dkrs_collateral_to_custodian_fmls varchar(128) not null,
    dkrs_collateral_to_investor_lender_user_pid bigint null,
    dkrs_collateral_to_investor_fmls varchar(128) not null,
    dkrs_transaction_assistant_lender_user_pid bigint null,
    dkrs_transaction_assistant_fmls varchar(128) not null,
    dkrs_final_documents_to_investor_lender_user_pid bigint null,
    dkrs_final_documents_to_investor_fmls varchar(128) not null,
    dkrs_government_insurance_lender_user_pid bigint null,
    dkrs_government_insurance_fmls varchar(128) not null,
    dkrs_funder_lender_user_pid bigint null,
    dkrs_funder_fmls varchar(128) not null,
    dkrs_processor_lender_user_pid bigint null,
    dkrs_processor_fmls varchar(128) not null,
    dkrs_underwriter_lender_user_pid bigint null,
    dkrs_underwriter_fmls varchar(128) not null,
    dkrs_project_underwriter_lender_user_pid bigint null,
    dkrs_project_underwriter_fmls varchar(128) not null,
    dkrs_closing_doc_specialist_lender_user_pid bigint null,
    dkrs_closing_doc_specialist_fmls varchar(128) not null,
    dkrs_wholesale_client_advocate_lender_user_pid bigint null,
    dkrs_wholesale_client_advocate_fmls varchar(128) not null,
    constraint uk_deal_key_roles_1
        unique (dkrs_deal_pid),
    constraint fk_deal_key_roles_1
        foreign key (dkrs_deal_pid) references deal (d_pid),
    constraint fk_deal_key_roles_10
        foreign key (dkrs_final_documents_to_investor_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_key_roles_11
        foreign key (dkrs_government_insurance_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_key_roles_12
        foreign key (dkrs_funder_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_key_roles_13
        foreign key (dkrs_processor_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_key_roles_14
        foreign key (dkrs_underwriter_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_key_roles_15
        foreign key (dkrs_project_underwriter_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_key_roles_16
        foreign key (dkrs_closing_doc_specialist_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_key_roles_17
        foreign key (dkrs_wholesale_client_advocate_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_key_roles_2
        foreign key (dkrs_originator_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_key_roles_3
        foreign key (dkrs_supplemental_originator_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_key_roles_4
        foreign key (dkrs_account_executive_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_key_roles_5
        foreign key (dkrs_investor_conditions_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_key_roles_6
        foreign key (dkrs_investor_stack_to_investor_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_key_roles_7
        foreign key (dkrs_collateral_to_custodian_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_key_roles_8
        foreign key (dkrs_collateral_to_investor_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_key_roles_9
        foreign key (dkrs_transaction_assistant_lender_user_pid) references lender_user (lu_pid)
);

create table deal_lender_user
(
    dlu_pid bigint auto_increment
        primary key,
    dlu_version int not null,
    dlu_deal_pid bigint not null,
    dlu_lender_user_pid bigint not null,
    dlu_role_pid bigint not null,
    dlu_loan_access_type varchar(128) not null,
    dlu_legacy_role_assignment_type varchar(128) not null,
    dlu_legacy_role_assignment_date date null,
    dlu_synthetic_unique varchar(32) not null,
    constraint uk_deal_lender_user_1
        unique (dlu_deal_pid, dlu_synthetic_unique),
    constraint fk_deal_lender_user_1
        foreign key (dlu_deal_pid) references deal (d_pid),
    constraint fk_deal_lender_user_2
        foreign key (dlu_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_lender_user_3
        foreign key (dlu_role_pid) references role (r_pid),
    constraint fkt_dlu_legacy_role_assignment_type
        foreign key (dlu_legacy_role_assignment_type) references legacy_role_assignment_type (code),
    constraint fkt_dlu_loan_access_type
        foreign key (dlu_loan_access_type) references loan_access_type (code)
);

create index idx_deal_lender_user_1
    on deal_lender_user (dlu_deal_pid, dlu_lender_user_pid);

create table deal_performer_team_user
(
    dptu_pid bigint auto_increment
        primary key,
    dptu_version int not null,
    dptu_deal_pid bigint not null,
    dptu_performer_team_pid bigint not null,
    dptu_user_pid bigint not null,
    constraint uk_deal_performer_team_user_1
        unique (dptu_deal_pid, dptu_performer_team_pid, dptu_user_pid),
    constraint fk_deal_performer_team_user_1
        foreign key (dptu_deal_pid) references deal (d_pid),
    constraint fk_deal_performer_team_user_2
        foreign key (dptu_performer_team_pid) references performer_team (ptm_pid),
    constraint fk_deal_performer_team_user_3
        foreign key (dptu_user_pid) references lender_user (lu_pid)
);

create table dw_export_request
(
    dwer_pid bigint auto_increment
        primary key,
    dwer_version int not null,
    dwer_account_pid bigint not null,
    dwer_create_datetime datetime not null,
    dwer_start_datetime datetime null,
    dwer_end_datetime datetime null,
    dwer_request_status_type varchar(128) not null,
    dwer_request_status_messages text not null,
    dwer_requester_lender_user_pid bigint not null,
    dwer_requester_unparsed_name varchar(128) not null,
    dwer_exported_deal_count int not null,
    dwer_export_id varchar(16) not null,
    constraint fk_dw_export_request_1
        foreign key (dwer_account_pid) references account (a_pid),
    constraint fk_dw_export_request_2
        foreign key (dwer_requester_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_dwer_request_status_type
        foreign key (dwer_request_status_type) references dw_export_request_status_type (code)
);

create table lender_settings
(
    lss_pid bigint auto_increment
        primary key,
    lss_version int not null,
    lss_account_pid bigint not null,
    lss_company_time_zone_type varchar(128) not null,
    lss_va_lender_id varchar(16) not null,
    lss_usda_lender_id varchar(16) not null,
    lss_fha_lender_id varchar(16) not null,
    lss_fha_home_office_branch_pid bigint null,
    lss_fha_sponsor_id varchar(16) not null,
    lss_fha_sponsor_company_name varchar(32) not null,
    lss_fha_sponsor_address_street1 varchar(128) not null,
    lss_fha_sponsor_address_street2 varchar(128) not null,
    lss_fha_sponsor_address_city varchar(128) not null,
    lss_fha_sponsor_address_state varchar(128) not null,
    lss_fha_sponsor_address_postal_code varchar(128) not null,
    lss_fha_sponsor_address_country varchar(128) not null,
    lss_fha_non_supervised_mortgagee bit null,
    lss_fnma_seller_id varchar(16) not null,
    lss_fre_seller_id varchar(16) not null,
    lss_lp_submission_type varchar(128) not null,
    lss_lender_user_email_from varchar(256) not null,
    lss_hmda_contact_pid bigint null,
    lss_hmda_legal_entity_id varchar(20) not null,
    lss_hmda_respondent_id varchar(32) not null,
    lss_hmda_agency_id_type varchar(128) not null,
    lss_prequalification_program bit null,
    lss_preapproval_program bit null,
    lss_pest_inspector_company_name varchar(128) not null,
    lss_pest_inspector_phone varchar(32) not null,
    lss_pest_inspector_website_url varchar(256) not null,
    lss_pest_inspector_address_street1 varchar(128) not null,
    lss_pest_inspector_address_street2 varchar(128) not null,
    lss_pest_inspector_address_city varchar(128) not null,
    lss_pest_inspector_address_state varchar(128) not null,
    lss_pest_inspector_address_postal_code varchar(128) not null,
    lss_take_application_hours varchar(128) not null,
    lss_originator_title varchar(128) not null,
    lss_default_credit_bureau_type varchar(128) not null,
    lss_sap_minimum_decision_credit_score int null,
    lss_default_standalone_lock_term_setting_pid bigint null,
    lss_default_combo_lock_term_setting_pid bigint null,
    lss_preferred_aus_type varchar(128) not null,
    lss_borrower_quote_filter_pivot_type varchar(128) not null,
    lss_borrower_quote_filter_pivot_lower_count int null,
    lss_borrower_quote_filter_pivot_higher_count int null,
    constraint fk_lender_settings_1
        foreign key (lss_account_pid) references account (a_pid),
    constraint fk_lender_settings_2
        foreign key (lss_fha_home_office_branch_pid) references branch (br_pid),
    constraint fk_lender_settings_3
        foreign key (lss_hmda_contact_pid) references lender_user (lu_pid),
    constraint fk_lender_settings_4
        foreign key (lss_default_standalone_lock_term_setting_pid) references lock_term_setting (lts_pid),
    constraint fk_lender_settings_5
        foreign key (lss_default_combo_lock_term_setting_pid) references lock_term_setting (lts_pid),
    constraint fkt_lss_borrower_quote_filter_pivot_type
        foreign key (lss_borrower_quote_filter_pivot_type) references quote_filter_pivot_type (code),
    constraint fkt_lss_company_time_zone_type
        foreign key (lss_company_time_zone_type) references time_zone_type (code),
    constraint fkt_lss_default_credit_bureau_type
        foreign key (lss_default_credit_bureau_type) references credit_bureau_type (code),
    constraint fkt_lss_fha_sponsor_address_country
        foreign key (lss_fha_sponsor_address_country) references country_type (code),
    constraint fkt_lss_hmda_agency_id_type
        foreign key (lss_hmda_agency_id_type) references hmda_agency_id_type (code),
    constraint fkt_lss_lp_submission_type
        foreign key (lss_lp_submission_type) references lp_submission_type (code),
    constraint fkt_lss_preferred_aus_type
        foreign key (lss_preferred_aus_type) references aus_type (code)
);

create table lender_user_allowed_ip
(
    luip_pid bigint auto_increment
        primary key,
    luip_version int not null,
    luip_lender_user_pid bigint not null,
    luip_status varchar(128) not null,
    luip_ip_address varchar(32) not null,
    luip_request_id varchar(128) null,
    luip_request_expiration_datetime datetime null,
    luip_last_used_datetime datetime null,
    luip_first_used_datetime datetime null,
    constraint fk_lender_user_allowed_ip_1
        foreign key (luip_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_luip_status
        foreign key (luip_status) references lender_user_allowed_ip_status_type (code)
);

create index idx_lender_user_allowed_ip_1
    on lender_user_allowed_ip (luip_lender_user_pid);

create index idx_lender_user_allowed_ip_2
    on lender_user_allowed_ip (luip_request_id);

create index idx_lender_user_allowed_ip_3
    on lender_user_allowed_ip (luip_ip_address);

create table lender_user_deal_visit
(
    ludv_pid bigint auto_increment
        primary key,
    ludv_version int not null,
    ludv_deal_pid bigint not null,
    ludv_lender_user_pid bigint not null,
    ludv_visited_datetime datetime null,
    constraint fk_lender_user_deal_visit_1
        foreign key (ludv_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lender_user_deal_visit_2
        foreign key (ludv_deal_pid) references deal (d_pid)
);

create table lender_user_lead_source
(
    lulds_pid bigint auto_increment
        primary key,
    lulds_version int not null,
    lulds_lender_user_pid bigint not null,
    lulds_lead_source_pid bigint not null,
    constraint uk_lender_user_lead_source_1
        unique (lulds_lender_user_pid, lulds_lead_source_pid),
    constraint fk_lender_user_lead_source_1
        foreign key (lulds_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lender_user_lead_source_2
        foreign key (lulds_lead_source_pid) references lead_source (lds_pid)
);

create table lender_user_license
(
    luml_pid bigint auto_increment
        primary key,
    luml_version int not null,
    luml_lender_user_pid bigint not null,
    luml_license_type varchar(128) not null,
    luml_state_type varchar(128) not null,
    luml_license_number varchar(128) null,
    luml_from_date date not null,
    luml_through_date date not null,
    luml_note varchar(256) null,
    constraint fk_lender_user_license_1
        foreign key (luml_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_luml_license_type
        foreign key (luml_license_type) references license_type (code),
    constraint fkt_luml_state_type
        foreign key (luml_state_type) references state_type (code)
);

create table lender_user_notice
(
    lun_pid bigint auto_increment
        primary key,
    lun_version int not null,
    lun_lender_user_pid bigint not null,
    lun_deal_pid bigint null,
    lun_create_datetime datetime not null,
    lun_lender_user_notice_type varchar(128) not null,
    lun_detail varchar(16000) null,
    lun_source_unparsed_name varchar(128) null,
    constraint fk_lender_user_notice_1
        foreign key (lun_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lender_user_notice_2
        foreign key (lun_deal_pid) references deal (d_pid),
    constraint fkt_lun_lender_user_notice_type
        foreign key (lun_lender_user_notice_type) references lender_user_notice_type (code)
);

create table lender_user_reset_password
(
    lurp_pid bigint auto_increment
        primary key,
    lurp_version int not null,
    lurp_lender_user_pid bigint not null,
    lurp_expire_datetime datetime null,
    lurp_reset_password_id varchar(128) null,
    lurp_lender_user_reset_type varchar(128) not null,
    constraint fk_lender_user_reset_password_1
        foreign key (lurp_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_lurp_lender_user_reset_type
        foreign key (lurp_lender_user_reset_type) references lender_user_reset_type (code)
);

create index idx_lender_user_reset_password_1
    on lender_user_reset_password (lurp_reset_password_id);

create table lender_user_role
(
    lur_pid bigint auto_increment
        primary key,
    lur_version int not null,
    lur_lender_user_pid bigint not null,
    lur_role_pid bigint not null,
    lur_criteria_pid bigint null,
    lur_workload_cap int null,
    lur_daily_cap int null,
    lur_assignment_gap_minutes int null,
    lur_secondary_role bit null,
    lur_subscribe_smart_messages bit not null,
    lur_for_training_only bit not null,
    lur_notes varchar(16000) null,
    lur_queue_type varchar(128) not null,
    lur_queue_datetime datetime null,
    constraint uk_lender_user_role_1
        unique (lur_lender_user_pid, lur_role_pid),
    constraint fk_lender_user_role_1
        foreign key (lur_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lender_user_role_2
        foreign key (lur_role_pid) references role (r_pid),
    constraint fk_lender_user_role_3
        foreign key (lur_criteria_pid) references criteria (cr_pid),
    constraint fkt_lur_queue_type
        foreign key (lur_queue_type) references lender_user_role_queue_type (code)
);

create table exclusive_assignment
(
    ea_pid bigint auto_increment
        primary key,
    ea_version int not null,
    ea_lender_user_role_pid bigint not null,
    ea_criteria_pid bigint not null,
    ea_priority int null,
    ea_name varchar(128) not null,
    constraint ea_lender_user_role_pid
        unique (ea_lender_user_role_pid, ea_name),
    constraint fk_exclusive_assignment_1
        foreign key (ea_lender_user_role_pid) references lender_user_role (lur_pid),
    constraint fk_exclusive_assignment_2
        foreign key (ea_criteria_pid) references criteria (cr_pid)
);

create table lender_user_role_addendum
(
    lura_pid bigint auto_increment
        primary key,
    lura_version int not null,
    lura_lender_user_pid bigint not null,
    lura_lender_user_role_pid bigint not null,
    lura_role_pid bigint not null,
    constraint uk_lender_user_role_addendum_1
        unique (lura_lender_user_role_pid, lura_role_pid),
    constraint fk_lender_user_role_addendum_1
        foreign key (lura_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lender_user_role_addendum_2
        foreign key (lura_lender_user_role_pid) references lender_user_role (lur_pid),
    constraint fk_lender_user_role_addendum_3
        foreign key (lura_role_pid) references role (r_pid)
);

create table lender_user_service_credentials
(
    lusc_pid bigint auto_increment
        primary key,
    lusc_version int not null,
    lusc_lender_user_pid bigint not null,
    lusc_external_entity_type varchar(128) null,
    lusc_username varchar(256) null,
    lusc_password varchar(128) null,
    lusc_password2 varchar(128) null,
    lusc_additional_id varchar(32) null,
    lusc_additional_question bit null,
    constraint fk_lender_user_service_credentials_1
        foreign key (lusc_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_lender_user_service_credentials_1
        foreign key (lusc_external_entity_type) references external_entity_type (code)
);

create table lender_user_sign_on
(
    luso_pid bigint auto_increment
        primary key,
    luso_version int not null,
    luso_lender_user_pid bigint not null,
    luso_last_sign_on_datetime datetime not null,
    constraint uk_lender_user_sign_on_1
        unique (luso_lender_user_pid),
    constraint fk_lender_user_sign_on_1
        foreign key (luso_lender_user_pid) references lender_user (lu_pid)
);

create table lender_user_unavailable
(
    luu_pid bigint auto_increment
        primary key,
    luu_version int not null,
    luu_lender_user_pid bigint not null,
    luu_from_date date not null,
    luu_through_date date not null,
    constraint uk_lender_user_unavailable_1
        unique (luu_lender_user_pid, luu_from_date, luu_through_date),
    constraint fk_lender_user_unavailable_1
        foreign key (luu_lender_user_pid) references lender_user (lu_pid)
);

create table mercury_network_status_request
(
    mnsr_pid bigint auto_increment
        primary key,
    mnsr_version int not null,
    mnsr_deal_pid bigint not null,
    mnsr_mercury_network_order_id varchar(128) not null,
    mnsr_mercury_network_status_type varchar(128) not null,
    mnsr_status_message varchar(16000) not null,
    constraint fk_mercury_network_status_request_1
        foreign key (mnsr_deal_pid) references deal (d_pid),
    constraint fkt_mnsr_mercury_network_status_type
        foreign key (mnsr_mercury_network_status_type) references mercury_network_status_type (code)
);

create table org_division_leader
(
    orgdl_pid bigint auto_increment
        primary key,
    orgdl_version int not null,
    orgdl_lender_user_pid bigint not null,
    orgdl_org_division_pid bigint not null,
    orgdl_from_date date not null,
    orgdl_through_date date null,
    orgdl_org_leader_position_type varchar(128) not null,
    constraint fk_org_division_leader_1
        foreign key (orgdl_lender_user_pid) references lender_user (lu_pid),
    constraint fk_org_division_leader_2
        foreign key (orgdl_org_division_pid) references org_division (orgd_pid),
    constraint fkt_orgdl_org_leader_position_type
        foreign key (orgdl_org_leader_position_type) references org_leader_position_type (code)
);

create table org_group_leader
(
    orggl_pid bigint auto_increment
        primary key,
    orggl_version int not null,
    orggl_lender_user_pid bigint not null,
    orggl_org_group_pid bigint not null,
    orggl_from_date date not null,
    orggl_through_date date null,
    orggl_org_leader_position_type varchar(128) not null,
    constraint fk_org_group_leader_1
        foreign key (orggl_lender_user_pid) references lender_user (lu_pid),
    constraint fk_org_group_leader_2
        foreign key (orggl_org_group_pid) references org_group (orgg_pid),
    constraint fkt_orggl_org_leader_position_type
        foreign key (orggl_org_leader_position_type) references org_leader_position_type (code)
);

create table org_lender_user_terms
(
    orglut_pid bigint auto_increment
        primary key,
    orglut_version int not null,
    orglut_org_team_pid bigint not null,
    orglut_lender_user_pid bigint not null,
    orglut_from_date date not null,
    orglut_through_date date null,
    constraint fk_org_lender_user_terms_1
        foreign key (orglut_org_team_pid) references org_team (orgt_pid),
    constraint fk_org_lender_user_terms_2
        foreign key (orglut_lender_user_pid) references lender_user (lu_pid)
);

create table org_region_leader
(
    orgrl_pid bigint auto_increment
        primary key,
    orgrl_version int not null,
    orgrl_lender_user_pid bigint not null,
    orgrl_org_region_pid bigint not null,
    orgrl_from_date date not null,
    orgrl_through_date date null,
    orgrl_org_leader_position_type varchar(128) not null,
    constraint fk_org_region_leader_1
        foreign key (orgrl_lender_user_pid) references lender_user (lu_pid),
    constraint fk_org_region_leader_2
        foreign key (orgrl_org_region_pid) references org_region (orgr_pid),
    constraint fkt_orgrl_org_leader_position_type
        foreign key (orgrl_org_leader_position_type) references org_leader_position_type (code)
);

create table org_team_leader
(
    orgtl_pid bigint auto_increment
        primary key,
    orgtl_version int not null,
    orgtl_lender_user_pid bigint not null,
    orgtl_org_team_pid bigint not null,
    orgtl_from_date date not null,
    orgtl_through_date date null,
    orgtl_org_leader_position_type varchar(128) not null,
    constraint fk_org_team_leader_1
        foreign key (orgtl_lender_user_pid) references lender_user (lu_pid),
    constraint fk_org_team_leader_2
        foreign key (orgtl_org_team_pid) references org_team (orgt_pid),
    constraint fkt_orgtl_org_leader_position_type
        foreign key (orgtl_org_leader_position_type) references org_leader_position_type (code)
);

create table org_unit_leader
(
    orgul_pid bigint auto_increment
        primary key,
    orgul_version int not null,
    orgul_lender_user_pid bigint not null,
    orgul_org_unit_pid bigint not null,
    orgul_from_date date not null,
    orgul_through_date date null,
    orgul_org_leader_position_type varchar(128) not null,
    constraint fk_org_unit_leader_1
        foreign key (orgul_lender_user_pid) references lender_user (lu_pid),
    constraint fk_org_unit_leader_2
        foreign key (orgul_org_unit_pid) references org_unit (orgu_pid),
    constraint fkt_orgul_org_leader_position_type
        foreign key (orgul_org_leader_position_type) references org_leader_position_type (code)
);

create table performer_assignment
(
    pa_pid bigint auto_increment
        primary key,
    pa_version int not null,
    pa_role_pid bigint not null,
    pa_lender_user_pid bigint not null,
    pa_last_assign_datetime datetime not null,
    constraint uk_performer_assignment_1
        unique (pa_lender_user_pid, pa_role_pid),
    constraint fk_performer_assignment_1
        foreign key (pa_role_pid) references role (r_pid),
    constraint fk_performer_assignment_2
        foreign key (pa_lender_user_pid) references lender_user (lu_pid)
);

create table product
(
    p_pid bigint auto_increment
        primary key,
    p_version int not null,
    p_account_pid bigint not null,
    p_investor_pid bigint not null,
    p_fund_source_type varchar(128) not null,
    p_investor_product_id varchar(32) not null,
    p_investor_product_name varchar(128) null,
    p_from_date date not null,
    p_through_date date null,
    p_fnm_product_name varchar(15) null,
    p_lock_auto_confirm bit null,
    p_description varchar(1024) not null,
    p_product_side_type varchar(128) not null,
    p_parent_product_pid bigint null,
    constraint p_investor_pid
        unique (p_investor_pid, p_investor_product_name),
    constraint p_investor_pid_2
        unique (p_investor_pid, p_investor_product_id),
    constraint fk_product_1
        foreign key (p_account_pid) references account (a_pid),
    constraint fk_product_2
        foreign key (p_investor_pid) references investor (i_pid),
    constraint fk_product_3
        foreign key (p_parent_product_pid) references product (p_pid),
    constraint fkt_p_fund_source_type
        foreign key (p_fund_source_type) references fund_source_type (code),
    constraint fkt_p_product_side_type
        foreign key (p_product_side_type) references product_side_type (code)
);

create table offering_product
(
    ofp_pid bigint auto_increment
        primary key,
    ofp_version int not null,
    ofp_offering_pid bigint not null,
    ofp_product_pid bigint not null,
    ofp_from_date date not null,
    ofp_through_date date null,
    ofp_price_adjustment_percent decimal(11,9) not null,
    constraint ofp_offering_pid
        unique (ofp_offering_pid, ofp_product_pid, ofp_from_date),
    constraint fk_offering_product_1
        foreign key (ofp_offering_pid) references offering (of_pid),
    constraint fk_offering_product_2
        foreign key (ofp_product_pid) references product (p_pid)
);

create table product_add_on
(
    pao_pid bigint auto_increment
        primary key,
    pao_version int not null,
    pao_product_pid bigint not null,
    pao_from_date date not null,
    constraint fk_product_loan_add_on_1
        foreign key (pao_product_pid) references product (p_pid)
);

create table product_add_on_rule
(
    par_pid bigint auto_increment
        primary key,
    par_version int not null,
    par_product_add_on_pid bigint not null,
    par_summary varchar(16000) not null,
    par_note varchar(256) not null,
    par_rate_adjustment_percent decimal(11,9) not null,
    par_investor_price_adjustment_percent decimal(11,9) not null,
    par_account_price_adjustment_percent decimal(11,9) not null,
    par_arm_margin_adjustment_percent decimal(11,9) not null,
    par_loan_purpose_input_type varchar(128) not null,
    par_property_usage_input_type varchar(128) not null,
    par_doc_level_input_type varchar(128) not null,
    par_property_category_input_type varchar(128) not null,
    par_first_time_homebuyer_input_type varchar(128) not null,
    par_self_employed_input_type varchar(128) not null,
    par_amortization_input_type varchar(128) not null,
    par_non_resident_alien_input_type varchar(128) not null,
    par_hazardous_lava_zone_input_type varchar(128) not null,
    par_property_rights_input_type varchar(128) not null,
    par_property_acres_input_type varchar(128) not null,
    par_arms_length_input_type varchar(128) not null,
    par_state_input_type varchar(128) not null,
    par_escrow_waiver_input_type varchar(128) not null,
    par_subordinate_financing_input_type varchar(128) not null,
    par_minimum_credit_score_input bit null,
    par_maximum_credit_score_input bit null,
    par_minimum_loan_amount_input bit null,
    par_maximum_loan_amount_input bit null,
    par_minimum_ltv_ratio_input bit null,
    par_maximum_ltv_ratio_input bit null,
    par_minimum_cltv_ratio_input bit null,
    par_maximum_cltv_ratio_input bit null,
    par_maximum_housing_ratio_input bit null,
    par_minimum_debt_ratio_input bit null,
    par_maximum_debt_ratio_input bit null,
    par_loan_purpose_purchase bit null,
    par_loan_purpose_change_in_rate_term bit null,
    par_loan_purpose_cash_out bit null,
    par_property_usage_primary_residence bit null,
    par_property_usage_second_home bit null,
    par_property_usage_investment bit null,
    par_doc_level_full bit null,
    par_doc_level_lite bit null,
    par_doc_level_limited bit null,
    par_doc_level_streamline_refinance bit null,
    par_property_category_detached bit null,
    par_property_category_attached bit null,
    par_property_category_condo_hotel bit null,
    par_property_category_duplex bit null,
    par_property_category_triplex bit null,
    par_property_category_fourplex bit null,
    par_property_category_commercial_residential bit null,
    par_property_category_condo_1_to_4_story bit null,
    par_property_category_condo_5_over_story bit null,
    par_property_category_manufactured_multi_wide bit null,
    par_property_category_manufactured_single_wide bit null,
    par_property_category_townhouse_rowhouse bit null,
    par_property_category_land_and_lots bit null,
    par_property_category_farm bit null,
    par_first_time_homebuyer bit null,
    par_not_first_time_homebuyer bit null,
    par_self_employed bit null,
    par_not_self_employed bit null,
    par_amortization_fully bit null,
    par_amortization_interest_only bit null,
    par_non_resident_alien bit null,
    par_not_non_resident_alien bit null,
    par_arms_length bit null,
    par_not_arms_length bit null,
    par_hazardous_lava_zone bit null,
    par_not_hazardous_lava_zone bit null,
    par_property_rights_fee_simple bit null,
    par_property_rights_leasehold bit null,
    par_under_10_acres bit null,
    par_not_under_10_acres bit null,
    par_escrow_waiver bit null,
    par_not_escrow_waiver bit null,
    par_subordinate_financing bit null,
    par_not_subordinate_financing bit null,
    par_minimum_credit_score int null,
    par_maximum_credit_score int null,
    par_minimum_loan_amount decimal(15) not null,
    par_maximum_loan_amount decimal(15) not null,
    par_minimum_ltv_ratio_percent decimal(11,9) not null,
    par_maximum_ltv_ratio_percent decimal(11,9) not null,
    par_minimum_cltv_ratio_percent decimal(11,9) not null,
    par_maximum_cltv_ratio_percent decimal(11,9) not null,
    par_maximum_housing_ratio_percent decimal(11,9) not null,
    par_minimum_debt_ratio_percent decimal(11,9) not null,
    par_maximum_debt_ratio_percent decimal(11,9) not null,
    par_state_al bit null,
    par_state_ak bit null,
    par_state_az bit null,
    par_state_ar bit null,
    par_state_ca bit null,
    par_state_co bit null,
    par_state_ct bit null,
    par_state_de bit null,
    par_state_dc bit null,
    par_state_fl bit null,
    par_state_ga bit null,
    par_state_gu bit null,
    par_state_hi bit null,
    par_state_id bit null,
    par_state_il bit null,
    par_state_in bit null,
    par_state_ia bit null,
    par_state_ks bit null,
    par_state_ky bit null,
    par_state_la bit null,
    par_state_me bit null,
    par_state_md bit null,
    par_state_ma bit null,
    par_state_mi bit null,
    par_state_mn bit null,
    par_state_ms bit null,
    par_state_mo bit null,
    par_state_mt bit null,
    par_state_ne bit null,
    par_state_nv bit null,
    par_state_nh bit null,
    par_state_nj bit null,
    par_state_nm bit null,
    par_state_ny bit null,
    par_state_nc bit null,
    par_state_nd bit null,
    par_state_oh bit null,
    par_state_ok bit null,
    par_state_or bit null,
    par_state_pa bit null,
    par_state_pr bit null,
    par_state_ri bit null,
    par_state_sc bit null,
    par_state_sd bit null,
    par_state_tn bit null,
    par_state_tx bit null,
    par_state_ut bit null,
    par_state_vt bit null,
    par_state_va bit null,
    par_state_vi bit null,
    par_state_wa bit null,
    par_state_wv bit null,
    par_state_wi bit null,
    par_state_wy bit null,
    constraint fk_product_loan_add_on_rule_1
        foreign key (par_product_add_on_pid) references product_add_on (pao_pid),
    constraint fkt_par_amortization_input_type
        foreign key (par_amortization_input_type) references product_rule_domain_input_type (code),
    constraint fkt_par_arms_length_input_type
        foreign key (par_arms_length_input_type) references product_rule_domain_input_type (code),
    constraint fkt_par_doc_level_input_type
        foreign key (par_doc_level_input_type) references product_rule_domain_input_type (code),
    constraint fkt_par_escrow_waiver_input_type
        foreign key (par_escrow_waiver_input_type) references product_rule_domain_input_type (code),
    constraint fkt_par_first_time_homebuyer_input_type
        foreign key (par_first_time_homebuyer_input_type) references product_rule_domain_input_type (code),
    constraint fkt_par_hazardous_lava_zone_input_type
        foreign key (par_hazardous_lava_zone_input_type) references product_rule_domain_input_type (code),
    constraint fkt_par_loan_purpose_input_type
        foreign key (par_loan_purpose_input_type) references product_rule_domain_input_type (code),
    constraint fkt_par_non_resident_alien_input_type
        foreign key (par_non_resident_alien_input_type) references product_rule_domain_input_type (code),
    constraint fkt_par_property_acres_input_type
        foreign key (par_property_acres_input_type) references product_rule_domain_input_type (code),
    constraint fkt_par_property_category_input_type
        foreign key (par_property_category_input_type) references product_rule_domain_input_type (code),
    constraint fkt_par_property_rights_input_type
        foreign key (par_property_rights_input_type) references product_rule_domain_input_type (code),
    constraint fkt_par_property_usage_input_type
        foreign key (par_property_usage_input_type) references product_rule_domain_input_type (code),
    constraint fkt_par_self_employed_input_type
        foreign key (par_self_employed_input_type) references product_rule_domain_input_type (code),
    constraint fkt_par_state_input_type
        foreign key (par_state_input_type) references product_rule_domain_input_type (code),
    constraint fkt_par_subordinate_financing_input_type
        foreign key (par_subordinate_financing_input_type) references product_rule_domain_input_type (code)
);

create table product_branch
(
    pbr_pid bigint auto_increment
        primary key,
    pbr_version int not null,
    pbr_product_pid bigint not null,
    pbr_branch_pid bigint not null,
    pbr_from_date date not null,
    pbr_through_date date null,
    pbr_price_adjustment_percent decimal(11,9) not null,
    constraint fk_product_branch_1
        foreign key (pbr_product_pid) references product (p_pid),
    constraint fk_product_branch_2
        foreign key (pbr_branch_pid) references branch (br_pid)
);

create table product_deal_check_exclusion
(
    pdce_pid bigint auto_increment
        primary key,
    pdce_version int not null,
    pdce_product_pid bigint not null,
    pdce_deal_check_type varchar(128) not null,
    constraint fk_product_deal_check_exclusion_1
        foreign key (pdce_product_pid) references product (p_pid),
    constraint fkt_pdce_deal_check_type
        foreign key (pdce_deal_check_type) references deal_check_type (code)
);

create table product_eligibility
(
    pe_pid bigint auto_increment
        primary key,
    pe_version int not null,
    pe_product_pid bigint not null,
    pe_from_date date not null,
    constraint pe_product_pid
        unique (pe_product_pid, pe_from_date),
    constraint fk_product_eligibility_1
        foreign key (pe_product_pid) references product (p_pid)
);

create table product_eligibility_rule
(
    per_pid bigint auto_increment
        primary key,
    per_version int not null,
    per_product_eligibility_pid bigint not null,
    per_summary varchar(16000) not null,
    per_note varchar(256) not null,
    per_group_id int not null,
    per_loan_purpose_input_type varchar(128) not null,
    per_property_usage_input_type varchar(128) not null,
    per_doc_level_input_type varchar(128) not null,
    per_property_category_input_type varchar(128) not null,
    per_first_time_homebuyer_input_type varchar(128) not null,
    per_self_employed_input_type varchar(128) not null,
    per_amortization_input_type varchar(128) not null,
    per_non_resident_alien_input_type varchar(128) not null,
    per_hazardous_lava_zone_input_type varchar(128) not null,
    per_property_rights_input_type varchar(128) not null,
    per_property_acres_input_type varchar(128) not null,
    per_arms_length_input_type varchar(128) not null,
    per_underwrite_accepted_input_type varchar(128) not null,
    per_state_input_type varchar(128) not null,
    per_escrow_waiver_input_type varchar(128) not null,
    per_minimum_credit_score_input bit null,
    per_minimum_loan_amount_input bit null,
    per_maximum_loan_amount_input bit null,
    per_maximum_ltv_ratio_input bit null,
    per_newly_built_maximum_ltv_ratio_input bit null,
    per_subordinate_maximum_ltv_ratio_input bit null,
    per_maximum_cltv_ratio_input bit null,
    per_maximum_housing_ratio_input bit null,
    per_maximum_debt_ratio_input bit null,
    per_lp_risk_assessment_accepted bit null,
    per_du_risk_assessment_accepted bit null,
    per_manual_risk_assessment_accepted bit null,
    per_loan_purpose_purchase bit null,
    per_loan_purpose_change_in_rate_term bit null,
    per_loan_purpose_cash_out bit null,
    per_property_usage_primary_residence bit null,
    per_property_usage_second_home bit null,
    per_property_usage_investment bit null,
    per_doc_level_full bit null,
    per_doc_level_lite bit null,
    per_doc_level_limited bit null,
    per_doc_level_streamline_refinance bit null,
    per_property_category_detached bit null,
    per_property_category_attached bit null,
    per_property_category_condo_hotel bit null,
    per_property_category_duplex bit null,
    per_property_category_triplex bit null,
    per_property_category_fourplex bit null,
    per_property_category_commercial_residential bit null,
    per_property_category_condo_1_to_4_story bit null,
    per_property_category_condo_5_over_story bit null,
    per_property_category_manufactured_multi_wide bit null,
    per_property_category_manufactured_single_wide bit null,
    per_property_category_townhouse_rowhouse bit null,
    per_property_category_land_and_lots bit null,
    per_property_category_farm bit null,
    per_first_time_homebuyer bit null,
    per_not_first_time_homebuyer bit null,
    per_self_employed bit null,
    per_not_self_employed bit null,
    per_amortization_fully bit null,
    per_amortization_interest_only bit null,
    per_non_resident_alien bit null,
    per_not_non_resident_alien bit null,
    per_arms_length bit null,
    per_not_arms_length bit null,
    per_hazardous_lava_zone bit null,
    per_not_hazardous_lava_zone bit null,
    per_property_rights_fee_simple bit null,
    per_property_rights_leasehold bit null,
    per_under_10_acres bit null,
    per_not_under_10_acres bit null,
    per_escrow_waiver bit null,
    per_not_escrow_waiver bit null,
    per_minimum_credit_score int null,
    per_minimum_loan_amount decimal(15) not null,
    per_maximum_loan_amount decimal(15) not null,
    per_maximum_ltv_ratio_percent decimal(11,9) not null,
    per_newly_built_maximum_ltv_ratio_percent decimal(11,9) not null,
    per_subordinate_maximum_ltv_ratio_percent decimal(11,9) not null,
    per_maximum_cltv_ratio_percent decimal(11,9) not null,
    per_maximum_housing_ratio_percent decimal(11,9) not null,
    per_maximum_debt_ratio_percent decimal(11,9) not null,
    per_state_al bit null,
    per_state_ak bit null,
    per_state_az bit null,
    per_state_ar bit null,
    per_state_ca bit null,
    per_state_co bit null,
    per_state_ct bit null,
    per_state_de bit null,
    per_state_dc bit null,
    per_state_fl bit null,
    per_state_ga bit null,
    per_state_gu bit null,
    per_state_hi bit null,
    per_state_id bit null,
    per_state_il bit null,
    per_state_in bit null,
    per_state_ia bit null,
    per_state_ks bit null,
    per_state_ky bit null,
    per_state_la bit null,
    per_state_me bit null,
    per_state_md bit null,
    per_state_ma bit null,
    per_state_mi bit null,
    per_state_mn bit null,
    per_state_ms bit null,
    per_state_mo bit null,
    per_state_mt bit null,
    per_state_ne bit null,
    per_state_nv bit null,
    per_state_nh bit null,
    per_state_nj bit null,
    per_state_nm bit null,
    per_state_ny bit null,
    per_state_nc bit null,
    per_state_nd bit null,
    per_state_oh bit null,
    per_state_ok bit null,
    per_state_or bit null,
    per_state_pa bit null,
    per_state_pr bit null,
    per_state_ri bit null,
    per_state_sc bit null,
    per_state_sd bit null,
    per_state_tn bit null,
    per_state_tx bit null,
    per_state_ut bit null,
    per_state_vt bit null,
    per_state_va bit null,
    per_state_vi bit null,
    per_state_wa bit null,
    per_state_wv bit null,
    per_state_wi bit null,
    per_state_wy bit null,
    constraint fk_product_eligibility_rule_1
        foreign key (per_product_eligibility_pid) references product_eligibility (pe_pid),
    constraint fkt_per_amortization_input_type
        foreign key (per_amortization_input_type) references product_rule_domain_input_type (code),
    constraint fkt_per_arms_length_input_type
        foreign key (per_arms_length_input_type) references product_rule_domain_input_type (code),
    constraint fkt_per_doc_level_input_type
        foreign key (per_doc_level_input_type) references product_rule_domain_input_type (code),
    constraint fkt_per_escrow_waiver_input_type
        foreign key (per_escrow_waiver_input_type) references product_rule_domain_input_type (code),
    constraint fkt_per_first_time_homebuyer_input_type
        foreign key (per_first_time_homebuyer_input_type) references product_rule_domain_input_type (code),
    constraint fkt_per_hazardous_lava_zone_input_type
        foreign key (per_hazardous_lava_zone_input_type) references product_rule_domain_input_type (code),
    constraint fkt_per_loan_purpose_input_type
        foreign key (per_loan_purpose_input_type) references product_rule_domain_input_type (code),
    constraint fkt_per_non_resident_alien_input_type
        foreign key (per_non_resident_alien_input_type) references product_rule_domain_input_type (code),
    constraint fkt_per_property_acres_input_type
        foreign key (per_property_acres_input_type) references product_rule_domain_input_type (code),
    constraint fkt_per_property_category_input_type
        foreign key (per_property_category_input_type) references product_rule_domain_input_type (code),
    constraint fkt_per_property_rights_input_type
        foreign key (per_property_rights_input_type) references product_rule_domain_input_type (code),
    constraint fkt_per_property_usage_input_type
        foreign key (per_property_usage_input_type) references product_rule_domain_input_type (code),
    constraint fkt_per_self_employed_input_type
        foreign key (per_self_employed_input_type) references product_rule_domain_input_type (code),
    constraint fkt_per_state_input_type
        foreign key (per_state_input_type) references product_rule_domain_input_type (code),
    constraint fkt_per_underwrite_accepted_input_type
        foreign key (per_underwrite_accepted_input_type) references product_rule_domain_input_type (code)
);

create table product_lock_term
(
    plt_pid bigint auto_increment
        primary key,
    plt_version int not null,
    plt_product_pid bigint not null,
    plt_lock_term_setting_pid bigint not null,
    plt_from_date date not null,
    plt_through_date date null,
    plt_price_adjustment_percent decimal(11,9) not null,
    constraint plt_product_pid
        unique (plt_product_pid, plt_lock_term_setting_pid, plt_from_date),
    constraint fk_product_lock_term_1
        foreign key (plt_product_pid) references product (p_pid),
    constraint fk_product_lock_term_2
        foreign key (plt_lock_term_setting_pid) references lock_term_setting (lts_pid)
);

create table product_maximum_investor_price
(
    pmip_pid bigint auto_increment
        primary key,
    pmip_version int not null,
    pmip_product_pid bigint not null,
    pmip_from_date date not null,
    pmip_maximum_investor_price_percent decimal(11,9) not null,
    pmip_maximum_includes_srp bit not null,
    pmip_loan_amount_min decimal(15) null,
    pmip_loan_amount_max decimal(15) null,
    constraint pmip_product_pid
        unique (pmip_product_pid, pmip_from_date),
    constraint fk_product_maximum_investor_price_1
        foreign key (pmip_product_pid) references product (p_pid)
);

create table product_maximum_rebate
(
    pmr_pid bigint auto_increment
        primary key,
    pmr_version int not null,
    pmr_product_pid bigint not null,
    pmr_from_date date not null,
    pmr_maximum_rebate_percent decimal(11,9) not null,
    constraint pmr_product_pid
        unique (pmr_product_pid, pmr_from_date),
    constraint fk_product_maximum_rebate_1
        foreign key (pmr_product_pid) references product (p_pid)
);

create table product_minimum_investor_price
(
    pminip_pid bigint auto_increment
        primary key,
    pminip_version int not null,
    pminip_product_pid bigint not null,
    pminip_from_date date not null,
    pminip_minimum_investor_price_percent decimal(11,9) not null,
    pminip_minimum_includes_srp bit not null,
    pminip_loan_amount_min decimal(15) null,
    pminip_loan_amount_max decimal(15) null,
    constraint pminip_product_pid
        unique (pminip_product_pid, pminip_from_date),
    constraint fk_product_minimum_investor_price_1
        foreign key (pminip_product_pid) references product (p_pid)
);

create table product_originator
(
    po_pid bigint auto_increment
        primary key,
    po_version int not null,
    po_product_pid bigint not null,
    po_lender_user_pid bigint not null,
    po_from_date date not null,
    po_through_date date null,
    po_price_adjustment_percent decimal(11,9) not null,
    constraint fk_product_originator_1
        foreign key (po_product_pid) references product (p_pid),
    constraint fk_product_originator_2
        foreign key (po_lender_user_pid) references lender_user (lu_pid)
);

create table product_terms
(
    pt_pid bigint auto_increment
        primary key,
    pt_version int not null,
    pt_amortization_term_months int null,
    pt_arm_index_type varchar(128) not null,
    pt_arm_payment_adjustment_calculation_type varchar(128) not null,
    pt_assumable bit null,
    pt_product_category varchar(128) null,
    pt_conditions_to_assumability bit null,
    pt_demand_feature bit null,
    pt_due_in_term_months int null,
    pt_escrow_cushion_months int null,
    pt_from_date date not null,
    pt_initial_payment_adjustment_term_months int null,
    pt_initial_rate_adjustment_cap_percent decimal(11,9) not null,
    pt_initial_rate_adjustment_term_months int null,
    pt_lien_priority_type varchar(128) not null,
    pt_loan_amortization_type varchar(128) not null,
    pt_minimum_payment_rate_percent decimal(11,9) not null,
    pt_minimum_rate_term_months int null,
    pt_mortgage_type varchar(128) not null,
    pt_negative_amortization_type varchar(128) not null,
    pt_negative_amortization_limit_percent decimal(11,9) not null,
    pt_negative_amortization_recast_period_months int null,
    pt_payment_adjustment_lifetime_cap_percent decimal(11,9) not null,
    pt_payment_adjustment_periodic_cap decimal(11,9) not null,
    pt_payment_frequency_type varchar(128) not null,
    pt_prepayment_finance_charge_refund bit null,
    pt_product_pid bigint not null,
    pt_rate_adjustment_lifetime_cap_percent decimal(11,9) not null,
    pt_subsequent_payment_adjustment_term_months int null,
    pt_subsequent_rate_adjustment_cap_percent decimal(11,9) not null,
    pt_subsequent_rate_adjustment_term_months int null,
    pt_prepay_penalty_type varchar(128) not null,
    pt_lender_hazard_insurance_available bit null,
    pt_lender_hazard_insurance_premium_amount decimal(15,2) not null,
    pt_lender_hazard_insurance_term_months int null,
    pt_loan_requires_hazard_insurance bit null,
    pt_arm_convertible bit null,
    pt_arm_convertible_from_month int null,
    pt_arm_convertible_through_month int null,
    pt_arm_floor_rate_percent decimal(11,9) not null,
    pt_arm_lookback_period_days int null,
    pt_escrow_waiver_allowed bit null,
    pt_days_per_year_type varchar(128) not null,
    pt_lp_risk_assessment_accepted bit null,
    pt_du_risk_assessment_accepted bit null,
    pt_manual_risk_assessment_accepted bit null,
    pt_internal_underwrite_accepted bit null,
    pt_external_fha_underwrite_accepted bit null,
    pt_external_va_underwrite_accepted bit null,
    pt_external_usda_underwrite_accepted bit null,
    pt_external_investor_underwrite_accepted bit null,
    pt_heloc_cancel_fee_applicable_type varchar(128) not null,
    pt_heloc_cancel_fee_period_months int null,
    pt_heloc_cancel_fee_amount decimal(15,2) not null,
    pt_heloc_draw_period_months int null,
    pt_heloc_repayment_period_duration_months int null,
    pt_heloc_maximum_initial_draw bit null,
    pt_heloc_maximum_initial_draw_amount decimal(15) not null,
    pt_heloc_minimum_draw bit null,
    pt_heloc_minimum_draw_amount decimal(15) not null,
    pt_gpm_adjustment_years int null,
    pt_gpm_adjustment_percent decimal(11,9) not null,
    pt_qualifying_monthly_payment_type varchar(128) not null,
    pt_qualifying_rate_type varchar(128) not null,
    pt_qualifying_rate_input_percent decimal(11,9) not null,
    pt_ipc_calc_type varchar(128) not null,
    pt_ipc_limit_percent1 decimal(11,9) not null,
    pt_ipc_property_usage_type1 varchar(128) not null,
    pt_ipc_comparison_operator_type1 varchar(128) not null,
    pt_ipc_cltv_ratio_percent1 decimal(11,9) not null,
    pt_ipc_limit_percent2 decimal(11,9) not null,
    pt_ipc_property_usage_type2 varchar(128) not null,
    pt_ipc_comparison_operator_type2 varchar(128) not null,
    pt_ipc_cltv_ratio_percent2 decimal(11,9) not null,
    pt_ipc_limit_percent3 decimal(11,9) not null,
    pt_ipc_property_usage_type3 varchar(128) not null,
    pt_ipc_comparison_operator_type3 varchar(128) not null,
    pt_ipc_cltv_ratio_percent3 decimal(11,9) not null,
    pt_ipc_limit_percent4 decimal(11,9) not null,
    pt_ipc_property_usage_type4 varchar(128) not null,
    pt_ipc_comparison_operator_type4 varchar(128) not null,
    pt_ipc_cltv_ratio_percent4 decimal(11,9) not null,
    pt_buydown_base_date_type varchar(128) not null,
    pt_buydown_subsidy_calculation_type varchar(128) not null,
    pt_prepaid_interest_rate_type varchar(128) not null,
    pt_fnm_arm_plan_type varchar(128) not null,
    pt_dsi_plan_code varchar(128) null,
    pt_credit_qualifying bit null,
    pt_product_special_program_type varchar(128) not null,
    pt_section_of_act_coarse_type varchar(128) not null,
    pt_fha_rehab_program_type varchar(128) not null,
    pt_fha_special_program_type varchar(128) not null,
    pt_third_party_grant_eligible bit not null,
    pt_servicing_transfer_type varchar(128) not null,
    pt_no_mi_product bit not null,
    pt_mortgage_credit_certificate_eligible bit not null,
    pt_fre_community_program_type varchar(128) not null,
    pt_fnm_community_lending_product_type varchar(128) not null,
    pt_zero_note_rate bit not null,
    pt_third_party_community_second_program_eligibility_type varchar(128) not null,
    pt_texas_veterans_land_board varchar(128) not null,
    pt_security_instrument_page_count int not null,
    pt_deed_page_count int not null,
    pt_partial_payment_policy_type varchar(128) not null,
    pt_payment_structure_type varchar(128) not null,
    pt_deferred_payment_months int not null,
    pt_always_current_market_price bit not null,
    pt_rate_protect bit not null,
    pt_non_conforming bit not null,
    pt_allow_loan_amount_cents bit not null,
    pt_product_appraisal_requirement_type varchar(128) not null,
    pt_family_advantage bit not null,
    pt_community_lending_type varchar(128) not null,
    pt_high_balance varchar(128) not null,
    pt_decision_credit_score_calc_type varchar(128) not null,
    pt_new_york bit not null,
    constraint pt_product_pid
        unique (pt_product_pid, pt_from_date),
    constraint fk_product_terms_1
        foreign key (pt_product_pid) references product (p_pid),
    constraint fkt_pt_arm_index_type
        foreign key (pt_arm_index_type) references arm_index_type (code),
    constraint fkt_pt_arm_payment_adjustment_calculation_type
        foreign key (pt_arm_payment_adjustment_calculation_type) references payment_adjustment_calculation_type (code),
    constraint fkt_pt_buydown_base_date_type
        foreign key (pt_buydown_base_date_type) references buydown_base_date_type (code),
    constraint fkt_pt_buydown_subsidy_calculation_type
        foreign key (pt_buydown_subsidy_calculation_type) references buydown_subsidy_calculation_type (code),
    constraint fkt_pt_community_lending_type
        foreign key (pt_community_lending_type) references community_lending_type (code),
    constraint fkt_pt_days_per_year_type
        foreign key (pt_days_per_year_type) references days_per_year_type (code),
    constraint fkt_pt_decision_credit_score_calc_type
        foreign key (pt_decision_credit_score_calc_type) references decision_credit_score_calc_type (code),
    constraint fkt_pt_fha_rehab_program_type
        foreign key (pt_fha_rehab_program_type) references fha_rehab_program_type (code),
    constraint fkt_pt_fha_special_program_type
        foreign key (pt_fha_special_program_type) references fha_special_program_type (code),
    constraint fkt_pt_fnm_arm_plan_type
        foreign key (pt_fnm_arm_plan_type) references fnm_arm_plan_type (code),
    constraint fkt_pt_fnm_community_lending_product_type
        foreign key (pt_fnm_community_lending_product_type) references fnm_community_lending_product_type (code),
    constraint fkt_pt_fre_community_program_type
        foreign key (pt_fre_community_program_type) references fre_community_program_type (code),
    constraint fkt_pt_heloc_cancel_fee_applicable_type
        foreign key (pt_heloc_cancel_fee_applicable_type) references heloc_cancel_fee_applicable_type (code),
    constraint fkt_pt_high_balance_temp
        foreign key (pt_high_balance) references yes_no_na_unknown_type (code),
    constraint fkt_pt_ipc_calc_type
        foreign key (pt_ipc_calc_type) references ipc_calc_type (code),
    constraint fkt_pt_ipc_comparison_operator_type1
        foreign key (pt_ipc_comparison_operator_type1) references ipc_comparison_operator_type (code),
    constraint fkt_pt_ipc_comparison_operator_type2
        foreign key (pt_ipc_comparison_operator_type2) references ipc_comparison_operator_type (code),
    constraint fkt_pt_ipc_comparison_operator_type3
        foreign key (pt_ipc_comparison_operator_type3) references ipc_comparison_operator_type (code),
    constraint fkt_pt_ipc_comparison_operator_type4
        foreign key (pt_ipc_comparison_operator_type4) references ipc_comparison_operator_type (code),
    constraint fkt_pt_ipc_property_usage_type1
        foreign key (pt_ipc_property_usage_type1) references ipc_property_usage_type (code),
    constraint fkt_pt_ipc_property_usage_type2
        foreign key (pt_ipc_property_usage_type2) references ipc_property_usage_type (code),
    constraint fkt_pt_ipc_property_usage_type3
        foreign key (pt_ipc_property_usage_type3) references ipc_property_usage_type (code),
    constraint fkt_pt_ipc_property_usage_type4
        foreign key (pt_ipc_property_usage_type4) references ipc_property_usage_type (code),
    constraint fkt_pt_lien_priority_type
        foreign key (pt_lien_priority_type) references lien_priority_type (code),
    constraint fkt_pt_loan_amortization_type
        foreign key (pt_loan_amortization_type) references loan_amortization_type (code),
    constraint fkt_pt_mortgage_type
        foreign key (pt_mortgage_type) references mortgage_type (code),
    constraint fkt_pt_negative_amortization_type
        foreign key (pt_negative_amortization_type) references negative_amortization_type (code),
    constraint fkt_pt_partial_payment_policy_type
        foreign key (pt_partial_payment_policy_type) references partial_payment_policy_type (code),
    constraint fkt_pt_payment_frequency_type
        foreign key (pt_payment_frequency_type) references payment_frequency_type (code),
    constraint fkt_pt_payment_structure_type
        foreign key (pt_payment_structure_type) references payment_structure_type (code),
    constraint fkt_pt_prepaid_interest_rate_type
        foreign key (pt_prepaid_interest_rate_type) references prepaid_interest_rate_type (code),
    constraint fkt_pt_prepay_penalty_type
        foreign key (pt_prepay_penalty_type) references prepay_penalty_type (code),
    constraint fkt_pt_product_appraisal_requirement_type
        foreign key (pt_product_appraisal_requirement_type) references product_appraisal_requirement_type (code),
    constraint fkt_pt_product_special_program_type
        foreign key (pt_product_special_program_type) references product_special_program_type (code),
    constraint fkt_pt_qualifying_monthly_payment_type
        foreign key (pt_qualifying_monthly_payment_type) references qualifying_monthly_payment_type (code),
    constraint fkt_pt_qualifying_rate_type
        foreign key (pt_qualifying_rate_type) references qualifying_rate_type (code),
    constraint fkt_pt_section_of_act_coarse_type
        foreign key (pt_section_of_act_coarse_type) references section_of_act_coarse_type (code),
    constraint fkt_pt_servicing_transfer_type
        foreign key (pt_servicing_transfer_type) references servicing_transfer_type (code),
    constraint fkt_pt_texas_veterans_land_board
        foreign key (pt_texas_veterans_land_board) references yes_no_unknown_type (code),
    constraint fkt_pt_third_party_community_second_program_eligibility_type
        foreign key (pt_third_party_community_second_program_eligibility_type) references third_party_community_second_program_eligibility_type (code)
);

create table product_buydown
(
    pbd_pid bigint auto_increment
        primary key,
    pbd_version int not null,
    pbd_product_terms_pid bigint not null,
    pbd_buydown_schedule_type varchar(128) not null,
    constraint pbd_product_terms_pid
        unique (pbd_product_terms_pid, pbd_buydown_schedule_type),
    constraint fk_product_buydown_1
        foreign key (pbd_product_terms_pid) references product_terms (pt_pid),
    constraint fkt_pbd_buydown_schedule_type
        foreign key (pbd_buydown_schedule_type) references buydown_schedule_type (code)
);

create table product_interest_only
(
    pio_pid bigint auto_increment
        primary key,
    pio_version int not null,
    pio_product_terms_pid bigint not null,
    pio_interest_only_type varchar(128) not null,
    constraint pio_product_terms_pid
        unique (pio_product_terms_pid, pio_interest_only_type),
    constraint fk_product_interest_only_1
        foreign key (pio_product_terms_pid) references product_terms (pt_pid),
    constraint fkt_pio_interest_only_type
        foreign key (pio_interest_only_type) references interest_only_type (code)
);

create table product_prepay_penalty
(
    ppp_pid bigint auto_increment
        primary key,
    ppp_version int not null,
    ppp_product_terms_pid bigint not null,
    ppp_prepay_penalty_schedule_type varchar(128) not null,
    constraint ppp_product_terms_pid
        unique (ppp_product_terms_pid, ppp_prepay_penalty_schedule_type),
    constraint fk_product_prepay_penalty_1
        foreign key (ppp_product_terms_pid) references product_terms (pt_pid),
    constraint fkt_ppp_prepay_penalty_schedule_type
        foreign key (ppp_prepay_penalty_schedule_type) references prepay_penalty_schedule_type (code)
);

create table rate_sheet
(
    rs_pid bigint auto_increment
        primary key,
    rs_version int not null,
    rs_product_pid bigint not null,
    rs_from_datetime datetime not null,
    constraint rs_product_pid
        unique (rs_product_pid, rs_from_datetime),
    constraint fk_rate_sheet_1
        foreign key (rs_product_pid) references product (p_pid)
);

create table rate_sheet_rate
(
    rsr_pid bigint auto_increment
        primary key,
    rsr_version int not null,
    rsr_rate_sheet_pid bigint not null,
    rsr_rate_percent decimal(11,9) not null,
    rsr_arm_margin_percent decimal(11,9) not null,
    rsr_available bit not null,
    constraint fk_rate_sheet_rate_1
        foreign key (rsr_rate_sheet_pid) references rate_sheet (rs_pid)
);

create table rate_sheet_price
(
    rsp_pid bigint auto_increment
        primary key,
    rsp_version int not null,
    rsp_rate_sheet_rate_pid bigint not null,
    rsp_lock_duration_days int null,
    rsp_lock_commitment_type varchar(128) not null,
    rsp_price_percent decimal(11,9) not null,
    constraint fk_rate_sheet_price_1
        foreign key (rsp_rate_sheet_rate_pid) references rate_sheet_rate (rsr_pid),
    constraint fkt_rsp_lock_commitment_type
        foreign key (rsp_lock_commitment_type) references lock_commitment_type (code)
);

create table repository_file
(
    rf_pid bigint auto_increment
        primary key,
    rf_version int not null,
    rf_account_pid bigint not null,
    rf_repository_type varchar(128) not null,
    rf_client_filename varchar(128) null,
    rf_repository_filename varchar(128) not null,
    rf_upload_datetime datetime not null,
    rf_uploader_name varchar(128) not null,
    rf_uploader_agent_type varchar(128) not null,
    rf_uploader_lender_user_pid bigint null,
    rf_uploader_borrower_user_pid bigint null,
    rf_description varchar(256) null,
    rf_file_size bigint not null,
    rf_mime_type varchar(128) not null,
    rf_delete_datetime datetime null,
    rf_file_checksum varchar(128) not null,
    constraint rf_repository_type
        unique (rf_repository_type, rf_repository_filename),
    constraint fk_repository_file_1
        foreign key (rf_account_pid) references account (a_pid),
    constraint fk_repository_file_2
        foreign key (rf_uploader_lender_user_pid) references lender_user (lu_pid),
    constraint fk_repository_file_3
        foreign key (rf_uploader_borrower_user_pid) references borrower_user (bu_pid),
    constraint fkt_rf_repository_type
        foreign key (rf_repository_type) references lura_file_repository_type (code),
    constraint fkt_rf_uploader_agent_type
        foreign key (rf_uploader_agent_type) references agent_type (code)
);

create table bid_pool_file
(
    bpf_pid bigint auto_increment
        primary key,
    bpf_version int not null,
    bpf_bid_pool_pid bigint not null,
    bpf_repository_file_pid bigint not null,
    constraint bpf_repository_file_pid
        unique (bpf_repository_file_pid),
    constraint fk_bid_pool_file_1
        foreign key (bpf_bid_pool_pid) references bid_pool (bp_pid),
    constraint fk_bid_pool_file_2
        foreign key (bpf_repository_file_pid) references repository_file (rf_pid)
);

create table compass_analytics_report_request
(
    carr_pid bigint auto_increment
        primary key,
    carr_version int not null,
    carr_account_pid bigint not null,
    carr_create_datetime datetime not null,
    carr_start_datetime datetime null,
    carr_end_datetime datetime null,
    carr_request_status_type varchar(128) not null,
    carr_request_status_messages text not null,
    carr_requester_unparsed_name varchar(128) not null,
    carr_exported_deal_count int not null,
    carr_total_deal_count int not null,
    carr_sold_from_date date not null,
    carr_sold_through_date date null,
    carr_cancelled_from_date date not null,
    carr_cancelled_through_date date null,
    carr_export_csv_repository_file_pid bigint null,
    carr_error_file_pid bigint null,
    carr_use_loan_hedge_data bit not null,
    constraint fk_compass_analytics_report_request_1
        foreign key (carr_account_pid) references account (a_pid),
    constraint fk_compass_analytics_report_request_2
        foreign key (carr_export_csv_repository_file_pid) references repository_file (rf_pid),
    constraint fkt_carr_request_status_type
        foreign key (carr_request_status_type) references compass_analytics_report_request_status_type (code)
);

create table consumer_privacy_request
(
    cpr_pid bigint auto_increment
        primary key,
    cpr_version int not null,
    cpr_request_id int not null,
    cpr_receiver_lender_user_pid bigint null,
    cpr_account_pid bigint not null,
    cpr_borrower_last_name varchar(128) not null,
    cpr_searched_email varchar(256) not null,
    cpr_searched_phone varchar(32) not null,
    cpr_searched_los_loan_id bigint null,
    cpr_searched_subject_property_street varchar(128) not null,
    cpr_searched_subject_property_city varchar(128) not null,
    cpr_searched_subject_property_state_type varchar(128) not null,
    cpr_received_date datetime null,
    cpr_know_datetime datetime null,
    cpr_delete_datetime datetime null,
    cpr_request_type varchar(128) not null,
    cpr_request_todo varchar(128) null,
    cpr_know_repository_file_pid bigint null,
    cpr_delete_repository_file_pid bigint null,
    constraint fk_consumer_privacy_request_1
        foreign key (cpr_receiver_lender_user_pid) references lender_user (lu_pid),
    constraint fk_consumer_privacy_request_2
        foreign key (cpr_account_pid) references account (a_pid),
    constraint fk_consumer_privacy_request_3
        foreign key (cpr_know_repository_file_pid) references repository_file (rf_pid),
    constraint fk_consumer_privacy_request_4
        foreign key (cpr_delete_repository_file_pid) references repository_file (rf_pid),
    constraint fkt_cpr_request_todo
        foreign key (cpr_request_todo) references consumer_privacy_request_type (code),
    constraint fkt_cpr_request_type
        foreign key (cpr_request_type) references consumer_privacy_request_type (code),
    constraint fkt_cpr_searched_subject_property_state_type
        foreign key (cpr_searched_subject_property_state_type) references state_type (code)
);

create table custom_form
(
    cf_pid bigint auto_increment
        primary key,
    cf_version int not null,
    cf_account_pid bigint not null,
    cf_merge_form bit null,
    cf_repository_file_pid bigint not null,
    constraint cf_repository_file_pid
        unique (cf_repository_file_pid),
    constraint fk_custom_form_1
        foreign key (cf_account_pid) references account (a_pid),
    constraint fk_custom_form_2
        foreign key (cf_repository_file_pid) references repository_file (rf_pid)
);

create table custom_form_merge_field
(
    cfmf_pid bigint auto_increment
        primary key,
    cfmf_version int not null,
    cfmf_custom_form_pid bigint not null,
    cfmf_field_type varchar(128) not null,
    constraint fk_form_merge_field_1
        foreign key (cfmf_custom_form_pid) references custom_form (cf_pid),
    constraint fkt_cfmf_field_type
        foreign key (cfmf_field_type) references field_type (code)
);

create table deal_file
(
    df_pid bigint auto_increment
        primary key,
    df_version int not null,
    df_deal_pid bigint not null,
    df_repository_file_pid bigint not null,
    df_archive bit not null,
    df_borrower_uploaded bit not null,
    constraint df_repository_file_pid
        unique (df_repository_file_pid),
    constraint fk_deal_file_1
        foreign key (df_deal_pid) references deal (d_pid),
    constraint fk_deal_file_2
        foreign key (df_repository_file_pid) references repository_file (rf_pid)
);

create table appraisal_file
(
    aprf_pid bigint auto_increment
        primary key,
    aprf_version int not null,
    aprf_appraisal_pid bigint not null,
    aprf_deal_file_pid bigint not null,
    aprf_appraisal_file_type varchar(128) not null,
    constraint aprf_appraisal_pid
        unique (aprf_appraisal_pid, aprf_deal_file_pid),
    constraint fk_appraisal_file_1
        foreign key (aprf_appraisal_pid) references appraisal (apr_pid),
    constraint fk_appraisal_file_2
        foreign key (aprf_deal_file_pid) references deal_file (df_pid),
    constraint fkt_aprf_appraisal_file_type
        foreign key (aprf_appraisal_file_type) references appraisal_file_type (code)
);

create table deal_dropbox_file
(
    ddf_pid bigint auto_increment
        primary key,
    ddf_version int not null,
    ddf_deal_file_pid bigint not null,
    constraint uk_deal_dropbox_file_1
        unique (ddf_deal_file_pid),
    constraint fk_deal_dropbox_file_1
        foreign key (ddf_deal_file_pid) references deal_file (df_pid)
);

create table deal_file_signature
(
    dfs_pid bigint auto_increment
        primary key,
    dfs_version int not null,
    dfs_deal_file_pid bigint not null,
    dfs_deal_signer_pid bigint not null,
    dfs_x decimal(15,7) not null,
    dfs_y decimal(15,7) not null,
    dfs_page_number int null,
    dfs_page_height decimal(15,7) not null,
    dfs_signature_part_type varchar(128) not null,
    dfs_charge_type varchar(128) null,
    dfs_charge_amount decimal(15,2) not null,
    constraint fk_deal_file_signature_1
        foreign key (dfs_deal_file_pid) references deal_file (df_pid),
    constraint fk_deal_file_signature_2
        foreign key (dfs_deal_signer_pid) references deal_signer (dsi_pid),
    constraint fkt_dfs_charge_type
        foreign key (dfs_charge_type) references charge_type (code),
    constraint fkt_dfs_signature_part_type
        foreign key (dfs_signature_part_type) references signature_part_type (code)
);

create table deal_fraud_risk
(
    dfr_pid bigint auto_increment
        primary key,
    dfr_version int not null,
    dfr_deal_pid bigint not null,
    dfr_loan_safe_risk_manager_status_messages text not null,
    dfr_loan_safe_risk_manager_order_number varchar(128) null,
    dfr_loan_safe_risk_manager_html_deal_file_pid bigint null,
    dfr_loan_safe_risk_manager_pdf_deal_file_pid bigint null,
    dfr_loan_safe_fraud_risk_score int null,
    dfr_loan_safe_collateral_risk_score int null,
    dfr_loan_safe_product_type varchar(128) not null,
    constraint uk_deal_fraud_risk_1
        unique (dfr_deal_pid),
    constraint fk_deal_fraud_risk_1
        foreign key (dfr_deal_pid) references deal (d_pid),
    constraint fk_deal_fraud_risk_2
        foreign key (dfr_loan_safe_risk_manager_html_deal_file_pid) references deal_file (df_pid),
    constraint fk_deal_fraud_risk_3
        foreign key (dfr_loan_safe_risk_manager_pdf_deal_file_pid) references deal_file (df_pid),
    constraint fkt_dfr_loan_safe_product_type
        foreign key (dfr_loan_safe_product_type) references loan_safe_product_type (code)
);

create table deal_invoice_file
(
    dif_pid bigint auto_increment
        primary key,
    dif_version int not null,
    dif_deal_invoice_file_type varchar(128) not null,
    dif_deal_file_pid bigint not null,
    dif_deal_invoice_pid bigint not null,
    dif_create_datetime datetime not null,
    constraint fk_deal_invoice_file_1
        foreign key (dif_deal_file_pid) references deal_file (df_pid),
    constraint fk_deal_invoice_file_2
        foreign key (dif_deal_invoice_pid) references deal_invoice (di_pid),
    constraint fkt_dif_deal_invoice_file_type
        foreign key (dif_deal_invoice_file_type) references deal_invoice_file_type (code)
);

create table deal_message_log
(
    dmlog_pid bigint auto_increment
        primary key,
    dmlog_version int not null,
    dmlog_deal_pid bigint not null,
    dmlog_sent_datetime datetime not null,
    dmlog_delivery_type varchar(128) not null,
    dmlog_to_recipients varchar(16000) not null,
    dmlog_email_reply_to varchar(256) null,
    dmlog_name varchar(256) not null,
    dmlog_email_subject varchar(1024) null,
    dmlog_email_body text null,
    dmlog_sent_securely bit null,
    dmlog_cover_letter_deal_file_pid bigint null,
    dmlog_attachment_deal_file_pid bigint null,
    dmlog_cc_recipients varchar(16000) null,
    dmlog_bcc_recipients varchar(16000) null,
    dmlog_plain_text bit not null,
    constraint fk_deal_message_log_1
        foreign key (dmlog_deal_pid) references deal (d_pid),
    constraint fk_deal_message_log_2
        foreign key (dmlog_cover_letter_deal_file_pid) references deal_file (df_pid),
    constraint fk_deal_message_log_3
        foreign key (dmlog_attachment_deal_file_pid) references deal_file (df_pid),
    constraint fkt_dmlog_delivery_type
        foreign key (dmlog_delivery_type) references smart_message_delivery_type (code)
);

create table deal_system_file
(
    dsf_pid bigint auto_increment
        primary key,
    dsf_version int not null,
    dsf_deal_pid bigint not null,
    dsf_repository_file_pid bigint not null,
    constraint dsf_repository_file_pid
        unique (dsf_repository_file_pid),
    constraint fk_deal_system_file_1
        foreign key (dsf_deal_pid) references deal (d_pid),
    constraint fk_deal_system_file_2
        foreign key (dsf_repository_file_pid) references repository_file (rf_pid)
);

create table appraisal_order_request
(
    aprq_pid bigint auto_increment
        primary key,
    aprq_version int not null,
    aprq_deal_pid bigint not null,
    aprq_appraisal_pid bigint null,
    aprq_mercury_network_status_request_pid bigint null,
    aprq_appraisal_order_coarse_status_type varchar(128) not null,
    aprq_order_id varchar(128) null,
    aprq_order_instructions varchar(1024) null,
    aprq_address_street1 varchar(128) not null,
    aprq_address_street2 varchar(128) not null,
    aprq_address_city varchar(128) not null,
    aprq_address_state varchar(128) not null,
    aprq_address_postal_code varchar(128) not null,
    aprq_appraisal_fee_amount decimal(15,2) not null,
    aprq_order_request_date date not null,
    aprq_response_xml_deal_system_file_pid bigint null,
    aprq_mismo_xml_deal_system_file_pid bigint null,
    aprq_appraisal_order_request_type varchar(128) not null,
    aprq_status_check_datetime datetime null,
    aprq_appraisal_management_company_type varchar(128) not null,
    aprq_requester_lender_user_pid bigint null,
    aprq_requester_unparsed_name varchar(128) not null,
    aprq_requester_agent_type varchar(128) not null,
    aprq_vendor_status_unique_id varchar(128) not null,
    constraint uk_appraisal_order_request_1
        unique (aprq_appraisal_pid),
    constraint uk_appraisal_order_request_2
        unique (aprq_mercury_network_status_request_pid),
    constraint fk_appraisal_order_request_1
        foreign key (aprq_deal_pid) references deal (d_pid),
    constraint fk_appraisal_order_request_2
        foreign key (aprq_appraisal_pid) references appraisal (apr_pid),
    constraint fk_appraisal_order_request_3
        foreign key (aprq_mercury_network_status_request_pid) references mercury_network_status_request (mnsr_pid),
    constraint fk_appraisal_order_request_4
        foreign key (aprq_response_xml_deal_system_file_pid) references deal_system_file (dsf_pid),
    constraint fk_appraisal_order_request_5
        foreign key (aprq_mismo_xml_deal_system_file_pid) references deal_system_file (dsf_pid),
    constraint fk_appraisal_order_request_6
        foreign key (aprq_requester_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_aprq_appraisal_management_company_type
        foreign key (aprq_appraisal_management_company_type) references appraisal_management_company_type (code),
    constraint fkt_aprq_appraisal_order_coarse_status_type
        foreign key (aprq_appraisal_order_coarse_status_type) references appraisal_order_coarse_status_type (code),
    constraint fkt_aprq_appraisal_order_request_type
        foreign key (aprq_appraisal_order_request_type) references appraisal_order_request_type (code),
    constraint fkt_aprq_requester_agent_type
        foreign key (aprq_requester_agent_type) references agent_type (code)
);

create table appraisal_order_request_file
(
    aorf_pid bigint auto_increment
        primary key,
    aorf_version int not null,
    aorf_appraisal_order_request_pid bigint not null,
    aorf_deal_file_pid bigint not null,
    aorf_appraisal_order_request_file_type varchar(128) not null,
    aorf_vendor_document_datetime datetime null,
    aorf_vendor_document_id varchar(128) not null,
    constraint fk_appraisal_order_request_file_1
        foreign key (aorf_appraisal_order_request_pid) references appraisal_order_request (aprq_pid),
    constraint fk_appraisal_order_request_file_2
        foreign key (aorf_deal_file_pid) references deal_file (df_pid),
    constraint fkt_aorf_appraisal_order_request_file_type
        foreign key (aorf_appraisal_order_request_file_type) references appraisal_order_request_file_type (code)
);

create table deal_file_thumbnail
(
    dft_pid bigint auto_increment
        primary key,
    dft_version int not null,
    dft_deal_file_pid bigint not null,
    dft_deal_system_file_pid bigint not null,
    dft_page_number int not null,
    constraint uk_deal_file_thumbnail_1
        unique (dft_deal_file_pid, dft_page_number),
    constraint uk_deal_file_thumbnail_2
        unique (dft_deal_system_file_pid),
    constraint fk_deal_file_thumbnail_1
        foreign key (dft_deal_file_pid) references deal_file (df_pid),
    constraint fk_deal_file_thumbnail_2
        foreign key (dft_deal_system_file_pid) references deal_system_file (dsf_pid)
);

create table du_request
(
    dur_pid bigint auto_increment
        primary key,
    dur_version int not null,
    dur_proposal_pid bigint not null,
    dur_proposal_snapshot_pid bigint null,
    dur_uw_findings_html_deal_file_pid bigint null,
    dur_uw_analysis_html_deal_file_pid bigint null,
    dur_uw_findings_pdf_deal_file_pid bigint null,
    dur_uw_findings_xml_provided bit null,
    dur_requester_agent_type varchar(128) not null,
    dur_requester_lender_user_pid bigint null,
    dur_requester_unparsed_name varchar(128) not null,
    dur_create_datetime datetime not null,
    dur_mismo_version_type varchar(128) not null,
    dur_credit_bureau_type varchar(128) not null,
    dur_globally_unique_id varchar(128) null,
    dur_response_deal_system_file_pid bigint null,
    dur_du_casefile_id varchar(32) null,
    dur_du_request_status_type varchar(128) not null,
    dur_status_message varchar(1024) null,
    dur_mp_status_log varchar(16000) null,
    dur_du_recommendation_type varchar(128) not null,
    dur_du_version varchar(16) null,
    dur_du_submission_number int null,
    dur_loan_amount decimal(17,2) not null,
    dur_initial_pi_amount decimal(15,2) not null,
    dur_note_rate_percent decimal(11,9) not null,
    dur_initial_note_rate_percent decimal(11,9) not null,
    dur_ltv_ratio_percent decimal(11,9) not null,
    dur_cltv_ratio_percent decimal(11,9) not null,
    dur_housing_ratio_percent decimal(11,9) not null,
    dur_debt_ratio_percent decimal(11,9) not null,
    dur_du_ltv_ratio_percent decimal(11,9) not null,
    dur_du_cltv_ratio_percent decimal(11,9) not null,
    dur_du_housing_ratio_percent decimal(11,9) not null,
    dur_du_debt_ratio_percent decimal(11,9) not null,
    dur_aus_request_number int not null,
    dur_cash_from_borrower_amount decimal(15,2) not null,
    dur_aus_cash_from_borrower_amount decimal(15,2) not null,
    dur_gse_version_type varchar(128) not null,
    constraint fk_du_request_2
        foreign key (dur_uw_findings_html_deal_file_pid) references deal_file (df_pid),
    constraint fk_du_request_3
        foreign key (dur_uw_analysis_html_deal_file_pid) references deal_file (df_pid),
    constraint fk_du_request_4
        foreign key (dur_uw_findings_pdf_deal_file_pid) references deal_file (df_pid),
    constraint fk_du_request_5
        foreign key (dur_requester_lender_user_pid) references lender_user (lu_pid),
    constraint fk_du_request_6
        foreign key (dur_response_deal_system_file_pid) references deal_system_file (dsf_pid),
    constraint fkt_dur_credit_bureau_type
        foreign key (dur_credit_bureau_type) references credit_bureau_type (code),
    constraint fkt_dur_du_recommendation_type
        foreign key (dur_du_recommendation_type) references du_recommendation_type (code),
    constraint fkt_dur_du_request_status_type
        foreign key (dur_du_request_status_type) references du_request_status_type (code),
    constraint fkt_dur_gse_version_type
        foreign key (dur_gse_version_type) references gse_version_type (code),
    constraint fkt_dur_mismo_version_type
        foreign key (dur_mismo_version_type) references mismo_version_type (code),
    constraint fkt_dur_requester_agent_type
        foreign key (dur_requester_agent_type) references agent_type (code)
);

create table du_key_finding
(
    dukf_pid bigint auto_increment
        primary key,
    dukf_version int not null,
    dukf_du_request_pid bigint not null,
    dukf_du_key_finding_type varchar(128) null,
    dukf_key_finding_result varchar(128) null,
    constraint uk_du_key_finding_1
        unique (dukf_du_request_pid, dukf_du_key_finding_type),
    constraint fk_du_key_finding_1
        foreign key (dukf_du_request_pid) references du_request (dur_pid),
    constraint fkt_dukf_du_key_finding_type
        foreign key (dukf_du_key_finding_type) references du_key_finding_type (code),
    constraint fkt_dukf_key_finding_result
        foreign key (dukf_key_finding_result) references yes_no_unknown_type (code)
);

create table du_refi_plus_finding
(
    durpf_pid bigint auto_increment
        primary key,
    durpf_version int not null,
    durpf_du_request_pid bigint not null,
    durpf_description varchar(32) null,
    durpf_value varchar(128) null,
    constraint uk_du_refi_plus_finding_1
        unique (durpf_du_request_pid, durpf_description),
    constraint fk_du_refi_plus_1
        foreign key (durpf_du_request_pid) references du_request (dur_pid)
);

create table du_request_credit
(
    durc_pid bigint auto_increment
        primary key,
    durc_version int not null,
    durc_du_request_pid bigint not null,
    durc_du_casefile_id varchar(32) not null,
    durc_create_datetime datetime not null,
    durc_credit_report_create_datetime datetime null,
    durc_credit_bureau_type varchar(128) not null,
    durc_credit_report_identifier varchar(32) not null,
    durc_credit_report_name varchar(256) not null,
    durc_aus_credit_service_type varchar(128) not null,
    durc_borrower_1_ssn varchar(128) null,
    durc_borrower_2_ssn varchar(128) null,
    durc_borrower_1_borrower_tiny_id_type varchar(128) not null,
    durc_borrower_2_borrower_tiny_id_type varchar(128) null,
    constraint fk_du_request_credit_1
        foreign key (durc_du_request_pid) references du_request (dur_pid),
    constraint fkt_durc_aus_credit_service_type
        foreign key (durc_aus_credit_service_type) references aus_credit_service_type (code),
    constraint fkt_durc_borrower_1_borrower_tiny_id_type
        foreign key (durc_borrower_1_borrower_tiny_id_type) references borrower_tiny_id_type (code),
    constraint fkt_durc_borrower_2_borrower_tiny_id_type
        foreign key (durc_borrower_2_borrower_tiny_id_type) references borrower_tiny_id_type (code),
    constraint fkt_durc_credit_bureau_type
        foreign key (durc_credit_bureau_type) references credit_bureau_type (code)
);

create table du_special_feature_code
(
    dusfc_pid bigint auto_increment
        primary key,
    dusfc_version int not null,
    dusfc_du_request_pid bigint not null,
    dusfc_special_feature_code varchar(32) null,
    dusfc_special_feature_description varchar(128) null,
    constraint uk_du_special_feature_code_1
        unique (dusfc_du_request_pid, dusfc_special_feature_description),
    constraint fk_du_special_feature_code_1
        foreign key (dusfc_du_request_pid) references du_request (dur_pid)
);

create table flood_cert
(
    fc_pid bigint auto_increment
        primary key,
    fc_version int not null,
    fc_deal_pid bigint not null,
    fc_flood_certificate_type varchar(128) not null,
    fc_flood_cert_vendor_type varchar(128) not null,
    fc_flood_certification_reference_number varchar(32) null,
    fc_flood_cert_effective_date date null,
    fc_nfip_community_name varchar(256) null,
    fc_nfip_counties varchar(256) null,
    fc_nfip_state varchar(2) null,
    fc_nfip_community_number varchar(16) null,
    fc_nfip_community_firm_date date null,
    fc_nfip_community_participation_start_date date null,
    fc_flood_partial varchar(128) not null,
    fc_nfip_map_number varchar(8) null,
    fc_nfip_map_panel varchar(8) null,
    fc_nfip_map_panel_suffix varchar(8) null,
    fc_nfip_map_panel_date date null,
    fc_nfip_map_exists varchar(128) not null,
    fc_nfip_letter_of_map_date date null,
    fc_nfip_letter_of_map_case_number varchar(32) null,
    fc_fema_flood_zone_designation_type varchar(128) not null,
    fc_nfip_community_participation_status_type varchar(128) not null,
    fc_protected_area varchar(128) not null,
    fc_protected_area_designation_date date null,
    fc_special_flood_hazard_area varchar(128) not null,
    fc_property_county_fips varchar(32) null,
    fc_property_state_fips varchar(32) null,
    fc_flood_cert_deal_file_pid bigint null,
    fc_property_address_city varchar(128) null,
    fc_property_address_country varchar(128) not null,
    fc_property_address_postal_code varchar(128) null,
    fc_property_address_state varchar(128) null,
    fc_property_address_street1 varchar(128) null,
    fc_property_address_street2 varchar(128) null,
    fc_property_county_name varchar(128) null,
    fc_clg_flood_cert_messages text not null,
    fc_clg_flood_cert_status_type varchar(128) not null,
    fc_clg_flood_cert_request_datetime datetime null,
    fc_clg_flood_cert_requester_agent_type varchar(128) not null,
    fc_clg_flood_cert_requester_lender_user_pid bigint null,
    fc_clg_flood_cert_requester_unparsed_name varchar(128) null,
    constraint uk_flood_cert_1
        unique (fc_deal_pid),
    constraint fk_flood_cert_1
        foreign key (fc_deal_pid) references deal (d_pid),
    constraint fk_flood_cert_2
        foreign key (fc_flood_cert_deal_file_pid) references deal_file (df_pid),
    constraint fk_flood_cert_3
        foreign key (fc_clg_flood_cert_requester_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_fc_clg_flood_cert_requester_agent_type
        foreign key (fc_clg_flood_cert_requester_agent_type) references agent_type (code),
    constraint fkt_fc_clg_flood_cert_status_type
        foreign key (fc_clg_flood_cert_status_type) references clg_flood_cert_status_type (code),
    constraint fkt_fc_fema_flood_zone_designation_type
        foreign key (fc_fema_flood_zone_designation_type) references fema_flood_zone_designation_type (code),
    constraint fkt_fc_flood_cert_vendor_type
        foreign key (fc_flood_cert_vendor_type) references flood_cert_vendor_type (code),
    constraint fkt_fc_flood_certificate_type
        foreign key (fc_flood_certificate_type) references flood_certificate_type (code),
    constraint fkt_fc_flood_partial
        foreign key (fc_flood_partial) references yes_no_unknown_type (code),
    constraint fkt_fc_nfip_community_participation_status_type
        foreign key (fc_nfip_community_participation_status_type) references nfip_community_participation_status_type (code),
    constraint fkt_fc_nfip_map_exists
        foreign key (fc_nfip_map_exists) references yes_no_unknown_type (code),
    constraint fkt_fc_property_address_country
        foreign key (fc_property_address_country) references country_type (code),
    constraint fkt_fc_protected_area
        foreign key (fc_protected_area) references yes_no_unknown_type (code),
    constraint fkt_fc_special_flood_hazard_area
        foreign key (fc_special_flood_hazard_area) references yes_no_unknown_type (code)
);

create table hmda_report_request
(
    hrr_pid bigint auto_increment
        primary key,
    hrr_version int not null,
    hrr_account_pid bigint not null,
    hrr_create_datetime datetime not null,
    hrr_start_datetime datetime null,
    hrr_end_datetime datetime null,
    hrr_request_status_type varchar(128) not null,
    hrr_request_status_messages text null,
    hrr_requester_unparsed_name varchar(128) not null,
    hrr_row_count int null,
    hrr_from_date date null,
    hrr_through_date date null,
    hrr_error_protection bit null,
    hrr_error_limit int null,
    hrr_repository_file_pid bigint null,
    constraint fk_hmda_report_request_1
        foreign key (hrr_account_pid) references account (a_pid),
    constraint fk_hmda_report_request_2
        foreign key (hrr_repository_file_pid) references repository_file (rf_pid),
    constraint fkt_hrr_request_status_type
        foreign key (hrr_request_status_type) references report_request_status_type (code)
);

create table lender_user_photo
(
    lup_pid bigint auto_increment
        primary key,
    lup_version int not null,
    lup_lender_user_pid bigint not null,
    lup_repository_file_pid bigint not null,
    constraint lup_lender_user_pid
        unique (lup_lender_user_pid),
    constraint lup_repository_file_pid
        unique (lup_repository_file_pid),
    constraint fk_lender_user_photo_1
        foreign key (lup_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lender_user_photo_2
        foreign key (lup_repository_file_pid) references repository_file (rf_pid)
);

create table lp_request
(
    lpr_pid bigint auto_increment
        primary key,
    lpr_version int not null,
    lpr_proposal_pid bigint not null,
    lpr_proposal_snapshot_pid bigint null,
    lpr_full_feedback_pdf_deal_file_pid bigint null,
    lpr_hve_pdf_deal_file_pid bigint null,
    lpr_requester_agent_type varchar(128) not null,
    lpr_requester_lender_user_pid bigint null,
    lpr_requester_unparsed_name varchar(128) not null,
    lpr_create_datetime datetime not null,
    lpr_lp_interface_version_type varchar(128) not null,
    lpr_lp_dtd_version_type varchar(128) not null,
    lpr_mismo_version_type varchar(128) not null,
    lpr_fre_lp_transaction_id varchar(32) null,
    lpr_lp_transaction_id varchar(32) null,
    lpr_globally_unique_id varchar(128) not null,
    lpr_lp_request_status_type varchar(128) not null,
    lpr_lp_evaluation_status_type varchar(128) not null,
    lpr_status_messages text not null,
    lpr_xml_response_deal_system_file_pid bigint null,
    lpr_loan_amount decimal(17,2) not null,
    lpr_initial_pi_amount decimal(15,2) not null,
    lpr_note_rate_percent decimal(11,9) not null,
    lpr_initial_note_rate_percent decimal(11,9) not null,
    lpr_ltv_ratio_percent decimal(11,9) not null,
    lpr_cltv_ratio_percent decimal(11,9) not null,
    lpr_hcltv_ratio_percent decimal(11,9) not null,
    lpr_hcltv_applicable bit null,
    lpr_housing_ratio_percent decimal(11,9) not null,
    lpr_debt_ratio_percent decimal(11,9) not null,
    lpr_lp_ltv_ratio_percent decimal(11,9) not null,
    lpr_lp_total_ltv_ratio_percent decimal(11,9) not null,
    lpr_lp_high_total_ltv_ratio_percent decimal(11,9) not null,
    lpr_lp_housing_ratio_percent decimal(11,9) not null,
    lpr_lp_debt_ratio_percent decimal(11,9) not null,
    lpr_lp_submission_number int null,
    lpr_lp_credit_risk_classification_type varchar(128) not null,
    lpr_fre_doc_level_description_type varchar(128) not null,
    lpr_fre_purchase_eligibility_type varchar(128) not null,
    lpr_lp_case_state_type varchar(128) not null,
    lpr_lp_async_id varchar(128) null,
    lpr_lp_async_polling_interval int not null,
    lpr_lp_total_funds_to_be_verified_amount decimal(15,2) not null,
    lpr_lp_required_borrower_funds_amount decimal(15,2) not null,
    lpr_lp_paid_off_debt_amount decimal(15,2) not null,
    lpr_lp_required_reserves_amount decimal(15,2) not null,
    lpr_lp_total_eligible_assets_amount decimal(15,2) not null,
    lpr_lp_proceeds_from_subordinate_financing_amount decimal(15,2) not null,
    lpr_lp_calculated_reserves_amount decimal(15,2) not null,
    lpr_aus_request_number int not null,
    lpr_cash_from_borrower_amount decimal(15,2) not null,
    lpr_aus_cash_from_borrower_amount decimal(15,2) not null,
    lpr_gse_version_type varchar(128) not null,
    constraint lpr_globally_unique_id
        unique (lpr_globally_unique_id),
    constraint fk_lp_request_2
        foreign key (lpr_requester_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lp_request_3
        foreign key (lpr_full_feedback_pdf_deal_file_pid) references deal_file (df_pid),
    constraint fk_lp_request_4
        foreign key (lpr_hve_pdf_deal_file_pid) references deal_file (df_pid),
    constraint fk_lp_request_5
        foreign key (lpr_xml_response_deal_system_file_pid) references deal_system_file (dsf_pid),
    constraint fkt_lpr_fre_doc_level_description_type
        foreign key (lpr_fre_doc_level_description_type) references fre_doc_level_description_type (code),
    constraint fkt_lpr_fre_purchase_eligibility_type
        foreign key (lpr_fre_purchase_eligibility_type) references fre_purchase_eligibility_type (code),
    constraint fkt_lpr_gse_version_type
        foreign key (lpr_gse_version_type) references gse_version_type (code),
    constraint fkt_lpr_lp_case_state_type
        foreign key (lpr_lp_case_state_type) references lp_case_state_type (code),
    constraint fkt_lpr_lp_credit_risk_classification_type
        foreign key (lpr_lp_credit_risk_classification_type) references lp_credit_risk_classification_type (code),
    constraint fkt_lpr_lp_dtd_version_type
        foreign key (lpr_lp_dtd_version_type) references lp_dtd_version_type (code),
    constraint fkt_lpr_lp_evaluation_status_type
        foreign key (lpr_lp_evaluation_status_type) references lp_evaluation_status_type (code),
    constraint fkt_lpr_lp_interface_version_type
        foreign key (lpr_lp_interface_version_type) references lp_interface_version_type (code),
    constraint fkt_lpr_lp_request_status_type
        foreign key (lpr_lp_request_status_type) references lp_request_status_type (code),
    constraint fkt_lpr_mismo_version_type
        foreign key (lpr_mismo_version_type) references mismo_version_type (code),
    constraint fkt_lpr_requester_agent_type
        foreign key (lpr_requester_agent_type) references agent_type (code)
);

create table credit_request
(
    crdr_pid bigint auto_increment
        primary key,
    crdr_version int not null,
    crdr_deal_pid bigint not null,
    crdr_credit_report_file_pid bigint null,
    crdr_credit_score_disclosure_file_pid bigint null,
    crdr_create_datetime datetime not null,
    crdr_requester_agent_type varchar(128) not null,
    crdr_requester_lender_user_pid bigint null,
    crdr_requester_unparsed_name varchar(128) not null,
    crdr_credit_request_via_type varchar(128) not null,
    crdr_lp_request_pid bigint null,
    crdr_du_request_pid bigint null,
    crdr_mismo_version_type varchar(128) not null,
    crdr_credit_bureau_type varchar(128) not null,
    crdr_credit_report_request_action_type varchar(128) not null,
    crdr_credit_report_type varchar(128) not null,
    crdr_credit_report_product_description varchar(32) not null,
    crdr_credit_request_type varchar(128) not null,
    crdr_credit_repositories_selected_count int null,
    crdr_equifax_included bit null,
    crdr_experian_included bit null,
    crdr_trans_union_included bit null,
    crdr_borrower1_ssn varchar(128) null,
    crdr_borrower1_first_name varchar(32) null,
    crdr_borrower1_middle_name varchar(32) null,
    crdr_borrower1_last_name varchar(32) null,
    crdr_borrower1_name_suffix varchar(32) null,
    crdr_borrower1_birth_date date null,
    crdr_borrower1_residence_city varchar(128) null,
    crdr_borrower1_residence_country varchar(128) not null,
    crdr_borrower1_residence_postal_code varchar(128) null,
    crdr_borrower1_residence_state varchar(128) null,
    crdr_borrower1_residence_street1 varchar(128) null,
    crdr_borrower1_residence_street2 varchar(128) null,
    crdr_borrower1_experian_credit_score int null,
    crdr_borrower1_equifax_credit_score int null,
    crdr_borrower1_trans_union_credit_score int null,
    crdr_borrower1_equifax_credit_score_model_type varchar(128) not null,
    crdr_borrower1_experian_credit_score_model_type varchar(128) not null,
    crdr_borrower1_trans_union_credit_score_model_type varchar(128) not null,
    crdr_borrower2_ssn varchar(128) null,
    crdr_borrower2_first_name varchar(32) null,
    crdr_borrower2_middle_name varchar(32) null,
    crdr_borrower2_last_name varchar(32) null,
    crdr_borrower2_name_suffix varchar(32) null,
    crdr_borrower2_birth_date date null,
    crdr_borrower2_residence_city varchar(128) null,
    crdr_borrower2_residence_country varchar(128) not null,
    crdr_borrower2_residence_postal_code varchar(128) null,
    crdr_borrower2_residence_state varchar(128) null,
    crdr_borrower2_residence_street1 varchar(128) null,
    crdr_borrower2_residence_street2 varchar(128) null,
    crdr_borrower2_experian_credit_score int null,
    crdr_borrower2_equifax_credit_score int null,
    crdr_borrower2_trans_union_credit_score int null,
    crdr_borrower2_equifax_credit_score_model_type varchar(128) not null,
    crdr_borrower2_experian_credit_score_model_type varchar(128) not null,
    crdr_borrower2_trans_union_credit_score_model_type varchar(128) not null,
    crdr_contains_importable_data bit not null,
    crdr_credit_report_identifier varchar(32) null,
    crdr_credit_report_price decimal(15,2) not null,
    crdr_credit_request_status_type varchar(128) not null,
    crdr_request_error_messages text not null,
    crdr_bureau_status_messages text not null,
    crdr_bureau_credit_report_url varchar(1024) null,
    crdr_last_status_query_datetime datetime null,
    crdr_xml_response_file_pid bigint null,
    constraint fk_credit_request_1
        foreign key (crdr_deal_pid) references deal (d_pid),
    constraint fk_credit_request_2
        foreign key (crdr_credit_report_file_pid) references deal_file (df_pid),
    constraint fk_credit_request_3
        foreign key (crdr_credit_score_disclosure_file_pid) references deal_file (df_pid),
    constraint fk_credit_request_4
        foreign key (crdr_requester_lender_user_pid) references lender_user (lu_pid),
    constraint fk_credit_request_5
        foreign key (crdr_lp_request_pid) references lp_request (lpr_pid),
    constraint fk_credit_request_6
        foreign key (crdr_du_request_pid) references du_request (dur_pid),
    constraint fk_credit_request_7
        foreign key (crdr_xml_response_file_pid) references deal_system_file (dsf_pid),
    constraint fkt_crdr_borrower1_equifax_credit_score_model_type
        foreign key (crdr_borrower1_equifax_credit_score_model_type) references credit_score_model_type (code),
    constraint fkt_crdr_borrower1_experian_credit_score_model_type
        foreign key (crdr_borrower1_experian_credit_score_model_type) references credit_score_model_type (code),
    constraint fkt_crdr_borrower1_residence_country
        foreign key (crdr_borrower1_residence_country) references country_type (code),
    constraint fkt_crdr_borrower1_trans_union_credit_score_model_type
        foreign key (crdr_borrower1_trans_union_credit_score_model_type) references credit_score_model_type (code),
    constraint fkt_crdr_borrower2_equifax_credit_score_model_type
        foreign key (crdr_borrower2_equifax_credit_score_model_type) references credit_score_model_type (code),
    constraint fkt_crdr_borrower2_experian_credit_score_model_type
        foreign key (crdr_borrower2_experian_credit_score_model_type) references credit_score_model_type (code),
    constraint fkt_crdr_borrower2_residence_country
        foreign key (crdr_borrower2_residence_country) references country_type (code),
    constraint fkt_crdr_borrower2_trans_union_credit_score_model_type
        foreign key (crdr_borrower2_trans_union_credit_score_model_type) references credit_score_model_type (code),
    constraint fkt_crdr_credit_bureau_type
        foreign key (crdr_credit_bureau_type) references credit_bureau_type (code),
    constraint fkt_crdr_credit_report_request_action_type
        foreign key (crdr_credit_report_request_action_type) references credit_report_request_action_type (code),
    constraint fkt_crdr_credit_report_type
        foreign key (crdr_credit_report_type) references credit_report_type (code),
    constraint fkt_crdr_credit_request_status_type
        foreign key (crdr_credit_request_status_type) references credit_request_status_type (code),
    constraint fkt_crdr_credit_request_type
        foreign key (crdr_credit_request_type) references credit_request_type (code),
    constraint fkt_crdr_credit_request_via_type
        foreign key (crdr_credit_request_via_type) references credit_request_via_type (code),
    constraint fkt_crdr_mismo_version_type
        foreign key (crdr_mismo_version_type) references mismo_version_type (code),
    constraint fkt_crdr_requester_agent_type
        foreign key (crdr_requester_agent_type) references agent_type (code)
);

create table borrower
(
    b_pid bigint auto_increment
        primary key,
    b_version int not null,
    b_alimony_child_support varchar(128) not null,
    b_alimony_child_support_explanation varchar(128) null,
    b_application_pid bigint not null,
    b_application_signed_date date null,
    b_application_taken_method_type varchar(128) not null,
    b_bankruptcy varchar(128) not null,
    b_bankruptcy_explanation varchar(128) null,
    b_birth_date date null,
    b_borrowed_down_payment varchar(128) not null,
    b_borrowed_down_payment_explanation varchar(128) null,
    b_applicant_role_type varchar(128) not null,
    b_required_to_sign bit not null,
    b_spousal_homestead varchar(128) not null,
    b_borrower_ssn varchar(128) null,
    b_has_no_ssn bit not null,
    b_citizenship_residency_type varchar(128) not null,
    b_credit_request_pid bigint null,
    b_credit_report_identifier varchar(32) not null,
    b_credit_report_authorization bit null,
    b_has_dependents varchar(128) not null,
    b_dependent_count int null,
    b_dependents_age_years varchar(32) null,
    b_email varchar(256) null,
    b_fax varchar(32) null,
    b_first_name varchar(32) null,
    b_nickname varchar(32) not null,
    b_first_time_homebuyer bit null,
    b_lender_employee varchar(128) not null,
    b_lender_employee_status_confirmed bit not null,
    b_sex_refused varchar(128) not null,
    b_sex_collected_visual_or_surname varchar(128) not null,
    b_sex_male bit not null,
    b_sex_female bit not null,
    b_sex_not_obtainable bit not null,
    b_ethnicity_refused varchar(128) not null,
    b_ethnicity_collected_visual_or_surname varchar(128) not null,
    b_ethnicity_hispanic_or_latino bit not null,
    b_ethnicity_mexican bit not null,
    b_ethnicity_puerto_rican bit not null,
    b_ethnicity_cuban bit not null,
    b_ethnicity_other_hispanic_or_latino bit not null,
    b_ethnicity_other_hispanic_or_latino_description varchar(100) not null,
    b_ethnicity_not_hispanic_or_latino bit not null,
    b_ethnicity_not_obtainable bit not null,
    b_homeowner_past_three_years varchar(128) not null,
    b_home_phone varchar(32) null,
    b_intend_to_occupy varchar(128) not null,
    b_last_name varchar(32) null,
    b_mailing_place_pid bigint not null,
    b_marital_status_type varchar(128) not null,
    b_spouse_borrower_pid bigint null,
    b_middle_name varchar(32) null,
    b_mobile_phone varchar(32) null,
    b_name_suffix varchar(32) null,
    b_note_endorser varchar(128) not null,
    b_note_endorser_explanation varchar(128) null,
    b_obligated_loan_foreclosure varchar(128) not null,
    b_obligated_loan_foreclosure_explanation varchar(128) null,
    b_office_phone varchar(32) null,
    b_office_phone_extension varchar(16) null,
    b_other_race_national_origin_description varchar(32) null,
    b_outstanding_judgements varchar(128) not null,
    b_outstanding_judgments_explanation varchar(128) null,
    b_party_to_lawsuit varchar(128) not null,
    b_party_to_lawsuit_explanation varchar(128) null,
    b_power_of_attorney varchar(128) not null,
    b_power_of_attorney_signing_capacity varchar(1024) null,
    b_power_of_attorney_first_name varchar(32) null,
    b_power_of_attorney_last_name varchar(32) null,
    b_power_of_attorney_middle_name varchar(32) null,
    b_power_of_attorney_name_suffix varchar(32) null,
    b_power_of_attorney_company_name varchar(128) not null,
    b_power_of_attorney_title varchar(128) null,
    b_power_of_attorney_office_phone varchar(32) null,
    b_power_of_attorney_office_phone_extension varchar(16) null,
    b_power_of_attorney_mobile_phone varchar(32) null,
    b_power_of_attorney_email varchar(256) null,
    b_power_of_attorney_fax varchar(32) null,
    b_power_of_attorney_city varchar(128) null,
    b_power_of_attorney_country varchar(128) not null,
    b_power_of_attorney_postal_code varchar(128) null,
    b_power_of_attorney_state varchar(128) null,
    b_power_of_attorney_street1 varchar(128) null,
    b_power_of_attorney_street2 varchar(128) null,
    b_presently_delinquent varchar(128) not null,
    b_presently_delinquent_explanation varchar(128) null,
    b_prior_property_title_type varchar(128) not null,
    b_prior_property_usage_type varchar(128) not null,
    b_property_foreclosure varchar(128) not null,
    b_property_foreclosure_explanation varchar(128) null,
    b_race_refused varchar(128) not null,
    b_race_collected_visual_or_surname varchar(128) not null,
    b_race_american_indian_or_alaska_native bit null,
    b_race_other_american_indian_or_alaska_native_description varchar(100) not null,
    b_race_asian bit null,
    b_race_asian_indian bit not null,
    b_race_chinese bit not null,
    b_race_filipino bit not null,
    b_race_japanese bit not null,
    b_race_korean bit not null,
    b_race_vietnamese bit not null,
    b_race_other_asian bit not null,
    b_race_other_asian_description varchar(100) not null,
    b_race_black_or_african_american bit null,
    b_race_information_not_provided bit null,
    b_race_national_origin_refusal bit null,
    b_race_native_hawaiian_or_other_pacific_islander bit null,
    b_race_native_hawaiian bit not null,
    b_race_guamanian_or_chamorro bit not null,
    b_race_samoan bit not null,
    b_race_other_pacific_islander bit not null,
    b_race_not_obtainable bit not null,
    b_race_other_pacific_islander_description varchar(100) not null,
    b_race_not_applicable bit null,
    b_race_white bit null,
    b_schooling_years int null,
    b_titleholder varchar(128) not null,
    b_experian_credit_score int null,
    b_equifax_credit_score int null,
    b_trans_union_credit_score int null,
    b_decision_credit_score int null,
    b_borrower_tiny_id_type varchar(128) not null,
    b_first_time_home_buyer_explain varchar(1024) null,
    b_first_time_home_buyer_auto_compute bit null,
    b_caivrs_id varchar(16) null,
    b_caivrs_messages text not null,
    b_on_ldp_list varchar(128) not null,
    b_on_gsa_list varchar(128) not null,
    b_monthly_job_federal_tax_amount decimal(15,2) not null,
    b_monthly_job_state_tax_amount decimal(15,2) not null,
    b_monthly_job_retirement_tax_amount decimal(15,2) not null,
    b_monthly_job_medicare_tax_amount decimal(15,2) not null,
    b_monthly_job_state_disability_insurance_amount decimal(15,2) not null,
    b_monthly_job_other_tax_1_amount decimal(15,2) not null,
    b_monthly_job_other_tax_1_description varchar(128) null,
    b_monthly_job_other_tax_2_amount decimal(15,2) not null,
    b_monthly_job_other_tax_2_description varchar(128) null,
    b_monthly_job_other_tax_3_amount decimal(15,2) not null,
    b_monthly_job_other_tax_3_description varchar(128) null,
    b_monthly_job_total_tax_amount decimal(15,2) not null,
    b_homeownership_education_type varchar(128) not null,
    b_homeownership_education_agency_type varchar(128) not null,
    b_homeownership_education_id varchar(128) null,
    b_homeownership_education_name varchar(128) null,
    b_homeownership_education_complete_date date null,
    b_housing_counseling_type varchar(128) not null,
    b_housing_counseling_agency_type varchar(128) not null,
    b_housing_counseling_id varchar(128) null,
    b_housing_counseling_name varchar(128) null,
    b_housing_counseling_complete_date date null,
    b_legal_entity_type varchar(128) not null,
    b_credit_report_authorization_datetime datetime null,
    b_credit_report_authorization_method varchar(128) not null,
    b_credit_report_authorization_obtained_by_unparsed_name varchar(128) null,
    b_disabled varchar(128) not null,
    b_usda_annual_child_care_expenses decimal(15,2) not null,
    b_usda_disability_expenses decimal(15,2) not null,
    b_usda_medical_expenses decimal(15,2) not null,
    b_usda_income_from_assets decimal(15,2) not null,
    b_usda_moderate_income_limit decimal(15,2) not null,
    b_hud_employee bit not null,
    b_relationship_to_primary_borrower_type varchar(128) not null,
    b_relationship_to_seller_type varchar(128) not null,
    b_preferred_first_name varchar(32) not null,
    constraint fk_borrower_1
        foreign key (b_application_pid) references application (apl_pid),
    constraint fk_borrower_3
        foreign key (b_spouse_borrower_pid) references borrower (b_pid),
    constraint fk_borrower_4
        foreign key (b_credit_request_pid) references credit_request (crdr_pid),
    constraint fkt_b_alimony_child_support
        foreign key (b_alimony_child_support) references yes_no_unknown_type (code),
    constraint fkt_b_applicant_role_type
        foreign key (b_applicant_role_type) references applicant_role_type (code),
    constraint fkt_b_application_taken_method_type
        foreign key (b_application_taken_method_type) references application_taken_method_type (code),
    constraint fkt_b_bankruptcy
        foreign key (b_bankruptcy) references yes_no_unknown_type (code),
    constraint fkt_b_borrowed_down_payment
        foreign key (b_borrowed_down_payment) references yes_no_unknown_type (code),
    constraint fkt_b_borrower_tiny_id_type
        foreign key (b_borrower_tiny_id_type) references borrower_tiny_id_type (code),
    constraint fkt_b_citizenship_residency_type
        foreign key (b_citizenship_residency_type) references citizenship_residency_type (code),
    constraint fkt_b_credit_report_authorization_method
        foreign key (b_credit_report_authorization_method) references credit_authorization_method_type (code),
    constraint fkt_b_disabled
        foreign key (b_disabled) references yes_no_unknown_type (code),
    constraint fkt_b_ethnicity_collected_visual_or_surname
        foreign key (b_ethnicity_collected_visual_or_surname) references yes_no_unknown_type (code),
    constraint fkt_b_ethnicity_refused
        foreign key (b_ethnicity_refused) references yes_no_unknown_type (code),
    constraint fkt_b_has_dependents
        foreign key (b_has_dependents) references yes_no_unknown_type (code),
    constraint fkt_b_homeowner_past_three_years
        foreign key (b_homeowner_past_three_years) references yes_no_unknown_type (code),
    constraint fkt_b_homeownership_education_agency_type
        foreign key (b_homeownership_education_agency_type) references housing_counseling_agency_type (code),
    constraint fkt_b_homeownership_education_type
        foreign key (b_homeownership_education_type) references homeownership_education_type (code),
    constraint fkt_b_housing_counseling_agency_type
        foreign key (b_housing_counseling_agency_type) references housing_counseling_agency_type (code),
    constraint fkt_b_housing_counseling_type
        foreign key (b_housing_counseling_type) references housing_counseling_type (code),
    constraint fkt_b_intend_to_occupy
        foreign key (b_intend_to_occupy) references yes_no_unknown_type (code),
    constraint fkt_b_legal_entity_type
        foreign key (b_legal_entity_type) references legal_entity_type (code),
    constraint fkt_b_lender_employee
        foreign key (b_lender_employee) references yes_no_unknown_type (code),
    constraint fkt_b_marital_status_type
        foreign key (b_marital_status_type) references marital_status_type (code),
    constraint fkt_b_note_endorser
        foreign key (b_note_endorser) references yes_no_unknown_type (code),
    constraint fkt_b_obligated_loan_foreclosure
        foreign key (b_obligated_loan_foreclosure) references yes_no_unknown_type (code),
    constraint fkt_b_on_gsa_list
        foreign key (b_on_gsa_list) references yes_no_unknown_type (code),
    constraint fkt_b_on_ldp_list
        foreign key (b_on_ldp_list) references yes_no_unknown_type (code),
    constraint fkt_b_outstanding_judgements
        foreign key (b_outstanding_judgements) references yes_no_unknown_type (code),
    constraint fkt_b_party_to_lawsuit
        foreign key (b_party_to_lawsuit) references yes_no_unknown_type (code),
    constraint fkt_b_power_of_attorney
        foreign key (b_power_of_attorney) references yes_no_unknown_type (code),
    constraint fkt_b_power_of_attorney_country
        foreign key (b_power_of_attorney_country) references country_type (code),
    constraint fkt_b_presently_delinquent
        foreign key (b_presently_delinquent) references yes_no_unknown_type (code),
    constraint fkt_b_prior_property_title_type
        foreign key (b_prior_property_title_type) references prior_property_title_type (code),
    constraint fkt_b_prior_property_usage_type
        foreign key (b_prior_property_usage_type) references property_usage_type (code),
    constraint fkt_b_property_foreclosure
        foreign key (b_property_foreclosure) references yes_no_unknown_type (code),
    constraint fkt_b_race_collected_visual_or_surname
        foreign key (b_race_collected_visual_or_surname) references yes_no_unknown_type (code),
    constraint fkt_b_race_refused
        foreign key (b_race_refused) references yes_no_unknown_type (code),
    constraint fkt_b_relationship_to_primary_borrower_type
        foreign key (b_relationship_to_primary_borrower_type) references borrower_relationship_type (code),
    constraint fkt_b_relationship_to_seller_type
        foreign key (b_relationship_to_seller_type) references borrower_relationship_type (code),
    constraint fkt_b_sex_collected_visual_or_surname
        foreign key (b_sex_collected_visual_or_surname) references yes_no_unknown_type (code),
    constraint fkt_b_sex_refused
        foreign key (b_sex_refused) references yes_no_unknown_type (code),
    constraint fkt_b_spousal_homestead
        foreign key (b_spousal_homestead) references yes_no_unknown_type (code),
    constraint fkt_b_titleholder
        foreign key (b_titleholder) references yes_no_unknown_type (code)
);

create index idx_borrower_1
    on borrower (b_last_name);

create index idx_borrower_2
    on borrower (b_email);

create index idx_borrower_3
    on borrower (b_home_phone);

create index idx_borrower_4
    on borrower (b_mobile_phone);

create index idx_borrower_5
    on borrower (b_office_phone);

create table borrower_alias
(
    ba_pid bigint auto_increment
        primary key,
    ba_version int not null,
    ba_account_number varchar(32) null,
    ba_borrower_pid bigint not null,
    ba_credit_request_pid bigint null,
    ba_creditor_name varchar(32) null,
    ba_first_name varchar(32) null,
    ba_last_name varchar(32) null,
    ba_middle_name varchar(32) null,
    ba_name_suffix varchar(32) null,
    ba_credit_report_identifier varchar(32) not null,
    constraint fk_borrower_alias_1
        foreign key (ba_borrower_pid) references borrower (b_pid),
    constraint fk_borrower_alias_2
        foreign key (ba_credit_request_pid) references credit_request (crdr_pid)
);

create table borrower_asset
(
    bas_pid bigint auto_increment
        primary key,
    bas_version int not null,
    bas_borrower_pid bigint not null,
    bas_asset_pid bigint not null,
    constraint bas_borrower_pid
        unique (bas_borrower_pid, bas_asset_pid),
    constraint fk_borrower_asset_1
        foreign key (bas_borrower_pid) references borrower (b_pid),
    constraint fk_borrower_asset_2
        foreign key (bas_asset_pid) references asset (as_pid)
);

create table borrower_associated_address
(
    baa_pid bigint auto_increment
        primary key,
    baa_version int not null,
    baa_borrower_pid bigint not null,
    baa_credit_request_pid bigint null,
    baa_credit_report_identifier varchar(32) not null,
    baa_borrower_associated_address_source_type varchar(128) not null,
    baa_reported_month int null,
    baa_reported_year int null,
    baa_reported_date_verified bit not null,
    baa_reported_address_street1 varchar(128) not null,
    baa_reported_address_street2 varchar(128) not null,
    baa_reported_address_city varchar(128) not null,
    baa_reported_address_state varchar(128) not null,
    baa_reported_address_postal_code varchar(128) not null,
    baa_reported_address_country varchar(16) not null,
    baa_current varchar(128) not null,
    baa_internal_note varchar(1024) not null,
    baa_requires_explanation bit not null,
    baa_force_requires_explanation bit not null,
    baa_borrower_associated_address_explanation_type varchar(128) not null,
    baa_explanation_type_other_explanation varchar(128) not null,
    baa_typo_of_loan_app_address varchar(128) not null,
    baa_known_to_borrower varchar(128) not null,
    baa_owned_by_borrower varchar(128) not null,
    baa_resided_at_address varchar(128) not null,
    baa_used_as_mailing_address varchar(128) not null,
    baa_current_mailing_address varchar(128) not null,
    baa_current_residence varchar(128) not null,
    baa_borrower_resided_at_address_after_date varchar(128) not null,
    constraint fk_borrower_associated_address_1
        foreign key (baa_borrower_pid) references borrower (b_pid),
    constraint fk_borrower_associated_address_2
        foreign key (baa_credit_request_pid) references credit_request (crdr_pid),
    constraint fkt_baa_borrower_associated_address_explanation_type
        foreign key (baa_borrower_associated_address_explanation_type) references borrower_associated_address_explanation_type (code),
    constraint fkt_baa_borrower_associated_address_source_type
        foreign key (baa_borrower_associated_address_source_type) references borrower_associated_address_source_type (code),
    constraint fkt_baa_borrower_resided_at_address_after_date
        foreign key (baa_borrower_resided_at_address_after_date) references yes_no_unknown_type (code),
    constraint fkt_baa_current
        foreign key (baa_current) references yes_no_unknown_type (code),
    constraint fkt_baa_current_mailing_address
        foreign key (baa_current_mailing_address) references yes_no_unknown_type (code),
    constraint fkt_baa_current_residence
        foreign key (baa_current_residence) references yes_no_unknown_type (code),
    constraint fkt_baa_known_to_borrower
        foreign key (baa_known_to_borrower) references yes_no_unknown_type (code),
    constraint fkt_baa_owned_by_borrower
        foreign key (baa_owned_by_borrower) references yes_no_unknown_type (code),
    constraint fkt_baa_resided_at_address
        foreign key (baa_resided_at_address) references yes_no_unknown_type (code),
    constraint fkt_baa_typo_of_loan_app_address
        foreign key (baa_typo_of_loan_app_address) references yes_no_unknown_type (code),
    constraint fkt_baa_used_as_mailing_address
        foreign key (baa_used_as_mailing_address) references yes_no_unknown_type (code)
);

create table borrower_dependent
(
    bd_pid bigint auto_increment
        primary key,
    bd_version int not null,
    bd_borrower_pid bigint not null,
    bd_first_name varchar(32) not null,
    bd_last_name varchar(32) not null,
    bd_age int null,
    bd_disabled varchar(128) null,
    bd_full_time_student varchar(128) null,
    bd_receives_income varchar(128) null,
    bd_income_source text null,
    bd_income_amount decimal(15,2) not null,
    constraint fk_borrower_dependent_1
        foreign key (bd_borrower_pid) references borrower (b_pid)
);

create table borrower_income
(
    bi_pid bigint auto_increment
        primary key,
    bi_version int not null,
    bi_borrower_pid bigint not null,
    bi_borrower_income_category_type varchar(128) not null,
    bi_job_gap_reason_type varchar(128) not null,
    bi_job_gap_reason_explanation varchar(1024) not null,
    bi_business_ownership_type varchar(128) not null,
    bi_from_date date not null,
    bi_through_date date null,
    bi_current bit null,
    bi_primary bit null,
    bi_source_name varchar(128) null,
    bi_source_address_street1 varchar(128) not null,
    bi_source_address_street2 varchar(128) not null,
    bi_source_address_city varchar(128) not null,
    bi_source_address_state varchar(128) not null,
    bi_source_address_postal_code varchar(128) not null,
    bi_source_address_country varchar(128) not null,
    bi_source_phone varchar(32) null,
    bi_source_phone_extension varchar(16) null,
    bi_synthetic_unique bit null,
    constraint uk_borrower_income_1
        unique (bi_borrower_pid, bi_synthetic_unique),
    constraint fk_borrower_income_1
        foreign key (bi_borrower_pid) references borrower (b_pid),
    constraint fkt_bi_borrower_income_category_type
        foreign key (bi_borrower_income_category_type) references borrower_income_category_type (code),
    constraint fkt_bi_business_ownership_type
        foreign key (bi_business_ownership_type) references business_ownership_type (code),
    constraint fkt_bi_job_gap_reason_type
        foreign key (bi_job_gap_reason_type) references job_gap_reason_type (code),
    constraint fkt_bi_source_address_country
        foreign key (bi_source_address_country) references country_type (code)
);

create table borrower_job_gap
(
    bjg_pid bigint auto_increment
        primary key,
    bjg_version int not null,
    bjg_borrower_pid bigint not null,
    bjg_from_date date not null,
    bjg_through_date date null,
    bjg_primary_job bit null,
    constraint fk_borrower_job_gap_1
        foreign key (bjg_borrower_pid) references borrower (b_pid)
);

create table borrower_user_deal
(
    bud_pid bigint auto_increment
        primary key,
    bud_version int not null,
    bud_borrower_user_pid bigint not null,
    bud_deal_pid bigint not null,
    bud_borrower_pid bigint not null,
    bud_borrower_user_deal_access_type varchar(128) not null,
    bud_loan_key varchar(128) null,
    bud_electronic_transaction_consent bit not null,
    bud_electronic_transaction_consent_datetime datetime null,
    bud_electronic_transaction_consent_ip_address varchar(32) null,
    bud_create_datetime datetime not null,
    constraint uk_borrower_user_deal_1
        unique (bud_borrower_pid),
    constraint fk_borrower_user_deal_1
        foreign key (bud_borrower_user_pid) references borrower_user (bu_pid),
    constraint fk_borrower_user_deal_2
        foreign key (bud_deal_pid) references deal (d_pid),
    constraint fk_borrower_user_deal_3
        foreign key (bud_borrower_pid) references borrower (b_pid),
    constraint fkt_bud_borrower_user_deal_access_type
        foreign key (bud_borrower_user_deal_access_type) references borrower_user_deal_access_type (code)
);

create table borrower_user_change_email
(
    buce_pid bigint auto_increment
        primary key,
    buce_version int not null,
    buce_borrower_user_pid bigint not null,
    buce_create_datetime datetime not null,
    buce_change_email_id varchar(128) not null,
    buce_email varchar(256) not null,
    buce_borrower_user_deal_pid bigint null,
    constraint buce_borrower_user_pid
        unique (buce_borrower_user_pid),
    constraint buce_change_email_id
        unique (buce_change_email_id),
    constraint fk_borrower_user_change_email_1
        foreign key (buce_borrower_user_pid) references borrower_user (bu_pid),
    constraint fk_borrower_user_change_email_2
        foreign key (buce_borrower_user_deal_pid) references borrower_user_deal (bud_pid)
);

create index idx_borrower_user_change_email_1
    on borrower_user_change_email (buce_change_email_id);

create index idx_borrower_user_change_email_2
    on borrower_user_change_email (buce_email);

create index idx_borrower_user_deal_1
    on borrower_user_deal (bud_loan_key);

create table business_income
(
    bui_pid bigint auto_increment
        primary key,
    bui_version int not null,
    bui_borrower_income_pid bigint not null,
    bui_business_income_type varchar(128) not null,
    bui_business_disposition_type varchar(128) not null,
    bui_company_ein varchar(16) null,
    bui_estimated_net_income_amount decimal(15,2) not null,
    bui_estimated_mode bit null,
    bui_worksheet_monthly_total_amount decimal(15,2) not null,
    bui_monthly_total_amount decimal(15,2) not null,
    bui_borrower_income_percent decimal(11,9) not null,
    bui_calc_method_type varchar(128) not null,
    bui_common_year1_year int null,
    bui_common_year1_year_include bit null,
    bui_common_year1_from_date date null,
    bui_common_year1_through_date date null,
    bui_common_year1_months decimal(4,2) null,
    bui_common_year1_annual_total_amount decimal(15,2) null,
    bui_common_year1_monthly_total_amount decimal(15,2) not null,
    bui_common_year2_year int null,
    bui_common_year2_year_include bit null,
    bui_common_year2_from_date date null,
    bui_common_year2_through_date date null,
    bui_common_year2_months decimal(4,2) null,
    bui_common_year2_annual_total_amount decimal(15,2) null,
    bui_common_year2_monthly_total_amount decimal(15,2) not null,
    bui_common_year3_year int null,
    bui_common_year3_year_include bit null,
    bui_common_year3_from_date date null,
    bui_common_year3_through_date date null,
    bui_common_year3_months decimal(4,2) null,
    bui_common_year3_annual_total_amount decimal(15,2) null,
    bui_common_year3_monthly_total_amount decimal(15,2) not null,
    bui_sole_year1_gross_receipts decimal(15,2) not null,
    bui_sole_year1_other_income_loss_exp decimal(15,2) not null,
    bui_sole_year1_depletion decimal(15,2) not null,
    bui_sole_year1_depreciation decimal(15,2) not null,
    bui_sole_year1_meal_exclusions decimal(15,2) not null,
    bui_sole_year1_business_use_home decimal(15,2) not null,
    bui_sole_year1_amortization_loss decimal(15,2) not null,
    bui_sole_year1_business_miles int null,
    bui_sole_year1_depreciation_mile decimal(11,9) not null,
    bui_sole_year1_mileage_depreciation decimal(15,2) not null,
    bui_sole_year2_gross_receipts decimal(15,2) not null,
    bui_sole_year2_other_income_loss_exp decimal(15,2) not null,
    bui_sole_year2_depletion decimal(15,2) not null,
    bui_sole_year2_depreciation decimal(15,2) not null,
    bui_sole_year2_meal_exclusions decimal(15,2) not null,
    bui_sole_year2_business_use_home decimal(15,2) not null,
    bui_sole_year2_amortization_loss decimal(15,2) not null,
    bui_sole_year2_business_miles int null,
    bui_sole_year2_depreciation_mile decimal(11,9) not null,
    bui_sole_year2_mileage_depreciation decimal(15,2) not null,
    bui_sole_year3_gross_receipts decimal(15,2) not null,
    bui_sole_year3_other_income_loss_exp decimal(15,2) not null,
    bui_sole_year3_depletion decimal(15,2) not null,
    bui_sole_year3_depreciation decimal(15,2) not null,
    bui_sole_year3_meal_exclusions decimal(15,2) not null,
    bui_sole_year3_business_use_home decimal(15,2) not null,
    bui_sole_year3_amortization_loss decimal(15,2) not null,
    bui_sole_year3_business_miles int null,
    bui_sole_year3_depreciation_mile decimal(11,9) not null,
    bui_sole_year3_mileage_depreciation decimal(15,2) not null,
    bui_partner_year1_amortization_loss decimal(15,2) not null,
    bui_partner_year1_depletion decimal(15,2) not null,
    bui_partner_year1_depreciation decimal(15,2) not null,
    bui_partner_year1_guaranteed_payments decimal(15,2) not null,
    bui_partner_year1_meals_exclusion decimal(15,2) not null,
    bui_partner_year1_net_rental_income_loss decimal(15,2) not null,
    bui_partner_year1_notes_payable_less_year decimal(15,2) not null,
    bui_partner_year1_ordinary_income_loss decimal(15,2) not null,
    bui_partner_year1_other_income_loss decimal(15,2) not null,
    bui_partner_year1_ownership_percent decimal(11,9) not null,
    bui_partner_year1_form_k_1_total decimal(15,2) not null,
    bui_partner_year1_form_1065_subtotal decimal(15,2) not null,
    bui_partner_year1_form_1065_total decimal(15,2) not null,
    bui_partner_year2_amortization_loss decimal(15,2) not null,
    bui_partner_year2_depletion decimal(15,2) not null,
    bui_partner_year2_depreciation decimal(15,2) not null,
    bui_partner_year2_guaranteed_payments decimal(15,2) not null,
    bui_partner_year2_meals_exclusion decimal(15,2) not null,
    bui_partner_year2_net_rental_income_loss decimal(15,2) not null,
    bui_partner_year2_notes_payable_less_year decimal(15,2) not null,
    bui_partner_year2_ordinary_income_loss decimal(15,2) not null,
    bui_partner_year2_other_income_loss decimal(15,2) not null,
    bui_partner_year2_ownership_percent decimal(11,9) not null,
    bui_partner_year2_form_k_1_total decimal(15,2) not null,
    bui_partner_year2_form_1065_subtotal decimal(15,2) not null,
    bui_partner_year2_form_1065_total decimal(15,2) not null,
    bui_partner_year3_amortization_loss decimal(15,2) not null,
    bui_partner_year3_depletion decimal(15,2) not null,
    bui_partner_year3_depreciation decimal(15,2) not null,
    bui_partner_year3_guaranteed_payments decimal(15,2) not null,
    bui_partner_year3_meals_exclusion decimal(15,2) not null,
    bui_partner_year3_net_rental_income_loss decimal(15,2) not null,
    bui_partner_year3_notes_payable_less_year decimal(15,2) not null,
    bui_partner_year3_ordinary_income_loss decimal(15,2) not null,
    bui_partner_year3_other_income_loss decimal(15,2) not null,
    bui_partner_year3_ownership_percent decimal(11,9) not null,
    bui_partner_year3_form_k_1_total decimal(15,2) not null,
    bui_partner_year3_form_1065_subtotal decimal(15,2) not null,
    bui_partner_year3_form_1065_total decimal(15,2) not null,
    bui_form_1065_available bit null,
    bui_scorp_year1_ordinary_income_loss decimal(15,2) not null,
    bui_scorp_year1_net_rental_income_loss decimal(15,2) not null,
    bui_scorp_year1_other_income_loss decimal(15,2) not null,
    bui_scorp_year1_depletion decimal(15,2) not null,
    bui_scorp_year1_depreciation decimal(15,2) not null,
    bui_scorp_year1_amortization_loss decimal(15,2) not null,
    bui_scorp_year1_notes_payable_less_year decimal(15,2) not null,
    bui_scorp_year1_meals_exclusion decimal(15,2) not null,
    bui_scorp_year1_ownership_percent decimal(11,9) not null,
    bui_scorp_year1_form_k_1_total decimal(15,2) not null,
    bui_scorp_year1_form_1120s_subtotal decimal(15,2) not null,
    bui_scorp_year1_form_1120s_total decimal(15,2) not null,
    bui_scorp_year2_ordinary_income_loss decimal(15,2) not null,
    bui_scorp_year2_net_rental_income_loss decimal(15,2) not null,
    bui_scorp_year2_other_income_loss decimal(15,2) not null,
    bui_scorp_year2_depletion decimal(15,2) not null,
    bui_scorp_year2_depreciation decimal(15,2) not null,
    bui_scorp_year2_amortization_loss decimal(15,2) not null,
    bui_scorp_year2_notes_payable_less_year decimal(15,2) not null,
    bui_scorp_year2_meals_exclusion decimal(15,2) not null,
    bui_scorp_year2_ownership_percent decimal(11,9) not null,
    bui_scorp_year2_form_k_1_total decimal(15,2) not null,
    bui_scorp_year2_form_1120s_subtotal decimal(15,2) not null,
    bui_scorp_year2_form_1120s_total decimal(15,2) not null,
    bui_scorp_year3_ordinary_income_loss decimal(15,2) not null,
    bui_scorp_year3_net_rental_income_loss decimal(15,2) not null,
    bui_scorp_year3_other_income_loss decimal(15,2) not null,
    bui_scorp_year3_depletion decimal(15,2) not null,
    bui_scorp_year3_depreciation decimal(15,2) not null,
    bui_scorp_year3_amortization_loss decimal(15,2) not null,
    bui_scorp_year3_notes_payable_less_year decimal(15,2) not null,
    bui_scorp_year3_meals_exclusion decimal(15,2) not null,
    bui_scorp_year3_ownership_percent decimal(11,9) not null,
    bui_scorp_year3_form_k_1_total decimal(15,2) not null,
    bui_scorp_year3_form_1120s_subtotal decimal(15,2) not null,
    bui_scorp_year3_form_1120s_total decimal(15,2) not null,
    bui_form_1120s_available bit null,
    bui_corp_year1_taxable_income decimal(15,2) not null,
    bui_corp_year1_total_tax decimal(15,2) not null,
    bui_corp_year1_gain_loss decimal(15,2) not null,
    bui_corp_year1_other_income_loss decimal(15,2) not null,
    bui_corp_year1_depreciation decimal(15,2) not null,
    bui_corp_year1_depletion decimal(15,2) not null,
    bui_corp_year1_domestic_production_activities decimal(15,2) not null,
    bui_corp_year1_other_deductions decimal(15,2) not null,
    bui_corp_year1_net_operating_loss_special_deductions decimal(15,2) not null,
    bui_corp_year1_notes_payable_less_one_year decimal(15,2) not null,
    bui_corp_year1_meals_exclusion decimal(15,2) not null,
    bui_corp_year1_dividends_paid_to_borrower decimal(15,2) not null,
    bui_corp_year1_annual_subtotal decimal(15,2) not null,
    bui_corp_year1_ownership_percent decimal(11,9) not null,
    bui_corp_year1_annual_subtotal_ownership_applied decimal(15,2) not null,
    bui_corp_year2_taxable_income decimal(15,2) not null,
    bui_corp_year2_total_tax decimal(15,2) not null,
    bui_corp_year2_gain_loss decimal(15,2) not null,
    bui_corp_year2_other_income_loss decimal(15,2) not null,
    bui_corp_year2_depreciation decimal(15,2) not null,
    bui_corp_year2_depletion decimal(15,2) not null,
    bui_corp_year2_domestic_production_activities decimal(15,2) not null,
    bui_corp_year2_other_deductions decimal(15,2) not null,
    bui_corp_year2_net_operating_loss_special_deductions decimal(15,2) not null,
    bui_corp_year2_notes_payable_less_one_year decimal(15,2) not null,
    bui_corp_year2_meals_exclusion decimal(15,2) not null,
    bui_corp_year2_dividends_paid_to_borrower decimal(15,2) not null,
    bui_corp_year2_annual_subtotal decimal(15,2) not null,
    bui_corp_year2_ownership_percent decimal(11,9) not null,
    bui_corp_year2_annual_subtotal_ownership_applied decimal(15,2) not null,
    bui_corp_year3_taxable_income decimal(15,2) not null,
    bui_corp_year3_total_tax decimal(15,2) not null,
    bui_corp_year3_gain_loss decimal(15,2) not null,
    bui_corp_year3_other_income_loss decimal(15,2) not null,
    bui_corp_year3_depreciation decimal(15,2) not null,
    bui_corp_year3_depletion decimal(15,2) not null,
    bui_corp_year3_domestic_production_activities decimal(15,2) not null,
    bui_corp_year3_other_deductions decimal(15,2) not null,
    bui_corp_year3_net_operating_loss_special_deductions decimal(15,2) not null,
    bui_corp_year3_notes_payable_less_one_year decimal(15,2) not null,
    bui_corp_year3_meals_exclusion decimal(15,2) not null,
    bui_corp_year3_dividends_paid_to_borrower decimal(15,2) not null,
    bui_corp_year3_annual_subtotal decimal(15,2) not null,
    bui_corp_year3_ownership_percent decimal(11,9) not null,
    bui_corp_year3_annual_subtotal_ownership_applied decimal(15,2) not null,
    bui_sch_f_year1_specific_income_loss decimal(15,2) not null,
    bui_sch_f_year1_nonrecurring_income_loss decimal(15,2) not null,
    bui_sch_f_year1_depreciation decimal(15,2) not null,
    bui_sch_f_year1_amortization_loss_depletion decimal(15,2) not null,
    bui_sch_f_year1_business_use_home decimal(15,2) not null,
    bui_sch_f_year2_specific_income_loss decimal(15,2) not null,
    bui_sch_f_year2_nonrecurring_income_loss decimal(15,2) not null,
    bui_sch_f_year2_depreciation decimal(15,2) not null,
    bui_sch_f_year2_amortization_loss_depletion decimal(15,2) not null,
    bui_sch_f_year2_business_use_home decimal(15,2) not null,
    bui_sch_f_year3_specific_income_loss decimal(15,2) not null,
    bui_sch_f_year3_nonrecurring_income_loss decimal(15,2) not null,
    bui_sch_f_year3_depreciation decimal(15,2) not null,
    bui_sch_f_year3_amortization_loss_depletion decimal(15,2) not null,
    bui_sch_f_year3_business_use_home decimal(15,2) not null,
    bui_underwriter_comments varchar(1024) null,
    constraint uk_business_income_1
        unique (bui_borrower_income_pid),
    constraint fk_business_income_1
        foreign key (bui_borrower_income_pid) references borrower_income (bi_pid),
    constraint fkt_bui_business_disposition_type
        foreign key (bui_business_disposition_type) references business_disposition_type (code),
    constraint fkt_bui_business_income_type
        foreign key (bui_business_income_type) references business_income_type (code),
    constraint fkt_bui_calc_method_type
        foreign key (bui_calc_method_type) references income_history_calc_method_type (code)
);

create table consumer_privacy_affected_borrower
(
    cpab_pid bigint auto_increment
        primary key,
    cpab_version int not null,
    cpab_consumer_privacy_request_pid bigint not null,
    cpab_deal_pid bigint not null,
    cpab_borrower_pid bigint not null,
    constraint fk_consumer_privacy_affected_borrower_1
        foreign key (cpab_consumer_privacy_request_pid) references consumer_privacy_request (cpr_pid),
    constraint fk_consumer_privacy_affected_borrower_2
        foreign key (cpab_deal_pid) references deal (d_pid),
    constraint fk_consumer_privacy_affected_borrower_3
        foreign key (cpab_borrower_pid) references borrower (b_pid)
);

create table job_income
(
    ji_pid bigint auto_increment
        primary key,
    ji_version int not null,
    ji_borrower_income_pid bigint not null,
    ji_estimated_mode bit null,
    ji_line_of_work_years int null,
    ji_voe_written_required bit null,
    ji_voe_written_system bit null,
    ji_voe_written_forced bit null,
    ji_base_income_calc_method_type varchar(128) not null,
    ji_monthly_base_unadjusted_amount decimal(15,2) not null,
    ji_monthly_base_adjustment_amount decimal(15,2) not null,
    ji_overtime_income_calc_method_type varchar(128) not null,
    ji_monthly_overtime_unadjusted_amount decimal(15,2) not null,
    ji_monthly_overtime_adjustment_amount decimal(15,2) not null,
    ji_bonus_income_calc_method_type varchar(128) not null,
    ji_monthly_bonus_unadjusted_amount decimal(15,2) not null,
    ji_monthly_bonus_adjustment_amount decimal(15,2) not null,
    ji_commissions_income_calc_method_type varchar(128) not null,
    ji_monthly_commissions_unadjusted_amount decimal(15,2) not null,
    ji_monthly_commissions_adjustment_amount decimal(15,2) not null,
    ji_tip_income_calc_method_type varchar(128) not null,
    ji_monthly_tip_unadjusted_amount decimal(15,2) not null,
    ji_monthly_tip_adjustment_amount decimal(15,2) not null,
    ji_adjustment_income_calc_method_type varchar(128) not null,
    ji_monthly_adjustment_amount decimal(15,2) not null,
    ji_position varchar(32) null,
    ji_employer_relative bit null,
    ji_employer_property_seller bit null,
    ji_employer_real_estate_broker bit null,
    ji_military_job bit null,
    ji_estimated_monthly_military_amount decimal(15,2) not null,
    ji_monthly_military_base_pay_amount decimal(15,2) not null,
    ji_monthly_military_clothes_allowance_ungrossed_amount decimal(15,2) not null,
    ji_monthly_military_combat_pay_amount decimal(15,2) not null,
    ji_monthly_military_flight_pay_amount decimal(15,2) not null,
    ji_monthly_military_hazard_pay_amount decimal(15,2) not null,
    ji_monthly_military_housing_allowance_ungrossed_amount decimal(15,2) not null,
    ji_monthly_military_overseas_pay_amount decimal(15,2) not null,
    ji_monthly_military_prop_pay_amount decimal(15,2) not null,
    ji_monthly_military_quarters_allowance_ungrossed_amount decimal(15,2) not null,
    ji_monthly_military_rations_allowance_ungrossed_amount decimal(15,2) not null,
    ji_military_gross_up bit null,
    ji_military_gross_up_percent decimal(11,9) not null,
    ji_monthly_military_clothes_allowance_amount decimal(15,2) not null,
    ji_monthly_military_quarters_allowance_amount decimal(15,2) not null,
    ji_monthly_military_rations_allowance_amount decimal(15,2) not null,
    ji_monthly_military_housing_allowance_amount decimal(15,2) not null,
    ji_military_pay_subtotal_amount decimal(15,2) not null,
    ji_military_allowance_subtotal_amount decimal(15,2) not null,
    ji_monthly_military_total_amount decimal(15,2) not null,
    ji_annual_military_total_amount decimal(15,2) not null,
    ji_job_year1_year int null,
    ji_job_year1_year_include bit null,
    ji_job_year1_from_date date null,
    ji_job_year1_through_date date null,
    ji_job_year1_months decimal(4,2) null,
    ji_job_year1_base_input_amount decimal(15,2) not null,
    ji_job_year1_monthly_base_amount decimal(15,2) not null,
    ji_job_year1_overtime_input_amount decimal(15,2) not null,
    ji_job_year1_monthly_overtime_amount decimal(15,2) not null,
    ji_job_year1_bonus_input_amount decimal(15,2) not null,
    ji_job_year1_monthly_bonus_amount decimal(15,2) not null,
    ji_job_year1_commissions_input_amount decimal(15,2) not null,
    ji_job_year1_monthly_commissions_amount decimal(15,2) not null,
    ji_job_year1_tip_input_amount decimal(15,2) not null,
    ji_job_year1_monthly_tip_amount decimal(15,2) not null,
    ji_job_year1_adjustment_input_amount decimal(15,2) not null,
    ji_job_year1_monthly_adjustment_amount decimal(15,2) not null,
    ji_job_year1_monthly_total_amount decimal(15,2) not null,
    ji_job_year1_annual_total_amount decimal(15,2) not null,
    ji_job_year1_monthly_total_commissions_percent decimal(11,9) not null,
    ji_job_year2_year int null,
    ji_job_year2_year_include bit null,
    ji_job_year2_from_date date null,
    ji_job_year2_through_date date null,
    ji_job_year2_months decimal(4,2) null,
    ji_job_year2_base_input_amount decimal(15,2) not null,
    ji_job_year2_monthly_base_amount decimal(15,2) not null,
    ji_job_year2_overtime_input_amount decimal(15,2) not null,
    ji_job_year2_monthly_overtime_amount decimal(15,2) not null,
    ji_job_year2_bonus_input_amount decimal(15,2) not null,
    ji_job_year2_monthly_bonus_amount decimal(15,2) not null,
    ji_job_year2_commissions_input_amount decimal(15,2) not null,
    ji_job_year2_monthly_commissions_amount decimal(15,2) not null,
    ji_job_year2_tip_input_amount decimal(15,2) not null,
    ji_job_year2_monthly_tip_amount decimal(15,2) not null,
    ji_job_year2_adjustment_input_amount decimal(15,2) not null,
    ji_job_year2_monthly_adjustment_amount decimal(15,2) not null,
    ji_job_year2_monthly_total_amount decimal(15,2) not null,
    ji_job_year2_annual_total_amount decimal(15,2) not null,
    ji_job_year2_monthly_total_commissions_percent decimal(11,9) not null,
    ji_job_year3_year int null,
    ji_job_year3_year_include bit null,
    ji_job_year3_from_date date null,
    ji_job_year3_through_date date null,
    ji_job_year3_months decimal(4,2) null,
    ji_job_year3_base_input_amount decimal(15,2) not null,
    ji_job_year3_monthly_base_amount decimal(15,2) not null,
    ji_job_year3_overtime_input_amount decimal(15,2) not null,
    ji_job_year3_monthly_overtime_amount decimal(15,2) not null,
    ji_job_year3_bonus_input_amount decimal(15,2) not null,
    ji_job_year3_monthly_bonus_amount decimal(15,2) not null,
    ji_job_year3_commissions_input_amount decimal(15,2) not null,
    ji_job_year3_monthly_commissions_amount decimal(15,2) not null,
    ji_job_year3_tip_input_amount decimal(15,2) not null,
    ji_job_year3_monthly_tip_amount decimal(15,2) not null,
    ji_job_year3_adjustment_input_amount decimal(15,2) not null,
    ji_job_year3_monthly_adjustment_amount decimal(15,2) not null,
    ji_job_year3_monthly_total_amount decimal(15,2) not null,
    ji_job_year3_annual_total_amount decimal(15,2) not null,
    ji_job_year3_monthly_total_commissions_percent decimal(11,9) not null,
    ji_estimated_monthly_base_amount decimal(15,2) not null,
    ji_estimated_monthly_bonus_amount decimal(15,2) not null,
    ji_estimated_monthly_overtime_amount decimal(15,2) not null,
    ji_estimated_monthly_commissions_amount decimal(15,2) not null,
    ji_estimated_monthly_tip_amount decimal(15,2) not null,
    ji_estimated_monthly_total_amount decimal(15,2) not null,
    ji_estimated_annual_total_amount decimal(15,2) not null,
    ji_estimated_monthly_total_commissions_percent decimal(11,9) not null,
    ji_worksheet_monthly_base_amount decimal(15,2) not null,
    ji_worksheet_monthly_bonus_amount decimal(15,2) not null,
    ji_worksheet_monthly_overtime_amount decimal(15,2) not null,
    ji_worksheet_monthly_commissions_amount decimal(15,2) not null,
    ji_worksheet_monthly_tip_amount decimal(15,2) not null,
    ji_worksheet_monthly_total_amount decimal(15,2) not null,
    ji_worksheet_annual_total_amount decimal(15,2) not null,
    ji_worksheet_monthly_total_commissions_percent decimal(11,9) not null,
    ji_working_monthly_base_amount decimal(15,2) not null,
    ji_working_monthly_bonus_amount decimal(15,2) not null,
    ji_working_monthly_overtime_amount decimal(15,2) not null,
    ji_working_monthly_commissions_amount decimal(15,2) not null,
    ji_working_monthly_tip_amount decimal(15,2) not null,
    ji_working_monthly_total_amount decimal(15,2) not null,
    ji_working_annual_total_amount decimal(15,2) not null,
    ji_working_monthly_total_commissions_percent decimal(11,9) not null,
    ji_underwriter_comments varchar(1024) null,
    ji_foreign_income bit null,
    ji_seasonal_income bit null,
    ji_voe_third_party_verifier_order_id varchar(16) not null,
    ji_employer_voe_name varchar(128) null,
    ji_employer_voe_title varchar(128) null,
    ji_employer_voe_phone varchar(32) null,
    ji_employer_voe_phone_extension varchar(16) null,
    ji_employer_voe_fax varchar(32) null,
    ji_employer_voe_email varchar(256) null,
    ji_phone_voe_verify_method_type varchar(128) not null,
    ji_address_voe_verify_method_type varchar(128) not null,
    ji_verified_date date null,
    ji_verified_by varchar(128) null,
    ji_voe_verbal_verify_method_type varchar(128) not null,
    ji_voe_third_party_verifier_type varchar(128) not null,
    ji_employer_other_interested_party bit not null,
    ji_employer_other_interested_party_description varchar(128) null,
    constraint fk_job_income_1
        foreign key (ji_borrower_income_pid) references borrower_income (bi_pid),
    constraint fkt_ji_address_voe_verify_method_type
        foreign key (ji_address_voe_verify_method_type) references voe_verify_method_type (code),
    constraint fkt_ji_adjustment_income_calc_method_type
        foreign key (ji_adjustment_income_calc_method_type) references income_history_calc_method_type (code),
    constraint fkt_ji_base_income_calc_method_type
        foreign key (ji_base_income_calc_method_type) references income_history_calc_method_type (code),
    constraint fkt_ji_bonus_income_calc_method_type
        foreign key (ji_bonus_income_calc_method_type) references income_history_calc_method_type (code),
    constraint fkt_ji_commissions_income_calc_method_type
        foreign key (ji_commissions_income_calc_method_type) references income_history_calc_method_type (code),
    constraint fkt_ji_overtime_income_calc_method_type
        foreign key (ji_overtime_income_calc_method_type) references income_history_calc_method_type (code),
    constraint fkt_ji_phone_voe_verify_method_type
        foreign key (ji_phone_voe_verify_method_type) references voe_verify_method_type (code),
    constraint fkt_ji_tip_income_calc_method_type
        foreign key (ji_tip_income_calc_method_type) references income_history_calc_method_type (code),
    constraint fkt_ji_voe_third_party_verifier_type
        foreign key (ji_voe_third_party_verifier_type) references voe_third_party_verifier_type (code),
    constraint fkt_ji_voe_verbal_verify_method_type
        foreign key (ji_voe_verbal_verify_method_type) references voe_verbal_verify_method_type (code)
);

create table lp_finding
(
    lpf_pid bigint auto_increment
        primary key,
    lpf_version int not null,
    lpf_lp_request_pid bigint not null,
    lpf_lp_finding_message_type varchar(128) not null,
    lpf_finding_yes_no_unknown_type varchar(128) not null,
    lpf_finding_value varchar(128) not null,
    constraint uk_lp_finding_1
        unique (lpf_lp_request_pid, lpf_lp_finding_message_type),
    constraint fk_lp_finding_1
        foreign key (lpf_lp_request_pid) references lp_request (lpr_pid),
    constraint fkt_lpf_finding_yes_no_unknown_type
        foreign key (lpf_finding_yes_no_unknown_type) references yes_no_unknown_type (code),
    constraint fkt_lpf_lp_finding_message_type
        foreign key (lpf_lp_finding_message_type) references lp_finding_message_type (code)
);

create table lp_request_credit
(
    lprc_pid bigint auto_increment
        primary key,
    lprc_version int not null,
    lprc_lp_request_pid bigint not null,
    lprc_create_datetime datetime not null,
    lprc_credit_report_create_datetime datetime null,
    lprc_credit_bureau_type varchar(128) not null,
    lprc_credit_report_identifier varchar(32) not null,
    lprc_credit_report_name varchar(256) not null,
    lprc_aus_credit_service_type varchar(128) not null,
    lprc_borrower_1_ssn varchar(128) null,
    lprc_borrower_2_ssn varchar(128) null,
    lprc_borrower_1_borrower_tiny_id_type varchar(128) not null,
    lprc_borrower_2_borrower_tiny_id_type varchar(128) null,
    constraint fk_lp_request_credit_1
        foreign key (lprc_lp_request_pid) references lp_request (lpr_pid),
    constraint fkt_lprc_aus_credit_service_type
        foreign key (lprc_aus_credit_service_type) references aus_credit_service_type (code),
    constraint fkt_lprc_borrower_1_borrower_tiny_id_type
        foreign key (lprc_borrower_1_borrower_tiny_id_type) references borrower_tiny_id_type (code),
    constraint fkt_lprc_borrower_2_borrower_tiny_id_type
        foreign key (lprc_borrower_2_borrower_tiny_id_type) references borrower_tiny_id_type (code),
    constraint fkt_lprc_credit_bureau_type
        foreign key (lprc_credit_bureau_type) references credit_bureau_type (code)
);

create table mers_daily_report
(
    medr_pid bigint auto_increment
        primary key,
    medr_version int not null,
    medr_account_pid bigint not null,
    medr_create_datetime datetime not null,
    medr_report_date date not null,
    medr_import_status_type varchar(128) not null,
    medr_import_status_messages text not null,
    medr_import_attempt_count int not null,
    medr_imported_loan_count int not null,
    medr_consolidated_report_text_repository_file_pid bigint null,
    constraint uk_mers_daily_report_1
        unique (medr_account_pid, medr_report_date),
    constraint fk_mers_daily_report_1
        foreign key (medr_account_pid) references account (a_pid),
    constraint fk_mers_daily_report_2
        foreign key (medr_consolidated_report_text_repository_file_pid) references repository_file (rf_pid),
    constraint fkt_medr_import_status_type
        foreign key (medr_import_status_type) references mers_daily_report_import_status_type (code)
);

create table military_service
(
    ms_pid bigint auto_increment
        primary key,
    ms_version int not null,
    ms_borrower_pid bigint not null,
    ms_from_date date not null,
    ms_through_date date null,
    ms_name_used_during_service varchar(128) null,
    ms_service_number varchar(32) null,
    ms_military_branch_type varchar(128) not null,
    ms_military_service_type varchar(128) not null,
    ms_military_status_type varchar(128) not null,
    constraint fk_military_service_1
        foreign key (ms_borrower_pid) references borrower (b_pid),
    constraint fkt_ms_military_branch_type
        foreign key (ms_military_branch_type) references military_branch_type (code),
    constraint fkt_ms_military_service_type
        foreign key (ms_military_service_type) references military_service_type (code),
    constraint fkt_ms_military_status_type
        foreign key (ms_military_status_type) references military_status_type (code)
);

create table other_income
(
    oi_pid bigint auto_increment
        primary key,
    oi_version int not null,
    oi_other_income_type varchar(128) not null,
    oi_borrower_income_pid bigint not null,
    oi_estimated_net_income_amount decimal(15,2) not null,
    oi_estimated_mode bit null,
    oi_worksheet_monthly_total_amount decimal(15,2) not null,
    oi_monthly_total_amount decimal(15,2) not null,
    oi_borrower_income_percent decimal(11,9) not null,
    oi_description varchar(128) null,
    oi_calc_method_type varchar(128) not null,
    oi_common_year1_year int null,
    oi_common_year1_year_include bit null,
    oi_common_year1_from_date date null,
    oi_common_year1_through_date date null,
    oi_common_year1_months decimal(4,2) null,
    oi_common_year1_annual_total_amount decimal(15,2) null,
    oi_common_year1_monthly_total_amount decimal(15,2) not null,
    oi_common_year2_year int null,
    oi_common_year2_year_include bit null,
    oi_common_year2_from_date date null,
    oi_common_year2_through_date date null,
    oi_common_year2_months decimal(4,2) null,
    oi_common_year2_annual_total_amount decimal(15,2) null,
    oi_common_year2_monthly_total_amount decimal(15,2) not null,
    oi_common_year3_year int null,
    oi_common_year3_year_include bit null,
    oi_common_year3_from_date date null,
    oi_common_year3_through_date date null,
    oi_common_year3_months decimal(4,2) null,
    oi_common_year3_annual_total_amount decimal(15,2) null,
    oi_common_year3_monthly_total_amount decimal(15,2) not null,
    oi_simple_year1_unadjusted_amount decimal(15,2) not null,
    oi_simple_year1_income_federal_tax_exempt bit null,
    oi_simple_year1_tax_exempt_tax_rate_percent decimal(11,9) not null,
    oi_simple_year1_tax_exempt_amount decimal(15,2) not null,
    oi_simple_year2_unadjusted_amount decimal(15,2) not null,
    oi_simple_year2_income_federal_tax_exempt bit null,
    oi_simple_year2_tax_exempt_tax_rate_percent decimal(11,9) not null,
    oi_simple_year2_tax_exempt_amount decimal(15,2) not null,
    oi_simple_year3_unadjusted_amount decimal(15,2) not null,
    oi_simple_year3_income_federal_tax_exempt bit null,
    oi_simple_year3_tax_exempt_tax_rate_percent decimal(11,9) not null,
    oi_simple_year3_tax_exempt_amount decimal(15,2) not null,
    oi_simple_unadjusted_monthly_amount decimal(15,2) not null,
    oi_simple_income_federal_tax_exempt bit null,
    oi_simple_tax_exempt_tax_rate_percent decimal(11,9) not null,
    oi_simple_tax_exempt_amount decimal(15,2) not null,
    oi_simple_calculated_monthly_amount decimal(15,2) not null,
    oi_underwriter_comments varchar(1024) null,
    oi_mortgage_credit_certificate_issuer_pid bigint null,
    oi_mcc_reservation_number varchar(128) not null,
    oi_mcc_reservation_date date null,
    oi_mcc_reservation_expiration_date date null,
    oi_mcc_commitment_number varchar(128) not null,
    oi_mcc_underwriting_certification_deadline_date date null,
    oi_mcc_delivered_by_date date null,
    oi_unadjusted_monthly_total_amount decimal(15,2) not null,
    oi_simple_year1_unadjusted_monthly_amount decimal(15,2) not null,
    oi_simple_year2_unadjusted_monthly_amount decimal(15,2) not null,
    oi_simple_year3_unadjusted_monthly_amount decimal(15,2) not null,
    constraint fk_other_income_1
        foreign key (oi_borrower_income_pid) references borrower_income (bi_pid),
    constraint fk_other_income_2
        foreign key (oi_mortgage_credit_certificate_issuer_pid) references mortgage_credit_certificate_issuer (mcci_pid),
    constraint fkt_oi_calc_method_type
        foreign key (oi_calc_method_type) references income_history_calc_method_type (code),
    constraint fkt_oi_other_income_type
        foreign key (oi_other_income_type) references other_income_type (code)
);

create table proposal
(
    prp_pid bigint auto_increment
        primary key,
    prp_version int not null,
    prp_decision_lp_request_pid bigint null,
    prp_decision_du_request_pid bigint null,
    prp_proposal_type varchar(128) not null,
    prp_description varchar(256) null,
    prp_doc_level_type varchar(128) not null,
    prp_loan_purpose_type varchar(128) not null,
    prp_name varchar(128) null,
    prp_create_datetime datetime not null,
    prp_effective_funding_date date null,
    prp_estimated_funding_date date not null,
    prp_calculated_earliest_allowed_consummation_date date null,
    prp_overridden_earliest_allowed_consummation_date date null,
    prp_effective_earliest_allowed_consummation_date date null,
    prp_earliest_allowed_consummation_date_override_reason text not null,
    prp_last_requested_disclosure_date date null,
    prp_closing_document_sign_datetime datetime null,
    prp_scheduled_closing_document_sign_datetime datetime null,
    prp_rescission_through_date date null,
    prp_rescission_notification_date date null,
    prp_rescission_notification_by varchar(256) null,
    prp_rescission_notification_type varchar(128) not null,
    prp_rescission_effective_date date null,
    prp_first_payment_date date not null,
    prp_first_payment_date_auto_compute bit null,
    prp_property_usage_type varchar(128) not null,
    prp_estimated_property_value_amount decimal(15) not null,
    prp_smart_charges_enabled bit null,
    prp_charges_updated_datetime datetime null,
    prp_smart_docs_enabled bit null,
    prp_docs_enabled_datetime datetime null,
    prp_request_fha_mip_refund_required bit null,
    prp_request_recording_fees_required bit null,
    prp_request_property_taxes_required bit null,
    prp_property_tax_request_error_messages text not null,
    prp_fha_mip_refund_request_input_error bit null,
    prp_recording_fees_request_input_error bit null,
    prp_property_taxes_request_input_error bit null,
    prp_publish bit null,
    prp_publish_date date null,
    prp_ipc_auto_compute bit null,
    prp_ipc_limit_percent decimal(11,9) not null,
    prp_ipc_maximum_amount_allowed decimal(15,2) not null,
    prp_ipc_amount decimal(15,2) not null,
    prp_ipc_percent decimal(11,9) not null,
    prp_ipc_financing_concession_amount decimal(15,2) not null,
    prp_ipc_non_cash_concession_amount decimal(15,2) not null,
    prp_sale_price_amount decimal(15) not null,
    prp_structure_type varchar(128) not null,
    prp_deal_pid bigint not null,
    prp_gfe_interest_rate_expiration_date date null,
    prp_gfe_lock_duration_days int null,
    prp_gfe_lock_before_settlement_days int null,
    prp_proposal_expiration_date date null,
    prp_uuts_master_contact_name varchar(128) null,
    prp_uuts_master_contact_title varchar(128) null,
    prp_uuts_master_office_phone varchar(32) null,
    prp_uuts_master_office_phone_extension varchar(16) null,
    prp_underwrite_risk_assessment_type varchar(128) not null,
    prp_underwriting_comments varchar(1024) null,
    prp_reserves_auto_compute bit null,
    prp_reserves_amount decimal(15,2) not null,
    prp_reserves_months int null,
    prp_underwrite_disposition_type varchar(128) not null,
    prp_underwrite_publish_date date null,
    prp_underwrite_expiration_date date null,
    prp_usda_gsa_sam_exclusion varchar(128) not null,
    prp_usda_gsa_sam_checked_date date null,
    prp_usda_rd_single_family_housing_type varchar(128) not null,
    prp_underwrite_method_type varchar(128) not null,
    prp_mi_required bit null,
    prp_decision_credit_score_borrower_pid bigint null,
    prp_decision_credit_score int null,
    prp_estimated_credit_score int null,
    prp_effective_credit_score int null,
    prp_mortgagee_builder_seller_relationship varchar(128) not null,
    prp_fha_prior_agency_case_id varchar(32) null,
    prp_fha_prior_agency_case_endorsement_date date null,
    prp_fha_refinance_authorization_number varchar(16) null,
    prp_fha_refinance_authorization_expiration_date date null,
    prp_fhac_refinance_authorization_messages text not null,
    prp_fha_203k_consultant_id varchar(8) null,
    prp_hud_fha_de_approval_type varchar(128) not null,
    prp_owner_occupancy_not_required bit null,
    prp_va_monthly_utilities_included varchar(128) not null,
    prp_va_maintenance_utilities_auto_compute bit null,
    prp_va_monthly_maintenance_utilities_amount decimal(15,2) not null,
    prp_va_maintenance_utilities_per_square_feet_amount decimal(15,2) not null,
    prp_household_size_count int not null,
    prp_household_income_guideline_amount decimal(15,2) not null,
    prp_va_past_credit_record_type varchar(128) not null,
    prp_va_meets_credit_standards varchar(128) not null,
    prp_va_prior_paid_in_full_loan_number varchar(32) null,
    prp_note_date date null,
    prp_security_instrument_type varchar(128) not null,
    prp_trustee_pid bigint null,
    prp_trustee_name varchar(128) null,
    prp_trustee_address_street1 varchar(128) not null,
    prp_trustee_address_street2 varchar(128) not null,
    prp_trustee_address_city varchar(128) not null,
    prp_trustee_address_state varchar(128) not null,
    prp_trustee_address_postal_code varchar(128) not null,
    prp_trustee_address_country varchar(128) not null,
    prp_trustee_mers_org_id varchar(7) null,
    prp_trustee_phone_number varchar(32) null,
    prp_fre_ctp_closing_feature_type varchar(128) not null,
    prp_fre_ctp_closing_type varchar(128) not null,
    prp_fre_ctp_first_payment_due_date date null,
    prp_purchase_contract_date date null,
    prp_purchase_contract_financing_contingency_date date null,
    prp_purchase_contract_funding_date date null,
    prp_effective_property_value_type varchar(128) not null,
    prp_effective_property_value_amount decimal(15) not null,
    prp_decision_appraised_value_amount decimal(15) not null,
    prp_fha_va_reasonable_value_amount decimal(15) not null,
    prp_cd_clear_date date null,
    prp_disaster_declaration_check_date_type varchar(128) not null,
    prp_disaster_declaration_check_date date not null,
    prp_any_disaster_declaration_before_appraisal bit null,
    prp_any_disaster_declaration_after_appraisal bit null,
    prp_any_disaster_declaration bit null,
    prp_early_first_payment varchar(128) not null,
    prp_property_acquired_through_inheritance varchar(128) not null,
    prp_property_acquired_through_ancillary_relief varchar(128) not null,
    prp_delayed_financing_exception_guidelines_applicable bit not null,
    prp_delayed_financing_exception_verified bit null,
    prp_effective_property_value_explanation_type varchar(128) not null,
    prp_taxes_escrowed varchar(128) not null,
    prp_flood_insurance_applicable varchar(128) not null,
    prp_windstorm_insurance_applicable varchar(128) not null,
    prp_earthquake_insurance_applicable varchar(128) not null,
    prp_arms_length varchar(128) not null,
    prp_fha_non_arms_length_ltv_exception_type varchar(128) not null,
    prp_fha_non_arms_length_ltv_exception_verified bit not null,
    prp_escrow_cushion_months int not null,
    prp_escrow_cushion_months_auto_compute bit not null,
    prp_fha_eligible_maximum_financing varchar(128) not null,
    prp_hazard_insurance_applicable varchar(128) not null,
    prp_property_repairs_required_type varchar(128) null,
    prp_property_repairs_description varchar(1024) not null,
    prp_property_repairs_cost_amount decimal(15,2) not null,
    prp_property_repairs_holdback_calc_type varchar(128) null,
    prp_property_repairs_holdback_amount decimal(15,2) not null,
    prp_property_repairs_holdback_payer_type varchar(128) null,
    prp_property_repairs_holdback_administrator varchar(128) not null,
    prp_property_repairs_holdback_required_completion_date date null,
    prp_property_repairs_completed_notification_date date null,
    prp_property_repairs_inspection_ordered_date date null,
    prp_property_repairs_inspection_completed_date date null,
    prp_property_repairs_funds_released_contractor_date date null,
    prp_anti_steering_lowest_rate_option_rate_percent decimal(11,9) null,
    prp_anti_steering_lowest_rate_option_fee_amount decimal(15,2) null,
    prp_anti_steering_lowest_rate_wo_neg_option_rate_percent decimal(11,9) null,
    prp_anti_steering_lowest_rate_wo_neg_option_fee_amount decimal(15,2) null,
    prp_anti_steering_lowest_cost_option_rate_percent decimal(11,9) null,
    prp_anti_steering_lowest_cost_option_fee_amount decimal(15,2) null,
    prp_initial_uw_submit_datetime datetime null,
    prp_va_notice_of_value_source_type varchar(128) not null,
    prp_va_notice_of_value_date date null,
    prp_va_notice_of_value_estimated_reasonable_value_amount decimal(15) not null,
    prp_sar_significant_adjustments bit not null,
    prp_separate_transaction_for_land_acquisition varchar(128) not null,
    prp_land_acquisition_transaction_date date null,
    prp_land_acquisition_price decimal(15) not null,
    prp_cash_out_reason_home_improvement bit not null,
    prp_cash_out_reason_debt_or_debt_consolidation bit not null,
    prp_cash_out_reason_personal_use bit not null,
    prp_cash_out_reason_future_investment_not_under_contract bit not null,
    prp_cash_out_reason_future_investment_under_contract bit not null,
    prp_cash_out_reason_other bit not null,
    prp_cash_out_reason_other_text varchar(128) not null,
    prp_decision_veteran_borrower_pid bigint null,
    prp_signed_closing_doc_received_datetime datetime null,
    prp_other_lender_requires_appraisal bit not null,
    prp_other_lender_requires_appraisal_reason text not null,
    prp_texas_equity_determination_datetime datetime null,
    prp_texas_equity_conversion_determination_datetime datetime null,
    prp_texas_equity_determination_datetime_override bit not null,
    prp_texas_equity_determination_datetime_override_reason text not null,
    prp_texas_equity_conversion_determination_datetime_override bit not null,
    prp_texas_equity_conversion_determ_datetime_override_reason text not null,
    prp_cema varchar(128) not null,
    prp_cema_borrower_savings decimal(15,2) not null,
    prp_any_vesting_changes varchar(128) not null,
    prp_vesting_change_titleholder_added varchar(128) not null,
    prp_vesting_change_titleholder_removed varchar(128) not null,
    prp_vesting_change_titleholder_name_change varchar(128) not null,
    prp_deed_taxes_applicable bit not null,
    prp_deed_taxes_applicable_explanation varchar(1024) not null,
    prp_deed_taxes_auto_compute bit not null,
    prp_deed_taxes_auto_compute_override_reason varchar(1024) not null,
    prp_intent_to_proceed_date date null,
    prp_intent_to_proceed_type varchar(128) not null,
    prp_intent_to_proceed_provider_unparsed_name varchar(128) not null,
    prp_intent_to_proceed_obtainer_unparsed_name varchar(128) not null,
    prp_cash_out_reason_student_loans bit not null,
    prp_household_income_exclusive_edit bit not null,
    prp_purchase_contract_received_date date null,
    prp_down_payment_percent_mode bit not null,
    prp_lender_escrow_loan_amount decimal(15,2) not null,
    prp_underwrite_disposition_note varchar(1024) not null,
    prp_rescission_applicable bit not null,
    prp_area_median_income decimal(15,2) not null,
    prp_total_income_to_ami_ratio decimal(14,9) not null,
    prp_construction_budget_url varchar(1024) not null,
    prp_construction_borrower_contribution_amount decimal(15,2) not null,
    prp_construction_lot_ownership_status_type varchar(128) null,
    prp_intent_to_proceed_provided bit not null,
    prp_effective_signing_location_state varchar(128) null,
    prp_effective_signing_location_city varchar(128) null,
    prp_va_required_guaranty_amount decimal(15,2) null,
    prp_va_amount_used_to_calculate_maximum_guaranty decimal(15,2) null,
    prp_va_actual_guaranty_amount decimal(15,2) null,
    prp_last_corrective_disclosure_processed_datetime datetime null,
    prp_user_entered_note_date date null,
    prp_effective_note_date date null,
    prp_lender_escrow_loan_due_date date null,
    prp_va_maximum_base_loan_amount decimal(15,2) null,
    prp_va_maximum_funding_fee_amount decimal(15,2) null,
    prp_va_maximum_total_loan_amount decimal(15,2) null,
    prp_va_required_cash_amount decimal(15,2) null,
    prp_va_guaranty_percent decimal(11,9) null,
    constraint prp_deal_pid
        unique (prp_deal_pid, prp_proposal_type, prp_name),
    constraint fk_proposal_1
        foreign key (prp_deal_pid) references deal (d_pid),
    constraint fk_proposal_2
        foreign key (prp_decision_lp_request_pid) references lp_request (lpr_pid),
    constraint fk_proposal_3
        foreign key (prp_decision_du_request_pid) references du_request (dur_pid),
    constraint fk_proposal_5
        foreign key (prp_decision_credit_score_borrower_pid) references borrower (b_pid),
    constraint fk_proposal_7
        foreign key (prp_trustee_pid) references trustee (tru_pid),
    constraint fk_proposal_8
        foreign key (prp_decision_veteran_borrower_pid) references borrower (b_pid),
    constraint fkt_prp_any_vesting_changes
        foreign key (prp_any_vesting_changes) references yes_no_unknown_type (code),
    constraint fkt_prp_arms_length
        foreign key (prp_arms_length) references yes_no_unknown_type (code),
    constraint fkt_prp_cema
        foreign key (prp_cema) references yes_no_na_unknown_type (code),
    constraint fkt_prp_construction_lot_ownership_status_type
        foreign key (prp_construction_lot_ownership_status_type) references construction_lot_ownership_status_type (code),
    constraint fkt_prp_disaster_declaration_check_date_type
        foreign key (prp_disaster_declaration_check_date_type) references disaster_declaration_check_date_type (code),
    constraint fkt_prp_doc_level_type
        foreign key (prp_doc_level_type) references doc_level_type (code),
    constraint fkt_prp_early_first_payment
        foreign key (prp_early_first_payment) references yes_no_unknown_type (code),
    constraint fkt_prp_earthquake_insurance_applicable
        foreign key (prp_earthquake_insurance_applicable) references yes_no_unknown_type (code),
    constraint fkt_prp_effective_property_value_explanation_type
        foreign key (prp_effective_property_value_explanation_type) references effective_property_value_explanation_type (code),
    constraint fkt_prp_effective_property_value_type
        foreign key (prp_effective_property_value_type) references effective_property_value_type (code),
    constraint fkt_prp_effective_signing_location_state
        foreign key (prp_effective_signing_location_state) references state_type (code),
    constraint fkt_prp_fha_eligible_maximum_financing
        foreign key (prp_fha_eligible_maximum_financing) references yes_no_unknown_type (code),
    constraint fkt_prp_fha_non_arms_length_ltv_exception_type
        foreign key (prp_fha_non_arms_length_ltv_exception_type) references fha_non_arms_length_ltv_limit_exception_type (code),
    constraint fkt_prp_flood_insurance_applicable
        foreign key (prp_flood_insurance_applicable) references yes_no_unknown_type (code),
    constraint fkt_prp_fre_ctp_closing_feature_type
        foreign key (prp_fre_ctp_closing_feature_type) references fre_ctp_closing_feature_type (code),
    constraint fkt_prp_fre_ctp_closing_type
        foreign key (prp_fre_ctp_closing_type) references fre_ctp_closing_type (code),
    constraint fkt_prp_hazard_insurance_applicable
        foreign key (prp_hazard_insurance_applicable) references yes_no_unknown_type (code),
    constraint fkt_prp_hud_fha_de_approval_type
        foreign key (prp_hud_fha_de_approval_type) references hud_fha_de_approval_type (code),
    constraint fkt_prp_intent_to_proceed_type
        foreign key (prp_intent_to_proceed_type) references intent_to_proceed_type (code),
    constraint fkt_prp_loan_purpose_type
        foreign key (prp_loan_purpose_type) references loan_purpose_type (code),
    constraint fkt_prp_mortgagee_builder_seller_relationship
        foreign key (prp_mortgagee_builder_seller_relationship) references yes_no_unknown_type (code),
    constraint fkt_prp_property_acquired_through_ancillary_relief
        foreign key (prp_property_acquired_through_ancillary_relief) references yes_no_unknown_type (code),
    constraint fkt_prp_property_acquired_through_inheritance
        foreign key (prp_property_acquired_through_inheritance) references yes_no_unknown_type (code),
    constraint fkt_prp_property_repairs_holdback_calc_type
        foreign key (prp_property_repairs_holdback_calc_type) references property_repairs_holdback_calc_type (code),
    constraint fkt_prp_property_repairs_holdback_payer_type
        foreign key (prp_property_repairs_holdback_payer_type) references property_repairs_holdback_payer_type (code),
    constraint fkt_prp_property_repairs_required_type
        foreign key (prp_property_repairs_required_type) references property_repairs_required_type (code),
    constraint fkt_prp_property_usage_type
        foreign key (prp_property_usage_type) references property_usage_type (code),
    constraint fkt_prp_proposal_type
        foreign key (prp_proposal_type) references proposal_type (code),
    constraint fkt_prp_rescission_notification_type
        foreign key (prp_rescission_notification_type) references rescission_notification_type (code),
    constraint fkt_prp_security_instrument_type
        foreign key (prp_security_instrument_type) references security_instrument_type (code),
    constraint fkt_prp_separate_transaction_for_land_acquisition
        foreign key (prp_separate_transaction_for_land_acquisition) references yes_no_unknown_type (code),
    constraint fkt_prp_structure_type
        foreign key (prp_structure_type) references proposal_structure_type (code),
    constraint fkt_prp_taxes_escrowed
        foreign key (prp_taxes_escrowed) references yes_no_unknown_type (code),
    constraint fkt_prp_trustee_address_country
        foreign key (prp_trustee_address_country) references country_type (code),
    constraint fkt_prp_underwrite_disposition_type
        foreign key (prp_underwrite_disposition_type) references underwrite_disposition_type (code),
    constraint fkt_prp_underwrite_method_type
        foreign key (prp_underwrite_method_type) references underwrite_method_type (code),
    constraint fkt_prp_underwrite_risk_assessment_type
        foreign key (prp_underwrite_risk_assessment_type) references underwrite_risk_assessment_type (code),
    constraint fkt_prp_usda_gsa_sam_exclusion
        foreign key (prp_usda_gsa_sam_exclusion) references yes_no_unknown_type (code),
    constraint fkt_prp_usda_rd_single_family_housing_type
        foreign key (prp_usda_rd_single_family_housing_type) references usda_rd_single_family_housing_type (code),
    constraint fkt_prp_va_meets_credit_standards
        foreign key (prp_va_meets_credit_standards) references yes_no_unknown_type (code),
    constraint fkt_prp_va_monthly_utilities_included
        foreign key (prp_va_monthly_utilities_included) references yes_no_unknown_type (code),
    constraint fkt_prp_va_notice_of_value_source_type
        foreign key (prp_va_notice_of_value_source_type) references va_notice_of_value_source_type (code),
    constraint fkt_prp_va_past_credit_record_type
        foreign key (prp_va_past_credit_record_type) references va_past_credit_record_type (code),
    constraint fkt_prp_vesting_change_titleholder_added
        foreign key (prp_vesting_change_titleholder_added) references yes_no_unknown_type (code),
    constraint fkt_prp_vesting_change_titleholder_name_change
        foreign key (prp_vesting_change_titleholder_name_change) references yes_no_unknown_type (code),
    constraint fkt_prp_vesting_change_titleholder_removed
        foreign key (prp_vesting_change_titleholder_removed) references yes_no_unknown_type (code),
    constraint fkt_prp_windstorm_insurance_applicable
        foreign key (prp_windstorm_insurance_applicable) references yes_no_unknown_type (code)
);

alter table application
    add constraint fk_application_1
        foreign key (apl_proposal_pid) references proposal (prp_pid);

create table aus_request_number_ticker
(
    arnt_pid bigint auto_increment
        primary key,
    arnt_version int not null,
    arnt_proposal_pid bigint not null,
    arnt_next_aus_request_number int null,
    constraint uk_aus_request_number_ticker_1
        unique (arnt_proposal_pid),
    constraint fk_aus_request_number_ticker_1
        foreign key (arnt_proposal_pid) references proposal (prp_pid)
);

create table construction_draw
(
    cd_pid bigint auto_increment
        primary key,
    cd_version int not null,
    cd_proposal_pid bigint not null,
    cd_construction_draw_type varchar(128) not null,
    cd_construction_draw_status_type varchar(128) not null,
    cd_scheduled_disbursement_date date null,
    cd_confirmation_datetime datetime null,
    cd_inspection_datetime datetime null,
    cd_disbursement_datetime datetime null,
    cd_boarded_datetime datetime null,
    cd_voided_datetime datetime null,
    cd_construction_draw_notes varchar(1024) not null,
    cd_total_draw_amount decimal(15,2) not null,
    cd_borrower_contribution_amount decimal(15,2) not null,
    cd_lender_contribution_amount decimal(15,2) not null,
    cd_construction_draw_number int null,
    cd_construction_draw_disbursed_at_closing bit not null,
    constraint fk_construction_draw_1
        foreign key (cd_proposal_pid) references proposal (prp_pid),
    constraint fkt_cd_construction_draw_status_type
        foreign key (cd_construction_draw_status_type) references construction_draw_status_type (code),
    constraint fkt_cd_construction_draw_type
        foreign key (cd_construction_draw_type) references construction_draw_type (code)
);

create table construction_draw_number_ticker
(
    cdnt_pid bigint auto_increment
        primary key,
    cdnt_version int not null,
    cdnt_proposal_pid bigint not null,
    cdnt_next_construction_draw_number int not null,
    constraint cdnt_proposal_pid_1
        unique (cdnt_proposal_pid),
    constraint fk_construction_draw_number_ticker_1
        foreign key (cdnt_proposal_pid) references proposal (prp_pid)
);

create table credit_inquiry
(
    ci_pid bigint auto_increment
        primary key,
    ci_version int not null,
    ci_proposal_pid bigint not null,
    ci_credit_request_pid bigint null,
    ci_inquiry_date date null,
    ci_name varchar(128) not null,
    ci_address_street1 varchar(128) not null,
    ci_address_street2 varchar(128) not null,
    ci_address_city varchar(128) not null,
    ci_address_state varchar(128) not null,
    ci_address_postal_code varchar(128) not null,
    ci_address_country varchar(128) not null,
    ci_phone varchar(32) null,
    ci_credit_inquiry_result_type varchar(128) not null,
    ci_credit_business_type varchar(128) not null,
    ci_credit_loan_type varchar(128) not null,
    ci_equifax_included bit null,
    ci_experian_included bit null,
    ci_trans_union_included bit null,
    ci_explanation_type varchar(128) not null,
    ci_explanation_info varchar(1024) not null,
    ci_credit_report_identifier varchar(32) not null,
    ci_inquiry_date_provided bit not null,
    constraint fk_credit_inquiry_1
        foreign key (ci_proposal_pid) references proposal (prp_pid),
    constraint fk_credit_inquiry_2
        foreign key (ci_credit_request_pid) references credit_request (crdr_pid),
    constraint fkt_ci_address_country
        foreign key (ci_address_country) references country_type (code),
    constraint fkt_ci_credit_business_type
        foreign key (ci_credit_business_type) references credit_business_type (code),
    constraint fkt_ci_credit_inquiry_result_type
        foreign key (ci_credit_inquiry_result_type) references credit_inquiry_result_type (code),
    constraint fkt_ci_credit_loan_type
        foreign key (ci_credit_loan_type) references credit_loan_type (code),
    constraint fkt_ci_explanation_type
        foreign key (ci_explanation_type) references credit_inquiry_explanation_type (code)
);

create table borrower_credit_inquiry
(
    bci_pid bigint auto_increment
        primary key,
    bci_version int not null,
    bci_credit_inquiry_pid bigint not null,
    bci_borrower_pid bigint not null,
    constraint bci_borrower_pid
        unique (bci_borrower_pid, bci_credit_inquiry_pid),
    constraint fk_borrower_credit_inquiry_1
        foreign key (bci_credit_inquiry_pid) references credit_inquiry (ci_pid),
    constraint fk_borrower_credit_inquiry_2
        foreign key (bci_borrower_pid) references borrower (b_pid)
);

alter table deal
    add constraint fk_deal_2
        foreign key (d_active_proposal_pid) references proposal (prp_pid);

create table deal_snapshot
(
    desn_pid bigint auto_increment
        primary key,
    desn_version int not null,
    desn_snapshot_proposal_pid bigint not null,
    desn_decision_appraisal_condition_type varchar(128) not null,
    desn_lender_lock_effective_expiration_datetime_main datetime null,
    desn_lender_lock_effective_expiration_datetime_piggyback datetime null,
    desn_lender_lock_status_type_main varchar(128) not null,
    desn_lender_lock_status_type_piggyback varchar(128) not null,
    desn_lender_lock_id_main varchar(11) not null,
    desn_lender_lock_id_piggyback varchar(11) not null,
    desn_preferred_vendor_used bit null,
    desn_lender_lock_start_datetime_main datetime null,
    desn_lender_lock_start_datetime_piggyback datetime null,
    desn_lender_lock_effective_duration_days_main int null,
    desn_lender_lock_effective_duration_days_piggyback int null,
    desn_lead_source_name varchar(128) not null,
    desn_appraisal_rush_request bit not null,
    desn_appraisal_transfer_specified bit not null,
    desn_borrower_requires_appraisal bit not null,
    desn_lender_requires_appraisal bit not null,
    desn_product_requires_appraisal bit not null,
    desn_override_calculated_appraisal_required bit not null,
    desn_decision_appraisal_appraised_value_amount decimal(15) not null,
    desn_appraisal_required bit not null,
    desn_lender_concession_total_approved_amount_main decimal(15,2) not null,
    desn_lender_concession_total_approved_amount_piggyback decimal(15,2) not null,
    desn_relock_fee_gross_amount_main decimal(15,2) not null,
    desn_relock_fee_gross_amount_piggyback decimal(15,2) not null,
    desn_relock_fee_amount_less_concessions_main decimal(15,2) not null,
    desn_relock_fee_amount_less_concessions_piggyback decimal(15,2) not null,
    desn_relock_fee_amount_concessed_main decimal(15,2) not null,
    desn_relock_fee_amount_concessed_piggyback decimal(15,2) not null,
    desn_lock_extension_fee_gross_amount_main decimal(15,2) not null,
    desn_lock_extension_fee_gross_amount_piggyback decimal(15,2) not null,
    desn_lock_extension_fee_amount_less_concessions_main decimal(15,2) not null,
    desn_lock_extension_fee_amount_less_concessions_piggyback decimal(15,2) not null,
    desn_lock_extension_fee_amount_concessed_main decimal(15,2) not null,
    desn_lock_extension_fee_amount_concessed_piggyback decimal(15,2) not null,
    desn_lender_concession_remaining_amount_main decimal(15,2) not null,
    desn_lender_concession_remaining_amount_piggyback decimal(15,2) not null,
    desn_charge_credit_for_interest_rate_main decimal(15,2) not null,
    desn_charge_credit_for_interest_rate_piggyback decimal(15,2) not null,
    constraint desn_snapshot_proposal_pid
        unique (desn_snapshot_proposal_pid),
    constraint fk_deal_snapshot_1
        foreign key (desn_snapshot_proposal_pid) references proposal (prp_pid),
    constraint fkt_desn_decision_appraisal_condition_type
        foreign key (desn_decision_appraisal_condition_type) references appraisal_condition_type (code),
    constraint fkt_desn_lender_lock_status_type_main
        foreign key (desn_lender_lock_status_type_main) references lender_lock_status_type (code),
    constraint fkt_desn_lender_lock_status_type_piggyback
        foreign key (desn_lender_lock_status_type_piggyback) references lender_lock_status_type (code)
);

create table docusign_package
(
    dcsp_pid bigint auto_increment
        primary key,
    dcsp_version int not null,
    dcsp_proposal_pid bigint not null,
    dcsp_envelope_id varchar(128) not null,
    dcsp_esign_package_status_type varchar(128) not null,
    dcsp_status_datetime datetime not null,
    constraint fk_docusign_package_1
        foreign key (dcsp_proposal_pid) references proposal (prp_pid),
    constraint fkt_dcsp_esign_package_status_type
        foreign key (dcsp_esign_package_status_type) references esign_package_status_type (code)
);

create index idx_docusign_package_1
    on docusign_package (dcsp_envelope_id);

alter table du_request
    add constraint fk_du_request_1
        foreign key (dur_proposal_pid) references proposal (prp_pid);

alter table du_request
    add constraint fk_du_request_7
        foreign key (dur_proposal_snapshot_pid) references proposal (prp_pid);

alter table lp_request
    add constraint fk_lp_request_1
        foreign key (lpr_proposal_pid) references proposal (prp_pid);

alter table lp_request
    add constraint fk_lp_request_6
        foreign key (lpr_proposal_snapshot_pid) references proposal (prp_pid);

create table master_property_insurance
(
    mpi_pid bigint auto_increment
        primary key,
    mpi_version int not null,
    mpi_proposal_pid bigint not null,
    mpi_master_property_insurance_type varchar(128) not null,
    mpi_policy_effective_date date null,
    mpi_policy_expiration_date date null,
    mpi_next_payment_date date null,
    mpi_policy_property_coverage_amount decimal(15) not null,
    mpi_policy_liability_coverage_amount decimal(15) not null,
    mpi_policy_fidelity_coverage_amount decimal(15) not null,
    mpi_policy_deductible_amount decimal(15) not null,
    mpi_replacement_cost_amount decimal(15) not null,
    mpi_coinsurance varchar(128) not null,
    mpi_agreed_amount_endorsement varchar(128) not null,
    mpi_company_name varchar(128) not null,
    mpi_first_name varchar(32) not null,
    mpi_middle_name varchar(32) not null,
    mpi_last_name varchar(32) not null,
    mpi_name_suffix varchar(32) not null,
    mpi_title varchar(128) not null,
    mpi_email varchar(256) not null,
    mpi_mobile_phone varchar(32) not null,
    mpi_office_phone varchar(32) not null,
    mpi_office_phone_extension varchar(16) not null,
    mpi_fax varchar(32) not null,
    mpi_address_street1 varchar(128) not null,
    mpi_address_street2 varchar(128) not null,
    mpi_address_city varchar(128) not null,
    mpi_address_state varchar(128) not null,
    mpi_address_postal_code varchar(128) not null,
    mpi_address_country varchar(16) not null,
    mpi_policy_id varchar(128) not null,
    constraint uk_master_property_insurance_1
        unique (mpi_proposal_pid, mpi_master_property_insurance_type),
    constraint fk_master_property_insurance_1
        foreign key (mpi_proposal_pid) references proposal (prp_pid),
    constraint fkt_mpi_address_country
        foreign key (mpi_address_country) references country_type (code),
    constraint fkt_mpi_agreed_amount_endorsement
        foreign key (mpi_agreed_amount_endorsement) references yes_no_unknown_type (code),
    constraint fkt_mpi_coinsurance
        foreign key (mpi_coinsurance) references yes_no_unknown_type (code),
    constraint fkt_mpi_master_property_insurance_type
        foreign key (mpi_master_property_insurance_type) references master_property_insurance_type (code)
);

create table mi_integration_vendor_request
(
    mivr_pid bigint auto_increment
        primary key,
    mivr_version int not null,
    mivr_proposal_pid bigint not null,
    mivr_create_datetime datetime not null,
    mivr_mi_company_name_type varchar(128) not null,
    mivr_request_type varchar(128) not null,
    mivr_mi_payment_type varchar(128) not null,
    mivr_mi_payer_type varchar(128) not null,
    mivr_mi_coverage_percentage decimal(11,9) not null,
    mivr_mi_upfront_percentage decimal(11,9) not null,
    mivr_mi_initial_monthly_annual_percentage decimal(11,9) not null,
    mivr_mi_renewal_monthly_annual_percentage decimal(11,9) not null,
    mivr_mi_initial_duration_months int not null,
    mivr_mi_rate_quote_id varchar(128) not null,
    mivr_mi_certificate_id varchar(128) not null,
    mivr_request_status_type varchar(128) not null,
    mivr_request_time_to_completion_ms bigint not null,
    mivr_eligible_mi_products bit not null,
    mivr_input_errors text not null,
    mivr_service_errors text not null,
    mivr_internal_errors text not null,
    mivr_request_xml_pid bigint null,
    mivr_response_xml_pid bigint null,
    mivr_response_pdf_file_pid bigint null,
    constraint fk_mi_integration_vendor_request_1
        foreign key (mivr_proposal_pid) references proposal (prp_pid),
    constraint fk_mi_integration_vendor_request_2
        foreign key (mivr_response_xml_pid) references deal_system_file (dsf_pid),
    constraint fk_mi_integration_vendor_request_3
        foreign key (mivr_request_xml_pid) references deal_system_file (dsf_pid),
    constraint fk_mi_integration_vendor_request_4
        foreign key (mivr_response_pdf_file_pid) references deal_file (df_pid),
    constraint fkt_mivr_mi_company_name_type
        foreign key (mivr_mi_company_name_type) references mi_company_name_type (code),
    constraint fkt_mivr_mi_payer_type
        foreign key (mivr_mi_payer_type) references mi_payer_type (code),
    constraint fkt_mivr_mi_payment_type
        foreign key (mivr_mi_payment_type) references mi_payment_type (code),
    constraint fkt_mivr_request_status_type
        foreign key (mivr_request_status_type) references mi_integration_vendor_request_status_type (code),
    constraint fkt_mivr_request_type
        foreign key (mivr_request_type) references mi_integration_request_type (code)
);

create table loan
(
    l_pid bigint auto_increment
        primary key,
    l_version int not null,
    l_proposal_pid bigint not null,
    l_offering_pid bigint null,
    l_product_terms_pid bigint null,
    l_mortgage_type varchar(128) not null,
    l_interest_only_type varchar(128) not null,
    l_buydown_schedule_type varchar(128) not null,
    l_prepay_penalty_schedule_type varchar(128) not null,
    l_aus_type varchar(128) not null,
    l_agency_case_id varchar(32) null,
    l_arm_index_datetime datetime null,
    l_arm_index_current_value_percent decimal(11,9) not null,
    l_arm_margin_percent decimal(11,9) not null,
    l_base_loan_amount decimal(17,2) not null,
    l_buydown_contributor_type varchar(128) not null,
    l_target_cash_out_amount decimal(15,2) not null,
    l_heloc_maximum_balance_amount decimal(15) not null,
    l_note_rate_percent decimal(11,9) not null,
    l_initial_note_rate_percent decimal(11,9) not null,
    l_lien_priority_type varchar(128) not null,
    l_loan_amount decimal(17,2) not null,
    l_financed_amount decimal(15) not null,
    l_ltv_ratio_percent decimal(11,9) not null,
    l_base_loan_amount_ltv_ratio_percent decimal(11,9) not null,
    l_mi_requirement_ltv_ratio_percent decimal(11,9) not null,
    l_mi_auto_compute bit null,
    l_mi_no_mi_product bit not null,
    l_mi_input_type varchar(128) not null,
    l_mi_company_name_type varchar(128) not null,
    l_mi_certificate_id varchar(32) not null,
    l_mi_premium_refundable_type varchar(128) not null,
    l_mi_initial_calculation_type varchar(128) not null,
    l_mi_renewal_calculation_type varchar(128) not null,
    l_mi_payer_type varchar(128) not null,
    l_mi_coverage_percent decimal(11,9) not null,
    l_mi_ltv_cutoff_percent decimal(11,9) not null,
    l_mi_midpoint_cutoff_required bit null,
    l_mi_required_monthly_payment_count int null,
    l_mi_actual_monthly_payment_count int null,
    l_mi_payment_type varchar(128) not null,
    l_mi_upfront_amount decimal(15,2) not null,
    l_mi_upfront_percent decimal(11,9) not null,
    l_mi_initial_monthly_payment_amount decimal(15,2) not null,
    l_mi_renewal_monthly_payment_annual_percent decimal(11,9) not null,
    l_mi_renewal_monthly_payment_amount decimal(15,2) not null,
    l_mi_initial_duration_months int null,
    l_mi_initial_monthly_payment_annual_percent decimal(11,9) not null,
    l_mi_initial_calculated_rate_type varchar(128) not null,
    l_mi_renewal_calculated_rate_type varchar(128) not null,
    l_mi_base_rate_label varchar(16000) null,
    l_mi_base_monthly_payment_annual_percent decimal(11,9) not null,
    l_mi_base_upfront_percent decimal(11,9) not null,
    l_mi_base_monthly_payment_amount decimal(15,2) not null,
    l_mi_base_upfront_payment_amount decimal(15,2) not null,
    l_qualifying_rate_type varchar(128) not null,
    l_qualifying_rate_input_percent decimal(11,9) not null,
    l_qualifying_rate_percent decimal(11,9) not null,
    l_fha_program_code_type varchar(128) not null,
    l_fha_principal_write_down bit null,
    l_fhac_case_assignment_messages text not null,
    l_initial_pi_amount decimal(15,2) not null,
    l_qualifying_pi_amount decimal(15,2) not null,
    l_base_note_rate_percent decimal(11,9) not null,
    l_base_arm_margin_percent decimal(11,9) not null,
    l_base_price_percent decimal(11,9) not null,
    l_lock_price_percent decimal(11,9) not null,
    l_lock_duration_days int null,
    l_lock_commitment_type varchar(128) not null,
    l_product_choice_datetime datetime null,
    l_hmda_purchaser_of_loan_2017_type varchar(128) not null,
    l_hmda_purchaser_of_loan_2018_type varchar(128) not null,
    l_texas_equity varchar(128) not null,
    l_texas_equity_auto varchar(128) not null,
    l_fnm_mbs_investor_contract_id varchar(6) null,
    l_base_guaranty_fee_percent decimal(11,9) not null,
    l_guaranty_fee_percent decimal(11,9) not null,
    l_guaranty_fee_after_alternate_payment_method_percent decimal(11,9) not null,
    l_fnm_investor_product_plan_id varchar(5) null,
    l_uldd_loan_comment varchar(60) null,
    l_principal_curtailment_amount decimal(15,2) not null,
    l_agency_case_id_assigned_date date null,
    l_mi_lender_paid_rate_adjustment_percent decimal(11,9) not null,
    l_apr decimal(11,9) not null,
    l_finance_charge_amount decimal(15,2) not null,
    l_apor_percent decimal(11,9) null,
    l_apor_date date null,
    l_hmda_rate_spread_percent decimal(11,9) null,
    l_hoepa_apr decimal(11,9) not null,
    l_hoepa_rate_spread decimal(11,9) not null,
    l_hoepa_fees_dollar_amount decimal(15,2) not null,
    l_hmda_hoepa_status_type varchar(128) not null,
    l_rate_sheet_undiscounted_rate_percent decimal(11,9) not null,
    l_effective_undiscounted_rate_percent decimal(11,9) not null,
    l_last_unprocessed_changes_datetime datetime null,
    l_locked_price_change_percent decimal(11,9) not null,
    l_interest_rate_fee_change_amount decimal(15,2) not null,
    l_lender_concession_candidate bit not null,
    l_durp_eligibility_opt_out bit not null,
    l_qualified_mortgage_status_type varchar(128) not null,
    l_qualified_mortgage bit not null,
    l_lqa_purchase_eligibility_type varchar(128) not null,
    l_student_loan_cash_out_refinance bit not null,
    l_mi_rate_quote_id varchar(128) not null,
    l_mi_integration_vendor_request_pid bigint null,
    l_secondary_clear_to_commit bit not null,
    l_qm_eligible bit not null,
    l_fha_endorsement_date date null,
    l_va_guaranty_date date null,
    l_usda_guarantee_date date null,
    constraint l_proposal_pid
        unique (l_proposal_pid, l_lien_priority_type),
    constraint fk_loan_1
        foreign key (l_proposal_pid) references proposal (prp_pid),
    constraint fk_loan_2
        foreign key (l_product_terms_pid) references product_terms (pt_pid),
    constraint fk_loan_3
        foreign key (l_offering_pid) references offering (of_pid),
    constraint fk_loan_4
        foreign key (l_mi_integration_vendor_request_pid) references mi_integration_vendor_request (mivr_pid),
    constraint fkt_l_aus_type
        foreign key (l_aus_type) references aus_type (code),
    constraint fkt_l_buydown_contributor_type
        foreign key (l_buydown_contributor_type) references buydown_contributor_type (code),
    constraint fkt_l_buydown_schedule_type
        foreign key (l_buydown_schedule_type) references buydown_schedule_type (code),
    constraint fkt_l_fha_program_code_type
        foreign key (l_fha_program_code_type) references fha_program_code_type (code),
    constraint fkt_l_hmda_hoepa_status_type
        foreign key (l_hmda_hoepa_status_type) references hmda_hoepa_status_type (code),
    constraint fkt_l_hmda_purchaser_of_loan_2018_type
        foreign key (l_hmda_purchaser_of_loan_2018_type) references hmda_purchaser_of_loan_2018_type (code),
    constraint fkt_l_hmda_purchaser_of_loan_type
        foreign key (l_hmda_purchaser_of_loan_2017_type) references hmda_purchaser_of_loan_2017_type (code),
    constraint fkt_l_interest_only_type
        foreign key (l_interest_only_type) references interest_only_type (code),
    constraint fkt_l_lien_priority_type
        foreign key (l_lien_priority_type) references lien_priority_type (code),
    constraint fkt_l_lock_commitment_type
        foreign key (l_lock_commitment_type) references lock_commitment_type (code),
    constraint fkt_l_lqa_purchase_eligibility_type
        foreign key (l_lqa_purchase_eligibility_type) references lqa_purchase_eligibility_type (code),
    constraint fkt_l_mi_company_name_type
        foreign key (l_mi_company_name_type) references mi_company_name_type (code),
    constraint fkt_l_mi_initial_calculated_rate_type
        foreign key (l_mi_initial_calculated_rate_type) references mi_calculated_rate_type (code),
    constraint fkt_l_mi_initial_calculation_type
        foreign key (l_mi_initial_calculation_type) references mi_initial_calculation_type (code),
    constraint fkt_l_mi_input_type
        foreign key (l_mi_input_type) references mi_input_type (code),
    constraint fkt_l_mi_payer_type
        foreign key (l_mi_payer_type) references mi_payer_type (code),
    constraint fkt_l_mi_payment_type
        foreign key (l_mi_payment_type) references mi_payment_type (code),
    constraint fkt_l_mi_premium_refundable_type
        foreign key (l_mi_premium_refundable_type) references mi_premium_refundable_type (code),
    constraint fkt_l_mi_renewal_calculated_rate_type
        foreign key (l_mi_renewal_calculated_rate_type) references mi_calculated_rate_type (code),
    constraint fkt_l_mi_renewal_calculation_type
        foreign key (l_mi_renewal_calculation_type) references mi_renewal_calculation_type (code),
    constraint fkt_l_mortgage_type
        foreign key (l_mortgage_type) references mortgage_type (code),
    constraint fkt_l_prepay_penalty_schedule_type
        foreign key (l_prepay_penalty_schedule_type) references prepay_penalty_schedule_type (code),
    constraint fkt_l_qualified_mortgage_status_type
        foreign key (l_qualified_mortgage_status_type) references qualified_mortgage_status_type (code),
    constraint fkt_l_qualifying_rate_type
        foreign key (l_qualifying_rate_type) references qualifying_rate_type (code),
    constraint fkt_l_texas_equity
        foreign key (l_texas_equity) references yes_no_unknown_type (code),
    constraint fkt_l_texas_equity_auto
        foreign key (l_texas_equity_auto) references yes_no_na_type (code)
);

create table circumstance_change
(
    cc_pid bigint auto_increment
        primary key,
    cc_version int not null,
    cc_loan_pid bigint not null,
    cc_create_datetime datetime not null,
    cc_circumstance_change_type varchar(128) not null,
    cc_source_unparsed_name varchar(128) not null,
    cc_expired bit not null,
    cc_previous_formatted_value varchar(1024) not null,
    cc_to_formatted_value varchar(1024) not null,
    cc_expiration_date date null,
    cc_system_added bit not null,
    constraint fk_circumstance_change_1
        foreign key (cc_loan_pid) references loan (l_pid),
    constraint fkt_cc_circumstance_change_type
        foreign key (cc_circumstance_change_type) references circumstance_change_type (code)
);

create index idx_circumstance_change_1
    on circumstance_change (cc_create_datetime);

create table ernst_request
(
    enst_pid bigint auto_increment
        primary key,
    enst_version int not null,
    enst_loan_pid bigint not null,
    enst_response_deal_system_file_pid bigint null,
    enst_auto_compute bit null,
    enst_create_datetime datetime not null,
    enst_ernst_request_status_type varchar(128) not null,
    enst_error_messages text not null,
    enst_state varchar(2) null,
    enst_ernst_page_rec varchar(16) null,
    enst_sub_jurisdiction_name varchar(128) null,
    enst_torrens bit null,
    enst_security_instrument_request_type varchar(128) not null,
    enst_security_instrument_index_fee_requested bit null,
    enst_security_instrument_index_fee_grantor_count int null,
    enst_security_instrument_index_fee_grantees_count int null,
    enst_security_instrument_index_fee_surnames_count int null,
    enst_security_instrument_index_fee_signatures_count int null,
    enst_security_instrument_page_count int null,
    enst_security_instrument_modification_amendment_page_count int not null,
    enst_security_instrument_page_breakdown varchar(1024) not null,
    enst_mortgage_new_debt_amount decimal(15) not null,
    enst_mortgage_original_debt_amount decimal(15) not null,
    enst_mortgage_unpaid_balance_amount decimal(15,2) not null,
    enst_deed_request_type varchar(128) not null,
    enst_deed_index_fee_requested bit null,
    enst_deed_index_fee_grantor_count int null,
    enst_deed_index_fee_grantees_count int null,
    enst_deed_index_fee_surnames_count int null,
    enst_deed_index_fee_signatures_count int null,
    enst_deed_page_count int null,
    enst_deed_page_breakdown varchar(256) not null,
    enst_deed_consideration_amount decimal(15) not null,
    enst_deed_amendment_page_count int null,
    enst_include_assignment bit null,
    enst_assign_index_fee_requested bit null,
    enst_assign_index_fee_grantor_count int null,
    enst_assign_index_fee_grantees_count int null,
    enst_assign_index_fee_surnames_count int null,
    enst_assign_index_fee_signatures_count int null,
    enst_assignment_page_count_per_doc int null,
    enst_assignment_count int null,
    enst_include_poa bit null,
    enst_poa_page_count int null,
    enst_include_subordination bit null,
    enst_subord_index_fee_requested bit null,
    enst_subord_index_fee_grantor_count int null,
    enst_subord_index_fee_grantees_count int null,
    enst_subord_index_fee_surnames_count int null,
    enst_subord_index_fee_signatures_count int null,
    enst_subordination_page_count_per_doc int null,
    enst_subordination_count int null,
    enst_loan_position_type varchar(128) not null,
    constraint fk_ernst_request_1
        foreign key (enst_loan_pid) references loan (l_pid),
    constraint fk_ernst_request_2
        foreign key (enst_response_deal_system_file_pid) references deal_system_file (dsf_pid),
    constraint fkt_enst_deed_request_type
        foreign key (enst_deed_request_type) references ernst_deed_request_type (code),
    constraint fkt_enst_ernst_request_status_type
        foreign key (enst_ernst_request_status_type) references ernst_request_status_type (code),
    constraint fkt_enst_loan_position_type
        foreign key (enst_loan_position_type) references loan_position_type (code),
    constraint fkt_enst_security_instrument_request_type
        foreign key (enst_security_instrument_request_type) references ernst_security_instrument_request_type (code)
);

create table ernst_request_question
(
    enstq_pid bigint auto_increment
        primary key,
    enstq_version int not null,
    enstq_ernst_request_pid bigint not null,
    enstq_ernst_question_id varchar(8) null,
    enstq_question varchar(1024) null,
    enstq_yes_no_answer bit null,
    enstq_answer varchar(16) null,
    constraint fk_ernst_request_question_1
        foreign key (enstq_ernst_request_pid) references ernst_request (enst_pid)
);

create table loan_beneficiary
(
    lb_pid bigint auto_increment
        primary key,
    lb_version int not null,
    lb_loan_pid bigint not null,
    lb_investor_pid bigint not null,
    lb_investor_loan_id varchar(32) null,
    lb_from_date date null,
    lb_through_date date null,
    lb_current bit null,
    lb_initial bit null,
    lb_loan_benef_transfer_status_type varchar(128) not null,
    lb_loan_file_ship_date date null,
    lb_approved_with_conditions_date date null,
    lb_rejected_date date null,
    lb_pending_wire_date date null,
    lb_purchase_advice_amount decimal(15,2) not null,
    lb_mers_mom bit null,
    lb_mers_transfer_status_type varchar(128) not null,
    lb_mers_transfer_creation_date date null,
    lb_mers_transfer_override bit null,
    lb_mers_transfer_batch_pid bigint null,
    lb_loan_file_courier_type varchar(128) not null,
    lb_loan_file_tracking_number varchar(32) null,
    lb_collateral_courier_type varchar(128) not null,
    lb_collateral_tracking_number varchar(32) null,
    lb_loan_file_delivery_method_type varchar(128) null,
    lb_pool_id varchar(32) not null,
    lb_mbs_final_purchaser_investor_pid bigint null,
    lb_early_funding varchar(128) not null,
    lb_early_funding_date date null,
    lb_delivery_aus_type varchar(128) not null,
    constraint fk_loan_beneficiary_1
        foreign key (lb_loan_pid) references loan (l_pid),
    constraint fk_loan_beneficiary_2
        foreign key (lb_investor_pid) references investor (i_pid),
    constraint fk_loan_beneficiary_3
        foreign key (lb_mers_transfer_batch_pid) references mers_transfer_batch (metb_pid),
    constraint fk_loan_beneficiary_4
        foreign key (lb_mbs_final_purchaser_investor_pid) references investor (i_pid),
    constraint fkt_lb_collateral_courier_type
        foreign key (lb_collateral_courier_type) references courier_type (code),
    constraint fkt_lb_delivery_aus_type
        foreign key (lb_delivery_aus_type) references delivery_aus_type (code),
    constraint fkt_lb_early_funding
        foreign key (lb_early_funding) references yes_no_unknown_type (code),
    constraint fkt_lb_loan_benef_transfer_status_type
        foreign key (lb_loan_benef_transfer_status_type) references loan_benef_transfer_status_type (code),
    constraint fkt_lb_loan_file_courier_type
        foreign key (lb_loan_file_courier_type) references courier_type (code),
    constraint fkt_lb_loan_file_delivery_method_type
        foreign key (lb_loan_file_delivery_method_type) references loan_file_delivery_method_type (code),
    constraint fkt_lb_mers_transfer_status_type
        foreign key (lb_mers_transfer_status_type) references mers_transfer_status_type (code)
);

create table loan_closing_doc
(
    lcd_pid bigint auto_increment
        primary key,
    lcd_version int not null,
    lcd_loan_pid bigint not null,
    lcd_dsi_websheet_number varchar(16) null,
    lcd_dsi_doc_code varchar(32) null,
    lcd_dsi_transaction_id varchar(128) null,
    lcd_dsi_closing_document_status_type varchar(128) not null,
    lcd_dsi_fatal_messages text not null,
    lcd_dsi_warning_messages text not null,
    lcd_unsigned_closing_doc_deal_file_pid bigint null,
    constraint uk_loan_closing_doc_1
        unique (lcd_loan_pid),
    constraint fk_loan_closing_doc_1
        foreign key (lcd_loan_pid) references loan (l_pid),
    constraint fk_loan_closing_doc_2
        foreign key (lcd_unsigned_closing_doc_deal_file_pid) references deal_file (df_pid),
    constraint fkt_lcd_dsi_closing_document_status_type
        foreign key (lcd_dsi_closing_document_status_type) references closing_document_status_type (code)
);

create table loan_eligible_investor
(
    lei_pid bigint auto_increment
        primary key,
    lei_version int not null,
    lei_loan_pid bigint not null,
    lei_investor_pid bigint not null,
    constraint fk_loan_eligible_investor_1
        foreign key (lei_loan_pid) references loan (l_pid),
    constraint fk_loan_eligible_investor_2
        foreign key (lei_investor_pid) references investor (i_pid)
);

create table loan_funding
(
    lf_pid bigint auto_increment
        primary key,
    lf_version int not null,
    lf_loan_pid bigint not null,
    lf_interim_funder_pid bigint null,
    lf_proposal_snapshot_pid bigint null,
    lf_interim_funder_loan_id varchar(32) null,
    lf_funding_status_type varchar(128) not null,
    lf_requested_date date null,
    lf_confirmed_release_datetime datetime null,
    lf_wire_amount decimal(15,2) not null,
    lf_interim_funder_fee_amount decimal(15,2) not null,
    lf_release_wire_federal_reference_number varchar(32) null,
    lf_disbursement_date date null,
    lf_return_request_date date null,
    lf_return_confirmed_date date null,
    lf_funds_authorization_code varchar(32) null,
    lf_scheduled_release_date date null,
    lf_funds_authorized_datetime datetime null,
    lf_funding_date date null,
    lf_collateral_sent_date date null,
    lf_collateral_tracking_number varchar(32) not null,
    lf_collateral_courier_type varchar(128) not null,
    lf_post_wire_adjustment_amount decimal(15,2) not null,
    lf_net_wire_amount decimal(15,2) not null,
    lf_early_wire_charge_day_count int not null,
    lf_early_wire_daily_charge_amount decimal(15,2) not null,
    lf_early_wire_total_charge_amount decimal(15,2) not null,
    lf_scheduled_release_date_auto_compute bit not null,
    lf_early_wire_request bit not null,
    constraint fk_loan_funding_1
        foreign key (lf_loan_pid) references loan (l_pid),
    constraint fk_loan_funding_2
        foreign key (lf_interim_funder_pid) references interim_funder (if_pid),
    constraint fk_loan_funding_3
        foreign key (lf_proposal_snapshot_pid) references proposal (prp_pid),
    constraint fkt_lf_collateral_courier_type
        foreign key (lf_collateral_courier_type) references courier_type (code),
    constraint fkt_lf_funding_status_type
        foreign key (lf_funding_status_type) references funding_status_type (code)
);

create table loan_hedge
(
    lh_pid bigint auto_increment
        primary key,
    lh_version int not null,
    lh_loan_pid bigint not null,
    lh_update_datetime datetime null,
    lh_update_pending_datetime datetime null,
    lh_transaction_status_date date null,
    lh_loan_number bigint not null,
    lh_product_code varchar(128) not null,
    lh_note_rate decimal(11,9) not null,
    lh_loan_amount decimal(17,2) not null,
    lh_lock_date datetime null,
    lh_buy_side_lock_expires_date datetime null,
    lh_lock_expiration_date datetime null,
    lh_secondary_cost decimal(11,9) not null,
    lh_total_cost_basis decimal(11,9) not null,
    lh_total_lender_margin decimal(17,9) not null,
    lh_stage varchar(128) not null,
    lh_fund_date datetime null,
    lh_allocation_date datetime null,
    lh_estimated_fund_date date null,
    lh_purchased_by_investor_date date null,
    lh_commitment_number varchar(32) not null,
    lh_property_occupancy varchar(128) not null,
    lh_property_type varchar(128) not null,
    lh_property_type_supplemental varchar(16) not null,
    lh_property_state varchar(128) not null,
    lh_property_zip varchar(128) not null,
    lh_property_number_of_units int null,
    lh_purchase_price decimal(15) not null,
    lh_appraised_value decimal(15) not null,
    lh_purpose varchar(128) not null,
    lh_refinance_type varchar(128) not null,
    lh_lien_position varchar(128) not null,
    lh_impounds varchar(16) not null,
    lh_buydown_type varchar(128) not null,
    lh_buydown varchar(8) not null,
    lh_ltv decimal(11,9) not null,
    lh_original_ltv decimal(11,9) not null,
    lh_cltv decimal(11,9) not null,
    lh_original_cltv decimal(11,9) not null,
    lh_effective_credit_score int null,
    lh_doc_type varchar(128) not null,
    lh_debt_to_income decimal(11,9) not null,
    lh_prepayment_penalty bit null,
    lh_prepayment_penalty_term int null,
    lh_interest_only bit null,
    lh_lock_type varchar(128) not null,
    lh_lock_period int null,
    lh_fees_collected_bps varchar(8) not null,
    lh_channel varchar(32) not null,
    lh_loan_officer varchar(128) not null,
    lh_branch varchar(128) not null,
    lh_broker varchar(8) not null,
    lh_correspondent varchar(8) not null,
    lh_origination_source varchar(32) not null,
    lh_investor varchar(128) not null,
    lh_investor_total_price decimal(11,9) null,
    lh_investor_base_price decimal(11,9) null,
    lh_investor_srp_paid varchar(8) not null,
    lh_investor_loan_number varchar(32) not null,
    lh_pmi bit null,
    lh_pmi_percent decimal(11,9) not null,
    lh_mi_cert_number varchar(128) not null,
    lh_srp_paid varchar(8) not null,
    lh_discount_points varchar(8) not null,
    lh_date_docs_back varchar(8) not null,
    lh_note_date date null,
    lh_close_date datetime null,
    lh_first_payment_date date null,
    lh_last_payment_date date null,
    lh_next_scheduled_payment_due_date varchar(8) not null,
    lh_scheduled_principal_and_interest decimal(15,2) not null,
    lh_current_principal_and_interest decimal(15,2) not null,
    lh_minimum_principal_and_interest decimal(15,2) not null,
    lh_current_unpaid_principal_balance decimal(17,2) not null,
    lh_original_interest_rate decimal(11,9) not null,
    lh_maturity_date date null,
    lh_amortization_term int null,
    lh_yearly_payment_cap varchar(8) not null,
    lh_arm_margin decimal(11,9) null,
    lh_arm_adjustment_date date null,
    lh_first_arm_period int null,
    lh_first_arm_adjustment_cap decimal(11,9) null,
    lh_arm_life_floor decimal(11,9) null,
    lh_arm_life_ceiling decimal(11,9) null,
    lh_first_arm_payment_adjustment_date varchar(8) not null,
    lh_arm_period_after_first varchar(8) not null,
    lh_arm_adjustment_cap_after_first decimal(11,9) null,
    lh_first_payment_cap varchar(8) not null,
    lh_payment_cap_option varchar(8) not null,
    lh_neg_am_flag varchar(8) not null,
    lh_maximum_negative_amortization varchar(8) not null,
    lh_arm_convertible varchar(8) not null,
    lh_arm_index varchar(8) not null,
    lh_dual_loan_flag varchar(8) not null,
    lh_other_loan_number varchar(8) not null,
    lh_agency_extract_fields varchar(8) not null,
    lh_warehouse_bank varchar(128) not null,
    lh_wire_amount decimal(15,2) null,
    lh_credit_rating_agency_fields varchar(8) not null,
    lh_levels_fields varchar(8) not null,
    lh_data_fields varchar(8) not null,
    lh_loan_status varchar(128) not null,
    lh_suspense_yes_no varchar(8) not null,
    lh_loan_type varchar(128) not null,
    lh_hud_borr_paid_by_for_borr_other_amount varchar(8) not null,
    lh_fees_line_user_def_fee_one_borr varchar(8) not null,
    lh_uw_suspended_cleared_date varchar(8) not null,
    lh_underwriting_suspended_date varchar(8) not null,
    lh_line_orig_charge decimal(15,2) not null,
    lh_amortization_type varchar(32) not null,
    lh_milestone varchar(128) not null,
    lh_msa varchar(8) not null,
    lh_county_code varchar(8) not null,
    lh_ship_date_to_investor date null,
    lh_ship_date_to_custodian varchar(8) not null,
    lh_borrower_last_name varchar(32) not null,
    lh_purchase_advice_suspense_fee varchar(8) not null,
    lh_purchase_advice_early_delivery_amount varchar(8) not null,
    lh_purchase_advice_llpa varchar(8) not null,
    lh_purchase_advice_fmna varchar(8) not null,
    lh_purchase_advice_rp varchar(8) not null,
    lh_lock_info_relock_amount varchar(8) not null,
    lh_lock_info_loan_basis decimal(11,9) null,
    lh_lock_info_lock_request_fulfilled_date_time varchar(8) not null,
    lh_lock_info_rate_lock_request_rate_sheet_id varchar(8) not null,
    lh_current_status_change_date date null,
    lh_aus_type varchar(8) not null,
    lh_buy_side_base_arm_margin varchar(8) not null,
    lh_uldd_poolid varchar(32) not null,
    lh_warehouse_co_name varchar(128) not null,
    lh_underwriting_investor_eligibility_wells_fargo varchar(8) not null,
    lh_underwriting_investor_eligibility_chase varchar(8) not null,
    lh_du_fail_reason varchar(8) not null,
    lh_lpmi_total_costs_on_lock varchar(8) not null,
    lh_lpmi_after_lock_required varchar(8) not null,
    lh_lpmi_after_lock_bps varchar(8) not null,
    lh_mi_company_name_type varchar(128) not null,
    lh_lpmi_frequency varchar(128) not null,
    lh_lpmi_estimated_amount_of_lender_paid_mi varchar(8) not null,
    lh_mortgage_insurance_premium_source_type varchar(16) not null,
    lh_loan_amount_repeat decimal(17,2) not null,
    lh_product_code_repeat varchar(128) not null,
    lh_note_rate_repeat decimal(11,9) not null,
    lh_loan_info_loan_id varchar(8) not null,
    lh_salable_loan varchar(8) not null,
    lh_sale_hold varchar(8) not null,
    lh_sale_hold_comments varchar(8) not null,
    lh_pf_disbursement_ledger_date date null,
    lh_aus_eligibility varchar(8) not null,
    lh_texas_cash_out bit null,
    lh_acceptable_du bit null,
    lh_acceptable_lp bit null,
    lh_financed_property_count int null,
    lh_payoff_primary_lien_holder_company varchar(8) not null,
    lh_payoff_junior_lien_holder_company varchar(8) not null,
    lh_base_loan_amount decimal(17,2) not null,
    lh_funding_authorized varchar(32) not null,
    lh_credit_committee_fico_exception varchar(8) not null,
    lh_home_ready_eligibility varchar(8) not null,
    lh_home_ready_borr_acceptance varchar(8) not null,
    lh_home_ready_eligibility_review varchar(8) not null,
    lh_home_possible_eligibility varchar(8) not null,
    lh_home_possible_eligibility_review varchar(8) not null,
    lh_piw varchar(8) not null,
    lh_piw_fee varchar(8) not null,
    lh_uw_investor_eligibility_fnma varchar(8) not null,
    lh_uw_investor_eligibility_fhlmc varchar(8) not null,
    lh_appraisal_form varchar(128) not null,
    lh_ext_cos_total_amt varchar(8) not null,
    lh_fnmcu_risk_score varchar(8) not null,
    lh_borrower_income_verification varchar(8) not null,
    lh_co_borrower_income_verification varchar(8) not null,
    lh_day_one_income_verification_available varchar(8) not null,
    lh_subject_property_estimated_value decimal(15) not null,
    lh_transaction_status varchar(128) not null,
    lh_buy_status varchar(128) not null,
    lh_appraisal_exists bit null,
    lh_du_piw_eligible bit null,
    lh_lp_appraisal_waiver_eligible bit null,
    lh_borrower_first_name varchar(32) not null,
    lh_co_borrower_first_name varchar(32) not null,
    lh_co_borrower_last_name varchar(32) not null,
    lh_total_borrower_income decimal(15,2) not null,
    lh_subject_property_city varchar(128) not null,
    lh_subject_property_county varchar(128) not null,
    lh_subject_property_zip varchar(128) not null,
    lh_borrower_decision_credit_score int null,
    lh_co_borrower_decision_credit_score int null,
    lh_underwriter_disposition varchar(128) not null,
    lh_underwrite_risk_assessment_type varchar(128) not null,
    lh_subject_property_address varchar(1024) not null,
    lh_original_lock_date datetime null,
    lh_original_lock_period int null,
    lh_borrower_income_docs_required_count int null,
    lh_borrower_income_docs_fulfilled_count int null,
    lh_borrower_income_docs_approved_count int null,
    lh_borrower_asset_docs_required_count int null,
    lh_borrower_asset_docs_fulfilled_count int null,
    lh_borrower_asset_docs_approved_count int null,
    lh_borrower_credit_docs_required_count int null,
    lh_borrower_credit_docs_fulfilled_count int null,
    lh_borrower_credit_docs_approved_count int null,
    lh_initial_uw_submit_date_time datetime null,
    lh_cd_clear_date date null,
    lh_lender_concession_total_approved_amount decimal(15,2) not null,
    lh_relock_fee_gross_amount decimal(15,2) not null,
    lh_relock_fee_amount_less_concessions decimal(15,2) not null,
    lh_relock_fee_amount_concessed decimal(15,2) not null,
    lh_lock_extension_fee_gross_amount decimal(15,2) not null,
    lh_lock_extension_fee_amount_less_concessions decimal(15,2) not null,
    lh_lock_extension_fee_amount_concessed decimal(15,2) not null,
    lh_lender_concession_remaining_amount decimal(15,2) not null,
    lh_day_one_concessions decimal(15,2) not null,
    lh_investor_lock_commitment_type varchar(128) not null,
    lh_signed_closing_doc_received_datetime datetime null,
    lh_geocoding_msa_code varchar(32) not null,
    lh_geocoding_state_code varchar(32) not null,
    lh_geocoding_county_code varchar(32) not null,
    lh_geocoding_census_tract varchar(32) not null,
    lh_tolerance_cure_amount decimal(15,2) not null,
    lh_self_employed_flag bit null,
    lh_first_time_homebuyer bit null,
    lh_mortgage_insurance_lpmi_rate_adjustment decimal(11,9) not null,
    lh_eligible_for_qm_status bit null,
    lh_safe_harbor_test_passed bit null,
    lh_hpml bit null,
    lh_hoepa varchar(128) not null,
    lh_funding_status varchar(128) not null,
    lh_early_funding varchar(128) not null,
    lh_early_funding_date date null,
    lh_lqa_purchase_eligibility_type varchar(128) not null,
    lh_transferred_appraisal bit null,
    lh_appraisal_cu_risk_score varchar(32) not null,
    lh_mi_upfront_rate decimal(11,9) not null,
    lh_loan_funding_requested_date date null,
    lh_student_loan_cash_out bit null,
    lh_octane_high_balance bit null,
    lh_borrower_final_price decimal(11,9) not null,
    lh_charge_credit_for_interest_rate decimal(15,2) not null,
    lh_contract_processing_fee decimal(15,2) not null,
    lh_escrow_holdback bit null,
    lh_appraiser_license_number varchar(128) not null,
    lh_mcc_present bit null,
    lh_grant_present bit null,
    lh_cema varchar(128) not null,
    lh_supplemental_margin_company decimal(15,2) not null,
    lh_supplemental_margin_branch decimal(15,2) not null,
    lh_supplemental_margin_total decimal(15,2) not null,
    lh_concessions_renegotiations_amount decimal(15,2) not null,
    lh_fund_source_type varchar(128) not null,
    lh_purchase_contract_funding_date date null,
    lh_product_id varchar(32) not null,
    lh_community_second bit null,
    lh_current_taxes_and_insurance decimal(15,2) not null,
    lh_multiple_applicants bit null,
    lh_community_second_liability bit null,
    lh_property_rights_type varchar(128) not null,
    lh_mbs_final_purchaser varchar(128) not null,
    lh_hmda_universal_loan_id varchar(45) not null,
    lh_lp_ace_eligible bit null,
    lh_family_advantage_product bit null,
    lh_effective_rate_sheet_datetime datetime null,
    lh_debt_to_income_excluding_mi decimal(11,9) not null,
    lh_clear_to_commit bit null,
    lh_b2_first_name varchar(32) not null,
    lh_b2_last_name varchar(32) not null,
    lh_c2_first_name varchar(32) not null,
    lh_c2_last_name varchar(32) not null,
    lh_b3_first_name varchar(32) not null,
    lh_b3_last_name varchar(32) not null,
    lh_c3_first_name varchar(32) not null,
    lh_c3_last_name varchar(32) not null,
    lh_b4_first_name varchar(32) not null,
    lh_b4_last_name varchar(32) not null,
    lh_c4_first_name varchar(32) not null,
    lh_c4_last_name varchar(32) not null,
    lh_b5_first_name varchar(32) not null,
    lh_b5_last_name varchar(32) not null,
    lh_c5_first_name varchar(32) not null,
    lh_c5_last_name varchar(32) not null,
    lh_texas_home_equity_conversion bit null,
    lh_interest_only_heloc bit null,
    lh_interest_only_term_months int null,
    lh_investor_lock_product_name varchar(128) not null,
    lh_investor_lock_product_id varchar(32) not null,
    lh_rebuttable_presumption bit null,
    lh_non_conforming bit null,
    lh_num_deal_updates_since_update_pending int not null,
    lh_borrower_engagement_percent decimal(11,9) not null,
    lh_loan_create_date date not null,
    lh_high_balance_hit_percent decimal(11,9) null,
    lh_new_york_payup_percent decimal(11,9) null,
    constraint uk_lh_loan_pid
        unique (lh_loan_pid),
    constraint fk_loan_hedge_1
        foreign key (lh_loan_pid) references loan (l_pid)
);

create table loan_mi_rate_adjustment
(
    lmra_pid bigint auto_increment
        primary key,
    lmra_version int not null,
    lmra_loan_pid bigint not null,
    lmra_case_name varchar(16000) null,
    lmra_rate_adjustment_percent decimal(11,9) not null,
    constraint fk_loan_mi_rate_adjustment_1
        foreign key (lmra_loan_pid) references loan (l_pid)
);

create table loan_mi_surcharge
(
    lms_pid bigint auto_increment
        primary key,
    lms_version int not null,
    lms_loan_pid bigint not null,
    lms_criteria_html varchar(16000) not null,
    lms_government_surcharge_percent decimal(11,9) not null,
    lms_government_surcharge_minimum_amount decimal(15,2) not null,
    constraint fk_loan_mi_surcharge_1
        foreign key (lms_loan_pid) references loan (l_pid)
);

create table loan_price_add_on
(
    lpa_pid bigint auto_increment
        primary key,
    lpa_version int not null,
    lpa_loan_pid bigint not null,
    lpa_create_datetime datetime not null,
    lpa_summary varchar(16000) not null,
    lpa_rate_adjustment_percent decimal(11,9) not null,
    lpa_price_adjustment_percent decimal(11,9) not null,
    lpa_arm_margin_adjustment_percent decimal(11,9) not null,
    lpa_lock_add_on_type varchar(128) not null,
    constraint fk_loan_price_add_on_1
        foreign key (lpa_loan_pid) references loan (l_pid),
    constraint fkt_lpa_lock_add_on_type
        foreign key (lpa_lock_add_on_type) references lock_add_on_type (code)
);

create table loan_recording
(
    lr_pid bigint auto_increment
        primary key,
    lr_version int not null,
    lr_loan_pid bigint not null,
    lr_recording_date date null,
    lr_recording_instrument_number varchar(16) null,
    lr_recording_book_number varchar(16) null,
    lr_recording_volume_number varchar(16) null,
    lr_recording_page_number varchar(16) null,
    lr_recording_jurisdiction_name varchar(16) null,
    lr_recording_witness_unparsed_name varchar(16) null,
    lr_re_recording bit null,
    lr_mers_registration_status_type varchar(128) not null,
    lr_mers_registration_date date null,
    lr_mers_registration_errors text not null,
    lr_mers_registration_warnings text not null,
    lr_mers_transfer_errors text not null,
    lr_mers_transfer_warnings text not null,
    constraint uk_loan_recording_1
        unique (lr_loan_pid),
    constraint fk_loan_recording_1
        foreign key (lr_loan_pid) references loan (l_pid),
    constraint fkt_lr_mers_registration_status_type
        foreign key (lr_mers_registration_status_type) references mers_registration_status_type (code)
);

create table loan_servicer
(
    lsv_pid bigint auto_increment
        primary key,
    lsv_version int not null,
    lsv_loan_pid bigint not null,
    lsv_investor_pid bigint not null,
    lsv_investor_loan_id varchar(32) null,
    lsv_initial bit null,
    lsv_from_date date null,
    lsv_servicing_data_sent_date date null,
    lsv_retain_notification_date date null,
    lsv_release_notification_date date null,
    lsv_servicing_docs_sent_date date null,
    lsv_mers_transfer_status_type varchar(128) not null,
    lsv_mers_transfer_creation_date date null,
    lsv_mers_transfer_override bit null,
    lsv_mers_transfer_batch_pid bigint null,
    lsv_loan_acquisition_scheduled_upb_amount decimal(15,2) not null,
    lsv_last_paid_installment_due_date date null,
    lsv_upb_amount decimal(15,2) not null,
    lsv_delinquent_payments_over_past_twelve_months_count int null,
    constraint fk_loan_servicer_1
        foreign key (lsv_loan_pid) references loan (l_pid),
    constraint fk_loan_servicer_2
        foreign key (lsv_investor_pid) references investor (i_pid),
    constraint fk_loan_servicer_3
        foreign key (lsv_mers_transfer_batch_pid) references mers_transfer_batch (metb_pid),
    constraint fkt_lsv_mers_transfer_status_type
        foreign key (lsv_mers_transfer_status_type) references mers_transfer_status_type (code)
);

create index idx_loan_servicer_1
    on loan_servicer (lsv_investor_loan_id);

create table lock_series
(
    lsr_pid bigint auto_increment
        primary key,
    lsr_loan_pid bigint not null,
    lsr_version int not null,
    lsr_vintage_date date not null,
    lsr_series_id int not null,
    constraint uk_lock_series_1
        unique (lsr_loan_pid, lsr_series_id),
    constraint fk_lock_series_1
        foreign key (lsr_loan_pid) references loan (l_pid)
);

create table lender_lock_major
(
    llmj_pid bigint auto_increment
        primary key,
    llmj_version int not null,
    llmj_major_version int not null,
    llmj_lender_lock_id varchar(11) not null,
    llmj_loan_pid bigint not null,
    llmj_lien_priority_type varchar(128) not null,
    llmj_account_pid bigint not null,
    llmj_lock_datetime datetime null,
    llmj_initial_duration_days int null,
    llmj_initial_lock_expiration_datetime datetime null,
    llmj_requester_agent_type varchar(128) not null,
    llmj_requester_lender_user_pid bigint null,
    llmj_requester_unparsed_name varchar(128) null,
    llmj_request_datetime datetime null,
    llmj_confirm_datetime datetime null,
    llmj_confirm_lender_user_pid bigint null,
    llmj_confirm_unparsed_name varchar(128) null,
    llmj_void_request_datetime datetime null,
    llmj_void_request_lender_user_pid bigint null,
    llmj_void_request_unparsed_name varchar(128) null,
    llmj_void_datetime datetime null,
    llmj_void_lender_user_pid bigint null,
    llmj_void_unparsed_name varchar(128) null,
    llmj_cancel_datetime datetime null,
    llmj_cancel_lender_user_pid bigint null,
    llmj_cancel_unparsed_name varchar(128) null,
    llmj_auto_confirmed bit null,
    llmj_active bit null,
    llmj_relock_fee_percent decimal(11,9) not null,
    llmj_notes varchar(16000) null,
    llmj_lender_concession_approved_amount decimal(15,2) null,
    llmj_clear_extension_fees_relock bit null,
    llmj_pricing_duration_days int not null,
    llmj_pricing_commitment_type varchar(128) not null,
    llmj_expired_lock_successor bit not null,
    llmj_lock_series_pid bigint null,
    constraint fk_lender_lock_major_1
        foreign key (llmj_void_request_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lender_lock_major_2
        foreign key (llmj_void_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lender_lock_major_3
        foreign key (llmj_cancel_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lender_lock_major_4
        foreign key (llmj_confirm_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lender_lock_major_5
        foreign key (llmj_requester_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lender_lock_major_6
        foreign key (llmj_loan_pid) references loan (l_pid),
    constraint fk_lender_lock_major_7
        foreign key (llmj_account_pid) references account (a_pid),
    constraint fk_llmj_lock_series_pid
        foreign key (llmj_lock_series_pid) references lock_series (lsr_pid),
    constraint fkt_llmj_lien_priority_type
        foreign key (llmj_lien_priority_type) references lien_priority_type (code),
    constraint fkt_llmj_pricing_commitment_type
        foreign key (llmj_pricing_commitment_type) references lock_commitment_type (code),
    constraint fkt_llmj_requester_agent_type
        foreign key (llmj_requester_agent_type) references agent_type (code)
);

create table bid_pool_lender_lock
(
    bpll_pid bigint auto_increment
        primary key,
    bpll_version int not null,
    bpll_bid_pool_pid bigint not null,
    bpll_lender_lock_major_pid bigint not null,
    constraint uk_bid_pool_lender_lock_1
        unique (bpll_bid_pool_pid, bpll_lender_lock_major_pid),
    constraint fk_bid_pool_lender_lock_1
        foreign key (bpll_bid_pool_pid) references bid_pool (bp_pid),
    constraint fk_bid_pool_lender_lock_2
        foreign key (bpll_lender_lock_major_pid) references lender_lock_major (llmj_pid)
);

create table lender_concession_request
(
    lcr_pid bigint auto_increment
        primary key,
    lcr_version int not null,
    lcr_loan_pid bigint not null,
    lcr_lender_lock_major_pid bigint null,
    lcr_requested_amount decimal(15,2) not null,
    lcr_approved_amount decimal(15,2) not null,
    lcr_requested_reason varchar(128) not null,
    lcr_approved_reason varchar(128) not null,
    lcr_requested_datetime datetime not null,
    lcr_decision_datetime datetime null,
    lcr_decision_notes varchar(1024) null,
    lcr_request_notes varchar(1024) not null,
    lcr_requester_lender_user_pid bigint not null,
    lcr_requester_unparsed_name varchar(128) not null,
    lcr_approver_lender_user_pid bigint null,
    lcr_approver_unparsed_name varchar(128) null,
    lcr_lender_concession_request_status_type varchar(128) not null,
    lcr_corporate_amount decimal(15,2) not null,
    constraint fk_lender_concession_4
        foreign key (lcr_loan_pid) references loan (l_pid),
    constraint fk_lender_concession_request_1
        foreign key (lcr_lender_lock_major_pid) references lender_lock_major (llmj_pid),
    constraint fk_lender_concession_request_2
        foreign key (lcr_requester_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lender_concession_request_3
        foreign key (lcr_approver_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_lcr_approved_reason
        foreign key (lcr_approved_reason) references lender_concession_request_type (code),
    constraint fkt_lcr_lender_concession_request_status_type
        foreign key (lcr_lender_concession_request_status_type) references lender_concession_request_status_type (code),
    constraint fkt_lcr_requested_reason
        foreign key (lcr_requested_reason) references lender_concession_request_type (code)
);

create table lender_lock_extension
(
    lle_pid bigint auto_increment
        primary key,
    lle_version int not null,
    lle_lender_lock_major_pid bigint not null,
    lle_creator_lender_user_pid bigint not null,
    lle_creator_unparsed_name varchar(128) null,
    lle_requester_lender_user_pid bigint not null,
    lle_requester_unparsed_name varchar(128) null,
    lle_requested_datetime datetime null,
    lle_confirm_lender_user_pid bigint null,
    lle_confirm_unparsed_name varchar(128) null,
    lle_confirm_datetime datetime null,
    lle_auto_confirmed bit null,
    lle_reject_lender_user_pid bigint null,
    lle_reject_datetime datetime null,
    lle_reject_explanation varchar(1024) null,
    lle_lock_extension_status_type varchar(128) not null,
    lle_extension_days int null,
    lle_price_adjustment_percent decimal(11,9) not null,
    lle_fee_applicable bit null,
    constraint fk_lender_lock_extension_1
        foreign key (lle_lender_lock_major_pid) references lender_lock_major (llmj_pid),
    constraint fk_lender_lock_extension_2
        foreign key (lle_creator_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lender_lock_extension_3
        foreign key (lle_requester_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lender_lock_extension_4
        foreign key (lle_confirm_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lender_lock_extension_5
        foreign key (lle_reject_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_lle_lock_extension_status_type
        foreign key (lle_lock_extension_status_type) references lock_extension_status_type (code)
);

create index idx_lender_lock_major_1
    on lender_lock_major (llmj_lender_lock_id);

create table lender_lock_minor
(
    llmn_pid bigint auto_increment
        primary key,
    llmn_version int not null,
    llmn_lender_lock_major_pid bigint not null,
    llmn_minor_version int not null,
    llmn_latest_version bit null,
    llmn_lender_lock_status_type varchar(128) not null,
    llmn_create_datetime datetime null,
    llmn_creator_agent_type varchar(128) not null,
    llmn_creator_lender_user_pid bigint null,
    llmn_creator_unparsed_name varchar(128) not null,
    llmn_effective_lock_expiration_datetime datetime null,
    llmn_effective_duration_days int null,
    llmn_num_extensions int null,
    llmn_investor_base_note_rate_percent decimal(11,9) not null,
    llmn_investor_base_arm_margin_percent decimal(11,9) not null,
    llmn_investor_base_price_percent decimal(11,9) not null,
    llmn_lock_note_rate_percent decimal(11,9) not null,
    llmn_lock_initial_note_rate_percent decimal(11,9) not null,
    llmn_lock_arm_margin_percent decimal(11,9) not null,
    llmn_lock_price_percent decimal(11,9) not null,
    llmn_lock_price_raw_percent decimal(11,9) not null,
    llmn_maximum_rebate_percent decimal(11,9) not null,
    llmn_maximum_investor_price_percent decimal(11,9) not null,
    llmn_maximum_investor_price_includes_srp bit not null,
    llmn_created_historic_price_delta decimal(11,9) not null,
    llmn_profit_table_name varchar(128) not null,
    llmn_total_profit_margin_percent decimal(11,9) not null,
    llmn_base_note_rate_percent decimal(11,9) not null,
    llmn_base_arm_margin_percent decimal(11,9) not null,
    llmn_base_price_percent decimal(11,9) not null,
    llmn_pricing_datetime datetime not null,
    llmn_effective_rate_sheet_datetime datetime not null,
    llmn_apor_date date not null,
    llmn_proposal_snapshot_pid bigint null,
    llmn_loan_amount decimal(17,2) not null,
    llmn_base_loan_amount decimal(17,2) not null,
    llmn_lock_commitment_type varchar(128) not null,
    llmn_offering_pid bigint null,
    llmn_product_terms_pid bigint null,
    llmn_mortgage_type varchar(128) not null,
    llmn_interest_only_type varchar(128) not null,
    llmn_buydown_schedule_type varchar(128) not null,
    llmn_prepay_penalty_schedule_type varchar(128) not null,
    llmn_aus_type varchar(128) not null,
    llmn_high_balance_hit_percent decimal(11,9) null,
    llmn_new_york_payup_percent decimal(11,9) null,
    constraint fk_lender_lock_minor_1
        foreign key (llmn_lender_lock_major_pid) references lender_lock_major (llmj_pid),
    constraint fk_lender_lock_minor_2
        foreign key (llmn_creator_lender_user_pid) references lender_user (lu_pid),
    constraint fk_lender_lock_minor_3
        foreign key (llmn_product_terms_pid) references product_terms (pt_pid),
    constraint fk_lender_lock_minor_4
        foreign key (llmn_offering_pid) references offering (of_pid),
    constraint fk_lender_lock_minor_5
        foreign key (llmn_proposal_snapshot_pid) references proposal (prp_pid),
    constraint fkt_llmn_aus_type
        foreign key (llmn_aus_type) references aus_type (code),
    constraint fkt_llmn_buydown_schedule_type
        foreign key (llmn_buydown_schedule_type) references buydown_schedule_type (code),
    constraint fkt_llmn_creator_agent_type
        foreign key (llmn_creator_agent_type) references agent_type (code),
    constraint fkt_llmn_interest_only_type
        foreign key (llmn_interest_only_type) references interest_only_type (code),
    constraint fkt_llmn_lender_lock_status_type
        foreign key (llmn_lender_lock_status_type) references lender_lock_status_type (code),
    constraint fkt_llmn_lock_commitment_type
        foreign key (llmn_lock_commitment_type) references lock_commitment_type (code),
    constraint fkt_llmn_mortgage_type
        foreign key (llmn_mortgage_type) references mortgage_type (code),
    constraint fkt_llmn_prepay_penalty_schedule_type
        foreign key (llmn_prepay_penalty_schedule_type) references prepay_penalty_schedule_type (code)
);

create table lender_lock_add_on
(
    lla_pid bigint auto_increment
        primary key,
    lla_version int not null,
    lla_lender_lock_minor_pid bigint not null,
    lla_lock_add_on_type varchar(128) not null,
    lla_investor_price_adjustment_percent decimal(11,9) not null,
    lla_account_price_adjustment_percent decimal(11,9) not null,
    lla_create_datetime datetime not null,
    lla_creator_lender_user_pid bigint null,
    lla_creator_unparsed_name varchar(128) null,
    lla_summary varchar(16000) null,
    lla_rate_adjustment_percent decimal(11,9) not null,
    lla_price_adjustment_percent decimal(11,9) not null,
    lla_arm_margin_adjustment_percent decimal(11,9) not null,
    constraint fk_lender_lock_add_on_1
        foreign key (lla_lender_lock_minor_pid) references lender_lock_minor (llmn_pid),
    constraint fk_lender_lock_add_on_2
        foreign key (lla_creator_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_lla_lock_add_on_type
        foreign key (lla_lock_add_on_type) references lock_add_on_type (code)
);

create table net_tangible_benefit
(
    ntb_pid bigint auto_increment
        primary key,
    ntb_version int not null,
    ntb_net_tangible_benefit_type varchar(128) not null,
    ntb_proposal_pid bigint not null,
    constraint uk_net_tangible_benefit_1
        unique (ntb_net_tangible_benefit_type, ntb_proposal_pid),
    constraint fk_net_tangible_benefit_1
        foreign key (ntb_proposal_pid) references proposal (prp_pid),
    constraint fkt_ntb_net_tangible_benefit_type
        foreign key (ntb_net_tangible_benefit_type) references net_tangible_benefit_type (code)
);

create table obligation
(
    ob_pid bigint auto_increment
        primary key,
    ob_version int not null,
    ob_proposal_pid bigint not null,
    ob_obligation_type varchar(128) not null,
    ob_amount_input_type varchar(128) not null,
    ob_factor_percent decimal(11,9) not null,
    ob_factor_percent_base_amount decimal(15,2) not null,
    ob_annual_payment_amount decimal(15,2) not null,
    ob_monthly_payment_amount decimal(15,2) not null,
    ob_pte_annual_tax_installment_amount decimal(15,2) not null,
    ob_pte_annual_preferred_tax_amount decimal(15,2) not null,
    ob_pte_annual_homeowner_occupied_estimated_tax_amount decimal(15,2) not null,
    ob_pte_annual_exemption_free_estimated_tax_amount decimal(15,2) not null,
    ob_payment_date_1 date null,
    ob_payment_date_2 date null,
    ob_payment_date_3 date null,
    ob_payment_date_4 date null,
    ob_payment_date_5 date null,
    ob_payment_date_6 date null,
    ob_payment_amount_1 decimal(15,2) not null,
    ob_payment_amount_2 decimal(15,2) not null,
    ob_payment_amount_3 decimal(15,2) not null,
    ob_payment_amount_4 decimal(15,2) not null,
    ob_payment_amount_5 decimal(15,2) not null,
    ob_payment_amount_6 decimal(15,2) not null,
    ob_total_dated_payment_amount decimal(15,2) not null,
    ob_vendor_first_name varchar(32) null,
    ob_vendor_last_name varchar(32) null,
    ob_vendor_middle_name varchar(32) null,
    ob_vendor_name_suffix varchar(32) null,
    ob_vendor_company_name varchar(128) not null,
    ob_vendor_title varchar(128) null,
    ob_vendor_office_phone varchar(32) null,
    ob_vendor_office_phone_extension varchar(16) null,
    ob_vendor_mobile_phone varchar(32) null,
    ob_vendor_email varchar(256) null,
    ob_vendor_fax varchar(32) null,
    ob_vendor_city varchar(128) null,
    ob_vendor_country varchar(128) not null,
    ob_vendor_postal_code varchar(128) null,
    ob_vendor_state varchar(128) null,
    ob_vendor_street1 varchar(128) null,
    ob_vendor_street2 varchar(128) null,
    ob_vendor_reference_id varchar(128) null,
    ob_name varchar(128) not null,
    ob_payment_amount_1_warning varchar(1024) null,
    ob_payment_amount_2_warning varchar(1024) null,
    ob_payment_amount_3_warning varchar(1024) null,
    ob_payment_amount_4_warning varchar(1024) null,
    ob_payment_amount_5_warning varchar(1024) null,
    ob_payment_amount_6_warning varchar(1024) null,
    ob_tax_auto_compute bit null,
    ob_policy_dwelling_coverage_amount decimal(15) not null,
    ob_policy_extended_coverage_amount decimal(15) not null,
    ob_policy_deductible_amount decimal(15) not null,
    ob_policy_effective_date date null,
    ob_policy_expiration_date date null,
    ob_escrow_waiver varchar(128) not null,
    ob_insurance_transferred bit not null,
    constraint ob_proposal_pid
        unique (ob_proposal_pid, ob_obligation_type),
    constraint fk_obligation_1
        foreign key (ob_proposal_pid) references proposal (prp_pid),
    constraint fkt_ob_amount_input_type
        foreign key (ob_amount_input_type) references obligation_amount_input_type (code),
    constraint fkt_ob_escrow_waiver
        foreign key (ob_escrow_waiver) references yes_no_unknown_type (code),
    constraint fkt_ob_obligation_type
        foreign key (ob_obligation_type) references obligation_type (code),
    constraint fkt_ob_vendor_country
        foreign key (ob_vendor_country) references country_type (code)
);

create table loan_charge
(
    lc_pid bigint auto_increment
        primary key,
    lc_version int not null,
    lc_proposal_pid bigint not null,
    lc_obligation_pid bigint null,
    lc_account_charge_ordinal int null,
    lc_loan_position_type varchar(128) not null,
    lc_charge_type varchar(128) not null,
    lc_name varchar(128) null,
    lc_charge_payer_type varchar(128) not null,
    lc_charge_payee_type varchar(128) not null,
    lc_paid_by varchar(128) null,
    lc_paid_to varchar(128) null,
    lc_poc bit null,
    lc_poc_applicable bit null,
    lc_charge_wire_action_type varchar(128) not null,
    lc_reduction_amount decimal(15) not null,
    lc_apr bit null,
    lc_base_amount decimal(16,3) not null,
    lc_configured_total_amount decimal(15,2) not null,
    lc_total_amount decimal(15,2) not null,
    lc_charge_input_type varchar(128) not null,
    lc_charge_input_type_base_amount decimal(16,3) not null,
    lc_charge_input_type_percent decimal(11,9) not null,
    lc_charge_input_type_currency decimal(16,3) not null,
    lc_hud_section_number varchar(16) null,
    lc_hud_line_number varchar(16) null,
    lc_user_defined bit null,
    lc_months_auto_compute bit null,
    lc_months int null,
    lc_per_diem_amount decimal(15,2) not null,
    lc_per_diem_rate decimal(11,9) not null,
    lc_days int null,
    lc_financed bit null,
    lc_financed_auto_compute bit null,
    lc_financed_amount decimal(15) not null,
    lc_auto_compute bit null,
    lc_charge_source_type varchar(128) not null,
    lc_obligation_charge_input_type varchar(128) not null,
    lc_from_date date null,
    lc_through_date date null,
    lc_smart_charge_config_warning varchar(1024) not null,
    lc_reduction_amount_warning varchar(1024) not null,
    lc_advance_amount_warning varchar(1024) not null,
    lc_fha_mip_refund_warning varchar(1024) not null,
    lc_aggregate_adjustment_compute_warning varchar(1024) not null,
    lc_advance_obligation_compute_warning varchar(1024) not null,
    lc_escrow_obligation_compute_warning varchar(1024) not null,
    lc_excess_financing_concession_warning varchar(1024) not null,
    lc_amount_exceeds_cap_warning varchar(1024) not null,
    lc_subtract_lenders_title_insurance_amount bit not null,
    lc_lender_insurance_exceeds_owner_insurance_warning varchar(1024) not null,
    lc_manual_circumstance_change_type_1 varchar(128) not null,
    lc_manual_circumstance_change_type_2 varchar(128) not null,
    lc_configured_charge_payer_type varchar(128) not null,
    lc_configured_charge_payee_type varchar(128) not null,
    lc_configured_paid_by varchar(128) not null,
    lc_configured_paid_to varchar(128) not null,
    lc_configured_poc bit not null,
    lc_configured_financed bit not null,
    lc_charge_wire_action_auto_compute bit not null,
    constraint uk_loan_charge_1
        unique (lc_proposal_pid, lc_loan_position_type, lc_charge_type, lc_account_charge_ordinal),
    constraint fk_loan_charge_1
        foreign key (lc_proposal_pid) references proposal (prp_pid),
    constraint fk_loan_charge_2
        foreign key (lc_obligation_pid) references obligation (ob_pid),
    constraint fkt_lc_charge_input_type
        foreign key (lc_charge_input_type) references charge_input_type (code),
    constraint fkt_lc_charge_payee_type
        foreign key (lc_charge_payee_type) references charge_payee_type (code),
    constraint fkt_lc_charge_payer_type
        foreign key (lc_charge_payer_type) references charge_payer_type (code),
    constraint fkt_lc_charge_source_type
        foreign key (lc_charge_source_type) references charge_source_type (code),
    constraint fkt_lc_charge_type
        foreign key (lc_charge_type) references charge_type (code),
    constraint fkt_lc_charge_wire_action_type
        foreign key (lc_charge_wire_action_type) references charge_wire_action_type (code),
    constraint fkt_lc_configured_charge_payee_type
        foreign key (lc_configured_charge_payee_type) references charge_payee_type (code),
    constraint fkt_lc_configured_charge_payer_type
        foreign key (lc_configured_charge_payer_type) references charge_payer_type (code),
    constraint fkt_lc_loan_position_type
        foreign key (lc_loan_position_type) references loan_position_type (code),
    constraint fkt_lc_manual_circumstance_change_type_1
        foreign key (lc_manual_circumstance_change_type_1) references circumstance_change_type (code),
    constraint fkt_lc_manual_circumstance_change_type_2
        foreign key (lc_manual_circumstance_change_type_2) references circumstance_change_type (code),
    constraint fkt_lc_obligation_charge_input_type
        foreign key (lc_obligation_charge_input_type) references obligation_charge_input_type (code)
);

create table place
(
    pl_pid bigint auto_increment
        primary key,
    pl_version int not null,
    pl_proposal_pid bigint not null,
    pl_subject_property bit null,
    pl_acquisition_date date null,
    pl_construction_improvement_costs_amount decimal(15) not null,
    pl_financed_units_count int null,
    pl_unit_count int null,
    pl_land_estimated_value_amount decimal(15) not null,
    pl_land_original_cost_amount decimal(15) not null,
    pl_leasehold_expiration_date date null,
    pl_legal_description_type varchar(128) not null,
    pl_legal_description varchar(32000) not null,
    pl_property_tax_id varchar(32) null,
    pl_legal_lot varchar(32) null,
    pl_legal_block varchar(32) null,
    pl_legal_section varchar(32) null,
    pl_project_name varchar(128) null,
    pl_cpm_project_id varchar(128) null,
    pl_acquisition_cost_amount decimal(15) not null,
    pl_county_pid bigint null,
    pl_sub_jurisdiction_name varchar(128) null,
    pl_recording_district_name varchar(128) null,
    pl_project_classification_type varchar(128) not null,
    pl_property_category_type varchar(128) not null,
    pl_property_rights_type varchar(128) not null,
    pl_refinance_total_improvement_costs_amount decimal(15) not null,
    pl_refinance_improvements_type varchar(128) not null,
    pl_refinance_proposed_improvements_description varchar(32) null,
    pl_structure_built_year int null,
    pl_structure_built_month int null,
    pl_title_manner_held_type varchar(128) not null,
    pl_title_manner_held_description varchar(1024) not null,
    pl_building_status_type varchar(128) not null,
    pl_construction_conversion varchar(128) not null,
    pl_native_american_lands_type varchar(128) not null,
    pl_community_land_trust bit null,
    pl_inclusionary_zoning bit null,
    pl_unique_dwelling_type varchar(128) not null,
    pl_living_unit_count int null,
    pl_project_design_type varchar(128) not null,
    pl_city varchar(128) null,
    pl_country varchar(128) not null,
    pl_postal_code varchar(128) null,
    pl_state varchar(128) null,
    pl_street1 varchar(128) null,
    pl_street2 varchar(128) null,
    pl_street_tbd bit null,
    pl_landlord_first_name varchar(32) null,
    pl_landlord_last_name varchar(32) null,
    pl_landlord_middle_name varchar(32) null,
    pl_landlord_name_suffix varchar(32) null,
    pl_landlord_company_name varchar(128) not null,
    pl_landlord_title varchar(128) null,
    pl_landlord_office_phone varchar(32) null,
    pl_landlord_office_phone_extension varchar(16) null,
    pl_landlord_mobile_phone varchar(32) null,
    pl_landlord_email varchar(256) null,
    pl_landlord_fax varchar(32) null,
    pl_landlord_city varchar(128) null,
    pl_landlord_country varchar(128) not null,
    pl_landlord_postal_code varchar(128) null,
    pl_landlord_state varchar(128) null,
    pl_landlord_street1 varchar(128) null,
    pl_landlord_street2 varchar(128) null,
    pl_management_first_name varchar(32) null,
    pl_management_last_name varchar(32) null,
    pl_management_middle_name varchar(32) null,
    pl_management_name_suffix varchar(32) null,
    pl_management_company_name varchar(128) not null,
    pl_management_title varchar(128) null,
    pl_management_office_phone varchar(32) null,
    pl_management_office_phone_extension varchar(16) null,
    pl_management_mobile_phone varchar(32) null,
    pl_management_email varchar(256) null,
    pl_management_fax varchar(32) null,
    pl_management_city varchar(128) null,
    pl_management_country varchar(128) not null,
    pl_management_postal_code varchar(128) null,
    pl_management_state varchar(128) null,
    pl_management_street1 varchar(128) null,
    pl_management_street2 varchar(128) null,
    pl_property_insurance_amount_input_type varchar(128) not null,
    pl_property_tax_amount_input_type varchar(128) not null,
    pl_annual_property_insurance_amount decimal(15,2) not null,
    pl_annual_property_tax_amount decimal(15,2) not null,
    pl_monthly_property_insurance_amount decimal(15,2) null,
    pl_monthly_hoa_amount decimal(15,2) null,
    pl_monthly_mi_amount decimal(15,2) null,
    pl_monthly_property_tax_amount decimal(15,2) null,
    pl_monthly_lease_ground_rent_amount decimal(15,2) null,
    pl_monthly_rent_amount decimal(15,2) not null,
    pl_monthly_obligation_amount decimal(15,2) not null,
    pl_use_proposed_property_usage bit null,
    pl_property_usage_type varchar(128) not null,
    pl_property_value_amount decimal(15) not null,
    pl_reo_disposition_status_type varchar(128) not null,
    pl_auto_geocode bit null,
    pl_auto_geocode_exception varchar(1024) null,
    pl_msa_code varchar(32) null,
    pl_state_fips varchar(32) null,
    pl_county_fips varchar(32) null,
    pl_census_tract varchar(32) null,
    pl_mh_make varchar(32) null,
    pl_mh_model varchar(32) null,
    pl_mh_length int null,
    pl_mh_width int null,
    pl_mh_manufacturer varchar(32) null,
    pl_mh_serial_number varchar(128) not null,
    pl_mh_hud_label_number varchar(128) not null,
    pl_mh_certificate_of_title_issued varchar(128) not null,
    pl_mh_certificate_of_title_number varchar(32) null,
    pl_mh_certificate_of_title_type varchar(128) not null,
    pl_mh_loan_purpose_type varchar(128) not null,
    pl_mh_anchored bit null,
    pl_coop_company_name varchar(128) not null,
    pl_coop_building_name varchar(128) null,
    pl_coop_vacant_units int null,
    pl_coop_proprietary_lease_date date null,
    pl_coop_assignment_lease_date date null,
    pl_coop_existing_company_laws_state varchar(128) not null,
    pl_coop_shares_being_purchased int null,
    pl_coop_attorney_in_fact varchar(128) null,
    pl_coop_stock_certificate_number varchar(32) null,
    pl_coop_apartment_unit varchar(32) null,
    pl_rental bit null,
    pl_underwriter_comments varchar(1024) null,
    pl_lava_zone_type varchar(128) not null,
    pl_neighborhood_location_type varchar(128) null,
    pl_site_area decimal(15) not null,
    pl_hud_reo varchar(128) not null,
    pl_energy_improvement_replacement_major_system bit null,
    pl_energy_improvement_insulation_sealant bit null,
    pl_energy_improvement_installation_solar bit null,
    pl_energy_improvement_addition_new_feature bit null,
    pl_energy_improvement_other bit null,
    pl_energy_related_repairs_or_improvements_amount decimal(15,2) null,
    pl_refinance_general_improvements_amount decimal(15) not null,
    pl_va_guaranteed_reo varchar(128) not null,
    pl_va_loan_date date null,
    pl_gross_building_area_square_feet int null,
    pl_project_dwelling_units_sold_count int null,
    pl_prior_owners_title bit null,
    pl_prior_owners_title_policy_amount decimal(15,2) not null,
    pl_prior_owners_title_policy_effective_date date null,
    pl_prior_lenders_title bit null,
    pl_prior_lenders_title_policy_amount decimal(15,2) not null,
    pl_prior_lenders_title_policy_effective_date date null,
    pl_bedroom_count_unit_1 int null,
    pl_bedroom_count_unit_2 int null,
    pl_bedroom_count_unit_3 int null,
    pl_bedroom_count_unit_4 int null,
    pl_rent_amount_unit_1 decimal(15,2) not null,
    pl_rent_amount_unit_2 decimal(15,2) not null,
    pl_rent_amount_unit_3 decimal(15,2) not null,
    pl_rent_amount_unit_4 decimal(15,2) not null,
    pl_listed_for_sale_in_last_6_months varchar(128) not null,
    pl_property_in_borrower_trust varchar(128) not null,
    pl_road_type varchar(128) not null,
    pl_water_type varchar(128) not null,
    pl_sanitation_type varchar(128) not null,
    pl_survey_required varchar(128) not null,
    pl_solar_panels_type varchar(128) not null,
    pl_power_purchase_agreement varchar(128) not null,
    pl_solar_panel_provider_name varchar(128) null,
    pl_seller_acquired_date date null,
    pl_seller_original_cost_amount decimal(15) not null,
    pl_remaining_economic_life_years int null,
    pl_bathroom_count_unit_1 int null,
    pl_bathroom_count_unit_2 int null,
    pl_bathroom_count_unit_3 int null,
    pl_bathroom_count_unit_4 int null,
    pl_total_room_count_unit_1 int null,
    pl_total_room_count_unit_2 int null,
    pl_total_room_count_unit_3 int null,
    pl_total_room_count_unit_4 int null,
    pl_gross_living_area_square_feet_unit_1 int null,
    pl_gross_living_area_square_feet_unit_2 int null,
    pl_gross_living_area_square_feet_unit_3 int null,
    pl_gross_living_area_square_feet_unit_4 int null,
    pl_mh_leasehold__property_interest_type varchar(128) not null,
    pl_tribe_name varchar(128) not null,
    pl_leasehold_begin_date date null,
    pl_lease_number varchar(128) not null,
    pl_property_inspection_required bit not null,
    pl_hvac_inspection_required bit not null,
    pl_pest_inspection_required bit not null,
    pl_radon_inspection_required bit not null,
    pl_septic_inspection_required bit not null,
    pl_water_well_inspection_required bit not null,
    pl_structural_inspection_required bit not null,
    pl_pest_inspection_required_auto_compute bit not null,
    pl_management_agent_federal_tax_id varchar(32) not null,
    pl_mh_manufacturer_street_1 varchar(128) not null,
    pl_mh_manufacturer_street_2 varchar(128) not null,
    pl_mh_manufacturer_city varchar(128) not null,
    pl_mh_manufacturer_state varchar(128) not null,
    pl_mh_manufacturer_postal_code varchar(128) not null,
    pl_mh_manufacturer_phone varchar(32) not null,
    pl_mh_manufacturer_phone_extension varchar(16) not null,
    pl_recording_city_name varchar(128) not null,
    pl_abbreviated_legal_description varchar(1024) not null,
    pl_geocode_service_disabled bit not null,
    pl_vesting_confirmed bit not null,
    pl_previous_title_manner_held_description varchar(1024) not null,
    pl_legal_lot_na bit not null,
    pl_legal_block_na bit not null,
    pl_legal_section_na bit not null,
    pl_legal_description_confirmed bit not null,
    pl_lead_inspection_required varchar(128) not null,
    pl_calculated_lead_inspection_required varchar(128) not null,
    pl_geocode_system_error bit not null,
    constraint fk_place_1
        foreign key (pl_proposal_pid) references proposal (prp_pid),
    constraint fk_place_2
        foreign key (pl_county_pid) references county (c_pid),
    constraint fkt_pl_building_status_type
        foreign key (pl_building_status_type) references building_status_type (code),
    constraint fkt_pl_calculated_lead_inspection_required
        foreign key (pl_calculated_lead_inspection_required) references yes_no_unknown_type (code),
    constraint fkt_pl_construction_conversion
        foreign key (pl_construction_conversion) references yes_no_unknown_type (code),
    constraint fkt_pl_coop_existing_company_laws_state
        foreign key (pl_coop_existing_company_laws_state) references state_type (code),
    constraint fkt_pl_country
        foreign key (pl_country) references country_type (code),
    constraint fkt_pl_hud_reo
        foreign key (pl_hud_reo) references yes_no_unknown_type (code),
    constraint fkt_pl_landlord_country
        foreign key (pl_landlord_country) references country_type (code),
    constraint fkt_pl_lava_zone_type
        foreign key (pl_lava_zone_type) references lava_zone_type (code),
    constraint fkt_pl_lead_inspection_required
        foreign key (pl_lead_inspection_required) references yes_no_unknown_type (code),
    constraint fkt_pl_legal_description_type
        foreign key (pl_legal_description_type) references legal_description_type (code),
    constraint fkt_pl_listed_for_sale_in_last_6_months
        foreign key (pl_listed_for_sale_in_last_6_months) references yes_no_unknown_type (code),
    constraint fkt_pl_management_country
        foreign key (pl_management_country) references country_type (code),
    constraint fkt_pl_mh_certificate_of_title_issued
        foreign key (pl_mh_certificate_of_title_issued) references yes_no_unknown_type (code),
    constraint fkt_pl_mh_certificate_of_title_type
        foreign key (pl_mh_certificate_of_title_type) references manufactured_home_certificate_of_title_type (code),
    constraint fkt_pl_mh_leasehold__property_interest_type
        foreign key (pl_mh_leasehold__property_interest_type) references manufactured_home_leasehold_property_interest_type (code),
    constraint fkt_pl_mh_loan_purpose_type
        foreign key (pl_mh_loan_purpose_type) references manufactured_home_loan_purpose_type (code),
    constraint fkt_pl_native_american_lands_type
        foreign key (pl_native_american_lands_type) references native_american_lands_type (code),
    constraint fkt_pl_neighborhood_location_type
        foreign key (pl_neighborhood_location_type) references neighborhood_location_type (code),
    constraint fkt_pl_power_purchase_agreement
        foreign key (pl_power_purchase_agreement) references yes_no_unknown_type (code),
    constraint fkt_pl_project_classification_type
        foreign key (pl_project_classification_type) references project_classification_type (code),
    constraint fkt_pl_project_design_type
        foreign key (pl_project_design_type) references project_design_type (code),
    constraint fkt_pl_property_category_type
        foreign key (pl_property_category_type) references property_category_type (code),
    constraint fkt_pl_property_in_trust
        foreign key (pl_property_in_borrower_trust) references yes_no_unknown_type (code),
    constraint fkt_pl_property_insurance_amount_input_type
        foreign key (pl_property_insurance_amount_input_type) references annual_monthly_type (code),
    constraint fkt_pl_property_rights_type
        foreign key (pl_property_rights_type) references property_rights_type (code),
    constraint fkt_pl_property_tax_amount_input_type
        foreign key (pl_property_tax_amount_input_type) references annual_monthly_type (code),
    constraint fkt_pl_property_usage_type
        foreign key (pl_property_usage_type) references property_usage_type (code),
    constraint fkt_pl_refinance_improvements_type
        foreign key (pl_refinance_improvements_type) references refinance_improvements_type (code),
    constraint fkt_pl_reo_disposition_status_type
        foreign key (pl_reo_disposition_status_type) references reo_disposition_status_type (code),
    constraint fkt_pl_road_type
        foreign key (pl_road_type) references road_type (code),
    constraint fkt_pl_sanitation_type
        foreign key (pl_sanitation_type) references sanitation_type (code),
    constraint fkt_pl_solar_panels_type
        foreign key (pl_solar_panels_type) references solar_panel_type (code),
    constraint fkt_pl_survey_required
        foreign key (pl_survey_required) references yes_no_unknown_type (code),
    constraint fkt_pl_title_manner_held_type
        foreign key (pl_title_manner_held_type) references title_manner_held_type (code),
    constraint fkt_pl_unique_dwelling_type
        foreign key (pl_unique_dwelling_type) references unique_dwelling_type (code),
    constraint fkt_pl_va_guaranteed_reo
        foreign key (pl_va_guaranteed_reo) references yes_no_unknown_type (code),
    constraint fkt_pl_water_type
        foreign key (pl_water_type) references water_type (code)
);

alter table borrower
    add constraint fk_borrower_2
        foreign key (b_mailing_place_pid) references place (pl_pid);

create table borrower_reo
(
    breo_pid bigint auto_increment
        primary key,
    breo_version int not null,
    breo_borrower_pid bigint not null,
    breo_place_pid bigint not null,
    breo_ownership_percent decimal(11,9) not null,
    constraint breo_borrower_pid
        unique (breo_borrower_pid, breo_place_pid),
    constraint fk_borrower_reo_1
        foreign key (breo_borrower_pid) references borrower (b_pid),
    constraint fk_borrower_reo_2
        foreign key (breo_place_pid) references place (pl_pid)
);

create table borrower_residence
(
    bres_pid bigint auto_increment
        primary key,
    bres_version int not null,
    bres_borrower_pid bigint not null,
    bres_place_pid bigint not null,
    bres_current bit null,
    bres_borrower_residency_basis_type varchar(128) not null,
    bres_from_date date not null,
    bres_through_date date null,
    bres_verification_required bit not null,
    constraint bres_borrower_pid
        unique (bres_borrower_pid, bres_place_pid, bres_from_date),
    constraint fk_borrower_residence_1
        foreign key (bres_borrower_pid) references borrower (b_pid),
    constraint fk_borrower_residence_2
        foreign key (bres_place_pid) references place (pl_pid),
    constraint fkt_bres_borrower_residency_basis_type
        foreign key (bres_borrower_residency_basis_type) references borrower_residency_basis_type (code)
);

create table borrower_tax_filing
(
    btf_pid bigint auto_increment
        primary key,
    btf_version int not null,
    btf_borrower_pid bigint not null,
    btf_place_pid bigint null,
    btf_tax_filing_status_type varchar(128) not null,
    btf_year int null,
    btf_joint_is_coborrower bit null,
    btf_joint_filer_first_name varchar(32) null,
    btf_joint_filer_middle_name varchar(32) null,
    btf_joint_filer_last_name varchar(32) null,
    btf_joint_filer_suffix varchar(32) null,
    btf_joint_filer_ssn varchar(128) null,
    constraint uk_borrower_tax_filing_1
        unique (btf_borrower_pid, btf_year),
    constraint fk_borrower_tax_filing_1
        foreign key (btf_borrower_pid) references borrower (b_pid),
    constraint fk_borrower_tax_filing_2
        foreign key (btf_place_pid) references place (pl_pid),
    constraint fkt_btf_tax_filing_status_type
        foreign key (btf_tax_filing_status_type) references tax_filing_status_type (code)
);

create table borrower_va
(
    bva_pid bigint auto_increment
        primary key,
    bva_version int not null,
    bva_borrower_pid bigint not null,
    bva_veteran_status_type varchar(128) not null,
    bva_va_funding_fee_exempt bit null,
    bva_subsequent_use bit null,
    bva_claim_folder_number varchar(32) null,
    bva_benefit_related_indebtedness varchar(128) not null,
    bva_available_entitlement_amount decimal(15,2) null,
    bva_va_entitlement_code_type varchar(128) not null,
    bva_disability_benefits_prior_to_discharge varchar(128) not null,
    bva_active_duty_following_separation varchar(128) not null,
    bva_separated_from_service_due_to_disability varchar(128) not null,
    bva_disability_payments varchar(128) not null,
    bva_surviving_spouse_receiving_dic_payments varchar(128) not null,
    bva_surviving_spouse_dic_claim_number varchar(128) not null,
    bva_deceased_spouse_first_name varchar(32) null,
    bva_deceased_spouse_middle_name varchar(32) null,
    bva_deceased_spouse_last_name varchar(32) null,
    bva_deceased_spouse_name_suffix varchar(32) null,
    bva_deceased_spouse_ssn varchar(128) null,
    bva_deceased_spouse_claim_folder_number varchar(32) null,
    bva_deceased_spouse_claim_folder_location varchar(32) null,
    bva_deceased_spouse_service_number varchar(32) null,
    bva_deceased_spouse_military_branch_type varchar(128) not null,
    bva_deceased_spouse_birth_date date null,
    bva_deceased_spouse_death_date date null,
    bva_deceased_spouse_service_from_date_1 date null,
    bva_deceased_spouse_service_through_date_1 date null,
    bva_deceased_spouse_service_from_date_2 date null,
    bva_deceased_spouse_service_through_date_2 date null,
    bva_deceased_spouse_service_from_date_3 date null,
    bva_deceased_spouse_service_through_date_3 date null,
    bva_previously_applied_for_eligibility varchar(128) not null,
    bva_previously_secured_center_type varchar(128) not null,
    bva_previously_applied_for_eligibility_center_type varchar(128) not null,
    bva_previously_received_certificate_of_eligibility_center_type varchar(128) not null,
    bva_previously_received_certificate_of_eligibility varchar(128) not null,
    bva_previous_loan_address_street1 varchar(128) not null,
    bva_previous_loan_address_street2 varchar(128) not null,
    bva_previous_loan_address_city varchar(128) not null,
    bva_previous_loan_address_state varchar(128) not null,
    bva_previous_loan_address_postal_code varchar(128) not null,
    bva_previous_loan_number varchar(128) not null,
    bva_previous_loan_month int null,
    bva_previous_loan_year int null,
    bva_veteran_poa_verification_date date null,
    bva_relative_first_name varchar(32) not null,
    bva_relative_middle_name varchar(32) not null,
    bva_relative_last_name varchar(32) not null,
    bva_relative_name_suffix varchar(32) not null,
    bva_relative_address_street1 varchar(128) not null,
    bva_relative_address_street2 varchar(128) not null,
    bva_relative_address_city varchar(128) not null,
    bva_relative_address_state varchar(128) not null,
    bva_relative_address_postal_code varchar(128) not null,
    bva_relative_phone_number varchar(32) not null,
    bva_va_relative_relationship_type varchar(128) not null,
    bva_va_relative_relationship_other_description varchar(32) not null,
    bva_service_related_disability bit not null,
    bva_purple_heart_recipient bit not null,
    bva_va_funding_fee_exemption_verified bit not null,
    bva_entitlement_charged_amount decimal(15,2) null,
    bva_used_entitlement_amount decimal(15,2) not null,
    bva_va_entitlement_restoration_type varchar(128) not null,
    bva_previous_use_place_pid bigint null,
    constraint bva_previously_received_cert_of_eligibility_center_type
        foreign key (bva_previously_received_certificate_of_eligibility_center_type) references va_regional_loan_center_type (code),
    constraint fk_borrower_va_1
        foreign key (bva_borrower_pid) references borrower (b_pid),
    constraint fk_bva_previous_use_place_pid
        foreign key (bva_previous_use_place_pid) references place (pl_pid),
    constraint fkt_bva_active_duty_following_separation
        foreign key (bva_active_duty_following_separation) references yes_no_unknown_type (code),
    constraint fkt_bva_benefit_related_indebtedness
        foreign key (bva_benefit_related_indebtedness) references yes_no_unknown_type (code),
    constraint fkt_bva_deceased_spouse_military_branch_type
        foreign key (bva_deceased_spouse_military_branch_type) references military_branch_type (code),
    constraint fkt_bva_disability_benefits_prior_to_discharge
        foreign key (bva_disability_benefits_prior_to_discharge) references yes_no_unknown_type (code),
    constraint fkt_bva_disability_payments
        foreign key (bva_disability_payments) references yes_no_unknown_type (code),
    constraint fkt_bva_previously_applied_for_eligibility
        foreign key (bva_previously_applied_for_eligibility) references yes_no_unknown_type (code),
    constraint fkt_bva_previously_applied_for_eligibility_center_type
        foreign key (bva_previously_applied_for_eligibility_center_type) references va_regional_loan_center_type (code),
    constraint fkt_bva_previously_received_certificate_of_eligibility
        foreign key (bva_previously_received_certificate_of_eligibility) references yes_no_unknown_type (code),
    constraint fkt_bva_previously_secured_center_type
        foreign key (bva_previously_secured_center_type) references va_regional_loan_center_type (code),
    constraint fkt_bva_separated_from_service_due_to_disability
        foreign key (bva_separated_from_service_due_to_disability) references yes_no_unknown_type (code),
    constraint fkt_bva_surviving_spouse_receiving_dic_payments
        foreign key (bva_surviving_spouse_receiving_dic_payments) references yes_no_unknown_type (code),
    constraint fkt_bva_va_entitlement_code_type
        foreign key (bva_va_entitlement_code_type) references va_entitlement_code_type (code),
    constraint fkt_bva_va_entitlement_restoration_type
        foreign key (bva_va_entitlement_restoration_type) references va_entitlement_restoration_type (code),
    constraint fkt_bva_va_relative_relationship_type
        foreign key (bva_va_relative_relationship_type) references va_relative_relationship_type (code),
    constraint fkt_bva_veteran_status_type
        foreign key (bva_veteran_status_type) references veteran_status_type (code)
);

create index idx_place_1
    on place (pl_state);

create table profit_margin_detail
(
    pmd_pid bigint auto_increment
        primary key,
    pmd_version int not null,
    pmd_lender_lock_minor_pid bigint not null,
    pmd_profit_margin_type varchar(128) not null,
    pmd_description varchar(128) null,
    pmd_percent decimal(11,9) not null,
    pmd_dollars decimal(15,2) not null,
    pmd_adjustment_description varchar(16000) not null,
    constraint fk_profit_margin_detail_1
        foreign key (pmd_lender_lock_minor_pid) references lender_lock_minor (llmn_pid),
    constraint fkt_pmd_profit_margin_type
        foreign key (pmd_profit_margin_type) references profit_margin_type (code)
);

create index idx_profit_margin_detail_1
    on profit_margin_detail (pmd_lender_lock_minor_pid);

create index idx_proposal_1
    on proposal (prp_create_datetime);

create table proposal_contractor
(
    pctr_pid bigint auto_increment
        primary key,
    pctr_version int not null,
    pctr_proposal_pid bigint not null,
    pctr_contractor_pid bigint not null,
    constraint fk_proposal_contractor_1
        foreign key (pctr_proposal_pid) references proposal (prp_pid),
    constraint fk_proposal_contractor_2
        foreign key (pctr_contractor_pid) references contractor (ctr_pid)
);

create table construction_cost
(
    coc_pid bigint auto_increment
        primary key,
    coc_version int not null,
    coc_proposal_pid bigint not null,
    coc_construction_cost_category_type varchar(128) not null,
    coc_construction_cost_funding_type varchar(128) not null,
    coc_construction_cost_status_type varchar(128) not null,
    coc_construction_cost_payee_type varchar(128) not null,
    coc_create_datetime datetime not null,
    coc_construction_cost_amount decimal(15,2) not null,
    coc_construction_cost_notes varchar(1024) not null,
    coc_contractor_pid bigint null,
    coc_proposal_contractor_pid bigint null,
    coc_payee varchar(128) not null,
    constraint fk_construction_cost_1
        foreign key (coc_proposal_pid) references proposal (prp_pid),
    constraint fk_construction_cost_2
        foreign key (coc_contractor_pid) references contractor (ctr_pid),
    constraint fk_construction_cost_3
        foreign key (coc_proposal_contractor_pid) references proposal_contractor (pctr_pid),
    constraint fkt_coc_construction_cost_category_type
        foreign key (coc_construction_cost_category_type) references construction_cost_category_type (code),
    constraint fkt_coc_construction_cost_funding_type
        foreign key (coc_construction_cost_funding_type) references construction_cost_funding_type (code),
    constraint fkt_coc_construction_cost_payee_type
        foreign key (coc_construction_cost_payee_type) references construction_cost_payee_type (code),
    constraint fkt_coc_construction_cost_status_type
        foreign key (coc_construction_cost_status_type) references construction_cost_status_type (code)
);

create table construction_draw_item
(
    cdi_pid bigint auto_increment
        primary key,
    cdi_version int not null,
    cdi_proposal_pid bigint not null,
    cdi_construction_cost_pid bigint not null,
    cdi_construction_draw_pid bigint not null,
    cdi_construction_draw_item_amount decimal(15,2) not null,
    cdi_construction_draw_item_borrower_contribution_amount decimal(15,2) not null,
    cdi_construction_draw_item_lender_contribution_amount decimal(15,2) not null,
    constraint fk_construction_draw_item_1
        foreign key (cdi_proposal_pid) references proposal (prp_pid),
    constraint fk_construction_draw_item_2
        foreign key (cdi_construction_cost_pid) references construction_cost (coc_pid),
    constraint fk_construction_draw_item_3
        foreign key (cdi_construction_draw_pid) references construction_draw (cd_pid)
);

create table proposal_doc_set
(
    prpds_pid bigint auto_increment
        primary key,
    prpds_version int not null,
    prpds_proposal_pid bigint not null,
    prpds_smart_doc_set_pid bigint not null,
    prpds_create_datetime datetime not null,
    prpds_delivered_or_mailed_datetime datetime null,
    prpds_creator_agent_type varchar(128) not null,
    prpds_creator_lender_user_pid bigint null,
    prpds_creator_unparsed_name varchar(128) null,
    prpds_requested_datetime datetime null,
    prpds_requester_agent_type varchar(128) not null,
    prpds_requester_lender_user_pid bigint null,
    prpds_requester_unparsed_name varchar(128) null,
    prpds_signed_date date null,
    prpds_delivery_method_type varchar(128) not null,
    prpds_tracking_number varchar(32) null,
    prpds_affects_earliest_allowed_consummation_date bit null,
    prpds_name varchar(128) not null,
    prpds_docusign_package_pid bigint null,
    prpds_esign_vendor_type varchar(128) not null,
    prpds_esign_evidence_deal_file_pid bigint null,
    prpds_doc_package_status_type varchar(128) not null,
    prpds_canceled_reason_type varchar(128) not null,
    prpds_canceled_datetime datetime null,
    prpds_canceler_agent_type varchar(128) not null,
    prpds_canceler_lender_user_pid bigint null,
    prpds_canceler_unparsed_name varchar(128) not null,
    prpds_canceled_reason varchar(16000) not null,
    prpds_proposal_doc_set_id int not null,
    constraint uk_proposal_doc_set_2
        unique (prpds_proposal_pid, prpds_smart_doc_set_pid, prpds_proposal_doc_set_id),
    constraint fk_proposal_doc_set_1
        foreign key (prpds_proposal_pid) references proposal (prp_pid),
    constraint fk_proposal_doc_set_2
        foreign key (prpds_smart_doc_set_pid) references smart_doc_set (sdst_pid),
    constraint fk_proposal_doc_set_4
        foreign key (prpds_esign_evidence_deal_file_pid) references deal_file (df_pid),
    constraint fk_proposal_doc_set_5
        foreign key (prpds_docusign_package_pid) references docusign_package (dcsp_pid),
    constraint fk_proposal_doc_set_7
        foreign key (prpds_requester_lender_user_pid) references lender_user (lu_pid),
    constraint fk_proposal_doc_set_8
        foreign key (prpds_creator_lender_user_pid) references lender_user (lu_pid),
    constraint fk_proposal_doc_set_9
        foreign key (prpds_canceler_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_prpds_canceled_reason_type
        foreign key (prpds_canceled_reason_type) references doc_package_canceled_reason_type (code),
    constraint fkt_prpds_canceler_agent_type
        foreign key (prpds_canceler_agent_type) references agent_type (code),
    constraint fkt_prpds_creator_agent_type
        foreign key (prpds_creator_agent_type) references agent_type (code),
    constraint fkt_prpds_delivery_method_type
        foreign key (prpds_delivery_method_type) references doc_package_delivery_method_type (code),
    constraint fkt_prpds_doc_package_status_type
        foreign key (prpds_doc_package_status_type) references doc_package_status_type (code),
    constraint fkt_prpds_esign_vendor_type
        foreign key (prpds_esign_vendor_type) references esign_vendor_type (code),
    constraint fkt_prpds_requester_agent_type
        foreign key (prpds_requester_agent_type) references agent_type (code)
);

create table proposal_doc_set_id_ticker
(
    pdstk_pid bigint auto_increment
        primary key,
    pdstk_version int not null,
    pdstk_proposal_pid bigint not null,
    pdstk_smart_doc_set_pid bigint not null,
    pdstk_next_proposal_doc_set_id int not null,
    constraint uk_proposal_doc_set_id_ticker_1
        unique (pdstk_proposal_pid, pdstk_smart_doc_set_pid),
    constraint fk_proposal_doc_set_id_ticker_1
        foreign key (pdstk_proposal_pid) references proposal (prp_pid),
    constraint fk_proposal_doc_set_id_ticker_2
        foreign key (pdstk_smart_doc_set_pid) references smart_doc_set (sdst_pid)
);

create table proposal_doc_set_signer
(
    prpdss_pid bigint auto_increment
        primary key,
    prpdss_version int not null,
    prpdss_proposal_doc_set_pid bigint not null,
    prpdss_deal_signer_pid bigint not null,
    prpdss_esign_complete bit null,
    prpdss_received_datetime datetime null,
    prpdss_signed_datetime datetime null,
    constraint uk_proposal_doc_set_signer_1
        unique (prpdss_proposal_doc_set_pid, prpdss_deal_signer_pid),
    constraint fk_proposal_doc_set_signer_1
        foreign key (prpdss_proposal_doc_set_pid) references proposal_doc_set (prpds_pid),
    constraint fk_proposal_doc_set_signer_2
        foreign key (prpdss_deal_signer_pid) references deal_signer (dsi_pid)
);

create table proposal_doc_set_snapshot
(
    prpdssn_pid bigint auto_increment
        primary key,
    prpdssn_version int not null,
    prpdssn_proposal_doc_set_pid bigint not null,
    prpdssn_snapshot_proposal_pid bigint not null,
    constraint fk_proposal_doc_set_snapshot_1
        foreign key (prpdssn_proposal_doc_set_pid) references proposal_doc_set (prpds_pid),
    constraint fk_proposal_doc_set_snapshot_2
        foreign key (prpdssn_snapshot_proposal_pid) references proposal (prp_pid)
);

create table proposal_engagement
(
    prpe_pid bigint auto_increment
        primary key,
    prpe_version int not null,
    prpe_proposal_pid bigint not null,
    prpe_borrower_engagement_percent decimal(11,9) not null,
    constraint uk_proposal_engagement_1
        unique (prpe_proposal_pid),
    constraint fk_proposal_engagement_1
        foreign key (prpe_proposal_pid) references proposal (prp_pid)
);

create table proposal_grant_program
(
    pgp_pid bigint auto_increment
        primary key,
    pgp_version int not null,
    pgp_proposal_pid bigint not null,
    pgp_account_grant_program_pid bigint not null,
    pgp_grant_amount decimal(15,2) not null,
    constraint fk_proposal_grant_program_1
        foreign key (pgp_proposal_pid) references proposal (prp_pid),
    constraint fk_proposal_grant_program_2
        foreign key (pgp_account_grant_program_pid) references account_grant_program (agp_pid)
);

create table proposal_review
(
    prpre_pid bigint auto_increment
        primary key,
    prpre_version int not null,
    prpre_proposal_pid bigint not null,
    prpre_request_id int not null,
    prpre_request_datetime datetime not null,
    prpre_request_by_lender_user_pid bigint not null,
    prpre_request_summary text not null,
    prpre_proposal_review_status_type varchar(128) not null,
    prpre_decision_datetime datetime null,
    prpre_decision_by_lender_user_pid bigint null,
    prpre_decision_summary text not null,
    constraint uk_proposal_review_1
        unique (prpre_proposal_pid, prpre_request_id),
    constraint fk_proposal_review_1
        foreign key (prpre_proposal_pid) references proposal (prp_pid),
    constraint fk_proposal_review_2
        foreign key (prpre_request_by_lender_user_pid) references lender_user (lu_pid),
    constraint fk_proposal_review_3
        foreign key (prpre_decision_by_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_prpre_proposal_review_status_type
        foreign key (prpre_proposal_review_status_type) references proposal_review_status_type (code)
);

create table proposal_review_ticker
(
    prpret_pid bigint auto_increment
        primary key,
    prpret_version int not null,
    prpret_proposal_pid bigint not null,
    prpret_next_id int not null,
    constraint uk_proposal_review_ticker_1
        unique (prpret_proposal_pid),
    constraint fk_proposal_review_ticker_1
        foreign key (prpret_proposal_pid) references proposal (prp_pid)
);

create table proposal_summary
(
    ps_pid bigint auto_increment
        primary key,
    ps_version int not null,
    ps_proposal_pid bigint not null,
    ps_subject_property_city varchar(128) null,
    ps_subject_property_country varchar(128) not null,
    ps_subject_property_postal_code varchar(128) null,
    ps_subject_property_state varchar(128) null,
    ps_subject_property_street1 varchar(128) null,
    ps_subject_property_street2 varchar(128) null,
    ps_note_rate_percent_main decimal(11,9) not null,
    ps_note_rate_percent_piggyback decimal(11,9) not null,
    ps_initial_note_rate_percent_main decimal(11,9) not null,
    ps_initial_note_rate_percent_piggyback decimal(11,9) not null,
    ps_base_loan_amount_main decimal(17,2) not null,
    ps_base_loan_amount_piggyback decimal(17,2) not null,
    ps_loan_amount_main decimal(17,2) not null,
    ps_loan_amount_piggyback decimal(17,2) not null,
    ps_product_special_program_type_main varchar(128) not null,
    ps_product_special_program_type_piggyback varchar(128) not null,
    ps_investor_pid_main bigint null,
    ps_investor_pid_piggyback bigint null,
    ps_product_fnm_community_lending_product_type_main varchar(128) not null,
    ps_product_fnm_community_lending_product_type_piggyback varchar(128) not null,
    ps_product_fre_community_program_type_main varchar(128) not null,
    ps_product_fre_community_program_type_piggyback varchar(128) not null,
    ps_mortgage_type_main varchar(128) not null,
    ps_mortgage_type_piggyback varchar(128) not null,
    ps_b1_first_name varchar(32) not null,
    ps_c1_first_name varchar(32) null,
    ps_b2_first_name varchar(32) null,
    ps_b1_last_name varchar(32) not null,
    ps_c1_last_name varchar(32) null,
    ps_b2_last_name varchar(32) null,
    ps_b1_middle_name varchar(32) null,
    ps_c1_middle_name varchar(32) null,
    ps_b2_middle_name varchar(32) null,
    ps_b1_preferred_first_name varchar(32) not null,
    ps_b2_preferred_first_name varchar(32) not null,
    ps_c1_preferred_first_name varchar(32) not null,
    ps_b1_birth_date date null,
    ps_c1_birth_date date null,
    ps_b1_monthly_income decimal(15,2) not null,
    ps_c1_monthly_income decimal(15,2) not null,
    ps_b2_monthly_income decimal(15,2) not null,
    ps_b1_has_business_income bit null,
    ps_c1_has_business_income bit null,
    ps_b2_has_business_income bit null,
    ps_b1_citizenship_residency_type varchar(128) not null,
    ps_c1_citizenship_residency_type varchar(128) not null,
    ps_b2_citizenship_residency_type varchar(128) not null,
    ps_b1_hmda_ethnicity_2017_type varchar(128) not null,
    ps_c1_hmda_ethnicity_2017_type varchar(128) not null,
    ps_b2_hmda_ethnicity_2017_type varchar(128) not null,
    ps_b1_decision_credit_score int null,
    ps_c1_decision_credit_score int null,
    ps_b2_decision_credit_score int null,
    ps_b1_gender_type varchar(128) not null,
    ps_c1_gender_type varchar(128) not null,
    ps_b2_gender_type varchar(128) not null,
    ps_b1_ssn varchar(128) null,
    ps_c1_ssn varchar(128) null,
    ps_b2_ssn varchar(128) null,
    ps_b1_hmda_race_2017_type varchar(128) not null,
    ps_c1_hmda_race_2017_type varchar(128) not null,
    ps_b2_hmda_race_2017_type varchar(128) not null,
    ps_any_lender_employee_borrower bit not null,
    ps_upfront_mi_percent_main decimal(11,9) not null,
    ps_upfront_mi_percent_piggyback decimal(11,9) not null,
    ps_primary_application_name varchar(128) not null,
    ps_investor_loan_id_main varchar(32) not null,
    ps_investor_loan_id_piggyback varchar(32) not null,
    ps_initial_servicer_investor_loan_id_main varchar(32) not null,
    ps_initial_servicer_investor_loan_id_piggyback varchar(32) not null,
    ps_current_servicer_investor_loan_id_main varchar(32) not null,
    ps_current_servicer_investor_loan_id_piggyback varchar(32) not null,
    ps_offering_id_main varchar(32) not null,
    ps_offering_id_piggyback varchar(32) not null,
    ps_proposal_structure_type varchar(128) not null,
    ps_loan_maturity_date_main date null,
    ps_loan_maturity_date_piggyback date null,
    ps_ltv_ratio_percent_main decimal(11,9) not null,
    ps_ltv_ratio_percent_piggyback decimal(11,9) not null,
    ps_cltv_ratio_percent decimal(11,9) not null,
    ps_hcltv_ratio_percent decimal(11,9) not null,
    ps_hcltv_applicable bit null,
    ps_debt_ratio_percent decimal(11,9) not null,
    ps_housing_ratio_percent decimal(11,9) not null,
    ps_property_category_type varchar(128) not null,
    ps_any_first_time_home_buyer bit null,
    ps_primary_housing_expense_amount decimal(15,2) not null,
    ps_non_primary_housing_expense_amount decimal(15,2) not null,
    ps_income_monthly_total_amount decimal(15,2) not null,
    ps_asset_total_amount decimal(15,2) not null,
    ps_liquid_asset_total_amount decimal(15,2) not null,
    ps_liability_unpaid_balance_total_amount decimal(15,2) not null,
    ps_liability_monthly_payment_total_amount decimal(15,2) not null,
    ps_monthly_pitia_amount decimal(15,2) not null,
    ps_cash_from_borrower_amount_signed decimal(15,2) not null,
    ps_proposed_monthly_housing_and_debt_amount decimal(15,2) not null,
    ps_funding_date_main date null,
    ps_funding_date_piggyback date null,
    ps_interim_funder_company_name varchar(128) null,
    ps_interim_funder_mers_org_id varchar(7) null,
    ps_funding_scheduled_release_date_main date null,
    ps_funding_scheduled_release_date_piggyback date null,
    ps_uuts_aus_recommendation_description varchar(32) null,
    ps_interest_rate_fee_amount_signed decimal(15,2) not null,
    ps_interest_rate_fee_amount_signed_main decimal(15,2) not null,
    ps_interest_rate_fee_amount_signed_piggyback decimal(15,2) not null,
    ps_origination_fees_amount_signed decimal(15,2) not null,
    ps_origination_fees_amount_signed_main decimal(15,2) not null,
    ps_origination_fees_amount_signed_piggyback decimal(15,2) not null,
    ps_any_escrow_waived bit null,
    ps_initial_rate_adjustment_date_main date null,
    ps_initial_rate_adjustment_date_piggyback date null,
    ps_tolerance_cure_amount_signed decimal(15,2) null,
    ps_tolerance_cure_amount_signed_main decimal(15,2) null,
    ps_tolerance_cure_amount_signed_piggyback decimal(15,2) null,
    ps_subject_property_existing_subordinate_2nd bit not null,
    ps_subject_property_subordinate_2nd_creditor_pid bigint null,
    ps_subject_property_existing_subordinate_3rd bit not null,
    ps_subject_property_subordinate_3rd_creditor_pid bigint null,
    ps_total_monthly_solar_lease_payments_amount decimal(15,2) not null,
    ps_total_debt_payoff_amount decimal(15,2) not null,
    ps_total_new_subordinate_financing_amount decimal(15,2) not null,
    ps_total_grant_amount decimal(15,2) not null,
    ps_any_third_party_community_second bit not null,
    ps_any_grant_program bit not null,
    ps_initial_loan_estimate_loan_amount_main decimal(17,2) not null,
    ps_initial_loan_estimate_loan_amount_piggyback decimal(17,2) not null,
    ps_any_mortgage_credit_certificate bit not null,
    ps_debt_ratio_excluding_mi_percent decimal(11,9) not null,
    ps_fund_source_type_main varchar(128) not null,
    ps_fund_source_type_piggyback varchar(128) not null,
    ps_mortgage_credit_certificate_issuer_pid bigint null,
    ps_subject_property_new_subordinate_2nd bit not null,
    ps_subject_property_new_subordinate_3rd bit not null,
    ps_any_borrower_self_employed bit not null,
    ps_fha_section_of_act_coarse_type_main varchar(128) not null,
    ps_fha_section_of_act_coarse_type_piggyback varchar(128) not null,
    ps_fha_special_program_type_main varchar(128) not null,
    ps_fha_special_program_type_piggyback varchar(128) not null,
    ps_product_pid_main bigint null,
    ps_product_pid_piggyback bigint null,
    ps_net_origination_charge_main decimal(15,2) not null,
    ps_net_origination_charge_piggyback decimal(15,2) not null,
    ps_household_income_guideline_percent decimal(22,9) not null,
    ps_applicant_count tinyint not null,
    ps_early_wire_total_charge_amount_main decimal(15,2) not null,
    ps_early_wire_total_charge_amount_piggyback decimal(15,2) not null,
    ps_funding_scheduled_release_date_auto_compute_main bit not null,
    ps_funding_scheduled_release_date_auto_compute_piggyback bit not null,
    constraint uk_proposal_summary_1
        unique (ps_proposal_pid),
    constraint fk_proposal_summary_1
        foreign key (ps_proposal_pid) references proposal (prp_pid),
    constraint fk_proposal_summary_2
        foreign key (ps_subject_property_subordinate_2nd_creditor_pid) references creditor (crd_pid),
    constraint fk_proposal_summary_3
        foreign key (ps_subject_property_subordinate_3rd_creditor_pid) references creditor (crd_pid),
    constraint fk_proposal_summary_4
        foreign key (ps_investor_pid_main) references investor (i_pid),
    constraint fk_proposal_summary_5
        foreign key (ps_investor_pid_piggyback) references investor (i_pid),
    constraint fk_proposal_summary_6
        foreign key (ps_mortgage_credit_certificate_issuer_pid) references mortgage_credit_certificate_issuer (mcci_pid),
    constraint fk_proposal_summary_7
        foreign key (ps_product_pid_main) references product (p_pid),
    constraint fk_proposal_summary_8
        foreign key (ps_product_pid_piggyback) references product (p_pid),
    constraint fkt_ps_b1_citizenship_residency_type
        foreign key (ps_b1_citizenship_residency_type) references citizenship_residency_type (code),
    constraint fkt_ps_b1_gender_type
        foreign key (ps_b1_gender_type) references gender_type (code),
    constraint fkt_ps_b1_hmda_ethnicity_type
        foreign key (ps_b1_hmda_ethnicity_2017_type) references hmda_ethnicity_2017_type (code),
    constraint fkt_ps_b1_hmda_race_type
        foreign key (ps_b1_hmda_race_2017_type) references hmda_race_2017_type (code),
    constraint fkt_ps_b2_citizenship_residency_type
        foreign key (ps_b2_citizenship_residency_type) references citizenship_residency_type (code),
    constraint fkt_ps_b2_gender_type
        foreign key (ps_b2_gender_type) references gender_type (code),
    constraint fkt_ps_b2_hmda_ethnicity_type
        foreign key (ps_b2_hmda_ethnicity_2017_type) references hmda_ethnicity_2017_type (code),
    constraint fkt_ps_b2_hmda_race_type
        foreign key (ps_b2_hmda_race_2017_type) references hmda_race_2017_type (code),
    constraint fkt_ps_c1_citizenship_residency_type
        foreign key (ps_c1_citizenship_residency_type) references citizenship_residency_type (code),
    constraint fkt_ps_c1_gender_type
        foreign key (ps_c1_gender_type) references gender_type (code),
    constraint fkt_ps_c1_hmda_ethnicity_type
        foreign key (ps_c1_hmda_ethnicity_2017_type) references hmda_ethnicity_2017_type (code),
    constraint fkt_ps_c1_hmda_race_type
        foreign key (ps_c1_hmda_race_2017_type) references hmda_race_2017_type (code),
    constraint fkt_ps_fha_section_of_act_coarse_type_main
        foreign key (ps_fha_section_of_act_coarse_type_main) references section_of_act_coarse_type (code),
    constraint fkt_ps_fha_section_of_act_coarse_type_piggyback
        foreign key (ps_fha_section_of_act_coarse_type_piggyback) references section_of_act_coarse_type (code),
    constraint fkt_ps_fha_special_program_type_main
        foreign key (ps_fha_special_program_type_main) references fha_special_program_type (code),
    constraint fkt_ps_fha_special_program_type_piggyback
        foreign key (ps_fha_special_program_type_piggyback) references fha_special_program_type (code),
    constraint fkt_ps_fund_source_type_main
        foreign key (ps_fund_source_type_main) references fund_source_type (code),
    constraint fkt_ps_fund_source_type_piggyback
        foreign key (ps_fund_source_type_piggyback) references fund_source_type (code),
    constraint fkt_ps_mortgage_type_main
        foreign key (ps_mortgage_type_main) references mortgage_type (code),
    constraint fkt_ps_mortgage_type_piggyback
        foreign key (ps_mortgage_type_piggyback) references mortgage_type (code),
    constraint fkt_ps_product_fnm_community_lending_product_type_main
        foreign key (ps_product_fnm_community_lending_product_type_main) references fnm_community_lending_product_type (code),
    constraint fkt_ps_product_fnm_community_lending_product_type_piggyback
        foreign key (ps_product_fnm_community_lending_product_type_piggyback) references fnm_community_lending_product_type (code),
    constraint fkt_ps_product_fre_community_program_type_main
        foreign key (ps_product_fre_community_program_type_main) references fre_community_program_type (code),
    constraint fkt_ps_product_fre_community_program_type_piggyback
        foreign key (ps_product_fre_community_program_type_piggyback) references fre_community_program_type (code),
    constraint fkt_ps_product_special_program_type_main
        foreign key (ps_product_special_program_type_main) references product_special_program_type (code),
    constraint fkt_ps_product_special_program_type_piggyback
        foreign key (ps_product_special_program_type_piggyback) references product_special_program_type (code),
    constraint fkt_ps_property_category_type
        foreign key (ps_property_category_type) references property_category_type (code),
    constraint fkt_ps_proposal_structure_type
        foreign key (ps_proposal_structure_type) references proposal_structure_type (code),
    constraint fkt_ps_subject_property_country
        foreign key (ps_subject_property_country) references country_type (code)
);

create index idx_proposal_summary_1
    on proposal_summary (ps_subject_property_street1);

create index idx_proposal_summary_2
    on proposal_summary (ps_subject_property_street2);

create index idx_proposal_summary_3
    on proposal_summary (ps_subject_property_city);

create index idx_proposal_summary_4
    on proposal_summary (ps_investor_loan_id_main);

create index idx_proposal_summary_5
    on proposal_summary (ps_investor_loan_id_piggyback);

create index idx_proposal_summary_6
    on proposal_summary (ps_subject_property_state);

create index idx_proposal_summary_7
    on proposal_summary (ps_funding_date_main);

create index idx_proposal_summary_8
    on proposal_summary (ps_funding_date_piggyback);

create table pte_request
(
    pter_pid bigint auto_increment
        primary key,
    pter_version int not null,
    pter_proposal_pid bigint not null,
    pter_create_datetime datetime not null,
    pter_pte_request_status_type varchar(128) not null,
    pter_pte_response_status_type varchar(128) not null,
    pter_pte_error_messages text not null,
    pter_address_street1 varchar(128) not null,
    pter_address_street2 varchar(128) not null,
    pter_address_city varchar(128) not null,
    pter_address_state varchar(128) not null,
    pter_address_postal_code varchar(128) not null,
    pter_response_xml_pid bigint null,
    pter_response_pdf_file_pid bigint null,
    pter_submitting_party_order_id varchar(128) not null,
    pter_responding_party_order_id varchar(32) not null,
    pter_fulfillment_party_order_id varchar(32) not null,
    pter_building_status_type varchar(128) not null,
    pter_loan_purpose_type varchar(128) not null,
    pter_effective_property_value_amount decimal(15) not null,
    pter_property_usage_type varchar(128) not null,
    constraint fk_pte_request_1
        foreign key (pter_proposal_pid) references proposal (prp_pid),
    constraint fk_pte_request_2
        foreign key (pter_response_xml_pid) references deal_system_file (dsf_pid),
    constraint fk_pte_request_3
        foreign key (pter_response_pdf_file_pid) references deal_file (df_pid),
    constraint fkt_pter_building_status_type
        foreign key (pter_building_status_type) references building_status_type (code),
    constraint fkt_pter_loan_purpose_type
        foreign key (pter_loan_purpose_type) references loan_purpose_type (code),
    constraint fkt_pter_property_usage_type
        foreign key (pter_property_usage_type) references property_usage_type (code),
    constraint fkt_pter_pte_request_status_type
        foreign key (pter_pte_request_status_type) references pte_request_status_type (code),
    constraint fkt_pter_pte_response_status_type
        foreign key (pter_pte_response_status_type) references pte_response_status_type (code)
);

create table public_record
(
    pr_pid bigint auto_increment
        primary key,
    pr_version int not null,
    pr_proposal_pid bigint not null,
    pr_credit_request_pid bigint null,
    pr_public_record_type varchar(128) not null,
    pr_public_record_type_other_description varchar(32) null,
    pr_public_record_disposition_type varchar(128) not null,
    pr_report_public_record_disposition_type varchar(128) not null,
    pr_disposition_date date null,
    pr_filed_date date null,
    pr_reported_date date null,
    pr_settled_date date null,
    pr_paid_date date null,
    pr_docket_id varchar(32) null,
    pr_bankruptcy_exception_type varchar(128) not null,
    pr_bankruptcy_assets_amount decimal(15,2) not null,
    pr_bankruptcy_exempt_amount decimal(15,2) not null,
    pr_bankruptcy_liabilities_amount decimal(15,2) not null,
    pr_legal_obligation_amount decimal(15,2) not null,
    pr_court_name varchar(128) null,
    pr_plaintiff_name varchar(128) null,
    pr_defendant_name varchar(128) null,
    pr_attorney_name varchar(128) null,
    pr_comment varchar(16000) null,
    pr_note varchar(1024) null,
    pr_equifax_included bit null,
    pr_experian_included bit null,
    pr_trans_union_included bit null,
    pr_credit_report_identifier varchar(32) not null,
    constraint fk_public_record_1
        foreign key (pr_proposal_pid) references proposal (prp_pid),
    constraint fk_public_record_2
        foreign key (pr_credit_request_pid) references credit_request (crdr_pid),
    constraint fkt_pr_bankruptcy_exception_type
        foreign key (pr_bankruptcy_exception_type) references bankruptcy_exception_type (code),
    constraint fkt_pr_public_record_disposition_type
        foreign key (pr_public_record_disposition_type) references public_record_disposition_type (code),
    constraint fkt_pr_public_record_type
        foreign key (pr_public_record_type) references public_record_type (code),
    constraint fkt_pr_report_public_record_disposition_type
        foreign key (pr_report_public_record_disposition_type) references public_record_disposition_type (code)
);

create table borrower_public_record
(
    bpr_pid bigint auto_increment
        primary key,
    bpr_version int not null,
    bpr_borrower_pid bigint not null,
    bpr_public_record_pid bigint not null,
    constraint bpr_borrower_pid
        unique (bpr_borrower_pid, bpr_public_record_pid),
    constraint fk_borrower_public_record_1
        foreign key (bpr_borrower_pid) references borrower (b_pid),
    constraint fk_borrower_public_record_2
        foreign key (bpr_public_record_pid) references public_record (pr_pid)
);

create table rental_income
(
    ri_pid bigint auto_increment
        primary key,
    ri_version int not null,
    ri_borrower_income_pid bigint not null,
    ri_place_pid bigint not null,
    ri_schedule_e_input bit null,
    ri_rental_income_estimated_mode bit null,
    ri_rental_income_estimated_gross_monthly_amount decimal(15,2) not null,
    ri_simple_monthly_total_amount decimal(15,2) not null,
    ri_schedule_e_calculated_gross_monthly_amount decimal(15,2) not null,
    ri_schedule_e_proposed_monthly_expense_amount decimal(15,2) not null,
    ri_schedule_e_net_monthly_amount decimal(15,2) not null,
    ri_rental_income_monthly_total_amount decimal(15,2) not null,
    ri_schedule_e_non_recurring_expense_1 varchar(128) null,
    ri_schedule_e_non_recurring_expense_2 varchar(128) null,
    ri_schedule_e_non_recurring_expense_3 varchar(128) null,
    ri_rental_income_calc_method varchar(128) not null,
    ri_common_year1_year int null,
    ri_common_year1_year_include bit null,
    ri_common_year1_from_date date null,
    ri_common_year1_through_date date null,
    ri_common_year1_months decimal(4,2) null,
    ri_common_year1_annual_total_amount decimal(15,2) null,
    ri_common_year1_monthly_total_amount decimal(15,2) not null,
    ri_common_year2_year int null,
    ri_common_year2_year_include bit null,
    ri_common_year2_from_date date null,
    ri_common_year2_through_date date null,
    ri_common_year2_months decimal(4,2) null,
    ri_common_year2_annual_total_amount decimal(15,2) null,
    ri_common_year2_monthly_total_amount decimal(15,2) not null,
    ri_common_year3_year int null,
    ri_common_year3_year_include bit null,
    ri_common_year3_from_date date null,
    ri_common_year3_through_date date null,
    ri_common_year3_months decimal(4,2) null,
    ri_common_year3_annual_total_amount decimal(15,2) null,
    ri_common_year3_monthly_total_amount decimal(15,2) not null,
    ri_schedule_e_year1_rent_received_amount decimal(15,2) null,
    ri_schedule_e_year1_advertising_expense_amount decimal(15,2) not null,
    ri_schedule_e_year1_auto_travel_expense_amount decimal(15,2) not null,
    ri_schedule_e_year1_cleaning_maintenance_expense_amount decimal(15,2) not null,
    ri_schedule_e_year1_commissions_expense_amount decimal(15,2) not null,
    ri_schedule_e_year1_insurance_expense_amount decimal(15,2) not null,
    ri_schedule_e_year1_legal_professional_expense_amount decimal(15,2) not null,
    ri_schedule_e_year1_management_expense_amount decimal(15,2) not null,
    ri_schedule_e_year1_mortgage_interest_expense_amount decimal(15,2) not null,
    ri_schedule_e_year1_other_interest_expense_amount decimal(15,2) not null,
    ri_schedule_e_year1_repairs_expense_amount decimal(15,2) not null,
    ri_schedule_e_year1_supplies_expense_amount decimal(15,2) not null,
    ri_schedule_e_year1_taxes_expense_amount decimal(15,2) not null,
    ri_schedule_e_year1_utilities_expense_amount decimal(15,2) not null,
    ri_schedule_e_year1_depreciation_expense_amount decimal(15,2) not null,
    ri_schedule_e_year1_other_expense_amount decimal(15,2) not null,
    ri_schedule_e_year1_total_expense_amount decimal(15,2) not null,
    ri_schedule_e_year1_non_recurring_expense_amount_1 decimal(15,2) not null,
    ri_schedule_e_year1_non_recurring_expense_amount_2 decimal(15,2) not null,
    ri_schedule_e_year1_non_recurring_expense_amount_3 decimal(15,2) not null,
    ri_schedule_e_year1_insurance_credit_amount decimal(15,2) not null,
    ri_schedule_e_year1_taxes_credit_amount decimal(15,2) not null,
    ri_schedule_e_year1_annual_subtotal decimal(15,2) not null,
    ri_schedule_e_year1_ownership_percent decimal(11,9) not null,
    ri_schedule_e_year2_rent_received_amount decimal(15,2) null,
    ri_schedule_e_year2_advertising_expense_amount decimal(15,2) not null,
    ri_schedule_e_year2_auto_travel_expense_amount decimal(15,2) not null,
    ri_schedule_e_year2_cleaning_maintenance_expense_amount decimal(15,2) not null,
    ri_schedule_e_year2_commissions_expense_amount decimal(15,2) not null,
    ri_schedule_e_year2_insurance_expense_amount decimal(15,2) not null,
    ri_schedule_e_year2_legal_professional_expense_amount decimal(15,2) not null,
    ri_schedule_e_year2_management_expense_amount decimal(15,2) not null,
    ri_schedule_e_year2_mortgage_interest_expense_amount decimal(15,2) not null,
    ri_schedule_e_year2_other_interest_expense_amount decimal(15,2) not null,
    ri_schedule_e_year2_repairs_expense_amount decimal(15,2) not null,
    ri_schedule_e_year2_supplies_expense_amount decimal(15,2) not null,
    ri_schedule_e_year2_taxes_expense_amount decimal(15,2) not null,
    ri_schedule_e_year2_utilities_expense_amount decimal(15,2) not null,
    ri_schedule_e_year2_depreciation_expense_amount decimal(15,2) not null,
    ri_schedule_e_year2_other_expense_amount decimal(15,2) not null,
    ri_schedule_e_year2_total_expense_amount decimal(15,2) not null,
    ri_schedule_e_year2_non_recurring_expense_amount_1 decimal(15,2) not null,
    ri_schedule_e_year2_non_recurring_expense_amount_2 decimal(15,2) not null,
    ri_schedule_e_year2_non_recurring_expense_amount_3 decimal(15,2) not null,
    ri_schedule_e_year2_insurance_credit_amount decimal(15,2) not null,
    ri_schedule_e_year2_taxes_credit_amount decimal(15,2) not null,
    ri_schedule_e_year2_annual_subtotal decimal(15,2) not null,
    ri_schedule_e_year2_ownership_percent decimal(11,9) not null,
    ri_schedule_e_year3_rent_received_amount decimal(15,2) null,
    ri_schedule_e_year3_advertising_expense_amount decimal(15,2) not null,
    ri_schedule_e_year3_auto_travel_expense_amount decimal(15,2) not null,
    ri_schedule_e_year3_cleaning_maintenance_expense_amount decimal(15,2) not null,
    ri_schedule_e_year3_commissions_expense_amount decimal(15,2) not null,
    ri_schedule_e_year3_insurance_expense_amount decimal(15,2) not null,
    ri_schedule_e_year3_legal_professional_expense_amount decimal(15,2) not null,
    ri_schedule_e_year3_management_expense_amount decimal(15,2) not null,
    ri_schedule_e_year3_mortgage_interest_expense_amount decimal(15,2) not null,
    ri_schedule_e_year3_other_interest_expense_amount decimal(15,2) not null,
    ri_schedule_e_year3_repairs_expense_amount decimal(15,2) not null,
    ri_schedule_e_year3_supplies_expense_amount decimal(15,2) not null,
    ri_schedule_e_year3_taxes_expense_amount decimal(15,2) not null,
    ri_schedule_e_year3_utilities_expense_amount decimal(15,2) not null,
    ri_schedule_e_year3_depreciation_expense_amount decimal(15,2) not null,
    ri_schedule_e_year3_other_expense_amount decimal(15,2) not null,
    ri_schedule_e_year3_total_expense_amount decimal(15,2) not null,
    ri_schedule_e_year3_non_recurring_expense_amount_1 decimal(15,2) not null,
    ri_schedule_e_year3_non_recurring_expense_amount_2 decimal(15,2) not null,
    ri_schedule_e_year3_non_recurring_expense_amount_3 decimal(15,2) not null,
    ri_schedule_e_year3_insurance_credit_amount decimal(15,2) not null,
    ri_schedule_e_year3_taxes_credit_amount decimal(15,2) not null,
    ri_schedule_e_year3_annual_subtotal decimal(15,2) not null,
    ri_schedule_e_year3_ownership_percent decimal(11,9) not null,
    ri_simple_monthly_rent_amount decimal(15,2) null,
    ri_simple_vacancy_maintenance_adjustment_percent decimal(11,9) not null,
    ri_simple_monthly_net_rent_amount decimal(15,2) not null,
    ri_simple_monthly_expense_amount decimal(15,2) not null,
    ri_simple_monthly_pre_ownership_income_amount decimal(15,2) not null,
    ri_simple_ownership_percent decimal(11,9) not null,
    ri_simple_calculated_monthly_amount decimal(15,2) not null,
    constraint uk_rental_income_1
        unique (ri_borrower_income_pid),
    constraint uk_rental_income_2
        unique (ri_place_pid),
    constraint fk_rental_income_1
        foreign key (ri_borrower_income_pid) references borrower_income (bi_pid),
    constraint fk_rental_income_2
        foreign key (ri_place_pid) references place (pl_pid),
    constraint fkt_ri_rental_income_calc_method
        foreign key (ri_rental_income_calc_method) references income_history_calc_method_type (code)
);

create table sap_quote_request
(
    sqr_pid bigint auto_increment
        primary key,
    sqr_version int not null,
    sqr_deal_pid bigint not null,
    sqr_include_conventional bit null,
    sqr_include_fha bit null,
    sqr_include_va bit null,
    sqr_include_fixed_rate bit null,
    sqr_include_arm bit null,
    sqr_due_in_term_months_string_list text not null,
    constraint sqr_deal_pid
        unique (sqr_deal_pid),
    constraint fk_sap_quote_request_1
        foreign key (sqr_deal_pid) references deal (d_pid)
);

create table secondary_settings
(
    sset_pid bigint auto_increment
        primary key,
    sset_version int not null,
    sset_account_pid bigint not null,
    sset_default_lead_source_pid bigint null,
    sset_default_mortech_account_pid bigint null,
    sset_default_beneficiary_investor_pid bigint null,
    sset_default_servicer_investor_pid bigint null,
    sset_initial_lender_lock_id bigint not null,
    sset_initial_lender_trade_id bigint not null,
    sset_lock_expiration_warning_days int not null,
    sset_expired_lock_update_allowed_days int not null,
    sset_disable_all_locking bit not null,
    sset_pricing_engine_type varchar(128) not null,
    sset_price_match_check_suspend_through_date date null,
    sset_mortech_disable_eligibility bit not null,
    sset_mortech_strict_eligibility bit not null,
    sset_zillow_appraisal_fee decimal(15,2) not null,
    sset_zillow_title_fee decimal(15,2) not null,
    sset_zillow_recording_fee decimal(15,2) not null,
    sset_mortech_floating_adjuster_prefixes varchar(16000) not null,
    sset_rate_lock_acknowledgement_due_days int not null,
    sset_rate_lock_supporting_documentation_due_days int not null,
    sset_rate_lock_appraisal_inspection_due_days int not null,
    sset_min_subordinate_financing_lock_term_days int not null,
    sset_servicer_loan_id_minimum_available_threshold int not null,
    sset_servicer_loan_id_minimum_available_warning_email varchar(256) null,
    sset_third_party_base_margin_prefixes varchar(16000) not null,
    sset_third_party_floating_margin_prefixes varchar(16000) not null,
    sset_month_ami_uses_subsequent_year int not null,
    sset_day_ami_uses_subsequent_year int not null,
    constraint sset_account_pid
        unique (sset_account_pid),
    constraint fk_secondary_settings_1
        foreign key (sset_account_pid) references account (a_pid),
    constraint fk_secondary_settings_2
        foreign key (sset_default_lead_source_pid) references lead_source (lds_pid),
    constraint fk_secondary_settings_3
        foreign key (sset_default_mortech_account_pid) references mortech_account (ma_pid),
    constraint fk_secondary_settings_4
        foreign key (sset_default_beneficiary_investor_pid) references investor (i_pid),
    constraint fk_secondary_settings_5
        foreign key (sset_default_servicer_investor_pid) references investor (i_pid)
);

create table servicer_loan_id_import_request
(
    slir_pid bigint auto_increment
        primary key,
    slir_version int not null,
    slir_account_pid bigint not null,
    slir_create_datetime datetime not null,
    slir_import_lender_user_pid bigint not null,
    slir_imported_loan_id_count int not null,
    slir_error_loan_id_count int not null,
    slir_servicer_loan_id_import_request_status_type varchar(128) not null,
    constraint fk_servicer_loan_id_import_request_1
        foreign key (slir_account_pid) references account (a_pid),
    constraint fk_servicer_loan_id_import_request_2
        foreign key (slir_import_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_slir_servicer_loan_id_import_request_status_type
        foreign key (slir_servicer_loan_id_import_request_status_type) references servicer_loan_id_import_request_status_type (code)
);

create table servicer_loan_id_assignment
(
    slia_pid bigint auto_increment
        primary key,
    slia_version int not null,
    slia_account_pid bigint not null,
    slia_servicer_loan_id_import_request_pid bigint not null,
    slia_loan_servicer_pid bigint null,
    slia_servicer_loan_id varchar(32) not null,
    slia_servicer_loan_id_assign_type varchar(128) not null,
    slia_assigned_datetime datetime null,
    constraint uk_servicer_loan_id_assignment_1
        unique (slia_account_pid, slia_servicer_loan_id),
    constraint uk_servicer_loan_id_assignment_2
        unique (slia_loan_servicer_pid),
    constraint fk_servicer_loan_id_assignment_1
        foreign key (slia_account_pid) references account (a_pid),
    constraint fk_servicer_loan_id_assignment_2
        foreign key (slia_servicer_loan_id_import_request_pid) references servicer_loan_id_import_request (slir_pid),
    constraint fk_servicer_loan_id_assignment_3
        foreign key (slia_loan_servicer_pid) references loan_servicer (lsv_pid),
    constraint fkt_slia_servicer_loan_id_assign_type
        foreign key (slia_servicer_loan_id_assign_type) references servicer_loan_id_assign_type (code)
);

create table smart_doc
(
    sd_pid bigint auto_increment
        primary key,
    sd_version int not null,
    sd_account_pid bigint not null,
    sd_doc_set_type varchar(128) not null,
    sd_custom_form_pid bigint null,
    sd_doc_name varchar(767) not null,
    sd_doc_number decimal(15,3) not null,
    sd_doc_category_type varchar(128) not null,
    sd_doc_file_source_type varchar(128) not null,
    sd_doc_external_provider_type varchar(128) not null,
    sd_broker_applicable_provider bit not null,
    sd_action_entities_from_merge_field bit null,
    sd_action_entity_applicant bit not null,
    sd_action_entity_non_applicant bit not null,
    sd_action_entity_underwriter bit null,
    sd_action_entity_originator bit null,
    sd_doc_borrower_access_mode_type varchar(128) not null,
    sd_borrower_explanation varchar(1024) null,
    sd_deal_child_type varchar(128) not null,
    sd_doc_fulfill_status_type_default varchar(128) not null,
    sd_prior_to_type varchar(128) not null,
    sd_doc_action_type varchar(128) not null,
    sd_e_delivery bit null,
    sd_active bit null,
    sd_doc_validity_type varchar(128) not null,
    sd_doc_key_date_type varchar(128) not null,
    sd_expiration_rule_type varchar(128) not null,
    sd_days_before_key_date int null,
    sd_warning_days int null,
    sd_key_doc_type varchar(128) not null,
    sd_key_doc_include_file varchar(128) not null,
    sd_doc_approval_type varchar(128) not null,
    sd_auto_approve bit not null,
    sd_auto_include_on_request bit not null,
    sd_poa_applicable bit not null,
    sd_action_entity_hud_va_lender_officer bit not null,
    sd_action_entity_collateral_underwriter bit not null,
    sd_action_entity_wholesale_client_advocate bit not null,
    sd_action_entity_correspondent_client_advocate bit null,
    constraint sd_custom_form_pid
        unique (sd_custom_form_pid),
    constraint uk_smart_doc_1
        unique (sd_account_pid, sd_doc_name),
    constraint fk_smart_doc_1
        foreign key (sd_account_pid) references account (a_pid),
    constraint fk_smart_doc_2
        foreign key (sd_custom_form_pid) references custom_form (cf_pid),
    constraint fkt_sd_deal_child_type
        foreign key (sd_deal_child_type) references deal_child_type (code),
    constraint fkt_sd_doc_action_type
        foreign key (sd_doc_action_type) references doc_action_type (code),
    constraint fkt_sd_doc_approval_type
        foreign key (sd_doc_approval_type) references doc_approval_type (code),
    constraint fkt_sd_doc_borrower_access_mode_type
        foreign key (sd_doc_borrower_access_mode_type) references doc_borrower_access_mode_type (code),
    constraint fkt_sd_doc_category_type
        foreign key (sd_doc_category_type) references doc_category_type (code),
    constraint fkt_sd_doc_external_provider_type
        foreign key (sd_doc_external_provider_type) references doc_external_provider_type (code),
    constraint fkt_sd_doc_file_source_type
        foreign key (sd_doc_file_source_type) references doc_file_source_type (code),
    constraint fkt_sd_doc_fulfill_status_type_default
        foreign key (sd_doc_fulfill_status_type_default) references doc_fulfill_status_type (code),
    constraint fkt_sd_doc_key_date_type
        foreign key (sd_doc_key_date_type) references doc_key_date_type (code),
    constraint fkt_sd_doc_set_type
        foreign key (sd_doc_set_type) references doc_set_type (code),
    constraint fkt_sd_doc_validity_type
        foreign key (sd_doc_validity_type) references doc_validity_type (code),
    constraint fkt_sd_expiration_rule_type
        foreign key (sd_expiration_rule_type) references calendar_rule_type (code),
    constraint fkt_sd_key_doc_include_file
        foreign key (sd_key_doc_include_file) references yes_no_unknown_type (code),
    constraint fkt_sd_key_doc_type
        foreign key (sd_key_doc_type) references key_doc_type (code),
    constraint fkt_sd_prior_to_type
        foreign key (sd_prior_to_type) references prior_to_type (code)
);

create table smart_doc_criteria
(
    sdc_pid bigint auto_increment
        primary key,
    sdc_version int not null,
    sdc_smart_doc_pid bigint not null,
    sdc_criteria_pid bigint null,
    sdc_deal_child_type varchar(128) not null,
    constraint fk_smart_doc_criteria_1
        foreign key (sdc_smart_doc_pid) references smart_doc (sd_pid),
    constraint fk_smart_doc_criteria_2
        foreign key (sdc_criteria_pid) references criteria (cr_pid),
    constraint fkt_sdc_deal_child_type
        foreign key (sdc_deal_child_type) references deal_child_type (code)
);

create table smart_doc_note
(
    sdn_pid bigint auto_increment
        primary key,
    sdn_version int not null,
    sdn_smart_doc_pid bigint not null,
    sdn_create_datetime datetime not null,
    sdn_content varchar(16000) not null,
    sdn_author_lender_user_pid bigint not null,
    sdn_author_unparsed_name varchar(128) not null,
    constraint fk_smart_doc_note_1
        foreign key (sdn_smart_doc_pid) references smart_doc (sd_pid),
    constraint fk_smart_doc_note_2
        foreign key (sdn_author_lender_user_pid) references lender_user (lu_pid)
);

create table smart_doc_note_comment
(
    sdnc_pid bigint auto_increment
        primary key,
    sdnc_version int not null,
    sdnc_smart_doc_note_pid bigint not null,
    sdnc_create_datetime datetime not null,
    sdnc_content varchar(16000) not null,
    sdnc_author_lender_user_pid bigint not null,
    sdnc_author_unparsed_name varchar(128) not null,
    constraint fk_smart_doc_note_comment_1
        foreign key (sdnc_smart_doc_note_pid) references smart_doc_note (sdn_pid),
    constraint fk_smart_doc_note_comment_2
        foreign key (sdnc_author_lender_user_pid) references lender_user (lu_pid)
);

create table smart_doc_note_monitor
(
    sdnm_pid bigint auto_increment
        primary key,
    sdnm_version int not null,
    sdnm_smart_doc_note_pid bigint not null,
    sdnm_lender_user_pid bigint not null,
    constraint fk_smart_doc_note_monitor_1
        foreign key (sdnm_smart_doc_note_pid) references smart_doc_note (sdn_pid),
    constraint fk_smart_doc_note_monitor_2
        foreign key (sdnm_lender_user_pid) references lender_user (lu_pid)
);

create table smart_doc_role
(
    sdr_pid bigint auto_increment
        primary key,
    sdr_version int not null,
    sdr_smart_doc_pid bigint not null,
    sdr_role_pid bigint not null,
    sdr_doc_permission_type varchar(128) not null,
    constraint uk_smart_doc_role_1
        unique (sdr_smart_doc_pid, sdr_role_pid, sdr_doc_permission_type),
    constraint fk_smart_doc_role_1
        foreign key (sdr_smart_doc_pid) references smart_doc (sd_pid),
    constraint fk_smart_doc_role_2
        foreign key (sdr_role_pid) references role (r_pid),
    constraint fkt_sdr_doc_permission_type
        foreign key (sdr_doc_permission_type) references doc_permission_type (code)
);

create table smart_message
(
    smsg_pid bigint auto_increment
        primary key,
    smsg_version int not null,
    smsg_account_pid bigint not null,
    smsg_name varchar(256) not null,
    smsg_delivery_type varchar(128) not null,
    smsg_reply_to_role_pid bigint null,
    smsg_email_subject varchar(1024) null,
    smsg_message_source_type varchar(128) not null,
    smsg_smart_doc_pid bigint null,
    smsg_smart_stack_pid bigint null,
    smsg_allow_ad_hoc bit null,
    smsg_send_securely bit null,
    smsg_id_num int not null,
    smsg_message_body varchar(16000) not null,
    smsg_email_closing_type varchar(128) not null,
    constraint uk_smart_message_1
        unique (smsg_account_pid, smsg_name),
    constraint fk_smart_message_1
        foreign key (smsg_account_pid) references account (a_pid),
    constraint fk_smart_message_2
        foreign key (smsg_reply_to_role_pid) references role (r_pid),
    constraint fk_smart_message_3
        foreign key (smsg_smart_doc_pid) references smart_doc (sd_pid),
    constraint fk_smart_message_4
        foreign key (smsg_smart_stack_pid) references smart_stack (ss_pid),
    constraint fkt_smsg_delivery_type
        foreign key (smsg_delivery_type) references smart_message_delivery_type (code),
    constraint fkt_smsg_email_closing_type
        foreign key (smsg_email_closing_type) references email_closing_type (code),
    constraint fkt_smsg_message_source_type
        foreign key (smsg_message_source_type) references smart_message_source_type (code)
);

create table smart_message_recipient
(
    smr_pid bigint auto_increment
        primary key,
    smr_version int not null,
    smr_smart_message_pid bigint not null,
    smr_recipient_type varchar(128) not null,
    smr_role_pid bigint null,
    smr_email_recipient_type varchar(128) not null,
    constraint smr_smart_message
        unique (smr_smart_message_pid, smr_recipient_type, smr_role_pid, smr_email_recipient_type),
    constraint fk_smart_message_recipient_1
        foreign key (smr_smart_message_pid) references smart_message (smsg_pid),
    constraint fk_smart_message_recipient_2
        foreign key (smr_role_pid) references role (r_pid),
    constraint fkt_smr_email_recipient_type
        foreign key (smr_email_recipient_type) references smart_message_email_recipient_type (code),
    constraint fkt_smr_recipient_type
        foreign key (smr_recipient_type) references smart_message_recipient_type (code)
);

create table smart_req
(
    sr_pid bigint auto_increment
        primary key,
    sr_version int not null,
    sr_smart_doc_pid bigint not null,
    sr_criteria_pid bigint null,
    sr_deal_child_type varchar(128) not null,
    sr_deal_child_relationship_type varchar(128) not null,
    sr_req_name varchar(767) not null,
    sr_borrower_access bit null,
    sr_active bit null,
    constraint uk_smart_req_1
        unique (sr_smart_doc_pid, sr_req_name),
    constraint fk_smart_req_1
        foreign key (sr_smart_doc_pid) references smart_doc (sd_pid),
    constraint fk_smart_req_2
        foreign key (sr_criteria_pid) references criteria (cr_pid),
    constraint fkt_sr_deal_child_relationship_type
        foreign key (sr_deal_child_relationship_type) references deal_child_relationship_type (code),
    constraint fkt_sr_deal_child_type
        foreign key (sr_deal_child_type) references deal_child_type (code)
);

create table smart_separator
(
    ssp_pid bigint auto_increment
        primary key,
    ssp_version int not null,
    ssp_account_pid bigint not null,
    ssp_custom_form_pid bigint not null,
    ssp_criteria_pid bigint null,
    ssp_separator_name varchar(767) null,
    constraint ssp_custom_form_pid
        unique (ssp_custom_form_pid),
    constraint uk_smart_separator_1
        unique (ssp_account_pid, ssp_separator_name),
    constraint fk_smart_separator_1
        foreign key (ssp_account_pid) references account (a_pid),
    constraint fk_smart_separator_2
        foreign key (ssp_custom_form_pid) references custom_form (cf_pid),
    constraint fk_smart_separator_3
        foreign key (ssp_criteria_pid) references criteria (cr_pid)
);

create table smart_set_doc
(
    sstd_pid bigint auto_increment
        primary key,
    sstd_version int not null,
    sstd_smart_doc_set_pid bigint not null,
    sstd_smart_doc_pid bigint not null,
    sstd_sequence int null,
    constraint uk_smart_set_doc_1
        unique (sstd_smart_doc_set_pid, sstd_smart_doc_pid),
    constraint fk_smart_set_doc_1
        foreign key (sstd_smart_doc_set_pid) references smart_doc_set (sdst_pid),
    constraint fk_smart_set_doc_2
        foreign key (sstd_smart_doc_pid) references smart_doc (sd_pid)
);

create table smart_stack_doc
(
    ssd_pid bigint auto_increment
        primary key,
    ssd_version int not null,
    ssd_smart_stack_pid bigint not null,
    ssd_stack_doc_type varchar(128) not null,
    ssd_smart_doc_set_pid bigint null,
    ssd_smart_separator_pid bigint null,
    ssd_smart_doc_pid bigint null,
    ssd_sequence bigint not null,
    ssd_smart_stack_doc_set_include_type varchar(128) not null,
    constraint uk_smart_stack_doc_1
        unique (ssd_smart_stack_pid, ssd_smart_doc_pid, ssd_sequence),
    constraint fk_smart_stack_doc_1
        foreign key (ssd_smart_stack_pid) references smart_stack (ss_pid),
    constraint fk_smart_stack_doc_2
        foreign key (ssd_smart_doc_pid) references smart_doc (sd_pid),
    constraint fk_smart_stack_doc_3
        foreign key (ssd_smart_doc_set_pid) references smart_doc_set (sdst_pid),
    constraint fk_smart_stack_doc_4
        foreign key (ssd_smart_separator_pid) references smart_separator (ssp_pid),
    constraint fkt_ssd_smart_stack_doc_set_include_type
        foreign key (ssd_smart_stack_doc_set_include_type) references smart_stack_doc_set_include_type (code),
    constraint fkt_ssd_stack_doc_type
        foreign key (ssd_stack_doc_type) references stack_doc_type (code)
);

create table stack_export_request
(
    ser_pid bigint auto_increment
        primary key,
    ser_version int not null,
    ser_account_pid bigint not null,
    ser_create_datetime datetime not null,
    ser_start_datetime datetime null,
    ser_end_datetime datetime null,
    ser_request_status_type varchar(128) not null,
    ser_loan_export_type varchar(128) not null,
    ser_loan_name_format_type varchar(128) not null,
    ser_file_name_format_type varchar(128) not null,
    ser_requester_lender_user_pid bigint not null,
    ser_requester_unparsed_name varchar(128) not null,
    ser_smart_stack_pid bigint not null,
    ser_total_deal_count int not null,
    ser_exported_deal_count int not null,
    ser_description varchar(32) not null,
    constraint fk_stack_export_request_1
        foreign key (ser_account_pid) references account (a_pid),
    constraint fk_stack_export_request_2
        foreign key (ser_requester_lender_user_pid) references lender_user (lu_pid),
    constraint fk_stack_export_request_3
        foreign key (ser_smart_stack_pid) references smart_stack (ss_pid),
    constraint fkt_ser_file_name_format_type
        foreign key (ser_file_name_format_type) references stack_export_file_name_format_type (code),
    constraint fkt_ser_loan_export_type
        foreign key (ser_loan_export_type) references stack_export_request_loan_export_type (code),
    constraint fkt_ser_loan_name_format_type
        foreign key (ser_loan_name_format_type) references stack_export_loan_name_format_type (code),
    constraint fkt_ser_request_status_type
        foreign key (ser_request_status_type) references stack_export_request_status_type (code)
);

create table stack_export_file
(
    sef_pid bigint auto_increment
        primary key,
    sef_version int not null,
    sef_stack_export_request_pid bigint not null,
    sef_repository_file_pid bigint not null,
    sef_stack_export_file_type varchar(128) not null,
    constraint uk_stack_export_file_1
        unique (sef_stack_export_request_pid, sef_stack_export_file_type),
    constraint fk_stack_export_file_1
        foreign key (sef_stack_export_request_pid) references stack_export_request (ser_pid),
    constraint fk_stack_export_file_2
        foreign key (sef_repository_file_pid) references repository_file (rf_pid),
    constraint fkt_sef_stack_export_file_type
        foreign key (sef_stack_export_file_type) references stack_export_file_type (code)
);

create table tax_transcript_request
(
    ttr_pid bigint auto_increment
        primary key,
    ttr_version int not null,
    ttr_deal_pid bigint not null,
    ttr_create_datetime datetime not null,
    ttr_requester_agent_type varchar(128) not null,
    ttr_requester_lender_user_pid bigint null,
    ttr_requester_unparsed_name varchar(128) null,
    ttr_mismo_version_type varchar(128) not null,
    ttr_credit_request_type varchar(128) not null,
    ttr_request_error_messages text not null,
    ttr_request_success_messages text not null,
    ttr_tracking_number varchar(16) null,
    ttr_tax_transcript_request_status_type varchar(128) not null,
    ttr_update_reason varchar(1024) null,
    ttr_last_status_query_datetime datetime null,
    ttr_signed_4506t_deal_file_pid bigint null,
    ttr_company bit null,
    ttr_company_name varchar(128) not null,
    ttr_company_city varchar(128) null,
    ttr_company_country varchar(128) not null,
    ttr_company_postal_code varchar(128) null,
    ttr_company_state varchar(128) null,
    ttr_company_street1 varchar(128) null,
    ttr_company_street2 varchar(128) null,
    ttr_company_ein varchar(16) null,
    ttr_borrower1_pid bigint null,
    ttr_borrower1_ssn varchar(128) null,
    ttr_borrower1_first_name varchar(32) null,
    ttr_borrower1_middle_name varchar(32) null,
    ttr_borrower1_last_name varchar(32) null,
    ttr_borrower1_name_suffix varchar(32) null,
    ttr_borrower1_birth_date date null,
    ttr_borrower1_current_city varchar(128) null,
    ttr_borrower1_current_country varchar(128) not null,
    ttr_borrower1_current_postal_code varchar(128) null,
    ttr_borrower1_current_state varchar(128) null,
    ttr_borrower1_current_street1 varchar(128) null,
    ttr_borrower1_current_street2 varchar(128) null,
    ttr_borrower1_prior_city varchar(128) null,
    ttr_borrower1_prior_country varchar(128) not null,
    ttr_borrower1_prior_postal_code varchar(128) null,
    ttr_borrower1_prior_state varchar(128) null,
    ttr_borrower1_prior_street1 varchar(128) null,
    ttr_borrower1_prior_street2 varchar(128) null,
    ttr_borrower1_monthly_income_amount decimal(15,2) not null,
    ttr_borrower2_pid bigint null,
    ttr_borrower2_ssn varchar(128) null,
    ttr_borrower2_first_name varchar(32) null,
    ttr_borrower2_middle_name varchar(32) null,
    ttr_borrower2_last_name varchar(32) null,
    ttr_borrower2_name_suffix varchar(32) null,
    ttr_borrower2_birth_date date null,
    ttr_borrower2_current_city varchar(128) null,
    ttr_borrower2_current_country varchar(128) not null,
    ttr_borrower2_current_postal_code varchar(128) null,
    ttr_borrower2_current_state varchar(128) null,
    ttr_borrower2_current_street1 varchar(128) null,
    ttr_borrower2_current_street2 varchar(128) null,
    ttr_borrower2_prior_city varchar(128) null,
    ttr_borrower2_prior_country varchar(128) not null,
    ttr_borrower2_prior_postal_code varchar(128) null,
    ttr_borrower2_prior_state varchar(128) null,
    ttr_borrower2_prior_street1 varchar(128) null,
    ttr_borrower2_prior_street2 varchar(128) null,
    ttr_borrower2_monthly_income_amount decimal(15,2) not null,
    ttr_year1 int null,
    ttr_year2 int null,
    ttr_year3 int null,
    ttr_year4 int null,
    ttr_include_w_2 bit null,
    ttr_include_1099 bit null,
    ttr_include_1040 bit null,
    ttr_include_1040_return_transcript bit null,
    ttr_include_1040_account_transcript bit null,
    ttr_include_1040_record_of_account bit null,
    ttr_include_1065 bit null,
    ttr_include_1065_return_transcript bit null,
    ttr_include_1065_account_transcript bit null,
    ttr_include_1065_record_of_account bit null,
    ttr_include_1120 bit null,
    ttr_include_1120_return_transcript bit null,
    ttr_include_1120_account_transcript bit null,
    ttr_include_1120_record_of_account bit null,
    ttr_archived bit null,
    ttr_company_phone varchar(32) not null,
    ttr_company_phone_extension varchar(16) not null,
    ttr_business_ownership_type varchar(128) not null,
    constraint fk_tax_transcript_request_1
        foreign key (ttr_deal_pid) references deal (d_pid),
    constraint fk_tax_transcript_request_2
        foreign key (ttr_requester_lender_user_pid) references lender_user (lu_pid),
    constraint fk_tax_transcript_request_3
        foreign key (ttr_signed_4506t_deal_file_pid) references deal_file (df_pid),
    constraint fk_tax_transcript_request_4
        foreign key (ttr_borrower1_pid) references borrower (b_pid),
    constraint fk_tax_transcript_request_5
        foreign key (ttr_borrower2_pid) references borrower (b_pid),
    constraint fkt_ttr_borrower1_current_country
        foreign key (ttr_borrower1_current_country) references country_type (code),
    constraint fkt_ttr_borrower1_prior_country
        foreign key (ttr_borrower1_prior_country) references country_type (code),
    constraint fkt_ttr_borrower2_current_country
        foreign key (ttr_borrower2_current_country) references country_type (code),
    constraint fkt_ttr_borrower2_prior_country
        foreign key (ttr_borrower2_prior_country) references country_type (code),
    constraint fkt_ttr_business_ownership_type
        foreign key (ttr_business_ownership_type) references business_ownership_type (code),
    constraint fkt_ttr_company_country
        foreign key (ttr_company_country) references country_type (code),
    constraint fkt_ttr_credit_request_type
        foreign key (ttr_credit_request_type) references credit_request_type (code),
    constraint fkt_ttr_mismo_version_type
        foreign key (ttr_mismo_version_type) references mismo_version_type (code),
    constraint fkt_ttr_requester_agent_type
        foreign key (ttr_requester_agent_type) references agent_type (code),
    constraint fkt_ttr_tax_transcript_request_status_type
        foreign key (ttr_tax_transcript_request_status_type) references tax_transcript_request_status_type (code)
);

create table third_party_community_second_program
(
    tpcsp_pid bigint auto_increment
        primary key,
    tpcsp_version int not null,
    tpcsp_account_pid bigint not null,
    tpcsp_program_id varchar(32) not null,
    tpcsp_program_name varchar(128) not null,
    tpcsp_fre_community_program_type varchar(128) not null,
    tpcsp_fnm_community_lending_product_type varchar(128) not null,
    tpcsp_fnm_community_seconds_repayment_structure_type varchar(128) not null,
    tpcsp_ein varchar(10) not null,
    tpcsp_wire_action_type varchar(128) not null,
    tpcsp_security_instrument_page_count int not null,
    tpcsp_deed_page_count int not null,
    tpcsp_notes varchar(1024) not null,
    tpcsp_from_date date not null,
    tpcsp_through_date date null,
    tpcsp_investor_pid bigint null,
    constraint uk_third_party_community_second_program_1
        unique (tpcsp_account_pid, tpcsp_program_id),
    constraint fk_third_party_community_second_program_1
        foreign key (tpcsp_account_pid) references account (a_pid),
    constraint fk_third_party_community_second_program_2
        foreign key (tpcsp_investor_pid) references investor (i_pid),
    constraint fkt_tpcsp_fnm_community_lending_product_type
        foreign key (tpcsp_fnm_community_lending_product_type) references fnm_community_lending_product_type (code),
    constraint fkt_tpcsp_fnm_community_seconds_repayment_structure_type
        foreign key (tpcsp_fnm_community_seconds_repayment_structure_type) references fnm_community_seconds_repayment_structure_type (code),
    constraint fkt_tpcsp_fre_community_program_type
        foreign key (tpcsp_fre_community_program_type) references fre_community_program_type (code),
    constraint fkt_tpcsp_wire_action_type
        foreign key (tpcsp_wire_action_type) references charge_wire_action_type (code)
);

create table liability
(
    lia_pid bigint auto_increment
        primary key,
    lia_version int not null,
    lia_proposal_pid bigint not null,
    lia_creditor_pid bigint null,
    lia_account_id varchar(32) null,
    lia_aggregate_description varchar(128) null,
    lia_credit_request_pid bigint null,
    lia_description varchar(128) null,
    lia_city varchar(128) null,
    lia_country varchar(128) not null,
    lia_postal_code varchar(128) null,
    lia_state varchar(128) null,
    lia_street1 varchar(128) null,
    lia_street2 varchar(128) null,
    lia_holder_name varchar(128) null,
    lia_report_holder_name varchar(128) null,
    lia_holder_phone varchar(32) null,
    lia_holder_phone_extension varchar(16) null,
    lia_holder_fax varchar(32) null,
    lia_holder_email varchar(256) null,
    lia_account_opened_date date null,
    lia_report_account_opened_date date null,
    lia_account_reported_date date null,
    lia_last_activity_date date null,
    lia_most_recent_adverse_rating_date date null,
    lia_liability_disposition_type varchar(128) not null,
    lia_liability_type varchar(128) not null,
    lia_report_liability_type varchar(128) not null,
    lia_lien_priority_type varchar(128) not null,
    lia_monthly_payment_amount decimal(15,2) not null,
    lia_report_monthly_payment_amount decimal(15,2) not null,
    lia_remaining_term_months int null,
    lia_report_remaining_term_months int null,
    lia_months_reviewed_count int null,
    lia_high_balance_amount decimal(15,2) not null,
    lia_credit_limit_amount decimal(15) not null,
    lia_report_credit_limit_amount decimal(15) not null,
    lia_past_due_amount decimal(15,2) not null,
    lia_report_past_due_amount decimal(15,2) not null,
    lia_unpaid_balance_amount decimal(15,2) not null,
    lia_report_unpaid_balance_amount decimal(15,2) not null,
    lia_report_value_overridden bit null,
    lia_place_pid bigint null,
    lia_liability_foreclosure_exception_type varchar(128) not null,
    lia_bankruptcy_exception_type varchar(128) not null,
    lia_liability_current_rating_type varchar(128) not null,
    lia_liability_account_status_type varchar(128) not null,
    lia_report_account_ownership_type varchar(128) not null,
    lia_consumer_dispute varchar(128) not null,
    lia_derogatory_data varchar(128) not null,
    lia_late30_days_count varchar(16) null,
    lia_late60_days_count varchar(16) null,
    lia_late90_days_count varchar(16) null,
    lia_note varchar(1024) null,
    lia_equifax_included bit null,
    lia_experian_included bit null,
    lia_trans_union_included bit null,
    lia_liability_financing_type varchar(128) not null,
    lia_original_loan_amount decimal(15) not null,
    lia_interest_rate_on_statement bit null,
    lia_interest_rate_percent decimal(11,9) not null,
    lia_loan_amortization_type varchar(128) not null,
    lia_interest_only varchar(128) not null,
    lia_property_taxes_escrowed bit null,
    lia_property_insurance_escrowed bit null,
    lia_senior_lien_restriction_type varchar(128) not null,
    lia_senior_lien_restriction_amount decimal(15) not null,
    lia_agency_case_id varchar(32) null,
    lia_terms_months_count int null,
    lia_report_terms_months_count int not null,
    lia_payoff_statement_date date null,
    lia_payoff_statement_good_through_date date null,
    lia_next_payment_due_date date null,
    lia_payoff_statement_interest decimal(15,2) null,
    lia_daily_interest_amount decimal(15,2) null,
    lia_monthly_interest_amount decimal(15,2) null,
    lia_payoff_interest_pad_days int null,
    lia_effective_payoff_date date null,
    lia_effective_payoff_date_adjustment_amount decimal(15,2) not null,
    lia_effective_payoff_date_adjustment_days int null,
    lia_other_payoff_related_charges_amount decimal(15,2) null,
    lia_payoff_amount decimal(15,2) not null,
    lia_payoff_amount_estimated bit null,
    lia_used_to_acquire_property varchar(128) not null,
    lia_heloc_advance_last_12_months_over_thousand varchar(128) not null,
    lia_liability_mi_type varchar(128) not null,
    lia_texas_equity varchar(128) not null,
    lia_texas_equity_locked bit not null,
    lia_texas_equity_conversion varchar(128) not null,
    lia_credit_report_identifier varchar(32) not null,
    lia_net_escrow varchar(128) not null,
    lia_third_party_community_second_program_pid bigint null,
    lia_current_escrow_balance_amount decimal(15,2) not null,
    lia_report_account_id varchar(32) not null,
    lia_first_payment_date date null,
    lia_closing_date date null,
    lia_mip_due_amount decimal(15,2) null,
    lia_unpaid_late_charges_amount decimal(15,2) not null,
    lia_include_within_cema varchar(128) not null,
    lia_energy_related_type varchar(128) not null,
    constraint fk_liability_1
        foreign key (lia_proposal_pid) references proposal (prp_pid),
    constraint fk_liability_2
        foreign key (lia_place_pid) references place (pl_pid),
    constraint fk_liability_3
        foreign key (lia_credit_request_pid) references credit_request (crdr_pid),
    constraint fk_liability_4
        foreign key (lia_creditor_pid) references creditor (crd_pid),
    constraint fk_liability_5
        foreign key (lia_third_party_community_second_program_pid) references third_party_community_second_program (tpcsp_pid),
    constraint fkt_lia_bankruptcy_exception_type
        foreign key (lia_bankruptcy_exception_type) references bankruptcy_exception_type (code),
    constraint fkt_lia_consumer_dispute
        foreign key (lia_consumer_dispute) references yes_no_unknown_type (code),
    constraint fkt_lia_country
        foreign key (lia_country) references country_type (code),
    constraint fkt_lia_derogatory_data
        foreign key (lia_derogatory_data) references yes_no_unknown_type (code),
    constraint fkt_lia_energy_related_type
        foreign key (lia_energy_related_type) references liability_energy_related_type (code),
    constraint fkt_lia_heloc_advance_last_12_months_over_thousand
        foreign key (lia_heloc_advance_last_12_months_over_thousand) references yes_no_unknown_type (code),
    constraint fkt_lia_include_within_cema
        foreign key (lia_include_within_cema) references yes_no_unknown_type (code),
    constraint fkt_lia_interest_only
        foreign key (lia_interest_only) references yes_no_unknown_type (code),
    constraint fkt_lia_liability_account_status_type
        foreign key (lia_liability_account_status_type) references liability_account_status_type (code),
    constraint fkt_lia_liability_current_rating_type
        foreign key (lia_liability_current_rating_type) references liability_current_rating_type (code),
    constraint fkt_lia_liability_disposition_type
        foreign key (lia_liability_disposition_type) references liability_disposition_type (code),
    constraint fkt_lia_liability_financing_type
        foreign key (lia_liability_financing_type) references liability_financing_type (code),
    constraint fkt_lia_liability_foreclosure_exception_type
        foreign key (lia_liability_foreclosure_exception_type) references liability_foreclosure_exception_type (code),
    constraint fkt_lia_liability_mi_type
        foreign key (lia_liability_mi_type) references liability_mi_type (code),
    constraint fkt_lia_liability_type
        foreign key (lia_liability_type) references liability_type (code),
    constraint fkt_lia_lien_priority_type
        foreign key (lia_lien_priority_type) references lien_priority_type (code),
    constraint fkt_lia_loan_amortization_type
        foreign key (lia_loan_amortization_type) references loan_amortization_type (code),
    constraint fkt_lia_net_escrow
        foreign key (lia_net_escrow) references yes_no_unknown_type (code),
    constraint fkt_lia_report_account_ownership_type
        foreign key (lia_report_account_ownership_type) references liability_account_ownership_type (code),
    constraint fkt_lia_report_liability_type
        foreign key (lia_report_liability_type) references liability_type (code),
    constraint fkt_lia_senior_lien_restriction_type
        foreign key (lia_senior_lien_restriction_type) references senior_lien_restriction_type (code),
    constraint fkt_lia_texas_equity
        foreign key (lia_texas_equity) references yes_no_unknown_type (code),
    constraint fkt_lia_texas_equity_conversion
        foreign key (lia_texas_equity_conversion) references yes_no_unknown_type (code),
    constraint fkt_lia_used_to_acquire_property
        foreign key (lia_used_to_acquire_property) references yes_no_unknown_type (code)
);

create table borrower_liability
(
    bl_pid bigint auto_increment
        primary key,
    bl_version int not null,
    bl_borrower_pid bigint not null,
    bl_liability_pid bigint not null,
    constraint bl_borrower_pid
        unique (bl_borrower_pid, bl_liability_pid),
    constraint fk_borrower_liability_1
        foreign key (bl_borrower_pid) references borrower (b_pid),
    constraint fk_borrower_liability_2
        foreign key (bl_liability_pid) references liability (lia_pid)
);

create table deal_tag
(
    dtg_pid bigint auto_increment
        primary key,
    dtg_version int not null,
    dtg_deal_tag_definition_pid bigint not null,
    dtg_deal_pid bigint not null,
    dtg_asset_pid bigint null,
    dtg_liability_pid bigint null,
    dtg_application_pid bigint null,
    dtg_borrower_pid bigint null,
    dtg_borrower_income_pid bigint null,
    dtg_job_income_pid bigint null,
    dtg_other_income_pid bigint null,
    dtg_business_income_pid bigint null,
    dtg_rental_income_pid bigint null,
    dtg_place_pid bigint null,
    dtg_borrower_residence_pid bigint null,
    dtg_credit_inquiry_pid bigint null,
    dtg_appraisal_pid bigint null,
    constraint fk_deal_tag_1
        foreign key (dtg_deal_tag_definition_pid) references deal_tag_definition (dtd_pid),
    constraint fk_deal_tag_10
        foreign key (dtg_business_income_pid) references business_income (bui_pid),
    constraint fk_deal_tag_11
        foreign key (dtg_rental_income_pid) references rental_income (ri_pid),
    constraint fk_deal_tag_12
        foreign key (dtg_place_pid) references place (pl_pid),
    constraint fk_deal_tag_13
        foreign key (dtg_borrower_residence_pid) references borrower_residence (bres_pid),
    constraint fk_deal_tag_14
        foreign key (dtg_credit_inquiry_pid) references credit_inquiry (ci_pid),
    constraint fk_deal_tag_15
        foreign key (dtg_appraisal_pid) references appraisal (apr_pid),
    constraint fk_deal_tag_2
        foreign key (dtg_deal_pid) references deal (d_pid),
    constraint fk_deal_tag_3
        foreign key (dtg_asset_pid) references asset (as_pid),
    constraint fk_deal_tag_4
        foreign key (dtg_liability_pid) references liability (lia_pid),
    constraint fk_deal_tag_5
        foreign key (dtg_application_pid) references application (apl_pid),
    constraint fk_deal_tag_6
        foreign key (dtg_borrower_pid) references borrower (b_pid),
    constraint fk_deal_tag_7
        foreign key (dtg_borrower_income_pid) references borrower_income (bi_pid),
    constraint fk_deal_tag_8
        foreign key (dtg_job_income_pid) references job_income (ji_pid),
    constraint fk_deal_tag_9
        foreign key (dtg_other_income_pid) references other_income (oi_pid)
);

create table product_third_party_community_second_program
(
    ptpp_pid bigint auto_increment
        primary key,
    ptpp_version int not null,
    ptpp_product_terms_pid bigint not null,
    ptpp_third_party_community_second_program_pid bigint not null,
    constraint uk_product_third_party_community_second_program_1
        unique (ptpp_product_terms_pid, ptpp_third_party_community_second_program_pid),
    constraint fk_product_third_party_community_second_program_1
        foreign key (ptpp_product_terms_pid) references product_terms (pt_pid),
    constraint fk_product_third_party_community_second_program_2
        foreign key (ptpp_third_party_community_second_program_pid) references third_party_community_second_program (tpcsp_pid)
);

create table proposal_doc
(
    prpd_pid bigint auto_increment
        primary key,
    prpd_version int not null,
    prpd_doc_name varchar(767) not null,
    prpd_doc_number decimal(15,3) not null,
    prpd_borrower_access bit null,
    prpd_deal_child_type varchar(128) not null,
    prpd_deal_child_name varchar(767) not null,
    prpd_deal_pid bigint not null,
    prpd_proposal_pid bigint not null,
    prpd_loan_pid bigint null,
    prpd_borrower_pid bigint null,
    prpd_borrower_income_pid bigint null,
    prpd_job_income_pid bigint null,
    prpd_borrower_job_gap_pid bigint null,
    prpd_other_income_pid bigint null,
    prpd_business_income_pid bigint null,
    prpd_rental_income_pid bigint null,
    prpd_asset_pid bigint null,
    prpd_asset_large_deposit_pid bigint null,
    prpd_liability_pid bigint null,
    prpd_reo_place_pid bigint null,
    prpd_property_place_pid bigint null,
    prpd_residence_place_pid bigint null,
    prpd_borrower_residence_pid bigint null,
    prpd_application_pid bigint null,
    prpd_credit_inquiry_pid bigint null,
    prpd_appraisal_pid bigint null,
    prpd_appraisal_form_pid bigint null,
    prpd_tax_transcript_request_pid bigint null,
    prpd_valid_from_date date null,
    prpd_valid_through_date date null,
    prpd_key_date date null,
    prpd_trash bit null,
    prpd_smart_doc_pid bigint not null,
    prpd_proposal_doc_set_pid bigint not null,
    prpd_doc_fulfill_status_type varchar(128) not null,
    prpd_status_unparsed_name varchar(128) null,
    prpd_status_datetime datetime null,
    prpd_status_reason varchar(1024) null,
    prpd_doc_excluded bit null,
    prpd_doc_excluded_reason varchar(1024) null,
    prpd_doc_excluded_unparsed_name varchar(128) null,
    prpd_doc_excluded_datetime datetime null,
    prpd_doc_approval_type varchar(128) not null,
    prpd_borrower_edit bit null,
    prpd_last_status_reason text null,
    prpd_borrower_associated_address_pid bigint null,
    prpd_construction_cost_pid bigint null,
    prpd_construction_draw_pid bigint null,
    prpd_proposal_contractor_pid bigint null,
    constraint fk_proposal_doc_1
        foreign key (prpd_deal_pid) references deal (d_pid),
    constraint fk_proposal_doc_10
        foreign key (prpd_rental_income_pid) references rental_income (ri_pid),
    constraint fk_proposal_doc_11
        foreign key (prpd_asset_pid) references asset (as_pid),
    constraint fk_proposal_doc_12
        foreign key (prpd_asset_large_deposit_pid) references asset_large_deposit (ald_pid),
    constraint fk_proposal_doc_13
        foreign key (prpd_liability_pid) references liability (lia_pid),
    constraint fk_proposal_doc_14
        foreign key (prpd_reo_place_pid) references place (pl_pid),
    constraint fk_proposal_doc_15
        foreign key (prpd_property_place_pid) references place (pl_pid),
    constraint fk_proposal_doc_16
        foreign key (prpd_residence_place_pid) references place (pl_pid),
    constraint fk_proposal_doc_17
        foreign key (prpd_borrower_residence_pid) references borrower_residence (bres_pid),
    constraint fk_proposal_doc_18
        foreign key (prpd_application_pid) references application (apl_pid),
    constraint fk_proposal_doc_19
        foreign key (prpd_credit_inquiry_pid) references credit_inquiry (ci_pid),
    constraint fk_proposal_doc_2
        foreign key (prpd_proposal_pid) references proposal (prp_pid),
    constraint fk_proposal_doc_20
        foreign key (prpd_appraisal_pid) references appraisal (apr_pid),
    constraint fk_proposal_doc_21
        foreign key (prpd_proposal_doc_set_pid) references proposal_doc_set (prpds_pid),
    constraint fk_proposal_doc_22
        foreign key (prpd_smart_doc_pid) references smart_doc (sd_pid),
    constraint fk_proposal_doc_23
        foreign key (prpd_appraisal_form_pid) references appraisal_form (aprfm_pid),
    constraint fk_proposal_doc_24
        foreign key (prpd_tax_transcript_request_pid) references tax_transcript_request (ttr_pid),
    constraint fk_proposal_doc_25
        foreign key (prpd_borrower_associated_address_pid) references borrower_associated_address (baa_pid),
    constraint fk_proposal_doc_26
        foreign key (prpd_construction_cost_pid) references construction_cost (coc_pid),
    constraint fk_proposal_doc_27
        foreign key (prpd_construction_draw_pid) references construction_draw (cd_pid),
    constraint fk_proposal_doc_28
        foreign key (prpd_proposal_contractor_pid) references proposal_contractor (pctr_pid),
    constraint fk_proposal_doc_3
        foreign key (prpd_loan_pid) references loan (l_pid),
    constraint fk_proposal_doc_4
        foreign key (prpd_borrower_pid) references borrower (b_pid),
    constraint fk_proposal_doc_5
        foreign key (prpd_borrower_income_pid) references borrower_income (bi_pid),
    constraint fk_proposal_doc_6
        foreign key (prpd_job_income_pid) references job_income (ji_pid),
    constraint fk_proposal_doc_7
        foreign key (prpd_borrower_job_gap_pid) references borrower_job_gap (bjg_pid),
    constraint fk_proposal_doc_8
        foreign key (prpd_other_income_pid) references other_income (oi_pid),
    constraint fk_proposal_doc_9
        foreign key (prpd_business_income_pid) references business_income (bui_pid),
    constraint fkt_prpd_deal_child_type
        foreign key (prpd_deal_child_type) references deal_child_type (code),
    constraint fkt_prpd_doc_approval_type
        foreign key (prpd_doc_approval_type) references doc_approval_type (code),
    constraint fkt_prpd_doc_fulfill_status_type
        foreign key (prpd_doc_fulfill_status_type) references doc_fulfill_status_type (code)
);

create table proposal_doc_borrower_access
(
    pdba_pid bigint auto_increment
        primary key,
    pdba_version int not null,
    pdba_borrower_pid bigint not null,
    pdba_proposal_doc_pid bigint not null,
    constraint fk_proposal_doc_borrower_access_1
        foreign key (pdba_borrower_pid) references borrower (b_pid),
    constraint fk_proposal_doc_borrower_access_2
        foreign key (pdba_proposal_doc_pid) references proposal_doc (prpd_pid)
);

create table proposal_doc_file
(
    prpdf_pid bigint auto_increment
        primary key,
    prpdf_version int not null,
    prpdf_proposal_doc_pid bigint not null,
    prpdf_deal_file_pid bigint not null,
    prpdf_proposal_doc_file_type varchar(128) not null,
    prpdf_included_file varchar(128) not null,
    prpdf_key_doc bit null,
    constraint prpdf_proposal_doc_pid
        unique (prpdf_proposal_doc_pid, prpdf_deal_file_pid),
    constraint fk_proposal_doc_file_1
        foreign key (prpdf_proposal_doc_pid) references proposal_doc (prpd_pid),
    constraint fk_proposal_doc_file_2
        foreign key (prpdf_deal_file_pid) references deal_file (df_pid),
    constraint fkt_prpdf_included_file
        foreign key (prpdf_included_file) references yes_no_unknown_type (code),
    constraint fkt_prpdf_proposal_doc_file_type
        foreign key (prpdf_proposal_doc_file_type) references proposal_doc_file_type (code)
);

create table proposal_req
(
    prpr_pid bigint auto_increment
        primary key,
    prpr_version int not null,
    prpr_proposal_doc_pid bigint not null,
    prpr_req_name varchar(767) not null,
    prpr_borrower_access bit null,
    prpr_req_id int null,
    prpr_req_fulfill_status_type varchar(128) not null,
    prpr_fulfill_status_unparsed_name varchar(128) null,
    prpr_fulfill_status_reason varchar(1024) null,
    prpr_fulfill_status_datetime datetime null,
    prpr_req_decision_status_type varchar(128) not null,
    prpr_decision_status_unparsed_name varchar(128) null,
    prpr_decision_status_reason varchar(1024) null,
    prpr_decision_status_datetime datetime null,
    prpr_deal_pid bigint not null,
    prpr_proposal_pid bigint not null,
    prpr_loan_pid bigint null,
    prpr_borrower_pid bigint null,
    prpr_borrower_income_pid bigint null,
    prpr_job_income_pid bigint null,
    prpr_borrower_job_gap_pid bigint null,
    prpr_other_income_pid bigint null,
    prpr_business_income_pid bigint null,
    prpr_rental_income_pid bigint null,
    prpr_asset_pid bigint null,
    prpr_asset_large_deposit_pid bigint null,
    prpr_liability_pid bigint null,
    prpr_reo_place_pid bigint null,
    prpr_property_place_pid bigint null,
    prpr_residence_place_pid bigint null,
    prpr_borrower_residence_pid bigint null,
    prpr_application_pid bigint null,
    prpr_credit_inquiry_pid bigint null,
    prpr_appraisal_pid bigint null,
    prpr_appraisal_form_pid bigint null,
    prpr_tax_transcript_request_pid bigint null,
    prpr_deal_child_type varchar(128) not null,
    prpr_deal_child_name varchar(767) not null,
    prpr_smart_req bit null,
    prpr_smart_req_criteria_html text not null,
    prpr_trash bit null,
    prpr_borrower_associated_address_pid bigint null,
    prpr_construction_cost_pid bigint null,
    prpr_construction_draw_pid bigint null,
    prpr_proposal_contractor_pid bigint null,
    constraint uk_proposal_req_1
        unique (prpr_proposal_doc_pid, prpr_req_id),
    constraint fk_proposal_req_1
        foreign key (prpr_proposal_doc_pid) references proposal_doc (prpd_pid),
    constraint fk_proposal_req_10
        foreign key (prpr_business_income_pid) references business_income (bui_pid),
    constraint fk_proposal_req_11
        foreign key (prpr_rental_income_pid) references rental_income (ri_pid),
    constraint fk_proposal_req_12
        foreign key (prpr_asset_pid) references asset (as_pid),
    constraint fk_proposal_req_13
        foreign key (prpr_asset_large_deposit_pid) references asset_large_deposit (ald_pid),
    constraint fk_proposal_req_14
        foreign key (prpr_liability_pid) references liability (lia_pid),
    constraint fk_proposal_req_15
        foreign key (prpr_reo_place_pid) references place (pl_pid),
    constraint fk_proposal_req_16
        foreign key (prpr_property_place_pid) references place (pl_pid),
    constraint fk_proposal_req_17
        foreign key (prpr_residence_place_pid) references place (pl_pid),
    constraint fk_proposal_req_18
        foreign key (prpr_borrower_residence_pid) references borrower_residence (bres_pid),
    constraint fk_proposal_req_19
        foreign key (prpr_application_pid) references application (apl_pid),
    constraint fk_proposal_req_2
        foreign key (prpr_deal_pid) references deal (d_pid),
    constraint fk_proposal_req_20
        foreign key (prpr_credit_inquiry_pid) references credit_inquiry (ci_pid),
    constraint fk_proposal_req_21
        foreign key (prpr_appraisal_pid) references appraisal (apr_pid),
    constraint fk_proposal_req_22
        foreign key (prpr_appraisal_form_pid) references appraisal_form (aprfm_pid),
    constraint fk_proposal_req_23
        foreign key (prpr_tax_transcript_request_pid) references tax_transcript_request (ttr_pid),
    constraint fk_proposal_req_24
        foreign key (prpr_borrower_associated_address_pid) references borrower_associated_address (baa_pid),
    constraint fk_proposal_req_26
        foreign key (prpr_construction_cost_pid) references construction_cost (coc_pid),
    constraint fk_proposal_req_27
        foreign key (prpr_construction_draw_pid) references construction_draw (cd_pid),
    constraint fk_proposal_req_28
        foreign key (prpr_proposal_contractor_pid) references proposal_contractor (pctr_pid),
    constraint fk_proposal_req_3
        foreign key (prpr_proposal_pid) references proposal (prp_pid),
    constraint fk_proposal_req_4
        foreign key (prpr_loan_pid) references loan (l_pid),
    constraint fk_proposal_req_5
        foreign key (prpr_borrower_pid) references borrower (b_pid),
    constraint fk_proposal_req_6
        foreign key (prpr_borrower_income_pid) references borrower_income (bi_pid),
    constraint fk_proposal_req_7
        foreign key (prpr_job_income_pid) references job_income (ji_pid),
    constraint fk_proposal_req_8
        foreign key (prpr_borrower_job_gap_pid) references borrower_job_gap (bjg_pid),
    constraint fk_proposal_req_9
        foreign key (prpr_other_income_pid) references other_income (oi_pid),
    constraint fkt_prpr_deal_child_type
        foreign key (prpr_deal_child_type) references deal_child_type (code),
    constraint fkt_prpr_req_decision_status_type
        foreign key (prpr_req_decision_status_type) references req_decision_status_type (code),
    constraint fkt_prpr_req_fulfill_status_type
        foreign key (prpr_req_fulfill_status_type) references req_fulfill_status_type (code)
);

create table sap_deal_step
(
    sds_pid bigint auto_increment
        primary key,
    sds_version int not null,
    sds_borrower_user_pid bigint not null,
    sds_previous_pid bigint null,
    sds_sap_step_type varchar(128) not null,
    sds_complete_datetime datetime null,
    sds_yes_no_answer varchar(128) not null,
    sds_deal_pid bigint not null,
    sds_borrower_pid bigint null,
    sds_reo_pid bigint null,
    sds_application_pid bigint null,
    sds_job_income_pid bigint null,
    sds_other_income_pid bigint null,
    sds_borrower_residence_pid bigint null,
    sds_asset_pid bigint null,
    sds_liability_pid bigint null,
    sds_deal_contact_pid bigint null,
    sds_deal_real_estate_agent_pid bigint null,
    sds_radio_choice_answer varchar(32) null,
    sds_initial_values bit null,
    sds_business_income_pid bigint null,
    constraint fk_sap_deal_step_1
        foreign key (sds_borrower_user_pid) references borrower_user (bu_pid),
    constraint fk_sap_deal_step_10
        foreign key (sds_asset_pid) references asset (as_pid),
    constraint fk_sap_deal_step_11
        foreign key (sds_liability_pid) references liability (lia_pid),
    constraint fk_sap_deal_step_12
        foreign key (sds_deal_contact_pid) references deal_contact (dc_pid),
    constraint fk_sap_deal_step_13
        foreign key (sds_deal_real_estate_agent_pid) references deal_real_estate_agent (drea_pid),
    constraint fk_sap_deal_step_2
        foreign key (sds_previous_pid) references sap_deal_step (sds_pid),
    constraint fk_sap_deal_step_3
        foreign key (sds_deal_pid) references deal (d_pid),
    constraint fk_sap_deal_step_4
        foreign key (sds_borrower_pid) references borrower (b_pid),
    constraint fk_sap_deal_step_5
        foreign key (sds_reo_pid) references place (pl_pid),
    constraint fk_sap_deal_step_6
        foreign key (sds_application_pid) references application (apl_pid),
    constraint fk_sap_deal_step_7
        foreign key (sds_job_income_pid) references job_income (ji_pid),
    constraint fk_sap_deal_step_8
        foreign key (sds_other_income_pid) references other_income (oi_pid),
    constraint fk_sap_deal_step_9
        foreign key (sds_borrower_residence_pid) references borrower_residence (bres_pid),
    constraint fkt_sds_sap_step_type
        foreign key (sds_sap_step_type) references sap_step_type (code),
    constraint fkt_sds_yes_no_answer
        foreign key (sds_yes_no_answer) references yes_no_unknown_type (code)
);

create table deal_sap
(
    dsap_pid bigint auto_increment
        primary key,
    dsap_version int not null,
    dsap_deal_pid bigint not null,
    dsap_last_sap_deal_step_pid bigint null,
    dsap_last_sap_step_type varchar(128) not null,
    dsap_credit_pull_attempts int not null,
    dsap_retry_credit_pull bit not null,
    dsap_borrower_step_type int not null,
    constraint fk_deal_sap_1
        foreign key (dsap_deal_pid) references deal (d_pid),
    constraint fk_deal_sap_2
        foreign key (dsap_last_sap_deal_step_pid) references sap_deal_step (sds_pid),
    constraint fkt_dsap_last_sap_step_type
        foreign key (dsap_last_sap_step_type) references sap_step_type (code)
);

create table trade
(
    t_pid bigint auto_increment
        primary key,
    t_version int not null,
    t_account_pid bigint not null,
    t_investor_pid bigint null,
    t_create_lender_user_pid bigint not null,
    t_create_datetime datetime not null,
    t_lender_trade_id varchar(11) not null,
    t_investor_trade_id varchar(32) null,
    t_investor_commitment_id varchar(32) null,
    t_trade_name varchar(128) null,
    t_trade_status_type varchar(128) not null,
    t_commitment_amount_tolerance_percent decimal(11,9) not null,
    t_commitment_amount decimal(15,2) not null,
    t_minimum_note_rate_percent decimal(11,9) not null,
    t_maximum_note_rate_percent decimal(11,9) not null,
    t_actual_delivery_datetime datetime null,
    t_early_delivery_datetime datetime null,
    t_required_delivery_datetime datetime null,
    t_commitment_expiration_datetime datetime null,
    t_commitment_datetime datetime null,
    t_purchase_datetime datetime null,
    t_weighted_average_note_rate_percent decimal(11,9) not null,
    t_weighted_average_lender_price_percent decimal(11,9) not null,
    t_weighted_average_investor_price_percent decimal(11,9) not null,
    t_weighted_average_net_price_percent decimal(11,9) not null,
    t_weighted_average_decision_credit_score int null,
    t_average_loan_amount decimal(15,2) not null,
    t_total_loan_amount decimal(17,2) not null,
    t_loans_delivered_percent decimal(11,9) not null,
    t_trade_pricing_type varchar(128) not null,
    t_trade_same_price_percent decimal(11,9) not null,
    t_buy_up_multiple int null,
    t_buy_down_multiple int null,
    constraint t_account_pid
        unique (t_account_pid, t_lender_trade_id),
    constraint fk_trade_1
        foreign key (t_account_pid) references account (a_pid),
    constraint fk_trade_2
        foreign key (t_investor_pid) references investor (i_pid),
    constraint fk_trade_3
        foreign key (t_create_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_t_trade_pricing_type
        foreign key (t_trade_pricing_type) references trade_pricing_type (code),
    constraint fkt_t_trade_status_type
        foreign key (t_trade_status_type) references trade_status_type (code)
);

create table investor_lock
(
    il_pid bigint auto_increment
        primary key,
    il_version int not null,
    il_lender_lock_major_pid bigint not null,
    il_product_terms_pid bigint null,
    il_mortgage_type varchar(128) not null,
    il_interest_only_type varchar(128) not null,
    il_buydown_schedule_type varchar(128) not null,
    il_prepay_penalty_schedule_type varchar(128) not null,
    il_lock_commitment_type varchar(128) not null,
    il_initial_duration_days int null,
    il_commitment_datetime datetime null,
    il_initial_commitment_expiration_datetime datetime null,
    il_effective_commitment_expiration_datetime datetime null,
    il_effective_duration_days int null,
    il_cancel_datetime datetime null,
    il_cancel_lender_user_pid bigint null,
    il_cancel_unparsed_name varchar(128) null,
    il_confirm_datetime datetime null,
    il_confirm_lender_user_pid bigint null,
    il_confirm_unparsed_name varchar(128) null,
    il_requester_lender_user_pid bigint null,
    il_requester_unparsed_name varchar(128) null,
    il_request_datetime datetime null,
    il_notes varchar(16000) null,
    il_investor_base_note_rate_percent decimal(11,9) not null,
    il_investor_base_arm_margin_percent decimal(11,9) not null,
    il_investor_base_price_percent decimal(11,9) not null,
    il_lock_note_rate_percent decimal(11,9) not null,
    il_lock_initial_note_rate_percent decimal(11,9) not null,
    il_lock_arm_margin_percent decimal(11,9) not null,
    il_lock_price_percent decimal(11,9) not null,
    il_lock_price_raw_percent decimal(11,9) not null,
    il_maximum_rebate_percent decimal(11,9) not null,
    il_trade_pid bigint null,
    il_hedging bit null,
    il_investor_lock_status_type varchar(128) not null,
    il_investor_loan_id varchar(32) null,
    il_required_delivery_datetime datetime null,
    il_investor_commitment_id varchar(32) null,
    constraint il_lender_lock_major_pid
        unique (il_lender_lock_major_pid),
    constraint fk_investor_lock_2
        foreign key (il_cancel_lender_user_pid) references lender_user (lu_pid),
    constraint fk_investor_lock_3
        foreign key (il_confirm_lender_user_pid) references lender_user (lu_pid),
    constraint fk_investor_lock_4
        foreign key (il_requester_lender_user_pid) references lender_user (lu_pid),
    constraint fk_investor_lock_5
        foreign key (il_lender_lock_major_pid) references lender_lock_major (llmj_pid),
    constraint fk_investor_lock_6
        foreign key (il_product_terms_pid) references product_terms (pt_pid),
    constraint fk_investor_lock_7
        foreign key (il_trade_pid) references trade (t_pid),
    constraint fkt_il_buydown_schedule_type
        foreign key (il_buydown_schedule_type) references buydown_schedule_type (code),
    constraint fkt_il_interest_only_type
        foreign key (il_interest_only_type) references interest_only_type (code),
    constraint fkt_il_investor_lock_status_type
        foreign key (il_investor_lock_status_type) references investor_lock_status_type (code),
    constraint fkt_il_lock_commitment_type
        foreign key (il_lock_commitment_type) references lock_commitment_type (code),
    constraint fkt_il_mortgage_type
        foreign key (il_mortgage_type) references mortgage_type (code),
    constraint fkt_il_prepay_penalty_schedule_type
        foreign key (il_prepay_penalty_schedule_type) references prepay_penalty_schedule_type (code)
);

create table investor_lock_add_on
(
    ila_pid bigint auto_increment
        primary key,
    ila_version int not null,
    ila_investor_lock_pid bigint not null,
    ila_create_datetime datetime not null,
    ila_creator_lender_user_pid bigint not null,
    ila_creator_unparsed_name varchar(128) null,
    ila_summary varchar(16000) null,
    ila_rate_adjustment_percent decimal(11,9) not null,
    ila_price_adjustment_percent decimal(11,9) not null,
    ila_arm_margin_adjustment_percent decimal(11,9) not null,
    constraint fk_investor_lock_add_on_1
        foreign key (ila_investor_lock_pid) references investor_lock (il_pid),
    constraint fk_investor_lock_add_on_2
        foreign key (ila_creator_lender_user_pid) references lender_user (lu_pid)
);

create table investor_lock_extension
(
    ile_pid bigint auto_increment
        primary key,
    ile_version int not null,
    ile_investor_lock_pid bigint not null,
    ile_creator_lender_user_pid bigint not null,
    ile_creator_unparsed_name varchar(128) null,
    ile_requester_lender_user_pid bigint not null,
    ile_requester_unparsed_name varchar(128) null,
    ile_requested_datetime datetime null,
    ile_confirm_lender_user_pid bigint null,
    ile_confirm_unparsed_name varchar(128) null,
    ile_confirm_datetime datetime null,
    ile_reject_lender_user_pid bigint null,
    ile_reject_datetime datetime null,
    ile_reject_explanation varchar(1024) null,
    ile_lock_extension_status_type varchar(128) not null,
    ile_extension_days int null,
    ile_price_adjustment_percent decimal(11,9) not null,
    constraint fk_investor_lock_extension_1
        foreign key (ile_investor_lock_pid) references investor_lock (il_pid),
    constraint fk_investor_lock_extension_2
        foreign key (ile_creator_lender_user_pid) references lender_user (lu_pid),
    constraint fk_investor_lock_extension_3
        foreign key (ile_requester_lender_user_pid) references lender_user (lu_pid),
    constraint fk_investor_lock_extension_4
        foreign key (ile_confirm_lender_user_pid) references lender_user (lu_pid),
    constraint fk_investor_lock_extension_5
        foreign key (ile_reject_lender_user_pid) references lender_user (lu_pid),
    constraint fkt_ile_lock_extension_status_type
        foreign key (ile_lock_extension_status_type) references lock_extension_status_type (code)
);

create index idx_trade_1
    on trade (t_lender_trade_id);

create table trade_audit
(
    ta_pid bigint auto_increment
        primary key,
    ta_version int not null,
    ta_trade_pid bigint not null,
    ta_lender_lock_major_pid bigint null,
    ta_trade_audit_type varchar(128) not null,
    ta_message varchar(256) null,
    constraint fk_trade_audit_1
        foreign key (ta_trade_pid) references trade (t_pid),
    constraint fk_trade_audit_2
        foreign key (ta_lender_lock_major_pid) references lender_lock_major (llmj_pid),
    constraint fkt_ta_trade_audit_type
        foreign key (ta_trade_audit_type) references trade_audit_type (code)
);

create table trade_fee
(
    tfe_pid bigint auto_increment
        primary key,
    tfe_version int not null,
    tfe_trade_pid bigint not null,
    tfe_trade_fee_type_pid bigint not null,
    tfe_amount decimal(15,2) not null,
    tfe_description varchar(256) null,
    constraint fk_trade_fee_1
        foreign key (tfe_trade_pid) references trade (t_pid),
    constraint fk_trade_fee_2
        foreign key (tfe_trade_fee_type_pid) references trade_fee_type (tft_pid)
);

create table trade_file
(
    tf_pid bigint auto_increment
        primary key,
    tf_version int not null,
    tf_trade_pid bigint not null,
    tf_repository_file_pid bigint not null,
    constraint tf_repository_file_pid
        unique (tf_repository_file_pid),
    constraint fk_trade_file_1
        foreign key (tf_trade_pid) references trade (t_pid),
    constraint fk_trade_file_2
        foreign key (tf_repository_file_pid) references repository_file (rf_pid)
);

create table trade_lock_filter
(
    tlf_pid bigint auto_increment
        primary key,
    tlf_version int not null,
    tlf_lender_user_pid bigint not null,
    tlf_name varchar(128) not null,
    tlf_criteria_pid bigint null,
    constraint fk_trade_lock_filter_1
        foreign key (tlf_lender_user_pid) references lender_user (lu_pid),
    constraint fk_trade_lock_filter_2
        foreign key (tlf_criteria_pid) references criteria (cr_pid)
);

create table trade_note
(
    tn_pid bigint auto_increment
        primary key,
    tn_version int not null,
    tn_trade_pid bigint not null,
    tn_create_datetime datetime not null,
    tn_content varchar(16000) null,
    tn_author_lender_user_pid bigint not null,
    tn_author_unparsed_name varchar(128) null,
    constraint fk_trade_note_1
        foreign key (tn_trade_pid) references trade (t_pid),
    constraint fk_trade_note_2
        foreign key (tn_author_lender_user_pid) references lender_user (lu_pid)
);

create table trade_note_comment
(
    tnc_pid bigint auto_increment
        primary key,
    tnc_version int not null,
    tnc_trade_note_pid bigint not null,
    tnc_create_datetime datetime not null,
    tnc_content varchar(16000) null,
    tnc_author_lender_user_pid bigint not null,
    tnc_author_unparsed_name varchar(128) null,
    constraint fk_trade_note_comment_1
        foreign key (tnc_trade_note_pid) references trade_note (tn_pid),
    constraint fk_trade_note_comment_2
        foreign key (tnc_author_lender_user_pid) references lender_user (lu_pid)
);

create table trade_note_monitor
(
    tnm_pid bigint auto_increment
        primary key,
    tnm_version int not null,
    tnm_trade_note_pid bigint not null,
    tnm_lender_user_pid bigint not null,
    constraint fk_trade_note_monitor_1
        foreign key (tnm_trade_note_pid) references trade_note (tn_pid),
    constraint fk_trade_note_monitor_2
        foreign key (tnm_lender_user_pid) references lender_user (lu_pid)
);

create table trade_product
(
    tp_pid bigint auto_increment
        primary key,
    tp_version int not null,
    tp_product_pid bigint not null,
    tp_trade_pid bigint not null,
    constraint uk_trade_product_1
        unique (tp_trade_pid, tp_product_pid),
    constraint fk_trade_product_1
        foreign key (tp_product_pid) references product (p_pid),
    constraint fk_trade_product_2
        foreign key (tp_trade_pid) references trade (t_pid)
);

create table unpaid_balance_adjustment
(
    upba_pid bigint auto_increment
        primary key,
    upba_version int not null,
    upba_investor_pid bigint not null,
    upba_adjustment_percent decimal(11,9) not null,
    upba_from_date date not null,
    upba_mortgage_type varchar(128) not null,
    constraint uk_investor_from_date
        unique (upba_from_date, upba_investor_pid, upba_mortgage_type),
    constraint fk_unpaid_balance_adjustment_1
        foreign key (upba_investor_pid) references investor (i_pid)
);

create table vendor_document_repository_file
(
    vdrf_pid bigint auto_increment
        primary key,
    vdrf_version int not null,
    vdrf_account_pid bigint not null,
    vdrf_deal_pid bigint null,
    vdrf_document_import_vendor_type varchar(128) not null,
    vdrf_client_filename varchar(128) not null,
    vdrf_client_filepath varchar(256) not null,
    vdrf_file_checksum varchar(128) null,
    vdrf_vendor_import_document_type varchar(128) not null,
    vdrf_document_import_status_type varchar(128) not null,
    vdrf_processed_datetime datetime null,
    constraint fk_vendor_document_repository_file_1
        foreign key (vdrf_account_pid) references account (a_pid),
    constraint fk_vendor_document_repository_file_2
        foreign key (vdrf_deal_pid) references deal (d_pid),
    constraint fkt_vdrf_document_import_status_type
        foreign key (vdrf_document_import_status_type) references document_import_status_type (code),
    constraint fkt_vdrf_document_import_vendor_type
        foreign key (vdrf_document_import_vendor_type) references document_import_vendor_type (code),
    constraint fkt_vdrf_vendor_import_document_type
        foreign key (vdrf_vendor_import_document_type) references vendor_import_document_type (code)
);

create table deal_data_vendor_document_import
(
    ddvdi_pid bigint auto_increment
        primary key,
    ddvdi_version int not null,
    ddvdi_deal_pid bigint not null,
    ddvdi_vendor_document_repository_file_pid bigint not null,
    ddvdi_deal_system_file_pid bigint not null,
    ddvdi_vendor_import_document_type varchar(128) not null,
    ddvdi_create_datetime datetime not null,
    ddvdi_document_import_status_type varchar(128) not null,
    ddvdi_failure_info varchar(16000) not null,
    ddvdi_warning_info varchar(16000) not null,
    constraint fk_deal_data_vendor_document_import_1
        foreign key (ddvdi_deal_pid) references deal (d_pid),
    constraint fk_deal_data_vendor_document_import_2
        foreign key (ddvdi_vendor_document_repository_file_pid) references vendor_document_repository_file (vdrf_pid),
    constraint fk_deal_data_vendor_document_import_3
        foreign key (ddvdi_deal_system_file_pid) references deal_system_file (dsf_pid),
    constraint fkt_ddvdi_document_import_status_type
        foreign key (ddvdi_document_import_status_type) references document_import_status_type (code),
    constraint fkt_ddvdi_vendor_import_document_type
        foreign key (ddvdi_vendor_import_document_type) references vendor_import_document_type (code)
);

create table vendor_document_event
(
    vde_pid bigint auto_increment
        primary key,
    vde_version int not null,
    vde_account_pid bigint not null,
    vde_vendor_document_repository_file_pid bigint not null,
    vde_vendor_document_event_type varchar(128) not null,
    vde_source_unparsed_name varchar(128) not null,
    vde_messages text not null,
    vde_create_datetime datetime null,
    vde_create_date date null,
    constraint fk_vendor_document_event_1
        foreign key (vde_account_pid) references account (a_pid),
    constraint fk_vendor_document_event_2
        foreign key (vde_vendor_document_repository_file_pid) references vendor_document_repository_file (vdrf_pid),
    constraint fkt_vde_vendor_document_event_type
        foreign key (vde_vendor_document_event_type) references vendor_document_event_type (code)
);

create table wf_deal_process
(
    wdpr_pid bigint auto_increment
        primary key,
    wdpr_version int not null,
    wdpr_deal_pid bigint not null,
    wdpr_wf_process_pid bigint not null,
    wdpr_wf_deal_process_status_type varchar(128) not null,
    wdpr_process_start_datetime datetime null,
    wdpr_process_complete_datetime datetime null,
    wdpr_name varchar(128) null,
    constraint fk_wf_deal_process_1
        foreign key (wdpr_deal_pid) references deal (d_pid),
    constraint fk_wf_deal_process_2
        foreign key (wdpr_wf_process_pid) references wf_process (wpr_pid),
    constraint fkt_wdpr_wf_deal_process_status_type
        foreign key (wdpr_wf_deal_process_status_type) references wf_deal_process_status_type (code)
);

create table wf_step
(
    ws_pid bigint auto_increment
        primary key,
    ws_version int not null,
    ws_wf_process_pid bigint not null,
    ws_step_name varchar(128) null,
    ws_step_number decimal(17,5) not null,
    ws_step_number_formatted varchar(16) null,
    ws_step_number_name_formatted varchar(128) null,
    ws_step_start_borrower_text varchar(1024) null,
    ws_expected_complete_minutes int null,
    ws_wf_step_timeout_type varchar(128) not null,
    ws_second_of_day_timeout int not null,
    ws_timeout_time_zone_type varchar(128) not null,
    ws_description varchar(1024) null,
    ws_wf_step_type varchar(128) not null,
    ws_wf_phase_pid bigint not null,
    ws_wf_step_performer_assign_type varchar(128) not null,
    ws_role_pid bigint null,
    ws_from_role_pid bigint null,
    ws_wf_step_reassign_type varchar(128) not null,
    ws_wf_step_function_type varchar(128) not null,
    ws_sap_expire_minutes int null,
    ws_sap_expire_warning_minutes int null,
    ws_prompt_user_defined_time bit null,
    ws_smart_message_pid bigint null,
    ws_smart_doc_set_pid bigint null,
    ws_lien_priority_type varchar(128) not null,
    ws_active_only bit null,
    ws_internal bit not null,
    ws_deal_stage_type varchar(128) not null,
    ws_polling_interval_type varchar(128) not null,
    ws_swappable bit not null,
    constraint fk_wf_step_1
        foreign key (ws_wf_process_pid) references wf_process (wpr_pid),
    constraint fk_wf_step_2
        foreign key (ws_wf_phase_pid) references wf_phase (wph_pid),
    constraint fk_wf_step_4
        foreign key (ws_role_pid) references role (r_pid),
    constraint fk_wf_step_5
        foreign key (ws_smart_message_pid) references smart_message (smsg_pid),
    constraint fk_wf_step_6
        foreign key (ws_from_role_pid) references role (r_pid),
    constraint fk_ws_step_6
        foreign key (ws_smart_doc_set_pid) references smart_doc_set (sdst_pid),
    constraint fkt_ws_deal_stage_type
        foreign key (ws_deal_stage_type) references deal_stage_type (code),
    constraint fkt_ws_lien_priority_type
        foreign key (ws_lien_priority_type) references lien_priority_type (code),
    constraint fkt_ws_polling_interval_type
        foreign key (ws_polling_interval_type) references polling_interval_type (code),
    constraint fkt_ws_timeout_time_zone_type
        foreign key (ws_timeout_time_zone_type) references timeout_time_zone_type (code),
    constraint fkt_ws_wf_step_function_type
        foreign key (ws_wf_step_function_type) references wf_step_function_type (code),
    constraint fkt_ws_wf_step_performer_assign_type
        foreign key (ws_wf_step_performer_assign_type) references wf_step_performer_assign_type (code),
    constraint fkt_ws_wf_step_reassign_type
        foreign key (ws_wf_step_reassign_type) references wf_step_reassign_type (code),
    constraint fkt_ws_wf_step_timeout_type
        foreign key (ws_wf_step_timeout_type) references wf_step_timeout_type (code),
    constraint fkt_ws_wf_step_type
        foreign key (ws_wf_step_type) references wf_step_type (code)
);

create table criteria_pid_operand
(
    crpo_pid bigint auto_increment
        primary key,
    crpo_version int not null,
    crpo_criteria_pid bigint not null,
    crpo_criteria_pid_operand_type varchar(128) not null,
    crpo_lender_user_pid bigint null,
    crpo_role_pid bigint null,
    crpo_branch_pid bigint null,
    crpo_wf_step_pid bigint null,
    crpo_wf_phase_pid bigint null,
    crpo_county_pid bigint null,
    crpo_investor_pid bigint null,
    crpo_product_pid bigint null,
    crpo_lead_source_pid bigint null,
    crpo_company_pid bigint null,
    crpo_deal_tag_definition_pid bigint null,
    crpo_creditor_pid bigint null,
    crpo_interim_funder_pid bigint null,
    crpo_settlement_agent_pid bigint null,
    crpo_performer_team_pid bigint null,
    crpo_third_party_community_second_program_pid bigint null,
    crpo_offering_pid bigint null,
    crpo_channel_pid bigint null,
    crpo_account_grant_program_pid bigint null,
    crpo_mortgage_credit_certificate_issuer_pid bigint null,
    crpo_criteria_snippet_pid bigint null,
    crpo_smart_doc_pid bigint null,
    constraint fk_criteria_pid_operand_1
        foreign key (crpo_criteria_pid) references criteria (cr_pid),
    constraint fk_criteria_pid_operand_10
        foreign key (crpo_lead_source_pid) references lead_source (lds_pid),
    constraint fk_criteria_pid_operand_11
        foreign key (crpo_company_pid) references company (cm_pid),
    constraint fk_criteria_pid_operand_12
        foreign key (crpo_creditor_pid) references creditor (crd_pid),
    constraint fk_criteria_pid_operand_13
        foreign key (crpo_interim_funder_pid) references interim_funder (if_pid),
    constraint fk_criteria_pid_operand_14
        foreign key (crpo_settlement_agent_pid) references settlement_agent (sa_pid),
    constraint fk_criteria_pid_operand_15
        foreign key (crpo_performer_team_pid) references performer_team (ptm_pid),
    constraint fk_criteria_pid_operand_16
        foreign key (crpo_third_party_community_second_program_pid) references third_party_community_second_program (tpcsp_pid),
    constraint fk_criteria_pid_operand_17
        foreign key (crpo_channel_pid) references channel (ch_pid),
    constraint fk_criteria_pid_operand_18
        foreign key (crpo_account_grant_program_pid) references account_grant_program (agp_pid),
    constraint fk_criteria_pid_operand_19
        foreign key (crpo_offering_pid) references offering (of_pid),
    constraint fk_criteria_pid_operand_2
        foreign key (crpo_lender_user_pid) references lender_user (lu_pid),
    constraint fk_criteria_pid_operand_20
        foreign key (crpo_mortgage_credit_certificate_issuer_pid) references mortgage_credit_certificate_issuer (mcci_pid),
    constraint fk_criteria_pid_operand_21
        foreign key (crpo_criteria_snippet_pid) references criteria_snippet (crs_pid),
    constraint fk_criteria_pid_operand_22
        foreign key (crpo_smart_doc_pid) references smart_doc (sd_pid),
    constraint fk_criteria_pid_operand_23
        foreign key (crpo_deal_tag_definition_pid) references deal_tag_definition (dtd_pid),
    constraint fk_criteria_pid_operand_3
        foreign key (crpo_role_pid) references role (r_pid),
    constraint fk_criteria_pid_operand_4
        foreign key (crpo_branch_pid) references branch (br_pid),
    constraint fk_criteria_pid_operand_5
        foreign key (crpo_wf_step_pid) references wf_step (ws_pid),
    constraint fk_criteria_pid_operand_6
        foreign key (crpo_wf_phase_pid) references wf_phase (wph_pid),
    constraint fk_criteria_pid_operand_7
        foreign key (crpo_county_pid) references county (c_pid),
    constraint fk_criteria_pid_operand_8
        foreign key (crpo_investor_pid) references investor (i_pid),
    constraint fk_criteria_pid_operand_9
        foreign key (crpo_product_pid) references product (p_pid),
    constraint fkt_crpo_criteria_pid_operand_type
        foreign key (crpo_criteria_pid_operand_type) references criteria_pid_operand_type (code)
);

create table smart_task
(
    st_pid bigint auto_increment
        primary key,
    st_version int not null,
    st_wf_step_pid bigint not null,
    st_description varchar(1024) not null,
    st_from_date date not null,
    st_through_date date null,
    st_wf_step_order int null,
    st_criteria_pid bigint null,
    constraint fk_smart_task_1
        foreign key (st_wf_step_pid) references wf_step (ws_pid),
    constraint fk_smart_task_2
        foreign key (st_criteria_pid) references criteria (cr_pid)
);

create table smart_task_tag_modifier
(
    sttm_pid bigint auto_increment
        primary key,
    sttm_version int not null,
    sttm_deal_tag_definition_pid bigint not null,
    sttm_smart_task_pid bigint not null,
    sttm_add_tag bit null,
    constraint fk_smart_task_tag_modifier_1
        foreign key (sttm_deal_tag_definition_pid) references deal_tag_definition (dtd_pid),
    constraint fk_smart_task_tag_modifier_2
        foreign key (sttm_smart_task_pid) references smart_task (st_pid)
);

create table view_wf_deal_step_started
(
    wds_pid bigint not null
        primary key,
    wds_version int not null,
    wds_wf_step_pid bigint null,
    wds_wf_deal_process_pid bigint not null,
    wds_performer_user_pid bigint null,
    wds_visit_number int null,
    wds_start_datetime datetime null,
    wds_complete_datetime datetime null,
    wds_timeout_datetime datetime null,
    wds_wf_deal_step_status_type varchar(128) not null,
    wds_wf_step_type varchar(128) not null,
    wds_function_error_list text not null,
    wds_step_name varchar(128) null,
    wds_step_number decimal(17,5) not null,
    wds_step_number_formatted varchar(16) null,
    wds_step_number_name_formatted varchar(128) null,
    wds_expected_complete_minutes int null,
    wds_description varchar(1024) null,
    wds_wf_step_function_type varchar(128) not null,
    wds_phase_name varchar(128) null,
    wds_phase_number int null,
    wds_allow_check_override bit null,
    wds_deal_stage_pid bigint not null,
    wds_completing_user_pid bigint null,
    wds_polling_interval_offset int not null,
    wds_materialized_view_trash bit not null,
    constraint wds_wf_step_pid
        unique (wds_wf_step_pid, wds_wf_deal_process_pid, wds_visit_number),
    constraint fk_view_wf_deal_step_started_1
        foreign key (wds_wf_step_pid) references wf_step (ws_pid),
    constraint fk_view_wf_deal_step_started_2
        foreign key (wds_wf_deal_process_pid) references wf_deal_process (wdpr_pid),
    constraint fk_view_wf_deal_step_started_3
        foreign key (wds_performer_user_pid) references lender_user (lu_pid),
    constraint fk_view_wf_deal_step_started_4
        foreign key (wds_deal_stage_pid) references deal_stage (dst_pid),
    constraint fk_view_wf_deal_step_started_5
        foreign key (wds_completing_user_pid) references lender_user (lu_pid),
    constraint fkt_view_started_wds_wf_deal_step_status_type
        foreign key (wds_wf_deal_step_status_type) references wf_deal_step_status_type (code),
    constraint fkt_view_started_wds_wf_step_function_type
        foreign key (wds_wf_step_function_type) references wf_step_function_type (code),
    constraint fkt_view_started_wds_wf_step_type
        foreign key (wds_wf_step_type) references wf_step_type (code)
);

create table wf_deal_step
(
    wds_pid bigint auto_increment
        primary key,
    wds_version int not null,
    wds_wf_step_pid bigint null,
    wds_wf_deal_process_pid bigint not null,
    wds_performer_user_pid bigint null,
    wds_visit_number int null,
    wds_start_datetime datetime null,
    wds_complete_datetime datetime null,
    wds_timeout_datetime datetime null,
    wds_wf_deal_step_status_type varchar(128) not null,
    wds_wf_step_type varchar(128) not null,
    wds_function_error_list text not null,
    wds_step_name varchar(128) null,
    wds_step_number decimal(17,5) not null,
    wds_step_number_formatted varchar(16) null,
    wds_step_number_name_formatted varchar(128) null,
    wds_expected_complete_minutes int null,
    wds_description varchar(1024) null,
    wds_wf_step_function_type varchar(128) not null,
    wds_phase_name varchar(128) null,
    wds_phase_number int null,
    wds_allow_check_override bit null,
    wds_deal_stage_pid bigint not null,
    wds_completing_user_pid bigint null,
    wds_polling_interval_offset int not null,
    constraint wds_wf_step_pid
        unique (wds_wf_step_pid, wds_wf_deal_process_pid, wds_visit_number),
    constraint fk_wf_deal_step_1
        foreign key (wds_wf_step_pid) references wf_step (ws_pid),
    constraint fk_wf_deal_step_2
        foreign key (wds_wf_deal_process_pid) references wf_deal_process (wdpr_pid),
    constraint fk_wf_deal_step_3
        foreign key (wds_performer_user_pid) references lender_user (lu_pid),
    constraint fk_wf_deal_step_4
        foreign key (wds_deal_stage_pid) references deal_stage (dst_pid),
    constraint fk_wf_deal_step_5
        foreign key (wds_completing_user_pid) references lender_user (lu_pid),
    constraint fkt_wds_wf_deal_step_status_type
        foreign key (wds_wf_deal_step_status_type) references wf_deal_step_status_type (code),
    constraint fkt_wds_wf_step_function_type
        foreign key (wds_wf_step_function_type) references wf_step_function_type (code),
    constraint fkt_wds_wf_step_type
        foreign key (wds_wf_step_type) references wf_step_type (code)
);

create table deal_note
(
    dn_pid bigint auto_increment
        primary key,
    dn_version int not null,
    dn_deal_pid bigint not null,
    dn_create_datetime datetime not null,
    dn_content varchar(16000) null,
    dn_author_unparsed_name varchar(128) null,
    dn_author_lender_user_pid bigint not null,
    dn_scope_type varchar(128) not null,
    dn_scope_name varchar(1024) null,
    dn_wf_deal_step_pid bigint null,
    dn_proposal_doc_pid bigint null,
    dn_proposal_review_pid bigint null,
    constraint fk_deal_note_1
        foreign key (dn_deal_pid) references deal (d_pid),
    constraint fk_deal_note_2
        foreign key (dn_author_lender_user_pid) references lender_user (lu_pid),
    constraint fk_deal_note_3
        foreign key (dn_wf_deal_step_pid) references wf_deal_step (wds_pid),
    constraint fk_deal_note_4
        foreign key (dn_proposal_doc_pid) references proposal_doc (prpd_pid),
    constraint fk_deal_note_5
        foreign key (dn_proposal_review_pid) references proposal_review (prpre_pid),
    constraint fkt_dn_scope_type
        foreign key (dn_scope_type) references deal_note_scope_type (code)
);

create table deal_note_comment
(
    dnc_pid bigint auto_increment
        primary key,
    dnc_version int not null,
    dnc_deal_note_pid bigint not null,
    dnc_create_datetime datetime not null,
    dnc_content varchar(16000) null,
    dnc_author_unparsed_name varchar(128) null,
    dnc_author_lender_user_pid bigint not null,
    constraint fk_deal_note_comment_1
        foreign key (dnc_deal_note_pid) references deal_note (dn_pid),
    constraint fk_deal_note_comment_2
        foreign key (dnc_author_lender_user_pid) references lender_user (lu_pid)
);

create table deal_note_monitor
(
    dnm_pid bigint auto_increment
        primary key,
    dnm_version int not null,
    dnm_deal_note_pid bigint not null,
    dnm_lender_user_pid bigint not null,
    constraint dnm_deal_note_pid
        unique (dnm_deal_note_pid, dnm_lender_user_pid),
    constraint fk_deal_note_monitor_1
        foreign key (dnm_deal_note_pid) references deal_note (dn_pid),
    constraint fk_deal_note_monitor_2
        foreign key (dnm_lender_user_pid) references lender_user (lu_pid)
);

create table deal_note_role_tag
(
    dnrt_pid bigint auto_increment
        primary key,
    dnrt_version int not null,
    dnrt_deal_note_pid bigint not null,
    dnrt_role_pid bigint not null,
    constraint fk_deal_note_role_tag_1
        foreign key (dnrt_deal_note_pid) references deal_note (dn_pid),
    constraint fk_deal_note_role_tag_2
        foreign key (dnrt_role_pid) references role (r_pid)
);

create table deal_task
(
    dt_pid bigint auto_increment
        primary key,
    dt_version int not null,
    dt_wf_deal_step_pid bigint not null,
    dt_create_lender_user_name varchar(128) not null,
    dt_create_datetime datetime not null,
    dt_description varchar(1024) not null,
    dt_complete_datetime datetime null,
    dt_deal_task_status_type varchar(128) not null,
    dt_smart_task bit null,
    constraint uk_description_1
        unique (dt_wf_deal_step_pid, dt_description),
    constraint fk_deal_task_1
        foreign key (dt_wf_deal_step_pid) references wf_deal_step (wds_pid),
    constraint fkt_dt_deal_task_status_type
        foreign key (dt_deal_task_status_type) references deal_task_status_type (code)
);

create table wf_deal_fork_process
(
    wdfp_pid bigint auto_increment
        primary key,
    wdfp_version int not null,
    wdfp_wf_deal_step_pid bigint not null,
    wdfp_wf_deal_process_pid bigint not null,
    constraint uk_wf_deal_fork_process_1
        unique (wdfp_wf_deal_step_pid, wdfp_wf_deal_process_pid),
    constraint fk_wf_deal_fork_process_1
        foreign key (wdfp_wf_deal_step_pid) references wf_deal_step (wds_pid),
    constraint fk_wf_deal_fork_process_2
        foreign key (wdfp_wf_deal_process_pid) references wf_deal_process (wdpr_pid)
);

create table wf_deal_function_queue
(
    wdfq_pid bigint auto_increment
        primary key,
    wdfq_version int not null,
    wdfq_wf_deal_step_pid bigint not null,
    wdfq_worker_start_datetime datetime not null,
    wdfq_halted bit not null,
    wdfq_retry_count int not null,
    constraint wdfq_wf_deal_step_pid
        unique (wdfq_wf_deal_step_pid),
    constraint fk_wf_deal_function_queue_1
        foreign key (wdfq_wf_deal_step_pid) references wf_deal_step (wds_pid)
);

create table wf_deal_outcome
(
    wdo_pid bigint auto_increment
        primary key,
    wdo_version int not null,
    wdo_wf_deal_step_pid bigint not null,
    wdo_wf_outcome_type varchar(128) not null,
    wdo_outcome_name varchar(128) null,
    wdo_borrower_message varchar(1024) null,
    wdo_lender_description varchar(256) not null,
    wdo_incomplete_outcome bit null,
    wdo_transition_wf_deal_step_pid bigint null,
    constraint wdo_wf_deal_step_pid
        unique (wdo_wf_deal_step_pid),
    constraint fk_wf_deal_outcome_1
        foreign key (wdo_wf_deal_step_pid) references wf_deal_step (wds_pid),
    constraint fk_wf_deal_outcome_2
        foreign key (wdo_transition_wf_deal_step_pid) references wf_deal_step (wds_pid),
    constraint fkt_wdo_wf_outcome_type
        foreign key (wdo_wf_outcome_type) references wf_outcome_type (code)
);

create table wf_deal_step_timeout
(
    wdst_pid bigint auto_increment
        primary key,
    wdst_version int not null,
    wdst_wf_deal_step_pid bigint not null,
    wdst_timeout_datetime datetime not null,
    constraint wdst_wf_deal_step_pid
        unique (wdst_wf_deal_step_pid),
    constraint fk_wf_deal_step_timeout_1
        foreign key (wdst_wf_deal_step_pid) references wf_deal_step (wds_pid)
);

create index idx_wf_deal_step_timeout_1
    on wf_deal_step_timeout (wdst_timeout_datetime);

create table wf_fork_process
(
    wfp_pid bigint auto_increment
        primary key,
    wfp_version int not null,
    wfp_wf_step_pid bigint not null,
    wfp_wf_process_pid bigint not null,
    constraint uk_wf_fork_process_1
        unique (wfp_wf_step_pid, wfp_wf_process_pid),
    constraint fk_wf_fork_process_1
        foreign key (wfp_wf_step_pid) references wf_step (ws_pid),
    constraint fk_wf_fork_process_2
        foreign key (wfp_wf_process_pid) references wf_process (wpr_pid)
);

create table wf_outcome
(
    wo_pid bigint auto_increment
        primary key,
    wo_version int not null,
    wo_wf_step_pid bigint not null,
    wo_wf_outcome_type varchar(128) not null,
    wo_outcome_name varchar(128) null,
    wo_ordinal int null,
    wo_criteria_pid bigint null,
    wo_borrower_message varchar(1024) null,
    wo_lender_description varchar(256) not null,
    wo_incomplete_outcome bit null,
    wo_transition_wf_step_pid bigint null,
    constraint uk_wf_outcome_1
        unique (wo_wf_step_pid, wo_outcome_name),
    constraint fk_wf_outcome_1
        foreign key (wo_wf_step_pid) references wf_step (ws_pid),
    constraint fk_wf_outcome_2
        foreign key (wo_criteria_pid) references criteria (cr_pid),
    constraint fkt_wo_wf_outcome_type
        foreign key (wo_wf_outcome_type) references wf_outcome_type (code)
);

create table wf_step_deal_check
(
    wsdc_pid bigint auto_increment
        primary key,
    wsdc_version int not null,
    wsdc_wf_step_pid bigint not null,
    wsdc_deal_check_type varchar(128) not null,
    wsdc_deal_check_severity_type varchar(128) not null,
    constraint uk_wf_step_deal_check_1
        unique (wsdc_wf_step_pid, wsdc_deal_check_type),
    constraint fk_wf_step_deal_check_1
        foreign key (wsdc_wf_step_pid) references wf_step (ws_pid),
    constraint fkt_wsdc_deal_check_severity_type
        foreign key (wsdc_deal_check_severity_type) references deal_check_severity_type (code),
    constraint fkt_wsdc_deal_check_type
        foreign key (wsdc_deal_check_type) references deal_check_type (code)
);

create table wf_step_deal_check_definition
(
    wsdd_pid bigint auto_increment
        primary key,
    wsdd_version int not null,
    wsdd_wf_step_pid bigint not null,
    wsdd_deal_check_type varchar(128) not null,
    wsdd_deal_check_severity_type varchar(128) not null,
    constraint uk_wf_step_deal_check_definition_1
        unique (wsdd_wf_step_pid, wsdd_deal_check_type),
    constraint fk_wf_step_deal_check_definition_1
        foreign key (wsdd_wf_step_pid) references wf_step (ws_pid),
    constraint fkt_wsdd_deal_check_severity_type
        foreign key (wsdd_deal_check_severity_type) references deal_check_severity_type (code),
    constraint fkt_wsdd_deal_check_type
        foreign key (wsdd_deal_check_type) references deal_check_type (code)
);

create table wf_step_deal_check_dependency
(
    wsdp_pid bigint auto_increment
        primary key,
    wsdp_version int not null,
    wsdp_wf_step_pid bigint not null,
    wsdp_dependency_wf_step_pid bigint not null,
    constraint uk_wf_step_deal_check_dependency_1
        unique (wsdp_wf_step_pid, wsdp_dependency_wf_step_pid),
    constraint fk_wf_step_deal_check_dependency_1
        foreign key (wsdp_wf_step_pid) references wf_step (ws_pid),
    constraint fk_wf_step_deal_check_dependency_2
        foreign key (wsdp_dependency_wf_step_pid) references wf_step (ws_pid)
);

create table wf_step_deal_tag_modifier
(
    wsdt_pid bigint auto_increment
        primary key,
    wsdt_version int not null,
    wsdt_deal_tag_definition_pid bigint not null,
    wsdt_wf_step_pid bigint not null,
    wsdt_add_tag bit null,
    constraint fk_wf_step_deal_tag_modifier_1
        foreign key (wsdt_deal_tag_definition_pid) references deal_tag_definition (dtd_pid),
    constraint fk_wf_step_deal_tag_modifier_2
        foreign key (wsdt_wf_step_pid) references wf_step (ws_pid)
);

create table zip_code_info
(
    zci_pid bigint auto_increment
        primary key,
    zci_version int not null,
    zci_zip_code varchar(5) null,
    zci_latitude decimal(9,6) null,
    zci_longitude decimal(9,6) null,
    constraint zci_zip_code
        unique (zci_zip_code)
);

create table county_zip_code
(
    czc_pid bigint auto_increment
        primary key,
    czc_version int not null,
    czc_county_pid bigint not null,
    czc_zip_code_info_pid bigint not null,
    constraint uk_county_zip_code_1
        unique (czc_county_pid, czc_zip_code_info_pid),
    constraint fk_county_zip_code_1
        foreign key (czc_county_pid) references county (c_pid),
    constraint fk_county_zip_code_2
        foreign key (czc_zip_code_info_pid) references zip_code_info (zci_pid)
);

