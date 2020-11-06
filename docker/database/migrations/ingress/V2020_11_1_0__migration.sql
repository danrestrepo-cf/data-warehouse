-------------------------------------------------------------------------------
--  NAME
--      Add DMI NMLS Call Report raw tables
--
--  ASANA
--      https://app.asana.com/0/0/1191097574613962
--		https://app.asana.com/0/0/1198937140577416
--		https://app.asana.com/0/0/1198960130092086
--
--  DESCRIPTION/PURPOSE
--      This script adds the raw tables that are needed to load data from DMI's
--      NMLS Call Report file which is report number V35.
--
-------------------------------------------------------------------------------

CREATE TABLE dmi.nmls_call_report_s540a_raw
(
    state_type TEXT,
    item_id BIGINT,
    servicer_id BIGINT,
    servicer_name TEXT,
    pool_number TEXT,
    unpaid_balance NUMERIC,
    loan_count INTEGER,
    etl_batch_id TEXT
)
;

CREATE TABLE dmi.nmls_call_report_state_raw
(
    mcr_code TEXT NOT NULL,
    mcr_desc TEXT,
    state_type TEXT NOT NULL,
    unpaid_balance NUMERIC,
    loan_count INTEGER,
    avg_loan_size NUMERIC,
    etl_batch_id TEXT
)
;

CREATE TABLE dmi.nmls_call_report_national_raw
(
    mcr_code TEXT NOT NULL,
    mcr_desc TEXT,
    unpaid_balance NUMERIC,
    loan_count INTEGER,
    avg_loan_size NUMERIC,
    etl_batch_id TEXT
)
;

