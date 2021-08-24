--
-- Main | EDW - Octane schemas from prod-release to uat (2021-08-24)
-- https://app.asana.com/0/0/1200849287203214
--

--staging_octane changes
ALTER TABLE staging_octane.proposal
    ADD COLUMN prp_down_payment_percent numeric(11,9);

--history_octane changes
ALTER TABLE history_octane.proposal
    ADD COLUMN prp_down_payment_percent numeric(11,9);
