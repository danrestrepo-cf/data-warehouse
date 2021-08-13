--
-- Main | EDW - Octane schemas from prod-release to uat (2021-08-13)
-- https://app.asana.com/0/0/1200761821493609
--

--Insert metadata for new columns: asset.as_earnest_money_deposit_is_gif
WITH new_fields (table_name, field_name, field_order) AS (
    VALUES ('asset', 'as_earnest_money_deposit_is_gift', 44)
)
   , new_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT edw_table_definition.dwid, new_fields.field_name, FALSE
        FROM new_fields
        JOIN mdi.edw_table_definition
             ON edw_table_definition.schema_name = 'staging_octane'
                 AND edw_table_definition.table_name = new_fields.table_name
        RETURNING dwid, edw_table_definition_dwid, field_name
)
   , new_history_field_definitions AS (
    INSERT
        INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, source_edw_field_definition_dwid)
            SELECT edw_table_definition.dwid, new_fields.field_name, FALSE, new_staging_field_definitions.dwid
            FROM new_fields
            JOIN mdi.edw_table_definition
                 ON edw_table_definition.schema_name = 'history_octane'
                     AND edw_table_definition.table_name = new_fields.table_name
            JOIN mdi.edw_table_definition source_table_definition
                 ON source_table_definition.schema_name = 'staging_octane'
                     AND source_table_definition.table_name = new_fields.table_name
            JOIN new_staging_field_definitions
                 ON new_staging_field_definitions.edw_table_definition_dwid = source_table_definition.dwid
                     AND new_staging_field_definitions.field_name = new_fields.field_name
)
   , new_table_output_fields AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
        SELECT table_output_step.dwid, new_fields.field_name, new_fields.field_name, new_fields.field_order, FALSE
        FROM new_fields
        JOIN mdi.table_output_step
             ON table_output_step.target_schema = 'history_octane'
                 AND table_output_step.target_table = new_fields.table_name
)
   , updated_table_input_sql (table_name, sql) AS (
    VALUES ('asset', '--finding records to insert into history_octane.asset
SELECT staging_table.as_pid, staging_table.as_version, staging_table.as_aggregate_description, staging_table.as_application_pid, staging_table.as_asset_type, staging_table.as_automobile_make_description, staging_table.as_automobile_model_year, staging_table.as_cash_or_market_value_amount, staging_table.as_description, staging_table.as_donor_city, staging_table.as_donor_country, staging_table.as_donor_postal_code, staging_table.as_donor_state, staging_table.as_donor_street1, staging_table.as_donor_street2, staging_table.as_gift_funds_donor_phone, staging_table.as_gift_funds_donor_relationship, staging_table.as_gift_funds_donor_unparsed_name, staging_table.as_gift_funds_other_type_description, staging_table.as_gift_funds_depository_asset_pid, staging_table.as_gift_amount, staging_table.as_gift_funds_source_account_type, staging_table.as_gift_funds_source_holder_name, staging_table.as_gift_funds_type, staging_table.as_holder_name, staging_table.as_holder_city, staging_table.as_holder_country, staging_table.as_holder_postal_code, staging_table.as_holder_state, staging_table.as_holder_street1, staging_table.as_holder_street2, staging_table.as_life_insurance_face_value_amount, staging_table.as_liquid_amount, staging_table.as_liquid_percent, staging_table.as_source_verification_required, staging_table.as_stock_bond_mutual_fund_share_count, staging_table.as_earnest_money_deposit_source_pid, staging_table.as_available_amount, staging_table.as_down_payment_amount, staging_table.as_closing_costs_amount, staging_table.as_gift_funds_account_holder_type, staging_table.as_penalty_amount, staging_table.as_earnest_money_deposit_is_gift, FALSE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.asset staging_table
LEFT JOIN history_octane.asset history_table on staging_table.as_pid = history_table.as_pid and staging_table.as_version = history_table.as_version
WHERE history_table.as_pid is NULL
UNION ALL
SELECT history_table.as_pid, history_table.as_version+1, history_table.as_aggregate_description, history_table.as_application_pid, history_table.as_asset_type, history_table.as_automobile_make_description, history_table.as_automobile_model_year, history_table.as_cash_or_market_value_amount, history_table.as_description, history_table.as_donor_city, history_table.as_donor_country, history_table.as_donor_postal_code, history_table.as_donor_state, history_table.as_donor_street1, history_table.as_donor_street2, history_table.as_gift_funds_donor_phone, history_table.as_gift_funds_donor_relationship, history_table.as_gift_funds_donor_unparsed_name, history_table.as_gift_funds_other_type_description, history_table.as_gift_funds_depository_asset_pid, history_table.as_gift_amount, history_table.as_gift_funds_source_account_type, history_table.as_gift_funds_source_holder_name, history_table.as_gift_funds_type, history_table.as_holder_name, history_table.as_holder_city, history_table.as_holder_country, history_table.as_holder_postal_code, history_table.as_holder_state, history_table.as_holder_street1, history_table.as_holder_street2, history_table.as_life_insurance_face_value_amount, history_table.as_liquid_amount, history_table.as_liquid_percent, history_table.as_source_verification_required, history_table.as_stock_bond_mutual_fund_share_count, history_table.as_earnest_money_deposit_source_pid, history_table.as_available_amount, history_table.as_down_payment_amount, history_table.as_closing_costs_amount, history_table.as_gift_funds_account_holder_type, history_table.as_penalty_amount, history_table.as_earnest_money_deposit_is_gift, TRUE as data_source_deleted_flag, now() AS data_source_updated_datetime
FROM history_octane.asset history_table
LEFT JOIN staging_octane.asset staging_table on staging_table.as_pid = history_table.as_pid
WHERE staging_table.as_pid is NULL
  AND not exists (select 1 from history_octane.asset deleted_records where deleted_records.as_pid = history_table.as_pid and deleted_records.data_source_deleted_flag = True);')
)
   , updated_table_input_step AS (
    UPDATE mdi.table_input_step
        SET sql = updated_table_input_sql.sql
        FROM updated_table_input_sql, mdi.table_output_step
        WHERE table_input_step.process_dwid = table_output_step.process_dwid
            AND table_output_step.target_schema = 'history_octane'
            AND table_output_step.target_table = updated_table_input_sql.table_name
)
SELECT 'Finished inserting metadata for new columns: asset.as_earnest_money_deposit_is_gift';
