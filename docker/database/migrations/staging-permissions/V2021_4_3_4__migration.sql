--
-- EDW | default permissions issue in staging_octane, history_octane
-- (https://app.asana.com/0/0/1200210378245535)
--

GRANT SELECT ON history_octane.construction_permit
    , history_octane.construction_permit_by_requested_type
    , history_octane.construction_permit_type
    , staging_octane.construction_permit
    , staging_octane.construction_permit_by_requested_type
    , staging_octane.construction_permit_type
    , staging_octane.borrower_declarations
    , staging_octane.doc_provider_group_type
    , staging_octane.doc_req_fulfill_status_type
    , staging_octane.financed_property_improvements_category_type
    , staging_octane.minimum_required_residual_income_row
    , staging_octane.minimum_required_residual_income_table
    , staging_octane.new_lock_only_add_on
    , staging_octane.trust_classification_type TO readonly;

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON staging_octane.construction_permit
    , staging_octane.construction_permit_by_requested_type
    , staging_octane.construction_permit_type TO dms_octane_writer;

ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA staging_octane GRANT SELECT ON TABLES TO readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA history_octane GRANT SELECT ON TABLES TO readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE deployer IN SCHEMA staging_octane GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE
    ON TABLES TO dms_octane_writer;
