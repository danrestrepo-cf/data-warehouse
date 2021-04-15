--
-- EDW - Octane 2021.4.3.0 schema changes (releases 4/16/2021)
-- (https://app.asana.com/0/0/1200183349597739/)
--

-- staging_octane:
ALTER TABLE staging_octane.borrower_user_deal
    DROP COLUMN bud_loan_key,
    ADD COLUMN bud_uuid varchar(36);

ALTER TABLE staging_octane.place
    ALTER COLUMN pl_property_tax_id SET DATA TYPE varchar(64),
    ALTER COLUMN pl_legal_lot SET DATA TYPE varchar(64),
    ALTER COLUMN pl_legal_block SET DATA TYPE varchar(64),
    ALTER COLUMN pl_legal_section SET DATA TYPE varchar(64);

ALTER TABLE staging_octane.deal_settlement
    ALTER COLUMN dsmt_title_insurance_underwriter_company_name SET DATA TYPE varchar(256),
    ALTER COLUMN dsmt_title_insurance_attorney_license_number SET DATA TYPE varchar(64),
    ALTER COLUMN dsmt_settlement_agent_escrow_id SET DATA TYPE varchar(64);

ALTER TABLE staging_octane.new_lock_only_add_on
    ADD COLUMN nlo_add_on_description varchar(256);

ALTER TABLE staging_octane.product_interest_only
    ADD COLUMN pio_balloon_payment bit;

CREATE TABLE staging_octane.construction_permit_type (
                                                         code varchar(128),
                                                         value varchar(1024),
                                                         constraint pk_construction_permit_type primary key (code)
);

CREATE TABLE staging_octane.construction_permit_requested_by_type (
                                                                      code varchar(128),
                                                                      value varchar(1024),
                                                                      constraint pk_construction_permit_requested_by_type primary key (code)
);

CREATE TABLE staging_octane.construction_permit (
                                                    cop_pid bigint,
                                                    cop_version integer,
                                                    constraint pk_construction_permit primary key (cop_pid),
                                                    cop_proposal_pid bigint,
                                                    cop_construction_permit_type varchar(128),
                                                    cop_construction_permit_type_other_description varchar(64),
                                                    cop_permit_number varchar(32),
                                                    cop_construction_permit_requested_by_type varchar(128),
                                                    cop_issued_by varchar(128),
                                                    cop_application_date date,
                                                    cop_issued_date date,
                                                    cop_expiration_date date,
                                                    cop_closed_out_date date,
                                                    cop_amount decimal(17,2),
                                                    cop_building_department_name varchar(64),
                                                    cop_building_department_contact_url varchar(256),
                                                    cop_first_name varchar(32),
                                                    cop_last_name varchar(32),
                                                    cop_email varchar(256),
                                                    cop_mobile_phone varchar(32),
                                                    cop_office_phone varchar(32),
                                                    cop_office_phone_extension varchar(16),
                                                    cop_fax varchar(32),
                                                    cop_address_street1 varchar(128),
                                                    cop_address_street2 varchar(128),
                                                    cop_address_city varchar(128),
                                                    cop_address_state varchar(128),
                                                    cop_address_postal_code varchar(128)
);

CREATE INDEX idx_construction_permit__pid_version ON staging_octane.construction_permit (cop_pid, cop_version);

-- history_octane:
ALTER TABLE history_octane.borrower_user_deal
    ADD COLUMN bud_uuid varchar(36);

ALTER TABLE history_octane.place
    ALTER COLUMN pl_property_tax_id SET DATA TYPE varchar(64),
    ALTER COLUMN pl_legal_lot SET DATA TYPE varchar(64),
    ALTER COLUMN pl_legal_block SET DATA TYPE varchar(64),
    ALTER COLUMN pl_legal_section SET DATA TYPE varchar(64);

ALTER TABLE history_octane.deal_settlement
    ALTER COLUMN dsmt_title_insurance_underwriter_company_name SET DATA TYPE varchar(256),
    ALTER COLUMN dsmt_title_insurance_attorney_license_number SET DATA TYPE varchar(64),
    ALTER COLUMN dsmt_settlement_agent_escrow_id SET DATA TYPE varchar(64);

ALTER TABLE history_octane.new_lock_only_add_on
    ADD COLUMN nlo_add_on_description varchar(256);

ALTER TABLE history_octane.product_interest_only
    ADD COLUMN pio_balloon_payment bit;

CREATE TABLE history_octane.construction_permit_type (
                                                         code varchar(128),
                                                         value varchar(1024),
                                                         data_source_updated_datetime timestamptz,
                                                         data_source_deleted_flag boolean
);

CREATE INDEX idx_construction_permit_type__data_source_updated_datetime ON history_octane.construction_permit_type (data_source_updated_datetime);

CREATE INDEX idx_construction_permit_type__data_source_deleted_flag ON history_octane.construction_permit_type (data_source_deleted_flag);

CREATE TABLE history_octane.construction_permit_requested_by_type (
                                                                      code varchar(128),
                                                                      value varchar(1024),
                                                                      data_source_updated_datetime timestamptz,
                                                                      data_source_deleted_flag boolean
);

CREATE INDEX idx_195162628b2979ff2c4f20ee9ca2d6a6 ON history_octane.construction_permit_requested_by_type (data_source_updated_datetime);

CREATE INDEX idx_f4ef876f53d12c1c1b11a232de67c93f ON history_octane.construction_permit_requested_by_type (data_source_deleted_flag);

CREATE TABLE history_octane.construction_permit (
                                                    cop_pid bigint,
                                                    cop_version integer,
                                                    cop_proposal_pid bigint,
                                                    cop_construction_permit_type varchar(128),
                                                    cop_construction_permit_type_other_description varchar(64),
                                                    cop_permit_number varchar(32),
                                                    cop_construction_permit_requested_by_type varchar(128),
                                                    cop_issued_by varchar(128),
                                                    cop_application_date date,
                                                    cop_issued_date date,
                                                    cop_expiration_date date,
                                                    cop_closed_out_date date,
                                                    cop_amount decimal(17,2),
                                                    cop_building_department_name varchar(64),
                                                    cop_building_department_contact_url varchar(256),
                                                    cop_first_name varchar(32),
                                                    cop_last_name varchar(32),
                                                    cop_email varchar(256),
                                                    cop_mobile_phone varchar(32),
                                                    cop_office_phone varchar(32),
                                                    cop_office_phone_extension varchar(16),
                                                    cop_fax varchar(32),
                                                    cop_address_street1 varchar(128),
                                                    cop_address_street2 varchar(128),
                                                    cop_address_city varchar(128),
                                                    cop_address_state varchar(128),
                                                    cop_address_postal_code varchar(128),
                                                    data_source_updated_datetime timestamptz,
                                                    data_source_deleted_flag boolean
);

CREATE INDEX idx_construction_permit__pid ON history_octane.construction_permit (cop_pid);

CREATE INDEX idx_construction_permit__data_source_updated_datetime ON history_octane.construction_permit (data_source_updated_datetime);

CREATE INDEX idx_construction_permit__data_source_deleted_flag ON history_octane.construction_permit (data_source_deleted_flag);

CREATE INDEX idx_construction_permit__pid_version ON history_octane.construction_permit (cop_pid, cop_version);

CREATE INDEX fk_construction_permit_1 ON history_octane.construction_permit (cop_proposal_pid);

CREATE INDEX fkt_cop_construction_permit_type ON history_octane.construction_permit (cop_construction_permit_type);

CREATE INDEX fkt_cop_construction_permit_requested_by_type ON history_octane.construction_permit (cop_construction_permit_requested_by_type);
