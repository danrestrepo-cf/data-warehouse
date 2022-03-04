--
-- Main | EDW | Octane schema sync for v2022.3.1.x
-- https://app.asana.com/0/0/1201886882131342/
--

-- staging_octane
ALTER TABLE staging_octane.appraisal_order_request
    ADD COLUMN aprq_appraisal_import_warnings text;

ALTER TABLE staging_octane.smart_doc
    ADD COLUMN sd_action_entity_supplemental_originator boolean,
    ADD COLUMN sd_action_entity_referring_associate boolean;

ALTER TABLE staging_octane.deal_key_roles
    ADD COLUMN dkrs_referring_associate_lender_user_pid bigint,
    ADD COLUMN dkrs_referring_associate_fmls varchar(128);

-- history_octane
ALTER TABLE history_octane.appraisal_order_request
    ADD COLUMN aprq_appraisal_import_warnings text;

ALTER TABLE history_octane.smart_doc
    ADD COLUMN sd_action_entity_supplemental_originator boolean,
    ADD COLUMN sd_action_entity_referring_associate boolean;

ALTER TABLE history_octane.deal_key_roles
    ADD COLUMN dkrs_referring_associate_lender_user_pid bigint,
    ADD COLUMN dkrs_referring_associate_fmls varchar(128);

CREATE INDEX fk_deal_key_roles_41 ON history_octane.deal_key_roles (dkrs_referring_associate_lender_user_pid);
