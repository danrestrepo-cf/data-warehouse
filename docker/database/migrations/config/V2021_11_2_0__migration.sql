--
-- EDW | SQS and lambda deduplication
-- https://app.asana.com/0/0/1201354667788164
--

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
