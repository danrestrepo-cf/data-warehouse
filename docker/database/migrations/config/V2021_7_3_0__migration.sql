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


--
-- EDW | config database - Duplicated data in mdi.table_output_field table
-- https://app.asana.com/0/0/1200662873455331
--

DELETE FROM mdi.table_output_field deleted_records
    USING mdi.table_output_field kept_records
WHERE deleted_records.database_field_name = kept_records.database_field_name
    AND deleted_records.database_field_name IN (
        'ctr_validation_status_type'
        , 'ctr_verified'
        , 'pl_acquisition_cost_amount_verified'
        , 'pl_acquisition_date_verified'
        , 'pl_property_tax_id_verified'
        , 'pl_seller_acquired_date_verified'
        , 'pl_seller_original_cost_amount_verified'
    )
    AND deleted_records.dwid > kept_records.dwid;

UPDATE mdi.table_output_field
SET field_order = 8
WHERE dwid IN (
    SELECT table_output_field.dwid
    FROM mdi.table_output_field
        JOIN mdi.table_output_step ON table_output_field.table_output_step_dwid = table_output_step.dwid
        JOIN mdi.process ON table_output_step.process_dwid = process.dwid
            AND process.name IN ('SP-0.1', 'SP-0.2')
    WHERE table_output_field.database_field_name = 'etl_batch_id'
);
