--
-- Main | EDW - Octane schemas from prod-release to v2021.9.2.0 on uat
-- https://app.asana.com/0/0/1200944665668886
--

-- staging_octane changes
ALTER TABLE staging_octane.borrower
    ADD COLUMN b_snapshotted_pid bigint;

-- history_octane changes
ALTER TABLE history_octane.borrower
    ADD COLUMN b_snapshotted_pid bigint;
