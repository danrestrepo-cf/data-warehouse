/*
SP-0.4 test case 7
Scenario: Input table contains multiple records with the same update key value
Expected output: Output record matches corresponding input record that was processed last
*/

INSERT INTO ingress.test.unit_test_tools_input (tool_pid, tool_code, tool_type, tool_price,
                                                tool_inventory_start_date, tool_inventory_end_date, data_source_dwid)
VALUES (1, 'LADW', 'Ladder', 50, '2021-01-01'::DATE, '2021-12-31'::DATE, 3)
,      (1, 'JAKH', 'Jackhammer', 350, '2021-01-01'::DATE, '2021-12-31'::DATE, 3);


INSERT INTO ingress.test.unit_test_tools_output (tool_pid, tool_code, tool_type, tool_price,
                                                 tool_inventory_start_date, tool_inventory_end_date,
                                                 data_source_dwid, etl_batch_id)
VALUES (1, 'LADW', 'Ladder', 50, '2021-01-01'::DATE, '2021-12-31'::DATE, 3, 'ETL-BATCH-ID')
,      (2, 'CHNS', 'Chainsaw', 175, '2021-01-01'::DATE, '2021-12-31'::DATE, 3, 'ETL-BATCH-ID');