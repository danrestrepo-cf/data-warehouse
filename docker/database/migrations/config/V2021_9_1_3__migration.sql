--
-- EDW | star_loan schema: Add indexes to tables' key lookup fields
-- https://app.asana.com/0/0/1200975391827399
--

DELETE FROM mdi.insert_update_key
WHERE dwid = (
    SELECT insert_update_key.dwid
    FROM mdi.insert_update_step
             JOIN mdi.insert_update_key ON insert_update_step.dwid = insert_update_key.insert_update_step_dwid
        AND insert_update_key.key_lookup = 'data_source_dwid'
    WHERE insert_update_step.table_name = 'loan_fact'
);

UPDATE mdi.insert_update_key
SET key_lookup = 'data_source_integration_id'
  , key_stream1 = 'data_source_integration_id'
WHERE dwid = (
    SELECT insert_update_key.dwid
    FROM mdi.insert_update_step
             JOIN mdi.insert_update_key ON insert_update_step.dwid = insert_update_key.insert_update_step_dwid
        AND insert_update_key.key_lookup = 'loan_pid'
    WHERE insert_update_step.table_name = 'loan_fact'
);

--
-- EDW | star_loan - prevent dimension ETLs from performing unnecessary updates
-- https://app.asana.com/0/1199645410972911/1200970669432550/f
--

--borrower_demographics_dim
UPDATE mdi.table_input_step
SET sql = 'SELECT borrower_demographics_dim_new_records.data_source_integration_columns
     , borrower_demographics_dim_new_records.data_source_integration_id
     , borrower_demographics_dim_new_records.edw_created_datetime
     , borrower_demographics_dim_new_records.edw_modified_datetime
     , borrower_demographics_dim_new_records.data_source_modified_datetime
     , borrower_demographics_dim_new_records.sex_refused_code
     , borrower_demographics_dim_new_records.sex_collected_visual_or_surname_code
     , borrower_demographics_dim_new_records.sex_male_flag
     , borrower_demographics_dim_new_records.sex_female_flag
     , borrower_demographics_dim_new_records.sex_not_obtainable_flag
     , borrower_demographics_dim_new_records.ethnicity_refused_code
     , borrower_demographics_dim_new_records.ethnicity_collected_visual_or_surname_code
     , borrower_demographics_dim_new_records.ethnicity_hispanic_or_latino_flag
     , borrower_demographics_dim_new_records.ethnicity_mexican_flag
     , borrower_demographics_dim_new_records.ethnicity_puerto_rican_flag
     , borrower_demographics_dim_new_records.ethnicity_cuban_flag
     , borrower_demographics_dim_new_records.ethnicity_other_hispanic_or_latino_flag
     , borrower_demographics_dim_new_records.ethnicity_not_hispanic_or_latino_flag
     , borrower_demographics_dim_new_records.ethnicity_not_obtainable_flag
     , borrower_demographics_dim_new_records.marital_status_code
     , borrower_demographics_dim_new_records.race_refused_code
     , borrower_demographics_dim_new_records.race_collected_visual_or_surname_code
     , borrower_demographics_dim_new_records.race_american_indian_or_alaska_native_flag
     , borrower_demographics_dim_new_records.race_asian_flag
     , borrower_demographics_dim_new_records.race_asian_indian_flag
     , borrower_demographics_dim_new_records.race_chinese_flag
     , borrower_demographics_dim_new_records.race_filipino_flag
     , borrower_demographics_dim_new_records.race_japanese_flag
     , borrower_demographics_dim_new_records.race_korean_flag
     , borrower_demographics_dim_new_records.race_vietnamese_flag
     , borrower_demographics_dim_new_records.race_other_asian_flag
     , borrower_demographics_dim_new_records.race_black_or_african_american_flag
     , borrower_demographics_dim_new_records.race_information_not_provided_flag
     , borrower_demographics_dim_new_records.race_national_origin_refusal_flag
     , borrower_demographics_dim_new_records.race_native_hawaiian_or_other_pacific_islander_flag
     , borrower_demographics_dim_new_records.race_native_hawaiian_flag
     , borrower_demographics_dim_new_records.race_guamanian_or_chamorro_flag
     , borrower_demographics_dim_new_records.race_samoan_flag
     , borrower_demographics_dim_new_records.race_other_pacific_islander_flag
     , borrower_demographics_dim_new_records.race_not_obtainable_flag
     , borrower_demographics_dim_new_records.race_not_applicable_flag
     , borrower_demographics_dim_new_records.race_white_flag
     , borrower_demographics_dim_new_records.schooling_years
     , borrower_demographics_dim_new_records.marital_status
     , borrower_demographics_dim_new_records.ethnicity_collected_visual_or_surname
     , borrower_demographics_dim_new_records.sex_collected_visual_or_surname
     , borrower_demographics_dim_new_records.sex_refused
     , borrower_demographics_dim_new_records.race_refused
     , borrower_demographics_dim_new_records.ethnicity_refused
     , borrower_demographics_dim_new_records.race_collected_visual_or_surname
     , borrower_demographics_dim_new_records.race_other_pacific_islander_description_flag
     , borrower_demographics_dim_new_records.ethnicity_other_hispanic_or_latino_description_flag
     , borrower_demographics_dim_new_records.other_race_national_origin_description_flag
     , borrower_demographics_dim_new_records.race_other_american_indian_or_alaska_native_description_flag
     , borrower_demographics_dim_new_records.race_other_asian_description_flag
