/*
SP-0.4 test case 12 source setup
Scenario: Source and target tables contain records with matching update key values and source field value has data,
target field value is NULL
Expected output: Target table update field values data match source table update field values (becomes NOT NULL)
*/

INSERT INTO test.unit_test_tools_source (tool_pid, tool_code, tool_type, tool_price,
                                                tool_inventory_start_date, tool_inventory_end_date, data_source_dwid)
VALUES (1, 'LADW', 'Ladder', 50, '2021-01-01'::DATE, '2021-12-31'::DATE, 3)
,      (2, 'CHNS', 'Chainsaw', 175, '2021-01-01'::DATE, '2021-12-31'::DATE, 3);