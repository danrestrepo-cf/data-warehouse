--
-- Main | EDW - Octane schemas from prod-release to uat (2022-01-28)
-- https://app.asana.com/0/0/1201715439024488
--

--staging_octane changes
CREATE TABLE staging_octane.smart_doc_prior_to_type_case (
    sdpttc_pid BIGINT,
    sdpttc_version INTEGER,
    CONSTRAINT pk_smart_doc_prior_to_type_case
        PRIMARY KEY (sdpttc_pid),
    sdpttc_smart_doc_pid BIGINT,
    sdpttc_criteria_pid BIGINT,
    sdpttc_deal_child_type VARCHAR(128),
    sdpttc_deal_child_relationship_type VARCHAR(128),
    sdpttc_prior_to_type VARCHAR(128),
    sdpttc_ordinal VARCHAR(128),
    sdpttc_active BOOLEAN
);

CREATE INDEX idx_smart_doc_prior_to_type_case__pid_version ON staging_octane.smart_doc_prior_to_type_case (sdpttc_pid, sdpttc_version);

ALTER TABLE staging_octane.criteria_snippet
    ADD COLUMN crs_compatible_with_smart_doc_prior_to_type_case BOOLEAN;

CREATE TABLE staging_octane.smart_doc_provider_type_case (
    sdptc_pid BIGINT,
    sdptc_version INTEGER,
    CONSTRAINT pk_smart_doc_provider_type_case
        PRIMARY KEY (sdptc_pid),
    sdptc_smart_doc_pid BIGINT
);

CREATE INDEX idx_smart_doc_provider_type_case__pid_version ON staging_octane.smart_doc_provider_type_case (sdptc_pid, sdptc_version);

ALTER TABLE staging_octane.lead
    ADD COLUMN ld_borrower_job_employer_phone VARCHAR(32),
    ADD COLUMN ld_borrower_job_income_start_date VARCHAR(32),
    ADD COLUMN ld_borrower_job_income_end_date VARCHAR(32),
    ADD COLUMN ld_borrower_job_bonus_monthly_income VARCHAR(32),
    ADD COLUMN ld_borrower_job_2_employer_name VARCHAR(128),
    ADD COLUMN ld_borrower_job_2_position VARCHAR(32),
    ADD COLUMN ld_borrower_job_2_employer_phone VARCHAR(32),
    ADD COLUMN ld_borrower_job_2_income_start_date VARCHAR(32),
    ADD COLUMN ld_borrower_job_2_income_end_date VARCHAR(32),
    ADD COLUMN ld_borrower_job_2_gross_monthly_income VARCHAR(32),
    ADD COLUMN ld_borrower_job_2_bonus_monthly_income VARCHAR(32),
    ADD COLUMN ld_borrower_job_3_employer_name VARCHAR(128),
    ADD COLUMN ld_borrower_job_3_position VARCHAR(32),
    ADD COLUMN ld_borrower_job_3_employer_phone VARCHAR(32),
    ADD COLUMN ld_borrower_job_3_income_start_date VARCHAR(32),
    ADD COLUMN ld_borrower_job_3_income_end_date VARCHAR(32),
    ADD COLUMN ld_borrower_job_3_gross_monthly_income VARCHAR(32),
    ADD COLUMN ld_borrower_job_3_bonus_monthly_income VARCHAR(32),
    ADD COLUMN ld_borrower_residency_basis_type VARCHAR(32),
    ADD COLUMN ld_borrower_residence_from_date VARCHAR(32),
    ADD COLUMN ld_borrower_residence_through_date VARCHAR(32);

--history_octane changes
CREATE TABLE history_octane.smart_doc_prior_to_type_case (
    sdpttc_pid BIGINT,
    sdpttc_version INTEGER,
    sdpttc_smart_doc_pid BIGINT,
    sdpttc_criteria_pid BIGINT,
    sdpttc_deal_child_type VARCHAR(128),
    sdpttc_deal_child_relationship_type VARCHAR(128),
    sdpttc_prior_to_type VARCHAR(128),
    sdpttc_ordinal VARCHAR(128),
    sdpttc_active BOOLEAN,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN
);

CREATE INDEX idx_smart_doc_prior_to_type_case__pid ON history_octane.smart_doc_prior_to_type_case (sdpttc_pid);

CREATE INDEX idx_smart_doc_prior_to_type_case__data_source_updated_datetime ON history_octane.smart_doc_prior_to_type_case (data_source_updated_datetime);

