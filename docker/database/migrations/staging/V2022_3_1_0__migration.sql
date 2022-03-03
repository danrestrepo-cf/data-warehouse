--
-- Main | EDW | Octane schema sync for v2022.3.1.x
-- https://app.asana.com/0/0/1201886882131342/
--

-- staging_octane
ALTER TABLE staging_octane.appraisal_order_request
    ADD COLUMN aprq_appraisal_import_warnings text;


-- history_octane
ALTER TABLE history_octane.appraisal_order_request
    ADD COLUMN aprq_appraisal_import_warnings text;
