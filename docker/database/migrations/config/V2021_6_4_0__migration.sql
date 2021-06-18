--
-- EDW | State machine creator - Allow multiple processes to be triggered from the same 'previous' process (parallel)
-- https://app.asana.com/0/0/1200341798516191
--

--going forward, we will only store processes in state_machine_step that *have* a next process
DELETE
FROM mdi.state_machine_step
WHERE state_machine_step.next_process_dwid IS NULL;

--add new metadata column and initial data for Terraform's scheduling configuration
ALTER TABLE mdi.state_machine_definition
    ADD COLUMN cron_schedule TEXT;

UPDATE mdi.state_machine_definition
SET cron_schedule = '0/15 * * * ? *'
WHERE cron_schedule IS NULL;
