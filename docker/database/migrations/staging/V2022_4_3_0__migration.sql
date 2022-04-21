--
-- EDW | star_loan - incorporate new lender_user fields into dimension tables
-- https://app.asana.com/0/0/1201360578080569
--

ALTER TABLE star_loan.lender_user_dim
    ADD COLUMN marketing_details_enabled BOOLEAN,
    ADD COLUMN marketing_details_featured_review VARCHAR(1024);
