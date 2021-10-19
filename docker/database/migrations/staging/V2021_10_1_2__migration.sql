--
-- Main | EDW - Octane schemas from prod-release to v2021.10.2.1 on uat
-- https://app.asana.com/0/0/1201176006424816
--

-- staging_octane changes
ALTER TABLE staging_octane.loan_hedge
    ALTER COLUMN lh_lender_concession_remaining_amount SET DATA TYPE numeric(15,2);

ALTER TABLE staging_octane.loan_hedge
    RENAME COLUMN lh_lender_concession_remaining_amount TO lh_general_lender_concessions_amount_non_itemized;

--history_octane changes
ALTER TABLE history_octane.loan_hedge
    ALTER COLUMN lh_lender_concession_remaining_amount SET DATA TYPE numeric(15,2);

ALTER TABLE history_octane.loan_hedge
    RENAME COLUMN lh_lender_concession_remaining_amount TO lh_general_lender_concessions_amount_non_itemized;
