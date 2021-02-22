/*
SP-0.3 test case 3
Scenario: Input table does not contain data, output table contains data
Expected output: No change in output table
*/

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
VALUES (1, 'LADW', 'Ladder', 50, '2021-01-01'::DATE, '2021-12-31'::DATE, 3, 'ETL-BATCH-ID');