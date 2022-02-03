--
-- EDW | star_loan: Remove column lender_user_dim.work_step_start_notices_enabled_flag
-- https://app.asana.com/0/0/1201753612968906
--

ALTER TABLE star_loan.lender_user_dim
    DROP COLUMN work_step_start_notices_enabled_flag;

--
-- Main | EDW | Octane schemas from prod-release to v2022.2.1.0 on uat
-- https://app.asana.com/0/0/1201745462160447
--

-- staging_octane
CREATE TABLE staging_octane.qm_rate_spread_thresholds (
qmrst_pid bigint,
qmrst_version integer,
constraint pk_qm_rate_spread_thresholds primary key (qmrst_pid),
qmrst_effective_date date,
qmrst_first_lien_manufactured_loan_amount_threshold numeric(15,0),
qmrst_first_lien_manufactured_max_rate_spread_over_threshold numeric(11,9),
qmrst_first_lien_manufactured_max_rate_spread_under_threshold numeric(11,9),
qmrst_first_lien_high_loan_amount_threshold numeric(15,0),
qmrst_first_lien_low_loan_amount_threshold numeric(15,0),
qmrst_first_lien_max_rate_spread_over_high_threshold numeric(11,9),
qmrst_first_lien_max_rate_spread_under_high_over_low_threshold numeric(11,9),
qmrst_first_lien_max_rate_spread_under_low_threshold numeric(11,9),
qmrst_subordinate_lien_loan_amount_threshold numeric(15,0),
qmrst_subordinate_lien_max_rate_spread_over_threshold numeric(11,9),
qmrst_subordinate_lien_max_rate_spread_under_threshold numeric(11,9)
);

CREATE INDEX idx_qm_rate_spread_thresholds__pid_version ON staging_octane.qm_rate_spread_thresholds (qmrst_pid, qmrst_version);

ALTER TABLE staging_octane.qualified_mortgage_thresholds RENAME TO qm_points_and_fees_thresholds;

ALTER TABLE staging_octane.qm_points_and_fees_thresholds
ALTER COLUMN qmt_pid SET DATA TYPE bigint,
ALTER COLUMN qmt_version SET DATA TYPE integer,
ALTER COLUMN qmt_effective_date SET DATA TYPE date,
ALTER COLUMN qmt_first_total_loan_amount_threshold SET DATA TYPE numeric(15,0),
ALTER COLUMN qmt_first_points_and_fees_threshold_percent SET DATA TYPE numeric(11,9),
ALTER COLUMN qmt_second_total_loan_amount_threshold SET DATA TYPE numeric(15,0),
ALTER COLUMN qmt_second_points_and_fees_threshold_amount SET DATA TYPE numeric(15,0),
ALTER COLUMN qmt_third_total_loan_amount_threshold SET DATA TYPE numeric(15,0),
ALTER COLUMN qmt_third_points_and_fees_threshold_percent SET DATA TYPE numeric(11,9),
ALTER COLUMN qmt_fourth_total_loan_amount_threshold SET DATA TYPE numeric(15,0),
ALTER COLUMN qmt_fourth_points_and_fees_threshold_amount SET DATA TYPE numeric(15,0),
ALTER COLUMN qmt_ceiling_points_and_fees_threshold_percent SET DATA TYPE numeric(11,9);

ALTER TABLE staging_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_pid TO qmpaft_pid;

ALTER TABLE staging_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_version TO qmpaft_version;

ALTER TABLE staging_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_effective_date TO qmpaft_effective_date;

ALTER TABLE staging_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_first_total_loan_amount_threshold TO qmpaft_first_total_loan_amount_threshold;

ALTER TABLE staging_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_first_points_and_fees_threshold_percent TO qmpaft_first_points_and_fees_threshold_percent;

ALTER TABLE staging_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_second_total_loan_amount_threshold TO qmpaft_second_total_loan_amount_threshold;

ALTER TABLE staging_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_second_points_and_fees_threshold_amount TO qmpaft_second_points_and_fees_threshold_amount;

ALTER TABLE staging_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_third_total_loan_amount_threshold TO qmpaft_third_total_loan_amount_threshold;

ALTER TABLE staging_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_third_points_and_fees_threshold_percent TO qmpaft_third_points_and_fees_threshold_percent;

ALTER TABLE staging_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_fourth_total_loan_amount_threshold TO qmpaft_fourth_total_loan_amount_threshold;

ALTER TABLE staging_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_fourth_points_and_fees_threshold_amount TO qmpaft_fourth_points_and_fees_threshold_amount;

ALTER TABLE staging_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_ceiling_points_and_fees_threshold_percent TO qmpaft_ceiling_points_and_fees_threshold_percent;

ALTER TABLE staging_octane.lender_user
DROP COLUMN lu_work_step_start_notices_enabled;

ALTER TABLE staging_octane.smart_doc
ADD COLUMN sd_document_explanation varchar(1024),
ADD COLUMN sd_document_explanation_reference varchar(2048);


