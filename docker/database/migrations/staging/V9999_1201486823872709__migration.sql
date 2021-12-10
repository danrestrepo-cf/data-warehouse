--
-- EDW | backfill etl_log with existing star_loan etl_batch_id and insure all future etl_batch_ids correspond to a row in etl_log
-- https://app.asana.com/0/0/1201486823872709
--

-- add index to every etl_batch_id column in star_loan
CREATE INDEX idx_application_dim__etl_batch_id ON star_loan.application_dim (etl_batch_id);
CREATE INDEX idx_borrower_demographics_dim__etl_batch_id ON star_loan.borrower_demographics_dim (etl_batch_id);
CREATE INDEX idx_lender_user_dim__etl_batch_id ON star_loan.lender_user_dim (etl_batch_id);
CREATE INDEX idx_loan_lender_user_access__etl_batch_id ON star_loan.loan_lender_user_access (etl_batch_id);
CREATE INDEX idx_loan_funding_dim__etl_batch_id ON star_loan.loan_funding_dim (etl_batch_id);
CREATE INDEX idx_borrower_dim__etl_batch_id ON star_loan.borrower_dim (etl_batch_id);
CREATE INDEX idx_loan_junk_dim__etl_batch_id ON star_loan.loan_junk_dim (etl_batch_id);
CREATE INDEX idx_investor_dim__etl_batch_id ON star_loan.investor_dim (etl_batch_id);
CREATE INDEX idx_hmda_purchaser_of_loan_dim__etl_batch_id ON star_loan.hmda_purchaser_of_loan_dim (etl_batch_id);
CREATE INDEX idx_borrower_lending_profile_dim__etl_batch_id ON star_loan.borrower_lending_profile_dim (etl_batch_id);
CREATE INDEX idx_loan_dim__etl_batch_id ON star_loan.loan_dim (etl_batch_id);
CREATE INDEX idx_product_terms_dim__etl_batch_id ON star_loan.product_terms_dim (etl_batch_id);
CREATE INDEX idx_product_dim__etl_batch_id ON star_loan.product_dim (etl_batch_id);
CREATE INDEX idx_product_choice_dim__etl_batch_id ON star_loan.product_choice_dim (etl_batch_id);
CREATE INDEX idx_mortgage_insurance_dim__etl_batch_id ON star_loan.mortgage_insurance_dim (etl_batch_id);
CREATE INDEX idx_transaction_junk_dim__etl_batch_id ON star_loan.transaction_junk_dim (etl_batch_id);
CREATE INDEX idx_loan_fact__etl_batch_id ON star_loan.loan_fact (etl_batch_id);
CREATE INDEX idx_loan_beneficiary_dim__etl_batch_id ON star_loan.loan_beneficiary_dim (etl_batch_id);
CREATE INDEX idx_transaction_dim__etl_batch_id ON star_loan.transaction_dim (etl_batch_id);
CREATE INDEX idx_interim_funder_dim__etl_batch_id ON star_loan.interim_funder_dim (etl_batch_id);

-- add index to star_common.date_dim value column
CREATE INDEX idx_date_dim__value ON star_common.date_dim (value);