CREATE INDEX idx_smart_doc_prior_to_type_case__data_source_deleted_flag ON history_octane.smart_doc_prior_to_type_case (data_source_deleted_flag);

CREATE INDEX idx_smart_doc_prior_to_type_case__pid_version ON history_octane.smart_doc_prior_to_type_case (sdpttc_pid, sdpttc_version);

CREATE INDEX fk_smart_doc_prior_to_type_case_1 ON history_octane.smart_doc_prior_to_type_case (sdpttc_smart_doc_pid);

CREATE INDEX fk_smart_doc_prior_to_type_case_2 ON history_octane.smart_doc_prior_to_type_case (sdpttc_criteria_pid);

CREATE INDEX fkt_sdpttc_deal_child_type ON history_octane.smart_doc_prior_to_type_case (sdpttc_deal_child_type);

CREATE INDEX fkt_sdpttc_deal_child_relationship_type ON history_octane.smart_doc_prior_to_type_case (sdpttc_deal_child_relationship_type);

CREATE INDEX fkt_sdpttc_prior_to_type ON history_octane.smart_doc_prior_to_type_case (sdpttc_prior_to_type);

ALTER TABLE history_octane.criteria_snippet
    ADD COLUMN crs_compatible_with_smart_doc_prior_to_type_case BOOLEAN;

CREATE TABLE history_octane.smart_doc_provider_type_case (
    sdptc_pid BIGINT,
    sdptc_version INTEGER,
    sdptc_smart_doc_pid BIGINT,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN
);

CREATE INDEX idx_smart_doc_provider_type_case__pid ON history_octane.smart_doc_provider_type_case (sdptc_pid);

CREATE INDEX idx_smart_doc_provider_type_case__data_source_updated_datetime ON history_octane.smart_doc_provider_type_case (data_source_updated_datetime);

CREATE INDEX idx_smart_doc_provider_type_case__data_source_deleted_flag ON history_octane.smart_doc_provider_type_case (data_source_deleted_flag);

CREATE INDEX idx_smart_doc_provider_type_case__pid_version ON history_octane.smart_doc_provider_type_case (sdptc_pid, sdptc_version);

CREATE INDEX fk_smart_doc_provider_type_case_1 ON history_octane.smart_doc_provider_type_case (sdptc_smart_doc_pid);

--indexes added to two existing columns on proposal_doc
CREATE INDEX fk_proposal_doc_30 ON history_octane.proposal_doc (prpd_smart_doc_prior_to_type_case_pid);

CREATE INDEX fk_proposal_doc_31 ON history_octane.proposal_doc (prpd_smart_doc_provider_type_case_pid);

ALTER TABLE history_octane.lead
    ADD COLUMN ld_borrower_job_employer_phone VARCHAR(32),
    ADD COLUMN ld_borrower_job_income_start_date VARCHAR(32),
    ADD COLUMN ld_borrower_job_income_end_date VARCHAR(32),
    ADD COLUMN ld_borrower_job_bonus_monthly_income VARCHAR(32),
    ADD COLUMN ld_borrower_job_2_employer_name VARCHAR(128),
    ADD COLUMN ld_borrower_job_2_position VARCHAR(32),
    ADD COLUMN ld_borrower_job_2_employer_phone VARCHAR(32),
    ADD COLUMN ld_borrower_job_2_income_start_date VARCHAR(32),
    ADD COLUMN ld_borrower_job_2_income_end_date VARCHAR(32),
    ADD COLUMN ld_borrower_job_2_gross_monthly_income VARCHAR(32),
    ADD COLUMN ld_borrower_job_2_bonus_monthly_income VARCHAR(32),
    ADD COLUMN ld_borrower_job_3_employer_name VARCHAR(128),
    ADD COLUMN ld_borrower_job_3_position VARCHAR(32),
    ADD COLUMN ld_borrower_job_3_employer_phone VARCHAR(32),
    ADD COLUMN ld_borrower_job_3_income_start_date VARCHAR(32),
    ADD COLUMN ld_borrower_job_3_income_end_date VARCHAR(32),
    ADD COLUMN ld_borrower_job_3_gross_monthly_income VARCHAR(32),
    ADD COLUMN ld_borrower_job_3_bonus_monthly_income VARCHAR(32),
    ADD COLUMN ld_borrower_residency_basis_type VARCHAR(32),
    ADD COLUMN ld_borrower_residence_from_date VARCHAR(32),
    ADD COLUMN ld_borrower_residence_through_date VARCHAR(32);
