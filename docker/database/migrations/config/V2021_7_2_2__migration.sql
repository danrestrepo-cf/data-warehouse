--
-- EDW | DDL changes - Octane Schema changes for 2021.7.3.0 (7/16/21)
-- https://app.asana.com/0/0/1200594538672335
--

-- Insert edw_table_definition rows for contractor_validation_status_type
WITH staging_table AS (
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                          primary_source_edw_table_definition_dwid)
        VALUES ('staging', 'staging_octane', 'contractor_validation_status_type', NULL)
        RETURNING dwid
)

INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name,
                                      primary_source_edw_table_definition_dwid)
    SELECT 'staging', 'history_octane', 'contractor_validation_status_type', staging_table.dwid
    FROM staging_table;

-- Insert edw_field_definition and mdi configuration rows for new columns (including those from new table)
WITH new_staging_and_history_columns (table_name, field_name, key_field_flag, field_order) AS (
    VALUES
        -- contractor_validation_status_type
        ('contractor_validation_status_type', 'code', TRUE, 1)
        , ('contractor_validation_status_type', 'value', FALSE, 2)
        -- mcr_loan
        , ('mcr_loan', 'mcrl_financed_property_improvements_category_type', FALSE, 48)
        -- deal_check_type
        , ('deal_check_type', 'dct_id_num', FALSE, 4)
        -- place
        , ('place', 'pl_acquisition_date_verified', FALSE, 221)
        , ('place', 'pl_acquisition_cost_amount_verified', FALSE, 222)
        , ('place', 'pl_property_tax_id_verified', FALSE, 223)
        , ('place', 'pl_seller_acquired_date_verified', FALSE, 224)
        , ('place', 'pl_seller_original_cost_amount_verified', FALSE, 225)
        -- contractor
        , ('contractor', 'ctr_verified', FALSE, 22)
        , ('contractor', 'ctr_validation_status_type', FALSE, 23)
        -- appraisal
        , ('appraisal', 'apr_second_decision_appraisal', FALSE, 103)
)

, new_history_only_columns (table_name, field_name, key_field_flag, field_order) AS (
    VALUES
        -- contractor_validation_status_type
        ('contractor_validation_status_type', 'data_source_updated_datetime', FALSE, 3)
        , ('contractor_validation_status_type', 'data_source_deleted_flag', FALSE, 4)
)

, all_new_columns (table_name, field_name, key_field_flag, field_order) AS (
    SELECT *
    FROM new_staging_and_history_columns
    UNION ALL
    SELECT *
    FROM new_history_only_columns
)

, insert_staging_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
        SELECT edw_table_definition.dwid, new_staging_and_history_columns.field_name,
            new_staging_and_history_columns.key_field_flag
        FROM new_staging_and_history_columns
            JOIN mdi.edw_table_definition
                ON new_staging_and_history_columns.table_name = edw_table_definition.table_name
                    AND edw_table_definition.schema_name = 'staging_octane'
        RETURNING dwid, field_name
)

, insert_history_field_definitions AS (
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag,
                                          source_edw_field_definition_dwid)
        SELECT edw_table_definition.dwid, all_new_columns.field_name, all_new_columns.key_field_flag,
               insert_staging_field_definitions.dwid
        FROM all_new_columns
            LEFT JOIN insert_staging_field_definitions
                ON all_new_columns.field_name = insert_staging_field_definitions.field_name
            JOIN mdi.edw_table_definition
                ON all_new_columns.table_name = edw_table_definition.table_name
                    AND edw_table_definition.schema_name = 'history_octane'
)

