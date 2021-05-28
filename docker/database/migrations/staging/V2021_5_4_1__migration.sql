--
-- EDW | DDL changes - Octane Schema changes for 2021.5.4.0 (5/28/21)
-- https://app.asana.com/0/0/1200387930619085
--

-- staging_octane changes
CREATE TABLE staging_octane.credit_request_liability (
    crl_pid BIGINT,
    crl_version INTEGER,
    CONSTRAINT pk_credit_request_liability
        PRIMARY KEY (crl_pid),
    crl_deal_pid BIGINT,
    crl_credit_request_pid BIGINT,
    crl_credit_report_identifier VARCHAR(32),
    crl_report_liability_type VARCHAR(128),
    crl_report_holder_name VARCHAR(128),
    crl_report_account_opened_date DATE,
    crl_account_reported_date DATE,
    crl_last_activity_date DATE,
    crl_most_recent_adverse_rating_date DATE,
    crl_report_monthly_payment_amount DECIMAL(17, 2),
    crl_report_remaining_term_months INTEGER,
    crl_months_reviewed_count INTEGER,
    crl_report_unpaid_balance_amount DECIMAL(17, 2),
    crl_report_credit_limit_amount NUMERIC(15, 0),
    crl_report_past_due_amount DECIMAL(17, 2),
    crl_report_terms_months_count INTEGER,
    crl_report_liability_current_rating_type VARCHAR(128),
    crl_report_liability_account_status_type VARCHAR(128),
    crl_report_liability_account_ownership_type VARCHAR(128),
    crl_consumer_dispute VARCHAR(128),
    crl_derogatory_data VARCHAR(128),
    crl_late_30_days_count VARCHAR(16),
    crl_late_60_days_count VARCHAR(16),
    crl_late_90_days_count VARCHAR(16),
    crl_equifax_included BOOLEAN,
    crl_experian_included BOOLEAN,
    crl_trans_union_included BOOLEAN,
    crl_temp_liability_pid BIGINT
);

CREATE INDEX idx_credit_request_liability__pid_version ON staging_octane.credit_request_liability (crl_pid, crl_version);

CREATE TABLE staging_octane.liability_new (
    lia_pid BIGINT,
    lia_version INTEGER,
    CONSTRAINT pk_liability_new
        PRIMARY KEY (lia_pid),
    lia_proposal_pid BIGINT,
    lia_account_id VARCHAR(32),
    lia_aggregate_description VARCHAR(128),
    lia_credit_request_liability_pid BIGINT,
    lia_description VARCHAR(128),
    lia_city VARCHAR(128),
    lia_country VARCHAR(128),
    lia_postal_code VARCHAR(128),
    lia_state VARCHAR(128),
    lia_street1 VARCHAR(128),
    lia_street2 VARCHAR(128),
    lia_holder_name VARCHAR(128),
    lia_holder_phone VARCHAR(32),
    lia_holder_phone_extension VARCHAR(16),
    lia_holder_fax VARCHAR(32),
    lia_holder_email VARCHAR(256),
    lia_account_opened_date DATE,
    lia_liability_disposition_type VARCHAR(128),
    lia_liability_type VARCHAR(128),
    lia_monthly_payment_amount NUMERIC(15, 2),
    lia_remaining_term_months INTEGER,
    lia_high_balance_amount NUMERIC(15, 2),
    lia_credit_limit_amount NUMERIC(15, 0),
    lia_past_due_amount NUMERIC(15, 2),
    lia_unpaid_balance_amount NUMERIC(15, 2),
    lia_report_value_overridden BOOLEAN,
    lia_bankruptcy_exception_type VARCHAR(128),
    lia_note VARCHAR(1024),
    lia_terms_months_count INTEGER,
    lia_payoff_amount NUMERIC(15, 2),
    lia_energy_related_type VARCHAR(128)
);

CREATE INDEX idx_liability_new__pid_version ON staging_octane.liability_new (lia_pid, lia_version);

