--
-- EDW | star_loan schema: Add indexes to tables' key lookup fields
-- https://app.asana.com/0/0/1200975391827399
--

DELETE FROM mdi.insert_update_key
WHERE dwid = (
    SELECT insert_update_key.dwid
    FROM mdi.insert_update_step
             JOIN mdi.insert_update_key ON insert_update_step.dwid = insert_update_key.insert_update_step_dwid
        AND insert_update_key.key_lookup = 'data_source_dwid'
    WHERE insert_update_step.table_name = 'loan_fact'
);

UPDATE mdi.insert_update_key
SET key_lookup = 'data_source_integration_id'
  , key_stream1 = 'data_source_integration_id'
WHERE dwid = (
    SELECT insert_update_key.dwid
    FROM mdi.insert_update_step
             JOIN mdi.insert_update_key ON insert_update_step.dwid = insert_update_key.insert_update_step_dwid
        AND insert_update_key.key_lookup = 'loan_pid'
    WHERE insert_update_step.table_name = 'loan_fact'
);
