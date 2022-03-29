--
-- EDW | Create borrower_hmda_collection_dim and add its dwid to borrower_dim
-- https://app.asana.com/0/0/1201985219077223
--

UPDATE star_loan.borrower_dim
SET borrower_hmda_collection_dwid = 0
WHERE borrower_hmda_collection_dwid IS NULL;
