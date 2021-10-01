--
-- EDW | star_loan table metadata shows key fields as updatable
-- https://app.asana.com/0/0/1200753845956817
--

UPDATE mdi.insert_update_field
    SET update_flag = 'N'
    WHERE dwid IN (
        SELECT insert_update_field.dwid
        FROM mdi.insert_update_step
                 JOIN mdi.insert_update_key ON insert_update_step.dwid = insert_update_key.insert_update_step_dwid
                 JOIN mdi.insert_update_field ON insert_update_step.dwid = insert_update_field.insert_update_step_dwid
            AND insert_update_key.key_lookup = insert_update_field.update_lookup
            AND insert_update_field.update_flag = 'Y'
        );
