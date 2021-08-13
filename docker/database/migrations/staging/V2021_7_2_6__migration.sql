--
-- Main | EDW - Octane schemas from prod-release to uat (2021-08-13)
-- https://app.asana.com/0/0/1200761821493609
--

--staging_octane changes
ALTER TABLE staging_octane.asset
    ADD COLUMN as_earnest_money_deposit_is_gift varchar(128);

--history_octane changes
ALTER TABLE history_octane.asset
    ADD COLUMN as_earnest_money_deposit_is_gift varchar(128);

CREATE INDEX fkt_as_earnest_money_deposit_is_gift ON history_octane.asset (as_earnest_money_deposit_is_gift);
