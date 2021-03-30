--
-- EDW - add missed domain types (https://app.asana.com/0/0/1200119922255221)
--

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON
    staging_octane.doc_provider_group_type
    , staging_octane.doc_req_fulfill_status_type
    , staging_octane.trust_classification_type
    , staging_octane.financed_property_improvements_category_type
    TO dms_octane_writer;
