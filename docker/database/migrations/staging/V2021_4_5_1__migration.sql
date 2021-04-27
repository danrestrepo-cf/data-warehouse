--
-- EDW | test that DMS works if reading from a MySQL bit column and writing to Postgres Boolean column
-- (https://app.asana.com/0/0/1200241170329567/)
--

ALTER TABLE staging_octane.borrower_job_gap
    ALTER COLUMN bjg_primary_job TYPE BOOLEAN USING bjg_primary_job::INT::BOOLEAN;

ALTER TABLE history_octane.borrower_job_gap
    ALTER COLUMN bjg_primary_job TYPE BOOLEAN USING bjg_primary_job::INT::BOOLEAN;
