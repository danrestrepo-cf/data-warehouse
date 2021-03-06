-------------------------------------------------------------------------------
--  NAME
--      Add MDI Ingress test tables for Pentaho Insert / update step support
--
--  ASANA
--      https://app.asana.com/0/0/1199565206309934
--
--  DESCRIPTION/PURPOSE
--      This script adds the test tables that are needed to support testing of
--      the table-to-table insert and table-to-table insert / update MDI configurations
--
-- PROGRAMMING NOTES
--     None
--
-------------------------------------------------------------------------------

CREATE TABLE test.unit_test_tools_source (
    tool_pid INT
    , tool_code TEXT
    , tool_type TEXT
    , tool_price INT
    , tool_inventory_start_date DATE
    , tool_inventory_end_date DATE
    , data_source_dwid INT
);

CREATE TABLE test.unit_test_tools_target (
    tool_pid INT
    , tool_code TEXT
    , tool_type TEXT
    , tool_price INT
    , tool_inventory_start_date DATE
    , tool_inventory_end_date DATE
    , data_source_dwid INT
    , etl_batch_id TEXT
);