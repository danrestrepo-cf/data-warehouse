--
-- test that DMS works if reading from a MySQL bit column and writing to Postgres Boolean column: borrower_income  bi_current, bi_primary, bi_synthetic_unique
-- (https://app.asana.com/0/0/1200256573875475)
--

ALTER TABLE staging_octane.borrower_income
    ALTER COLUMN bi_current TYPE BOOLEAN USING bi_current::INT::BOOLEAN
    , ALTER COLUMN bi_primary TYPE BOOLEAN USING bi_current::INT::BOOLEAN
    , ALTER COLUMN bi_synthetic_unique TYPE BOOLEAN USING bi_current::INT::BOOLEAN;

ALTER TABLE history_octane.borrower_income
    ALTER COLUMN bi_current TYPE BOOLEAN USING bi_current::INT::BOOLEAN
    , ALTER COLUMN bi_primary TYPE BOOLEAN USING bi_current::INT::BOOLEAN
    , ALTER COLUMN bi_synthetic_unique TYPE BOOLEAN USING bi_current::INT::BOOLEAN;
