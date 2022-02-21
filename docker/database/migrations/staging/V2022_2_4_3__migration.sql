--
-- Main | EDW - Octane schemas from prod-release to v2022.2.3.3-release
-- https://app.asana.com/0/0/1201862456976010
--

--staging_octane
ALTER TABLE staging_octane.deal
    ADD COLUMN d_ecoa_application_date date,
    ADD COLUMN d_ecoa_decision_due_date date;

ALTER TABLE staging_octane.deal RENAME COLUMN d_disclosure_mode_date TO d_trid_application_date;

ALTER TABLE staging_octane.mcr_loan RENAME COLUMN mcrl_disclosure_mode_date TO mcrl_trid_application_date;

--history_octane
ALTER TABLE history_octane.deal
    ADD COLUMN d_ecoa_application_date date,
    ADD COLUMN d_ecoa_decision_due_date date;

ALTER TABLE history_octane.deal RENAME COLUMN d_disclosure_mode_date TO d_trid_application_date;

ALTER TABLE history_octane.mcr_loan RENAME COLUMN mcrl_disclosure_mode_date TO mcrl_trid_application_date;