FROM (
    SELECT ''sex_refused_code'' || ''~'' || ''sex_collected_visual_or_surname_code'' || ''~'' || ''sex_male_flag'' || ''~'' || ''sex_female_flag'' ||
           ''~'' || ''sex_not_obtainable_flag'' || ''~'' || ''ethnicity_refused_code'' || ''~'' || ''ethnicity_collected_visual_or_surname_code'' ||
           ''~'' || ''ethnicity_hispanic_or_latino_flag'' || ''~'' || ''ethnicity_mexican_flag'' || ''~'' || ''ethnicity_puerto_rican_flag'' || ''~'' ||
           ''ethnicity_cuban_flag'' || ''~'' || ''ethnicity_other_hispanic_or_latino_flag'' || ''~'' || ''ethnicity_not_hispanic_or_latino_flag'' ||
           ''~'' || ''ethnicity_not_obtainable_flag'' || ''~'' || ''marital_status_code'' || ''~'' || ''race_refused_code'' || ''~'' ||
           ''race_collected_visual_or_surname_code'' || ''~'' || ''race_american_indian_or_alaska_native_flag'' || ''~'' || ''race_asian_flag'' ||
           ''~'' || ''race_asian_indian_flag'' || ''~'' || ''race_chinese_flag'' || ''~'' || ''race_filipino_flag'' || ''~'' || ''race_japanese_flag'' ||
           ''~'' || ''race_korean_flag'' || ''~'' || ''race_vietnamese_flag'' || ''~'' || ''race_other_asian_flag'' || ''~'' ||
           ''race_black_or_african_american_flag'' || ''~'' || ''race_information_not_provided_flag'' || ''~'' ||
           ''race_national_origin_refusal_flag'' || ''~'' || ''race_native_hawaiian_or_other_pacific_islander_flag'' || ''~'' ||
           ''race_native_hawaiian_flag'' || ''~'' || ''race_guamanian_or_chamorro_flag'' || ''~'' || ''race_samoan_flag'' || ''~'' ||
           ''race_other_pacific_islander_flag'' || ''~'' || ''race_not_obtainable_flag'' || ''~'' || ''race_not_applicable_flag'' || ''~'' ||
           ''race_white_flag'' || ''~'' || ''schooling_years'' || ''~'' || ''marital_status'' || ''~'' || ''ethnicity_collected_visual_or_surname'' ||
           ''~'' || ''sex_collected_visual_or_surname'' || ''~'' || ''sex_refused'' || ''~'' || ''race_refused'' || ''~'' || ''ethnicity_refused'' || ''~'' ||
           ''race_collected_visual_or_surname'' || ''~'' || ''race_other_pacific_islander_description_flag'' || ''~'' || ''data_source_dwid'' ||
           ''~'' || ''ethnicity_other_hispanic_or_latino_description_flag'' || ''~'' || ''other_race_national_origin_description_flag'' || ''~'' ||
           ''race_other_american_indian_or_alaska_native_description_flag'' || ''~'' ||
           ''race_other_asian_description_flag'' AS data_source_integration_columns
         , COALESCE( CAST( primary_table.b_sex_refused AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_sex_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_sex_male AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_sex_female AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_sex_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_ethnicity_refused AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_ethnicity_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_ethnicity_hispanic_or_latino AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_ethnicity_mexican AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_ethnicity_puerto_rican AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_ethnicity_cuban AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_ethnicity_other_hispanic_or_latino AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_ethnicity_not_hispanic_or_latino AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_ethnicity_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_marital_status_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_refused AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_collected_visual_or_surname AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_american_indian_or_alaska_native AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_asian AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_asian_indian AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_chinese AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_filipino AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_japanese AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_korean AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_vietnamese AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_other_asian AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_black_or_african_american AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_information_not_provided AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_national_origin_refusal AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_native_hawaiian_or_other_pacific_islander AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_native_hawaiian AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_guamanian_or_chamorro AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_samoan AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_other_pacific_islander AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_not_obtainable AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_not_applicable AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_white AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_schooling_years AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t134.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t123.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t151.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t152.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t148.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t124.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t147.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_other_pacific_islander_description <> '''' AND
                           primary_table.b_race_other_pacific_islander_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_ethnicity_other_hispanic_or_latino_description <> '''' AND
                           primary_table.b_ethnicity_other_hispanic_or_latino_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_other_race_national_origin_description <> '''' AND
                           primary_table.b_other_race_national_origin_description IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_race_other_american_indian_or_alaska_native_description <> '''' AND
                           primary_table.b_race_other_american_indian_or_alaska_native_description IS NOT NULL AS TEXT ), ''<NULL>'' ) ||
           ''~'' ||
           COALESCE( CAST( primary_table.b_race_other_asian_description <> '''' AND
                           primary_table.b_race_other_asian_description IS NOT NULL AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( primary_table.data_source_updated_datetime ) AS data_source_modified_datetime
         , primary_table.b_sex_refused AS sex_refused_code
         , primary_table.b_sex_collected_visual_or_surname AS sex_collected_visual_or_surname_code
         , primary_table.b_sex_male AS sex_male_flag
         , primary_table.b_sex_female AS sex_female_flag
         , primary_table.b_sex_not_obtainable AS sex_not_obtainable_flag
         , primary_table.b_ethnicity_refused AS ethnicity_refused_code
         , primary_table.b_ethnicity_collected_visual_or_surname AS ethnicity_collected_visual_or_surname_code
         , primary_table.b_ethnicity_hispanic_or_latino AS ethnicity_hispanic_or_latino_flag
         , primary_table.b_ethnicity_mexican AS ethnicity_mexican_flag
         , primary_table.b_ethnicity_puerto_rican AS ethnicity_puerto_rican_flag
         , primary_table.b_ethnicity_cuban AS ethnicity_cuban_flag
         , primary_table.b_ethnicity_other_hispanic_or_latino AS ethnicity_other_hispanic_or_latino_flag
         , primary_table.b_ethnicity_not_hispanic_or_latino AS ethnicity_not_hispanic_or_latino_flag
         , primary_table.b_ethnicity_not_obtainable AS ethnicity_not_obtainable_flag
         , primary_table.b_marital_status_type AS marital_status_code
         , primary_table.b_race_refused AS race_refused_code
         , primary_table.b_race_collected_visual_or_surname AS race_collected_visual_or_surname_code
         , primary_table.b_race_american_indian_or_alaska_native AS race_american_indian_or_alaska_native_flag
         , primary_table.b_race_asian AS race_asian_flag
         , primary_table.b_race_asian_indian AS race_asian_indian_flag
         , primary_table.b_race_chinese AS race_chinese_flag
         , primary_table.b_race_filipino AS race_filipino_flag
         , primary_table.b_race_japanese AS race_japanese_flag
         , primary_table.b_race_korean AS race_korean_flag
         , primary_table.b_race_vietnamese AS race_vietnamese_flag
         , primary_table.b_race_other_asian AS race_other_asian_flag
         , primary_table.b_race_black_or_african_american AS race_black_or_african_american_flag
         , primary_table.b_race_information_not_provided AS race_information_not_provided_flag
         , primary_table.b_race_national_origin_refusal AS race_national_origin_refusal_flag
         , primary_table.b_race_native_hawaiian_or_other_pacific_islander AS race_native_hawaiian_or_other_pacific_islander_flag
         , primary_table.b_race_native_hawaiian AS race_native_hawaiian_flag
         , primary_table.b_race_guamanian_or_chamorro AS race_guamanian_or_chamorro_flag
         , primary_table.b_race_samoan AS race_samoan_flag
         , primary_table.b_race_other_pacific_islander AS race_other_pacific_islander_flag
         , primary_table.b_race_not_obtainable AS race_not_obtainable_flag
         , primary_table.b_race_not_applicable AS race_not_applicable_flag
         , primary_table.b_race_white AS race_white_flag
         , primary_table.b_schooling_years AS schooling_years
         , t134.value AS marital_status
         , t123.value AS ethnicity_collected_visual_or_surname
         , t151.value AS sex_collected_visual_or_surname
         , t152.value AS sex_refused
         , t148.value AS race_refused
         , t124.value AS ethnicity_refused
         , t147.value AS race_collected_visual_or_surname
         , primary_table.b_race_other_pacific_islander_description <> '''' AND
           primary_table.b_race_other_pacific_islander_description IS NOT NULL AS race_other_pacific_islander_description_flag
         , primary_table.b_ethnicity_other_hispanic_or_latino_description <> '''' AND
           primary_table.b_ethnicity_other_hispanic_or_latino_description IS NOT NULL AS ethnicity_other_hispanic_or_latino_description_flag
         , primary_table.b_other_race_national_origin_description <> '''' AND
           primary_table.b_other_race_national_origin_description IS NOT NULL AS other_race_national_origin_description_flag
         , primary_table.b_race_other_american_indian_or_alaska_native_description <> '''' AND
           primary_table.b_race_other_american_indian_or_alaska_native_description IS NOT NULL AS race_other_american_indian_or_alaska_native_description_flag
         , primary_table.b_race_other_asian_description <> '''' AND
           primary_table.b_race_other_asian_description IS NOT NULL AS race_other_asian_description_flag
    FROM (
        SELECT TRUE AS include_record
             , borrower.*
        FROM history_octane.borrower
        LEFT JOIN history_octane.borrower AS history_records
                  ON borrower.b_pid = history_records.b_pid
                      AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.b_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT *
        FROM (
            SELECT TRUE AS include_record
                 , marital_status_type.*
            FROM history_octane.marital_status_type
            LEFT JOIN history_octane.marital_status_type AS history_records
                      ON marital_status_type.code = history_records.code
                          AND marital_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t134
               ON primary_table.b_marital_status_type = t134.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT TRUE AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t123
               ON primary_table.b_ethnicity_collected_visual_or_surname = t123.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT TRUE AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t151
               ON primary_table.b_sex_collected_visual_or_surname = t151.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT TRUE AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t152
               ON primary_table.b_sex_refused = t152.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT TRUE AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t148
               ON primary_table.b_race_refused = t148.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT TRUE AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t124
               ON primary_table.b_ethnicity_refused = t124.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT TRUE AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t147
               ON primary_table.b_race_collected_visual_or_surname = t147.code
    WHERE GREATEST( primary_table.include_record, t134.include_record, t123.include_record, t151.include_record, t152.include_record,
                    t148.include_record, t124.include_record, t147.include_record ) IS TRUE
    GROUP BY primary_table.b_sex_refused, primary_table.b_sex_collected_visual_or_surname, primary_table.b_sex_male
           , primary_table.b_sex_female, primary_table.b_sex_not_obtainable, primary_table.b_ethnicity_refused
           , primary_table.b_ethnicity_collected_visual_or_surname, primary_table.b_ethnicity_hispanic_or_latino
           , primary_table.b_ethnicity_mexican, primary_table.b_ethnicity_puerto_rican, primary_table.b_ethnicity_cuban
           , primary_table.b_ethnicity_other_hispanic_or_latino, primary_table.b_ethnicity_not_hispanic_or_latino
           , primary_table.b_ethnicity_not_obtainable, primary_table.b_marital_status_type, primary_table.b_race_refused
           , primary_table.b_race_collected_visual_or_surname, primary_table.b_race_american_indian_or_alaska_native
           , primary_table.b_race_asian, primary_table.b_race_asian_indian, primary_table.b_race_chinese, primary_table.b_race_filipino
           , primary_table.b_race_japanese, primary_table.b_race_korean, primary_table.b_race_vietnamese, primary_table.b_race_other_asian
           , primary_table.b_race_black_or_african_american, primary_table.b_race_information_not_provided
           , primary_table.b_race_national_origin_refusal, primary_table.b_race_native_hawaiian_or_other_pacific_islander
           , primary_table.b_race_native_hawaiian, primary_table.b_race_guamanian_or_chamorro, primary_table.b_race_samoan
           , primary_table.b_race_other_pacific_islander, primary_table.b_race_not_obtainable, primary_table.b_race_not_applicable
           , primary_table.b_race_white, primary_table.b_schooling_years, t123.value, t151.value, t152.value, t148.value, t124.value
           , t147.value, t134.value
           , primary_table.b_race_other_pacific_islander_description <> '''' AND
             primary_table.b_race_other_pacific_islander_description IS NOT NULL
           , primary_table.b_ethnicity_other_hispanic_or_latino_description <> '''' AND
             primary_table.b_ethnicity_other_hispanic_or_latino_description IS NOT NULL
           , primary_table.b_other_race_national_origin_description <> '''' AND
             primary_table.b_other_race_national_origin_description IS NOT NULL
           , primary_table.b_race_other_american_indian_or_alaska_native_description <> '''' AND
             primary_table.b_race_other_american_indian_or_alaska_native_description IS NOT NULL
           , primary_table.b_race_other_asian_description <> '''' AND
             primary_table.b_race_other_asian_description IS NOT NULL
) AS borrower_demographics_dim_new_records
LEFT JOIN star_loan.borrower_demographics_dim
          ON borrower_demographics_dim.data_source_integration_id = borrower_demographics_dim_new_records.data_source_integration_id
WHERE borrower_demographics_dim.dwid IS NULL
;'
FROM mdi.process
WHERE table_input_step.process_dwid = process.dwid
  AND process.name = 'SP-200004';

--borrower_lending_profile_dim
UPDATE mdi.table_input_step
SET sql = 'SELECT borrower_lending_profile_dim_new_records.data_source_integration_columns
     , borrower_lending_profile_dim_new_records.data_source_integration_id
     , borrower_lending_profile_dim_new_records.edw_created_datetime
     , borrower_lending_profile_dim_new_records.edw_modified_datetime
     , borrower_lending_profile_dim_new_records.data_source_modified_datetime
     , borrower_lending_profile_dim_new_records.alimony_child_support_code
     , borrower_lending_profile_dim_new_records.bankruptcy_code
     , borrower_lending_profile_dim_new_records.borrowed_down_payment_code
     , borrower_lending_profile_dim_new_records.spousal_homestead_code
     , borrower_lending_profile_dim_new_records.citizenship_residency_code
     , borrower_lending_profile_dim_new_records.dependents_code
     , borrower_lending_profile_dim_new_records.first_time_homebuyer_flag
     , borrower_lending_profile_dim_new_records.lender_employee_code
     , borrower_lending_profile_dim_new_records.lender_employee_status_confirmed_flag
     , borrower_lending_profile_dim_new_records.homeowner_past_three_years_code
     , borrower_lending_profile_dim_new_records.intend_to_occupy_code
     , borrower_lending_profile_dim_new_records.note_endorser_code
     , borrower_lending_profile_dim_new_records.obligated_loan_foreclosure_code
     , borrower_lending_profile_dim_new_records.outstanding_judgements_code
     , borrower_lending_profile_dim_new_records.party_to_lawsuit_code
     , borrower_lending_profile_dim_new_records.presently_delinquent_code
     , borrower_lending_profile_dim_new_records.property_foreclosure_code
     , borrower_lending_profile_dim_new_records.titleholder_code
     , borrower_lending_profile_dim_new_records.first_time_homebuyer_auto_compute_flag
     , borrower_lending_profile_dim_new_records.on_ldp_list_code
     , borrower_lending_profile_dim_new_records.on_gsa_list_code
     , borrower_lending_profile_dim_new_records.homeownership_education_code
     , borrower_lending_profile_dim_new_records.homeownership_education_agency_code
     , borrower_lending_profile_dim_new_records.homeownership_education_complete_date
     , borrower_lending_profile_dim_new_records.disabled_code
     , borrower_lending_profile_dim_new_records.hud_employee_flag
     , borrower_lending_profile_dim_new_records.domestic_relationship_state_code
     , borrower_lending_profile_dim_new_records.citizenship_residency
     , borrower_lending_profile_dim_new_records.homeownership_education
     , borrower_lending_profile_dim_new_records.homeownership_education_agency
     , borrower_lending_profile_dim_new_records.domestic_relationship_state
     , borrower_lending_profile_dim_new_records.alimony_child_support
     , borrower_lending_profile_dim_new_records.bankruptcy
     , borrower_lending_profile_dim_new_records.borrowed_down_payment
     , borrower_lending_profile_dim_new_records.disabled
     , borrower_lending_profile_dim_new_records.dependents
     , borrower_lending_profile_dim_new_records.homeowner_past_three_years
     , borrower_lending_profile_dim_new_records.intend_to_occupy
     , borrower_lending_profile_dim_new_records.lender_employee
     , borrower_lending_profile_dim_new_records.note_endorser
     , borrower_lending_profile_dim_new_records.obligated_loan_foreclosure
     , borrower_lending_profile_dim_new_records.on_gsa_list
     , borrower_lending_profile_dim_new_records.on_ldp_list
     , borrower_lending_profile_dim_new_records.outstanding_judgements
     , borrower_lending_profile_dim_new_records.party_to_lawsuit
     , borrower_lending_profile_dim_new_records.presently_delinquent
     , borrower_lending_profile_dim_new_records.property_foreclosure
     , borrower_lending_profile_dim_new_records.spousal_homestead
     , borrower_lending_profile_dim_new_records.titleholder
     , borrower_lending_profile_dim_new_records.property_foreclosure_explanation_flag
     , borrower_lending_profile_dim_new_records.presently_delinquent_explanation_flag
     , borrower_lending_profile_dim_new_records.party_to_lawsuit_explanation_flag
     , borrower_lending_profile_dim_new_records.outstanding_judgments_explanation_flag
     , borrower_lending_profile_dim_new_records.obligated_loan_foreclosure_explanation_flag
     , borrower_lending_profile_dim_new_records.note_endorser_explanation_flag
     , borrower_lending_profile_dim_new_records.borrowed_down_payment_explanation_flag
     , borrower_lending_profile_dim_new_records.bankruptcy_explanation_flag
     , borrower_lending_profile_dim_new_records.alimony_child_support_explanation_flag
FROM (
    SELECT ''alimony_child_support_code'' || ''~'' || ''bankruptcy_code'' || ''~'' || ''borrowed_down_payment_code'' || ''~'' ||
           ''spousal_homestead_code'' || ''~'' || ''citizenship_residency_code'' || ''~'' || ''dependents_code'' || ''~'' ||
           ''first_time_homebuyer_flag'' || ''~'' || ''lender_employee_code'' || ''~'' || ''lender_employee_status_confirmed_flag'' || ''~'' ||
           ''homeowner_past_three_years_code'' || ''~'' || ''intend_to_occupy_code'' || ''~'' || ''note_endorser_code'' || ''~'' ||
           ''obligated_loan_foreclosure_code'' || ''~'' || ''outstanding_judgements_code'' || ''~'' || ''party_to_lawsuit_code'' || ''~'' ||
           ''presently_delinquent_code'' || ''~'' || ''property_foreclosure_code'' || ''~'' || ''titleholder_code'' || ''~'' ||
           ''first_time_homebuyer_auto_compute_flag'' || ''~'' || ''on_ldp_list_code'' || ''~'' || ''on_gsa_list_code'' || ''~'' ||
           ''homeownership_education_code'' || ''~'' || ''homeownership_education_agency_code'' || ''~'' ||
           ''homeownership_education_complete_date'' || ''~'' || ''disabled_code'' || ''~'' || ''hud_employee_flag'' || ''~'' ||
           ''domestic_relationship_state_code'' || ''~'' || ''citizenship_residency'' || ''~'' || ''alimony_child_support'' || ''~'' || ''bankruptcy'' ||
           ''~'' || ''borrowed_down_payment'' || ''~'' || ''disabled'' || ''~'' || ''dependents'' || ''~'' || ''homeowner_past_three_years'' || ''~'' ||
           ''intend_to_occupy'' || ''~'' || ''lender_employee'' || ''~'' || ''note_endorser'' || ''~'' || ''obligated_loan_foreclosure'' || ''~'' ||
           ''on_gsa_list'' || ''~'' || ''on_ldp_list'' || ''~'' || ''outstanding_judgements'' || ''~'' || ''party_to_lawsuit'' || ''~'' ||
           ''presently_delinquent'' || ''~'' || ''property_foreclosure'' || ''~'' || ''spousal_homestead'' || ''~'' || ''titleholder'' || ''~'' ||
           ''data_source_dwid'' || ''~'' || ''property_foreclosure_explanation_flag'' || ''~'' || ''presently_delinquent_explanation_flag'' || ''~'' ||
           ''party_to_lawsuit_explanation_flag'' || ''~'' || ''outstanding_judgments_explanation_flag'' || ''~'' ||
           ''obligated_loan_foreclosure_explanation_flag'' || ''~'' || ''note_endorser_explanation_flag'' || ''~'' ||
           ''borrowed_down_payment_explanation_flag'' || ''~'' || ''bankruptcy_explanation_flag'' || ''~'' ||
           ''alimony_child_support_explanation_flag'' AS data_source_integration_columns
         , COALESCE( CAST( primary_table.b_alimony_child_support AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_bankruptcy AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_borrowed_down_payment AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_spousal_homestead AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_citizenship_residency_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_has_dependents AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_first_time_homebuyer AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_lender_employee AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_lender_employee_status_confirmed AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_homeowner_past_three_years AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_intend_to_occupy AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_note_endorser AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_obligated_loan_foreclosure AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_outstanding_judgements AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_party_to_lawsuit AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_presently_delinquent AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_property_foreclosure AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_titleholder AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_first_time_home_buyer_auto_compute AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_on_ldp_list AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_on_gsa_list AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_homeownership_education_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_homeownership_education_agency_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_homeownership_education_complete_date AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_disabled AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_hud_employee AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_domestic_relationship_state_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t119.value AS TEXT ), ''<NULL>'' ) || ''~'' || COALESCE( CAST( t127.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t126.value AS TEXT ), ''<NULL>'' ) || ''~'' || COALESCE( CAST( t122.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t113.value AS TEXT ), ''<NULL>'' ) || ''~'' || COALESCE( CAST( t116.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t117.value AS TEXT ), ''<NULL>'' ) || ''~'' || COALESCE( CAST( t121.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t125.value AS TEXT ), ''<NULL>'' ) || ''~'' || COALESCE( CAST( t128.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t131.value AS TEXT ), ''<NULL>'' ) || ''~'' || COALESCE( CAST( t133.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t135.value AS TEXT ), ''<NULL>'' ) || ''~'' || COALESCE( CAST( t136.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t137.value AS TEXT ), ''<NULL>'' ) || ''~'' || COALESCE( CAST( t138.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t139.value AS TEXT ), ''<NULL>'' ) || ''~'' || COALESCE( CAST( t140.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t143.value AS TEXT ), ''<NULL>'' ) || ''~'' || COALESCE( CAST( t146.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t153.value AS TEXT ), ''<NULL>'' ) || ''~'' || COALESCE( CAST( t154.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_property_foreclosure_explanation <> '''' AND
                           primary_table.b_property_foreclosure_explanation IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_presently_delinquent_explanation <> '''' AND
                           primary_table.b_presently_delinquent_explanation IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_party_to_lawsuit_explanation <> '''' AND
                           primary_table.b_party_to_lawsuit_explanation IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_outstanding_judgments_explanation <> '''' AND
                           primary_table.b_outstanding_judgments_explanation IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_obligated_loan_foreclosure_explanation <> '''' AND
                           primary_table.b_obligated_loan_foreclosure_explanation IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_note_endorser_explanation <> '''' AND
                           primary_table.b_note_endorser_explanation IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_borrowed_down_payment_explanation <> '''' AND
                           primary_table.b_borrowed_down_payment_explanation IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_bankruptcy_explanation <> '''' AND
                           primary_table.b_bankruptcy_explanation IS NOT NULL AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.b_alimony_child_support_explanation <> '''' AND
                           primary_table.b_alimony_child_support_explanation IS NOT NULL AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( primary_table.data_source_updated_datetime ) AS data_source_modified_datetime
         , primary_table.b_alimony_child_support AS alimony_child_support_code
         , primary_table.b_bankruptcy AS bankruptcy_code
         , primary_table.b_borrowed_down_payment AS borrowed_down_payment_code
         , primary_table.b_spousal_homestead AS spousal_homestead_code
         , primary_table.b_citizenship_residency_type AS citizenship_residency_code
         , primary_table.b_has_dependents AS dependents_code
         , primary_table.b_first_time_homebuyer AS first_time_homebuyer_flag
         , primary_table.b_lender_employee AS lender_employee_code
         , primary_table.b_lender_employee_status_confirmed AS lender_employee_status_confirmed_flag
         , primary_table.b_homeowner_past_three_years AS homeowner_past_three_years_code
         , primary_table.b_intend_to_occupy AS intend_to_occupy_code
         , primary_table.b_note_endorser AS note_endorser_code
         , primary_table.b_obligated_loan_foreclosure AS obligated_loan_foreclosure_code
         , primary_table.b_outstanding_judgements AS outstanding_judgements_code
         , primary_table.b_party_to_lawsuit AS party_to_lawsuit_code
         , primary_table.b_presently_delinquent AS presently_delinquent_code
         , primary_table.b_property_foreclosure AS property_foreclosure_code
         , primary_table.b_titleholder AS titleholder_code
         , primary_table.b_first_time_home_buyer_auto_compute AS first_time_homebuyer_auto_compute_flag
         , primary_table.b_on_ldp_list AS on_ldp_list_code
         , primary_table.b_on_gsa_list AS on_gsa_list_code
         , primary_table.b_homeownership_education_type AS homeownership_education_code
         , primary_table.b_homeownership_education_agency_type AS homeownership_education_agency_code
         , primary_table.b_homeownership_education_complete_date AS homeownership_education_complete_date
         , primary_table.b_disabled AS disabled_code
         , primary_table.b_hud_employee AS hud_employee_flag
         , primary_table.b_domestic_relationship_state_type AS domestic_relationship_state_code
         , t119.value AS citizenship_residency
         , t127.value AS homeownership_education
         , t126.value AS homeownership_education_agency
         , t122.value AS domestic_relationship_state
         , t113.value AS alimony_child_support
         , t116.value AS bankruptcy
         , t117.value AS borrowed_down_payment
         , t121.value AS disabled
         , t125.value AS dependents
         , t128.value AS homeowner_past_three_years
         , t131.value AS intend_to_occupy
         , t133.value AS lender_employee
         , t135.value AS note_endorser
         , t136.value AS obligated_loan_foreclosure
         , t137.value AS on_gsa_list
         , t138.value AS on_ldp_list
         , t139.value AS outstanding_judgements
         , t140.value AS party_to_lawsuit
         , t143.value AS presently_delinquent
         , t146.value AS property_foreclosure
         , t153.value AS spousal_homestead
         , t154.value AS titleholder
         , primary_table.b_property_foreclosure_explanation <> '''' AND
           primary_table.b_property_foreclosure_explanation IS NOT NULL AS property_foreclosure_explanation_flag
         , primary_table.b_presently_delinquent_explanation <> '''' AND
           primary_table.b_presently_delinquent_explanation IS NOT NULL AS presently_delinquent_explanation_flag
         , primary_table.b_party_to_lawsuit_explanation <> '''' AND
           primary_table.b_party_to_lawsuit_explanation IS NOT NULL AS party_to_lawsuit_explanation_flag
         , primary_table.b_outstanding_judgments_explanation <> '''' AND
           primary_table.b_outstanding_judgments_explanation IS NOT NULL AS outstanding_judgments_explanation_flag
         , primary_table.b_obligated_loan_foreclosure_explanation <> '''' AND
           primary_table.b_obligated_loan_foreclosure_explanation IS NOT NULL AS obligated_loan_foreclosure_explanation_flag
         , primary_table.b_note_endorser_explanation <> '''' AND
           primary_table.b_note_endorser_explanation IS NOT NULL AS note_endorser_explanation_flag
         , primary_table.b_borrowed_down_payment_explanation <> '''' AND
           primary_table.b_borrowed_down_payment_explanation IS NOT NULL AS borrowed_down_payment_explanation_flag
         , primary_table.b_bankruptcy_explanation <> '''' AND
           primary_table.b_bankruptcy_explanation IS NOT NULL AS bankruptcy_explanation_flag
         , primary_table.b_alimony_child_support_explanation <> '''' AND
           primary_table.b_alimony_child_support_explanation IS NOT NULL AS alimony_child_support_explanation_flag
    FROM (
        SELECT <<borrower_partial_load_condition>> AS include_record
             , borrower.*
        FROM history_octane.borrower
        LEFT JOIN history_octane.borrower AS history_records
                  ON borrower.b_pid = history_records.b_pid
                      AND borrower.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.b_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<citizenship_residency_type_partial_load_condition>> AS include_record
                 , citizenship_residency_type.*
            FROM history_octane.citizenship_residency_type
            LEFT JOIN history_octane.citizenship_residency_type AS history_records
                      ON citizenship_residency_type.code = history_records.code
                          AND citizenship_residency_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t119
               ON primary_table.b_citizenship_residency_type = t119.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<homeownership_education_type_partial_load_condition>> AS include_record
                 , homeownership_education_type.*
            FROM history_octane.homeownership_education_type
            LEFT JOIN history_octane.homeownership_education_type AS history_records
                      ON homeownership_education_type.code = history_records.code
                          AND homeownership_education_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t127
               ON primary_table.b_homeownership_education_type = t127.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<housing_counseling_agency_type_partial_load_condition>> AS include_record
                 , housing_counseling_agency_type.*
            FROM history_octane.housing_counseling_agency_type
            LEFT JOIN history_octane.housing_counseling_agency_type AS history_records
                      ON housing_counseling_agency_type.code = history_records.code
                          AND housing_counseling_agency_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t126
               ON primary_table.b_homeownership_education_agency_type = t126.code

    LEFT JOIN (
        SELECT *
        FROM (
            SELECT <<state_type_partial_load_condition>> AS include_record
                 , state_type.*
            FROM history_octane.state_type
            LEFT JOIN history_octane.state_type AS history_records
                      ON state_type.code = history_records.code
                          AND state_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t122
              ON primary_table.b_domestic_relationship_state_type = t122.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t113
               ON primary_table.b_alimony_child_support = t113.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t116
               ON primary_table.b_bankruptcy = t116.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t117
               ON primary_table.b_borrowed_down_payment = t117.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t121
               ON primary_table.b_disabled = t121.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t125
               ON primary_table.b_has_dependents = t125.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t128
               ON primary_table.b_homeowner_past_three_years = t128.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t131
               ON primary_table.b_intend_to_occupy = t131.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t133
               ON primary_table.b_lender_employee = t133.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t135
               ON primary_table.b_note_endorser = t135.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t136
               ON primary_table.b_obligated_loan_foreclosure = t136.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t137
               ON primary_table.b_on_gsa_list = t137.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t138
               ON primary_table.b_on_ldp_list = t138.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t139
               ON primary_table.b_outstanding_judgements = t139.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t140
               ON primary_table.b_party_to_lawsuit = t140.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t143
               ON primary_table.b_presently_delinquent = t143.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t146
               ON primary_table.b_property_foreclosure = t146.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t153
               ON primary_table.b_spousal_homestead = t153.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t154
               ON primary_table.b_titleholder = t154.code
    WHERE GREATEST( primary_table.include_record, t119.include_record, t127.include_record, t126.include_record, t122.include_record,
                    t113.include_record, t116.include_record, t117.include_record, t121.include_record, t125.include_record,
                    t128.include_record, t131.include_record, t133.include_record, t135.include_record, t136.include_record,
                    t137.include_record, t138.include_record, t139.include_record, t140.include_record, t143.include_record,
                    t146.include_record, t153.include_record, t154.include_record ) IS TRUE
    GROUP BY t119.value, primary_table.b_alimony_child_support, primary_table.b_bankruptcy, primary_table.b_borrowed_down_payment
           , primary_table.b_spousal_homestead, primary_table.b_citizenship_residency_type, primary_table.b_has_dependents
           , primary_table.b_first_time_homebuyer, primary_table.b_lender_employee, primary_table.b_lender_employee_status_confirmed
           , primary_table.b_homeowner_past_three_years, primary_table.b_intend_to_occupy, primary_table.b_note_endorser
           , primary_table.b_obligated_loan_foreclosure, primary_table.b_outstanding_judgements, primary_table.b_party_to_lawsuit
           , primary_table.b_presently_delinquent, primary_table.b_property_foreclosure, primary_table.b_titleholder
           , primary_table.b_first_time_home_buyer_auto_compute, primary_table.b_on_ldp_list, primary_table.b_on_gsa_list
           , primary_table.b_homeownership_education_type, primary_table.b_homeownership_education_agency_type
           , primary_table.b_homeownership_education_complete_date, primary_table.b_disabled, primary_table.b_hud_employee
           , primary_table.b_domestic_relationship_state_type, t127.value, t126.value, t122.value, t113.value, t116.value, t117.value
           , t121.value, t125.value, t128.value, t131.value, t133.value, t135.value, t136.value, t137.value, t138.value, t139.value
           , t140.value, t143.value, t146.value, t153.value, t154.value
           , primary_table.b_property_foreclosure_explanation <> '''' AND
             primary_table.b_property_foreclosure_explanation IS NOT NULL
           , primary_table.b_presently_delinquent_explanation <> '''' AND
             primary_table.b_presently_delinquent_explanation IS NOT NULL
           , primary_table.b_party_to_lawsuit_explanation <> '''' AND
             primary_table.b_party_to_lawsuit_explanation IS NOT NULL
           , primary_table.b_outstanding_judgments_explanation <> '''' AND
             primary_table.b_outstanding_judgments_explanation IS NOT NULL
           , primary_table.b_obligated_loan_foreclosure_explanation <> '''' AND
             primary_table.b_obligated_loan_foreclosure_explanation IS NOT NULL
           , primary_table.b_note_endorser_explanation <> '''' AND
             primary_table.b_note_endorser_explanation IS NOT NULL
           , primary_table.b_borrowed_down_payment_explanation <> '''' AND
             primary_table.b_borrowed_down_payment_explanation IS NOT NULL
           , primary_table.b_bankruptcy_explanation <> '''' AND
             primary_table.b_bankruptcy_explanation IS NOT NULL
           , primary_table.b_alimony_child_support_explanation <> '''' AND
             primary_table.b_alimony_child_support_explanation IS NOT NULL
) AS borrower_lending_profile_dim_new_records
LEFT JOIN star_loan.borrower_lending_profile_dim
          ON borrower_lending_profile_dim.data_source_integration_id = borrower_lending_profile_dim_new_records.data_source_integration_id
WHERE borrower_lending_profile_dim.dwid IS NULL
;'
FROM mdi.process
WHERE table_input_step.process_dwid = process.dwid
  AND process.name = 'SP-200006';

--hmda_purchaser_of_loan_dim
UPDATE mdi.table_input_step
SET sql = 'SELECT hmda_purchaser_of_loan_dim_new_records.data_source_integration_columns
     , hmda_purchaser_of_loan_dim_new_records.data_source_integration_id
     , hmda_purchaser_of_loan_dim_new_records.edw_created_datetime
     , hmda_purchaser_of_loan_dim_new_records.edw_modified_datetime
     , hmda_purchaser_of_loan_dim_new_records.data_source_modified_datetime
     , hmda_purchaser_of_loan_dim_new_records.value_2017
     , hmda_purchaser_of_loan_dim_new_records.code_2017
     , hmda_purchaser_of_loan_dim_new_records.code_2018
     , hmda_purchaser_of_loan_dim_new_records.value_2018
FROM (
    SELECT ''value_2017'' || ''~'' || ''code_2017'' || ''~'' || ''code_2018'' || ''~'' || ''value_2018'' || ''~'' ||
           ''data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( t465.value AS TEXT ), ''<NULL>'' ) || ''~'' || COALESCE( CAST( t465.code AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t464.code AS TEXT ), ''<NULL>'' ) || ''~'' || COALESCE( CAST( t464.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( primary_table.data_source_updated_datetime ) AS data_source_modified_datetime
         , t465.value AS value_2017
         , t465.code AS code_2017
         , t464.code AS code_2018
         , t464.value AS value_2018
    FROM (
        SELECT <<loan_partial_load_condition>> AS include_record
             , loan.*
        FROM history_octane.loan
        LEFT JOIN history_octane.loan AS history_records
                  ON loan.l_pid = history_records.l_pid
                      AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.l_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<hmda_purchaser_of_loan_2017_type_partial_load_condition>> AS include_record
                 , hmda_purchaser_of_loan_2017_type.*
            FROM history_octane.hmda_purchaser_of_loan_2017_type
            LEFT JOIN history_octane.hmda_purchaser_of_loan_2017_type AS history_records
                      ON hmda_purchaser_of_loan_2017_type.code = history_records.code
                          AND hmda_purchaser_of_loan_2017_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t465
               ON primary_table.l_hmda_purchaser_of_loan_2017_type = t465.code
        -- ignoring this because the table alias t465 has already been added: INNER JOIN history_octane.hmda_purchaser_of_loan_2017_type t465 ON primary_table.l_hmda_purchaser_of_loan_2017_type = t465.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<hmda_purchaser_of_loan_2018_type_partial_load_condition>> AS include_record
                 , hmda_purchaser_of_loan_2018_type.*
            FROM history_octane.hmda_purchaser_of_loan_2018_type
            LEFT JOIN history_octane.hmda_purchaser_of_loan_2018_type AS history_records
                      ON hmda_purchaser_of_loan_2018_type.code = history_records.code
                          AND hmda_purchaser_of_loan_2018_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t464
               ON primary_table.l_hmda_purchaser_of_loan_2018_type = t464.code
        -- ignoring this because the table alias t464 has already been added: INNER JOIN history_octane.hmda_purchaser_of_loan_2018_type t464 ON primary_table.l_hmda_purchaser_of_loan_2018_type = t464.code
    WHERE GREATEST( primary_table.include_record, t465.include_record, t464.include_record ) IS TRUE
    GROUP BY t465.value, t465.code, t464.code, t464.value
) AS hmda_purchaser_of_loan_dim_new_records
LEFT JOIN star_loan.hmda_purchaser_of_loan_dim
          ON hmda_purchaser_of_loan_dim.data_source_integration_id = hmda_purchaser_of_loan_dim_new_records.data_source_integration_id
WHERE hmda_purchaser_of_loan_dim.dwid IS NULL
;'
FROM mdi.process
WHERE table_input_step.process_dwid = process.dwid
  AND process.name = 'SP-200007';

--loan_junk_dim
UPDATE mdi.table_input_step
SET sql = 'SELECT loan_junk_dim_new_records.data_source_integration_columns
     , loan_junk_dim_new_records.data_source_integration_id
     , loan_junk_dim_new_records.edw_created_datetime
     , loan_junk_dim_new_records.edw_modified_datetime
     , loan_junk_dim_new_records.data_source_modified_datetime
     , loan_junk_dim_new_records.buydown_contributor
     , loan_junk_dim_new_records.fha_program
     , loan_junk_dim_new_records.hmda_hoepa_status
     , loan_junk_dim_new_records.lien_priority
     , loan_junk_dim_new_records.lender_concession_candidate_flag
     , loan_junk_dim_new_records.durp_eligibility_opt_out_flag
     , loan_junk_dim_new_records.qualified_mortgage_status_code
     , loan_junk_dim_new_records.qualified_mortgage_flag
     , loan_junk_dim_new_records.lqa_purchase_eligibility_code
     , loan_junk_dim_new_records.student_loan_cash_out_refinance_flag
     , loan_junk_dim_new_records.secondary_clear_to_commit_flag
     , loan_junk_dim_new_records.qm_eligible_flag
     , loan_junk_dim_new_records.hpml_flag
     , loan_junk_dim_new_records.lien_priority_code
     , loan_junk_dim_new_records.buydown_contributor_code
     , loan_junk_dim_new_records.qualifying_rate_code
     , loan_junk_dim_new_records.fha_program_code
     , loan_junk_dim_new_records.fha_principal_write_down_flag
     , loan_junk_dim_new_records.texas_equity_code
     , loan_junk_dim_new_records.texas_equity_auto_code
     , loan_junk_dim_new_records.hmda_hoepa_status_code
     , loan_junk_dim_new_records.lqa_purchase_eligibility
     , loan_junk_dim_new_records.mi_required_flag
     , loan_junk_dim_new_records.qualified_mortgage_status
     , loan_junk_dim_new_records.qualifying_rate
     , loan_junk_dim_new_records.texas_equity_auto
     , loan_junk_dim_new_records.texas_equity
     , loan_junk_dim_new_records.piggyback_flag
FROM (
    SELECT ''buydown_contributor'' || ''~'' || ''fha_program'' || ''~'' || ''hmda_hoepa_status'' || ''~'' || ''lien_priority'' || ''~'' ||
           ''lender_concession_candidate_flag'' || ''~'' || ''durp_eligibility_opt_out_flag'' || ''~'' || ''qualified_mortgage_status_code'' || ''~'' ||
           ''qualified_mortgage_flag'' || ''~'' || ''lqa_purchase_eligibility_code'' || ''~'' || ''student_loan_cash_out_refinance_flag'' || ''~'' ||
           ''secondary_clear_to_commit_flag'' || ''~'' || ''qm_eligible_flag'' || ''~'' || ''hpml_flag'' || ''~'' || ''lien_priority_code'' || ''~'' ||
           ''buydown_contributor_code'' || ''~'' || ''qualifying_rate_code'' || ''~'' || ''fha_program_code'' || ''~'' ||
           ''fha_principal_write_down_flag'' ||
           ''~'' || ''texas_equity_code'' || ''~'' || ''texas_equity_auto_code'' || ''~'' || ''hmda_hoepa_status_code'' || ''~'' ||
           ''lqa_purchase_eligibility'' || ''~'' || ''mi_required_flag'' || ''~'' || ''qualified_mortgage_status'' || ''~'' || ''qualifying_rate'' ||
           ''~'' ||
           ''texas_equity_auto'' || ''~'' || ''texas_equity'' || ''~'' || ''piggyback_flag'' || ''~'' ||
           ''data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( t460.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t462.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t463.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t467.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_lender_concession_candidate AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_durp_eligibility_opt_out AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_qualified_mortgage_status_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_qualified_mortgage AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_lqa_purchase_eligibility_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_student_loan_cash_out_refinance AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_secondary_clear_to_commit AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_qm_eligible AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_hpml AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_lien_priority_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_buydown_contributor_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_qualifying_rate_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_fha_program_code_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_fha_principal_write_down AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_texas_equity AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_texas_equity_auto AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_hmda_hoepa_status_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t469.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t1317.prp_mi_required AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t481.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t482.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t484.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t483.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( CASE
                               WHEN primary_table.l_lien_priority_type IS NULL OR t1317.prp_structure_type IS NULL THEN NULL
                               WHEN primary_table.l_lien_priority_type = ''FIRST'' OR t1317.prp_structure_type = ''STANDALONE_2ND'' THEN FALSE
                               ELSE TRUE END AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( primary_table.data_source_updated_datetime ) AS data_source_modified_datetime
         , t460.value AS buydown_contributor
         , t462.value AS fha_program
         , t463.value AS hmda_hoepa_status
         , t467.value AS lien_priority
         , primary_table.l_lender_concession_candidate AS lender_concession_candidate_flag
         , primary_table.l_durp_eligibility_opt_out AS durp_eligibility_opt_out_flag
         , primary_table.l_qualified_mortgage_status_type AS qualified_mortgage_status_code
         , primary_table.l_qualified_mortgage AS qualified_mortgage_flag
         , primary_table.l_lqa_purchase_eligibility_type AS lqa_purchase_eligibility_code
         , primary_table.l_student_loan_cash_out_refinance AS student_loan_cash_out_refinance_flag
         , primary_table.l_secondary_clear_to_commit AS secondary_clear_to_commit_flag
         , primary_table.l_qm_eligible AS qm_eligible_flag
         , primary_table.l_hpml AS hpml_flag
         , primary_table.l_lien_priority_type AS lien_priority_code
         , primary_table.l_buydown_contributor_type AS buydown_contributor_code
         , primary_table.l_qualifying_rate_type AS qualifying_rate_code
         , primary_table.l_fha_program_code_type AS fha_program_code
         , primary_table.l_fha_principal_write_down AS fha_principal_write_down_flag
         , primary_table.l_texas_equity AS texas_equity_code
         , primary_table.l_texas_equity_auto AS texas_equity_auto_code
         , primary_table.l_hmda_hoepa_status_type AS hmda_hoepa_status_code
         , t469.value AS lqa_purchase_eligibility
         , t1317.prp_mi_required AS mi_required_flag
         , t481.value AS qualified_mortgage_status
         , t482.value AS qualifying_rate
         , t484.value AS texas_equity_auto
         , t483.value AS texas_equity
         , CASE
               WHEN primary_table.l_lien_priority_type IS NULL OR t1317.prp_structure_type IS NULL THEN NULL
               WHEN primary_table.l_lien_priority_type = ''FIRST'' OR t1317.prp_structure_type = ''STANDALONE_2ND'' THEN FALSE
               ELSE TRUE END AS piggyback_flag
    FROM (
        SELECT <<loan_partial_load_condition>> AS include_record
             , loan.*
        FROM history_octane.loan
        LEFT JOIN history_octane.loan AS history_records
                  ON loan.l_pid = history_records.l_pid
                      AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.l_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<buydown_contributor_type_partial_load_condition>> AS include_record
                 , buydown_contributor_type.*
            FROM history_octane.buydown_contributor_type
            LEFT JOIN history_octane.buydown_contributor_type AS history_records
                      ON buydown_contributor_type.code = history_records.code
                          AND buydown_contributor_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t460
               ON primary_table.l_buydown_contributor_type = t460.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<fha_program_code_type_partial_load_condition>> AS include_record
                 , fha_program_code_type.*
            FROM history_octane.fha_program_code_type
            LEFT JOIN history_octane.fha_program_code_type AS history_records
                      ON fha_program_code_type.code = history_records.code
                          AND fha_program_code_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t462
               ON primary_table.l_fha_program_code_type = t462.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<hmda_hoepa_status_type_partial_load_condition>> AS include_record
                 , hmda_hoepa_status_type.*
            FROM history_octane.hmda_hoepa_status_type
            LEFT JOIN history_octane.hmda_hoepa_status_type AS history_records
                      ON hmda_hoepa_status_type.code = history_records.code
                          AND hmda_hoepa_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t463
               ON primary_table.l_hmda_hoepa_status_type = t463.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<lien_priority_type_partial_load_condition>> AS include_record
                 , lien_priority_type.*
            FROM history_octane.lien_priority_type
            LEFT JOIN history_octane.lien_priority_type AS history_records
                      ON lien_priority_type.code = history_records.code
                          AND lien_priority_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t467
               ON primary_table.l_lien_priority_type = t467.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<lqa_purchase_eligibility_type_partial_load_condition>> AS include_record
                 , lqa_purchase_eligibility_type.*
            FROM history_octane.lqa_purchase_eligibility_type
            LEFT JOIN history_octane.lqa_purchase_eligibility_type AS history_records
                      ON lqa_purchase_eligibility_type.code = history_records.code
                          AND lqa_purchase_eligibility_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t469
               ON primary_table.l_lqa_purchase_eligibility_type = t469.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT proposal.*
            FROM history_octane.proposal
            LEFT JOIN history_octane.proposal AS history_records
                      ON proposal.prp_pid = history_records.prp_pid
                          AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.prp_pid IS NULL
        ) AS primary_table

            -- child join start
        INNER JOIN
        (
            SELECT <<deal_partial_load_condition>> AS include_record
                 , deal.*
            FROM history_octane.deal
            LEFT JOIN history_octane.deal AS history_records
                      ON deal.d_pid = history_records.d_pid
                          AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.d_pid IS NULL
        ) AS t1441
        ON primary_table.prp_deal_pid = t1441.d_pid
        -- child join end

    ) AS t1317
               ON primary_table.l_proposal_pid = t1317.prp_pid

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<qualified_mortgage_status_type_partial_load_condition>> AS include_record
                 , qualified_mortgage_status_type.*
            FROM history_octane.qualified_mortgage_status_type
            LEFT JOIN history_octane.qualified_mortgage_status_type AS history_records
                      ON qualified_mortgage_status_type.code = history_records.code
                          AND qualified_mortgage_status_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t481
               ON primary_table.l_qualified_mortgage_status_type = t481.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<qualifying_rate_type_partial_load_condition>> AS include_record
                 , qualifying_rate_type.*
            FROM history_octane.qualifying_rate_type
            LEFT JOIN history_octane.qualifying_rate_type AS history_records
                      ON qualifying_rate_type.code = history_records.code
                          AND qualifying_rate_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t482
               ON primary_table.l_qualifying_rate_type = t482.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_na_type_partial_load_condition>> AS include_record
                 , yes_no_na_type.*
            FROM history_octane.yes_no_na_type
            LEFT JOIN history_octane.yes_no_na_type AS history_records
                      ON yes_no_na_type.code = history_records.code
                          AND yes_no_na_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t484
               ON primary_table.l_texas_equity_auto = t484.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<yes_no_unknown_type_partial_load_condition>> AS include_record
                 , yes_no_unknown_type.*
            FROM history_octane.yes_no_unknown_type
            LEFT JOIN history_octane.yes_no_unknown_type AS history_records
                      ON yes_no_unknown_type.code = history_records.code
                          AND yes_no_unknown_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t483
               ON primary_table.l_texas_equity = t483.code
        -- ignoring this because the table alias t1317 has already been added: INNER JOIN history_octane.proposal t1317 ON primary_table.l_proposal_pid = t1317.prp_pid
    WHERE GREATEST( primary_table.include_record, t460.include_record, t462.include_record, t463.include_record, t467.include_record,
                    t469.include_record, t1317.include_record, t481.include_record, t482.include_record, t484.include_record,
                    t483.include_record ) IS TRUE
    GROUP BY t460.value, t462.value, t463.value, t467.value, primary_table.l_lender_concession_candidate
           , primary_table.l_durp_eligibility_opt_out, primary_table.l_qualified_mortgage_status_type, primary_table.l_qualified_mortgage
           , primary_table.l_lqa_purchase_eligibility_type, primary_table.l_student_loan_cash_out_refinance
           , primary_table.l_secondary_clear_to_commit, primary_table.l_qm_eligible, primary_table.l_hpml
           , primary_table.l_lien_priority_type, primary_table.l_buydown_contributor_type, primary_table.l_qualifying_rate_type
           , primary_table.l_fha_program_code_type, primary_table.l_fha_principal_write_down, primary_table.l_texas_equity
           , primary_table.l_texas_equity_auto, primary_table.l_hmda_hoepa_status_type, t469.value, t1317.prp_mi_required, t481.value
           , t482.value, t484.value, t483.value
           , CASE
                 WHEN primary_table.l_lien_priority_type IS NULL OR t1317.prp_structure_type IS NULL
                     THEN NULL
                 WHEN primary_table.l_lien_priority_type = ''FIRST'' OR
                      t1317.prp_structure_type = ''STANDALONE_2ND'' THEN FALSE
                 ELSE TRUE END
) AS loan_junk_dim_new_records
LEFT JOIN star_loan.loan_junk_dim
          ON loan_junk_dim.data_source_integration_id = loan_junk_dim_new_records.data_source_integration_id
WHERE loan_junk_dim.dwid IS NULL
;'
FROM mdi.process
WHERE table_input_step.process_dwid = process.dwid
  AND process.name = 'SP-200014';

--product_choice_dim
UPDATE mdi.table_input_step
SET sql = 'SELECT product_choice_dim_new_records.data_source_integration_columns
     , product_choice_dim_new_records.data_source_integration_id
     , product_choice_dim_new_records.edw_created_datetime
     , product_choice_dim_new_records.edw_modified_datetime
     , product_choice_dim_new_records.data_source_modified_datetime
     , product_choice_dim_new_records.aus
     , product_choice_dim_new_records.buydown_schedule
     , product_choice_dim_new_records.interest_only
     , product_choice_dim_new_records.aus_code
     , product_choice_dim_new_records.prepay_penalty_schedule
     , product_choice_dim_new_records.buydown_schedule_code
     , product_choice_dim_new_records.interest_only_code
     , product_choice_dim_new_records.mortgage_type_code
     , product_choice_dim_new_records.mortgage_type
     , product_choice_dim_new_records.prepay_penalty_schedule
FROM (
    SELECT ''aus'' || ''~'' || ''buydown_schedule'' || ''~'' || ''interest_only'' || ''~'' || ''aus_code'' || ''~'' || ''prepay_penatly_schedule_code'' ||
           ''~'' || ''buydown_schedule_code'' || ''~'' || ''interest_only_code'' || ''~'' || ''mortgage_type_code'' || ''~'' || ''mortgage_type'' || ''~'' ||
           ''prepay_penalty_schedule'' || ''~'' || ''data_source_dwid'' AS data_source_integration_columns
         , COALESCE( CAST( t459.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t461.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t466.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_aus_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_prepay_penalty_schedule_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_buydown_schedule_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_interest_only_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.l_mortgage_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t479.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t480.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( primary_table.data_source_updated_datetime ) AS data_source_modified_datetime
         , t459.value AS aus
         , t461.value AS buydown_schedule
         , t466.value AS interest_only
         , primary_table.l_aus_type AS aus_code
         , primary_table.l_prepay_penalty_schedule_type AS prepay_penatly_schedule_code
         , primary_table.l_buydown_schedule_type AS buydown_schedule_code
         , primary_table.l_interest_only_type AS interest_only_code
         , primary_table.l_mortgage_type AS mortgage_type_code
         , t479.value AS mortgage_type
         , t480.value AS prepay_penalty_schedule
    FROM (
        SELECT <<loan_partial_load_condition>> AS include_record
             , loan.*
        FROM history_octane.loan
        LEFT JOIN history_octane.loan AS history_records
                  ON loan.l_pid = history_records.l_pid
                      AND loan.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.l_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<aus_type_partial_load_condition>> AS include_record
                 , aus_type.*
            FROM history_octane.aus_type
            LEFT JOIN history_octane.aus_type AS history_records
                      ON aus_type.code = history_records.code
                          AND aus_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t459
               ON primary_table.l_aus_type = t459.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<buydown_schedule_type_partial_load_condition>> AS include_record
                 , buydown_schedule_type.*
            FROM history_octane.buydown_schedule_type
            LEFT JOIN history_octane.buydown_schedule_type AS history_records
                      ON buydown_schedule_type.code = history_records.code
                          AND buydown_schedule_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t461
               ON primary_table.l_buydown_schedule_type = t461.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<interest_only_type_partial_load_condition>> AS include_record
                 , interest_only_type.*
            FROM history_octane.interest_only_type
            LEFT JOIN history_octane.interest_only_type AS history_records
                      ON interest_only_type.code = history_records.code
                          AND interest_only_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t466
               ON primary_table.l_interest_only_type = t466.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<mortgage_type_partial_load_condition>> AS include_record
                 , mortgage_type.*
            FROM history_octane.mortgage_type
            LEFT JOIN history_octane.mortgage_type AS history_records
                      ON mortgage_type.code = history_records.code
                          AND mortgage_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t479
               ON primary_table.l_mortgage_type = t479.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<prepay_penalty_schedule_type_partial_load_condition>> AS include_record
                 , prepay_penalty_schedule_type.*
            FROM history_octane.prepay_penalty_schedule_type
            LEFT JOIN history_octane.prepay_penalty_schedule_type AS history_records
                      ON prepay_penalty_schedule_type.code = history_records.code
                          AND prepay_penalty_schedule_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t480
               ON primary_table.l_prepay_penalty_schedule_type = t480.code
    WHERE GREATEST( primary_table.include_record, t459.include_record, t461.include_record, t466.include_record, t479.include_record,
                    t480.include_record ) IS TRUE
    GROUP BY t459.value, t461.value, t466.value, primary_table.l_aus_type, primary_table.l_prepay_penalty_schedule_type
           , primary_table.l_buydown_schedule_type, primary_table.l_interest_only_type, primary_table.l_mortgage_type, t479.value
           , t480.value
) AS product_choice_dim_new_records
LEFT JOIN star_loan.product_choice_dim
          ON product_choice_dim.data_source_integration_id = product_choice_dim_new_records.data_source_integration_id
WHERE product_choice_dim.dwid IS NULL
;'
FROM mdi.process
WHERE table_input_step.process_dwid = process.dwid
  AND process.name = 'SP-200016';

--transaction_junk_dim
UPDATE mdi.table_input_step
SET sql = 'SELECT transaction_junk_dim_new_records.data_source_integration_columns
     , transaction_junk_dim_new_records.data_source_integration_id
     , transaction_junk_dim_new_records.edw_created_datetime
     , transaction_junk_dim_new_records.edw_created_datetime
     , transaction_junk_dim_new_records.data_source_modified_datetime
     , transaction_junk_dim_new_records.is_test_loan_flag
     , transaction_junk_dim_new_records.loan_purpose
     , transaction_junk_dim_new_records.structure_code
     , transaction_junk_dim_new_records.mi_required_flag
     , transaction_junk_dim_new_records.loan_purpose_code
     , transaction_junk_dim_new_records.structure
     , transaction_junk_dim_new_records.piggyback_flag
FROM (
    SELECT ''is_test_loan_flag'' || ''~'' || ''loan_purpose'' || ''~'' || ''structure_code'' || ''~'' || ''mi_required_flag'' || ''~'' ||
           ''loan_purpose_code'' || ''~'' || ''structure'' || ''~'' || ''data_source_dwid'' || ''~'' || ''piggyback_flag'' AS data_source_integration_columns
         , COALESCE( CAST( t1441.d_test_loan AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t649.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.prp_structure_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.prp_mi_required AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( t661.value AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.prp_loan_purpose_type AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( 1 AS TEXT ), ''<NULL>'' ) || ''~'' ||
           COALESCE( CAST( primary_table.prp_structure_type = ''COMBO'' AS TEXT ), ''<NULL>'' ) AS data_source_integration_id
         , NOW( ) AS edw_created_datetime
         , NOW( ) AS edw_modified_datetime
         , MAX( primary_table.data_source_updated_datetime ) AS data_source_modified_datetime
         , t1441.d_test_loan AS is_test_loan_flag
         , t649.value AS loan_purpose
         , primary_table.prp_structure_type AS structure_code
         , primary_table.prp_mi_required AS mi_required_flag
         , primary_table.prp_loan_purpose_type AS loan_purpose_code
         , t661.value AS structure
         , primary_table.prp_structure_type = ''COMBO'' AS piggyback_flag
    FROM (
        SELECT <<proposal_partial_load_condition>> AS include_record
             , proposal.*
        FROM history_octane.proposal
        LEFT JOIN history_octane.proposal AS history_records
                  ON proposal.prp_pid = history_records.prp_pid
                      AND proposal.data_source_updated_datetime < history_records.data_source_updated_datetime
        WHERE history_records.prp_pid IS NULL
    ) AS primary_table

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<deal_partial_load_condition>> AS include_record
                 , deal.*
            FROM history_octane.deal
            LEFT JOIN history_octane.deal AS history_records
                      ON deal.d_pid = history_records.d_pid
                          AND deal.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.d_pid IS NULL
        ) AS primary_table
    ) AS t1441
               ON primary_table.prp_deal_pid = t1441.d_pid

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<loan_purpose_type_partial_load_condition>> AS include_record
                 , loan_purpose_type.*
            FROM history_octane.loan_purpose_type
            LEFT JOIN history_octane.loan_purpose_type AS history_records
                      ON loan_purpose_type.code = history_records.code
                          AND loan_purpose_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t649
               ON primary_table.prp_loan_purpose_type = t649.code

    INNER JOIN (
        SELECT *
        FROM (
            SELECT <<proposal_structure_type_partial_load_condition>> AS include_record
                 , proposal_structure_type.*
            FROM history_octane.proposal_structure_type
            LEFT JOIN history_octane.proposal_structure_type AS history_records
                      ON proposal_structure_type.code = history_records.code
                          AND proposal_structure_type.data_source_updated_datetime < history_records.data_source_updated_datetime
            WHERE history_records.code IS NULL
        ) AS primary_table
    ) AS t661
               ON primary_table.prp_structure_type = t661.code
    WHERE GREATEST( primary_table.include_record, t1441.include_record, t649.include_record, t661.include_record ) IS TRUE
    GROUP BY t1441.d_test_loan, primary_table.prp_structure_type, primary_table.prp_mi_required, t661.value
           , primary_table.prp_structure_type, t649.value, primary_table.prp_loan_purpose_type
) AS transaction_junk_dim_new_records
LEFT JOIN star_loan.transaction_junk_dim
          ON transaction_junk_dim.data_source_integration_id = transaction_junk_dim_new_records.data_source_integration_id
WHERE transaction_junk_dim.dwid IS NULL;'
FROM mdi.process
WHERE table_input_step.process_dwid = process.dwid
  AND process.name = 'SP-200020';

--fix metadata for transaction_junk_dim.loan_purpose and transaction_junk_dim.loan_purpose_code
UPDATE mdi.edw_field_definition
SET key_field_flag = TRUE
FROM mdi.edw_table_definition
WHERE edw_table_definition.dwid = edw_field_definition.edw_table_definition_dwid
  AND edw_table_definition.schema_name = 'star_loan'
  AND edw_table_definition.table_name = 'transaction_junk_dim'
  AND edw_field_definition.field_name IN ('loan_purpose', 'loan_purpose_code');
