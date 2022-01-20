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
