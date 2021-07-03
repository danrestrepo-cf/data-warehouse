--
-- EDW | issues from 2021.7.1.1 deploy | lending_profile_dim and loan_lender_user_access
-- https://app.asana.com/0/0/1200549286211279
--

-- Update to table_input_sql for borrower_demographics_dim
-- This includes updates to calculated fields AND data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''sex_refused_code'' || ''~'' || ''sex_collected_visual_or_surname_code'' || ''~'' || ''sex_male_flag'' || ''~'' || ''sex_female_flag'' || ''~'' || ''sex_not_obtainable_flag'' || ''~'' || ''ethnicity_refused_code'' || ''~'' || ''ethnicity_collected_visual_or_surname_code'' || ''~'' || ''ethnicity_hispanic_or_latino_flag'' || ''~'' || ''ethnicity_mexican_flag'' || ''~'' || ''ethnicity_puerto_rican_flag'' || ''~'' || ''ethnicity_cuban_flag'' || ''~'' || ''ethnicity_other_hispanic_or_latino_flag'' || ''~'' || ''ethnicity_not_hispanic_or_latino_flag'' || ''~'' || ''ethnicity_not_obtainable_flag'' || ''~'' || ''marital_status_code'' || ''~'' || ''race_refused_code'' || ''~'' || ''race_collected_visual_or_surname_code'' || ''~'' || ''race_american_indian_or_alaska_native_flag'' || ''~'' || ''race_asian_flag'' || ''~'' || ''race_asian_indian_flag'' || ''~'' || ''race_chinese_flag'' || ''~'' || ''race_filipino_flag'' || ''~'' || ''race_japanese_flag'' || ''~'' || ''race_korean_flag'' || ''~'' || ''race_vietnamese_flag'' || ''~'' || ''race_other_asian_flag'' || ''~'' || ''race_black_or_african_american_flag'' || ''~'' || ''race_information_not_provided_flag'' || ''~'' || ''race_national_origin_refusal_flag'' || ''~'' || ''race_native_hawaiian_or_other_pacific_islander_flag'' || ''~'' || ''race_native_hawaiian_flag'' || ''~'' || ''race_guamanian_or_chamorro_flag'' || ''~'' || ''race_samoan_flag'' || ''~'' || ''race_other_pacific_islander_flag'' || ''~'' || ''race_not_obtainable_flag'' || ''~'' || ''race_not_applicable_flag'' || ''~'' || ''race_white_flag'' || ''~'' || ''schooling_years'' || ''~'' || ''marital_status'' || ''~'' || ''ethnicity_collected_visual_or_surname'' || ''~'' || ''sex_collected_visual_or_surname'' || ''~'' || ''sex_refused'' || ''~'' || ''race_refused'' || ''~'' || ''ethnicity_refused'' || ''~'' || ''race_collected_visual_or_surname'' || ''~'' || ''race_other_pacific_islander_description_flag'' || ''~'' || ''data_source_dwid'' || ''~'' || ''ethnicity_other_hispanic_or_latino_description_flag'' || ''~'' || ''other_race_national_origin_description_flag'' || ''~'' || ''race_other_american_indian_or_alaska_native_description_flag'' || ''~'' || ''race_other_asian_description_flag'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.b_sex_refused as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_sex_collected_visual_or_surname as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_sex_male as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_sex_female as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_sex_not_obtainable as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_ethnicity_refused as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_ethnicity_collected_visual_or_surname as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_ethnicity_hispanic_or_latino as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_ethnicity_mexican as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_ethnicity_puerto_rican as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_ethnicity_cuban as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_ethnicity_other_hispanic_or_latino as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_ethnicity_not_hispanic_or_latino as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_ethnicity_not_obtainable as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_marital_status_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_refused as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_collected_visual_or_surname as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_american_indian_or_alaska_native as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_asian as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_asian_indian as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_chinese as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_filipino as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_japanese as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_korean as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_vietnamese as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_other_asian as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_black_or_african_american as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_information_not_provided as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_national_origin_refusal as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_native_hawaiian_or_other_pacific_islander as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_native_hawaiian as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_guamanian_or_chamorro as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_samoan as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_other_pacific_islander as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_not_obtainable as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_not_applicable as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_white as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_schooling_years as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t134.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t123.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t151.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t152.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t148.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t124.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t147.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_race_other_pacific_islander_description <> '''' as text), ''<NULL>'') || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_ethnicity_other_hispanic_or_latino_description <> '''' AND primary_table.b_ethnicity_other_hispanic_or_latino_description IS NOT NULL as text), ''<NULL>'') || ''~'' || COALESCE(CAST(primary_table.b_other_race_national_origin_description <> '''' AND primary_table.b_other_race_national_origin_description IS NOT NULL as text), ''<NULL>'') || ''~'' || COALESCE(CAST(primary_table.b_race_other_american_indian_or_alaska_native_description <> '''' AND primary_table.b_race_other_american_indian_or_alaska_native_description IS NOT NULL as text), ''<NULL>'') || ''~'' || COALESCE(CAST(primary_table.b_race_other_asian_description <> '''' AND primary_table.b_race_other_asian_description IS NOT NULL as text), ''<NULL>'') as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        primary_table.b_sex_refused as sex_refused_code,
        primary_table.b_sex_collected_visual_or_surname as sex_collected_visual_or_surname_code,
        primary_table.b_sex_male as sex_male_flag,
        primary_table.b_sex_female as sex_female_flag,
        primary_table.b_sex_not_obtainable as sex_not_obtainable_flag,
        primary_table.b_ethnicity_refused as ethnicity_refused_code,
        primary_table.b_ethnicity_collected_visual_or_surname as ethnicity_collected_visual_or_surname_code,
        primary_table.b_ethnicity_hispanic_or_latino as ethnicity_hispanic_or_latino_flag,
        primary_table.b_ethnicity_mexican as ethnicity_mexican_flag,
        primary_table.b_ethnicity_puerto_rican as ethnicity_puerto_rican_flag,
        primary_table.b_ethnicity_cuban as ethnicity_cuban_flag,
        primary_table.b_ethnicity_other_hispanic_or_latino as ethnicity_other_hispanic_or_latino_flag,
        primary_table.b_ethnicity_not_hispanic_or_latino as ethnicity_not_hispanic_or_latino_flag,
        primary_table.b_ethnicity_not_obtainable as ethnicity_not_obtainable_flag,
        primary_table.b_marital_status_type as marital_status_code,
        primary_table.b_race_refused as race_refused_code,
        primary_table.b_race_collected_visual_or_surname as race_collected_visual_or_surname_code,
        primary_table.b_race_american_indian_or_alaska_native as race_american_indian_or_alaska_native_flag,
        primary_table.b_race_asian as race_asian_flag,
        primary_table.b_race_asian_indian as race_asian_indian_flag,
        primary_table.b_race_chinese as race_chinese_flag,
        primary_table.b_race_filipino as race_filipino_flag,
        primary_table.b_race_japanese as race_japanese_flag,
        primary_table.b_race_korean as race_korean_flag,
        primary_table.b_race_vietnamese as race_vietnamese_flag,
        primary_table.b_race_other_asian as race_other_asian_flag,
        primary_table.b_race_black_or_african_american as race_black_or_african_american_flag,
        primary_table.b_race_information_not_provided as race_information_not_provided_flag,
        primary_table.b_race_national_origin_refusal as race_national_origin_refusal_flag,
        primary_table.b_race_native_hawaiian_or_other_pacific_islander as race_native_hawaiian_or_other_pacific_islander_flag,
        primary_table.b_race_native_hawaiian as race_native_hawaiian_flag,
        primary_table.b_race_guamanian_or_chamorro as race_guamanian_or_chamorro_flag,
        primary_table.b_race_samoan as race_samoan_flag,
        primary_table.b_race_other_pacific_islander as race_other_pacific_islander_flag,
        primary_table.b_race_not_obtainable as race_not_obtainable_flag,
        primary_table.b_race_not_applicable as race_not_applicable_flag,
        primary_table.b_race_white as race_white_flag,
        primary_table.b_schooling_years as schooling_years,
        t134.value as marital_status,
        t123.value as ethnicity_collected_visual_or_surname,
        t151.value as sex_collected_visual_or_surname,
        t152.value as sex_refused,
        t148.value as race_refused,
        t124.value as ethnicity_refused,
        t147.value as race_collected_visual_or_surname,
        primary_table.b_race_other_pacific_islander_description <> '''' AND primary_table.b_race_other_pacific_islander_description IS NOT NULL as race_other_pacific_islander_description_flag,
        primary_table.b_ethnicity_other_hispanic_or_latino_description <> '''' AND primary_table.b_ethnicity_other_hispanic_or_latino_description IS NOT NULL as ethnicity_other_hispanic_or_latino_description_flag,
        primary_table.b_other_race_national_origin_description <> '''' AND primary_table.b_other_race_national_origin_description IS NOT NULL as other_race_national_origin_description_flag,
        primary_table.b_race_other_american_indian_or_alaska_native_description <> '''' AND primary_table.b_race_other_american_indian_or_alaska_native_description IS NOT NULL as race_other_american_indian_or_alaska_native_description_flag,
        primary_table.b_race_other_asian_description <> '''' AND primary_table.b_race_other_asian_description IS NOT NULL as race_other_asian_description_flag
 FROM (
    SELECT
        <<borrower_partial_load_condition>> as include_record,
        borrower.*
    FROM history_octane.borrower
        LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid = history_records.b_pid
            AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.b_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<marital_status_type_partial_load_condition>> as include_record,
            marital_status_type.*
            FROM history_octane.marital_status_type
                LEFT JOIN history_octane.marital_status_type AS history_records ON marital_status_type.code = history_records.code
                AND marital_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t134 ON primary_table.b_marital_status_type = t134.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t123 ON primary_table.b_ethnicity_collected_visual_or_surname = t123.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t151 ON primary_table.b_sex_collected_visual_or_surname = t151.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t152 ON primary_table.b_sex_refused = t152.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t148 ON primary_table.b_race_refused = t148.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t124 ON primary_table.b_ethnicity_refused = t124.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t147 ON primary_table.b_race_collected_visual_or_surname = t147.code
 WHERE
    GREATEST(primary_table.include_record, t134.include_record, t123.include_record, t151.include_record, t152.include_record, t148.include_record, t124.include_record, t147.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'borrower_demographics_dim'
);


-- Update to table_input_sql for borrower_lending_profile_dim
-- This includes updates to calculated fields AND data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''alimony_child_support_code'' || ''~'' || ''bankruptcy_code'' || ''~'' || ''borrowed_down_payment_code'' || ''~'' || ''spousal_homestead_code'' || ''~'' || ''citizenship_residency_code'' || ''~'' || ''dependents_code'' || ''~'' || ''first_time_homebuyer_flag'' || ''~'' || ''lender_employee_code'' || ''~'' || ''lender_employee_status_confirmed_flag'' || ''~'' || ''homeowner_past_three_years_code'' || ''~'' || ''intend_to_occupy_code'' || ''~'' || ''note_endorser_code'' || ''~'' || ''obligated_loan_foreclosure_code'' || ''~'' || ''outstanding_judgements_code'' || ''~'' || ''party_to_lawsuit_code'' || ''~'' || ''presently_delinquent_code'' || ''~'' || ''property_foreclosure_code'' || ''~'' || ''titleholder_code'' || ''~'' || ''first_time_homebuyer_auto_compute_flag'' || ''~'' || ''on_ldp_list_code'' || ''~'' || ''on_gsa_list_code'' || ''~'' || ''homeownership_education_code'' || ''~'' || ''homeownership_education_agency_code'' || ''~'' || ''homeownership_education_complete_date'' || ''~'' || ''disabled_code'' || ''~'' || ''hud_employee_flag'' || ''~'' || ''domestic_relationship_state_code'' || ''~'' || ''citizenship_residency'' || ''~'' || ''homeownership_education'' || ''~'' || ''homeownership_education_agency'' || ''~'' || ''domestic_relationship_state'' || ''~'' || ''alimony_child_support'' || ''~'' || ''bankruptcy'' || ''~'' || ''borrowed_down_payment'' || ''~'' || ''disabled'' || ''~'' || ''dependents'' || ''~'' || ''homeowner_past_three_years'' || ''~'' || ''intend_to_occupy'' || ''~'' || ''lender_employee'' || ''~'' || ''note_endorser'' || ''~'' || ''obligated_loan_foreclosure'' || ''~'' || ''on_gsa_list'' || ''~'' || ''on_ldp_list'' || ''~'' || ''outstanding_judgements'' || ''~'' || ''party_to_lawsuit'' || ''~'' || ''presently_delinquent'' || ''~'' || ''property_foreclosure'' || ''~'' || ''spousal_homestead'' || ''~'' || ''titleholder'' || ''~'' || ''data_source_dwid'' || ''~'' || ''property_foreclosure_explanation_flag'' || ''~'' || ''presently_delinquent_explanation_flag'' || ''~'' || ''party_to_lawsuit_explanation_flag'' || ''~'' || ''outstanding_judgments_explanation_flag'' || ''~'' || ''obligated_loan_foreclosure_explanation_flag'' || ''~'' || ''note_endorser_explanation_flag'' || ''~'' || ''borrowed_down_payment_explanation_flag'' || ''~'' || ''bankruptcy_explanation_flag'' || ''~'' || ''alimony_child_support_explanation_flag'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.b_alimony_child_support as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_bankruptcy as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_borrowed_down_payment as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_spousal_homestead as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_citizenship_residency_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_has_dependents as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_first_time_homebuyer as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_lender_employee as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_lender_employee_status_confirmed as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_homeowner_past_three_years as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_intend_to_occupy as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_note_endorser as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_obligated_loan_foreclosure as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_outstanding_judgements as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_party_to_lawsuit as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_presently_delinquent as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_property_foreclosure as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_titleholder as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_first_time_home_buyer_auto_compute as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_on_ldp_list as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_on_gsa_list as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_homeownership_education_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_homeownership_education_agency_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_homeownership_education_complete_date as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_disabled as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_hud_employee as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_domestic_relationship_state_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t119.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t127.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t126.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t122.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t113.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t116.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t117.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t121.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t125.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t128.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t131.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t133.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t135.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t136.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t137.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t138.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t139.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t140.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t143.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t146.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t153.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t154.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.b_property_foreclosure_explanation <> '''' AND primary_table.b_property_foreclosure_explanation IS NOT NULL as text), ''<NULL>'') || ''~'' || COALESCE(CAST(primary_table.b_presently_delinquent_explanation <> '''' AND primary_table.b_presently_delinquent_explanation IS NOT NULL as text), ''<NULL>'') || ''~'' || COALESCE(CAST(primary_table.b_party_to_lawsuit_explanation <> '''' AND primary_table.b_party_to_lawsuit_explanation IS NOT NULL as text), ''<NULL>'') || ''~'' || COALESCE(CAST(primary_table.b_outstanding_judgments_explanation <> '''' AND primary_table.b_outstanding_judgments_explanation IS NOT NULL as text), ''<NULL>'') || ''~'' || COALESCE(CAST(primary_table.b_obligated_loan_foreclosure_explanation <> '''' AND primary_table.b_obligated_loan_foreclosure_explanation IS NOT NULL as text), ''<NULL>'') || ''~'' || COALESCE(CAST(primary_table.b_note_endorser_explanation <> '''' AND primary_table.b_note_endorser_explanation IS NOT NULL as text), ''<NULL>'') || ''~'' || COALESCE(CAST(primary_table.b_borrowed_down_payment_explanation <> '''' AND primary_table.b_borrowed_down_payment_explanation IS NOT NULL as text), ''<NULL>'') || ''~'' || COALESCE(CAST(primary_table.b_bankruptcy_explanation <> '''' AND primary_table.b_bankruptcy_explanation IS NOT NULL as text), ''<NULL>'') || ''~'' || COALESCE(CAST(primary_table.b_alimony_child_support_explanation <> '''' AND primary_table.b_alimony_child_support_explanation IS NOT NULL as text), ''<NULL>'') as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        primary_table.b_alimony_child_support as alimony_child_support_code,
        primary_table.b_bankruptcy as bankruptcy_code,
        primary_table.b_borrowed_down_payment as borrowed_down_payment_code,
        primary_table.b_spousal_homestead as spousal_homestead_code,
        primary_table.b_citizenship_residency_type as citizenship_residency_code,
        primary_table.b_has_dependents as dependents_code,
        primary_table.b_first_time_homebuyer as first_time_homebuyer_flag,
        primary_table.b_lender_employee as lender_employee_code,
        primary_table.b_lender_employee_status_confirmed as lender_employee_status_confirmed_flag,
        primary_table.b_homeowner_past_three_years as homeowner_past_three_years_code,
        primary_table.b_intend_to_occupy as intend_to_occupy_code,
        primary_table.b_note_endorser as note_endorser_code,
        primary_table.b_obligated_loan_foreclosure as obligated_loan_foreclosure_code,
        primary_table.b_outstanding_judgements as outstanding_judgements_code,
        primary_table.b_party_to_lawsuit as party_to_lawsuit_code,
        primary_table.b_presently_delinquent as presently_delinquent_code,
        primary_table.b_property_foreclosure as property_foreclosure_code,
        primary_table.b_titleholder as titleholder_code,
        primary_table.b_first_time_home_buyer_auto_compute as first_time_homebuyer_auto_compute_flag,
        primary_table.b_on_ldp_list as on_ldp_list_code,
        primary_table.b_on_gsa_list as on_gsa_list_code,
        primary_table.b_homeownership_education_type as homeownership_education_code,
        primary_table.b_homeownership_education_agency_type as homeownership_education_agency_code,
        primary_table.b_homeownership_education_complete_date as homeownership_education_complete_date,
        primary_table.b_disabled as disabled_code,
        primary_table.b_hud_employee as hud_employee_flag,
        primary_table.b_domestic_relationship_state_type as domestic_relationship_state_code,
        t119.value as citizenship_residency,
        t127.value as homeownership_education,
        t126.value as homeownership_education_agency,
        t122.value as domestic_relationship_state,
        t113.value as alimony_child_support,
        t116.value as bankruptcy,
        t117.value as borrowed_down_payment,
        t121.value as disabled,
        t125.value as dependents,
        t128.value as homeowner_past_three_years,
        t131.value as intend_to_occupy,
        t133.value as lender_employee,
        t135.value as note_endorser,
        t136.value as obligated_loan_foreclosure,
        t137.value as on_gsa_list,
        t138.value as on_ldp_list,
        t139.value as outstanding_judgements,
        t140.value as party_to_lawsuit,
        t143.value as presently_delinquent,
        t146.value as property_foreclosure,
        t153.value as spousal_homestead,
        t154.value as titleholder,
        primary_table.b_property_foreclosure_explanation <> '''' AND primary_table.b_property_foreclosure_explanation IS NOT NULL as property_foreclosure_explanation_flag,
        primary_table.b_presently_delinquent_explanation <> '''' AND primary_table.b_presently_delinquent_explanation IS NOT NULL as presently_delinquent_explanation_flag,
        primary_table.b_party_to_lawsuit_explanation <> '''' AND primary_table.b_party_to_lawsuit_explanation IS NOT NULL as party_to_lawsuit_explanation_flag,
        primary_table.b_outstanding_judgments_explanation <> '''' AND primary_table.b_outstanding_judgments_explanation IS NOT NULL as outstanding_judgments_explanation_flag,
        primary_table.b_obligated_loan_foreclosure_explanation <> '''' AND primary_table.b_obligated_loan_foreclosure_explanation IS NOT NULL as obligated_loan_foreclosure_explanation_flag,
        primary_table.b_note_endorser_explanation <> '''' AND primary_table.b_note_endorser_explanation IS NOT NULL as note_endorser_explanation_flag,
        primary_table.b_borrowed_down_payment_explanation <> '''' AND primary_table.b_borrowed_down_payment_explanation IS NOT NULL as borrowed_down_payment_explanation_flag,
        primary_table.b_bankruptcy_explanation <> '''' AND primary_table.b_bankruptcy_explanation IS NOT NULL as bankruptcy_explanation_flag,
        primary_table.b_alimony_child_support_explanation <> '''' AND primary_table.b_alimony_child_support_explanation IS NOT NULL as alimony_child_support_explanation_flag
 FROM (
    SELECT
        <<borrower_partial_load_condition>> as include_record,
        borrower.*
    FROM history_octane.borrower
        LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid = history_records.b_pid
            AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.b_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<citizenship_residency_type_partial_load_condition>> as include_record,
            citizenship_residency_type.*
            FROM history_octane.citizenship_residency_type
                LEFT JOIN history_octane.citizenship_residency_type AS history_records ON citizenship_residency_type.code = history_records.code
                AND citizenship_residency_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t119 ON primary_table.b_citizenship_residency_type = t119.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<homeownership_education_type_partial_load_condition>> as include_record,
            homeownership_education_type.*
            FROM history_octane.homeownership_education_type
                LEFT JOIN history_octane.homeownership_education_type AS history_records ON homeownership_education_type.code = history_records.code
                AND homeownership_education_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t127 ON primary_table.b_homeownership_education_type = t127.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<housing_counseling_agency_type_partial_load_condition>> as include_record,
            housing_counseling_agency_type.*
            FROM history_octane.housing_counseling_agency_type
                LEFT JOIN history_octane.housing_counseling_agency_type AS history_records ON housing_counseling_agency_type.code = history_records.code
                AND housing_counseling_agency_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t126 ON primary_table.b_homeownership_education_agency_type = t126.code

    LEFT JOIN (
        SELECT * FROM (
            SELECT     <<state_type_partial_load_condition>> as include_record,
            state_type.*
            FROM history_octane.state_type
                LEFT JOIN history_octane.state_type AS history_records ON state_type.code = history_records.code
                AND state_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t122 ON primary_table.b_domestic_relationship_state_type = t122.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t113 ON primary_table.b_alimony_child_support = t113.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t116 ON primary_table.b_bankruptcy = t116.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t117 ON primary_table.b_borrowed_down_payment = t117.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t121 ON primary_table.b_disabled = t121.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t125 ON primary_table.b_has_dependents = t125.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t128 ON primary_table.b_homeowner_past_three_years = t128.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t131 ON primary_table.b_intend_to_occupy = t131.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t133 ON primary_table.b_lender_employee = t133.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t135 ON primary_table.b_note_endorser = t135.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t136 ON primary_table.b_obligated_loan_foreclosure = t136.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t137 ON primary_table.b_on_gsa_list = t137.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t138 ON primary_table.b_on_ldp_list = t138.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t139 ON primary_table.b_outstanding_judgements = t139.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t140 ON primary_table.b_party_to_lawsuit = t140.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t143 ON primary_table.b_presently_delinquent = t143.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t146 ON primary_table.b_property_foreclosure = t146.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t153 ON primary_table.b_spousal_homestead = t153.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t154 ON primary_table.b_titleholder = t154.code
 WHERE
    GREATEST(primary_table.include_record, t119.include_record, t127.include_record, t126.include_record, t122.include_record, t113.include_record, t116.include_record, t117.include_record, t121.include_record, t125.include_record, t128.include_record, t131.include_record, t133.include_record, t135.include_record, t136.include_record, t137.include_record, t138.include_record, t139.include_record, t140.include_record, t143.include_record, t146.include_record, t153.include_record, t154.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'borrower_lending_profile_dim'
);


-- Update to table_input_sql for loan_dim
-- This includes updates to calculated field AND data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''loan_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.l_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        primary_table.l_last_unprocessed_changes_datetime as last_unprocessed_changes_datetime,
        primary_table.l_locked_price_change_percent as locked_price_change_percent,
        primary_table.l_mi_requirement_ltv_ratio_percent as mi_requirement_ltv_ratio_percent,
        primary_table.l_base_loan_amount_ltv_ratio_percent as base_loan_amount_ltv_ratio_percent,
        primary_table.l_arm_index_current_value_percent as arm_index_current_value_percent,
        primary_table.l_arm_index_datetime as arm_index_datetime,
        primary_table.l_product_terms_pid as product_terms_pid,
        primary_table.l_proposal_pid as proposal_pid,
        primary_table.l_pid as loan_pid,
        primary_table.l_fhac_case_assignment_messages as fhac_case_assignment_messages,
        primary_table.l_product_choice_datetime as product_choice_datetime,
        primary_table.l_fnm_mbs_investor_contract_id as fnm_mbs_investor_contract_id,
        primary_table.l_base_guaranty_fee_percent as base_guaranty_fee_percent,
        primary_table.l_guaranty_fee_percent as guaranty_fee_percent,
        primary_table.l_guaranty_fee_after_alternate_payment_method_percent as guaranty_fee_after_alternate_payment_method_percent,
        primary_table.l_fnm_investor_product_plan_id as fnm_investor_product_plan_id,
        primary_table.l_uldd_loan_comment as uldd_loan_comment,
        primary_table.l_hmda_rate_spread_percent as hmda_rate_spread_percent,
        primary_table.l_hoepa_apr as hoepa_apr,
        primary_table.l_hoepa_rate_spread as hoepa_rate_spread,
        primary_table.l_rate_sheet_undiscounted_rate_percent as rate_sheet_undiscounted_rate_percent,
        primary_table.l_effective_undiscounted_rate_percent as effective_undiscounted_rate_percent,
        CASE WHEN primary_table.l_lien_priority_type IS NULL OR t1317.prp_structure_type IS NULL THEN NULL WHEN primary_table.l_lien_priority_type = ''FIRST'' OR t1317.prp_structure_type = ''STANDALONE_2ND'' THEN t1317.d_los_loan_id_main ELSE t1317.d_los_loan_id_piggyback END as los_loan_number
 FROM (
    SELECT
        <<loan_partial_load_condition>> as include_record,
        loan.*
    FROM history_octane.loan
        LEFT JOIN history_octane.loan AS history_records ON loan.l_pid = history_records.l_pid
            AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.l_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT
            proposal.*
            FROM history_octane.proposal
                LEFT JOIN history_octane.proposal AS history_records ON proposal.prp_pid = history_records.prp_pid
                AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.prp_pid IS NULL
        ) as primary_table

                -- child join start
                INNER JOIN
                (
                    SELECT
                    <<deal_partial_load_condition>> as include_record,
                        deal.*
                    FROM
                        history_octane.deal
                            LEFT JOIN history_octane.deal AS history_records ON deal.d_pid = history_records.d_pid
                                AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
                    WHERE
                        history_records.d_pid IS NULL
                ) AS t1441 ON primary_table.prp_deal_pid = t1441.d_pid
                -- child join end

    ) AS t1317 ON primary_table.l_proposal_pid = t1317.prp_pid
 WHERE
    GREATEST(primary_table.include_record, t1317.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'loan_dim'
);


-- Update to table_input_sql for loan_junk_dim
-- This includes updates to calculated field AND data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''buydown_contributor'' || ''~'' || ''fha_program'' || ''~'' || ''hmda_hoepa_status'' || ''~'' || ''lien_priority'' || ''~'' || ''lender_concession_candidate_flag'' || ''~'' || ''durp_eligibility_opt_out_flag'' || ''~'' || ''qualified_mortgage_status_code'' || ''~'' || ''qualified_mortgage_flag'' || ''~'' || ''lqa_purchase_eligibility_code'' || ''~'' || ''student_loan_cash_out_refinance_flag'' || ''~'' || ''secondary_clear_to_commit_flag'' || ''~'' || ''qm_eligible_flag'' || ''~'' || ''hpml_flag'' || ''~'' || ''lien_priority_code'' || ''~'' || ''buydown_contributor_code'' || ''~'' || ''qualifying_rate_code'' || ''~'' || ''fha_program_code'' || ''~'' || ''fha_principal_write_down_flag'' || ''~'' || ''texas_equity_code'' || ''~'' || ''texas_equity_auto_code'' || ''~'' || ''hmda_hoepa_status_code'' || ''~'' || ''lqa_purchase_eligibility'' || ''~'' || ''mi_required_flag'' || ''~'' || ''qualified_mortgage_status'' || ''~'' || ''qualifying_rate'' || ''~'' || ''texas_equity_auto'' || ''~'' || ''texas_equity'' || ''~'' || ''piggyback_flag'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(t460.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t462.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t463.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t467.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_lender_concession_candidate as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_durp_eligibility_opt_out as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_qualified_mortgage_status_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_qualified_mortgage as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_lqa_purchase_eligibility_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_student_loan_cash_out_refinance as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_secondary_clear_to_commit as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_qm_eligible as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_hpml as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_lien_priority_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_buydown_contributor_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_qualifying_rate_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_fha_program_code_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_fha_principal_write_down as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_texas_equity as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_texas_equity_auto as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_hmda_hoepa_status_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t469.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t1317.prp_mi_required as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t481.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t482.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t484.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t483.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(CASE WHEN primary_table.l_lien_priority_type IS NULL OR t1317.prp_structure_type IS NULL THEN NULL WHEN primary_table.l_lien_priority_type = ''FIRST'' OR t1317.prp_structure_type = ''STANDALONE_2ND'' THEN FALSE ELSE TRUE END as text), ''<NULL>'') || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        t460.value as buydown_contributor,
        t462.value as fha_program,
        t463.value as hmda_hoepa_status,
        t467.value as lien_priority,
        primary_table.l_lender_concession_candidate as lender_concession_candidate_flag,
        primary_table.l_durp_eligibility_opt_out as durp_eligibility_opt_out_flag,
        primary_table.l_qualified_mortgage_status_type as qualified_mortgage_status_code,
        primary_table.l_qualified_mortgage as qualified_mortgage_flag,
        primary_table.l_lqa_purchase_eligibility_type as lqa_purchase_eligibility_code,
        primary_table.l_student_loan_cash_out_refinance as student_loan_cash_out_refinance_flag,
        primary_table.l_secondary_clear_to_commit as secondary_clear_to_commit_flag,
        primary_table.l_qm_eligible as qm_eligible_flag,
        primary_table.l_hpml as hpml_flag,
        primary_table.l_lien_priority_type as lien_priority_code,
        primary_table.l_buydown_contributor_type as buydown_contributor_code,
        primary_table.l_qualifying_rate_type as qualifying_rate_code,
        primary_table.l_fha_program_code_type as fha_program_code,
        primary_table.l_fha_principal_write_down as fha_principal_write_down_flag,
        primary_table.l_texas_equity as texas_equity_code,
        primary_table.l_texas_equity_auto as texas_equity_auto_code,
        primary_table.l_hmda_hoepa_status_type as hmda_hoepa_status_code,
        t469.value as lqa_purchase_eligibility,
        t1317.prp_mi_required as mi_required_flag,
        t481.value as qualified_mortgage_status,
        t482.value as qualifying_rate,
        t484.value as texas_equity_auto,
        t483.value as texas_equity,
        CASE WHEN primary_table.l_lien_priority_type IS NULL OR t1317.prp_structure_type IS NULL THEN NULL WHEN primary_table.l_lien_priority_type = ''FIRST'' OR t1317.prp_structure_type = ''STANDALONE_2ND'' THEN FALSE ELSE TRUE END as piggyback_flag
 FROM (
    SELECT
        <<loan_partial_load_condition>> as include_record,
        loan.*
    FROM history_octane.loan
        LEFT JOIN history_octane.loan AS history_records ON loan.l_pid = history_records.l_pid
            AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.l_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<buydown_contributor_type_partial_load_condition>> as include_record,
            buydown_contributor_type.*
            FROM history_octane.buydown_contributor_type
                LEFT JOIN history_octane.buydown_contributor_type AS history_records ON buydown_contributor_type.code = history_records.code
                AND buydown_contributor_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t460 ON primary_table.l_buydown_contributor_type = t460.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fha_program_code_type_partial_load_condition>> as include_record,
            fha_program_code_type.*
            FROM history_octane.fha_program_code_type
                LEFT JOIN history_octane.fha_program_code_type AS history_records ON fha_program_code_type.code = history_records.code
                AND fha_program_code_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t462 ON primary_table.l_fha_program_code_type = t462.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<hmda_hoepa_status_type_partial_load_condition>> as include_record,
            hmda_hoepa_status_type.*
            FROM history_octane.hmda_hoepa_status_type
                LEFT JOIN history_octane.hmda_hoepa_status_type AS history_records ON hmda_hoepa_status_type.code = history_records.code
                AND hmda_hoepa_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t463 ON primary_table.l_hmda_hoepa_status_type = t463.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<lien_priority_type_partial_load_condition>> as include_record,
            lien_priority_type.*
            FROM history_octane.lien_priority_type
                LEFT JOIN history_octane.lien_priority_type AS history_records ON lien_priority_type.code = history_records.code
                AND lien_priority_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t467 ON primary_table.l_lien_priority_type = t467.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<lqa_purchase_eligibility_type_partial_load_condition>> as include_record,
            lqa_purchase_eligibility_type.*
            FROM history_octane.lqa_purchase_eligibility_type
                LEFT JOIN history_octane.lqa_purchase_eligibility_type AS history_records ON lqa_purchase_eligibility_type.code = history_records.code
                AND lqa_purchase_eligibility_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t469 ON primary_table.l_lqa_purchase_eligibility_type = t469.code

    INNER JOIN (
        SELECT * FROM (
            SELECT
            proposal.*
            FROM history_octane.proposal
                LEFT JOIN history_octane.proposal AS history_records ON proposal.prp_pid = history_records.prp_pid
                AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.prp_pid IS NULL
        ) as primary_table

                -- child join start
                INNER JOIN
                (
                    SELECT
                    <<deal_partial_load_condition>> as include_record,
                        deal.*
                    FROM
                        history_octane.deal
                            LEFT JOIN history_octane.deal AS history_records ON deal.d_pid = history_records.d_pid
                                AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
                    WHERE
                        history_records.d_pid IS NULL
                ) AS t1441 ON primary_table.prp_deal_pid = t1441.d_pid
                -- child join end

    ) AS t1317 ON primary_table.l_proposal_pid = t1317.prp_pid

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<qualified_mortgage_status_type_partial_load_condition>> as include_record,
            qualified_mortgage_status_type.*
            FROM history_octane.qualified_mortgage_status_type
                LEFT JOIN history_octane.qualified_mortgage_status_type AS history_records ON qualified_mortgage_status_type.code = history_records.code
                AND qualified_mortgage_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t481 ON primary_table.l_qualified_mortgage_status_type = t481.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<qualifying_rate_type_partial_load_condition>> as include_record,
            qualifying_rate_type.*
            FROM history_octane.qualifying_rate_type
                LEFT JOIN history_octane.qualifying_rate_type AS history_records ON qualifying_rate_type.code = history_records.code
                AND qualifying_rate_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t482 ON primary_table.l_qualifying_rate_type = t482.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_na_type_partial_load_condition>> as include_record,
            yes_no_na_type.*
            FROM history_octane.yes_no_na_type
                LEFT JOIN history_octane.yes_no_na_type AS history_records ON yes_no_na_type.code = history_records.code
                AND yes_no_na_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t484 ON primary_table.l_texas_equity_auto = t484.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t483 ON primary_table.l_texas_equity = t483.code
        -- ignoring this because the table alias t1317 has already been added: INNER JOIN history_octane.proposal t1317 ON primary_table.l_proposal_pid = t1317.prp_pid
 WHERE
    GREATEST(primary_table.include_record, t460.include_record, t462.include_record, t463.include_record, t467.include_record, t469.include_record, t1317.include_record, t481.include_record, t482.include_record, t484.include_record, t483.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'loan_junk_dim'
);


-- Update to table_input_sql for application_dim
-- This includes updates data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''application_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.apl_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        primary_table.apl_pid as application_pid,
        primary_table.apl_proposal_pid as proposal_pid
 FROM (
    SELECT
        <<application_partial_load_condition>> as include_record,
        application.*
    FROM history_octane.application
        LEFT JOIN history_octane.application AS history_records ON application.apl_pid = history_records.apl_pid
            AND application.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.apl_pid IS NULL
    ) AS primary_table
  WHERE
    GREATEST(primary_table.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'application_dim'
);


-- Update to table_input_sql for borrower_dim
-- This includes updates data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''borrower_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.b_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        t114.value as applicant_role,
        t115.value as application_taken_method,
        primary_table.b_pid as borrower_pid,
        primary_table.b_alimony_child_support_explanation as alimony_child_support_explanation,
        primary_table.b_application_taken_method_type as application_taken_method_code,
        primary_table.b_bankruptcy_explanation as bankruptcy_explanation,
        primary_table.b_birth_date as birth_date,
        primary_table.b_borrowed_down_payment_explanation as borrowed_down_payment_explanation,
        primary_table.b_applicant_role_type as applicant_role_code,
        primary_table.b_required_to_sign as required_to_sign_flag,
        primary_table.b_has_no_ssn as has_no_ssn_flag,
        primary_table.b_credit_report_identifier as credit_report_identifier,
        primary_table.b_credit_report_authorization as credit_report_authorization_flag,
        primary_table.b_dependent_count as dependent_count,
        primary_table.b_dependents_age_years as dependents_age_years,
        primary_table.b_email as email,
        primary_table.b_fax as fax,
        primary_table.b_first_name as first_name,
        primary_table.b_nickname as nickname,
        primary_table.b_ethnicity_other_hispanic_or_latino_description as ethnicity_other_hispanic_or_latino_description,
        primary_table.b_home_phone as home_phone,
        primary_table.b_last_name as last_name,
        primary_table.b_middle_name as middle_name,
        primary_table.b_name_suffix as name_suffix,
        primary_table.b_note_endorser_explanation as note_endorser_explanation,
        primary_table.b_obligated_loan_foreclosure_explanation as obligated_loan_foreclosure_explanation,
        primary_table.b_office_phone as office_phone,
        primary_table.b_office_phone_extension as office_phone_extension,
        primary_table.b_other_race_national_origin_description as other_race_national_origin_description,
        primary_table.b_outstanding_judgments_explanation as outstanding_judgments_explanation,
        primary_table.b_party_to_lawsuit_explanation as party_to_lawsuit_explanation,
        primary_table.b_power_of_attorney as power_of_attorney_code,
        primary_table.b_power_of_attorney_signing_capacity as power_of_attorney_signing_capacity,
        primary_table.b_power_of_attorney_first_name as power_of_attorney_first_name,
        primary_table.b_power_of_attorney_last_name as power_of_attorney_last_name,
        primary_table.b_power_of_attorney_middle_name as power_of_attorney_middle_name,
        primary_table.b_power_of_attorney_name_suffix as power_of_attorney_name_suffix,
        primary_table.b_power_of_attorney_company_name as power_of_attorney_company_name,
        primary_table.b_power_of_attorney_title as power_of_attorney_title,
        primary_table.b_power_of_attorney_office_phone as power_of_attorney_office_phone,
        primary_table.b_power_of_attorney_office_phone_extension as power_of_attorney_office_phone_extension,
        primary_table.b_power_of_attorney_mobile_phone as power_of_attorney_mobile_phone,
        primary_table.b_power_of_attorney_email as power_of_attorney_email,
        primary_table.b_power_of_attorney_fax as power_of_attorney_fax,
        primary_table.b_power_of_attorney_city as power_of_attorney_city,
        primary_table.b_power_of_attorney_country as power_of_attorney_country_code,
        primary_table.b_power_of_attorney_postal_code as power_of_attorney_postal_code,
        primary_table.b_power_of_attorney_state as power_of_attorney_state,
        primary_table.b_power_of_attorney_street1 as power_of_attorney_street1,
        primary_table.b_power_of_attorney_street2 as power_of_attorney_street2,
        primary_table.b_presently_delinquent_explanation as presently_delinquent_explanation,
        primary_table.b_prior_property_title_type as prior_property_title_code,
        primary_table.b_prior_property_usage_type as prior_property_usage_code,
        primary_table.b_property_foreclosure_explanation as property_foreclosure_explanation,
        primary_table.b_race_other_american_indian_or_alaska_native_description as race_other_american_indian_or_alaska_native_description,
        primary_table.b_race_other_asian_description as race_other_asian_description,
        primary_table.b_race_other_pacific_islander_description as race_other_pacific_islander_description,
        primary_table.b_experian_credit_score as experian_credit_score,
        primary_table.b_equifax_credit_score as equifax_credit_score,
        primary_table.b_trans_union_credit_score as trans_union_credit_score,
        primary_table.b_decision_credit_score as decision_credit_score,
        primary_table.b_borrower_tiny_id_type as tiny_id_code,
        primary_table.b_first_time_home_buyer_explain as first_time_homebuyer_explain,
        primary_table.b_caivrs_id as caivrs_id,
        primary_table.b_caivrs_messages as caivrs_messages,
        primary_table.b_monthly_job_federal_tax_amount as monthly_job_federal_tax_amount,
        primary_table.b_monthly_job_state_tax_amount as monthly_job_state_tax_amount,
        primary_table.b_monthly_job_retirement_tax_amount as monthly_job_retirement_tax_amount,
        primary_table.b_monthly_job_medicare_tax_amount as monthly_job_medicare_tax_amount,
        primary_table.b_monthly_job_state_disability_insurance_amount as monthly_job_state_disability_insurance_amount,
        primary_table.b_monthly_job_other_tax_1_amount as monthly_job_other_tax_1_amount,
        primary_table.b_monthly_job_other_tax_1_description as monthly_job_other_tax_1_description,
        primary_table.b_monthly_job_other_tax_2_amount as monthly_job_other_tax_2_amount,
        primary_table.b_monthly_job_other_tax_2_description as monthly_job_other_tax_2_description,
        primary_table.b_monthly_job_other_tax_3_amount as monthly_job_other_tax_3_amount,
        primary_table.b_monthly_job_other_tax_3_description as monthly_job_other_tax_3_description,
        primary_table.b_monthly_job_total_tax_amount as monthly_job_total_tax_amount,
        primary_table.b_homeownership_education_id as homeownership_education_id,
        primary_table.b_homeownership_education_name as homeownership_education_name,
        primary_table.b_housing_counseling_type as housing_counseling_code,
        primary_table.b_housing_counseling_agency_type as housing_counseling_agency_code,
        primary_table.b_housing_counseling_id as housing_counseling_id,
        primary_table.b_housing_counseling_name as housing_counseling_name,
        primary_table.b_housing_counseling_complete_date as housing_counseling_complete_date,
        primary_table.b_legal_entity_type as legal_entity_code,
        primary_table.b_credit_report_authorization_datetime as credit_report_authorization_datetime,
        primary_table.b_credit_report_authorization_method as credit_report_authorization_method_code,
        primary_table.b_credit_report_authorization_obtained_by_unparsed_name as credit_report_authorization_obtained_by_unparsed_name,
        primary_table.b_usda_annual_child_care_expenses as usda_annual_child_care_expenses,
        primary_table.b_usda_disability_expenses as usda_disability_expenses,
        primary_table.b_usda_medical_expenses as usda_medical_expenses,
        primary_table.b_usda_income_from_assets as usda_income_from_assets,
        primary_table.b_usda_moderate_income_limit as usda_moderate_income_limit,
        primary_table.b_relationship_to_primary_borrower_type as relationship_to_primary_borrower_code,
        primary_table.b_relationship_to_seller_type as relationship_to_seller_code,
        primary_table.b_preferred_first_name as preferred_first_name,
        primary_table.b_application_pid as application_pid,
        t149.value as relationship_to_primary_borrower,
        t150.value as relationship_to_seller,
        t118.value as tiny_id,
        t142.value as power_of_attorney_country,
        t120.value as credit_report_authorization_method,
        t129.value as housing_counseling_agency,
        t130.value as housing_counseling,
        t132.value as legal_entity,
        t144.value as prior_property_title,
        t145.value as prior_property_usage,
        t141.value as power_of_attorney
 FROM (
    SELECT
        <<borrower_partial_load_condition>> as include_record,
        borrower.*
    FROM history_octane.borrower
        LEFT JOIN history_octane.borrower AS history_records ON borrower.b_pid = history_records.b_pid
            AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.b_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<applicant_role_type_partial_load_condition>> as include_record,
            applicant_role_type.*
            FROM history_octane.applicant_role_type
                LEFT JOIN history_octane.applicant_role_type AS history_records ON applicant_role_type.code = history_records.code
                AND applicant_role_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t114 ON primary_table.b_applicant_role_type = t114.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<application_taken_method_type_partial_load_condition>> as include_record,
            application_taken_method_type.*
            FROM history_octane.application_taken_method_type
                LEFT JOIN history_octane.application_taken_method_type AS history_records ON application_taken_method_type.code = history_records.code
                AND application_taken_method_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t115 ON primary_table.b_application_taken_method_type = t115.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<borrower_relationship_type_partial_load_condition>> as include_record,
            borrower_relationship_type.*
            FROM history_octane.borrower_relationship_type
                LEFT JOIN history_octane.borrower_relationship_type AS history_records ON borrower_relationship_type.code = history_records.code
                AND borrower_relationship_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t149 ON primary_table.b_relationship_to_primary_borrower_type = t149.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<borrower_relationship_type_partial_load_condition>> as include_record,
            borrower_relationship_type.*
            FROM history_octane.borrower_relationship_type
                LEFT JOIN history_octane.borrower_relationship_type AS history_records ON borrower_relationship_type.code = history_records.code
                AND borrower_relationship_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t150 ON primary_table.b_relationship_to_seller_type = t150.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<borrower_tiny_id_type_partial_load_condition>> as include_record,
            borrower_tiny_id_type.*
            FROM history_octane.borrower_tiny_id_type
                LEFT JOIN history_octane.borrower_tiny_id_type AS history_records ON borrower_tiny_id_type.code = history_records.code
                AND borrower_tiny_id_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t118 ON primary_table.b_borrower_tiny_id_type = t118.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t142 ON primary_table.b_power_of_attorney_country = t142.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<credit_authorization_method_type_partial_load_condition>> as include_record,
            credit_authorization_method_type.*
            FROM history_octane.credit_authorization_method_type
                LEFT JOIN history_octane.credit_authorization_method_type AS history_records ON credit_authorization_method_type.code = history_records.code
                AND credit_authorization_method_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t120 ON primary_table.b_credit_report_authorization_method = t120.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<housing_counseling_agency_type_partial_load_condition>> as include_record,
            housing_counseling_agency_type.*
            FROM history_octane.housing_counseling_agency_type
                LEFT JOIN history_octane.housing_counseling_agency_type AS history_records ON housing_counseling_agency_type.code = history_records.code
                AND housing_counseling_agency_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t129 ON primary_table.b_housing_counseling_agency_type = t129.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<housing_counseling_type_partial_load_condition>> as include_record,
            housing_counseling_type.*
            FROM history_octane.housing_counseling_type
                LEFT JOIN history_octane.housing_counseling_type AS history_records ON housing_counseling_type.code = history_records.code
                AND housing_counseling_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t130 ON primary_table.b_housing_counseling_type = t130.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<legal_entity_type_partial_load_condition>> as include_record,
            legal_entity_type.*
            FROM history_octane.legal_entity_type
                LEFT JOIN history_octane.legal_entity_type AS history_records ON legal_entity_type.code = history_records.code
                AND legal_entity_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t132 ON primary_table.b_legal_entity_type = t132.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<prior_property_title_type_partial_load_condition>> as include_record,
            prior_property_title_type.*
            FROM history_octane.prior_property_title_type
                LEFT JOIN history_octane.prior_property_title_type AS history_records ON prior_property_title_type.code = history_records.code
                AND prior_property_title_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t144 ON primary_table.b_prior_property_title_type = t144.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<property_usage_type_partial_load_condition>> as include_record,
            property_usage_type.*
            FROM history_octane.property_usage_type
                LEFT JOIN history_octane.property_usage_type AS history_records ON property_usage_type.code = history_records.code
                AND property_usage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t145 ON primary_table.b_prior_property_usage_type = t145.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t141 ON primary_table.b_power_of_attorney = t141.code
 WHERE
    GREATEST(primary_table.include_record, t114.include_record, t115.include_record, t149.include_record, t150.include_record, t118.include_record, t142.include_record, t120.include_record, t129.include_record, t130.include_record, t132.include_record, t144.include_record, t145.include_record, t141.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'borrower_dim'
);

-- Update to table_input_sql for hmda_purchaser_of_loan_dim
-- This includes updates data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''value_2017'' || ''~'' || ''code_2017'' || ''~'' || ''code_2018'' || ''~'' || ''value_2018'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(t465.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t465.code as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t464.code as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t464.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        t465.value as value_2017,
        t465.code as code_2017,
        t464.code as code_2018,
        t464.value as value_2018
 FROM (
    SELECT
        <<loan_partial_load_condition>> as include_record,
        loan.*
    FROM history_octane.loan
        LEFT JOIN history_octane.loan AS history_records ON loan.l_pid = history_records.l_pid
            AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.l_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<hmda_purchaser_of_loan_2017_type_partial_load_condition>> as include_record,
            hmda_purchaser_of_loan_2017_type.*
            FROM history_octane.hmda_purchaser_of_loan_2017_type
                LEFT JOIN history_octane.hmda_purchaser_of_loan_2017_type AS history_records ON hmda_purchaser_of_loan_2017_type.code = history_records.code
                AND hmda_purchaser_of_loan_2017_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t465 ON primary_table.l_hmda_purchaser_of_loan_2017_type = t465.code
        -- ignoring this because the table alias t465 has already been added: INNER JOIN history_octane.hmda_purchaser_of_loan_2017_type t465 ON primary_table.l_hmda_purchaser_of_loan_2017_type = t465.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<hmda_purchaser_of_loan_2018_type_partial_load_condition>> as include_record,
            hmda_purchaser_of_loan_2018_type.*
            FROM history_octane.hmda_purchaser_of_loan_2018_type
                LEFT JOIN history_octane.hmda_purchaser_of_loan_2018_type AS history_records ON hmda_purchaser_of_loan_2018_type.code = history_records.code
                AND hmda_purchaser_of_loan_2018_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t464 ON primary_table.l_hmda_purchaser_of_loan_2018_type = t464.code
        -- ignoring this because the table alias t464 has already been added: INNER JOIN history_octane.hmda_purchaser_of_loan_2018_type t464 ON primary_table.l_hmda_purchaser_of_loan_2018_type = t464.code
 WHERE
    GREATEST(primary_table.include_record, t465.include_record, t464.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'hmda_purchaser_of_loan_dim'
);

-- Update to table_input_sql for interim_funder_dim
-- This includes updates data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''interim_funder_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.if_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        t309.value as address_country,
        primary_table.if_pid as interim_funder_pid,
        primary_table.if_company_name as name,
        primary_table.if_company_contact_unparsed_name as contact_unparsed_name,
        primary_table.if_company_address_street1 as address_street1,
        primary_table.if_company_address_street2 as address_street2,
        primary_table.if_company_address_city as address_city,
        primary_table.if_company_address_state as address_state,
        primary_table.if_company_address_postal_code as address_postal_code,
        primary_table.if_company_address_country as address_country_code,
        primary_table.if_company_office_phone as office_phone,
        primary_table.if_company_office_phone_extension as office_phone_extension,
        primary_table.if_company_email as email,
        primary_table.if_company_fax as fax,
        primary_table.if_company_mers_org_id as mers_org_id,
        primary_table.if_remarks as remarks,
        primary_table.if_from_date as from_date,
        primary_table.if_through_date as through_date,
        primary_table.if_reimbursement_wire_credit_to_name as remibursement_wire_credit_to_name,
        primary_table.if_reimbursement_wire_attention_unparsed_name as reimbursement_wire_attention_unparsed_name,
        primary_table.if_reimbursement_wire_authorized_signer_unparsed_name as reimbursement_wire_authorized_signer_unparsed_name,
        primary_table.if_return_wire_credit_to_name as return_wire_credit_to_name,
        primary_table.if_return_wire_authorized_signer_unparsed_name as return_wire_authorized_signer_unparsed_name,
        primary_table.if_fnm_payee_id as fnm_payee_id,
        primary_table.if_interim_funder_mers_registration_type as mers_registration_code,
        primary_table.if_fnm_warehouse_lender_id as fnm_warehouse_lender_id,
        primary_table.if_fre_warehouse_lender_id as fre_warehouse_lender_id,
        primary_table.if_funder_id as id,
        primary_table.if_return_wire_attention_unparsed_name as return_wire_attention_unparsed_name,
        t310.value as mers_registration
 FROM (
    SELECT
        <<interim_funder_partial_load_condition>> as include_record,
        interim_funder.*
    FROM history_octane.interim_funder
        LEFT JOIN history_octane.interim_funder AS history_records ON interim_funder.if_pid = history_records.if_pid
            AND interim_funder.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.if_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t309 ON primary_table.if_company_address_country = t309.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<interim_funder_mers_registration_type_partial_load_condition>> as include_record,
            interim_funder_mers_registration_type.*
            FROM history_octane.interim_funder_mers_registration_type
                LEFT JOIN history_octane.interim_funder_mers_registration_type AS history_records ON interim_funder_mers_registration_type.code = history_records.code
                AND interim_funder_mers_registration_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t310 ON primary_table.if_interim_funder_mers_registration_type = t310.code
 WHERE
    GREATEST(primary_table.include_record, t309.include_record, t310.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'interim_funder_dim'
);

-- Update to table_input_sql for investor_dim
-- This includes updates data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''investor_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.i_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        t318.value as beneficiary_country,
        t319.value as file_delivery_address_country,
        t323.value as investor_country,
        t326.value as loss_payee_country,
        t330.value as servicer_address_country,
        t331.value as sub_servicer_address_country,
        t332.value as when_recorded_mail_to_country,
        t320.value as fnm_investor_remittance,
        t321.value as fnm_mbs_loan_default_loss_party,
        t322.value as fnm_mbs_reo_marketing_party,
        t329.value as secondary_financing_source,
        primary_table.i_investor_country as investor_country_code,
        primary_table.i_investor_postal_code as investor_postal_code,
        primary_table.i_investor_state as investor_state,
        primary_table.i_investor_street1 as investor_street1,
        primary_table.i_investor_street2 as investor_street2,
        primary_table.i_secondary_financing_source_type as secondary_financing_source_code,
        primary_table.i_ein as ein,
        primary_table.i_loss_payee_state as loss_payee_state,
        primary_table.i_loss_payee_postal_code as loss_payee_postal_code,
        primary_table.i_when_recorded_mail_to_country as when_recorded_mail_to_country_code,
        primary_table.i_when_recorded_mail_to_postal_code as when_recorded_mail_to_postal_code,
        primary_table.i_when_recorded_mail_to_state as when_recorded_mail_to_state,
        primary_table.i_when_recorded_mail_to_street1 as when_recorded_mail_to_street1,
        primary_table.i_when_recorded_mail_to_street2 as when_recorded_mail_to_street2,
        primary_table.i_servicer_name as servicer_name,
        primary_table.i_servicer_address_street1 as servicer_address_street1,
        primary_table.i_servicer_address_street2 as servicer_address_street2,
        primary_table.i_servicer_address_city as servicer_address_city,
        primary_table.i_servicer_address_state as servicer_address_state,
        primary_table.i_servicer_address_postal_code as servicer_address_postal_code,
        primary_table.i_servicer_address_country as servicer_address_country_code,
        primary_table.i_sub_servicer_name as sub_servicer_name,
        primary_table.i_sub_servicer_address_street1 as sub_servicer_address_street1,
        primary_table.i_sub_servicer_address_street2 as sub_servicer_address_street2,
        primary_table.i_sub_servicer_address_city as sub_servicer_address_city,
        primary_table.i_sub_servicer_address_state as sub_servicer_address_state,
        primary_table.i_sub_servicer_address_postal_code as sub_servicer_address_postal_code,
        primary_table.i_sub_servicer_address_country as sub_servicer_address_country_code,
        primary_table.i_sub_servicer_mers_org_id as sub_servicer_mers_org_id,
        primary_table.i_file_delivery_name as file_delivery_name,
        primary_table.i_file_delivery_address_street1 as file_delivery_address_street1,
        primary_table.i_file_delivery_address_street2 as file_delivery_address_street2,
        primary_table.i_file_delivery_address_city as file_delivery_address_city,
        primary_table.i_file_delivery_address_state as file_delivery_address_state,
        primary_table.i_file_delivery_address_postal_code as file_delivery_address_postal_code,
        primary_table.i_file_delivery_address_country as file_delivery_address_country_code,
        primary_table.i_initial_beneficiary_candidate as initial_beneficiary_candidate_flag,
        primary_table.i_initial_servicer_candidate as initial_servicer_candidate_flag,
        primary_table.i_mers_org_member as mers_org_member,
        primary_table.i_mers_org_id as mers_org_id,
        primary_table.i_allonge_transfer_to_name as allonge_transfer_to_name,
        primary_table.i_lock_expiration_delivery_subtrahend_days as lock_expiration_delivery_subtrahend_days,
        primary_table.i_loss_payee_country as loss_payee_country_code,
        primary_table.i_loss_payee_city as loss_payee_city,
        primary_table.i_loss_payee_name as loss_payee_name,
        primary_table.i_pid as investor_pid,
        primary_table.i_investor_id as investor_id,
        primary_table.i_website_url as website_url,
        primary_table.i_investor_name as investor_name,
        primary_table.i_investor_city as investor_city,
        primary_table.i_when_recorded_mail_to_city as when_recorded_mail_to_city,
        primary_table.i_maximum_lock_extensions_allowed as maximum_lock_extensions_allowed,
        primary_table.i_maximum_lock_extension_days_allowed as maximum_lock_extension_days_allowed,
        primary_table.i_mortech_investor_id as mortech_investor_id,
        primary_table.i_fnma_servicer_id as fnma_servicer_id,
        primary_table.i_loan_file_delivery_method_type as loan_file_delivery_method_code,
        primary_table.i_mbs_investor as mbs_investor_flag,
        primary_table.i_investor_hmda_purchaser_of_loan_type as investor_hmda_purchaser_of_loan_code,
        primary_table.i_lock_disable_time as investor_lock_disable_time,
        primary_table.i_allow_weekend_holiday_locks as allows_weekend_holiday_locks_flag,
        primary_table.i_nmls_id as nmls_id,
        primary_table.i_nmls_id_applicable as nmls_id_applicable,
        primary_table.i_fnm_investor_remittance_type as fnm_investor_remittance_code,
        primary_table.i_fnm_mbs_investor_remittance_day_of_month as fnm_mbs_investor_remittance_day_of_month,
        primary_table.i_fnm_mbs_loan_default_loss_party_type as fnm_mbs_loan_default_loss_party_code,
        primary_table.i_fnm_mbs_reo_marketing_party_type as fnm_mbs_reo_marketing_party_code,
        primary_table.i_offers_secondary_financing as offers_secondary_financing_flag,
        primary_table.i_beneficiary_street2 as beneficiary_street2,
        primary_table.i_beneficiary_street1 as beneficiary_street1,
        primary_table.i_beneficiary_state as beneficiary_state,
        primary_table.i_beneficiary_postal_code as beneficiary_postal_code,
        primary_table.i_beneficiary_country as beneficiary_country_code,
        primary_table.i_beneficiary_city as beneficiary_city,
        primary_table.i_loss_payee_street1 as loss_payee_street1,
        primary_table.i_loss_payee_street2 as loss_payee_street2,
        primary_table.i_beneficiary_name as beneficiary_name,
        primary_table.i_loss_payee_assignee_name as loss_payee_assignee_name,
        primary_table.i_when_recorded_mail_to_name as when_recorded_mail_to_name,
        t324.value as investor_hmda_purchaser_of_loan,
        t325.value as loan_file_delivery_method
 FROM (
    SELECT
        <<investor_partial_load_condition>> as include_record,
        investor.*
    FROM history_octane.investor
        LEFT JOIN history_octane.investor AS history_records ON investor.i_pid = history_records.i_pid
            AND investor.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.i_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t318 ON primary_table.i_beneficiary_country = t318.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t319 ON primary_table.i_file_delivery_address_country = t319.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t323 ON primary_table.i_investor_country = t323.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t326 ON primary_table.i_loss_payee_country = t326.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t330 ON primary_table.i_servicer_address_country = t330.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t331 ON primary_table.i_sub_servicer_address_country = t331.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t332 ON primary_table.i_when_recorded_mail_to_country = t332.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fnm_investor_remittance_type_partial_load_condition>> as include_record,
            fnm_investor_remittance_type.*
            FROM history_octane.fnm_investor_remittance_type
                LEFT JOIN history_octane.fnm_investor_remittance_type AS history_records ON fnm_investor_remittance_type.code = history_records.code
                AND fnm_investor_remittance_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t320 ON primary_table.i_fnm_investor_remittance_type = t320.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fnm_mbs_loan_default_loss_party_type_partial_load_condition>> as include_record,
            fnm_mbs_loan_default_loss_party_type.*
            FROM history_octane.fnm_mbs_loan_default_loss_party_type
                LEFT JOIN history_octane.fnm_mbs_loan_default_loss_party_type AS history_records ON fnm_mbs_loan_default_loss_party_type.code = history_records.code
                AND fnm_mbs_loan_default_loss_party_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t321 ON primary_table.i_fnm_mbs_loan_default_loss_party_type = t321.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fnm_mbs_reo_marketing_party_type_partial_load_condition>> as include_record,
            fnm_mbs_reo_marketing_party_type.*
            FROM history_octane.fnm_mbs_reo_marketing_party_type
                LEFT JOIN history_octane.fnm_mbs_reo_marketing_party_type AS history_records ON fnm_mbs_reo_marketing_party_type.code = history_records.code
                AND fnm_mbs_reo_marketing_party_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t322 ON primary_table.i_fnm_mbs_reo_marketing_party_type = t322.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<gift_funds_type_partial_load_condition>> as include_record,
            gift_funds_type.*
            FROM history_octane.gift_funds_type
                LEFT JOIN history_octane.gift_funds_type AS history_records ON gift_funds_type.code = history_records.code
                AND gift_funds_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t329 ON primary_table.i_secondary_financing_source_type = t329.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<investor_hmda_purchaser_of_loan_type_partial_load_condition>> as include_record,
            investor_hmda_purchaser_of_loan_type.*
            FROM history_octane.investor_hmda_purchaser_of_loan_type
                LEFT JOIN history_octane.investor_hmda_purchaser_of_loan_type AS history_records ON investor_hmda_purchaser_of_loan_type.code = history_records.code
                AND investor_hmda_purchaser_of_loan_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t324 ON primary_table.i_investor_hmda_purchaser_of_loan_type = t324.code

    LEFT JOIN (
        SELECT * FROM (
            SELECT     <<loan_file_delivery_method_type_partial_load_condition>> as include_record,
            loan_file_delivery_method_type.*
            FROM history_octane.loan_file_delivery_method_type
                LEFT JOIN history_octane.loan_file_delivery_method_type AS history_records ON loan_file_delivery_method_type.code = history_records.code
                AND loan_file_delivery_method_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t325 ON primary_table.i_loan_file_delivery_method_type = t325.code
 WHERE
    GREATEST(primary_table.include_record, t318.include_record, t319.include_record, t323.include_record, t326.include_record, t330.include_record, t331.include_record, t332.include_record, t320.include_record, t321.include_record, t322.include_record, t329.include_record, t324.include_record, t325.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'investor_dim'
);


-- Update to table_input_sql for lender_user_dim
-- This includes updates data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''lender_user_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.lu_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        t454.value as country,
        t455.value as default_credit_bureau,
        primary_table.lu_username as username,
        primary_table.lu_nmls_loan_originator_id as nmls_loan_originator_id,
        primary_table.lu_fha_chums_id as fha_chums_id,
        primary_table.lu_va_agent_id as va_agent_id,
        primary_table.lu_search_text as search_text,
        primary_table.lu_company_user_id as company_user_id,
        primary_table.lu_force_password_change as force_password_change_flag,
        primary_table.lu_last_password_change_date as last_password_change_datetime,
        primary_table.lu_allow_external_ip as allow_external_ip_flag,
        primary_table.lu_total_workload_cap as total_workload_cap,
        primary_table.lu_schedule_once_booking_page_id as schedule_once_booking_page_id,
        primary_table.lu_esign_only as esign_only_flag,
        primary_table.lu_work_step_start_notices_enabled as work_step_start_notices_enabled_flag,
        primary_table.lu_smart_app_enabled as smart_app_enabled_flag,
        primary_table.lu_default_credit_bureau_type as default_credit_bureau_code,
        primary_table.lu_originator_id as originator_id,
        primary_table.lu_name_qualifier as name_qualifier,
        primary_table.lu_training_mode as training_mode_flag,
        primary_table.lu_about_me as about_me,
        primary_table.lu_lender_user_type as type_code,
        primary_table.lu_hire_date as hire_date,
        primary_table.lu_nickname as nickname,
        primary_table.lu_preferred_first_name as preferred_first_name,
        primary_table.lu_hub_directory as hub_directory_flag,
        primary_table.lu_pid as lender_user_pid,
        primary_table.lu_account_owner as account_owner_flag,
        primary_table.lu_create_date as create_date,
        primary_table.lu_first_name as first_name,
        primary_table.lu_last_name as last_name,
        primary_table.lu_middle_name as middle_name,
        primary_table.lu_name_suffix as name_suffix,
        primary_table.lu_company_name as company_name,
        primary_table.lu_title as title,
        primary_table.lu_office_phone as office_phone,
        primary_table.lu_office_phone_extension as office_phone_extension,
        primary_table.lu_email as email,
        primary_table.lu_fax as fax,
        primary_table.lu_city as city,
        primary_table.lu_country as country_code,
        primary_table.lu_postal_code as postal_code,
        primary_table.lu_state as state,
        primary_table.lu_street1 as street1,
        primary_table.lu_street2 as street2,
        primary_table.lu_office_phone_use_branch as office_phone_use_branch_flag,
        primary_table.lu_fax_use_branch as fax_use_branch_flag,
        primary_table.lu_address_use_branch as address_use_branch_flag,
        primary_table.lu_start_date as start_date,
        primary_table.lu_through_date as through_date,
        primary_table.lu_time_zone as time_zone_code,
        primary_table.lu_unparsed_name as unparsed_name,
        primary_table.lu_lender_user_status_type as status_code,
        t456.value as status,
        t457.value as type,
        t458.value as time_zone
 FROM (
    SELECT
        <<lender_user_partial_load_condition>> as include_record,
        lender_user.*
    FROM history_octane.lender_user
        LEFT JOIN history_octane.lender_user AS history_records ON lender_user.lu_pid = history_records.lu_pid
            AND lender_user.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.lu_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<country_type_partial_load_condition>> as include_record,
            country_type.*
            FROM history_octane.country_type
                LEFT JOIN history_octane.country_type AS history_records ON country_type.code = history_records.code
                AND country_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t454 ON primary_table.lu_country = t454.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<credit_bureau_type_partial_load_condition>> as include_record,
            credit_bureau_type.*
            FROM history_octane.credit_bureau_type
                LEFT JOIN history_octane.credit_bureau_type AS history_records ON credit_bureau_type.code = history_records.code
                AND credit_bureau_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t455 ON primary_table.lu_default_credit_bureau_type = t455.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<lender_user_status_type_partial_load_condition>> as include_record,
            lender_user_status_type.*
            FROM history_octane.lender_user_status_type
                LEFT JOIN history_octane.lender_user_status_type AS history_records ON lender_user_status_type.code = history_records.code
                AND lender_user_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t456 ON primary_table.lu_lender_user_status_type = t456.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<lender_user_type_partial_load_condition>> as include_record,
            lender_user_type.*
            FROM history_octane.lender_user_type
                LEFT JOIN history_octane.lender_user_type AS history_records ON lender_user_type.code = history_records.code
                AND lender_user_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t457 ON primary_table.lu_lender_user_type = t457.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<time_zone_type_partial_load_condition>> as include_record,
            time_zone_type.*
            FROM history_octane.time_zone_type
                LEFT JOIN history_octane.time_zone_type AS history_records ON time_zone_type.code = history_records.code
                AND time_zone_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t458 ON primary_table.lu_time_zone = t458.code
 WHERE
    GREATEST(primary_table.include_record, t454.include_record, t455.include_record, t456.include_record, t457.include_record, t458.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'lender_user_dim'
);

-- Update to table_input_sql for loan_beneficiary_dim
-- This includes updates data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''loan_beneficiary_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.lb_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        t347.value as collateral_courier,
        t351.value as loan_file_courier,
        t348.value as delivery_aus,
        primary_table.lb_mers_mom as mers_mom_flag,
        primary_table.lb_pid as loan_beneficiary_pid,
        primary_table.lb_mers_transfer_status_type as mers_transfer_status_code,
        primary_table.lb_mers_transfer_override as mers_transfer_override_flag,
        primary_table.lb_loan_file_courier_type as loan_file_courier_code,
        primary_table.lb_collateral_courier_type as collateral_courier_code,
        primary_table.lb_loan_pid as loan_pid,
        primary_table.lb_delivery_aus_type as delivery_aus_code,
        primary_table.lb_early_funding as early_funding_code,
        primary_table.lb_pool_id as pool_id,
        primary_table.lb_loan_file_delivery_method_type as loan_file_delivery_method_code,
        primary_table.lb_loan_benef_transfer_status_type as transfer_status_code,
        primary_table.lb_initial as initial_flag,
        primary_table.lb_current as current_flag,
        primary_table.lb_investor_loan_id as investor_loan_id,
        t350.value as transfer_status,
        t352.value as loan_file_delivery_method,
        t353.value as mers_transfer_status,
        t349.value as early_funding
 FROM (
    SELECT
        <<loan_beneficiary_partial_load_condition>> as include_record,
        loan_beneficiary.*
    FROM history_octane.loan_beneficiary
        LEFT JOIN history_octane.loan_beneficiary AS history_records ON loan_beneficiary.lb_pid = history_records.lb_pid
            AND loan_beneficiary.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.lb_pid IS NULL
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

    ) AS t347 ON primary_table.lb_collateral_courier_type = t347.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<courier_type_partial_load_condition>> as include_record,
            courier_type.*
            FROM history_octane.courier_type
                LEFT JOIN history_octane.courier_type AS history_records ON courier_type.code = history_records.code
                AND courier_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t351 ON primary_table.lb_loan_file_courier_type = t351.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<delivery_aus_type_partial_load_condition>> as include_record,
            delivery_aus_type.*
            FROM history_octane.delivery_aus_type
                LEFT JOIN history_octane.delivery_aus_type AS history_records ON delivery_aus_type.code = history_records.code
                AND delivery_aus_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t348 ON primary_table.lb_delivery_aus_type = t348.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<loan_benef_transfer_status_type_partial_load_condition>> as include_record,
            loan_benef_transfer_status_type.*
            FROM history_octane.loan_benef_transfer_status_type
                LEFT JOIN history_octane.loan_benef_transfer_status_type AS history_records ON loan_benef_transfer_status_type.code = history_records.code
                AND loan_benef_transfer_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t350 ON primary_table.lb_loan_benef_transfer_status_type = t350.code

    LEFT JOIN (
        SELECT * FROM (
            SELECT     <<loan_file_delivery_method_type_partial_load_condition>> as include_record,
            loan_file_delivery_method_type.*
            FROM history_octane.loan_file_delivery_method_type
                LEFT JOIN history_octane.loan_file_delivery_method_type AS history_records ON loan_file_delivery_method_type.code = history_records.code
                AND loan_file_delivery_method_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t352 ON primary_table.lb_loan_file_delivery_method_type = t352.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mers_transfer_status_type_partial_load_condition>> as include_record,
            mers_transfer_status_type.*
            FROM history_octane.mers_transfer_status_type
                LEFT JOIN history_octane.mers_transfer_status_type AS history_records ON mers_transfer_status_type.code = history_records.code
                AND mers_transfer_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t353 ON primary_table.lb_mers_transfer_status_type = t353.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
            yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
                LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t349 ON primary_table.lb_early_funding = t349.code
 WHERE
    GREATEST(primary_table.include_record, t347.include_record, t351.include_record, t348.include_record, t350.include_record, t352.include_record, t353.include_record, t349.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'loan_beneficiary_dim'
);

-- Update to table_input_sql for loan_funding_dim
-- This includes updates data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''loan_funding_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.lf_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
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
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'loan_funding_dim'
);


-- Update to table_input_sql for loan_lender_user_access
-- This includes updates data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT NOW( ) AS edw_created_datetime
     , NOW( ) AS edw_modified_datetime
     , ''dlu_lender_user_pid~d_pid~prp_pid~l_pid~data_source_dwid'' AS data_source_integration_columns
     , COALESCE(CAST(deal_lender_user.dlu_lender_user_pid as text), ''<NULL>'') || ''~'' ||
       COALESCE(CAST(deal.d_pid as text), ''<NULL>'') || ''~'' ||
       COALESCE(CAST(proposal.prp_pid as text), ''<NULL>'') || ''~'' ||
       COALESCE(CAST(loan.l_pid as text), ''<NULL>'') || ''~'' ||
       COALESCE(''1'', ''<NULL>'') AS data_source_integration_id
     , deal_lender_user.data_source_updated_datetime AS data_source_modified_datetime
     , deal_lender_user.dlu_lender_user_pid AS lender_user_pid
     , loan_fact.loan_dwid
FROM (
         SELECT <<loan_fact_partial_load_condition>> AS include_record
              , loan_fact.*
         FROM star_loan.loan_fact
     ) AS loan_fact
-- join to loan
         JOIN (
    SELECT <<loan_partial_load_condition>> AS include_record
         , loan.*
    FROM history_octane.loan
             LEFT JOIN history_octane.loan history_records
                       ON loan.l_pid = history_records.l_pid
                           AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.l_pid IS NULL
      AND loan.data_source_deleted_flag = FALSE
) AS loan
              ON loan.l_pid = loan_fact.loan_pid
                  AND loan_fact.data_source_dwid = 1
-- join to proposal
         JOIN (
    SELECT <<proposal_partial_load_condition>> AS include_record
         , proposal.*
    FROM history_octane.proposal
             LEFT JOIN history_octane.proposal history_records
                       ON proposal.prp_pid = history_records.prp_pid
                           AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.prp_pid IS NULL
      AND proposal.data_source_deleted_flag = FALSE
      AND proposal.prp_proposal_type = ''ACTIVE''
) AS proposal
              ON proposal.prp_pid = loan.l_proposal_pid
-- join to deal
         JOIN (
    SELECT <<deal_partial_load_condition>> AS include_record
         , deal.*
    FROM history_octane.deal
             LEFT JOIN history_octane.deal history_records
                       ON deal.d_pid = history_records.d_pid
                           AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.d_pid IS NULL
      AND deal.data_source_deleted_flag = FALSE
) AS deal
              ON deal.d_pid = proposal.prp_deal_pid
-- join to deal_lender_user
         JOIN (
    -- selecting *distinct* pairs of deal/lender_user from a table at a lower granularity than loan_lender_user_access
    -- using a GROUP BY instead of DISTINCT because we need the maximum data_source_updated_datetime as well as the deal/lender_user pair
    -- using BOOL_OR because MAX doesn''t work for boolean arguments
    SELECT BOOL_OR( <<deal_lender_user_partial_load_condition>> ) AS include_record
         , deal_lender_user.dlu_deal_pid
         , deal_lender_user.dlu_lender_user_pid
         , MAX( deal_lender_user.data_source_updated_datetime ) AS data_source_updated_datetime
    FROM history_octane.deal_lender_user
             LEFT JOIN history_octane.deal_lender_user history_records
                       ON deal_lender_user.dlu_pid = history_records.dlu_pid
                           AND deal_lender_user.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.dlu_pid IS NULL
      AND deal_lender_user.data_source_deleted_flag = FALSE
    GROUP BY deal_lender_user.dlu_deal_pid, deal_lender_user.dlu_lender_user_pid
) AS deal_lender_user
              ON deal_lender_user.dlu_deal_pid = deal.d_pid
-- join to loan_lender_user_access to ensure no duplicate lender_user - loan pairings are inserted
         LEFT JOIN star_loan.loan_lender_user_access
                   ON loan_lender_user_access.lender_user_pid = deal_lender_user.dlu_lender_user_pid
                       AND loan_lender_user_access.loan_dwid = loan_fact.loan_dwid
                       AND loan_lender_user_access.data_source_dwid = 1
WHERE loan_lender_user_access.dwid IS NULL
  AND GREATEST( loan_fact.include_record, loan.include_record, proposal.include_record, deal.include_record,
                deal_lender_user.include_record ) = TRUE;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.table_output_step ON process.dwid = table_output_step.process_dwid
        AND table_output_step.target_schema = 'star_loan'
        AND table_output_step.target_table = 'loan_lender_user_access'
);

-- Update to table_input_sql for mortgage_insurance_dim
-- This includes updates data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''loan_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.l_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        primary_table.l_mi_rate_quote_id as mi_rate_quote_id,
        primary_table.l_mi_base_upfront_payment_amount as mi_base_upfront_payment_amount,
        primary_table.l_mi_base_monthly_payment_amount as mi_base_monthly_payment_amount,
        primary_table.l_mi_base_upfront_percent as mi_base_upfront_percent,
        primary_table.l_mi_base_monthly_payment_annual_percent as mi_base_monthly_payment_annual_percent,
        primary_table.l_mi_base_rate_label as mi_base_rate_label,
        primary_table.l_mi_renewal_calculated_rate_type as mi_renewal_calculated_rate_code,
        primary_table.l_mi_initial_calculated_rate_type as mi_initial_calculated_rate_code,
        primary_table.l_mi_initial_monthly_payment_annual_percent as mi_initial_monthly_payment_annual_percent,
        primary_table.l_mi_initial_duration_months as mi_initial_duration_months,
        primary_table.l_mi_renewal_monthly_payment_amount as mi_renewal_monthly_payment_amount,
        primary_table.l_mi_renewal_monthly_payment_annual_percent as mi_renewal_monthly_payment_annual_percent,
        primary_table.l_mi_initial_monthly_payment_amount as mi_initial_monthly_payment_amount,
        primary_table.l_mi_upfront_percent as mi_upront_percent,
        primary_table.l_mi_upfront_amount as mi_upfront_amount,
        primary_table.l_mi_payment_type as mi_payment_code,
        primary_table.l_mi_actual_monthly_payment_count as mi_actual_monthly_payment_count,
        primary_table.l_mi_required_monthly_payment_count as mi_required_monthly_payment_count,
        primary_table.l_mi_midpoint_cutoff_required as mi_midpoint_cutoff_required_flag,
        primary_table.l_mi_ltv_cutoff_percent as mi_ltv_cutoff_percent,
        primary_table.l_mi_coverage_percent as mi_coverage_percent,
        primary_table.l_mi_payer_type as mi_payer_code,
        primary_table.l_mi_renewal_calculation_type as mi_renewal_calculation_code,
        primary_table.l_mi_initial_calculation_type as mi_initial_calculation_code,
        primary_table.l_mi_premium_refundable_type as mi_premium_refundable_code,
        primary_table.l_mi_certificate_id as mi_certificate_id,
        primary_table.l_mi_company_name_type as mi_company_code,
        primary_table.l_mi_input_type as mi_input_code,
        primary_table.l_mi_no_mi_product as no_mi_product_flag,
        primary_table.l_mi_auto_compute as mi_auto_compute_flag,
        primary_table.l_pid as loan_pid,
        primary_table.l_mi_lender_paid_rate_adjustment_percent as mi_lender_paid_rate_adjustment_percent,
        t471.value as mi_initial_calculated_rate,
        t477.value as mi_renewal_calcuated_rate,
        t470.value as mi_company,
        t472.value as mi_initial_calculation,
        t473.value as mi_input,
        t474.value as mi_payer,
        t475.value as mi_payment,
        t476.value as mi_premium_refundable,
        t478.value as mi_renewal_calculation,
        t1739.dwid as loan_dwid
 FROM (
    SELECT
        <<loan_partial_load_condition>> as include_record,
        loan.*
    FROM history_octane.loan
        LEFT JOIN history_octane.loan AS history_records ON loan.l_pid = history_records.l_pid
            AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.l_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_calculated_rate_type_partial_load_condition>> as include_record,
            mi_calculated_rate_type.*
            FROM history_octane.mi_calculated_rate_type
                LEFT JOIN history_octane.mi_calculated_rate_type AS history_records ON mi_calculated_rate_type.code = history_records.code
                AND mi_calculated_rate_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t471 ON primary_table.l_mi_initial_calculated_rate_type = t471.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_calculated_rate_type_partial_load_condition>> as include_record,
            mi_calculated_rate_type.*
            FROM history_octane.mi_calculated_rate_type
                LEFT JOIN history_octane.mi_calculated_rate_type AS history_records ON mi_calculated_rate_type.code = history_records.code
                AND mi_calculated_rate_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t477 ON primary_table.l_mi_renewal_calculated_rate_type = t477.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_company_name_type_partial_load_condition>> as include_record,
            mi_company_name_type.*
            FROM history_octane.mi_company_name_type
                LEFT JOIN history_octane.mi_company_name_type AS history_records ON mi_company_name_type.code = history_records.code
                AND mi_company_name_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t470 ON primary_table.l_mi_company_name_type = t470.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_initial_calculation_type_partial_load_condition>> as include_record,
            mi_initial_calculation_type.*
            FROM history_octane.mi_initial_calculation_type
                LEFT JOIN history_octane.mi_initial_calculation_type AS history_records ON mi_initial_calculation_type.code = history_records.code
                AND mi_initial_calculation_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t472 ON primary_table.l_mi_initial_calculation_type = t472.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_input_type_partial_load_condition>> as include_record,
            mi_input_type.*
            FROM history_octane.mi_input_type
                LEFT JOIN history_octane.mi_input_type AS history_records ON mi_input_type.code = history_records.code
                AND mi_input_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t473 ON primary_table.l_mi_input_type = t473.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_payer_type_partial_load_condition>> as include_record,
            mi_payer_type.*
            FROM history_octane.mi_payer_type
                LEFT JOIN history_octane.mi_payer_type AS history_records ON mi_payer_type.code = history_records.code
                AND mi_payer_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t474 ON primary_table.l_mi_payer_type = t474.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_payment_type_partial_load_condition>> as include_record,
            mi_payment_type.*
            FROM history_octane.mi_payment_type
                LEFT JOIN history_octane.mi_payment_type AS history_records ON mi_payment_type.code = history_records.code
                AND mi_payment_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t475 ON primary_table.l_mi_payment_type = t475.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_premium_refundable_type_partial_load_condition>> as include_record,
            mi_premium_refundable_type.*
            FROM history_octane.mi_premium_refundable_type
                LEFT JOIN history_octane.mi_premium_refundable_type AS history_records ON mi_premium_refundable_type.code = history_records.code
                AND mi_premium_refundable_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t476 ON primary_table.l_mi_premium_refundable_type = t476.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mi_renewal_calculation_type_partial_load_condition>> as include_record,
            mi_renewal_calculation_type.*
            FROM history_octane.mi_renewal_calculation_type
                LEFT JOIN history_octane.mi_renewal_calculation_type AS history_records ON mi_renewal_calculation_type.code = history_records.code
                AND mi_renewal_calculation_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t478 ON primary_table.l_mi_renewal_calculation_type = t478.code

    INNER JOIN (
        SELECT
                <<loan_dim_partial_load_condition>> as include_record,
            loan_dim.*
        FROM star_loan.loan_dim
    ) AS t1739 ON primary_table.l_pid = t1739.loan_pid AND t1739.data_source_dwid = 1
 WHERE
    GREATEST(primary_table.include_record, t471.include_record, t477.include_record, t470.include_record, t472.include_record, t473.include_record, t474.include_record, t475.include_record, t476.include_record, t478.include_record, t1739.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'mortgage_insurance_dim'
);

-- Update to table_input_sql for product_choice_dim
-- This includes updates data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''aus'' || ''~'' || ''buydown_schedule'' || ''~'' || ''interest_only'' || ''~'' || ''aus_code'' || ''~'' || ''prepay_penatly_schedule_code'' || ''~'' || ''buydown_schedule_code'' || ''~'' || ''interest_only_code'' || ''~'' || ''mortgage_type_code'' || ''~'' || ''mortgage_type'' || ''~'' || ''prepay_penalty_schedule'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(t459.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t461.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t466.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_aus_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_prepay_penalty_schedule_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_buydown_schedule_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_interest_only_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.l_mortgage_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t479.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t480.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        t459.value as aus,
        t461.value as buydown_schedule,
        t466.value as interest_only,
        primary_table.l_aus_type as aus_code,
        primary_table.l_prepay_penalty_schedule_type as prepay_penatly_schedule_code,
        primary_table.l_buydown_schedule_type as buydown_schedule_code,
        primary_table.l_interest_only_type as interest_only_code,
        primary_table.l_mortgage_type as mortgage_type_code,
        t479.value as mortgage_type,
        t480.value as prepay_penalty_schedule
 FROM (
    SELECT
        <<loan_partial_load_condition>> as include_record,
        loan.*
    FROM history_octane.loan
        LEFT JOIN history_octane.loan AS history_records ON loan.l_pid = history_records.l_pid
            AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.l_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<aus_type_partial_load_condition>> as include_record,
            aus_type.*
            FROM history_octane.aus_type
                LEFT JOIN history_octane.aus_type AS history_records ON aus_type.code = history_records.code
                AND aus_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t459 ON primary_table.l_aus_type = t459.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<buydown_schedule_type_partial_load_condition>> as include_record,
            buydown_schedule_type.*
            FROM history_octane.buydown_schedule_type
                LEFT JOIN history_octane.buydown_schedule_type AS history_records ON buydown_schedule_type.code = history_records.code
                AND buydown_schedule_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t461 ON primary_table.l_buydown_schedule_type = t461.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<interest_only_type_partial_load_condition>> as include_record,
            interest_only_type.*
            FROM history_octane.interest_only_type
                LEFT JOIN history_octane.interest_only_type AS history_records ON interest_only_type.code = history_records.code
                AND interest_only_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t466 ON primary_table.l_interest_only_type = t466.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<mortgage_type_partial_load_condition>> as include_record,
            mortgage_type.*
            FROM history_octane.mortgage_type
                LEFT JOIN history_octane.mortgage_type AS history_records ON mortgage_type.code = history_records.code
                AND mortgage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t479 ON primary_table.l_mortgage_type = t479.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<prepay_penalty_schedule_type_partial_load_condition>> as include_record,
            prepay_penalty_schedule_type.*
            FROM history_octane.prepay_penalty_schedule_type
                LEFT JOIN history_octane.prepay_penalty_schedule_type AS history_records ON prepay_penalty_schedule_type.code = history_records.code
                AND prepay_penalty_schedule_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t480 ON primary_table.l_prepay_penalty_schedule_type = t480.code
 WHERE
    GREATEST(primary_table.include_record, t459.include_record, t461.include_record, t466.include_record, t479.include_record, t480.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'product_choice_dim'
);

-- Update to table_input_sql for product_dim
-- This includes updates data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''product_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(primary_table.p_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        t755.value as fund_source,
        primary_table.p_pid as product_pid,
        primary_table.p_description as description,
        primary_table.p_lock_auto_confirm as lock_auto_confirm_flag,
        primary_table.p_fnm_product_name as fnm_product_name,
        primary_table.p_through_date as through_date,
        primary_table.p_from_date as from_date,
        primary_table.p_investor_product_name as investor_product_name,
        primary_table.p_investor_product_id as investor_product_id,
        primary_table.p_fund_source_type as fund_source_code,
        primary_table.p_product_side_type as product_side_code,
        primary_table.p_investor_pid as investor_pid,
        t756.value as product_side
 FROM (
    SELECT
        <<product_partial_load_condition>> as include_record,
        product.*
    FROM history_octane.product
        LEFT JOIN history_octane.product AS history_records ON product.p_pid = history_records.p_pid
            AND product.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.p_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<fund_source_type_partial_load_condition>> as include_record,
            fund_source_type.*
            FROM history_octane.fund_source_type
                LEFT JOIN history_octane.fund_source_type AS history_records ON fund_source_type.code = history_records.code
                AND fund_source_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t755 ON primary_table.p_fund_source_type = t755.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<product_side_type_partial_load_condition>> as include_record,
            product_side_type.*
            FROM history_octane.product_side_type
                LEFT JOIN history_octane.product_side_type AS history_records ON product_side_type.code = history_records.code
                AND product_side_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t756 ON primary_table.p_product_side_type = t756.code
 WHERE
    GREATEST(primary_table.include_record, t755.include_record, t756.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'product_dim'
);

-- Update to table_input_sql for product_terms_dim
-- This includes updates data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
            ''product_terms_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
            COALESCE(CAST(primary_table.pt_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
            now() as edw_created_datetime,
            now() as edw_modified_datetime,
            primary_table.data_source_updated_datetime as data_source_modified_datetime,
            t715.value as arm_index,
            t717.value as buydown_base_date,
            t718.value as buydown_subsidy_calculation,
            t719.value as community_lending,
            t720.value as days_per_year,
            t721.value as decision_credit_score_calc,
            t722.value as fha_rehab_program,
            t723.value as fha_special_program,
            t724.value as fnm_arm_plan,
            t725.value as fnm_community_lending_product,
            t726.value as fre_community_program,
            t727.value as heloc_cancel_fee_applicable,
            t729.value as ipc_calc,
            t732.value as ipc_comparison_operator3,
            t730.value as ipc_comparison_operator1,
            t731.value as ipc_comparison_operator2,
            t733.value as ipc_comparison_operator4,
            t736.value as ipc_property_usage3,
            t734.value as ipc_property_usage1,
            t735.value as ipc_property_usage2,
            t737.value as ipc_property_usage4,
            t738.value as lien_priority,
            t739.value as loan_amortization,
            t740.value as mortgage_type,
            t741.value as negative_amortization,
            t742.value as partial_payment_policy,
            t716.value as arm_payment_adjustment_calculation,
            t743.value as payment_frequency,
            t744.value as payment_structure,
            t745.value as prepaid_interest_rate,
            t746.value as prepay_penalty,
            t747.value as product_appraisal_requirement,
            t748.value as product_special_program,
            primary_table.pt_ipc_comparison_operator_type3 as ipc_comparison_operator_code3,
            primary_table.pt_ipc_cltv_ratio_percent3 as ipc_cltv_ratio_percent3,
            primary_table.pt_ipc_limit_percent4 as ipc_limit_percent4,
            primary_table.pt_ipc_property_usage_type4 as ipc_property_usage_code4,
            primary_table.pt_ipc_comparison_operator_type4 as ipc_comparison_operator_code4,
            primary_table.pt_ipc_cltv_ratio_percent4 as ipc_cltv_ratio_percent4,
            primary_table.pt_buydown_base_date_type as buydown_base_date_code,
            primary_table.pt_buydown_subsidy_calculation_type as buydown_subsidy_calculation_code,
            primary_table.pt_prepaid_interest_rate_type as prepaid_interest_rate_code,
            primary_table.pt_fnm_arm_plan_type as fnm_arm_plan_code,
            primary_table.pt_dsi_plan_code as dsi_plan_code,
            primary_table.pt_credit_qualifying as credit_qualifying_flag,
            primary_table.pt_product_special_program_type as product_special_program_code,
            primary_table.pt_section_of_act_coarse_type as section_of_act_coarse_code,
            primary_table.pt_fha_rehab_program_type as fha_rehab_program_code,
            primary_table.pt_fha_special_program_type as fha_special_program_code,
            primary_table.pt_third_party_grant_eligible as third_party_grant_eligible_flag,
            primary_table.pt_servicing_transfer_type as servicing_transfer_code,
            primary_table.pt_no_mi_product as no_mi_product_flag,
            primary_table.pt_mortgage_credit_certificate_eligible as mortgage_credit_certificate_eligible_flag,
            primary_table.pt_fre_community_program_type as fre_community_program_code,
            primary_table.pt_fnm_community_lending_product_type as fnm_community_lending_product_code,
            primary_table.pt_zero_note_rate as zero_note_rate_flag,
            primary_table.pt_third_party_community_second_program_eligibility_type as third_party_community_second_program_eligibility_code,
            primary_table.pt_texas_veterans_land_board as texas_veterans_land_board_code,
            primary_table.pt_security_instrument_page_count as security_instrument_page_count,
            primary_table.pt_deed_page_count as deed_page_count,
            primary_table.pt_partial_payment_policy_type as partial_payment_policy_code,
            primary_table.pt_payment_structure_type as payment_structure_code,
            primary_table.pt_deferred_payment_months as deferred_payment_months,
            primary_table.pt_always_current_market_price as always_current_market_price_flag,
            primary_table.pt_rate_protect as rate_protect_flag,
            primary_table.pt_non_conforming as non_conforming_flag,
            primary_table.pt_allow_loan_amount_cents as allow_loan_amount_cents_flag,
            primary_table.pt_product_appraisal_requirement_type as product_appraisal_requirement_code,
            primary_table.pt_family_advantage as family_advantage_flag,
            primary_table.pt_community_lending_type as community_lending_code,
            primary_table.pt_high_balance as high_balance_code,
            primary_table.pt_decision_credit_score_calc_type as decision_credit_score_calc_code,
            primary_table.pt_new_york as new_york_flag,
            primary_table.pt_manual_risk_assessment_accepted as manual_risk_assessment_accepted_flag,
            primary_table.pt_external_fha_underwrite_accepted as external_fha_underwrite_accepted_flag,
            primary_table.pt_external_va_underwrite_accepted as external_va_underwrite_accepted_flag,
            primary_table.pt_external_usda_underwrite_accepted as external_usda_underwrite_accepted_flag,
            primary_table.pt_external_investor_underwrite_accepted as external_investor_underwrite_accepted_flag,
            primary_table.pt_heloc_cancel_fee_applicable_type as heloc_cancel_fee_applicable_code,
            primary_table.pt_heloc_cancel_fee_period_months as heloc_cancel_fee_period_months,
            primary_table.pt_heloc_cancel_fee_amount as heloc_cancel_fee_amount,
            primary_table.pt_heloc_draw_period_months as heloc_draw_period_months,
            primary_table.pt_heloc_repayment_period_duration_months as heloc_repayment_period_duration_months,
            primary_table.pt_heloc_maximum_initial_draw as heloc_maximum_initial_draw_flag,
            primary_table.pt_heloc_maximum_initial_draw_amount as heloc_maximum_initial_draw_amount,
            primary_table.pt_heloc_minimum_draw as heloc_minimum_draw_flag,
            primary_table.pt_heloc_minimum_draw_amount as heloc_minimum_draw_amount,
            primary_table.pt_gpm_adjustment_years as gpm_adjustment_years,
            primary_table.pt_gpm_adjustment_percent as gpm_adjustment_percent,
            primary_table.pt_qualifying_monthly_payment_type as qualifying_monthly_payment_code,
            primary_table.pt_qualifying_rate_type as qualifying_rate_code,
            primary_table.pt_qualifying_rate_input_percent as qualifying_rate_input_percent,
            primary_table.pt_ipc_calc_type as ipc_calc_code,
            primary_table.pt_ipc_limit_percent1 as ipc_limit_percent1,
            primary_table.pt_ipc_property_usage_type1 as ipc_property_usage_code1,
            primary_table.pt_ipc_comparison_operator_type1 as ipc_comparison_operator_code1,
            primary_table.pt_ipc_cltv_ratio_percent1 as ipc_cltv_ratio_percent1,
            primary_table.pt_ipc_limit_percent2 as ipc_limit_percent2,
            primary_table.pt_ipc_property_usage_type2 as ipc_property_usage_code2,
            primary_table.pt_ipc_comparison_operator_type2 as ipc_comparison_operator_code2,
            primary_table.pt_ipc_cltv_ratio_percent2 as ipc_cltv_ratio_percent2,
            primary_table.pt_ipc_limit_percent3 as ipc_limit_percent3,
            primary_table.pt_ipc_property_usage_type3 as ipc_property_usage_code3,
            primary_table.pt_pid as product_terms_pid,
            primary_table.pt_amortization_term_months as amortization_term_months,
            primary_table.pt_arm_index_type as arm_index_code,
            primary_table.pt_arm_payment_adjustment_calculation_type as arm_payment_adjustment_calculation_code,
            primary_table.pt_assumable as assumable_flag,
            primary_table.pt_product_category as product_category,
            primary_table.pt_conditions_to_assumability as conditions_to_assumability_flag,
            primary_table.pt_demand_feature as demand_feature_flag,
            primary_table.pt_due_in_term_months as due_in_term_months,
            primary_table.pt_escrow_cushion_months as escrow_cushion_months,
            primary_table.pt_from_date as from_date,
            primary_table.pt_initial_payment_adjustment_term_months as initial_payment_adjustment_term_months,
            primary_table.pt_initial_rate_adjustment_cap_percent as initial_rate_adjustment_cap_percent,
            primary_table.pt_initial_rate_adjustment_term_months as initial_rate_adjustment_term_months,
            primary_table.pt_lien_priority_type as lien_priority_code,
            primary_table.pt_loan_amortization_type as loan_amortization_code,
            primary_table.pt_minimum_payment_rate_percent as minimum_payment_rate_percent,
            primary_table.pt_minimum_rate_term_months as minimum_rate_term_months,
            primary_table.pt_mortgage_type as mortgage_type_code,
            primary_table.pt_negative_amortization_type as negative_amortization_code,
            primary_table.pt_negative_amortization_limit_percent as negative_amortization_limit_percent,
            primary_table.pt_negative_amortization_recast_period_months as negative_amortization_recast_period_months,
            primary_table.pt_payment_adjustment_lifetime_cap_percent as payment_adjustment_lifetime_cap_percent,
            primary_table.pt_payment_adjustment_periodic_cap as payment_adjustment_periodic_cap,
            primary_table.pt_payment_frequency_type as payment_frequency_code,
            primary_table.pt_prepayment_finance_charge_refund as prepayment_charge_refund_flag,
            primary_table.pt_product_pid as product_pid,
            primary_table.pt_rate_adjustment_lifetime_cap_percent as rate_adjustment_lifetime_cap_percent,
            primary_table.pt_subsequent_payment_adjustment_term_months as subsequent_payment_adjustment_term_months,
            primary_table.pt_subsequent_rate_adjustment_cap_percent as subsequent_rate_adjustment_cap_percent,
            primary_table.pt_subsequent_rate_adjustment_term_months as subsequent_rate_adjustment_term_months,
            primary_table.pt_prepay_penalty_type as prepay_penalty_code,
            primary_table.pt_lender_hazard_insurance_available as lender_hazard_insurance_available_flag,
            primary_table.pt_lender_hazard_insurance_premium_amount as lender_hazard_insurance_premium_amount,
            primary_table.pt_lender_hazard_insurance_term_months as lender_hazard_insurance_term_months,
            primary_table.pt_loan_requires_hazard_insurance as loan_requires_hazard_insurance_flag,
            primary_table.pt_arm_convertible as arm_convertible_flag,
            primary_table.pt_arm_convertible_from_month as arm_convertible_from_month,
            primary_table.pt_arm_convertible_through_month as arm_convertible_through_month,
            primary_table.pt_arm_floor_rate_percent as arm_floor_rate_percent,
            primary_table.pt_arm_lookback_period_days as arm_lookback_period_days,
            primary_table.pt_escrow_waiver_allowed as escrow_waiver_allowed_flag,
            primary_table.pt_days_per_year_type as days_per_year_code,
            primary_table.pt_lp_risk_assessment_accepted as lp_risk_assessment_accepted_flag,
            primary_table.pt_du_risk_assessment_accepted as du_risk_assessment_accepted_flag,
            primary_table.pt_internal_underwrite_accepted as internal_underwrite_accepted_flag,
            t749.value as qualifying_monthly_payment,
            t750.value as qualifying_rate,
            t751.value as section_of_act_coarse,
            t752.value as servicing_transfer,
            t754.value as third_party_community_second_program_eligibility,
            t753.value as texas_veterans_land_board,
            t753.value as high_balance
FROM (
         SELECT
             <<product_terms_partial_load_condition>> as include_record,
             product_terms.*
         FROM history_octane.product_terms
                  LEFT JOIN history_octane.product_terms AS history_records ON product_terms.pt_pid = history_records.pt_pid
             AND product_terms.data_source_updated_datetime < history_records.data_source_updated_datetime
         WHERE history_records.pt_pid IS NULL
     ) AS primary_table

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<arm_index_type_partial_load_condition>> as include_record,
                                 arm_index_type.*
                      FROM history_octane.arm_index_type
                               LEFT JOIN history_octane.arm_index_type AS history_records ON arm_index_type.code = history_records.code
                          AND arm_index_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t715 ON primary_table.pt_arm_index_type = t715.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<buydown_base_date_type_partial_load_condition>> as include_record,
                                 buydown_base_date_type.*
                      FROM history_octane.buydown_base_date_type
                               LEFT JOIN history_octane.buydown_base_date_type AS history_records ON buydown_base_date_type.code = history_records.code
                          AND buydown_base_date_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t717 ON primary_table.pt_buydown_base_date_type = t717.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<buydown_subsidy_calculation_type_partial_load_condition>> as include_record,
                                 buydown_subsidy_calculation_type.*
                      FROM history_octane.buydown_subsidy_calculation_type
                               LEFT JOIN history_octane.buydown_subsidy_calculation_type AS history_records ON buydown_subsidy_calculation_type.code = history_records.code
                          AND buydown_subsidy_calculation_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t718 ON primary_table.pt_buydown_subsidy_calculation_type = t718.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<community_lending_type_partial_load_condition>> as include_record,
                                 community_lending_type.*
                      FROM history_octane.community_lending_type
                               LEFT JOIN history_octane.community_lending_type AS history_records ON community_lending_type.code = history_records.code
                          AND community_lending_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t719 ON primary_table.pt_community_lending_type = t719.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<days_per_year_type_partial_load_condition>> as include_record,
                                 days_per_year_type.*
                      FROM history_octane.days_per_year_type
                               LEFT JOIN history_octane.days_per_year_type AS history_records ON days_per_year_type.code = history_records.code
                          AND days_per_year_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t720 ON primary_table.pt_days_per_year_type = t720.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<decision_credit_score_calc_type_partial_load_condition>> as include_record,
                                 decision_credit_score_calc_type.*
                      FROM history_octane.decision_credit_score_calc_type
                               LEFT JOIN history_octane.decision_credit_score_calc_type AS history_records ON decision_credit_score_calc_type.code = history_records.code
                          AND decision_credit_score_calc_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t721 ON primary_table.pt_decision_credit_score_calc_type = t721.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<fha_rehab_program_type_partial_load_condition>> as include_record,
                                 fha_rehab_program_type.*
                      FROM history_octane.fha_rehab_program_type
                               LEFT JOIN history_octane.fha_rehab_program_type AS history_records ON fha_rehab_program_type.code = history_records.code
                          AND fha_rehab_program_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t722 ON primary_table.pt_fha_rehab_program_type = t722.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<fha_special_program_type_partial_load_condition>> as include_record,
                                 fha_special_program_type.*
                      FROM history_octane.fha_special_program_type
                               LEFT JOIN history_octane.fha_special_program_type AS history_records ON fha_special_program_type.code = history_records.code
                          AND fha_special_program_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t723 ON primary_table.pt_fha_special_program_type = t723.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<fnm_arm_plan_type_partial_load_condition>> as include_record,
                                 fnm_arm_plan_type.*
                      FROM history_octane.fnm_arm_plan_type
                               LEFT JOIN history_octane.fnm_arm_plan_type AS history_records ON fnm_arm_plan_type.code = history_records.code
                          AND fnm_arm_plan_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t724 ON primary_table.pt_fnm_arm_plan_type = t724.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<fnm_community_lending_product_type_partial_load_condition>> as include_record,
                                 fnm_community_lending_product_type.*
                      FROM history_octane.fnm_community_lending_product_type
                               LEFT JOIN history_octane.fnm_community_lending_product_type AS history_records ON fnm_community_lending_product_type.code = history_records.code
                          AND fnm_community_lending_product_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t725 ON primary_table.pt_fnm_community_lending_product_type = t725.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<fre_community_program_type_partial_load_condition>> as include_record,
                                 fre_community_program_type.*
                      FROM history_octane.fre_community_program_type
                               LEFT JOIN history_octane.fre_community_program_type AS history_records ON fre_community_program_type.code = history_records.code
                          AND fre_community_program_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t726 ON primary_table.pt_fre_community_program_type = t726.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<heloc_cancel_fee_applicable_type_partial_load_condition>> as include_record,
                                 heloc_cancel_fee_applicable_type.*
                      FROM history_octane.heloc_cancel_fee_applicable_type
                               LEFT JOIN history_octane.heloc_cancel_fee_applicable_type AS history_records ON heloc_cancel_fee_applicable_type.code = history_records.code
                          AND heloc_cancel_fee_applicable_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t727 ON primary_table.pt_heloc_cancel_fee_applicable_type = t727.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_calc_type_partial_load_condition>> as include_record,
                                 ipc_calc_type.*
                      FROM history_octane.ipc_calc_type
                               LEFT JOIN history_octane.ipc_calc_type AS history_records ON ipc_calc_type.code = history_records.code
                          AND ipc_calc_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t729 ON primary_table.pt_ipc_calc_type = t729.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_comparison_operator_type_partial_load_condition>> as include_record,
                                 ipc_comparison_operator_type.*
                      FROM history_octane.ipc_comparison_operator_type
                               LEFT JOIN history_octane.ipc_comparison_operator_type AS history_records ON ipc_comparison_operator_type.code = history_records.code
                          AND ipc_comparison_operator_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t732 ON primary_table.pt_ipc_comparison_operator_type3 = t732.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_comparison_operator_type_partial_load_condition>> as include_record,
                                 ipc_comparison_operator_type.*
                      FROM history_octane.ipc_comparison_operator_type
                               LEFT JOIN history_octane.ipc_comparison_operator_type AS history_records ON ipc_comparison_operator_type.code = history_records.code
                          AND ipc_comparison_operator_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t730 ON primary_table.pt_ipc_comparison_operator_type1 = t730.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_comparison_operator_type_partial_load_condition>> as include_record,
                                 ipc_comparison_operator_type.*
                      FROM history_octane.ipc_comparison_operator_type
                               LEFT JOIN history_octane.ipc_comparison_operator_type AS history_records ON ipc_comparison_operator_type.code = history_records.code
                          AND ipc_comparison_operator_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t731 ON primary_table.pt_ipc_comparison_operator_type2 = t731.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_comparison_operator_type_partial_load_condition>> as include_record,
                                 ipc_comparison_operator_type.*
                      FROM history_octane.ipc_comparison_operator_type
                               LEFT JOIN history_octane.ipc_comparison_operator_type AS history_records ON ipc_comparison_operator_type.code = history_records.code
                          AND ipc_comparison_operator_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t733 ON primary_table.pt_ipc_comparison_operator_type4 = t733.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_property_usage_type_partial_load_condition>> as include_record,
                                 ipc_property_usage_type.*
                      FROM history_octane.ipc_property_usage_type
                               LEFT JOIN history_octane.ipc_property_usage_type AS history_records ON ipc_property_usage_type.code = history_records.code
                          AND ipc_property_usage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t736 ON primary_table.pt_ipc_property_usage_type3 = t736.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_property_usage_type_partial_load_condition>> as include_record,
                                 ipc_property_usage_type.*
                      FROM history_octane.ipc_property_usage_type
                               LEFT JOIN history_octane.ipc_property_usage_type AS history_records ON ipc_property_usage_type.code = history_records.code
                          AND ipc_property_usage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t734 ON primary_table.pt_ipc_property_usage_type1 = t734.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_property_usage_type_partial_load_condition>> as include_record,
                                 ipc_property_usage_type.*
                      FROM history_octane.ipc_property_usage_type
                               LEFT JOIN history_octane.ipc_property_usage_type AS history_records ON ipc_property_usage_type.code = history_records.code
                          AND ipc_property_usage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t735 ON primary_table.pt_ipc_property_usage_type2 = t735.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<ipc_property_usage_type_partial_load_condition>> as include_record,
                                 ipc_property_usage_type.*
                      FROM history_octane.ipc_property_usage_type
                               LEFT JOIN history_octane.ipc_property_usage_type AS history_records ON ipc_property_usage_type.code = history_records.code
                          AND ipc_property_usage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t737 ON primary_table.pt_ipc_property_usage_type4 = t737.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<lien_priority_type_partial_load_condition>> as include_record,
                                 lien_priority_type.*
                      FROM history_octane.lien_priority_type
                               LEFT JOIN history_octane.lien_priority_type AS history_records ON lien_priority_type.code = history_records.code
                          AND lien_priority_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t738 ON primary_table.pt_lien_priority_type = t738.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<loan_amortization_type_partial_load_condition>> as include_record,
                                 loan_amortization_type.*
                      FROM history_octane.loan_amortization_type
                               LEFT JOIN history_octane.loan_amortization_type AS history_records ON loan_amortization_type.code = history_records.code
                          AND loan_amortization_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t739 ON primary_table.pt_loan_amortization_type = t739.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<mortgage_type_partial_load_condition>> as include_record,
                                 mortgage_type.*
                      FROM history_octane.mortgage_type
                               LEFT JOIN history_octane.mortgage_type AS history_records ON mortgage_type.code = history_records.code
                          AND mortgage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t740 ON primary_table.pt_mortgage_type = t740.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<negative_amortization_type_partial_load_condition>> as include_record,
                                 negative_amortization_type.*
                      FROM history_octane.negative_amortization_type
                               LEFT JOIN history_octane.negative_amortization_type AS history_records ON negative_amortization_type.code = history_records.code
                          AND negative_amortization_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t741 ON primary_table.pt_negative_amortization_type = t741.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<partial_payment_policy_type_partial_load_condition>> as include_record,
                                 partial_payment_policy_type.*
                      FROM history_octane.partial_payment_policy_type
                               LEFT JOIN history_octane.partial_payment_policy_type AS history_records ON partial_payment_policy_type.code = history_records.code
                          AND partial_payment_policy_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t742 ON primary_table.pt_partial_payment_policy_type = t742.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<payment_adjustment_calculation_type_partial_load_condition>> as include_record,
                                 payment_adjustment_calculation_type.*
                      FROM history_octane.payment_adjustment_calculation_type
                               LEFT JOIN history_octane.payment_adjustment_calculation_type AS history_records ON payment_adjustment_calculation_type.code = history_records.code
                          AND payment_adjustment_calculation_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t716 ON primary_table.pt_arm_payment_adjustment_calculation_type = t716.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<payment_frequency_type_partial_load_condition>> as include_record,
                                 payment_frequency_type.*
                      FROM history_octane.payment_frequency_type
                               LEFT JOIN history_octane.payment_frequency_type AS history_records ON payment_frequency_type.code = history_records.code
                          AND payment_frequency_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t743 ON primary_table.pt_payment_frequency_type = t743.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<payment_structure_type_partial_load_condition>> as include_record,
                                 payment_structure_type.*
                      FROM history_octane.payment_structure_type
                               LEFT JOIN history_octane.payment_structure_type AS history_records ON payment_structure_type.code = history_records.code
                          AND payment_structure_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t744 ON primary_table.pt_payment_structure_type = t744.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<prepaid_interest_rate_type_partial_load_condition>> as include_record,
                                 prepaid_interest_rate_type.*
                      FROM history_octane.prepaid_interest_rate_type
                               LEFT JOIN history_octane.prepaid_interest_rate_type AS history_records ON prepaid_interest_rate_type.code = history_records.code
                          AND prepaid_interest_rate_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t745 ON primary_table.pt_prepaid_interest_rate_type = t745.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<prepay_penalty_type_partial_load_condition>> as include_record,
                                 prepay_penalty_type.*
                      FROM history_octane.prepay_penalty_type
                               LEFT JOIN history_octane.prepay_penalty_type AS history_records ON prepay_penalty_type.code = history_records.code
                          AND prepay_penalty_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t746 ON primary_table.pt_prepay_penalty_type = t746.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<product_appraisal_requirement_type_partial_load_condition>> as include_record,
                                 product_appraisal_requirement_type.*
                      FROM history_octane.product_appraisal_requirement_type
                               LEFT JOIN history_octane.product_appraisal_requirement_type AS history_records ON product_appraisal_requirement_type.code = history_records.code
                          AND product_appraisal_requirement_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t747 ON primary_table.pt_product_appraisal_requirement_type = t747.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<product_special_program_type_partial_load_condition>> as include_record,
                                 product_special_program_type.*
                      FROM history_octane.product_special_program_type
                               LEFT JOIN history_octane.product_special_program_type AS history_records ON product_special_program_type.code = history_records.code
                          AND product_special_program_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t748 ON primary_table.pt_product_special_program_type = t748.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<qualifying_monthly_payment_type_partial_load_condition>> as include_record,
                                 qualifying_monthly_payment_type.*
                      FROM history_octane.qualifying_monthly_payment_type
                               LEFT JOIN history_octane.qualifying_monthly_payment_type AS history_records ON qualifying_monthly_payment_type.code = history_records.code
                          AND qualifying_monthly_payment_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t749 ON primary_table.pt_qualifying_monthly_payment_type = t749.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<qualifying_rate_type_partial_load_condition>> as include_record,
                                 qualifying_rate_type.*
                      FROM history_octane.qualifying_rate_type
                               LEFT JOIN history_octane.qualifying_rate_type AS history_records ON qualifying_rate_type.code = history_records.code
                          AND qualifying_rate_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t750 ON primary_table.pt_qualifying_rate_type = t750.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<section_of_act_coarse_type_partial_load_condition>> as include_record,
                                 section_of_act_coarse_type.*
                      FROM history_octane.section_of_act_coarse_type
                               LEFT JOIN history_octane.section_of_act_coarse_type AS history_records ON section_of_act_coarse_type.code = history_records.code
                          AND section_of_act_coarse_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t751 ON primary_table.pt_section_of_act_coarse_type = t751.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<servicing_transfer_type_partial_load_condition>> as include_record,
                                 servicing_transfer_type.*
                      FROM history_octane.servicing_transfer_type
                               LEFT JOIN history_octane.servicing_transfer_type AS history_records ON servicing_transfer_type.code = history_records.code
                          AND servicing_transfer_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t752 ON primary_table.pt_servicing_transfer_type = t752.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<third_party_community_second_program_eligibility_type_partial_load_condition>> as include_record,
                                 third_party_community_second_program_eligibility_type.*
                      FROM history_octane.third_party_community_second_program_eligibility_type
                               LEFT JOIN history_octane.third_party_community_second_program_eligibility_type AS history_records ON third_party_community_second_program_eligibility_type.code = history_records.code
                          AND third_party_community_second_program_eligibility_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t754 ON primary_table.pt_third_party_community_second_program_eligibility_type = t754.code

         INNER JOIN (
    SELECT * FROM (
                      SELECT     <<yes_no_unknown_type_partial_load_condition>> as include_record,
                                 yes_no_unknown_type.*
                      FROM history_octane.yes_no_unknown_type
                               LEFT JOIN history_octane.yes_no_unknown_type AS history_records ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
                      WHERE history_records.code IS NULL
                  ) as primary_table

) AS t753 ON primary_table.pt_texas_veterans_land_board = t753.code
     -- ignoring this because the table alias t753 has already been added: INNER JOIN history_octane.yes_no_unknown_type t753 ON primary_table.pt_texas_veterans_land_board = t753.code
WHERE
    GREATEST(primary_table.include_record, t715.include_record, t717.include_record, t718.include_record, t719.include_record, t720.include_record, t721.include_record, t722.include_record, t723.include_record, t724.include_record, t725.include_record, t726.include_record, t727.include_record, t729.include_record, t732.include_record, t730.include_record, t731.include_record, t733.include_record, t736.include_record, t734.include_record, t735.include_record, t737.include_record, t738.include_record, t739.include_record, t740.include_record, t741.include_record, t742.include_record, t716.include_record, t743.include_record, t744.include_record, t745.include_record, t746.include_record, t747.include_record, t748.include_record, t749.include_record, t750.include_record, t751.include_record, t752.include_record, t754.include_record, t753.include_record) IS TRUE
ORDER BY
    primary_table.data_source_updated_datetime ASC
;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'product_terms_dim'
);

-- Update to table_input_sql for transaction_dim
-- This includes updates data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''deal_pid'' || ''~'' || ''active_proposal_pid'' || ''~'' || ''data_source_dwid'' as data_source_integration_columns,
        COALESCE(CAST(t1441.d_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.prp_pid as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        t1441.d_pid as deal_pid,
        primary_table.prp_pid as active_proposal_pid
 FROM (
    SELECT
        <<proposal_partial_load_condition>> as include_record,
        proposal.*
    FROM history_octane.proposal
        LEFT JOIN history_octane.proposal AS history_records ON proposal.prp_pid = history_records.prp_pid
            AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.prp_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<deal_partial_load_condition>> as include_record,
            deal.*
            FROM history_octane.deal
                LEFT JOIN history_octane.deal AS history_records ON deal.d_pid = history_records.d_pid
                AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.d_pid IS NULL
        ) as primary_table

    ) AS t1441 ON primary_table.prp_deal_pid = t1441.d_pid
 WHERE
    GREATEST(primary_table.include_record, t1441.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'transaction_dim'
);

-- Update to table_input_sql for transaction_junk_dim
-- This includes updates data_source_integration_id concatenation
UPDATE mdi.table_input_step
SET sql = 'SELECT
        ''is_test_loan_flag'' || ''~'' || ''structure_code'' || ''~'' || ''mi_required_flag'' || ''~'' || ''structure'' || ''~'' || ''data_source_dwid'' || ''~'' || ''piggyback_flag'' as data_source_integration_columns,
        COALESCE(CAST(t1441.d_test_loan as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.prp_structure_type as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.prp_mi_required as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(t661.value as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(1 as text), ''<NULL>'')  || ''~'' || COALESCE(CAST(primary_table.prp_structure_type = ''COMBO'' as text), ''<NULL>'') as data_source_integration_id,
        now() as edw_created_datetime,
        now() as edw_modified_datetime,
        primary_table.data_source_updated_datetime as data_source_modified_datetime,
        t1441.d_test_loan as is_test_loan_flag,
        t649.value as loan_purpose,
        primary_table.prp_structure_type as structure_code,
        primary_table.prp_mi_required as mi_required_flag,
        primary_table.prp_loan_purpose_type as loan_purpose_code,
        t661.value as structure,
        primary_table.prp_structure_type = ''COMBO'' as piggyback_flag
 FROM (
    SELECT
        <<proposal_partial_load_condition>> as include_record,
        proposal.*
    FROM history_octane.proposal
        LEFT JOIN history_octane.proposal AS history_records ON proposal.prp_pid = history_records.prp_pid
            AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
    WHERE history_records.prp_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<deal_partial_load_condition>> as include_record,
            deal.*
            FROM history_octane.deal
                LEFT JOIN history_octane.deal AS history_records ON deal.d_pid = history_records.d_pid
                AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.d_pid IS NULL
        ) as primary_table

    ) AS t1441 ON primary_table.prp_deal_pid = t1441.d_pid

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<loan_purpose_type_partial_load_condition>> as include_record,
            loan_purpose_type.*
            FROM history_octane.loan_purpose_type
                LEFT JOIN history_octane.loan_purpose_type AS history_records ON loan_purpose_type.code = history_records.code
                AND loan_purpose_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t649 ON primary_table.prp_loan_purpose_type = t649.code

    INNER JOIN (
        SELECT * FROM (
            SELECT     <<proposal_structure_type_partial_load_condition>> as include_record,
            proposal_structure_type.*
            FROM history_octane.proposal_structure_type
                LEFT JOIN history_octane.proposal_structure_type AS history_records ON proposal_structure_type.code = history_records.code
                AND proposal_structure_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) as primary_table

    ) AS t661 ON primary_table.prp_structure_type = t661.code
 WHERE
    GREATEST(primary_table.include_record, t1441.include_record, t649.include_record, t661.include_record) IS TRUE
 ORDER BY
    primary_table.data_source_updated_datetime ASC
 ;'
WHERE process_dwid = (
    SELECT process.dwid
    FROM mdi.process
    JOIN mdi.insert_update_step ON process.dwid = insert_update_step.process_dwid
        AND insert_update_step.schema_name = 'star_loan'
        AND insert_update_step.table_name = 'transaction_junk_dim'
);
