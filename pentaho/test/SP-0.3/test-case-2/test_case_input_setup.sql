/*
SP-0.3 test case 2
Scenario: Input table contains data, output table does not contain data
Expected output: Output table matches input table
*/

INSERT INTO ingress.test.unit_test_tools_input (
    tool_pid
    , tool_code
    , tool_type
    , tool_price
    , tool_inventory_start_date
    , tool_inventory_end_date
)
VALUES (1, 'LADW', 'Ladder', 50, '2021-01-01'::DATE, '2021-12-31'::DATE);