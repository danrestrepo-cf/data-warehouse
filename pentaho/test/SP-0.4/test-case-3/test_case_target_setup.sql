/*
SP-0.4 test case 3 target setup
Scenario: Source table does not contain data, target table contains data
Expected output: No change in target table

This test case inserts data into the target table only per the scenario defined above
*/

INSERT INTO test.unit_test_tools_target (tool_pid, tool_code, tool_type, tool_price,
                                         tool_inventory_start_date, tool_inventory_end_date,
                                         data_source_dwid, etl_batch_id)
VALUES (1, 'LADW', 'Ladder', 50, '2021-01-01'::DATE, '2021-12-31'::DATE, 3, 'ETL-BATCH-ID');