CREATE TABLE staging_octane.liability_place (
    lip_pid BIGINT,
    lip_version INTEGER,
    CONSTRAINT pk_liability_place
        PRIMARY KEY (lip_pid),
    lip_liability_pid BIGINT,
    lip_creditor_pid BIGINT,
    lip_place_pid BIGINT,
    lip_lien_priority_type VARCHAR(128),
    lip_liability_financing_type VARCHAR(128),
    lip_liability_foreclosure_exception_type VARCHAR(128),
    lip_liability_mi_type VARCHAR(128),
    lip_original_loan_amount NUMERIC(15, 0),
    lip_property_taxes_escrowed BOOLEAN,
    lip_property_insurance_escrowed BOOLEAN,
    lip_senior_lien_restriction_type VARCHAR(128),
    lip_senior_lien_restriction_amount NUMERIC(15, 0),
    lip_texas_equity VARCHAR(128),
    lip_texas_equity_conversion VARCHAR(128),
    lip_texas_equity_locked BOOLEAN,
    lip_third_party_community_second_program_pid BIGINT
);

CREATE INDEX idx_liability_place__pid_version ON staging_octane.liability_place (lip_pid, lip_version);

CREATE TABLE staging_octane.liability_mortgage_payoff (
    lmp_pid BIGINT,
    lmp_version INTEGER,
    CONSTRAINT pk_liability_mortgage_payoff
        PRIMARY KEY (lmp_pid),
    lmp_liability_pid BIGINT,
    lmp_interest_rate_on_statement BOOLEAN,
    lmp_interest_rate_percent NUMERIC(11, 9),
    lmp_loan_amortization_type VARCHAR(128),
    lmp_interest_only VARCHAR(128),
    lmp_agency_case_id VARCHAR(32),
    lmp_payoff_statement_date DATE,
    lmp_payoff_statement_good_through_date DATE,
    lmp_next_payment_due_date DATE,
    lmp_payoff_statement_interest DECIMAL(17, 2),
    lmp_daily_interest_amount DECIMAL(17, 2),
    lmp_monthly_interest_amount DECIMAL(17, 2),
    lmp_payoff_interest_pad_days INTEGER,
    lmp_effective_payoff_date DATE,
    lmp_effective_payoff_date_adjustment_amount DECIMAL(17, 2),
    lmp_effective_payoff_date_adjustment_days INTEGER,
    lmp_other_payoff_related_charges_amount DECIMAL(17, 2),
    lmp_unpaid_late_charges_amount NUMERIC(15, 2),
    lmp_mortgage_payoff_amount_estimated BOOLEAN,
    lmp_mip_due_amount DECIMAL(17, 2),
    lmp_used_to_acquire_property VARCHAR(128),
    lmp_heloc_advance_last_12_months_over_thousand VARCHAR(128),
    lmp_net_escrow VARCHAR(128),
    lmp_current_escrow_balance_amount DECIMAL(17, 2),
    lmp_first_payment_date DATE,
    lmp_closing_date DATE,
    lmp_include_within_cema VARCHAR(128)
);

CREATE INDEX idx_liability_mortgage_payoff__pid_version ON staging_octane.liability_mortgage_payoff (lmp_pid, lmp_version);

ALTER TABLE staging_octane.credit_request_liability
    DROP COLUMN crl_temp_liability_pid;

ALTER TABLE staging_octane.proposal
    ALTER COLUMN prp_construction_budget_url SET DATA TYPE VARCHAR(1024);

ALTER TABLE staging_octane.proposal
    RENAME COLUMN prp_construction_budget_url TO prp_cr_tracker_url;

