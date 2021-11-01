--
-- Main | EDW - Octane schemas from prod-release to V2021.11.2.1 on uat
-- https://app.asana.com/0/0/1201362050225727
--

--staging_octane changes
CREATE TABLE staging_octane.company_license_contact (
    cmlc_pid BIGINT,
    cmlc_version INTEGER,
    CONSTRAINT pk_company_license_contact
        PRIMARY KEY (cmlc_pid),
    cmlc_lender_user_pid BIGINT,
    cmlc_company_license_pid BIGINT,
    cmlc_from_date DATE,
    cmlc_through_date DATE
);

CREATE INDEX idx_company_license_contact__pid_version ON staging_octane.company_license_contact (cmlc_pid, cmlc_version);

ALTER TABLE staging_octane.lender_user
    ADD COLUMN lu_marketing_details_enabled BOOLEAN,
    ADD COLUMN lu_marketing_details_featured_review VARCHAR(1024);

ALTER TABLE staging_octane.proposal
    ADD COLUMN prp_proposed_additional_monthly_payment DECIMAL(17, 2),
    ADD COLUMN prp_term_borrower_intends_to_retain_property INTEGER;

ALTER TABLE staging_octane.proposal_construction
    ADD COLUMN prpc_contingency_reserve_required BOOLEAN;

ALTER TABLE staging_octane.proposal_req
    DROP COLUMN prpr_decision_status_reason,
    DROP COLUMN prpr_fulfill_status_reason;

ALTER TABLE staging_octane.lender_user_location
    ADD COLUMN luloc_current_physical_location BOOLEAN,
    ADD COLUMN luloc_current_license_location BOOLEAN,
    ADD COLUMN luloc_synthetic_unique_current_physical_location BOOLEAN,
    ADD COLUMN luloc_synthetic_unique_current_license_location BOOLEAN;

--history_octane changes
CREATE TABLE history_octane.company_license_contact (
    cmlc_pid BIGINT,
    cmlc_version INTEGER,
    cmlc_lender_user_pid BIGINT,
    cmlc_company_license_pid BIGINT,
    cmlc_from_date DATE,
    cmlc_through_date DATE,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN
);

CREATE INDEX idx_company_license_contact__pid ON history_octane.company_license_contact (cmlc_pid);

CREATE INDEX idx_company_license_contact__data_source_updated_datetime ON history_octane.company_license_contact (data_source_updated_datetime);

CREATE INDEX idx_company_license_contact__data_source_deleted_flag ON history_octane.company_license_contact (data_source_deleted_flag);

CREATE INDEX idx_company_license_contact__pid_version ON history_octane.company_license_contact (cmlc_pid, cmlc_version);

CREATE INDEX fk_company_license_contact_1 ON history_octane.company_license_contact (cmlc_lender_user_pid);

CREATE INDEX fk_company_license_contact_2 ON history_octane.company_license_contact (cmlc_company_license_pid);

ALTER TABLE history_octane.lender_user
    ADD COLUMN lu_marketing_details_enabled BOOLEAN,
    ADD COLUMN lu_marketing_details_featured_review VARCHAR(1024);

ALTER TABLE history_octane.proposal
    ADD COLUMN prp_proposed_additional_monthly_payment DECIMAL(17, 2),
    ADD COLUMN prp_term_borrower_intends_to_retain_property INTEGER;

ALTER TABLE history_octane.proposal_construction
    ADD COLUMN prpc_contingency_reserve_required BOOLEAN;

ALTER TABLE history_octane.lender_user_location
    ADD COLUMN luloc_current_physical_location BOOLEAN,
    ADD COLUMN luloc_current_license_location BOOLEAN,
    ADD COLUMN luloc_synthetic_unique_current_physical_location BOOLEAN,
    ADD COLUMN luloc_synthetic_unique_current_license_location BOOLEAN;

--
-- EDW | Pentaho - log ETL start and end times and other metadata to a table in EDW
-- https://app.asana.com/0/0/1201311226688068
--

CREATE TABLE star_common.etl_log (
    dwid BIGSERIAL
        PRIMARY KEY,
    etl_batch_id TEXT NOT NULL,
    etl_start_date_time TIMESTAMPTZ NOT NULL,
    etl_end_date_time TIMESTAMPTZ,
    etl_duration INTERVAL GENERATED ALWAYS AS (etl_end_date_time - etl_start_date_time) STORED,
    status TEXT NOT NULL,
    process_name TEXT NOT NULL,
    controller_job_batch_id INTEGER,
    input_json TEXT,
    output_json TEXT,
    input_rows_read BIGINT,
    -- store duration as # of milliseconds then calculate the duration because Pentaho can't write directly to an INTERVAL field by default
    input_step_duration_ms BIGINT,
    -- adding ".0" to "1000.0" in the below calculation forces floating-point division (answer is rounded to nearest integer otherwise)
    input_step_duration INTERVAL GENERATED ALWAYS AS (MAKE_INTERVAL( secs := input_step_duration_ms / 1000.0 )) STORED,
    output_rows_inserted BIGINT,
    output_rows_updated BIGINT,
    output_rows_deleted BIGINT,
    output_rows_rejected BIGINT,
    output_total_rows BIGINT GENERATED ALWAYS AS (output_rows_inserted + output_rows_updated + output_rows_deleted + output_rows_rejected) STORED,
    output_step_duration_ms BIGINT,
    output_step_duration INTERVAL GENERATED ALWAYS AS (MAKE_INTERVAL( secs := output_step_duration_ms / 1000.0 )) STORED
);

