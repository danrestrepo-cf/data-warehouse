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


--
-- EDW - add missed domain types (https://app.asana.com/0/0/1200119922255221)
--

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON
    staging_octane.doc_provider_group_type
    , staging_octane.doc_req_fulfill_status_type
    , staging_octane.trust_classification_type
    , staging_octane.financed_property_improvements_category_type
    TO dms_octane_writer;
