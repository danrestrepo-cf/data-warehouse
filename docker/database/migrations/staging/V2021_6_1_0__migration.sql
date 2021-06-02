--
-- EDW | edw_field_definition - fix data type mismatches between dimensions and source fields
-- https://app.asana.com/0/0/1200393611923107
--

ALTER TABLE star_loan.borrower_demographics_dim
    ALTER COLUMN schooling_years TYPE INTEGER USING schooling_years::INTEGER;
