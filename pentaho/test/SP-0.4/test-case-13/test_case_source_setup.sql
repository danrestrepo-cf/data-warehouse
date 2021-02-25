/*
SP-0.4 test case 13 source setup
Scenario: Source and target tables contain records with no matching update key values between the two
Expected output: Target table appends data from source table
*/

INSERT INTO test.unit_test_tools_source (tool_pid, tool_code, tool_type, tool_price,
                                                tool_inventory_start_date, tool_inventory_end_date,data_source_dwid)
VALUES (3, 'JAKH', 'Jackhammer', 350, '2021-01-01'::DATE, '2021-12-31'::DATE, 3)
,      (4, 'TSAW', 'Table saw', 225, '2021-01-01'::DATE, '2021-12-31'::DATE, 3);