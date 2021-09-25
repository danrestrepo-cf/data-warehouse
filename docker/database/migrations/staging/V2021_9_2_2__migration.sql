--
-- Main | EDW - Octane schemas from prod-release to v2021.9.4.1 on uat
-- https://app.asana.com/0/0/1201028468419837
--

-- staging_octane changes
CREATE TABLE staging_octane.location_status_type (
    code varchar(128),
    value varchar(1024),
        constraint pk_location_status_type primary key (code)
);

CREATE TABLE staging_octane.location (
    loc_pid bigint,
    loc_version integer,
        constraint pk_location primary key (loc_pid),
    loc_account_pid bigint,
    loc_address_street1 varchar(128),
    loc_address_street2 varchar(128),
    loc_address_city varchar(128),
    loc_address_state varchar(128),
    loc_address_postal_code varchar(128),
    loc_location_name varchar(256),
    loc_location_id integer,
    loc_location_remote boolean,
    loc_location_status_type varchar(128),
    loc_fha_field_office_code varchar(8),
    loc_documents_url varchar(256)
);

CREATE INDEX idx_location__pid_version
    ON staging_octane.location (loc_pid, loc_version);

CREATE TABLE staging_octane.location_lease (
    locl_pid bigint,
    locl_version integer,
        constraint pk_location_lease primary key (locl_pid),
    locl_location_pid bigint,
    locl_from_date date,
    locl_through_date date,
    locl_monthly_lease_amount numeric(15,2),
    locl_cubicle_count integer,
    locl_office_count integer
);

CREATE INDEX idx_location_lease__pid_version
    ON staging_octane.location_lease (locl_pid, locl_version);

CREATE TABLE staging_octane.company_location_type (
    code varchar(128),
    value varchar(1024),
        constraint pk_company_location_type primary key (code)
);

CREATE TABLE staging_octane.company_location (
    cmloc_pid bigint,
    cmloc_version integer,
        constraint pk_company_location primary key (cmloc_pid),
    cmloc_company_pid bigint,
    cmloc_location_pid bigint,
    cmloc_from_date date,
    cmloc_through_date date,
    cmloc_company_location_type varchar(128),
    cmloc_nmls_id varchar(16),
    cmloc_fha_branch_id varchar(16),
    cmloc_fha_branch_id_qualified varchar(16),
    cmloc_office_phone varchar(32),
    cmloc_office_phone_extension varchar(16),
    cmloc_fax varchar(32)
);

CREATE INDEX idx_company_location__pid_version
    ON staging_octane.company_location (cmloc_pid, cmloc_version);

CREATE TABLE staging_octane.lender_user_location_type (
    code varchar(128),
    value varchar(1024),
        constraint pk_lender_user_location_type primary key (code)
);

CREATE TABLE staging_octane.workspace_type (
    code varchar(128),
    value varchar(1024),
        constraint pk_workspace_type primary key (code)
);

CREATE TABLE staging_octane.lender_user_location (
    luloc_pid bigint,
    luloc_version integer,
        constraint pk_lender_user_location primary key (luloc_pid),
    luloc_company_pid bigint,
    luloc_lender_user_pid bigint,
    luloc_location_pid bigint,
    luloc_from_date date,
    luloc_lender_user_location_type varchar(128),
    luloc_workspace_type varchar(128),
    luloc_workspace_code varchar(16)
);

CREATE INDEX idx_lender_user_location__pid_version
    ON staging_octane.lender_user_location (luloc_pid, luloc_version);

ALTER TABLE staging_octane.branch
    ADD COLUMN br_location_pid bigint;

ALTER TABLE staging_octane.branch_license
    ADD COLUMN brml_company_pid bigint,
    ADD COLUMN brml_location_pid bigint;

ALTER TABLE staging_octane.deal
    ADD COLUMN d_license_location_pid bigint;

