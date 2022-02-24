--
-- EDW | ensure SP-200001 (loan_lender_user_access) ETLs are triggered as part of the nightly ETL cycle
-- https://app.asana.com/0/0/1201878754398244
--

/*
INSERTIONS
*/

--state_machine_step
WITH insert_rows (process_name, next_process_name) AS (
    VALUES ('SP-100092', 'SP-200001-delete')
         , ('SP-100092', 'SP-200001-insert')
         , ('SP-100090', 'SP-200001-delete')
         , ('SP-100090', 'SP-200001-insert')
         , ('SP-300001-insert-update', 'SP-200001-delete')
         , ('SP-300001-insert-update', 'SP-200001-insert')
         , ('SP-300001-delete', 'SP-200001-delete')
         , ('SP-300001-delete', 'SP-200001-insert')
)
INSERT
INTO mdi.state_machine_step (process_dwid, next_process_dwid)
SELECT process.dwid, next_process.dwid
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name
JOIN mdi.process next_process
     ON next_process.name = insert_rows.next_process_name;
