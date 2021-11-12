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
