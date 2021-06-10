--
-- EDW - Step Function Pipelines | terraform does not accept spaces in names generated from mdi.state_machine_definition.name (https://app.asana.com/0/0/1200453484886085 )
--

UPDATE mdi.state_machine_definition SET name = REPLACE(name, ' ', '__');
