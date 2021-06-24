--
-- EDW | Deployment - fix ""name" cannot be longer than 64 characters" error
-- https://app.asana.com/0/0/1200517388794529
--

UPDATE mdi.state_machine_definition
SET name = process.name
FROM mdi.process
WHERE state_machine_definition.process_dwid = process.dwid;
