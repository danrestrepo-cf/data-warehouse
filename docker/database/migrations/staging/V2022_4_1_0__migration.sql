--
-- EDW | Add borrower_hmda_collection_dim_dwid to loan_fact, populated using new borrower_lkup table
-- https://app.asana.com/0/0/1201990575730851
--

--remove unique dim foreign key from borrower_dim
ALTER TABLE star_loan.borrower_dim
    DROP COLUMN borrower_hmda_collection_dwid;

--create new lookup table for borrower-related unique dim dwids
CREATE TABLE star_loan.borrower_lkup (
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    borrower_dwid BIGINT
        CONSTRAINT pk_borrower_lkup
            PRIMARY KEY,
    borrower_pid BIGINT,
    borrower_hmda_collection_dwid BIGINT
);

CREATE INDEX idx_borrower_lkup__etl_batch_id ON star_loan.borrower_lkup (etl_batch_id);
CREATE INDEX idx_borrower_lkup__data_source_integration_id ON star_loan.borrower_lkup (data_source_integration_id);
CREATE INDEX idx_borrower_lkup__borrower_pid ON star_loan.borrower_lkup (borrower_pid);
CREATE INDEX idx_borrower_lkup__borrower_hmda_collection_dwid ON star_loan.borrower_lkup (borrower_hmda_collection_dwid);

--add unique dim column to loan_fact
ALTER TABLE star_loan.loan_fact
    ADD COLUMN b1_borrower_hmda_collection_dwid BIGINT;

CREATE INDEX idx_loan_fact__b1_borrower_hmda_collection_dwid ON star_loan.loan_fact (b1_borrower_hmda_collection_dwid);