-- history_octane
CREATE TABLE history_octane.qm_rate_spread_thresholds (
qmrst_pid bigint,
qmrst_version integer,
qmrst_effective_date date,
qmrst_first_lien_manufactured_loan_amount_threshold numeric(15,0),
qmrst_first_lien_manufactured_max_rate_spread_over_threshold numeric(11,9),
qmrst_first_lien_manufactured_max_rate_spread_under_threshold numeric(11,9),
qmrst_first_lien_high_loan_amount_threshold numeric(15,0),
qmrst_first_lien_low_loan_amount_threshold numeric(15,0),
qmrst_first_lien_max_rate_spread_over_high_threshold numeric(11,9),
qmrst_first_lien_max_rate_spread_under_high_over_low_threshold numeric(11,9),
qmrst_first_lien_max_rate_spread_under_low_threshold numeric(11,9),
qmrst_subordinate_lien_loan_amount_threshold numeric(15,0),
qmrst_subordinate_lien_max_rate_spread_over_threshold numeric(11,9),
qmrst_subordinate_lien_max_rate_spread_under_threshold numeric(11,9),
data_source_updated_datetime timestamptz,
data_source_deleted_flag boolean,
etl_batch_id TEXT
);

CREATE INDEX idx_qm_rate_spread_thresholds__pid ON history_octane.qm_rate_spread_thresholds (qmrst_pid);

CREATE INDEX idx_qm_rate_spread_thresholds__data_source_updated_datetime ON history_octane.qm_rate_spread_thresholds (data_source_updated_datetime);

CREATE INDEX idx_qm_rate_spread_thresholds__data_source_deleted_flag ON history_octane.qm_rate_spread_thresholds (data_source_deleted_flag);

CREATE INDEX idx_qm_rate_spread_thresholds__pid_version ON history_octane.qm_rate_spread_thresholds (qmrst_pid, qmrst_version);

CREATE INDEX idx_qm_rate_spread_thresholds__etl_batch_id ON history_octane.qm_rate_spread_thresholds (etl_batch_id);

ALTER TABLE history_octane.qualified_mortgage_thresholds RENAME TO qm_points_and_fees_thresholds;

ALTER TABLE history_octane.qm_points_and_fees_thresholds
ALTER COLUMN qmt_pid SET DATA TYPE bigint,
ALTER COLUMN qmt_version SET DATA TYPE integer,
ALTER COLUMN qmt_effective_date SET DATA TYPE date,
ALTER COLUMN qmt_first_total_loan_amount_threshold SET DATA TYPE numeric(15,0),
ALTER COLUMN qmt_first_points_and_fees_threshold_percent SET DATA TYPE numeric(11,9),
ALTER COLUMN qmt_second_total_loan_amount_threshold SET DATA TYPE numeric(15,0),
ALTER COLUMN qmt_second_points_and_fees_threshold_amount SET DATA TYPE numeric(15,0),
ALTER COLUMN qmt_third_total_loan_amount_threshold SET DATA TYPE numeric(15,0),
ALTER COLUMN qmt_third_points_and_fees_threshold_percent SET DATA TYPE numeric(11,9),
ALTER COLUMN qmt_fourth_total_loan_amount_threshold SET DATA TYPE numeric(15,0),
ALTER COLUMN qmt_fourth_points_and_fees_threshold_amount SET DATA TYPE numeric(15,0),
ALTER COLUMN qmt_ceiling_points_and_fees_threshold_percent SET DATA TYPE numeric(11,9);

ALTER TABLE history_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_pid TO qmpaft_pid;

ALTER TABLE history_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_version TO qmpaft_version;

ALTER TABLE history_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_effective_date TO qmpaft_effective_date;

ALTER TABLE history_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_first_total_loan_amount_threshold TO qmpaft_first_total_loan_amount_threshold;

ALTER TABLE history_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_first_points_and_fees_threshold_percent TO qmpaft_first_points_and_fees_threshold_percent;

ALTER TABLE history_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_second_total_loan_amount_threshold TO qmpaft_second_total_loan_amount_threshold;

ALTER TABLE history_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_second_points_and_fees_threshold_amount TO qmpaft_second_points_and_fees_threshold_amount;

ALTER TABLE history_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_third_total_loan_amount_threshold TO qmpaft_third_total_loan_amount_threshold;

ALTER TABLE history_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_third_points_and_fees_threshold_percent TO qmpaft_third_points_and_fees_threshold_percent;

ALTER TABLE history_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_fourth_total_loan_amount_threshold TO qmpaft_fourth_total_loan_amount_threshold;

ALTER TABLE history_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_fourth_points_and_fees_threshold_amount TO qmpaft_fourth_points_and_fees_threshold_amount;

ALTER TABLE history_octane.qm_points_and_fees_thresholds RENAME COLUMN qmt_ceiling_points_and_fees_threshold_percent TO qmpaft_ceiling_points_and_fees_threshold_percent;

ALTER TABLE history_octane.smart_doc
ADD COLUMN sd_document_explanation varchar(1024),
ADD COLUMN sd_document_explanation_reference varchar(2048);