CREATE INDEX idx_etl_log__etl_batch_id ON star_common.etl_log (etl_batch_id);
CREATE INDEX idx_etl_log__etl_start_date_time ON star_common.etl_log (etl_start_date_time);
CREATE INDEX idx_etl_log__etl_end_date_time ON star_common.etl_log (etl_end_date_time);

--
-- EDW | Correct table and column discrepancies between EDW and Octane prod
-- https://app.asana.com/0/0/1201243778259925
--

-- staging_octane changes

DROP TABLE staging_octane.du_key_finding;
DROP TABLE staging_octane.du_refi_plus_finding;
DROP TABLE staging_octane.liability_new;

ALTER TABLE staging_octane.lender_user
    DROP COLUMN lu_challenge_question_answer;

ALTER TABLE staging_octane.liability
    ADD COLUMN lia_credit_request_liability_pid BIGINT,
    DROP COLUMN lia_account_reported_date,
    DROP COLUMN lia_agency_case_id,
    DROP COLUMN lia_closing_date,
    DROP COLUMN lia_consumer_dispute,
    DROP COLUMN lia_credit_report_identifier,
    DROP COLUMN lia_credit_request_pid,
    DROP COLUMN lia_creditor_pid,
    DROP COLUMN lia_current_escrow_balance_amount,
    DROP COLUMN lia_daily_interest_amount,
    DROP COLUMN lia_derogatory_data,
    DROP COLUMN lia_effective_payoff_date,
    DROP COLUMN lia_effective_payoff_date_adjustment_amount,
    DROP COLUMN lia_effective_payoff_date_adjustment_days,
    DROP COLUMN lia_equifax_included,
    DROP COLUMN lia_experian_included,
    DROP COLUMN lia_first_payment_date,
    DROP COLUMN lia_heloc_advance_last_12_months_over_thousand,
    DROP COLUMN lia_include_within_cema,
    DROP COLUMN lia_interest_only,
    DROP COLUMN lia_interest_rate_on_statement,
    DROP COLUMN lia_interest_rate_percent,
    DROP COLUMN lia_last_activity_date,
    DROP COLUMN lia_late30_days_count,
    DROP COLUMN lia_late60_days_count,
    DROP COLUMN lia_late90_days_count,
    DROP COLUMN lia_liability_account_status_type,
    DROP COLUMN lia_liability_current_rating_type,
    DROP COLUMN lia_liability_financing_type,
    DROP COLUMN lia_liability_foreclosure_exception_type,
    DROP COLUMN lia_liability_mi_type,
    DROP COLUMN lia_lien_priority_type,
    DROP COLUMN lia_loan_amortization_type,
    DROP COLUMN lia_mip_due_amount,
    DROP COLUMN lia_monthly_interest_amount,
    DROP COLUMN lia_months_reviewed_count,
    DROP COLUMN lia_most_recent_adverse_rating_date,
    DROP COLUMN lia_net_escrow,
    DROP COLUMN lia_next_payment_due_date,
    DROP COLUMN lia_original_loan_amount,
    DROP COLUMN lia_other_payoff_related_charges_amount,
    DROP COLUMN lia_payoff_amount_estimated,
    DROP COLUMN lia_payoff_interest_pad_days,
    DROP COLUMN lia_payoff_statement_date,
    DROP COLUMN lia_payoff_statement_good_through_date,
    DROP COLUMN lia_payoff_statement_interest,
    DROP COLUMN lia_place_pid,
    DROP COLUMN lia_property_insurance_escrowed,
    DROP COLUMN lia_property_taxes_escrowed,
    DROP COLUMN lia_report_account_opened_date,
    DROP COLUMN lia_report_account_ownership_type,
    DROP COLUMN lia_report_credit_limit_amount,
    DROP COLUMN lia_report_holder_name,
    DROP COLUMN lia_report_liability_type,
    DROP COLUMN lia_report_monthly_payment_amount,
    DROP COLUMN lia_report_past_due_amount,
    DROP COLUMN lia_report_remaining_term_months,
    DROP COLUMN lia_report_terms_months_count,
    DROP COLUMN lia_report_unpaid_balance_amount,
    DROP COLUMN lia_senior_lien_restriction_amount,
    DROP COLUMN lia_senior_lien_restriction_type,
    DROP COLUMN lia_texas_equity,
    DROP COLUMN lia_texas_equity_conversion,
    DROP COLUMN lia_texas_equity_locked,
    DROP COLUMN lia_third_party_community_second_program_pid,
    DROP COLUMN lia_trans_union_included,
    DROP COLUMN lia_unpaid_late_charges_amount,
    DROP COLUMN lia_used_to_acquire_property;

