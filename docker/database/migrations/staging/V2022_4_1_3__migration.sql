--
-- Main | EDW | Octane schema synchronization for v2022.4.2.2 (2022-04-12)
-- https://app.asana.com/0/0/1202118188346928
--

--staging_octane
ALTER TABLE staging_octane.deal
    ADD COLUMN d_ecoa_application_received_date DATE;

ALTER TABLE staging_octane.deal
    RENAME COLUMN d_ecoa_application_date TO d_ecoa_application_complete_date;

ALTER TABLE staging_octane.borrower
    ADD COLUMN b_oldest_credit_report_received_date DATE;

--history_octane
ALTER TABLE history_octane.deal
    ADD COLUMN d_ecoa_application_received_date DATE;

ALTER TABLE history_octane.deal
    RENAME COLUMN d_ecoa_application_date TO d_ecoa_application_complete_date;

ALTER TABLE history_octane.borrower
    ADD COLUMN b_oldest_credit_report_received_date DATE;
