--
-- EDW - update DMS permissions to apply to future tables (https://app.asana.com/0/0/1200119921931317)
--

ALTER DEFAULT PRIVILEGES IN SCHEMA staging_octane GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON TABLES TO dms_octane_writer;

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON
    staging_octane.borrower_declarations
    , staging_octane.minimum_required_residual_income_table
    , staging_octane.minimum_required_residual_income_row
    , staging_octane.new_lock_only_add_on
TO dms_octane_writer;
