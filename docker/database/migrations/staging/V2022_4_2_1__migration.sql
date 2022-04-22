--
-- Main | EDW | Octane schema synchronization for v2022.4.4.1 (2022-04-22)
-- https://app.asana.com/0/0/1202154363221915
--

/*
 MANUALLY-WRITTEN MIGRATIONS
 */

 ALTER TABLE star_loan.loan_fact
     RENAME COLUMN preapproval_uw_submit_date_dwid TO preapproval_complete_date_dwid;

ALTER TABLE star_loan.transaction_dim
    RENAME COLUMN preapproval_uw_submit_datetime TO preapproval_complete_datetime;

ALTER TABLE star_loan.transaction_dim
    RENAME COLUMN preapproval_uw_disposition_datetime TO preapproval_disposition_datetime;


/*
 AUTO-GENERATED DDL MIGRATIONS
 */

/*
staging_octane
*/

-- Octane 2022.4.4.0
ALTER TABLE staging_octane.wf_step
    ADD COLUMN ws_trustee_pid BIGINT;

-- Octane 2022.4.4.1
ALTER TABLE staging_octane.deal
    ADD COLUMN d_notice_of_missing_documentation_date DATE,
    ADD COLUMN d_notice_of_missing_documentation_due_date DATE;

-- Octane 2022.4.4.2

ALTER TABLE staging_octane.proposal
    RENAME COLUMN prp_preapproval_uw_submit_datetime TO prp_preapproval_complete_datetime;

ALTER TABLE staging_octane.proposal
    RENAME COLUMN prp_preapproval_uw_disposition_datetime TO prp_preapproval_disposition_datetime;

ALTER TABLE staging_octane.deal
    ADD COLUMN d_preapproval_received_date DATE,
    ADD COLUMN d_preapproval_decision_due_date DATE;

/*
history_octane
 */

-- Octane 2022.4.4.0
ALTER TABLE history_octane.wf_step
    ADD COLUMN ws_trustee_pid BIGINT;

CREATE INDEX fk_wf_step_8 ON history_octane.wf_step (ws_trustee_pid);

-- Octane 2022.4.4.1
ALTER TABLE history_octane.deal
    ADD COLUMN d_notice_of_missing_documentation_date DATE,
    ADD COLUMN d_notice_of_missing_documentation_due_date DATE;

-- Octane 2022.4.4.2
ALTER TABLE history_octane.proposal
    RENAME COLUMN prp_preapproval_uw_submit_datetime TO prp_preapproval_complete_datetime;

ALTER TABLE history_octane.proposal
    RENAME COLUMN prp_preapproval_uw_disposition_datetime TO prp_preapproval_disposition_datetime;

ALTER TABLE history_octane.deal
    ADD COLUMN d_preapproval_received_date DATE,
    ADD COLUMN d_preapproval_decision_due_date DATE;
