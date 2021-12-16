--
-- MAIN | EDW - Octane schemas from prod-release to v2021.12.3.0 on uat  -  https://app.asana.com/0/0/1201508123725637
--

ALTER TABLE staging_octane.ledger_entry_import_loan_status 
ADD COLUMN leils_row_number integer;

CREATE TABLE staging_octane.branch_license_contact (
brlc_pid bigint,
brlc_version integer,
constraint pk_branch_license_contact primary key (brlc_pid),
brlc_lender_user_pid bigint,
brlc_branch_license_pid bigint,
brlc_from_date date,
brlc_through_date date
);

CREATE INDEX idx_branch_license_contact__pid_version ON staging_octane.branch_license_contact (brlc_pid, brlc_version);

ALTER TABLE staging_octane.proposal_construction 
ADD COLUMN prpc_extension_period_days integer;

ALTER TABLE staging_octane.wf_step 
ADD COLUMN ws_user_step_name varchar(128);

ALTER TABLE history_octane.ledger_entry_import_loan_status
ADD COLUMN leils_row_number integer;

CREATE TABLE history_octane.branch_license_contact (
brlc_pid bigint,
brlc_version integer,
brlc_lender_user_pid bigint,
brlc_branch_license_pid bigint,
brlc_from_date date,
brlc_through_date date,
data_source_updated_datetime timestamptz,
data_source_deleted_flag boolean,
etl_batch_id TEXT
);

CREATE INDEX idx_branch_license_contact__etl_batch_id ON history_octane.branch_license_contact (etl_batch_id);

CREATE INDEX idx_branch_license_contact__pid ON history_octane.branch_license_contact (brlc_pid);

CREATE INDEX idx_branch_license_contact__data_source_updated_datetime ON history_octane.branch_license_contact (data_source_updated_datetime);

CREATE INDEX idx_branch_license_contact__data_source_deleted_flag ON history_octane.branch_license_contact (data_source_deleted_flag);

CREATE INDEX idx_branch_license_contact__pid_version ON history_octane.branch_license_contact (brlc_pid, brlc_version);

CREATE INDEX fk_branch_license_contact_1 ON history_octane.branch_license_contact (brlc_lender_user_pid);

CREATE INDEX fk_branch_license_contact_2 ON history_octane.branch_license_contact (brlc_branch_license_pid);

ALTER TABLE history_octane.proposal_construction 
ADD COLUMN prpc_extension_period_days integer;

ALTER TABLE history_octane.wf_step 
ADD COLUMN ws_user_step_name varchar(128);

CREATE TABLE staging_octane.company_settings (
                                                 cs_pid bigint,
                                                 cs_version integer,
                                                 constraint pk_company_settings primary key (cs_pid),
                                                 cs_company_pid bigint,
                                                 cs_equifax_mortgage_services_internal_account_id varchar(256),
                                                 cs_factual_data_internal_account_id varchar(256),
                                                 cs_sharper_lending_internal_account_id varchar(256),
                                                 cs_va_lender_id varchar(16),
                                                 cs_usda_lender_id varchar(16),
                                                 cs_fha_sponsor_address_country varchar(128),
                                                 cs_fha_sponsor_id varchar(16),
                                                 cs_fha_sponsor_company_name varchar(32),
                                                 cs_fha_non_supervised_mortgagee boolean,
                                                 cs_fha_sponsor_address_city varchar(128),
                                                 cs_fha_lender_id varchar(16),
                                                 cs_fha_sponsor_address_street2 varchar(128),
                                                 cs_fha_sponsor_address_street1 varchar(128),
                                                 cs_fha_sponsor_address_state varchar(128),
                                                 cs_fha_home_office_location_pid bigint,
                                                 cs_fha_sponsor_address_postal_code varchar(128),
                                                 cs_fha_settings_present varchar(128),
                                                 cs_va_settings_present varchar(128),
                                                 cs_usda_settings_present varchar(128)
);

CREATE INDEX idx_company_settings__pid_version ON staging_octane.company_settings (cs_pid, cs_version);

