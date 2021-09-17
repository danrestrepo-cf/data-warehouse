--
-- EDW | star_loan - prevent dimension ETLs from performing unnecessary updates
-- https://app.asana.com/0/0/1200970669432550
--

ALTER TABLE star_loan.borrower_lending_profile_dim
    DROP COLUMN homeownership_education_complete_date,
    DROP COLUMN property_foreclosure_explanation_flag,
    DROP COLUMN presently_delinquent_explanation_flag,
    DROP COLUMN party_to_lawsuit_explanation_flag,
    DROP COLUMN outstanding_judgments_explanation_flag,
    DROP COLUMN obligated_loan_foreclosure_explanation_flag,
    DROP COLUMN note_endorser_explanation_flag,
    DROP COLUMN borrowed_down_payment_explanation_flag,
    DROP COLUMN bankruptcy_explanation_flag,
    DROP COLUMN alimony_child_support_explanation_flag;

--update borrower_lending_profile_dim zero row to account for table structure changes made above
UPDATE star_loan.borrower_lending_profile_dim
SET data_source_integration_columns = 'alimony_child_support_code~bankruptcy_code~borrowed_down_payment_code~spousal_homestead_code~citizenship_residency_code~dependents_code~first_time_homebuyer_flag~lender_employee_code~lender_employee_status_confirmed_flag~homeowner_past_three_years_code~intend_to_occupy_code~note_endorser_code~obligated_loan_foreclosure_code~outstanding_judgements_code~party_to_lawsuit_code~presently_delinquent_code~property_foreclosure_code~titleholder_code~first_time_homebuyer_auto_compute_flag~on_ldp_list_code~on_gsa_list_code~homeownership_education_code~homeownership_education_agency_code~disabled_code~hud_employee_flag~domestic_relationship_state_code~citizenship_residency~alimony_child_support~bankruptcy~borrowed_down_payment~disabled~dependents~homeowner_past_three_years~intend_to_occupy~lender_employee~note_endorser~obligated_loan_foreclosure~on_gsa_list~on_ldp_list~outstanding_judgements~party_to_lawsuit~presently_delinquent~property_foreclosure~spousal_homestead~titleholder~data_source_dwid'
  , data_source_integration_id = '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
  , edw_modified_datetime = NOW( )
WHERE dwid = 0;

--fix borrower_demographics_dim zero row which was incorrectly overwritten with empty strings in the previous migration
UPDATE star_loan.borrower_demographics_dim
SET data_source_integration_columns = 'sex_refused_code~sex_collected_visual_or_surname_code~sex_male_flag~sex_female_flag~sex_not_obtainable_flag~ethnicity_refused_code~ethnicity_collected_visual_or_surname_code~ethnicity_hispanic_or_latino_flag~ethnicity_mexican_flag~ethnicity_puerto_rican_flag~ethnicity_cuban_flag~ethnicity_other_hispanic_or_latino_flag~ethnicity_not_hispanic_or_latino_flag~ethnicity_not_obtainable_flag~marital_status_code~race_refused_code~race_collected_visual_or_surname_code~race_american_indian_or_alaska_native_flag~race_asian_flag~race_asian_indian_flag~race_chinese_flag~race_filipino_flag~race_japanese_flag~race_korean_flag~race_vietnamese_flag~race_other_asian_flag~race_black_or_african_american_flag~race_information_not_provided_flag~race_national_origin_refusal_flag~race_native_hawaiian_or_other_pacific_islander_flag~race_native_hawaiian_flag~race_guamanian_or_chamorro_flag~race_samoan_flag~race_other_pacific_islander_flag~race_not_obtainable_flag~race_not_applicable_flag~race_white_flag~schooling_years~marital_status~ethnicity_collected_visual_or_surname~sex_collected_visual_or_surname~sex_refused~race_refused~ethnicity_refused~race_collected_visual_or_surname~race_other_pacific_islander_description_flag~data_source_dwid~ethnicity_other_hispanic_or_latino_description_flag~other_race_national_origin_description_flag~race_other_american_indian_or_alaska_native_description_flag~race_other_asian_description_flag'
  , data_source_integration_id = '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
  , edw_modified_datetime = NOW( )
WHERE dwid = 0;
