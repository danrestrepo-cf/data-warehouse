--
-- EDW - Octane 2021.4.2.0 schema changes (https://app.asana.com/0/0/1200152646479560)
--

ALTER TABLE staging_octane.proposal
    ADD COLUMN prp_adjusted_as_is_value_amount numeric(15,0),
    ADD COLUMN prp_after_improved_value_amount numeric(15,0);

ALTER TABLE staging_octane.smart_doc
    ADD COLUMN sd_action_entity_effective_collateral_underwriter bit;
