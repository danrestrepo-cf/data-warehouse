--
-- EDW | star_loan schema: Add indexes to tables' key lookup fields
-- https://app.asana.com/0/0/1200975391827399
--

CREATE INDEX idx_application_dim__data_source_integration_id 
	ON star_loan.application_dim USING btree(data_source_integration_id);

CREATE INDEX idx_borrower_demographics_dim__data_source_integration_id 
	ON star_loan.borrower_demographics_dim USING btree(data_source_integration_id);

CREATE INDEX idx_borrower_dim__data_source_integration_id 
	ON star_loan.borrower_dim USING btree(data_source_integration_id);

CREATE INDEX idx_borrower_lending_profile_dim__data_source_integration_id 
	ON star_loan.borrower_lending_profile_dim USING btree(data_source_integration_id);

CREATE INDEX idx_hmda_purchaser_of_loan_dim__data_source_integration_id 
	ON star_loan.hmda_purchaser_of_loan_dim USING btree(data_source_integration_id);

CREATE INDEX idx_interim_funder_dim__data_source_integration_id 
	ON star_loan.interim_funder_dim USING btree(data_source_integration_id);

CREATE INDEX idx_investor_dim__data_source_integration_id 
	ON star_loan.investor_dim USING btree(data_source_integration_id);

CREATE INDEX idx_lender_user_dim__data_source_integration_id 
	ON star_loan.lender_user_dim USING btree(data_source_integration_id);

CREATE INDEX idx_loan_beneficiary_dim__data_source_integration_id 
	ON star_loan.loan_beneficiary_dim USING btree(data_source_integration_id);

CREATE INDEX idx_loan_dim__data_source_integration_id 
	ON star_loan.loan_dim USING btree(data_source_integration_id);

CREATE INDEX idx_loan_fact__data_source_integration_id 
	ON star_loan.loan_fact USING btree(data_source_integration_id);

CREATE INDEX idx_loan_funding_dim__data_source_integration_id 
	ON star_loan.loan_funding_dim USING btree(data_source_integration_id);

CREATE INDEX idx_loan_junk_dim__data_source_integration_id 
	ON star_loan.loan_junk_dim USING btree(data_source_integration_id);

CREATE INDEX idx_mortgage_insurance_dim__data_source_integration_id 
	ON star_loan.mortgage_insurance_dim USING btree(data_source_integration_id);

CREATE INDEX idx_product_choice_dim__data_source_integration_id 
	ON star_loan.product_choice_dim USING btree(data_source_integration_id);

CREATE INDEX idx_product_dim__data_source_integration_id 
	ON star_loan.product_dim USING btree(data_source_integration_id);

CREATE INDEX idx_product_terms_dim__data_source_integration_id 
	ON star_loan.product_terms_dim USING btree(data_source_integration_id);

CREATE INDEX idx_transaction_dim__data_source_integration_id 
	ON star_loan.transaction_dim USING btree(data_source_integration_id);

CREATE INDEX idx_transaction_junk_dim__data_source_integration_id 
	ON star_loan.transaction_junk_dim USING btree(data_source_integration_id);

--
-- EDW | star_loan - prevent dimension ETLs from performing unnecessary updates
-- https://app.asana.com/0/1199645410972911/1200970669432550/f
--

ALTER TABLE star_loan.product_choice_dim
    RENAME COLUMN prepay_penatly_schedule_code TO prepay_penalty_schedule_code;
