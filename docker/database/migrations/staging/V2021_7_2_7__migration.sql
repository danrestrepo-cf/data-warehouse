--
-- Main | EDW - Octane schemas from prod-release to uat (2021-08-20)
-- https://app.asana.com/0/0/1200801318938944
--

-- staging_octane changes
CREATE TABLE staging_octane.qualified_mortgage_rule_version_type (
    code VARCHAR(128),
    value VARCHAR(1024),
    CONSTRAINT pk_qualified_mortgage_rule_version_type
        PRIMARY KEY (code)
);

ALTER TABLE staging_octane.loan
    ADD COLUMN l_qualified_mortgage_rule_version_type VARCHAR(128),
    ADD COLUMN l_qualified_mortgage_apr NUMERIC(11, 9),
    ADD COLUMN l_qualified_mortgage_max_allowed_rate_spread NUMERIC(11, 9);

DROP TABLE IF EXISTS staging_octane.old_du_key_finding;
DROP TABLE IF EXISTS staging_octane.old_du_refi_plus_finding;
DROP TABLE IF EXISTS staging_octane.du_key_finding_type;

-- history_octane changes
CREATE TABLE history_octane.qualified_mortgage_rule_version_type (
    code VARCHAR(128),
    value VARCHAR(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN
);

CREATE INDEX idx_c19ea4872a807643d8f47700e006cd56 ON history_octane.qualified_mortgage_rule_version_type (data_source_updated_datetime);

CREATE INDEX idx_40cfdb8ddc5b71d4c9ab0f7b4545400b ON history_octane.qualified_mortgage_rule_version_type (data_source_deleted_flag);

ALTER TABLE history_octane.loan
    ADD COLUMN l_qualified_mortgage_rule_version_type VARCHAR(128),
    ADD COLUMN l_qualified_mortgage_apr NUMERIC(11, 9),
    ADD COLUMN l_qualified_mortgage_max_allowed_rate_spread NUMERIC(11, 9);

CREATE INDEX fkt_l_qualified_mortgage_rule_version_type ON history_octane.loan (l_qualified_mortgage_rule_version_type);
