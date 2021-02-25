/*
SP-0.4 test case 6 source setup
Scenario: Source table contains a record with a NULL update key value, target table contains a record with a NULL
update key value
Expected output: NULL update key value from source table is inserted into target table
*/
INSERT INTO test.unit_test_tools_source (tool_pid, tool_code, tool_type, tool_price,
                                                tool_inventory_start_date, tool_inventory_end_date, data_source_dwid)
VALUES (1, 'LADW', 'Ladder', 50, '2021-01-01'::DATE, '2021-12-31'::DATE, 3)
,      (NULL, 'CHNS', 'Chainsaw', 175, '2021-01-01'::DATE, '2021-12-31'::DATE, 3);