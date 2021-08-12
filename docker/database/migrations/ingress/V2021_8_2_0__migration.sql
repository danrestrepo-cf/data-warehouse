--
-- EDW - DMI Passport data load (SP-7) (https://app.asana.com/0/0/1182841661698329 )
--

CREATE TABLE dmi.passport
(
    etl_batch_id TEXT,
    data_source_dwid BIGINT,
    input_filename TEXT,
    loan_number TEXT,
    old_loan_number TEXT,
    new_servicer_loan_number TEXT,
    user_03_position_field_3a TEXT,
    first_due_date DATE,
    loan_closing_date DATE,
    loan_purpose_code TEXT,
    loan_purpose_code_description TEXT,
    note_date DATE,
    acquisition_date DATE,
    original_interest_rate NUMERIC(15, 9),
    original_loan_term INTEGER,
    original_mortgage_amount NUMERIC(21, 3),
    original_p_and_i_amount NUMERIC(21, 3),
    original_property_value_amount NUMERIC(21, 3),
    original_second_interest_rate NUMERIC(15, 9),
    original_second_loan_term INTEGER,
    original_second_mtg_amount NUMERIC(21, 3),
    original_second_p_and_i NUMERIC(21, 3),
    original_loan_to_value_ratio NUMERIC(15, 9),
    annual_interest_rate NUMERIC(15, 9),
    arm_indicator TEXT,
    drafting_indicator TEXT,
    draft_option_code TEXT,
    draft_delay_days_quantity INTEGER,
    billing_mode TEXT,
    coupon_tape_date DATE,
    coupon_bill_last_create_date DATE,
    def_int_balance NUMERIC(21, 3),
    distribution_type TEXT,
    loan_to_value_ratio NUMERIC(15, 9),
    first_p_and_i_amount NUMERIC(21, 3),
    first_principal_balance NUMERIC(21, 3),
    el_status_indicator TEXT,
    interest_only_expire_date DATE,
    interest_only_loan_indicator TEXT,
    qualified_mortgage_code TEXT,
    qualified_mortgage_code_description TEXT,
    higher_priced_indicator TEXT,
    higher_priced_indicator_description TEXT,
    high_cost_type TEXT,
    high_cost_type_description TEXT,
    escrow_waiver_code TEXT,
    escrow_waiver_code_description TEXT,
    escrow_waiver_date DATE,
    investor_loan_number TEXT,
    investor_id TEXT,
    category_code TEXT,
    first_service_fee_rate NUMERIC(15, 9),
    pool_number TEXT,
    pool_class_code TEXT,
    pool_contract_number TEXT,
    gse_code TEXT,
    gse_code_description TEXT,
    hi_type TEXT,
    hi_type_description TEXT,
    lo_type TEXT,
    lo_type_description TEXT,
    development_type TEXT,
    development_type_description TEXT,
    second_hi_type TEXT,
    bl_balloon_status_code TEXT,
    bl_balloon_status_code_description TEXT,
    balloon_status_code TEXT,
    balloon_status_code_description TEXT,
    loan_matures_date DATE,
    loan_term INTEGER,
    remaining_term INTEGER,
    man_code TEXT,
    man_code_description TEXT,
    mers_id TEXT,
    mers_original_mortgagee_ind TEXT,
    mers_original_mortgagee_ind_description TEXT,
    mers_registration_status_code TEXT,
    mers_registration_date DATE,
    mers_id_number_status_code TEXT,
    mers_assigned_date DATE,
    next_payment_due_date DATE,
    last_full_payment_date DATE,
    due_date_day_portion_parsed DATE,
    payment_period INTEGER,
    payment_option_code TEXT,
    payment_option_code_description TEXT,
    suspense_balance NUMERIC(21, 3),
    nsf_fee_balance NUMERIC(21, 3),
    total_monthly_payment NUMERIC(21, 3),
    billing_name TEXT,
    billing_address_line_2 TEXT,
    co_mortgagor_name TEXT,
    billing_address_line_3 TEXT,
    billing_address_line_4 TEXT,
    billing_city_name TEXT,
    foreign_address_indicator TEXT,
    billing_state TEXT,
    billing_zip_code TEXT,
    telephone_number TEXT,
    telephone_code TEXT,
    mortgagor_prefered_lang_code TEXT,
    second_telephone_number TEXT,
    sec_mortgagor_ss_number TEXT,
    sec_co_mortgagor_ss_number TEXT,
    property_street_address TEXT,
    property_unit_number TEXT,
    city_name TEXT,
    property_alpha_state_code TEXT,
    property_zip_code TEXT,
    county_code TEXT,
    fips_county_code TEXT,
    fips_state_code TEXT,
    occupancy_code TEXT,
    occupancy_code_description TEXT,
    property_state_code TEXT,
    number_of_units TEXT,
    appraisal_date DATE,
    property_value_amount INTEGER,
    property_type TEXT,
    property_type_fnma_code TEXT,
    property_type_fnma_code_description TEXT,
    occupancy_current_status_code TEXT,
    occupancy_current_status_code_description TEXT,
    ownership_type TEXT,
    ownership_type_description TEXT,
    flood_community_start_date DATE,
    flood_program_type TEXT,
    flood_loma_revision_code TEXT,
    flood_loma_determination_date DATE,
    flood_contract_type TEXT,
    flood_community_number TEXT,
    flood_panel_number TEXT,
    flood_zone_position_1 TEXT,
    flood_zone_position_2_and_3 TEXT,
    flood_suffix_number TEXT,
    flood_zone_partial_indicator TEXT,
    flood_firm_effective_date DATE,
    flood_mapping_company_id TEXT,
    flood_certification_number TEXT,
    grace_days INTEGER,
    late_charge_amount NUMERIC(21, 3),
    late_charge_code TEXT,
    late_charge_code_description TEXT,
    late_charge_factor NUMERIC(15, 9),
    maximum_late_charge_amount NUMERIC(21, 3),
    minimum_late_charge_amount NUMERIC(21, 3),
    delinquency_class_code TEXT,
    delinquency_class_code_description TEXT,
    secondary_phone_code TEXT,
    secondary_phone_number TEXT,
    escrow_advance_balance INTEGER,
    escrow_balance NUMERIC(21, 3),
    escrow_replace_resrv_balance NUMERIC(21, 3),
    hazard_ins_monthly_amount NUMERIC(21, 3),
    replace_reserve_amount NUMERIC(21, 3),
    restricted_escrow_balance NUMERIC(21, 3),
    t_and_i_monthly_amount NUMERIC(21, 3),
    a_and_h_premium_amount NUMERIC(21, 3),
    life_premium_amount NUMERIC(21, 3),
    interest_paid_through_date DATE,
    ln_mod_code TEXT,
    ln_mod_code_description TEXT,
    last_analysis_date DATE,
    last_analysis_effective_date DATE,
    last_analysis_os_spread_months INTEGER,
    mi_monthly_amount NUMERIC(21, 3),
    mi_term INTEGER,
    mi_disbursement_amount NUMERIC(21, 3),
    mi_disbursement_due_date DATE,
    mi_mid_point_date DATE,
    mi_termination_date DATE,
    mi_cancellation_date DATE,
    mi_request_to_cancel_date DATE,
    pmi_cancellation_reason_code TEXT,
    pmi_cancellation_reason_code_description TEXT,
    va_loan_number TEXT,
    va_lin_check_digit_number TEXT,
    recover_corp_advance_balance NUMERIC(21, 3),
    third_party_recoverable_ca_bal NUMERIC(21, 3),
    non_rec_corp_advance_balance NUMERIC(21, 3),
    second_principal_balance NUMERIC(21, 3),
    actual_deferred_balance NUMERIC(21, 3),
    ytd_principal_paid_amount NUMERIC(21, 3),
    ytd_interest_amount NUMERIC(21, 3),
    ytd_tax_amount NUMERIC(21, 3),
    ytd_ioe_amount NUMERIC(21, 3),
    ytd_hazard_amt NUMERIC(21, 3),
    ytd_lien_amount NUMERIC(21, 3),
    ytd_mip_amount NUMERIC(21, 3),
    ytd_nsf_total NUMERIC(21, 3),
    ytd_restricted_ioe_amount NUMERIC(21, 3),
    ytd_late_charge_amount NUMERIC(21, 3),
    prepay_penalty_indicator TEXT,
    ppp_header_id TEXT,
    ppp_header_name TEXT,
    user_05_position_field_2a TEXT,
    purchase_price NUMERIC(21, 3),
    interest_calc_option_code TEXT,
    the_360_365_factor TEXT,
    the_360_365_factor_description TEXT,
    assumption_code TEXT,
    assumption_code_description TEXT,
    bill_code TEXT,
    bill_code_description TEXT,
    rhs_borrower_id TEXT,
    opt_ins_plan_id TEXT,
    certificate_number_1 TEXT,
    certificate_number_2 TEXT,
    opt_ins_disbursement_amount NUMERIC(21, 3),
    opt_ins_disbursement_due_date DATE,
    imminent_default_fico_score INTEGER,
    imminent_default_fico_date DATE,
    points_paid_by_borrower NUMERIC(21, 3),
    third_party_draft_code TEXT,
    third_party_draft_code_description TEXT,
    employee_code TEXT,
    zone TEXT,
    sec_mortgagor_birth_date DATE,
    sec_co_mortgagor_birth_date DATE,
    email_address TEXT,
    co_mortgagor_email_address TEXT,
    servicing_sold_id TEXT
);
