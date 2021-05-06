--
-- EDW | staging.star_loan.transaction_junk_dim - needs a primary key (dwid)
-- (https://app.asana.com/0/0/1200280545004754)
--

ALTER TABLE star_loan.transaction_junk_dim
    ADD PRIMARY KEY (dwid);
