--
-- EDW | star_loan schema: Add indexes to tables' key lookup fields
-- https://app.asana.com/0/0/1200975391827399
--

CREATE INDEX idx_application_dim__data_source_integration_id
	ON star_loan.application_dim USING btree(data_source_integration_id);

CREATE INDEX idx_borrower_demographics_dim__data_source_integration_id
	ON star_loan.borrower_demographics_dim USING btree(data_source_integration_id);

CREATE INDEX idx_borrower_dim__data_source_integration_id
	ON star_loan.borrower_dim USING btree(data_source_integration_id);

CREATE INDEX idx_borrower_lending_profile_dim__data_source_integration_id
	ON star_loan.borrower_lending_profile_dim USING btree(data_source_integration_id);

CREATE INDEX idx_hmda_purchaser_of_loan_dim__data_source_integration_id
	ON star_loan.hmda_purchaser_of_loan_dim USING btree(data_source_integration_id);

CREATE INDEX idx_interim_funder_dim__data_source_integration_id
	ON star_loan.interim_funder_dim USING btree(data_source_integration_id);

CREATE INDEX idx_investor_dim__data_source_integration_id
	ON star_loan.investor_dim USING btree(data_source_integration_id);

CREATE INDEX idx_lender_user_dim__data_source_integration_id
	ON star_loan.lender_user_dim USING btree(data_source_integration_id);

CREATE INDEX idx_loan_beneficiary_dim__data_source_integration_id
	ON star_loan.loan_beneficiary_dim USING btree(data_source_integration_id);

CREATE INDEX idx_loan_dim__data_source_integration_id
	ON star_loan.loan_dim USING btree(data_source_integration_id);

CREATE INDEX idx_loan_fact__data_source_integration_id
	ON star_loan.loan_fact USING btree(data_source_integration_id);

CREATE INDEX idx_loan_funding_dim__data_source_integration_id
	ON star_loan.loan_funding_dim USING btree(data_source_integration_id);

CREATE INDEX idx_loan_junk_dim__data_source_integration_id
	ON star_loan.loan_junk_dim USING btree(data_source_integration_id);

CREATE INDEX idx_mortgage_insurance_dim__data_source_integration_id
	ON star_loan.mortgage_insurance_dim USING btree(data_source_integration_id);

CREATE INDEX idx_product_choice_dim__data_source_integration_id
	ON star_loan.product_choice_dim USING btree(data_source_integration_id);

CREATE INDEX idx_product_dim__data_source_integration_id
	ON star_loan.product_dim USING btree(data_source_integration_id);

CREATE INDEX idx_product_terms_dim__data_source_integration_id
	ON star_loan.product_terms_dim USING btree(data_source_integration_id);

CREATE INDEX idx_transaction_dim__data_source_integration_id
	ON star_loan.transaction_dim USING btree(data_source_integration_id);

CREATE INDEX idx_transaction_junk_dim__data_source_integration_id
	ON star_loan.transaction_junk_dim USING btree(data_source_integration_id);

--
-- EDW | star_loan - prevent dimension ETLs from performing unnecessary updates
-- https://app.asana.com/0/1199645410972911/1200970669432550/f
--

--fix typo in column name
ALTER TABLE star_loan.product_choice_dim
    RENAME COLUMN prepay_penatly_schedule_code TO prepay_penalty_schedule_code;

--insert/update "zero" rows for dimensions whose zero rows' data_source_integration_columns didn't match the ETL's data_source_integration_columns
UPDATE star_loan.loan_junk_dim
SET data_source_integration_columns = 'buydown_contributor~fha_program~hmda_hoepa_status~lien_priority~lender_concession_candidate_flag~durp_eligibility_opt_out_flag~qualified_mortgage_status_code~qualified_mortgage_flag~lqa_purchase_eligibility_code~student_loan_cash_out_refinance_flag~secondary_clear_to_commit_flag~qm_eligible_flag~hpml_flag~lien_priority_code~buydown_contributor_code~qualifying_rate_code~fha_program_code~fha_principal_write_down_flag~texas_equity_code~texas_equity_auto_code~hmda_hoepa_status_code~lqa_purchase_eligibility~mi_required_flag~qualified_mortgage_status~qualifying_rate~texas_equity_auto~texas_equity~piggyback_flag~data_source_dwid'
  , data_source_integration_id = '~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
WHERE dwid = 0;

UPDATE star_loan.product_choice_dim
SET data_source_integration_columns = 'aus~buydown_schedule~interest_only~aus_code~prepay_penalty_schedule_code~buydown_schedule_code~interest_only_code~mortgage_type_code~mortgage_type~prepay_penalty_schedule~data_source_dwid'
  , data_source_integration_id = '~~~~~~~~~~'
WHERE dwid = 0;

UPDATE star_loan.hmda_purchaser_of_loan_dim
SET data_source_integration_columns = 'value_2017~code_2017~code_2018~value_2018~data_source_dwid'
  , data_source_integration_id = '~~~~'
