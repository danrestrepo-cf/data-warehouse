--
-- EDW | Configure SP-100320 (ETL for history_octane.loan) to trigger SP-300001-insert-update (ETL for star_loan.loan_fact)
-- https://app.asana.com/0/0/1201147219120972
--

/*
INSERTIONS
*/

--state_machine_step
WITH insert_rows (process_name, next_process_name) AS (
    VALUES ('SP-100320', 'SP-300001-insert-update')
)
INSERT
INTO mdi.state_machine_step (process_dwid, next_process_dwid)
SELECT process.dwid, next_process.dwid
FROM insert_rows
JOIN mdi.process
     ON process.name = insert_rows.process_name
JOIN mdi.process next_process
     ON next_process.name = insert_rows.next_process_name;
