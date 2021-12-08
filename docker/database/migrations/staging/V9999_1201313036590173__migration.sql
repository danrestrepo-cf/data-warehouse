--
-- EDW | dimension ETLs - refactor to use batch_id start/end times instead of comparing every field to determine which records to update
-- https://app.asana.com/0/0/1201313036590173
--

CREATE INDEX idx_application_dim__etl_batch_id ON star_loan.application_dim (etl_batch_id);

CREATE INDEX idx_borrower_dim__etl_batch_id ON star_loan.borrower_dim (etl_batch_id);

CREATE INDEX idx_interim_funder_dim__etl_batch_id ON star_loan.interim_funder_dim (etl_batch_id);

CREATE INDEX idx_investor_dim__etl_batch_id ON star_loan.investor_dim (etl_batch_id);

CREATE INDEX idx_lender_user_dim__etl_batch_id ON star_loan.lender_user_dim (etl_batch_id);

CREATE INDEX idx_loan_beneficiary_dim__etl_batch_id ON star_loan.loan_beneficiary_dim (etl_batch_id);

CREATE INDEX idx_loan_dim__etl_batch_id ON star_loan.loan_dim (etl_batch_id);

CREATE INDEX idx_loan_fact__etl_batch_id ON star_loan.loan_fact (etl_batch_id);

CREATE INDEX idx_loan_funding_dim__etl_batch_id ON star_loan.loan_funding_dim (etl_batch_id);

CREATE INDEX idx_mortgage_insurance_dim__etl_batch_id ON star_loan.mortgage_insurance_dim (etl_batch_id);

CREATE INDEX idx_product_dim__etl_batch_id ON star_loan.product_dim (etl_batch_id);

CREATE INDEX idx_product_terms_dim__etl_batch_id ON star_loan.product_terms_dim (etl_batch_id);

CREATE INDEX idx_transaction_dim__etl_batch_id ON star_loan.transaction_dim (etl_batch_id);
