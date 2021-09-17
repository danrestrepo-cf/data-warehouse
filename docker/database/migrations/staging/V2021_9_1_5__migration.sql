--
-- Main | EDW - Octane schemas from prod-release to v2021.9.3.2 on uat
-- https://app.asana.com/0/0/1200992742622198
--

-- staging_octane changes
ALTER TABLE staging_octane.proposal_construction
    ADD COLUMN prpc_estimated_permit_amount_applicable boolean;

ALTER TABLE staging_octane.smart_doc
    DROP COLUMN sd_doc_validity_type,
    DROP COLUMN sd_expiration_rule_type,
    DROP COLUMN sd_days_before_key_date,
    DROP COLUMN sd_warning_days,
    DROP COLUMN sd_doc_key_date_type;

ALTER TABLE staging_octane.proposal_doc
    DROP COLUMN prpd_valid_from_date,
    DROP COLUMN prpd_valid_through_date,
    DROP COLUMN prpd_key_date;

ALTER TABLE staging_octane.asset
    ADD COLUMN as_deposit_date date,
    ADD COLUMN as_gift_funds_ein varchar(16);

CREATE TABLE staging_octane.deal_note_category_type (
    code varchar(128),
    value varchar(1024),
    constraint pk_deal_note_category_type primary key (code)
);

CREATE TABLE staging_octane.doc_status_type (
    code varchar(128),
    value varchar(1024),
    constraint pk_doc_status_type primary key (code)
);

ALTER TABLE staging_octane.deal_note
    ALTER COLUMN dn_author_lender_user_pid SET DATA TYPE bigint,
    ADD COLUMN dn_category_type varchar(128);

CREATE TABLE staging_octane.proposal_doc_new (
    prpd_pid bigint,
    prpd_version integer,
    constraint pk_proposal_doc_new primary key (prpd_pid),
    prpd_doc_name varchar(767),
    prpd_doc_number numeric(15,3),
    prpd_borrower_access boolean,
    prpd_deal_child_type varchar(128),
    prpd_deal_child_name varchar(767),
    prpd_deal_pid bigint,
    prpd_proposal_pid bigint,
    prpd_loan_pid bigint,
    prpd_borrower_pid bigint,
    prpd_borrower_income_pid bigint,
    prpd_job_income_pid bigint,
    prpd_borrower_job_gap_pid bigint,
    prpd_other_income_pid bigint,
    prpd_business_income_pid bigint,
    prpd_rental_income_pid bigint,
    prpd_asset_pid bigint,
    prpd_asset_large_deposit_pid bigint,
    prpd_liability_pid bigint,
    prpd_reo_place_pid bigint,
    prpd_property_place_pid bigint,
    prpd_residence_place_pid bigint,
    prpd_borrower_residence_pid bigint,
    prpd_application_pid bigint,
    prpd_credit_inquiry_pid bigint,
    prpd_appraisal_pid bigint,
    prpd_appraisal_form_pid bigint,
    prpd_tax_transcript_request_pid bigint,
    prpd_trash boolean,
    prpd_smart_doc_pid bigint,
    prpd_proposal_doc_set_pid bigint,
    prpd_doc_fulfill_status_type varchar(128),
    prpd_status_unparsed_name varchar(128),
    prpd_status_datetime timestamp,
    prpd_status_reason varchar(1024),
    prpd_doc_excluded boolean,
    prpd_doc_excluded_reason varchar(1024),
    prpd_doc_excluded_unparsed_name varchar(128),
    prpd_doc_excluded_datetime timestamp,
    prpd_doc_approval_type varchar(128),
    prpd_borrower_edit boolean,
    prpd_borrower_associated_address_pid bigint,
    prpd_construction_cost_pid bigint,
    prpd_construction_draw_pid bigint,
    prpd_proposal_contractor_pid bigint,
    prpd_doc_provider_group_type varchar(128),
    prpd_doc_req_fulfill_status_type varchar(128),
    prpd_doc_req_decision_status_type varchar(128),
    prpd_doc_status_type varchar(128)
);

CREATE INDEX idx_proposal_doc_new__pid_version
    ON staging_octane.proposal_doc_new (prpd_pid, prpd_version);

-- history_octane changes
ALTER TABLE history_octane.proposal_construction
    ADD COLUMN prpc_estimated_permit_amount_applicable boolean;

ALTER TABLE history_octane.asset
    ADD COLUMN as_deposit_date date,
    ADD COLUMN as_gift_funds_ein varchar(16);

