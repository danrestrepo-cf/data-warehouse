-- Grant SELECT to readonly for new mdi.config tables
GRANT SELECT ON mdi.insert_update_step, mdi.insert_update_key, mdi.insert_update_field TO mditest;
GRANT SELECT ON mdi.insert_update_step, mdi.insert_update_key, mdi.insert_update_field TO readonly;