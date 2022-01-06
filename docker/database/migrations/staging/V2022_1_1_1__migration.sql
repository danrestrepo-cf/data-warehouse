--
-- EDW | star_loan - remove country fields from lender_user_dim
-- https://app.asana.com/0/0/1201615556752354
--

ALTER TABLE star_loan.lender_user_dim
    DROP COLUMN country_code
    , DROP COLUMN country;
