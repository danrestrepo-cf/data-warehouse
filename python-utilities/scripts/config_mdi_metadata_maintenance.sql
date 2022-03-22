/*
INSERTIONS
*/

--state_machine_step
WITH insert_rows (process_name, next_process_name) AS (
    VALUES ('SP-100403', 'SP-200005-insert-update')
         , ('SP-100404', 'SP-200005-insert-update')
         , ('SP-100308', 'SP-200005-insert-update')
         , ('SP-100419', 'SP-200005-insert-update')
         , ('SP-100158', 'SP-200005-insert-update')
         , ('SP-100421', 'SP-200005-insert-update')
         , ('SP-100450', 'SP-200005-insert-update')
         , ('SP-100058', 'SP-200005-insert-update')
         , ('SP-100452', 'SP-200005-insert-update')
         , ('SP-100092', 'SP-200001-delete')
         , ('SP-100747', 'SP-200005-insert-update')
         , ('SP-100748', 'SP-200005-insert-update')
         , ('SP-100549', 'SP-200005-insert-update')
         , ('SP-100090', 'SP-200001-delete')
         , ('SP-100012', 'SP-200005-insert-update')
         , ('SP-100617', 'SP-200005-insert-update')
         , ('SP-100629', 'SP-200005-insert-update')
         , ('SP-100814', 'SP-200005-insert-update')
         , ('SP-300001-insert-update', 'SP-200001-delete')
         , ('SP-300001-delete', 'SP-200001-delete')
)
INSERT
INTO mdi.state_machine_step (process_dwid, next_process_dwid)
SELECT process.dwid, next_process.dwid
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name
JOIN mdi.process next_process
     ON next_process.name = insert_rows.next_process_name;