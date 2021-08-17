--
-- EDW - DMI Passport data load (SP-7) (https://app.asana.com/0/0/1182841661698329 )
--

-- populate edw_table_definition with data for newly created table ingress.dmi.passport
WITH cte_edw_table_definition as (INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
    VALUES ('ingress', 'dmi', 'passport', NULL)
    RETURNING dwid)

    , cte_new_fields (field_name, key_field_flag) AS (
    VALUES ('etl_batch_id',FALSE)
         , ('data_source_dwid',TRUE)
         , ('input_filename',FALSE)
         , ('loan_number',TRUE)
         , ('old_loan_number',FALSE)
         , ('new_servicer_loan_number',FALSE)
         , ('user_03_position_field_3a',FALSE)
         , ('first_due_date',FALSE)
         , ('loan_closing_date',FALSE)
         , ('loan_purpose_code',FALSE)
         , ('loan_purpose_code_description',FALSE)
         , ('note_date',FALSE)
         , ('acquisition_date',FALSE)
         , ('original_interest_rate',FALSE)
         , ('original_loan_term',FALSE)
         , ('original_mortgage_amount',FALSE)
         , ('original_p_and_i_amount',FALSE)
         , ('original_property_value_amount',FALSE)
         , ('original_second_interest_rate',FALSE)
         , ('original_second_loan_term',FALSE)
         , ('original_second_mtg_amount',FALSE)
         , ('original_second_p_and_i',FALSE)
         , ('original_loan_to_value_ratio',FALSE)
         , ('annual_interest_rate',FALSE)
         , ('arm_indicator',FALSE)
         , ('drafting_indicator',FALSE)
         , ('draft_option_code',FALSE)
         , ('draft_delay_days_quantity',FALSE)
         , ('billing_mode',FALSE)
         , ('coupon_tape_date',FALSE)
         , ('coupon_bill_last_create_date',FALSE)
         , ('def_int_balance',FALSE)
         , ('distribution_type',FALSE)
         , ('loan_to_value_ratio',FALSE)
         , ('first_p_and_i_amount',FALSE)
         , ('first_principal_balance',FALSE)
         , ('el_status_indicator',FALSE)
         , ('interest_only_expire_date',FALSE)
         , ('interest_only_loan_indicator',FALSE)
         , ('qualified_mortgage_code',FALSE)
         , ('qualified_mortgage_code_description',FALSE)
         , ('higher_priced_indicator',FALSE)
         , ('higher_priced_indicator_description',FALSE)
         , ('high_cost_type',FALSE)
         , ('high_cost_type_description',FALSE)
         , ('escrow_waiver_code',FALSE)
         , ('escrow_waiver_code_description',FALSE)
         , ('escrow_waiver_date',FALSE)
         , ('investor_loan_number',FALSE)
         , ('investor_id',FALSE)
         , ('category_code',FALSE)
         , ('first_service_fee_rate',FALSE)
         , ('pool_number',FALSE)
         , ('pool_class_code',FALSE)
         , ('pool_contract_number',FALSE)
         , ('gse_code',FALSE)
         , ('gse_code_description',FALSE)
         , ('hi_type',FALSE)
         , ('hi_type_description',FALSE)
         , ('lo_type',FALSE)
         , ('lo_type_description',FALSE)
         , ('development_type',FALSE)
         , ('development_type_description',FALSE)
         , ('second_hi_type',FALSE)
         , ('bl_balloon_status_code',FALSE)
         , ('bl_balloon_status_code_description',FALSE)
         , ('balloon_status_code',FALSE)
         , ('balloon_status_code_description',FALSE)
         , ('loan_matures_date',FALSE)
         , ('loan_term',FALSE)
         , ('remaining_term',FALSE)
         , ('man_code',FALSE)
         , ('man_code_description',FALSE)
         , ('mers_id',FALSE)
         , ('mers_original_mortgagee_ind',FALSE)
         , ('mers_original_mortgagee_ind_description',FALSE)
         , ('mers_registration_status_code',FALSE)
         , ('mers_registration_date',FALSE)
         , ('mers_id_number_status_code',FALSE)
         , ('mers_assigned_date',FALSE)
         , ('next_payment_due_date',FALSE)
         , ('last_full_payment_date',FALSE)
         , ('due_date_day_portion_parsed',FALSE)
         , ('payment_period',FALSE)
         , ('payment_option_code',FALSE)
         , ('payment_option_code_description',FALSE)
         , ('suspense_balance',FALSE)
         , ('nsf_fee_balance',FALSE)
         , ('total_monthly_payment',FALSE)
         , ('billing_name',FALSE)
         , ('billing_address_line_2',FALSE)
         , ('co_mortgagor_name',FALSE)
         , ('billing_address_line_3',FALSE)
         , ('billing_address_line_4',FALSE)
         , ('billing_city_name',FALSE)
         , ('foreign_address_indicator',FALSE)
         , ('billing_state',FALSE)
         , ('billing_zip_code',FALSE)
         , ('telephone_number',FALSE)
         , ('telephone_code',FALSE)
         , ('mortgagor_prefered_lang_code',FALSE)
         , ('second_telephone_number',FALSE)
         , ('sec_mortgagor_ss_number',FALSE)
         , ('sec_co_mortgagor_ss_number',FALSE)
         , ('property_street_address',FALSE)
         , ('property_unit_number',FALSE)
         , ('city_name',FALSE)
         , ('property_alpha_state_code',FALSE)
         , ('property_zip_code',FALSE)
         , ('county_code',FALSE)
         , ('fips_county_code',FALSE)
         , ('fips_state_code',FALSE)
         , ('occupancy_code',FALSE)
         , ('occupancy_code_description',FALSE)
         , ('property_state_code',FALSE)
         , ('number_of_units',FALSE)
         , ('appraisal_date',FALSE)
         , ('property_value_amount',FALSE)
         , ('property_type',FALSE)
         , ('property_type_fnma_code',FALSE)
         , ('property_type_fnma_code_description',FALSE)
         , ('occupancy_current_status_code',FALSE)
         , ('occupancy_current_status_code_description',FALSE)
         , ('ownership_type',FALSE)
         , ('ownership_type_description',FALSE)
         , ('flood_community_start_date',FALSE)
         , ('flood_program_type',FALSE)
         , ('flood_loma_revision_code',FALSE)
         , ('flood_loma_determination_date',FALSE)
         , ('flood_contract_type',FALSE)
         , ('flood_community_number',FALSE)
         , ('flood_panel_number',FALSE)
         , ('flood_zone_position_1',FALSE)
         , ('flood_zone_position_2_and_3',FALSE)
         , ('flood_suffix_number',FALSE)
         , ('flood_zone_partial_indicator',FALSE)
         , ('flood_firm_effective_date',FALSE)
         , ('flood_mapping_company_id',FALSE)
         , ('flood_certification_number',FALSE)
         , ('grace_days',FALSE)
         , ('late_charge_amount',FALSE)
         , ('late_charge_code',FALSE)
         , ('late_charge_code_description',FALSE)
         , ('late_charge_factor',FALSE)
         , ('maximum_late_charge_amount',FALSE)
         , ('minimum_late_charge_amount',FALSE)
         , ('delinquency_class_code',FALSE)
         , ('delinquency_class_code_description',FALSE)
         , ('secondary_phone_code',FALSE)
         , ('secondary_phone_number',FALSE)
         , ('escrow_advance_balance',FALSE)
         , ('escrow_balance',FALSE)
         , ('escrow_replace_resrv_balance',FALSE)
         , ('hazard_ins_monthly_amount',FALSE)
         , ('replace_reserve_amount',FALSE)
         , ('restricted_escrow_balance',FALSE)
         , ('t_and_i_monthly_amount',FALSE)
         , ('a_and_h_premium_amount',FALSE)
         , ('life_premium_amount',FALSE)
         , ('interest_paid_through_date',FALSE)
         , ('ln_mod_code',FALSE)
         , ('ln_mod_code_description',FALSE)
         , ('last_analysis_date',FALSE)
         , ('last_analysis_effective_date',FALSE)
         , ('last_analysis_os_spread_months',FALSE)
         , ('mi_monthly_amount',FALSE)
         , ('mi_term',FALSE)
         , ('mi_disbursement_amount',FALSE)
         , ('mi_disbursement_due_date',FALSE)
         , ('mi_mid_point_date',FALSE)
         , ('mi_termination_date',FALSE)
         , ('mi_cancellation_date',FALSE)
         , ('mi_request_to_cancel_date',FALSE)
         , ('pmi_cancellation_reason_code',FALSE)
         , ('pmi_cancellation_reason_code_description',FALSE)
         , ('va_loan_number',FALSE)
         , ('va_lin_check_digit_number',FALSE)
         , ('recover_corp_advance_balance',FALSE)
         , ('third_party_recoverable_ca_bal',FALSE)
         , ('non_rec_corp_advance_balance',FALSE)
         , ('second_principal_balance',FALSE)
         , ('actual_deferred_balance',FALSE)
         , ('ytd_principal_paid_amount',FALSE)
         , ('ytd_interest_amount',FALSE)
         , ('ytd_tax_amount',FALSE)
         , ('ytd_ioe_amount',FALSE)
         , ('ytd_hazard_amt',FALSE)
         , ('ytd_lien_amount',FALSE)
         , ('ytd_mip_amount',FALSE)
         , ('ytd_nsf_total',FALSE)
         , ('ytd_restricted_ioe_amount',FALSE)
         , ('ytd_late_charge_amount',FALSE)
         , ('prepay_penalty_indicator',FALSE)
         , ('ppp_header_id',FALSE)
         , ('ppp_header_name',FALSE)
         , ('user_05_position_field_2a',FALSE)
         , ('purchase_price',FALSE)
         , ('interest_calc_option_code',FALSE)
         , ('the_360_365_factor',FALSE)
         , ('the_360_365_factor_description',FALSE)
         , ('assumption_code',FALSE)
         , ('assumption_code_description',FALSE)
         , ('bill_code',FALSE)
         , ('bill_code_description',FALSE)
         , ('rhs_borrower_id',FALSE)
         , ('opt_ins_plan_id',FALSE)
         , ('certificate_number_1',FALSE)
         , ('certificate_number_2',FALSE)
         , ('opt_ins_disbursement_amount',FALSE)
         , ('opt_ins_disbursement_due_date',FALSE)
         , ('imminent_default_fico_score',FALSE)
         , ('imminent_default_fico_date',FALSE)
         , ('points_paid_by_borrower',FALSE)
         , ('third_party_draft_code',FALSE)
         , ('third_party_draft_code_description',FALSE)
         , ('employee_code',FALSE)
         , ('zone',FALSE)
         , ('sec_mortgagor_birth_date',FALSE)
         , ('sec_co_mortgagor_birth_date',FALSE)
         , ('email_address',FALSE)
         , ('co_mortgagor_email_address',FALSE)
         , ('servicing_sold_id',FALSE)
)
    -- populate edw_field_definition with the list of above fields
    , cte_edw_field_definition as (INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag)
    SELECT cte_edw_table_definition.dwid, cte_new_fields.field_name, cte_new_fields.key_field_flag
        FROM cte_edw_table_definition, cte_new_fields)

SELECT 'Done adding table and field definitions for ingress.dmi.passport';


-- Create a Metadata Injection (MDI) configuration with the following properties:
-- Process Name: SP-7
-- Process Description: Load DMI Passport file to ingress database

-- The following statement adds an ETL configuration to populate dmi.passport (SP-7)
WITH cte_process as (INSERT INTO mdi.process (name, description)    -- mdi.process
    VALUES ('SP-7', 'Source data ETL to populate dmi.passport from a CSV file')
    RETURNING dwid)

    , cte_csv_file_input_step as (INSERT INTO mdi.csv_file_input_step ( process_dwid,
                                                                        header_present,
                                                                        delimiter,
                                                                        enclosure,
                                                                        buffersize,
                                                                        lazy_conversion,
                                                                        newline_possible,
                                                                        add_filename_result,
                                                                        file_format,
                                                                        file_encoding,
                                                                        include_filename,
                                                                        process_in_parallel,
                                                                        filename_field,
                                                                        row_num_field,
                                                                        data_source_dwid)
    SELECT cte_process.dwid,
           'Y',
           ',',
           '"',
           1024,
           'N',
           'N',
           'N',
           'mixed',
           'UTF-8',
           'Y',
           'N',
           NULL,
           NULL,
           3 -- 3 = DMI in staging.star_common.data_source
        FROM
            cte_process
    RETURNING dwid)

   , cte_csv_file_input_field_list (field_name, field_type, field_format, field_length, field_precision, field_trim_type, field_order) AS (
    VALUES  ('loan_number', 'String', NULL, -1, -1, 'none', 1)
         , ('old_loan_number', 'String', NULL, -1, -1, 'none', 2)
         , ('new_servicer_loan_number', 'String', NULL, -1, -1, 'none', 3)
         , ('user_03_position_field_3a', 'String', NULL, -1, -1, 'none', 4)
         , ('first_due_date', 'String', NULL, -1, -1, 'none', 5)
         , ('loan_closing_date', 'String', NULL, -1, -1, 'none', 6)
         , ('loan_purpose_code', 'String', NULL, -1, -1, 'none', 7)
         , ('loan_purpose_code_description', 'String', NULL, -1, -1, 'none', 8)
         , ('note_date', 'String', NULL, -1, -1, 'none', 9)
         , ('acquisition_date', 'String', NULL, -1, -1, 'none', 10)
         , ('original_interest_rate', 'String', NULL, -1, -1, 'none', 11)
         , ('original_loan_term', 'String', NULL, -1, -1, 'none', 12)
         , ('original_mortgage_amount', 'String', NULL, -1, -1, 'none', 13)
         , ('original_p_and_i_amount', 'String', NULL, -1, -1, 'none', 14)
         , ('original_property_value_amount', 'String', NULL, -1, -1, 'none', 15)
         , ('original_second_interest_rate', 'String', NULL, -1, -1, 'none', 16)
         , ('original_second_loan_term', 'String', NULL, -1, -1, 'none', 17)
         , ('original_second_mtg_amount', 'String', NULL, -1, -1, 'none', 18)
         , ('original_second_p_and_i', 'String', NULL, -1, -1, 'none', 19)
         , ('original_loan_to_value_ratio', 'String', NULL, -1, -1, 'none', 20)
         , ('annual_interest_rate', 'String', NULL, -1, -1, 'none', 21)
         , ('arm_indicator', 'String', NULL, -1, -1, 'none', 22)
         , ('drafting_indicator', 'String', NULL, -1, -1, 'none', 23)
         , ('draft_option_code', 'String', NULL, -1, -1, 'none', 24)
         , ('draft_delay_days_quantity', 'String', NULL, -1, -1, 'none', 25)
         , ('billing_mode', 'String', NULL, -1, -1, 'none', 26)
         , ('coupon_tape_date', 'String', NULL, -1, -1, 'none', 27)
         , ('coupon_bill_last_create_date', 'String', NULL, -1, -1, 'none', 28)
         , ('def_int_balance', 'String', NULL, -1, -1, 'none', 29)
         , ('distribution_type', 'String', NULL, -1, -1, 'none', 30)
         , ('loan_to_value_ratio', 'String', NULL, -1, -1, 'none', 31)
         , ('first_p_and_i_amount', 'String', NULL, -1, -1, 'none', 32)
         , ('first_principal_balance', 'String', NULL, -1, -1, 'none', 33)
         , ('el_status_indicator', 'String', NULL, -1, -1, 'none', 34)
         , ('interest_only_expire_date', 'String', NULL, -1, -1, 'none', 35)
         , ('interest_only_loan_indicator', 'String', NULL, -1, -1, 'none', 36)
         , ('qualified_mortgage_code', 'String', NULL, -1, -1, 'none', 37)
         , ('qualified_mortgage_code_description', 'String', NULL, -1, -1, 'none', 38)
         , ('higher_priced_indicator', 'String', NULL, -1, -1, 'none', 39)
         , ('higher_priced_indicator_description', 'String', NULL, -1, -1, 'none', 40)
         , ('high_cost_type', 'String', NULL, -1, -1, 'none', 41)
         , ('high_cost_type_description', 'String', NULL, -1, -1, 'none', 42)
         , ('escrow_waiver_code', 'String', NULL, -1, -1, 'none', 43)
         , ('escrow_waiver_code_description', 'String', NULL, -1, -1, 'none', 44)
         , ('escrow_waiver_date', 'String', NULL, -1, -1, 'none', 45)
         , ('investor_loan_number', 'String', NULL, -1, -1, 'none', 46)
         , ('investor_id', 'String', NULL, -1, -1, 'none', 47)
         , ('category_code', 'String', NULL, -1, -1, 'none', 48)
         , ('first_service_fee_rate', 'String', NULL, -1, -1, 'none', 49)
         , ('pool_number', 'String', NULL, -1, -1, 'none', 50)
         , ('pool_class_code', 'String', NULL, -1, -1, 'none', 51)
         , ('pool_contract_number', 'String', NULL, -1, -1, 'none', 52)
         , ('gse_code', 'String', NULL, -1, -1, 'none', 53)
         , ('gse_code_description', 'String', NULL, -1, -1, 'none', 54)
         , ('hi_type', 'String', NULL, -1, -1, 'none', 55)
         , ('hi_type_description', 'String', NULL, -1, -1, 'none', 56)
         , ('lo_type', 'String', NULL, -1, -1, 'none', 57)
         , ('lo_type_description', 'String', NULL, -1, -1, 'none', 58)
         , ('development_type', 'String', NULL, -1, -1, 'none', 59)
         , ('development_type_description', 'String', NULL, -1, -1, 'none', 60)
         , ('second_hi_type', 'String', NULL, -1, -1, 'none', 61)
         , ('bl_balloon_status_code', 'String', NULL, -1, -1, 'none', 62)
         , ('bl_balloon_status_code_description', 'String', NULL, -1, -1, 'none', 63)
         , ('balloon_status_code', 'String', NULL, -1, -1, 'none', 64)
         , ('balloon_status_code_description', 'String', NULL, -1, -1, 'none', 65)
         , ('loan_matures_date', 'String', NULL, -1, -1, 'none', 66)
         , ('loan_term', 'String', NULL, -1, -1, 'none', 67)
         , ('remaining_term', 'String', NULL, -1, -1, 'none', 68)
         , ('man_code', 'String', NULL, -1, -1, 'none', 69)
         , ('man_code_description', 'String', NULL, -1, -1, 'none', 70)
         , ('mers_id', 'String', NULL, -1, -1, 'none', 71)
         , ('mers_original_mortgagee_ind', 'String', NULL, -1, -1, 'none', 72)
         , ('mers_original_mortgagee_ind_description', 'String', NULL, -1, -1, 'none', 73)
         , ('mers_registration_status_code', 'String', NULL, -1, -1, 'none', 74)
         , ('mers_registration_date', 'String', NULL, -1, -1, 'none', 75)
         , ('mers_id_number_status_code', 'String', NULL, -1, -1, 'none', 76)
         , ('mers_assigned_date', 'String', NULL, -1, -1, 'none', 77)
         , ('next_payment_due_date', 'String', NULL, -1, -1, 'none', 78)
         , ('last_full_payment_date', 'String', NULL, -1, -1, 'none', 79)
         , ('due_date_day_portion_parsed', 'String', NULL, -1, -1, 'none', 80)
         , ('payment_period', 'String', NULL, -1, -1, 'none', 81)
         , ('payment_option_code', 'String', NULL, -1, -1, 'none', 82)
         , ('payment_option_code_description', 'String', NULL, -1, -1, 'none', 83)
         , ('suspense_balance', 'String', NULL, -1, -1, 'none', 84)
         , ('nsf_fee_balance', 'String', NULL, -1, -1, 'none', 85)
         , ('total_monthly_payment', 'String', NULL, -1, -1, 'none', 86)
         , ('billing_name', 'String', NULL, -1, -1, 'none', 87)
         , ('billing_address_line_2', 'String', NULL, -1, -1, 'none', 88)
         , ('co_mortgagor_name', 'String', NULL, -1, -1, 'none', 89)
         , ('billing_address_line_3', 'String', NULL, -1, -1, 'none', 90)
         , ('billing_address_line_4', 'String', NULL, -1, -1, 'none', 91)
         , ('billing_city_name', 'String', NULL, -1, -1, 'none', 92)
         , ('foreign_address_indicator', 'String', NULL, -1, -1, 'none', 93)
         , ('billing_state', 'String', NULL, -1, -1, 'none', 94)
         , ('billing_zip_code', 'String', NULL, -1, -1, 'none', 95)
         , ('telephone_number', 'String', NULL, -1, -1, 'none', 96)
         , ('telephone_code', 'String', NULL, -1, -1, 'none', 97)
         , ('mortgagor_prefered_lang_code', 'String', NULL, -1, -1, 'none', 98)
         , ('second_telephone_number', 'String', NULL, -1, -1, 'none', 99)
         , ('sec_mortgagor_ss_number', 'String', NULL, -1, -1, 'none', 100)
         , ('sec_co_mortgagor_ss_number', 'String', NULL, -1, -1, 'none', 101)
         , ('property_street_address', 'String', NULL, -1, -1, 'none', 102)
         , ('property_unit_number', 'String', NULL, -1, -1, 'none', 103)
         , ('city_name', 'String', NULL, -1, -1, 'none', 104)
         , ('property_alpha_state_code', 'String', NULL, -1, -1, 'none', 105)
         , ('property_zip_code', 'String', NULL, -1, -1, 'none', 106)
         , ('county_code', 'String', NULL, -1, -1, 'none', 107)
         , ('fips_county_code', 'String', NULL, -1, -1, 'none', 108)
         , ('fips_state_code', 'String', NULL, -1, -1, 'none', 109)
         , ('occupancy_code', 'String', NULL, -1, -1, 'none', 110)
         , ('occupancy_code_description', 'String', NULL, -1, -1, 'none', 111)
         , ('property_state_code', 'String', NULL, -1, -1, 'none', 112)
         , ('number_of_units', 'String', NULL, -1, -1, 'none', 113)
         , ('appraisal_date', 'String', NULL, -1, -1, 'none', 114)
         , ('property_value_amount', 'String', NULL, -1, -1, 'none', 115)
         , ('property_type', 'String', NULL, -1, -1, 'none', 116)
         , ('property_type_fnma_code', 'String', NULL, -1, -1, 'none', 117)
         , ('property_type_fnma_code_description', 'String', NULL, -1, -1, 'none', 118)
         , ('occupancy_current_status_code', 'String', NULL, -1, -1, 'none', 119)
         , ('occupancy_current_status_code_description', 'String', NULL, -1, -1, 'none', 120)
         , ('ownership_type', 'String', NULL, -1, -1, 'none', 121)
         , ('ownership_type_description', 'String', NULL, -1, -1, 'none', 122)
         , ('flood_community_start_date', 'String', NULL, -1, -1, 'none', 123)
         , ('flood_program_type', 'String', NULL, -1, -1, 'none', 124)
         , ('flood_loma_revision_code', 'String', NULL, -1, -1, 'none', 125)
         , ('flood_loma_determination_date', 'String', NULL, -1, -1, 'none', 126)
         , ('flood_contract_type', 'String', NULL, -1, -1, 'none', 127)
         , ('flood_community_number', 'String', NULL, -1, -1, 'none', 128)
         , ('flood_panel_number', 'String', NULL, -1, -1, 'none', 129)
         , ('flood_zone_position_1', 'String', NULL, -1, -1, 'none', 130)
         , ('flood_zone_position_2_and_3', 'String', NULL, -1, -1, 'none', 131)
         , ('flood_suffix_number', 'String', NULL, -1, -1, 'none', 132)
         , ('flood_zone_partial_indicator', 'String', NULL, -1, -1, 'none', 133)
         , ('flood_firm_effective_date', 'String', NULL, -1, -1, 'none', 134)
         , ('flood_mapping_company_id', 'String', NULL, -1, -1, 'none', 135)
         , ('flood_certification_number', 'String', NULL, -1, -1, 'none', 136)
         , ('grace_days', 'String', NULL, -1, -1, 'none', 137)
         , ('late_charge_amount', 'String', NULL, -1, -1, 'none', 138)
         , ('late_charge_code', 'String', NULL, -1, -1, 'none', 139)
         , ('late_charge_code_description', 'String', NULL, -1, -1, 'none', 140)
         , ('late_charge_factor', 'String', NULL, -1, -1, 'none', 141)
         , ('maximum_late_charge_amount', 'String', NULL, -1, -1, 'none', 142)
         , ('minimum_late_charge_amount', 'String', NULL, -1, -1, 'none', 143)
         , ('delinquency_class_code', 'String', NULL, -1, -1, 'none', 144)
         , ('delinquency_class_code_description', 'String', NULL, -1, -1, 'none', 145)
         , ('secondary_phone_code', 'String', NULL, -1, -1, 'none', 146)
         , ('secondary_phone_number', 'String', NULL, -1, -1, 'none', 147)
         , ('escrow_advance_balance', 'String', NULL, -1, -1, 'none', 148)
         , ('escrow_balance', 'String', NULL, -1, -1, 'none', 149)
         , ('escrow_replace_resrv_balance', 'String', NULL, -1, -1, 'none', 150)
         , ('hazard_ins_monthly_amount', 'String', NULL, -1, -1, 'none', 151)
         , ('replace_reserve_amount', 'String', NULL, -1, -1, 'none', 152)
         , ('restricted_escrow_balance', 'String', NULL, -1, -1, 'none', 153)
         , ('t_and_i_monthly_amount', 'String', NULL, -1, -1, 'none', 154)
         , ('a_and_h_premium_amount', 'String', NULL, -1, -1, 'none', 155)
         , ('life_premium_amount', 'String', NULL, -1, -1, 'none', 156)
         , ('interest_paid_through_date', 'String', NULL, -1, -1, 'none', 157)
         , ('ln_mod_code', 'String', NULL, -1, -1, 'none', 158)
         , ('ln_mod_code_description', 'String', NULL, -1, -1, 'none', 159)
         , ('last_analysis_date', 'String', NULL, -1, -1, 'none', 160)
         , ('last_analysis_effective_date', 'String', NULL, -1, -1, 'none', 161)
         , ('last_analysis_os_spread_months', 'String', NULL, -1, -1, 'none', 162)
         , ('mi_monthly_amount', 'String', NULL, -1, -1, 'none', 163)
         , ('mi_term', 'String', NULL, -1, -1, 'none', 164)
         , ('mi_disbursement_amount', 'String', NULL, -1, -1, 'none', 165)
         , ('mi_disbursement_due_date', 'String', NULL, -1, -1, 'none', 166)
         , ('mi_mid_point_date', 'String', NULL, -1, -1, 'none', 167)
         , ('mi_termination_date', 'String', NULL, -1, -1, 'none', 168)
         , ('mi_cancellation_date', 'String', NULL, -1, -1, 'none', 169)
         , ('mi_request_to_cancel_date', 'String', NULL, -1, -1, 'none', 170)
         , ('pmi_cancellation_reason_code', 'String', NULL, -1, -1, 'none', 171)
         , ('pmi_cancellation_reason_code_description', 'String', NULL, -1, -1, 'none', 172)
         , ('va_loan_number', 'String', NULL, -1, -1, 'none', 173)
         , ('va_lin_check_digit_number', 'String', NULL, -1, -1, 'none', 174)
         , ('recover_corp_advance_balance', 'String', NULL, -1, -1, 'none', 175)
         , ('third_party_recoverable_ca_bal', 'String', NULL, -1, -1, 'none', 176)
         , ('non_rec_corp_advance_balance', 'String', NULL, -1, -1, 'none', 177)
         , ('second_principal_balance', 'String', NULL, -1, -1, 'none', 178)
         , ('actual_deferred_balance', 'String', NULL, -1, -1, 'none', 179)
         , ('ytd_principal_paid_amount', 'String', NULL, -1, -1, 'none', 180)
         , ('ytd_interest_amount', 'String', NULL, -1, -1, 'none', 181)
         , ('ytd_tax_amount', 'String', NULL, -1, -1, 'none', 182)
         , ('ytd_ioe_amount', 'String', NULL, -1, -1, 'none', 183)
         , ('ytd_hazard_amt', 'String', NULL, -1, -1, 'none', 184)
         , ('ytd_lien_amount', 'String', NULL, -1, -1, 'none', 185)
         , ('ytd_mip_amount', 'String', NULL, -1, -1, 'none', 186)
         , ('ytd_nsf_total', 'String', NULL, -1, -1, 'none', 187)
         , ('ytd_restricted_ioe_amount', 'String', NULL, -1, -1, 'none', 188)
         , ('ytd_late_charge_amount', 'String', NULL, -1, -1, 'none', 189)
         , ('prepay_penalty_indicator', 'String', NULL, -1, -1, 'none', 190)
         , ('ppp_header_id', 'String', NULL, -1, -1, 'none', 191)
         , ('ppp_header_name', 'String', NULL, -1, -1, 'none', 192)
         , ('user_05_position_field_2a', 'String', NULL, -1, -1, 'none', 193)
         , ('purchase_price', 'String', NULL, -1, -1, 'none', 194)
         , ('interest_calc_option_code', 'String', NULL, -1, -1, 'none', 195)
         , ('the_360_365_factor', 'String', NULL, -1, -1, 'none', 196)
         , ('the_360_365_factor_description', 'String', NULL, -1, -1, 'none', 197)
         , ('assumption_code', 'String', NULL, -1, -1, 'none', 198)
         , ('assumption_code_description', 'String', NULL, -1, -1, 'none', 199)
         , ('bill_code', 'String', NULL, -1, -1, 'none', 200)
         , ('bill_code_description', 'String', NULL, -1, -1, 'none', 201)
         , ('rhs_borrower_id', 'String', NULL, -1, -1, 'none', 202)
         , ('opt_ins_plan_id', 'String', NULL, -1, -1, 'none', 203)
         , ('certificate_number_1', 'String', NULL, -1, -1, 'none', 204)
         , ('certificate_number_2', 'String', NULL, -1, -1, 'none', 205)
         , ('opt_ins_disbursement_amount', 'String', NULL, -1, -1, 'none', 206)
         , ('opt_ins_disbursement_due_date', 'String', NULL, -1, -1, 'none', 207)
         , ('imminent_default_fico_score', 'String', NULL, -1, -1, 'none', 208)
         , ('imminent_default_fico_date', 'String', NULL, -1, -1, 'none', 209)
         , ('points_paid_by_borrower', 'String', NULL, -1, -1, 'none', 210)
         , ('third_party_draft_code', 'String', NULL, -1, -1, 'none', 211)
         , ('third_party_draft_code_description', 'String', NULL, -1, -1, 'none', 212)
         , ('employee_code', 'String', NULL, -1, -1, 'none', 213)
         , ('zone', 'String', NULL, -1, -1, 'none', 214)
         , ('sec_mortgagor_birth_date', 'String', NULL, -1, -1, 'none', 215)
         , ('sec_co_mortgagor_birth_date', 'String', NULL, -1, -1, 'none', 216)
         , ('email_address', 'String', NULL, -1, -1, 'none', 217)
         , ('co_mortgagor_email_address', 'String', NULL, -1, -1, 'none', 218)
         , ('servicing_sold_id', 'String', NULL, -1, -1, 'none', 219))

    , cte_csv_file_input_field as (INSERT INTO mdi.csv_file_input_field (csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_trim_type, field_order)
        SELECT
              cte_csv_file_input_step.dwid
            , cte_csv_file_input_field_list.field_name
            , cte_csv_file_input_field_list.field_type::mdi.pentaho_field_type
            , cte_csv_file_input_field_list.field_format
            , cte_csv_file_input_field_list.field_length
            , cte_csv_file_input_field_list.field_precision
            , cte_csv_file_input_field_list.field_trim_type::mdi.pentaho_trim_type
            , cte_csv_file_input_field_list.field_order
        FROM
            cte_csv_file_input_field_list
            , cte_csv_file_input_step)

    , cte_table_output_step_values (target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update) AS (
        VALUES ('dmi', 'passport', 1000, NULL, NULL, NULL, NULL, 'N', NULL, 'Y', 'Ingress DB Connection', 'N', 'Y', 'N', 'N'))

    , cte_table_output_step as (INSERT INTO mdi.table_output_step (process_dwid, target_schema, target_table, commit_size, partitioning_field, table_name_field, auto_generated_key_field, partition_data_per, table_name_defined_in_field, return_auto_generated_key_field, truncate_table, connectionname, partition_over_tables, specify_database_fields, ignore_insert_errors, use_batch_update)
        SELECT
              cte_process.dwid,
            cte_table_output_step_values.target_schema,
            cte_table_output_step_values.target_table,
            cte_table_output_step_values.commit_size,
            cte_table_output_step_values.partitioning_field,
            cte_table_output_step_values.table_name_field,
            cte_table_output_step_values.auto_generated_key_field,
            cte_table_output_step_values.partition_data_per,
            cte_table_output_step_values.table_name_defined_in_field::mdi.pentaho_y_or_n,
            cte_table_output_step_values.return_auto_generated_key_field,
            cte_table_output_step_values.truncate_table::mdi.pentaho_y_or_n,
            cte_table_output_step_values.connectionname,
            cte_table_output_step_values.partition_over_tables::mdi.pentaho_y_or_n,
            cte_table_output_step_values.specify_database_fields::mdi.pentaho_y_or_n,
            cte_table_output_step_values.ignore_insert_errors::mdi.pentaho_y_or_n,
            cte_table_output_step_values.use_batch_update::mdi.pentaho_y_or_n
        FROM
            cte_process
            , cte_table_output_step_values
        RETURNING dwid)


    , cte_table_output_field_list (database_field_name, database_stream_name, field_order, is_sensitive) as (
    VALUES ('loan_number', 'loan_number', 1, FALSE)
         , ('old_loan_number', 'old_loan_number', 2, FALSE)
         , ('new_servicer_loan_number', 'new_servicer_loan_number', 3, FALSE)
         , ('user_03_position_field_3a', 'user_03_position_field_3a', 4, FALSE)
         , ('first_due_date', 'first_due_date', 5, FALSE)
         , ('loan_closing_date', 'loan_closing_date', 6, FALSE)
         , ('loan_purpose_code', 'loan_purpose_code', 7, FALSE)
         , ('loan_purpose_code_description', 'loan_purpose_code_description', 8, FALSE)
         , ('note_date', 'note_date', 9, FALSE)
         , ('acquisition_date', 'acquisition_date', 10, FALSE)
         , ('original_interest_rate', 'original_interest_rate', 11, FALSE)
         , ('original_loan_term', 'original_loan_term', 12, FALSE)
         , ('original_mortgage_amount', 'original_mortgage_amount', 13, FALSE)
         , ('original_p_and_i_amount', 'original_p_and_i_amount', 14, FALSE)
         , ('original_property_value_amount', 'original_property_value_amount', 15, FALSE)
         , ('original_second_interest_rate', 'original_second_interest_rate', 16, FALSE)
         , ('original_second_loan_term', 'original_second_loan_term', 17, FALSE)
         , ('original_second_mtg_amount', 'original_second_mtg_amount', 18, FALSE)
         , ('original_second_p_and_i', 'original_second_p_and_i', 19, FALSE)
         , ('original_loan_to_value_ratio', 'original_loan_to_value_ratio', 20, FALSE)
         , ('annual_interest_rate', 'annual_interest_rate', 21, FALSE)
         , ('arm_indicator', 'arm_indicator', 22, FALSE)
         , ('drafting_indicator', 'drafting_indicator', 23, FALSE)
         , ('draft_option_code', 'draft_option_code', 24, FALSE)
         , ('draft_delay_days_quantity', 'draft_delay_days_quantity', 25, FALSE)
         , ('billing_mode', 'billing_mode', 26, FALSE)
         , ('coupon_tape_date', 'coupon_tape_date', 27, FALSE)
         , ('coupon_bill_last_create_date', 'coupon_bill_last_create_date', 28, FALSE)
         , ('def_int_balance', 'def_int_balance', 29, FALSE)
         , ('distribution_type', 'distribution_type', 30, FALSE)
         , ('loan_to_value_ratio', 'loan_to_value_ratio', 31, FALSE)
         , ('first_p_and_i_amount', 'first_p_and_i_amount', 32, FALSE)
         , ('first_principal_balance', 'first_principal_balance', 33, FALSE)
         , ('el_status_indicator', 'el_status_indicator', 34, FALSE)
         , ('interest_only_expire_date', 'interest_only_expire_date', 35, FALSE)
         , ('interest_only_loan_indicator', 'interest_only_loan_indicator', 36, FALSE)
         , ('qualified_mortgage_code', 'qualified_mortgage_code', 37, FALSE)
         , ('qualified_mortgage_code_description', 'qualified_mortgage_code_description', 38, FALSE)
         , ('higher_priced_indicator', 'higher_priced_indicator', 39, FALSE)
         , ('higher_priced_indicator_description', 'higher_priced_indicator_description', 40, FALSE)
         , ('high_cost_type', 'high_cost_type', 41, FALSE)
         , ('high_cost_type_description', 'high_cost_type_description', 42, FALSE)
         , ('escrow_waiver_code', 'escrow_waiver_code', 43, FALSE)
         , ('escrow_waiver_code_description', 'escrow_waiver_code_description', 44, FALSE)
         , ('escrow_waiver_date', 'escrow_waiver_date', 45, FALSE)
         , ('investor_loan_number', 'investor_loan_number', 46, FALSE)
         , ('investor_id', 'investor_id', 47, FALSE)
         , ('category_code', 'category_code', 48, FALSE)
         , ('first_service_fee_rate', 'first_service_fee_rate', 49, FALSE)
         , ('pool_number', 'pool_number', 50, FALSE)
         , ('pool_class_code', 'pool_class_code', 51, FALSE)
         , ('pool_contract_number', 'pool_contract_number', 52, FALSE)
         , ('gse_code', 'gse_code', 53, FALSE)
         , ('gse_code_description', 'gse_code_description', 54, FALSE)
         , ('hi_type', 'hi_type', 55, FALSE)
         , ('hi_type_description', 'hi_type_description', 56, FALSE)
         , ('lo_type', 'lo_type', 57, FALSE)
         , ('lo_type_description', 'lo_type_description', 58, FALSE)
         , ('development_type', 'development_type', 59, FALSE)
         , ('development_type_description', 'development_type_description', 60, FALSE)
         , ('second_hi_type', 'second_hi_type', 61, FALSE)
         , ('bl_balloon_status_code', 'bl_balloon_status_code', 62, FALSE)
         , ('bl_balloon_status_code_description', 'bl_balloon_status_code_description', 63, FALSE)
         , ('balloon_status_code', 'balloon_status_code', 64, FALSE)
         , ('balloon_status_code_description', 'balloon_status_code_description', 65, FALSE)
         , ('loan_matures_date', 'loan_matures_date', 66, FALSE)
         , ('loan_term', 'loan_term', 67, FALSE)
         , ('remaining_term', 'remaining_term', 68, FALSE)
         , ('man_code', 'man_code', 69, FALSE)
         , ('man_code_description', 'man_code_description', 70, FALSE)
         , ('mers_id', 'mers_id', 71, FALSE)
         , ('mers_original_mortgagee_ind', 'mers_original_mortgagee_ind', 72, FALSE)
         , ('mers_original_mortgagee_ind_description', 'mers_original_mortgagee_ind_description', 73, FALSE)
         , ('mers_registration_status_code', 'mers_registration_status_code', 74, FALSE)
         , ('mers_registration_date', 'mers_registration_date', 75, FALSE)
         , ('mers_id_number_status_code', 'mers_id_number_status_code', 76, FALSE)
         , ('mers_assigned_date', 'mers_assigned_date', 77, FALSE)
         , ('next_payment_due_date', 'next_payment_due_date', 78, FALSE)
         , ('last_full_payment_date', 'last_full_payment_date', 79, FALSE)
         , ('due_date_day_portion_parsed', 'due_date_day_portion_parsed', 80, FALSE)
         , ('payment_period', 'payment_period', 81, FALSE)
         , ('payment_option_code', 'payment_option_code', 82, FALSE)
         , ('payment_option_code_description', 'payment_option_code_description', 83, FALSE)
         , ('suspense_balance', 'suspense_balance', 84, FALSE)
         , ('nsf_fee_balance', 'nsf_fee_balance', 85, FALSE)
         , ('total_monthly_payment', 'total_monthly_payment', 86, FALSE)
         , ('billing_name', 'billing_name', 87, FALSE)
         , ('billing_address_line_2', 'billing_address_line_2', 88, FALSE)
         , ('co_mortgagor_name', 'co_mortgagor_name', 89, FALSE)
         , ('billing_address_line_3', 'billing_address_line_3', 90, FALSE)
         , ('billing_address_line_4', 'billing_address_line_4', 91, FALSE)
         , ('billing_city_name', 'billing_city_name', 92, FALSE)
         , ('foreign_address_indicator', 'foreign_address_indicator', 93, FALSE)
         , ('billing_state', 'billing_state', 94, FALSE)
         , ('billing_zip_code', 'billing_zip_code', 95, FALSE)
         , ('telephone_number', 'telephone_number', 96, FALSE)
         , ('telephone_code', 'telephone_code', 97, FALSE)
         , ('mortgagor_prefered_lang_code', 'mortgagor_prefered_lang_code', 98, FALSE)
         , ('second_telephone_number', 'second_telephone_number', 99, FALSE)
         , ('sec_mortgagor_ss_number', 'sec_mortgagor_ss_number', 100, FALSE)
         , ('sec_co_mortgagor_ss_number', 'sec_co_mortgagor_ss_number', 101, FALSE)
         , ('property_street_address', 'property_street_address', 102, FALSE)
         , ('property_unit_number', 'property_unit_number', 103, FALSE)
         , ('city_name', 'city_name', 104, FALSE)
         , ('property_alpha_state_code', 'property_alpha_state_code', 105, FALSE)
         , ('property_zip_code', 'property_zip_code', 106, FALSE)
         , ('county_code', 'county_code', 107, FALSE)
         , ('fips_county_code', 'fips_county_code', 108, FALSE)
         , ('fips_state_code', 'fips_state_code', 109, FALSE)
         , ('occupancy_code', 'occupancy_code', 110, FALSE)
         , ('occupancy_code_description', 'occupancy_code_description', 111, FALSE)
         , ('property_state_code', 'property_state_code', 112, FALSE)
         , ('number_of_units', 'number_of_units', 113, FALSE)
         , ('appraisal_date', 'appraisal_date', 114, FALSE)
         , ('property_value_amount', 'property_value_amount', 115, FALSE)
         , ('property_type', 'property_type', 116, FALSE)
         , ('property_type_fnma_code', 'property_type_fnma_code', 117, FALSE)
         , ('property_type_fnma_code_description', 'property_type_fnma_code_description', 118, FALSE)
         , ('occupancy_current_status_code', 'occupancy_current_status_code', 119, FALSE)
         , ('occupancy_current_status_code_description', 'occupancy_current_status_code_description', 120, FALSE)
         , ('ownership_type', 'ownership_type', 121, FALSE)
         , ('ownership_type_description', 'ownership_type_description', 122, FALSE)
         , ('flood_community_start_date', 'flood_community_start_date', 123, FALSE)
         , ('flood_program_type', 'flood_program_type', 124, FALSE)
         , ('flood_loma_revision_code', 'flood_loma_revision_code', 125, FALSE)
         , ('flood_loma_determination_date', 'flood_loma_determination_date', 126, FALSE)
         , ('flood_contract_type', 'flood_contract_type', 127, FALSE)
         , ('flood_community_number', 'flood_community_number', 128, FALSE)
         , ('flood_panel_number', 'flood_panel_number', 129, FALSE)
         , ('flood_zone_position_1', 'flood_zone_position_1', 130, FALSE)
         , ('flood_zone_position_2_and_3', 'flood_zone_position_2_and_3', 131, FALSE)
         , ('flood_suffix_number', 'flood_suffix_number', 132, FALSE)
         , ('flood_zone_partial_indicator', 'flood_zone_partial_indicator', 133, FALSE)
         , ('flood_firm_effective_date', 'flood_firm_effective_date', 134, FALSE)
         , ('flood_mapping_company_id', 'flood_mapping_company_id', 135, FALSE)
         , ('flood_certification_number', 'flood_certification_number', 136, FALSE)
         , ('grace_days', 'grace_days', 137, FALSE)
         , ('late_charge_amount', 'late_charge_amount', 138, FALSE)
         , ('late_charge_code', 'late_charge_code', 139, FALSE)
         , ('late_charge_code_description', 'late_charge_code_description', 140, FALSE)
         , ('late_charge_factor', 'late_charge_factor', 141, FALSE)
         , ('maximum_late_charge_amount', 'maximum_late_charge_amount', 142, FALSE)
         , ('minimum_late_charge_amount', 'minimum_late_charge_amount', 143, FALSE)
         , ('delinquency_class_code', 'delinquency_class_code', 144, FALSE)
         , ('delinquency_class_code_description', 'delinquency_class_code_description', 145, FALSE)
         , ('secondary_phone_code', 'secondary_phone_code', 146, FALSE)
         , ('secondary_phone_number', 'secondary_phone_number', 147, FALSE)
         , ('escrow_advance_balance', 'escrow_advance_balance', 148, FALSE)
         , ('escrow_balance', 'escrow_balance', 149, FALSE)
         , ('escrow_replace_resrv_balance', 'escrow_replace_resrv_balance', 150, FALSE)
         , ('hazard_ins_monthly_amount', 'hazard_ins_monthly_amount', 151, FALSE)
         , ('replace_reserve_amount', 'replace_reserve_amount', 152, FALSE)
         , ('restricted_escrow_balance', 'restricted_escrow_balance', 153, FALSE)
         , ('t_and_i_monthly_amount', 't_and_i_monthly_amount', 154, FALSE)
         , ('a_and_h_premium_amount', 'a_and_h_premium_amount', 155, FALSE)
         , ('life_premium_amount', 'life_premium_amount', 156, FALSE)
         , ('interest_paid_through_date', 'interest_paid_through_date', 157, FALSE)
         , ('ln_mod_code', 'ln_mod_code', 158, FALSE)
         , ('ln_mod_code_description', 'ln_mod_code_description', 159, FALSE)
         , ('last_analysis_date', 'last_analysis_date', 160, FALSE)
         , ('last_analysis_effective_date', 'last_analysis_effective_date', 161, FALSE)
         , ('last_analysis_os_spread_months', 'last_analysis_os_spread_months', 162, FALSE)
         , ('mi_monthly_amount', 'mi_monthly_amount', 163, FALSE)
         , ('mi_term', 'mi_term', 164, FALSE)
         , ('mi_disbursement_amount', 'mi_disbursement_amount', 165, FALSE)
         , ('mi_disbursement_due_date', 'mi_disbursement_due_date', 166, FALSE)
         , ('mi_mid_point_date', 'mi_mid_point_date', 167, FALSE)
         , ('mi_termination_date', 'mi_termination_date', 168, FALSE)
         , ('mi_cancellation_date', 'mi_cancellation_date', 169, FALSE)
         , ('mi_request_to_cancel_date', 'mi_request_to_cancel_date', 170, FALSE)
         , ('pmi_cancellation_reason_code', 'pmi_cancellation_reason_code', 171, FALSE)
         , ('pmi_cancellation_reason_code_description', 'pmi_cancellation_reason_code_description', 172, FALSE)
         , ('va_loan_number', 'va_loan_number', 173, FALSE)
         , ('va_lin_check_digit_number', 'va_lin_check_digit_number', 174, FALSE)
         , ('recover_corp_advance_balance', 'recover_corp_advance_balance', 175, FALSE)
         , ('third_party_recoverable_ca_bal', 'third_party_recoverable_ca_bal', 176, FALSE)
         , ('non_rec_corp_advance_balance', 'non_rec_corp_advance_balance', 177, FALSE)
         , ('second_principal_balance', 'second_principal_balance', 178, FALSE)
         , ('actual_deferred_balance', 'actual_deferred_balance', 179, FALSE)
         , ('ytd_principal_paid_amount', 'ytd_principal_paid_amount', 180, FALSE)
         , ('ytd_interest_amount', 'ytd_interest_amount', 181, FALSE)
         , ('ytd_tax_amount', 'ytd_tax_amount', 182, FALSE)
         , ('ytd_ioe_amount', 'ytd_ioe_amount', 183, FALSE)
         , ('ytd_hazard_amt', 'ytd_hazard_amt', 184, FALSE)
         , ('ytd_lien_amount', 'ytd_lien_amount', 185, FALSE)
         , ('ytd_mip_amount', 'ytd_mip_amount', 186, FALSE)
         , ('ytd_nsf_total', 'ytd_nsf_total', 187, FALSE)
         , ('ytd_restricted_ioe_amount', 'ytd_restricted_ioe_amount', 188, FALSE)
         , ('ytd_late_charge_amount', 'ytd_late_charge_amount', 189, FALSE)
         , ('prepay_penalty_indicator', 'prepay_penalty_indicator', 190, FALSE)
         , ('ppp_header_id', 'ppp_header_id', 191, FALSE)
         , ('ppp_header_name', 'ppp_header_name', 192, FALSE)
         , ('user_05_position_field_2a', 'user_05_position_field_2a', 193, FALSE)
         , ('purchase_price', 'purchase_price', 194, FALSE)
         , ('interest_calc_option_code', 'interest_calc_option_code', 195, FALSE)
         , ('the_360_365_factor', 'the_360_365_factor', 196, FALSE)
         , ('the_360_365_factor_description', 'the_360_365_factor_description', 197, FALSE)
         , ('assumption_code', 'assumption_code', 198, FALSE)
         , ('assumption_code_description', 'assumption_code_description', 199, FALSE)
         , ('bill_code', 'bill_code', 200, FALSE)
         , ('bill_code_description', 'bill_code_description', 201, FALSE)
         , ('rhs_borrower_id', 'rhs_borrower_id', 202, FALSE)
         , ('opt_ins_plan_id', 'opt_ins_plan_id', 203, FALSE)
         , ('certificate_number_1', 'certificate_number_1', 204, FALSE)
         , ('certificate_number_2', 'certificate_number_2', 205, FALSE)
         , ('opt_ins_disbursement_amount', 'opt_ins_disbursement_amount', 206, FALSE)
         , ('opt_ins_disbursement_due_date', 'opt_ins_disbursement_due_date', 207, FALSE)
         , ('imminent_default_fico_score', 'imminent_default_fico_score', 208, FALSE)
         , ('imminent_default_fico_date', 'imminent_default_fico_date', 209, FALSE)
         , ('points_paid_by_borrower', 'points_paid_by_borrower', 210, FALSE)
         , ('third_party_draft_code', 'third_party_draft_code', 211, FALSE)
         , ('third_party_draft_code_description', 'third_party_draft_code_description', 212, FALSE)
         , ('employee_code', 'employee_code', 213, FALSE)
         , ('zone', 'zone', 214, FALSE)
         , ('sec_mortgagor_birth_date', 'sec_mortgagor_birth_date', 215, FALSE)
         , ('sec_co_mortgagor_birth_date', 'sec_co_mortgagor_birth_date', 216, FALSE)
         , ('email_address', 'email_address', 217, FALSE)
         , ('co_mortgagor_email_address', 'co_mortgagor_email_address', 218, FALSE)
         , ('servicing_sold_id', 'servicing_sold_id', 219, FALSE)
         , ('etl_batch_id', 'etl_batch_id', 220, FALSE)
         , ('data_source_dwid', 'data_source_dwid', 221, FALSE)
         , ('input_filename', 'imported_filename', 222, FALSE))

   , cte_table_output_field as (INSERT INTO mdi.table_output_field (table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive)
           SELECT
               cte_table_output_step.dwid
               , cte_table_output_field_list.database_field_name
               , cte_table_output_field_list.database_stream_name
               , cte_table_output_field_list.field_order
               , cte_table_output_field_list.is_sensitive
           FROM
               cte_table_output_field_list
               , cte_table_output_step
    )
    select cte_table_output_step.dwid FROM cte_table_output_step;

