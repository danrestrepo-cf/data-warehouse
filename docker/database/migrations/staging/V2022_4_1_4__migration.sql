--
-- Main | EDW | Octane schema synchronization for v2022.4.3.2 (2022-04-15)
-- https://app.asana.com/0/0/1202112089121386
--

-- staging_octane
ALTER TABLE staging_octane.secondary_settings
	ADD COLUMN sset_high_balance_llpa_prefixes varchar(16000),
	ADD COLUMN sset_high_balance_llpa_filter_applicable_date date;

ALTER TABLE staging_octane.loan_hedge
	ADD COLUMN lh_total_income_to_ami_ratio numeric(14,9);

-- history_octane
ALTER TABLE history_octane.secondary_settings
	ADD COLUMN sset_high_balance_llpa_prefixes varchar(16000),
	ADD COLUMN sset_high_balance_llpa_filter_applicable_date date;

ALTER TABLE history_octane.loan_hedge
	ADD COLUMN lh_total_income_to_ami_ratio numeric(14,9);
