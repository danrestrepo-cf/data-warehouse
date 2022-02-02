--
-- EDW | Octane Type tables with updated values will cause duplicated fact records
-- https://app.asana.com/0/0/1201056914554058
--

/*
 Update each unique dimension's data_source_integration_columns/id to remove domain (type table) "value" fields
 */

--borrower_demographics_dim
UPDATE star_loan.borrower_demographics_dim
SET data_source_integration_columns = 'sex_refused_code~sex_collected_visual_or_surname_code~sex_male_flag~sex_female_flag~sex_not_obtainable_flag~ethnicity_refused_code~ethnicity_collected_visual_or_surname_code~ethnicity_hispanic_or_latino_flag~ethnicity_mexican_flag~ethnicity_puerto_rican_flag~ethnicity_cuban_flag~ethnicity_other_hispanic_or_latino_flag~ethnicity_not_hispanic_or_latino_flag~ethnicity_not_obtainable_flag~marital_status_code~race_refused_code~race_collected_visual_or_surname_code~race_american_indian_or_alaska_native_flag~race_asian_flag~race_asian_indian_flag~race_chinese_flag~race_filipino_flag~race_japanese_flag~race_korean_flag~race_vietnamese_flag~race_other_asian_flag~race_black_or_african_american_flag~race_information_not_provided_flag~race_national_origin_refusal_flag~race_native_hawaiian_or_other_pacific_islander_flag~race_native_hawaiian_flag~race_guamanian_or_chamorro_flag~race_samoan_flag~race_other_pacific_islander_flag~race_not_obtainable_flag~race_not_applicable_flag~race_white_flag~schooling_years~race_other_pacific_islander_description_flag~data_source_dwid~ethnicity_other_hispanic_or_latino_description_flag~other_race_national_origin_description_flag~race_other_american_indian_or_alaska_native_description_flag~race_other_asian_description_flag'
  , data_source_integration_id = COALESCE( CAST( borrower_demographics_dim.sex_refused_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.sex_collected_visual_or_surname_code AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.sex_male_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.sex_female_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.sex_not_obtainable_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.ethnicity_refused_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.ethnicity_collected_visual_or_surname_code AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.ethnicity_hispanic_or_latino_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.ethnicity_mexican_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.ethnicity_puerto_rican_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.ethnicity_cuban_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.ethnicity_other_hispanic_or_latino_flag AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.ethnicity_not_hispanic_or_latino_flag AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.ethnicity_not_obtainable_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.marital_status_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_refused_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_collected_visual_or_surname_code AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_american_indian_or_alaska_native_flag AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_asian_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_asian_indian_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_chinese_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_filipino_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_japanese_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_korean_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_vietnamese_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_other_asian_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_black_or_african_american_flag AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_information_not_provided_flag AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_national_origin_refusal_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_native_hawaiian_or_other_pacific_islander_flag AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_native_hawaiian_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_guamanian_or_chamorro_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_samoan_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_other_pacific_islander_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_not_obtainable_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_not_applicable_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_white_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.schooling_years AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_other_pacific_islander_description_flag AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.data_source_dwid AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.ethnicity_other_hispanic_or_latino_description_flag AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.other_race_national_origin_description_flag AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE(
                                     CAST( borrower_demographics_dim.race_other_american_indian_or_alaska_native_description_flag AS TEXT ),
                                     '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_demographics_dim.race_other_asian_description_flag AS TEXT ), '<NULL>' )
--where condition added to silence warnings about condition-less updates
WHERE TRUE;

--borrower_lending_profile_dim
UPDATE star_loan.borrower_lending_profile_dim
SET data_source_integration_columns = 'alimony_child_support_code~bankruptcy_code~borrowed_down_payment_code~spousal_homestead_code~citizenship_residency_code~dependents_code~first_time_homebuyer_flag~lender_employee_code~lender_employee_status_confirmed_flag~homeowner_past_three_years_code~intend_to_occupy_code~note_endorser_code~obligated_loan_foreclosure_code~outstanding_judgements_code~party_to_lawsuit_code~presently_delinquent_code~property_foreclosure_code~titleholder_code~first_time_homebuyer_auto_compute_flag~on_ldp_list_code~on_gsa_list_code~homeownership_education_code~homeownership_education_agency_code~disabled_code~hud_employee_flag~domestic_relationship_state_code~data_source_dwid'
  , data_source_integration_id = COALESCE( CAST( borrower_lending_profile_dim.alimony_child_support_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.bankruptcy_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.borrowed_down_payment_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.spousal_homestead_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.citizenship_residency_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.dependents_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.first_time_homebuyer_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.lender_employee_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.lender_employee_status_confirmed_flag AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.homeowner_past_three_years_code AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.intend_to_occupy_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.note_endorser_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.obligated_loan_foreclosure_code AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.outstanding_judgements_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.party_to_lawsuit_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.presently_delinquent_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.property_foreclosure_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.titleholder_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.first_time_homebuyer_auto_compute_flag AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.on_ldp_list_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.on_gsa_list_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.homeownership_education_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.homeownership_education_agency_code AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.disabled_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.hud_employee_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.domestic_relationship_state_code AS TEXT ),
                                           '<NULL>' ) || '~' ||
                                 COALESCE( CAST( borrower_lending_profile_dim.data_source_dwid AS TEXT ), '<NULL>' )
--where condition added to silence warnings about condition-less updates
WHERE TRUE;

--hmda_purchaser_of_loan_dim
UPDATE star_loan.hmda_purchaser_of_loan_dim
SET data_source_integration_columns = 'code_2017~code_2018~data_source_dwid'
  , data_source_integration_id = COALESCE( CAST( hmda_purchaser_of_loan_dim.code_2017 AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( hmda_purchaser_of_loan_dim.code_2018 AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( hmda_purchaser_of_loan_dim.data_source_dwid AS TEXT ), '<NULL>' )
--where condition added to silence warnings about condition-less updates
WHERE TRUE;

--loan_junk_dim
UPDATE star_loan.loan_junk_dim
SET data_source_integration_columns = 'lender_concession_candidate_flag~durp_eligibility_opt_out_flag~qualified_mortgage_status_code~qualified_mortgage_flag~lqa_purchase_eligibility_code~student_loan_cash_out_refinance_flag~secondary_clear_to_commit_flag~qm_eligible_flag~hpml_flag~lien_priority_code~buydown_contributor_code~qualifying_rate_code~fha_program_code~fha_principal_write_down_flag~texas_equity_code~texas_equity_auto_code~hmda_hoepa_status_code~mi_required_flag~piggyback_flag~data_source_dwid'
  , data_source_integration_id = COALESCE( CAST( loan_junk_dim.lender_concession_candidate_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.durp_eligibility_opt_out_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.qualified_mortgage_status_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.qualified_mortgage_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.lqa_purchase_eligibility_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.student_loan_cash_out_refinance_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.secondary_clear_to_commit_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.qm_eligible_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.hpml_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.lien_priority_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.buydown_contributor_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.qualifying_rate_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.fha_program_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.fha_principal_write_down_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.texas_equity_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.texas_equity_auto_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.hmda_hoepa_status_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.mi_required_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.piggyback_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST( loan_junk_dim.data_source_dwid AS TEXT ), '<NULL>' )
--where condition added to silence warnings about condition-less updates
WHERE TRUE;

--product_choice_dim
UPDATE star_loan.product_choice_dim
SET data_source_integration_columns = 'aus_code~prepay_penalty_schedule_code~buydown_schedule_code~interest_only_code~mortgage_type_code~data_source_dwid'
  , data_source_integration_id = COALESCE( CAST(product_choice_dim.aus_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST(product_choice_dim.prepay_penalty_schedule_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST(product_choice_dim.buydown_schedule_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST(product_choice_dim.interest_only_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST(product_choice_dim.mortgage_type_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST(product_choice_dim.data_source_dwid AS TEXT ), '<NULL>' )
--where condition added to silence warnings about condition-less updates
WHERE TRUE;

--transaction_junk_dim
UPDATE star_loan.transaction_junk_dim
SET data_source_integration_columns = 'is_test_loan_flag~structure_code~mi_required_flag~loan_purpose_code~data_source_dwid~piggyback_flag'
  , data_source_integration_id = COALESCE( CAST(transaction_junk_dim.is_test_loan_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST(transaction_junk_dim.structure_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST(transaction_junk_dim.mi_required_flag AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST(transaction_junk_dim.loan_purpose_code AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST(transaction_junk_dim.data_source_dwid AS TEXT ), '<NULL>' ) || '~' ||
                                 COALESCE( CAST(transaction_junk_dim.piggyback_flag AS TEXT ), '<NULL>' )
--where condition added to silence warnings about condition-less updates
WHERE TRUE;

/*
 Delete duplicate rows from unique dims and update any loan_fact records that pointed to deleted unique dim rows
 */

--borrower_demographics_dim
WITH delete_query AS (
    DELETE
        FROM star_loan.borrower_demographics_dim
            USING (
                SELECT MAX( all_rows.dwid ) AS current_dwid
                     , duplicates.dwid AS duplicate_dwid
                FROM star_loan.borrower_demographics_dim all_rows
                JOIN star_loan.borrower_demographics_dim duplicates
                     ON all_rows.data_source_integration_id = duplicates.data_source_integration_id
                         AND all_rows.dwid <> duplicates.dwid
                         AND ((all_rows.edw_modified_datetime > duplicates.edw_modified_datetime)
                             OR (all_rows.edw_modified_datetime = duplicates.edw_modified_datetime
                                 AND all_rows.dwid > duplicates.dwid))
                GROUP BY duplicates.dwid
            ) AS duplicates
            WHERE borrower_demographics_dim.dwid = duplicates.duplicate_dwid
            RETURNING duplicates.current_dwid, duplicates.duplicate_dwid
)
UPDATE star_loan.loan_fact
SET b1_borrower_demographics_dwid = delete_query.current_dwid
FROM delete_query
WHERE loan_fact.b1_borrower_demographics_dwid = delete_query.duplicate_dwid;

--borrower_lending_profile_dim
WITH delete_query AS (
    DELETE
        FROM star_loan.borrower_lending_profile_dim
            USING (
                SELECT MAX( all_rows.dwid ) AS current_dwid
                     , duplicates.dwid AS duplicate_dwid
                FROM star_loan.borrower_lending_profile_dim all_rows
                JOIN star_loan.borrower_lending_profile_dim duplicates
                     ON all_rows.data_source_integration_id = duplicates.data_source_integration_id
                         AND all_rows.dwid <> duplicates.dwid
                         AND ((all_rows.edw_modified_datetime > duplicates.edw_modified_datetime)
                             OR (all_rows.edw_modified_datetime = duplicates.edw_modified_datetime
                                 AND all_rows.dwid > duplicates.dwid))
                GROUP BY duplicates.dwid
            ) AS duplicates
            WHERE borrower_lending_profile_dim.dwid = duplicates.duplicate_dwid
            RETURNING duplicates.current_dwid, duplicates.duplicate_dwid
)
UPDATE star_loan.loan_fact
SET b1_borrower_lending_profile_dwid = delete_query.current_dwid
FROM delete_query
WHERE loan_fact.b1_borrower_lending_profile_dwid = delete_query.duplicate_dwid;

--hmda_purchaser_of_loan_dim
WITH delete_query AS (
    DELETE
        FROM star_loan.hmda_purchaser_of_loan_dim
            USING (
                SELECT MAX( all_rows.dwid ) AS current_dwid
                     , duplicates.dwid AS duplicate_dwid
                FROM star_loan.hmda_purchaser_of_loan_dim all_rows
                JOIN star_loan.hmda_purchaser_of_loan_dim duplicates
                     ON all_rows.data_source_integration_id = duplicates.data_source_integration_id
                         AND all_rows.dwid <> duplicates.dwid
                         AND ((all_rows.edw_modified_datetime > duplicates.edw_modified_datetime)
                             OR (all_rows.edw_modified_datetime = duplicates.edw_modified_datetime
                                 AND all_rows.dwid > duplicates.dwid))
                GROUP BY duplicates.dwid
            ) AS duplicates
            WHERE hmda_purchaser_of_loan_dim.dwid = duplicates.duplicate_dwid
            RETURNING duplicates.current_dwid, duplicates.duplicate_dwid
)
UPDATE star_loan.loan_fact
SET hmda_purchaser_of_loan_dwid = delete_query.current_dwid
FROM delete_query
WHERE loan_fact.hmda_purchaser_of_loan_dwid = delete_query.duplicate_dwid;

--loan_junk_dim
WITH delete_query AS (
    DELETE
        FROM star_loan.loan_junk_dim
            USING (
                SELECT MAX( all_rows.dwid ) AS current_dwid
                     , duplicates.dwid AS duplicate_dwid
                FROM star_loan.loan_junk_dim all_rows
                JOIN star_loan.loan_junk_dim duplicates
                     ON all_rows.data_source_integration_id = duplicates.data_source_integration_id
                         AND all_rows.dwid <> duplicates.dwid
                         AND ((all_rows.edw_modified_datetime > duplicates.edw_modified_datetime)
                             OR (all_rows.edw_modified_datetime = duplicates.edw_modified_datetime
                                 AND all_rows.dwid > duplicates.dwid))
                GROUP BY duplicates.dwid
            ) AS duplicates
            WHERE loan_junk_dim.dwid = duplicates.duplicate_dwid
            RETURNING duplicates.current_dwid, duplicates.duplicate_dwid
)
UPDATE star_loan.loan_fact
SET loan_junk_dwid = delete_query.current_dwid
FROM delete_query
WHERE loan_fact.loan_junk_dwid = delete_query.duplicate_dwid;

--product_choice_dim
WITH delete_query AS (
    DELETE
        FROM star_loan.product_choice_dim
            USING (
                SELECT MAX( all_rows.dwid ) AS current_dwid
                     , duplicates.dwid AS duplicate_dwid
                FROM star_loan.product_choice_dim all_rows
                JOIN star_loan.product_choice_dim duplicates
                     ON all_rows.data_source_integration_id = duplicates.data_source_integration_id
                         AND all_rows.dwid <> duplicates.dwid
                         AND ((all_rows.edw_modified_datetime > duplicates.edw_modified_datetime)
                             OR (all_rows.edw_modified_datetime = duplicates.edw_modified_datetime
                                 AND all_rows.dwid > duplicates.dwid))
                GROUP BY duplicates.dwid
            ) AS duplicates
            WHERE product_choice_dim.dwid = duplicates.duplicate_dwid
            RETURNING duplicates.current_dwid, duplicates.duplicate_dwid
)
UPDATE star_loan.loan_fact
SET product_choice_dwid = delete_query.current_dwid
FROM delete_query
WHERE loan_fact.product_choice_dwid = delete_query.duplicate_dwid;

--transaction_junk_dim
WITH delete_query AS (
    DELETE
        FROM star_loan.transaction_junk_dim
            USING (
                SELECT MAX( all_rows.dwid ) AS current_dwid
                     , duplicates.dwid AS duplicate_dwid
                FROM star_loan.transaction_junk_dim all_rows
                JOIN star_loan.transaction_junk_dim duplicates
                     ON all_rows.data_source_integration_id = duplicates.data_source_integration_id
                         AND all_rows.dwid <> duplicates.dwid
                         AND ((all_rows.edw_modified_datetime > duplicates.edw_modified_datetime)
                             OR (all_rows.edw_modified_datetime = duplicates.edw_modified_datetime
                                 AND all_rows.dwid > duplicates.dwid))
                GROUP BY duplicates.dwid
            ) AS duplicates
            WHERE transaction_junk_dim.dwid = duplicates.duplicate_dwid
            RETURNING duplicates.current_dwid, duplicates.duplicate_dwid
)
UPDATE star_loan.loan_fact
SET transaction_junk_dwid = delete_query.current_dwid
FROM delete_query
WHERE loan_fact.transaction_junk_dwid = delete_query.duplicate_dwid;
