--
-- EDW | star_loan - update mortgage_insurance_dim
-- (https://app.asana.com/0/0/1200290945682993/)
--

ALTER TABLE star_loan.mortgage_insurance_dim
    ALTER COLUMN loan_dwid TYPE BIGINT
    , ALTER COLUMN loan_dwid DROP DEFAULT
    , ADD PRIMARY KEY (loan_dwid);

DROP SEQUENCE star_loan.mortgage_insurance_dim_loan_dwid_seq;
