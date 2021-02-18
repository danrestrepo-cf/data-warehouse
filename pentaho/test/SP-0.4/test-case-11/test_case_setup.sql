/*
SP-0.4 test case 11
Scenario: Input and output tables contain records with matching update key values and input field value has data,
output field value is NULL
Expected output: Output table update field values data match input table update field values (becomes NOT NULL)
*/

INSERT INTO ingress.test.unit_test_tools_input (
                                                 tool_pid
                                               , tool_code
                                               , tool_type
                                               , tool_price
                                               , tool_inventory_start_date
                                               , tool_inventory_end_date
)
SELECT 1, 'LADW', 'Ladder', 50, '2021-01-01'::DATE, '2021-12-31'::DATE
UNION ALL
SELECT 2, 'CHNS', 'Chainsaw', 175, '2021-01-01'::DATE, '2021-12-31'::DATE
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
SELECT 1, NULL, NULL, NULL, NULL, NULL, 3, 'ETL-BATCH-ID'
UNION ALL
SELECT 2, 'CHNS', 'Chainsaw', 175, '2021-01-01'::DATE, '2021-12-31'::DATE, 3, 'ETL-BATCH-ID'
;