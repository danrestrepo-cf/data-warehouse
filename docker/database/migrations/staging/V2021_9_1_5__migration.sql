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
    ADD COLUMN prpd_doc_status_type varchar(128);

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

ALTER TABLE history_octane.proposal_doc
    ADD COLUMN prpd_doc_status_type varchar(128);

CREATE INDEX fkt_prpd_doc_status_type
    ON history_octane.proposal_doc (prpd_doc_status_type);

CREATE INDEX fk_deal_note_4
    ON history_octane.deal_note (dn_proposal_doc_pid);

CREATE INDEX fk_proposal_doc_borrower_access_2
    ON history_octane.proposal_doc_borrower_access (pdba_proposal_doc_pid);

CREATE INDEX fk_proposal_doc_file_1
    ON history_octane.proposal_doc_file (prpdf_proposal_doc_pid);

CREATE INDEX fk_proposal_req_1
    ON history_octane.proposal_req (prpr_proposal_doc_pid);