SELECT 'Done adding MDI configuration for dmi.passport (SP-7)' as etl_creator_status;


/*
 config code for Risk Asset
 */



DO $$

    DECLARE sp_12_process_dwid BIGINT;
    DECLARE sp_12_file_input_step_dwid BIGINT;
    DECLARE sp_12_table_output_step_dwid BIGINT;
    DECLARE sp_13_process_dwid BIGINT;
    DECLARE sp_13_table_output_step_dwid BIGINT;
    DECLARE sp_13_microsoft_excel_input_step_dwid BIGINT;
    DECLARE sp_14_process_dwid BIGINT;
    DECLARE sp_14_file_input_step_dwid BIGINT;
    DECLARE sp_14_table_output_step_dwid BIGINT;
    DECLARE sp_15_process_dwid BIGINT;
    DECLARE sp_15_file_input_step_dwid BIGINT;
    DECLARE sp_15_table_output_step_dwid BIGINT;
    DECLARE sp_16_process_dwid BIGINT;
    DECLARE sp_16_microsoft_excel_input_step_dwid BIGINT;
    DECLARE sp_16_table_output_step_dwid BIGINT;
    DECLARE sp_17_process_dwid BIGINT;
    DECLARE sp_17_file_input_step_dwid BIGINT;
    DECLARE sp_17_table_output_step_dwid BIGINT;
    DECLARE sp_18_process_dwid BIGINT;
    DECLARE sp_18_file_input_step_dwid BIGINT;
    DECLARE sp_18_table_output_step_dwid BIGINT;
    DECLARE sp_19_process_dwid BIGINT;
    DECLARE sp_19_microsoft_excel_input_step_dwid BIGINT;
    DECLARE sp_19_table_output_step_dwid BIGINT;
    DECLARE sp_20_process_dwid BIGINT;
    DECLARE sp_20_microsoft_excel_input_step_dwid BIGINT;
    DECLARE sp_20_table_output_step_dwid BIGINT;


    DECLARE sp_12_edw_table_definition_dwid BIGINT;
    DECLARE sp_13_edw_table_definition_dwid BIGINT;
    DECLARE sp_14_edw_table_definition_dwid BIGINT;
    DECLARE sp_15_edw_table_definition_dwid BIGINT;
    DECLARE sp_16_edw_table_definition_dwid BIGINT;
    DECLARE sp_17_edw_table_definition_dwid BIGINT;
    DECLARE sp_18_edw_table_definition_dwid BIGINT;
    DECLARE sp_19_edw_table_definition_dwid BIGINT;
    DECLARE sp_20_edw_table_definition_dwid BIGINT;

BEGIN

-- SP-12 edw table definition insert
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
    VALUES  ('ingress', 'warehouse_banks', 'loan_inventory_prosperity', NULL)
    RETURNING dwid INTO sp_12_edw_table_definition_dwid;

-- SP-12 process input
    INSERT INTO mdi.process (name, description)
    VALUES ('SP-12', 'Load Prosperity bank data to the ingress.warehouse_banks.loan_inventory_prosperity table')
    RETURNING dwid INTO sp_12_process_dwid;

-- SP-12 csv_file_input_step insert
    INSERT INTO mdi.csv_file_input_step (process_dwid, header_present, delimiter, enclosure, buffersize
                                        , lazy_conversion, newline_possible, add_filename_result, file_format
                                        , file_encoding, include_filename
                                        , process_in_parallel, filename_field, row_num_field, data_source_dwid )
    VALUES (sp_12_process_dwid, 'N', ',', '"', 1024, 'N', 'Y', 'N', 'mixed', 'UTF-8', 'N', 'N', NULL, NULL, 0 )
    RETURNING dwid INTO sp_12_file_input_step_dwid;

