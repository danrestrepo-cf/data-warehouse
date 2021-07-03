--
-- EDW - Octane schemas from prod-release to uat 2021.6.4.6
-- https://app.asana.com/0/0/1200534000334560
--

CREATE INDEX idx_account_event_3 ON history_octane.account_event (ae_event_date);
