--
-- EDW | Update lambda to allow only one running ETL per target table at a time
-- https://app.asana.com/0/0/1201354667788164
--

-- mdi.process
UPDATE mdi.process
    SET name = 'SP-200001-insert'
    WHERE name = 'SP-200001';

UPDATE mdi.process
    SET name = 'SP-200001-delete'
    WHERE name = 'SP-200002';

UPDATE mdi.process
    SET name = 'SP-300001-insert-update'
    WHERE name = 'SP-300001';

UPDATE mdi.process
    SET name = 'SP-300001-delete'
    WHERE name = 'SP-300002';

-- mdi.state_machine_definition
UPDATE mdi.state_machine_definition
    SET name = 'SP-200001-insert'
    WHERE name = 'SP-200001';

UPDATE mdi.state_machine_definition
    SET name = 'SP-200001-delete'
    WHERE name = 'SP-200002';

UPDATE mdi.state_machine_definition
    SET name = 'SP-300001-insert-update'
    WHERE name = 'SP-300001';

UPDATE mdi.state_machine_definition
    SET name = 'SP-300001-delete'
    WHERE name = 'SP-300002';
