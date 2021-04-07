\COPY test.unit_test_tools_target (tool_pid,tool_code,tool_type,tool_price,tool_inventory_start_date,tool_inventory_end_date,data_source_dwid) TO '/input/actual_output.csv' WITH (FORMAT CSV,HEADER);