CREATE TABLE staging_octane.location_id_ticker (
    loctk_pid bigint,
    loctk_version integer,
        constraint pk_location_id_ticker primary key (loctk_pid),
    loctk_account_pid bigint,
    loctk_next_location_id integer
);

CREATE INDEX idx_location_id_ticker__pid_version
    ON staging_octane.location_id_ticker (loctk_pid, loctk_version);

ALTER TABLE staging_octane.branch
    ALTER COLUMN br_fha_branch_id SET DATA TYPE varchar(16),
    ALTER COLUMN br_fha_branch_id_qualified SET DATA TYPE varchar(16),
    ALTER COLUMN br_fha_field_office_code SET DATA TYPE varchar(16),
    ALTER COLUMN br_nmls_branch_id SET DATA TYPE varchar(16),
    ALTER COLUMN br_address_street1 SET DATA TYPE varchar(128),
    ALTER COLUMN br_address_street2 SET DATA TYPE varchar(128),
    ALTER COLUMN br_address_city SET DATA TYPE varchar(128),
    ALTER COLUMN br_address_state SET DATA TYPE varchar(128),
    ALTER COLUMN br_address_postal_code SET DATA TYPE varchar(128),
    ALTER COLUMN br_address_country SET DATA TYPE varchar(128),
    ALTER COLUMN br_office_phone SET DATA TYPE varchar(32),
    ALTER COLUMN br_office_phone_extension SET DATA TYPE varchar(16),
    ALTER COLUMN br_fax SET DATA TYPE varchar(32);

ALTER TABLE staging_octane.branch_license
    ALTER COLUMN brml_branch_pid SET DATA TYPE bigint;

ALTER TABLE staging_octane.lender_user
    ALTER COLUMN lu_office_phone_use_branch SET DATA TYPE boolean,
    ALTER COLUMN lu_fax_use_branch SET DATA TYPE boolean,
    ALTER COLUMN lu_address_use_branch SET DATA TYPE boolean,
    ALTER COLUMN lu_company_name SET DATA TYPE varchar(128),
    ALTER COLUMN lu_street1 SET DATA TYPE varchar(128),
    ALTER COLUMN lu_street2 SET DATA TYPE varchar(128),
    ALTER COLUMN lu_city SET DATA TYPE varchar(128),
    ALTER COLUMN lu_state SET DATA TYPE varchar(128),
    ALTER COLUMN lu_country SET DATA TYPE varchar(128),
    ALTER COLUMN lu_postal_code SET DATA TYPE varchar(128);

ALTER TABLE staging_octane.company
    ALTER COLUMN cm_company_address_street1 SET DATA TYPE varchar(128),
    ALTER COLUMN cm_company_address_street2 SET DATA TYPE varchar(128),
    ALTER COLUMN cm_company_address_city SET DATA TYPE varchar(128),
    ALTER COLUMN cm_company_address_state SET DATA TYPE varchar(128),
    ALTER COLUMN cm_company_address_postal_code SET DATA TYPE varchar(128),
    ALTER COLUMN cm_company_address_country SET DATA TYPE varchar(128),
    ALTER COLUMN cm_company_phone SET DATA TYPE varchar(32);

ALTER TABLE staging_octane.borrower_declarations
    ADD COLUMN bdec_intend_to_occupy_more_than_14_days varchar(128);

ALTER TABLE staging_octane.proposal
    ADD COLUMN prp_cash_out_reason_investment_or_business_property boolean,
    ADD COLUMN prp_cash_out_reason_business_debt_or_debt_consolidation boolean,
    ADD COLUMN prp_non_business_cash_out_reason_acknowledged varchar(128);

ALTER TABLE staging_octane.loan_hedge
    ADD COLUMN lh_qualified_mortgage_status_type varchar(128);

CREATE TABLE staging_octane.location_note (
    locn_pid bigint,
    locn_version integer,
        constraint pk_location_note primary key (locn_pid),
    locn_location_pid bigint,
    locn_create_datetime timestamp,
    locn_content varchar(16000),
    locn_author_lender_user_pid bigint,
    locn_author_unparsed_name varchar(128)
);

