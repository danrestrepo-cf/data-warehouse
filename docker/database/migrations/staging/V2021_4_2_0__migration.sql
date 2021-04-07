--
-- EDW | Create initial star model
-- (https://app.asana.com/0/0/1199659841029429)
--

CREATE TABLE star_loan.loan_fact (data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , loan_pid BIGINT
    , loan_dwid BIGINT CONSTRAINT pk_loan_fact PRIMARY KEY
    , loan_junk_dwid BIGINT
    , product_choices_dwid BIGINT
    , transaction_dwid BIGINT
    , transaction_junk_dwid BIGINT
    , loan_beneficiary_dwid BIGINT
    , loan_funding_dwid BIGINT
    , b1_borrower_dwid BIGINT
    , b2_borrower_dwid BIGINT
    , b3_borrower_dwid BIGINT
    , b4_borrower_dwid BIGINT
    , b5_borrower_dwid BIGINT
    , c1_borrower_dwid BIGINT
    , c2_borrower_dwid BIGINT
    , c3_borrower_dwid BIGINT
    , c4_borrower_dwid BIGINT
    , c5_borrower_dwid BIGINT
    , n1_borrower_dwid BIGINT
    , n2_borrower_dwid BIGINT
    , n3_borrower_dwid BIGINT
    , n4_borrower_dwid BIGINT
    , n5_borrower_dwid BIGINT
    , n6_borrower_dwid BIGINT
    , n7_borrower_dwid BIGINT
    , n8_borrower_dwid BIGINT
    , b1_borrower_demographics_dwid BIGINT
    , b1_borrower_lending_profile_dwid BIGINT
    , application_dwid BIGINT
    , collateral_to_custodian_lender_user_dwid BIGINT
    , interim_funder_dwid BIGINT
    , product_terms_dwid BIGINT
    , product_dwid BIGINT
    , investor_dwid BIGINT
    , hmda_purchaser_of_loan_dwid BIGINT
    , apr NUMERIC(15,9)
    , base_loan_amount NUMERIC(21,3)
    , financed_amount NUMERIC(21,3)
    , loan_amount NUMERIC(21,3)
    , ltv_ratio_percent NUMERIC(15,9)
    , note_rate_percent NUMERIC(15,9)
    , purchase_advice_amount NUMERIC(21,3)
    , finance_charge_amount NUMERIC(21,3)
    , hoepa_fees_dollar_amount NUMERIC(21,3)
    , interest_rate_fee_change_amount NUMERIC(21,3)
    , principal_curtailment_amount NUMERIC(21,3)
    , qualifying_pi_amount NUMERIC(21,3)
    , target_cash_out_amount NUMERIC(21,3)
    , heloc_maximum_balance_amount NUMERIC(21,3)
    , agency_case_id_assigned_date_dwid BIGINT
    , apor_date_dwid BIGINT
    , application_signed_date_dwid BIGINT
    , approved_with_conditions_date_dwid BIGINT
    , beneficiary_from_date_dwid BIGINT
    , beneficiary_through_date_dwid BIGINT
    , collateral_sent_date_dwid BIGINT
    , disbursement_date_dwid BIGINT
    , early_funding_date_dwid BIGINT
    , effective_funding_date_dwid BIGINT
    , fha_endorsement_date_dwid BIGINT
    , estimated_funding_date_dwid BIGINT
    , intent_to_proceed_date_dwid BIGINT
    , funding_date_dwid BIGINT
    , funding_requested_date_dwid BIGINT
    , loan_file_ship_date_dwid BIGINT
    , mers_transfer_creation_date_dwid BIGINT
    , pending_wire_date_dwid BIGINT
    , rejected_date_dwid BIGINT
    , return_confirmed_date_dwid BIGINT
    , return_request_date_dwid BIGINT
    , scheduled_release_date_dwid BIGINT
    , usda_guarantee_date_dwid BIGINT
    , va_guaranty_date_dwid BIGINT);
CREATE TABLE star_loan.loan_dim (dwid BIGSERIAL NOT NULL CONSTRAINT pk_loan_dim PRIMARY KEY
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , loan_pid BIGINT NOT NULL
    , proposal_pid BIGINT
    , product_terms_pid BIGINT
    , los_loan_number BIGINT
    , arm_index_current_value_percent NUMERIC(15,9)
    , arm_index_datetime TIMESTAMPTZ
    , base_guaranty_fee_percent NUMERIC(15,9)
    , base_loan_amount_ltv_ratio_percent NUMERIC(15,9)
    , collateral_tracking_number VARCHAR(32)
    , effective_undiscounted_rate_percent NUMERIC(15,9)
    , fhac_case_assignment_messages TEXT
    , fnm_investor_product_plan_id VARCHAR(5)
    , fnm_mbs_investor_contract_id VARCHAR(6)
    , guaranty_fee_after_alternate_payment_method_percent NUMERIC(15,9)
    , guaranty_fee_percent NUMERIC(15,9)
    , hmda_rate_spread_percent NUMERIC(15,9)
    , hoepa_apr NUMERIC(15,9)
    , hoepa_rate_spread NUMERIC(15,9)
    , last_unprocessed_changes_datetime TIMESTAMPTZ
    , loan_file_tracking_number VARCHAR(32)
    , locked_price_change_percent NUMERIC(15,9)
    , mi_requirement_ltv_ratio_percent NUMERIC(15,9)
    , product_choice_datetime TIMESTAMPTZ
    , rate_sheet_undiscounted_rate_percent NUMERIC(15,9)
    , uldd_loan_comment VARCHAR(60));
CREATE TABLE star_loan.loan_junk_dim (dwid BIGSERIAL NOT NULL CONSTRAINT pk_loan_junk_dim PRIMARY KEY
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , buydown_contributor VARCHAR(1024)
    , buydown_contributor_code VARCHAR(128)
    , fha_program VARCHAR(1024)
    , fha_program_code VARCHAR(128)
    , hmda_hoepa_status VARCHAR(1024)
    , hmda_hoepa_status_code VARCHAR(128)
    , durp_eligibility_opt_out_flag BOOLEAN
    , fha_principal_write_down_flag BOOLEAN
    , hpml_flag BOOLEAN
    , lender_concession_candidate_flag BOOLEAN
    , mi_required_flag BOOLEAN
    , piggyback_flag BOOLEAN
    , qm_eligible_flag BOOLEAN
    , qualified_mortgage_flag BOOLEAN
    , secondary_clear_to_commit_flag BOOLEAN
    , student_loan_cash_out_refinance_flag BOOLEAN
    , lien_priority VARCHAR(1024)
    , lien_priority_code VARCHAR(128)
    , lqa_purchase_eligibility VARCHAR(1024)
    , lqa_purchase_eligibility_code VARCHAR(128)
    , qualified_mortgage_status VARCHAR(1024)
    , qualified_mortgage_status_code VARCHAR(128)
    , qualifying_rate VARCHAR(1024)
    , qualifying_rate_code VARCHAR(128)
    , texas_equity VARCHAR(1024)
    , texas_equity_auto VARCHAR(1024)
    , texas_equity_auto_code VARCHAR(128)
    , texas_equity_code VARCHAR(128));
CREATE TABLE star_loan.product_choice_dim (dwid BIGSERIAL NOT NULL CONSTRAINT pk_product_choice_dim PRIMARY KEY
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , aus VARCHAR(1024)
    , aus_code VARCHAR(128)
    , buydown_schedule VARCHAR(1024)
    , buydown_schedule_code VARCHAR(128)
    , interest_only VARCHAR(1024)
    , interest_only_code VARCHAR(128)
    , mortgage_type VARCHAR(1024)
    , mortgage_type_code VARCHAR(128)
    , prepay_penalty_schedule VARCHAR(1024)
    , prepay_penatly_schedule_code VARCHAR(128));
CREATE TABLE star_loan.transaction_junk_dim (dwid BIGSERIAL NOT NULL
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , piggyback_flag BOOLEAN
    , mi_required_flag BOOLEAN
    , is_test_loan_flag BOOLEAN
    , structure VARCHAR(1024)
    , loan_purpose VARCHAR(1024)
    , structure_code VARCHAR(128)
    , loan_purpose_code VARCHAR(128));
CREATE TABLE star_loan.hmda_purchaser_of_loan_dim (dwid BIGSERIAL NOT NULL CONSTRAINT pk_hmda_purchaser_of_loan_dim PRIMARY KEY
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , code VARCHAR(128)
    , value VARCHAR(1024)
    , year VARCHAR(1024));
CREATE TABLE star_loan.borrower_dim (dwid BIGSERIAL NOT NULL CONSTRAINT pk_borrower_dim PRIMARY KEY
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , borrower_pid BIGINT NOT NULL
    , application_pid BIGINT
    , alimony_child_support_explanation VARCHAR(128)
    , applicant_role VARCHAR(1024)
    , applicant_role_code VARCHAR(128)
    , application_taken_method VARCHAR(1024)
    , application_taken_method_code VARCHAR(128)
    , bankruptcy_explanation VARCHAR(128)
    , birth_date DATE
    , borrowed_down_payment_explanation VARCHAR(128)
    , caivrs_id VARCHAR(16)
    , caivrs_messages TEXT
    , credit_report_authorization_datetime TIMESTAMPTZ
    , credit_report_authorization_method VARCHAR(1024)
    , credit_report_authorization_method_code VARCHAR(128)
    , credit_report_authorization_obtained_by_unparsed_name VARCHAR(128)
    , credit_report_identifier VARCHAR(32)
    , decision_credit_score INTEGER
    , dependent_count INTEGER
    , dependents_age_years VARCHAR(32)
    , email VARCHAR(256)
    , equifax_credit_score INTEGER
    , ethnicity_other_hispanic_or_latino_description VARCHAR(100)
    , experian_credit_score INTEGER
    , fax VARCHAR(32)
    , first_name VARCHAR(32)
    , first_time_homebuyer_explain VARCHAR(1024)
    , credit_report_authorization_flag BOOLEAN
    , has_no_ssn_flag BOOLEAN
    , power_of_attorney VARCHAR(1024)
    , power_of_attorney_code VARCHAR(128)
    , home_phone VARCHAR(32)
    , homeownership_education_id VARCHAR(128)
    , homeownership_education_name VARCHAR(128)
    , housing_counseling VARCHAR(1024)
    , housing_counseling_agency VARCHAR(1024)
    , housing_counseling_agency_code VARCHAR(128)
    , housing_counseling_code VARCHAR(128)
    , housing_counseling_complete_date DATE
    , housing_counseling_id VARCHAR(128)
    , housing_counseling_name VARCHAR(128)
    , required_to_sign_flag BOOLEAN
    , last_name VARCHAR(32)
    , legal_entity VARCHAR(1024)
    , legal_entity_code VARCHAR(128)
    , middle_name VARCHAR(32)
    , monthly_job_federal_tax_amount NUMERIC(21,3)
    , monthly_job_medicare_tax_amount NUMERIC(21,3)
    , monthly_job_other_tax_1_amount NUMERIC(21,3)
    , monthly_job_other_tax_1_description VARCHAR(128)
    , monthly_job_other_tax_2_amount NUMERIC(21,3)
    , monthly_job_other_tax_2_description VARCHAR(128)
    , monthly_job_other_tax_3_amount NUMERIC(21,3)
    , monthly_job_other_tax_3_description VARCHAR(128)
    , monthly_job_retirement_tax_amount NUMERIC(21,3)
    , monthly_job_state_disability_insurance_amount NUMERIC(21,3)
    , monthly_job_state_tax_amount NUMERIC(21,3)
    , monthly_job_total_tax_amount NUMERIC(21,3)
    , name_suffix VARCHAR(32)
    , nickname VARCHAR(32)
    , note_endorser_explanation VARCHAR(128)
    , obligated_loan_foreclosure_explanation VARCHAR(128)
    , office_phone VARCHAR(32)
    , office_phone_extension VARCHAR(16)
    , other_race_national_origin_description VARCHAR(32)
    , outstanding_judgments_explanation VARCHAR(128)
    , party_to_lawsuit_explanation VARCHAR(128)
    , power_of_attorney_city VARCHAR(128)
    , power_of_attorney_company_name VARCHAR(128)
    , power_of_attorney_country VARCHAR(1024)
    , power_of_attorney_country_code VARCHAR(128)
    , power_of_attorney_email VARCHAR(256)
    , power_of_attorney_fax VARCHAR(32)
    , power_of_attorney_first_name VARCHAR(32)
    , power_of_attorney_last_name VARCHAR(32)
    , power_of_attorney_middle_name VARCHAR(32)
    , power_of_attorney_mobile_phone VARCHAR(32)
    , power_of_attorney_name_suffix VARCHAR(32)
    , power_of_attorney_office_phone VARCHAR(32)
    , power_of_attorney_office_phone_extension VARCHAR(16)
    , power_of_attorney_postal_code VARCHAR(128)
    , power_of_attorney_signing_capacity VARCHAR(1024)
    , power_of_attorney_state VARCHAR(128)
    , power_of_attorney_street1 VARCHAR(128)
    , power_of_attorney_street2 VARCHAR(128)
    , power_of_attorney_title VARCHAR(128)
    , preferred_first_name VARCHAR(32)
    , presently_delinquent_explanation VARCHAR(128)
    , prior_property_title VARCHAR(1024)
    , prior_property_title_code VARCHAR(128)
    , prior_property_usage VARCHAR(1024)
    , prior_property_usage_code VARCHAR(128)
    , property_foreclosure_explanation VARCHAR(128)
    , race_other_american_indian_or_alaska_native_description VARCHAR(100)
    , race_other_asian_description VARCHAR(100)
    , race_other_pacific_islander_description VARCHAR(100)
    , relationship_to_primary_borrower VARCHAR(1024)
    , relationship_to_primary_borrower_code VARCHAR(128)
    , relationship_to_seller VARCHAR(1024)
    , relationship_to_seller_code VARCHAR(128)
    , tiny_id VARCHAR(1024)
    , tiny_id_code VARCHAR(128)
    , trans_union_credit_score INTEGER
    , usda_annual_child_care_expenses NUMERIC(21,3)
    , usda_disability_expenses NUMERIC(21,3)
    , usda_income_from_assets NUMERIC(21,3)
    , usda_medical_expenses NUMERIC(21,3)
    , usda_moderate_income_limit NUMERIC(21,3));
CREATE TABLE star_loan.borrower_demographics_dim (dwid BIGSERIAL NOT NULL CONSTRAINT pk_borrower_demographics_dim PRIMARY KEY
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , ethnicity_collected_visual_or_surname VARCHAR(1024)
    , ethnicity_collected_visual_or_surname_code VARCHAR(128)
    , ethnicity_refused VARCHAR(1024)
    , ethnicity_refused_code VARCHAR(128)
    , ethnicity_other_hispanic_or_latino_description_flag BOOLEAN
    , other_race_national_origin_description_flag BOOLEAN
    , race_other_american_indian_or_alaska_native_description_flag BOOLEAN
    , race_other_asian_description_flag BOOLEAN
    , race_other_pacific_islander_description_flag BOOLEAN
    , ethnicity_cuban_flag BOOLEAN
    , ethnicity_hispanic_or_latino_flag BOOLEAN
    , ethnicity_mexican_flag BOOLEAN
    , ethnicity_not_hispanic_or_latino_flag BOOLEAN
    , ethnicity_not_obtainable_flag BOOLEAN
    , ethnicity_other_hispanic_or_latino_flag BOOLEAN
    , ethnicity_puerto_rican_flag BOOLEAN
    , race_american_indian_or_alaska_native_flag BOOLEAN
    , race_asian_flag BOOLEAN
    , race_asian_indian_flag BOOLEAN
    , race_black_or_african_american_flag BOOLEAN
    , race_chinese_flag BOOLEAN
    , race_filipino_flag BOOLEAN
    , race_guamanian_or_chamorro_flag BOOLEAN
    , race_information_not_provided_flag BOOLEAN
    , race_japanese_flag BOOLEAN
    , race_korean_flag BOOLEAN
    , race_national_origin_refusal_flag BOOLEAN
    , race_native_hawaiian_flag BOOLEAN
    , race_native_hawaiian_or_other_pacific_islander_flag BOOLEAN
    , race_not_applicable_flag BOOLEAN
    , race_not_obtainable_flag BOOLEAN
    , race_other_asian_flag BOOLEAN
    , race_other_pacific_islander_flag BOOLEAN
    , race_samoan_flag BOOLEAN
    , race_vietnamese_flag BOOLEAN
    , race_white_flag BOOLEAN
    , sex_female_flag BOOLEAN
    , sex_male_flag BOOLEAN
    , sex_not_obtainable_flag BOOLEAN
    , marital_status VARCHAR(1024)
    , marital_status_code VARCHAR(128)
    , race_collected_visual_or_surname VARCHAR(1024)
    , race_collected_visual_or_surname_code VARCHAR(128)
    , race_refused VARCHAR(1024)
    , race_refused_code VARCHAR(128)
    , schooling_years VARCHAR(11)
    , sex_collected_visual_or_surname VARCHAR(1024)
    , sex_collected_visual_or_surname_code VARCHAR(128)
    , sex_refused VARCHAR(1024)
    , sex_refused_code VARCHAR(128));
CREATE TABLE star_loan.borrower_lending_profile_dim (dwid BIGSERIAL NOT NULL CONSTRAINT pk_borrower_lending_profile_dim PRIMARY KEY
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , alimony_child_support VARCHAR(1024)
    , alimony_child_support_code VARCHAR(128)
    , bankruptcy VARCHAR(1024)
    , bankruptcy_code VARCHAR(128)
    , borrowed_down_payment VARCHAR(1024)
    , borrowed_down_payment_code VARCHAR(128)
    , citizenship_residency VARCHAR(1024)
    , citizenship_residency_code VARCHAR(128)
    , disabled VARCHAR(1024)
    , disabled_code VARCHAR(128)
    , domestic_relationship_state VARCHAR(1024)
    , domestic_relationship_state_code VARCHAR(128)
    , alimony_child_support_explanation_flag BOOLEAN
    , bankruptcy_explanation_flag BOOLEAN
    , borrowed_down_payment_explanation_flag BOOLEAN
    , dependents VARCHAR(1024)
    , dependents_code VARCHAR(128)
    , note_endorser_explanation_flag BOOLEAN
    , obligated_loan_foreclosure_explanation_flag BOOLEAN
    , outstanding_judgments_explanation_flag BOOLEAN
    , party_to_lawsuit_explanation_flag BOOLEAN
    , presently_delinquent_explanation_flag BOOLEAN
    , property_foreclosure_explanation_flag BOOLEAN
    , homeowner_past_three_years VARCHAR(1024)
    , homeowner_past_three_years_code VARCHAR(128)
    , homeownership_education VARCHAR(1024)
    , homeownership_education_agency VARCHAR(1024)
    , homeownership_education_agency_code VARCHAR(128)
    , homeownership_education_code VARCHAR(128)
    , homeownership_education_complete_date DATE
    , intend_to_occupy VARCHAR(1024)
    , intend_to_occupy_code VARCHAR(128)
    , first_time_homebuyer_flag BOOLEAN
    , first_time_homebuyer_auto_compute_flag BOOLEAN
    , hud_employee_flag BOOLEAN
    , lender_employee_status_confirmed_flag BOOLEAN
    , lender_employee VARCHAR(1024)
    , lender_employee_code VARCHAR(128)
    , note_endorser VARCHAR(1024)
    , note_endorser_code VARCHAR(128)
    , obligated_loan_foreclosure VARCHAR(1024)
    , obligated_loan_foreclosure_code VARCHAR(128)
    , on_gsa_list VARCHAR(1024)
    , on_gsa_list_code VARCHAR(128)
    , on_ldp_list VARCHAR(1024)
    , on_ldp_list_code VARCHAR(128)
    , outstanding_judgements VARCHAR(1024)
    , outstanding_judgements_code VARCHAR(128)
    , party_to_lawsuit VARCHAR(1024)
    , party_to_lawsuit_code VARCHAR(128)
    , presently_delinquent VARCHAR(1024)
    , presently_delinquent_code VARCHAR(128)
    , property_foreclosure VARCHAR(1024)
    , property_foreclosure_code VARCHAR(128)
    , spousal_homestead VARCHAR(1024)
    , spousal_homestead_code VARCHAR(128)
    , titleholder VARCHAR(1024)
    , titleholder_code VARCHAR(128));
CREATE TABLE star_loan.interim_funder_dim (dwid BIGSERIAL NOT NULL CONSTRAINT pk_interim_funder_dim PRIMARY KEY
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , interim_funder_pid BIGINT NOT NULL
    , address_city VARCHAR(128)
    , address_country VARCHAR(1024)
    , address_country_code VARCHAR(128)
    , address_postal_code VARCHAR(128)
    , address_state VARCHAR(128)
    , address_street1 VARCHAR(128)
    , address_street2 VARCHAR(128)
    , contact_unparsed_name VARCHAR(128)
    , email VARCHAR(256)
    , fax VARCHAR(32)
    , fnm_payee_id VARCHAR(9)
    , fnm_warehouse_lender_id VARCHAR(32)
    , fre_warehouse_lender_id VARCHAR(32)
    , id VARCHAR(32)
    , mers_org_id VARCHAR(7)
    , mers_registration VARCHAR(1024)
    , mers_registration_code VARCHAR(128)
    , name VARCHAR(128)
    , office_phone VARCHAR(32)
    , office_phone_extension VARCHAR(16)
    , reimbursement_wire_attention_unparsed_name VARCHAR(128)
    , reimbursement_wire_authorized_signer_unparsed_name VARCHAR(128)
    , remarks VARCHAR(1024)
    , remibursement_wire_credit_to_name VARCHAR(128)
    , return_wire_attention_unparsed_name VARCHAR(128)
    , return_wire_authorized_signer_unparsed_name VARCHAR(128)
    , return_wire_credit_to_name VARCHAR(128)
    , from_date DATE
    , through_date DATE);
CREATE TABLE star_loan.investor_dim (dwid BIGSERIAL NOT NULL CONSTRAINT pk_investor_dim PRIMARY KEY
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , investor_pid BIGINT NOT NULL
    , allonge_transfer_to_name VARCHAR(128)
    , allows_weekend_holiday_locks_flag BOOLEAN
    , beneficiary_city VARCHAR(128)
    , beneficiary_country VARCHAR(1024)
    , beneficiary_country_code VARCHAR(128)
    , beneficiary_name VARCHAR(128)
    , beneficiary_postal_code VARCHAR(128)
    , beneficiary_state VARCHAR(128)
    , beneficiary_street1 VARCHAR(128)
    , beneficiary_street2 VARCHAR(128)
    , ein VARCHAR(10)
    , file_delivery_address_city VARCHAR(128)
    , file_delivery_address_country VARCHAR(1024)
    , file_delivery_address_country_code VARCHAR(128)
    , file_delivery_address_postal_code VARCHAR(128)
    , file_delivery_address_state VARCHAR(128)
    , file_delivery_address_street1 VARCHAR(128)
    , file_delivery_address_street2 VARCHAR(128)
    , file_delivery_name VARCHAR(128)
    , fnm_investor_remittance VARCHAR(1024)
    , fnm_investor_remittance_code VARCHAR(128)
    , fnm_mbs_investor_remittance_day_of_month INTEGER
    , fnm_mbs_loan_default_loss_party VARCHAR(1024)
    , fnm_mbs_loan_default_loss_party_code VARCHAR(128)
    , fnm_mbs_reo_marketing_party VARCHAR(1024)
    , fnm_mbs_reo_marketing_party_code VARCHAR(128)
    , fnma_servicer_id VARCHAR(16)
    , investor_city VARCHAR(128)
    , investor_country VARCHAR(1024)
    , investor_country_code VARCHAR(128)
    , investor_hmda_purchaser_of_loan VARCHAR(1024)
    , investor_hmda_purchaser_of_loan_code VARCHAR(128)
    , investor_id VARCHAR(32)
    , investor_lock_disable_time TIMETZ
    , investor_name VARCHAR(128)
    , investor_postal_code VARCHAR(128)
    , investor_state VARCHAR(128)
    , investor_street1 VARCHAR(128)
    , investor_street2 VARCHAR(128)
    , initial_beneficiary_candidate_flag BOOLEAN
    , initial_servicer_candidate_flag BOOLEAN
    , mbs_investor_flag BOOLEAN
    , loan_file_delivery_method VARCHAR(1024)
    , loan_file_delivery_method_code VARCHAR(128)
    , lock_expiration_delivery_subtrahend_days INTEGER
    , loss_payee_assignee_name VARCHAR(128)
    , loss_payee_city VARCHAR(128)
    , loss_payee_country VARCHAR(1024)
    , loss_payee_country_code VARCHAR(128)
    , loss_payee_name VARCHAR(128)
    , loss_payee_postal_code VARCHAR(128)
    , loss_payee_state VARCHAR(128)
    , loss_payee_street1 VARCHAR(128)
    , loss_payee_street2 VARCHAR(128)
    , maximum_lock_extension_days_allowed INTEGER
    , maximum_lock_extensions_allowed INTEGER
    , mers_org_id VARCHAR(7)
    , mers_org_member VARCHAR(128)
    , mortech_investor_id VARCHAR(16)
    , nmls_id VARCHAR(16)
    , nmls_id_applicable VARCHAR(128)
    , offers_secondary_financing_flag BOOLEAN
    , secondary_financing_source VARCHAR(1024)
    , secondary_financing_source_code VARCHAR(128)
    , servicer_address_city VARCHAR(128)
    , servicer_address_country VARCHAR(1024)
    , servicer_address_country_code VARCHAR(128)
    , servicer_address_postal_code VARCHAR(128)
    , servicer_address_state VARCHAR(128)
    , servicer_address_street1 VARCHAR(128)
    , servicer_address_street2 VARCHAR(128)
    , servicer_name VARCHAR(128)
    , sub_servicer_address_city VARCHAR(128)
    , sub_servicer_address_country VARCHAR(1024)
    , sub_servicer_address_country_code VARCHAR(128)
    , sub_servicer_address_postal_code VARCHAR(128)
    , sub_servicer_address_state VARCHAR(128)
    , sub_servicer_address_street1 VARCHAR(128)
    , sub_servicer_address_street2 VARCHAR(128)
    , sub_servicer_mers_org_id VARCHAR(7)
    , sub_servicer_name VARCHAR(128)
    , website_url VARCHAR(256)
    , when_recorded_mail_to_city VARCHAR(128)
    , when_recorded_mail_to_country VARCHAR(1024)
    , when_recorded_mail_to_country_code VARCHAR(128)
    , when_recorded_mail_to_name VARCHAR(128)
    , when_recorded_mail_to_postal_code VARCHAR(128)
    , when_recorded_mail_to_state VARCHAR(128)
    , when_recorded_mail_to_street1 VARCHAR(128)
    , when_recorded_mail_to_street2 VARCHAR(128));
CREATE TABLE star_loan.lender_user_dim (dwid BIGSERIAL NOT NULL CONSTRAINT pk_lender_user_dim PRIMARY KEY
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , lender_user_pid BIGINT NOT NULL
    , create_date DATE
    , about_me VARCHAR(2000)
    , city VARCHAR(128)
    , company_name VARCHAR(128)
    , company_user_id VARCHAR(32)
    , country VARCHAR(1024)
    , country_code VARCHAR(128)
    , default_credit_bureau VARCHAR(1024)
    , default_credit_bureau_code VARCHAR(128)
    , email VARCHAR(256)
    , fax VARCHAR(32)
    , fha_chums_id VARCHAR(16)
    , first_name VARCHAR(32)
    , hire_date DATE
    , account_owner_flag BOOLEAN
    , address_use_branch_flag BOOLEAN
    , allow_external_ip_flag BOOLEAN
    , esign_only_flag BOOLEAN
    , fax_use_branch_flag BOOLEAN
    , force_password_change_flag BOOLEAN
    , hub_directory_flag BOOLEAN
    , office_phone_use_branch_flag BOOLEAN
    , smart_app_enabled_flag BOOLEAN
    , training_mode_flag BOOLEAN
    , work_step_start_notices_enabled_flag BOOLEAN
    , last_name VARCHAR(32)
    , last_password_change_datetime TIMESTAMPTZ
    , middle_name VARCHAR(32)
    , name_qualifier VARCHAR(16)
    , name_suffix VARCHAR(32)
    , nickname VARCHAR(32)
    , nmls_loan_originator_id VARCHAR(16)
    , office_phone VARCHAR(32)
    , office_phone_extension VARCHAR(16)
    , originator_id VARCHAR(32)
    , postal_code VARCHAR(128)
    , preferred_first_name VARCHAR(32)
    , schedule_once_booking_page_id VARCHAR(128)
    , search_text VARCHAR(256)
    , state VARCHAR(128)
    , status VARCHAR(1024)
    , status_code VARCHAR(128)
    , street1 VARCHAR(128)
    , street2 VARCHAR(128)
    , time_zone VARCHAR(1024)
    , time_zone_code VARCHAR(128)
    , title VARCHAR(128)
    , total_workload_cap INTEGER
    , type VARCHAR(1024)
    , type_code VARCHAR(128)
    , unparsed_name VARCHAR(128)
    , username VARCHAR(32)
    , va_agent_id VARCHAR(32)
    , start_date DATE
    , through_date DATE);
CREATE TABLE star_loan.loan_beneficiary_dim (dwid BIGSERIAL NOT NULL CONSTRAINT pk_loan_beneficiary_dim PRIMARY KEY
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , loan_beneficiary_pid BIGINT NOT NULL
    , loan_pid BIGINT
    , collateral_courier VARCHAR(1024)
    , collateral_courier_code VARCHAR(128)
    , collateral_tracking_number VARCHAR(32)
    , delivery_aus VARCHAR(1024)
    , delivery_aus_code VARCHAR(128)
    , early_funding VARCHAR(1024)
    , early_funding_code VARCHAR(128)
    , investor_loan_id VARCHAR(32)
    , current_flag BOOLEAN
    , initial_flag BOOLEAN
    , mers_mom_flag BOOLEAN
    , mers_transfer_override_flag BOOLEAN
    , loan_file_courier VARCHAR(1024)
    , loan_file_courier_code VARCHAR(128)
    , loan_file_delivery_method VARCHAR(1024)
    , loan_file_delivery_method_code VARCHAR(128)
    , mers_transfer_status VARCHAR(1024)
    , mers_transfer_status_code VARCHAR(128)
    , pool_id VARCHAR(32)
    , transfer_status VARCHAR(1024)
    , transfer_status_code VARCHAR(128));
CREATE TABLE star_loan.loan_funding_dim (dwid BIGSERIAL NOT NULL CONSTRAINT pk_loan_funding_dim PRIMARY KEY
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , loan_funding_pid BIGINT NOT NULL
    , loan_pid BIGINT
    , interim_funder_pid BIGINT
    , collateral_courier VARCHAR(1024)
    , collateral_courier_code VARCHAR(128)
    , early_wire_charge_day_count INTEGER
    , early_wire_daily_charge_amount NUMERIC(21,3)
    , early_wire_total_charge_amount NUMERIC(21,3)
    , funding_confirmed_release_datetime TIMESTAMPTZ
    , funding_status VARCHAR(1024)
    , funding_status_code VARCHAR(128)
    , funds_authorization_code VARCHAR(32)
    , funds_authorized_datetime TIMESTAMPTZ
    , interim_funder_fee_amount NUMERIC(21,3)
    , interim_funder_loan_id VARCHAR(32)
    , early_wire_request_flag BOOLEAN
    , scheduled_release_date_auto_compute_flag BOOLEAN
    , net_wire_amount NUMERIC(21,3)
    , post_wire_adjustment_amount NUMERIC(21,3)
    , release_wire_federal_reference_number VARCHAR(32)
    , wire_amount NUMERIC(21,3));
CREATE TABLE star_loan.mortgage_insurance_dim (loan_dwid BIGSERIAL NOT NULL
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , loan_pid BIGINT NOT NULL
    , mi_auto_compute_flag BOOLEAN
    , mi_midpoint_cutoff_required_flag BOOLEAN
    , no_mi_product_flag BOOLEAN
    , mi_actual_monthly_payment_count INTEGER
    , mi_base_monthly_payment_amount NUMERIC(21,3)
    , mi_base_monthly_payment_annual_percent NUMERIC(15,9)
    , mi_base_rate_label VARCHAR(16000)
    , mi_base_upfront_payment_amount NUMERIC(21,3)
    , mi_base_upfront_percent NUMERIC(15,9)
    , mi_certificate_id VARCHAR(32)
    , mi_company VARCHAR(1024)
    , mi_company_code VARCHAR(128)
    , mi_coverage_percent NUMERIC(15,9)
    , mi_initial_calculated_rate VARCHAR(1024)
    , mi_initial_calculated_rate_code VARCHAR(128)
    , mi_initial_calculation VARCHAR(1024)
    , mi_initial_calculation_code VARCHAR(128)
    , mi_initial_duration_months INTEGER
    , mi_initial_monthly_payment_amount NUMERIC(21,3)
    , mi_initial_monthly_payment_annual_percent NUMERIC(15,9)
    , mi_input VARCHAR(1024)
    , mi_input_code VARCHAR(128)
    , mi_lender_paid_rate_adjustment_percent NUMERIC(15,9)
    , mi_ltv_cutoff_percent NUMERIC(15,9)
    , mi_payer VARCHAR(1024)
    , mi_payer_code VARCHAR(128)
    , mi_payment VARCHAR(1024)
    , mi_payment_code VARCHAR(128)
    , mi_premium_refundable VARCHAR(1024)
    , mi_premium_refundable_code VARCHAR(128)
    , mi_rate_quote_id VARCHAR(128)
    , mi_renewal_calcuated_rate VARCHAR(1024)
    , mi_renewal_calculated_rate_code VARCHAR(128)
    , mi_renewal_calculation VARCHAR(1024)
    , mi_renewal_calculation_code VARCHAR(128)
    , mi_renewal_monthly_payment_amount NUMERIC(21,3)
    , mi_renewal_monthly_payment_annual_percent NUMERIC(15,9)
    , mi_required_monthly_payment_count INTEGER
    , mi_upfront_amount NUMERIC(21,3)
    , mi_upront_percent NUMERIC(15,9));
CREATE TABLE star_loan.product_dim (dwid BIGSERIAL NOT NULL CONSTRAINT pk_product_dim PRIMARY KEY
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , product_pid BIGINT NOT NULL
    , investor_pid BIGINT
    , investor_product_id VARCHAR(32)
    , description VARCHAR(1024)
    , fnm_product_name VARCHAR(15)
    , fund_source VARCHAR(1024)
    , fund_source_code VARCHAR(128)
    , investor_product_name VARCHAR(128)
    , lock_auto_confirm_flag BOOLEAN
    , product_side VARCHAR(1024)
    , product_side_code VARCHAR(128)
    , from_date DATE
    , through_date DATE);
CREATE TABLE star_loan.product_terms_dim (dwid BIGSERIAL NOT NULL CONSTRAINT pk_product_terms_dim PRIMARY KEY
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , product_terms_pid BIGINT NOT NULL
    , product_pid BIGINT
    , amortization_term_months INTEGER
    , arm_convertible_from_month INTEGER
    , arm_convertible_through_month INTEGER
    , arm_floor_rate_percent NUMERIC(15,9)
    , arm_index VARCHAR(1024)
    , arm_index_code VARCHAR(128)
    , arm_lookback_period_days INTEGER
    , arm_payment_adjustment_calculation VARCHAR(1024)
    , arm_payment_adjustment_calculation_code VARCHAR(128)
    , buydown_base_date VARCHAR(1024)
    , buydown_base_date_code VARCHAR(128)
    , buydown_subsidy_calculation_code VARCHAR(128)
    , buydown_subsidy_calculation VARCHAR(1024)
    , community_lending VARCHAR(1024)
    , community_lending_code VARCHAR(128)
    , days_per_year VARCHAR(1024)
    , days_per_year_code VARCHAR(128)
    , decision_credit_score_calc VARCHAR(1024)
    , decision_credit_score_calc_code VARCHAR(128)
    , deed_page_count INTEGER
    , deferred_payment_months INTEGER
    , dsi_plan_code VARCHAR(128)
    , due_in_term_months INTEGER
    , escrow_cushion_months INTEGER
    , fha_rehab_program VARCHAR(1024)
    , fha_rehab_program_code VARCHAR(128)
    , fha_special_program VARCHAR(1024)
    , fha_special_program_code VARCHAR(128)
    , fnm_arm_plan VARCHAR(1024)
    , fnm_arm_plan_code VARCHAR(128)
    , fnm_community_lending_product VARCHAR(1024)
    , fnm_community_lending_product_code VARCHAR(128)
    , fre_community_program VARCHAR(1024)
    , fre_community_program_code VARCHAR(128)
    , from_date DATE
    , gpm_adjustment_percent NUMERIC(15,9)
    , gpm_adjustment_years INTEGER
    , conditions_to_assumability_flag BOOLEAN
    , demand_feature_flag BOOLEAN
    , lender_hazard_insurance_available_flag BOOLEAN
    , prepayment_charge_refund_flag BOOLEAN
    , heloc_cancel_fee_amount NUMERIC(21,3)
    , heloc_cancel_fee_applicable VARCHAR(1024)
    , heloc_cancel_fee_applicable_code VARCHAR(128)
    , heloc_cancel_fee_period_months INTEGER
    , heloc_draw_period_months INTEGER
    , heloc_maximum_initial_draw_amount NUMERIC(21,3)
    , heloc_minimum_draw_amount NUMERIC(21,3)
    , heloc_repayment_period_duration_months INTEGER
    , high_balance VARCHAR(1024)
    , high_balance_code VARCHAR(128)
    , initial_payment_adjustment_term_months INTEGER
    , initial_rate_adjustment_cap_percent NUMERIC(15,9)
    , initial_rate_adjustment_term_months INTEGER
    , ipc_calc VARCHAR(1024)
    , ipc_calc_code VARCHAR(128)
    , ipc_cltv_ratio_percent1 NUMERIC(15,9)
    , ipc_cltv_ratio_percent2 NUMERIC(15,9)
    , ipc_cltv_ratio_percent3 NUMERIC(15,9)
    , ipc_cltv_ratio_percent4 NUMERIC(15,9)
    , ipc_comparison_operator_code1 VARCHAR(128)
    , ipc_comparison_operator_code2 VARCHAR(128)
    , ipc_comparison_operator_code3 VARCHAR(128)
    , ipc_comparison_operator_code4 VARCHAR(128)
    , ipc_comparison_operator1 VARCHAR(1024)
    , ipc_comparison_operator2 VARCHAR(1024)
    , ipc_comparison_operator3 VARCHAR(1024)
    , ipc_comparison_operator4 VARCHAR(1024)
    , ipc_limit_percent1 NUMERIC(15,9)
    , ipc_limit_percent2 NUMERIC(15,9)
    , ipc_limit_percent3 NUMERIC(15,9)
    , ipc_limit_percent4 NUMERIC(15,9)
    , ipc_property_usage_code1 VARCHAR(128)
    , ipc_property_usage_code2 VARCHAR(128)
    , ipc_property_usage_code3 VARCHAR(128)
    , ipc_property_usage_code4 VARCHAR(128)
    , ipc_property_usage1 VARCHAR(1024)
    , ipc_property_usage2 VARCHAR(1024)
    , ipc_property_usage3 VARCHAR(1024)
    , ipc_property_usage4 VARCHAR(1024)
    , allow_loan_amount_cents_flag BOOLEAN
    , always_current_market_price_flag BOOLEAN
    , arm_convertible_flag BOOLEAN
    , assumable_flag BOOLEAN
    , credit_qualifying_flag BOOLEAN
    , du_risk_assessment_accepted_flag BOOLEAN
    , escrow_waiver_allowed_flag BOOLEAN
    , external_fha_underwrite_accepted_flag BOOLEAN
    , external_investor_underwrite_accepted_flag BOOLEAN
    , external_usda_underwrite_accepted_flag BOOLEAN
    , external_va_underwrite_accepted_flag BOOLEAN
    , family_advantage_flag BOOLEAN
    , heloc_maximum_initial_draw_flag BOOLEAN
    , heloc_minimum_draw_flag BOOLEAN
    , internal_underwrite_accepted_flag BOOLEAN
    , loan_requires_hazard_insurance_flag BOOLEAN
    , lp_risk_assessment_accepted_flag BOOLEAN
    , manual_risk_assessment_accepted_flag BOOLEAN
    , mortgage_credit_certificate_eligible_flag BOOLEAN
    , new_york_flag BOOLEAN
    , no_mi_product_flag BOOLEAN
    , non_conforming_flag BOOLEAN
    , rate_protect_flag BOOLEAN
    , texas_veterans_land_board VARCHAR(1024)
    , texas_veterans_land_board_code VARCHAR(128)
    , third_party_grant_eligible_flag BOOLEAN
    , zero_note_rate_flag BOOLEAN
    , lender_hazard_insurance_premium_amount NUMERIC(21,3)
    , lender_hazard_insurance_term_months INTEGER
    , lien_priority VARCHAR(1024)
    , lien_priority_code VARCHAR(128)
    , loan_amortization VARCHAR(1024)
    , loan_amortization_code VARCHAR(128)
    , minimum_payment_rate_percent NUMERIC(15,9)
    , minimum_rate_term_months INTEGER
    , mortgage_type VARCHAR(1024)
    , mortgage_type_code VARCHAR(128)
    , negative_amortization VARCHAR(1024)
    , negative_amortization_code VARCHAR(128)
    , negative_amortization_limit_percent NUMERIC(15,9)
    , negative_amortization_recast_period_months INTEGER
    , partial_payment_policy VARCHAR(1024)
    , partial_payment_policy_code VARCHAR(128)
    , payment_adjustment_lifetime_cap_percent NUMERIC(15,9)
    , payment_adjustment_periodic_cap NUMERIC(15,9)
    , payment_frequency VARCHAR(1024)
    , payment_frequency_code VARCHAR(128)
    , payment_structure VARCHAR(1024)
    , payment_structure_code VARCHAR(128)
    , prepaid_interest_rate VARCHAR(1024)
    , prepaid_interest_rate_code VARCHAR(128)
    , prepay_penalty VARCHAR(1024)
    , prepay_penalty_code VARCHAR(128)
    , product_appraisal_requirement VARCHAR(1024)
    , product_appraisal_requirement_code VARCHAR(128)
    , product_category VARCHAR(128)
    , product_special_program VARCHAR(1024)
    , product_special_program_code VARCHAR(128)
    , qualifying_monthly_payment VARCHAR(1024)
    , qualifying_monthly_payment_code VARCHAR(128)
    , qualifying_rate VARCHAR(1024)
    , qualifying_rate_code VARCHAR(128)
    , qualifying_rate_input_percent NUMERIC(15,9)
    , rate_adjustment_lifetime_cap_percent NUMERIC(15,9)
    , section_of_act_coarse VARCHAR(1024)
    , section_of_act_coarse_code VARCHAR(128)
    , security_instrument_page_count INTEGER
    , servicing_transfer VARCHAR(1024)
    , servicing_transfer_code VARCHAR(128)
    , subsequent_payment_adjustment_term_months INTEGER
    , subsequent_rate_adjustment_cap_percent NUMERIC(15,9)
    , subsequent_rate_adjustment_term_months INTEGER
    , third_party_community_second_program_eligibility VARCHAR(1024)
    , third_party_community_second_program_eligibility_code VARCHAR(128));
CREATE TABLE star_loan.application_dim (dwid BIGSERIAL NOT NULL CONSTRAINT pk_application_dim PRIMARY KEY
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , application_pid BIGINT NOT NULL
    , proposal_pid BIGINT);
CREATE TABLE star_loan.transaction_dim (dwid BIGSERIAL NOT NULL CONSTRAINT pk_transaction_dim PRIMARY KEY
    , data_source_dwid BIGINT NOT NULL
    , edw_created_datetime TIMESTAMPTZ
    , edw_modified_datetime TIMESTAMPTZ
    , etl_batch_id TEXT
    , data_source_integration_columns TEXT
    , data_source_integration_id TEXT NOT NULL
    , data_source_modified_datetime TIMESTAMPTZ
    , deal_pid BIGINT
    , active_proposal_pid BIGINT);

CREATE INDEX idx_loan_fact__loan_pid ON star_loan.loan_fact (loan_pid);
CREATE INDEX idx_loan_fact__loan_junk_dwid ON star_loan.loan_fact (loan_junk_dwid);
CREATE INDEX idx_loan_fact__product_choices_dwid ON star_loan.loan_fact (product_choices_dwid);
CREATE INDEX idx_loan_fact__transaction_dwid ON star_loan.loan_fact (transaction_dwid);
CREATE INDEX idx_loan_fact__transaction_junk_dwid ON star_loan.loan_fact (transaction_junk_dwid);
CREATE INDEX idx_loan_fact__loan_beneficiary_dwid ON star_loan.loan_fact (loan_beneficiary_dwid);
CREATE INDEX idx_loan_fact__loan_funding_dwid ON star_loan.loan_fact (loan_funding_dwid);
CREATE INDEX idx_loan_fact__b1_borrower_dwid ON star_loan.loan_fact (b1_borrower_dwid);
CREATE INDEX idx_loan_fact__b2_borrower_dwid ON star_loan.loan_fact (b2_borrower_dwid);
CREATE INDEX idx_loan_fact__b3_borrower_dwid ON star_loan.loan_fact (b3_borrower_dwid);
CREATE INDEX idx_loan_fact__b4_borrower_dwid ON star_loan.loan_fact (b4_borrower_dwid);
CREATE INDEX idx_loan_fact__b5_borrower_dwid ON star_loan.loan_fact (b5_borrower_dwid);
CREATE INDEX idx_loan_fact__c1_borrower_dwid ON star_loan.loan_fact (c1_borrower_dwid);
CREATE INDEX idx_loan_fact__c2_borrower_dwid ON star_loan.loan_fact (c2_borrower_dwid);
CREATE INDEX idx_loan_fact__c3_borrower_dwid ON star_loan.loan_fact (c3_borrower_dwid);
CREATE INDEX idx_loan_fact__c4_borrower_dwid ON star_loan.loan_fact (c4_borrower_dwid);
CREATE INDEX idx_loan_fact__c5_borrower_dwid ON star_loan.loan_fact (c5_borrower_dwid);
CREATE INDEX idx_loan_fact__n1_borrower_dwid ON star_loan.loan_fact (n1_borrower_dwid);
CREATE INDEX idx_loan_fact__n2_borrower_dwid ON star_loan.loan_fact (n2_borrower_dwid);
CREATE INDEX idx_loan_fact__n3_borrower_dwid ON star_loan.loan_fact (n3_borrower_dwid);
CREATE INDEX idx_loan_fact__n4_borrower_dwid ON star_loan.loan_fact (n4_borrower_dwid);
CREATE INDEX idx_loan_fact__n5_borrower_dwid ON star_loan.loan_fact (n5_borrower_dwid);
CREATE INDEX idx_loan_fact__n6_borrower_dwid ON star_loan.loan_fact (n6_borrower_dwid);
CREATE INDEX idx_loan_fact__n7_borrower_dwid ON star_loan.loan_fact (n7_borrower_dwid);
CREATE INDEX idx_loan_fact__n8_borrower_dwid ON star_loan.loan_fact (n8_borrower_dwid);
CREATE INDEX idx_loan_fact__b1_borrower_demographics_dwid ON star_loan.loan_fact (b1_borrower_demographics_dwid);
CREATE INDEX idx_loan_fact__b1_borrower_lending_profile_dwid ON star_loan.loan_fact (b1_borrower_lending_profile_dwid);
CREATE INDEX idx_loan_fact__application_dwid ON star_loan.loan_fact (application_dwid);
CREATE INDEX idx_loan_fact__collateral_to_custodian_lender_user_dwid ON star_loan.loan_fact (collateral_to_custodian_lender_user_dwid);
CREATE INDEX idx_loan_fact__interim_funder_dwid ON star_loan.loan_fact (interim_funder_dwid);
CREATE INDEX idx_loan_fact__product_terms_dwid ON star_loan.loan_fact (product_terms_dwid);
CREATE INDEX idx_loan_fact__product_dwid ON star_loan.loan_fact (product_dwid);
CREATE INDEX idx_loan_fact__investor_dwid ON star_loan.loan_fact (investor_dwid);
CREATE INDEX idx_loan_fact__hmda_purchaser_of_loan_dwid ON star_loan.loan_fact (hmda_purchaser_of_loan_dwid);
CREATE INDEX idx_loan_fact__agency_case_id_assigned_date_dwid ON star_loan.loan_fact (agency_case_id_assigned_date_dwid);
CREATE INDEX idx_loan_fact__apor_date_dwid ON star_loan.loan_fact (apor_date_dwid);
CREATE INDEX idx_loan_fact__application_signed_date_dwid ON star_loan.loan_fact (application_signed_date_dwid);
CREATE INDEX idx_loan_fact__approved_with_conditions_date_dwid ON star_loan.loan_fact (approved_with_conditions_date_dwid);
CREATE INDEX idx_loan_fact__beneficiary_from_date_dwid ON star_loan.loan_fact (beneficiary_from_date_dwid);
CREATE INDEX idx_loan_fact__beneficiary_through_date_dwid ON star_loan.loan_fact (beneficiary_through_date_dwid);
CREATE INDEX idx_loan_fact__collateral_sent_date_dwid ON star_loan.loan_fact (collateral_sent_date_dwid);
CREATE INDEX idx_loan_fact__disbursement_date_dwid ON star_loan.loan_fact (disbursement_date_dwid);
CREATE INDEX idx_loan_fact__early_funding_date_dwid ON star_loan.loan_fact (early_funding_date_dwid);
CREATE INDEX idx_loan_fact__effective_funding_date_dwid ON star_loan.loan_fact (effective_funding_date_dwid);
CREATE INDEX idx_loan_fact__fha_endorsement_date_dwid ON star_loan.loan_fact (fha_endorsement_date_dwid);
CREATE INDEX idx_loan_fact__estimated_funding_date_dwid ON star_loan.loan_fact (estimated_funding_date_dwid);
CREATE INDEX idx_loan_fact__intent_to_proceed_date_dwid ON star_loan.loan_fact (intent_to_proceed_date_dwid);
CREATE INDEX idx_loan_fact__funding_date_dwid ON star_loan.loan_fact (funding_date_dwid);
CREATE INDEX idx_loan_fact__funding_requested_date_dwid ON star_loan.loan_fact (funding_requested_date_dwid);
CREATE INDEX idx_loan_fact__loan_file_ship_date_dwid ON star_loan.loan_fact (loan_file_ship_date_dwid);
CREATE INDEX idx_loan_fact__mers_transfer_creation_date_dwid ON star_loan.loan_fact (mers_transfer_creation_date_dwid);
CREATE INDEX idx_loan_fact__pending_wire_date_dwid ON star_loan.loan_fact (pending_wire_date_dwid);
CREATE INDEX idx_loan_fact__rejected_date_dwid ON star_loan.loan_fact (rejected_date_dwid);
CREATE INDEX idx_loan_fact__return_confirmed_date_dwid ON star_loan.loan_fact (return_confirmed_date_dwid);
CREATE INDEX idx_loan_fact__return_request_date_dwid ON star_loan.loan_fact (return_request_date_dwid);
CREATE INDEX idx_loan_fact__scheduled_release_date_dwid ON star_loan.loan_fact (scheduled_release_date_dwid);
CREATE INDEX idx_loan_fact__usda_guarantee_date_dwid ON star_loan.loan_fact (usda_guarantee_date_dwid);
CREATE INDEX idx_loan_fact__va_guaranty_date_dwid ON star_loan.loan_fact (va_guaranty_date_dwid);
CREATE INDEX idx_loan_dim__loan_pid ON star_loan.loan_dim (loan_pid);
CREATE INDEX idx_loan_dim__proposal_pid ON star_loan.loan_dim (proposal_pid);
CREATE INDEX idx_loan_dim__product_terms_pid ON star_loan.loan_dim (product_terms_pid);
CREATE INDEX idx_loan_dim__los_loan_number ON star_loan.loan_dim (los_loan_number);
CREATE INDEX idx_loan_junk_dim__lien_priority ON star_loan.loan_junk_dim (lien_priority);
CREATE INDEX idx_product_choice_dim__mortgage_type ON star_loan.product_choice_dim (mortgage_type);
CREATE INDEX idx_transaction_junk_dim__structure ON star_loan.transaction_junk_dim (structure);
CREATE INDEX idx_borrower_dim__borrower_pid ON star_loan.borrower_dim (borrower_pid);
CREATE INDEX idx_borrower_dim__application_pid ON star_loan.borrower_dim (application_pid);
CREATE INDEX idx_borrower_dim__applicant_role ON star_loan.borrower_dim (applicant_role);
CREATE INDEX idx_borrower_dim__decision_credit_score ON star_loan.borrower_dim (decision_credit_score);
CREATE INDEX idx_borrower_dim__tiny_id ON star_loan.borrower_dim (tiny_id);
CREATE INDEX idx_borrower_lending_profile_dim__lender_employee ON star_loan.borrower_lending_profile_dim (lender_employee);
CREATE INDEX idx_interim_funder_dim__interim_funder_pid ON star_loan.interim_funder_dim (interim_funder_pid);
CREATE INDEX idx_interim_funder_dim__name ON star_loan.interim_funder_dim (name);
CREATE INDEX idx_investor_dim__investor_pid ON star_loan.investor_dim (investor_pid);
CREATE INDEX idx_investor_dim__beneficiary_name ON star_loan.investor_dim (beneficiary_name);
CREATE INDEX idx_investor_dim__investor_name ON star_loan.investor_dim (investor_name);
CREATE INDEX idx_investor_dim__nmls_id ON star_loan.investor_dim (nmls_id);
CREATE INDEX idx_investor_dim__servicer_name ON star_loan.investor_dim (servicer_name);
CREATE INDEX idx_lender_user_dim__lender_user_pid ON star_loan.lender_user_dim (lender_user_pid);
CREATE INDEX idx_lender_user_dim__nmls_loan_originator_id ON star_loan.lender_user_dim (nmls_loan_originator_id);
CREATE INDEX idx_lender_user_dim__status ON star_loan.lender_user_dim (status);
CREATE INDEX idx_lender_user_dim__type ON star_loan.lender_user_dim (type);
CREATE INDEX idx_lender_user_dim__unparsed_name ON star_loan.lender_user_dim (unparsed_name);
CREATE INDEX idx_lender_user_dim__start_date ON star_loan.lender_user_dim (start_date);
CREATE INDEX idx_lender_user_dim__through_date ON star_loan.lender_user_dim (through_date);
CREATE INDEX idx_loan_beneficiary_dim__loan_beneficiary_pid ON star_loan.loan_beneficiary_dim (loan_beneficiary_pid);
CREATE INDEX idx_loan_beneficiary_dim__loan_pid ON star_loan.loan_beneficiary_dim (loan_pid);
CREATE INDEX idx_loan_beneficiary_dim__transfer_status ON star_loan.loan_beneficiary_dim (transfer_status);
CREATE INDEX idx_loan_funding_dim__loan_funding_pid ON star_loan.loan_funding_dim (loan_funding_pid);
CREATE INDEX idx_loan_funding_dim__loan_pid ON star_loan.loan_funding_dim (loan_pid);
CREATE INDEX idx_loan_funding_dim__interim_funder_pid ON star_loan.loan_funding_dim (interim_funder_pid);
CREATE INDEX idx_loan_funding_dim__funding_status ON star_loan.loan_funding_dim (funding_status);
CREATE INDEX idx_mortgage_insurance_dim__loan_pid ON star_loan.mortgage_insurance_dim (loan_pid);
CREATE INDEX idx_product_dim__product_pid ON star_loan.product_dim (product_pid);
CREATE INDEX idx_product_dim__investor_pid ON star_loan.product_dim (investor_pid);
CREATE INDEX idx_product_dim__fund_source ON star_loan.product_dim (fund_source);
CREATE INDEX idx_product_dim__product_side ON star_loan.product_dim (product_side);
CREATE INDEX idx_product_terms_dim__product_terms_pid ON star_loan.product_terms_dim (product_terms_pid);
CREATE INDEX idx_product_terms_dim__product_pid ON star_loan.product_terms_dim (product_pid);
CREATE INDEX idx_product_terms_dim__high_balance ON star_loan.product_terms_dim (high_balance);
CREATE INDEX idx_product_terms_dim__lien_priority ON star_loan.product_terms_dim (lien_priority);
CREATE INDEX idx_product_terms_dim__loan_amortization ON star_loan.product_terms_dim (loan_amortization);
CREATE INDEX idx_product_terms_dim__mortgage_type ON star_loan.product_terms_dim (mortgage_type);
CREATE INDEX idx_product_terms_dim__product_special_program ON star_loan.product_terms_dim (product_special_program);
CREATE INDEX idx_application_dim__application_pid ON star_loan.application_dim (application_pid);
CREATE INDEX idx_application_dim__proposal_pid ON star_loan.application_dim (proposal_pid);
CREATE INDEX idx_transaction_dim__deal_pid ON star_loan.transaction_dim (deal_pid);
CREATE INDEX idx_transaction_dim__active_proposal_pid ON star_loan.transaction_dim (active_proposal_pid);
