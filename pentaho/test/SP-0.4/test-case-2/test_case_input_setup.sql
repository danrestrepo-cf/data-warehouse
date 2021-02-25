/*
SP-0.4 test case 2
Scenario: Input table contains data, output table does not contain data
Expected output: Output table matches input table

This test case inserts data into the input table only per the scenario defined above
*/

INSERT INTO ingress.test.unit_test_tools_input (tool_pid, tool_code, tool_type, tool_price,
                                                tool_inventory_start_date, tool_inventory_end_date, data_source_dwid)
VALUES (1, 'LADW', 'Ladder', 50, '2021-01-01'::DATE, '2021-12-31'::DATE,3);