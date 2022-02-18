--
-- Main | EDW | Octane schemas from prod-release to v2022.2.3.1 on uat
-- https://app.asana.com/0/0/1201819172972254
--

-- staging_octane
ALTER TABLE staging_octane.lp_finding RENAME COLUMN lpf_finding_yes_no_unknown_type TO lpf_finding_result;

-- history_octane
ALTER TABLE history_octane.lp_finding RENAME COLUMN lpf_finding_yes_no_unknown_type TO lpf_finding_result;
