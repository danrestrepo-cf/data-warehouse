-- create data_source table
CREATE TABLE star_common.data_source
(
    dwid BIGSERIAL NOT NULL
        CONSTRAINT data_source_pk
            PRIMARY KEY,
    name TEXT NOT NULL
);

-- populate data_source table with values
INSERT INTO star_common.data_source ( dwid, name )
VALUES ( 0, 'Unspecified' )
     , ( 1, 'Octane' )
     , ( 2, 'Encompass' )
     , ( 3, 'DMI' )
;

--
-- create target table for SP8.2
--
CREATE TABLE staging_compliance.nmls_call_report_state
(
    mcr_code TEXT NOT NULL,
    mcr_desc TEXT,
    state_type TEXT NOT NULL,
    unpaid_balance NUMERIC,
    loan_count INTEGER,
    avg_loan_size NUMERIC,
    etl_batch_id TEXT,
    data_source_dwid BIGINT
);

--
-- create target table for SP9.2
--
CREATE TABLE staging_compliance.nmls_call_report_national
(
    mcr_code TEXT NOT NULL,
    mcr_desc TEXT,
    unpaid_balance NUMERIC,
    loan_count INTEGER,
    avg_loan_size NUMERIC,
    etl_batch_id TEXT,
    data_source_dwid BIGINT
);

--
-- create target table for SP10.2
--
CREATE TABLE staging_compliance.nmls_call_report_s540a
(
    state_type TEXT,
    item_id BIGINT,
    servicer_id BIGINT,
    servicer_name TEXT,
    pool_number TEXT,
    unpaid_balance NUMERIC,
    loan_count INTEGER,
    etl_batch_id TEXT,
    data_source_dwid BIGINT
);
