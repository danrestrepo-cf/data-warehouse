--
-- EDW | star_loan - null data in calculated dimension field(s) (manual metadata fix)
-- https://app.asana.com/0/0/1200548658779340/
--

INSERT INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)
    SELECT insert_update_step.dwid AS insert_update_step_dwid
         , edw_field_definition.field_name AS update_lookup
         , edw_field_definition.field_name AS update_stream
         , 'Y' AS update_flag
         , FALSE AS is_sensitive
    FROM mdi.edw_table_definition
             JOIN mdi.edw_field_definition ON edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
             LEFT JOIN mdi.insert_update_step ON edw_table_definition.schema_name = insert_update_step.schema_name
        AND edw_table_definition.table_name = insert_update_step.table_name
             LEFT JOIN mdi.insert_update_field ON insert_update_step.dwid = insert_update_field.insert_update_step_dwid
        AND edw_field_definition.field_name = insert_update_field.update_lookup
    WHERE insert_update_step.schema_name = 'star_loan'
      AND edw_field_definition.field_name IN ('race_other_pacific_islander_description_flag'
        , 'piggyback_flag'
        , 'party_to_lawsuit_explanation_flag'
        , 'ethnicity_other_hispanic_or_latino_description_flag'
        , 'borrowed_down_payment_explanation_flag'
        , 'race_other_american_indian_or_alaska_native_description_flag'
        , 'note_endorser_explanation_flag'
        , 'other_race_national_origin_description_flag'
        , 'race_other_asian_description_flag'
        , 'obligated_loan_foreclosure_explanation_flag'
        , 'outstanding_judgments_explanation_flag'
        , 'los_loan_number'
        , 'presently_delinquent_explanation_flag'
        , 'bankruptcy_explanation_flag'
        , 'property_foreclosure_explanation_flag'
        , 'alimony_child_support_explanation_flag'
        );

--
-- EDW | loan_funding_dim - Add collateral_tracking_number to the table, metadata and ETL
-- https://app.asana.com/0/0/1200453484886100
--

-- insert edw_field_definition row for loan_funding_dim.collateral_tracking_number
INSERT
INTO mdi.edw_field_definition (edw_table_definition_dwid,
                               field_name,
                               key_field_flag,
                               source_edw_field_definition_dwid,
                               data_type, reporting_label,
                               reporting_hidden,
                               reporting_key_flag)
SELECT edw_table_definition.dwid
     , 'collateral_tracking_number'
     , FALSE
     , src_field_definition.dwid
     , 'VARCHAR(32)'
     , 'Collateral Tracking Number'
     , 'no'
     , FALSE
FROM mdi.edw_table_definition
JOIN mdi.edw_table_definition src_table_definition
     ON src_table_definition.schema_name = 'history_octane'
         AND src_table_definition.table_name = 'loan_funding'
JOIN mdi.edw_field_definition src_field_definition
     ON src_field_definition.edw_table_definition_dwid = src_table_definition.dwid
         AND src_field_definition.field_name = 'lf_collateral_tracking_number'
WHERE edw_table_definition.schema_name = 'star_loan'
  AND edw_table_definition.table_name = 'loan_funding_dim';

-- insert insert_update_field row for loan_funding_dim.collateral_tracking_number
INSERT
INTO mdi.insert_update_field (insert_update_step_dwid, update_lookup, update_stream, update_flag, is_sensitive)
SELECT insert_update_step.dwid, 'collateral_tracking_number', 'collateral_tracking_number', 'Y', FALSE
FROM mdi.insert_update_step
WHERE insert_update_step.schema_name = 'star_loan'
  AND insert_update_step.table_name = 'loan_funding_dim';

-- update loan_funding_dim table_input_step sql to include collateral_tracking_number
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''loan_funding_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        CAST(primary_table.lf_pid as text)  || ''~'' || CAST(1 as text)  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        t380.value as collateral_courier,
        t381.value as funding_status,
        primary_table.lf_release_wire_federal_reference_number as release_wire_federal_reference_number,
        primary_table.lf_interim_funder_fee_amount as interim_funder_fee_amount,
        primary_table.lf_wire_amount as wire_amount,
        primary_table.lf_confirmed_release_datetime as funding_confirmed_release_datetime,
        primary_table.lf_funding_status_type as funding_status_code,
        primary_table.lf_interim_funder_loan_id as interim_funder_loan_id,
        primary_table.lf_pid as loan_funding_pid,
        primary_table.lf_loan_pid as loan_pid,
        primary_table.lf_interim_funder_pid as interim_funder_pid,
        primary_table.lf_early_wire_request as early_wire_request_flag,
        primary_table.lf_scheduled_release_date_auto_compute as scheduled_release_date_auto_compute_flag,
        primary_table.lf_early_wire_total_charge_amount as early_wire_total_charge_amount,
        primary_table.lf_early_wire_daily_charge_amount as early_wire_daily_charge_amount,
        primary_table.lf_early_wire_charge_day_count as early_wire_charge_day_count,
        primary_table.lf_net_wire_amount as net_wire_amount,
        primary_table.lf_post_wire_adjustment_amount as post_wire_adjustment_amount,
        primary_table.lf_collateral_courier_type as collateral_courier_code,
        primary_table.lf_funds_authorized_datetime as funds_authorized_datetime,
        primary_table.lf_funds_authorization_code as funds_authorization_code,
        primary_table.lf_collateral_tracking_number as collateral_tracking_number
 FROM (
    SELECT
        <<loan_funding_partial_load_condition>> as include_record,
        loan_funding.*
    FROM history_octane.loan_funding
        LEFT JOIN history_octane.loan_funding AS history_records ON loan_funding.lf_pid = history_records.lf_pid
            AND loan_funding.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.lf_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<courier_type_partial_load_condition>> as include_record,
            courier_type.*
            FROM history_octane.courier_type
                LEFT JOIN history_octane.courier_type AS history_records ON courier_type.code = history_records.code
                AND courier_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t380 ON primary_table.lf_collateral_courier_type = t380.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<funding_status_type_partial_load_condition>> as include_record,
            funding_status_type.*
            FROM history_octane.funding_status_type
                LEFT JOIN history_octane.funding_status_type AS history_records ON funding_status_type.code = history_records.code
                AND funding_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t381 ON primary_table.lf_funding_status_type = t381.code
 WHERE
    GREATEST(primary_table.include_record, t380.include_record, t381.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
FROM mdi.insert_update_step
WHERE insert_update_step.process_dwid = table_input_step.process_dwid
  AND insert_update_step.schema_name = 'star_loan'
  AND insert_update_step.table_name = 'loan_funding_dim';
