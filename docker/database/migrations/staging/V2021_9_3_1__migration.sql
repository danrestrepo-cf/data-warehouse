--
-- Main | EDW - Octane schemas from prod-release to v2021.10.1.0 on uat ( https://app.asana.com/0/0/1201077269203237 )
--

ALTER TABLE staging_octane.smart_doc_validity_date_case
    DROP COLUMN sdvdc_criteria_html;

ALTER TABLE staging_octane.smart_mi_rate_case
    DROP COLUMN smrc_criteria_html;

ALTER TABLE staging_octane.smart_mi_rate_adjustment_case
    DROP COLUMN smrac_criteria_html;

ALTER TABLE staging_octane.smart_mi_surcharge_case
    DROP COLUMN smsc_criteria_html;

ALTER TABLE staging_octane.proposal_doc_validity
    ADD COLUMN prpdv_criteria_html varchar(16000);

ALTER TABLE staging_octane.loan
    ADD COLUMN l_buyup_buydown_basis_points numeric(15,2);

ALTER TABLE staging_octane.loan
    ALTER COLUMN l_base_guaranty_fee_percent SET DATA TYPE numeric(15,2),
    ALTER COLUMN l_guaranty_fee_percent SET DATA TYPE numeric(15,2),
    ALTER COLUMN l_guaranty_fee_after_alternate_payment_method_percent SET DATA TYPE numeric(15,2);

ALTER TABLE staging_octane.loan RENAME COLUMN l_base_guaranty_fee_percent TO l_base_guaranty_fee_basis_points;

ALTER TABLE staging_octane.loan RENAME COLUMN l_guaranty_fee_percent TO l_guaranty_fee_basis_points;

ALTER TABLE staging_octane.loan RENAME COLUMN l_guaranty_fee_after_alternate_payment_method_percent TO l_guaranty_fee_after_alternate_payment_method_basis_points;

ALTER TABLE staging_octane.loan
    ALTER COLUMN l_base_guaranty_fee_basis_points SET DATA TYPE numeric(15,2),
    ALTER COLUMN l_guaranty_fee_basis_points SET DATA TYPE numeric(15,2),
    ALTER COLUMN l_guaranty_fee_after_alternate_payment_method_basis_points SET DATA TYPE numeric(15,2);

ALTER TABLE staging_octane.loan
    ALTER COLUMN l_base_guaranty_fee_basis_points SET DATA TYPE numeric(15,2),
    ALTER COLUMN l_guaranty_fee_basis_points SET DATA TYPE numeric(15,2),
    ALTER COLUMN l_guaranty_fee_after_alternate_payment_method_basis_points SET DATA TYPE numeric(15,2);

ALTER TABLE staging_octane.construction_cost
    DROP COLUMN coc_contractor_pid;

ALTER TABLE staging_octane.loan
    DROP COLUMN l_base_loan_amount_ltv_ratio_percent;

ALTER TABLE staging_octane.proposal_doc_set
    ADD COLUMN prpds_docs_last_updated_datetime timestamp;



history_octane changes:
ALTER TABLE history_octane.proposal_doc_validity
    ADD COLUMN prpdv_criteria_html varchar(16000);

ALTER TABLE history_octane.loan
    ADD COLUMN l_buyup_buydown_basis_points numeric(15,2);

ALTER TABLE history_octane.loan
    ALTER COLUMN l_base_guaranty_fee_percent SET DATA TYPE numeric(15,2),
    ALTER COLUMN l_guaranty_fee_percent SET DATA TYPE numeric(15,2),
    ALTER COLUMN l_guaranty_fee_after_alternate_payment_method_percent SET DATA TYPE numeric(15,2);

ALTER TABLE history_octane.loan RENAME COLUMN l_base_guaranty_fee_percent TO l_base_guaranty_fee_basis_points;

ALTER TABLE history_octane.loan RENAME COLUMN l_guaranty_fee_percent TO l_guaranty_fee_basis_points;

ALTER TABLE history_octane.loan RENAME COLUMN l_guaranty_fee_after_alternate_payment_method_percent TO l_guaranty_fee_after_alternate_payment_method_basis_points;

ALTER TABLE history_octane.loan
    ALTER COLUMN l_base_guaranty_fee_basis_points SET DATA TYPE numeric(15,2),
    ALTER COLUMN l_guaranty_fee_basis_points SET DATA TYPE numeric(15,2),
    ALTER COLUMN l_guaranty_fee_after_alternate_payment_method_basis_points SET DATA TYPE numeric(15,2);

ALTER TABLE history_octane.loan
    ALTER COLUMN l_base_guaranty_fee_basis_points SET DATA TYPE numeric(15,2),
    ALTER COLUMN l_guaranty_fee_basis_points SET DATA TYPE numeric(15,2),
    ALTER COLUMN l_guaranty_fee_after_alternate_payment_method_basis_points SET DATA TYPE numeric(15,2);

ALTER TABLE history_octane.proposal_doc_set
    ADD COLUMN prpds_docs_last_updated_datetime timestamp;









CREATE TABLE staging_octane.pricing_config_file (
                                                    pcf_pid bigint,
                                                    pcf_version integer,
                                                    constraint pk_pricing_config_file primary key (pcf_pid),
                                                    pcf_account_pid bigint,
                                                    pcf_repository_file_pid bigint
);

CREATE INDEX idx_pricing_config_file__pid_version ON staging_octane.pricing_config_file (pcf_pid, pcf_version);

CREATE TABLE staging_octane.pricing_eligibility_config (
                                                           pec_pid bigint,
                                                           pec_version integer,
                                                           constraint pk_pricing_eligibility_config primary key (pec_pid),
                                                           pec_account_pid bigint,
                                                           pec_pricing_config_file_pid bigint,
                                                           pec_from_datetime timestamp,
                                                           pec_active boolean
);

CREATE INDEX idx_pricing_eligibility_config__pid_version ON staging_octane.pricing_eligibility_config (pec_pid, pec_version);

CREATE TABLE staging_octane.product_level_pricing_eligibility_config (
                                                                         plpc_pid bigint,
                                                                         plpc_version integer,
                                                                         constraint pk_product_level_pricing_eligibility_config primary key (plpc_pid),
                                                                         plpc_pricing_eligibility_config_pid bigint,
                                                                         plpc_product_pid bigint,
                                                                         plpc_offering_pid bigint,
                                                                         plpc_offering_group_pid bigint,
                                                                         plpc_root_only boolean
);

CREATE INDEX idx_product_level_pricing_eligibility_config__pid_version ON staging_octane.product_level_pricing_eligibility_config (plpc_pid, plpc_version);

CREATE TABLE staging_octane.pricing_config_category_type (
                                                             code varchar(128),
                                                             value varchar(1024),
                                                             constraint pk_pricing_config_category_type primary key (code)
);

CREATE TABLE staging_octane.pricing_add_on_config (
                                                      paoc_pid bigint,
                                                      paoc_version integer,
                                                      constraint pk_pricing_add_on_config primary key (paoc_pid),
                                                      paoc_account_pid bigint,
                                                      paoc_pricing_config_file_pid bigint,
                                                      paoc_org_node_pid bigint,
                                                      paoc_from_datetime timestamp,
                                                      paoc_category_type varchar(128),
                                                      paoc_active boolean
);

CREATE INDEX idx_pricing_add_on_config__pid_version ON staging_octane.pricing_add_on_config (paoc_pid, paoc_version);

DROP TABLE IF EXISTS staging_octane.product_add_on_rule;
DROP TABLE IF EXISTS staging_octane.product_add_on;

ALTER TABLE staging_octane.offering_product DROP COLUMN ofp_price_adjustment_percent;

ALTER TABLE staging_octane.product_lock_term DROP COLUMN plt_price_adjustment_percent;

CREATE TABLE staging_octane.product_access_type (
                                                    code varchar(128),
                                                    value varchar(1024),
                                                    constraint pk_product_access_type primary key (code)
);

CREATE TABLE staging_octane.product_access (
                                               pac_pid bigint,
                                               pac_version integer,
                                               constraint pk_product_access primary key (pac_pid),
                                               pac_from_date date,
                                               pac_through_date date,
                                               pac_product_pid bigint,
                                               pac_product_access_type varchar(128),
                                               pac_org_node_pid bigint
);

CREATE INDEX idx_product_access__pid_version ON staging_octane.product_access (pac_pid, pac_version);

DROP TABLE IF EXISTS staging_octane.product_branch;
DROP TABLE IF EXISTS staging_octane.product_originator;

ALTER TABLE staging_octane.profit_margin_detail ADD COLUMN pmd_pricing_add_on_config_pid bigint;

ALTER TABLE staging_octane.lender_lock_add_on ADD COLUMN lla_pricing_add_on_config_pid bigint;

ALTER TABLE staging_octane.lender_lock_minor
    ADD COLUMN llmn_add_on_cap_id varchar(128),
    ADD COLUMN llmn_add_on_floor numeric(11,9),
    ADD COLUMN llmn_add_on_cap_config_file_pid bigint;

ALTER TABLE staging_octane.proposal_summary
    ADD COLUMN ps_any_property_insurance_escrow_waived boolean,
    ADD COLUMN ps_property_taxes_escrow_waived boolean;

ALTER TABLE staging_octane.place
    ADD COLUMN pl_warrantable_condo varchar(128);

ALTER TABLE staging_octane.secondary_settings
    DROP COLUMN sset_pricing_engine_type;

ALTER TABLE staging_octane.offering
    ADD COLUMN of_pricing_engine_type varchar(128);

ALTER TABLE staging_octane.lender_lock_major
    ADD COLUMN llmj_pricing_engine_type varchar(128);

ALTER TABLE staging_octane.lender_lock_minor
    ADD COLUMN llmn_unable_to_create_historic_price boolean;

CREATE TABLE staging_octane.quote_request_prepay_schedule_type (
                                                                   code varchar(128),
                                                                   value varchar(1024),
                                                                   constraint pk_quote_request_prepay_schedule_type primary key (code)
);

CREATE TABLE staging_octane.quote_request_buydown_type (
                                                           code varchar(128),
                                                           value varchar(1024),
                                                           constraint pk_quote_request_buydown_type primary key (code)
);

CREATE TABLE staging_octane.pricing_comparison_request (
                                                           pcr_pid bigint,
                                                           pcr_version integer,
                                                           constraint pk_pricing_comparison_request primary key (pcr_pid),
                                                           pcr_account_pid bigint,
                                                           pcr_create_datetime timestamp,
                                                           pcr_create_date date,
                                                           pcr_pricing_datetime timestamp,
                                                           pcr_main_lender_lock_major_pid bigint,
                                                           pcr_main_lender_lock_minor_pid bigint,
                                                           pcr_piggyback_lender_lock_major_pid bigint,
                                                           pcr_piggyback_lender_lock_minor_pid bigint,
                                                           pcr_proposal_pid bigint,
                                                           pcr_lender_lock_id_main varchar(11),
                                                           pcr_lender_lock_major_version_main integer,
                                                           pcr_lender_lock_minor_version_main integer,
                                                           pcr_lender_lock_id_piggyback varchar(11),
                                                           pcr_lender_lock_major_version_piggyback integer,
                                                           pcr_lender_lock_minor_version_piggyback integer,
                                                           pcr_los_loan_id_main bigint,
                                                           pcr_los_loan_id_piggyback bigint,
                                                           pcr_internal_time_ms bigint,
                                                           pcr_hybrid_time_ms bigint,
                                                           pcr_originator_pid bigint,
                                                           pcr_lead_source_pid bigint,
                                                           pcr_lock_commitment_type varchar(128),
                                                           pcr_lock_duration_days integer,
                                                           pcr_loan_purpose_type varchar(128),
                                                           pcr_proposal_structure_type varchar(128),
                                                           pcr_state_type varchar(128),
                                                           pcr_county_pid bigint,
                                                           pcr_city_name varchar(128),
                                                           pcr_loan_amount_main numeric(15,2),
                                                           pcr_loan_amount_piggyback numeric(15,2),
                                                           pcr_target_cash_out_amount numeric(15,2),
                                                           pcr_student_loan_cash_out_refinance  boolean,
                                                           pcr_credit_score integer,
                                                           pcr_ltv_ratio_percent numeric(11,9),
                                                           pcr_cltv_ratio_percent numeric(11,9),
                                                           pcr_he_ratio_percent numeric(11,9),
                                                           pcr_dti_ratio_percent numeric(11,9),
                                                           pcr_total_income_to_ami_ratio numeric(11,9),
                                                           pcr_total_monthly_income_amount numeric(15,2),
                                                           pcr_property_usage_type varchar(128),
                                                           pcr_property_category_type varchar(128),
                                                           pcr_warrantable_condo  boolean,
                                                           pcr_project_classification_type varchar(128),
                                                           pcr_building_status_type varchar(128),
                                                           pcr_qm_main  boolean,
                                                           pcr_qm_piggyback  boolean,
                                                           pcr_first_time_buyer  boolean,
                                                           pcr_all_borrower_declaration_intend_to_occupy  boolean,
                                                           pcr_any_borrower_self_employed  boolean,
                                                           pcr_multiple_applicants  boolean,
                                                           pcr_arms_length  boolean,
                                                           pcr_under_10_acres  boolean,
                                                           pcr_newly_built  boolean,
                                                           pcr_property_rights_type varchar(128),
                                                           pcr_property_taxes_escrow_waived  boolean,
                                                           pcr_any_property_insurance_escrow_waived  boolean,
                                                           pcr_community_second_present  boolean,
                                                           pcr_subject_property_hud_reo  boolean,
                                                           pcr_mi_payment_type varchar(128),
                                                           pcr_mi_payer_type varchar(128),
                                                           pcr_underwrite_risk_assessment_type varchar(128),
                                                           pcr_doc_level_type varchar(128),
                                                           pcr_veteran_status_type varchar(128),
                                                           pcr_va_funding_fee_exempt  boolean,
                                                           pcr_va_funding_fee_financed  boolean,
                                                           pcr_va_subsequent_use  boolean,
                                                           pcr_military_status_type varchar(128),
                                                           pcr_agency_case_id_assigned_date date,
                                                           pcr_subject_property_subordinate_2nd_creditor_pid bigint,
                                                           pcr_subject_property_subordinate_3rd_creditor_pid bigint,
                                                           pcr_quote_request_prepay_schedule_type_main varchar(128),
                                                           pcr_quote_request_buydown_type_main varchar(128),
                                                           pcr_quote_request_prepay_schedule_type_piggyback varchar(128),
                                                           pcr_quote_request_buydown_type_piggyback varchar(128),
                                                           pcr_cash_out_reason_home_improvement boolean,
                                                           pcr_cash_out_reason_debt_or_debt_consolidation boolean,
                                                           pcr_cash_out_reason_personal_use boolean,
                                                           pcr_cash_out_reason_future_investment_not_under_contract boolean,
                                                           pcr_cash_out_reason_future_investment_under_contract boolean,
                                                           pcr_cash_out_reason_student_loans boolean,
                                                           pcr_cash_out_reason_other boolean
);

CREATE INDEX idx_pricing_comparison_request__pid_version ON staging_octane.pricing_comparison_request (pcr_pid, pcr_version);

CREATE TABLE staging_octane.pricing_comparison_request_mortgage_type_choice (
                                                                                pcrmtc_pid bigint,
                                                                                pcrmtc_version integer,
                                                                                constraint pk_pricing_comparison_request_mortgage_type_choice primary key (pcrmtc_pid),
                                                                                pcrmtc_pricing_comparison_request_pid bigint,
                                                                                pcrmtc_loan_position_type varchar(128),
                                                                                pcrmtc_mortgage_type varchar(128)
);

CREATE INDEX idx_1eff56403425751376d78c174a8f4417 ON staging_octane.pricing_comparison_request_mortgage_type_choice (pcrmtc_pid, pcrmtc_version);

CREATE TABLE staging_octane.pricing_comparison_request_amortization_type_choice (
                                                                                    pcratc_pid bigint,
                                                                                    pcratc_version integer,
                                                                                    constraint pk_pricing_comparison_request_amortization_type_choice primary key (pcratc_pid),
                                                                                    pcratc_pricing_comparison_request_pid bigint,
                                                                                    pcratc_loan_position_type varchar(128),
                                                                                    pcratc_amortization_type varchar(128)
);

CREATE INDEX idx_8f1f26129b11fdb8ed97dc60d0d95b73 ON staging_octane.pricing_comparison_request_amortization_type_choice (pcratc_pid, pcratc_version);

CREATE TABLE staging_octane.pricing_comparison_request_term (
                                                                pcrt_pid bigint,
                                                                pcrt_version integer,
                                                                constraint pk_pricing_comparison_request_term primary key (pcrt_pid),
                                                                pcrt_pricing_comparison_request_pid bigint,
                                                                pcrt_loan_position_type varchar(128),
                                                                pcrt_term_month integer
);

CREATE INDEX idx_pricing_comparison_request_term__pid_version ON staging_octane.pricing_comparison_request_term (pcrt_pid, pcrt_version);

CREATE TABLE staging_octane.pricing_comparison_request_interest_only_type_choice (
                                                                                     pcriotc_pid bigint,
                                                                                     pcriotc_version integer,
                                                                                     constraint pk_pricing_comparison_request_interest_only_type_choice primary key (pcriotc_pid),
                                                                                     pcriotc_pricing_comparison_request_pid bigint,
                                                                                     pcriotc_loan_position_type varchar(128),
                                                                                     pcriotc_interest_only_type varchar(128)
);

CREATE INDEX idx_b251930d01abaac4920d0244aae0fcfe ON staging_octane.pricing_comparison_request_interest_only_type_choice (pcriotc_pid, pcriotc_version);

CREATE TABLE staging_octane.pricing_comparison_request_eligible_offering (
                                                                             pcreo_pid bigint,
                                                                             pcreo_version integer,
                                                                             constraint pk_pricing_comparison_request_eligible_offering primary key (pcreo_pid),
                                                                             pcreo_pricing_comparison_request_pid bigint,
                                                                             pcreo_offering_id varchar(32)
);

CREATE INDEX idx_pricing_comparison_request_eligible_offering__pid_version ON staging_octane.pricing_comparison_request_eligible_offering (pcreo_pid, pcreo_version);

CREATE TABLE staging_octane.pricing_comparison_mismatch (
                                                            pcm_pid bigint,
                                                            pcm_version integer,
                                                            constraint pk_pricing_comparison_mismatch primary key (pcm_pid),
                                                            pcm_pricing_comparison_request_pid bigint,
                                                            pcm_offering_id varchar(32),
                                                            pcm_offering_name varchar(128),
                                                            pcm_investor_product_id varchar(32),
                                                            pcm_investor_id varchar(32),
                                                            pcm_arm_product boolean,
                                                            pcm_lien_priority_type varchar(128),
                                                            pcm_note_rate numeric(11,9),
                                                            pcm_lock_commitment_type varchar(128),
                                                            pcm_lock_duration_days integer,
                                                            pcm_base_price_internal numeric(11,9),
                                                            pcm_base_price_hybrid numeric(11,9),
                                                            pcm_base_arm_margin_percent_internal numeric(11,9),
                                                            pcm_base_arm_margin_percent_hybrid numeric(11,9),
                                                            pcm_final_price_internal numeric(11,9),
                                                            pcm_final_price_hybrid numeric(11,9),
                                                            pcm_final_profit_margin_internal numeric(11,9),
                                                            pcm_final_profit_margin_hybrid numeric(11,9)
);

CREATE INDEX idx_pricing_comparison_mismatch__pid_version ON staging_octane.pricing_comparison_mismatch (pcm_pid, pcm_version);

CREATE TABLE staging_octane.pricing_comparison_mismatch_add_on (
                                                                   pcmao_pid bigint,
                                                                   pcmao_version integer,
                                                                   constraint pk_pricing_comparison_mismatch_add_on primary key (pcmao_pid),
                                                                   pcmao_pricing_comparison_mismatch_pid bigint,
                                                                   pcmao_rate numeric(11,9),
                                                                   pcmao_price numeric(11,9),
                                                                   pcmao_margin numeric(11,9),
                                                                   pcmao_arm_margin_adjustment numeric(11,9),
                                                                   pcmao_description varchar(16000),
                                                                   pcmao_pricing_engine_type varchar(128)
);

CREATE INDEX idx_pricing_comparison_mismatch_add_on__pid_version ON staging_octane.pricing_comparison_mismatch_add_on (pcmao_pid, pcmao_version);

CREATE TABLE staging_octane.pricing_comparison_mismatch_margin (
                                                                   pcmm_pid bigint,
                                                                   pcmm_version integer,
                                                                   constraint pk_pricing_comparison_mismatch_margin primary key (pcmm_pid),
                                                                   pcmm_pricing_comparison_mismatch_pid bigint,
                                                                   pcmm_percent numeric(11,9),
                                                                   pcmm_dollar numeric(15,2),
                                                                   pcmm_margin_type varchar(128),
                                                                   pcmm_description varchar(16000),
                                                                   pcmm_pricing_engine_type varchar(128)
);

CREATE INDEX idx_pricing_comparison_mismatch_margin__pid_version ON staging_octane.pricing_comparison_mismatch_margin (pcmm_pid, pcmm_version);

ALTER TABLE staging_octane.product_minimum_investor_price RENAME COLUMN pminip_minimum_includes_srp TO pminip_minimum_includes_msr;

ALTER TABLE staging_octane.product_maximum_investor_price RENAME COLUMN pmip_maximum_includes_srp TO pmip_maximum_includes_msr;

CREATE TABLE history_octane.pricing_config_file (
                                                    pcf_pid bigint,
                                                    pcf_version integer,
                                                    pcf_account_pid bigint,
                                                    pcf_repository_file_pid bigint,
                                                    data_source_updated_datetime timestamptz,
                                                    data_source_deleted_flag boolean
);

CREATE INDEX idx_pricing_config_file__pid ON history_octane.pricing_config_file (pcf_pid);

CREATE INDEX idx_pricing_config_file__data_source_updated_datetime ON history_octane.pricing_config_file (data_source_updated_datetime);

CREATE INDEX idx_pricing_config_file__data_source_deleted_flag ON history_octane.pricing_config_file (data_source_deleted_flag);

CREATE INDEX idx_pricing_config_file__pid_version ON history_octane.pricing_config_file (pcf_pid, pcf_version);

CREATE INDEX fk_pricing_config_file_1 ON history_octane.pricing_config_file (pcf_account_pid);

CREATE INDEX fk_pricing_config_file_2 ON history_octane.pricing_config_file (pcf_repository_file_pid);

CREATE TABLE history_octane.pricing_eligibility_config (
                                                           pec_pid bigint,
                                                           pec_version integer,
                                                           pec_account_pid bigint,
                                                           pec_pricing_config_file_pid bigint,
                                                           pec_from_datetime timestamp,
                                                           pec_active boolean,
                                                           data_source_updated_datetime timestamptz,
                                                           data_source_deleted_flag boolean
);

CREATE INDEX idx_pricing_eligibility_config__pid ON history_octane.pricing_eligibility_config (pec_pid);

CREATE INDEX idx_pricing_eligibility_config__data_source_updated_datetime ON history_octane.pricing_eligibility_config (data_source_updated_datetime);

CREATE INDEX idx_pricing_eligibility_config__data_source_deleted_flag ON history_octane.pricing_eligibility_config (data_source_deleted_flag);

CREATE INDEX idx_pricing_eligibility_config__pid_version ON history_octane.pricing_eligibility_config (pec_pid, pec_version);

CREATE INDEX fk_pricing_eligibility_config_1 ON history_octane.pricing_eligibility_config (pec_account_pid);

CREATE INDEX fk_pricing_eligibility_config_2 ON history_octane.pricing_eligibility_config (pec_pricing_config_file_pid);

CREATE TABLE history_octane.product_level_pricing_eligibility_config (
                                                                         plpc_pid bigint,
                                                                         plpc_version integer,
                                                                         plpc_pricing_eligibility_config_pid bigint,
                                                                         plpc_product_pid bigint,
                                                                         plpc_offering_pid bigint,
                                                                         plpc_offering_group_pid bigint,
                                                                         plpc_root_only boolean,
                                                                         data_source_updated_datetime timestamptz,
                                                                         data_source_deleted_flag boolean
);

CREATE INDEX idx_product_level_pricing_eligibility_config__pid ON history_octane.product_level_pricing_eligibility_config (plpc_pid);

CREATE INDEX idx_99edff9af0472f382c93e1c61c26155f ON history_octane.product_level_pricing_eligibility_config (data_source_updated_datetime);

CREATE INDEX idx_fb744a464107e3dd404b64ea36ec9347 ON history_octane.product_level_pricing_eligibility_config (data_source_deleted_flag);

CREATE INDEX idx_product_level_pricing_eligibility_config__pid_version ON history_octane.product_level_pricing_eligibility_config (plpc_pid, plpc_version);

CREATE INDEX fk_product_level_pricing_eligibility_config_1 ON history_octane.product_level_pricing_eligibility_config (plpc_pricing_eligibility_config_pid);

CREATE INDEX fk_product_level_pricing_eligibility_config_2 ON history_octane.product_level_pricing_eligibility_config (plpc_product_pid);

CREATE INDEX fk_product_level_pricing_eligibility_config_3 ON history_octane.product_level_pricing_eligibility_config (plpc_offering_pid);

CREATE INDEX fk_product_level_pricing_eligibility_config_4 ON history_octane.product_level_pricing_eligibility_config (plpc_offering_group_pid);

CREATE TABLE history_octane.pricing_config_category_type (
                                                             code varchar(128),
                                                             value varchar(1024),
                                                             data_source_updated_datetime timestamptz,
                                                             data_source_deleted_flag boolean
);

CREATE INDEX idx_pricing_config_category_type__data_source_updated_datetime ON history_octane.pricing_config_category_type (data_source_updated_datetime);

CREATE INDEX idx_pricing_config_category_type__data_source_deleted_flag ON history_octane.pricing_config_category_type (data_source_deleted_flag);

CREATE TABLE history_octane.pricing_add_on_config (
                                                      paoc_pid bigint,
                                                      paoc_version integer,
                                                      paoc_account_pid bigint,
                                                      paoc_pricing_config_file_pid bigint,
                                                      paoc_org_node_pid bigint,
                                                      paoc_from_datetime timestamp,
                                                      paoc_category_type varchar(128),
                                                      paoc_active boolean,
                                                      data_source_updated_datetime timestamptz,
                                                      data_source_deleted_flag boolean
);

CREATE INDEX idx_pricing_add_on_config__pid ON history_octane.pricing_add_on_config (paoc_pid);

CREATE INDEX idx_pricing_add_on_config__data_source_updated_datetime ON history_octane.pricing_add_on_config (data_source_updated_datetime);

CREATE INDEX idx_pricing_add_on_config__data_source_deleted_flag ON history_octane.pricing_add_on_config (data_source_deleted_flag);

CREATE INDEX idx_pricing_add_on_config__pid_version ON history_octane.pricing_add_on_config (paoc_pid, paoc_version);

CREATE INDEX fk_pricing_add_on_config_1 ON history_octane.pricing_add_on_config (paoc_account_pid);

CREATE INDEX fk_pricing_add_on_config_2 ON history_octane.pricing_add_on_config (paoc_pricing_config_file_pid);

CREATE INDEX fk_pricing_add_on_config_3 ON history_octane.pricing_add_on_config (paoc_org_node_pid);

CREATE INDEX fkt_paoc_category_type ON history_octane.pricing_add_on_config (paoc_category_type);

CREATE TABLE history_octane.product_access_type (
                                                    code varchar(128),
                                                    value varchar(1024),
                                                    data_source_updated_datetime timestamptz,
                                                    data_source_deleted_flag boolean
);

CREATE INDEX idx_product_access_type__data_source_updated_datetime ON history_octane.product_access_type (data_source_updated_datetime);

CREATE INDEX idx_product_access_type__data_source_deleted_flag ON history_octane.product_access_type (data_source_deleted_flag);

CREATE TABLE history_octane.product_access (
                                               pac_pid bigint,
                                               pac_version integer,
                                               pac_from_date date,
                                               pac_through_date date,
                                               pac_product_pid bigint,
                                               pac_product_access_type varchar(128),
                                               pac_org_node_pid bigint,
                                               data_source_updated_datetime timestamptz,
                                               data_source_deleted_flag boolean
);

CREATE INDEX idx_product_access__pid ON history_octane.product_access (pac_pid);

CREATE INDEX idx_product_access__data_source_updated_datetime ON history_octane.product_access (data_source_updated_datetime);

CREATE INDEX idx_product_access__data_source_deleted_flag ON history_octane.product_access (data_source_deleted_flag);

CREATE INDEX idx_product_access__pid_version ON history_octane.product_access (pac_pid, pac_version);

CREATE INDEX fk_product_access_1 ON history_octane.product_access (pac_product_pid);

CREATE INDEX fk_product_access_2 ON history_octane.product_access (pac_org_node_pid);

CREATE INDEX fkt_pac_product_access_type ON history_octane.product_access (pac_product_access_type);

ALTER TABLE history_octane.profit_margin_detail
    ADD COLUMN pmd_pricing_add_on_config_pid bigint;

CREATE INDEX fk_profit_margin_detail_2 ON history_octane.profit_margin_detail (pmd_pricing_add_on_config_pid);

ALTER TABLE history_octane.lender_lock_add_on
    ADD COLUMN lla_pricing_add_on_config_pid bigint;

CREATE INDEX fk_lender_lock_add_on_3 ON history_octane.lender_lock_add_on (lla_pricing_add_on_config_pid);

ALTER TABLE history_octane.lender_lock_minor
    ADD COLUMN llmn_add_on_cap_id varchar(128),
    ADD COLUMN llmn_add_on_floor numeric(11,9),
    ADD COLUMN llmn_add_on_cap_config_file_pid bigint;

CREATE INDEX fk_lender_lock_minor_6 ON history_octane.lender_lock_minor (llmn_add_on_cap_config_file_pid);

ALTER TABLE history_octane.proposal_summary
    ADD COLUMN ps_any_property_insurance_escrow_waived boolean,
    ADD COLUMN ps_property_taxes_escrow_waived boolean;

ALTER TABLE history_octane.place
    ADD COLUMN pl_warrantable_condo varchar(128);

CREATE INDEX fkt_pl_warrantable_condo ON history_octane.place (pl_warrantable_condo);

ALTER TABLE history_octane.offering
    ADD COLUMN of_pricing_engine_type varchar(128);

CREATE INDEX fkt_of_pricing_engine_type ON history_octane.offering (of_pricing_engine_type);

ALTER TABLE history_octane.lender_lock_major
    ADD COLUMN llmj_pricing_engine_type varchar(128);

CREATE INDEX fkt_llmj_pricing_engine_type ON history_octane.lender_lock_major (llmj_pricing_engine_type);

ALTER TABLE history_octane.lender_lock_minor
    ADD COLUMN llmn_unable_to_create_historic_price boolean;

CREATE TABLE history_octane.quote_request_prepay_schedule_type (
                                                                   code varchar(128),
                                                                   value varchar(1024),
                                                                   data_source_updated_datetime timestamptz,
                                                                   data_source_deleted_flag boolean
);

CREATE INDEX idx_ce697299201b45f01cc0ce9cb47a9103 ON history_octane.quote_request_prepay_schedule_type (data_source_updated_datetime);

CREATE INDEX idx_9d59d3da297b18ec933d0b9578856903 ON history_octane.quote_request_prepay_schedule_type (data_source_deleted_flag);

CREATE TABLE history_octane.quote_request_buydown_type (
                                                           code varchar(128),
                                                           value varchar(1024),
                                                           data_source_updated_datetime timestamptz,
                                                           data_source_deleted_flag boolean
);

CREATE INDEX idx_quote_request_buydown_type__data_source_updated_datetime ON history_octane.quote_request_buydown_type (data_source_updated_datetime);

CREATE INDEX idx_quote_request_buydown_type__data_source_deleted_flag ON history_octane.quote_request_buydown_type (data_source_deleted_flag);

CREATE TABLE history_octane.pricing_comparison_request (
                                                           pcr_pid bigint,
                                                           pcr_version integer,
                                                           pcr_account_pid bigint,
                                                           pcr_create_datetime timestamp,
                                                           pcr_create_date date,
                                                           pcr_pricing_datetime timestamp,
                                                           pcr_main_lender_lock_major_pid bigint,
                                                           pcr_main_lender_lock_minor_pid bigint,
                                                           pcr_piggyback_lender_lock_major_pid bigint,
                                                           pcr_piggyback_lender_lock_minor_pid bigint,
                                                           pcr_proposal_pid bigint,
                                                           pcr_lender_lock_id_main varchar(11),
                                                           pcr_lender_lock_major_version_main integer,
                                                           pcr_lender_lock_minor_version_main integer,
                                                           pcr_lender_lock_id_piggyback varchar(11),
                                                           pcr_lender_lock_major_version_piggyback integer,
                                                           pcr_lender_lock_minor_version_piggyback integer,
                                                           pcr_los_loan_id_main bigint,
                                                           pcr_los_loan_id_piggyback bigint,
                                                           pcr_internal_time_ms bigint,
                                                           pcr_hybrid_time_ms bigint,
                                                           pcr_originator_pid bigint,
                                                           pcr_lead_source_pid bigint,
                                                           pcr_lock_commitment_type varchar(128),
                                                           pcr_lock_duration_days integer,
                                                           pcr_loan_purpose_type varchar(128),
                                                           pcr_proposal_structure_type varchar(128),
                                                           pcr_state_type varchar(128),
                                                           pcr_county_pid bigint,
                                                           pcr_city_name varchar(128),
                                                           pcr_loan_amount_main numeric(15,2),
                                                           pcr_loan_amount_piggyback numeric(15,2),
                                                           pcr_target_cash_out_amount numeric(15,2),
                                                           pcr_student_loan_cash_out_refinance  boolean,
                                                           pcr_credit_score integer,
                                                           pcr_ltv_ratio_percent numeric(11,9),
                                                           pcr_cltv_ratio_percent numeric(11,9),
                                                           pcr_he_ratio_percent numeric(11,9),
                                                           pcr_dti_ratio_percent numeric(11,9),
                                                           pcr_total_income_to_ami_ratio numeric(11,9),
                                                           pcr_total_monthly_income_amount numeric(15,2),
                                                           pcr_property_usage_type varchar(128),
                                                           pcr_property_category_type varchar(128),
                                                           pcr_warrantable_condo  boolean,
                                                           pcr_project_classification_type varchar(128),
                                                           pcr_building_status_type varchar(128),
                                                           pcr_qm_main  boolean,
                                                           pcr_qm_piggyback  boolean,
                                                           pcr_first_time_buyer  boolean,
                                                           pcr_all_borrower_declaration_intend_to_occupy  boolean,
                                                           pcr_any_borrower_self_employed  boolean,
                                                           pcr_multiple_applicants  boolean,
                                                           pcr_arms_length  boolean,
                                                           pcr_under_10_acres  boolean,
                                                           pcr_newly_built  boolean,
                                                           pcr_property_rights_type varchar(128),
                                                           pcr_property_taxes_escrow_waived  boolean,
                                                           pcr_any_property_insurance_escrow_waived  boolean,
                                                           pcr_community_second_present  boolean,
                                                           pcr_subject_property_hud_reo  boolean,
                                                           pcr_mi_payment_type varchar(128),
                                                           pcr_mi_payer_type varchar(128),
                                                           pcr_underwrite_risk_assessment_type varchar(128),
                                                           pcr_doc_level_type varchar(128),
                                                           pcr_veteran_status_type varchar(128),
                                                           pcr_va_funding_fee_exempt  boolean,
                                                           pcr_va_funding_fee_financed  boolean,
                                                           pcr_va_subsequent_use  boolean,
                                                           pcr_military_status_type varchar(128),
                                                           pcr_agency_case_id_assigned_date date,
                                                           pcr_subject_property_subordinate_2nd_creditor_pid bigint,
                                                           pcr_subject_property_subordinate_3rd_creditor_pid bigint,
                                                           pcr_quote_request_prepay_schedule_type_main varchar(128),
                                                           pcr_quote_request_buydown_type_main varchar(128),
                                                           pcr_quote_request_prepay_schedule_type_piggyback varchar(128),
                                                           pcr_quote_request_buydown_type_piggyback varchar(128),
                                                           pcr_cash_out_reason_home_improvement boolean,
                                                           pcr_cash_out_reason_debt_or_debt_consolidation boolean,
                                                           pcr_cash_out_reason_personal_use boolean,
                                                           pcr_cash_out_reason_future_investment_not_under_contract boolean,
                                                           pcr_cash_out_reason_future_investment_under_contract boolean,
                                                           pcr_cash_out_reason_student_loans boolean,
                                                           pcr_cash_out_reason_other boolean,
                                                           data_source_updated_datetime timestamptz,
                                                           data_source_deleted_flag boolean
);

CREATE INDEX idx_pricing_comparison_request__pid ON history_octane.pricing_comparison_request (pcr_pid);

CREATE INDEX idx_pricing_comparison_request__data_source_updated_datetime ON history_octane.pricing_comparison_request (data_source_updated_datetime);

CREATE INDEX idx_pricing_comparison_request__data_source_deleted_flag ON history_octane.pricing_comparison_request (data_source_deleted_flag);

CREATE INDEX idx_pricing_comparison_request__pid_version ON history_octane.pricing_comparison_request (pcr_pid, pcr_version);

CREATE INDEX fk_pricing_comparison_request_1 ON history_octane.pricing_comparison_request (pcr_account_pid);

CREATE INDEX fkt_pcr_lock_commitment_type ON history_octane.pricing_comparison_request (pcr_lock_commitment_type);

CREATE INDEX fkt_pcr_loan_purpose_type ON history_octane.pricing_comparison_request (pcr_loan_purpose_type);

CREATE INDEX fkt_pcr_proposal_structure_type ON history_octane.pricing_comparison_request (pcr_proposal_structure_type);

CREATE INDEX fkt_pcr_state_type ON history_octane.pricing_comparison_request (pcr_state_type);

CREATE INDEX fkt_pcr_property_usage_type ON history_octane.pricing_comparison_request (pcr_property_usage_type);

CREATE INDEX fkt_pcr_property_category_type ON history_octane.pricing_comparison_request (pcr_property_category_type);

CREATE INDEX fkt_pcr_project_classification_type ON history_octane.pricing_comparison_request (pcr_project_classification_type);

CREATE INDEX fkt_pcr_building_status_type ON history_octane.pricing_comparison_request (pcr_building_status_type);

CREATE INDEX fkt_pcr_property_rights_type ON history_octane.pricing_comparison_request (pcr_property_rights_type);

CREATE INDEX fkt_pcr_mi_payment_type ON history_octane.pricing_comparison_request (pcr_mi_payment_type);

CREATE INDEX fkt_pcr_mi_payer_type ON history_octane.pricing_comparison_request (pcr_mi_payer_type);

CREATE INDEX fkt_pcr_underwrite_risk_assessment_type ON history_octane.pricing_comparison_request (pcr_underwrite_risk_assessment_type);

CREATE INDEX fkt_pcr_doc_level_type ON history_octane.pricing_comparison_request (pcr_doc_level_type);

CREATE INDEX fkt_pcr_veteran_status_type ON history_octane.pricing_comparison_request (pcr_veteran_status_type);

CREATE INDEX fkt_pcr_military_status_type ON history_octane.pricing_comparison_request (pcr_military_status_type);

CREATE INDEX fkt_pcr_quote_request_prepay_schedule_type_main ON history_octane.pricing_comparison_request (pcr_quote_request_prepay_schedule_type_main);

CREATE INDEX fkt_pcr_quote_request_buydown_type_main ON history_octane.pricing_comparison_request (pcr_quote_request_buydown_type_main);

CREATE INDEX fkt_pcr_quote_request_prepay_schedule_type_piggyback ON history_octane.pricing_comparison_request (pcr_quote_request_prepay_schedule_type_piggyback);

CREATE INDEX fkt_pcr_quote_request_buydown_type_piggyback ON history_octane.pricing_comparison_request (pcr_quote_request_buydown_type_piggyback);

CREATE TABLE history_octane.pricing_comparison_request_mortgage_type_choice (
                                                                                pcrmtc_pid bigint,
                                                                                pcrmtc_version integer,
                                                                                pcrmtc_pricing_comparison_request_pid bigint,
                                                                                pcrmtc_loan_position_type varchar(128),
                                                                                pcrmtc_mortgage_type varchar(128),
                                                                                data_source_updated_datetime timestamptz,
                                                                                data_source_deleted_flag boolean
);

CREATE INDEX idx_pricing_comparison_request_mortgage_type_choice__pid ON history_octane.pricing_comparison_request_mortgage_type_choice (pcrmtc_pid);

CREATE INDEX idx_cce620264f82441e6e7b0de2b2341e4d ON history_octane.pricing_comparison_request_mortgage_type_choice (data_source_updated_datetime);

CREATE INDEX idx_76a981c588991987a1aed2dac71cb3f7 ON history_octane.pricing_comparison_request_mortgage_type_choice (data_source_deleted_flag);

CREATE INDEX idx_1eff56403425751376d78c174a8f4417 ON history_octane.pricing_comparison_request_mortgage_type_choice (pcrmtc_pid, pcrmtc_version);

CREATE INDEX fk_pricing_comparison_request_mortgage_type_choice_1 ON history_octane.pricing_comparison_request_mortgage_type_choice (pcrmtc_pricing_comparison_request_pid);

CREATE INDEX fkt_pcrmtc_loan_position_type ON history_octane.pricing_comparison_request_mortgage_type_choice (pcrmtc_loan_position_type);

CREATE INDEX fkt_pcrmtc_mortgage_type ON history_octane.pricing_comparison_request_mortgage_type_choice (pcrmtc_mortgage_type);

CREATE TABLE history_octane.pricing_comparison_request_amortization_type_choice (
                                                                                    pcratc_pid bigint,
                                                                                    pcratc_version integer,
                                                                                    pcratc_pricing_comparison_request_pid bigint,
                                                                                    pcratc_loan_position_type varchar(128),
                                                                                    pcratc_amortization_type varchar(128),
                                                                                    data_source_updated_datetime timestamptz,
                                                                                    data_source_deleted_flag boolean
);

CREATE INDEX idx_pricing_comparison_request_amortization_type_choice__pid ON history_octane.pricing_comparison_request_amortization_type_choice (pcratc_pid);

CREATE INDEX idx_c694d36a09a10381f7397968955d6a80 ON history_octane.pricing_comparison_request_amortization_type_choice (data_source_updated_datetime);

CREATE INDEX idx_e943899f3e8d10912768d408f2290b90 ON history_octane.pricing_comparison_request_amortization_type_choice (data_source_deleted_flag);

CREATE INDEX idx_8f1f26129b11fdb8ed97dc60d0d95b73 ON history_octane.pricing_comparison_request_amortization_type_choice (pcratc_pid, pcratc_version);

CREATE INDEX fk_pricing_comparison_request_amortization_type_choice_1 ON history_octane.pricing_comparison_request_amortization_type_choice (pcratc_pricing_comparison_request_pid);

CREATE INDEX fkt_pcratc_loan_position_type ON history_octane.pricing_comparison_request_amortization_type_choice (pcratc_loan_position_type);

CREATE INDEX fkt_pcratc_amortization_type ON history_octane.pricing_comparison_request_amortization_type_choice (pcratc_amortization_type);

CREATE TABLE history_octane.pricing_comparison_request_term (
                                                                pcrt_pid bigint,
                                                                pcrt_version integer,
                                                                pcrt_pricing_comparison_request_pid bigint,
                                                                pcrt_loan_position_type varchar(128),
                                                                pcrt_term_month integer,
                                                                data_source_updated_datetime timestamptz,
                                                                data_source_deleted_flag boolean
);

CREATE INDEX idx_pricing_comparison_request_term__pid ON history_octane.pricing_comparison_request_term (pcrt_pid);

CREATE INDEX idx_3bb9aca463d4df57433c8f4e3a4d7ae4 ON history_octane.pricing_comparison_request_term (data_source_updated_datetime);

CREATE INDEX idx_pricing_comparison_request_term__data_source_deleted_flag ON history_octane.pricing_comparison_request_term (data_source_deleted_flag);

CREATE INDEX idx_pricing_comparison_request_term__pid_version ON history_octane.pricing_comparison_request_term (pcrt_pid, pcrt_version);

CREATE INDEX fk_pricing_comparison_request_term_1 ON history_octane.pricing_comparison_request_term (pcrt_pricing_comparison_request_pid);

CREATE INDEX fkt_pcrt_loan_position_type ON history_octane.pricing_comparison_request_term (pcrt_loan_position_type);

CREATE TABLE history_octane.pricing_comparison_request_interest_only_type_choice (
                                                                                     pcriotc_pid bigint,
                                                                                     pcriotc_version integer,
                                                                                     pcriotc_pricing_comparison_request_pid bigint,
                                                                                     pcriotc_loan_position_type varchar(128),
                                                                                     pcriotc_interest_only_type varchar(128),
                                                                                     data_source_updated_datetime timestamptz,
                                                                                     data_source_deleted_flag boolean
);

CREATE INDEX idx_pricing_comparison_request_interest_only_type_choice__pid ON history_octane.pricing_comparison_request_interest_only_type_choice (pcriotc_pid);

CREATE INDEX idx_7e896d7c0097f9b5017c906ec4b94bc6 ON history_octane.pricing_comparison_request_interest_only_type_choice (data_source_updated_datetime);

CREATE INDEX idx_07d398d57b4d578d33e737ebc02a04aa ON history_octane.pricing_comparison_request_interest_only_type_choice (data_source_deleted_flag);

CREATE INDEX idx_b251930d01abaac4920d0244aae0fcfe ON history_octane.pricing_comparison_request_interest_only_type_choice (pcriotc_pid, pcriotc_version);

CREATE INDEX fk_pricing_comparison_request_interest_only_type_choice_1 ON history_octane.pricing_comparison_request_interest_only_type_choice (pcriotc_pricing_comparison_request_pid);

CREATE INDEX fkt_pcriotc_loan_position_type ON history_octane.pricing_comparison_request_interest_only_type_choice (pcriotc_loan_position_type);

CREATE INDEX fkt_pcriotc_interest_only_type ON history_octane.pricing_comparison_request_interest_only_type_choice (pcriotc_interest_only_type);

CREATE TABLE history_octane.pricing_comparison_request_eligible_offering (
                                                                             pcreo_pid bigint,
                                                                             pcreo_version integer,
                                                                             pcreo_pricing_comparison_request_pid bigint,
                                                                             pcreo_offering_id varchar(32),
                                                                             data_source_updated_datetime timestamptz,
                                                                             data_source_deleted_flag boolean
);

CREATE INDEX idx_pricing_comparison_request_eligible_offering__pid ON history_octane.pricing_comparison_request_eligible_offering (pcreo_pid);

CREATE INDEX idx_d432de7d08309bddb11a6c3b64a1517b ON history_octane.pricing_comparison_request_eligible_offering (data_source_updated_datetime);

CREATE INDEX idx_c3f0705a10bd970ad6eb26a4dc4cb54f ON history_octane.pricing_comparison_request_eligible_offering (data_source_deleted_flag);

CREATE INDEX idx_pricing_comparison_request_eligible_offering__pid_version ON history_octane.pricing_comparison_request_eligible_offering (pcreo_pid, pcreo_version);

CREATE INDEX fk_pricing_comparison_request_eligible_offering_1 ON history_octane.pricing_comparison_request_eligible_offering (pcreo_pricing_comparison_request_pid);

CREATE TABLE history_octane.pricing_comparison_mismatch (
                                                            pcm_pid bigint,
                                                            pcm_version integer,
                                                            pcm_pricing_comparison_request_pid bigint,
                                                            pcm_offering_id varchar(32),
                                                            pcm_offering_name varchar(128),
                                                            pcm_investor_product_id varchar(32),
                                                            pcm_investor_id varchar(32),
                                                            pcm_arm_product boolean,
                                                            pcm_lien_priority_type varchar(128),
                                                            pcm_note_rate numeric(11,9),
                                                            pcm_lock_commitment_type varchar(128),
                                                            pcm_lock_duration_days integer,
                                                            pcm_base_price_internal numeric(11,9),
                                                            pcm_base_price_hybrid numeric(11,9),
                                                            pcm_base_arm_margin_percent_internal numeric(11,9),
                                                            pcm_base_arm_margin_percent_hybrid numeric(11,9),
                                                            pcm_final_price_internal numeric(11,9),
                                                            pcm_final_price_hybrid numeric(11,9),
                                                            pcm_final_profit_margin_internal numeric(11,9),
                                                            pcm_final_profit_margin_hybrid numeric(11,9),
                                                            data_source_updated_datetime timestamptz,
                                                            data_source_deleted_flag boolean
);

CREATE INDEX idx_pricing_comparison_mismatch__pid ON history_octane.pricing_comparison_mismatch (pcm_pid);

CREATE INDEX idx_pricing_comparison_mismatch__data_source_updated_datetime ON history_octane.pricing_comparison_mismatch (data_source_updated_datetime);

CREATE INDEX idx_pricing_comparison_mismatch__data_source_deleted_flag ON history_octane.pricing_comparison_mismatch (data_source_deleted_flag);

CREATE INDEX idx_pricing_comparison_mismatch__pid_version ON history_octane.pricing_comparison_mismatch (pcm_pid, pcm_version);

CREATE INDEX fk_pricing_comparison_mismatch_1 ON history_octane.pricing_comparison_mismatch (pcm_pricing_comparison_request_pid);

CREATE INDEX fkt_pcm_lien_priority_type ON history_octane.pricing_comparison_mismatch (pcm_lien_priority_type);

CREATE INDEX fkt_pcm_lock_commitment_type ON history_octane.pricing_comparison_mismatch (pcm_lock_commitment_type);

CREATE TABLE history_octane.pricing_comparison_mismatch_add_on (
                                                                   pcmao_pid bigint,
                                                                   pcmao_version integer,
                                                                   pcmao_pricing_comparison_mismatch_pid bigint,
                                                                   pcmao_rate numeric(11,9),
                                                                   pcmao_price numeric(11,9),
                                                                   pcmao_margin numeric(11,9),
                                                                   pcmao_arm_margin_adjustment numeric(11,9),
                                                                   pcmao_description varchar(16000),
                                                                   pcmao_pricing_engine_type varchar(128),
                                                                   data_source_updated_datetime timestamptz,
                                                                   data_source_deleted_flag boolean
);

CREATE INDEX idx_pricing_comparison_mismatch_add_on__pid ON history_octane.pricing_comparison_mismatch_add_on (pcmao_pid);

CREATE INDEX idx_23f5793a0438cff69eb2abec8ff36ae5 ON history_octane.pricing_comparison_mismatch_add_on (data_source_updated_datetime);

CREATE INDEX idx_951c4039226e52ea269e62c2c0c5831e ON history_octane.pricing_comparison_mismatch_add_on (data_source_deleted_flag);

CREATE INDEX idx_pricing_comparison_mismatch_add_on__pid_version ON history_octane.pricing_comparison_mismatch_add_on (pcmao_pid, pcmao_version);

CREATE INDEX fk_pricing_comparison_mismatch_add_on_1 ON history_octane.pricing_comparison_mismatch_add_on (pcmao_pricing_comparison_mismatch_pid);

CREATE INDEX fkt_pcmao_pricing_engine_type ON history_octane.pricing_comparison_mismatch_add_on (pcmao_pricing_engine_type);

CREATE TABLE history_octane.pricing_comparison_mismatch_margin (
                                                                   pcmm_pid bigint,
                                                                   pcmm_version integer,
                                                                   pcmm_pricing_comparison_mismatch_pid bigint,
                                                                   pcmm_percent numeric(11,9),
                                                                   pcmm_dollar numeric(15,2),
                                                                   pcmm_margin_type varchar(128),
                                                                   pcmm_description varchar(16000),
                                                                   pcmm_pricing_engine_type varchar(128),
                                                                   data_source_updated_datetime timestamptz,
                                                                   data_source_deleted_flag boolean
);

CREATE INDEX idx_pricing_comparison_mismatch_margin__pid ON history_octane.pricing_comparison_mismatch_margin (pcmm_pid);

CREATE INDEX idx_34511bb16ffa01b5034056ae54e735de ON history_octane.pricing_comparison_mismatch_margin (data_source_updated_datetime);

CREATE INDEX idx_b609c5a71490ca73445bce305db76fdb ON history_octane.pricing_comparison_mismatch_margin (data_source_deleted_flag);

CREATE INDEX idx_pricing_comparison_mismatch_margin__pid_version ON history_octane.pricing_comparison_mismatch_margin (pcmm_pid, pcmm_version);

CREATE INDEX fk_pricing_comparison_mismatch_margin_1 ON history_octane.pricing_comparison_mismatch_margin (pcmm_pricing_comparison_mismatch_pid);

CREATE INDEX fkt_pcmm_margin_type ON history_octane.pricing_comparison_mismatch_margin (pcmm_margin_type);

CREATE INDEX fkt_pcmm_pricing_engine_type ON history_octane.pricing_comparison_mismatch_margin (pcmm_pricing_engine_type);

ALTER TABLE history_octane.product_minimum_investor_price RENAME COLUMN pminip_minimum_includes_srp TO pminip_minimum_includes_msr;

ALTER TABLE history_octane.product_maximum_investor_price RENAME COLUMN pmip_maximum_includes_srp TO pmip_maximum_includes_msr;
