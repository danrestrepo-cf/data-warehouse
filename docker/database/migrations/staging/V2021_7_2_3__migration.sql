--
-- EDW - Octane schemas from prod-release to uat (2021-07-23)
-- https://app.asana.com/0/0/1200643028011805/
--

-- staging_octane changes
ALTER TABLE staging_octane.borrower
    ADD COLUMN b_closing_disclosure_signer boolean;

-- history_octane changes
ALTER TABLE history_octane.borrower
    ADD COLUMN b_closing_disclosure_signer boolean;
