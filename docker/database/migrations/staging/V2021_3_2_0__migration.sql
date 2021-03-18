--
-- EDW - Octane data mart - NMLS Call Report table - fix data types (https://app.asana.com/0/0/1200087257796917)
--

-- drop views that need the columns
drop view octane_data_mart.nmls_call_report_national;
drop view octane_data_mart.nmls_call_report_s540a;
drop view octane_data_mart.nmls_call_report_state;

-- modify nmls_call_report_national
alter table staging_compliance.nmls_call_report_national alter column total_unpaid_balance type numeric(21,3) using total_unpaid_balance::numeric(21,3);
alter table staging_compliance.nmls_call_report_national alter column average_unpaid_balance type numeric(21,3) using average_unpaid_balance::numeric(21,3);

-- modify nmls_call_report_s540a
alter table staging_compliance.nmls_call_report_s540a alter column total_unpaid_balance type numeric(21,3) using total_unpaid_balance::numeric(21,3);
alter table staging_compliance.nmls_call_report_s540a alter column average_unpaid_balance type numeric(21,3) using average_unpaid_balance::numeric(21,3);

-- modify nmls_call_report_state
alter table staging_compliance.nmls_call_report_state alter column total_unpaid_balance type numeric(21,3) using total_unpaid_balance::numeric(21,3);
alter table staging_compliance.nmls_call_report_state alter column average_loan_size type numeric(21,3) using average_loan_size::numeric(21,3);

-- recreate views that needed the columns we modified
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

--
-- Octane 2021.1.4.0
--

ALTER TABLE staging_octane.proposal_doc
    ADD COLUMN prpd_doc_provider_group_type      varchar(128),
    ADD COLUMN prpd_doc_req_fulfill_status_type  varchar(128),
    ADD COLUMN prpd_doc_req_decision_status_type varchar(128);

CREATE INDEX fkt_prpd_doc_provider_group_type ON staging_octane.proposal_doc (prpd_doc_provider_group_type);

CREATE INDEX fkt_prpd_doc_req_fulfill_status_type ON staging_octane.proposal_doc (prpd_doc_req_fulfill_status_type);

CREATE INDEX fkt_prpd_doc_req_decision_status_type ON staging_octane.proposal_doc (prpd_doc_req_decision_status_type);

ALTER TABLE staging_octane.deal
    DROP CONSTRAINT IF EXISTS fkt_d_gse_version_type,
    DROP COLUMN d_gse_version_type;

ALTER TABLE staging_octane.proposal
    ADD COLUMN prp_gse_version_type varchar(128);

CREATE INDEX fkt_prp_gse_version_type ON staging_octane.proposal (prp_gse_version_type);

ALTER TABLE staging_octane.deal_contact
    ADD COLUMN dc_company_license_id varchar(128);

ALTER TABLE staging_octane.deal_real_estate_agent
    ALTER COLUMN drea_state_license_id SET DATA TYPE varchar(128),
    ALTER COLUMN drea_company_state_license_id SET DATA TYPE varchar(128);

ALTER TABLE staging_octane.deal_real_estate_agent
    RENAME COLUMN drea_state_license_id TO drea_license_id;

ALTER TABLE staging_octane.deal_real_estate_agent
    RENAME COLUMN drea_company_state_license_id TO drea_company_license_id;



--
-- Octane 2021.2.1.0
--

ALTER TABLE staging_octane.place
    ADD COLUMN pl_mixed_use                           varchar(128),
    ADD COLUMN pl_mixed_use_verified                  bit,
    ADD COLUMN pl_mixed_use_area_square_feet          integer,
    ADD COLUMN pl_mixed_use_area_square_feet_verified bit,
    ADD COLUMN pl_mixed_use_area_percent              numeric(11, 9);

CREATE INDEX fkt_pl_mixed_use ON staging_octane.place (pl_mixed_use);

ALTER TABLE staging_octane.loan_hedge
    DROP COLUMN lh_ship_date_to_custodian;

ALTER TABLE staging_octane.loan_hedge
    ADD COLUMN lh_ship_date_to_custodian date,
    ADD COLUMN lh_lock_vintage           date,
    ADD COLUMN lh_lock_series            integer,
    ADD COLUMN lh_investor_total         numeric(11, 9);

--
-- Octane 2021.2.2.0
--

CREATE TABLE staging_octane.borrower_declarations (
    bdec_pid                                       bigint,
    bdec_version                                   integer,
    PRIMARY KEY (bdec_pid),
    bdec_borrower_pid                              bigint,
    bdec_fha_secondary_residence                   varchar(128),
    bdec_relationship_with_seller                  varchar(128),
    bdec_borrowed_funds_undisclosed                varchar(128),
    bdec_borrowed_funds_undisclosed_amount         numeric(15, 2),
    bdec_other_mortgage_in_progress_before_closing varchar(128),
    bdec_applying_for_credit_before_closing        varchar(128),
    bdec_priority_given_to_another_lien            varchar(128),
    bdec_cosigner_undisclosed                      varchar(128),
    bdec_currently_delinquent_federal_debt         varchar(128),
    bdec_party_to_lawsuit                          varchar(128),
    bdec_conveyed_title_in_lieu_of_foreclosure     varchar(128),
    bdec_completed_pre_foreclosure_short_sale      varchar(128),
    bdec_property_foreclosure                      varchar(128),
    bdec_bankruptcy_chapter_7                      varchar(128),
    bdec_bankruptcy_chapter_11                     varchar(128),
    bdec_bankruptcy_chapter_12                     varchar(128),
    bdec_bankruptcy_chapter_13                     varchar(128)
);

CREATE INDEX fk_borrower_declarations_1 ON staging_octane.borrower_declarations (bdec_borrower_pid);

CREATE INDEX fkt_bdec_fha_secondary_residence ON staging_octane.borrower_declarations (bdec_fha_secondary_residence);

CREATE INDEX fkt_bdec_relationship_with_seller ON staging_octane.borrower_declarations (bdec_relationship_with_seller);

CREATE INDEX fkt_bdec_borrowed_funds_undisclosed ON staging_octane.borrower_declarations (bdec_borrowed_funds_undisclosed);

CREATE INDEX fkt_bdec_other_mortgage_in_progress_before_closing ON staging_octane.borrower_declarations (bdec_other_mortgage_in_progress_before_closing);

CREATE INDEX fkt_bdec_applying_for_credit_before_closing ON staging_octane.borrower_declarations (bdec_applying_for_credit_before_closing);

CREATE INDEX fkt_bdec_priority_given_to_another_lien ON staging_octane.borrower_declarations (bdec_priority_given_to_another_lien);

CREATE INDEX fkt_bdec_cosigner_undisclosed ON staging_octane.borrower_declarations (bdec_cosigner_undisclosed);

CREATE INDEX fkt_bdec_currently_delinquent_federal_debt ON staging_octane.borrower_declarations (bdec_currently_delinquent_federal_debt);

CREATE INDEX fkt_bdec_party_to_lawsuit ON staging_octane.borrower_declarations (bdec_party_to_lawsuit);

CREATE INDEX fkt_bdec_conveyed_title_in_lieu_of_foreclosure ON staging_octane.borrower_declarations (bdec_conveyed_title_in_lieu_of_foreclosure);

CREATE INDEX fkt_bdec_completed_pre_foreclosure_short_sale ON staging_octane.borrower_declarations (bdec_completed_pre_foreclosure_short_sale);

CREATE INDEX fkt_bdec_property_foreclosure ON staging_octane.borrower_declarations (bdec_property_foreclosure);

CREATE INDEX fkt_bdec_bankruptcy_chapter_7 ON staging_octane.borrower_declarations (bdec_bankruptcy_chapter_7);

CREATE INDEX fkt_bdec_bankruptcy_chapter_11 ON staging_octane.borrower_declarations (bdec_bankruptcy_chapter_11);

CREATE INDEX fkt_bdec_bankruptcy_chapter_12 ON staging_octane.borrower_declarations (bdec_bankruptcy_chapter_12);

CREATE INDEX fkt_bdec_bankruptcy_chapter_13 ON staging_octane.borrower_declarations (bdec_bankruptcy_chapter_13);

ALTER TABLE staging_octane.proposal
    ADD COLUMN prp_minimum_household_income_amount      numeric(15, 2),
    ADD COLUMN prp_minimum_residual_income_amount       numeric(15, 2),
    ADD COLUMN prp_minimum_residual_income_auto_compute bit;

ALTER TABLE staging_octane.proposal
    DROP COLUMN prp_household_income_guideline_amount;

ALTER TABLE staging_octane.borrower_va
    ADD COLUMN bva_entitled_to_military_based_facilities varchar(128),
    ADD COLUMN bva_one_hundred_percent_disabled_veteran  varchar(128),
    ADD COLUMN bva_medal_of_honor_recipient              bit;

CREATE INDEX fkt_bva_entitled_to_military_based_facilities ON staging_octane.borrower_va (bva_entitled_to_military_based_facilities);

CREATE INDEX fkt_bva_one_hundred_percent_disabled_veteran ON staging_octane.borrower_va (bva_one_hundred_percent_disabled_veteran);

CREATE TABLE staging_octane.minimum_required_residual_income_table (
    mrit_pid            bigint,
    mrit_version        integer,
    PRIMARY KEY (mrit_pid),
    mrit_effective_date date
);

CREATE TABLE staging_octane.minimum_required_residual_income_row (
    mrir_pid                                        bigint,
    mrir_version                                    integer,
    PRIMARY KEY (mrir_pid),
    mrir_minimum_required_residual_income_table_pid bigint,
    mrir_state_type                                 varchar(16),
    mrir_household_size                             integer,
    mrir_loan_amount_min                            numeric(15, 2),
    mrir_loan_amount_max                            numeric(15, 2),
    mrir_minimum_required_residual_income_amount    numeric(15, 2)
);

CREATE INDEX fk_minimum_required_residual_income_row_1 ON staging_octane.minimum_required_residual_income_row (mrir_minimum_required_residual_income_table_pid);

CREATE INDEX fkt_mrir_state_type ON staging_octane.minimum_required_residual_income_row (mrir_state_type);

ALTER TABLE staging_octane.borrower
    ADD COLUMN b_domestic_relationship_state_type varchar(128);

CREATE INDEX fkt_b_domestic_relationship_state_type ON staging_octane.borrower (b_domestic_relationship_state_type);

--
-- Octane 2021.2.3.0
--

ALTER TABLE staging_octane.place
    ADD COLUMN pl_trust_classification_type varchar(128);

CREATE INDEX fkt_pl_trust_classification_type ON staging_octane.place (pl_trust_classification_type);

ALTER TABLE staging_octane.job_income
    ADD COLUMN ji_line_of_work_months integer;

ALTER TABLE staging_octane.loan
    ADD COLUMN l_hpml bit;

ALTER TABLE staging_octane.deal
    ADD COLUMN d_enable_electronic_transaction_boolean bit;

ALTER TABLE staging_octane.deal
    DROP CONSTRAINT IF EXISTS fkt_d_enable_electronic_transaction,
    DROP COLUMN d_enable_electronic_transaction,
    ALTER COLUMN d_enable_electronic_transaction_boolean SET DATA TYPE bit;

ALTER TABLE staging_octane.deal
    RENAME COLUMN d_enable_electronic_transaction_boolean TO d_enable_electronic_transaction;

--
-- Octane 2021.2.4.0
--

ALTER TABLE staging_octane.investor
    ADD COLUMN i_offers_secondary_financing      bit,
    ADD COLUMN i_secondary_financing_source_type varchar(128);

CREATE INDEX fkt_i_secondary_financing_source_type ON staging_octane.investor (i_secondary_financing_source_type);

--
-- Octane 2021.2.4.10
--

CREATE TABLE staging_octane.new_lock_only_add_on (
    nlo_pid           bigint,
    nlo_version       integer,
    PRIMARY KEY (nlo_pid),
    nlo_account_pid   bigint,
    nlo_add_on_prefix varchar(32)
);

CREATE INDEX fk_new_lock_only_add_on_1 ON staging_octane.new_lock_only_add_on (nlo_account_pid);

--
-- Octane 2021.3.1.0
--

ALTER TABLE staging_octane.deal_key_roles
    ADD COLUMN dkrs_closing_scheduler_lender_user_pid             bigint,
    ADD COLUMN dkrs_closing_scheduler_fmls                        varchar(128),
    ADD COLUMN dkrs_collateral_underwriter_lender_user_pid        bigint,
    ADD COLUMN dkrs_collateral_underwriter_fmls                   varchar(128),
    ADD COLUMN dkrs_correspondent_client_advocate_lender_user_pid bigint,
    ADD COLUMN dkrs_correspondent_client_advocate_fmls            varchar(128),
    ADD COLUMN dkrs_flood_insurance_specialist_lender_user_pid    bigint,
    ADD COLUMN dkrs_flood_insurance_specialist_fmls               varchar(128),
    ADD COLUMN dkrs_hoa_specialist_lender_user_pid                bigint,
    ADD COLUMN dkrs_hoa_specialist_fmls                           varchar(128),
    ADD COLUMN dkrs_hoi_specialist_lender_user_pid                bigint,
    ADD COLUMN dkrs_hoi_specialist_fmls                           varchar(128),
    ADD COLUMN dkrs_ho6_specialist_lender_user_pid                bigint,
    ADD COLUMN dkrs_ho6_specialist_fmls                           varchar(128),
    ADD COLUMN dkrs_hud_va_lender_officer_lender_user_pid         bigint,
    ADD COLUMN dkrs_hud_va_lender_officer_fmls                    varchar(128),
    ADD COLUMN dkrs_loan_officer_assistant_lender_user_pid        bigint,
    ADD COLUMN dkrs_loan_officer_assistant_fmls                   varchar(128),
    ADD COLUMN dkrs_loan_payoff_specialist_lender_user_pid        bigint,
    ADD COLUMN dkrs_loan_payoff_specialist_fmls                   varchar(128),
    ADD COLUMN dkrs_subordination_specialist_lender_user_pid      bigint,
    ADD COLUMN dkrs_subordination_specialist_fmls                 varchar(128),
    ADD COLUMN dkrs_title_specialist_lender_user_pid              bigint,
    ADD COLUMN dkrs_title_specialist_fmls                         varchar(128),
    ADD COLUMN dkrs_underwriting_manager_lender_user_pid          bigint,
    ADD COLUMN dkrs_underwriting_manager_fmls                     varchar(128),
    ADD COLUMN dkrs_va_specialist_lender_user_pid                 bigint,
    ADD COLUMN dkrs_va_specialist_fmls                            varchar(128),
    ADD COLUMN dkrs_verbal_voe_specialist_lender_user_pid         bigint,
    ADD COLUMN dkrs_verbal_voe_specialist_fmls                    varchar(128),
    ADD COLUMN dkrs_voe_specialist_lender_user_pid                bigint,
    ADD COLUMN dkrs_voe_specialist_fmls                           varchar(128),
    ADD COLUMN dkrs_wire_specialist_lender_user_pid               bigint,
    ADD COLUMN dkrs_wire_specialist_fmls                          varchar(128);

CREATE INDEX fk_deal_key_roles_18 ON staging_octane.deal_key_roles (dkrs_closing_scheduler_lender_user_pid);

CREATE INDEX fk_deal_key_roles_19 ON staging_octane.deal_key_roles (dkrs_collateral_underwriter_lender_user_pid);

CREATE INDEX fk_deal_key_roles_20 ON staging_octane.deal_key_roles (dkrs_correspondent_client_advocate_lender_user_pid);

CREATE INDEX fk_deal_key_roles_21 ON staging_octane.deal_key_roles (dkrs_flood_insurance_specialist_lender_user_pid);

CREATE INDEX fk_deal_key_roles_22 ON staging_octane.deal_key_roles (dkrs_hoa_specialist_lender_user_pid);

CREATE INDEX fk_deal_key_roles_23 ON staging_octane.deal_key_roles (dkrs_hoi_specialist_lender_user_pid);

CREATE INDEX fk_deal_key_roles_24 ON staging_octane.deal_key_roles (dkrs_ho6_specialist_lender_user_pid);

CREATE INDEX fk_deal_key_roles_25 ON staging_octane.deal_key_roles (dkrs_hud_va_lender_officer_lender_user_pid);

CREATE INDEX fk_deal_key_roles_26 ON staging_octane.deal_key_roles (dkrs_loan_officer_assistant_lender_user_pid);

CREATE INDEX fk_deal_key_roles_27 ON staging_octane.deal_key_roles (dkrs_loan_payoff_specialist_lender_user_pid);

CREATE INDEX fk_deal_key_roles_28 ON staging_octane.deal_key_roles (dkrs_subordination_specialist_lender_user_pid);

CREATE INDEX fk_deal_key_roles_29 ON staging_octane.deal_key_roles (dkrs_title_specialist_lender_user_pid);

CREATE INDEX fk_deal_key_roles_30 ON staging_octane.deal_key_roles (dkrs_underwriting_manager_lender_user_pid);

CREATE INDEX fk_deal_key_roles_31 ON staging_octane.deal_key_roles (dkrs_va_specialist_lender_user_pid);

CREATE INDEX fk_deal_key_roles_32 ON staging_octane.deal_key_roles (dkrs_verbal_voe_specialist_lender_user_pid);

CREATE INDEX fk_deal_key_roles_33 ON staging_octane.deal_key_roles (dkrs_voe_specialist_lender_user_pid);

CREATE INDEX fk_deal_key_roles_34 ON staging_octane.deal_key_roles (dkrs_wire_specialist_lender_user_pid);

ALTER TABLE staging_octane.criteria_snippet
    ALTER COLUMN crs_compatible_with_smart_doc_criteria SET DATA TYPE bit;

ALTER TABLE staging_octane.criteria_snippet
    RENAME COLUMN crs_compatible_with_smart_doc_criteria TO crs_compatible_with_smart_doc;

--
-- Octane 2021.3.2.0
--

ALTER TABLE staging_octane.smart_doc
    ADD COLUMN sd_action_entity_government_insurance bit,
    ADD COLUMN sd_action_entity_underwriting_manager bit;

