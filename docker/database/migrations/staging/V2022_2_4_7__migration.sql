--
-- Main | EDW | Octane schemas from prod-release to v2022.2.4.1 on uat
-- https://app.asana.com/0/0/1201869048849952
--

-- staging_octane
ALTER TABLE staging_octane.borrower
    ADD COLUMN b_mobile_phone_na boolean;

ALTER TABLE staging_octane.lender_concession_request
    RENAME COLUMN lcr_request_notes TO lcr_requested_reason_explanation;

ALTER TABLE staging_octane.lender_concession_request
    RENAME COLUMN lcr_decision_notes TO lcr_decision_explanation;

ALTER TABLE staging_octane.proposal_engagement
    ADD COLUMN prpe_lender_engagement_percent numeric(11,9);

-- history_octane
ALTER TABLE history_octane.borrower
    ADD COLUMN b_mobile_phone_na boolean;

ALTER TABLE history_octane.lender_concession_request
    RENAME COLUMN lcr_request_notes TO lcr_requested_reason_explanation;

ALTER TABLE history_octane.lender_concession_request
    RENAME COLUMN lcr_decision_notes TO lcr_decision_explanation;

ALTER TABLE history_octane.proposal_engagement
    ADD COLUMN prpe_lender_engagement_percent numeric(11,9);
