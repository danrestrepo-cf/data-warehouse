--
-- EDW | star_loan - improve loan_lender_user_access delete query run times
-- https://app.asana.com/0/0/1201486823872698
--

CREATE TABLE star_loan.new_loan_lender_user_access (
    dwid BIGSERIAL NOT NULL
        CONSTRAINT pk_loan_lender_user_access
            PRIMARY KEY,
    data_source_dwid BIGINT NOT NULL,
    edw_created_datetime TIMESTAMPTZ,
    edw_modified_datetime TIMESTAMPTZ,
    etl_batch_id TEXT,
    data_source_integration_columns TEXT,
    data_source_integration_id TEXT NOT NULL,
    data_source_modified_datetime TIMESTAMPTZ,
    lender_user_pid BIGINT NOT NULL,
    octane_username TEXT,
    loan_dwid BIGINT NOT NULL,
    account_pid BIGINT NOT NULL
);

CREATE INDEX idx_new_loan_lender_user_access__data_source_integration_id ON star_loan.new_loan_lender_user_access (data_source_integration_id);
CREATE INDEX idx_new_loan_lender_user_access__etl_batch_id ON star_loan.new_loan_lender_user_access (etl_batch_id);
CREATE INDEX idx_new_loan_lender_user_access__octane_username_account_pid ON star_loan.new_loan_lender_user_access (octane_username, account_pid);
CREATE INDEX idx_new_loan_lender_user_access__lender_user_pid ON star_loan.new_loan_lender_user_access (lender_user_pid);
CREATE INDEX idx_new_loan_lender_user_access__loan_dwid ON star_loan.new_loan_lender_user_access (loan_dwid);
