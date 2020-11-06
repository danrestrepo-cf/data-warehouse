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

CREATE SCHEMA IF NOT EXISTS log;
CREATE SCHEMA IF NOT EXISTS mdi; -- added for https://app.asana.com/0/0/1198065847802233