-- SP-12 csv_file_input_field insert
    INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format
                                         , field_length, field_precision, field_currency, field_decimal, field_group
                                         , field_trim_type, field_order )
    VALUES( sp_12_file_input_step_dwid, 'bank_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 1 ),
          ( sp_12_file_input_step_dwid, 'report_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 2 ),
          ( sp_12_file_input_step_dwid, 'report_date_as_of', 'String', NULL, -1, -1, '$', '.', ',', 'none', 3 ),
          ( sp_12_file_input_step_dwid, 'accrued_through', 'String', NULL, -1, -1, '$', '.', ',', 'none' , 4 ),
          ( sp_12_file_input_step_dwid, 'accrued_through_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 5 ),
          ( sp_12_file_input_step_dwid, 'company_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 6 ),
          ( sp_12_file_input_step_dwid, 'company_address', 'String', NULL, -1, -1, '$', '.', ',', 'none', 7 ),
          ( sp_12_file_input_step_dwid, 'company_address_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 8 ),
          ( sp_12_file_input_step_dwid, 'company_city_state_zip', 'String', NULL, -1, -1, '$', '.', ',', 'none', 9 ),
          ( sp_12_file_input_step_dwid, 'company_phone', 'String', NULL, -1, -1, '$', '.', ',', 'none', 10 ),
          ( sp_12_file_input_step_dwid, 'empty_1', 'String', NULL, -1, -1, '$', '.', ',', 'none', 11 ),
          ( sp_12_file_input_step_dwid, 'empty_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 12 ),
          ( sp_12_file_input_step_dwid, 'empty_3', 'String', NULL, -1, -1, '$', '.', ',', 'none', 13 ),
          ( sp_12_file_input_step_dwid, 'loan_number_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 14 ),
          ( sp_12_file_input_step_dwid, 'name_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 15 ),
          ( sp_12_file_input_step_dwid, 'note_amount_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 16 ),
          ( sp_12_file_input_step_dwid, 'warehouse_amount_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 17 ),
          ( sp_12_file_input_step_dwid, 'orig_part_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 18 ),
          ( sp_12_file_input_step_dwid, 'int_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 19 ),
          ( sp_12_file_input_step_dwid, 'fees_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 20 ),
          ( sp_12_file_input_step_dwid, 'days_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 21 ),
          ( sp_12_file_input_step_dwid, 'date_disb_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 22 ),
          ( sp_12_file_input_step_dwid, 'note_recd_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 23 ),
          ( sp_12_file_input_step_dwid, 'note_shipped_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 24 ),
          ( sp_12_file_input_step_dwid, 'investor_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 25 ),
          ( sp_12_file_input_step_dwid, 'takeout_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 26 ),
          ( sp_12_file_input_step_dwid, 'tracking_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 27 ),
          ( sp_12_file_input_step_dwid, 'prod_code_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 28 ),
          ( sp_12_file_input_step_dwid, 'index_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 29 ),
          ( sp_12_file_input_step_dwid, 'margin_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 30 ),
          ( sp_12_file_input_step_dwid, 'loan_number', 'String', NULL, -1, -1, '$', '.', ',', 'none', 31 ),
          ( sp_12_file_input_step_dwid, 'name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 32 ),
          ( sp_12_file_input_step_dwid, 'note_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 33 ),
          ( sp_12_file_input_step_dwid, 'warehouse_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 34 ),
          ( sp_12_file_input_step_dwid, 'orig_part', 'String', NULL, -1, -1, '$', '.', ',', 'none', 35 ),
          ( sp_12_file_input_step_dwid, 'int', 'String', NULL, -1, -1, '$', '.', ',', 'none', 36 ),
          ( sp_12_file_input_step_dwid, 'fees', 'String', NULL, -1, -1, '$', '.', ',', 'none', 37 ),
          ( sp_12_file_input_step_dwid, 'days', 'String', NULL, -1, -1, '$', '.', ',', 'none', 38 ),
          ( sp_12_file_input_step_dwid, 'date_disb', 'String', NULL, -1, -1, '$', '.', ',', 'none', 39 ),
          ( sp_12_file_input_step_dwid, 'note_recd', 'String', NULL, -1, -1, '$', '.', ',', 'none', 40 ),
          ( sp_12_file_input_step_dwid, 'note_shipped', 'String', NULL, -1, -1, '$', '.', ',', 'none', 41 ),
          ( sp_12_file_input_step_dwid, 'investor', 'String', NULL, -1, -1, '$', '.', ',', 'none', 42 ),
          ( sp_12_file_input_step_dwid, 'takeout', 'String', NULL, -1, -1, '$', '.', ',', 'none', 43 ),
          ( sp_12_file_input_step_dwid, 'tracking', 'String', NULL, -1, -1, '$', '.', ',', 'none', 44 ),
          ( sp_12_file_input_step_dwid, 'prod_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 45 ),
          ( sp_12_file_input_step_dwid, 'index', 'String', NULL, -1, -1, '$', '.', ',', 'none', 46 ),
          ( sp_12_file_input_step_dwid, 'margin', 'String', NULL, -1, -1, '$', '.', ',', 'none', 47 ),
          ( sp_12_file_input_step_dwid, 'company_name_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 48 ),
          ( sp_12_file_input_step_dwid, 'total_company_loan_count', 'String', NULL, -1, -1, '$', '.', ',', 'none', 49 ),
          ( sp_12_file_input_step_dwid, 'note_amount_total', 'String', NULL, -1, -1, '$', '.', ',', 'none', 50 ),
          ( sp_12_file_input_step_dwid, 'warehouse_amount_total', 'String', NULL, -1, -1, '$', '.', ',', 'none', 51 ),
          ( sp_12_file_input_step_dwid, 'orig_part_total', 'String', NULL, -1, -1, '$', '.', ',', 'none', 52 ),
          ( sp_12_file_input_step_dwid, 'total_interest_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 53 ),
          ( sp_12_file_input_step_dwid, 'total_fees_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 54 ),
          ( sp_12_file_input_step_dwid, 'limit_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 55 ),
          ( sp_12_file_input_step_dwid, 'limit_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 56 ),
          ( sp_12_file_input_step_dwid, 'available_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 57 ),
          ( sp_12_file_input_step_dwid, 'available_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 58 ),
          ( sp_12_file_input_step_dwid, 'grand_total_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 59 ),
          ( sp_12_file_input_step_dwid, 'grand_total_loan_count', 'String', NULL, -1, -1, '$', '.', ',', 'none', 60 ),
          ( sp_12_file_input_step_dwid, 'grand_total_note_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 61 ),
          ( sp_12_file_input_step_dwid, 'grand_total_warehouse_amount', 'String', NULL, -1, -1, '$', '.', ',',   'none', 62 ),
          ( sp_12_file_input_step_dwid, 'grand_total_orig_part', 'String', NULL, -1, -1, '$', '.', ',', 'none', 63 ),
          ( sp_12_file_input_step_dwid, 'grand_total_interest', 'String', NULL, -1, -1, '$', '.', ',', 'none', 64 ),
          ( sp_12_file_input_step_dwid, 'grand_total_fees', 'String', NULL, -1, -1, '$', '.', ',', 'none', 65 ),
          ( sp_12_file_input_step_dwid, 'crystal_reports_export_page_description', 'String', NULL, -1, -1, '$', '.', ',', 'none', 66 ),
          ( sp_12_file_input_step_dwid, 'report_export_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 67 ),
          ( sp_12_file_input_step_dwid, 'report_export_time', 'String', NULL, -1, -1, '$', '.', ',', 'none', 68 ),
          ( sp_12_file_input_step_dwid, 'crystal_reports_report_type', 'String', NULL, -1, -1, '$', '.', ',', 'none', 69 )
 ;

-- SP-12 table output step
    INSERT INTO mdi.table_output_step ( process_dwid, target_schema, target_table, commit_size, partitioning_field
                                      , table_name_field, auto_generated_key_field, partition_data_per
                                      , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                      , connectionname, partition_over_tables, specify_database_fields
                                      , ignore_insert_errors, use_batch_update )
    VALUES (sp_12_process_dwid, 'warehouse_banks', 'loan_inventory_prosperity', 1000, NULL, NULL, NULL, NULL, 'N',
            NULL,'Y' ,'Ingress DB Connection' ,'N' ,'Y' ,'N' ,'N')
    RETURNING dwid INTO sp_12_table_output_step_dwid;

-- SP-12 table output field

    INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive )
    VALUES  ( sp_12_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', 1, false ),
            ( sp_12_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid', 2, false ),
            ( sp_12_table_output_step_dwid, 'input_filename', 'imported_filename', 3, false ),
            ( sp_12_table_output_step_dwid, 'bank_name', 'bank_name', 4, false ),
            ( sp_12_table_output_step_dwid, 'report_name', 'report_name', 5, false ),
            ( sp_12_table_output_step_dwid, 'report_date_as_of', 'report_date_as_of', 6, false ),
            ( sp_12_table_output_step_dwid, 'accrued_through', 'accrued_through', 7, false ),
            ( sp_12_table_output_step_dwid, 'accrued_through_date', 'accrued_through_date', 8, false ),
            ( sp_12_table_output_step_dwid, 'company_name', 'company_name', 9, false ),
            ( sp_12_table_output_step_dwid, 'company_address', 'company_address', 10, false ),
            ( sp_12_table_output_step_dwid, 'company_address_2', 'company_address_2', 11, false ),
            ( sp_12_table_output_step_dwid, 'company_city_state_zip', 'company_city_state_zip', 12, false ),
            ( sp_12_table_output_step_dwid, 'company_phone', 'company_phone', 13, false ),
            ( sp_12_table_output_step_dwid, 'empty_1', 'empty_1', 14, false ),
            ( sp_12_table_output_step_dwid, 'empty_2', 'empty_2', 15, false ),
            ( sp_12_table_output_step_dwid, 'empty_3', 'empty_3', 16, false ),
            ( sp_12_table_output_step_dwid, 'loan_number_header', 'loan_number_header', 17, false ),
            ( sp_12_table_output_step_dwid, 'name_header', 'name_header', 18, false ),
            ( sp_12_table_output_step_dwid, 'note_amount_header', 'note_amount_header', 19, false ),
            ( sp_12_table_output_step_dwid, 'warehouse_amount_header', 'warehouse_amount_header', 20, false ),
            ( sp_12_table_output_step_dwid, 'orig_part_header', 'orig_part_header', 21, false ),
            ( sp_12_table_output_step_dwid, 'int_header', 'int_header', 22, false ),
            ( sp_12_table_output_step_dwid, 'fees_header', 'fees_header', 23, false ),
            ( sp_12_table_output_step_dwid, 'days_header', 'days_header', 24, false ),
            ( sp_12_table_output_step_dwid, 'date_disb_header', 'date_disb_header', 25, false ),
            ( sp_12_table_output_step_dwid, 'note_recd_header', 'note_recd_header', 26, false ),
            ( sp_12_table_output_step_dwid, 'note_shipped_header', 'note_shipped_header', 27, false ),
            ( sp_12_table_output_step_dwid, 'investor_header', 'investor_header', 28, false ),
            ( sp_12_table_output_step_dwid, 'takeout_header', 'takeout_header', 29, false ),
            ( sp_12_table_output_step_dwid, 'tracking_header', 'tracking_header', 30, false ),
            ( sp_12_table_output_step_dwid, 'prod_code_header', 'prod_code_header', 31, false ),
            ( sp_12_table_output_step_dwid, 'index_header', 'index_header', 32, false ),
            ( sp_12_table_output_step_dwid, 'margin_header', 'margin_header', 33, false ),
            ( sp_12_table_output_step_dwid, 'loan_number', 'loan_number', 34, false ),
            ( sp_12_table_output_step_dwid, 'name', 'name', 35, false ),
            ( sp_12_table_output_step_dwid, 'note_amount', 'note_amount', 36, false ),
            ( sp_12_table_output_step_dwid, 'warehouse_amount', 'warehouse_amount', 37, false ),
            ( sp_12_table_output_step_dwid, 'orig_part', 'orig_part', 38, false ),
            ( sp_12_table_output_step_dwid, 'int', 'int', 39, false ),
            ( sp_12_table_output_step_dwid, 'fees', 'fees', 40, false ),
            ( sp_12_table_output_step_dwid, 'days', 'days', 41, false ),
            ( sp_12_table_output_step_dwid, 'date_disb', 'date_disb', 42, false ),
            ( sp_12_table_output_step_dwid, 'note_recd', 'note_recd', 43, false ),
            ( sp_12_table_output_step_dwid, 'note_shipped', 'note_shipped', 44, false ),
            ( sp_12_table_output_step_dwid, 'investor', 'investor', 45, false ),
            ( sp_12_table_output_step_dwid, 'takeout', 'takeout', 46, false ),
            ( sp_12_table_output_step_dwid, 'tracking', 'tracking', 47, false ),
            ( sp_12_table_output_step_dwid, 'prod_code', 'prod_code', 48, false ),
            ( sp_12_table_output_step_dwid, 'index', 'index', 49, false ),
            ( sp_12_table_output_step_dwid, 'margin', 'margin', 50, false ),
            ( sp_12_table_output_step_dwid, 'company_name_2', 'company_name_2', 51, false ),
            ( sp_12_table_output_step_dwid, 'total_company_loan_count', 'total_company_loan_count', 52,false ),
            ( sp_12_table_output_step_dwid, 'note_amount_total', 'note_amount_total', 53, false ),
            ( sp_12_table_output_step_dwid, 'warehouse_amount_total', 'warehouse_amount_total', 54, false ),
            ( sp_12_table_output_step_dwid, 'orig_part_total', 'orig_part_total', 55, false ),
            ( sp_12_table_output_step_dwid, 'total_interest_amount', 'total_interest_amount', 56, false ),
            ( sp_12_table_output_step_dwid, 'total_fees_amount', 'total_fees_amount', 57, false ),
            ( sp_12_table_output_step_dwid, 'limit_header', 'limit_header', 58, false ),
            ( sp_12_table_output_step_dwid, 'limit_amount', 'limit_amount', 59, false ),
            ( sp_12_table_output_step_dwid, 'available_header', 'available_header', 60, false ),
            ( sp_12_table_output_step_dwid, 'available_amount', 'available_amount', 61, false ),
            ( sp_12_table_output_step_dwid, 'grand_total_header', 'grand_total_header', 62, false ),
            ( sp_12_table_output_step_dwid, 'grand_total_loan_count', 'grand_total_loan_count', 63, false ),
            ( sp_12_table_output_step_dwid, 'grand_total_note_amount', 'grand_total_note_amount', 64, false ),
            ( sp_12_table_output_step_dwid, 'grand_total_warehouse_amount', 'grand_total_warehouse_amount', 65, false ),
            ( sp_12_table_output_step_dwid, 'grand_total_orig_part', 'grand_total_orig_part', 66, false ),
            ( sp_12_table_output_step_dwid, 'grand_total_interest', 'grand_total_interest', 67, false ),
            ( sp_12_table_output_step_dwid, 'grand_total_fees', 'grand_total_fees', 68, false ),
            ( sp_12_table_output_step_dwid, 'crystal_reports_export_page_description',  'crystal_reports_export_page_description', 69, false ),
            ( sp_12_table_output_step_dwid, 'report_export_date', 'report_export_date', 70, false ),
            ( sp_12_table_output_step_dwid, 'report_export_time', 'report_export_time', 71, false ),
            ( sp_12_table_output_step_dwid, 'crystal_reports_report_type', 'crystal_reports_report_type', 72, false )
;

-- SP-12 edw field definition insert
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, data_type)
    VALUES  (sp_12_edw_table_definition_dwid, 'etl_batch_id', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'data_source_dwid', FALSE, 'BIGINT'),
            (sp_12_edw_table_definition_dwid, 'input_filename', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'bank_name', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'report_name', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'report_date_as_of', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'accrued_through', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'accrued_through_date', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'company_name', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'company_address', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'company_address_2', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'company_city_state_zip', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'company_phone', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'empty_1', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'empty_2', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'empty_3', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'loan_number_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'name_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'note_amount_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'warehouse_amount_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'orig_part_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'int_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'fees_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'days_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'date_disb_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'note_recd_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'note_shipped_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'investor_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'takeout_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'tracking_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'prod_code_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'index_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'margin_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'loan_number', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'name', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'note_amount', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'warehouse_amount', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'orig_part', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'int', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'fees', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'days', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'date_disb', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'note_recd', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'note_shipped', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'investor', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'takeout', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'tracking', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'prod_code', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'index', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'margin', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'company_name_2', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'total_company_loan_count', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'note_amount_total', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'warehouse_amount_total', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'orig_part_total', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'total_interest_amount', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'total_fees_amount', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'limit_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'limit_amount', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'available_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'available_amount', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'grand_total_header', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'grand_total_loan_count', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'grand_total_note_amount', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'grand_total_warehouse_amount', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'grand_total_orig_part', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'grand_total_interest', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'grand_total_fees', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'crystal_reports_export_page_description', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'report_export_date', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'report_export_time', FALSE, 'TEXT'),
            (sp_12_edw_table_definition_dwid, 'crystal_reports_report_type', FALSE, 'TEXT')
;

-- SP-13 edw table definition insert
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
    VALUES  ('ingress', 'warehouse_banks', 'loan_inventory_flagstar', NULL)
    RETURNING dwid INTO sp_13_edw_table_definition_dwid;
-- SP-13 process input
    INSERT INTO mdi.process (name, description)
    VALUES ('SP-13', 'Load Flagstar bank data to the ingress.warehouse_banks.loan_inventory_flagstar table')
    RETURNING dwid INTO sp_13_process_dwid;

-- SP-13 excel input step insert
    INSERT INTO mdi.microsoft_excel_input_step ( process_dwid, spreadsheet_type, filemask, exclude_filemask
                                               , file_required, include_subfolders, sheet_name, sheet_start_row
                                               , sheet_start_col, data_source_dwid )
    VALUES ( sp_13_process_dwid, 'POI', '*', NULL, 'Y', 'N', 'Report_Page_1', 7, 0, 0 )
    RETURNING dwid INTO sp_13_microsoft_excel_input_step_dwid;

-- SP-13 excel input field insert
    INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency
                                                    , field_decimal, field_group, field_trim_type, field_order )
    VALUES  ( sp_13_microsoft_excel_input_step_dwid, 'Confirm #', 'String', NULL, -1, -1, '$', '.', ',', 'none', 1 ),
            ( sp_13_microsoft_excel_input_step_dwid, 'Loan #', 'String', NULL, -1, -1, '$', '.', ',', 'none', 2  ),
            ( sp_13_microsoft_excel_input_step_dwid, 'Lender Loan #', 'String', NULL, -1, -1, '$', '.', ',', 'none', 3  ),
            ( sp_13_microsoft_excel_input_step_dwid, 'Note Amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 4  ),
            ( sp_13_microsoft_excel_input_step_dwid, 'Note Rate', 'String', NULL, -1, -1, '$', '.', ',', 'none', 5  ),
            ( sp_13_microsoft_excel_input_step_dwid, 'Borrower', 'String', NULL, -1, -1, '$', '.', ',', 'none', 6  ),
            ( sp_13_microsoft_excel_input_step_dwid, 'Draw Fee', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 7  ),
            ( sp_13_microsoft_excel_input_step_dwid, 'Outstanding Interest Accrued', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 8  ),
            ( sp_13_microsoft_excel_input_step_dwid, 'Original Advance Amount', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 9  ),
            ( sp_13_microsoft_excel_input_step_dwid, 'Outstanding Advance Amount', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 10  ),
            ( sp_13_microsoft_excel_input_step_dwid, 'Disbursement Amount', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 11  ),
            ( sp_13_microsoft_excel_input_step_dwid, 'Advance Date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 12  ),
            ( sp_13_microsoft_excel_input_step_dwid, 'Days Out', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 13  ),
            ( sp_13_microsoft_excel_input_step_dwid, 'Note Received Date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 14  ),
            ( sp_13_microsoft_excel_input_step_dwid, 'Outbound Collateral Tracking Number', 'String', NULL, -1, -1, '$', '.', ',', 'none', 15  ),
            ( sp_13_microsoft_excel_input_step_dwid, 'Outbound Collateral Shipping Date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 16  )
;

-- SP-13 table output step
    INSERT INTO mdi.table_output_step ( process_dwid, target_schema, target_table, commit_size, partitioning_field
                                      , table_name_field, auto_generated_key_field, partition_data_per
                                      , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                      , connectionname, partition_over_tables, specify_database_fields
                                      , ignore_insert_errors, use_batch_update )
    VALUES (sp_13_process_dwid, 'warehouse_banks', 'loan_inventory_flagstar', 1000, NULL, NULL, NULL, NULL, 'N',
            NULL,'Y' ,'Ingress DB Connection' ,'N' ,'Y' ,'N' ,'N')
    RETURNING dwid INTO sp_13_table_output_step_dwid;

-- SP-13 table output field
    INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive )
    VALUES  ( sp_13_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', 1, false ),
            ( sp_13_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid', 2, false ),
            ( sp_13_table_output_step_dwid, 'input_filename', 'imported_filename', 3, false ),
            ( sp_13_table_output_step_dwid, 'confirm_number', 'Confirm #', 4, false ),
            ( sp_13_table_output_step_dwid, 'loan_number', 'Loan #', 5, false ),
            ( sp_13_table_output_step_dwid, 'lender_loan_number', 'Lender Loan #', 6, false ),
            ( sp_13_table_output_step_dwid, 'note_amount', 'Note Amount', 7, false ),
            ( sp_13_table_output_step_dwid, 'note_rate', 'Note Rate', 8, false ),
            ( sp_13_table_output_step_dwid, 'borrower', 'Borrower', 9, false ),
            ( sp_13_table_output_step_dwid, 'draw_fee', 'Draw Fee', 10, false ),
            ( sp_13_table_output_step_dwid, 'outstanding_interest_accrued', 'Outstanding Interest Accrued', 11, false ),
            ( sp_13_table_output_step_dwid, 'original_advance_amount', 'Original Advance Amount', 12, false ),
            ( sp_13_table_output_step_dwid, 'outstanding_advance_amount', 'Outstanding Advance Amount', 13, false ),
            ( sp_13_table_output_step_dwid, 'disbursement_amount', 'Disbursement Amount', 14, false ),
            ( sp_13_table_output_step_dwid, 'advance_date', 'Advance Date', 15, false ),
            ( sp_13_table_output_step_dwid, 'days_out', 'Days Out', 16, false ),
            ( sp_13_table_output_step_dwid, 'note_received_date', 'Note Received Date', 17, false ),
            ( sp_13_table_output_step_dwid, 'outbound_collateral_tracking_number', 'Outbound Collateral Tracking Number', 18, false ),
            ( sp_13_table_output_step_dwid, 'outbound_collateral_shipping_date', 'Outbound Collateral Shipping Date', 19, false )
;

-- SP-13 edw field definition insert
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, data_type)
    VALUES  (sp_13_edw_table_definition_dwid, 'etl_batch_id', FALSE, 'TEXT'),
            (sp_13_edw_table_definition_dwid, 'data_source_dwid', FALSE, 'BIGINT'),
            (sp_13_edw_table_definition_dwid, 'imported_filename', FALSE, 'TEXT'),
            (sp_13_edw_table_definition_dwid, 'confirm_number', FALSE, 'TEXT'),
            (sp_13_edw_table_definition_dwid, 'loan_number ', FALSE, 'TEXT'),
            (sp_13_edw_table_definition_dwid, 'lender_loan_number ', FALSE, 'TEXT'),
            (sp_13_edw_table_definition_dwid, 'note_amount ', FALSE, 'TEXT'),
            (sp_13_edw_table_definition_dwid, 'note_rate', FALSE, 'TEXT'),
            (sp_13_edw_table_definition_dwid, 'borrower', FALSE, 'TEXT'),
            (sp_13_edw_table_definition_dwid, 'draw_fee', FALSE, 'NUMERIC(21,3)'),
            (sp_13_edw_table_definition_dwid, 'outstanding_interest_accrued', FALSE, 'NUMERIC(21,3)'),
            (sp_13_edw_table_definition_dwid, 'original_advance_amount', FALSE, 'NUMERIC(21,3)'),
            (sp_13_edw_table_definition_dwid, 'outstanding_advance_amount', FALSE, 'NUMERIC(21,3)'),
            (sp_13_edw_table_definition_dwid, 'disbursement_amount', FALSE, 'NUMERIC(21,3)'),
            (sp_13_edw_table_definition_dwid, 'advance_date', FALSE, 'DATE'),
            (sp_13_edw_table_definition_dwid, 'days_out', FALSE, 'INTEGER'),
            (sp_13_edw_table_definition_dwid, 'note_received_date', FALSE, 'DATE'),
            (sp_13_edw_table_definition_dwid, 'outbound_collateral_tracking_number', FALSE, 'TEXT'),
            (sp_13_edw_table_definition_dwid, 'outbound_collateral_shipping_date', FALSE, 'DATE')
;

-- SP-14 edw table definition insert
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
    VALUES  ('ingress', 'warehouse_banks', 'loan_inventory_lifestyle_home_lending', NULL)
    RETURNING dwid INTO sp_14_edw_table_definition_dwid;

-- SP-14 process input
    INSERT INTO mdi.process (name, description)
    VALUES ('SP-14', 'Load Lifestyle Home Lending bank data to the ingress.warehouse_banks.loan_inventory_lifestyle_home_lending table')
    RETURNING dwid INTO sp_14_process_dwid;

-- SP-14 csv_file_input_step insert
    INSERT INTO mdi.csv_file_input_step (process_dwid, header_present, delimiter, enclosure, buffersize
                                        , lazy_conversion, newline_possible, add_filename_result, file_format
                                        , file_encoding, include_filename
                                        , process_in_parallel, filename_field, row_num_field, data_source_dwid )
    VALUES (sp_14_process_dwid, 'N', ',', '"', 1024, 'N', 'Y', 'N', 'mixed', 'UTF-8', 'N', 'N', NULL, NULL, 0 )
    RETURNING dwid INTO sp_14_file_input_step_dwid;

-- SP-14 csv file input field insert
    INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format,
     field_length, field_precision, field_currency, field_decimal, field_group,
     field_trim_type, field_order )
    VALUES  ( sp_14_file_input_step_dwid, 'bank_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 1 ),
            ( sp_14_file_input_step_dwid, 'report_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 2 ),
            ( sp_14_file_input_step_dwid, 'report_date_as_of', 'String', NULL, -1, -1, '$', '.', ',', 'none', 3 ),
            ( sp_14_file_input_step_dwid, 'accrued_through', 'String', NULL, -1, -1, '$', '.', ',', 'none', 4 ),
            ( sp_14_file_input_step_dwid, 'accrued_through_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 5 ),
            ( sp_14_file_input_step_dwid, 'company_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 6 ),
            ( sp_14_file_input_step_dwid, 'company_address', 'String', NULL, -1, -1, '$', '.', ',', 'none', 7 ),
            ( sp_14_file_input_step_dwid, 'company_address_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 8 ),
            ( sp_14_file_input_step_dwid, 'company_city_state_zip', 'String', NULL, -1, -1, '$', '.', ',', 'none', 9 ),
            ( sp_14_file_input_step_dwid, 'empty_1', 'String', NULL, -1, -1, '$', '.', ',', 'none', 10 ),
            ( sp_14_file_input_step_dwid, 'empty_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 11 ),
            ( sp_14_file_input_step_dwid, 'empty_3', 'String', NULL, -1, -1, '$', '.', ',', 'none', 12 ),
            ( sp_14_file_input_step_dwid, 'empty_4', 'String', NULL, -1, -1, '$', '.', ',', 'none', 13 ),
            ( sp_14_file_input_step_dwid, 'loan_number_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 14 ),
            ( sp_14_file_input_step_dwid, 'name_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 15 ),
            ( sp_14_file_input_step_dwid, 'note_amount_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 16 ),
            ( sp_14_file_input_step_dwid, 'warehouse_amount_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 17 ),
            ( sp_14_file_input_step_dwid, 'orig_part_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 18 ),
            ( sp_14_file_input_step_dwid, 'int_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 19 ),
            ( sp_14_file_input_step_dwid, 'fees_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 20 ),
            ( sp_14_file_input_step_dwid, 'days_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 21 ),
            ( sp_14_file_input_step_dwid, 'date_disb_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 22 ),
            ( sp_14_file_input_step_dwid, 'note_recd_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 23 ),
            ( sp_14_file_input_step_dwid, 'note_shipped_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 24 ),
            ( sp_14_file_input_step_dwid, 'investor_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 25 ),
            ( sp_14_file_input_step_dwid, 'takeout_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 26 ),
            ( sp_14_file_input_step_dwid, 'tracking_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 27 ),
            ( sp_14_file_input_step_dwid, 'prod_code_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 28 ),
            ( sp_14_file_input_step_dwid, 'index_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 29 ),
            ( sp_14_file_input_step_dwid, 'margin_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 30 ),
            ( sp_14_file_input_step_dwid, 'loan_number', 'String', NULL, -1, -1, '$', '.', ',', 'none', 31 ),
            ( sp_14_file_input_step_dwid, 'name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 32 ),
            ( sp_14_file_input_step_dwid, 'note_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 33 ),
            ( sp_14_file_input_step_dwid, 'warehouse_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 34 ),
            ( sp_14_file_input_step_dwid, 'orig_part', 'String', NULL, -1, -1, '$', '.', ',', 'none', 35 ),
            ( sp_14_file_input_step_dwid, 'int', 'String', NULL, -1, -1, '$', '.', ',', 'none', 36 ),
            ( sp_14_file_input_step_dwid, 'fees', 'String', NULL, -1, -1, '$', '.', ',', 'none', 37 ),
            ( sp_14_file_input_step_dwid, 'days', 'String', NULL, -1, -1, '$', '.', ',', 'none', 38 ),
            ( sp_14_file_input_step_dwid, 'date_disb', 'String', NULL, -1, -1, '$', '.', ',', 'none', 39 ),
            ( sp_14_file_input_step_dwid, 'note_recd', 'String', NULL, -1, -1, '$', '.', ',', 'none', 40 ),
            ( sp_14_file_input_step_dwid, 'note_shipped', 'String', NULL, -1, -1, '$', '.', ',', 'none', 41 ),
            ( sp_14_file_input_step_dwid, 'investor', 'String', NULL, -1, -1, '$', '.', ',', 'none', 42 ),
            ( sp_14_file_input_step_dwid, 'takeout', 'String', NULL, -1, -1, '$', '.', ',', 'none', 43 ),
            ( sp_14_file_input_step_dwid, 'tracking', 'String', NULL, -1, -1, '$', '.', ',', 'none', 44 ),
            ( sp_14_file_input_step_dwid, 'product_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 45 ),
            ( sp_14_file_input_step_dwid, 'index', 'String', NULL, -1, -1, '$', '.', ',', 'none', 46 ),
            ( sp_14_file_input_step_dwid, 'margin', 'String', NULL, -1, -1, '$', '.', ',', 'none', 47 ),
            ( sp_14_file_input_step_dwid, 'company_name_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 48 ),
            ( sp_14_file_input_step_dwid, 'total_company_loan_count', 'String', NULL, -1, -1, '$', '.', ',', 'none', 49 ),
            ( sp_14_file_input_step_dwid, 'note_amount_total', 'String', NULL, -1, -1, '$', '.', ',', 'none', 50 ),
            ( sp_14_file_input_step_dwid, 'warehouse_amount_total', 'String', NULL, -1, -1, '$', '.', ',', 'none', 51 ),
            ( sp_14_file_input_step_dwid, 'orig_part_total', 'String', NULL, -1, -1, '$', '.', ',', 'none', 52 ),
            ( sp_14_file_input_step_dwid, 'total_interest_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 53 ),
            ( sp_14_file_input_step_dwid, 'total_fees_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 54 ),
            ( sp_14_file_input_step_dwid, 'limit_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 55 ),
            ( sp_14_file_input_step_dwid, 'limit_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 56 ),
            ( sp_14_file_input_step_dwid, 'available_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 57 ),
            ( sp_14_file_input_step_dwid, 'available_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 58 ),
            ( sp_14_file_input_step_dwid, 'grand_total_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 59 ),
            ( sp_14_file_input_step_dwid, 'grand_total_loan_count', 'String', NULL, -1, -1, '$', '.', ',', 'none', 60 ),
            ( sp_14_file_input_step_dwid, 'grand_total_note_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 61 ),
            ( sp_14_file_input_step_dwid, 'grand_total_warehouse_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 62 ),
            ( sp_14_file_input_step_dwid, 'grand_total_orig_part', 'String', NULL, -1, -1, '$', '.', ',', 'none', 63 ),
            ( sp_14_file_input_step_dwid, 'grand_total_interest', 'String', NULL, -1, -1, '$', '.', ',', 'none', 64 ),
            ( sp_14_file_input_step_dwid, 'grand_total_fees', 'String', NULL, -1, -1, '$', '.', ',', 'none', 65 ),
            ( sp_14_file_input_step_dwid, 'crystal_reports_export_page_description', 'String', NULL, -1, -1, '$', '.', ',', 'none', 66 ),
            ( sp_14_file_input_step_dwid, 'report_export_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 67 ),
            ( sp_14_file_input_step_dwid, 'report_export_time', 'String', NULL, -1, -1, '$', '.', ',', 'none', 68 ),
            ( sp_14_file_input_step_dwid, 'crystal_reports_report_type', 'String', NULL, -1, -1, '$', '.', ',', 'none', 69 )
;

-- SP-14 table output step
    INSERT INTO mdi.table_output_step ( process_dwid, target_schema, target_table, commit_size, partitioning_field
                                      , table_name_field, auto_generated_key_field, partition_data_per
                                      , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                      , connectionname, partition_over_tables, specify_database_fields
                                      , ignore_insert_errors, use_batch_update )
    VALUES (sp_14_process_dwid, 'warehouse_banks', 'loan_inventory_lifestyle_home_lending', 1000, NULL, NULL, NULL, NULL, 'N',
            NULL,'Y' ,'Ingress DB Connection' ,'N' ,'Y' ,'N' ,'N')
    RETURNING dwid INTO sp_14_table_output_step_dwid;

-- SP-14 table output field
    INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive )
    VALUES  ( sp_14_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', 1, false ),
            ( sp_14_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid', 2, false ),
            ( sp_14_table_output_step_dwid, 'input_filename', 'imported_filename', 3, false ),
            ( sp_14_table_output_step_dwid, 'bank_name', 'bank_name', 4, false ),
            ( sp_14_table_output_step_dwid, 'report_name', 'report_name', 5, false ),
            ( sp_14_table_output_step_dwid, 'report_date_as_of', 'report_date_as_of', 6, false ),
            ( sp_14_table_output_step_dwid, 'accrued_through', 'accrued_through', 7, false ),
            ( sp_14_table_output_step_dwid, 'accrued_through_date', 'accrued_through_date', 8, false ),
            ( sp_14_table_output_step_dwid, 'company_name', 'company_name', 9, false ),
            ( sp_14_table_output_step_dwid, 'company_address', 'company_address', 10, false ),
            ( sp_14_table_output_step_dwid, 'company_address_2', 'company_address_2', 11, false ),
            ( sp_14_table_output_step_dwid, 'company_city_state_zip', 'company_city_state_zip', 12, false ),
            ( sp_14_table_output_step_dwid, 'empty_1', 'empty_1', 13, false ),
            ( sp_14_table_output_step_dwid, 'empty_2', 'empty_2', 14, false ),
            ( sp_14_table_output_step_dwid, 'empty_3', 'empty_3', 15, false ),
            ( sp_14_table_output_step_dwid, 'empty_4', 'empty_4', 16, false ),
            ( sp_14_table_output_step_dwid, 'loan_number_header', 'loan_number_header', 17, false ),
            ( sp_14_table_output_step_dwid, 'name_header', 'name_header', 18, false ),
            ( sp_14_table_output_step_dwid, 'note_amount_header', 'note_amount_header', 19, false ),
            ( sp_14_table_output_step_dwid, 'warehouse_amount_header', 'warehouse_amount_header', 20, false ),
            ( sp_14_table_output_step_dwid, 'orig_part_header', 'orig_part_header', 21, false ),
            ( sp_14_table_output_step_dwid, 'int_header', 'int_header', 22, false ),
            ( sp_14_table_output_step_dwid, 'fees_header', 'fees_header', 23, false ),
            ( sp_14_table_output_step_dwid, 'days_header', 'days_header', 24, false ),
            ( sp_14_table_output_step_dwid, 'date_disb_header', 'date_disb_header', 25, false ),
            ( sp_14_table_output_step_dwid, 'note_recd_header', 'note_recd_header', 26, false ),
            ( sp_14_table_output_step_dwid, 'note_shipped_header', 'note_shipped_header', 27, false ),
            ( sp_14_table_output_step_dwid, 'investor_header', 'investor_header', 28, false ),
            ( sp_14_table_output_step_dwid, 'takeout_header', 'takeout_header', 29, false ),
            ( sp_14_table_output_step_dwid, 'tracking_header', 'tracking_header', 30, false ),
            ( sp_14_table_output_step_dwid, 'prod_code_header', 'prod_code_header', 31, false ),
            ( sp_14_table_output_step_dwid, 'index_header', 'index_header', 32, false ),
            ( sp_14_table_output_step_dwid, 'margin_header', 'margin_header', 33, false ),
            ( sp_14_table_output_step_dwid, 'loan_number', 'loan_number', 34, false ),
            ( sp_14_table_output_step_dwid, 'name', 'name', 35, false ),
            ( sp_14_table_output_step_dwid, 'note_amount', 'note_amount', 36, false ),
            ( sp_14_table_output_step_dwid, 'warehouse_amount', 'warehouse_amount', 37, false ),
            ( sp_14_table_output_step_dwid, 'orig_part', 'orig_part', 38, false ),
            ( sp_14_table_output_step_dwid, 'int', 'int', 39, false ),
            ( sp_14_table_output_step_dwid, 'fees', 'fees', 40, false ),
            ( sp_14_table_output_step_dwid, 'days', 'days', 41, false ),
            ( sp_14_table_output_step_dwid, 'date_disb', 'date_disb', 42, false ),
            ( sp_14_table_output_step_dwid, 'note_recd', 'note_recd', 43, false ),
            ( sp_14_table_output_step_dwid, 'note_shipped', 'note_shipped', 44, false ),
            ( sp_14_table_output_step_dwid, 'investor', 'investor', 45, false ),
            ( sp_14_table_output_step_dwid, 'takeout', 'takeout', 46, false ),
            ( sp_14_table_output_step_dwid, 'tracking', 'tracking', 47, false ),
            ( sp_14_table_output_step_dwid, 'product_code', 'product_code', 48, false ),
            ( sp_14_table_output_step_dwid, 'index', 'index', 49, false ),
            ( sp_14_table_output_step_dwid, 'margin', 'margin', 50, false ),
            ( sp_14_table_output_step_dwid, 'company_name_2', 'company_name_2', 51, false ),
            ( sp_14_table_output_step_dwid, 'total_company_loan_count', 'total_company_loan_count', 52, false ),
            ( sp_14_table_output_step_dwid, 'note_amount_total', 'note_amount_total', 53, false ),
            ( sp_14_table_output_step_dwid, 'warehouse_amount_total', 'warehouse_amount_total', 54, false ),
            ( sp_14_table_output_step_dwid, 'orig_part_total', 'orig_part_total', 55, false ),
            ( sp_14_table_output_step_dwid, 'total_interest_amount', 'total_interest_amount', 56, false ),
            ( sp_14_table_output_step_dwid, 'total_fees_amount', 'total_fees_amount', 57, false ),
            ( sp_14_table_output_step_dwid, 'limit_header', 'limit_header', 58, false ),
            ( sp_14_table_output_step_dwid, 'limit_amount', 'limit_amount', 59, false ),
            ( sp_14_table_output_step_dwid, 'available_header', 'available_header', 60, false ),
            ( sp_14_table_output_step_dwid, 'available_amount', 'available_amount', 61, false ),
            ( sp_14_table_output_step_dwid, 'grand_total_header', 'grand_total_header', 62, false ),
            ( sp_14_table_output_step_dwid, 'grand_total_loan_count', 'grand_total_loan_count', 63, false ),
            ( sp_14_table_output_step_dwid, 'grand_total_note_amount', 'grand_total_note_amount', 64, false ),
            ( sp_14_table_output_step_dwid, 'grand_total_warehouse_amount', 'grand_total_warehouse_amount', 65, false ),
            ( sp_14_table_output_step_dwid, 'grand_total_orig_part', 'grand_total_orig_part', 66, false ),
            ( sp_14_table_output_step_dwid, 'grand_total_interest', 'grand_total_interest', 67, false ),
            ( sp_14_table_output_step_dwid, 'grand_total_fees', 'grand_total_fees', 68, false ),
            ( sp_14_table_output_step_dwid, 'crystal_reports_export_page_description', 'crystal_reports_export_page_description', 69, false ),
            ( sp_14_table_output_step_dwid, 'report_export_date', 'report_export_date', 70, false ),
            ( sp_14_table_output_step_dwid, 'report_export_time', 'report_export_time', 71, false ),
            ( sp_14_table_output_step_dwid, 'crystal_reports_report_type', 'crystal_reports_report_type', 72, false )
;

-- SP-14 edw field definition insert
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, data_type)
    VALUES  (sp_14_edw_table_definition_dwid, 'etl_batch_id', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'data_source_dwid', FALSE, 'BIGINT'),
            (sp_14_edw_table_definition_dwid, 'input_filename', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'bank_name', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'report_name', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'report_date_as_of', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'accrued_through', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'accrued_through_date', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'company_name', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'company_address', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'company_address_2', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'company_city_state_zip', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'empty_1', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'empty_2', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'empty_3', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'empty_4', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'loan_number_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'name_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'note_amount_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'warehouse_amount_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'orig_part_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'int_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'fees_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'days_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'date_disb_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'note_recd_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'note_shipped_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'investor_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'takeout_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'tracking_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'prod_code_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'index_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'margin_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'loan_number', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'name', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'note_amount', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'warehouse_amount', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'orig_part', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'int', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'fees', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'days', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'date_disb', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'note_recd', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'note_shipped', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'investor', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'takeout', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'tracking', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'product_code', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'index', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'margin', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'company_name_2', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'total_company_loan_count', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'note_amount_total', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'warehouse_amount_total', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'orig_part_total', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'total_interest_amount', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'total_fees_amount', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'limit_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'limit_amount', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'available_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'available_amount', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'grand_total_header', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'grand_total_loan_count', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'grand_total_note_amount', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'grand_total_warehouse_amount', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'grand_total_orig_part', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'grand_total_interest', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'grand_total_fees', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'crystal_reports_export_page_description', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'report_export_date', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'report_export_time', FALSE, 'TEXT'),
            (sp_14_edw_table_definition_dwid, 'crystal_reports_report_type', FALSE, 'TEXT')
;


-- SP-15 edw table definition insert
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
    VALUES  ('ingress', 'warehouse_banks', 'loan_inventory_bank_united', NULL)
    RETURNING dwid INTO sp_15_edw_table_definition_dwid;

-- SP-15 process input
    INSERT INTO mdi.process (name, description)
    VALUES ('SP-15', 'Load Bank United bank data to the ingress.warehoues_banks.loan_inventory_bank_united table')
    RETURNING dwid INTO sp_15_process_dwid;

-- SP-15 csv file input step insert
    INSERT INTO mdi.csv_file_input_step (process_dwid, header_present, delimiter, enclosure, buffersize
                                        , lazy_conversion, newline_possible, add_filename_result, file_format
                                        , file_encoding, include_filename, process_in_parallel
                                        , filename_field, row_num_field, data_source_dwid )
    VALUES (sp_15_process_dwid, 'N', ',', '"', 1024, 'N', 'Y', 'N', 'mixed', 'UTF-8', 'N', 'N', NULL, NULL, 0 )
    RETURNING dwid INTO sp_15_file_input_step_dwid;

    INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format,
     field_length, field_precision, field_currency, field_decimal, field_group,
     field_trim_type, field_order )
     VALUES ( sp_15_file_input_step_dwid, 'bank_name', 'String', NULL, -1, -1, '$', '.', ',', 'none',1 ),
            ( sp_15_file_input_step_dwid, 'report_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 2 ),
            ( sp_15_file_input_step_dwid, 'report_date_as_of', 'String', NULL, -1, -1, '$', '.', ',', 'none', 3 ),
            ( sp_15_file_input_step_dwid, 'accrued_through', 'String', NULL, -1, -1, '$', '.', ',', 'none', 4 ),
            ( sp_15_file_input_step_dwid, 'accrued_through_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 5 ),
            ( sp_15_file_input_step_dwid, 'company_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 6 ),
            ( sp_15_file_input_step_dwid, 'company_address', 'String', NULL, -1, -1, '$', '.', ',', 'none', 7 ),
            ( sp_15_file_input_step_dwid, 'company_address_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 8 ),
            ( sp_15_file_input_step_dwid, 'company_city_state_zip', 'String', NULL, -1, -1, '$', '.', ',', 'none', 9 ),
            ( sp_15_file_input_step_dwid, 'empty_1', 'String', NULL, -1, -1, '$', '.', ',', 'none', 10 ),
            ( sp_15_file_input_step_dwid, 'empty_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 11 ),
            ( sp_15_file_input_step_dwid, 'empty_3', 'String', NULL, -1, -1, '$', '.', ',', 'none', 12 ),
            ( sp_15_file_input_step_dwid, 'empty_4', 'String', NULL, -1, -1, '$', '.', ',', 'none', 13 ),
            ( sp_15_file_input_step_dwid, 'loan_number_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 14 ),
            ( sp_15_file_input_step_dwid, 'name_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 15 ),
            ( sp_15_file_input_step_dwid, 'note_amount_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 16 ),
            ( sp_15_file_input_step_dwid, 'warehouse_amount_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 17 ),
            ( sp_15_file_input_step_dwid, 'orig_part_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 18 ),
            ( sp_15_file_input_step_dwid, 'int_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 19 ),
            ( sp_15_file_input_step_dwid, 'fees_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 20 ),
            ( sp_15_file_input_step_dwid, 'days_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 21 ),
            ( sp_15_file_input_step_dwid, 'date_disb_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 22 ),
            ( sp_15_file_input_step_dwid, 'note_recd_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 23 ),
            ( sp_15_file_input_step_dwid, 'note_shipped_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 24 ),
            ( sp_15_file_input_step_dwid, 'investor_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 25 ),
            ( sp_15_file_input_step_dwid, 'takeout_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 26 ),
            ( sp_15_file_input_step_dwid, 'tracking_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 27 ),
            ( sp_15_file_input_step_dwid, 'prod_code_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 28 ),
            ( sp_15_file_input_step_dwid, 'index_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 29 ),
            ( sp_15_file_input_step_dwid, 'margin_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 30 ),
            ( sp_15_file_input_step_dwid, 'loan_number', 'String', NULL, -1, -1, '$', '.', ',', 'none', 31 ),
            ( sp_15_file_input_step_dwid, 'name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 32 ),
            ( sp_15_file_input_step_dwid, 'note_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 33 ),
            ( sp_15_file_input_step_dwid, 'warehouse_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 34 ),
            ( sp_15_file_input_step_dwid, 'orig_part', 'String', NULL, -1, -1, '$', '.', ',', 'none', 35 ),
            ( sp_15_file_input_step_dwid, 'int', 'String', NULL, -1, -1, '$', '.', ',', 'none', 36 ),
            ( sp_15_file_input_step_dwid, 'fees', 'String', NULL, -1, -1, '$', '.', ',', 'none', 37 ),
            ( sp_15_file_input_step_dwid, 'days', 'String', NULL, -1, -1, '$', '.', ',', 'none', 38 ),
            ( sp_15_file_input_step_dwid, 'date_disb', 'String', NULL, -1, -1, '$', '.', ',', 'none', 39 ),
            ( sp_15_file_input_step_dwid, 'note_recd', 'String', NULL, -1, -1, '$', '.', ',', 'none', 40 ),
            ( sp_15_file_input_step_dwid, 'note_shipped', 'String', NULL, -1, -1, '$', '.', ',', 'none', 41 ),
            ( sp_15_file_input_step_dwid, 'investor', 'String', NULL, -1, -1, '$', '.', ',', 'none', 42 ),
            ( sp_15_file_input_step_dwid, 'takeout', 'String', NULL, -1, -1, '$', '.', ',', 'none', 43 ),
            ( sp_15_file_input_step_dwid, 'tracking', 'String', NULL, -1, -1, '$', '.', ',', 'none', 44 ),
            ( sp_15_file_input_step_dwid, 'product_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 45 ),
            ( sp_15_file_input_step_dwid, 'index', 'String', NULL, -1, -1, '$', '.', ',', 'none', 46 ),
            ( sp_15_file_input_step_dwid, 'margin', 'String', NULL, -1, -1, '$', '.', ',', 'none', 47 ),
            ( sp_15_file_input_step_dwid, 'company_name_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 48 ),
            ( sp_15_file_input_step_dwid, 'total_company_loan_count', 'String', NULL, -1, -1, '$', '.', ',', 'none', 49 ),
            ( sp_15_file_input_step_dwid, 'note_amount_total', 'String', NULL, -1, -1, '$', '.', ',', 'none', 50 ),
            ( sp_15_file_input_step_dwid, 'warehouse_amount_total', 'String', NULL, -1, -1, '$', '.', ',', 'none', 51 ),
            ( sp_15_file_input_step_dwid, 'orig_part_total', 'String', NULL, -1, -1, '$', '.', ',', 'none', 52 ),
            ( sp_15_file_input_step_dwid, 'total_interest_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 53 ),
            ( sp_15_file_input_step_dwid, 'total_fees_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 54 ),
            ( sp_15_file_input_step_dwid, 'limit_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 55 ),
            ( sp_15_file_input_step_dwid, 'limit_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 56 ),
            ( sp_15_file_input_step_dwid, 'available_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 57 ),
            ( sp_15_file_input_step_dwid, 'available_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 58 ),
            ( sp_15_file_input_step_dwid, 'grand_total_header', 'String', NULL, -1, -1, '$', '.', ',', 'none', 59 ),
            ( sp_15_file_input_step_dwid, 'grand_total_loan_count', 'String', NULL, -1, -1, '$', '.', ',', 'none', 60 ),
            ( sp_15_file_input_step_dwid, 'grand_total_note_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 61 ),
            ( sp_15_file_input_step_dwid, 'grand_total_warehouse_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 62 ),
            ( sp_15_file_input_step_dwid, 'grand_total_orig_part', 'String', NULL, -1, -1, '$', '.', ',', 'none', 63 ),
            ( sp_15_file_input_step_dwid, 'grand_total_interest', 'String', NULL, -1, -1, '$', '.', ',', 'none', 64 ),
            ( sp_15_file_input_step_dwid, 'grand_total_fees', 'String', NULL, -1, -1, '$', '.', ',', 'none', 65 ),
            ( sp_15_file_input_step_dwid, 'crystal_reports_export_page_description', 'String', NULL, -1, -1, '$', '.', ',', 'none', 66 ),
            ( sp_15_file_input_step_dwid, 'report_export_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 67 ),
            ( sp_15_file_input_step_dwid, 'report_export_time', 'String', NULL, -1, -1, '$', '.', ',', 'none', 68 ),
            ( sp_15_file_input_step_dwid, 'crystal_reports_report_type', 'String', NULL, -1, -1, '$', '.', ',', 'none', 69 )
;

-- SP-15 table output step
    INSERT INTO mdi.table_output_step ( process_dwid, target_schema, target_table, commit_size, partitioning_field
                                      , table_name_field, auto_generated_key_field, partition_data_per
                                      , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                      , connectionname, partition_over_tables, specify_database_fields
                                      , ignore_insert_errors, use_batch_update )
    VALUES (sp_15_process_dwid, 'warehouse_banks', 'loan_inventory_bank_united', 1000, NULL, NULL, NULL, NULL, 'N',
            NULL,'Y' ,'Ingress DB Connection' ,'N' ,'Y' ,'N' ,'N')
    RETURNING dwid INTO sp_15_table_output_step_dwid;

-- SP-15 table output fields
    INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive )
    VALUES  ( sp_15_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', 1, false ),
            ( sp_15_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid', 2, false ),
            ( sp_15_table_output_step_dwid, 'input_filename', 'imported_filename', 3, false ),
            ( sp_15_table_output_step_dwid, 'bank_name', 'bank_name', 4, false ),
            ( sp_15_table_output_step_dwid, 'report_name', 'report_name', 5, false ),
            ( sp_15_table_output_step_dwid, 'report_date_as_of', 'report_date_as_of', 6, false ),
            ( sp_15_table_output_step_dwid, 'accrued_through', 'accrued_through', 7, false ),
            ( sp_15_table_output_step_dwid, 'accrued_through_date', 'accrued_through_date', 8, false ),
            ( sp_15_table_output_step_dwid, 'company_name', 'company_name', 9, false ),
            ( sp_15_table_output_step_dwid, 'company_address', 'company_address', 10, false ),
            ( sp_15_table_output_step_dwid, 'company_address_2', 'company_address_2', 11, false ),
            ( sp_15_table_output_step_dwid, 'company_city_state_zip', 'company_city_state_zip', 12, false ),
            ( sp_15_table_output_step_dwid, 'empty_1', 'empty_1', 13, false ),
            ( sp_15_table_output_step_dwid, 'empty_2', 'empty_2', 14, false ),
            ( sp_15_table_output_step_dwid, 'empty_3', 'empty_3', 15, false ),
            ( sp_15_table_output_step_dwid, 'empty_4', 'empty_4', 16, false ),
            ( sp_15_table_output_step_dwid, 'loan_number_header', 'loan_number_header', 17, false ),
            ( sp_15_table_output_step_dwid, 'name_header', 'name_header', 18, false ),
            ( sp_15_table_output_step_dwid, 'note_amount_header', 'note_amount_header', 19, false ),
            ( sp_15_table_output_step_dwid, 'warehouse_amount_header', 'warehouse_amount_header', 20, false ),
            ( sp_15_table_output_step_dwid, 'orig_part_header', 'orig_part_header', 21, false ),
            ( sp_15_table_output_step_dwid, 'int_header', 'int_header', 22, false ),
            ( sp_15_table_output_step_dwid, 'fees_header', 'fees_header', 23, false ),
            ( sp_15_table_output_step_dwid, 'days_header', 'days_header', 24, false ),
            ( sp_15_table_output_step_dwid, 'date_disb_header', 'date_disb_header', 25, false ),
            ( sp_15_table_output_step_dwid, 'note_recd_header', 'note_recd_header', 26, false ),
            ( sp_15_table_output_step_dwid, 'note_shipped_header', 'note_shipped_header', 27, false ),
            ( sp_15_table_output_step_dwid, 'investor_header', 'investor_header', 28, false ),
            ( sp_15_table_output_step_dwid, 'takeout_header', 'takeout_header', 29, false ),
            ( sp_15_table_output_step_dwid, 'tracking_header', 'tracking_header', 30, false ),
            ( sp_15_table_output_step_dwid, 'prod_code_header', 'prod_code_header', 31, false ),
            ( sp_15_table_output_step_dwid, 'index_header', 'index_header', 32, false ),
            ( sp_15_table_output_step_dwid, 'margin_header', 'margin_header', 33, false ),
            ( sp_15_table_output_step_dwid, 'loan_number', 'loan_number', 34, false ),
            ( sp_15_table_output_step_dwid, 'name', 'name', 35, false ),
            ( sp_15_table_output_step_dwid, 'note_amount', 'note_amount', 36, false ),
            ( sp_15_table_output_step_dwid, 'warehouse_amount', 'warehouse_amount', 37, false ),
            ( sp_15_table_output_step_dwid, 'orig_part', 'orig_part', 38, false ),
            ( sp_15_table_output_step_dwid, 'int', 'int', 39, false ),
            ( sp_15_table_output_step_dwid, 'fees', 'fees', 40, false ),
            ( sp_15_table_output_step_dwid, 'days', 'days', 41, false ),
            ( sp_15_table_output_step_dwid, 'date_disb', 'date_disb', 42, false ),
            ( sp_15_table_output_step_dwid, 'note_recd', 'note_recd', 43, false ),
            ( sp_15_table_output_step_dwid, 'note_shipped', 'note_shipped', 44, false ),
            ( sp_15_table_output_step_dwid, 'investor', 'investor', 45, false ),
            ( sp_15_table_output_step_dwid, 'takeout', 'takeout', 46, false ),
            ( sp_15_table_output_step_dwid, 'tracking', 'tracking', 47, false ),
            ( sp_15_table_output_step_dwid, 'product_code', 'product_code', 48, false ),
            ( sp_15_table_output_step_dwid, 'index', 'index', 49, false ),
            ( sp_15_table_output_step_dwid, 'margin', 'margin', 50, false ),
            ( sp_15_table_output_step_dwid, 'company_name_2', 'company_name_2', 51, false ),
            ( sp_15_table_output_step_dwid, 'total_company_loan_count', 'total_company_loan_count', 52, false ),
            ( sp_15_table_output_step_dwid, 'note_amount_total', 'note_amount_total', 53, false ),
            ( sp_15_table_output_step_dwid, 'warehouse_amount_total', 'warehouse_amount_total', 54, false ),
            ( sp_15_table_output_step_dwid, 'orig_part_total', 'orig_part_total', 55, false ),
            ( sp_15_table_output_step_dwid, 'total_interest_amount', 'total_interest_amount', 56, false ),
            ( sp_15_table_output_step_dwid, 'total_fees_amount', 'total_fees_amount', 57, false ),
            ( sp_15_table_output_step_dwid, 'limit_header', 'limit_header', 58, false ),
            ( sp_15_table_output_step_dwid, 'limit_amount', 'limit_amount', 59, false ),
            ( sp_15_table_output_step_dwid, 'available_header', 'available_header', 60, false ),
            ( sp_15_table_output_step_dwid, 'available_amount', 'available_amount', 61, false ),
            ( sp_15_table_output_step_dwid, 'grand_total_header', 'grand_total_header', 62, false ),
            ( sp_15_table_output_step_dwid, 'grand_total_loan_count', 'grand_total_loan_count', 63, false ),
            ( sp_15_table_output_step_dwid, 'grand_total_note_amount', 'grand_total_note_amount', 64, false ),
            ( sp_15_table_output_step_dwid, 'grand_total_warehouse_amount', 'grand_total_warehouse_amount', 65, false ),
            ( sp_15_table_output_step_dwid, 'grand_total_orig_part', 'grand_total_orig_part', 66, false ),
            ( sp_15_table_output_step_dwid, 'grand_total_interest', 'grand_total_interest', 67, false ),
            ( sp_15_table_output_step_dwid, 'grand_total_fees', 'grand_total_fees', 68, false ),
            ( sp_15_table_output_step_dwid, 'crystal_reports_export_page_description', 'crystal_reports_export_page_description', 69, false ),
            ( sp_15_table_output_step_dwid, 'report_export_date', 'report_export_date', 70, false ),
            ( sp_15_table_output_step_dwid, 'report_export_time', 'report_export_time', 71, false ),
            ( sp_15_table_output_step_dwid, 'crystal_reports_report_type', 'crystal_reports_report_type', 72, false )
;

-- SP-15 edw field definition insert
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, data_type)
    VALUES  (sp_15_edw_table_definition_dwid, 'etl_batch_id', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'data_source_dwid', FALSE, 'BIGINT'),
            (sp_15_edw_table_definition_dwid, 'input_filename', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'bank_name', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'report_name', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'report_date_as_of', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'accrued_through', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'accrued_through_date', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'company_name', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'company_address', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'company_address_2', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'company_city_state_zip', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'empty_1', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'empty_2', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'empty_3', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'empty_4', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'loan_number_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'name_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'note_amount_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'warehouse_amount_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'orig_part_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'int_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'fees_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'days_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'date_disb_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'note_recd_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'note_shipped_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'investor_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'takeout_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'tracking_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'prod_code_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'index_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'margin_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'loan_number', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'name', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'note_amount', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'warehouse_amount', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'orig_part', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'int', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'fees', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'days', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'date_disb', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'note_recd', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'note_shipped', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'investor', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'takeout', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'tracking', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'product_code', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'index', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'margin', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'company_name_2', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'total_company_loan_count', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'note_amount_total', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'warehouse_amount_total', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'orig_part_total', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'total_interest_amount', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'total_fees_amount', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'limit_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'limit_amount', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'available_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'available_amount', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'grand_total_header', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'grand_total_loan_count', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'grand_total_note_amount', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'grand_total_warehouse_amount', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'grand_total_orig_part', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'grand_total_interest', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'grand_total_fees', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'crystal_reports_export_page_description', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'report_export_date', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'report_export_time', FALSE, 'TEXT'),
            (sp_15_edw_table_definition_dwid, 'crystal_reports_report_type', FALSE, 'TEXT')
;

-- SP-16 edw table definition insert
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
    VALUES  ('ingress', 'warehouse_banks', 'loan_inventory_truist', NULL)
    RETURNING dwid INTO sp_16_edw_table_definition_dwid;

-- SP-16 process input
    INSERT INTO mdi.process (name, description)
    VALUES ('SP-16', 'Load Truist bank data to the ingress.warehouse_banks.loan_inventory_truist table')
    RETURNING dwid INTO sp_16_process_dwid;


-- SP-16 excel input step insert
    INSERT INTO mdi.microsoft_excel_input_step ( process_dwid, spreadsheet_type, filemask, exclude_filemask
                                               , file_required, include_subfolders, sheet_name, sheet_start_row
                                               , sheet_start_col, data_source_dwid )
    VALUES ( sp_16_process_dwid, 'JXL', '*', NULL, 'Y', 'N', 'Pipeline', 4, 0, 0 )
    RETURNING dwid INTO sp_16_microsoft_excel_input_step_dwid;

-- SP-16 excel input field insert
    INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type, field_format,
            field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
    VALUES  ( sp_16_microsoft_excel_input_step_dwid, 'ACCOUNT', 'String', NULL, -1, -1, '$', '.', ',', 'none', 1 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'LOAN ID', 'String', NULL, -1, -1, '$', '.', ',', 'none', 2 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'LNAME', 'String', NULL, -1, -1, '$', '.', ',', 'none', 3 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'FNAME', 'String', NULL, -1, -1, '$', '.', ',', 'none', 4 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'PRODUCT', 'String', NULL, -1, -1, '$', '.', ',', 'none', 5 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'RATE', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 6 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'NOTE AMOUNT', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 7 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'BALANCE', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 8 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'MTG DATE', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 9 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'DEPOSIT DATE', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 10 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'INCEPTION DATE', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 11 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'AGE CAL', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 12 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'INVESTOR', 'String', NULL, -1, -1, '$', '.', ',', 'none', 13 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'COMMIT #', 'String', NULL, -1, -1, '$', '.', ',', 'none', 14 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'STAGE', 'String', NULL, -1, -1, '$', '.', ',', 'none', 15 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'REL DATE', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 16 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'EXCEPTION FLAG', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 17 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'REL METHOD', 'String', NULL, -1, -1, '$', '.', ',', 'none', 18 ),
            ( sp_16_microsoft_excel_input_step_dwid, 'TRACKING NUM', 'String', NULL, -1, -1, '$', '.', ',', 'none', 19 )
;


-- SP-16 table output step
    INSERT INTO mdi.table_output_step ( process_dwid, target_schema, target_table, commit_size, partitioning_field
                                      , table_name_field, auto_generated_key_field, partition_data_per
                                      , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                      , connectionname, partition_over_tables, specify_database_fields
                                      , ignore_insert_errors, use_batch_update )
    VALUES (sp_16_process_dwid, 'warehouse_banks', 'loan_inventory_truist', 1000, NULL, NULL, NULL, NULL, 'N',
            NULL,'Y' ,'Ingress DB Connection' ,'N' ,'Y' ,'N' ,'N')
    RETURNING dwid INTO sp_16_table_output_step_dwid;

    INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive )
    VALUES  ( sp_16_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', 1, false ),
            ( sp_16_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid', 2, false ),
            ( sp_16_table_output_step_dwid, 'input_filename', 'imported_filename', 3, false ),
            ( sp_16_table_output_step_dwid, 'account', 'ACCOUNT', 4, false ),
            ( sp_16_table_output_step_dwid, 'loan_id', 'LOAN ID', 5, false ),
            ( sp_16_table_output_step_dwid, 'lname', 'LNAME', 6, false ),
            ( sp_16_table_output_step_dwid, 'fname', 'FNAME', 7, false ),
            ( sp_16_table_output_step_dwid, 'product', 'PRODUCT', 8, false ),
            ( sp_16_table_output_step_dwid, 'rate', 'RATE', 9, false ),
            ( sp_16_table_output_step_dwid, 'note_amount', 'NOTE AMOUNT', 10, false ),
            ( sp_16_table_output_step_dwid, 'balance', 'BALANCE', 11, false ),
            ( sp_16_table_output_step_dwid, 'mtg_date', 'MTG DATE', 12, false ),
            ( sp_16_table_output_step_dwid, 'deposit_date', 'DEPOSIT DATE', 13, false ),
            ( sp_16_table_output_step_dwid, 'inception_date', 'INCEPTION DATE', 14, false ),
            ( sp_16_table_output_step_dwid, 'age_cal', 'AGE CAL', 15, false ),
            ( sp_16_table_output_step_dwid, 'investor', 'INVESTOR', 16, false ),
            ( sp_16_table_output_step_dwid, 'commit_number', 'COMMIT #', 17, false ),
            ( sp_16_table_output_step_dwid, 'stage', 'STAGE', 18, false ),
            ( sp_16_table_output_step_dwid, 'rel_date', 'REL DATE', 19, false ),
            ( sp_16_table_output_step_dwid, 'exception_flag', 'EXCEPTION FLAG', 20, false ),
            ( sp_16_table_output_step_dwid, 'rel_method', 'REL METHOD', 21, false ),
            ( sp_16_table_output_step_dwid, 'tracking_num', 'TRACKING NUM', 22, false )
;

-- SP-16 edw field definition insert
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, data_type)
    VALUES  (sp_16_edw_table_definition_dwid, 'etl_batch_id', FALSE, 'TEXT'),
            (sp_16_edw_table_definition_dwid, 'data_source_dwid', FALSE, 'BIGINT'),
            (sp_16_edw_table_definition_dwid, 'input_filename', FALSE, 'TEXT'),
            (sp_16_edw_table_definition_dwid, 'account', FALSE, 'TEXT'),
            (sp_16_edw_table_definition_dwid, 'loan_id', FALSE, 'TEXT'),
            (sp_16_edw_table_definition_dwid, 'lname', FALSE, 'TEXT'),
            (sp_16_edw_table_definition_dwid, 'fname', FALSE, 'TEXT'),
            (sp_16_edw_table_definition_dwid, 'product', FALSE, 'TEXT'),
            (sp_16_edw_table_definition_dwid, 'rate', FALSE, 'NUMERIC(15,9)'),
            (sp_16_edw_table_definition_dwid, 'note_amount', FALSE, 'NUMERIC(21,3)'),
            (sp_16_edw_table_definition_dwid, 'balance', FALSE, 'NUMERIC(21,3)'),
            (sp_16_edw_table_definition_dwid, 'mtg_date', FALSE, 'DATE'),
            (sp_16_edw_table_definition_dwid, 'deposit_date', FALSE, 'DATE'),
            (sp_16_edw_table_definition_dwid, 'inception_date', FALSE, 'DATE'),
            (sp_16_edw_table_definition_dwid, 'age_cal', FALSE, 'INTEGER'),
            (sp_16_edw_table_definition_dwid, 'investor', FALSE, 'TEXT'),
            (sp_16_edw_table_definition_dwid, 'commit_number', FALSE, 'TEXT'),
            (sp_16_edw_table_definition_dwid, 'stage', FALSE, 'TEXT'),
            (sp_16_edw_table_definition_dwid, 'rel_date', FALSE, 'DATE'),
            (sp_16_edw_table_definition_dwid, 'exception_flag', FALSE, 'INTEGER'),
            (sp_16_edw_table_definition_dwid, 'rel_method', FALSE, 'TEXT'),
            (sp_16_edw_table_definition_dwid, 'tracking_num', FALSE, 'TEXT')
;

-- SP-17 edw table definition insert
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
    VALUES  ('ingress', 'warehouse_banks', 'loan_inventory_texas_capital', NULL)
    RETURNING dwid INTO sp_17_edw_table_definition_dwid;

-- SP-17 process input
    INSERT INTO mdi.process (name, description)
    VALUES ('SP-17', 'Load Texas Capital bank data to the ingress.warehoues_banks.loan_inventory_texas_capital table')
    RETURNING dwid INTO sp_17_process_dwid;

-- SP-17 csv file input step insert
    INSERT INTO mdi.csv_file_input_step (process_dwid, header_present, delimiter, enclosure, buffersize
                                        , lazy_conversion, newline_possible, add_filename_result, file_format
                                        , file_encoding, include_filename
                                        , process_in_parallel, filename_field, row_num_field, data_source_dwid )
    VALUES (sp_17_process_dwid, 'N', ',', '"', 1024, 'N', 'Y', 'N', 'mixed', 'UTF-8', 'N', 'N', NULL, NULL, 0 )
    RETURNING dwid INTO sp_17_file_input_step_dwid;

-- SP-17 file input field insert
    INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format,
     field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
    VALUES  ( sp_17_file_input_step_dwid, 'rowtype', 'String', NULL, -1, -1, '$', '.', ',', 'none', 1 ),
            ( sp_17_file_input_step_dwid, 'customer_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 2 ),
            ( sp_17_file_input_step_dwid, 'customer_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 3 ),
            ( sp_17_file_input_step_dwid, 'account_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 4 ),
            ( sp_17_file_input_step_dwid, 'customer_account_key', 'String', NULL, -1, -1, '$', '.', ',', 'none', 5 ),
            ( sp_17_file_input_step_dwid, 'renewal_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 6 ),
            ( sp_17_file_input_step_dwid, 'account_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 7 ),
            ( sp_17_file_input_step_dwid, 'cost_center', 'String', NULL, -1, -1, '$', '.', ',', 'none', 8 ),
            ( sp_17_file_input_step_dwid, 'orig_advance_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 9 ),
            ( sp_17_file_input_step_dwid, 'acquisition_cost', 'String', NULL, -1, -1, '$', '.', ',', 'none', 10 ),
            ( sp_17_file_input_step_dwid, 'address', 'String', NULL, -1, -1, '$', '.', ',', 'none', 11 ),
            ( sp_17_file_input_step_dwid, 'amortization_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 12 ),
            ( sp_17_file_input_step_dwid, 'anncap', 'String', NULL, -1, -1, '$', '.', ',', 'none', 13 ),
            ( sp_17_file_input_step_dwid, 'armadj', 'String', NULL, -1, -1, '$', '.', ',', 'none', 14 ),
            ( sp_17_file_input_step_dwid, 'armconv', 'String', NULL, -1, -1, '$', '.', ',', 'none', 15 ),
            ( sp_17_file_input_step_dwid, 'armindex', 'String', NULL, -1, -1, '$', '.', ',', 'none', 16 ),
            ( sp_17_file_input_step_dwid, 'armmargin', 'String', NULL, -1, -1, '$', '.', ',', 'none', 17 ),
            ( sp_17_file_input_step_dwid, 'armround', 'String', NULL, -1, -1, '$', '.', ',', 'none', 18 ),
            ( sp_17_file_input_step_dwid, 'armteaser', 'String', NULL, -1, -1, '$', '.', ',', 'none', 19 ),
            ( sp_17_file_input_step_dwid, 'as_of_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 20 ),
            ( sp_17_file_input_step_dwid, 'asset_class_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 21 ),
            ( sp_17_file_input_step_dwid, 'auction_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 22 ),
            ( sp_17_file_input_step_dwid, 'balloon_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 23 ),
            ( sp_17_file_input_step_dwid, 'bar_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 24 ),
            ( sp_17_file_input_step_dwid, 'borr_1_first_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 25 ),
            ( sp_17_file_input_step_dwid, 'borr_1_last_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 26 ),
            ( sp_17_file_input_step_dwid, 'borr_2_first_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 27 ),
            ( sp_17_file_input_step_dwid, 'borr_2_last_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 28 ),
            ( sp_17_file_input_step_dwid, 'city', 'String', NULL, -1, -1, '$', '.', ',', 'none', 29 ),
            ( sp_17_file_input_step_dwid, 'closing_agent_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 30 ),
            ( sp_17_file_input_step_dwid, 'coll_closed_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 31 ),
            ( sp_17_file_input_step_dwid, 'coll_valuation_set_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 32 ),
            ( sp_17_file_input_step_dwid, 'coll_value_expire_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 33 ),
            ( sp_17_file_input_step_dwid, 'coll_value_recalc_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 34 ),
            ( sp_17_file_input_step_dwid, 'collateral_key', 'String', NULL, -1, -1, '$', '.', ',', 'none', 35 ),
            ( sp_17_file_input_step_dwid, 'collateral_key2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 36 ),
            ( sp_17_file_input_step_dwid, 'collateral_key3', 'String', NULL, -1, -1, '$', '.', ',', 'none', 37 ),
            ( sp_17_file_input_step_dwid, 'collateral_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 38 ),
            ( sp_17_file_input_step_dwid, 'collateral_value', 'String', NULL, -1, -1, '$', '.', ',', 'none', 39 ),
            ( sp_17_file_input_step_dwid, 'collateral_value_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 40 ),
            ( sp_17_file_input_step_dwid, 'collateral_value_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 41 ),
            ( sp_17_file_input_step_dwid, 'collgroup', 'String', NULL, -1, -1, '$', '.', ',', 'none', 42 ),
            ( sp_17_file_input_step_dwid, 'construction_cost', 'String', NULL, -1, -1, '$', '.', ',', 'none', 43 ),
            ( sp_17_file_input_step_dwid, 'credit_grade_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 44 ),
            ( sp_17_file_input_step_dwid, 'curr_appraised_value', 'String', NULL, -1, -1, '$', '.', ',', 'none', 45 ),
            ( sp_17_file_input_step_dwid, 'curr_payment', 'String', NULL, -1, -1, '$', '.', ',', 'none', 46 ),
            ( sp_17_file_input_step_dwid, 'curr_pledge_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 47 ),
            ( sp_17_file_input_step_dwid, 'curr_rate', 'String', NULL, -1, -1, '$', '.', ',', 'none', 48 ),
            ( sp_17_file_input_step_dwid, 'curr_upb', 'String', NULL, -1, -1, '$', '.', ',', 'none', 49 ),
            ( sp_17_file_input_step_dwid, 'custodian_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 50 ),
            ( sp_17_file_input_step_dwid, 'customer_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 51 ),
            ( sp_17_file_input_step_dwid, 'debt_service_ratio', 'String', NULL, -1, -1, '$', '.', ',', 'none', 52 ),
            ( sp_17_file_input_step_dwid, 'delinquent_days', 'String', NULL, -1, -1, '$', '.', ',', 'none', 53 ),
            ( sp_17_file_input_step_dwid, 'delinquent_history', 'String', NULL, -1, -1, '$', '.', ',', 'none', 54 ),
            ( sp_17_file_input_step_dwid, 'doc_level_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 55 ),
            ( sp_17_file_input_step_dwid, 'document_set_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 56 ),
            ( sp_17_file_input_step_dwid, 'coll_exist_status_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 57 ),
            ( sp_17_file_input_step_dwid, 'expire_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 58 ),
            ( sp_17_file_input_step_dwid, 'fico_score', 'String', NULL, -1, -1, '$', '.', ',', 'none', 59 ),
            ( sp_17_file_input_step_dwid, 'first_rate_change_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 60 ),
            ( sp_17_file_input_step_dwid, 'firstdue', 'String', NULL, -1, -1, '$', '.', ',', 'none', 61 ),
            ( sp_17_file_input_step_dwid, 'coll_home_track_location_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 62 ),
            ( sp_17_file_input_step_dwid, 'instrument_num', 'String', NULL, -1, -1, '$', '.', ',', 'none', 63 ),
            ( sp_17_file_input_step_dwid, 'inv_commit_expire_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 64 ),
            ( sp_17_file_input_step_dwid, 'inv_commit_number', 'String', NULL, -1, -1, '$', '.', ',', 'none', 65 ),
            ( sp_17_file_input_step_dwid, 'inv_commit_price', 'String', NULL, -1, -1, '$', '.', ',', 'none', 66 ),
            ( sp_17_file_input_step_dwid, 'investor_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 67 ),
            ( sp_17_file_input_step_dwid, 'investor_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 68 ),
            ( sp_17_file_input_step_dwid, 'coll_is_active', 'String', NULL, -1, -1, '$', '.', ',', 'none', 69 ),
            ( sp_17_file_input_step_dwid, 'last_paid_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 70 ),
            ( sp_17_file_input_step_dwid, 'lien_position', 'String', NULL, -1, -1, '$', '.', ',', 'none', 71 ),
            ( sp_17_file_input_step_dwid, 'lifecap', 'String', NULL, -1, -1, '$', '.', ',', 'none', 72 ),
            ( sp_17_file_input_step_dwid, 'coll_major_count', 'String', NULL, -1, -1, '$', '.', ',', 'none', 73 ),
            ( sp_17_file_input_step_dwid, 'market_value', 'String', NULL, -1, -1, '$', '.', ',', 'none', 74 ),
            ( sp_17_file_input_step_dwid, 'market_value_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 75 ),
            ( sp_17_file_input_step_dwid, 'market_value_expire_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 76 ),
            ( sp_17_file_input_step_dwid, 'market_value_override_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 77 ),
            ( sp_17_file_input_step_dwid, 'maturity', 'String', NULL, -1, -1, '$', '.', ',', 'none', 78 ),
            ( sp_17_file_input_step_dwid, 'mers_min', 'String', NULL, -1, -1, '$', '.', ',', 'none', 79 ),
            ( sp_17_file_input_step_dwid, 'coll_minor_count', 'String', NULL, -1, -1, '$', '.', ',', 'none', 80 ),
            ( sp_17_file_input_step_dwid, 'months_to_roll', 'String', NULL, -1, -1, '$', '.', ',', 'none', 81 ),
            ( sp_17_file_input_step_dwid, 'next_due_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 82 ),
            ( sp_17_file_input_step_dwid, 'next_inspection_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 83 ),
            ( sp_17_file_input_step_dwid, 'next_rate_change_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 84 ),
            ( sp_17_file_input_step_dwid, 'occupancy_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 85 ),
            ( sp_17_file_input_step_dwid, 'occupancy_ratio', 'String', NULL, -1, -1, '$', '.', ',', 'none', 86 ),
            ( sp_17_file_input_step_dwid, 'orig_appraised_value', 'String', NULL, -1, -1, '$', '.', ',', 'none', 87 ),
            ( sp_17_file_input_step_dwid, 'orig_pledge_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 88 ),
            ( sp_17_file_input_step_dwid, 'orig_rate', 'String', NULL, -1, -1, '$', '.', ',', 'none', 89 ),
            ( sp_17_file_input_step_dwid, 'orig_upb', 'String', NULL, -1, -1, '$', '.', ',', 'none', 90 ),
            ( sp_17_file_input_step_dwid, 'original_cltv', 'String', NULL, -1, -1, '$', '.', ',', 'none', 91 ),
            ( sp_17_file_input_step_dwid, 'original_ltv', 'String', NULL, -1, -1, '$', '.', ',', 'none', 92 ),
            ( sp_17_file_input_step_dwid, 'original_term', 'String', NULL, -1, -1, '$', '.', ',', 'none', 93 ),
            ( sp_17_file_input_step_dwid, 'origination_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 94 ),
            ( sp_17_file_input_step_dwid, 'originator_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 95 ),
            ( sp_17_file_input_step_dwid, 'p_i', 'String', NULL, -1, -1, '$', '.', ',', 'none', 96 ),
            ( sp_17_file_input_step_dwid, 'paid_to_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 97 ),
            ( sp_17_file_input_step_dwid, 'pool_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 98 ),
            ( sp_17_file_input_step_dwid, 'prepay_penalty_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 99 ),
            ( sp_17_file_input_step_dwid, 'prepay_penalty_pct', 'String', NULL, -1, -1, '$', '.', ',', 'none', 100 ),
            ( sp_17_file_input_step_dwid, 'product_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 101 ),
            ( sp_17_file_input_step_dwid, 'production_stage_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 102 ),
            ( sp_17_file_input_step_dwid, 'production_stage_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 103 ),
            ( sp_17_file_input_step_dwid, 'property_type_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 104 ),
            ( sp_17_file_input_step_dwid, 'purpose_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 105 ),
            ( sp_17_file_input_step_dwid, 'rate_change_frequency', 'String', NULL, -1, -1, '$', '.', ',', 'none', 106 ),
            ( sp_17_file_input_step_dwid, 'record_book', 'String', NULL, -1, -1, '$', '.', ',', 'none', 107 ),
            ( sp_17_file_input_step_dwid, 'record_page', 'String', NULL, -1, -1, '$', '.', ',', 'none', 108 ),
            ( sp_17_file_input_step_dwid, 'recorded', 'String', NULL, -1, -1, '$', '.', ',', 'none', 109 ),
            ( sp_17_file_input_step_dwid, 'coll_release_request_identifier', 'String', NULL, -1, -1, '$', '.', ',', 'none', 110 ),
            ( sp_17_file_input_step_dwid, 'scheduled_upb', 'String', NULL, -1, -1, '$', '.', ',', 'none', 111 ),
            ( sp_17_file_input_step_dwid, 'coll_shipment_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 112 ),
            ( sp_17_file_input_step_dwid, 'short_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 113 ),
            ( sp_17_file_input_step_dwid, 'ss_number', 'String', NULL, -1, -1, '$', '.', ',', 'none', 114 ),
            ( sp_17_file_input_step_dwid, 'state', 'String', NULL, -1, -1, '$', '.', ',', 'none', 115 ),
            ( sp_17_file_input_step_dwid, 'tenant_num', 'String', NULL, -1, -1, '$', '.', ',', 'none', 116 ),
            ( sp_17_file_input_step_dwid, 'tmo_ratio', 'String', NULL, -1, -1, '$', '.', ',', 'none', 117 ),
            ( sp_17_file_input_step_dwid, 'track_item_type_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 118 ),
            ( sp_17_file_input_step_dwid, 'coll_track_location_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 119 ),
            ( sp_17_file_input_step_dwid, 'udf_char_1', 'String', NULL, -1, -1, '$', '.', ',', 'none', 120 ),
            ( sp_17_file_input_step_dwid, 'udf_char_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 121 ),
            ( sp_17_file_input_step_dwid, 'udf_date_1', 'String', NULL, -1, -1, '$', '.', ',', 'none', 122 ),
            ( sp_17_file_input_step_dwid, 'udf_date_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 123 ),
            ( sp_17_file_input_step_dwid, 'udf_dollar_1', 'String', NULL, -1, -1, '$', '.', ',', 'none', 124 ),
            ( sp_17_file_input_step_dwid, 'udf_dollar_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 125 ),
            ( sp_17_file_input_step_dwid, 'udf_int_1', 'String', NULL, -1, -1, '$', '.', ',', 'none', 126 ),
            ( sp_17_file_input_step_dwid, 'udf_int_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 127 ),
            ( sp_17_file_input_step_dwid, 'udf_pct_1', 'String', NULL, -1, -1, '$', '.', ',', 'none', 128 ),
            ( sp_17_file_input_step_dwid, 'udf_pct_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 129 ),
            ( sp_17_file_input_step_dwid, 'units', 'String', NULL, -1, -1, '$', '.', ',', 'none', 130 ),
            ( sp_17_file_input_step_dwid, 'zip', 'String', NULL, -1, -1, '$', '.', ',', 'none', 131 ),
            ( sp_17_file_input_step_dwid, 'warehouse_aging_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 132 ),
            ( sp_17_file_input_step_dwid, 'active_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 133 ),
            ( sp_17_file_input_step_dwid, 'doctype_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 134 ),
            ( sp_17_file_input_step_dwid, 'document_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 135 ),
            ( sp_17_file_input_step_dwid, 'document_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 136 ),
            ( sp_17_file_input_step_dwid, 'doc_exist_status_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 137 ),
            ( sp_17_file_input_step_dwid, 'doc_home_track_location_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 138 ),
            ( sp_17_file_input_step_dwid, 'doc_major_count', 'String', NULL, -1, -1, '$', '.', ',', 'none', 139 ),
            ( sp_17_file_input_step_dwid, 'doc_minor_count', 'String', NULL, -1, -1, '$', '.', ',', 'none', 140 ),
            ( sp_17_file_input_step_dwid, 'doc_release_request_identifier', 'String', NULL, -1, -1, '$', '.', ',', 'none', 141 ),
            ( sp_17_file_input_step_dwid, 'doc_track_location_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 142 ),
            ( sp_17_file_input_step_dwid, 'cleared_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 143 ),
            ( sp_17_file_input_step_dwid, 'fatal_error_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 144 ),
            ( sp_17_file_input_step_dwid, 'docex_notation', 'String', NULL, -1, -1, '$', '.', ',', 'none', 145 ),
            ( sp_17_file_input_step_dwid, 'opendate', 'String', NULL, -1, -1, '$', '.', ',', 'none', 146 ),
            ( sp_17_file_input_step_dwid, 'question_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 147 ),
            ( sp_17_file_input_step_dwid, 'updated_by', 'String', NULL, -1, -1, '$', '.', ',', 'none', 148 ),
            ( sp_17_file_input_step_dwid, 'collmemo_active_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 149 ),
            ( sp_17_file_input_step_dwid, 'collmemo_memo_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 150 ),
            ( sp_17_file_input_step_dwid, 'collmemo_memo_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 151 ),
            ( sp_17_file_input_step_dwid, 'collmemo_memo_subject', 'String', NULL, -1, -1, '$', '.', ',', 'none', 152 ),
            ( sp_17_file_input_step_dwid, 'collmemo_memo_text', 'String', NULL, -1, -1, '$', '.', ',', 'none', 153 ),
            ( sp_17_file_input_step_dwid, 'collmemo_memo_type', 'String', NULL, -1, -1, '$', '.', ',', 'none', 154 ),
            ( sp_17_file_input_step_dwid, 'collmemo_posted_by', 'String', NULL, -1, -1, '$', '.', ',', 'none', 155 ),
            ( sp_17_file_input_step_dwid, 'collmemo_private_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 156 ),
            ( sp_17_file_input_step_dwid, 'docmemo_active_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 157 ),
            ( sp_17_file_input_step_dwid, 'docmemo_memo_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 158 ),
            ( sp_17_file_input_step_dwid, 'docmemo_memo_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 159 ),
            ( sp_17_file_input_step_dwid, 'docmemo_memo_subject', 'String', NULL, -1, -1, '$', '.', ',', 'none', 160 ),
            ( sp_17_file_input_step_dwid, 'docmemo_memo_text', 'String', NULL, -1, -1, '$', '.', ',', 'none', 161 ),
            ( sp_17_file_input_step_dwid, 'docmemo_memo_type', 'String', NULL, -1, -1, '$', '.', ',', 'none', 162 ),
            ( sp_17_file_input_step_dwid, 'docmemo_posted_by', 'String', NULL, -1, -1, '$', '.', ',', 'none', 163 ),
            ( sp_17_file_input_step_dwid, 'docmemo_private_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 164 ),
            ( sp_17_file_input_step_dwid, 'business_tran_log_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 165 ),
            ( sp_17_file_input_step_dwid, 'carrier_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 166 ),
            ( sp_17_file_input_step_dwid, 'carrier_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 167 ),
            ( sp_17_file_input_step_dwid, 'certification_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 168 ),
            ( sp_17_file_input_step_dwid, 'destination_type_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 169 ),
            ( sp_17_file_input_step_dwid, 'effective_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 170 ),
            ( sp_17_file_input_step_dwid, 'deposit_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 171 ),
            ( sp_17_file_input_step_dwid, 'release_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 172 ),
            ( sp_17_file_input_step_dwid, 'effective_rate', 'String', NULL, -1, -1, '$', '.', ',', 'none', 173 ),
            ( sp_17_file_input_step_dwid, 'handling_option', 'String', NULL, -1, -1, '$', '.', ',', 'none', 174 ),
            ( sp_17_file_input_step_dwid, 'btl_investor_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 175 ),
            ( sp_17_file_input_step_dwid, 'btl_notation', 'String', NULL, -1, -1, '$', '.', ',', 'none', 176 ),
            ( sp_17_file_input_step_dwid, 'posted_by', 'String', NULL, -1, -1, '$', '.', ',', 'none', 177 ),
            ( sp_17_file_input_step_dwid, 'release_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 178 ),
            ( sp_17_file_input_step_dwid, 'release_request_identifier', 'String', NULL, -1, -1, '$', '.', ',', 'none', 179 ),
            ( sp_17_file_input_step_dwid, 'request_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 180 ),
            ( sp_17_file_input_step_dwid, 'requestor', 'String', NULL, -1, -1, '$', '.', ',', 'none', 181 ),
            ( sp_17_file_input_step_dwid, 'return_due_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 182 ),
            ( sp_17_file_input_step_dwid, 'reversal_method', 'String', NULL, -1, -1, '$', '.', ',', 'none', 183 ),
            ( sp_17_file_input_step_dwid, 'shipment_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 184 ),
            ( sp_17_file_input_step_dwid, 'task_type_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 185 ),
            ( sp_17_file_input_step_dwid, 'task_type_code_rel', 'String', NULL, -1, -1, '$', '.', ',', 'none', 186 ),
            ( sp_17_file_input_step_dwid, 'btl_track_location_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 187 ),
            ( sp_17_file_input_step_dwid, 'transtype', 'String', NULL, -1, -1, '$', '.', ',', 'none', 188 ),
            ( sp_17_file_input_step_dwid, 'workbin_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 189 ),
            ( sp_17_file_input_step_dwid, 'funding_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 190 ),
            ( sp_17_file_input_step_dwid, 'funding_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 191 ),
            ( sp_17_file_input_step_dwid, 'sched_funding_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 192 ),
            ( sp_17_file_input_step_dwid, 'doctype_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 193 ),
            ( sp_17_file_input_step_dwid, 'question_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 194 ),
            ( sp_17_file_input_step_dwid, 'expires', 'String', NULL, -1, -1, '$', '.', ',', 'none', 195 ),
            ( sp_17_file_input_step_dwid, 'loan_is_active', 'String', NULL, -1, -1, '$', '.', ',', 'none', 196 ),
            ( sp_17_file_input_step_dwid, 'lender_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 197 ),
            ( sp_17_file_input_step_dwid, 'loan_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 198 ),
            ( sp_17_file_input_step_dwid, 'loan_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 199 ),
            ( sp_17_file_input_step_dwid, 'loan_inception', 'String', NULL, -1, -1, '$', '.', ',', 'none', 200 ),
            ( sp_17_file_input_step_dwid, 'loan_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 201 ),
            ( sp_17_file_input_step_dwid, 'max_balance_amt', 'String', NULL, -1, -1, '$', '.', ',', 'none', 202 ),
            ( sp_17_file_input_step_dwid, 'max_balance_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 203 ),
            ( sp_17_file_input_step_dwid, 'max_balance_pct', 'String', NULL, -1, -1, '$', '.', ',', 'none', 204 ),
            ( sp_17_file_input_step_dwid, 'orig_prin_balance', 'String', NULL, -1, -1, '$', '.', ',', 'none', 205 ),
            ( sp_17_file_input_step_dwid, 'payoff_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 206 ),
            ( sp_17_file_input_step_dwid, 'pricing_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 207 ),
            ( sp_17_file_input_step_dwid, 'pricing_rule_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 208 ),
            ( sp_17_file_input_step_dwid, 'pricing_rule_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 209 ),
            ( sp_17_file_input_step_dwid, 'sequence', 'String', NULL, -1, -1, '$', '.', ',', 'none', 210 ),
            ( sp_17_file_input_step_dwid, 'curr_prin_balance', 'String', NULL, -1, -1, '$', '.', ',', 'none', 211 ),
            ( sp_17_file_input_step_dwid, 'curr_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 212 ),
            ( sp_17_file_input_step_dwid, 'curr_interest', 'String', NULL, -1, -1, '$', '.', ',', 'none', 213 ),
            ( sp_17_file_input_step_dwid, 'curr_fee', 'String', NULL, -1, -1, '$', '.', ',', 'none', 214 ),
            ( sp_17_file_input_step_dwid, 'curr_cof', 'String', NULL, -1, -1, '$', '.', ',', 'none', 215 ),
            ( sp_17_file_input_step_dwid, 'curr_unapplied', 'String', NULL, -1, -1, '$', '.', ',', 'none', 216 ),
            ( sp_17_file_input_step_dwid, 'redemptive_value', 'String', NULL, -1, -1, '$', '.', ',', 'none', 217 ),
            ( sp_17_file_input_step_dwid, 'lender_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 218 ),
            ( sp_17_file_input_step_dwid, 'lender_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 219 ),
            ( sp_17_file_input_step_dwid, 'cdays_aging', 'String', NULL, -1, -1, '$', '.', ',', 'none', 220 ),
            ( sp_17_file_input_step_dwid, 'bdays_aging', 'String', NULL, -1, -1, '$', '.', ',', 'none', 221 ),
            ( sp_17_file_input_step_dwid, 'coll_group_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 222 ),
            ( sp_17_file_input_step_dwid, 'member_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 223 ),
            ( sp_17_file_input_step_dwid, 'query_stmt_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 224 ),
            ( sp_17_file_input_step_dwid, 'cleared_docex_notation', 'String', NULL, -1, -1, '$', '.', ',', 'none', 225 ),
            ( sp_17_file_input_step_dwid, 'cleared_opendate', 'String', NULL, -1, -1, '$', '.', ',', 'none', 226 ),
            ( sp_17_file_input_step_dwid, 'cleared_question_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 227 ),
            ( sp_17_file_input_step_dwid, 'cleared_question_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 228 ),
            ( sp_17_file_input_step_dwid, 'takeout_value', 'String', NULL, -1, -1, '$', '.', ',', 'none', 229 ),
            ( sp_17_file_input_step_dwid, 'collateral_deficit', 'String', NULL, -1, -1, '$', '.', ',', 'none', 230 ),
            ( sp_17_file_input_step_dwid, 'curr_cltv', 'String', NULL, -1, -1, '$', '.', ',', 'none', 231 ),
            ( sp_17_file_input_step_dwid, 'curr_ltv', 'String', NULL, -1, -1, '$', '.', ',', 'none', 232 ),
            ( sp_17_file_input_step_dwid, 'customer_code_list', 'String', NULL, -1, -1, '$', '.', ',', 'none', 233 ),
            ( sp_17_file_input_step_dwid, 'customer_account_key_list', 'String', NULL, -1, -1, '$', '.', ',', 'none', 234 ),
            ( sp_17_file_input_step_dwid, 'exist_status_code_list', 'String', NULL, -1, -1, '$', '.', ',', 'none', 235 ),
            ( sp_17_file_input_step_dwid, 'date_analysis', 'String', NULL, -1, -1, '$', '.', ',', 'none', 236 ),
            ( sp_17_file_input_step_dwid, 'coll_sel_opt', 'String', NULL, -1, -1, '$', '.', ',', 'none', 237 ),
            ( sp_17_file_input_step_dwid, 'begin_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 238 ),
            ( sp_17_file_input_step_dwid, 'end_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 239 ),
            ( sp_17_file_input_step_dwid, 'print_memos', 'String', NULL, -1, -1, '$', '.', ',', 'none', 240 ),
            ( sp_17_file_input_step_dwid, 'production_stage_code_list', 'String', NULL, -1, -1, '$', '.', ',', 'none', 241 ),
            ( sp_17_file_input_step_dwid, 'print_docs', 'String', NULL, -1, -1, '$', '.', ',', 'none', 242 ),
            ( sp_17_file_input_step_dwid, 'print_exceptions', 'String', NULL, -1, -1, '$', '.', ',', 'none', 243 ),
            ( sp_17_file_input_step_dwid, 'sort_option', 'String', NULL, -1, -1, '$', '.', ',', 'none', 244 ),
            ( sp_17_file_input_step_dwid, 'format_option', 'String', NULL, -1, -1, '$', '.', ',', 'none', 245 )
;

-- SP-17 table output step
    INSERT INTO mdi.table_output_step ( process_dwid, target_schema, target_table, commit_size, partitioning_field
                                      , table_name_field, auto_generated_key_field, partition_data_per
                                      , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                      , connectionname, partition_over_tables, specify_database_fields
                                      , ignore_insert_errors, use_batch_update )
    VALUES (sp_17_process_dwid, 'warehouse_banks', 'loan_inventory_texas_capital', 1000, NULL, NULL, NULL, NULL, 'N',
            NULL,'Y' ,'Ingress DB Connection' ,'N' ,'Y' ,'N' ,'N')
    RETURNING dwid INTO sp_17_table_output_step_dwid;

    INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive )
    VALUES  ( sp_17_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', 1, false ),
            ( sp_17_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid', 2, false ),
            ( sp_17_table_output_step_dwid, 'input_filename', 'imported_filename', 3, false ),
            ( sp_17_table_output_step_dwid, 'rowtype', 'rowtype', 4, false ),
            ( sp_17_table_output_step_dwid, 'customer_code', 'customer_code', 5, false ),
            ( sp_17_table_output_step_dwid, 'customer_name', 'customer_name', 6, false ),
            ( sp_17_table_output_step_dwid, 'account_sak', 'account_sak', 7, false ),
            ( sp_17_table_output_step_dwid, 'customer_account_key', 'customer_account_key', 8, false ),
            ( sp_17_table_output_step_dwid, 'renewal_date', 'renewal_date', 9, false ),
            ( sp_17_table_output_step_dwid, 'account_descr', 'account_descr', 10, false ),
            ( sp_17_table_output_step_dwid, 'cost_center', 'cost_center', 11, false ),
            ( sp_17_table_output_step_dwid, 'orig_advance_date', 'orig_advance_date', 12, false ),
            ( sp_17_table_output_step_dwid, 'acquisition_cost', 'acquisition_cost', 13, false ),
            ( sp_17_table_output_step_dwid, 'address', 'address', 14, false ),
            ( sp_17_table_output_step_dwid, 'amortization_code', 'amortization_code', 15, false ),
            ( sp_17_table_output_step_dwid, 'anncap', 'anncap', 16, false ),
            ( sp_17_table_output_step_dwid, 'armadj', 'armadj', 17, false ),
            ( sp_17_table_output_step_dwid, 'armconv', 'armconv', 18, false ),
            ( sp_17_table_output_step_dwid, 'armindex', 'armindex', 19, false ),
            ( sp_17_table_output_step_dwid, 'armmargin', 'armmargin', 20, false ),
            ( sp_17_table_output_step_dwid, 'armround', 'armround', 21, false ),
            ( sp_17_table_output_step_dwid, 'armteaser', 'armteaser', 22, false ),
            ( sp_17_table_output_step_dwid, 'as_of_date', 'as_of_date', 23, false ),
            ( sp_17_table_output_step_dwid, 'asset_class_code', 'asset_class_code', 24, false ),
            ( sp_17_table_output_step_dwid, 'auction_date', 'auction_date', 25, false ),
            ( sp_17_table_output_step_dwid, 'balloon_flag', 'balloon_flag', 26, false ),
            ( sp_17_table_output_step_dwid, 'bar_code', 'bar_code', 27, false ),
            ( sp_17_table_output_step_dwid, 'borr_1_first_name', 'borr_1_first_name', 28, false ),
            ( sp_17_table_output_step_dwid, 'borr_1_last_name', 'borr_1_last_name', 29, false ),
            ( sp_17_table_output_step_dwid, 'borr_2_first_name', 'borr_2_first_name', 30, false ),
            ( sp_17_table_output_step_dwid, 'borr_2_last_name', 'borr_2_last_name', 31, false ),
            ( sp_17_table_output_step_dwid, 'city', 'city', 32, false ),
            ( sp_17_table_output_step_dwid, 'closing_agent_code', 'closing_agent_code', 33, false ),
            ( sp_17_table_output_step_dwid, 'coll_closed_date', 'coll_closed_date', 34, false ),
            ( sp_17_table_output_step_dwid, 'coll_valuation_set_code', 'coll_valuation_set_code', 35, false ),
            ( sp_17_table_output_step_dwid, 'coll_value_expire_date', 'coll_value_expire_date', 36, false ),
            ( sp_17_table_output_step_dwid, 'coll_value_recalc_flag', 'coll_value_recalc_flag', 37, false ),
            ( sp_17_table_output_step_dwid, 'collateral_key', 'collateral_key', 38, false ),
            ( sp_17_table_output_step_dwid, 'collateral_key2', 'collateral_key2', 39, false ),
            ( sp_17_table_output_step_dwid, 'collateral_key3', 'collateral_key3', 40, false ),
            ( sp_17_table_output_step_dwid, 'collateral_sak', 'collateral_sak', 41, false ),
            ( sp_17_table_output_step_dwid, 'collateral_value', 'collateral_value', 42, false ),
            ( sp_17_table_output_step_dwid, 'collateral_value_date', 'collateral_value_date', 43, false ),
            ( sp_17_table_output_step_dwid, 'collateral_value_flag', 'collateral_value_flag', 44, false ),
            ( sp_17_table_output_step_dwid, 'collgroup', 'collgroup', 45, false ),
            ( sp_17_table_output_step_dwid, 'construction_cost', 'construction_cost', 46, false ),
            ( sp_17_table_output_step_dwid, 'credit_grade_code', 'credit_grade_code', 47, false ),
            ( sp_17_table_output_step_dwid, 'curr_appraised_value', 'curr_appraised_value', 48, false ),
            ( sp_17_table_output_step_dwid, 'curr_payment', 'curr_payment', 49, false ),
            ( sp_17_table_output_step_dwid, 'curr_pledge_date', 'curr_pledge_date', 50, false ),
            ( sp_17_table_output_step_dwid, 'curr_rate', 'curr_rate', 51, false ),
            ( sp_17_table_output_step_dwid, 'curr_upb', 'curr_upb', 52, false ),
            ( sp_17_table_output_step_dwid, 'custodian_sak', 'custodian_sak', 53, false ),
            ( sp_17_table_output_step_dwid, 'customer_sak', 'customer_sak', 54, false ),
            ( sp_17_table_output_step_dwid, 'debt_service_ratio', 'debt_service_ratio', 55, false ),
            ( sp_17_table_output_step_dwid, 'delinquent_days', 'delinquent_days', 56, false ),
            ( sp_17_table_output_step_dwid, 'delinquent_history', 'delinquent_history', 57, false ),
            ( sp_17_table_output_step_dwid, 'doc_level_code', 'doc_level_code', 58, false ),
            ( sp_17_table_output_step_dwid, 'document_set_code', 'document_set_code', 59, false ),
            ( sp_17_table_output_step_dwid, 'coll_exist_status_code', 'coll_exist_status_code', 60, false ),
            ( sp_17_table_output_step_dwid, 'expire_date', 'expire_date', 61, false ),
            ( sp_17_table_output_step_dwid, 'fico_score', 'fico_score', 62, false ),
            ( sp_17_table_output_step_dwid, 'first_rate_change_date', 'first_rate_change_date', 63, false ),
            ( sp_17_table_output_step_dwid, 'firstdue', 'firstdue', 64, false ),
            ( sp_17_table_output_step_dwid, 'coll_home_track_location_code', 'coll_home_track_location_code', 65, false ),
            ( sp_17_table_output_step_dwid, 'instrument_num', 'instrument_num', 66, false ),
            ( sp_17_table_output_step_dwid, 'inv_commit_expire_date', 'inv_commit_expire_date', 67, false ),
            ( sp_17_table_output_step_dwid, 'inv_commit_number', 'inv_commit_number', 68, false ),
            ( sp_17_table_output_step_dwid, 'inv_commit_price', 'inv_commit_price', 69, false ),
            ( sp_17_table_output_step_dwid, 'investor_code', 'investor_code', 70, false ),
            ( sp_17_table_output_step_dwid, 'investor_id', 'investor_id', 71, false ),
            ( sp_17_table_output_step_dwid, 'coll_is_active', 'coll_is_active', 72, false ),
            ( sp_17_table_output_step_dwid, 'last_paid_date', 'last_paid_date', 73, false ),
            ( sp_17_table_output_step_dwid, 'lien_position', 'lien_position', 74, false ),
            ( sp_17_table_output_step_dwid, 'lifecap', 'lifecap', 75, false ),
            ( sp_17_table_output_step_dwid, 'coll_major_count', 'coll_major_count', 76, false ),
            ( sp_17_table_output_step_dwid, 'market_value', 'market_value', 77, false ),
            ( sp_17_table_output_step_dwid, 'market_value_date', 'market_value_date', 78, false ),
            ( sp_17_table_output_step_dwid, 'market_value_expire_date', 'market_value_expire_date', 79, false ),
            ( sp_17_table_output_step_dwid, 'market_value_override_flag', 'market_value_override_flag', 80, false ),
            ( sp_17_table_output_step_dwid, 'maturity', 'maturity', 81, false ),
            ( sp_17_table_output_step_dwid, 'mers_min', 'mers_min', 82, false ),
            ( sp_17_table_output_step_dwid, 'coll_minor_count', 'coll_minor_count', 83, false ),
            ( sp_17_table_output_step_dwid, 'months_to_roll', 'months_to_roll', 84, false ),
            ( sp_17_table_output_step_dwid, 'next_due_date', 'next_due_date', 85, false ),
            ( sp_17_table_output_step_dwid, 'next_inspection_date', 'next_inspection_date', 86, false ),
            ( sp_17_table_output_step_dwid, 'next_rate_change_date', 'next_rate_change_date', 87, false ),
            ( sp_17_table_output_step_dwid, 'occupancy_code', 'occupancy_code', 88, false ),
            ( sp_17_table_output_step_dwid, 'occupancy_ratio', 'occupancy_ratio', 89, false ),
            ( sp_17_table_output_step_dwid, 'orig_appraised_value', 'orig_appraised_value', 90, false ),
            ( sp_17_table_output_step_dwid, 'orig_pledge_date', 'orig_pledge_date', 91, false ),
            ( sp_17_table_output_step_dwid, 'orig_rate', 'orig_rate', 92, false ),
            ( sp_17_table_output_step_dwid, 'orig_upb', 'orig_upb', 93, false ),
            ( sp_17_table_output_step_dwid, 'original_cltv', 'original_cltv', 94, false ),
            ( sp_17_table_output_step_dwid, 'original_ltv', 'original_ltv', 95, false ),
            ( sp_17_table_output_step_dwid, 'original_term', 'original_term', 96, false ),
            ( sp_17_table_output_step_dwid, 'origination_date', 'origination_date', 97, false ),
            ( sp_17_table_output_step_dwid, 'originator_code', 'originator_code', 98, false ),
            ( sp_17_table_output_step_dwid, 'p_i', 'p_i', 99, false ),
            ( sp_17_table_output_step_dwid, 'paid_to_date', 'paid_to_date', 100, false ),
            ( sp_17_table_output_step_dwid, 'pool_id', 'pool_id', 101, false ),
            ( sp_17_table_output_step_dwid, 'prepay_penalty_flag', 'prepay_penalty_flag', 102, false ),
            ( sp_17_table_output_step_dwid, 'prepay_penalty_pct', 'prepay_penalty_pct', 103, false ),
            ( sp_17_table_output_step_dwid, 'product_code', 'product_code', 104, false ),
            ( sp_17_table_output_step_dwid, 'production_stage_code', 'production_stage_code', 105, false ),
            ( sp_17_table_output_step_dwid, 'production_stage_date', 'production_stage_date', 106, false ),
            ( sp_17_table_output_step_dwid, 'property_type_code', 'property_type_code', 107, false ),
            ( sp_17_table_output_step_dwid, 'purpose_code', 'purpose_code', 108, false ),
            ( sp_17_table_output_step_dwid, 'rate_change_frequency', 'rate_change_frequency', 109, false ),
            ( sp_17_table_output_step_dwid, 'record_book', 'record_book', 110, false ),
            ( sp_17_table_output_step_dwid, 'record_page', 'record_page', 111, false ),
            ( sp_17_table_output_step_dwid, 'recorded', 'recorded', 112, false ),
            ( sp_17_table_output_step_dwid, 'coll_release_request_identifier', 'coll_release_request_identifier', 113, false ),
            ( sp_17_table_output_step_dwid, 'scheduled_upb', 'scheduled_upb', 114, false ),
            ( sp_17_table_output_step_dwid, 'coll_shipment_id', 'coll_shipment_id', 115, false ),
            ( sp_17_table_output_step_dwid, 'short_name', 'short_name', 116, false ),
            ( sp_17_table_output_step_dwid, 'state', 'state', 118, false ),
            ( sp_17_table_output_step_dwid, 'tenant_num', 'tenant_num', 119, false ),
            ( sp_17_table_output_step_dwid, 'tmo_ratio', 'tmo_ratio', 120, false ),
            ( sp_17_table_output_step_dwid, 'track_item_type_code', 'track_item_type_code', 121, false ),
            ( sp_17_table_output_step_dwid, 'coll_track_location_code', 'coll_track_location_code', 122, false ),
            ( sp_17_table_output_step_dwid, 'udf_char_1', 'udf_char_1', 123, false ),
            ( sp_17_table_output_step_dwid, 'udf_char_2', 'udf_char_2', 124, false ),
            ( sp_17_table_output_step_dwid, 'udf_date_1', 'udf_date_1', 125, false ),
            ( sp_17_table_output_step_dwid, 'udf_date_2', 'udf_date_2', 126, false ),
            ( sp_17_table_output_step_dwid, 'udf_dollar_1', 'udf_dollar_1', 127, false ),
            ( sp_17_table_output_step_dwid, 'udf_dollar_2', 'udf_dollar_2', 128, false ),
            ( sp_17_table_output_step_dwid, 'udf_int_1', 'udf_int_1', 129, false ),
            ( sp_17_table_output_step_dwid, 'udf_int_2', 'udf_int_2', 130, false ),
            ( sp_17_table_output_step_dwid, 'udf_pct_1', 'udf_pct_1', 131, false ),
            ( sp_17_table_output_step_dwid, 'udf_pct_2', 'udf_pct_2', 132, false ),
            ( sp_17_table_output_step_dwid, 'units', 'units', 133, false ),
            ( sp_17_table_output_step_dwid, 'zip', 'zip', 134, false ),
            ( sp_17_table_output_step_dwid, 'warehouse_aging_date', 'warehouse_aging_date', 135, false ),
            ( sp_17_table_output_step_dwid, 'active_flag', 'active_flag', 136, false ),
            ( sp_17_table_output_step_dwid, 'doctype_code', 'doctype_code', 137, false ),
            ( sp_17_table_output_step_dwid, 'document_descr', 'document_descr', 138, false ),
            ( sp_17_table_output_step_dwid, 'document_sak', 'document_sak', 139, false ),
            ( sp_17_table_output_step_dwid, 'doc_exist_status_code', 'doc_exist_status_code', 140, false ),
            ( sp_17_table_output_step_dwid, 'doc_home_track_location_code', 'doc_home_track_location_code', 141, false ),
            ( sp_17_table_output_step_dwid, 'doc_major_count', 'doc_major_count', 142, false ),
            ( sp_17_table_output_step_dwid, 'doc_minor_count', 'doc_minor_count', 143, false ),
            ( sp_17_table_output_step_dwid, 'doc_release_request_identifier', 'doc_release_request_identifier', 144, false ),
            ( sp_17_table_output_step_dwid, 'doc_track_location_code', 'doc_track_location_code', 145, false ),
            ( sp_17_table_output_step_dwid, 'cleared_flag', 'cleared_flag', 146, false ),
            ( sp_17_table_output_step_dwid, 'fatal_error_flag', 'fatal_error_flag', 147, false ),
            ( sp_17_table_output_step_dwid, 'docex_notation', 'docex_notation', 148, false ),
            ( sp_17_table_output_step_dwid, 'opendate', 'opendate', 149, false ),
            ( sp_17_table_output_step_dwid, 'question_code', 'question_code', 150, false ),
            ( sp_17_table_output_step_dwid, 'updated_by', 'updated_by', 151, false ),
            ( sp_17_table_output_step_dwid, 'collmemo_active_flag', 'collmemo_active_flag', 152, false ),
            ( sp_17_table_output_step_dwid, 'collmemo_memo_date', 'collmemo_memo_date', 153, false ),
            ( sp_17_table_output_step_dwid, 'collmemo_memo_sak', 'collmemo_memo_sak', 154, false ),
            ( sp_17_table_output_step_dwid, 'collmemo_memo_subject', 'collmemo_memo_subject', 155, false ),
            ( sp_17_table_output_step_dwid, 'collmemo_memo_text', 'collmemo_memo_text', 156, false ),
            ( sp_17_table_output_step_dwid, 'collmemo_memo_type', 'collmemo_memo_type', 157, false ),
            ( sp_17_table_output_step_dwid, 'collmemo_posted_by', 'collmemo_posted_by', 158, false ),
            ( sp_17_table_output_step_dwid, 'collmemo_private_flag', 'collmemo_private_flag', 159, false ),
            ( sp_17_table_output_step_dwid, 'docmemo_active_flag', 'docmemo_active_flag', 160, false ),
            ( sp_17_table_output_step_dwid, 'docmemo_memo_date', 'docmemo_memo_date', 161, false ),
            ( sp_17_table_output_step_dwid, 'docmemo_memo_sak', 'docmemo_memo_sak', 162, false ),
            ( sp_17_table_output_step_dwid, 'docmemo_memo_subject', 'docmemo_memo_subject', 163, false ),
            ( sp_17_table_output_step_dwid, 'docmemo_memo_text', 'docmemo_memo_text', 164, false ),
            ( sp_17_table_output_step_dwid, 'docmemo_memo_type', 'docmemo_memo_type', 165, false ),
            ( sp_17_table_output_step_dwid, 'docmemo_posted_by', 'docmemo_posted_by', 166, false ),
            ( sp_17_table_output_step_dwid, 'docmemo_private_flag', 'docmemo_private_flag', 167, false ),
            ( sp_17_table_output_step_dwid, 'business_tran_log_sak', 'business_tran_log_sak', 168, false ),
            ( sp_17_table_output_step_dwid, 'carrier_code', 'carrier_code', 169, false ),
            ( sp_17_table_output_step_dwid, 'carrier_id', 'carrier_id', 170, false ),
            ( sp_17_table_output_step_dwid, 'certification_code', 'certification_code', 171, false ),
            ( sp_17_table_output_step_dwid, 'destination_type_flag', 'destination_type_flag', 172, false ),
            ( sp_17_table_output_step_dwid, 'effective_date', 'effective_date', 173, false ),
            ( sp_17_table_output_step_dwid, 'deposit_date', 'deposit_date', 174, false ),
            ( sp_17_table_output_step_dwid, 'release_date', 'release_date', 175, false ),
            ( sp_17_table_output_step_dwid, 'effective_rate', 'effective_rate', 176, false ),
            ( sp_17_table_output_step_dwid, 'handling_option', 'handling_option', 177, false ),
            ( sp_17_table_output_step_dwid, 'btl_investor_code', 'btl_investor_code', 178, false ),
            ( sp_17_table_output_step_dwid, 'btl_notation', 'btl_notation', 179, false ),
            ( sp_17_table_output_step_dwid, 'posted_by', 'posted_by', 180, false ),
            ( sp_17_table_output_step_dwid, 'release_code', 'release_code', 181, false ),
            ( sp_17_table_output_step_dwid, 'release_request_identifier', 'release_request_identifier', 182, false ),
            ( sp_17_table_output_step_dwid, 'request_date', 'request_date', 183, false ),
            ( sp_17_table_output_step_dwid, 'requestor', 'requestor', 184, false ),
            ( sp_17_table_output_step_dwid, 'return_due_date', 'return_due_date', 185, false ),
            ( sp_17_table_output_step_dwid, 'reversal_method', 'reversal_method', 186, false ),
            ( sp_17_table_output_step_dwid, 'shipment_id', 'shipment_id', 187, false ),
            ( sp_17_table_output_step_dwid, 'task_type_code', 'task_type_code', 188, false ),
            ( sp_17_table_output_step_dwid, 'task_type_code_rel', 'task_type_code_rel', 189, false ),
            ( sp_17_table_output_step_dwid, 'btl_track_location_code', 'btl_track_location_code', 190, false ),
            ( sp_17_table_output_step_dwid, 'transtype', 'transtype', 191, false ),
            ( sp_17_table_output_step_dwid, 'workbin_code', 'workbin_code', 192, false ),
            ( sp_17_table_output_step_dwid, 'funding_id', 'funding_id', 193, false ),
            ( sp_17_table_output_step_dwid, 'funding_date', 'funding_date', 194, false ),
            ( sp_17_table_output_step_dwid, 'sched_funding_date', 'sched_funding_date', 195, false ),
            ( sp_17_table_output_step_dwid, 'doctype_descr', 'doctype_descr', 196, false ),
            ( sp_17_table_output_step_dwid, 'question_descr', 'question_descr', 197, false ),
            ( sp_17_table_output_step_dwid, 'expires', 'expires', 198, false ),
            ( sp_17_table_output_step_dwid, 'loan_is_active', 'loan_is_active', 199, false ),
            ( sp_17_table_output_step_dwid, 'lender_sak', 'lender_sak', 200, false ),
            ( sp_17_table_output_step_dwid, 'loan_descr', 'loan_descr', 201, false ),
            ( sp_17_table_output_step_dwid, 'loan_id', 'loan_id', 202, false ),
            ( sp_17_table_output_step_dwid, 'loan_inception', 'loan_inception', 203, false ),
            ( sp_17_table_output_step_dwid, 'loan_sak', 'loan_sak', 204, false ),
            ( sp_17_table_output_step_dwid, 'max_balance_amt', 'max_balance_amt', 205, false ),
            ( sp_17_table_output_step_dwid, 'max_balance_flag', 'max_balance_flag', 206, false ),
            ( sp_17_table_output_step_dwid, 'max_balance_pct', 'max_balance_pct', 207, false ),
            ( sp_17_table_output_step_dwid, 'orig_prin_balance', 'orig_prin_balance', 208, false ),
            ( sp_17_table_output_step_dwid, 'payoff_date', 'payoff_date', 209, false ),
            ( sp_17_table_output_step_dwid, 'pricing_flag', 'pricing_flag', 210, false ),
            ( sp_17_table_output_step_dwid, 'pricing_rule_code', 'pricing_rule_code', 211, false ),
            ( sp_17_table_output_step_dwid, 'pricing_rule_flag', 'pricing_rule_flag', 212, false ),
            ( sp_17_table_output_step_dwid, 'sequence', 'sequence', 213, false ),
            ( sp_17_table_output_step_dwid, 'curr_prin_balance', 'curr_prin_balance', 214, false ),
            ( sp_17_table_output_step_dwid, 'curr_amount', 'curr_amount', 215, false ),
            ( sp_17_table_output_step_dwid, 'curr_interest', 'curr_interest', 216, false ),
            ( sp_17_table_output_step_dwid, 'curr_fee', 'curr_fee', 217, false ),
            ( sp_17_table_output_step_dwid, 'curr_cof', 'curr_cof', 218, false ),
            ( sp_17_table_output_step_dwid, 'curr_unapplied', 'curr_unapplied', 219, false ),
            ( sp_17_table_output_step_dwid, 'redemptive_value', 'redemptive_value', 220, false ),
            ( sp_17_table_output_step_dwid, 'lender_code', 'lender_code', 221, false ),
            ( sp_17_table_output_step_dwid, 'lender_descr', 'lender_descr', 222, false ),
            ( sp_17_table_output_step_dwid, 'cdays_aging', 'cdays_aging', 223, false ),
            ( sp_17_table_output_step_dwid, 'bdays_aging', 'bdays_aging', 224, false ),
            ( sp_17_table_output_step_dwid, 'coll_group_code', 'coll_group_code', 225, false ),
            ( sp_17_table_output_step_dwid, 'member_sak', 'member_sak', 226, false ),
            ( sp_17_table_output_step_dwid, 'query_stmt_descr', 'query_stmt_descr', 227, false ),
            ( sp_17_table_output_step_dwid, 'cleared_docex_notation', 'cleared_docex_notation', 228, false ),
            ( sp_17_table_output_step_dwid, 'cleared_opendate', 'cleared_opendate', 229, false ),
            ( sp_17_table_output_step_dwid, 'cleared_question_code', 'cleared_question_code', 230, false ),
            ( sp_17_table_output_step_dwid, 'cleared_question_descr', 'cleared_question_descr', 231, false ),
            ( sp_17_table_output_step_dwid, 'takeout_value', 'takeout_value', 232, false ),
            ( sp_17_table_output_step_dwid, 'collateral_deficit', 'collateral_deficit', 233, false ),
            ( sp_17_table_output_step_dwid, 'curr_cltv', 'curr_cltv', 234, false ),
            ( sp_17_table_output_step_dwid, 'curr_ltv', 'curr_ltv', 235, false ),
            ( sp_17_table_output_step_dwid, 'customer_code_list', 'customer_code_list', 236, false ),
            ( sp_17_table_output_step_dwid, 'customer_account_key_list', 'customer_account_key_list', 237, false ),
            ( sp_17_table_output_step_dwid, 'exist_status_code_list', 'exist_status_code_list', 238, false ),
            ( sp_17_table_output_step_dwid, 'date_analysis', 'date_analysis', 239, false ),
            ( sp_17_table_output_step_dwid, 'coll_sel_opt', 'coll_sel_opt', 240, false ),
            ( sp_17_table_output_step_dwid, 'begin_date', 'begin_date', 241, false ),
            ( sp_17_table_output_step_dwid, 'end_date', 'end_date', 242, false ),
            ( sp_17_table_output_step_dwid, 'print_memos', 'print_memos', 243, false ),
            ( sp_17_table_output_step_dwid, 'production_stage_code_list', 'production_stage_code_list', 244, false ),
            ( sp_17_table_output_step_dwid, 'print_docs', 'print_docs', 245, false ),
            ( sp_17_table_output_step_dwid, 'print_exceptions', 'print_exceptions', 246, false ),
            ( sp_17_table_output_step_dwid, 'sort_option', 'sort_option', 247, false ),
            ( sp_17_table_output_step_dwid, 'format_option', 'format_option', 248, false )
;

-- SP-17 edw field definition insert
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, data_type)
    VALUES  (sp_17_edw_table_definition_dwid, 'etl_batch_id', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'data_source_dwid', FALSE, 'BIGINT'),
            (sp_17_edw_table_definition_dwid, 'input_filename', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'rowtype', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'customer_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'customer_name', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'account_sak', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'customer_account_key', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'renewal_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'account_descr', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'cost_center', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'orig_advance_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'acquisition_cost', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'address', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'amortization_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'anncap', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'armadj', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'armconv', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'armindex', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'armmargin', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'armround', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'armteaser', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'as_of_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'asset_class_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'auction_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'balloon_flag', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'bar_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'borr_1_first_name', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'borr_1_last_name', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'borr_2_first_name', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'borr_2_last_name', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'city', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'closing_agent_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'coll_closed_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'coll_valuation_set_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'coll_value_expire_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'coll_value_recalc_flag', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collateral_key', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collateral_key2', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collateral_key3', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collateral_sak', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collateral_value', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collateral_value_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collateral_value_flag', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collgroup', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'construction_cost', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'credit_grade_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'curr_appraised_value', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'curr_payment', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'curr_pledge_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'curr_rate', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'curr_upb', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'custodian_sak', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'customer_sak', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'debt_service_ratio', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'delinquent_days', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'delinquent_history', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'doc_level_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'document_set_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'coll_exist_status_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'expire_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'fico_score', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'first_rate_change_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'firstdue', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'coll_home_track_location_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'instrument_num', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'inv_commit_expire_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'inv_commit_number', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'inv_commit_price', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'investor_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'investor_id', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'coll_is_active', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'last_paid_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'lien_position', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'lifecap', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'coll_major_count', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'market_value', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'market_value_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'market_value_expire_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'market_value_override_flag', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'maturity', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'mers_min', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'coll_minor_count', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'months_to_roll', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'next_due_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'next_inspection_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'next_rate_change_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'occupancy_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'occupancy_ratio', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'orig_appraised_value', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'orig_pledge_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'orig_rate', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'orig_upb', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'original_cltv', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'original_ltv', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'original_term', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'origination_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'originator_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'p_i', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'paid_to_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'pool_id', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'prepay_penalty_flag', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'prepay_penalty_pct', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'product_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'production_stage_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'production_stage_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'property_type_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'purpose_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'rate_change_frequency', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'record_book', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'record_page', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'recorded', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'coll_release_request_identifier', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'scheduled_upb', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'coll_shipment_id', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'short_name', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'state', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'tenant_num', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'tmo_ratio', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'track_item_type_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'coll_track_location_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'udf_char_1', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'udf_char_2', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'udf_date_1', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'udf_date_2', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'udf_dollar_1', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'udf_dollar_2', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'udf_int_1', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'udf_int_2', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'udf_pct_1', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'udf_pct_2', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'units', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'zip', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'warehouse_aging_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'active_flag', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'doctype_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'document_descr', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'document_sak', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'doc_exist_status_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'doc_home_track_location_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'doc_major_count', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'doc_minor_count', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'doc_release_request_identifier', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'doc_track_location_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'cleared_flag', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'fatal_error_flag', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'docex_notation', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'opendate', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'question_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'updated_by', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collmemo_active_flag', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collmemo_memo_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collmemo_memo_sak', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collmemo_memo_subject', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collmemo_memo_text', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collmemo_memo_type', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collmemo_posted_by', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collmemo_private_flag', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'docmemo_active_flag', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'docmemo_memo_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'docmemo_memo_sak', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'docmemo_memo_subject', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'docmemo_memo_text', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'docmemo_memo_type', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'docmemo_posted_by', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'docmemo_private_flag', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'business_tran_log_sak', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'carrier_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'carrier_id', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'certification_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'destination_type_flag', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'effective_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'deposit_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'release_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'effective_rate', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'handling_option', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'btl_investor_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'btl_notation', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'posted_by', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'release_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'release_request_identifier', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'request_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'requestor', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'return_due_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'reversal_method', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'shipment_id', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'task_type_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'task_type_code_rel', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'btl_track_location_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'transtype', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'workbin_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'funding_id', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'funding_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'sched_funding_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'doctype_descr', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'question_descr', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'expires', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'loan_is_active', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'lender_sak', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'loan_descr', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'loan_id', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'loan_inception', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'loan_sak', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'max_balance_amt', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'max_balance_flag', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'max_balance_pct', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'orig_prin_balance', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'payoff_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'pricing_flag', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'pricing_rule_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'pricing_rule_flag', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'sequence', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'curr_prin_balance', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'curr_amount', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'curr_interest', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'curr_fee', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'curr_cof', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'curr_unapplied', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'redemptive_value', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'lender_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'lender_descr', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'cdays_aging', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'bdays_aging', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'coll_group_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'member_sak', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'query_stmt_descr', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'cleared_docex_notation', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'cleared_opendate', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'cleared_question_code', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'cleared_question_descr', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'takeout_value', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'collateral_deficit', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'curr_cltv', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'curr_ltv', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'customer_code_list', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'customer_account_key_list', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'exist_status_code_list', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'date_analysis', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'coll_sel_opt', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'begin_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'end_date', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'print_memos', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'production_stage_code_list', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'print_docs', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'print_exceptions', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'sort_option', FALSE, 'TEXT'),
            (sp_17_edw_table_definition_dwid, 'format_option', FALSE, 'TEXT')
;

-- SP-18 edw table definition insert
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
    VALUES  ('ingress', 'warehouse_banks', 'loan_inventory_tiaa', NULL)
    RETURNING dwid INTO sp_18_edw_table_definition_dwid;

-- SP-18 process input
    INSERT INTO mdi.process (name, description)
    VALUES ('SP-18', 'Load TIAA bank data to the ingress.warehoues_banks.loan_inventory_tiaa table')
    RETURNING dwid INTO sp_18_process_dwid;

-- SP-18 csv_file_input_step insert
    INSERT INTO mdi.csv_file_input_step (process_dwid, header_present, delimiter, enclosure, buffersize
                                        , lazy_conversion, newline_possible, add_filename_result, file_format
                                        , file_encoding, include_filename
                                        , process_in_parallel, filename_field, row_num_field, data_source_dwid )
    VALUES (sp_18_process_dwid, 'N', ',', '"', 1024, 'N', 'Y', 'N', 'mixed', 'UTF-8', 'N', 'N', NULL, NULL, 0 )
    RETURNING dwid INTO sp_18_file_input_step_dwid;

-- SP-18 csv field input insert
    INSERT INTO mdi.csv_file_input_field ( csv_file_input_step_dwid, field_name, field_type, field_format, field_length, field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
    VALUES  (sp_18_file_input_step_dwid, 'rowtype', 'String', NULL, -1, -1, '$', '.', ',', 'none',1 ),
            (sp_18_file_input_step_dwid, 'customer_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 2),
            (sp_18_file_input_step_dwid, 'customer_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 3),
            (sp_18_file_input_step_dwid, 'account_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 4),
            (sp_18_file_input_step_dwid, 'customer_account_key', 'String', NULL, -1, -1, '$', '.', ',', 'none', 5),
            (sp_18_file_input_step_dwid, 'renewal_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 6),
            (sp_18_file_input_step_dwid, 'account_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 7),
            (sp_18_file_input_step_dwid, 'cost_center', 'String', NULL, -1, -1, '$', '.', ',', 'none', 8),
            (sp_18_file_input_step_dwid, 'orig_advance_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 9),
            (sp_18_file_input_step_dwid, 'acquisition_cost', 'String', NULL, -1, -1, '$', '.', ',', 'none', 10),
            (sp_18_file_input_step_dwid, 'address', 'String', NULL, -1, -1, '$', '.', ',', 'none', 11),
            (sp_18_file_input_step_dwid, 'amortization_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 12),
            (sp_18_file_input_step_dwid, 'anncap', 'String', NULL, -1, -1, '$', '.', ',', 'none', 13),
            (sp_18_file_input_step_dwid, 'armadj', 'String', NULL, -1, -1, '$', '.', ',', 'none', 14),
            (sp_18_file_input_step_dwid, 'armconv', 'String', NULL, -1, -1, '$', '.', ',', 'none', 15),
            (sp_18_file_input_step_dwid, 'armindex', 'String', NULL, -1, -1, '$', '.', ',', 'none', 16),
            (sp_18_file_input_step_dwid, 'armmargin', 'String', NULL, -1, -1, '$', '.', ',', 'none', 17),
            (sp_18_file_input_step_dwid, 'armround', 'String', NULL, -1, -1, '$', '.', ',', 'none', 18),
            (sp_18_file_input_step_dwid, 'armteaser', 'String', NULL, -1, -1, '$', '.', ',', 'none', 19),
            (sp_18_file_input_step_dwid, 'as_of_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 20),
            (sp_18_file_input_step_dwid, 'asset_class_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 21),
            (sp_18_file_input_step_dwid, 'auction_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 22),
            (sp_18_file_input_step_dwid, 'balloon_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 23),
            (sp_18_file_input_step_dwid, 'bar_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 24),
            (sp_18_file_input_step_dwid, 'borr_1_first_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 25),
            (sp_18_file_input_step_dwid, 'borr_1_last_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 26),
            (sp_18_file_input_step_dwid, 'borr_2_first_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 27),
            (sp_18_file_input_step_dwid, 'borr_2_last_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 28),
            (sp_18_file_input_step_dwid, 'city', 'String', NULL, -1, -1, '$', '.', ',', 'none', 29),
            (sp_18_file_input_step_dwid, 'closing_agent_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 30),
            (sp_18_file_input_step_dwid, 'coll_closed_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 31),
            (sp_18_file_input_step_dwid, 'coll_valuation_set_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 32),
            (sp_18_file_input_step_dwid, 'coll_value_expire_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 33),
            (sp_18_file_input_step_dwid, 'coll_value_recalc_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 34),
            (sp_18_file_input_step_dwid, 'collateral_key', 'String', NULL, -1, -1, '$', '.', ',', 'none', 35),
            (sp_18_file_input_step_dwid, 'collateral_key2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 36),
            (sp_18_file_input_step_dwid, 'collateral_key3', 'String', NULL, -1, -1, '$', '.', ',', 'none', 37),
            (sp_18_file_input_step_dwid, 'collateral_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 38),
            (sp_18_file_input_step_dwid, 'collateral_value', 'String', NULL, -1, -1, '$', '.', ',', 'none', 39),
            (sp_18_file_input_step_dwid, 'collateral_value_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 40),
            (sp_18_file_input_step_dwid, 'collateral_value_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 41),
            (sp_18_file_input_step_dwid, 'collgroup', 'String', NULL, -1, -1, '$', '.', ',', 'none', 42),
            (sp_18_file_input_step_dwid, 'construction_cost', 'String', NULL, -1, -1, '$', '.', ',', 'none', 43),
            (sp_18_file_input_step_dwid, 'credit_grade_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 44),
            (sp_18_file_input_step_dwid, 'curr_appraised_value', 'String', NULL, -1, -1, '$', '.', ',', 'none', 45),
            (sp_18_file_input_step_dwid, 'curr_payment', 'String', NULL, -1, -1, '$', '.', ',', 'none', 46),
            (sp_18_file_input_step_dwid, 'curr_pledge_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 47),
            (sp_18_file_input_step_dwid, 'curr_rate', 'String', NULL, -1, -1, '$', '.', ',', 'none', 48),
            (sp_18_file_input_step_dwid, 'curr_upb', 'String', NULL, -1, -1, '$', '.', ',', 'none', 49),
            (sp_18_file_input_step_dwid, 'custodian_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 50),
            (sp_18_file_input_step_dwid, 'customer_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 51),
            (sp_18_file_input_step_dwid, 'debt_service_ratio', 'String', NULL, -1, -1, '$', '.', ',', 'none', 52),
            (sp_18_file_input_step_dwid, 'delinquent_days', 'String', NULL, -1, -1, '$', '.', ',', 'none', 53),
            (sp_18_file_input_step_dwid, 'delinquent_history', 'String', NULL, -1, -1, '$', '.', ',', 'none', 54),
            (sp_18_file_input_step_dwid, 'doc_level_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 55),
            (sp_18_file_input_step_dwid, 'document_set_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 56),
            (sp_18_file_input_step_dwid, 'coll_exist_status_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 57),
            (sp_18_file_input_step_dwid, 'expire_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 58),
            (sp_18_file_input_step_dwid, 'fico_score', 'String', NULL, -1, -1, '$', '.', ',', 'none', 59),
            (sp_18_file_input_step_dwid, 'first_rate_change_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 60),
            (sp_18_file_input_step_dwid, 'firstdue', 'String', NULL, -1, -1, '$', '.', ',', 'none', 61),
            (sp_18_file_input_step_dwid, 'coll_home_track_location_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 62),
            (sp_18_file_input_step_dwid, 'instrument_num', 'String', NULL, -1, -1, '$', '.', ',', 'none', 63),
            (sp_18_file_input_step_dwid, 'inv_commit_expire_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 64),
            (sp_18_file_input_step_dwid, 'inv_commit_number', 'String', NULL, -1, -1, '$', '.', ',', 'none', 65),
            (sp_18_file_input_step_dwid, 'inv_commit_price', 'String', NULL, -1, -1, '$', '.', ',', 'none', 66),
            (sp_18_file_input_step_dwid, 'investor_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 67),
            (sp_18_file_input_step_dwid, 'investor_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 68),
            (sp_18_file_input_step_dwid, 'coll_is_active', 'String', NULL, -1, -1, '$', '.', ',', 'none', 69),
            (sp_18_file_input_step_dwid, 'last_paid_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 70),
            (sp_18_file_input_step_dwid, 'lien_position', 'String', NULL, -1, -1, '$', '.', ',', 'none', 71),
            (sp_18_file_input_step_dwid, 'lifecap', 'String', NULL, -1, -1, '$', '.', ',', 'none', 72),
            (sp_18_file_input_step_dwid, 'coll_major_count', 'String', NULL, -1, -1, '$', '.', ',', 'none', 73),
            (sp_18_file_input_step_dwid, 'market_value', 'String', NULL, -1, -1, '$', '.', ',', 'none', 74),
            (sp_18_file_input_step_dwid, 'market_value_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 75),
            (sp_18_file_input_step_dwid, 'market_value_expire_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 76),
            (sp_18_file_input_step_dwid, 'market_value_override_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 77),
            (sp_18_file_input_step_dwid, 'maturity', 'String', NULL, -1, -1, '$', '.', ',', 'none', 78),
            (sp_18_file_input_step_dwid, 'mers_min', 'String', NULL, -1, -1, '$', '.', ',', 'none', 79),
            (sp_18_file_input_step_dwid, 'coll_minor_count', 'String', NULL, -1, -1, '$', '.', ',', 'none', 80),
            (sp_18_file_input_step_dwid, 'months_to_roll', 'String', NULL, -1, -1, '$', '.', ',', 'none', 81),
            (sp_18_file_input_step_dwid, 'next_due_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 82),
            (sp_18_file_input_step_dwid, 'next_inspection_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 83),
            (sp_18_file_input_step_dwid, 'next_rate_change_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 84),
            (sp_18_file_input_step_dwid, 'occupancy_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 85),
            (sp_18_file_input_step_dwid, 'occupancy_ratio', 'String', NULL, -1, -1, '$', '.', ',', 'none', 86),
            (sp_18_file_input_step_dwid, 'orig_appraised_value', 'String', NULL, -1, -1, '$', '.', ',', 'none', 87),
            (sp_18_file_input_step_dwid, 'orig_pledge_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 88),
            (sp_18_file_input_step_dwid, 'orig_rate', 'String', NULL, -1, -1, '$', '.', ',', 'none', 89),
            (sp_18_file_input_step_dwid, 'orig_upb', 'String', NULL, -1, -1, '$', '.', ',', 'none', 90),
            (sp_18_file_input_step_dwid, 'original_cltv', 'String', NULL, -1, -1, '$', '.', ',', 'none', 91),
            (sp_18_file_input_step_dwid, 'original_ltv', 'String', NULL, -1, -1, '$', '.', ',', 'none', 92),
            (sp_18_file_input_step_dwid, 'original_term', 'String', NULL, -1, -1, '$', '.', ',', 'none', 93),
            (sp_18_file_input_step_dwid, 'origination_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 94),
            (sp_18_file_input_step_dwid, 'originator_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 95),
            (sp_18_file_input_step_dwid, 'p_i', 'String', NULL, -1, -1, '$', '.', ',', 'none', 96),
            (sp_18_file_input_step_dwid, 'paid_to_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 97),
            (sp_18_file_input_step_dwid, 'pool_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 98),
            (sp_18_file_input_step_dwid, 'prepay_penalty_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 99),
            (sp_18_file_input_step_dwid, 'prepay_penalty_pct', 'String', NULL, -1, -1, '$', '.', ',', 'none', 100),
            (sp_18_file_input_step_dwid, 'product_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 101),
            (sp_18_file_input_step_dwid, 'production_stage_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 102),
            (sp_18_file_input_step_dwid, 'production_stage_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 103),
            (sp_18_file_input_step_dwid, 'production_grade_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 104),
            (sp_18_file_input_step_dwid, 'production_grade_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 105),
            (sp_18_file_input_step_dwid, 'property_type_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 106),
            (sp_18_file_input_step_dwid, 'purpose_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 107),
            (sp_18_file_input_step_dwid, 'rate_change_frequency', 'String', NULL, -1, -1, '$', '.', ',', 'none', 108),
            (sp_18_file_input_step_dwid, 'record_book', 'String', NULL, -1, -1, '$', '.', ',', 'none', 109),
            (sp_18_file_input_step_dwid, 'record_page', 'String', NULL, -1, -1, '$', '.', ',', 'none', 110),
            (sp_18_file_input_step_dwid, 'recorded', 'String', NULL, -1, -1, '$', '.', ',', 'none', 111),
            (sp_18_file_input_step_dwid, 'coll_release_request_identifier', 'String', NULL, -1, -1, '$', '.', ',', 'none', 112),
            (sp_18_file_input_step_dwid, 'scheduled_upb', 'String', NULL, -1, -1, '$', '.', ',', 'none', 113),
            (sp_18_file_input_step_dwid, 'coll_shipment_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 114),
            (sp_18_file_input_step_dwid, 'short_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 115),
            (sp_18_file_input_step_dwid, 'ss_number', 'String', NULL, -1, -1, '$', '.', ',', 'none', 116),
            (sp_18_file_input_step_dwid, 'state', 'String', NULL, -1, -1, '$', '.', ',', 'none', 117),
            (sp_18_file_input_step_dwid, 'tenant_num', 'String', NULL, -1, -1, '$', '.', ',', 'none', 118),
            (sp_18_file_input_step_dwid, 'tmo_ratio', 'String', NULL, -1, -1, '$', '.', ',', 'none', 119),
            (sp_18_file_input_step_dwid, 'track_item_type_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 120),
            (sp_18_file_input_step_dwid, 'coll_track_location_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 121),
            (sp_18_file_input_step_dwid, 'udf_char_1', 'String', NULL, -1, -1, '$', '.', ',', 'none', 122),
            (sp_18_file_input_step_dwid, 'udf_char_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 123),
            (sp_18_file_input_step_dwid, 'udf_date_1', 'String', NULL, -1, -1, '$', '.', ',', 'none', 124),
            (sp_18_file_input_step_dwid, 'udf_date_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 125),
            (sp_18_file_input_step_dwid, 'udf_dollar_1', 'String', NULL, -1, -1, '$', '.', ',', 'none', 126),
            (sp_18_file_input_step_dwid, 'udf_dollar_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 127),
            (sp_18_file_input_step_dwid, 'udf_int_1', 'String', NULL, -1, -1, '$', '.', ',', 'none', 128),
            (sp_18_file_input_step_dwid, 'udf_int_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 129),
            (sp_18_file_input_step_dwid, 'udf_pct_1', 'String', NULL, -1, -1, '$', '.', ',', 'none', 130),
            (sp_18_file_input_step_dwid, 'udf_pct_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 131),
            (sp_18_file_input_step_dwid, 'units', 'String', NULL, -1, -1, '$', '.', ',', 'none', 132),
            (sp_18_file_input_step_dwid, 'zip', 'String', NULL, -1, -1, '$', '.', ',', 'none', 133),
            (sp_18_file_input_step_dwid, 'warehouse_aging_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 134),
            (sp_18_file_input_step_dwid, 'active_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 135),
            (sp_18_file_input_step_dwid, 'doctype_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 136),
            (sp_18_file_input_step_dwid, 'document_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 137),
            (sp_18_file_input_step_dwid, 'document_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 138),
            (sp_18_file_input_step_dwid, 'doc_exist_status_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 139),
            (sp_18_file_input_step_dwid, 'doc_home_track_location_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 140),
            (sp_18_file_input_step_dwid, 'doc_major_count', 'String', NULL, -1, -1, '$', '.', ',', 'none', 141),
            (sp_18_file_input_step_dwid, 'doc_minor_count', 'String', NULL, -1, -1, '$', '.', ',', 'none', 142),
            (sp_18_file_input_step_dwid, 'doc_release_request_identifier', 'String', NULL, -1, -1, '$', '.', ',', 'none', 143),
            (sp_18_file_input_step_dwid, 'doc_track_location_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 144),
            (sp_18_file_input_step_dwid, 'cleared_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 145),
            (sp_18_file_input_step_dwid, 'fatal_error_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 146),
            (sp_18_file_input_step_dwid, 'docex_notation', 'String', NULL, -1, -1, '$', '.', ',', 'none', 147),
            (sp_18_file_input_step_dwid, 'opendate', 'String', NULL, -1, -1, '$', '.', ',', 'none', 148),
            (sp_18_file_input_step_dwid, 'question_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 149),
            (sp_18_file_input_step_dwid, 'updated_by', 'String', NULL, -1, -1, '$', '.', ',', 'none', 150),
            (sp_18_file_input_step_dwid, 'collmemo_active_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 151),
            (sp_18_file_input_step_dwid, 'collmemo_memo_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 152),
            (sp_18_file_input_step_dwid, 'collmemo_memo_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 153),
            (sp_18_file_input_step_dwid, 'collmemo_memo_subject', 'String', NULL, -1, -1, '$', '.', ',', 'none', 154),
            (sp_18_file_input_step_dwid, 'collmemo_memo_text', 'String', NULL, -1, -1, '$', '.', ',', 'none', 155),
            (sp_18_file_input_step_dwid, 'collmemo_memo_type', 'String', NULL, -1, -1, '$', '.', ',', 'none', 156),
            (sp_18_file_input_step_dwid, 'collmemo_posted_by', 'String', NULL, -1, -1, '$', '.', ',', 'none', 157),
            (sp_18_file_input_step_dwid, 'collmemo_private_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 158),
            (sp_18_file_input_step_dwid, 'docmemo_active_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 159),
            (sp_18_file_input_step_dwid, 'docmemo_memo_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 160),
            (sp_18_file_input_step_dwid, 'docmemo_memo_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 161),
            (sp_18_file_input_step_dwid, 'docmemo_memo_subject', 'String', NULL, -1, -1, '$', '.', ',', 'none', 162),
            (sp_18_file_input_step_dwid, 'docmemo_memo_text', 'String', NULL, -1, -1, '$', '.', ',', 'none', 163),
            (sp_18_file_input_step_dwid, 'docmemo_memo_type', 'String', NULL, -1, -1, '$', '.', ',', 'none', 164),
            (sp_18_file_input_step_dwid, 'docmemo_posted_by', 'String', NULL, -1, -1, '$', '.', ',', 'none', 165),
            (sp_18_file_input_step_dwid, 'docmemo_private_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 166),
            (sp_18_file_input_step_dwid, 'business_tran_log_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 167),
            (sp_18_file_input_step_dwid, 'carrier_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 168),
            (sp_18_file_input_step_dwid, 'carrier_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 169),
            (sp_18_file_input_step_dwid, 'certification_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 170),
            (sp_18_file_input_step_dwid, 'destination_type_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 171),
            (sp_18_file_input_step_dwid, 'effective_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 172),
            (sp_18_file_input_step_dwid, 'deposit_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 173),
            (sp_18_file_input_step_dwid, 'release_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 174),
            (sp_18_file_input_step_dwid, 'effective_rate', 'String', NULL, -1, -1, '$', '.', ',', 'none', 175),
            (sp_18_file_input_step_dwid, 'handling_option', 'String', NULL, -1, -1, '$', '.', ',', 'none', 176),
            (sp_18_file_input_step_dwid, 'btl_investor_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 177),
            (sp_18_file_input_step_dwid, 'btl_notation', 'String', NULL, -1, -1, '$', '.', ',', 'none', 178),
            (sp_18_file_input_step_dwid, 'posted_by', 'String', NULL, -1, -1, '$', '.', ',', 'none', 179),
            (sp_18_file_input_step_dwid, 'release_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 180),
            (sp_18_file_input_step_dwid, 'release_request_identifier', 'String', NULL, -1, -1, '$', '.', ',', 'none', 181),
            (sp_18_file_input_step_dwid, 'request_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 182),
            (sp_18_file_input_step_dwid, 'requestor', 'String', NULL, -1, -1, '$', '.', ',', 'none', 183),
            (sp_18_file_input_step_dwid, 'return_due_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 184),
            (sp_18_file_input_step_dwid, 'reversal_method', 'String', NULL, -1, -1, '$', '.', ',', 'none', 185),
            (sp_18_file_input_step_dwid, 'shipment_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 186),
            (sp_18_file_input_step_dwid, 'task_type_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 187),
            (sp_18_file_input_step_dwid, 'task_type_code_rel', 'String', NULL, -1, -1, '$', '.', ',', 'none', 188),
            (sp_18_file_input_step_dwid, 'btl_track_location_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 189),
            (sp_18_file_input_step_dwid, 'transtype', 'String', NULL, -1, -1, '$', '.', ',', 'none', 190),
            (sp_18_file_input_step_dwid, 'workbin_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 191),
            (sp_18_file_input_step_dwid, 'funding_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 192),
            (sp_18_file_input_step_dwid, 'funding_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 193),
            (sp_18_file_input_step_dwid, 'sched_funding_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 194),
            (sp_18_file_input_step_dwid, 'doctype_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 195),
            (sp_18_file_input_step_dwid, 'question_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 196),
            (sp_18_file_input_step_dwid, 'expires', 'String', NULL, -1, -1, '$', '.', ',', 'none', 197),
            (sp_18_file_input_step_dwid, 'loan_is_active', 'String', NULL, -1, -1, '$', '.', ',', 'none', 198),
            (sp_18_file_input_step_dwid, 'lender_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 199),
            (sp_18_file_input_step_dwid, 'loan_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 200),
            (sp_18_file_input_step_dwid, 'loan_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 201),
            (sp_18_file_input_step_dwid, 'loan_inception', 'String', NULL, -1, -1, '$', '.', ',', 'none', 202),
            (sp_18_file_input_step_dwid, 'loan_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 203),
            (sp_18_file_input_step_dwid, 'max_balance_amt', 'String', NULL, -1, -1, '$', '.', ',', 'none', 204),
            (sp_18_file_input_step_dwid, 'max_balance_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 205),
            (sp_18_file_input_step_dwid, 'max_balance_pct', 'String', NULL, -1, -1, '$', '.', ',', 'none', 206),
            (sp_18_file_input_step_dwid, 'orig_prin_balance', 'String', NULL, -1, -1, '$', '.', ',', 'none', 207),
            (sp_18_file_input_step_dwid, 'payoff_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 208),
            (sp_18_file_input_step_dwid, 'pricing_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 209),
            (sp_18_file_input_step_dwid, 'pricing_rule_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 210),
            (sp_18_file_input_step_dwid, 'pricing_rule_flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 211),
            (sp_18_file_input_step_dwid, 'sequence', 'String', NULL, -1, -1, '$', '.', ',', 'none', 212),
            (sp_18_file_input_step_dwid, 'curr_prin_balance', 'String', NULL, -1, -1, '$', '.', ',', 'none', 213),
            (sp_18_file_input_step_dwid, 'curr_amount', 'String', NULL, -1, -1, '$', '.', ',', 'none', 214),
            (sp_18_file_input_step_dwid, 'curr_interest', 'String', NULL, -1, -1, '$', '.', ',', 'none', 215),
            (sp_18_file_input_step_dwid, 'curr_fee', 'String', NULL, -1, -1, '$', '.', ',', 'none', 216),
            (sp_18_file_input_step_dwid, 'curr_cof', 'String', NULL, -1, -1, '$', '.', ',', 'none', 217),
            (sp_18_file_input_step_dwid, 'curr_unapplied', 'String', NULL, -1, -1, '$', '.', ',', 'none', 218),
            (sp_18_file_input_step_dwid, 'redemptive_value', 'String', NULL, -1, -1, '$', '.', ',', 'none', 219),
            (sp_18_file_input_step_dwid, 'lender_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 220),
            (sp_18_file_input_step_dwid, 'lender_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 221),
            (sp_18_file_input_step_dwid, 'cdays_aging', 'String', NULL, -1, -1, '$', '.', ',', 'none', 222),
            (sp_18_file_input_step_dwid, 'bdays_aging', 'String', NULL, -1, -1, '$', '.', ',', 'none', 223),
            (sp_18_file_input_step_dwid, 'coll_group_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 224),
            (sp_18_file_input_step_dwid, 'member_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 225),
            (sp_18_file_input_step_dwid, 'query_stmt_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 226),
            (sp_18_file_input_step_dwid, 'cleared_docex_notation', 'String', NULL, -1, -1, '$', '.', ',', 'none', 227),
            (sp_18_file_input_step_dwid, 'cleared_opendate', 'String', NULL, -1, -1, '$', '.', ',', 'none', 228),
            (sp_18_file_input_step_dwid, 'cleared_question_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 229),
            (sp_18_file_input_step_dwid, 'cleared_question_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 230),
            (sp_18_file_input_step_dwid, 'takeout_value', 'String', NULL, -1, -1, '$', '.', ',', 'none', 231),
            (sp_18_file_input_step_dwid, 'collateral_deficit', 'String', NULL, -1, -1, '$', '.', ',', 'none', 232),
            (sp_18_file_input_step_dwid, 'curr_cltv', 'String', NULL, -1, -1, '$', '.', ',', 'none', 233),
            (sp_18_file_input_step_dwid, 'curr_ltv', 'String', NULL, -1, -1, '$', '.', ',', 'none', 234),
            (sp_18_file_input_step_dwid, 'customer_code_list', 'String', NULL, -1, -1, '$', '.', ',', 'none', 235),
            (sp_18_file_input_step_dwid, 'customer_account_key_list', 'String', NULL, -1, -1, '$', '.', ',', 'none', 236),
            (sp_18_file_input_step_dwid, 'exist_status_code_list', 'String', NULL, -1, -1, '$', '.', ',', 'none', 237),
            (sp_18_file_input_step_dwid, 'date_analysis', 'String', NULL, -1, -1, '$', '.', ',', 'none', 238),
            (sp_18_file_input_step_dwid, 'coll_sel_opt', 'String', NULL, -1, -1, '$', '.', ',', 'none', 239),
            (sp_18_file_input_step_dwid, 'begin_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 240),
            (sp_18_file_input_step_dwid, 'end_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 241),
            (sp_18_file_input_step_dwid, 'print_memos', 'String', NULL, -1, -1, '$', '.', ',', 'none', 242),
            (sp_18_file_input_step_dwid, 'production_stage_code_list', 'String', NULL, -1, -1, '$', '.', ',', 'none', 243),
            (sp_18_file_input_step_dwid, 'print_docs', 'String', NULL, -1, -1, '$', '.', ',', 'none', 244),
            (sp_18_file_input_step_dwid, 'print_exceptions', 'String', NULL, -1, -1, '$', '.', ',', 'none', 245),
            (sp_18_file_input_step_dwid, 'sort_option', 'String', NULL, -1, -1, '$', '.', ',', 'none', 246),
            (sp_18_file_input_step_dwid, 'format_option', 'String', NULL, -1, -1, '$', '.', ',', 'none', 247)
;

-- SP-18 table output step
    INSERT INTO mdi.table_output_step ( process_dwid, target_schema, target_table, commit_size, partitioning_field
                                      , table_name_field, auto_generated_key_field, partition_data_per
                                      , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                      , connectionname, partition_over_tables, specify_database_fields
                                      , ignore_insert_errors, use_batch_update )
    VALUES (sp_18_process_dwid, 'warehouse_banks', 'loan_inventory_tiaa', 1000, NULL, NULL, NULL, NULL, 'N',
            NULL,'Y' ,'Ingress DB Connection' ,'N' ,'Y' ,'N' ,'N')
    RETURNING dwid INTO sp_18_table_output_step_dwid;

-- SP-18 table output field insert
    INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive )
    VALUES  ( sp_18_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', 1, false ),
            ( sp_18_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid', 2, false ),
            ( sp_18_table_output_step_dwid, 'input_filename', 'imported_filename', 3, false ),
            ( sp_18_table_output_step_dwid, 'rowtype', 'rowtype', 4, false ),
            ( sp_18_table_output_step_dwid, 'customer_code', 'customer_code', 5, false ),
            ( sp_18_table_output_step_dwid, 'customer_name', 'customer_name', 6, false ),
            ( sp_18_table_output_step_dwid, 'account_sak', 'account_sak', 7, false ),
            ( sp_18_table_output_step_dwid, 'customer_account_key', 'customer_account_key', 8, false ),
            ( sp_18_table_output_step_dwid, 'renewal_date', 'renewal_date', 9, false ),
            ( sp_18_table_output_step_dwid, 'account_descr', 'account_descr', 10, false ),
            ( sp_18_table_output_step_dwid, 'cost_center', 'cost_center', 11, false ),
            ( sp_18_table_output_step_dwid, 'orig_advance_date', 'orig_advance_date', 12, false ),
            ( sp_18_table_output_step_dwid, 'acquisition_cost', 'acquisition_cost', 13, false ),
            ( sp_18_table_output_step_dwid, 'address', 'address', 14, false ),
            ( sp_18_table_output_step_dwid, 'amortization_code', 'amortization_code', 15, false ),
            ( sp_18_table_output_step_dwid, 'anncap', 'anncap', 16, false ),
            ( sp_18_table_output_step_dwid, 'armadj', 'armadj', 17, false ),
            ( sp_18_table_output_step_dwid, 'armconv', 'armconv', 18, false ),
            ( sp_18_table_output_step_dwid, 'armindex', 'armindex', 19, false ),
            ( sp_18_table_output_step_dwid, 'armmargin', 'armmargin', 20, false ),
            ( sp_18_table_output_step_dwid, 'armround', 'armround', 21, false ),
            ( sp_18_table_output_step_dwid, 'armteaser', 'armteaser', 22, false ),
            ( sp_18_table_output_step_dwid, 'as_of_date', 'as_of_date', 23, false ),
            ( sp_18_table_output_step_dwid, 'asset_class_code', 'asset_class_code', 24, false ),
            ( sp_18_table_output_step_dwid, 'auction_date', 'auction_date', 25, false ),
            ( sp_18_table_output_step_dwid, 'balloon_flag', 'balloon_flag', 26, false ),
            ( sp_18_table_output_step_dwid, 'bar_code', 'bar_code', 27, false ),
            ( sp_18_table_output_step_dwid, 'borr_1_first_name', 'borr_1_first_name', 28, false ),
            ( sp_18_table_output_step_dwid, 'borr_1_last_name', 'borr_1_last_name', 29, false ),
            ( sp_18_table_output_step_dwid, 'borr_2_first_name', 'borr_2_first_name', 30, false ),
            ( sp_18_table_output_step_dwid, 'borr_2_last_name', 'borr_2_last_name', 31, false ),
            ( sp_18_table_output_step_dwid, 'city', 'city', 32, false ),
            ( sp_18_table_output_step_dwid, 'closing_agent_code', 'closing_agent_code', 33, false ),
            ( sp_18_table_output_step_dwid, 'coll_closed_date', 'coll_closed_date', 34, false ),
            ( sp_18_table_output_step_dwid, 'coll_valuation_set_code', 'coll_valuation_set_code', 35, false ),
            ( sp_18_table_output_step_dwid, 'coll_value_expire_date', 'coll_value_expire_date', 36, false ),
            ( sp_18_table_output_step_dwid, 'coll_value_recalc_flag', 'coll_value_recalc_flag', 37, false ),
            ( sp_18_table_output_step_dwid, 'collateral_key', 'collateral_key', 38, false ),
            ( sp_18_table_output_step_dwid, 'collateral_key2', 'collateral_key2', 39, false ),
            ( sp_18_table_output_step_dwid, 'collateral_key3', 'collateral_key3', 40, false ),
            ( sp_18_table_output_step_dwid, 'collateral_sak', 'collateral_sak', 41, false ),
            ( sp_18_table_output_step_dwid, 'collateral_value', 'collateral_value', 42, false ),
            ( sp_18_table_output_step_dwid, 'collateral_value_date', 'collateral_value_date', 43, false ),
            ( sp_18_table_output_step_dwid, 'collateral_value_flag', 'collateral_value_flag', 44, false ),
            ( sp_18_table_output_step_dwid, 'collgroup', 'collgroup', 45, false ),
            ( sp_18_table_output_step_dwid, 'construction_cost', 'construction_cost', 46, false ),
            ( sp_18_table_output_step_dwid, 'credit_grade_code', 'credit_grade_code', 47, false ),
            ( sp_18_table_output_step_dwid, 'curr_appraised_value', 'curr_appraised_value', 48, false ),
            ( sp_18_table_output_step_dwid, 'curr_payment', 'curr_payment', 49, false ),
            ( sp_18_table_output_step_dwid, 'curr_pledge_date', 'curr_pledge_date', 50, false ),
            ( sp_18_table_output_step_dwid, 'curr_rate', 'curr_rate', 51, false ),
            ( sp_18_table_output_step_dwid, 'curr_upb', 'curr_upb', 52, false ),
            ( sp_18_table_output_step_dwid, 'custodian_sak', 'custodian_sak', 53, false ),
            ( sp_18_table_output_step_dwid, 'customer_sak', 'customer_sak', 54, false ),
            ( sp_18_table_output_step_dwid, 'debt_service_ratio', 'debt_service_ratio', 55, false ),
            ( sp_18_table_output_step_dwid, 'delinquent_days', 'delinquent_days', 56, false ),
            ( sp_18_table_output_step_dwid, 'delinquent_history', 'delinquent_history', 57, false ),
            ( sp_18_table_output_step_dwid, 'doc_level_code', 'doc_level_code', 58, false ),
            ( sp_18_table_output_step_dwid, 'document_set_code', 'document_set_code', 59, false ),
            ( sp_18_table_output_step_dwid, 'coll_exist_status_code', 'coll_exist_status_code', 60, false ),
            ( sp_18_table_output_step_dwid, 'expire_date', 'expire_date', 61, false ),
            ( sp_18_table_output_step_dwid, 'fico_score', 'fico_score', 62, false ),
            ( sp_18_table_output_step_dwid, 'first_rate_change_date', 'first_rate_change_date', 63, false ),
            ( sp_18_table_output_step_dwid, 'firstdue', 'firstdue', 64, false ),
            ( sp_18_table_output_step_dwid, 'coll_home_track_location_code', 'coll_home_track_location_code', 65, false ),
            ( sp_18_table_output_step_dwid, 'instrument_num', 'instrument_num', 66, false ),
            ( sp_18_table_output_step_dwid, 'inv_commit_expire_date', 'inv_commit_expire_date', 67, false ),
            ( sp_18_table_output_step_dwid, 'inv_commit_number', 'inv_commit_number', 68, false ),
            ( sp_18_table_output_step_dwid, 'inv_commit_price', 'inv_commit_price', 69, false ),
            ( sp_18_table_output_step_dwid, 'investor_code', 'investor_code', 70, false ),
            ( sp_18_table_output_step_dwid, 'investor_id', 'investor_id', 71, false ),
            ( sp_18_table_output_step_dwid, 'coll_is_active', 'coll_is_active', 72, false ),
            ( sp_18_table_output_step_dwid, 'last_paid_date', 'last_paid_date', 73, false ),
            ( sp_18_table_output_step_dwid, 'lien_position', 'lien_position', 74, false ),
            ( sp_18_table_output_step_dwid, 'lifecap', 'lifecap', 75, false ),
            ( sp_18_table_output_step_dwid, 'coll_major_count', 'coll_major_count', 76, false ),
            ( sp_18_table_output_step_dwid, 'market_value', 'market_value', 77, false ),
            ( sp_18_table_output_step_dwid, 'market_value_date', 'market_value_date', 78, false ),
            ( sp_18_table_output_step_dwid, 'market_value_expire_date', 'market_value_expire_date', 79, false ),
            ( sp_18_table_output_step_dwid, 'market_value_override_flag', 'market_value_override_flag', 80, false ),
            ( sp_18_table_output_step_dwid, 'maturity', 'maturity', 81, false ),
            ( sp_18_table_output_step_dwid, 'mers_min', 'mers_min', 82, false ),
            ( sp_18_table_output_step_dwid, 'coll_minor_count', 'coll_minor_count', 83, false ),
            ( sp_18_table_output_step_dwid, 'months_to_roll', 'months_to_roll', 84, false ),
            ( sp_18_table_output_step_dwid, 'next_due_date', 'next_due_date', 85, false ),
            ( sp_18_table_output_step_dwid, 'next_inspection_date', 'next_inspection_date', 86, false ),
            ( sp_18_table_output_step_dwid, 'next_rate_change_date', 'next_rate_change_date', 87, false ),
            ( sp_18_table_output_step_dwid, 'occupancy_code', 'occupancy_code', 88, false ),
            ( sp_18_table_output_step_dwid, 'occupancy_ratio', 'occupancy_ratio', 89, false ),
            ( sp_18_table_output_step_dwid, 'orig_appraised_value', 'orig_appraised_value', 90, false ),
            ( sp_18_table_output_step_dwid, 'orig_pledge_date', 'orig_pledge_date', 91, false ),
            ( sp_18_table_output_step_dwid, 'orig_rate', 'orig_rate', 92, false ),
            ( sp_18_table_output_step_dwid, 'orig_upb', 'orig_upb', 93, false ),
            ( sp_18_table_output_step_dwid, 'original_cltv', 'original_cltv', 94, false ),
            ( sp_18_table_output_step_dwid, 'original_ltv', 'original_ltv', 95, false ),
            ( sp_18_table_output_step_dwid, 'original_term', 'original_term', 96, false ),
            ( sp_18_table_output_step_dwid, 'origination_date', 'origination_date', 97, false ),
            ( sp_18_table_output_step_dwid, 'originator_code', 'originator_code', 98, false ),
            ( sp_18_table_output_step_dwid, 'p_i', 'p_i', 99, false ),
            ( sp_18_table_output_step_dwid, 'paid_to_date', 'paid_to_date', 100, false ),
            ( sp_18_table_output_step_dwid, 'pool_id', 'pool_id', 101, false ),
            ( sp_18_table_output_step_dwid, 'prepay_penalty_flag', 'prepay_penalty_flag', 102, false ),
            ( sp_18_table_output_step_dwid, 'prepay_penalty_pct', 'prepay_penalty_pct', 103, false ),
            ( sp_18_table_output_step_dwid, 'product_code', 'product_code', 104, false ),
            ( sp_18_table_output_step_dwid, 'production_stage_code', 'production_stage_code', 105, false ),
            ( sp_18_table_output_step_dwid, 'production_stage_date', 'production_stage_date', 106, false ),
            ( sp_18_table_output_step_dwid, 'production_grade_code', 'production_grade_code', 107, false ),
            ( sp_18_table_output_step_dwid, 'production_grade_date', 'production_grade_date', 108, false ),
            ( sp_18_table_output_step_dwid, 'property_type_code', 'property_type_code', 109, false ),
            ( sp_18_table_output_step_dwid, 'purpose_code', 'purpose_code', 110, false ),
            ( sp_18_table_output_step_dwid, 'rate_change_frequency', 'rate_change_frequency', 111, false ),
            ( sp_18_table_output_step_dwid, 'record_book', 'record_book', 112, false ),
            ( sp_18_table_output_step_dwid, 'record_page', 'record_page', 113, false ),
            ( sp_18_table_output_step_dwid, 'recorded', 'recorded', 114, false ),
            ( sp_18_table_output_step_dwid, 'coll_release_request_identifier', 'coll_release_request_identifier', 115, false ),
            ( sp_18_table_output_step_dwid, 'scheduled_upb', 'scheduled_upb', 116, false ),
            ( sp_18_table_output_step_dwid, 'coll_shipment_id', 'coll_shipment_id', 117, false ),
            ( sp_18_table_output_step_dwid, 'short_name', 'short_name', 118, false ),
            ( sp_18_table_output_step_dwid, 'state', 'state', 120, false ),
            ( sp_18_table_output_step_dwid, 'tenant_num', 'tenant_num', 121, false ),
            ( sp_18_table_output_step_dwid, 'tmo_ratio', 'tmo_ratio', 122, false ),
            ( sp_18_table_output_step_dwid, 'track_item_type_code', 'track_item_type_code', 123, false ),
            ( sp_18_table_output_step_dwid, 'coll_track_location_code', 'coll_track_location_code', 124, false ),
            ( sp_18_table_output_step_dwid, 'udf_char_1', 'udf_char_1', 125, false ),
            ( sp_18_table_output_step_dwid, 'udf_char_2', 'udf_char_2', 126, false ),
            ( sp_18_table_output_step_dwid, 'udf_date_1', 'udf_date_1', 127, false ),
            ( sp_18_table_output_step_dwid, 'udf_date_2', 'udf_date_2', 128, false ),
            ( sp_18_table_output_step_dwid, 'udf_dollar_1', 'udf_dollar_1', 129, false ),
            ( sp_18_table_output_step_dwid, 'udf_dollar_2', 'udf_dollar_2', 130, false ),
            ( sp_18_table_output_step_dwid, 'udf_int_1', 'udf_int_1', 131, false ),
            ( sp_18_table_output_step_dwid, 'udf_int_2', 'udf_int_2', 132, false ),
            ( sp_18_table_output_step_dwid, 'udf_pct_1', 'udf_pct_1', 133, false ),
            ( sp_18_table_output_step_dwid, 'udf_pct_2', 'udf_pct_2', 134, false ),
            ( sp_18_table_output_step_dwid, 'units', 'units', 135, false ),
            ( sp_18_table_output_step_dwid, 'zip', 'zip', 136, false ),
            ( sp_18_table_output_step_dwid, 'warehouse_aging_date', 'warehouse_aging_date', 137, false ),
            ( sp_18_table_output_step_dwid, 'active_flag', 'active_flag', 138, false ),
            ( sp_18_table_output_step_dwid, 'doctype_code', 'doctype_code', 139, false ),
            ( sp_18_table_output_step_dwid, 'document_descr', 'document_descr', 140, false ),
            ( sp_18_table_output_step_dwid, 'document_sak', 'document_sak', 141, false ),
            ( sp_18_table_output_step_dwid, 'doc_exist_status_code', 'doc_exist_status_code', 142, false ),
            ( sp_18_table_output_step_dwid, 'doc_home_track_location_code', 'doc_home_track_location_code', 143, false ),
            ( sp_18_table_output_step_dwid, 'doc_major_count', 'doc_major_count', 144, false ),
            ( sp_18_table_output_step_dwid, 'doc_minor_count', 'doc_minor_count', 145, false ),
            ( sp_18_table_output_step_dwid, 'doc_release_request_identifier', 'doc_release_request_identifier', 146, false ),
            ( sp_18_table_output_step_dwid, 'doc_track_location_code', 'doc_track_location_code', 147, false ),
            ( sp_18_table_output_step_dwid, 'cleared_flag', 'cleared_flag', 148, false ),
            ( sp_18_table_output_step_dwid, 'fatal_error_flag', 'fatal_error_flag', 149, false ),
            ( sp_18_table_output_step_dwid, 'docex_notation', 'docex_notation', 150, false ),
            ( sp_18_table_output_step_dwid, 'opendate', 'opendate', 151, false ),
            ( sp_18_table_output_step_dwid, 'question_code', 'question_code', 152, false ),
            ( sp_18_table_output_step_dwid, 'updated_by', 'updated_by', 153, false ),
            ( sp_18_table_output_step_dwid, 'collmemo_active_flag', 'collmemo_active_flag', 154, false ),
            ( sp_18_table_output_step_dwid, 'collmemo_memo_date', 'collmemo_memo_date', 155, false ),
            ( sp_18_table_output_step_dwid, 'collmemo_memo_sak', 'collmemo_memo_sak', 156, false ),
            ( sp_18_table_output_step_dwid, 'collmemo_memo_subject', 'collmemo_memo_subject', 157, false ),
            ( sp_18_table_output_step_dwid, 'collmemo_memo_text', 'collmemo_memo_text', 158, false ),
            ( sp_18_table_output_step_dwid, 'collmemo_memo_type', 'collmemo_memo_type', 159, false ),
            ( sp_18_table_output_step_dwid, 'collmemo_posted_by', 'collmemo_posted_by', 160, false ),
            ( sp_18_table_output_step_dwid, 'collmemo_private_flag', 'collmemo_private_flag', 161, false ),
            ( sp_18_table_output_step_dwid, 'docmemo_active_flag', 'docmemo_active_flag', 162, false ),
            ( sp_18_table_output_step_dwid, 'docmemo_memo_date', 'docmemo_memo_date', 163, false ),
            ( sp_18_table_output_step_dwid, 'docmemo_memo_sak', 'docmemo_memo_sak', 164, false ),
            ( sp_18_table_output_step_dwid, 'docmemo_memo_subject', 'docmemo_memo_subject', 165, false ),
            ( sp_18_table_output_step_dwid, 'docmemo_memo_text', 'docmemo_memo_text', 166, false ),
            ( sp_18_table_output_step_dwid, 'docmemo_memo_type', 'docmemo_memo_type', 167, false ),
            ( sp_18_table_output_step_dwid, 'docmemo_posted_by', 'docmemo_posted_by', 168, false ),
            ( sp_18_table_output_step_dwid, 'docmemo_private_flag', 'docmemo_private_flag', 169, false ),
            ( sp_18_table_output_step_dwid, 'business_tran_log_sak', 'business_tran_log_sak', 170, false ),
            ( sp_18_table_output_step_dwid, 'carrier_code', 'carrier_code', 171, false ),
            ( sp_18_table_output_step_dwid, 'carrier_id', 'carrier_id', 172, false ),
            ( sp_18_table_output_step_dwid, 'certification_code', 'certification_code', 173, false ),
            ( sp_18_table_output_step_dwid, 'destination_type_flag', 'destination_type_flag', 174, false ),
            ( sp_18_table_output_step_dwid, 'effective_date', 'effective_date', 175, false ),
            ( sp_18_table_output_step_dwid, 'deposit_date', 'deposit_date', 176, false ),
            ( sp_18_table_output_step_dwid, 'release_date', 'release_date', 177, false ),
            ( sp_18_table_output_step_dwid, 'effective_rate', 'effective_rate', 178, false ),
            ( sp_18_table_output_step_dwid, 'handling_option', 'handling_option', 179, false ),
            ( sp_18_table_output_step_dwid, 'btl_investor_code', 'btl_investor_code', 180, false ),
            ( sp_18_table_output_step_dwid, 'btl_notation', 'btl_notation', 181, false ),
            ( sp_18_table_output_step_dwid, 'posted_by', 'posted_by', 182, false ),
            ( sp_18_table_output_step_dwid, 'release_code', 'release_code', 183, false ),
            ( sp_18_table_output_step_dwid, 'release_request_identifier', 'release_request_identifier', 184, false ),
            ( sp_18_table_output_step_dwid, 'request_date', 'request_date', 185, false ),
            ( sp_18_table_output_step_dwid, 'requestor', 'requestor', 186, false ),
            ( sp_18_table_output_step_dwid, 'return_due_date', 'return_due_date', 187, false ),
            ( sp_18_table_output_step_dwid, 'reversal_method', 'reversal_method', 188, false ),
            ( sp_18_table_output_step_dwid, 'shipment_id', 'shipment_id', 189, false ),
            ( sp_18_table_output_step_dwid, 'task_type_code', 'task_type_code', 190, false ),
            ( sp_18_table_output_step_dwid, 'task_type_code_rel', 'task_type_code_rel', 191, false ),
            ( sp_18_table_output_step_dwid, 'btl_track_location_code', 'btl_track_location_code', 192, false ),
            ( sp_18_table_output_step_dwid, 'transtype', 'transtype', 193, false ),
            ( sp_18_table_output_step_dwid, 'workbin_code', 'workbin_code', 194, false ),
            ( sp_18_table_output_step_dwid, 'funding_id', 'funding_id', 195, false ),
            ( sp_18_table_output_step_dwid, 'funding_date', 'funding_date', 196, false ),
            ( sp_18_table_output_step_dwid, 'sched_funding_date', 'sched_funding_date', 197, false ),
            ( sp_18_table_output_step_dwid, 'doctype_descr', 'doctype_descr', 198, false ),
            ( sp_18_table_output_step_dwid, 'question_descr', 'question_descr', 199, false ),
            ( sp_18_table_output_step_dwid, 'expires', 'expires', 200, false ),
            ( sp_18_table_output_step_dwid, 'loan_is_active', 'loan_is_active', 201, false ),
            ( sp_18_table_output_step_dwid, 'lender_sak', 'lender_sak', 202, false ),
            ( sp_18_table_output_step_dwid, 'loan_descr', 'loan_descr', 203, false ),
            ( sp_18_table_output_step_dwid, 'loan_id', 'loan_id', 204, false ),
            ( sp_18_table_output_step_dwid, 'loan_inception', 'loan_inception', 205, false ),
            ( sp_18_table_output_step_dwid, 'loan_sak', 'loan_sak', 206, false ),
            ( sp_18_table_output_step_dwid, 'max_balance_amt', 'max_balance_amt', 207, false ),
            ( sp_18_table_output_step_dwid, 'max_balance_flag', 'max_balance_flag', 208, false ),
            ( sp_18_table_output_step_dwid, 'max_balance_pct', 'max_balance_pct', 209, false ),
            ( sp_18_table_output_step_dwid, 'orig_prin_balance', 'orig_prin_balance', 210, false ),
            ( sp_18_table_output_step_dwid, 'payoff_date', 'payoff_date', 211, false ),
            ( sp_18_table_output_step_dwid, 'pricing_flag', 'pricing_flag', 212, false ),
            ( sp_18_table_output_step_dwid, 'pricing_rule_code', 'pricing_rule_code', 213, false ),
            ( sp_18_table_output_step_dwid, 'pricing_rule_flag', 'pricing_rule_flag', 214, false ),
            ( sp_18_table_output_step_dwid, 'sequence', 'sequence', 215, false ),
            ( sp_18_table_output_step_dwid, 'curr_prin_balance', 'curr_prin_balance', 216, false ),
            ( sp_18_table_output_step_dwid, 'curr_amount', 'curr_amount', 217, false ),
            ( sp_18_table_output_step_dwid, 'curr_interest', 'curr_interest', 218, false ),
            ( sp_18_table_output_step_dwid, 'curr_fee', 'curr_fee', 219, false ),
            ( sp_18_table_output_step_dwid, 'curr_cof', 'curr_cof', 220, false ),
            ( sp_18_table_output_step_dwid, 'curr_unapplied', 'curr_unapplied', 221, false ),
            ( sp_18_table_output_step_dwid, 'redemptive_value', 'redemptive_value', 222, false ),
            ( sp_18_table_output_step_dwid, 'lender_code', 'lender_code', 223, false ),
            ( sp_18_table_output_step_dwid, 'lender_descr', 'lender_descr', 224, false ),
            ( sp_18_table_output_step_dwid, 'cdays_aging', 'cdays_aging', 225, false ),
            ( sp_18_table_output_step_dwid, 'bdays_aging', 'bdays_aging', 226, false ),
            ( sp_18_table_output_step_dwid, 'coll_group_code', 'coll_group_code', 227, false ),
            ( sp_18_table_output_step_dwid, 'member_sak', 'member_sak', 228, false ),
            ( sp_18_table_output_step_dwid, 'query_stmt_descr', 'query_stmt_descr', 229, false ),
            ( sp_18_table_output_step_dwid, 'cleared_docex_notation', 'cleared_docex_notation', 230, false ),
            ( sp_18_table_output_step_dwid, 'cleared_opendate', 'cleared_opendate', 231, false ),
            ( sp_18_table_output_step_dwid, 'cleared_question_code', 'cleared_question_code', 232, false ),
            ( sp_18_table_output_step_dwid, 'cleared_question_descr', 'cleared_question_descr', 233, false ),
            ( sp_18_table_output_step_dwid, 'takeout_value', 'takeout_value', 234, false ),
            ( sp_18_table_output_step_dwid, 'collateral_deficit', 'collateral_deficit', 235, false ),
            ( sp_18_table_output_step_dwid, 'curr_cltv', 'curr_cltv', 236, false ),
            ( sp_18_table_output_step_dwid, 'curr_ltv', 'curr_ltv', 237, false ),
            ( sp_18_table_output_step_dwid, 'customer_code_list', 'customer_code_list', 238, false ),
            ( sp_18_table_output_step_dwid, 'customer_account_key_list', 'customer_account_key_list', 239, false ),
            ( sp_18_table_output_step_dwid, 'exist_status_code_list', 'exist_status_code_list', 240, false ),
            ( sp_18_table_output_step_dwid, 'date_analysis', 'date_analysis', 241, false ),
            ( sp_18_table_output_step_dwid, 'coll_sel_opt', 'coll_sel_opt', 242, false ),
            ( sp_18_table_output_step_dwid, 'begin_date', 'begin_date', 243, false ),
            ( sp_18_table_output_step_dwid, 'end_date', 'end_date', 244, false ),
            ( sp_18_table_output_step_dwid, 'print_memos', 'print_memos', 245, false ),
            ( sp_18_table_output_step_dwid, 'production_stage_code_list', 'production_stage_code_list', 246, false ),
            ( sp_18_table_output_step_dwid, 'print_docs', 'print_docs', 247, false ),
            ( sp_18_table_output_step_dwid, 'print_exceptions', 'print_exceptions', 248, false ),
            ( sp_18_table_output_step_dwid, 'sort_option', 'sort_option', 249, false ),
            ( sp_18_table_output_step_dwid, 'format_option', 'format_option', 250, false )
;

-- SP-18 edw field definition insert
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, data_type)
    VALUES  (sp_18_edw_table_definition_dwid, 'etl_batch_id', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'data_source_dwid', FALSE, 'BIGINT'),
            (sp_18_edw_table_definition_dwid, 'input_filename', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'rowtype', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'customer_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'customer_name', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'account_sak', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'customer_account_key', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'renewal_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'account_descr', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'cost_center', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'orig_advance_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'acquisition_cost', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'address', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'amortization_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'anncap', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'armadj', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'armconv', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'armindex', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'armmargin', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'armround', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'armteaser', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'as_of_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'asset_class_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'auction_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'balloon_flag', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'bar_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'borr_1_first_name', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'borr_1_last_name', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'borr_2_first_name', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'borr_2_last_name', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'city', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'closing_agent_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'coll_closed_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'coll_valuation_set_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'coll_value_expire_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'coll_value_recalc_flag', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collateral_key', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collateral_key2', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collateral_key3', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collateral_sak', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collateral_value', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collateral_value_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collateral_value_flag', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collgroup', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'construction_cost', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'credit_grade_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'curr_appraised_value', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'curr_payment', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'curr_pledge_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'curr_rate', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'curr_upb', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'custodian_sak', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'customer_sak', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'debt_service_ratio', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'delinquent_days', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'delinquent_history', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'doc_level_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'document_set_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'coll_exist_status_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'expire_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'fico_score', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'first_rate_change_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'firstdue', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'coll_home_track_location_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'instrument_num', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'inv_commit_expire_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'inv_commit_number', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'inv_commit_price', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'investor_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'investor_id', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'coll_is_active', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'last_paid_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'lien_position', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'lifecap', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'coll_major_count', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'market_value', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'market_value_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'market_value_expire_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'market_value_override_flag', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'maturity', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'mers_min', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'coll_minor_count', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'months_to_roll', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'next_due_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'next_inspection_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'next_rate_change_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'occupancy_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'occupancy_ratio', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'orig_appraised_value', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'orig_pledge_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'orig_rate', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'orig_upb', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'original_cltv', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'original_ltv', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'original_term', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'origination_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'originator_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'p_i', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'paid_to_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'pool_id', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'prepay_penalty_flag', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'prepay_penalty_pct', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'product_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'production_stage_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'production_stage_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'production_grade_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'production_grade_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'property_type_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'purpose_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'rate_change_frequency', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'record_book', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'record_page', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'recorded', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'coll_release_request_identifier', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'scheduled_upb', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'coll_shipment_id', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'short_name', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'state', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'tenant_num', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'tmo_ratio', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'track_item_type_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'coll_track_location_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'udf_char_1', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'udf_char_2', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'udf_date_1', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'udf_date_2', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'udf_dollar_1', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'udf_dollar_2', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'udf_int_1', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'udf_int_2', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'udf_pct_1', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'udf_pct_2', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'units', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'zip', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'warehouse_aging_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'active_flag', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'doctype_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'document_descr', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'document_sak', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'doc_exist_status_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'doc_home_track_location_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'doc_major_count', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'doc_minor_count', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'doc_release_request_identifier', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'doc_track_location_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'cleared_flag', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'fatal_error_flag', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'docex_notation', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'opendate', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'question_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'updated_by', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collmemo_active_flag', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collmemo_memo_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collmemo_memo_sak', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collmemo_memo_subject', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collmemo_memo_text', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collmemo_memo_type', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collmemo_posted_by', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collmemo_private_flag', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'docmemo_active_flag', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'docmemo_memo_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'docmemo_memo_sak', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'docmemo_memo_subject', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'docmemo_memo_text', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'docmemo_memo_type', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'docmemo_posted_by', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'docmemo_private_flag', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'business_tran_log_sak', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'carrier_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'carrier_id', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'certification_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'destination_type_flag', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'effective_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'deposit_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'release_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'effective_rate', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'handling_option', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'btl_investor_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'btl_notation', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'posted_by', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'release_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'release_request_identifier', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'request_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'requestor', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'return_due_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'reversal_method', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'shipment_id', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'task_type_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'task_type_code_rel', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'btl_track_location_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'transtype', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'workbin_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'funding_id', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'funding_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'sched_funding_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'doctype_descr', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'question_descr', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'expires', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'loan_is_active', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'lender_sak', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'loan_descr', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'loan_id', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'loan_inception', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'loan_sak', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'max_balance_amt', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'max_balance_flag', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'max_balance_pct', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'orig_prin_balance', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'payoff_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'pricing_flag', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'pricing_rule_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'pricing_rule_flag', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'sequence', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'curr_prin_balance', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'curr_amount', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'curr_interest', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'curr_fee', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'curr_cof', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'curr_unapplied', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'redemptive_value', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'lender_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'lender_descr', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'cdays_aging', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'bdays_aging', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'coll_group_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'member_sak', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'query_stmt_descr', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'cleared_docex_notation', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'cleared_opendate', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'cleared_question_code', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'cleared_question_descr', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'takeout_value', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'collateral_deficit', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'curr_cltv', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'curr_ltv', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'customer_code_list', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'customer_account_key_list', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'exist_status_code_list', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'date_analysis', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'coll_sel_opt', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'begin_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'end_date', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'print_memos', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'production_stage_code_list', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'print_docs', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'print_exceptions', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'sort_option', FALSE, 'TEXT'),
            (sp_18_edw_table_definition_dwid, 'format_option', FALSE, 'TEXT')
;

-- SP-19 edw table definition insert
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
    VALUES  ('ingress', 'warehouse_banks', 'loan_inventory_bank_montreal', NULL)
    RETURNING dwid INTO sp_19_edw_table_definition_dwid;

-- SP-19 process input
    INSERT INTO mdi.process (name, description)
    VALUES ('SP-19', 'Load Bank of Montreal bank data to the ingress.warehoues_banks.loan_inventory_bank_montreal table')
    RETURNING dwid INTO sp_19_process_dwid;

-- SP-19 excel input step insert
    INSERT INTO mdi.microsoft_excel_input_step ( process_dwid, spreadsheet_type, filemask, exclude_filemask
                                               , file_required, include_subfolders, sheet_name, sheet_start_row
                                               , sheet_start_col, data_source_dwid )
    VALUES ( sp_19_process_dwid, 'POI', '*', NULL, 'Y', 'N', 'Sheet1', 1, 0, 0 )
    RETURNING dwid INTO sp_19_microsoft_excel_input_step_dwid;

-- SP-19 excel input step fields insert
    INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type, field_format, field_length,
                                            field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
    VALUES  ( sp_19_microsoft_excel_input_step_dwid, 'Seller Loan ID', 'String', NULL, -1, -1, '$', '.', ',', 'none', 1 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Seller Code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 2 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Status', 'String', NULL, -1, -1, '$', '.', ',', 'none', 3 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Wire Confirm Status', 'String', NULL, -1, -1, '$', '.', ',', 'none', 4 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Fed Ref', 'String', NULL, -1, -1, '$', '.', ',', 'none', 5 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Product Type', 'String', NULL, -1, -1, '$', '.', ',', 'none', 6 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Bal Orig', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 7 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Lien', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 8 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'First Name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 9 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Last Name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 10 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Advance Amt', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 11 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Occupancy', 'String', NULL, -1, -1, '$', '.', ',', 'none', 12 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'CF', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 13 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'LTV', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 14 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'CLTV', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 15 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Purpose', 'String', NULL, -1, -1, '$', '.', ',', 'none', 16 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Current Rate', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 17 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Rt Orig', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 18 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Rt Adjustable Flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 19 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Original Term', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 20 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Address', 'String', NULL, -1, -1, '$', '.', ',', 'none', 21 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'State', 'String', NULL, -1, -1, '$', '.', ',', 'none', 22 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'City', 'String', NULL, -1, -1, '$', '.', ',', 'none', 23 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Zip', 'String', NULL, -1, -1, '$', '.', ',', 'none', 24 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Is Wet Flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 25 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Custodian Status', 'String', NULL, -1, -1, '$', '.', ',', 'none', 26 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Agency', 'String', NULL, -1, -1, '$', '.', ',', 'none', 27 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Product Type Tape', 'String', NULL, -1, -1, '$', '.', ',', 'none', 28 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Funding Date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 29 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'FICO', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 30 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Bal Curr', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 31 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Wire Amount', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 32 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Origination Dt', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 33 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Maturity Dt', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 34 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Co Borrower First Name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 35 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Co Borrower Name Last', 'String', NULL, -1, -1, '$', '.', ',', 'none', 36 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Co Borrower FICO', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 37 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'MERS Loan ID', 'String', NULL, -1, -1, '$', '.', ',', 'none', 38 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'MERS Registration', 'String', NULL, -1, -1, '$', '.', ',', 'none', 39 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'MERS Flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 40 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Property Type', 'String', NULL, -1, -1, '$', '.', ',', 'none', 41 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Units', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 42 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Doc Type', 'String', NULL, -1, -1, '$', '.', ',', 'none', 43 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Appraisal Value', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 44 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Sales Price', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 45 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'DTI', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 46 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Balloon', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 47 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Balloon Term', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 48 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Origination Channel', 'String', NULL, -1, -1, '$', '.', ',', 'none', 49 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'FHAVA Cert No', 'String', NULL, -1, -1, '$', '.', ',', 'none', 50 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Index', 'String', NULL, -1, -1, '$', '.', ',', 'none', 51 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Margin', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 52 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Rt Reset Dt First', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 53 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Rt Reset Mo First', 'String', NULL, -1, -1, '$', '.', ',', 'none', 54 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Pmt Reset Dt First', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 55 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Rt Cap First', 'String', NULL, -1, -1, '$', '.', ',', 'none', 56 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Life Cap', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 57 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Rt Reset Frequency', 'String', NULL, -1, -1, '$', '.', ',', 'none', 58 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Rt Floor Life', 'String', NULL, -1, -1, '$', '.', ',', 'none', 59 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Rt Lookback Period', 'String', NULL, -1, -1, '$', '.', ',', 'none', 60 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Rt Rounding Factor', 'String', NULL, -1, -1, '$', '.', ',', 'none', 61 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Investor ID', 'String', NULL, -1, -1, '$', '.', ',', 'none', 62 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'PMI Cert No', 'String', NULL, -1, -1, '$', '.', ',', 'none', 63 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'PMI Company', 'String', NULL, -1, -1, '$', '.', ',', 'none', 64 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'PMI', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 65 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'APR', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 66 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Section32 Flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 67 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'AUS Rating', 'String', NULL, -1, -1, '$', '.', ',', 'none', 68 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'AUS Response', 'String', NULL, -1, -1, '$', '.', ',', 'none', 69 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Enote Flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 70 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Prior BK Filing Dt', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 71 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Periodic Cap', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 72 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Interest Only', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 73 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Pmt Due Dt First', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 74 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Pmt Due Dt Next', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 75 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'As Of Dt Act', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 76 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Delq Days OTS', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 77 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Pmt Amount', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 78 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'LMS Loan ID', 'String', NULL, -1, -1, '$', '.', ',', 'none', 79 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Account Number', 'String', NULL, -1, -1, '$', '.', ',', 'none', 80 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Bank ABA', 'String', NULL, -1, -1, '$', '.', ',', 'none', 81 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Account Name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 82 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Bank Name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 83 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Additional Instructions 1', 'String', NULL, -1, -1, '$', '.', ',', 'none', 84 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Additional Instructions 2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 85 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Bulk Wire Flag', 'String', NULL, -1, -1, '$', '.', ',', 'none', 86 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Takeout Commitment Price', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 87 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Commitment Expiration Date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 88 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'County Code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 89 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'County', 'String', NULL, -1, -1, '$', '.', ',', 'none', 90 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Calendar Days Aged', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 91 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Dry Date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 92 ),
            ( sp_19_microsoft_excel_input_step_dwid, 'Ship Date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 93 )
;

-- SP-19 table output step
    INSERT INTO mdi.table_output_step ( process_dwid, target_schema, target_table, commit_size, partitioning_field
                                      , table_name_field, auto_generated_key_field, partition_data_per
                                      , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                      , connectionname, partition_over_tables, specify_database_fields
                                      , ignore_insert_errors, use_batch_update )
    VALUES (sp_19_process_dwid, 'warehouse_banks', 'loan_inventory_bank_montreal', 1000, NULL, NULL, NULL, NULL, 'N',
            NULL,'Y' ,'Ingress DB Connection' ,'N' ,'Y' ,'N' ,'N')
    RETURNING dwid INTO sp_19_table_output_step_dwid;

-- SP-19 table output field insert
    INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive )
    VALUES  ( sp_19_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', 1, false ),
            ( sp_19_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid', 2, false ),
            ( sp_19_table_output_step_dwid, 'input_filename', 'imported_filename', 3, false ),
            ( sp_19_table_output_step_dwid, 'seller_loan_id', 'Seller Loan ID', 4, false ),
            ( sp_19_table_output_step_dwid, 'seller_code', 'Seller Code', 5, false ),
            ( sp_19_table_output_step_dwid, 'status', 'Status', 6, false ),
            ( sp_19_table_output_step_dwid, 'wire_confirm_status', 'Wire Confirm Status', 7, false ),
            ( sp_19_table_output_step_dwid, 'fed_ref', 'Fed Ref', 8, false ),
            ( sp_19_table_output_step_dwid, 'product_type', 'Product Type', 9, false ),
            ( sp_19_table_output_step_dwid, 'bal_orig', 'Bal Orig', 10, false ),
            ( sp_19_table_output_step_dwid, 'lien', 'Lien', 11, false ),
            ( sp_19_table_output_step_dwid, 'first_name', 'First Name', 12, false ),
            ( sp_19_table_output_step_dwid, 'last_name', 'Last Name', 13, false ),
            ( sp_19_table_output_step_dwid, 'advance_amt', 'Advance Amt', 14, false ),
            ( sp_19_table_output_step_dwid, 'occupancy', 'Occupancy', 15, false ),
            ( sp_19_table_output_step_dwid, 'cf', 'CF', 16, false ),
            ( sp_19_table_output_step_dwid, 'ltv', 'LTV', 17, false ),
            ( sp_19_table_output_step_dwid, 'cltv', 'CLTV', 18, false ),
            ( sp_19_table_output_step_dwid, 'purpose', 'Purpose', 19, false ),
            ( sp_19_table_output_step_dwid, 'current_rate', 'Current Rate', 20, false ),
            ( sp_19_table_output_step_dwid, 'rt_orig', 'Rt Orig', 21, false ),
            ( sp_19_table_output_step_dwid, 'rt_adjustable_flag', 'Rt Adjustable Flag', 22, false ),
            ( sp_19_table_output_step_dwid, 'original_term', 'Original Term', 23, false ),
            ( sp_19_table_output_step_dwid, 'address', 'Address', 24, false ),
            ( sp_19_table_output_step_dwid, 'state', 'State', 25, false ),
            ( sp_19_table_output_step_dwid, 'city', 'City', 26, false ),
            ( sp_19_table_output_step_dwid, 'zip', 'Zip', 27, false ),
            ( sp_19_table_output_step_dwid, 'is_wet_flag', 'Is Wet Flag', 28, false ),
            ( sp_19_table_output_step_dwid, 'custodian_status', 'Custodian Status', 29, false ),
            ( sp_19_table_output_step_dwid, 'agency', 'Agency', 30, false ),
            ( sp_19_table_output_step_dwid, 'product_type_tape', 'Product Type Tape', 31, false ),
            ( sp_19_table_output_step_dwid, 'funding_date', 'Funding Date', 32, false ),
            ( sp_19_table_output_step_dwid, 'fico', 'FICO', 33, false ),
            ( sp_19_table_output_step_dwid, 'bal_curr', 'Bal Curr', 34, false ),
            ( sp_19_table_output_step_dwid, 'wire_amount', 'Wire Amount', 35, false ),
            ( sp_19_table_output_step_dwid, 'origination_dt', 'Origination Dt', 36, false ),
            ( sp_19_table_output_step_dwid, 'maturity_dt', 'Maturity Dt', 37, false ),
            ( sp_19_table_output_step_dwid, 'co_borrower_first_name', 'Co Borrower First Name', 38, false ),
            ( sp_19_table_output_step_dwid, 'co_borrower_name_last', 'Co Borrower Name Last', 39, false ),
            ( sp_19_table_output_step_dwid, 'co_borrower_fico', 'Co Borrower FICO', 40, false ),
            ( sp_19_table_output_step_dwid, 'mers_loan_id', 'MERS Loan ID', 41, false ),
            ( sp_19_table_output_step_dwid, 'mers_registration', 'MERS Registration', 42, false ),
            ( sp_19_table_output_step_dwid, 'mers_flag', 'MERS Flag', 43, false ),
            ( sp_19_table_output_step_dwid, 'property_type', 'Property Type', 44, false ),
            ( sp_19_table_output_step_dwid, 'units', 'Units', 45, false ),
            ( sp_19_table_output_step_dwid, 'doc_type', 'Doc Type', 46, false ),
            ( sp_19_table_output_step_dwid, 'appraisal_value', 'Appraisal Value', 47, false ),
            ( sp_19_table_output_step_dwid, 'sales_price', 'Sales Price', 48, false ),
            ( sp_19_table_output_step_dwid, 'dti', 'DTI', 49, false ),
            ( sp_19_table_output_step_dwid, 'balloon', 'Balloon', 50, false ),
            ( sp_19_table_output_step_dwid, 'balloon_term', 'Balloon Term', 51, false ),
            ( sp_19_table_output_step_dwid, 'origination_channel', 'Origination Channel', 52, false ),
            ( sp_19_table_output_step_dwid, 'fhava_cert_number', 'FHAVA Cert No', 53, false ),
            ( sp_19_table_output_step_dwid, 'index', 'Index', 54, false ),
            ( sp_19_table_output_step_dwid, 'margin', 'Margin', 55, false ),
            ( sp_19_table_output_step_dwid, 'rt_reset_dt_first', 'Rt Reset Dt First', 56, false ),
            ( sp_19_table_output_step_dwid, 'rt_reset_mo_first', 'Rt Reset Mo First', 57, false ),
            ( sp_19_table_output_step_dwid, 'pmt_reset_dt_first', 'Pmt Reset Dt First', 58, false ),
            ( sp_19_table_output_step_dwid, 'rt_cap_first', 'Rt Cap First', 59, false ),
            ( sp_19_table_output_step_dwid, 'life_cap', 'Life Cap', 60, false ),
            ( sp_19_table_output_step_dwid, 'rt_reset_frequency', 'Rt Reset Frequency', 61, false ),
            ( sp_19_table_output_step_dwid, 'rt_floor_life', 'Rt Floor Life', 62, false ),
            ( sp_19_table_output_step_dwid, 'rt_lookback_period', 'Rt Lookback Period', 63, false ),
            ( sp_19_table_output_step_dwid, 'rt_rounding_factor', 'Rt Rounding Factor', 64, false ),
            ( sp_19_table_output_step_dwid, 'investor_id', 'Investor ID', 65, false ),
            ( sp_19_table_output_step_dwid, 'pmi_cert_no', 'PMI Cert No', 66, false ),
            ( sp_19_table_output_step_dwid, 'pmi_company', 'PMI Company', 67, false ),
            ( sp_19_table_output_step_dwid, 'pmi', 'PMI', 68, false ),
            ( sp_19_table_output_step_dwid, 'apr', 'APR', 69, false ),
            ( sp_19_table_output_step_dwid, 'section32_flag', 'Section32 Flag', 70, false ),
            ( sp_19_table_output_step_dwid, 'aus_rating', 'AUS Rating', 71, false ),
            ( sp_19_table_output_step_dwid, 'aus_response', 'AUS Response', 72, false ),
            ( sp_19_table_output_step_dwid, 'enote_flag', 'Enote Flag', 73, false ),
            ( sp_19_table_output_step_dwid, 'prior_bk_filing_dt', 'Prior BK Filing Dt', 74, false ),
            ( sp_19_table_output_step_dwid, 'periodic_cap', 'Periodic Cap', 75, false ),
            ( sp_19_table_output_step_dwid, 'interest_only', 'Interest Only', 76, false ),
            ( sp_19_table_output_step_dwid, 'pmt_due_dt_first', 'Pmt Due Dt First', 77, false ),
            ( sp_19_table_output_step_dwid, 'pmt_due_dt_next', 'Pmt Due Dt Next', 78, false ),
            ( sp_19_table_output_step_dwid, 'as_of_dt_act', 'As Of Dt Act', 79, false ),
            ( sp_19_table_output_step_dwid, 'delq_days_ots', 'Delq Days OTS', 80, false ),
            ( sp_19_table_output_step_dwid, 'pmt_amount', 'Pmt Amount', 81, false ),
            ( sp_19_table_output_step_dwid, 'lms_loan_id', 'LMS Loan ID', 82, false ),
            ( sp_19_table_output_step_dwid, 'account_name', 'Account Name', 85, false ),
            ( sp_19_table_output_step_dwid, 'bank_name', 'Bank Name', 86, false ),
            ( sp_19_table_output_step_dwid, 'additional_nstructions_1', 'Additional Instructions 1', 87, false ),
            ( sp_19_table_output_step_dwid, 'additional_instructions_2', 'Additional Instructions 2', 88, false ),
            ( sp_19_table_output_step_dwid, 'bulk_wire_flag', 'Bulk Wire Flag', 89, false ),
            ( sp_19_table_output_step_dwid, 'takeout_commitment_price', 'Takeout Commitment Price', 90, false ),
            ( sp_19_table_output_step_dwid, 'commitment_expiration_date', 'Commitment Expiration Date', 91, false ),
            ( sp_19_table_output_step_dwid, 'county_code', 'County Code', 92, false ),
            ( sp_19_table_output_step_dwid, 'county', 'County', 93, false ),
            ( sp_19_table_output_step_dwid, 'calendar_days_aged', 'Calendar Days Aged', 94, false ),
            ( sp_19_table_output_step_dwid, 'dry_date', 'Dry Date', 95, false ),
            ( sp_19_table_output_step_dwid, 'ship_date', 'Ship Date', 96, false )
;

-- SP-19 edw field definition insert
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, data_type)
    VALUES  (sp_19_edw_table_definition_dwid, 'etl_batch_id', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'data_source_dwid', FALSE, 'BIGINT'),
            (sp_19_edw_table_definition_dwid, 'input_filename', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'seller_loan_id', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'seller_code', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'status', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'wire_confirm_status', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'fed_ref', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'product_type', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'bal_orig', FALSE, 'NUMERIC(21,3)'),
            (sp_19_edw_table_definition_dwid, 'lien', FALSE, 'INTEGER'),
            (sp_19_edw_table_definition_dwid, 'first_name', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'last_name', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'advance_amt', FALSE, 'NUMERIC(21,3)'),
            (sp_19_edw_table_definition_dwid, 'occupancy', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'cf', FALSE, 'INTEGER'),
            (sp_19_edw_table_definition_dwid, 'ltv', FALSE, 'NUMERIC(15,9)'),
            (sp_19_edw_table_definition_dwid, 'cltv', FALSE, 'NUMERIC(15,9)'),
            (sp_19_edw_table_definition_dwid, 'purpose', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'current_rate', FALSE, 'NUMERIC(15,9)'),
            (sp_19_edw_table_definition_dwid, 'rt_orig', FALSE, 'NUMERIC(15,9)'),
            (sp_19_edw_table_definition_dwid, 'rt_adjustable_flag', FALSE, 'INTEGER'),
            (sp_19_edw_table_definition_dwid, 'original_term', FALSE, 'INTEGER'),
            (sp_19_edw_table_definition_dwid, 'address', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'state', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'city', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'zip', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'is_wet_flag', FALSE, 'INTEGER'),
            (sp_19_edw_table_definition_dwid, 'custodian_status', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'agency', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'product_type_tape', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'funding_date', FALSE, 'DATE'),
            (sp_19_edw_table_definition_dwid, 'fico', FALSE, 'INTEGER'),
            (sp_19_edw_table_definition_dwid, 'bal_curr', FALSE, 'NUMERIC(21,3)'),
            (sp_19_edw_table_definition_dwid, 'wire_amount', FALSE, 'NUMERIC(21,3)'),
            (sp_19_edw_table_definition_dwid, 'origination_dt', FALSE, 'DATE'),
            (sp_19_edw_table_definition_dwid, 'maturity_dt', FALSE, 'DATE'),
            (sp_19_edw_table_definition_dwid, 'co_borrower_first_name', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'co_borrower_name_last', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'co_borrower_fico', FALSE, 'INTEGER'),
            (sp_19_edw_table_definition_dwid, 'mers_loan_id', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'mers_registration', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'mers_flag', FALSE, 'INTEGER'),
            (sp_19_edw_table_definition_dwid, 'property_type', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'units', FALSE, 'INTEGER'),
            (sp_19_edw_table_definition_dwid, 'doc_type', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'appraisal_value', FALSE, 'NUMERIC(21,3)'),
            (sp_19_edw_table_definition_dwid, 'sales_price', FALSE, 'NUMERIC(21,3)'),
            (sp_19_edw_table_definition_dwid, 'dti', FALSE, 'NUMERIC(15,9)'),
            (sp_19_edw_table_definition_dwid, 'balloon', FALSE, 'INTEGER'),
            (sp_19_edw_table_definition_dwid, 'balloon_term', FALSE, 'INTEGER'),
            (sp_19_edw_table_definition_dwid, 'origination_channel', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'fhava_cert_number', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'index', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'margin', FALSE, 'NUMERIC(15,9)'),
            (sp_19_edw_table_definition_dwid, 'rt_reset_dt_first', FALSE, 'DATE'),
            (sp_19_edw_table_definition_dwid, 'rt_reset_mo_first', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'pmt_reset_dt_first', FALSE, 'DATE'),
            (sp_19_edw_table_definition_dwid, 'rt_cap_first', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'life_cap', FALSE, 'NUMERIC(15,9)'),
            (sp_19_edw_table_definition_dwid, 'rt_reset_frequency', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'rt_floor_life', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'rt_lookback_period', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'rt_rounding_factor', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'investor_id', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'pmi_cert_no', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'pmi_company', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'pmi', FALSE, 'NUMERIC(15,9)'),
            (sp_19_edw_table_definition_dwid, 'apr', FALSE, 'NUMERIC(15,9)'),
            (sp_19_edw_table_definition_dwid, 'section32_flag', FALSE, 'INTEGER'),
            (sp_19_edw_table_definition_dwid, 'aus_rating', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'aus_response', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'enote_flag', FALSE, 'INTEGER'),
            (sp_19_edw_table_definition_dwid, 'prior_bk_filing_dt', FALSE, 'DATE'),
            (sp_19_edw_table_definition_dwid, 'periodic_cap', FALSE, 'NUMERIC(15,9)'),
            (sp_19_edw_table_definition_dwid, 'interest_only', FALSE, 'INTEGER'),
            (sp_19_edw_table_definition_dwid, 'pmt_due_dt_first', FALSE, 'DATE'),
            (sp_19_edw_table_definition_dwid, 'pmt_due_dt_next', FALSE, 'DATE'),
            (sp_19_edw_table_definition_dwid, 'as_of_dt_act', FALSE, 'DATE'),
            (sp_19_edw_table_definition_dwid, 'delq_days_ots', FALSE, 'INTEGER'),
            (sp_19_edw_table_definition_dwid, 'pmt_amount', FALSE, 'NUMERIC(21,3)'),
            (sp_19_edw_table_definition_dwid, 'lms_loan_id', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'account_name', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'bank_name', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'additional_nstructions_1', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'additional_instructions_2', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'bulk_wire_flag', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'takeout_commitment_price', FALSE, 'NUMERIC(21,3)'),
            (sp_19_edw_table_definition_dwid, 'commitment_expiration_date', FALSE, 'DATE'),
            (sp_19_edw_table_definition_dwid, 'county_code', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'county', FALSE, 'TEXT'),
            (sp_19_edw_table_definition_dwid, 'calendar_days_aged', FALSE, 'INTEGER'),
            (sp_19_edw_table_definition_dwid, 'dry_date', FALSE, 'DATETIME'),
            (sp_19_edw_table_definition_dwid, 'ship_date', FALSE, 'DATE')
;

-- SP-20 edw table definition insert
    INSERT INTO mdi.edw_table_definition (database_name, schema_name, table_name, primary_source_edw_table_definition_dwid)
    VALUES  ('ingress', 'warehouse_banks', 'loan_inventory_sterling', NULL)
    RETURNING dwid INTO sp_20_edw_table_definition_dwid;

-- SP-20 process input
    INSERT INTO mdi.process (name, description)
    VALUES ('SP-20', 'Load Sterling bank data to the ingress.warehoues_banks.loan_inventory_sterling table')
    RETURNING dwid INTO sp_20_process_dwid;


-- SP-20 excel input step insert
    INSERT INTO mdi.microsoft_excel_input_step ( process_dwid, spreadsheet_type, filemask, exclude_filemask
                                               , file_required, include_subfolders, sheet_name, sheet_start_row
                                               , sheet_start_col, data_source_dwid )
    VALUES ( sp_20_process_dwid, 'JXL', '*', NULL, 'Y', 'N', 'Results', 1, 0, 0 )
    RETURNING dwid INTO sp_20_microsoft_excel_input_step_dwid;

-- SP-20 excel input field insert
    INSERT INTO mdi.microsoft_excel_input_field ( microsoft_excel_input_step_dwid, field_name, field_type, field_format, field_length,
                                        field_precision, field_currency, field_decimal, field_group, field_trim_type, field_order )
    VALUES  ( sp_20_microsoft_excel_input_step_dwid, 'rowtype', 'String', NULL, -1, -1, '$', '.', ',', 'none', 1 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'customer_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 2 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'customer_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 3 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'account_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 4 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'customer_account_key', 'String', NULL, -1, -1, '$', '.', ',', 'none', 5 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'renewal_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 6 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'account_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 7 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'cost_center', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 8 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'orig_advance_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 9 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'acquisition_cost', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 10 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'address', 'String', NULL, -1, -1, '$', '.', ',', 'none', 11 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'amortization_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 12 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'anncap', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 13 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'armadj', 'String', NULL, -1, -1, '$', '.', ',', 'none', 14 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'armconv', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 15 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'armindex', 'String', NULL, -1, -1, '$', '.', ',', 'none', 16 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'armmargin', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 17 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'armround', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 18 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'armteaser', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 19 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'as_of_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 20 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'asset_class_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 21 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'auction_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 22 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'balloon_flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 23 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'bar_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 24 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'borr_1_first_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 25 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'borr_1_last_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 26 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'borr_2_first_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 27 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'borr_2_last_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 28 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'city', 'String', NULL, -1, -1, '$', '.', ',', 'none', 29 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'closing_agent_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 30 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'coll_closed_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 31 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'coll_valuation_set_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 32 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'coll_value_expire_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 33 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'coll_value_recalc_flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 34 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collateral_key', 'String', NULL, -1, -1, '$', '.', ',', 'none', 35 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collateral_key2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 36 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collateral_key3', 'String', NULL, -1, -1, '$', '.', ',', 'none', 37 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collateral_sak', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 38 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collateral_value', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 39 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collateral_value_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 40 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collateral_value_flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 41 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collgroup', 'String', NULL, -1, -1, '$', '.', ',', 'none', 42 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'construction_cost', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 43 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'credit_grade_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 44 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'curr_appraised_value', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 45 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'curr_payment', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 46 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'curr_pledge_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 47 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'curr_rate', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 48 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'curr_upb', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 49 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'custodian_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 50 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'customer_sak', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 51 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'debt_service_ratio', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 52 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'delinquent_days', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 53 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'delinquent_history', 'String', NULL, -1, -1, '$', '.', ',', 'none', 54 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'doc_level_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 55 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'document_set_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 56 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'coll_exist_status_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 57 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'expire_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 58 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'fico_score', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 59 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'first_rate_change_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 60 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'firstdue', 'String', NULL, -1, -1, '$', '.', ',', 'none', 61 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'coll_home_track_location_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 62 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'instrument_num', 'String', NULL, -1, -1, '$', '.', ',', 'none', 63 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'inv_commit_expire_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 64 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'inv_commit_number', 'String', NULL, -1, -1, '$', '.', ',', 'none', 65 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'inv_commit_price', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 66 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'investor_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 67 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'investor_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 68 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'coll_is_active', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 69 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'last_paid_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 70 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'lien_position', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 71 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'lifecap', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 72 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'coll_major_count', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 73 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'market_value', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 74 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'market_value_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 75 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'market_value_expire_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 76 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'market_value_override_flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 77 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'maturity', 'String', NULL, -1, -1, '$', '.', ',', 'none', 78 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'mers_min', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 79 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'coll_minor_count', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 80 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'months_to_roll', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 81 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'next_due_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 82 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'next_inspection_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 83 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'next_rate_change_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 84 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'occupancy_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 85 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'occupancy_ratio', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 86 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'orig_appraised_value', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 87 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'orig_pledge_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 88 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'orig_rate', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 89 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'orig_upb', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 90 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'original_cltv', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 91 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'original_ltv', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 92 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'original_term', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 93 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'origination_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 94 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'originator_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 95 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'p_i', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 96 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'paid_to_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 97 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'pool_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 98 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'prepay_penalty_flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 99 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'prepay_penalty_pct', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 100 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'product_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 101 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'production_stage_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 102 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'production_stage_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 103 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'property_type_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 104 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'purpose_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 105 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'rate_change_frequency', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 106 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'record_book', 'String', NULL, -1, -1, '$', '.', ',', 'none', 107 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'record_page', 'String', NULL, -1, -1, '$', '.', ',', 'none', 108 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'recorded', 'String', NULL, -1, -1, '$', '.', ',', 'none', 109 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'coll_release_request_identifier', 'String', NULL, -1, -1, '$', '.', ',', 'none', 110 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'scheduled_upb', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 111 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'coll_shipment_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 112 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'short_name', 'String', NULL, -1, -1, '$', '.', ',', 'none', 113 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'ss_number', 'String', NULL, -1, -1, '$', '.', ',', 'none', 114 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'state', 'String', NULL, -1, -1, '$', '.', ',', 'none', 115 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'tenant_num', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 116 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'tmo_ratio', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 117 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'track_item_type_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 118 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'coll_track_location_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 119 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'udf_char_1', 'String', NULL, -1, -1, '$', '.', ',', 'none', 120 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'udf_char_2', 'String', NULL, -1, -1, '$', '.', ',', 'none', 121 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'udf_date_1', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 122 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'udf_date_2', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 123 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'udf_dollar_1', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 124 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'udf_dollar_2', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 125 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'udf_int_1', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 126 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'udf_int_2', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 127 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'udf_pct_1', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 128 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'udf_pct_2', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 129 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'units', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 130 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'zip', 'String', NULL, -1, -1, '$', '.', ',', 'none', 131 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'warehouse_aging_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 132 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'active_flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 133 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'doctype_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 134 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'document_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 135 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'document_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 136 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'doc_exist_status_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 137 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'doc_home_track_location_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 138 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'doc_major_count', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 139 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'doc_minor_count', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 140 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'doc_release_request_identifier', 'String', NULL, -1, -1, '$', '.', ',', 'none', 141 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'doc_track_location_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 142 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'cleared_flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 143 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'fatal_error_flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 144 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'docex_notation', 'String', NULL, -1, -1, '$', '.', ',', 'none', 145 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'opendate', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 146 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'question_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 147 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'updated_by', 'String', NULL, -1, -1, '$', '.', ',', 'none', 148 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collmemo_active_flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 149 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collmemo_memo_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 150 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collmemo_memo_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 151 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collmemo_memo_subject', 'String', NULL, -1, -1, '$', '.', ',', 'none', 152 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collmemo_memo_text', 'String', NULL, -1, -1, '$', '.', ',', 'none', 153 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collmemo_memo_type', 'String', NULL, -1, -1, '$', '.', ',', 'none', 154 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collmemo_posted_by', 'String', NULL, -1, -1, '$', '.', ',', 'none', 155 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collmemo_private_flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 156 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'docmemo_active_flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 157 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'docmemo_memo_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 158 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'docmemo_memo_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 159 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'docmemo_memo_subject', 'String', NULL, -1, -1, '$', '.', ',', 'none', 160 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'docmemo_memo_text', 'String', NULL, -1, -1, '$', '.', ',', 'none', 161 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'docmemo_memo_type', 'String', NULL, -1, -1, '$', '.', ',', 'none', 162 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'docmemo_posted_by', 'String', NULL, -1, -1, '$', '.', ',', 'none', 163 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'docmemo_private_flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 164 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'business_tran_log_sak', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 165 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'carrier_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 166 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'carrier_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 167 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'certification_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 168 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'destination_type_flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 169 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'effective_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 170 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'deposit_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 171 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'release_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 172 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'effective_rate', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 173 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'handling_option', 'String', NULL, -1, -1, '$', '.', ',', 'none', 174 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'btl_investor_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 175 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'btl_notation', 'String', NULL, -1, -1, '$', '.', ',', 'none', 176 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'posted_by', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 177 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'release_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 178 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'release_request_identifier', 'String', NULL, -1, -1, '$', '.', ',', 'none', 179 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'request_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 180 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'requestor', 'String', NULL, -1, -1, '$', '.', ',', 'none', 181 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'return_due_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 182 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'reversal_method', 'String', NULL, -1, -1, '$', '.', ',', 'none', 183 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'shipment_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 184 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'task_type_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 185 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'task_type_code_rel', 'String', NULL, -1, -1, '$', '.', ',', 'none', 186 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'btl_track_location_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 187 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'transtype', 'String', NULL, -1, -1, '$', '.', ',', 'none', 188 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'workbin_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 189 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'funding_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 190 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'funding_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 191 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'sched_funding_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 192 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'doctype_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 193 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'question_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 194 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'expires', 'String', NULL, -1, -1, '$', '.', ',', 'none', 195 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'loan_is_active', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 196 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'lender_sak', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 197 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'loan_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 198 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'loan_id', 'String', NULL, -1, -1, '$', '.', ',', 'none', 199 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'loan_inception', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 200 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'loan_sak', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 201 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'max_balance_amt', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 202 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'max_balance_flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 203 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'max_balance_pct', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 204 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'orig_prin_balance', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 205 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'payoff_date', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 206 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'pricing_flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 207 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'pricing_rule_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 208 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'pricing_rule_flag', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 209 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'sequence', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 210 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'curr_prin_balance', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 211 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'curr_amount', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 212 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'curr_interest', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 213 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'curr_fee', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 214 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'curr_cof', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 215 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'curr_unapplied', 'String', NULL, -1, -1, '$', '.', ',', 'none', 216 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'redemptive_value', 'String', NULL, -1, -1, '$', '.', ',', 'none', 217 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'lender_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 218 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'lender_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 219 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'cdays_aging', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 220 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'bdays_aging', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 221 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'coll_group_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 222 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'member_sak', 'String', NULL, -1, -1, '$', '.', ',', 'none', 223 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'query_stmt_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 224 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'cleared_docex_notation', 'String', NULL, -1, -1, '$', '.', ',', 'none', 225 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'cleared_opendate', 'Date', NULL, -1, -1, '$', '.', ',', 'none', 226 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'cleared_question_code', 'String', NULL, -1, -1, '$', '.', ',', 'none', 227 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'cleared_question_descr', 'String', NULL, -1, -1, '$', '.', ',', 'none', 228 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'takeout_value', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 229 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'collateral_deficit', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 230 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'curr_cltv', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 231 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'curr_ltv', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 232 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'customer_code_list', 'String', NULL, -1, -1, '$', '.', ',', 'none', 233 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'customer_account_key_list', 'String', NULL, -1, -1, '$', '.', ',', 'none', 234 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'exist_status_code_list', 'String', NULL, -1, -1, '$', '.', ',', 'none', 235 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'date_analysis', 'String', NULL, -1, -1, '$', '.', ',', 'none', 236 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'coll_sel_opt', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 237 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'begin_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 238 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'end_date', 'String', NULL, -1, -1, '$', '.', ',', 'none', 239 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'print_memos', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 240 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'production_stage_code_list', 'String', NULL, -1, -1, '$', '.', ',', 'none', 241 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'print_docs', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 242 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'print_exceptions', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 243 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'sort_option', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 244 ),
            ( sp_20_microsoft_excel_input_step_dwid, 'format_option', 'Number', NULL, -1, -1, '$', '.', ',', 'none', 245 )
;


-- SP-20 table output step
    INSERT INTO mdi.table_output_step ( process_dwid, target_schema, target_table, commit_size, partitioning_field
                                      , table_name_field, auto_generated_key_field, partition_data_per
                                      , table_name_defined_in_field, return_auto_generated_key_field, truncate_table
                                      , connectionname, partition_over_tables, specify_database_fields
                                      , ignore_insert_errors, use_batch_update )
    VALUES (sp_20_process_dwid, 'warehouse_banks', 'loan_inventory_sterling', 1000, NULL, NULL, NULL, NULL, 'N',
            NULL,'Y' ,'Ingress DB Connection' ,'N' ,'Y' ,'N' ,'N')
    RETURNING dwid INTO sp_20_table_output_step_dwid;

-- SP-20 table output field insert
    INSERT INTO mdi.table_output_field ( table_output_step_dwid, database_field_name, database_stream_name, field_order, is_sensitive )
    VALUES  ( sp_20_table_output_step_dwid, 'etl_batch_id', 'etl_batch_id', 1, false ),
            ( sp_20_table_output_step_dwid, 'data_source_dwid', 'data_source_dwid', 2, false ),
            ( sp_20_table_output_step_dwid, 'input_filename', 'imported_filename', 3, false ),
            ( sp_20_table_output_step_dwid, 'rowtype', 'rowtype', 4, false ),
            ( sp_20_table_output_step_dwid, 'customer_code', 'customer_code', 5, false ),
            ( sp_20_table_output_step_dwid, 'customer_name', 'customer_name', 6, false ),
            ( sp_20_table_output_step_dwid, 'account_sak', 'account_sak', 7, false ),
            ( sp_20_table_output_step_dwid, 'customer_account_key', 'customer_account_key', 8, false ),
            ( sp_20_table_output_step_dwid, 'renewal_date', 'renewal_date', 9, false ),
            ( sp_20_table_output_step_dwid, 'account_descr', 'account_descr', 10, false ),
            ( sp_20_table_output_step_dwid, 'cost_center', 'cost_center', 11, false ),
            ( sp_20_table_output_step_dwid, 'orig_advance_date', 'orig_advance_date', 12, false ),
            ( sp_20_table_output_step_dwid, 'acquisition_cost', 'acquisition_cost', 13, false ),
            ( sp_20_table_output_step_dwid, 'address', 'address', 14, false ),
            ( sp_20_table_output_step_dwid, 'amortization_code', 'amortization_code', 15, false ),
            ( sp_20_table_output_step_dwid, 'anncap', 'anncap', 16, false ),
            ( sp_20_table_output_step_dwid, 'armadj', 'armadj', 17, false ),
            ( sp_20_table_output_step_dwid, 'armconv', 'armconv', 18, false ),
            ( sp_20_table_output_step_dwid, 'armindex', 'armindex', 19, false ),
            ( sp_20_table_output_step_dwid, 'armmargin', 'armmargin', 20, false ),
            ( sp_20_table_output_step_dwid, 'armround', 'armround', 21, false ),
            ( sp_20_table_output_step_dwid, 'armteaser', 'armteaser', 22, false ),
            ( sp_20_table_output_step_dwid, 'as_of_date', 'as_of_date', 23, false ),
            ( sp_20_table_output_step_dwid, 'asset_class_code', 'asset_class_code', 24, false ),
            ( sp_20_table_output_step_dwid, 'auction_date', 'auction_date', 25, false ),
            ( sp_20_table_output_step_dwid, 'balloon_flag', 'balloon_flag', 26, false ),
            ( sp_20_table_output_step_dwid, 'bar_code', 'bar_code', 27, false ),
            ( sp_20_table_output_step_dwid, 'borr_1_first_name', 'borr_1_first_name', 28, false ),
            ( sp_20_table_output_step_dwid, 'borr_1_last_name', 'borr_1_last_name', 29, false ),
            ( sp_20_table_output_step_dwid, 'borr_2_first_name', 'borr_2_first_name', 30, false ),
            ( sp_20_table_output_step_dwid, 'borr_2_last_name', 'borr_2_last_name', 31, false ),
            ( sp_20_table_output_step_dwid, 'city', 'city', 32, false ),
            ( sp_20_table_output_step_dwid, 'closing_agent_code', 'closing_agent_code', 33, false ),
            ( sp_20_table_output_step_dwid, 'coll_closed_date', 'coll_closed_date', 34, false ),
            ( sp_20_table_output_step_dwid, 'coll_valuation_set_code', 'coll_valuation_set_code', 35, false ),
            ( sp_20_table_output_step_dwid, 'coll_value_expire_date', 'coll_value_expire_date', 36, false ),
            ( sp_20_table_output_step_dwid, 'coll_value_recalc_flag', 'coll_value_recalc_flag', 37, false ),
            ( sp_20_table_output_step_dwid, 'collateral_key', 'collateral_key', 38, false ),
            ( sp_20_table_output_step_dwid, 'collateral_key2', 'collateral_key2', 39, false ),
            ( sp_20_table_output_step_dwid, 'collateral_key3', 'collateral_key3', 40, false ),
            ( sp_20_table_output_step_dwid, 'collateral_sak', 'collateral_sak', 41, false ),
            ( sp_20_table_output_step_dwid, 'collateral_value', 'collateral_value', 42, false ),
            ( sp_20_table_output_step_dwid, 'collateral_value_date', 'collateral_value_date', 43, false ),
            ( sp_20_table_output_step_dwid, 'collateral_value_flag', 'collateral_value_flag', 44, false ),
            ( sp_20_table_output_step_dwid, 'collgroup', 'collgroup', 45, false ),
            ( sp_20_table_output_step_dwid, 'construction_cost', 'construction_cost', 46, false ),
            ( sp_20_table_output_step_dwid, 'credit_grade_code', 'credit_grade_code', 47, false ),
            ( sp_20_table_output_step_dwid, 'curr_appraised_value', 'curr_appraised_value', 48, false ),
            ( sp_20_table_output_step_dwid, 'curr_payment', 'curr_payment', 49, false ),
            ( sp_20_table_output_step_dwid, 'curr_pledge_date', 'curr_pledge_date', 50, false ),
            ( sp_20_table_output_step_dwid, 'curr_rate', 'curr_rate', 51, false ),
            ( sp_20_table_output_step_dwid, 'curr_upb', 'curr_upb', 52, false ),
            ( sp_20_table_output_step_dwid, 'custodian_sak', 'custodian_sak', 53, false ),
            ( sp_20_table_output_step_dwid, 'customer_sak', 'customer_sak', 54, false ),
            ( sp_20_table_output_step_dwid, 'debt_service_ratio', 'debt_service_ratio', 55, false ),
            ( sp_20_table_output_step_dwid, 'delinquent_days', 'delinquent_days', 56, false ),
            ( sp_20_table_output_step_dwid, 'delinquent_history', 'delinquent_history', 57, false ),
            ( sp_20_table_output_step_dwid, 'doc_level_code', 'doc_level_code', 58, false ),
            ( sp_20_table_output_step_dwid, 'document_set_code', 'document_set_code', 59, false ),
            ( sp_20_table_output_step_dwid, 'coll_exist_status_code', 'coll_exist_status_code', 60, false ),
            ( sp_20_table_output_step_dwid, 'expire_date', 'expire_date', 61, false ),
            ( sp_20_table_output_step_dwid, 'fico_score', 'fico_score', 62, false ),
            ( sp_20_table_output_step_dwid, 'first_rate_change_date', 'first_rate_change_date', 63, false ),
            ( sp_20_table_output_step_dwid, 'firstdue', 'firstdue', 64, false ),
            ( sp_20_table_output_step_dwid, 'coll_home_track_location_code', 'coll_home_track_location_code', 65, false ),
            ( sp_20_table_output_step_dwid, 'instrument_num', 'instrument_num', 66, false ),
            ( sp_20_table_output_step_dwid, 'inv_commit_expire_date', 'inv_commit_expire_date', 67, false ),
            ( sp_20_table_output_step_dwid, 'inv_commit_number', 'inv_commit_number', 68, false ),
            ( sp_20_table_output_step_dwid, 'inv_commit_price', 'inv_commit_price', 69, false ),
            ( sp_20_table_output_step_dwid, 'investor_code', 'investor_code', 70, false ),
            ( sp_20_table_output_step_dwid, 'investor_id', 'investor_id', 71, false ),
            ( sp_20_table_output_step_dwid, 'coll_is_active', 'coll_is_active', 72, false ),
            ( sp_20_table_output_step_dwid, 'last_paid_date', 'last_paid_date', 73, false ),
            ( sp_20_table_output_step_dwid, 'lien_position', 'lien_position', 74, false ),
            ( sp_20_table_output_step_dwid, 'lifecap', 'lifecap', 75, false ),
            ( sp_20_table_output_step_dwid, 'coll_major_count', 'coll_major_count', 76, false ),
            ( sp_20_table_output_step_dwid, 'market_value', 'market_value', 77, false ),
            ( sp_20_table_output_step_dwid, 'market_value_date', 'market_value_date', 78, false ),
            ( sp_20_table_output_step_dwid, 'market_value_expire_date', 'market_value_expire_date', 79, false ),
            ( sp_20_table_output_step_dwid, 'market_value_override_flag', 'market_value_override_flag', 80, false ),
            ( sp_20_table_output_step_dwid, 'maturity', 'maturity', 81, false ),
            ( sp_20_table_output_step_dwid, 'mers_min', 'mers_min', 82, false ),
            ( sp_20_table_output_step_dwid, 'coll_minor_count', 'coll_minor_count', 83, false ),
            ( sp_20_table_output_step_dwid, 'months_to_roll', 'months_to_roll', 84, false ),
            ( sp_20_table_output_step_dwid, 'next_due_date', 'next_due_date', 85, false ),
            ( sp_20_table_output_step_dwid, 'next_inspection_date', 'next_inspection_date', 86, false ),
            ( sp_20_table_output_step_dwid, 'next_rate_change_date', 'next_rate_change_date', 87, false ),
            ( sp_20_table_output_step_dwid, 'occupancy_code', 'occupancy_code', 88, false ),
            ( sp_20_table_output_step_dwid, 'occupancy_ratio', 'occupancy_ratio', 89, false ),
            ( sp_20_table_output_step_dwid, 'orig_appraised_value', 'orig_appraised_value', 90, false ),
            ( sp_20_table_output_step_dwid, 'orig_pledge_date', 'orig_pledge_date', 91, false ),
            ( sp_20_table_output_step_dwid, 'orig_rate', 'orig_rate', 92, false ),
            ( sp_20_table_output_step_dwid, 'orig_upb', 'orig_upb', 93, false ),
            ( sp_20_table_output_step_dwid, 'original_cltv', 'original_cltv', 94, false ),
            ( sp_20_table_output_step_dwid, 'original_ltv', 'original_ltv', 95, false ),
            ( sp_20_table_output_step_dwid, 'original_term', 'original_term', 96, false ),
            ( sp_20_table_output_step_dwid, 'origination_date', 'origination_date', 97, false ),
            ( sp_20_table_output_step_dwid, 'originator_code', 'originator_code', 98, false ),
            ( sp_20_table_output_step_dwid, 'p_i', 'p_i', 99, false ),
            ( sp_20_table_output_step_dwid, 'paid_to_date', 'paid_to_date', 100, false ),
            ( sp_20_table_output_step_dwid, 'pool_id', 'pool_id', 101, false ),
            ( sp_20_table_output_step_dwid, 'prepay_penalty_flag', 'prepay_penalty_flag', 102, false ),
            ( sp_20_table_output_step_dwid, 'prepay_penalty_pct', 'prepay_penalty_pct', 103, false ),
            ( sp_20_table_output_step_dwid, 'product_code', 'product_code', 104, false ),
            ( sp_20_table_output_step_dwid, 'production_stage_code', 'production_stage_code', 105, false ),
            ( sp_20_table_output_step_dwid, 'production_stage_date', 'production_stage_date', 106, false ),
            ( sp_20_table_output_step_dwid, 'property_type_code', 'property_type_code', 107, false ),
            ( sp_20_table_output_step_dwid, 'purpose_code', 'purpose_code', 108, false ),
            ( sp_20_table_output_step_dwid, 'rate_change_frequency', 'rate_change_frequency', 109, false ),
            ( sp_20_table_output_step_dwid, 'record_book', 'record_book', 110, false ),
            ( sp_20_table_output_step_dwid, 'record_page', 'record_page', 111, false ),
            ( sp_20_table_output_step_dwid, 'recorded', 'recorded', 112, false ),
            ( sp_20_table_output_step_dwid, 'coll_release_request_identifier', 'coll_release_request_identifier', 113, false ),
            ( sp_20_table_output_step_dwid, 'scheduled_upb', 'scheduled_upb', 114, false ),
            ( sp_20_table_output_step_dwid, 'coll_shipment_id', 'coll_shipment_id', 115, false ),
            ( sp_20_table_output_step_dwid, 'short_name', 'short_name', 116, false ),
            ( sp_20_table_output_step_dwid, 'state', 'state', 118, false ),
            ( sp_20_table_output_step_dwid, 'tenant_num', 'tenant_num', 119, false ),
            ( sp_20_table_output_step_dwid, 'tmo_ratio', 'tmo_ratio', 120, false ),
            ( sp_20_table_output_step_dwid, 'track_item_type_code', 'track_item_type_code', 121, false ),
            ( sp_20_table_output_step_dwid, 'coll_track_location_code', 'coll_track_location_code', 122, false ),
            ( sp_20_table_output_step_dwid, 'udf_char_1', 'udf_char_1', 123, false ),
            ( sp_20_table_output_step_dwid, 'udf_char_2', 'udf_char_2', 124, false ),
            ( sp_20_table_output_step_dwid, 'udf_date_1', 'udf_date_1', 125, false ),
            ( sp_20_table_output_step_dwid, 'udf_date_2', 'udf_date_2', 126, false ),
            ( sp_20_table_output_step_dwid, 'udf_dollar_1', 'udf_dollar_1', 127, false ),
            ( sp_20_table_output_step_dwid, 'udf_dollar_2', 'udf_dollar_2', 128, false ),
            ( sp_20_table_output_step_dwid, 'udf_int_1', 'udf_int_1', 129, false ),
            ( sp_20_table_output_step_dwid, 'udf_int_2', 'udf_int_2', 130, false ),
            ( sp_20_table_output_step_dwid, 'udf_pct_1', 'udf_pct_1', 131, false ),
            ( sp_20_table_output_step_dwid, 'udf_pct_2', 'udf_pct_2', 132, false ),
            ( sp_20_table_output_step_dwid, 'units', 'units', 133, false ),
            ( sp_20_table_output_step_dwid, 'zip', 'zip', 134, false ),
            ( sp_20_table_output_step_dwid, 'warehouse_aging_date', 'warehouse_aging_date', 135, false ),
            ( sp_20_table_output_step_dwid, 'active_flag', 'active_flag', 136, false ),
            ( sp_20_table_output_step_dwid, 'doctype_code', 'doctype_code', 137, false ),
            ( sp_20_table_output_step_dwid, 'document_descr', 'document_descr', 138, false ),
            ( sp_20_table_output_step_dwid, 'document_sak', 'document_sak', 139, false ),
            ( sp_20_table_output_step_dwid, 'doc_exist_status_code', 'doc_exist_status_code', 140, false ),
            ( sp_20_table_output_step_dwid, 'doc_home_track_location_code', 'doc_home_track_location_code', 141, false ),
            ( sp_20_table_output_step_dwid, 'doc_major_count', 'doc_major_count', 142, false ),
            ( sp_20_table_output_step_dwid, 'doc_minor_count', 'doc_minor_count', 143, false ),
            ( sp_20_table_output_step_dwid, 'doc_release_request_identifier', 'doc_release_request_identifier', 144, false ),
            ( sp_20_table_output_step_dwid, 'doc_track_location_code', 'doc_track_location_code', 145, false ),
            ( sp_20_table_output_step_dwid, 'cleared_flag', 'cleared_flag', 146, false ),
            ( sp_20_table_output_step_dwid, 'fatal_error_flag', 'fatal_error_flag', 147, false ),
            ( sp_20_table_output_step_dwid, 'docex_notation', 'docex_notation', 148, false ),
            ( sp_20_table_output_step_dwid, 'opendate', 'opendate', 149, false ),
            ( sp_20_table_output_step_dwid, 'question_code', 'question_code', 150, false ),
            ( sp_20_table_output_step_dwid, 'updated_by', 'updated_by', 151, false ),
            ( sp_20_table_output_step_dwid, 'collmemo_active_flag', 'collmemo_active_flag', 152, false ),
            ( sp_20_table_output_step_dwid, 'collmemo_memo_date', 'collmemo_memo_date', 153, false ),
            ( sp_20_table_output_step_dwid, 'collmemo_memo_sak', 'collmemo_memo_sak', 154, false ),
            ( sp_20_table_output_step_dwid, 'collmemo_memo_subject', 'collmemo_memo_subject', 155, false ),
            ( sp_20_table_output_step_dwid, 'collmemo_memo_text', 'collmemo_memo_text', 156, false ),
            ( sp_20_table_output_step_dwid, 'collmemo_memo_type', 'collmemo_memo_type', 157, false ),
            ( sp_20_table_output_step_dwid, 'collmemo_posted_by', 'collmemo_posted_by', 158, false ),
            ( sp_20_table_output_step_dwid, 'collmemo_private_flag', 'collmemo_private_flag', 159, false ),
            ( sp_20_table_output_step_dwid, 'docmemo_active_flag', 'docmemo_active_flag', 160, false ),
            ( sp_20_table_output_step_dwid, 'docmemo_memo_date', 'docmemo_memo_date', 161, false ),
            ( sp_20_table_output_step_dwid, 'docmemo_memo_sak', 'docmemo_memo_sak', 162, false ),
            ( sp_20_table_output_step_dwid, 'docmemo_memo_subject', 'docmemo_memo_subject', 163, false ),
            ( sp_20_table_output_step_dwid, 'docmemo_memo_text', 'docmemo_memo_text', 164, false ),
            ( sp_20_table_output_step_dwid, 'docmemo_memo_type', 'docmemo_memo_type', 165, false ),
            ( sp_20_table_output_step_dwid, 'docmemo_posted_by', 'docmemo_posted_by', 166, false ),
            ( sp_20_table_output_step_dwid, 'docmemo_private_flag', 'docmemo_private_flag', 167, false ),
            ( sp_20_table_output_step_dwid, 'business_tran_log_sak', 'business_tran_log_sak', 168, false ),
            ( sp_20_table_output_step_dwid, 'carrier_code', 'carrier_code', 169, false ),
            ( sp_20_table_output_step_dwid, 'carrier_id', 'carrier_id', 170, false ),
            ( sp_20_table_output_step_dwid, 'certification_code', 'certification_code', 171, false ),
            ( sp_20_table_output_step_dwid, 'destination_type_flag', 'destination_type_flag', 172, false ),
            ( sp_20_table_output_step_dwid, 'effective_date', 'effective_date', 173, false ),
            ( sp_20_table_output_step_dwid, 'deposit_date', 'deposit_date', 174, false ),
            ( sp_20_table_output_step_dwid, 'release_date', 'release_date', 175, false ),
            ( sp_20_table_output_step_dwid, 'effective_rate', 'effective_rate', 176, false ),
            ( sp_20_table_output_step_dwid, 'handling_option', 'handling_option', 177, false ),
            ( sp_20_table_output_step_dwid, 'btl_investor_code', 'btl_investor_code', 178, false ),
            ( sp_20_table_output_step_dwid, 'btl_notation', 'btl_notation', 179, false ),
            ( sp_20_table_output_step_dwid, 'posted_by', 'posted_by', 180, false ),
            ( sp_20_table_output_step_dwid, 'release_code', 'release_code', 181, false ),
            ( sp_20_table_output_step_dwid, 'release_request_identifier', 'release_request_identifier', 182, false ),
            ( sp_20_table_output_step_dwid, 'request_date', 'request_date', 183, false ),
            ( sp_20_table_output_step_dwid, 'requestor', 'requestor', 184, false ),
            ( sp_20_table_output_step_dwid, 'return_due_date', 'return_due_date', 185, false ),
            ( sp_20_table_output_step_dwid, 'reversal_method', 'reversal_method', 186, false ),
            ( sp_20_table_output_step_dwid, 'shipment_id', 'shipment_id', 187, false ),
            ( sp_20_table_output_step_dwid, 'task_type_code', 'task_type_code', 188, false ),
            ( sp_20_table_output_step_dwid, 'task_type_code_rel', 'task_type_code_rel', 189, false ),
            ( sp_20_table_output_step_dwid, 'btl_track_location_code', 'btl_track_location_code', 190, false ),
            ( sp_20_table_output_step_dwid, 'transtype', 'transtype', 191, false ),
            ( sp_20_table_output_step_dwid, 'workbin_code', 'workbin_code', 192, false ),
            ( sp_20_table_output_step_dwid, 'funding_id', 'funding_id', 193, false ),
            ( sp_20_table_output_step_dwid, 'funding_date', 'funding_date', 194, false ),
            ( sp_20_table_output_step_dwid, 'sched_funding_date', 'sched_funding_date', 195, false ),
            ( sp_20_table_output_step_dwid, 'doctype_descr', 'doctype_descr', 196, false ),
            ( sp_20_table_output_step_dwid, 'question_descr', 'question_descr', 197, false ),
            ( sp_20_table_output_step_dwid, 'expires', 'expires', 198, false ),
            ( sp_20_table_output_step_dwid, 'loan_is_active', 'loan_is_active', 199, false ),
            ( sp_20_table_output_step_dwid, 'lender_sak', 'lender_sak', 200, false ),
            ( sp_20_table_output_step_dwid, 'loan_descr', 'loan_descr', 201, false ),
            ( sp_20_table_output_step_dwid, 'loan_id', 'loan_id', 202, false ),
            ( sp_20_table_output_step_dwid, 'loan_inception', 'loan_inception', 203, false ),
            ( sp_20_table_output_step_dwid, 'loan_sak', 'loan_sak', 204, false ),
            ( sp_20_table_output_step_dwid, 'max_balance_amt', 'max_balance_amt', 205, false ),
            ( sp_20_table_output_step_dwid, 'max_balance_flag', 'max_balance_flag', 206, false ),
            ( sp_20_table_output_step_dwid, 'max_balance_pct', 'max_balance_pct', 207, false ),
            ( sp_20_table_output_step_dwid, 'orig_prin_balance', 'orig_prin_balance', 208, false ),
            ( sp_20_table_output_step_dwid, 'payoff_date', 'payoff_date', 209, false ),
            ( sp_20_table_output_step_dwid, 'pricing_flag', 'pricing_flag', 210, false ),
            ( sp_20_table_output_step_dwid, 'pricing_rule_code', 'pricing_rule_code', 211, false ),
            ( sp_20_table_output_step_dwid, 'pricing_rule_flag', 'pricing_rule_flag', 212, false ),
            ( sp_20_table_output_step_dwid, 'sequence', 'sequence', 213, false ),
            ( sp_20_table_output_step_dwid, 'curr_prin_balance', 'curr_prin_balance', 214, false ),
            ( sp_20_table_output_step_dwid, 'curr_amount', 'curr_amount', 215, false ),
            ( sp_20_table_output_step_dwid, 'curr_interest', 'curr_interest', 216, false ),
            ( sp_20_table_output_step_dwid, 'curr_fee', 'curr_fee', 217, false ),
            ( sp_20_table_output_step_dwid, 'curr_cof', 'curr_cof', 218, false ),
            ( sp_20_table_output_step_dwid, 'curr_unapplied', 'curr_unapplied', 219, false ),
            ( sp_20_table_output_step_dwid, 'redemptive_value', 'redemptive_value', 220, false ),
            ( sp_20_table_output_step_dwid, 'lender_code', 'lender_code', 221, false ),
            ( sp_20_table_output_step_dwid, 'lender_descr', 'lender_descr', 222, false ),
            ( sp_20_table_output_step_dwid, 'cdays_aging', 'cdays_aging', 223, false ),
            ( sp_20_table_output_step_dwid, 'bdays_aging', 'bdays_aging', 224, false ),
            ( sp_20_table_output_step_dwid, 'coll_group_code', 'coll_group_code', 225, false ),
            ( sp_20_table_output_step_dwid, 'member_sak', 'member_sak', 226, false ),
            ( sp_20_table_output_step_dwid, 'query_stmt_descr', 'query_stmt_descr', 227, false ),
            ( sp_20_table_output_step_dwid, 'cleared_docex_notation', 'cleared_docex_notation', 228, false ),
            ( sp_20_table_output_step_dwid, 'cleared_opendate', 'cleared_opendate', 229, false ),
            ( sp_20_table_output_step_dwid, 'cleared_question_code', 'cleared_question_code', 230, false ),
            ( sp_20_table_output_step_dwid, 'cleared_question_descr', 'cleared_question_descr', 231, false ),
            ( sp_20_table_output_step_dwid, 'takeout_value', 'takeout_value', 232, false ),
            ( sp_20_table_output_step_dwid, 'collateral_deficit', 'collateral_deficit', 233, false ),
            ( sp_20_table_output_step_dwid, 'curr_cltv', 'curr_cltv', 234, false ),
            ( sp_20_table_output_step_dwid, 'curr_ltv', 'curr_ltv', 235, false ),
            ( sp_20_table_output_step_dwid, 'customer_code_list', 'customer_code_list', 236, false ),
            ( sp_20_table_output_step_dwid, 'customer_account_key_list', 'customer_account_key_list', 237, false ),
            ( sp_20_table_output_step_dwid, 'exist_status_code_list', 'exist_status_code_list', 238, false ),
            ( sp_20_table_output_step_dwid, 'date_analysis', 'date_analysis', 239, false ),
            ( sp_20_table_output_step_dwid, 'coll_sel_opt', 'coll_sel_opt', 240, false ),
            ( sp_20_table_output_step_dwid, 'begin_date', 'begin_date', 241, false ),
            ( sp_20_table_output_step_dwid, 'end_date', 'end_date', 242, false ),
            ( sp_20_table_output_step_dwid, 'print_memos', 'print_memos', 243, false ),
            ( sp_20_table_output_step_dwid, 'production_stage_code_list', 'production_stage_code_list', 244, false ),
            ( sp_20_table_output_step_dwid, 'print_docs', 'print_docs', 245, false ),
            ( sp_20_table_output_step_dwid, 'print_exceptions', 'print_exceptions', 246, false ),
            ( sp_20_table_output_step_dwid, 'sort_option', 'sort_option', 247, false ),
            ( sp_20_table_output_step_dwid, 'format_option', 'format_option', 248, false )
;

-- SP-20 edw field definition insert
    INSERT INTO mdi.edw_field_definition (edw_table_definition_dwid, field_name, key_field_flag, data_type)
    VALUES  (sp_20_edw_table_definition_dwid, 'etl_batch_id', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'data_source_dwid', FALSE, 'BIGINT'),
            (sp_20_edw_table_definition_dwid, 'input_filename', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'rowtype', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'customer_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'customer_name', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'account_sak', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'customer_account_key', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'renewal_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'account_descr', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'cost_center', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'orig_advance_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'acquisition_cost', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'address', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'amortization_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'anncap', FALSE, 'NUMERIC(15,9)'),
            (sp_20_edw_table_definition_dwid, 'armadj', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'armconv', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'armindex', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'armmargin', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'armround', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'armteaser', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'as_of_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'asset_class_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'auction_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'balloon_flag', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'bar_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'borr_1_first_name', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'borr_1_last_name', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'borr_2_first_name', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'borr_2_last_name', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'city', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'closing_agent_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'coll_closed_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'coll_valuation_set_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'coll_value_expire_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'coll_value_recalc_flag', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'collateral_key', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'collateral_key2', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'collateral_key3', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'collateral_sak', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'collateral_value', FALSE, 'NUMERIC(21,3)'),
            (sp_20_edw_table_definition_dwid, 'collateral_value_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'collateral_value_flag', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'collgroup', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'construction_cost', FALSE, 'NUMERIC(21,3)'),
            (sp_20_edw_table_definition_dwid, 'credit_grade_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'curr_appraised_value', FALSE, 'NUMERIC(21,3)'),
            (sp_20_edw_table_definition_dwid, 'curr_payment', FALSE, 'NUMERIC(21,3)'),
            (sp_20_edw_table_definition_dwid, 'curr_pledge_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'curr_rate', FALSE, 'NUMERIC(15,9)'),
            (sp_20_edw_table_definition_dwid, 'curr_upb', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'custodian_sak', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'customer_sak', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'debt_service_ratio', FALSE, 'NUMERIC(15,9)'),
            (sp_20_edw_table_definition_dwid, 'delinquent_days', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'delinquent_history', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'doc_level_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'document_set_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'coll_exist_status_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'expire_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'fico_score', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'first_rate_change_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'firstdue', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'coll_home_track_location_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'instrument_num', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'inv_commit_expire_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'inv_commit_number', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'inv_commit_price', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'investor_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'investor_id', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'coll_is_active', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'last_paid_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'lien_position', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'lifecap', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'coll_major_count', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'market_value', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'market_value_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'market_value_expire_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'market_value_override_flag', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'maturity', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'mers_min', FALSE, 'BIGINT'),
            (sp_20_edw_table_definition_dwid, 'coll_minor_count', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'months_to_roll', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'next_due_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'next_inspection_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'next_rate_change_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'occupancy_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'occupancy_ratio', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'orig_appraised_value', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'orig_pledge_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'orig_rate', FALSE, 'NUMERIC(15,9)'),
            (sp_20_edw_table_definition_dwid, 'orig_upb', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'original_cltv', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'original_ltv', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'original_term', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'origination_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'originator_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'p_i', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'paid_to_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'pool_id', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'prepay_penalty_flag', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'prepay_penalty_pct', FALSE, 'NUMERIC(15,9)'),
            (sp_20_edw_table_definition_dwid, 'product_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'production_stage_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'production_stage_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'property_type_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'purpose_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'rate_change_frequency', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'record_book', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'record_page', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'recorded', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'coll_release_request_identifier', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'scheduled_upb', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'coll_shipment_id', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'short_name', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'state', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'tenant_num', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'tmo_ratio', FALSE, 'NUMERIC(15,9)'),
            (sp_20_edw_table_definition_dwid, 'track_item_type_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'coll_track_location_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'udf_char_1', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'udf_char_2', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'udf_date_1', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'udf_date_2', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'udf_dollar_1', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'udf_dollar_2', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'udf_int_1', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'udf_int_2', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'udf_pct_1', FALSE, 'NUMERIC(15,9)'),
            (sp_20_edw_table_definition_dwid, 'udf_pct_2', FALSE, 'NUMERIC(15,9)'),
            (sp_20_edw_table_definition_dwid, 'units', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'zip', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'warehouse_aging_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'active_flag', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'doctype_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'document_descr', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'document_sak', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'doc_exist_status_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'doc_home_track_location_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'doc_major_count', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'doc_minor_count', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'doc_release_request_identifier', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'doc_track_location_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'cleared_flag', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'fatal_error_flag', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'docex_notation', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'opendate', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'question_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'updated_by', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'collmemo_active_flag', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'collmemo_memo_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'collmemo_memo_sak', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'collmemo_memo_subject', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'collmemo_memo_text', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'collmemo_memo_type', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'collmemo_posted_by', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'collmemo_private_flag', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'docmemo_active_flag', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'docmemo_memo_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'docmemo_memo_sak', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'docmemo_memo_subject', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'docmemo_memo_text', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'docmemo_memo_type', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'docmemo_posted_by', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'docmemo_private_flag', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'business_tran_log_sak', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'carrier_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'carrier_id', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'certification_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'destination_type_flag', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'effective_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'deposit_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'release_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'effective_rate', FALSE, 'NUMERIC(15,9)'),
            (sp_20_edw_table_definition_dwid, 'handling_option', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'btl_investor_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'btl_notation', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'posted_by', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'release_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'release_request_identifier', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'request_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'requestor', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'return_due_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'reversal_method', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'shipment_id', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'task_type_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'task_type_code_rel', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'btl_track_location_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'transtype', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'workbin_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'funding_id', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'funding_date', FALSE, 'DATETIME'),
            (sp_20_edw_table_definition_dwid, 'sched_funding_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'doctype_descr', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'question_descr', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'expires', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'loan_is_active', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'lender_sak', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'loan_descr', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'loan_id', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'loan_inception', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'loan_sak', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'max_balance_amt', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'max_balance_flag', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'max_balance_pct', FALSE, 'NUMERIC(15,9)'),
            (sp_20_edw_table_definition_dwid, 'orig_prin_balance', FALSE, 'NUMERIC(21,3)'),
            (sp_20_edw_table_definition_dwid, 'payoff_date', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'pricing_flag', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'pricing_rule_code', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'pricing_rule_flag', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'sequence', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'curr_prin_balance', FALSE, 'NUMERIC(21,3)'),
            (sp_20_edw_table_definition_dwid, 'curr_amount', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'curr_interest', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'curr_fee', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'curr_cof', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'curr_unapplied', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'redemptive_value', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'lender_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'lender_descr', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'cdays_aging', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'bdays_aging', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'coll_group_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'member_sak', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'query_stmt_descr', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'cleared_docex_notation', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'cleared_opendate', FALSE, 'DATE'),
            (sp_20_edw_table_definition_dwid, 'cleared_question_code', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'cleared_question_descr', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'takeout_value', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'collateral_deficit', FALSE, 'NUMERIC(21,3)'),
            (sp_20_edw_table_definition_dwid, 'curr_cltv', FALSE, 'NUMERIC(15,9)'),
            (sp_20_edw_table_definition_dwid, 'curr_ltv', FALSE, 'NUMERIC(15,9)'),
            (sp_20_edw_table_definition_dwid, 'customer_code_list', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'customer_account_key_list', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'exist_status_code_list', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'date_analysis', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'coll_sel_opt', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'begin_date', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'end_date', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'print_memos', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'production_stage_code_list', FALSE, 'TEXT'),
            (sp_20_edw_table_definition_dwid, 'print_docs', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'print_exceptions', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'sort_option', FALSE, 'INTEGER'),
            (sp_20_edw_table_definition_dwid, 'format_option', FALSE, 'INTEGER')
;


END $$;