CREATE INDEX idx_location_note__pid_version
    ON staging_octane.location_note (locn_pid, locn_version);

CREATE TABLE staging_octane.location_note_comment (
    locnc_pid bigint,
    locnc_version integer,
        constraint pk_location_note_comment primary key (locnc_pid),
    locnc_location_note_pid bigint,
    locnc_create_datetime timestamp,
    locnc_content varchar(16000),
    locnc_author_lender_user_pid bigint,
    locnc_author_unparsed_name varchar(128)
);

CREATE INDEX idx_location_note_comment__pid_version
    ON staging_octane.location_note_comment (locnc_pid, locnc_version);

CREATE TABLE staging_octane.location_note_monitor (
    locnm_pid bigint,
    locnm_version integer,
        constraint pk_location_note_monitor primary key (locnm_pid),
    locnm_location_note_pid bigint,
    locnm_lender_user_pid bigint
);

CREATE INDEX idx_location_note_monitor__pid_version
    ON staging_octane.location_note_monitor (locnm_pid, locnm_version);

-- history_octane changes
CREATE TABLE history_octane.location_status_type (
    code varchar(128),
    value varchar(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_location_status_type__data_source_updated_datetime
    ON history_octane.location_status_type (data_source_updated_datetime);

CREATE INDEX idx_location_status_type__data_source_deleted_flag
    ON history_octane.location_status_type (data_source_deleted_flag);

CREATE TABLE history_octane.location (
    loc_pid bigint,
    loc_version integer,
    loc_account_pid bigint,
    loc_address_street1 varchar(128),
    loc_address_street2 varchar(128),
    loc_address_city varchar(128),
    loc_address_state varchar(128),
    loc_address_postal_code varchar(128),
    loc_location_name varchar(256),
    loc_location_id integer,
    loc_location_remote boolean,
    loc_location_status_type varchar(128),
    loc_fha_field_office_code varchar(8),
    loc_documents_url varchar(256),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_location__pid
    ON history_octane.location (loc_pid);

CREATE INDEX idx_location__data_source_updated_datetime
    ON history_octane.location (data_source_updated_datetime);

CREATE INDEX idx_location__data_source_deleted_flag
    ON history_octane.location (data_source_deleted_flag);

CREATE INDEX idx_location__pid_version
    ON history_octane.location (loc_pid, loc_version);

CREATE INDEX fk_location_1
    ON history_octane.location (loc_account_pid);

CREATE INDEX fkt_loc_location_status_type
    ON history_octane.location (loc_location_status_type);

CREATE TABLE history_octane.location_lease (
    locl_pid bigint,
    locl_version integer,
    locl_location_pid bigint,
    locl_from_date date,
    locl_through_date date,
    locl_monthly_lease_amount numeric(15,2),
    locl_cubicle_count integer,
    locl_office_count integer,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_location_lease__pid
    ON history_octane.location_lease (locl_pid);

CREATE INDEX idx_location_lease__data_source_updated_datetime
    ON history_octane.location_lease (data_source_updated_datetime);

CREATE INDEX idx_location_lease__data_source_deleted_flag
    ON history_octane.location_lease (data_source_deleted_flag);

CREATE INDEX idx_location_lease__pid_version
    ON history_octane.location_lease (locl_pid, locl_version);

CREATE INDEX fk_location_lease_1
    ON history_octane.location_lease (locl_location_pid);

CREATE TABLE history_octane.company_location_type (
    code varchar(128),
    value varchar(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_company_location_type__data_source_updated_datetime
    ON history_octane.company_location_type (data_source_updated_datetime);

CREATE INDEX idx_company_location_type__data_source_deleted_flag
    ON history_octane.company_location_type (data_source_deleted_flag);

CREATE TABLE history_octane.company_location (
    cmloc_pid bigint,
    cmloc_version integer,
    cmloc_company_pid bigint,
    cmloc_location_pid bigint,
    cmloc_from_date date,
    cmloc_through_date date,
    cmloc_company_location_type varchar(128),
    cmloc_nmls_id varchar(16),
    cmloc_fha_branch_id varchar(16),
    cmloc_fha_branch_id_qualified varchar(16),
    cmloc_office_phone varchar(32),
    cmloc_office_phone_extension varchar(16),
    cmloc_fax varchar(32),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_company_location__pid
    ON history_octane.company_location (cmloc_pid);

CREATE INDEX idx_company_location__data_source_updated_datetime
    ON history_octane.company_location (data_source_updated_datetime);

CREATE INDEX idx_company_location__data_source_deleted_flag
    ON history_octane.company_location (data_source_deleted_flag);

CREATE INDEX idx_company_location__pid_version
    ON history_octane.company_location (cmloc_pid, cmloc_version);

CREATE INDEX fk_company_location_1
    ON history_octane.company_location (cmloc_company_pid);

CREATE INDEX fk_company_location_2
    ON history_octane.company_location (cmloc_location_pid);

CREATE INDEX fkt_cmloc_company_location_type
    ON history_octane.company_location (cmloc_company_location_type);

CREATE TABLE history_octane.lender_user_location_type (
    code varchar(128),
    value varchar(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_lender_user_location_type__data_source_updated_datetime
    ON history_octane.lender_user_location_type (data_source_updated_datetime);

CREATE INDEX idx_lender_user_location_type__data_source_deleted_flag
    ON history_octane.lender_user_location_type (data_source_deleted_flag);

CREATE TABLE history_octane.workspace_type (
    code varchar(128),
    value varchar(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_workspace_type__data_source_updated_datetime
    ON history_octane.workspace_type (data_source_updated_datetime);

CREATE INDEX idx_workspace_type__data_source_deleted_flag
    ON history_octane.workspace_type (data_source_deleted_flag);

CREATE TABLE history_octane.lender_user_location (
    luloc_pid bigint,
    luloc_version integer,
    luloc_company_pid bigint,
    luloc_lender_user_pid bigint,
    luloc_location_pid bigint,
    luloc_from_date date,
    luloc_lender_user_location_type varchar(128),
    luloc_workspace_type varchar(128),
    luloc_workspace_code varchar(16),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_lender_user_location__pid
    ON history_octane.lender_user_location (luloc_pid);

CREATE INDEX idx_lender_user_location__data_source_updated_datetime
    ON history_octane.lender_user_location (data_source_updated_datetime);

CREATE INDEX idx_lender_user_location__data_source_deleted_flag
    ON history_octane.lender_user_location (data_source_deleted_flag);

CREATE INDEX idx_lender_user_location__pid_version
    ON history_octane.lender_user_location (luloc_pid, luloc_version);

CREATE INDEX fk_lender_user_location_1
    ON history_octane.lender_user_location (luloc_company_pid);

CREATE INDEX fk_lender_user_location_2
    ON history_octane.lender_user_location (luloc_lender_user_pid);

CREATE INDEX fk_lender_user_location_3
    ON history_octane.lender_user_location (luloc_location_pid);

CREATE INDEX fkt_luloc_lender_user_location_type
    ON history_octane.lender_user_location (luloc_lender_user_location_type);

CREATE INDEX fkt_luloc_workspace_type
    ON history_octane.lender_user_location (luloc_workspace_type);

ALTER TABLE history_octane.branch
    ADD COLUMN br_location_pid bigint;

CREATE INDEX fk_branch_2
    ON history_octane.branch (br_location_pid);

ALTER TABLE history_octane.branch_license
    ADD COLUMN brml_company_pid bigint,
    ADD COLUMN brml_location_pid bigint;

CREATE INDEX fk_branch_license_2
    ON history_octane.branch_license (brml_company_pid);

CREATE INDEX fk_branch_license_3
    ON history_octane.branch_license (brml_location_pid);

ALTER TABLE history_octane.deal
    ADD COLUMN d_license_location_pid bigint;

CREATE INDEX fk_deal_3
    ON history_octane.deal (d_license_location_pid);

CREATE TABLE history_octane.location_id_ticker (
    loctk_pid bigint,
    loctk_version integer,
    loctk_account_pid bigint,
    loctk_next_location_id integer,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_location_id_ticker__pid
    ON history_octane.location_id_ticker (loctk_pid);

CREATE INDEX idx_location_id_ticker__data_source_updated_datetime
    ON history_octane.location_id_ticker (data_source_updated_datetime);

CREATE INDEX idx_location_id_ticker__data_source_deleted_flag
    ON history_octane.location_id_ticker (data_source_deleted_flag);

CREATE INDEX idx_location_id_ticker__pid_version
    ON history_octane.location_id_ticker (loctk_pid, loctk_version);

CREATE INDEX fk_location_id_ticker_1
    ON history_octane.location_id_ticker (loctk_account_pid);

ALTER TABLE history_octane.branch
    ALTER COLUMN br_fha_branch_id SET DATA TYPE varchar(16),
    ALTER COLUMN br_fha_branch_id_qualified SET DATA TYPE varchar(16),
    ALTER COLUMN br_fha_field_office_code SET DATA TYPE varchar(16),
    ALTER COLUMN br_nmls_branch_id SET DATA TYPE varchar(16),
    ALTER COLUMN br_address_street1 SET DATA TYPE varchar(128),
    ALTER COLUMN br_address_street2 SET DATA TYPE varchar(128),
    ALTER COLUMN br_address_city SET DATA TYPE varchar(128),
    ALTER COLUMN br_address_state SET DATA TYPE varchar(128),
    ALTER COLUMN br_address_postal_code SET DATA TYPE varchar(128),
    ALTER COLUMN br_address_country SET DATA TYPE varchar(128),
    ALTER COLUMN br_office_phone SET DATA TYPE varchar(32),
    ALTER COLUMN br_office_phone_extension SET DATA TYPE varchar(16),
    ALTER COLUMN br_fax SET DATA TYPE varchar(32);

ALTER TABLE history_octane.branch_license
    ALTER COLUMN brml_branch_pid SET DATA TYPE bigint;

ALTER TABLE history_octane.lender_user
    ALTER COLUMN lu_office_phone_use_branch SET DATA TYPE boolean,
    ALTER COLUMN lu_fax_use_branch SET DATA TYPE boolean,
    ALTER COLUMN lu_address_use_branch SET DATA TYPE boolean,
    ALTER COLUMN lu_company_name SET DATA TYPE varchar(128),
    ALTER COLUMN lu_street1 SET DATA TYPE varchar(128),
    ALTER COLUMN lu_street2 SET DATA TYPE varchar(128),
    ALTER COLUMN lu_city SET DATA TYPE varchar(128),
    ALTER COLUMN lu_state SET DATA TYPE varchar(128),
    ALTER COLUMN lu_country SET DATA TYPE varchar(128),
    ALTER COLUMN lu_postal_code SET DATA TYPE varchar(128);

ALTER TABLE history_octane.company
    ALTER COLUMN cm_company_address_street1 SET DATA TYPE varchar(128),
    ALTER COLUMN cm_company_address_street2 SET DATA TYPE varchar(128),
    ALTER COLUMN cm_company_address_city SET DATA TYPE varchar(128),
    ALTER COLUMN cm_company_address_state SET DATA TYPE varchar(128),
    ALTER COLUMN cm_company_address_postal_code SET DATA TYPE varchar(128),
    ALTER COLUMN cm_company_address_country SET DATA TYPE varchar(128),
    ALTER COLUMN cm_company_phone SET DATA TYPE varchar(32);

ALTER TABLE history_octane.borrower_declarations
    ADD COLUMN bdec_intend_to_occupy_more_than_14_days varchar(128);

CREATE INDEX fkt_bdec_intend_to_occupy_more_than_14_days
    ON history_octane.borrower_declarations (bdec_intend_to_occupy_more_than_14_days);

ALTER TABLE history_octane.proposal
    ADD COLUMN prp_cash_out_reason_investment_or_business_property boolean,
    ADD COLUMN prp_cash_out_reason_business_debt_or_debt_consolidation boolean,
    ADD COLUMN prp_non_business_cash_out_reason_acknowledged varchar(128);

CREATE INDEX fkt_prp_non_business_cash_out_reason_acknowledged
    ON history_octane.proposal (prp_non_business_cash_out_reason_acknowledged);

ALTER TABLE history_octane.loan_hedge
    ADD COLUMN lh_qualified_mortgage_status_type varchar(128);

CREATE TABLE history_octane.location_note (
    locn_pid bigint,
    locn_version integer,
    locn_location_pid bigint,
    locn_create_datetime timestamp,
    locn_content varchar(16000),
    locn_author_lender_user_pid bigint,
    locn_author_unparsed_name varchar(128),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_location_note__pid
    ON history_octane.location_note (locn_pid);

CREATE INDEX idx_location_note__data_source_updated_datetime
    ON history_octane.location_note (data_source_updated_datetime);

CREATE INDEX idx_location_note__data_source_deleted_flag
    ON history_octane.location_note (data_source_deleted_flag);

CREATE INDEX idx_location_note__pid_version
    ON history_octane.location_note (locn_pid, locn_version);

CREATE INDEX fk_location_note_1
    ON history_octane.location_note (locn_location_pid);

CREATE INDEX fk_location_note_2
    ON history_octane.location_note (locn_author_lender_user_pid);

CREATE TABLE history_octane.location_note_comment (
    locnc_pid bigint,
    locnc_version integer,
    locnc_location_note_pid bigint,
    locnc_create_datetime timestamp,
    locnc_content varchar(16000),
    locnc_author_lender_user_pid bigint,
    locnc_author_unparsed_name varchar(128),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_location_note_comment__pid
    ON history_octane.location_note_comment (locnc_pid);

CREATE INDEX idx_location_note_comment__data_source_updated_datetime
    ON history_octane.location_note_comment (data_source_updated_datetime);

CREATE INDEX idx_location_note_comment__data_source_deleted_flag
    ON history_octane.location_note_comment (data_source_deleted_flag);

CREATE INDEX idx_location_note_comment__pid_version
    ON history_octane.location_note_comment (locnc_pid, locnc_version);

CREATE INDEX fk_location_note_comment_1
    ON history_octane.location_note_comment (locnc_location_note_pid);

CREATE INDEX fk_location_note_comment_2
    ON history_octane.location_note_comment (locnc_author_lender_user_pid);

CREATE TABLE history_octane.location_note_monitor (
    locnm_pid bigint,
    locnm_version integer,
    locnm_location_note_pid bigint,
    locnm_lender_user_pid bigint,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag boolean
);

CREATE INDEX idx_location_note_monitor__pid
    ON history_octane.location_note_monitor (locnm_pid);

CREATE INDEX idx_location_note_monitor__data_source_updated_datetime
    ON history_octane.location_note_monitor (data_source_updated_datetime);

CREATE INDEX idx_location_note_monitor__data_source_deleted_flag
    ON history_octane.location_note_monitor (data_source_deleted_flag);

CREATE INDEX idx_location_note_monitor__pid_version
    ON history_octane.location_note_monitor (locnm_pid, locnm_version);

CREATE INDEX fk_location_note_monitor_1
    ON history_octane.location_note_monitor (locnm_location_note_pid);

CREATE INDEX fk_location_note_monitor_2
    ON history_octane.location_note_monitor (locnm_lender_user_pid);
