--
-- EDW | loan_funding_dim - Add collateral_tracking_number to the table, metadata and ETL
-- https://app.asana.com/0/0/1200453484886100
--

ALTER TABLE star_loan.loan_funding_dim
    ADD COLUMN collateral_tracking_number VARCHAR(32);
