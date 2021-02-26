/*
SP-0.4 test case 8 target setup
Scenario: Target table contains multiple records with the same update key value
Expected output: All corresponding target records match source record
*/

INSERT INTO test.unit_test_tools_target (tool_pid, tool_code, tool_type, tool_price,
                                         tool_inventory_start_date, tool_inventory_end_date,
                                         data_source_dwid, etl_batch_id)
VALUES (1, 'JAKH', 'Jackhammer', 350, '2021-01-01'::DATE, '2021-12-31'::DATE, 3, 'ETL-BATCH-ID')
,      (1, 'CHNS', 'Chainsaw', 175, '2021-01-01'::DATE, '2021-12-31'::DATE, 3, 'ETL-BATCH-ID');