--history_octane changes
CREATE TABLE history_octane.credit_request_liability (
    crl_pid BIGINT,
    crl_version INTEGER,
    crl_deal_pid BIGINT,
    crl_credit_request_pid BIGINT,
    crl_credit_report_identifier VARCHAR(32),
    crl_report_liability_type VARCHAR(128),
    crl_report_holder_name VARCHAR(128),
    crl_report_account_opened_date DATE,
    crl_account_reported_date DATE,
    crl_last_activity_date DATE,
    crl_most_recent_adverse_rating_date DATE,
    crl_report_monthly_payment_amount DECIMAL(17, 2),
    crl_report_remaining_term_months INTEGER,
    crl_months_reviewed_count INTEGER,
    crl_report_unpaid_balance_amount DECIMAL(17, 2),
    crl_report_credit_limit_amount NUMERIC(15, 0),
    crl_report_past_due_amount DECIMAL(17, 2),
    crl_report_terms_months_count INTEGER,
    crl_report_liability_current_rating_type VARCHAR(128),
    crl_report_liability_account_status_type VARCHAR(128),
    crl_report_liability_account_ownership_type VARCHAR(128),
    crl_consumer_dispute VARCHAR(128),
    crl_derogatory_data VARCHAR(128),
    crl_late_30_days_count VARCHAR(16),
    crl_late_60_days_count VARCHAR(16),
    crl_late_90_days_count VARCHAR(16),
    crl_equifax_included BOOLEAN,
    crl_experian_included BOOLEAN,
    crl_trans_union_included BOOLEAN,
    crl_temp_liability_pid BIGINT,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN
);

CREATE INDEX idx_credit_request_liability__pid ON history_octane.credit_request_liability (crl_pid);

CREATE INDEX idx_credit_request_liability__data_source_updated_datetime ON history_octane.credit_request_liability (data_source_updated_datetime);

CREATE INDEX idx_credit_request_liability__data_source_deleted_flag ON history_octane.credit_request_liability (data_source_deleted_flag);

CREATE INDEX idx_credit_request_liability__pid_version ON history_octane.credit_request_liability (crl_pid, crl_version);

CREATE INDEX fk_credit_request_liability_1 ON history_octane.credit_request_liability (crl_deal_pid);

CREATE INDEX fk_credit_request_liability_2 ON history_octane.credit_request_liability (crl_credit_request_pid);

CREATE INDEX fkt_crl_report_liability_type ON history_octane.credit_request_liability (crl_report_liability_type);

CREATE INDEX fkt_crl_report_liability_current_rating_type ON history_octane.credit_request_liability (crl_report_liability_current_rating_type);

CREATE INDEX fkt_crl_report_liability_account_status_type ON history_octane.credit_request_liability (crl_report_liability_account_status_type);

CREATE INDEX fkt_crl_report_liability_account_ownership_type ON history_octane.credit_request_liability (crl_report_liability_account_ownership_type);

CREATE INDEX fkt_crl_consumer_dispute ON history_octane.credit_request_liability (crl_consumer_dispute);

CREATE INDEX fkt_crl_derogatory_data ON history_octane.credit_request_liability (crl_derogatory_data);

CREATE INDEX fk_credit_request_liability_3 ON history_octane.credit_request_liability (crl_temp_liability_pid);

CREATE TABLE history_octane.liability_new (
    lia_pid BIGINT,
    lia_version INTEGER,
    lia_proposal_pid BIGINT,
    lia_account_id VARCHAR(32),
    lia_aggregate_description VARCHAR(128),
    lia_credit_request_liability_pid BIGINT,
    lia_description VARCHAR(128),
    lia_city VARCHAR(128),
    lia_country VARCHAR(128),
    lia_postal_code VARCHAR(128),
    lia_state VARCHAR(128),
    lia_street1 VARCHAR(128),
    lia_street2 VARCHAR(128),
    lia_holder_name VARCHAR(128),
    lia_holder_phone VARCHAR(32),
    lia_holder_phone_extension VARCHAR(16),
    lia_holder_fax VARCHAR(32),
    lia_holder_email VARCHAR(256),
    lia_account_opened_date DATE,
    lia_liability_disposition_type VARCHAR(128),
    lia_liability_type VARCHAR(128),
    lia_monthly_payment_amount NUMERIC(15, 2),
    lia_remaining_term_months INTEGER,
    lia_high_balance_amount NUMERIC(15, 2),
    lia_credit_limit_amount NUMERIC(15, 0),
    lia_past_due_amount NUMERIC(15, 2),
    lia_unpaid_balance_amount NUMERIC(15, 2),
    lia_report_value_overridden BOOLEAN,
    lia_bankruptcy_exception_type VARCHAR(128),
    lia_note VARCHAR(1024),
    lia_terms_months_count INTEGER,
    lia_payoff_amount NUMERIC(15, 2),
    lia_energy_related_type VARCHAR(128),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN
);