CREATE TABLE history_octane.deal_note_category_type (
    code varchar(128),
    value varchar(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_deal_note_category_type__data_source_updated_datetime
    ON history_octane.deal_note_category_type (data_source_updated_datetime);

CREATE INDEX idx_deal_note_category_type__data_source_deleted_flag
    ON history_octane.deal_note_category_type (data_source_deleted_flag);

CREATE TABLE history_octane.doc_status_type (
    code varchar(128),
    value varchar(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_doc_status_type__data_source_updated_datetime
    ON history_octane.doc_status_type (data_source_updated_datetime);

CREATE INDEX idx_doc_status_type__data_source_deleted_flag
    ON history_octane.doc_status_type (data_source_deleted_flag);

ALTER TABLE history_octane.deal_note
    ALTER COLUMN dn_author_lender_user_pid SET DATA TYPE bigint,
    ADD COLUMN dn_category_type varchar(128);

CREATE INDEX fkt_dn_category_type
    ON history_octane.deal_note (dn_category_type);

CREATE TABLE history_octane.proposal_doc_new (
    prpd_pid bigint,
    prpd_version integer,
    prpd_doc_name varchar(767),
    prpd_doc_number numeric(15,3),
    prpd_borrower_access boolean,
    prpd_deal_child_type varchar(128),
    prpd_deal_child_name varchar(767),
    prpd_deal_pid bigint,
    prpd_proposal_pid bigint,
    prpd_loan_pid bigint,
    prpd_borrower_pid bigint,
    prpd_borrower_income_pid bigint,
    prpd_job_income_pid bigint,
    prpd_borrower_job_gap_pid bigint,
    prpd_other_income_pid bigint,
    prpd_business_income_pid bigint,
    prpd_rental_income_pid bigint,
    prpd_asset_pid bigint,
    prpd_asset_large_deposit_pid bigint,
    prpd_liability_pid bigint,
    prpd_reo_place_pid bigint,
    prpd_property_place_pid bigint,
    prpd_residence_place_pid bigint,
    prpd_borrower_residence_pid bigint,
    prpd_application_pid bigint,
    prpd_credit_inquiry_pid bigint,
    prpd_appraisal_pid bigint,
    prpd_appraisal_form_pid bigint,
    prpd_tax_transcript_request_pid bigint,
    prpd_trash boolean,
    prpd_smart_doc_pid bigint,
    prpd_proposal_doc_set_pid bigint,
    prpd_doc_fulfill_status_type varchar(128),
    prpd_status_unparsed_name varchar(128),
    prpd_status_datetime timestamp,
    prpd_status_reason varchar(1024),
    prpd_doc_excluded boolean,
    prpd_doc_excluded_reason varchar(1024),
    prpd_doc_excluded_unparsed_name varchar(128),
    prpd_doc_excluded_datetime timestamp,
    prpd_doc_approval_type varchar(128),
    prpd_borrower_edit boolean,
    prpd_borrower_associated_address_pid bigint,
    prpd_construction_cost_pid bigint,
    prpd_construction_draw_pid bigint,
    prpd_proposal_contractor_pid bigint,
    prpd_doc_provider_group_type varchar(128),
    prpd_doc_req_fulfill_status_type varchar(128),
    prpd_doc_req_decision_status_type varchar(128),
    prpd_doc_status_type varchar(128),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_proposal_doc_new__pid
    ON history_octane.proposal_doc_new (prpd_pid);

CREATE INDEX idx_proposal_doc_new__data_source_updated_datetime
    ON history_octane.proposal_doc_new (data_source_updated_datetime);

CREATE INDEX idx_proposal_doc_new__data_source_deleted_flag
    ON history_octane.proposal_doc_new (data_source_deleted_flag);

CREATE INDEX idx_proposal_doc_new__pid_version
    ON history_octane.proposal_doc_new (prpd_pid, prpd_version);

CREATE INDEX fk_proposal_doc_new_1
    ON history_octane.proposal_doc_new (prpd_deal_pid);

CREATE INDEX fk_proposal_doc_new_2
    ON history_octane.proposal_doc_new (prpd_proposal_pid);

CREATE INDEX fk_proposal_doc_new_3
    ON history_octane.proposal_doc_new (prpd_loan_pid);

CREATE INDEX fk_proposal_doc_new_4
    ON history_octane.proposal_doc_new (prpd_borrower_pid);

CREATE INDEX fk_proposal_doc_new_5
    ON history_octane.proposal_doc_new (prpd_borrower_income_pid);

CREATE INDEX fk_proposal_doc_new_6
    ON history_octane.proposal_doc_new (prpd_job_income_pid);

CREATE INDEX fk_proposal_doc_new_7
    ON history_octane.proposal_doc_new (prpd_borrower_job_gap_pid);

CREATE INDEX fk_proposal_doc_new_8
    ON history_octane.proposal_doc_new (prpd_other_income_pid);

CREATE INDEX fk_proposal_doc_new_9
    ON history_octane.proposal_doc_new (prpd_business_income_pid);

CREATE INDEX fk_proposal_doc_new_10
    ON history_octane.proposal_doc_new (prpd_rental_income_pid);

CREATE INDEX fk_proposal_doc_new_11
    ON history_octane.proposal_doc_new (prpd_asset_pid);

CREATE INDEX fk_proposal_doc_new_12
    ON history_octane.proposal_doc_new (prpd_asset_large_deposit_pid);

CREATE INDEX fk_proposal_doc_new_13
    ON history_octane.proposal_doc_new (prpd_liability_pid);

CREATE INDEX fk_proposal_doc_new_14
    ON history_octane.proposal_doc_new (prpd_reo_place_pid);

CREATE INDEX fk_proposal_doc_new_15
    ON history_octane.proposal_doc_new (prpd_property_place_pid);

CREATE INDEX fk_proposal_doc_new_16
    ON history_octane.proposal_doc_new (prpd_residence_place_pid);

CREATE INDEX fk_proposal_doc_new_17
    ON history_octane.proposal_doc_new (prpd_borrower_residence_pid);

CREATE INDEX fk_proposal_doc_new_18
    ON history_octane.proposal_doc_new (prpd_application_pid);

CREATE INDEX fk_proposal_doc_new_19
    ON history_octane.proposal_doc_new (prpd_credit_inquiry_pid);

CREATE INDEX fk_proposal_doc_new_20
    ON history_octane.proposal_doc_new (prpd_appraisal_pid);

CREATE INDEX fk_proposal_doc_new_21
    ON history_octane.proposal_doc_new (prpd_proposal_doc_set_pid);

CREATE INDEX fk_proposal_doc_new_22
    ON history_octane.proposal_doc_new (prpd_smart_doc_pid);

CREATE INDEX fk_proposal_doc_new_23
    ON history_octane.proposal_doc_new (prpd_appraisal_form_pid);

CREATE INDEX fk_proposal_doc_new_24
    ON history_octane.proposal_doc_new (prpd_tax_transcript_request_pid);

CREATE INDEX fk_proposal_doc_new_25
    ON history_octane.proposal_doc_new (prpd_borrower_associated_address_pid);

CREATE INDEX fk_proposal_doc_new_26
    ON history_octane.proposal_doc_new (prpd_construction_cost_pid);

CREATE INDEX fk_proposal_doc_new_27
    ON history_octane.proposal_doc_new (prpd_construction_draw_pid);

CREATE INDEX fk_proposal_doc_new_28
    ON history_octane.proposal_doc_new (prpd_proposal_contractor_pid);

CREATE INDEX fkt_prpd_deal_child_type
    ON history_octane.proposal_doc_new (prpd_deal_child_type);

CREATE INDEX fkt_prpd_doc_approval_type
    ON history_octane.proposal_doc_new (prpd_doc_approval_type);

CREATE INDEX fkt_prpd_doc_fulfill_status_type
    ON history_octane.proposal_doc_new (prpd_doc_fulfill_status_type);

CREATE INDEX fkt_prpd_doc_provider_group_type
    ON history_octane.proposal_doc_new (prpd_doc_provider_group_type);

CREATE INDEX fkt_prpd_doc_req_decision_status_type
    ON history_octane.proposal_doc_new (prpd_doc_req_decision_status_type);

CREATE INDEX fkt_prpd_doc_req_fulfill_status_type
    ON history_octane.proposal_doc_new (prpd_doc_req_fulfill_status_type);

CREATE INDEX fkt_prpd_doc_status_type
    ON history_octane.proposal_doc_new (prpd_doc_status_type);

CREATE INDEX fk_proposal_doc_validity_1
    ON history_octane.proposal_doc_validity (prpdv_proposal_doc_pid);

CREATE INDEX fk_deal_note_4
    ON history_octane.deal_note (dn_proposal_doc_pid);

CREATE INDEX fk_proposal_doc_borrower_access_2
    ON history_octane.proposal_doc_borrower_access (pdba_proposal_doc_pid);

CREATE INDEX fk_proposal_doc_file_1
    ON history_octane.proposal_doc_file (prpdf_proposal_doc_pid);

CREATE INDEX fk_proposal_req_1
    ON history_octane.proposal_req (prpr_proposal_doc_pid);
