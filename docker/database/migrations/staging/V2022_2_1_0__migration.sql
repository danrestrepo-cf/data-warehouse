--
-- EDW | Add Octane table deal_stage data EDW so it is reportable at the loan level - https://app.asana.com/0/0/1200811462378267
--

ALTER TABLE star_loan.loan_fact
    ADD current_transaction_stage_from_date_dwid BIGINT;

ALTER TABLE star_loan.transaction_dim
    ADD current_transaction_stage VARCHAR(1024)
    , ADD current_transaction_stage_code VARCHAR(128);
