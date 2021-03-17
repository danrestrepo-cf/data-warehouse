INSERT INTO test.unit_test_tools_source (tool_pid, tool_code, tool_type, tool_price,
                                         tool_inventory_start_date, tool_inventory_end_date,
                                         data_source_dwid)
VALUES (1, 'LADW', 'Ladder', 50, '2021-01-01'::DATE, '2021-12-31'::DATE, 1); -- the data_source_dwid=1 in the source table, should be 3 in expected output