CREATE INDEX idx_liability_new__pid ON history_octane.liability_new (lia_pid);

CREATE INDEX idx_liability_new__data_source_updated_datetime ON history_octane.liability_new (data_source_updated_datetime);

CREATE INDEX idx_liability_new__data_source_deleted_flag ON history_octane.liability_new (data_source_deleted_flag);

CREATE INDEX idx_liability_new__pid_version ON history_octane.liability_new (lia_pid, lia_version);

CREATE INDEX fk_liability_new_11 ON history_octane.liability_new (lia_proposal_pid);

CREATE INDEX fk_liability_new_12 ON history_octane.liability_new (lia_credit_request_liability_pid);

CREATE INDEX fkt_lia_bankruptcy_exception_type ON history_octane.liability_new (lia_bankruptcy_exception_type);

CREATE INDEX fkt_lia_country ON history_octane.liability_new (lia_country);

CREATE INDEX fkt_lia_energy_related_type ON history_octane.liability_new (lia_energy_related_type);

CREATE INDEX fkt_lia_liability_disposition_type ON history_octane.liability_new (lia_liability_disposition_type);

CREATE INDEX fkt_lia_liability_type ON history_octane.liability_new (lia_liability_type);

CREATE TABLE history_octane.liability_place (
    lip_pid BIGINT,
    lip_version INTEGER,
    lip_liability_pid BIGINT,
    lip_creditor_pid BIGINT,
    lip_place_pid BIGINT,
    lip_lien_priority_type VARCHAR(128),
    lip_liability_financing_type VARCHAR(128),
    lip_liability_foreclosure_exception_type VARCHAR(128),
    lip_liability_mi_type VARCHAR(128),
    lip_original_loan_amount NUMERIC(15, 0),
    lip_property_taxes_escrowed BOOLEAN,
    lip_property_insurance_escrowed BOOLEAN,
    lip_senior_lien_restriction_type VARCHAR(128),
    lip_senior_lien_restriction_amount NUMERIC(15, 0),
    lip_texas_equity VARCHAR(128),
    lip_texas_equity_conversion VARCHAR(128),
    lip_texas_equity_locked BOOLEAN,
    lip_third_party_community_second_program_pid BIGINT,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN
);

CREATE INDEX idx_liability_place__pid ON history_octane.liability_place (lip_pid);

CREATE INDEX idx_liability_place__data_source_updated_datetime ON history_octane.liability_place (data_source_updated_datetime);

CREATE INDEX idx_liability_place__data_source_deleted_flag ON history_octane.liability_place (data_source_deleted_flag);

CREATE INDEX idx_liability_place__pid_version ON history_octane.liability_place (lip_pid, lip_version);

CREATE INDEX fk_liability_place_1 ON history_octane.liability_place (lip_liability_pid);

CREATE INDEX fk_liability_place_2 ON history_octane.liability_place (lip_creditor_pid);

CREATE INDEX fk_liability_place_3 ON history_octane.liability_place (lip_place_pid);

CREATE INDEX fk_liability_place_4 ON history_octane.liability_place (lip_third_party_community_second_program_pid);

CREATE INDEX fkt_lip_lien_priority_type ON history_octane.liability_place (lip_lien_priority_type);

CREATE INDEX fkt_lip_liability_financing_type ON history_octane.liability_place (lip_liability_financing_type);

CREATE INDEX fkt_lip_liability_foreclosure_exception_type ON history_octane.liability_place (lip_liability_foreclosure_exception_type);

CREATE INDEX fkt_lip_liability_mi_type ON history_octane.liability_place (lip_liability_mi_type);

CREATE INDEX fkt_lip_senior_lien_restriction_type ON history_octane.liability_place (lip_senior_lien_restriction_type);

CREATE INDEX fkt_lip_texas_equity ON history_octane.liability_place (lip_texas_equity);

CREATE INDEX fkt_lip_texas_equity_conversion ON history_octane.liability_place (lip_texas_equity_conversion);

