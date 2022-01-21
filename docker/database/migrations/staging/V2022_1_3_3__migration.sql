--
-- Main | EDW - Octane schemas from prod-release to uat (2022-01-21)
-- https://app.asana.com/0/0/1201686423062444
--

--staging_octane changes
CREATE TABLE staging_octane.lender_user_suspend_reason_type (
    code VARCHAR(128),
    value VARCHAR(1024),
    CONSTRAINT pk_lender_user_suspend_reason_type
        PRIMARY KEY (code)
);

ALTER TABLE staging_octane.lender_user
    ADD COLUMN lu_suspended BOOLEAN,
    ADD COLUMN lu_lender_user_suspend_reason_type VARCHAR(128),
    ADD COLUMN lu_suspend_reason_other_description VARCHAR(1024),
    ADD COLUMN lu_suspend_date_time TIMESTAMP;

ALTER TABLE staging_octane.ledger_entry
    ADD COLUMN le_smart_adjustment BOOLEAN,
    ALTER COLUMN le_synthetic_unique SET DATA TYPE VARCHAR(128);

ALTER TABLE staging_octane.smart_ledger_plan_case_version
    DROP COLUMN slpcv_smart_ledger_plan_case_type;

ALTER TABLE staging_octane.smart_ledger_plan_case_group
    ADD COLUMN slpcg_smart_ledger_plan_case_group_type VARCHAR(128);

CREATE TABLE staging_octane.smart_ledger_plan_case_measure_type (
    code VARCHAR(128),
    value VARCHAR(1024),
    CONSTRAINT pk_smart_ledger_plan_case_measure_type
        PRIMARY KEY (code)
);

CREATE TABLE staging_octane.smart_ledger_plan_case_measure_source_date_type (
    code VARCHAR(128),
    value VARCHAR(1024),
    CONSTRAINT pk_smart_ledger_plan_case_measure_source_date_type
        PRIMARY KEY (code)
);

CREATE TABLE staging_octane.smart_ledger_plan_case_population_period_type (
    code VARCHAR(128),
    value VARCHAR(1024),
    CONSTRAINT pk_smart_ledger_plan_case_population_period_type
        PRIMARY KEY (code)
);

ALTER TABLE staging_octane.smart_ledger_plan_case_version
    ADD COLUMN slpcv_smart_ledger_plan_case_measure_type VARCHAR(128),
    ADD COLUMN slpcv_smart_ledger_plan_case_measure_source_date_type VARCHAR(128),
    ADD COLUMN slpcv_smart_ledger_plan_case_population_period_type VARCHAR(128),
    ADD COLUMN slpcv_measure_criteria_from_date DATE,
    ADD COLUMN slpcv_measure_criteria_through_date DATE;

ALTER TABLE staging_octane.smart_ledger_plan_case_type
    RENAME TO smart_ledger_plan_case_group_type;

