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
    , deal_pid BIGINT NOT NULL
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


--
--  BI - EDW | schema history_octane - Create initial DDL (https://app.asana.com/0/0/1200124472993448)
--

CREATE TABLE history_octane.account_event_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.account_id_sequence
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ais_id BIGINT NOT NULL
);

CREATE TABLE history_octane.account_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.account
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    a_pid BIGINT NOT NULL,
    a_version INTEGER,
    a_account_id BIGINT,
    a_account_name VARCHAR(128),
    a_gfe_interest_rate_expiration_days INTEGER,
    a_gfe_lock_duration_days INTEGER,
    a_gfe_lock_before_settlement_days INTEGER,
    a_proposal_expiration_days INTEGER,
    a_uw_expiration_days INTEGER,
    a_conditional_commitment_expiration_days INTEGER,
    a_account_from_date DATE,
    a_account_status_type VARCHAR(128),
    a_account_through_date DATE,
    a_initial_los_loan_id BIGINT,
    a_uuts_master_contact_name VARCHAR(128),
    a_uuts_master_contact_title VARCHAR(128),
    a_uuts_master_office_phone VARCHAR(16),
    a_uuts_master_office_phone_extension VARCHAR(32),
    a_allonge_representative_name VARCHAR(128),
    a_allonge_representative_title VARCHAR(128),
    a_account_borrower_site_id VARCHAR(128),
    a_originator_borrower_sites_enabled BIT,
    a_company_borrower_site_enabled BIT,
    a_discount_included_in_origination_fee BIT,
    a_uuts_use_master_contact BIT,
    a_borrower_job_gap_lookback_years INTEGER,
    a_borrower_job_gap_minimum_days INTEGER,
    a_lender_app_host VARCHAR(256),
    a_lender_app_ip_address VARCHAR(32),
    a_advance_period_days INTEGER,
    a_account_destroy_mode BIT,
    a_lender_user_password_expire_days INTEGER,
    a_lender_user_password_minimum_change_days INTEGER,
    a_lender_user_previous_password_ban INTEGER,
    a_paid_through_current_month_required_day_of_month INTEGER,
    a_disclosure_change_threshold_cash_to_close NUMERIC(15, 2),
    a_disclosure_change_threshold_monthly_payment NUMERIC(15, 2),
    a_disclosure_action_required_days INTEGER,
    a_le_to_cd_seasoning_days INTEGER,
    a_disclosure_max_arm_apr_change_percent NUMERIC(11, 9),
    a_disclosure_max_non_arm_apr_change_percent NUMERIC(11, 9),
    a_initial_le_delivered_mailed_seasoning_days INTEGER,
    a_revised_le_delivered_mailed_seasoning_days INTEGER,
    a_revised_le_received_signed_seasoning_days INTEGER,
    a_significant_cd_delivered_mailed_seasoning_days INTEGER,
    a_significant_cd_received_signed_seasoning_days INTEGER,
    a_supported_states TEXT
);

CREATE TABLE history_octane.account_event
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ae_pid BIGINT NOT NULL,
    ae_version INTEGER,
    ae_account_pid BIGINT,
    ae_create_datetime TIMESTAMP,
    ae_account_event_type VARCHAR(128),
    ae_detail VARCHAR(16000),
    ae_source_unparsed_name VARCHAR(128),
    ae_ip_address VARCHAR(32),
    ae_client_agent VARCHAR(256)
);

CREATE TABLE history_octane.admin_user_event_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.admin_user_event
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    aue_pid BIGINT NOT NULL,
    aue_version INTEGER,
    aue_create_datetime TIMESTAMP,
    aue_detail VARCHAR(16000),
    aue_source_unparsed_name VARCHAR(128),
    aue_admin_user_event_type VARCHAR(128),
    aue_ip_address VARCHAR(32),
    aue_client_agent VARCHAR(256)
);

CREATE TABLE history_octane.admin_user_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.agency_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.agent_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.announcement
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ann_pid BIGINT NOT NULL,
    ann_version INTEGER,
    ann_lender_text VARCHAR(1024),
    ann_borrower_text VARCHAR(1024),
    ann_from_datetime TIMESTAMP,
    ann_to_datetime TIMESTAMP
);

CREATE TABLE history_octane.annual_monthly_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.applicant_role_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.application_taken_method_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.application_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.appraisal_condition_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.appraisal_entry_contact_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.appraisal_file_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.appraisal_form_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.appraisal_hold_reason_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.appraisal_hold_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.appraisal_management_company_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.appraisal_order_coarse_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.appraisal_order_request_file_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.appraisal_order_request_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.appraisal_order_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.appraisal_purpose_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.appraisal_source_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.appraisal_underwriter_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.area_median_income_table
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    amit_pid BIGINT NOT NULL,
    amit_version INTEGER,
    amit_account_pid BIGINT,
    amit_from_date DATE,
    amit_uploader_unparsed_name VARCHAR(128),
    amit_upload_datetime TIMESTAMP
);

CREATE TABLE history_octane.arm_index_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.arm_index_rate
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    air_pid BIGINT NOT NULL,
    air_version INTEGER,
    air_arm_index_type VARCHAR(128),
    air_effective_datetime TIMESTAMP,
    air_rate NUMERIC(11, 9)
);

CREATE TABLE history_octane.asset_account_holder_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.asset_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.aus_credit_service_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.aus_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.backfill_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.bankruptcy_exception_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.bid_pool_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.bid_pool
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bp_pid BIGINT NOT NULL,
    bp_version INTEGER,
    bp_account_pid BIGINT,
    bp_bid_pool_name VARCHAR(32),
    bp_bid_pool_status_type VARCHAR(128),
    bp_create_datetime DATE
);

CREATE TABLE history_octane.borrower_associated_address_explanation_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);
-- TODO: make the name shorter than 63 bytes
-- TODO: make the name shorter than 63 bytes

CREATE TABLE history_octane.borrower_associated_address_source_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);
-- TODO: make the name shorter than 63 bytes
-- TODO: make the name shorter than 63 bytes

CREATE TABLE history_octane.borrower_income_category_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.borrower_relationship_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.borrower_residency_basis_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.borrower_tiny_id_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.borrower_user_account_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.borrower_user_deal_access_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.branch_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.building_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.business_disposition_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.business_income_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.business_ownership_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.buydown_base_date_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.buydown_contributor_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.buydown_schedule_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.buydown_subsidy_calculation_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.calendar_rule_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.challenge_question_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.channel_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.channel
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ch_pid BIGINT NOT NULL,
    ch_version INTEGER,
    ch_account_pid BIGINT,
    ch_id VARCHAR(32),
    ch_name VARCHAR(128),
    ch_channel_type VARCHAR(128)
);

CREATE TABLE history_octane.charge_input_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.charge_payee_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.charge_payer_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.charge_source_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.charge_wire_action_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.circumstance_change_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.citizenship_residency_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.clg_flood_cert_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.closing_document_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.coarse_event_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.community_lending_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.company_admin_event_entity_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.company_admin_event
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cae_pid BIGINT NOT NULL,
    cae_version INTEGER,
    cae_account_pid BIGINT,
    cae_company_admin_event_entity_type VARCHAR(128),
    cae_message VARCHAR(256),
    cae_diff_list TEXT,
    cae_unparsed_name VARCHAR(128),
    cae_event_date DATE,
    cae_event_datetime TIMESTAMP,
    cae_target_entity_pid BIGINT
);

CREATE TABLE history_octane.company_state_license_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.config_export_permission_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.construction_cost_category_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.construction_cost_funding_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.construction_cost_payee_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.construction_cost_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.construction_draw_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.construction_draw_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.construction_lot_ownership_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.consumer_privacy_request_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.cost_center
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cosc_pid BIGINT NOT NULL,
    cosc_version INTEGER,
    cosc_account_pid BIGINT,
    cosc_amb_code VARCHAR(16),
    cosc_name VARCHAR(128),
    cosc_comments VARCHAR(1024),
    cosc_active BIT
);

CREATE TABLE history_octane.country_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.account_contact
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ac_pid BIGINT NOT NULL,
    ac_version INTEGER,
    ac_account_pid BIGINT,
    ac_unparsed_name VARCHAR(128),
    ac_note VARCHAR(256),
    ac_search_text VARCHAR(256),
    ac_tags VARCHAR(256),
    ac_first_name VARCHAR(32),
    ac_middle_name VARCHAR(32),
    ac_last_name VARCHAR(32),
    ac_name_suffix VARCHAR(32),
    ac_company_name VARCHAR(128),
    ac_title VARCHAR(128),
    ac_office_phone VARCHAR(32),
    ac_office_phone_extension VARCHAR(16),
    ac_mobile_phone VARCHAR(32),
    ac_email VARCHAR(256),
    ac_fax VARCHAR(32),
    ac_address_street1 VARCHAR(128),
    ac_address_street2 VARCHAR(128),
    ac_address_city VARCHAR(128),
    ac_address_state VARCHAR(128),
    ac_address_postal_code VARCHAR(128),
    ac_address_country VARCHAR(128),
    ac_home_phone VARCHAR(32),
    ac_closing_document_email VARCHAR(256),
    ac_license_number VARCHAR(128),
    ac_supervisory_license_number VARCHAR(128),
    ac_license_state VARCHAR(128)
);

CREATE TABLE history_octane.courier_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.credit_authorization_method_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.credit_bureau_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.credit_business_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.credit_inquiry_explanation_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.credit_inquiry_result_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.credit_limit_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.credit_loan_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.credit_report_request_action_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.credit_report_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.credit_request_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.credit_request_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.credit_request_via_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.credit_score_model_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.criteria
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cr_pid BIGINT NOT NULL,
    cr_version INTEGER,
    cr_account_pid BIGINT,
    cr_criteria_source VARCHAR(16000),
    cr_criteria_sql VARCHAR(16000),
    cr_criteria_owner_instance_name VARCHAR(2048),
    cr_criteria_source_html TEXT,
    cr_criteria_source_pretty_text TEXT
);

CREATE TABLE history_octane.criteria_owner_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.criteria_pid_operand_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.custodian
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cu_pid BIGINT NOT NULL,
    cu_version INTEGER,
    cu_account_pid BIGINT,
    cu_custodian_id VARCHAR(32),
    cu_custodian_name VARCHAR(128),
    cu_address_street1 VARCHAR(128),
    cu_address_street2 VARCHAR(128),
    cu_address_city VARCHAR(128),
    cu_address_state VARCHAR(128),
    cu_address_postal_code VARCHAR(128),
    cu_address_country VARCHAR(128),
    cu_custodian_phone VARCHAR(32),
    cu_custodian_mers_org_id VARCHAR(7),
    cu_whole_loan_fin VARCHAR(11),
    cu_mbs_loan_fin VARCHAR(11),
    cu_register_with_mers BIT
);

CREATE TABLE history_octane.days_per_year_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_cancel_reason_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_change_updater_time
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dcut_pid BIGINT NOT NULL,
    dcut_version INTEGER,
    dcut_account_pid BIGINT,
    dcut_los_loan_id_main BIGINT,
    dcut_start_time TIMESTAMP,
    dcut_start_date DATE,
    dcut_overall_duration_ms BIGINT,
    dcut_deal_checks_ms BIGINT,
    dcut_deal_updates_ms BIGINT,
    dcut_proposal_updates_ms BIGINT,
    dcut_num_proposal_updates INTEGER,
    dcut_application_updates_ms BIGINT,
    dcut_num_application_updates INTEGER,
    dcut_borrower_updates_ms BIGINT,
    dcut_num_borrower_updates INTEGER,
    dcut_place_updates_ms BIGINT,
    dcut_num_place_updates INTEGER,
    dcut_loan_updates_ms BIGINT,
    dcut_num_loan_updates INTEGER,
    dcut_proposal_updates_after_loan_updates_ms BIGINT,
    dcut_updates_after_proposal_updates_ms BIGINT,
    dcut_proposal_summary_updates_ms BIGINT,
    dcut_deal_updates_after_all_proposal_updates_ms BIGINT,
    dcut_smart_charge_update_ms BIGINT,
    dcut_circumstance_change_updates_ms BIGINT,
    dcut_num_circumstance_change_updates INTEGER,
    dcut_tolerance_cure_update_ms BIGINT,
    dcut_proposal_summary_updates_after_smart_charge_updates_ms BIGINT,
    dcut_update_doc_sets_ms BIGINT,
    dcut_closing_funds_itemization_ms BIGINT,
    dcut_update_ribbon_for_deal_ms BIGINT,
    dcut_num_construction_draw_updates INTEGER,
    dcut_construction_draw_updates_ms BIGINT
);

CREATE TABLE history_octane.deal_check_severity_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_check_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_child_relationship_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_child_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.criteria_snippet
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    crs_pid BIGINT NOT NULL,
    crs_version INTEGER,
    crs_account_pid BIGINT,
    crs_name VARCHAR(35),
    crs_criteria_pid BIGINT,
    crs_description VARCHAR(16000),
    crs_deal_child_type VARCHAR(128),
    crs_compatible_with_smart_charge_case BIT,
    crs_compatible_with_smart_req BIT,
    crs_compatible_with_stack_separator BIT,
    crs_compatible_with_investor_eligibility BIT,
    crs_compatible_with_wf_smart_task BIT,
    crs_compatible_with_wf_outcome BIT,
    crs_compatible_with_wf_smart_process BIT,
    crs_compatible_with_smart_doc BIT
);

CREATE TABLE history_octane.deal_contact_role_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_context_permission_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_create_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_event_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_id_sequence
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dis_id BIGINT NOT NULL
);

CREATE TABLE history_octane.deal_invoice_file_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_invoice_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_note_scope_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_orphan_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_stage_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_tag_access_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_tag_level_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.deal_tag_definition
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dtd_pid BIGINT NOT NULL,
    dtd_version INTEGER,
    dtd_account_pid BIGINT,
    dtd_tag_name VARCHAR(32),
    dtd_deal_tag_level_type VARCHAR(128),
    dtd_deal_tag_access_type VARCHAR(128)
);

CREATE TABLE history_octane.deal_task_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.decision_credit_score_calc_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.delivery_aus_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.disaster_declaration_check_date_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.doc_action_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.doc_approval_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.doc_borrower_access_mode_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.doc_category_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.doc_external_provider_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.doc_file_source_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.doc_fulfill_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.doc_key_date_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.doc_level_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.doc_package_canceled_reason_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.doc_package_delivery_method_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.doc_package_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.doc_permission_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.doc_set_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.doc_validity_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.document_import_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.document_import_vendor_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.du_key_finding_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.du_recommendation_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.du_request_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.dw_export_request_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.ecoa_denial_reason_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.effective_property_value_explanation_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.effective_property_value_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.email_closing_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.ernst_deed_request_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.ernst_page_rec_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.ernst_request_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.ernst_security_instrument_request_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.esign_package_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.esign_vendor_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.export_permission_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.export_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.external_entity_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fault_tolerant_event_registration
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    fter_message_id VARCHAR(128) NOT NULL,
    fter_queue_name VARCHAR(128),
    fter_event_type VARCHAR(128),
    fter_create_datetime TIMESTAMP,
    fter_processed_datetime TIMESTAMP
);

CREATE TABLE history_octane.fema_flood_zone_designation_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fha_non_arms_length_ltv_limit_exception_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fha_program_code_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fha_rehab_program_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fha_special_program_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fha_va_bor_cert_sales_price_exceeds_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.field_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.flood_cert_vendor_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.flood_certificate_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fnm_arm_plan_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fnm_community_lending_product_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fnm_community_seconds_repayment_structure_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fnm_investor_remittance_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fnm_mbs_loan_default_loss_party_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fnm_mbs_reo_marketing_party_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.for_further_credit_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fre_community_program_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fre_ctp_closing_feature_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fre_ctp_closing_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fre_doc_level_description_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fre_purchase_eligibility_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.fund_source_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.funding_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024),
    fst_ordinal INTEGER
);

CREATE TABLE history_octane.gender_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.gift_funds_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.account_grant_program
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    agp_pid BIGINT NOT NULL,
    agp_version INTEGER,
    agp_account_pid BIGINT,
    agp_from_date DATE,
    agp_through_date DATE,
    agp_program_id VARCHAR(32),
    agp_program_name VARCHAR(128),
    agp_program_funds_type VARCHAR(128),
    agp_donor_name VARCHAR(128),
    agp_donor_phone VARCHAR(32),
    agp_address_street1 VARCHAR(128),
    agp_address_street2 VARCHAR(128),
    agp_address_city VARCHAR(128),
    agp_address_state VARCHAR(128),
    agp_address_postal_code VARCHAR(128),
    agp_address_country VARCHAR(128),
    agp_ein VARCHAR(10),
    agp_wire_action_type VARCHAR(128),
    agp_notes VARCHAR(1024)
);

CREATE TABLE history_octane.gse_version_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.heloc_cancel_fee_applicable_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.hmda_action_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.hmda_agency_id_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.hmda_denial_reason_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.hmda_ethnicity_2017_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.hmda_hoepa_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.hmda_purchaser_of_loan_2017_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.hmda_purchaser_of_loan_2018_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.hmda_race_2017_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.hoepa_thresholds
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ht_pid BIGINT NOT NULL,
    ht_version INTEGER,
    ht_effective_date DATE,
    ht_total_loan_amount_threshold NUMERIC(15),
    ht_points_and_fees_threshold_amount NUMERIC(15),
    ht_first_lien_rate_spread_threshold NUMERIC(11, 9),
    ht_subordinate_lien_rate_spread_threshold NUMERIC(11, 9),
    ht_max_points_and_fees_percent_over_threshold NUMERIC(11, 9),
    ht_max_points_and_fees_percent_under_threshold NUMERIC(11, 9)
);

CREATE TABLE history_octane.homeownership_education_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.housing_counseling_agency_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.housing_counseling_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.hud_fha_de_approval_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.hve_confidence_level_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.income_history_calc_method_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.intent_to_proceed_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.interest_only_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.interim_funder_mers_registration_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.interim_funder
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    if_pid BIGINT NOT NULL,
    if_version INTEGER,
    if_account_pid BIGINT,
    if_company_name VARCHAR(128),
    if_company_contact_unparsed_name VARCHAR(128),
    if_company_address_street1 VARCHAR(128),
    if_company_address_street2 VARCHAR(128),
    if_company_address_city VARCHAR(128),
    if_company_address_state VARCHAR(128),
    if_company_address_postal_code VARCHAR(128),
    if_company_address_country VARCHAR(128),
    if_company_office_phone VARCHAR(32),
    if_company_office_phone_extension VARCHAR(16),
    if_company_email VARCHAR(256),
    if_company_fax VARCHAR(32),
    if_company_mers_org_id VARCHAR(7),
    if_remarks VARCHAR(1024),
    if_from_date DATE,
    if_through_date DATE,
    if_custodian_pid BIGINT,
    if_reimbursement_wire_credit_to_name VARCHAR(128),
    if_reimbursement_wire_attention_unparsed_name VARCHAR(128),
    if_reimbursement_wire_authorized_signer_unparsed_name VARCHAR(128),
    if_return_wire_credit_to_name VARCHAR(128),
    if_return_wire_attention_unparsed_name VARCHAR(128),
    if_return_wire_authorized_signer_unparsed_name VARCHAR(128),
    if_fnm_payee_id VARCHAR(9),
    if_interim_funder_mers_registration_type VARCHAR(128),
    if_fnm_warehouse_lender_id VARCHAR(32),
    if_fre_warehouse_lender_id VARCHAR(32),
    if_funder_id VARCHAR(32)
);

CREATE TABLE history_octane.credit_limit
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cl_pid BIGINT NOT NULL,
    cl_version INTEGER,
    cl_interim_funder_pid BIGINT,
    cl_credit_limit_name VARCHAR(128),
    cl_credit_limit_amount NUMERIC(15, 2),
    cl_credit_limit_type VARCHAR(128),
    cl_from_date DATE,
    cl_through_date DATE
);

CREATE TABLE history_octane.investor_group
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ig_pid BIGINT NOT NULL,
    ig_version INTEGER,
    ig_account_pid BIGINT,
    ig_name VARCHAR(128),
    ig_lender_group BIT
);

CREATE TABLE history_octane.investor_hmda_purchaser_of_loan_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.investor_lock_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.invoice_item_category_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.invoice_payer_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.invoice_payment_submission_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.ipc_calc_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.ipc_comparison_operator_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.ipc_property_usage_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.job_gap_reason_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.key_creditor_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.key_doc_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.key_package_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.key_role_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lava_zone_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.legacy_role_assignment_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.legal_description_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.legal_entity_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lender_concession_request_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lender_concession_request_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lender_lock_id_ticker
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lltk_pid BIGINT NOT NULL,
    lltk_version INTEGER,
    lltk_account_pid BIGINT,
    lltk_next_lender_lock_id BIGINT
);

CREATE TABLE history_octane.lender_lock_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lender_toolbox_permission_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lender_trade_id_ticker
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lttk_pid BIGINT NOT NULL,
    lttk_version INTEGER,
    lttk_account_pid BIGINT,
    lttk_next_lender_trade_id BIGINT
);

CREATE TABLE history_octane.lender_user_allowed_ip_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lender_user_interest
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lui_pid BIGINT NOT NULL,
    lui_version INTEGER,
    lui_lender_user_pid BIGINT,
    lui_lender_user_interest_type VARCHAR(128)
);

CREATE TABLE history_octane.lender_user_interest_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lender_user_language
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lul_pid BIGINT NOT NULL,
    lul_version INTEGER,
    lul_lender_user_pid BIGINT,
    lul_lender_user_language_type VARCHAR(128)
);

CREATE TABLE history_octane.lender_user_language_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lender_user_notice_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lender_user_reset_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lender_user_role_queue_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lender_user_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lender_user_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.liability_account_ownership_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.liability_account_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.liability_current_rating_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.liability_disposition_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.liability_energy_related_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.liability_financing_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.liability_foreclosure_exception_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.liability_mi_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.liability_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.license_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lien_priority_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.loan_access_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.loan_amortization_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.apor
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ap_pid BIGINT NOT NULL,
    ap_version INTEGER,
    ap_as_of_date DATE,
    ap_loan_amortization_type VARCHAR(128),
    ap_term_years INTEGER,
    ap_apor_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.loan_benef_transfer_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.loan_file_delivery_method_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.loan_limit_table_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.loan_limit_table
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    llt_pid BIGINT NOT NULL,
    llt_version INTEGER,
    llt_account_pid BIGINT,
    llt_from_date DATE,
    llt_loan_limit_table_type VARCHAR(128),
    llt_uploader_unparsed_name VARCHAR(128),
    llt_upload_datetime TIMESTAMP
);

CREATE TABLE history_octane.loan_limit_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.loan_position_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.loan_purpose_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.loan_safe_product_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.loans_toolbox_permission_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lock_add_on_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lock_commitment_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lock_extension_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lock_term_setting
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lts_pid BIGINT NOT NULL,
    lts_version INTEGER,
    lts_account_pid BIGINT,
    lts_lock_duration_days INTEGER,
    lts_lock_commitment_type VARCHAR(128),
    lts_borrower_app_enabled BIT
);

CREATE TABLE history_octane.los_loan_id_ticker
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ltk_pid BIGINT NOT NULL,
    ltk_version INTEGER,
    ltk_account_pid BIGINT,
    ltk_next_los_loan_id BIGINT
);

CREATE TABLE history_octane.lp_case_state_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lp_credit_risk_classification_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lp_dtd_version_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lp_evaluation_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lp_finding_message_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lp_interface_version_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lp_request_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lp_submission_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lqa_purchase_eligibility_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lura_file_repository_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.lura_setting_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.manufactured_home_certificate_of_title_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.manufactured_home_leasehold_property_interest_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.manufactured_home_loan_purpose_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.marital_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.master_property_insurance_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mcr_loan_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mercury_client_group
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    mcg_pid BIGINT NOT NULL,
    mcg_version INTEGER,
    mcg_account_pid BIGINT,
    mcg_mercury_client_group_name VARCHAR(1024),
    mcg_mercury_client_group_id INTEGER,
    mcg_active BIT
);

CREATE TABLE history_octane.mercury_network_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mers_daily_report_import_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mers_registration_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mers_transfer_batch
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    metb_pid BIGINT NOT NULL,
    metb_version INTEGER,
    metb_account_pid BIGINT,
    metb_create_datetime TIMESTAMP,
    metb_sent_datetime TIMESTAMP,
    metb_batch_id VARCHAR(32)
);

CREATE TABLE history_octane.mers_transfer_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mi_calculated_rate_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mi_company_name_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mi_initial_calculation_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mi_input_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mi_integration_request_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mi_integration_vendor_request_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mi_payer_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mi_payment_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mi_premium_refundable_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mi_renewal_calculation_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mi_submission_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.military_branch_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.military_service_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.military_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mismo_version_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mortech_account
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ma_pid BIGINT NOT NULL,
    ma_version INTEGER,
    ma_account_pid BIGINT,
    ma_name VARCHAR(128),
    ma_mortech_customer_id VARCHAR(128)
);

CREATE TABLE history_octane.lead_source
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lds_pid BIGINT NOT NULL,
    lds_version INTEGER,
    lds_account_pid BIGINT,
    lds_channel_pid BIGINT,
    lds_lead_source_name VARCHAR(128),
    lds_mortech_lead_source_id VARCHAR(16),
    lds_lead_source_id VARCHAR(32),
    lds_active BIT,
    lds_lead_id_required BIT,
    lds_zero_margin_allowed BIT,
    lds_mortech_account_pid BIGINT,
    lds_training_only BIT
);

CREATE TABLE history_octane.lead_campaign
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ldc_pid BIGINT NOT NULL,
    ldc_version INTEGER,
    ldc_account_pid BIGINT,
    ldc_lead_source_pid BIGINT,
    ldc_campaign_id VARCHAR(32),
    ldc_campaign_name VARCHAR(128),
    ldc_velocify_campaign_title VARCHAR(32)
);

CREATE TABLE history_octane.lead_supplemental_margin_table
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lsmt_pid BIGINT NOT NULL,
    lsmt_version INTEGER,
    lsmt_lead_source_pid BIGINT,
    lsmt_effective_datetime TIMESTAMP
);

CREATE TABLE history_octane.lead_supplemental_margin_row
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lsmr_pid BIGINT NOT NULL,
    lsmr_version INTEGER,
    lsmr_lead_supplemental_margin_table_pid BIGINT,
    lsmr_over_anchor_rate_percent NUMERIC(11, 9),
    lsmr_company_supplemental_margin_percent NUMERIC(11, 9),
    lsmr_branch_supplemental_margin_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.mortgage_credit_certificate_issuer
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    mcci_pid BIGINT NOT NULL,
    mcci_version INTEGER,
    mcci_account_pid BIGINT,
    mcci_from_date DATE,
    mcci_through_date DATE,
    mcci_issuer_name VARCHAR(128),
    mcci_credit_rate_percent NUMERIC(11, 9),
    mcci_ein VARCHAR(10),
    mcci_contact_name VARCHAR(128),
    mcci_contact_phone VARCHAR(128),
    mcci_address_street1 VARCHAR(128),
    mcci_address_street2 VARCHAR(128),
    mcci_address_city VARCHAR(128),
    mcci_address_state VARCHAR(128),
    mcci_address_postal_code VARCHAR(128),
    mcci_contact_email VARCHAR(256),
    mcci_web_url VARCHAR(256),
    mcci_notes VARCHAR(1024)
);

CREATE TABLE history_octane.mortgage_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.native_american_lands_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.negative_amortization_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.neighborhood_location_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.net_tangible_benefit_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.nfip_community_participation_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.obligation_amount_input_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.obligation_charge_input_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.obligation_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.offering_group
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ofg_pid BIGINT NOT NULL,
    ofg_version INTEGER,
    ofg_account_pid BIGINT,
    ofg_name VARCHAR(128)
);

CREATE TABLE history_octane.offering
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    of_pid BIGINT NOT NULL,
    of_version INTEGER,
    of_account_pid BIGINT,
    of_offering_name VARCHAR(128),
    of_offering_id VARCHAR(32),
    of_from_date DATE,
    of_through_date DATE,
    of_mortech_product_id VARCHAR(16),
    of_offering_group_pid BIGINT,
    of_adverse_action_offering BIT
);

CREATE TABLE history_octane.org_division
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    orgd_pid BIGINT NOT NULL,
    orgd_version INTEGER,
    orgd_account_pid BIGINT,
    orgd_latest_level_name VARCHAR(128),
    orgd_active BIT
);

CREATE TABLE history_octane.org_division_terms
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    orgdt_pid BIGINT NOT NULL,
    orgdt_version INTEGER,
    orgdt_org_division_pid BIGINT,
    orgdt_from_date DATE,
    orgdt_through_date DATE,
    orgdt_level_name VARCHAR(128),
    orgdt_level_cost_center_pid BIGINT,
    orgdt_beneficiary_cost_center_pid BIGINT,
    orgdt_guarantor_cost_center_pid BIGINT
);

CREATE TABLE history_octane.org_group
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    orgg_pid BIGINT NOT NULL,
    orgg_version INTEGER,
    orgg_account_pid BIGINT,
    orgg_latest_level_name VARCHAR(128),
    orgg_active BIT
);

CREATE TABLE history_octane.org_group_terms
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    orggt_pid BIGINT NOT NULL,
    orggt_version INTEGER,
    orggt_org_division_pid BIGINT,
    orggt_org_group_pid BIGINT,
    orggt_from_date DATE,
    orggt_through_date DATE,
    orggt_level_name VARCHAR(128),
    orggt_level_cost_center_pid BIGINT,
    orggt_beneficiary_cost_center_pid BIGINT,
    orggt_guarantor_cost_center_pid BIGINT
);

CREATE TABLE history_octane.org_leader_position_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.org_region
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    orgr_pid BIGINT NOT NULL,
    orgr_version INTEGER,
    orgr_account_pid BIGINT,
    orgr_latest_level_name VARCHAR(128),
    orgr_active BIT
);

CREATE TABLE history_octane.org_region_terms
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    orgrt_pid BIGINT NOT NULL,
    orgrt_version INTEGER,
    orgrt_org_group_pid BIGINT,
    orgrt_org_region_pid BIGINT,
    orgrt_from_date DATE,
    orgrt_through_date DATE,
    orgrt_level_name VARCHAR(128),
    orgrt_level_cost_center_pid BIGINT,
    orgrt_beneficiary_cost_center_pid BIGINT,
    orgrt_guarantor_cost_center_pid BIGINT
);

CREATE TABLE history_octane.org_team
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    orgt_pid BIGINT NOT NULL,
    orgt_version INTEGER,
    orgt_account_pid BIGINT,
    orgt_latest_level_name VARCHAR(128),
    orgt_individual_pl_owner BIT,
    orgt_admin_team BIT,
    orgt_active BIT
);

CREATE TABLE history_octane.org_unit
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    orgu_pid BIGINT NOT NULL,
    orgu_version INTEGER,
    orgu_account_pid BIGINT,
    orgu_latest_level_name VARCHAR(128),
    orgu_active BIT
);

CREATE TABLE history_octane.org_team_terms
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    orgtt_pid BIGINT NOT NULL,
    orgtt_version INTEGER,
    orgtt_org_unit_pid BIGINT,
    orgtt_org_team_pid BIGINT,
    orgtt_from_date DATE,
    orgtt_through_date DATE,
    orgtt_level_name VARCHAR(128),
    orgtt_level_cost_center_pid BIGINT,
    orgtt_beneficiary_cost_center_pid BIGINT,
    orgtt_guarantor_cost_center_pid BIGINT
);

CREATE TABLE history_octane.org_unit_terms
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    orgut_pid BIGINT NOT NULL,
    orgut_version INTEGER,
    orgut_org_region_pid BIGINT,
    orgut_org_unit_pid BIGINT,
    orgut_from_date DATE,
    orgut_through_date DATE,
    orgut_level_name VARCHAR(128),
    orgut_level_cost_center_pid BIGINT,
    orgut_beneficiary_cost_center_pid BIGINT,
    orgut_guarantor_cost_center_pid BIGINT
);

CREATE TABLE history_octane.origination_source_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.other_income_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.partial_payment_policy_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.payment_adjustment_calculation_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.payment_frequency_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.payment_fulfill_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.payment_processing_company_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.payment_request_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.payment_structure_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.payment_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.payoff_request_delivery_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.performer_team
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ptm_pid BIGINT NOT NULL,
    ptm_version INTEGER,
    ptm_account_pid BIGINT,
    ptm_name VARCHAR(128)
);

CREATE TABLE history_octane.polling_interval_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.prepaid_interest_rate_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.prepay_penalty_schedule_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.prepay_penalty_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.price_processing_time
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ppt_pid BIGINT NOT NULL,
    ppt_version INTEGER,
    ppt_account_pid BIGINT,
    ppt_los_loan_id_main BIGINT,
    ppt_start_time TIMESTAMP,
    ppt_start_date DATE,
    ppt_overall_duration_ms BIGINT,
    ppt_pre_mortech_time_ms BIGINT,
    ppt_post_mortech_time_ms BIGINT,
    ppt_num_of_mortech_requests INTEGER,
    ppt_mortech_request_url_1 TEXT,
    ppt_mortech_request_start_time_1 TIMESTAMP,
    ppt_mortech_request_time_ms_1 BIGINT,
    ppt_mortech_request_url_2 TEXT,
    ppt_mortech_request_start_time_2 TIMESTAMP,
    ppt_mortech_request_time_ms_2 BIGINT,
    ppt_mortech_request_url_3 TEXT,
    ppt_mortech_request_start_time_3 TIMESTAMP,
    ppt_mortech_request_time_ms_3 BIGINT,
    ppt_mortech_request_url_4 TEXT,
    ppt_mortech_request_start_time_4 TIMESTAMP,
    ppt_mortech_request_time_ms_4 BIGINT,
    ppt_mortech_request_url_5 TEXT,
    ppt_mortech_request_start_time_5 TIMESTAMP,
    ppt_mortech_request_time_ms_5 BIGINT,
    ppt_mortech_request_url_6 TEXT,
    ppt_mortech_request_start_time_6 TIMESTAMP,
    ppt_mortech_request_time_ms_6 BIGINT,
    ppt_mortech_request_url_7 TEXT,
    ppt_mortech_request_start_time_7 TIMESTAMP,
    ppt_mortech_request_time_ms_7 BIGINT,
    ppt_mortech_request_url_8 TEXT,
    ppt_mortech_request_start_time_8 TIMESTAMP,
    ppt_mortech_request_time_ms_8 BIGINT
);

CREATE TABLE history_octane.pricing_engine_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.prior_property_title_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.prior_to_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.product_appraisal_requirement_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.product_rule_domain_input_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.product_side_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.product_special_program_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.profit_margin_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.project_classification_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.project_design_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.property_category_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.property_repairs_holdback_calc_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.property_repairs_holdback_payer_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.property_repairs_required_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.property_rights_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.property_usage_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.proposal_doc_file_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.proposal_review_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.proposal_structure_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.proposal_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.pte_request_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.pte_response_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.public_record_disposition_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.public_record_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.qualified_mortgage_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.qualified_mortgage_thresholds
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    qmt_pid BIGINT NOT NULL,
    qmt_version INTEGER,
    qmt_effective_date DATE,
    qmt_first_total_loan_amount_threshold NUMERIC(15),
    qmt_first_points_and_fees_threshold_percent NUMERIC(11, 9),
    qmt_second_total_loan_amount_threshold NUMERIC(15),
    qmt_second_points_and_fees_threshold_amount NUMERIC(15),
    qmt_third_total_loan_amount_threshold NUMERIC(15),
    qmt_third_points_and_fees_threshold_percent NUMERIC(11, 9),
    qmt_fourth_total_loan_amount_threshold NUMERIC(15),
    qmt_fourth_points_and_fees_threshold_amount NUMERIC(15),
    qmt_ceiling_points_and_fees_threshold_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.qualifying_monthly_payment_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.qualifying_rate_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.quarter_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.mcr_snapshot
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    mcrs_pid BIGINT NOT NULL,
    mcrs_version INTEGER,
    mcrs_account_pid BIGINT,
    mcrs_year INTEGER,
    mcrs_quarter_type VARCHAR(128)
);

CREATE TABLE history_octane.mcr_loan
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    mcrl_pid BIGINT NOT NULL,
    mcrl_version INTEGER,
    mcrl_loan_pid BIGINT,
    mcrl_mcr_snapshot_pid BIGINT,
    mcrl_los_loan_id BIGINT,
    mcrl_originator_nmls_id VARCHAR(16),
    mcrl_loan_amount NUMERIC(15, 2),
    mcrl_lien_priority_type VARCHAR(128),
    mcrl_mortgage_type VARCHAR(128),
    mcrl_interest_only_type VARCHAR(128),
    mcrl_prepay_penalty_schedule_type VARCHAR(128),
    mcrl_ltv_ratio_percent NUMERIC(11, 9),
    mcrl_note_rate_percent NUMERIC(11, 9),
    mcrl_hmda_action_type VARCHAR(128),
    mcrl_hmda_action_date DATE,
    mcrl_disclosure_mode_date DATE,
    mcrl_decision_credit_score INTEGER,
    mcrl_property_usage_type VARCHAR(128),
    mcrl_doc_level_type VARCHAR(128),
    mcrl_loan_purpose_type VARCHAR(128),
    mcrl_mi_required BIT,
    mcrl_proposal_structure_type VARCHAR(128),
    mcrl_subject_property_state VARCHAR(128),
    mcrl_property_category_type VARCHAR(128),
    mcrl_cltv_ratio_percent NUMERIC(11, 9),
    mcrl_funding_status_type VARCHAR(128),
    mcrl_funding_date DATE,
    mcrl_loan_amortization_type VARCHAR(128),
    mcrl_product_special_program_type VARCHAR(128),
    mcrl_non_conforming BIT,
    mcrl_initial_payment_adjustment_term_months INTEGER,
    mcrl_subsequent_payment_adjustment_term_months INTEGER,
    mcrl_fund_source_type VARCHAR(128),
    mcrl_channel_type VARCHAR(128),
    mcrl_financed_units_count INTEGER,
    mcrl_cash_out_reason_home_improvement BIT,
    mcrl_hmda_hoepa_status_type VARCHAR(128),
    mcrl_qualified_mortgage_status_type VARCHAR(128),
    mcrl_lender_fee_total_amount NUMERIC(15, 2),
    mcrl_broker_fee_total_amount NUMERIC(15, 2),
    mcrl_investor_hmda_purchaser_of_loan_type VARCHAR(128),
    mcrl_confirmed_release_datetime TIMESTAMP,
    mcrl_purchase_advice_date DATE,
    mcrl_purchasing_beneficiary_investor_pid BIGINT,
    mcrl_mcr_loan_status_type VARCHAR(128)
);

CREATE TABLE history_octane.quote_filter_pivot_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.realty_agent_scenario_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.recording_district_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.refinance_improvements_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.relock_fee_setting
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rfs_pid BIGINT NOT NULL,
    rfs_version INTEGER,
    rfs_account_pid BIGINT,
    rfs_from_date DATE,
    rfs_relock_fee_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.reo_disposition_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.report_request_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.report_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.report
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rp_pid BIGINT NOT NULL,
    rp_version INTEGER,
    rp_account_pid BIGINT,
    rp_name VARCHAR(128),
    rp_description VARCHAR(1024),
    rp_report_type VARCHAR(128),
    rp_report_row_pid BIGINT,
    rp_criteria_pid BIGINT,
    rp_accessible_only BIT,
    rp_analysis_report BIT,
    rp_publish BIT,
    rp_test_data_report BIT,
    rp_allow_view BIT,
    rp_allow_excel_export BIT
);

CREATE TABLE history_octane.report_row
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rprw_pid BIGINT NOT NULL,
    rprw_version INTEGER,
    rprw_account_pid BIGINT,
    rprw_report_type VARCHAR(128),
    rprw_name VARCHAR(128),
    rprw_description VARCHAR(1024),
    rprw_formula_row BIT
);

CREATE TABLE history_octane.formula_report_column
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    frc_pid BIGINT NOT NULL,
    frc_version INTEGER,
    frc_report_row_pid BIGINT,
    frc_header VARCHAR(128),
    frc_formula VARCHAR(1024),
    frc_field_type_1 VARCHAR(128),
    frc_field_type_2 VARCHAR(128),
    frc_field_type_3 VARCHAR(128),
    frc_field_type_4 VARCHAR(128),
    frc_field_type_5 VARCHAR(128),
    frc_field_type_6 VARCHAR(128),
    frc_ordinal INTEGER
);

CREATE TABLE history_octane.report_column
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rpc_pid BIGINT NOT NULL,
    rpc_version INTEGER,
    rpc_report_row_pid BIGINT,
    rpc_report_column_type VARCHAR(128),
    rpc_ordinal INTEGER
);

CREATE TABLE history_octane.req_decision_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.req_fulfill_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.rescission_notification_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.respa_section_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.charge_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    ct_respa_section_type VARCHAR(128),
    value VARCHAR(1024)
);

CREATE TABLE history_octane.road_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.role
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    r_pid BIGINT NOT NULL,
    r_version INTEGER,
    r_account_pid BIGINT,
    r_role_name VARCHAR(32),
    r_borrower_viewable BIT,
    r_loan_access_type VARCHAR(128),
    r_internal BIT,
    r_training_applicable BIT
);

CREATE TABLE history_octane.key_role
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    kr_pid BIGINT NOT NULL,
    kr_version INTEGER,
    kr_role_pid BIGINT,
    kr_account_pid BIGINT,
    kr_key_role_type VARCHAR(128)
);

CREATE TABLE history_octane.role_charge_permissions
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rcp_pid BIGINT NOT NULL,
    rcp_version INTEGER,
    rcp_role_pid BIGINT,
    rcp_charge_type VARCHAR(128),
    rcp_basic_editable BIT,
    rcp_financed_editable BIT,
    rcp_payer_non_lender_editable BIT,
    rcp_payer_lender_editable BIT,
    rcp_payee_editable BIT,
    rcp_apr_editable BIT,
    rcp_poc_editable BIT,
    rcp_wire_editable BIT
);

CREATE TABLE history_octane.role_config_export_permission
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rcep_pid BIGINT NOT NULL,
    rcep_version INTEGER,
    rcep_role_pid BIGINT,
    rcep_config_export_permission_type VARCHAR(128)
);

CREATE TABLE history_octane.role_deal_context
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rdc_pid BIGINT NOT NULL,
    rdc_version INTEGER,
    rdc_role_pid BIGINT,
    rdc_deal_context_permission_type VARCHAR(128)
);

CREATE TABLE history_octane.role_export_permission
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rep_pid BIGINT NOT NULL,
    rep_version INTEGER,
    rep_role_pid BIGINT,
    rep_export_permission_type VARCHAR(128)
);

CREATE TABLE history_octane.role_lender_toolbox
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rlet_pid BIGINT NOT NULL,
    rlet_version INTEGER,
    rlet_role_pid BIGINT,
    rlet_lender_toolbox_permission_type VARCHAR(128)
);

CREATE TABLE history_octane.role_loans_toolbox
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rlot_pid BIGINT NOT NULL,
    rlot_version INTEGER,
    rlot_role_pid BIGINT,
    rlot_loans_toolbox_permission_type VARCHAR(128)
);

CREATE TABLE history_octane.role_performer_assign
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rpa_pid BIGINT NOT NULL,
    rpa_version INTEGER,
    rpa_role_pid BIGINT,
    rpa_assignee_role_pid BIGINT
);

CREATE TABLE history_octane.role_report
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rrp_pid BIGINT NOT NULL,
    rrp_version INTEGER,
    rrp_report_pid BIGINT,
    rrp_role_pid BIGINT
);

CREATE TABLE history_octane.sanitation_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.sap_step_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.secondary_admin_event_entity_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.secondary_admin_event
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sae_pid BIGINT NOT NULL,
    sae_version INTEGER,
    sae_account_pid BIGINT,
    sae_secondary_admin_event_entity_type VARCHAR(128),
    sae_message VARCHAR(256),
    sae_diff_list TEXT,
    sae_unparsed_name VARCHAR(128),
    sae_event_date DATE,
    sae_event_datetime TIMESTAMP,
    sae_target_entity_pid BIGINT
);

CREATE TABLE history_octane.section_of_act_coarse_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.security_instrument_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.senior_lien_restriction_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.servicer_loan_id_assign_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.servicer_loan_id_import_request_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.servicing_transfer_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.settlement_agent
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sa_pid BIGINT NOT NULL,
    sa_version INTEGER,
    sa_account_pid BIGINT,
    sa_active BIT,
    sa_admin_lock BIT,
    sa_license_id VARCHAR(128),
    sa_company_name VARCHAR(128),
    sa_preferred_vendor BIT
);

CREATE TABLE history_octane.settlement_agent_office
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sao_pid BIGINT NOT NULL,
    sao_version INTEGER,
    sao_settlement_agent_pid BIGINT,
    sao_active BIT,
    sao_address_street1 VARCHAR(128),
    sao_address_street2 VARCHAR(128),
    sao_address_city VARCHAR(128),
    sao_address_state VARCHAR(128),
    sao_address_postal_code VARCHAR(128),
    sao_address_country VARCHAR(128),
    sao_phone VARCHAR(32),
    sao_fax VARCHAR(32),
    sao_docs_email VARCHAR(256),
    sao_fund_email VARCHAR(256),
    sao_schedule_email VARCHAR(256)
);

CREATE TABLE history_octane.settlement_agent_wire
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    saw_pid BIGINT NOT NULL,
    saw_version INTEGER,
    saw_settlement_agent_pid BIGINT,
    saw_active BIT,
    saw_create_datetime TIMESTAMP,
    saw_bank_name VARCHAR(128),
    saw_address_street1 VARCHAR(128),
    saw_address_street2 VARCHAR(128),
    saw_address_city VARCHAR(128),
    saw_address_state VARCHAR(128),
    saw_address_postal_code VARCHAR(128),
    saw_address_country VARCHAR(128),
    saw_for_credit_to VARCHAR(256),
    saw_for_further_credit_fixed_text VARCHAR(256),
    saw_for_further_credit_prompt_text VARCHAR(256),
    saw_verified_from_date DATE,
    saw_verified_through_date DATE,
    saw_verifier VARCHAR(128),
    saw_notes VARCHAR(1024),
    saw_for_further_credit_type VARCHAR(128),
    saw_beneficiary_bank_name VARCHAR(128),
    saw_beneficiary_address_street1 VARCHAR(128),
    saw_beneficiary_address_street2 VARCHAR(128),
    saw_beneficiary_address_city VARCHAR(128),
    saw_beneficiary_address_state VARCHAR(128),
    saw_beneficiary_address_postal_code VARCHAR(128),
    saw_beneficiary_address_country VARCHAR(128),
    saw_beneficiary_for_credit_to VARCHAR(256),
    saw_beneficiary_for_further_credit_fixed_text VARCHAR(256),
    saw_beneficiary_for_further_credit_prompt_text VARCHAR(256),
    saw_beneficiary_for_further_credit_type VARCHAR(128),
    saw_beneficiary_notes VARCHAR(1024)
);

CREATE TABLE history_octane.sheet_format_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.google_sheet_export
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    gse_pid BIGINT NOT NULL,
    gse_version INTEGER,
    gse_name VARCHAR(128),
    gse_account_pid BIGINT,
    gse_export_type VARCHAR(128),
    gse_stored_query_name VARCHAR(128),
    gse_spreadsheet_id VARCHAR(128),
    gse_control_sheet_id VARCHAR(128),
    gse_results_sheet_id VARCHAR(128),
    gse_cron_expression VARCHAR(32),
    gse_format_type VARCHAR(128)
);

CREATE TABLE history_octane.signature_part_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.site_allowed_ip
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    saip_pid BIGINT NOT NULL,
    saip_version INTEGER,
    saip_account_pid BIGINT,
    saip_name VARCHAR(128),
    saip_ip_address VARCHAR(32)
);

CREATE TABLE history_octane.smart_charge_apr_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.smart_charge
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sc_pid BIGINT NOT NULL,
    sc_version INTEGER,
    sc_account_pid BIGINT,
    sc_charge_type VARCHAR(128),
    sc_loan_position_type VARCHAR(128),
    sc_name VARCHAR(128),
    sc_smart_charge_apr_type VARCHAR(128),
    sc_apr_criteria_pid BIGINT
);

CREATE TABLE history_octane.smart_charge_group
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    scg_pid BIGINT NOT NULL,
    scg_version INTEGER,
    scg_smart_charge_pid BIGINT,
    scg_group_name VARCHAR(128)
);

CREATE TABLE history_octane.smart_charge_group_case
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    scgc_pid BIGINT NOT NULL,
    scgc_version INTEGER,
    scgc_smart_charge_group_pid BIGINT,
    scgc_from_date DATE,
    scgc_through_date DATE
);

CREATE TABLE history_octane.smart_charge_case
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    scc_pid BIGINT NOT NULL,
    scc_version INTEGER,
    scc_smart_charge_group_case_pid BIGINT,
    scc_case_name VARCHAR(128),
    scc_ordinal INTEGER,
    scc_criteria_pid BIGINT,
    scc_amount_description VARCHAR(256),
    scc_charge_payer_type VARCHAR(128),
    scc_charge_payee_type VARCHAR(128),
    scc_paid_by VARCHAR(128),
    scc_paid_to VARCHAR(128),
    scc_base_amount NUMERIC(16, 3),
    scc_charge_input_type VARCHAR(128),
    scc_charge_input_type_percent NUMERIC(11, 9),
    scc_charge_input_type_currency NUMERIC(16, 3),
    scc_financed BIT,
    scc_financed_auto_compute BIT,
    scc_poc BIT,
    scc_reduction_amount NUMERIC(15),
    scc_subtract_lenders_title_insurance_amount BIT
);

CREATE TABLE history_octane.smart_message_delivery_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.smart_message_email_recipient_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.smart_message_recipient_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.smart_message_source_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.smart_mi
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sm_pid BIGINT NOT NULL,
    sm_version INTEGER,
    sm_account_pid BIGINT,
    sm_mi_company_name_type VARCHAR(128)
);

CREATE TABLE history_octane.smart_mi_eligibility_case
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    smec_pid BIGINT NOT NULL,
    smec_version INTEGER,
    smec_smart_mi_pid BIGINT,
    smec_criteria_pid BIGINT,
    smec_from_date DATE,
    smec_through_date DATE
);

CREATE TABLE history_octane.smart_mi_rate_card
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    smrca_pid BIGINT NOT NULL,
    smrca_version INTEGER,
    smrca_from_date DATE,
    smrca_mi_payment_type VARCHAR(128),
    smrca_mi_payer_type VARCHAR(128),
    smrca_minimum_rate_percent NUMERIC(11, 9),
    smrca_smart_mi_pid BIGINT,
    smrca_maximum_renewal_rate_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.smart_mi_rate_adjustment_case
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    smrac_pid BIGINT NOT NULL,
    smrac_version INTEGER,
    smrac_smart_mi_rate_card_pid BIGINT,
    smrac_rate_adjustment_percent NUMERIC(11, 9),
    smrac_criteria_html VARCHAR(16000),
    smrac_criteria_pid BIGINT
);

CREATE TABLE history_octane.smart_mi_rate_case
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    smrc_pid BIGINT NOT NULL,
    smrc_version INTEGER,
    smrc_smart_mi_rate_card_pid BIGINT,
    smrc_criteria_html VARCHAR(16000),
    smrc_ordinal INTEGER,
    smrc_criteria_pid BIGINT,
    smrc_else_case BIT,
    smrc_amount_description VARCHAR(256),
    smrc_upfront_percent NUMERIC(11, 9),
    smrc_initial_monthly_payment_annual_percent NUMERIC(11, 9),
    smrc_coverage_percent NUMERIC(11, 9),
    smrc_ltv_cutoff_percent NUMERIC(11, 9),
    smrc_midpoint_cutoff_required BIT,
    smrc_required_monthly_payment_count INTEGER,
    smrc_initial_duration_months INTEGER
);

CREATE TABLE history_octane.smart_mi_surcharge
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sms_pid BIGINT NOT NULL,
    sms_version INTEGER,
    sms_account_pid BIGINT,
    sms_from_date DATE
);

CREATE TABLE history_octane.smart_mi_surcharge_case
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    smsc_pid BIGINT NOT NULL,
    smsc_version INTEGER,
    smsc_smart_mi_surcharge_pid BIGINT,
    smsc_criteria_pid BIGINT,
    smsc_government_surcharge_percent NUMERIC(11, 9),
    smsc_minimum_surcharge_amount NUMERIC(15, 2),
    smsc_criteria_html VARCHAR(16000)
);

CREATE TABLE history_octane.smart_stack
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ss_pid BIGINT NOT NULL,
    ss_version INTEGER,
    ss_account_pid BIGINT,
    ss_name VARCHAR(128)
);

CREATE TABLE history_octane.smart_stack_doc_set_include_option_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.smart_doc_set
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sdst_pid BIGINT NOT NULL,
    sdst_version INTEGER,
    sdst_account_pid BIGINT,
    sdst_name VARCHAR(128),
    sdst_doc_set_type VARCHAR(128),
    sdst_active BIT,
    sdst_smart_stack_doc_set_include_option_type VARCHAR(128)
);

CREATE TABLE history_octane.key_package
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    kp_pid BIGINT NOT NULL,
    kp_version INTEGER,
    kp_account_pid BIGINT,
    kp_smart_doc_set_pid BIGINT,
    kp_key_package_type VARCHAR(128)
);

CREATE TABLE history_octane.smart_stack_doc_set_include_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.solar_panel_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.stack_doc_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.stack_export_file_name_format_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.stack_export_file_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.stack_export_loan_name_format_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.stack_export_request_loan_export_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.stack_export_request_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.state_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.county
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    c_pid BIGINT NOT NULL,
    c_version INTEGER,
    c_name VARCHAR(128),
    c_state_type VARCHAR(128),
    c_county_fips VARCHAR(16),
    c_recording_district_type VARCHAR(128),
    c_torrens_available BIT,
    c_defunct BIT,
    c_mortech_name VARCHAR(128)
);

CREATE TABLE history_octane.area_median_income_row
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    amir_pid BIGINT NOT NULL,
    amir_version INTEGER,
    amir_area_median_income_table_pid BIGINT,
    amir_state_type VARCHAR(128),
    amir_county_pid BIGINT,
    amir_census_tract VARCHAR(16),
    amir_area_median_income NUMERIC(15, 2)
);

CREATE TABLE history_octane.county_city
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cci_pid BIGINT NOT NULL,
    cci_version INTEGER,
    cci_county_pid BIGINT,
    cci_city_name VARCHAR(128)
);

CREATE TABLE history_octane.county_sub_jurisdiction
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    csju_pid BIGINT NOT NULL,
    csju_version INTEGER,
    csju_county_pid BIGINT,
    csju_sub_jurisdiction_name VARCHAR(128)
);

CREATE TABLE history_octane.disaster_declaration
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dd_pid BIGINT NOT NULL,
    dd_version INTEGER,
    dd_account_pid BIGINT,
    dd_fema_incident_id VARCHAR(32),
    dd_state_type VARCHAR(128),
    dd_county_pid BIGINT,
    dd_declared_disaster_date DATE,
    dd_last_processed_datetime TIMESTAMP
);

CREATE TABLE history_octane.license_req
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    mlr_pid BIGINT NOT NULL,
    mlr_version INTEGER,
    mlr_account_pid BIGINT,
    mlr_state_type VARCHAR(128),
    mlr_license_type VARCHAR(128)
);

CREATE TABLE history_octane.loan_limit_row
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    llr_pid BIGINT NOT NULL,
    llr_version INTEGER,
    llr_loan_limit_table_pid BIGINT,
    llr_loan_limit_type VARCHAR(128),
    llr_state_type VARCHAR(128),
    llr_county_pid BIGINT,
    llr_one_unit_limit_amount NUMERIC(15, 2),
    llr_two_unit_limit_amount NUMERIC(15, 2),
    llr_three_unit_limit_amount NUMERIC(15, 2),
    llr_four_unit_limit_amount NUMERIC(15, 2)
);

CREATE TABLE history_octane.recording_city
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rc_pid BIGINT NOT NULL,
    rc_version INTEGER,
    rc_city_name VARCHAR(128),
    rc_state_type VARCHAR(128),
    rc_recording_city_name VARCHAR(128)
);

CREATE TABLE history_octane.recording_district
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rdi_pid BIGINT NOT NULL,
    rdi_version INTEGER,
    rdi_state_type VARCHAR(128),
    rdi_district_name_with_qualifier VARCHAR(128),
    rdi_district_name VARCHAR(128)
);

CREATE TABLE history_octane.county_recording_district
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    crdi_pid BIGINT NOT NULL,
    crdi_version INTEGER,
    crdi_county_pid BIGINT,
    crdi_recording_district_pid BIGINT
);

CREATE TABLE history_octane.region_ernst_page_rec
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rerc_pid BIGINT NOT NULL,
    rerc_version INTEGER,
    rerc_ernst_page_rec_type VARCHAR(128),
    rerc_state_type VARCHAR(128),
    rerc_county_pid BIGINT,
    rerc_county_city_pid BIGINT,
    rerc_recording_district_pid BIGINT,
    rerc_ernst_page_rec VARCHAR(16)
);

CREATE TABLE history_octane.street_links_product_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.stripe_payment_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.stripe_payment
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    stpm_pid BIGINT NOT NULL,
    stpm_version INTEGER,
    stpm_account_pid BIGINT,
    stpm_submit_datetime TIMESTAMP,
    stpm_payer_unparsed_name VARCHAR(128),
    stpm_invoice_amount NUMERIC(15, 2),
    stpm_payment_request_type VARCHAR(128),
    stpm_stripe_payment_status_type VARCHAR(128),
    stpm_payment_status_messages TEXT,
    stpm_status_datetime TIMESTAMP,
    stpm_token VARCHAR(128),
    stpm_receipt_email VARCHAR(256),
    stpm_stripe_id VARCHAR(128),
    stpm_refund_stripe_id VARCHAR(128),
    stpm_receipt_url VARCHAR(256)
);

CREATE TABLE history_octane.tax_filing_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.tax_transcript_request_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.taxpayer_identifier_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.contractor
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ctr_pid BIGINT NOT NULL,
    ctr_version INTEGER,
    ctr_account_pid BIGINT,
    ctr_contractor_company_name VARCHAR(128),
    ctr_max_construction_credit_amount NUMERIC(15, 2),
    ctr_taxpayer_identifier_type VARCHAR(128),
    ctr_first_name VARCHAR(128),
    ctr_last_name VARCHAR(128),
    ctr_work_phone VARCHAR(32),
    ctr_work_phone_extension VARCHAR(16),
    ctr_mobile_phone VARCHAR(32),
    ctr_fax VARCHAR(32),
    ctr_email VARCHAR(256),
    ctr_address_street1 VARCHAR(128),
    ctr_address_street2 VARCHAR(128),
    ctr_address_city VARCHAR(128),
    ctr_address_state VARCHAR(128),
    ctr_address_postal_code VARCHAR(128),
    ctr_address_country VARCHAR(128),
    ctr_notes VARCHAR(1024)
);

CREATE TABLE history_octane.contractor_license
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ctrl_pid BIGINT NOT NULL,
    ctrl_version INTEGER,
    ctrl_contractor_pid BIGINT,
    ctrl_state_type VARCHAR(128),
    ctrl_license_number VARCHAR(128),
    ctrl_from_date DATE,
    ctrl_through_date DATE,
    ctrl_note VARCHAR(256)
);

CREATE TABLE history_octane.third_party_community_second_program_eligibility_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.time_zone_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.admin_user
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    au_pid BIGINT NOT NULL,
    au_version INTEGER,
    au_create_date DATE,
    au_email VARCHAR(256),
    au_first_name VARCHAR(32),
    au_last_name VARCHAR(32),
    au_unparsed_name VARCHAR(128),
    au_office_phone VARCHAR(32),
    au_office_phone_extension VARCHAR(16),
    au_through_date DATE,
    au_time_zone VARCHAR(128),
    au_title VARCHAR(128),
    au_admin_user_status_type VARCHAR(128),
    au_username VARCHAR(32),
    au_admin_user_administrator BIT,
    au_customer_support BIT,
    au_engineering BIT,
    au_management BIT,
    au_force_password_change BIT,
    au_last_password_change_date TIMESTAMP,
    au_last_sign_on_datetime TIMESTAMP
);

CREATE TABLE history_octane.borrower_user
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bu_pid BIGINT NOT NULL,
    bu_version INTEGER,
    bu_account_pid BIGINT,
    bu_create_datetime TIMESTAMP,
    bu_email VARCHAR(256),
    bu_last_sign_on_datetime TIMESTAMP,
    bu_time_zone VARCHAR(128),
    bu_first_name VARCHAR(32),
    bu_middle_name VARCHAR(32),
    bu_last_name VARCHAR(32),
    bu_name_suffix VARCHAR(32),
    bu_unparsed_name VARCHAR(128),
    bu_borrower_activation_id VARCHAR(128),
    bu_challenge_question_type VARCHAR(128),
    bu_challenge_question_answer VARCHAR(128),
    bu_borrower_user_account_status_type VARCHAR(128),
    bu_public_quote_request_cache_id INTEGER,
    bu_create_sap_on_activation BIT,
    bu_nickname VARCHAR(32),
    bu_plain_text_email BIT,
    bu_preferred_first_name VARCHAR(32)
);

CREATE TABLE history_octane.timeout_time_zone_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.title_company
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    tc_pid BIGINT NOT NULL,
    tc_version INTEGER,
    tc_account_pid BIGINT,
    tc_company_name VARCHAR(128),
    tc_admin_lock BIT,
    tc_active BIT,
    tc_preferred_vendor BIT
);

CREATE TABLE history_octane.title_company_office
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    tco_pid BIGINT NOT NULL,
    tco_version INTEGER,
    tco_title_company_pid BIGINT,
    tco_address_street1 VARCHAR(128),
    tco_address_street2 VARCHAR(128),
    tco_address_city VARCHAR(128),
    tco_address_state VARCHAR(128),
    tco_address_postal_code VARCHAR(128),
    tco_address_country VARCHAR(128),
    tco_phone VARCHAR(32),
    tco_fax VARCHAR(32),
    tco_email VARCHAR(256),
    tco_active BIT
);

CREATE TABLE history_octane.preferred_settlement
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    prs_pid BIGINT NOT NULL,
    prs_version INTEGER,
    prs_account_pid BIGINT,
    prs_state VARCHAR(16),
    prs_from_date DATE,
    prs_title_company_pid BIGINT,
    prs_title_company_office_pid BIGINT,
    prs_settlement_agent_pid BIGINT,
    prs_settlement_agent_office_pid BIGINT,
    prs_settlement_agent_wire_pid BIGINT
);

CREATE TABLE history_octane.title_manner_held_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.total_expert_account_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.trade_audit_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.trade_fee_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    tft_pid BIGINT NOT NULL,
    tft_version INTEGER,
    tft_account_pid BIGINT,
    tft_name VARCHAR(128)
);

CREATE TABLE history_octane.trade_pricing_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.trade_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.trustee
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    tru_pid BIGINT NOT NULL,
    tru_version INTEGER,
    tru_account_pid BIGINT,
    tru_name VARCHAR(128),
    tru_address_street1 VARCHAR(128),
    tru_address_street2 VARCHAR(128),
    tru_address_city VARCHAR(128),
    tru_address_state VARCHAR(128),
    tru_address_postal_code VARCHAR(128),
    tru_address_country VARCHAR(128),
    tru_mers_org_id VARCHAR(7),
    tru_from_date DATE,
    tru_through_date DATE,
    tru_phone_number VARCHAR(32)
);

CREATE TABLE history_octane.underwrite_disposition_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.underwrite_method_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.underwrite_risk_assessment_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.unique_dwelling_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.usda_rd_single_family_housing_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.uuts_loan_originator_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.va_borrower_certification_occupancy_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.va_entitlement_code_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.va_entitlement_restoration_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.va_notice_of_value_source_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.va_past_credit_record_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.va_regional_loan_center_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.va_relative_relationship_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.vendor_credential_source_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.vendor_document_event_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.vendor_import_document_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.veteran_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.voe_third_party_verifier_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.voe_verbal_verify_method_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.voe_verify_method_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.water_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.wf_deal_process_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.wf_deal_step_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.wf_outcome_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.wf_phase
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    wph_pid BIGINT NOT NULL,
    wph_version INTEGER,
    wph_account_pid BIGINT,
    wph_phase_name VARCHAR(128),
    wph_phase_number INTEGER
);

CREATE TABLE history_octane.wf_process_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.wf_process_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.wf_process
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    wpr_pid BIGINT NOT NULL,
    wpr_version INTEGER,
    wpr_account_pid BIGINT,
    wpr_name VARCHAR(128),
    wpr_wf_process_type VARCHAR(128),
    wpr_criteria_pid BIGINT,
    wpr_wf_process_status_type VARCHAR(128)
);

CREATE TABLE history_octane.wf_step_function_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.wf_step_performer_assign_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.wf_step_reassign_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.wf_step_timeout_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.wf_step_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.wf_wait_until_time_slice
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    wts_pid BIGINT NOT NULL,
    wts_version INTEGER,
    wts_time_slice TIMESTAMP,
    wts_when_fired TIMESTAMP,
    wts_when_complete TIMESTAMP
);

CREATE TABLE history_octane.yes_no_na_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.yes_no_na_unknown_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.yes_no_unknown_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.application
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    apl_pid BIGINT NOT NULL,
    apl_version INTEGER,
    apl_application_name VARCHAR(128),
    apl_primary_application BIT,
    apl_urla BIT,
    apl_proposal_pid BIGINT,
    apl_fha_borrower_certification_own_other_property VARCHAR(128),
    apl_fha_borrower_certification_property_to_be_sold VARCHAR(128),
    apl_fha_borrower_certification_sales_price_amount NUMERIC(15),
    apl_fha_borrower_certification_mortgage_amount NUMERIC(15),
    apl_address_street1 VARCHAR(128),
    apl_address_street2 VARCHAR(128),
    apl_address_city VARCHAR(128),
    apl_address_state VARCHAR(128),
    apl_address_postal_code VARCHAR(128),
    apl_address_country VARCHAR(128),
    apl_fha_borrower_certification_rental VARCHAR(128),
    apl_fha_borrower_certification_rental_explain VARCHAR(256),
    apl_fha_borrower_certification_more_than_four_dwellings VARCHAR(128),
    apl_va_borrower_certification_occupancy_type VARCHAR(128),
    apl_fha_va_bor_cert_sales_price_exceeds_type VARCHAR(128)
);

CREATE TABLE history_octane.asset
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    as_pid BIGINT NOT NULL,
    as_version INTEGER,
    as_aggregate_description VARCHAR(256),
    as_application_pid BIGINT,
    as_asset_type VARCHAR(128),
    as_automobile_make_description VARCHAR(32),
    as_automobile_model_year INTEGER,
    as_cash_or_market_value_amount NUMERIC(15, 2),
    as_description VARCHAR(128),
    as_donor_city VARCHAR(128),
    as_donor_country VARCHAR(128),
    as_donor_postal_code VARCHAR(128),
    as_donor_state VARCHAR(128),
    as_donor_street1 VARCHAR(128),
    as_donor_street2 VARCHAR(128),
    as_gift_funds_donor_phone VARCHAR(32),
    as_gift_funds_donor_relationship VARCHAR(128),
    as_gift_funds_donor_unparsed_name VARCHAR(128),
    as_gift_funds_other_type_description VARCHAR(32),
    as_gift_funds_depository_asset_pid BIGINT,
    as_gift_amount NUMERIC(15, 2),
    as_gift_funds_source_account_type VARCHAR(128),
    as_gift_funds_source_holder_name VARCHAR(128),
    as_gift_funds_type VARCHAR(128),
    as_holder_name VARCHAR(128),
    as_holder_city VARCHAR(128),
    as_holder_country VARCHAR(128),
    as_holder_postal_code VARCHAR(128),
    as_holder_state VARCHAR(128),
    as_holder_street1 VARCHAR(128),
    as_holder_street2 VARCHAR(128),
    as_life_insurance_face_value_amount NUMERIC(15, 2),
    as_liquid_amount NUMERIC(15, 2),
    as_liquid_percent NUMERIC(11, 9),
    as_source_verification_required VARCHAR(128),
    as_stock_bond_mutual_fund_share_count INTEGER,
    as_earnest_money_deposit_source_pid BIGINT,
    as_available_amount NUMERIC(15, 2),
    as_down_payment_amount NUMERIC(15),
    as_closing_costs_amount NUMERIC(15, 2),
    as_gift_funds_account_holder_type VARCHAR(128),
    as_penalty_amount NUMERIC(15, 2)
);

CREATE TABLE history_octane.asset_large_deposit
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ald_pid BIGINT NOT NULL,
    ald_version INTEGER,
    ald_asset_pid BIGINT,
    ald_deposit_amount NUMERIC(15, 2),
    ald_deposit_date DATE
);

CREATE TABLE history_octane.creditor
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    crd_pid BIGINT NOT NULL,
    crd_version INTEGER,
    crd_account_pid BIGINT,
    crd_payoff_request_delivery_type VARCHAR(128),
    crd_name VARCHAR(128),
    crd_payoff_phone_1 VARCHAR(32),
    crd_payoff_phone_1_extension VARCHAR(16),
    crd_payoff_phone_2 VARCHAR(32),
    crd_payoff_phone_2_extension VARCHAR(16),
    crd_payoff_fax VARCHAR(32),
    crd_payoff_email VARCHAR(256),
    crd_payoff_auto_teller VARCHAR(128),
    crd_last_updated DATE,
    crd_last_updated_by VARCHAR(128),
    crd_payoff_notes VARCHAR(1024),
    crd_address_street1 VARCHAR(128),
    crd_address_street2 VARCHAR(128),
    crd_address_city VARCHAR(128),
    crd_address_state VARCHAR(128),
    crd_address_postal_code VARCHAR(128),
    crd_address_country VARCHAR(128),
    crd_key_creditor_type VARCHAR(128)
);

CREATE TABLE history_octane.creditor_lookup_name
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cln_pid BIGINT NOT NULL,
    cln_version INTEGER,
    cln_account_pid BIGINT,
    cln_creditor_pid BIGINT,
    cln_name VARCHAR(128)
);

CREATE TABLE history_octane.investor
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    i_pid BIGINT NOT NULL,
    i_version INTEGER,
    i_account_pid BIGINT,
    i_investor_id VARCHAR(32),
    i_criteria_pid BIGINT,
    i_website_url VARCHAR(256),
    i_investor_name VARCHAR(128),
    i_investor_city VARCHAR(128),
    i_investor_country VARCHAR(128),
    i_investor_postal_code VARCHAR(128),
    i_investor_state VARCHAR(128),
    i_investor_street1 VARCHAR(128),
    i_investor_street2 VARCHAR(128),
    i_investor_county_pid BIGINT,
    i_beneficiary_name VARCHAR(128),
    i_beneficiary_city VARCHAR(128),
    i_beneficiary_country VARCHAR(128),
    i_beneficiary_postal_code VARCHAR(128),
    i_beneficiary_state VARCHAR(128),
    i_beneficiary_street1 VARCHAR(128),
    i_beneficiary_street2 VARCHAR(128),
    i_beneficiary_county_pid BIGINT,
    i_loss_payee_name VARCHAR(128),
    i_loss_payee_city VARCHAR(128),
    i_loss_payee_country VARCHAR(128),
    i_loss_payee_postal_code VARCHAR(128),
    i_loss_payee_state VARCHAR(128),
    i_loss_payee_street1 VARCHAR(128),
    i_loss_payee_street2 VARCHAR(128),
    i_loss_payee_county_pid BIGINT,
    i_loss_payee_assignee_name VARCHAR(128),
    i_when_recorded_mail_to_name VARCHAR(128),
    i_when_recorded_mail_to_city VARCHAR(128),
    i_when_recorded_mail_to_country VARCHAR(128),
    i_when_recorded_mail_to_postal_code VARCHAR(128),
    i_when_recorded_mail_to_state VARCHAR(128),
    i_when_recorded_mail_to_street1 VARCHAR(128),
    i_when_recorded_mail_to_street2 VARCHAR(128),
    i_when_recorded_mail_to_county_pid BIGINT,
    i_servicer_name VARCHAR(128),
    i_servicer_address_street1 VARCHAR(128),
    i_servicer_address_street2 VARCHAR(128),
    i_servicer_address_city VARCHAR(128),
    i_servicer_address_state VARCHAR(128),
    i_servicer_address_postal_code VARCHAR(128),
    i_servicer_address_country VARCHAR(128),
    i_servicer_county_pid BIGINT,
    i_sub_servicer_name VARCHAR(128),
    i_sub_servicer_address_street1 VARCHAR(128),
    i_sub_servicer_address_street2 VARCHAR(128),
    i_sub_servicer_address_city VARCHAR(128),
    i_sub_servicer_address_state VARCHAR(128),
    i_sub_servicer_address_postal_code VARCHAR(128),
    i_sub_servicer_address_country VARCHAR(128),
    i_sub_servicer_mers_org_id VARCHAR(7),
    i_custodian_pid BIGINT,
    i_file_delivery_name VARCHAR(128),
    i_file_delivery_address_street1 VARCHAR(128),
    i_file_delivery_address_street2 VARCHAR(128),
    i_file_delivery_address_city VARCHAR(128),
    i_file_delivery_address_state VARCHAR(128),
    i_file_delivery_address_postal_code VARCHAR(128),
    i_file_delivery_address_country VARCHAR(128),
    i_initial_beneficiary_candidate BIT,
    i_initial_servicer_candidate BIT,
    i_mers_org_member VARCHAR(128),
    i_mers_org_id VARCHAR(7),
    i_allonge_transfer_to_name VARCHAR(128),
    i_lock_expiration_delivery_subtrahend_days INTEGER,
    i_maximum_lock_extensions_allowed INTEGER,
    i_maximum_lock_extension_days_allowed INTEGER,
    i_mortech_investor_id VARCHAR(16),
    i_fnma_servicer_id VARCHAR(16),
    i_loan_file_delivery_method_type VARCHAR(128),
    i_investor_group_pid BIGINT,
    i_mbs_investor BIT,
    i_investor_hmda_purchaser_of_loan_type VARCHAR(128),
    i_lock_disable_time time,
    i_allow_weekend_holiday_locks BIT,
    i_nmls_id VARCHAR(16),
    i_nmls_id_applicable VARCHAR(128),
    i_fnm_investor_remittance_type VARCHAR(128),
    i_fnm_mbs_investor_remittance_day_of_month INTEGER,
    i_fnm_mbs_loan_default_loss_party_type VARCHAR(128),
    i_fnm_mbs_reo_marketing_party_type VARCHAR(128),
    i_offers_secondary_financing BIT,
    i_secondary_financing_source_type VARCHAR(128),
    i_ein VARCHAR(10)
);

CREATE TABLE history_octane.company
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cm_pid BIGINT NOT NULL,
    cm_version INTEGER,
    cm_account_pid BIGINT,
    cm_origination_source_type VARCHAR(128),
    cm_company_id VARCHAR(32),
    cm_nmls_company_id VARCHAR(16),
    cm_federal_tax_id VARCHAR(32),
    cm_mers_org_id VARCHAR(7),
    cm_mers_mom BIT,
    cm_company_name VARCHAR(128),
    cm_company_mailing_address_name VARCHAR(128),
    cm_company_name_for_header_and_footer VARCHAR(128),
    cm_casual_company_name VARCHAR(128),
    cm_company_address_street1 VARCHAR(128),
    cm_company_address_street2 VARCHAR(128),
    cm_company_address_city VARCHAR(128),
    cm_company_address_state VARCHAR(128),
    cm_company_address_postal_code VARCHAR(128),
    cm_company_address_country VARCHAR(128),
    cm_company_phone VARCHAR(32),
    cm_customer_service_email VARCHAR(256),
    cm_customer_service_phone VARCHAR(32),
    cm_customer_service_phone_extension VARCHAR(16),
    cm_borrower_app_company_host VARCHAR(256),
    cm_borrower_app_company_ip_address VARCHAR(32),
    cm_borrower_app_company_enabled BIT,
    cm_borrower_user_email_from VARCHAR(256),
    cm_company_legal_entity_type VARCHAR(128),
    cm_company_legal_entity_organization_state_type VARCHAR(128),
    cm_broker_participating_with_less_than_four_lenders VARCHAR(128),
    cm_broker_participating_lender_1 VARCHAR(256),
    cm_broker_participating_lender_2 VARCHAR(256),
    cm_broker_participating_lender_3 VARCHAR(256),
    cm_correspondent_investor_pid BIGINT,
    cm_total_expert_account_type VARCHAR(128)
);

CREATE TABLE history_octane.branch
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    br_pid BIGINT NOT NULL,
    br_version INTEGER,
    br_company_pid BIGINT,
    br_branch_name VARCHAR(128),
    br_fha_field_office_code VARCHAR(16),
    br_branch_id VARCHAR(16),
    br_branch_status_type VARCHAR(128),
    br_nmls_branch_id VARCHAR(16),
    br_uuts_loan_originator_type VARCHAR(128),
    br_address_street1 VARCHAR(128),
    br_address_street2 VARCHAR(128),
    br_address_city VARCHAR(128),
    br_address_state VARCHAR(128),
    br_address_postal_code VARCHAR(128),
    br_address_country VARCHAR(128),
    br_office_phone VARCHAR(32),
    br_office_phone_extension VARCHAR(16),
    br_fax VARCHAR(32),
    br_lp_lender_branch_id VARCHAR(16),
    br_dsi_customer_id VARCHAR(16),
    br_clg_flood_cert_internal_account_id VARCHAR(16),
    br_street_links_branch_id VARCHAR(32),
    br_fha_branch_id VARCHAR(16),
    br_fha_branch_id_qualified VARCHAR(16),
    br_lender_paid_broker_compensation_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.branch_license
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    brml_pid BIGINT NOT NULL,
    brml_version INTEGER,
    brml_branch_pid BIGINT,
    brml_license_type VARCHAR(128),
    brml_state_type VARCHAR(128),
    brml_license_number VARCHAR(128),
    brml_from_date DATE,
    brml_through_date DATE,
    brml_note VARCHAR(256)
);

CREATE TABLE history_octane.company_license
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cml_pid BIGINT NOT NULL,
    cml_version INTEGER,
    cml_company_pid BIGINT,
    cml_license_type VARCHAR(128),
    cml_state_type VARCHAR(128),
    cml_company_state_license_type VARCHAR(128),
    cml_company_state_legal_name VARCHAR(128),
    cml_use_state_specific_company_name BIT,
    cml_license_number VARCHAR(128),
    cml_from_date DATE,
    cml_through_date DATE,
    cml_note VARCHAR(256)
);

CREATE TABLE history_octane.deal
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    d_pid BIGINT NOT NULL,
    d_version INTEGER,
    d_account_pid BIGINT,
    d_company_pid BIGINT,
    d_active_proposal_pid BIGINT,
    d_branch_pid BIGINT,
    d_deal_create_date DATE,
    d_deal_status_type VARCHAR(128),
    d_velocify_lead_id VARCHAR(32),
    d_lead_zillow_zq VARCHAR(256),
    d_lead_tracking_id VARCHAR(256),
    d_lead_reference_id VARCHAR(256),
    d_los_loan_id_main BIGINT,
    d_los_loan_id_piggyback BIGINT,
    d_mers_min_main VARCHAR(20),
    d_mers_min_piggyback VARCHAR(20),
    d_external_loan_id_main VARCHAR(32),
    d_external_loan_id_piggyback VARCHAR(32),
    d_lead_source_pid BIGINT,
    d_disclosure_mode_date DATE,
    d_deal_status_date DATE,
    d_sap_deal BIT,
    d_hmda_action_date DATE,
    d_hmda_action_type VARCHAR(128),
    d_hmda_denial_reason_type_1 VARCHAR(128),
    d_hmda_denial_reason_type_2 VARCHAR(128),
    d_hmda_denial_reason_type_3 VARCHAR(128),
    d_hmda_denial_reason_type_4 VARCHAR(128),
    d_borrower_esign BIT,
    d_application_type VARCHAR(128),
    d_welcome_call_datetime TIMESTAMP,
    d_realty_agent_scenario_type VARCHAR(128),
    d_test_loan BIT,
    d_charges_enabled_date DATE,
    d_credit_bureau_type VARCHAR(128),
    d_performer_team_pid BIGINT,
    d_deal_create_type VARCHAR(128),
    d_hmda_denial_reason_other_description VARCHAR(255),
    d_effective_hmda_action_date DATE,
    d_copy_source_los_loan_id_main BIGINT,
    d_copy_source_los_loan_id_piggyback BIGINT,
    d_referred_by_name VARCHAR(128),
    d_hmda_universal_loan_id_main VARCHAR(45),
    d_hmda_universal_loan_id_piggyback VARCHAR(45),
    d_calyx_loan_guid VARCHAR(128),
    d_invoices_enabled_date DATE,
    d_invoices_enabled BIT,
    d_training_loan BIT,
    d_deal_orphan_status_type VARCHAR(128),
    d_deal_orphan_earliest_check_date DATE,
    d_deal_create_date_time TIMESTAMP,
    d_early_wire_request BIT,
    d_enable_electronic_transaction BIT
);

CREATE TABLE history_octane.appraisal
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    apr_pid BIGINT NOT NULL,
    apr_version INTEGER,
    apr_appraised_value_amount BIGINT,
    apr_effective_date DATE,
    apr_deal_pid BIGINT,
    apr_decision_appraisal BIT,
    apr_appraisal_condition_type VARCHAR(128),
    apr_appraiser_address_city VARCHAR(128),
    apr_appraiser_address_country VARCHAR(128),
    apr_appraiser_address_postal_code VARCHAR(128),
    apr_appraiser_address_state VARCHAR(128),
    apr_appraiser_address_street1 VARCHAR(128),
    apr_appraiser_address_street2 VARCHAR(128),
    apr_appraiser_company_name VARCHAR(128),
    apr_appraiser_email VARCHAR(256),
    apr_appraiser_fax VARCHAR(32),
    apr_appraiser_first_name VARCHAR(32),
    apr_appraiser_last_name VARCHAR(32),
    apr_appraiser_middle_name VARCHAR(32),
    apr_appraiser_mobile_phone VARCHAR(32),
    apr_appraiser_name_suffix VARCHAR(32),
    apr_appraiser_office_phone VARCHAR(32),
    apr_appraiser_office_phone_extension VARCHAR(16),
    apr_appraiser_title VARCHAR(128),
    apr_appraiser_license_number VARCHAR(128),
    apr_appraiser_supervisory_license_number VARCHAR(128),
    apr_appraiser_license_state VARCHAR(128),
    apr_appraisal_order_status_type VARCHAR(128),
    apr_appraisal_order_id VARCHAR(32),
    apr_appraisal_order_instructions VARCHAR(1024),
    apr_property_address_city VARCHAR(128),
    apr_property_address_country VARCHAR(128),
    apr_property_address_postal_code VARCHAR(128),
    apr_property_address_state VARCHAR(128),
    apr_property_address_street1 VARCHAR(128),
    apr_property_address_street2 VARCHAR(128),
    apr_property_county_name VARCHAR(128),
    apr_obtained_from_transfer BIT,
    apr_hud_provided BIT,
    apr_bedroom_count_unit_1 INTEGER,
    apr_bedroom_count_unit_2 INTEGER,
    apr_bedroom_count_unit_3 INTEGER,
    apr_bedroom_count_unit_4 INTEGER,
    apr_bathroom_count_unit_1 INTEGER,
    apr_bathroom_count_unit_2 INTEGER,
    apr_bathroom_count_unit_3 INTEGER,
    apr_bathroom_count_unit_4 INTEGER,
    apr_total_room_count_unit_1 INTEGER,
    apr_total_room_count_unit_2 INTEGER,
    apr_total_room_count_unit_3 INTEGER,
    apr_total_room_count_unit_4 INTEGER,
    apr_gross_living_area_square_feet_unit_1 INTEGER,
    apr_gross_living_area_square_feet_unit_2 INTEGER,
    apr_gross_living_area_square_feet_unit_3 INTEGER,
    apr_gross_living_area_square_feet_unit_4 INTEGER,
    apr_appraisal_underwriter_type VARCHAR(128),
    apr_ucdp_doc_file_id VARCHAR(10),
    apr_inspection_date DATE,
    apr_appraisal_reference_id VARCHAR(32),
    apr_ucdp_ssr_id VARCHAR(16),
    apr_sale_price_amount NUMERIC(15),
    apr_property_tax_id VARCHAR(128),
    apr_property_category_type VARCHAR(128),
    apr_cost_to_build_new NUMERIC(15),
    apr_monthly_hoa_amount NUMERIC(15, 2),
    apr_structure_built_year INTEGER,
    apr_structure_built_month INTEGER,
    apr_project_name VARCHAR(128),
    apr_road_type VARCHAR(128),
    apr_water_type VARCHAR(128),
    apr_sanitation_type VARCHAR(128),
    apr_neighborhood_location_type VARCHAR(128),
    apr_site_area NUMERIC(15),
    apr_due_date DATE,
    apr_order_date DATE,
    apr_payment_type VARCHAR(128),
    apr_payment_received_date DATE,
    apr_appraisal_source_type VARCHAR(128),
    apr_appraisal_purpose_type VARCHAR(128),
    apr_exclude BIT,
    apr_order_appraisal VARCHAR(128),
    apr_appraisal_id INTEGER,
    apr_mortgage_type VARCHAR(128),
    apr_remaining_economic_life_years INTEGER,
    apr_deficient_economic_life_explanation VARCHAR(1024),
    apr_hve_point_value_estimate_amount NUMERIC(15, 2),
    apr_hve_forecast_standard_deviation_percent NUMERIC(11, 9),
    apr_hve_confidence_level_type VARCHAR(128),
    apr_hve_variance_percent NUMERIC(11, 9),
    apr_hve_excessive_value_message VARCHAR(1024),
    apr_cu_risk_score NUMERIC(10, 2),
    apr_license_expiration_date DATE,
    apr_supervisor_required BIT,
    apr_supervisory_appraiser_first_name VARCHAR(32),
    apr_supervisory_appraiser_middle_name VARCHAR(32),
    apr_supervisory_appraiser_last_name VARCHAR(32),
    apr_supervisory_appraiser_name_suffix VARCHAR(32),
    apr_supervisory_license_state VARCHAR(128),
    apr_supervisory_license_expiration_date DATE,
    apr_synthetic_unique BIT
);

CREATE TABLE history_octane.appraisal_form
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    aprfm_pid BIGINT NOT NULL,
    aprfm_version INTEGER,
    aprfm_appraisal_pid BIGINT,
    aprfm_appraisal_source_type VARCHAR(128),
    aprfm_appraisal_form_type VARCHAR(128)
);

CREATE TABLE history_octane.appraisal_id_ticker
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    aprtk_pid BIGINT NOT NULL,
    aprtk_version INTEGER,
    aprtk_deal_pid BIGINT,
    aprtk_next_id INTEGER
);

CREATE TABLE history_octane.deal_appraisal
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dappr_pid BIGINT NOT NULL,
    dappr_version INTEGER,
    dappr_deal_pid BIGINT,
    dappr_door_lock_combination BIT,
    dappr_appraisal_entry_contact_type VARCHAR(128),
    dappr_appraisal_hold_type VARCHAR(128),
    dappr_appraisal_hold_reason_type VARCHAR(128),
    dappr_hold_release_date DATE,
    dappr_rush_request BIT,
    dappr_transfer_specified BIT,
    dappr_calculated_appraisal_required BIT,
    dappr_override_calculated_appraisal_required BIT,
    dappr_override_calculated_appraisal_required_reason VARCHAR(16000),
    dappr_borrower_requires_appraisal VARCHAR(128),
    dappr_lender_requires_appraisal BIT,
    dappr_product_requires_appraisal BIT,
    dappr_appraisal_required BIT
);

CREATE TABLE history_octane.deal_contact
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dc_pid BIGINT NOT NULL,
    dc_version INTEGER,
    dc_address_city VARCHAR(128),
    dc_address_country VARCHAR(128),
    dc_address_postal_code VARCHAR(128),
    dc_address_state VARCHAR(128),
    dc_address_street1 VARCHAR(128),
    dc_address_street2 VARCHAR(128),
    dc_company_name VARCHAR(128),
    dc_deal_pid BIGINT,
    dc_email VARCHAR(256),
    dc_fax VARCHAR(32),
    dc_first_name VARCHAR(32),
    dc_last_name VARCHAR(32),
    dc_middle_name VARCHAR(32),
    dc_mobile_phone VARCHAR(32),
    dc_name_suffix VARCHAR(32),
    dc_office_phone VARCHAR(32),
    dc_office_phone_extension VARCHAR(16),
    dc_role_type VARCHAR(128),
    dc_title VARCHAR(128),
    dc_company_license_id VARCHAR(128)
);

CREATE TABLE history_octane.deal_disaster_declaration
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ddd_pid BIGINT NOT NULL,
    ddd_version INTEGER,
    ddd_deal_pid BIGINT,
    ddd_disaster_declaration_pid BIGINT
);

CREATE TABLE history_octane.deal_du
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ddu_pid BIGINT NOT NULL,
    ddu_version INTEGER,
    ddu_deal_pid BIGINT,
    ddu_du_casefile_id VARCHAR(32),
    ddu_du_institution_id VARCHAR(16)
);

CREATE TABLE history_octane.deal_event
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    de_pid BIGINT NOT NULL,
    de_version INTEGER,
    de_create_datetime TIMESTAMP,
    de_deal_event_type VARCHAR(128),
    de_deal_pid BIGINT,
    de_deal_task_pid BIGINT,
    de_deal_note_pid BIGINT,
    de_deal_message_log_pid BIGINT,
    de_proposal_doc_pid BIGINT,
    de_proposal_doc_file_pid BIGINT,
    de_wf_deal_step_pid BIGINT,
    de_proposal_pid BIGINT,
    de_detail VARCHAR(16000),
    de_source_unparsed_name VARCHAR(128),
    de_coarse_event_type VARCHAR(128),
    de_borrower_text VARCHAR(1024),
    de_create_nanoseconds INTEGER
);

CREATE TABLE history_octane.deal_housing_counselors_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dhcr_pid BIGINT NOT NULL,
    dhcr_version INTEGER,
    dhcr_deal_pid BIGINT,
    dhcr_centroid_address_street1 VARCHAR(128),
    dhcr_centroid_address_street2 VARCHAR(128),
    dhcr_centroid_address_city VARCHAR(128),
    dhcr_centroid_address_state VARCHAR(128),
    dhcr_centroid_address_postal_code VARCHAR(128),
    dhcr_centroid_address_country VARCHAR(128),
    dhcr_error_messages TEXT
);

CREATE TABLE history_octane.deal_housing_counselor_candidate
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dhcc_pid BIGINT NOT NULL,
    dhcc_version INTEGER,
    dhcc_deal_pid BIGINT,
    dhcc_deal_housing_counselors_request_pid BIGINT,
    dhcc_counseling_agency_id VARCHAR(16),
    dhcc_office_name VARCHAR(256),
    dhcc_office_address_street1 VARCHAR(128),
    dhcc_office_address_street2 VARCHAR(128),
    dhcc_office_address_city VARCHAR(128),
    dhcc_office_address_state VARCHAR(128),
    dhcc_office_address_postal_code VARCHAR(128),
    dhcc_office_address_country VARCHAR(128),
    dhcc_office_email VARCHAR(256),
    dhcc_office_fax VARCHAR(32),
    dhcc_office_phone1 VARCHAR(32),
    dhcc_office_phone2 VARCHAR(32),
    dhcc_mailing_address_street1 VARCHAR(128),
    dhcc_mailing_address_street2 VARCHAR(128),
    dhcc_mailing_address_city VARCHAR(128),
    dhcc_mailing_address_state VARCHAR(128),
    dhcc_mailing_address_postal_code VARCHAR(128),
    dhcc_mailing_address_country VARCHAR(128),
    dhcc_web_url VARCHAR(256),
    dhcc_language_codes VARCHAR(256),
    dhcc_address_latitude NUMERIC(15, 3),
    dhcc_address_longitude NUMERIC(15, 3),
    dhcc_service_codes VARCHAR(1500),
    dhcc_county_name VARCHAR(128),
    dhcc_faith_based BIT,
    dhcc_migrant_workers BIT,
    dhcc_colonias BIT,
    dhcc_parent_org_id VARCHAR(16),
    dhcc_ordinal INTEGER
);

CREATE TABLE history_octane.deal_invoice
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    di_pid BIGINT NOT NULL,
    di_version INTEGER,
    di_deal_pid BIGINT,
    di_create_datetime TIMESTAMP,
    di_invoice_amount NUMERIC(15, 2),
    di_refund_amount NUMERIC(15, 2),
    di_smart_invoice BIT,
    di_invoice_status_type VARCHAR(128),
    di_description VARCHAR(256),
    di_internal_notes VARCHAR(1024)
);

CREATE TABLE history_octane.deal_invoice_item
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dii_pid BIGINT NOT NULL,
    dii_version INTEGER,
    dii_deal_invoice_pid BIGINT,
    dii_charge_type VARCHAR(128),
    dii_item_amount NUMERIC(15, 2),
    dii_smart_item BIT,
    dii_adjustment BIT
);

CREATE TABLE history_octane.deal_lender_user_event
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dlue_pid BIGINT NOT NULL,
    dlue_version INTEGER,
    dlue_deal_pid BIGINT,
    dlue_subject_lender_user_pid BIGINT,
    dlue_role_pid BIGINT,
    dlue_create_datetime TIMESTAMP,
    dlue_unparsed_text VARCHAR(1024)
);

CREATE TABLE history_octane.deal_lp
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dlp_pid BIGINT NOT NULL,
    dlp_version INTEGER,
    dlp_deal_pid BIGINT,
    dlp_lp_loan_id VARCHAR(32),
    dlp_lp_key_id VARCHAR(32)
);

CREATE TABLE history_octane.deal_performer_team
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dptm_pid BIGINT NOT NULL,
    dptm_version INTEGER,
    dptm_deal_pid BIGINT,
    dptm_performer_team_pid BIGINT
);

CREATE TABLE history_octane.deal_real_estate_agent
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    drea_pid BIGINT NOT NULL,
    drea_version INTEGER,
    drea_deal_pid BIGINT,
    drea_first_name VARCHAR(32),
    drea_middle_name VARCHAR(32),
    drea_last_name VARCHAR(32),
    drea_name_suffix VARCHAR(32),
    drea_company_name VARCHAR(128),
    drea_title VARCHAR(128),
    drea_office_phone VARCHAR(32),
    drea_office_phone_extension VARCHAR(16),
    drea_mobile_phone VARCHAR(32),
    drea_email VARCHAR(256),
    drea_fax VARCHAR(32),
    drea_street_1 VARCHAR(128),
    drea_street_2 VARCHAR(128),
    drea_city VARCHAR(128),
    drea_state VARCHAR(128),
    drea_country VARCHAR(128),
    drea_postal_code VARCHAR(128),
    drea_license_id VARCHAR(128),
    drea_company_license_id VARCHAR(128),
    drea_agency_type VARCHAR(128)
);

CREATE TABLE history_octane.deal_settlement
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dsmt_pid BIGINT NOT NULL,
    dsmt_version INTEGER,
    dsmt_account_pid BIGINT,
    dsmt_deal_pid BIGINT,
    dsmt_borrower_elected_preferred_settlement VARCHAR(128),
    dsmt_settlement_agent_escrow_id VARCHAR(32),
    dsmt_title_company_reference_id VARCHAR(32),
    dsmt_settlement_agent_pid BIGINT,
    dsmt_settlement_agent_office_pid BIGINT,
    dsmt_settlement_agent_wire_pid BIGINT,
    dsmt_settlement_agent_first_name VARCHAR(128),
    dsmt_settlement_agent_last_name VARCHAR(128),
    dsmt_settlement_agent_phone VARCHAR(32),
    dsmt_settlement_agent_phone_extension VARCHAR(16),
    dsmt_settlement_agent_email VARCHAR(256),
    dsmt_settlement_agent_contact_license_id VARCHAR(128),
    dsmt_settlement_agent_preferred_vendor BIT,
    dsmt_for_further_credit VARCHAR(128),
    dsmt_beneficiary_for_further_credit VARCHAR(128),
    dsmt_title_company_pid BIGINT,
    dsmt_title_company_office_pid BIGINT,
    dsmt_title_company_first_name VARCHAR(128),
    dsmt_title_company_last_name VARCHAR(128),
    dsmt_title_company_phone VARCHAR(32),
    dsmt_title_company_phone_extension VARCHAR(16),
    dsmt_title_company_email VARCHAR(256),
    dsmt_title_company_contact_license_id VARCHAR(128),
    dsmt_title_company_preferred_vendor BIT,
    dsmt_title_insurance_underwriter_company_name VARCHAR(128),
    dsmt_title_insurance_attorney_first_name VARCHAR(32),
    dsmt_title_insurance_attorney_middle_name VARCHAR(32),
    dsmt_title_insurance_attorney_last_name VARCHAR(32),
    dsmt_title_insurance_attorney_name_suffix VARCHAR(32),
    dsmt_title_insurance_attorney_license_number VARCHAR(32)
);

CREATE TABLE history_octane.deal_signer
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dsi_pid BIGINT NOT NULL,
    dsi_version INTEGER,
    dsi_deal_pid BIGINT,
    dsi_email VARCHAR(256),
    dsi_first_name VARCHAR(32),
    dsi_middle_name VARCHAR(32),
    dsi_last_name VARCHAR(32),
    dsi_name_suffix VARCHAR(32),
    dsi_signer_id VARCHAR(256)
);

CREATE TABLE history_octane.deal_stage
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dst_pid BIGINT NOT NULL,
    dst_version INTEGER,
    dst_deal_pid BIGINT,
    dst_deal_stage_type VARCHAR(128),
    dst_from_date DATE,
    dst_from_datetime TIMESTAMP,
    dst_through_date DATE,
    dst_through_datetime TIMESTAMP,
    dst_duration_seconds BIGINT,
    dst_business_hours_duration_seconds BIGINT
);

CREATE TABLE history_octane.deal_summary
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ds_pid BIGINT NOT NULL,
    ds_version INTEGER,
    ds_deal_pid BIGINT,
    ds_lender_lock_expiration_datetime_main TIMESTAMP,
    ds_lender_lock_expiration_datetime_piggyback TIMESTAMP,
    ds_lender_lock_status_type_main VARCHAR(128),
    ds_lender_lock_status_type_piggyback VARCHAR(128),
    ds_decision_appraisal_condition_type VARCHAR(128),
    ds_funding_status_type_main VARCHAR(128),
    ds_funding_status_type_piggyback VARCHAR(128),
    ds_purchase_advice_date_main DATE,
    ds_purchase_advice_date_piggyback DATE,
    ds_last_wf_phase_number INTEGER,
    ds_last_wf_phase_name VARCHAR(128),
    ds_eligible_investor_ids_main VARCHAR(16000),
    ds_eligible_investor_ids_piggyback VARCHAR(16000),
    ds_decision_appraisal_cu_risk_score NUMERIC(10, 2),
    ds_deal_stage_type VARCHAR(128),
    ds_deal_stage_from_datetime TIMESTAMP,
    ds_funded_main BIT,
    ds_funded_piggyback BIT,
    ds_most_recent_user_update_date DATE,
    ds_lock_vintage_date_main DATE,
    ds_lock_vintage_date_piggyback DATE,
    ds_lender_lock_datetime_main TIMESTAMP,
    ds_lender_lock_datetime_piggyback TIMESTAMP,
    ds_any_unrequested_packages BIT
);

CREATE TABLE history_octane.investor_lock_extension_setting
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    iles_pid BIGINT NOT NULL,
    iles_version INTEGER,
    iles_investor_pid BIGINT,
    iles_from_date DATE,
    iles_through_date DATE,
    iles_extension_days INTEGER,
    iles_price_adjustment_percent NUMERIC(11, 9),
    iles_auto_confirm BIT
);

CREATE TABLE history_octane.lead
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ld_pid BIGINT NOT NULL,
    ld_version INTEGER,
    ld_deal_pid BIGINT,
    ld_lead_datetime VARCHAR(32),
    ld_velocify_campaign_id VARCHAR(32),
    ld_velocify_campaign_title VARCHAR(32),
    ld_originator_email VARCHAR(256),
    ld_customer_service_rep_name VARCHAR(128),
    ld_velocify_lead_id VARCHAR(32),
    ld_tracking_id VARCHAR(256),
    ld_zillow_zq VARCHAR(256),
    ld_reference_id VARCHAR(256),
    ld_apr_percent VARCHAR(16),
    ld_interest_rate VARCHAR(16),
    ld_rate_type VARCHAR(32),
    ld_fico_score VARCHAR(16),
    ld_loan_type VARCHAR(32),
    ld_notes VARCHAR(1024),
    ld_loan_purpose_type VARCHAR(32),
    ld_purchase_price VARCHAR(32),
    ld_existing_home_value VARCHAR(32),
    ld_loan_amount VARCHAR(32),
    ld_property_use VARCHAR(32),
    ld_subject_property_street VARCHAR(128),
    ld_subject_property_city VARCHAR(128),
    ld_subject_property_state VARCHAR(128),
    ld_subject_property_postal_code VARCHAR(128),
    ld_subject_property_type VARCHAR(32),
    ld_borrower_first_name VARCHAR(32),
    ld_borrower_last_name VARCHAR(32),
    ld_borrower_home_phone VARCHAR(32),
    ld_borrower_mobile_phone VARCHAR(32),
    ld_borrower_email VARCHAR(256),
    ld_borrower_birth_date VARCHAR(32),
    ld_borrower_residence_street VARCHAR(128),
    ld_borrower_residence_city VARCHAR(128),
    ld_borrower_residence_state VARCHAR(128),
    ld_borrower_residence_postal_code VARCHAR(128),
    ld_coborrower_first_name VARCHAR(32),
    ld_coborrower_middle_name VARCHAR(32),
    ld_coborrower_last_name VARCHAR(32),
    ld_coborrower_email VARCHAR(256),
    ld_coborrower_birth_date VARCHAR(32),
    ld_borrower_current_job_employer_name VARCHAR(128),
    ld_borrower_current_job_position VARCHAR(32),
    ld_borrower_years_on_job VARCHAR(16),
    ld_borrower_gross_monthly_income VARCHAR(32)
);

CREATE TABLE history_octane.lender_user
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lu_pid BIGINT NOT NULL,
    lu_version INTEGER,
    lu_branch_pid BIGINT,
    lu_account_owner BIT,
    lu_account_pid BIGINT,
    lu_create_date DATE,
    lu_first_name VARCHAR(32),
    lu_last_name VARCHAR(32),
    lu_middle_name VARCHAR(32),
    lu_name_suffix VARCHAR(32),
    lu_company_name VARCHAR(128),
    lu_title VARCHAR(128),
    lu_office_phone VARCHAR(32),
    lu_office_phone_extension VARCHAR(16),
    lu_email VARCHAR(256),
    lu_fax VARCHAR(32),
    lu_city VARCHAR(128),
    lu_country VARCHAR(128),
    lu_postal_code VARCHAR(128),
    lu_state VARCHAR(128),
    lu_street1 VARCHAR(128),
    lu_street2 VARCHAR(128),
    lu_office_phone_use_branch BIT,
    lu_fax_use_branch BIT,
    lu_address_use_branch BIT,
    lu_start_date DATE,
    lu_through_date DATE,
    lu_time_zone VARCHAR(128),
    lu_unparsed_name VARCHAR(128),
    lu_lender_user_status_type VARCHAR(128),
    lu_username VARCHAR(32),
    lu_nmls_loan_originator_id VARCHAR(16),
    lu_fha_chums_id VARCHAR(16),
    lu_va_agent_id VARCHAR(32),
    lu_search_text VARCHAR(256),
    lu_company_user_id VARCHAR(32),
    lu_force_password_change BIT,
    lu_last_password_change_date TIMESTAMP,
    lu_challenge_question_type VARCHAR(128),
    lu_challenge_question_answer VARCHAR(128),
    lu_allow_external_ip BIT,
    lu_total_workload_cap INTEGER,
    lu_schedule_once_booking_page_id VARCHAR(128),
    lu_performer_team_pid BIGINT,
    lu_esign_only BIT,
    lu_work_step_start_notices_enabled BIT,
    lu_smart_app_enabled BIT,
    lu_default_lead_source_pid BIGINT,
    lu_default_credit_bureau_type VARCHAR(128),
    lu_originator_id VARCHAR(32),
    lu_name_qualifier VARCHAR(16),
    lu_training_mode BIT,
    lu_about_me VARCHAR(2000),
    lu_lender_user_type VARCHAR(128),
    lu_hire_date DATE,
    lu_mercury_client_group_pid BIGINT,
    lu_nickname VARCHAR(32),
    lu_preferred_first_name VARCHAR(32),
    lu_hub_directory BIT
);

CREATE TABLE history_octane.backfill_status
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bfs_pid BIGINT NOT NULL,
    bfs_version INTEGER,
    bfs_account_pid BIGINT,
    bfs_batch_id VARCHAR(128),
    bfs_name VARCHAR(128),
    bfs_lender_user_pid BIGINT,
    bfs_submit_datetime TIMESTAMP,
    bfs_completed_datetime TIMESTAMP,
    bfs_num_loans INTEGER,
    bfs_backfill_status_type VARCHAR(128),
    bfs_failure_info VARCHAR(16000),
    bfs_raw_header_row VARCHAR(16000)
);

CREATE TABLE history_octane.backfill_loan_status
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bfls_pid BIGINT NOT NULL,
    bfls_version INTEGER,
    bfls_backfill_status_pid BIGINT,
    bfls_los_loan_id VARCHAR(32),
    bfls_started_datetime TIMESTAMP,
    bfls_completed_datetime TIMESTAMP,
    bfls_backfill_status_type VARCHAR(128),
    bfls_failure_info VARCHAR(16000),
    bfls_raw_loan_row VARCHAR(16000),
    bfls_warning_info VARCHAR(16000)
);

CREATE TABLE history_octane.bid_pool_note
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bpn_pid BIGINT NOT NULL,
    bpn_version INTEGER,
    bpn_bid_pool_pid BIGINT,
    bpn_create_datetime TIMESTAMP,
    bpn_content VARCHAR(16000),
    bpn_author_lender_user_pid BIGINT,
    bpn_author_unparsed_name VARCHAR(128)
);

CREATE TABLE history_octane.bid_pool_note_comment
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bpnc_pid BIGINT NOT NULL,
    bpnc_version INTEGER,
    bpnc_bid_pool_note_pid BIGINT,
    bpnc_create_datetime TIMESTAMP,
    bpnc_content VARCHAR(16000),
    bpnc_author_lender_user_pid BIGINT,
    bpnc_author_unparsed_name VARCHAR(128)
);

CREATE TABLE history_octane.bid_pool_note_monitor
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bpnm_pid BIGINT NOT NULL,
    bpnm_version INTEGER,
    bpnm_bid_pool_note_pid BIGINT,
    bpnm_lender_user_pid BIGINT
);

CREATE TABLE history_octane.branch_account_executive
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    brae_pid BIGINT NOT NULL,
    brae_version INTEGER,
    brae_branch_pid BIGINT,
    brae_lender_user_pid BIGINT,
    brae_from_date DATE
);

CREATE TABLE history_octane.deal_invoice_payment_method
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dipm_pid BIGINT NOT NULL,
    dipm_version INTEGER,
    dipm_deal_invoice_pid BIGINT,
    dipm_payer_type VARCHAR(128),
    dipm_configured_payer_type VARCHAR(128),
    dipm_payer_unparsed_name VARCHAR(128),
    dipm_payment_fulfill_type VARCHAR(128),
    dipm_payment_transfer_los_loan_id_main BIGINT,
    dipm_payment_processing_company_type VARCHAR(128),
    dipm_stripe_payment_pid BIGINT,
    dipm_stripe_payment_refund_pid BIGINT,
    dipm_requester_agent_type VARCHAR(128),
    dipm_requester_lender_user_pid BIGINT,
    dipm_requester_unparsed_name VARCHAR(128),
    dipm_payment_submission_type VARCHAR(128),
    dipm_payment_completed_date DATE
);

CREATE TABLE history_octane.deal_key_roles
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dkrs_pid BIGINT NOT NULL,
    dkrs_version INTEGER,
    dkrs_deal_pid BIGINT,
    dkrs_originator_lender_user_pid BIGINT,
    dkrs_originator_first_name VARCHAR(32),
    dkrs_originator_last_name VARCHAR(32),
    dkrs_originator_middle_name VARCHAR(32),
    dkrs_originator_fmls_basic VARCHAR(128),
    dkrs_originator_nmls_id VARCHAR(16),
    dkrs_supplemental_originator_lender_user_pid BIGINT,
    dkrs_supplemental_originator_fmls VARCHAR(128),
    dkrs_account_executive_lender_user_pid BIGINT,
    dkrs_account_executive_fmls VARCHAR(128),
    dkrs_investor_conditions_lender_user_pid BIGINT,
    dkrs_investor_conditions_fmls VARCHAR(128),
    dkrs_investor_stack_to_investor_lender_user_pid BIGINT,
    dkrs_investor_stack_to_investor_fmls VARCHAR(128),
    dkrs_collateral_to_custodian_lender_user_pid BIGINT,
    dkrs_collateral_to_custodian_fmls VARCHAR(128),
    dkrs_collateral_to_investor_lender_user_pid BIGINT,
    dkrs_collateral_to_investor_fmls VARCHAR(128),
    dkrs_transaction_assistant_lender_user_pid BIGINT,
    dkrs_transaction_assistant_fmls VARCHAR(128),
    dkrs_final_documents_to_investor_lender_user_pid BIGINT,
    dkrs_final_documents_to_investor_fmls VARCHAR(128),
    dkrs_government_insurance_lender_user_pid BIGINT,
    dkrs_government_insurance_fmls VARCHAR(128),
    dkrs_funder_lender_user_pid BIGINT,
    dkrs_funder_fmls VARCHAR(128),
    dkrs_processor_lender_user_pid BIGINT,
    dkrs_processor_fmls VARCHAR(128),
    dkrs_underwriter_lender_user_pid BIGINT,
    dkrs_underwriter_fmls VARCHAR(128),
    dkrs_project_underwriter_lender_user_pid BIGINT,
    dkrs_project_underwriter_fmls VARCHAR(128),
    dkrs_closing_doc_specialist_lender_user_pid BIGINT,
    dkrs_closing_doc_specialist_fmls VARCHAR(128),
    dkrs_wholesale_client_advocate_lender_user_pid BIGINT,
    dkrs_wholesale_client_advocate_fmls VARCHAR(128),
    dkrs_closing_scheduler_lender_user_pid BIGINT,
    dkrs_closing_scheduler_fmls VARCHAR(128),
    dkrs_collateral_underwriter_lender_user_pid BIGINT,
    dkrs_collateral_underwriter_fmls VARCHAR(128),
    dkrs_correspondent_client_advocate_lender_user_pid BIGINT,
    dkrs_correspondent_client_advocate_fmls VARCHAR(128),
    dkrs_flood_insurance_specialist_lender_user_pid BIGINT,
    dkrs_flood_insurance_specialist_fmls VARCHAR(128),
    dkrs_hoa_specialist_lender_user_pid BIGINT,
    dkrs_hoa_specialist_fmls VARCHAR(128),
    dkrs_hoi_specialist_lender_user_pid BIGINT,
    dkrs_hoi_specialist_fmls VARCHAR(128),
    dkrs_ho6_specialist_lender_user_pid BIGINT,
    dkrs_ho6_specialist_fmls VARCHAR(128),
    dkrs_hud_va_lender_officer_lender_user_pid BIGINT,
    dkrs_hud_va_lender_officer_fmls VARCHAR(128),
    dkrs_loan_officer_assistant_lender_user_pid BIGINT,
    dkrs_loan_officer_assistant_fmls VARCHAR(128),
    dkrs_loan_payoff_specialist_lender_user_pid BIGINT,
    dkrs_loan_payoff_specialist_fmls VARCHAR(128),
    dkrs_subordination_specialist_lender_user_pid BIGINT,
    dkrs_subordination_specialist_fmls VARCHAR(128),
    dkrs_title_specialist_lender_user_pid BIGINT,
    dkrs_title_specialist_fmls VARCHAR(128),
    dkrs_underwriting_manager_lender_user_pid BIGINT,
    dkrs_underwriting_manager_fmls VARCHAR(128),
    dkrs_va_specialist_lender_user_pid BIGINT,
    dkrs_va_specialist_fmls VARCHAR(128),
    dkrs_verbal_voe_specialist_lender_user_pid BIGINT,
    dkrs_verbal_voe_specialist_fmls VARCHAR(128),
    dkrs_voe_specialist_lender_user_pid BIGINT,
    dkrs_voe_specialist_fmls VARCHAR(128),
    dkrs_wire_specialist_lender_user_pid BIGINT,
    dkrs_wire_specialist_fmls VARCHAR(128)
);

CREATE TABLE history_octane.deal_lender_user
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dlu_pid BIGINT NOT NULL,
    dlu_version INTEGER,
    dlu_deal_pid BIGINT,
    dlu_lender_user_pid BIGINT,
    dlu_role_pid BIGINT,
    dlu_loan_access_type VARCHAR(128),
    dlu_legacy_role_assignment_type VARCHAR(128),
    dlu_legacy_role_assignment_date DATE,
    dlu_synthetic_unique VARCHAR(32)
);

CREATE TABLE history_octane.deal_performer_team_user
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dptu_pid BIGINT NOT NULL,
    dptu_version INTEGER,
    dptu_deal_pid BIGINT,
    dptu_performer_team_pid BIGINT,
    dptu_user_pid BIGINT
);

CREATE TABLE history_octane.dw_export_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dwer_pid BIGINT NOT NULL,
    dwer_version INTEGER,
    dwer_account_pid BIGINT,
    dwer_create_datetime TIMESTAMP,
    dwer_start_datetime TIMESTAMP,
    dwer_end_datetime TIMESTAMP,
    dwer_request_status_type VARCHAR(128),
    dwer_request_status_messages TEXT,
    dwer_requester_lender_user_pid BIGINT,
    dwer_requester_unparsed_name VARCHAR(128),
    dwer_exported_deal_count INTEGER,
    dwer_export_id VARCHAR(16)
);

CREATE TABLE history_octane.lender_settings
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lss_pid BIGINT NOT NULL,
    lss_version INTEGER,
    lss_account_pid BIGINT,
    lss_company_time_zone_type VARCHAR(128),
    lss_va_lender_id VARCHAR(16),
    lss_usda_lender_id VARCHAR(16),
    lss_fha_lender_id VARCHAR(16),
    lss_fha_home_office_branch_pid BIGINT,
    lss_fha_sponsor_id VARCHAR(16),
    lss_fha_sponsor_company_name VARCHAR(32),
    lss_fha_sponsor_address_street1 VARCHAR(128),
    lss_fha_sponsor_address_street2 VARCHAR(128),
    lss_fha_sponsor_address_city VARCHAR(128),
    lss_fha_sponsor_address_state VARCHAR(128),
    lss_fha_sponsor_address_postal_code VARCHAR(128),
    lss_fha_sponsor_address_country VARCHAR(128),
    lss_fha_non_supervised_mortgagee BIT,
    lss_fnma_seller_id VARCHAR(16),
    lss_fre_seller_id VARCHAR(16),
    lss_lp_submission_type VARCHAR(128),
    lss_lender_user_email_from VARCHAR(256),
    lss_hmda_contact_pid BIGINT,
    lss_hmda_legal_entity_id VARCHAR(20),
    lss_hmda_respondent_id VARCHAR(32),
    lss_hmda_agency_id_type VARCHAR(128),
    lss_prequalification_program BIT,
    lss_preapproval_program BIT,
    lss_pest_inspector_company_name VARCHAR(128),
    lss_pest_inspector_phone VARCHAR(32),
    lss_pest_inspector_website_url VARCHAR(256),
    lss_pest_inspector_address_street1 VARCHAR(128),
    lss_pest_inspector_address_street2 VARCHAR(128),
    lss_pest_inspector_address_city VARCHAR(128),
    lss_pest_inspector_address_state VARCHAR(128),
    lss_pest_inspector_address_postal_code VARCHAR(128),
    lss_take_application_hours VARCHAR(128),
    lss_originator_title VARCHAR(128),
    lss_default_credit_bureau_type VARCHAR(128),
    lss_sap_minimum_decision_credit_score INTEGER,
    lss_default_standalone_lock_term_setting_pid BIGINT,
    lss_default_combo_lock_term_setting_pid BIGINT,
    lss_preferred_aus_type VARCHAR(128),
    lss_borrower_quote_filter_pivot_type VARCHAR(128),
    lss_borrower_quote_filter_pivot_lower_count INTEGER,
    lss_borrower_quote_filter_pivot_higher_count INTEGER
);

CREATE TABLE history_octane.lender_user_allowed_ip
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    luip_pid BIGINT NOT NULL,
    luip_version INTEGER,
    luip_lender_user_pid BIGINT,
    luip_status VARCHAR(128),
    luip_ip_address VARCHAR(32),
    luip_request_id VARCHAR(128),
    luip_request_expiration_datetime TIMESTAMP,
    luip_last_used_datetime TIMESTAMP,
    luip_first_used_datetime TIMESTAMP
);

CREATE TABLE history_octane.lender_user_deal_visit
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ludv_pid BIGINT NOT NULL,
    ludv_version INTEGER,
    ludv_deal_pid BIGINT,
    ludv_lender_user_pid BIGINT,
    ludv_visited_datetime TIMESTAMP
);

CREATE TABLE history_octane.lender_user_lead_source
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lulds_pid BIGINT NOT NULL,
    lulds_version INTEGER,
    lulds_lender_user_pid BIGINT,
    lulds_lead_source_pid BIGINT
);

CREATE TABLE history_octane.lender_user_license
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    luml_pid BIGINT NOT NULL,
    luml_version INTEGER,
    luml_lender_user_pid BIGINT,
    luml_license_type VARCHAR(128),
    luml_state_type VARCHAR(128),
    luml_license_number VARCHAR(128),
    luml_from_date DATE,
    luml_through_date DATE,
    luml_note VARCHAR(256)
);

CREATE TABLE history_octane.lender_user_notice
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lun_pid BIGINT NOT NULL,
    lun_version INTEGER,
    lun_lender_user_pid BIGINT,
    lun_deal_pid BIGINT,
    lun_create_datetime TIMESTAMP,
    lun_lender_user_notice_type VARCHAR(128),
    lun_detail VARCHAR(16000),
    lun_source_unparsed_name VARCHAR(128)
);

CREATE TABLE history_octane.lender_user_role
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lur_pid BIGINT NOT NULL,
    lur_version INTEGER,
    lur_lender_user_pid BIGINT,
    lur_role_pid BIGINT,
    lur_criteria_pid BIGINT,
    lur_workload_cap INTEGER,
    lur_daily_cap INTEGER,
    lur_assignment_gap_minutes INTEGER,
    lur_secondary_role BIT,
    lur_subscribe_smart_messages BIT,
    lur_for_training_only BIT,
    lur_notes VARCHAR(16000),
    lur_queue_type VARCHAR(128),
    lur_queue_datetime TIMESTAMP
);

CREATE TABLE history_octane.exclusive_assignment
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ea_pid BIGINT NOT NULL,
    ea_version INTEGER,
    ea_lender_user_role_pid BIGINT,
    ea_criteria_pid BIGINT,
    ea_priority INTEGER,
    ea_name VARCHAR(128)
);

CREATE TABLE history_octane.lender_user_role_addendum
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lura_pid BIGINT NOT NULL,
    lura_version INTEGER,
    lura_lender_user_pid BIGINT,
    lura_lender_user_role_pid BIGINT,
    lura_role_pid BIGINT
);

CREATE TABLE history_octane.lender_user_sign_on
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    luso_pid BIGINT NOT NULL,
    luso_version INTEGER,
    luso_lender_user_pid BIGINT,
    luso_last_sign_on_datetime TIMESTAMP
);

CREATE TABLE history_octane.lender_user_unavailable
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    luu_pid BIGINT NOT NULL,
    luu_version INTEGER,
    luu_lender_user_pid BIGINT,
    luu_from_date DATE,
    luu_through_date DATE
);

CREATE TABLE history_octane.mercury_network_status_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    mnsr_pid BIGINT NOT NULL,
    mnsr_version INTEGER,
    mnsr_deal_pid BIGINT,
    mnsr_mercury_network_order_id VARCHAR(128),
    mnsr_mercury_network_status_type VARCHAR(128),
    mnsr_status_message VARCHAR(16000)
);

CREATE TABLE history_octane.org_division_leader
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    orgdl_pid BIGINT NOT NULL,
    orgdl_version INTEGER,
    orgdl_lender_user_pid BIGINT,
    orgdl_org_division_pid BIGINT,
    orgdl_from_date DATE,
    orgdl_through_date DATE,
    orgdl_org_leader_position_type VARCHAR(128)
);

CREATE TABLE history_octane.org_group_leader
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    orggl_pid BIGINT NOT NULL,
    orggl_version INTEGER,
    orggl_lender_user_pid BIGINT,
    orggl_org_group_pid BIGINT,
    orggl_from_date DATE,
    orggl_through_date DATE,
    orggl_org_leader_position_type VARCHAR(128)
);

CREATE TABLE history_octane.org_lender_user_terms
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    orglut_pid BIGINT NOT NULL,
    orglut_version INTEGER,
    orglut_org_team_pid BIGINT,
    orglut_lender_user_pid BIGINT,
    orglut_from_date DATE,
    orglut_through_date DATE
);

CREATE TABLE history_octane.org_region_leader
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    orgrl_pid BIGINT NOT NULL,
    orgrl_version INTEGER,
    orgrl_lender_user_pid BIGINT,
    orgrl_org_region_pid BIGINT,
    orgrl_from_date DATE,
    orgrl_through_date DATE,
    orgrl_org_leader_position_type VARCHAR(128)
);

CREATE TABLE history_octane.org_team_leader
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    orgtl_pid BIGINT NOT NULL,
    orgtl_version INTEGER,
    orgtl_lender_user_pid BIGINT,
    orgtl_org_team_pid BIGINT,
    orgtl_from_date DATE,
    orgtl_through_date DATE,
    orgtl_org_leader_position_type VARCHAR(128)
);

CREATE TABLE history_octane.org_unit_leader
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    orgul_pid BIGINT NOT NULL,
    orgul_version INTEGER,
    orgul_lender_user_pid BIGINT,
    orgul_org_unit_pid BIGINT,
    orgul_from_date DATE,
    orgul_through_date DATE,
    orgul_org_leader_position_type VARCHAR(128)
);

CREATE TABLE history_octane.performer_assignment
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pa_pid BIGINT NOT NULL,
    pa_version INTEGER,
    pa_role_pid BIGINT,
    pa_lender_user_pid BIGINT,
    pa_last_assign_datetime TIMESTAMP
);

CREATE TABLE history_octane.product
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    p_pid BIGINT NOT NULL,
    p_version INTEGER,
    p_account_pid BIGINT,
    p_investor_pid BIGINT,
    p_fund_source_type VARCHAR(128),
    p_investor_product_id VARCHAR(32),
    p_investor_product_name VARCHAR(128),
    p_from_date DATE,
    p_through_date DATE,
    p_fnm_product_name VARCHAR(15),
    p_lock_auto_confirm BIT,
    p_description VARCHAR(1024),
    p_product_side_type VARCHAR(128),
    p_parent_product_pid BIGINT
);

CREATE TABLE history_octane.offering_product
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ofp_pid BIGINT NOT NULL,
    ofp_version INTEGER,
    ofp_offering_pid BIGINT,
    ofp_product_pid BIGINT,
    ofp_from_date DATE,
    ofp_through_date DATE,
    ofp_price_adjustment_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.product_add_on
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pao_pid BIGINT NOT NULL,
    pao_version INTEGER,
    pao_product_pid BIGINT,
    pao_from_date DATE
);

CREATE TABLE history_octane.product_add_on_rule
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    par_pid BIGINT NOT NULL,
    par_version INTEGER,
    par_product_add_on_pid BIGINT,
    par_summary VARCHAR(16000),
    par_note VARCHAR(256),
    par_rate_adjustment_percent NUMERIC(11, 9),
    par_investor_price_adjustment_percent NUMERIC(11, 9),
    par_account_price_adjustment_percent NUMERIC(11, 9),
    par_arm_margin_adjustment_percent NUMERIC(11, 9),
    par_loan_purpose_input_type VARCHAR(128),
    par_property_usage_input_type VARCHAR(128),
    par_doc_level_input_type VARCHAR(128),
    par_property_category_input_type VARCHAR(128),
    par_first_time_homebuyer_input_type VARCHAR(128),
    par_self_employed_input_type VARCHAR(128),
    par_amortization_input_type VARCHAR(128),
    par_non_resident_alien_input_type VARCHAR(128),
    par_hazardous_lava_zone_input_type VARCHAR(128),
    par_property_rights_input_type VARCHAR(128),
    par_property_acres_input_type VARCHAR(128),
    par_arms_length_input_type VARCHAR(128),
    par_state_input_type VARCHAR(128),
    par_escrow_waiver_input_type VARCHAR(128),
    par_subordinate_financing_input_type VARCHAR(128),
    par_minimum_credit_score_input BIT,
    par_maximum_credit_score_input BIT,
    par_minimum_loan_amount_input BIT,
    par_maximum_loan_amount_input BIT,
    par_minimum_ltv_ratio_input BIT,
    par_maximum_ltv_ratio_input BIT,
    par_minimum_cltv_ratio_input BIT,
    par_maximum_cltv_ratio_input BIT,
    par_maximum_housing_ratio_input BIT,
    par_minimum_debt_ratio_input BIT,
    par_maximum_debt_ratio_input BIT,
    par_loan_purpose_purchase BIT,
    par_loan_purpose_change_in_rate_term BIT,
    par_loan_purpose_cash_out BIT,
    par_property_usage_primary_residence BIT,
    par_property_usage_second_home BIT,
    par_property_usage_investment BIT,
    par_doc_level_full BIT,
    par_doc_level_lite BIT,
    par_doc_level_limited BIT,
    par_doc_level_streamline_refinance BIT,
    par_property_category_detached BIT,
    par_property_category_attached BIT,
    par_property_category_condo_hotel BIT,
    par_property_category_duplex BIT,
    par_property_category_triplex BIT,
    par_property_category_fourplex BIT,
    par_property_category_commercial_residential BIT,
    par_property_category_condo_1_to_4_story BIT,
    par_property_category_condo_5_over_story BIT,
    par_property_category_manufactured_multi_wide BIT,
    par_property_category_manufactured_single_wide BIT,
    par_property_category_townhouse_rowhouse BIT,
    par_property_category_land_and_lots BIT,
    par_property_category_farm BIT,
    par_first_time_homebuyer BIT,
    par_not_first_time_homebuyer BIT,
    par_self_employed BIT,
    par_not_self_employed BIT,
    par_amortization_fully BIT,
    par_amortization_interest_only BIT,
    par_non_resident_alien BIT,
    par_not_non_resident_alien BIT,
    par_arms_length BIT,
    par_not_arms_length BIT,
    par_hazardous_lava_zone BIT,
    par_not_hazardous_lava_zone BIT,
    par_property_rights_fee_simple BIT,
    par_property_rights_leasehold BIT,
    par_under_10_acres BIT,
    par_not_under_10_acres BIT,
    par_escrow_waiver BIT,
    par_not_escrow_waiver BIT,
    par_subordinate_financing BIT,
    par_not_subordinate_financing BIT,
    par_minimum_credit_score INTEGER,
    par_maximum_credit_score INTEGER,
    par_minimum_loan_amount NUMERIC(15),
    par_maximum_loan_amount NUMERIC(15),
    par_minimum_ltv_ratio_percent NUMERIC(11, 9),
    par_maximum_ltv_ratio_percent NUMERIC(11, 9),
    par_minimum_cltv_ratio_percent NUMERIC(11, 9),
    par_maximum_cltv_ratio_percent NUMERIC(11, 9),
    par_maximum_housing_ratio_percent NUMERIC(11, 9),
    par_minimum_debt_ratio_percent NUMERIC(11, 9),
    par_maximum_debt_ratio_percent NUMERIC(11, 9),
    par_state_al BIT,
    par_state_ak BIT,
    par_state_az BIT,
    par_state_ar BIT,
    par_state_ca BIT,
    par_state_co BIT,
    par_state_ct BIT,
    par_state_de BIT,
    par_state_dc BIT,
    par_state_fl BIT,
    par_state_ga BIT,
    par_state_gu BIT,
    par_state_hi BIT,
    par_state_id BIT,
    par_state_il BIT,
    par_state_in BIT,
    par_state_ia BIT,
    par_state_ks BIT,
    par_state_ky BIT,
    par_state_la BIT,
    par_state_me BIT,
    par_state_md BIT,
    par_state_ma BIT,
    par_state_mi BIT,
    par_state_mn BIT,
    par_state_ms BIT,
    par_state_mo BIT,
    par_state_mt BIT,
    par_state_ne BIT,
    par_state_nv BIT,
    par_state_nh BIT,
    par_state_nj BIT,
    par_state_nm BIT,
    par_state_ny BIT,
    par_state_nc BIT,
    par_state_nd BIT,
    par_state_oh BIT,
    par_state_ok BIT,
    par_state_or BIT,
    par_state_pa BIT,
    par_state_pr BIT,
    par_state_ri BIT,
    par_state_sc BIT,
    par_state_sd BIT,
    par_state_tn BIT,
    par_state_tx BIT,
    par_state_ut BIT,
    par_state_vt BIT,
    par_state_va BIT,
    par_state_vi BIT,
    par_state_wa BIT,
    par_state_wv BIT,
    par_state_wi BIT,
    par_state_wy BIT
);

CREATE TABLE history_octane.product_branch
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pbr_pid BIGINT NOT NULL,
    pbr_version INTEGER,
    pbr_product_pid BIGINT,
    pbr_branch_pid BIGINT,
    pbr_from_date DATE,
    pbr_through_date DATE,
    pbr_price_adjustment_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.product_deal_check_exclusion
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pdce_pid BIGINT NOT NULL,
    pdce_version INTEGER,
    pdce_product_pid BIGINT,
    pdce_deal_check_type VARCHAR(128)
);

CREATE TABLE history_octane.product_eligibility
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pe_pid BIGINT NOT NULL,
    pe_version INTEGER,
    pe_product_pid BIGINT,
    pe_from_date DATE
);

CREATE TABLE history_octane.product_eligibility_rule
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    per_pid BIGINT NOT NULL,
    per_version INTEGER,
    per_product_eligibility_pid BIGINT,
    per_summary VARCHAR(16000),
    per_note VARCHAR(256),
    per_group_id INTEGER,
    per_loan_purpose_input_type VARCHAR(128),
    per_property_usage_input_type VARCHAR(128),
    per_doc_level_input_type VARCHAR(128),
    per_property_category_input_type VARCHAR(128),
    per_first_time_homebuyer_input_type VARCHAR(128),
    per_self_employed_input_type VARCHAR(128),
    per_amortization_input_type VARCHAR(128),
    per_non_resident_alien_input_type VARCHAR(128),
    per_hazardous_lava_zone_input_type VARCHAR(128),
    per_property_rights_input_type VARCHAR(128),
    per_property_acres_input_type VARCHAR(128),
    per_arms_length_input_type VARCHAR(128),
    per_underwrite_accepted_input_type VARCHAR(128),
    per_state_input_type VARCHAR(128),
    per_escrow_waiver_input_type VARCHAR(128),
    per_minimum_credit_score_input BIT,
    per_minimum_loan_amount_input BIT,
    per_maximum_loan_amount_input BIT,
    per_maximum_ltv_ratio_input BIT,
    per_newly_built_maximum_ltv_ratio_input BIT,
    per_subordinate_maximum_ltv_ratio_input BIT,
    per_maximum_cltv_ratio_input BIT,
    per_maximum_housing_ratio_input BIT,
    per_maximum_debt_ratio_input BIT,
    per_lp_risk_assessment_accepted BIT,
    per_du_risk_assessment_accepted BIT,
    per_manual_risk_assessment_accepted BIT,
    per_loan_purpose_purchase BIT,
    per_loan_purpose_change_in_rate_term BIT,
    per_loan_purpose_cash_out BIT,
    per_property_usage_primary_residence BIT,
    per_property_usage_second_home BIT,
    per_property_usage_investment BIT,
    per_doc_level_full BIT,
    per_doc_level_lite BIT,
    per_doc_level_limited BIT,
    per_doc_level_streamline_refinance BIT,
    per_property_category_detached BIT,
    per_property_category_attached BIT,
    per_property_category_condo_hotel BIT,
    per_property_category_duplex BIT,
    per_property_category_triplex BIT,
    per_property_category_fourplex BIT,
    per_property_category_commercial_residential BIT,
    per_property_category_condo_1_to_4_story BIT,
    per_property_category_condo_5_over_story BIT,
    per_property_category_manufactured_multi_wide BIT,
    per_property_category_manufactured_single_wide BIT,
    per_property_category_townhouse_rowhouse BIT,
    per_property_category_land_and_lots BIT,
    per_property_category_farm BIT,
    per_first_time_homebuyer BIT,
    per_not_first_time_homebuyer BIT,
    per_self_employed BIT,
    per_not_self_employed BIT,
    per_amortization_fully BIT,
    per_amortization_interest_only BIT,
    per_non_resident_alien BIT,
    per_not_non_resident_alien BIT,
    per_arms_length BIT,
    per_not_arms_length BIT,
    per_hazardous_lava_zone BIT,
    per_not_hazardous_lava_zone BIT,
    per_property_rights_fee_simple BIT,
    per_property_rights_leasehold BIT,
    per_under_10_acres BIT,
    per_not_under_10_acres BIT,
    per_escrow_waiver BIT,
    per_not_escrow_waiver BIT,
    per_minimum_credit_score INTEGER,
    per_minimum_loan_amount NUMERIC(15),
    per_maximum_loan_amount NUMERIC(15),
    per_maximum_ltv_ratio_percent NUMERIC(11, 9),
    per_newly_built_maximum_ltv_ratio_percent NUMERIC(11, 9),
    per_subordinate_maximum_ltv_ratio_percent NUMERIC(11, 9),
    per_maximum_cltv_ratio_percent NUMERIC(11, 9),
    per_maximum_housing_ratio_percent NUMERIC(11, 9),
    per_maximum_debt_ratio_percent NUMERIC(11, 9),
    per_state_al BIT,
    per_state_ak BIT,
    per_state_az BIT,
    per_state_ar BIT,
    per_state_ca BIT,
    per_state_co BIT,
    per_state_ct BIT,
    per_state_de BIT,
    per_state_dc BIT,
    per_state_fl BIT,
    per_state_ga BIT,
    per_state_gu BIT,
    per_state_hi BIT,
    per_state_id BIT,
    per_state_il BIT,
    per_state_in BIT,
    per_state_ia BIT,
    per_state_ks BIT,
    per_state_ky BIT,
    per_state_la BIT,
    per_state_me BIT,
    per_state_md BIT,
    per_state_ma BIT,
    per_state_mi BIT,
    per_state_mn BIT,
    per_state_ms BIT,
    per_state_mo BIT,
    per_state_mt BIT,
    per_state_ne BIT,
    per_state_nv BIT,
    per_state_nh BIT,
    per_state_nj BIT,
    per_state_nm BIT,
    per_state_ny BIT,
    per_state_nc BIT,
    per_state_nd BIT,
    per_state_oh BIT,
    per_state_ok BIT,
    per_state_or BIT,
    per_state_pa BIT,
    per_state_pr BIT,
    per_state_ri BIT,
    per_state_sc BIT,
    per_state_sd BIT,
    per_state_tn BIT,
    per_state_tx BIT,
    per_state_ut BIT,
    per_state_vt BIT,
    per_state_va BIT,
    per_state_vi BIT,
    per_state_wa BIT,
    per_state_wv BIT,
    per_state_wi BIT,
    per_state_wy BIT
);

CREATE TABLE history_octane.product_lock_term
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    plt_pid BIGINT NOT NULL,
    plt_version INTEGER,
    plt_product_pid BIGINT,
    plt_lock_term_setting_pid BIGINT,
    plt_from_date DATE,
    plt_through_date DATE,
    plt_price_adjustment_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.product_maximum_investor_price
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pmip_pid BIGINT NOT NULL,
    pmip_version INTEGER,
    pmip_product_pid BIGINT,
    pmip_from_date DATE,
    pmip_maximum_investor_price_percent NUMERIC(11, 9),
    pmip_maximum_includes_srp BIT,
    pmip_loan_amount_min NUMERIC(15),
    pmip_loan_amount_max NUMERIC(15)
);

CREATE TABLE history_octane.product_maximum_rebate
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pmr_pid BIGINT NOT NULL,
    pmr_version INTEGER,
    pmr_product_pid BIGINT,
    pmr_from_date DATE,
    pmr_maximum_rebate_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.product_minimum_investor_price
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pminip_pid BIGINT NOT NULL,
    pminip_version INTEGER,
    pminip_product_pid BIGINT,
    pminip_from_date DATE,
    pminip_minimum_investor_price_percent NUMERIC(11, 9),
    pminip_minimum_includes_srp BIT,
    pminip_loan_amount_min NUMERIC(15),
    pminip_loan_amount_max NUMERIC(15)
);

CREATE TABLE history_octane.product_originator
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    po_pid BIGINT NOT NULL,
    po_version INTEGER,
    po_product_pid BIGINT,
    po_lender_user_pid BIGINT,
    po_from_date DATE,
    po_through_date DATE,
    po_price_adjustment_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.product_terms
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pt_pid BIGINT NOT NULL,
    pt_version INTEGER,
    pt_amortization_term_months INTEGER,
    pt_arm_index_type VARCHAR(128),
    pt_arm_payment_adjustment_calculation_type VARCHAR(128),
    pt_assumable BIT,
    pt_product_category VARCHAR(128),
    pt_conditions_to_assumability BIT,
    pt_demand_feature BIT,
    pt_due_in_term_months INTEGER,
    pt_escrow_cushion_months INTEGER,
    pt_from_date DATE,
    pt_initial_payment_adjustment_term_months INTEGER,
    pt_initial_rate_adjustment_cap_percent NUMERIC(11, 9),
    pt_initial_rate_adjustment_term_months INTEGER,
    pt_lien_priority_type VARCHAR(128),
    pt_loan_amortization_type VARCHAR(128),
    pt_minimum_payment_rate_percent NUMERIC(11, 9),
    pt_minimum_rate_term_months INTEGER,
    pt_mortgage_type VARCHAR(128),
    pt_negative_amortization_type VARCHAR(128),
    pt_negative_amortization_limit_percent NUMERIC(11, 9),
    pt_negative_amortization_recast_period_months INTEGER,
    pt_payment_adjustment_lifetime_cap_percent NUMERIC(11, 9),
    pt_payment_adjustment_periodic_cap NUMERIC(11, 9),
    pt_payment_frequency_type VARCHAR(128),
    pt_prepayment_finance_charge_refund BIT,
    pt_product_pid BIGINT,
    pt_rate_adjustment_lifetime_cap_percent NUMERIC(11, 9),
    pt_subsequent_payment_adjustment_term_months INTEGER,
    pt_subsequent_rate_adjustment_cap_percent NUMERIC(11, 9),
    pt_subsequent_rate_adjustment_term_months INTEGER,
    pt_prepay_penalty_type VARCHAR(128),
    pt_lender_hazard_insurance_available BIT,
    pt_lender_hazard_insurance_premium_amount NUMERIC(15, 2),
    pt_lender_hazard_insurance_term_months INTEGER,
    pt_loan_requires_hazard_insurance BIT,
    pt_arm_convertible BIT,
    pt_arm_convertible_from_month INTEGER,
    pt_arm_convertible_through_month INTEGER,
    pt_arm_floor_rate_percent NUMERIC(11, 9),
    pt_arm_lookback_period_days INTEGER,
    pt_escrow_waiver_allowed BIT,
    pt_days_per_year_type VARCHAR(128),
    pt_lp_risk_assessment_accepted BIT,
    pt_du_risk_assessment_accepted BIT,
    pt_manual_risk_assessment_accepted BIT,
    pt_internal_underwrite_accepted BIT,
    pt_external_fha_underwrite_accepted BIT,
    pt_external_va_underwrite_accepted BIT,
    pt_external_usda_underwrite_accepted BIT,
    pt_external_investor_underwrite_accepted BIT,
    pt_heloc_cancel_fee_applicable_type VARCHAR(128),
    pt_heloc_cancel_fee_period_months INTEGER,
    pt_heloc_cancel_fee_amount NUMERIC(15, 2),
    pt_heloc_draw_period_months INTEGER,
    pt_heloc_repayment_period_duration_months INTEGER,
    pt_heloc_maximum_initial_draw BIT,
    pt_heloc_maximum_initial_draw_amount NUMERIC(15),
    pt_heloc_minimum_draw BIT,
    pt_heloc_minimum_draw_amount NUMERIC(15),
    pt_gpm_adjustment_years INTEGER,
    pt_gpm_adjustment_percent NUMERIC(11, 9),
    pt_qualifying_monthly_payment_type VARCHAR(128),
    pt_qualifying_rate_type VARCHAR(128),
    pt_qualifying_rate_input_percent NUMERIC(11, 9),
    pt_ipc_calc_type VARCHAR(128),
    pt_ipc_limit_percent1 NUMERIC(11, 9),
    pt_ipc_property_usage_type1 VARCHAR(128),
    pt_ipc_comparison_operator_type1 VARCHAR(128),
    pt_ipc_cltv_ratio_percent1 NUMERIC(11, 9),
    pt_ipc_limit_percent2 NUMERIC(11, 9),
    pt_ipc_property_usage_type2 VARCHAR(128),
    pt_ipc_comparison_operator_type2 VARCHAR(128),
    pt_ipc_cltv_ratio_percent2 NUMERIC(11, 9),
    pt_ipc_limit_percent3 NUMERIC(11, 9),
    pt_ipc_property_usage_type3 VARCHAR(128),
    pt_ipc_comparison_operator_type3 VARCHAR(128),
    pt_ipc_cltv_ratio_percent3 NUMERIC(11, 9),
    pt_ipc_limit_percent4 NUMERIC(11, 9),
    pt_ipc_property_usage_type4 VARCHAR(128),
    pt_ipc_comparison_operator_type4 VARCHAR(128),
    pt_ipc_cltv_ratio_percent4 NUMERIC(11, 9),
    pt_buydown_base_date_type VARCHAR(128),
    pt_buydown_subsidy_calculation_type VARCHAR(128),
    pt_prepaid_interest_rate_type VARCHAR(128),
    pt_fnm_arm_plan_type VARCHAR(128),
    pt_dsi_plan_code VARCHAR(128),
    pt_credit_qualifying BIT,
    pt_product_special_program_type VARCHAR(128),
    pt_section_of_act_coarse_type VARCHAR(128),
    pt_fha_rehab_program_type VARCHAR(128),
    pt_fha_special_program_type VARCHAR(128),
    pt_third_party_grant_eligible BIT,
    pt_servicing_transfer_type VARCHAR(128),
    pt_no_mi_product BIT,
    pt_mortgage_credit_certificate_eligible BIT,
    pt_fre_community_program_type VARCHAR(128),
    pt_fnm_community_lending_product_type VARCHAR(128),
    pt_zero_note_rate BIT,
    pt_third_party_community_second_program_eligibility_type VARCHAR(128),
    pt_texas_veterans_land_board VARCHAR(128),
    pt_security_instrument_page_count INTEGER,
    pt_deed_page_count INTEGER,
    pt_partial_payment_policy_type VARCHAR(128),
    pt_payment_structure_type VARCHAR(128),
    pt_deferred_payment_months INTEGER,
    pt_always_current_market_price BIT,
    pt_rate_protect BIT,
    pt_non_conforming BIT,
    pt_allow_loan_amount_cents BIT,
    pt_product_appraisal_requirement_type VARCHAR(128),
    pt_family_advantage BIT,
    pt_community_lending_type VARCHAR(128),
    pt_high_balance VARCHAR(128),
    pt_decision_credit_score_calc_type VARCHAR(128),
    pt_new_york BIT
);

CREATE TABLE history_octane.product_buydown
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pbd_pid BIGINT NOT NULL,
    pbd_version INTEGER,
    pbd_product_terms_pid BIGINT,
    pbd_buydown_schedule_type VARCHAR(128)
);

CREATE TABLE history_octane.product_interest_only
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pio_pid BIGINT NOT NULL,
    pio_version INTEGER,
    pio_product_terms_pid BIGINT,
    pio_interest_only_type VARCHAR(128)
);

CREATE TABLE history_octane.product_prepay_penalty
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ppp_pid BIGINT NOT NULL,
    ppp_version INTEGER,
    ppp_product_terms_pid BIGINT,
    ppp_prepay_penalty_schedule_type VARCHAR(128)
);

CREATE TABLE history_octane.rate_sheet
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rs_pid BIGINT NOT NULL,
    rs_version INTEGER,
    rs_product_pid BIGINT,
    rs_from_datetime TIMESTAMP
);

CREATE TABLE history_octane.rate_sheet_rate
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rsr_pid BIGINT NOT NULL,
    rsr_version INTEGER,
    rsr_rate_sheet_pid BIGINT,
    rsr_rate_percent NUMERIC(11, 9),
    rsr_arm_margin_percent NUMERIC(11, 9),
    rsr_available BIT
);

CREATE TABLE history_octane.rate_sheet_price
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rsp_pid BIGINT NOT NULL,
    rsp_version INTEGER,
    rsp_rate_sheet_rate_pid BIGINT,
    rsp_lock_duration_days INTEGER,
    rsp_lock_commitment_type VARCHAR(128),
    rsp_price_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.repository_file
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    rf_pid BIGINT NOT NULL,
    rf_version INTEGER,
    rf_account_pid BIGINT,
    rf_repository_type VARCHAR(128),
    rf_client_filename VARCHAR(128),
    rf_repository_filename VARCHAR(128),
    rf_upload_datetime TIMESTAMP,
    rf_uploader_name VARCHAR(128),
    rf_uploader_agent_type VARCHAR(128),
    rf_uploader_lender_user_pid BIGINT,
    rf_uploader_borrower_user_pid BIGINT,
    rf_description VARCHAR(256),
    rf_file_size BIGINT,
    rf_mime_type VARCHAR(128),
    rf_delete_datetime TIMESTAMP,
    rf_file_checksum VARCHAR(128)
);

CREATE TABLE history_octane.bid_pool_file
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bpf_pid BIGINT NOT NULL,
    bpf_version INTEGER,
    bpf_bid_pool_pid BIGINT,
    bpf_repository_file_pid BIGINT
);

CREATE TABLE history_octane.compass_analytics_report_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    carr_pid BIGINT NOT NULL,
    carr_version INTEGER,
    carr_account_pid BIGINT,
    carr_create_datetime TIMESTAMP,
    carr_start_datetime TIMESTAMP,
    carr_end_datetime TIMESTAMP,
    carr_request_status_type VARCHAR(128),
    carr_request_status_messages TEXT,
    carr_requester_unparsed_name VARCHAR(128),
    carr_exported_deal_count INTEGER,
    carr_total_deal_count INTEGER,
    carr_sold_from_date DATE,
    carr_sold_through_date DATE,
    carr_cancelled_from_date DATE,
    carr_cancelled_through_date DATE,
    carr_export_csv_repository_file_pid BIGINT,
    carr_error_file_pid BIGINT,
    carr_use_loan_hedge_data BIT
);

CREATE TABLE history_octane.consumer_privacy_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cpr_pid BIGINT NOT NULL,
    cpr_version INTEGER,
    cpr_request_id INTEGER,
    cpr_receiver_lender_user_pid BIGINT,
    cpr_account_pid BIGINT,
    cpr_borrower_last_name VARCHAR(128),
    cpr_searched_email VARCHAR(256),
    cpr_searched_phone VARCHAR(32),
    cpr_searched_los_loan_id BIGINT,
    cpr_searched_subject_property_street VARCHAR(128),
    cpr_searched_subject_property_city VARCHAR(128),
    cpr_searched_subject_property_state_type VARCHAR(128),
    cpr_received_date TIMESTAMP,
    cpr_know_datetime TIMESTAMP,
    cpr_delete_datetime TIMESTAMP,
    cpr_request_type VARCHAR(128),
    cpr_request_todo VARCHAR(128),
    cpr_know_repository_file_pid BIGINT,
    cpr_delete_repository_file_pid BIGINT
);

CREATE TABLE history_octane.custom_form
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cf_pid BIGINT NOT NULL,
    cf_version INTEGER,
    cf_account_pid BIGINT,
    cf_merge_form BIT,
    cf_repository_file_pid BIGINT
);

CREATE TABLE history_octane.custom_form_merge_field
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cfmf_pid BIGINT NOT NULL,
    cfmf_version INTEGER,
    cfmf_custom_form_pid BIGINT,
    cfmf_field_type VARCHAR(128)
);

CREATE TABLE history_octane.deal_file
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    df_pid BIGINT NOT NULL,
    df_version INTEGER,
    df_deal_pid BIGINT,
    df_repository_file_pid BIGINT,
    df_archive BIT,
    df_borrower_uploaded BIT
);

CREATE TABLE history_octane.appraisal_file
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    aprf_pid BIGINT NOT NULL,
    aprf_version INTEGER,
    aprf_appraisal_pid BIGINT,
    aprf_deal_file_pid BIGINT,
    aprf_appraisal_file_type VARCHAR(128)
);

CREATE TABLE history_octane.deal_dropbox_file
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ddf_pid BIGINT NOT NULL,
    ddf_version INTEGER,
    ddf_deal_file_pid BIGINT
);

CREATE TABLE history_octane.deal_file_signature
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dfs_pid BIGINT NOT NULL,
    dfs_version INTEGER,
    dfs_deal_file_pid BIGINT,
    dfs_deal_signer_pid BIGINT,
    dfs_x NUMERIC(15, 7),
    dfs_y NUMERIC(15, 7),
    dfs_page_number INTEGER,
    dfs_page_height NUMERIC(15, 7),
    dfs_signature_part_type VARCHAR(128),
    dfs_charge_type VARCHAR(128),
    dfs_charge_amount NUMERIC(15, 2)
);

CREATE TABLE history_octane.deal_fraud_risk
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dfr_pid BIGINT NOT NULL,
    dfr_version INTEGER,
    dfr_deal_pid BIGINT,
    dfr_loan_safe_risk_manager_status_messages TEXT,
    dfr_loan_safe_risk_manager_order_number VARCHAR(128),
    dfr_loan_safe_risk_manager_html_deal_file_pid BIGINT,
    dfr_loan_safe_risk_manager_pdf_deal_file_pid BIGINT,
    dfr_loan_safe_fraud_risk_score INTEGER,
    dfr_loan_safe_collateral_risk_score INTEGER,
    dfr_loan_safe_product_type VARCHAR(128)
);

CREATE TABLE history_octane.deal_invoice_file
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dif_pid BIGINT NOT NULL,
    dif_version INTEGER,
    dif_deal_invoice_file_type VARCHAR(128),
    dif_deal_file_pid BIGINT,
    dif_deal_invoice_pid BIGINT,
    dif_create_datetime TIMESTAMP
);

CREATE TABLE history_octane.deal_message_log
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dmlog_pid BIGINT NOT NULL,
    dmlog_version INTEGER,
    dmlog_deal_pid BIGINT,
    dmlog_sent_datetime TIMESTAMP,
    dmlog_delivery_type VARCHAR(128),
    dmlog_to_recipients VARCHAR(16000),
    dmlog_email_reply_to VARCHAR(256),
    dmlog_name VARCHAR(256),
    dmlog_email_subject VARCHAR(1024),
    dmlog_email_body TEXT,
    dmlog_sent_securely BIT,
    dmlog_cover_letter_deal_file_pid BIGINT,
    dmlog_attachment_deal_file_pid BIGINT,
    dmlog_cc_recipients VARCHAR(16000),
    dmlog_bcc_recipients VARCHAR(16000),
    dmlog_plain_text BIT
);

CREATE TABLE history_octane.deal_system_file
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dsf_pid BIGINT NOT NULL,
    dsf_version INTEGER,
    dsf_deal_pid BIGINT,
    dsf_repository_file_pid BIGINT
);

CREATE TABLE history_octane.appraisal_order_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    aprq_pid BIGINT NOT NULL,
    aprq_version INTEGER,
    aprq_deal_pid BIGINT,
    aprq_appraisal_pid BIGINT,
    aprq_mercury_network_status_request_pid BIGINT,
    aprq_appraisal_order_coarse_status_type VARCHAR(128),
    aprq_order_id VARCHAR(128),
    aprq_order_instructions VARCHAR(1024),
    aprq_address_street1 VARCHAR(128),
    aprq_address_street2 VARCHAR(128),
    aprq_address_city VARCHAR(128),
    aprq_address_state VARCHAR(128),
    aprq_address_postal_code VARCHAR(128),
    aprq_appraisal_fee_amount NUMERIC(15, 2),
    aprq_order_request_date DATE,
    aprq_response_xml_deal_system_file_pid BIGINT,
    aprq_mismo_xml_deal_system_file_pid BIGINT,
    aprq_appraisal_order_request_type VARCHAR(128),
    aprq_status_check_datetime TIMESTAMP,
    aprq_appraisal_management_company_type VARCHAR(128),
    aprq_requester_lender_user_pid BIGINT,
    aprq_requester_unparsed_name VARCHAR(128),
    aprq_requester_agent_type VARCHAR(128),
    aprq_vendor_status_unique_id VARCHAR(128)
);

CREATE TABLE history_octane.appraisal_order_request_file
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    aorf_pid BIGINT NOT NULL,
    aorf_version INTEGER,
    aorf_appraisal_order_request_pid BIGINT,
    aorf_deal_file_pid BIGINT,
    aorf_appraisal_order_request_file_type VARCHAR(128),
    aorf_vendor_document_datetime TIMESTAMP,
    aorf_vendor_document_id VARCHAR(128)
);

CREATE TABLE history_octane.deal_file_thumbnail
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dft_pid BIGINT NOT NULL,
    dft_version INTEGER,
    dft_deal_file_pid BIGINT,
    dft_deal_system_file_pid BIGINT,
    dft_page_number INTEGER
);

CREATE TABLE history_octane.du_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dur_pid BIGINT NOT NULL,
    dur_version INTEGER,
    dur_proposal_pid BIGINT,
    dur_proposal_snapshot_pid BIGINT,
    dur_uw_findings_html_deal_file_pid BIGINT,
    dur_uw_analysis_html_deal_file_pid BIGINT,
    dur_uw_findings_pdf_deal_file_pid BIGINT,
    dur_uw_findings_xml_provided BIT,
    dur_requester_agent_type VARCHAR(128),
    dur_requester_lender_user_pid BIGINT,
    dur_requester_unparsed_name VARCHAR(128),
    dur_create_datetime TIMESTAMP,
    dur_mismo_version_type VARCHAR(128),
    dur_credit_bureau_type VARCHAR(128),
    dur_globally_unique_id VARCHAR(128),
    dur_response_deal_system_file_pid BIGINT,
    dur_du_casefile_id VARCHAR(32),
    dur_du_request_status_type VARCHAR(128),
    dur_status_message VARCHAR(1024),
    dur_mp_status_log VARCHAR(16000),
    dur_du_recommendation_type VARCHAR(128),
    dur_du_version VARCHAR(16),
    dur_du_submission_number INTEGER,
    dur_loan_amount NUMERIC(17, 2),
    dur_initial_pi_amount NUMERIC(15, 2),
    dur_note_rate_percent NUMERIC(11, 9),
    dur_initial_note_rate_percent NUMERIC(11, 9),
    dur_ltv_ratio_percent NUMERIC(11, 9),
    dur_cltv_ratio_percent NUMERIC(11, 9),
    dur_housing_ratio_percent NUMERIC(11, 9),
    dur_debt_ratio_percent NUMERIC(11, 9),
    dur_du_ltv_ratio_percent NUMERIC(11, 9),
    dur_du_cltv_ratio_percent NUMERIC(11, 9),
    dur_du_housing_ratio_percent NUMERIC(11, 9),
    dur_du_debt_ratio_percent NUMERIC(11, 9),
    dur_aus_request_number INTEGER,
    dur_cash_from_borrower_amount NUMERIC(15, 2),
    dur_aus_cash_from_borrower_amount NUMERIC(15, 2),
    dur_gse_version_type VARCHAR(128)
);

CREATE TABLE history_octane.du_key_finding
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dukf_pid BIGINT NOT NULL,
    dukf_version INTEGER,
    dukf_du_request_pid BIGINT,
    dukf_du_key_finding_type VARCHAR(128),
    dukf_key_finding_result VARCHAR(128)
);

CREATE TABLE history_octane.du_refi_plus_finding
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    durpf_pid BIGINT NOT NULL,
    durpf_version INTEGER,
    durpf_du_request_pid BIGINT,
    durpf_description VARCHAR(32),
    durpf_value VARCHAR(128)
);

CREATE TABLE history_octane.du_request_credit
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    durc_pid BIGINT NOT NULL,
    durc_version INTEGER,
    durc_du_request_pid BIGINT,
    durc_du_casefile_id VARCHAR(32),
    durc_create_datetime TIMESTAMP,
    durc_credit_report_create_datetime TIMESTAMP,
    durc_credit_bureau_type VARCHAR(128),
    durc_credit_report_identifier VARCHAR(32),
    durc_credit_report_name VARCHAR(256),
    durc_aus_credit_service_type VARCHAR(128),
    durc_borrower_1_borrower_tiny_id_type VARCHAR(128),
    durc_borrower_2_borrower_tiny_id_type VARCHAR(128)
);

CREATE TABLE history_octane.du_special_feature_code
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dusfc_pid BIGINT NOT NULL,
    dusfc_version INTEGER,
    dusfc_du_request_pid BIGINT,
    dusfc_special_feature_code VARCHAR(32),
    dusfc_special_feature_description VARCHAR(128)
);

CREATE TABLE history_octane.flood_cert
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    fc_pid BIGINT NOT NULL,
    fc_version INTEGER,
    fc_deal_pid BIGINT,
    fc_flood_certificate_type VARCHAR(128),
    fc_flood_cert_vendor_type VARCHAR(128),
    fc_flood_certification_reference_number VARCHAR(32),
    fc_flood_cert_effective_date DATE,
    fc_nfip_community_name VARCHAR(256),
    fc_nfip_counties VARCHAR(256),
    fc_nfip_state VARCHAR(2),
    fc_nfip_community_number VARCHAR(16),
    fc_nfip_community_firm_date DATE,
    fc_nfip_community_participation_start_date DATE,
    fc_flood_partial VARCHAR(128),
    fc_nfip_map_number VARCHAR(8),
    fc_nfip_map_panel VARCHAR(8),
    fc_nfip_map_panel_suffix VARCHAR(8),
    fc_nfip_map_panel_date DATE,
    fc_nfip_map_exists VARCHAR(128),
    fc_nfip_letter_of_map_date DATE,
    fc_nfip_letter_of_map_case_number VARCHAR(32),
    fc_fema_flood_zone_designation_type VARCHAR(128),
    fc_nfip_community_participation_status_type VARCHAR(128),
    fc_protected_area VARCHAR(128),
    fc_protected_area_designation_date DATE,
    fc_special_flood_hazard_area VARCHAR(128),
    fc_property_county_fips VARCHAR(32),
    fc_property_state_fips VARCHAR(32),
    fc_flood_cert_deal_file_pid BIGINT,
    fc_property_address_city VARCHAR(128),
    fc_property_address_country VARCHAR(128),
    fc_property_address_postal_code VARCHAR(128),
    fc_property_address_state VARCHAR(128),
    fc_property_address_street1 VARCHAR(128),
    fc_property_address_street2 VARCHAR(128),
    fc_property_county_name VARCHAR(128),
    fc_clg_flood_cert_messages TEXT,
    fc_clg_flood_cert_status_type VARCHAR(128),
    fc_clg_flood_cert_request_datetime TIMESTAMP,
    fc_clg_flood_cert_requester_agent_type VARCHAR(128),
    fc_clg_flood_cert_requester_lender_user_pid BIGINT,
    fc_clg_flood_cert_requester_unparsed_name VARCHAR(128)
);

CREATE TABLE history_octane.hmda_report_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    hrr_pid BIGINT NOT NULL,
    hrr_version INTEGER,
    hrr_account_pid BIGINT,
    hrr_create_datetime TIMESTAMP,
    hrr_start_datetime TIMESTAMP,
    hrr_end_datetime TIMESTAMP,
    hrr_request_status_type VARCHAR(128),
    hrr_request_status_messages TEXT,
    hrr_requester_unparsed_name VARCHAR(128),
    hrr_row_count INTEGER,
    hrr_from_date DATE,
    hrr_through_date DATE,
    hrr_error_protection BIT,
    hrr_error_limit INTEGER,
    hrr_repository_file_pid BIGINT
);

CREATE TABLE history_octane.lender_user_photo
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lup_pid BIGINT NOT NULL,
    lup_version INTEGER,
    lup_lender_user_pid BIGINT,
    lup_repository_file_pid BIGINT
);

CREATE TABLE history_octane.lp_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lpr_pid BIGINT NOT NULL,
    lpr_version INTEGER,
    lpr_proposal_pid BIGINT,
    lpr_proposal_snapshot_pid BIGINT,
    lpr_full_feedback_pdf_deal_file_pid BIGINT,
    lpr_hve_pdf_deal_file_pid BIGINT,
    lpr_requester_agent_type VARCHAR(128),
    lpr_requester_lender_user_pid BIGINT,
    lpr_requester_unparsed_name VARCHAR(128),
    lpr_create_datetime TIMESTAMP,
    lpr_lp_interface_version_type VARCHAR(128),
    lpr_lp_dtd_version_type VARCHAR(128),
    lpr_mismo_version_type VARCHAR(128),
    lpr_fre_lp_transaction_id VARCHAR(32),
    lpr_lp_transaction_id VARCHAR(32),
    lpr_globally_unique_id VARCHAR(128),
    lpr_lp_request_status_type VARCHAR(128),
    lpr_lp_evaluation_status_type VARCHAR(128),
    lpr_status_messages TEXT,
    lpr_xml_response_deal_system_file_pid BIGINT,
    lpr_loan_amount NUMERIC(17, 2),
    lpr_initial_pi_amount NUMERIC(15, 2),
    lpr_note_rate_percent NUMERIC(11, 9),
    lpr_initial_note_rate_percent NUMERIC(11, 9),
    lpr_ltv_ratio_percent NUMERIC(11, 9),
    lpr_cltv_ratio_percent NUMERIC(11, 9),
    lpr_hcltv_ratio_percent NUMERIC(11, 9),
    lpr_hcltv_applicable BIT,
    lpr_housing_ratio_percent NUMERIC(11, 9),
    lpr_debt_ratio_percent NUMERIC(11, 9),
    lpr_lp_ltv_ratio_percent NUMERIC(11, 9),
    lpr_lp_total_ltv_ratio_percent NUMERIC(11, 9),
    lpr_lp_high_total_ltv_ratio_percent NUMERIC(11, 9),
    lpr_lp_housing_ratio_percent NUMERIC(11, 9),
    lpr_lp_debt_ratio_percent NUMERIC(11, 9),
    lpr_lp_submission_number INTEGER,
    lpr_lp_credit_risk_classification_type VARCHAR(128),
    lpr_fre_doc_level_description_type VARCHAR(128),
    lpr_fre_purchase_eligibility_type VARCHAR(128),
    lpr_lp_case_state_type VARCHAR(128),
    lpr_lp_async_id VARCHAR(128),
    lpr_lp_async_polling_interval INTEGER,
    lpr_lp_total_funds_to_be_verified_amount NUMERIC(15, 2),
    lpr_lp_required_borrower_funds_amount NUMERIC(15, 2),
    lpr_lp_paid_off_debt_amount NUMERIC(15, 2),
    lpr_lp_required_reserves_amount NUMERIC(15, 2),
    lpr_lp_total_eligible_assets_amount NUMERIC(15, 2),
    lpr_lp_proceeds_from_subordinate_financing_amount NUMERIC(15, 2),
    lpr_lp_calculated_reserves_amount NUMERIC(15, 2),
    lpr_aus_request_number INTEGER,
    lpr_cash_from_borrower_amount NUMERIC(15, 2),
    lpr_aus_cash_from_borrower_amount NUMERIC(15, 2),
    lpr_gse_version_type VARCHAR(128)
);

CREATE TABLE history_octane.credit_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    crdr_pid BIGINT NOT NULL,
    crdr_version INTEGER,
    crdr_deal_pid BIGINT,
    crdr_credit_report_file_pid BIGINT,
    crdr_credit_score_disclosure_file_pid BIGINT,
    crdr_create_datetime TIMESTAMP,
    crdr_requester_agent_type VARCHAR(128),
    crdr_requester_lender_user_pid BIGINT,
    crdr_requester_unparsed_name VARCHAR(128),
    crdr_credit_request_via_type VARCHAR(128),
    crdr_lp_request_pid BIGINT,
    crdr_du_request_pid BIGINT,
    crdr_mismo_version_type VARCHAR(128),
    crdr_credit_bureau_type VARCHAR(128),
    crdr_credit_report_request_action_type VARCHAR(128),
    crdr_credit_report_type VARCHAR(128),
    crdr_credit_report_product_description VARCHAR(32),
    crdr_credit_request_type VARCHAR(128),
    crdr_credit_repositories_selected_count INTEGER,
    crdr_equifax_included BIT,
    crdr_experian_included BIT,
    crdr_trans_union_included BIT,
    crdr_borrower1_first_name VARCHAR(32),
    crdr_borrower1_middle_name VARCHAR(32),
    crdr_borrower1_last_name VARCHAR(32),
    crdr_borrower1_name_suffix VARCHAR(32),
    crdr_borrower1_birth_date DATE,
    crdr_borrower1_residence_city VARCHAR(128),
    crdr_borrower1_residence_country VARCHAR(128),
    crdr_borrower1_residence_postal_code VARCHAR(128),
    crdr_borrower1_residence_state VARCHAR(128),
    crdr_borrower1_residence_street1 VARCHAR(128),
    crdr_borrower1_residence_street2 VARCHAR(128),
    crdr_borrower1_experian_credit_score INTEGER,
    crdr_borrower1_equifax_credit_score INTEGER,
    crdr_borrower1_trans_union_credit_score INTEGER,
    crdr_borrower1_equifax_credit_score_model_type VARCHAR(128),
    crdr_borrower1_experian_credit_score_model_type VARCHAR(128),
    crdr_borrower1_trans_union_credit_score_model_type VARCHAR(128),
    crdr_borrower2_first_name VARCHAR(32),
    crdr_borrower2_middle_name VARCHAR(32),
    crdr_borrower2_last_name VARCHAR(32),
    crdr_borrower2_name_suffix VARCHAR(32),
    crdr_borrower2_birth_date DATE,
    crdr_borrower2_residence_city VARCHAR(128),
    crdr_borrower2_residence_country VARCHAR(128),
    crdr_borrower2_residence_postal_code VARCHAR(128),
    crdr_borrower2_residence_state VARCHAR(128),
    crdr_borrower2_residence_street1 VARCHAR(128),
    crdr_borrower2_residence_street2 VARCHAR(128),
    crdr_borrower2_experian_credit_score INTEGER,
    crdr_borrower2_equifax_credit_score INTEGER,
    crdr_borrower2_trans_union_credit_score INTEGER,
    crdr_borrower2_equifax_credit_score_model_type VARCHAR(128),
    crdr_borrower2_experian_credit_score_model_type VARCHAR(128),
    crdr_borrower2_trans_union_credit_score_model_type VARCHAR(128),
    crdr_contains_importable_data BIT,
    crdr_credit_report_identifier VARCHAR(32),
    crdr_credit_report_price NUMERIC(15, 2),
    crdr_credit_request_status_type VARCHAR(128),
    crdr_request_error_messages TEXT,
    crdr_bureau_status_messages TEXT,
    crdr_bureau_credit_report_url VARCHAR(1024),
    crdr_last_status_query_datetime TIMESTAMP,
    crdr_xml_response_file_pid BIGINT
);

CREATE TABLE history_octane.borrower
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    b_pid BIGINT NOT NULL,
    b_version INTEGER,
    b_alimony_child_support VARCHAR(128),
    b_alimony_child_support_explanation VARCHAR(128),
    b_application_pid BIGINT,
    b_application_signed_date DATE,
    b_application_taken_method_type VARCHAR(128),
    b_bankruptcy VARCHAR(128),
    b_bankruptcy_explanation VARCHAR(128),
    b_birth_date DATE,
    b_borrowed_down_payment VARCHAR(128),
    b_borrowed_down_payment_explanation VARCHAR(128),
    b_applicant_role_type VARCHAR(128),
    b_required_to_sign BIT,
    b_spousal_homestead VARCHAR(128),
    b_has_no_ssn BIT,
    b_citizenship_residency_type VARCHAR(128),
    b_credit_request_pid BIGINT,
    b_credit_report_identifier VARCHAR(32),
    b_credit_report_authorization BIT,
    b_has_dependents VARCHAR(128),
    b_dependent_count INTEGER,
    b_dependents_age_years VARCHAR(32),
    b_email VARCHAR(256),
    b_fax VARCHAR(32),
    b_first_name VARCHAR(32),
    b_nickname VARCHAR(32),
    b_first_time_homebuyer BIT,
    b_lender_employee VARCHAR(128),
    b_lender_employee_status_confirmed BIT,
    b_sex_refused VARCHAR(128),
    b_sex_collected_visual_or_surname VARCHAR(128),
    b_sex_male BIT,
    b_sex_female BIT,
    b_sex_not_obtainable BIT,
    b_ethnicity_refused VARCHAR(128),
    b_ethnicity_collected_visual_or_surname VARCHAR(128),
    b_ethnicity_hispanic_or_latino BIT,
    b_ethnicity_mexican BIT,
    b_ethnicity_puerto_rican BIT,
    b_ethnicity_cuban BIT,
    b_ethnicity_other_hispanic_or_latino BIT,
    b_ethnicity_other_hispanic_or_latino_description VARCHAR(100),
    b_ethnicity_not_hispanic_or_latino BIT,
    b_ethnicity_not_obtainable BIT,
    b_homeowner_past_three_years VARCHAR(128),
    b_home_phone VARCHAR(32),
    b_intend_to_occupy VARCHAR(128),
    b_last_name VARCHAR(32),
    b_mailing_place_pid BIGINT,
    b_marital_status_type VARCHAR(128),
    b_spouse_borrower_pid BIGINT,
    b_middle_name VARCHAR(32),
    b_mobile_phone VARCHAR(32),
    b_name_suffix VARCHAR(32),
    b_note_endorser VARCHAR(128),
    b_note_endorser_explanation VARCHAR(128),
    b_obligated_loan_foreclosure VARCHAR(128),
    b_obligated_loan_foreclosure_explanation VARCHAR(128),
    b_office_phone VARCHAR(32),
    b_office_phone_extension VARCHAR(16),
    b_other_race_national_origin_description VARCHAR(32),
    b_outstanding_judgements VARCHAR(128),
    b_outstanding_judgments_explanation VARCHAR(128),
    b_party_to_lawsuit VARCHAR(128),
    b_party_to_lawsuit_explanation VARCHAR(128),
    b_power_of_attorney VARCHAR(128),
    b_power_of_attorney_signing_capacity VARCHAR(1024),
    b_power_of_attorney_first_name VARCHAR(32),
    b_power_of_attorney_last_name VARCHAR(32),
    b_power_of_attorney_middle_name VARCHAR(32),
    b_power_of_attorney_name_suffix VARCHAR(32),
    b_power_of_attorney_company_name VARCHAR(128),
    b_power_of_attorney_title VARCHAR(128),
    b_power_of_attorney_office_phone VARCHAR(32),
    b_power_of_attorney_office_phone_extension VARCHAR(16),
    b_power_of_attorney_mobile_phone VARCHAR(32),
    b_power_of_attorney_email VARCHAR(256),
    b_power_of_attorney_fax VARCHAR(32),
    b_power_of_attorney_city VARCHAR(128),
    b_power_of_attorney_country VARCHAR(128),
    b_power_of_attorney_postal_code VARCHAR(128),
    b_power_of_attorney_state VARCHAR(128),
    b_power_of_attorney_street1 VARCHAR(128),
    b_power_of_attorney_street2 VARCHAR(128),
    b_presently_delinquent VARCHAR(128),
    b_presently_delinquent_explanation VARCHAR(128),
    b_prior_property_title_type VARCHAR(128),
    b_prior_property_usage_type VARCHAR(128),
    b_property_foreclosure VARCHAR(128),
    b_property_foreclosure_explanation VARCHAR(128),
    b_race_refused VARCHAR(128),
    b_race_collected_visual_or_surname VARCHAR(128),
    b_race_american_indian_or_alaska_native BIT,
    b_race_other_american_indian_or_alaska_native_description VARCHAR(100),
    b_race_asian BIT,
    b_race_asian_indian BIT,
    b_race_chinese BIT,
    b_race_filipino BIT,
    b_race_japanese BIT,
    b_race_korean BIT,
    b_race_vietnamese BIT,
    b_race_other_asian BIT,
    b_race_other_asian_description VARCHAR(100),
    b_race_black_or_african_american BIT,
    b_race_information_not_provided BIT,
    b_race_national_origin_refusal BIT,
    b_race_native_hawaiian_or_other_pacific_islander BIT,
    b_race_native_hawaiian BIT,
    b_race_guamanian_or_chamorro BIT,
    b_race_samoan BIT,
    b_race_other_pacific_islander BIT,
    b_race_not_obtainable BIT,
    b_race_other_pacific_islander_description VARCHAR(100),
    b_race_not_applicable BIT,
    b_race_white BIT,
    b_schooling_years INTEGER,
    b_titleholder VARCHAR(128),
    b_experian_credit_score INTEGER,
    b_equifax_credit_score INTEGER,
    b_trans_union_credit_score INTEGER,
    b_decision_credit_score INTEGER,
    b_borrower_tiny_id_type VARCHAR(128),
    b_first_time_home_buyer_explain VARCHAR(1024),
    b_first_time_home_buyer_auto_compute BIT,
    b_caivrs_id VARCHAR(16),
    b_caivrs_messages TEXT,
    b_on_ldp_list VARCHAR(128),
    b_on_gsa_list VARCHAR(128),
    b_monthly_job_federal_tax_amount NUMERIC(15, 2),
    b_monthly_job_state_tax_amount NUMERIC(15, 2),
    b_monthly_job_retirement_tax_amount NUMERIC(15, 2),
    b_monthly_job_medicare_tax_amount NUMERIC(15, 2),
    b_monthly_job_state_disability_insurance_amount NUMERIC(15, 2),
    b_monthly_job_other_tax_1_amount NUMERIC(15, 2),
    b_monthly_job_other_tax_1_description VARCHAR(128),
    b_monthly_job_other_tax_2_amount NUMERIC(15, 2),
    b_monthly_job_other_tax_2_description VARCHAR(128),
    b_monthly_job_other_tax_3_amount NUMERIC(15, 2),
    b_monthly_job_other_tax_3_description VARCHAR(128),
    b_monthly_job_total_tax_amount NUMERIC(15, 2),
    b_homeownership_education_type VARCHAR(128),
    b_homeownership_education_agency_type VARCHAR(128),
    b_homeownership_education_id VARCHAR(128),
    b_homeownership_education_name VARCHAR(128),
    b_homeownership_education_complete_date DATE,
    b_housing_counseling_type VARCHAR(128),
    b_housing_counseling_agency_type VARCHAR(128),
    b_housing_counseling_id VARCHAR(128),
    b_housing_counseling_name VARCHAR(128),
    b_housing_counseling_complete_date DATE,
    b_legal_entity_type VARCHAR(128),
    b_credit_report_authorization_datetime TIMESTAMP,
    b_credit_report_authorization_method VARCHAR(128),
    b_credit_report_authorization_obtained_by_unparsed_name VARCHAR(128),
    b_disabled VARCHAR(128),
    b_usda_annual_child_care_expenses NUMERIC(15, 2),
    b_usda_disability_expenses NUMERIC(15, 2),
    b_usda_medical_expenses NUMERIC(15, 2),
    b_usda_income_from_assets NUMERIC(15, 2),
    b_usda_moderate_income_limit NUMERIC(15, 2),
    b_hud_employee BIT,
    b_relationship_to_primary_borrower_type VARCHAR(128),
    b_relationship_to_seller_type VARCHAR(128),
    b_preferred_first_name VARCHAR(32),
    b_domestic_relationship_state_type VARCHAR(128)
);

CREATE TABLE history_octane.borrower_alias
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ba_pid BIGINT NOT NULL,
    ba_version INTEGER,
    ba_account_number VARCHAR(32),
    ba_borrower_pid BIGINT,
    ba_credit_request_pid BIGINT,
    ba_creditor_name VARCHAR(32),
    ba_first_name VARCHAR(32),
    ba_last_name VARCHAR(32),
    ba_middle_name VARCHAR(32),
    ba_name_suffix VARCHAR(32),
    ba_credit_report_identifier VARCHAR(32)
);

CREATE TABLE history_octane.borrower_asset
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bas_pid BIGINT NOT NULL,
    bas_version INTEGER,
    bas_borrower_pid BIGINT,
    bas_asset_pid BIGINT
);

CREATE TABLE history_octane.borrower_associated_address
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    baa_pid BIGINT NOT NULL,
    baa_version INTEGER,
    baa_borrower_pid BIGINT,
    baa_credit_request_pid BIGINT,
    baa_credit_report_identifier VARCHAR(32),
    baa_borrower_associated_address_source_type VARCHAR(128),
    baa_reported_month INTEGER,
    baa_reported_year INTEGER,
    baa_reported_date_verified BIT,
    baa_reported_address_street1 VARCHAR(128),
    baa_reported_address_street2 VARCHAR(128),
    baa_reported_address_city VARCHAR(128),
    baa_reported_address_state VARCHAR(128),
    baa_reported_address_postal_code VARCHAR(128),
    baa_reported_address_country VARCHAR(16),
    baa_current VARCHAR(128),
    baa_internal_note VARCHAR(1024),
    baa_requires_explanation BIT,
    baa_force_requires_explanation BIT,
    baa_borrower_associated_address_explanation_type VARCHAR(128),
    baa_explanation_type_other_explanation VARCHAR(128),
    baa_typo_of_loan_app_address VARCHAR(128),
    baa_known_to_borrower VARCHAR(128),
    baa_owned_by_borrower VARCHAR(128),
    baa_resided_at_address VARCHAR(128),
    baa_used_as_mailing_address VARCHAR(128),
    baa_current_mailing_address VARCHAR(128),
    baa_current_residence VARCHAR(128),
    baa_borrower_resided_at_address_after_date VARCHAR(128)
);

CREATE TABLE history_octane.borrower_dependent
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bd_pid BIGINT NOT NULL,
    bd_version INTEGER,
    bd_borrower_pid BIGINT,
    bd_first_name VARCHAR(32),
    bd_last_name VARCHAR(32),
    bd_age INTEGER,
    bd_disabled VARCHAR(128),
    bd_full_time_student VARCHAR(128),
    bd_receives_income VARCHAR(128),
    bd_income_source TEXT,
    bd_income_amount NUMERIC(15, 2)
);

CREATE TABLE history_octane.borrower_income
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bi_pid BIGINT NOT NULL,
    bi_version INTEGER,
    bi_borrower_pid BIGINT,
    bi_borrower_income_category_type VARCHAR(128),
    bi_job_gap_reason_type VARCHAR(128),
    bi_job_gap_reason_explanation VARCHAR(1024),
    bi_business_ownership_type VARCHAR(128),
    bi_from_date DATE,
    bi_through_date DATE,
    bi_current BIT,
    bi_primary BIT,
    bi_source_name VARCHAR(128),
    bi_source_address_street1 VARCHAR(128),
    bi_source_address_street2 VARCHAR(128),
    bi_source_address_city VARCHAR(128),
    bi_source_address_state VARCHAR(128),
    bi_source_address_postal_code VARCHAR(128),
    bi_source_address_country VARCHAR(128),
    bi_source_phone VARCHAR(32),
    bi_source_phone_extension VARCHAR(16),
    bi_synthetic_unique BIT
);

CREATE TABLE history_octane.borrower_job_gap
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bjg_pid BIGINT NOT NULL,
    bjg_version INTEGER,
    bjg_borrower_pid BIGINT,
    bjg_from_date DATE,
    bjg_through_date DATE,
    bjg_primary_job BIT
);

CREATE TABLE history_octane.borrower_user_deal
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bud_pid BIGINT NOT NULL,
    bud_version INTEGER,
    bud_borrower_user_pid BIGINT,
    bud_deal_pid BIGINT,
    bud_borrower_pid BIGINT,
    bud_borrower_user_deal_access_type VARCHAR(128),
    bud_loan_key VARCHAR(128),
    bud_electronic_transaction_consent BIT,
    bud_electronic_transaction_consent_datetime TIMESTAMP,
    bud_electronic_transaction_consent_ip_address VARCHAR(32),
    bud_create_datetime TIMESTAMP
);

CREATE TABLE history_octane.borrower_user_change_email
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    buce_pid BIGINT NOT NULL,
    buce_version INTEGER,
    buce_borrower_user_pid BIGINT,
    buce_create_datetime TIMESTAMP,
    buce_change_email_id VARCHAR(128),
    buce_email VARCHAR(256),
    buce_borrower_user_deal_pid BIGINT
);

CREATE TABLE history_octane.business_income
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bui_pid BIGINT NOT NULL,
    bui_version INTEGER,
    bui_borrower_income_pid BIGINT,
    bui_business_income_type VARCHAR(128),
    bui_business_disposition_type VARCHAR(128),
    bui_company_ein VARCHAR(16),
    bui_estimated_net_income_amount NUMERIC(15, 2),
    bui_estimated_mode BIT,
    bui_worksheet_monthly_total_amount NUMERIC(15, 2),
    bui_monthly_total_amount NUMERIC(15, 2),
    bui_borrower_income_percent NUMERIC(11, 9),
    bui_calc_method_type VARCHAR(128),
    bui_common_year1_year INTEGER,
    bui_common_year1_year_include BIT,
    bui_common_year1_from_date DATE,
    bui_common_year1_through_date DATE,
    bui_common_year1_months NUMERIC(4, 2),
    bui_common_year1_annual_total_amount NUMERIC(15, 2),
    bui_common_year1_monthly_total_amount NUMERIC(15, 2),
    bui_common_year2_year INTEGER,
    bui_common_year2_year_include BIT,
    bui_common_year2_from_date DATE,
    bui_common_year2_through_date DATE,
    bui_common_year2_months NUMERIC(4, 2),
    bui_common_year2_annual_total_amount NUMERIC(15, 2),
    bui_common_year2_monthly_total_amount NUMERIC(15, 2),
    bui_common_year3_year INTEGER,
    bui_common_year3_year_include BIT,
    bui_common_year3_from_date DATE,
    bui_common_year3_through_date DATE,
    bui_common_year3_months NUMERIC(4, 2),
    bui_common_year3_annual_total_amount NUMERIC(15, 2),
    bui_common_year3_monthly_total_amount NUMERIC(15, 2),
    bui_sole_year1_gross_receipts NUMERIC(15, 2),
    bui_sole_year1_other_income_loss_exp NUMERIC(15, 2),
    bui_sole_year1_depletion NUMERIC(15, 2),
    bui_sole_year1_depreciation NUMERIC(15, 2),
    bui_sole_year1_meal_exclusions NUMERIC(15, 2),
    bui_sole_year1_business_use_home NUMERIC(15, 2),
    bui_sole_year1_amortization_loss NUMERIC(15, 2),
    bui_sole_year1_business_miles INTEGER,
    bui_sole_year1_depreciation_mile NUMERIC(11, 9),
    bui_sole_year1_mileage_depreciation NUMERIC(15, 2),
    bui_sole_year2_gross_receipts NUMERIC(15, 2),
    bui_sole_year2_other_income_loss_exp NUMERIC(15, 2),
    bui_sole_year2_depletion NUMERIC(15, 2),
    bui_sole_year2_depreciation NUMERIC(15, 2),
    bui_sole_year2_meal_exclusions NUMERIC(15, 2),
    bui_sole_year2_business_use_home NUMERIC(15, 2),
    bui_sole_year2_amortization_loss NUMERIC(15, 2),
    bui_sole_year2_business_miles INTEGER,
    bui_sole_year2_depreciation_mile NUMERIC(11, 9),
    bui_sole_year2_mileage_depreciation NUMERIC(15, 2),
    bui_sole_year3_gross_receipts NUMERIC(15, 2),
    bui_sole_year3_other_income_loss_exp NUMERIC(15, 2),
    bui_sole_year3_depletion NUMERIC(15, 2),
    bui_sole_year3_depreciation NUMERIC(15, 2),
    bui_sole_year3_meal_exclusions NUMERIC(15, 2),
    bui_sole_year3_business_use_home NUMERIC(15, 2),
    bui_sole_year3_amortization_loss NUMERIC(15, 2),
    bui_sole_year3_business_miles INTEGER,
    bui_sole_year3_depreciation_mile NUMERIC(11, 9),
    bui_sole_year3_mileage_depreciation NUMERIC(15, 2),
    bui_partner_year1_amortization_loss NUMERIC(15, 2),
    bui_partner_year1_depletion NUMERIC(15, 2),
    bui_partner_year1_depreciation NUMERIC(15, 2),
    bui_partner_year1_guaranteed_payments NUMERIC(15, 2),
    bui_partner_year1_meals_exclusion NUMERIC(15, 2),
    bui_partner_year1_net_rental_income_loss NUMERIC(15, 2),
    bui_partner_year1_notes_payable_less_year NUMERIC(15, 2),
    bui_partner_year1_ordinary_income_loss NUMERIC(15, 2),
    bui_partner_year1_other_income_loss NUMERIC(15, 2),
    bui_partner_year1_ownership_percent NUMERIC(11, 9),
    bui_partner_year1_form_k_1_total NUMERIC(15, 2),
    bui_partner_year1_form_1065_subtotal NUMERIC(15, 2),
    bui_partner_year1_form_1065_total NUMERIC(15, 2),
    bui_partner_year2_amortization_loss NUMERIC(15, 2),
    bui_partner_year2_depletion NUMERIC(15, 2),
    bui_partner_year2_depreciation NUMERIC(15, 2),
    bui_partner_year2_guaranteed_payments NUMERIC(15, 2),
    bui_partner_year2_meals_exclusion NUMERIC(15, 2),
    bui_partner_year2_net_rental_income_loss NUMERIC(15, 2),
    bui_partner_year2_notes_payable_less_year NUMERIC(15, 2),
    bui_partner_year2_ordinary_income_loss NUMERIC(15, 2),
    bui_partner_year2_other_income_loss NUMERIC(15, 2),
    bui_partner_year2_ownership_percent NUMERIC(11, 9),
    bui_partner_year2_form_k_1_total NUMERIC(15, 2),
    bui_partner_year2_form_1065_subtotal NUMERIC(15, 2),
    bui_partner_year2_form_1065_total NUMERIC(15, 2),
    bui_partner_year3_amortization_loss NUMERIC(15, 2),
    bui_partner_year3_depletion NUMERIC(15, 2),
    bui_partner_year3_depreciation NUMERIC(15, 2),
    bui_partner_year3_guaranteed_payments NUMERIC(15, 2),
    bui_partner_year3_meals_exclusion NUMERIC(15, 2),
    bui_partner_year3_net_rental_income_loss NUMERIC(15, 2),
    bui_partner_year3_notes_payable_less_year NUMERIC(15, 2),
    bui_partner_year3_ordinary_income_loss NUMERIC(15, 2),
    bui_partner_year3_other_income_loss NUMERIC(15, 2),
    bui_partner_year3_ownership_percent NUMERIC(11, 9),
    bui_partner_year3_form_k_1_total NUMERIC(15, 2),
    bui_partner_year3_form_1065_subtotal NUMERIC(15, 2),
    bui_partner_year3_form_1065_total NUMERIC(15, 2),
    bui_form_1065_available BIT,
    bui_scorp_year1_ordinary_income_loss NUMERIC(15, 2),
    bui_scorp_year1_net_rental_income_loss NUMERIC(15, 2),
    bui_scorp_year1_other_income_loss NUMERIC(15, 2),
    bui_scorp_year1_depletion NUMERIC(15, 2),
    bui_scorp_year1_depreciation NUMERIC(15, 2),
    bui_scorp_year1_amortization_loss NUMERIC(15, 2),
    bui_scorp_year1_notes_payable_less_year NUMERIC(15, 2),
    bui_scorp_year1_meals_exclusion NUMERIC(15, 2),
    bui_scorp_year1_ownership_percent NUMERIC(11, 9),
    bui_scorp_year1_form_k_1_total NUMERIC(15, 2),
    bui_scorp_year1_form_1120s_subtotal NUMERIC(15, 2),
    bui_scorp_year1_form_1120s_total NUMERIC(15, 2),
    bui_scorp_year2_ordinary_income_loss NUMERIC(15, 2),
    bui_scorp_year2_net_rental_income_loss NUMERIC(15, 2),
    bui_scorp_year2_other_income_loss NUMERIC(15, 2),
    bui_scorp_year2_depletion NUMERIC(15, 2),
    bui_scorp_year2_depreciation NUMERIC(15, 2),
    bui_scorp_year2_amortization_loss NUMERIC(15, 2),
    bui_scorp_year2_notes_payable_less_year NUMERIC(15, 2),
    bui_scorp_year2_meals_exclusion NUMERIC(15, 2),
    bui_scorp_year2_ownership_percent NUMERIC(11, 9),
    bui_scorp_year2_form_k_1_total NUMERIC(15, 2),
    bui_scorp_year2_form_1120s_subtotal NUMERIC(15, 2),
    bui_scorp_year2_form_1120s_total NUMERIC(15, 2),
    bui_scorp_year3_ordinary_income_loss NUMERIC(15, 2),
    bui_scorp_year3_net_rental_income_loss NUMERIC(15, 2),
    bui_scorp_year3_other_income_loss NUMERIC(15, 2),
    bui_scorp_year3_depletion NUMERIC(15, 2),
    bui_scorp_year3_depreciation NUMERIC(15, 2),
    bui_scorp_year3_amortization_loss NUMERIC(15, 2),
    bui_scorp_year3_notes_payable_less_year NUMERIC(15, 2),
    bui_scorp_year3_meals_exclusion NUMERIC(15, 2),
    bui_scorp_year3_ownership_percent NUMERIC(11, 9),
    bui_scorp_year3_form_k_1_total NUMERIC(15, 2),
    bui_scorp_year3_form_1120s_subtotal NUMERIC(15, 2),
    bui_scorp_year3_form_1120s_total NUMERIC(15, 2),
    bui_form_1120s_available BIT,
    bui_corp_year1_taxable_income NUMERIC(15, 2),
    bui_corp_year1_total_tax NUMERIC(15, 2),
    bui_corp_year1_gain_loss NUMERIC(15, 2),
    bui_corp_year1_other_income_loss NUMERIC(15, 2),
    bui_corp_year1_depreciation NUMERIC(15, 2),
    bui_corp_year1_depletion NUMERIC(15, 2),
    bui_corp_year1_domestic_production_activities NUMERIC(15, 2),
    bui_corp_year1_other_deductions NUMERIC(15, 2),
    bui_corp_year1_net_operating_loss_special_deductions NUMERIC(15, 2),
    bui_corp_year1_notes_payable_less_one_year NUMERIC(15, 2),
    bui_corp_year1_meals_exclusion NUMERIC(15, 2),
    bui_corp_year1_dividends_paid_to_borrower NUMERIC(15, 2),
    bui_corp_year1_annual_subtotal NUMERIC(15, 2),
    bui_corp_year1_ownership_percent NUMERIC(11, 9),
    bui_corp_year1_annual_subtotal_ownership_applied NUMERIC(15, 2),
    bui_corp_year2_taxable_income NUMERIC(15, 2),
    bui_corp_year2_total_tax NUMERIC(15, 2),
    bui_corp_year2_gain_loss NUMERIC(15, 2),
    bui_corp_year2_other_income_loss NUMERIC(15, 2),
    bui_corp_year2_depreciation NUMERIC(15, 2),
    bui_corp_year2_depletion NUMERIC(15, 2),
    bui_corp_year2_domestic_production_activities NUMERIC(15, 2),
    bui_corp_year2_other_deductions NUMERIC(15, 2),
    bui_corp_year2_net_operating_loss_special_deductions NUMERIC(15, 2),
    bui_corp_year2_notes_payable_less_one_year NUMERIC(15, 2),
    bui_corp_year2_meals_exclusion NUMERIC(15, 2),
    bui_corp_year2_dividends_paid_to_borrower NUMERIC(15, 2),
    bui_corp_year2_annual_subtotal NUMERIC(15, 2),
    bui_corp_year2_ownership_percent NUMERIC(11, 9),
    bui_corp_year2_annual_subtotal_ownership_applied NUMERIC(15, 2),
    bui_corp_year3_taxable_income NUMERIC(15, 2),
    bui_corp_year3_total_tax NUMERIC(15, 2),
    bui_corp_year3_gain_loss NUMERIC(15, 2),
    bui_corp_year3_other_income_loss NUMERIC(15, 2),
    bui_corp_year3_depreciation NUMERIC(15, 2),
    bui_corp_year3_depletion NUMERIC(15, 2),
    bui_corp_year3_domestic_production_activities NUMERIC(15, 2),
    bui_corp_year3_other_deductions NUMERIC(15, 2),
    bui_corp_year3_net_operating_loss_special_deductions NUMERIC(15, 2),
    bui_corp_year3_notes_payable_less_one_year NUMERIC(15, 2),
    bui_corp_year3_meals_exclusion NUMERIC(15, 2),
    bui_corp_year3_dividends_paid_to_borrower NUMERIC(15, 2),
    bui_corp_year3_annual_subtotal NUMERIC(15, 2),
    bui_corp_year3_ownership_percent NUMERIC(11, 9),
    bui_corp_year3_annual_subtotal_ownership_applied NUMERIC(15, 2),
    bui_sch_f_year1_specific_income_loss NUMERIC(15, 2),
    bui_sch_f_year1_nonrecurring_income_loss NUMERIC(15, 2),
    bui_sch_f_year1_depreciation NUMERIC(15, 2),
    bui_sch_f_year1_amortization_loss_depletion NUMERIC(15, 2),
    bui_sch_f_year1_business_use_home NUMERIC(15, 2),
    bui_sch_f_year2_specific_income_loss NUMERIC(15, 2),
    bui_sch_f_year2_nonrecurring_income_loss NUMERIC(15, 2),
    bui_sch_f_year2_depreciation NUMERIC(15, 2),
    bui_sch_f_year2_amortization_loss_depletion NUMERIC(15, 2),
    bui_sch_f_year2_business_use_home NUMERIC(15, 2),
    bui_sch_f_year3_specific_income_loss NUMERIC(15, 2),
    bui_sch_f_year3_nonrecurring_income_loss NUMERIC(15, 2),
    bui_sch_f_year3_depreciation NUMERIC(15, 2),
    bui_sch_f_year3_amortization_loss_depletion NUMERIC(15, 2),
    bui_sch_f_year3_business_use_home NUMERIC(15, 2),
    bui_underwriter_comments VARCHAR(1024)
);

CREATE TABLE history_octane.consumer_privacy_affected_borrower
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cpab_pid BIGINT NOT NULL,
    cpab_version INTEGER,
    cpab_consumer_privacy_request_pid BIGINT,
    cpab_deal_pid BIGINT,
    cpab_borrower_pid BIGINT
);

CREATE TABLE history_octane.job_income
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ji_pid BIGINT NOT NULL,
    ji_version INTEGER,
    ji_borrower_income_pid BIGINT,
    ji_estimated_mode BIT,
    ji_line_of_work_years INTEGER,
    ji_voe_written_required BIT,
    ji_voe_written_system BIT,
    ji_voe_written_forced BIT,
    ji_base_income_calc_method_type VARCHAR(128),
    ji_monthly_base_unadjusted_amount NUMERIC(15, 2),
    ji_monthly_base_adjustment_amount NUMERIC(15, 2),
    ji_overtime_income_calc_method_type VARCHAR(128),
    ji_monthly_overtime_unadjusted_amount NUMERIC(15, 2),
    ji_monthly_overtime_adjustment_amount NUMERIC(15, 2),
    ji_bonus_income_calc_method_type VARCHAR(128),
    ji_monthly_bonus_unadjusted_amount NUMERIC(15, 2),
    ji_monthly_bonus_adjustment_amount NUMERIC(15, 2),
    ji_commissions_income_calc_method_type VARCHAR(128),
    ji_monthly_commissions_unadjusted_amount NUMERIC(15, 2),
    ji_monthly_commissions_adjustment_amount NUMERIC(15, 2),
    ji_tip_income_calc_method_type VARCHAR(128),
    ji_monthly_tip_unadjusted_amount NUMERIC(15, 2),
    ji_monthly_tip_adjustment_amount NUMERIC(15, 2),
    ji_adjustment_income_calc_method_type VARCHAR(128),
    ji_monthly_adjustment_amount NUMERIC(15, 2),
    ji_position VARCHAR(32),
    ji_employer_relative BIT,
    ji_employer_property_seller BIT,
    ji_employer_real_estate_broker BIT,
    ji_military_job BIT,
    ji_estimated_monthly_military_amount NUMERIC(15, 2),
    ji_monthly_military_base_pay_amount NUMERIC(15, 2),
    ji_monthly_military_clothes_allowance_ungrossed_amount NUMERIC(15, 2),
    ji_monthly_military_combat_pay_amount NUMERIC(15, 2),
    ji_monthly_military_flight_pay_amount NUMERIC(15, 2),
    ji_monthly_military_hazard_pay_amount NUMERIC(15, 2),
    ji_monthly_military_housing_allowance_ungrossed_amount NUMERIC(15, 2),
    ji_monthly_military_overseas_pay_amount NUMERIC(15, 2),
    ji_monthly_military_prop_pay_amount NUMERIC(15, 2),
    ji_monthly_military_quarters_allowance_ungrossed_amount NUMERIC(15, 2),
    ji_monthly_military_rations_allowance_ungrossed_amount NUMERIC(15, 2),
    ji_military_gross_up BIT,
    ji_military_gross_up_percent NUMERIC(11, 9),
    ji_monthly_military_clothes_allowance_amount NUMERIC(15, 2),
    ji_monthly_military_quarters_allowance_amount NUMERIC(15, 2),
    ji_monthly_military_rations_allowance_amount NUMERIC(15, 2),
    ji_monthly_military_housing_allowance_amount NUMERIC(15, 2),
    ji_military_pay_subtotal_amount NUMERIC(15, 2),
    ji_military_allowance_subtotal_amount NUMERIC(15, 2),
    ji_monthly_military_total_amount NUMERIC(15, 2),
    ji_annual_military_total_amount NUMERIC(15, 2),
    ji_job_year1_year INTEGER,
    ji_job_year1_year_include BIT,
    ji_job_year1_from_date DATE,
    ji_job_year1_through_date DATE,
    ji_job_year1_months NUMERIC(4, 2),
    ji_job_year1_base_input_amount NUMERIC(15, 2),
    ji_job_year1_monthly_base_amount NUMERIC(15, 2),
    ji_job_year1_overtime_input_amount NUMERIC(15, 2),
    ji_job_year1_monthly_overtime_amount NUMERIC(15, 2),
    ji_job_year1_bonus_input_amount NUMERIC(15, 2),
    ji_job_year1_monthly_bonus_amount NUMERIC(15, 2),
    ji_job_year1_commissions_input_amount NUMERIC(15, 2),
    ji_job_year1_monthly_commissions_amount NUMERIC(15, 2),
    ji_job_year1_tip_input_amount NUMERIC(15, 2),
    ji_job_year1_monthly_tip_amount NUMERIC(15, 2),
    ji_job_year1_adjustment_input_amount NUMERIC(15, 2),
    ji_job_year1_monthly_adjustment_amount NUMERIC(15, 2),
    ji_job_year1_monthly_total_amount NUMERIC(15, 2),
    ji_job_year1_annual_total_amount NUMERIC(15, 2),
    ji_job_year1_monthly_total_commissions_percent NUMERIC(11, 9),
    ji_job_year2_year INTEGER,
    ji_job_year2_year_include BIT,
    ji_job_year2_from_date DATE,
    ji_job_year2_through_date DATE,
    ji_job_year2_months NUMERIC(4, 2),
    ji_job_year2_base_input_amount NUMERIC(15, 2),
    ji_job_year2_monthly_base_amount NUMERIC(15, 2),
    ji_job_year2_overtime_input_amount NUMERIC(15, 2),
    ji_job_year2_monthly_overtime_amount NUMERIC(15, 2),
    ji_job_year2_bonus_input_amount NUMERIC(15, 2),
    ji_job_year2_monthly_bonus_amount NUMERIC(15, 2),
    ji_job_year2_commissions_input_amount NUMERIC(15, 2),
    ji_job_year2_monthly_commissions_amount NUMERIC(15, 2),
    ji_job_year2_tip_input_amount NUMERIC(15, 2),
    ji_job_year2_monthly_tip_amount NUMERIC(15, 2),
    ji_job_year2_adjustment_input_amount NUMERIC(15, 2),
    ji_job_year2_monthly_adjustment_amount NUMERIC(15, 2),
    ji_job_year2_monthly_total_amount NUMERIC(15, 2),
    ji_job_year2_annual_total_amount NUMERIC(15, 2),
    ji_job_year2_monthly_total_commissions_percent NUMERIC(11, 9),
    ji_job_year3_year INTEGER,
    ji_job_year3_year_include BIT,
    ji_job_year3_from_date DATE,
    ji_job_year3_through_date DATE,
    ji_job_year3_months NUMERIC(4, 2),
    ji_job_year3_base_input_amount NUMERIC(15, 2),
    ji_job_year3_monthly_base_amount NUMERIC(15, 2),
    ji_job_year3_overtime_input_amount NUMERIC(15, 2),
    ji_job_year3_monthly_overtime_amount NUMERIC(15, 2),
    ji_job_year3_bonus_input_amount NUMERIC(15, 2),
    ji_job_year3_monthly_bonus_amount NUMERIC(15, 2),
    ji_job_year3_commissions_input_amount NUMERIC(15, 2),
    ji_job_year3_monthly_commissions_amount NUMERIC(15, 2),
    ji_job_year3_tip_input_amount NUMERIC(15, 2),
    ji_job_year3_monthly_tip_amount NUMERIC(15, 2),
    ji_job_year3_adjustment_input_amount NUMERIC(15, 2),
    ji_job_year3_monthly_adjustment_amount NUMERIC(15, 2),
    ji_job_year3_monthly_total_amount NUMERIC(15, 2),
    ji_job_year3_annual_total_amount NUMERIC(15, 2),
    ji_job_year3_monthly_total_commissions_percent NUMERIC(11, 9),
    ji_estimated_monthly_base_amount NUMERIC(15, 2),
    ji_estimated_monthly_bonus_amount NUMERIC(15, 2),
    ji_estimated_monthly_overtime_amount NUMERIC(15, 2),
    ji_estimated_monthly_commissions_amount NUMERIC(15, 2),
    ji_estimated_monthly_tip_amount NUMERIC(15, 2),
    ji_estimated_monthly_total_amount NUMERIC(15, 2),
    ji_estimated_annual_total_amount NUMERIC(15, 2),
    ji_estimated_monthly_total_commissions_percent NUMERIC(11, 9),
    ji_worksheet_monthly_base_amount NUMERIC(15, 2),
    ji_worksheet_monthly_bonus_amount NUMERIC(15, 2),
    ji_worksheet_monthly_overtime_amount NUMERIC(15, 2),
    ji_worksheet_monthly_commissions_amount NUMERIC(15, 2),
    ji_worksheet_monthly_tip_amount NUMERIC(15, 2),
    ji_worksheet_monthly_total_amount NUMERIC(15, 2),
    ji_worksheet_annual_total_amount NUMERIC(15, 2),
    ji_worksheet_monthly_total_commissions_percent NUMERIC(11, 9),
    ji_working_monthly_base_amount NUMERIC(15, 2),
    ji_working_monthly_bonus_amount NUMERIC(15, 2),
    ji_working_monthly_overtime_amount NUMERIC(15, 2),
    ji_working_monthly_commissions_amount NUMERIC(15, 2),
    ji_working_monthly_tip_amount NUMERIC(15, 2),
    ji_working_monthly_total_amount NUMERIC(15, 2),
    ji_working_annual_total_amount NUMERIC(15, 2),
    ji_working_monthly_total_commissions_percent NUMERIC(11, 9),
    ji_underwriter_comments VARCHAR(1024),
    ji_foreign_income BIT,
    ji_seasonal_income BIT,
    ji_voe_third_party_verifier_order_id VARCHAR(16),
    ji_employer_voe_name VARCHAR(128),
    ji_employer_voe_title VARCHAR(128),
    ji_employer_voe_phone VARCHAR(32),
    ji_employer_voe_phone_extension VARCHAR(16),
    ji_employer_voe_fax VARCHAR(32),
    ji_employer_voe_email VARCHAR(256),
    ji_phone_voe_verify_method_type VARCHAR(128),
    ji_address_voe_verify_method_type VARCHAR(128),
    ji_verified_date DATE,
    ji_verified_by VARCHAR(128),
    ji_voe_verbal_verify_method_type VARCHAR(128),
    ji_voe_third_party_verifier_type VARCHAR(128),
    ji_employer_other_interested_party BIT,
    ji_employer_other_interested_party_description VARCHAR(128),
    ji_line_of_work_months INTEGER
);

CREATE TABLE history_octane.lp_finding
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lpf_pid BIGINT NOT NULL,
    lpf_version INTEGER,
    lpf_lp_request_pid BIGINT,
    lpf_lp_finding_message_type VARCHAR(128),
    lpf_finding_yes_no_unknown_type VARCHAR(128),
    lpf_finding_value VARCHAR(128)
);

CREATE TABLE history_octane.lp_request_credit
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lprc_pid BIGINT NOT NULL,
    lprc_version INTEGER,
    lprc_lp_request_pid BIGINT,
    lprc_create_datetime TIMESTAMP,
    lprc_credit_report_create_datetime TIMESTAMP,
    lprc_credit_bureau_type VARCHAR(128),
    lprc_credit_report_identifier VARCHAR(32),
    lprc_credit_report_name VARCHAR(256),
    lprc_aus_credit_service_type VARCHAR(128),
    lprc_borrower_1_borrower_tiny_id_type VARCHAR(128),
    lprc_borrower_2_borrower_tiny_id_type VARCHAR(128)
);

CREATE TABLE history_octane.mers_daily_report
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    medr_pid BIGINT NOT NULL,
    medr_version INTEGER,
    medr_account_pid BIGINT,
    medr_create_datetime TIMESTAMP,
    medr_report_date DATE,
    medr_import_status_type VARCHAR(128),
    medr_import_status_messages TEXT,
    medr_import_attempt_count INTEGER,
    medr_imported_loan_count INTEGER,
    medr_consolidated_report_text_repository_file_pid BIGINT
);

CREATE TABLE history_octane.military_service
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ms_pid BIGINT NOT NULL,
    ms_version INTEGER,
    ms_borrower_pid BIGINT,
    ms_from_date DATE,
    ms_through_date DATE,
    ms_name_used_during_service VARCHAR(128),
    ms_service_number VARCHAR(32),
    ms_military_branch_type VARCHAR(128),
    ms_military_service_type VARCHAR(128),
    ms_military_status_type VARCHAR(128)
);

CREATE TABLE history_octane.other_income
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    oi_pid BIGINT NOT NULL,
    oi_version INTEGER,
    oi_other_income_type VARCHAR(128),
    oi_borrower_income_pid BIGINT,
    oi_estimated_net_income_amount NUMERIC(15, 2),
    oi_estimated_mode BIT,
    oi_worksheet_monthly_total_amount NUMERIC(15, 2),
    oi_monthly_total_amount NUMERIC(15, 2),
    oi_borrower_income_percent NUMERIC(11, 9),
    oi_description VARCHAR(128),
    oi_calc_method_type VARCHAR(128),
    oi_common_year1_year INTEGER,
    oi_common_year1_year_include BIT,
    oi_common_year1_from_date DATE,
    oi_common_year1_through_date DATE,
    oi_common_year1_months NUMERIC(4, 2),
    oi_common_year1_annual_total_amount NUMERIC(15, 2),
    oi_common_year1_monthly_total_amount NUMERIC(15, 2),
    oi_common_year2_year INTEGER,
    oi_common_year2_year_include BIT,
    oi_common_year2_from_date DATE,
    oi_common_year2_through_date DATE,
    oi_common_year2_months NUMERIC(4, 2),
    oi_common_year2_annual_total_amount NUMERIC(15, 2),
    oi_common_year2_monthly_total_amount NUMERIC(15, 2),
    oi_common_year3_year INTEGER,
    oi_common_year3_year_include BIT,
    oi_common_year3_from_date DATE,
    oi_common_year3_through_date DATE,
    oi_common_year3_months NUMERIC(4, 2),
    oi_common_year3_annual_total_amount NUMERIC(15, 2),
    oi_common_year3_monthly_total_amount NUMERIC(15, 2),
    oi_simple_year1_unadjusted_amount NUMERIC(15, 2),
    oi_simple_year1_income_federal_tax_exempt BIT,
    oi_simple_year1_tax_exempt_tax_rate_percent NUMERIC(11, 9),
    oi_simple_year1_tax_exempt_amount NUMERIC(15, 2),
    oi_simple_year2_unadjusted_amount NUMERIC(15, 2),
    oi_simple_year2_income_federal_tax_exempt BIT,
    oi_simple_year2_tax_exempt_tax_rate_percent NUMERIC(11, 9),
    oi_simple_year2_tax_exempt_amount NUMERIC(15, 2),
    oi_simple_year3_unadjusted_amount NUMERIC(15, 2),
    oi_simple_year3_income_federal_tax_exempt BIT,
    oi_simple_year3_tax_exempt_tax_rate_percent NUMERIC(11, 9),
    oi_simple_year3_tax_exempt_amount NUMERIC(15, 2),
    oi_simple_unadjusted_monthly_amount NUMERIC(15, 2),
    oi_simple_income_federal_tax_exempt BIT,
    oi_simple_tax_exempt_tax_rate_percent NUMERIC(11, 9),
    oi_simple_tax_exempt_amount NUMERIC(15, 2),
    oi_simple_calculated_monthly_amount NUMERIC(15, 2),
    oi_underwriter_comments VARCHAR(1024),
    oi_mortgage_credit_certificate_issuer_pid BIGINT,
    oi_mcc_reservation_number VARCHAR(128),
    oi_mcc_reservation_date DATE,
    oi_mcc_reservation_expiration_date DATE,
    oi_mcc_commitment_number VARCHAR(128),
    oi_mcc_underwriting_certification_deadline_date DATE,
    oi_mcc_delivered_by_date DATE,
    oi_unadjusted_monthly_total_amount NUMERIC(15, 2),
    oi_simple_year1_unadjusted_monthly_amount NUMERIC(15, 2),
    oi_simple_year2_unadjusted_monthly_amount NUMERIC(15, 2),
    oi_simple_year3_unadjusted_monthly_amount NUMERIC(15, 2)
);

CREATE TABLE history_octane.proposal
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    prp_pid BIGINT NOT NULL,
    prp_version INTEGER,
    prp_decision_lp_request_pid BIGINT,
    prp_decision_du_request_pid BIGINT,
    prp_proposal_type VARCHAR(128),
    prp_description VARCHAR(256),
    prp_doc_level_type VARCHAR(128),
    prp_loan_purpose_type VARCHAR(128),
    prp_name VARCHAR(128),
    prp_create_datetime TIMESTAMP,
    prp_effective_funding_date DATE,
    prp_estimated_funding_date DATE,
    prp_calculated_earliest_allowed_consummation_date DATE,
    prp_overridden_earliest_allowed_consummation_date DATE,
    prp_effective_earliest_allowed_consummation_date DATE,
    prp_earliest_allowed_consummation_date_override_reason TEXT,
    prp_last_requested_disclosure_date DATE,
    prp_closing_document_sign_datetime TIMESTAMP,
    prp_scheduled_closing_document_sign_datetime TIMESTAMP,
    prp_rescission_through_date DATE,
    prp_rescission_notification_date DATE,
    prp_rescission_notification_by VARCHAR(256),
    prp_rescission_notification_type VARCHAR(128),
    prp_rescission_effective_date DATE,
    prp_first_payment_date DATE,
    prp_first_payment_date_auto_compute BIT,
    prp_property_usage_type VARCHAR(128),
    prp_estimated_property_value_amount NUMERIC(15),
    prp_smart_charges_enabled BIT,
    prp_charges_updated_datetime TIMESTAMP,
    prp_smart_docs_enabled BIT,
    prp_docs_enabled_datetime TIMESTAMP,
    prp_request_fha_mip_refund_required BIT,
    prp_request_recording_fees_required BIT,
    prp_request_property_taxes_required BIT,
    prp_property_tax_request_error_messages TEXT,
    prp_fha_mip_refund_request_input_error BIT,
    prp_recording_fees_request_input_error BIT,
    prp_property_taxes_request_input_error BIT,
    prp_publish BIT,
    prp_publish_date DATE,
    prp_ipc_auto_compute BIT,
    prp_ipc_limit_percent NUMERIC(11, 9),
    prp_ipc_maximum_amount_allowed NUMERIC(15, 2),
    prp_ipc_amount NUMERIC(15, 2),
    prp_ipc_percent NUMERIC(11, 9),
    prp_ipc_financing_concession_amount NUMERIC(15, 2),
    prp_ipc_non_cash_concession_amount NUMERIC(15, 2),
    prp_sale_price_amount NUMERIC(15),
    prp_structure_type VARCHAR(128),
    prp_deal_pid BIGINT,
    prp_gfe_interest_rate_expiration_date DATE,
    prp_gfe_lock_duration_days INTEGER,
    prp_gfe_lock_before_settlement_days INTEGER,
    prp_proposal_expiration_date DATE,
    prp_uuts_master_contact_name VARCHAR(128),
    prp_uuts_master_contact_title VARCHAR(128),
    prp_uuts_master_office_phone VARCHAR(32),
    prp_uuts_master_office_phone_extension VARCHAR(16),
    prp_underwrite_risk_assessment_type VARCHAR(128),
    prp_underwriting_comments VARCHAR(1024),
    prp_reserves_auto_compute BIT,
    prp_reserves_amount NUMERIC(15, 2),
    prp_reserves_months INTEGER,
    prp_underwrite_disposition_type VARCHAR(128),
    prp_underwrite_publish_date DATE,
    prp_underwrite_expiration_date DATE,
    prp_usda_gsa_sam_exclusion VARCHAR(128),
    prp_usda_gsa_sam_checked_date DATE,
    prp_usda_rd_single_family_housing_type VARCHAR(128),
    prp_underwrite_method_type VARCHAR(128),
    prp_mi_required BIT,
    prp_decision_credit_score_borrower_pid BIGINT,
    prp_decision_credit_score INTEGER,
    prp_estimated_credit_score INTEGER,
    prp_effective_credit_score INTEGER,
    prp_mortgagee_builder_seller_relationship VARCHAR(128),
    prp_fha_prior_agency_case_id VARCHAR(32),
    prp_fha_prior_agency_case_endorsement_date DATE,
    prp_fha_refinance_authorization_number VARCHAR(16),
    prp_fha_refinance_authorization_expiration_date DATE,
    prp_fhac_refinance_authorization_messages TEXT,
    prp_fha_203k_consultant_id VARCHAR(8),
    prp_hud_fha_de_approval_type VARCHAR(128),
    prp_owner_occupancy_not_required BIT,
    prp_va_monthly_utilities_included VARCHAR(128),
    prp_va_maintenance_utilities_auto_compute BIT,
    prp_va_monthly_maintenance_utilities_amount NUMERIC(15, 2),
    prp_va_maintenance_utilities_per_square_feet_amount NUMERIC(15, 2),
    prp_household_size_count INTEGER,
    prp_va_past_credit_record_type VARCHAR(128),
    prp_va_meets_credit_standards VARCHAR(128),
    prp_va_prior_paid_in_full_loan_number VARCHAR(32),
    prp_note_date DATE,
    prp_security_instrument_type VARCHAR(128),
    prp_trustee_pid BIGINT,
    prp_trustee_name VARCHAR(128),
    prp_trustee_address_street1 VARCHAR(128),
    prp_trustee_address_street2 VARCHAR(128),
    prp_trustee_address_city VARCHAR(128),
    prp_trustee_address_state VARCHAR(128),
    prp_trustee_address_postal_code VARCHAR(128),
    prp_trustee_address_country VARCHAR(128),
    prp_trustee_mers_org_id VARCHAR(7),
    prp_trustee_phone_number VARCHAR(32),
    prp_fre_ctp_closing_feature_type VARCHAR(128),
    prp_fre_ctp_closing_type VARCHAR(128),
    prp_fre_ctp_first_payment_due_date DATE,
    prp_purchase_contract_date DATE,
    prp_purchase_contract_financing_contingency_date DATE,
    prp_purchase_contract_funding_date DATE,
    prp_effective_property_value_type VARCHAR(128),
    prp_effective_property_value_amount NUMERIC(15),
    prp_decision_appraised_value_amount NUMERIC(15),
    prp_fha_va_reasonable_value_amount NUMERIC(15),
    prp_cd_clear_date DATE,
    prp_disaster_declaration_check_date_type VARCHAR(128),
    prp_disaster_declaration_check_date DATE,
    prp_any_disaster_declaration_before_appraisal BIT,
    prp_any_disaster_declaration_after_appraisal BIT,
    prp_any_disaster_declaration BIT,
    prp_early_first_payment VARCHAR(128),
    prp_property_acquired_through_inheritance VARCHAR(128),
    prp_property_acquired_through_ancillary_relief VARCHAR(128),
    prp_delayed_financing_exception_guidelines_applicable BIT,
    prp_delayed_financing_exception_verified BIT,
    prp_effective_property_value_explanation_type VARCHAR(128),
    prp_taxes_escrowed VARCHAR(128),
    prp_flood_insurance_applicable VARCHAR(128),
    prp_windstorm_insurance_applicable VARCHAR(128),
    prp_earthquake_insurance_applicable VARCHAR(128),
    prp_arms_length VARCHAR(128),
    prp_fha_non_arms_length_ltv_exception_type VARCHAR(128),
    prp_fha_non_arms_length_ltv_exception_verified BIT,
    prp_escrow_cushion_months INTEGER,
    prp_escrow_cushion_months_auto_compute BIT,
    prp_fha_eligible_maximum_financing VARCHAR(128),
    prp_hazard_insurance_applicable VARCHAR(128),
    prp_property_repairs_required_type VARCHAR(128),
    prp_property_repairs_description VARCHAR(1024),
    prp_property_repairs_cost_amount NUMERIC(15, 2),
    prp_property_repairs_holdback_calc_type VARCHAR(128),
    prp_property_repairs_holdback_amount NUMERIC(15, 2),
    prp_property_repairs_holdback_payer_type VARCHAR(128),
    prp_property_repairs_holdback_administrator VARCHAR(128),
    prp_property_repairs_holdback_required_completion_date DATE,
    prp_property_repairs_completed_notification_date DATE,
    prp_property_repairs_inspection_ordered_date DATE,
    prp_property_repairs_inspection_completed_date DATE,
    prp_property_repairs_funds_released_contractor_date DATE,
    prp_anti_steering_lowest_rate_option_rate_percent NUMERIC(11, 9),
    prp_anti_steering_lowest_rate_option_fee_amount NUMERIC(15, 2),
    prp_anti_steering_lowest_rate_wo_neg_option_rate_percent NUMERIC(11, 9),
    prp_anti_steering_lowest_rate_wo_neg_option_fee_amount NUMERIC(15, 2),
    prp_anti_steering_lowest_cost_option_rate_percent NUMERIC(11, 9),
    prp_anti_steering_lowest_cost_option_fee_amount NUMERIC(15, 2),
    prp_initial_uw_submit_datetime TIMESTAMP,
    prp_va_notice_of_value_source_type VARCHAR(128),
    prp_va_notice_of_value_date DATE,
    prp_va_notice_of_value_estimated_reasonable_value_amount NUMERIC(15),
    prp_sar_significant_adjustments BIT,
    prp_separate_transaction_for_land_acquisition VARCHAR(128),
    prp_land_acquisition_transaction_date DATE,
    prp_land_acquisition_price NUMERIC(15),
    prp_cash_out_reason_home_improvement BIT,
    prp_cash_out_reason_debt_or_debt_consolidation BIT,
    prp_cash_out_reason_personal_use BIT,
    prp_cash_out_reason_future_investment_not_under_contract BIT,
    prp_cash_out_reason_future_investment_under_contract BIT,
    prp_cash_out_reason_other BIT,
    prp_cash_out_reason_other_text VARCHAR(128),
    prp_decision_veteran_borrower_pid BIGINT,
    prp_signed_closing_doc_received_datetime TIMESTAMP,
    prp_other_lender_requires_appraisal BIT,
    prp_other_lender_requires_appraisal_reason TEXT,
    prp_texas_equity_determination_datetime TIMESTAMP,
    prp_texas_equity_conversion_determination_datetime TIMESTAMP,
    prp_texas_equity_determination_datetime_override BIT,
    prp_texas_equity_determination_datetime_override_reason TEXT,
    prp_texas_equity_conversion_determination_datetime_override BIT,
    prp_texas_equity_conversion_determ_datetime_override_reason TEXT,
    prp_cema VARCHAR(128),
    prp_cema_borrower_savings NUMERIC(15, 2),
    prp_any_vesting_changes VARCHAR(128),
    prp_vesting_change_titleholder_added VARCHAR(128),
    prp_vesting_change_titleholder_removed VARCHAR(128),
    prp_vesting_change_titleholder_name_change VARCHAR(128),
    prp_deed_taxes_applicable BIT,
    prp_deed_taxes_applicable_explanation VARCHAR(1024),
    prp_deed_taxes_auto_compute BIT,
    prp_deed_taxes_auto_compute_override_reason VARCHAR(1024),
    prp_intent_to_proceed_date DATE,
    prp_intent_to_proceed_type VARCHAR(128),
    prp_intent_to_proceed_provider_unparsed_name VARCHAR(128),
    prp_intent_to_proceed_obtainer_unparsed_name VARCHAR(128),
    prp_cash_out_reason_student_loans BIT,
    prp_household_income_exclusive_edit BIT,
    prp_purchase_contract_received_date DATE,
    prp_down_payment_percent_mode BIT,
    prp_lender_escrow_loan_amount NUMERIC(15, 2),
    prp_underwrite_disposition_note VARCHAR(1024),
    prp_rescission_applicable BIT,
    prp_area_median_income NUMERIC(15, 2),
    prp_total_income_to_ami_ratio NUMERIC(14, 9),
    prp_construction_budget_url VARCHAR(1024),
    prp_construction_borrower_contribution_amount NUMERIC(15, 2),
    prp_construction_lot_ownership_status_type VARCHAR(128),
    prp_intent_to_proceed_provided BIT,
    prp_effective_signing_location_state VARCHAR(128),
    prp_effective_signing_location_city VARCHAR(128),
    prp_va_required_guaranty_amount NUMERIC(15, 2),
    prp_va_amount_used_to_calculate_maximum_guaranty NUMERIC(15, 2),
    prp_va_actual_guaranty_amount NUMERIC(15, 2),
    prp_last_corrective_disclosure_processed_datetime TIMESTAMP,
    prp_user_entered_note_date DATE,
    prp_effective_note_date DATE,
    prp_lender_escrow_loan_due_date DATE,
    prp_va_maximum_base_loan_amount NUMERIC(15, 2),
    prp_va_maximum_funding_fee_amount NUMERIC(15, 2),
    prp_va_maximum_total_loan_amount NUMERIC(15, 2),
    prp_va_required_cash_amount NUMERIC(15, 2),
    prp_va_guaranty_percent NUMERIC(11, 9),
    prp_gse_version_type VARCHAR(128),
    prp_minimum_household_income_amount NUMERIC(15, 2),
    prp_minimum_residual_income_amount NUMERIC(15, 2),
    prp_minimum_residual_income_auto_compute BIT,
    prp_financed_property_improvements_category_type VARCHAR(128),
    prp_adjusted_as_is_value_amount NUMERIC(15, 0),
    prp_after_improved_value_amount NUMERIC(15, 0)
);

CREATE TABLE history_octane.aus_request_number_ticker
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    arnt_pid BIGINT NOT NULL,
    arnt_version INTEGER,
    arnt_proposal_pid BIGINT,
    arnt_next_aus_request_number INTEGER
);

CREATE TABLE history_octane.construction_draw
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cd_pid BIGINT NOT NULL,
    cd_version INTEGER,
    cd_proposal_pid BIGINT,
    cd_construction_draw_type VARCHAR(128),
    cd_construction_draw_status_type VARCHAR(128),
    cd_scheduled_disbursement_date DATE,
    cd_confirmation_datetime TIMESTAMP,
    cd_inspection_datetime TIMESTAMP,
    cd_disbursement_datetime TIMESTAMP,
    cd_boarded_datetime TIMESTAMP,
    cd_voided_datetime TIMESTAMP,
    cd_construction_draw_notes VARCHAR(1024),
    cd_total_draw_amount NUMERIC(15, 2),
    cd_borrower_contribution_amount NUMERIC(15, 2),
    cd_lender_contribution_amount NUMERIC(15, 2),
    cd_construction_draw_number INTEGER,
    cd_construction_draw_disbursed_at_closing BIT
);

CREATE TABLE history_octane.construction_draw_number_ticker
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cdnt_pid BIGINT NOT NULL,
    cdnt_version INTEGER,
    cdnt_proposal_pid BIGINT,
    cdnt_next_construction_draw_number INTEGER
);

CREATE TABLE history_octane.credit_inquiry
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ci_pid BIGINT NOT NULL,
    ci_version INTEGER,
    ci_proposal_pid BIGINT,
    ci_credit_request_pid BIGINT,
    ci_inquiry_date DATE,
    ci_name VARCHAR(128),
    ci_address_street1 VARCHAR(128),
    ci_address_street2 VARCHAR(128),
    ci_address_city VARCHAR(128),
    ci_address_state VARCHAR(128),
    ci_address_postal_code VARCHAR(128),
    ci_address_country VARCHAR(128),
    ci_phone VARCHAR(32),
    ci_credit_inquiry_result_type VARCHAR(128),
    ci_credit_business_type VARCHAR(128),
    ci_credit_loan_type VARCHAR(128),
    ci_equifax_included BIT,
    ci_experian_included BIT,
    ci_trans_union_included BIT,
    ci_explanation_type VARCHAR(128),
    ci_explanation_info VARCHAR(1024),
    ci_credit_report_identifier VARCHAR(32),
    ci_inquiry_date_provided BIT
);

CREATE TABLE history_octane.borrower_credit_inquiry
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bci_pid BIGINT NOT NULL,
    bci_version INTEGER,
    bci_credit_inquiry_pid BIGINT,
    bci_borrower_pid BIGINT
);

CREATE TABLE history_octane.deal_snapshot
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    desn_pid BIGINT NOT NULL,
    desn_version INTEGER,
    desn_snapshot_proposal_pid BIGINT,
    desn_decision_appraisal_condition_type VARCHAR(128),
    desn_lender_lock_effective_expiration_datetime_main TIMESTAMP,
    desn_lender_lock_effective_expiration_datetime_piggyback TIMESTAMP,
    desn_lender_lock_status_type_main VARCHAR(128),
    desn_lender_lock_status_type_piggyback VARCHAR(128),
    desn_lender_lock_id_main VARCHAR(11),
    desn_lender_lock_id_piggyback VARCHAR(11),
    desn_preferred_vendor_used BIT,
    desn_lender_lock_start_datetime_main TIMESTAMP,
    desn_lender_lock_start_datetime_piggyback TIMESTAMP,
    desn_lender_lock_effective_duration_days_main INTEGER,
    desn_lender_lock_effective_duration_days_piggyback INTEGER,
    desn_lead_source_name VARCHAR(128),
    desn_appraisal_rush_request BIT,
    desn_appraisal_transfer_specified BIT,
    desn_borrower_requires_appraisal BIT,
    desn_lender_requires_appraisal BIT,
    desn_product_requires_appraisal BIT,
    desn_override_calculated_appraisal_required BIT,
    desn_decision_appraisal_appraised_value_amount NUMERIC(15),
    desn_appraisal_required BIT,
    desn_lender_concession_total_approved_amount_main NUMERIC(15, 2),
    desn_lender_concession_total_approved_amount_piggyback NUMERIC(15, 2),
    desn_relock_fee_gross_amount_main NUMERIC(15, 2),
    desn_relock_fee_gross_amount_piggyback NUMERIC(15, 2),
    desn_relock_fee_amount_less_concessions_main NUMERIC(15, 2),
    desn_relock_fee_amount_less_concessions_piggyback NUMERIC(15, 2),
    desn_relock_fee_amount_concessed_main NUMERIC(15, 2),
    desn_relock_fee_amount_concessed_piggyback NUMERIC(15, 2),
    desn_lock_extension_fee_gross_amount_main NUMERIC(15, 2),
    desn_lock_extension_fee_gross_amount_piggyback NUMERIC(15, 2),
    desn_lock_extension_fee_amount_less_concessions_main NUMERIC(15, 2),
    desn_lock_extension_fee_amount_less_concessions_piggyback NUMERIC(15, 2),
    desn_lock_extension_fee_amount_concessed_main NUMERIC(15, 2),
    desn_lock_extension_fee_amount_concessed_piggyback NUMERIC(15, 2),
    desn_lender_concession_remaining_amount_main NUMERIC(15, 2),
    desn_lender_concession_remaining_amount_piggyback NUMERIC(15, 2),
    desn_charge_credit_for_interest_rate_main NUMERIC(15, 2),
    desn_charge_credit_for_interest_rate_piggyback NUMERIC(15, 2)
);

CREATE TABLE history_octane.docusign_package
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dcsp_pid BIGINT NOT NULL,
    dcsp_version INTEGER,
    dcsp_proposal_pid BIGINT,
    dcsp_envelope_id VARCHAR(128),
    dcsp_esign_package_status_type VARCHAR(128),
    dcsp_status_datetime TIMESTAMP
);

CREATE TABLE history_octane.master_property_insurance
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    mpi_pid BIGINT NOT NULL,
    mpi_version INTEGER,
    mpi_proposal_pid BIGINT,
    mpi_master_property_insurance_type VARCHAR(128),
    mpi_policy_effective_date DATE,
    mpi_policy_expiration_date DATE,
    mpi_next_payment_date DATE,
    mpi_policy_property_coverage_amount NUMERIC(15),
    mpi_policy_liability_coverage_amount NUMERIC(15),
    mpi_policy_fidelity_coverage_amount NUMERIC(15),
    mpi_policy_deductible_amount NUMERIC(15),
    mpi_replacement_cost_amount NUMERIC(15),
    mpi_coinsurance VARCHAR(128),
    mpi_agreed_amount_endorsement VARCHAR(128),
    mpi_company_name VARCHAR(128),
    mpi_first_name VARCHAR(32),
    mpi_middle_name VARCHAR(32),
    mpi_last_name VARCHAR(32),
    mpi_name_suffix VARCHAR(32),
    mpi_title VARCHAR(128),
    mpi_email VARCHAR(256),
    mpi_mobile_phone VARCHAR(32),
    mpi_office_phone VARCHAR(32),
    mpi_office_phone_extension VARCHAR(16),
    mpi_fax VARCHAR(32),
    mpi_address_street1 VARCHAR(128),
    mpi_address_street2 VARCHAR(128),
    mpi_address_city VARCHAR(128),
    mpi_address_state VARCHAR(128),
    mpi_address_postal_code VARCHAR(128),
    mpi_address_country VARCHAR(16),
    mpi_policy_id VARCHAR(128)
);

CREATE TABLE history_octane.mi_integration_vendor_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    mivr_pid BIGINT NOT NULL,
    mivr_version INTEGER,
    mivr_proposal_pid BIGINT,
    mivr_create_datetime TIMESTAMP,
    mivr_mi_company_name_type VARCHAR(128),
    mivr_request_type VARCHAR(128),
    mivr_mi_payment_type VARCHAR(128),
    mivr_mi_payer_type VARCHAR(128),
    mivr_mi_coverage_percentage NUMERIC(11, 9),
    mivr_mi_upfront_percentage NUMERIC(11, 9),
    mivr_mi_initial_monthly_annual_percentage NUMERIC(11, 9),
    mivr_mi_renewal_monthly_annual_percentage NUMERIC(11, 9),
    mivr_mi_initial_duration_months INTEGER,
    mivr_mi_rate_quote_id VARCHAR(128),
    mivr_mi_certificate_id VARCHAR(128),
    mivr_request_status_type VARCHAR(128),
    mivr_request_time_to_completion_ms BIGINT,
    mivr_eligible_mi_products BIT,
    mivr_input_errors TEXT,
    mivr_service_errors TEXT,
    mivr_internal_errors TEXT,
    mivr_request_xml_pid BIGINT,
    mivr_response_xml_pid BIGINT,
    mivr_response_pdf_file_pid BIGINT
);

CREATE TABLE history_octane.loan
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    l_pid BIGINT NOT NULL,
    l_version INTEGER,
    l_proposal_pid BIGINT,
    l_offering_pid BIGINT,
    l_product_terms_pid BIGINT,
    l_mortgage_type VARCHAR(128),
    l_interest_only_type VARCHAR(128),
    l_buydown_schedule_type VARCHAR(128),
    l_prepay_penalty_schedule_type VARCHAR(128),
    l_aus_type VARCHAR(128),
    l_agency_case_id VARCHAR(32),
    l_arm_index_datetime TIMESTAMP,
    l_arm_index_current_value_percent NUMERIC(11, 9),
    l_arm_margin_percent NUMERIC(11, 9),
    l_base_loan_amount NUMERIC(17, 2),
    l_buydown_contributor_type VARCHAR(128),
    l_target_cash_out_amount NUMERIC(15, 2),
    l_heloc_maximum_balance_amount NUMERIC(15),
    l_note_rate_percent NUMERIC(11, 9),
    l_initial_note_rate_percent NUMERIC(11, 9),
    l_lien_priority_type VARCHAR(128),
    l_loan_amount NUMERIC(17, 2),
    l_financed_amount NUMERIC(15),
    l_ltv_ratio_percent NUMERIC(11, 9),
    l_base_loan_amount_ltv_ratio_percent NUMERIC(11, 9),
    l_mi_requirement_ltv_ratio_percent NUMERIC(11, 9),
    l_mi_auto_compute BIT,
    l_mi_no_mi_product BIT,
    l_mi_input_type VARCHAR(128),
    l_mi_company_name_type VARCHAR(128),
    l_mi_certificate_id VARCHAR(32),
    l_mi_premium_refundable_type VARCHAR(128),
    l_mi_initial_calculation_type VARCHAR(128),
    l_mi_renewal_calculation_type VARCHAR(128),
    l_mi_payer_type VARCHAR(128),
    l_mi_coverage_percent NUMERIC(11, 9),
    l_mi_ltv_cutoff_percent NUMERIC(11, 9),
    l_mi_midpoint_cutoff_required BIT,
    l_mi_required_monthly_payment_count INTEGER,
    l_mi_actual_monthly_payment_count INTEGER,
    l_mi_payment_type VARCHAR(128),
    l_mi_upfront_amount NUMERIC(15, 2),
    l_mi_upfront_percent NUMERIC(11, 9),
    l_mi_initial_monthly_payment_amount NUMERIC(15, 2),
    l_mi_renewal_monthly_payment_annual_percent NUMERIC(11, 9),
    l_mi_renewal_monthly_payment_amount NUMERIC(15, 2),
    l_mi_initial_duration_months INTEGER,
    l_mi_initial_monthly_payment_annual_percent NUMERIC(11, 9),
    l_mi_initial_calculated_rate_type VARCHAR(128),
    l_mi_renewal_calculated_rate_type VARCHAR(128),
    l_mi_base_rate_label VARCHAR(16000),
    l_mi_base_monthly_payment_annual_percent NUMERIC(11, 9),
    l_mi_base_upfront_percent NUMERIC(11, 9),
    l_mi_base_monthly_payment_amount NUMERIC(15, 2),
    l_mi_base_upfront_payment_amount NUMERIC(15, 2),
    l_qualifying_rate_type VARCHAR(128),
    l_qualifying_rate_input_percent NUMERIC(11, 9),
    l_qualifying_rate_percent NUMERIC(11, 9),
    l_fha_program_code_type VARCHAR(128),
    l_fha_principal_write_down BIT,
    l_fhac_case_assignment_messages TEXT,
    l_initial_pi_amount NUMERIC(15, 2),
    l_qualifying_pi_amount NUMERIC(15, 2),
    l_base_note_rate_percent NUMERIC(11, 9),
    l_base_arm_margin_percent NUMERIC(11, 9),
    l_base_price_percent NUMERIC(11, 9),
    l_lock_price_percent NUMERIC(11, 9),
    l_lock_duration_days INTEGER,
    l_lock_commitment_type VARCHAR(128),
    l_product_choice_datetime TIMESTAMP,
    l_hmda_purchaser_of_loan_2017_type VARCHAR(128),
    l_hmda_purchaser_of_loan_2018_type VARCHAR(128),
    l_texas_equity VARCHAR(128),
    l_texas_equity_auto VARCHAR(128),
    l_fnm_mbs_investor_contract_id VARCHAR(6),
    l_base_guaranty_fee_percent NUMERIC(11, 9),
    l_guaranty_fee_percent NUMERIC(11, 9),
    l_guaranty_fee_after_alternate_payment_method_percent NUMERIC(11, 9),
    l_fnm_investor_product_plan_id VARCHAR(5),
    l_uldd_loan_comment VARCHAR(60),
    l_principal_curtailment_amount NUMERIC(15, 2),
    l_agency_case_id_assigned_date DATE,
    l_mi_lender_paid_rate_adjustment_percent NUMERIC(11, 9),
    l_apr NUMERIC(11, 9),
    l_finance_charge_amount NUMERIC(15, 2),
    l_apor_percent NUMERIC(11, 9),
    l_apor_date DATE,
    l_hmda_rate_spread_percent NUMERIC(11, 9),
    l_hoepa_apr NUMERIC(11, 9),
    l_hoepa_rate_spread NUMERIC(11, 9),
    l_hoepa_fees_dollar_amount NUMERIC(15, 2),
    l_hmda_hoepa_status_type VARCHAR(128),
    l_rate_sheet_undiscounted_rate_percent NUMERIC(11, 9),
    l_effective_undiscounted_rate_percent NUMERIC(11, 9),
    l_last_unprocessed_changes_datetime TIMESTAMP,
    l_locked_price_change_percent NUMERIC(11, 9),
    l_interest_rate_fee_change_amount NUMERIC(15, 2),
    l_lender_concession_candidate BIT,
    l_durp_eligibility_opt_out BIT,
    l_qualified_mortgage_status_type VARCHAR(128),
    l_qualified_mortgage BIT,
    l_lqa_purchase_eligibility_type VARCHAR(128),
    l_student_loan_cash_out_refinance BIT,
    l_mi_rate_quote_id VARCHAR(128),
    l_mi_integration_vendor_request_pid BIGINT,
    l_secondary_clear_to_commit BIT,
    l_qm_eligible BIT,
    l_fha_endorsement_date DATE,
    l_va_guaranty_date DATE,
    l_usda_guarantee_date DATE,
    l_hpml BIT
);

CREATE TABLE history_octane.circumstance_change
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cc_pid BIGINT NOT NULL,
    cc_version INTEGER,
    cc_loan_pid BIGINT,
    cc_create_datetime TIMESTAMP,
    cc_circumstance_change_type VARCHAR(128),
    cc_source_unparsed_name VARCHAR(128),
    cc_expired BIT,
    cc_previous_formatted_value VARCHAR(1024),
    cc_to_formatted_value VARCHAR(1024),
    cc_expiration_date DATE,
    cc_system_added BIT
);

CREATE TABLE history_octane.ernst_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    enst_pid BIGINT NOT NULL,
    enst_version INTEGER,
    enst_loan_pid BIGINT,
    enst_response_deal_system_file_pid BIGINT,
    enst_auto_compute BIT,
    enst_create_datetime TIMESTAMP,
    enst_ernst_request_status_type VARCHAR(128),
    enst_error_messages TEXT,
    enst_state VARCHAR(2),
    enst_ernst_page_rec VARCHAR(16),
    enst_sub_jurisdiction_name VARCHAR(128),
    enst_torrens BIT,
    enst_security_instrument_request_type VARCHAR(128),
    enst_security_instrument_index_fee_requested BIT,
    enst_security_instrument_index_fee_grantor_count INTEGER,
    enst_security_instrument_index_fee_grantees_count INTEGER,
    enst_security_instrument_index_fee_surnames_count INTEGER,
    enst_security_instrument_index_fee_signatures_count INTEGER,
    enst_security_instrument_page_count INTEGER,
    enst_security_instrument_modification_amendment_page_count INTEGER,
    enst_security_instrument_page_breakdown VARCHAR(1024),
    enst_mortgage_new_debt_amount NUMERIC(15),
    enst_mortgage_original_debt_amount NUMERIC(15),
    enst_mortgage_unpaid_balance_amount NUMERIC(15, 2),
    enst_deed_request_type VARCHAR(128),
    enst_deed_index_fee_requested BIT,
    enst_deed_index_fee_grantor_count INTEGER,
    enst_deed_index_fee_grantees_count INTEGER,
    enst_deed_index_fee_surnames_count INTEGER,
    enst_deed_index_fee_signatures_count INTEGER,
    enst_deed_page_count INTEGER,
    enst_deed_page_breakdown VARCHAR(256),
    enst_deed_consideration_amount NUMERIC(15),
    enst_deed_amendment_page_count INTEGER,
    enst_include_assignment BIT,
    enst_assign_index_fee_requested BIT,
    enst_assign_index_fee_grantor_count INTEGER,
    enst_assign_index_fee_grantees_count INTEGER,
    enst_assign_index_fee_surnames_count INTEGER,
    enst_assign_index_fee_signatures_count INTEGER,
    enst_assignment_page_count_per_doc INTEGER,
    enst_assignment_count INTEGER,
    enst_include_poa BIT,
    enst_poa_page_count INTEGER,
    enst_include_subordination BIT,
    enst_subord_index_fee_requested BIT,
    enst_subord_index_fee_grantor_count INTEGER,
    enst_subord_index_fee_grantees_count INTEGER,
    enst_subord_index_fee_surnames_count INTEGER,
    enst_subord_index_fee_signatures_count INTEGER,
    enst_subordination_page_count_per_doc INTEGER,
    enst_subordination_count INTEGER,
    enst_loan_position_type VARCHAR(128)
);

CREATE TABLE history_octane.ernst_request_question
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    enstq_pid BIGINT NOT NULL,
    enstq_version INTEGER,
    enstq_ernst_request_pid BIGINT,
    enstq_ernst_question_id VARCHAR(8),
    enstq_question VARCHAR(1024),
    enstq_yes_no_answer BIT,
    enstq_answer VARCHAR(16)
);

CREATE TABLE history_octane.loan_beneficiary
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lb_pid BIGINT NOT NULL,
    lb_version INTEGER,
    lb_loan_pid BIGINT,
    lb_investor_pid BIGINT,
    lb_investor_loan_id VARCHAR(32),
    lb_from_date DATE,
    lb_through_date DATE,
    lb_current BIT,
    lb_initial BIT,
    lb_loan_benef_transfer_status_type VARCHAR(128),
    lb_loan_file_ship_date DATE,
    lb_approved_with_conditions_date DATE,
    lb_rejected_date DATE,
    lb_pending_wire_date DATE,
    lb_purchase_advice_amount NUMERIC(15, 2),
    lb_mers_mom BIT,
    lb_mers_transfer_status_type VARCHAR(128),
    lb_mers_transfer_creation_date DATE,
    lb_mers_transfer_override BIT,
    lb_mers_transfer_batch_pid BIGINT,
    lb_loan_file_courier_type VARCHAR(128),
    lb_loan_file_tracking_number VARCHAR(32),
    lb_collateral_courier_type VARCHAR(128),
    lb_collateral_tracking_number VARCHAR(32),
    lb_loan_file_delivery_method_type VARCHAR(128),
    lb_pool_id VARCHAR(32),
    lb_mbs_final_purchaser_investor_pid BIGINT,
    lb_early_funding VARCHAR(128),
    lb_early_funding_date DATE,
    lb_delivery_aus_type VARCHAR(128)
);

CREATE TABLE history_octane.loan_closing_doc
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lcd_pid BIGINT NOT NULL,
    lcd_version INTEGER,
    lcd_loan_pid BIGINT,
    lcd_dsi_websheet_number VARCHAR(16),
    lcd_dsi_doc_code VARCHAR(32),
    lcd_dsi_transaction_id VARCHAR(128),
    lcd_dsi_closing_document_status_type VARCHAR(128),
    lcd_dsi_fatal_messages TEXT,
    lcd_dsi_warning_messages TEXT,
    lcd_unsigned_closing_doc_deal_file_pid BIGINT
);

CREATE TABLE history_octane.loan_eligible_investor
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lei_pid BIGINT NOT NULL,
    lei_version INTEGER,
    lei_loan_pid BIGINT,
    lei_investor_pid BIGINT
);

CREATE TABLE history_octane.loan_funding
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lf_pid BIGINT NOT NULL,
    lf_version INTEGER,
    lf_loan_pid BIGINT,
    lf_interim_funder_pid BIGINT,
    lf_proposal_snapshot_pid BIGINT,
    lf_interim_funder_loan_id VARCHAR(32),
    lf_funding_status_type VARCHAR(128),
    lf_requested_date DATE,
    lf_confirmed_release_datetime TIMESTAMP,
    lf_wire_amount NUMERIC(15, 2),
    lf_interim_funder_fee_amount NUMERIC(15, 2),
    lf_release_wire_federal_reference_number VARCHAR(32),
    lf_disbursement_date DATE,
    lf_return_request_date DATE,
    lf_return_confirmed_date DATE,
    lf_funds_authorization_code VARCHAR(32),
    lf_scheduled_release_date DATE,
    lf_funds_authorized_datetime TIMESTAMP,
    lf_funding_date DATE,
    lf_collateral_sent_date DATE,
    lf_collateral_tracking_number VARCHAR(32),
    lf_collateral_courier_type VARCHAR(128),
    lf_post_wire_adjustment_amount NUMERIC(15, 2),
    lf_net_wire_amount NUMERIC(15, 2),
    lf_early_wire_charge_day_count INTEGER,
    lf_early_wire_daily_charge_amount NUMERIC(15, 2),
    lf_early_wire_total_charge_amount NUMERIC(15, 2),
    lf_scheduled_release_date_auto_compute BIT,
    lf_early_wire_request BIT
);

CREATE TABLE history_octane.loan_hedge
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lh_pid BIGINT NOT NULL,
    lh_version INTEGER,
    lh_loan_pid BIGINT,
    lh_update_datetime TIMESTAMP,
    lh_update_pending_datetime TIMESTAMP,
    lh_transaction_status_date DATE,
    lh_loan_number BIGINT,
    lh_product_code VARCHAR(128),
    lh_note_rate NUMERIC(11, 9),
    lh_loan_amount NUMERIC(17, 2),
    lh_lock_date TIMESTAMP,
    lh_buy_side_lock_expires_date TIMESTAMP,
    lh_lock_expiration_date TIMESTAMP,
    lh_secondary_cost NUMERIC(11, 9),
    lh_total_cost_basis NUMERIC(11, 9),
    lh_total_lender_margin NUMERIC(17, 9),
    lh_stage VARCHAR(128),
    lh_fund_date TIMESTAMP,
    lh_allocation_date TIMESTAMP,
    lh_estimated_fund_date DATE,
    lh_purchased_by_investor_date DATE,
    lh_commitment_number VARCHAR(32),
    lh_property_occupancy VARCHAR(128),
    lh_property_type VARCHAR(128),
    lh_property_type_supplemental VARCHAR(16),
    lh_property_state VARCHAR(128),
    lh_property_zip VARCHAR(128),
    lh_property_number_of_units INTEGER,
    lh_purchase_price NUMERIC(15),
    lh_appraised_value NUMERIC(15),
    lh_purpose VARCHAR(128),
    lh_refinance_type VARCHAR(128),
    lh_lien_position VARCHAR(128),
    lh_impounds VARCHAR(16),
    lh_buydown_type VARCHAR(128),
    lh_buydown VARCHAR(8),
    lh_ltv NUMERIC(11, 9),
    lh_original_ltv NUMERIC(11, 9),
    lh_cltv NUMERIC(11, 9),
    lh_original_cltv NUMERIC(11, 9),
    lh_effective_credit_score INTEGER,
    lh_doc_type VARCHAR(128),
    lh_debt_to_income NUMERIC(11, 9),
    lh_prepayment_penalty BIT,
    lh_prepayment_penalty_term INTEGER,
    lh_interest_only BIT,
    lh_lock_type VARCHAR(128),
    lh_lock_period INTEGER,
    lh_fees_collected_bps VARCHAR(8),
    lh_channel VARCHAR(32),
    lh_loan_officer VARCHAR(128),
    lh_branch VARCHAR(128),
    lh_broker VARCHAR(8),
    lh_correspondent VARCHAR(8),
    lh_origination_source VARCHAR(32),
    lh_investor VARCHAR(128),
    lh_investor_total_price NUMERIC(11, 9),
    lh_investor_base_price NUMERIC(11, 9),
    lh_investor_srp_paid VARCHAR(8),
    lh_investor_loan_number VARCHAR(32),
    lh_pmi BIT,
    lh_pmi_percent NUMERIC(11, 9),
    lh_mi_cert_number VARCHAR(128),
    lh_srp_paid VARCHAR(8),
    lh_discount_points VARCHAR(8),
    lh_date_docs_back VARCHAR(8),
    lh_note_date DATE,
    lh_close_date TIMESTAMP,
    lh_first_payment_date DATE,
    lh_last_payment_date DATE,
    lh_next_scheduled_payment_due_date VARCHAR(8),
    lh_scheduled_principal_and_interest NUMERIC(15, 2),
    lh_current_principal_and_interest NUMERIC(15, 2),
    lh_minimum_principal_and_interest NUMERIC(15, 2),
    lh_current_unpaid_principal_balance NUMERIC(17, 2),
    lh_original_interest_rate NUMERIC(11, 9),
    lh_maturity_date DATE,
    lh_amortization_term INTEGER,
    lh_yearly_payment_cap VARCHAR(8),
    lh_arm_margin NUMERIC(11, 9),
    lh_arm_adjustment_date DATE,
    lh_first_arm_period INTEGER,
    lh_first_arm_adjustment_cap NUMERIC(11, 9),
    lh_arm_life_floor NUMERIC(11, 9),
    lh_arm_life_ceiling NUMERIC(11, 9),
    lh_first_arm_payment_adjustment_date VARCHAR(8),
    lh_arm_period_after_first VARCHAR(8),
    lh_arm_adjustment_cap_after_first NUMERIC(11, 9),
    lh_first_payment_cap VARCHAR(8),
    lh_payment_cap_option VARCHAR(8),
    lh_neg_am_flag VARCHAR(8),
    lh_maximum_negative_amortization VARCHAR(8),
    lh_arm_convertible VARCHAR(8),
    lh_arm_index VARCHAR(8),
    lh_dual_loan_flag VARCHAR(8),
    lh_other_loan_number VARCHAR(8),
    lh_agency_extract_fields VARCHAR(8),
    lh_warehouse_bank VARCHAR(128),
    lh_wire_amount NUMERIC(15, 2),
    lh_credit_rating_agency_fields VARCHAR(8),
    lh_levels_fields VARCHAR(8),
    lh_data_fields VARCHAR(8),
    lh_loan_status VARCHAR(128),
    lh_suspense_yes_no VARCHAR(8),
    lh_loan_type VARCHAR(128),
    lh_hud_borr_paid_by_for_borr_other_amount VARCHAR(8),
    lh_fees_line_user_def_fee_one_borr VARCHAR(8),
    lh_uw_suspended_cleared_date VARCHAR(8),
    lh_underwriting_suspended_date VARCHAR(8),
    lh_line_orig_charge NUMERIC(15, 2),
    lh_amortization_type VARCHAR(32),
    lh_milestone VARCHAR(128),
    lh_msa VARCHAR(8),
    lh_county_code VARCHAR(8),
    lh_ship_date_to_investor DATE,
    lh_borrower_last_name VARCHAR(32),
    lh_purchase_advice_suspense_fee VARCHAR(8),
    lh_purchase_advice_early_delivery_amount VARCHAR(8),
    lh_purchase_advice_llpa VARCHAR(8),
    lh_purchase_advice_fmna VARCHAR(8),
    lh_purchase_advice_rp VARCHAR(8),
    lh_lock_info_relock_amount VARCHAR(8),
    lh_lock_info_loan_basis NUMERIC(11, 9),
    lh_lock_info_lock_request_fulfilled_date_time VARCHAR(8),
    lh_lock_info_rate_lock_request_rate_sheet_id VARCHAR(8),
    lh_current_status_change_date DATE,
    lh_aus_type VARCHAR(8),
    lh_buy_side_base_arm_margin VARCHAR(8),
    lh_uldd_poolid VARCHAR(32),
    lh_warehouse_co_name VARCHAR(128),
    lh_underwriting_investor_eligibility_wells_fargo VARCHAR(8),
    lh_underwriting_investor_eligibility_chase VARCHAR(8),
    lh_du_fail_reason VARCHAR(8),
    lh_lpmi_total_costs_on_lock VARCHAR(8),
    lh_lpmi_after_lock_required VARCHAR(8),
    lh_lpmi_after_lock_bps VARCHAR(8),
    lh_mi_company_name_type VARCHAR(128),
    lh_lpmi_frequency VARCHAR(128),
    lh_lpmi_estimated_amount_of_lender_paid_mi VARCHAR(8),
    lh_mortgage_insurance_premium_source_type VARCHAR(16),
    lh_loan_amount_repeat NUMERIC(17, 2),
    lh_product_code_repeat VARCHAR(128),
    lh_note_rate_repeat NUMERIC(11, 9),
    lh_loan_info_loan_id VARCHAR(8),
    lh_salable_loan VARCHAR(8),
    lh_sale_hold VARCHAR(8),
    lh_sale_hold_comments VARCHAR(8),
    lh_pf_disbursement_ledger_date DATE,
    lh_aus_eligibility VARCHAR(8),
    lh_texas_cash_out BIT,
    lh_acceptable_du BIT,
    lh_acceptable_lp BIT,
    lh_financed_property_count INTEGER,
    lh_payoff_primary_lien_holder_company VARCHAR(8),
    lh_payoff_junior_lien_holder_company VARCHAR(8),
    lh_base_loan_amount NUMERIC(17, 2),
    lh_funding_authorized VARCHAR(32),
    lh_credit_committee_fico_exception VARCHAR(8),
    lh_home_ready_eligibility VARCHAR(8),
    lh_home_ready_borr_acceptance VARCHAR(8),
    lh_home_ready_eligibility_review VARCHAR(8),
    lh_home_possible_eligibility VARCHAR(8),
    lh_home_possible_eligibility_review VARCHAR(8),
    lh_piw VARCHAR(8),
    lh_piw_fee VARCHAR(8),
    lh_uw_investor_eligibility_fnma VARCHAR(8),
    lh_uw_investor_eligibility_fhlmc VARCHAR(8),
    lh_appraisal_form VARCHAR(128),
    lh_ext_cos_total_amt VARCHAR(8),
    lh_fnmcu_risk_score VARCHAR(8),
    lh_borrower_income_verification VARCHAR(8),
    lh_co_borrower_income_verification VARCHAR(8),
    lh_day_one_income_verification_available VARCHAR(8),
    lh_subject_property_estimated_value NUMERIC(15),
    lh_transaction_status VARCHAR(128),
    lh_buy_status VARCHAR(128),
    lh_appraisal_exists BIT,
    lh_du_piw_eligible BIT,
    lh_lp_appraisal_waiver_eligible BIT,
    lh_borrower_first_name VARCHAR(32),
    lh_co_borrower_first_name VARCHAR(32),
    lh_co_borrower_last_name VARCHAR(32),
    lh_total_borrower_income NUMERIC(15, 2),
    lh_subject_property_city VARCHAR(128),
    lh_subject_property_county VARCHAR(128),
    lh_subject_property_zip VARCHAR(128),
    lh_borrower_decision_credit_score INTEGER,
    lh_co_borrower_decision_credit_score INTEGER,
    lh_underwriter_disposition VARCHAR(128),
    lh_underwrite_risk_assessment_type VARCHAR(128),
    lh_subject_property_address VARCHAR(1024),
    lh_original_lock_date TIMESTAMP,
    lh_original_lock_period INTEGER,
    lh_borrower_income_docs_required_count INTEGER,
    lh_borrower_income_docs_fulfilled_count INTEGER,
    lh_borrower_income_docs_approved_count INTEGER,
    lh_borrower_asset_docs_required_count INTEGER,
    lh_borrower_asset_docs_fulfilled_count INTEGER,
    lh_borrower_asset_docs_approved_count INTEGER,
    lh_borrower_credit_docs_required_count INTEGER,
    lh_borrower_credit_docs_fulfilled_count INTEGER,
    lh_borrower_credit_docs_approved_count INTEGER,
    lh_initial_uw_submit_date_time TIMESTAMP,
    lh_cd_clear_date DATE,
    lh_lender_concession_total_approved_amount NUMERIC(15, 2),
    lh_relock_fee_gross_amount NUMERIC(15, 2),
    lh_relock_fee_amount_less_concessions NUMERIC(15, 2),
    lh_relock_fee_amount_concessed NUMERIC(15, 2),
    lh_lock_extension_fee_gross_amount NUMERIC(15, 2),
    lh_lock_extension_fee_amount_less_concessions NUMERIC(15, 2),
    lh_lock_extension_fee_amount_concessed NUMERIC(15, 2),
    lh_lender_concession_remaining_amount NUMERIC(15, 2),
    lh_day_one_concessions NUMERIC(15, 2),
    lh_investor_lock_commitment_type VARCHAR(128),
    lh_signed_closing_doc_received_datetime TIMESTAMP,
    lh_geocoding_msa_code VARCHAR(32),
    lh_geocoding_state_code VARCHAR(32),
    lh_geocoding_county_code VARCHAR(32),
    lh_geocoding_census_tract VARCHAR(32),
    lh_tolerance_cure_amount NUMERIC(15, 2),
    lh_self_employed_flag BIT,
    lh_first_time_homebuyer BIT,
    lh_mortgage_insurance_lpmi_rate_adjustment NUMERIC(11, 9),
    lh_eligible_for_qm_status BIT,
    lh_safe_harbor_test_passed BIT,
    lh_hpml BIT,
    lh_hoepa VARCHAR(128),
    lh_funding_status VARCHAR(128),
    lh_early_funding VARCHAR(128),
    lh_early_funding_date DATE,
    lh_lqa_purchase_eligibility_type VARCHAR(128),
    lh_transferred_appraisal BIT,
    lh_appraisal_cu_risk_score VARCHAR(32),
    lh_mi_upfront_rate NUMERIC(11, 9),
    lh_loan_funding_requested_date DATE,
    lh_student_loan_cash_out BIT,
    lh_octane_high_balance BIT,
    lh_borrower_final_price NUMERIC(11, 9),
    lh_charge_credit_for_interest_rate NUMERIC(15, 2),
    lh_contract_processing_fee NUMERIC(15, 2),
    lh_escrow_holdback BIT,
    lh_appraiser_license_number VARCHAR(128),
    lh_mcc_present BIT,
    lh_grant_present BIT,
    lh_cema VARCHAR(128),
    lh_supplemental_margin_company NUMERIC(15, 2),
    lh_supplemental_margin_branch NUMERIC(15, 2),
    lh_supplemental_margin_total NUMERIC(15, 2),
    lh_concessions_renegotiations_amount NUMERIC(15, 2),
    lh_fund_source_type VARCHAR(128),
    lh_purchase_contract_funding_date DATE,
    lh_product_id VARCHAR(32),
    lh_community_second BIT,
    lh_current_taxes_and_insurance NUMERIC(15, 2),
    lh_multiple_applicants BIT,
    lh_community_second_liability BIT,
    lh_property_rights_type VARCHAR(128),
    lh_mbs_final_purchaser VARCHAR(128),
    lh_hmda_universal_loan_id VARCHAR(45),
    lh_lp_ace_eligible BIT,
    lh_family_advantage_product BIT,
    lh_effective_rate_sheet_datetime TIMESTAMP,
    lh_debt_to_income_excluding_mi NUMERIC(11, 9),
    lh_clear_to_commit BIT,
    lh_b2_first_name VARCHAR(32),
    lh_b2_last_name VARCHAR(32),
    lh_c2_first_name VARCHAR(32),
    lh_c2_last_name VARCHAR(32),
    lh_b3_first_name VARCHAR(32),
    lh_b3_last_name VARCHAR(32),
    lh_c3_first_name VARCHAR(32),
    lh_c3_last_name VARCHAR(32),
    lh_b4_first_name VARCHAR(32),
    lh_b4_last_name VARCHAR(32),
    lh_c4_first_name VARCHAR(32),
    lh_c4_last_name VARCHAR(32),
    lh_b5_first_name VARCHAR(32),
    lh_b5_last_name VARCHAR(32),
    lh_c5_first_name VARCHAR(32),
    lh_c5_last_name VARCHAR(32),
    lh_texas_home_equity_conversion BIT,
    lh_interest_only_heloc BIT,
    lh_interest_only_term_months INTEGER,
    lh_investor_lock_product_name VARCHAR(128),
    lh_investor_lock_product_id VARCHAR(32),
    lh_rebuttable_presumption BIT,
    lh_non_conforming BIT,
    lh_num_deal_updates_since_update_pending INTEGER,
    lh_borrower_engagement_percent NUMERIC(11, 9),
    lh_loan_create_date DATE,
    lh_high_balance_hit_percent NUMERIC(11, 9),
    lh_new_york_payup_percent NUMERIC(11, 9),
    lh_ship_date_to_custodian DATE,
    lh_lock_vintage DATE,
    lh_lock_series INTEGER,
    lh_investor_total NUMERIC(11, 9)
);

CREATE TABLE history_octane.loan_mi_rate_adjustment
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lmra_pid BIGINT NOT NULL,
    lmra_version INTEGER,
    lmra_loan_pid BIGINT,
    lmra_case_name VARCHAR(16000),
    lmra_rate_adjustment_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.loan_mi_surcharge
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lms_pid BIGINT NOT NULL,
    lms_version INTEGER,
    lms_loan_pid BIGINT,
    lms_criteria_html VARCHAR(16000),
    lms_government_surcharge_percent NUMERIC(11, 9),
    lms_government_surcharge_minimum_amount NUMERIC(15, 2)
);

CREATE TABLE history_octane.loan_price_add_on
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lpa_pid BIGINT NOT NULL,
    lpa_version INTEGER,
    lpa_loan_pid BIGINT,
    lpa_create_datetime TIMESTAMP,
    lpa_summary VARCHAR(16000),
    lpa_rate_adjustment_percent NUMERIC(11, 9),
    lpa_price_adjustment_percent NUMERIC(11, 9),
    lpa_arm_margin_adjustment_percent NUMERIC(11, 9),
    lpa_lock_add_on_type VARCHAR(128)
);

CREATE TABLE history_octane.loan_recording
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lr_pid BIGINT NOT NULL,
    lr_version INTEGER,
    lr_loan_pid BIGINT,
    lr_recording_date DATE,
    lr_recording_instrument_number VARCHAR(16),
    lr_recording_book_number VARCHAR(16),
    lr_recording_volume_number VARCHAR(16),
    lr_recording_page_number VARCHAR(16),
    lr_recording_jurisdiction_name VARCHAR(16),
    lr_recording_witness_unparsed_name VARCHAR(16),
    lr_re_recording BIT,
    lr_mers_registration_status_type VARCHAR(128),
    lr_mers_registration_date DATE,
    lr_mers_registration_errors TEXT,
    lr_mers_registration_warnings TEXT,
    lr_mers_transfer_errors TEXT,
    lr_mers_transfer_warnings TEXT
);

CREATE TABLE history_octane.loan_servicer
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lsv_pid BIGINT NOT NULL,
    lsv_version INTEGER,
    lsv_loan_pid BIGINT,
    lsv_investor_pid BIGINT,
    lsv_investor_loan_id VARCHAR(32),
    lsv_initial BIT,
    lsv_from_date DATE,
    lsv_servicing_data_sent_date DATE,
    lsv_retain_notification_date DATE,
    lsv_release_notification_date DATE,
    lsv_servicing_docs_sent_date DATE,
    lsv_mers_transfer_status_type VARCHAR(128),
    lsv_mers_transfer_creation_date DATE,
    lsv_mers_transfer_override BIT,
    lsv_mers_transfer_batch_pid BIGINT,
    lsv_loan_acquisition_scheduled_upb_amount NUMERIC(15, 2),
    lsv_last_paid_installment_due_date DATE,
    lsv_upb_amount NUMERIC(15, 2),
    lsv_delinquent_payments_over_past_twelve_months_count INTEGER
);

CREATE TABLE history_octane.lock_series
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lsr_pid BIGINT NOT NULL,
    lsr_loan_pid BIGINT,
    lsr_version INTEGER,
    lsr_vintage_date DATE,
    lsr_series_id INTEGER
);

CREATE TABLE history_octane.lender_lock_major
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    llmj_pid BIGINT NOT NULL,
    llmj_version INTEGER,
    llmj_major_version INTEGER,
    llmj_lender_lock_id VARCHAR(11),
    llmj_loan_pid BIGINT,
    llmj_lien_priority_type VARCHAR(128),
    llmj_account_pid BIGINT,
    llmj_lock_datetime TIMESTAMP,
    llmj_initial_duration_days INTEGER,
    llmj_initial_lock_expiration_datetime TIMESTAMP,
    llmj_requester_agent_type VARCHAR(128),
    llmj_requester_lender_user_pid BIGINT,
    llmj_requester_unparsed_name VARCHAR(128),
    llmj_request_datetime TIMESTAMP,
    llmj_confirm_datetime TIMESTAMP,
    llmj_confirm_lender_user_pid BIGINT,
    llmj_confirm_unparsed_name VARCHAR(128),
    llmj_void_request_datetime TIMESTAMP,
    llmj_void_request_lender_user_pid BIGINT,
    llmj_void_request_unparsed_name VARCHAR(128),
    llmj_void_datetime TIMESTAMP,
    llmj_void_lender_user_pid BIGINT,
    llmj_void_unparsed_name VARCHAR(128),
    llmj_cancel_datetime TIMESTAMP,
    llmj_cancel_lender_user_pid BIGINT,
    llmj_cancel_unparsed_name VARCHAR(128),
    llmj_auto_confirmed BIT,
    llmj_active BIT,
    llmj_relock_fee_percent NUMERIC(11, 9),
    llmj_notes VARCHAR(16000),
    llmj_lender_concession_approved_amount NUMERIC(15, 2),
    llmj_clear_extension_fees_relock BIT,
    llmj_pricing_duration_days INTEGER,
    llmj_pricing_commitment_type VARCHAR(128),
    llmj_expired_lock_successor BIT,
    llmj_lock_series_pid BIGINT
);

CREATE TABLE history_octane.bid_pool_lender_lock
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bpll_pid BIGINT NOT NULL,
    bpll_version INTEGER,
    bpll_bid_pool_pid BIGINT,
    bpll_lender_lock_major_pid BIGINT
);

CREATE TABLE history_octane.lender_concession_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lcr_pid BIGINT NOT NULL,
    lcr_version INTEGER,
    lcr_loan_pid BIGINT,
    lcr_lender_lock_major_pid BIGINT,
    lcr_requested_amount NUMERIC(15, 2),
    lcr_approved_amount NUMERIC(15, 2),
    lcr_requested_reason VARCHAR(128),
    lcr_approved_reason VARCHAR(128),
    lcr_requested_datetime TIMESTAMP,
    lcr_decision_datetime TIMESTAMP,
    lcr_decision_notes VARCHAR(1024),
    lcr_request_notes VARCHAR(1024),
    lcr_requester_lender_user_pid BIGINT,
    lcr_requester_unparsed_name VARCHAR(128),
    lcr_approver_lender_user_pid BIGINT,
    lcr_approver_unparsed_name VARCHAR(128),
    lcr_lender_concession_request_status_type VARCHAR(128),
    lcr_corporate_amount NUMERIC(15, 2)
);

CREATE TABLE history_octane.lender_lock_extension
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lle_pid BIGINT NOT NULL,
    lle_version INTEGER,
    lle_lender_lock_major_pid BIGINT,
    lle_creator_lender_user_pid BIGINT,
    lle_creator_unparsed_name VARCHAR(128),
    lle_requester_lender_user_pid BIGINT,
    lle_requester_unparsed_name VARCHAR(128),
    lle_requested_datetime TIMESTAMP,
    lle_confirm_lender_user_pid BIGINT,
    lle_confirm_unparsed_name VARCHAR(128),
    lle_confirm_datetime TIMESTAMP,
    lle_auto_confirmed BIT,
    lle_reject_lender_user_pid BIGINT,
    lle_reject_datetime TIMESTAMP,
    lle_reject_explanation VARCHAR(1024),
    lle_lock_extension_status_type VARCHAR(128),
    lle_extension_days INTEGER,
    lle_price_adjustment_percent NUMERIC(11, 9),
    lle_fee_applicable BIT
);

CREATE TABLE history_octane.lender_lock_minor
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    llmn_pid BIGINT NOT NULL,
    llmn_version INTEGER,
    llmn_lender_lock_major_pid BIGINT,
    llmn_minor_version INTEGER,
    llmn_latest_version BIT,
    llmn_lender_lock_status_type VARCHAR(128),
    llmn_create_datetime TIMESTAMP,
    llmn_creator_agent_type VARCHAR(128),
    llmn_creator_lender_user_pid BIGINT,
    llmn_creator_unparsed_name VARCHAR(128),
    llmn_effective_lock_expiration_datetime TIMESTAMP,
    llmn_effective_duration_days INTEGER,
    llmn_num_extensions INTEGER,
    llmn_investor_base_note_rate_percent NUMERIC(11, 9),
    llmn_investor_base_arm_margin_percent NUMERIC(11, 9),
    llmn_investor_base_price_percent NUMERIC(11, 9),
    llmn_lock_note_rate_percent NUMERIC(11, 9),
    llmn_lock_initial_note_rate_percent NUMERIC(11, 9),
    llmn_lock_arm_margin_percent NUMERIC(11, 9),
    llmn_lock_price_percent NUMERIC(11, 9),
    llmn_lock_price_raw_percent NUMERIC(11, 9),
    llmn_maximum_rebate_percent NUMERIC(11, 9),
    llmn_maximum_investor_price_percent NUMERIC(11, 9),
    llmn_maximum_investor_price_includes_srp BIT,
    llmn_created_historic_price_delta NUMERIC(11, 9),
    llmn_profit_table_name VARCHAR(128),
    llmn_total_profit_margin_percent NUMERIC(11, 9),
    llmn_base_note_rate_percent NUMERIC(11, 9),
    llmn_base_arm_margin_percent NUMERIC(11, 9),
    llmn_base_price_percent NUMERIC(11, 9),
    llmn_pricing_datetime TIMESTAMP,
    llmn_effective_rate_sheet_datetime TIMESTAMP,
    llmn_apor_date DATE,
    llmn_proposal_snapshot_pid BIGINT,
    llmn_loan_amount NUMERIC(17, 2),
    llmn_base_loan_amount NUMERIC(17, 2),
    llmn_lock_commitment_type VARCHAR(128),
    llmn_offering_pid BIGINT,
    llmn_product_terms_pid BIGINT,
    llmn_mortgage_type VARCHAR(128),
    llmn_interest_only_type VARCHAR(128),
    llmn_buydown_schedule_type VARCHAR(128),
    llmn_prepay_penalty_schedule_type VARCHAR(128),
    llmn_aus_type VARCHAR(128),
    llmn_high_balance_hit_percent NUMERIC(11, 9),
    llmn_new_york_payup_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.lender_lock_add_on
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lla_pid BIGINT NOT NULL,
    lla_version INTEGER,
    lla_lender_lock_minor_pid BIGINT,
    lla_lock_add_on_type VARCHAR(128),
    lla_investor_price_adjustment_percent NUMERIC(11, 9),
    lla_account_price_adjustment_percent NUMERIC(11, 9),
    lla_create_datetime TIMESTAMP,
    lla_creator_lender_user_pid BIGINT,
    lla_creator_unparsed_name VARCHAR(128),
    lla_summary VARCHAR(16000),
    lla_rate_adjustment_percent NUMERIC(11, 9),
    lla_price_adjustment_percent NUMERIC(11, 9),
    lla_arm_margin_adjustment_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.net_tangible_benefit
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ntb_pid BIGINT NOT NULL,
    ntb_version INTEGER,
    ntb_net_tangible_benefit_type VARCHAR(128),
    ntb_proposal_pid BIGINT
);

CREATE TABLE history_octane.obligation
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ob_pid BIGINT NOT NULL,
    ob_version INTEGER,
    ob_proposal_pid BIGINT,
    ob_obligation_type VARCHAR(128),
    ob_amount_input_type VARCHAR(128),
    ob_factor_percent NUMERIC(11, 9),
    ob_factor_percent_base_amount NUMERIC(15, 2),
    ob_annual_payment_amount NUMERIC(15, 2),
    ob_monthly_payment_amount NUMERIC(15, 2),
    ob_pte_annual_tax_installment_amount NUMERIC(15, 2),
    ob_pte_annual_preferred_tax_amount NUMERIC(15, 2),
    ob_pte_annual_homeowner_occupied_estimated_tax_amount NUMERIC(15, 2),
    ob_pte_annual_exemption_free_estimated_tax_amount NUMERIC(15, 2),
    ob_payment_date_1 DATE,
    ob_payment_date_2 DATE,
    ob_payment_date_3 DATE,
    ob_payment_date_4 DATE,
    ob_payment_date_5 DATE,
    ob_payment_date_6 DATE,
    ob_payment_amount_1 NUMERIC(15, 2),
    ob_payment_amount_2 NUMERIC(15, 2),
    ob_payment_amount_3 NUMERIC(15, 2),
    ob_payment_amount_4 NUMERIC(15, 2),
    ob_payment_amount_5 NUMERIC(15, 2),
    ob_payment_amount_6 NUMERIC(15, 2),
    ob_total_dated_payment_amount NUMERIC(15, 2),
    ob_vendor_first_name VARCHAR(32),
    ob_vendor_last_name VARCHAR(32),
    ob_vendor_middle_name VARCHAR(32),
    ob_vendor_name_suffix VARCHAR(32),
    ob_vendor_company_name VARCHAR(128),
    ob_vendor_title VARCHAR(128),
    ob_vendor_office_phone VARCHAR(32),
    ob_vendor_office_phone_extension VARCHAR(16),
    ob_vendor_mobile_phone VARCHAR(32),
    ob_vendor_email VARCHAR(256),
    ob_vendor_fax VARCHAR(32),
    ob_vendor_city VARCHAR(128),
    ob_vendor_country VARCHAR(128),
    ob_vendor_postal_code VARCHAR(128),
    ob_vendor_state VARCHAR(128),
    ob_vendor_street1 VARCHAR(128),
    ob_vendor_street2 VARCHAR(128),
    ob_vendor_reference_id VARCHAR(128),
    ob_name VARCHAR(128),
    ob_payment_amount_1_warning VARCHAR(1024),
    ob_payment_amount_2_warning VARCHAR(1024),
    ob_payment_amount_3_warning VARCHAR(1024),
    ob_payment_amount_4_warning VARCHAR(1024),
    ob_payment_amount_5_warning VARCHAR(1024),
    ob_payment_amount_6_warning VARCHAR(1024),
    ob_tax_auto_compute BIT,
    ob_policy_dwelling_coverage_amount NUMERIC(15),
    ob_policy_extended_coverage_amount NUMERIC(15),
    ob_policy_deductible_amount NUMERIC(15),
    ob_policy_effective_date DATE,
    ob_policy_expiration_date DATE,
    ob_escrow_waiver VARCHAR(128),
    ob_insurance_transferred BIT
);

CREATE TABLE history_octane.loan_charge
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lc_pid BIGINT NOT NULL,
    lc_version INTEGER,
    lc_proposal_pid BIGINT,
    lc_obligation_pid BIGINT,
    lc_account_charge_ordinal INTEGER,
    lc_loan_position_type VARCHAR(128),
    lc_charge_type VARCHAR(128),
    lc_name VARCHAR(128),
    lc_charge_payer_type VARCHAR(128),
    lc_charge_payee_type VARCHAR(128),
    lc_paid_by VARCHAR(128),
    lc_paid_to VARCHAR(128),
    lc_poc BIT,
    lc_poc_applicable BIT,
    lc_charge_wire_action_type VARCHAR(128),
    lc_reduction_amount NUMERIC(15),
    lc_apr BIT,
    lc_base_amount NUMERIC(16, 3),
    lc_configured_total_amount NUMERIC(15, 2),
    lc_total_amount NUMERIC(15, 2),
    lc_charge_input_type VARCHAR(128),
    lc_charge_input_type_base_amount NUMERIC(16, 3),
    lc_charge_input_type_percent NUMERIC(11, 9),
    lc_charge_input_type_currency NUMERIC(16, 3),
    lc_hud_section_number VARCHAR(16),
    lc_hud_line_number VARCHAR(16),
    lc_user_defined BIT,
    lc_months_auto_compute BIT,
    lc_months INTEGER,
    lc_per_diem_amount NUMERIC(15, 2),
    lc_per_diem_rate NUMERIC(11, 9),
    lc_days INTEGER,
    lc_financed BIT,
    lc_financed_auto_compute BIT,
    lc_financed_amount NUMERIC(15),
    lc_auto_compute BIT,
    lc_charge_source_type VARCHAR(128),
    lc_obligation_charge_input_type VARCHAR(128),
    lc_from_date DATE,
    lc_through_date DATE,
    lc_smart_charge_config_warning VARCHAR(1024),
    lc_reduction_amount_warning VARCHAR(1024),
    lc_advance_amount_warning VARCHAR(1024),
    lc_fha_mip_refund_warning VARCHAR(1024),
    lc_aggregate_adjustment_compute_warning VARCHAR(1024),
    lc_advance_obligation_compute_warning VARCHAR(1024),
    lc_escrow_obligation_compute_warning VARCHAR(1024),
    lc_excess_financing_concession_warning VARCHAR(1024),
    lc_amount_exceeds_cap_warning VARCHAR(1024),
    lc_subtract_lenders_title_insurance_amount BIT,
    lc_lender_insurance_exceeds_owner_insurance_warning VARCHAR(1024),
    lc_manual_circumstance_change_type_1 VARCHAR(128),
    lc_manual_circumstance_change_type_2 VARCHAR(128),
    lc_configured_charge_payer_type VARCHAR(128),
    lc_configured_charge_payee_type VARCHAR(128),
    lc_configured_paid_by VARCHAR(128),
    lc_configured_paid_to VARCHAR(128),
    lc_configured_poc BIT,
    lc_configured_financed BIT,
    lc_charge_wire_action_auto_compute BIT
);

CREATE TABLE history_octane.place
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pl_pid BIGINT NOT NULL,
    pl_version INTEGER,
    pl_proposal_pid BIGINT,
    pl_subject_property BIT,
    pl_acquisition_date DATE,
    pl_construction_improvement_costs_amount NUMERIC(15),
    pl_financed_units_count INTEGER,
    pl_unit_count INTEGER,
    pl_land_estimated_value_amount NUMERIC(15),
    pl_land_original_cost_amount NUMERIC(15),
    pl_leasehold_expiration_date DATE,
    pl_legal_description_type VARCHAR(128),
    pl_legal_description VARCHAR(32000),
    pl_property_tax_id VARCHAR(32),
    pl_legal_lot VARCHAR(32),
    pl_legal_block VARCHAR(32),
    pl_legal_section VARCHAR(32),
    pl_project_name VARCHAR(128),
    pl_cpm_project_id VARCHAR(128),
    pl_acquisition_cost_amount NUMERIC(15),
    pl_county_pid BIGINT,
    pl_sub_jurisdiction_name VARCHAR(128),
    pl_recording_district_name VARCHAR(128),
    pl_project_classification_type VARCHAR(128),
    pl_property_category_type VARCHAR(128),
    pl_property_rights_type VARCHAR(128),
    pl_refinance_total_improvement_costs_amount NUMERIC(15),
    pl_refinance_improvements_type VARCHAR(128),
    pl_refinance_proposed_improvements_description VARCHAR(32),
    pl_structure_built_year INTEGER,
    pl_structure_built_month INTEGER,
    pl_title_manner_held_type VARCHAR(128),
    pl_title_manner_held_description VARCHAR(1024),
    pl_building_status_type VARCHAR(128),
    pl_construction_conversion VARCHAR(128),
    pl_native_american_lands_type VARCHAR(128),
    pl_community_land_trust BIT,
    pl_inclusionary_zoning BIT,
    pl_unique_dwelling_type VARCHAR(128),
    pl_living_unit_count INTEGER,
    pl_project_design_type VARCHAR(128),
    pl_city VARCHAR(128),
    pl_country VARCHAR(128),
    pl_postal_code VARCHAR(128),
    pl_state VARCHAR(128),
    pl_street1 VARCHAR(128),
    pl_street2 VARCHAR(128),
    pl_street_tbd BIT,
    pl_landlord_first_name VARCHAR(32),
    pl_landlord_last_name VARCHAR(32),
    pl_landlord_middle_name VARCHAR(32),
    pl_landlord_name_suffix VARCHAR(32),
    pl_landlord_company_name VARCHAR(128),
    pl_landlord_title VARCHAR(128),
    pl_landlord_office_phone VARCHAR(32),
    pl_landlord_office_phone_extension VARCHAR(16),
    pl_landlord_mobile_phone VARCHAR(32),
    pl_landlord_email VARCHAR(256),
    pl_landlord_fax VARCHAR(32),
    pl_landlord_city VARCHAR(128),
    pl_landlord_country VARCHAR(128),
    pl_landlord_postal_code VARCHAR(128),
    pl_landlord_state VARCHAR(128),
    pl_landlord_street1 VARCHAR(128),
    pl_landlord_street2 VARCHAR(128),
    pl_management_first_name VARCHAR(32),
    pl_management_last_name VARCHAR(32),
    pl_management_middle_name VARCHAR(32),
    pl_management_name_suffix VARCHAR(32),
    pl_management_company_name VARCHAR(128),
    pl_management_title VARCHAR(128),
    pl_management_office_phone VARCHAR(32),
    pl_management_office_phone_extension VARCHAR(16),
    pl_management_mobile_phone VARCHAR(32),
    pl_management_email VARCHAR(256),
    pl_management_fax VARCHAR(32),
    pl_management_city VARCHAR(128),
    pl_management_country VARCHAR(128),
    pl_management_postal_code VARCHAR(128),
    pl_management_state VARCHAR(128),
    pl_management_street1 VARCHAR(128),
    pl_management_street2 VARCHAR(128),
    pl_property_insurance_amount_input_type VARCHAR(128),
    pl_property_tax_amount_input_type VARCHAR(128),
    pl_annual_property_insurance_amount NUMERIC(15, 2),
    pl_annual_property_tax_amount NUMERIC(15, 2),
    pl_monthly_property_insurance_amount NUMERIC(15, 2),
    pl_monthly_hoa_amount NUMERIC(15, 2),
    pl_monthly_mi_amount NUMERIC(15, 2),
    pl_monthly_property_tax_amount NUMERIC(15, 2),
    pl_monthly_lease_ground_rent_amount NUMERIC(15, 2),
    pl_monthly_rent_amount NUMERIC(15, 2),
    pl_monthly_obligation_amount NUMERIC(15, 2),
    pl_use_proposed_property_usage BIT,
    pl_property_usage_type VARCHAR(128),
    pl_property_value_amount NUMERIC(15),
    pl_reo_disposition_status_type VARCHAR(128),
    pl_auto_geocode BIT,
    pl_auto_geocode_exception VARCHAR(1024),
    pl_msa_code VARCHAR(32),
    pl_state_fips VARCHAR(32),
    pl_county_fips VARCHAR(32),
    pl_census_tract VARCHAR(32),
    pl_mh_make VARCHAR(32),
    pl_mh_model VARCHAR(32),
    pl_mh_length INTEGER,
    pl_mh_width INTEGER,
    pl_mh_manufacturer VARCHAR(32),
    pl_mh_serial_number VARCHAR(128),
    pl_mh_hud_label_number VARCHAR(128),
    pl_mh_certificate_of_title_issued VARCHAR(128),
    pl_mh_certificate_of_title_number VARCHAR(32),
    pl_mh_certificate_of_title_type VARCHAR(128),
    pl_mh_loan_purpose_type VARCHAR(128),
    pl_mh_anchored BIT,
    pl_coop_company_name VARCHAR(128),
    pl_coop_building_name VARCHAR(128),
    pl_coop_vacant_units INTEGER,
    pl_coop_proprietary_lease_date DATE,
    pl_coop_assignment_lease_date DATE,
    pl_coop_existing_company_laws_state VARCHAR(128),
    pl_coop_shares_being_purchased INTEGER,
    pl_coop_attorney_in_fact VARCHAR(128),
    pl_coop_stock_certificate_number VARCHAR(32),
    pl_coop_apartment_unit VARCHAR(32),
    pl_rental BIT,
    pl_underwriter_comments VARCHAR(1024),
    pl_lava_zone_type VARCHAR(128),
    pl_neighborhood_location_type VARCHAR(128),
    pl_site_area NUMERIC(15),
    pl_hud_reo VARCHAR(128),
    pl_energy_improvement_replacement_major_system BIT,
    pl_energy_improvement_insulation_sealant BIT,
    pl_energy_improvement_installation_solar BIT,
    pl_energy_improvement_addition_new_feature BIT,
    pl_energy_improvement_other BIT,
    pl_energy_related_repairs_or_improvements_amount NUMERIC(15, 2),
    pl_refinance_general_improvements_amount NUMERIC(15),
    pl_va_guaranteed_reo VARCHAR(128),
    pl_va_loan_date DATE,
    pl_gross_building_area_square_feet INTEGER,
    pl_project_dwelling_units_sold_count INTEGER,
    pl_prior_owners_title BIT,
    pl_prior_owners_title_policy_amount NUMERIC(15, 2),
    pl_prior_owners_title_policy_effective_date DATE,
    pl_prior_lenders_title BIT,
    pl_prior_lenders_title_policy_amount NUMERIC(15, 2),
    pl_prior_lenders_title_policy_effective_date DATE,
    pl_bedroom_count_unit_1 INTEGER,
    pl_bedroom_count_unit_2 INTEGER,
    pl_bedroom_count_unit_3 INTEGER,
    pl_bedroom_count_unit_4 INTEGER,
    pl_rent_amount_unit_1 NUMERIC(15, 2),
    pl_rent_amount_unit_2 NUMERIC(15, 2),
    pl_rent_amount_unit_3 NUMERIC(15, 2),
    pl_rent_amount_unit_4 NUMERIC(15, 2),
    pl_listed_for_sale_in_last_6_months VARCHAR(128),
    pl_property_in_borrower_trust VARCHAR(128),
    pl_road_type VARCHAR(128),
    pl_water_type VARCHAR(128),
    pl_sanitation_type VARCHAR(128),
    pl_survey_required VARCHAR(128),
    pl_solar_panels_type VARCHAR(128),
    pl_power_purchase_agreement VARCHAR(128),
    pl_solar_panel_provider_name VARCHAR(128),
    pl_seller_acquired_date DATE,
    pl_seller_original_cost_amount NUMERIC(15),
    pl_remaining_economic_life_years INTEGER,
    pl_bathroom_count_unit_1 INTEGER,
    pl_bathroom_count_unit_2 INTEGER,
    pl_bathroom_count_unit_3 INTEGER,
    pl_bathroom_count_unit_4 INTEGER,
    pl_total_room_count_unit_1 INTEGER,
    pl_total_room_count_unit_2 INTEGER,
    pl_total_room_count_unit_3 INTEGER,
    pl_total_room_count_unit_4 INTEGER,
    pl_gross_living_area_square_feet_unit_1 INTEGER,
    pl_gross_living_area_square_feet_unit_2 INTEGER,
    pl_gross_living_area_square_feet_unit_3 INTEGER,
    pl_gross_living_area_square_feet_unit_4 INTEGER,
    pl_mh_leasehold__property_interest_type VARCHAR(128),
    pl_tribe_name VARCHAR(128),
    pl_leasehold_begin_date DATE,
    pl_lease_number VARCHAR(128),
    pl_property_inspection_required BIT,
    pl_hvac_inspection_required BIT,
    pl_pest_inspection_required BIT,
    pl_radon_inspection_required BIT,
    pl_septic_inspection_required BIT,
    pl_water_well_inspection_required BIT,
    pl_structural_inspection_required BIT,
    pl_pest_inspection_required_auto_compute BIT,
    pl_management_agent_federal_tax_id VARCHAR(32),
    pl_mh_manufacturer_street_1 VARCHAR(128),
    pl_mh_manufacturer_street_2 VARCHAR(128),
    pl_mh_manufacturer_city VARCHAR(128),
    pl_mh_manufacturer_state VARCHAR(128),
    pl_mh_manufacturer_postal_code VARCHAR(128),
    pl_mh_manufacturer_phone VARCHAR(32),
    pl_mh_manufacturer_phone_extension VARCHAR(16),
    pl_recording_city_name VARCHAR(128),
    pl_abbreviated_legal_description VARCHAR(1024),
    pl_geocode_service_disabled BIT,
    pl_vesting_confirmed BIT,
    pl_previous_title_manner_held_description VARCHAR(1024),
    pl_legal_lot_na BIT,
    pl_legal_block_na BIT,
    pl_legal_section_na BIT,
    pl_legal_description_confirmed BIT,
    pl_lead_inspection_required VARCHAR(128),
    pl_calculated_lead_inspection_required VARCHAR(128),
    pl_geocode_system_error BIT,
    pl_mixed_use VARCHAR(128),
    pl_mixed_use_verified BIT,
    pl_mixed_use_area_square_feet INTEGER,
    pl_mixed_use_area_square_feet_verified BIT,
    pl_mixed_use_area_percent NUMERIC(11, 9),
    pl_trust_classification_type VARCHAR(128)
);

CREATE TABLE history_octane.borrower_reo
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    breo_pid BIGINT NOT NULL,
    breo_version INTEGER,
    breo_borrower_pid BIGINT,
    breo_place_pid BIGINT,
    breo_ownership_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.borrower_residence
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bres_pid BIGINT NOT NULL,
    bres_version INTEGER,
    bres_borrower_pid BIGINT,
    bres_place_pid BIGINT,
    bres_current BIT,
    bres_borrower_residency_basis_type VARCHAR(128),
    bres_from_date DATE,
    bres_through_date DATE,
    bres_verification_required BIT
);

CREATE TABLE history_octane.borrower_tax_filing
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    btf_pid BIGINT NOT NULL,
    btf_version INTEGER,
    btf_borrower_pid BIGINT,
    btf_place_pid BIGINT,
    btf_tax_filing_status_type VARCHAR(128),
    btf_year INTEGER,
    btf_joint_is_coborrower BIT,
    btf_joint_filer_first_name VARCHAR(32),
    btf_joint_filer_middle_name VARCHAR(32),
    btf_joint_filer_last_name VARCHAR(32),
    btf_joint_filer_suffix VARCHAR(32)
);

CREATE TABLE history_octane.borrower_va
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bva_pid BIGINT NOT NULL,
    bva_version INTEGER,
    bva_borrower_pid BIGINT,
    bva_veteran_status_type VARCHAR(128),
    bva_va_funding_fee_exempt BIT,
    bva_subsequent_use BIT,
    bva_claim_folder_number VARCHAR(32),
    bva_benefit_related_indebtedness VARCHAR(128),
    bva_available_entitlement_amount NUMERIC(15, 2),
    bva_va_entitlement_code_type VARCHAR(128),
    bva_disability_benefits_prior_to_discharge VARCHAR(128),
    bva_active_duty_following_separation VARCHAR(128),
    bva_separated_from_service_due_to_disability VARCHAR(128),
    bva_disability_payments VARCHAR(128),
    bva_surviving_spouse_receiving_dic_payments VARCHAR(128),
    bva_surviving_spouse_dic_claim_number VARCHAR(128),
    bva_deceased_spouse_first_name VARCHAR(32),
    bva_deceased_spouse_middle_name VARCHAR(32),
    bva_deceased_spouse_last_name VARCHAR(32),
    bva_deceased_spouse_name_suffix VARCHAR(32),
    bva_deceased_spouse_claim_folder_number VARCHAR(32),
    bva_deceased_spouse_claim_folder_location VARCHAR(32),
    bva_deceased_spouse_service_number VARCHAR(32),
    bva_deceased_spouse_military_branch_type VARCHAR(128),
    bva_deceased_spouse_birth_date DATE,
    bva_deceased_spouse_death_date DATE,
    bva_deceased_spouse_service_from_date_1 DATE,
    bva_deceased_spouse_service_through_date_1 DATE,
    bva_deceased_spouse_service_from_date_2 DATE,
    bva_deceased_spouse_service_through_date_2 DATE,
    bva_deceased_spouse_service_from_date_3 DATE,
    bva_deceased_spouse_service_through_date_3 DATE,
    bva_previously_applied_for_eligibility VARCHAR(128),
    bva_previously_secured_center_type VARCHAR(128),
    bva_previously_applied_for_eligibility_center_type VARCHAR(128),
    bva_previously_received_certificate_of_eligibility_center_type VARCHAR(128),
    bva_previously_received_certificate_of_eligibility VARCHAR(128),
    bva_previous_loan_address_street1 VARCHAR(128),
    bva_previous_loan_address_street2 VARCHAR(128),
    bva_previous_loan_address_city VARCHAR(128),
    bva_previous_loan_address_state VARCHAR(128),
    bva_previous_loan_address_postal_code VARCHAR(128),
    bva_previous_loan_number VARCHAR(128),
    bva_previous_loan_month INTEGER,
    bva_previous_loan_year INTEGER,
    bva_veteran_poa_verification_date DATE,
    bva_relative_first_name VARCHAR(32),
    bva_relative_middle_name VARCHAR(32),
    bva_relative_last_name VARCHAR(32),
    bva_relative_name_suffix VARCHAR(32),
    bva_relative_address_street1 VARCHAR(128),
    bva_relative_address_street2 VARCHAR(128),
    bva_relative_address_city VARCHAR(128),
    bva_relative_address_state VARCHAR(128),
    bva_relative_address_postal_code VARCHAR(128),
    bva_relative_phone_number VARCHAR(32),
    bva_va_relative_relationship_type VARCHAR(128),
    bva_va_relative_relationship_other_description VARCHAR(32),
    bva_service_related_disability BIT,
    bva_purple_heart_recipient BIT,
    bva_va_funding_fee_exemption_verified BIT,
    bva_entitlement_charged_amount NUMERIC(15, 2),
    bva_used_entitlement_amount NUMERIC(15, 2),
    bva_va_entitlement_restoration_type VARCHAR(128),
    bva_previous_use_place_pid BIGINT,
    bva_entitled_to_military_based_facilities VARCHAR(128),
    bva_one_hundred_percent_disabled_veteran VARCHAR(128),
    bva_medal_of_honor_recipient BIT
);

CREATE TABLE history_octane.profit_margin_detail
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pmd_pid BIGINT NOT NULL,
    pmd_version INTEGER,
    pmd_lender_lock_minor_pid BIGINT,
    pmd_profit_margin_type VARCHAR(128),
    pmd_description VARCHAR(128),
    pmd_percent NUMERIC(11, 9),
    pmd_dollars NUMERIC(15, 2),
    pmd_adjustment_description VARCHAR(16000)
);

CREATE TABLE history_octane.proposal_contractor
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pctr_pid BIGINT NOT NULL,
    pctr_version INTEGER,
    pctr_proposal_pid BIGINT,
    pctr_contractor_pid BIGINT
);

CREATE TABLE history_octane.construction_cost
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    coc_pid BIGINT NOT NULL,
    coc_version INTEGER,
    coc_proposal_pid BIGINT,
    coc_construction_cost_category_type VARCHAR(128),
    coc_construction_cost_funding_type VARCHAR(128),
    coc_construction_cost_status_type VARCHAR(128),
    coc_construction_cost_payee_type VARCHAR(128),
    coc_create_datetime TIMESTAMP,
    coc_construction_cost_amount NUMERIC(15, 2),
    coc_construction_cost_notes VARCHAR(1024),
    coc_contractor_pid BIGINT,
    coc_proposal_contractor_pid BIGINT,
    coc_payee VARCHAR(128)
);

CREATE TABLE history_octane.construction_draw_item
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    cdi_pid BIGINT NOT NULL,
    cdi_version INTEGER,
    cdi_proposal_pid BIGINT,
    cdi_construction_cost_pid BIGINT,
    cdi_construction_draw_pid BIGINT,
    cdi_construction_draw_item_amount NUMERIC(15, 2),
    cdi_construction_draw_item_borrower_contribution_amount NUMERIC(15, 2),
    cdi_construction_draw_item_lender_contribution_amount NUMERIC(15, 2)
);

CREATE TABLE history_octane.proposal_doc_set
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    prpds_pid BIGINT NOT NULL,
    prpds_version INTEGER,
    prpds_proposal_pid BIGINT,
    prpds_smart_doc_set_pid BIGINT,
    prpds_create_datetime TIMESTAMP,
    prpds_delivered_or_mailed_datetime TIMESTAMP,
    prpds_creator_agent_type VARCHAR(128),
    prpds_creator_lender_user_pid BIGINT,
    prpds_creator_unparsed_name VARCHAR(128),
    prpds_requested_datetime TIMESTAMP,
    prpds_requester_agent_type VARCHAR(128),
    prpds_requester_lender_user_pid BIGINT,
    prpds_requester_unparsed_name VARCHAR(128),
    prpds_signed_date DATE,
    prpds_delivery_method_type VARCHAR(128),
    prpds_tracking_number VARCHAR(32),
    prpds_affects_earliest_allowed_consummation_date BIT,
    prpds_name VARCHAR(128),
    prpds_docusign_package_pid BIGINT,
    prpds_esign_vendor_type VARCHAR(128),
    prpds_esign_evidence_deal_file_pid BIGINT,
    prpds_doc_package_status_type VARCHAR(128),
    prpds_canceled_reason_type VARCHAR(128),
    prpds_canceled_datetime TIMESTAMP,
    prpds_canceler_agent_type VARCHAR(128),
    prpds_canceler_lender_user_pid BIGINT,
    prpds_canceler_unparsed_name VARCHAR(128),
    prpds_canceled_reason VARCHAR(16000),
    prpds_proposal_doc_set_id INTEGER
);

CREATE TABLE history_octane.proposal_doc_set_id_ticker
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pdstk_pid BIGINT NOT NULL,
    pdstk_version INTEGER,
    pdstk_proposal_pid BIGINT,
    pdstk_smart_doc_set_pid BIGINT,
    pdstk_next_proposal_doc_set_id INTEGER
);

CREATE TABLE history_octane.proposal_doc_set_signer
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    prpdss_pid BIGINT NOT NULL,
    prpdss_version INTEGER,
    prpdss_proposal_doc_set_pid BIGINT,
    prpdss_deal_signer_pid BIGINT,
    prpdss_esign_complete BIT,
    prpdss_received_datetime TIMESTAMP,
    prpdss_signed_datetime TIMESTAMP
);

CREATE TABLE history_octane.proposal_doc_set_snapshot
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    prpdssn_pid BIGINT NOT NULL,
    prpdssn_version INTEGER,
    prpdssn_proposal_doc_set_pid BIGINT,
    prpdssn_snapshot_proposal_pid BIGINT
);

CREATE TABLE history_octane.proposal_engagement
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    prpe_pid BIGINT NOT NULL,
    prpe_version INTEGER,
    prpe_proposal_pid BIGINT,
    prpe_borrower_engagement_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.proposal_grant_program
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pgp_pid BIGINT NOT NULL,
    pgp_version INTEGER,
    pgp_proposal_pid BIGINT,
    pgp_account_grant_program_pid BIGINT,
    pgp_grant_amount NUMERIC(15, 2)
);

CREATE TABLE history_octane.proposal_review
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    prpre_pid BIGINT NOT NULL,
    prpre_version INTEGER,
    prpre_proposal_pid BIGINT,
    prpre_request_id INTEGER,
    prpre_request_datetime TIMESTAMP,
    prpre_request_by_lender_user_pid BIGINT,
    prpre_request_summary TEXT,
    prpre_proposal_review_status_type VARCHAR(128),
    prpre_decision_datetime TIMESTAMP,
    prpre_decision_by_lender_user_pid BIGINT,
    prpre_decision_summary TEXT
);

CREATE TABLE history_octane.proposal_review_ticker
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    prpret_pid BIGINT NOT NULL,
    prpret_version INTEGER,
    prpret_proposal_pid BIGINT,
    prpret_next_id INTEGER
);

CREATE TABLE history_octane.proposal_summary
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ps_pid BIGINT NOT NULL,
    ps_version INTEGER,
    ps_proposal_pid BIGINT,
    ps_subject_property_city VARCHAR(128),
    ps_subject_property_country VARCHAR(128),
    ps_subject_property_postal_code VARCHAR(128),
    ps_subject_property_state VARCHAR(128),
    ps_subject_property_street1 VARCHAR(128),
    ps_subject_property_street2 VARCHAR(128),
    ps_note_rate_percent_main NUMERIC(11, 9),
    ps_note_rate_percent_piggyback NUMERIC(11, 9),
    ps_initial_note_rate_percent_main NUMERIC(11, 9),
    ps_initial_note_rate_percent_piggyback NUMERIC(11, 9),
    ps_base_loan_amount_main NUMERIC(17, 2),
    ps_base_loan_amount_piggyback NUMERIC(17, 2),
    ps_loan_amount_main NUMERIC(17, 2),
    ps_loan_amount_piggyback NUMERIC(17, 2),
    ps_product_special_program_type_main VARCHAR(128),
    ps_product_special_program_type_piggyback VARCHAR(128),
    ps_investor_pid_main BIGINT,
    ps_investor_pid_piggyback BIGINT,
    ps_product_fnm_community_lending_product_type_main VARCHAR(128),
    ps_product_fnm_community_lending_product_type_piggyback VARCHAR(128),
    ps_product_fre_community_program_type_main VARCHAR(128),
    ps_product_fre_community_program_type_piggyback VARCHAR(128),
    ps_mortgage_type_main VARCHAR(128),
    ps_mortgage_type_piggyback VARCHAR(128),
    ps_b1_first_name VARCHAR(32),
    ps_c1_first_name VARCHAR(32),
    ps_b2_first_name VARCHAR(32),
    ps_b1_last_name VARCHAR(32),
    ps_c1_last_name VARCHAR(32),
    ps_b2_last_name VARCHAR(32),
    ps_b1_middle_name VARCHAR(32),
    ps_c1_middle_name VARCHAR(32),
    ps_b2_middle_name VARCHAR(32),
    ps_b1_preferred_first_name VARCHAR(32),
    ps_b2_preferred_first_name VARCHAR(32),
    ps_c1_preferred_first_name VARCHAR(32),
    ps_b1_birth_date DATE,
    ps_c1_birth_date DATE,
    ps_b1_monthly_income NUMERIC(15, 2),
    ps_c1_monthly_income NUMERIC(15, 2),
    ps_b2_monthly_income NUMERIC(15, 2),
    ps_b1_has_business_income BIT,
    ps_c1_has_business_income BIT,
    ps_b2_has_business_income BIT,
    ps_b1_citizenship_residency_type VARCHAR(128),
    ps_c1_citizenship_residency_type VARCHAR(128),
    ps_b2_citizenship_residency_type VARCHAR(128),
    ps_b1_hmda_ethnicity_2017_type VARCHAR(128),
    ps_c1_hmda_ethnicity_2017_type VARCHAR(128),
    ps_b2_hmda_ethnicity_2017_type VARCHAR(128),
    ps_b1_decision_credit_score INTEGER,
    ps_c1_decision_credit_score INTEGER,
    ps_b2_decision_credit_score INTEGER,
    ps_b1_gender_type VARCHAR(128),
    ps_c1_gender_type VARCHAR(128),
    ps_b2_gender_type VARCHAR(128),
    ps_b1_hmda_race_2017_type VARCHAR(128),
    ps_c1_hmda_race_2017_type VARCHAR(128),
    ps_b2_hmda_race_2017_type VARCHAR(128),
    ps_any_lender_employee_borrower BIT,
    ps_upfront_mi_percent_main NUMERIC(11, 9),
    ps_upfront_mi_percent_piggyback NUMERIC(11, 9),
    ps_primary_application_name VARCHAR(128),
    ps_investor_loan_id_main VARCHAR(32),
    ps_investor_loan_id_piggyback VARCHAR(32),
    ps_initial_servicer_investor_loan_id_main VARCHAR(32),
    ps_initial_servicer_investor_loan_id_piggyback VARCHAR(32),
    ps_current_servicer_investor_loan_id_main VARCHAR(32),
    ps_current_servicer_investor_loan_id_piggyback VARCHAR(32),
    ps_offering_id_main VARCHAR(32),
    ps_offering_id_piggyback VARCHAR(32),
    ps_proposal_structure_type VARCHAR(128),
    ps_loan_maturity_date_main DATE,
    ps_loan_maturity_date_piggyback DATE,
    ps_ltv_ratio_percent_main NUMERIC(11, 9),
    ps_ltv_ratio_percent_piggyback NUMERIC(11, 9),
    ps_cltv_ratio_percent NUMERIC(11, 9),
    ps_hcltv_ratio_percent NUMERIC(11, 9),
    ps_hcltv_applicable BIT,
    ps_debt_ratio_percent NUMERIC(11, 9),
    ps_housing_ratio_percent NUMERIC(11, 9),
    ps_property_category_type VARCHAR(128),
    ps_any_first_time_home_buyer BIT,
    ps_primary_housing_expense_amount NUMERIC(15, 2),
    ps_non_primary_housing_expense_amount NUMERIC(15, 2),
    ps_income_monthly_total_amount NUMERIC(15, 2),
    ps_asset_total_amount NUMERIC(15, 2),
    ps_liquid_asset_total_amount NUMERIC(15, 2),
    ps_liability_unpaid_balance_total_amount NUMERIC(15, 2),
    ps_liability_monthly_payment_total_amount NUMERIC(15, 2),
    ps_monthly_pitia_amount NUMERIC(15, 2),
    ps_cash_from_borrower_amount_signed NUMERIC(15, 2),
    ps_proposed_monthly_housing_and_debt_amount NUMERIC(15, 2),
    ps_funding_date_main DATE,
    ps_funding_date_piggyback DATE,
    ps_interim_funder_company_name VARCHAR(128),
    ps_interim_funder_mers_org_id VARCHAR(7),
    ps_funding_scheduled_release_date_main DATE,
    ps_funding_scheduled_release_date_piggyback DATE,
    ps_uuts_aus_recommendation_description VARCHAR(32),
    ps_interest_rate_fee_amount_signed NUMERIC(15, 2),
    ps_interest_rate_fee_amount_signed_main NUMERIC(15, 2),
    ps_interest_rate_fee_amount_signed_piggyback NUMERIC(15, 2),
    ps_origination_fees_amount_signed NUMERIC(15, 2),
    ps_origination_fees_amount_signed_main NUMERIC(15, 2),
    ps_origination_fees_amount_signed_piggyback NUMERIC(15, 2),
    ps_any_escrow_waived BIT,
    ps_initial_rate_adjustment_date_main DATE,
    ps_initial_rate_adjustment_date_piggyback DATE,
    ps_tolerance_cure_amount_signed NUMERIC(15, 2),
    ps_tolerance_cure_amount_signed_main NUMERIC(15, 2),
    ps_tolerance_cure_amount_signed_piggyback NUMERIC(15, 2),
    ps_subject_property_existing_subordinate_2nd BIT,
    ps_subject_property_subordinate_2nd_creditor_pid BIGINT,
    ps_subject_property_existing_subordinate_3rd BIT,
    ps_subject_property_subordinate_3rd_creditor_pid BIGINT,
    ps_total_monthly_solar_lease_payments_amount NUMERIC(15, 2),
    ps_total_debt_payoff_amount NUMERIC(15, 2),
    ps_total_new_subordinate_financing_amount NUMERIC(15, 2),
    ps_total_grant_amount NUMERIC(15, 2),
    ps_any_third_party_community_second BIT,
    ps_any_grant_program BIT,
    ps_initial_loan_estimate_loan_amount_main NUMERIC(17, 2),
    ps_initial_loan_estimate_loan_amount_piggyback NUMERIC(17, 2),
    ps_any_mortgage_credit_certificate BIT,
    ps_debt_ratio_excluding_mi_percent NUMERIC(11, 9),
    ps_fund_source_type_main VARCHAR(128),
    ps_fund_source_type_piggyback VARCHAR(128),
    ps_mortgage_credit_certificate_issuer_pid BIGINT,
    ps_subject_property_new_subordinate_2nd BIT,
    ps_subject_property_new_subordinate_3rd BIT,
    ps_any_borrower_self_employed BIT,
    ps_fha_section_of_act_coarse_type_main VARCHAR(128),
    ps_fha_section_of_act_coarse_type_piggyback VARCHAR(128),
    ps_fha_special_program_type_main VARCHAR(128),
    ps_fha_special_program_type_piggyback VARCHAR(128),
    ps_product_pid_main BIGINT,
    ps_product_pid_piggyback BIGINT,
    ps_net_origination_charge_main NUMERIC(15, 2),
    ps_net_origination_charge_piggyback NUMERIC(15, 2),
    ps_household_income_guideline_percent NUMERIC(22, 9),
    ps_applicant_count smallint,
    ps_early_wire_total_charge_amount_main NUMERIC(15, 2),
    ps_early_wire_total_charge_amount_piggyback NUMERIC(15, 2),
    ps_funding_scheduled_release_date_auto_compute_main BIT,
    ps_funding_scheduled_release_date_auto_compute_piggyback BIT
);

CREATE TABLE history_octane.pte_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pter_pid BIGINT NOT NULL,
    pter_version INTEGER,
    pter_proposal_pid BIGINT,
    pter_create_datetime TIMESTAMP,
    pter_pte_request_status_type VARCHAR(128),
    pter_pte_response_status_type VARCHAR(128),
    pter_pte_error_messages TEXT,
    pter_address_street1 VARCHAR(128),
    pter_address_street2 VARCHAR(128),
    pter_address_city VARCHAR(128),
    pter_address_state VARCHAR(128),
    pter_address_postal_code VARCHAR(128),
    pter_response_xml_pid BIGINT,
    pter_response_pdf_file_pid BIGINT,
    pter_submitting_party_order_id VARCHAR(128),
    pter_responding_party_order_id VARCHAR(32),
    pter_fulfillment_party_order_id VARCHAR(32),
    pter_building_status_type VARCHAR(128),
    pter_loan_purpose_type VARCHAR(128),
    pter_effective_property_value_amount NUMERIC(15),
    pter_property_usage_type VARCHAR(128)
);

CREATE TABLE history_octane.public_record
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pr_pid BIGINT NOT NULL,
    pr_version INTEGER,
    pr_proposal_pid BIGINT,
    pr_credit_request_pid BIGINT,
    pr_public_record_type VARCHAR(128),
    pr_public_record_type_other_description VARCHAR(32),
    pr_public_record_disposition_type VARCHAR(128),
    pr_report_public_record_disposition_type VARCHAR(128),
    pr_disposition_date DATE,
    pr_filed_date DATE,
    pr_reported_date DATE,
    pr_settled_date DATE,
    pr_paid_date DATE,
    pr_docket_id VARCHAR(32),
    pr_bankruptcy_exception_type VARCHAR(128),
    pr_bankruptcy_assets_amount NUMERIC(15, 2),
    pr_bankruptcy_exempt_amount NUMERIC(15, 2),
    pr_bankruptcy_liabilities_amount NUMERIC(15, 2),
    pr_legal_obligation_amount NUMERIC(15, 2),
    pr_court_name VARCHAR(128),
    pr_plaintiff_name VARCHAR(128),
    pr_defendant_name VARCHAR(128),
    pr_attorney_name VARCHAR(128),
    pr_comment VARCHAR(16000),
    pr_note VARCHAR(1024),
    pr_equifax_included BIT,
    pr_experian_included BIT,
    pr_trans_union_included BIT,
    pr_credit_report_identifier VARCHAR(32)
);

CREATE TABLE history_octane.borrower_public_record
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bpr_pid BIGINT NOT NULL,
    bpr_version INTEGER,
    bpr_borrower_pid BIGINT,
    bpr_public_record_pid BIGINT
);

CREATE TABLE history_octane.rental_income
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ri_pid BIGINT NOT NULL,
    ri_version INTEGER,
    ri_borrower_income_pid BIGINT,
    ri_place_pid BIGINT,
    ri_schedule_e_input BIT,
    ri_rental_income_estimated_mode BIT,
    ri_rental_income_estimated_gross_monthly_amount NUMERIC(15, 2),
    ri_simple_monthly_total_amount NUMERIC(15, 2),
    ri_schedule_e_calculated_gross_monthly_amount NUMERIC(15, 2),
    ri_schedule_e_proposed_monthly_expense_amount NUMERIC(15, 2),
    ri_schedule_e_net_monthly_amount NUMERIC(15, 2),
    ri_rental_income_monthly_total_amount NUMERIC(15, 2),
    ri_schedule_e_non_recurring_expense_1 VARCHAR(128),
    ri_schedule_e_non_recurring_expense_2 VARCHAR(128),
    ri_schedule_e_non_recurring_expense_3 VARCHAR(128),
    ri_rental_income_calc_method VARCHAR(128),
    ri_common_year1_year INTEGER,
    ri_common_year1_year_include BIT,
    ri_common_year1_from_date DATE,
    ri_common_year1_through_date DATE,
    ri_common_year1_months NUMERIC(4, 2),
    ri_common_year1_annual_total_amount NUMERIC(15, 2),
    ri_common_year1_monthly_total_amount NUMERIC(15, 2),
    ri_common_year2_year INTEGER,
    ri_common_year2_year_include BIT,
    ri_common_year2_from_date DATE,
    ri_common_year2_through_date DATE,
    ri_common_year2_months NUMERIC(4, 2),
    ri_common_year2_annual_total_amount NUMERIC(15, 2),
    ri_common_year2_monthly_total_amount NUMERIC(15, 2),
    ri_common_year3_year INTEGER,
    ri_common_year3_year_include BIT,
    ri_common_year3_from_date DATE,
    ri_common_year3_through_date DATE,
    ri_common_year3_months NUMERIC(4, 2),
    ri_common_year3_annual_total_amount NUMERIC(15, 2),
    ri_common_year3_monthly_total_amount NUMERIC(15, 2),
    ri_schedule_e_year1_rent_received_amount NUMERIC(15, 2),
    ri_schedule_e_year1_advertising_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year1_auto_travel_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year1_cleaning_maintenance_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year1_commissions_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year1_insurance_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year1_legal_professional_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year1_management_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year1_mortgage_interest_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year1_other_interest_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year1_repairs_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year1_supplies_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year1_taxes_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year1_utilities_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year1_depreciation_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year1_other_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year1_total_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year1_non_recurring_expense_amount_1 NUMERIC(15, 2),
    ri_schedule_e_year1_non_recurring_expense_amount_2 NUMERIC(15, 2),
    ri_schedule_e_year1_non_recurring_expense_amount_3 NUMERIC(15, 2),
    ri_schedule_e_year1_insurance_credit_amount NUMERIC(15, 2),
    ri_schedule_e_year1_taxes_credit_amount NUMERIC(15, 2),
    ri_schedule_e_year1_annual_subtotal NUMERIC(15, 2),
    ri_schedule_e_year1_ownership_percent NUMERIC(11, 9),
    ri_schedule_e_year2_rent_received_amount NUMERIC(15, 2),
    ri_schedule_e_year2_advertising_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year2_auto_travel_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year2_cleaning_maintenance_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year2_commissions_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year2_insurance_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year2_legal_professional_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year2_management_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year2_mortgage_interest_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year2_other_interest_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year2_repairs_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year2_supplies_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year2_taxes_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year2_utilities_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year2_depreciation_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year2_other_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year2_total_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year2_non_recurring_expense_amount_1 NUMERIC(15, 2),
    ri_schedule_e_year2_non_recurring_expense_amount_2 NUMERIC(15, 2),
    ri_schedule_e_year2_non_recurring_expense_amount_3 NUMERIC(15, 2),
    ri_schedule_e_year2_insurance_credit_amount NUMERIC(15, 2),
    ri_schedule_e_year2_taxes_credit_amount NUMERIC(15, 2),
    ri_schedule_e_year2_annual_subtotal NUMERIC(15, 2),
    ri_schedule_e_year2_ownership_percent NUMERIC(11, 9),
    ri_schedule_e_year3_rent_received_amount NUMERIC(15, 2),
    ri_schedule_e_year3_advertising_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year3_auto_travel_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year3_cleaning_maintenance_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year3_commissions_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year3_insurance_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year3_legal_professional_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year3_management_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year3_mortgage_interest_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year3_other_interest_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year3_repairs_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year3_supplies_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year3_taxes_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year3_utilities_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year3_depreciation_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year3_other_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year3_total_expense_amount NUMERIC(15, 2),
    ri_schedule_e_year3_non_recurring_expense_amount_1 NUMERIC(15, 2),
    ri_schedule_e_year3_non_recurring_expense_amount_2 NUMERIC(15, 2),
    ri_schedule_e_year3_non_recurring_expense_amount_3 NUMERIC(15, 2),
    ri_schedule_e_year3_insurance_credit_amount NUMERIC(15, 2),
    ri_schedule_e_year3_taxes_credit_amount NUMERIC(15, 2),
    ri_schedule_e_year3_annual_subtotal NUMERIC(15, 2),
    ri_schedule_e_year3_ownership_percent NUMERIC(11, 9),
    ri_simple_monthly_rent_amount NUMERIC(15, 2),
    ri_simple_vacancy_maintenance_adjustment_percent NUMERIC(11, 9),
    ri_simple_monthly_net_rent_amount NUMERIC(15, 2),
    ri_simple_monthly_expense_amount NUMERIC(15, 2),
    ri_simple_monthly_pre_ownership_income_amount NUMERIC(15, 2),
    ri_simple_ownership_percent NUMERIC(11, 9),
    ri_simple_calculated_monthly_amount NUMERIC(15, 2)
);

CREATE TABLE history_octane.sap_quote_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sqr_pid BIGINT NOT NULL,
    sqr_version INTEGER,
    sqr_deal_pid BIGINT,
    sqr_include_conventional BIT,
    sqr_include_fha BIT,
    sqr_include_va BIT,
    sqr_include_fixed_rate BIT,
    sqr_include_arm BIT,
    sqr_due_in_term_months_string_list TEXT
);

CREATE TABLE history_octane.secondary_settings
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sset_pid BIGINT NOT NULL,
    sset_version INTEGER,
    sset_account_pid BIGINT,
    sset_default_lead_source_pid BIGINT,
    sset_default_mortech_account_pid BIGINT,
    sset_default_beneficiary_investor_pid BIGINT,
    sset_default_servicer_investor_pid BIGINT,
    sset_initial_lender_lock_id BIGINT,
    sset_initial_lender_trade_id BIGINT,
    sset_lock_expiration_warning_days INTEGER,
    sset_expired_lock_update_allowed_days INTEGER,
    sset_disable_all_locking BIT,
    sset_pricing_engine_type VARCHAR(128),
    sset_price_match_check_suspend_through_date DATE,
    sset_mortech_disable_eligibility BIT,
    sset_mortech_strict_eligibility BIT,
    sset_zillow_appraisal_fee NUMERIC(15, 2),
    sset_zillow_title_fee NUMERIC(15, 2),
    sset_zillow_recording_fee NUMERIC(15, 2),
    sset_mortech_floating_adjuster_prefixes VARCHAR(16000),
    sset_rate_lock_acknowledgement_due_days INTEGER,
    sset_rate_lock_supporting_documentation_due_days INTEGER,
    sset_rate_lock_appraisal_inspection_due_days INTEGER,
    sset_min_subordinate_financing_lock_term_days INTEGER,
    sset_servicer_loan_id_minimum_available_threshold INTEGER,
    sset_servicer_loan_id_minimum_available_warning_email VARCHAR(256),
    sset_third_party_base_margin_prefixes VARCHAR(16000),
    sset_third_party_floating_margin_prefixes VARCHAR(16000),
    sset_month_ami_uses_subsequent_year INTEGER,
    sset_day_ami_uses_subsequent_year INTEGER
);

CREATE TABLE history_octane.servicer_loan_id_import_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    slir_pid BIGINT NOT NULL,
    slir_version INTEGER,
    slir_account_pid BIGINT,
    slir_create_datetime TIMESTAMP,
    slir_import_lender_user_pid BIGINT,
    slir_imported_loan_id_count INTEGER,
    slir_error_loan_id_count INTEGER,
    slir_servicer_loan_id_import_request_status_type VARCHAR(128)
);

CREATE TABLE history_octane.servicer_loan_id_assignment
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    slia_pid BIGINT NOT NULL,
    slia_version INTEGER,
    slia_account_pid BIGINT,
    slia_servicer_loan_id_import_request_pid BIGINT,
    slia_loan_servicer_pid BIGINT,
    slia_servicer_loan_id VARCHAR(32),
    slia_servicer_loan_id_assign_type VARCHAR(128),
    slia_assigned_datetime TIMESTAMP
);

CREATE TABLE history_octane.smart_doc
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sd_pid BIGINT NOT NULL,
    sd_version INTEGER,
    sd_account_pid BIGINT,
    sd_doc_set_type VARCHAR(128),
    sd_custom_form_pid BIGINT,
    sd_doc_name VARCHAR(767),
    sd_doc_number NUMERIC(15, 3),
    sd_doc_category_type VARCHAR(128),
    sd_doc_file_source_type VARCHAR(128),
    sd_doc_external_provider_type VARCHAR(128),
    sd_broker_applicable_provider BIT,
    sd_action_entities_from_merge_field BIT,
    sd_action_entity_applicant BIT,
    sd_action_entity_non_applicant BIT,
    sd_action_entity_underwriter BIT,
    sd_action_entity_originator BIT,
    sd_doc_borrower_access_mode_type VARCHAR(128),
    sd_borrower_explanation VARCHAR(1024),
    sd_deal_child_type VARCHAR(128),
    sd_doc_fulfill_status_type_default VARCHAR(128),
    sd_prior_to_type VARCHAR(128),
    sd_doc_action_type VARCHAR(128),
    sd_e_delivery BIT,
    sd_active BIT,
    sd_doc_validity_type VARCHAR(128),
    sd_doc_key_date_type VARCHAR(128),
    sd_expiration_rule_type VARCHAR(128),
    sd_days_before_key_date INTEGER,
    sd_warning_days INTEGER,
    sd_key_doc_type VARCHAR(128),
    sd_key_doc_include_file VARCHAR(128),
    sd_doc_approval_type VARCHAR(128),
    sd_auto_approve BIT,
    sd_auto_include_on_request BIT,
    sd_poa_applicable BIT,
    sd_action_entity_hud_va_lender_officer BIT,
    sd_action_entity_collateral_underwriter BIT,
    sd_action_entity_wholesale_client_advocate BIT,
    sd_action_entity_correspondent_client_advocate BIT,
    sd_action_entity_government_insurance BIT,
    sd_action_entity_underwriting_manager BIT,
    sd_action_entity_effective_collateral_underwriter BIT
);

CREATE TABLE history_octane.smart_doc_criteria
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sdc_pid BIGINT NOT NULL,
    sdc_version INTEGER,
    sdc_smart_doc_pid BIGINT,
    sdc_criteria_pid BIGINT,
    sdc_deal_child_type VARCHAR(128)
);

CREATE TABLE history_octane.smart_doc_note
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sdn_pid BIGINT NOT NULL,
    sdn_version INTEGER,
    sdn_smart_doc_pid BIGINT,
    sdn_create_datetime TIMESTAMP,
    sdn_content VARCHAR(16000),
    sdn_author_lender_user_pid BIGINT,
    sdn_author_unparsed_name VARCHAR(128)
);

CREATE TABLE history_octane.smart_doc_note_comment
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sdnc_pid BIGINT NOT NULL,
    sdnc_version INTEGER,
    sdnc_smart_doc_note_pid BIGINT,
    sdnc_create_datetime TIMESTAMP,
    sdnc_content VARCHAR(16000),
    sdnc_author_lender_user_pid BIGINT,
    sdnc_author_unparsed_name VARCHAR(128)
);

CREATE TABLE history_octane.smart_doc_note_monitor
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sdnm_pid BIGINT NOT NULL,
    sdnm_version INTEGER,
    sdnm_smart_doc_note_pid BIGINT,
    sdnm_lender_user_pid BIGINT
);

CREATE TABLE history_octane.smart_doc_role
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sdr_pid BIGINT NOT NULL,
    sdr_version INTEGER,
    sdr_smart_doc_pid BIGINT,
    sdr_role_pid BIGINT,
    sdr_doc_permission_type VARCHAR(128)
);

CREATE TABLE history_octane.smart_message
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    smsg_pid BIGINT NOT NULL,
    smsg_version INTEGER,
    smsg_account_pid BIGINT,
    smsg_name VARCHAR(256),
    smsg_delivery_type VARCHAR(128),
    smsg_reply_to_role_pid BIGINT,
    smsg_email_subject VARCHAR(1024),
    smsg_message_source_type VARCHAR(128),
    smsg_smart_doc_pid BIGINT,
    smsg_smart_stack_pid BIGINT,
    smsg_allow_ad_hoc BIT,
    smsg_send_securely BIT,
    smsg_id_num INTEGER,
    smsg_message_body VARCHAR(16000),
    smsg_email_closing_type VARCHAR(128)
);

CREATE TABLE history_octane.smart_message_recipient
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    smr_pid BIGINT NOT NULL,
    smr_version INTEGER,
    smr_smart_message_pid BIGINT,
    smr_recipient_type VARCHAR(128),
    smr_role_pid BIGINT,
    smr_email_recipient_type VARCHAR(128)
);

CREATE TABLE history_octane.smart_req
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sr_pid BIGINT NOT NULL,
    sr_version INTEGER,
    sr_smart_doc_pid BIGINT,
    sr_criteria_pid BIGINT,
    sr_deal_child_type VARCHAR(128),
    sr_deal_child_relationship_type VARCHAR(128),
    sr_req_name VARCHAR(767),
    sr_borrower_access BIT,
    sr_active BIT
);

CREATE TABLE history_octane.smart_separator
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ssp_pid BIGINT NOT NULL,
    ssp_version INTEGER,
    ssp_account_pid BIGINT,
    ssp_custom_form_pid BIGINT,
    ssp_criteria_pid BIGINT,
    ssp_separator_name VARCHAR(767)
);

CREATE TABLE history_octane.smart_set_doc
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sstd_pid BIGINT NOT NULL,
    sstd_version INTEGER,
    sstd_smart_doc_set_pid BIGINT,
    sstd_smart_doc_pid BIGINT,
    sstd_sequence INTEGER
);

CREATE TABLE history_octane.smart_stack_doc
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ssd_pid BIGINT NOT NULL,
    ssd_version INTEGER,
    ssd_smart_stack_pid BIGINT,
    ssd_stack_doc_type VARCHAR(128),
    ssd_smart_doc_set_pid BIGINT,
    ssd_smart_separator_pid BIGINT,
    ssd_smart_doc_pid BIGINT,
    ssd_sequence BIGINT,
    ssd_smart_stack_doc_set_include_type VARCHAR(128)
);

CREATE TABLE history_octane.stack_export_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ser_pid BIGINT NOT NULL,
    ser_version INTEGER,
    ser_account_pid BIGINT,
    ser_create_datetime TIMESTAMP,
    ser_start_datetime TIMESTAMP,
    ser_end_datetime TIMESTAMP,
    ser_request_status_type VARCHAR(128),
    ser_loan_export_type VARCHAR(128),
    ser_loan_name_format_type VARCHAR(128),
    ser_file_name_format_type VARCHAR(128),
    ser_requester_lender_user_pid BIGINT,
    ser_requester_unparsed_name VARCHAR(128),
    ser_smart_stack_pid BIGINT,
    ser_total_deal_count INTEGER,
    ser_exported_deal_count INTEGER,
    ser_description VARCHAR(32)
);

CREATE TABLE history_octane.stack_export_file
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sef_pid BIGINT NOT NULL,
    sef_version INTEGER,
    sef_stack_export_request_pid BIGINT,
    sef_repository_file_pid BIGINT,
    sef_stack_export_file_type VARCHAR(128)
);

CREATE TABLE history_octane.tax_transcript_request
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ttr_pid BIGINT NOT NULL,
    ttr_version INTEGER,
    ttr_deal_pid BIGINT,
    ttr_create_datetime TIMESTAMP,
    ttr_requester_agent_type VARCHAR(128),
    ttr_requester_lender_user_pid BIGINT,
    ttr_requester_unparsed_name VARCHAR(128),
    ttr_mismo_version_type VARCHAR(128),
    ttr_credit_request_type VARCHAR(128),
    ttr_request_error_messages TEXT,
    ttr_request_success_messages TEXT,
    ttr_tracking_number VARCHAR(16),
    ttr_tax_transcript_request_status_type VARCHAR(128),
    ttr_update_reason VARCHAR(1024),
    ttr_last_status_query_datetime TIMESTAMP,
    ttr_signed_4506t_deal_file_pid BIGINT,
    ttr_company BIT,
    ttr_company_name VARCHAR(128),
    ttr_company_city VARCHAR(128),
    ttr_company_country VARCHAR(128),
    ttr_company_postal_code VARCHAR(128),
    ttr_company_state VARCHAR(128),
    ttr_company_street1 VARCHAR(128),
    ttr_company_street2 VARCHAR(128),
    ttr_company_ein VARCHAR(16),
    ttr_borrower1_pid BIGINT,
    ttr_borrower1_first_name VARCHAR(32),
    ttr_borrower1_middle_name VARCHAR(32),
    ttr_borrower1_last_name VARCHAR(32),
    ttr_borrower1_name_suffix VARCHAR(32),
    ttr_borrower1_birth_date DATE,
    ttr_borrower1_current_city VARCHAR(128),
    ttr_borrower1_current_country VARCHAR(128),
    ttr_borrower1_current_postal_code VARCHAR(128),
    ttr_borrower1_current_state VARCHAR(128),
    ttr_borrower1_current_street1 VARCHAR(128),
    ttr_borrower1_current_street2 VARCHAR(128),
    ttr_borrower1_prior_city VARCHAR(128),
    ttr_borrower1_prior_country VARCHAR(128),
    ttr_borrower1_prior_postal_code VARCHAR(128),
    ttr_borrower1_prior_state VARCHAR(128),
    ttr_borrower1_prior_street1 VARCHAR(128),
    ttr_borrower1_prior_street2 VARCHAR(128),
    ttr_borrower1_monthly_income_amount NUMERIC(15, 2),
    ttr_borrower2_pid BIGINT,
    ttr_borrower2_first_name VARCHAR(32),
    ttr_borrower2_middle_name VARCHAR(32),
    ttr_borrower2_last_name VARCHAR(32),
    ttr_borrower2_name_suffix VARCHAR(32),
    ttr_borrower2_birth_date DATE,
    ttr_borrower2_current_city VARCHAR(128),
    ttr_borrower2_current_country VARCHAR(128),
    ttr_borrower2_current_postal_code VARCHAR(128),
    ttr_borrower2_current_state VARCHAR(128),
    ttr_borrower2_current_street1 VARCHAR(128),
    ttr_borrower2_current_street2 VARCHAR(128),
    ttr_borrower2_prior_city VARCHAR(128),
    ttr_borrower2_prior_country VARCHAR(128),
    ttr_borrower2_prior_postal_code VARCHAR(128),
    ttr_borrower2_prior_state VARCHAR(128),
    ttr_borrower2_prior_street1 VARCHAR(128),
    ttr_borrower2_prior_street2 VARCHAR(128),
    ttr_borrower2_monthly_income_amount NUMERIC(15, 2),
    ttr_year1 INTEGER,
    ttr_year2 INTEGER,
    ttr_year3 INTEGER,
    ttr_year4 INTEGER,
    ttr_include_w_2 BIT,
    ttr_include_1099 BIT,
    ttr_include_1040 BIT,
    ttr_include_1040_return_transcript BIT,
    ttr_include_1040_account_transcript BIT,
    ttr_include_1040_record_of_account BIT,
    ttr_include_1065 BIT,
    ttr_include_1065_return_transcript BIT,
    ttr_include_1065_account_transcript BIT,
    ttr_include_1065_record_of_account BIT,
    ttr_include_1120 BIT,
    ttr_include_1120_return_transcript BIT,
    ttr_include_1120_account_transcript BIT,
    ttr_include_1120_record_of_account BIT,
    ttr_archived BIT,
    ttr_company_phone VARCHAR(32),
    ttr_company_phone_extension VARCHAR(16),
    ttr_business_ownership_type VARCHAR(128)
);

CREATE TABLE history_octane.third_party_community_second_program
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    tpcsp_pid BIGINT NOT NULL,
    tpcsp_version INTEGER,
    tpcsp_account_pid BIGINT,
    tpcsp_program_id VARCHAR(32),
    tpcsp_program_name VARCHAR(128),
    tpcsp_fre_community_program_type VARCHAR(128),
    tpcsp_fnm_community_lending_product_type VARCHAR(128),
    tpcsp_fnm_community_seconds_repayment_structure_type VARCHAR(128),
    tpcsp_wire_action_type VARCHAR(128),
    tpcsp_security_instrument_page_count INTEGER,
    tpcsp_deed_page_count INTEGER,
    tpcsp_notes VARCHAR(1024),
    tpcsp_from_date DATE,
    tpcsp_through_date DATE,
    tpcsp_investor_pid BIGINT
);

CREATE TABLE history_octane.liability
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    lia_pid BIGINT NOT NULL,
    lia_version INTEGER,
    lia_proposal_pid BIGINT,
    lia_creditor_pid BIGINT,
    lia_aggregate_description VARCHAR(128),
    lia_credit_request_pid BIGINT,
    lia_description VARCHAR(128),
    lia_city VARCHAR(128),
    lia_country VARCHAR(128),
    lia_postal_code VARCHAR(128),
    lia_state VARCHAR(128),
    lia_street1 VARCHAR(128),
    lia_street2 VARCHAR(128),
    lia_holder_name VARCHAR(128),
    lia_report_holder_name VARCHAR(128),
    lia_holder_phone VARCHAR(32),
    lia_holder_phone_extension VARCHAR(16),
    lia_holder_fax VARCHAR(32),
    lia_holder_email VARCHAR(256),
    lia_account_opened_date DATE,
    lia_report_account_opened_date DATE,
    lia_account_reported_date DATE,
    lia_last_activity_date DATE,
    lia_most_recent_adverse_rating_date DATE,
    lia_liability_disposition_type VARCHAR(128),
    lia_liability_type VARCHAR(128),
    lia_report_liability_type VARCHAR(128),
    lia_lien_priority_type VARCHAR(128),
    lia_monthly_payment_amount NUMERIC(15, 2),
    lia_report_monthly_payment_amount NUMERIC(15, 2),
    lia_remaining_term_months INTEGER,
    lia_report_remaining_term_months INTEGER,
    lia_months_reviewed_count INTEGER,
    lia_high_balance_amount NUMERIC(15, 2),
    lia_credit_limit_amount NUMERIC(15),
    lia_report_credit_limit_amount NUMERIC(15),
    lia_past_due_amount NUMERIC(15, 2),
    lia_report_past_due_amount NUMERIC(15, 2),
    lia_unpaid_balance_amount NUMERIC(15, 2),
    lia_report_unpaid_balance_amount NUMERIC(15, 2),
    lia_report_value_overridden BIT,
    lia_place_pid BIGINT,
    lia_liability_foreclosure_exception_type VARCHAR(128),
    lia_bankruptcy_exception_type VARCHAR(128),
    lia_liability_current_rating_type VARCHAR(128),
    lia_liability_account_status_type VARCHAR(128),
    lia_report_account_ownership_type VARCHAR(128),
    lia_consumer_dispute VARCHAR(128),
    lia_derogatory_data VARCHAR(128),
    lia_late30_days_count VARCHAR(16),
    lia_late60_days_count VARCHAR(16),
    lia_late90_days_count VARCHAR(16),
    lia_note VARCHAR(1024),
    lia_equifax_included BIT,
    lia_experian_included BIT,
    lia_trans_union_included BIT,
    lia_liability_financing_type VARCHAR(128),
    lia_original_loan_amount NUMERIC(15),
    lia_interest_rate_on_statement BIT,
    lia_interest_rate_percent NUMERIC(11, 9),
    lia_loan_amortization_type VARCHAR(128),
    lia_interest_only VARCHAR(128),
    lia_property_taxes_escrowed BIT,
    lia_property_insurance_escrowed BIT,
    lia_senior_lien_restriction_type VARCHAR(128),
    lia_senior_lien_restriction_amount NUMERIC(15),
    lia_agency_case_id VARCHAR(32),
    lia_terms_months_count INTEGER,
    lia_report_terms_months_count INTEGER,
    lia_payoff_statement_date DATE,
    lia_payoff_statement_good_through_date DATE,
    lia_next_payment_due_date DATE,
    lia_payoff_statement_interest NUMERIC(15, 2),
    lia_daily_interest_amount NUMERIC(15, 2),
    lia_monthly_interest_amount NUMERIC(15, 2),
    lia_payoff_interest_pad_days INTEGER,
    lia_effective_payoff_date DATE,
    lia_effective_payoff_date_adjustment_amount NUMERIC(15, 2),
    lia_effective_payoff_date_adjustment_days INTEGER,
    lia_other_payoff_related_charges_amount NUMERIC(15, 2),
    lia_payoff_amount NUMERIC(15, 2),
    lia_payoff_amount_estimated BIT,
    lia_used_to_acquire_property VARCHAR(128),
    lia_heloc_advance_last_12_months_over_thousand VARCHAR(128),
    lia_liability_mi_type VARCHAR(128),
    lia_texas_equity VARCHAR(128),
    lia_texas_equity_locked BIT,
    lia_texas_equity_conversion VARCHAR(128),
    lia_credit_report_identifier VARCHAR(32),
    lia_net_escrow VARCHAR(128),
    lia_third_party_community_second_program_pid BIGINT,
    lia_current_escrow_balance_amount NUMERIC(15, 2),
    lia_first_payment_date DATE,
    lia_closing_date DATE,
    lia_mip_due_amount NUMERIC(15, 2),
    lia_unpaid_late_charges_amount NUMERIC(15, 2),
    lia_include_within_cema VARCHAR(128),
    lia_energy_related_type VARCHAR(128)
);

CREATE TABLE history_octane.borrower_liability
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bl_pid BIGINT NOT NULL,
    bl_version INTEGER,
    bl_borrower_pid BIGINT,
    bl_liability_pid BIGINT
);

CREATE TABLE history_octane.deal_tag
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dtg_pid BIGINT NOT NULL,
    dtg_version INTEGER,
    dtg_deal_tag_definition_pid BIGINT,
    dtg_deal_pid BIGINT,
    dtg_asset_pid BIGINT,
    dtg_liability_pid BIGINT,
    dtg_application_pid BIGINT,
    dtg_borrower_pid BIGINT,
    dtg_borrower_income_pid BIGINT,
    dtg_job_income_pid BIGINT,
    dtg_other_income_pid BIGINT,
    dtg_business_income_pid BIGINT,
    dtg_rental_income_pid BIGINT,
    dtg_place_pid BIGINT,
    dtg_borrower_residence_pid BIGINT,
    dtg_credit_inquiry_pid BIGINT,
    dtg_appraisal_pid BIGINT
);

CREATE TABLE history_octane.product_third_party_community_second_program
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ptpp_pid BIGINT NOT NULL,
    ptpp_version INTEGER,
    ptpp_product_terms_pid BIGINT,
    ptpp_third_party_community_second_program_pid BIGINT
);

CREATE TABLE history_octane.proposal_doc
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    prpd_pid BIGINT NOT NULL,
    prpd_version INTEGER,
    prpd_doc_name VARCHAR(767),
    prpd_doc_number NUMERIC(15, 3),
    prpd_borrower_access BIT,
    prpd_deal_child_type VARCHAR(128),
    prpd_deal_child_name VARCHAR(767),
    prpd_deal_pid BIGINT,
    prpd_proposal_pid BIGINT,
    prpd_loan_pid BIGINT,
    prpd_borrower_pid BIGINT,
    prpd_borrower_income_pid BIGINT,
    prpd_job_income_pid BIGINT,
    prpd_borrower_job_gap_pid BIGINT,
    prpd_other_income_pid BIGINT,
    prpd_business_income_pid BIGINT,
    prpd_rental_income_pid BIGINT,
    prpd_asset_pid BIGINT,
    prpd_asset_large_deposit_pid BIGINT,
    prpd_liability_pid BIGINT,
    prpd_reo_place_pid BIGINT,
    prpd_property_place_pid BIGINT,
    prpd_residence_place_pid BIGINT,
    prpd_borrower_residence_pid BIGINT,
    prpd_application_pid BIGINT,
    prpd_credit_inquiry_pid BIGINT,
    prpd_appraisal_pid BIGINT,
    prpd_appraisal_form_pid BIGINT,
    prpd_tax_transcript_request_pid BIGINT,
    prpd_valid_from_date DATE,
    prpd_valid_through_date DATE,
    prpd_key_date DATE,
    prpd_trash BIT,
    prpd_smart_doc_pid BIGINT,
    prpd_proposal_doc_set_pid BIGINT,
    prpd_doc_fulfill_status_type VARCHAR(128),
    prpd_status_unparsed_name VARCHAR(128),
    prpd_status_datetime TIMESTAMP,
    prpd_status_reason VARCHAR(1024),
    prpd_doc_excluded BIT,
    prpd_doc_excluded_reason VARCHAR(1024),
    prpd_doc_excluded_unparsed_name VARCHAR(128),
    prpd_doc_excluded_datetime TIMESTAMP,
    prpd_doc_approval_type VARCHAR(128),
    prpd_borrower_edit BIT,
    prpd_last_status_reason TEXT,
    prpd_borrower_associated_address_pid BIGINT,
    prpd_construction_cost_pid BIGINT,
    prpd_construction_draw_pid BIGINT,
    prpd_proposal_contractor_pid BIGINT,
    prpd_doc_provider_group_type VARCHAR(128),
    prpd_doc_req_fulfill_status_type VARCHAR(128),
    prpd_doc_req_decision_status_type VARCHAR(128)
);

CREATE TABLE history_octane.proposal_doc_borrower_access
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    pdba_pid BIGINT NOT NULL,
    pdba_version INTEGER,
    pdba_borrower_pid BIGINT,
    pdba_proposal_doc_pid BIGINT
);

CREATE TABLE history_octane.proposal_doc_file
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    prpdf_pid BIGINT NOT NULL,
    prpdf_version INTEGER,
    prpdf_proposal_doc_pid BIGINT,
    prpdf_deal_file_pid BIGINT,
    prpdf_proposal_doc_file_type VARCHAR(128),
    prpdf_included_file VARCHAR(128),
    prpdf_key_doc BIT
);

CREATE TABLE history_octane.proposal_req
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    prpr_pid BIGINT NOT NULL,
    prpr_version INTEGER,
    prpr_proposal_doc_pid BIGINT,
    prpr_req_name VARCHAR(767),
    prpr_borrower_access BIT,
    prpr_req_id INTEGER,
    prpr_req_fulfill_status_type VARCHAR(128),
    prpr_fulfill_status_unparsed_name VARCHAR(128),
    prpr_fulfill_status_reason VARCHAR(1024),
    prpr_fulfill_status_datetime TIMESTAMP,
    prpr_req_decision_status_type VARCHAR(128),
    prpr_decision_status_unparsed_name VARCHAR(128),
    prpr_decision_status_reason VARCHAR(1024),
    prpr_decision_status_datetime TIMESTAMP,
    prpr_deal_pid BIGINT,
    prpr_proposal_pid BIGINT,
    prpr_loan_pid BIGINT,
    prpr_borrower_pid BIGINT,
    prpr_borrower_income_pid BIGINT,
    prpr_job_income_pid BIGINT,
    prpr_borrower_job_gap_pid BIGINT,
    prpr_other_income_pid BIGINT,
    prpr_business_income_pid BIGINT,
    prpr_rental_income_pid BIGINT,
    prpr_asset_pid BIGINT,
    prpr_asset_large_deposit_pid BIGINT,
    prpr_liability_pid BIGINT,
    prpr_reo_place_pid BIGINT,
    prpr_property_place_pid BIGINT,
    prpr_residence_place_pid BIGINT,
    prpr_borrower_residence_pid BIGINT,
    prpr_application_pid BIGINT,
    prpr_credit_inquiry_pid BIGINT,
    prpr_appraisal_pid BIGINT,
    prpr_appraisal_form_pid BIGINT,
    prpr_tax_transcript_request_pid BIGINT,
    prpr_deal_child_type VARCHAR(128),
    prpr_deal_child_name VARCHAR(767),
    prpr_smart_req BIT,
    prpr_smart_req_criteria_html TEXT,
    prpr_trash BIT,
    prpr_borrower_associated_address_pid BIGINT,
    prpr_construction_cost_pid BIGINT,
    prpr_construction_draw_pid BIGINT,
    prpr_proposal_contractor_pid BIGINT
);

CREATE TABLE history_octane.sap_deal_step
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sds_pid BIGINT NOT NULL,
    sds_version INTEGER,
    sds_borrower_user_pid BIGINT,
    sds_previous_pid BIGINT,
    sds_sap_step_type VARCHAR(128),
    sds_complete_datetime TIMESTAMP,
    sds_yes_no_answer VARCHAR(128),
    sds_deal_pid BIGINT,
    sds_borrower_pid BIGINT,
    sds_reo_pid BIGINT,
    sds_application_pid BIGINT,
    sds_job_income_pid BIGINT,
    sds_other_income_pid BIGINT,
    sds_borrower_residence_pid BIGINT,
    sds_asset_pid BIGINT,
    sds_liability_pid BIGINT,
    sds_deal_contact_pid BIGINT,
    sds_deal_real_estate_agent_pid BIGINT,
    sds_radio_choice_answer VARCHAR(32),
    sds_initial_values BIT,
    sds_business_income_pid BIGINT
);

CREATE TABLE history_octane.deal_sap
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dsap_pid BIGINT NOT NULL,
    dsap_version INTEGER,
    dsap_deal_pid BIGINT,
    dsap_last_sap_deal_step_pid BIGINT,
    dsap_last_sap_step_type VARCHAR(128),
    dsap_credit_pull_attempts INTEGER,
    dsap_retry_credit_pull BIT,
    dsap_borrower_step_type INTEGER
);

CREATE TABLE history_octane.trade
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    t_pid BIGINT NOT NULL,
    t_version INTEGER,
    t_account_pid BIGINT,
    t_investor_pid BIGINT,
    t_create_lender_user_pid BIGINT,
    t_create_datetime TIMESTAMP,
    t_lender_trade_id VARCHAR(11),
    t_investor_trade_id VARCHAR(32),
    t_investor_commitment_id VARCHAR(32),
    t_trade_name VARCHAR(128),
    t_trade_status_type VARCHAR(128),
    t_commitment_amount_tolerance_percent NUMERIC(11, 9),
    t_commitment_amount NUMERIC(15, 2),
    t_minimum_note_rate_percent NUMERIC(11, 9),
    t_maximum_note_rate_percent NUMERIC(11, 9),
    t_actual_delivery_datetime TIMESTAMP,
    t_early_delivery_datetime TIMESTAMP,
    t_required_delivery_datetime TIMESTAMP,
    t_commitment_expiration_datetime TIMESTAMP,
    t_commitment_datetime TIMESTAMP,
    t_purchase_datetime TIMESTAMP,
    t_weighted_average_note_rate_percent NUMERIC(11, 9),
    t_weighted_average_lender_price_percent NUMERIC(11, 9),
    t_weighted_average_investor_price_percent NUMERIC(11, 9),
    t_weighted_average_net_price_percent NUMERIC(11, 9),
    t_weighted_average_decision_credit_score INTEGER,
    t_average_loan_amount NUMERIC(15, 2),
    t_total_loan_amount NUMERIC(17, 2),
    t_loans_delivered_percent NUMERIC(11, 9),
    t_trade_pricing_type VARCHAR(128),
    t_trade_same_price_percent NUMERIC(11, 9),
    t_buy_up_multiple INTEGER,
    t_buy_down_multiple INTEGER
);

CREATE TABLE history_octane.investor_lock
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    il_pid BIGINT NOT NULL,
    il_version INTEGER,
    il_lender_lock_major_pid BIGINT,
    il_product_terms_pid BIGINT,
    il_mortgage_type VARCHAR(128),
    il_interest_only_type VARCHAR(128),
    il_buydown_schedule_type VARCHAR(128),
    il_prepay_penalty_schedule_type VARCHAR(128),
    il_lock_commitment_type VARCHAR(128),
    il_initial_duration_days INTEGER,
    il_commitment_datetime TIMESTAMP,
    il_initial_commitment_expiration_datetime TIMESTAMP,
    il_effective_commitment_expiration_datetime TIMESTAMP,
    il_effective_duration_days INTEGER,
    il_cancel_datetime TIMESTAMP,
    il_cancel_lender_user_pid BIGINT,
    il_cancel_unparsed_name VARCHAR(128),
    il_confirm_datetime TIMESTAMP,
    il_confirm_lender_user_pid BIGINT,
    il_confirm_unparsed_name VARCHAR(128),
    il_requester_lender_user_pid BIGINT,
    il_requester_unparsed_name VARCHAR(128),
    il_request_datetime TIMESTAMP,
    il_notes VARCHAR(16000),
    il_investor_base_note_rate_percent NUMERIC(11, 9),
    il_investor_base_arm_margin_percent NUMERIC(11, 9),
    il_investor_base_price_percent NUMERIC(11, 9),
    il_lock_note_rate_percent NUMERIC(11, 9),
    il_lock_initial_note_rate_percent NUMERIC(11, 9),
    il_lock_arm_margin_percent NUMERIC(11, 9),
    il_lock_price_percent NUMERIC(11, 9),
    il_lock_price_raw_percent NUMERIC(11, 9),
    il_maximum_rebate_percent NUMERIC(11, 9),
    il_trade_pid BIGINT,
    il_hedging BIT,
    il_investor_lock_status_type VARCHAR(128),
    il_investor_loan_id VARCHAR(32),
    il_required_delivery_datetime TIMESTAMP,
    il_investor_commitment_id VARCHAR(32)
);

CREATE TABLE history_octane.investor_lock_add_on
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ila_pid BIGINT NOT NULL,
    ila_version INTEGER,
    ila_investor_lock_pid BIGINT,
    ila_create_datetime TIMESTAMP,
    ila_creator_lender_user_pid BIGINT,
    ila_creator_unparsed_name VARCHAR(128),
    ila_summary VARCHAR(16000),
    ila_rate_adjustment_percent NUMERIC(11, 9),
    ila_price_adjustment_percent NUMERIC(11, 9),
    ila_arm_margin_adjustment_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.investor_lock_extension
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ile_pid BIGINT NOT NULL,
    ile_version INTEGER,
    ile_investor_lock_pid BIGINT,
    ile_creator_lender_user_pid BIGINT,
    ile_creator_unparsed_name VARCHAR(128),
    ile_requester_lender_user_pid BIGINT,
    ile_requester_unparsed_name VARCHAR(128),
    ile_requested_datetime TIMESTAMP,
    ile_confirm_lender_user_pid BIGINT,
    ile_confirm_unparsed_name VARCHAR(128),
    ile_confirm_datetime TIMESTAMP,
    ile_reject_lender_user_pid BIGINT,
    ile_reject_datetime TIMESTAMP,
    ile_reject_explanation VARCHAR(1024),
    ile_lock_extension_status_type VARCHAR(128),
    ile_extension_days INTEGER,
    ile_price_adjustment_percent NUMERIC(11, 9)
);

CREATE TABLE history_octane.trade_audit
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ta_pid BIGINT NOT NULL,
    ta_version INTEGER,
    ta_trade_pid BIGINT,
    ta_lender_lock_major_pid BIGINT,
    ta_trade_audit_type VARCHAR(128),
    ta_message VARCHAR(256)
);

CREATE TABLE history_octane.trade_fee
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    tfe_pid BIGINT NOT NULL,
    tfe_version INTEGER,
    tfe_trade_pid BIGINT,
    tfe_trade_fee_type_pid BIGINT,
    tfe_amount NUMERIC(15, 2),
    tfe_description VARCHAR(256)
);

CREATE TABLE history_octane.trade_file
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    tf_pid BIGINT NOT NULL,
    tf_version INTEGER,
    tf_trade_pid BIGINT,
    tf_repository_file_pid BIGINT
);

CREATE TABLE history_octane.trade_lock_filter
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    tlf_pid BIGINT NOT NULL,
    tlf_version INTEGER,
    tlf_lender_user_pid BIGINT,
    tlf_name VARCHAR(128),
    tlf_criteria_pid BIGINT
);

CREATE TABLE history_octane.trade_note
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    tn_pid BIGINT NOT NULL,
    tn_version INTEGER,
    tn_trade_pid BIGINT,
    tn_create_datetime TIMESTAMP,
    tn_content VARCHAR(16000),
    tn_author_lender_user_pid BIGINT,
    tn_author_unparsed_name VARCHAR(128)
);

CREATE TABLE history_octane.trade_note_comment
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    tnc_pid BIGINT NOT NULL,
    tnc_version INTEGER,
    tnc_trade_note_pid BIGINT,
    tnc_create_datetime TIMESTAMP,
    tnc_content VARCHAR(16000),
    tnc_author_lender_user_pid BIGINT,
    tnc_author_unparsed_name VARCHAR(128)
);

CREATE TABLE history_octane.trade_note_monitor
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    tnm_pid BIGINT NOT NULL,
    tnm_version INTEGER,
    tnm_trade_note_pid BIGINT,
    tnm_lender_user_pid BIGINT
);

CREATE TABLE history_octane.trade_product
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    tp_pid BIGINT NOT NULL,
    tp_version INTEGER,
    tp_product_pid BIGINT,
    tp_trade_pid BIGINT
);

CREATE TABLE history_octane.unpaid_balance_adjustment
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    upba_pid BIGINT NOT NULL,
    upba_version INTEGER,
    upba_investor_pid BIGINT,
    upba_adjustment_percent NUMERIC(11, 9),
    upba_from_date DATE,
    upba_mortgage_type VARCHAR(128)
);

CREATE TABLE history_octane.vendor_document_repository_file
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    vdrf_pid BIGINT NOT NULL,
    vdrf_version INTEGER,
    vdrf_account_pid BIGINT,
    vdrf_deal_pid BIGINT,
    vdrf_document_import_vendor_type VARCHAR(128),
    vdrf_client_filename VARCHAR(128),
    vdrf_client_filepath VARCHAR(256),
    vdrf_file_checksum VARCHAR(128),
    vdrf_vendor_import_document_type VARCHAR(128),
    vdrf_document_import_status_type VARCHAR(128),
    vdrf_processed_datetime TIMESTAMP
);

CREATE TABLE history_octane.deal_data_vendor_document_import
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ddvdi_pid BIGINT NOT NULL,
    ddvdi_version INTEGER,
    ddvdi_deal_pid BIGINT,
    ddvdi_vendor_document_repository_file_pid BIGINT,
    ddvdi_deal_system_file_pid BIGINT,
    ddvdi_vendor_import_document_type VARCHAR(128),
    ddvdi_create_datetime TIMESTAMP,
    ddvdi_document_import_status_type VARCHAR(128),
    ddvdi_failure_info VARCHAR(16000),
    ddvdi_warning_info VARCHAR(16000)
);

CREATE TABLE history_octane.vendor_document_event
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    vde_pid BIGINT NOT NULL,
    vde_version INTEGER,
    vde_account_pid BIGINT,
    vde_vendor_document_repository_file_pid BIGINT,
    vde_vendor_document_event_type VARCHAR(128),
    vde_source_unparsed_name VARCHAR(128),
    vde_messages TEXT,
    vde_create_datetime TIMESTAMP,
    vde_create_date DATE
);

CREATE TABLE history_octane.wf_deal_process
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    wdpr_pid BIGINT NOT NULL,
    wdpr_version INTEGER,
    wdpr_deal_pid BIGINT,
    wdpr_wf_process_pid BIGINT,
    wdpr_wf_deal_process_status_type VARCHAR(128),
    wdpr_process_start_datetime TIMESTAMP,
    wdpr_process_complete_datetime TIMESTAMP,
    wdpr_name VARCHAR(128)
);

CREATE TABLE history_octane.wf_step
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    ws_pid BIGINT NOT NULL,
    ws_version INTEGER,
    ws_wf_process_pid BIGINT,
    ws_step_name VARCHAR(128),
    ws_step_number NUMERIC(17, 5),
    ws_step_number_formatted VARCHAR(16),
    ws_step_number_name_formatted VARCHAR(128),
    ws_step_start_borrower_text VARCHAR(1024),
    ws_expected_complete_minutes INTEGER,
    ws_wf_step_timeout_type VARCHAR(128),
    ws_second_of_day_timeout INTEGER,
    ws_timeout_time_zone_type VARCHAR(128),
    ws_description VARCHAR(1024),
    ws_wf_step_type VARCHAR(128),
    ws_wf_phase_pid BIGINT,
    ws_wf_step_performer_assign_type VARCHAR(128),
    ws_role_pid BIGINT,
    ws_from_role_pid BIGINT,
    ws_wf_step_reassign_type VARCHAR(128),
    ws_wf_step_function_type VARCHAR(128),
    ws_sap_expire_minutes INTEGER,
    ws_sap_expire_warning_minutes INTEGER,
    ws_prompt_user_defined_time BIT,
    ws_smart_message_pid BIGINT,
    ws_smart_doc_set_pid BIGINT,
    ws_lien_priority_type VARCHAR(128),
    ws_active_only BIT,
    ws_internal BIT,
    ws_deal_stage_type VARCHAR(128),
    ws_polling_interval_type VARCHAR(128),
    ws_swappable BIT
);

CREATE TABLE history_octane.criteria_pid_operand
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    crpo_pid BIGINT NOT NULL,
    crpo_version INTEGER,
    crpo_criteria_pid BIGINT,
    crpo_criteria_pid_operand_type VARCHAR(128),
    crpo_lender_user_pid BIGINT,
    crpo_role_pid BIGINT,
    crpo_branch_pid BIGINT,
    crpo_wf_step_pid BIGINT,
    crpo_wf_phase_pid BIGINT,
    crpo_county_pid BIGINT,
    crpo_investor_pid BIGINT,
    crpo_product_pid BIGINT,
    crpo_lead_source_pid BIGINT,
    crpo_company_pid BIGINT,
    crpo_deal_tag_definition_pid BIGINT,
    crpo_creditor_pid BIGINT,
    crpo_interim_funder_pid BIGINT,
    crpo_settlement_agent_pid BIGINT,
    crpo_performer_team_pid BIGINT,
    crpo_third_party_community_second_program_pid BIGINT,
    crpo_offering_pid BIGINT,
    crpo_channel_pid BIGINT,
    crpo_account_grant_program_pid BIGINT,
    crpo_mortgage_credit_certificate_issuer_pid BIGINT,
    crpo_criteria_snippet_pid BIGINT,
    crpo_smart_doc_pid BIGINT
);

CREATE TABLE history_octane.smart_task
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    st_pid BIGINT NOT NULL,
    st_version INTEGER,
    st_wf_step_pid BIGINT,
    st_description VARCHAR(1024),
    st_from_date DATE,
    st_through_date DATE,
    st_wf_step_order INTEGER,
    st_criteria_pid BIGINT
);

CREATE TABLE history_octane.smart_task_tag_modifier
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    sttm_pid BIGINT NOT NULL,
    sttm_version INTEGER,
    sttm_deal_tag_definition_pid BIGINT,
    sttm_smart_task_pid BIGINT,
    sttm_add_tag BIT
);

CREATE TABLE history_octane.view_wf_deal_step_started
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    wds_pid BIGINT NOT NULL,
    wds_version INTEGER,
    wds_wf_step_pid BIGINT,
    wds_wf_deal_process_pid BIGINT,
    wds_performer_user_pid BIGINT,
    wds_visit_number INTEGER,
    wds_start_datetime TIMESTAMP,
    wds_complete_datetime TIMESTAMP,
    wds_timeout_datetime TIMESTAMP,
    wds_wf_deal_step_status_type VARCHAR(128),
    wds_wf_step_type VARCHAR(128),
    wds_function_error_list TEXT,
    wds_step_name VARCHAR(128),
    wds_step_number NUMERIC(17, 5),
    wds_step_number_formatted VARCHAR(16),
    wds_step_number_name_formatted VARCHAR(128),
    wds_expected_complete_minutes INTEGER,
    wds_description VARCHAR(1024),
    wds_wf_step_function_type VARCHAR(128),
    wds_phase_name VARCHAR(128),
    wds_phase_number INTEGER,
    wds_allow_check_override BIT,
    wds_deal_stage_pid BIGINT,
    wds_completing_user_pid BIGINT,
    wds_polling_interval_offset INTEGER,
    wds_materialized_view_trash BIT
);

CREATE TABLE history_octane.wf_deal_step
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    wds_pid BIGINT NOT NULL,
    wds_version INTEGER,
    wds_wf_step_pid BIGINT,
    wds_wf_deal_process_pid BIGINT,
    wds_performer_user_pid BIGINT,
    wds_visit_number INTEGER,
    wds_start_datetime TIMESTAMP,
    wds_complete_datetime TIMESTAMP,
    wds_timeout_datetime TIMESTAMP,
    wds_wf_deal_step_status_type VARCHAR(128),
    wds_wf_step_type VARCHAR(128),
    wds_function_error_list TEXT,
    wds_step_name VARCHAR(128),
    wds_step_number NUMERIC(17, 5),
    wds_step_number_formatted VARCHAR(16),
    wds_step_number_name_formatted VARCHAR(128),
    wds_expected_complete_minutes INTEGER,
    wds_description VARCHAR(1024),
    wds_wf_step_function_type VARCHAR(128),
    wds_phase_name VARCHAR(128),
    wds_phase_number INTEGER,
    wds_allow_check_override BIT,
    wds_deal_stage_pid BIGINT,
    wds_completing_user_pid BIGINT,
    wds_polling_interval_offset INTEGER
);

CREATE TABLE history_octane.deal_note
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dn_pid BIGINT NOT NULL,
    dn_version INTEGER,
    dn_deal_pid BIGINT,
    dn_create_datetime TIMESTAMP,
    dn_content VARCHAR(16000),
    dn_author_unparsed_name VARCHAR(128),
    dn_author_lender_user_pid BIGINT,
    dn_scope_type VARCHAR(128),
    dn_scope_name VARCHAR(1024),
    dn_wf_deal_step_pid BIGINT,
    dn_proposal_doc_pid BIGINT,
    dn_proposal_review_pid BIGINT
);

CREATE TABLE history_octane.deal_note_comment
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dnc_pid BIGINT NOT NULL,
    dnc_version INTEGER,
    dnc_deal_note_pid BIGINT,
    dnc_create_datetime TIMESTAMP,
    dnc_content VARCHAR(16000),
    dnc_author_unparsed_name VARCHAR(128),
    dnc_author_lender_user_pid BIGINT
);

CREATE TABLE history_octane.deal_note_monitor
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dnm_pid BIGINT NOT NULL,
    dnm_version INTEGER,
    dnm_deal_note_pid BIGINT,
    dnm_lender_user_pid BIGINT
);

CREATE TABLE history_octane.deal_note_role_tag
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dnrt_pid BIGINT NOT NULL,
    dnrt_version INTEGER,
    dnrt_deal_note_pid BIGINT,
    dnrt_role_pid BIGINT
);

CREATE TABLE history_octane.deal_task
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    dt_pid BIGINT NOT NULL,
    dt_version INTEGER,
    dt_wf_deal_step_pid BIGINT,
    dt_create_lender_user_name VARCHAR(128),
    dt_create_datetime TIMESTAMP,
    dt_description VARCHAR(1024),
    dt_complete_datetime TIMESTAMP,
    dt_deal_task_status_type VARCHAR(128),
    dt_smart_task BIT
);

CREATE TABLE history_octane.wf_deal_fork_process
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    wdfp_pid BIGINT NOT NULL,
    wdfp_version INTEGER,
    wdfp_wf_deal_step_pid BIGINT,
    wdfp_wf_deal_process_pid BIGINT
);

CREATE TABLE history_octane.wf_deal_function_queue
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    wdfq_pid BIGINT NOT NULL,
    wdfq_version INTEGER,
    wdfq_wf_deal_step_pid BIGINT,
    wdfq_worker_start_datetime TIMESTAMP,
    wdfq_halted BIT,
    wdfq_retry_count INTEGER
);

CREATE TABLE history_octane.wf_deal_outcome
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    wdo_pid BIGINT NOT NULL,
    wdo_version INTEGER,
    wdo_wf_deal_step_pid BIGINT,
    wdo_wf_outcome_type VARCHAR(128),
    wdo_outcome_name VARCHAR(128),
    wdo_borrower_message VARCHAR(1024),
    wdo_lender_description VARCHAR(256),
    wdo_incomplete_outcome BIT,
    wdo_transition_wf_deal_step_pid BIGINT
);

CREATE TABLE history_octane.wf_deal_step_timeout
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    wdst_pid BIGINT NOT NULL,
    wdst_version INTEGER,
    wdst_wf_deal_step_pid BIGINT,
    wdst_timeout_datetime TIMESTAMP
);

CREATE TABLE history_octane.wf_fork_process
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    wfp_pid BIGINT NOT NULL,
    wfp_version INTEGER,
    wfp_wf_step_pid BIGINT,
    wfp_wf_process_pid BIGINT
);

CREATE TABLE history_octane.wf_outcome
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    wo_pid BIGINT NOT NULL,
    wo_version INTEGER,
    wo_wf_step_pid BIGINT,
    wo_wf_outcome_type VARCHAR(128),
    wo_outcome_name VARCHAR(128),
    wo_ordinal INTEGER,
    wo_criteria_pid BIGINT,
    wo_borrower_message VARCHAR(1024),
    wo_lender_description VARCHAR(256),
    wo_incomplete_outcome BIT,
    wo_transition_wf_step_pid BIGINT
);

CREATE TABLE history_octane.wf_step_deal_check
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    wsdc_pid BIGINT NOT NULL,
    wsdc_version INTEGER,
    wsdc_wf_step_pid BIGINT,
    wsdc_deal_check_type VARCHAR(128),
    wsdc_deal_check_severity_type VARCHAR(128)
);

CREATE TABLE history_octane.wf_step_deal_check_definition
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    wsdd_pid BIGINT NOT NULL,
    wsdd_version INTEGER,
    wsdd_wf_step_pid BIGINT,
    wsdd_deal_check_type VARCHAR(128),
    wsdd_deal_check_severity_type VARCHAR(128)
);

CREATE TABLE history_octane.wf_step_deal_check_dependency
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    wsdp_pid BIGINT NOT NULL,
    wsdp_version INTEGER,
    wsdp_wf_step_pid BIGINT,
    wsdp_dependency_wf_step_pid BIGINT
);

CREATE TABLE history_octane.wf_step_deal_tag_modifier
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    wsdt_pid BIGINT NOT NULL,
    wsdt_version INTEGER,
    wsdt_deal_tag_definition_pid BIGINT,
    wsdt_wf_step_pid BIGINT,
    wsdt_add_tag BIT
);

CREATE TABLE history_octane.zip_code_info
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    zci_pid BIGINT NOT NULL,
    zci_version INTEGER,
    zci_zip_code VARCHAR(5),
    zci_latitude NUMERIC(9, 6),
    zci_longitude NUMERIC(9, 6)
);

CREATE TABLE history_octane.county_zip_code
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    czc_pid BIGINT NOT NULL,
    czc_version INTEGER,
    czc_county_pid BIGINT,
    czc_zip_code_info_pid BIGINT
);

CREATE TABLE history_octane.borrower_declarations
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    bdec_pid BIGINT NOT NULL,
    bdec_version INTEGER,
    bdec_borrower_pid BIGINT,
    bdec_fha_secondary_residence VARCHAR(128),
    bdec_relationship_with_seller VARCHAR(128),
    bdec_borrowed_funds_undisclosed VARCHAR(128),
    bdec_borrowed_funds_undisclosed_amount NUMERIC(15, 2),
    bdec_other_mortgage_in_progress_before_closing VARCHAR(128),
    bdec_applying_for_credit_before_closing VARCHAR(128),
    bdec_priority_given_to_another_lien VARCHAR(128),
    bdec_cosigner_undisclosed VARCHAR(128),
    bdec_currently_delinquent_federal_debt VARCHAR(128),
    bdec_party_to_lawsuit VARCHAR(128),
    bdec_conveyed_title_in_lieu_of_foreclosure VARCHAR(128),
    bdec_completed_pre_foreclosure_short_sale VARCHAR(128),
    bdec_property_foreclosure VARCHAR(128),
    bdec_bankruptcy_chapter_7 VARCHAR(128),
    bdec_bankruptcy_chapter_11 VARCHAR(128),
    bdec_bankruptcy_chapter_12 VARCHAR(128),
    bdec_bankruptcy_chapter_13 VARCHAR(128)
);

CREATE TABLE history_octane.minimum_required_residual_income_table
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    mrit_pid BIGINT NOT NULL,
    mrit_version INTEGER,
    mrit_effective_date DATE
);
CREATE TABLE history_octane.minimum_required_residual_income_row
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    mrir_pid BIGINT NOT NULL,
    mrir_version INTEGER,
    mrir_minimum_required_residual_income_table_pid BIGINT,
    mrir_state_type VARCHAR(16),
    mrir_household_size INTEGER,
    mrir_loan_amount_min NUMERIC(15, 2),
    mrir_loan_amount_max NUMERIC(15, 2),
    mrir_minimum_required_residual_income_amount NUMERIC(15, 2)
);

CREATE TABLE history_octane.new_lock_only_add_on
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    nlo_pid BIGINT NOT NULL,
    nlo_version INTEGER,
    nlo_account_pid BIGINT,
    nlo_add_on_prefix VARCHAR(32)
);

CREATE TABLE history_octane.doc_provider_group_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.doc_req_fulfill_status_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.trust_classification_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

CREATE TABLE history_octane.financed_property_improvements_category_type
(
    data_source_updated_datetime TIMESTAMP WITH TIME ZONE,
    data_source_deleted_flag BOOLEAN,
    code VARCHAR(128) NOT NULL,
    value VARCHAR(1024)
);

-- SQL for migration: history_octane
CREATE INDEX idx_account_event_type__data_source_deleted_flag ON history_octane.account_event_type (data_source_deleted_flag);
CREATE INDEX idx_account_id_sequence__data_source_deleted_flag ON history_octane.account_id_sequence (data_source_deleted_flag);
CREATE INDEX idx_account_status_type__data_source_deleted_flag ON history_octane.account_status_type (data_source_deleted_flag);
CREATE INDEX idx_account__data_source_deleted_flag ON history_octane.account (data_source_deleted_flag);
CREATE INDEX idx_account_event__data_source_deleted_flag ON history_octane.account_event (data_source_deleted_flag);
CREATE INDEX idx_admin_user_event_type__data_source_deleted_flag ON history_octane.admin_user_event_type (data_source_deleted_flag);
CREATE INDEX idx_admin_user_event__data_source_deleted_flag ON history_octane.admin_user_event (data_source_deleted_flag);
CREATE INDEX idx_admin_user_status_type__data_source_deleted_flag ON history_octane.admin_user_status_type (data_source_deleted_flag);
CREATE INDEX idx_agency_type__data_source_deleted_flag ON history_octane.agency_type (data_source_deleted_flag);
CREATE INDEX idx_agent_type__data_source_deleted_flag ON history_octane.agent_type (data_source_deleted_flag);
CREATE INDEX idx_announcement__data_source_deleted_flag ON history_octane.announcement (data_source_deleted_flag);
CREATE INDEX idx_annual_monthly_type__data_source_deleted_flag ON history_octane.annual_monthly_type (data_source_deleted_flag);
CREATE INDEX idx_applicant_role_type__data_source_deleted_flag ON history_octane.applicant_role_type (data_source_deleted_flag);
CREATE INDEX idx_application_taken_method_type__data_source_deleted_flag ON history_octane.application_taken_method_type (data_source_deleted_flag);
CREATE INDEX idx_application_type__data_source_deleted_flag ON history_octane.application_type (data_source_deleted_flag);
CREATE INDEX idx_appraisal_condition_type__data_source_deleted_flag ON history_octane.appraisal_condition_type (data_source_deleted_flag);
CREATE INDEX idx_appraisal_entry_contact_type__data_source_deleted_flag ON history_octane.appraisal_entry_contact_type (data_source_deleted_flag);
CREATE INDEX idx_appraisal_file_type__data_source_deleted_flag ON history_octane.appraisal_file_type (data_source_deleted_flag);
CREATE INDEX idx_appraisal_form_type__data_source_deleted_flag ON history_octane.appraisal_form_type (data_source_deleted_flag);
CREATE INDEX idx_appraisal_hold_reason_type__data_source_deleted_flag ON history_octane.appraisal_hold_reason_type (data_source_deleted_flag);
CREATE INDEX idx_appraisal_hold_type__data_source_deleted_flag ON history_octane.appraisal_hold_type (data_source_deleted_flag);
CREATE INDEX idx_appraisal_management_company_type__data_source_deleted_flag ON history_octane.appraisal_management_company_type (data_source_deleted_flag);
CREATE INDEX idx_814cd08aa1e2e72658e457a4e7e8bfc1 ON history_octane.appraisal_order_coarse_status_type (data_source_deleted_flag);
CREATE INDEX idx_appraisal_order_request_file_type__data_source_deleted_flag ON history_octane.appraisal_order_request_file_type (data_source_deleted_flag);
CREATE INDEX idx_appraisal_order_request_type__data_source_deleted_flag ON history_octane.appraisal_order_request_type (data_source_deleted_flag);
CREATE INDEX idx_appraisal_order_status_type__data_source_deleted_flag ON history_octane.appraisal_order_status_type (data_source_deleted_flag);
CREATE INDEX idx_appraisal_purpose_type__data_source_deleted_flag ON history_octane.appraisal_purpose_type (data_source_deleted_flag);
CREATE INDEX idx_appraisal_source_type__data_source_deleted_flag ON history_octane.appraisal_source_type (data_source_deleted_flag);
CREATE INDEX idx_appraisal_underwriter_type__data_source_deleted_flag ON history_octane.appraisal_underwriter_type (data_source_deleted_flag);
CREATE INDEX idx_area_median_income_table__data_source_deleted_flag ON history_octane.area_median_income_table (data_source_deleted_flag);
CREATE INDEX idx_arm_index_type__data_source_deleted_flag ON history_octane.arm_index_type (data_source_deleted_flag);
CREATE INDEX idx_arm_index_rate__data_source_deleted_flag ON history_octane.arm_index_rate (data_source_deleted_flag);
CREATE INDEX idx_asset_account_holder_type__data_source_deleted_flag ON history_octane.asset_account_holder_type (data_source_deleted_flag);
CREATE INDEX idx_asset_type__data_source_deleted_flag ON history_octane.asset_type (data_source_deleted_flag);
CREATE INDEX idx_aus_credit_service_type__data_source_deleted_flag ON history_octane.aus_credit_service_type (data_source_deleted_flag);
CREATE INDEX idx_aus_type__data_source_deleted_flag ON history_octane.aus_type (data_source_deleted_flag);
CREATE INDEX idx_backfill_status_type__data_source_deleted_flag ON history_octane.backfill_status_type (data_source_deleted_flag);
CREATE INDEX idx_bankruptcy_exception_type__data_source_deleted_flag ON history_octane.bankruptcy_exception_type (data_source_deleted_flag);
CREATE INDEX idx_bid_pool_status_type__data_source_deleted_flag ON history_octane.bid_pool_status_type (data_source_deleted_flag);
CREATE INDEX idx_bid_pool__data_source_deleted_flag ON history_octane.bid_pool (data_source_deleted_flag);
CREATE INDEX idx_492ba628157a869b6367305eb9bf483b ON history_octane.borrower_associated_address_explanation_type (data_source_deleted_flag);
CREATE INDEX idx_36999a2b3e2b80516decdd3b0f4f39db ON history_octane.borrower_associated_address_source_type (data_source_deleted_flag);
CREATE INDEX idx_borrower_income_category_type__data_source_deleted_flag ON history_octane.borrower_income_category_type (data_source_deleted_flag);
CREATE INDEX idx_borrower_relationship_type__data_source_deleted_flag ON history_octane.borrower_relationship_type (data_source_deleted_flag);
CREATE INDEX idx_borrower_residency_basis_type__data_source_deleted_flag ON history_octane.borrower_residency_basis_type (data_source_deleted_flag);
CREATE INDEX idx_borrower_tiny_id_type__data_source_deleted_flag ON history_octane.borrower_tiny_id_type (data_source_deleted_flag);
CREATE INDEX idx_borrower_user_account_status_type__data_source_deleted_flag ON history_octane.borrower_user_account_status_type (data_source_deleted_flag);
CREATE INDEX idx_borrower_user_deal_access_type__data_source_deleted_flag ON history_octane.borrower_user_deal_access_type (data_source_deleted_flag);
CREATE INDEX idx_branch_status_type__data_source_deleted_flag ON history_octane.branch_status_type (data_source_deleted_flag);
CREATE INDEX idx_building_status_type__data_source_deleted_flag ON history_octane.building_status_type (data_source_deleted_flag);
CREATE INDEX idx_business_disposition_type__data_source_deleted_flag ON history_octane.business_disposition_type (data_source_deleted_flag);
CREATE INDEX idx_business_income_type__data_source_deleted_flag ON history_octane.business_income_type (data_source_deleted_flag);
CREATE INDEX idx_business_ownership_type__data_source_deleted_flag ON history_octane.business_ownership_type (data_source_deleted_flag);
CREATE INDEX idx_buydown_base_date_type__data_source_deleted_flag ON history_octane.buydown_base_date_type (data_source_deleted_flag);
CREATE INDEX idx_buydown_contributor_type__data_source_deleted_flag ON history_octane.buydown_contributor_type (data_source_deleted_flag);
CREATE INDEX idx_buydown_schedule_type__data_source_deleted_flag ON history_octane.buydown_schedule_type (data_source_deleted_flag);
CREATE INDEX idx_buydown_subsidy_calculation_type__data_source_deleted_flag ON history_octane.buydown_subsidy_calculation_type (data_source_deleted_flag);
CREATE INDEX idx_calendar_rule_type__data_source_deleted_flag ON history_octane.calendar_rule_type (data_source_deleted_flag);
CREATE INDEX idx_challenge_question_type__data_source_deleted_flag ON history_octane.challenge_question_type (data_source_deleted_flag);
CREATE INDEX idx_channel_type__data_source_deleted_flag ON history_octane.channel_type (data_source_deleted_flag);
CREATE INDEX idx_channel__data_source_deleted_flag ON history_octane.channel (data_source_deleted_flag);
CREATE INDEX idx_charge_input_type__data_source_deleted_flag ON history_octane.charge_input_type (data_source_deleted_flag);
CREATE INDEX idx_charge_payee_type__data_source_deleted_flag ON history_octane.charge_payee_type (data_source_deleted_flag);
CREATE INDEX idx_charge_payer_type__data_source_deleted_flag ON history_octane.charge_payer_type (data_source_deleted_flag);
CREATE INDEX idx_charge_source_type__data_source_deleted_flag ON history_octane.charge_source_type (data_source_deleted_flag);
CREATE INDEX idx_charge_wire_action_type__data_source_deleted_flag ON history_octane.charge_wire_action_type (data_source_deleted_flag);
CREATE INDEX idx_circumstance_change_type__data_source_deleted_flag ON history_octane.circumstance_change_type (data_source_deleted_flag);
CREATE INDEX idx_citizenship_residency_type__data_source_deleted_flag ON history_octane.citizenship_residency_type (data_source_deleted_flag);
CREATE INDEX idx_clg_flood_cert_status_type__data_source_deleted_flag ON history_octane.clg_flood_cert_status_type (data_source_deleted_flag);
CREATE INDEX idx_closing_document_status_type__data_source_deleted_flag ON history_octane.closing_document_status_type (data_source_deleted_flag);
CREATE INDEX idx_coarse_event_type__data_source_deleted_flag ON history_octane.coarse_event_type (data_source_deleted_flag);
CREATE INDEX idx_community_lending_type__data_source_deleted_flag ON history_octane.community_lending_type (data_source_deleted_flag);
CREATE INDEX idx_company_admin_event_entity_type__data_source_deleted_flag ON history_octane.company_admin_event_entity_type (data_source_deleted_flag);
CREATE INDEX idx_company_admin_event__data_source_deleted_flag ON history_octane.company_admin_event (data_source_deleted_flag);
CREATE INDEX idx_company_state_license_type__data_source_deleted_flag ON history_octane.company_state_license_type (data_source_deleted_flag);
CREATE INDEX idx_config_export_permission_type__data_source_deleted_flag ON history_octane.config_export_permission_type (data_source_deleted_flag);
CREATE INDEX idx_construction_cost_category_type__data_source_deleted_flag ON history_octane.construction_cost_category_type (data_source_deleted_flag);
CREATE INDEX idx_construction_cost_funding_type__data_source_deleted_flag ON history_octane.construction_cost_funding_type (data_source_deleted_flag);
CREATE INDEX idx_construction_cost_payee_type__data_source_deleted_flag ON history_octane.construction_cost_payee_type (data_source_deleted_flag);
CREATE INDEX idx_construction_cost_status_type__data_source_deleted_flag ON history_octane.construction_cost_status_type (data_source_deleted_flag);
CREATE INDEX idx_construction_draw_status_type__data_source_deleted_flag ON history_octane.construction_draw_status_type (data_source_deleted_flag);
CREATE INDEX idx_construction_draw_type__data_source_deleted_flag ON history_octane.construction_draw_type (data_source_deleted_flag);
CREATE INDEX idx_1857202eb32daff0d6a880f5bcc27e58 ON history_octane.construction_lot_ownership_status_type (data_source_deleted_flag);
CREATE INDEX idx_consumer_privacy_request_type__data_source_deleted_flag ON history_octane.consumer_privacy_request_type (data_source_deleted_flag);
CREATE INDEX idx_cost_center__data_source_deleted_flag ON history_octane.cost_center (data_source_deleted_flag);
CREATE INDEX idx_country_type__data_source_deleted_flag ON history_octane.country_type (data_source_deleted_flag);
CREATE INDEX idx_account_contact__data_source_deleted_flag ON history_octane.account_contact (data_source_deleted_flag);
CREATE INDEX idx_courier_type__data_source_deleted_flag ON history_octane.courier_type (data_source_deleted_flag);
CREATE INDEX idx_credit_authorization_method_type__data_source_deleted_flag ON history_octane.credit_authorization_method_type (data_source_deleted_flag);
CREATE INDEX idx_credit_bureau_type__data_source_deleted_flag ON history_octane.credit_bureau_type (data_source_deleted_flag);
CREATE INDEX idx_credit_business_type__data_source_deleted_flag ON history_octane.credit_business_type (data_source_deleted_flag);
CREATE INDEX idx_credit_inquiry_explanation_type__data_source_deleted_flag ON history_octane.credit_inquiry_explanation_type (data_source_deleted_flag);
CREATE INDEX idx_credit_inquiry_result_type__data_source_deleted_flag ON history_octane.credit_inquiry_result_type (data_source_deleted_flag);
CREATE INDEX idx_credit_limit_type__data_source_deleted_flag ON history_octane.credit_limit_type (data_source_deleted_flag);
CREATE INDEX idx_credit_loan_type__data_source_deleted_flag ON history_octane.credit_loan_type (data_source_deleted_flag);
CREATE INDEX idx_credit_report_request_action_type__data_source_deleted_flag ON history_octane.credit_report_request_action_type (data_source_deleted_flag);
CREATE INDEX idx_credit_report_type__data_source_deleted_flag ON history_octane.credit_report_type (data_source_deleted_flag);
CREATE INDEX idx_credit_request_status_type__data_source_deleted_flag ON history_octane.credit_request_status_type (data_source_deleted_flag);
CREATE INDEX idx_credit_request_type__data_source_deleted_flag ON history_octane.credit_request_type (data_source_deleted_flag);
CREATE INDEX idx_credit_request_via_type__data_source_deleted_flag ON history_octane.credit_request_via_type (data_source_deleted_flag);
CREATE INDEX idx_credit_score_model_type__data_source_deleted_flag ON history_octane.credit_score_model_type (data_source_deleted_flag);
CREATE INDEX idx_criteria__data_source_deleted_flag ON history_octane.criteria (data_source_deleted_flag);
CREATE INDEX idx_criteria_owner_type__data_source_deleted_flag ON history_octane.criteria_owner_type (data_source_deleted_flag);
CREATE INDEX idx_criteria_pid_operand_type__data_source_deleted_flag ON history_octane.criteria_pid_operand_type (data_source_deleted_flag);
CREATE INDEX idx_custodian__data_source_deleted_flag ON history_octane.custodian (data_source_deleted_flag);
CREATE INDEX idx_days_per_year_type__data_source_deleted_flag ON history_octane.days_per_year_type (data_source_deleted_flag);
CREATE INDEX idx_deal_cancel_reason_type__data_source_deleted_flag ON history_octane.deal_cancel_reason_type (data_source_deleted_flag);
CREATE INDEX idx_deal_change_updater_time__data_source_deleted_flag ON history_octane.deal_change_updater_time (data_source_deleted_flag);
CREATE INDEX idx_deal_check_severity_type__data_source_deleted_flag ON history_octane.deal_check_severity_type (data_source_deleted_flag);
CREATE INDEX idx_deal_check_type__data_source_deleted_flag ON history_octane.deal_check_type (data_source_deleted_flag);
CREATE INDEX idx_deal_child_relationship_type__data_source_deleted_flag ON history_octane.deal_child_relationship_type (data_source_deleted_flag);
CREATE INDEX idx_deal_child_type__data_source_deleted_flag ON history_octane.deal_child_type (data_source_deleted_flag);
CREATE INDEX idx_criteria_snippet__data_source_deleted_flag ON history_octane.criteria_snippet (data_source_deleted_flag);
CREATE INDEX idx_deal_contact_role_type__data_source_deleted_flag ON history_octane.deal_contact_role_type (data_source_deleted_flag);
CREATE INDEX idx_deal_context_permission_type__data_source_deleted_flag ON history_octane.deal_context_permission_type (data_source_deleted_flag);
CREATE INDEX idx_deal_create_type__data_source_deleted_flag ON history_octane.deal_create_type (data_source_deleted_flag);
CREATE INDEX idx_deal_event_type__data_source_deleted_flag ON history_octane.deal_event_type (data_source_deleted_flag);
CREATE INDEX idx_deal_id_sequence__data_source_deleted_flag ON history_octane.deal_id_sequence (data_source_deleted_flag);
CREATE INDEX idx_deal_invoice_file_type__data_source_deleted_flag ON history_octane.deal_invoice_file_type (data_source_deleted_flag);
CREATE INDEX idx_deal_invoice_status_type__data_source_deleted_flag ON history_octane.deal_invoice_status_type (data_source_deleted_flag);
CREATE INDEX idx_deal_note_scope_type__data_source_deleted_flag ON history_octane.deal_note_scope_type (data_source_deleted_flag);
CREATE INDEX idx_deal_orphan_status_type__data_source_deleted_flag ON history_octane.deal_orphan_status_type (data_source_deleted_flag);
CREATE INDEX idx_deal_stage_type__data_source_deleted_flag ON history_octane.deal_stage_type (data_source_deleted_flag);
CREATE INDEX idx_deal_status_type__data_source_deleted_flag ON history_octane.deal_status_type (data_source_deleted_flag);
CREATE INDEX idx_deal_tag_access_type__data_source_deleted_flag ON history_octane.deal_tag_access_type (data_source_deleted_flag);
CREATE INDEX idx_deal_tag_level_type__data_source_deleted_flag ON history_octane.deal_tag_level_type (data_source_deleted_flag);
CREATE INDEX idx_deal_tag_definition__data_source_deleted_flag ON history_octane.deal_tag_definition (data_source_deleted_flag);
CREATE INDEX idx_deal_task_status_type__data_source_deleted_flag ON history_octane.deal_task_status_type (data_source_deleted_flag);
CREATE INDEX idx_decision_credit_score_calc_type__data_source_deleted_flag ON history_octane.decision_credit_score_calc_type (data_source_deleted_flag);
CREATE INDEX idx_delivery_aus_type__data_source_deleted_flag ON history_octane.delivery_aus_type (data_source_deleted_flag);
CREATE INDEX idx_73b1c2c28d6a8587497cd5a3b7c89508 ON history_octane.disaster_declaration_check_date_type (data_source_deleted_flag);
CREATE INDEX idx_doc_action_type__data_source_deleted_flag ON history_octane.doc_action_type (data_source_deleted_flag);
CREATE INDEX idx_doc_approval_type__data_source_deleted_flag ON history_octane.doc_approval_type (data_source_deleted_flag);
CREATE INDEX idx_doc_borrower_access_mode_type__data_source_deleted_flag ON history_octane.doc_borrower_access_mode_type (data_source_deleted_flag);
CREATE INDEX idx_doc_category_type__data_source_deleted_flag ON history_octane.doc_category_type (data_source_deleted_flag);
CREATE INDEX idx_doc_external_provider_type__data_source_deleted_flag ON history_octane.doc_external_provider_type (data_source_deleted_flag);
CREATE INDEX idx_doc_file_source_type__data_source_deleted_flag ON history_octane.doc_file_source_type (data_source_deleted_flag);
CREATE INDEX idx_doc_fulfill_status_type__data_source_deleted_flag ON history_octane.doc_fulfill_status_type (data_source_deleted_flag);
CREATE INDEX idx_doc_key_date_type__data_source_deleted_flag ON history_octane.doc_key_date_type (data_source_deleted_flag);
CREATE INDEX idx_doc_level_type__data_source_deleted_flag ON history_octane.doc_level_type (data_source_deleted_flag);
CREATE INDEX idx_doc_package_canceled_reason_type__data_source_deleted_flag ON history_octane.doc_package_canceled_reason_type (data_source_deleted_flag);
CREATE INDEX idx_doc_package_delivery_method_type__data_source_deleted_flag ON history_octane.doc_package_delivery_method_type (data_source_deleted_flag);
CREATE INDEX idx_doc_package_status_type__data_source_deleted_flag ON history_octane.doc_package_status_type (data_source_deleted_flag);
CREATE INDEX idx_doc_permission_type__data_source_deleted_flag ON history_octane.doc_permission_type (data_source_deleted_flag);
CREATE INDEX idx_doc_set_type__data_source_deleted_flag ON history_octane.doc_set_type (data_source_deleted_flag);
CREATE INDEX idx_doc_validity_type__data_source_deleted_flag ON history_octane.doc_validity_type (data_source_deleted_flag);
CREATE INDEX idx_document_import_status_type__data_source_deleted_flag ON history_octane.document_import_status_type (data_source_deleted_flag);
CREATE INDEX idx_document_import_vendor_type__data_source_deleted_flag ON history_octane.document_import_vendor_type (data_source_deleted_flag);
CREATE INDEX idx_du_key_finding_type__data_source_deleted_flag ON history_octane.du_key_finding_type (data_source_deleted_flag);
CREATE INDEX idx_du_recommendation_type__data_source_deleted_flag ON history_octane.du_recommendation_type (data_source_deleted_flag);
CREATE INDEX idx_du_request_status_type__data_source_deleted_flag ON history_octane.du_request_status_type (data_source_deleted_flag);
CREATE INDEX idx_dw_export_request_status_type__data_source_deleted_flag ON history_octane.dw_export_request_status_type (data_source_deleted_flag);
CREATE INDEX idx_ecoa_denial_reason_type__data_source_deleted_flag ON history_octane.ecoa_denial_reason_type (data_source_deleted_flag);
CREATE INDEX idx_a952d4e859c12d39678323b2e0cb9e5c ON history_octane.effective_property_value_explanation_type (data_source_deleted_flag);
CREATE INDEX idx_effective_property_value_type__data_source_deleted_flag ON history_octane.effective_property_value_type (data_source_deleted_flag);
CREATE INDEX idx_email_closing_type__data_source_deleted_flag ON history_octane.email_closing_type (data_source_deleted_flag);
CREATE INDEX idx_ernst_deed_request_type__data_source_deleted_flag ON history_octane.ernst_deed_request_type (data_source_deleted_flag);
CREATE INDEX idx_ernst_page_rec_type__data_source_deleted_flag ON history_octane.ernst_page_rec_type (data_source_deleted_flag);
CREATE INDEX idx_ernst_request_status_type__data_source_deleted_flag ON history_octane.ernst_request_status_type (data_source_deleted_flag);
CREATE INDEX idx_ffdba69d49b1d17e40080eb95abbe428 ON history_octane.ernst_security_instrument_request_type (data_source_deleted_flag);
CREATE INDEX idx_esign_package_status_type__data_source_deleted_flag ON history_octane.esign_package_status_type (data_source_deleted_flag);
CREATE INDEX idx_esign_vendor_type__data_source_deleted_flag ON history_octane.esign_vendor_type (data_source_deleted_flag);
CREATE INDEX idx_export_permission_type__data_source_deleted_flag ON history_octane.export_permission_type (data_source_deleted_flag);
CREATE INDEX idx_export_type__data_source_deleted_flag ON history_octane.export_type (data_source_deleted_flag);
CREATE INDEX idx_external_entity_type__data_source_deleted_flag ON history_octane.external_entity_type (data_source_deleted_flag);
CREATE INDEX idx_fault_tolerant_event_registration__data_source_deleted_flag ON history_octane.fault_tolerant_event_registration (data_source_deleted_flag);
CREATE INDEX idx_fema_flood_zone_designation_type__data_source_deleted_flag ON history_octane.fema_flood_zone_designation_type (data_source_deleted_flag);
CREATE INDEX idx_33b26a53c4e2f47089378308705b2139 ON history_octane.fha_non_arms_length_ltv_limit_exception_type (data_source_deleted_flag);
CREATE INDEX idx_fha_program_code_type__data_source_deleted_flag ON history_octane.fha_program_code_type (data_source_deleted_flag);
CREATE INDEX idx_fha_rehab_program_type__data_source_deleted_flag ON history_octane.fha_rehab_program_type (data_source_deleted_flag);
CREATE INDEX idx_fha_special_program_type__data_source_deleted_flag ON history_octane.fha_special_program_type (data_source_deleted_flag);
CREATE INDEX idx_d59ccb31fc6b7f09be63650acc255026 ON history_octane.fha_va_bor_cert_sales_price_exceeds_type (data_source_deleted_flag);
CREATE INDEX idx_field_type__data_source_deleted_flag ON history_octane.field_type (data_source_deleted_flag);
CREATE INDEX idx_flood_cert_vendor_type__data_source_deleted_flag ON history_octane.flood_cert_vendor_type (data_source_deleted_flag);
CREATE INDEX idx_flood_certificate_type__data_source_deleted_flag ON history_octane.flood_certificate_type (data_source_deleted_flag);
CREATE INDEX idx_fnm_arm_plan_type__data_source_deleted_flag ON history_octane.fnm_arm_plan_type (data_source_deleted_flag);
CREATE INDEX idx_1da5f1001322bbace6065847c50af3c5 ON history_octane.fnm_community_lending_product_type (data_source_deleted_flag);
CREATE INDEX idx_bda91c4279c1d40d1318c74fbf80ff48 ON history_octane.fnm_community_seconds_repayment_structure_type (data_source_deleted_flag);
CREATE INDEX idx_fnm_investor_remittance_type__data_source_deleted_flag ON history_octane.fnm_investor_remittance_type (data_source_deleted_flag);
CREATE INDEX idx_3bc08aae0ec468011183bcb59f07e9fc ON history_octane.fnm_mbs_loan_default_loss_party_type (data_source_deleted_flag);
CREATE INDEX idx_fnm_mbs_reo_marketing_party_type__data_source_deleted_flag ON history_octane.fnm_mbs_reo_marketing_party_type (data_source_deleted_flag);
CREATE INDEX idx_for_further_credit_type__data_source_deleted_flag ON history_octane.for_further_credit_type (data_source_deleted_flag);
CREATE INDEX idx_fre_community_program_type__data_source_deleted_flag ON history_octane.fre_community_program_type (data_source_deleted_flag);
CREATE INDEX idx_fre_ctp_closing_feature_type__data_source_deleted_flag ON history_octane.fre_ctp_closing_feature_type (data_source_deleted_flag);
CREATE INDEX idx_fre_ctp_closing_type__data_source_deleted_flag ON history_octane.fre_ctp_closing_type (data_source_deleted_flag);
CREATE INDEX idx_fre_doc_level_description_type__data_source_deleted_flag ON history_octane.fre_doc_level_description_type (data_source_deleted_flag);
CREATE INDEX idx_fre_purchase_eligibility_type__data_source_deleted_flag ON history_octane.fre_purchase_eligibility_type (data_source_deleted_flag);
CREATE INDEX idx_fund_source_type__data_source_deleted_flag ON history_octane.fund_source_type (data_source_deleted_flag);
CREATE INDEX idx_funding_status_type__data_source_deleted_flag ON history_octane.funding_status_type (data_source_deleted_flag);
CREATE INDEX idx_gender_type__data_source_deleted_flag ON history_octane.gender_type (data_source_deleted_flag);
CREATE INDEX idx_gift_funds_type__data_source_deleted_flag ON history_octane.gift_funds_type (data_source_deleted_flag);
CREATE INDEX idx_account_grant_program__data_source_deleted_flag ON history_octane.account_grant_program (data_source_deleted_flag);
CREATE INDEX idx_gse_version_type__data_source_deleted_flag ON history_octane.gse_version_type (data_source_deleted_flag);
CREATE INDEX idx_heloc_cancel_fee_applicable_type__data_source_deleted_flag ON history_octane.heloc_cancel_fee_applicable_type (data_source_deleted_flag);
CREATE INDEX idx_hmda_action_type__data_source_deleted_flag ON history_octane.hmda_action_type (data_source_deleted_flag);
CREATE INDEX idx_hmda_agency_id_type__data_source_deleted_flag ON history_octane.hmda_agency_id_type (data_source_deleted_flag);
CREATE INDEX idx_hmda_denial_reason_type__data_source_deleted_flag ON history_octane.hmda_denial_reason_type (data_source_deleted_flag);
CREATE INDEX idx_hmda_ethnicity_2017_type__data_source_deleted_flag ON history_octane.hmda_ethnicity_2017_type (data_source_deleted_flag);
CREATE INDEX idx_hmda_hoepa_status_type__data_source_deleted_flag ON history_octane.hmda_hoepa_status_type (data_source_deleted_flag);
CREATE INDEX idx_hmda_purchaser_of_loan_2017_type__data_source_deleted_flag ON history_octane.hmda_purchaser_of_loan_2017_type (data_source_deleted_flag);
CREATE INDEX idx_hmda_purchaser_of_loan_2018_type__data_source_deleted_flag ON history_octane.hmda_purchaser_of_loan_2018_type (data_source_deleted_flag);
CREATE INDEX idx_hmda_race_2017_type__data_source_deleted_flag ON history_octane.hmda_race_2017_type (data_source_deleted_flag);
CREATE INDEX idx_hoepa_thresholds__data_source_deleted_flag ON history_octane.hoepa_thresholds (data_source_deleted_flag);
CREATE INDEX idx_homeownership_education_type__data_source_deleted_flag ON history_octane.homeownership_education_type (data_source_deleted_flag);
CREATE INDEX idx_housing_counseling_agency_type__data_source_deleted_flag ON history_octane.housing_counseling_agency_type (data_source_deleted_flag);
CREATE INDEX idx_housing_counseling_type__data_source_deleted_flag ON history_octane.housing_counseling_type (data_source_deleted_flag);
CREATE INDEX idx_hud_fha_de_approval_type__data_source_deleted_flag ON history_octane.hud_fha_de_approval_type (data_source_deleted_flag);
CREATE INDEX idx_hve_confidence_level_type__data_source_deleted_flag ON history_octane.hve_confidence_level_type (data_source_deleted_flag);
CREATE INDEX idx_income_history_calc_method_type__data_source_deleted_flag ON history_octane.income_history_calc_method_type (data_source_deleted_flag);
CREATE INDEX idx_intent_to_proceed_type__data_source_deleted_flag ON history_octane.intent_to_proceed_type (data_source_deleted_flag);
CREATE INDEX idx_interest_only_type__data_source_deleted_flag ON history_octane.interest_only_type (data_source_deleted_flag);
CREATE INDEX idx_c63826906f239bf04b3cdbc7d7e78552 ON history_octane.interim_funder_mers_registration_type (data_source_deleted_flag);
CREATE INDEX idx_interim_funder__data_source_deleted_flag ON history_octane.interim_funder (data_source_deleted_flag);
CREATE INDEX idx_credit_limit__data_source_deleted_flag ON history_octane.credit_limit (data_source_deleted_flag);
CREATE INDEX idx_investor_group__data_source_deleted_flag ON history_octane.investor_group (data_source_deleted_flag);
CREATE INDEX idx_a2771b0861f095dd240d276b08f5df54 ON history_octane.investor_hmda_purchaser_of_loan_type (data_source_deleted_flag);
CREATE INDEX idx_investor_lock_status_type__data_source_deleted_flag ON history_octane.investor_lock_status_type (data_source_deleted_flag);
CREATE INDEX idx_invoice_item_category_type__data_source_deleted_flag ON history_octane.invoice_item_category_type (data_source_deleted_flag);
CREATE INDEX idx_invoice_payer_type__data_source_deleted_flag ON history_octane.invoice_payer_type (data_source_deleted_flag);
CREATE INDEX idx_invoice_payment_submission_type__data_source_deleted_flag ON history_octane.invoice_payment_submission_type (data_source_deleted_flag);
CREATE INDEX idx_ipc_calc_type__data_source_deleted_flag ON history_octane.ipc_calc_type (data_source_deleted_flag);
CREATE INDEX idx_ipc_comparison_operator_type__data_source_deleted_flag ON history_octane.ipc_comparison_operator_type (data_source_deleted_flag);
CREATE INDEX idx_ipc_property_usage_type__data_source_deleted_flag ON history_octane.ipc_property_usage_type (data_source_deleted_flag);
CREATE INDEX idx_job_gap_reason_type__data_source_deleted_flag ON history_octane.job_gap_reason_type (data_source_deleted_flag);
CREATE INDEX idx_key_creditor_type__data_source_deleted_flag ON history_octane.key_creditor_type (data_source_deleted_flag);
CREATE INDEX idx_key_doc_type__data_source_deleted_flag ON history_octane.key_doc_type (data_source_deleted_flag);
CREATE INDEX idx_key_package_type__data_source_deleted_flag ON history_octane.key_package_type (data_source_deleted_flag);
CREATE INDEX idx_key_role_type__data_source_deleted_flag ON history_octane.key_role_type (data_source_deleted_flag);
CREATE INDEX idx_lava_zone_type__data_source_deleted_flag ON history_octane.lava_zone_type (data_source_deleted_flag);
CREATE INDEX idx_legacy_role_assignment_type__data_source_deleted_flag ON history_octane.legacy_role_assignment_type (data_source_deleted_flag);
CREATE INDEX idx_legal_description_type__data_source_deleted_flag ON history_octane.legal_description_type (data_source_deleted_flag);
CREATE INDEX idx_legal_entity_type__data_source_deleted_flag ON history_octane.legal_entity_type (data_source_deleted_flag);
CREATE INDEX idx_90f853d3531b4628610f69426df6b09a ON history_octane.lender_concession_request_status_type (data_source_deleted_flag);
CREATE INDEX idx_lender_concession_request_type__data_source_deleted_flag ON history_octane.lender_concession_request_type (data_source_deleted_flag);
CREATE INDEX idx_lender_lock_id_ticker__data_source_deleted_flag ON history_octane.lender_lock_id_ticker (data_source_deleted_flag);
CREATE INDEX idx_lender_lock_status_type__data_source_deleted_flag ON history_octane.lender_lock_status_type (data_source_deleted_flag);
CREATE INDEX idx_lender_toolbox_permission_type__data_source_deleted_flag ON history_octane.lender_toolbox_permission_type (data_source_deleted_flag);
CREATE INDEX idx_lender_trade_id_ticker__data_source_deleted_flag ON history_octane.lender_trade_id_ticker (data_source_deleted_flag);
CREATE INDEX idx_6ad30f595f89302a1a5314bf0fba4f04 ON history_octane.lender_user_allowed_ip_status_type (data_source_deleted_flag);
CREATE INDEX idx_lender_user_interest__data_source_deleted_flag ON history_octane.lender_user_interest (data_source_deleted_flag);
CREATE INDEX idx_lender_user_interest_type__data_source_deleted_flag ON history_octane.lender_user_interest_type (data_source_deleted_flag);
CREATE INDEX idx_lender_user_language__data_source_deleted_flag ON history_octane.lender_user_language (data_source_deleted_flag);
CREATE INDEX idx_lender_user_language_type__data_source_deleted_flag ON history_octane.lender_user_language_type (data_source_deleted_flag);
CREATE INDEX idx_lender_user_notice_type__data_source_deleted_flag ON history_octane.lender_user_notice_type (data_source_deleted_flag);
CREATE INDEX idx_lender_user_reset_type__data_source_deleted_flag ON history_octane.lender_user_reset_type (data_source_deleted_flag);
CREATE INDEX idx_lender_user_role_queue_type__data_source_deleted_flag ON history_octane.lender_user_role_queue_type (data_source_deleted_flag);
CREATE INDEX idx_lender_user_status_type__data_source_deleted_flag ON history_octane.lender_user_status_type (data_source_deleted_flag);
CREATE INDEX idx_lender_user_type__data_source_deleted_flag ON history_octane.lender_user_type (data_source_deleted_flag);
CREATE INDEX idx_liability_account_ownership_type__data_source_deleted_flag ON history_octane.liability_account_ownership_type (data_source_deleted_flag);
CREATE INDEX idx_liability_account_status_type__data_source_deleted_flag ON history_octane.liability_account_status_type (data_source_deleted_flag);
CREATE INDEX idx_liability_current_rating_type__data_source_deleted_flag ON history_octane.liability_current_rating_type (data_source_deleted_flag);
CREATE INDEX idx_liability_disposition_type__data_source_deleted_flag ON history_octane.liability_disposition_type (data_source_deleted_flag);
CREATE INDEX idx_liability_energy_related_type__data_source_deleted_flag ON history_octane.liability_energy_related_type (data_source_deleted_flag);
CREATE INDEX idx_liability_financing_type__data_source_deleted_flag ON history_octane.liability_financing_type (data_source_deleted_flag);
CREATE INDEX idx_7f9483ebf552a06ab208ba5bad115d3d ON history_octane.liability_foreclosure_exception_type (data_source_deleted_flag);
CREATE INDEX idx_liability_mi_type__data_source_deleted_flag ON history_octane.liability_mi_type (data_source_deleted_flag);
CREATE INDEX idx_liability_type__data_source_deleted_flag ON history_octane.liability_type (data_source_deleted_flag);
CREATE INDEX idx_license_type__data_source_deleted_flag ON history_octane.license_type (data_source_deleted_flag);
CREATE INDEX idx_lien_priority_type__data_source_deleted_flag ON history_octane.lien_priority_type (data_source_deleted_flag);
CREATE INDEX idx_loan_access_type__data_source_deleted_flag ON history_octane.loan_access_type (data_source_deleted_flag);
CREATE INDEX idx_loan_amortization_type__data_source_deleted_flag ON history_octane.loan_amortization_type (data_source_deleted_flag);
CREATE INDEX idx_apor__data_source_deleted_flag ON history_octane.apor (data_source_deleted_flag);
CREATE INDEX idx_loan_benef_transfer_status_type__data_source_deleted_flag ON history_octane.loan_benef_transfer_status_type (data_source_deleted_flag);
CREATE INDEX idx_loan_file_delivery_method_type__data_source_deleted_flag ON history_octane.loan_file_delivery_method_type (data_source_deleted_flag);
CREATE INDEX idx_loan_limit_table_type__data_source_deleted_flag ON history_octane.loan_limit_table_type (data_source_deleted_flag);
CREATE INDEX idx_loan_limit_table__data_source_deleted_flag ON history_octane.loan_limit_table (data_source_deleted_flag);
CREATE INDEX idx_loan_limit_type__data_source_deleted_flag ON history_octane.loan_limit_type (data_source_deleted_flag);
CREATE INDEX idx_loan_position_type__data_source_deleted_flag ON history_octane.loan_position_type (data_source_deleted_flag);
CREATE INDEX idx_loan_purpose_type__data_source_deleted_flag ON history_octane.loan_purpose_type (data_source_deleted_flag);
CREATE INDEX idx_loan_safe_product_type__data_source_deleted_flag ON history_octane.loan_safe_product_type (data_source_deleted_flag);
CREATE INDEX idx_loans_toolbox_permission_type__data_source_deleted_flag ON history_octane.loans_toolbox_permission_type (data_source_deleted_flag);
CREATE INDEX idx_lock_add_on_type__data_source_deleted_flag ON history_octane.lock_add_on_type (data_source_deleted_flag);
CREATE INDEX idx_lock_commitment_type__data_source_deleted_flag ON history_octane.lock_commitment_type (data_source_deleted_flag);
CREATE INDEX idx_lock_extension_status_type__data_source_deleted_flag ON history_octane.lock_extension_status_type (data_source_deleted_flag);
CREATE INDEX idx_lock_term_setting__data_source_deleted_flag ON history_octane.lock_term_setting (data_source_deleted_flag);
CREATE INDEX idx_los_loan_id_ticker__data_source_deleted_flag ON history_octane.los_loan_id_ticker (data_source_deleted_flag);
CREATE INDEX idx_lp_case_state_type__data_source_deleted_flag ON history_octane.lp_case_state_type (data_source_deleted_flag);
CREATE INDEX idx_703bb4e3700d3629386f15d2e9100c83 ON history_octane.lp_credit_risk_classification_type (data_source_deleted_flag);
CREATE INDEX idx_lp_dtd_version_type__data_source_deleted_flag ON history_octane.lp_dtd_version_type (data_source_deleted_flag);
CREATE INDEX idx_lp_evaluation_status_type__data_source_deleted_flag ON history_octane.lp_evaluation_status_type (data_source_deleted_flag);
CREATE INDEX idx_lp_finding_message_type__data_source_deleted_flag ON history_octane.lp_finding_message_type (data_source_deleted_flag);
CREATE INDEX idx_lp_interface_version_type__data_source_deleted_flag ON history_octane.lp_interface_version_type (data_source_deleted_flag);
CREATE INDEX idx_lp_request_status_type__data_source_deleted_flag ON history_octane.lp_request_status_type (data_source_deleted_flag);
CREATE INDEX idx_lp_submission_type__data_source_deleted_flag ON history_octane.lp_submission_type (data_source_deleted_flag);
CREATE INDEX idx_lqa_purchase_eligibility_type__data_source_deleted_flag ON history_octane.lqa_purchase_eligibility_type (data_source_deleted_flag);
CREATE INDEX idx_lura_file_repository_type__data_source_deleted_flag ON history_octane.lura_file_repository_type (data_source_deleted_flag);
CREATE INDEX idx_lura_setting_type__data_source_deleted_flag ON history_octane.lura_setting_type (data_source_deleted_flag);
CREATE INDEX idx_45f06c6a371405e4b14730f32a14dce0 ON history_octane.manufactured_home_certificate_of_title_type (data_source_deleted_flag);
CREATE INDEX idx_2710d0c2e24d5dd0705026c5f3865755 ON history_octane.manufactured_home_leasehold_property_interest_type (data_source_deleted_flag);
CREATE INDEX idx_595a7f7c2ef56994fe49261d62e552a7 ON history_octane.manufactured_home_loan_purpose_type (data_source_deleted_flag);
CREATE INDEX idx_marital_status_type__data_source_deleted_flag ON history_octane.marital_status_type (data_source_deleted_flag);
CREATE INDEX idx_master_property_insurance_type__data_source_deleted_flag ON history_octane.master_property_insurance_type (data_source_deleted_flag);
CREATE INDEX idx_mcr_loan_status_type__data_source_deleted_flag ON history_octane.mcr_loan_status_type (data_source_deleted_flag);
CREATE INDEX idx_mercury_client_group__data_source_deleted_flag ON history_octane.mercury_client_group (data_source_deleted_flag);
CREATE INDEX idx_mercury_network_status_type__data_source_deleted_flag ON history_octane.mercury_network_status_type (data_source_deleted_flag);
CREATE INDEX idx_0dff87b1cb5f3583a454a5b4802fb79a ON history_octane.mers_daily_report_import_status_type (data_source_deleted_flag);
CREATE INDEX idx_mers_registration_status_type__data_source_deleted_flag ON history_octane.mers_registration_status_type (data_source_deleted_flag);
CREATE INDEX idx_mers_transfer_batch__data_source_deleted_flag ON history_octane.mers_transfer_batch (data_source_deleted_flag);
CREATE INDEX idx_mers_transfer_status_type__data_source_deleted_flag ON history_octane.mers_transfer_status_type (data_source_deleted_flag);
CREATE INDEX idx_mi_calculated_rate_type__data_source_deleted_flag ON history_octane.mi_calculated_rate_type (data_source_deleted_flag);
CREATE INDEX idx_mi_company_name_type__data_source_deleted_flag ON history_octane.mi_company_name_type (data_source_deleted_flag);
CREATE INDEX idx_mi_initial_calculation_type__data_source_deleted_flag ON history_octane.mi_initial_calculation_type (data_source_deleted_flag);
CREATE INDEX idx_mi_input_type__data_source_deleted_flag ON history_octane.mi_input_type (data_source_deleted_flag);
CREATE INDEX idx_mi_integration_request_type__data_source_deleted_flag ON history_octane.mi_integration_request_type (data_source_deleted_flag);
CREATE INDEX idx_09ab4afac5e772ecee63431f37640deb ON history_octane.mi_integration_vendor_request_status_type (data_source_deleted_flag);
CREATE INDEX idx_mi_payer_type__data_source_deleted_flag ON history_octane.mi_payer_type (data_source_deleted_flag);
CREATE INDEX idx_mi_payment_type__data_source_deleted_flag ON history_octane.mi_payment_type (data_source_deleted_flag);
CREATE INDEX idx_mi_premium_refundable_type__data_source_deleted_flag ON history_octane.mi_premium_refundable_type (data_source_deleted_flag);
CREATE INDEX idx_mi_renewal_calculation_type__data_source_deleted_flag ON history_octane.mi_renewal_calculation_type (data_source_deleted_flag);
CREATE INDEX idx_mi_submission_type__data_source_deleted_flag ON history_octane.mi_submission_type (data_source_deleted_flag);
CREATE INDEX idx_military_branch_type__data_source_deleted_flag ON history_octane.military_branch_type (data_source_deleted_flag);
CREATE INDEX idx_military_service_type__data_source_deleted_flag ON history_octane.military_service_type (data_source_deleted_flag);
CREATE INDEX idx_military_status_type__data_source_deleted_flag ON history_octane.military_status_type (data_source_deleted_flag);
CREATE INDEX idx_mismo_version_type__data_source_deleted_flag ON history_octane.mismo_version_type (data_source_deleted_flag);
CREATE INDEX idx_mortech_account__data_source_deleted_flag ON history_octane.mortech_account (data_source_deleted_flag);
CREATE INDEX idx_lead_source__data_source_deleted_flag ON history_octane.lead_source (data_source_deleted_flag);
CREATE INDEX idx_lead_campaign__data_source_deleted_flag ON history_octane.lead_campaign (data_source_deleted_flag);
CREATE INDEX idx_lead_supplemental_margin_table__data_source_deleted_flag ON history_octane.lead_supplemental_margin_table (data_source_deleted_flag);
CREATE INDEX idx_lead_supplemental_margin_row__data_source_deleted_flag ON history_octane.lead_supplemental_margin_row (data_source_deleted_flag);
CREATE INDEX idx_71e7976d369c0cd592bfdfeed89ca9ae ON history_octane.mortgage_credit_certificate_issuer (data_source_deleted_flag);
CREATE INDEX idx_mortgage_type__data_source_deleted_flag ON history_octane.mortgage_type (data_source_deleted_flag);
CREATE INDEX idx_native_american_lands_type__data_source_deleted_flag ON history_octane.native_american_lands_type (data_source_deleted_flag);
CREATE INDEX idx_negative_amortization_type__data_source_deleted_flag ON history_octane.negative_amortization_type (data_source_deleted_flag);
CREATE INDEX idx_neighborhood_location_type__data_source_deleted_flag ON history_octane.neighborhood_location_type (data_source_deleted_flag);
CREATE INDEX idx_net_tangible_benefit_type__data_source_deleted_flag ON history_octane.net_tangible_benefit_type (data_source_deleted_flag);
CREATE INDEX idx_20d9223d8a398acce5c11b47186277a2 ON history_octane.nfip_community_participation_status_type (data_source_deleted_flag);
CREATE INDEX idx_obligation_amount_input_type__data_source_deleted_flag ON history_octane.obligation_amount_input_type (data_source_deleted_flag);
CREATE INDEX idx_obligation_charge_input_type__data_source_deleted_flag ON history_octane.obligation_charge_input_type (data_source_deleted_flag);
CREATE INDEX idx_obligation_type__data_source_deleted_flag ON history_octane.obligation_type (data_source_deleted_flag);
CREATE INDEX idx_offering_group__data_source_deleted_flag ON history_octane.offering_group (data_source_deleted_flag);
CREATE INDEX idx_offering__data_source_deleted_flag ON history_octane.offering (data_source_deleted_flag);
CREATE INDEX idx_org_division__data_source_deleted_flag ON history_octane.org_division (data_source_deleted_flag);
CREATE INDEX idx_org_division_terms__data_source_deleted_flag ON history_octane.org_division_terms (data_source_deleted_flag);
CREATE INDEX idx_org_group__data_source_deleted_flag ON history_octane.org_group (data_source_deleted_flag);
CREATE INDEX idx_org_group_terms__data_source_deleted_flag ON history_octane.org_group_terms (data_source_deleted_flag);
CREATE INDEX idx_org_leader_position_type__data_source_deleted_flag ON history_octane.org_leader_position_type (data_source_deleted_flag);
CREATE INDEX idx_org_region__data_source_deleted_flag ON history_octane.org_region (data_source_deleted_flag);
CREATE INDEX idx_org_region_terms__data_source_deleted_flag ON history_octane.org_region_terms (data_source_deleted_flag);
CREATE INDEX idx_org_team__data_source_deleted_flag ON history_octane.org_team (data_source_deleted_flag);
CREATE INDEX idx_org_unit__data_source_deleted_flag ON history_octane.org_unit (data_source_deleted_flag);
CREATE INDEX idx_org_team_terms__data_source_deleted_flag ON history_octane.org_team_terms (data_source_deleted_flag);
CREATE INDEX idx_org_unit_terms__data_source_deleted_flag ON history_octane.org_unit_terms (data_source_deleted_flag);
CREATE INDEX idx_origination_source_type__data_source_deleted_flag ON history_octane.origination_source_type (data_source_deleted_flag);
CREATE INDEX idx_other_income_type__data_source_deleted_flag ON history_octane.other_income_type (data_source_deleted_flag);
CREATE INDEX idx_partial_payment_policy_type__data_source_deleted_flag ON history_octane.partial_payment_policy_type (data_source_deleted_flag);
CREATE INDEX idx_539a306f399b219c3e2825420e453dba ON history_octane.payment_adjustment_calculation_type (data_source_deleted_flag);
CREATE INDEX idx_payment_frequency_type__data_source_deleted_flag ON history_octane.payment_frequency_type (data_source_deleted_flag);
CREATE INDEX idx_payment_fulfill_type__data_source_deleted_flag ON history_octane.payment_fulfill_type (data_source_deleted_flag);
CREATE INDEX idx_payment_processing_company_type__data_source_deleted_flag ON history_octane.payment_processing_company_type (data_source_deleted_flag);
CREATE INDEX idx_payment_request_type__data_source_deleted_flag ON history_octane.payment_request_type (data_source_deleted_flag);
CREATE INDEX idx_payment_structure_type__data_source_deleted_flag ON history_octane.payment_structure_type (data_source_deleted_flag);
CREATE INDEX idx_payment_type__data_source_deleted_flag ON history_octane.payment_type (data_source_deleted_flag);
CREATE INDEX idx_payoff_request_delivery_type__data_source_deleted_flag ON history_octane.payoff_request_delivery_type (data_source_deleted_flag);
CREATE INDEX idx_performer_team__data_source_deleted_flag ON history_octane.performer_team (data_source_deleted_flag);
CREATE INDEX idx_polling_interval_type__data_source_deleted_flag ON history_octane.polling_interval_type (data_source_deleted_flag);
CREATE INDEX idx_prepaid_interest_rate_type__data_source_deleted_flag ON history_octane.prepaid_interest_rate_type (data_source_deleted_flag);
CREATE INDEX idx_prepay_penalty_schedule_type__data_source_deleted_flag ON history_octane.prepay_penalty_schedule_type (data_source_deleted_flag);
CREATE INDEX idx_prepay_penalty_type__data_source_deleted_flag ON history_octane.prepay_penalty_type (data_source_deleted_flag);
CREATE INDEX idx_price_processing_time__data_source_deleted_flag ON history_octane.price_processing_time (data_source_deleted_flag);
CREATE INDEX idx_pricing_engine_type__data_source_deleted_flag ON history_octane.pricing_engine_type (data_source_deleted_flag);
CREATE INDEX idx_prior_property_title_type__data_source_deleted_flag ON history_octane.prior_property_title_type (data_source_deleted_flag);
CREATE INDEX idx_prior_to_type__data_source_deleted_flag ON history_octane.prior_to_type (data_source_deleted_flag);
CREATE INDEX idx_716e649ac0f4d0b732c45ae8799b788b ON history_octane.product_appraisal_requirement_type (data_source_deleted_flag);
CREATE INDEX idx_product_rule_domain_input_type__data_source_deleted_flag ON history_octane.product_rule_domain_input_type (data_source_deleted_flag);
CREATE INDEX idx_product_side_type__data_source_deleted_flag ON history_octane.product_side_type (data_source_deleted_flag);
CREATE INDEX idx_product_special_program_type__data_source_deleted_flag ON history_octane.product_special_program_type (data_source_deleted_flag);
CREATE INDEX idx_profit_margin_type__data_source_deleted_flag ON history_octane.profit_margin_type (data_source_deleted_flag);
CREATE INDEX idx_project_classification_type__data_source_deleted_flag ON history_octane.project_classification_type (data_source_deleted_flag);
CREATE INDEX idx_project_design_type__data_source_deleted_flag ON history_octane.project_design_type (data_source_deleted_flag);
CREATE INDEX idx_property_category_type__data_source_deleted_flag ON history_octane.property_category_type (data_source_deleted_flag);
CREATE INDEX idx_c1bd00e55a14c0493dfe906b6a5f72c5 ON history_octane.property_repairs_holdback_calc_type (data_source_deleted_flag);
CREATE INDEX idx_fa1973fc5c41395e0289f5ad99b04835 ON history_octane.property_repairs_holdback_payer_type (data_source_deleted_flag);
CREATE INDEX idx_property_repairs_required_type__data_source_deleted_flag ON history_octane.property_repairs_required_type (data_source_deleted_flag);
CREATE INDEX idx_property_rights_type__data_source_deleted_flag ON history_octane.property_rights_type (data_source_deleted_flag);
CREATE INDEX idx_property_usage_type__data_source_deleted_flag ON history_octane.property_usage_type (data_source_deleted_flag);
CREATE INDEX idx_proposal_doc_file_type__data_source_deleted_flag ON history_octane.proposal_doc_file_type (data_source_deleted_flag);
CREATE INDEX idx_proposal_review_status_type__data_source_deleted_flag ON history_octane.proposal_review_status_type (data_source_deleted_flag);
CREATE INDEX idx_proposal_structure_type__data_source_deleted_flag ON history_octane.proposal_structure_type (data_source_deleted_flag);
CREATE INDEX idx_proposal_type__data_source_deleted_flag ON history_octane.proposal_type (data_source_deleted_flag);
CREATE INDEX idx_pte_request_status_type__data_source_deleted_flag ON history_octane.pte_request_status_type (data_source_deleted_flag);
CREATE INDEX idx_pte_response_status_type__data_source_deleted_flag ON history_octane.pte_response_status_type (data_source_deleted_flag);
CREATE INDEX idx_public_record_disposition_type__data_source_deleted_flag ON history_octane.public_record_disposition_type (data_source_deleted_flag);
CREATE INDEX idx_public_record_type__data_source_deleted_flag ON history_octane.public_record_type (data_source_deleted_flag);
CREATE INDEX idx_qualified_mortgage_status_type__data_source_deleted_flag ON history_octane.qualified_mortgage_status_type (data_source_deleted_flag);
CREATE INDEX idx_qualified_mortgage_thresholds__data_source_deleted_flag ON history_octane.qualified_mortgage_thresholds (data_source_deleted_flag);
CREATE INDEX idx_qualifying_monthly_payment_type__data_source_deleted_flag ON history_octane.qualifying_monthly_payment_type (data_source_deleted_flag);
CREATE INDEX idx_qualifying_rate_type__data_source_deleted_flag ON history_octane.qualifying_rate_type (data_source_deleted_flag);
CREATE INDEX idx_quarter_type__data_source_deleted_flag ON history_octane.quarter_type (data_source_deleted_flag);
CREATE INDEX idx_mcr_snapshot__data_source_deleted_flag ON history_octane.mcr_snapshot (data_source_deleted_flag);
CREATE INDEX idx_mcr_loan__data_source_deleted_flag ON history_octane.mcr_loan (data_source_deleted_flag);
CREATE INDEX idx_quote_filter_pivot_type__data_source_deleted_flag ON history_octane.quote_filter_pivot_type (data_source_deleted_flag);
CREATE INDEX idx_realty_agent_scenario_type__data_source_deleted_flag ON history_octane.realty_agent_scenario_type (data_source_deleted_flag);
CREATE INDEX idx_recording_district_type__data_source_deleted_flag ON history_octane.recording_district_type (data_source_deleted_flag);
CREATE INDEX idx_refinance_improvements_type__data_source_deleted_flag ON history_octane.refinance_improvements_type (data_source_deleted_flag);
CREATE INDEX idx_relock_fee_setting__data_source_deleted_flag ON history_octane.relock_fee_setting (data_source_deleted_flag);
CREATE INDEX idx_reo_disposition_status_type__data_source_deleted_flag ON history_octane.reo_disposition_status_type (data_source_deleted_flag);
CREATE INDEX idx_report_request_status_type__data_source_deleted_flag ON history_octane.report_request_status_type (data_source_deleted_flag);
CREATE INDEX idx_report_type__data_source_deleted_flag ON history_octane.report_type (data_source_deleted_flag);
CREATE INDEX idx_report__data_source_deleted_flag ON history_octane.report (data_source_deleted_flag);
CREATE INDEX idx_report_row__data_source_deleted_flag ON history_octane.report_row (data_source_deleted_flag);
CREATE INDEX idx_formula_report_column__data_source_deleted_flag ON history_octane.formula_report_column (data_source_deleted_flag);
CREATE INDEX idx_report_column__data_source_deleted_flag ON history_octane.report_column (data_source_deleted_flag);
CREATE INDEX idx_req_decision_status_type__data_source_deleted_flag ON history_octane.req_decision_status_type (data_source_deleted_flag);
CREATE INDEX idx_req_fulfill_status_type__data_source_deleted_flag ON history_octane.req_fulfill_status_type (data_source_deleted_flag);
CREATE INDEX idx_rescission_notification_type__data_source_deleted_flag ON history_octane.rescission_notification_type (data_source_deleted_flag);
CREATE INDEX idx_respa_section_type__data_source_deleted_flag ON history_octane.respa_section_type (data_source_deleted_flag);
CREATE INDEX idx_charge_type__data_source_deleted_flag ON history_octane.charge_type (data_source_deleted_flag);
CREATE INDEX idx_road_type__data_source_deleted_flag ON history_octane.road_type (data_source_deleted_flag);
CREATE INDEX idx_role__data_source_deleted_flag ON history_octane.role (data_source_deleted_flag);
CREATE INDEX idx_key_role__data_source_deleted_flag ON history_octane.key_role (data_source_deleted_flag);
CREATE INDEX idx_role_charge_permissions__data_source_deleted_flag ON history_octane.role_charge_permissions (data_source_deleted_flag);
CREATE INDEX idx_role_config_export_permission__data_source_deleted_flag ON history_octane.role_config_export_permission (data_source_deleted_flag);
CREATE INDEX idx_role_deal_context__data_source_deleted_flag ON history_octane.role_deal_context (data_source_deleted_flag);
CREATE INDEX idx_role_export_permission__data_source_deleted_flag ON history_octane.role_export_permission (data_source_deleted_flag);
CREATE INDEX idx_role_lender_toolbox__data_source_deleted_flag ON history_octane.role_lender_toolbox (data_source_deleted_flag);
CREATE INDEX idx_role_loans_toolbox__data_source_deleted_flag ON history_octane.role_loans_toolbox (data_source_deleted_flag);
CREATE INDEX idx_role_performer_assign__data_source_deleted_flag ON history_octane.role_performer_assign (data_source_deleted_flag);
CREATE INDEX idx_role_report__data_source_deleted_flag ON history_octane.role_report (data_source_deleted_flag);
CREATE INDEX idx_sanitation_type__data_source_deleted_flag ON history_octane.sanitation_type (data_source_deleted_flag);
CREATE INDEX idx_sap_step_type__data_source_deleted_flag ON history_octane.sap_step_type (data_source_deleted_flag);
CREATE INDEX idx_secondary_admin_event_entity_type__data_source_deleted_flag ON history_octane.secondary_admin_event_entity_type (data_source_deleted_flag);
CREATE INDEX idx_secondary_admin_event__data_source_deleted_flag ON history_octane.secondary_admin_event (data_source_deleted_flag);
CREATE INDEX idx_section_of_act_coarse_type__data_source_deleted_flag ON history_octane.section_of_act_coarse_type (data_source_deleted_flag);
CREATE INDEX idx_security_instrument_type__data_source_deleted_flag ON history_octane.security_instrument_type (data_source_deleted_flag);
CREATE INDEX idx_senior_lien_restriction_type__data_source_deleted_flag ON history_octane.senior_lien_restriction_type (data_source_deleted_flag);
CREATE INDEX idx_servicer_loan_id_assign_type__data_source_deleted_flag ON history_octane.servicer_loan_id_assign_type (data_source_deleted_flag);
CREATE INDEX idx_a6d0e1d3fcf9c9932e2e1234ad1d82b9 ON history_octane.servicer_loan_id_import_request_status_type (data_source_deleted_flag);
CREATE INDEX idx_servicing_transfer_type__data_source_deleted_flag ON history_octane.servicing_transfer_type (data_source_deleted_flag);
CREATE INDEX idx_settlement_agent__data_source_deleted_flag ON history_octane.settlement_agent (data_source_deleted_flag);
CREATE INDEX idx_settlement_agent_office__data_source_deleted_flag ON history_octane.settlement_agent_office (data_source_deleted_flag);
CREATE INDEX idx_settlement_agent_wire__data_source_deleted_flag ON history_octane.settlement_agent_wire (data_source_deleted_flag);
CREATE INDEX idx_sheet_format_type__data_source_deleted_flag ON history_octane.sheet_format_type (data_source_deleted_flag);
CREATE INDEX idx_google_sheet_export__data_source_deleted_flag ON history_octane.google_sheet_export (data_source_deleted_flag);
CREATE INDEX idx_signature_part_type__data_source_deleted_flag ON history_octane.signature_part_type (data_source_deleted_flag);
CREATE INDEX idx_site_allowed_ip__data_source_deleted_flag ON history_octane.site_allowed_ip (data_source_deleted_flag);
CREATE INDEX idx_smart_charge_apr_type__data_source_deleted_flag ON history_octane.smart_charge_apr_type (data_source_deleted_flag);
CREATE INDEX idx_smart_charge__data_source_deleted_flag ON history_octane.smart_charge (data_source_deleted_flag);
CREATE INDEX idx_smart_charge_group__data_source_deleted_flag ON history_octane.smart_charge_group (data_source_deleted_flag);
CREATE INDEX idx_smart_charge_group_case__data_source_deleted_flag ON history_octane.smart_charge_group_case (data_source_deleted_flag);
CREATE INDEX idx_smart_charge_case__data_source_deleted_flag ON history_octane.smart_charge_case (data_source_deleted_flag);
CREATE INDEX idx_smart_message_delivery_type__data_source_deleted_flag ON history_octane.smart_message_delivery_type (data_source_deleted_flag);
CREATE INDEX idx_d2fc7d37027b873fdda165ddf2bc667d ON history_octane.smart_message_email_recipient_type (data_source_deleted_flag);
CREATE INDEX idx_smart_message_recipient_type__data_source_deleted_flag ON history_octane.smart_message_recipient_type (data_source_deleted_flag);
CREATE INDEX idx_smart_message_source_type__data_source_deleted_flag ON history_octane.smart_message_source_type (data_source_deleted_flag);
CREATE INDEX idx_smart_mi__data_source_deleted_flag ON history_octane.smart_mi (data_source_deleted_flag);
CREATE INDEX idx_smart_mi_eligibility_case__data_source_deleted_flag ON history_octane.smart_mi_eligibility_case (data_source_deleted_flag);
CREATE INDEX idx_smart_mi_rate_card__data_source_deleted_flag ON history_octane.smart_mi_rate_card (data_source_deleted_flag);
CREATE INDEX idx_smart_mi_rate_adjustment_case__data_source_deleted_flag ON history_octane.smart_mi_rate_adjustment_case (data_source_deleted_flag);
CREATE INDEX idx_smart_mi_rate_case__data_source_deleted_flag ON history_octane.smart_mi_rate_case (data_source_deleted_flag);
CREATE INDEX idx_smart_mi_surcharge__data_source_deleted_flag ON history_octane.smart_mi_surcharge (data_source_deleted_flag);
CREATE INDEX idx_smart_mi_surcharge_case__data_source_deleted_flag ON history_octane.smart_mi_surcharge_case (data_source_deleted_flag);
CREATE INDEX idx_smart_stack__data_source_deleted_flag ON history_octane.smart_stack (data_source_deleted_flag);
CREATE INDEX idx_5c4005d0fddc17c523757df5dbf67392 ON history_octane.smart_stack_doc_set_include_option_type (data_source_deleted_flag);
CREATE INDEX idx_smart_doc_set__data_source_deleted_flag ON history_octane.smart_doc_set (data_source_deleted_flag);
CREATE INDEX idx_key_package__data_source_deleted_flag ON history_octane.key_package (data_source_deleted_flag);
CREATE INDEX idx_smart_stack_doc_set_include_type__data_source_deleted_flag ON history_octane.smart_stack_doc_set_include_type (data_source_deleted_flag);
CREATE INDEX idx_solar_panel_type__data_source_deleted_flag ON history_octane.solar_panel_type (data_source_deleted_flag);
CREATE INDEX idx_stack_doc_type__data_source_deleted_flag ON history_octane.stack_doc_type (data_source_deleted_flag);
CREATE INDEX idx_a59d745759acb87020fbd4ada6ca4a3c ON history_octane.stack_export_file_name_format_type (data_source_deleted_flag);
CREATE INDEX idx_stack_export_file_type__data_source_deleted_flag ON history_octane.stack_export_file_type (data_source_deleted_flag);
CREATE INDEX idx_3dc2cabc994c0f5321e22ec82d56f05e ON history_octane.stack_export_loan_name_format_type (data_source_deleted_flag);
CREATE INDEX idx_782172dfbbafe081637d5817cd310c07 ON history_octane.stack_export_request_loan_export_type (data_source_deleted_flag);
CREATE INDEX idx_stack_export_request_status_type__data_source_deleted_flag ON history_octane.stack_export_request_status_type (data_source_deleted_flag);
CREATE INDEX idx_state_type__data_source_deleted_flag ON history_octane.state_type (data_source_deleted_flag);
CREATE INDEX idx_county__data_source_deleted_flag ON history_octane.county (data_source_deleted_flag);
CREATE INDEX idx_area_median_income_row__data_source_deleted_flag ON history_octane.area_median_income_row (data_source_deleted_flag);
CREATE INDEX idx_county_city__data_source_deleted_flag ON history_octane.county_city (data_source_deleted_flag);
CREATE INDEX idx_county_sub_jurisdiction__data_source_deleted_flag ON history_octane.county_sub_jurisdiction (data_source_deleted_flag);
CREATE INDEX idx_disaster_declaration__data_source_deleted_flag ON history_octane.disaster_declaration (data_source_deleted_flag);
CREATE INDEX idx_license_req__data_source_deleted_flag ON history_octane.license_req (data_source_deleted_flag);
CREATE INDEX idx_loan_limit_row__data_source_deleted_flag ON history_octane.loan_limit_row (data_source_deleted_flag);
CREATE INDEX idx_recording_city__data_source_deleted_flag ON history_octane.recording_city (data_source_deleted_flag);
CREATE INDEX idx_recording_district__data_source_deleted_flag ON history_octane.recording_district (data_source_deleted_flag);
CREATE INDEX idx_county_recording_district__data_source_deleted_flag ON history_octane.county_recording_district (data_source_deleted_flag);
CREATE INDEX idx_region_ernst_page_rec__data_source_deleted_flag ON history_octane.region_ernst_page_rec (data_source_deleted_flag);
CREATE INDEX idx_street_links_product_type__data_source_deleted_flag ON history_octane.street_links_product_type (data_source_deleted_flag);
CREATE INDEX idx_stripe_payment_status_type__data_source_deleted_flag ON history_octane.stripe_payment_status_type (data_source_deleted_flag);
CREATE INDEX idx_stripe_payment__data_source_deleted_flag ON history_octane.stripe_payment (data_source_deleted_flag);
CREATE INDEX idx_tax_filing_status_type__data_source_deleted_flag ON history_octane.tax_filing_status_type (data_source_deleted_flag);
CREATE INDEX idx_f796fadd84b7ddf44940c6fbcb745d37 ON history_octane.tax_transcript_request_status_type (data_source_deleted_flag);
CREATE INDEX idx_taxpayer_identifier_type__data_source_deleted_flag ON history_octane.taxpayer_identifier_type (data_source_deleted_flag);
CREATE INDEX idx_contractor__data_source_deleted_flag ON history_octane.contractor (data_source_deleted_flag);
CREATE INDEX idx_contractor_license__data_source_deleted_flag ON history_octane.contractor_license (data_source_deleted_flag);
CREATE INDEX idx_c6c9eaa644f24a2b226bcc9f8e6af26d ON history_octane.third_party_community_second_program_eligibility_type (data_source_deleted_flag);
CREATE INDEX idx_time_zone_type__data_source_deleted_flag ON history_octane.time_zone_type (data_source_deleted_flag);
CREATE INDEX idx_admin_user__data_source_deleted_flag ON history_octane.admin_user (data_source_deleted_flag);
CREATE INDEX idx_borrower_user__data_source_deleted_flag ON history_octane.borrower_user (data_source_deleted_flag);
CREATE INDEX idx_timeout_time_zone_type__data_source_deleted_flag ON history_octane.timeout_time_zone_type (data_source_deleted_flag);
CREATE INDEX idx_title_company__data_source_deleted_flag ON history_octane.title_company (data_source_deleted_flag);
CREATE INDEX idx_title_company_office__data_source_deleted_flag ON history_octane.title_company_office (data_source_deleted_flag);
CREATE INDEX idx_preferred_settlement__data_source_deleted_flag ON history_octane.preferred_settlement (data_source_deleted_flag);
CREATE INDEX idx_title_manner_held_type__data_source_deleted_flag ON history_octane.title_manner_held_type (data_source_deleted_flag);
CREATE INDEX idx_total_expert_account_type__data_source_deleted_flag ON history_octane.total_expert_account_type (data_source_deleted_flag);
CREATE INDEX idx_trade_audit_type__data_source_deleted_flag ON history_octane.trade_audit_type (data_source_deleted_flag);
CREATE INDEX idx_trade_fee_type__data_source_deleted_flag ON history_octane.trade_fee_type (data_source_deleted_flag);
CREATE INDEX idx_trade_pricing_type__data_source_deleted_flag ON history_octane.trade_pricing_type (data_source_deleted_flag);
CREATE INDEX idx_trade_status_type__data_source_deleted_flag ON history_octane.trade_status_type (data_source_deleted_flag);
CREATE INDEX idx_trustee__data_source_deleted_flag ON history_octane.trustee (data_source_deleted_flag);
CREATE INDEX idx_underwrite_disposition_type__data_source_deleted_flag ON history_octane.underwrite_disposition_type (data_source_deleted_flag);
CREATE INDEX idx_underwrite_method_type__data_source_deleted_flag ON history_octane.underwrite_method_type (data_source_deleted_flag);
CREATE INDEX idx_underwrite_risk_assessment_type__data_source_deleted_flag ON history_octane.underwrite_risk_assessment_type (data_source_deleted_flag);
CREATE INDEX idx_unique_dwelling_type__data_source_deleted_flag ON history_octane.unique_dwelling_type (data_source_deleted_flag);
CREATE INDEX idx_1560c2243b0e12f95735fbb63740d2f8 ON history_octane.usda_rd_single_family_housing_type (data_source_deleted_flag);
CREATE INDEX idx_uuts_loan_originator_type__data_source_deleted_flag ON history_octane.uuts_loan_originator_type (data_source_deleted_flag);
CREATE INDEX idx_286601f67cf74707c9212e168372f68a ON history_octane.va_borrower_certification_occupancy_type (data_source_deleted_flag);
CREATE INDEX idx_va_entitlement_code_type__data_source_deleted_flag ON history_octane.va_entitlement_code_type (data_source_deleted_flag);
CREATE INDEX idx_va_entitlement_restoration_type__data_source_deleted_flag ON history_octane.va_entitlement_restoration_type (data_source_deleted_flag);
CREATE INDEX idx_va_notice_of_value_source_type__data_source_deleted_flag ON history_octane.va_notice_of_value_source_type (data_source_deleted_flag);
CREATE INDEX idx_va_past_credit_record_type__data_source_deleted_flag ON history_octane.va_past_credit_record_type (data_source_deleted_flag);
CREATE INDEX idx_va_regional_loan_center_type__data_source_deleted_flag ON history_octane.va_regional_loan_center_type (data_source_deleted_flag);
CREATE INDEX idx_va_relative_relationship_type__data_source_deleted_flag ON history_octane.va_relative_relationship_type (data_source_deleted_flag);
CREATE INDEX idx_vendor_credential_source_type__data_source_deleted_flag ON history_octane.vendor_credential_source_type (data_source_deleted_flag);
CREATE INDEX idx_vendor_document_event_type__data_source_deleted_flag ON history_octane.vendor_document_event_type (data_source_deleted_flag);
CREATE INDEX idx_vendor_import_document_type__data_source_deleted_flag ON history_octane.vendor_import_document_type (data_source_deleted_flag);
CREATE INDEX idx_veteran_status_type__data_source_deleted_flag ON history_octane.veteran_status_type (data_source_deleted_flag);
CREATE INDEX idx_voe_third_party_verifier_type__data_source_deleted_flag ON history_octane.voe_third_party_verifier_type (data_source_deleted_flag);
CREATE INDEX idx_voe_verbal_verify_method_type__data_source_deleted_flag ON history_octane.voe_verbal_verify_method_type (data_source_deleted_flag);
CREATE INDEX idx_voe_verify_method_type__data_source_deleted_flag ON history_octane.voe_verify_method_type (data_source_deleted_flag);
CREATE INDEX idx_water_type__data_source_deleted_flag ON history_octane.water_type (data_source_deleted_flag);
CREATE INDEX idx_wf_deal_process_status_type__data_source_deleted_flag ON history_octane.wf_deal_process_status_type (data_source_deleted_flag);
CREATE INDEX idx_wf_deal_step_status_type__data_source_deleted_flag ON history_octane.wf_deal_step_status_type (data_source_deleted_flag);
CREATE INDEX idx_wf_outcome_type__data_source_deleted_flag ON history_octane.wf_outcome_type (data_source_deleted_flag);
CREATE INDEX idx_wf_phase__data_source_deleted_flag ON history_octane.wf_phase (data_source_deleted_flag);
CREATE INDEX idx_wf_process_status_type__data_source_deleted_flag ON history_octane.wf_process_status_type (data_source_deleted_flag);
CREATE INDEX idx_wf_process_type__data_source_deleted_flag ON history_octane.wf_process_type (data_source_deleted_flag);
CREATE INDEX idx_wf_process__data_source_deleted_flag ON history_octane.wf_process (data_source_deleted_flag);
CREATE INDEX idx_wf_step_function_type__data_source_deleted_flag ON history_octane.wf_step_function_type (data_source_deleted_flag);
CREATE INDEX idx_wf_step_performer_assign_type__data_source_deleted_flag ON history_octane.wf_step_performer_assign_type (data_source_deleted_flag);
CREATE INDEX idx_wf_step_reassign_type__data_source_deleted_flag ON history_octane.wf_step_reassign_type (data_source_deleted_flag);
CREATE INDEX idx_wf_step_timeout_type__data_source_deleted_flag ON history_octane.wf_step_timeout_type (data_source_deleted_flag);
CREATE INDEX idx_wf_step_type__data_source_deleted_flag ON history_octane.wf_step_type (data_source_deleted_flag);
CREATE INDEX idx_wf_wait_until_time_slice__data_source_deleted_flag ON history_octane.wf_wait_until_time_slice (data_source_deleted_flag);
CREATE INDEX idx_yes_no_na_type__data_source_deleted_flag ON history_octane.yes_no_na_type (data_source_deleted_flag);
CREATE INDEX idx_yes_no_na_unknown_type__data_source_deleted_flag ON history_octane.yes_no_na_unknown_type (data_source_deleted_flag);
CREATE INDEX idx_yes_no_unknown_type__data_source_deleted_flag ON history_octane.yes_no_unknown_type (data_source_deleted_flag);
CREATE INDEX idx_application__data_source_deleted_flag ON history_octane.application (data_source_deleted_flag);
CREATE INDEX idx_asset__data_source_deleted_flag ON history_octane.asset (data_source_deleted_flag);
CREATE INDEX idx_asset_large_deposit__data_source_deleted_flag ON history_octane.asset_large_deposit (data_source_deleted_flag);
CREATE INDEX idx_creditor__data_source_deleted_flag ON history_octane.creditor (data_source_deleted_flag);
CREATE INDEX idx_creditor_lookup_name__data_source_deleted_flag ON history_octane.creditor_lookup_name (data_source_deleted_flag);
CREATE INDEX idx_investor__data_source_deleted_flag ON history_octane.investor (data_source_deleted_flag);
CREATE INDEX idx_company__data_source_deleted_flag ON history_octane.company (data_source_deleted_flag);
CREATE INDEX idx_branch__data_source_deleted_flag ON history_octane.branch (data_source_deleted_flag);
CREATE INDEX idx_branch_license__data_source_deleted_flag ON history_octane.branch_license (data_source_deleted_flag);
CREATE INDEX idx_company_license__data_source_deleted_flag ON history_octane.company_license (data_source_deleted_flag);
CREATE INDEX idx_deal__data_source_deleted_flag ON history_octane.deal (data_source_deleted_flag);
CREATE INDEX idx_appraisal__data_source_deleted_flag ON history_octane.appraisal (data_source_deleted_flag);
CREATE INDEX idx_appraisal_form__data_source_deleted_flag ON history_octane.appraisal_form (data_source_deleted_flag);
CREATE INDEX idx_appraisal_id_ticker__data_source_deleted_flag ON history_octane.appraisal_id_ticker (data_source_deleted_flag);
CREATE INDEX idx_deal_appraisal__data_source_deleted_flag ON history_octane.deal_appraisal (data_source_deleted_flag);
CREATE INDEX idx_deal_contact__data_source_deleted_flag ON history_octane.deal_contact (data_source_deleted_flag);
CREATE INDEX idx_deal_disaster_declaration__data_source_deleted_flag ON history_octane.deal_disaster_declaration (data_source_deleted_flag);
CREATE INDEX idx_deal_du__data_source_deleted_flag ON history_octane.deal_du (data_source_deleted_flag);
CREATE INDEX idx_deal_event__data_source_deleted_flag ON history_octane.deal_event (data_source_deleted_flag);
CREATE INDEX idx_deal_housing_counselors_request__data_source_deleted_flag ON history_octane.deal_housing_counselors_request (data_source_deleted_flag);
CREATE INDEX idx_deal_housing_counselor_candidate__data_source_deleted_flag ON history_octane.deal_housing_counselor_candidate (data_source_deleted_flag);
CREATE INDEX idx_deal_invoice__data_source_deleted_flag ON history_octane.deal_invoice (data_source_deleted_flag);
CREATE INDEX idx_deal_invoice_item__data_source_deleted_flag ON history_octane.deal_invoice_item (data_source_deleted_flag);
CREATE INDEX idx_deal_lender_user_event__data_source_deleted_flag ON history_octane.deal_lender_user_event (data_source_deleted_flag);
CREATE INDEX idx_deal_lp__data_source_deleted_flag ON history_octane.deal_lp (data_source_deleted_flag);
CREATE INDEX idx_deal_performer_team__data_source_deleted_flag ON history_octane.deal_performer_team (data_source_deleted_flag);
CREATE INDEX idx_deal_real_estate_agent__data_source_deleted_flag ON history_octane.deal_real_estate_agent (data_source_deleted_flag);
CREATE INDEX idx_deal_settlement__data_source_deleted_flag ON history_octane.deal_settlement (data_source_deleted_flag);
CREATE INDEX idx_deal_signer__data_source_deleted_flag ON history_octane.deal_signer (data_source_deleted_flag);
CREATE INDEX idx_deal_stage__data_source_deleted_flag ON history_octane.deal_stage (data_source_deleted_flag);
CREATE INDEX idx_deal_summary__data_source_deleted_flag ON history_octane.deal_summary (data_source_deleted_flag);
CREATE INDEX idx_investor_lock_extension_setting__data_source_deleted_flag ON history_octane.investor_lock_extension_setting (data_source_deleted_flag);
CREATE INDEX idx_lead__data_source_deleted_flag ON history_octane.lead (data_source_deleted_flag);
CREATE INDEX idx_lender_user__data_source_deleted_flag ON history_octane.lender_user (data_source_deleted_flag);
CREATE INDEX idx_backfill_status__data_source_deleted_flag ON history_octane.backfill_status (data_source_deleted_flag);
CREATE INDEX idx_backfill_loan_status__data_source_deleted_flag ON history_octane.backfill_loan_status (data_source_deleted_flag);
CREATE INDEX idx_bid_pool_note__data_source_deleted_flag ON history_octane.bid_pool_note (data_source_deleted_flag);
CREATE INDEX idx_bid_pool_note_comment__data_source_deleted_flag ON history_octane.bid_pool_note_comment (data_source_deleted_flag);
CREATE INDEX idx_bid_pool_note_monitor__data_source_deleted_flag ON history_octane.bid_pool_note_monitor (data_source_deleted_flag);
CREATE INDEX idx_branch_account_executive__data_source_deleted_flag ON history_octane.branch_account_executive (data_source_deleted_flag);
CREATE INDEX idx_deal_invoice_payment_method__data_source_deleted_flag ON history_octane.deal_invoice_payment_method (data_source_deleted_flag);
CREATE INDEX idx_deal_key_roles__data_source_deleted_flag ON history_octane.deal_key_roles (data_source_deleted_flag);
CREATE INDEX idx_deal_lender_user__data_source_deleted_flag ON history_octane.deal_lender_user (data_source_deleted_flag);
CREATE INDEX idx_deal_performer_team_user__data_source_deleted_flag ON history_octane.deal_performer_team_user (data_source_deleted_flag);
CREATE INDEX idx_dw_export_request__data_source_deleted_flag ON history_octane.dw_export_request (data_source_deleted_flag);
CREATE INDEX idx_lender_settings__data_source_deleted_flag ON history_octane.lender_settings (data_source_deleted_flag);
CREATE INDEX idx_lender_user_allowed_ip__data_source_deleted_flag ON history_octane.lender_user_allowed_ip (data_source_deleted_flag);
CREATE INDEX idx_lender_user_deal_visit__data_source_deleted_flag ON history_octane.lender_user_deal_visit (data_source_deleted_flag);
CREATE INDEX idx_lender_user_lead_source__data_source_deleted_flag ON history_octane.lender_user_lead_source (data_source_deleted_flag);
CREATE INDEX idx_lender_user_license__data_source_deleted_flag ON history_octane.lender_user_license (data_source_deleted_flag);
CREATE INDEX idx_lender_user_notice__data_source_deleted_flag ON history_octane.lender_user_notice (data_source_deleted_flag);
CREATE INDEX idx_lender_user_role__data_source_deleted_flag ON history_octane.lender_user_role (data_source_deleted_flag);
CREATE INDEX idx_exclusive_assignment__data_source_deleted_flag ON history_octane.exclusive_assignment (data_source_deleted_flag);
CREATE INDEX idx_lender_user_role_addendum__data_source_deleted_flag ON history_octane.lender_user_role_addendum (data_source_deleted_flag);
CREATE INDEX idx_lender_user_sign_on__data_source_deleted_flag ON history_octane.lender_user_sign_on (data_source_deleted_flag);
CREATE INDEX idx_lender_user_unavailable__data_source_deleted_flag ON history_octane.lender_user_unavailable (data_source_deleted_flag);
CREATE INDEX idx_mercury_network_status_request__data_source_deleted_flag ON history_octane.mercury_network_status_request (data_source_deleted_flag);
CREATE INDEX idx_org_division_leader__data_source_deleted_flag ON history_octane.org_division_leader (data_source_deleted_flag);
CREATE INDEX idx_org_group_leader__data_source_deleted_flag ON history_octane.org_group_leader (data_source_deleted_flag);
CREATE INDEX idx_org_lender_user_terms__data_source_deleted_flag ON history_octane.org_lender_user_terms (data_source_deleted_flag);
CREATE INDEX idx_org_region_leader__data_source_deleted_flag ON history_octane.org_region_leader (data_source_deleted_flag);
CREATE INDEX idx_org_team_leader__data_source_deleted_flag ON history_octane.org_team_leader (data_source_deleted_flag);
CREATE INDEX idx_org_unit_leader__data_source_deleted_flag ON history_octane.org_unit_leader (data_source_deleted_flag);
CREATE INDEX idx_performer_assignment__data_source_deleted_flag ON history_octane.performer_assignment (data_source_deleted_flag);
CREATE INDEX idx_product__data_source_deleted_flag ON history_octane.product (data_source_deleted_flag);
CREATE INDEX idx_offering_product__data_source_deleted_flag ON history_octane.offering_product (data_source_deleted_flag);
CREATE INDEX idx_product_add_on__data_source_deleted_flag ON history_octane.product_add_on (data_source_deleted_flag);
CREATE INDEX idx_product_add_on_rule__data_source_deleted_flag ON history_octane.product_add_on_rule (data_source_deleted_flag);
CREATE INDEX idx_product_branch__data_source_deleted_flag ON history_octane.product_branch (data_source_deleted_flag);
CREATE INDEX idx_product_deal_check_exclusion__data_source_deleted_flag ON history_octane.product_deal_check_exclusion (data_source_deleted_flag);
CREATE INDEX idx_product_eligibility__data_source_deleted_flag ON history_octane.product_eligibility (data_source_deleted_flag);
CREATE INDEX idx_product_eligibility_rule__data_source_deleted_flag ON history_octane.product_eligibility_rule (data_source_deleted_flag);
CREATE INDEX idx_product_lock_term__data_source_deleted_flag ON history_octane.product_lock_term (data_source_deleted_flag);
CREATE INDEX idx_product_maximum_investor_price__data_source_deleted_flag ON history_octane.product_maximum_investor_price (data_source_deleted_flag);
CREATE INDEX idx_product_maximum_rebate__data_source_deleted_flag ON history_octane.product_maximum_rebate (data_source_deleted_flag);
CREATE INDEX idx_product_minimum_investor_price__data_source_deleted_flag ON history_octane.product_minimum_investor_price (data_source_deleted_flag);
CREATE INDEX idx_product_originator__data_source_deleted_flag ON history_octane.product_originator (data_source_deleted_flag);
CREATE INDEX idx_product_terms__data_source_deleted_flag ON history_octane.product_terms (data_source_deleted_flag);
CREATE INDEX idx_product_buydown__data_source_deleted_flag ON history_octane.product_buydown (data_source_deleted_flag);
CREATE INDEX idx_product_interest_only__data_source_deleted_flag ON history_octane.product_interest_only (data_source_deleted_flag);
CREATE INDEX idx_product_prepay_penalty__data_source_deleted_flag ON history_octane.product_prepay_penalty (data_source_deleted_flag);
CREATE INDEX idx_rate_sheet__data_source_deleted_flag ON history_octane.rate_sheet (data_source_deleted_flag);
CREATE INDEX idx_rate_sheet_rate__data_source_deleted_flag ON history_octane.rate_sheet_rate (data_source_deleted_flag);
CREATE INDEX idx_rate_sheet_price__data_source_deleted_flag ON history_octane.rate_sheet_price (data_source_deleted_flag);
CREATE INDEX idx_repository_file__data_source_deleted_flag ON history_octane.repository_file (data_source_deleted_flag);
CREATE INDEX idx_bid_pool_file__data_source_deleted_flag ON history_octane.bid_pool_file (data_source_deleted_flag);
CREATE INDEX idx_compass_analytics_report_request__data_source_deleted_flag ON history_octane.compass_analytics_report_request (data_source_deleted_flag);
CREATE INDEX idx_consumer_privacy_request__data_source_deleted_flag ON history_octane.consumer_privacy_request (data_source_deleted_flag);
CREATE INDEX idx_custom_form__data_source_deleted_flag ON history_octane.custom_form (data_source_deleted_flag);
CREATE INDEX idx_custom_form_merge_field__data_source_deleted_flag ON history_octane.custom_form_merge_field (data_source_deleted_flag);
CREATE INDEX idx_deal_file__data_source_deleted_flag ON history_octane.deal_file (data_source_deleted_flag);
CREATE INDEX idx_appraisal_file__data_source_deleted_flag ON history_octane.appraisal_file (data_source_deleted_flag);
CREATE INDEX idx_deal_dropbox_file__data_source_deleted_flag ON history_octane.deal_dropbox_file (data_source_deleted_flag);
CREATE INDEX idx_deal_file_signature__data_source_deleted_flag ON history_octane.deal_file_signature (data_source_deleted_flag);
CREATE INDEX idx_deal_fraud_risk__data_source_deleted_flag ON history_octane.deal_fraud_risk (data_source_deleted_flag);
CREATE INDEX idx_deal_invoice_file__data_source_deleted_flag ON history_octane.deal_invoice_file (data_source_deleted_flag);
CREATE INDEX idx_deal_message_log__data_source_deleted_flag ON history_octane.deal_message_log (data_source_deleted_flag);
CREATE INDEX idx_deal_system_file__data_source_deleted_flag ON history_octane.deal_system_file (data_source_deleted_flag);
CREATE INDEX idx_appraisal_order_request__data_source_deleted_flag ON history_octane.appraisal_order_request (data_source_deleted_flag);
CREATE INDEX idx_appraisal_order_request_file__data_source_deleted_flag ON history_octane.appraisal_order_request_file (data_source_deleted_flag);
CREATE INDEX idx_deal_file_thumbnail__data_source_deleted_flag ON history_octane.deal_file_thumbnail (data_source_deleted_flag);
CREATE INDEX idx_du_request__data_source_deleted_flag ON history_octane.du_request (data_source_deleted_flag);
CREATE INDEX idx_du_key_finding__data_source_deleted_flag ON history_octane.du_key_finding (data_source_deleted_flag);
CREATE INDEX idx_du_refi_plus_finding__data_source_deleted_flag ON history_octane.du_refi_plus_finding (data_source_deleted_flag);
CREATE INDEX idx_du_request_credit__data_source_deleted_flag ON history_octane.du_request_credit (data_source_deleted_flag);
CREATE INDEX idx_du_special_feature_code__data_source_deleted_flag ON history_octane.du_special_feature_code (data_source_deleted_flag);
CREATE INDEX idx_flood_cert__data_source_deleted_flag ON history_octane.flood_cert (data_source_deleted_flag);
CREATE INDEX idx_hmda_report_request__data_source_deleted_flag ON history_octane.hmda_report_request (data_source_deleted_flag);
CREATE INDEX idx_lender_user_photo__data_source_deleted_flag ON history_octane.lender_user_photo (data_source_deleted_flag);
CREATE INDEX idx_lp_request__data_source_deleted_flag ON history_octane.lp_request (data_source_deleted_flag);
CREATE INDEX idx_credit_request__data_source_deleted_flag ON history_octane.credit_request (data_source_deleted_flag);
CREATE INDEX idx_borrower__data_source_deleted_flag ON history_octane.borrower (data_source_deleted_flag);
CREATE INDEX idx_borrower_alias__data_source_deleted_flag ON history_octane.borrower_alias (data_source_deleted_flag);
CREATE INDEX idx_borrower_asset__data_source_deleted_flag ON history_octane.borrower_asset (data_source_deleted_flag);
CREATE INDEX idx_borrower_associated_address__data_source_deleted_flag ON history_octane.borrower_associated_address (data_source_deleted_flag);
CREATE INDEX idx_borrower_dependent__data_source_deleted_flag ON history_octane.borrower_dependent (data_source_deleted_flag);
CREATE INDEX idx_borrower_income__data_source_deleted_flag ON history_octane.borrower_income (data_source_deleted_flag);
CREATE INDEX idx_borrower_job_gap__data_source_deleted_flag ON history_octane.borrower_job_gap (data_source_deleted_flag);
CREATE INDEX idx_borrower_user_deal__data_source_deleted_flag ON history_octane.borrower_user_deal (data_source_deleted_flag);
CREATE INDEX idx_borrower_user_change_email__data_source_deleted_flag ON history_octane.borrower_user_change_email (data_source_deleted_flag);
CREATE INDEX idx_business_income__data_source_deleted_flag ON history_octane.business_income (data_source_deleted_flag);
CREATE INDEX idx_346a25b840c2a776e6a1f449adbf9718 ON history_octane.consumer_privacy_affected_borrower (data_source_deleted_flag);
CREATE INDEX idx_job_income__data_source_deleted_flag ON history_octane.job_income (data_source_deleted_flag);
CREATE INDEX idx_lp_finding__data_source_deleted_flag ON history_octane.lp_finding (data_source_deleted_flag);
CREATE INDEX idx_lp_request_credit__data_source_deleted_flag ON history_octane.lp_request_credit (data_source_deleted_flag);
CREATE INDEX idx_mers_daily_report__data_source_deleted_flag ON history_octane.mers_daily_report (data_source_deleted_flag);
CREATE INDEX idx_military_service__data_source_deleted_flag ON history_octane.military_service (data_source_deleted_flag);
CREATE INDEX idx_other_income__data_source_deleted_flag ON history_octane.other_income (data_source_deleted_flag);
CREATE INDEX idx_proposal__data_source_deleted_flag ON history_octane.proposal (data_source_deleted_flag);
CREATE INDEX idx_aus_request_number_ticker__data_source_deleted_flag ON history_octane.aus_request_number_ticker (data_source_deleted_flag);
CREATE INDEX idx_construction_draw__data_source_deleted_flag ON history_octane.construction_draw (data_source_deleted_flag);
CREATE INDEX idx_construction_draw_number_ticker__data_source_deleted_flag ON history_octane.construction_draw_number_ticker (data_source_deleted_flag);
CREATE INDEX idx_credit_inquiry__data_source_deleted_flag ON history_octane.credit_inquiry (data_source_deleted_flag);
CREATE INDEX idx_borrower_credit_inquiry__data_source_deleted_flag ON history_octane.borrower_credit_inquiry (data_source_deleted_flag);
CREATE INDEX idx_deal_snapshot__data_source_deleted_flag ON history_octane.deal_snapshot (data_source_deleted_flag);
CREATE INDEX idx_docusign_package__data_source_deleted_flag ON history_octane.docusign_package (data_source_deleted_flag);
CREATE INDEX idx_master_property_insurance__data_source_deleted_flag ON history_octane.master_property_insurance (data_source_deleted_flag);
CREATE INDEX idx_mi_integration_vendor_request__data_source_deleted_flag ON history_octane.mi_integration_vendor_request (data_source_deleted_flag);
CREATE INDEX idx_loan__data_source_deleted_flag ON history_octane.loan (data_source_deleted_flag);
CREATE INDEX idx_circumstance_change__data_source_deleted_flag ON history_octane.circumstance_change (data_source_deleted_flag);
CREATE INDEX idx_ernst_request__data_source_deleted_flag ON history_octane.ernst_request (data_source_deleted_flag);
CREATE INDEX idx_ernst_request_question__data_source_deleted_flag ON history_octane.ernst_request_question (data_source_deleted_flag);
CREATE INDEX idx_loan_beneficiary__data_source_deleted_flag ON history_octane.loan_beneficiary (data_source_deleted_flag);
CREATE INDEX idx_loan_closing_doc__data_source_deleted_flag ON history_octane.loan_closing_doc (data_source_deleted_flag);
CREATE INDEX idx_loan_eligible_investor__data_source_deleted_flag ON history_octane.loan_eligible_investor (data_source_deleted_flag);
CREATE INDEX idx_loan_funding__data_source_deleted_flag ON history_octane.loan_funding (data_source_deleted_flag);
CREATE INDEX idx_loan_hedge__data_source_deleted_flag ON history_octane.loan_hedge (data_source_deleted_flag);
CREATE INDEX idx_loan_mi_rate_adjustment__data_source_deleted_flag ON history_octane.loan_mi_rate_adjustment (data_source_deleted_flag);
CREATE INDEX idx_loan_mi_surcharge__data_source_deleted_flag ON history_octane.loan_mi_surcharge (data_source_deleted_flag);
CREATE INDEX idx_loan_price_add_on__data_source_deleted_flag ON history_octane.loan_price_add_on (data_source_deleted_flag);
CREATE INDEX idx_loan_recording__data_source_deleted_flag ON history_octane.loan_recording (data_source_deleted_flag);
CREATE INDEX idx_loan_servicer__data_source_deleted_flag ON history_octane.loan_servicer (data_source_deleted_flag);
CREATE INDEX idx_lock_series__data_source_deleted_flag ON history_octane.lock_series (data_source_deleted_flag);
CREATE INDEX idx_lender_lock_major__data_source_deleted_flag ON history_octane.lender_lock_major (data_source_deleted_flag);
CREATE INDEX idx_bid_pool_lender_lock__data_source_deleted_flag ON history_octane.bid_pool_lender_lock (data_source_deleted_flag);
CREATE INDEX idx_lender_concession_request__data_source_deleted_flag ON history_octane.lender_concession_request (data_source_deleted_flag);
CREATE INDEX idx_lender_lock_extension__data_source_deleted_flag ON history_octane.lender_lock_extension (data_source_deleted_flag);
CREATE INDEX idx_lender_lock_minor__data_source_deleted_flag ON history_octane.lender_lock_minor (data_source_deleted_flag);
CREATE INDEX idx_lender_lock_add_on__data_source_deleted_flag ON history_octane.lender_lock_add_on (data_source_deleted_flag);
CREATE INDEX idx_net_tangible_benefit__data_source_deleted_flag ON history_octane.net_tangible_benefit (data_source_deleted_flag);
CREATE INDEX idx_obligation__data_source_deleted_flag ON history_octane.obligation (data_source_deleted_flag);
CREATE INDEX idx_loan_charge__data_source_deleted_flag ON history_octane.loan_charge (data_source_deleted_flag);
CREATE INDEX idx_place__data_source_deleted_flag ON history_octane.place (data_source_deleted_flag);
CREATE INDEX idx_borrower_reo__data_source_deleted_flag ON history_octane.borrower_reo (data_source_deleted_flag);
CREATE INDEX idx_borrower_residence__data_source_deleted_flag ON history_octane.borrower_residence (data_source_deleted_flag);
CREATE INDEX idx_borrower_tax_filing__data_source_deleted_flag ON history_octane.borrower_tax_filing (data_source_deleted_flag);
CREATE INDEX idx_borrower_va__data_source_deleted_flag ON history_octane.borrower_va (data_source_deleted_flag);
CREATE INDEX idx_profit_margin_detail__data_source_deleted_flag ON history_octane.profit_margin_detail (data_source_deleted_flag);
CREATE INDEX idx_proposal_contractor__data_source_deleted_flag ON history_octane.proposal_contractor (data_source_deleted_flag);
CREATE INDEX idx_construction_cost__data_source_deleted_flag ON history_octane.construction_cost (data_source_deleted_flag);
CREATE INDEX idx_construction_draw_item__data_source_deleted_flag ON history_octane.construction_draw_item (data_source_deleted_flag);
CREATE INDEX idx_proposal_doc_set__data_source_deleted_flag ON history_octane.proposal_doc_set (data_source_deleted_flag);
CREATE INDEX idx_proposal_doc_set_id_ticker__data_source_deleted_flag ON history_octane.proposal_doc_set_id_ticker (data_source_deleted_flag);
CREATE INDEX idx_proposal_doc_set_signer__data_source_deleted_flag ON history_octane.proposal_doc_set_signer (data_source_deleted_flag);
CREATE INDEX idx_proposal_doc_set_snapshot__data_source_deleted_flag ON history_octane.proposal_doc_set_snapshot (data_source_deleted_flag);
CREATE INDEX idx_proposal_engagement__data_source_deleted_flag ON history_octane.proposal_engagement (data_source_deleted_flag);
CREATE INDEX idx_proposal_grant_program__data_source_deleted_flag ON history_octane.proposal_grant_program (data_source_deleted_flag);
CREATE INDEX idx_proposal_review__data_source_deleted_flag ON history_octane.proposal_review (data_source_deleted_flag);
CREATE INDEX idx_proposal_review_ticker__data_source_deleted_flag ON history_octane.proposal_review_ticker (data_source_deleted_flag);
CREATE INDEX idx_proposal_summary__data_source_deleted_flag ON history_octane.proposal_summary (data_source_deleted_flag);
CREATE INDEX idx_pte_request__data_source_deleted_flag ON history_octane.pte_request (data_source_deleted_flag);
CREATE INDEX idx_public_record__data_source_deleted_flag ON history_octane.public_record (data_source_deleted_flag);
CREATE INDEX idx_borrower_public_record__data_source_deleted_flag ON history_octane.borrower_public_record (data_source_deleted_flag);
CREATE INDEX idx_rental_income__data_source_deleted_flag ON history_octane.rental_income (data_source_deleted_flag);
CREATE INDEX idx_sap_quote_request__data_source_deleted_flag ON history_octane.sap_quote_request (data_source_deleted_flag);
CREATE INDEX idx_secondary_settings__data_source_deleted_flag ON history_octane.secondary_settings (data_source_deleted_flag);
CREATE INDEX idx_servicer_loan_id_import_request__data_source_deleted_flag ON history_octane.servicer_loan_id_import_request (data_source_deleted_flag);
CREATE INDEX idx_servicer_loan_id_assignment__data_source_deleted_flag ON history_octane.servicer_loan_id_assignment (data_source_deleted_flag);
CREATE INDEX idx_smart_doc__data_source_deleted_flag ON history_octane.smart_doc (data_source_deleted_flag);
CREATE INDEX idx_smart_doc_criteria__data_source_deleted_flag ON history_octane.smart_doc_criteria (data_source_deleted_flag);
CREATE INDEX idx_smart_doc_note__data_source_deleted_flag ON history_octane.smart_doc_note (data_source_deleted_flag);
CREATE INDEX idx_smart_doc_note_comment__data_source_deleted_flag ON history_octane.smart_doc_note_comment (data_source_deleted_flag);
CREATE INDEX idx_smart_doc_note_monitor__data_source_deleted_flag ON history_octane.smart_doc_note_monitor (data_source_deleted_flag);
CREATE INDEX idx_smart_doc_role__data_source_deleted_flag ON history_octane.smart_doc_role (data_source_deleted_flag);
CREATE INDEX idx_smart_message__data_source_deleted_flag ON history_octane.smart_message (data_source_deleted_flag);
CREATE INDEX idx_smart_message_recipient__data_source_deleted_flag ON history_octane.smart_message_recipient (data_source_deleted_flag);
CREATE INDEX idx_smart_req__data_source_deleted_flag ON history_octane.smart_req (data_source_deleted_flag);
CREATE INDEX idx_smart_separator__data_source_deleted_flag ON history_octane.smart_separator (data_source_deleted_flag);
CREATE INDEX idx_smart_set_doc__data_source_deleted_flag ON history_octane.smart_set_doc (data_source_deleted_flag);
CREATE INDEX idx_smart_stack_doc__data_source_deleted_flag ON history_octane.smart_stack_doc (data_source_deleted_flag);
CREATE INDEX idx_stack_export_request__data_source_deleted_flag ON history_octane.stack_export_request (data_source_deleted_flag);
CREATE INDEX idx_stack_export_file__data_source_deleted_flag ON history_octane.stack_export_file (data_source_deleted_flag);
CREATE INDEX idx_tax_transcript_request__data_source_deleted_flag ON history_octane.tax_transcript_request (data_source_deleted_flag);
CREATE INDEX idx_021716ca351bc3ab86bc96d84ed3e27a ON history_octane.third_party_community_second_program (data_source_deleted_flag);
CREATE INDEX idx_liability__data_source_deleted_flag ON history_octane.liability (data_source_deleted_flag);
CREATE INDEX idx_borrower_liability__data_source_deleted_flag ON history_octane.borrower_liability (data_source_deleted_flag);
CREATE INDEX idx_deal_tag__data_source_deleted_flag ON history_octane.deal_tag (data_source_deleted_flag);
CREATE INDEX idx_c0659fbef135030f82273be29d193361 ON history_octane.product_third_party_community_second_program (data_source_deleted_flag);
CREATE INDEX idx_proposal_doc__data_source_deleted_flag ON history_octane.proposal_doc (data_source_deleted_flag);
CREATE INDEX idx_proposal_doc_borrower_access__data_source_deleted_flag ON history_octane.proposal_doc_borrower_access (data_source_deleted_flag);
CREATE INDEX idx_proposal_doc_file__data_source_deleted_flag ON history_octane.proposal_doc_file (data_source_deleted_flag);
CREATE INDEX idx_proposal_req__data_source_deleted_flag ON history_octane.proposal_req (data_source_deleted_flag);
CREATE INDEX idx_sap_deal_step__data_source_deleted_flag ON history_octane.sap_deal_step (data_source_deleted_flag);
CREATE INDEX idx_deal_sap__data_source_deleted_flag ON history_octane.deal_sap (data_source_deleted_flag);
CREATE INDEX idx_trade__data_source_deleted_flag ON history_octane.trade (data_source_deleted_flag);
CREATE INDEX idx_investor_lock__data_source_deleted_flag ON history_octane.investor_lock (data_source_deleted_flag);
CREATE INDEX idx_investor_lock_add_on__data_source_deleted_flag ON history_octane.investor_lock_add_on (data_source_deleted_flag);
CREATE INDEX idx_investor_lock_extension__data_source_deleted_flag ON history_octane.investor_lock_extension (data_source_deleted_flag);
CREATE INDEX idx_trade_audit__data_source_deleted_flag ON history_octane.trade_audit (data_source_deleted_flag);
CREATE INDEX idx_trade_fee__data_source_deleted_flag ON history_octane.trade_fee (data_source_deleted_flag);
CREATE INDEX idx_trade_file__data_source_deleted_flag ON history_octane.trade_file (data_source_deleted_flag);
CREATE INDEX idx_trade_lock_filter__data_source_deleted_flag ON history_octane.trade_lock_filter (data_source_deleted_flag);
CREATE INDEX idx_trade_note__data_source_deleted_flag ON history_octane.trade_note (data_source_deleted_flag);
CREATE INDEX idx_trade_note_comment__data_source_deleted_flag ON history_octane.trade_note_comment (data_source_deleted_flag);
CREATE INDEX idx_trade_note_monitor__data_source_deleted_flag ON history_octane.trade_note_monitor (data_source_deleted_flag);
CREATE INDEX idx_trade_product__data_source_deleted_flag ON history_octane.trade_product (data_source_deleted_flag);
CREATE INDEX idx_unpaid_balance_adjustment__data_source_deleted_flag ON history_octane.unpaid_balance_adjustment (data_source_deleted_flag);
CREATE INDEX idx_vendor_document_repository_file__data_source_deleted_flag ON history_octane.vendor_document_repository_file (data_source_deleted_flag);
CREATE INDEX idx_deal_data_vendor_document_import__data_source_deleted_flag ON history_octane.deal_data_vendor_document_import (data_source_deleted_flag);
CREATE INDEX idx_vendor_document_event__data_source_deleted_flag ON history_octane.vendor_document_event (data_source_deleted_flag);
CREATE INDEX idx_wf_deal_process__data_source_deleted_flag ON history_octane.wf_deal_process (data_source_deleted_flag);
CREATE INDEX idx_wf_step__data_source_deleted_flag ON history_octane.wf_step (data_source_deleted_flag);
CREATE INDEX idx_criteria_pid_operand__data_source_deleted_flag ON history_octane.criteria_pid_operand (data_source_deleted_flag);
CREATE INDEX idx_smart_task__data_source_deleted_flag ON history_octane.smart_task (data_source_deleted_flag);
CREATE INDEX idx_smart_task_tag_modifier__data_source_deleted_flag ON history_octane.smart_task_tag_modifier (data_source_deleted_flag);
CREATE INDEX idx_view_wf_deal_step_started__data_source_deleted_flag ON history_octane.view_wf_deal_step_started (data_source_deleted_flag);
CREATE INDEX idx_wf_deal_step__data_source_deleted_flag ON history_octane.wf_deal_step (data_source_deleted_flag);
CREATE INDEX idx_deal_note__data_source_deleted_flag ON history_octane.deal_note (data_source_deleted_flag);
CREATE INDEX idx_deal_note_comment__data_source_deleted_flag ON history_octane.deal_note_comment (data_source_deleted_flag);
CREATE INDEX idx_deal_note_monitor__data_source_deleted_flag ON history_octane.deal_note_monitor (data_source_deleted_flag);
CREATE INDEX idx_deal_note_role_tag__data_source_deleted_flag ON history_octane.deal_note_role_tag (data_source_deleted_flag);
CREATE INDEX idx_deal_task__data_source_deleted_flag ON history_octane.deal_task (data_source_deleted_flag);
CREATE INDEX idx_wf_deal_fork_process__data_source_deleted_flag ON history_octane.wf_deal_fork_process (data_source_deleted_flag);
CREATE INDEX idx_wf_deal_function_queue__data_source_deleted_flag ON history_octane.wf_deal_function_queue (data_source_deleted_flag);
CREATE INDEX idx_wf_deal_outcome__data_source_deleted_flag ON history_octane.wf_deal_outcome (data_source_deleted_flag);
CREATE INDEX idx_wf_deal_step_timeout__data_source_deleted_flag ON history_octane.wf_deal_step_timeout (data_source_deleted_flag);
CREATE INDEX idx_wf_fork_process__data_source_deleted_flag ON history_octane.wf_fork_process (data_source_deleted_flag);
CREATE INDEX idx_wf_outcome__data_source_deleted_flag ON history_octane.wf_outcome (data_source_deleted_flag);
CREATE INDEX idx_wf_step_deal_check__data_source_deleted_flag ON history_octane.wf_step_deal_check (data_source_deleted_flag);
CREATE INDEX idx_wf_step_deal_check_definition__data_source_deleted_flag ON history_octane.wf_step_deal_check_definition (data_source_deleted_flag);
CREATE INDEX idx_wf_step_deal_check_dependency__data_source_deleted_flag ON history_octane.wf_step_deal_check_dependency (data_source_deleted_flag);
CREATE INDEX idx_wf_step_deal_tag_modifier__data_source_deleted_flag ON history_octane.wf_step_deal_tag_modifier (data_source_deleted_flag);
CREATE INDEX idx_zip_code_info__data_source_deleted_flag ON history_octane.zip_code_info (data_source_deleted_flag);
CREATE INDEX idx_county_zip_code__data_source_deleted_flag ON history_octane.county_zip_code (data_source_deleted_flag);
CREATE INDEX idx_borrower_declarations__data_source_deleted_flag ON history_octane.borrower_declarations (data_source_deleted_flag);
CREATE INDEX idx_804a010cf3cb7fe3a62a6743ece39f1a ON history_octane.minimum_required_residual_income_table (data_source_deleted_flag);
CREATE INDEX idx_ffa7c99e520050f1ad3792f4c6a2985d ON history_octane.minimum_required_residual_income_row (data_source_deleted_flag);
CREATE INDEX idx_new_lock_only_add_on__data_source_deleted_flag ON history_octane.new_lock_only_add_on (data_source_deleted_flag);
CREATE INDEX idx_doc_provider_group_type__data_source_deleted_flag ON history_octane.doc_provider_group_type (data_source_deleted_flag);
CREATE INDEX idx_doc_req_fulfill_status_type__data_source_deleted_flag ON history_octane.doc_req_fulfill_status_type (data_source_deleted_flag);
CREATE INDEX idx_trust_classification_type__data_source_deleted_flag ON history_octane.trust_classification_type (data_source_deleted_flag);
CREATE INDEX idx_c150104d6f81d83b669943c5bc340aec ON history_octane.financed_property_improvements_category_type (data_source_deleted_flag);


CREATE INDEX idx_account_event_type__data_source_updated_datetime ON history_octane.account_event_type (data_source_updated_datetime);
CREATE INDEX idx_account_id_sequence__data_source_updated_datetime ON history_octane.account_id_sequence (data_source_updated_datetime);
CREATE INDEX idx_account_status_type__data_source_updated_datetime ON history_octane.account_status_type (data_source_updated_datetime);
CREATE INDEX idx_account__data_source_updated_datetime ON history_octane.account (data_source_updated_datetime);
CREATE INDEX idx_account_event__data_source_updated_datetime ON history_octane.account_event (data_source_updated_datetime);
CREATE INDEX idx_admin_user_event_type__data_source_updated_datetime ON history_octane.admin_user_event_type (data_source_updated_datetime);
CREATE INDEX idx_admin_user_event__data_source_updated_datetime ON history_octane.admin_user_event (data_source_updated_datetime);
CREATE INDEX idx_admin_user_status_type__data_source_updated_datetime ON history_octane.admin_user_status_type (data_source_updated_datetime);
CREATE INDEX idx_agency_type__data_source_updated_datetime ON history_octane.agency_type (data_source_updated_datetime);
CREATE INDEX idx_agent_type__data_source_updated_datetime ON history_octane.agent_type (data_source_updated_datetime);
CREATE INDEX idx_announcement__data_source_updated_datetime ON history_octane.announcement (data_source_updated_datetime);
CREATE INDEX idx_annual_monthly_type__data_source_updated_datetime ON history_octane.annual_monthly_type (data_source_updated_datetime);
CREATE INDEX idx_applicant_role_type__data_source_updated_datetime ON history_octane.applicant_role_type (data_source_updated_datetime);
CREATE INDEX idx_application_taken_method_type__data_source_updated_datetime ON history_octane.application_taken_method_type (data_source_updated_datetime);
CREATE INDEX idx_application_type__data_source_updated_datetime ON history_octane.application_type (data_source_updated_datetime);
CREATE INDEX idx_appraisal_condition_type__data_source_updated_datetime ON history_octane.appraisal_condition_type (data_source_updated_datetime);
CREATE INDEX idx_appraisal_entry_contact_type__data_source_updated_datetime ON history_octane.appraisal_entry_contact_type (data_source_updated_datetime);
CREATE INDEX idx_appraisal_file_type__data_source_updated_datetime ON history_octane.appraisal_file_type (data_source_updated_datetime);
CREATE INDEX idx_appraisal_form_type__data_source_updated_datetime ON history_octane.appraisal_form_type (data_source_updated_datetime);
CREATE INDEX idx_appraisal_hold_reason_type__data_source_updated_datetime ON history_octane.appraisal_hold_reason_type (data_source_updated_datetime);
CREATE INDEX idx_appraisal_hold_type__data_source_updated_datetime ON history_octane.appraisal_hold_type (data_source_updated_datetime);
CREATE INDEX idx_4b7ca44c61494bfa82eaf25a529a3eb9 ON history_octane.appraisal_management_company_type (data_source_updated_datetime);
CREATE INDEX idx_722fe01982d734cff0a3b3ee99d151d5 ON history_octane.appraisal_order_coarse_status_type (data_source_updated_datetime);
CREATE INDEX idx_ab3bcc197067e972586553193bd6fea6 ON history_octane.appraisal_order_request_file_type (data_source_updated_datetime);
CREATE INDEX idx_appraisal_order_request_type__data_source_updated_datetime ON history_octane.appraisal_order_request_type (data_source_updated_datetime);
CREATE INDEX idx_appraisal_order_status_type__data_source_updated_datetime ON history_octane.appraisal_order_status_type (data_source_updated_datetime);
CREATE INDEX idx_appraisal_purpose_type__data_source_updated_datetime ON history_octane.appraisal_purpose_type (data_source_updated_datetime);
CREATE INDEX idx_appraisal_source_type__data_source_updated_datetime ON history_octane.appraisal_source_type (data_source_updated_datetime);
CREATE INDEX idx_appraisal_underwriter_type__data_source_updated_datetime ON history_octane.appraisal_underwriter_type (data_source_updated_datetime);
CREATE INDEX idx_area_median_income_table__data_source_updated_datetime ON history_octane.area_median_income_table (data_source_updated_datetime);
CREATE INDEX idx_arm_index_type__data_source_updated_datetime ON history_octane.arm_index_type (data_source_updated_datetime);
CREATE INDEX idx_arm_index_rate__data_source_updated_datetime ON history_octane.arm_index_rate (data_source_updated_datetime);
CREATE INDEX idx_asset_account_holder_type__data_source_updated_datetime ON history_octane.asset_account_holder_type (data_source_updated_datetime);
CREATE INDEX idx_asset_type__data_source_updated_datetime ON history_octane.asset_type (data_source_updated_datetime);
CREATE INDEX idx_aus_credit_service_type__data_source_updated_datetime ON history_octane.aus_credit_service_type (data_source_updated_datetime);
CREATE INDEX idx_aus_type__data_source_updated_datetime ON history_octane.aus_type (data_source_updated_datetime);
CREATE INDEX idx_backfill_status_type__data_source_updated_datetime ON history_octane.backfill_status_type (data_source_updated_datetime);
CREATE INDEX idx_bankruptcy_exception_type__data_source_updated_datetime ON history_octane.bankruptcy_exception_type (data_source_updated_datetime);
CREATE INDEX idx_bid_pool_status_type__data_source_updated_datetime ON history_octane.bid_pool_status_type (data_source_updated_datetime);
CREATE INDEX idx_bid_pool__data_source_updated_datetime ON history_octane.bid_pool (data_source_updated_datetime);
CREATE INDEX idx_2b2996b07f71948219825726bf76a641 ON history_octane.borrower_associated_address_explanation_type (data_source_updated_datetime);
CREATE INDEX idx_d75847291129937761c034799ae18b49 ON history_octane.borrower_associated_address_source_type (data_source_updated_datetime);
CREATE INDEX idx_borrower_income_category_type__data_source_updated_datetime ON history_octane.borrower_income_category_type (data_source_updated_datetime);
CREATE INDEX idx_borrower_relationship_type__data_source_updated_datetime ON history_octane.borrower_relationship_type (data_source_updated_datetime);
CREATE INDEX idx_borrower_residency_basis_type__data_source_updated_datetime ON history_octane.borrower_residency_basis_type (data_source_updated_datetime);
CREATE INDEX idx_borrower_tiny_id_type__data_source_updated_datetime ON history_octane.borrower_tiny_id_type (data_source_updated_datetime);
CREATE INDEX idx_50050b35ee0505f3a8d9662355fbaac1 ON history_octane.borrower_user_account_status_type (data_source_updated_datetime);
CREATE INDEX idx_fce5009a10c9ab8c98a514aa5f19ed9c ON history_octane.borrower_user_deal_access_type (data_source_updated_datetime);
CREATE INDEX idx_branch_status_type__data_source_updated_datetime ON history_octane.branch_status_type (data_source_updated_datetime);
CREATE INDEX idx_building_status_type__data_source_updated_datetime ON history_octane.building_status_type (data_source_updated_datetime);
CREATE INDEX idx_business_disposition_type__data_source_updated_datetime ON history_octane.business_disposition_type (data_source_updated_datetime);
CREATE INDEX idx_business_income_type__data_source_updated_datetime ON history_octane.business_income_type (data_source_updated_datetime);
CREATE INDEX idx_business_ownership_type__data_source_updated_datetime ON history_octane.business_ownership_type (data_source_updated_datetime);
CREATE INDEX idx_buydown_base_date_type__data_source_updated_datetime ON history_octane.buydown_base_date_type (data_source_updated_datetime);
CREATE INDEX idx_buydown_contributor_type__data_source_updated_datetime ON history_octane.buydown_contributor_type (data_source_updated_datetime);
CREATE INDEX idx_buydown_schedule_type__data_source_updated_datetime ON history_octane.buydown_schedule_type (data_source_updated_datetime);
CREATE INDEX idx_358da196152bc355714aec303885b4c7 ON history_octane.buydown_subsidy_calculation_type (data_source_updated_datetime);
CREATE INDEX idx_calendar_rule_type__data_source_updated_datetime ON history_octane.calendar_rule_type (data_source_updated_datetime);
CREATE INDEX idx_challenge_question_type__data_source_updated_datetime ON history_octane.challenge_question_type (data_source_updated_datetime);
CREATE INDEX idx_channel_type__data_source_updated_datetime ON history_octane.channel_type (data_source_updated_datetime);
CREATE INDEX idx_channel__data_source_updated_datetime ON history_octane.channel (data_source_updated_datetime);
CREATE INDEX idx_charge_input_type__data_source_updated_datetime ON history_octane.charge_input_type (data_source_updated_datetime);
CREATE INDEX idx_charge_payee_type__data_source_updated_datetime ON history_octane.charge_payee_type (data_source_updated_datetime);
CREATE INDEX idx_charge_payer_type__data_source_updated_datetime ON history_octane.charge_payer_type (data_source_updated_datetime);
CREATE INDEX idx_charge_source_type__data_source_updated_datetime ON history_octane.charge_source_type (data_source_updated_datetime);
CREATE INDEX idx_charge_wire_action_type__data_source_updated_datetime ON history_octane.charge_wire_action_type (data_source_updated_datetime);
CREATE INDEX idx_circumstance_change_type__data_source_updated_datetime ON history_octane.circumstance_change_type (data_source_updated_datetime);
CREATE INDEX idx_citizenship_residency_type__data_source_updated_datetime ON history_octane.citizenship_residency_type (data_source_updated_datetime);
CREATE INDEX idx_clg_flood_cert_status_type__data_source_updated_datetime ON history_octane.clg_flood_cert_status_type (data_source_updated_datetime);
CREATE INDEX idx_closing_document_status_type__data_source_updated_datetime ON history_octane.closing_document_status_type (data_source_updated_datetime);
CREATE INDEX idx_coarse_event_type__data_source_updated_datetime ON history_octane.coarse_event_type (data_source_updated_datetime);
CREATE INDEX idx_community_lending_type__data_source_updated_datetime ON history_octane.community_lending_type (data_source_updated_datetime);
CREATE INDEX idx_a86e5a34e003c082c9ec98691e7ff411 ON history_octane.company_admin_event_entity_type (data_source_updated_datetime);
CREATE INDEX idx_company_admin_event__data_source_updated_datetime ON history_octane.company_admin_event (data_source_updated_datetime);
CREATE INDEX idx_company_state_license_type__data_source_updated_datetime ON history_octane.company_state_license_type (data_source_updated_datetime);
CREATE INDEX idx_config_export_permission_type__data_source_updated_datetime ON history_octane.config_export_permission_type (data_source_updated_datetime);
CREATE INDEX idx_d45b5ecb30a641bdb07b273ec60c9ef2 ON history_octane.construction_cost_category_type (data_source_updated_datetime);
CREATE INDEX idx_04fa93434c5902fd32ddad731ddc32a8 ON history_octane.construction_cost_funding_type (data_source_updated_datetime);
CREATE INDEX idx_construction_cost_payee_type__data_source_updated_datetime ON history_octane.construction_cost_payee_type (data_source_updated_datetime);
CREATE INDEX idx_construction_cost_status_type__data_source_updated_datetime ON history_octane.construction_cost_status_type (data_source_updated_datetime);
CREATE INDEX idx_construction_draw_status_type__data_source_updated_datetime ON history_octane.construction_draw_status_type (data_source_updated_datetime);
CREATE INDEX idx_construction_draw_type__data_source_updated_datetime ON history_octane.construction_draw_type (data_source_updated_datetime);
CREATE INDEX idx_d0490336eb448a3be8291c6b7acc562a ON history_octane.construction_lot_ownership_status_type (data_source_updated_datetime);
CREATE INDEX idx_consumer_privacy_request_type__data_source_updated_datetime ON history_octane.consumer_privacy_request_type (data_source_updated_datetime);
CREATE INDEX idx_cost_center__data_source_updated_datetime ON history_octane.cost_center (data_source_updated_datetime);
CREATE INDEX idx_country_type__data_source_updated_datetime ON history_octane.country_type (data_source_updated_datetime);
CREATE INDEX idx_account_contact__data_source_updated_datetime ON history_octane.account_contact (data_source_updated_datetime);
CREATE INDEX idx_courier_type__data_source_updated_datetime ON history_octane.courier_type (data_source_updated_datetime);
CREATE INDEX idx_df9464b430ef1b41bd9d58ea426267b7 ON history_octane.credit_authorization_method_type (data_source_updated_datetime);
CREATE INDEX idx_credit_bureau_type__data_source_updated_datetime ON history_octane.credit_bureau_type (data_source_updated_datetime);
CREATE INDEX idx_credit_business_type__data_source_updated_datetime ON history_octane.credit_business_type (data_source_updated_datetime);
CREATE INDEX idx_495a6c1b9145f50d6466478038f8a0f0 ON history_octane.credit_inquiry_explanation_type (data_source_updated_datetime);
CREATE INDEX idx_credit_inquiry_result_type__data_source_updated_datetime ON history_octane.credit_inquiry_result_type (data_source_updated_datetime);
CREATE INDEX idx_credit_limit_type__data_source_updated_datetime ON history_octane.credit_limit_type (data_source_updated_datetime);
CREATE INDEX idx_credit_loan_type__data_source_updated_datetime ON history_octane.credit_loan_type (data_source_updated_datetime);
CREATE INDEX idx_4bdbac27fd0634ca1a1d3090d31d7a66 ON history_octane.credit_report_request_action_type (data_source_updated_datetime);
CREATE INDEX idx_credit_report_type__data_source_updated_datetime ON history_octane.credit_report_type (data_source_updated_datetime);
CREATE INDEX idx_credit_request_status_type__data_source_updated_datetime ON history_octane.credit_request_status_type (data_source_updated_datetime);
CREATE INDEX idx_credit_request_type__data_source_updated_datetime ON history_octane.credit_request_type (data_source_updated_datetime);
CREATE INDEX idx_credit_request_via_type__data_source_updated_datetime ON history_octane.credit_request_via_type (data_source_updated_datetime);
CREATE INDEX idx_credit_score_model_type__data_source_updated_datetime ON history_octane.credit_score_model_type (data_source_updated_datetime);
CREATE INDEX idx_criteria__data_source_updated_datetime ON history_octane.criteria (data_source_updated_datetime);
CREATE INDEX idx_criteria_owner_type__data_source_updated_datetime ON history_octane.criteria_owner_type (data_source_updated_datetime);
CREATE INDEX idx_criteria_pid_operand_type__data_source_updated_datetime ON history_octane.criteria_pid_operand_type (data_source_updated_datetime);
CREATE INDEX idx_custodian__data_source_updated_datetime ON history_octane.custodian (data_source_updated_datetime);
CREATE INDEX idx_days_per_year_type__data_source_updated_datetime ON history_octane.days_per_year_type (data_source_updated_datetime);
CREATE INDEX idx_deal_cancel_reason_type__data_source_updated_datetime ON history_octane.deal_cancel_reason_type (data_source_updated_datetime);
CREATE INDEX idx_deal_change_updater_time__data_source_updated_datetime ON history_octane.deal_change_updater_time (data_source_updated_datetime);
CREATE INDEX idx_deal_check_severity_type__data_source_updated_datetime ON history_octane.deal_check_severity_type (data_source_updated_datetime);
CREATE INDEX idx_deal_check_type__data_source_updated_datetime ON history_octane.deal_check_type (data_source_updated_datetime);
CREATE INDEX idx_deal_child_relationship_type__data_source_updated_datetime ON history_octane.deal_child_relationship_type (data_source_updated_datetime);
CREATE INDEX idx_deal_child_type__data_source_updated_datetime ON history_octane.deal_child_type (data_source_updated_datetime);
CREATE INDEX idx_criteria_snippet__data_source_updated_datetime ON history_octane.criteria_snippet (data_source_updated_datetime);
CREATE INDEX idx_deal_contact_role_type__data_source_updated_datetime ON history_octane.deal_contact_role_type (data_source_updated_datetime);
CREATE INDEX idx_deal_context_permission_type__data_source_updated_datetime ON history_octane.deal_context_permission_type (data_source_updated_datetime);
CREATE INDEX idx_deal_create_type__data_source_updated_datetime ON history_octane.deal_create_type (data_source_updated_datetime);
CREATE INDEX idx_deal_event_type__data_source_updated_datetime ON history_octane.deal_event_type (data_source_updated_datetime);
CREATE INDEX idx_deal_id_sequence__data_source_updated_datetime ON history_octane.deal_id_sequence (data_source_updated_datetime);
CREATE INDEX idx_deal_invoice_file_type__data_source_updated_datetime ON history_octane.deal_invoice_file_type (data_source_updated_datetime);
CREATE INDEX idx_deal_invoice_status_type__data_source_updated_datetime ON history_octane.deal_invoice_status_type (data_source_updated_datetime);
CREATE INDEX idx_deal_note_scope_type__data_source_updated_datetime ON history_octane.deal_note_scope_type (data_source_updated_datetime);
CREATE INDEX idx_deal_orphan_status_type__data_source_updated_datetime ON history_octane.deal_orphan_status_type (data_source_updated_datetime);
CREATE INDEX idx_deal_stage_type__data_source_updated_datetime ON history_octane.deal_stage_type (data_source_updated_datetime);
CREATE INDEX idx_deal_status_type__data_source_updated_datetime ON history_octane.deal_status_type (data_source_updated_datetime);
CREATE INDEX idx_deal_tag_access_type__data_source_updated_datetime ON history_octane.deal_tag_access_type (data_source_updated_datetime);
CREATE INDEX idx_deal_tag_level_type__data_source_updated_datetime ON history_octane.deal_tag_level_type (data_source_updated_datetime);
CREATE INDEX idx_deal_tag_definition__data_source_updated_datetime ON history_octane.deal_tag_definition (data_source_updated_datetime);
CREATE INDEX idx_deal_task_status_type__data_source_updated_datetime ON history_octane.deal_task_status_type (data_source_updated_datetime);
CREATE INDEX idx_51796213227f169842573f8f3202e8ff ON history_octane.decision_credit_score_calc_type (data_source_updated_datetime);
CREATE INDEX idx_delivery_aus_type__data_source_updated_datetime ON history_octane.delivery_aus_type (data_source_updated_datetime);
CREATE INDEX idx_229dd865e1238d1f9d2762d6ac319360 ON history_octane.disaster_declaration_check_date_type (data_source_updated_datetime);
CREATE INDEX idx_doc_action_type__data_source_updated_datetime ON history_octane.doc_action_type (data_source_updated_datetime);
CREATE INDEX idx_doc_approval_type__data_source_updated_datetime ON history_octane.doc_approval_type (data_source_updated_datetime);
CREATE INDEX idx_doc_borrower_access_mode_type__data_source_updated_datetime ON history_octane.doc_borrower_access_mode_type (data_source_updated_datetime);
CREATE INDEX idx_doc_category_type__data_source_updated_datetime ON history_octane.doc_category_type (data_source_updated_datetime);
CREATE INDEX idx_doc_external_provider_type__data_source_updated_datetime ON history_octane.doc_external_provider_type (data_source_updated_datetime);
CREATE INDEX idx_doc_file_source_type__data_source_updated_datetime ON history_octane.doc_file_source_type (data_source_updated_datetime);
CREATE INDEX idx_doc_fulfill_status_type__data_source_updated_datetime ON history_octane.doc_fulfill_status_type (data_source_updated_datetime);
CREATE INDEX idx_doc_key_date_type__data_source_updated_datetime ON history_octane.doc_key_date_type (data_source_updated_datetime);
CREATE INDEX idx_doc_level_type__data_source_updated_datetime ON history_octane.doc_level_type (data_source_updated_datetime);
CREATE INDEX idx_95d2508f3fe8a58ba3f56bc14b163694 ON history_octane.doc_package_canceled_reason_type (data_source_updated_datetime);
CREATE INDEX idx_5741263e70b382e88e0567c505397cf9 ON history_octane.doc_package_delivery_method_type (data_source_updated_datetime);
CREATE INDEX idx_doc_package_status_type__data_source_updated_datetime ON history_octane.doc_package_status_type (data_source_updated_datetime);
CREATE INDEX idx_doc_permission_type__data_source_updated_datetime ON history_octane.doc_permission_type (data_source_updated_datetime);
CREATE INDEX idx_doc_set_type__data_source_updated_datetime ON history_octane.doc_set_type (data_source_updated_datetime);
CREATE INDEX idx_doc_validity_type__data_source_updated_datetime ON history_octane.doc_validity_type (data_source_updated_datetime);
CREATE INDEX idx_document_import_status_type__data_source_updated_datetime ON history_octane.document_import_status_type (data_source_updated_datetime);
CREATE INDEX idx_document_import_vendor_type__data_source_updated_datetime ON history_octane.document_import_vendor_type (data_source_updated_datetime);
CREATE INDEX idx_du_key_finding_type__data_source_updated_datetime ON history_octane.du_key_finding_type (data_source_updated_datetime);
CREATE INDEX idx_du_recommendation_type__data_source_updated_datetime ON history_octane.du_recommendation_type (data_source_updated_datetime);
CREATE INDEX idx_du_request_status_type__data_source_updated_datetime ON history_octane.du_request_status_type (data_source_updated_datetime);
CREATE INDEX idx_dw_export_request_status_type__data_source_updated_datetime ON history_octane.dw_export_request_status_type (data_source_updated_datetime);
CREATE INDEX idx_ecoa_denial_reason_type__data_source_updated_datetime ON history_octane.ecoa_denial_reason_type (data_source_updated_datetime);
CREATE INDEX idx_733f9a72f12c850d19a6b97a6b1607b0 ON history_octane.effective_property_value_explanation_type (data_source_updated_datetime);
CREATE INDEX idx_effective_property_value_type__data_source_updated_datetime ON history_octane.effective_property_value_type (data_source_updated_datetime);
CREATE INDEX idx_email_closing_type__data_source_updated_datetime ON history_octane.email_closing_type (data_source_updated_datetime);
CREATE INDEX idx_ernst_deed_request_type__data_source_updated_datetime ON history_octane.ernst_deed_request_type (data_source_updated_datetime);
CREATE INDEX idx_ernst_page_rec_type__data_source_updated_datetime ON history_octane.ernst_page_rec_type (data_source_updated_datetime);
CREATE INDEX idx_ernst_request_status_type__data_source_updated_datetime ON history_octane.ernst_request_status_type (data_source_updated_datetime);
CREATE INDEX idx_e49d8814b828a50f5bfc3364a809c0ca ON history_octane.ernst_security_instrument_request_type (data_source_updated_datetime);
CREATE INDEX idx_esign_package_status_type__data_source_updated_datetime ON history_octane.esign_package_status_type (data_source_updated_datetime);
CREATE INDEX idx_esign_vendor_type__data_source_updated_datetime ON history_octane.esign_vendor_type (data_source_updated_datetime);
CREATE INDEX idx_export_permission_type__data_source_updated_datetime ON history_octane.export_permission_type (data_source_updated_datetime);
CREATE INDEX idx_export_type__data_source_updated_datetime ON history_octane.export_type (data_source_updated_datetime);
CREATE INDEX idx_external_entity_type__data_source_updated_datetime ON history_octane.external_entity_type (data_source_updated_datetime);
CREATE INDEX idx_f27bd339acc2ed06e4ac7d5d6ac637d0 ON history_octane.fault_tolerant_event_registration (data_source_updated_datetime);
CREATE INDEX idx_73b88a69bd3ff444813a1c910c43ee7f ON history_octane.fema_flood_zone_designation_type (data_source_updated_datetime);
CREATE INDEX idx_5a78b7866e49d1ed7b44a4094a3d64ab ON history_octane.fha_non_arms_length_ltv_limit_exception_type (data_source_updated_datetime);
CREATE INDEX idx_fha_program_code_type__data_source_updated_datetime ON history_octane.fha_program_code_type (data_source_updated_datetime);
CREATE INDEX idx_fha_rehab_program_type__data_source_updated_datetime ON history_octane.fha_rehab_program_type (data_source_updated_datetime);
CREATE INDEX idx_fha_special_program_type__data_source_updated_datetime ON history_octane.fha_special_program_type (data_source_updated_datetime);
CREATE INDEX idx_18e56bad127ebcd833c09b3199ebd7f6 ON history_octane.fha_va_bor_cert_sales_price_exceeds_type (data_source_updated_datetime);
CREATE INDEX idx_field_type__data_source_updated_datetime ON history_octane.field_type (data_source_updated_datetime);
CREATE INDEX idx_flood_cert_vendor_type__data_source_updated_datetime ON history_octane.flood_cert_vendor_type (data_source_updated_datetime);
CREATE INDEX idx_flood_certificate_type__data_source_updated_datetime ON history_octane.flood_certificate_type (data_source_updated_datetime);
CREATE INDEX idx_fnm_arm_plan_type__data_source_updated_datetime ON history_octane.fnm_arm_plan_type (data_source_updated_datetime);
CREATE INDEX idx_04a27259298d38e149af5926b944723e ON history_octane.fnm_community_lending_product_type (data_source_updated_datetime);
CREATE INDEX idx_0bd7652dffe5f672f0e9d5aafa3f5d17 ON history_octane.fnm_community_seconds_repayment_structure_type (data_source_updated_datetime);
CREATE INDEX idx_fnm_investor_remittance_type__data_source_updated_datetime ON history_octane.fnm_investor_remittance_type (data_source_updated_datetime);
CREATE INDEX idx_5da341d4a47d3f1c486bac7b7438256b ON history_octane.fnm_mbs_loan_default_loss_party_type (data_source_updated_datetime);
CREATE INDEX idx_30a136ae4538f0e5f880a1ebb461da99 ON history_octane.fnm_mbs_reo_marketing_party_type (data_source_updated_datetime);
CREATE INDEX idx_for_further_credit_type__data_source_updated_datetime ON history_octane.for_further_credit_type (data_source_updated_datetime);
CREATE INDEX idx_fre_community_program_type__data_source_updated_datetime ON history_octane.fre_community_program_type (data_source_updated_datetime);
CREATE INDEX idx_fre_ctp_closing_feature_type__data_source_updated_datetime ON history_octane.fre_ctp_closing_feature_type (data_source_updated_datetime);
CREATE INDEX idx_fre_ctp_closing_type__data_source_updated_datetime ON history_octane.fre_ctp_closing_type (data_source_updated_datetime);
CREATE INDEX idx_f436865572e4a1f8ce7191d1538d8aaf ON history_octane.fre_doc_level_description_type (data_source_updated_datetime);
CREATE INDEX idx_fre_purchase_eligibility_type__data_source_updated_datetime ON history_octane.fre_purchase_eligibility_type (data_source_updated_datetime);
CREATE INDEX idx_fund_source_type__data_source_updated_datetime ON history_octane.fund_source_type (data_source_updated_datetime);
CREATE INDEX idx_funding_status_type__data_source_updated_datetime ON history_octane.funding_status_type (data_source_updated_datetime);
CREATE INDEX idx_gender_type__data_source_updated_datetime ON history_octane.gender_type (data_source_updated_datetime);
CREATE INDEX idx_gift_funds_type__data_source_updated_datetime ON history_octane.gift_funds_type (data_source_updated_datetime);
CREATE INDEX idx_account_grant_program__data_source_updated_datetime ON history_octane.account_grant_program (data_source_updated_datetime);
CREATE INDEX idx_gse_version_type__data_source_updated_datetime ON history_octane.gse_version_type (data_source_updated_datetime);
CREATE INDEX idx_8813974b3f85418fc59610c3e5c50403 ON history_octane.heloc_cancel_fee_applicable_type (data_source_updated_datetime);
CREATE INDEX idx_hmda_action_type__data_source_updated_datetime ON history_octane.hmda_action_type (data_source_updated_datetime);
CREATE INDEX idx_hmda_agency_id_type__data_source_updated_datetime ON history_octane.hmda_agency_id_type (data_source_updated_datetime);
CREATE INDEX idx_hmda_denial_reason_type__data_source_updated_datetime ON history_octane.hmda_denial_reason_type (data_source_updated_datetime);
CREATE INDEX idx_hmda_ethnicity_2017_type__data_source_updated_datetime ON history_octane.hmda_ethnicity_2017_type (data_source_updated_datetime);
CREATE INDEX idx_hmda_hoepa_status_type__data_source_updated_datetime ON history_octane.hmda_hoepa_status_type (data_source_updated_datetime);
CREATE INDEX idx_78ea0bfe717eecbe61b0a09ca9a0afb7 ON history_octane.hmda_purchaser_of_loan_2017_type (data_source_updated_datetime);
CREATE INDEX idx_c12c8e515fa5b50de9e8800ac1e48ac0 ON history_octane.hmda_purchaser_of_loan_2018_type (data_source_updated_datetime);
CREATE INDEX idx_hmda_race_2017_type__data_source_updated_datetime ON history_octane.hmda_race_2017_type (data_source_updated_datetime);
CREATE INDEX idx_hoepa_thresholds__data_source_updated_datetime ON history_octane.hoepa_thresholds (data_source_updated_datetime);
CREATE INDEX idx_homeownership_education_type__data_source_updated_datetime ON history_octane.homeownership_education_type (data_source_updated_datetime);
CREATE INDEX idx_9fde9db8a1258330402a650befa574c2 ON history_octane.housing_counseling_agency_type (data_source_updated_datetime);
CREATE INDEX idx_housing_counseling_type__data_source_updated_datetime ON history_octane.housing_counseling_type (data_source_updated_datetime);
CREATE INDEX idx_hud_fha_de_approval_type__data_source_updated_datetime ON history_octane.hud_fha_de_approval_type (data_source_updated_datetime);
CREATE INDEX idx_hve_confidence_level_type__data_source_updated_datetime ON history_octane.hve_confidence_level_type (data_source_updated_datetime);
CREATE INDEX idx_c0c9b16d78247284168581417caf1833 ON history_octane.income_history_calc_method_type (data_source_updated_datetime);
CREATE INDEX idx_intent_to_proceed_type__data_source_updated_datetime ON history_octane.intent_to_proceed_type (data_source_updated_datetime);
CREATE INDEX idx_interest_only_type__data_source_updated_datetime ON history_octane.interest_only_type (data_source_updated_datetime);
CREATE INDEX idx_a35b2fcc591a004ee98cd6f608d983e0 ON history_octane.interim_funder_mers_registration_type (data_source_updated_datetime);
CREATE INDEX idx_interim_funder__data_source_updated_datetime ON history_octane.interim_funder (data_source_updated_datetime);
CREATE INDEX idx_credit_limit__data_source_updated_datetime ON history_octane.credit_limit (data_source_updated_datetime);
CREATE INDEX idx_investor_group__data_source_updated_datetime ON history_octane.investor_group (data_source_updated_datetime);
CREATE INDEX idx_8af5341ddcbd85deb7df17857a25d908 ON history_octane.investor_hmda_purchaser_of_loan_type (data_source_updated_datetime);
CREATE INDEX idx_investor_lock_status_type__data_source_updated_datetime ON history_octane.investor_lock_status_type (data_source_updated_datetime);
CREATE INDEX idx_invoice_item_category_type__data_source_updated_datetime ON history_octane.invoice_item_category_type (data_source_updated_datetime);
CREATE INDEX idx_invoice_payer_type__data_source_updated_datetime ON history_octane.invoice_payer_type (data_source_updated_datetime);
CREATE INDEX idx_bd7031bbea3be2e41ef2242553fdd049 ON history_octane.invoice_payment_submission_type (data_source_updated_datetime);
CREATE INDEX idx_ipc_calc_type__data_source_updated_datetime ON history_octane.ipc_calc_type (data_source_updated_datetime);
CREATE INDEX idx_ipc_comparison_operator_type__data_source_updated_datetime ON history_octane.ipc_comparison_operator_type (data_source_updated_datetime);
CREATE INDEX idx_ipc_property_usage_type__data_source_updated_datetime ON history_octane.ipc_property_usage_type (data_source_updated_datetime);
CREATE INDEX idx_job_gap_reason_type__data_source_updated_datetime ON history_octane.job_gap_reason_type (data_source_updated_datetime);
CREATE INDEX idx_key_creditor_type__data_source_updated_datetime ON history_octane.key_creditor_type (data_source_updated_datetime);
CREATE INDEX idx_key_doc_type__data_source_updated_datetime ON history_octane.key_doc_type (data_source_updated_datetime);
CREATE INDEX idx_key_package_type__data_source_updated_datetime ON history_octane.key_package_type (data_source_updated_datetime);
CREATE INDEX idx_key_role_type__data_source_updated_datetime ON history_octane.key_role_type (data_source_updated_datetime);
CREATE INDEX idx_lava_zone_type__data_source_updated_datetime ON history_octane.lava_zone_type (data_source_updated_datetime);
CREATE INDEX idx_legacy_role_assignment_type__data_source_updated_datetime ON history_octane.legacy_role_assignment_type (data_source_updated_datetime);
CREATE INDEX idx_legal_description_type__data_source_updated_datetime ON history_octane.legal_description_type (data_source_updated_datetime);
CREATE INDEX idx_legal_entity_type__data_source_updated_datetime ON history_octane.legal_entity_type (data_source_updated_datetime);
CREATE INDEX idx_651ac451ec4dea7ada8069bd0b46ba2a ON history_octane.lender_concession_request_status_type (data_source_updated_datetime);
CREATE INDEX idx_c9654951572d94542c2bb78b795fa2b9 ON history_octane.lender_concession_request_type (data_source_updated_datetime);
CREATE INDEX idx_lender_lock_id_ticker__data_source_updated_datetime ON history_octane.lender_lock_id_ticker (data_source_updated_datetime);
CREATE INDEX idx_lender_lock_status_type__data_source_updated_datetime ON history_octane.lender_lock_status_type (data_source_updated_datetime);
CREATE INDEX idx_37d3177156ed47d5afdb3851c48390b0 ON history_octane.lender_toolbox_permission_type (data_source_updated_datetime);
CREATE INDEX idx_lender_trade_id_ticker__data_source_updated_datetime ON history_octane.lender_trade_id_ticker (data_source_updated_datetime);
CREATE INDEX idx_4bb2f281fe7c0a658dc006b39e32cbb9 ON history_octane.lender_user_allowed_ip_status_type (data_source_updated_datetime);
CREATE INDEX idx_lender_user_interest__data_source_updated_datetime ON history_octane.lender_user_interest (data_source_updated_datetime);
CREATE INDEX idx_lender_user_interest_type__data_source_updated_datetime ON history_octane.lender_user_interest_type (data_source_updated_datetime);
CREATE INDEX idx_lender_user_language__data_source_updated_datetime ON history_octane.lender_user_language (data_source_updated_datetime);
CREATE INDEX idx_lender_user_language_type__data_source_updated_datetime ON history_octane.lender_user_language_type (data_source_updated_datetime);
CREATE INDEX idx_lender_user_notice_type__data_source_updated_datetime ON history_octane.lender_user_notice_type (data_source_updated_datetime);
CREATE INDEX idx_lender_user_reset_type__data_source_updated_datetime ON history_octane.lender_user_reset_type (data_source_updated_datetime);
CREATE INDEX idx_lender_user_role_queue_type__data_source_updated_datetime ON history_octane.lender_user_role_queue_type (data_source_updated_datetime);
CREATE INDEX idx_lender_user_status_type__data_source_updated_datetime ON history_octane.lender_user_status_type (data_source_updated_datetime);
CREATE INDEX idx_lender_user_type__data_source_updated_datetime ON history_octane.lender_user_type (data_source_updated_datetime);
CREATE INDEX idx_aff0f36243b637823c641bffc899905b ON history_octane.liability_account_ownership_type (data_source_updated_datetime);
CREATE INDEX idx_liability_account_status_type__data_source_updated_datetime ON history_octane.liability_account_status_type (data_source_updated_datetime);
CREATE INDEX idx_liability_current_rating_type__data_source_updated_datetime ON history_octane.liability_current_rating_type (data_source_updated_datetime);
CREATE INDEX idx_liability_disposition_type__data_source_updated_datetime ON history_octane.liability_disposition_type (data_source_updated_datetime);
CREATE INDEX idx_liability_energy_related_type__data_source_updated_datetime ON history_octane.liability_energy_related_type (data_source_updated_datetime);
CREATE INDEX idx_liability_financing_type__data_source_updated_datetime ON history_octane.liability_financing_type (data_source_updated_datetime);
CREATE INDEX idx_a1f2f8574304f78aca1820030518172b ON history_octane.liability_foreclosure_exception_type (data_source_updated_datetime);
CREATE INDEX idx_liability_mi_type__data_source_updated_datetime ON history_octane.liability_mi_type (data_source_updated_datetime);
CREATE INDEX idx_liability_type__data_source_updated_datetime ON history_octane.liability_type (data_source_updated_datetime);
CREATE INDEX idx_license_type__data_source_updated_datetime ON history_octane.license_type (data_source_updated_datetime);
CREATE INDEX idx_lien_priority_type__data_source_updated_datetime ON history_octane.lien_priority_type (data_source_updated_datetime);
CREATE INDEX idx_loan_access_type__data_source_updated_datetime ON history_octane.loan_access_type (data_source_updated_datetime);
CREATE INDEX idx_loan_amortization_type__data_source_updated_datetime ON history_octane.loan_amortization_type (data_source_updated_datetime);
CREATE INDEX idx_apor__data_source_updated_datetime ON history_octane.apor (data_source_updated_datetime);
CREATE INDEX idx_0078d0cac4d83c0d1c3082dbbcbdcc60 ON history_octane.loan_benef_transfer_status_type (data_source_updated_datetime);
CREATE INDEX idx_e6f20a205922dde3b1eb37bd5f6a1071 ON history_octane.loan_file_delivery_method_type (data_source_updated_datetime);
CREATE INDEX idx_loan_limit_table_type__data_source_updated_datetime ON history_octane.loan_limit_table_type (data_source_updated_datetime);
CREATE INDEX idx_loan_limit_table__data_source_updated_datetime ON history_octane.loan_limit_table (data_source_updated_datetime);
CREATE INDEX idx_loan_limit_type__data_source_updated_datetime ON history_octane.loan_limit_type (data_source_updated_datetime);
CREATE INDEX idx_loan_position_type__data_source_updated_datetime ON history_octane.loan_position_type (data_source_updated_datetime);
CREATE INDEX idx_loan_purpose_type__data_source_updated_datetime ON history_octane.loan_purpose_type (data_source_updated_datetime);
CREATE INDEX idx_loan_safe_product_type__data_source_updated_datetime ON history_octane.loan_safe_product_type (data_source_updated_datetime);
CREATE INDEX idx_loans_toolbox_permission_type__data_source_updated_datetime ON history_octane.loans_toolbox_permission_type (data_source_updated_datetime);
CREATE INDEX idx_lock_add_on_type__data_source_updated_datetime ON history_octane.lock_add_on_type (data_source_updated_datetime);
CREATE INDEX idx_lock_commitment_type__data_source_updated_datetime ON history_octane.lock_commitment_type (data_source_updated_datetime);
CREATE INDEX idx_lock_extension_status_type__data_source_updated_datetime ON history_octane.lock_extension_status_type (data_source_updated_datetime);
CREATE INDEX idx_lock_term_setting__data_source_updated_datetime ON history_octane.lock_term_setting (data_source_updated_datetime);
CREATE INDEX idx_los_loan_id_ticker__data_source_updated_datetime ON history_octane.los_loan_id_ticker (data_source_updated_datetime);
CREATE INDEX idx_lp_case_state_type__data_source_updated_datetime ON history_octane.lp_case_state_type (data_source_updated_datetime);
CREATE INDEX idx_0439ae1e5d067d04cc4ec31c9aa5f0d3 ON history_octane.lp_credit_risk_classification_type (data_source_updated_datetime);
CREATE INDEX idx_lp_dtd_version_type__data_source_updated_datetime ON history_octane.lp_dtd_version_type (data_source_updated_datetime);
CREATE INDEX idx_lp_evaluation_status_type__data_source_updated_datetime ON history_octane.lp_evaluation_status_type (data_source_updated_datetime);
CREATE INDEX idx_lp_finding_message_type__data_source_updated_datetime ON history_octane.lp_finding_message_type (data_source_updated_datetime);
CREATE INDEX idx_lp_interface_version_type__data_source_updated_datetime ON history_octane.lp_interface_version_type (data_source_updated_datetime);
CREATE INDEX idx_lp_request_status_type__data_source_updated_datetime ON history_octane.lp_request_status_type (data_source_updated_datetime);
CREATE INDEX idx_lp_submission_type__data_source_updated_datetime ON history_octane.lp_submission_type (data_source_updated_datetime);
CREATE INDEX idx_lqa_purchase_eligibility_type__data_source_updated_datetime ON history_octane.lqa_purchase_eligibility_type (data_source_updated_datetime);
CREATE INDEX idx_lura_file_repository_type__data_source_updated_datetime ON history_octane.lura_file_repository_type (data_source_updated_datetime);
CREATE INDEX idx_lura_setting_type__data_source_updated_datetime ON history_octane.lura_setting_type (data_source_updated_datetime);
CREATE INDEX idx_4268fd87e5801bfaeb9e091f48105803 ON history_octane.manufactured_home_certificate_of_title_type (data_source_updated_datetime);
CREATE INDEX idx_2ef0f30b8d2ffe3cdffce081886784bc ON history_octane.manufactured_home_leasehold_property_interest_type (data_source_updated_datetime);
CREATE INDEX idx_f6f0b0d394352b9ae1c48a3c398adbc4 ON history_octane.manufactured_home_loan_purpose_type (data_source_updated_datetime);
CREATE INDEX idx_marital_status_type__data_source_updated_datetime ON history_octane.marital_status_type (data_source_updated_datetime);
CREATE INDEX idx_b4618368c40320c0d566f34d15852ccc ON history_octane.master_property_insurance_type (data_source_updated_datetime);
CREATE INDEX idx_mcr_loan_status_type__data_source_updated_datetime ON history_octane.mcr_loan_status_type (data_source_updated_datetime);
CREATE INDEX idx_mercury_client_group__data_source_updated_datetime ON history_octane.mercury_client_group (data_source_updated_datetime);
CREATE INDEX idx_mercury_network_status_type__data_source_updated_datetime ON history_octane.mercury_network_status_type (data_source_updated_datetime);
CREATE INDEX idx_beb5801ff471fc77d3b9e5f9b6e88706 ON history_octane.mers_daily_report_import_status_type (data_source_updated_datetime);
CREATE INDEX idx_mers_registration_status_type__data_source_updated_datetime ON history_octane.mers_registration_status_type (data_source_updated_datetime);
CREATE INDEX idx_mers_transfer_batch__data_source_updated_datetime ON history_octane.mers_transfer_batch (data_source_updated_datetime);
CREATE INDEX idx_mers_transfer_status_type__data_source_updated_datetime ON history_octane.mers_transfer_status_type (data_source_updated_datetime);
CREATE INDEX idx_mi_calculated_rate_type__data_source_updated_datetime ON history_octane.mi_calculated_rate_type (data_source_updated_datetime);
CREATE INDEX idx_mi_company_name_type__data_source_updated_datetime ON history_octane.mi_company_name_type (data_source_updated_datetime);
CREATE INDEX idx_mi_initial_calculation_type__data_source_updated_datetime ON history_octane.mi_initial_calculation_type (data_source_updated_datetime);
CREATE INDEX idx_mi_input_type__data_source_updated_datetime ON history_octane.mi_input_type (data_source_updated_datetime);
CREATE INDEX idx_mi_integration_request_type__data_source_updated_datetime ON history_octane.mi_integration_request_type (data_source_updated_datetime);
CREATE INDEX idx_399087273c2ec35783109942cc8e7224 ON history_octane.mi_integration_vendor_request_status_type (data_source_updated_datetime);
CREATE INDEX idx_mi_payer_type__data_source_updated_datetime ON history_octane.mi_payer_type (data_source_updated_datetime);
CREATE INDEX idx_mi_payment_type__data_source_updated_datetime ON history_octane.mi_payment_type (data_source_updated_datetime);
CREATE INDEX idx_mi_premium_refundable_type__data_source_updated_datetime ON history_octane.mi_premium_refundable_type (data_source_updated_datetime);
CREATE INDEX idx_mi_renewal_calculation_type__data_source_updated_datetime ON history_octane.mi_renewal_calculation_type (data_source_updated_datetime);
CREATE INDEX idx_mi_submission_type__data_source_updated_datetime ON history_octane.mi_submission_type (data_source_updated_datetime);
CREATE INDEX idx_military_branch_type__data_source_updated_datetime ON history_octane.military_branch_type (data_source_updated_datetime);
CREATE INDEX idx_military_service_type__data_source_updated_datetime ON history_octane.military_service_type (data_source_updated_datetime);
CREATE INDEX idx_military_status_type__data_source_updated_datetime ON history_octane.military_status_type (data_source_updated_datetime);
CREATE INDEX idx_mismo_version_type__data_source_updated_datetime ON history_octane.mismo_version_type (data_source_updated_datetime);
CREATE INDEX idx_mortech_account__data_source_updated_datetime ON history_octane.mortech_account (data_source_updated_datetime);
CREATE INDEX idx_lead_source__data_source_updated_datetime ON history_octane.lead_source (data_source_updated_datetime);
CREATE INDEX idx_lead_campaign__data_source_updated_datetime ON history_octane.lead_campaign (data_source_updated_datetime);
CREATE INDEX idx_ed4c35b5f5ffb113dd13af8e0c4620ce ON history_octane.lead_supplemental_margin_table (data_source_updated_datetime);
CREATE INDEX idx_lead_supplemental_margin_row__data_source_updated_datetime ON history_octane.lead_supplemental_margin_row (data_source_updated_datetime);
CREATE INDEX idx_2445c818d7787d88c7c8383c065dcfff ON history_octane.mortgage_credit_certificate_issuer (data_source_updated_datetime);
CREATE INDEX idx_mortgage_type__data_source_updated_datetime ON history_octane.mortgage_type (data_source_updated_datetime);
CREATE INDEX idx_native_american_lands_type__data_source_updated_datetime ON history_octane.native_american_lands_type (data_source_updated_datetime);
CREATE INDEX idx_negative_amortization_type__data_source_updated_datetime ON history_octane.negative_amortization_type (data_source_updated_datetime);
CREATE INDEX idx_neighborhood_location_type__data_source_updated_datetime ON history_octane.neighborhood_location_type (data_source_updated_datetime);
CREATE INDEX idx_net_tangible_benefit_type__data_source_updated_datetime ON history_octane.net_tangible_benefit_type (data_source_updated_datetime);
CREATE INDEX idx_9379db229e0f6508cddd38d2bf4d0372 ON history_octane.nfip_community_participation_status_type (data_source_updated_datetime);
CREATE INDEX idx_obligation_amount_input_type__data_source_updated_datetime ON history_octane.obligation_amount_input_type (data_source_updated_datetime);
CREATE INDEX idx_obligation_charge_input_type__data_source_updated_datetime ON history_octane.obligation_charge_input_type (data_source_updated_datetime);
CREATE INDEX idx_obligation_type__data_source_updated_datetime ON history_octane.obligation_type (data_source_updated_datetime);
CREATE INDEX idx_offering_group__data_source_updated_datetime ON history_octane.offering_group (data_source_updated_datetime);
CREATE INDEX idx_offering__data_source_updated_datetime ON history_octane.offering (data_source_updated_datetime);
CREATE INDEX idx_org_division__data_source_updated_datetime ON history_octane.org_division (data_source_updated_datetime);
CREATE INDEX idx_org_division_terms__data_source_updated_datetime ON history_octane.org_division_terms (data_source_updated_datetime);
CREATE INDEX idx_org_group__data_source_updated_datetime ON history_octane.org_group (data_source_updated_datetime);
CREATE INDEX idx_org_group_terms__data_source_updated_datetime ON history_octane.org_group_terms (data_source_updated_datetime);
CREATE INDEX idx_org_leader_position_type__data_source_updated_datetime ON history_octane.org_leader_position_type (data_source_updated_datetime);
CREATE INDEX idx_org_region__data_source_updated_datetime ON history_octane.org_region (data_source_updated_datetime);
CREATE INDEX idx_org_region_terms__data_source_updated_datetime ON history_octane.org_region_terms (data_source_updated_datetime);
CREATE INDEX idx_org_team__data_source_updated_datetime ON history_octane.org_team (data_source_updated_datetime);
CREATE INDEX idx_org_unit__data_source_updated_datetime ON history_octane.org_unit (data_source_updated_datetime);
CREATE INDEX idx_org_team_terms__data_source_updated_datetime ON history_octane.org_team_terms (data_source_updated_datetime);
CREATE INDEX idx_org_unit_terms__data_source_updated_datetime ON history_octane.org_unit_terms (data_source_updated_datetime);
CREATE INDEX idx_origination_source_type__data_source_updated_datetime ON history_octane.origination_source_type (data_source_updated_datetime);
CREATE INDEX idx_other_income_type__data_source_updated_datetime ON history_octane.other_income_type (data_source_updated_datetime);
CREATE INDEX idx_partial_payment_policy_type__data_source_updated_datetime ON history_octane.partial_payment_policy_type (data_source_updated_datetime);
CREATE INDEX idx_938904d3353c0d1f39f872af85c9d55b ON history_octane.payment_adjustment_calculation_type (data_source_updated_datetime);
CREATE INDEX idx_payment_frequency_type__data_source_updated_datetime ON history_octane.payment_frequency_type (data_source_updated_datetime);
CREATE INDEX idx_payment_fulfill_type__data_source_updated_datetime ON history_octane.payment_fulfill_type (data_source_updated_datetime);
CREATE INDEX idx_268adb281a01331aa43b58753cb80e64 ON history_octane.payment_processing_company_type (data_source_updated_datetime);
CREATE INDEX idx_payment_request_type__data_source_updated_datetime ON history_octane.payment_request_type (data_source_updated_datetime);
CREATE INDEX idx_payment_structure_type__data_source_updated_datetime ON history_octane.payment_structure_type (data_source_updated_datetime);
CREATE INDEX idx_payment_type__data_source_updated_datetime ON history_octane.payment_type (data_source_updated_datetime);
CREATE INDEX idx_payoff_request_delivery_type__data_source_updated_datetime ON history_octane.payoff_request_delivery_type (data_source_updated_datetime);
CREATE INDEX idx_performer_team__data_source_updated_datetime ON history_octane.performer_team (data_source_updated_datetime);
CREATE INDEX idx_polling_interval_type__data_source_updated_datetime ON history_octane.polling_interval_type (data_source_updated_datetime);
CREATE INDEX idx_prepaid_interest_rate_type__data_source_updated_datetime ON history_octane.prepaid_interest_rate_type (data_source_updated_datetime);
CREATE INDEX idx_prepay_penalty_schedule_type__data_source_updated_datetime ON history_octane.prepay_penalty_schedule_type (data_source_updated_datetime);
CREATE INDEX idx_prepay_penalty_type__data_source_updated_datetime ON history_octane.prepay_penalty_type (data_source_updated_datetime);
CREATE INDEX idx_price_processing_time__data_source_updated_datetime ON history_octane.price_processing_time (data_source_updated_datetime);
CREATE INDEX idx_pricing_engine_type__data_source_updated_datetime ON history_octane.pricing_engine_type (data_source_updated_datetime);
CREATE INDEX idx_prior_property_title_type__data_source_updated_datetime ON history_octane.prior_property_title_type (data_source_updated_datetime);
CREATE INDEX idx_prior_to_type__data_source_updated_datetime ON history_octane.prior_to_type (data_source_updated_datetime);
CREATE INDEX idx_623fbf1694b8957537ffb89201e4c50e ON history_octane.product_appraisal_requirement_type (data_source_updated_datetime);
CREATE INDEX idx_c858ac39db7ba1a96180492e870120e5 ON history_octane.product_rule_domain_input_type (data_source_updated_datetime);
CREATE INDEX idx_product_side_type__data_source_updated_datetime ON history_octane.product_side_type (data_source_updated_datetime);
CREATE INDEX idx_product_special_program_type__data_source_updated_datetime ON history_octane.product_special_program_type (data_source_updated_datetime);
CREATE INDEX idx_profit_margin_type__data_source_updated_datetime ON history_octane.profit_margin_type (data_source_updated_datetime);
CREATE INDEX idx_project_classification_type__data_source_updated_datetime ON history_octane.project_classification_type (data_source_updated_datetime);
CREATE INDEX idx_project_design_type__data_source_updated_datetime ON history_octane.project_design_type (data_source_updated_datetime);
CREATE INDEX idx_property_category_type__data_source_updated_datetime ON history_octane.property_category_type (data_source_updated_datetime);
CREATE INDEX idx_3cef9781d2dd17d9911b6bdd26217a43 ON history_octane.property_repairs_holdback_calc_type (data_source_updated_datetime);
CREATE INDEX idx_fc08d7035b440ee02db1e4e4469a2a8f ON history_octane.property_repairs_holdback_payer_type (data_source_updated_datetime);
CREATE INDEX idx_400d1aa069b21e1569fd9dc766c34933 ON history_octane.property_repairs_required_type (data_source_updated_datetime);
CREATE INDEX idx_property_rights_type__data_source_updated_datetime ON history_octane.property_rights_type (data_source_updated_datetime);
CREATE INDEX idx_property_usage_type__data_source_updated_datetime ON history_octane.property_usage_type (data_source_updated_datetime);
CREATE INDEX idx_proposal_doc_file_type__data_source_updated_datetime ON history_octane.proposal_doc_file_type (data_source_updated_datetime);
CREATE INDEX idx_proposal_review_status_type__data_source_updated_datetime ON history_octane.proposal_review_status_type (data_source_updated_datetime);
CREATE INDEX idx_proposal_structure_type__data_source_updated_datetime ON history_octane.proposal_structure_type (data_source_updated_datetime);
CREATE INDEX idx_proposal_type__data_source_updated_datetime ON history_octane.proposal_type (data_source_updated_datetime);
CREATE INDEX idx_pte_request_status_type__data_source_updated_datetime ON history_octane.pte_request_status_type (data_source_updated_datetime);
CREATE INDEX idx_pte_response_status_type__data_source_updated_datetime ON history_octane.pte_response_status_type (data_source_updated_datetime);
CREATE INDEX idx_7d3b11509c6f5e24d5e384ee018f7d25 ON history_octane.public_record_disposition_type (data_source_updated_datetime);
CREATE INDEX idx_public_record_type__data_source_updated_datetime ON history_octane.public_record_type (data_source_updated_datetime);
CREATE INDEX idx_3b3cd13e8728c9a8dab6e0ff61c91970 ON history_octane.qualified_mortgage_status_type (data_source_updated_datetime);
CREATE INDEX idx_qualified_mortgage_thresholds__data_source_updated_datetime ON history_octane.qualified_mortgage_thresholds (data_source_updated_datetime);
CREATE INDEX idx_9b021bd566cffdfbf2114395584e6a90 ON history_octane.qualifying_monthly_payment_type (data_source_updated_datetime);
CREATE INDEX idx_qualifying_rate_type__data_source_updated_datetime ON history_octane.qualifying_rate_type (data_source_updated_datetime);
CREATE INDEX idx_quarter_type__data_source_updated_datetime ON history_octane.quarter_type (data_source_updated_datetime);
CREATE INDEX idx_mcr_snapshot__data_source_updated_datetime ON history_octane.mcr_snapshot (data_source_updated_datetime);
CREATE INDEX idx_mcr_loan__data_source_updated_datetime ON history_octane.mcr_loan (data_source_updated_datetime);
CREATE INDEX idx_quote_filter_pivot_type__data_source_updated_datetime ON history_octane.quote_filter_pivot_type (data_source_updated_datetime);
CREATE INDEX idx_realty_agent_scenario_type__data_source_updated_datetime ON history_octane.realty_agent_scenario_type (data_source_updated_datetime);
CREATE INDEX idx_recording_district_type__data_source_updated_datetime ON history_octane.recording_district_type (data_source_updated_datetime);
CREATE INDEX idx_refinance_improvements_type__data_source_updated_datetime ON history_octane.refinance_improvements_type (data_source_updated_datetime);
CREATE INDEX idx_relock_fee_setting__data_source_updated_datetime ON history_octane.relock_fee_setting (data_source_updated_datetime);
CREATE INDEX idx_reo_disposition_status_type__data_source_updated_datetime ON history_octane.reo_disposition_status_type (data_source_updated_datetime);
CREATE INDEX idx_report_request_status_type__data_source_updated_datetime ON history_octane.report_request_status_type (data_source_updated_datetime);
CREATE INDEX idx_report_type__data_source_updated_datetime ON history_octane.report_type (data_source_updated_datetime);
CREATE INDEX idx_report__data_source_updated_datetime ON history_octane.report (data_source_updated_datetime);
CREATE INDEX idx_report_row__data_source_updated_datetime ON history_octane.report_row (data_source_updated_datetime);
CREATE INDEX idx_formula_report_column__data_source_updated_datetime ON history_octane.formula_report_column (data_source_updated_datetime);
CREATE INDEX idx_report_column__data_source_updated_datetime ON history_octane.report_column (data_source_updated_datetime);
CREATE INDEX idx_req_decision_status_type__data_source_updated_datetime ON history_octane.req_decision_status_type (data_source_updated_datetime);
CREATE INDEX idx_req_fulfill_status_type__data_source_updated_datetime ON history_octane.req_fulfill_status_type (data_source_updated_datetime);
CREATE INDEX idx_rescission_notification_type__data_source_updated_datetime ON history_octane.rescission_notification_type (data_source_updated_datetime);
CREATE INDEX idx_respa_section_type__data_source_updated_datetime ON history_octane.respa_section_type (data_source_updated_datetime);
CREATE INDEX idx_charge_type__data_source_updated_datetime ON history_octane.charge_type (data_source_updated_datetime);
CREATE INDEX idx_road_type__data_source_updated_datetime ON history_octane.road_type (data_source_updated_datetime);
CREATE INDEX idx_role__data_source_updated_datetime ON history_octane.role (data_source_updated_datetime);
CREATE INDEX idx_key_role__data_source_updated_datetime ON history_octane.key_role (data_source_updated_datetime);
CREATE INDEX idx_role_charge_permissions__data_source_updated_datetime ON history_octane.role_charge_permissions (data_source_updated_datetime);
CREATE INDEX idx_role_config_export_permission__data_source_updated_datetime ON history_octane.role_config_export_permission (data_source_updated_datetime);
CREATE INDEX idx_role_deal_context__data_source_updated_datetime ON history_octane.role_deal_context (data_source_updated_datetime);
CREATE INDEX idx_role_export_permission__data_source_updated_datetime ON history_octane.role_export_permission (data_source_updated_datetime);
CREATE INDEX idx_role_lender_toolbox__data_source_updated_datetime ON history_octane.role_lender_toolbox (data_source_updated_datetime);
CREATE INDEX idx_role_loans_toolbox__data_source_updated_datetime ON history_octane.role_loans_toolbox (data_source_updated_datetime);
CREATE INDEX idx_role_performer_assign__data_source_updated_datetime ON history_octane.role_performer_assign (data_source_updated_datetime);
CREATE INDEX idx_role_report__data_source_updated_datetime ON history_octane.role_report (data_source_updated_datetime);
CREATE INDEX idx_sanitation_type__data_source_updated_datetime ON history_octane.sanitation_type (data_source_updated_datetime);
CREATE INDEX idx_sap_step_type__data_source_updated_datetime ON history_octane.sap_step_type (data_source_updated_datetime);
CREATE INDEX idx_80db9e8549a85ddf2fd0184c2e02cfed ON history_octane.secondary_admin_event_entity_type (data_source_updated_datetime);
CREATE INDEX idx_secondary_admin_event__data_source_updated_datetime ON history_octane.secondary_admin_event (data_source_updated_datetime);
CREATE INDEX idx_section_of_act_coarse_type__data_source_updated_datetime ON history_octane.section_of_act_coarse_type (data_source_updated_datetime);
CREATE INDEX idx_security_instrument_type__data_source_updated_datetime ON history_octane.security_instrument_type (data_source_updated_datetime);
CREATE INDEX idx_senior_lien_restriction_type__data_source_updated_datetime ON history_octane.senior_lien_restriction_type (data_source_updated_datetime);
CREATE INDEX idx_servicer_loan_id_assign_type__data_source_updated_datetime ON history_octane.servicer_loan_id_assign_type (data_source_updated_datetime);
CREATE INDEX idx_7b583499ad5743bf58f06ce69da8e282 ON history_octane.servicer_loan_id_import_request_status_type (data_source_updated_datetime);
CREATE INDEX idx_servicing_transfer_type__data_source_updated_datetime ON history_octane.servicing_transfer_type (data_source_updated_datetime);
CREATE INDEX idx_settlement_agent__data_source_updated_datetime ON history_octane.settlement_agent (data_source_updated_datetime);
CREATE INDEX idx_settlement_agent_office__data_source_updated_datetime ON history_octane.settlement_agent_office (data_source_updated_datetime);
CREATE INDEX idx_settlement_agent_wire__data_source_updated_datetime ON history_octane.settlement_agent_wire (data_source_updated_datetime);
CREATE INDEX idx_sheet_format_type__data_source_updated_datetime ON history_octane.sheet_format_type (data_source_updated_datetime);
CREATE INDEX idx_google_sheet_export__data_source_updated_datetime ON history_octane.google_sheet_export (data_source_updated_datetime);
CREATE INDEX idx_signature_part_type__data_source_updated_datetime ON history_octane.signature_part_type (data_source_updated_datetime);
CREATE INDEX idx_site_allowed_ip__data_source_updated_datetime ON history_octane.site_allowed_ip (data_source_updated_datetime);
CREATE INDEX idx_smart_charge_apr_type__data_source_updated_datetime ON history_octane.smart_charge_apr_type (data_source_updated_datetime);
CREATE INDEX idx_smart_charge__data_source_updated_datetime ON history_octane.smart_charge (data_source_updated_datetime);
CREATE INDEX idx_smart_charge_group__data_source_updated_datetime ON history_octane.smart_charge_group (data_source_updated_datetime);
CREATE INDEX idx_smart_charge_group_case__data_source_updated_datetime ON history_octane.smart_charge_group_case (data_source_updated_datetime);
CREATE INDEX idx_smart_charge_case__data_source_updated_datetime ON history_octane.smart_charge_case (data_source_updated_datetime);
CREATE INDEX idx_smart_message_delivery_type__data_source_updated_datetime ON history_octane.smart_message_delivery_type (data_source_updated_datetime);
CREATE INDEX idx_3cd54c6f7f99074cfa53517a295984a4 ON history_octane.smart_message_email_recipient_type (data_source_updated_datetime);
CREATE INDEX idx_smart_message_recipient_type__data_source_updated_datetime ON history_octane.smart_message_recipient_type (data_source_updated_datetime);
CREATE INDEX idx_smart_message_source_type__data_source_updated_datetime ON history_octane.smart_message_source_type (data_source_updated_datetime);
CREATE INDEX idx_smart_mi__data_source_updated_datetime ON history_octane.smart_mi (data_source_updated_datetime);
CREATE INDEX idx_smart_mi_eligibility_case__data_source_updated_datetime ON history_octane.smart_mi_eligibility_case (data_source_updated_datetime);
CREATE INDEX idx_smart_mi_rate_card__data_source_updated_datetime ON history_octane.smart_mi_rate_card (data_source_updated_datetime);
CREATE INDEX idx_smart_mi_rate_adjustment_case__data_source_updated_datetime ON history_octane.smart_mi_rate_adjustment_case (data_source_updated_datetime);
CREATE INDEX idx_smart_mi_rate_case__data_source_updated_datetime ON history_octane.smart_mi_rate_case (data_source_updated_datetime);
CREATE INDEX idx_smart_mi_surcharge__data_source_updated_datetime ON history_octane.smart_mi_surcharge (data_source_updated_datetime);
CREATE INDEX idx_smart_mi_surcharge_case__data_source_updated_datetime ON history_octane.smart_mi_surcharge_case (data_source_updated_datetime);
CREATE INDEX idx_smart_stack__data_source_updated_datetime ON history_octane.smart_stack (data_source_updated_datetime);
CREATE INDEX idx_09ea9135341c15df2d1dba242cdbbd37 ON history_octane.smart_stack_doc_set_include_option_type (data_source_updated_datetime);
CREATE INDEX idx_smart_doc_set__data_source_updated_datetime ON history_octane.smart_doc_set (data_source_updated_datetime);
CREATE INDEX idx_key_package__data_source_updated_datetime ON history_octane.key_package (data_source_updated_datetime);
CREATE INDEX idx_c27fa5d1cddb1a2b57c2679e5f7241fc ON history_octane.smart_stack_doc_set_include_type (data_source_updated_datetime);
CREATE INDEX idx_solar_panel_type__data_source_updated_datetime ON history_octane.solar_panel_type (data_source_updated_datetime);
CREATE INDEX idx_stack_doc_type__data_source_updated_datetime ON history_octane.stack_doc_type (data_source_updated_datetime);
CREATE INDEX idx_40e27eee26cab30f24440eab7fa7a60a ON history_octane.stack_export_file_name_format_type (data_source_updated_datetime);
CREATE INDEX idx_stack_export_file_type__data_source_updated_datetime ON history_octane.stack_export_file_type (data_source_updated_datetime);
CREATE INDEX idx_ebf40efa982aa0e5b01929480cfc3b9c ON history_octane.stack_export_loan_name_format_type (data_source_updated_datetime);
CREATE INDEX idx_9c2d5783bb393705f43c0ba0115cac4f ON history_octane.stack_export_request_loan_export_type (data_source_updated_datetime);
CREATE INDEX idx_be36282c14483800cb24afad669c1cce ON history_octane.stack_export_request_status_type (data_source_updated_datetime);
CREATE INDEX idx_state_type__data_source_updated_datetime ON history_octane.state_type (data_source_updated_datetime);
CREATE INDEX idx_county__data_source_updated_datetime ON history_octane.county (data_source_updated_datetime);
CREATE INDEX idx_area_median_income_row__data_source_updated_datetime ON history_octane.area_median_income_row (data_source_updated_datetime);
CREATE INDEX idx_county_city__data_source_updated_datetime ON history_octane.county_city (data_source_updated_datetime);
CREATE INDEX idx_county_sub_jurisdiction__data_source_updated_datetime ON history_octane.county_sub_jurisdiction (data_source_updated_datetime);
CREATE INDEX idx_disaster_declaration__data_source_updated_datetime ON history_octane.disaster_declaration (data_source_updated_datetime);
CREATE INDEX idx_license_req__data_source_updated_datetime ON history_octane.license_req (data_source_updated_datetime);
CREATE INDEX idx_loan_limit_row__data_source_updated_datetime ON history_octane.loan_limit_row (data_source_updated_datetime);
CREATE INDEX idx_recording_city__data_source_updated_datetime ON history_octane.recording_city (data_source_updated_datetime);
CREATE INDEX idx_recording_district__data_source_updated_datetime ON history_octane.recording_district (data_source_updated_datetime);
CREATE INDEX idx_county_recording_district__data_source_updated_datetime ON history_octane.county_recording_district (data_source_updated_datetime);
CREATE INDEX idx_region_ernst_page_rec__data_source_updated_datetime ON history_octane.region_ernst_page_rec (data_source_updated_datetime);
CREATE INDEX idx_street_links_product_type__data_source_updated_datetime ON history_octane.street_links_product_type (data_source_updated_datetime);
CREATE INDEX idx_stripe_payment_status_type__data_source_updated_datetime ON history_octane.stripe_payment_status_type (data_source_updated_datetime);
CREATE INDEX idx_stripe_payment__data_source_updated_datetime ON history_octane.stripe_payment (data_source_updated_datetime);
CREATE INDEX idx_tax_filing_status_type__data_source_updated_datetime ON history_octane.tax_filing_status_type (data_source_updated_datetime);
CREATE INDEX idx_1210c62ce475577d167d68ea630571d9 ON history_octane.tax_transcript_request_status_type (data_source_updated_datetime);
CREATE INDEX idx_taxpayer_identifier_type__data_source_updated_datetime ON history_octane.taxpayer_identifier_type (data_source_updated_datetime);
CREATE INDEX idx_contractor__data_source_updated_datetime ON history_octane.contractor (data_source_updated_datetime);
CREATE INDEX idx_contractor_license__data_source_updated_datetime ON history_octane.contractor_license (data_source_updated_datetime);
CREATE INDEX idx_00624c22e5567e075825b769cc1849af ON history_octane.third_party_community_second_program_eligibility_type (data_source_updated_datetime);
CREATE INDEX idx_time_zone_type__data_source_updated_datetime ON history_octane.time_zone_type (data_source_updated_datetime);
CREATE INDEX idx_admin_user__data_source_updated_datetime ON history_octane.admin_user (data_source_updated_datetime);
CREATE INDEX idx_borrower_user__data_source_updated_datetime ON history_octane.borrower_user (data_source_updated_datetime);
CREATE INDEX idx_timeout_time_zone_type__data_source_updated_datetime ON history_octane.timeout_time_zone_type (data_source_updated_datetime);
CREATE INDEX idx_title_company__data_source_updated_datetime ON history_octane.title_company (data_source_updated_datetime);
CREATE INDEX idx_title_company_office__data_source_updated_datetime ON history_octane.title_company_office (data_source_updated_datetime);
CREATE INDEX idx_preferred_settlement__data_source_updated_datetime ON history_octane.preferred_settlement (data_source_updated_datetime);
CREATE INDEX idx_title_manner_held_type__data_source_updated_datetime ON history_octane.title_manner_held_type (data_source_updated_datetime);
CREATE INDEX idx_total_expert_account_type__data_source_updated_datetime ON history_octane.total_expert_account_type (data_source_updated_datetime);
CREATE INDEX idx_trade_audit_type__data_source_updated_datetime ON history_octane.trade_audit_type (data_source_updated_datetime);
CREATE INDEX idx_trade_fee_type__data_source_updated_datetime ON history_octane.trade_fee_type (data_source_updated_datetime);
CREATE INDEX idx_trade_pricing_type__data_source_updated_datetime ON history_octane.trade_pricing_type (data_source_updated_datetime);
CREATE INDEX idx_trade_status_type__data_source_updated_datetime ON history_octane.trade_status_type (data_source_updated_datetime);
CREATE INDEX idx_trustee__data_source_updated_datetime ON history_octane.trustee (data_source_updated_datetime);
CREATE INDEX idx_underwrite_disposition_type__data_source_updated_datetime ON history_octane.underwrite_disposition_type (data_source_updated_datetime);
CREATE INDEX idx_underwrite_method_type__data_source_updated_datetime ON history_octane.underwrite_method_type (data_source_updated_datetime);
CREATE INDEX idx_19b178f053393ae90076603fec1019d7 ON history_octane.underwrite_risk_assessment_type (data_source_updated_datetime);
CREATE INDEX idx_unique_dwelling_type__data_source_updated_datetime ON history_octane.unique_dwelling_type (data_source_updated_datetime);
CREATE INDEX idx_ca2c375ae50e62c5e1174f1ee5f9568e ON history_octane.usda_rd_single_family_housing_type (data_source_updated_datetime);
CREATE INDEX idx_uuts_loan_originator_type__data_source_updated_datetime ON history_octane.uuts_loan_originator_type (data_source_updated_datetime);
CREATE INDEX idx_5338409d8afdaa2c27664c5c867f210a ON history_octane.va_borrower_certification_occupancy_type (data_source_updated_datetime);
CREATE INDEX idx_va_entitlement_code_type__data_source_updated_datetime ON history_octane.va_entitlement_code_type (data_source_updated_datetime);
CREATE INDEX idx_d23cf13e8e4ab0b49776808637f30b71 ON history_octane.va_entitlement_restoration_type (data_source_updated_datetime);
CREATE INDEX idx_2219a650a3a2503adce8b8f9bf815ee0 ON history_octane.va_notice_of_value_source_type (data_source_updated_datetime);
CREATE INDEX idx_va_past_credit_record_type__data_source_updated_datetime ON history_octane.va_past_credit_record_type (data_source_updated_datetime);
CREATE INDEX idx_va_regional_loan_center_type__data_source_updated_datetime ON history_octane.va_regional_loan_center_type (data_source_updated_datetime);
CREATE INDEX idx_va_relative_relationship_type__data_source_updated_datetime ON history_octane.va_relative_relationship_type (data_source_updated_datetime);
CREATE INDEX idx_vendor_credential_source_type__data_source_updated_datetime ON history_octane.vendor_credential_source_type (data_source_updated_datetime);
CREATE INDEX idx_vendor_document_event_type__data_source_updated_datetime ON history_octane.vendor_document_event_type (data_source_updated_datetime);
CREATE INDEX idx_vendor_import_document_type__data_source_updated_datetime ON history_octane.vendor_import_document_type (data_source_updated_datetime);
CREATE INDEX idx_veteran_status_type__data_source_updated_datetime ON history_octane.veteran_status_type (data_source_updated_datetime);
CREATE INDEX idx_voe_third_party_verifier_type__data_source_updated_datetime ON history_octane.voe_third_party_verifier_type (data_source_updated_datetime);
CREATE INDEX idx_voe_verbal_verify_method_type__data_source_updated_datetime ON history_octane.voe_verbal_verify_method_type (data_source_updated_datetime);
CREATE INDEX idx_voe_verify_method_type__data_source_updated_datetime ON history_octane.voe_verify_method_type (data_source_updated_datetime);
CREATE INDEX idx_water_type__data_source_updated_datetime ON history_octane.water_type (data_source_updated_datetime);
CREATE INDEX idx_wf_deal_process_status_type__data_source_updated_datetime ON history_octane.wf_deal_process_status_type (data_source_updated_datetime);
CREATE INDEX idx_wf_deal_step_status_type__data_source_updated_datetime ON history_octane.wf_deal_step_status_type (data_source_updated_datetime);
CREATE INDEX idx_wf_outcome_type__data_source_updated_datetime ON history_octane.wf_outcome_type (data_source_updated_datetime);
CREATE INDEX idx_wf_phase__data_source_updated_datetime ON history_octane.wf_phase (data_source_updated_datetime);
CREATE INDEX idx_wf_process_status_type__data_source_updated_datetime ON history_octane.wf_process_status_type (data_source_updated_datetime);
CREATE INDEX idx_wf_process_type__data_source_updated_datetime ON history_octane.wf_process_type (data_source_updated_datetime);
CREATE INDEX idx_wf_process__data_source_updated_datetime ON history_octane.wf_process (data_source_updated_datetime);
CREATE INDEX idx_wf_step_function_type__data_source_updated_datetime ON history_octane.wf_step_function_type (data_source_updated_datetime);
CREATE INDEX idx_wf_step_performer_assign_type__data_source_updated_datetime ON history_octane.wf_step_performer_assign_type (data_source_updated_datetime);
CREATE INDEX idx_wf_step_reassign_type__data_source_updated_datetime ON history_octane.wf_step_reassign_type (data_source_updated_datetime);
CREATE INDEX idx_wf_step_timeout_type__data_source_updated_datetime ON history_octane.wf_step_timeout_type (data_source_updated_datetime);
CREATE INDEX idx_wf_step_type__data_source_updated_datetime ON history_octane.wf_step_type (data_source_updated_datetime);
CREATE INDEX idx_wf_wait_until_time_slice__data_source_updated_datetime ON history_octane.wf_wait_until_time_slice (data_source_updated_datetime);
CREATE INDEX idx_yes_no_na_type__data_source_updated_datetime ON history_octane.yes_no_na_type (data_source_updated_datetime);
CREATE INDEX idx_yes_no_na_unknown_type__data_source_updated_datetime ON history_octane.yes_no_na_unknown_type (data_source_updated_datetime);
CREATE INDEX idx_yes_no_unknown_type__data_source_updated_datetime ON history_octane.yes_no_unknown_type (data_source_updated_datetime);
CREATE INDEX idx_application__data_source_updated_datetime ON history_octane.application (data_source_updated_datetime);
CREATE INDEX idx_asset__data_source_updated_datetime ON history_octane.asset (data_source_updated_datetime);
CREATE INDEX idx_asset_large_deposit__data_source_updated_datetime ON history_octane.asset_large_deposit (data_source_updated_datetime);
CREATE INDEX idx_creditor__data_source_updated_datetime ON history_octane.creditor (data_source_updated_datetime);
CREATE INDEX idx_creditor_lookup_name__data_source_updated_datetime ON history_octane.creditor_lookup_name (data_source_updated_datetime);
CREATE INDEX idx_investor__data_source_updated_datetime ON history_octane.investor (data_source_updated_datetime);
CREATE INDEX idx_company__data_source_updated_datetime ON history_octane.company (data_source_updated_datetime);
CREATE INDEX idx_branch__data_source_updated_datetime ON history_octane.branch (data_source_updated_datetime);
CREATE INDEX idx_branch_license__data_source_updated_datetime ON history_octane.branch_license (data_source_updated_datetime);
CREATE INDEX idx_company_license__data_source_updated_datetime ON history_octane.company_license (data_source_updated_datetime);
CREATE INDEX idx_deal__data_source_updated_datetime ON history_octane.deal (data_source_updated_datetime);
CREATE INDEX idx_appraisal__data_source_updated_datetime ON history_octane.appraisal (data_source_updated_datetime);
CREATE INDEX idx_appraisal_form__data_source_updated_datetime ON history_octane.appraisal_form (data_source_updated_datetime);
CREATE INDEX idx_appraisal_id_ticker__data_source_updated_datetime ON history_octane.appraisal_id_ticker (data_source_updated_datetime);
CREATE INDEX idx_deal_appraisal__data_source_updated_datetime ON history_octane.deal_appraisal (data_source_updated_datetime);
CREATE INDEX idx_deal_contact__data_source_updated_datetime ON history_octane.deal_contact (data_source_updated_datetime);
CREATE INDEX idx_deal_disaster_declaration__data_source_updated_datetime ON history_octane.deal_disaster_declaration (data_source_updated_datetime);
CREATE INDEX idx_deal_du__data_source_updated_datetime ON history_octane.deal_du (data_source_updated_datetime);
CREATE INDEX idx_deal_event__data_source_updated_datetime ON history_octane.deal_event (data_source_updated_datetime);
CREATE INDEX idx_7b17954e0c86ba97a1a153429a2558f6 ON history_octane.deal_housing_counselors_request (data_source_updated_datetime);
CREATE INDEX idx_f0d200309765aca171d0babd52ac08e8 ON history_octane.deal_housing_counselor_candidate (data_source_updated_datetime);
CREATE INDEX idx_deal_invoice__data_source_updated_datetime ON history_octane.deal_invoice (data_source_updated_datetime);
CREATE INDEX idx_deal_invoice_item__data_source_updated_datetime ON history_octane.deal_invoice_item (data_source_updated_datetime);
CREATE INDEX idx_deal_lender_user_event__data_source_updated_datetime ON history_octane.deal_lender_user_event (data_source_updated_datetime);
CREATE INDEX idx_deal_lp__data_source_updated_datetime ON history_octane.deal_lp (data_source_updated_datetime);
CREATE INDEX idx_deal_performer_team__data_source_updated_datetime ON history_octane.deal_performer_team (data_source_updated_datetime);
CREATE INDEX idx_deal_real_estate_agent__data_source_updated_datetime ON history_octane.deal_real_estate_agent (data_source_updated_datetime);
CREATE INDEX idx_deal_settlement__data_source_updated_datetime ON history_octane.deal_settlement (data_source_updated_datetime);
CREATE INDEX idx_deal_signer__data_source_updated_datetime ON history_octane.deal_signer (data_source_updated_datetime);
CREATE INDEX idx_deal_stage__data_source_updated_datetime ON history_octane.deal_stage (data_source_updated_datetime);
CREATE INDEX idx_deal_summary__data_source_updated_datetime ON history_octane.deal_summary (data_source_updated_datetime);
CREATE INDEX idx_bef384a66ce455683523a4af94c2afa1 ON history_octane.investor_lock_extension_setting (data_source_updated_datetime);
CREATE INDEX idx_lead__data_source_updated_datetime ON history_octane.lead (data_source_updated_datetime);
CREATE INDEX idx_lender_user__data_source_updated_datetime ON history_octane.lender_user (data_source_updated_datetime);
CREATE INDEX idx_backfill_status__data_source_updated_datetime ON history_octane.backfill_status (data_source_updated_datetime);
CREATE INDEX idx_backfill_loan_status__data_source_updated_datetime ON history_octane.backfill_loan_status (data_source_updated_datetime);
CREATE INDEX idx_bid_pool_note__data_source_updated_datetime ON history_octane.bid_pool_note (data_source_updated_datetime);
CREATE INDEX idx_bid_pool_note_comment__data_source_updated_datetime ON history_octane.bid_pool_note_comment (data_source_updated_datetime);
CREATE INDEX idx_bid_pool_note_monitor__data_source_updated_datetime ON history_octane.bid_pool_note_monitor (data_source_updated_datetime);
CREATE INDEX idx_branch_account_executive__data_source_updated_datetime ON history_octane.branch_account_executive (data_source_updated_datetime);
CREATE INDEX idx_deal_invoice_payment_method__data_source_updated_datetime ON history_octane.deal_invoice_payment_method (data_source_updated_datetime);
CREATE INDEX idx_deal_key_roles__data_source_updated_datetime ON history_octane.deal_key_roles (data_source_updated_datetime);
CREATE INDEX idx_deal_lender_user__data_source_updated_datetime ON history_octane.deal_lender_user (data_source_updated_datetime);
CREATE INDEX idx_deal_performer_team_user__data_source_updated_datetime ON history_octane.deal_performer_team_user (data_source_updated_datetime);
CREATE INDEX idx_dw_export_request__data_source_updated_datetime ON history_octane.dw_export_request (data_source_updated_datetime);
CREATE INDEX idx_lender_settings__data_source_updated_datetime ON history_octane.lender_settings (data_source_updated_datetime);
CREATE INDEX idx_lender_user_allowed_ip__data_source_updated_datetime ON history_octane.lender_user_allowed_ip (data_source_updated_datetime);
CREATE INDEX idx_lender_user_deal_visit__data_source_updated_datetime ON history_octane.lender_user_deal_visit (data_source_updated_datetime);
CREATE INDEX idx_lender_user_lead_source__data_source_updated_datetime ON history_octane.lender_user_lead_source (data_source_updated_datetime);
CREATE INDEX idx_lender_user_license__data_source_updated_datetime ON history_octane.lender_user_license (data_source_updated_datetime);
CREATE INDEX idx_lender_user_notice__data_source_updated_datetime ON history_octane.lender_user_notice (data_source_updated_datetime);
CREATE INDEX idx_lender_user_role__data_source_updated_datetime ON history_octane.lender_user_role (data_source_updated_datetime);
CREATE INDEX idx_exclusive_assignment__data_source_updated_datetime ON history_octane.exclusive_assignment (data_source_updated_datetime);
CREATE INDEX idx_lender_user_role_addendum__data_source_updated_datetime ON history_octane.lender_user_role_addendum (data_source_updated_datetime);
CREATE INDEX idx_lender_user_sign_on__data_source_updated_datetime ON history_octane.lender_user_sign_on (data_source_updated_datetime);
CREATE INDEX idx_lender_user_unavailable__data_source_updated_datetime ON history_octane.lender_user_unavailable (data_source_updated_datetime);
CREATE INDEX idx_ce7e4fd55e05f73cc655286b4e43f702 ON history_octane.mercury_network_status_request (data_source_updated_datetime);
CREATE INDEX idx_org_division_leader__data_source_updated_datetime ON history_octane.org_division_leader (data_source_updated_datetime);
CREATE INDEX idx_org_group_leader__data_source_updated_datetime ON history_octane.org_group_leader (data_source_updated_datetime);
CREATE INDEX idx_org_lender_user_terms__data_source_updated_datetime ON history_octane.org_lender_user_terms (data_source_updated_datetime);
CREATE INDEX idx_org_region_leader__data_source_updated_datetime ON history_octane.org_region_leader (data_source_updated_datetime);
CREATE INDEX idx_org_team_leader__data_source_updated_datetime ON history_octane.org_team_leader (data_source_updated_datetime);
CREATE INDEX idx_org_unit_leader__data_source_updated_datetime ON history_octane.org_unit_leader (data_source_updated_datetime);
CREATE INDEX idx_performer_assignment__data_source_updated_datetime ON history_octane.performer_assignment (data_source_updated_datetime);
CREATE INDEX idx_product__data_source_updated_datetime ON history_octane.product (data_source_updated_datetime);
CREATE INDEX idx_offering_product__data_source_updated_datetime ON history_octane.offering_product (data_source_updated_datetime);
CREATE INDEX idx_product_add_on__data_source_updated_datetime ON history_octane.product_add_on (data_source_updated_datetime);
CREATE INDEX idx_product_add_on_rule__data_source_updated_datetime ON history_octane.product_add_on_rule (data_source_updated_datetime);
CREATE INDEX idx_product_branch__data_source_updated_datetime ON history_octane.product_branch (data_source_updated_datetime);
CREATE INDEX idx_product_deal_check_exclusion__data_source_updated_datetime ON history_octane.product_deal_check_exclusion (data_source_updated_datetime);
CREATE INDEX idx_product_eligibility__data_source_updated_datetime ON history_octane.product_eligibility (data_source_updated_datetime);
CREATE INDEX idx_product_eligibility_rule__data_source_updated_datetime ON history_octane.product_eligibility_rule (data_source_updated_datetime);
CREATE INDEX idx_product_lock_term__data_source_updated_datetime ON history_octane.product_lock_term (data_source_updated_datetime);
CREATE INDEX idx_c1226fd344ab1136f9876fb689406413 ON history_octane.product_maximum_investor_price (data_source_updated_datetime);
CREATE INDEX idx_product_maximum_rebate__data_source_updated_datetime ON history_octane.product_maximum_rebate (data_source_updated_datetime);
CREATE INDEX idx_3b025cbe2c86f18dff4ee158839919e1 ON history_octane.product_minimum_investor_price (data_source_updated_datetime);
CREATE INDEX idx_product_originator__data_source_updated_datetime ON history_octane.product_originator (data_source_updated_datetime);
CREATE INDEX idx_product_terms__data_source_updated_datetime ON history_octane.product_terms (data_source_updated_datetime);
CREATE INDEX idx_product_buydown__data_source_updated_datetime ON history_octane.product_buydown (data_source_updated_datetime);
CREATE INDEX idx_product_interest_only__data_source_updated_datetime ON history_octane.product_interest_only (data_source_updated_datetime);
CREATE INDEX idx_product_prepay_penalty__data_source_updated_datetime ON history_octane.product_prepay_penalty (data_source_updated_datetime);
CREATE INDEX idx_rate_sheet__data_source_updated_datetime ON history_octane.rate_sheet (data_source_updated_datetime);
CREATE INDEX idx_rate_sheet_rate__data_source_updated_datetime ON history_octane.rate_sheet_rate (data_source_updated_datetime);
CREATE INDEX idx_rate_sheet_price__data_source_updated_datetime ON history_octane.rate_sheet_price (data_source_updated_datetime);
CREATE INDEX idx_repository_file__data_source_updated_datetime ON history_octane.repository_file (data_source_updated_datetime);
CREATE INDEX idx_bid_pool_file__data_source_updated_datetime ON history_octane.bid_pool_file (data_source_updated_datetime);
CREATE INDEX idx_a2987eba562bb417cbf94ade3ebf6176 ON history_octane.compass_analytics_report_request (data_source_updated_datetime);
CREATE INDEX idx_consumer_privacy_request__data_source_updated_datetime ON history_octane.consumer_privacy_request (data_source_updated_datetime);
CREATE INDEX idx_custom_form__data_source_updated_datetime ON history_octane.custom_form (data_source_updated_datetime);
CREATE INDEX idx_custom_form_merge_field__data_source_updated_datetime ON history_octane.custom_form_merge_field (data_source_updated_datetime);
CREATE INDEX idx_deal_file__data_source_updated_datetime ON history_octane.deal_file (data_source_updated_datetime);
CREATE INDEX idx_appraisal_file__data_source_updated_datetime ON history_octane.appraisal_file (data_source_updated_datetime);
CREATE INDEX idx_deal_dropbox_file__data_source_updated_datetime ON history_octane.deal_dropbox_file (data_source_updated_datetime);
CREATE INDEX idx_deal_file_signature__data_source_updated_datetime ON history_octane.deal_file_signature (data_source_updated_datetime);
CREATE INDEX idx_deal_fraud_risk__data_source_updated_datetime ON history_octane.deal_fraud_risk (data_source_updated_datetime);
CREATE INDEX idx_deal_invoice_file__data_source_updated_datetime ON history_octane.deal_invoice_file (data_source_updated_datetime);
CREATE INDEX idx_deal_message_log__data_source_updated_datetime ON history_octane.deal_message_log (data_source_updated_datetime);
CREATE INDEX idx_deal_system_file__data_source_updated_datetime ON history_octane.deal_system_file (data_source_updated_datetime);
CREATE INDEX idx_appraisal_order_request__data_source_updated_datetime ON history_octane.appraisal_order_request (data_source_updated_datetime);
CREATE INDEX idx_appraisal_order_request_file__data_source_updated_datetime ON history_octane.appraisal_order_request_file (data_source_updated_datetime);
CREATE INDEX idx_deal_file_thumbnail__data_source_updated_datetime ON history_octane.deal_file_thumbnail (data_source_updated_datetime);
CREATE INDEX idx_du_request__data_source_updated_datetime ON history_octane.du_request (data_source_updated_datetime);
CREATE INDEX idx_du_key_finding__data_source_updated_datetime ON history_octane.du_key_finding (data_source_updated_datetime);
CREATE INDEX idx_du_refi_plus_finding__data_source_updated_datetime ON history_octane.du_refi_plus_finding (data_source_updated_datetime);
CREATE INDEX idx_du_request_credit__data_source_updated_datetime ON history_octane.du_request_credit (data_source_updated_datetime);
CREATE INDEX idx_du_special_feature_code__data_source_updated_datetime ON history_octane.du_special_feature_code (data_source_updated_datetime);
CREATE INDEX idx_flood_cert__data_source_updated_datetime ON history_octane.flood_cert (data_source_updated_datetime);
CREATE INDEX idx_hmda_report_request__data_source_updated_datetime ON history_octane.hmda_report_request (data_source_updated_datetime);
CREATE INDEX idx_lender_user_photo__data_source_updated_datetime ON history_octane.lender_user_photo (data_source_updated_datetime);
CREATE INDEX idx_lp_request__data_source_updated_datetime ON history_octane.lp_request (data_source_updated_datetime);
CREATE INDEX idx_credit_request__data_source_updated_datetime ON history_octane.credit_request (data_source_updated_datetime);
CREATE INDEX idx_borrower__data_source_updated_datetime ON history_octane.borrower (data_source_updated_datetime);
CREATE INDEX idx_borrower_alias__data_source_updated_datetime ON history_octane.borrower_alias (data_source_updated_datetime);
CREATE INDEX idx_borrower_asset__data_source_updated_datetime ON history_octane.borrower_asset (data_source_updated_datetime);
CREATE INDEX idx_borrower_associated_address__data_source_updated_datetime ON history_octane.borrower_associated_address (data_source_updated_datetime);
CREATE INDEX idx_borrower_dependent__data_source_updated_datetime ON history_octane.borrower_dependent (data_source_updated_datetime);
CREATE INDEX idx_borrower_income__data_source_updated_datetime ON history_octane.borrower_income (data_source_updated_datetime);
CREATE INDEX idx_borrower_job_gap__data_source_updated_datetime ON history_octane.borrower_job_gap (data_source_updated_datetime);
CREATE INDEX idx_borrower_user_deal__data_source_updated_datetime ON history_octane.borrower_user_deal (data_source_updated_datetime);
CREATE INDEX idx_borrower_user_change_email__data_source_updated_datetime ON history_octane.borrower_user_change_email (data_source_updated_datetime);
CREATE INDEX idx_business_income__data_source_updated_datetime ON history_octane.business_income (data_source_updated_datetime);
CREATE INDEX idx_80f21523e2d55c562acd806a5983c7d2 ON history_octane.consumer_privacy_affected_borrower (data_source_updated_datetime);
CREATE INDEX idx_job_income__data_source_updated_datetime ON history_octane.job_income (data_source_updated_datetime);
CREATE INDEX idx_lp_finding__data_source_updated_datetime ON history_octane.lp_finding (data_source_updated_datetime);
CREATE INDEX idx_lp_request_credit__data_source_updated_datetime ON history_octane.lp_request_credit (data_source_updated_datetime);
CREATE INDEX idx_mers_daily_report__data_source_updated_datetime ON history_octane.mers_daily_report (data_source_updated_datetime);
CREATE INDEX idx_military_service__data_source_updated_datetime ON history_octane.military_service (data_source_updated_datetime);
CREATE INDEX idx_other_income__data_source_updated_datetime ON history_octane.other_income (data_source_updated_datetime);
CREATE INDEX idx_proposal__data_source_updated_datetime ON history_octane.proposal (data_source_updated_datetime);
CREATE INDEX idx_aus_request_number_ticker__data_source_updated_datetime ON history_octane.aus_request_number_ticker (data_source_updated_datetime);
CREATE INDEX idx_construction_draw__data_source_updated_datetime ON history_octane.construction_draw (data_source_updated_datetime);
CREATE INDEX idx_4dc415afa171940e92646ce89e9f9385 ON history_octane.construction_draw_number_ticker (data_source_updated_datetime);
CREATE INDEX idx_credit_inquiry__data_source_updated_datetime ON history_octane.credit_inquiry (data_source_updated_datetime);
CREATE INDEX idx_borrower_credit_inquiry__data_source_updated_datetime ON history_octane.borrower_credit_inquiry (data_source_updated_datetime);
CREATE INDEX idx_deal_snapshot__data_source_updated_datetime ON history_octane.deal_snapshot (data_source_updated_datetime);
CREATE INDEX idx_docusign_package__data_source_updated_datetime ON history_octane.docusign_package (data_source_updated_datetime);
CREATE INDEX idx_master_property_insurance__data_source_updated_datetime ON history_octane.master_property_insurance (data_source_updated_datetime);
CREATE INDEX idx_mi_integration_vendor_request__data_source_updated_datetime ON history_octane.mi_integration_vendor_request (data_source_updated_datetime);
CREATE INDEX idx_loan__data_source_updated_datetime ON history_octane.loan (data_source_updated_datetime);
CREATE INDEX idx_circumstance_change__data_source_updated_datetime ON history_octane.circumstance_change (data_source_updated_datetime);
CREATE INDEX idx_ernst_request__data_source_updated_datetime ON history_octane.ernst_request (data_source_updated_datetime);
CREATE INDEX idx_ernst_request_question__data_source_updated_datetime ON history_octane.ernst_request_question (data_source_updated_datetime);
CREATE INDEX idx_loan_beneficiary__data_source_updated_datetime ON history_octane.loan_beneficiary (data_source_updated_datetime);
CREATE INDEX idx_loan_closing_doc__data_source_updated_datetime ON history_octane.loan_closing_doc (data_source_updated_datetime);
CREATE INDEX idx_loan_eligible_investor__data_source_updated_datetime ON history_octane.loan_eligible_investor (data_source_updated_datetime);
CREATE INDEX idx_loan_funding__data_source_updated_datetime ON history_octane.loan_funding (data_source_updated_datetime);
CREATE INDEX idx_loan_hedge__data_source_updated_datetime ON history_octane.loan_hedge (data_source_updated_datetime);
CREATE INDEX idx_loan_mi_rate_adjustment__data_source_updated_datetime ON history_octane.loan_mi_rate_adjustment (data_source_updated_datetime);
CREATE INDEX idx_loan_mi_surcharge__data_source_updated_datetime ON history_octane.loan_mi_surcharge (data_source_updated_datetime);
CREATE INDEX idx_loan_price_add_on__data_source_updated_datetime ON history_octane.loan_price_add_on (data_source_updated_datetime);
CREATE INDEX idx_loan_recording__data_source_updated_datetime ON history_octane.loan_recording (data_source_updated_datetime);
CREATE INDEX idx_loan_servicer__data_source_updated_datetime ON history_octane.loan_servicer (data_source_updated_datetime);
CREATE INDEX idx_lock_series__data_source_updated_datetime ON history_octane.lock_series (data_source_updated_datetime);
CREATE INDEX idx_lender_lock_major__data_source_updated_datetime ON history_octane.lender_lock_major (data_source_updated_datetime);
CREATE INDEX idx_bid_pool_lender_lock__data_source_updated_datetime ON history_octane.bid_pool_lender_lock (data_source_updated_datetime);
CREATE INDEX idx_lender_concession_request__data_source_updated_datetime ON history_octane.lender_concession_request (data_source_updated_datetime);
CREATE INDEX idx_lender_lock_extension__data_source_updated_datetime ON history_octane.lender_lock_extension (data_source_updated_datetime);
CREATE INDEX idx_lender_lock_minor__data_source_updated_datetime ON history_octane.lender_lock_minor (data_source_updated_datetime);
CREATE INDEX idx_lender_lock_add_on__data_source_updated_datetime ON history_octane.lender_lock_add_on (data_source_updated_datetime);
CREATE INDEX idx_net_tangible_benefit__data_source_updated_datetime ON history_octane.net_tangible_benefit (data_source_updated_datetime);
CREATE INDEX idx_obligation__data_source_updated_datetime ON history_octane.obligation (data_source_updated_datetime);
CREATE INDEX idx_loan_charge__data_source_updated_datetime ON history_octane.loan_charge (data_source_updated_datetime);
CREATE INDEX idx_place__data_source_updated_datetime ON history_octane.place (data_source_updated_datetime);
CREATE INDEX idx_borrower_reo__data_source_updated_datetime ON history_octane.borrower_reo (data_source_updated_datetime);
CREATE INDEX idx_borrower_residence__data_source_updated_datetime ON history_octane.borrower_residence (data_source_updated_datetime);
CREATE INDEX idx_borrower_tax_filing__data_source_updated_datetime ON history_octane.borrower_tax_filing (data_source_updated_datetime);
CREATE INDEX idx_borrower_va__data_source_updated_datetime ON history_octane.borrower_va (data_source_updated_datetime);
CREATE INDEX idx_profit_margin_detail__data_source_updated_datetime ON history_octane.profit_margin_detail (data_source_updated_datetime);
CREATE INDEX idx_proposal_contractor__data_source_updated_datetime ON history_octane.proposal_contractor (data_source_updated_datetime);
CREATE INDEX idx_construction_cost__data_source_updated_datetime ON history_octane.construction_cost (data_source_updated_datetime);
CREATE INDEX idx_construction_draw_item__data_source_updated_datetime ON history_octane.construction_draw_item (data_source_updated_datetime);
CREATE INDEX idx_proposal_doc_set__data_source_updated_datetime ON history_octane.proposal_doc_set (data_source_updated_datetime);
CREATE INDEX idx_proposal_doc_set_id_ticker__data_source_updated_datetime ON history_octane.proposal_doc_set_id_ticker (data_source_updated_datetime);
CREATE INDEX idx_proposal_doc_set_signer__data_source_updated_datetime ON history_octane.proposal_doc_set_signer (data_source_updated_datetime);
CREATE INDEX idx_proposal_doc_set_snapshot__data_source_updated_datetime ON history_octane.proposal_doc_set_snapshot (data_source_updated_datetime);
CREATE INDEX idx_proposal_engagement__data_source_updated_datetime ON history_octane.proposal_engagement (data_source_updated_datetime);
CREATE INDEX idx_proposal_grant_program__data_source_updated_datetime ON history_octane.proposal_grant_program (data_source_updated_datetime);
CREATE INDEX idx_proposal_review__data_source_updated_datetime ON history_octane.proposal_review (data_source_updated_datetime);
CREATE INDEX idx_proposal_review_ticker__data_source_updated_datetime ON history_octane.proposal_review_ticker (data_source_updated_datetime);
CREATE INDEX idx_proposal_summary__data_source_updated_datetime ON history_octane.proposal_summary (data_source_updated_datetime);
CREATE INDEX idx_pte_request__data_source_updated_datetime ON history_octane.pte_request (data_source_updated_datetime);
CREATE INDEX idx_public_record__data_source_updated_datetime ON history_octane.public_record (data_source_updated_datetime);
CREATE INDEX idx_borrower_public_record__data_source_updated_datetime ON history_octane.borrower_public_record (data_source_updated_datetime);
CREATE INDEX idx_rental_income__data_source_updated_datetime ON history_octane.rental_income (data_source_updated_datetime);
CREATE INDEX idx_sap_quote_request__data_source_updated_datetime ON history_octane.sap_quote_request (data_source_updated_datetime);
CREATE INDEX idx_secondary_settings__data_source_updated_datetime ON history_octane.secondary_settings (data_source_updated_datetime);
CREATE INDEX idx_93d741378c54dc9df712d3466a82e6f6 ON history_octane.servicer_loan_id_import_request (data_source_updated_datetime);
CREATE INDEX idx_servicer_loan_id_assignment__data_source_updated_datetime ON history_octane.servicer_loan_id_assignment (data_source_updated_datetime);
CREATE INDEX idx_smart_doc__data_source_updated_datetime ON history_octane.smart_doc (data_source_updated_datetime);
CREATE INDEX idx_smart_doc_criteria__data_source_updated_datetime ON history_octane.smart_doc_criteria (data_source_updated_datetime);
CREATE INDEX idx_smart_doc_note__data_source_updated_datetime ON history_octane.smart_doc_note (data_source_updated_datetime);
CREATE INDEX idx_smart_doc_note_comment__data_source_updated_datetime ON history_octane.smart_doc_note_comment (data_source_updated_datetime);
CREATE INDEX idx_smart_doc_note_monitor__data_source_updated_datetime ON history_octane.smart_doc_note_monitor (data_source_updated_datetime);
CREATE INDEX idx_smart_doc_role__data_source_updated_datetime ON history_octane.smart_doc_role (data_source_updated_datetime);
CREATE INDEX idx_smart_message__data_source_updated_datetime ON history_octane.smart_message (data_source_updated_datetime);
CREATE INDEX idx_smart_message_recipient__data_source_updated_datetime ON history_octane.smart_message_recipient (data_source_updated_datetime);
CREATE INDEX idx_smart_req__data_source_updated_datetime ON history_octane.smart_req (data_source_updated_datetime);
CREATE INDEX idx_smart_separator__data_source_updated_datetime ON history_octane.smart_separator (data_source_updated_datetime);
CREATE INDEX idx_smart_set_doc__data_source_updated_datetime ON history_octane.smart_set_doc (data_source_updated_datetime);
CREATE INDEX idx_smart_stack_doc__data_source_updated_datetime ON history_octane.smart_stack_doc (data_source_updated_datetime);
CREATE INDEX idx_stack_export_request__data_source_updated_datetime ON history_octane.stack_export_request (data_source_updated_datetime);
CREATE INDEX idx_stack_export_file__data_source_updated_datetime ON history_octane.stack_export_file (data_source_updated_datetime);
CREATE INDEX idx_tax_transcript_request__data_source_updated_datetime ON history_octane.tax_transcript_request (data_source_updated_datetime);
CREATE INDEX idx_64fd1e22b10f2b27ea515fa7d721821e ON history_octane.third_party_community_second_program (data_source_updated_datetime);
CREATE INDEX idx_liability__data_source_updated_datetime ON history_octane.liability (data_source_updated_datetime);
CREATE INDEX idx_borrower_liability__data_source_updated_datetime ON history_octane.borrower_liability (data_source_updated_datetime);
CREATE INDEX idx_deal_tag__data_source_updated_datetime ON history_octane.deal_tag (data_source_updated_datetime);
CREATE INDEX idx_6b63fe02a74ba120fe394d32e48fb632 ON history_octane.product_third_party_community_second_program (data_source_updated_datetime);
CREATE INDEX idx_proposal_doc__data_source_updated_datetime ON history_octane.proposal_doc (data_source_updated_datetime);
CREATE INDEX idx_proposal_doc_borrower_access__data_source_updated_datetime ON history_octane.proposal_doc_borrower_access (data_source_updated_datetime);
CREATE INDEX idx_proposal_doc_file__data_source_updated_datetime ON history_octane.proposal_doc_file (data_source_updated_datetime);
CREATE INDEX idx_proposal_req__data_source_updated_datetime ON history_octane.proposal_req (data_source_updated_datetime);
CREATE INDEX idx_sap_deal_step__data_source_updated_datetime ON history_octane.sap_deal_step (data_source_updated_datetime);
CREATE INDEX idx_deal_sap__data_source_updated_datetime ON history_octane.deal_sap (data_source_updated_datetime);
CREATE INDEX idx_trade__data_source_updated_datetime ON history_octane.trade (data_source_updated_datetime);
CREATE INDEX idx_investor_lock__data_source_updated_datetime ON history_octane.investor_lock (data_source_updated_datetime);
CREATE INDEX idx_investor_lock_add_on__data_source_updated_datetime ON history_octane.investor_lock_add_on (data_source_updated_datetime);
CREATE INDEX idx_investor_lock_extension__data_source_updated_datetime ON history_octane.investor_lock_extension (data_source_updated_datetime);
CREATE INDEX idx_trade_audit__data_source_updated_datetime ON history_octane.trade_audit (data_source_updated_datetime);
CREATE INDEX idx_trade_fee__data_source_updated_datetime ON history_octane.trade_fee (data_source_updated_datetime);
CREATE INDEX idx_trade_file__data_source_updated_datetime ON history_octane.trade_file (data_source_updated_datetime);
CREATE INDEX idx_trade_lock_filter__data_source_updated_datetime ON history_octane.trade_lock_filter (data_source_updated_datetime);
CREATE INDEX idx_trade_note__data_source_updated_datetime ON history_octane.trade_note (data_source_updated_datetime);
CREATE INDEX idx_trade_note_comment__data_source_updated_datetime ON history_octane.trade_note_comment (data_source_updated_datetime);
CREATE INDEX idx_trade_note_monitor__data_source_updated_datetime ON history_octane.trade_note_monitor (data_source_updated_datetime);
CREATE INDEX idx_trade_product__data_source_updated_datetime ON history_octane.trade_product (data_source_updated_datetime);
CREATE INDEX idx_unpaid_balance_adjustment__data_source_updated_datetime ON history_octane.unpaid_balance_adjustment (data_source_updated_datetime);
CREATE INDEX idx_4ff779b058702e61f4af0985919e414a ON history_octane.vendor_document_repository_file (data_source_updated_datetime);
CREATE INDEX idx_b835c06dc8c12296c156c272b50d55d5 ON history_octane.deal_data_vendor_document_import (data_source_updated_datetime);
CREATE INDEX idx_vendor_document_event__data_source_updated_datetime ON history_octane.vendor_document_event (data_source_updated_datetime);
CREATE INDEX idx_wf_deal_process__data_source_updated_datetime ON history_octane.wf_deal_process (data_source_updated_datetime);
CREATE INDEX idx_wf_step__data_source_updated_datetime ON history_octane.wf_step (data_source_updated_datetime);
CREATE INDEX idx_criteria_pid_operand__data_source_updated_datetime ON history_octane.criteria_pid_operand (data_source_updated_datetime);
CREATE INDEX idx_smart_task__data_source_updated_datetime ON history_octane.smart_task (data_source_updated_datetime);
CREATE INDEX idx_smart_task_tag_modifier__data_source_updated_datetime ON history_octane.smart_task_tag_modifier (data_source_updated_datetime);
CREATE INDEX idx_view_wf_deal_step_started__data_source_updated_datetime ON history_octane.view_wf_deal_step_started (data_source_updated_datetime);
CREATE INDEX idx_wf_deal_step__data_source_updated_datetime ON history_octane.wf_deal_step (data_source_updated_datetime);
CREATE INDEX idx_deal_note__data_source_updated_datetime ON history_octane.deal_note (data_source_updated_datetime);
CREATE INDEX idx_deal_note_comment__data_source_updated_datetime ON history_octane.deal_note_comment (data_source_updated_datetime);
CREATE INDEX idx_deal_note_monitor__data_source_updated_datetime ON history_octane.deal_note_monitor (data_source_updated_datetime);
CREATE INDEX idx_deal_note_role_tag__data_source_updated_datetime ON history_octane.deal_note_role_tag (data_source_updated_datetime);
CREATE INDEX idx_deal_task__data_source_updated_datetime ON history_octane.deal_task (data_source_updated_datetime);
CREATE INDEX idx_wf_deal_fork_process__data_source_updated_datetime ON history_octane.wf_deal_fork_process (data_source_updated_datetime);
CREATE INDEX idx_wf_deal_function_queue__data_source_updated_datetime ON history_octane.wf_deal_function_queue (data_source_updated_datetime);
CREATE INDEX idx_wf_deal_outcome__data_source_updated_datetime ON history_octane.wf_deal_outcome (data_source_updated_datetime);
CREATE INDEX idx_wf_deal_step_timeout__data_source_updated_datetime ON history_octane.wf_deal_step_timeout (data_source_updated_datetime);
CREATE INDEX idx_wf_fork_process__data_source_updated_datetime ON history_octane.wf_fork_process (data_source_updated_datetime);
CREATE INDEX idx_wf_outcome__data_source_updated_datetime ON history_octane.wf_outcome (data_source_updated_datetime);
CREATE INDEX idx_wf_step_deal_check__data_source_updated_datetime ON history_octane.wf_step_deal_check (data_source_updated_datetime);
CREATE INDEX idx_wf_step_deal_check_definition__data_source_updated_datetime ON history_octane.wf_step_deal_check_definition (data_source_updated_datetime);
CREATE INDEX idx_wf_step_deal_check_dependency__data_source_updated_datetime ON history_octane.wf_step_deal_check_dependency (data_source_updated_datetime);
CREATE INDEX idx_wf_step_deal_tag_modifier__data_source_updated_datetime ON history_octane.wf_step_deal_tag_modifier (data_source_updated_datetime);
CREATE INDEX idx_zip_code_info__data_source_updated_datetime ON history_octane.zip_code_info (data_source_updated_datetime);
CREATE INDEX idx_county_zip_code__data_source_updated_datetime ON history_octane.county_zip_code (data_source_updated_datetime);
CREATE INDEX idx_borrower_declarations__data_source_updated_datetime ON history_octane.borrower_declarations (data_source_updated_datetime);
CREATE INDEX idx_9c5782e605d456d7c2b66e9df931b015 ON history_octane.minimum_required_residual_income_table (data_source_updated_datetime);
CREATE INDEX idx_379d69a01809b5bcd8a7827da23f1ad6 ON history_octane.minimum_required_residual_income_row (data_source_updated_datetime);
CREATE INDEX idx_new_lock_only_add_on__data_source_updated_datetime ON history_octane.new_lock_only_add_on (data_source_updated_datetime);
CREATE INDEX idx_doc_provider_group_type__data_source_updated_datetime ON history_octane.doc_provider_group_type (data_source_updated_datetime);
CREATE INDEX idx_doc_req_fulfill_status_type__data_source_updated_datetime ON history_octane.doc_req_fulfill_status_type (data_source_updated_datetime);
CREATE INDEX idx_trust_classification_type__data_source_updated_datetime ON history_octane.trust_classification_type (data_source_updated_datetime);
CREATE INDEX idx_e57ebd9d165435f5c478708b3f1d41d4 ON history_octane.financed_property_improvements_category_type (data_source_updated_datetime);


CREATE INDEX idx_account__pid ON history_octane.account (a_pid);
CREATE INDEX idx_account_contact__pid ON history_octane.account_contact (ac_pid);
CREATE INDEX idx_account_event__pid ON history_octane.account_event (ae_pid);
CREATE INDEX idx_account_grant_program__pid ON history_octane.account_grant_program (agp_pid);
CREATE INDEX idx_admin_user__pid ON history_octane.admin_user (au_pid);
CREATE INDEX idx_admin_user_event__pid ON history_octane.admin_user_event (aue_pid);
CREATE INDEX idx_announcement__pid ON history_octane.announcement (ann_pid);
CREATE INDEX idx_apor__pid ON history_octane.apor (ap_pid);
CREATE INDEX idx_application__pid ON history_octane.application (apl_pid);
CREATE INDEX idx_appraisal__pid ON history_octane.appraisal (apr_pid);
CREATE INDEX idx_appraisal_file__pid ON history_octane.appraisal_file (aprf_pid);
CREATE INDEX idx_appraisal_form__pid ON history_octane.appraisal_form (aprfm_pid);
CREATE INDEX idx_appraisal_id_ticker__pid ON history_octane.appraisal_id_ticker (aprtk_pid);
CREATE INDEX idx_appraisal_order_request__pid ON history_octane.appraisal_order_request (aprq_pid);
CREATE INDEX idx_appraisal_order_request_file__pid ON history_octane.appraisal_order_request_file (aorf_pid);
CREATE INDEX idx_area_median_income_row__pid ON history_octane.area_median_income_row (amir_pid);
CREATE INDEX idx_area_median_income_table__pid ON history_octane.area_median_income_table (amit_pid);
CREATE INDEX idx_arm_index_rate__pid ON history_octane.arm_index_rate (air_pid);
CREATE INDEX idx_asset__pid ON history_octane.asset (as_pid);
CREATE INDEX idx_asset_large_deposit__pid ON history_octane.asset_large_deposit (ald_pid);
CREATE INDEX idx_aus_request_number_ticker__pid ON history_octane.aus_request_number_ticker (arnt_pid);
CREATE INDEX idx_backfill_loan_status__pid ON history_octane.backfill_loan_status (bfls_pid);
CREATE INDEX idx_backfill_status__pid ON history_octane.backfill_status (bfs_pid);
CREATE INDEX idx_bid_pool__pid ON history_octane.bid_pool (bp_pid);
CREATE INDEX idx_bid_pool_file__pid ON history_octane.bid_pool_file (bpf_pid);
CREATE INDEX idx_bid_pool_lender_lock__pid ON history_octane.bid_pool_lender_lock (bpll_pid);
CREATE INDEX idx_bid_pool_note__pid ON history_octane.bid_pool_note (bpn_pid);
CREATE INDEX idx_bid_pool_note_comment__pid ON history_octane.bid_pool_note_comment (bpnc_pid);
CREATE INDEX idx_bid_pool_note_monitor__pid ON history_octane.bid_pool_note_monitor (bpnm_pid);
CREATE INDEX idx_borrower__pid ON history_octane.borrower (b_pid);
CREATE INDEX idx_borrower_alias__pid ON history_octane.borrower_alias (ba_pid);
CREATE INDEX idx_borrower_asset__pid ON history_octane.borrower_asset (bas_pid);
CREATE INDEX idx_borrower_associated_address__pid ON history_octane.borrower_associated_address (baa_pid);
CREATE INDEX idx_borrower_credit_inquiry__pid ON history_octane.borrower_credit_inquiry (bci_pid);
CREATE INDEX idx_borrower_declarations__pid ON history_octane.borrower_declarations (bdec_pid);
CREATE INDEX idx_borrower_dependent__pid ON history_octane.borrower_dependent (bd_pid);
CREATE INDEX idx_borrower_income__pid ON history_octane.borrower_income (bi_pid);
CREATE INDEX idx_borrower_job_gap__pid ON history_octane.borrower_job_gap (bjg_pid);
CREATE INDEX idx_borrower_liability__pid ON history_octane.borrower_liability (bl_pid);
CREATE INDEX idx_borrower_public_record__pid ON history_octane.borrower_public_record (bpr_pid);
CREATE INDEX idx_borrower_reo__pid ON history_octane.borrower_reo (breo_pid);
CREATE INDEX idx_borrower_residence__pid ON history_octane.borrower_residence (bres_pid);
CREATE INDEX idx_borrower_tax_filing__pid ON history_octane.borrower_tax_filing (btf_pid);
CREATE INDEX idx_borrower_user__pid ON history_octane.borrower_user (bu_pid);
CREATE INDEX idx_borrower_user_change_email__pid ON history_octane.borrower_user_change_email (buce_pid);
CREATE INDEX idx_borrower_user_deal__pid ON history_octane.borrower_user_deal (bud_pid);
CREATE INDEX idx_borrower_va__pid ON history_octane.borrower_va (bva_pid);
CREATE INDEX idx_branch__pid ON history_octane.branch (br_pid);
CREATE INDEX idx_branch_account_executive__pid ON history_octane.branch_account_executive (brae_pid);
CREATE INDEX idx_branch_license__pid ON history_octane.branch_license (brml_pid);
CREATE INDEX idx_business_income__pid ON history_octane.business_income (bui_pid);
CREATE INDEX idx_channel__pid ON history_octane.channel (ch_pid);
CREATE INDEX idx_circumstance_change__pid ON history_octane.circumstance_change (cc_pid);
CREATE INDEX idx_company__pid ON history_octane.company (cm_pid);
CREATE INDEX idx_company_admin_event__pid ON history_octane.company_admin_event (cae_pid);
CREATE INDEX idx_company_license__pid ON history_octane.company_license (cml_pid);
CREATE INDEX idx_compass_analytics_report_request__pid ON history_octane.compass_analytics_report_request (carr_pid);
CREATE INDEX idx_construction_cost__pid ON history_octane.construction_cost (coc_pid);
CREATE INDEX idx_construction_draw__pid ON history_octane.construction_draw (cd_pid);
CREATE INDEX idx_construction_draw_item__pid ON history_octane.construction_draw_item (cdi_pid);
CREATE INDEX idx_construction_draw_number_ticker__pid ON history_octane.construction_draw_number_ticker (cdnt_pid);
CREATE INDEX idx_consumer_privacy_affected_borrower__pid ON history_octane.consumer_privacy_affected_borrower (cpab_pid);
CREATE INDEX idx_consumer_privacy_request__pid ON history_octane.consumer_privacy_request (cpr_pid);
CREATE INDEX idx_contractor__pid ON history_octane.contractor (ctr_pid);
CREATE INDEX idx_contractor_license__pid ON history_octane.contractor_license (ctrl_pid);
CREATE INDEX idx_cost_center__pid ON history_octane.cost_center (cosc_pid);
CREATE INDEX idx_county__pid ON history_octane.county (c_pid);
CREATE INDEX idx_county_city__pid ON history_octane.county_city (cci_pid);
CREATE INDEX idx_county_recording_district__pid ON history_octane.county_recording_district (crdi_pid);
CREATE INDEX idx_county_sub_jurisdiction__pid ON history_octane.county_sub_jurisdiction (csju_pid);
CREATE INDEX idx_county_zip_code__pid ON history_octane.county_zip_code (czc_pid);
CREATE INDEX idx_credit_inquiry__pid ON history_octane.credit_inquiry (ci_pid);
CREATE INDEX idx_credit_limit__pid ON history_octane.credit_limit (cl_pid);
CREATE INDEX idx_credit_request__pid ON history_octane.credit_request (crdr_pid);
CREATE INDEX idx_creditor__pid ON history_octane.creditor (crd_pid);
CREATE INDEX idx_creditor_lookup_name__pid ON history_octane.creditor_lookup_name (cln_pid);
CREATE INDEX idx_criteria__pid ON history_octane.criteria (cr_pid);
CREATE INDEX idx_criteria_pid_operand__pid ON history_octane.criteria_pid_operand (crpo_pid);
CREATE INDEX idx_criteria_snippet__pid ON history_octane.criteria_snippet (crs_pid);
CREATE INDEX idx_custodian__pid ON history_octane.custodian (cu_pid);
CREATE INDEX idx_custom_form__pid ON history_octane.custom_form (cf_pid);
CREATE INDEX idx_custom_form_merge_field__pid ON history_octane.custom_form_merge_field (cfmf_pid);
CREATE INDEX idx_deal__pid ON history_octane.deal (d_pid);
CREATE INDEX idx_deal_appraisal__pid ON history_octane.deal_appraisal (dappr_pid);
CREATE INDEX idx_deal_change_updater_time__pid ON history_octane.deal_change_updater_time (dcut_pid);
CREATE INDEX idx_deal_contact__pid ON history_octane.deal_contact (dc_pid);
CREATE INDEX idx_deal_data_vendor_document_import__pid ON history_octane.deal_data_vendor_document_import (ddvdi_pid);
CREATE INDEX idx_deal_disaster_declaration__pid ON history_octane.deal_disaster_declaration (ddd_pid);
CREATE INDEX idx_deal_dropbox_file__pid ON history_octane.deal_dropbox_file (ddf_pid);
CREATE INDEX idx_deal_du__pid ON history_octane.deal_du (ddu_pid);
CREATE INDEX idx_deal_event__pid ON history_octane.deal_event (de_pid);
CREATE INDEX idx_deal_file__pid ON history_octane.deal_file (df_pid);
CREATE INDEX idx_deal_file_signature__pid ON history_octane.deal_file_signature (dfs_pid);
CREATE INDEX idx_deal_file_thumbnail__pid ON history_octane.deal_file_thumbnail (dft_pid);
CREATE INDEX idx_deal_fraud_risk__pid ON history_octane.deal_fraud_risk (dfr_pid);
CREATE INDEX idx_deal_housing_counselor_candidate__pid ON history_octane.deal_housing_counselor_candidate (dhcc_pid);
CREATE INDEX idx_deal_housing_counselors_request__pid ON history_octane.deal_housing_counselors_request (dhcr_pid);
CREATE INDEX idx_deal_invoice__pid ON history_octane.deal_invoice (di_pid);
CREATE INDEX idx_deal_invoice_file__pid ON history_octane.deal_invoice_file (dif_pid);
CREATE INDEX idx_deal_invoice_item__pid ON history_octane.deal_invoice_item (dii_pid);
CREATE INDEX idx_deal_invoice_payment_method__pid ON history_octane.deal_invoice_payment_method (dipm_pid);
CREATE INDEX idx_deal_key_roles__pid ON history_octane.deal_key_roles (dkrs_pid);
CREATE INDEX idx_deal_lender_user__pid ON history_octane.deal_lender_user (dlu_pid);
CREATE INDEX idx_deal_lender_user_event__pid ON history_octane.deal_lender_user_event (dlue_pid);
CREATE INDEX idx_deal_lp__pid ON history_octane.deal_lp (dlp_pid);
CREATE INDEX idx_deal_message_log__pid ON history_octane.deal_message_log (dmlog_pid);
CREATE INDEX idx_deal_note__pid ON history_octane.deal_note (dn_pid);
CREATE INDEX idx_deal_note_comment__pid ON history_octane.deal_note_comment (dnc_pid);
CREATE INDEX idx_deal_note_monitor__pid ON history_octane.deal_note_monitor (dnm_pid);
CREATE INDEX idx_deal_note_role_tag__pid ON history_octane.deal_note_role_tag (dnrt_pid);
CREATE INDEX idx_deal_performer_team__pid ON history_octane.deal_performer_team (dptm_pid);
CREATE INDEX idx_deal_performer_team_user__pid ON history_octane.deal_performer_team_user (dptu_pid);
CREATE INDEX idx_deal_real_estate_agent__pid ON history_octane.deal_real_estate_agent (drea_pid);
CREATE INDEX idx_deal_sap__pid ON history_octane.deal_sap (dsap_pid);
CREATE INDEX idx_deal_settlement__pid ON history_octane.deal_settlement (dsmt_pid);
CREATE INDEX idx_deal_signer__pid ON history_octane.deal_signer (dsi_pid);
CREATE INDEX idx_deal_snapshot__pid ON history_octane.deal_snapshot (desn_pid);
CREATE INDEX idx_deal_stage__pid ON history_octane.deal_stage (dst_pid);
CREATE INDEX idx_deal_summary__pid ON history_octane.deal_summary (ds_pid);
CREATE INDEX idx_deal_system_file__pid ON history_octane.deal_system_file (dsf_pid);
CREATE INDEX idx_deal_tag__pid ON history_octane.deal_tag (dtg_pid);
CREATE INDEX idx_deal_tag_definition__pid ON history_octane.deal_tag_definition (dtd_pid);
CREATE INDEX idx_deal_task__pid ON history_octane.deal_task (dt_pid);
CREATE INDEX idx_disaster_declaration__pid ON history_octane.disaster_declaration (dd_pid);
CREATE INDEX idx_docusign_package__pid ON history_octane.docusign_package (dcsp_pid);
CREATE INDEX idx_du_key_finding__pid ON history_octane.du_key_finding (dukf_pid);
CREATE INDEX idx_du_refi_plus_finding__pid ON history_octane.du_refi_plus_finding (durpf_pid);
CREATE INDEX idx_du_request__pid ON history_octane.du_request (dur_pid);
CREATE INDEX idx_du_request_credit__pid ON history_octane.du_request_credit (durc_pid);
CREATE INDEX idx_du_special_feature_code__pid ON history_octane.du_special_feature_code (dusfc_pid);
CREATE INDEX idx_dw_export_request__pid ON history_octane.dw_export_request (dwer_pid);
CREATE INDEX idx_ernst_request__pid ON history_octane.ernst_request (enst_pid);
CREATE INDEX idx_ernst_request_question__pid ON history_octane.ernst_request_question (enstq_pid);
CREATE INDEX idx_exclusive_assignment__pid ON history_octane.exclusive_assignment (ea_pid);
CREATE INDEX idx_flood_cert__pid ON history_octane.flood_cert (fc_pid);
CREATE INDEX idx_formula_report_column__pid ON history_octane.formula_report_column (frc_pid);
CREATE INDEX idx_google_sheet_export__pid ON history_octane.google_sheet_export (gse_pid);
CREATE INDEX idx_hmda_report_request__pid ON history_octane.hmda_report_request (hrr_pid);
CREATE INDEX idx_hoepa_thresholds__pid ON history_octane.hoepa_thresholds (ht_pid);
CREATE INDEX idx_interim_funder__pid ON history_octane.interim_funder (if_pid);
CREATE INDEX idx_investor__pid ON history_octane.investor (i_pid);
CREATE INDEX idx_investor_group__pid ON history_octane.investor_group (ig_pid);
CREATE INDEX idx_investor_lock__pid ON history_octane.investor_lock (il_pid);
CREATE INDEX idx_investor_lock_add_on__pid ON history_octane.investor_lock_add_on (ila_pid);
CREATE INDEX idx_investor_lock_extension__pid ON history_octane.investor_lock_extension (ile_pid);
CREATE INDEX idx_investor_lock_extension_setting__pid ON history_octane.investor_lock_extension_setting (iles_pid);
CREATE INDEX idx_job_income__pid ON history_octane.job_income (ji_pid);
CREATE INDEX idx_key_package__pid ON history_octane.key_package (kp_pid);
CREATE INDEX idx_key_role__pid ON history_octane.key_role (kr_pid);
CREATE INDEX idx_lead__pid ON history_octane.lead (ld_pid);
CREATE INDEX idx_lead_campaign__pid ON history_octane.lead_campaign (ldc_pid);
CREATE INDEX idx_lead_source__pid ON history_octane.lead_source (lds_pid);
CREATE INDEX idx_lead_supplemental_margin_row__pid ON history_octane.lead_supplemental_margin_row (lsmr_pid);
CREATE INDEX idx_lead_supplemental_margin_table__pid ON history_octane.lead_supplemental_margin_table (lsmt_pid);
CREATE INDEX idx_lender_concession_request__pid ON history_octane.lender_concession_request (lcr_pid);
CREATE INDEX idx_lender_lock_add_on__pid ON history_octane.lender_lock_add_on (lla_pid);
CREATE INDEX idx_lender_lock_extension__pid ON history_octane.lender_lock_extension (lle_pid);
CREATE INDEX idx_lender_lock_id_ticker__pid ON history_octane.lender_lock_id_ticker (lltk_pid);
CREATE INDEX idx_lender_lock_major__pid ON history_octane.lender_lock_major (llmj_pid);
CREATE INDEX idx_lender_lock_minor__pid ON history_octane.lender_lock_minor (llmn_pid);
CREATE INDEX idx_lender_settings__pid ON history_octane.lender_settings (lss_pid);
CREATE INDEX idx_lender_trade_id_ticker__pid ON history_octane.lender_trade_id_ticker (lttk_pid);
CREATE INDEX idx_lender_user__pid ON history_octane.lender_user (lu_pid);
CREATE INDEX idx_lender_user_allowed_ip__pid ON history_octane.lender_user_allowed_ip (luip_pid);
CREATE INDEX idx_lender_user_deal_visit__pid ON history_octane.lender_user_deal_visit (ludv_pid);
CREATE INDEX idx_lender_user_interest__pid ON history_octane.lender_user_interest (lui_pid);
CREATE INDEX idx_lender_user_language__pid ON history_octane.lender_user_language (lul_pid);
CREATE INDEX idx_lender_user_lead_source__pid ON history_octane.lender_user_lead_source (lulds_pid);
CREATE INDEX idx_lender_user_license__pid ON history_octane.lender_user_license (luml_pid);
CREATE INDEX idx_lender_user_notice__pid ON history_octane.lender_user_notice (lun_pid);
CREATE INDEX idx_lender_user_photo__pid ON history_octane.lender_user_photo (lup_pid);
CREATE INDEX idx_lender_user_role__pid ON history_octane.lender_user_role (lur_pid);
CREATE INDEX idx_lender_user_role_addendum__pid ON history_octane.lender_user_role_addendum (lura_pid);
CREATE INDEX idx_lender_user_sign_on__pid ON history_octane.lender_user_sign_on (luso_pid);
CREATE INDEX idx_lender_user_unavailable__pid ON history_octane.lender_user_unavailable (luu_pid);
CREATE INDEX idx_liability__pid ON history_octane.liability (lia_pid);
CREATE INDEX idx_license_req__pid ON history_octane.license_req (mlr_pid);
CREATE INDEX idx_loan__pid ON history_octane.loan (l_pid);
CREATE INDEX idx_loan_beneficiary__pid ON history_octane.loan_beneficiary (lb_pid);
CREATE INDEX idx_loan_charge__pid ON history_octane.loan_charge (lc_pid);
CREATE INDEX idx_loan_closing_doc__pid ON history_octane.loan_closing_doc (lcd_pid);
CREATE INDEX idx_loan_eligible_investor__pid ON history_octane.loan_eligible_investor (lei_pid);
CREATE INDEX idx_loan_funding__pid ON history_octane.loan_funding (lf_pid);
CREATE INDEX idx_loan_hedge__pid ON history_octane.loan_hedge (lh_pid);
CREATE INDEX idx_loan_limit_row__pid ON history_octane.loan_limit_row (llr_pid);
CREATE INDEX idx_loan_limit_table__pid ON history_octane.loan_limit_table (llt_pid);
CREATE INDEX idx_loan_mi_rate_adjustment__pid ON history_octane.loan_mi_rate_adjustment (lmra_pid);
CREATE INDEX idx_loan_mi_surcharge__pid ON history_octane.loan_mi_surcharge (lms_pid);
CREATE INDEX idx_loan_price_add_on__pid ON history_octane.loan_price_add_on (lpa_pid);
CREATE INDEX idx_loan_recording__pid ON history_octane.loan_recording (lr_pid);
CREATE INDEX idx_loan_servicer__pid ON history_octane.loan_servicer (lsv_pid);
CREATE INDEX idx_lock_series__pid ON history_octane.lock_series (lsr_pid);
CREATE INDEX idx_lock_term_setting__pid ON history_octane.lock_term_setting (lts_pid);
CREATE INDEX idx_los_loan_id_ticker__pid ON history_octane.los_loan_id_ticker (ltk_pid);
CREATE INDEX idx_lp_finding__pid ON history_octane.lp_finding (lpf_pid);
CREATE INDEX idx_lp_request__pid ON history_octane.lp_request (lpr_pid);
CREATE INDEX idx_lp_request_credit__pid ON history_octane.lp_request_credit (lprc_pid);
CREATE INDEX idx_master_property_insurance__pid ON history_octane.master_property_insurance (mpi_pid);
CREATE INDEX idx_mcr_loan__pid ON history_octane.mcr_loan (mcrl_pid);
CREATE INDEX idx_mcr_snapshot__pid ON history_octane.mcr_snapshot (mcrs_pid);
CREATE INDEX idx_mercury_client_group__pid ON history_octane.mercury_client_group (mcg_pid);
CREATE INDEX idx_mercury_network_status_request__pid ON history_octane.mercury_network_status_request (mnsr_pid);
CREATE INDEX idx_mers_daily_report__pid ON history_octane.mers_daily_report (medr_pid);
CREATE INDEX idx_mers_transfer_batch__pid ON history_octane.mers_transfer_batch (metb_pid);
CREATE INDEX idx_mi_integration_vendor_request__pid ON history_octane.mi_integration_vendor_request (mivr_pid);
CREATE INDEX idx_military_service__pid ON history_octane.military_service (ms_pid);
CREATE INDEX idx_minimum_required_residual_income_row__pid ON history_octane.minimum_required_residual_income_row (mrir_pid);
CREATE INDEX idx_minimum_required_residual_income_table__pid ON history_octane.minimum_required_residual_income_table (mrit_pid);
CREATE INDEX idx_mortech_account__pid ON history_octane.mortech_account (ma_pid);
CREATE INDEX idx_mortgage_credit_certificate_issuer__pid ON history_octane.mortgage_credit_certificate_issuer (mcci_pid);
CREATE INDEX idx_net_tangible_benefit__pid ON history_octane.net_tangible_benefit (ntb_pid);
CREATE INDEX idx_new_lock_only_add_on__pid ON history_octane.new_lock_only_add_on (nlo_pid);
CREATE INDEX idx_obligation__pid ON history_octane.obligation (ob_pid);
CREATE INDEX idx_offering__pid ON history_octane.offering (of_pid);
CREATE INDEX idx_offering_group__pid ON history_octane.offering_group (ofg_pid);
CREATE INDEX idx_offering_product__pid ON history_octane.offering_product (ofp_pid);
CREATE INDEX idx_org_division__pid ON history_octane.org_division (orgd_pid);
CREATE INDEX idx_org_division_leader__pid ON history_octane.org_division_leader (orgdl_pid);
CREATE INDEX idx_org_division_terms__pid ON history_octane.org_division_terms (orgdt_pid);
CREATE INDEX idx_org_group__pid ON history_octane.org_group (orgg_pid);
CREATE INDEX idx_org_group_leader__pid ON history_octane.org_group_leader (orggl_pid);
CREATE INDEX idx_org_group_terms__pid ON history_octane.org_group_terms (orggt_pid);
CREATE INDEX idx_org_lender_user_terms__pid ON history_octane.org_lender_user_terms (orglut_pid);
CREATE INDEX idx_org_region__pid ON history_octane.org_region (orgr_pid);
CREATE INDEX idx_org_region_leader__pid ON history_octane.org_region_leader (orgrl_pid);
CREATE INDEX idx_org_region_terms__pid ON history_octane.org_region_terms (orgrt_pid);
CREATE INDEX idx_org_team__pid ON history_octane.org_team (orgt_pid);
CREATE INDEX idx_org_team_leader__pid ON history_octane.org_team_leader (orgtl_pid);
CREATE INDEX idx_org_team_terms__pid ON history_octane.org_team_terms (orgtt_pid);
CREATE INDEX idx_org_unit__pid ON history_octane.org_unit (orgu_pid);
CREATE INDEX idx_org_unit_leader__pid ON history_octane.org_unit_leader (orgul_pid);
CREATE INDEX idx_org_unit_terms__pid ON history_octane.org_unit_terms (orgut_pid);
CREATE INDEX idx_other_income__pid ON history_octane.other_income (oi_pid);
CREATE INDEX idx_performer_assignment__pid ON history_octane.performer_assignment (pa_pid);
CREATE INDEX idx_performer_team__pid ON history_octane.performer_team (ptm_pid);
CREATE INDEX idx_place__pid ON history_octane.place (pl_pid);
CREATE INDEX idx_preferred_settlement__pid ON history_octane.preferred_settlement (prs_pid);
CREATE INDEX idx_price_processing_time__pid ON history_octane.price_processing_time (ppt_pid);
CREATE INDEX idx_product__pid ON history_octane.product (p_pid);
CREATE INDEX idx_product_add_on__pid ON history_octane.product_add_on (pao_pid);
CREATE INDEX idx_product_add_on_rule__pid ON history_octane.product_add_on_rule (par_pid);
CREATE INDEX idx_product_branch__pid ON history_octane.product_branch (pbr_pid);
CREATE INDEX idx_product_buydown__pid ON history_octane.product_buydown (pbd_pid);
CREATE INDEX idx_product_deal_check_exclusion__pid ON history_octane.product_deal_check_exclusion (pdce_pid);
CREATE INDEX idx_product_eligibility__pid ON history_octane.product_eligibility (pe_pid);
CREATE INDEX idx_product_eligibility_rule__pid ON history_octane.product_eligibility_rule (per_pid);
CREATE INDEX idx_product_interest_only__pid ON history_octane.product_interest_only (pio_pid);
CREATE INDEX idx_product_lock_term__pid ON history_octane.product_lock_term (plt_pid);
CREATE INDEX idx_product_maximum_investor_price__pid ON history_octane.product_maximum_investor_price (pmip_pid);
CREATE INDEX idx_product_maximum_rebate__pid ON history_octane.product_maximum_rebate (pmr_pid);
CREATE INDEX idx_product_minimum_investor_price__pid ON history_octane.product_minimum_investor_price (pminip_pid);
CREATE INDEX idx_product_originator__pid ON history_octane.product_originator (po_pid);
CREATE INDEX idx_product_prepay_penalty__pid ON history_octane.product_prepay_penalty (ppp_pid);
CREATE INDEX idx_product_terms__pid ON history_octane.product_terms (pt_pid);
CREATE INDEX idx_product_third_party_community_second_program__pid ON history_octane.product_third_party_community_second_program (ptpp_pid);
CREATE INDEX idx_profit_margin_detail__pid ON history_octane.profit_margin_detail (pmd_pid);
CREATE INDEX idx_proposal__pid ON history_octane.proposal (prp_pid);
CREATE INDEX idx_proposal_contractor__pid ON history_octane.proposal_contractor (pctr_pid);
CREATE INDEX idx_proposal_doc__pid ON history_octane.proposal_doc (prpd_pid);
CREATE INDEX idx_proposal_doc_borrower_access__pid ON history_octane.proposal_doc_borrower_access (pdba_pid);
CREATE INDEX idx_proposal_doc_file__pid ON history_octane.proposal_doc_file (prpdf_pid);
CREATE INDEX idx_proposal_doc_set__pid ON history_octane.proposal_doc_set (prpds_pid);
CREATE INDEX idx_proposal_doc_set_id_ticker__pid ON history_octane.proposal_doc_set_id_ticker (pdstk_pid);
CREATE INDEX idx_proposal_doc_set_signer__pid ON history_octane.proposal_doc_set_signer (prpdss_pid);
CREATE INDEX idx_proposal_doc_set_snapshot__pid ON history_octane.proposal_doc_set_snapshot (prpdssn_pid);
CREATE INDEX idx_proposal_engagement__pid ON history_octane.proposal_engagement (prpe_pid);
CREATE INDEX idx_proposal_grant_program__pid ON history_octane.proposal_grant_program (pgp_pid);
CREATE INDEX idx_proposal_req__pid ON history_octane.proposal_req (prpr_pid);
CREATE INDEX idx_proposal_review__pid ON history_octane.proposal_review (prpre_pid);
CREATE INDEX idx_proposal_review_ticker__pid ON history_octane.proposal_review_ticker (prpret_pid);
CREATE INDEX idx_proposal_summary__pid ON history_octane.proposal_summary (ps_pid);
CREATE INDEX idx_pte_request__pid ON history_octane.pte_request (pter_pid);
CREATE INDEX idx_public_record__pid ON history_octane.public_record (pr_pid);
CREATE INDEX idx_qualified_mortgage_thresholds__pid ON history_octane.qualified_mortgage_thresholds (qmt_pid);
CREATE INDEX idx_rate_sheet__pid ON history_octane.rate_sheet (rs_pid);
CREATE INDEX idx_rate_sheet_price__pid ON history_octane.rate_sheet_price (rsp_pid);
CREATE INDEX idx_rate_sheet_rate__pid ON history_octane.rate_sheet_rate (rsr_pid);
CREATE INDEX idx_recording_city__pid ON history_octane.recording_city (rc_pid);
CREATE INDEX idx_recording_district__pid ON history_octane.recording_district (rdi_pid);
CREATE INDEX idx_region_ernst_page_rec__pid ON history_octane.region_ernst_page_rec (rerc_pid);
CREATE INDEX idx_relock_fee_setting__pid ON history_octane.relock_fee_setting (rfs_pid);
CREATE INDEX idx_rental_income__pid ON history_octane.rental_income (ri_pid);
CREATE INDEX idx_report__pid ON history_octane.report (rp_pid);
CREATE INDEX idx_report_column__pid ON history_octane.report_column (rpc_pid);
CREATE INDEX idx_report_row__pid ON history_octane.report_row (rprw_pid);
CREATE INDEX idx_repository_file__pid ON history_octane.repository_file (rf_pid);
CREATE INDEX idx_role__pid ON history_octane.role (r_pid);
CREATE INDEX idx_role_charge_permissions__pid ON history_octane.role_charge_permissions (rcp_pid);
CREATE INDEX idx_role_config_export_permission__pid ON history_octane.role_config_export_permission (rcep_pid);
CREATE INDEX idx_role_deal_context__pid ON history_octane.role_deal_context (rdc_pid);
CREATE INDEX idx_role_export_permission__pid ON history_octane.role_export_permission (rep_pid);
CREATE INDEX idx_role_lender_toolbox__pid ON history_octane.role_lender_toolbox (rlet_pid);
CREATE INDEX idx_role_loans_toolbox__pid ON history_octane.role_loans_toolbox (rlot_pid);
CREATE INDEX idx_role_performer_assign__pid ON history_octane.role_performer_assign (rpa_pid);
CREATE INDEX idx_role_report__pid ON history_octane.role_report (rrp_pid);
CREATE INDEX idx_sap_deal_step__pid ON history_octane.sap_deal_step (sds_pid);
CREATE INDEX idx_sap_quote_request__pid ON history_octane.sap_quote_request (sqr_pid);
CREATE INDEX idx_secondary_admin_event__pid ON history_octane.secondary_admin_event (sae_pid);
CREATE INDEX idx_secondary_settings__pid ON history_octane.secondary_settings (sset_pid);
CREATE INDEX idx_servicer_loan_id_assignment__pid ON history_octane.servicer_loan_id_assignment (slia_pid);
CREATE INDEX idx_servicer_loan_id_import_request__pid ON history_octane.servicer_loan_id_import_request (slir_pid);
CREATE INDEX idx_settlement_agent__pid ON history_octane.settlement_agent (sa_pid);
CREATE INDEX idx_settlement_agent_office__pid ON history_octane.settlement_agent_office (sao_pid);
CREATE INDEX idx_settlement_agent_wire__pid ON history_octane.settlement_agent_wire (saw_pid);
CREATE INDEX idx_site_allowed_ip__pid ON history_octane.site_allowed_ip (saip_pid);
CREATE INDEX idx_smart_charge__pid ON history_octane.smart_charge (sc_pid);
CREATE INDEX idx_smart_charge_case__pid ON history_octane.smart_charge_case (scc_pid);
CREATE INDEX idx_smart_charge_group__pid ON history_octane.smart_charge_group (scg_pid);
CREATE INDEX idx_smart_charge_group_case__pid ON history_octane.smart_charge_group_case (scgc_pid);
CREATE INDEX idx_smart_doc__pid ON history_octane.smart_doc (sd_pid);
CREATE INDEX idx_smart_doc_criteria__pid ON history_octane.smart_doc_criteria (sdc_pid);
CREATE INDEX idx_smart_doc_note__pid ON history_octane.smart_doc_note (sdn_pid);
CREATE INDEX idx_smart_doc_note_comment__pid ON history_octane.smart_doc_note_comment (sdnc_pid);
CREATE INDEX idx_smart_doc_note_monitor__pid ON history_octane.smart_doc_note_monitor (sdnm_pid);
CREATE INDEX idx_smart_doc_role__pid ON history_octane.smart_doc_role (sdr_pid);
CREATE INDEX idx_smart_doc_set__pid ON history_octane.smart_doc_set (sdst_pid);
CREATE INDEX idx_smart_message__pid ON history_octane.smart_message (smsg_pid);
CREATE INDEX idx_smart_message_recipient__pid ON history_octane.smart_message_recipient (smr_pid);
CREATE INDEX idx_smart_mi__pid ON history_octane.smart_mi (sm_pid);
CREATE INDEX idx_smart_mi_eligibility_case__pid ON history_octane.smart_mi_eligibility_case (smec_pid);
CREATE INDEX idx_smart_mi_rate_adjustment_case__pid ON history_octane.smart_mi_rate_adjustment_case (smrac_pid);
CREATE INDEX idx_smart_mi_rate_card__pid ON history_octane.smart_mi_rate_card (smrca_pid);
CREATE INDEX idx_smart_mi_rate_case__pid ON history_octane.smart_mi_rate_case (smrc_pid);
CREATE INDEX idx_smart_mi_surcharge__pid ON history_octane.smart_mi_surcharge (sms_pid);
CREATE INDEX idx_smart_mi_surcharge_case__pid ON history_octane.smart_mi_surcharge_case (smsc_pid);
CREATE INDEX idx_smart_req__pid ON history_octane.smart_req (sr_pid);
CREATE INDEX idx_smart_separator__pid ON history_octane.smart_separator (ssp_pid);
CREATE INDEX idx_smart_set_doc__pid ON history_octane.smart_set_doc (sstd_pid);
CREATE INDEX idx_smart_stack__pid ON history_octane.smart_stack (ss_pid);
CREATE INDEX idx_smart_stack_doc__pid ON history_octane.smart_stack_doc (ssd_pid);
CREATE INDEX idx_smart_task__pid ON history_octane.smart_task (st_pid);
CREATE INDEX idx_smart_task_tag_modifier__pid ON history_octane.smart_task_tag_modifier (sttm_pid);
CREATE INDEX idx_stack_export_file__pid ON history_octane.stack_export_file (sef_pid);
CREATE INDEX idx_stack_export_request__pid ON history_octane.stack_export_request (ser_pid);
CREATE INDEX idx_stripe_payment__pid ON history_octane.stripe_payment (stpm_pid);
CREATE INDEX idx_tax_transcript_request__pid ON history_octane.tax_transcript_request (ttr_pid);
CREATE INDEX idx_third_party_community_second_program__pid ON history_octane.third_party_community_second_program (tpcsp_pid);
CREATE INDEX idx_title_company__pid ON history_octane.title_company (tc_pid);
CREATE INDEX idx_title_company_office__pid ON history_octane.title_company_office (tco_pid);
CREATE INDEX idx_trade__pid ON history_octane.trade (t_pid);
CREATE INDEX idx_trade_audit__pid ON history_octane.trade_audit (ta_pid);
CREATE INDEX idx_trade_fee__pid ON history_octane.trade_fee (tfe_pid);
CREATE INDEX idx_trade_fee_type__pid ON history_octane.trade_fee_type (tft_pid);
CREATE INDEX idx_trade_file__pid ON history_octane.trade_file (tf_pid);
CREATE INDEX idx_trade_lock_filter__pid ON history_octane.trade_lock_filter (tlf_pid);
CREATE INDEX idx_trade_note__pid ON history_octane.trade_note (tn_pid);
CREATE INDEX idx_trade_note_comment__pid ON history_octane.trade_note_comment (tnc_pid);
CREATE INDEX idx_trade_note_monitor__pid ON history_octane.trade_note_monitor (tnm_pid);
CREATE INDEX idx_trade_product__pid ON history_octane.trade_product (tp_pid);
CREATE INDEX idx_trustee__pid ON history_octane.trustee (tru_pid);
CREATE INDEX idx_unpaid_balance_adjustment__pid ON history_octane.unpaid_balance_adjustment (upba_pid);
CREATE INDEX idx_vendor_document_event__pid ON history_octane.vendor_document_event (vde_pid);
CREATE INDEX idx_vendor_document_repository_file__pid ON history_octane.vendor_document_repository_file (vdrf_pid);
CREATE INDEX idx_view_wf_deal_step_started__pid ON history_octane.view_wf_deal_step_started (wds_pid);
CREATE INDEX idx_wf_deal_fork_process__pid ON history_octane.wf_deal_fork_process (wdfp_pid);
CREATE INDEX idx_wf_deal_function_queue__pid ON history_octane.wf_deal_function_queue (wdfq_pid);
CREATE INDEX idx_wf_deal_outcome__pid ON history_octane.wf_deal_outcome (wdo_pid);
CREATE INDEX idx_wf_deal_process__pid ON history_octane.wf_deal_process (wdpr_pid);
CREATE INDEX idx_wf_deal_step__pid ON history_octane.wf_deal_step (wds_pid);
CREATE INDEX idx_wf_deal_step_timeout__pid ON history_octane.wf_deal_step_timeout (wdst_pid);
CREATE INDEX idx_wf_fork_process__pid ON history_octane.wf_fork_process (wfp_pid);
CREATE INDEX idx_wf_outcome__pid ON history_octane.wf_outcome (wo_pid);
CREATE INDEX idx_wf_phase__pid ON history_octane.wf_phase (wph_pid);
CREATE INDEX idx_wf_process__pid ON history_octane.wf_process (wpr_pid);
CREATE INDEX idx_wf_step__pid ON history_octane.wf_step (ws_pid);
CREATE INDEX idx_wf_step_deal_check__pid ON history_octane.wf_step_deal_check (wsdc_pid);
CREATE INDEX idx_wf_step_deal_check_definition__pid ON history_octane.wf_step_deal_check_definition (wsdd_pid);
CREATE INDEX idx_wf_step_deal_check_dependency__pid ON history_octane.wf_step_deal_check_dependency (wsdp_pid);
CREATE INDEX idx_wf_step_deal_tag_modifier__pid ON history_octane.wf_step_deal_tag_modifier (wsdt_pid);
CREATE INDEX idx_wf_wait_until_time_slice__pid ON history_octane.wf_wait_until_time_slice (wts_pid);
CREATE INDEX idx_zip_code_info__pid ON history_octane.zip_code_info (zci_pid);












































































































































































































































































































































































































































CREATE INDEX idx_account__pid_version ON history_octane.account (a_pid, a_version);
CREATE INDEX idx_account_contact__pid_version ON history_octane.account_contact (ac_pid, ac_version);
CREATE INDEX idx_account_event__pid_version ON history_octane.account_event (ae_pid, ae_version);
CREATE INDEX idx_account_grant_program__pid_version ON history_octane.account_grant_program (agp_pid, agp_version);
CREATE INDEX idx_admin_user__pid_version ON history_octane.admin_user (au_pid, au_version);
CREATE INDEX idx_admin_user_event__pid_version ON history_octane.admin_user_event (aue_pid, aue_version);
CREATE INDEX idx_announcement__pid_version ON history_octane.announcement (ann_pid, ann_version);
CREATE INDEX idx_apor__pid_version ON history_octane.apor (ap_pid, ap_version);
CREATE INDEX idx_application__pid_version ON history_octane.application (apl_pid, apl_version);
CREATE INDEX idx_appraisal__pid_version ON history_octane.appraisal (apr_pid, apr_version);
CREATE INDEX idx_appraisal_file__pid_version ON history_octane.appraisal_file (aprf_pid, aprf_version);
CREATE INDEX idx_appraisal_form__pid_version ON history_octane.appraisal_form (aprfm_pid, aprfm_version);
CREATE INDEX idx_appraisal_id_ticker__pid_version ON history_octane.appraisal_id_ticker (aprtk_pid, aprtk_version);
CREATE INDEX idx_appraisal_order_request__pid_version ON history_octane.appraisal_order_request (aprq_pid, aprq_version);
CREATE INDEX idx_appraisal_order_request_file__pid_version ON history_octane.appraisal_order_request_file (aorf_pid, aorf_version);
CREATE INDEX idx_area_median_income_row__pid_version ON history_octane.area_median_income_row (amir_pid, amir_version);
CREATE INDEX idx_area_median_income_table__pid_version ON history_octane.area_median_income_table (amit_pid, amit_version);
CREATE INDEX idx_arm_index_rate__pid_version ON history_octane.arm_index_rate (air_pid, air_version);
CREATE INDEX idx_asset__pid_version ON history_octane.asset (as_pid, as_version);
CREATE INDEX idx_asset_large_deposit__pid_version ON history_octane.asset_large_deposit (ald_pid, ald_version);
CREATE INDEX idx_aus_request_number_ticker__pid_version ON history_octane.aus_request_number_ticker (arnt_pid, arnt_version);
CREATE INDEX idx_backfill_loan_status__pid_version ON history_octane.backfill_loan_status (bfls_pid, bfls_version);
CREATE INDEX idx_backfill_status__pid_version ON history_octane.backfill_status (bfs_pid, bfs_version);
CREATE INDEX idx_bid_pool__pid_version ON history_octane.bid_pool (bp_pid, bp_version);
CREATE INDEX idx_bid_pool_file__pid_version ON history_octane.bid_pool_file (bpf_pid, bpf_version);
CREATE INDEX idx_bid_pool_lender_lock__pid_version ON history_octane.bid_pool_lender_lock (bpll_pid, bpll_version);
CREATE INDEX idx_bid_pool_note__pid_version ON history_octane.bid_pool_note (bpn_pid, bpn_version);
CREATE INDEX idx_bid_pool_note_comment__pid_version ON history_octane.bid_pool_note_comment (bpnc_pid, bpnc_version);
CREATE INDEX idx_bid_pool_note_monitor__pid_version ON history_octane.bid_pool_note_monitor (bpnm_pid, bpnm_version);
CREATE INDEX idx_borrower__pid_version ON history_octane.borrower (b_pid, b_version);
CREATE INDEX idx_borrower_alias__pid_version ON history_octane.borrower_alias (ba_pid, ba_version);
CREATE INDEX idx_borrower_asset__pid_version ON history_octane.borrower_asset (bas_pid, bas_version);
CREATE INDEX idx_borrower_associated_address__pid_version ON history_octane.borrower_associated_address (baa_pid, baa_version);
CREATE INDEX idx_borrower_credit_inquiry__pid_version ON history_octane.borrower_credit_inquiry (bci_pid, bci_version);
CREATE INDEX idx_borrower_declarations__pid_version ON history_octane.borrower_declarations (bdec_pid, bdec_version);
CREATE INDEX idx_borrower_dependent__pid_version ON history_octane.borrower_dependent (bd_pid, bd_version);
CREATE INDEX idx_borrower_income__pid_version ON history_octane.borrower_income (bi_pid, bi_version);
CREATE INDEX idx_borrower_job_gap__pid_version ON history_octane.borrower_job_gap (bjg_pid, bjg_version);
CREATE INDEX idx_borrower_liability__pid_version ON history_octane.borrower_liability (bl_pid, bl_version);
CREATE INDEX idx_borrower_public_record__pid_version ON history_octane.borrower_public_record (bpr_pid, bpr_version);
CREATE INDEX idx_borrower_reo__pid_version ON history_octane.borrower_reo (breo_pid, breo_version);
CREATE INDEX idx_borrower_residence__pid_version ON history_octane.borrower_residence (bres_pid, bres_version);
CREATE INDEX idx_borrower_tax_filing__pid_version ON history_octane.borrower_tax_filing (btf_pid, btf_version);
CREATE INDEX idx_borrower_user__pid_version ON history_octane.borrower_user (bu_pid, bu_version);
CREATE INDEX idx_borrower_user_change_email__pid_version ON history_octane.borrower_user_change_email (buce_pid, buce_version);
CREATE INDEX idx_borrower_user_deal__pid_version ON history_octane.borrower_user_deal (bud_pid, bud_version);
CREATE INDEX idx_borrower_va__pid_version ON history_octane.borrower_va (bva_pid, bva_version);
CREATE INDEX idx_branch__pid_version ON history_octane.branch (br_pid, br_version);
CREATE INDEX idx_branch_account_executive__pid_version ON history_octane.branch_account_executive (brae_pid, brae_version);
CREATE INDEX idx_branch_license__pid_version ON history_octane.branch_license (brml_pid, brml_version);
CREATE INDEX idx_business_income__pid_version ON history_octane.business_income (bui_pid, bui_version);
CREATE INDEX idx_channel__pid_version ON history_octane.channel (ch_pid, ch_version);
CREATE INDEX idx_circumstance_change__pid_version ON history_octane.circumstance_change (cc_pid, cc_version);
CREATE INDEX idx_company__pid_version ON history_octane.company (cm_pid, cm_version);
CREATE INDEX idx_company_admin_event__pid_version ON history_octane.company_admin_event (cae_pid, cae_version);
CREATE INDEX idx_company_license__pid_version ON history_octane.company_license (cml_pid, cml_version);
CREATE INDEX idx_compass_analytics_report_request__pid_version ON history_octane.compass_analytics_report_request (carr_pid, carr_version);
CREATE INDEX idx_construction_cost__pid_version ON history_octane.construction_cost (coc_pid, coc_version);
CREATE INDEX idx_construction_draw__pid_version ON history_octane.construction_draw (cd_pid, cd_version);
CREATE INDEX idx_construction_draw_item__pid_version ON history_octane.construction_draw_item (cdi_pid, cdi_version);
CREATE INDEX idx_construction_draw_number_ticker__pid_version ON history_octane.construction_draw_number_ticker (cdnt_pid, cdnt_version);
CREATE INDEX idx_consumer_privacy_affected_borrower__pid_version ON history_octane.consumer_privacy_affected_borrower (cpab_pid, cpab_version);
CREATE INDEX idx_consumer_privacy_request__pid_version ON history_octane.consumer_privacy_request (cpr_pid, cpr_version);
CREATE INDEX idx_contractor__pid_version ON history_octane.contractor (ctr_pid, ctr_version);
CREATE INDEX idx_contractor_license__pid_version ON history_octane.contractor_license (ctrl_pid, ctrl_version);
CREATE INDEX idx_cost_center__pid_version ON history_octane.cost_center (cosc_pid, cosc_version);
CREATE INDEX idx_county__pid_version ON history_octane.county (c_pid, c_version);
CREATE INDEX idx_county_city__pid_version ON history_octane.county_city (cci_pid, cci_version);
CREATE INDEX idx_county_recording_district__pid_version ON history_octane.county_recording_district (crdi_pid, crdi_version);
CREATE INDEX idx_county_sub_jurisdiction__pid_version ON history_octane.county_sub_jurisdiction (csju_pid, csju_version);
CREATE INDEX idx_county_zip_code__pid_version ON history_octane.county_zip_code (czc_pid, czc_version);
CREATE INDEX idx_credit_inquiry__pid_version ON history_octane.credit_inquiry (ci_pid, ci_version);
CREATE INDEX idx_credit_limit__pid_version ON history_octane.credit_limit (cl_pid, cl_version);
CREATE INDEX idx_credit_request__pid_version ON history_octane.credit_request (crdr_pid, crdr_version);
CREATE INDEX idx_creditor__pid_version ON history_octane.creditor (crd_pid, crd_version);
CREATE INDEX idx_creditor_lookup_name__pid_version ON history_octane.creditor_lookup_name (cln_pid, cln_version);
CREATE INDEX idx_criteria__pid_version ON history_octane.criteria (cr_pid, cr_version);
CREATE INDEX idx_criteria_pid_operand__pid_version ON history_octane.criteria_pid_operand (crpo_pid, crpo_version);
CREATE INDEX idx_criteria_snippet__pid_version ON history_octane.criteria_snippet (crs_pid, crs_version);
CREATE INDEX idx_custodian__pid_version ON history_octane.custodian (cu_pid, cu_version);
CREATE INDEX idx_custom_form__pid_version ON history_octane.custom_form (cf_pid, cf_version);
CREATE INDEX idx_custom_form_merge_field__pid_version ON history_octane.custom_form_merge_field (cfmf_pid, cfmf_version);
CREATE INDEX idx_deal__pid_version ON history_octane.deal (d_pid, d_version);
CREATE INDEX idx_deal_appraisal__pid_version ON history_octane.deal_appraisal (dappr_pid, dappr_version);
CREATE INDEX idx_deal_change_updater_time__pid_version ON history_octane.deal_change_updater_time (dcut_pid, dcut_version);
CREATE INDEX idx_deal_contact__pid_version ON history_octane.deal_contact (dc_pid, dc_version);
CREATE INDEX idx_deal_data_vendor_document_import__pid_version ON history_octane.deal_data_vendor_document_import (ddvdi_pid, ddvdi_version);
CREATE INDEX idx_deal_disaster_declaration__pid_version ON history_octane.deal_disaster_declaration (ddd_pid, ddd_version);
CREATE INDEX idx_deal_dropbox_file__pid_version ON history_octane.deal_dropbox_file (ddf_pid, ddf_version);
CREATE INDEX idx_deal_du__pid_version ON history_octane.deal_du (ddu_pid, ddu_version);
CREATE INDEX idx_deal_event__pid_version ON history_octane.deal_event (de_pid, de_version);
CREATE INDEX idx_deal_file__pid_version ON history_octane.deal_file (df_pid, df_version);
CREATE INDEX idx_deal_file_signature__pid_version ON history_octane.deal_file_signature (dfs_pid, dfs_version);
CREATE INDEX idx_deal_file_thumbnail__pid_version ON history_octane.deal_file_thumbnail (dft_pid, dft_version);
CREATE INDEX idx_deal_fraud_risk__pid_version ON history_octane.deal_fraud_risk (dfr_pid, dfr_version);
CREATE INDEX idx_deal_housing_counselor_candidate__pid_version ON history_octane.deal_housing_counselor_candidate (dhcc_pid, dhcc_version);
CREATE INDEX idx_deal_housing_counselors_request__pid_version ON history_octane.deal_housing_counselors_request (dhcr_pid, dhcr_version);
CREATE INDEX idx_deal_invoice__pid_version ON history_octane.deal_invoice (di_pid, di_version);
CREATE INDEX idx_deal_invoice_file__pid_version ON history_octane.deal_invoice_file (dif_pid, dif_version);
CREATE INDEX idx_deal_invoice_item__pid_version ON history_octane.deal_invoice_item (dii_pid, dii_version);
CREATE INDEX idx_deal_invoice_payment_method__pid_version ON history_octane.deal_invoice_payment_method (dipm_pid, dipm_version);
CREATE INDEX idx_deal_key_roles__pid_version ON history_octane.deal_key_roles (dkrs_pid, dkrs_version);
CREATE INDEX idx_deal_lender_user__pid_version ON history_octane.deal_lender_user (dlu_pid, dlu_version);
CREATE INDEX idx_deal_lender_user_event__pid_version ON history_octane.deal_lender_user_event (dlue_pid, dlue_version);
CREATE INDEX idx_deal_lp__pid_version ON history_octane.deal_lp (dlp_pid, dlp_version);
CREATE INDEX idx_deal_message_log__pid_version ON history_octane.deal_message_log (dmlog_pid, dmlog_version);
CREATE INDEX idx_deal_note__pid_version ON history_octane.deal_note (dn_pid, dn_version);
CREATE INDEX idx_deal_note_comment__pid_version ON history_octane.deal_note_comment (dnc_pid, dnc_version);
CREATE INDEX idx_deal_note_monitor__pid_version ON history_octane.deal_note_monitor (dnm_pid, dnm_version);
CREATE INDEX idx_deal_note_role_tag__pid_version ON history_octane.deal_note_role_tag (dnrt_pid, dnrt_version);
CREATE INDEX idx_deal_performer_team__pid_version ON history_octane.deal_performer_team (dptm_pid, dptm_version);
CREATE INDEX idx_deal_performer_team_user__pid_version ON history_octane.deal_performer_team_user (dptu_pid, dptu_version);
CREATE INDEX idx_deal_real_estate_agent__pid_version ON history_octane.deal_real_estate_agent (drea_pid, drea_version);
CREATE INDEX idx_deal_sap__pid_version ON history_octane.deal_sap (dsap_pid, dsap_version);
CREATE INDEX idx_deal_settlement__pid_version ON history_octane.deal_settlement (dsmt_pid, dsmt_version);
CREATE INDEX idx_deal_signer__pid_version ON history_octane.deal_signer (dsi_pid, dsi_version);
CREATE INDEX idx_deal_snapshot__pid_version ON history_octane.deal_snapshot (desn_pid, desn_version);
CREATE INDEX idx_deal_stage__pid_version ON history_octane.deal_stage (dst_pid, dst_version);
CREATE INDEX idx_deal_summary__pid_version ON history_octane.deal_summary (ds_pid, ds_version);
CREATE INDEX idx_deal_system_file__pid_version ON history_octane.deal_system_file (dsf_pid, dsf_version);
CREATE INDEX idx_deal_tag__pid_version ON history_octane.deal_tag (dtg_pid, dtg_version);
CREATE INDEX idx_deal_tag_definition__pid_version ON history_octane.deal_tag_definition (dtd_pid, dtd_version);
CREATE INDEX idx_deal_task__pid_version ON history_octane.deal_task (dt_pid, dt_version);
CREATE INDEX idx_disaster_declaration__pid_version ON history_octane.disaster_declaration (dd_pid, dd_version);
CREATE INDEX idx_docusign_package__pid_version ON history_octane.docusign_package (dcsp_pid, dcsp_version);
CREATE INDEX idx_du_key_finding__pid_version ON history_octane.du_key_finding (dukf_pid, dukf_version);
CREATE INDEX idx_du_refi_plus_finding__pid_version ON history_octane.du_refi_plus_finding (durpf_pid, durpf_version);
CREATE INDEX idx_du_request__pid_version ON history_octane.du_request (dur_pid, dur_version);
CREATE INDEX idx_du_request_credit__pid_version ON history_octane.du_request_credit (durc_pid, durc_version);
CREATE INDEX idx_du_special_feature_code__pid_version ON history_octane.du_special_feature_code (dusfc_pid, dusfc_version);
CREATE INDEX idx_dw_export_request__pid_version ON history_octane.dw_export_request (dwer_pid, dwer_version);
CREATE INDEX idx_ernst_request__pid_version ON history_octane.ernst_request (enst_pid, enst_version);
CREATE INDEX idx_ernst_request_question__pid_version ON history_octane.ernst_request_question (enstq_pid, enstq_version);
CREATE INDEX idx_exclusive_assignment__pid_version ON history_octane.exclusive_assignment (ea_pid, ea_version);
CREATE INDEX idx_flood_cert__pid_version ON history_octane.flood_cert (fc_pid, fc_version);
CREATE INDEX idx_formula_report_column__pid_version ON history_octane.formula_report_column (frc_pid, frc_version);
CREATE INDEX idx_google_sheet_export__pid_version ON history_octane.google_sheet_export (gse_pid, gse_version);
CREATE INDEX idx_hmda_report_request__pid_version ON history_octane.hmda_report_request (hrr_pid, hrr_version);
CREATE INDEX idx_hoepa_thresholds__pid_version ON history_octane.hoepa_thresholds (ht_pid, ht_version);
CREATE INDEX idx_interim_funder__pid_version ON history_octane.interim_funder (if_pid, if_version);
CREATE INDEX idx_investor__pid_version ON history_octane.investor (i_pid, i_version);
CREATE INDEX idx_investor_group__pid_version ON history_octane.investor_group (ig_pid, ig_version);
CREATE INDEX idx_investor_lock__pid_version ON history_octane.investor_lock (il_pid, il_version);
CREATE INDEX idx_investor_lock_add_on__pid_version ON history_octane.investor_lock_add_on (ila_pid, ila_version);
CREATE INDEX idx_investor_lock_extension__pid_version ON history_octane.investor_lock_extension (ile_pid, ile_version);
CREATE INDEX idx_investor_lock_extension_setting__pid_version ON history_octane.investor_lock_extension_setting (iles_pid, iles_version);
CREATE INDEX idx_job_income__pid_version ON history_octane.job_income (ji_pid, ji_version);
CREATE INDEX idx_key_package__pid_version ON history_octane.key_package (kp_pid, kp_version);
CREATE INDEX idx_key_role__pid_version ON history_octane.key_role (kr_pid, kr_version);
CREATE INDEX idx_lead__pid_version ON history_octane.lead (ld_pid, ld_version);
CREATE INDEX idx_lead_campaign__pid_version ON history_octane.lead_campaign (ldc_pid, ldc_version);
CREATE INDEX idx_lead_source__pid_version ON history_octane.lead_source (lds_pid, lds_version);
CREATE INDEX idx_lead_supplemental_margin_row__pid_version ON history_octane.lead_supplemental_margin_row (lsmr_pid, lsmr_version);
CREATE INDEX idx_lead_supplemental_margin_table__pid_version ON history_octane.lead_supplemental_margin_table (lsmt_pid, lsmt_version);
CREATE INDEX idx_lender_concession_request__pid_version ON history_octane.lender_concession_request (lcr_pid, lcr_version);
CREATE INDEX idx_lender_lock_add_on__pid_version ON history_octane.lender_lock_add_on (lla_pid, lla_version);
CREATE INDEX idx_lender_lock_extension__pid_version ON history_octane.lender_lock_extension (lle_pid, lle_version);
CREATE INDEX idx_lender_lock_id_ticker__pid_version ON history_octane.lender_lock_id_ticker (lltk_pid, lltk_version);
CREATE INDEX idx_lender_lock_major__pid_version ON history_octane.lender_lock_major (llmj_pid, llmj_version);
CREATE INDEX idx_lender_lock_minor__pid_version ON history_octane.lender_lock_minor (llmn_pid, llmn_version);
CREATE INDEX idx_lender_settings__pid_version ON history_octane.lender_settings (lss_pid, lss_version);
CREATE INDEX idx_lender_trade_id_ticker__pid_version ON history_octane.lender_trade_id_ticker (lttk_pid, lttk_version);
CREATE INDEX idx_lender_user__pid_version ON history_octane.lender_user (lu_pid, lu_version);
CREATE INDEX idx_lender_user_allowed_ip__pid_version ON history_octane.lender_user_allowed_ip (luip_pid, luip_version);
CREATE INDEX idx_lender_user_deal_visit__pid_version ON history_octane.lender_user_deal_visit (ludv_pid, ludv_version);
CREATE INDEX idx_lender_user_interest__pid_version ON history_octane.lender_user_interest (lui_pid, lui_version);
CREATE INDEX idx_lender_user_language__pid_version ON history_octane.lender_user_language (lul_pid, lul_version);
CREATE INDEX idx_lender_user_lead_source__pid_version ON history_octane.lender_user_lead_source (lulds_pid, lulds_version);
CREATE INDEX idx_lender_user_license__pid_version ON history_octane.lender_user_license (luml_pid, luml_version);
CREATE INDEX idx_lender_user_notice__pid_version ON history_octane.lender_user_notice (lun_pid, lun_version);
CREATE INDEX idx_lender_user_photo__pid_version ON history_octane.lender_user_photo (lup_pid, lup_version);
CREATE INDEX idx_lender_user_role__pid_version ON history_octane.lender_user_role (lur_pid, lur_version);
CREATE INDEX idx_lender_user_role_addendum__pid_version ON history_octane.lender_user_role_addendum (lura_pid, lura_version);
CREATE INDEX idx_lender_user_sign_on__pid_version ON history_octane.lender_user_sign_on (luso_pid, luso_version);
CREATE INDEX idx_lender_user_unavailable__pid_version ON history_octane.lender_user_unavailable (luu_pid, luu_version);
CREATE INDEX idx_liability__pid_version ON history_octane.liability (lia_pid, lia_version);
CREATE INDEX idx_license_req__pid_version ON history_octane.license_req (mlr_pid, mlr_version);
CREATE INDEX idx_loan__pid_version ON history_octane.loan (l_pid, l_version);
CREATE INDEX idx_loan_beneficiary__pid_version ON history_octane.loan_beneficiary (lb_pid, lb_version);
CREATE INDEX idx_loan_charge__pid_version ON history_octane.loan_charge (lc_pid, lc_version);
CREATE INDEX idx_loan_closing_doc__pid_version ON history_octane.loan_closing_doc (lcd_pid, lcd_version);
CREATE INDEX idx_loan_eligible_investor__pid_version ON history_octane.loan_eligible_investor (lei_pid, lei_version);
CREATE INDEX idx_loan_funding__pid_version ON history_octane.loan_funding (lf_pid, lf_version);
CREATE INDEX idx_loan_hedge__pid_version ON history_octane.loan_hedge (lh_pid, lh_version);
CREATE INDEX idx_loan_limit_row__pid_version ON history_octane.loan_limit_row (llr_pid, llr_version);
CREATE INDEX idx_loan_limit_table__pid_version ON history_octane.loan_limit_table (llt_pid, llt_version);
CREATE INDEX idx_loan_mi_rate_adjustment__pid_version ON history_octane.loan_mi_rate_adjustment (lmra_pid, lmra_version);
CREATE INDEX idx_loan_mi_surcharge__pid_version ON history_octane.loan_mi_surcharge (lms_pid, lms_version);
CREATE INDEX idx_loan_price_add_on__pid_version ON history_octane.loan_price_add_on (lpa_pid, lpa_version);
CREATE INDEX idx_loan_recording__pid_version ON history_octane.loan_recording (lr_pid, lr_version);
CREATE INDEX idx_loan_servicer__pid_version ON history_octane.loan_servicer (lsv_pid, lsv_version);
CREATE INDEX idx_lock_series__pid_version ON history_octane.lock_series (lsr_pid, lsr_version);
CREATE INDEX idx_lock_term_setting__pid_version ON history_octane.lock_term_setting (lts_pid, lts_version);
CREATE INDEX idx_los_loan_id_ticker__pid_version ON history_octane.los_loan_id_ticker (ltk_pid, ltk_version);
CREATE INDEX idx_lp_finding__pid_version ON history_octane.lp_finding (lpf_pid, lpf_version);
CREATE INDEX idx_lp_request__pid_version ON history_octane.lp_request (lpr_pid, lpr_version);
CREATE INDEX idx_lp_request_credit__pid_version ON history_octane.lp_request_credit (lprc_pid, lprc_version);
CREATE INDEX idx_master_property_insurance__pid_version ON history_octane.master_property_insurance (mpi_pid, mpi_version);
CREATE INDEX idx_mcr_loan__pid_version ON history_octane.mcr_loan (mcrl_pid, mcrl_version);
CREATE INDEX idx_mcr_snapshot__pid_version ON history_octane.mcr_snapshot (mcrs_pid, mcrs_version);
CREATE INDEX idx_mercury_client_group__pid_version ON history_octane.mercury_client_group (mcg_pid, mcg_version);
CREATE INDEX idx_mercury_network_status_request__pid_version ON history_octane.mercury_network_status_request (mnsr_pid, mnsr_version);
CREATE INDEX idx_mers_daily_report__pid_version ON history_octane.mers_daily_report (medr_pid, medr_version);
CREATE INDEX idx_mers_transfer_batch__pid_version ON history_octane.mers_transfer_batch (metb_pid, metb_version);
CREATE INDEX idx_mi_integration_vendor_request__pid_version ON history_octane.mi_integration_vendor_request (mivr_pid, mivr_version);
CREATE INDEX idx_military_service__pid_version ON history_octane.military_service (ms_pid, ms_version);
CREATE INDEX idx_minimum_required_residual_income_row__pid_version ON history_octane.minimum_required_residual_income_row (mrir_pid, mrir_version);
CREATE INDEX idx_minimum_required_residual_income_table__pid_version ON history_octane.minimum_required_residual_income_table (mrit_pid, mrit_version);
CREATE INDEX idx_mortech_account__pid_version ON history_octane.mortech_account (ma_pid, ma_version);
CREATE INDEX idx_mortgage_credit_certificate_issuer__pid_version ON history_octane.mortgage_credit_certificate_issuer (mcci_pid, mcci_version);
CREATE INDEX idx_net_tangible_benefit__pid_version ON history_octane.net_tangible_benefit (ntb_pid, ntb_version);
CREATE INDEX idx_new_lock_only_add_on__pid_version ON history_octane.new_lock_only_add_on (nlo_pid, nlo_version);
CREATE INDEX idx_obligation__pid_version ON history_octane.obligation (ob_pid, ob_version);
CREATE INDEX idx_offering__pid_version ON history_octane.offering (of_pid, of_version);
CREATE INDEX idx_offering_group__pid_version ON history_octane.offering_group (ofg_pid, ofg_version);
CREATE INDEX idx_offering_product__pid_version ON history_octane.offering_product (ofp_pid, ofp_version);
CREATE INDEX idx_org_division__pid_version ON history_octane.org_division (orgd_pid, orgd_version);
CREATE INDEX idx_org_division_leader__pid_version ON history_octane.org_division_leader (orgdl_pid, orgdl_version);
CREATE INDEX idx_org_division_terms__pid_version ON history_octane.org_division_terms (orgdt_pid, orgdt_version);
CREATE INDEX idx_org_group__pid_version ON history_octane.org_group (orgg_pid, orgg_version);
CREATE INDEX idx_org_group_leader__pid_version ON history_octane.org_group_leader (orggl_pid, orggl_version);
CREATE INDEX idx_org_group_terms__pid_version ON history_octane.org_group_terms (orggt_pid, orggt_version);
CREATE INDEX idx_org_lender_user_terms__pid_version ON history_octane.org_lender_user_terms (orglut_pid, orglut_version);
CREATE INDEX idx_org_region__pid_version ON history_octane.org_region (orgr_pid, orgr_version);
CREATE INDEX idx_org_region_leader__pid_version ON history_octane.org_region_leader (orgrl_pid, orgrl_version);
CREATE INDEX idx_org_region_terms__pid_version ON history_octane.org_region_terms (orgrt_pid, orgrt_version);
CREATE INDEX idx_org_team__pid_version ON history_octane.org_team (orgt_pid, orgt_version);
CREATE INDEX idx_org_team_leader__pid_version ON history_octane.org_team_leader (orgtl_pid, orgtl_version);
CREATE INDEX idx_org_team_terms__pid_version ON history_octane.org_team_terms (orgtt_pid, orgtt_version);
CREATE INDEX idx_org_unit__pid_version ON history_octane.org_unit (orgu_pid, orgu_version);
CREATE INDEX idx_org_unit_leader__pid_version ON history_octane.org_unit_leader (orgul_pid, orgul_version);
CREATE INDEX idx_org_unit_terms__pid_version ON history_octane.org_unit_terms (orgut_pid, orgut_version);
CREATE INDEX idx_other_income__pid_version ON history_octane.other_income (oi_pid, oi_version);
CREATE INDEX idx_performer_assignment__pid_version ON history_octane.performer_assignment (pa_pid, pa_version);
CREATE INDEX idx_performer_team__pid_version ON history_octane.performer_team (ptm_pid, ptm_version);
CREATE INDEX idx_place__pid_version ON history_octane.place (pl_pid, pl_version);
CREATE INDEX idx_preferred_settlement__pid_version ON history_octane.preferred_settlement (prs_pid, prs_version);
CREATE INDEX idx_price_processing_time__pid_version ON history_octane.price_processing_time (ppt_pid, ppt_version);
CREATE INDEX idx_product__pid_version ON history_octane.product (p_pid, p_version);
CREATE INDEX idx_product_add_on__pid_version ON history_octane.product_add_on (pao_pid, pao_version);
CREATE INDEX idx_product_add_on_rule__pid_version ON history_octane.product_add_on_rule (par_pid, par_version);
CREATE INDEX idx_product_branch__pid_version ON history_octane.product_branch (pbr_pid, pbr_version);
CREATE INDEX idx_product_buydown__pid_version ON history_octane.product_buydown (pbd_pid, pbd_version);
CREATE INDEX idx_product_deal_check_exclusion__pid_version ON history_octane.product_deal_check_exclusion (pdce_pid, pdce_version);
CREATE INDEX idx_product_eligibility__pid_version ON history_octane.product_eligibility (pe_pid, pe_version);
CREATE INDEX idx_product_eligibility_rule__pid_version ON history_octane.product_eligibility_rule (per_pid, per_version);
CREATE INDEX idx_product_interest_only__pid_version ON history_octane.product_interest_only (pio_pid, pio_version);
CREATE INDEX idx_product_lock_term__pid_version ON history_octane.product_lock_term (plt_pid, plt_version);
CREATE INDEX idx_product_maximum_investor_price__pid_version ON history_octane.product_maximum_investor_price (pmip_pid, pmip_version);
CREATE INDEX idx_product_maximum_rebate__pid_version ON history_octane.product_maximum_rebate (pmr_pid, pmr_version);
CREATE INDEX idx_product_minimum_investor_price__pid_version ON history_octane.product_minimum_investor_price (pminip_pid, pminip_version);
CREATE INDEX idx_product_originator__pid_version ON history_octane.product_originator (po_pid, po_version);
CREATE INDEX idx_product_prepay_penalty__pid_version ON history_octane.product_prepay_penalty (ppp_pid, ppp_version);
CREATE INDEX idx_product_terms__pid_version ON history_octane.product_terms (pt_pid, pt_version);
CREATE INDEX idx_product_third_party_community_second_program__pid_version ON history_octane.product_third_party_community_second_program (ptpp_pid, ptpp_version);
CREATE INDEX idx_profit_margin_detail__pid_version ON history_octane.profit_margin_detail (pmd_pid, pmd_version);
CREATE INDEX idx_proposal__pid_version ON history_octane.proposal (prp_pid, prp_version);
CREATE INDEX idx_proposal_contractor__pid_version ON history_octane.proposal_contractor (pctr_pid, pctr_version);
CREATE INDEX idx_proposal_doc__pid_version ON history_octane.proposal_doc (prpd_pid, prpd_version);
CREATE INDEX idx_proposal_doc_borrower_access__pid_version ON history_octane.proposal_doc_borrower_access (pdba_pid, pdba_version);
CREATE INDEX idx_proposal_doc_file__pid_version ON history_octane.proposal_doc_file (prpdf_pid, prpdf_version);
CREATE INDEX idx_proposal_doc_set__pid_version ON history_octane.proposal_doc_set (prpds_pid, prpds_version);
CREATE INDEX idx_proposal_doc_set_id_ticker__pid_version ON history_octane.proposal_doc_set_id_ticker (pdstk_pid, pdstk_version);
CREATE INDEX idx_proposal_doc_set_signer__pid_version ON history_octane.proposal_doc_set_signer (prpdss_pid, prpdss_version);
CREATE INDEX idx_proposal_doc_set_snapshot__pid_version ON history_octane.proposal_doc_set_snapshot (prpdssn_pid, prpdssn_version);
CREATE INDEX idx_proposal_engagement__pid_version ON history_octane.proposal_engagement (prpe_pid, prpe_version);
CREATE INDEX idx_proposal_grant_program__pid_version ON history_octane.proposal_grant_program (pgp_pid, pgp_version);
CREATE INDEX idx_proposal_req__pid_version ON history_octane.proposal_req (prpr_pid, prpr_version);
CREATE INDEX idx_proposal_review__pid_version ON history_octane.proposal_review (prpre_pid, prpre_version);
CREATE INDEX idx_proposal_review_ticker__pid_version ON history_octane.proposal_review_ticker (prpret_pid, prpret_version);
CREATE INDEX idx_proposal_summary__pid_version ON history_octane.proposal_summary (ps_pid, ps_version);
CREATE INDEX idx_pte_request__pid_version ON history_octane.pte_request (pter_pid, pter_version);
CREATE INDEX idx_public_record__pid_version ON history_octane.public_record (pr_pid, pr_version);
CREATE INDEX idx_qualified_mortgage_thresholds__pid_version ON history_octane.qualified_mortgage_thresholds (qmt_pid, qmt_version);
CREATE INDEX idx_rate_sheet__pid_version ON history_octane.rate_sheet (rs_pid, rs_version);
CREATE INDEX idx_rate_sheet_price__pid_version ON history_octane.rate_sheet_price (rsp_pid, rsp_version);
CREATE INDEX idx_rate_sheet_rate__pid_version ON history_octane.rate_sheet_rate (rsr_pid, rsr_version);
CREATE INDEX idx_recording_city__pid_version ON history_octane.recording_city (rc_pid, rc_version);
CREATE INDEX idx_recording_district__pid_version ON history_octane.recording_district (rdi_pid, rdi_version);
CREATE INDEX idx_region_ernst_page_rec__pid_version ON history_octane.region_ernst_page_rec (rerc_pid, rerc_version);
CREATE INDEX idx_relock_fee_setting__pid_version ON history_octane.relock_fee_setting (rfs_pid, rfs_version);
CREATE INDEX idx_rental_income__pid_version ON history_octane.rental_income (ri_pid, ri_version);
CREATE INDEX idx_report__pid_version ON history_octane.report (rp_pid, rp_version);
CREATE INDEX idx_report_column__pid_version ON history_octane.report_column (rpc_pid, rpc_version);
CREATE INDEX idx_report_row__pid_version ON history_octane.report_row (rprw_pid, rprw_version);
CREATE INDEX idx_repository_file__pid_version ON history_octane.repository_file (rf_pid, rf_version);
CREATE INDEX idx_role__pid_version ON history_octane.role (r_pid, r_version);
CREATE INDEX idx_role_charge_permissions__pid_version ON history_octane.role_charge_permissions (rcp_pid, rcp_version);
CREATE INDEX idx_role_config_export_permission__pid_version ON history_octane.role_config_export_permission (rcep_pid, rcep_version);
CREATE INDEX idx_role_deal_context__pid_version ON history_octane.role_deal_context (rdc_pid, rdc_version);
CREATE INDEX idx_role_export_permission__pid_version ON history_octane.role_export_permission (rep_pid, rep_version);
CREATE INDEX idx_role_lender_toolbox__pid_version ON history_octane.role_lender_toolbox (rlet_pid, rlet_version);
CREATE INDEX idx_role_loans_toolbox__pid_version ON history_octane.role_loans_toolbox (rlot_pid, rlot_version);
CREATE INDEX idx_role_performer_assign__pid_version ON history_octane.role_performer_assign (rpa_pid, rpa_version);
CREATE INDEX idx_role_report__pid_version ON history_octane.role_report (rrp_pid, rrp_version);
CREATE INDEX idx_sap_deal_step__pid_version ON history_octane.sap_deal_step (sds_pid, sds_version);
CREATE INDEX idx_sap_quote_request__pid_version ON history_octane.sap_quote_request (sqr_pid, sqr_version);
CREATE INDEX idx_secondary_admin_event__pid_version ON history_octane.secondary_admin_event (sae_pid, sae_version);
CREATE INDEX idx_secondary_settings__pid_version ON history_octane.secondary_settings (sset_pid, sset_version);
CREATE INDEX idx_servicer_loan_id_assignment__pid_version ON history_octane.servicer_loan_id_assignment (slia_pid, slia_version);
CREATE INDEX idx_servicer_loan_id_import_request__pid_version ON history_octane.servicer_loan_id_import_request (slir_pid, slir_version);
CREATE INDEX idx_settlement_agent__pid_version ON history_octane.settlement_agent (sa_pid, sa_version);
CREATE INDEX idx_settlement_agent_office__pid_version ON history_octane.settlement_agent_office (sao_pid, sao_version);
CREATE INDEX idx_settlement_agent_wire__pid_version ON history_octane.settlement_agent_wire (saw_pid, saw_version);
CREATE INDEX idx_site_allowed_ip__pid_version ON history_octane.site_allowed_ip (saip_pid, saip_version);
CREATE INDEX idx_smart_charge__pid_version ON history_octane.smart_charge (sc_pid, sc_version);
CREATE INDEX idx_smart_charge_case__pid_version ON history_octane.smart_charge_case (scc_pid, scc_version);
CREATE INDEX idx_smart_charge_group__pid_version ON history_octane.smart_charge_group (scg_pid, scg_version);
CREATE INDEX idx_smart_charge_group_case__pid_version ON history_octane.smart_charge_group_case (scgc_pid, scgc_version);
CREATE INDEX idx_smart_doc__pid_version ON history_octane.smart_doc (sd_pid, sd_version);
CREATE INDEX idx_smart_doc_criteria__pid_version ON history_octane.smart_doc_criteria (sdc_pid, sdc_version);
CREATE INDEX idx_smart_doc_note__pid_version ON history_octane.smart_doc_note (sdn_pid, sdn_version);
CREATE INDEX idx_smart_doc_note_comment__pid_version ON history_octane.smart_doc_note_comment (sdnc_pid, sdnc_version);
CREATE INDEX idx_smart_doc_note_monitor__pid_version ON history_octane.smart_doc_note_monitor (sdnm_pid, sdnm_version);
CREATE INDEX idx_smart_doc_role__pid_version ON history_octane.smart_doc_role (sdr_pid, sdr_version);
CREATE INDEX idx_smart_doc_set__pid_version ON history_octane.smart_doc_set (sdst_pid, sdst_version);
CREATE INDEX idx_smart_message__pid_version ON history_octane.smart_message (smsg_pid, smsg_version);
CREATE INDEX idx_smart_message_recipient__pid_version ON history_octane.smart_message_recipient (smr_pid, smr_version);
CREATE INDEX idx_smart_mi__pid_version ON history_octane.smart_mi (sm_pid, sm_version);
CREATE INDEX idx_smart_mi_eligibility_case__pid_version ON history_octane.smart_mi_eligibility_case (smec_pid, smec_version);
CREATE INDEX idx_smart_mi_rate_adjustment_case__pid_version ON history_octane.smart_mi_rate_adjustment_case (smrac_pid, smrac_version);
CREATE INDEX idx_smart_mi_rate_card__pid_version ON history_octane.smart_mi_rate_card (smrca_pid, smrca_version);
CREATE INDEX idx_smart_mi_rate_case__pid_version ON history_octane.smart_mi_rate_case (smrc_pid, smrc_version);
CREATE INDEX idx_smart_mi_surcharge__pid_version ON history_octane.smart_mi_surcharge (sms_pid, sms_version);
CREATE INDEX idx_smart_mi_surcharge_case__pid_version ON history_octane.smart_mi_surcharge_case (smsc_pid, smsc_version);
CREATE INDEX idx_smart_req__pid_version ON history_octane.smart_req (sr_pid, sr_version);
CREATE INDEX idx_smart_separator__pid_version ON history_octane.smart_separator (ssp_pid, ssp_version);
CREATE INDEX idx_smart_set_doc__pid_version ON history_octane.smart_set_doc (sstd_pid, sstd_version);
CREATE INDEX idx_smart_stack__pid_version ON history_octane.smart_stack (ss_pid, ss_version);
CREATE INDEX idx_smart_stack_doc__pid_version ON history_octane.smart_stack_doc (ssd_pid, ssd_version);
CREATE INDEX idx_smart_task__pid_version ON history_octane.smart_task (st_pid, st_version);
CREATE INDEX idx_smart_task_tag_modifier__pid_version ON history_octane.smart_task_tag_modifier (sttm_pid, sttm_version);
CREATE INDEX idx_stack_export_file__pid_version ON history_octane.stack_export_file (sef_pid, sef_version);
CREATE INDEX idx_stack_export_request__pid_version ON history_octane.stack_export_request (ser_pid, ser_version);
CREATE INDEX idx_stripe_payment__pid_version ON history_octane.stripe_payment (stpm_pid, stpm_version);
CREATE INDEX idx_tax_transcript_request__pid_version ON history_octane.tax_transcript_request (ttr_pid, ttr_version);
CREATE INDEX idx_third_party_community_second_program__pid_version ON history_octane.third_party_community_second_program (tpcsp_pid, tpcsp_version);
CREATE INDEX idx_title_company__pid_version ON history_octane.title_company (tc_pid, tc_version);
CREATE INDEX idx_title_company_office__pid_version ON history_octane.title_company_office (tco_pid, tco_version);
CREATE INDEX idx_trade__pid_version ON history_octane.trade (t_pid, t_version);
CREATE INDEX idx_trade_audit__pid_version ON history_octane.trade_audit (ta_pid, ta_version);
CREATE INDEX idx_trade_fee__pid_version ON history_octane.trade_fee (tfe_pid, tfe_version);
CREATE INDEX idx_trade_fee_type__pid_version ON history_octane.trade_fee_type (tft_pid, tft_version);
CREATE INDEX idx_trade_file__pid_version ON history_octane.trade_file (tf_pid, tf_version);
CREATE INDEX idx_trade_lock_filter__pid_version ON history_octane.trade_lock_filter (tlf_pid, tlf_version);
CREATE INDEX idx_trade_note__pid_version ON history_octane.trade_note (tn_pid, tn_version);
CREATE INDEX idx_trade_note_comment__pid_version ON history_octane.trade_note_comment (tnc_pid, tnc_version);
CREATE INDEX idx_trade_note_monitor__pid_version ON history_octane.trade_note_monitor (tnm_pid, tnm_version);
CREATE INDEX idx_trade_product__pid_version ON history_octane.trade_product (tp_pid, tp_version);
CREATE INDEX idx_trustee__pid_version ON history_octane.trustee (tru_pid, tru_version);
CREATE INDEX idx_unpaid_balance_adjustment__pid_version ON history_octane.unpaid_balance_adjustment (upba_pid, upba_version);
CREATE INDEX idx_vendor_document_event__pid_version ON history_octane.vendor_document_event (vde_pid, vde_version);
CREATE INDEX idx_vendor_document_repository_file__pid_version ON history_octane.vendor_document_repository_file (vdrf_pid, vdrf_version);
CREATE INDEX idx_view_wf_deal_step_started__pid_version ON history_octane.view_wf_deal_step_started (wds_pid, wds_version);
CREATE INDEX idx_wf_deal_fork_process__pid_version ON history_octane.wf_deal_fork_process (wdfp_pid, wdfp_version);
CREATE INDEX idx_wf_deal_function_queue__pid_version ON history_octane.wf_deal_function_queue (wdfq_pid, wdfq_version);
CREATE INDEX idx_wf_deal_outcome__pid_version ON history_octane.wf_deal_outcome (wdo_pid, wdo_version);
CREATE INDEX idx_wf_deal_process__pid_version ON history_octane.wf_deal_process (wdpr_pid, wdpr_version);
CREATE INDEX idx_wf_deal_step__pid_version ON history_octane.wf_deal_step (wds_pid, wds_version);
CREATE INDEX idx_wf_deal_step_timeout__pid_version ON history_octane.wf_deal_step_timeout (wdst_pid, wdst_version);
CREATE INDEX idx_wf_fork_process__pid_version ON history_octane.wf_fork_process (wfp_pid, wfp_version);
CREATE INDEX idx_wf_outcome__pid_version ON history_octane.wf_outcome (wo_pid, wo_version);
CREATE INDEX idx_wf_phase__pid_version ON history_octane.wf_phase (wph_pid, wph_version);
CREATE INDEX idx_wf_process__pid_version ON history_octane.wf_process (wpr_pid, wpr_version);
CREATE INDEX idx_wf_step__pid_version ON history_octane.wf_step (ws_pid, ws_version);
CREATE INDEX idx_wf_step_deal_check__pid_version ON history_octane.wf_step_deal_check (wsdc_pid, wsdc_version);
CREATE INDEX idx_wf_step_deal_check_definition__pid_version ON history_octane.wf_step_deal_check_definition (wsdd_pid, wsdd_version);
CREATE INDEX idx_wf_step_deal_check_dependency__pid_version ON history_octane.wf_step_deal_check_dependency (wsdp_pid, wsdp_version);
CREATE INDEX idx_wf_step_deal_tag_modifier__pid_version ON history_octane.wf_step_deal_tag_modifier (wsdt_pid, wsdt_version);
CREATE INDEX idx_wf_wait_until_time_slice__pid_version ON history_octane.wf_wait_until_time_slice (wts_pid, wts_version);

-- SQL for migration: staging_octane
CREATE INDEX idx_account__pid_version ON staging_octane.account ( a_pid, a_version );
CREATE INDEX idx_account_contact__pid_version ON staging_octane.account_contact ( ac_pid, ac_version );
CREATE INDEX idx_account_event__pid_version ON staging_octane.account_event ( ae_pid, ae_version );
CREATE INDEX idx_account_grant_program__pid_version ON staging_octane.account_grant_program ( agp_pid, agp_version );
CREATE INDEX idx_admin_user__pid_version ON staging_octane.admin_user ( au_pid, au_version );
CREATE INDEX idx_admin_user_event__pid_version ON staging_octane.admin_user_event ( aue_pid, aue_version );
CREATE INDEX idx_announcement__pid_version ON staging_octane.announcement ( ann_pid, ann_version );
CREATE INDEX idx_apor__pid_version ON staging_octane.apor ( ap_pid, ap_version );
CREATE INDEX idx_application__pid_version ON staging_octane.application ( apl_pid, apl_version );
CREATE INDEX idx_appraisal__pid_version ON staging_octane.appraisal ( apr_pid, apr_version );
CREATE INDEX idx_appraisal_file__pid_version ON staging_octane.appraisal_file ( aprf_pid, aprf_version );
CREATE INDEX idx_appraisal_form__pid_version ON staging_octane.appraisal_form ( aprfm_pid, aprfm_version );
CREATE INDEX idx_appraisal_id_ticker__pid_version ON staging_octane.appraisal_id_ticker ( aprtk_pid, aprtk_version );
CREATE INDEX idx_appraisal_order_request__pid_version ON staging_octane.appraisal_order_request ( aprq_pid, aprq_version );
CREATE INDEX idx_appraisal_order_request_file__pid_version ON staging_octane.appraisal_order_request_file ( aorf_pid, aorf_version );
CREATE INDEX idx_area_median_income_row__pid_version ON staging_octane.area_median_income_row ( amir_pid, amir_version );
CREATE INDEX idx_area_median_income_table__pid_version ON staging_octane.area_median_income_table ( amit_pid, amit_version );
CREATE INDEX idx_arm_index_rate__pid_version ON staging_octane.arm_index_rate ( air_pid, air_version );
CREATE INDEX idx_asset__pid_version ON staging_octane.asset ( as_pid, as_version );
CREATE INDEX idx_asset_large_deposit__pid_version ON staging_octane.asset_large_deposit ( ald_pid, ald_version );
CREATE INDEX idx_aus_request_number_ticker__pid_version ON staging_octane.aus_request_number_ticker ( arnt_pid, arnt_version );
CREATE INDEX idx_backfill_loan_status__pid_version ON staging_octane.backfill_loan_status ( bfls_pid, bfls_version );
CREATE INDEX idx_backfill_status__pid_version ON staging_octane.backfill_status ( bfs_pid, bfs_version );
CREATE INDEX idx_bid_pool__pid_version ON staging_octane.bid_pool ( bp_pid, bp_version );
CREATE INDEX idx_bid_pool_file__pid_version ON staging_octane.bid_pool_file ( bpf_pid, bpf_version );
CREATE INDEX idx_bid_pool_lender_lock__pid_version ON staging_octane.bid_pool_lender_lock ( bpll_pid, bpll_version );
CREATE INDEX idx_bid_pool_note__pid_version ON staging_octane.bid_pool_note ( bpn_pid, bpn_version );
CREATE INDEX idx_bid_pool_note_comment__pid_version ON staging_octane.bid_pool_note_comment ( bpnc_pid, bpnc_version );
CREATE INDEX idx_bid_pool_note_monitor__pid_version ON staging_octane.bid_pool_note_monitor ( bpnm_pid, bpnm_version );
CREATE INDEX idx_borrower__pid_version ON staging_octane.borrower ( b_pid, b_version );
CREATE INDEX idx_borrower_alias__pid_version ON staging_octane.borrower_alias ( ba_pid, ba_version );
CREATE INDEX idx_borrower_asset__pid_version ON staging_octane.borrower_asset ( bas_pid, bas_version );
CREATE INDEX idx_borrower_associated_address__pid_version ON staging_octane.borrower_associated_address ( baa_pid, baa_version );
CREATE INDEX idx_borrower_credit_inquiry__pid_version ON staging_octane.borrower_credit_inquiry ( bci_pid, bci_version );
CREATE INDEX idx_borrower_declarations__pid_version ON staging_octane.borrower_declarations ( bdec_pid, bdec_version );
CREATE INDEX idx_borrower_dependent__pid_version ON staging_octane.borrower_dependent ( bd_pid, bd_version );
CREATE INDEX idx_borrower_income__pid_version ON staging_octane.borrower_income ( bi_pid, bi_version );
CREATE INDEX idx_borrower_job_gap__pid_version ON staging_octane.borrower_job_gap ( bjg_pid, bjg_version );
CREATE INDEX idx_borrower_liability__pid_version ON staging_octane.borrower_liability ( bl_pid, bl_version );
CREATE INDEX idx_borrower_public_record__pid_version ON staging_octane.borrower_public_record ( bpr_pid, bpr_version );
CREATE INDEX idx_borrower_reo__pid_version ON staging_octane.borrower_reo ( breo_pid, breo_version );
CREATE INDEX idx_borrower_residence__pid_version ON staging_octane.borrower_residence ( bres_pid, bres_version );
CREATE INDEX idx_borrower_tax_filing__pid_version ON staging_octane.borrower_tax_filing ( btf_pid, btf_version );
CREATE INDEX idx_borrower_user__pid_version ON staging_octane.borrower_user ( bu_pid, bu_version );
CREATE INDEX idx_borrower_user_change_email__pid_version ON staging_octane.borrower_user_change_email ( buce_pid, buce_version );
CREATE INDEX idx_borrower_user_deal__pid_version ON staging_octane.borrower_user_deal ( bud_pid, bud_version );
CREATE INDEX idx_borrower_va__pid_version ON staging_octane.borrower_va ( bva_pid, bva_version );
CREATE INDEX idx_branch__pid_version ON staging_octane.branch ( br_pid, br_version );
CREATE INDEX idx_branch_account_executive__pid_version ON staging_octane.branch_account_executive ( brae_pid, brae_version );
CREATE INDEX idx_branch_license__pid_version ON staging_octane.branch_license ( brml_pid, brml_version );
CREATE INDEX idx_business_income__pid_version ON staging_octane.business_income ( bui_pid, bui_version );
CREATE INDEX idx_channel__pid_version ON staging_octane.channel ( ch_pid, ch_version );
CREATE INDEX idx_circumstance_change__pid_version ON staging_octane.circumstance_change ( cc_pid, cc_version );
CREATE INDEX idx_company__pid_version ON staging_octane.company ( cm_pid, cm_version );
CREATE INDEX idx_company_admin_event__pid_version ON staging_octane.company_admin_event ( cae_pid, cae_version );
CREATE INDEX idx_company_license__pid_version ON staging_octane.company_license ( cml_pid, cml_version );
CREATE INDEX idx_compass_analytics_report_request__pid_version ON staging_octane.compass_analytics_report_request ( carr_pid, carr_version );
CREATE INDEX idx_construction_cost__pid_version ON staging_octane.construction_cost ( coc_pid, coc_version );
CREATE INDEX idx_construction_draw__pid_version ON staging_octane.construction_draw ( cd_pid, cd_version );
CREATE INDEX idx_construction_draw_item__pid_version ON staging_octane.construction_draw_item ( cdi_pid, cdi_version );
CREATE INDEX idx_construction_draw_number_ticker__pid_version ON staging_octane.construction_draw_number_ticker ( cdnt_pid, cdnt_version );
CREATE INDEX idx_consumer_privacy_affected_borrower__pid_version ON staging_octane.consumer_privacy_affected_borrower ( cpab_pid, cpab_version );
CREATE INDEX idx_consumer_privacy_request__pid_version ON staging_octane.consumer_privacy_request ( cpr_pid, cpr_version );
CREATE INDEX idx_contractor__pid_version ON staging_octane.contractor ( ctr_pid, ctr_version );
CREATE INDEX idx_contractor_license__pid_version ON staging_octane.contractor_license ( ctrl_pid, ctrl_version );
CREATE INDEX idx_cost_center__pid_version ON staging_octane.cost_center ( cosc_pid, cosc_version );
CREATE INDEX idx_county__pid_version ON staging_octane.county ( c_pid, c_version );
CREATE INDEX idx_county_city__pid_version ON staging_octane.county_city ( cci_pid, cci_version );
CREATE INDEX idx_county_recording_district__pid_version ON staging_octane.county_recording_district ( crdi_pid, crdi_version );
CREATE INDEX idx_county_sub_jurisdiction__pid_version ON staging_octane.county_sub_jurisdiction ( csju_pid, csju_version );
CREATE INDEX idx_county_zip_code__pid_version ON staging_octane.county_zip_code ( czc_pid, czc_version );
CREATE INDEX idx_credit_inquiry__pid_version ON staging_octane.credit_inquiry ( ci_pid, ci_version );
CREATE INDEX idx_credit_limit__pid_version ON staging_octane.credit_limit ( cl_pid, cl_version );
CREATE INDEX idx_credit_request__pid_version ON staging_octane.credit_request ( crdr_pid, crdr_version );
CREATE INDEX idx_creditor__pid_version ON staging_octane.creditor ( crd_pid, crd_version );
CREATE INDEX idx_creditor_lookup_name__pid_version ON staging_octane.creditor_lookup_name ( cln_pid, cln_version );
CREATE INDEX idx_criteria__pid_version ON staging_octane.criteria ( cr_pid, cr_version );
CREATE INDEX idx_criteria_pid_operand__pid_version ON staging_octane.criteria_pid_operand ( crpo_pid, crpo_version );
CREATE INDEX idx_criteria_snippet__pid_version ON staging_octane.criteria_snippet ( crs_pid, crs_version );
CREATE INDEX idx_custodian__pid_version ON staging_octane.custodian ( cu_pid, cu_version );
CREATE INDEX idx_custom_form__pid_version ON staging_octane.custom_form ( cf_pid, cf_version );
CREATE INDEX idx_custom_form_merge_field__pid_version ON staging_octane.custom_form_merge_field ( cfmf_pid, cfmf_version );
CREATE INDEX idx_deal__pid_version ON staging_octane.deal ( d_pid, d_version );
CREATE INDEX idx_deal_appraisal__pid_version ON staging_octane.deal_appraisal ( dappr_pid, dappr_version );
CREATE INDEX idx_deal_change_updater_time__pid_version ON staging_octane.deal_change_updater_time ( dcut_pid, dcut_version );
CREATE INDEX idx_deal_contact__pid_version ON staging_octane.deal_contact ( dc_pid, dc_version );
CREATE INDEX idx_deal_data_vendor_document_import__pid_version ON staging_octane.deal_data_vendor_document_import ( ddvdi_pid, ddvdi_version );
CREATE INDEX idx_deal_disaster_declaration__pid_version ON staging_octane.deal_disaster_declaration ( ddd_pid, ddd_version );
CREATE INDEX idx_deal_dropbox_file__pid_version ON staging_octane.deal_dropbox_file ( ddf_pid, ddf_version );
CREATE INDEX idx_deal_du__pid_version ON staging_octane.deal_du ( ddu_pid, ddu_version );
CREATE INDEX idx_deal_event__pid_version ON staging_octane.deal_event ( de_pid, de_version );
CREATE INDEX idx_deal_file__pid_version ON staging_octane.deal_file ( df_pid, df_version );
CREATE INDEX idx_deal_file_signature__pid_version ON staging_octane.deal_file_signature ( dfs_pid, dfs_version );
CREATE INDEX idx_deal_file_thumbnail__pid_version ON staging_octane.deal_file_thumbnail ( dft_pid, dft_version );
CREATE INDEX idx_deal_fraud_risk__pid_version ON staging_octane.deal_fraud_risk ( dfr_pid, dfr_version );
CREATE INDEX idx_deal_housing_counselor_candidate__pid_version ON staging_octane.deal_housing_counselor_candidate ( dhcc_pid, dhcc_version );
CREATE INDEX idx_deal_housing_counselors_request__pid_version ON staging_octane.deal_housing_counselors_request ( dhcr_pid, dhcr_version );
CREATE INDEX idx_deal_invoice__pid_version ON staging_octane.deal_invoice ( di_pid, di_version );
CREATE INDEX idx_deal_invoice_file__pid_version ON staging_octane.deal_invoice_file ( dif_pid, dif_version );
CREATE INDEX idx_deal_invoice_item__pid_version ON staging_octane.deal_invoice_item ( dii_pid, dii_version );
CREATE INDEX idx_deal_invoice_payment_method__pid_version ON staging_octane.deal_invoice_payment_method ( dipm_pid, dipm_version );
CREATE INDEX idx_deal_key_roles__pid_version ON staging_octane.deal_key_roles ( dkrs_pid, dkrs_version );
CREATE INDEX idx_deal_lender_user__pid_version ON staging_octane.deal_lender_user ( dlu_pid, dlu_version );
CREATE INDEX idx_deal_lender_user_event__pid_version ON staging_octane.deal_lender_user_event ( dlue_pid, dlue_version );
CREATE INDEX idx_deal_lp__pid_version ON staging_octane.deal_lp ( dlp_pid, dlp_version );
CREATE INDEX idx_deal_message_log__pid_version ON staging_octane.deal_message_log ( dmlog_pid, dmlog_version );
CREATE INDEX idx_deal_note__pid_version ON staging_octane.deal_note ( dn_pid, dn_version );
CREATE INDEX idx_deal_note_comment__pid_version ON staging_octane.deal_note_comment ( dnc_pid, dnc_version );
CREATE INDEX idx_deal_note_monitor__pid_version ON staging_octane.deal_note_monitor ( dnm_pid, dnm_version );
CREATE INDEX idx_deal_note_role_tag__pid_version ON staging_octane.deal_note_role_tag ( dnrt_pid, dnrt_version );
CREATE INDEX idx_deal_performer_team__pid_version ON staging_octane.deal_performer_team ( dptm_pid, dptm_version );
CREATE INDEX idx_deal_performer_team_user__pid_version ON staging_octane.deal_performer_team_user ( dptu_pid, dptu_version );
CREATE INDEX idx_deal_real_estate_agent__pid_version ON staging_octane.deal_real_estate_agent ( drea_pid, drea_version );
CREATE INDEX idx_deal_sap__pid_version ON staging_octane.deal_sap ( dsap_pid, dsap_version );
CREATE INDEX idx_deal_settlement__pid_version ON staging_octane.deal_settlement ( dsmt_pid, dsmt_version );
CREATE INDEX idx_deal_signer__pid_version ON staging_octane.deal_signer ( dsi_pid, dsi_version );
CREATE INDEX idx_deal_snapshot__pid_version ON staging_octane.deal_snapshot ( desn_pid, desn_version );
CREATE INDEX idx_deal_stage__pid_version ON staging_octane.deal_stage ( dst_pid, dst_version );
CREATE INDEX idx_deal_summary__pid_version ON staging_octane.deal_summary ( ds_pid, ds_version );
CREATE INDEX idx_deal_system_file__pid_version ON staging_octane.deal_system_file ( dsf_pid, dsf_version );
CREATE INDEX idx_deal_tag__pid_version ON staging_octane.deal_tag ( dtg_pid, dtg_version );
CREATE INDEX idx_deal_tag_definition__pid_version ON staging_octane.deal_tag_definition ( dtd_pid, dtd_version );
CREATE INDEX idx_deal_task__pid_version ON staging_octane.deal_task ( dt_pid, dt_version );
CREATE INDEX idx_disaster_declaration__pid_version ON staging_octane.disaster_declaration ( dd_pid, dd_version );
CREATE INDEX idx_docusign_package__pid_version ON staging_octane.docusign_package ( dcsp_pid, dcsp_version );
CREATE INDEX idx_du_key_finding__pid_version ON staging_octane.du_key_finding ( dukf_pid, dukf_version );
CREATE INDEX idx_du_refi_plus_finding__pid_version ON staging_octane.du_refi_plus_finding ( durpf_pid, durpf_version );
CREATE INDEX idx_du_request__pid_version ON staging_octane.du_request ( dur_pid, dur_version );
CREATE INDEX idx_du_request_credit__pid_version ON staging_octane.du_request_credit ( durc_pid, durc_version );
CREATE INDEX idx_du_special_feature_code__pid_version ON staging_octane.du_special_feature_code ( dusfc_pid, dusfc_version );
CREATE INDEX idx_dw_export_request__pid_version ON staging_octane.dw_export_request ( dwer_pid, dwer_version );
CREATE INDEX idx_ernst_request__pid_version ON staging_octane.ernst_request ( enst_pid, enst_version );
CREATE INDEX idx_ernst_request_question__pid_version ON staging_octane.ernst_request_question ( enstq_pid, enstq_version );
CREATE INDEX idx_exclusive_assignment__pid_version ON staging_octane.exclusive_assignment ( ea_pid, ea_version );
CREATE INDEX idx_flood_cert__pid_version ON staging_octane.flood_cert ( fc_pid, fc_version );
CREATE INDEX idx_formula_report_column__pid_version ON staging_octane.formula_report_column ( frc_pid, frc_version );
CREATE INDEX idx_google_sheet_export__pid_version ON staging_octane.google_sheet_export ( gse_pid, gse_version );
CREATE INDEX idx_hmda_report_request__pid_version ON staging_octane.hmda_report_request ( hrr_pid, hrr_version );
CREATE INDEX idx_hoepa_thresholds__pid_version ON staging_octane.hoepa_thresholds ( ht_pid, ht_version );
CREATE INDEX idx_interim_funder__pid_version ON staging_octane.interim_funder ( if_pid, if_version );
CREATE INDEX idx_investor__pid_version ON staging_octane.investor ( i_pid, i_version );
CREATE INDEX idx_investor_group__pid_version ON staging_octane.investor_group ( ig_pid, ig_version );
CREATE INDEX idx_investor_lock__pid_version ON staging_octane.investor_lock ( il_pid, il_version );
CREATE INDEX idx_investor_lock_add_on__pid_version ON staging_octane.investor_lock_add_on ( ila_pid, ila_version );
CREATE INDEX idx_investor_lock_extension__pid_version ON staging_octane.investor_lock_extension ( ile_pid, ile_version );
CREATE INDEX idx_investor_lock_extension_setting__pid_version ON staging_octane.investor_lock_extension_setting ( iles_pid, iles_version );
CREATE INDEX idx_job_income__pid_version ON staging_octane.job_income ( ji_pid, ji_version );
CREATE INDEX idx_key_package__pid_version ON staging_octane.key_package ( kp_pid, kp_version );
CREATE INDEX idx_key_role__pid_version ON staging_octane.key_role ( kr_pid, kr_version );
CREATE INDEX idx_lead__pid_version ON staging_octane.lead ( ld_pid, ld_version );
CREATE INDEX idx_lead_campaign__pid_version ON staging_octane.lead_campaign ( ldc_pid, ldc_version );
CREATE INDEX idx_lead_source__pid_version ON staging_octane.lead_source ( lds_pid, lds_version );
CREATE INDEX idx_lead_supplemental_margin_row__pid_version ON staging_octane.lead_supplemental_margin_row ( lsmr_pid, lsmr_version );
CREATE INDEX idx_lead_supplemental_margin_table__pid_version ON staging_octane.lead_supplemental_margin_table ( lsmt_pid, lsmt_version );
CREATE INDEX idx_lender_concession_request__pid_version ON staging_octane.lender_concession_request ( lcr_pid, lcr_version );
CREATE INDEX idx_lender_lock_add_on__pid_version ON staging_octane.lender_lock_add_on ( lla_pid, lla_version );
CREATE INDEX idx_lender_lock_extension__pid_version ON staging_octane.lender_lock_extension ( lle_pid, lle_version );
CREATE INDEX idx_lender_lock_id_ticker__pid_version ON staging_octane.lender_lock_id_ticker ( lltk_pid, lltk_version );
CREATE INDEX idx_lender_lock_major__pid_version ON staging_octane.lender_lock_major ( llmj_pid, llmj_version );
CREATE INDEX idx_lender_lock_minor__pid_version ON staging_octane.lender_lock_minor ( llmn_pid, llmn_version );
CREATE INDEX idx_lender_settings__pid_version ON staging_octane.lender_settings ( lss_pid, lss_version );
CREATE INDEX idx_lender_trade_id_ticker__pid_version ON staging_octane.lender_trade_id_ticker ( lttk_pid, lttk_version );
CREATE INDEX idx_lender_user__pid_version ON staging_octane.lender_user ( lu_pid, lu_version );
CREATE INDEX idx_lender_user_allowed_ip__pid_version ON staging_octane.lender_user_allowed_ip ( luip_pid, luip_version );
CREATE INDEX idx_lender_user_deal_visit__pid_version ON staging_octane.lender_user_deal_visit ( ludv_pid, ludv_version );
CREATE INDEX idx_lender_user_interest__pid_version ON staging_octane.lender_user_interest ( lui_pid, lui_version );
CREATE INDEX idx_lender_user_language__pid_version ON staging_octane.lender_user_language ( lul_pid, lul_version );
CREATE INDEX idx_lender_user_lead_source__pid_version ON staging_octane.lender_user_lead_source ( lulds_pid, lulds_version );
CREATE INDEX idx_lender_user_license__pid_version ON staging_octane.lender_user_license ( luml_pid, luml_version );
CREATE INDEX idx_lender_user_notice__pid_version ON staging_octane.lender_user_notice ( lun_pid, lun_version );
CREATE INDEX idx_lender_user_photo__pid_version ON staging_octane.lender_user_photo ( lup_pid, lup_version );
CREATE INDEX idx_lender_user_role__pid_version ON staging_octane.lender_user_role ( lur_pid, lur_version );
CREATE INDEX idx_lender_user_role_addendum__pid_version ON staging_octane.lender_user_role_addendum ( lura_pid, lura_version );
CREATE INDEX idx_lender_user_sign_on__pid_version ON staging_octane.lender_user_sign_on ( luso_pid, luso_version );
CREATE INDEX idx_lender_user_unavailable__pid_version ON staging_octane.lender_user_unavailable ( luu_pid, luu_version );
CREATE INDEX idx_liability__pid_version ON staging_octane.liability ( lia_pid, lia_version );
CREATE INDEX idx_license_req__pid_version ON staging_octane.license_req ( mlr_pid, mlr_version );
CREATE INDEX idx_loan__pid_version ON staging_octane.loan ( l_pid, l_version );
CREATE INDEX idx_loan_beneficiary__pid_version ON staging_octane.loan_beneficiary ( lb_pid, lb_version );
CREATE INDEX idx_loan_charge__pid_version ON staging_octane.loan_charge ( lc_pid, lc_version );
CREATE INDEX idx_loan_closing_doc__pid_version ON staging_octane.loan_closing_doc ( lcd_pid, lcd_version );
CREATE INDEX idx_loan_eligible_investor__pid_version ON staging_octane.loan_eligible_investor ( lei_pid, lei_version );
CREATE INDEX idx_loan_funding__pid_version ON staging_octane.loan_funding ( lf_pid, lf_version );
CREATE INDEX idx_loan_hedge__pid_version ON staging_octane.loan_hedge ( lh_pid, lh_version );
CREATE INDEX idx_loan_limit_row__pid_version ON staging_octane.loan_limit_row ( llr_pid, llr_version );
CREATE INDEX idx_loan_limit_table__pid_version ON staging_octane.loan_limit_table ( llt_pid, llt_version );
CREATE INDEX idx_loan_mi_rate_adjustment__pid_version ON staging_octane.loan_mi_rate_adjustment ( lmra_pid, lmra_version );
CREATE INDEX idx_loan_mi_surcharge__pid_version ON staging_octane.loan_mi_surcharge ( lms_pid, lms_version );
CREATE INDEX idx_loan_price_add_on__pid_version ON staging_octane.loan_price_add_on ( lpa_pid, lpa_version );
CREATE INDEX idx_loan_recording__pid_version ON staging_octane.loan_recording ( lr_pid, lr_version );
CREATE INDEX idx_loan_servicer__pid_version ON staging_octane.loan_servicer ( lsv_pid, lsv_version );
CREATE INDEX idx_lock_series__pid_version ON staging_octane.lock_series ( lsr_pid, lsr_version );
CREATE INDEX idx_lock_term_setting__pid_version ON staging_octane.lock_term_setting ( lts_pid, lts_version );
CREATE INDEX idx_los_loan_id_ticker__pid_version ON staging_octane.los_loan_id_ticker ( ltk_pid, ltk_version );
CREATE INDEX idx_lp_finding__pid_version ON staging_octane.lp_finding ( lpf_pid, lpf_version );
CREATE INDEX idx_lp_request__pid_version ON staging_octane.lp_request ( lpr_pid, lpr_version );
CREATE INDEX idx_lp_request_credit__pid_version ON staging_octane.lp_request_credit ( lprc_pid, lprc_version );
CREATE INDEX idx_master_property_insurance__pid_version ON staging_octane.master_property_insurance ( mpi_pid, mpi_version );
CREATE INDEX idx_mcr_loan__pid_version ON staging_octane.mcr_loan ( mcrl_pid, mcrl_version );
CREATE INDEX idx_mcr_snapshot__pid_version ON staging_octane.mcr_snapshot ( mcrs_pid, mcrs_version );
CREATE INDEX idx_mercury_client_group__pid_version ON staging_octane.mercury_client_group ( mcg_pid, mcg_version );
CREATE INDEX idx_mercury_network_status_request__pid_version ON staging_octane.mercury_network_status_request ( mnsr_pid, mnsr_version );
CREATE INDEX idx_mers_daily_report__pid_version ON staging_octane.mers_daily_report ( medr_pid, medr_version );
CREATE INDEX idx_mers_transfer_batch__pid_version ON staging_octane.mers_transfer_batch ( metb_pid, metb_version );
CREATE INDEX idx_mi_integration_vendor_request__pid_version ON staging_octane.mi_integration_vendor_request ( mivr_pid, mivr_version );
CREATE INDEX idx_military_service__pid_version ON staging_octane.military_service ( ms_pid, ms_version );
CREATE INDEX idx_minimum_required_residual_income_row__pid_version ON staging_octane.minimum_required_residual_income_row ( mrir_pid, mrir_version );
CREATE INDEX idx_minimum_required_residual_income_table__pid_version ON staging_octane.minimum_required_residual_income_table ( mrit_pid, mrit_version );
CREATE INDEX idx_mortech_account__pid_version ON staging_octane.mortech_account ( ma_pid, ma_version );
CREATE INDEX idx_mortgage_credit_certificate_issuer__pid_version ON staging_octane.mortgage_credit_certificate_issuer ( mcci_pid, mcci_version );
CREATE INDEX idx_net_tangible_benefit__pid_version ON staging_octane.net_tangible_benefit ( ntb_pid, ntb_version );
CREATE INDEX idx_new_lock_only_add_on__pid_version ON staging_octane.new_lock_only_add_on ( nlo_pid, nlo_version );
CREATE INDEX idx_obligation__pid_version ON staging_octane.obligation ( ob_pid, ob_version );
CREATE INDEX idx_offering__pid_version ON staging_octane.offering ( of_pid, of_version );
CREATE INDEX idx_offering_group__pid_version ON staging_octane.offering_group ( ofg_pid, ofg_version );
CREATE INDEX idx_offering_product__pid_version ON staging_octane.offering_product ( ofp_pid, ofp_version );
CREATE INDEX idx_org_division__pid_version ON staging_octane.org_division ( orgd_pid, orgd_version );
CREATE INDEX idx_org_division_leader__pid_version ON staging_octane.org_division_leader ( orgdl_pid, orgdl_version );
CREATE INDEX idx_org_division_terms__pid_version ON staging_octane.org_division_terms ( orgdt_pid, orgdt_version );
CREATE INDEX idx_org_group__pid_version ON staging_octane.org_group ( orgg_pid, orgg_version );
CREATE INDEX idx_org_group_leader__pid_version ON staging_octane.org_group_leader ( orggl_pid, orggl_version );
CREATE INDEX idx_org_group_terms__pid_version ON staging_octane.org_group_terms ( orggt_pid, orggt_version );
CREATE INDEX idx_org_lender_user_terms__pid_version ON staging_octane.org_lender_user_terms ( orglut_pid, orglut_version );
CREATE INDEX idx_org_region__pid_version ON staging_octane.org_region ( orgr_pid, orgr_version );
CREATE INDEX idx_org_region_leader__pid_version ON staging_octane.org_region_leader ( orgrl_pid, orgrl_version );
CREATE INDEX idx_org_region_terms__pid_version ON staging_octane.org_region_terms ( orgrt_pid, orgrt_version );
CREATE INDEX idx_org_team__pid_version ON staging_octane.org_team ( orgt_pid, orgt_version );
CREATE INDEX idx_org_team_leader__pid_version ON staging_octane.org_team_leader ( orgtl_pid, orgtl_version );
CREATE INDEX idx_org_team_terms__pid_version ON staging_octane.org_team_terms ( orgtt_pid, orgtt_version );
CREATE INDEX idx_org_unit__pid_version ON staging_octane.org_unit ( orgu_pid, orgu_version );
CREATE INDEX idx_org_unit_leader__pid_version ON staging_octane.org_unit_leader ( orgul_pid, orgul_version );
CREATE INDEX idx_org_unit_terms__pid_version ON staging_octane.org_unit_terms ( orgut_pid, orgut_version );
CREATE INDEX idx_other_income__pid_version ON staging_octane.other_income ( oi_pid, oi_version );
CREATE INDEX idx_performer_assignment__pid_version ON staging_octane.performer_assignment ( pa_pid, pa_version );
CREATE INDEX idx_performer_team__pid_version ON staging_octane.performer_team ( ptm_pid, ptm_version );
CREATE INDEX idx_place__pid_version ON staging_octane.place ( pl_pid, pl_version );
CREATE INDEX idx_preferred_settlement__pid_version ON staging_octane.preferred_settlement ( prs_pid, prs_version );
CREATE INDEX idx_price_processing_time__pid_version ON staging_octane.price_processing_time ( ppt_pid, ppt_version );
CREATE INDEX idx_product__pid_version ON staging_octane.product ( p_pid, p_version );
CREATE INDEX idx_product_add_on__pid_version ON staging_octane.product_add_on ( pao_pid, pao_version );
CREATE INDEX idx_product_add_on_rule__pid_version ON staging_octane.product_add_on_rule ( par_pid, par_version );
CREATE INDEX idx_product_branch__pid_version ON staging_octane.product_branch ( pbr_pid, pbr_version );
CREATE INDEX idx_product_buydown__pid_version ON staging_octane.product_buydown ( pbd_pid, pbd_version );
CREATE INDEX idx_product_deal_check_exclusion__pid_version ON staging_octane.product_deal_check_exclusion ( pdce_pid, pdce_version );
CREATE INDEX idx_product_eligibility__pid_version ON staging_octane.product_eligibility ( pe_pid, pe_version );
CREATE INDEX idx_product_eligibility_rule__pid_version ON staging_octane.product_eligibility_rule ( per_pid, per_version );
CREATE INDEX idx_product_interest_only__pid_version ON staging_octane.product_interest_only ( pio_pid, pio_version );
CREATE INDEX idx_product_lock_term__pid_version ON staging_octane.product_lock_term ( plt_pid, plt_version );
CREATE INDEX idx_product_maximum_investor_price__pid_version ON staging_octane.product_maximum_investor_price ( pmip_pid, pmip_version );
CREATE INDEX idx_product_maximum_rebate__pid_version ON staging_octane.product_maximum_rebate ( pmr_pid, pmr_version );
CREATE INDEX idx_product_minimum_investor_price__pid_version ON staging_octane.product_minimum_investor_price ( pminip_pid, pminip_version );
CREATE INDEX idx_product_originator__pid_version ON staging_octane.product_originator ( po_pid, po_version );
CREATE INDEX idx_product_prepay_penalty__pid_version ON staging_octane.product_prepay_penalty ( ppp_pid, ppp_version );
CREATE INDEX idx_product_terms__pid_version ON staging_octane.product_terms ( pt_pid, pt_version );
CREATE INDEX idx_product_third_party_community_second_program__pid_version ON staging_octane.product_third_party_community_second_program ( ptpp_pid, ptpp_version );
CREATE INDEX idx_profit_margin_detail__pid_version ON staging_octane.profit_margin_detail ( pmd_pid, pmd_version );
CREATE INDEX idx_proposal__pid_version ON staging_octane.proposal ( prp_pid, prp_version );
CREATE INDEX idx_proposal_contractor__pid_version ON staging_octane.proposal_contractor ( pctr_pid, pctr_version );
CREATE INDEX idx_proposal_doc__pid_version ON staging_octane.proposal_doc ( prpd_pid, prpd_version );
CREATE INDEX idx_proposal_doc_borrower_access__pid_version ON staging_octane.proposal_doc_borrower_access ( pdba_pid, pdba_version );
CREATE INDEX idx_proposal_doc_file__pid_version ON staging_octane.proposal_doc_file ( prpdf_pid, prpdf_version );
CREATE INDEX idx_proposal_doc_set__pid_version ON staging_octane.proposal_doc_set ( prpds_pid, prpds_version );
CREATE INDEX idx_proposal_doc_set_id_ticker__pid_version ON staging_octane.proposal_doc_set_id_ticker ( pdstk_pid, pdstk_version );
CREATE INDEX idx_proposal_doc_set_signer__pid_version ON staging_octane.proposal_doc_set_signer ( prpdss_pid, prpdss_version );
CREATE INDEX idx_proposal_doc_set_snapshot__pid_version ON staging_octane.proposal_doc_set_snapshot ( prpdssn_pid, prpdssn_version );
CREATE INDEX idx_proposal_engagement__pid_version ON staging_octane.proposal_engagement ( prpe_pid, prpe_version );
CREATE INDEX idx_proposal_grant_program__pid_version ON staging_octane.proposal_grant_program ( pgp_pid, pgp_version );
CREATE INDEX idx_proposal_req__pid_version ON staging_octane.proposal_req ( prpr_pid, prpr_version );
CREATE INDEX idx_proposal_review__pid_version ON staging_octane.proposal_review ( prpre_pid, prpre_version );
CREATE INDEX idx_proposal_review_ticker__pid_version ON staging_octane.proposal_review_ticker ( prpret_pid, prpret_version );
CREATE INDEX idx_proposal_summary__pid_version ON staging_octane.proposal_summary ( ps_pid, ps_version );
CREATE INDEX idx_pte_request__pid_version ON staging_octane.pte_request ( pter_pid, pter_version );
CREATE INDEX idx_public_record__pid_version ON staging_octane.public_record ( pr_pid, pr_version );
CREATE INDEX idx_qualified_mortgage_thresholds__pid_version ON staging_octane.qualified_mortgage_thresholds ( qmt_pid, qmt_version );
CREATE INDEX idx_rate_sheet__pid_version ON staging_octane.rate_sheet ( rs_pid, rs_version );
CREATE INDEX idx_rate_sheet_price__pid_version ON staging_octane.rate_sheet_price ( rsp_pid, rsp_version );
CREATE INDEX idx_rate_sheet_rate__pid_version ON staging_octane.rate_sheet_rate ( rsr_pid, rsr_version );
CREATE INDEX idx_recording_city__pid_version ON staging_octane.recording_city ( rc_pid, rc_version );
CREATE INDEX idx_recording_district__pid_version ON staging_octane.recording_district ( rdi_pid, rdi_version );
CREATE INDEX idx_region_ernst_page_rec__pid_version ON staging_octane.region_ernst_page_rec ( rerc_pid, rerc_version );
CREATE INDEX idx_relock_fee_setting__pid_version ON staging_octane.relock_fee_setting ( rfs_pid, rfs_version );
CREATE INDEX idx_rental_income__pid_version ON staging_octane.rental_income ( ri_pid, ri_version );
CREATE INDEX idx_report__pid_version ON staging_octane.report ( rp_pid, rp_version );
CREATE INDEX idx_report_column__pid_version ON staging_octane.report_column ( rpc_pid, rpc_version );
CREATE INDEX idx_report_row__pid_version ON staging_octane.report_row ( rprw_pid, rprw_version );
CREATE INDEX idx_repository_file__pid_version ON staging_octane.repository_file ( rf_pid, rf_version );
CREATE INDEX idx_role__pid_version ON staging_octane.role ( r_pid, r_version );
CREATE INDEX idx_role_charge_permissions__pid_version ON staging_octane.role_charge_permissions ( rcp_pid, rcp_version );
CREATE INDEX idx_role_config_export_permission__pid_version ON staging_octane.role_config_export_permission ( rcep_pid, rcep_version );
CREATE INDEX idx_role_deal_context__pid_version ON staging_octane.role_deal_context ( rdc_pid, rdc_version );
CREATE INDEX idx_role_export_permission__pid_version ON staging_octane.role_export_permission ( rep_pid, rep_version );
CREATE INDEX idx_role_lender_toolbox__pid_version ON staging_octane.role_lender_toolbox ( rlet_pid, rlet_version );
CREATE INDEX idx_role_loans_toolbox__pid_version ON staging_octane.role_loans_toolbox ( rlot_pid, rlot_version );
CREATE INDEX idx_role_performer_assign__pid_version ON staging_octane.role_performer_assign ( rpa_pid, rpa_version );
CREATE INDEX idx_role_report__pid_version ON staging_octane.role_report ( rrp_pid, rrp_version );
CREATE INDEX idx_sap_deal_step__pid_version ON staging_octane.sap_deal_step ( sds_pid, sds_version );
CREATE INDEX idx_sap_quote_request__pid_version ON staging_octane.sap_quote_request ( sqr_pid, sqr_version );
CREATE INDEX idx_secondary_admin_event__pid_version ON staging_octane.secondary_admin_event ( sae_pid, sae_version );
CREATE INDEX idx_secondary_settings__pid_version ON staging_octane.secondary_settings ( sset_pid, sset_version );
CREATE INDEX idx_servicer_loan_id_assignment__pid_version ON staging_octane.servicer_loan_id_assignment ( slia_pid, slia_version );
CREATE INDEX idx_servicer_loan_id_import_request__pid_version ON staging_octane.servicer_loan_id_import_request ( slir_pid, slir_version );
CREATE INDEX idx_settlement_agent__pid_version ON staging_octane.settlement_agent ( sa_pid, sa_version );
CREATE INDEX idx_settlement_agent_office__pid_version ON staging_octane.settlement_agent_office ( sao_pid, sao_version );
CREATE INDEX idx_settlement_agent_wire__pid_version ON staging_octane.settlement_agent_wire ( saw_pid, saw_version );
CREATE INDEX idx_site_allowed_ip__pid_version ON staging_octane.site_allowed_ip ( saip_pid, saip_version );
CREATE INDEX idx_smart_charge__pid_version ON staging_octane.smart_charge ( sc_pid, sc_version );
CREATE INDEX idx_smart_charge_case__pid_version ON staging_octane.smart_charge_case ( scc_pid, scc_version );
CREATE INDEX idx_smart_charge_group__pid_version ON staging_octane.smart_charge_group ( scg_pid, scg_version );
CREATE INDEX idx_smart_charge_group_case__pid_version ON staging_octane.smart_charge_group_case ( scgc_pid, scgc_version );
CREATE INDEX idx_smart_doc__pid_version ON staging_octane.smart_doc ( sd_pid, sd_version );
CREATE INDEX idx_smart_doc_criteria__pid_version ON staging_octane.smart_doc_criteria ( sdc_pid, sdc_version );
CREATE INDEX idx_smart_doc_note__pid_version ON staging_octane.smart_doc_note ( sdn_pid, sdn_version );
CREATE INDEX idx_smart_doc_note_comment__pid_version ON staging_octane.smart_doc_note_comment ( sdnc_pid, sdnc_version );
CREATE INDEX idx_smart_doc_note_monitor__pid_version ON staging_octane.smart_doc_note_monitor ( sdnm_pid, sdnm_version );
CREATE INDEX idx_smart_doc_role__pid_version ON staging_octane.smart_doc_role ( sdr_pid, sdr_version );
CREATE INDEX idx_smart_doc_set__pid_version ON staging_octane.smart_doc_set ( sdst_pid, sdst_version );
CREATE INDEX idx_smart_message__pid_version ON staging_octane.smart_message ( smsg_pid, smsg_version );
CREATE INDEX idx_smart_message_recipient__pid_version ON staging_octane.smart_message_recipient ( smr_pid, smr_version );
CREATE INDEX idx_smart_mi__pid_version ON staging_octane.smart_mi ( sm_pid, sm_version );
CREATE INDEX idx_smart_mi_eligibility_case__pid_version ON staging_octane.smart_mi_eligibility_case ( smec_pid, smec_version );
CREATE INDEX idx_smart_mi_rate_adjustment_case__pid_version ON staging_octane.smart_mi_rate_adjustment_case ( smrac_pid, smrac_version );
CREATE INDEX idx_smart_mi_rate_card__pid_version ON staging_octane.smart_mi_rate_card ( smrca_pid, smrca_version );
CREATE INDEX idx_smart_mi_rate_case__pid_version ON staging_octane.smart_mi_rate_case ( smrc_pid, smrc_version );
CREATE INDEX idx_smart_mi_surcharge__pid_version ON staging_octane.smart_mi_surcharge ( sms_pid, sms_version );
CREATE INDEX idx_smart_mi_surcharge_case__pid_version ON staging_octane.smart_mi_surcharge_case ( smsc_pid, smsc_version );
CREATE INDEX idx_smart_req__pid_version ON staging_octane.smart_req ( sr_pid, sr_version );
CREATE INDEX idx_smart_separator__pid_version ON staging_octane.smart_separator ( ssp_pid, ssp_version );
CREATE INDEX idx_smart_set_doc__pid_version ON staging_octane.smart_set_doc ( sstd_pid, sstd_version );
CREATE INDEX idx_smart_stack__pid_version ON staging_octane.smart_stack ( ss_pid, ss_version );
CREATE INDEX idx_smart_stack_doc__pid_version ON staging_octane.smart_stack_doc ( ssd_pid, ssd_version );
CREATE INDEX idx_smart_task__pid_version ON staging_octane.smart_task ( st_pid, st_version );
CREATE INDEX idx_smart_task_tag_modifier__pid_version ON staging_octane.smart_task_tag_modifier ( sttm_pid, sttm_version );
CREATE INDEX idx_stack_export_file__pid_version ON staging_octane.stack_export_file ( sef_pid, sef_version );
CREATE INDEX idx_stack_export_request__pid_version ON staging_octane.stack_export_request ( ser_pid, ser_version );
CREATE INDEX idx_stripe_payment__pid_version ON staging_octane.stripe_payment ( stpm_pid, stpm_version );
CREATE INDEX idx_tax_transcript_request__pid_version ON staging_octane.tax_transcript_request ( ttr_pid, ttr_version );
CREATE INDEX idx_third_party_community_second_program__pid_version ON staging_octane.third_party_community_second_program ( tpcsp_pid, tpcsp_version );
CREATE INDEX idx_title_company__pid_version ON staging_octane.title_company ( tc_pid, tc_version );
CREATE INDEX idx_title_company_office__pid_version ON staging_octane.title_company_office ( tco_pid, tco_version );
CREATE INDEX idx_trade__pid_version ON staging_octane.trade ( t_pid, t_version );
CREATE INDEX idx_trade_audit__pid_version ON staging_octane.trade_audit ( ta_pid, ta_version );
CREATE INDEX idx_trade_fee__pid_version ON staging_octane.trade_fee ( tfe_pid, tfe_version );
CREATE INDEX idx_trade_fee_type__pid_version ON staging_octane.trade_fee_type ( tft_pid, tft_version );
CREATE INDEX idx_trade_file__pid_version ON staging_octane.trade_file ( tf_pid, tf_version );
CREATE INDEX idx_trade_lock_filter__pid_version ON staging_octane.trade_lock_filter ( tlf_pid, tlf_version );
CREATE INDEX idx_trade_note__pid_version ON staging_octane.trade_note ( tn_pid, tn_version );
CREATE INDEX idx_trade_note_comment__pid_version ON staging_octane.trade_note_comment ( tnc_pid, tnc_version );
CREATE INDEX idx_trade_note_monitor__pid_version ON staging_octane.trade_note_monitor ( tnm_pid, tnm_version );
CREATE INDEX idx_trade_product__pid_version ON staging_octane.trade_product ( tp_pid, tp_version );
CREATE INDEX idx_trustee__pid_version ON staging_octane.trustee ( tru_pid, tru_version );
CREATE INDEX idx_unpaid_balance_adjustment__pid_version ON staging_octane.unpaid_balance_adjustment ( upba_pid, upba_version );
CREATE INDEX idx_vendor_document_event__pid_version ON staging_octane.vendor_document_event ( vde_pid, vde_version );
CREATE INDEX idx_vendor_document_repository_file__pid_version ON staging_octane.vendor_document_repository_file ( vdrf_pid, vdrf_version );
CREATE INDEX idx_view_wf_deal_step_started__pid_version ON staging_octane.view_wf_deal_step_started ( wds_pid, wds_version );
CREATE INDEX idx_wf_deal_fork_process__pid_version ON staging_octane.wf_deal_fork_process ( wdfp_pid, wdfp_version );
CREATE INDEX idx_wf_deal_function_queue__pid_version ON staging_octane.wf_deal_function_queue ( wdfq_pid, wdfq_version );
CREATE INDEX idx_wf_deal_outcome__pid_version ON staging_octane.wf_deal_outcome ( wdo_pid, wdo_version );
CREATE INDEX idx_wf_deal_process__pid_version ON staging_octane.wf_deal_process ( wdpr_pid, wdpr_version );
CREATE INDEX idx_wf_deal_step__pid_version ON staging_octane.wf_deal_step ( wds_pid, wds_version );
CREATE INDEX idx_wf_deal_step_timeout__pid_version ON staging_octane.wf_deal_step_timeout ( wdst_pid, wdst_version );
CREATE INDEX idx_wf_fork_process__pid_version ON staging_octane.wf_fork_process ( wfp_pid, wfp_version );
CREATE INDEX idx_wf_outcome__pid_version ON staging_octane.wf_outcome ( wo_pid, wo_version );
CREATE INDEX idx_wf_phase__pid_version ON staging_octane.wf_phase ( wph_pid, wph_version );
CREATE INDEX idx_wf_process__pid_version ON staging_octane.wf_process ( wpr_pid, wpr_version );
CREATE INDEX idx_wf_step__pid_version ON staging_octane.wf_step ( ws_pid, ws_version );
CREATE INDEX idx_wf_step_deal_check__pid_version ON staging_octane.wf_step_deal_check ( wsdc_pid, wsdc_version );
CREATE INDEX idx_wf_step_deal_check_definition__pid_version ON staging_octane.wf_step_deal_check_definition ( wsdd_pid, wsdd_version );
CREATE INDEX idx_wf_step_deal_check_dependency__pid_version ON staging_octane.wf_step_deal_check_dependency ( wsdp_pid, wsdp_version );
CREATE INDEX idx_wf_step_deal_tag_modifier__pid_version ON staging_octane.wf_step_deal_tag_modifier ( wsdt_pid, wsdt_version );
CREATE INDEX idx_wf_wait_until_time_slice__pid_version ON staging_octane.wf_wait_until_time_slice ( wts_pid, wts_version );

DROP INDEX staging_octane.idx_account_event_1;
DROP INDEX staging_octane.idx_account_event_2;
DROP INDEX staging_octane.idx_arm_index_rate_1;
DROP INDEX staging_octane.idx_arm_index_rate_2;
DROP INDEX staging_octane.idx_company_admin_event_1;
DROP INDEX staging_octane.idx_deal_change_updater_time_1;
DROP INDEX staging_octane.idx_deal_change_updater_time_2;
DROP INDEX staging_octane.idx_apor_1;
DROP INDEX staging_octane.idx_price_processing_time_1;
DROP INDEX staging_octane.idx_price_processing_time_2;
DROP INDEX staging_octane.idx_secondary_admin_event_1;
DROP INDEX staging_octane.idx_site_allowed_ip_1;
DROP INDEX staging_octane.idx_county_1;
DROP INDEX staging_octane.idx_recording_district_1;
DROP INDEX staging_octane.idx_borrower_user_1;
DROP INDEX staging_octane.idx_wf_wait_until_time_slice_1;
DROP INDEX staging_octane.idx_account_1;
DROP INDEX staging_octane.idx_deal_1;
DROP INDEX staging_octane.idx_deal_2;
DROP INDEX staging_octane.idx_deal_4;
DROP INDEX staging_octane.idx_deal_5;
DROP INDEX staging_octane.idx_deal_6;
DROP INDEX staging_octane.idx_deal_event_1;
DROP INDEX staging_octane.idx_deal_event_2;
DROP INDEX staging_octane.idx_deal_event_3;
DROP INDEX staging_octane.idx_deal_event_4;
DROP INDEX staging_octane.idx_deal_event_5;
DROP INDEX staging_octane.idx_deal_event_6;
DROP INDEX staging_octane.idx_deal_event_7;
DROP INDEX staging_octane.idx_deal_event_8;
DROP INDEX staging_octane.idx_deal_event_9;
DROP INDEX staging_octane.idx_deal_lender_user_event_1;
DROP INDEX staging_octane.idx_deal_lender_user_event_2;
DROP INDEX staging_octane.idx_deal_settlement_1;
DROP INDEX staging_octane.idx_deal_signer_1;
DROP INDEX staging_octane.idx_deal_lender_user_1;
DROP INDEX staging_octane.idx_lender_user_allowed_ip_1;
DROP INDEX staging_octane.idx_lender_user_allowed_ip_2;
DROP INDEX staging_octane.idx_lender_user_allowed_ip_3;
DROP INDEX staging_octane.idx_borrower_1;
DROP INDEX staging_octane.idx_borrower_2;
DROP INDEX staging_octane.idx_borrower_3;
DROP INDEX staging_octane.idx_borrower_4;
DROP INDEX staging_octane.idx_borrower_5;
DROP INDEX staging_octane.idx_borrower_user_change_email_1;
DROP INDEX staging_octane.idx_borrower_user_change_email_2;
DROP INDEX staging_octane.idx_borrower_user_deal_1;
DROP INDEX staging_octane.idx_docusign_package_1;
DROP INDEX staging_octane.idx_circumstance_change_1;
DROP INDEX staging_octane.idx_loan_servicer_1;
DROP INDEX staging_octane.idx_lender_lock_major_1;
DROP INDEX staging_octane.idx_place_1;
DROP INDEX staging_octane.idx_profit_margin_detail_1;
DROP INDEX staging_octane.idx_proposal_1;
DROP INDEX staging_octane.idx_proposal_summary_1;
DROP INDEX staging_octane.idx_proposal_summary_2;
DROP INDEX staging_octane.idx_proposal_summary_3;
DROP INDEX staging_octane.idx_proposal_summary_4;
DROP INDEX staging_octane.idx_proposal_summary_5;
DROP INDEX staging_octane.idx_proposal_summary_6;
DROP INDEX staging_octane.idx_proposal_summary_7;
DROP INDEX staging_octane.idx_proposal_summary_8;
DROP INDEX staging_octane.idx_trade_1;
DROP INDEX staging_octane.idx_wf_deal_step_timeout_1;
DROP INDEX staging_octane.idx_fk_account_contact_1;
DROP INDEX staging_octane.idx_fkt_account_contact_2;
DROP INDEX staging_octane.idx_fk_account_event_1;
DROP INDEX staging_octane.idx_fkt_account_event_2;
DROP INDEX staging_octane.idx_fk_account_grant_program_1;
DROP INDEX staging_octane.idx_fkt_account_grant_program_2;
DROP INDEX staging_octane.idx_fkt_account_grant_program_3;
DROP INDEX staging_octane.idx_fkt_admin_user_1;
DROP INDEX staging_octane.idx_fkt_admin_user_2;
DROP INDEX staging_octane.idx_fkt_admin_user_event_1;
DROP INDEX staging_octane.idx_fkt_apor_1;
DROP INDEX staging_octane.idx_fk_application_1;
DROP INDEX staging_octane.idx_fkt_application_2;
DROP INDEX staging_octane.idx_fkt_application_3;
DROP INDEX staging_octane.idx_fkt_application_4;
DROP INDEX staging_octane.idx_fkt_application_5;
DROP INDEX staging_octane.idx_fkt_application_6;
DROP INDEX staging_octane.idx_fkt_application_7;
DROP INDEX staging_octane.idx_fkt_application_8;
DROP INDEX staging_octane.idx_fk_appraisal_1;
DROP INDEX staging_octane.idx_fk_appraisal_2;
DROP INDEX staging_octane.idx_fkt_appraisal_3;
DROP INDEX staging_octane.idx_fkt_appraisal_4;
DROP INDEX staging_octane.idx_fkt_appraisal_5;
DROP INDEX staging_octane.idx_fkt_appraisal_6;
DROP INDEX staging_octane.idx_fkt_appraisal_7;
DROP INDEX staging_octane.idx_fkt_appraisal_8;
DROP INDEX staging_octane.idx_fkt_appraisal_9;
DROP INDEX staging_octane.idx_fkt_appraisal_10;
DROP INDEX staging_octane.idx_fkt_appraisal_11;
DROP INDEX staging_octane.idx_fkt_appraisal_12;
DROP INDEX staging_octane.idx_fkt_appraisal_13;
DROP INDEX staging_octane.idx_fkt_appraisal_14;
DROP INDEX staging_octane.idx_fkt_appraisal_15;
DROP INDEX staging_octane.idx_fkt_appraisal_16;
DROP INDEX staging_octane.idx_fkt_appraisal_17;
DROP INDEX staging_octane.idx_fk_appraisal_file_1;
DROP INDEX staging_octane.idx_fk_appraisal_file_2;
DROP INDEX staging_octane.idx_fkt_appraisal_file_3;
DROP INDEX staging_octane.idx_fk_appraisal_form_1;
DROP INDEX staging_octane.idx_fkt_appraisal_form_2;
DROP INDEX staging_octane.idx_fkt_appraisal_form_3;
DROP INDEX staging_octane.idx_fk_appraisal_id_ticker_1;
DROP INDEX staging_octane.idx_fk_appraisal_order_request_1;
DROP INDEX staging_octane.idx_fk_appraisal_order_request_2;
DROP INDEX staging_octane.idx_fk_appraisal_order_request_3;
DROP INDEX staging_octane.idx_fk_appraisal_order_request_4;
DROP INDEX staging_octane.idx_fk_appraisal_order_request_5;
DROP INDEX staging_octane.idx_fk_appraisal_order_request_6;
DROP INDEX staging_octane.idx_fkt_appraisal_order_request_7;
DROP INDEX staging_octane.idx_fkt_appraisal_order_request_8;
DROP INDEX staging_octane.idx_fkt_appraisal_order_request_9;
DROP INDEX staging_octane.idx_fkt_appraisal_order_request_10;
DROP INDEX staging_octane.idx_fk_appraisal_order_request_file_1;
DROP INDEX staging_octane.idx_fk_appraisal_order_request_file_2;
DROP INDEX staging_octane.idx_fkt_appraisal_order_request_file_3;
DROP INDEX staging_octane.idx_fk_area_median_income_row_1;
DROP INDEX staging_octane.idx_fk_area_median_income_row_2;
DROP INDEX staging_octane.idx_fk_area_median_income_row_3;
DROP INDEX staging_octane.idx_fk_area_median_income_table_1;
DROP INDEX staging_octane.idx_fkt_arm_index_rate_1;
DROP INDEX staging_octane.idx_fk_asset_1;
DROP INDEX staging_octane.idx_fk_asset_2;
DROP INDEX staging_octane.idx_fk_asset_3;
DROP INDEX staging_octane.idx_fkt_asset_4;
DROP INDEX staging_octane.idx_fkt_asset_5;
DROP INDEX staging_octane.idx_fkt_asset_6;
DROP INDEX staging_octane.idx_fkt_asset_7;
DROP INDEX staging_octane.idx_fkt_asset_8;
DROP INDEX staging_octane.idx_fkt_asset_9;
DROP INDEX staging_octane.idx_fk_asset_large_deposit_1;
DROP INDEX staging_octane.idx_fk_aus_request_number_ticker_1;
DROP INDEX staging_octane.idx_fk_backfill_loan_status_1;
DROP INDEX staging_octane.idx_fkt_backfill_loan_status_2;
DROP INDEX staging_octane.idx_fk_backfill_status_1;
DROP INDEX staging_octane.idx_fk_backfill_status_2;
DROP INDEX staging_octane.idx_fkt_backfill_status_3;
DROP INDEX staging_octane.idx_fk_bid_pool_1;
DROP INDEX staging_octane.idx_fkt_bid_pool_2;
DROP INDEX staging_octane.idx_fk_bid_pool_file_1;
DROP INDEX staging_octane.idx_fk_bid_pool_file_2;
DROP INDEX staging_octane.idx_fk_bid_pool_lender_lock_1;
DROP INDEX staging_octane.idx_fk_bid_pool_lender_lock_2;
DROP INDEX staging_octane.idx_fk_bid_pool_note_1;
DROP INDEX staging_octane.idx_fk_bid_pool_note_2;
DROP INDEX staging_octane.idx_fk_bid_pool_note_comment_1;
DROP INDEX staging_octane.idx_fk_bid_pool_note_comment_2;
DROP INDEX staging_octane.idx_fk_bid_pool_note_monitor_1;
DROP INDEX staging_octane.idx_fk_bid_pool_note_monitor_2;
DROP INDEX staging_octane.idx_fk_borrower_1;
DROP INDEX staging_octane.idx_fk_borrower_2;
DROP INDEX staging_octane.idx_fk_borrower_3;
DROP INDEX staging_octane.idx_fk_borrower_4;
DROP INDEX staging_octane.idx_fkt_borrower_5;
DROP INDEX staging_octane.idx_fkt_borrower_6;
DROP INDEX staging_octane.idx_fkt_borrower_7;
DROP INDEX staging_octane.idx_fkt_borrower_8;
DROP INDEX staging_octane.idx_fkt_borrower_9;
DROP INDEX staging_octane.idx_fkt_borrower_10;
DROP INDEX staging_octane.idx_fkt_borrower_11;
DROP INDEX staging_octane.idx_fkt_borrower_12;
DROP INDEX staging_octane.idx_fkt_borrower_13;
DROP INDEX staging_octane.idx_fkt_borrower_14;
DROP INDEX staging_octane.idx_fkt_borrower_15;
DROP INDEX staging_octane.idx_fkt_borrower_16;
DROP INDEX staging_octane.idx_fkt_borrower_17;
DROP INDEX staging_octane.idx_fkt_borrower_18;
DROP INDEX staging_octane.idx_fkt_borrower_19;
DROP INDEX staging_octane.idx_fkt_borrower_20;
DROP INDEX staging_octane.idx_fkt_borrower_21;
DROP INDEX staging_octane.idx_fkt_borrower_22;
DROP INDEX staging_octane.idx_fkt_borrower_23;
DROP INDEX staging_octane.idx_fkt_borrower_24;
DROP INDEX staging_octane.idx_fkt_borrower_25;
DROP INDEX staging_octane.idx_fkt_borrower_26;
DROP INDEX staging_octane.idx_fkt_borrower_27;
DROP INDEX staging_octane.idx_fkt_borrower_28;
DROP INDEX staging_octane.idx_fkt_borrower_29;
DROP INDEX staging_octane.idx_fkt_borrower_30;
DROP INDEX staging_octane.idx_fkt_borrower_31;
DROP INDEX staging_octane.idx_fkt_borrower_32;
DROP INDEX staging_octane.idx_fkt_borrower_33;
DROP INDEX staging_octane.idx_fkt_borrower_34;
DROP INDEX staging_octane.idx_fkt_borrower_35;
DROP INDEX staging_octane.idx_fkt_borrower_36;
DROP INDEX staging_octane.idx_fkt_borrower_37;
DROP INDEX staging_octane.idx_fkt_borrower_38;
DROP INDEX staging_octane.idx_fkt_borrower_39;
DROP INDEX staging_octane.idx_fkt_borrower_40;
DROP INDEX staging_octane.idx_fkt_borrower_41;
DROP INDEX staging_octane.idx_fkt_borrower_42;
DROP INDEX staging_octane.idx_fkt_borrower_43;
DROP INDEX staging_octane.idx_fkt_borrower_44;
DROP INDEX staging_octane.idx_fkt_borrower_45;
DROP INDEX staging_octane.idx_fk_borrower_alias_1;
DROP INDEX staging_octane.idx_fk_borrower_alias_2;
DROP INDEX staging_octane.idx_fk_borrower_asset_1;
DROP INDEX staging_octane.idx_fk_borrower_asset_2;
DROP INDEX staging_octane.idx_fk_borrower_associated_address_1;
DROP INDEX staging_octane.idx_fk_borrower_associated_address_2;
DROP INDEX staging_octane.idx_fkt_borrower_associated_address_3;
DROP INDEX staging_octane.idx_fkt_borrower_associated_address_4;
DROP INDEX staging_octane.idx_fkt_borrower_associated_address_5;
DROP INDEX staging_octane.idx_fkt_borrower_associated_address_6;
DROP INDEX staging_octane.idx_fkt_borrower_associated_address_7;
DROP INDEX staging_octane.idx_fkt_borrower_associated_address_8;
DROP INDEX staging_octane.idx_fkt_borrower_associated_address_9;
DROP INDEX staging_octane.idx_fkt_borrower_associated_address_10;
DROP INDEX staging_octane.idx_fkt_borrower_associated_address_11;
DROP INDEX staging_octane.idx_fkt_borrower_associated_address_12;
DROP INDEX staging_octane.idx_fkt_borrower_associated_address_13;
DROP INDEX staging_octane.idx_fk_borrower_credit_inquiry_1;
DROP INDEX staging_octane.idx_fk_borrower_credit_inquiry_2;
DROP INDEX staging_octane.idx_fk_borrower_dependent_1;
DROP INDEX staging_octane.idx_fk_borrower_income_1;
DROP INDEX staging_octane.idx_fkt_borrower_income_2;
DROP INDEX staging_octane.idx_fkt_borrower_income_3;
DROP INDEX staging_octane.idx_fkt_borrower_income_4;
DROP INDEX staging_octane.idx_fkt_borrower_income_5;
DROP INDEX staging_octane.idx_fk_borrower_job_gap_1;
DROP INDEX staging_octane.idx_fk_borrower_liability_1;
DROP INDEX staging_octane.idx_fk_borrower_liability_2;
DROP INDEX staging_octane.idx_fk_borrower_public_record_1;
DROP INDEX staging_octane.idx_fk_borrower_public_record_2;
DROP INDEX staging_octane.idx_fk_borrower_reo_1;
DROP INDEX staging_octane.idx_fk_borrower_reo_2;
DROP INDEX staging_octane.idx_fk_borrower_residence_1;
DROP INDEX staging_octane.idx_fk_borrower_residence_2;
DROP INDEX staging_octane.idx_fkt_borrower_residence_3;
DROP INDEX staging_octane.idx_fk_borrower_tax_filing_1;
DROP INDEX staging_octane.idx_fk_borrower_tax_filing_2;
DROP INDEX staging_octane.idx_fkt_borrower_tax_filing_3;
DROP INDEX staging_octane.idx_fk_borrower_user_1;
DROP INDEX staging_octane.idx_fkt_borrower_user_2;
DROP INDEX staging_octane.idx_fkt_borrower_user_3;
DROP INDEX staging_octane.idx_fkt_borrower_user_4;
DROP INDEX staging_octane.idx_fk_borrower_user_change_email_1;
DROP INDEX staging_octane.idx_fk_borrower_user_change_email_2;
DROP INDEX staging_octane.idx_fk_borrower_user_deal_1;
DROP INDEX staging_octane.idx_fk_borrower_user_deal_2;
DROP INDEX staging_octane.idx_fk_borrower_user_deal_3;
DROP INDEX staging_octane.idx_fkt_borrower_user_deal_4;
DROP INDEX staging_octane.idx_fk_borrower_va_1;
DROP INDEX staging_octane.idx_fk_borrower_va_2;
DROP INDEX staging_octane.idx_fkt_borrower_va_3;
DROP INDEX staging_octane.idx_fkt_borrower_va_4;
DROP INDEX staging_octane.idx_fkt_borrower_va_5;
DROP INDEX staging_octane.idx_fkt_borrower_va_6;
DROP INDEX staging_octane.idx_fkt_borrower_va_7;
DROP INDEX staging_octane.idx_fkt_borrower_va_8;
DROP INDEX staging_octane.idx_fkt_borrower_va_9;
DROP INDEX staging_octane.idx_fkt_borrower_va_10;
DROP INDEX staging_octane.idx_fkt_borrower_va_11;
DROP INDEX staging_octane.idx_fkt_borrower_va_12;
DROP INDEX staging_octane.idx_fkt_borrower_va_13;
DROP INDEX staging_octane.idx_fkt_borrower_va_14;
DROP INDEX staging_octane.idx_fkt_borrower_va_15;
DROP INDEX staging_octane.idx_fkt_borrower_va_16;
DROP INDEX staging_octane.idx_fkt_borrower_va_17;
DROP INDEX staging_octane.idx_fk_branch_1;
DROP INDEX staging_octane.idx_fkt_branch_2;
DROP INDEX staging_octane.idx_fkt_branch_3;
DROP INDEX staging_octane.idx_fkt_branch_4;
DROP INDEX staging_octane.idx_fk_branch_account_executive_1;
DROP INDEX staging_octane.idx_fk_branch_account_executive_2;
DROP INDEX staging_octane.idx_fk_branch_license_1;
DROP INDEX staging_octane.idx_fkt_branch_license_2;
DROP INDEX staging_octane.idx_fkt_branch_license_3;
DROP INDEX staging_octane.idx_fk_business_income_1;
DROP INDEX staging_octane.idx_fkt_business_income_2;
DROP INDEX staging_octane.idx_fkt_business_income_3;
DROP INDEX staging_octane.idx_fkt_business_income_4;
DROP INDEX staging_octane.idx_fk_channel_1;
DROP INDEX staging_octane.idx_fkt_channel_2;
DROP INDEX staging_octane.idx_fkt_charge_type_1;
DROP INDEX staging_octane.idx_fk_circumstance_change_1;
DROP INDEX staging_octane.idx_fkt_circumstance_change_2;
DROP INDEX staging_octane.idx_fk_company_1;
DROP INDEX staging_octane.idx_fk_company_2;
DROP INDEX staging_octane.idx_fkt_company_3;
DROP INDEX staging_octane.idx_fkt_company_4;
DROP INDEX staging_octane.idx_fkt_company_5;
DROP INDEX staging_octane.idx_fkt_company_6;
DROP INDEX staging_octane.idx_fkt_company_7;
DROP INDEX staging_octane.idx_fk_company_admin_event_1;
DROP INDEX staging_octane.idx_fkt_company_admin_event_2;
DROP INDEX staging_octane.idx_fk_company_license_1;
DROP INDEX staging_octane.idx_fkt_company_license_2;
DROP INDEX staging_octane.idx_fkt_company_license_3;
DROP INDEX staging_octane.idx_fkt_company_license_4;
DROP INDEX staging_octane.idx_fk_compass_analytics_report_request_1;
DROP INDEX staging_octane.idx_fk_compass_analytics_report_request_2;
DROP INDEX staging_octane.idx_fkt_compass_analytics_report_request_3;
DROP INDEX staging_octane.idx_fk_construction_cost_1;
DROP INDEX staging_octane.idx_fk_construction_cost_2;
DROP INDEX staging_octane.idx_fk_construction_cost_3;
DROP INDEX staging_octane.idx_fkt_construction_cost_4;
DROP INDEX staging_octane.idx_fkt_construction_cost_5;
DROP INDEX staging_octane.idx_fkt_construction_cost_6;
DROP INDEX staging_octane.idx_fkt_construction_cost_7;
DROP INDEX staging_octane.idx_fk_construction_draw_1;
DROP INDEX staging_octane.idx_fkt_construction_draw_2;
DROP INDEX staging_octane.idx_fkt_construction_draw_3;
DROP INDEX staging_octane.idx_fk_construction_draw_item_1;
DROP INDEX staging_octane.idx_fk_construction_draw_item_2;
DROP INDEX staging_octane.idx_fk_construction_draw_item_3;
DROP INDEX staging_octane.idx_fk_construction_draw_number_ticker_1;
DROP INDEX staging_octane.idx_fk_consumer_privacy_affected_borrower_1;
DROP INDEX staging_octane.idx_fk_consumer_privacy_affected_borrower_2;
DROP INDEX staging_octane.idx_fk_consumer_privacy_affected_borrower_3;
DROP INDEX staging_octane.idx_fk_consumer_privacy_request_1;
DROP INDEX staging_octane.idx_fk_consumer_privacy_request_2;
DROP INDEX staging_octane.idx_fk_consumer_privacy_request_3;
DROP INDEX staging_octane.idx_fk_consumer_privacy_request_4;
DROP INDEX staging_octane.idx_fkt_consumer_privacy_request_5;
DROP INDEX staging_octane.idx_fkt_consumer_privacy_request_6;
DROP INDEX staging_octane.idx_fkt_consumer_privacy_request_7;
DROP INDEX staging_octane.idx_fk_contractor_1;
DROP INDEX staging_octane.idx_fkt_contractor_2;
DROP INDEX staging_octane.idx_fk_contractor_license_1;
DROP INDEX staging_octane.idx_fkt_contractor_license_2;
DROP INDEX staging_octane.idx_fk_cost_center_1;
DROP INDEX staging_octane.idx_fkt_county_1;
DROP INDEX staging_octane.idx_fkt_county_2;
DROP INDEX staging_octane.idx_fk_county_city_1;
DROP INDEX staging_octane.idx_fk_county_recording_district_1;
DROP INDEX staging_octane.idx_fk_county_recording_district_2;
DROP INDEX staging_octane.idx_fk_county_sub_jurisdiction_1;
DROP INDEX staging_octane.idx_fk_county_zip_code_1;
DROP INDEX staging_octane.idx_fk_county_zip_code_2;
DROP INDEX staging_octane.idx_fk_credit_inquiry_1;
DROP INDEX staging_octane.idx_fk_credit_inquiry_2;
DROP INDEX staging_octane.idx_fkt_credit_inquiry_3;
DROP INDEX staging_octane.idx_fkt_credit_inquiry_4;
DROP INDEX staging_octane.idx_fkt_credit_inquiry_5;
DROP INDEX staging_octane.idx_fkt_credit_inquiry_6;
DROP INDEX staging_octane.idx_fkt_credit_inquiry_7;
DROP INDEX staging_octane.idx_fk_credit_limit_1;
DROP INDEX staging_octane.idx_fkt_credit_limit_2;
DROP INDEX staging_octane.idx_fk_credit_request_1;
DROP INDEX staging_octane.idx_fk_credit_request_2;
DROP INDEX staging_octane.idx_fk_credit_request_3;
DROP INDEX staging_octane.idx_fk_credit_request_4;
DROP INDEX staging_octane.idx_fk_credit_request_5;
DROP INDEX staging_octane.idx_fk_credit_request_6;
DROP INDEX staging_octane.idx_fk_credit_request_7;
DROP INDEX staging_octane.idx_fkt_credit_request_8;
DROP INDEX staging_octane.idx_fkt_credit_request_9;
DROP INDEX staging_octane.idx_fkt_credit_request_10;
DROP INDEX staging_octane.idx_fkt_credit_request_11;
DROP INDEX staging_octane.idx_fkt_credit_request_12;
DROP INDEX staging_octane.idx_fkt_credit_request_13;
DROP INDEX staging_octane.idx_fkt_credit_request_14;
DROP INDEX staging_octane.idx_fkt_credit_request_15;
DROP INDEX staging_octane.idx_fkt_credit_request_16;
DROP INDEX staging_octane.idx_fkt_credit_request_17;
DROP INDEX staging_octane.idx_fkt_credit_request_18;
DROP INDEX staging_octane.idx_fkt_credit_request_19;
DROP INDEX staging_octane.idx_fkt_credit_request_20;
DROP INDEX staging_octane.idx_fkt_credit_request_21;
DROP INDEX staging_octane.idx_fkt_credit_request_22;
DROP INDEX staging_octane.idx_fkt_credit_request_23;
DROP INDEX staging_octane.idx_fk_creditor_1;
DROP INDEX staging_octane.idx_fkt_creditor_2;
DROP INDEX staging_octane.idx_fkt_creditor_3;
DROP INDEX staging_octane.idx_fkt_creditor_4;
DROP INDEX staging_octane.idx_fkt_creditor_5;
DROP INDEX staging_octane.idx_fk_creditor_lookup_name_1;
DROP INDEX staging_octane.idx_fk_creditor_lookup_name_2;
DROP INDEX staging_octane.idx_fk_criteria_1;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_1;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_2;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_3;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_4;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_5;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_6;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_7;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_8;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_9;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_10;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_11;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_12;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_13;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_14;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_15;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_16;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_17;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_18;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_19;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_20;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_21;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_22;
DROP INDEX staging_octane.idx_fk_criteria_pid_operand_23;
DROP INDEX staging_octane.idx_fkt_criteria_pid_operand_24;
DROP INDEX staging_octane.idx_fk_criteria_snippet_1;
DROP INDEX staging_octane.idx_fk_criteria_snippet_2;
DROP INDEX staging_octane.idx_fkt_criteria_snippet_3;
DROP INDEX staging_octane.idx_fkt_custodian_1;
DROP INDEX staging_octane.idx_fk_custom_form_1;
DROP INDEX staging_octane.idx_fk_custom_form_2;
DROP INDEX staging_octane.idx_fk_custom_form_merge_field_1;
DROP INDEX staging_octane.idx_fkt_custom_form_merge_field_2;
DROP INDEX staging_octane.idx_fk_deal_1;
DROP INDEX staging_octane.idx_fk_deal_2;
DROP INDEX staging_octane.idx_fk_deal_3;
DROP INDEX staging_octane.idx_fk_deal_4;
DROP INDEX staging_octane.idx_fk_deal_5;
DROP INDEX staging_octane.idx_fk_deal_6;
DROP INDEX staging_octane.idx_fkt_deal_7;
DROP INDEX staging_octane.idx_fkt_deal_8;
DROP INDEX staging_octane.idx_fkt_deal_9;
DROP INDEX staging_octane.idx_fkt_deal_10;
DROP INDEX staging_octane.idx_fkt_deal_11;
DROP INDEX staging_octane.idx_fkt_deal_13;
DROP INDEX staging_octane.idx_fkt_deal_14;
DROP INDEX staging_octane.idx_fkt_deal_15;
DROP INDEX staging_octane.idx_fkt_deal_16;
DROP INDEX staging_octane.idx_fkt_deal_17;
DROP INDEX staging_octane.idx_fkt_deal_18;
DROP INDEX staging_octane.idx_fk_deal_appraisal_1;
DROP INDEX staging_octane.idx_fkt_deal_appraisal_2;
DROP INDEX staging_octane.idx_fkt_deal_appraisal_3;
DROP INDEX staging_octane.idx_fkt_deal_appraisal_4;
DROP INDEX staging_octane.idx_fkt_deal_appraisal_5;
DROP INDEX staging_octane.idx_fk_deal_change_updater_time_1;
DROP INDEX staging_octane.idx_fk_deal_contact_1;
DROP INDEX staging_octane.idx_fkt_deal_contact_2;
DROP INDEX staging_octane.idx_fkt_deal_contact_3;
DROP INDEX staging_octane.idx_fk_deal_data_vendor_document_import_1;
DROP INDEX staging_octane.idx_fk_deal_data_vendor_document_import_2;
DROP INDEX staging_octane.idx_fk_deal_data_vendor_document_import_3;
DROP INDEX staging_octane.idx_fkt_deal_data_vendor_document_import_4;
DROP INDEX staging_octane.idx_fkt_deal_data_vendor_document_import_5;
DROP INDEX staging_octane.idx_fk_deal_disaster_declaration_1;
DROP INDEX staging_octane.idx_fk_deal_disaster_declaration_2;
DROP INDEX staging_octane.idx_fk_deal_dropbox_file_1;
DROP INDEX staging_octane.idx_fk_deal_du_1;
DROP INDEX staging_octane.idx_fk_deal_event_1;
DROP INDEX staging_octane.idx_fkt_deal_event_2;
DROP INDEX staging_octane.idx_fkt_deal_event_3;
DROP INDEX staging_octane.idx_fk_deal_file_1;
DROP INDEX staging_octane.idx_fk_deal_file_2;
DROP INDEX staging_octane.idx_fk_deal_file_signature_1;
DROP INDEX staging_octane.idx_fk_deal_file_signature_2;
DROP INDEX staging_octane.idx_fkt_deal_file_signature_3;
DROP INDEX staging_octane.idx_fkt_deal_file_signature_4;
DROP INDEX staging_octane.idx_fk_deal_file_thumbnail_1;
DROP INDEX staging_octane.idx_fk_deal_file_thumbnail_2;
DROP INDEX staging_octane.idx_fk_deal_fraud_risk_1;
DROP INDEX staging_octane.idx_fk_deal_fraud_risk_2;
DROP INDEX staging_octane.idx_fk_deal_fraud_risk_3;
DROP INDEX staging_octane.idx_fkt_deal_fraud_risk_4;
DROP INDEX staging_octane.idx_fk_deal_housing_counselor_candidate_1;
DROP INDEX staging_octane.idx_fk_deal_housing_counselor_candidate_2;
DROP INDEX staging_octane.idx_fkt_deal_housing_counselor_candidate_3;
DROP INDEX staging_octane.idx_fkt_deal_housing_counselor_candidate_4;
DROP INDEX staging_octane.idx_fk_deal_housing_counselors_request_1;
DROP INDEX staging_octane.idx_fkt_deal_housing_counselors_request_2;
DROP INDEX staging_octane.idx_fk_deal_invoice_1;
DROP INDEX staging_octane.idx_fkt_deal_invoice_2;
DROP INDEX staging_octane.idx_fk_deal_invoice_file_1;
DROP INDEX staging_octane.idx_fk_deal_invoice_file_2;
DROP INDEX staging_octane.idx_fkt_deal_invoice_file_3;
DROP INDEX staging_octane.idx_fk_deal_invoice_item_1;
DROP INDEX staging_octane.idx_fkt_deal_invoice_item_2;
DROP INDEX staging_octane.idx_fk_deal_invoice_payment_method_1;
DROP INDEX staging_octane.idx_fk_deal_invoice_payment_method_2;
DROP INDEX staging_octane.idx_fk_deal_invoice_payment_method_3;
DROP INDEX staging_octane.idx_fk_deal_invoice_payment_method_4;
DROP INDEX staging_octane.idx_fkt_deal_invoice_payment_method_5;
DROP INDEX staging_octane.idx_fkt_deal_invoice_payment_method_6;
DROP INDEX staging_octane.idx_fkt_deal_invoice_payment_method_7;
DROP INDEX staging_octane.idx_fkt_deal_invoice_payment_method_8;
DROP INDEX staging_octane.idx_fkt_deal_invoice_payment_method_9;
DROP INDEX staging_octane.idx_fkt_deal_invoice_payment_method_10;
DROP INDEX staging_octane.idx_fk_deal_key_roles_1;
DROP INDEX staging_octane.idx_fk_deal_key_roles_2;
DROP INDEX staging_octane.idx_fk_deal_key_roles_3;
DROP INDEX staging_octane.idx_fk_deal_key_roles_4;
DROP INDEX staging_octane.idx_fk_deal_key_roles_5;
DROP INDEX staging_octane.idx_fk_deal_key_roles_6;
DROP INDEX staging_octane.idx_fk_deal_key_roles_7;
DROP INDEX staging_octane.idx_fk_deal_key_roles_8;
DROP INDEX staging_octane.idx_fk_deal_key_roles_9;
DROP INDEX staging_octane.idx_fk_deal_key_roles_10;
DROP INDEX staging_octane.idx_fk_deal_key_roles_11;
DROP INDEX staging_octane.idx_fk_deal_key_roles_12;
DROP INDEX staging_octane.idx_fk_deal_key_roles_13;
DROP INDEX staging_octane.idx_fk_deal_key_roles_14;
DROP INDEX staging_octane.idx_fk_deal_key_roles_15;
DROP INDEX staging_octane.idx_fk_deal_key_roles_16;
DROP INDEX staging_octane.idx_fk_deal_key_roles_17;
DROP INDEX staging_octane.idx_fk_deal_lender_user_1;
DROP INDEX staging_octane.idx_fk_deal_lender_user_2;
DROP INDEX staging_octane.idx_fk_deal_lender_user_3;
DROP INDEX staging_octane.idx_fkt_deal_lender_user_4;
DROP INDEX staging_octane.idx_fkt_deal_lender_user_5;
DROP INDEX staging_octane.idx_fk_deal_lender_user_event_1;
DROP INDEX staging_octane.idx_fk_deal_lp_1;
DROP INDEX staging_octane.idx_fk_deal_message_log_1;
DROP INDEX staging_octane.idx_fk_deal_message_log_2;
DROP INDEX staging_octane.idx_fk_deal_message_log_3;
DROP INDEX staging_octane.idx_fkt_deal_message_log_4;
DROP INDEX staging_octane.idx_fk_deal_note_1;
DROP INDEX staging_octane.idx_fk_deal_note_2;
DROP INDEX staging_octane.idx_fk_deal_note_3;
DROP INDEX staging_octane.idx_fk_deal_note_4;
DROP INDEX staging_octane.idx_fk_deal_note_5;
DROP INDEX staging_octane.idx_fkt_deal_note_6;
DROP INDEX staging_octane.idx_fk_deal_note_comment_1;
DROP INDEX staging_octane.idx_fk_deal_note_comment_2;
DROP INDEX staging_octane.idx_fk_deal_note_monitor_1;
DROP INDEX staging_octane.idx_fk_deal_note_monitor_2;
DROP INDEX staging_octane.idx_fk_deal_note_role_tag_1;
DROP INDEX staging_octane.idx_fk_deal_note_role_tag_2;
DROP INDEX staging_octane.idx_fk_deal_performer_team_1;
DROP INDEX staging_octane.idx_fk_deal_performer_team_2;
DROP INDEX staging_octane.idx_fk_deal_performer_team_user_1;
DROP INDEX staging_octane.idx_fk_deal_performer_team_user_2;
DROP INDEX staging_octane.idx_fk_deal_performer_team_user_3;
DROP INDEX staging_octane.idx_fk_deal_real_estate_agent_1;
DROP INDEX staging_octane.idx_fkt_deal_real_estate_agent_2;
DROP INDEX staging_octane.idx_fkt_deal_real_estate_agent_3;
DROP INDEX staging_octane.idx_fk_deal_sap_1;
DROP INDEX staging_octane.idx_fk_deal_sap_2;
DROP INDEX staging_octane.idx_fkt_deal_sap_3;
DROP INDEX staging_octane.idx_fk_deal_settlement_1;
DROP INDEX staging_octane.idx_fk_deal_settlement_2;
DROP INDEX staging_octane.idx_fk_deal_settlement_3;
DROP INDEX staging_octane.idx_fk_deal_settlement_4;
DROP INDEX staging_octane.idx_fk_deal_settlement_5;
DROP INDEX staging_octane.idx_fk_deal_settlement_6;
DROP INDEX staging_octane.idx_fk_deal_settlement_7;
DROP INDEX staging_octane.idx_fkt_deal_settlement_8;
DROP INDEX staging_octane.idx_fk_deal_signer_1;
DROP INDEX staging_octane.idx_fk_deal_snapshot_1;
DROP INDEX staging_octane.idx_fkt_deal_snapshot_2;
DROP INDEX staging_octane.idx_fkt_deal_snapshot_3;
DROP INDEX staging_octane.idx_fkt_deal_snapshot_4;
DROP INDEX staging_octane.idx_fk_deal_stage_1;
DROP INDEX staging_octane.idx_fkt_deal_stage_2;
DROP INDEX staging_octane.idx_fk_deal_summary_1;
DROP INDEX staging_octane.idx_fkt_deal_summary_2;
DROP INDEX staging_octane.idx_fkt_deal_summary_3;
DROP INDEX staging_octane.idx_fkt_deal_summary_4;
DROP INDEX staging_octane.idx_fkt_deal_summary_5;
DROP INDEX staging_octane.idx_fkt_deal_summary_6;
DROP INDEX staging_octane.idx_fkt_deal_summary_7;
DROP INDEX staging_octane.idx_fk_deal_system_file_1;
DROP INDEX staging_octane.idx_fk_deal_system_file_2;
DROP INDEX staging_octane.idx_fk_deal_tag_1;
DROP INDEX staging_octane.idx_fk_deal_tag_2;
DROP INDEX staging_octane.idx_fk_deal_tag_3;
DROP INDEX staging_octane.idx_fk_deal_tag_4;
DROP INDEX staging_octane.idx_fk_deal_tag_5;
DROP INDEX staging_octane.idx_fk_deal_tag_6;
DROP INDEX staging_octane.idx_fk_deal_tag_7;
DROP INDEX staging_octane.idx_fk_deal_tag_8;
DROP INDEX staging_octane.idx_fk_deal_tag_9;
DROP INDEX staging_octane.idx_fk_deal_tag_10;
DROP INDEX staging_octane.idx_fk_deal_tag_11;
DROP INDEX staging_octane.idx_fk_deal_tag_12;
DROP INDEX staging_octane.idx_fk_deal_tag_13;
DROP INDEX staging_octane.idx_fk_deal_tag_14;
DROP INDEX staging_octane.idx_fk_deal_tag_15;
DROP INDEX staging_octane.idx_fk_deal_tag_definition_1;
DROP INDEX staging_octane.idx_fkt_deal_tag_definition_2;
DROP INDEX staging_octane.idx_fkt_deal_tag_definition_3;
DROP INDEX staging_octane.idx_fk_deal_task_1;
DROP INDEX staging_octane.idx_fkt_deal_task_2;
DROP INDEX staging_octane.idx_fk_disaster_declaration_1;
DROP INDEX staging_octane.idx_fk_disaster_declaration_2;
DROP INDEX staging_octane.idx_fkt_disaster_declaration_3;
DROP INDEX staging_octane.idx_fk_docusign_package_1;
DROP INDEX staging_octane.idx_fkt_docusign_package_2;
DROP INDEX staging_octane.idx_fk_du_key_finding_1;
DROP INDEX staging_octane.idx_fkt_du_key_finding_2;
DROP INDEX staging_octane.idx_fkt_du_key_finding_3;
DROP INDEX staging_octane.idx_fk_du_refi_plus_finding_1;
DROP INDEX staging_octane.idx_fk_du_request_1;
DROP INDEX staging_octane.idx_fk_du_request_2;
DROP INDEX staging_octane.idx_fk_du_request_3;
DROP INDEX staging_octane.idx_fk_du_request_4;
DROP INDEX staging_octane.idx_fk_du_request_5;
DROP INDEX staging_octane.idx_fk_du_request_6;
DROP INDEX staging_octane.idx_fk_du_request_7;
DROP INDEX staging_octane.idx_fkt_du_request_8;
DROP INDEX staging_octane.idx_fkt_du_request_9;
DROP INDEX staging_octane.idx_fkt_du_request_10;
DROP INDEX staging_octane.idx_fkt_du_request_11;
DROP INDEX staging_octane.idx_fkt_du_request_12;
DROP INDEX staging_octane.idx_fkt_du_request_13;
DROP INDEX staging_octane.idx_fk_du_request_credit_1;
DROP INDEX staging_octane.idx_fkt_du_request_credit_2;
DROP INDEX staging_octane.idx_fkt_du_request_credit_3;
DROP INDEX staging_octane.idx_fkt_du_request_credit_4;
DROP INDEX staging_octane.idx_fkt_du_request_credit_5;
DROP INDEX staging_octane.idx_fk_du_special_feature_code_1;
DROP INDEX staging_octane.idx_fk_dw_export_request_1;
DROP INDEX staging_octane.idx_fk_dw_export_request_2;
DROP INDEX staging_octane.idx_fkt_dw_export_request_3;
DROP INDEX staging_octane.idx_fk_ernst_request_1;
DROP INDEX staging_octane.idx_fk_ernst_request_2;
DROP INDEX staging_octane.idx_fkt_ernst_request_3;
DROP INDEX staging_octane.idx_fkt_ernst_request_4;
DROP INDEX staging_octane.idx_fkt_ernst_request_5;
DROP INDEX staging_octane.idx_fkt_ernst_request_6;
DROP INDEX staging_octane.idx_fk_ernst_request_question_1;
DROP INDEX staging_octane.idx_fk_exclusive_assignment_1;
DROP INDEX staging_octane.idx_fk_exclusive_assignment_2;
DROP INDEX staging_octane.idx_fk_flood_cert_1;
DROP INDEX staging_octane.idx_fk_flood_cert_2;
DROP INDEX staging_octane.idx_fk_flood_cert_3;
DROP INDEX staging_octane.idx_fkt_flood_cert_4;
DROP INDEX staging_octane.idx_fkt_flood_cert_5;
DROP INDEX staging_octane.idx_fkt_flood_cert_6;
DROP INDEX staging_octane.idx_fkt_flood_cert_7;
DROP INDEX staging_octane.idx_fkt_flood_cert_8;
DROP INDEX staging_octane.idx_fkt_flood_cert_9;
DROP INDEX staging_octane.idx_fkt_flood_cert_10;
DROP INDEX staging_octane.idx_fkt_flood_cert_11;
DROP INDEX staging_octane.idx_fkt_flood_cert_12;
DROP INDEX staging_octane.idx_fkt_flood_cert_13;
DROP INDEX staging_octane.idx_fkt_flood_cert_14;
DROP INDEX staging_octane.idx_fk_formula_report_column_1;
DROP INDEX staging_octane.idx_fkt_formula_report_column_2;
DROP INDEX staging_octane.idx_fkt_formula_report_column_3;
DROP INDEX staging_octane.idx_fkt_formula_report_column_4;
DROP INDEX staging_octane.idx_fkt_formula_report_column_5;
DROP INDEX staging_octane.idx_fkt_formula_report_column_6;
DROP INDEX staging_octane.idx_fkt_formula_report_column_7;
DROP INDEX staging_octane.idx_fk_google_sheet_export_1;
DROP INDEX staging_octane.idx_fkt_google_sheet_export_2;
DROP INDEX staging_octane.idx_fkt_google_sheet_export_3;
DROP INDEX staging_octane.idx_fk_hmda_report_request_1;
DROP INDEX staging_octane.idx_fk_hmda_report_request_2;
DROP INDEX staging_octane.idx_fkt_hmda_report_request_3;
DROP INDEX staging_octane.idx_fk_interim_funder_1;
DROP INDEX staging_octane.idx_fk_interim_funder_2;
DROP INDEX staging_octane.idx_fkt_interim_funder_3;
DROP INDEX staging_octane.idx_fkt_interim_funder_4;
DROP INDEX staging_octane.idx_fk_investor_1;
DROP INDEX staging_octane.idx_fk_investor_2;
DROP INDEX staging_octane.idx_fk_investor_3;
DROP INDEX staging_octane.idx_fk_investor_4;
DROP INDEX staging_octane.idx_fk_investor_5;
DROP INDEX staging_octane.idx_fk_investor_6;
DROP INDEX staging_octane.idx_fk_investor_7;
DROP INDEX staging_octane.idx_fk_investor_8;
DROP INDEX staging_octane.idx_fk_investor_9;
DROP INDEX staging_octane.idx_fkt_investor_10;
DROP INDEX staging_octane.idx_fkt_investor_11;
DROP INDEX staging_octane.idx_fkt_investor_12;
DROP INDEX staging_octane.idx_fkt_investor_13;
DROP INDEX staging_octane.idx_fkt_investor_14;
DROP INDEX staging_octane.idx_fkt_investor_15;
DROP INDEX staging_octane.idx_fkt_investor_16;
DROP INDEX staging_octane.idx_fkt_investor_17;
DROP INDEX staging_octane.idx_fkt_investor_18;
DROP INDEX staging_octane.idx_fkt_investor_19;
DROP INDEX staging_octane.idx_fkt_investor_20;
DROP INDEX staging_octane.idx_fkt_investor_21;
DROP INDEX staging_octane.idx_fkt_investor_22;
DROP INDEX staging_octane.idx_fkt_investor_23;
DROP INDEX staging_octane.idx_fk_investor_group_1;
DROP INDEX staging_octane.idx_fk_investor_lock_1;
DROP INDEX staging_octane.idx_fk_investor_lock_2;
DROP INDEX staging_octane.idx_fk_investor_lock_3;
DROP INDEX staging_octane.idx_fk_investor_lock_4;
DROP INDEX staging_octane.idx_fk_investor_lock_5;
DROP INDEX staging_octane.idx_fk_investor_lock_6;
DROP INDEX staging_octane.idx_fkt_investor_lock_7;
DROP INDEX staging_octane.idx_fkt_investor_lock_8;
DROP INDEX staging_octane.idx_fkt_investor_lock_9;
DROP INDEX staging_octane.idx_fkt_investor_lock_10;
DROP INDEX staging_octane.idx_fkt_investor_lock_11;
DROP INDEX staging_octane.idx_fkt_investor_lock_12;
DROP INDEX staging_octane.idx_fk_investor_lock_add_on_1;
DROP INDEX staging_octane.idx_fk_investor_lock_add_on_2;
DROP INDEX staging_octane.idx_fk_investor_lock_extension_1;
DROP INDEX staging_octane.idx_fk_investor_lock_extension_2;
DROP INDEX staging_octane.idx_fk_investor_lock_extension_3;
DROP INDEX staging_octane.idx_fk_investor_lock_extension_4;
DROP INDEX staging_octane.idx_fk_investor_lock_extension_5;
DROP INDEX staging_octane.idx_fkt_investor_lock_extension_6;
DROP INDEX staging_octane.idx_fk_investor_lock_extension_setting_1;
DROP INDEX staging_octane.idx_fk_job_income_1;
DROP INDEX staging_octane.idx_fkt_job_income_2;
DROP INDEX staging_octane.idx_fkt_job_income_3;
DROP INDEX staging_octane.idx_fkt_job_income_4;
DROP INDEX staging_octane.idx_fkt_job_income_5;
DROP INDEX staging_octane.idx_fkt_job_income_6;
DROP INDEX staging_octane.idx_fkt_job_income_7;
DROP INDEX staging_octane.idx_fkt_job_income_8;
DROP INDEX staging_octane.idx_fkt_job_income_9;
DROP INDEX staging_octane.idx_fkt_job_income_10;
DROP INDEX staging_octane.idx_fkt_job_income_11;
DROP INDEX staging_octane.idx_fk_key_package_1;
DROP INDEX staging_octane.idx_fk_key_package_2;
DROP INDEX staging_octane.idx_fkt_key_package_3;
DROP INDEX staging_octane.idx_fk_key_role_1;
DROP INDEX staging_octane.idx_fk_key_role_2;
DROP INDEX staging_octane.idx_fkt_key_role_3;
DROP INDEX staging_octane.idx_fk_lead_1;
DROP INDEX staging_octane.idx_fk_lead_campaign_1;
DROP INDEX staging_octane.idx_fk_lead_campaign_2;
DROP INDEX staging_octane.idx_fk_lead_source_1;
DROP INDEX staging_octane.idx_fk_lead_source_2;
DROP INDEX staging_octane.idx_fk_lead_source_3;
DROP INDEX staging_octane.idx_fk_lead_supplemental_margin_row_1;
DROP INDEX staging_octane.idx_fk_lead_supplemental_margin_table_1;
DROP INDEX staging_octane.idx_fk_lender_concession_request_1;
DROP INDEX staging_octane.idx_fk_lender_concession_request_2;
DROP INDEX staging_octane.idx_fk_lender_concession_request_3;
DROP INDEX staging_octane.idx_fk_lender_concession_request_4;
DROP INDEX staging_octane.idx_fkt_lender_concession_request_5;
DROP INDEX staging_octane.idx_fkt_lender_concession_request_6;
DROP INDEX staging_octane.idx_fkt_lender_concession_request_7;
DROP INDEX staging_octane.idx_fk_lender_lock_add_on_1;
DROP INDEX staging_octane.idx_fk_lender_lock_add_on_2;
DROP INDEX staging_octane.idx_fkt_lender_lock_add_on_3;
DROP INDEX staging_octane.idx_fk_lender_lock_extension_1;
DROP INDEX staging_octane.idx_fk_lender_lock_extension_2;
DROP INDEX staging_octane.idx_fk_lender_lock_extension_3;
DROP INDEX staging_octane.idx_fk_lender_lock_extension_4;
DROP INDEX staging_octane.idx_fk_lender_lock_extension_5;
DROP INDEX staging_octane.idx_fkt_lender_lock_extension_6;
DROP INDEX staging_octane.idx_fk_lender_lock_id_ticker_1;
DROP INDEX staging_octane.idx_fk_lender_lock_major_1;
DROP INDEX staging_octane.idx_fk_lender_lock_major_2;
DROP INDEX staging_octane.idx_fk_lender_lock_major_3;
DROP INDEX staging_octane.idx_fk_lender_lock_major_4;
DROP INDEX staging_octane.idx_fk_lender_lock_major_5;
DROP INDEX staging_octane.idx_fk_lender_lock_major_6;
DROP INDEX staging_octane.idx_fk_lender_lock_major_7;
DROP INDEX staging_octane.idx_fk_lender_lock_major_8;
DROP INDEX staging_octane.idx_fkt_lender_lock_major_9;
DROP INDEX staging_octane.idx_fkt_lender_lock_major_10;
DROP INDEX staging_octane.idx_fkt_lender_lock_major_11;
DROP INDEX staging_octane.idx_fk_lender_lock_minor_1;
DROP INDEX staging_octane.idx_fk_lender_lock_minor_2;
DROP INDEX staging_octane.idx_fk_lender_lock_minor_3;
DROP INDEX staging_octane.idx_fk_lender_lock_minor_4;
DROP INDEX staging_octane.idx_fk_lender_lock_minor_5;
DROP INDEX staging_octane.idx_fkt_lender_lock_minor_6;
DROP INDEX staging_octane.idx_fkt_lender_lock_minor_7;
DROP INDEX staging_octane.idx_fkt_lender_lock_minor_8;
DROP INDEX staging_octane.idx_fkt_lender_lock_minor_9;
DROP INDEX staging_octane.idx_fkt_lender_lock_minor_10;
DROP INDEX staging_octane.idx_fkt_lender_lock_minor_11;
DROP INDEX staging_octane.idx_fkt_lender_lock_minor_12;
DROP INDEX staging_octane.idx_fkt_lender_lock_minor_13;
DROP INDEX staging_octane.idx_fk_lender_settings_1;
DROP INDEX staging_octane.idx_fk_lender_settings_2;
DROP INDEX staging_octane.idx_fk_lender_settings_3;
DROP INDEX staging_octane.idx_fk_lender_settings_4;
DROP INDEX staging_octane.idx_fk_lender_settings_5;
DROP INDEX staging_octane.idx_fkt_lender_settings_6;
DROP INDEX staging_octane.idx_fkt_lender_settings_7;
DROP INDEX staging_octane.idx_fkt_lender_settings_8;
DROP INDEX staging_octane.idx_fkt_lender_settings_9;
DROP INDEX staging_octane.idx_fkt_lender_settings_10;
DROP INDEX staging_octane.idx_fkt_lender_settings_11;
DROP INDEX staging_octane.idx_fkt_lender_settings_12;
DROP INDEX staging_octane.idx_fk_lender_trade_id_ticker_1;
DROP INDEX staging_octane.idx_fk_lender_user_1;
DROP INDEX staging_octane.idx_fk_lender_user_2;
DROP INDEX staging_octane.idx_fk_lender_user_3;
DROP INDEX staging_octane.idx_fk_lender_user_4;
DROP INDEX staging_octane.idx_fk_lender_user_5;
DROP INDEX staging_octane.idx_fkt_lender_user_6;
DROP INDEX staging_octane.idx_fkt_lender_user_7;
DROP INDEX staging_octane.idx_fkt_lender_user_8;
DROP INDEX staging_octane.idx_fkt_lender_user_9;
DROP INDEX staging_octane.idx_fkt_lender_user_10;
DROP INDEX staging_octane.idx_fkt_lender_user_11;
DROP INDEX staging_octane.idx_fk_lender_user_allowed_ip_1;
DROP INDEX staging_octane.idx_fkt_lender_user_allowed_ip_2;
DROP INDEX staging_octane.idx_fk_lender_user_deal_visit_1;
DROP INDEX staging_octane.idx_fk_lender_user_deal_visit_2;
DROP INDEX staging_octane.idx_fk_lender_user_lead_source_1;
DROP INDEX staging_octane.idx_fk_lender_user_lead_source_2;
DROP INDEX staging_octane.idx_fk_lender_user_license_1;
DROP INDEX staging_octane.idx_fkt_lender_user_license_2;
DROP INDEX staging_octane.idx_fkt_lender_user_license_3;
DROP INDEX staging_octane.idx_fk_lender_user_notice_1;
DROP INDEX staging_octane.idx_fk_lender_user_notice_2;
DROP INDEX staging_octane.idx_fkt_lender_user_notice_3;
DROP INDEX staging_octane.idx_fk_lender_user_photo_1;
DROP INDEX staging_octane.idx_fk_lender_user_photo_2;
DROP INDEX staging_octane.idx_fk_lender_user_role_1;
DROP INDEX staging_octane.idx_fk_lender_user_role_2;
DROP INDEX staging_octane.idx_fk_lender_user_role_3;
DROP INDEX staging_octane.idx_fkt_lender_user_role_4;
DROP INDEX staging_octane.idx_fk_lender_user_role_addendum_1;
DROP INDEX staging_octane.idx_fk_lender_user_role_addendum_2;
DROP INDEX staging_octane.idx_fk_lender_user_role_addendum_3;
DROP INDEX staging_octane.idx_fk_lender_user_sign_on_1;
DROP INDEX staging_octane.idx_fk_lender_user_unavailable_1;
DROP INDEX staging_octane.idx_fk_liability_1;
DROP INDEX staging_octane.idx_fk_liability_2;
DROP INDEX staging_octane.idx_fk_liability_3;
DROP INDEX staging_octane.idx_fk_liability_4;
DROP INDEX staging_octane.idx_fk_liability_5;
DROP INDEX staging_octane.idx_fkt_liability_6;
DROP INDEX staging_octane.idx_fkt_liability_7;
DROP INDEX staging_octane.idx_fkt_liability_8;
DROP INDEX staging_octane.idx_fkt_liability_9;
DROP INDEX staging_octane.idx_fkt_liability_10;
DROP INDEX staging_octane.idx_fkt_liability_11;
DROP INDEX staging_octane.idx_fkt_liability_12;
DROP INDEX staging_octane.idx_fkt_liability_13;
DROP INDEX staging_octane.idx_fkt_liability_14;
DROP INDEX staging_octane.idx_fkt_liability_15;
DROP INDEX staging_octane.idx_fkt_liability_16;
DROP INDEX staging_octane.idx_fkt_liability_17;
DROP INDEX staging_octane.idx_fkt_liability_18;
DROP INDEX staging_octane.idx_fkt_liability_19;
DROP INDEX staging_octane.idx_fkt_liability_20;
DROP INDEX staging_octane.idx_fkt_liability_21;
DROP INDEX staging_octane.idx_fkt_liability_22;
DROP INDEX staging_octane.idx_fkt_liability_23;
DROP INDEX staging_octane.idx_fkt_liability_24;
DROP INDEX staging_octane.idx_fkt_liability_25;
DROP INDEX staging_octane.idx_fkt_liability_26;
DROP INDEX staging_octane.idx_fkt_liability_27;
DROP INDEX staging_octane.idx_fkt_liability_28;
DROP INDEX staging_octane.idx_fkt_liability_29;
DROP INDEX staging_octane.idx_fk_license_req_1;
DROP INDEX staging_octane.idx_fkt_license_req_2;
DROP INDEX staging_octane.idx_fkt_license_req_3;
DROP INDEX staging_octane.idx_fk_loan_1;
DROP INDEX staging_octane.idx_fk_loan_2;
DROP INDEX staging_octane.idx_fk_loan_3;
DROP INDEX staging_octane.idx_fk_loan_4;
DROP INDEX staging_octane.idx_fkt_loan_5;
DROP INDEX staging_octane.idx_fkt_loan_6;
DROP INDEX staging_octane.idx_fkt_loan_7;
DROP INDEX staging_octane.idx_fkt_loan_8;
DROP INDEX staging_octane.idx_fkt_loan_9;
DROP INDEX staging_octane.idx_fkt_loan_10;
DROP INDEX staging_octane.idx_fkt_loan_11;
DROP INDEX staging_octane.idx_fkt_loan_12;
DROP INDEX staging_octane.idx_fkt_loan_13;
DROP INDEX staging_octane.idx_fkt_loan_14;
DROP INDEX staging_octane.idx_fkt_loan_15;
DROP INDEX staging_octane.idx_fkt_loan_16;
DROP INDEX staging_octane.idx_fkt_loan_17;
DROP INDEX staging_octane.idx_fkt_loan_18;
DROP INDEX staging_octane.idx_fkt_loan_19;
DROP INDEX staging_octane.idx_fkt_loan_20;
DROP INDEX staging_octane.idx_fkt_loan_21;
DROP INDEX staging_octane.idx_fkt_loan_22;
DROP INDEX staging_octane.idx_fkt_loan_23;
DROP INDEX staging_octane.idx_fkt_loan_24;
DROP INDEX staging_octane.idx_fkt_loan_25;
DROP INDEX staging_octane.idx_fkt_loan_26;
DROP INDEX staging_octane.idx_fkt_loan_27;
DROP INDEX staging_octane.idx_fkt_loan_28;
DROP INDEX staging_octane.idx_fkt_loan_29;
DROP INDEX staging_octane.idx_fkt_loan_30;
DROP INDEX staging_octane.idx_fk_loan_beneficiary_1;
DROP INDEX staging_octane.idx_fk_loan_beneficiary_2;
DROP INDEX staging_octane.idx_fk_loan_beneficiary_3;
DROP INDEX staging_octane.idx_fk_loan_beneficiary_4;
DROP INDEX staging_octane.idx_fkt_loan_beneficiary_5;
DROP INDEX staging_octane.idx_fkt_loan_beneficiary_6;
DROP INDEX staging_octane.idx_fkt_loan_beneficiary_7;
DROP INDEX staging_octane.idx_fkt_loan_beneficiary_8;
DROP INDEX staging_octane.idx_fkt_loan_beneficiary_9;
DROP INDEX staging_octane.idx_fkt_loan_beneficiary_10;
DROP INDEX staging_octane.idx_fkt_loan_beneficiary_11;
DROP INDEX staging_octane.idx_fk_loan_charge_1;
DROP INDEX staging_octane.idx_fk_loan_charge_2;
DROP INDEX staging_octane.idx_fkt_loan_charge_3;
DROP INDEX staging_octane.idx_fkt_loan_charge_4;
DROP INDEX staging_octane.idx_fkt_loan_charge_5;
DROP INDEX staging_octane.idx_fkt_loan_charge_6;
DROP INDEX staging_octane.idx_fkt_loan_charge_7;
DROP INDEX staging_octane.idx_fkt_loan_charge_8;
DROP INDEX staging_octane.idx_fkt_loan_charge_9;
DROP INDEX staging_octane.idx_fkt_loan_charge_10;
DROP INDEX staging_octane.idx_fkt_loan_charge_11;
DROP INDEX staging_octane.idx_fkt_loan_charge_12;
DROP INDEX staging_octane.idx_fkt_loan_charge_13;
DROP INDEX staging_octane.idx_fkt_loan_charge_14;
DROP INDEX staging_octane.idx_fk_loan_closing_doc_1;
DROP INDEX staging_octane.idx_fk_loan_closing_doc_2;
DROP INDEX staging_octane.idx_fkt_loan_closing_doc_3;
DROP INDEX staging_octane.idx_fk_loan_eligible_investor_1;
DROP INDEX staging_octane.idx_fk_loan_eligible_investor_2;
DROP INDEX staging_octane.idx_fk_loan_funding_1;
DROP INDEX staging_octane.idx_fk_loan_funding_2;
DROP INDEX staging_octane.idx_fk_loan_funding_3;
DROP INDEX staging_octane.idx_fkt_loan_funding_4;
DROP INDEX staging_octane.idx_fkt_loan_funding_5;
DROP INDEX staging_octane.idx_fk_loan_hedge_1;
DROP INDEX staging_octane.idx_fk_loan_limit_row_1;
DROP INDEX staging_octane.idx_fk_loan_limit_row_2;
DROP INDEX staging_octane.idx_fk_loan_limit_row_3;
DROP INDEX staging_octane.idx_fk_loan_limit_row_4;
DROP INDEX staging_octane.idx_fk_loan_limit_table_1;
DROP INDEX staging_octane.idx_fk_loan_limit_table_2;
DROP INDEX staging_octane.idx_fk_loan_mi_rate_adjustment_1;
DROP INDEX staging_octane.idx_fk_loan_mi_surcharge_1;
DROP INDEX staging_octane.idx_fk_loan_price_add_on_1;
DROP INDEX staging_octane.idx_fkt_loan_price_add_on_2;
DROP INDEX staging_octane.idx_fk_loan_recording_1;
DROP INDEX staging_octane.idx_fkt_loan_recording_2;
DROP INDEX staging_octane.idx_fk_loan_servicer_1;
DROP INDEX staging_octane.idx_fk_loan_servicer_2;
DROP INDEX staging_octane.idx_fk_loan_servicer_3;
DROP INDEX staging_octane.idx_fkt_loan_servicer_4;
DROP INDEX staging_octane.idx_fk_lock_series_1;
DROP INDEX staging_octane.idx_fk_lock_term_setting_1;
DROP INDEX staging_octane.idx_fkt_lock_term_setting_2;
DROP INDEX staging_octane.idx_fk_los_loan_id_ticker_1;
DROP INDEX staging_octane.idx_fk_lp_finding_1;
DROP INDEX staging_octane.idx_fkt_lp_finding_2;
DROP INDEX staging_octane.idx_fkt_lp_finding_3;
DROP INDEX staging_octane.idx_fk_lp_request_1;
DROP INDEX staging_octane.idx_fk_lp_request_2;
DROP INDEX staging_octane.idx_fk_lp_request_3;
DROP INDEX staging_octane.idx_fk_lp_request_4;
DROP INDEX staging_octane.idx_fk_lp_request_5;
DROP INDEX staging_octane.idx_fk_lp_request_6;
DROP INDEX staging_octane.idx_fkt_lp_request_7;
DROP INDEX staging_octane.idx_fkt_lp_request_8;
DROP INDEX staging_octane.idx_fkt_lp_request_9;
DROP INDEX staging_octane.idx_fkt_lp_request_10;
DROP INDEX staging_octane.idx_fkt_lp_request_11;
DROP INDEX staging_octane.idx_fkt_lp_request_12;
DROP INDEX staging_octane.idx_fkt_lp_request_13;
DROP INDEX staging_octane.idx_fkt_lp_request_14;
DROP INDEX staging_octane.idx_fkt_lp_request_15;
DROP INDEX staging_octane.idx_fkt_lp_request_16;
DROP INDEX staging_octane.idx_fkt_lp_request_17;
DROP INDEX staging_octane.idx_fk_lp_request_credit_1;
DROP INDEX staging_octane.idx_fkt_lp_request_credit_2;
DROP INDEX staging_octane.idx_fkt_lp_request_credit_3;
DROP INDEX staging_octane.idx_fkt_lp_request_credit_4;
DROP INDEX staging_octane.idx_fkt_lp_request_credit_5;
DROP INDEX staging_octane.idx_fk_master_property_insurance_1;
DROP INDEX staging_octane.idx_fkt_master_property_insurance_2;
DROP INDEX staging_octane.idx_fkt_master_property_insurance_3;
DROP INDEX staging_octane.idx_fkt_master_property_insurance_4;
DROP INDEX staging_octane.idx_fkt_master_property_insurance_5;
DROP INDEX staging_octane.idx_fk_mcr_loan_1;
DROP INDEX staging_octane.idx_fkt_mcr_loan_2;
DROP INDEX staging_octane.idx_fkt_mcr_loan_3;
DROP INDEX staging_octane.idx_fkt_mcr_loan_4;
DROP INDEX staging_octane.idx_fkt_mcr_loan_5;
DROP INDEX staging_octane.idx_fkt_mcr_loan_6;
DROP INDEX staging_octane.idx_fkt_mcr_loan_7;
DROP INDEX staging_octane.idx_fkt_mcr_loan_8;
DROP INDEX staging_octane.idx_fkt_mcr_loan_9;
DROP INDEX staging_octane.idx_fkt_mcr_loan_10;
DROP INDEX staging_octane.idx_fkt_mcr_loan_11;
DROP INDEX staging_octane.idx_fkt_mcr_loan_12;
DROP INDEX staging_octane.idx_fkt_mcr_loan_13;
DROP INDEX staging_octane.idx_fkt_mcr_loan_14;
DROP INDEX staging_octane.idx_fkt_mcr_loan_15;
DROP INDEX staging_octane.idx_fkt_mcr_loan_16;
DROP INDEX staging_octane.idx_fkt_mcr_loan_17;
DROP INDEX staging_octane.idx_fkt_mcr_loan_18;
DROP INDEX staging_octane.idx_fkt_mcr_loan_19;
DROP INDEX staging_octane.idx_fkt_mcr_loan_20;
DROP INDEX staging_octane.idx_fk_mcr_snapshot_1;
DROP INDEX staging_octane.idx_fkt_mcr_snapshot_2;
DROP INDEX staging_octane.idx_fk_mercury_client_group_1;
DROP INDEX staging_octane.idx_fk_mercury_network_status_request_1;
DROP INDEX staging_octane.idx_fkt_mercury_network_status_request_2;
DROP INDEX staging_octane.idx_fk_mers_daily_report_1;
DROP INDEX staging_octane.idx_fk_mers_daily_report_2;
DROP INDEX staging_octane.idx_fkt_mers_daily_report_3;
DROP INDEX staging_octane.idx_fk_mi_integration_vendor_request_1;
DROP INDEX staging_octane.idx_fk_mi_integration_vendor_request_2;
DROP INDEX staging_octane.idx_fk_mi_integration_vendor_request_3;
DROP INDEX staging_octane.idx_fk_mi_integration_vendor_request_4;
DROP INDEX staging_octane.idx_fkt_mi_integration_vendor_request_5;
DROP INDEX staging_octane.idx_fkt_mi_integration_vendor_request_6;
DROP INDEX staging_octane.idx_fkt_mi_integration_vendor_request_7;
DROP INDEX staging_octane.idx_fkt_mi_integration_vendor_request_8;
DROP INDEX staging_octane.idx_fkt_mi_integration_vendor_request_9;
DROP INDEX staging_octane.idx_fk_military_service_1;
DROP INDEX staging_octane.idx_fkt_military_service_2;
DROP INDEX staging_octane.idx_fkt_military_service_3;
DROP INDEX staging_octane.idx_fkt_military_service_4;
DROP INDEX staging_octane.idx_fk_mortech_account_1;
DROP INDEX staging_octane.idx_fk_mortgage_credit_certificate_issuer_1;
DROP INDEX staging_octane.idx_fk_net_tangible_benefit_1;
DROP INDEX staging_octane.idx_fkt_net_tangible_benefit_2;
DROP INDEX staging_octane.idx_fk_obligation_1;
DROP INDEX staging_octane.idx_fkt_obligation_2;
DROP INDEX staging_octane.idx_fkt_obligation_3;
DROP INDEX staging_octane.idx_fkt_obligation_4;
DROP INDEX staging_octane.idx_fkt_obligation_5;
DROP INDEX staging_octane.idx_fk_offering_1;
DROP INDEX staging_octane.idx_fk_offering_2;
DROP INDEX staging_octane.idx_fk_offering_group_1;
DROP INDEX staging_octane.idx_fk_offering_product_1;
DROP INDEX staging_octane.idx_fk_offering_product_2;
DROP INDEX staging_octane.idx_fk_org_division_1;
DROP INDEX staging_octane.idx_fk_org_division_leader_1;
DROP INDEX staging_octane.idx_fk_org_division_leader_2;
DROP INDEX staging_octane.idx_fkt_org_division_leader_3;
DROP INDEX staging_octane.idx_fk_org_division_terms_1;
DROP INDEX staging_octane.idx_fk_org_division_terms_2;
DROP INDEX staging_octane.idx_fk_org_division_terms_3;
DROP INDEX staging_octane.idx_fk_org_division_terms_4;
DROP INDEX staging_octane.idx_fk_org_group_1;
DROP INDEX staging_octane.idx_fk_org_group_leader_1;
DROP INDEX staging_octane.idx_fk_org_group_leader_2;
DROP INDEX staging_octane.idx_fkt_org_group_leader_3;
DROP INDEX staging_octane.idx_fk_org_group_terms_1;
DROP INDEX staging_octane.idx_fk_org_group_terms_2;
DROP INDEX staging_octane.idx_fk_org_group_terms_3;
DROP INDEX staging_octane.idx_fk_org_group_terms_4;
DROP INDEX staging_octane.idx_fk_org_group_terms_5;
DROP INDEX staging_octane.idx_fk_org_lender_user_terms_1;
DROP INDEX staging_octane.idx_fk_org_lender_user_terms_2;
DROP INDEX staging_octane.idx_fk_org_region_1;
DROP INDEX staging_octane.idx_fk_org_region_leader_1;
DROP INDEX staging_octane.idx_fk_org_region_leader_2;
DROP INDEX staging_octane.idx_fkt_org_region_leader_3;
DROP INDEX staging_octane.idx_fk_org_region_terms_1;
DROP INDEX staging_octane.idx_fk_org_region_terms_2;
DROP INDEX staging_octane.idx_fk_org_region_terms_3;
DROP INDEX staging_octane.idx_fk_org_region_terms_4;
DROP INDEX staging_octane.idx_fk_org_region_terms_5;
DROP INDEX staging_octane.idx_fk_org_team_1;
DROP INDEX staging_octane.idx_fk_org_team_leader_1;
DROP INDEX staging_octane.idx_fk_org_team_leader_2;
DROP INDEX staging_octane.idx_fkt_org_team_leader_3;
DROP INDEX staging_octane.idx_fk_org_team_terms_1;
DROP INDEX staging_octane.idx_fk_org_team_terms_2;
DROP INDEX staging_octane.idx_fk_org_team_terms_3;
DROP INDEX staging_octane.idx_fk_org_team_terms_4;
DROP INDEX staging_octane.idx_fk_org_team_terms_5;
DROP INDEX staging_octane.idx_fk_org_unit_1;
DROP INDEX staging_octane.idx_fk_org_unit_leader_1;
DROP INDEX staging_octane.idx_fk_org_unit_leader_2;
DROP INDEX staging_octane.idx_fkt_org_unit_leader_3;
DROP INDEX staging_octane.idx_fk_org_unit_terms_1;
DROP INDEX staging_octane.idx_fk_org_unit_terms_2;
DROP INDEX staging_octane.idx_fk_org_unit_terms_3;
DROP INDEX staging_octane.idx_fk_org_unit_terms_4;
DROP INDEX staging_octane.idx_fk_org_unit_terms_5;
DROP INDEX staging_octane.idx_fk_other_income_1;
DROP INDEX staging_octane.idx_fk_other_income_2;
DROP INDEX staging_octane.idx_fkt_other_income_3;
DROP INDEX staging_octane.idx_fkt_other_income_4;
DROP INDEX staging_octane.idx_fk_performer_assignment_1;
DROP INDEX staging_octane.idx_fk_performer_assignment_2;
DROP INDEX staging_octane.idx_fk_performer_team_1;
DROP INDEX staging_octane.idx_fk_place_1;
DROP INDEX staging_octane.idx_fk_place_2;
DROP INDEX staging_octane.idx_fkt_place_3;
DROP INDEX staging_octane.idx_fkt_place_4;
DROP INDEX staging_octane.idx_fkt_place_5;
DROP INDEX staging_octane.idx_fkt_place_6;
DROP INDEX staging_octane.idx_fkt_place_7;
DROP INDEX staging_octane.idx_fkt_place_8;
DROP INDEX staging_octane.idx_fkt_place_9;
DROP INDEX staging_octane.idx_fkt_place_10;
DROP INDEX staging_octane.idx_fkt_place_11;
DROP INDEX staging_octane.idx_fkt_place_12;
DROP INDEX staging_octane.idx_fkt_place_13;
DROP INDEX staging_octane.idx_fkt_place_14;
DROP INDEX staging_octane.idx_fkt_place_15;
DROP INDEX staging_octane.idx_fkt_place_16;
DROP INDEX staging_octane.idx_fkt_place_17;
DROP INDEX staging_octane.idx_fkt_place_18;
DROP INDEX staging_octane.idx_fkt_place_20;
DROP INDEX staging_octane.idx_fkt_place_21;
DROP INDEX staging_octane.idx_fkt_place_22;
DROP INDEX staging_octane.idx_fkt_place_23;
DROP INDEX staging_octane.idx_fkt_place_24;
DROP INDEX staging_octane.idx_fkt_place_25;
DROP INDEX staging_octane.idx_fkt_place_26;
DROP INDEX staging_octane.idx_fkt_place_27;
DROP INDEX staging_octane.idx_fkt_place_28;
DROP INDEX staging_octane.idx_fkt_place_29;
DROP INDEX staging_octane.idx_fkt_place_30;
DROP INDEX staging_octane.idx_fkt_place_31;
DROP INDEX staging_octane.idx_fkt_place_32;
DROP INDEX staging_octane.idx_fkt_place_33;
DROP INDEX staging_octane.idx_fkt_place_34;
DROP INDEX staging_octane.idx_fkt_place_35;
DROP INDEX staging_octane.idx_fkt_place_36;
DROP INDEX staging_octane.idx_fkt_place_37;
DROP INDEX staging_octane.idx_fkt_place_38;
DROP INDEX staging_octane.idx_fkt_place_39;
DROP INDEX staging_octane.idx_fkt_place_40;
DROP INDEX staging_octane.idx_fk_preferred_settlement_1;
DROP INDEX staging_octane.idx_fk_preferred_settlement_2;
DROP INDEX staging_octane.idx_fk_preferred_settlement_3;
DROP INDEX staging_octane.idx_fk_preferred_settlement_4;
DROP INDEX staging_octane.idx_fk_preferred_settlement_5;
DROP INDEX staging_octane.idx_fk_preferred_settlement_6;
DROP INDEX staging_octane.idx_fk_price_processing_time_1;
DROP INDEX staging_octane.idx_fk_product_1;
DROP INDEX staging_octane.idx_fk_product_2;
DROP INDEX staging_octane.idx_fk_product_3;
DROP INDEX staging_octane.idx_fkt_product_4;
DROP INDEX staging_octane.idx_fkt_product_5;
DROP INDEX staging_octane.idx_fk_product_add_on_1;
DROP INDEX staging_octane.idx_fk_product_add_on_rule_1;
DROP INDEX staging_octane.idx_fkt_product_add_on_rule_2;
DROP INDEX staging_octane.idx_fkt_product_add_on_rule_3;
DROP INDEX staging_octane.idx_fkt_product_add_on_rule_4;
DROP INDEX staging_octane.idx_fkt_product_add_on_rule_5;
DROP INDEX staging_octane.idx_fkt_product_add_on_rule_6;
DROP INDEX staging_octane.idx_fkt_product_add_on_rule_7;
DROP INDEX staging_octane.idx_fkt_product_add_on_rule_8;
DROP INDEX staging_octane.idx_fkt_product_add_on_rule_9;
DROP INDEX staging_octane.idx_fkt_product_add_on_rule_10;
DROP INDEX staging_octane.idx_fkt_product_add_on_rule_11;
DROP INDEX staging_octane.idx_fkt_product_add_on_rule_12;
DROP INDEX staging_octane.idx_fkt_product_add_on_rule_13;
DROP INDEX staging_octane.idx_fkt_product_add_on_rule_14;
DROP INDEX staging_octane.idx_fkt_product_add_on_rule_15;
DROP INDEX staging_octane.idx_fkt_product_add_on_rule_16;
DROP INDEX staging_octane.idx_fk_product_branch_1;
DROP INDEX staging_octane.idx_fk_product_branch_2;
DROP INDEX staging_octane.idx_fk_product_buydown_1;
DROP INDEX staging_octane.idx_fkt_product_buydown_2;
DROP INDEX staging_octane.idx_fk_product_deal_check_exclusion_1;
DROP INDEX staging_octane.idx_fkt_product_deal_check_exclusion_2;
DROP INDEX staging_octane.idx_fk_product_eligibility_1;
DROP INDEX staging_octane.idx_fk_product_eligibility_rule_1;
DROP INDEX staging_octane.idx_fkt_product_eligibility_rule_2;
DROP INDEX staging_octane.idx_fkt_product_eligibility_rule_3;
DROP INDEX staging_octane.idx_fkt_product_eligibility_rule_4;
DROP INDEX staging_octane.idx_fkt_product_eligibility_rule_5;
DROP INDEX staging_octane.idx_fkt_product_eligibility_rule_6;
DROP INDEX staging_octane.idx_fkt_product_eligibility_rule_7;
DROP INDEX staging_octane.idx_fkt_product_eligibility_rule_8;
DROP INDEX staging_octane.idx_fkt_product_eligibility_rule_9;
DROP INDEX staging_octane.idx_fkt_product_eligibility_rule_10;
DROP INDEX staging_octane.idx_fkt_product_eligibility_rule_11;
DROP INDEX staging_octane.idx_fkt_product_eligibility_rule_12;
DROP INDEX staging_octane.idx_fkt_product_eligibility_rule_13;
DROP INDEX staging_octane.idx_fkt_product_eligibility_rule_14;
DROP INDEX staging_octane.idx_fkt_product_eligibility_rule_15;
DROP INDEX staging_octane.idx_fkt_product_eligibility_rule_16;
DROP INDEX staging_octane.idx_fk_product_interest_only_1;
DROP INDEX staging_octane.idx_fkt_product_interest_only_2;
DROP INDEX staging_octane.idx_fk_product_lock_term_1;
DROP INDEX staging_octane.idx_fk_product_lock_term_2;
DROP INDEX staging_octane.idx_fk_product_maximum_investor_price_1;
DROP INDEX staging_octane.idx_fk_product_maximum_rebate_1;
DROP INDEX staging_octane.idx_fk_product_minimum_investor_price_1;
DROP INDEX staging_octane.idx_fk_product_originator_1;
DROP INDEX staging_octane.idx_fk_product_originator_2;
DROP INDEX staging_octane.idx_fk_product_prepay_penalty_1;
DROP INDEX staging_octane.idx_fkt_product_prepay_penalty_2;
DROP INDEX staging_octane.idx_fk_product_terms_1;
DROP INDEX staging_octane.idx_fkt_product_terms_2;
DROP INDEX staging_octane.idx_fkt_product_terms_3;
DROP INDEX staging_octane.idx_fkt_product_terms_4;
DROP INDEX staging_octane.idx_fkt_product_terms_5;
DROP INDEX staging_octane.idx_fkt_product_terms_6;
DROP INDEX staging_octane.idx_fkt_product_terms_7;
DROP INDEX staging_octane.idx_fkt_product_terms_8;
DROP INDEX staging_octane.idx_fkt_product_terms_9;
DROP INDEX staging_octane.idx_fkt_product_terms_10;
DROP INDEX staging_octane.idx_fkt_product_terms_11;
DROP INDEX staging_octane.idx_fkt_product_terms_12;
DROP INDEX staging_octane.idx_fkt_product_terms_13;
DROP INDEX staging_octane.idx_fkt_product_terms_14;
DROP INDEX staging_octane.idx_fkt_product_terms_15;
DROP INDEX staging_octane.idx_fkt_product_terms_16;
DROP INDEX staging_octane.idx_fkt_product_terms_17;
DROP INDEX staging_octane.idx_fkt_product_terms_18;
DROP INDEX staging_octane.idx_fkt_product_terms_19;
DROP INDEX staging_octane.idx_fkt_product_terms_20;
DROP INDEX staging_octane.idx_fkt_product_terms_21;
DROP INDEX staging_octane.idx_fkt_product_terms_22;
DROP INDEX staging_octane.idx_fkt_product_terms_23;
DROP INDEX staging_octane.idx_fkt_product_terms_24;
DROP INDEX staging_octane.idx_fkt_product_terms_25;
DROP INDEX staging_octane.idx_fkt_product_terms_26;
DROP INDEX staging_octane.idx_fkt_product_terms_27;
DROP INDEX staging_octane.idx_fkt_product_terms_28;
DROP INDEX staging_octane.idx_fkt_product_terms_29;
DROP INDEX staging_octane.idx_fkt_product_terms_30;
DROP INDEX staging_octane.idx_fkt_product_terms_31;
DROP INDEX staging_octane.idx_fkt_product_terms_32;
DROP INDEX staging_octane.idx_fkt_product_terms_33;
DROP INDEX staging_octane.idx_fkt_product_terms_34;
DROP INDEX staging_octane.idx_fkt_product_terms_35;
DROP INDEX staging_octane.idx_fkt_product_terms_36;
DROP INDEX staging_octane.idx_fkt_product_terms_37;
DROP INDEX staging_octane.idx_fkt_product_terms_38;
DROP INDEX staging_octane.idx_fkt_product_terms_39;
DROP INDEX staging_octane.idx_fkt_product_terms_40;
DROP INDEX staging_octane.idx_fkt_product_terms_41;
DROP INDEX staging_octane.idx_fk_product_third_party_community_second_program_1;
DROP INDEX staging_octane.idx_fk_product_third_party_community_second_program_2;
DROP INDEX staging_octane.idx_fk_profit_margin_detail_1;
DROP INDEX staging_octane.idx_fkt_profit_margin_detail_2;
DROP INDEX staging_octane.idx_fk_proposal_1;
DROP INDEX staging_octane.idx_fk_proposal_2;
DROP INDEX staging_octane.idx_fk_proposal_3;
DROP INDEX staging_octane.idx_fk_proposal_4;
DROP INDEX staging_octane.idx_fk_proposal_5;
DROP INDEX staging_octane.idx_fk_proposal_6;
DROP INDEX staging_octane.idx_fkt_proposal_7;
DROP INDEX staging_octane.idx_fkt_proposal_8;
DROP INDEX staging_octane.idx_fkt_proposal_9;
DROP INDEX staging_octane.idx_fkt_proposal_10;
DROP INDEX staging_octane.idx_fkt_proposal_11;
DROP INDEX staging_octane.idx_fkt_proposal_12;
DROP INDEX staging_octane.idx_fkt_proposal_13;
DROP INDEX staging_octane.idx_fkt_proposal_14;
DROP INDEX staging_octane.idx_fkt_proposal_15;
DROP INDEX staging_octane.idx_fkt_proposal_16;
DROP INDEX staging_octane.idx_fkt_proposal_17;
DROP INDEX staging_octane.idx_fkt_proposal_18;
DROP INDEX staging_octane.idx_fkt_proposal_19;
DROP INDEX staging_octane.idx_fkt_proposal_20;
DROP INDEX staging_octane.idx_fkt_proposal_21;
DROP INDEX staging_octane.idx_fkt_proposal_22;
DROP INDEX staging_octane.idx_fkt_proposal_24;
DROP INDEX staging_octane.idx_fkt_proposal_25;
DROP INDEX staging_octane.idx_fkt_proposal_26;
DROP INDEX staging_octane.idx_fkt_proposal_27;
DROP INDEX staging_octane.idx_fkt_proposal_28;
DROP INDEX staging_octane.idx_fkt_proposal_29;
DROP INDEX staging_octane.idx_fkt_proposal_30;
DROP INDEX staging_octane.idx_fkt_proposal_31;
DROP INDEX staging_octane.idx_fkt_proposal_32;
DROP INDEX staging_octane.idx_fkt_proposal_33;
DROP INDEX staging_octane.idx_fkt_proposal_34;
DROP INDEX staging_octane.idx_fkt_proposal_35;
DROP INDEX staging_octane.idx_fkt_proposal_36;
DROP INDEX staging_octane.idx_fkt_proposal_37;
DROP INDEX staging_octane.idx_fkt_proposal_38;
DROP INDEX staging_octane.idx_fkt_proposal_39;
DROP INDEX staging_octane.idx_fkt_proposal_40;
DROP INDEX staging_octane.idx_fkt_proposal_41;
DROP INDEX staging_octane.idx_fkt_proposal_42;
DROP INDEX staging_octane.idx_fkt_proposal_43;
DROP INDEX staging_octane.idx_fkt_proposal_44;
DROP INDEX staging_octane.idx_fkt_proposal_45;
DROP INDEX staging_octane.idx_fkt_proposal_46;
DROP INDEX staging_octane.idx_fkt_proposal_47;
DROP INDEX staging_octane.idx_fkt_proposal_48;
DROP INDEX staging_octane.idx_fkt_proposal_49;
DROP INDEX staging_octane.idx_fkt_proposal_50;
DROP INDEX staging_octane.idx_fkt_proposal_51;
DROP INDEX staging_octane.idx_fkt_proposal_52;
DROP INDEX staging_octane.idx_fkt_proposal_53;
DROP INDEX staging_octane.idx_fkt_proposal_54;
DROP INDEX staging_octane.idx_fk_proposal_contractor_1;
DROP INDEX staging_octane.idx_fk_proposal_contractor_2;
DROP INDEX staging_octane.idx_fk_proposal_doc_1;
DROP INDEX staging_octane.idx_fk_proposal_doc_2;
DROP INDEX staging_octane.idx_fk_proposal_doc_3;
DROP INDEX staging_octane.idx_fk_proposal_doc_4;
DROP INDEX staging_octane.idx_fk_proposal_doc_5;
DROP INDEX staging_octane.idx_fk_proposal_doc_6;
DROP INDEX staging_octane.idx_fk_proposal_doc_7;
DROP INDEX staging_octane.idx_fk_proposal_doc_8;
DROP INDEX staging_octane.idx_fk_proposal_doc_9;
DROP INDEX staging_octane.idx_fk_proposal_doc_10;
DROP INDEX staging_octane.idx_fk_proposal_doc_11;
DROP INDEX staging_octane.idx_fk_proposal_doc_12;
DROP INDEX staging_octane.idx_fk_proposal_doc_13;
DROP INDEX staging_octane.idx_fk_proposal_doc_14;
DROP INDEX staging_octane.idx_fk_proposal_doc_15;
DROP INDEX staging_octane.idx_fk_proposal_doc_16;
DROP INDEX staging_octane.idx_fk_proposal_doc_17;
DROP INDEX staging_octane.idx_fk_proposal_doc_18;
DROP INDEX staging_octane.idx_fk_proposal_doc_19;
DROP INDEX staging_octane.idx_fk_proposal_doc_20;
DROP INDEX staging_octane.idx_fk_proposal_doc_21;
DROP INDEX staging_octane.idx_fk_proposal_doc_22;
DROP INDEX staging_octane.idx_fk_proposal_doc_23;
DROP INDEX staging_octane.idx_fk_proposal_doc_24;
DROP INDEX staging_octane.idx_fk_proposal_doc_25;
DROP INDEX staging_octane.idx_fk_proposal_doc_26;
DROP INDEX staging_octane.idx_fk_proposal_doc_27;
DROP INDEX staging_octane.idx_fk_proposal_doc_28;
DROP INDEX staging_octane.idx_fkt_proposal_doc_29;
DROP INDEX staging_octane.idx_fkt_proposal_doc_30;
DROP INDEX staging_octane.idx_fkt_proposal_doc_31;
DROP INDEX staging_octane.idx_fk_proposal_doc_borrower_access_1;
DROP INDEX staging_octane.idx_fk_proposal_doc_borrower_access_2;
DROP INDEX staging_octane.idx_fk_proposal_doc_file_1;
DROP INDEX staging_octane.idx_fk_proposal_doc_file_2;
DROP INDEX staging_octane.idx_fkt_proposal_doc_file_3;
DROP INDEX staging_octane.idx_fkt_proposal_doc_file_4;
DROP INDEX staging_octane.idx_fk_proposal_doc_set_1;
DROP INDEX staging_octane.idx_fk_proposal_doc_set_2;
DROP INDEX staging_octane.idx_fk_proposal_doc_set_3;
DROP INDEX staging_octane.idx_fk_proposal_doc_set_4;
DROP INDEX staging_octane.idx_fk_proposal_doc_set_5;
DROP INDEX staging_octane.idx_fk_proposal_doc_set_6;
DROP INDEX staging_octane.idx_fk_proposal_doc_set_7;
DROP INDEX staging_octane.idx_fkt_proposal_doc_set_8;
DROP INDEX staging_octane.idx_fkt_proposal_doc_set_9;
DROP INDEX staging_octane.idx_fkt_proposal_doc_set_10;
DROP INDEX staging_octane.idx_fkt_proposal_doc_set_11;
DROP INDEX staging_octane.idx_fkt_proposal_doc_set_12;
DROP INDEX staging_octane.idx_fkt_proposal_doc_set_13;
DROP INDEX staging_octane.idx_fkt_proposal_doc_set_14;
DROP INDEX staging_octane.idx_fk_proposal_doc_set_id_ticker_1;
DROP INDEX staging_octane.idx_fk_proposal_doc_set_id_ticker_2;
DROP INDEX staging_octane.idx_fk_proposal_doc_set_signer_1;
DROP INDEX staging_octane.idx_fk_proposal_doc_set_signer_2;
DROP INDEX staging_octane.idx_fk_proposal_doc_set_snapshot_1;
DROP INDEX staging_octane.idx_fk_proposal_doc_set_snapshot_2;
DROP INDEX staging_octane.idx_fk_proposal_engagement_1;
DROP INDEX staging_octane.idx_fk_proposal_grant_program_1;
DROP INDEX staging_octane.idx_fk_proposal_grant_program_2;
DROP INDEX staging_octane.idx_fk_proposal_req_1;
DROP INDEX staging_octane.idx_fk_proposal_req_2;
DROP INDEX staging_octane.idx_fk_proposal_req_3;
DROP INDEX staging_octane.idx_fk_proposal_req_4;
DROP INDEX staging_octane.idx_fk_proposal_req_5;
DROP INDEX staging_octane.idx_fk_proposal_req_6;
DROP INDEX staging_octane.idx_fk_proposal_req_7;
DROP INDEX staging_octane.idx_fk_proposal_req_8;
DROP INDEX staging_octane.idx_fk_proposal_req_9;
DROP INDEX staging_octane.idx_fk_proposal_req_10;
DROP INDEX staging_octane.idx_fk_proposal_req_11;
DROP INDEX staging_octane.idx_fk_proposal_req_12;
DROP INDEX staging_octane.idx_fk_proposal_req_13;
DROP INDEX staging_octane.idx_fk_proposal_req_14;
DROP INDEX staging_octane.idx_fk_proposal_req_15;
DROP INDEX staging_octane.idx_fk_proposal_req_16;
DROP INDEX staging_octane.idx_fk_proposal_req_17;
DROP INDEX staging_octane.idx_fk_proposal_req_18;
DROP INDEX staging_octane.idx_fk_proposal_req_19;
DROP INDEX staging_octane.idx_fk_proposal_req_20;
DROP INDEX staging_octane.idx_fk_proposal_req_21;
DROP INDEX staging_octane.idx_fk_proposal_req_22;
DROP INDEX staging_octane.idx_fk_proposal_req_23;
DROP INDEX staging_octane.idx_fk_proposal_req_24;
DROP INDEX staging_octane.idx_fk_proposal_req_25;
DROP INDEX staging_octane.idx_fk_proposal_req_26;
DROP INDEX staging_octane.idx_fk_proposal_req_27;
DROP INDEX staging_octane.idx_fkt_proposal_req_28;
DROP INDEX staging_octane.idx_fkt_proposal_req_29;
DROP INDEX staging_octane.idx_fkt_proposal_req_30;
DROP INDEX staging_octane.idx_fk_proposal_review_1;
DROP INDEX staging_octane.idx_fk_proposal_review_2;
DROP INDEX staging_octane.idx_fk_proposal_review_3;
DROP INDEX staging_octane.idx_fkt_proposal_review_4;
DROP INDEX staging_octane.idx_fk_proposal_review_ticker_1;
DROP INDEX staging_octane.idx_fk_proposal_summary_1;
DROP INDEX staging_octane.idx_fk_proposal_summary_2;
DROP INDEX staging_octane.idx_fk_proposal_summary_3;
DROP INDEX staging_octane.idx_fk_proposal_summary_4;
DROP INDEX staging_octane.idx_fk_proposal_summary_5;
DROP INDEX staging_octane.idx_fk_proposal_summary_6;
DROP INDEX staging_octane.idx_fk_proposal_summary_7;
DROP INDEX staging_octane.idx_fk_proposal_summary_8;
DROP INDEX staging_octane.idx_fkt_proposal_summary_9;
DROP INDEX staging_octane.idx_fkt_proposal_summary_10;
DROP INDEX staging_octane.idx_fkt_proposal_summary_11;
DROP INDEX staging_octane.idx_fkt_proposal_summary_12;
DROP INDEX staging_octane.idx_fkt_proposal_summary_13;
DROP INDEX staging_octane.idx_fkt_proposal_summary_14;
DROP INDEX staging_octane.idx_fkt_proposal_summary_15;
DROP INDEX staging_octane.idx_fkt_proposal_summary_16;
DROP INDEX staging_octane.idx_fkt_proposal_summary_17;
DROP INDEX staging_octane.idx_fkt_proposal_summary_18;
DROP INDEX staging_octane.idx_fkt_proposal_summary_19;
DROP INDEX staging_octane.idx_fkt_proposal_summary_20;
DROP INDEX staging_octane.idx_fkt_proposal_summary_21;
DROP INDEX staging_octane.idx_fkt_proposal_summary_22;
DROP INDEX staging_octane.idx_fkt_proposal_summary_23;
DROP INDEX staging_octane.idx_fkt_proposal_summary_24;
DROP INDEX staging_octane.idx_fkt_proposal_summary_25;
DROP INDEX staging_octane.idx_fkt_proposal_summary_26;
DROP INDEX staging_octane.idx_fkt_proposal_summary_27;
DROP INDEX staging_octane.idx_fkt_proposal_summary_28;
DROP INDEX staging_octane.idx_fkt_proposal_summary_29;
DROP INDEX staging_octane.idx_fkt_proposal_summary_30;
DROP INDEX staging_octane.idx_fkt_proposal_summary_31;
DROP INDEX staging_octane.idx_fkt_proposal_summary_32;
DROP INDEX staging_octane.idx_fkt_proposal_summary_33;
DROP INDEX staging_octane.idx_fkt_proposal_summary_34;
DROP INDEX staging_octane.idx_fkt_proposal_summary_35;
DROP INDEX staging_octane.idx_fkt_proposal_summary_36;
DROP INDEX staging_octane.idx_fkt_proposal_summary_37;
DROP INDEX staging_octane.idx_fk_pte_request_1;
DROP INDEX staging_octane.idx_fk_pte_request_2;
DROP INDEX staging_octane.idx_fk_pte_request_3;
DROP INDEX staging_octane.idx_fkt_pte_request_4;
DROP INDEX staging_octane.idx_fkt_pte_request_5;
DROP INDEX staging_octane.idx_fkt_pte_request_6;
DROP INDEX staging_octane.idx_fkt_pte_request_7;
DROP INDEX staging_octane.idx_fkt_pte_request_8;
DROP INDEX staging_octane.idx_fk_public_record_1;
DROP INDEX staging_octane.idx_fk_public_record_2;
DROP INDEX staging_octane.idx_fkt_public_record_3;
DROP INDEX staging_octane.idx_fkt_public_record_4;
DROP INDEX staging_octane.idx_fkt_public_record_5;
DROP INDEX staging_octane.idx_fkt_public_record_6;
DROP INDEX staging_octane.idx_fk_rate_sheet_1;
DROP INDEX staging_octane.idx_fk_rate_sheet_price_1;
DROP INDEX staging_octane.idx_fkt_rate_sheet_price_2;
DROP INDEX staging_octane.idx_fk_rate_sheet_rate_1;
DROP INDEX staging_octane.idx_fkt_recording_city_1;
DROP INDEX staging_octane.idx_fkt_recording_district_1;
DROP INDEX staging_octane.idx_fk_region_ernst_page_rec_1;
DROP INDEX staging_octane.idx_fk_region_ernst_page_rec_2;
DROP INDEX staging_octane.idx_fk_region_ernst_page_rec_3;
DROP INDEX staging_octane.idx_fkt_region_ernst_page_rec_4;
DROP INDEX staging_octane.idx_fkt_region_ernst_page_rec_5;
DROP INDEX staging_octane.idx_fk_relock_fee_setting_1;
DROP INDEX staging_octane.idx_fk_rental_income_1;
DROP INDEX staging_octane.idx_fk_rental_income_2;
DROP INDEX staging_octane.idx_fkt_rental_income_3;
DROP INDEX staging_octane.idx_fk_report_1;
DROP INDEX staging_octane.idx_fk_report_2;
DROP INDEX staging_octane.idx_fkt_report_3;
DROP INDEX staging_octane.idx_fk_report_column_1;
DROP INDEX staging_octane.idx_fkt_report_column_2;
DROP INDEX staging_octane.idx_fk_report_row_1;
DROP INDEX staging_octane.idx_fkt_report_row_2;
DROP INDEX staging_octane.idx_fk_repository_file_1;
DROP INDEX staging_octane.idx_fk_repository_file_2;
DROP INDEX staging_octane.idx_fk_repository_file_3;
DROP INDEX staging_octane.idx_fkt_repository_file_4;
DROP INDEX staging_octane.idx_fkt_repository_file_5;
DROP INDEX staging_octane.idx_fk_role_1;
DROP INDEX staging_octane.idx_fkt_role_2;
DROP INDEX staging_octane.idx_fk_role_charge_permissions_1;
DROP INDEX staging_octane.idx_fkt_role_charge_permissions_2;
DROP INDEX staging_octane.idx_fk_role_config_export_permission_1;
DROP INDEX staging_octane.idx_fkt_role_config_export_permission_2;
DROP INDEX staging_octane.idx_fk_role_deal_context_1;
DROP INDEX staging_octane.idx_fkt_role_deal_context_2;
DROP INDEX staging_octane.idx_fk_role_export_permission_1;
DROP INDEX staging_octane.idx_fkt_role_export_permission_2;
DROP INDEX staging_octane.idx_fk_role_lender_toolbox_1;
DROP INDEX staging_octane.idx_fkt_role_lender_toolbox_2;
DROP INDEX staging_octane.idx_fk_role_loans_toolbox_1;
DROP INDEX staging_octane.idx_fkt_role_loans_toolbox_2;
DROP INDEX staging_octane.idx_fk_role_performer_assign_1;
DROP INDEX staging_octane.idx_fk_role_performer_assign_2;
DROP INDEX staging_octane.idx_fk_role_report_1;
DROP INDEX staging_octane.idx_fk_role_report_2;
DROP INDEX staging_octane.idx_fk_sap_deal_step_1;
DROP INDEX staging_octane.idx_fk_sap_deal_step_2;
DROP INDEX staging_octane.idx_fk_sap_deal_step_3;
DROP INDEX staging_octane.idx_fk_sap_deal_step_4;
DROP INDEX staging_octane.idx_fk_sap_deal_step_5;
DROP INDEX staging_octane.idx_fk_sap_deal_step_6;
DROP INDEX staging_octane.idx_fk_sap_deal_step_7;
DROP INDEX staging_octane.idx_fk_sap_deal_step_8;
DROP INDEX staging_octane.idx_fk_sap_deal_step_9;
DROP INDEX staging_octane.idx_fk_sap_deal_step_10;
DROP INDEX staging_octane.idx_fk_sap_deal_step_11;
DROP INDEX staging_octane.idx_fk_sap_deal_step_12;
DROP INDEX staging_octane.idx_fk_sap_deal_step_13;
DROP INDEX staging_octane.idx_fkt_sap_deal_step_14;
DROP INDEX staging_octane.idx_fkt_sap_deal_step_15;
DROP INDEX staging_octane.idx_fk_sap_quote_request_1;
DROP INDEX staging_octane.idx_fk_secondary_admin_event_1;
DROP INDEX staging_octane.idx_fk_secondary_admin_event_2;
DROP INDEX staging_octane.idx_fk_secondary_settings_1;
DROP INDEX staging_octane.idx_fk_secondary_settings_2;
DROP INDEX staging_octane.idx_fk_secondary_settings_3;
DROP INDEX staging_octane.idx_fk_secondary_settings_4;
DROP INDEX staging_octane.idx_fk_secondary_settings_5;
DROP INDEX staging_octane.idx_fk_servicer_loan_id_assignment_1;
DROP INDEX staging_octane.idx_fk_servicer_loan_id_assignment_2;
DROP INDEX staging_octane.idx_fk_servicer_loan_id_assignment_3;
DROP INDEX staging_octane.idx_fkt_servicer_loan_id_assignment_4;
DROP INDEX staging_octane.idx_fk_servicer_loan_id_import_request_1;
DROP INDEX staging_octane.idx_fk_servicer_loan_id_import_request_2;
DROP INDEX staging_octane.idx_fkt_servicer_loan_id_import_request_3;
DROP INDEX staging_octane.idx_fk_settlement_agent_1;
DROP INDEX staging_octane.idx_fk_settlement_agent_office_1;
DROP INDEX staging_octane.idx_fkt_settlement_agent_office_2;
DROP INDEX staging_octane.idx_fk_settlement_agent_wire_1;
DROP INDEX staging_octane.idx_fkt_settlement_agent_wire_2;
DROP INDEX staging_octane.idx_fkt_settlement_agent_wire_3;
DROP INDEX staging_octane.idx_fkt_settlement_agent_wire_4;
DROP INDEX staging_octane.idx_fk_site_allowed_ip_1;
DROP INDEX staging_octane.idx_fk_smart_charge_1;
DROP INDEX staging_octane.idx_fk_smart_charge_2;
DROP INDEX staging_octane.idx_fkt_smart_charge_3;
DROP INDEX staging_octane.idx_fkt_smart_charge_4;
DROP INDEX staging_octane.idx_fkt_smart_charge_5;
DROP INDEX staging_octane.idx_fk_smart_charge_case_1;
DROP INDEX staging_octane.idx_fk_smart_charge_case_2;
DROP INDEX staging_octane.idx_fkt_smart_charge_case_3;
DROP INDEX staging_octane.idx_fkt_smart_charge_case_4;
DROP INDEX staging_octane.idx_fkt_smart_charge_case_5;
DROP INDEX staging_octane.idx_fk_smart_charge_group_1;
DROP INDEX staging_octane.idx_fk_smart_charge_group_case_1;
DROP INDEX staging_octane.idx_fk_smart_doc_1;
DROP INDEX staging_octane.idx_fk_smart_doc_2;
DROP INDEX staging_octane.idx_fkt_smart_doc_3;
DROP INDEX staging_octane.idx_fkt_smart_doc_4;
DROP INDEX staging_octane.idx_fkt_smart_doc_5;
DROP INDEX staging_octane.idx_fkt_smart_doc_6;
DROP INDEX staging_octane.idx_fkt_smart_doc_7;
DROP INDEX staging_octane.idx_fkt_smart_doc_8;
DROP INDEX staging_octane.idx_fkt_smart_doc_9;
DROP INDEX staging_octane.idx_fkt_smart_doc_10;
DROP INDEX staging_octane.idx_fkt_smart_doc_11;
DROP INDEX staging_octane.idx_fkt_smart_doc_12;
DROP INDEX staging_octane.idx_fkt_smart_doc_13;
DROP INDEX staging_octane.idx_fkt_smart_doc_14;
DROP INDEX staging_octane.idx_fkt_smart_doc_15;
DROP INDEX staging_octane.idx_fkt_smart_doc_16;
DROP INDEX staging_octane.idx_fkt_smart_doc_17;
DROP INDEX staging_octane.idx_fk_smart_doc_criteria_1;
DROP INDEX staging_octane.idx_fk_smart_doc_criteria_2;
DROP INDEX staging_octane.idx_fkt_smart_doc_criteria_3;
DROP INDEX staging_octane.idx_fk_smart_doc_note_1;
DROP INDEX staging_octane.idx_fk_smart_doc_note_2;
DROP INDEX staging_octane.idx_fk_smart_doc_note_comment_1;
DROP INDEX staging_octane.idx_fk_smart_doc_note_comment_2;
DROP INDEX staging_octane.idx_fk_smart_doc_note_monitor_1;
DROP INDEX staging_octane.idx_fk_smart_doc_note_monitor_2;
DROP INDEX staging_octane.idx_fk_smart_doc_role_1;
DROP INDEX staging_octane.idx_fk_smart_doc_role_2;
DROP INDEX staging_octane.idx_fkt_smart_doc_role_3;
DROP INDEX staging_octane.idx_fk_smart_doc_set_1;
DROP INDEX staging_octane.idx_fkt_smart_doc_set_2;
DROP INDEX staging_octane.idx_fkt_smart_doc_set_3;
DROP INDEX staging_octane.idx_fk_smart_message_1;
DROP INDEX staging_octane.idx_fk_smart_message_2;
DROP INDEX staging_octane.idx_fk_smart_message_3;
DROP INDEX staging_octane.idx_fk_smart_message_4;
DROP INDEX staging_octane.idx_fkt_smart_message_5;
DROP INDEX staging_octane.idx_fkt_smart_message_6;
DROP INDEX staging_octane.idx_fkt_smart_message_7;
DROP INDEX staging_octane.idx_fk_smart_message_recipient_1;
DROP INDEX staging_octane.idx_fk_smart_message_recipient_2;
DROP INDEX staging_octane.idx_fkt_smart_message_recipient_3;
DROP INDEX staging_octane.idx_fkt_smart_message_recipient_4;
DROP INDEX staging_octane.idx_fk_smart_mi_1;
DROP INDEX staging_octane.idx_fkt_smart_mi_2;
DROP INDEX staging_octane.idx_fk_smart_mi_eligibility_case_1;
DROP INDEX staging_octane.idx_fk_smart_mi_eligibility_case_2;
DROP INDEX staging_octane.idx_fk_smart_mi_rate_adjustment_case_1;
DROP INDEX staging_octane.idx_fk_smart_mi_rate_adjustment_case_2;
DROP INDEX staging_octane.idx_fk_smart_mi_rate_card_1;
DROP INDEX staging_octane.idx_fkt_smart_mi_rate_card_2;
DROP INDEX staging_octane.idx_fkt_smart_mi_rate_card_3;
DROP INDEX staging_octane.idx_fk_smart_mi_rate_case_1;
DROP INDEX staging_octane.idx_fk_smart_mi_rate_case_2;
DROP INDEX staging_octane.idx_fk_smart_mi_surcharge_1;
DROP INDEX staging_octane.idx_fk_smart_mi_surcharge_case_1;
DROP INDEX staging_octane.idx_fk_smart_mi_surcharge_case_2;
DROP INDEX staging_octane.idx_fk_smart_req_1;
DROP INDEX staging_octane.idx_fk_smart_req_2;
DROP INDEX staging_octane.idx_fkt_smart_req_3;
DROP INDEX staging_octane.idx_fkt_smart_req_4;
DROP INDEX staging_octane.idx_fk_smart_separator_1;
DROP INDEX staging_octane.idx_fk_smart_separator_2;
DROP INDEX staging_octane.idx_fk_smart_separator_3;
DROP INDEX staging_octane.idx_fk_smart_set_doc_1;
DROP INDEX staging_octane.idx_fk_smart_set_doc_2;
DROP INDEX staging_octane.idx_fk_smart_stack_1;
DROP INDEX staging_octane.idx_fk_smart_stack_doc_1;
DROP INDEX staging_octane.idx_fk_smart_stack_doc_2;
DROP INDEX staging_octane.idx_fk_smart_stack_doc_3;
DROP INDEX staging_octane.idx_fk_smart_stack_doc_4;
DROP INDEX staging_octane.idx_fkt_smart_stack_doc_5;
DROP INDEX staging_octane.idx_fkt_smart_stack_doc_6;
DROP INDEX staging_octane.idx_fk_smart_task_1;
DROP INDEX staging_octane.idx_fk_smart_task_2;
DROP INDEX staging_octane.idx_fk_smart_task_tag_modifier_1;
DROP INDEX staging_octane.idx_fk_smart_task_tag_modifier_2;
DROP INDEX staging_octane.idx_fk_stack_export_file_1;
DROP INDEX staging_octane.idx_fk_stack_export_file_2;
DROP INDEX staging_octane.idx_fkt_stack_export_file_3;
DROP INDEX staging_octane.idx_fk_stack_export_request_1;
DROP INDEX staging_octane.idx_fk_stack_export_request_2;
DROP INDEX staging_octane.idx_fk_stack_export_request_3;
DROP INDEX staging_octane.idx_fkt_stack_export_request_4;
DROP INDEX staging_octane.idx_fkt_stack_export_request_5;
DROP INDEX staging_octane.idx_fkt_stack_export_request_6;
DROP INDEX staging_octane.idx_fkt_stack_export_request_7;
DROP INDEX staging_octane.idx_fk_stripe_payment_1;
DROP INDEX staging_octane.idx_fkt_stripe_payment_2;
DROP INDEX staging_octane.idx_fkt_stripe_payment_3;
DROP INDEX staging_octane.idx_fk_tax_transcript_request_1;
DROP INDEX staging_octane.idx_fk_tax_transcript_request_2;
DROP INDEX staging_octane.idx_fk_tax_transcript_request_3;
DROP INDEX staging_octane.idx_fk_tax_transcript_request_4;
DROP INDEX staging_octane.idx_fk_tax_transcript_request_5;
DROP INDEX staging_octane.idx_fkt_tax_transcript_request_6;
DROP INDEX staging_octane.idx_fkt_tax_transcript_request_7;
DROP INDEX staging_octane.idx_fkt_tax_transcript_request_8;
DROP INDEX staging_octane.idx_fkt_tax_transcript_request_9;
DROP INDEX staging_octane.idx_fkt_tax_transcript_request_10;
DROP INDEX staging_octane.idx_fkt_tax_transcript_request_11;
DROP INDEX staging_octane.idx_fkt_tax_transcript_request_12;
DROP INDEX staging_octane.idx_fkt_tax_transcript_request_13;
DROP INDEX staging_octane.idx_fkt_tax_transcript_request_14;
DROP INDEX staging_octane.idx_fkt_tax_transcript_request_15;
DROP INDEX staging_octane.idx_fk_third_party_community_second_program_1;
DROP INDEX staging_octane.idx_fk_third_party_community_second_program_2;
DROP INDEX staging_octane.idx_fkt_third_party_community_second_program_3;
DROP INDEX staging_octane.idx_fkt_third_party_community_second_program_4;
DROP INDEX staging_octane.idx_fkt_third_party_community_second_program_5;
DROP INDEX staging_octane.idx_fkt_third_party_community_second_program_6;
DROP INDEX staging_octane.idx_fk_title_company_1;
DROP INDEX staging_octane.idx_fk_title_company_office_1;
DROP INDEX staging_octane.idx_fkt_title_company_office_2;
DROP INDEX staging_octane.idx_fk_trade_1;
DROP INDEX staging_octane.idx_fk_trade_2;
DROP INDEX staging_octane.idx_fk_trade_3;
DROP INDEX staging_octane.idx_fkt_trade_4;
DROP INDEX staging_octane.idx_fkt_trade_5;
DROP INDEX staging_octane.idx_fk_trade_audit_1;
DROP INDEX staging_octane.idx_fk_trade_audit_2;
DROP INDEX staging_octane.idx_fkt_trade_audit_3;
DROP INDEX staging_octane.idx_fk_trade_fee_1;
DROP INDEX staging_octane.idx_fk_trade_fee_2;
DROP INDEX staging_octane.idx_fk_trade_fee_type_1;
DROP INDEX staging_octane.idx_fk_trade_file_1;
DROP INDEX staging_octane.idx_fk_trade_file_2;
DROP INDEX staging_octane.idx_fk_trade_lock_filter_1;
DROP INDEX staging_octane.idx_fk_trade_lock_filter_2;
DROP INDEX staging_octane.idx_fk_trade_note_1;
DROP INDEX staging_octane.idx_fk_trade_note_2;
DROP INDEX staging_octane.idx_fk_trade_note_comment_1;
DROP INDEX staging_octane.idx_fk_trade_note_comment_2;
DROP INDEX staging_octane.idx_fk_trade_note_monitor_1;
DROP INDEX staging_octane.idx_fk_trade_note_monitor_2;
DROP INDEX staging_octane.idx_fk_trade_product_1;
DROP INDEX staging_octane.idx_fk_trade_product_2;
DROP INDEX staging_octane.idx_fk_trustee_1;
DROP INDEX staging_octane.idx_fkt_trustee_2;
DROP INDEX staging_octane.idx_fk_unpaid_balance_adjustment_1;
DROP INDEX staging_octane.idx_fk_vendor_document_event_1;
DROP INDEX staging_octane.idx_fk_vendor_document_event_2;
DROP INDEX staging_octane.idx_fkt_vendor_document_event_3;
DROP INDEX staging_octane.idx_fk_vendor_document_repository_file_1;
DROP INDEX staging_octane.idx_fk_vendor_document_repository_file_2;
DROP INDEX staging_octane.idx_fkt_vendor_document_repository_file_3;
DROP INDEX staging_octane.idx_fkt_vendor_document_repository_file_4;
DROP INDEX staging_octane.idx_fkt_vendor_document_repository_file_5;
DROP INDEX staging_octane.idx_fk_view_wf_deal_step_started_1;
DROP INDEX staging_octane.idx_fk_view_wf_deal_step_started_2;
DROP INDEX staging_octane.idx_fk_view_wf_deal_step_started_3;
DROP INDEX staging_octane.idx_fk_view_wf_deal_step_started_4;
DROP INDEX staging_octane.idx_fk_view_wf_deal_step_started_5;
DROP INDEX staging_octane.idx_fkt_view_wf_deal_step_started_6;
DROP INDEX staging_octane.idx_fkt_view_wf_deal_step_started_7;
DROP INDEX staging_octane.idx_fkt_view_wf_deal_step_started_8;
DROP INDEX staging_octane.idx_fk_wf_deal_fork_process_1;
DROP INDEX staging_octane.idx_fk_wf_deal_fork_process_2;
DROP INDEX staging_octane.idx_fk_wf_deal_function_queue_1;
DROP INDEX staging_octane.idx_fk_wf_deal_outcome_1;
DROP INDEX staging_octane.idx_fk_wf_deal_outcome_2;
DROP INDEX staging_octane.idx_fkt_wf_deal_outcome_3;
DROP INDEX staging_octane.idx_fk_wf_deal_process_1;
DROP INDEX staging_octane.idx_fk_wf_deal_process_2;
DROP INDEX staging_octane.idx_fkt_wf_deal_process_3;
DROP INDEX staging_octane.idx_fk_wf_deal_step_1;
DROP INDEX staging_octane.idx_fk_wf_deal_step_2;
DROP INDEX staging_octane.idx_fk_wf_deal_step_3;
DROP INDEX staging_octane.idx_fk_wf_deal_step_4;
DROP INDEX staging_octane.idx_fk_wf_deal_step_5;
DROP INDEX staging_octane.idx_fkt_wf_deal_step_6;
DROP INDEX staging_octane.idx_fkt_wf_deal_step_7;
DROP INDEX staging_octane.idx_fkt_wf_deal_step_8;
DROP INDEX staging_octane.idx_fk_wf_deal_step_timeout_1;
DROP INDEX staging_octane.idx_fk_wf_fork_process_1;
DROP INDEX staging_octane.idx_fk_wf_fork_process_2;
DROP INDEX staging_octane.idx_fk_wf_outcome_1;
DROP INDEX staging_octane.idx_fk_wf_outcome_2;
DROP INDEX staging_octane.idx_fkt_wf_outcome_3;
DROP INDEX staging_octane.idx_fk_wf_phase_1;
DROP INDEX staging_octane.idx_fk_wf_process_1;
DROP INDEX staging_octane.idx_fkt_wf_process_2;
DROP INDEX staging_octane.idx_fkt_wf_process_3;
DROP INDEX staging_octane.idx_fk_wf_step_1;
DROP INDEX staging_octane.idx_fk_wf_step_2;
DROP INDEX staging_octane.idx_fk_wf_step_3;
DROP INDEX staging_octane.idx_fk_wf_step_4;
DROP INDEX staging_octane.idx_fk_wf_step_5;
DROP INDEX staging_octane.idx_fk_wf_step_6;
DROP INDEX staging_octane.idx_fkt_wf_step_7;
DROP INDEX staging_octane.idx_fkt_wf_step_8;
DROP INDEX staging_octane.idx_fkt_wf_step_9;
DROP INDEX staging_octane.idx_fkt_wf_step_10;
DROP INDEX staging_octane.idx_fkt_wf_step_11;
DROP INDEX staging_octane.idx_fkt_wf_step_12;
DROP INDEX staging_octane.idx_fkt_wf_step_13;
DROP INDEX staging_octane.idx_fkt_wf_step_14;
DROP INDEX staging_octane.idx_fkt_wf_step_15;
DROP INDEX staging_octane.idx_fk_wf_step_deal_check_1;
DROP INDEX staging_octane.idx_fkt_wf_step_deal_check_2;
DROP INDEX staging_octane.idx_fkt_wf_step_deal_check_3;
DROP INDEX staging_octane.idx_fk_wf_step_deal_check_definition_1;
DROP INDEX staging_octane.idx_fkt_wf_step_deal_check_definition_2;
DROP INDEX staging_octane.idx_fkt_wf_step_deal_check_definition_3;
DROP INDEX staging_octane.idx_fk_wf_step_deal_check_dependency_1;
DROP INDEX staging_octane.idx_fk_wf_step_deal_check_dependency_2;
DROP INDEX staging_octane.idx_fk_wf_step_deal_tag_modifier_1;
DROP INDEX staging_octane.idx_fk_wf_step_deal_tag_modifier_2;
DROP INDEX staging_octane.fkt_prpd_doc_provider_group_type;
DROP INDEX staging_octane.fkt_prpd_doc_req_fulfill_status_type;
DROP INDEX staging_octane.fkt_prpd_doc_req_decision_status_type;
DROP INDEX staging_octane.fkt_prp_gse_version_type;
DROP INDEX staging_octane.fkt_pl_mixed_use;
DROP INDEX staging_octane.fk_borrower_declarations_1;
DROP INDEX staging_octane.fkt_bdec_fha_secondary_residence;
DROP INDEX staging_octane.fkt_bdec_relationship_with_seller;
DROP INDEX staging_octane.fkt_bdec_borrowed_funds_undisclosed;
DROP INDEX staging_octane.fkt_bdec_other_mortgage_in_progress_before_closing;
DROP INDEX staging_octane.fkt_bdec_applying_for_credit_before_closing;
DROP INDEX staging_octane.fkt_bdec_priority_given_to_another_lien;
DROP INDEX staging_octane.fkt_bdec_cosigner_undisclosed;
DROP INDEX staging_octane.fkt_bdec_currently_delinquent_federal_debt;
DROP INDEX staging_octane.fkt_bdec_party_to_lawsuit;
DROP INDEX staging_octane.fkt_bdec_conveyed_title_in_lieu_of_foreclosure;
DROP INDEX staging_octane.fkt_bdec_completed_pre_foreclosure_short_sale;
DROP INDEX staging_octane.fkt_bdec_property_foreclosure;
DROP INDEX staging_octane.fkt_bdec_bankruptcy_chapter_7;
DROP INDEX staging_octane.fkt_bdec_bankruptcy_chapter_11;
DROP INDEX staging_octane.fkt_bdec_bankruptcy_chapter_12;
DROP INDEX staging_octane.fkt_bdec_bankruptcy_chapter_13;
DROP INDEX staging_octane.fkt_bva_entitled_to_military_based_facilities;
DROP INDEX staging_octane.fkt_bva_one_hundred_percent_disabled_veteran;
DROP INDEX staging_octane.fk_minimum_required_residual_income_row_1;
DROP INDEX staging_octane.fkt_mrir_state_type;
DROP INDEX staging_octane.fkt_b_domestic_relationship_state_type;
DROP INDEX staging_octane.fkt_pl_trust_classification_type;
DROP INDEX staging_octane.fkt_i_secondary_financing_source_type;
DROP INDEX staging_octane.fk_new_lock_only_add_on_1;
DROP INDEX staging_octane.fk_deal_key_roles_18;
DROP INDEX staging_octane.fk_deal_key_roles_19;
DROP INDEX staging_octane.fk_deal_key_roles_20;
DROP INDEX staging_octane.fk_deal_key_roles_21;
DROP INDEX staging_octane.fk_deal_key_roles_22;
DROP INDEX staging_octane.fk_deal_key_roles_23;
DROP INDEX staging_octane.fk_deal_key_roles_24;
DROP INDEX staging_octane.fk_deal_key_roles_25;
DROP INDEX staging_octane.fk_deal_key_roles_26;
DROP INDEX staging_octane.fk_deal_key_roles_27;
DROP INDEX staging_octane.fk_deal_key_roles_28;
DROP INDEX staging_octane.fk_deal_key_roles_29;
DROP INDEX staging_octane.fk_deal_key_roles_30;
DROP INDEX staging_octane.fk_deal_key_roles_31;
DROP INDEX staging_octane.fk_deal_key_roles_32;
DROP INDEX staging_octane.fk_deal_key_roles_33;
DROP INDEX staging_octane.fk_deal_key_roles_34;
DROP INDEX staging_octane.fkt_prp_financed_property_improvements_category_type;
DROP INDEX staging_octane.idx_fkt_account_1;