CREATE TABLE history_octane.liability_mortgage_payoff (
    lmp_pid BIGINT,
    lmp_version INTEGER,
    lmp_liability_pid BIGINT,
    lmp_interest_rate_on_statement BOOLEAN,
    lmp_interest_rate_percent NUMERIC(11, 9),
    lmp_loan_amortization_type VARCHAR(128),
    lmp_interest_only VARCHAR(128),
    lmp_agency_case_id VARCHAR(32),
    lmp_payoff_statement_date DATE,
    lmp_payoff_statement_good_through_date DATE,
    lmp_next_payment_due_date DATE,
    lmp_payoff_statement_interest DECIMAL(17, 2),
    lmp_daily_interest_amount DECIMAL(17, 2),
    lmp_monthly_interest_amount DECIMAL(17, 2),
    lmp_payoff_interest_pad_days INTEGER,
    lmp_effective_payoff_date DATE,
    lmp_effective_payoff_date_adjustment_amount DECIMAL(17, 2),
    lmp_effective_payoff_date_adjustment_days INTEGER,
    lmp_other_payoff_related_charges_amount DECIMAL(17, 2),
    lmp_unpaid_late_charges_amount NUMERIC(15, 2),
    lmp_mortgage_payoff_amount_estimated BOOLEAN,
    lmp_mip_due_amount DECIMAL(17, 2),
    lmp_used_to_acquire_property VARCHAR(128),
    lmp_heloc_advance_last_12_months_over_thousand VARCHAR(128),
    lmp_net_escrow VARCHAR(128),
    lmp_current_escrow_balance_amount DECIMAL(17, 2),
    lmp_first_payment_date DATE,
    lmp_closing_date DATE,
    lmp_include_within_cema VARCHAR(128),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN
);

CREATE INDEX idx_liability_mortgage_payoff__pid ON history_octane.liability_mortgage_payoff (lmp_pid);

CREATE INDEX idx_liability_mortgage_payoff__data_source_updated_datetime ON history_octane.liability_mortgage_payoff (data_source_updated_datetime);

CREATE INDEX idx_liability_mortgage_payoff__data_source_deleted_flag ON history_octane.liability_mortgage_payoff (data_source_deleted_flag);

CREATE INDEX idx_liability_mortgage_payoff__pid_version ON history_octane.liability_mortgage_payoff (lmp_pid, lmp_version);

CREATE INDEX fk_liability_mortgage_payoff_1 ON history_octane.liability_mortgage_payoff (lmp_liability_pid);

CREATE INDEX fkt_lmp_loan_amortization_type ON history_octane.liability_mortgage_payoff (lmp_loan_amortization_type);

CREATE INDEX fkt_lmp_interest_only ON history_octane.liability_mortgage_payoff (lmp_interest_only);

CREATE INDEX fkt_lmp_used_to_acquire_property ON history_octane.liability_mortgage_payoff (lmp_used_to_acquire_property);

CREATE INDEX fkt_lmp_heloc_advance_last_12_months_over_thousand ON history_octane.liability_mortgage_payoff (lmp_heloc_advance_last_12_months_over_thousand);

CREATE INDEX fkt_lmp_net_escrow ON history_octane.liability_mortgage_payoff (lmp_net_escrow);

CREATE INDEX fkt_lmp_include_within_cema ON history_octane.liability_mortgage_payoff (lmp_include_within_cema);

CREATE INDEX fk_borrower_liability_2 ON history_octane.borrower_liability (bl_liability_pid);

CREATE INDEX fk_deal_tag_4 ON history_octane.deal_tag (dtg_liability_pid);

CREATE INDEX fk_proposal_doc_13 ON history_octane.proposal_doc (prpd_liability_pid);

CREATE INDEX fk_proposal_req_14 ON history_octane.proposal_req (prpr_liability_pid);

CREATE INDEX fk_sap_deal_step_11 ON history_octane.sap_deal_step (sds_liability_pid);

ALTER TABLE history_octane.proposal
    ALTER COLUMN prp_construction_budget_url SET DATA TYPE VARCHAR(1024);

ALTER TABLE history_octane.proposal
    RENAME COLUMN prp_construction_budget_url TO prp_cr_tracker_url;
