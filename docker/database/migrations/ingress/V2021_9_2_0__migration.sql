--
-- EDW - DMI Passport data load (SP-7) (https://app.asana.com/0/0/1182841661698329 )
--

CREATE TABLE dmi.passport
(
    etl_batch_id TEXT,
    data_source_dwid TEXT,
    input_filename TEXT,
    loan_number TEXT,
    old_loan_number TEXT,
    new_servicer_loan_number TEXT,
    user_03_position_field_3a TEXT,
    first_due_date TEXT,
    loan_closing_date TEXT,
    loan_purpose_code TEXT,
    loan_purpose_code_description TEXT,
    note_date TEXT,
    acquisition_date TEXT,
    original_interest_rate TEXT,
    original_loan_term TEXT,
    original_mortgage_amount TEXT,
    original_p_and_i_amount TEXT,
    original_property_value_amount TEXT,
    original_second_interest_rate TEXT,
    original_second_loan_term TEXT,
    original_second_mtg_amount TEXT,
    original_second_p_and_i TEXT,
    original_loan_to_value_ratio TEXT,
    annual_interest_rate TEXT,
    arm_indicator TEXT,
    drafting_indicator TEXT,
    draft_option_code TEXT,
    draft_delay_days_quantity TEXT,
    billing_mode TEXT,
    coupon_tape_date TEXT,
    coupon_bill_last_create_date TEXT,
    def_int_balance TEXT,
    distribution_type TEXT,
    loan_to_value_ratio TEXT,
    first_p_and_i_amount TEXT,
    first_principal_balance TEXT,
    el_status_indicator TEXT,
    interest_only_expire_date TEXT,
    interest_only_loan_indicator TEXT,
    qualified_mortgage_code TEXT,
    qualified_mortgage_code_description TEXT,
    higher_priced_indicator TEXT,
    higher_priced_indicator_description TEXT,
    high_cost_type TEXT,
    high_cost_type_description TEXT,
    escrow_waiver_code TEXT,
    escrow_waiver_code_description TEXT,
    escrow_waiver_date TEXT,
    investor_loan_number TEXT,
    investor_id TEXT,
    category_code TEXT,
    first_service_fee_rate TEXT,
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
    loan_matures_date TEXT,
    loan_term TEXT,
    remaining_term TEXT,
    man_code TEXT,
    man_code_description TEXT,
    mers_id TEXT,
    mers_original_mortgagee_ind TEXT,
    mers_original_mortgagee_ind_description TEXT,
    mers_registration_status_code TEXT,
    mers_registration_date TEXT,
    mers_id_number_status_code TEXT,
    mers_assigned_date TEXT,
    next_payment_due_date TEXT,
    last_full_payment_date TEXT,
    due_date_day_portion_parsed TEXT,
    payment_period TEXT,
    payment_option_code TEXT,
    payment_option_code_description TEXT,
    suspense_balance TEXT,
    nsf_fee_balance TEXT,
    total_monthly_payment TEXT,
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
    appraisal_date TEXT,
    property_value_amount TEXT,
    property_type TEXT,
    property_type_fnma_code TEXT,
    property_type_fnma_code_description TEXT,
    occupancy_current_status_code TEXT,
    occupancy_current_status_code_description TEXT,
    ownership_type TEXT,
    ownership_type_description TEXT,
    flood_community_start_date TEXT,
    flood_program_type TEXT,
    flood_loma_revision_code TEXT,
    flood_loma_determination_date TEXT,
    flood_contract_type TEXT,
    flood_community_number TEXT,
    flood_panel_number TEXT,
    flood_zone_position_1 TEXT,
    flood_zone_position_2_and_3 TEXT,
    flood_suffix_number TEXT,
    flood_zone_partial_indicator TEXT,
    flood_firm_effective_date TEXT,
    flood_mapping_company_id TEXT,
    flood_certification_number TEXT,
    grace_days TEXT,
    late_charge_amount TEXT,
    late_charge_code TEXT,
    late_charge_code_description TEXT,
    late_charge_factor TEXT,
    maximum_late_charge_amount TEXT,
    minimum_late_charge_amount TEXT,
    delinquency_class_code TEXT,
    delinquency_class_code_description TEXT,
    secondary_phone_code TEXT,
    secondary_phone_number TEXT,
    escrow_advance_balance TEXT,
    escrow_balance TEXT,
    escrow_replace_resrv_balance TEXT,
    hazard_ins_monthly_amount TEXT,
    replace_reserve_amount TEXT,
    restricted_escrow_balance TEXT,
    t_and_i_monthly_amount TEXT,
    a_and_h_premium_amount TEXT,
    life_premium_amount TEXT,
    interest_paid_through_date TEXT,
    ln_mod_code TEXT,
    ln_mod_code_description TEXT,
    last_analysis_date TEXT,
    last_analysis_effective_date TEXT,
    last_analysis_os_spread_months TEXT,
    mi_monthly_amount TEXT,
    mi_term TEXT,
    mi_disbursement_amount TEXT,
    mi_disbursement_due_date TEXT,
    mi_mid_point_date TEXT,
    mi_termination_date TEXT,
    mi_cancellation_date TEXT,
    mi_request_to_cancel_date TEXT,
    pmi_cancellation_reason_code TEXT,
    pmi_cancellation_reason_code_description TEXT,
    va_loan_number TEXT,
    va_lin_check_digit_number TEXT,
    recover_corp_advance_balance TEXT,
    third_party_recoverable_ca_bal TEXT,
    non_rec_corp_advance_balance TEXT,
    second_principal_balance TEXT,
    actual_deferred_balance TEXT,
    ytd_principal_paid_amount TEXT,
    ytd_interest_amount TEXT,
    ytd_tax_amount TEXT,
    ytd_ioe_amount TEXT,
    ytd_hazard_amt TEXT,
    ytd_lien_amount TEXT,
    ytd_mip_amount TEXT,
    ytd_nsf_total TEXT,
    ytd_restricted_ioe_amount TEXT,
    ytd_late_charge_amount TEXT,
    prepay_penalty_indicator TEXT,
    ppp_header_id TEXT,
    ppp_header_name TEXT,
    user_05_position_field_2a TEXT,
    purchase_price TEXT,
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
    opt_ins_disbursement_amount TEXT,
    opt_ins_disbursement_due_date TEXT,
    imminent_default_fico_score TEXT,
    imminent_default_fico_date TEXT,
    points_paid_by_borrower TEXT,
    third_party_draft_code TEXT,
    third_party_draft_code_description TEXT,
    employee_code TEXT,
    zone TEXT,
    sec_mortgagor_birth_date TEXT,
    sec_co_mortgagor_birth_date TEXT,
    email_address TEXT,
    co_mortgagor_email_address TEXT,
    servicing_sold_id TEXT
);



-- to create a new user, baseline - roles
-- for permissions, ingress-permissions, check out V2021_7_1_0_migration - alter default on new user




/*
This section of code is for creating the warehouse bank tables in the warehouse_banks
*/


CREATE TABLE warehouse_banks.loan_inventory_prosperity
(
    etl_batch_id TEXT,
    data_source_dwid BIGINT,
    input_filename TEXT,
    bank_name TEXT,
    report_name TEXT,
    report_date_as_of TEXT,
    accrued_through TEXT,
    accrued_through_date TEXT,
    company_name TEXT,
    company_address TEXT,
    company_address_2 TEXT,
    company_city_state_zip TEXT,
    company_phone TEXT,
    empty_1 TEXT,
    empty_2 TEXT,
    empty_3 TEXT,
    loan_number_header TEXT,
    name_header TEXT,
    note_amount_header TEXT,
    warehouse_amount_header TEXT,
    orig_part_header TEXT,
    int_header TEXT,
    fees_header TEXT,
    days_header TEXT,
    date_disb_header TEXT,
    note_recd_header TEXT,
    note_shipped_header TEXT,
    investor_header TEXT,
    takeout_header TEXT,
    tracking_header TEXT,
    prod_code_header TEXT,
    index_header TEXT,
    margin_header TEXT,
    loan_number TEXT,
    name TEXT,
    note_amount TEXT,
    warehouse_amount TEXT,
    orig_part TEXT,
    int TEXT,
    fees TEXT,
    days TEXT,
    date_disb TEXT,
    note_recd TEXT,
    note_shipped TEXT,
    investor TEXT,
    takeout TEXT,
    tracking TEXT,
    prod_code TEXT,
    index text,
    margin TEXT,
    company_name_2 TEXT,
    total_company_loan_count TEXT,
    note_amount_total TEXT,
    warehouse_amount_total TEXT,
    orig_part_total TEXT,
    total_interest_amount TEXT,
    total_fees_amount TEXT,
    limit_header TEXT,
    limit_amount TEXT,
    available_header TEXT,
    available_amount TEXT,
    grand_total_header TEXT,
    grand_total_loan_count TEXT,
    grand_total_note_amount TEXT,
    grand_total_warehouse_amount TEXT,
    grand_total_orig_part TEXT,
    grand_total_interest TEXT,
    grand_total_fees TEXT,
    crystal_reports_export_page_description TEXT,
    report_export_date TEXT,
    report_export_time TEXT,
    crystal_reports_report_type TEXT
)
;

CREATE TABLE warehouse_banks.loan_inventory_flagstar
(
    etl_batch_id TEXT,
    data_source_dwid BIGINT,
    input_filename TEXT,
    confirm_number TEXT,
    loan_number TEXT,
    lender_loan_number TEXT,
    note_amount TEXT,
    note_rate TEXT,
    borrower TEXT,
    draw_fee NUMERIC(21, 3),
    outstanding_interest_accrued NUMERIC(21, 3),
    original_advance_amount NUMERIC(21, 3),
    outstanding_advance_amount NUMERIC(21, 3),
    disbursement_amount NUMERIC(21, 3),
    advance_date DATE,
    days_out INTEGER,
    note_received_date DATE,
    outbound_collateral_tracking_number TEXT,
    outbound_collateral_shipping_date DATE
)
;



CREATE TABLE warehouse_banks.loan_inventory_lifestyle_home_lending
(
    etl_batch_id TEXT,
    data_source_dwid BIGINT,
    input_filename TEXT,
    bank_name TEXT,
    report_name TEXT,
    report_date_as_of TEXT,
    accrued_through TEXT,
    accrued_through_date TEXT,
    company_name TEXT,
    company_address TEXT,
    company_address_2 TEXT,
    company_city_state_zip TEXT,
    empty_1 TEXT,
    empty_2 TEXT,
    empty_3 TEXT,
    empty_4 TEXT,
    loan_number_header TEXT,
    name_header TEXT,
    note_amount_header TEXT,
    warehouse_amount_header TEXT,
    orig_part_header TEXT,
    int_header TEXT,
    fees_header TEXT,
    days_header TEXT,
    date_disb_header TEXT,
    note_recd_header TEXT,
    note_shipped_header TEXT,
    investor_header TEXT,
    takeout_header TEXT,
    tracking_header TEXT,
    prod_code_header TEXT,
    index_header TEXT,
    margin_header TEXT,
    loan_number TEXT,
    name TEXT,
    note_amount TEXT,
    warehouse_amount TEXT,
    orig_part TEXT,
    int TEXT,
    fees TEXT,
    days TEXT,
    date_disb TEXT,
    note_recd TEXT,
    note_shipped TEXT,
    investor TEXT,
    takeout TEXT,
    tracking TEXT,
    product_code TEXT,
    index TEXT,
    margin TEXT,
    company_name_2 TEXT,
    total_company_loan_count TEXT,
    note_amount_total TEXT,
    warehouse_amount_total TEXT,
    orig_part_total TEXT,
    total_interest_amount TEXT,
    total_fees_amount TEXT,
    limit_header TEXT,
    limit_amount TEXT,
    available_header TEXT,
    available_amount TEXT,
    grand_total_header TEXT,
    grand_total_loan_count TEXT,
    grand_total_note_amount TEXT,
    grand_total_warehouse_amount TEXT,
    grand_total_orig_part TEXT,
    grand_total_interest TEXT,
    grand_total_fees TEXT,
    crystal_reports_export_page_description TEXT,
    report_export_date TEXT,
    report_export_time TEXT,
    crystal_reports_report_type TEXT
)
;

CREATE TABLE warehouse_banks.loan_inventory_bank_united
(
    etl_batch_id TEXT,
    data_source_dwid BIGINT,
    input_filename TEXT,
    bank_name TEXT,
    report_name TEXT,
    report_date_as_of TEXT,
    accrued_through TEXT,
    accrued_through_date TEXT,
    company_name TEXT,
    company_address TEXT,
    company_address_2 TEXT,
    company_city_state_zip TEXT,
    empty_1 TEXT,
    empty_2 TEXT,
    empty_3 TEXT,
    empty_4 TEXT,
    loan_number_header TEXT,
    name_header TEXT,
    note_amount_header TEXT,
    warehouse_amount_header TEXT,
    orig_part_header TEXT,
    int_header TEXT,
    fees_header TEXT,
    days_header TEXT,
    date_disb_header TEXT,
    note_recd_header TEXT,
    note_shipped_header TEXT,
    investor_header TEXT,
    takeout_header TEXT,
    tracking_header TEXT,
    prod_code_header TEXT,
    index_header TEXT,
    margin_header TEXT,
    loan_number TEXT,
    name TEXT,
    note_amount TEXT,
    warehouse_amount TEXT,
    orig_part TEXT,
    int TEXT,
    fees TEXT,
    days TEXT,
    date_disb TEXT,
    note_recd TEXT,
    note_shipped TEXT,
    investor TEXT,
    takeout TEXT,
    tracking TEXT,
    product_code TEXT,
    index TEXT,
    margin TEXT,
    company_name_2 TEXT,
    total_company_loan_count TEXT,
    note_amount_total TEXT,
    warehouse_amount_total TEXT,
    orig_part_total TEXT,
    total_interest_amount TEXT,
    total_fees_amount TEXT,
    limit_header TEXT,
    limit_amount TEXT,
    available_header TEXT,
    available_amount TEXT,
    grand_total_header TEXT,
    grand_total_loan_count TEXT,
    grand_total_note_amount TEXT,
    grand_total_warehouse_amount TEXT,
    grand_total_orig_part TEXT,
    grand_total_interest TEXT,
    grand_total_fees TEXT,
    crystal_reports_export_page_description TEXT,
    report_export_date TEXT,
    report_export_time TEXT,
    crystal_reports_report_type TEXT
)
;

CREATE TABLE warehouse_banks.loan_inventory_truist
(
    etl_batch_id TEXT,
    data_source_dwid BIGINT,
    input_filename TEXT,
    account TEXT,
    loan_id TEXT,
    lname TEXT,
    fname TEXT,
    product TEXT,
    rate NUMERIC(15,9),
    note_amount NUMERIC(21,3),
    balance NUMERIC(21,3),
    mtg_date DATE,
    deposit_date DATE,
    inception_date DATE,
    age_cal INTEGER,
    investor TEXT,
    commit_number TEXT,
    stage TEXT,
    rel_date DATE,
    exception_flag INTEGER,
    rel_method TEXT,
    tracking_num TEXT
)
;

CREATE TABLE warehouse_banks.loan_inventory_texas_capital (
    etl_batch_id TEXT,
    data_source_dwid BIGINT,
    input_filename TEXT,
    rowtype TEXT,
    customer_code TEXT,
    customer_name TEXT,
    account_sak TEXT,
    customer_account_key TEXT,
    renewal_date TEXT,
    account_descr TEXT,
    cost_center TEXT,
    orig_advance_date TEXT,
    acquisition_cost TEXT,
    address TEXT,
    amortization_code TEXT,
    anncap TEXT,
    armadj TEXT,
    armconv TEXT,
    armindex TEXT,
    armmargin TEXT,
    armround TEXT,
    armteaser TEXT,
    as_of_date TEXT,
    asset_class_code TEXT,
    auction_date TEXT,
    balloon_flag TEXT,
    bar_code TEXT,
    borr_1_first_name TEXT,
    borr_1_last_name TEXT,
    borr_2_first_name TEXT,
    borr_2_last_name TEXT,
    city TEXT,
    closing_agent_code TEXT,
    coll_closed_date TEXT,
    coll_valuation_set_code TEXT,
    coll_value_expire_date TEXT,
    coll_value_recalc_flag TEXT,
    collateral_key TEXT,
    collateral_key2 TEXT,
    collateral_key3 TEXT,
    collateral_sak TEXT,
    collateral_value TEXT,
    collateral_value_date TEXT,
    collateral_value_flag TEXT,
    collgroup TEXT,
    construction_cost TEXT,
    credit_grade_code TEXT,
    curr_appraised_value TEXT,
    curr_payment TEXT,
    curr_pledge_date TEXT,
    curr_rate TEXT,
    curr_upb TEXT,
    custodian_sak TEXT,
    customer_sak TEXT,
    debt_service_ratio TEXT,
    delinquent_days TEXT,
    delinquent_history TEXT,
    doc_level_code TEXT,
    document_set_code TEXT,
    coll_exist_status_code TEXT,
    expire_date TEXT,
    fico_score TEXT,
    first_rate_change_date TEXT,
    firstdue TEXT,
    coll_home_track_location_code TEXT,
    instrument_num TEXT,
    inv_commit_expire_date TEXT,
    inv_commit_number TEXT,
    inv_commit_price TEXT,
    investor_code TEXT,
    investor_id TEXT,
    coll_is_active TEXT,
    last_paid_date TEXT,
    lien_position TEXT,
    lifecap TEXT,
    coll_major_count TEXT,
    market_value TEXT,
    market_value_date TEXT,
    market_value_expire_date TEXT,
    market_value_override_flag TEXT,
    maturity TEXT,
    mers_min TEXT,
    coll_minor_count TEXT,
    months_to_roll TEXT,
    next_due_date TEXT,
    next_inspection_date TEXT,
    next_rate_change_date TEXT,
    occupancy_code TEXT,
    occupancy_ratio TEXT,
    orig_appraised_value TEXT,
    orig_pledge_date TEXT,
    orig_rate TEXT,
    orig_upb TEXT,
    original_cltv TEXT,
    original_ltv TEXT,
    original_term TEXT,
    origination_date TEXT,
    originator_code TEXT,
    p_i TEXT,
    paid_to_date TEXT,
    pool_id TEXT,
    prepay_penalty_flag TEXT,
    prepay_penalty_pct TEXT,
    product_code TEXT,
    production_stage_code TEXT,
    production_stage_date TEXT,
    property_type_code TEXT,
    purpose_code TEXT,
    rate_change_frequency TEXT,
    record_book TEXT,
    record_page TEXT,
    recorded TEXT,
    coll_release_request_identifier TEXT,
    scheduled_upb TEXT,
    coll_shipment_id TEXT,
    short_name TEXT,
    state TEXT,
    tenant_num TEXT,
    tmo_ratio TEXT,
    track_item_type_code TEXT,
    coll_track_location_code TEXT,
    udf_char_1 TEXT,
    udf_char_2 TEXT,
    udf_date_1 TEXT,
    udf_date_2 TEXT,
    udf_dollar_1 TEXT,
    udf_dollar_2 TEXT,
    udf_int_1 TEXT,
    udf_int_2 TEXT,
    udf_pct_1 TEXT,
    udf_pct_2 TEXT,
    units TEXT,
    zip TEXT,
    warehouse_aging_date TEXT,
    active_flag TEXT,
    doctype_code TEXT,
    document_descr TEXT,
    document_sak TEXT,
    doc_exist_status_code TEXT,
    doc_home_track_location_code TEXT,
    doc_major_count TEXT,
    doc_minor_count TEXT,
    doc_release_request_identifier TEXT,
    doc_track_location_code TEXT,
    cleared_flag TEXT,
    fatal_error_flag TEXT,
    docex_notation TEXT,
    opendate TEXT,
    question_code TEXT,
    updated_by TEXT,
    collmemo_active_flag TEXT,
    collmemo_memo_date TEXT,
    collmemo_memo_sak TEXT,
    collmemo_memo_subject TEXT,
    collmemo_memo_text TEXT,
    collmemo_memo_type TEXT,
    collmemo_posted_by TEXT,
    collmemo_private_flag TEXT,
    docmemo_active_flag TEXT,
    docmemo_memo_date TEXT,
    docmemo_memo_sak TEXT,
    docmemo_memo_subject TEXT,
    docmemo_memo_text TEXT,
    docmemo_memo_type TEXT,
    docmemo_posted_by TEXT,
    docmemo_private_flag TEXT,
    business_tran_log_sak TEXT,
    carrier_code TEXT,
    carrier_id TEXT,
    certification_code TEXT,
    destination_type_flag TEXT,
    effective_date TEXT,
    deposit_date TEXT,
    release_date TEXT,
    effective_rate TEXT,
    handling_option TEXT,
    btl_investor_code TEXT,
    btl_notation TEXT,
    posted_by TEXT,
    release_code TEXT,
    release_request_identifier TEXT,
    request_date TEXT,
    requestor TEXT,
    return_due_date TEXT,
    reversal_method TEXT,
    shipment_id TEXT,
    task_type_code TEXT,
    task_type_code_rel TEXT,
    btl_track_location_code TEXT,
    transtype TEXT,
    workbin_code TEXT,
    funding_id TEXT,
    funding_date TEXT,
    sched_funding_date TEXT,
    doctype_descr TEXT,
    question_descr TEXT,
    expires TEXT,
    loan_is_active TEXT,
    lender_sak TEXT,
    loan_descr TEXT,
    loan_id TEXT,
    loan_inception TEXT,
    loan_sak TEXT,
    max_balance_amt TEXT,
    max_balance_flag TEXT,
    max_balance_pct TEXT,
    orig_prin_balance TEXT,
    payoff_date TEXT,
    pricing_flag TEXT,
    pricing_rule_code TEXT,
    pricing_rule_flag TEXT,
    sequence TEXT,
    curr_prin_balance TEXT,
    curr_amount TEXT,
    curr_interest TEXT,
    curr_fee TEXT,
    curr_cof TEXT,
    curr_unapplied TEXT,
    redemptive_value TEXT,
    lender_code TEXT,
    lender_descr TEXT,
    cdays_aging TEXT,
    bdays_aging TEXT,
    coll_group_code TEXT,
    member_sak TEXT,
    query_stmt_descr TEXT,
    cleared_docex_notation TEXT,
    cleared_opendate TEXT,
    cleared_question_code TEXT,
    cleared_question_descr TEXT,
    takeout_value TEXT,
    collateral_deficit TEXT,
    curr_cltv TEXT,
    curr_ltv TEXT,
    customer_code_list TEXT,
    customer_account_key_list TEXT,
    exist_status_code_list TEXT,
    date_analysis TEXT,
    coll_sel_opt TEXT,
    begin_date TEXT,
    end_date TEXT,
    print_memos TEXT,
    production_stage_code_list TEXT,
    print_docs TEXT,
    print_exceptions TEXT,
    sort_option TEXT,
    format_option TEXT
    )
;


CREATE TABLE warehouse_banks.loan_inventory_tiaa (
    etl_batch_id TEXT,
    data_source_dwid BIGINT,
    input_filename TEXT,
    rowtype TEXT,
    customer_code TEXT,
    customer_name TEXT,
    account_sak TEXT,
    customer_account_key TEXT,
    renewal_date TEXT,
    account_descr TEXT,
    cost_center TEXT,
    orig_advance_date TEXT,
    acquisition_cost TEXT,
    address TEXT,
    amortization_code TEXT,
    anncap TEXT,
    armadj TEXT,
    armconv TEXT,
    armindex TEXT,
    armmargin TEXT,
    armround TEXT,
    armteaser TEXT,
    as_of_date TEXT,
    asset_class_code TEXT,
    auction_date TEXT,
    balloon_flag TEXT,
    bar_code TEXT,
    borr_1_first_name TEXT,
    borr_1_last_name TEXT,
    borr_2_first_name TEXT,
    borr_2_last_name TEXT,
    city TEXT,
    closing_agent_code TEXT,
    coll_closed_date TEXT,
    coll_valuation_set_code TEXT,
    coll_value_expire_date TEXT,
    coll_value_recalc_flag TEXT,
    collateral_key TEXT,
    collateral_key2 TEXT,
    collateral_key3 TEXT,
    collateral_sak TEXT,
    collateral_value TEXT,
    collateral_value_date TEXT,
    collateral_value_flag TEXT,
    collgroup TEXT,
    construction_cost TEXT,
    credit_grade_code TEXT,
    curr_appraised_value TEXT,
    curr_payment TEXT,
    curr_pledge_date TEXT,
    curr_rate TEXT,
    curr_upb TEXT,
    custodian_sak TEXT,
    customer_sak TEXT,
    debt_service_ratio TEXT,
    delinquent_days TEXT,
    delinquent_history TEXT,
    doc_level_code TEXT,
    document_set_code TEXT,
    coll_exist_status_code TEXT,
    expire_date TEXT,
    fico_score TEXT,
    first_rate_change_date TEXT,
    firstdue TEXT,
    coll_home_track_location_code TEXT,
    instrument_num TEXT,
    inv_commit_expire_date TEXT,
    inv_commit_number TEXT,
    inv_commit_price TEXT,
    investor_code TEXT,
    investor_id TEXT,
    coll_is_active TEXT,
    last_paid_date TEXT,
    lien_position TEXT,
    lifecap TEXT,
    coll_major_count TEXT,
    market_value TEXT,
    market_value_date TEXT,
    market_value_expire_date TEXT,
    market_value_override_flag TEXT,
    maturity TEXT,
    mers_min TEXT,
    coll_minor_count TEXT,
    months_to_roll TEXT,
    next_due_date TEXT,
    next_inspection_date TEXT,
    next_rate_change_date TEXT,
    occupancy_code TEXT,
    occupancy_ratio TEXT,
    orig_appraised_value TEXT,
    orig_pledge_date TEXT,
    orig_rate TEXT,
    orig_upb TEXT,
    original_cltv TEXT,
    original_ltv TEXT,
    original_term TEXT,
    origination_date TEXT,
    originator_code TEXT,
    p_i TEXT,
    paid_to_date TEXT,
    pool_id TEXT,
    prepay_penalty_flag TEXT,
    prepay_penalty_pct TEXT,
    product_code TEXT,
    production_stage_code TEXT,
    production_stage_date TEXT,
    production_grade_code TEXT,
    production_grade_date TEXT,
    property_type_code TEXT,
    purpose_code TEXT,
    rate_change_frequency TEXT,
    record_book TEXT,
    record_page TEXT,
    recorded TEXT,
    coll_release_request_identifier TEXT,
    scheduled_upb TEXT,
    coll_shipment_id TEXT,
    short_name TEXT,
    state TEXT,
    tenant_num TEXT,
    tmo_ratio TEXT,
    track_item_type_code TEXT,
    coll_track_location_code TEXT,
    udf_char_1 TEXT,
    udf_char_2 TEXT,
    udf_date_1 TEXT,
    udf_date_2 TEXT,
    udf_dollar_1 TEXT,
    udf_dollar_2 TEXT,
    udf_int_1 TEXT,
    udf_int_2 TEXT,
    udf_pct_1 TEXT,
    udf_pct_2 TEXT,
    units TEXT,
    zip TEXT,
    warehouse_aging_date TEXT,
    active_flag TEXT,
    doctype_code TEXT,
    document_descr TEXT,
    document_sak TEXT,
    doc_exist_status_code TEXT,
    doc_home_track_location_code TEXT,
    doc_major_count TEXT,
    doc_minor_count TEXT,
    doc_release_request_identifier TEXT,
    doc_track_location_code TEXT,
    cleared_flag TEXT,
    fatal_error_flag TEXT,
    docex_notation TEXT,
    opendate TEXT,
    question_code TEXT,
    updated_by TEXT,
    collmemo_active_flag TEXT,
    collmemo_memo_date TEXT,
    collmemo_memo_sak TEXT,
    collmemo_memo_subject TEXT,
    collmemo_memo_text TEXT,
    collmemo_memo_type TEXT,
    collmemo_posted_by TEXT,
    collmemo_private_flag TEXT,
    docmemo_active_flag TEXT,
    docmemo_memo_date TEXT,
    docmemo_memo_sak TEXT,
    docmemo_memo_subject TEXT,
    docmemo_memo_text TEXT,
    docmemo_memo_type TEXT,
    docmemo_posted_by TEXT,
    docmemo_private_flag TEXT,
    business_tran_log_sak TEXT,
    carrier_code TEXT,
    carrier_id TEXT,
    certification_code TEXT,
    destination_type_flag TEXT,
    effective_date TEXT,
    deposit_date TEXT,
    release_date TEXT,
    effective_rate TEXT,
    handling_option TEXT,
    btl_investor_code TEXT,
    btl_notation TEXT,
    posted_by TEXT,
    release_code TEXT,
    release_request_identifier TEXT,
    request_date TEXT,
    requestor TEXT,
    return_due_date TEXT,
    reversal_method TEXT,
    shipment_id TEXT,
    task_type_code TEXT,
    task_type_code_rel TEXT,
    btl_track_location_code TEXT,
    transtype TEXT,
    workbin_code TEXT,
    funding_id TEXT,
    funding_date TEXT,
    sched_funding_date TEXT,
    doctype_descr TEXT,
    question_descr TEXT,
    expires TEXT,
    loan_is_active TEXT,
    lender_sak TEXT,
    loan_descr TEXT,
    loan_id TEXT,
    loan_inception TEXT,
    loan_sak TEXT,
    max_balance_amt TEXT,
    max_balance_flag TEXT,
    max_balance_pct TEXT,
    orig_prin_balance TEXT,
    payoff_date TEXT,
    pricing_flag TEXT,
    pricing_rule_code TEXT,
    pricing_rule_flag TEXT,
    sequence TEXT,
    curr_prin_balance TEXT,
    curr_amount TEXT,
    curr_interest TEXT,
    curr_fee TEXT,
    curr_cof TEXT,
    curr_unapplied TEXT,
    redemptive_value TEXT,
    lender_code TEXT,
    lender_descr TEXT,
    cdays_aging TEXT,
    bdays_aging TEXT,
    coll_group_code TEXT,
    member_sak TEXT,
    query_stmt_descr TEXT,
    cleared_docex_notation TEXT,
    cleared_opendate TEXT,
    cleared_question_code TEXT,
    cleared_question_descr TEXT,
    takeout_value TEXT,
    collateral_deficit TEXT,
    curr_cltv TEXT,
    curr_ltv TEXT,
    customer_code_list TEXT,
    customer_account_key_list TEXT,
    exist_status_code_list TEXT,
    date_analysis TEXT,
    coll_sel_opt TEXT,
    begin_date TEXT,
    end_date TEXT,
    print_memos TEXT,
    production_stage_code_list TEXT,
    print_docs TEXT,
    print_exceptions TEXT,
    sort_option TEXT,
    format_option TEXT
    )
;


CREATE TABLE warehouse_banks.loan_inventory_bank_montreal
(
    etl_batch_id TEXT,
    data_source_dwid BIGINT,
    input_filename TEXT,
    seller_loan_id TEXT,
    seller_code TEXT,
    status TEXT,
    wire_confirm_status TEXT,
    fed_ref TEXT,
    product_type TEXT,
    bal_orig NUMERIC(21, 3),
    lien INTEGER,
    first_name TEXT,
    last_name TEXT,
    advance_amt NUMERIC(21, 3),
    occupancy TEXT,
    cf INTEGER,
    ltv NUMERIC(15, 9),
    cltv NUMERIC(15, 9),
    purpose TEXT,
    current_rate NUMERIC(15, 9),
    rt_orig NUMERIC(15, 9),
    rt_adjustable_flag INTEGER,
    original_term INTEGER,
    address TEXT,
    state TEXT,
    city TEXT,
    zip TEXT,
    is_wet_flag INTEGER,
    custodian_status TEXT,
    agency TEXT,
    product_type_tape TEXT,
    funding_date DATE,
    fico INTEGER,
    bal_curr NUMERIC(21, 3),
    wire_amount NUMERIC(21, 3),
    origination_dt DATE,
    maturity_dt DATE,
    co_borrower_first_name TEXT,
    co_borrower_name_last TEXT,
    co_borrower_fico INTEGER,
    mers_loan_id TEXT,
    mers_registration TEXT,
    mers_flag INTEGER,
    property_type TEXT,
    units INTEGER,
    doc_type TEXT,
    appraisal_value NUMERIC(21, 3),
    sales_price NUMERIC(21, 3),
    dti NUMERIC(15, 9),
    balloon INTEGER,
    balloon_term INTEGER,
    origination_channel TEXT,
    fhava_cert_number TEXT,
    index TEXT,
    margin NUMERIC(15, 9),
    rt_reset_dt_first DATE,
    rt_reset_mo_first TEXT,
    pmt_reset_dt_first DATE,
    rt_cap_first TEXT,
    life_cap NUMERIC(15, 9),
    rt_reset_frequency TEXT,
    rt_floor_life TEXT,
    rt_lookback_period TEXT,
    rt_rounding_factor TEXT,
    investor_id TEXT,
    pmi_cert_no TEXT,
    pmi_company TEXT,
    pmi NUMERIC(15, 9),
    apr NUMERIC(15, 9),
    section32_flag INTEGER,
    aus_rating TEXT,
    aus_response TEXT,
    enote_flag INTEGER,
    prior_bk_filing_dt DATE,
    periodic_cap NUMERIC(15, 9),
    interest_only INTEGER,
    pmt_due_dt_first DATE,
    pmt_due_dt_next DATE,
    as_of_dt_act DATE,
    delq_days_ots INTEGER,
    pmt_amount NUMERIC(21, 3),
    lms_loan_id TEXT,
    account_name TEXT,
    bank_name TEXT,
    additional_nstructions_1 TEXT,
    additional_instructions_2 TEXT,
    bulk_wire_flag TEXT,
    takeout_commitment_price NUMERIC(21, 3),
    commitment_expiration_date DATE,
    county_code TEXT,
    county TEXT,
    calendar_days_aged INTEGER,
    dry_date TIMESTAMP,
    ship_date DATE
)
;

CREATE TABLE warehouse_banks.loan_inventory_sterling
(
    etl_batch_id TEXT,
    data_source_dwid BIGINT,
    input_filename TEXT,
    rowtype TEXT,
    customer_code TEXT,
    customer_name TEXT,
    account_sak TEXT,
    customer_account_key TEXT,
    renewal_date DATE,
    account_descr TEXT,
    cost_center INTEGER,
    orig_advance_date DATE,
    acquisition_cost INTEGER,
    address TEXT,
    amortization_code TEXT,
    anncap NUMERIC(15, 9),
    armadj TEXT,
    armconv INTEGER,
    armindex TEXT,
    armmargin INTEGER,
    armround INTEGER,
    armteaser INTEGER,
    as_of_date DATE,
    asset_class_code TEXT,
    auction_date DATE,
    balloon_flag INTEGER,
    bar_code TEXT,
    borr_1_first_name TEXT,
    borr_1_last_name TEXT,
    borr_2_first_name TEXT,
    borr_2_last_name TEXT,
    city TEXT,
    closing_agent_code TEXT,
    coll_closed_date DATE,
    coll_valuation_set_code TEXT,
    coll_value_expire_date DATE,
    coll_value_recalc_flag INTEGER,
    collateral_key TEXT,
    collateral_key2 TEXT,
    collateral_key3 TEXT,
    collateral_sak INTEGER,
    collateral_value NUMERIC(21, 3),
    collateral_value_date DATE,
    collateral_value_flag INTEGER,
    collgroup TEXT,
    construction_cost NUMERIC(21, 3),
    credit_grade_code TEXT,
    curr_appraised_value NUMERIC(21, 3),
    curr_payment NUMERIC(21, 3),
    curr_pledge_date DATE,
    curr_rate NUMERIC(15, 9),
    curr_upb INTEGER,
    custodian_sak TEXT,
    customer_sak INTEGER,
    debt_service_ratio NUMERIC(15, 9),
    delinquent_days INTEGER,
    delinquent_history TEXT,
    doc_level_code TEXT,
    document_set_code TEXT,
    coll_exist_status_code TEXT,
    expire_date DATE,
    fico_score INTEGER,
    first_rate_change_date DATE,
    firstdue TEXT,
    coll_home_track_location_code TEXT,
    instrument_num TEXT,
    inv_commit_expire_date DATE,
    inv_commit_number TEXT,
    inv_commit_price INTEGER,
    investor_code TEXT,
    investor_id TEXT,
    coll_is_active INTEGER,
    last_paid_date DATE,
    lien_position INTEGER,
    lifecap INTEGER,
    coll_major_count INTEGER,
    market_value INTEGER,
    market_value_date DATE,
    market_value_expire_date DATE,
    market_value_override_flag INTEGER,
    maturity TEXT,
    mers_min BIGINT,
    coll_minor_count INTEGER,
    months_to_roll INTEGER,
    next_due_date DATE,
    next_inspection_date DATE,
    next_rate_change_date DATE,
    occupancy_code TEXT,
    occupancy_ratio INTEGER,
    orig_appraised_value INTEGER,
    orig_pledge_date DATE,
    orig_rate NUMERIC(15, 9),
    orig_upb INTEGER,
    original_cltv INTEGER,
    original_ltv INTEGER,
    original_term INTEGER,
    origination_date DATE,
    originator_code TEXT,
    p_i INTEGER,
    paid_to_date DATE,
    pool_id TEXT,
    prepay_penalty_flag INTEGER,
    prepay_penalty_pct NUMERIC(15, 9),
    product_code TEXT,
    production_stage_code TEXT,
    production_stage_date DATE,
    property_type_code TEXT,
    purpose_code TEXT,
    rate_change_frequency INTEGER,
    record_book TEXT,
    record_page TEXT,
    recorded TEXT,
    coll_release_request_identifier TEXT,
    scheduled_upb INTEGER,
    coll_shipment_id TEXT,
    short_name TEXT,
    state TEXT,
    tenant_num INTEGER,
    tmo_ratio NUMERIC(15, 9),
    track_item_type_code TEXT,
    coll_track_location_code TEXT,
    udf_char_1 TEXT,
    udf_char_2 TEXT,
    udf_date_1 DATE,
    udf_date_2 DATE,
    udf_dollar_1 INTEGER,
    udf_dollar_2 INTEGER,
    udf_int_1 INTEGER,
    udf_int_2 INTEGER,
    udf_pct_1 NUMERIC(15, 9),
    udf_pct_2 NUMERIC(15, 9),
    units INTEGER,
    zip TEXT,
    warehouse_aging_date DATE,
    active_flag INTEGER,
    doctype_code TEXT,
    document_descr TEXT,
    document_sak TEXT,
    doc_exist_status_code TEXT,
    doc_home_track_location_code TEXT,
    doc_major_count INTEGER,
    doc_minor_count INTEGER,
    doc_release_request_identifier TEXT,
    doc_track_location_code TEXT,
    cleared_flag INTEGER,
    fatal_error_flag INTEGER,
    docex_notation TEXT,
    opendate DATE,
    question_code TEXT,
    updated_by TEXT,
    collmemo_active_flag INTEGER,
    collmemo_memo_date DATE,
    collmemo_memo_sak TEXT,
    collmemo_memo_subject TEXT,
    collmemo_memo_text TEXT,
    collmemo_memo_type TEXT,
    collmemo_posted_by TEXT,
    collmemo_private_flag INTEGER,
    docmemo_active_flag INTEGER,
    docmemo_memo_date DATE,
    docmemo_memo_sak TEXT,
    docmemo_memo_subject TEXT,
    docmemo_memo_text TEXT,
    docmemo_memo_type TEXT,
    docmemo_posted_by TEXT,
    docmemo_private_flag INTEGER,
    business_tran_log_sak INTEGER,
    carrier_code TEXT,
    carrier_id TEXT,
    certification_code TEXT,
    destination_type_flag INTEGER,
    effective_date DATE,
    deposit_date DATE,
    release_date DATE,
    effective_rate NUMERIC(15, 9),
    handling_option TEXT,
    btl_investor_code TEXT,
    btl_notation TEXT,
    posted_by INTEGER,
    release_code TEXT,
    release_request_identifier TEXT,
    request_date DATE,
    requestor TEXT,
    return_due_date DATE,
    reversal_method TEXT,
    shipment_id TEXT,
    task_type_code TEXT,
    task_type_code_rel TEXT,
    btl_track_location_code TEXT,
    transtype TEXT,
    workbin_code TEXT,
    funding_id TEXT,
    funding_date TIMESTAMP,
    sched_funding_date DATE,
    doctype_descr TEXT,
    question_descr TEXT,
    expires TEXT,
    loan_is_active INTEGER,
    lender_sak INTEGER,
    loan_descr TEXT,
    loan_id TEXT,
    loan_inception DATE,
    loan_sak INTEGER,
    max_balance_amt INTEGER,
    max_balance_flag INTEGER,
    max_balance_pct NUMERIC(15, 9),
    orig_prin_balance NUMERIC(21, 3),
    payoff_date DATE,
    pricing_flag INTEGER,
    pricing_rule_code TEXT,
    pricing_rule_flag INTEGER,
    sequence INTEGER,
    curr_prin_balance NUMERIC(21, 3),
    curr_amount INTEGER,
    curr_interest INTEGER,
    curr_fee INTEGER,
    curr_cof INTEGER,
    curr_unapplied TEXT,
    redemptive_value TEXT,
    lender_code TEXT,
    lender_descr TEXT,
    cdays_aging INTEGER,
    bdays_aging INTEGER,
    coll_group_code TEXT,
    member_sak TEXT,
    query_stmt_descr TEXT,
    cleared_docex_notation TEXT,
    cleared_opendate DATE,
    cleared_question_code TEXT,
    cleared_question_descr TEXT,
    takeout_value INTEGER,
    collateral_deficit NUMERIC(21, 3),
    curr_cltv NUMERIC(15, 9),
    curr_ltv NUMERIC(15, 9),
    customer_code_list TEXT,
    customer_account_key_list TEXT,
    exist_status_code_list TEXT,
    date_analysis TEXT,
    coll_sel_opt INTEGER,
    begin_date TEXT,
    end_date TEXT,
    print_memos INTEGER,
    production_stage_code_list TEXT,
    print_docs INTEGER,
    print_exceptions INTEGER,
    sort_option INTEGER,
    format_option INTEGER
)
;