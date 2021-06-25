--
-- EDW | DDL changes - Octane Schema changes for 2021.6.4.0 (6/25/21)
-- https://app.asana.com/0/0/1200504745087506
--

-- staging_octane changes
ALTER TABLE staging_octane.smart_ledger_plan_case
    ADD COLUMN slpc_ordinal INTEGER;

ALTER TABLE staging_octane.ledger_entry
    ADD COLUMN le_synthetic_unique VARCHAR(32);

ALTER TABLE staging_octane.wf_step
    ALTER COLUMN ws_step_number_name_formatted SET DATA TYPE VARCHAR(145);

ALTER TABLE staging_octane.wf_deal_step
    ALTER COLUMN wds_step_number_name_formatted SET DATA TYPE VARCHAR(145);

ALTER TABLE staging_octane.view_wf_deal_step_started
    ALTER COLUMN wds_step_number_name_formatted SET DATA TYPE VARCHAR(145);

ALTER TABLE staging_octane.org_node
    ADD COLUMN on_amb_codes VARCHAR(256);

ALTER TABLE staging_octane.account_event
    ADD COLUMN ae_event_date DATE;

ALTER TABLE staging_octane.account_event
    ALTER COLUMN ae_event_date SET DATA TYPE DATE;

-- history_octane changes
ALTER TABLE history_octane.smart_ledger_plan_case
    ADD COLUMN slpc_ordinal INTEGER;

ALTER TABLE history_octane.ledger_entry
    ADD COLUMN le_synthetic_unique VARCHAR(32);

ALTER TABLE history_octane.wf_step
    ALTER COLUMN ws_step_number_name_formatted SET DATA TYPE VARCHAR(145);

ALTER TABLE history_octane.wf_deal_step
    ALTER COLUMN wds_step_number_name_formatted SET DATA TYPE VARCHAR(145);

ALTER TABLE history_octane.view_wf_deal_step_started
    ALTER COLUMN wds_step_number_name_formatted SET DATA TYPE VARCHAR(145);

ALTER TABLE history_octane.org_node
    ADD COLUMN on_amb_codes VARCHAR(256);

ALTER TABLE history_octane.account_event
    ADD COLUMN ae_event_date DATE;

ALTER TABLE history_octane.account_event
    ALTER COLUMN ae_event_date SET DATA TYPE DATE;
