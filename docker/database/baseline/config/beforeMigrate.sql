-------------------------------------------------------------------------------
--  NAME
--      Add Staging Encompass Tables
--
--  ASANA
--      https://app.asana.com/0/265828915819547/1156662690313663
--
--  DESCRIPTION/PURPOSE
--      This script adds the tables that are needed to stage Encompass loan data
--      into the Enterprise Data Warehouse (EDW).
--
-------------------------------------------------------------------------------


-- Schema: log
--DROP SCHEMA IF EXISTS log CASCADE; -- execute this line to test the rest of the script
CREATE SCHEMA IF NOT EXISTS log;
