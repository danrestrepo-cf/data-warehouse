/*
SP-0.4 test case 12
Scenario: Input and output tables contain records with no matching update key values between the two
Expected output: Output table appends data from input table
*/

INSERT INTO ingress.test.unit_test_tools_input (
                                                 tool_pid
                                               , tool_code
                                               , tool_type
                                               , tool_price
                                               , tool_inventory_start_date
                                               , tool_inventory_end_date
)
SELECT 3, 'JAKH', 'Jackhammer', 350, '2021-01-01'::DATE, '2021-12-31'::DATE
UNION ALL
SELECT 4, 'TSAW', 'Table saw', 225, '2021-01-01'::DATE, '2021-12-31'::DATE
;


INSERT INTO ingress.test.unit_test_tools_output (
                                                  tool_pid
                                                , tool_code
                                                , tool_type
                                                , tool_price
                                                , tool_inventory_start_date
                                                , tool_inventory_end_date
                                                , data_source_dwid
                                                , etl_batch_id
)
SELECT 1, 'LADW', 'Ladder', 50, '2021-01-01'::DATE, '2021-12-31'::DATE, 3, 'ETL-BATCH-ID'
UNION ALL
SELECT 2, 'CHNS', 'Chainsaw', 175, '2021-01-01'::DATE, '2021-12-31'::DATE, 3, 'ETL-BATCH-ID'
;