ALTER TABLE staging_octane.lender_settings
    ADD COLUMN lss_equifax_submitting_party_name varchar(256),
    ADD COLUMN lss_factual_data_submitting_party_name varchar(256),
    ADD COLUMN lss_factual_data_submitting_party_id varchar(256),
    ADD COLUMN lss_meridian_link_submitting_party_id varchar(256),
    DROP COLUMN lss_va_lender_id,
    DROP COLUMN lss_usda_lender_id,
    DROP COLUMN lss_fha_sponsor_address_country,
    DROP COLUMN lss_fha_sponsor_id,
    DROP COLUMN lss_fha_sponsor_company_name,
    DROP COLUMN lss_fha_non_supervised_mortgagee,
    DROP COLUMN lss_fha_sponsor_address_city,
    DROP COLUMN lss_fha_lender_id,
    DROP COLUMN lss_fha_sponsor_address_street2,
    DROP COLUMN lss_fha_sponsor_address_street1,
    DROP COLUMN lss_fha_sponsor_address_state,
    DROP COLUMN lss_fha_home_office_location_pid,
    DROP COLUMN lss_fha_sponsor_address_postal_code;

CREATE TABLE history_octane.company_settings (
                                                 cs_pid bigint,
                                                 cs_version integer,
                                                 cs_company_pid bigint,
                                                 cs_equifax_mortgage_services_internal_account_id varchar(256),
                                                 cs_factual_data_internal_account_id varchar(256),
                                                 cs_sharper_lending_internal_account_id varchar(256),
                                                 cs_va_lender_id varchar(16),
                                                 cs_usda_lender_id varchar(16),
                                                 cs_fha_sponsor_address_country varchar(128),
                                                 cs_fha_sponsor_id varchar(16),
                                                 cs_fha_sponsor_company_name varchar(32),
                                                 cs_fha_non_supervised_mortgagee boolean,
                                                 cs_fha_sponsor_address_city varchar(128),
                                                 cs_fha_lender_id varchar(16),
                                                 cs_fha_sponsor_address_street2 varchar(128),
                                                 cs_fha_sponsor_address_street1 varchar(128),
                                                 cs_fha_sponsor_address_state varchar(128),
                                                 cs_fha_home_office_location_pid bigint,
                                                 cs_fha_sponsor_address_postal_code varchar(128),
                                                 cs_fha_settings_present varchar(128),
                                                 cs_va_settings_present varchar(128),
                                                 cs_usda_settings_present varchar(128),
                                                 data_source_updated_datetime timestamptz,
                                                 data_source_deleted_flag boolean,
                                                 etl_batch_id TEXT
);

CREATE INDEX idx_company_settings__pid ON history_octane.company_settings (cs_pid);

CREATE INDEX idx_company_settings__data_source_updated_datetime ON history_octane.company_settings (data_source_updated_datetime);

CREATE INDEX idx_company_settings__data_source_deleted_flag ON history_octane.company_settings (data_source_deleted_flag);

CREATE INDEX idx_company_settings__pid_version ON history_octane.company_settings (cs_pid, cs_version);

CREATE INDEX fk_company_settings_1 ON history_octane.company_settings (cs_company_pid);

CREATE INDEX fk_company_settings_2 ON history_octane.company_settings (cs_fha_home_office_location_pid);

CREATE INDEX fkt_cs_fha_sponsor_address_country ON history_octane.company_settings (cs_fha_sponsor_address_country);

CREATE INDEX fkt_cs_fha_settings_present ON history_octane.company_settings (cs_fha_settings_present);

CREATE INDEX fkt_cs_va_settings_present ON history_octane.company_settings (cs_va_settings_present);

CREATE INDEX fkt_cs_usda_settings_present ON history_octane.company_settings (cs_usda_settings_present);

ALTER TABLE history_octane.lender_settings
    ADD COLUMN lss_equifax_submitting_party_name varchar(256),
    ADD COLUMN lss_factual_data_submitting_party_name varchar(256),
    ADD COLUMN lss_factual_data_submitting_party_id varchar(256),
    ADD COLUMN lss_meridian_link_submitting_party_id varchar(256);

