-------------------------------------------------------------------------------
--  NAME
--      Add Raw Encompass Tables
--
--  ASANA
--      https://app.asana.com/0/265828915819547/1170641800406346
--      https://app.asana.com/0/265828915819547/1163456485468342
--      https://app.asana.com/0/265828915819547/1170641800406346
--      https://app.asana.com/0/265828915819547/1166527173409791
--      https://app.asana.com/0/265828915819547/1174838407509437
--
--  DESCRIPTION/PURPOSE
--      This script adds the tables that are needed to load Encompass loan data
--      into the Enterprise Data Warehouse (EDW).
--
-- PROGRAMMING NOTES
--      Tables encompass.encompass_loan_raw and encompass_encompass_loan_raw_error
--      have functions associated with them to auto populate the created_at and
--      updated_at columns. A trigger updates the updated_at column when it is modified
--      so we can easily tell if any data was modified after the initial load.
--
-------------------------------------------------------------------------------

CREATE SCHEMA IF NOT EXISTS encompass;
CREATE SCHEMA IF NOT EXISTS dmi;