-- history_octane changes

DROP TABLE history_octane.du_key_finding;
DROP TABLE history_octane.du_refi_plus_finding;
DROP TABLE history_octane.liability_new;

ALTER TABLE history_octane.lender_user
    DROP COLUMN lu_challenge_question_answer;

ALTER TABLE history_octane.liability
    ADD COLUMN lia_credit_request_liability_pid BIGINT,
    DROP COLUMN lia_account_reported_date,
    DROP COLUMN lia_agency_case_id,
    DROP COLUMN lia_closing_date,
    DROP COLUMN lia_consumer_dispute,
    DROP COLUMN lia_credit_report_identifier,
    DROP COLUMN lia_credit_request_pid,
    DROP COLUMN lia_creditor_pid,
    DROP COLUMN lia_current_escrow_balance_amount,
    DROP COLUMN lia_daily_interest_amount,
    DROP COLUMN lia_derogatory_data,
    DROP COLUMN lia_effective_payoff_date,
    DROP COLUMN lia_effective_payoff_date_adjustment_amount,
    DROP COLUMN lia_effective_payoff_date_adjustment_days,
    DROP COLUMN lia_equifax_included,
    DROP COLUMN lia_experian_included,
    DROP COLUMN lia_first_payment_date,
    DROP COLUMN lia_heloc_advance_last_12_months_over_thousand,
    DROP COLUMN lia_include_within_cema,
    DROP COLUMN lia_interest_only,
    DROP COLUMN lia_interest_rate_on_statement,
    DROP COLUMN lia_interest_rate_percent,
    DROP COLUMN lia_last_activity_date,
    DROP COLUMN lia_late30_days_count,
    DROP COLUMN lia_late60_days_count,
    DROP COLUMN lia_late90_days_count,
    DROP COLUMN lia_liability_account_status_type,
    DROP COLUMN lia_liability_current_rating_type,
    DROP COLUMN lia_liability_financing_type,
    DROP COLUMN lia_liability_foreclosure_exception_type,
    DROP COLUMN lia_liability_mi_type,
    DROP COLUMN lia_lien_priority_type,
    DROP COLUMN lia_loan_amortization_type,
    DROP COLUMN lia_mip_due_amount,
    DROP COLUMN lia_monthly_interest_amount,
    DROP COLUMN lia_months_reviewed_count,
    DROP COLUMN lia_most_recent_adverse_rating_date,
    DROP COLUMN lia_net_escrow,
    DROP COLUMN lia_next_payment_due_date,
    DROP COLUMN lia_original_loan_amount,
    DROP COLUMN lia_other_payoff_related_charges_amount,
    DROP COLUMN lia_payoff_amount_estimated,
    DROP COLUMN lia_payoff_interest_pad_days,
    DROP COLUMN lia_payoff_statement_date,
    DROP COLUMN lia_payoff_statement_good_through_date,
    DROP COLUMN lia_payoff_statement_interest,
    DROP COLUMN lia_place_pid,
    DROP COLUMN lia_property_insurance_escrowed,
    DROP COLUMN lia_property_taxes_escrowed,
    DROP COLUMN lia_report_account_opened_date,
    DROP COLUMN lia_report_account_ownership_type,
    DROP COLUMN lia_report_credit_limit_amount,
    DROP COLUMN lia_report_holder_name,
    DROP COLUMN lia_report_liability_type,
    DROP COLUMN lia_report_monthly_payment_amount,
    DROP COLUMN lia_report_past_due_amount,
    DROP COLUMN lia_report_remaining_term_months,
    DROP COLUMN lia_report_terms_months_count,
    DROP COLUMN lia_report_unpaid_balance_amount,
    DROP COLUMN lia_senior_lien_restriction_amount,
    DROP COLUMN lia_senior_lien_restriction_type,
    DROP COLUMN lia_texas_equity,
    DROP COLUMN lia_texas_equity_conversion,
    DROP COLUMN lia_texas_equity_locked,
    DROP COLUMN lia_third_party_community_second_program_pid,
    DROP COLUMN lia_trans_union_included,
    DROP COLUMN lia_unpaid_late_charges_amount,
    DROP COLUMN lia_used_to_acquire_property;