, new_tables (process_name, table_name, json_output_field, sql) AS (
-- contractor_validation_status_type
    VALUES ('SP-100834', 'contractor_validation_status_type', 'code', 'SELECT staging_table.code, staging_table.value, FALSE AS data_source_deleted_flag, now() AS data_source_updated_datetime
FROM staging_octane.contractor_validation_status_type staging_table
    LEFT JOIN history_octane.contractor_validation_status_type history_table
        ON staging_table.code = history_table.code AND staging_table.value = history_table.value
WHERE history_table.code is NULL;')
)

, updated_tables (process_name, table_name, sql) AS (
-- mcr_loan
    VALUES ('SP-100042', 'mcr_loan', '--finding records to insert into history_octane.mcr_loan
SELECT staging_table.mcrl_servicing_transfer_type,
       staging_table.mcrl_pid,
       staging_table.mcrl_version,
       staging_table.mcrl_loan_pid,
       staging_table.mcrl_mcr_snapshot_pid,
       staging_table.mcrl_los_loan_id,
       staging_table.mcrl_originator_nmls_id,
       staging_table.mcrl_loan_amount,
       staging_table.mcrl_lien_priority_type,
       staging_table.mcrl_mortgage_type,
       staging_table.mcrl_interest_only_type,
       staging_table.mcrl_prepay_penalty_schedule_type,
       staging_table.mcrl_ltv_ratio_percent,
       staging_table.mcrl_note_rate_percent,
       staging_table.mcrl_hmda_action_type,
       staging_table.mcrl_hmda_action_date,
       staging_table.mcrl_disclosure_mode_date,
       staging_table.mcrl_decision_credit_score,
       staging_table.mcrl_property_usage_type,
       staging_table.mcrl_doc_level_type,
       staging_table.mcrl_loan_purpose_type,
       staging_table.mcrl_mi_required,
       staging_table.mcrl_proposal_structure_type,
       staging_table.mcrl_subject_property_state,
       staging_table.mcrl_property_category_type,
       staging_table.mcrl_cltv_ratio_percent,
       staging_table.mcrl_funding_status_type,
       staging_table.mcrl_funding_date,
       staging_table.mcrl_loan_amortization_type,
       staging_table.mcrl_product_special_program_type,
       staging_table.mcrl_non_conforming,
       staging_table.mcrl_initial_payment_adjustment_term_months,
       staging_table.mcrl_subsequent_payment_adjustment_term_months,
       staging_table.mcrl_fund_source_type,
       staging_table.mcrl_channel_type,
       staging_table.mcrl_financed_units_count,
       staging_table.mcrl_cash_out_reason_home_improvement,
       staging_table.mcrl_hmda_hoepa_status_type,
       staging_table.mcrl_qualified_mortgage_status_type,
       staging_table.mcrl_lender_fee_total_amount,
       staging_table.mcrl_broker_fee_total_amount,
       staging_table.mcrl_investor_hmda_purchaser_of_loan_type,
       staging_table.mcrl_confirmed_release_datetime,
       staging_table.mcrl_purchase_advice_date,
       staging_table.mcrl_purchasing_beneficiary_investor_pid,
       staging_table.mcrl_mcr_loan_status_type,
       staging_table.mcrl_financed_property_improvements_category_type,
       FALSE as data_source_deleted_flag,
       now() AS data_source_updated_datetime
FROM staging_octane.mcr_loan staging_table
         LEFT JOIN history_octane.mcr_loan history_table on staging_table.mcrl_pid = history_table.mcrl_pid and staging_table.mcrl_version = history_table.mcrl_version
WHERE history_table.mcrl_pid is NULL
UNION ALL
SELECT history_table.mcrl_servicing_transfer_type,
       history_table.mcrl_pid,
       history_table.mcrl_version+1,
       history_table.mcrl_loan_pid,
       history_table.mcrl_mcr_snapshot_pid,
       history_table.mcrl_los_loan_id,
       history_table.mcrl_originator_nmls_id,
       history_table.mcrl_loan_amount,
       history_table.mcrl_lien_priority_type,
       history_table.mcrl_mortgage_type,
       history_table.mcrl_interest_only_type,
       history_table.mcrl_prepay_penalty_schedule_type,
       history_table.mcrl_ltv_ratio_percent,
       history_table.mcrl_note_rate_percent,
       history_table.mcrl_hmda_action_type,
       history_table.mcrl_hmda_action_date,
       history_table.mcrl_disclosure_mode_date,
       history_table.mcrl_decision_credit_score,
       history_table.mcrl_property_usage_type,
       history_table.mcrl_doc_level_type,
       history_table.mcrl_loan_purpose_type,
       history_table.mcrl_mi_required,
       history_table.mcrl_proposal_structure_type,
       history_table.mcrl_subject_property_state,
       history_table.mcrl_property_category_type,
       history_table.mcrl_cltv_ratio_percent,
       history_table.mcrl_funding_status_type,
       history_table.mcrl_funding_date,
       history_table.mcrl_loan_amortization_type,
       history_table.mcrl_product_special_program_type,
       history_table.mcrl_non_conforming,
       history_table.mcrl_initial_payment_adjustment_term_months,
       history_table.mcrl_subsequent_payment_adjustment_term_months,
       history_table.mcrl_fund_source_type,
       history_table.mcrl_channel_type,
       history_table.mcrl_financed_units_count,
       history_table.mcrl_cash_out_reason_home_improvement,
       history_table.mcrl_hmda_hoepa_status_type,
       history_table.mcrl_qualified_mortgage_status_type,
       history_table.mcrl_lender_fee_total_amount,
       history_table.mcrl_broker_fee_total_amount,
       history_table.mcrl_investor_hmda_purchaser_of_loan_type,
       history_table.mcrl_confirmed_release_datetime,
       history_table.mcrl_purchase_advice_date,
       history_table.mcrl_purchasing_beneficiary_investor_pid,
       history_table.mcrl_mcr_loan_status_type,
       history_table.mcrl_financed_property_improvements_category_type,
       TRUE as data_source_deleted_flag,
       now() AS data_source_updated_datetime
FROM history_octane.mcr_loan history_table
         LEFT JOIN staging_octane.mcr_loan staging_table on staging_table.mcrl_pid = history_table.mcrl_pid
WHERE staging_table.mcrl_pid is NULL
  AND not exists (select 1 from history_octane.mcr_loan deleted_records where deleted_records.mcrl_pid = history_table.mcrl_pid and deleted_records.data_source_deleted_flag = True);')

-- deal_check_type
    , ('SP-100467', 'deal_check_type', 'SELECT staging_table.code,
       staging_table.value,
       staging_table.dct_id_num,
       FALSE as data_source_deleted_flag,
       now() AS data_source_updated_datetime
FROM staging_octane.deal_check_type staging_table
         LEFT JOIN history_octane.deal_check_type history_table on staging_table.code = history_table.code AND staging_table.value = history_table.value
WHERE history_table.code is NULL')

-- place
    , ('SP-100012', 'place', '--finding records to insert into history_octane.place
SELECT staging_table.pl_pid,
       staging_table.pl_version,
       staging_table.pl_proposal_pid,
       staging_table.pl_subject_property,
       staging_table.pl_acquisition_date,
       staging_table.pl_financed_units_count,
       staging_table.pl_unit_count,
       staging_table.pl_land_estimated_value_amount,
       staging_table.pl_land_original_cost_amount,
       staging_table.pl_leasehold_expiration_date,
       staging_table.pl_legal_description_type,
       staging_table.pl_legal_description,
       staging_table.pl_property_tax_id,
       staging_table.pl_legal_lot,
       staging_table.pl_legal_block,
       staging_table.pl_legal_section,
       staging_table.pl_project_name,
       staging_table.pl_cpm_project_id,
       staging_table.pl_acquisition_cost_amount,
       staging_table.pl_county_pid,
       staging_table.pl_sub_jurisdiction_name,
       staging_table.pl_recording_district_name,
       staging_table.pl_project_classification_type,
       staging_table.pl_property_category_type,
       staging_table.pl_property_rights_type,
       staging_table.pl_structure_built_year,
       staging_table.pl_structure_built_month,
       staging_table.pl_title_manner_held_type,
       staging_table.pl_title_manner_held_description,
       staging_table.pl_building_status_type,
       staging_table.pl_construction_conversion,
       staging_table.pl_native_american_lands_type,
       staging_table.pl_community_land_trust,
       staging_table.pl_inclusionary_zoning,
       staging_table.pl_unique_dwelling_type,
       staging_table.pl_living_unit_count,
       staging_table.pl_project_design_type,
       staging_table.pl_city,
       staging_table.pl_country,
       staging_table.pl_postal_code,
       staging_table.pl_state,
       staging_table.pl_street1,
       staging_table.pl_street2,
       staging_table.pl_street_tbd,
       staging_table.pl_landlord_first_name,
       staging_table.pl_landlord_last_name,
       staging_table.pl_landlord_middle_name,
       staging_table.pl_landlord_name_suffix,
       staging_table.pl_landlord_company_name,
       staging_table.pl_landlord_title,
       staging_table.pl_landlord_office_phone,
       staging_table.pl_landlord_office_phone_extension,
       staging_table.pl_landlord_mobile_phone,
       staging_table.pl_landlord_email,
       staging_table.pl_landlord_fax,
       staging_table.pl_landlord_city,
       staging_table.pl_landlord_country,
       staging_table.pl_landlord_postal_code,
       staging_table.pl_landlord_state,
       staging_table.pl_landlord_street1,
       staging_table.pl_landlord_street2,
       staging_table.pl_management_first_name,
       staging_table.pl_management_last_name,
       staging_table.pl_management_middle_name,
       staging_table.pl_management_name_suffix,
       staging_table.pl_management_company_name,
       staging_table.pl_management_title,
       staging_table.pl_management_office_phone,
       staging_table.pl_management_office_phone_extension,
       staging_table.pl_management_mobile_phone,
       staging_table.pl_management_email,
       staging_table.pl_management_fax,
       staging_table.pl_management_city,
       staging_table.pl_management_country,
       staging_table.pl_management_postal_code,
       staging_table.pl_management_state,
       staging_table.pl_management_street1,
       staging_table.pl_management_street2,
       staging_table.pl_property_insurance_amount_input_type,
       staging_table.pl_property_tax_amount_input_type,
       staging_table.pl_annual_property_insurance_amount,
       staging_table.pl_annual_property_tax_amount,
       staging_table.pl_monthly_property_insurance_amount,
       staging_table.pl_monthly_hoa_amount,
       staging_table.pl_monthly_mi_amount,
       staging_table.pl_monthly_property_tax_amount,
       staging_table.pl_monthly_lease_ground_rent_amount,
       staging_table.pl_monthly_rent_amount,
       staging_table.pl_monthly_obligation_amount,
       staging_table.pl_use_proposed_property_usage,
       staging_table.pl_property_usage_type,
       staging_table.pl_property_value_amount,
       staging_table.pl_reo_disposition_status_type,
       staging_table.pl_auto_geocode,
       staging_table.pl_auto_geocode_exception,
       staging_table.pl_msa_code,
       staging_table.pl_state_fips,
       staging_table.pl_county_fips,
       staging_table.pl_census_tract,
       staging_table.pl_mh_make,
       staging_table.pl_mh_model,
       staging_table.pl_mh_length,
       staging_table.pl_mh_width,
       staging_table.pl_mh_manufacturer,
       staging_table.pl_mh_serial_number,
       staging_table.pl_mh_hud_label_number,
       staging_table.pl_mh_certificate_of_title_issued,
       staging_table.pl_mh_certificate_of_title_number,
       staging_table.pl_mh_certificate_of_title_type,
       staging_table.pl_mh_loan_purpose_type,
       staging_table.pl_mh_anchored,
       staging_table.pl_coop_company_name,
       staging_table.pl_coop_building_name,
       staging_table.pl_coop_vacant_units,
       staging_table.pl_coop_proprietary_lease_date,
       staging_table.pl_coop_assignment_lease_date,
       staging_table.pl_coop_existing_company_laws_state,
       staging_table.pl_coop_shares_being_purchased,
       staging_table.pl_coop_attorney_in_fact,
       staging_table.pl_coop_stock_certificate_number,
       staging_table.pl_coop_apartment_unit,
       staging_table.pl_rental,
       staging_table.pl_underwriter_comments,
       staging_table.pl_lava_zone_type,
       staging_table.pl_neighborhood_location_type,
       staging_table.pl_site_area,
       staging_table.pl_hud_reo,
       staging_table.pl_va_guaranteed_reo,
       staging_table.pl_va_loan_date,
       staging_table.pl_gross_building_area_square_feet,
       staging_table.pl_project_dwelling_units_sold_count,
       staging_table.pl_prior_owners_title,
       staging_table.pl_prior_owners_title_policy_amount,
       staging_table.pl_prior_owners_title_policy_effective_date,
       staging_table.pl_prior_lenders_title,
       staging_table.pl_prior_lenders_title_policy_amount,
       staging_table.pl_prior_lenders_title_policy_effective_date,
       staging_table.pl_bedroom_count_unit_1,
       staging_table.pl_bedroom_count_unit_2,
       staging_table.pl_bedroom_count_unit_3,
       staging_table.pl_bedroom_count_unit_4,
       staging_table.pl_rent_amount_unit_1,
       staging_table.pl_rent_amount_unit_2,
       staging_table.pl_rent_amount_unit_3,
       staging_table.pl_rent_amount_unit_4,
       staging_table.pl_listed_for_sale_in_last_6_months,
       staging_table.pl_property_in_borrower_trust,
       staging_table.pl_road_type,
       staging_table.pl_water_type,
       staging_table.pl_sanitation_type,
       staging_table.pl_survey_required,
       staging_table.pl_solar_panels_type,
       staging_table.pl_power_purchase_agreement,
       staging_table.pl_solar_panel_provider_name,
       staging_table.pl_seller_acquired_date,
       staging_table.pl_seller_original_cost_amount,
       staging_table.pl_remaining_economic_life_years,
       staging_table.pl_bathroom_count_unit_1,
       staging_table.pl_bathroom_count_unit_2,
       staging_table.pl_bathroom_count_unit_3,
       staging_table.pl_bathroom_count_unit_4,
       staging_table.pl_total_room_count_unit_1,
       staging_table.pl_total_room_count_unit_2,
       staging_table.pl_total_room_count_unit_3,
       staging_table.pl_total_room_count_unit_4,
       staging_table.pl_gross_living_area_square_feet_unit_1,
       staging_table.pl_gross_living_area_square_feet_unit_2,
       staging_table.pl_gross_living_area_square_feet_unit_3,
       staging_table.pl_gross_living_area_square_feet_unit_4,
       staging_table.pl_mh_leasehold__property_interest_type,
       staging_table.pl_tribe_name,
       staging_table.pl_leasehold_begin_date,
       staging_table.pl_lease_number,
       staging_table.pl_property_inspection_required,
       staging_table.pl_hvac_inspection_required,
       staging_table.pl_pest_inspection_required,
       staging_table.pl_radon_inspection_required,
       staging_table.pl_septic_inspection_required,
       staging_table.pl_water_well_inspection_required,
       staging_table.pl_structural_inspection_required,
       staging_table.pl_pest_inspection_required_auto_compute,
       staging_table.pl_management_agent_federal_tax_id,
       staging_table.pl_mh_manufacturer_street_1,
       staging_table.pl_mh_manufacturer_street_2,
       staging_table.pl_mh_manufacturer_city,
       staging_table.pl_mh_manufacturer_state,
       staging_table.pl_mh_manufacturer_postal_code,
       staging_table.pl_mh_manufacturer_phone,
       staging_table.pl_mh_manufacturer_phone_extension,
       staging_table.pl_recording_city_name,
       staging_table.pl_abbreviated_legal_description,
       staging_table.pl_geocode_service_disabled,
       staging_table.pl_vesting_confirmed,
       staging_table.pl_previous_title_manner_held_description,
       staging_table.pl_legal_lot_na,
       staging_table.pl_legal_block_na,
       staging_table.pl_legal_section_na,
       staging_table.pl_legal_description_confirmed,
       staging_table.pl_lead_inspection_required,
       staging_table.pl_calculated_lead_inspection_required,
       staging_table.pl_geocode_system_error,
       staging_table.pl_mixed_use,
       staging_table.pl_mixed_use_verified,
       staging_table.pl_mixed_use_area_square_feet,
       staging_table.pl_mixed_use_area_square_feet_verified,
       staging_table.pl_mixed_use_area_percent,
       staging_table.pl_trust_classification_type,
       staging_table.pl_additional_building_area_square_feet,
       staging_table.pl_acquisition_date_verified,
       staging_table.pl_acquisition_cost_amount_verified,
       staging_table.pl_property_tax_id_verified,
       staging_table.pl_seller_acquired_date_verified,
       staging_table.pl_seller_original_cost_amount_verified,
       FALSE as data_source_deleted_flag,
       now() AS data_source_updated_datetime
FROM staging_octane.place staging_table
         LEFT JOIN history_octane.place history_table on staging_table.pl_pid = history_table.pl_pid and staging_table.pl_version = history_table.pl_version
WHERE history_table.pl_pid is NULL
UNION ALL
SELECT history_table.pl_pid,
       history_table.pl_version+1,
       history_table.pl_proposal_pid,
       history_table.pl_subject_property,
       history_table.pl_acquisition_date,
       history_table.pl_financed_units_count,
       history_table.pl_unit_count,
       history_table.pl_land_estimated_value_amount,
       history_table.pl_land_original_cost_amount,
       history_table.pl_leasehold_expiration_date,
       history_table.pl_legal_description_type,
       history_table.pl_legal_description,
       history_table.pl_property_tax_id,
       history_table.pl_legal_lot,
       history_table.pl_legal_block,
       history_table.pl_legal_section,
       history_table.pl_project_name,
       history_table.pl_cpm_project_id,
       history_table.pl_acquisition_cost_amount,
       history_table.pl_county_pid,
       history_table.pl_sub_jurisdiction_name,
       history_table.pl_recording_district_name,
       history_table.pl_project_classification_type,
       history_table.pl_property_category_type,
       history_table.pl_property_rights_type,
       history_table.pl_structure_built_year,
       history_table.pl_structure_built_month,
       history_table.pl_title_manner_held_type,
       history_table.pl_title_manner_held_description,
       history_table.pl_building_status_type,
       history_table.pl_construction_conversion,
       history_table.pl_native_american_lands_type,
       history_table.pl_community_land_trust,
       history_table.pl_inclusionary_zoning,
       history_table.pl_unique_dwelling_type,
       history_table.pl_living_unit_count,
       history_table.pl_project_design_type,
       history_table.pl_city,
       history_table.pl_country,
       history_table.pl_postal_code,
       history_table.pl_state,
       history_table.pl_street1,
       history_table.pl_street2,
       history_table.pl_street_tbd,
       history_table.pl_landlord_first_name,
       history_table.pl_landlord_last_name,
       history_table.pl_landlord_middle_name,
       history_table.pl_landlord_name_suffix,
       history_table.pl_landlord_company_name,
       history_table.pl_landlord_title,
       history_table.pl_landlord_office_phone,
       history_table.pl_landlord_office_phone_extension,
       history_table.pl_landlord_mobile_phone,
       history_table.pl_landlord_email,
       history_table.pl_landlord_fax,
       history_table.pl_landlord_city,
       history_table.pl_landlord_country,
       history_table.pl_landlord_postal_code,
       history_table.pl_landlord_state,
       history_table.pl_landlord_street1,
       history_table.pl_landlord_street2,
       history_table.pl_management_first_name,
       history_table.pl_management_last_name,
       history_table.pl_management_middle_name,
       history_table.pl_management_name_suffix,
       history_table.pl_management_company_name,
       history_table.pl_management_title,
       history_table.pl_management_office_phone,
       history_table.pl_management_office_phone_extension,
       history_table.pl_management_mobile_phone,
       history_table.pl_management_email,
       history_table.pl_management_fax,
       history_table.pl_management_city,
       history_table.pl_management_country,
       history_table.pl_management_postal_code,
       history_table.pl_management_state,
       history_table.pl_management_street1,
       history_table.pl_management_street2,
       history_table.pl_property_insurance_amount_input_type,
       history_table.pl_property_tax_amount_input_type,
       history_table.pl_annual_property_insurance_amount,
       history_table.pl_annual_property_tax_amount,
       history_table.pl_monthly_property_insurance_amount,
       history_table.pl_monthly_hoa_amount,
       history_table.pl_monthly_mi_amount,
       history_table.pl_monthly_property_tax_amount,
       history_table.pl_monthly_lease_ground_rent_amount,
       history_table.pl_monthly_rent_amount,
       history_table.pl_monthly_obligation_amount,
       history_table.pl_use_proposed_property_usage,
       history_table.pl_property_usage_type,
       history_table.pl_property_value_amount,
       history_table.pl_reo_disposition_status_type,
       history_table.pl_auto_geocode,
       history_table.pl_auto_geocode_exception,
       history_table.pl_msa_code,
       history_table.pl_state_fips,
       history_table.pl_county_fips,
       history_table.pl_census_tract,
       history_table.pl_mh_make,
       history_table.pl_mh_model,
       history_table.pl_mh_length,
       history_table.pl_mh_width,
       history_table.pl_mh_manufacturer,
       history_table.pl_mh_serial_number,
       history_table.pl_mh_hud_label_number,
       history_table.pl_mh_certificate_of_title_issued,
       history_table.pl_mh_certificate_of_title_number,
       history_table.pl_mh_certificate_of_title_type,
       history_table.pl_mh_loan_purpose_type,
       history_table.pl_mh_anchored,
       history_table.pl_coop_company_name,
       history_table.pl_coop_building_name,
       history_table.pl_coop_vacant_units,
       history_table.pl_coop_proprietary_lease_date,
       history_table.pl_coop_assignment_lease_date,
       history_table.pl_coop_existing_company_laws_state,
       history_table.pl_coop_shares_being_purchased,
       history_table.pl_coop_attorney_in_fact,
       history_table.pl_coop_stock_certificate_number,
       history_table.pl_coop_apartment_unit,
       history_table.pl_rental,
       history_table.pl_underwriter_comments,
       history_table.pl_lava_zone_type,
       history_table.pl_neighborhood_location_type,
       history_table.pl_site_area,
       history_table.pl_hud_reo,
       history_table.pl_va_guaranteed_reo,
       history_table.pl_va_loan_date,
       history_table.pl_gross_building_area_square_feet,
       history_table.pl_project_dwelling_units_sold_count,
       history_table.pl_prior_owners_title,
       history_table.pl_prior_owners_title_policy_amount,
       history_table.pl_prior_owners_title_policy_effective_date,
       history_table.pl_prior_lenders_title,
       history_table.pl_prior_lenders_title_policy_amount,
       history_table.pl_prior_lenders_title_policy_effective_date,
       history_table.pl_bedroom_count_unit_1,
       history_table.pl_bedroom_count_unit_2,
       history_table.pl_bedroom_count_unit_3,
       history_table.pl_bedroom_count_unit_4,
       history_table.pl_rent_amount_unit_1,
       history_table.pl_rent_amount_unit_2,
       history_table.pl_rent_amount_unit_3,
       history_table.pl_rent_amount_unit_4,
       history_table.pl_listed_for_sale_in_last_6_months,
       history_table.pl_property_in_borrower_trust,
       history_table.pl_road_type,
       history_table.pl_water_type,
       history_table.pl_sanitation_type,
       history_table.pl_survey_required,
       history_table.pl_solar_panels_type,
       history_table.pl_power_purchase_agreement,
       history_table.pl_solar_panel_provider_name,
       history_table.pl_seller_acquired_date,
       history_table.pl_seller_original_cost_amount,
       history_table.pl_remaining_economic_life_years,
       history_table.pl_bathroom_count_unit_1,
       history_table.pl_bathroom_count_unit_2,
       history_table.pl_bathroom_count_unit_3,
       history_table.pl_bathroom_count_unit_4,
       history_table.pl_total_room_count_unit_1,
       history_table.pl_total_room_count_unit_2,
       history_table.pl_total_room_count_unit_3,
       history_table.pl_total_room_count_unit_4,
       history_table.pl_gross_living_area_square_feet_unit_1,
       history_table.pl_gross_living_area_square_feet_unit_2,
       history_table.pl_gross_living_area_square_feet_unit_3,
       history_table.pl_gross_living_area_square_feet_unit_4,
       history_table.pl_mh_leasehold__property_interest_type,
       history_table.pl_tribe_name,
       history_table.pl_leasehold_begin_date,
       history_table.pl_lease_number,
       history_table.pl_property_inspection_required,
       history_table.pl_hvac_inspection_required,
       history_table.pl_pest_inspection_required,
       history_table.pl_radon_inspection_required,
       history_table.pl_septic_inspection_required,
       history_table.pl_water_well_inspection_required,
       history_table.pl_structural_inspection_required,
       history_table.pl_pest_inspection_required_auto_compute,
       history_table.pl_management_agent_federal_tax_id,
       history_table.pl_mh_manufacturer_street_1,
       history_table.pl_mh_manufacturer_street_2,
       history_table.pl_mh_manufacturer_city,
       history_table.pl_mh_manufacturer_state,
       history_table.pl_mh_manufacturer_postal_code,
       history_table.pl_mh_manufacturer_phone,
       history_table.pl_mh_manufacturer_phone_extension,
       history_table.pl_recording_city_name,
       history_table.pl_abbreviated_legal_description,
       history_table.pl_geocode_service_disabled,
       history_table.pl_vesting_confirmed,
       history_table.pl_previous_title_manner_held_description,
       history_table.pl_legal_lot_na,
       history_table.pl_legal_block_na,
       history_table.pl_legal_section_na,
       history_table.pl_legal_description_confirmed,
       history_table.pl_lead_inspection_required,
       history_table.pl_calculated_lead_inspection_required,
       history_table.pl_geocode_system_error,
       history_table.pl_mixed_use,
       history_table.pl_mixed_use_verified,
       history_table.pl_mixed_use_area_square_feet,
       history_table.pl_mixed_use_area_square_feet_verified,
       history_table.pl_mixed_use_area_percent,
       history_table.pl_trust_classification_type,
       history_table.pl_additional_building_area_square_feet,
       history_table.pl_acquisition_date_verified,
       history_table.pl_acquisition_cost_amount_verified,
       history_table.pl_property_tax_id_verified,
       history_table.pl_seller_acquired_date_verified,
       history_table.pl_seller_original_cost_amount_verified,
       TRUE as data_source_deleted_flag,
       now() AS data_source_updated_datetime
FROM history_octane.place history_table
         LEFT JOIN staging_octane.place staging_table on staging_table.pl_pid = history_table.pl_pid
WHERE staging_table.pl_pid is NULL
  AND not exists (select 1 from history_octane.place deleted_records where deleted_records.pl_pid = history_table.pl_pid and deleted_records.data_source_deleted_flag = True);')

-- contractor
    , ('SP-100062', 'contractor', '--finding records to insert into history_octane.contractor
SELECT staging_table.ctr_pid,
       staging_table.ctr_version,
       staging_table.ctr_account_pid,
       staging_table.ctr_contractor_company_name,
       staging_table.ctr_max_construction_credit_amount,
       staging_table.ctr_taxpayer_identifier_type,
       staging_table.ctr_first_name,
       staging_table.ctr_last_name,
       staging_table.ctr_work_phone,
       staging_table.ctr_work_phone_extension,
       staging_table.ctr_mobile_phone,
       staging_table.ctr_fax,
       staging_table.ctr_email,
       staging_table.ctr_address_street1,
       staging_table.ctr_address_street2,
       staging_table.ctr_address_city,
       staging_table.ctr_address_state,
       staging_table.ctr_address_postal_code,
       staging_table.ctr_address_country,
       staging_table.ctr_notes,
       staging_table.ctr_verified,
       staging_table.ctr_validation_status_type,
       FALSE as data_source_deleted_flag,
       now() AS data_source_updated_datetime
FROM staging_octane.contractor staging_table
         LEFT JOIN history_octane.contractor history_table on staging_table.ctr_pid = history_table.ctr_pid and staging_table.ctr_version = history_table.ctr_version
WHERE history_table.ctr_pid is NULL
UNION ALL
SELECT history_table.ctr_pid,
       history_table.ctr_version+1,
       history_table.ctr_account_pid,
       history_table.ctr_contractor_company_name,
       history_table.ctr_max_construction_credit_amount,
       history_table.ctr_taxpayer_identifier_type,
       history_table.ctr_first_name,
       history_table.ctr_last_name,
       history_table.ctr_work_phone,
       history_table.ctr_work_phone_extension,
       history_table.ctr_mobile_phone,
       history_table.ctr_fax,
       history_table.ctr_email,
       history_table.ctr_address_street1,
       history_table.ctr_address_street2,
       history_table.ctr_address_city,
       history_table.ctr_address_state,
       history_table.ctr_address_postal_code,
       history_table.ctr_address_country,
       history_table.ctr_notes,
       history_table.ctr_verified,
       history_table.ctr_validation_status_type,
       TRUE as data_source_deleted_flag,
       now() AS data_source_updated_datetime
FROM history_octane.contractor history_table
         LEFT JOIN staging_octane.contractor staging_table on staging_table.ctr_pid = history_table.ctr_pid
WHERE staging_table.ctr_pid is NULL
  AND not exists (select 1 from history_octane.contractor deleted_records where deleted_records.ctr_pid = history_table.ctr_pid and deleted_records.data_source_deleted_flag = True)')

-- appraisal
    , ('SP-100005', 'appraisal', '--finding records to insert into history_octane.appraisal
SELECT staging_table.apr_appraisal_invoice_amount,
       staging_table.apr_pid,
       staging_table.apr_version,
       staging_table.apr_appraised_value_amount,
       staging_table.apr_effective_date,
       staging_table.apr_deal_pid,
       staging_table.apr_decision_appraisal,
       staging_table.apr_appraisal_condition_type,
       staging_table.apr_appraiser_address_city,
       staging_table.apr_appraiser_address_country,
       staging_table.apr_appraiser_address_postal_code,
       staging_table.apr_appraiser_address_state,
       staging_table.apr_appraiser_address_street1,
       staging_table.apr_appraiser_address_street2,
       staging_table.apr_appraiser_company_name,
       staging_table.apr_appraiser_email,
       staging_table.apr_appraiser_fax,
       staging_table.apr_appraiser_first_name,
       staging_table.apr_appraiser_last_name,
       staging_table.apr_appraiser_middle_name,
       staging_table.apr_appraiser_mobile_phone,
       staging_table.apr_appraiser_name_suffix,
       staging_table.apr_appraiser_office_phone,
       staging_table.apr_appraiser_office_phone_extension,
       staging_table.apr_appraiser_title,
       staging_table.apr_appraiser_license_number,
       staging_table.apr_appraiser_supervisory_license_number,
       staging_table.apr_appraiser_license_state,
       staging_table.apr_appraisal_order_status_type,
       staging_table.apr_appraisal_order_id,
       staging_table.apr_appraisal_order_instructions,
       staging_table.apr_property_address_city,
       staging_table.apr_property_address_country,
       staging_table.apr_property_address_postal_code,
       staging_table.apr_property_address_state,
       staging_table.apr_property_address_street1,
       staging_table.apr_property_address_street2,
       staging_table.apr_property_county_name,
       staging_table.apr_obtained_from_transfer,
       staging_table.apr_hud_provided,
       staging_table.apr_bedroom_count_unit_1,
       staging_table.apr_bedroom_count_unit_2,
       staging_table.apr_bedroom_count_unit_3,
       staging_table.apr_bedroom_count_unit_4,
       staging_table.apr_bathroom_count_unit_1,
       staging_table.apr_bathroom_count_unit_2,
       staging_table.apr_bathroom_count_unit_3,
       staging_table.apr_bathroom_count_unit_4,
       staging_table.apr_total_room_count_unit_1,
       staging_table.apr_total_room_count_unit_2,
       staging_table.apr_total_room_count_unit_3,
       staging_table.apr_total_room_count_unit_4,
       staging_table.apr_gross_living_area_square_feet_unit_1,
       staging_table.apr_gross_living_area_square_feet_unit_2,
       staging_table.apr_gross_living_area_square_feet_unit_3,
       staging_table.apr_gross_living_area_square_feet_unit_4,
       staging_table.apr_appraisal_underwriter_type,
       staging_table.apr_ucdp_doc_file_id,
       staging_table.apr_inspection_date,
       staging_table.apr_appraisal_reference_id,
       staging_table.apr_ucdp_ssr_id,
       staging_table.apr_sale_price_amount,
       staging_table.apr_property_tax_id,
       staging_table.apr_property_category_type,
       staging_table.apr_cost_to_build_new,
       staging_table.apr_monthly_hoa_amount,
       staging_table.apr_structure_built_year,
       staging_table.apr_structure_built_month,
       staging_table.apr_project_name,
       staging_table.apr_road_type,
       staging_table.apr_water_type,
       staging_table.apr_sanitation_type,
       staging_table.apr_neighborhood_location_type,
       staging_table.apr_site_area,
       staging_table.apr_due_date,
       staging_table.apr_order_date,
       staging_table.apr_payment_type,
       staging_table.apr_payment_received_date,
       staging_table.apr_appraisal_source_type,
       staging_table.apr_appraisal_purpose_type,
       staging_table.apr_exclude,
       staging_table.apr_order_appraisal,
       staging_table.apr_appraisal_id,
       staging_table.apr_mortgage_type,
       staging_table.apr_remaining_economic_life_years,
       staging_table.apr_deficient_economic_life_explanation,
       staging_table.apr_hve_point_value_estimate_amount,
       staging_table.apr_hve_forecast_standard_deviation_percent,
       staging_table.apr_hve_confidence_level_type,
       staging_table.apr_hve_variance_percent,
       staging_table.apr_hve_excessive_value_message,
       staging_table.apr_cu_risk_score,
       staging_table.apr_license_expiration_date,
       staging_table.apr_supervisor_required,
       staging_table.apr_supervisory_appraiser_first_name,
       staging_table.apr_supervisory_appraiser_middle_name,
       staging_table.apr_supervisory_appraiser_last_name,
       staging_table.apr_supervisory_appraiser_name_suffix,
       staging_table.apr_supervisory_license_state,
       staging_table.apr_supervisory_license_expiration_date,
       staging_table.apr_synthetic_unique,
       staging_table.apr_second_decision_appraisal,
       FALSE as data_source_deleted_flag,
       now() AS data_source_updated_datetime
FROM staging_octane.appraisal staging_table
         LEFT JOIN history_octane.appraisal history_table on staging_table.apr_pid = history_table.apr_pid and staging_table.apr_version = history_table.apr_version
WHERE history_table.apr_pid is NULL
UNION ALL
SELECT history_table.apr_appraisal_invoice_amount,
       history_table.apr_pid,
       history_table.apr_version+1,
       history_table.apr_appraised_value_amount,
       history_table.apr_effective_date,
       history_table.apr_deal_pid,
       history_table.apr_decision_appraisal,
       history_table.apr_appraisal_condition_type,
       history_table.apr_appraiser_address_city,
       history_table.apr_appraiser_address_country,
       history_table.apr_appraiser_address_postal_code,
       history_table.apr_appraiser_address_state,
       history_table.apr_appraiser_address_street1,
       history_table.apr_appraiser_address_street2,
       history_table.apr_appraiser_company_name,
       history_table.apr_appraiser_email,
       history_table.apr_appraiser_fax,
       history_table.apr_appraiser_first_name,
       history_table.apr_appraiser_last_name,
       history_table.apr_appraiser_middle_name,
       history_table.apr_appraiser_mobile_phone,
       history_table.apr_appraiser_name_suffix,
       history_table.apr_appraiser_office_phone,
       history_table.apr_appraiser_office_phone_extension,
       history_table.apr_appraiser_title,
       history_table.apr_appraiser_license_number,
       history_table.apr_appraiser_supervisory_license_number,
       history_table.apr_appraiser_license_state,
       history_table.apr_appraisal_order_status_type,
       history_table.apr_appraisal_order_id,
       history_table.apr_appraisal_order_instructions,
       history_table.apr_property_address_city,
       history_table.apr_property_address_country,
       history_table.apr_property_address_postal_code,
       history_table.apr_property_address_state,
       history_table.apr_property_address_street1,
       history_table.apr_property_address_street2,
       history_table.apr_property_county_name,
       history_table.apr_obtained_from_transfer,
       history_table.apr_hud_provided,
       history_table.apr_bedroom_count_unit_1,
       history_table.apr_bedroom_count_unit_2,
       history_table.apr_bedroom_count_unit_3,
       history_table.apr_bedroom_count_unit_4,
       history_table.apr_bathroom_count_unit_1,
       history_table.apr_bathroom_count_unit_2,
       history_table.apr_bathroom_count_unit_3,
       history_table.apr_bathroom_count_unit_4,
       history_table.apr_total_room_count_unit_1,
       history_table.apr_total_room_count_unit_2,
       history_table.apr_total_room_count_unit_3,
       history_table.apr_total_room_count_unit_4,
       history_table.apr_gross_living_area_square_feet_unit_1,
       history_table.apr_gross_living_area_square_feet_unit_2,
       history_table.apr_gross_living_area_square_feet_unit_3,
       history_table.apr_gross_living_area_square_feet_unit_4,
       history_table.apr_appraisal_underwriter_type,
       history_table.apr_ucdp_doc_file_id,
       history_table.apr_inspection_date,
       history_table.apr_appraisal_reference_id,
       history_table.apr_ucdp_ssr_id,
       history_table.apr_sale_price_amount,
       history_table.apr_property_tax_id,
       history_table.apr_property_category_type,
       history_table.apr_cost_to_build_new,
       history_table.apr_monthly_hoa_amount,
       history_table.apr_structure_built_year,
       history_table.apr_structure_built_month,
       history_table.apr_project_name,
       history_table.apr_road_type,
       history_table.apr_water_type,
       history_table.apr_sanitation_type,
       history_table.apr_neighborhood_location_type,
       history_table.apr_site_area,
       history_table.apr_due_date,
       history_table.apr_order_date,
       history_table.apr_payment_type,
       history_table.apr_payment_received_date,
       history_table.apr_appraisal_source_type,
       history_table.apr_appraisal_purpose_type,
       history_table.apr_exclude,
       history_table.apr_order_appraisal,
       history_table.apr_appraisal_id,
       history_table.apr_mortgage_type,
       history_table.apr_remaining_economic_life_years,
       history_table.apr_deficient_economic_life_explanation,
       history_table.apr_hve_point_value_estimate_amount,
       history_table.apr_hve_forecast_standard_deviation_percent,
       history_table.apr_hve_confidence_level_type,
       history_table.apr_hve_variance_percent,
       history_table.apr_hve_excessive_value_message,
       history_table.apr_cu_risk_score,
       history_table.apr_license_expiration_date,
       history_table.apr_supervisor_required,
       history_table.apr_supervisory_appraiser_first_name,
       history_table.apr_supervisory_appraiser_middle_name,
       history_table.apr_supervisory_appraiser_last_name,
       history_table.apr_supervisory_appraiser_name_suffix,
       history_table.apr_supervisory_license_state,
       history_table.apr_supervisory_license_expiration_date,
       history_table.apr_synthetic_unique,
       history_table.apr_second_decision_appraisal,
       TRUE as data_source_deleted_flag,
       now() AS data_source_updated_datetime
FROM history_octane.appraisal history_table
         LEFT JOIN staging_octane.appraisal staging_table on staging_table.apr_pid = history_table.apr_pid
WHERE staging_table.apr_pid is NULL
  AND not exists (select 1 from history_octane.appraisal deleted_records where deleted_records.apr_pid = history_table.apr_pid and deleted_records.data_source_deleted_flag = True);')
)

, new_table_processes AS (
    INSERT INTO mdi.process (name, description)
        SELECT new_tables.process_name, 'ETL to copy ' || table_name || ' data from staging_octane to history_octane'
        FROM new_tables
            RETURNING dwid, name AS process_name
)

, new_table_input_steps AS (
    INSERT INTO mdi.table_input_step (process_dwid
        , data_source_dwid
        , sql
        , limit_size
        , execute_for_each_row
        , replace_variables
        , enable_lazy_conversion
        , cached_row_meta
        , connectionname
    )
        SELECT new_table_processes.dwid
            , 0
            , new_tables.sql
            , 0
            , 'N'
            , 'N'
            , 'N'
            , 'N'
            , 'Staging DB Connection'
        FROM new_tables
            JOIN new_table_processes
                ON new_tables.process_name = new_table_processes.process_name
)

, updated_table_input_steps AS (
    UPDATE mdi.table_input_step
        SET sql = updated_tables.sql
        FROM updated_tables
            JOIN mdi.process
                ON process.name = updated_tables.process_name
        WHERE table_input_step.dwid = process.dwid
)

, new_table_output_steps AS (
    INSERT INTO mdi.table_output_step (process_dwid
        , target_schema
        , target_table
        , commit_size
        , partitioning_field
        , table_name_field
        , auto_generated_key_field
        , partition_data_per
        , table_name_defined_in_field
        , return_auto_generated_key_field
        , truncate_table
        , connectionname
        , partition_over_tables
        , specify_database_fields
        , ignore_insert_errors
        , use_batch_update
    )
        SELECT new_table_processes.dwid
             , 'history_octane'
             , new_tables.table_name
             , 1000
             , NULL
             , NULL
             , NULL
             , NULL
             , 'N'
             , NULL
             , 'N'
             , 'Staging DB Connection'
             , 'N'
             , 'Y'
             , 'N'
             , 'N'
        FROM new_tables
                 JOIN new_table_processes
                      ON new_tables.process_name = new_table_processes.process_name
        RETURNING dwid, target_table
)

, new_table_output_fields AS (
    INSERT INTO mdi.table_output_field (table_output_step_dwid
        , database_field_name, database_stream_name
        , field_order
        , is_sensitive)
            SELECT table_output_step.dwid
                 , all_new_columns.field_name
                 , all_new_columns.field_name
                 , all_new_columns.field_order
                 , FALSE
            FROM all_new_columns
            JOIN (
                SELECT dwid, target_table
                FROM mdi.table_output_step
                    JOIN all_new_columns
                        ON all_new_columns.table_name = table_output_step.target_table
                            AND table_output_step.target_schema = 'history_octane'
                UNION ALL
                SELECT dwid
                    , target_table
                FROM new_table_output_steps
            ) AS table_output_step
                ON table_output_step.target_table = all_new_columns.table_name
)

, new_json_output_steps AS (
    INSERT INTO mdi.json_output_field (process_dwid, field_name)
        SELECT new_table_processes.dwid, new_tables.json_output_field
        FROM new_tables
            JOIN new_table_processes
                ON new_tables.process_name = new_table_processes.process_name
)

, new_state_machine_definitions AS (
    INSERT INTO mdi.state_machine_definition (process_dwid, name, comment)
        SELECT new_table_processes.dwid
             , new_table_processes.process_name
             , 'ETL to copy ' || new_tables.table_name || ' data from staging_octane to history_octane'
        FROM new_tables
            JOIN new_table_processes
                ON new_tables.process_name = new_table_processes.process_name
)

SELECT 'Finished loading new Octane catch up metadata';