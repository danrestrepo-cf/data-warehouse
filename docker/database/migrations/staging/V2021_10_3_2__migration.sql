--
-- Main | EDW - Octane schemas from prod-release to v2021.11.1.0 on uat
-- https://app.asana.com/0/0/1201311226688064
--

--staging_octane changes

ALTER TABLE staging_octane.proposal
    ADD COLUMN prp_va_energy_efficient_improvements_amount NUMERIC(15, 2);

CREATE TABLE staging_octane.password_settings (
    pws_pid BIGINT,
    pws_version INTEGER,
    CONSTRAINT pk_password_settings
        PRIMARY KEY (pws_pid),
    pws_account_pid BIGINT,
    pws_lender_user_expire_days INTEGER,
    pws_lender_user_minimum_change_days INTEGER,
    pws_lender_user_previous_password_ban INTEGER,
    pws_minimum_length INTEGER,
    pws_require_special_character BOOLEAN,
    pws_require_uppercase_letter BOOLEAN,
    pws_require_lowercase_letter BOOLEAN,
    pws_require_digit BOOLEAN
);

CREATE INDEX idx_password_settings__pid_version ON staging_octane.password_settings (pws_pid, pws_version);

ALTER TABLE staging_octane.account
    DROP COLUMN a_lender_user_password_expire_days,
    DROP COLUMN a_lender_user_password_minimum_change_days,
    DROP COLUMN a_lender_user_previous_password_ban;

--history_octane changes

ALTER TABLE history_octane.proposal
    ADD COLUMN prp_va_energy_efficient_improvements_amount NUMERIC(15, 2);

CREATE TABLE history_octane.password_settings (
    pws_pid BIGINT,
    pws_version INTEGER,
    pws_account_pid BIGINT,
    pws_lender_user_expire_days INTEGER,
    pws_lender_user_minimum_change_days INTEGER,
    pws_lender_user_previous_password_ban INTEGER,
    pws_minimum_length INTEGER,
    pws_require_special_character BOOLEAN,
    pws_require_uppercase_letter BOOLEAN,
    pws_require_lowercase_letter BOOLEAN,
    pws_require_digit BOOLEAN,
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN
);

CREATE INDEX idx_password_settings__pid ON history_octane.password_settings (pws_pid);

CREATE INDEX idx_password_settings__data_source_updated_datetime ON history_octane.password_settings (data_source_updated_datetime);

CREATE INDEX idx_password_settings__data_source_deleted_flag ON history_octane.password_settings (data_source_deleted_flag);

CREATE INDEX idx_password_settings__pid_version ON history_octane.password_settings (pws_pid, pws_version);

CREATE INDEX fk_password_settings_1 ON history_octane.password_settings (pws_account_pid);
