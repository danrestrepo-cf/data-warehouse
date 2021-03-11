/*
EDW | Create an Octane schema in staging, should copy the Octane schema minus any sensitive fields (SSN, etc)
https://app.asana.com/0/0/1199681185367867
*/

create table staging_octane.account_event_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.account_id_sequence
(
    ais_id bigint
        primary key
);

create table staging_octane.account_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.account
(
    a_pid bigint
        primary key,
    a_version int null,
    a_account_id bigint null,
    a_account_name varchar(128) null,
    a_gfe_interest_rate_expiration_days int null,
    a_gfe_lock_duration_days int null,
    a_gfe_lock_before_settlement_days int null,
    a_proposal_expiration_days int null,
    a_uw_expiration_days int null,
    a_conditional_commitment_expiration_days int null,
    a_account_from_date date null,
    a_account_status_type varchar(128) null,
    a_account_through_date date null,
    a_initial_los_loan_id bigint null,
    a_uuts_master_contact_name varchar(128) null,
    a_uuts_master_contact_title varchar(128) null,
    a_uuts_master_office_phone varchar(16) null,
    a_uuts_master_office_phone_extension varchar(32) null,
    a_allonge_representative_name varchar(128) null,
    a_allonge_representative_title varchar(128) null,
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
    a_disclosure_change_threshold_cash_to_close decimal(15,2) null,
    a_disclosure_change_threshold_monthly_payment decimal(15,2) null,
    a_disclosure_action_required_days int null,
    a_le_to_cd_seasoning_days int null,
    a_disclosure_max_arm_apr_change_percent decimal(11,9) null,
    a_disclosure_max_non_arm_apr_change_percent decimal(11,9) null,
    a_initial_le_delivered_mailed_seasoning_days int null,
    a_revised_le_delivered_mailed_seasoning_days int null,
    a_revised_le_received_signed_seasoning_days int null,
    a_significant_cd_delivered_mailed_seasoning_days int null,
    a_significant_cd_received_signed_seasoning_days int null,
    a_supported_states text null
);

create table staging_octane.account_event
(
    ae_pid bigint
        primary key,
    ae_version int null,
    ae_account_pid bigint null,
    ae_create_datetime timestamp null,
    ae_account_event_type varchar(128) null,
    ae_detail varchar(16000) null,
    ae_source_unparsed_name varchar(128) null,
    ae_ip_address varchar(32) null,
    ae_client_agent varchar(256) null
);

create index idx_account_event_1
    on staging_octane.account_event (ae_create_datetime);

create index idx_account_event_2
    on staging_octane.account_event (ae_create_datetime, ae_account_event_type, ae_account_pid);

create table staging_octane.admin_user_event_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.admin_user_event
(
    aue_pid bigint
        primary key,
    aue_version int null,
    aue_create_datetime timestamp null,
    aue_detail varchar(16000) null,
    aue_source_unparsed_name varchar(128) null,
    aue_admin_user_event_type varchar(128) null,
    aue_ip_address varchar(32) null,
    aue_client_agent varchar(256) null
);

create table staging_octane.admin_user_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.agency_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.agent_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.announcement
(
    ann_pid bigint
        primary key,
    ann_version int null,
    ann_lender_text varchar(1024) null,
    ann_borrower_text varchar(1024) null,
    ann_from_datetime timestamp null,
    ann_to_datetime timestamp null
);

create table staging_octane.annual_monthly_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.applicant_role_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.application_taken_method_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.application_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.appraisal_condition_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.appraisal_entry_contact_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.appraisal_file_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.appraisal_form_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.appraisal_hold_reason_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.appraisal_hold_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.appraisal_management_company_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.appraisal_order_coarse_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.appraisal_order_request_file_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.appraisal_order_request_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.appraisal_order_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.appraisal_purpose_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.appraisal_source_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.appraisal_underwriter_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.area_median_income_table
(
    amit_pid bigint
        primary key,
    amit_version int null,
    amit_account_pid bigint null,
    amit_from_date date null,
    amit_uploader_unparsed_name varchar(128) null,
    amit_upload_datetime timestamp null
);

create table staging_octane.arm_index_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.arm_index_rate
(
    air_pid bigint
        primary key,
    air_version int null,
    air_arm_index_type varchar(128) null,
    air_effective_datetime timestamp null,
    air_rate decimal(11,9) null
);

create index idx_arm_index_rate_1
    on staging_octane.arm_index_rate (air_arm_index_type);

create index idx_arm_index_rate_2
    on staging_octane.arm_index_rate (air_effective_datetime);

create table staging_octane.asset_account_holder_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.asset_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.aus_credit_service_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.aus_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.backfill_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.bankruptcy_exception_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.bid_pool_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.bid_pool
(
    bp_pid bigint
        primary key,
    bp_version int null,
    bp_account_pid bigint null,
    bp_bid_pool_name varchar(32) null,
    bp_bid_pool_status_type varchar(128) null,
    bp_create_datetime date null
);

create table staging_octane.borrower_associated_address_explanation_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.borrower_associated_address_source_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.borrower_income_category_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.borrower_relationship_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.borrower_residency_basis_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.borrower_tiny_id_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.borrower_user_account_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.borrower_user_deal_access_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.branch_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.building_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.business_disposition_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.business_income_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.business_ownership_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.buydown_base_date_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.buydown_contributor_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.buydown_schedule_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.buydown_subsidy_calculation_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.calendar_rule_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.challenge_question_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.channel_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.channel
(
    ch_pid bigint
        primary key,
    ch_version int null,
    ch_account_pid bigint null,
    ch_id varchar(32) null,
    ch_name varchar(128) null,
    ch_channel_type varchar(128) null
);

create table staging_octane.charge_input_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.charge_payee_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.charge_payer_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.charge_source_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.charge_wire_action_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.circumstance_change_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.citizenship_residency_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.clg_flood_cert_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.closing_document_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.coarse_event_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.community_lending_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.company_admin_event_entity_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.company_admin_event
(
    cae_pid bigint
        primary key,
    cae_version int null,
    cae_account_pid bigint null,
    cae_company_admin_event_entity_type varchar(128) null,
    cae_message varchar(256) null,
    cae_diff_list text null,
    cae_unparsed_name varchar(128) null,
    cae_event_date date null,
    cae_event_datetime timestamp null,
    cae_target_entity_pid bigint null
);

create index idx_company_admin_event_1
    on staging_octane.company_admin_event (cae_event_date);

create table staging_octane.company_state_license_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.config_export_permission_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.construction_cost_category_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.construction_cost_funding_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.construction_cost_payee_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.construction_cost_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.construction_draw_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.construction_draw_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.construction_lot_ownership_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.consumer_privacy_request_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.cost_center
(
    cosc_pid bigint
        primary key,
    cosc_version int null,
    cosc_account_pid bigint null,
    cosc_amb_code varchar(16) null,
    cosc_name varchar(128) null,
    cosc_comments varchar(1024) null,
    cosc_active bit null
);

create table staging_octane.country_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.account_contact
(
    ac_pid bigint
        primary key,
    ac_version int null,
    ac_account_pid bigint null,
    ac_unparsed_name varchar(128) null,
    ac_note varchar(256) null,
    ac_search_text varchar(256) null,
    ac_tags varchar(256) null,
    ac_first_name varchar(32) null,
    ac_middle_name varchar(32) null,
    ac_last_name varchar(32) null,
    ac_name_suffix varchar(32) null,
    ac_company_name varchar(128) null,
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
    ac_address_country varchar(128) null,
    ac_home_phone varchar(32) null,
    ac_closing_document_email varchar(256) null,
    ac_license_number varchar(128) null,
    ac_supervisory_license_number varchar(128) null,
    ac_license_state varchar(128) null
);

create table staging_octane.courier_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.credit_authorization_method_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.credit_bureau_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.credit_business_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.credit_inquiry_explanation_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.credit_inquiry_result_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.credit_limit_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.credit_loan_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.credit_report_request_action_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.credit_report_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.credit_request_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.credit_request_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.credit_request_via_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.credit_score_model_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.criteria
(
    cr_pid bigint
        primary key,
    cr_version int null,
    cr_account_pid bigint null,
    cr_criteria_source varchar(16000) null,
    cr_criteria_sql varchar(16000) null,
    cr_criteria_owner_instance_name varchar(2048) null,
    cr_criteria_source_html text null,
    cr_criteria_source_pretty_text text null
);

create table staging_octane.criteria_owner_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.criteria_pid_operand_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.custodian
(
    cu_pid bigint
        primary key,
    cu_version int null,
    cu_account_pid bigint null,
    cu_custodian_id varchar(32) null,
    cu_custodian_name varchar(128) null,
    cu_address_street1 varchar(128) null,
    cu_address_street2 varchar(128) null,
    cu_address_city varchar(128) null,
    cu_address_state varchar(128) null,
    cu_address_postal_code varchar(128) null,
    cu_address_country varchar(128) null,
    cu_custodian_phone varchar(32) null,
    cu_custodian_mers_org_id varchar(7) null,
    cu_whole_loan_fin varchar(11) null,
    cu_mbs_loan_fin varchar(11) null,
    cu_register_with_mers bit null
);

create table staging_octane.days_per_year_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_cancel_reason_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_change_updater_time
(
    dcut_pid bigint
        primary key,
    dcut_version int null,
    dcut_account_pid bigint null,
    dcut_los_loan_id_main bigint null,
    dcut_start_time timestamp null,
    dcut_start_date date null,
    dcut_overall_duration_ms bigint null,
    dcut_deal_checks_ms bigint null,
    dcut_deal_updates_ms bigint null,
    dcut_proposal_updates_ms bigint null,
    dcut_num_proposal_updates int null,
    dcut_application_updates_ms bigint null,
    dcut_num_application_updates int null,
    dcut_borrower_updates_ms bigint null,
    dcut_num_borrower_updates int null,
    dcut_place_updates_ms bigint null,
    dcut_num_place_updates int null,
    dcut_loan_updates_ms bigint null,
    dcut_num_loan_updates int null,
    dcut_proposal_updates_after_loan_updates_ms bigint null,
    dcut_updates_after_proposal_updates_ms bigint null,
    dcut_proposal_summary_updates_ms bigint null,
    dcut_deal_updates_after_all_proposal_updates_ms bigint null,
    dcut_smart_charge_update_ms bigint null,
    dcut_circumstance_change_updates_ms bigint null,
    dcut_num_circumstance_change_updates int null,
    dcut_tolerance_cure_update_ms bigint null,
    dcut_proposal_summary_updates_after_smart_charge_updates_ms bigint null,
    dcut_update_doc_sets_ms bigint null,
    dcut_closing_funds_itemization_ms bigint null,
    dcut_update_ribbon_for_deal_ms bigint null,
    dcut_num_construction_draw_updates int null,
    dcut_construction_draw_updates_ms bigint null
);

create index idx_deal_change_updater_time_1
    on staging_octane.deal_change_updater_time (dcut_start_time);

create index idx_deal_change_updater_time_2
    on staging_octane.deal_change_updater_time (dcut_start_date);

create table staging_octane.deal_check_severity_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_check_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_child_relationship_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_child_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.criteria_snippet
(
    crs_pid bigint
        primary key,
    crs_version int null,
    crs_account_pid bigint null,
    crs_name varchar(35) null,
    crs_criteria_pid bigint null,
    crs_description varchar(16000) null,
    crs_deal_child_type varchar(128) null,
    crs_compatible_with_smart_charge_case bit null,
    crs_compatible_with_smart_req bit null,
    crs_compatible_with_stack_separator bit null,
    crs_compatible_with_investor_eligibility bit null,
    crs_compatible_with_wf_smart_task bit null,
    crs_compatible_with_wf_outcome bit null,
    crs_compatible_with_wf_smart_process bit null,
    crs_compatible_with_smart_doc_criteria bit null
);

create table staging_octane.deal_contact_role_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_context_permission_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_create_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_event_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_id_sequence
(
    dis_id bigint
        primary key
);

create table staging_octane.deal_invoice_file_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_invoice_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_note_scope_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_orphan_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_stage_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_tag_access_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_tag_level_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.deal_tag_definition
(
    dtd_pid bigint
        primary key,
    dtd_version int null,
    dtd_account_pid bigint null,
    dtd_tag_name varchar(32) null,
    dtd_deal_tag_level_type varchar(128) null,
    dtd_deal_tag_access_type varchar(128) null
);

create table staging_octane.deal_task_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.decision_credit_score_calc_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.delivery_aus_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.disaster_declaration_check_date_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.doc_action_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.doc_approval_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.doc_borrower_access_mode_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.doc_category_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.doc_external_provider_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.doc_file_source_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.doc_fulfill_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.doc_key_date_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.doc_level_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.doc_package_canceled_reason_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.doc_package_delivery_method_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.doc_package_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.doc_permission_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.doc_set_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.doc_validity_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.document_import_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.document_import_vendor_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.du_key_finding_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.du_recommendation_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.du_request_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.dw_export_request_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.ecoa_denial_reason_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.effective_property_value_explanation_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.effective_property_value_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.email_closing_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.ernst_deed_request_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.ernst_page_rec_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.ernst_request_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.ernst_security_instrument_request_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.esign_package_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.esign_vendor_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.export_permission_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.export_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.external_entity_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fault_tolerant_event_registration
(
    fter_message_id varchar(128) null
        primary key,
    fter_queue_name varchar(128) null,
    fter_event_type varchar(128) null,
    fter_create_datetime timestamp null,
    fter_processed_datetime timestamp null
);

create table staging_octane.fema_flood_zone_designation_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fha_non_arms_length_ltv_limit_exception_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fha_program_code_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fha_rehab_program_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fha_special_program_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fha_va_bor_cert_sales_price_exceeds_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.field_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.flood_cert_vendor_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.flood_certificate_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fnm_arm_plan_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fnm_community_lending_product_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fnm_community_seconds_repayment_structure_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fnm_investor_remittance_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fnm_mbs_loan_default_loss_party_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fnm_mbs_reo_marketing_party_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.for_further_credit_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fre_community_program_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fre_ctp_closing_feature_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fre_ctp_closing_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fre_doc_level_description_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fre_purchase_eligibility_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.fund_source_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.funding_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null,
    fst_ordinal int null
);

create table staging_octane.gender_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.gift_funds_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.account_grant_program
(
    agp_pid bigint
        primary key,
    agp_version int null,
    agp_account_pid bigint null,
    agp_from_date date null,
    agp_through_date date null,
    agp_program_id varchar(32) null,
    agp_program_name varchar(128) null,
    agp_program_funds_type varchar(128) null,
    agp_donor_name varchar(128) null,
    agp_donor_phone varchar(32) null,
    agp_address_street1 varchar(128) null,
    agp_address_street2 varchar(128) null,
    agp_address_city varchar(128) null,
    agp_address_state varchar(128) null,
    agp_address_postal_code varchar(128) null,
    agp_address_country varchar(128) null,
    agp_ein varchar(10) null,
    agp_wire_action_type varchar(128) null,
    agp_notes varchar(1024) null
);

create table staging_octane.gse_version_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.heloc_cancel_fee_applicable_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.hmda_action_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.hmda_agency_id_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.hmda_denial_reason_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.hmda_ethnicity_2017_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.hmda_hoepa_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.hmda_purchaser_of_loan_2017_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.hmda_purchaser_of_loan_2018_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.hmda_race_2017_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.hoepa_thresholds
(
    ht_pid bigint
        primary key,
    ht_version int null,
    ht_effective_date date null,
    ht_total_loan_amount_threshold decimal(15) null,
    ht_points_and_fees_threshold_amount decimal(15) null,
    ht_first_lien_rate_spread_threshold decimal(11,9) null,
    ht_subordinate_lien_rate_spread_threshold decimal(11,9) null,
    ht_max_points_and_fees_percent_over_threshold decimal(11,9) null,
    ht_max_points_and_fees_percent_under_threshold decimal(11,9) null
);

create table staging_octane.homeownership_education_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.housing_counseling_agency_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.housing_counseling_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.hud_fha_de_approval_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.hve_confidence_level_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.income_history_calc_method_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.intent_to_proceed_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.interest_only_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.interim_funder_mers_registration_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.interim_funder
(
    if_pid bigint
        primary key,
    if_version int null,
    if_account_pid bigint null,
    if_company_name varchar(128) null,
    if_company_contact_unparsed_name varchar(128) null,
    if_company_address_street1 varchar(128) null,
    if_company_address_street2 varchar(128) null,
    if_company_address_city varchar(128) null,
    if_company_address_state varchar(128) null,
    if_company_address_postal_code varchar(128) null,
    if_company_address_country varchar(128) null,
    if_company_office_phone varchar(32) null,
    if_company_office_phone_extension varchar(16) null,
    if_company_email varchar(256) null,
    if_company_fax varchar(32) null,
    if_company_mers_org_id varchar(7) null,
    if_remarks varchar(1024) null,
    if_from_date date null,
    if_through_date date null,
    if_custodian_pid bigint null,
    if_reimbursement_wire_credit_to_name varchar(128) null,
    if_reimbursement_wire_attention_unparsed_name varchar(128) null,
    if_reimbursement_wire_authorized_signer_unparsed_name varchar(128) null,
    if_return_wire_credit_to_name varchar(128) null,
    if_return_wire_attention_unparsed_name varchar(128) null,
    if_return_wire_authorized_signer_unparsed_name varchar(128) null,
    if_fnm_payee_id varchar(9) null,
    if_interim_funder_mers_registration_type varchar(128) null,
    if_fnm_warehouse_lender_id varchar(32) null,
    if_fre_warehouse_lender_id varchar(32) null,
    if_funder_id varchar(32) null
);

create table staging_octane.credit_limit
(
    cl_pid bigint
        primary key,
    cl_version int null,
    cl_interim_funder_pid bigint null,
    cl_credit_limit_name varchar(128) null,
    cl_credit_limit_amount decimal(15,2) null,
    cl_credit_limit_type varchar(128) null,
    cl_from_date date null,
    cl_through_date date null
);

create table staging_octane.investor_group
(
    ig_pid bigint
        primary key,
    ig_version int null,
    ig_account_pid bigint null,
    ig_name varchar(128) null,
    ig_lender_group bit null
);

create table staging_octane.investor_hmda_purchaser_of_loan_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.investor_lock_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.invoice_item_category_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.invoice_payer_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.invoice_payment_submission_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.ipc_calc_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.ipc_comparison_operator_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.ipc_property_usage_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.job_gap_reason_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.key_creditor_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.key_doc_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.key_package_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.key_role_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lava_zone_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.legacy_role_assignment_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.legal_description_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.legal_entity_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lender_concession_request_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lender_concession_request_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lender_lock_id_ticker
(
    lltk_pid bigint
        primary key,
    lltk_version int null,
    lltk_account_pid bigint null,
    lltk_next_lender_lock_id bigint null
);

create table staging_octane.lender_lock_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lender_toolbox_permission_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lender_trade_id_ticker
(
    lttk_pid bigint
        primary key,
    lttk_version int null,
    lttk_account_pid bigint null,
    lttk_next_lender_trade_id bigint null
);

create table staging_octane.lender_user_allowed_ip_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lender_user_interest
(
    lui_pid bigint
        primary key,
    lui_version int null,
    lui_lender_user_pid bigint null,
    lui_lender_user_interest_type varchar(128) null
);

create table staging_octane.lender_user_interest_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lender_user_language
(
    lul_pid bigint
        primary key,
    lul_version int null,
    lul_lender_user_pid bigint null,
    lul_lender_user_language_type varchar(128) null
);

create table staging_octane.lender_user_language_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lender_user_notice_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lender_user_reset_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lender_user_role_queue_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lender_user_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lender_user_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.liability_account_ownership_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.liability_account_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.liability_current_rating_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.liability_disposition_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.liability_energy_related_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.liability_financing_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.liability_foreclosure_exception_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.liability_mi_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.liability_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.license_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lien_priority_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.loan_access_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.loan_amortization_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.apor
(
    ap_pid bigint
        primary key,
    ap_version int null,
    ap_as_of_date date null,
    ap_loan_amortization_type varchar(128) null,
    ap_term_years int null,
    ap_apor_percent decimal(11,9) null
);

create index idx_apor_1
    on staging_octane.apor (ap_as_of_date);

create table staging_octane.loan_benef_transfer_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.loan_file_delivery_method_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.loan_limit_table_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.loan_limit_table
(
    llt_pid bigint
        primary key,
    llt_version int null,
    llt_account_pid bigint null,
    llt_from_date date null,
    llt_loan_limit_table_type varchar(128) null,
    llt_uploader_unparsed_name varchar(128) null,
    llt_upload_datetime timestamp null
);

create table staging_octane.loan_limit_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.loan_position_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.loan_purpose_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.loan_safe_product_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.loans_toolbox_permission_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lock_add_on_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lock_commitment_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lock_extension_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lock_term_setting
(
    lts_pid bigint
        primary key,
    lts_version int null,
    lts_account_pid bigint null,
    lts_lock_duration_days int null,
    lts_lock_commitment_type varchar(128) null,
    lts_borrower_app_enabled bit null
);

create table staging_octane.los_loan_id_ticker
(
    ltk_pid bigint
        primary key,
    ltk_version int null,
    ltk_account_pid bigint null,
    ltk_next_los_loan_id bigint null
);

create table staging_octane.lp_case_state_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lp_credit_risk_classification_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lp_dtd_version_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lp_evaluation_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lp_finding_message_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lp_interface_version_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lp_request_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lp_submission_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lqa_purchase_eligibility_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lura_file_repository_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.lura_setting_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.manufactured_home_certificate_of_title_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.manufactured_home_leasehold_property_interest_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.manufactured_home_loan_purpose_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.marital_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.master_property_insurance_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mcr_loan_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mercury_client_group
(
    mcg_pid bigint
        primary key,
    mcg_version int null,
    mcg_account_pid bigint null,
    mcg_mercury_client_group_name varchar(1024) null,
    mcg_mercury_client_group_id int null,
    mcg_active bit null
);

create table staging_octane.mercury_network_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mers_daily_report_import_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mers_registration_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mers_transfer_batch
(
    metb_pid bigint
        primary key,
    metb_version int null,
    metb_account_pid bigint null,
    metb_create_datetime timestamp null,
    metb_sent_datetime timestamp null,
    metb_batch_id varchar(32) null
);

create table staging_octane.mers_transfer_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mi_calculated_rate_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mi_company_name_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mi_initial_calculation_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mi_input_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mi_integration_request_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mi_integration_vendor_request_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mi_payer_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mi_payment_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mi_premium_refundable_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mi_renewal_calculation_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mi_submission_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.military_branch_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.military_service_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.military_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mismo_version_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mortech_account
(
    ma_pid bigint
        primary key,
    ma_version int null,
    ma_account_pid bigint null,
    ma_name varchar(128) null,
    ma_mortech_customer_id varchar(128) null
);

create table staging_octane.lead_source
(
    lds_pid bigint
        primary key,
    lds_version int null,
    lds_account_pid bigint null,
    lds_channel_pid bigint null,
    lds_lead_source_name varchar(128) null,
    lds_mortech_lead_source_id varchar(16) null,
    lds_lead_source_id varchar(32) null,
    lds_active bit null,
    lds_lead_id_required bit null,
    lds_zero_margin_allowed bit null,
    lds_mortech_account_pid bigint null,
    lds_training_only bit null
);

create table staging_octane.lead_campaign
(
    ldc_pid bigint
        primary key,
    ldc_version int null,
    ldc_account_pid bigint null,
    ldc_lead_source_pid bigint null,
    ldc_campaign_id varchar(32) null,
    ldc_campaign_name varchar(128) null,
    ldc_velocify_campaign_title varchar(32) null
);

create table staging_octane.lead_supplemental_margin_table
(
    lsmt_pid bigint
        primary key,
    lsmt_version int null,
    lsmt_lead_source_pid bigint null,
    lsmt_effective_datetime timestamp null
);

create table staging_octane.lead_supplemental_margin_row
(
    lsmr_pid bigint
        primary key,
    lsmr_version int null,
    lsmr_lead_supplemental_margin_table_pid bigint null,
    lsmr_over_anchor_rate_percent decimal(11,9) null,
    lsmr_company_supplemental_margin_percent decimal(11,9) null,
    lsmr_branch_supplemental_margin_percent decimal(11,9) null
);

create table staging_octane.mortgage_credit_certificate_issuer
(
    mcci_pid bigint
        primary key,
    mcci_version int null,
    mcci_account_pid bigint null,
    mcci_from_date date null,
    mcci_through_date date null,
    mcci_issuer_name varchar(128) null,
    mcci_credit_rate_percent decimal(11,9) null,
    mcci_ein varchar(10) null,
    mcci_contact_name varchar(128) null,
    mcci_contact_phone varchar(128) null,
    mcci_address_street1 varchar(128) null,
    mcci_address_street2 varchar(128) null,
    mcci_address_city varchar(128) null,
    mcci_address_state varchar(128) null,
    mcci_address_postal_code varchar(128) null,
    mcci_contact_email varchar(256) null,
    mcci_web_url varchar(256) null,
    mcci_notes varchar(1024) null
);

create table staging_octane.mortgage_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.native_american_lands_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.negative_amortization_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.neighborhood_location_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.net_tangible_benefit_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.nfip_community_participation_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.obligation_amount_input_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.obligation_charge_input_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.obligation_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.offering_group
(
    ofg_pid bigint
        primary key,
    ofg_version int null,
    ofg_account_pid bigint null,
    ofg_name varchar(128) null
);

create table staging_octane.offering
(
    of_pid bigint
        primary key,
    of_version int null,
    of_account_pid bigint null,
    of_offering_name varchar(128) null,
    of_offering_id varchar(32) null,
    of_from_date date null,
    of_through_date date null,
    of_mortech_product_id varchar(16) null,
    of_offering_group_pid bigint null,
    of_adverse_action_offering bit null
);

create table staging_octane.org_division
(
    orgd_pid bigint
        primary key,
    orgd_version int null,
    orgd_account_pid bigint null,
    orgd_latest_level_name varchar(128) null,
    orgd_active bit null
);

create table staging_octane.org_division_terms
(
    orgdt_pid bigint
        primary key,
    orgdt_version int null,
    orgdt_org_division_pid bigint null,
    orgdt_from_date date null,
    orgdt_through_date date null,
    orgdt_level_name varchar(128) null,
    orgdt_level_cost_center_pid bigint null,
    orgdt_beneficiary_cost_center_pid bigint null,
    orgdt_guarantor_cost_center_pid bigint null
);

create table staging_octane.org_group
(
    orgg_pid bigint
        primary key,
    orgg_version int null,
    orgg_account_pid bigint null,
    orgg_latest_level_name varchar(128) null,
    orgg_active bit null
);

create table staging_octane.org_group_terms
(
    orggt_pid bigint
        primary key,
    orggt_version int null,
    orggt_org_division_pid bigint null,
    orggt_org_group_pid bigint null,
    orggt_from_date date null,
    orggt_through_date date null,
    orggt_level_name varchar(128) null,
    orggt_level_cost_center_pid bigint null,
    orggt_beneficiary_cost_center_pid bigint null,
    orggt_guarantor_cost_center_pid bigint null
);

create table staging_octane.org_leader_position_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.org_region
(
    orgr_pid bigint
        primary key,
    orgr_version int null,
    orgr_account_pid bigint null,
    orgr_latest_level_name varchar(128) null,
    orgr_active bit null
);

create table staging_octane.org_region_terms
(
    orgrt_pid bigint
        primary key,
    orgrt_version int null,
    orgrt_org_group_pid bigint null,
    orgrt_org_region_pid bigint null,
    orgrt_from_date date null,
    orgrt_through_date date null,
    orgrt_level_name varchar(128) null,
    orgrt_level_cost_center_pid bigint null,
    orgrt_beneficiary_cost_center_pid bigint null,
    orgrt_guarantor_cost_center_pid bigint null
);

create table staging_octane.org_team
(
    orgt_pid bigint
        primary key,
    orgt_version int null,
    orgt_account_pid bigint null,
    orgt_latest_level_name varchar(128) null,
    orgt_individual_pl_owner bit null,
    orgt_admin_team bit null,
    orgt_active bit null
);

create table staging_octane.org_unit
(
    orgu_pid bigint
        primary key,
    orgu_version int null,
    orgu_account_pid bigint null,
    orgu_latest_level_name varchar(128) null,
    orgu_active bit null
);

create table staging_octane.org_team_terms
(
    orgtt_pid bigint
        primary key,
    orgtt_version int null,
    orgtt_org_unit_pid bigint null,
    orgtt_org_team_pid bigint null,
    orgtt_from_date date null,
    orgtt_through_date date null,
    orgtt_level_name varchar(128) null,
    orgtt_level_cost_center_pid bigint null,
    orgtt_beneficiary_cost_center_pid bigint null,
    orgtt_guarantor_cost_center_pid bigint null
);

create table staging_octane.org_unit_terms
(
    orgut_pid bigint
        primary key,
    orgut_version int null,
    orgut_org_region_pid bigint null,
    orgut_org_unit_pid bigint null,
    orgut_from_date date null,
    orgut_through_date date null,
    orgut_level_name varchar(128) null,
    orgut_level_cost_center_pid bigint null,
    orgut_beneficiary_cost_center_pid bigint null,
    orgut_guarantor_cost_center_pid bigint null
);

create table staging_octane.origination_source_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.other_income_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.partial_payment_policy_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.payment_adjustment_calculation_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.payment_frequency_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.payment_fulfill_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.payment_processing_company_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.payment_request_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.payment_structure_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.payment_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.payoff_request_delivery_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.performer_team
(
    ptm_pid bigint
        primary key,
    ptm_version int null,
    ptm_account_pid bigint null,
    ptm_name varchar(128) null
);

create table staging_octane.polling_interval_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.prepaid_interest_rate_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.prepay_penalty_schedule_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.prepay_penalty_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.price_processing_time
(
    ppt_pid bigint
        primary key,
    ppt_version int null,
    ppt_account_pid bigint null,
    ppt_los_loan_id_main bigint null,
    ppt_start_time timestamp null,
    ppt_start_date date null,
    ppt_overall_duration_ms bigint null,
    ppt_pre_mortech_time_ms bigint null,
    ppt_post_mortech_time_ms bigint null,
    ppt_num_of_mortech_requests int null,
    ppt_mortech_request_url_1 text null,
    ppt_mortech_request_start_time_1 timestamp null,
    ppt_mortech_request_time_ms_1 bigint null,
    ppt_mortech_request_url_2 text null,
    ppt_mortech_request_start_time_2 timestamp null,
    ppt_mortech_request_time_ms_2 bigint null,
    ppt_mortech_request_url_3 text null,
    ppt_mortech_request_start_time_3 timestamp null,
    ppt_mortech_request_time_ms_3 bigint null,
    ppt_mortech_request_url_4 text null,
    ppt_mortech_request_start_time_4 timestamp null,
    ppt_mortech_request_time_ms_4 bigint null,
    ppt_mortech_request_url_5 text null,
    ppt_mortech_request_start_time_5 timestamp null,
    ppt_mortech_request_time_ms_5 bigint null,
    ppt_mortech_request_url_6 text null,
    ppt_mortech_request_start_time_6 timestamp null,
    ppt_mortech_request_time_ms_6 bigint null,
    ppt_mortech_request_url_7 text null,
    ppt_mortech_request_start_time_7 timestamp null,
    ppt_mortech_request_time_ms_7 bigint null,
    ppt_mortech_request_url_8 text null,
    ppt_mortech_request_start_time_8 timestamp null,
    ppt_mortech_request_time_ms_8 bigint null
);

create index idx_price_processing_time_1
    on staging_octane.price_processing_time (ppt_start_time);

create index idx_price_processing_time_2
    on staging_octane.price_processing_time (ppt_start_date);

create table staging_octane.pricing_engine_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.prior_property_title_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.prior_to_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.product_appraisal_requirement_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.product_rule_domain_input_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.product_side_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.product_special_program_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.profit_margin_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.project_classification_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.project_design_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.property_category_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.property_repairs_holdback_calc_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.property_repairs_holdback_payer_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.property_repairs_required_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.property_rights_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.property_usage_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.proposal_doc_file_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.proposal_review_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.proposal_structure_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.proposal_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.pte_request_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.pte_response_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.public_record_disposition_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.public_record_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.qualified_mortgage_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.qualified_mortgage_thresholds
(
    qmt_pid bigint
        primary key,
    qmt_version int null,
    qmt_effective_date date null,
    qmt_first_total_loan_amount_threshold decimal(15) null,
    qmt_first_points_and_fees_threshold_percent decimal(11,9) null,
    qmt_second_total_loan_amount_threshold decimal(15) null,
    qmt_second_points_and_fees_threshold_amount decimal(15) null,
    qmt_third_total_loan_amount_threshold decimal(15) null,
    qmt_third_points_and_fees_threshold_percent decimal(11,9) null,
    qmt_fourth_total_loan_amount_threshold decimal(15) null,
    qmt_fourth_points_and_fees_threshold_amount decimal(15) null,
    qmt_ceiling_points_and_fees_threshold_percent decimal(11,9) null
);

create table staging_octane.qualifying_monthly_payment_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.qualifying_rate_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.quarter_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.mcr_snapshot
(
    mcrs_pid bigint
        primary key,
    mcrs_version int null,
    mcrs_account_pid bigint null,
    mcrs_year int null,
    mcrs_quarter_type varchar(128) null
);

create table staging_octane.mcr_loan
(
    mcrl_pid bigint
        primary key,
    mcrl_version int null,
    mcrl_loan_pid bigint null,
    mcrl_mcr_snapshot_pid bigint null,
    mcrl_los_loan_id bigint null,
    mcrl_originator_nmls_id varchar(16) null,
    mcrl_loan_amount decimal(15,2) null,
    mcrl_lien_priority_type varchar(128) null,
    mcrl_mortgage_type varchar(128) null,
    mcrl_interest_only_type varchar(128) null,
    mcrl_prepay_penalty_schedule_type varchar(128) null,
    mcrl_ltv_ratio_percent decimal(11,9) null,
    mcrl_note_rate_percent decimal(11,9) null,
    mcrl_hmda_action_type varchar(128) null,
    mcrl_hmda_action_date date null,
    mcrl_disclosure_mode_date date null,
    mcrl_decision_credit_score int null,
    mcrl_property_usage_type varchar(128) null,
    mcrl_doc_level_type varchar(128) null,
    mcrl_loan_purpose_type varchar(128) null,
    mcrl_mi_required bit null,
    mcrl_proposal_structure_type varchar(128) null,
    mcrl_subject_property_state varchar(128) null,
    mcrl_property_category_type varchar(128) null,
    mcrl_cltv_ratio_percent decimal(11,9) null,
    mcrl_funding_status_type varchar(128) null,
    mcrl_funding_date date null,
    mcrl_loan_amortization_type varchar(128) null,
    mcrl_product_special_program_type varchar(128) null,
    mcrl_non_conforming bit null,
    mcrl_initial_payment_adjustment_term_months int null,
    mcrl_subsequent_payment_adjustment_term_months int null,
    mcrl_fund_source_type varchar(128) null,
    mcrl_channel_type varchar(128) null,
    mcrl_financed_units_count int null,
    mcrl_cash_out_reason_home_improvement bit null,
    mcrl_hmda_hoepa_status_type varchar(128) null,
    mcrl_qualified_mortgage_status_type varchar(128) null,
    mcrl_lender_fee_total_amount decimal(15,2) null,
    mcrl_broker_fee_total_amount decimal(15,2) null,
    mcrl_investor_hmda_purchaser_of_loan_type varchar(128) null,
    mcrl_confirmed_release_datetime timestamp null,
    mcrl_purchase_advice_date date null,
    mcrl_purchasing_beneficiary_investor_pid bigint null,
    mcrl_mcr_loan_status_type varchar(128) null
);

create table staging_octane.quote_filter_pivot_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.realty_agent_scenario_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.recording_district_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.refinance_improvements_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.relock_fee_setting
(
    rfs_pid bigint
        primary key,
    rfs_version int null,
    rfs_account_pid bigint null,
    rfs_from_date date null,
    rfs_relock_fee_percent decimal(11,9) null
);

create table staging_octane.reo_disposition_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.report_request_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.report_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.report
(
    rp_pid bigint
        primary key,
    rp_version int null,
    rp_account_pid bigint null,
    rp_name varchar(128) null,
    rp_description varchar(1024) null,
    rp_report_type varchar(128) null,
    rp_report_row_pid bigint null,
    rp_criteria_pid bigint null,
    rp_accessible_only bit null,
    rp_analysis_report bit null,
    rp_publish bit null,
    rp_test_data_report bit null,
    rp_allow_view bit null,
    rp_allow_excel_export bit null
);

create table staging_octane.report_row
(
    rprw_pid bigint
        primary key,
    rprw_version int null,
    rprw_account_pid bigint null,
    rprw_report_type varchar(128) null,
    rprw_name varchar(128) null,
    rprw_description varchar(1024) null,
    rprw_formula_row bit null
);

create table staging_octane.formula_report_column
(
    frc_pid bigint
        primary key,
    frc_version int null,
    frc_report_row_pid bigint null,
    frc_header varchar(128) null,
    frc_formula varchar(1024) null,
    frc_field_type_1 varchar(128) null,
    frc_field_type_2 varchar(128) null,
    frc_field_type_3 varchar(128) null,
    frc_field_type_4 varchar(128) null,
    frc_field_type_5 varchar(128) null,
    frc_field_type_6 varchar(128) null,
    frc_ordinal int null
);

create table staging_octane.report_column
(
    rpc_pid bigint
        primary key,
    rpc_version int null,
    rpc_report_row_pid bigint null,
    rpc_report_column_type varchar(128) null,
    rpc_ordinal int null
);

create table staging_octane.req_decision_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.req_fulfill_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.rescission_notification_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.respa_section_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.charge_type
(
    code varchar(128) null
        primary key,
    ct_respa_section_type varchar(128) null,
    value varchar(1024) null
);

create table staging_octane.road_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.role
(
    r_pid bigint
        primary key,
    r_version int null,
    r_account_pid bigint null,
    r_role_name varchar(32) null,
    r_borrower_viewable bit null,
    r_loan_access_type varchar(128) null,
    r_internal bit null,
    r_training_applicable bit null
);

create table staging_octane.key_role
(
    kr_pid bigint
        primary key,
    kr_version int null,
    kr_role_pid bigint null,
    kr_account_pid bigint null,
    kr_key_role_type varchar(128) null
);

create table staging_octane.role_charge_permissions
(
    rcp_pid bigint
        primary key,
    rcp_version int null,
    rcp_role_pid bigint null,
    rcp_charge_type varchar(128) null,
    rcp_basic_editable bit null,
    rcp_financed_editable bit null,
    rcp_payer_non_lender_editable bit null,
    rcp_payer_lender_editable bit null,
    rcp_payee_editable bit null,
    rcp_apr_editable bit null,
    rcp_poc_editable bit null,
    rcp_wire_editable bit null
);

create table staging_octane.role_config_export_permission
(
    rcep_pid bigint
        primary key,
    rcep_version int null,
    rcep_role_pid bigint null,
    rcep_config_export_permission_type varchar(128) null
);

create table staging_octane.role_deal_context
(
    rdc_pid bigint
        primary key,
    rdc_version int null,
    rdc_role_pid bigint null,
    rdc_deal_context_permission_type varchar(128) null
);

create table staging_octane.role_export_permission
(
    rep_pid bigint
        primary key,
    rep_version int null,
    rep_role_pid bigint null,
    rep_export_permission_type varchar(128) null
);

create table staging_octane.role_lender_toolbox
(
    rlet_pid bigint
        primary key,
    rlet_version int null,
    rlet_role_pid bigint null,
    rlet_lender_toolbox_permission_type varchar(128) null
);

create table staging_octane.role_loans_toolbox
(
    rlot_pid bigint
        primary key,
    rlot_version int null,
    rlot_role_pid bigint null,
    rlot_loans_toolbox_permission_type varchar(128) null
);

create table staging_octane.role_performer_assign
(
    rpa_pid bigint
        primary key,
    rpa_version int null,
    rpa_role_pid bigint null,
    rpa_assignee_role_pid bigint null
);

create table staging_octane.role_report
(
    rrp_pid bigint
        primary key,
    rrp_version int null,
    rrp_report_pid bigint null,
    rrp_role_pid bigint null
);

create table staging_octane.sanitation_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.sap_step_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.secondary_admin_event_entity_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.secondary_admin_event
(
    sae_pid bigint
        primary key,
    sae_version int null,
    sae_account_pid bigint null,
    sae_secondary_admin_event_entity_type varchar(128) null,
    sae_message varchar(256) null,
    sae_diff_list text null,
    sae_unparsed_name varchar(128) null,
    sae_event_date date null,
    sae_event_datetime timestamp null,
    sae_target_entity_pid bigint null
);

create index idx_secondary_admin_event_1
    on staging_octane.secondary_admin_event (sae_event_date);

create table staging_octane.section_of_act_coarse_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.security_instrument_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.senior_lien_restriction_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.servicer_loan_id_assign_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.servicer_loan_id_import_request_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.servicing_transfer_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.settlement_agent
(
    sa_pid bigint
        primary key,
    sa_version int null,
    sa_account_pid bigint null,
    sa_active bit null,
    sa_admin_lock bit null,
    sa_license_id varchar(128) null,
    sa_company_name varchar(128) null,
    sa_preferred_vendor bit null
);

create table staging_octane.settlement_agent_office
(
    sao_pid bigint
        primary key,
    sao_version int null,
    sao_settlement_agent_pid bigint null,
    sao_active bit null,
    sao_address_street1 varchar(128) null,
    sao_address_street2 varchar(128) null,
    sao_address_city varchar(128) null,
    sao_address_state varchar(128) null,
    sao_address_postal_code varchar(128) null,
    sao_address_country varchar(128) null,
    sao_phone varchar(32) null,
    sao_fax varchar(32) null,
    sao_docs_email varchar(256) null,
    sao_fund_email varchar(256) null,
    sao_schedule_email varchar(256) null
);

create table staging_octane.settlement_agent_wire
(
    saw_pid bigint
        primary key,
    saw_version int null,
    saw_settlement_agent_pid bigint null,
    saw_active bit null,
    saw_create_datetime timestamp null,
    saw_bank_name varchar(128) null,
    saw_address_street1 varchar(128) null,
    saw_address_street2 varchar(128) null,
    saw_address_city varchar(128) null,
    saw_address_state varchar(128) null,
    saw_address_postal_code varchar(128) null,
    saw_address_country varchar(128) null,
    saw_for_credit_to varchar(256) null,
    saw_for_further_credit_fixed_text varchar(256) null,
    saw_for_further_credit_prompt_text varchar(256) null,
    saw_verified_from_date date null,
    saw_verified_through_date date null,
    saw_verifier varchar(128) null,
    saw_notes varchar(1024) null,
    saw_for_further_credit_type varchar(128) null,
    saw_beneficiary_bank_name varchar(128) null,
    saw_beneficiary_address_street1 varchar(128) null,
    saw_beneficiary_address_street2 varchar(128) null,
    saw_beneficiary_address_city varchar(128) null,
    saw_beneficiary_address_state varchar(128) null,
    saw_beneficiary_address_postal_code varchar(128) null,
    saw_beneficiary_address_country varchar(128) null,
    saw_beneficiary_for_credit_to varchar(256) null,
    saw_beneficiary_for_further_credit_fixed_text varchar(256) null,
    saw_beneficiary_for_further_credit_prompt_text varchar(256) null,
    saw_beneficiary_for_further_credit_type varchar(128) null,
    saw_beneficiary_notes varchar(1024) null
);

create table staging_octane.sheet_format_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.google_sheet_export
(
    gse_pid bigint
        primary key,
    gse_version int null,
    gse_name varchar(128) null,
    gse_account_pid bigint null,
    gse_export_type varchar(128) null,
    gse_stored_query_name varchar(128) null,
    gse_spreadsheet_id varchar(128) null,
    gse_control_sheet_id varchar(128) null,
    gse_results_sheet_id varchar(128) null,
    gse_cron_expression varchar(32) null,
    gse_format_type varchar(128) null
);

create table staging_octane.signature_part_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.site_allowed_ip
(
    saip_pid bigint
        primary key,
    saip_version int null,
    saip_account_pid bigint null,
    saip_name varchar(128) null,
    saip_ip_address varchar(32) null
);

create index idx_site_allowed_ip_1
    on staging_octane.site_allowed_ip (saip_ip_address);

create table staging_octane.smart_charge_apr_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.smart_charge
(
    sc_pid bigint
        primary key,
    sc_version int null,
    sc_account_pid bigint null,
    sc_charge_type varchar(128) null,
    sc_loan_position_type varchar(128) null,
    sc_name varchar(128) null,
    sc_smart_charge_apr_type varchar(128) null,
    sc_apr_criteria_pid bigint null
);

create table staging_octane.smart_charge_group
(
    scg_pid bigint
        primary key,
    scg_version int null,
    scg_smart_charge_pid bigint null,
    scg_group_name varchar(128) null
);

create table staging_octane.smart_charge_group_case
(
    scgc_pid bigint
        primary key,
    scgc_version int null,
    scgc_smart_charge_group_pid bigint null,
    scgc_from_date date null,
    scgc_through_date date null
);

create table staging_octane.smart_charge_case
(
    scc_pid bigint
        primary key,
    scc_version int null,
    scc_smart_charge_group_case_pid bigint null,
    scc_case_name varchar(128) null,
    scc_ordinal int null,
    scc_criteria_pid bigint null,
    scc_amount_description varchar(256) null,
    scc_charge_payer_type varchar(128) null,
    scc_charge_payee_type varchar(128) null,
    scc_paid_by varchar(128) null,
    scc_paid_to varchar(128) null,
    scc_base_amount decimal(16,3) null,
    scc_charge_input_type varchar(128) null,
    scc_charge_input_type_percent decimal(11,9) null,
    scc_charge_input_type_currency decimal(16,3) null,
    scc_financed bit null,
    scc_financed_auto_compute bit null,
    scc_poc bit null,
    scc_reduction_amount decimal(15) null,
    scc_subtract_lenders_title_insurance_amount bit null
);

create table staging_octane.smart_message_delivery_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.smart_message_email_recipient_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.smart_message_recipient_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.smart_message_source_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.smart_mi
(
    sm_pid bigint
        primary key,
    sm_version int null,
    sm_account_pid bigint null,
    sm_mi_company_name_type varchar(128) null
);

create table staging_octane.smart_mi_eligibility_case
(
    smec_pid bigint
        primary key,
    smec_version int null,
    smec_smart_mi_pid bigint null,
    smec_criteria_pid bigint null,
    smec_from_date date null,
    smec_through_date date null
);

create table staging_octane.smart_mi_rate_card
(
    smrca_pid bigint
        primary key,
    smrca_version int null,
    smrca_from_date date null,
    smrca_mi_payment_type varchar(128) null,
    smrca_mi_payer_type varchar(128) null,
    smrca_minimum_rate_percent decimal(11,9) null,
    smrca_smart_mi_pid bigint null,
    smrca_maximum_renewal_rate_percent decimal(11,9) null
);

create table staging_octane.smart_mi_rate_adjustment_case
(
    smrac_pid bigint
        primary key,
    smrac_version int null,
    smrac_smart_mi_rate_card_pid bigint null,
    smrac_rate_adjustment_percent decimal(11,9) null,
    smrac_criteria_html varchar(16000) null,
    smrac_criteria_pid bigint null
);

create table staging_octane.smart_mi_rate_case
(
    smrc_pid bigint
        primary key,
    smrc_version int null,
    smrc_smart_mi_rate_card_pid bigint null,
    smrc_criteria_html varchar(16000) null,
    smrc_ordinal int null,
    smrc_criteria_pid bigint null,
    smrc_else_case bit null,
    smrc_amount_description varchar(256) null,
    smrc_upfront_percent decimal(11,9) null,
    smrc_initial_monthly_payment_annual_percent decimal(11,9) null,
    smrc_coverage_percent decimal(11,9) null,
    smrc_ltv_cutoff_percent decimal(11,9) null,
    smrc_midpoint_cutoff_required bit null,
    smrc_required_monthly_payment_count int null,
    smrc_initial_duration_months int null
);

create table staging_octane.smart_mi_surcharge
(
    sms_pid bigint
        primary key,
    sms_version int null,
    sms_account_pid bigint null,
    sms_from_date date null
);

create table staging_octane.smart_mi_surcharge_case
(
    smsc_pid bigint
        primary key,
    smsc_version int null,
    smsc_smart_mi_surcharge_pid bigint null,
    smsc_criteria_pid bigint null,
    smsc_government_surcharge_percent decimal(11,9) null,
    smsc_minimum_surcharge_amount decimal(15,2) null,
    smsc_criteria_html varchar(16000) null
);

create table staging_octane.smart_stack
(
    ss_pid bigint
        primary key,
    ss_version int null,
    ss_account_pid bigint null,
    ss_name varchar(128) null
);

create table staging_octane.smart_stack_doc_set_include_option_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.smart_doc_set
(
    sdst_pid bigint
        primary key,
    sdst_version int null,
    sdst_account_pid bigint null,
    sdst_name varchar(128) null,
    sdst_doc_set_type varchar(128) null,
    sdst_active bit null,
    sdst_smart_stack_doc_set_include_option_type varchar(128) null
);

create table staging_octane.key_package
(
    kp_pid bigint
        primary key,
    kp_version int null,
    kp_account_pid bigint null,
    kp_smart_doc_set_pid bigint null,
    kp_key_package_type varchar(128) null
);

create table staging_octane.smart_stack_doc_set_include_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.solar_panel_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.stack_doc_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.stack_export_file_name_format_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.stack_export_file_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.stack_export_loan_name_format_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.stack_export_request_loan_export_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.stack_export_request_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.state_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.county
(
    c_pid bigint
        primary key,
    c_version int null,
    c_name varchar(128) null,
    c_state_type varchar(128) null,
    c_county_fips varchar(16) null,
    c_recording_district_type varchar(128) null,
    c_torrens_available bit null,
    c_defunct bit null,
    c_mortech_name varchar(128) null
);

create table staging_octane.area_median_income_row
(
    amir_pid bigint
        primary key,
    amir_version int null,
    amir_area_median_income_table_pid bigint null,
    amir_state_type varchar(128) null,
    amir_county_pid bigint null,
    amir_census_tract varchar(16) null,
    amir_area_median_income decimal(15,2) null
);

create index idx_county_1
    on staging_octane.county (c_state_type);

create table staging_octane.county_city
(
    cci_pid bigint
        primary key,
    cci_version int null,
    cci_county_pid bigint null,
    cci_city_name varchar(128) null
);

create table staging_octane.county_sub_jurisdiction
(
    csju_pid bigint
        primary key,
    csju_version int null,
    csju_county_pid bigint null,
    csju_sub_jurisdiction_name varchar(128) null
);

create table staging_octane.disaster_declaration
(
    dd_pid bigint
        primary key,
    dd_version int null,
    dd_account_pid bigint null,
    dd_fema_incident_id varchar(32) null,
    dd_state_type varchar(128) null,
    dd_county_pid bigint null,
    dd_declared_disaster_date date null,
    dd_last_processed_datetime timestamp null
);

create table staging_octane.license_req
(
    mlr_pid bigint
        primary key,
    mlr_version int null,
    mlr_account_pid bigint null,
    mlr_state_type varchar(128) null,
    mlr_license_type varchar(128) null
);

create table staging_octane.loan_limit_row
(
    llr_pid bigint
        primary key,
    llr_version int null,
    llr_loan_limit_table_pid bigint null,
    llr_loan_limit_type varchar(128) null,
    llr_state_type varchar(128) null,
    llr_county_pid bigint null,
    llr_one_unit_limit_amount decimal(15,2) null,
    llr_two_unit_limit_amount decimal(15,2) null,
    llr_three_unit_limit_amount decimal(15,2) null,
    llr_four_unit_limit_amount decimal(15,2) null
);

create table staging_octane.recording_city
(
    rc_pid bigint
        primary key,
    rc_version int null,
    rc_city_name varchar(128) null,
    rc_state_type varchar(128) null,
    rc_recording_city_name varchar(128) null
);

create table staging_octane.recording_district
(
    rdi_pid bigint
        primary key,
    rdi_version int null,
    rdi_state_type varchar(128) null,
    rdi_district_name_with_qualifier varchar(128) null,
    rdi_district_name varchar(128) null
);

create table staging_octane.county_recording_district
(
    crdi_pid bigint
        primary key,
    crdi_version int null,
    crdi_county_pid bigint null,
    crdi_recording_district_pid bigint null
);

create index idx_recording_district_1
    on staging_octane.recording_district (rdi_district_name);

create table staging_octane.region_ernst_page_rec
(
    rerc_pid bigint
        primary key,
    rerc_version int null,
    rerc_ernst_page_rec_type varchar(128) null,
    rerc_state_type varchar(128) null,
    rerc_county_pid bigint null,
    rerc_county_city_pid bigint null,
    rerc_recording_district_pid bigint null,
    rerc_ernst_page_rec varchar(16) null
);

create table staging_octane.street_links_product_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.stripe_payment_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.stripe_payment
(
    stpm_pid bigint
        primary key,
    stpm_version int null,
    stpm_account_pid bigint null,
    stpm_submit_datetime timestamp null,
    stpm_payer_unparsed_name varchar(128) null,
    stpm_invoice_amount decimal(15,2) null,
    stpm_payment_request_type varchar(128) null,
    stpm_stripe_payment_status_type varchar(128) null,
    stpm_payment_status_messages text null,
    stpm_status_datetime timestamp null,
    stpm_token varchar(128) null,
    stpm_receipt_email varchar(256) null,
    stpm_stripe_id varchar(128) null,
    stpm_refund_stripe_id varchar(128) null,
    stpm_receipt_url varchar(256) null
);

create table staging_octane.tax_filing_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.tax_transcript_request_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.taxpayer_identifier_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.contractor
(
    ctr_pid bigint
        primary key,
    ctr_version int null,
    ctr_account_pid bigint null,
    ctr_contractor_company_name varchar(128) null,
    ctr_max_construction_credit_amount decimal(15,2) null,
    ctr_taxpayer_identifier_type varchar(128) null,
    ctr_first_name varchar(128) null,
    ctr_last_name varchar(128) null,
    ctr_work_phone varchar(32) null,
    ctr_work_phone_extension varchar(16) null,
    ctr_mobile_phone varchar(32) null,
    ctr_fax varchar(32) null,
    ctr_email varchar(256) null,
    ctr_address_street1 varchar(128) null,
    ctr_address_street2 varchar(128) null,
    ctr_address_city varchar(128) null,
    ctr_address_state varchar(128) null,
    ctr_address_postal_code varchar(128) null,
    ctr_address_country varchar(128) null,
    ctr_notes varchar(1024) null
);

create table staging_octane.contractor_license
(
    ctrl_pid bigint
        primary key,
    ctrl_version int null,
    ctrl_contractor_pid bigint null,
    ctrl_state_type varchar(128) null,
    ctrl_license_number varchar(128) null,
    ctrl_from_date date null,
    ctrl_through_date date null,
    ctrl_note varchar(256) null
);

create table staging_octane.third_party_community_second_program_eligibility_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.time_zone_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.admin_user
(
    au_pid bigint
        primary key,
    au_version int null,
    au_create_date date null,
    au_email varchar(256) null,
    au_first_name varchar(32) null,
    au_last_name varchar(32) null,
    au_unparsed_name varchar(128) null,
    au_office_phone varchar(32) null,
    au_office_phone_extension varchar(16) null,
    au_through_date date null,
    au_time_zone varchar(128) null,
    au_title varchar(128) null,
    au_admin_user_status_type varchar(128) null,
    au_username varchar(32) null,
    au_admin_user_administrator bit null,
    au_customer_support bit null,
    au_engineering bit null,
    au_management bit null,
    au_force_password_change bit null,
    au_last_password_change_date timestamp null,
    au_last_sign_on_datetime timestamp null
);

create table staging_octane.borrower_user
(
    bu_pid bigint
        primary key,
    bu_version int null,
    bu_account_pid bigint null,
    bu_create_datetime timestamp null,
    bu_email varchar(256) null,
    bu_last_sign_on_datetime timestamp null,
    bu_time_zone varchar(128) null,
    bu_first_name varchar(32) null,
    bu_middle_name varchar(32) null,
    bu_last_name varchar(32) null,
    bu_name_suffix varchar(32) null,
    bu_unparsed_name varchar(128) null,
    bu_borrower_activation_id varchar(128) null,
    bu_challenge_question_type varchar(128) null,
    bu_challenge_question_answer varchar(128) null,
    bu_borrower_user_account_status_type varchar(128) null,
    bu_public_quote_request_cache_id int null,
    bu_create_sap_on_activation bit null,
    bu_nickname varchar(32) null,
    bu_plain_text_email bit null,
    bu_preferred_first_name varchar(32) null
);

create index idx_borrower_user_1
    on staging_octane.borrower_user (bu_borrower_activation_id);

create table staging_octane.timeout_time_zone_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.title_company
(
    tc_pid bigint
        primary key,
    tc_version int null,
    tc_account_pid bigint null,
    tc_company_name varchar(128) null,
    tc_admin_lock bit null,
    tc_active bit null,
    tc_preferred_vendor bit null
);

create table staging_octane.title_company_office
(
    tco_pid bigint
        primary key,
    tco_version int null,
    tco_title_company_pid bigint null,
    tco_address_street1 varchar(128) null,
    tco_address_street2 varchar(128) null,
    tco_address_city varchar(128) null,
    tco_address_state varchar(128) null,
    tco_address_postal_code varchar(128) null,
    tco_address_country varchar(128) null,
    tco_phone varchar(32) null,
    tco_fax varchar(32) null,
    tco_email varchar(256) null,
    tco_active bit null
);

create table staging_octane.preferred_settlement
(
    prs_pid bigint
        primary key,
    prs_version int null,
    prs_account_pid bigint null,
    prs_state varchar(16) null,
    prs_from_date date null,
    prs_title_company_pid bigint null,
    prs_title_company_office_pid bigint null,
    prs_settlement_agent_pid bigint null,
    prs_settlement_agent_office_pid bigint null,
    prs_settlement_agent_wire_pid bigint null
);

create table staging_octane.title_manner_held_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.total_expert_account_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.trade_audit_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.trade_fee_type
(
    tft_pid bigint
        primary key,
    tft_version int null,
    tft_account_pid bigint null,
    tft_name varchar(128) null
);

create table staging_octane.trade_pricing_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.trade_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.trustee
(
    tru_pid bigint
        primary key,
    tru_version int null,
    tru_account_pid bigint null,
    tru_name varchar(128) null,
    tru_address_street1 varchar(128) null,
    tru_address_street2 varchar(128) null,
    tru_address_city varchar(128) null,
    tru_address_state varchar(128) null,
    tru_address_postal_code varchar(128) null,
    tru_address_country varchar(128) null,
    tru_mers_org_id varchar(7) null,
    tru_from_date date null,
    tru_through_date date null,
    tru_phone_number varchar(32) null
);

create table staging_octane.underwrite_disposition_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.underwrite_method_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.underwrite_risk_assessment_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.unique_dwelling_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.usda_rd_single_family_housing_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.uuts_loan_originator_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.va_borrower_certification_occupancy_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.va_entitlement_code_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.va_entitlement_restoration_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.va_notice_of_value_source_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.va_past_credit_record_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.va_regional_loan_center_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.va_relative_relationship_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.vendor_credential_source_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.vendor_document_event_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.vendor_import_document_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.veteran_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.voe_third_party_verifier_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.voe_verbal_verify_method_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.voe_verify_method_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.water_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.wf_deal_process_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.wf_deal_step_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.wf_outcome_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.wf_phase
(
    wph_pid bigint
        primary key,
    wph_version int null,
    wph_account_pid bigint null,
    wph_phase_name varchar(128) null,
    wph_phase_number int null
);

create table staging_octane.wf_process_status_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.wf_process_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.wf_process
(
    wpr_pid bigint
        primary key,
    wpr_version int null,
    wpr_account_pid bigint null,
    wpr_name varchar(128) null,
    wpr_wf_process_type varchar(128) null,
    wpr_criteria_pid bigint null,
    wpr_wf_process_status_type varchar(128) null
);

create table staging_octane.wf_step_function_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.wf_step_performer_assign_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.wf_step_reassign_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.wf_step_timeout_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.wf_step_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.wf_wait_until_time_slice
(
    wts_pid bigint
        primary key,
    wts_version int null,
    wts_time_slice timestamp null,
    wts_when_fired timestamp null,
    wts_when_complete timestamp null
);

create index idx_wf_wait_until_time_slice_1
    on staging_octane.wf_wait_until_time_slice (wts_time_slice);

create table staging_octane.yes_no_na_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.yes_no_na_unknown_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.yes_no_unknown_type
(
    code varchar(128) null
        primary key,
    value varchar(1024) null
);

create table staging_octane.application
(
    apl_pid bigint
        primary key,
    apl_version int null,
    apl_application_name varchar(128) null,
    apl_primary_application bit null,
    apl_urla bit null,
    apl_proposal_pid bigint null,
    apl_fha_borrower_certification_own_other_property varchar(128) null,
    apl_fha_borrower_certification_property_to_be_sold varchar(128) null,
    apl_fha_borrower_certification_sales_price_amount decimal(15) null,
    apl_fha_borrower_certification_mortgage_amount decimal(15) null,
    apl_address_street1 varchar(128) null,
    apl_address_street2 varchar(128) null,
    apl_address_city varchar(128) null,
    apl_address_state varchar(128) null,
    apl_address_postal_code varchar(128) null,
    apl_address_country varchar(128) null,
    apl_fha_borrower_certification_rental varchar(128) null,
    apl_fha_borrower_certification_rental_explain varchar(256) null,
    apl_fha_borrower_certification_more_than_four_dwellings varchar(128) null,
    apl_va_borrower_certification_occupancy_type varchar(128) null,
    apl_fha_va_bor_cert_sales_price_exceeds_type varchar(128) null
);

create table staging_octane.asset
(
    as_pid bigint
        primary key,
    as_version int null,
    as_aggregate_description varchar(256) null,
    as_application_pid bigint null,
    as_asset_type varchar(128) null,
    as_automobile_make_description varchar(32) null,
    as_automobile_model_year int null,
    as_cash_or_market_value_amount decimal(15,2) null,
    as_description varchar(128) null,
    as_donor_city varchar(128) null,
    as_donor_country varchar(128) null,
    as_donor_postal_code varchar(128) null,
    as_donor_state varchar(128) null,
    as_donor_street1 varchar(128) null,
    as_donor_street2 varchar(128) null,
    as_gift_funds_donor_phone varchar(32) null,
    as_gift_funds_donor_relationship varchar(128) null,
    as_gift_funds_donor_unparsed_name varchar(128) null,
    as_gift_funds_other_type_description varchar(32) null,
    as_gift_funds_depository_asset_pid bigint null,
    as_gift_amount decimal(15,2) null,
    as_gift_funds_source_account_type varchar(128) null,
    as_gift_funds_source_holder_name varchar(128) null,
    as_gift_funds_type varchar(128) null,
    as_holder_name varchar(128) null,
    as_holder_city varchar(128) null,
    as_holder_country varchar(128) null,
    as_holder_postal_code varchar(128) null,
    as_holder_state varchar(128) null,
    as_holder_street1 varchar(128) null,
    as_holder_street2 varchar(128) null,
    as_life_insurance_face_value_amount decimal(15,2) null,
    as_liquid_amount decimal(15,2) null,
    as_liquid_percent decimal(11,9) null,
    as_source_verification_required varchar(128) null,
    as_stock_bond_mutual_fund_share_count int null,
    as_earnest_money_deposit_source_pid bigint null,
    as_available_amount decimal(15,2) null,
    as_down_payment_amount decimal(15) null,
    as_closing_costs_amount decimal(15,2) null,
    as_gift_funds_account_holder_type varchar(128) null,
    as_penalty_amount decimal(15,2) null
);

create table staging_octane.asset_large_deposit
(
    ald_pid bigint
        primary key,
    ald_version int null,
    ald_asset_pid bigint null,
    ald_deposit_amount decimal(15,2) null,
    ald_deposit_date date null
);

create table staging_octane.creditor
(
    crd_pid bigint
        primary key,
    crd_version int null,
    crd_account_pid bigint null,
    crd_payoff_request_delivery_type varchar(128) null,
    crd_name varchar(128) null,
    crd_payoff_phone_1 varchar(32) null,
    crd_payoff_phone_1_extension varchar(16) null,
    crd_payoff_phone_2 varchar(32) null,
    crd_payoff_phone_2_extension varchar(16) null,
    crd_payoff_fax varchar(32) null,
    crd_payoff_email varchar(256) null,
    crd_payoff_auto_teller varchar(128) null,
    crd_last_updated date null,
    crd_last_updated_by varchar(128) null,
    crd_payoff_notes varchar(1024) null,
    crd_address_street1 varchar(128) null,
    crd_address_street2 varchar(128) null,
    crd_address_city varchar(128) null,
    crd_address_state varchar(128) null,
    crd_address_postal_code varchar(128) null,
    crd_address_country varchar(128) null,
    crd_key_creditor_type varchar(128) null
);

create table staging_octane.creditor_lookup_name
(
    cln_pid bigint
        primary key,
    cln_version int null,
    cln_account_pid bigint null,
    cln_creditor_pid bigint null,
    cln_name varchar(128) null
);

create table staging_octane.investor
(
    i_pid bigint
        primary key,
    i_version int null,
    i_account_pid bigint null,
    i_investor_id varchar(32) null,
    i_criteria_pid bigint null,
    i_website_url varchar(256) null,
    i_investor_name varchar(128) null,
    i_investor_city varchar(128) null,
    i_investor_country varchar(128) null,
    i_investor_postal_code varchar(128) null,
    i_investor_state varchar(128) null,
    i_investor_street1 varchar(128) null,
    i_investor_street2 varchar(128) null,
    i_investor_county_pid bigint null,
    i_beneficiary_name varchar(128) null,
    i_beneficiary_city varchar(128) null,
    i_beneficiary_country varchar(128) null,
    i_beneficiary_postal_code varchar(128) null,
    i_beneficiary_state varchar(128) null,
    i_beneficiary_street1 varchar(128) null,
    i_beneficiary_street2 varchar(128) null,
    i_beneficiary_county_pid bigint null,
    i_loss_payee_name varchar(128) null,
    i_loss_payee_city varchar(128) null,
    i_loss_payee_country varchar(128) null,
    i_loss_payee_postal_code varchar(128) null,
    i_loss_payee_state varchar(128) null,
    i_loss_payee_street1 varchar(128) null,
    i_loss_payee_street2 varchar(128) null,
    i_loss_payee_county_pid bigint null,
    i_loss_payee_assignee_name varchar(128) null,
    i_when_recorded_mail_to_name varchar(128) null,
    i_when_recorded_mail_to_city varchar(128) null,
    i_when_recorded_mail_to_country varchar(128) null,
    i_when_recorded_mail_to_postal_code varchar(128) null,
    i_when_recorded_mail_to_state varchar(128) null,
    i_when_recorded_mail_to_street1 varchar(128) null,
    i_when_recorded_mail_to_street2 varchar(128) null,
    i_when_recorded_mail_to_county_pid bigint null,
    i_servicer_name varchar(128) null,
    i_servicer_address_street1 varchar(128) null,
    i_servicer_address_street2 varchar(128) null,
    i_servicer_address_city varchar(128) null,
    i_servicer_address_state varchar(128) null,
    i_servicer_address_postal_code varchar(128) null,
    i_servicer_address_country varchar(128) null,
    i_servicer_county_pid bigint null,
    i_sub_servicer_name varchar(128) null,
    i_sub_servicer_address_street1 varchar(128) null,
    i_sub_servicer_address_street2 varchar(128) null,
    i_sub_servicer_address_city varchar(128) null,
    i_sub_servicer_address_state varchar(128) null,
    i_sub_servicer_address_postal_code varchar(128) null,
    i_sub_servicer_address_country varchar(128) null,
    i_sub_servicer_mers_org_id varchar(7) null,
    i_custodian_pid bigint null,
    i_file_delivery_name varchar(128) null,
    i_file_delivery_address_street1 varchar(128) null,
    i_file_delivery_address_street2 varchar(128) null,
    i_file_delivery_address_city varchar(128) null,
    i_file_delivery_address_state varchar(128) null,
    i_file_delivery_address_postal_code varchar(128) null,
    i_file_delivery_address_country varchar(128) null,
    i_initial_beneficiary_candidate bit null,
    i_initial_servicer_candidate bit null,
    i_mers_org_member varchar(128) null,
    i_mers_org_id varchar(7) null,
    i_allonge_transfer_to_name varchar(128) null,
    i_lock_expiration_delivery_subtrahend_days int null,
    i_maximum_lock_extensions_allowed int null,
    i_maximum_lock_extension_days_allowed int null,
    i_mortech_investor_id varchar(16) null,
    i_fnma_servicer_id varchar(16) null,
    i_loan_file_delivery_method_type varchar(128) null,
    i_investor_group_pid bigint null,
    i_mbs_investor bit null,
    i_investor_hmda_purchaser_of_loan_type varchar(128) null,
    i_lock_disable_time time null,
    i_allow_weekend_holiday_locks bit null,
    i_nmls_id varchar(16) null,
    i_nmls_id_applicable varchar(128) null,
    i_fnm_investor_remittance_type varchar(128) null,
    i_fnm_mbs_investor_remittance_day_of_month int null,
    i_fnm_mbs_loan_default_loss_party_type varchar(128) null,
    i_fnm_mbs_reo_marketing_party_type varchar(128) null
);

create table staging_octane.company
(
    cm_pid bigint
        primary key,
    cm_version int null,
    cm_account_pid bigint null,
    cm_origination_source_type varchar(128) null,
    cm_company_id varchar(32) null,
    cm_nmls_company_id varchar(16) null,
    cm_federal_tax_id varchar(32) null,
    cm_mers_org_id varchar(7) null,
    cm_mers_mom bit null,
    cm_company_name varchar(128) null,
    cm_company_mailing_address_name varchar(128) null,
    cm_company_name_for_header_and_footer varchar(128) null,
    cm_casual_company_name varchar(128) null,
    cm_company_address_street1 varchar(128) null,
    cm_company_address_street2 varchar(128) null,
    cm_company_address_city varchar(128) null,
    cm_company_address_state varchar(128) null,
    cm_company_address_postal_code varchar(128) null,
    cm_company_address_country varchar(128) null,
    cm_company_phone varchar(32) null,
    cm_customer_service_email varchar(256) null,
    cm_customer_service_phone varchar(32) null,
    cm_customer_service_phone_extension varchar(16) null,
    cm_borrower_app_company_host varchar(256) null,
    cm_borrower_app_company_ip_address varchar(32) null,
    cm_borrower_app_company_enabled bit null,
    cm_borrower_user_email_from varchar(256) null,
    cm_company_legal_entity_type varchar(128) null,
    cm_company_legal_entity_organization_state_type varchar(128) null,
    cm_broker_participating_with_less_than_four_lenders varchar(128) null,
    cm_broker_participating_lender_1 varchar(256) null,
    cm_broker_participating_lender_2 varchar(256) null,
    cm_broker_participating_lender_3 varchar(256) null,
    cm_correspondent_investor_pid bigint null,
    cm_total_expert_account_type varchar(128) null
);

create table staging_octane.branch
(
    br_pid bigint
        primary key,
    br_version int null,
    br_company_pid bigint null,
    br_branch_name varchar(128) null,
    br_fha_field_office_code varchar(16) null,
    br_branch_id varchar(16) null,
    br_branch_status_type varchar(128) null,
    br_nmls_branch_id varchar(16) null,
    br_uuts_loan_originator_type varchar(128) null,
    br_address_street1 varchar(128) null,
    br_address_street2 varchar(128) null,
    br_address_city varchar(128) null,
    br_address_state varchar(128) null,
    br_address_postal_code varchar(128) null,
    br_address_country varchar(128) null,
    br_office_phone varchar(32) null,
    br_office_phone_extension varchar(16) null,
    br_fax varchar(32) null,
    br_lp_lender_branch_id varchar(16) null,
    br_dsi_customer_id varchar(16) null,
    br_clg_flood_cert_internal_account_id varchar(16) null,
    br_street_links_branch_id varchar(32) null,
    br_fha_branch_id varchar(16) null,
    br_fha_branch_id_qualified varchar(16) null,
    br_lender_paid_broker_compensation_percent decimal(11,9) null
);

create table staging_octane.branch_license
(
    brml_pid bigint
        primary key,
    brml_version int null,
    brml_branch_pid bigint null,
    brml_license_type varchar(128) null,
    brml_state_type varchar(128) null,
    brml_license_number varchar(128) null,
    brml_from_date date null,
    brml_through_date date null,
    brml_note varchar(256) null
);

create index idx_account_1
    on staging_octane.company (cm_borrower_app_company_host);

create table staging_octane.company_license
(
    cml_pid bigint
        primary key,
    cml_version int null,
    cml_company_pid bigint null,
    cml_license_type varchar(128) null,
    cml_state_type varchar(128) null,
    cml_company_state_license_type varchar(128) null,
    cml_company_state_legal_name varchar(128) null,
    cml_use_state_specific_company_name bit null,
    cml_license_number varchar(128) null,
    cml_from_date date null,
    cml_through_date date null,
    cml_note varchar(256) null
);

create table staging_octane.deal
(
    d_pid bigint
        primary key,
    d_version int null,
    d_account_pid bigint null,
    d_company_pid bigint null,
    d_active_proposal_pid bigint null,
    d_branch_pid bigint null,
    d_deal_create_date date null,
    d_deal_status_type varchar(128) null,
    d_velocify_lead_id varchar(32) null,
    d_lead_zillow_zq varchar(256) null,
    d_lead_tracking_id varchar(256) null,
    d_lead_reference_id varchar(256) null,
    d_los_loan_id_main bigint null,
    d_los_loan_id_piggyback bigint null,
    d_mers_min_main varchar(20) null,
    d_mers_min_piggyback varchar(20) null,
    d_external_loan_id_main varchar(32) null,
    d_external_loan_id_piggyback varchar(32) null,
    d_lead_source_pid bigint null,
    d_disclosure_mode_date date null,
    d_deal_status_date date null,
    d_sap_deal bit null,
    d_hmda_action_date date null,
    d_hmda_action_type varchar(128) null,
    d_hmda_denial_reason_type_1 varchar(128) null,
    d_hmda_denial_reason_type_2 varchar(128) null,
    d_hmda_denial_reason_type_3 varchar(128) null,
    d_hmda_denial_reason_type_4 varchar(128) null,
    d_borrower_esign bit null,
    d_enable_electronic_transaction varchar(128) null,
    d_application_type varchar(128) null,
    d_welcome_call_datetime timestamp null,
    d_realty_agent_scenario_type varchar(128) null,
    d_test_loan bit null,
    d_charges_enabled_date date null,
    d_credit_bureau_type varchar(128) null,
    d_performer_team_pid bigint null,
    d_deal_create_type varchar(128) null,
    d_hmda_denial_reason_other_description varchar(255) null,
    d_effective_hmda_action_date date null,
    d_copy_source_los_loan_id_main bigint null,
    d_copy_source_los_loan_id_piggyback bigint null,
    d_referred_by_name varchar(128) null,
    d_hmda_universal_loan_id_main varchar(45) null,
    d_hmda_universal_loan_id_piggyback varchar(45) null,
    d_calyx_loan_guid varchar(128) null,
    d_invoices_enabled_date date null,
    d_invoices_enabled bit null,
    d_training_loan bit null,
    d_deal_orphan_status_type varchar(128) null,
    d_deal_orphan_earliest_check_date date null,
    d_deal_create_date_time timestamp null,
    d_gse_version_type varchar(128) null,
    d_early_wire_request bit null
);

create table staging_octane.appraisal
(
    apr_pid bigint
        primary key,
    apr_version int null,
    apr_appraised_value_amount bigint null,
    apr_effective_date date null,
    apr_deal_pid bigint null,
    apr_decision_appraisal bit null,
    apr_appraisal_condition_type varchar(128) null,
    apr_appraiser_address_city varchar(128) null,
    apr_appraiser_address_country varchar(128) null,
    apr_appraiser_address_postal_code varchar(128) null,
    apr_appraiser_address_state varchar(128) null,
    apr_appraiser_address_street1 varchar(128) null,
    apr_appraiser_address_street2 varchar(128) null,
    apr_appraiser_company_name varchar(128) null,
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
    apr_appraiser_license_state varchar(128) null,
    apr_appraisal_order_status_type varchar(128) null,
    apr_appraisal_order_id varchar(32) null,
    apr_appraisal_order_instructions varchar(1024) null,
    apr_property_address_city varchar(128) null,
    apr_property_address_country varchar(128) null,
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
    apr_appraisal_underwriter_type varchar(128) null,
    apr_ucdp_doc_file_id varchar(10) null,
    apr_inspection_date date null,
    apr_appraisal_reference_id varchar(32) null,
    apr_ucdp_ssr_id varchar(16) null,
    apr_sale_price_amount decimal(15) null,
    apr_property_tax_id varchar(128) null,
    apr_property_category_type varchar(128) null,
    apr_cost_to_build_new decimal(15) null,
    apr_monthly_hoa_amount decimal(15,2) null,
    apr_structure_built_year int null,
    apr_structure_built_month int null,
    apr_project_name varchar(128) null,
    apr_road_type varchar(128) null,
    apr_water_type varchar(128) null,
    apr_sanitation_type varchar(128) null,
    apr_neighborhood_location_type varchar(128) null,
    apr_site_area decimal(15) null,
    apr_due_date date null,
    apr_order_date date null,
    apr_payment_type varchar(128) null,
    apr_payment_received_date date null,
    apr_appraisal_source_type varchar(128) null,
    apr_appraisal_purpose_type varchar(128) null,
    apr_exclude bit null,
    apr_order_appraisal varchar(128) null,
    apr_appraisal_id int null,
    apr_mortgage_type varchar(128) null,
    apr_remaining_economic_life_years int null,
    apr_deficient_economic_life_explanation varchar(1024) null,
    apr_hve_point_value_estimate_amount decimal(15,2) null,
    apr_hve_forecast_standard_deviation_percent decimal(11,9) null,
    apr_hve_confidence_level_type varchar(128) null,
    apr_hve_variance_percent decimal(11,9) null,
    apr_hve_excessive_value_message varchar(1024) null,
    apr_cu_risk_score decimal(10,2) null,
    apr_license_expiration_date date null,
    apr_supervisor_required bit null,
    apr_supervisory_appraiser_first_name varchar(32) null,
    apr_supervisory_appraiser_middle_name varchar(32) null,
    apr_supervisory_appraiser_last_name varchar(32) null,
    apr_supervisory_appraiser_name_suffix varchar(32) null,
    apr_supervisory_license_state varchar(128) null,
    apr_supervisory_license_expiration_date date null,
    apr_synthetic_unique bit null
);

create table staging_octane.appraisal_form
(
    aprfm_pid bigint
        primary key,
    aprfm_version int null,
    aprfm_appraisal_pid bigint null,
    aprfm_appraisal_source_type varchar(128) null,
    aprfm_appraisal_form_type varchar(128) null
);

create table staging_octane.appraisal_id_ticker
(
    aprtk_pid bigint
        primary key,
    aprtk_version int null,
    aprtk_deal_pid bigint null,
    aprtk_next_id int null
);

create index idx_deal_1
    on staging_octane.deal (d_external_loan_id_main);

create index idx_deal_2
    on staging_octane.deal (d_external_loan_id_piggyback);

create index idx_deal_4
    on staging_octane.deal (d_deal_create_date);

create index idx_deal_5
    on staging_octane.deal (d_hmda_action_date);

create index idx_deal_6
    on staging_octane.deal (d_disclosure_mode_date);

create table staging_octane.deal_appraisal
(
    dappr_pid bigint
        primary key,
    dappr_version int null,
    dappr_deal_pid bigint null,
    dappr_door_lock_combination bit null,
    dappr_appraisal_entry_contact_type varchar(128) null,
    dappr_appraisal_hold_type varchar(128) null,
    dappr_appraisal_hold_reason_type varchar(128) null,
    dappr_hold_release_date date null,
    dappr_rush_request bit null,
    dappr_transfer_specified bit null,
    dappr_calculated_appraisal_required bit null,
    dappr_override_calculated_appraisal_required bit null,
    dappr_override_calculated_appraisal_required_reason varchar(16000) null,
    dappr_borrower_requires_appraisal varchar(128) null,
    dappr_lender_requires_appraisal bit null,
    dappr_product_requires_appraisal bit null,
    dappr_appraisal_required bit null
);

create table staging_octane.deal_contact
(
    dc_pid bigint
        primary key,
    dc_version int null,
    dc_address_city varchar(128) null,
    dc_address_country varchar(128) null,
    dc_address_postal_code varchar(128) null,
    dc_address_state varchar(128) null,
    dc_address_street1 varchar(128) null,
    dc_address_street2 varchar(128) null,
    dc_company_name varchar(128) null,
    dc_deal_pid bigint null,
    dc_email varchar(256) null,
    dc_fax varchar(32) null,
    dc_first_name varchar(32) null,
    dc_last_name varchar(32) null,
    dc_middle_name varchar(32) null,
    dc_mobile_phone varchar(32) null,
    dc_name_suffix varchar(32) null,
    dc_office_phone varchar(32) null,
    dc_office_phone_extension varchar(16) null,
    dc_role_type varchar(128) null,
    dc_title varchar(128) null
);

create table staging_octane.deal_disaster_declaration
(
    ddd_pid bigint
        primary key,
    ddd_version int null,
    ddd_deal_pid bigint null,
    ddd_disaster_declaration_pid bigint null
);

create table staging_octane.deal_du
(
    ddu_pid bigint
        primary key,
    ddu_version int null,
    ddu_deal_pid bigint null,
    ddu_du_casefile_id varchar(32) null,
    ddu_du_institution_id varchar(16) null
);

create table staging_octane.deal_housing_counselors_request
(
    dhcr_pid bigint
        primary key,
    dhcr_version int null,
    dhcr_deal_pid bigint null,
    dhcr_centroid_address_street1 varchar(128) null,
    dhcr_centroid_address_street2 varchar(128) null,
    dhcr_centroid_address_city varchar(128) null,
    dhcr_centroid_address_state varchar(128) null,
    dhcr_centroid_address_postal_code varchar(128) null,
    dhcr_centroid_address_country varchar(128) null,
    dhcr_error_messages text null
);

create table staging_octane.deal_housing_counselor_candidate
(
    dhcc_pid bigint
        primary key,
    dhcc_version int null,
    dhcc_deal_pid bigint null,
    dhcc_deal_housing_counselors_request_pid bigint null,
    dhcc_counseling_agency_id varchar(16) null,
    dhcc_office_name varchar(256) null,
    dhcc_office_address_street1 varchar(128) null,
    dhcc_office_address_street2 varchar(128) null,
    dhcc_office_address_city varchar(128) null,
    dhcc_office_address_state varchar(128) null,
    dhcc_office_address_postal_code varchar(128) null,
    dhcc_office_address_country varchar(128) null,
    dhcc_office_email varchar(256) null,
    dhcc_office_fax varchar(32) null,
    dhcc_office_phone1 varchar(32) null,
    dhcc_office_phone2 varchar(32) null,
    dhcc_mailing_address_street1 varchar(128) null,
    dhcc_mailing_address_street2 varchar(128) null,
    dhcc_mailing_address_city varchar(128) null,
    dhcc_mailing_address_state varchar(128) null,
    dhcc_mailing_address_postal_code varchar(128) null,
    dhcc_mailing_address_country varchar(128) null,
    dhcc_web_url varchar(256) null,
    dhcc_language_codes varchar(256) null,
    dhcc_address_latitude decimal(15,3) null,
    dhcc_address_longitude decimal(15,3) null,
    dhcc_service_codes varchar(1500) null,
    dhcc_county_name varchar(128) null,
    dhcc_faith_based bit null,
    dhcc_migrant_workers bit null,
    dhcc_colonias bit null,
    dhcc_parent_org_id varchar(16) null,
    dhcc_ordinal int null
);

create table staging_octane.deal_invoice
(
    di_pid bigint
        primary key,
    di_version int null,
    di_deal_pid bigint null,
    di_create_datetime timestamp null,
    di_invoice_amount decimal(15,2) null,
    di_refund_amount decimal(15,2) null,
    di_smart_invoice bit null,
    di_invoice_status_type varchar(128) null,
    di_description varchar(256) null,
    di_internal_notes varchar(1024) null
);

create table staging_octane.deal_invoice_item
(
    dii_pid bigint
        primary key,
    dii_version int null,
    dii_deal_invoice_pid bigint null,
    dii_charge_type varchar(128) null,
    dii_item_amount decimal(15,2) null,
    dii_smart_item bit null,
    dii_adjustment bit null
);

create table staging_octane.deal_lender_user_event
(
    dlue_pid bigint
        primary key,
    dlue_version int null,
    dlue_deal_pid bigint null,
    dlue_subject_lender_user_pid bigint null,
    dlue_role_pid bigint null,
    dlue_create_datetime timestamp null,
    dlue_unparsed_text varchar(1024) null
);

create table staging_octane.deal_event
(
    de_pid bigint
        primary key,
    de_version int null,
    de_create_datetime timestamp null,
    de_deal_event_type varchar(128) null,
    de_deal_pid bigint null,
    de_deal_task_pid bigint null,
    de_deal_note_pid bigint null,
    de_deal_message_log_pid bigint null,
    de_proposal_doc_pid bigint null,
    de_proposal_doc_file_pid bigint null,
    de_wf_deal_step_pid bigint null,
    de_proposal_pid bigint null,
    de_detail varchar(16000) null,
    de_source_unparsed_name varchar(128) null,
    de_coarse_event_type varchar(128) null,
    de_borrower_text varchar(1024) null,
    de_create_nanoseconds int null
);

create table staging_octane.deal_lp
(
    dlp_pid bigint
        primary key,
    dlp_version int null,
    dlp_deal_pid bigint null,
    dlp_lp_loan_id varchar(32) null,
    dlp_lp_key_id varchar(32) null
);

create table staging_octane.deal_performer_team
(
    dptm_pid bigint
        primary key,
    dptm_version int null,
    dptm_deal_pid bigint null,
    dptm_performer_team_pid bigint null
);

create table staging_octane.deal_real_estate_agent
(
    drea_pid bigint
        primary key,
    drea_version int null,
    drea_deal_pid bigint null,
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
    drea_country varchar(128) null,
    drea_postal_code varchar(128) null,
    drea_state_license_id varchar(128) null,
    drea_company_state_license_id varchar(128) null,
    drea_agency_type varchar(128) null
);

create table staging_octane.deal_settlement
(
    dsmt_pid bigint
        primary key,
    dsmt_version int null,
    dsmt_account_pid bigint null,
    dsmt_deal_pid bigint null,
    dsmt_borrower_elected_preferred_settlement varchar(128) null,
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
    dsmt_beneficiary_for_further_credit varchar(128) null,
    dsmt_title_company_pid bigint null,
    dsmt_title_company_office_pid bigint null,
    dsmt_title_company_first_name varchar(128) null,
    dsmt_title_company_last_name varchar(128) null,
    dsmt_title_company_phone varchar(32) null,
    dsmt_title_company_phone_extension varchar(16) null,
    dsmt_title_company_email varchar(256) null,
    dsmt_title_company_contact_license_id varchar(128) null,
    dsmt_title_company_preferred_vendor bit null,
    dsmt_title_insurance_underwriter_company_name varchar(128) null,
    dsmt_title_insurance_attorney_first_name varchar(32) null,
    dsmt_title_insurance_attorney_middle_name varchar(32) null,
    dsmt_title_insurance_attorney_last_name varchar(32) null,
    dsmt_title_insurance_attorney_name_suffix varchar(32) null,
    dsmt_title_insurance_attorney_license_number varchar(32) null
);

create index idx_deal_settlement_1
    on staging_octane.deal_settlement (dsmt_settlement_agent_escrow_id);

create table staging_octane.deal_signer
(
    dsi_pid bigint
        primary key,
    dsi_version int null,
    dsi_deal_pid bigint null,
    dsi_email varchar(256) null,
    dsi_first_name varchar(32) null,
    dsi_middle_name varchar(32) null,
    dsi_last_name varchar(32) null,
    dsi_name_suffix varchar(32) null,
    dsi_signer_id varchar(256) null
);

create index idx_deal_signer_1
    on staging_octane.deal_signer (dsi_signer_id);

create table staging_octane.deal_stage
(
    dst_pid bigint
        primary key,
    dst_version int null,
    dst_deal_pid bigint null,
    dst_deal_stage_type varchar(128) null,
    dst_from_date date null,
    dst_from_datetime timestamp null,
    dst_through_date date null,
    dst_through_datetime timestamp null,
    dst_duration_seconds bigint null,
    dst_business_hours_duration_seconds bigint null
);

create table staging_octane.deal_summary
(
    ds_pid bigint
        primary key,
    ds_version int null,
    ds_deal_pid bigint null,
    ds_lender_lock_expiration_datetime_main timestamp null,
    ds_lender_lock_expiration_datetime_piggyback timestamp null,
    ds_lender_lock_status_type_main varchar(128) null,
    ds_lender_lock_status_type_piggyback varchar(128) null,
    ds_decision_appraisal_condition_type varchar(128) null,
    ds_funding_status_type_main varchar(128) null,
    ds_funding_status_type_piggyback varchar(128) null,
    ds_purchase_advice_date_main date null,
    ds_purchase_advice_date_piggyback date null,
    ds_last_wf_phase_number int null,
    ds_last_wf_phase_name varchar(128) null,
    ds_eligible_investor_ids_main varchar(16000) null,
    ds_eligible_investor_ids_piggyback varchar(16000) null,
    ds_decision_appraisal_cu_risk_score decimal(10,2) null,
    ds_deal_stage_type varchar(128) null,
    ds_deal_stage_from_datetime timestamp null,
    ds_funded_main bit null,
    ds_funded_piggyback bit null,
    ds_most_recent_user_update_date date null,
    ds_lock_vintage_date_main date null,
    ds_lock_vintage_date_piggyback date null,
    ds_lender_lock_datetime_main timestamp null,
    ds_lender_lock_datetime_piggyback timestamp null,
    ds_any_unrequested_packages bit null
);

create table staging_octane.investor_lock_extension_setting
(
    iles_pid bigint
        primary key,
    iles_version int null,
    iles_investor_pid bigint null,
    iles_from_date date null,
    iles_through_date date null,
    iles_extension_days int null,
    iles_price_adjustment_percent decimal(11,9) null,
    iles_auto_confirm bit null
);

create table staging_octane.lead
(
    ld_pid bigint
    primary key,
    ld_version int null,
    ld_deal_pid bigint null,
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
    ld_borrower_birth_date varchar(32) null,
    ld_borrower_residence_street varchar(128) null,
    ld_borrower_residence_city varchar(128) null,
    ld_borrower_residence_state varchar(128) null,
    ld_borrower_residence_postal_code varchar(128) null,
    ld_coborrower_first_name varchar(32) null,
    ld_coborrower_middle_name varchar(32) null,
    ld_coborrower_last_name varchar(32) null,
    ld_coborrower_email varchar(256) null,
    ld_coborrower_birth_date varchar(32) null,
    ld_borrower_current_job_employer_name varchar(128) null,
    ld_borrower_current_job_position varchar(32) null,
    ld_borrower_years_on_job varchar(16) null,
    ld_borrower_gross_monthly_income varchar(32) null
    );

create table staging_octane.lender_user
(
    lu_pid bigint
        primary key,
    lu_version int null,
    lu_branch_pid bigint null,
    lu_account_owner bit null,
    lu_account_pid bigint null,
    lu_create_date date null,
    lu_first_name varchar(32) null,
    lu_last_name varchar(32) null,
    lu_middle_name varchar(32) null,
    lu_name_suffix varchar(32) null,
    lu_company_name varchar(128) null,
    lu_title varchar(128) null,
    lu_office_phone varchar(32) null,
    lu_office_phone_extension varchar(16) null,
    lu_email varchar(256) null,
    lu_fax varchar(32) null,
    lu_city varchar(128) null,
    lu_country varchar(128) null,
    lu_postal_code varchar(128) null,
    lu_state varchar(128) null,
    lu_street1 varchar(128) null,
    lu_street2 varchar(128) null,
    lu_office_phone_use_branch bit null,
    lu_fax_use_branch bit null,
    lu_address_use_branch bit null,
    lu_start_date date null,
    lu_through_date date null,
    lu_time_zone varchar(128) null,
    lu_unparsed_name varchar(128) null,
    lu_lender_user_status_type varchar(128) null,
    lu_username varchar(32) null,
    lu_nmls_loan_originator_id varchar(16) null,
    lu_fha_chums_id varchar(16) null,
    lu_va_agent_id varchar(32) null,
    lu_search_text varchar(256) null,
    lu_company_user_id varchar(32) null,
    lu_force_password_change bit null,
    lu_last_password_change_date timestamp null,
    lu_challenge_question_type varchar(128) null,
    lu_challenge_question_answer varchar(128) null,
    lu_allow_external_ip bit null,
    lu_total_workload_cap int null,
    lu_schedule_once_booking_page_id varchar(128) null,
    lu_performer_team_pid bigint null,
    lu_esign_only bit null,
    lu_work_step_start_notices_enabled bit null,
    lu_smart_app_enabled bit null,
    lu_default_lead_source_pid bigint null,
    lu_default_credit_bureau_type varchar(128) null,
    lu_originator_id varchar(32) null,
    lu_name_qualifier varchar(16) null,
    lu_training_mode bit null,
    lu_about_me varchar(2000) null,
    lu_lender_user_type varchar(128) null,
    lu_hire_date date null,
    lu_mercury_client_group_pid bigint null,
    lu_nickname varchar(32) null,
    lu_preferred_first_name varchar(32) null,
    lu_hub_directory bit null
);

create table staging_octane.backfill_status
(
    bfs_pid bigint
        primary key,
    bfs_version int null,
    bfs_account_pid bigint null,
    bfs_batch_id varchar(128) null,
    bfs_name varchar(128) null,
    bfs_lender_user_pid bigint null,
    bfs_submit_datetime timestamp null,
    bfs_completed_datetime timestamp null,
    bfs_num_loans int null,
    bfs_backfill_status_type varchar(128) null,
    bfs_failure_info varchar(16000) null,
    bfs_raw_header_row varchar(16000) null
);

create table staging_octane.backfill_loan_status
(
    bfls_pid bigint
        primary key,
    bfls_version int null,
    bfls_backfill_status_pid bigint null,
    bfls_los_loan_id varchar(32) null,
    bfls_started_datetime timestamp null,
    bfls_completed_datetime timestamp null,
    bfls_backfill_status_type varchar(128) null,
    bfls_failure_info varchar(16000) null,
    bfls_raw_loan_row varchar(16000) null,
    bfls_warning_info varchar(16000) null
);

create table staging_octane.bid_pool_note
(
    bpn_pid bigint
        primary key,
    bpn_version int null,
    bpn_bid_pool_pid bigint null,
    bpn_create_datetime timestamp null,
    bpn_content varchar(16000) null,
    bpn_author_lender_user_pid bigint null,
    bpn_author_unparsed_name varchar(128) null
);

create table staging_octane.bid_pool_note_comment
(
    bpnc_pid bigint
        primary key,
    bpnc_version int null,
    bpnc_bid_pool_note_pid bigint null,
    bpnc_create_datetime timestamp null,
    bpnc_content varchar(16000) null,
    bpnc_author_lender_user_pid bigint null,
    bpnc_author_unparsed_name varchar(128) null
);

create table staging_octane.bid_pool_note_monitor
(
    bpnm_pid bigint
        primary key,
    bpnm_version int null,
    bpnm_bid_pool_note_pid bigint null,
    bpnm_lender_user_pid bigint null
);

create table staging_octane.branch_account_executive
(
    brae_pid bigint
        primary key,
    brae_version int null,
    brae_branch_pid bigint null,
    brae_lender_user_pid bigint null,
    brae_from_date date null
);

create table staging_octane.deal_invoice_payment_method
(
    dipm_pid bigint
        primary key,
    dipm_version int null,
    dipm_deal_invoice_pid bigint null,
    dipm_payer_type varchar(128) null,
    dipm_configured_payer_type varchar(128) null,
    dipm_payer_unparsed_name varchar(128) null,
    dipm_payment_fulfill_type varchar(128) null,
    dipm_payment_transfer_los_loan_id_main bigint null,
    dipm_payment_processing_company_type varchar(128) null,
    dipm_stripe_payment_pid bigint null,
    dipm_stripe_payment_refund_pid bigint null,
    dipm_requester_agent_type varchar(128) null,
    dipm_requester_lender_user_pid bigint null,
    dipm_requester_unparsed_name varchar(128) null,
    dipm_payment_submission_type varchar(128) null,
    dipm_payment_completed_date date null
);

create table staging_octane.deal_key_roles
(
    dkrs_pid bigint
        primary key,
    dkrs_version int null,
    dkrs_deal_pid bigint null,
    dkrs_originator_lender_user_pid bigint null,
    dkrs_originator_first_name varchar(32) null,
    dkrs_originator_last_name varchar(32) null,
    dkrs_originator_middle_name varchar(32) null,
    dkrs_originator_fmls_basic varchar(128) null,
    dkrs_originator_nmls_id varchar(16) null,
    dkrs_supplemental_originator_lender_user_pid bigint null,
    dkrs_supplemental_originator_fmls varchar(128) null,
    dkrs_account_executive_lender_user_pid bigint null,
    dkrs_account_executive_fmls varchar(128) null,
    dkrs_investor_conditions_lender_user_pid bigint null,
    dkrs_investor_conditions_fmls varchar(128) null,
    dkrs_investor_stack_to_investor_lender_user_pid bigint null,
    dkrs_investor_stack_to_investor_fmls varchar(128) null,
    dkrs_collateral_to_custodian_lender_user_pid bigint null,
    dkrs_collateral_to_custodian_fmls varchar(128) null,
    dkrs_collateral_to_investor_lender_user_pid bigint null,
    dkrs_collateral_to_investor_fmls varchar(128) null,
    dkrs_transaction_assistant_lender_user_pid bigint null,
    dkrs_transaction_assistant_fmls varchar(128) null,
    dkrs_final_documents_to_investor_lender_user_pid bigint null,
    dkrs_final_documents_to_investor_fmls varchar(128) null,
    dkrs_government_insurance_lender_user_pid bigint null,
    dkrs_government_insurance_fmls varchar(128) null,
    dkrs_funder_lender_user_pid bigint null,
    dkrs_funder_fmls varchar(128) null,
    dkrs_processor_lender_user_pid bigint null,
    dkrs_processor_fmls varchar(128) null,
    dkrs_underwriter_lender_user_pid bigint null,
    dkrs_underwriter_fmls varchar(128) null,
    dkrs_project_underwriter_lender_user_pid bigint null,
    dkrs_project_underwriter_fmls varchar(128) null,
    dkrs_closing_doc_specialist_lender_user_pid bigint null,
    dkrs_closing_doc_specialist_fmls varchar(128) null,
    dkrs_wholesale_client_advocate_lender_user_pid bigint null,
    dkrs_wholesale_client_advocate_fmls varchar(128) null
);

create table staging_octane.deal_lender_user
(
    dlu_pid bigint
        primary key,
    dlu_version int null,
    dlu_deal_pid bigint null,
    dlu_lender_user_pid bigint null,
    dlu_role_pid bigint null,
    dlu_loan_access_type varchar(128) null,
    dlu_legacy_role_assignment_type varchar(128) null,
    dlu_legacy_role_assignment_date date null,
    dlu_synthetic_unique varchar(32) null
);

create index idx_deal_lender_user_1
    on staging_octane.deal_lender_user (dlu_deal_pid, dlu_lender_user_pid);

create table staging_octane.deal_performer_team_user
(
    dptu_pid bigint
        primary key,
    dptu_version int null,
    dptu_deal_pid bigint null,
    dptu_performer_team_pid bigint null,
    dptu_user_pid bigint null
);

create table staging_octane.dw_export_request
(
    dwer_pid bigint
        primary key,
    dwer_version int null,
    dwer_account_pid bigint null,
    dwer_create_datetime timestamp null,
    dwer_start_datetime timestamp null,
    dwer_end_datetime timestamp null,
    dwer_request_status_type varchar(128) null,
    dwer_request_status_messages text null,
    dwer_requester_lender_user_pid bigint null,
    dwer_requester_unparsed_name varchar(128) null,
    dwer_exported_deal_count int null,
    dwer_export_id varchar(16) null
);

create table staging_octane.lender_settings
(
    lss_pid bigint
        primary key,
    lss_version int null,
    lss_account_pid bigint null,
    lss_company_time_zone_type varchar(128) null,
    lss_va_lender_id varchar(16) null,
    lss_usda_lender_id varchar(16) null,
    lss_fha_lender_id varchar(16) null,
    lss_fha_home_office_branch_pid bigint null,
    lss_fha_sponsor_id varchar(16) null,
    lss_fha_sponsor_company_name varchar(32) null,
    lss_fha_sponsor_address_street1 varchar(128) null,
    lss_fha_sponsor_address_street2 varchar(128) null,
    lss_fha_sponsor_address_city varchar(128) null,
    lss_fha_sponsor_address_state varchar(128) null,
    lss_fha_sponsor_address_postal_code varchar(128) null,
    lss_fha_sponsor_address_country varchar(128) null,
    lss_fha_non_supervised_mortgagee bit null,
    lss_fnma_seller_id varchar(16) null,
    lss_fre_seller_id varchar(16) null,
    lss_lp_submission_type varchar(128) null,
    lss_lender_user_email_from varchar(256) null,
    lss_hmda_contact_pid bigint null,
    lss_hmda_legal_entity_id varchar(20) null,
    lss_hmda_respondent_id varchar(32) null,
    lss_hmda_agency_id_type varchar(128) null,
    lss_prequalification_program bit null,
    lss_preapproval_program bit null,
    lss_pest_inspector_company_name varchar(128) null,
    lss_pest_inspector_phone varchar(32) null,
    lss_pest_inspector_website_url varchar(256) null,
    lss_pest_inspector_address_street1 varchar(128) null,
    lss_pest_inspector_address_street2 varchar(128) null,
    lss_pest_inspector_address_city varchar(128) null,
    lss_pest_inspector_address_state varchar(128) null,
    lss_pest_inspector_address_postal_code varchar(128) null,
    lss_take_application_hours varchar(128) null,
    lss_originator_title varchar(128) null,
    lss_default_credit_bureau_type varchar(128) null,
    lss_sap_minimum_decision_credit_score int null,
    lss_default_standalone_lock_term_setting_pid bigint null,
    lss_default_combo_lock_term_setting_pid bigint null,
    lss_preferred_aus_type varchar(128) null,
    lss_borrower_quote_filter_pivot_type varchar(128) null,
    lss_borrower_quote_filter_pivot_lower_count int null,
    lss_borrower_quote_filter_pivot_higher_count int null
);

create table staging_octane.lender_user_allowed_ip
(
    luip_pid bigint
        primary key,
    luip_version int null,
    luip_lender_user_pid bigint null,
    luip_status varchar(128) null,
    luip_ip_address varchar(32) null,
    luip_request_id varchar(128) null,
    luip_request_expiration_datetime timestamp null,
    luip_last_used_datetime timestamp null,
    luip_first_used_datetime timestamp null
);

create index idx_lender_user_allowed_ip_1
    on staging_octane.lender_user_allowed_ip (luip_lender_user_pid);

create index idx_lender_user_allowed_ip_2
    on staging_octane.lender_user_allowed_ip (luip_request_id);

create index idx_lender_user_allowed_ip_3
    on staging_octane.lender_user_allowed_ip (luip_ip_address);

create table staging_octane.lender_user_deal_visit
(
    ludv_pid bigint
        primary key,
    ludv_version int null,
    ludv_deal_pid bigint null,
    ludv_lender_user_pid bigint null,
    ludv_visited_datetime timestamp null
);

create table staging_octane.lender_user_lead_source
(
    lulds_pid bigint
        primary key,
    lulds_version int null,
    lulds_lender_user_pid bigint null,
    lulds_lead_source_pid bigint null
);

create table staging_octane.lender_user_license
(
    luml_pid bigint
        primary key,
    luml_version int null,
    luml_lender_user_pid bigint null,
    luml_license_type varchar(128) null,
    luml_state_type varchar(128) null,
    luml_license_number varchar(128) null,
    luml_from_date date null,
    luml_through_date date null,
    luml_note varchar(256) null
);

create table staging_octane.lender_user_notice
(
    lun_pid bigint
        primary key,
    lun_version int null,
    lun_lender_user_pid bigint null,
    lun_deal_pid bigint null,
    lun_create_datetime timestamp null,
    lun_lender_user_notice_type varchar(128) null,
    lun_detail varchar(16000) null,
    lun_source_unparsed_name varchar(128) null
);

create table staging_octane.lender_user_role
(
    lur_pid bigint
        primary key,
    lur_version int null,
    lur_lender_user_pid bigint null,
    lur_role_pid bigint null,
    lur_criteria_pid bigint null,
    lur_workload_cap int null,
    lur_daily_cap int null,
    lur_assignment_gap_minutes int null,
    lur_secondary_role bit null,
    lur_subscribe_smart_messages bit null,
    lur_for_training_only bit null,
    lur_notes varchar(16000) null,
    lur_queue_type varchar(128) null,
    lur_queue_datetime timestamp null
);

create table staging_octane.exclusive_assignment
(
    ea_pid bigint
        primary key,
    ea_version int null,
    ea_lender_user_role_pid bigint null,
    ea_criteria_pid bigint null,
    ea_priority int null,
    ea_name varchar(128) null
);

create table staging_octane.lender_user_role_addendum
(
    lura_pid bigint
        primary key,
    lura_version int null,
    lura_lender_user_pid bigint null,
    lura_lender_user_role_pid bigint null,
    lura_role_pid bigint null
);

create table staging_octane.lender_user_sign_on
(
    luso_pid bigint
        primary key,
    luso_version int null,
    luso_lender_user_pid bigint null,
    luso_last_sign_on_datetime timestamp null
);

create table staging_octane.lender_user_unavailable
(
    luu_pid bigint
        primary key,
    luu_version int null,
    luu_lender_user_pid bigint null,
    luu_from_date date null,
    luu_through_date date null
);

create table staging_octane.mercury_network_status_request
(
    mnsr_pid bigint
        primary key,
    mnsr_version int null,
    mnsr_deal_pid bigint null,
    mnsr_mercury_network_order_id varchar(128) null,
    mnsr_mercury_network_status_type varchar(128) null,
    mnsr_status_message varchar(16000) null
);

create table staging_octane.org_division_leader
(
    orgdl_pid bigint
        primary key,
    orgdl_version int null,
    orgdl_lender_user_pid bigint null,
    orgdl_org_division_pid bigint null,
    orgdl_from_date date null,
    orgdl_through_date date null,
    orgdl_org_leader_position_type varchar(128) null
);

create table staging_octane.org_group_leader
(
    orggl_pid bigint
        primary key,
    orggl_version int null,
    orggl_lender_user_pid bigint null,
    orggl_org_group_pid bigint null,
    orggl_from_date date null,
    orggl_through_date date null,
    orggl_org_leader_position_type varchar(128) null
);

create table staging_octane.org_lender_user_terms
(
    orglut_pid bigint
        primary key,
    orglut_version int null,
    orglut_org_team_pid bigint null,
    orglut_lender_user_pid bigint null,
    orglut_from_date date null,
    orglut_through_date date null
);

create table staging_octane.org_region_leader
(
    orgrl_pid bigint
        primary key,
    orgrl_version int null,
    orgrl_lender_user_pid bigint null,
    orgrl_org_region_pid bigint null,
    orgrl_from_date date null,
    orgrl_through_date date null,
    orgrl_org_leader_position_type varchar(128) null
);

create table staging_octane.org_team_leader
(
    orgtl_pid bigint
        primary key,
    orgtl_version int null,
    orgtl_lender_user_pid bigint null,
    orgtl_org_team_pid bigint null,
    orgtl_from_date date null,
    orgtl_through_date date null,
    orgtl_org_leader_position_type varchar(128) null
);

create table staging_octane.org_unit_leader
(
    orgul_pid bigint
        primary key,
    orgul_version int null,
    orgul_lender_user_pid bigint null,
    orgul_org_unit_pid bigint null,
    orgul_from_date date null,
    orgul_through_date date null,
    orgul_org_leader_position_type varchar(128) null
);

create table staging_octane.performer_assignment
(
    pa_pid bigint
        primary key,
    pa_version int null,
    pa_role_pid bigint null,
    pa_lender_user_pid bigint null,
    pa_last_assign_datetime timestamp null
);

create table staging_octane.product
(
    p_pid bigint
        primary key,
    p_version int null,
    p_account_pid bigint null,
    p_investor_pid bigint null,
    p_fund_source_type varchar(128) null,
    p_investor_product_id varchar(32) null,
    p_investor_product_name varchar(128) null,
    p_from_date date null,
    p_through_date date null,
    p_fnm_product_name varchar(15) null,
    p_lock_auto_confirm bit null,
    p_description varchar(1024) null,
    p_product_side_type varchar(128) null,
    p_parent_product_pid bigint null
);

create table staging_octane.offering_product
(
    ofp_pid bigint
        primary key,
    ofp_version int null,
    ofp_offering_pid bigint null,
    ofp_product_pid bigint null,
    ofp_from_date date null,
    ofp_through_date date null,
    ofp_price_adjustment_percent decimal(11,9) null
);

create table staging_octane.product_add_on
(
    pao_pid bigint
        primary key,
    pao_version int null,
    pao_product_pid bigint null,
    pao_from_date date null
);

create table staging_octane.product_add_on_rule
(
    par_pid bigint
        primary key,
    par_version int null,
    par_product_add_on_pid bigint null,
    par_summary varchar(16000) null,
    par_note varchar(256) null,
    par_rate_adjustment_percent decimal(11,9) null,
    par_investor_price_adjustment_percent decimal(11,9) null,
    par_account_price_adjustment_percent decimal(11,9) null,
    par_arm_margin_adjustment_percent decimal(11,9) null,
    par_loan_purpose_input_type varchar(128) null,
    par_property_usage_input_type varchar(128) null,
    par_doc_level_input_type varchar(128) null,
    par_property_category_input_type varchar(128) null,
    par_first_time_homebuyer_input_type varchar(128) null,
    par_self_employed_input_type varchar(128) null,
    par_amortization_input_type varchar(128) null,
    par_non_resident_alien_input_type varchar(128) null,
    par_hazardous_lava_zone_input_type varchar(128) null,
    par_property_rights_input_type varchar(128) null,
    par_property_acres_input_type varchar(128) null,
    par_arms_length_input_type varchar(128) null,
    par_state_input_type varchar(128) null,
    par_escrow_waiver_input_type varchar(128) null,
    par_subordinate_financing_input_type varchar(128) null,
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
    par_minimum_loan_amount decimal(15) null,
    par_maximum_loan_amount decimal(15) null,
    par_minimum_ltv_ratio_percent decimal(11,9) null,
    par_maximum_ltv_ratio_percent decimal(11,9) null,
    par_minimum_cltv_ratio_percent decimal(11,9) null,
    par_maximum_cltv_ratio_percent decimal(11,9) null,
    par_maximum_housing_ratio_percent decimal(11,9) null,
    par_minimum_debt_ratio_percent decimal(11,9) null,
    par_maximum_debt_ratio_percent decimal(11,9) null,
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
    par_state_wy bit null
);

create table staging_octane.product_branch
(
    pbr_pid bigint
        primary key,
    pbr_version int null,
    pbr_product_pid bigint null,
    pbr_branch_pid bigint null,
    pbr_from_date date null,
    pbr_through_date date null,
    pbr_price_adjustment_percent decimal(11,9) null
);

create table staging_octane.product_deal_check_exclusion
(
    pdce_pid bigint
        primary key,
    pdce_version int null,
    pdce_product_pid bigint null,
    pdce_deal_check_type varchar(128) null
);

create table staging_octane.product_eligibility
(
    pe_pid bigint
        primary key,
    pe_version int null,
    pe_product_pid bigint null,
    pe_from_date date null
);

create table staging_octane.product_eligibility_rule
(
    per_pid bigint
        primary key,
    per_version int null,
    per_product_eligibility_pid bigint null,
    per_summary varchar(16000) null,
    per_note varchar(256) null,
    per_group_id int null,
    per_loan_purpose_input_type varchar(128) null,
    per_property_usage_input_type varchar(128) null,
    per_doc_level_input_type varchar(128) null,
    per_property_category_input_type varchar(128) null,
    per_first_time_homebuyer_input_type varchar(128) null,
    per_self_employed_input_type varchar(128) null,
    per_amortization_input_type varchar(128) null,
    per_non_resident_alien_input_type varchar(128) null,
    per_hazardous_lava_zone_input_type varchar(128) null,
    per_property_rights_input_type varchar(128) null,
    per_property_acres_input_type varchar(128) null,
    per_arms_length_input_type varchar(128) null,
    per_underwrite_accepted_input_type varchar(128) null,
    per_state_input_type varchar(128) null,
    per_escrow_waiver_input_type varchar(128) null,
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
    per_minimum_loan_amount decimal(15) null,
    per_maximum_loan_amount decimal(15) null,
    per_maximum_ltv_ratio_percent decimal(11,9) null,
    per_newly_built_maximum_ltv_ratio_percent decimal(11,9) null,
    per_subordinate_maximum_ltv_ratio_percent decimal(11,9) null,
    per_maximum_cltv_ratio_percent decimal(11,9) null,
    per_maximum_housing_ratio_percent decimal(11,9) null,
    per_maximum_debt_ratio_percent decimal(11,9) null,
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
    per_state_wy bit null
);

create table staging_octane.product_lock_term
(
    plt_pid bigint
        primary key,
    plt_version int null,
    plt_product_pid bigint null,
    plt_lock_term_setting_pid bigint null,
    plt_from_date date null,
    plt_through_date date null,
    plt_price_adjustment_percent decimal(11,9) null
);

create table staging_octane.product_maximum_investor_price
(
    pmip_pid bigint
        primary key,
    pmip_version int null,
    pmip_product_pid bigint null,
    pmip_from_date date null,
    pmip_maximum_investor_price_percent decimal(11,9) null,
    pmip_maximum_includes_srp bit null,
    pmip_loan_amount_min decimal(15) null,
    pmip_loan_amount_max decimal(15) null
);

create table staging_octane.product_maximum_rebate
(
    pmr_pid bigint
        primary key,
    pmr_version int null,
    pmr_product_pid bigint null,
    pmr_from_date date null,
    pmr_maximum_rebate_percent decimal(11,9) null
);

create table staging_octane.product_minimum_investor_price
(
    pminip_pid bigint
        primary key,
    pminip_version int null,
    pminip_product_pid bigint null,
    pminip_from_date date null,
    pminip_minimum_investor_price_percent decimal(11,9) null,
    pminip_minimum_includes_srp bit null,
    pminip_loan_amount_min decimal(15) null,
    pminip_loan_amount_max decimal(15) null
);

create table staging_octane.product_originator
(
    po_pid bigint
        primary key,
    po_version int null,
    po_product_pid bigint null,
    po_lender_user_pid bigint null,
    po_from_date date null,
    po_through_date date null,
    po_price_adjustment_percent decimal(11,9) null
);

create table staging_octane.product_terms
(
    pt_pid bigint
        primary key,
    pt_version int null,
    pt_amortization_term_months int null,
    pt_arm_index_type varchar(128) null,
    pt_arm_payment_adjustment_calculation_type varchar(128) null,
    pt_assumable bit null,
    pt_product_category varchar(128) null,
    pt_conditions_to_assumability bit null,
    pt_demand_feature bit null,
    pt_due_in_term_months int null,
    pt_escrow_cushion_months int null,
    pt_from_date date null,
    pt_initial_payment_adjustment_term_months int null,
    pt_initial_rate_adjustment_cap_percent decimal(11,9) null,
    pt_initial_rate_adjustment_term_months int null,
    pt_lien_priority_type varchar(128) null,
    pt_loan_amortization_type varchar(128) null,
    pt_minimum_payment_rate_percent decimal(11,9) null,
    pt_minimum_rate_term_months int null,
    pt_mortgage_type varchar(128) null,
    pt_negative_amortization_type varchar(128) null,
    pt_negative_amortization_limit_percent decimal(11,9) null,
    pt_negative_amortization_recast_period_months int null,
    pt_payment_adjustment_lifetime_cap_percent decimal(11,9) null,
    pt_payment_adjustment_periodic_cap decimal(11,9) null,
    pt_payment_frequency_type varchar(128) null,
    pt_prepayment_finance_charge_refund bit null,
    pt_product_pid bigint null,
    pt_rate_adjustment_lifetime_cap_percent decimal(11,9) null,
    pt_subsequent_payment_adjustment_term_months int null,
    pt_subsequent_rate_adjustment_cap_percent decimal(11,9) null,
    pt_subsequent_rate_adjustment_term_months int null,
    pt_prepay_penalty_type varchar(128) null,
    pt_lender_hazard_insurance_available bit null,
    pt_lender_hazard_insurance_premium_amount decimal(15,2) null,
    pt_lender_hazard_insurance_term_months int null,
    pt_loan_requires_hazard_insurance bit null,
    pt_arm_convertible bit null,
    pt_arm_convertible_from_month int null,
    pt_arm_convertible_through_month int null,
    pt_arm_floor_rate_percent decimal(11,9) null,
    pt_arm_lookback_period_days int null,
    pt_escrow_waiver_allowed bit null,
    pt_days_per_year_type varchar(128) null,
    pt_lp_risk_assessment_accepted bit null,
    pt_du_risk_assessment_accepted bit null,
    pt_manual_risk_assessment_accepted bit null,
    pt_internal_underwrite_accepted bit null,
    pt_external_fha_underwrite_accepted bit null,
    pt_external_va_underwrite_accepted bit null,
    pt_external_usda_underwrite_accepted bit null,
    pt_external_investor_underwrite_accepted bit null,
    pt_heloc_cancel_fee_applicable_type varchar(128) null,
    pt_heloc_cancel_fee_period_months int null,
    pt_heloc_cancel_fee_amount decimal(15,2) null,
    pt_heloc_draw_period_months int null,
    pt_heloc_repayment_period_duration_months int null,
    pt_heloc_maximum_initial_draw bit null,
    pt_heloc_maximum_initial_draw_amount decimal(15) null,
    pt_heloc_minimum_draw bit null,
    pt_heloc_minimum_draw_amount decimal(15) null,
    pt_gpm_adjustment_years int null,
    pt_gpm_adjustment_percent decimal(11,9) null,
    pt_qualifying_monthly_payment_type varchar(128) null,
    pt_qualifying_rate_type varchar(128) null,
    pt_qualifying_rate_input_percent decimal(11,9) null,
    pt_ipc_calc_type varchar(128) null,
    pt_ipc_limit_percent1 decimal(11,9) null,
    pt_ipc_property_usage_type1 varchar(128) null,
    pt_ipc_comparison_operator_type1 varchar(128) null,
    pt_ipc_cltv_ratio_percent1 decimal(11,9) null,
    pt_ipc_limit_percent2 decimal(11,9) null,
    pt_ipc_property_usage_type2 varchar(128) null,
    pt_ipc_comparison_operator_type2 varchar(128) null,
    pt_ipc_cltv_ratio_percent2 decimal(11,9) null,
    pt_ipc_limit_percent3 decimal(11,9) null,
    pt_ipc_property_usage_type3 varchar(128) null,
    pt_ipc_comparison_operator_type3 varchar(128) null,
    pt_ipc_cltv_ratio_percent3 decimal(11,9) null,
    pt_ipc_limit_percent4 decimal(11,9) null,
    pt_ipc_property_usage_type4 varchar(128) null,
    pt_ipc_comparison_operator_type4 varchar(128) null,
    pt_ipc_cltv_ratio_percent4 decimal(11,9) null,
    pt_buydown_base_date_type varchar(128) null,
    pt_buydown_subsidy_calculation_type varchar(128) null,
    pt_prepaid_interest_rate_type varchar(128) null,
    pt_fnm_arm_plan_type varchar(128) null,
    pt_dsi_plan_code varchar(128) null,
    pt_credit_qualifying bit null,
    pt_product_special_program_type varchar(128) null,
    pt_section_of_act_coarse_type varchar(128) null,
    pt_fha_rehab_program_type varchar(128) null,
    pt_fha_special_program_type varchar(128) null,
    pt_third_party_grant_eligible bit null,
    pt_servicing_transfer_type varchar(128) null,
    pt_no_mi_product bit null,
    pt_mortgage_credit_certificate_eligible bit null,
    pt_fre_community_program_type varchar(128) null,
    pt_fnm_community_lending_product_type varchar(128) null,
    pt_zero_note_rate bit null,
    pt_third_party_community_second_program_eligibility_type varchar(128) null,
    pt_texas_veterans_land_board varchar(128) null,
    pt_security_instrument_page_count int null,
    pt_deed_page_count int null,
    pt_partial_payment_policy_type varchar(128) null,
    pt_payment_structure_type varchar(128) null,
    pt_deferred_payment_months int null,
    pt_always_current_market_price bit null,
    pt_rate_protect bit null,
    pt_non_conforming bit null,
    pt_allow_loan_amount_cents bit null,
    pt_product_appraisal_requirement_type varchar(128) null,
    pt_family_advantage bit null,
    pt_community_lending_type varchar(128) null,
    pt_high_balance varchar(128) null,
    pt_decision_credit_score_calc_type varchar(128) null,
    pt_new_york bit null
);

create table staging_octane.product_buydown
(
    pbd_pid bigint
        primary key,
    pbd_version int null,
    pbd_product_terms_pid bigint null,
    pbd_buydown_schedule_type varchar(128) null
);

create table staging_octane.product_interest_only
(
    pio_pid bigint
        primary key,
    pio_version int null,
    pio_product_terms_pid bigint null,
    pio_interest_only_type varchar(128) null
);

create table staging_octane.product_prepay_penalty
(
    ppp_pid bigint
        primary key,
    ppp_version int null,
    ppp_product_terms_pid bigint null,
    ppp_prepay_penalty_schedule_type varchar(128) null
);

create table staging_octane.rate_sheet
(
    rs_pid bigint
        primary key,
    rs_version int null,
    rs_product_pid bigint null,
    rs_from_datetime timestamp null
);

create table staging_octane.rate_sheet_rate
(
    rsr_pid bigint
        primary key,
    rsr_version int null,
    rsr_rate_sheet_pid bigint null,
    rsr_rate_percent decimal(11,9) null,
    rsr_arm_margin_percent decimal(11,9) null,
    rsr_available bit null
);

create table staging_octane.rate_sheet_price
(
    rsp_pid bigint
        primary key,
    rsp_version int null,
    rsp_rate_sheet_rate_pid bigint null,
    rsp_lock_duration_days int null,
    rsp_lock_commitment_type varchar(128) null,
    rsp_price_percent decimal(11,9) null
);

create table staging_octane.repository_file
(
    rf_pid bigint
        primary key,
    rf_version int null,
    rf_account_pid bigint null,
    rf_repository_type varchar(128) null,
    rf_client_filename varchar(128) null,
    rf_repository_filename varchar(128) null,
    rf_upload_datetime timestamp null,
    rf_uploader_name varchar(128) null,
    rf_uploader_agent_type varchar(128) null,
    rf_uploader_lender_user_pid bigint null,
    rf_uploader_borrower_user_pid bigint null,
    rf_description varchar(256) null,
    rf_file_size bigint null,
    rf_mime_type varchar(128) null,
    rf_delete_datetime timestamp null,
    rf_file_checksum varchar(128) null
);

create table staging_octane.bid_pool_file
(
    bpf_pid bigint
        primary key,
    bpf_version int null,
    bpf_bid_pool_pid bigint null,
    bpf_repository_file_pid bigint null
);

create table staging_octane.compass_analytics_report_request
(
    carr_pid bigint
        primary key,
    carr_version int null,
    carr_account_pid bigint null,
    carr_create_datetime timestamp null,
    carr_start_datetime timestamp null,
    carr_end_datetime timestamp null,
    carr_request_status_type varchar(128) null,
    carr_request_status_messages text null,
    carr_requester_unparsed_name varchar(128) null,
    carr_exported_deal_count int null,
    carr_total_deal_count int null,
    carr_sold_from_date date null,
    carr_sold_through_date date null,
    carr_cancelled_from_date date null,
    carr_cancelled_through_date date null,
    carr_export_csv_repository_file_pid bigint null,
    carr_error_file_pid bigint null,
    carr_use_loan_hedge_data bit null
);

create table staging_octane.consumer_privacy_request
(
    cpr_pid bigint
        primary key,
    cpr_version int null,
    cpr_request_id int null,
    cpr_receiver_lender_user_pid bigint null,
    cpr_account_pid bigint null,
    cpr_borrower_last_name varchar(128) null,
    cpr_searched_email varchar(256) null,
    cpr_searched_phone varchar(32) null,
    cpr_searched_los_loan_id bigint null,
    cpr_searched_subject_property_street varchar(128) null,
    cpr_searched_subject_property_city varchar(128) null,
    cpr_searched_subject_property_state_type varchar(128) null,
    cpr_received_date timestamp null,
    cpr_know_datetime timestamp null,
    cpr_delete_datetime timestamp null,
    cpr_request_type varchar(128) null,
    cpr_request_todo varchar(128) null,
    cpr_know_repository_file_pid bigint null,
    cpr_delete_repository_file_pid bigint null
);

create table staging_octane.custom_form
(
    cf_pid bigint
        primary key,
    cf_version int null,
    cf_account_pid bigint null,
    cf_merge_form bit null,
    cf_repository_file_pid bigint null
);

create table staging_octane.custom_form_merge_field
(
    cfmf_pid bigint
        primary key,
    cfmf_version int null,
    cfmf_custom_form_pid bigint null,
    cfmf_field_type varchar(128) null
);

create table staging_octane.deal_file
(
    df_pid bigint
        primary key,
    df_version int null,
    df_deal_pid bigint null,
    df_repository_file_pid bigint null,
    df_archive bit null,
    df_borrower_uploaded bit null
);

create table staging_octane.appraisal_file
(
    aprf_pid bigint
        primary key,
    aprf_version int null,
    aprf_appraisal_pid bigint null,
    aprf_deal_file_pid bigint null,
    aprf_appraisal_file_type varchar(128) null
);

create table staging_octane.deal_dropbox_file
(
    ddf_pid bigint
        primary key,
    ddf_version int null,
    ddf_deal_file_pid bigint null
);

create table staging_octane.deal_file_signature
(
    dfs_pid bigint
        primary key,
    dfs_version int null,
    dfs_deal_file_pid bigint null,
    dfs_deal_signer_pid bigint null,
    dfs_x decimal(15,7) null,
    dfs_y decimal(15,7) null,
    dfs_page_number int null,
    dfs_page_height decimal(15,7) null,
    dfs_signature_part_type varchar(128) null,
    dfs_charge_type varchar(128) null,
    dfs_charge_amount decimal(15,2) null
);

create table staging_octane.deal_fraud_risk
(
    dfr_pid bigint
        primary key,
    dfr_version int null,
    dfr_deal_pid bigint null,
    dfr_loan_safe_risk_manager_status_messages text null,
    dfr_loan_safe_risk_manager_order_number varchar(128) null,
    dfr_loan_safe_risk_manager_html_deal_file_pid bigint null,
    dfr_loan_safe_risk_manager_pdf_deal_file_pid bigint null,
    dfr_loan_safe_fraud_risk_score int null,
    dfr_loan_safe_collateral_risk_score int null,
    dfr_loan_safe_product_type varchar(128) null
);

create table staging_octane.deal_invoice_file
(
    dif_pid bigint
        primary key,
    dif_version int null,
    dif_deal_invoice_file_type varchar(128) null,
    dif_deal_file_pid bigint null,
    dif_deal_invoice_pid bigint null,
    dif_create_datetime timestamp null
);

create table staging_octane.deal_message_log
(
    dmlog_pid bigint
        primary key,
    dmlog_version int null,
    dmlog_deal_pid bigint null,
    dmlog_sent_datetime timestamp null,
    dmlog_delivery_type varchar(128) null,
    dmlog_to_recipients varchar(16000) null,
    dmlog_email_reply_to varchar(256) null,
    dmlog_name varchar(256) null,
    dmlog_email_subject varchar(1024) null,
    dmlog_email_body text null,
    dmlog_sent_securely bit null,
    dmlog_cover_letter_deal_file_pid bigint null,
    dmlog_attachment_deal_file_pid bigint null,
    dmlog_cc_recipients varchar(16000) null,
    dmlog_bcc_recipients varchar(16000) null,
    dmlog_plain_text bit null
);

create table staging_octane.deal_system_file
(
    dsf_pid bigint
        primary key,
    dsf_version int null,
    dsf_deal_pid bigint null,
    dsf_repository_file_pid bigint null
);

create table staging_octane.appraisal_order_request
(
    aprq_pid bigint
        primary key,
    aprq_version int null,
    aprq_deal_pid bigint null,
    aprq_appraisal_pid bigint null,
    aprq_mercury_network_status_request_pid bigint null,
    aprq_appraisal_order_coarse_status_type varchar(128) null,
    aprq_order_id varchar(128) null,
    aprq_order_instructions varchar(1024) null,
    aprq_address_street1 varchar(128) null,
    aprq_address_street2 varchar(128) null,
    aprq_address_city varchar(128) null,
    aprq_address_state varchar(128) null,
    aprq_address_postal_code varchar(128) null,
    aprq_appraisal_fee_amount decimal(15,2) null,
    aprq_order_request_date date null,
    aprq_response_xml_deal_system_file_pid bigint null,
    aprq_mismo_xml_deal_system_file_pid bigint null,
    aprq_appraisal_order_request_type varchar(128) null,
    aprq_status_check_datetime timestamp null,
    aprq_appraisal_management_company_type varchar(128) null,
    aprq_requester_lender_user_pid bigint null,
    aprq_requester_unparsed_name varchar(128) null,
    aprq_requester_agent_type varchar(128) null,
    aprq_vendor_status_unique_id varchar(128) null
);

create table staging_octane.appraisal_order_request_file
(
    aorf_pid bigint
        primary key,
    aorf_version int null,
    aorf_appraisal_order_request_pid bigint null,
    aorf_deal_file_pid bigint null,
    aorf_appraisal_order_request_file_type varchar(128) null,
    aorf_vendor_document_datetime timestamp null,
    aorf_vendor_document_id varchar(128) null
);

create table staging_octane.deal_file_thumbnail
(
    dft_pid bigint
        primary key,
    dft_version int null,
    dft_deal_file_pid bigint null,
    dft_deal_system_file_pid bigint null,
    dft_page_number int null
);

create table staging_octane.du_request
(
    dur_pid bigint
        primary key,
    dur_version int null,
    dur_proposal_pid bigint null,
    dur_proposal_snapshot_pid bigint null,
    dur_uw_findings_html_deal_file_pid bigint null,
    dur_uw_analysis_html_deal_file_pid bigint null,
    dur_uw_findings_pdf_deal_file_pid bigint null,
    dur_uw_findings_xml_provided bit null,
    dur_requester_agent_type varchar(128) null,
    dur_requester_lender_user_pid bigint null,
    dur_requester_unparsed_name varchar(128) null,
    dur_create_datetime timestamp null,
    dur_mismo_version_type varchar(128) null,
    dur_credit_bureau_type varchar(128) null,
    dur_globally_unique_id varchar(128) null,
    dur_response_deal_system_file_pid bigint null,
    dur_du_casefile_id varchar(32) null,
    dur_du_request_status_type varchar(128) null,
    dur_status_message varchar(1024) null,
    dur_mp_status_log varchar(16000) null,
    dur_du_recommendation_type varchar(128) null,
    dur_du_version varchar(16) null,
    dur_du_submission_number int null,
    dur_loan_amount decimal(17,2) null,
    dur_initial_pi_amount decimal(15,2) null,
    dur_note_rate_percent decimal(11,9) null,
    dur_initial_note_rate_percent decimal(11,9) null,
    dur_ltv_ratio_percent decimal(11,9) null,
    dur_cltv_ratio_percent decimal(11,9) null,
    dur_housing_ratio_percent decimal(11,9) null,
    dur_debt_ratio_percent decimal(11,9) null,
    dur_du_ltv_ratio_percent decimal(11,9) null,
    dur_du_cltv_ratio_percent decimal(11,9) null,
    dur_du_housing_ratio_percent decimal(11,9) null,
    dur_du_debt_ratio_percent decimal(11,9) null,
    dur_aus_request_number int null,
    dur_cash_from_borrower_amount decimal(15,2) null,
    dur_aus_cash_from_borrower_amount decimal(15,2) null,
    dur_gse_version_type varchar(128) null
);

create table staging_octane.du_key_finding
(
    dukf_pid bigint
        primary key,
    dukf_version int null,
    dukf_du_request_pid bigint null,
    dukf_du_key_finding_type varchar(128) null,
    dukf_key_finding_result varchar(128) null
);

create table staging_octane.du_refi_plus_finding
(
    durpf_pid bigint
        primary key,
    durpf_version int null,
    durpf_du_request_pid bigint null,
    durpf_description varchar(32) null,
    durpf_value varchar(128) null
);

create table staging_octane.du_request_credit
(
    durc_pid bigint
        primary key,
    durc_version int null,
    durc_du_request_pid bigint null,
    durc_du_casefile_id varchar(32) null,
    durc_create_datetime timestamp null,
    durc_credit_report_create_datetime timestamp null,
    durc_credit_bureau_type varchar(128) null,
    durc_credit_report_identifier varchar(32) null,
    durc_credit_report_name varchar(256) null,
    durc_aus_credit_service_type varchar(128) null,
    durc_borrower_1_borrower_tiny_id_type varchar(128) null,
    durc_borrower_2_borrower_tiny_id_type varchar(128) null
);

create table staging_octane.du_special_feature_code
(
    dusfc_pid bigint
        primary key,
    dusfc_version int null,
    dusfc_du_request_pid bigint null,
    dusfc_special_feature_code varchar(32) null,
    dusfc_special_feature_description varchar(128) null
);

create table staging_octane.flood_cert
(
    fc_pid bigint
        primary key,
    fc_version int null,
    fc_deal_pid bigint null,
    fc_flood_certificate_type varchar(128) null,
    fc_flood_cert_vendor_type varchar(128) null,
    fc_flood_certification_reference_number varchar(32) null,
    fc_flood_cert_effective_date date null,
    fc_nfip_community_name varchar(256) null,
    fc_nfip_counties varchar(256) null,
    fc_nfip_state varchar(2) null,
    fc_nfip_community_number varchar(16) null,
    fc_nfip_community_firm_date date null,
    fc_nfip_community_participation_start_date date null,
    fc_flood_partial varchar(128) null,
    fc_nfip_map_number varchar(8) null,
    fc_nfip_map_panel varchar(8) null,
    fc_nfip_map_panel_suffix varchar(8) null,
    fc_nfip_map_panel_date date null,
    fc_nfip_map_exists varchar(128) null,
    fc_nfip_letter_of_map_date date null,
    fc_nfip_letter_of_map_case_number varchar(32) null,
    fc_fema_flood_zone_designation_type varchar(128) null,
    fc_nfip_community_participation_status_type varchar(128) null,
    fc_protected_area varchar(128) null,
    fc_protected_area_designation_date date null,
    fc_special_flood_hazard_area varchar(128) null,
    fc_property_county_fips varchar(32) null,
    fc_property_state_fips varchar(32) null,
    fc_flood_cert_deal_file_pid bigint null,
    fc_property_address_city varchar(128) null,
    fc_property_address_country varchar(128) null,
    fc_property_address_postal_code varchar(128) null,
    fc_property_address_state varchar(128) null,
    fc_property_address_street1 varchar(128) null,
    fc_property_address_street2 varchar(128) null,
    fc_property_county_name varchar(128) null,
    fc_clg_flood_cert_messages text null,
    fc_clg_flood_cert_status_type varchar(128) null,
    fc_clg_flood_cert_request_datetime timestamp null,
    fc_clg_flood_cert_requester_agent_type varchar(128) null,
    fc_clg_flood_cert_requester_lender_user_pid bigint null,
    fc_clg_flood_cert_requester_unparsed_name varchar(128) null
);

create table staging_octane.hmda_report_request
(
    hrr_pid bigint
        primary key,
    hrr_version int null,
    hrr_account_pid bigint null,
    hrr_create_datetime timestamp null,
    hrr_start_datetime timestamp null,
    hrr_end_datetime timestamp null,
    hrr_request_status_type varchar(128) null,
    hrr_request_status_messages text null,
    hrr_requester_unparsed_name varchar(128) null,
    hrr_row_count int null,
    hrr_from_date date null,
    hrr_through_date date null,
    hrr_error_protection bit null,
    hrr_error_limit int null,
    hrr_repository_file_pid bigint null
);

create table staging_octane.lender_user_photo
(
    lup_pid bigint
        primary key,
    lup_version int null,
    lup_lender_user_pid bigint null,
    lup_repository_file_pid bigint null
);

create table staging_octane.lp_request
(
    lpr_pid bigint
        primary key,
    lpr_version int null,
    lpr_proposal_pid bigint null,
    lpr_proposal_snapshot_pid bigint null,
    lpr_full_feedback_pdf_deal_file_pid bigint null,
    lpr_hve_pdf_deal_file_pid bigint null,
    lpr_requester_agent_type varchar(128) null,
    lpr_requester_lender_user_pid bigint null,
    lpr_requester_unparsed_name varchar(128) null,
    lpr_create_datetime timestamp null,
    lpr_lp_interface_version_type varchar(128) null,
    lpr_lp_dtd_version_type varchar(128) null,
    lpr_mismo_version_type varchar(128) null,
    lpr_fre_lp_transaction_id varchar(32) null,
    lpr_lp_transaction_id varchar(32) null,
    lpr_globally_unique_id varchar(128) null,
    lpr_lp_request_status_type varchar(128) null,
    lpr_lp_evaluation_status_type varchar(128) null,
    lpr_status_messages text null,
    lpr_xml_response_deal_system_file_pid bigint null,
    lpr_loan_amount decimal(17,2) null,
    lpr_initial_pi_amount decimal(15,2) null,
    lpr_note_rate_percent decimal(11,9) null,
    lpr_initial_note_rate_percent decimal(11,9) null,
    lpr_ltv_ratio_percent decimal(11,9) null,
    lpr_cltv_ratio_percent decimal(11,9) null,
    lpr_hcltv_ratio_percent decimal(11,9) null,
    lpr_hcltv_applicable bit null,
    lpr_housing_ratio_percent decimal(11,9) null,
    lpr_debt_ratio_percent decimal(11,9) null,
    lpr_lp_ltv_ratio_percent decimal(11,9) null,
    lpr_lp_total_ltv_ratio_percent decimal(11,9) null,
    lpr_lp_high_total_ltv_ratio_percent decimal(11,9) null,
    lpr_lp_housing_ratio_percent decimal(11,9) null,
    lpr_lp_debt_ratio_percent decimal(11,9) null,
    lpr_lp_submission_number int null,
    lpr_lp_credit_risk_classification_type varchar(128) null,
    lpr_fre_doc_level_description_type varchar(128) null,
    lpr_fre_purchase_eligibility_type varchar(128) null,
    lpr_lp_case_state_type varchar(128) null,
    lpr_lp_async_id varchar(128) null,
    lpr_lp_async_polling_interval int null,
    lpr_lp_total_funds_to_be_verified_amount decimal(15,2) null,
    lpr_lp_required_borrower_funds_amount decimal(15,2) null,
    lpr_lp_paid_off_debt_amount decimal(15,2) null,
    lpr_lp_required_reserves_amount decimal(15,2) null,
    lpr_lp_total_eligible_assets_amount decimal(15,2) null,
    lpr_lp_proceeds_from_subordinate_financing_amount decimal(15,2) null,
    lpr_lp_calculated_reserves_amount decimal(15,2) null,
    lpr_aus_request_number int null,
    lpr_cash_from_borrower_amount decimal(15,2) null,
    lpr_aus_cash_from_borrower_amount decimal(15,2) null,
    lpr_gse_version_type varchar(128) null
);

create table staging_octane.credit_request
(
    crdr_pid bigint
        primary key,
    crdr_version int null,
    crdr_deal_pid bigint null,
    crdr_credit_report_file_pid bigint null,
    crdr_credit_score_disclosure_file_pid bigint null,
    crdr_create_datetime timestamp null,
    crdr_requester_agent_type varchar(128) null,
    crdr_requester_lender_user_pid bigint null,
    crdr_requester_unparsed_name varchar(128) null,
    crdr_credit_request_via_type varchar(128) null,
    crdr_lp_request_pid bigint null,
    crdr_du_request_pid bigint null,
    crdr_mismo_version_type varchar(128) null,
    crdr_credit_bureau_type varchar(128) null,
    crdr_credit_report_request_action_type varchar(128) null,
    crdr_credit_report_type varchar(128) null,
    crdr_credit_report_product_description varchar(32) null,
    crdr_credit_request_type varchar(128) null,
    crdr_credit_repositories_selected_count int null,
    crdr_equifax_included bit null,
    crdr_experian_included bit null,
    crdr_trans_union_included bit null,
    crdr_borrower1_first_name varchar(32) null,
    crdr_borrower1_middle_name varchar(32) null,
    crdr_borrower1_last_name varchar(32) null,
    crdr_borrower1_name_suffix varchar(32) null,
    crdr_borrower1_birth_date date null,
    crdr_borrower1_residence_city varchar(128) null,
    crdr_borrower1_residence_country varchar(128) null,
    crdr_borrower1_residence_postal_code varchar(128) null,
    crdr_borrower1_residence_state varchar(128) null,
    crdr_borrower1_residence_street1 varchar(128) null,
    crdr_borrower1_residence_street2 varchar(128) null,
    crdr_borrower1_experian_credit_score int null,
    crdr_borrower1_equifax_credit_score int null,
    crdr_borrower1_trans_union_credit_score int null,
    crdr_borrower1_equifax_credit_score_model_type varchar(128) null,
    crdr_borrower1_experian_credit_score_model_type varchar(128) null,
    crdr_borrower1_trans_union_credit_score_model_type varchar(128) null,
    crdr_borrower2_first_name varchar(32) null,
    crdr_borrower2_middle_name varchar(32) null,
    crdr_borrower2_last_name varchar(32) null,
    crdr_borrower2_name_suffix varchar(32) null,
    crdr_borrower2_birth_date date null,
    crdr_borrower2_residence_city varchar(128) null,
    crdr_borrower2_residence_country varchar(128) null,
    crdr_borrower2_residence_postal_code varchar(128) null,
    crdr_borrower2_residence_state varchar(128) null,
    crdr_borrower2_residence_street1 varchar(128) null,
    crdr_borrower2_residence_street2 varchar(128) null,
    crdr_borrower2_experian_credit_score int null,
    crdr_borrower2_equifax_credit_score int null,
    crdr_borrower2_trans_union_credit_score int null,
    crdr_borrower2_equifax_credit_score_model_type varchar(128) null,
    crdr_borrower2_experian_credit_score_model_type varchar(128) null,
    crdr_borrower2_trans_union_credit_score_model_type varchar(128) null,
    crdr_contains_importable_data bit null,
    crdr_credit_report_identifier varchar(32) null,
    crdr_credit_report_price decimal(15,2) null,
    crdr_credit_request_status_type varchar(128) null,
    crdr_request_error_messages text null,
    crdr_bureau_status_messages text null,
    crdr_bureau_credit_report_url varchar(1024) null,
    crdr_last_status_query_datetime timestamp null,
    crdr_xml_response_file_pid bigint null
);

create table staging_octane.borrower
(
    b_pid bigint
        primary key,
    b_version int null,
    b_alimony_child_support varchar(128) null,
    b_alimony_child_support_explanation varchar(128) null,
    b_application_pid bigint null,
    b_application_signed_date date null,
    b_application_taken_method_type varchar(128) null,
    b_bankruptcy varchar(128) null,
    b_bankruptcy_explanation varchar(128) null,
    b_birth_date date null,
    b_borrowed_down_payment varchar(128) null,
    b_borrowed_down_payment_explanation varchar(128) null,
    b_applicant_role_type varchar(128) null,
    b_required_to_sign bit null,
    b_spousal_homestead varchar(128) null,
    b_has_no_ssn bit null,
    b_citizenship_residency_type varchar(128) null,
    b_credit_request_pid bigint null,
    b_credit_report_identifier varchar(32) null,
    b_credit_report_authorization bit null,
    b_has_dependents varchar(128) null,
    b_dependent_count int null,
    b_dependents_age_years varchar(32) null,
    b_email varchar(256) null,
    b_fax varchar(32) null,
    b_first_name varchar(32) null,
    b_nickname varchar(32) null,
    b_first_time_homebuyer bit null,
    b_lender_employee varchar(128) null,
    b_lender_employee_status_confirmed bit null,
    b_sex_refused varchar(128) null,
    b_sex_collected_visual_or_surname varchar(128) null,
    b_sex_male bit null,
    b_sex_female bit null,
    b_sex_not_obtainable bit null,
    b_ethnicity_refused varchar(128) null,
    b_ethnicity_collected_visual_or_surname varchar(128) null,
    b_ethnicity_hispanic_or_latino bit null,
    b_ethnicity_mexican bit null,
    b_ethnicity_puerto_rican bit null,
    b_ethnicity_cuban bit null,
    b_ethnicity_other_hispanic_or_latino bit null,
    b_ethnicity_other_hispanic_or_latino_description varchar(100) null,
    b_ethnicity_not_hispanic_or_latino bit null,
    b_ethnicity_not_obtainable bit null,
    b_homeowner_past_three_years varchar(128) null,
    b_home_phone varchar(32) null,
    b_intend_to_occupy varchar(128) null,
    b_last_name varchar(32) null,
    b_mailing_place_pid bigint null,
    b_marital_status_type varchar(128) null,
    b_spouse_borrower_pid bigint null,
    b_middle_name varchar(32) null,
    b_mobile_phone varchar(32) null,
    b_name_suffix varchar(32) null,
    b_note_endorser varchar(128) null,
    b_note_endorser_explanation varchar(128) null,
    b_obligated_loan_foreclosure varchar(128) null,
    b_obligated_loan_foreclosure_explanation varchar(128) null,
    b_office_phone varchar(32) null,
    b_office_phone_extension varchar(16) null,
    b_other_race_national_origin_description varchar(32) null,
    b_outstanding_judgements varchar(128) null,
    b_outstanding_judgments_explanation varchar(128) null,
    b_party_to_lawsuit varchar(128) null,
    b_party_to_lawsuit_explanation varchar(128) null,
    b_power_of_attorney varchar(128) null,
    b_power_of_attorney_signing_capacity varchar(1024) null,
    b_power_of_attorney_first_name varchar(32) null,
    b_power_of_attorney_last_name varchar(32) null,
    b_power_of_attorney_middle_name varchar(32) null,
    b_power_of_attorney_name_suffix varchar(32) null,
    b_power_of_attorney_company_name varchar(128) null,
    b_power_of_attorney_title varchar(128) null,
    b_power_of_attorney_office_phone varchar(32) null,
    b_power_of_attorney_office_phone_extension varchar(16) null,
    b_power_of_attorney_mobile_phone varchar(32) null,
    b_power_of_attorney_email varchar(256) null,
    b_power_of_attorney_fax varchar(32) null,
    b_power_of_attorney_city varchar(128) null,
    b_power_of_attorney_country varchar(128) null,
    b_power_of_attorney_postal_code varchar(128) null,
    b_power_of_attorney_state varchar(128) null,
    b_power_of_attorney_street1 varchar(128) null,
    b_power_of_attorney_street2 varchar(128) null,
    b_presently_delinquent varchar(128) null,
    b_presently_delinquent_explanation varchar(128) null,
    b_prior_property_title_type varchar(128) null,
    b_prior_property_usage_type varchar(128) null,
    b_property_foreclosure varchar(128) null,
    b_property_foreclosure_explanation varchar(128) null,
    b_race_refused varchar(128) null,
    b_race_collected_visual_or_surname varchar(128) null,
    b_race_american_indian_or_alaska_native bit null,
    b_race_other_american_indian_or_alaska_native_description varchar(100) null,
    b_race_asian bit null,
    b_race_asian_indian bit null,
    b_race_chinese bit null,
    b_race_filipino bit null,
    b_race_japanese bit null,
    b_race_korean bit null,
    b_race_vietnamese bit null,
    b_race_other_asian bit null,
    b_race_other_asian_description varchar(100) null,
    b_race_black_or_african_american bit null,
    b_race_information_not_provided bit null,
    b_race_national_origin_refusal bit null,
    b_race_native_hawaiian_or_other_pacific_islander bit null,
    b_race_native_hawaiian bit null,
    b_race_guamanian_or_chamorro bit null,
    b_race_samoan bit null,
    b_race_other_pacific_islander bit null,
    b_race_not_obtainable bit null,
    b_race_other_pacific_islander_description varchar(100) null,
    b_race_not_applicable bit null,
    b_race_white bit null,
    b_schooling_years int null,
    b_titleholder varchar(128) null,
    b_experian_credit_score int null,
    b_equifax_credit_score int null,
    b_trans_union_credit_score int null,
    b_decision_credit_score int null,
    b_borrower_tiny_id_type varchar(128) null,
    b_first_time_home_buyer_explain varchar(1024) null,
    b_first_time_home_buyer_auto_compute bit null,
    b_caivrs_id varchar(16) null,
    b_caivrs_messages text null,
    b_on_ldp_list varchar(128) null,
    b_on_gsa_list varchar(128) null,
    b_monthly_job_federal_tax_amount decimal(15,2) null,
    b_monthly_job_state_tax_amount decimal(15,2) null,
    b_monthly_job_retirement_tax_amount decimal(15,2) null,
    b_monthly_job_medicare_tax_amount decimal(15,2) null,
    b_monthly_job_state_disability_insurance_amount decimal(15,2) null,
    b_monthly_job_other_tax_1_amount decimal(15,2) null,
    b_monthly_job_other_tax_1_description varchar(128) null,
    b_monthly_job_other_tax_2_amount decimal(15,2) null,
    b_monthly_job_other_tax_2_description varchar(128) null,
    b_monthly_job_other_tax_3_amount decimal(15,2) null,
    b_monthly_job_other_tax_3_description varchar(128) null,
    b_monthly_job_total_tax_amount decimal(15,2) null,
    b_homeownership_education_type varchar(128) null,
    b_homeownership_education_agency_type varchar(128) null,
    b_homeownership_education_id varchar(128) null,
    b_homeownership_education_name varchar(128) null,
    b_homeownership_education_complete_date date null,
    b_housing_counseling_type varchar(128) null,
    b_housing_counseling_agency_type varchar(128) null,
    b_housing_counseling_id varchar(128) null,
    b_housing_counseling_name varchar(128) null,
    b_housing_counseling_complete_date date null,
    b_legal_entity_type varchar(128) null,
    b_credit_report_authorization_datetime timestamp null,
    b_credit_report_authorization_method varchar(128) null,
    b_credit_report_authorization_obtained_by_unparsed_name varchar(128) null,
    b_disabled varchar(128) null,
    b_usda_annual_child_care_expenses decimal(15,2) null,
    b_usda_disability_expenses decimal(15,2) null,
    b_usda_medical_expenses decimal(15,2) null,
    b_usda_income_from_assets decimal(15,2) null,
    b_usda_moderate_income_limit decimal(15,2) null,
    b_hud_employee bit null,
    b_relationship_to_primary_borrower_type varchar(128) null,
    b_relationship_to_seller_type varchar(128) null,
    b_preferred_first_name varchar(32) null
);

create index idx_borrower_1
    on staging_octane.borrower (b_last_name);

create index idx_borrower_2
    on staging_octane.borrower (b_email);

create index idx_borrower_3
    on staging_octane.borrower (b_home_phone);

create index idx_borrower_4
    on staging_octane.borrower (b_mobile_phone);

create index idx_borrower_5
    on staging_octane.borrower (b_office_phone);

create table staging_octane.borrower_alias
(
    ba_pid bigint
        primary key,
    ba_version int null,
    ba_account_number varchar(32) null,
    ba_borrower_pid bigint null,
    ba_credit_request_pid bigint null,
    ba_creditor_name varchar(32) null,
    ba_first_name varchar(32) null,
    ba_last_name varchar(32) null,
    ba_middle_name varchar(32) null,
    ba_name_suffix varchar(32) null,
    ba_credit_report_identifier varchar(32) null
);

create table staging_octane.borrower_asset
(
    bas_pid bigint
        primary key,
    bas_version int null,
    bas_borrower_pid bigint null,
    bas_asset_pid bigint null
);

create table staging_octane.borrower_associated_address
(
    baa_pid bigint
        primary key,
    baa_version int null,
    baa_borrower_pid bigint null,
    baa_credit_request_pid bigint null,
    baa_credit_report_identifier varchar(32) null,
    baa_borrower_associated_address_source_type varchar(128) null,
    baa_reported_month int null,
    baa_reported_year int null,
    baa_reported_date_verified bit null,
    baa_reported_address_street1 varchar(128) null,
    baa_reported_address_street2 varchar(128) null,
    baa_reported_address_city varchar(128) null,
    baa_reported_address_state varchar(128) null,
    baa_reported_address_postal_code varchar(128) null,
    baa_reported_address_country varchar(16) null,
    baa_current varchar(128) null,
    baa_internal_note varchar(1024) null,
    baa_requires_explanation bit null,
    baa_force_requires_explanation bit null,
    baa_borrower_associated_address_explanation_type varchar(128) null,
    baa_explanation_type_other_explanation varchar(128) null,
    baa_typo_of_loan_app_address varchar(128) null,
    baa_known_to_borrower varchar(128) null,
    baa_owned_by_borrower varchar(128) null,
    baa_resided_at_address varchar(128) null,
    baa_used_as_mailing_address varchar(128) null,
    baa_current_mailing_address varchar(128) null,
    baa_current_residence varchar(128) null,
    baa_borrower_resided_at_address_after_date varchar(128) null
);

create table staging_octane.borrower_dependent
(
    bd_pid bigint
        primary key,
    bd_version int null,
    bd_borrower_pid bigint null,
    bd_first_name varchar(32) null,
    bd_last_name varchar(32) null,
    bd_age int null,
    bd_disabled varchar(128) null,
    bd_full_time_student varchar(128) null,
    bd_receives_income varchar(128) null,
    bd_income_source text null,
    bd_income_amount decimal(15,2) null
);

create table staging_octane.borrower_income
(
    bi_pid bigint
        primary key,
    bi_version int null,
    bi_borrower_pid bigint null,
    bi_borrower_income_category_type varchar(128) null,
    bi_job_gap_reason_type varchar(128) null,
    bi_job_gap_reason_explanation varchar(1024) null,
    bi_business_ownership_type varchar(128) null,
    bi_from_date date null,
    bi_through_date date null,
    bi_current bit null,
    bi_primary bit null,
    bi_source_name varchar(128) null,
    bi_source_address_street1 varchar(128) null,
    bi_source_address_street2 varchar(128) null,
    bi_source_address_city varchar(128) null,
    bi_source_address_state varchar(128) null,
    bi_source_address_postal_code varchar(128) null,
    bi_source_address_country varchar(128) null,
    bi_source_phone varchar(32) null,
    bi_source_phone_extension varchar(16) null,
    bi_synthetic_unique bit null
);

create table staging_octane.borrower_job_gap
(
    bjg_pid bigint
        primary key,
    bjg_version int null,
    bjg_borrower_pid bigint null,
    bjg_from_date date null,
    bjg_through_date date null,
    bjg_primary_job bit null
);

create table staging_octane.borrower_user_deal
(
    bud_pid bigint
        primary key,
    bud_version int null,
    bud_borrower_user_pid bigint null,
    bud_deal_pid bigint null,
    bud_borrower_pid bigint null,
    bud_borrower_user_deal_access_type varchar(128) null,
    bud_loan_key varchar(128) null,
    bud_electronic_transaction_consent bit null,
    bud_electronic_transaction_consent_datetime timestamp null,
    bud_electronic_transaction_consent_ip_address varchar(32) null,
    bud_create_datetime timestamp null
);

create table staging_octane.borrower_user_change_email
(
    buce_pid bigint
        primary key,
    buce_version int null,
    buce_borrower_user_pid bigint null,
    buce_create_datetime timestamp null,
    buce_change_email_id varchar(128) null,
    buce_email varchar(256) null,
    buce_borrower_user_deal_pid bigint null
);

create index idx_borrower_user_change_email_1
    on staging_octane.borrower_user_change_email (buce_change_email_id);

create index idx_borrower_user_change_email_2
    on staging_octane.borrower_user_change_email (buce_email);

create index idx_borrower_user_deal_1
    on staging_octane.borrower_user_deal (bud_loan_key);

create table staging_octane.business_income
(
    bui_pid bigint
        primary key,
    bui_version int null,
    bui_borrower_income_pid bigint null,
    bui_business_income_type varchar(128) null,
    bui_business_disposition_type varchar(128) null,
    bui_company_ein varchar(16) null,
    bui_estimated_net_income_amount decimal(15,2) null,
    bui_estimated_mode bit null,
    bui_worksheet_monthly_total_amount decimal(15,2) null,
    bui_monthly_total_amount decimal(15,2) null,
    bui_borrower_income_percent decimal(11,9) null,
    bui_calc_method_type varchar(128) null,
    bui_common_year1_year int null,
    bui_common_year1_year_include bit null,
    bui_common_year1_from_date date null,
    bui_common_year1_through_date date null,
    bui_common_year1_months decimal(4,2) null,
    bui_common_year1_annual_total_amount decimal(15,2) null,
    bui_common_year1_monthly_total_amount decimal(15,2) null,
    bui_common_year2_year int null,
    bui_common_year2_year_include bit null,
    bui_common_year2_from_date date null,
    bui_common_year2_through_date date null,
    bui_common_year2_months decimal(4,2) null,
    bui_common_year2_annual_total_amount decimal(15,2) null,
    bui_common_year2_monthly_total_amount decimal(15,2) null,
    bui_common_year3_year int null,
    bui_common_year3_year_include bit null,
    bui_common_year3_from_date date null,
    bui_common_year3_through_date date null,
    bui_common_year3_months decimal(4,2) null,
    bui_common_year3_annual_total_amount decimal(15,2) null,
    bui_common_year3_monthly_total_amount decimal(15,2) null,
    bui_sole_year1_gross_receipts decimal(15,2) null,
    bui_sole_year1_other_income_loss_exp decimal(15,2) null,
    bui_sole_year1_depletion decimal(15,2) null,
    bui_sole_year1_depreciation decimal(15,2) null,
    bui_sole_year1_meal_exclusions decimal(15,2) null,
    bui_sole_year1_business_use_home decimal(15,2) null,
    bui_sole_year1_amortization_loss decimal(15,2) null,
    bui_sole_year1_business_miles int null,
    bui_sole_year1_depreciation_mile decimal(11,9) null,
    bui_sole_year1_mileage_depreciation decimal(15,2) null,
    bui_sole_year2_gross_receipts decimal(15,2) null,
    bui_sole_year2_other_income_loss_exp decimal(15,2) null,
    bui_sole_year2_depletion decimal(15,2) null,
    bui_sole_year2_depreciation decimal(15,2) null,
    bui_sole_year2_meal_exclusions decimal(15,2) null,
    bui_sole_year2_business_use_home decimal(15,2) null,
    bui_sole_year2_amortization_loss decimal(15,2) null,
    bui_sole_year2_business_miles int null,
    bui_sole_year2_depreciation_mile decimal(11,9) null,
    bui_sole_year2_mileage_depreciation decimal(15,2) null,
    bui_sole_year3_gross_receipts decimal(15,2) null,
    bui_sole_year3_other_income_loss_exp decimal(15,2) null,
    bui_sole_year3_depletion decimal(15,2) null,
    bui_sole_year3_depreciation decimal(15,2) null,
    bui_sole_year3_meal_exclusions decimal(15,2) null,
    bui_sole_year3_business_use_home decimal(15,2) null,
    bui_sole_year3_amortization_loss decimal(15,2) null,
    bui_sole_year3_business_miles int null,
    bui_sole_year3_depreciation_mile decimal(11,9) null,
    bui_sole_year3_mileage_depreciation decimal(15,2) null,
    bui_partner_year1_amortization_loss decimal(15,2) null,
    bui_partner_year1_depletion decimal(15,2) null,
    bui_partner_year1_depreciation decimal(15,2) null,
    bui_partner_year1_guaranteed_payments decimal(15,2) null,
    bui_partner_year1_meals_exclusion decimal(15,2) null,
    bui_partner_year1_net_rental_income_loss decimal(15,2) null,
    bui_partner_year1_notes_payable_less_year decimal(15,2) null,
    bui_partner_year1_ordinary_income_loss decimal(15,2) null,
    bui_partner_year1_other_income_loss decimal(15,2) null,
    bui_partner_year1_ownership_percent decimal(11,9) null,
    bui_partner_year1_form_k_1_total decimal(15,2) null,
    bui_partner_year1_form_1065_subtotal decimal(15,2) null,
    bui_partner_year1_form_1065_total decimal(15,2) null,
    bui_partner_year2_amortization_loss decimal(15,2) null,
    bui_partner_year2_depletion decimal(15,2) null,
    bui_partner_year2_depreciation decimal(15,2) null,
    bui_partner_year2_guaranteed_payments decimal(15,2) null,
    bui_partner_year2_meals_exclusion decimal(15,2) null,
    bui_partner_year2_net_rental_income_loss decimal(15,2) null,
    bui_partner_year2_notes_payable_less_year decimal(15,2) null,
    bui_partner_year2_ordinary_income_loss decimal(15,2) null,
    bui_partner_year2_other_income_loss decimal(15,2) null,
    bui_partner_year2_ownership_percent decimal(11,9) null,
    bui_partner_year2_form_k_1_total decimal(15,2) null,
    bui_partner_year2_form_1065_subtotal decimal(15,2) null,
    bui_partner_year2_form_1065_total decimal(15,2) null,
    bui_partner_year3_amortization_loss decimal(15,2) null,
    bui_partner_year3_depletion decimal(15,2) null,
    bui_partner_year3_depreciation decimal(15,2) null,
    bui_partner_year3_guaranteed_payments decimal(15,2) null,
    bui_partner_year3_meals_exclusion decimal(15,2) null,
    bui_partner_year3_net_rental_income_loss decimal(15,2) null,
    bui_partner_year3_notes_payable_less_year decimal(15,2) null,
    bui_partner_year3_ordinary_income_loss decimal(15,2) null,
    bui_partner_year3_other_income_loss decimal(15,2) null,
    bui_partner_year3_ownership_percent decimal(11,9) null,
    bui_partner_year3_form_k_1_total decimal(15,2) null,
    bui_partner_year3_form_1065_subtotal decimal(15,2) null,
    bui_partner_year3_form_1065_total decimal(15,2) null,
    bui_form_1065_available bit null,
    bui_scorp_year1_ordinary_income_loss decimal(15,2) null,
    bui_scorp_year1_net_rental_income_loss decimal(15,2) null,
    bui_scorp_year1_other_income_loss decimal(15,2) null,
    bui_scorp_year1_depletion decimal(15,2) null,
    bui_scorp_year1_depreciation decimal(15,2) null,
    bui_scorp_year1_amortization_loss decimal(15,2) null,
    bui_scorp_year1_notes_payable_less_year decimal(15,2) null,
    bui_scorp_year1_meals_exclusion decimal(15,2) null,
    bui_scorp_year1_ownership_percent decimal(11,9) null,
    bui_scorp_year1_form_k_1_total decimal(15,2) null,
    bui_scorp_year1_form_1120s_subtotal decimal(15,2) null,
    bui_scorp_year1_form_1120s_total decimal(15,2) null,
    bui_scorp_year2_ordinary_income_loss decimal(15,2) null,
    bui_scorp_year2_net_rental_income_loss decimal(15,2) null,
    bui_scorp_year2_other_income_loss decimal(15,2) null,
    bui_scorp_year2_depletion decimal(15,2) null,
    bui_scorp_year2_depreciation decimal(15,2) null,
    bui_scorp_year2_amortization_loss decimal(15,2) null,
    bui_scorp_year2_notes_payable_less_year decimal(15,2) null,
    bui_scorp_year2_meals_exclusion decimal(15,2) null,
    bui_scorp_year2_ownership_percent decimal(11,9) null,
    bui_scorp_year2_form_k_1_total decimal(15,2) null,
    bui_scorp_year2_form_1120s_subtotal decimal(15,2) null,
    bui_scorp_year2_form_1120s_total decimal(15,2) null,
    bui_scorp_year3_ordinary_income_loss decimal(15,2) null,
    bui_scorp_year3_net_rental_income_loss decimal(15,2) null,
    bui_scorp_year3_other_income_loss decimal(15,2) null,
    bui_scorp_year3_depletion decimal(15,2) null,
    bui_scorp_year3_depreciation decimal(15,2) null,
    bui_scorp_year3_amortization_loss decimal(15,2) null,
    bui_scorp_year3_notes_payable_less_year decimal(15,2) null,
    bui_scorp_year3_meals_exclusion decimal(15,2) null,
    bui_scorp_year3_ownership_percent decimal(11,9) null,
    bui_scorp_year3_form_k_1_total decimal(15,2) null,
    bui_scorp_year3_form_1120s_subtotal decimal(15,2) null,
    bui_scorp_year3_form_1120s_total decimal(15,2) null,
    bui_form_1120s_available bit null,
    bui_corp_year1_taxable_income decimal(15,2) null,
    bui_corp_year1_total_tax decimal(15,2) null,
    bui_corp_year1_gain_loss decimal(15,2) null,
    bui_corp_year1_other_income_loss decimal(15,2) null,
    bui_corp_year1_depreciation decimal(15,2) null,
    bui_corp_year1_depletion decimal(15,2) null,
    bui_corp_year1_domestic_production_activities decimal(15,2) null,
    bui_corp_year1_other_deductions decimal(15,2) null,
    bui_corp_year1_net_operating_loss_special_deductions decimal(15,2) null,
    bui_corp_year1_notes_payable_less_one_year decimal(15,2) null,
    bui_corp_year1_meals_exclusion decimal(15,2) null,
    bui_corp_year1_dividends_paid_to_borrower decimal(15,2) null,
    bui_corp_year1_annual_subtotal decimal(15,2) null,
    bui_corp_year1_ownership_percent decimal(11,9) null,
    bui_corp_year1_annual_subtotal_ownership_applied decimal(15,2) null,
    bui_corp_year2_taxable_income decimal(15,2) null,
    bui_corp_year2_total_tax decimal(15,2) null,
    bui_corp_year2_gain_loss decimal(15,2) null,
    bui_corp_year2_other_income_loss decimal(15,2) null,
    bui_corp_year2_depreciation decimal(15,2) null,
    bui_corp_year2_depletion decimal(15,2) null,
    bui_corp_year2_domestic_production_activities decimal(15,2) null,
    bui_corp_year2_other_deductions decimal(15,2) null,
    bui_corp_year2_net_operating_loss_special_deductions decimal(15,2) null,
    bui_corp_year2_notes_payable_less_one_year decimal(15,2) null,
    bui_corp_year2_meals_exclusion decimal(15,2) null,
    bui_corp_year2_dividends_paid_to_borrower decimal(15,2) null,
    bui_corp_year2_annual_subtotal decimal(15,2) null,
    bui_corp_year2_ownership_percent decimal(11,9) null,
    bui_corp_year2_annual_subtotal_ownership_applied decimal(15,2) null,
    bui_corp_year3_taxable_income decimal(15,2) null,
    bui_corp_year3_total_tax decimal(15,2) null,
    bui_corp_year3_gain_loss decimal(15,2) null,
    bui_corp_year3_other_income_loss decimal(15,2) null,
    bui_corp_year3_depreciation decimal(15,2) null,
    bui_corp_year3_depletion decimal(15,2) null,
    bui_corp_year3_domestic_production_activities decimal(15,2) null,
    bui_corp_year3_other_deductions decimal(15,2) null,
    bui_corp_year3_net_operating_loss_special_deductions decimal(15,2) null,
    bui_corp_year3_notes_payable_less_one_year decimal(15,2) null,
    bui_corp_year3_meals_exclusion decimal(15,2) null,
    bui_corp_year3_dividends_paid_to_borrower decimal(15,2) null,
    bui_corp_year3_annual_subtotal decimal(15,2) null,
    bui_corp_year3_ownership_percent decimal(11,9) null,
    bui_corp_year3_annual_subtotal_ownership_applied decimal(15,2) null,
    bui_sch_f_year1_specific_income_loss decimal(15,2) null,
    bui_sch_f_year1_nonrecurring_income_loss decimal(15,2) null,
    bui_sch_f_year1_depreciation decimal(15,2) null,
    bui_sch_f_year1_amortization_loss_depletion decimal(15,2) null,
    bui_sch_f_year1_business_use_home decimal(15,2) null,
    bui_sch_f_year2_specific_income_loss decimal(15,2) null,
    bui_sch_f_year2_nonrecurring_income_loss decimal(15,2) null,
    bui_sch_f_year2_depreciation decimal(15,2) null,
    bui_sch_f_year2_amortization_loss_depletion decimal(15,2) null,
    bui_sch_f_year2_business_use_home decimal(15,2) null,
    bui_sch_f_year3_specific_income_loss decimal(15,2) null,
    bui_sch_f_year3_nonrecurring_income_loss decimal(15,2) null,
    bui_sch_f_year3_depreciation decimal(15,2) null,
    bui_sch_f_year3_amortization_loss_depletion decimal(15,2) null,
    bui_sch_f_year3_business_use_home decimal(15,2) null,
    bui_underwriter_comments varchar(1024) null
);

create table staging_octane.consumer_privacy_affected_borrower
(
    cpab_pid bigint
        primary key,
    cpab_version int null,
    cpab_consumer_privacy_request_pid bigint null,
    cpab_deal_pid bigint null,
    cpab_borrower_pid bigint null
);

create table staging_octane.job_income
(
    ji_pid bigint
        primary key,
    ji_version int null,
    ji_borrower_income_pid bigint null,
    ji_estimated_mode bit null,
    ji_line_of_work_years int null,
    ji_voe_written_required bit null,
    ji_voe_written_system bit null,
    ji_voe_written_forced bit null,
    ji_base_income_calc_method_type varchar(128) null,
    ji_monthly_base_unadjusted_amount decimal(15,2) null,
    ji_monthly_base_adjustment_amount decimal(15,2) null,
    ji_overtime_income_calc_method_type varchar(128) null,
    ji_monthly_overtime_unadjusted_amount decimal(15,2) null,
    ji_monthly_overtime_adjustment_amount decimal(15,2) null,
    ji_bonus_income_calc_method_type varchar(128) null,
    ji_monthly_bonus_unadjusted_amount decimal(15,2) null,
    ji_monthly_bonus_adjustment_amount decimal(15,2) null,
    ji_commissions_income_calc_method_type varchar(128) null,
    ji_monthly_commissions_unadjusted_amount decimal(15,2) null,
    ji_monthly_commissions_adjustment_amount decimal(15,2) null,
    ji_tip_income_calc_method_type varchar(128) null,
    ji_monthly_tip_unadjusted_amount decimal(15,2) null,
    ji_monthly_tip_adjustment_amount decimal(15,2) null,
    ji_adjustment_income_calc_method_type varchar(128) null,
    ji_monthly_adjustment_amount decimal(15,2) null,
    ji_position varchar(32) null,
    ji_employer_relative bit null,
    ji_employer_property_seller bit null,
    ji_employer_real_estate_broker bit null,
    ji_military_job bit null,
    ji_estimated_monthly_military_amount decimal(15,2) null,
    ji_monthly_military_base_pay_amount decimal(15,2) null,
    ji_monthly_military_clothes_allowance_ungrossed_amount decimal(15,2) null,
    ji_monthly_military_combat_pay_amount decimal(15,2) null,
    ji_monthly_military_flight_pay_amount decimal(15,2) null,
    ji_monthly_military_hazard_pay_amount decimal(15,2) null,
    ji_monthly_military_housing_allowance_ungrossed_amount decimal(15,2) null,
    ji_monthly_military_overseas_pay_amount decimal(15,2) null,
    ji_monthly_military_prop_pay_amount decimal(15,2) null,
    ji_monthly_military_quarters_allowance_ungrossed_amount decimal(15,2) null,
    ji_monthly_military_rations_allowance_ungrossed_amount decimal(15,2) null,
    ji_military_gross_up bit null,
    ji_military_gross_up_percent decimal(11,9) null,
    ji_monthly_military_clothes_allowance_amount decimal(15,2) null,
    ji_monthly_military_quarters_allowance_amount decimal(15,2) null,
    ji_monthly_military_rations_allowance_amount decimal(15,2) null,
    ji_monthly_military_housing_allowance_amount decimal(15,2) null,
    ji_military_pay_subtotal_amount decimal(15,2) null,
    ji_military_allowance_subtotal_amount decimal(15,2) null,
    ji_monthly_military_total_amount decimal(15,2) null,
    ji_annual_military_total_amount decimal(15,2) null,
    ji_job_year1_year int null,
    ji_job_year1_year_include bit null,
    ji_job_year1_from_date date null,
    ji_job_year1_through_date date null,
    ji_job_year1_months decimal(4,2) null,
    ji_job_year1_base_input_amount decimal(15,2) null,
    ji_job_year1_monthly_base_amount decimal(15,2) null,
    ji_job_year1_overtime_input_amount decimal(15,2) null,
    ji_job_year1_monthly_overtime_amount decimal(15,2) null,
    ji_job_year1_bonus_input_amount decimal(15,2) null,
    ji_job_year1_monthly_bonus_amount decimal(15,2) null,
    ji_job_year1_commissions_input_amount decimal(15,2) null,
    ji_job_year1_monthly_commissions_amount decimal(15,2) null,
    ji_job_year1_tip_input_amount decimal(15,2) null,
    ji_job_year1_monthly_tip_amount decimal(15,2) null,
    ji_job_year1_adjustment_input_amount decimal(15,2) null,
    ji_job_year1_monthly_adjustment_amount decimal(15,2) null,
    ji_job_year1_monthly_total_amount decimal(15,2) null,
    ji_job_year1_annual_total_amount decimal(15,2) null,
    ji_job_year1_monthly_total_commissions_percent decimal(11,9) null,
    ji_job_year2_year int null,
    ji_job_year2_year_include bit null,
    ji_job_year2_from_date date null,
    ji_job_year2_through_date date null,
    ji_job_year2_months decimal(4,2) null,
    ji_job_year2_base_input_amount decimal(15,2) null,
    ji_job_year2_monthly_base_amount decimal(15,2) null,
    ji_job_year2_overtime_input_amount decimal(15,2) null,
    ji_job_year2_monthly_overtime_amount decimal(15,2) null,
    ji_job_year2_bonus_input_amount decimal(15,2) null,
    ji_job_year2_monthly_bonus_amount decimal(15,2) null,
    ji_job_year2_commissions_input_amount decimal(15,2) null,
    ji_job_year2_monthly_commissions_amount decimal(15,2) null,
    ji_job_year2_tip_input_amount decimal(15,2) null,
    ji_job_year2_monthly_tip_amount decimal(15,2) null,
    ji_job_year2_adjustment_input_amount decimal(15,2) null,
    ji_job_year2_monthly_adjustment_amount decimal(15,2) null,
    ji_job_year2_monthly_total_amount decimal(15,2) null,
    ji_job_year2_annual_total_amount decimal(15,2) null,
    ji_job_year2_monthly_total_commissions_percent decimal(11,9) null,
    ji_job_year3_year int null,
    ji_job_year3_year_include bit null,
    ji_job_year3_from_date date null,
    ji_job_year3_through_date date null,
    ji_job_year3_months decimal(4,2) null,
    ji_job_year3_base_input_amount decimal(15,2) null,
    ji_job_year3_monthly_base_amount decimal(15,2) null,
    ji_job_year3_overtime_input_amount decimal(15,2) null,
    ji_job_year3_monthly_overtime_amount decimal(15,2) null,
    ji_job_year3_bonus_input_amount decimal(15,2) null,
    ji_job_year3_monthly_bonus_amount decimal(15,2) null,
    ji_job_year3_commissions_input_amount decimal(15,2) null,
    ji_job_year3_monthly_commissions_amount decimal(15,2) null,
    ji_job_year3_tip_input_amount decimal(15,2) null,
    ji_job_year3_monthly_tip_amount decimal(15,2) null,
    ji_job_year3_adjustment_input_amount decimal(15,2) null,
    ji_job_year3_monthly_adjustment_amount decimal(15,2) null,
    ji_job_year3_monthly_total_amount decimal(15,2) null,
    ji_job_year3_annual_total_amount decimal(15,2) null,
    ji_job_year3_monthly_total_commissions_percent decimal(11,9) null,
    ji_estimated_monthly_base_amount decimal(15,2) null,
    ji_estimated_monthly_bonus_amount decimal(15,2) null,
    ji_estimated_monthly_overtime_amount decimal(15,2) null,
    ji_estimated_monthly_commissions_amount decimal(15,2) null,
    ji_estimated_monthly_tip_amount decimal(15,2) null,
    ji_estimated_monthly_total_amount decimal(15,2) null,
    ji_estimated_annual_total_amount decimal(15,2) null,
    ji_estimated_monthly_total_commissions_percent decimal(11,9) null,
    ji_worksheet_monthly_base_amount decimal(15,2) null,
    ji_worksheet_monthly_bonus_amount decimal(15,2) null,
    ji_worksheet_monthly_overtime_amount decimal(15,2) null,
    ji_worksheet_monthly_commissions_amount decimal(15,2) null,
    ji_worksheet_monthly_tip_amount decimal(15,2) null,
    ji_worksheet_monthly_total_amount decimal(15,2) null,
    ji_worksheet_annual_total_amount decimal(15,2) null,
    ji_worksheet_monthly_total_commissions_percent decimal(11,9) null,
    ji_working_monthly_base_amount decimal(15,2) null,
    ji_working_monthly_bonus_amount decimal(15,2) null,
    ji_working_monthly_overtime_amount decimal(15,2) null,
    ji_working_monthly_commissions_amount decimal(15,2) null,
    ji_working_monthly_tip_amount decimal(15,2) null,
    ji_working_monthly_total_amount decimal(15,2) null,
    ji_working_annual_total_amount decimal(15,2) null,
    ji_working_monthly_total_commissions_percent decimal(11,9) null,
    ji_underwriter_comments varchar(1024) null,
    ji_foreign_income bit null,
    ji_seasonal_income bit null,
    ji_voe_third_party_verifier_order_id varchar(16) null,
    ji_employer_voe_name varchar(128) null,
    ji_employer_voe_title varchar(128) null,
    ji_employer_voe_phone varchar(32) null,
    ji_employer_voe_phone_extension varchar(16) null,
    ji_employer_voe_fax varchar(32) null,
    ji_employer_voe_email varchar(256) null,
    ji_phone_voe_verify_method_type varchar(128) null,
    ji_address_voe_verify_method_type varchar(128) null,
    ji_verified_date date null,
    ji_verified_by varchar(128) null,
    ji_voe_verbal_verify_method_type varchar(128) null,
    ji_voe_third_party_verifier_type varchar(128) null,
    ji_employer_other_interested_party bit null,
    ji_employer_other_interested_party_description varchar(128) null
);

create table staging_octane.lp_finding
(
    lpf_pid bigint
        primary key,
    lpf_version int null,
    lpf_lp_request_pid bigint null,
    lpf_lp_finding_message_type varchar(128) null,
    lpf_finding_yes_no_unknown_type varchar(128) null,
    lpf_finding_value varchar(128) null
);

create table staging_octane.lp_request_credit
(
    lprc_pid bigint
        primary key,
    lprc_version int null,
    lprc_lp_request_pid bigint null,
    lprc_create_datetime timestamp null,
    lprc_credit_report_create_datetime timestamp null,
    lprc_credit_bureau_type varchar(128) null,
    lprc_credit_report_identifier varchar(32) null,
    lprc_credit_report_name varchar(256) null,
    lprc_aus_credit_service_type varchar(128) null,
    lprc_borrower_1_borrower_tiny_id_type varchar(128) null,
    lprc_borrower_2_borrower_tiny_id_type varchar(128) null
);

create table staging_octane.mers_daily_report
(
    medr_pid bigint
        primary key,
    medr_version int null,
    medr_account_pid bigint null,
    medr_create_datetime timestamp null,
    medr_report_date date null,
    medr_import_status_type varchar(128) null,
    medr_import_status_messages text null,
    medr_import_attempt_count int null,
    medr_imported_loan_count int null,
    medr_consolidated_report_text_repository_file_pid bigint null
);

create table staging_octane.military_service
(
    ms_pid bigint
        primary key,
    ms_version int null,
    ms_borrower_pid bigint null,
    ms_from_date date null,
    ms_through_date date null,
    ms_name_used_during_service varchar(128) null,
    ms_service_number varchar(32) null,
    ms_military_branch_type varchar(128) null,
    ms_military_service_type varchar(128) null,
    ms_military_status_type varchar(128) null
);

create table staging_octane.other_income
(
    oi_pid bigint
        primary key,
    oi_version int null,
    oi_other_income_type varchar(128) null,
    oi_borrower_income_pid bigint null,
    oi_estimated_net_income_amount decimal(15,2) null,
    oi_estimated_mode bit null,
    oi_worksheet_monthly_total_amount decimal(15,2) null,
    oi_monthly_total_amount decimal(15,2) null,
    oi_borrower_income_percent decimal(11,9) null,
    oi_description varchar(128) null,
    oi_calc_method_type varchar(128) null,
    oi_common_year1_year int null,
    oi_common_year1_year_include bit null,
    oi_common_year1_from_date date null,
    oi_common_year1_through_date date null,
    oi_common_year1_months decimal(4,2) null,
    oi_common_year1_annual_total_amount decimal(15,2) null,
    oi_common_year1_monthly_total_amount decimal(15,2) null,
    oi_common_year2_year int null,
    oi_common_year2_year_include bit null,
    oi_common_year2_from_date date null,
    oi_common_year2_through_date date null,
    oi_common_year2_months decimal(4,2) null,
    oi_common_year2_annual_total_amount decimal(15,2) null,
    oi_common_year2_monthly_total_amount decimal(15,2) null,
    oi_common_year3_year int null,
    oi_common_year3_year_include bit null,
    oi_common_year3_from_date date null,
    oi_common_year3_through_date date null,
    oi_common_year3_months decimal(4,2) null,
    oi_common_year3_annual_total_amount decimal(15,2) null,
    oi_common_year3_monthly_total_amount decimal(15,2) null,
    oi_simple_year1_unadjusted_amount decimal(15,2) null,
    oi_simple_year1_income_federal_tax_exempt bit null,
    oi_simple_year1_tax_exempt_tax_rate_percent decimal(11,9) null,
    oi_simple_year1_tax_exempt_amount decimal(15,2) null,
    oi_simple_year2_unadjusted_amount decimal(15,2) null,
    oi_simple_year2_income_federal_tax_exempt bit null,
    oi_simple_year2_tax_exempt_tax_rate_percent decimal(11,9) null,
    oi_simple_year2_tax_exempt_amount decimal(15,2) null,
    oi_simple_year3_unadjusted_amount decimal(15,2) null,
    oi_simple_year3_income_federal_tax_exempt bit null,
    oi_simple_year3_tax_exempt_tax_rate_percent decimal(11,9) null,
    oi_simple_year3_tax_exempt_amount decimal(15,2) null,
    oi_simple_unadjusted_monthly_amount decimal(15,2) null,
    oi_simple_income_federal_tax_exempt bit null,
    oi_simple_tax_exempt_tax_rate_percent decimal(11,9) null,
    oi_simple_tax_exempt_amount decimal(15,2) null,
    oi_simple_calculated_monthly_amount decimal(15,2) null,
    oi_underwriter_comments varchar(1024) null,
    oi_mortgage_credit_certificate_issuer_pid bigint null,
    oi_mcc_reservation_number varchar(128) null,
    oi_mcc_reservation_date date null,
    oi_mcc_reservation_expiration_date date null,
    oi_mcc_commitment_number varchar(128) null,
    oi_mcc_underwriting_certification_deadline_date date null,
    oi_mcc_delivered_by_date date null,
    oi_unadjusted_monthly_total_amount decimal(15,2) null,
    oi_simple_year1_unadjusted_monthly_amount decimal(15,2) null,
    oi_simple_year2_unadjusted_monthly_amount decimal(15,2) null,
    oi_simple_year3_unadjusted_monthly_amount decimal(15,2) null
);

create table staging_octane.proposal
(
    prp_pid bigint
        primary key,
    prp_version int null,
    prp_decision_lp_request_pid bigint null,
    prp_decision_du_request_pid bigint null,
    prp_proposal_type varchar(128) null,
    prp_description varchar(256) null,
    prp_doc_level_type varchar(128) null,
    prp_loan_purpose_type varchar(128) null,
    prp_name varchar(128) null,
    prp_create_datetime timestamp null,
    prp_effective_funding_date date null,
    prp_estimated_funding_date date null,
    prp_calculated_earliest_allowed_consummation_date date null,
    prp_overridden_earliest_allowed_consummation_date date null,
    prp_effective_earliest_allowed_consummation_date date null,
    prp_earliest_allowed_consummation_date_override_reason text null,
    prp_last_requested_disclosure_date date null,
    prp_closing_document_sign_datetime timestamp null,
    prp_scheduled_closing_document_sign_datetime timestamp null,
    prp_rescission_through_date date null,
    prp_rescission_notification_date date null,
    prp_rescission_notification_by varchar(256) null,
    prp_rescission_notification_type varchar(128) null,
    prp_rescission_effective_date date null,
    prp_first_payment_date date null,
    prp_first_payment_date_auto_compute bit null,
    prp_property_usage_type varchar(128) null,
    prp_estimated_property_value_amount decimal(15) null,
    prp_smart_charges_enabled bit null,
    prp_charges_updated_datetime timestamp null,
    prp_smart_docs_enabled bit null,
    prp_docs_enabled_datetime timestamp null,
    prp_request_fha_mip_refund_required bit null,
    prp_request_recording_fees_required bit null,
    prp_request_property_taxes_required bit null,
    prp_property_tax_request_error_messages text null,
    prp_fha_mip_refund_request_input_error bit null,
    prp_recording_fees_request_input_error bit null,
    prp_property_taxes_request_input_error bit null,
    prp_publish bit null,
    prp_publish_date date null,
    prp_ipc_auto_compute bit null,
    prp_ipc_limit_percent decimal(11,9) null,
    prp_ipc_maximum_amount_allowed decimal(15,2) null,
    prp_ipc_amount decimal(15,2) null,
    prp_ipc_percent decimal(11,9) null,
    prp_ipc_financing_concession_amount decimal(15,2) null,
    prp_ipc_non_cash_concession_amount decimal(15,2) null,
    prp_sale_price_amount decimal(15) null,
    prp_structure_type varchar(128) null,
    prp_deal_pid bigint null,
    prp_gfe_interest_rate_expiration_date date null,
    prp_gfe_lock_duration_days int null,
    prp_gfe_lock_before_settlement_days int null,
    prp_proposal_expiration_date date null,
    prp_uuts_master_contact_name varchar(128) null,
    prp_uuts_master_contact_title varchar(128) null,
    prp_uuts_master_office_phone varchar(32) null,
    prp_uuts_master_office_phone_extension varchar(16) null,
    prp_underwrite_risk_assessment_type varchar(128) null,
    prp_underwriting_comments varchar(1024) null,
    prp_reserves_auto_compute bit null,
    prp_reserves_amount decimal(15,2) null,
    prp_reserves_months int null,
    prp_underwrite_disposition_type varchar(128) null,
    prp_underwrite_publish_date date null,
    prp_underwrite_expiration_date date null,
    prp_usda_gsa_sam_exclusion varchar(128) null,
    prp_usda_gsa_sam_checked_date date null,
    prp_usda_rd_single_family_housing_type varchar(128) null,
    prp_underwrite_method_type varchar(128) null,
    prp_mi_required bit null,
    prp_decision_credit_score_borrower_pid bigint null,
    prp_decision_credit_score int null,
    prp_estimated_credit_score int null,
    prp_effective_credit_score int null,
    prp_mortgagee_builder_seller_relationship varchar(128) null,
    prp_fha_prior_agency_case_id varchar(32) null,
    prp_fha_prior_agency_case_endorsement_date date null,
    prp_fha_refinance_authorization_number varchar(16) null,
    prp_fha_refinance_authorization_expiration_date date null,
    prp_fhac_refinance_authorization_messages text null,
    prp_fha_203k_consultant_id varchar(8) null,
    prp_hud_fha_de_approval_type varchar(128) null,
    prp_owner_occupancy_not_required bit null,
    prp_va_monthly_utilities_included varchar(128) null,
    prp_va_maintenance_utilities_auto_compute bit null,
    prp_va_monthly_maintenance_utilities_amount decimal(15,2) null,
    prp_va_maintenance_utilities_per_square_feet_amount decimal(15,2) null,
    prp_household_size_count int null,
    prp_household_income_guideline_amount decimal(15,2) null,
    prp_va_past_credit_record_type varchar(128) null,
    prp_va_meets_credit_standards varchar(128) null,
    prp_va_prior_paid_in_full_loan_number varchar(32) null,
    prp_note_date date null,
    prp_security_instrument_type varchar(128) null,
    prp_trustee_pid bigint null,
    prp_trustee_name varchar(128) null,
    prp_trustee_address_street1 varchar(128) null,
    prp_trustee_address_street2 varchar(128) null,
    prp_trustee_address_city varchar(128) null,
    prp_trustee_address_state varchar(128) null,
    prp_trustee_address_postal_code varchar(128) null,
    prp_trustee_address_country varchar(128) null,
    prp_trustee_mers_org_id varchar(7) null,
    prp_trustee_phone_number varchar(32) null,
    prp_fre_ctp_closing_feature_type varchar(128) null,
    prp_fre_ctp_closing_type varchar(128) null,
    prp_fre_ctp_first_payment_due_date date null,
    prp_purchase_contract_date date null,
    prp_purchase_contract_financing_contingency_date date null,
    prp_purchase_contract_funding_date date null,
    prp_effective_property_value_type varchar(128) null,
    prp_effective_property_value_amount decimal(15) null,
    prp_decision_appraised_value_amount decimal(15) null,
    prp_fha_va_reasonable_value_amount decimal(15) null,
    prp_cd_clear_date date null,
    prp_disaster_declaration_check_date_type varchar(128) null,
    prp_disaster_declaration_check_date date null,
    prp_any_disaster_declaration_before_appraisal bit null,
    prp_any_disaster_declaration_after_appraisal bit null,
    prp_any_disaster_declaration bit null,
    prp_early_first_payment varchar(128) null,
    prp_property_acquired_through_inheritance varchar(128) null,
    prp_property_acquired_through_ancillary_relief varchar(128) null,
    prp_delayed_financing_exception_guidelines_applicable bit null,
    prp_delayed_financing_exception_verified bit null,
    prp_effective_property_value_explanation_type varchar(128) null,
    prp_taxes_escrowed varchar(128) null,
    prp_flood_insurance_applicable varchar(128) null,
    prp_windstorm_insurance_applicable varchar(128) null,
    prp_earthquake_insurance_applicable varchar(128) null,
    prp_arms_length varchar(128) null,
    prp_fha_non_arms_length_ltv_exception_type varchar(128) null,
    prp_fha_non_arms_length_ltv_exception_verified bit null,
    prp_escrow_cushion_months int null,
    prp_escrow_cushion_months_auto_compute bit null,
    prp_fha_eligible_maximum_financing varchar(128) null,
    prp_hazard_insurance_applicable varchar(128) null,
    prp_property_repairs_required_type varchar(128) null,
    prp_property_repairs_description varchar(1024) null,
    prp_property_repairs_cost_amount decimal(15,2) null,
    prp_property_repairs_holdback_calc_type varchar(128) null,
    prp_property_repairs_holdback_amount decimal(15,2) null,
    prp_property_repairs_holdback_payer_type varchar(128) null,
    prp_property_repairs_holdback_administrator varchar(128) null,
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
    prp_initial_uw_submit_datetime timestamp null,
    prp_va_notice_of_value_source_type varchar(128) null,
    prp_va_notice_of_value_date date null,
    prp_va_notice_of_value_estimated_reasonable_value_amount decimal(15) null,
    prp_sar_significant_adjustments bit null,
    prp_separate_transaction_for_land_acquisition varchar(128) null,
    prp_land_acquisition_transaction_date date null,
    prp_land_acquisition_price decimal(15) null,
    prp_cash_out_reason_home_improvement bit null,
    prp_cash_out_reason_debt_or_debt_consolidation bit null,
    prp_cash_out_reason_personal_use bit null,
    prp_cash_out_reason_future_investment_not_under_contract bit null,
    prp_cash_out_reason_future_investment_under_contract bit null,
    prp_cash_out_reason_other bit null,
    prp_cash_out_reason_other_text varchar(128) null,
    prp_decision_veteran_borrower_pid bigint null,
    prp_signed_closing_doc_received_datetime timestamp null,
    prp_other_lender_requires_appraisal bit null,
    prp_other_lender_requires_appraisal_reason text null,
    prp_texas_equity_determination_datetime timestamp null,
    prp_texas_equity_conversion_determination_datetime timestamp null,
    prp_texas_equity_determination_datetime_override bit null,
    prp_texas_equity_determination_datetime_override_reason text null,
    prp_texas_equity_conversion_determination_datetime_override bit null,
    prp_texas_equity_conversion_determ_datetime_override_reason text null,
    prp_cema varchar(128) null,
    prp_cema_borrower_savings decimal(15,2) null,
    prp_any_vesting_changes varchar(128) null,
    prp_vesting_change_titleholder_added varchar(128) null,
    prp_vesting_change_titleholder_removed varchar(128) null,
    prp_vesting_change_titleholder_name_change varchar(128) null,
    prp_deed_taxes_applicable bit null,
    prp_deed_taxes_applicable_explanation varchar(1024) null,
    prp_deed_taxes_auto_compute bit null,
    prp_deed_taxes_auto_compute_override_reason varchar(1024) null,
    prp_intent_to_proceed_date date null,
    prp_intent_to_proceed_type varchar(128) null,
    prp_intent_to_proceed_provider_unparsed_name varchar(128) null,
    prp_intent_to_proceed_obtainer_unparsed_name varchar(128) null,
    prp_cash_out_reason_student_loans bit null,
    prp_household_income_exclusive_edit bit null,
    prp_purchase_contract_received_date date null,
    prp_down_payment_percent_mode bit null,
    prp_lender_escrow_loan_amount decimal(15,2) null,
    prp_underwrite_disposition_note varchar(1024) null,
    prp_rescission_applicable bit null,
    prp_area_median_income decimal(15,2) null,
    prp_total_income_to_ami_ratio decimal(14,9) null,
    prp_construction_budget_url varchar(1024) null,
    prp_construction_borrower_contribution_amount decimal(15,2) null,
    prp_construction_lot_ownership_status_type varchar(128) null,
    prp_intent_to_proceed_provided bit null,
    prp_effective_signing_location_state varchar(128) null,
    prp_effective_signing_location_city varchar(128) null,
    prp_va_required_guaranty_amount decimal(15,2) null,
    prp_va_amount_used_to_calculate_maximum_guaranty decimal(15,2) null,
    prp_va_actual_guaranty_amount decimal(15,2) null,
    prp_last_corrective_disclosure_processed_datetime timestamp null,
    prp_user_entered_note_date date null,
    prp_effective_note_date date null,
    prp_lender_escrow_loan_due_date date null,
    prp_va_maximum_base_loan_amount decimal(15,2) null,
    prp_va_maximum_funding_fee_amount decimal(15,2) null,
    prp_va_maximum_total_loan_amount decimal(15,2) null,
    prp_va_required_cash_amount decimal(15,2) null,
    prp_va_guaranty_percent decimal(11,9) null
);

create table staging_octane.aus_request_number_ticker
(
    arnt_pid bigint
        primary key,
    arnt_version int null,
    arnt_proposal_pid bigint null,
    arnt_next_aus_request_number int null
);

create table staging_octane.construction_draw
(
    cd_pid bigint
        primary key,
    cd_version int null,
    cd_proposal_pid bigint null,
    cd_construction_draw_type varchar(128) null,
    cd_construction_draw_status_type varchar(128) null,
    cd_scheduled_disbursement_date date null,
    cd_confirmation_datetime timestamp null,
    cd_inspection_datetime timestamp null,
    cd_disbursement_datetime timestamp null,
    cd_boarded_datetime timestamp null,
    cd_voided_datetime timestamp null,
    cd_construction_draw_notes varchar(1024) null,
    cd_total_draw_amount decimal(15,2) null,
    cd_borrower_contribution_amount decimal(15,2) null,
    cd_lender_contribution_amount decimal(15,2) null,
    cd_construction_draw_number int null,
    cd_construction_draw_disbursed_at_closing bit null
);

create table staging_octane.construction_draw_number_ticker
(
    cdnt_pid bigint
        primary key,
    cdnt_version int null,
    cdnt_proposal_pid bigint null,
    cdnt_next_construction_draw_number int null
);

create table staging_octane.credit_inquiry
(
    ci_pid bigint
        primary key,
    ci_version int null,
    ci_proposal_pid bigint null,
    ci_credit_request_pid bigint null,
    ci_inquiry_date date null,
    ci_name varchar(128) null,
    ci_address_street1 varchar(128) null,
    ci_address_street2 varchar(128) null,
    ci_address_city varchar(128) null,
    ci_address_state varchar(128) null,
    ci_address_postal_code varchar(128) null,
    ci_address_country varchar(128) null,
    ci_phone varchar(32) null,
    ci_credit_inquiry_result_type varchar(128) null,
    ci_credit_business_type varchar(128) null,
    ci_credit_loan_type varchar(128) null,
    ci_equifax_included bit null,
    ci_experian_included bit null,
    ci_trans_union_included bit null,
    ci_explanation_type varchar(128) null,
    ci_explanation_info varchar(1024) null,
    ci_credit_report_identifier varchar(32) null,
    ci_inquiry_date_provided bit null
);

create table staging_octane.borrower_credit_inquiry
(
    bci_pid bigint
        primary key,
    bci_version int null,
    bci_credit_inquiry_pid bigint null,
    bci_borrower_pid bigint null
);

create table staging_octane.deal_snapshot
(
    desn_pid bigint
        primary key,
    desn_version int null,
    desn_snapshot_proposal_pid bigint null,
    desn_decision_appraisal_condition_type varchar(128) null,
    desn_lender_lock_effective_expiration_datetime_main timestamp null,
    desn_lender_lock_effective_expiration_datetime_piggyback timestamp null,
    desn_lender_lock_status_type_main varchar(128) null,
    desn_lender_lock_status_type_piggyback varchar(128) null,
    desn_lender_lock_id_main varchar(11) null,
    desn_lender_lock_id_piggyback varchar(11) null,
    desn_preferred_vendor_used bit null,
    desn_lender_lock_start_datetime_main timestamp null,
    desn_lender_lock_start_datetime_piggyback timestamp null,
    desn_lender_lock_effective_duration_days_main int null,
    desn_lender_lock_effective_duration_days_piggyback int null,
    desn_lead_source_name varchar(128) null,
    desn_appraisal_rush_request bit null,
    desn_appraisal_transfer_specified bit null,
    desn_borrower_requires_appraisal bit null,
    desn_lender_requires_appraisal bit null,
    desn_product_requires_appraisal bit null,
    desn_override_calculated_appraisal_required bit null,
    desn_decision_appraisal_appraised_value_amount decimal(15) null,
    desn_appraisal_required bit null,
    desn_lender_concession_total_approved_amount_main decimal(15,2) null,
    desn_lender_concession_total_approved_amount_piggyback decimal(15,2) null,
    desn_relock_fee_gross_amount_main decimal(15,2) null,
    desn_relock_fee_gross_amount_piggyback decimal(15,2) null,
    desn_relock_fee_amount_less_concessions_main decimal(15,2) null,
    desn_relock_fee_amount_less_concessions_piggyback decimal(15,2) null,
    desn_relock_fee_amount_concessed_main decimal(15,2) null,
    desn_relock_fee_amount_concessed_piggyback decimal(15,2) null,
    desn_lock_extension_fee_gross_amount_main decimal(15,2) null,
    desn_lock_extension_fee_gross_amount_piggyback decimal(15,2) null,
    desn_lock_extension_fee_amount_less_concessions_main decimal(15,2) null,
    desn_lock_extension_fee_amount_less_concessions_piggyback decimal(15,2) null,
    desn_lock_extension_fee_amount_concessed_main decimal(15,2) null,
    desn_lock_extension_fee_amount_concessed_piggyback decimal(15,2) null,
    desn_lender_concession_remaining_amount_main decimal(15,2) null,
    desn_lender_concession_remaining_amount_piggyback decimal(15,2) null,
    desn_charge_credit_for_interest_rate_main decimal(15,2) null,
    desn_charge_credit_for_interest_rate_piggyback decimal(15,2) null
);

create table staging_octane.docusign_package
(
    dcsp_pid bigint
        primary key,
    dcsp_version int null,
    dcsp_proposal_pid bigint null,
    dcsp_envelope_id varchar(128) null,
    dcsp_esign_package_status_type varchar(128) null,
    dcsp_status_datetime timestamp null
);

create index idx_docusign_package_1
    on staging_octane.docusign_package (dcsp_envelope_id);

create table staging_octane.master_property_insurance
(
    mpi_pid bigint
        primary key,
    mpi_version int null,
    mpi_proposal_pid bigint null,
    mpi_master_property_insurance_type varchar(128) null,
    mpi_policy_effective_date date null,
    mpi_policy_expiration_date date null,
    mpi_next_payment_date date null,
    mpi_policy_property_coverage_amount decimal(15) null,
    mpi_policy_liability_coverage_amount decimal(15) null,
    mpi_policy_fidelity_coverage_amount decimal(15) null,
    mpi_policy_deductible_amount decimal(15) null,
    mpi_replacement_cost_amount decimal(15) null,
    mpi_coinsurance varchar(128) null,
    mpi_agreed_amount_endorsement varchar(128) null,
    mpi_company_name varchar(128) null,
    mpi_first_name varchar(32) null,
    mpi_middle_name varchar(32) null,
    mpi_last_name varchar(32) null,
    mpi_name_suffix varchar(32) null,
    mpi_title varchar(128) null,
    mpi_email varchar(256) null,
    mpi_mobile_phone varchar(32) null,
    mpi_office_phone varchar(32) null,
    mpi_office_phone_extension varchar(16) null,
    mpi_fax varchar(32) null,
    mpi_address_street1 varchar(128) null,
    mpi_address_street2 varchar(128) null,
    mpi_address_city varchar(128) null,
    mpi_address_state varchar(128) null,
    mpi_address_postal_code varchar(128) null,
    mpi_address_country varchar(16) null,
    mpi_policy_id varchar(128) null
);

create table staging_octane.mi_integration_vendor_request
(
    mivr_pid bigint
        primary key,
    mivr_version int null,
    mivr_proposal_pid bigint null,
    mivr_create_datetime timestamp null,
    mivr_mi_company_name_type varchar(128) null,
    mivr_request_type varchar(128) null,
    mivr_mi_payment_type varchar(128) null,
    mivr_mi_payer_type varchar(128) null,
    mivr_mi_coverage_percentage decimal(11,9) null,
    mivr_mi_upfront_percentage decimal(11,9) null,
    mivr_mi_initial_monthly_annual_percentage decimal(11,9) null,
    mivr_mi_renewal_monthly_annual_percentage decimal(11,9) null,
    mivr_mi_initial_duration_months int null,
    mivr_mi_rate_quote_id varchar(128) null,
    mivr_mi_certificate_id varchar(128) null,
    mivr_request_status_type varchar(128) null,
    mivr_request_time_to_completion_ms bigint null,
    mivr_eligible_mi_products bit null,
    mivr_input_errors text null,
    mivr_service_errors text null,
    mivr_internal_errors text null,
    mivr_request_xml_pid bigint null,
    mivr_response_xml_pid bigint null,
    mivr_response_pdf_file_pid bigint null
);

create table staging_octane.loan
(
    l_pid bigint
        primary key,
    l_version int null,
    l_proposal_pid bigint null,
    l_offering_pid bigint null,
    l_product_terms_pid bigint null,
    l_mortgage_type varchar(128) null,
    l_interest_only_type varchar(128) null,
    l_buydown_schedule_type varchar(128) null,
    l_prepay_penalty_schedule_type varchar(128) null,
    l_aus_type varchar(128) null,
    l_agency_case_id varchar(32) null,
    l_arm_index_datetime timestamp null,
    l_arm_index_current_value_percent decimal(11,9) null,
    l_arm_margin_percent decimal(11,9) null,
    l_base_loan_amount decimal(17,2) null,
    l_buydown_contributor_type varchar(128) null,
    l_target_cash_out_amount decimal(15,2) null,
    l_heloc_maximum_balance_amount decimal(15) null,
    l_note_rate_percent decimal(11,9) null,
    l_initial_note_rate_percent decimal(11,9) null,
    l_lien_priority_type varchar(128) null,
    l_loan_amount decimal(17,2) null,
    l_financed_amount decimal(15) null,
    l_ltv_ratio_percent decimal(11,9) null,
    l_base_loan_amount_ltv_ratio_percent decimal(11,9) null,
    l_mi_requirement_ltv_ratio_percent decimal(11,9) null,
    l_mi_auto_compute bit null,
    l_mi_no_mi_product bit null,
    l_mi_input_type varchar(128) null,
    l_mi_company_name_type varchar(128) null,
    l_mi_certificate_id varchar(32) null,
    l_mi_premium_refundable_type varchar(128) null,
    l_mi_initial_calculation_type varchar(128) null,
    l_mi_renewal_calculation_type varchar(128) null,
    l_mi_payer_type varchar(128) null,
    l_mi_coverage_percent decimal(11,9) null,
    l_mi_ltv_cutoff_percent decimal(11,9) null,
    l_mi_midpoint_cutoff_required bit null,
    l_mi_required_monthly_payment_count int null,
    l_mi_actual_monthly_payment_count int null,
    l_mi_payment_type varchar(128) null,
    l_mi_upfront_amount decimal(15,2) null,
    l_mi_upfront_percent decimal(11,9) null,
    l_mi_initial_monthly_payment_amount decimal(15,2) null,
    l_mi_renewal_monthly_payment_annual_percent decimal(11,9) null,
    l_mi_renewal_monthly_payment_amount decimal(15,2) null,
    l_mi_initial_duration_months int null,
    l_mi_initial_monthly_payment_annual_percent decimal(11,9) null,
    l_mi_initial_calculated_rate_type varchar(128) null,
    l_mi_renewal_calculated_rate_type varchar(128) null,
    l_mi_base_rate_label varchar(16000) null,
    l_mi_base_monthly_payment_annual_percent decimal(11,9) null,
    l_mi_base_upfront_percent decimal(11,9) null,
    l_mi_base_monthly_payment_amount decimal(15,2) null,
    l_mi_base_upfront_payment_amount decimal(15,2) null,
    l_qualifying_rate_type varchar(128) null,
    l_qualifying_rate_input_percent decimal(11,9) null,
    l_qualifying_rate_percent decimal(11,9) null,
    l_fha_program_code_type varchar(128) null,
    l_fha_principal_write_down bit null,
    l_fhac_case_assignment_messages text null,
    l_initial_pi_amount decimal(15,2) null,
    l_qualifying_pi_amount decimal(15,2) null,
    l_base_note_rate_percent decimal(11,9) null,
    l_base_arm_margin_percent decimal(11,9) null,
    l_base_price_percent decimal(11,9) null,
    l_lock_price_percent decimal(11,9) null,
    l_lock_duration_days int null,
    l_lock_commitment_type varchar(128) null,
    l_product_choice_datetime timestamp null,
    l_hmda_purchaser_of_loan_2017_type varchar(128) null,
    l_hmda_purchaser_of_loan_2018_type varchar(128) null,
    l_texas_equity varchar(128) null,
    l_texas_equity_auto varchar(128) null,
    l_fnm_mbs_investor_contract_id varchar(6) null,
    l_base_guaranty_fee_percent decimal(11,9) null,
    l_guaranty_fee_percent decimal(11,9) null,
    l_guaranty_fee_after_alternate_payment_method_percent decimal(11,9) null,
    l_fnm_investor_product_plan_id varchar(5) null,
    l_uldd_loan_comment varchar(60) null,
    l_principal_curtailment_amount decimal(15,2) null,
    l_agency_case_id_assigned_date date null,
    l_mi_lender_paid_rate_adjustment_percent decimal(11,9) null,
    l_apr decimal(11,9) null,
    l_finance_charge_amount decimal(15,2) null,
    l_apor_percent decimal(11,9) null,
    l_apor_date date null,
    l_hmda_rate_spread_percent decimal(11,9) null,
    l_hoepa_apr decimal(11,9) null,
    l_hoepa_rate_spread decimal(11,9) null,
    l_hoepa_fees_dollar_amount decimal(15,2) null,
    l_hmda_hoepa_status_type varchar(128) null,
    l_rate_sheet_undiscounted_rate_percent decimal(11,9) null,
    l_effective_undiscounted_rate_percent decimal(11,9) null,
    l_last_unprocessed_changes_datetime timestamp null,
    l_locked_price_change_percent decimal(11,9) null,
    l_interest_rate_fee_change_amount decimal(15,2) null,
    l_lender_concession_candidate bit null,
    l_durp_eligibility_opt_out bit null,
    l_qualified_mortgage_status_type varchar(128) null,
    l_qualified_mortgage bit null,
    l_lqa_purchase_eligibility_type varchar(128) null,
    l_student_loan_cash_out_refinance bit null,
    l_mi_rate_quote_id varchar(128) null,
    l_mi_integration_vendor_request_pid bigint null,
    l_secondary_clear_to_commit bit null,
    l_qm_eligible bit null,
    l_fha_endorsement_date date null,
    l_va_guaranty_date date null,
    l_usda_guarantee_date date null
);

create table staging_octane.circumstance_change
(
    cc_pid bigint
        primary key,
    cc_version int null,
    cc_loan_pid bigint null,
    cc_create_datetime timestamp null,
    cc_circumstance_change_type varchar(128) null,
    cc_source_unparsed_name varchar(128) null,
    cc_expired bit null,
    cc_previous_formatted_value varchar(1024) null,
    cc_to_formatted_value varchar(1024) null,
    cc_expiration_date date null,
    cc_system_added bit null
);

create index idx_circumstance_change_1
    on staging_octane.circumstance_change (cc_create_datetime);

create table staging_octane.ernst_request
(
    enst_pid bigint
        primary key,
    enst_version int null,
    enst_loan_pid bigint null,
    enst_response_deal_system_file_pid bigint null,
    enst_auto_compute bit null,
    enst_create_datetime timestamp null,
    enst_ernst_request_status_type varchar(128) null,
    enst_error_messages text null,
    enst_state varchar(2) null,
    enst_ernst_page_rec varchar(16) null,
    enst_sub_jurisdiction_name varchar(128) null,
    enst_torrens bit null,
    enst_security_instrument_request_type varchar(128) null,
    enst_security_instrument_index_fee_requested bit null,
    enst_security_instrument_index_fee_grantor_count int null,
    enst_security_instrument_index_fee_grantees_count int null,
    enst_security_instrument_index_fee_surnames_count int null,
    enst_security_instrument_index_fee_signatures_count int null,
    enst_security_instrument_page_count int null,
    enst_security_instrument_modification_amendment_page_count int null,
    enst_security_instrument_page_breakdown varchar(1024) null,
    enst_mortgage_new_debt_amount decimal(15) null,
    enst_mortgage_original_debt_amount decimal(15) null,
    enst_mortgage_unpaid_balance_amount decimal(15,2) null,
    enst_deed_request_type varchar(128) null,
    enst_deed_index_fee_requested bit null,
    enst_deed_index_fee_grantor_count int null,
    enst_deed_index_fee_grantees_count int null,
    enst_deed_index_fee_surnames_count int null,
    enst_deed_index_fee_signatures_count int null,
    enst_deed_page_count int null,
    enst_deed_page_breakdown varchar(256) null,
    enst_deed_consideration_amount decimal(15) null,
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
    enst_loan_position_type varchar(128) null
);

create table staging_octane.ernst_request_question
(
    enstq_pid bigint
        primary key,
    enstq_version int null,
    enstq_ernst_request_pid bigint null,
    enstq_ernst_question_id varchar(8) null,
    enstq_question varchar(1024) null,
    enstq_yes_no_answer bit null,
    enstq_answer varchar(16) null
);

create table staging_octane.loan_beneficiary
(
    lb_pid bigint
        primary key,
    lb_version int null,
    lb_loan_pid bigint null,
    lb_investor_pid bigint null,
    lb_investor_loan_id varchar(32) null,
    lb_from_date date null,
    lb_through_date date null,
    lb_current bit null,
    lb_initial bit null,
    lb_loan_benef_transfer_status_type varchar(128) null,
    lb_loan_file_ship_date date null,
    lb_approved_with_conditions_date date null,
    lb_rejected_date date null,
    lb_pending_wire_date date null,
    lb_purchase_advice_amount decimal(15,2) null,
    lb_mers_mom bit null,
    lb_mers_transfer_status_type varchar(128) null,
    lb_mers_transfer_creation_date date null,
    lb_mers_transfer_override bit null,
    lb_mers_transfer_batch_pid bigint null,
    lb_loan_file_courier_type varchar(128) null,
    lb_loan_file_tracking_number varchar(32) null,
    lb_collateral_courier_type varchar(128) null,
    lb_collateral_tracking_number varchar(32) null,
    lb_loan_file_delivery_method_type varchar(128) null,
    lb_pool_id varchar(32) null,
    lb_mbs_final_purchaser_investor_pid bigint null,
    lb_early_funding varchar(128) null,
    lb_early_funding_date date null,
    lb_delivery_aus_type varchar(128) null
);

create table staging_octane.loan_closing_doc
(
    lcd_pid bigint
        primary key,
    lcd_version int null,
    lcd_loan_pid bigint null,
    lcd_dsi_websheet_number varchar(16) null,
    lcd_dsi_doc_code varchar(32) null,
    lcd_dsi_transaction_id varchar(128) null,
    lcd_dsi_closing_document_status_type varchar(128) null,
    lcd_dsi_fatal_messages text null,
    lcd_dsi_warning_messages text null,
    lcd_unsigned_closing_doc_deal_file_pid bigint null
);

create table staging_octane.loan_eligible_investor
(
    lei_pid bigint
        primary key,
    lei_version int null,
    lei_loan_pid bigint null,
    lei_investor_pid bigint null
);

create table staging_octane.loan_funding
(
    lf_pid bigint
        primary key,
    lf_version int null,
    lf_loan_pid bigint null,
    lf_interim_funder_pid bigint null,
    lf_proposal_snapshot_pid bigint null,
    lf_interim_funder_loan_id varchar(32) null,
    lf_funding_status_type varchar(128) null,
    lf_requested_date date null,
    lf_confirmed_release_datetime timestamp null,
    lf_wire_amount decimal(15,2) null,
    lf_interim_funder_fee_amount decimal(15,2) null,
    lf_release_wire_federal_reference_number varchar(32) null,
    lf_disbursement_date date null,
    lf_return_request_date date null,
    lf_return_confirmed_date date null,
    lf_funds_authorization_code varchar(32) null,
    lf_scheduled_release_date date null,
    lf_funds_authorized_datetime timestamp null,
    lf_funding_date date null,
    lf_collateral_sent_date date null,
    lf_collateral_tracking_number varchar(32) null,
    lf_collateral_courier_type varchar(128) null,
    lf_post_wire_adjustment_amount decimal(15,2) null,
    lf_net_wire_amount decimal(15,2) null,
    lf_early_wire_charge_day_count int null,
    lf_early_wire_daily_charge_amount decimal(15,2) null,
    lf_early_wire_total_charge_amount decimal(15,2) null,
    lf_scheduled_release_date_auto_compute bit null,
    lf_early_wire_request bit null
);

create table staging_octane.loan_hedge
(
    lh_pid bigint
        primary key,
    lh_version int null,
    lh_loan_pid bigint null,
    lh_update_datetime timestamp null,
    lh_update_pending_datetime timestamp null,
    lh_transaction_status_date date null,
    lh_loan_number bigint null,
    lh_product_code varchar(128) null,
    lh_note_rate decimal(11,9) null,
    lh_loan_amount decimal(17,2) null,
    lh_lock_date timestamp null,
    lh_buy_side_lock_expires_date timestamp null,
    lh_lock_expiration_date timestamp null,
    lh_secondary_cost decimal(11,9) null,
    lh_total_cost_basis decimal(11,9) null,
    lh_total_lender_margin decimal(17,9) null,
    lh_stage varchar(128) null,
    lh_fund_date timestamp null,
    lh_allocation_date timestamp null,
    lh_estimated_fund_date date null,
    lh_purchased_by_investor_date date null,
    lh_commitment_number varchar(32) null,
    lh_property_occupancy varchar(128) null,
    lh_property_type varchar(128) null,
    lh_property_type_supplemental varchar(16) null,
    lh_property_state varchar(128) null,
    lh_property_zip varchar(128) null,
    lh_property_number_of_units int null,
    lh_purchase_price decimal(15) null,
    lh_appraised_value decimal(15) null,
    lh_purpose varchar(128) null,
    lh_refinance_type varchar(128) null,
    lh_lien_position varchar(128) null,
    lh_impounds varchar(16) null,
    lh_buydown_type varchar(128) null,
    lh_buydown varchar(8) null,
    lh_ltv decimal(11,9) null,
    lh_original_ltv decimal(11,9) null,
    lh_cltv decimal(11,9) null,
    lh_original_cltv decimal(11,9) null,
    lh_effective_credit_score int null,
    lh_doc_type varchar(128) null,
    lh_debt_to_income decimal(11,9) null,
    lh_prepayment_penalty bit null,
    lh_prepayment_penalty_term int null,
    lh_interest_only bit null,
    lh_lock_type varchar(128) null,
    lh_lock_period int null,
    lh_fees_collected_bps varchar(8) null,
    lh_channel varchar(32) null,
    lh_loan_officer varchar(128) null,
    lh_branch varchar(128) null,
    lh_broker varchar(8) null,
    lh_correspondent varchar(8) null,
    lh_origination_source varchar(32) null,
    lh_investor varchar(128) null,
    lh_investor_total_price decimal(11,9) null,
    lh_investor_base_price decimal(11,9) null,
    lh_investor_srp_paid varchar(8) null,
    lh_investor_loan_number varchar(32) null,
    lh_pmi bit null,
    lh_pmi_percent decimal(11,9) null,
    lh_mi_cert_number varchar(128) null,
    lh_srp_paid varchar(8) null,
    lh_discount_points varchar(8) null,
    lh_date_docs_back varchar(8) null,
    lh_note_date date null,
    lh_close_date timestamp null,
    lh_first_payment_date date null,
    lh_last_payment_date date null,
    lh_next_scheduled_payment_due_date varchar(8) null,
    lh_scheduled_principal_and_interest decimal(15,2) null,
    lh_current_principal_and_interest decimal(15,2) null,
    lh_minimum_principal_and_interest decimal(15,2) null,
    lh_current_unpaid_principal_balance decimal(17,2) null,
    lh_original_interest_rate decimal(11,9) null,
    lh_maturity_date date null,
    lh_amortization_term int null,
    lh_yearly_payment_cap varchar(8) null,
    lh_arm_margin decimal(11,9) null,
    lh_arm_adjustment_date date null,
    lh_first_arm_period int null,
    lh_first_arm_adjustment_cap decimal(11,9) null,
    lh_arm_life_floor decimal(11,9) null,
    lh_arm_life_ceiling decimal(11,9) null,
    lh_first_arm_payment_adjustment_date varchar(8) null,
    lh_arm_period_after_first varchar(8) null,
    lh_arm_adjustment_cap_after_first decimal(11,9) null,
    lh_first_payment_cap varchar(8) null,
    lh_payment_cap_option varchar(8) null,
    lh_neg_am_flag varchar(8) null,
    lh_maximum_negative_amortization varchar(8) null,
    lh_arm_convertible varchar(8) null,
    lh_arm_index varchar(8) null,
    lh_dual_loan_flag varchar(8) null,
    lh_other_loan_number varchar(8) null,
    lh_agency_extract_fields varchar(8) null,
    lh_warehouse_bank varchar(128) null,
    lh_wire_amount decimal(15,2) null,
    lh_credit_rating_agency_fields varchar(8) null,
    lh_levels_fields varchar(8) null,
    lh_data_fields varchar(8) null,
    lh_loan_status varchar(128) null,
    lh_suspense_yes_no varchar(8) null,
    lh_loan_type varchar(128) null,
    lh_hud_borr_paid_by_for_borr_other_amount varchar(8) null,
    lh_fees_line_user_def_fee_one_borr varchar(8) null,
    lh_uw_suspended_cleared_date varchar(8) null,
    lh_underwriting_suspended_date varchar(8) null,
    lh_line_orig_charge decimal(15,2) null,
    lh_amortization_type varchar(32) null,
    lh_milestone varchar(128) null,
    lh_msa varchar(8) null,
    lh_county_code varchar(8) null,
    lh_ship_date_to_investor date null,
    lh_ship_date_to_custodian varchar(8) null,
    lh_borrower_last_name varchar(32) null,
    lh_purchase_advice_suspense_fee varchar(8) null,
    lh_purchase_advice_early_delivery_amount varchar(8) null,
    lh_purchase_advice_llpa varchar(8) null,
    lh_purchase_advice_fmna varchar(8) null,
    lh_purchase_advice_rp varchar(8) null,
    lh_lock_info_relock_amount varchar(8) null,
    lh_lock_info_loan_basis decimal(11,9) null,
    lh_lock_info_lock_request_fulfilled_date_time varchar(8) null,
    lh_lock_info_rate_lock_request_rate_sheet_id varchar(8) null,
    lh_current_status_change_date date null,
    lh_aus_type varchar(8) null,
    lh_buy_side_base_arm_margin varchar(8) null,
    lh_uldd_poolid varchar(32) null,
    lh_warehouse_co_name varchar(128) null,
    lh_underwriting_investor_eligibility_wells_fargo varchar(8) null,
    lh_underwriting_investor_eligibility_chase varchar(8) null,
    lh_du_fail_reason varchar(8) null,
    lh_lpmi_total_costs_on_lock varchar(8) null,
    lh_lpmi_after_lock_required varchar(8) null,
    lh_lpmi_after_lock_bps varchar(8) null,
    lh_mi_company_name_type varchar(128) null,
    lh_lpmi_frequency varchar(128) null,
    lh_lpmi_estimated_amount_of_lender_paid_mi varchar(8) null,
    lh_mortgage_insurance_premium_source_type varchar(16) null,
    lh_loan_amount_repeat decimal(17,2) null,
    lh_product_code_repeat varchar(128) null,
    lh_note_rate_repeat decimal(11,9) null,
    lh_loan_info_loan_id varchar(8) null,
    lh_salable_loan varchar(8) null,
    lh_sale_hold varchar(8) null,
    lh_sale_hold_comments varchar(8) null,
    lh_pf_disbursement_ledger_date date null,
    lh_aus_eligibility varchar(8) null,
    lh_texas_cash_out bit null,
    lh_acceptable_du bit null,
    lh_acceptable_lp bit null,
    lh_financed_property_count int null,
    lh_payoff_primary_lien_holder_company varchar(8) null,
    lh_payoff_junior_lien_holder_company varchar(8) null,
    lh_base_loan_amount decimal(17,2) null,
    lh_funding_authorized varchar(32) null,
    lh_credit_committee_fico_exception varchar(8) null,
    lh_home_ready_eligibility varchar(8) null,
    lh_home_ready_borr_acceptance varchar(8) null,
    lh_home_ready_eligibility_review varchar(8) null,
    lh_home_possible_eligibility varchar(8) null,
    lh_home_possible_eligibility_review varchar(8) null,
    lh_piw varchar(8) null,
    lh_piw_fee varchar(8) null,
    lh_uw_investor_eligibility_fnma varchar(8) null,
    lh_uw_investor_eligibility_fhlmc varchar(8) null,
    lh_appraisal_form varchar(128) null,
    lh_ext_cos_total_amt varchar(8) null,
    lh_fnmcu_risk_score varchar(8) null,
    lh_borrower_income_verification varchar(8) null,
    lh_co_borrower_income_verification varchar(8) null,
    lh_day_one_income_verification_available varchar(8) null,
    lh_subject_property_estimated_value decimal(15) null,
    lh_transaction_status varchar(128) null,
    lh_buy_status varchar(128) null,
    lh_appraisal_exists bit null,
    lh_du_piw_eligible bit null,
    lh_lp_appraisal_waiver_eligible bit null,
    lh_borrower_first_name varchar(32) null,
    lh_co_borrower_first_name varchar(32) null,
    lh_co_borrower_last_name varchar(32) null,
    lh_total_borrower_income decimal(15,2) null,
    lh_subject_property_city varchar(128) null,
    lh_subject_property_county varchar(128) null,
    lh_subject_property_zip varchar(128) null,
    lh_borrower_decision_credit_score int null,
    lh_co_borrower_decision_credit_score int null,
    lh_underwriter_disposition varchar(128) null,
    lh_underwrite_risk_assessment_type varchar(128) null,
    lh_subject_property_address varchar(1024) null,
    lh_original_lock_date timestamp null,
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
    lh_initial_uw_submit_date_time timestamp null,
    lh_cd_clear_date date null,
    lh_lender_concession_total_approved_amount decimal(15,2) null,
    lh_relock_fee_gross_amount decimal(15,2) null,
    lh_relock_fee_amount_less_concessions decimal(15,2) null,
    lh_relock_fee_amount_concessed decimal(15,2) null,
    lh_lock_extension_fee_gross_amount decimal(15,2) null,
    lh_lock_extension_fee_amount_less_concessions decimal(15,2) null,
    lh_lock_extension_fee_amount_concessed decimal(15,2) null,
    lh_lender_concession_remaining_amount decimal(15,2) null,
    lh_day_one_concessions decimal(15,2) null,
    lh_investor_lock_commitment_type varchar(128) null,
    lh_signed_closing_doc_received_datetime timestamp null,
    lh_geocoding_msa_code varchar(32) null,
    lh_geocoding_state_code varchar(32) null,
    lh_geocoding_county_code varchar(32) null,
    lh_geocoding_census_tract varchar(32) null,
    lh_tolerance_cure_amount decimal(15,2) null,
    lh_self_employed_flag bit null,
    lh_first_time_homebuyer bit null,
    lh_mortgage_insurance_lpmi_rate_adjustment decimal(11,9) null,
    lh_eligible_for_qm_status bit null,
    lh_safe_harbor_test_passed bit null,
    lh_hpml bit null,
    lh_hoepa varchar(128) null,
    lh_funding_status varchar(128) null,
    lh_early_funding varchar(128) null,
    lh_early_funding_date date null,
    lh_lqa_purchase_eligibility_type varchar(128) null,
    lh_transferred_appraisal bit null,
    lh_appraisal_cu_risk_score varchar(32) null,
    lh_mi_upfront_rate decimal(11,9) null,
    lh_loan_funding_requested_date date null,
    lh_student_loan_cash_out bit null,
    lh_octane_high_balance bit null,
    lh_borrower_final_price decimal(11,9) null,
    lh_charge_credit_for_interest_rate decimal(15,2) null,
    lh_contract_processing_fee decimal(15,2) null,
    lh_escrow_holdback bit null,
    lh_appraiser_license_number varchar(128) null,
    lh_mcc_present bit null,
    lh_grant_present bit null,
    lh_cema varchar(128) null,
    lh_supplemental_margin_company decimal(15,2) null,
    lh_supplemental_margin_branch decimal(15,2) null,
    lh_supplemental_margin_total decimal(15,2) null,
    lh_concessions_renegotiations_amount decimal(15,2) null,
    lh_fund_source_type varchar(128) null,
    lh_purchase_contract_funding_date date null,
    lh_product_id varchar(32) null,
    lh_community_second bit null,
    lh_current_taxes_and_insurance decimal(15,2) null,
    lh_multiple_applicants bit null,
    lh_community_second_liability bit null,
    lh_property_rights_type varchar(128) null,
    lh_mbs_final_purchaser varchar(128) null,
    lh_hmda_universal_loan_id varchar(45) null,
    lh_lp_ace_eligible bit null,
    lh_family_advantage_product bit null,
    lh_effective_rate_sheet_datetime timestamp null,
    lh_debt_to_income_excluding_mi decimal(11,9) null,
    lh_clear_to_commit bit null,
    lh_b2_first_name varchar(32) null,
    lh_b2_last_name varchar(32) null,
    lh_c2_first_name varchar(32) null,
    lh_c2_last_name varchar(32) null,
    lh_b3_first_name varchar(32) null,
    lh_b3_last_name varchar(32) null,
    lh_c3_first_name varchar(32) null,
    lh_c3_last_name varchar(32) null,
    lh_b4_first_name varchar(32) null,
    lh_b4_last_name varchar(32) null,
    lh_c4_first_name varchar(32) null,
    lh_c4_last_name varchar(32) null,
    lh_b5_first_name varchar(32) null,
    lh_b5_last_name varchar(32) null,
    lh_c5_first_name varchar(32) null,
    lh_c5_last_name varchar(32) null,
    lh_texas_home_equity_conversion bit null,
    lh_interest_only_heloc bit null,
    lh_interest_only_term_months int null,
    lh_investor_lock_product_name varchar(128) null,
    lh_investor_lock_product_id varchar(32) null,
    lh_rebuttable_presumption bit null,
    lh_non_conforming bit null,
    lh_num_deal_updates_since_update_pending int null,
    lh_borrower_engagement_percent decimal(11,9) null,
    lh_loan_create_date date null,
    lh_high_balance_hit_percent decimal(11,9) null,
    lh_new_york_payup_percent decimal(11,9) null
);

create table staging_octane.loan_mi_rate_adjustment
(
    lmra_pid bigint
        primary key,
    lmra_version int null,
    lmra_loan_pid bigint null,
    lmra_case_name varchar(16000) null,
    lmra_rate_adjustment_percent decimal(11,9) null
);

create table staging_octane.loan_mi_surcharge
(
    lms_pid bigint
        primary key,
    lms_version int null,
    lms_loan_pid bigint null,
    lms_criteria_html varchar(16000) null,
    lms_government_surcharge_percent decimal(11,9) null,
    lms_government_surcharge_minimum_amount decimal(15,2) null
);

create table staging_octane.loan_price_add_on
(
    lpa_pid bigint
        primary key,
    lpa_version int null,
    lpa_loan_pid bigint null,
    lpa_create_datetime timestamp null,
    lpa_summary varchar(16000) null,
    lpa_rate_adjustment_percent decimal(11,9) null,
    lpa_price_adjustment_percent decimal(11,9) null,
    lpa_arm_margin_adjustment_percent decimal(11,9) null,
    lpa_lock_add_on_type varchar(128) null
);

create table staging_octane.loan_recording
(
    lr_pid bigint
        primary key,
    lr_version int null,
    lr_loan_pid bigint null,
    lr_recording_date date null,
    lr_recording_instrument_number varchar(16) null,
    lr_recording_book_number varchar(16) null,
    lr_recording_volume_number varchar(16) null,
    lr_recording_page_number varchar(16) null,
    lr_recording_jurisdiction_name varchar(16) null,
    lr_recording_witness_unparsed_name varchar(16) null,
    lr_re_recording bit null,
    lr_mers_registration_status_type varchar(128) null,
    lr_mers_registration_date date null,
    lr_mers_registration_errors text null,
    lr_mers_registration_warnings text null,
    lr_mers_transfer_errors text null,
    lr_mers_transfer_warnings text null
);

create table staging_octane.loan_servicer
(
    lsv_pid bigint
        primary key,
    lsv_version int null,
    lsv_loan_pid bigint null,
    lsv_investor_pid bigint null,
    lsv_investor_loan_id varchar(32) null,
    lsv_initial bit null,
    lsv_from_date date null,
    lsv_servicing_data_sent_date date null,
    lsv_retain_notification_date date null,
    lsv_release_notification_date date null,
    lsv_servicing_docs_sent_date date null,
    lsv_mers_transfer_status_type varchar(128) null,
    lsv_mers_transfer_creation_date date null,
    lsv_mers_transfer_override bit null,
    lsv_mers_transfer_batch_pid bigint null,
    lsv_loan_acquisition_scheduled_upb_amount decimal(15,2) null,
    lsv_last_paid_installment_due_date date null,
    lsv_upb_amount decimal(15,2) null,
    lsv_delinquent_payments_over_past_twelve_months_count int null
);

create index idx_loan_servicer_1
    on staging_octane.loan_servicer (lsv_investor_loan_id);

create table staging_octane.lock_series
(
    lsr_pid bigint
        primary key,
    lsr_loan_pid bigint null,
    lsr_version int null,
    lsr_vintage_date date null,
    lsr_series_id int null
);

create table staging_octane.lender_lock_major
(
    llmj_pid bigint
        primary key,
    llmj_version int null,
    llmj_major_version int null,
    llmj_lender_lock_id varchar(11) null,
    llmj_loan_pid bigint null,
    llmj_lien_priority_type varchar(128) null,
    llmj_account_pid bigint null,
    llmj_lock_datetime timestamp null,
    llmj_initial_duration_days int null,
    llmj_initial_lock_expiration_datetime timestamp null,
    llmj_requester_agent_type varchar(128) null,
    llmj_requester_lender_user_pid bigint null,
    llmj_requester_unparsed_name varchar(128) null,
    llmj_request_datetime timestamp null,
    llmj_confirm_datetime timestamp null,
    llmj_confirm_lender_user_pid bigint null,
    llmj_confirm_unparsed_name varchar(128) null,
    llmj_void_request_datetime timestamp null,
    llmj_void_request_lender_user_pid bigint null,
    llmj_void_request_unparsed_name varchar(128) null,
    llmj_void_datetime timestamp null,
    llmj_void_lender_user_pid bigint null,
    llmj_void_unparsed_name varchar(128) null,
    llmj_cancel_datetime timestamp null,
    llmj_cancel_lender_user_pid bigint null,
    llmj_cancel_unparsed_name varchar(128) null,
    llmj_auto_confirmed bit null,
    llmj_active bit null,
    llmj_relock_fee_percent decimal(11,9) null,
    llmj_notes varchar(16000) null,
    llmj_lender_concession_approved_amount decimal(15,2) null,
    llmj_clear_extension_fees_relock bit null,
    llmj_pricing_duration_days int null,
    llmj_pricing_commitment_type varchar(128) null,
    llmj_expired_lock_successor bit null,
    llmj_lock_series_pid bigint null
);

create table staging_octane.bid_pool_lender_lock
(
    bpll_pid bigint
        primary key,
    bpll_version int null,
    bpll_bid_pool_pid bigint null,
    bpll_lender_lock_major_pid bigint null
);

create table staging_octane.lender_concession_request
(
    lcr_pid bigint
        primary key,
    lcr_version int null,
    lcr_loan_pid bigint null,
    lcr_lender_lock_major_pid bigint null,
    lcr_requested_amount decimal(15,2) null,
    lcr_approved_amount decimal(15,2) null,
    lcr_requested_reason varchar(128) null,
    lcr_approved_reason varchar(128) null,
    lcr_requested_datetime timestamp null,
    lcr_decision_datetime timestamp null,
    lcr_decision_notes varchar(1024) null,
    lcr_request_notes varchar(1024) null,
    lcr_requester_lender_user_pid bigint null,
    lcr_requester_unparsed_name varchar(128) null,
    lcr_approver_lender_user_pid bigint null,
    lcr_approver_unparsed_name varchar(128) null,
    lcr_lender_concession_request_status_type varchar(128) null,
    lcr_corporate_amount decimal(15,2) null
);

create table staging_octane.lender_lock_extension
(
    lle_pid bigint
        primary key,
    lle_version int null,
    lle_lender_lock_major_pid bigint null,
    lle_creator_lender_user_pid bigint null,
    lle_creator_unparsed_name varchar(128) null,
    lle_requester_lender_user_pid bigint null,
    lle_requester_unparsed_name varchar(128) null,
    lle_requested_datetime timestamp null,
    lle_confirm_lender_user_pid bigint null,
    lle_confirm_unparsed_name varchar(128) null,
    lle_confirm_datetime timestamp null,
    lle_auto_confirmed bit null,
    lle_reject_lender_user_pid bigint null,
    lle_reject_datetime timestamp null,
    lle_reject_explanation varchar(1024) null,
    lle_lock_extension_status_type varchar(128) null,
    lle_extension_days int null,
    lle_price_adjustment_percent decimal(11,9) null,
    lle_fee_applicable bit null
);

create index idx_lender_lock_major_1
    on staging_octane.lender_lock_major (llmj_lender_lock_id);

create table staging_octane.lender_lock_minor
(
    llmn_pid bigint
        primary key,
    llmn_version int null,
    llmn_lender_lock_major_pid bigint null,
    llmn_minor_version int null,
    llmn_latest_version bit null,
    llmn_lender_lock_status_type varchar(128) null,
    llmn_create_datetime timestamp null,
    llmn_creator_agent_type varchar(128) null,
    llmn_creator_lender_user_pid bigint null,
    llmn_creator_unparsed_name varchar(128) null,
    llmn_effective_lock_expiration_datetime timestamp null,
    llmn_effective_duration_days int null,
    llmn_num_extensions int null,
    llmn_investor_base_note_rate_percent decimal(11,9) null,
    llmn_investor_base_arm_margin_percent decimal(11,9) null,
    llmn_investor_base_price_percent decimal(11,9) null,
    llmn_lock_note_rate_percent decimal(11,9) null,
    llmn_lock_initial_note_rate_percent decimal(11,9) null,
    llmn_lock_arm_margin_percent decimal(11,9) null,
    llmn_lock_price_percent decimal(11,9) null,
    llmn_lock_price_raw_percent decimal(11,9) null,
    llmn_maximum_rebate_percent decimal(11,9) null,
    llmn_maximum_investor_price_percent decimal(11,9) null,
    llmn_maximum_investor_price_includes_srp bit null,
    llmn_created_historic_price_delta decimal(11,9) null,
    llmn_profit_table_name varchar(128) null,
    llmn_total_profit_margin_percent decimal(11,9) null,
    llmn_base_note_rate_percent decimal(11,9) null,
    llmn_base_arm_margin_percent decimal(11,9) null,
    llmn_base_price_percent decimal(11,9) null,
    llmn_pricing_datetime timestamp null,
    llmn_effective_rate_sheet_datetime timestamp null,
    llmn_apor_date date null,
    llmn_proposal_snapshot_pid bigint null,
    llmn_loan_amount decimal(17,2) null,
    llmn_base_loan_amount decimal(17,2) null,
    llmn_lock_commitment_type varchar(128) null,
    llmn_offering_pid bigint null,
    llmn_product_terms_pid bigint null,
    llmn_mortgage_type varchar(128) null,
    llmn_interest_only_type varchar(128) null,
    llmn_buydown_schedule_type varchar(128) null,
    llmn_prepay_penalty_schedule_type varchar(128) null,
    llmn_aus_type varchar(128) null,
    llmn_high_balance_hit_percent decimal(11,9) null,
    llmn_new_york_payup_percent decimal(11,9) null
);

create table staging_octane.lender_lock_add_on
(
    lla_pid bigint
        primary key,
    lla_version int null,
    lla_lender_lock_minor_pid bigint null,
    lla_lock_add_on_type varchar(128) null,
    lla_investor_price_adjustment_percent decimal(11,9) null,
    lla_account_price_adjustment_percent decimal(11,9) null,
    lla_create_datetime timestamp null,
    lla_creator_lender_user_pid bigint null,
    lla_creator_unparsed_name varchar(128) null,
    lla_summary varchar(16000) null,
    lla_rate_adjustment_percent decimal(11,9) null,
    lla_price_adjustment_percent decimal(11,9) null,
    lla_arm_margin_adjustment_percent decimal(11,9) null
);

create table staging_octane.net_tangible_benefit
(
    ntb_pid bigint
        primary key,
    ntb_version int null,
    ntb_net_tangible_benefit_type varchar(128) null,
    ntb_proposal_pid bigint null
);

create table staging_octane.obligation
(
    ob_pid bigint
        primary key,
    ob_version int null,
    ob_proposal_pid bigint null,
    ob_obligation_type varchar(128) null,
    ob_amount_input_type varchar(128) null,
    ob_factor_percent decimal(11,9) null,
    ob_factor_percent_base_amount decimal(15,2) null,
    ob_annual_payment_amount decimal(15,2) null,
    ob_monthly_payment_amount decimal(15,2) null,
    ob_pte_annual_tax_installment_amount decimal(15,2) null,
    ob_pte_annual_preferred_tax_amount decimal(15,2) null,
    ob_pte_annual_homeowner_occupied_estimated_tax_amount decimal(15,2) null,
    ob_pte_annual_exemption_free_estimated_tax_amount decimal(15,2) null,
    ob_payment_date_1 date null,
    ob_payment_date_2 date null,
    ob_payment_date_3 date null,
    ob_payment_date_4 date null,
    ob_payment_date_5 date null,
    ob_payment_date_6 date null,
    ob_payment_amount_1 decimal(15,2) null,
    ob_payment_amount_2 decimal(15,2) null,
    ob_payment_amount_3 decimal(15,2) null,
    ob_payment_amount_4 decimal(15,2) null,
    ob_payment_amount_5 decimal(15,2) null,
    ob_payment_amount_6 decimal(15,2) null,
    ob_total_dated_payment_amount decimal(15,2) null,
    ob_vendor_first_name varchar(32) null,
    ob_vendor_last_name varchar(32) null,
    ob_vendor_middle_name varchar(32) null,
    ob_vendor_name_suffix varchar(32) null,
    ob_vendor_company_name varchar(128) null,
    ob_vendor_title varchar(128) null,
    ob_vendor_office_phone varchar(32) null,
    ob_vendor_office_phone_extension varchar(16) null,
    ob_vendor_mobile_phone varchar(32) null,
    ob_vendor_email varchar(256) null,
    ob_vendor_fax varchar(32) null,
    ob_vendor_city varchar(128) null,
    ob_vendor_country varchar(128) null,
    ob_vendor_postal_code varchar(128) null,
    ob_vendor_state varchar(128) null,
    ob_vendor_street1 varchar(128) null,
    ob_vendor_street2 varchar(128) null,
    ob_vendor_reference_id varchar(128) null,
    ob_name varchar(128) null,
    ob_payment_amount_1_warning varchar(1024) null,
    ob_payment_amount_2_warning varchar(1024) null,
    ob_payment_amount_3_warning varchar(1024) null,
    ob_payment_amount_4_warning varchar(1024) null,
    ob_payment_amount_5_warning varchar(1024) null,
    ob_payment_amount_6_warning varchar(1024) null,
    ob_tax_auto_compute bit null,
    ob_policy_dwelling_coverage_amount decimal(15) null,
    ob_policy_extended_coverage_amount decimal(15) null,
    ob_policy_deductible_amount decimal(15) null,
    ob_policy_effective_date date null,
    ob_policy_expiration_date date null,
    ob_escrow_waiver varchar(128) null,
    ob_insurance_transferred bit null
);

create table staging_octane.loan_charge
(
    lc_pid bigint
        primary key,
    lc_version int null,
    lc_proposal_pid bigint null,
    lc_obligation_pid bigint null,
    lc_account_charge_ordinal int null,
    lc_loan_position_type varchar(128) null,
    lc_charge_type varchar(128) null,
    lc_name varchar(128) null,
    lc_charge_payer_type varchar(128) null,
    lc_charge_payee_type varchar(128) null,
    lc_paid_by varchar(128) null,
    lc_paid_to varchar(128) null,
    lc_poc bit null,
    lc_poc_applicable bit null,
    lc_charge_wire_action_type varchar(128) null,
    lc_reduction_amount decimal(15) null,
    lc_apr bit null,
    lc_base_amount decimal(16,3) null,
    lc_configured_total_amount decimal(15,2) null,
    lc_total_amount decimal(15,2) null,
    lc_charge_input_type varchar(128) null,
    lc_charge_input_type_base_amount decimal(16,3) null,
    lc_charge_input_type_percent decimal(11,9) null,
    lc_charge_input_type_currency decimal(16,3) null,
    lc_hud_section_number varchar(16) null,
    lc_hud_line_number varchar(16) null,
    lc_user_defined bit null,
    lc_months_auto_compute bit null,
    lc_months int null,
    lc_per_diem_amount decimal(15,2) null,
    lc_per_diem_rate decimal(11,9) null,
    lc_days int null,
    lc_financed bit null,
    lc_financed_auto_compute bit null,
    lc_financed_amount decimal(15) null,
    lc_auto_compute bit null,
    lc_charge_source_type varchar(128) null,
    lc_obligation_charge_input_type varchar(128) null,
    lc_from_date date null,
    lc_through_date date null,
    lc_smart_charge_config_warning varchar(1024) null,
    lc_reduction_amount_warning varchar(1024) null,
    lc_advance_amount_warning varchar(1024) null,
    lc_fha_mip_refund_warning varchar(1024) null,
    lc_aggregate_adjustment_compute_warning varchar(1024) null,
    lc_advance_obligation_compute_warning varchar(1024) null,
    lc_escrow_obligation_compute_warning varchar(1024) null,
    lc_excess_financing_concession_warning varchar(1024) null,
    lc_amount_exceeds_cap_warning varchar(1024) null,
    lc_subtract_lenders_title_insurance_amount bit null,
    lc_lender_insurance_exceeds_owner_insurance_warning varchar(1024) null,
    lc_manual_circumstance_change_type_1 varchar(128) null,
    lc_manual_circumstance_change_type_2 varchar(128) null,
    lc_configured_charge_payer_type varchar(128) null,
    lc_configured_charge_payee_type varchar(128) null,
    lc_configured_paid_by varchar(128) null,
    lc_configured_paid_to varchar(128) null,
    lc_configured_poc bit null,
    lc_configured_financed bit null,
    lc_charge_wire_action_auto_compute bit null
);

create table staging_octane.place
(
    pl_pid bigint
        primary key,
    pl_version int null,
    pl_proposal_pid bigint null,
    pl_subject_property bit null,
    pl_acquisition_date date null,
    pl_construction_improvement_costs_amount decimal(15) null,
    pl_financed_units_count int null,
    pl_unit_count int null,
    pl_land_estimated_value_amount decimal(15) null,
    pl_land_original_cost_amount decimal(15) null,
    pl_leasehold_expiration_date date null,
    pl_legal_description_type varchar(128) null,
    pl_legal_description varchar(32000) null,
    pl_property_tax_id varchar(32) null,
    pl_legal_lot varchar(32) null,
    pl_legal_block varchar(32) null,
    pl_legal_section varchar(32) null,
    pl_project_name varchar(128) null,
    pl_cpm_project_id varchar(128) null,
    pl_acquisition_cost_amount decimal(15) null,
    pl_county_pid bigint null,
    pl_sub_jurisdiction_name varchar(128) null,
    pl_recording_district_name varchar(128) null,
    pl_project_classification_type varchar(128) null,
    pl_property_category_type varchar(128) null,
    pl_property_rights_type varchar(128) null,
    pl_refinance_total_improvement_costs_amount decimal(15) null,
    pl_refinance_improvements_type varchar(128) null,
    pl_refinance_proposed_improvements_description varchar(32) null,
    pl_structure_built_year int null,
    pl_structure_built_month int null,
    pl_title_manner_held_type varchar(128) null,
    pl_title_manner_held_description varchar(1024) null,
    pl_building_status_type varchar(128) null,
    pl_construction_conversion varchar(128) null,
    pl_native_american_lands_type varchar(128) null,
    pl_community_land_trust bit null,
    pl_inclusionary_zoning bit null,
    pl_unique_dwelling_type varchar(128) null,
    pl_living_unit_count int null,
    pl_project_design_type varchar(128) null,
    pl_city varchar(128) null,
    pl_country varchar(128) null,
    pl_postal_code varchar(128) null,
    pl_state varchar(128) null,
    pl_street1 varchar(128) null,
    pl_street2 varchar(128) null,
    pl_street_tbd bit null,
    pl_landlord_first_name varchar(32) null,
    pl_landlord_last_name varchar(32) null,
    pl_landlord_middle_name varchar(32) null,
    pl_landlord_name_suffix varchar(32) null,
    pl_landlord_company_name varchar(128) null,
    pl_landlord_title varchar(128) null,
    pl_landlord_office_phone varchar(32) null,
    pl_landlord_office_phone_extension varchar(16) null,
    pl_landlord_mobile_phone varchar(32) null,
    pl_landlord_email varchar(256) null,
    pl_landlord_fax varchar(32) null,
    pl_landlord_city varchar(128) null,
    pl_landlord_country varchar(128) null,
    pl_landlord_postal_code varchar(128) null,
    pl_landlord_state varchar(128) null,
    pl_landlord_street1 varchar(128) null,
    pl_landlord_street2 varchar(128) null,
    pl_management_first_name varchar(32) null,
    pl_management_last_name varchar(32) null,
    pl_management_middle_name varchar(32) null,
    pl_management_name_suffix varchar(32) null,
    pl_management_company_name varchar(128) null,
    pl_management_title varchar(128) null,
    pl_management_office_phone varchar(32) null,
    pl_management_office_phone_extension varchar(16) null,
    pl_management_mobile_phone varchar(32) null,
    pl_management_email varchar(256) null,
    pl_management_fax varchar(32) null,
    pl_management_city varchar(128) null,
    pl_management_country varchar(128) null,
    pl_management_postal_code varchar(128) null,
    pl_management_state varchar(128) null,
    pl_management_street1 varchar(128) null,
    pl_management_street2 varchar(128) null,
    pl_property_insurance_amount_input_type varchar(128) null,
    pl_property_tax_amount_input_type varchar(128) null,
    pl_annual_property_insurance_amount decimal(15,2) null,
    pl_annual_property_tax_amount decimal(15,2) null,
    pl_monthly_property_insurance_amount decimal(15,2) null,
    pl_monthly_hoa_amount decimal(15,2) null,
    pl_monthly_mi_amount decimal(15,2) null,
    pl_monthly_property_tax_amount decimal(15,2) null,
    pl_monthly_lease_ground_rent_amount decimal(15,2) null,
    pl_monthly_rent_amount decimal(15,2) null,
    pl_monthly_obligation_amount decimal(15,2) null,
    pl_use_proposed_property_usage bit null,
    pl_property_usage_type varchar(128) null,
    pl_property_value_amount decimal(15) null,
    pl_reo_disposition_status_type varchar(128) null,
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
    pl_mh_serial_number varchar(128) null,
    pl_mh_hud_label_number varchar(128) null,
    pl_mh_certificate_of_title_issued varchar(128) null,
    pl_mh_certificate_of_title_number varchar(32) null,
    pl_mh_certificate_of_title_type varchar(128) null,
    pl_mh_loan_purpose_type varchar(128) null,
    pl_mh_anchored bit null,
    pl_coop_company_name varchar(128) null,
    pl_coop_building_name varchar(128) null,
    pl_coop_vacant_units int null,
    pl_coop_proprietary_lease_date date null,
    pl_coop_assignment_lease_date date null,
    pl_coop_existing_company_laws_state varchar(128) null,
    pl_coop_shares_being_purchased int null,
    pl_coop_attorney_in_fact varchar(128) null,
    pl_coop_stock_certificate_number varchar(32) null,
    pl_coop_apartment_unit varchar(32) null,
    pl_rental bit null,
    pl_underwriter_comments varchar(1024) null,
    pl_lava_zone_type varchar(128) null,
    pl_neighborhood_location_type varchar(128) null,
    pl_site_area decimal(15) null,
    pl_hud_reo varchar(128) null,
    pl_energy_improvement_replacement_major_system bit null,
    pl_energy_improvement_insulation_sealant bit null,
    pl_energy_improvement_installation_solar bit null,
    pl_energy_improvement_addition_new_feature bit null,
    pl_energy_improvement_other bit null,
    pl_energy_related_repairs_or_improvements_amount decimal(15,2) null,
    pl_refinance_general_improvements_amount decimal(15) null,
    pl_va_guaranteed_reo varchar(128) null,
    pl_va_loan_date date null,
    pl_gross_building_area_square_feet int null,
    pl_project_dwelling_units_sold_count int null,
    pl_prior_owners_title bit null,
    pl_prior_owners_title_policy_amount decimal(15,2) null,
    pl_prior_owners_title_policy_effective_date date null,
    pl_prior_lenders_title bit null,
    pl_prior_lenders_title_policy_amount decimal(15,2) null,
    pl_prior_lenders_title_policy_effective_date date null,
    pl_bedroom_count_unit_1 int null,
    pl_bedroom_count_unit_2 int null,
    pl_bedroom_count_unit_3 int null,
    pl_bedroom_count_unit_4 int null,
    pl_rent_amount_unit_1 decimal(15,2) null,
    pl_rent_amount_unit_2 decimal(15,2) null,
    pl_rent_amount_unit_3 decimal(15,2) null,
    pl_rent_amount_unit_4 decimal(15,2) null,
    pl_listed_for_sale_in_last_6_months varchar(128) null,
    pl_property_in_borrower_trust varchar(128) null,
    pl_road_type varchar(128) null,
    pl_water_type varchar(128) null,
    pl_sanitation_type varchar(128) null,
    pl_survey_required varchar(128) null,
    pl_solar_panels_type varchar(128) null,
    pl_power_purchase_agreement varchar(128) null,
    pl_solar_panel_provider_name varchar(128) null,
    pl_seller_acquired_date date null,
    pl_seller_original_cost_amount decimal(15) null,
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
    pl_mh_leasehold__property_interest_type varchar(128) null,
    pl_tribe_name varchar(128) null,
    pl_leasehold_begin_date date null,
    pl_lease_number varchar(128) null,
    pl_property_inspection_required bit null,
    pl_hvac_inspection_required bit null,
    pl_pest_inspection_required bit null,
    pl_radon_inspection_required bit null,
    pl_septic_inspection_required bit null,
    pl_water_well_inspection_required bit null,
    pl_structural_inspection_required bit null,
    pl_pest_inspection_required_auto_compute bit null,
    pl_management_agent_federal_tax_id varchar(32) null,
    pl_mh_manufacturer_street_1 varchar(128) null,
    pl_mh_manufacturer_street_2 varchar(128) null,
    pl_mh_manufacturer_city varchar(128) null,
    pl_mh_manufacturer_state varchar(128) null,
    pl_mh_manufacturer_postal_code varchar(128) null,
    pl_mh_manufacturer_phone varchar(32) null,
    pl_mh_manufacturer_phone_extension varchar(16) null,
    pl_recording_city_name varchar(128) null,
    pl_abbreviated_legal_description varchar(1024) null,
    pl_geocode_service_disabled bit null,
    pl_vesting_confirmed bit null,
    pl_previous_title_manner_held_description varchar(1024) null,
    pl_legal_lot_na bit null,
    pl_legal_block_na bit null,
    pl_legal_section_na bit null,
    pl_legal_description_confirmed bit null,
    pl_lead_inspection_required varchar(128) null,
    pl_calculated_lead_inspection_required varchar(128) null,
    pl_geocode_system_error bit null
);

create table staging_octane.borrower_reo
(
    breo_pid bigint
        primary key,
    breo_version int null,
    breo_borrower_pid bigint null,
    breo_place_pid bigint null,
    breo_ownership_percent decimal(11,9) null
);

create table staging_octane.borrower_residence
(
    bres_pid bigint
        primary key,
    bres_version int null,
    bres_borrower_pid bigint null,
    bres_place_pid bigint null,
    bres_current bit null,
    bres_borrower_residency_basis_type varchar(128) null,
    bres_from_date date null,
    bres_through_date date null,
    bres_verification_required bit null
);

create table staging_octane.borrower_tax_filing
(
    btf_pid bigint
        primary key,
    btf_version int null,
    btf_borrower_pid bigint null,
    btf_place_pid bigint null,
    btf_tax_filing_status_type varchar(128) null,
    btf_year int null,
    btf_joint_is_coborrower bit null,
    btf_joint_filer_first_name varchar(32) null,
    btf_joint_filer_middle_name varchar(32) null,
    btf_joint_filer_last_name varchar(32) null,
    btf_joint_filer_suffix varchar(32) null
);

create table staging_octane.borrower_va
(
    bva_pid bigint
        primary key,
    bva_version int null,
    bva_borrower_pid bigint null,
    bva_veteran_status_type varchar(128) null,
    bva_va_funding_fee_exempt bit null,
    bva_subsequent_use bit null,
    bva_claim_folder_number varchar(32) null,
    bva_benefit_related_indebtedness varchar(128) null,
    bva_available_entitlement_amount decimal(15,2) null,
    bva_va_entitlement_code_type varchar(128) null,
    bva_disability_benefits_prior_to_discharge varchar(128) null,
    bva_active_duty_following_separation varchar(128) null,
    bva_separated_from_service_due_to_disability varchar(128) null,
    bva_disability_payments varchar(128) null,
    bva_surviving_spouse_receiving_dic_payments varchar(128) null,
    bva_surviving_spouse_dic_claim_number varchar(128) null,
    bva_deceased_spouse_first_name varchar(32) null,
    bva_deceased_spouse_middle_name varchar(32) null,
    bva_deceased_spouse_last_name varchar(32) null,
    bva_deceased_spouse_name_suffix varchar(32) null,
    bva_deceased_spouse_claim_folder_number varchar(32) null,
    bva_deceased_spouse_claim_folder_location varchar(32) null,
    bva_deceased_spouse_service_number varchar(32) null,
    bva_deceased_spouse_military_branch_type varchar(128) null,
    bva_deceased_spouse_birth_date date null,
    bva_deceased_spouse_death_date date null,
    bva_deceased_spouse_service_from_date_1 date null,
    bva_deceased_spouse_service_through_date_1 date null,
    bva_deceased_spouse_service_from_date_2 date null,
    bva_deceased_spouse_service_through_date_2 date null,
    bva_deceased_spouse_service_from_date_3 date null,
    bva_deceased_spouse_service_through_date_3 date null,
    bva_previously_applied_for_eligibility varchar(128) null,
    bva_previously_secured_center_type varchar(128) null,
    bva_previously_applied_for_eligibility_center_type varchar(128) null,
    bva_previously_received_certificate_of_eligibility_center_type varchar(128) null,
    bva_previously_received_certificate_of_eligibility varchar(128) null,
    bva_previous_loan_address_street1 varchar(128) null,
    bva_previous_loan_address_street2 varchar(128) null,
    bva_previous_loan_address_city varchar(128) null,
    bva_previous_loan_address_state varchar(128) null,
    bva_previous_loan_address_postal_code varchar(128) null,
    bva_previous_loan_number varchar(128) null,
    bva_previous_loan_month int null,
    bva_previous_loan_year int null,
    bva_veteran_poa_verification_date date null,
    bva_relative_first_name varchar(32) null,
    bva_relative_middle_name varchar(32) null,
    bva_relative_last_name varchar(32) null,
    bva_relative_name_suffix varchar(32) null,
    bva_relative_address_street1 varchar(128) null,
    bva_relative_address_street2 varchar(128) null,
    bva_relative_address_city varchar(128) null,
    bva_relative_address_state varchar(128) null,
    bva_relative_address_postal_code varchar(128) null,
    bva_relative_phone_number varchar(32) null,
    bva_va_relative_relationship_type varchar(128) null,
    bva_va_relative_relationship_other_description varchar(32) null,
    bva_service_related_disability bit null,
    bva_purple_heart_recipient bit null,
    bva_va_funding_fee_exemption_verified bit null,
    bva_entitlement_charged_amount decimal(15,2) null,
    bva_used_entitlement_amount decimal(15,2) null,
    bva_va_entitlement_restoration_type varchar(128) null,
    bva_previous_use_place_pid bigint null
);

create index idx_place_1
    on staging_octane.place (pl_state);

create table staging_octane.profit_margin_detail
(
    pmd_pid bigint
        primary key,
    pmd_version int null,
    pmd_lender_lock_minor_pid bigint null,
    pmd_profit_margin_type varchar(128) null,
    pmd_description varchar(128) null,
    pmd_percent decimal(11,9) null,
    pmd_dollars decimal(15,2) null,
    pmd_adjustment_description varchar(16000) null
);

create index idx_profit_margin_detail_1
    on staging_octane.profit_margin_detail (pmd_lender_lock_minor_pid);

create index idx_proposal_1
    on staging_octane.proposal (prp_create_datetime);

create table staging_octane.proposal_contractor
(
    pctr_pid bigint
        primary key,
    pctr_version int null,
    pctr_proposal_pid bigint null,
    pctr_contractor_pid bigint null
);

create table staging_octane.construction_cost
(
    coc_pid bigint
        primary key,
    coc_version int null,
    coc_proposal_pid bigint null,
    coc_construction_cost_category_type varchar(128) null,
    coc_construction_cost_funding_type varchar(128) null,
    coc_construction_cost_status_type varchar(128) null,
    coc_construction_cost_payee_type varchar(128) null,
    coc_create_datetime timestamp null,
    coc_construction_cost_amount decimal(15,2) null,
    coc_construction_cost_notes varchar(1024) null,
    coc_contractor_pid bigint null,
    coc_proposal_contractor_pid bigint null,
    coc_payee varchar(128) null
);

create table staging_octane.construction_draw_item
(
    cdi_pid bigint
        primary key,
    cdi_version int null,
    cdi_proposal_pid bigint null,
    cdi_construction_cost_pid bigint null,
    cdi_construction_draw_pid bigint null,
    cdi_construction_draw_item_amount decimal(15,2) null,
    cdi_construction_draw_item_borrower_contribution_amount decimal(15,2) null,
    cdi_construction_draw_item_lender_contribution_amount decimal(15,2) null
);

create table staging_octane.proposal_doc_set
(
    prpds_pid bigint
        primary key,
    prpds_version int null,
    prpds_proposal_pid bigint null,
    prpds_smart_doc_set_pid bigint null,
    prpds_create_datetime timestamp null,
    prpds_delivered_or_mailed_datetime timestamp null,
    prpds_creator_agent_type varchar(128) null,
    prpds_creator_lender_user_pid bigint null,
    prpds_creator_unparsed_name varchar(128) null,
    prpds_requested_datetime timestamp null,
    prpds_requester_agent_type varchar(128) null,
    prpds_requester_lender_user_pid bigint null,
    prpds_requester_unparsed_name varchar(128) null,
    prpds_signed_date date null,
    prpds_delivery_method_type varchar(128) null,
    prpds_tracking_number varchar(32) null,
    prpds_affects_earliest_allowed_consummation_date bit null,
    prpds_name varchar(128) null,
    prpds_docusign_package_pid bigint null,
    prpds_esign_vendor_type varchar(128) null,
    prpds_esign_evidence_deal_file_pid bigint null,
    prpds_doc_package_status_type varchar(128) null,
    prpds_canceled_reason_type varchar(128) null,
    prpds_canceled_datetime timestamp null,
    prpds_canceler_agent_type varchar(128) null,
    prpds_canceler_lender_user_pid bigint null,
    prpds_canceler_unparsed_name varchar(128) null,
    prpds_canceled_reason varchar(16000) null,
    prpds_proposal_doc_set_id int null
);

create table staging_octane.proposal_doc_set_id_ticker
(
    pdstk_pid bigint
        primary key,
    pdstk_version int null,
    pdstk_proposal_pid bigint null,
    pdstk_smart_doc_set_pid bigint null,
    pdstk_next_proposal_doc_set_id int null
);

create table staging_octane.proposal_doc_set_signer
(
    prpdss_pid bigint
        primary key,
    prpdss_version int null,
    prpdss_proposal_doc_set_pid bigint null,
    prpdss_deal_signer_pid bigint null,
    prpdss_esign_complete bit null,
    prpdss_received_datetime timestamp null,
    prpdss_signed_datetime timestamp null
);

create table staging_octane.proposal_doc_set_snapshot
(
    prpdssn_pid bigint
        primary key,
    prpdssn_version int null,
    prpdssn_proposal_doc_set_pid bigint null,
    prpdssn_snapshot_proposal_pid bigint null
);

create table staging_octane.proposal_engagement
(
    prpe_pid bigint
        primary key,
    prpe_version int null,
    prpe_proposal_pid bigint null,
    prpe_borrower_engagement_percent decimal(11,9) null
);

create table staging_octane.proposal_grant_program
(
    pgp_pid bigint
        primary key,
    pgp_version int null,
    pgp_proposal_pid bigint null,
    pgp_account_grant_program_pid bigint null,
    pgp_grant_amount decimal(15,2) null
);

create table staging_octane.proposal_review
(
    prpre_pid bigint
        primary key,
    prpre_version int null,
    prpre_proposal_pid bigint null,
    prpre_request_id int null,
    prpre_request_datetime timestamp null,
    prpre_request_by_lender_user_pid bigint null,
    prpre_request_summary text null,
    prpre_proposal_review_status_type varchar(128) null,
    prpre_decision_datetime timestamp null,
    prpre_decision_by_lender_user_pid bigint null,
    prpre_decision_summary text null
);

create table staging_octane.proposal_review_ticker
(
    prpret_pid bigint
        primary key,
    prpret_version int null,
    prpret_proposal_pid bigint null,
    prpret_next_id int null
);

create table staging_octane.proposal_summary
(
    ps_pid bigint
        primary key,
    ps_version int null,
    ps_proposal_pid bigint null,
    ps_subject_property_city varchar(128) null,
    ps_subject_property_country varchar(128) null,
    ps_subject_property_postal_code varchar(128) null,
    ps_subject_property_state varchar(128) null,
    ps_subject_property_street1 varchar(128) null,
    ps_subject_property_street2 varchar(128) null,
    ps_note_rate_percent_main decimal(11,9) null,
    ps_note_rate_percent_piggyback decimal(11,9) null,
    ps_initial_note_rate_percent_main decimal(11,9) null,
    ps_initial_note_rate_percent_piggyback decimal(11,9) null,
    ps_base_loan_amount_main decimal(17,2) null,
    ps_base_loan_amount_piggyback decimal(17,2) null,
    ps_loan_amount_main decimal(17,2) null,
    ps_loan_amount_piggyback decimal(17,2) null,
    ps_product_special_program_type_main varchar(128) null,
    ps_product_special_program_type_piggyback varchar(128) null,
    ps_investor_pid_main bigint null,
    ps_investor_pid_piggyback bigint null,
    ps_product_fnm_community_lending_product_type_main varchar(128) null,
    ps_product_fnm_community_lending_product_type_piggyback varchar(128) null,
    ps_product_fre_community_program_type_main varchar(128) null,
    ps_product_fre_community_program_type_piggyback varchar(128) null,
    ps_mortgage_type_main varchar(128) null,
    ps_mortgage_type_piggyback varchar(128) null,
    ps_b1_first_name varchar(32) null,
    ps_c1_first_name varchar(32) null,
    ps_b2_first_name varchar(32) null,
    ps_b1_last_name varchar(32) null,
    ps_c1_last_name varchar(32) null,
    ps_b2_last_name varchar(32) null,
    ps_b1_middle_name varchar(32) null,
    ps_c1_middle_name varchar(32) null,
    ps_b2_middle_name varchar(32) null,
    ps_b1_preferred_first_name varchar(32) null,
    ps_b2_preferred_first_name varchar(32) null,
    ps_c1_preferred_first_name varchar(32) null,
    ps_b1_birth_date date null,
    ps_c1_birth_date date null,
    ps_b1_monthly_income decimal(15,2) null,
    ps_c1_monthly_income decimal(15,2) null,
    ps_b2_monthly_income decimal(15,2) null,
    ps_b1_has_business_income bit null,
    ps_c1_has_business_income bit null,
    ps_b2_has_business_income bit null,
    ps_b1_citizenship_residency_type varchar(128) null,
    ps_c1_citizenship_residency_type varchar(128) null,
    ps_b2_citizenship_residency_type varchar(128) null,
    ps_b1_hmda_ethnicity_2017_type varchar(128) null,
    ps_c1_hmda_ethnicity_2017_type varchar(128) null,
    ps_b2_hmda_ethnicity_2017_type varchar(128) null,
    ps_b1_decision_credit_score int null,
    ps_c1_decision_credit_score int null,
    ps_b2_decision_credit_score int null,
    ps_b1_gender_type varchar(128) null,
    ps_c1_gender_type varchar(128) null,
    ps_b2_gender_type varchar(128) null,
    ps_b1_hmda_race_2017_type varchar(128) null,
    ps_c1_hmda_race_2017_type varchar(128) null,
    ps_b2_hmda_race_2017_type varchar(128) null,
    ps_any_lender_employee_borrower bit null,
    ps_upfront_mi_percent_main decimal(11,9) null,
    ps_upfront_mi_percent_piggyback decimal(11,9) null,
    ps_primary_application_name varchar(128) null,
    ps_investor_loan_id_main varchar(32) null,
    ps_investor_loan_id_piggyback varchar(32) null,
    ps_initial_servicer_investor_loan_id_main varchar(32) null,
    ps_initial_servicer_investor_loan_id_piggyback varchar(32) null,
    ps_current_servicer_investor_loan_id_main varchar(32) null,
    ps_current_servicer_investor_loan_id_piggyback varchar(32) null,
    ps_offering_id_main varchar(32) null,
    ps_offering_id_piggyback varchar(32) null,
    ps_proposal_structure_type varchar(128) null,
    ps_loan_maturity_date_main date null,
    ps_loan_maturity_date_piggyback date null,
    ps_ltv_ratio_percent_main decimal(11,9) null,
    ps_ltv_ratio_percent_piggyback decimal(11,9) null,
    ps_cltv_ratio_percent decimal(11,9) null,
    ps_hcltv_ratio_percent decimal(11,9) null,
    ps_hcltv_applicable bit null,
    ps_debt_ratio_percent decimal(11,9) null,
    ps_housing_ratio_percent decimal(11,9) null,
    ps_property_category_type varchar(128) null,
    ps_any_first_time_home_buyer bit null,
    ps_primary_housing_expense_amount decimal(15,2) null,
    ps_non_primary_housing_expense_amount decimal(15,2) null,
    ps_income_monthly_total_amount decimal(15,2) null,
    ps_asset_total_amount decimal(15,2) null,
    ps_liquid_asset_total_amount decimal(15,2) null,
    ps_liability_unpaid_balance_total_amount decimal(15,2) null,
    ps_liability_monthly_payment_total_amount decimal(15,2) null,
    ps_monthly_pitia_amount decimal(15,2) null,
    ps_cash_from_borrower_amount_signed decimal(15,2) null,
    ps_proposed_monthly_housing_and_debt_amount decimal(15,2) null,
    ps_funding_date_main date null,
    ps_funding_date_piggyback date null,
    ps_interim_funder_company_name varchar(128) null,
    ps_interim_funder_mers_org_id varchar(7) null,
    ps_funding_scheduled_release_date_main date null,
    ps_funding_scheduled_release_date_piggyback date null,
    ps_uuts_aus_recommendation_description varchar(32) null,
    ps_interest_rate_fee_amount_signed decimal(15,2) null,
    ps_interest_rate_fee_amount_signed_main decimal(15,2) null,
    ps_interest_rate_fee_amount_signed_piggyback decimal(15,2) null,
    ps_origination_fees_amount_signed decimal(15,2) null,
    ps_origination_fees_amount_signed_main decimal(15,2) null,
    ps_origination_fees_amount_signed_piggyback decimal(15,2) null,
    ps_any_escrow_waived bit null,
    ps_initial_rate_adjustment_date_main date null,
    ps_initial_rate_adjustment_date_piggyback date null,
    ps_tolerance_cure_amount_signed decimal(15,2) null,
    ps_tolerance_cure_amount_signed_main decimal(15,2) null,
    ps_tolerance_cure_amount_signed_piggyback decimal(15,2) null,
    ps_subject_property_existing_subordinate_2nd bit null,
    ps_subject_property_subordinate_2nd_creditor_pid bigint null,
    ps_subject_property_existing_subordinate_3rd bit null,
    ps_subject_property_subordinate_3rd_creditor_pid bigint null,
    ps_total_monthly_solar_lease_payments_amount decimal(15,2) null,
    ps_total_debt_payoff_amount decimal(15,2) null,
    ps_total_new_subordinate_financing_amount decimal(15,2) null,
    ps_total_grant_amount decimal(15,2) null,
    ps_any_third_party_community_second bit null,
    ps_any_grant_program bit null,
    ps_initial_loan_estimate_loan_amount_main decimal(17,2) null,
    ps_initial_loan_estimate_loan_amount_piggyback decimal(17,2) null,
    ps_any_mortgage_credit_certificate bit null,
    ps_debt_ratio_excluding_mi_percent decimal(11,9) null,
    ps_fund_source_type_main varchar(128) null,
    ps_fund_source_type_piggyback varchar(128) null,
    ps_mortgage_credit_certificate_issuer_pid bigint null,
    ps_subject_property_new_subordinate_2nd bit null,
    ps_subject_property_new_subordinate_3rd bit null,
    ps_any_borrower_self_employed bit null,
    ps_fha_section_of_act_coarse_type_main varchar(128) null,
    ps_fha_section_of_act_coarse_type_piggyback varchar(128) null,
    ps_fha_special_program_type_main varchar(128) null,
    ps_fha_special_program_type_piggyback varchar(128) null,
    ps_product_pid_main bigint null,
    ps_product_pid_piggyback bigint null,
    ps_net_origination_charge_main decimal(15,2) null,
    ps_net_origination_charge_piggyback decimal(15,2) null,
    ps_household_income_guideline_percent decimal(22,9) null,
    ps_applicant_count smallint null,
    ps_early_wire_total_charge_amount_main decimal(15,2) null,
    ps_early_wire_total_charge_amount_piggyback decimal(15,2) null,
    ps_funding_scheduled_release_date_auto_compute_main bit null,
    ps_funding_scheduled_release_date_auto_compute_piggyback bit null
);

create index idx_proposal_summary_1
    on staging_octane.proposal_summary (ps_subject_property_street1);

create index idx_proposal_summary_2
    on staging_octane.proposal_summary (ps_subject_property_street2);

create index idx_proposal_summary_3
    on staging_octane.proposal_summary (ps_subject_property_city);

create index idx_proposal_summary_4
    on staging_octane.proposal_summary (ps_investor_loan_id_main);

create index idx_proposal_summary_5
    on staging_octane.proposal_summary (ps_investor_loan_id_piggyback);

create index idx_proposal_summary_6
    on staging_octane.proposal_summary (ps_subject_property_state);

create index idx_proposal_summary_7
    on staging_octane.proposal_summary (ps_funding_date_main);

create index idx_proposal_summary_8
    on staging_octane.proposal_summary (ps_funding_date_piggyback);

create table staging_octane.pte_request
(
    pter_pid bigint
        primary key,
    pter_version int null,
    pter_proposal_pid bigint null,
    pter_create_datetime timestamp null,
    pter_pte_request_status_type varchar(128) null,
    pter_pte_response_status_type varchar(128) null,
    pter_pte_error_messages text null,
    pter_address_street1 varchar(128) null,
    pter_address_street2 varchar(128) null,
    pter_address_city varchar(128) null,
    pter_address_state varchar(128) null,
    pter_address_postal_code varchar(128) null,
    pter_response_xml_pid bigint null,
    pter_response_pdf_file_pid bigint null,
    pter_submitting_party_order_id varchar(128) null,
    pter_responding_party_order_id varchar(32) null,
    pter_fulfillment_party_order_id varchar(32) null,
    pter_building_status_type varchar(128) null,
    pter_loan_purpose_type varchar(128) null,
    pter_effective_property_value_amount decimal(15) null,
    pter_property_usage_type varchar(128) null
);

create table staging_octane.public_record
(
    pr_pid bigint
        primary key,
    pr_version int null,
    pr_proposal_pid bigint null,
    pr_credit_request_pid bigint null,
    pr_public_record_type varchar(128) null,
    pr_public_record_type_other_description varchar(32) null,
    pr_public_record_disposition_type varchar(128) null,
    pr_report_public_record_disposition_type varchar(128) null,
    pr_disposition_date date null,
    pr_filed_date date null,
    pr_reported_date date null,
    pr_settled_date date null,
    pr_paid_date date null,
    pr_docket_id varchar(32) null,
    pr_bankruptcy_exception_type varchar(128) null,
    pr_bankruptcy_assets_amount decimal(15,2) null,
    pr_bankruptcy_exempt_amount decimal(15,2) null,
    pr_bankruptcy_liabilities_amount decimal(15,2) null,
    pr_legal_obligation_amount decimal(15,2) null,
    pr_court_name varchar(128) null,
    pr_plaintiff_name varchar(128) null,
    pr_defendant_name varchar(128) null,
    pr_attorney_name varchar(128) null,
    pr_comment varchar(16000) null,
    pr_note varchar(1024) null,
    pr_equifax_included bit null,
    pr_experian_included bit null,
    pr_trans_union_included bit null,
    pr_credit_report_identifier varchar(32) null
);

create table staging_octane.borrower_public_record
(
    bpr_pid bigint
        primary key,
    bpr_version int null,
    bpr_borrower_pid bigint null,
    bpr_public_record_pid bigint null
);

create table staging_octane.rental_income
(
    ri_pid bigint
        primary key,
    ri_version int null,
    ri_borrower_income_pid bigint null,
    ri_place_pid bigint null,
    ri_schedule_e_input bit null,
    ri_rental_income_estimated_mode bit null,
    ri_rental_income_estimated_gross_monthly_amount decimal(15,2) null,
    ri_simple_monthly_total_amount decimal(15,2) null,
    ri_schedule_e_calculated_gross_monthly_amount decimal(15,2) null,
    ri_schedule_e_proposed_monthly_expense_amount decimal(15,2) null,
    ri_schedule_e_net_monthly_amount decimal(15,2) null,
    ri_rental_income_monthly_total_amount decimal(15,2) null,
    ri_schedule_e_non_recurring_expense_1 varchar(128) null,
    ri_schedule_e_non_recurring_expense_2 varchar(128) null,
    ri_schedule_e_non_recurring_expense_3 varchar(128) null,
    ri_rental_income_calc_method varchar(128) null,
    ri_common_year1_year int null,
    ri_common_year1_year_include bit null,
    ri_common_year1_from_date date null,
    ri_common_year1_through_date date null,
    ri_common_year1_months decimal(4,2) null,
    ri_common_year1_annual_total_amount decimal(15,2) null,
    ri_common_year1_monthly_total_amount decimal(15,2) null,
    ri_common_year2_year int null,
    ri_common_year2_year_include bit null,
    ri_common_year2_from_date date null,
    ri_common_year2_through_date date null,
    ri_common_year2_months decimal(4,2) null,
    ri_common_year2_annual_total_amount decimal(15,2) null,
    ri_common_year2_monthly_total_amount decimal(15,2) null,
    ri_common_year3_year int null,
    ri_common_year3_year_include bit null,
    ri_common_year3_from_date date null,
    ri_common_year3_through_date date null,
    ri_common_year3_months decimal(4,2) null,
    ri_common_year3_annual_total_amount decimal(15,2) null,
    ri_common_year3_monthly_total_amount decimal(15,2) null,
    ri_schedule_e_year1_rent_received_amount decimal(15,2) null,
    ri_schedule_e_year1_advertising_expense_amount decimal(15,2) null,
    ri_schedule_e_year1_auto_travel_expense_amount decimal(15,2) null,
    ri_schedule_e_year1_cleaning_maintenance_expense_amount decimal(15,2) null,
    ri_schedule_e_year1_commissions_expense_amount decimal(15,2) null,
    ri_schedule_e_year1_insurance_expense_amount decimal(15,2) null,
    ri_schedule_e_year1_legal_professional_expense_amount decimal(15,2) null,
    ri_schedule_e_year1_management_expense_amount decimal(15,2) null,
    ri_schedule_e_year1_mortgage_interest_expense_amount decimal(15,2) null,
    ri_schedule_e_year1_other_interest_expense_amount decimal(15,2) null,
    ri_schedule_e_year1_repairs_expense_amount decimal(15,2) null,
    ri_schedule_e_year1_supplies_expense_amount decimal(15,2) null,
    ri_schedule_e_year1_taxes_expense_amount decimal(15,2) null,
    ri_schedule_e_year1_utilities_expense_amount decimal(15,2) null,
    ri_schedule_e_year1_depreciation_expense_amount decimal(15,2) null,
    ri_schedule_e_year1_other_expense_amount decimal(15,2) null,
    ri_schedule_e_year1_total_expense_amount decimal(15,2) null,
    ri_schedule_e_year1_non_recurring_expense_amount_1 decimal(15,2) null,
    ri_schedule_e_year1_non_recurring_expense_amount_2 decimal(15,2) null,
    ri_schedule_e_year1_non_recurring_expense_amount_3 decimal(15,2) null,
    ri_schedule_e_year1_insurance_credit_amount decimal(15,2) null,
    ri_schedule_e_year1_taxes_credit_amount decimal(15,2) null,
    ri_schedule_e_year1_annual_subtotal decimal(15,2) null,
    ri_schedule_e_year1_ownership_percent decimal(11,9) null,
    ri_schedule_e_year2_rent_received_amount decimal(15,2) null,
    ri_schedule_e_year2_advertising_expense_amount decimal(15,2) null,
    ri_schedule_e_year2_auto_travel_expense_amount decimal(15,2) null,
    ri_schedule_e_year2_cleaning_maintenance_expense_amount decimal(15,2) null,
    ri_schedule_e_year2_commissions_expense_amount decimal(15,2) null,
    ri_schedule_e_year2_insurance_expense_amount decimal(15,2) null,
    ri_schedule_e_year2_legal_professional_expense_amount decimal(15,2) null,
    ri_schedule_e_year2_management_expense_amount decimal(15,2) null,
    ri_schedule_e_year2_mortgage_interest_expense_amount decimal(15,2) null,
    ri_schedule_e_year2_other_interest_expense_amount decimal(15,2) null,
    ri_schedule_e_year2_repairs_expense_amount decimal(15,2) null,
    ri_schedule_e_year2_supplies_expense_amount decimal(15,2) null,
    ri_schedule_e_year2_taxes_expense_amount decimal(15,2) null,
    ri_schedule_e_year2_utilities_expense_amount decimal(15,2) null,
    ri_schedule_e_year2_depreciation_expense_amount decimal(15,2) null,
    ri_schedule_e_year2_other_expense_amount decimal(15,2) null,
    ri_schedule_e_year2_total_expense_amount decimal(15,2) null,
    ri_schedule_e_year2_non_recurring_expense_amount_1 decimal(15,2) null,
    ri_schedule_e_year2_non_recurring_expense_amount_2 decimal(15,2) null,
    ri_schedule_e_year2_non_recurring_expense_amount_3 decimal(15,2) null,
    ri_schedule_e_year2_insurance_credit_amount decimal(15,2) null,
    ri_schedule_e_year2_taxes_credit_amount decimal(15,2) null,
    ri_schedule_e_year2_annual_subtotal decimal(15,2) null,
    ri_schedule_e_year2_ownership_percent decimal(11,9) null,
    ri_schedule_e_year3_rent_received_amount decimal(15,2) null,
    ri_schedule_e_year3_advertising_expense_amount decimal(15,2) null,
    ri_schedule_e_year3_auto_travel_expense_amount decimal(15,2) null,
    ri_schedule_e_year3_cleaning_maintenance_expense_amount decimal(15,2) null,
    ri_schedule_e_year3_commissions_expense_amount decimal(15,2) null,
    ri_schedule_e_year3_insurance_expense_amount decimal(15,2) null,
    ri_schedule_e_year3_legal_professional_expense_amount decimal(15,2) null,
    ri_schedule_e_year3_management_expense_amount decimal(15,2) null,
    ri_schedule_e_year3_mortgage_interest_expense_amount decimal(15,2) null,
    ri_schedule_e_year3_other_interest_expense_amount decimal(15,2) null,
    ri_schedule_e_year3_repairs_expense_amount decimal(15,2) null,
    ri_schedule_e_year3_supplies_expense_amount decimal(15,2) null,
    ri_schedule_e_year3_taxes_expense_amount decimal(15,2) null,
    ri_schedule_e_year3_utilities_expense_amount decimal(15,2) null,
    ri_schedule_e_year3_depreciation_expense_amount decimal(15,2) null,
    ri_schedule_e_year3_other_expense_amount decimal(15,2) null,
    ri_schedule_e_year3_total_expense_amount decimal(15,2) null,
    ri_schedule_e_year3_non_recurring_expense_amount_1 decimal(15,2) null,
    ri_schedule_e_year3_non_recurring_expense_amount_2 decimal(15,2) null,
    ri_schedule_e_year3_non_recurring_expense_amount_3 decimal(15,2) null,
    ri_schedule_e_year3_insurance_credit_amount decimal(15,2) null,
    ri_schedule_e_year3_taxes_credit_amount decimal(15,2) null,
    ri_schedule_e_year3_annual_subtotal decimal(15,2) null,
    ri_schedule_e_year3_ownership_percent decimal(11,9) null,
    ri_simple_monthly_rent_amount decimal(15,2) null,
    ri_simple_vacancy_maintenance_adjustment_percent decimal(11,9) null,
    ri_simple_monthly_net_rent_amount decimal(15,2) null,
    ri_simple_monthly_expense_amount decimal(15,2) null,
    ri_simple_monthly_pre_ownership_income_amount decimal(15,2) null,
    ri_simple_ownership_percent decimal(11,9) null,
    ri_simple_calculated_monthly_amount decimal(15,2) null
);

create table staging_octane.sap_quote_request
(
    sqr_pid bigint
        primary key,
    sqr_version int null,
    sqr_deal_pid bigint null,
    sqr_include_conventional bit null,
    sqr_include_fha bit null,
    sqr_include_va bit null,
    sqr_include_fixed_rate bit null,
    sqr_include_arm bit null,
    sqr_due_in_term_months_string_list text null
);

create table staging_octane.secondary_settings
(
    sset_pid bigint
        primary key,
    sset_version int null,
    sset_account_pid bigint null,
    sset_default_lead_source_pid bigint null,
    sset_default_mortech_account_pid bigint null,
    sset_default_beneficiary_investor_pid bigint null,
    sset_default_servicer_investor_pid bigint null,
    sset_initial_lender_lock_id bigint null,
    sset_initial_lender_trade_id bigint null,
    sset_lock_expiration_warning_days int null,
    sset_expired_lock_update_allowed_days int null,
    sset_disable_all_locking bit null,
    sset_pricing_engine_type varchar(128) null,
    sset_price_match_check_suspend_through_date date null,
    sset_mortech_disable_eligibility bit null,
    sset_mortech_strict_eligibility bit null,
    sset_zillow_appraisal_fee decimal(15,2) null,
    sset_zillow_title_fee decimal(15,2) null,
    sset_zillow_recording_fee decimal(15,2) null,
    sset_mortech_floating_adjuster_prefixes varchar(16000) null,
    sset_rate_lock_acknowledgement_due_days int null,
    sset_rate_lock_supporting_documentation_due_days int null,
    sset_rate_lock_appraisal_inspection_due_days int null,
    sset_min_subordinate_financing_lock_term_days int null,
    sset_servicer_loan_id_minimum_available_threshold int null,
    sset_servicer_loan_id_minimum_available_warning_email varchar(256) null,
    sset_third_party_base_margin_prefixes varchar(16000) null,
    sset_third_party_floating_margin_prefixes varchar(16000) null,
    sset_month_ami_uses_subsequent_year int null,
    sset_day_ami_uses_subsequent_year int null
);

create table staging_octane.servicer_loan_id_import_request
(
    slir_pid bigint
        primary key,
    slir_version int null,
    slir_account_pid bigint null,
    slir_create_datetime timestamp null,
    slir_import_lender_user_pid bigint null,
    slir_imported_loan_id_count int null,
    slir_error_loan_id_count int null,
    slir_servicer_loan_id_import_request_status_type varchar(128) null
);

create table staging_octane.servicer_loan_id_assignment
(
    slia_pid bigint
        primary key,
    slia_version int null,
    slia_account_pid bigint null,
    slia_servicer_loan_id_import_request_pid bigint null,
    slia_loan_servicer_pid bigint null,
    slia_servicer_loan_id varchar(32) null,
    slia_servicer_loan_id_assign_type varchar(128) null,
    slia_assigned_datetime timestamp null
);

create table staging_octane.smart_doc
(
    sd_pid bigint
        primary key,
    sd_version int null,
    sd_account_pid bigint null,
    sd_doc_set_type varchar(128) null,
    sd_custom_form_pid bigint null,
    sd_doc_name varchar(767) null,
    sd_doc_number decimal(15,3) null,
    sd_doc_category_type varchar(128) null,
    sd_doc_file_source_type varchar(128) null,
    sd_doc_external_provider_type varchar(128) null,
    sd_broker_applicable_provider bit null,
    sd_action_entities_from_merge_field bit null,
    sd_action_entity_applicant bit null,
    sd_action_entity_non_applicant bit null,
    sd_action_entity_underwriter bit null,
    sd_action_entity_originator bit null,
    sd_doc_borrower_access_mode_type varchar(128) null,
    sd_borrower_explanation varchar(1024) null,
    sd_deal_child_type varchar(128) null,
    sd_doc_fulfill_status_type_default varchar(128) null,
    sd_prior_to_type varchar(128) null,
    sd_doc_action_type varchar(128) null,
    sd_e_delivery bit null,
    sd_active bit null,
    sd_doc_validity_type varchar(128) null,
    sd_doc_key_date_type varchar(128) null,
    sd_expiration_rule_type varchar(128) null,
    sd_days_before_key_date int null,
    sd_warning_days int null,
    sd_key_doc_type varchar(128) null,
    sd_key_doc_include_file varchar(128) null,
    sd_doc_approval_type varchar(128) null,
    sd_auto_approve bit null,
    sd_auto_include_on_request bit null,
    sd_poa_applicable bit null,
    sd_action_entity_hud_va_lender_officer bit null,
    sd_action_entity_collateral_underwriter bit null,
    sd_action_entity_wholesale_client_advocate bit null,
    sd_action_entity_correspondent_client_advocate bit null
);

create table staging_octane.smart_doc_criteria
(
    sdc_pid bigint
        primary key,
    sdc_version int null,
    sdc_smart_doc_pid bigint null,
    sdc_criteria_pid bigint null,
    sdc_deal_child_type varchar(128) null
);

create table staging_octane.smart_doc_note
(
    sdn_pid bigint
        primary key,
    sdn_version int null,
    sdn_smart_doc_pid bigint null,
    sdn_create_datetime timestamp null,
    sdn_content varchar(16000) null,
    sdn_author_lender_user_pid bigint null,
    sdn_author_unparsed_name varchar(128) null
);

create table staging_octane.smart_doc_note_comment
(
    sdnc_pid bigint
        primary key,
    sdnc_version int null,
    sdnc_smart_doc_note_pid bigint null,
    sdnc_create_datetime timestamp null,
    sdnc_content varchar(16000) null,
    sdnc_author_lender_user_pid bigint null,
    sdnc_author_unparsed_name varchar(128) null
);

create table staging_octane.smart_doc_note_monitor
(
    sdnm_pid bigint
        primary key,
    sdnm_version int null,
    sdnm_smart_doc_note_pid bigint null,
    sdnm_lender_user_pid bigint null
);

create table staging_octane.smart_doc_role
(
    sdr_pid bigint
        primary key,
    sdr_version int null,
    sdr_smart_doc_pid bigint null,
    sdr_role_pid bigint null,
    sdr_doc_permission_type varchar(128) null
);

create table staging_octane.smart_message
(
    smsg_pid bigint
        primary key,
    smsg_version int null,
    smsg_account_pid bigint null,
    smsg_name varchar(256) null,
    smsg_delivery_type varchar(128) null,
    smsg_reply_to_role_pid bigint null,
    smsg_email_subject varchar(1024) null,
    smsg_message_source_type varchar(128) null,
    smsg_smart_doc_pid bigint null,
    smsg_smart_stack_pid bigint null,
    smsg_allow_ad_hoc bit null,
    smsg_send_securely bit null,
    smsg_id_num int null,
    smsg_message_body varchar(16000) null,
    smsg_email_closing_type varchar(128) null
);

create table staging_octane.smart_message_recipient
(
    smr_pid bigint
        primary key,
    smr_version int null,
    smr_smart_message_pid bigint null,
    smr_recipient_type varchar(128) null,
    smr_role_pid bigint null,
    smr_email_recipient_type varchar(128) null
);

create table staging_octane.smart_req
(
    sr_pid bigint
        primary key,
    sr_version int null,
    sr_smart_doc_pid bigint null,
    sr_criteria_pid bigint null,
    sr_deal_child_type varchar(128) null,
    sr_deal_child_relationship_type varchar(128) null,
    sr_req_name varchar(767) null,
    sr_borrower_access bit null,
    sr_active bit null
);

create table staging_octane.smart_separator
(
    ssp_pid bigint
        primary key,
    ssp_version int null,
    ssp_account_pid bigint null,
    ssp_custom_form_pid bigint null,
    ssp_criteria_pid bigint null,
    ssp_separator_name varchar(767) null
);

create table staging_octane.smart_set_doc
(
    sstd_pid bigint
        primary key,
    sstd_version int null,
    sstd_smart_doc_set_pid bigint null,
    sstd_smart_doc_pid bigint null,
    sstd_sequence int null
);

create table staging_octane.smart_stack_doc
(
    ssd_pid bigint
        primary key,
    ssd_version int null,
    ssd_smart_stack_pid bigint null,
    ssd_stack_doc_type varchar(128) null,
    ssd_smart_doc_set_pid bigint null,
    ssd_smart_separator_pid bigint null,
    ssd_smart_doc_pid bigint null,
    ssd_sequence bigint null,
    ssd_smart_stack_doc_set_include_type varchar(128) null
);

create table staging_octane.stack_export_request
(
    ser_pid bigint
        primary key,
    ser_version int null,
    ser_account_pid bigint null,
    ser_create_datetime timestamp null,
    ser_start_datetime timestamp null,
    ser_end_datetime timestamp null,
    ser_request_status_type varchar(128) null,
    ser_loan_export_type varchar(128) null,
    ser_loan_name_format_type varchar(128) null,
    ser_file_name_format_type varchar(128) null,
    ser_requester_lender_user_pid bigint null,
    ser_requester_unparsed_name varchar(128) null,
    ser_smart_stack_pid bigint null,
    ser_total_deal_count int null,
    ser_exported_deal_count int null,
    ser_description varchar(32) null
);

create table staging_octane.stack_export_file
(
    sef_pid bigint
        primary key,
    sef_version int null,
    sef_stack_export_request_pid bigint null,
    sef_repository_file_pid bigint null,
    sef_stack_export_file_type varchar(128) null
);

create table staging_octane.tax_transcript_request
(
    ttr_pid bigint
        primary key,
    ttr_version int null,
    ttr_deal_pid bigint null,
    ttr_create_datetime timestamp null,
    ttr_requester_agent_type varchar(128) null,
    ttr_requester_lender_user_pid bigint null,
    ttr_requester_unparsed_name varchar(128) null,
    ttr_mismo_version_type varchar(128) null,
    ttr_credit_request_type varchar(128) null,
    ttr_request_error_messages text null,
    ttr_request_success_messages text null,
    ttr_tracking_number varchar(16) null,
    ttr_tax_transcript_request_status_type varchar(128) null,
    ttr_update_reason varchar(1024) null,
    ttr_last_status_query_datetime timestamp null,
    ttr_signed_4506t_deal_file_pid bigint null,
    ttr_company bit null,
    ttr_company_name varchar(128) null,
    ttr_company_city varchar(128) null,
    ttr_company_country varchar(128) null,
    ttr_company_postal_code varchar(128) null,
    ttr_company_state varchar(128) null,
    ttr_company_street1 varchar(128) null,
    ttr_company_street2 varchar(128) null,
    ttr_company_ein varchar(16) null,
    ttr_borrower1_pid bigint null,
    ttr_borrower1_first_name varchar(32) null,
    ttr_borrower1_middle_name varchar(32) null,
    ttr_borrower1_last_name varchar(32) null,
    ttr_borrower1_name_suffix varchar(32) null,
    ttr_borrower1_birth_date date null,
    ttr_borrower1_current_city varchar(128) null,
    ttr_borrower1_current_country varchar(128) null,
    ttr_borrower1_current_postal_code varchar(128) null,
    ttr_borrower1_current_state varchar(128) null,
    ttr_borrower1_current_street1 varchar(128) null,
    ttr_borrower1_current_street2 varchar(128) null,
    ttr_borrower1_prior_city varchar(128) null,
    ttr_borrower1_prior_country varchar(128) null,
    ttr_borrower1_prior_postal_code varchar(128) null,
    ttr_borrower1_prior_state varchar(128) null,
    ttr_borrower1_prior_street1 varchar(128) null,
    ttr_borrower1_prior_street2 varchar(128) null,
    ttr_borrower1_monthly_income_amount decimal(15,2) null,
    ttr_borrower2_pid bigint null,
    ttr_borrower2_first_name varchar(32) null,
    ttr_borrower2_middle_name varchar(32) null,
    ttr_borrower2_last_name varchar(32) null,
    ttr_borrower2_name_suffix varchar(32) null,
    ttr_borrower2_birth_date date null,
    ttr_borrower2_current_city varchar(128) null,
    ttr_borrower2_current_country varchar(128) null,
    ttr_borrower2_current_postal_code varchar(128) null,
    ttr_borrower2_current_state varchar(128) null,
    ttr_borrower2_current_street1 varchar(128) null,
    ttr_borrower2_current_street2 varchar(128) null,
    ttr_borrower2_prior_city varchar(128) null,
    ttr_borrower2_prior_country varchar(128) null,
    ttr_borrower2_prior_postal_code varchar(128) null,
    ttr_borrower2_prior_state varchar(128) null,
    ttr_borrower2_prior_street1 varchar(128) null,
    ttr_borrower2_prior_street2 varchar(128) null,
    ttr_borrower2_monthly_income_amount decimal(15,2) null,
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
    ttr_company_phone varchar(32) null,
    ttr_company_phone_extension varchar(16) null,
    ttr_business_ownership_type varchar(128) null
);

create table staging_octane.third_party_community_second_program
(
    tpcsp_pid bigint
        primary key,
    tpcsp_version int null,
    tpcsp_account_pid bigint null,
    tpcsp_program_id varchar(32) null,
    tpcsp_program_name varchar(128) null,
    tpcsp_fre_community_program_type varchar(128) null,
    tpcsp_fnm_community_lending_product_type varchar(128) null,
    tpcsp_fnm_community_seconds_repayment_structure_type varchar(128) null,
    tpcsp_ein varchar(10) null,
    tpcsp_wire_action_type varchar(128) null,
    tpcsp_security_instrument_page_count int null,
    tpcsp_deed_page_count int null,
    tpcsp_notes varchar(1024) null,
    tpcsp_from_date date null,
    tpcsp_through_date date null,
    tpcsp_investor_pid bigint null
);

create table staging_octane.liability
(
    lia_pid bigint
        primary key,
    lia_version int null,
    lia_proposal_pid bigint null,
    lia_creditor_pid bigint null,
    lia_aggregate_description varchar(128) null,
    lia_credit_request_pid bigint null,
    lia_description varchar(128) null,
    lia_city varchar(128) null,
    lia_country varchar(128) null,
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
    lia_liability_disposition_type varchar(128) null,
    lia_liability_type varchar(128) null,
    lia_report_liability_type varchar(128) null,
    lia_lien_priority_type varchar(128) null,
    lia_monthly_payment_amount decimal(15,2) null,
    lia_report_monthly_payment_amount decimal(15,2) null,
    lia_remaining_term_months int null,
    lia_report_remaining_term_months int null,
    lia_months_reviewed_count int null,
    lia_high_balance_amount decimal(15,2) null,
    lia_credit_limit_amount decimal(15) null,
    lia_report_credit_limit_amount decimal(15) null,
    lia_past_due_amount decimal(15,2) null,
    lia_report_past_due_amount decimal(15,2) null,
    lia_unpaid_balance_amount decimal(15,2) null,
    lia_report_unpaid_balance_amount decimal(15,2) null,
    lia_report_value_overridden bit null,
    lia_place_pid bigint null,
    lia_liability_foreclosure_exception_type varchar(128) null,
    lia_bankruptcy_exception_type varchar(128) null,
    lia_liability_current_rating_type varchar(128) null,
    lia_liability_account_status_type varchar(128) null,
    lia_report_account_ownership_type varchar(128) null,
    lia_consumer_dispute varchar(128) null,
    lia_derogatory_data varchar(128) null,
    lia_late30_days_count varchar(16) null,
    lia_late60_days_count varchar(16) null,
    lia_late90_days_count varchar(16) null,
    lia_note varchar(1024) null,
    lia_equifax_included bit null,
    lia_experian_included bit null,
    lia_trans_union_included bit null,
    lia_liability_financing_type varchar(128) null,
    lia_original_loan_amount decimal(15) null,
    lia_interest_rate_on_statement bit null,
    lia_interest_rate_percent decimal(11,9) null,
    lia_loan_amortization_type varchar(128) null,
    lia_interest_only varchar(128) null,
    lia_property_taxes_escrowed bit null,
    lia_property_insurance_escrowed bit null,
    lia_senior_lien_restriction_type varchar(128) null,
    lia_senior_lien_restriction_amount decimal(15) null,
    lia_agency_case_id varchar(32) null,
    lia_terms_months_count int null,
    lia_report_terms_months_count int null,
    lia_payoff_statement_date date null,
    lia_payoff_statement_good_through_date date null,
    lia_next_payment_due_date date null,
    lia_payoff_statement_interest decimal(15,2) null,
    lia_daily_interest_amount decimal(15,2) null,
    lia_monthly_interest_amount decimal(15,2) null,
    lia_payoff_interest_pad_days int null,
    lia_effective_payoff_date date null,
    lia_effective_payoff_date_adjustment_amount decimal(15,2) null,
    lia_effective_payoff_date_adjustment_days int null,
    lia_other_payoff_related_charges_amount decimal(15,2) null,
    lia_payoff_amount decimal(15,2) null,
    lia_payoff_amount_estimated bit null,
    lia_used_to_acquire_property varchar(128) null,
    lia_heloc_advance_last_12_months_over_thousand varchar(128) null,
    lia_liability_mi_type varchar(128) null,
    lia_texas_equity varchar(128) null,
    lia_texas_equity_locked bit null,
    lia_texas_equity_conversion varchar(128) null,
    lia_credit_report_identifier varchar(32) null,
    lia_net_escrow varchar(128) null,
    lia_third_party_community_second_program_pid bigint null,
    lia_current_escrow_balance_amount decimal(15,2) null,
    lia_first_payment_date date null,
    lia_closing_date date null,
    lia_mip_due_amount decimal(15,2) null,
    lia_unpaid_late_charges_amount decimal(15,2) null,
    lia_include_within_cema varchar(128) null,
    lia_energy_related_type varchar(128) null
);

create table staging_octane.borrower_liability
(
    bl_pid bigint
        primary key,
    bl_version int null,
    bl_borrower_pid bigint null,
    bl_liability_pid bigint null
);

create table staging_octane.deal_tag
(
    dtg_pid bigint
        primary key,
    dtg_version int null,
    dtg_deal_tag_definition_pid bigint null,
    dtg_deal_pid bigint null,
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
    dtg_appraisal_pid bigint null
);

create table staging_octane.product_third_party_community_second_program
(
    ptpp_pid bigint
        primary key,
    ptpp_version int null,
    ptpp_product_terms_pid bigint null,
    ptpp_third_party_community_second_program_pid bigint null
);

create table staging_octane.proposal_doc
(
    prpd_pid bigint
        primary key,
    prpd_version int null,
    prpd_doc_name varchar(767) null,
    prpd_doc_number decimal(15,3) null,
    prpd_borrower_access bit null,
    prpd_deal_child_type varchar(128) null,
    prpd_deal_child_name varchar(767) null,
    prpd_deal_pid bigint null,
    prpd_proposal_pid bigint null,
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
    prpd_smart_doc_pid bigint null,
    prpd_proposal_doc_set_pid bigint null,
    prpd_doc_fulfill_status_type varchar(128) null,
    prpd_status_unparsed_name varchar(128) null,
    prpd_status_datetime timestamp null,
    prpd_status_reason varchar(1024) null,
    prpd_doc_excluded bit null,
    prpd_doc_excluded_reason varchar(1024) null,
    prpd_doc_excluded_unparsed_name varchar(128) null,
    prpd_doc_excluded_datetime timestamp null,
    prpd_doc_approval_type varchar(128) null,
    prpd_borrower_edit bit null,
    prpd_last_status_reason text null,
    prpd_borrower_associated_address_pid bigint null,
    prpd_construction_cost_pid bigint null,
    prpd_construction_draw_pid bigint null,
    prpd_proposal_contractor_pid bigint null
);

create table staging_octane.proposal_doc_borrower_access
(
    pdba_pid bigint
        primary key,
    pdba_version int null,
    pdba_borrower_pid bigint null,
    pdba_proposal_doc_pid bigint null
);

create table staging_octane.proposal_doc_file
(
    prpdf_pid bigint
        primary key,
    prpdf_version int null,
    prpdf_proposal_doc_pid bigint null,
    prpdf_deal_file_pid bigint null,
    prpdf_proposal_doc_file_type varchar(128) null,
    prpdf_included_file varchar(128) null,
    prpdf_key_doc bit null
);

create table staging_octane.proposal_req
(
    prpr_pid bigint
        primary key,
    prpr_version int null,
    prpr_proposal_doc_pid bigint null,
    prpr_req_name varchar(767) null,
    prpr_borrower_access bit null,
    prpr_req_id int null,
    prpr_req_fulfill_status_type varchar(128) null,
    prpr_fulfill_status_unparsed_name varchar(128) null,
    prpr_fulfill_status_reason varchar(1024) null,
    prpr_fulfill_status_datetime timestamp null,
    prpr_req_decision_status_type varchar(128) null,
    prpr_decision_status_unparsed_name varchar(128) null,
    prpr_decision_status_reason varchar(1024) null,
    prpr_decision_status_datetime timestamp null,
    prpr_deal_pid bigint null,
    prpr_proposal_pid bigint null,
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
    prpr_deal_child_type varchar(128) null,
    prpr_deal_child_name varchar(767) null,
    prpr_smart_req bit null,
    prpr_smart_req_criteria_html text null,
    prpr_trash bit null,
    prpr_borrower_associated_address_pid bigint null,
    prpr_construction_cost_pid bigint null,
    prpr_construction_draw_pid bigint null,
    prpr_proposal_contractor_pid bigint null
);

create table staging_octane.sap_deal_step
(
    sds_pid bigint
        primary key,
    sds_version int null,
    sds_borrower_user_pid bigint null,
    sds_previous_pid bigint null,
    sds_sap_step_type varchar(128) null,
    sds_complete_datetime timestamp null,
    sds_yes_no_answer varchar(128) null,
    sds_deal_pid bigint null,
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
    sds_business_income_pid bigint null
);

create table staging_octane.deal_sap
(
    dsap_pid bigint
        primary key,
    dsap_version int null,
    dsap_deal_pid bigint null,
    dsap_last_sap_deal_step_pid bigint null,
    dsap_last_sap_step_type varchar(128) null,
    dsap_credit_pull_attempts int null,
    dsap_retry_credit_pull bit null,
    dsap_borrower_step_type int null
);

create table staging_octane.trade
(
    t_pid bigint
        primary key,
    t_version int null,
    t_account_pid bigint null,
    t_investor_pid bigint null,
    t_create_lender_user_pid bigint null,
    t_create_datetime timestamp null,
    t_lender_trade_id varchar(11) null,
    t_investor_trade_id varchar(32) null,
    t_investor_commitment_id varchar(32) null,
    t_trade_name varchar(128) null,
    t_trade_status_type varchar(128) null,
    t_commitment_amount_tolerance_percent decimal(11,9) null,
    t_commitment_amount decimal(15,2) null,
    t_minimum_note_rate_percent decimal(11,9) null,
    t_maximum_note_rate_percent decimal(11,9) null,
    t_actual_delivery_datetime timestamp null,
    t_early_delivery_datetime timestamp null,
    t_required_delivery_datetime timestamp null,
    t_commitment_expiration_datetime timestamp null,
    t_commitment_datetime timestamp null,
    t_purchase_datetime timestamp null,
    t_weighted_average_note_rate_percent decimal(11,9) null,
    t_weighted_average_lender_price_percent decimal(11,9) null,
    t_weighted_average_investor_price_percent decimal(11,9) null,
    t_weighted_average_net_price_percent decimal(11,9) null,
    t_weighted_average_decision_credit_score int null,
    t_average_loan_amount decimal(15,2) null,
    t_total_loan_amount decimal(17,2) null,
    t_loans_delivered_percent decimal(11,9) null,
    t_trade_pricing_type varchar(128) null,
    t_trade_same_price_percent decimal(11,9) null,
    t_buy_up_multiple int null,
    t_buy_down_multiple int null
);

create table staging_octane.investor_lock
(
    il_pid bigint
        primary key,
    il_version int null,
    il_lender_lock_major_pid bigint null,
    il_product_terms_pid bigint null,
    il_mortgage_type varchar(128) null,
    il_interest_only_type varchar(128) null,
    il_buydown_schedule_type varchar(128) null,
    il_prepay_penalty_schedule_type varchar(128) null,
    il_lock_commitment_type varchar(128) null,
    il_initial_duration_days int null,
    il_commitment_datetime timestamp null,
    il_initial_commitment_expiration_datetime timestamp null,
    il_effective_commitment_expiration_datetime timestamp null,
    il_effective_duration_days int null,
    il_cancel_datetime timestamp null,
    il_cancel_lender_user_pid bigint null,
    il_cancel_unparsed_name varchar(128) null,
    il_confirm_datetime timestamp null,
    il_confirm_lender_user_pid bigint null,
    il_confirm_unparsed_name varchar(128) null,
    il_requester_lender_user_pid bigint null,
    il_requester_unparsed_name varchar(128) null,
    il_request_datetime timestamp null,
    il_notes varchar(16000) null,
    il_investor_base_note_rate_percent decimal(11,9) null,
    il_investor_base_arm_margin_percent decimal(11,9) null,
    il_investor_base_price_percent decimal(11,9) null,
    il_lock_note_rate_percent decimal(11,9) null,
    il_lock_initial_note_rate_percent decimal(11,9) null,
    il_lock_arm_margin_percent decimal(11,9) null,
    il_lock_price_percent decimal(11,9) null,
    il_lock_price_raw_percent decimal(11,9) null,
    il_maximum_rebate_percent decimal(11,9) null,
    il_trade_pid bigint null,
    il_hedging bit null,
    il_investor_lock_status_type varchar(128) null,
    il_investor_loan_id varchar(32) null,
    il_required_delivery_datetime timestamp null,
    il_investor_commitment_id varchar(32) null
);

create table staging_octane.investor_lock_add_on
(
    ila_pid bigint
        primary key,
    ila_version int null,
    ila_investor_lock_pid bigint null,
    ila_create_datetime timestamp null,
    ila_creator_lender_user_pid bigint null,
    ila_creator_unparsed_name varchar(128) null,
    ila_summary varchar(16000) null,
    ila_rate_adjustment_percent decimal(11,9) null,
    ila_price_adjustment_percent decimal(11,9) null,
    ila_arm_margin_adjustment_percent decimal(11,9) null
);

create table staging_octane.investor_lock_extension
(
    ile_pid bigint
        primary key,
    ile_version int null,
    ile_investor_lock_pid bigint null,
    ile_creator_lender_user_pid bigint null,
    ile_creator_unparsed_name varchar(128) null,
    ile_requester_lender_user_pid bigint null,
    ile_requester_unparsed_name varchar(128) null,
    ile_requested_datetime timestamp null,
    ile_confirm_lender_user_pid bigint null,
    ile_confirm_unparsed_name varchar(128) null,
    ile_confirm_datetime timestamp null,
    ile_reject_lender_user_pid bigint null,
    ile_reject_datetime timestamp null,
    ile_reject_explanation varchar(1024) null,
    ile_lock_extension_status_type varchar(128) null,
    ile_extension_days int null,
    ile_price_adjustment_percent decimal(11,9) null
);

create index idx_trade_1
    on staging_octane.trade (t_lender_trade_id);

create table staging_octane.trade_audit
(
    ta_pid bigint
        primary key,
    ta_version int null,
    ta_trade_pid bigint null,
    ta_lender_lock_major_pid bigint null,
    ta_trade_audit_type varchar(128) null,
    ta_message varchar(256) null
);

create table staging_octane.trade_fee
(
    tfe_pid bigint
        primary key,
    tfe_version int null,
    tfe_trade_pid bigint null,
    tfe_trade_fee_type_pid bigint null,
    tfe_amount decimal(15,2) null,
    tfe_description varchar(256) null
);

create table staging_octane.trade_file
(
    tf_pid bigint
        primary key,
    tf_version int null,
    tf_trade_pid bigint null,
    tf_repository_file_pid bigint null
);

create table staging_octane.trade_lock_filter
(
    tlf_pid bigint
        primary key,
    tlf_version int null,
    tlf_lender_user_pid bigint null,
    tlf_name varchar(128) null,
    tlf_criteria_pid bigint null
);

create table staging_octane.trade_note
(
    tn_pid bigint
        primary key,
    tn_version int null,
    tn_trade_pid bigint null,
    tn_create_datetime timestamp null,
    tn_content varchar(16000) null,
    tn_author_lender_user_pid bigint null,
    tn_author_unparsed_name varchar(128) null
);

create table staging_octane.trade_note_comment
(
    tnc_pid bigint
        primary key,
    tnc_version int null,
    tnc_trade_note_pid bigint null,
    tnc_create_datetime timestamp null,
    tnc_content varchar(16000) null,
    tnc_author_lender_user_pid bigint null,
    tnc_author_unparsed_name varchar(128) null
);

create table staging_octane.trade_note_monitor
(
    tnm_pid bigint
        primary key,
    tnm_version int null,
    tnm_trade_note_pid bigint null,
    tnm_lender_user_pid bigint null
);

create table staging_octane.trade_product
(
    tp_pid bigint
        primary key,
    tp_version int null,
    tp_product_pid bigint null,
    tp_trade_pid bigint null
);

create table staging_octane.unpaid_balance_adjustment
(
    upba_pid bigint
        primary key,
    upba_version int null,
    upba_investor_pid bigint null,
    upba_adjustment_percent decimal(11,9) null,
    upba_from_date date null,
    upba_mortgage_type varchar(128) null
);

create table staging_octane.vendor_document_repository_file
(
    vdrf_pid bigint
        primary key,
    vdrf_version int null,
    vdrf_account_pid bigint null,
    vdrf_deal_pid bigint null,
    vdrf_document_import_vendor_type varchar(128) null,
    vdrf_client_filename varchar(128) null,
    vdrf_client_filepath varchar(256) null,
    vdrf_file_checksum varchar(128) null,
    vdrf_vendor_import_document_type varchar(128) null,
    vdrf_document_import_status_type varchar(128) null,
    vdrf_processed_datetime timestamp null
);

create table staging_octane.deal_data_vendor_document_import
(
    ddvdi_pid bigint
        primary key,
    ddvdi_version int null,
    ddvdi_deal_pid bigint null,
    ddvdi_vendor_document_repository_file_pid bigint null,
    ddvdi_deal_system_file_pid bigint null,
    ddvdi_vendor_import_document_type varchar(128) null,
    ddvdi_create_datetime timestamp null,
    ddvdi_document_import_status_type varchar(128) null,
    ddvdi_failure_info varchar(16000) null,
    ddvdi_warning_info varchar(16000) null
);

create table staging_octane.vendor_document_event
(
    vde_pid bigint
        primary key,
    vde_version int null,
    vde_account_pid bigint null,
    vde_vendor_document_repository_file_pid bigint null,
    vde_vendor_document_event_type varchar(128) null,
    vde_source_unparsed_name varchar(128) null,
    vde_messages text null,
    vde_create_datetime timestamp null,
    vde_create_date date null
);

create table staging_octane.wf_deal_process
(
    wdpr_pid bigint
        primary key,
    wdpr_version int null,
    wdpr_deal_pid bigint null,
    wdpr_wf_process_pid bigint null,
    wdpr_wf_deal_process_status_type varchar(128) null,
    wdpr_process_start_datetime timestamp null,
    wdpr_process_complete_datetime timestamp null,
    wdpr_name varchar(128) null
);

create table staging_octane.wf_step
(
    ws_pid bigint
        primary key,
    ws_version int null,
    ws_wf_process_pid bigint null,
    ws_step_name varchar(128) null,
    ws_step_number decimal(17,5) null,
    ws_step_number_formatted varchar(16) null,
    ws_step_number_name_formatted varchar(128) null,
    ws_step_start_borrower_text varchar(1024) null,
    ws_expected_complete_minutes int null,
    ws_wf_step_timeout_type varchar(128) null,
    ws_second_of_day_timeout int null,
    ws_timeout_time_zone_type varchar(128) null,
    ws_description varchar(1024) null,
    ws_wf_step_type varchar(128) null,
    ws_wf_phase_pid bigint null,
    ws_wf_step_performer_assign_type varchar(128) null,
    ws_role_pid bigint null,
    ws_from_role_pid bigint null,
    ws_wf_step_reassign_type varchar(128) null,
    ws_wf_step_function_type varchar(128) null,
    ws_sap_expire_minutes int null,
    ws_sap_expire_warning_minutes int null,
    ws_prompt_user_defined_time bit null,
    ws_smart_message_pid bigint null,
    ws_smart_doc_set_pid bigint null,
    ws_lien_priority_type varchar(128) null,
    ws_active_only bit null,
    ws_internal bit null,
    ws_deal_stage_type varchar(128) null,
    ws_polling_interval_type varchar(128) null,
    ws_swappable bit null
);

create table staging_octane.criteria_pid_operand
(
    crpo_pid bigint
        primary key,
    crpo_version int null,
    crpo_criteria_pid bigint null,
    crpo_criteria_pid_operand_type varchar(128) null,
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
    crpo_smart_doc_pid bigint null
);

create table staging_octane.smart_task
(
    st_pid bigint
        primary key,
    st_version int null,
    st_wf_step_pid bigint null,
    st_description varchar(1024) null,
    st_from_date date null,
    st_through_date date null,
    st_wf_step_order int null,
    st_criteria_pid bigint null
);

create table staging_octane.smart_task_tag_modifier
(
    sttm_pid bigint
        primary key,
    sttm_version int null,
    sttm_deal_tag_definition_pid bigint null,
    sttm_smart_task_pid bigint null,
    sttm_add_tag bit null
);

create table staging_octane.view_wf_deal_step_started
(
    wds_pid bigint null
        primary key,
    wds_version int null,
    wds_wf_step_pid bigint null,
    wds_wf_deal_process_pid bigint null,
    wds_performer_user_pid bigint null,
    wds_visit_number int null,
    wds_start_datetime timestamp null,
    wds_complete_datetime timestamp null,
    wds_timeout_datetime timestamp null,
    wds_wf_deal_step_status_type varchar(128) null,
    wds_wf_step_type varchar(128) null,
    wds_function_error_list text null,
    wds_step_name varchar(128) null,
    wds_step_number decimal(17,5) null,
    wds_step_number_formatted varchar(16) null,
    wds_step_number_name_formatted varchar(128) null,
    wds_expected_complete_minutes int null,
    wds_description varchar(1024) null,
    wds_wf_step_function_type varchar(128) null,
    wds_phase_name varchar(128) null,
    wds_phase_number int null,
    wds_allow_check_override bit null,
    wds_deal_stage_pid bigint null,
    wds_completing_user_pid bigint null,
    wds_polling_interval_offset int null,
    wds_materialized_view_trash bit null
);

create table staging_octane.wf_deal_step
(
    wds_pid bigint
        primary key,
    wds_version int null,
    wds_wf_step_pid bigint null,
    wds_wf_deal_process_pid bigint null,
    wds_performer_user_pid bigint null,
    wds_visit_number int null,
    wds_start_datetime timestamp null,
    wds_complete_datetime timestamp null,
    wds_timeout_datetime timestamp null,
    wds_wf_deal_step_status_type varchar(128) null,
    wds_wf_step_type varchar(128) null,
    wds_function_error_list text null,
    wds_step_name varchar(128) null,
    wds_step_number decimal(17,5) null,
    wds_step_number_formatted varchar(16) null,
    wds_step_number_name_formatted varchar(128) null,
    wds_expected_complete_minutes int null,
    wds_description varchar(1024) null,
    wds_wf_step_function_type varchar(128) null,
    wds_phase_name varchar(128) null,
    wds_phase_number int null,
    wds_allow_check_override bit null,
    wds_deal_stage_pid bigint null,
    wds_completing_user_pid bigint null,
    wds_polling_interval_offset int null
);

create table staging_octane.deal_note
(
    dn_pid bigint
        primary key,
    dn_version int null,
    dn_deal_pid bigint null,
    dn_create_datetime timestamp null,
    dn_content varchar(16000) null,
    dn_author_unparsed_name varchar(128) null,
    dn_author_lender_user_pid bigint null,
    dn_scope_type varchar(128) null,
    dn_scope_name varchar(1024) null,
    dn_wf_deal_step_pid bigint null,
    dn_proposal_doc_pid bigint null,
    dn_proposal_review_pid bigint null
);

create table staging_octane.deal_note_comment
(
    dnc_pid bigint
        primary key,
    dnc_version int null,
    dnc_deal_note_pid bigint null,
    dnc_create_datetime timestamp null,
    dnc_content varchar(16000) null,
    dnc_author_unparsed_name varchar(128) null,
    dnc_author_lender_user_pid bigint null
);

create table staging_octane.deal_note_monitor
(
    dnm_pid bigint
        primary key,
    dnm_version int null,
    dnm_deal_note_pid bigint null,
    dnm_lender_user_pid bigint null
);

create table staging_octane.deal_note_role_tag
(
    dnrt_pid bigint
        primary key,
    dnrt_version int null,
    dnrt_deal_note_pid bigint null,
    dnrt_role_pid bigint null
);

create table staging_octane.deal_task
(
    dt_pid bigint
        primary key,
    dt_version int null,
    dt_wf_deal_step_pid bigint null,
    dt_create_lender_user_name varchar(128) null,
    dt_create_datetime timestamp null,
    dt_description varchar(1024) null,
    dt_complete_datetime timestamp null,
    dt_deal_task_status_type varchar(128) null,
    dt_smart_task bit null
);

create table staging_octane.wf_deal_fork_process
(
    wdfp_pid bigint
        primary key,
    wdfp_version int null,
    wdfp_wf_deal_step_pid bigint null,
    wdfp_wf_deal_process_pid bigint null
);

create table staging_octane.wf_deal_function_queue
(
    wdfq_pid bigint
        primary key,
    wdfq_version int null,
    wdfq_wf_deal_step_pid bigint null,
    wdfq_worker_start_datetime timestamp null,
    wdfq_halted bit null,
    wdfq_retry_count int null
);

create table staging_octane.wf_deal_outcome
(
    wdo_pid bigint
        primary key,
    wdo_version int null,
    wdo_wf_deal_step_pid bigint null,
    wdo_wf_outcome_type varchar(128) null,
    wdo_outcome_name varchar(128) null,
    wdo_borrower_message varchar(1024) null,
    wdo_lender_description varchar(256) null,
    wdo_incomplete_outcome bit null,
    wdo_transition_wf_deal_step_pid bigint null
);

create table staging_octane.wf_deal_step_timeout
(
    wdst_pid bigint
        primary key,
    wdst_version int null,
    wdst_wf_deal_step_pid bigint null,
    wdst_timeout_datetime timestamp null
);

create index idx_wf_deal_step_timeout_1
    on staging_octane.wf_deal_step_timeout (wdst_timeout_datetime);

create table staging_octane.wf_fork_process
(
    wfp_pid bigint
        primary key,
    wfp_version int null,
    wfp_wf_step_pid bigint null,
    wfp_wf_process_pid bigint null
);

create table staging_octane.wf_outcome
(
    wo_pid bigint
        primary key,
    wo_version int null,
    wo_wf_step_pid bigint null,
    wo_wf_outcome_type varchar(128) null,
    wo_outcome_name varchar(128) null,
    wo_ordinal int null,
    wo_criteria_pid bigint null,
    wo_borrower_message varchar(1024) null,
    wo_lender_description varchar(256) null,
    wo_incomplete_outcome bit null,
    wo_transition_wf_step_pid bigint null
);

create table staging_octane.wf_step_deal_check
(
    wsdc_pid bigint
        primary key,
    wsdc_version int null,
    wsdc_wf_step_pid bigint null,
    wsdc_deal_check_type varchar(128) null,
    wsdc_deal_check_severity_type varchar(128) null
);

create table staging_octane.wf_step_deal_check_definition
(
    wsdd_pid bigint
        primary key,
    wsdd_version int null,
    wsdd_wf_step_pid bigint null,
    wsdd_deal_check_type varchar(128) null,
    wsdd_deal_check_severity_type varchar(128) null
);

create table staging_octane.wf_step_deal_check_dependency
(
    wsdp_pid bigint
        primary key,
    wsdp_version int null,
    wsdp_wf_step_pid bigint null,
    wsdp_dependency_wf_step_pid bigint null
);

create table staging_octane.wf_step_deal_tag_modifier
(
    wsdt_pid bigint
        primary key,
    wsdt_version int null,
    wsdt_deal_tag_definition_pid bigint null,
    wsdt_wf_step_pid bigint null,
    wsdt_add_tag bit null
);

create table staging_octane.zip_code_info
(
    zci_pid bigint
        primary key,
    zci_version int null,
    zci_zip_code varchar(5) null,
    zci_latitude decimal(9,6) null,
    zci_longitude decimal(9,6) null
);

create table staging_octane.county_zip_code
(
    czc_pid bigint
        primary key,
    czc_version int null,
    czc_county_pid bigint null,
    czc_zip_code_info_pid bigint null
);


--
-- EDW - Modify DMI NMLS Call Report processes (SP8/SP9/SP10) to add report_quarter and filename columns (https://app.asana.com/0/0/1199603976631072)
--

--
-- SP8.2
--
DROP TABLE staging_compliance.nmls_call_report_state;
CREATE TABLE staging_compliance.nmls_call_report_state
(
    etl_batch_id text
    , data_source_dwid bigint
    , mcr_field_id text not null
    , mcr_description text
    , state_type text not null
    , total_unpaid_balance numeric
    , loan_count integer
    , average_loan_size numeric
    , report_quarter text
);


--
-- SP9.2
--
DROP TABLE staging_compliance.nmls_call_report_national;
CREATE TABLE staging_compliance.nmls_call_report_national
(
    etl_batch_id text
    , data_source_dwid bigint
    , mcr_field_id text not null
    , mcr_description text
    , total_unpaid_balance numeric
    , loan_count integer
    , average_unpaid_balance numeric
    , report_quarter text
);


--
-- SP10.2
--
DROP TABLE staging_compliance.nmls_call_report_s540a;
CREATE TABLE staging_compliance.nmls_call_report_s540a
(
    etl_batch_id text
    , data_source_dwid bigint
    , state_type text
    , item_id bigint
    , servicer_nmls_id bigint
    , servicer_name text
    , pool_number text
    , total_unpaid_balance numeric
    , loan_count integer
    , average_unpaid_balance numeric
    , report_quarter text
);

--
-- Expose DMI NMLS Call Report data to Octane AS a view (https://app.asana.com/0/0/1199574510798743)
--
CREATE VIEW octane_data_mart.nmls_call_report_national AS
    SELECT
        mcr_field_id
        , mcr_description
        , average_unpaid_balance as average_unpaid_balance_amount
        , loan_count
        , total_unpaid_balance as total_unpaid_balance_amount
        , report_quarter
    FROM
        staging_compliance.nmls_call_report_national;

CREATE VIEW octane_data_mart.nmls_call_report_s540a AS
    SELECT
        state_type
        , item_id
        , servicer_nmls_id
        , servicer_name
        , pool_number
        , total_unpaid_balance as total_unpaid_balance_amount
        , loan_count
        , average_unpaid_balance as average_unpaid_balance_amount
        , report_quarter
    FROM
        staging_compliance.nmls_call_report_s540a;

CREATE VIEW octane_data_mart.nmls_call_report_state AS
    SELECT
        mcr_field_id
        , mcr_description
        , state_type
        , total_unpaid_balance as total_unpaid_balance_amount
        , loan_count
        , average_loan_size as average_unpaid_balance_amount
        , report_quarter
    FROM
        staging_compliance.nmls_call_report_state;
