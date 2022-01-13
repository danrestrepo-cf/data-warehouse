--
-- Main | EDW - Octane schemas from prod-release to uat (2022-01-14)
-- https://app.asana.com/0/0/1201641184457748
--

--staging_octane changes
ALTER TABLE staging_octane.proposal_doc
    ADD COLUMN prpd_prior_to_type VARCHAR(128),
    ADD COLUMN prpd_prior_to_type_unparsed_name VARCHAR(128),
    ADD COLUMN prpd_prior_to_type_datetime TIMESTAMP,
    ADD COLUMN prpd_smart_doc_prior_to_type_case_pid BIGINT,
    ADD COLUMN prpd_smart_doc_prior_to_type_case_criteria_html VARCHAR(16000),
    ADD COLUMN prpd_provider_type_unparsed_name VARCHAR(128),
    ADD COLUMN prpd_provider_type_datetime TIMESTAMP,
    ADD COLUMN prpd_smart_doc_provider_type_case_pid BIGINT,
    ADD COLUMN prpd_smart_doc_provider_type_case_criteria_html VARCHAR(16000);

ALTER TABLE staging_octane.lender_user_location
    RENAME COLUMN luloc_current_license_location TO luloc_current_licensed_location;

ALTER TABLE staging_octane.lender_user_location
    RENAME COLUMN luloc_synthetic_unique_current_license_location TO luloc_synthetic_unique_current_licensed_location;

ALTER TABLE staging_octane.deal
    RENAME COLUMN d_license_location_pid TO d_location_pid;

--history_octane changes
ALTER TABLE history_octane.proposal_doc
    ADD COLUMN prpd_prior_to_type VARCHAR(128),
    ADD COLUMN prpd_prior_to_type_unparsed_name VARCHAR(128),
    ADD COLUMN prpd_prior_to_type_datetime TIMESTAMP,
    ADD COLUMN prpd_smart_doc_prior_to_type_case_pid BIGINT,
    ADD COLUMN prpd_smart_doc_prior_to_type_case_criteria_html VARCHAR(16000),
    ADD COLUMN prpd_provider_type_unparsed_name VARCHAR(128),
    ADD COLUMN prpd_provider_type_datetime TIMESTAMP,
    ADD COLUMN prpd_smart_doc_provider_type_case_pid BIGINT,
    ADD COLUMN prpd_smart_doc_provider_type_case_criteria_html VARCHAR(16000)
;

CREATE INDEX fkt_prpd_prior_to_type ON history_octane.proposal_doc (prpd_prior_to_type);

ALTER TABLE history_octane.lender_user_location
    RENAME COLUMN luloc_current_license_location TO luloc_current_licensed_location;

ALTER TABLE history_octane.lender_user_location
    RENAME COLUMN luloc_synthetic_unique_current_license_location TO luloc_synthetic_unique_current_licensed_location;

ALTER TABLE history_octane.deal
    RENAME COLUMN d_license_location_pid TO d_location_pid;
