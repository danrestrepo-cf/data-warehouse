--
-- Main | EDW - Octane schemas from prod-release to uat (2021-08-27)
-- https://app.asana.com/0/0/1200862837386332
--

--staging_octane changes
ALTER TABLE staging_octane.loan_hedge
    ADD COLUMN lh_velocify_lead_id varchar(32),
    ADD COLUMN lh_collateral_tracking_number varchar(32);

--history_octane changes
ALTER TABLE history_octane.loan_hedge
    ADD COLUMN lh_velocify_lead_id varchar(32),
    ADD COLUMN lh_collateral_tracking_number varchar(32);
