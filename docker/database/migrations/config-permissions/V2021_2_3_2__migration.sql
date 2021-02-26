-- Revoke mditest permissions for new mdi.config tables
REVOKE SELECT ON mdi.insert_update_step, mdi.insert_update_key, mdi.insert_update_field FROM mditest;
-- Grant permissions for new mdi.config tables
GRANT SELECT ON mdi.insert_update_step, mdi.insert_update_key, mdi.insert_update_field TO pentaho_mdi;