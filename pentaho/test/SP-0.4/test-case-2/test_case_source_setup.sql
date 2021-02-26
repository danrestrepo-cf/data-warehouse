/*
SP-0.4 test case 2 source setup
Scenario: Source table contains data, target table does not contain data
Expected output: Target table matches source table

This test case inserts data into the source table only per the scenario defined above
*/

INSERT INTO test.unit_test_tools_source (tool_pid, tool_code, tool_type, tool_price,
                                         tool_inventory_start_date, tool_inventory_end_date, data_source_dwid)
VALUES (1, 'LADW', 'Ladder', 50, '2021-01-01'::DATE, '2021-12-31'::DATE, 3);