--history_octane changes
CREATE TABLE history_octane.lender_user_suspend_reason_type (
    code VARCHAR(128),
    value VARCHAR(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN,
    etl_batch_id TEXT
);

CREATE INDEX idx_lender_user_suspend_reason_type__code ON history_octane.lender_user_suspend_reason_type (code);

CREATE INDEX idx_f8df8ef1f9d8a2bb1d61d35f358b5b9a ON history_octane.lender_user_suspend_reason_type (data_source_updated_datetime);

CREATE INDEX idx_lender_user_suspend_reason_type__data_source_deleted_flag ON history_octane.lender_user_suspend_reason_type (data_source_deleted_flag);

CREATE INDEX idx_lender_user_suspend_reason_type__etl_batch_id ON history_octane.lender_user_suspend_reason_type (etl_batch_id);

ALTER TABLE history_octane.lender_user
    ADD COLUMN lu_suspended BOOLEAN,
    ADD COLUMN lu_lender_user_suspend_reason_type VARCHAR(128),
    ADD COLUMN lu_suspend_reason_other_description VARCHAR(1024),
    ADD COLUMN lu_suspend_date_time TIMESTAMP;

CREATE INDEX fkt_lu_lender_user_suspend_reason_type ON history_octane.lender_user (lu_lender_user_suspend_reason_type);

ALTER TABLE history_octane.ledger_entry
    ADD COLUMN le_smart_adjustment BOOLEAN,
    ALTER COLUMN le_synthetic_unique SET DATA TYPE VARCHAR(128);

ALTER TABLE history_octane.smart_ledger_plan_case_group
    ADD COLUMN slpcg_smart_ledger_plan_case_group_type VARCHAR(128);

CREATE INDEX fkt_slpcg_smart_ledger_plan_case_group_type ON history_octane.smart_ledger_plan_case_group (slpcg_smart_ledger_plan_case_group_type);

CREATE TABLE history_octane.smart_ledger_plan_case_measure_type (
    code VARCHAR(128),
    value VARCHAR(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN,
    etl_batch_id TEXT
);

CREATE INDEX idx_smart_ledger_plan_case_measure_type__code ON history_octane.smart_ledger_plan_case_measure_type (code);

CREATE INDEX idx_abae268c2cafe00e9f87d8b098c0342e ON history_octane.smart_ledger_plan_case_measure_type (data_source_updated_datetime);

CREATE INDEX idx_9cd28fed2dee56e423d76e74ebfb7d49 ON history_octane.smart_ledger_plan_case_measure_type (data_source_deleted_flag);

CREATE INDEX idx_smart_ledger_plan_case_measure_type__etl_batch_id ON history_octane.smart_ledger_plan_case_measure_type (etl_batch_id);

CREATE TABLE history_octane.smart_ledger_plan_case_measure_source_date_type (
    code VARCHAR(128),
    value VARCHAR(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN,
    etl_batch_id TEXT
);

CREATE INDEX idx_smart_ledger_plan_case_measure_source_date_type__code ON history_octane.smart_ledger_plan_case_measure_source_date_type (code);

CREATE INDEX idx_d50a767e0f2a7d6fae394bdcfd0f9176 ON history_octane.smart_ledger_plan_case_measure_source_date_type (data_source_updated_datetime);

CREATE INDEX idx_49962802201d56ed19459307584b9262 ON history_octane.smart_ledger_plan_case_measure_source_date_type (data_source_deleted_flag);

CREATE INDEX idx_70595dc98941ccf0307cfe96f4af41b5 ON history_octane.smart_ledger_plan_case_measure_source_date_type (etl_batch_id);

CREATE TABLE history_octane.smart_ledger_plan_case_population_period_type (
    code VARCHAR(128),
    value VARCHAR(1024),
    data_source_updated_datetime timestamptz,
    data_source_deleted_flag BOOLEAN,
    etl_batch_id TEXT
);

CREATE INDEX idx_smart_ledger_plan_case_population_period_type__code ON history_octane.smart_ledger_plan_case_population_period_type (code);

CREATE INDEX idx_2f8cecd6987e4bc28c6d84414e431996 ON history_octane.smart_ledger_plan_case_population_period_type (data_source_updated_datetime);

CREATE INDEX idx_7c86d54bb049340913a0831b9bbdfe07 ON history_octane.smart_ledger_plan_case_population_period_type (data_source_deleted_flag);

CREATE INDEX idx_smart_ledger_plan_case_population_period_type__etl_batch_id ON history_octane.smart_ledger_plan_case_population_period_type (etl_batch_id);

ALTER TABLE history_octane.smart_ledger_plan_case_version
    ADD COLUMN slpcv_smart_ledger_plan_case_measure_type VARCHAR(128),
    ADD COLUMN slpcv_smart_ledger_plan_case_measure_source_date_type VARCHAR(128),
    ADD COLUMN slpcv_smart_ledger_plan_case_population_period_type VARCHAR(128),
    ADD COLUMN slpcv_measure_criteria_from_date DATE,
    ADD COLUMN slpcv_measure_criteria_through_date DATE;

CREATE INDEX fkt_slpcv_smart_ledger_plan_case_measure_type ON history_octane.smart_ledger_plan_case_version (slpcv_smart_ledger_plan_case_measure_type);

CREATE INDEX fkt_slpcv_smart_ledger_plan_case_measure_source_date_type ON history_octane.smart_ledger_plan_case_version (slpcv_smart_ledger_plan_case_measure_source_date_type);

CREATE INDEX fkt_slpcv_smart_ledger_plan_case_population_period_type ON history_octane.smart_ledger_plan_case_version (slpcv_smart_ledger_plan_case_population_period_type);

ALTER TABLE history_octane.smart_ledger_plan_case_type
    RENAME TO smart_ledger_plan_case_group_type;