WHERE dwid = 0;

UPDATE star_loan.transaction_dim
SET data_source_integration_columns = 'deal_pid~active_proposal_pid~data_source_dwid'
  , data_source_integration_id = '~~'
WHERE dwid = 0;

--transaction_junk_dim, borrower_demographics_dim, and borrower_lending_profile_dim are being truncated in QA and Prod as part of the 2021.9.1.3 deploy, so we must do an "upsert" here
INSERT
INTO star_loan.transaction_junk_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, piggyback_flag, mi_required_flag, is_test_loan_flag, structure, loan_purpose, structure_code, loan_purpose_code)
VALUES (0, 0, NOW( ), NOW( ), NULL, 'is_test_loan_flag~loan_purpose~structure_code~mi_required_flag~loan_purpose_code~structure~data_source_dwid~piggyback_flag', '~~~~~~~', NOW( ), NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT ON CONSTRAINT transaction_junk_dim_pkey
    DO UPDATE SET data_source_integration_columns = 'is_test_loan_flag~loan_purpose~structure_code~mi_required_flag~loan_purpose_code~structure~data_source_dwid~piggyback_flag'
                , data_source_integration_id = '~~~~~~~';

INSERT
INTO star_loan.borrower_demographics_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, ethnicity_collected_visual_or_surname, ethnicity_collected_visual_or_surname_code, ethnicity_refused, ethnicity_refused_code, ethnicity_other_hispanic_or_latino_description_flag, other_race_national_origin_description_flag, race_other_american_indian_or_alaska_native_description_flag, race_other_asian_description_flag, race_other_pacific_islander_description_flag, ethnicity_cuban_flag, ethnicity_hispanic_or_latino_flag, ethnicity_mexican_flag, ethnicity_not_hispanic_or_latino_flag, ethnicity_not_obtainable_flag, ethnicity_other_hispanic_or_latino_flag, ethnicity_puerto_rican_flag, race_american_indian_or_alaska_native_flag, race_asian_flag, race_asian_indian_flag, race_black_or_african_american_flag, race_chinese_flag, race_filipino_flag, race_guamanian_or_chamorro_flag, race_information_not_provided_flag, race_japanese_flag, race_korean_flag, race_national_origin_refusal_flag, race_native_hawaiian_flag, race_native_hawaiian_or_other_pacific_islander_flag, race_not_applicable_flag, race_not_obtainable_flag, race_other_asian_flag, race_other_pacific_islander_flag, race_samoan_flag, race_vietnamese_flag, race_white_flag, sex_female_flag, sex_male_flag, sex_not_obtainable_flag, marital_status, marital_status_code, race_collected_visual_or_surname, race_collected_visual_or_surname_code, race_refused, race_refused_code, schooling_years, sex_collected_visual_or_surname, sex_collected_visual_or_surname_code, sex_refused, sex_refused_code)
VALUES (0, 0, NOW( ), NOW( ), NULL, '', '', NOW( ), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT ON CONSTRAINT pk_borrower_demographics_dim
    DO UPDATE SET data_source_integration_columns = 'sex_refused_code~sex_collected_visual_or_surname_code~sex_male_flag~sex_female_flag~sex_not_obtainable_flag~ethnicity_refused_code~ethnicity_collected_visual_or_surname_code~ethnicity_hispanic_or_latino_flag~ethnicity_mexican_flag~ethnicity_puerto_rican_flag~ethnicity_cuban_flag~ethnicity_other_hispanic_or_latino_flag~ethnicity_not_hispanic_or_latino_flag~ethnicity_not_obtainable_flag~marital_status_code~race_refused_code~race_collected_visual_or_surname_code~race_american_indian_or_alaska_native_flag~race_asian_flag~race_asian_indian_flag~race_chinese_flag~race_filipino_flag~race_japanese_flag~race_korean_flag~race_vietnamese_flag~race_other_asian_flag~race_black_or_african_american_flag~race_information_not_provided_flag~race_national_origin_refusal_flag~race_native_hawaiian_or_other_pacific_islander_flag~race_native_hawaiian_flag~race_guamanian_or_chamorro_flag~race_samoan_flag~race_other_pacific_islander_flag~race_not_obtainable_flag~race_not_applicable_flag~race_white_flag~schooling_years~marital_status~ethnicity_collected_visual_or_surname~sex_collected_visual_or_surname~sex_refused~race_refused~ethnicity_refused~race_collected_visual_or_surname~race_other_pacific_islander_description_flag~data_source_dwid~ethnicity_other_hispanic_or_latino_description_flag~other_race_national_origin_description_flag~race_other_american_indian_or_alaska_native_description_flag~race_other_asian_description_flag'
                , data_source_integration_id = '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';

INSERT
INTO star_loan.borrower_lending_profile_dim (dwid, data_source_dwid, edw_created_datetime, edw_modified_datetime, etl_batch_id, data_source_integration_columns, data_source_integration_id, data_source_modified_datetime, alimony_child_support, alimony_child_support_code, bankruptcy, bankruptcy_code, borrowed_down_payment, borrowed_down_payment_code, citizenship_residency, citizenship_residency_code, disabled, disabled_code, domestic_relationship_state, domestic_relationship_state_code, alimony_child_support_explanation_flag, bankruptcy_explanation_flag, borrowed_down_payment_explanation_flag, dependents, dependents_code, note_endorser_explanation_flag, obligated_loan_foreclosure_explanation_flag, outstanding_judgments_explanation_flag, party_to_lawsuit_explanation_flag, presently_delinquent_explanation_flag, property_foreclosure_explanation_flag, homeowner_past_three_years, homeowner_past_three_years_code, homeownership_education, homeownership_education_agency, homeownership_education_agency_code, homeownership_education_code, homeownership_education_complete_date, intend_to_occupy, intend_to_occupy_code, first_time_homebuyer_flag, first_time_homebuyer_auto_compute_flag, hud_employee_flag, lender_employee_status_confirmed_flag, lender_employee, lender_employee_code, note_endorser, note_endorser_code, obligated_loan_foreclosure, obligated_loan_foreclosure_code, on_gsa_list, on_gsa_list_code, on_ldp_list, on_ldp_list_code, outstanding_judgements, outstanding_judgements_code, party_to_lawsuit, party_to_lawsuit_code, presently_delinquent, presently_delinquent_code, property_foreclosure, property_foreclosure_code, spousal_homestead, spousal_homestead_code, titleholder, titleholder_code)
VALUES (0, 0, NOW( ), NOW( ), NULL, 'alimony_child_support_code~bankruptcy_code~borrowed_down_payment_code~spousal_homestead_code~citizenship_residency_code~dependents_code~first_time_homebuyer_flag~lender_employee_code~lender_employee_status_confirmed_flag~homeowner_past_three_years_code~intend_to_occupy_code~note_endorser_code~obligated_loan_foreclosure_code~outstanding_judgements_code~party_to_lawsuit_code~presently_delinquent_code~property_foreclosure_code~titleholder_code~first_time_homebuyer_auto_compute_flag~on_ldp_list_code~on_gsa_list_code~homeownership_education_code~homeownership_education_agency_code~homeownership_education_complete_date~disabled_code~hud_employee_flag~domestic_relationship_state_code~citizenship_residency~alimony_child_support~bankruptcy~borrowed_down_payment~disabled~dependents~homeowner_past_three_years~intend_to_occupy~lender_employee~note_endorser~obligated_loan_foreclosure~on_gsa_list~on_ldp_list~outstanding_judgements~party_to_lawsuit~presently_delinquent~property_foreclosure~spousal_homestead~titleholder~data_source_dwid~property_foreclosure_explanation_flag~presently_delinquent_explanation_flag~party_to_lawsuit_explanation_flag~outstanding_judgments_explanation_flag~obligated_loan_foreclosure_explanation_flag~note_endorser_explanation_flag~borrowed_down_payment_explanation_flag~bankruptcy_explanation_flag~alimony_child_support_explanation_flag', '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', NOW( ), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
ON CONFLICT ON CONSTRAINT pk_borrower_lending_profile_dim
    DO UPDATE SET data_source_integration_columns = 'alimony_child_support_code~bankruptcy_code~borrowed_down_payment_code~spousal_homestead_code~citizenship_residency_code~dependents_code~first_time_homebuyer_flag~lender_employee_code~lender_employee_status_confirmed_flag~homeowner_past_three_years_code~intend_to_occupy_code~note_endorser_code~obligated_loan_foreclosure_code~outstanding_judgements_code~party_to_lawsuit_code~presently_delinquent_code~property_foreclosure_code~titleholder_code~first_time_homebuyer_auto_compute_flag~on_ldp_list_code~on_gsa_list_code~homeownership_education_code~homeownership_education_agency_code~homeownership_education_complete_date~disabled_code~hud_employee_flag~domestic_relationship_state_code~citizenship_residency~alimony_child_support~bankruptcy~borrowed_down_payment~disabled~dependents~homeowner_past_three_years~intend_to_occupy~lender_employee~note_endorser~obligated_loan_foreclosure~on_gsa_list~on_ldp_list~outstanding_judgements~party_to_lawsuit~presently_delinquent~property_foreclosure~spousal_homestead~titleholder~data_source_dwid~property_foreclosure_explanation_flag~presently_delinquent_explanation_flag~party_to_lawsuit_explanation_flag~outstanding_judgments_explanation_flag~obligated_loan_foreclosure_explanation_flag~note_endorser_explanation_flag~borrowed_down_payment_explanation_flag~bankruptcy_explanation_flag~alimony_child_support_explanation_flag'
                , data_source_integration_id = '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~';
