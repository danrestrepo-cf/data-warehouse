/*
SP-0.4 test case 6
Scenario: Input table contains a record with a NULL update key value, output table contains a record with a NULL
update key value
Expected output: NULL update key value record in output table matches NULL update key value record in input table
*/
INSERT INTO ingress.test.unit_test_tools_input (
                                                 tool_pid
                                               , tool_code
                                               , tool_type
                                               , tool_price
                                               , tool_inventory_start_date
                                               , tool_inventory_end_date
)
VALUES (1, 'LADW', 'Ladder', 50, '2021-01-01'::DATE, '2021-12-31'::DATE)
,      (NULL, 'CHNS', 'Chainsaw', 175, '2021-01-01'::DATE, '2021-12-31'::DATE);


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
VALUES (1, 'LADW', 'Ladder', 50, '2021-01-01'::DATE, '2021-12-31'::DATE, 3, 'ETL-BATCH-ID')
,      (NULL, 'JAKH', 'Jackhammer', 350, '2021-01-01'::DATE, '2021-12-31'::DATE, 3, 'ETL-BATCH-ID');