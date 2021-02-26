/*
SP-0.4 test case 11 target setup
Scenario: Source and target tables contain records with matching update key values and source field value is NULL,
target field value has data
Expected output: Target table update field values data match source table update field values (becomes NULL)
*/

INSERT INTO test.unit_test_tools_target (tool_pid, tool_code, tool_type, tool_price,
                                         tool_inventory_start_date, tool_inventory_end_date,
                                         data_source_dwid, etl_batch_id)
VALUES (1, 'LADW', 'Ladder', 50, '2021-01-01'::DATE, '2021-12-31'::DATE, 3, 'ETL-BATCH-ID')
,      (2, 'CHNS', 'Chainsaw', 175, '2021-01-01'::DATE, '2021-12-31'::DATE, 3, 'ETL-BATCH-ID');