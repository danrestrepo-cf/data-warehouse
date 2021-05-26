--
-- EDW | Modify hmda_purchaser_of_loan_dim to include separate columns for each year and build ETL to populate this dimension
-- https://app.asana.com/0/0/1200259416383677
--

ALTER TABLE star_loan.hmda_purchaser_of_loan_dim
    DROP COLUMN code,
    DROP COLUMN value,
    DROP COLUMN year,
    ADD COLUMN code_2017 VARCHAR(128),
    ADD COLUMN value_2017 VARCHAR(1024),
    ADD COLUMN code_2018 VARCHAR(128),
    ADD COLUMN value_2018 VARCHAR(1024);
