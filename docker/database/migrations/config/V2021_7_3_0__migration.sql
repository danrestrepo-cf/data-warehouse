/*
EDW | Modify step function creator and Cloudwatch trigger to accommodate updated ETL pipeline infrastructure
https://app.asana.com/0/0/1200598165371356/

mdi.state_machine_definition rows are needed for server processes (SPs) that maintain star_loan tables
Also, the mdi.state_machine_definition row for the SP that maintains history_octane.mortgage_delinquency_exception_type
has an invalid value in the 'name' field
*/


INSERT INTO mdi.state_machine_definition (process_dwid, name, comment)
SELECT process.dwid AS process_dwid, process.name, process.description AS comment
FROM mdi.process
         JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
    AND table_output_step.target_schema = 'star_loan'
UNION ALL
SELECT process.dwid AS process_dwid, process.name, process.description AS comment
FROM mdi.process
         JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
    AND insert_update_step.schema_name = 'star_loan'
UNION ALL
SELECT process.dwid AS process_dwid, process.name, process.description AS comment
FROM mdi.process
         JOIN mdi.delete_step ON process.dwid = delete_step.process_dwid
    AND delete_step.schema_name = 'star_loan';

UPDATE mdi.state_machine_definition
    SET name = 'SP-100833'
    WHERE name = 'Octane__mortgage_delinquency_exception_type';
