--
-- EDW | Octane catch-up: Rename wf_wait_until_time_slice table
-- https://app.asana.com/0/0/1201003816146617
--

ALTER TABLE staging_octane.wf_wait_until_time_slice
    RENAME TO wf_polling_time_slice;

ALTER TABLE history_octane.wf_wait_until_time_slice
    RENAME TO wf_polling_time_slice;
